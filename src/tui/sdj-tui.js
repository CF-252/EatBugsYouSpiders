// SDJ — Terminal UI
// run:  node sdj-tui.js
// deps: npm install blessed ws

const blessed   = require('blessed');
const WebSocket = require('ws');
const http      = require('http');
const fs        = require('fs');
const path      = require('path');
const { spawn } = require('child_process');
const dgram      = require('dgram');

// ── SKIN ──────────────────────────────────────────────────────────────────────
// This is the only thing users need to change to create a custom skin.
// Copy this block into a skin file and require() it, or edit in place.

const SKIN = {
  bg:         'default',    // terminal background (matches your terminal theme)
  fg:         'white',      // all text
  dim_fg:     'color7',     // medium white (between grey labels and bright bar fills)
  user_fg:    'magenta',    // user input lines only
  bar_full:   '█',     // █  filled block
  bar_empty:  ' ',          // empty portion of bar
  border:     'line',       // 'line' | 'none'
  border_fg:  'white',
};

// ── CONFIG ────────────────────────────────────────────────────────────────────

const CONFIG = {
  ws_host:      'localhost',    // Max/MSP WebSocket host
  ws_port:      8080,           // Max/MSP WebSocket port
  ollama_host:  'localhost',
  ollama_port:  11434,
  ollama_model: 'llama3.1:latest',
  reconnect_ms: 3000,
};

// ── STATE ─────────────────────────────────────────────────────────────────────

const state = {
  track:    'no track loaded',
  bpm:      0,
  key:      '?',
  slices:   [0, 0, 0, 0],
  running:  false,
  connected: false,
  lufs:     null,   // mix loudness LUFS  (null = no signal yet)
  dbfs:     null,   // mix true-peak dBFS
  stems: {
    vocals: { id: '--', pos: 0.0, C: 0, S: 0, E: 0, F: 0, P: 0, H: 0, T: 0, tC: null, tE: null, tF: null, tP: null, tH: null, tT: null, durMs: 0, timeMs: 0, lastPosTime: Date.now(), bars: 4, stay: 0.0, genre: '', track: '', weight: 1.0 },
    melody: { id: '--', pos: 0.0, C: 0, S: 0, E: 0, F: 0, P: 0, H: 0, T: 0, tC: null, tE: null, tF: null, tP: null, tH: null, tT: null, durMs: 0, timeMs: 0, lastPosTime: Date.now(), bars: 4, stay: 0.0, genre: '', track: '', weight: 1.0 },
    bass:   { id: '--', pos: 0.0, C: 0, S: 0, E: 0, F: 0, P: 0, H: 0, T: 0, tC: null, tE: null, tF: null, tP: null, tH: null, tT: null, durMs: 0, timeMs: 0, lastPosTime: Date.now(), bars: 4, stay: 0.0, genre: '', track: '', weight: 1.0 },
    drums:  { id: '--', pos: 0.0, C: 0, S: 0, E: 0, F: 0, P: 0, H: 0, T: 0, tC: null, tE: null, tF: null, tP: null, tH: null, tT: null, durMs: 0, timeMs: 0, lastPosTime: Date.now(), bars: 4, stay: 0.0, genre: '', track: '', weight: 1.0 },
  },
  beats: { meter: 0, bpm: 0, conf: 0.0 },
  params: {
    quant: true, envelope: 'hann',
    matchProb: 0.9,   // single global (collapsed from per-descriptor)
    entropy:   0.0,   // macro 0=order 1=chaos
    matchC: 0.0, matchS: 0.0, matchE: 0.0, matchF: 0.0, matchP: 0.0, matchH: 0.0, matchT: 0.0,
    dirC:   0.0, dirS:   0.0, dirE:   0.0, dirF:   0.0, dirP:   0.0, dirH:   0.0, dirT:   0.0,
  },
  gain: { vocals: 1.0, melody: 1.0, bass: 1.0, drums: 1.0 },
  mute: { vocals: 0,   melody: 0,   bass: 0,   drums: 0   },
  masterGain: 1.0,
  agentName: 'Cricket',  // localized — updates on language select
  mmtWindow: 4,          // momentum window size in bars (used by add_tension.py)
  log: [],
  followGraph: {         // followGraph[from][to] = weight 0–1
    vocals: {}, melody: {}, bass: {}, drums: {},
  },
};

// ── GENRE DB ──────────────────────────────────────────────────────────────────
let genreDb = {};
const GENRE_DB_PATH = path.join(__dirname, '..', 'genres.json');
try {
  genreDb = JSON.parse(fs.readFileSync(GENRE_DB_PATH, 'utf8'));
} catch (_) {}

// Pre-populate genre at startup with DREPTO (the default loaded track).
// Prefer a key containing 'DREPTO'; fall back to the first key in the DB.
{
  const drKey = Object.keys(genreDb).find(k => k.toUpperCase().includes('DREPTO'))
              || Object.keys(genreDb)[0];
  if (drKey && genreDb[drKey] && genreDb[drKey].genres && genreDb[drKey].genres.length) {
    const g = genreDb[drKey].genres[0].genre;
    Object.keys(state.stems).forEach(n => { state.stems[n].genre = g; });
  }
}

// ── ANALYSIS LIBRARY (slice counts for :nextTrack) ────────────────────────────
const LIBRARY_PATH = path.join(__dirname, '..', 'MAX', 'analysis_library.json');
function getSliceCountsForTrack(trackName) {
  // Returns { vocals, melody, bass, drums } slice counts from analysis_library.json.
  // Keys in library are like "TrackName_vocals.wav" → { vocals: { slices: {...} } }
  try {
    const lib = JSON.parse(fs.readFileSync(LIBRARY_PATH, 'utf8'));
    const stems = { vocals: 0, melody: 0, bass: 0, drums: 0 };
    const SUFFIXES = { vocals: '_vocals.wav', melody: '_other.wav', bass: '_bass.wav', drums: '_drums.wav' };
    for (const [fileKey, stemObj] of Object.entries(lib)) {
      const lk = fileKey.toLowerCase();
      for (const [stem, suffix] of Object.entries(SUFFIXES)) {
        if (lk.endsWith(suffix) && fileKey.startsWith(trackName)) {
          const data = Object.values(stemObj)[0];  // { slices: {...}, metadata: {...} }
          stems[stem] = data && data.slices ? Object.keys(data.slices).length : 0;
        }
      }
    }
    return stems;
  } catch (_) {
    return { vocals: 0, melody: 0, bass: 0, drums: 0 };
  }
}

// Average slice E (LUFS) per stem for a given track — used in :nextTrack display
function getSliceLufsForTrack(trackName) {
  try {
    const lib = JSON.parse(fs.readFileSync(LIBRARY_PATH, 'utf8'));
    const result  = { vocals: null, melody: null, bass: null, drums: null };
    const SUFFIXES = { vocals: '_vocals.wav', melody: '_other.wav', bass: '_bass.wav', drums: '_drums.wav' };
    for (const [fileKey, stemObj] of Object.entries(lib)) {
      const lk = fileKey.toLowerCase();
      for (const [stem, suffix] of Object.entries(SUFFIXES)) {
        if (lk.endsWith(suffix) && fileKey.startsWith(trackName)) {
          const data = Object.values(stemObj)[0];
          if (data && data.slices) {
            const Es = Object.values(data.slices).map(s => parseFloat(s.E)).filter(v => isFinite(v));
            if (Es.length > 0) result[stem] = Es.reduce((a, b) => a + b, 0) / Es.length;
          }
        }
      }
    }
    return result;
  } catch (_) { return null; }
}

// ── BEATS DB ──────────────────────────────────────────────────────────────────
let beatsDb = {};
const BEATS_DB_PATH = path.join(__dirname, '..', 'downbeats.json');

function reloadBeatsDb() {
  try {
    beatsDb = JSON.parse(fs.readFileSync(BEATS_DB_PATH, 'utf8'));
  } catch (_) { beatsDb = {}; }
}
reloadBeatsDb();

function reloadGenreDb() {
  try {
    genreDb = JSON.parse(fs.readFileSync(GENRE_DB_PATH, 'utf8'));
  } catch (_) { genreDb = {}; }
}

// "Electronic---Dub Techno" → { parent: "Electronic", sub: "Dub Techno" }
// "Rock"                    → { parent: "Rock",        sub: "Rock" }
function parseGenre(g) {
  if (!g) return { parent: '', sub: '' };
  const parts = g.split('---');
  return { parent: parts[0].trim(), sub: (parts[1] || parts[0]).trim() };
}

// Assign genre to one or all stems. Called at track load (all stems same source),
// and in future multi-source mode (per stem).
function setGenreForStem(stemName, genre) {
  if (state.stems[stemName]) state.stems[stemName].genre = genre;
}

function updateGenreForTrack(trackName) {
  const key = Object.keys(genreDb).find(k =>
    k.includes(trackName) || trackName.includes(k) || k === trackName
  );
  const genre = (key && genreDb[key].genres && genreDb[key].genres.length)
    ? genreDb[key].genres[0].genre
    : '';
  // For now all stems come from the same source — assign to all
  Object.keys(state.stems).forEach(n => setGenreForStem(n, genre));
}

function updateBeatsForTrack(trackName) {
  if (!trackName || trackName === 'no track loaded') {
    state.beats = { meter: 0, bpm: 0, conf: 0.0 };
    return;
  }
  // Strip stem suffix to get base track name (same logic as slicer.js)
  const base = trackName.replace(/_(vocals|melody|bass|drums|other|melo)(\.\w+)?$/i, '').trim();
  let entry = beatsDb[base];
  if (!entry) {
    const lower = base.toLowerCase();
    entry = Object.entries(beatsDb).find(([k]) => k.toLowerCase() === lower)?.[1];
  }
  state.beats = entry
    ? { meter: entry.meter || 4, bpm: entry.bpm || 0, conf: entry.confidence || 0 }
    : { meter: 0, bpm: 0, conf: 0.0 };
  if (entry && entry.key && entry.key !== '?') state.key = entry.key;
}

const DOWNBEAT_MIN_CONF = 0.4;  // must match slicer.js

function beatsHeaderLine() {
  const b = state.beats;
  if (!b.meter) return `{grey-fg}beats:{/grey-fg} --`;
  const confBar = Math.round(b.conf * 10);
  const bar = '●'.repeat(confBar) + '○'.repeat(10 - confBar);
  return `{grey-fg}beats:{/grey-fg} ${b.meter}/4 ${b.bpm.toFixed(0)}bpm ${bar}`;
}

function quantMode() {
  const p = state.params;
  if (!p.quant) return 'off';
  const b = state.beats;
  return (b.meter && b.conf >= DOWNBEAT_MIN_CONF) ? 'beat' : 'grid';
}

// ── TRACK BROWSER ─────────────────────────────────────────────────────────────
let browseList = [];
let browseIdx  = -1;

function getBrowseList() {
  const keys = new Set([...Object.keys(beatsDb), ...Object.keys(genreDb)]);
  return [...keys].sort((a, b) => a.localeCompare(b));
}

function showBrowsedTrack() {
  const name  = browseList[browseIdx];
  const beats = beatsDb[name] || {};
  const bpm   = beats.bpm    || 0;
  const meter = beats.meter  || 4;
  const key   = (beats.key && beats.key !== '?') ? beats.key : '?';
  const conf  = beats.confidence || 0;
  const confBar = '●'.repeat(Math.round(conf * 10)) + '○'.repeat(10 - Math.round(conf * 10));
  const genreEntry = genreDb[name];
  const genreStr = (genreEntry && genreEntry.genres && genreEntry.genres.length)
    ? genreEntry.genres[0].genre : '';
  const genreRaw = parseGenre(genreStr);
  const genre = genreRaw.sub && genreRaw.sub !== genreRaw.parent
    ? `${genreRaw.parent} · ${genreRaw.sub}`
    : (genreRaw.parent || '--');
  const n = browseIdx + 1, total = browseList.length;
  const sc   = getSliceCountsForTrack(name);
  const lufs = getSliceLufsForTrack(name);
  const sliceStr = `voc:${sc.vocals} mel:${sc.melody} bas:${sc.bass} drm:${sc.drums}`;
  const fmt  = v => v !== null ? v.toFixed(1) : '--';
  const lufsStr = lufs
    ? `voc:${fmt(lufs.vocals)} mel:${fmt(lufs.melody)} bas:${fmt(lufs.bass)} drm:${fmt(lufs.drums)}`
    : '--';
  logSys(
    `[${n}/${total}] ${name}\n` +
    `  key: ${key}   bpm: ${bpm.toFixed(1)}   meter: ${meter}/4   conf: ${conf.toFixed(2)} ${confBar}\n` +
    `  genre: ${genre}\n` +
    `  slices: ${sliceStr}\n` +
    `  avg LUFS: ${lufsStr}`
  );
}

function browseNext() {
  browseList = getBrowseList();
  if (browseList.length === 0) { logSys('no tracks in bank'); return; }
  browseIdx = (browseIdx + 1) % browseList.length;
  showBrowsedTrack();
}

function browsePrev() {
  browseList = getBrowseList();
  if (browseList.length === 0) { logSys('no tracks in bank'); return; }
  browseIdx = (browseIdx - 1 + browseList.length) % browseList.length;
  showBrowsedTrack();
}

// ── TAGGER ────────────────────────────────────────────────────────────────────
let taggerRunning  = false;
const SPIN_FRAMES  = ['⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏'];
let   spinFrame    = 0;
let   spinInterval = null;
let   spinLabel    = '';
let   spinProgress = '';    // white progress-bar portion ('' = none)
let   flucomaTimer = null;  // fake-progress timer for FluCoMa
let   hasEverStarted = false; // sparklines stay once :start has been pressed

function renderSpinner() {
  if (!languageSelected) return;
  const agent   = `${state.agentName.toLowerCase()} — `;
  const frame   = SPIN_FRAMES[spinFrame];
  const content = spinProgress
    ? `{cyan-fg}${agent}{/cyan-fg}{grey-fg}${spinLabel} ${spinProgress} ${frame}{/grey-fg}`
    : `{cyan-fg}${agent}{/cyan-fg}{grey-fg}${spinLabel} ${frame}{/grey-fg}`;
  sepBox.setContent(content);
}

function startSpinner(label) {
  spinLabel    = label;
  spinProgress = '';
  spinFrame    = 0;
  if (spinInterval) clearInterval(spinInterval);
  spinInterval = setInterval(() => {
    spinFrame = (spinFrame + 1) % SPIN_FRAMES.length;
    renderSpinner();
    scheduleRender();
  }, 120);
}

function stopSpinner() {
  if (spinInterval) { clearInterval(spinInterval); spinInterval = null; }
  if (flucomaTimer) { clearInterval(flucomaTimer); flucomaTimer = null; }
  spinLabel    = '';
  spinProgress = '';
  sepBox.setContent(languageSelected ? '' : '{white-fg}@!@#?{/white-fg}');
  scheduleRender();
}

// Fake-progress timer for FluCoMa: increments 0→95% over ~3 min, then 100% on analysisDone
function startFlucomaProgress() {
  if (flucomaTimer) clearInterval(flucomaTimer);
  let pct = 0;
  flucomaTimer = setInterval(() => {
    if (pct < 95) pct = Math.min(95, pct + 1);
    const filled = Math.round(pct / 10);
    spinProgress = '█'.repeat(filled) + '░'.repeat(10 - filled) + ' ' + pct + '%';
  }, 2000);  // ~3 min to reach 95%
}

// python3.10 has madmom + essentia; demucs_env has neither
const ANALYSIS_PY  = '/opt/homebrew/bin/python3.10';
const HTDEMUCS_ROOT = path.join(__dirname, '..', 'stems', 'htdemucs');
const ANALYSIS_ENV  = Object.assign({}, process.env, {
  PATH: '/opt/homebrew/bin:/usr/local/bin:' + (process.env.PATH || '')
});

function spawnProc(args, label, filter, onDone) {
  const proc = spawn(ANALYSIS_PY, args, { env: ANALYSIS_ENV });
  const test = filter ? (l => l.trim() && !filter.test(l)) : (l => l.trim());
  proc.stderr.on('data', d => d.toString().trim().split('\n').forEach(l => { if (test(l)) logSys(l.trim()); }));
  proc.stdout.on('data', d => d.toString().trim().split('\n').forEach(l => { if (test(l)) logSys(l.trim()); }));
  proc.on('error', err => { logSys(`${label} error: ${err.message}`); stopSpinner(); if (onDone) onDone(-1); });
  proc.on('close', code => { if (onDone) onDone(code); });
}

function runMadmomTagger(onDone) {
  logSys('→ madmom: analyzing stems/htdemucs …');
  const script = path.join(__dirname, '..', 'madmom_tagger.py');
  const out    = path.join(__dirname, '..', 'downbeats.json');
  const noise  = /No network created|last created network|WARNING.*network/i;
  spawnProc([script, '--htdemucs-root', HTDEMUCS_ROOT, '--out', out], 'madmom', noise, code => {
    if (code === 0) { reloadBeatsDb(); logSys('✓ madmom done'); sendToMax('reloadDownbeats'); }
    else logSys(`madmom exited with code ${code}`);
    if (onDone) onDone(code);
  });
}

function runGenreTagger(onDone) {
  logSys('→ genre: analyzing stems/htdemucs …');
  const script = path.join(__dirname, '..', 'genre_tagger.py');
  const out    = path.join(__dirname, '..', 'genres.json');
  spawnProc([script, '--htdemucs-root', HTDEMUCS_ROOT, '--out', out], 'genre', null, code => {
    if (code === 0) { reloadGenreDb(); updateGenreForTrack(state.track); logSys('✓ genre done'); scheduleRender(); }
    else logSys(`genre_tagger exited with code ${code}`);
    if (onDone) onDone(code);
  });
}

// Run genre + madmom sequentially, then trigger FluCoMa analysis in Max.
// Spinner stops when Max sends back { type: 'analysisDone' }.
function runFullAnalysis() {
  if (taggerRunning) { logSys('analysis already running'); return; }
  taggerRunning = true;
  startSpinner('genre…');
  logSys('→ analyzeAll: genre + beats + descriptors …');
  runGenreTagger(() => {
    startSpinner('beats…');
    runMadmomTagger(() => {
      reloadGenreDb();
      reloadBeatsDb();
      updateGenreForTrack(state.track);
      updateBeatsForTrack(state.track);
      sendToMax('reloadDownbeats');
      // Trigger FluCoMa descriptor analysis in Max — spinner stops on 'analysisDone'
      startSpinner('flucoma…');
      startFlucomaProgress();
      logSys('→ Max: startAnalysis …');
      sendToMax('startAnalysis');
      taggerRunning = false;
      // Safety fallback: stop spinner after 5 min if Max never replies
      setTimeout(() => { if (spinLabel === 'flucoma…') { stopSpinner(); logSys('⚠ analysisDone not received — spinner stopped'); } }, 5 * 60 * 1000);
    });
  });
}

// Build the genre header line — weighted by stem energy × track weight.
// The loudest/heaviest stem's genre leads; others appear as influences if different.
function genreHeaderLine() {
  const stemNames = ['vocals', 'melody', 'bass', 'drums'];

  const weighted = stemNames
    .map(n => {
      const s      = state.stems[n];
      const parsed = parseGenre(s.genre);
      const e      = parseFloat(s.E) || -60;
      const w      = parseFloat(s.weight) || 1.0;
      const dominance = Math.pow(10, e / 20) * w;  // LUFS → linear, scaled by user weight
      return { parsed, dominance };
    })
    .filter(x => x.parsed.parent);

  if (weighted.length === 0) return `{grey-fg}genre:{/grey-fg} --`;

  weighted.sort((a, b) => b.dominance - a.dominance);

  const p0 = weighted[0].parsed;
  const primary = (p0.parent && p0.sub && p0.sub !== p0.parent)
    ? `${p0.parent} · ${p0.sub}`
    : (p0.parent || p0.sub);

  // Collect genres from other stems that differ from the primary
  const seen = new Set([primary]);
  const influences = [];
  for (let i = 1; i < weighted.length; i++) {
    const pi = weighted[i].parsed;
    const g = (pi.parent && pi.sub && pi.sub !== pi.parent)
      ? `${pi.parent} · ${pi.sub}`
      : (pi.parent || pi.sub);
    if (g && !seen.has(g)) { influences.push(g); seen.add(g); }
  }

  if (influences.length === 0) return `{grey-fg}genre:{/grey-fg} ${primary}`;
  return `{grey-fg}genre:{/grey-fg} ${primary} {grey-fg}+{/grey-fg} ${influences.join(' · ')}`;
}

// ── SCREEN + LAYOUT ───────────────────────────────────────────────────────────

const screen = blessed.screen({
  smartCSR:    true,
  fullUnicode: true,
  title:       'EBYS 0.1.5',
  mouse:       true,
});

// Enable all-motion mouse tracking — captures every mouse event so the
// terminal has nothing left to interpret as a text selection drag.
process.stdout.write('\x1b[?1003h\x1b[?1006h');
process.on('exit', () => process.stdout.write('\x1b[?1003l\x1b[?1006l\x1b[?1000l'));

// ── DESCRIPTOR DOT GRID (per stem) ────────────────────────────────────────────
// 6 columns = descriptors C E F P H T
// 3 rows    = levels: row 0 = HIGH (>0.66), row 1 = MID, row 2 = LOW (<0.33)
// One dot per column is lit (●), showing where the current slice sits
// in each descriptor's range relative to all slices of that stem.

const GRAPH_W    = 11;   // 6 descriptors + 5 spaces
const GRAPH_ROWS  = 2;   // bar line + desc line
const GRAPH_SEP   = 0;   // no blank separator between stems

// Normalisation ranges written by ws_server.js after each buildIndex.
// Using a dedicated small file avoids Max JS's 32767-byte JsFile write limit
// that truncates ebys_index.json.
const RANGES_PATH = path.join(__dirname, '..', 'MAX', 'stem_ranges.json');
let   stemRanges  = {};

// ── Novelty history ───────────────────────────────────────────────────────────
const NOVELTY_HISTORY_LEN = 12;
const SPARK_CHARS         = '▁▂▃▄▅▆▇█';  // 8 levels; ▁ is the floor (thin, bottom-anchored)
const SPARK_FLOOR         = '▁';          // LOWER ONE EIGHTH BLOCK — thinnest bottom-anchored char
const noveltyHistory      = { vocals: [], melody: [], bass: [], drums: [] };
const noveltyPrevDesc     = {}; // last recorded descriptor snapshot per stem
const stemSliceStartPos   = {}; // track pos (0-1) at the moment each slice started
const stemSliceStartTime  = {}; // wall-clock ms when each slice started playing
let   playbackStopped     = false; // true after :stop, cleared by :start
const vuLevels            = { vocals: 0, melody: 0, bass: 0, drums: 0, master: 0 };

// ── VU BAR ────────────────────────────────────────────────────────────────────
// level: 0–1 linear peak amplitude (from peakamp~ in Max)
// Returns a 12-dot bar using ●/○ (filled/empty circles) with green/yellow/red zones.
const VU_W       = 12;
const VU_MIN_DB  = -60;
const VU_GREEN   = Math.round(VU_W * 0.80);  // chars 0–9  → green  (below -12 dB)
const VU_YELLOW  = Math.round(VU_W * 0.95);  // chars 10   → yellow (-12 to -3 dB)
                                              // chars 11   → red    (above -3 dB)
// Style: ●●●●●●●●●○○○  (● filled dot = signal, ○ empty dot = headroom)
// Other available styles (swap chars in the loop below):
//   Blocks:  █ / ░   (previous default)
//   Pipes:   ┃ / │
//   Squares: ■ / □
function vuBar(level) {
  const db     = level > 1e-7 ? 20 * Math.log10(level) : -70;
  const frac   = Math.max(0, Math.min(1, (db - VU_MIN_DB) / -VU_MIN_DB));
  const filled = Math.round(frac * VU_W);
  const empty  = VU_W - filled;
  let bar = '';
  for (let i = 0; i < filled; i++) {
    if (i < VU_GREEN)        bar += '{green-fg}●{/green-fg}';
    else if (i < VU_YELLOW)  bar += '{yellow-fg}●{/yellow-fg}';
    else                     bar += '{red-fg}●{/red-fg}';
  }
  return bar + `{grey-fg}${'○'.repeat(empty)}{/grey-fg}`;
}

function loadStemRanges() {
  try {
    const raw = JSON.parse(fs.readFileSync(RANGES_PATH, 'utf8'));
    if (raw && typeof raw === 'object') stemRanges = raw;
  } catch (e) { /* file not written yet — stay empty */ }
}
loadStemRanges();

// Mirrors the perceptual weights from slicer.js — E and T matter more,
// F matters less. Keeps novelty from being dominated by a single noisy dim.
const NOVELTY_WEIGHTS = { C: 1.0, S: 0.8, E: 2.0, F: 0.5, P: 1.5, H: 1.0, T: 1.5 };
const NOVELTY_WEIGHT_SUM = Object.values(NOVELTY_WEIGHTS).reduce((a, b) => a + b, 0);

// Weighted normalized distance in descriptor space between two slice snapshots.
// Returns 0–1 (roughly): 0 = identical, 1 = maximum weighted change across all dims.
function computeNovelty(curr, prev, stemName) {
  if (Object.keys(stemRanges).length === 0) loadStemRanges();
  const r = stemRanges[stemName];
  let sum = 0, totalW = 0;
  for (const d of ['C','E','F','P','H','T']) {
    const rng = r && r[d];
    if (!rng || rng.max === rng.min) continue;
    const delta = ((parseFloat(curr[d]) || 0) - (parseFloat(prev[d]) || 0)) / (rng.max - rng.min);
    const w = NOVELTY_WEIGHTS[d] || 1;
    sum   += w * delta * delta;
    totalW += w;
  }
  return totalW ? Math.sqrt(sum / totalW) : 0;
}

// Shared scale across all stems — all sparklines use the same reference.
// This prevents one stem's outlier from collapsing another stem's scale,
// and stops the abrupt "all bars jump high" when a lone outlier scrolls off.
const NOVELTY_GLOBAL_MIN = 0.05; // scale never drops below this — keeps small changes visible

function noveltyGlobalMax() {
  let m = NOVELTY_GLOBAL_MIN;
  for (const sn of ['vocals', 'melody', 'bass', 'drums']) {
    const h = noveltyHistory[sn];
    for (let i = 0; i < h.length; i++) if (h[i] > m) m = h[i];
  }
  return m;
}

// Momentum direction arrow from tension value (0–1).
// ↑ = building  ─ = stable  ↓ = releasing  · = no tension data
function tensionArrow(t) {
  if (t === null || t === undefined || isNaN(t)) return '·';
  if (t > 0.6) return '↑';
  if (t < 0.4) return '↓';
  return '─';
}

function sparkline(history, active) {
  // Before :start — blank. After :start — fills right→left as slices accumulate.
  if (!active) return ' '.repeat(NOVELTY_HISTORY_LEN);
  const buf = history.slice(-NOVELTY_HISTORY_LEN);
  if (!buf.length) return ' '.repeat(NOVELTY_HISTORY_LEN);
  const max = noveltyGlobalMax();
  return buf.map(v => SPARK_CHARS[Math.min(7, Math.round((v / max) * 7))]).join('').padStart(NOVELTY_HISTORY_LEN, ' ');
}

// Keep umapDb around (still written by ws_server.js) but no longer rendered.
let umapDb = {};
function loadUmapDb() {
  try { umapDb = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'MAX', 'umap_coords.json'), 'utf8')); }
  catch (e) { umapDb = {}; }
}
loadUmapDb();

const DIMS = ['C', 'S', 'E', 'F', 'P', 'H', 'T'];

// Range bar: shows current value as a ● cursor on a ━━━━ track within min-max range.
// width = number of inner characters (cursor included).
function rangeBar(val, stemName, dim, width) {
  width = width || 5;
  if (Object.keys(stemRanges).length === 0) loadStemRanges();
  const r = stemRanges[stemName];
  const rng = r && r[dim];
  if (!rng || rng.max === rng.min) {
    return `{white-fg}●{/white-fg}{grey-fg}${'─'.repeat(width - 1)}{/grey-fg}`;
  }
  const lv  = Math.max(0, Math.min(1, ((parseFloat(val) || 0) - rng.min) / (rng.max - rng.min)));
  const pos = Math.round(lv * (width - 1));
  return `{grey-fg}${'─'.repeat(pos)}{/grey-fg}{white-fg}●{/white-fg}{grey-fg}${'─'.repeat(width - 1 - pos)}{/grey-fg}`;
}

function renderStemGraph(stemName) {
  // Lazy-reload in case stem_ranges.json was written after startup
  if (Object.keys(stemRanges).length === 0) loadStemRanges();

  // Returns array of 6 tier indices (0=HIGH 1=MID 2=LOW), or null if no ranges yet
  if (Object.keys(stemRanges).length === 0) loadStemRanges();
  const s = state.stems[stemName];
  const r = stemRanges[stemName];
  if (!s || !r) return null;

  const levels = DIMS.map(d => {
    const rng = r[d];
    if (!rng || rng.max === rng.min) return 0.5;
    const val = parseFloat(s[d]) || 0;
    return Math.max(0, Math.min(1, (val - rng.min) / (rng.max - rng.min)));
  });
  return levels.map(lv => lv > 0.66 ? 0 : lv > 0.33 ? 1 : 2);
}

// ── ZONE 1 — Header (version + EBYS state) ───────────────────────────────────
const statusBox = blessed.box({
  top: 0, left: 0, width: '100%', height: 3,
  tags: true, wrap: true,
  style: { fg: SKIN.fg, bg: SKIN.bg },
});

// ── ZONE 2 — Progression bars + descriptors + inline scatter graph ────────────
const playBox = blessed.box({
  top: 3, left: 0, width: '100%', height: 8,
  tags: true, wrap: true,
  style: { fg: SKIN.fg, bg: SKIN.bg },
});
let fixedTop = 11; // 3 (statusBox) + playBox height — recalculated in render

// ── ZONE 2.5 — Separator (bars / chat) ───────────────────────────────────────
const sepBox = blessed.box({
  top: fixedTop, left: 0, width: '100%', height: 1,
  tags: true,
  style: { fg: 'grey', bg: SKIN.bg },
});

// ── ZONE 3 — Language selector (expands on boot, collapses after selection) ───
let langCollapsed = false;
let langContent   = '';
const langBox = blessed.box({
  top: fixedTop, left: 0, width: '100%', height: 1,
  tags: true, wrap: true,
  style: { fg: 'grey', bg: SKIN.bg },
});

// ── ZONE 4 — Command list (expands on boot, collapses to one-liner) ───────────
let cmdCollapsed = false;
let cmdContent   = '';
const cmdBox = blessed.box({
  top: fixedTop + 1, left: 0, width: '100%', height: 1,
  tags: true, wrap: true,
  scrollable: true, alwaysScroll: true, mouse: true,
  style: { fg: 'grey', bg: SKIN.bg, scrollbar: { bg: 'grey' } },
});

// ── ZONE 4.5 — Chat header (collapsed placeholder) ───────────────────────────
let chatCollapsed = false;
const chatHeaderBox = blessed.box({
  top: fixedTop + 2, left: 0, width: '100%', height: 1,
  tags: true,
  style: { fg: 'grey', bg: SKIN.bg },
});

// ── ZONE 5 — Chat with Cricket (scrollable) ───────────────────────────────────
const logBox = blessed.log({
  top:           fixedTop + 3,
  left:          0,
  width:         '100%',
  height:        screen.height - fixedTop - 3 - 1,
  tags:          true,
  scrollable:    true,
  alwaysScroll:  false,
  scrollOnInput: false,
  style:         { fg: SKIN.fg, bg: SKIN.bg },
});

// ── INPUT ────────────────────────────────────────────────────────────────────
let inputLines = 1;
const inputBox = blessed.textarea({
  bottom: 0, left: 0, width: '100%', height: 1,
  inputOnFocus: true, tags: false, wrap: true,
  style: { fg: SKIN.user_fg, bg: SKIN.bg },
});

// Spinner — top-right corner
const spinnerBox = blessed.text({
  top:    0,
  right:  0,
  width:  'shrink',
  height: 1,
  tags:   true,
  style:  { fg: 'grey', bg: SKIN.bg },
});

screen.append(statusBox);
screen.append(playBox);
screen.append(sepBox);
screen.append(langBox);
screen.append(cmdBox);
screen.append(chatHeaderBox);
screen.append(logBox);
screen.append(inputBox);
screen.append(spinnerBox);

// ── RENDER ────────────────────────────────────────────────────────────────────

function sliceBar(s, name, bpm, width) {
  const durMs   = s.durMs || 0;   // full stem buffer duration (ms)
  const bars    = s.bars  || 4;
  const safeBpm = Math.max(1, bpm || 120);

  // Prefer the actual segDurMs sent by slicer.js (threaded through ws_server).
  // Fall back to BPM-derived estimate only when not yet received.
  const segDurMs = (s.segDurMs > 0) ? s.segDurMs : (bars * 4 * 60000 / safeBpm);

  // Bracket position in the full stem buffer.
  // Use real fracs when available; fall back to startPos estimate.
  let startPos;
  if (s.sliceStart !== undefined) {
    startPos = s.sliceStart;
  } else {
    startPos = stemSliceStartPos[name] !== undefined ? stemSliceStartPos[name] : (s.pos || 0);
  }
  // Bracket width = segment duration / full stem duration (identical for all stems at same BPM/bars).
  const sliceFrac = durMs > 0 ? segDurMs / durMs : segDurMs / 300000;
  const endPos    = Math.min(1, startPos + sliceFrac);

  // Cursor = wall-clock elapsed since this slice started (0→1 over segDurMs).
  // Frozen at 0 when playback is stopped so the bar doesn't keep filling.
  const startTime = (!playbackStopped && stemSliceStartTime[name]) || 0;
  const elapsed   = startTime > 0 ? Date.now() - startTime : 0;
  const progress  = segDurMs > 0 ? Math.min(1, elapsed / segDurMs) : 0;

  // Map 0→1 progress onto character columns within the bracket.
  const startCh  = Math.floor(startPos * width);
  const endCh    = Math.min(width - 1, Math.ceil(endPos * width));
  const innerW   = Math.max(1, endCh - startCh - 1); // characters inside [ ]
  const filledW  = Math.round(progress * innerW);
  const emptyW   = innerW - filledW;

  const afterLen = Math.max(0, width - endCh - 1);

  return (
    `{grey-fg}${'─'.repeat(startCh)}[{/grey-fg}` +
    `{white-fg}${'█'.repeat(filledW)}{/white-fg}` +
    `{grey-fg}${'░'.repeat(emptyW)}]${'─'.repeat(afterLen)}{/grey-fg}`
  );
}

function pad(str, len) {
  return (str + ' '.repeat(len)).slice(0, len);
}

// Format milliseconds → H:MM:SS or M:SS
function fmtMs(ms) {
  if (!ms || ms <= 0) return '0:00:00';
  const totalSec = Math.floor(ms / 1000);
  const h  = Math.floor(totalSec / 3600);
  const m  = Math.floor((totalSec % 3600) / 60);
  const s  = totalSec % 60;
  const mm = String(m).padStart(2, '0');
  const ss = String(s).padStart(2, '0');
  return h > 0 ? `${h}:${mm}:${ss}` : `0:${mm}:${ss}`;
}

let renderPending = false;
let cachedLogH    = 0;

// ── ZONE LAYOUT ───────────────────────────────────────────────────────────────
function visWidth(text) {
  let cols = 0;
  for (const ch of text) {
    const cp = ch.codePointAt(0);
    // Directional marks and other zero-width formatting characters
    if (cp === 0x200E || cp === 0x200F ||
        cp >= 0x202A && cp <= 0x202E ||
        cp >= 0x2066 && cp <= 0x2069) continue;
    const wide =
      (cp >= 0x1100 && cp <= 0x115F) ||
      (cp >= 0x2E80 && cp <= 0x303E) ||
      (cp >= 0x3041 && cp <= 0x33FF) ||
      (cp >= 0x3400 && cp <= 0x4DBF) ||
      (cp >= 0x4E00 && cp <= 0x9FFF) ||
      (cp >= 0xA000 && cp <= 0xA4CF) ||
      (cp >= 0xAC00 && cp <= 0xD7AF) ||
      (cp >= 0xF900 && cp <= 0xFAFF) ||
      (cp >= 0xFE10 && cp <= 0xFE19) ||
      (cp >= 0xFE30 && cp <= 0xFE4F) ||
      (cp >= 0xFF01 && cp <= 0xFF60) ||
      (cp >= 0xFFE0 && cp <= 0xFFE6);
    cols += wide ? 2 : 1;
  }
  return cols;
}

function visLines(text, w) {
  const plain = text.replace(/\{[^}]+\}/g, '');
  if (!plain.trim()) return 1;
  return Math.max(1, Math.ceil(visWidth(plain) / Math.max(1, w)));
}

function buildLangList() {
  const w = Math.max(1, screen.width || 80);
  const N = LANGUAGES.length;

  const entries = LANGUAGES.map((l, i) => ({
    text:     `‎${i + 1}. ${l.label}`,           // LRM anchors RTL scripts (Arabic, Hebrew) left
    blessedW: visWidth(`${i + 1}. ${l.label}`) + 1,  // +1 for LRM (blessed counts it as 1 col)
  }));

  const maxEntW = Math.max(...entries.map(e => e.blessedW));
  const colW    = maxEntW + 8;                         // +8 gap absorbs CJK/syllabic width discrepancies
  const cols = Math.max(1, Math.floor(w / colW));

  // Distribute entries as evenly as possible:
  // first (N % cols) columns get one extra entry
  const baseH  = Math.floor(N / cols);
  const extras = N % cols;
  const colDefs = [];  // { start, height } per column
  let start = 0;
  for (let c = 0; c < cols; c++) {
    const h = c < extras ? baseH + 1 : baseH;
    colDefs.push({ start, height: h });
    start += h;
  }
  const maxRows = colDefs[0].height; // first col is tallest (or equal)

  const lines = [];
  for (let r = 0; r < maxRows; r++) {
    let line = '';
    for (let c = 0; c < cols; c++) {
      const { start: s, height: h } = colDefs[c];
      if (r >= h) break;                               // this column is shorter — stop row
      const { text, blessedW } = entries[s + r];
      const isLast = c === cols - 1 || (r >= h - 1 && c === cols - 1);
      line += isLast ? text : text + ' '.repeat(Math.max(0, colW - blessedW));
    }
    lines.push(line);
  }
  return lines.join('\n');
}

const MIN_LOG_H = 5; // always reserve this many lines for chat

function reflow() {
  const w = screen.width;
  const h = screen.height;

  const langHFull = langCollapsed
    ? 1
    : (langContent || '').split('\n').reduce((s, l) => s + visLines(l, w), 0);
  const cmdHFull  = cmdCollapsed
    ? 1
    : (cmdContent  || '').split('\n').reduce((s, l) => s + visLines(l, w), 0);

  // Layout order: sep → lang → chatHeader → cmd → log
  // chatHeader is always right below lang so :language and :chat stay together
  const chatHdrH = chatCollapsed ? 1 : 0;

  const available = h - fixedTop - 1 - langHFull - chatHdrH - (chatCollapsed ? 0 : MIN_LOG_H) - inputLines;
  const langH = langCollapsed ? 1 : Math.min(langHFull, Math.max(1, available + (chatCollapsed ? 0 : MIN_LOG_H)));
  const cmdH  = cmdCollapsed  ? 1 : Math.min(cmdHFull,  Math.max(1, Math.floor(h / 2)));

  sepBox.top = fixedTop;

  langBox.top    = fixedTop + 1;
  langBox.height = langH;

  // chatHeaderBox always sits immediately after langBox
  chatHeaderBox.top    = fixedTop + 1 + langH;
  chatHeaderBox.height = chatHdrH;
  chatHeaderBox.setContent(chatCollapsed ? '{grey-fg}:chat — type to expand{/grey-fg}' : '');

  cmdBox.top    = fixedTop + 1 + langH + chatHdrH;
  cmdBox.height = cmdH;

  const logTop = fixedTop + 1 + langH + chatHdrH + cmdH;
  if (chatCollapsed) {
    logBox.top    = logTop;
    logBox.height = 0;
    cachedLogH    = 0;
  } else {
    logBox.top = logTop;
    const newLogH = Math.max(MIN_LOG_H, h - logTop - inputLines);
    if (newLogH !== cachedLogH) {
      const wasBottom   = atBottom();
      const savedScroll = wasBottom ? -1 : logBox.getScroll();
      cachedLogH        = newLogH;
      logBox.height     = newLogH;
      if (!wasBottom) logBox.scrollTo(savedScroll);
    }
  }
}

function setLangContent(text) {
  langContent = text;
  langBox.setContent(text);
  reflow();
}

function setCmdContent(text) {
  cmdContent = text;
  cmdBox.setContent(text);
  reflow();
}
function scheduleRender() {
  if (renderPending) return;
  renderPending = true;
  setImmediate(() => { renderPending = false; render(); });
}

function render() {
  const w = screen.width;

  // Status
  const conn  = state.connected ? '{grey-fg}[CONNECTED]{/grey-fg}' : '{red-fg}[DISCONNECTED]{/red-fg}';
  const run   = state.running   ? '{grey-fg}[RUNNING]{/grey-fg}' : '{red-fg}[STOPPED]{/red-fg}';
  const sl    = state.slices.join('/');
  const p = state.params;
  const fmtDir = v => (v >= 0 ? '+' : '') + (parseFloat(v) || 0).toFixed(1);
  const fmtM   = v => (' ' + (parseFloat(v) || 0).toFixed(1)).slice(-4);
  const genreLine = genreHeaderLine();

  // Right-align a string flush with the timestamp column (w - 1)
  const withRight = (left, right) => {
    const leftVis  = left.replace(/\{[^}]+\}/g, '').length;
    const rightVis = right.replace(/\{[^}]+\}/g, '').length;
    const pad = Math.max(1, w - 1 - leftVis - rightVis);
    return left + ' '.repeat(pad) + right;
  };

  const matchStr = `{grey-fg}match{/grey-fg}  {grey-fg}M:{/grey-fg}${fmtM(p.matchM)} {grey-fg}E:{/grey-fg}${fmtM(p.matchE)} {grey-fg}F:{/grey-fg}${fmtM(p.matchF)} {grey-fg}P:{/grey-fg}${fmtM(p.matchP)} {grey-fg}H:{/grey-fg}${fmtM(p.matchH)} {grey-fg}T:{/grey-fg}${fmtM(p.matchT)}`;
  const dirStr   = `{grey-fg}dir{/grey-fg}    {grey-fg}M:{/grey-fg}${fmtDir(p.dirM)} {grey-fg}E:{/grey-fg}${fmtDir(p.dirE)} {grey-fg}F:{/grey-fg}${fmtDir(p.dirF)} {grey-fg}P:{/grey-fg}${fmtDir(p.dirP)} {grey-fg}H:{/grey-fg}${fmtDir(p.dirH)} {grey-fg}T:{/grey-fg}${fmtDir(p.dirT)}`;

  const envLine   = `{grey-fg}env:{/grey-fg} ${p.envelope}   {grey-fg}MMT window:{/grey-fg} ${state.mmtWindow} bars   {grey-fg}slices:{/grey-fg} ${sl}   {grey-fg}LUFSs:{/grey-fg} ${state.lufs !== null ? state.lufs.toFixed(1) : '--'}   {grey-fg}LUFSi:{/grey-fg} ${state.dbfs !== null ? state.dbfs.toFixed(1) : '--'}`;
  const genreBeatsLine = `${genreLine}   ${beatsHeaderLine()}   {grey-fg}quant:{/grey-fg} ${quantMode()}`;

  const masterVU  = vuBar(vuLevels.master || 0);
  const sLines = [
    withRight(`{red-fg}EBYS 0.1.5{/red-fg}   ${run}   ${conn}`, masterVU),
    `{grey-fg}track:{/grey-fg} ${(() => { const names = ['vocals','melody','bass','drums'].map(n => state.stems[n] && state.stems[n].track).filter(Boolean); const uniq = [...new Set(names)]; return uniq.length ? uniq.join('{grey-fg} · {/grey-fg}') : state.track; })()}   {grey-fg}key:{/grey-fg} ${state.key}${(state.bpm > 0 && !state.beats.bpm) ? `   {grey-fg}bpm:{/grey-fg} ${state.bpm}` : ''}`,
    withRight(envLine, matchStr),
    withRight(genreBeatsLine, dirStr),
    '',
  ];
  const statusH = sLines.reduce((h, l) =>
    h + Math.max(1, Math.ceil(visWidth(l.replace(/\{[^}]+\}/g,'')) / Math.max(1, w))), 0);
  statusBox.height = statusH;
  statusBox.setContent(sLines.join('\n'));
  playBox.top = statusH;

  // Playback bars — 2 lines per stem, graph merged inline as right column
  const stems  = ['vocals', 'melody', 'bass', 'drums'];
  const nameW  = 6;
  const TS_W   = 8;
  const barW   = Math.max(4, w - nameW - 3 - TS_W - 1 - VU_W - 1);
  const fmtN   = v => String(Math.round(parseFloat(v) || 0)).padStart(5);
  const sid    = id => String(id || '--').replace('slice_', '#').slice(0, 6).padEnd(6);
  const fmtF   = v => (parseFloat(v) || 0).toFixed(2).padStart(5);

  const playLines = [];
  stems.forEach((name, si) => {
    const s         = state.stems[name];
    const b         = sliceBar(s, name, state.beats.bpm || state.bpm || 120, barW);
    // Use slice_ms absolute position when available (most accurate).
    // Fall back to pos*durMs, then BPM estimate when neither is ready yet.
    const baseMs    = s.timeMs > 0
      ? s.timeMs
      : (s.durMs > 0
        ? Math.round(s.pos * s.durMs)
        : Math.round(s.pos * s.bars * 4 * 60000 / Math.max(1, state.bpm)));
    const posMs     = Math.max(0, state.running ? baseMs + (Date.now() - s.lastPosTime) : baseMs);
    const tsStr     = fmtMs(posMs).padStart(TS_W - 1);
    const subGenre  = parseGenre(s.genre).sub;
    const trackShort = s.track.length > 16 ? s.track.slice(0, 15) + '…' : s.track;

    // Fixed-width numbers — padStart (right-align) guarantees column width never overflows.
    // Widths chosen to fit the largest observed value for each descriptor.
    const nC = String(Math.round(parseFloat(s.C)||0)).padStart(5);   // up to 99999
    const nS = String(Math.round(parseFloat(s.S)||0)).padStart(4);   // usually 0-9
    const nE = (parseFloat(s.E)||0).toFixed(1).padStart(5);          // up to 99.9
    const nF = (parseFloat(s.F)||0).toFixed(2).padStart(7);          // -100.00 to 0.00
    const nP = String(Math.round(parseFloat(s.P)||0)).padStart(5);   // up to 99999
    const nH = (parseFloat(s.H)||0).toFixed(2).padStart(7);          // e.g. 1413.01
    const nT = (parseFloat(s.T)||0).toFixed(2).padStart(4);          // 0.00 to 1.00

    // Range bar: grey ━━●━━ showing where current value sits in observed min-max
    const rb  = (dim, val) => rangeBar(val, name, dim);

    // Row 0 — progress bar + timestamp + per-stem VU meter
    const vu = vuBar(vuLevels[name] || 0);
    playLines.push(`${pad(name, nameW)} : ${b} ${tsStr} ${vu}`);

    // Row 1 — M↑━━●━━ nnnnn   E↓━━━━●━ nnnnnn   …  aligned columns
    // Arrow sits between the descriptor letter and its range bar (replaces the space).
    const aC = tensionArrow(s.tC), aE = tensionArrow(s.tE), aF = tensionArrow(s.tF);
    const aP = tensionArrow(s.tP), aH = tensionArrow(s.tH), aT = tensionArrow(s.tT);
    const spark    = sparkline(noveltyHistory[name] || [], hasEverStarted);
    const descLine = `${pad('', nameW + 3)}C${aC} ${rb('C',s.C)} ${nC}   S· ${rb('S',s.S)} ${nS}   E${aE} ${rb('E',s.E)} ${nE}   F${aF} ${rb('F',s.F)} ${nF}   P${aP} ${rb('P',s.P)} ${nP}   H${aH} ${rb('H',s.H)} ${nH}   T${aT} ${rb('T',s.T)} ${nT}    [{/grey-fg}{white-fg}${spark}{/white-fg}{grey-fg}]    bars:${s.bars}  stay:${s.stay.toFixed(1)}  ${sid(s.id)}${subGenre ? '  [' + subGenre + ']' : ''}${s.track ? '  ' + trackShort : ''}`;
    playLines.push(`{grey-fg}${descLine}{/grey-fg}`);
  });

  // Calculate actual height accounting for line wrapping at current terminal width
  const playHeight = playLines.reduce((h, l) =>
    h + Math.max(1, Math.ceil(visWidth(l.replace(/\{[^}]+\}/g, '')) / Math.max(1, w))), 0);
  playBox.height = playHeight;
  playBox.setContent(playLines.join('\n'));

  fixedTop = statusH + 1 + playHeight;
  reflow();
  screen.render();
}

// ── NOVELTY (per-slice) ───────────────────────────────────────────────────────
// Novelty is recorded immediately on every slice change (id change), not on a timer.
// noveltyPrevDesc holds the descriptor snapshot of the previous slice per stem.
// On the very first slice there is no baseline yet → nothing pushed (history stays empty).
function recordNovelty(sn, newDesc) {
  const prev = noveltyPrevDesc[sn];
  if (prev) {
    const nov = computeNovelty(newDesc, prev, sn);
    noveltyHistory[sn].push(nov);
    if (noveltyHistory[sn].length > NOVELTY_HISTORY_LEN) noveltyHistory[sn].shift();
  }
  noveltyPrevDesc[sn] = { C: newDesc.C, E: newDesc.E, F: newDesc.F,
                           P: newDesc.P, H: newDesc.H, T: newDesc.T };
}

// ── CRICKET ───────────────────────────────────────────────────────────────────

// Commands Cricket can emit — any line starting with one of these goes to Max.
// Everything else is conversation and stays in the chat.
const COMMANDS = new Set([
  // playback
  'start', 'stop', 'applyNow',
  'next', 'selectSegment',
  'loop', 'unloop', 'unloopAll',
  // index
  'buildIndex', 'loadIndex', 'saveIndex',
  'reloadDownbeats', 'analyzeAll', 'tagBeats', 'info', 'reset',
  // slicing
  'setSegmentBars', 'setStayProb', 'setQuantize', 'setMaxSlices', 'setWindow',
  // tempo
  'setFallbackBPM', 'setGlobalBPM',
  // matching
  'setWeight', 'setMatchProb', 'setDirPref', 'setDirWeight', 'setTrackWeight', 'followStem',
  // entropy macro
  'setEntropy',
  // filters
  'setGenreFilter', 'clearGenreFilter', 'setKeyFilter', 'clearKeyFilter',
  // query
  'dumpDescriptors', 'selectRange', 'nextNearest',
  // audio — channel
  'setStemGain', 'setStemMute',
  // audio — master
  'setMasterGain',
  // audio — EQ
  'eqLow', 'eqMid', 'eqMidFreq', 'eqHigh', 'trim',
  // audio — spatial
  'setJoystick', 'setSpatialWidth',
  // audio — FX
  'fxSend', 'fxReturn', 'fxStereo',
  // TUI-only
  'showState', 'showCommands', 'chat', 'language',
  'nextTrack', 'prevTrack',
  'setMMT',
]);

function isCommand(line) {
  return COMMANDS.has(line.trim().split(/\s+/)[0]);
}

// Load CRICKET.md as the knowledge base
const CRICKET_MD_PATH = path.join(__dirname, '..', '..', 'CRICKET.md');
let cricketDocs = '';
try {
  cricketDocs = fs.readFileSync(CRICKET_MD_PATH, 'utf8');
  cricketDocs = cricketDocs.replace(
    /1\. \*\*Output ONLY commands\*\*[^\n]*/,
    '1. **Mix commands and conversation freely** — commands go one per line with no extra text on the same line, prose goes in normal sentences. You can do both in the same response.'
  );
} catch (e) {
  cricketDocs = '(CRICKET.md not found)';
}

// Load voice.md — extracted writing style
let voiceNote = '';
try { voiceNote = fs.readFileSync(path.join(__dirname, 'voice.md'), 'utf8').trim(); } catch (e) {}

// Load rules.md — explicit behavioral rules
let rulesNote = '';
try { rulesNote = fs.readFileSync(path.join(__dirname, 'rules.md'), 'utf8').trim(); } catch (e) {}

const CRICKET_SYSTEM = `You are Cricket, the control interface for EBYS — a generative audio collage engine that separates songs into stems (vocals, melody, bass, drums), analyzes every transient slice, and plays them back in real time using spectral descriptors.

EBYS stands for "Eat Bugs You Spider."

Default behavior: when the user gives a musical instruction, respond with engine commands only — one per line, no explanation.
When the user asks a question or starts a conversation, answer clearly and concisely.
You can mix commands and conversation in the same response when it makes sense.
Never invent command names. Only use the exact commands listed in the knowledge base. If a user asks to do something the engine cannot do (like loading a track), say so in plain text — do not make up a command for it.
Never repeat or quote the [current state] block back in your response. It is for your internal context only.
When the user asks to see the state, or when you bring the conversation back to EBYS, emit: showState
When the user asks what commands are available, asks for a list of commands, or asks how to control EBYS, emit: showCommands
Never emit showCommands when the user asks what a specific command or parameter DOES — that is a conversational question, answer it in plain language.
When a conversation goes off-topic, follow it — don't redirect immediately. Let it go for several exchanges. Only bring it back to EBYS naturally if there's an opening, never by force.
Do not use terms of endearment like "mon ami", "friend", "buddy", "mate" or similar. Be warm but don't name the relationship.

When explaining what a command or concept does:
- Use a concrete analogy or metaphor to anchor the idea before going technical.
- Show how values interact with each other — don't explain a parameter in isolation if it only makes sense alongside another.
- Give a short concrete example (what you'd type and what it would do to the sound).
- Keep it tight — one analogy, one example, done. No bullet-point dumps, no restating the same thing twice.
- Write like someone who knows the system deeply and enjoys explaining it, not like a manual.
${rulesNote ? `\n--- RULES (follow these exactly) ---\n${rulesNote}\n` : ''}${voiceNote ? `\n--- VOICE (mirror this writing style in conversation) ---\n${voiceNote}\n` : ''}
--- EBYS KNOWLEDGE BASE ---
${cricketDocs}`;

const chatHistory = [{ role: 'system', content: CRICKET_SYSTEM }];

// ── BAKE SESSION TRACKING ─────────────────────────────────────────────────────
// Captures the intent → Cricket attempt → user corrections loop for fine-tuning.
let bakeIntent     = '';   // last natural language message sent to Cricket
let bakeCricketCmds = [];  // commands Cricket generated from that intent
let bakeUserCmds    = [];  // manual :commands the user sent after Cricket's response

// ── BAKE LOOP STATE ───────────────────────────────────────────────────────────
// Full training bracket: :bake start → loop N bars → bakeRestore → repeat → :bake end
let bakeLoopBars     = 4;      // loop window in bars (set by :bakeloop)
let bakeSessionActive = false; // true while a training bracket is open
let bakeLoopTimer    = null;   // setInterval handle
let bakeAttempt      = 0;      // how many loops have completed this session
let bakeEndQueued    = false;  // :bake end called mid-loop — close at next boundary
let bakeSessionLabel = '';     // NL prompt for this session
let bakeFirstCmds    = null;   // commands from Cricket's first attempt (stored at loop 1 end)

function bakeLoopMs() {
    const bpm    = state.bpm > 0 ? state.bpm : 120;
    const meter  = 4;  // assume 4/4 for now
    return (60000 / bpm) * meter * bakeLoopBars;
}

function startBakeLoop(label) {
    if (bakeLoopTimer) clearInterval(bakeLoopTimer);
    bakeSessionActive = true;
    bakeEndQueued     = false;
    bakeAttempt       = 0;
    bakeFirstCmds     = null;
    bakeSessionLabel  = label;

    const ms = bakeLoopMs();
    logSys('🎯 bake: loop started — "' + label + '"  ' + bakeLoopBars + ' bars @ '
           + (state.bpm || 120) + ' BPM  (' + Math.round(ms / 1000) + 's/loop)');

    bakeLoopTimer = setInterval(() => {
        bakeAttempt++;

        // Store first attempt commands for training pair
        if (bakeAttempt === 1) {
            bakeFirstCmds = bakeCricketCmds.slice();
        }

        if (bakeEndQueued) {
            // This loop just finished — close the session
            stopBakeLoop(true);
            return;
        }

        // Reset ring buffers to snapshot, replay from frozen position
        sendToMax('bakeRestore');
        logSys('🔄 bake: loop ' + bakeAttempt + ' reset → bakeRestore');
    }, ms);
}

function stopBakeLoop(store) {
    if (bakeLoopTimer) { clearInterval(bakeLoopTimer); bakeLoopTimer = null; }
    bakeSessionActive = false;
    bakeEndQueued     = false;

    if (store && bakeSessionLabel) {
        const snapshot = {
            intent:           bakeSessionLabel,
            cricket_cmds:     bakeFirstCmds || bakeCricketCmds.slice(),
            user_corrections: bakeUserCmds.slice(),
            final_cmds:       [...(bakeFirstCmds || bakeCricketCmds), ...bakeUserCmds],
            attempts:         bakeAttempt,
        };
        if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify({ type: 'bake', ...snapshot }));
        }
        logSys('🫳 bake end — "' + bakeSessionLabel + '"  attempts: ' + bakeAttempt
               + '  stored first + last attempt');
    } else {
        logSys('bake aborted — nothing stored');
    }
}

function ts() {
  const now = new Date();
  const hh = String(now.getHours()).padStart(2, '0');
  const mm = String(now.getMinutes()).padStart(2, '0');
  return `{grey-fg}[${hh}:${mm}]{/grey-fg} `;
}

function atBottom() {
  return logBox.getScrollPerc() >= 99;
}

const LOG_NOISE = /No network created|last created network has been deleted|VisibleDeprecationWarning|absl::InitializeLog|mlir_graph_optimization|MLIR V1 optimization/i;

function appendLog(line) {
  if (LOG_NOISE.test(line)) return;
  const wasBottom = atBottom();
  const savedPos  = wasBottom ? -1 : logBox.getScroll();
  logBox.add(line);
  if (wasBottom) {
    logBox.setScrollPerc(100);
  } else {
    logBox.scrollTo(savedPos);
  }
  screen.render();
}

function logSys(text) {
  appendLog(`{grey-fg}${text}{/grey-fg}`);
}

// Zone 3 (lang) and Zone 4 (cmd) helpers — defined after reflow() above
const _C = 60;  // description column
const _r = (sig, desc) => sig.padEnd(_C) + desc;

const CMD_LINES = [
  '',
  'command list',
  '── view ──────────────────────────────────────────────────────────────────',
  ':language — type to expand   ·   :commands — toggle   ·   :chat — toggle',
  '',
  '── playback ──────────────────────────────────────────────────────────────',
  ':start  ·  :stop  ·  :applyNow',
  _r(':next vocals|melody|bass|drums',           'force-pick immediately'),
  _r(':selectSegment vocals|melody|bass|drums',  'queue next slice for stem'),
  _r(':loop <stem> <bars>',                      'lock stem to looping slice'),
  ':unloop <stem>  ·  :unloopAll',
  '',
  '── index ─────────────────────────────────────────────────────────────────',
  ':buildIndex  ·  :loadIndex  ·  :saveIndex',
  _r(':nextTrack / :prevTrack',                  'browse track bank — shows BPM, key, genre'),
  _r(':reloadDownbeats',                         'reload downbeats.json into Max'),
  _r(':info',                                    'dump slicer state to Max console'),
  _r(':reset',                                   'clear index + stop'),
  _r(':resetMemory',                             'wipe all analysis JSON (two-step)'),
  _r(':restartWatcher',                          'restart watch_demucs service (clears processed-file memory)'),
  _r(':tip',                                       'simulate payout — shows split based on active follow graph'),
  _r(':bakeloop <bars>',                           'set bake loop window length (default 4 bars)'),
  _r(':bake start <prompt>',                       'open training bracket — prompt is fed to NL translator, snapshots state, starts looping'),
  _r(':bake end',                                  'queue close at next loop boundary — stores first + last completed loop'),
  _r(':bake abort',                                'close bracket immediately — discards everything, releases engine'),
  _r(':resetAll',                                '⚠ wipe everything — stems, uploads, analysis, memory (Y/N)'),
  _r(':analyzeAll',                              'run genre (essentia) + beats (madmom) on all tracks'),
  _r(':tagBeats',                                'run madmom beat tagger only'),
  _r(':setMMT <bars>',                           'momentum window size (reruns tension calc)'),
  '',
  '── slicing ───────────────────────────────────────────────────────────────',
  _r(':setSegmentBars [stem] 0.5|1|2|4|8|16',   'bars/slice'),
  _r(':setStayProb [stem] 0.0–1.0',             '0=jump  1=loop'),
  _r(':setQuantize 0|1',                         'bar-locked cuts'),
  _r(':setMaxSlices N',                          'cap/stem  0=unlimited'),
  _r(':setWindow hann|hamming|blackman|rect',    'slice envelope shape'),
  '',
  '── tempo ─────────────────────────────────────────────────────────────────',
  _r(':setFallbackBPM 40–280',                   'fallback tempo'),
  _r(':setGlobalBPM 40–280',                     'BPM override  0=off'),
  '',
  '── matching ──────────────────────────────────────────────────────────────',
  _r(':setWeight C|S|E|F|P|H|T 0–5',             'descriptor weight'),
  _r(':setMatchProb C|S|E|F|P|H|T 0–1',          'transition tightness'),
  _r(':setDirPref C|S|E|F|P|H|T -1–1',           'direction bias  -1/0/1'),
  _r(':setDirWeight 0–5',                        'global direction bias strength'),
  _r(':setTrackWeight vocals|melody|bass|drums', '0–1  stem influence'),
  _r(':followStem <stem> <target> <weight> …',  'rewire stem to follow another stem\'s descriptors'),
  _r(':followStem <stem> self',                  'reset stem to read its own descriptors'),
  '',
  '── filters ───────────────────────────────────────────────────────────────',
  _r(':setGenreFilter <genre>',                  'restrict selection to tracks tagged with genre (e.g. Techno)'),
  _r(':clearGenreFilter',                        'remove genre restriction'),
  _r(':setKeyFilter <key>',                      'restrict selection to tracks in key (e.g. Am  C#  G)'),
  _r(':clearKeyFilter',                          'remove key restriction'),
  '',
  '── query ─────────────────────────────────────────────────────────────────',
  _r(':dumpDescriptors [stem]',                  'dump all slice descriptors'),
  _r(':selectRange [stem] C:lo,hi W:lo,hi E:lo,hi F:lo,hi P:lo,hi', 'pick random slice in range'),
].map(l => `{grey-fg}${l}{/grey-fg}`).join('\n');

function expandCmd() {
  cmdCollapsed = false;
  setCmdContent(CMD_LINES);
  screen.render();
}

function collapseCmd() {
  cmdCollapsed = true;
  setCmdContent('{grey-fg}:commands — type to expand{/grey-fg}');
  screen.render();
}

function expandLang() {
  langCollapsed = false;
  setLangContent(`{grey-fg}${buildLangList()}{/grey-fg}`);
  screen.realloc();
  screen.render();
}

function collapseLang() {
  langCollapsed = true;
  setLangContent(`{grey-fg}:language — type to expand{/grey-fg}`);
  screen.realloc();
  screen.render();
}

function collapseChat() {
  chatCollapsed = true;
  reflow();
  screen.realloc();
  screen.render();
}

function expandChat() {
  chatCollapsed = false;
  reflow();
  screen.realloc();
  screen.render();
}

function displayState() {
  const p = state.params;
  const stems = ['vocals', 'melody', 'bass', 'drums'];
  const stemLines = stems.map(n => {
    const s = state.stems[n];
    return `  ${n.padEnd(7)} slice:${s.id}  pos:${(s.pos*100).toFixed(0).padStart(3)}%  M:${String(s.C).padStart(5)}  E:${String(s.E).padStart(4)}  F:${(parseFloat(s.F)||0).toFixed(2)}  P:${String(s.P).padStart(5)}  H:${(parseFloat(s.H)||0).toFixed(2)}  T:${(parseFloat(s.T)||0).toFixed(2)}`;
  }).join('\n');
  logSys(
    `track: ${state.track}  bpm: ${state.bpm}  key: ${state.key}  running: ${state.running}\n` +
    `bars:${p.bars}  stay:${p.stay}  quant:${p.quant}\n` +
    stemLines
  );
}

function logUser(text) {
  appendLog(`${ts()}{${SKIN.user_fg}-fg}you:{/${SKIN.user_fg}-fg} ${text}`);
}

function logCricket(text) {
  appendLog(`${ts()}{cyan-fg}${state.agentName.toLowerCase()}:{/cyan-fg} ${text}`);
}

function buildStateContext() {
  const p = state.params;
  const stems = ['vocals', 'melody', 'bass', 'drums'];
  const stemInfo = stems.map(n => {
    const s = state.stems[n];
    return `  ${n}: slice ${s.id}, pos ${(s.pos * 100).toFixed(0)}%, M=${s.C}, E=${s.E}, F=${s.F}, P=${s.P}, H=${s.H}, T=${s.T}`;
  }).join('\n');
  return [
    `[current state]`,
    `track: ${state.track}  bpm: ${state.bpm}  key: ${state.key}`,
    `running: ${state.running}`,
    `params: bars=${p.bars} stay=${p.stay} quant=${p.quant}`,
    `stems:\n${stemInfo}`,
  ].join('\n');
}

let cricketThinking = false;
let cricketMsgCount = 0;  // used to throttle state injection

// Brew-style Braille spinner
const SPINNER_FRAMES = ['⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏'];
let spinnerFrame = 0;
let spinnerTimer = null;


function startChatSpinner() {
  spinnerFrame = 0;
  spinnerTimer = setInterval(() => {
    if (!languageSelected) return;
    spinnerFrame = (spinnerFrame + 1) % SPINNER_FRAMES.length;
    sepBox.setContent(`{cyan-fg}${state.agentName.toLowerCase()} - loading{/cyan-fg} {white-fg}${SPINNER_FRAMES[spinnerFrame]}{/white-fg}`);
  }, 100);
}

function stopChatSpinner() {
  if (spinnerTimer) { clearInterval(spinnerTimer); spinnerTimer = null; }
  sepBox.setContent(languageSelected ? '' : '{white-fg}@!@#?{/white-fg}');
  scheduleRender();
}

function processReply(reply, onCommand) {
  // Strip any [current state] block Cricket echoes back
  const cleaned = reply.replace(/\[current state\][\s\S]*?(?=\n\n|\n[^\s]|$)/i, '').trim();

  const cmdPattern = new RegExp(`(?=\\b(${[...COMMANDS].join('|')})\\b)`, 'g');
  const lines = cleaned.split('\n').flatMap(line => {
    if (isCommand(line) && line.trim().split(cmdPattern).filter(Boolean).length > 1) {
      return line.trim().split(cmdPattern).filter(Boolean).map(s => s.trim());
    }
    return [line];
  });
  const proseLines = [];
  lines.forEach(line => {
    if (isCommand(line)) {
      if (proseLines.length) { logCricket(proseLines.join('\n')); proseLines.length = 0; }
      appendLog(`{grey-fg}: ${line.trim()}{/grey-fg}`);
      if (onCommand) onCommand(line.trim());
    } else {
      proseLines.push(line);
    }
  });
  if (proseLines.length) {
    const t = proseLines.join('\n').trim();
    if (t) logCricket(t);
  }
}

function callCricket(text, onCommand) {
  if (cricketThinking) return;
  cricketThinking = true;

  cricketMsgCount++;
  // Inject live state every 4 messages so Cricket stays grounded without
  // constantly pivoting the conversation back to EBYS status
  const contextualText = (cricketMsgCount % 4 === 1)
    ? buildStateContext() + '\n\n' + text
    : text;
  chatHistory.push({ role: 'user', content: contextualText });

  startChatSpinner();

  // Trim history — keep system prompt + last 20 exchanges to avoid context overflow
  const MAX_HISTORY = 41; // 1 system + 20 pairs
  if (chatHistory.length > MAX_HISTORY) {
    chatHistory.splice(1, chatHistory.length - MAX_HISTORY);
  }

  const body = JSON.stringify({
    model:    CONFIG.ollama_model,
    messages: chatHistory,
    stream:   false,
  });

  function done() {
    cricketThinking = false;
    stopChatSpinner();
  }

  const req = http.request({
    hostname: CONFIG.ollama_host,
    port:     CONFIG.ollama_port,
    path:     '/api/chat',
    method:   'POST',
    headers:  { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) },
    timeout:  60000,  // 60s timeout
  }, res => {
    let data = '';
    res.on('data', c => data += c);
    res.on('end', () => {
      done();
      try {
        const json  = JSON.parse(data);
        const reply = json.message?.content || '';
        if (!reply) { logSys('no response — check CONFIG.ollama_model'); return; }
        chatHistory.push({ role: 'assistant', content: reply });
        processReply(reply, onCommand);
      } catch (e) {
        logSys('parse error: ' + e.message);
      }
    });
  });

  req.on('timeout', () => {
    req.destroy();
    done();
    logSys('ollama timed out — model may be overloaded');
  });

  req.on('error', () => {
    done();
    logSys('ollama unreachable — is it running? (localhost:11434)');
  });
  req.write(body);
  req.end();
}

// ── MAX/MSP WEBSOCKET ─────────────────────────────────────────────────────────

let ws = null;
let maxWasConnected = false;
let pendingConfirm = null;   // set by :resetMemory; holds callback for 'yes' response

function connectToMax() {
  ws = new WebSocket(`ws://${CONFIG.ws_host}:${CONFIG.ws_port}`);

  ws.on('open', () => {
    state.connected = true;
    maxWasConnected = true;
    logSys('connected to max');
    render();
    // Auto-build index so the flow is: pick language → set params → :start
    setTimeout(() => {
      sendToMax('buildIndex');
      logSys('→ buildIndex (auto)');
    }, 1500);
  });

  ws.on('message', data => {
    // Max sends JSON state updates:
    // { type: 'state', track, bpm, key, slices, running }
    // { type: 'stem',  name, id, pos, E, C }
    // { type: 'param', key, value }
    try {
      const msg = JSON.parse(data);
      if (msg.type === 'state') {
        // Don't let Max overwrite bpm/key with empty/zero values — preserve what the user set
        if (msg.bpm === 0 || msg.bpm === undefined) delete msg.bpm;
        if (!msg.key || msg.key === '?') delete msg.key;
        const prevTrack = state.track;
        Object.assign(state, msg);
        if (state.track !== prevTrack) {
          updateGenreForTrack(state.track);
          updateBeatsForTrack(state.track);
        }
      } else if (msg.type === 'desc' && state.stems[msg.name]) {
        // desc always arrives before seg (slicer.js outlet order) — just update state.
        // Novelty is computed when seg arrives, at which point state already has fresh descriptors.
        Object.assign(state.stems[msg.name], msg);
      } else if (msg.type === 'stem' && state.stems[msg.name]) {
        // seg arrives after desc, so state.stems[sn] already holds this slice's descriptors.
        // Compute novelty immediately — no timer, no pending flag.
        if (msg.id !== undefined && msg.id !== state.stems[msg.name].id) {
          const sn = msg.name;
          stemSliceStartPos[sn]  = parseFloat(msg.pos) || 0;
          stemSliceStartTime[sn] = Date.now();
          recordNovelty(sn, state.stems[sn]);
        }
        Object.assign(state.stems[msg.name], msg);
        if (msg.pos !== undefined) state.stems[msg.name].lastPosTime = Date.now();
        if (!state.running) state.running = true;
        if (!hasEverStarted) hasEverStarted = true;
      } else if (msg.type === 'stemTrack' && state.stems[msg.name]) {
        state.stems[msg.name].track = msg.track || '';
      } else if (msg.type === 'stemDurMs' && state.stems[msg.track]) {
        state.stems[msg.track].durMs = msg.ms;
      } else if (msg.type === 'vu') {
        if (vuLevels.hasOwnProperty(msg.name)) vuLevels[msg.name] = parseFloat(msg.level) || 0;
      } else if (msg.type === 'lufs') {
        // fluid.loudness~ perceptual loudness (K-weighted dBFS), sampled at 10 Hz
        // short     = short-term loudness  → state.lufs  (displayed as LUFSs in header)
        // integrated = integrated loudness → state.dbfs  (displayed as LUFSi in header)
        const s = parseFloat(msg.short);
        const i = parseFloat(msg.integrated);
        if (isFinite(s)) state.lufs = s;
        if (isFinite(i)) state.dbfs = i;
      } else if (msg.type === 'slice_ms' && state.stems[msg.name]) {
        state.stems[msg.name].timeMs = msg.timeMs || 0;
        // Reset elapsed-time anchor so the smooth-count starts from this slice position
        state.stems[msg.name].lastPosTime = Date.now();
      } else if (msg.type === 'entropy') {
        state.params.entropy   = msg.value;
        state.params.matchProb = msg.matchProb;
      } else if (msg.type === 'matchProb') {
        state.params.matchProb = msg.value;
      } else if (msg.type === 'param') {
        // Accept both new names (matchM/dirM) and legacy (matchC/dirC)
        const keyMap = { matchC: 'matchM', dirC: 'dirM', window: 'envelope' };
        const k = keyMap[msg.key] || msg.key;
        if (state.params.hasOwnProperty(k)) state.params[k] = msg.value;
        // Mirror gain/mute/masterGain into dedicated state fields
        const gainMatch = msg.key && msg.key.match(/^gain_(\w+)$/);
        const muteMatch = msg.key && msg.key.match(/^mute_(\w+)$/);
        if (gainMatch && state.gain[gainMatch[1]] !== undefined) state.gain[gainMatch[1]] = msg.value;
        if (muteMatch && state.mute[muteMatch[1]] !== undefined) state.mute[muteMatch[1]] = msg.value;
        if (msg.key === 'masterGain') state.masterGain = msg.value;
      } else if (msg.type === 'segmentBars') {
        // { type:'segmentBars', track:'drums'|'all', value:2 }
        const stems = msg.track === 'all' ? ['vocals','melody','bass','drums'] : [msg.track];
        stems.forEach(n => { if (state.stems[n]) state.stems[n].bars = msg.value; });
      } else if (msg.type === 'stayProb') {
        // { type:'stayProb', track:'bass'|'all', value:0.5 }
        const stems = msg.track === 'all' ? ['vocals','melody','bass','drums'] : [msg.track];
        stems.forEach(n => { if (state.stems[n]) state.stems[n].stay = msg.value; });
      } else if (msg.type === 'fileDetected') {
        logSys(`[+] new file: ${msg.filename}`);
        startSpinner('queued…');
      } else if (msg.type === 'pipelineStage') {
        const { stage, status, track, percent } = msg;
        if (status === 'start') {
          if (stage === 'demucs') {
            startSpinner('demucs 0%');
            logSys(`→ Demucs: separating "${track}" …`);
          } else if (stage === 'genre') {
            startSpinner('genre…');
            logSys('→ Essentia: classifying genre …');
          } else if (stage === 'madmom') {
            startSpinner('madmom…');
            logSys('→ madmom: detecting beats …');
          }
        } else if (status === 'progress' && stage === 'demucs') {
          const pct    = percent || 0;
          const filled = Math.round(pct / 10);
          spinLabel    = 'demucs';
          spinProgress = '█'.repeat(filled) + '░'.repeat(10 - filled) + ' ' + pct + '%';
          scheduleRender();
        } else if (status === 'done') {
          if (stage === 'demucs') logSys('✓ Demucs done — stems separated');
          else if (stage === 'genre') logSys('✓ genre classified');
          else if (stage === 'madmom') { logSys('✓ beats detected'); stopSpinner(); }
        } else if (status === 'error') {
          const errMsg = msg.msg || '';
          logSys(`✗ ${stage} FAILED ${errMsg} — check watchdemucs.log`);
          stopSpinner();
        }
      } else if (msg.type === 'streamUpdated') {
        // watch_demucs.py finished: genre + madmom written to disk, FluCoMa starting now.
        logSys('✓ genre + beats ready — starting FluCoMa…');
        reloadGenreDb();
        reloadBeatsDb();
        updateGenreForTrack(state.track);
        updateBeatsForTrack(state.track);
        if (spinLabel !== 'flucoma…') startSpinner('flucoma…');
        startFlucomaProgress();
        // Safety fallback: stop spinner after 5 min if analysisDone never arrives
        setTimeout(() => { if (spinLabel === 'flucoma…') { stopSpinner(); logSys('⚠ analysisDone not received — spinner stopped'); } }, 5 * 60 * 1000);
      } else if (msg.type === 'umapDone') {
        loadUmapDb();
        loadStemRanges();
        logSys('✓ UMAP ready — descriptor grids updated');
        scheduleRender();
      } else if (msg.type === 'analysisDone') {
        // Flash 100% bar briefly before clearing
        if (flucomaTimer) { clearInterval(flucomaTimer); flucomaTimer = null; }
        spinProgress = '██████████ 100%';
        setTimeout(() => {
          stopSpinner();
          logSys('✓ FluCoMa done — computing MMT…');
          startSpinner('mmt…');
          const tensionScript = path.join(__dirname, '..', 'add_tension.py');
          spawnProc([tensionScript], 'tension', null, code => {
            stopSpinner();
            if (code === 0) {
              logSys('✓ MMT computed');
              loadUmapDb(); loadStemRanges();  // pre-load in case UMAP already ran
              sendToMax('buildIndex');
              logSys('→ buildIndex — new tracks available');
            } else {
              logSys('⚠ add_tension.py failed (code ' + code + ')');
            }
          });
        }, 400);
      }
      scheduleRender();
    } catch (_) {}
  });

  ws.on('close', () => {
    state.connected = false;
    if (maxWasConnected) logSys('disconnected from max');
    maxWasConnected = false;
    render();
    setTimeout(connectToMax, CONFIG.reconnect_ms);
  });

  ws.on('error', () => {});
}

// ── EBYS LINK IPC ─────────────────────────────────────────────────────────────
// Talks to link_server.js (separate process) via localhost UDP.
//   TUI → link_server  : port 9001  (TOUCH / MISSILE / LINK_ON / etc.)
//   link_server → TUI  : port 9002  (incoming peer SET commands)

const LINK_IPC_SEND = 9001;   // port link_server listens on
const LINK_IPC_RECV = 9002;   // port we listen on for incoming peer params

// Keys whose values we track for missile switch + state dump
const LINK_TRACKED_VERBS = new Set([
  'setGlobalBPM', 'setFallbackBPM', 'setEntropy', 'setMatchProb',
  'setWeight', 'setDirPref', 'setDirWeight',
  'setStemGain', 'setMasterGain', 'fxSend',
  'eqLow', 'eqMid', 'eqMidFreq', 'eqHigh', 'trim',
]);

const linkSock = dgram.createSocket('udp4');

// Receive incoming peer params and apply them locally (as if user typed them)
const linkRecvSock = dgram.createSocket('udp4');
// Expand a link key back into a Max command.
// "setWeight_vocals_C"  → "setWeight vocals C"
// "setStemGain_vocals"  → "setStemGain vocals"
// "setEntropy"          → "setEntropy"
// "eqLow_bass"          → "eqLow bass"
// All verbs in LINK_TRACKED_VERBS are camelCase with no underscores,
// so a simple underscore→space expansion reconstructs the original command.
function expandLinkKey(key) {
  return key.replace(/_/g, ' ');
}

linkRecvSock.on('message', (buf) => {
  const line  = buf.toString().trim();
  const parts = line.split(' ');
  if (parts[0] === 'SET' && parts[1] && parts[2] !== undefined) {
    const cmd = expandLinkKey(parts[1]) + ' ' + parts[2];
    sendToMax(cmd);
    logSys('← LINK ' + cmd);
  } else if (parts[0] === 'PEER_OFFLINE') {
    logSys('⚠ LINK peer offline');
  } else if (parts[0] === 'PEER_ONLINE') {
    logSys('✓ LINK peer connected');
  }
});
linkRecvSock.bind(LINK_IPC_RECV);

function linkSend(msg) {
  const buf = Buffer.from(msg);
  linkSock.send(buf, 0, buf.length, LINK_IPC_SEND, '127.0.0.1');
}

// Notify link_server that a parameter was touched (updates last-touched register)
function linkTouch(command) {
  const parts = command.trim().split(/\s+/);
  if (!LINK_TRACKED_VERBS.has(parts[0])) return;
  // Flatten verb + args into a single key: e.g. "setWeight vocals C 0.8" → key="weight_vocals_C"
  // For simplicity, use the full command string as key/value split at verb
  const key   = parts[0] + '_' + parts.slice(1, -1).join('_');
  const value = parts[parts.length - 1];
  linkSend(`TOUCH ${key} ${value}`);
}

// ─────────────────────────────────────────────────────────────────────────────

function sendToMax(command) {
  if (ws && ws.readyState === WebSocket.OPEN) {
    ws.send(JSON.stringify({ type: 'command', text: command }));
  }
  linkTouch(command);   // always notify link_server, it filters by verb
}

// Expand :selectRange vocals C:200,2000 F:0.2,0.8  →  selectRange vocals 200 2000 -1e9 1e9 0.2 0.8 -1e9 1e9
function expandSelectRange(body) {
  const parts = body.trim().split(/\s+/);
  if (parts[0] !== 'selectRange') return body;
  let i = 1;
  let stem = null;
  if (parts[1] && !/^[CEFPcefp]:/.test(parts[1])) { stem = parts[1]; i = 2; }
  const ranges = { C: null, E: null, F: null, P: null };
  for (; i < parts.length; i++) {
    const m = parts[i].match(/^([CEFPcefp]):([-\d.]+),([-\d.]+)$/);
    if (m) ranges[m[1].toUpperCase()] = [parseFloat(m[2]), parseFloat(m[3])];
  }
  const INF = 1e9;
  const r = d => ranges[d] ? ranges[d] : [-INF, INF];
  const args = [...r('C'), ...r('E'), ...r('F'), ...r('P')].join(' ');
  return stem ? `selectRange ${stem} ${args}` : `selectRange ${args}`;
}

// ── INPUT HANDLING ────────────────────────────────────────────────────────────

function handleInput(text) {
  const trimmed = text.trim();
  if (!trimmed) return;

  // Two-step confirmation gate (e.g. :resetMemory, :resetAll)
  if (pendingConfirm) {
    const ans = trimmed.toLowerCase().replace(/^[:@]/, '').trim();
    if (ans === 'y' || ans === 'yes') {
      pendingConfirm();
    } else {
      logSys('cancelled');
    }
    pendingConfirm = null;
    return;
  }

  // Shared language lookup — works for number, @number, name, @name, code
  function findLang(query) {
    const q = query.replace(/^[@:]/, '').trim();
    const n = parseInt(q);
    return (!isNaN(n) && LANGUAGES[n - 1])
      || LANGUAGES_BASE.find(l =>
           l.label.toLowerCase().startsWith(q.toLowerCase()) ||
           l.code.toLowerCase() === q.toLowerCase()
         );
  }

  // Language selection gate — number, @name, or :name
  if (!languageSelected) {
    const n = parseInt(trimmed);
    const byNumber = !isNaN(n) && LANGUAGES[n - 1];
    const byAt     = trimmed.startsWith('@') ? findLang(trimmed) : null;
    const byColon  = trimmed.startsWith(':') ? findLang(trimmed) : null;
    const lang = byNumber || byAt || byColon;
    if (lang) {
      languageSelected = true;
      applyLanguage(lang);
    } else {
      logSys('🦗');
    }
    return;
  }

  // @ prefix: commands take priority, then language switching
  if (trimmed.startsWith('@') || trimmed.startsWith(':')) {
    const prefix = trimmed[0];
    const body   = trimmed.slice(1).trim();
    const parts  = body.split(/\s+/);
    const verb   = parts[0];

    // :bakeloop <bars> — set the loop window length
    if (verb === 'bakeloop') {
      const n = parseFloat(parts[1]);
      if (!isNaN(n) && n > 0) {
        bakeLoopBars = n;
        logSys('bake loop window: ' + bakeLoopBars + ' bars ('
               + Math.round(bakeLoopMs() / 1000) + 's @ ' + (state.bpm || 120) + ' BPM)');
      } else {
        logSys('bakeloop: current = ' + bakeLoopBars + ' bars  usage: :bakeloop <bars>');
      }
      return;
    }

    // :bake — training bracket commands
    if (verb === 'bake') {
      const sub = parts[1];

      // :bake start <prompt>
      if (sub === 'start') {
        if (bakeSessionActive) {
          logSys('bake already running — :bake abort first');
          return;
        }
        const label = parts.slice(2).join(' ');
        if (!label) { logSys('usage: :bake start <prompt>'); return; }

        // 1. Take ring buffer snapshot
        sendToMax('bakeSnapshot');

        // 2. Send label to Cricket (first attempt translation)
        bakeIntent      = label;
        bakeCricketCmds = [];
        bakeUserCmds    = [];
        callCricket(label, cmd => {
          const p = cmd.trim().split(/\s+/);
          if ((p[0] === 'setGlobalBPM' || p[0] === 'setFallbackBPM') && parseFloat(p[1]) > 0) {
            state.bpm = parseFloat(p[1]); render();
          }
          bakeCricketCmds.push(cmd.trim());
          sendToMax(expandSelectRange(cmd));
        });

        // 3. Start loop timer — loop resets to snapshot every N bars
        startBakeLoop(label);
        return;
      }

      // :bake end — queue close at next loop boundary
      if (sub === 'end') {
        if (!bakeSessionActive) { logSys('no bake session running'); return; }
        bakeEndQueued = true;
        logSys('bake: close queued — will store at next loop boundary');
        return;
      }

      // :bake abort — stop immediately, discard
      if (sub === 'abort') {
        if (!bakeSessionActive) { logSys('no bake session running'); return; }
        stopBakeLoop(false);
        return;
      }

      // :bake (no subcommand) — legacy: save current intent + corrections as a one-shot snapshot
      if (!bakeIntent) { logSys('nothing to bake — send a message to Cricket first'); return; }
      const snapshot = {
        intent:           bakeIntent,
        cricket_cmds:     bakeCricketCmds.slice(),
        user_corrections: bakeUserCmds.slice(),
        final_cmds:       [...bakeCricketCmds, ...bakeUserCmds],
      };
      if (ws && ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify({ type: 'bake', ...snapshot }));
      }
      logSys('🫳 baked — intent: "' + bakeIntent + '"  cricket: '
             + bakeCricketCmds.length + ' cmds  corrections: ' + bakeUserCmds.length);
      return;
    }

    // :resetMemory — two-step confirmation to wipe all analysis data
    if (verb === 'resetMemory') {
      logSys('⚠  This will erase ALL analysis data and reset the counter.');
      logSys('Type Y to confirm, anything else to cancel.');
      pendingConfirm = () => {
        sendToMax('resetMemory');
        logSys('→ memory cleared');
        render();
      };
      return;
    }

    // :tagBeats — run madmom tagger on all stems
    if (verb === 'tagBeats')   { if (!taggerRunning) { taggerRunning = true; runMadmomTagger(() => { taggerRunning = false; reloadBeatsDb(); updateBeatsForTrack(state.track); scheduleRender(); }); } else { logSys('tagger already running'); } return; }

    // :analyzeAll — run genre + madmom on all tracks in htdemucs
    if (verb === 'analyzeAll') { runFullAnalysis(); return; }

    // :resetAll — two-step confirmation: wipe everything and restart from scratch
    if (verb === 'resetAll') {
      logSys('⚠  RESET ALL — this will permanently delete:');
      logSys('   stems/htdemucs/  ·  raw_uploads/  ·  temp/');
      logSys('   analysis_library.json  ·  genres.json  ·  downbeats.json  ·  stream.txt');
      logSys('   Max slicer memory  ·  watch_demucs service');
      logSys('Type Y to confirm, anything else to cancel.');
      pendingConfirm = () => {
        const { execSync } = require('child_process');
        const INFRA = path.join(__dirname, '..');
        const errors = [];
        const wipe = (p) => { try { fs.rmSync(p, { recursive: true, force: true }); } catch (e) { errors.push(e.message); } };
        const writeEmpty = (p, content) => { try { fs.writeFileSync(p, content, 'utf8'); } catch (e) { errors.push(e.message); } };

        // 1. Empty stems/htdemucs/ (delete all track folders inside, keep the dir)
        const htRoot = path.join(INFRA, 'stems', 'htdemucs');
        if (fs.existsSync(htRoot)) {
          for (const entry of fs.readdirSync(htRoot)) {
            wipe(path.join(htRoot, entry));
          }
        }

        // 2. Empty raw_uploads/
        const rawUploads = path.join(INFRA, 'raw_uploads');
        if (fs.existsSync(rawUploads)) {
          for (const entry of fs.readdirSync(rawUploads)) {
            wipe(path.join(rawUploads, entry));
          }
        }

        // 3. Empty temp/
        const tempDir = path.join(INFRA, 'temp');
        if (fs.existsSync(tempDir)) {
          for (const entry of fs.readdirSync(tempDir)) {
            wipe(path.join(tempDir, entry));
          }
        }

        // 4. Reset JSON files to empty objects
        writeEmpty(LIBRARY_PATH,                          '{}');
        writeEmpty(path.join(INFRA, 'genres.json'),       '{}');
        writeEmpty(path.join(INFRA, 'downbeats.json'),    '{}');

        // 5. Delete stream.txt so streamWatcher's readFile returns null (no spurious bang)
        wipe(path.join(INFRA, 'stream.txt'));

        // 6. Reload in-memory DBs
        reloadGenreDb();
        reloadBeatsDb();

        // 7. Tell Max to wipe its slicer memory
        sendToMax('resetMemory');

        // 8. Restart watch_demucs service
        try {
          execSync(`launchctl kickstart -k gui/$(id -u)/com.ebys.watchdemucs`);
        } catch (e) { errors.push('watcher restart: ' + e.message); }

        if (errors.length) {
          logSys('⚠  resetAll finished with errors:');
          errors.forEach(e => logSys('   ' + e));
        } else {
          logSys('✓ resetAll complete — system is clean');
        }
        scheduleRender();
      };
      return;
    }

    // :restartWatcher — kill + restart watch_demucs launchd service (clears in-memory state)
    if (verb === 'restartWatcher') {
      const { execSync } = require('child_process');
      try {
        execSync(`launchctl kickstart -k gui/$(id -u)/com.ebys.watchdemucs`);
        logSys('✓ watcher restarted — drop files in raw_uploads to reprocess');
      } catch (e) {
        logSys('⚠ restartWatcher failed: ' + e.message);
      }
      return;
    }

    // :graph [X Y] [stem]  — change scatter plot axes / stem
    // e.g.  :graph C E        :graph P H vocals      :graph vocals
    if (verb === 'graph') {
      // :graph — show UMAP status / reload
      const stems = Object.keys(umapDb);
      if (!stems.length) {
        logSys('UMAP data not yet available.\n' +
               'Wire fluid.umap~ in Max (see comment in slicer.js) then :buildIndex.');
      } else {
        const counts = stems.map(s => `${s}:${Object.keys(umapDb[s]).length}`).join('  ');
        logSys(`UMAP loaded — ${counts}\nGraphs update automatically on slice change.`);
        loadUmapDb(); loadStemRanges();
        scheduleRender();
      }
      return;
    }

    if (verb === 'setMMT') {
      const n = parseInt(parts[1]);
      if (isNaN(n) || n < 1) { logSys('usage: :setMMT <bars>  e.g. :setMMT 8'); return; }
      state.mmtWindow = n;
      scheduleRender();
      logSys(`→ MMT window set to ${n} bars — recomputing momentum …`);
      const venvPy = path.join(__dirname, '..', 'demucs_env', 'bin', 'python3');
      const script = path.join(__dirname, '..', 'add_tension.py');
      const proc = spawn(venvPy, [script, '--window', String(n)]);
      proc.stderr.on('data', d => {
        d.toString().trim().split('\n').forEach(l => { if (l.trim()) logSys(l.trim()); });
      });
      proc.stdout.on('data', d => {
        d.toString().trim().split('\n').forEach(l => { if (l.trim()) logSys(l.trim()); });
      });
      proc.on('close', code => {
        if (code === 0) {
          logSys(`momentum recomputed (window=${n}) — sending buildIndex`);
          sendToMax('buildIndex');
        } else {
          logSys(`add_tension.py exited with code ${code}`);
        }
      });
      return;
    }

    if (verb === 'nextTrack') { browseNext(); return; }
    if (verb === 'prevTrack') { browsePrev(); return; }

    // Track follow graph locally so :tip can compute payouts
    if (verb === 'followStem') {
      const from = parts[1], to = parts[2], w = parseFloat(parts[3]);
      if (state.followGraph[from]) {
        if (to === 'self') {
          state.followGraph[from] = {};
        } else if (state.stems[to] && !isNaN(w)) {
          state.followGraph[from][to] = w / 100;
        }
      }
    }

    if (verb === 'tip') {
      const STEMS = ['vocals', 'melody', 'bass', 'drums'];
      const N = STEMS.length;

      // ── Curator share ─────────────────────────────────────────────────────
      const FLOOR = 0.40;
      // creative factors (edit_rate, spectral_dist, genre_div) not yet wired from Max
      const curatorShare = FLOOR;  // full eq: 0.40 + 0.60 × creative_factor
      const artistPool   = 1 - curatorShare;  // 0.60

      // ── Artist split (80/20 within artist pool) ───────────────────────────
      const base = 0.8 / N;

      // Sum incoming follows per stem
      const influence = {};
      STEMS.forEach(s => { influence[s] = 0; });
      STEMS.forEach(from => {
        Object.entries(state.followGraph[from] || {}).forEach(([to, w]) => {
          if (influence[to] !== undefined) influence[to] += w;
        });
      });
      const totalInfluence = STEMS.reduce((sum, s) => sum + influence[s], 0);

      const lines = ['── tip simulation ──────────────────'];
      lines.push(`  curator   ${(curatorShare * 100).toFixed(1)}%  (floor — creative factors not yet live)`);
      lines.push(`  ─────────────────────────────────`);
      STEMS.forEach(s => {
        const share      = totalInfluence > 0 ? influence[s] / totalInfluence : 0;
        const stemOfPool = base + 0.2 * share;
        const payout     = artistPool * stemOfPool;
        const pct        = (payout * 100).toFixed(1);
        const inf        = (share * 100).toFixed(1);
        lines.push(`  ${s.padEnd(7)}  ${pct}%  (of tip — influence ${inf}%)`);
      });
      lines.push(`  ─────────────────────────────────`);
      lines.push(`  artists   ${(artistPool * 100).toFixed(1)}%  total`);

      // Show active follow graph
      const edges = [];
      STEMS.forEach(from => {
        Object.entries(state.followGraph[from] || {}).forEach(([to, w]) => {
          edges.push(`${from} → ${to} ${(w * 100).toFixed(0)}%`);
        });
      });
      if (edges.length) {
        lines.push('');
        lines.push('follow graph:');
        edges.forEach(e => lines.push('  ' + e));
      } else {
        lines.push('');
        lines.push('no follow graph active — equal split');
      }
      lines.push('────────────────────────────────────');
      logSys(lines.join('\n'));
      return;
    }

    if (verb === 'reloadDownbeats') {
      reloadBeatsDb();
      reloadGenreDb();
      updateBeatsForTrack(state.track);
      sendToMax('reloadDownbeats');
      scheduleRender();
      return;
    }

    // ── EBYS LINK commands ───────────────────────────────────────────────────
    // :sendLink             → send last touched param to peer
    // :sendLink hold        → send full scope dump to peer
    // :link on / :link off  → enable / disable incoming sync
    // :linkscope all                   → dump full state on hold
    // :linkscope weights vocals        → dump all weights for stem on hold
    // :linkscope dirs bass             → dump all dirs for stem on hold
    // :linkscope single weight_vocals_C → dump one key on hold
    if (verb === 'sendLink') {
      if (parts[1] === 'hold') linkSend('MISSILE_HOLD');
      else                     linkSend('MISSILE');
      logSys('sendLink' + (parts[1] === 'hold' ? ' (hold)' : ''));
      return;
    }
    if (verb === 'link') {
      const onOff = (parts[1] || '').toLowerCase();
      if (onOff === 'on')       { linkSend('LINK_ON');  logSys('LINK on');  }
      else if (onOff === 'off') { linkSend('LINK_OFF'); logSys('LINK off'); }
      else logSys('usage: :link on | :link off');
      return;
    }
    if (verb === 'linkscope') {
      linkSend('MISSILE_SCOPE ' + parts.slice(1).join(' '));
      logSys('LINK scope: ' + parts.slice(1).join(' '));
      return;
    }
    // ─────────────────────────────────────────────────────────────────────────

    // @commands / :commands — toggle command panel
    if (verb === 'commands') { cmdCollapsed ? expandCmd() : collapseCmd(); return; }

    // :language — toggle language panel
    if (verb === 'language') { langCollapsed ? expandLang() : collapseLang(); return; }

    // :chat — toggle chat panel
    if (verb === 'chat') { chatCollapsed ? expandChat() : collapseChat(); return; }

    // @state / :state — show current state
    if (verb === 'state') { displayState(); return; }

    // @ alone — expand language list
    if (!body && prefix === '@') { langCollapsed ? expandLang() : collapseLang(); return; }

    // Check if verb is a known command
    if (COMMANDS.has(verb)) {
      if (verb === 'showState' || verb === 'state') { displayState(); return; }
      if (verb === 'showCommands') { cmdCollapsed ? expandCmd() : collapseCmd(); return; }
      if (verb === 'language') { langCollapsed ? expandLang() : collapseLang(); return; }
      if (verb === 'chat') { chatCollapsed ? expandChat() : collapseChat(); return; }
      if (verb === 'stop')  { playbackStopped = true; }
      if (verb === 'start') { playbackStopped = false; }
      if (verb === 'setGlobalBPM' || verb === 'setFallbackBPM') {
        const n = parseFloat(parts[1]);
        if (!isNaN(n) && n > 0) state.bpm = n;
      }
      if (verb === 'setTrackWeight') {
        const stem = parts[1], w = parseFloat(parts[2]);
        if (state.stems[stem] && !isNaN(w)) state.stems[stem].weight = w;
      }
      const expanded = expandSelectRange(body);
      bakeUserCmds.push(expanded);   // track as user correction for :bake
      sendToMax(expanded);
      logSys('→ ' + expanded);
      render();
      return;
    }

    // Otherwise: language switch (works with both @ and :)
    const lang = findLang(trimmed);
    if (lang) { applyLanguage(lang); return; }

    if (prefix === '@') {
      logSys('unknown — use :<language> to switch or :<command> to control EBYS');
      return;
    }

    // : prefix fallthrough (raw command to Max)
    sendToMax(body);
    logSys('→ ' + body);
    return;
  }

  // Natural language → Cricket → Max
  // Collapse commands panel on first chat message
  if (!cmdCollapsed) collapseCmd();
  logUser(trimmed);

  // New intent resets the bake session
  bakeIntent      = trimmed;
  bakeCricketCmds = [];
  bakeUserCmds    = [];

  callCricket(trimmed, cmd => {
    if (cmd === 'showState')    displayState();
    else if (cmd === 'showCommands') { cmdCollapsed ? expandCmd() : collapseCmd(); }
    else {
      const parts = cmd.trim().split(/\s+/);
      if ((parts[0] === 'setGlobalBPM' || parts[0] === 'setFallbackBPM') && parseFloat(parts[1]) > 0) {
        state.bpm = parseFloat(parts[1]);
        render();
      }
      bakeCricketCmds.push(cmd.trim());
      sendToMax(expandSelectRange(cmd));
    }
  });
}

// Quit
screen.key(['escape', 'C-c'], () => process.exit(0));


// Scroll
function scrollUp()   {
  logBox.scroll(-5);
  logBox.screen.render();
}
function scrollDown() {
  logBox.scroll(5);
  logBox.screen.render();
}

// Keyboard scroll — many terminal variants
inputBox.key(['pageup',   'S-up',   'shift+up'],   scrollUp);
inputBox.key(['pagedown', 'S-down', 'shift+down'], scrollDown);
screen.key( ['pageup',   'S-up',   'shift+up'],   scrollUp);
screen.key( ['pagedown', 'S-down', 'shift+down'], scrollDown);

// Mouse wheel scroll — direct handler bypasses element routing
screen.on('mouse', data => {
  if (data.action === 'wheelup' || data.action === 'wheeldown') {
    const dir = data.action === 'wheelup' ? -3 : 3;
    const overCmd = !cmdCollapsed
      && data.y >= cmdBox.top
      && data.y <  cmdBox.top + cmdBox.height;
    if (overCmd) { cmdBox.scroll(dir); screen.render(); }
    else          { logBox.scroll(dir); screen.render(); }
  }
});


screen.on('resize', () => {
  if (!langCollapsed) setLangContent(`{grey-fg}${buildLangList()}{/grey-fg}`);
  reflow(); render();
});

function updateInputSize() {
  const text = inputBox.getValue() || '';
  const cols = Math.max(1, screen.width);
  const needed = Math.max(1, Math.ceil((text.length + 1) / cols));
  if (needed !== inputLines) {
    inputLines = needed;
    inputBox.height = inputLines;
    reflow();
    screen.render();
  }
}

inputBox.on('keypress', () => setImmediate(updateInputSize));

// ── Command history (up/down arrow) ──────────────────────────────────────────
let cmdHistory = [];
let historyIdx = -1;

inputBox.key('up', () => {
  if (cmdHistory.length === 0) return;
  historyIdx = Math.min(historyIdx + 1, cmdHistory.length - 1);
  inputBox.setValue(cmdHistory[historyIdx]);
  updateInputSize();
  screen.render();
});

inputBox.key('down', () => {
  if (historyIdx <= 0) { historyIdx = -1; inputBox.setValue(''); updateInputSize(); screen.render(); return; }
  historyIdx--;
  inputBox.setValue(cmdHistory[historyIdx]);
  updateInputSize();
  screen.render();
});

inputBox.key('enter', () => {
  const text = inputBox.getValue().replace(/\n/g, ' ').trim();
  if (text) { cmdHistory.unshift(text); historyIdx = -1; }
  handleInput(text);
  inputBox.clearValue();
  inputLines = 1;
  inputBox.height = 1;
  reflow();
  inputBox.focus();
  screen.render();
});

// ── BOOT ──────────────────────────────────────────────────────────────────────

inputBox.focus();
connectToMax();
render();

// ── LANGUAGE SELECTION ────────────────────────────────────────────────────────

const LANGUAGES_BASE = [
  // Western Europe
  { code: 'en',  label: 'English',          name: 'Cricket'    },
  { code: 'fr',  label: 'Français',         name: 'Criquet'    },
  { code: 'qc',  label: 'Franglais',        name: 'Cricket'    },  // user spec
  { code: 'es',  label: 'Español',          name: 'Grillo'     },
  { code: 'de',  label: 'Deutsch',          name: 'Grille'     },
  { code: 'pt',  label: 'Português',        name: 'Grilo'      },
  { code: 'it',  label: 'Italiano',         name: 'Grillo'     },
  { code: 'nl',  label: 'Nederlands',       name: 'Krekel'     },
  { code: 'sv',  label: 'Svenska',          name: 'Syrsa'      },
  { code: 'no',  label: 'Norsk',            name: 'Siriss'     },
  { code: 'da',  label: 'Dansk',            name: 'Fårekylling'},
  { code: 'fi',  label: 'Suomi',            name: 'Sirkka'     },
  // Eastern Europe
  { code: 'ro',  label: 'Română',           name: 'Greier'     },
  { code: 'pl',  label: 'Polski',           name: 'Świerszcz'  },
  { code: 'cs',  label: 'Čeština',          name: 'Cvrček'     },
  { code: 'sk',  label: 'Slovenčina',       name: 'Svrček'     },
  { code: 'hu',  label: 'Magyar',           name: 'Tücsök'     },
  { code: 'bg',  label: 'Български',        name: 'Щурец'      },
  { code: 'sr',  label: 'Srpski',           name: 'Cvrčak'     },
  { code: 'hr',  label: 'Hrvatski',         name: 'Cvrčak'     },
  { code: 'uk',  label: 'Українська',       name: 'Цвіркун'    },
  { code: 'ru',  label: 'Русский',          name: 'Сверчок'    },
  { code: 'lt',  label: 'Lietuvių',         name: 'Svirplys'   },
  { code: 'lv',  label: 'Latviešu',         name: 'Circeņi'    },
  { code: 'et',  label: 'Eesti',            name: 'Siristaja'  },
  // Middle East
  { code: 'ar',  label: 'العربية',          name: 'صرصر'       },
  { code: 'he',  label: 'עברית',            name: 'צרצר'       },
  { code: 'tr',  label: 'Türkçe',           name: 'Cırcır'     },
  // Asia
  { code: 'ja',  label: '日本語',            name: 'コオロギ'    },
  { code: 'zh',  label: '中文',             name: '蟋蟀'        },
  { code: 'ko',  label: '한국어',            name: '귀뚜라미'    },
  // Africa
  { code: 'sw',  label: 'Kiswahili',        name: 'Nyenze'     },
  { code: 'ha',  label: 'Hausa',            name: 'Kirikiri'   },
  { code: 'yo',  label: 'Yorùbá',           name: 'Ìgbín'      },
  { code: 'am',  label: 'አማርኛ',            name: 'ቴምቢሎ'      },
  { code: 'zu',  label: 'isiZulu',          name: 'Ikhilikithi' },
  { code: 'ig',  label: 'Igbo',             name: 'Ogu'        },
  { code: 'so',  label: 'Soomaali',         name: 'Masaakiin'  },
  // Philippines
  { code: 'tl',  label: 'Filipino',         name: 'Kuliglig'   },
  { code: 'ceb', label: 'Cebuano',          name: 'Kuliglig'   },
  // First Nations
  { code: 'cr',  label: 'ᓀᐦᐃᔭᐍᐏᐣ',         name: 'Cricket'    },  // Cree
  { code: 'oj',  label: 'Ojibwe',           name: 'Cricket'    },  // Ojibwe
  { code: 'iu',  label: 'ᐃᓄᒃᑎᑐᑦ',          name: 'Cricket'    },  // Inuktitut
];

// Shuffle on every boot
const LANGUAGES = [...LANGUAGES_BASE].sort(() => Math.random() - 0.5);

// Localized cricket onomatopoeia per language code
const CHIRP = {
  // Western Europe
  en:  'CHIRP!',
  fr:  'CRIC !',
  qc:  'OSTI !',
  es:  '¡CRIC!',
  de:  'ZIRP!',
  pt:  'CRIC!',
  it:  'CRI-CRI!',
  nl:  'TJIRP!',
  sv:  'KRIX!',
  no:  'KRIX!',
  da:  'KRIK!',
  fi:  'SIRKKA!',
  // Eastern Europe
  ro:  'CRIC!',
  pl:  'CYK!',
  cs:  'CÍK!',
  sk:  'CÍK!',
  hu:  'CIRIP!',
  bg:  'ЩУРЕЦ!',
  sr:  'CVRČAK!',
  hr:  'CVRČAK!',
  uk:  'ЦВІРІНЬ!',
  ru:  'ЦИРК!',
  lt:  'ČIRPTI!',
  lv:  'ČIRKST!',
  et:  'SIRISTAB!',
  // Middle East
  ar:  '!صرصر',
  he:  '!צרצר',
  tr:  'CIR CIR!',
  // Asia
  ja:  'コロコロ！',
  zh:  '唧唧！',
  ko:  '귀뚤귀뚤!',
  // Africa
  sw:  'KRIK!',
  ha:  'KRIK!',
  yo:  'KRIK!',
  am:  'ቺርፕ!',
  zu:  'KRIK!',
  ig:  'KRIK!',
  so:  'KRIK!',
  // Philippines
  tl:  'KRIK!',
  ceb: 'KRIK!',
  // First Nations
  cr:  'CHIRP!',
  oj:  'CHIRP!',
  iu:  'CHIRP!',
};

function chirpFor(code) {
  return CHIRP[code] || 'CHIRP!';
}

function langInstruction(lang) {
  if (lang.code === 'qc') {
    return `\n\nLANGUAGE LOCK: Respond in franglais — québécois French grammar with English technical words mixed in naturally. Never translate these English words into French, always keep them in English:

track (never "piste" or "chanson"), stem (never "piste"), load/loader (never "charger"), split/splitter (never "séparer"), buffer (never "tampon"), loop (never "boucle"), slice (never "tranche"), beat (never "temps"), mix/mixer (never "mélanger"), plugin (never "module"), sample (never "échantillon"), file (never "fichier"), folder (never "dossier"), output (never "sortie"), input (never "entrée"), click (never "cliquer"), start (never "démarrer"), stop (never "arrêter"), reset (never "réinitialiser"), settings (never "paramètres"), feature (never "fonctionnalité").

Example: "les stems sont pas encore loadées" not "les pistes ne sont pas encore chargées". "tu veux splitter le track?" not "tu veux séparer la piste?". Short answers. Never use formal French.`;
  }
  return `\n\nLANGUAGE LOCK: You must respond ONLY in ${lang.label}. Never switch to any other language under any circumstances, regardless of what language the user writes in. This is absolute.`;
}

// Per-language model overrides — use a custom Ollama model when available
const LANG_MODELS = {
  qc: 'franglais',  // custom model with baked-in franglais vocabulary
};

function applyLanguage(lang) {
  sepBox.setContent('');
  // Switch Ollama model if this language has a custom one
  CONFIG.ollama_model = LANG_MODELS[lang.code] || 'llama3.1:latest';

  // Update system prompt
  chatHistory[0].content = chatHistory[0].content.replace(/\n\nLANGUAGE LOCK:[\s\S]*/, '');
  chatHistory[0].content += langInstruction(lang);
  // Inject a hard switch into the conversation so the model sees it in context
  chatHistory.push({ role: 'user',      content: `[LANGUAGE SWITCH] From this point forward you must respond exclusively in ${lang.label}. Do not use any other language.` });
  chatHistory.push({ role: 'assistant', content: chirpFor(lang.code) });
  state.langLabel  = lang.label;
  state.agentName  = lang.name || 'Cricket';
  logCricket(chirpFor(lang.code));
  collapseLang();
  expandCmd();
}

let languageSelected = false;

// Boot — show full language list in Zone 3, hide Zone 4 until language selected
setTimeout(() => {
  setLangContent(`{grey-fg}${buildLangList()}{/grey-fg}`);
  setCmdContent('');
  sepBox.setContent('{white-fg}@!@#?{/white-fg}');
  reflow();
  screen.render();
}, 200);

// Clock tick — keeps timestamps counting smoothly between Max messages
setInterval(() => { scheduleRender(); }, 100);

// Refresh playback bars on interval (position updates come from Max in real use)
setInterval(() => {
  // Demo: animate bars to show they work before Max is connected
  if (state.running) {
    ['vocals', 'melody', 'bass', 'drums'].forEach(name => {
      state.stems[name].pos = (state.stems[name].pos + 0.003) % 1.0;
    });
    render();
  }
}, 100);
