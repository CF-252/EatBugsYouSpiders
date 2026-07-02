// EBYS — Slice Writer  v6
// Four parallel tracks: vocals, melody, bass, drums.
// Each has global track metadata (BPM, confidence, track_name) and
// local per-onset slice descriptors (C, P, E, F — drums has no P).
//
// BPM is ALWAYS written. BPM_confidence is a quality flag (0–1).
// Gate is opt-in: send  set_bpm_gate 0.5  to enable it.  Default = 0 (off).
// track_name is always written — send  set_track_name <name>  before commit.
//
// ── Persistence ───────────────────────────────────────────────────────────────
//   All analyzed tracks are saved to analysis_library.json on disk.
//   On patch reload, loadLibrary() replays every replace message into
//   [dict analysis] automatically — no manual re-analysis needed.
//   set_track_name clears the library entry for that name so re-analysis
//   cleanly overwrites stale data.
//
// ── Dict structure ────────────────────────────────────────────────────────────
//   {track}::metadata::track_name
//   {track}::metadata::BPM_confidence
//   {track}::metadata::BPM
//   {track}::slices::slice_NNNN::time
//   {track}::slices::slice_NNNN::C     spectral centroid (Hz)      — display: M
//   {track}::slices::slice_NNNN::S     spectral spread (Hz)        — display: S
//   {track}::slices::slice_NNNN::P     pitch (Hz)                  — display: P  (no drums)
//   {track}::slices::slice_NNNN::E     loudness (LUFS)             — display: E
//   {track}::slices::slice_NNNN::F     spectral flatness (0–1)     — display: F
//   {track}::slices::slice_NNNN::H     dominant chroma bin (0–1)   — display: H
//   {track}::slices::slice_NNNN::M0    MFCC coeff 0                — display: T
//   {track}::slices::slice_NNNN::M1    MFCC coeff 1
//   {track}::slices::slice_NNNN::M2    MFCC coeff 2
//   {track}::slices::slice_NNNN::M3    MFCC coeff 3
//   {track}::slices::slice_NNNN::M4    MFCC coeff 4
//   {track}::slices::slice_NNNN::M5    MFCC coeff 5
//
// ── Key detection (Krumhansl-Schmuckler) ──────────────────────────────────────
//   Pitch values (Hz, P > 40) are accumulated during slice writes.
//   At write_meta_* time the histogram is correlated against 24 key profiles
//   and the best match (e.g. "C major", "A minor") is written to:
//     {track}::metadata::key
//   Drums are excluded (no P descriptor).
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0 — replace/clear messages  → [dict analysisLib]
//   1 — total slice count (all tracks in library combined) → number box
//   2 — last slice ID (e.g. "melo:slice_0042")             → message box
//   3 — trackExists response: 1 = already in library, 0 = new
//
// ── Inlet messages ────────────────────────────────────────────────────────────
//   Slice staging : set_vocals_time/C/P/E/F/H/M0-M5   write_vocals
//                   set_melo_time/C/P/E/F/H/M0-M5  write_melo
//                   set_bass_time/C/P/E/F/H/M0-M5  write_bass
//                   set_drum_time/C/E/F/H/M0-M5    write_drum  (no P)
//   Metadata      : set_meta_vocals_bpm/conf  write_meta_voc
//                   set_meta_melo_bpm/conf write_meta_melo
//                   set_meta_bass_bpm/conf write_meta_bass
//                   set_meta_drum_bpm/conf write_meta_drum
//   Global        : set_track_name <name>  (call before any write_meta_*)
//                   set_bpm_gate <0.0–1.0> (default 0.5)
//                   trackExists <name>     (→ outlet 3: 1 or 0)
//                   forgetTrack <name>     (remove one track from library)
//                   reset / reset_voc / reset_melo / reset_bass / reset_drum

autowatch = 1;
outlets   = 4;

// ── GLOBAL CONFIG ─────────────────────────────────────────────────────────────
var BPM_MIN_CONFIDENCE = 0.0;   // 0 = gate off (always write BPM); raise to enable
var track_name         = "";    // send  set_track_name <name>  before write_meta_*
var skipIfExists       = false; // true when set_track_name finds track already in library

function set_bpm_gate(v) {
    BPM_MIN_CONFIDENCE = parseFloat(v);
    post("EBYS: BPM gate → " + BPM_MIN_CONFIDENCE +
         (BPM_MIN_CONFIDENCE === 0.0 ? " (disabled)" : "") + "\n");
}

// ── PERSISTENT LIBRARY ────────────────────────────────────────────────────────
// library[track_name][dict_key] = value
// Survives patch reloads. Loaded on startup, saved after each write_meta_*.
// Path is resolved lazily so patcher.filepath is always populated when used.
var library = {};

// getPatcherDir — returns the absolute POSIX folder of the patch file.
// patcher.filepath can be either a POSIX path (/Users/...) or a Max-internal
// volume path (l:/Users/...). Strip everything before the first '/' to normalise.
function getPatcherDir() {
    var fp = patcher.filepath || "";
    var slash = fp.indexOf('/');
    if (slash > 0) fp = fp.slice(slash);   // strip "l:" or "Macintosh HD:" prefix
    fp = fp.replace(/[^\/\\]+$/, '');      // strip filename, keep trailing slash
    if (fp.length > 0 && fp[fp.length-1] !== '/') fp += '/';
    return fp;
}

function getLibraryPath() {
    var path = getPatcherDir() + "analysis_library.json";
    post("EBYS SliceWriter: library path = " + path + "\n");
    return path;
}

// wr() — write one entry to dict analysisLib AND mirror it into library.
// Outlet key includes the stem filename as outer prefix so dict analysisLib
// ends up with structure: {filename: {vocals: {metadata: {BPM: ...}, slices: {...}}}}
function wr(key, value) {
    if (track_name !== "") {
        outlet(0, "replace", track_name + "::" + key, value);
        library[track_name][key] = value;
    }
}

// Max JS writestring/readline are limited to ~32 KB per call.
// Write in 10 000-char chunks.
var CHUNK = 10000;

// flatToNested — converts {"a::b::c": v} to {a: {b: {c: v}}}
// Required so analysis_library.json reloads into dict analysisLib with proper
// nested structure, letting slicer.js traverse paths with d.get("f::a::b::c").
function flatToNested(flat) {
    var result = {};
    for (var k in flat) {
        var parts = k.split('::');
        var obj = result;
        for (var i = 0; i < parts.length - 1; i++) {
            if (typeof obj[parts[i]] !== 'object' || obj[parts[i]] === null) {
                obj[parts[i]] = {};
            }
            obj = obj[parts[i]];
        }
        obj[parts[parts.length - 1]] = flat[k];
    }
    return result;
}

// resetMemory — called via Max patch when TUI sends :resetMemory + confirmation
// Clears in-memory library, sends "clear" to dict analysisLib, overwrites JSON file
function resetMemory() {
    library = {};
    outlet(0, "clear");                 // clears dict analysisLib
    try {
        var f = new File(getLibraryPath(), "write", "TEXT");
        f.open(); f.writestring("{}"); f.close();
    } catch(e) {}
    post("EBYS SliceWriter: memory cleared — library wiped\n");
}

function saveLibrary() {
    try {
        // Build nested JSON: {filename: {vocals: {metadata: {...}, slices: {...}}}}
        // This is required so dict analysisLib can reload the file and have the
        // same nested structure that Max's "replace" messages create at runtime.
        var nested = {};
        for (var tn in library) {
            nested[tn] = flatToNested(library[tn]);
        }
        var f = new File(getLibraryPath(), "write", "TEXT");
        f.open();
        var str = JSON.stringify(nested);
        for (var i = 0; i < str.length; i += CHUNK) f.writestring(str.slice(i, i + CHUNK));
        f.close();
        post("EBYS SliceWriter: saved " + str.length + " chars to library\n");
    } catch(e) {
        post("EBYS SliceWriter: save failed — " + e + "\n");
    }
}

function loadLibrary() {
    try {
        var f = new File(getLibraryPath(), "read", "TEXT");
        if (!f.isopen) { post("EBYS SliceWriter: no library file found — starting fresh\n"); return; }
        var raw = "";
        while (!f.eof) raw += f.readstring(CHUNK);
        f.close();
        // library stores flat keys internally; JSON on disk is now nested.
        // Convert nested back to flat for the in-memory representation,
        // and replay replace messages with the filename prefix for dict analysisLib.
        var parsed = JSON.parse(raw);
        library = {};
        var trackCount = 0, sliceCount = 0;
        for (var tn in parsed) {
            library[tn] = {};
            nestedToFlat(parsed[tn], "", library[tn]);
            for (var key in library[tn]) {
                outlet(0, "replace", tn + "::" + key, library[tn][key]);
                if (key.indexOf("::time") !== -1) sliceCount++;
            }
            trackCount++;
        }
        post("EBYS SliceWriter: restored " + trackCount + " tracks, "
             + sliceCount + " slices from library\n");
        outlet(1, sliceCount);
    } catch(e) {
        post("EBYS SliceWriter: library load failed — " + e + "\n");
    }
}

// nestedToFlat — inverse of flatToNested; rebuilds flat {a::b::c: v} from nested obj
function nestedToFlat(obj, prefix, out) {
    for (var k in obj) {
        var path = prefix ? prefix + "::" + k : k;
        if (typeof obj[k] === 'object' && obj[k] !== null) {
            nestedToFlat(obj[k], path, out);
        } else {
            out[path] = obj[k];
        }
    }
}

// trackExists <name> → outlet 3: 1 if already in library, 0 if new
function trackExists() {
    var parts = [];
    for (var i = 0; i < arguments.length; i++) parts.push(String(arguments[i]));
    var name   = parts.join("_");
    var exists = library.hasOwnProperty(name)
                 && Object.keys(library[name]).length > 0;
    post("EBYS SliceWriter: trackExists('" + name + "') = " + (exists ? 1 : 0) + "\n");
    outlet(3, exists ? 1 : 0);
}

// forgetTrack <name> — remove one track from library + save
function forgetTrack() {
    var parts = [];
    for (var i = 0; i < arguments.length; i++) parts.push(String(arguments[i]));
    var name = parts.join("_");
    if (library.hasOwnProperty(name)) {
        delete library[name];
        saveLibrary();
        post("EBYS SliceWriter: removed '" + name + "' from library\n");
    } else {
        post("EBYS SliceWriter: forgetTrack — '" + name + "' not found\n");
    }
}

function set_track_name() {
    var parts = [];
    for (var i = 0; i < arguments.length; i++) parts.push(String(arguments[i]));
    track_name = parts.join("_");
    // Check library — skip analysis if track already stored
    skipIfExists = track_name !== ""
                   && library.hasOwnProperty(track_name)
                   && Object.keys(library[track_name]).length > 0;
    if (!skipIfExists && track_name !== "") library[track_name] = {};
    post("EBYS: track='" + track_name + "' " + (skipIfExists ? "EXISTS — skipping writes" : "NEW — analyzing") + "\n");
    outlet(3, skipIfExists ? 1 : 0);  // → sel 0 1 in patch: 0=reset+analyze, 1=skip
}

// ── KEY DETECTION (Krumhansl-Schmuckler 1982) ─────────────────────────────────
// Pitch class profiles — index 0 = root, rotated at query time.
// Diatonic (Krumhansl-Schmuckler 1982)
var KS_MAJOR      = [6.35, 2.23, 3.48, 2.33, 4.38, 4.09, 2.52, 5.19, 2.39, 3.66, 2.29, 2.88];
var KS_MINOR      = [6.33, 2.68, 3.52, 5.38, 2.60, 3.53, 2.54, 4.75, 3.98, 2.69, 3.34, 3.17];
// Pentatonic profiles — scale tones get high weight, chromatic gaps get low weight.
// Pentatonic minor:  root(0)  m3(3)  P4(5)  P5(7)  m7(10)
var KS_PENT_MINOR = [7.00, 1.50, 1.50, 5.00, 1.50, 4.50, 1.50, 6.00, 1.50, 1.50, 4.00, 1.50];
// Pentatonic major:  root(0)  M2(2)  M3(4)  P5(7)  M6(9)
var KS_PENT_MAJOR = [7.00, 1.50, 4.50, 1.50, 5.00, 1.50, 1.50, 6.00, 1.50, 4.00, 1.50, 1.50];
var SCALE_LABELS  = [" major", " minor", " pent.minor", " pent.major"];
var SCALE_PROFILES = [KS_MAJOR, KS_MINOR, KS_PENT_MINOR, KS_PENT_MAJOR];
var NOTE_NAMES = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];

// Pearson correlation between two 12-element arrays
function pearson(x, y) {
    var n = 12, sx = 0, sy = 0, i;
    for (i = 0; i < n; i++) { sx += x[i]; sy += y[i]; }
    var mx = sx / n, my = sy / n;
    var num = 0, dx2 = 0, dy2 = 0;
    for (i = 0; i < n; i++) {
        var dx = x[i] - mx, dy = y[i] - my;
        num += dx * dy;
        dx2 += dx * dx;
        dy2 += dy * dy;
    }
    var denom = Math.sqrt(dx2 * dy2);
    return denom < 1e-9 ? 0.0 : num / denom;
}

// detectKey: takes array of [hz, lufs] pairs, returns "X major" / "X minor" / "unknown"
//
// Two-stage algorithm:
//   Stage 1 — K-S correlation across all 24 keys gives a "best" key and score.
//   Stage 2 — Tiebreaker: find the pitch class with the most accumulated weight
//             (the "loudest" note). If that note is NOT the tonic of the K-S winner,
//             but IS the tonic of another key whose score is within 0.08 of the best,
//             prefer that other key.
//
// Rationale: melodies rarely sit on the tonic — they favour degrees 2-6. So the
// K-S raw winner is often the relative key or a parallel key. The tiebreaker says:
// "if the most prominent note could be the tonic of a nearly-equal key, use that."
//
// Energy gate: skip frames below -40 LUFS (noise/silence between onsets).
// Energy weight: lufs + 80 → positive; soft compression so one loud note can't
//                dominate the histogram entirely.
function detectKey(pitches) {
    if (pitches.length < 3) return "unknown";

    // Build energy-weighted pitch-class histogram (Hz → MIDI → pc)
    var hist = [0,0,0,0,0,0,0,0,0,0,0,0];
    var totalWeight = 0;
    for (var i = 0; i < pitches.length; i++) {
        var hz   = pitches[i][0];
        var lufs = pitches[i][1];
        if (hz < 40.0 || lufs < -40.0) continue;          // skip noise / silence
        var weight = lufs + 80.0;
        if (weight <= 0) continue;
        var midi = 69 + 12 * (Math.log(hz / 440.0) / Math.log(2));
        var pc   = ((Math.round(midi) % 12) + 12) % 12;
        hist[pc] += weight;
        totalWeight += weight;
    }
    if (totalWeight === 0) return "unknown";

    // Stage 1: full scan across all 48 candidates (12 roots × 4 scale types)
    var rootScore = new Array(12);
    var rootKey   = new Array(12);
    var best = { score: -Infinity, key: "unknown", root: 0 };
    for (var root = 0; root < 12; root++) {
        var rotHist = [];
        for (var j = 0; j < 12; j++) rotHist.push(hist[(j + root) % 12]);
        var topS = -Infinity, topL = 0;
        for (var p = 0; p < SCALE_PROFILES.length; p++) {
            var s = pearson(rotHist, SCALE_PROFILES[p]);
            if (s > topS) { topS = s; topL = p; }
        }
        rootScore[root] = topS;
        rootKey[root]   = NOTE_NAMES[root] + SCALE_LABELS[topL];
        if (topS > best.score) { best.score = topS; best.key = rootKey[root]; best.root = root; }
    }

    // Stage 2: tiebreaker — most energetic pitch class
    var maxPc = 0;
    for (var k = 1; k < 12; k++) if (hist[k] > hist[maxPc]) maxPc = k;

    // If the dominant note is NOT already the K-S tonic, but its own key
    // correlates within 0.08 of the best, prefer it (breaks relative key ties).
    if (best.root !== maxPc && (best.score - rootScore[maxPc]) < 0.08) {
        return rootKey[maxPc];
    }
    return best.key;
}

// topPcs: returns "A=42,F#=38,C#=31" style string for the 3 heaviest pitch classes
function topPcs(pitches) {
    var hist = [0,0,0,0,0,0,0,0,0,0,0,0];
    for (var i = 0; i < pitches.length; i++) {
        var hz = pitches[i][0], lufs = pitches[i][1];
        if (hz < 40.0 || lufs < -40.0) continue;
        var w = lufs + 80.0;
        if (w <= 0) continue;
        var pc = ((Math.round(69 + 12 * (Math.log(hz / 440.0) / Math.log(2))) % 12) + 12) % 12;
        hist[pc] += w;
    }
    var out = [];
    for (var t = 0; t < 3; t++) {
        var mv = -1, mi = 0;
        for (var p = 0; p < 12; p++) if (hist[p] > mv) { mv = hist[p]; mi = p; }
        if (mv <= 0) break;
        out.push(NOTE_NAMES[mi] + "=" + Math.round(mv));
        hist[mi] = -1;
    }
    return out.join(",");
}

// ── Pitch accumulation arrays (cleared on reset) ──────────────────────────────
var vocals_pitches  = [];
var melo_pitches = [];
var bass_pitches = [];

// ── UTILITY ───────────────────────────────────────────────────────────────────
function pad(n, width) {
    var s = String(n);
    while (s.length < width) s = "0" + s;
    return s;
}

function totalSlices() {
    return vocals_counter + melo_counter + bass_counter + drum_counter;
}

// ─────────────────────────────────────────────────────────────────────────────
// VOCALS
// ─────────────────────────────────────────────────────────────────────────────
var vocals_counter = 0;
var vocals_time = 0.0, vocals_C = 0.0, vocals_S = 0.0, vocals_P = 0.0, vocals_E = 0.0, vocals_F = 0.0;
var vocals_H = 0.0;
var vocals_M0 = 0.0, vocals_M1 = 0.0, vocals_M2 = 0.0;
var vocals_M3 = 0.0, vocals_M4 = 0.0, vocals_M5 = 0.0;
var meta_vocals_bpm = 0.0, meta_vocals_conf = 0.0, meta_vocals_durMs = 0.0;

function set_vocals_time(v) { vocals_time = parseFloat(v); }
function set_vocals_C(v)    { vocals_C    = parseFloat(v); }
function set_vocals_S(v)    { vocals_S    = parseFloat(v); }
function set_vocals_P(v)    { vocals_P    = parseFloat(v); }
function set_vocals_E(v)    { vocals_E    = parseFloat(v); }
function set_vocals_F(v)    { vocals_F    = parseFloat(v); }
function set_vocals_H(v)    { vocals_H    = parseFloat(v); }
function set_vocals_M0(v)   { vocals_M0   = parseFloat(v); }
function set_vocals_M1(v)   { vocals_M1   = parseFloat(v); }
function set_vocals_M2(v)   { vocals_M2   = parseFloat(v); }
function set_vocals_M3(v)   { vocals_M3   = parseFloat(v); }
function set_vocals_M4(v)   { vocals_M4   = parseFloat(v); }
function set_vocals_M5(v)   { vocals_M5   = parseFloat(v); }

function write_vocals() {
    if (skipIfExists) return;
    vocals_counter++;
    var id   = "slice_" + pad(vocals_counter, 4);
    var base = "vocals::slices::" + id + "::";
    wr(base + "time", vocals_time);
    wr(base + "C",    vocals_C);
    wr(base + "S",    vocals_S);
    wr(base + "P",    vocals_P);
    wr(base + "E",    vocals_E);
    wr(base + "F",    vocals_F);
    wr(base + "H",    vocals_H);
    wr(base + "M0",   vocals_M0);
    wr(base + "M1",   vocals_M1);
    wr(base + "M2",   vocals_M2);
    wr(base + "M3",   vocals_M3);
    wr(base + "M4",   vocals_M4);
    wr(base + "M5",   vocals_M5);
    if (vocals_P > 40.0) vocals_pitches.push([vocals_P, vocals_E]);
    outlet(1, totalSlices());
    outlet(2, "voc:" + id);
}

function set_meta_vocals_bpm(v)   { meta_vocals_bpm   = parseFloat(v); }
function set_meta_vocals_conf(v)  { meta_vocals_conf  = parseFloat(v); }
function set_meta_vocals_durMs(v) { meta_vocals_durMs = parseFloat(v); }

function write_meta_vocals() {
    if (skipIfExists) return;
    wr("vocals::metadata::track_name",     track_name);
    wr("vocals::metadata::stemDurMs",      meta_vocals_durMs);
    wr("vocals::metadata::BPM_confidence", meta_vocals_conf);
    if (meta_vocals_conf >= BPM_MIN_CONFIDENCE) {
        wr("vocals::metadata::BPM", meta_vocals_bpm);
        post("EBYS voc  BPM=" + meta_vocals_bpm.toFixed(1) +
             "  conf=" + meta_vocals_conf.toFixed(3) + "\n");
    } else {
        // Gate active and confidence too low — write 0 so the key still exists
        wr("vocals::metadata::BPM", 0.0);
        post("EBYS voc  BPM=0 (gated — conf=" + meta_vocals_conf.toFixed(3) +
             " < " + BPM_MIN_CONFIDENCE + ")\n");
    }
    var key = detectKey(vocals_pitches);
    wr("vocals::metadata::key", key);
    var topVoc = topPcs(vocals_pitches);
    post("EBYS voc  key=" + key + "  top:" + topVoc + "  n=" + vocals_pitches.length + "\n");
    saveLibrary();
}

// ─────────────────────────────────────────────────────────────────────────────
// MELODY
// ─────────────────────────────────────────────────────────────────────────────
var melo_counter = 0;
var melo_time = 0.0, melo_C = 0.0, melo_S = 0.0, melo_P = 0.0, melo_E = 0.0, melo_F = 0.0;
var melo_H = 0.0;
var melo_M0 = 0.0, melo_M1 = 0.0, melo_M2 = 0.0;
var melo_M3 = 0.0, melo_M4 = 0.0, melo_M5 = 0.0;
var meta_melo_bpm = 0.0, meta_melo_conf = 0.0, meta_melo_durMs = 0.0;

function set_melo_time(v) { melo_time = parseFloat(v); }
function set_melo_C(v)    { melo_C    = parseFloat(v); }
function set_melo_S(v)    { melo_S    = parseFloat(v); }
function set_melo_P(v)    { melo_P    = parseFloat(v); }
function set_melo_E(v)    { melo_E    = parseFloat(v); }
function set_melo_F(v)    { melo_F    = parseFloat(v); }
function set_melo_H(v)    { melo_H    = parseFloat(v); }
function set_melo_M0(v)   { melo_M0   = parseFloat(v); }
function set_melo_M1(v)   { melo_M1   = parseFloat(v); }
function set_melo_M2(v)   { melo_M2   = parseFloat(v); }
function set_melo_M3(v)   { melo_M3   = parseFloat(v); }
function set_melo_M4(v)   { melo_M4   = parseFloat(v); }
function set_melo_M5(v)   { melo_M5   = parseFloat(v); }

function write_melo() {
    if (skipIfExists) return;
    melo_counter++;
    var id   = "slice_" + pad(melo_counter, 4);
    var base = "melody::slices::" + id + "::";
    wr(base + "time", melo_time);
    wr(base + "C",    melo_C);
    wr(base + "S",    melo_S);
    wr(base + "P",    melo_P);
    wr(base + "E",    melo_E);
    wr(base + "F",    melo_F);
    wr(base + "H",    melo_H);
    wr(base + "M0",   melo_M0);
    wr(base + "M1",   melo_M1);
    wr(base + "M2",   melo_M2);
    wr(base + "M3",   melo_M3);
    wr(base + "M4",   melo_M4);
    wr(base + "M5",   melo_M5);
    if (melo_P > 40.0) melo_pitches.push([melo_P, melo_E]);
    outlet(1, totalSlices());
    outlet(2, "melo:" + id);
}

function set_meta_melo_bpm(v)   { meta_melo_bpm   = parseFloat(v); }
function set_meta_melo_conf(v)  { meta_melo_conf  = parseFloat(v); }
function set_meta_melo_durMs(v) { meta_melo_durMs = parseFloat(v); }

function write_meta_melo() {
    if (skipIfExists) return;
    wr("melody::metadata::track_name",     track_name);
    wr("melody::metadata::stemDurMs",      meta_melo_durMs);
    wr("melody::metadata::BPM_confidence", meta_melo_conf);
    if (meta_melo_conf >= BPM_MIN_CONFIDENCE) {
        wr("melody::metadata::BPM", meta_melo_bpm);
        post("EBYS melo BPM=" + meta_melo_bpm.toFixed(1) +
             "  conf=" + meta_melo_conf.toFixed(3) + "\n");
    } else {
        wr("melody::metadata::BPM", 0.0);
        post("EBYS melo BPM=0 (gated — conf=" + meta_melo_conf.toFixed(3) +
             " < " + BPM_MIN_CONFIDENCE + ")\n");
    }
    var key = detectKey(melo_pitches);
    wr("melody::metadata::key", key);
    var topMelo = topPcs(melo_pitches);
    post("EBYS melo key=" + key + "  top:" + topMelo + "  n=" + melo_pitches.length + "\n");
    saveLibrary();
}

// ─────────────────────────────────────────────────────────────────────────────
// BASS
// ─────────────────────────────────────────────────────────────────────────────
var bass_counter = 0;
var bass_time = 0.0, bass_C = 0.0, bass_S = 0.0, bass_P = 0.0, bass_E = 0.0, bass_F = 0.0;
var bass_H = 0.0;
var bass_M0 = 0.0, bass_M1 = 0.0, bass_M2 = 0.0;
var bass_M3 = 0.0, bass_M4 = 0.0, bass_M5 = 0.0;
var meta_bass_bpm = 0.0, meta_bass_conf = 0.0, meta_bass_durMs = 0.0;

function set_bass_time(v) { bass_time = parseFloat(v); }
function set_bass_C(v)    { bass_C    = parseFloat(v); }
function set_bass_S(v)    { bass_S    = parseFloat(v); }
function set_bass_P(v)    { bass_P    = parseFloat(v); }
function set_bass_E(v)    { bass_E    = parseFloat(v); }
function set_bass_F(v)    { bass_F    = parseFloat(v); }
function set_bass_H(v)    { bass_H    = parseFloat(v); }
function set_bass_M0(v)   { bass_M0   = parseFloat(v); }
function set_bass_M1(v)   { bass_M1   = parseFloat(v); }
function set_bass_M2(v)   { bass_M2   = parseFloat(v); }
function set_bass_M3(v)   { bass_M3   = parseFloat(v); }
function set_bass_M4(v)   { bass_M4   = parseFloat(v); }
function set_bass_M5(v)   { bass_M5   = parseFloat(v); }

function write_bass() {
    if (skipIfExists) return;
    bass_counter++;
    var id   = "slice_" + pad(bass_counter, 4);
    var base = "bass::slices::" + id + "::";
    wr(base + "time", bass_time);
    wr(base + "C",    bass_C);
    wr(base + "S",    bass_S);
    wr(base + "P",    bass_P);
    wr(base + "E",    bass_E);
    wr(base + "F",    bass_F);
    wr(base + "H",    bass_H);
    wr(base + "M0",   bass_M0);
    wr(base + "M1",   bass_M1);
    wr(base + "M2",   bass_M2);
    wr(base + "M3",   bass_M3);
    wr(base + "M4",   bass_M4);
    wr(base + "M5",   bass_M5);
    if (bass_P > 40.0) bass_pitches.push([bass_P, bass_E]);
    outlet(1, totalSlices());
    outlet(2, "bass:" + id);
}

function set_meta_bass_bpm(v)   { meta_bass_bpm   = parseFloat(v); }
function set_meta_bass_conf(v)  { meta_bass_conf  = parseFloat(v); }
function set_meta_bass_durMs(v) { meta_bass_durMs = parseFloat(v); }

function write_meta_bass() {
    if (skipIfExists) return;
    wr("bass::metadata::track_name",     track_name);
    wr("bass::metadata::stemDurMs",      meta_bass_durMs);
    wr("bass::metadata::BPM_confidence", meta_bass_conf);
    if (meta_bass_conf >= BPM_MIN_CONFIDENCE) {
        wr("bass::metadata::BPM", meta_bass_bpm);
        post("EBYS bass BPM=" + meta_bass_bpm.toFixed(1) +
             "  conf=" + meta_bass_conf.toFixed(3) + "\n");
    } else {
        wr("bass::metadata::BPM", 0.0);
        post("EBYS bass BPM=0 (gated — conf=" + meta_bass_conf.toFixed(3) +
             " < " + BPM_MIN_CONFIDENCE + ")\n");
    }
    var key = detectKey(bass_pitches);
    wr("bass::metadata::key", key);
    var topBass = topPcs(bass_pitches);
    post("EBYS bass key=" + key + "  top:" + topBass + "  n=" + bass_pitches.length + "\n");
    saveLibrary();
}

// ─────────────────────────────────────────────────────────────────────────────
// DRUMS  (no P — pitch is not meaningful on percussive transients)
// ─────────────────────────────────────────────────────────────────────────────
var drum_counter = 0;
var drum_time = 0.0, drum_C = 0.0, drum_S = 0.0, drum_E = 0.0, drum_F = 0.0;
var drum_H = 0.0;
var drum_M0 = 0.0, drum_M1 = 0.0, drum_M2 = 0.0;
var drum_M3 = 0.0, drum_M4 = 0.0, drum_M5 = 0.0;
var meta_drum_bpm = 0.0, meta_drum_conf = 0.0, meta_drum_durMs = 0.0;

function set_drum_time(v) { drum_time = parseFloat(v); }
function set_drum_C(v)    { drum_C    = parseFloat(v); }
function set_drum_S(v)    { drum_S    = parseFloat(v); }
function set_drum_E(v)    { drum_E    = parseFloat(v); }
function set_drum_F(v)    { drum_F    = parseFloat(v); }
function set_drum_H(v)    { drum_H    = parseFloat(v); }
function set_drum_M0(v)   { drum_M0   = parseFloat(v); }
function set_drum_M1(v)   { drum_M1   = parseFloat(v); }
function set_drum_M2(v)   { drum_M2   = parseFloat(v); }
function set_drum_M3(v)   { drum_M3   = parseFloat(v); }
function set_drum_M4(v)   { drum_M4   = parseFloat(v); }
function set_drum_M5(v)   { drum_M5   = parseFloat(v); }

function write_drum() {
    if (skipIfExists) return;
    drum_counter++;
    var id   = "slice_" + pad(drum_counter, 4);
    var base = "drums::slices::" + id + "::";
    wr(base + "time", drum_time);
    wr(base + "C",    drum_C);
    wr(base + "S",    drum_S);
    wr(base + "E",    drum_E);
    wr(base + "F",    drum_F);
    wr(base + "H",    drum_H);
    wr(base + "M0",   drum_M0);
    wr(base + "M1",   drum_M1);
    wr(base + "M2",   drum_M2);
    wr(base + "M3",   drum_M3);
    wr(base + "M4",   drum_M4);
    wr(base + "M5",   drum_M5);
    outlet(1, totalSlices());
    outlet(2, "drum:" + id);
}

function set_meta_drum_bpm(v)   { meta_drum_bpm   = parseFloat(v); }
function set_meta_drum_conf(v)  { meta_drum_conf  = parseFloat(v); }
function set_meta_drum_durMs(v) { meta_drum_durMs = parseFloat(v); }

function write_meta_drum() {
    if (skipIfExists) return;
    wr("drums::metadata::track_name",     track_name);
    wr("drums::metadata::stemDurMs",      meta_drum_durMs);
    wr("drums::metadata::BPM_confidence", meta_drum_conf);
    if (meta_drum_conf >= BPM_MIN_CONFIDENCE) {
        wr("drums::metadata::BPM", meta_drum_bpm);
        post("EBYS drum BPM=" + meta_drum_bpm.toFixed(1) +
             "  conf=" + meta_drum_conf.toFixed(3) + "\n");
    } else {
        wr("drums::metadata::BPM", 0.0);
        post("EBYS drum BPM=0 (gated — conf=" + meta_drum_conf.toFixed(3) +
             " < " + BPM_MIN_CONFIDENCE + ")\n");
    }
    saveLibrary();
}

// ── SESSION CONTROL ───────────────────────────────────────────────────────────
function reset() {
    vocals_counter  = 0;
    melo_counter = 0;
    bass_counter = 0;
    drum_counter = 0;
    // track_name intentionally preserved — set_track_name fires before reset in the auto chain
    skipIfExists    = false;
    vocals_pitches  = [];
    melo_pitches = [];
    bass_pitches = [];
    post("EBYS: counters + pitch buffers reset\n");
    outlet(1, 0);
}

function reset_vocals()  { vocals_counter  = 0; vocals_pitches  = []; post("EBYS: vocals counter reset\n"); }
function reset_melo() { melo_counter = 0; melo_pitches = []; post("EBYS: melody counter reset\n"); }
function reset_bass() { bass_counter = 0; bass_pitches = []; post("EBYS: bass counter reset\n"); }
function reset_drum() { drum_counter = 0;                    post("EBYS: drums counter reset\n"); }

// ── STARTUP ───────────────────────────────────────────────────────────────────
// dict analysisLib is reloaded on patch open via a native Max wire:
//   [loadbang] → [message "read analysis_library.json"] → [dict analysisLib]
// No JS startup code needed here — Max handles it reliably without outlet timing issues.
