// ws_server.js — EBYS WebSocket bridge (no external dependencies)
// Uses Node.js built-in http + manual WebSocket handshake (RFC 6455)

const Max    = require('max-api');
const http   = require('http');
const crypto = require('crypto');
const fs     = require('fs');
const path   = require('path');
const { spawn } = require('child_process');

const PORT = 8080;

// ── State cache ───────────────────────────────────────────────────────────────
const state = {
    running:      false,
    track:        'no track loaded',
    bpm:          0,
    globalBPM:    0,       // override from :setGlobalBPM (0 = use analyzed BPM)
    key:          '?',
    slices:       [0, 0, 0, 0],
    analysisDone: false,   // set true when analysisDone arrives (or library already exists)
    ms: {
        width:    { vocals: 0, melody: 0, bass: 0, drums: 0 },
        pan:      { vocals: 0, melody: 0, bass: 0, drums: 0 },
        fxSend:   0,
        fxReturn: 0,
    },
    recording:     false,
    recordingFile: null,
    stems: {
        vocals: { id: '--', pos: 0.0, C: 0, E: 0, F: 0, P: 0, H: 0, T: 0, track: '', slot: 0 },
        melody: { id: '--', pos: 0.0, C: 0, E: 0, F: 0, P: 0, H: 0, T: 0, track: '', slot: 0 },
        bass:   { id: '--', pos: 0.0, C: 0, E: 0, F: 0, P: 0, H: 0, T: 0, track: '', slot: 0 },
        drums:  { id: '--', pos: 0.0, C: 0, E: 0, F: 0, P: 0, H: 0, T: 0, track: '', slot: 0 },
    },
    // Tipping session
    segBars:     { vocals: 4, melody: 4, bass: 4, drums: 4 },
    sessionId:   null,
    sessionDeck: 'ebys',  // 'ebys' | 'direct' — direct = no pings, no slice logging
};

// ── Tipping backend ──────────────────────────────────────────────────────────
const TIPPING_URL = 'http://localhost:3000';

// Count how many distinct source tracks are playing simultaneously across the 4 stems.
// Each stem carries a slot index (0 = first alphabetical track, 1 = second, etc.)
// Unique slot count = simultaneousN for the split equation.
function computeSimultaneousN() {
    const slots = new Set();
    for (const track of ['vocals', 'melody', 'bass', 'drums']) {
        const s = state.stems[track];
        if (s && s.slot !== undefined) slots.add(s.slot);
    }
    return slots.size || 1;
}

async function pingBackend() {
    if (!state.sessionId) return;
    if (state.sessionDeck === 'direct') return;  // no pings in direct mode
    const simultaneousN = computeSimultaneousN();
    const segVoc = state.segBars.vocals || 4;
    const segMel = state.segBars.melody || 4;
    const segBas = state.segBars.bass   || 4;
    const segDrm = state.segBars.drums  || 4;
    const segMean = (segVoc + segMel + segBas + segDrm) / 4;
    const segVariance = [(segVoc - segMean), (segMel - segMean), (segBas - segMean), (segDrm - segMean)]
        .reduce((s, d) => s + d * d, 0) / 4;
    try {
        const res = await fetch(`${TIPPING_URL}/slices/ping`, {
            method:  'POST',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify({ sessionId: state.sessionId, simultaneousN, segVoc, segMel, segBas, segDrm, segVariance }),
        });
        if (!res.ok) Max.post('ws_server: ping failed — ' + res.status + '\n');
    } catch(e) {
        Max.post('ws_server: ping error — ' + e.message + '\n');
    }
}

let pingTimer = null;
function updatePingTimer() {
    if (pingTimer) { clearInterval(pingTimer); pingTimer = null; }
    if (!state.sessionId || state.sessionDeck === 'direct') return;
    const bpm      = state.globalBPM > 0 ? state.globalBPM : (state.bpm || 120);
    const interval = Math.round((4 * 4 * 60000) / bpm);
    pingTimer      = setInterval(pingBackend, interval);
    Max.post('ws_server: ping every ' + interval + 'ms (BPM=' + bpm + ')\n');
}

// Pre-check: if analysis_library.json already has entries, mark analysisDone now so
// new TUI clients that connect after the patch loads get the flag immediately.
try {
    const lib = parseMaxDictJSON(fs.readFileSync(path.join(__dirname, 'analysis_library.json'), 'utf8'));
    if (Object.keys(lib).length > 0) {
        state.analysisDone = true;
        Max.post('ws_server: library present — analysisDone pre-set\n');
    }
} catch(e) { /* no library yet — that's fine */ }

const clients = new Set();

// ── Chunk stream helpers ──────────────────────────────────────────────────────
// Every chunked send gets a unique streamId so receivers can detect interleaving.
// Format: label  streamId  chunkIndex  totalChunks  data
let chunkStreamCounter = 0;
function sendChunked(label, str, chunkSize) {
    chunkSize = chunkSize || 2048;
    const sid   = ++chunkStreamCounter;
    const total = Math.ceil(str.length / chunkSize);
    for (let i = 0; i < total; i++) {
        Max.outlet(label, sid, i, total, str.substring(i * chunkSize, (i + 1) * chunkSize));
    }
    return { sid, total };
}

// ── WebSocket frame helpers ───────────────────────────────────────────────────

function encodeFrame(data) {
    const payload = Buffer.from(data, 'utf8');
    const len = payload.length;
    let header;
    if (len < 126) {
        header = Buffer.alloc(2);
        header[0] = 0x81; // FIN + text frame
        header[1] = len;
    } else if (len < 65536) {
        header = Buffer.alloc(4);
        header[0] = 0x81;
        header[1] = 126;
        header.writeUInt16BE(len, 2);
    } else {
        header = Buffer.alloc(10);
        header[0] = 0x81;
        header[1] = 127;
        header.writeBigUInt64BE(BigInt(len), 2);
    }
    return Buffer.concat([header, payload]);
}

function decodeFrames(buf) {
    const messages = [];
    let offset = 0;
    while (offset < buf.length) {
        if (offset + 2 > buf.length) break;
        const b1 = buf[offset];
        const b2 = buf[offset + 1];
        const opcode = b1 & 0x0f;
        const masked  = (b2 & 0x80) !== 0;
        let payloadLen = b2 & 0x7f;
        let headerLen = 2;
        if (payloadLen === 126) {
            if (offset + 4 > buf.length) break;
            payloadLen = buf.readUInt16BE(offset + 2);
            headerLen = 4;
        } else if (payloadLen === 127) {
            if (offset + 10 > buf.length) break;
            payloadLen = Number(buf.readBigUInt64BE(offset + 2));
            headerLen = 10;
        }
        const maskOffset = offset + headerLen;
        const dataOffset = maskOffset + (masked ? 4 : 0);
        if (dataOffset + payloadLen > buf.length) break;
        if (opcode === 8) { messages.push(null); offset = dataOffset + payloadLen; break; } // close
        if (opcode === 0x9) { // ping
            offset = dataOffset + payloadLen; continue;
        }
        const raw = buf.slice(dataOffset, dataOffset + payloadLen);
        let payload;
        if (masked) {
            const mask = buf.slice(maskOffset, maskOffset + 4);
            payload = Buffer.alloc(payloadLen);
            for (let i = 0; i < payloadLen; i++) payload[i] = raw[i] ^ mask[i % 4];
        } else {
            payload = raw;
        }
        messages.push(payload.toString('utf8'));
        offset = dataOffset + payloadLen;
    }
    // Return both messages and how many bytes were consumed so the caller can trim the buffer
    return { messages, consumed: offset };
}

// ── HTTP server + WebSocket upgrade ──────────────────────────────────────────

const server = http.createServer((req, res) => {
    // POST /progress — watch_demucs.py sends Demucs progress here; we broadcast to TUI
    if (req.method === 'POST' && req.url === '/progress') {
        let body = '';
        req.on('data', chunk => { body += chunk; });
        req.on('end', () => {
            try { broadcast(JSON.parse(body)); } catch(e) {}
            res.writeHead(200); res.end('ok');
        });
        return;
    }
    res.writeHead(200); res.end('EBYS ws_server');
});

server.on('upgrade', (req, socket) => {
    const key = req.headers['sec-websocket-key'];
    if (!key) { socket.destroy(); return; }
    const accept = crypto.createHash('sha1')
        .update(key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11')
        .digest('base64');
    socket.write(
        'HTTP/1.1 101 Switching Protocols\r\n' +
        'Upgrade: websocket\r\n' +
        'Connection: Upgrade\r\n' +
        'Sec-WebSocket-Accept: ' + accept + '\r\n\r\n'
    );
    clients.add(socket);
    Max.post('ws_server: TUI connected (' + clients.size + ')\n');

    // Send operational state snapshot on connect — match the shape of all other
    // 'state' broadcasts (no stems: TUI has its own defaults and they must not be
    // overwritten by ws_server's thin stem objects which lack stay/bars/S/etc.)
    socket.write(encodeFrame(JSON.stringify({
        type: 'state',
        running: state.running,
        track:   state.track,
        bpm:     state.bpm,
        key:     state.key,
        slices:  state.slices,
    })));
    // NOTE: do NOT send analysisDone here. analysisDone means "a fresh analysis just
    // completed this session" — it triggers add_tension.py + buildIndex in the TUI.
    // Sending it on every reconnect caused a second buildIndex on every boot.

    let buf = Buffer.alloc(0);
    socket.on('data', chunk => {
        buf = Buffer.concat([buf, chunk]);
        const { messages, consumed } = decodeFrames(buf);
        buf = buf.slice(consumed); // trim processed bytes so old frames aren't replayed
        messages.forEach(msg => {
            if (msg === null) { socket.destroy(); return; }
            try {
                const m = JSON.parse(msg);

                // :bake — save training snapshot (intent + Cricket cmds + user corrections + live state)
                if (m.type === 'bake') {
                    const snapshot = {
                        timestamp:        new Date().toISOString(),
                        intent:           m.intent           || '',
                        cricket_cmds:     m.cricket_cmds     || [],
                        user_corrections: m.user_corrections || [],
                        final_cmds:       m.final_cmds       || [],
                        track:            state.track,
                        bpm:              state.bpm,
                        stems:            JSON.parse(JSON.stringify(state.stems)),
                    };
                    const logPath = path.join(__dirname, '..', 'training_log.jsonl');
                    fs.appendFileSync(logPath, JSON.stringify(snapshot) + '\n');
                    Max.post('ws_server: 🫳 baked\n');
                    broadcast({ type: 'sys', msg: '🫳 baked' });
                    return;
                }

                if (m.type === 'command' && m.text) {
                    const parts = m.text.trim().split(/\s+/);
                    const atoms = parts.map(p => isNaN(p) ? p : parseFloat(p));
                    if (atoms[0] === 'sessionOpen') {
                        // :sessionOpen <djId> <venue> <mode: web|venue> [deck: ebys|direct]
                        const djId  = String(atoms[1] || '1');
                        const venue = String(atoms[2] || 'unknown');
                        const mode  = String(atoms[3] || 'venue');
                        const deck  = String(atoms[4] || 'ebys');
                        try {
                            const res  = await fetch(`${TIPPING_URL}/slices/session/open`, {
                                method:  'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body:    JSON.stringify({ djId, venue, mode, deck }),
                            });
                            const data = await res.json();
                            state.sessionId   = data.sessionId;
                            state.sessionDeck = deck;
                            const deckLabel = deck === 'direct' ? ' [direct]' : ' [ebys]';
                            broadcast({ type: 'sys', msg: '✓ session ' + state.sessionId + ' open (' + mode + ')' + deckLabel });
                            Max.post('ws_server: session opened — id=' + state.sessionId + ' deck=' + deck + '\n');
                            updatePingTimer();  // no-op in direct mode
                        } catch(e) {
                            broadcast({ type: 'sys', msg: '✗ sessionOpen failed — ' + e.message });
                        }
                        return;
                    } else if (atoms[0] === 'sessionClose') {
                        // :sessionClose
                        if (!state.sessionId) { broadcast({ type: 'sys', msg: '✗ no active session' }); return; }
                        try {
                            await fetch(`${TIPPING_URL}/slices/session/close`, {
                                method:  'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body:    JSON.stringify({ sessionId: state.sessionId }),
                            });
                            broadcast({ type: 'sys', msg: '✓ session ' + state.sessionId + ' closed' });
                            Max.post('ws_server: session closed — id=' + state.sessionId + '\n');
                            state.sessionId   = null;
                            state.sessionDeck = 'ebys';
                            if (pingTimer) { clearInterval(pingTimer); pingTimer = null; }
                        } catch(e) {
                            broadcast({ type: 'sys', msg: '✗ sessionClose failed — ' + e.message });
                        }
                        return;
                    } else if (atoms[0] === 'pitchShift') {
                        // :pitchShift <stem> <semitones>
                        // stem = vocals | melody | bass | drums | all
                        // semitones = positive (up) or negative (down), e.g. 3 or -2
                        const stem      = String(atoms[1] || 'all');
                        const semitones = parseFloat(atoms[2]) || 0;
                        broadcast({ type: 'param', key: 'pitchShift', stem, semitones });
                        Max.outlet('pitchShift', stem, semitones);
                    } else if (atoms[0] === 'width') {
                        // :width <stem> <0–1>  — M/S stereo width (0=mono, 1=full wide)
                        // stem = vocals | melody | bass | drums | all
                        const stem  = String(atoms[1] || 'all');
                        const value = Math.max(0, Math.min(1, parseFloat(atoms[2]) || 0));
                        const targets = stem === 'all' ? ['vocals','melody','bass','drums'] : [stem];
                        targets.forEach(s => { if (state.ms.width.hasOwnProperty(s)) state.ms.width[s] = value; });
                        broadcast({ type: 'param', key: 'width', stem, value });
                        Max.outlet('width', stem, value);
                    } else if (atoms[0] === 'pan') {
                        // :pan <stem> <-1–+1>  — stereo pan (-1=left, 0=center, +1=right)
                        const stem  = String(atoms[1] || 'all');
                        const value = Math.max(-1, Math.min(1, parseFloat(atoms[2]) || 0));
                        const targets = stem === 'all' ? ['vocals','melody','bass','drums'] : [stem];
                        targets.forEach(s => { if (state.ms.pan.hasOwnProperty(s)) state.ms.pan[s] = value; });
                        broadcast({ type: 'param', key: 'pan', stem, value });
                        Max.outlet('pan', stem, value);
                    } else if (atoms[0] === 'fxSend') {
                        // :fxSend <0–1>  — send level to dac~ 3 4 (hardware FX loop)
                        const value = Math.max(0, Math.min(1, parseFloat(atoms[1]) || 0));
                        state.ms.fxSend = value;
                        broadcast({ type: 'param', key: 'fxSend', value });
                        Max.outlet('fxSend', value);
                    } else if (atoms[0] === 'fxReturn') {
                        // :fxReturn <0–1>  — return level from adc~ 3 4 to main mix
                        const value = Math.max(0, Math.min(1, parseFloat(atoms[1]) || 0));
                        state.ms.fxReturn = value;
                        broadcast({ type: 'param', key: 'fxReturn', value });
                        Max.outlet('fxReturn', value);
                    } else if (atoms[0] === 'fxStereo') {
                        // :fxStereo 0 | 1 | on | off
                        // 0/off = mono pedal chain (default)
                        // 1/on  = stereo pedal chain (dac~ 3+4 carry L/R, adc~ 3+4 return L/R)
                        const val = String(atoms[1] || '0');
                        broadcast({ type: 'param', key: 'fxStereo', value: val });
                        Max.outlet('fxStereo', val);
                    } else if (atoms[0] === 'eqLow') {
                        // :eqLow <stem|all> <dB>   — low shelf gain (-96 = kill, +12 = boost)
                        const stem  = String(atoms[1] || 'all');
                        const db    = parseFloat(atoms[2]) || 0;
                        broadcast({ type: 'param', key: 'eqLow', stem, value: db });
                        Max.outlet('eqLow', stem, db);
                    } else if (atoms[0] === 'eqMid') {
                        // :eqMid <stem|all> <dB>   — mid bell gain
                        const stem  = String(atoms[1] || 'all');
                        const db    = parseFloat(atoms[2]) || 0;
                        broadcast({ type: 'param', key: 'eqMid', stem, value: db });
                        Max.outlet('eqMid', stem, db);
                    } else if (atoms[0] === 'eqHigh') {
                        // :eqHigh <stem|all> <dB>  — high shelf gain
                        const stem  = String(atoms[1] || 'all');
                        const db    = parseFloat(atoms[2]) || 0;
                        broadcast({ type: 'param', key: 'eqHigh', stem, value: db });
                        Max.outlet('eqHigh', stem, db);
                    } else if (atoms[0] === 'trim') {
                        // :trim <stem|all> <dB>    — input gain before EQ (-12 to +12 dB)
                        const stem  = String(atoms[1] || 'all');
                        const db    = parseFloat(atoms[2]) || 0;
                        broadcast({ type: 'param', key: 'trim', stem, value: db });
                        Max.outlet('trim', stem, db);
                    } else if (atoms[0] === 'analysisMode') {
                        // :analysisMode on | off
                        // on  = slicer auto-drives pan/width per slice (default)
                        // off = manual :width / :pan override mode
                        const val = String(atoms[1] || 'on');
                        broadcast({ type: 'param', key: 'analysisMode', value: val });
                        Max.outlet('analysisMode', val);
                    } else if (atoms[0] === 'record') {
                        // :record start            — open timestamped file and begin recording
                        // :record stop             — stop and close file
                        // :record start <name>     — use custom filename (no spaces)
                        const sub = String(atoms[1] || 'start').toLowerCase();
                        if (sub === 'stop') {
                            Max.outlet('record_cmd', 'stop');
                            state.recording = false;
                            broadcast({ type: 'param', key: 'recording', value: false });
                            Max.post('ws_server: recording stopped\n');
                        } else {
                            // Build filename: recordings/EBYS_YYYYMMDD_HHMMSS.wav
                            const customName = atoms[2] ? String(atoms[2]) : null;
                            const now  = new Date();
                            const pad  = n => String(n).padStart(2, '0');
                            const stamp = `${now.getFullYear()}${pad(now.getMonth()+1)}${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;
                            const fname = customName ? `${customName}.wav` : `EBYS_${stamp}.wav`;
                            const recDir  = path.join(__dirname, '..', 'recordings');
                            const recPath = path.join(recDir, fname);
                            try { fs.mkdirSync(recDir, { recursive: true }); } catch(e) {}
                            Max.outlet('record_cmd', 'open', recPath);
                            setTimeout(() => Max.outlet('record_cmd', 'start'), 50);
                            state.recording = true;
                            state.recordingFile = fname;
                            broadcast({ type: 'param', key: 'recording', value: true, file: fname });
                            Max.post(`ws_server: recording → ${recPath}\n`);
                        }
                    } else if (atoms[0] === 'buildIndex') {
                        if (buildIndexInProgress) {
                            Max.post('ws_server: buildIndex already running — skipping duplicate\n');
                            return;
                        }
                        buildIndexInProgress = true;
                        // Pre-populate the named dict from Node before triggering slicer.js,
                        // then run t-SNE in the background (no patch wiring needed).
                        prepareLibraryDict()
                            .then(() => {
                                Max.outlet(...atoms);
                                Max.post('ws_server: scheduling t-SNE in 500ms…\n');
                                setTimeout(() => {
                                    Max.post('ws_server: t-SNE timer fired\n');
                                    try { computeAndWriteUMAP(); }
                                    catch(e) {
                                        Max.post('ws_server: UMAP error: ' + String(e) + '\n');
                                        buildIndexInProgress = false;
                                    }
                                    // On success, buildIndexInProgress is reset inside
                                    // computeAndWriteUMAP's setImmediate, after umapDone broadcast.
                                }, 500);
                            })
                            .catch(e => {
                                Max.post('ws_server: library prep failed: ' + String(e) + '\n');
                                Max.outlet(...atoms);
                                buildIndexInProgress = false;
                            });
                    } else {
                        Max.outlet(...atoms);
                    }
                }  // end command
            } catch(e) {}
        });
    });

    socket.on('close', () => {
        clients.delete(socket);
        Max.post('ws_server: TUI disconnected (' + clients.size + ')\n');
    });

    socket.on('error', () => { clients.delete(socket); });
});

server.listen(PORT, () => {
    Max.post('ws_server: ready on port ' + PORT + '\n');
    Max.outlet('ws_ready');   // signals the patch to start the meter metro

    // Send downbeats.json before the cached index so loadDownbeats() finds data ready.
    // downbeatchunk goes out outlet 0 → route else [24] → slicer.js inlet 0.
    try {
        const dbStr = fs.readFileSync(path.join(__dirname, '..', 'downbeats.json'), 'utf8');
        const { sid, total } = sendChunked('downbeatchunk', dbStr);
        Max.post('ws_server: downbeats sent (stream ' + sid + ', ' + total + ' chunks)\n');
    } catch(e) {
        Max.post('ws_server: downbeats error — ' + e + '\n');
    }

    // Send cached index to slicer immediately so it's ready before TUI connects.
    // idxchunk goes out outlet 0 → route else [24] → slicer.js inlet 0.
    const idxPath = path.join(__dirname, 'ebys_index.json');
    try {
        const idxStr = fs.readFileSync(idxPath, 'utf8');
        JSON.parse(idxStr); // validate before sending — skip if file is corrupted/truncated
        Max.post('ws_server: sending cached index…\n');
        const { sid, total } = sendChunked('idxchunk', idxStr);
        Max.post('ws_server: cached index sent (stream ' + sid + ', ' + total + ' chunks)\n');
    } catch(e) {
        Max.post('ws_server: no cached index — will build on first connect\n');
    }
});

// ── Library dict pre-loader ───────────────────────────────────────────────────
// Max's JS Dict.readfromfile() is unavailable; instead we read the JSON in Node
// (no size limit) and push it into a named Max dict via Max.setDict().
// slicer.js then opens the same named dict — no file I/O in the JS object needed.
let cachedLibraryData = null;
let buildIndexInProgress = false;

// Max Dict JSON export uses `{}` as a preamble — byte 1 is `}` where standard JSON
// needs `"`. Fix: replace the leading `{}` with `{"` before parsing.
function parseMaxDictJSON(raw) {
    if (raw.charCodeAt(0) === 0x7b && raw.charCodeAt(1) === 0x7d) {
        raw = '{"' + raw.slice(2);
    }
    return JSON.parse(raw);
}

function prepareLibraryDict() {
    const libPath = path.join(__dirname, 'analysis_library.json');
    const raw  = fs.readFileSync(libPath, 'utf8');
    cachedLibraryData = parseMaxDictJSON(raw);

    // Max.setDict fails for large nested objects (>~1 MB), and Max's built-in
    // JsFile API is capped at 32 767 bytes — both too small for analysis_library.json.
    // Solution: send the JSON string to slicer.js in 2 KB chunks via Max outlet.
    // slicer.js accumulates libchunk messages and parses once all arrive.
    const jsonStr = JSON.stringify(cachedLibraryData);
    const { sid: libSid, total: libTotal } = sendChunked('libchunk', jsonStr);
    Max.post('ws_server: library sent (stream ' + libSid + ', ' + libTotal + ' chunks, ' + jsonStr.length + ' chars)\n');

    // Send genres.json the same way — slicer.js uses it to tag slices for genre filtering.
    try {
        const genresPath = path.join(__dirname, '..', 'genres.json');
        const genresStr  = fs.readFileSync(genresPath, 'utf8');
        const { sid: gSid, total: gTotal } = sendChunked('genrechunk', genresStr);
        Max.post('ws_server: genres sent (stream ' + gSid + ', ' + gTotal + ' chunks)\n');
    } catch(e) {
        Max.post('ws_server: genres.json not found — genre filtering unavailable\n');
    }

    return Promise.resolve();  // keep .then()/.catch() callers happy
}

// ── Node-side t-SNE (replaces fluid.umap~ — no patch wiring needed) ──────────

function runTSNE(features, opts) {
    opts = opts || {};
    const perplexity = Math.min(opts.perplexity || 30, Math.floor(features.length / 3));
    const nIter = opts.nIter || 250;
    const lr    = opts.lr    || 200;
    const n = features.length;
    const dim = features[0].length;

    if (n < 5) return features.map(() => [(Math.random()-0.5)*0.1, (Math.random()-0.5)*0.1]);

    // Normalise each dimension to [0,1]
    const mins = [], rngs = [];
    for (let j = 0; j < dim; j++) {
        let mn = Infinity, mx = -Infinity;
        for (let i = 0; i < n; i++) {
            if (features[i][j] < mn) mn = features[i][j];
            if (features[i][j] > mx) mx = features[i][j];
        }
        mins.push(mn); rngs.push(mx > mn ? mx - mn : 1);
    }
    const X = features.map(f => f.map((v, j) => (v - mins[j]) / rngs[j]));

    // Pairwise squared distances
    const D2 = Array.from({length: n}, (_, i) =>
        Array.from({length: n}, (_, j) => {
            if (i === j) return 0;
            let s = 0;
            for (let k = 0; k < dim; k++) { const d = X[i][k] - X[j][k]; s += d*d; }
            return s;
        })
    );

    // Conditional probabilities with perplexity-based bandwidth search
    const P = Array.from({length: n}, () => new Array(n).fill(0));
    const logPerp = Math.log(perplexity);
    for (let i = 0; i < n; i++) {
        let lo = -Infinity, hi = Infinity, beta = 1;
        for (let t = 0; t < 50; t++) {
            let sum = 0;
            for (let j = 0; j < n; j++) { if (i !== j) sum += Math.exp(-D2[i][j] * beta); }
            if (sum === 0) sum = 1e-10;
            let H = 0;
            for (let j = 0; j < n; j++) {
                if (i === j) continue;
                const p = Math.exp(-D2[i][j] * beta) / sum;
                if (p > 1e-12) H -= p * Math.log(p);
            }
            const diff = H - logPerp;
            if (Math.abs(diff) < 1e-5) break;
            if (diff > 0) { lo = beta; beta = hi === Infinity ? beta * 2 : (beta + hi) / 2; }
            else          { hi = beta; beta = lo === -Infinity ? beta / 2 : (beta + lo) / 2; }
        }
        let sum = 0;
        for (let j = 0; j < n; j++) { if (i !== j) sum += Math.exp(-D2[i][j] * beta); }
        if (sum === 0) sum = 1e-10;
        for (let j = 0; j < n; j++) P[i][j] = i === j ? 0 : Math.exp(-D2[i][j] * beta) / sum;
    }

    // Symmetrise P_ij = (P_i|j + P_j|i) / 2n, clipped for stability
    const Ps = Array.from({length: n}, (_, i) =>
        Array.from({length: n}, (_, j) => Math.max((P[i][j] + P[j][i]) / (2*n), 1e-12))
    );

    // Random init in low-D
    const Y     = Array.from({length: n}, () => [(Math.random()-0.5)*0.01, (Math.random()-0.5)*0.01]);
    const iY    = Array.from({length: n}, () => [0, 0]);
    const gains = Array.from({length: n}, () => [1, 1]);

    for (let iter = 0; iter < nIter; iter++) {
        const exag = iter < 100 ? 4 : 1;

        // Student-t kernel in low-D
        const num = Array.from({length: n}, (_, i) =>
            Array.from({length: n}, (_, j) => {
                if (i === j) return 0;
                const dx = Y[i][0]-Y[j][0], dy = Y[i][1]-Y[j][1];
                return 1 / (1 + dx*dx + dy*dy);
            })
        );
        let sumQ = 0;
        for (let i = 0; i < n; i++) for (let j = 0; j < n; j++) sumQ += num[i][j];
        if (sumQ === 0) sumQ = 1e-10;

        // Gradient
        const dY = Array.from({length: n}, () => [0, 0]);
        for (let i = 0; i < n; i++) {
            for (let j = 0; j < n; j++) {
                if (i === j) continue;
                const pq   = exag * Ps[i][j] - num[i][j] / sumQ;
                const mult = 4 * pq * num[i][j];
                dY[i][0] += mult * (Y[i][0] - Y[j][0]);
                dY[i][1] += mult * (Y[i][1] - Y[j][1]);
            }
        }

        // Update with momentum + adaptive gains
        const mom = iter < 20 ? 0.5 : 0.8;
        for (let i = 0; i < n; i++) {
            for (let k = 0; k < 2; k++) {
                const sameSign = (dY[i][k] > 0) === (iY[i][k] > 0);
                gains[i][k] = sameSign ? Math.max(0.01, gains[i][k] * 0.8) : gains[i][k] + 0.2;
                iY[i][k] = mom * iY[i][k] - lr * gains[i][k] * dY[i][k];
                Y[i][k] += iY[i][k];
            }
        }

        // Re-centre every 50 iters
        if (iter % 50 === 0) {
            let cx = 0, cy = 0;
            for (let i = 0; i < n; i++) { cx += Y[i][0]; cy += Y[i][1]; }
            cx /= n; cy /= n;
            for (let i = 0; i < n; i++) { Y[i][0] -= cx; Y[i][1] -= cy; }
        }
    }
    return Y;
}

function computeAndWriteUMAP() {
    const data = cachedLibraryData;
    if (!data) { Max.post('ws_server: UMAP skipped — no library cached\n'); return; }

    const SUFFIXES = { vocals:'_vocals.wav', melody:'_other.wav', bass:'_bass.wav', drums:'_drums.wav' };
    const topKeys  = Object.keys(data);

    // Build a list of filenames per stem — multi-track: multiple files share the same stem type.
    const stemFiles = { vocals: [], melody: [], bass: [], drums: [] };
    for (const k of topKeys) {
        const kl = k.toLowerCase();
        for (const s in SUFFIXES) {
            if (kl.includes(SUFFIXES[s])) { stemFiles[s].push(k); break; }
        }
    }

    // Extract features synchronously (fast) then hand off to child process
    // so t-SNE doesn't block the event loop (keeps WebSocket connections alive).
    const stems = [];
    const stemRanges = {};

    for (const stem of ['vocals','melody','bass','drums']) {
        const filenames = stemFiles[stem];
        if (!filenames.length) continue;

        const ids = [], features = [];
        const acc = {};
        for (const d of ['C','E','F','P','H']) acc[d] = { min: Infinity, max: -Infinity };
        acc['T'] = { min: Infinity, max: -Infinity };

        // Aggregate slices from ALL source tracks for this stem type.
        // Without this, only the last alphabetical track gets t-SNE coords.
        for (const filename of filenames) {
            const stemData = data[filename] && data[filename][stem];
            if (!stemData || !stemData.slices) continue;

            // Prefix slice IDs with filename to keep them unique across tracks.
            const trackKey = filename.replace(/[^a-zA-Z0-9]/g, '_');
            const sliceKeys = Object.keys(stemData.slices).filter(k => k.startsWith('slice_')).sort();

            for (const id of sliceKeys) {
                const sd = stemData.slices[id];
                const M1=parseFloat(sd.M1)||0, M2=parseFloat(sd.M2)||0, M3=parseFloat(sd.M3)||0;
                const M4=parseFloat(sd.M4)||0, M5=parseFloat(sd.M5)||0;
                const T = Math.sqrt((M1*M1+M2*M2+M3*M3+M4*M4+M5*M5)/5);
                ids.push(trackKey + '/' + id);
                features.push([
                    parseFloat(sd.C)||0,
                    parseFloat(sd.E)||-60,
                    parseFloat(sd.F)||0,
                    parseFloat(sd.P)||0,
                    parseFloat(sd.H)||0,
                    T
                ]);
                for (const d of ['C','E','F','P','H']) {
                    const v = parseFloat(sd[d]);
                    if (isFinite(v)) { if (v < acc[d].min) acc[d].min=v; if (v > acc[d].max) acc[d].max=v; }
                }
                if (T < acc['T'].min) acc['T'].min=T; if (T > acc['T'].max) acc['T'].max=T;
            }
        }
        if (features.length < 5) continue;

        stemRanges[stem] = acc;
        const nIter = features.length > 400 ? 150 : features.length > 200 ? 200 : 250;
        Max.post('ws_server: t-SNE [' + stem + ']: ' + features.length + ' slices from ' + filenames.length + ' track(s) (' + nIter + ' iters)…\n');
        stems.push({ stem, ids, features, nIter });
    }

    // Write stem_ranges.json immediately (no t-SNE needed).
    const rangesPath = path.join(__dirname, 'stem_ranges.json');
    fs.writeFileSync(rangesPath, JSON.stringify(stemRanges));
    Max.post('ws_server: stem_ranges.json written\n');

    // Spin up child process for t-SNE via stdin/stdout JSON.
    // stdin/stdout bypasses N4M's IPC interception (N4M monkey-patches process.send
    // and ChildProcess message events for its own Max↔Node comms, which corrupts
    // fork() IPC).  Plain stdio is invisible to N4M.
    const child = spawn(process.execPath, [path.join(__dirname, 'tsne_worker.js')]);
    let outputJson = '';
    child.stdin.write(JSON.stringify({ stems }));
    child.stdin.end();

    child.stdout.on('data', chunk => { outputJson += chunk.toString(); });

    child.stdout.on('end', () => {
        try {
            const results = JSON.parse(outputJson);
            const umapResults = {};
            for (const stem of Object.keys(results)) {
                const { coords, ms } = results[stem];
                umapResults[stem] = coords;
                Max.post('ws_server: t-SNE [' + stem + ']: done in ' + ms + 'ms\n');
            }
            const outPath = path.join(__dirname, 'umap_coords.json');
            fs.writeFileSync(outPath, JSON.stringify(umapResults));
            Max.post('ws_server: umap_coords.json written\n');
            broadcast({ type: 'umapDone' });
            Max.post('ws_server: umapDone broadcast sent (' + clients.size + ' clients)\n');
            Max.outlet('umapDone');
        } catch(e) {
            Max.post('ws_server: t-SNE result parse error — ' + e + '\n');
        }
        buildIndexInProgress = false;
    });

    child.stderr.on('data', d => {
        Max.post('ws_server: t-SNE stderr — ' + d.toString().trim() + '\n');
    });

    child.on('error', e => {
        Max.post('ws_server: t-SNE spawn error — ' + e + '\n');
        buildIndexInProgress = false;
    });
}

// ── Broadcast ─────────────────────────────────────────────────────────────────
function broadcast(obj) {
    const frame = encodeFrame(JSON.stringify(obj));
    clients.forEach(s => { try { s.write(frame); } catch(e) {} });
}

// ── Slicer outlet 1 — status messages ────────────────────────────────────────
Max.addHandler('desc', (track, C, E, F, P, H, T, tC, tE, tF, tP, tH, tT) => {
    if (!state.stems[track]) return;
    const tension = (v) => (v === undefined || v === null || v === '') ? null : parseFloat(v);
    Object.assign(state.stems[track], {
        C: parseFloat(C)||0, E: parseFloat(E)||0,
        F: parseFloat(F)||0, P: parseFloat(P)||0,
        H: parseFloat(H)||0, T: parseFloat(T)||0,
        tC: tension(tC), tE: tension(tE), tF: tension(tF),
        tP: tension(tP), tH: tension(tH), tT: tension(tT),
    });
    // 'desc' type lets the TUI compute novelty the instant fresh descriptors arrive
    broadcast({ type: 'desc', name: track, ...state.stems[track] });
});

Max.addHandler('seg', async (track, id, durStr, distStr, startFrac, endFrac) => {
    if (!state.stems[track]) return;
    state.stems[track].id = String(id);
    if (startFrac !== undefined) state.stems[track].sliceStart = parseFloat(startFrac);
    if (endFrac   !== undefined) state.stems[track].sliceEnd   = parseFloat(endFrac);
    broadcast({ type: 'stem', name: track, ...state.stems[track] });

    // Log slice to tipping backend for artist duration tracking
    // handlePlayback (outlet 0) fires before seg (outlet 1), so segDurMs is already set
    // Skip in direct mode — no artist split, no slice tracking needed
    if (state.sessionId && state.sessionDeck !== 'direct' && state.stems[track].track && state.stems[track].segDurMs > 0) {
        try {
            await fetch(`${TIPPING_URL}/slices/log`, {
                method:  'POST',
                headers: { 'Content-Type': 'application/json' },
                body:    JSON.stringify({
                    sessionId: state.sessionId,
                    trackName: state.stems[track].track,
                    durationMs: state.stems[track].segDurMs,
                }),
            });
        } catch(e) {
            Max.post('ws_server: slice log error — ' + e.message + '\n');
        }
    }
});

Max.addHandler('track_name', (...args) => {
    state.track = args.join(' ');
    broadcast({ type: 'state', running: state.running,
                track: state.track, bpm: state.bpm,
                key: state.key, slices: state.slices });
    // Pre-populate all stem track fields so the name shows immediately (before playback)
    ['vocals', 'melody', 'bass', 'drums'].forEach(stem => {
        state.stems[stem].track = state.track;
        broadcast({ type: 'stemTrack', name: stem, track: state.track });
    });
});

Max.addHandler('globalBPM', (n) => {
    state.globalBPM = parseFloat(n) || 0;
    broadcast({ type: 'param', key: 'globalBPM', value: n });
    updatePingTimer();  // BPM changed — restart ping interval
});

// slicer.js emits: outlet(1, "segmentBars", track, N)
Max.addHandler('segmentBars', (track, n) => {
    const t    = String(track);
    const bars = parseFloat(n) || 4;
    if (state.segBars.hasOwnProperty(t)) state.segBars[t] = bars;
    broadcast({ type: 'param', key: 'bars', track: t, value: bars });
});

Max.addHandler('stemTrack', (stem, trackName) => {
    if (!state.stems[stem]) return;
    state.stems[stem].track = String(trackName || '');
    broadcast({ type: 'stemTrack', name: String(stem), track: String(trackName || '') });
});

Max.addHandler('stemDurMs', (track, ms) => {
    broadcast({ type: 'stemDurMs', track: String(track), ms: parseFloat(ms) });
});

Max.addHandler('slice_ms', (track, ms) => {
    broadcast({ type: 'slice_ms', name: String(track), timeMs: parseFloat(ms) || 0 });
});

Max.addHandler('ready', (n) => {
    broadcast({ type: 'state', running: state.running,
                track: state.track, bpm: state.bpm,
                key: state.key, slices: state.slices });
});

Max.addHandler('stopped', () => {
    state.running = false;
    broadcast({ type: 'state', running: false,
                track: state.track, bpm: state.bpm,
                key: state.key, slices: state.slices });
});

// ── Slicer outlet 0 — playback triggers ──────────────────────────────────────
// New format (v2 multi-track): track  slot  startFrac  endFrac  stretchRatio  segDurMs
// After Max routes by stem name, args here are: slot startFrac endFrac stretchRatio segDurMs
function handlePlayback(track, slot, startFrac, segDurMs) {
    if (!state.stems[track]) return;
    // slot = source track index (int); startFrac = 0–1 position in source buffer
    state.stems[track].pos  = parseFloat(startFrac) || 0;
    state.stems[track].slot = parseInt(slot) || 0;
    if (segDurMs !== undefined) state.stems[track].segDurMs = parseFloat(segDurMs) || 0;
    broadcast({ type: 'stem', name: track, ...state.stems[track] });
}
Max.addHandler('vocals', (slot, startFrac, endFrac, stretchRatio, segDurMs) => {
    if (!state.running) {
        state.running = true;
        broadcast({ type: 'state', running: true,
                    track: state.track, bpm: state.bpm,
                    key: state.key, slices: state.slices });
    }
    handlePlayback('vocals', slot, startFrac, segDurMs);
});
Max.addHandler('melody', (slot, startFrac, endFrac, stretchRatio, segDurMs) => { handlePlayback('melody', slot, startFrac, segDurMs); });
Max.addHandler('bass',   (slot, startFrac, endFrac, stretchRatio, segDurMs) => { handlePlayback('bass',   slot, startFrac, segDurMs); });
Max.addHandler('drums',  (slot, startFrac, endFrac, stretchRatio, segDurMs) => { handlePlayback('drums',  slot, startFrac, segDurMs); });

// ── State / meta ──────────────────────────────────────────────────────────────
Max.addHandler('state', (running) => {
    state.running = (parseInt(running) !== 0);
    broadcast({ type: 'state', running: state.running,
                track: state.track, bpm: state.bpm,
                key: state.key, slices: state.slices });
});

Max.addHandler('meta', (...args) => {
    if (args.length < 3) return;
    const prevBpm = state.bpm;
    state.key   = String(args[args.length - 1]);
    state.bpm   = parseFloat(args[args.length - 2])||0;
    state.track = args.slice(0, args.length - 2).join(' ');
    broadcast({ type: 'state', running: state.running,
                track: state.track, bpm: state.bpm,
                key: state.key, slices: state.slices });
    if (state.bpm !== prevBpm) updatePingTimer();  // BPM changed — restart ping interval
});

Max.addHandler('slices', (v, m, b, d) => {
    state.slices = [parseInt(v)||0, parseInt(m)||0, parseInt(b)||0, parseInt(d)||0];
    broadcast({ type: 'state', running: state.running,
                track: state.track, bpm: state.bpm,
                key: state.key, slices: state.slices });
});

Max.addHandler('param', (key, value) => {
    broadcast({ type: 'param', key, value });
});

// ── VU metering ───────────────────────────────────────────────────────────────
// Format: meter <name> <level>   where name = vocals|melody|bass|drums|master
//                                      level = 0–1 linear peak amplitude (from peakamp~)
// When called with no args (beat-tick from metro) — silently ignore.
// This handler also silences the "can't handle message meter" flood on startup.
Max.addHandler('meter', (...args) => {
    if (args.length >= 2) {
        const name  = String(args[0]);
        const level = parseFloat(args[1]) || 0;
        broadcast({ type: 'vu', name, level });
    }
    // 0 args = metro beat tick — silently discard
});

// ── LUFS metering ─────────────────────────────────────────────────────────────
// Format: lufs <short> <integrated>
//   short      = short-term loudness in dBFS  (snapshot~ outlet 0 of fluid.loudness~)
//   integrated = integrated loudness in dBFS  (snapshot~ outlet 1 of fluid.loudness~)
// Sampled by metro 100 (10 Hz) — perceptual loudness, frequency-weighted (K-weight).
// Distinct from 'meter' (peakamp~, linear amplitude, per stem).
// TUI uses this for the LUFS / dBFS header readout.
Max.addHandler('lufs', (short, integrated) => {
    broadcast({ type: 'lufs', short: parseFloat(short) || -Infinity, integrated: parseFloat(integrated) || -Infinity });
});

// ── Index cache save (from slicer.js outlet 1) ───────────────────────────────
// slicer sends saveIdxChunk messages after each buildIndex; Node writes to disk.
// Format: saveIdxChunk  streamId  chunkIndex  total  data
let saveIdxBuf = null, saveIdxTotal = 0, saveIdxReceived = 0, saveIdxSid = -1;
Max.addHandler('saveIdxChunk', (streamId, i, total, ...dataParts) => {
    const data = dataParts.join(' ');
    const sid  = parseInt(streamId);
    const ti   = parseInt(total), ii = parseInt(i);
    if (!saveIdxBuf || saveIdxSid !== sid) {
        if (saveIdxBuf && saveIdxSid !== sid) {
            Max.post('ws_server: saveIdxChunk stream reset (was ' + saveIdxSid + ', now ' + sid + ') — ' + saveIdxReceived + '/' + saveIdxTotal + ' chunks dropped\n');
        }
        saveIdxBuf      = new Array(ti);
        saveIdxTotal    = ti;
        saveIdxSid      = sid;
        saveIdxReceived = 0;
    }
    if (saveIdxBuf[ii] !== undefined) return; // duplicate chunk — ignore
    saveIdxBuf[ii] = data;
    saveIdxReceived++;
    if (saveIdxReceived === saveIdxTotal) {
        const jsonStr = saveIdxBuf.join('');
        saveIdxBuf = null;
        try {
            fs.writeFileSync(path.join(__dirname, 'ebys_index.json'), jsonStr);
            Max.post('ws_server: ebys_index.json saved (stream ' + sid + ', ' + jsonStr.length + ' chars)\n');
        } catch(e) {
            Max.post('ws_server: index save failed — ' + e + '\n');
        }
    }
});

Max.addHandler('sourceTrack', (slot, ...nameParts) => {
    // slicer.js outlet(1, "sourceTrack", slot, trackName) — tells TUI which source track
    // is loaded into each slot so it can display track names per stem.
    const name = nameParts.join(' ');
    broadcast({ type: 'sourceTrack', slot: parseInt(slot), name });
});

// Silence unhandled-message log — slicer.js emits this when it needs stem durations
Max.addHandler('need_stemDurs', () => {});

Max.addHandler('index_empty', () => {
    broadcast({ type: 'sys', msg: '⚠ index empty — send :buildIndex before :start' });
});

// stemMS — slicer.js emits this after each selectSegment() with analysis-driven
// pan/width for the chosen slice.  Forward to ms_router via outlet 0, and
// broadcast to TUI so it can show live pan/width per stem.
Max.addHandler('stemMS', (track, pan, width) => {
    const t = String(track);
    const p = parseFloat(pan)   || 0;
    const w = parseFloat(width) || 0;
    // Forward to ms_router — it receives all ws_server outlet 0 messages.
    // Message format: stemMS <track> <pan> <width>
    // ms_router.stemMS(track, pan, width) → applyPan + applyWidth
    Max.outlet('stemMS', t, p, w);
    broadcast({ type: 'param', key: 'stemMS', track: t, pan: p, width: w });
});

// streamUpdated — sent when streamWatcher detects stream.txt changed.
// genre + madmom are already written to disk; FluCoMa is about to start.
Max.addHandler('streamUpdated', () => {
    broadcast({ type: 'streamUpdated' });
});

// analysisDone — sent by analyze_reader when all FluCoMa stems are done.
// Stops the TUI spinner that was started by :analyzeAll.
Max.addHandler('analysisDone', () => {
    state.analysisDone = true;
    broadcast({ type: 'analysisDone' });
});

// umapDone — slicer.js finished writing umap_coords.json; tell TUI to reload.
Max.addHandler('umapDone', () => {
    broadcast({ type: 'umapDone' });
});

// resetMemory: TUI → ws_server → Max patch → slice_writer.js + analyze_reader.js
Max.addHandler('resetMemory', () => {
    Max.outlet('resetMemory');
});

Max.post('ws_server.js loaded\n');
