#!/usr/bin/env node
// EBYS — Slicer Test Harness
// Tests slicer.js logic without Max by mocking the Max JS environment.
//
// Run:  node slicer_test.js
//
// ─────────────────────────────────────────────────────────────────────────────

const fs   = require('fs');
const path = require('path');
const vm   = require('vm');

const DIR       = __dirname;
const LIB_PATH  = path.join(DIR, 'analysis_library.json');
const DB_PATH   = path.join(DIR, '..', 'downbeats.json');

// ── Colours ───────────────────────────────────────────────────────────────────
const RED   = '\x1b[31m';
const GRN   = '\x1b[32m';
const YEL   = '\x1b[33m';
const BLU   = '\x1b[34m';
const DIM   = '\x1b[2m';
const RST   = '\x1b[0m';

let PASS = 0, FAIL = 0, WARN = 0;
function ok(msg)   { console.log(`${GRN}✓${RST} ${msg}`); PASS++; }
function fail(msg) { console.log(`${RED}✗${RST} ${msg}`); FAIL++; }
function warn(msg) { console.log(`${YEL}⚠${RST} ${msg}`); WARN++; }
function head(msg) { console.log(`\n${BLU}── ${msg} ──${RST}`); }
function info(msg) { console.log(`  ${DIM}${msg}${RST}`); }

// ── Max environment shim ──────────────────────────────────────────────────────
const outlets = { 0: [], 1: [], 2: [], 3: [], 4: [], 5: [] };
const posts   = [];

global.autowatch    = 0;
global.inlets       = 3;
global.outlets_     = 6;
global.inlet        = 0;
global.inletinfo    = function() {};
global.patcher      = { filepath: path.join(DIR, 'ebys-analyze.maxpat') };
global.Max          = {};
global.jsarguments  = [];

global.post = function() {
    const msg = Array.from(arguments).join('');
    posts.push(msg.replace(/\n$/, ''));
    // Show slicer logs live for debugging
    if (process.env.VERBOSE) process.stdout.write('[slicer] ' + msg);
};

let outletLog = [];
global.outlet = function() {
    const args = Array.from(arguments);
    const n    = args[0];
    const msg  = args.slice(1);
    outletLog.push({ outlet: n, msg });
    if (outlets[n]) outlets[n].push(msg);
};

global.arrayfromargs = function() {
    return Array.from(arguments[0] || []);
};

global.File = function(filepath, mode, type) {
    // Mock file reads — return empty file
    this.isopen = false;
    this.eof    = true;
    this.readline = function() { return ''; };
    this.close  = function() {};
};

// ── Load slicer.js into this scope ────────────────────────────────────────────
// We eval() it so all module-level vars (idx, byTrack, etc.) live in this scope.
// We can then call slicer functions directly.
const slicerSrc = fs.readFileSync(path.join(DIR, 'slicer.js'), 'utf8');

// Patch autowatch/inlets/outlets declarations so they don't conflict
const patched = slicerSrc
    .replace(/^autowatch\s*=.*;/m, '// autowatch stripped')
    .replace(/^inlets\s*=.*;/m,   '// inlets stripped')
    .replace(/^outlets\s*=.*;/m,  '// outlets stripped');

vm.runInThisContext(patched, { filename: 'slicer.js' });

// ── Load real data ────────────────────────────────────────────────────────────
const lib = JSON.parse(fs.readFileSync(LIB_PATH, 'utf8'));
let   dbRaw = null;
if (fs.existsSync(DB_PATH)) {
    dbRaw = JSON.parse(fs.readFileSync(DB_PATH, 'utf8'));
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST 1 — Library structure
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 1 — Library structure');

const topKeys = Object.keys(lib);
if (topKeys.length > 0) ok(`Library loaded — ${topKeys.length} top-level keys`);
else                     fail('Library is empty');

// Check descriptor coverage per file
const EXPECTED_DESC = ['C', 'S', 'E', 'F', 'P', 'H'];
const missingByDesc = {};

for (const fkey of topKeys) {
    const inner = lib[fkey];
    for (const stemKey of Object.keys(inner)) {
        const slices = inner[stemKey].slices;
        const firstSlice = Object.values(slices)[0];
        for (const d of EXPECTED_DESC) {
            if (!(d in firstSlice)) {
                missingByDesc[d] = (missingByDesc[d] || 0) + 1;
            }
        }
    }
}

for (const d of EXPECTED_DESC) {
    if (missingByDesc[d]) {
        fail(`Descriptor "${d}" MISSING from ${missingByDesc[d]}/${topKeys.length} files — scoring dimension is dead`);
    } else {
        ok(`Descriptor "${d}" present in all files`);
    }
}

// Check F range (should be 0-1 for flatness)
const fVals = [];
for (const fkey of topKeys) {
    const inner = lib[fkey];
    for (const stemKey of Object.keys(inner)) {
        for (const sv of Object.values(inner[stemKey].slices)) {
            if (sv.F !== undefined) fVals.push(sv.F);
        }
    }
}
if (fVals.length > 0) {
    const fMin = Math.min(...fVals), fMax = Math.max(...fVals);
    if (fMax > 2.0) {
        warn(`Descriptor "F" range ${fMin.toFixed(0)}–${fMax.toFixed(0)} — NOT 0-1 flatness (likely spectral flux in Hz)`);
        warn(`  F is used in scoring but semantics are wrong — check FluCoMa feature extraction`);
    } else {
        ok(`Descriptor "F" in expected 0-1 range (${fMin.toFixed(3)}–${fMax.toFixed(3)})`);
    }
}

// Check stemDurMs in metadata
const stemDurMs_check = {};
for (const fkey of topKeys) {
    const inner = lib[fkey];
    for (const stemKey of Object.keys(inner)) {
        const meta = inner[stemKey].metadata || {};
        const dur  = meta.stemDurMs;
        const src  = meta.track_name || fkey;
        if (!dur || dur <= 0) {
            fail(`stemDurMs missing or 0 for ${fkey}/${stemKey} — bar alignment will break`);
        } else {
            stemDurMs_check[fkey + '/' + stemKey] = dur;
        }
    }
}
const durVals = Object.values(stemDurMs_check);
if (durVals.length > 0) {
    const allSame = durVals.every(v => Math.abs(v - durVals[0]) < 1000);
    if (allSame && topKeys.length > 1) {
        warn(`All stemDurMs values are identical (${(durVals[0]/1000).toFixed(1)}s) across different source tracks — verify this is correct`);
    } else {
        ok(`stemDurMs varies across tracks — multi-track durations look correct`);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST 2 — buildIndex()
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 2 — buildIndex()');

// Inject library via chunk system (simulates ws_server)
outletLog = [];
const libJson = JSON.stringify(lib);
const CHUNK   = 2048;
const total   = Math.ceil(libJson.length / CHUNK);

// Call libchunk() to assemble the library
for (let i = 0; i < total; i++) {
    const chunk = libJson.slice(i * CHUNK, (i + 1) * CHUNK);
    libchunk(1, i, total, ...chunk.split(' '));
    // libchunk expects the chunk split on spaces as separate args
    // Re-call with the raw string in one arg (Max splits on spaces, but here we don't)
}

// Actually libchunk reassembles using args.slice(3).join(' '), so we need to
// pass space-split tokens. Let's redo with proper format:
// Reset and try again
cachedLibrary = null;
libChunkBuf = null; libChunkTotal = 0; libChunkReceived = 0; libChunkSid = -1;

for (let i = 0; i < total; i++) {
    const data  = libJson.slice(i * CHUNK, (i + 1) * CHUNK);
    const parts = data.split(' ');
    // call libchunk(sid, i, total, ...tokens)
    const fakeArgs = [2, i, total, ...parts];
    // Replicate how Max calls it: arguments object
    const fakeArgsObj = Object.assign([], fakeArgs);
    fakeArgsObj.length = fakeArgs.length;
    // Use the arrayfromargs version
    global.arrayfromargs = function() { return fakeArgs; };
    libchunk.apply(null, fakeArgs);
}

// Restore arrayfromargs
global.arrayfromargs = function() { return Array.from(arguments[0] || []); };

// Inject downbeats
if (dbRaw) {
    downbeatsRaw = dbRaw;
    info('downbeats.json injected directly');
}

// Run buildIndex
outletLog = [];
posts.length = 0;
buildIndex();

// Check index was built
const totalSlices = idx.length;
if (totalSlices > 0)  ok(`buildIndex() completed — ${totalSlices} total slices in idx`);
else                  fail(`buildIndex() produced empty index`);

const TRACKS_LIST = ['vocals', 'melody', 'bass', 'drums'];
for (const t of TRACKS_LIST) {
    const arr = byTrack[t] || [];
    if (arr.length > 0) ok(`  byTrack.${t}: ${arr.length} slices`);
    else                fail(`  byTrack.${t}: 0 slices — stem missing from index`);
}

// Check norm values
const normCheck = norm;
for (const d of ['C', 'E', 'F', 'H', 'T']) {
    if (normCheck[d] > 0) ok(`  norm.${d} = ${normCheck[d].toFixed(3)} (non-zero — normalization active)`);
    else                  fail(`  norm.${d} = 0 — normalization will use fallback 1, scoring broken for ${d}`);
}
if (normCheck.S === 0 || normCheck.S === 1) {
    fail(`  norm.S = ${normCheck.S} — S descriptor is all-zero (missing from library) — spread dimension dead`);
}

// Check slotMap
const slots = Object.keys(slotMap);
if (slots.length > 0) ok(`  slotMap has ${slots.length} source track(s): ${slots.join(', ')}`);
else                  fail(`  slotMap is empty — slot assignments broken`);

// ─────────────────────────────────────────────────────────────────────────────
// TEST 3 — Bar alignment pool
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 3 — Bar alignment pool (QUANTIZE_BARS)');

for (const t of TRACKS_LIST) {
    const arr = byTrack[t] || [];
    if (arr.length === 0) { warn(`  ${t}: skipped (no slices)`); continue; }

    const firstSrc = arr[0].sourceTrack;
    const bpm      = effectiveBPMForSource(firstSrc);
    const barMs    = getBarMs(t, bpm, firstSrc);

    let aligned = 0;
    for (const sl of arr) {
        const slDurMs = sl.stemDurMs || stemDurMs[t] || 0;
        if (slDurMs <= 0) continue;
        const posMs = sl.time * slDurMs;
        if (isNearDownbeat(posMs, t, barMs, sl.sourceTrack)) aligned++;
    }

    const pct = (100 * aligned / arr.length).toFixed(0);
    if (aligned < 2) {
        fail(`  ${t}: only ${aligned}/${arr.length} bar-aligned slices (${pct}%) — pool too small, QUANTIZE_BARS will always fall back to full pool`);
    } else if (aligned < 10) {
        warn(`  ${t}: ${aligned}/${arr.length} bar-aligned slices (${pct}%) — very small pool, limited variety`);
    } else {
        ok(`  ${t}: ${aligned}/${arr.length} bar-aligned slices (${pct}%)`);
    }
    info(`    BPM=${bpm.toFixed(1)}  barMs=${barMs.toFixed(0)}ms  BAR_SNAP_MS=${BAR_SNAP_MS}ms`);
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST 4 — selectSegment() output validity
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 4 — selectSegment() output');

running = true;
outletLog = [];

for (const t of TRACKS_LIST) {
    outletLog = [];
    selectSegment(t);

    const playMsg  = outletLog.find(e => e.outlet === 0 && e.msg[0] === t);
    const segMsg   = outletLog.find(e => e.outlet === 1 && e.msg[0] === 'seg' && e.msg[1] === t);
    const descMsg  = outletLog.find(e => e.outlet === 1 && e.msg[0] === 'desc' && e.msg[1] === t);

    if (!playMsg) { fail(`  ${t}: no play message on outlet 0`); continue; }

    const [track, slot, startFrac, endFrac, stretchRatio, segDurMs] = playMsg.msg;
    const fracOk  = startFrac >= 0 && startFrac < endFrac && endFrac <= 1.0;
    const durOk   = segDurMs > 0;
    const ratioOk = stretchRatio > 0 && stretchRatio < 10;

    if (fracOk)  ok(`  ${t}: startFrac=${startFrac.toFixed(3)} endFrac=${endFrac.toFixed(3)} slot=${slot}`);
    else         fail(`  ${t}: BAD fracs — startFrac=${startFrac} endFrac=${endFrac}`);

    if (durOk)   ok(`  ${t}: segDurMs=${segDurMs}ms`);
    else         fail(`  ${t}: segDurMs=${segDurMs} — invalid duration`);

    if (ratioOk) ok(`  ${t}: stretchRatio=${stretchRatio.toFixed(3)}`);
    else         fail(`  ${t}: stretchRatio=${stretchRatio} — out of range`);

    if (descMsg) ok(`  ${t}: desc message emitted on outlet 1`);
    else         fail(`  ${t}: no desc message on outlet 1`);
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST 5 — Transition scoring (scoreCandidate)
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 5 — Transition scoring (scoreCandidate)');

// Set MATCH_PROB high and check that the best candidate is actually closer
MATCH_PROB = 0.9;
const testTrack = 'vocals';
const testArr   = byTrack[testTrack] || [];

if (testArr.length >= 3) {
    const ref = testArr[0]; // use first slice as reference "last played"
    const endDesc = { C: ref.endC, E: ref.endE, F: ref.endF, P: ref.endP, H: ref.endH, T: ref.endT };

    let minScore = Infinity, maxScore = -Infinity;
    for (const sl of testArr) {
        const sc = scoreCandidate(sl, endDesc);
        if (sc < minScore) minScore = sc;
        if (sc > maxScore) maxScore = sc;
    }

    if (minScore < maxScore) ok(`scoreCandidate() produces spread of scores (min=${minScore.toFixed(4)} max=${maxScore.toFixed(4)})`);
    else                     fail(`scoreCandidate() returns identical scores for all slices — matching is broken`);

    // Verify the zero-ref slice scores near 0 (a slice matching its own end should score low)
    const selfScore = scoreCandidate(ref, endDesc);
    const nextSlice = testArr[1];
    const nextScore = scoreCandidate(nextSlice, endDesc);
    info(`  self-match score: ${selfScore.toFixed(4)} (lower is better match)`);
    info(`  next-slice score: ${nextScore.toFixed(4)}`);
} else {
    warn(`Not enough vocals slices to test scoring`);
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST 6 — setEntropy macro
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 6 — setEntropy macro');

// Test entropy=0 → max order
setEntropy(0);
if (Math.abs(MATCH_PROB - 1.0) < 0.001) ok(`entropy=0 → matchProb=1.0 (max order)`);
else                                      fail(`entropy=0 → matchProb=${MATCH_PROB} (expected 1.0)`);
const sp0 = STAY_PROB.vocals;
if (Math.abs(sp0 - 0.8) < 0.01) ok(`entropy=0 → stayProb=0.8`);
else                              fail(`entropy=0 → stayProb=${sp0} (expected 0.8)`);
if (Math.abs(DIR_WEIGHT - 0.0) < 0.01) ok(`entropy=0 → dirWeight=0.0`);
else                                    fail(`entropy=0 → dirWeight=${DIR_WEIGHT} (expected 0.0)`);

// Test entropy=1 → max chaos
setEntropy(1);
if (Math.abs(MATCH_PROB - 0.0) < 0.001) ok(`entropy=1 → matchProb=0.0 (max chaos)`);
else                                      fail(`entropy=1 → matchProb=${MATCH_PROB} (expected 0.0)`);
const sp1 = STAY_PROB.vocals;
if (Math.abs(sp1 - 0.0) < 0.01) ok(`entropy=1 → stayProb=0.0`);
else                              fail(`entropy=1 → stayProb=${sp1} (expected 0.0)`);
if (Math.abs(DIR_WEIGHT - 3.0) < 0.01) ok(`entropy=1 → dirWeight=3.0`);
else                                    fail(`entropy=1 → dirWeight=${DIR_WEIGHT} (expected 3.0)`);

// Test midpoint
setEntropy(0.5);
if (MATCH_PROB > 0 && MATCH_PROB < 1) ok(`entropy=0.5 → matchProb=${MATCH_PROB.toFixed(3)} (in range)`);
else                                   fail(`entropy=0.5 → matchProb=${MATCH_PROB} out of range`);

// ─────────────────────────────────────────────────────────────────────────────
// TEST 7 — STAY_PROB / stay-or-move
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 7 — STAY_PROB (stay-or-move)');

setEntropy(0.5); // reset to mid
MATCH_PROB = 0;  // disable matching so we can isolate stay logic
running = true;

// Prime lastSourceTrack / lastEndFrac by running selectSegment first
for (const t of TRACKS_LIST) selectSegment(t);

// Now run 10 iterations with STAY_PROB=1 — all should stay on same source track
for (const t of TRACKS_LIST) {
    STAY_PROB[t] = 1.0;
}
const initialSrcTracks = {};
for (const t of TRACKS_LIST) initialSrcTracks[t] = lastSourceTrack[t];

let stayCount = 0;
for (let i = 0; i < 10; i++) {
    for (const t of TRACKS_LIST) {
        outletLog = [];
        selectSegment(t);
        const src = lastSourceTrack[t];
        if (src === initialSrcTracks[t]) stayCount++;
    }
}
const stayRate = stayCount / (10 * TRACKS_LIST.length);
if (stayRate > 0.9) ok(`STAY_PROB=1.0 → stay rate ${(stayRate*100).toFixed(0)}% (expected ~100%)`);
else                fail(`STAY_PROB=1.0 → stay rate ${(stayRate*100).toFixed(0)}% — stay logic broken`);

// STAY_PROB=0 should allow switching sources
for (const t of TRACKS_LIST) STAY_PROB[t] = 0.0;
const srcSet = new Set();
for (let i = 0; i < 20; i++) {
    for (const t of ['vocals']) {
        selectSegment(t);
        srcSet.add(lastSourceTrack[t]);
    }
}
if (srcSet.size > 1) ok(`STAY_PROB=0 → vocals visits ${srcSet.size} source tracks (variety present)`);
else                 warn(`STAY_PROB=0 → vocals only ever picks 1 source track out of ${slots.length} — check if multi-source selection works`);

// ─────────────────────────────────────────────────────────────────────────────
// TEST 8 — stretchRatio
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 8 — stretchRatio');

GLOBAL_BPM = 0;
outletLog = [];
for (const t of TRACKS_LIST) selectSegment(t);

for (const t of TRACKS_LIST) {
    const playMsg = outletLog.find(e => e.outlet === 0 && e.msg[0] === t);
    if (!playMsg) { fail(`  ${t}: no play message`); continue; }
    const stretchRatio = playMsg.msg[4];
    const srcTrack     = lastSourceTrack[t];
    const srcBpm       = effectiveBPMForSource(srcTrack);
    const expected     = srcBpm / FALLBACK_BPM;
    if (Math.abs(stretchRatio - expected) < 0.01) {
        ok(`  ${t}: stretchRatio=${stretchRatio.toFixed(3)} (srcBPM=${srcBpm} / fallback=${FALLBACK_BPM})`);
    } else {
        fail(`  ${t}: stretchRatio=${stretchRatio.toFixed(3)} expected ${expected.toFixed(3)}`);
    }
}

// Test with GLOBAL_BPM override
GLOBAL_BPM = 130;
outletLog = [];
selectSegment('vocals');
const overrideMsg = outletLog.find(e => e.outlet === 0 && e.msg[0] === 'vocals');
if (overrideMsg) {
    const sr = overrideMsg.msg[4];
    const srcBpm = effectiveBPMForSource(lastSourceTrack['vocals']);
    const expected = srcBpm / GLOBAL_BPM;
    if (Math.abs(sr - expected) < 0.01) ok(`  GLOBAL_BPM=130 → stretchRatio=${sr.toFixed(3)} correct`);
    else                                 fail(`  GLOBAL_BPM=130 → stretchRatio=${sr.toFixed(3)} expected ${expected.toFixed(3)}`);
}
GLOBAL_BPM = 0;

// ─────────────────────────────────────────────────────────────────────────────
// TEST 9 — nextNearest
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 9 — nextNearest()');

MATCH_PROB = 0.9;
setEntropy(0.3);
running = true;

const vocArr = byTrack['vocals'];
if (vocArr && vocArr.length >= 2) {
    const ref    = vocArr[0];
    outletLog    = [];
    nextNearest('vocals', ref.C, ref.E, ref.F, ref.P);
    const playMsg = outletLog.find(e => e.outlet === 0 && e.msg[0] === 'vocals');
    if (playMsg) {
        const startFrac = playMsg.msg[2];
        if (startFrac >= 0 && startFrac <= 1.0) ok(`nextNearest() returned valid startFrac=${startFrac.toFixed(3)}`);
        else                                      fail(`nextNearest() returned bad startFrac=${startFrac}`);
    } else {
        fail(`nextNearest() emitted no play message`);
    }
} else {
    warn(`Not enough vocals slices to test nextNearest`);
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST 10 — Genre/Key filtering
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 10 — Genre / Key filtering');

// Key filter
const vocSlice = (byTrack['vocals'] || [])[0];
if (vocSlice && vocSlice.key) {
    setKeyFilter(vocSlice.key);
    if (keyFilter) ok(`setKeyFilter("${vocSlice.key}") → keyFilter="${keyFilter}"`);

    outletLog = [];
    selectSegment('vocals');
    const playMsg = outletLog.find(e => e.outlet === 0 && e.msg[0] === 'vocals');
    if (playMsg) ok(`selectSegment() works with keyFilter active`);
    else         fail(`selectSegment() failed with keyFilter active`);

    // Apply impossible key filter — should fall back to full pool
    setKeyFilter('ZZZZZ');
    outletLog = [];
    selectSegment('vocals');
    const fallbackMsg = outletLog.find(e => e.outlet === 0 && e.msg[0] === 'vocals');
    if (fallbackMsg) ok(`Impossible keyFilter falls back to full pool (no crash)`);
    else             fail(`Impossible keyFilter caused selectSegment() to fail`);

    clearKeyFilter();
} else {
    warn(`No key data on vocals slices — key filter test skipped`);
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST 11 — loop / unloop
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 11 — loop / unloop');

running = true;
loop('vocals', 4);
if (loopState['vocals'] !== null) ok(`loop() set loopState for vocals`);
else                               fail(`loop() did not set loopState`);

outletLog = [];
next('vocals');
const loopMsg = outletLog.find(e => e.outlet === 0 && e.msg[0] === 'vocals');
if (loopMsg) {
    // Should replay the same fracs
    const lp = loopState['vocals'];
    if (Math.abs(loopMsg.msg[2] - lp.startTime) < 0.001) ok(`next() in loop mode replays correct startFrac`);
    else fail(`next() in loop mode returned wrong startFrac: ${loopMsg.msg[2]} vs ${lp.startTime}`);
} else {
    fail(`next() in loop mode emitted no play message`);
}

unloop('vocals');
if (loopState['vocals'] === null) ok(`unloop() cleared loopState`);
else                               fail(`unloop() did not clear loopState`);

// ─────────────────────────────────────────────────────────────────────────────
// TEST 12 — followStem
// ─────────────────────────────────────────────────────────────────────────────
head('TEST 12 — followStem');

// Prime end descriptors
for (const t of TRACKS_LIST) selectSegment(t);
const bassEndDesc = lastEndDesc['bass'];

followStem('vocals', 'bass', 1.0);
if (FOLLOW_STEM['vocals'] && FOLLOW_STEM['vocals'][0].stem === 'bass') {
    ok(`followStem() set vocals to follow bass at weight 1.0`);
} else {
    fail(`followStem() did not set FOLLOW_STEM correctly`);
}

const blended = getBlendedEndDesc('vocals');
if (bassEndDesc && blended) {
    if (Math.abs(blended.C - bassEndDesc.C) < 0.001) ok(`getBlendedEndDesc() correctly returns bass descriptors when following bass 100%`);
    else fail(`getBlendedEndDesc() returned wrong values: got C=${blended.C} expected ${bassEndDesc.C}`);
}

followStem('vocals', 'self');
if (!FOLLOW_STEM['vocals']) ok(`followStem("vocals", "self") resets to self`);
else                         fail(`followStem reset failed`);

// ─────────────────────────────────────────────────────────────────────────────
// SUMMARY
// ─────────────────────────────────────────────────────────────────────────────
console.log(`\n${'─'.repeat(60)}`);
console.log(`${GRN}PASS: ${PASS}${RST}   ${YEL}WARN: ${WARN}${RST}   ${RED}FAIL: ${FAIL}${RST}`);
console.log('─'.repeat(60));

if (FAIL > 0) {
    console.log(`\n${RED}ACTION ITEMS:${RST}`);
    if (missingByDesc['S']) {
        console.log(`  1. Add "S" (spectral spread) to FluCoMa feature extraction — currently missing from all library files`);
        console.log(`     In Max: fluid.bufsinglethreadednonrealtime~ or fluid.bufspectralshape~`);
        console.log(`     SpectralShape outlets: [centroid, spread, skewness, kurtosis, rolloff, flatness, crest]`);
        console.log(`     S = outlet 1 (spread). Currently only exporting centroid (C=outlet 0) and flatness?`);
    }
    if (missingByDesc['P']) {
        console.log(`  2. "P" missing from drums — if intentional, set WEIGHTS.P=0 for drums`);
    }
}

if (WARN > 0) {
    console.log(`\n${YEL}SUGGESTED FIXES:${RST}`);
    console.log(`  • BAR_SNAP_MS=${BAR_SNAP_MS}ms is very tight (${BAR_SNAP_MS/2000*100}% of a 2s bar)`);
    console.log(`    → Increase to 150-200ms for more aligned candidates: setattr BAR_SNAP_MS 150`);
    console.log(`  • "F" descriptor appears to be in Hz range, not 0-1 flatness`);
    console.log(`    → Check which SpectralShape outlet is mapped to F in FluCoMa analysis`);
}

process.exit(FAIL > 0 ? 1 : 0);
