// EBYS — Slicer  v2
//
// ── Role ──────────────────────────────────────────────────────────────────────
// Slicer.js is the sequencing brain of EBYS.  It owns all scheduling and
// musical decision-making: which segment plays next, when it fires, how long
// it runs, and whether the transport is running at all.
//
// Responsibilities:
//   - Index: parses the descriptor dict to build a slice database per stem
//   - Segment selection: picks musically coherent segments (bar-aligned,
//     consecutive slices, weighted by descriptor similarity)
//   - Transport: start / stop / next — drives the looping playback clock
//   - BPM-aware timing: computes stretchRatio = srcBPM / globalBPM so the
//     audio engine can slow/speed karma~ without slicer knowing about audio
//   - Loop / stay logic: STAY_PROB and explicit loop locks for performance control
//
// Slicer does NOT touch audio objects or DSP parameters directly.
// It emits play triggers on outlet 0 that buffer_manager.js consumes.
// ──────────────────────────────────────────────────────────────────────────────
//
// Changes from v1:
//   - selectSegment() replaces selectRandom() — groups consecutive slices
//     into musically meaningful segments (SEGMENT_BARS bars long).
//   - Bar-aligned starts: when QUANTIZE_BARS is on (default), the chosen
//     start slice is snapped to the nearest bar boundary so segments always
//     begin on beat 1.  This is the single biggest factor for sounding good.
//   - next(track) carries the track name, so each stem loops independently
//     and all four fire simultaneously on start().
//   - Probabilistic stay/change: STAY_PROB (0–1) controls how likely a track
//     is to replay the same segment instead of jumping to a new one.
//     0 = always random,  1 = never move.  Default 0.
//
// ── Inlet messages ────────────────────────────────────────────────────────────
//   buildIndex              — read dict, rebuild index
//   start                   — fire all 4 stems simultaneously
//   stop                    — halt
//   next <track>            — re-select segment for that track only
//                             Max patch sends: "next vocals", "next melody", etc.
//   dumpDescriptors [track] — outlet 2 descriptor stream
//   selectRange <track> Clo Chi Elo Ehi Flo Fhi Plo Phi
//   setSegmentBars N        — bars per segment (default 4)
//   setQuantize 0|1         — snap starts to bar grid (default 1 = on)
//   setStayProb 0-1         — probability of staying on same position (default 0)
//   setFallbackBPM N        — BPM when detection returned 0 (default 120)
//   setTrackWeight t N      — future cross-track bias
//   info                    — print state summary
//   reset                   — clear index, stop
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0  playback trigger  → list: track  startFrac  endFrac  stretchRatio
//        track        = "vocals" | "melody" | "bass" | "drums"
//        startFrac    = 0–1 fraction of buffer length
//                       multiply by buffer samps to get karma~ seek position
//        endFrac      = 0–1 fraction; segment ends here
//        stretchRatio = srcBPM / globalBPM  (1.0 when no global BPM override)
//   1  status / metadata — first word is the tag:
//        ready N                                        — index ready, N total slices
//        slices Nv Nm Nb Nd                             — per-stem slice counts (vocals melody bass drums)
//        track_name name                                — cleaned source track name
//        need_stemDurs                                  — ask Max to resend setStemDurMs for all stems
//        desc track C E F P H T tC tE tF tP tH tT      — current slice descriptors + tensions
//        slice_ms track ms                              — absolute playback position in ms
//        stemTrack track name                           — source file name for this stem
//        seg track id dur bars startFrac endFrac        — segment summary (human-readable)
//        stopped                                        — transport halted via stop()
//        reset                                          — index cleared via reset()
//        index_empty                                    — start() called with no index built
//        empty_pool track                               — selectSegment() found zero candidates
//        loop track bars locked                         — stem locked to looping segment
//        unloop track | "all"                           — loop released
//        globalBPM N                                    — global BPM override active
//        segmentBars track N                            — segment length updated
//        stayProb track N                               — stay probability updated
//        quantize 0|1                                   — bar-snap on/off
//        umapDone                                       — umap_coords.json written (Node t-SNE)
//   2  descriptor dump (from dumpDescriptors)
//        → list: track  id  n  C  P  E  F  startTime  dur
//   3  query result count (from selectRange)  → int: N matching slices
//   4  → fluid.dataset~ ebys.descriptors      — sends "read <fname>" to load per-stem descriptor data
//   5  → fluid.umap~                           — sends "fit ebys.descriptors ebys.umap" to run UMAP

autowatch = 1;
inlets    = 3;   // 0 = commands, 1 = fluid.dataset~ ebys.umap dump, 2 = fluid.dataset~ ebys.descriptors read-done
outlets   = 6;   // outlet 4 = fluid.dataset~ ebys.descriptors, outlet 5 = fluid.umap~

// ── CONSTANTS ─────────────────────────────────────────────────────────────────
var TRACKS                 = ["vocals", "melody", "bass", "drums"];
var LAST_SLICE_DEFAULT_DUR = 0.005; // fraction — fallback dur for the last slice (~0.5% of buffer)

// ── MUSICAL PARAMETERS ────────────────────────────────────────────────────────
// Per-track segment bars and stay probability
// Commands: setSegmentBars N  (all tracks)  or  setSegmentBars vocals N  (one track)
//           setStayProb P     (all tracks)  or  setStayProb drums P      (one track)
var SEGMENT_BARS  = { vocals: 4, melody: 4, bass: 4, drums: 4 };
var QUANTIZE_BARS = true;   // snap start to bar grid  (setQuantize 0|1)
var STAY_PROB     = { vocals: 0.5, melody: 0.5, bass: 0.5, drums: 0.5 };
var FALLBACK_BPM  = 120;    // used when BPM detection returned 0
var GLOBAL_BPM    = 0;      // when > 0, overrides ALL analyzed BPM values (setGlobalBPM N)
var BAR_SNAP_MS       = 30;  // ms tolerance for "close enough to a bar boundary"
var MAX_SLICES_PER_STEM = 200; // set via :setMaxSlices N; 0 = unlimited

// Timing is driven by play~'s done bang in the Max patch.
// play~ fires done bang when it reaches endFrac → next() → selectSegment() → new segment.
// BPM controls how many slices to select (segment length), not transition timing.

// ── STEM DURATIONS (ms) ───────────────────────────────────────────────────────
// Set from Max via:  setStemDurMs vocals 187420
// info~ stem_vocals → [* 1000] → prepend setStemDurMs vocals → js slicer.js
// Without these, slice.time fractions can't be compared to barMs (ms).
var stemDurMs = { vocals: 0, melody: 0, bass: 0, drums: 0 };

// ── SLOT MAP ──────────────────────────────────────────────────────────────────
// Maps source track name → slot index (0-based, alphabetical).
// Populated by buildIndex(); used to embed slot in outlet 0 messages.
// track_loader.js uses the same alphabetical sort, so slot 0 here = slot 0 there.
var slotMap = {};  // { "439 ISMT": 0, "DREPTO CE3o": 1, … }

function setStemDurMs(track, ms) {
    if (stemDurMs.hasOwnProperty(track)) {
        var newMs = parseFloat(ms);
        if (newMs <= 0) return;  // ignore empty-buffer reports (0ms on patch open)
        stemDurMs[track] = newMs;
        post("EBYS Slicer: stemDurMs[" + track + "] = "
             + (stemDurMs[track] / 1000).toFixed(2) + "s\n");
        outlet(1, "stemDurMs", track, stemDurMs[track]);
    }
}

// ── LIBRARY CHUNK ACCUMULATOR ─────────────────────────────────────────────────
// ws_server.js sends the 1+ MB analysis_library.json in 2 KB chunks to bypass
// Max's 32 767-byte JsFile limit and N4M's setDict size ceiling.
// Format: libchunk  streamId  chunkIndex  total  data
var cachedLibrary    = null;   // parsed library object, set once all chunks arrive
var libChunkBuf      = null;   // Array(total) of string chunks
var libChunkTotal    = 0;
var libChunkReceived = 0;
var libChunkSid      = -1;     // current stream id

function libchunk() {
    // Max splits symbol atoms on spaces, so a JSON chunk containing spaces arrives
    // as multiple atoms.  args[0]=streamId, args[1]=i, args[2]=total, args[3+]=data.
    var args = arrayfromargs(arguments);
    var sid  = parseInt(args[0]);
    var i    = parseInt(args[1]);
    var t    = parseInt(args[2]);
    var data = args.slice(3).join(' ');

    if (!libChunkBuf || libChunkSid !== sid) {
        if (libChunkBuf) {
            post("EBYS Slicer: libchunk stream reset (was " + libChunkSid
                 + ", now " + sid + ") — " + libChunkReceived + "/" + libChunkTotal + " chunks dropped\n");
        }
        libChunkBuf      = new Array(t);
        libChunkTotal    = t;
        libChunkSid      = sid;
        libChunkReceived = 0;
    }
    if (libChunkBuf[i] !== undefined) return; // duplicate chunk — ignore
    libChunkBuf[i] = data;
    libChunkReceived++;
    if (libChunkReceived === t) {
        var assembled = libChunkBuf.join('');
        libChunkBuf = null;
        try {
            cachedLibrary = JSON.parse(assembled);
            post("EBYS Slicer: library cached via chunks (stream " + sid
                 + ", " + assembled.length + " chars, " + t + " chunks)\n");
            // If buildIndex arrived before chunks finished, run it now.
            if (buildIndexPending) buildIndex();
        } catch(e) {
            post("EBYS Slicer: chunk assembly parse failed — " + e + "\n");
            post("EBYS Slicer: assembled[0..100] = " + assembled.substring(0, 100) + "\n");
            cachedLibrary = null;
        }
    }
}

// ── GENRE STATE ───────────────────────────────────────────────────────────────
// trackGenres[trackName] = ["Electronic---Techno", "Electronic---House", ...]
// Populated from genres.json via genrechunk messages from ws_server.js.
// genreFilter: substring match against genre strings (case-insensitive). null = no filter.
var trackGenres      = {};
var genreFilter      = null;   // e.g. "Techno", "House", "Jazz"
// keyFilter: exact or partial match against slice.key (case-insensitive). null = no filter.
// Key values come from the track metadata (e.g. "Am", "C#", "G").
var keyFilter        = null;   // e.g. "Am", "C", "G#m"

var genreChunkBuf      = null;
var genreChunkTotal    = 0;
var genreChunkReceived = 0;
var genreChunkSid      = -1;

function genrechunk() {
    var args = arrayfromargs(arguments);
    var sid  = parseInt(args[0]);
    var i    = parseInt(args[1]);
    var t    = parseInt(args[2]);
    var data = args.slice(3).join(' ');

    if (!genreChunkBuf || genreChunkSid !== sid) {
        if (genreChunkBuf) {
            post("EBYS Slicer: genrechunk stream reset (was " + genreChunkSid
                 + ", now " + sid + ") — " + genreChunkReceived + "/" + genreChunkTotal + " chunks dropped\n");
        }
        genreChunkBuf      = new Array(t);
        genreChunkTotal    = t;
        genreChunkSid      = sid;
        genreChunkReceived = 0;
    }
    if (genreChunkBuf[i] !== undefined) return; // duplicate
    genreChunkBuf[i] = data;
    genreChunkReceived++;
    if (genreChunkReceived === t) {
        var assembled = genreChunkBuf.join('');
        genreChunkBuf = null;
        try {
            var gdata = JSON.parse(assembled);
            trackGenres = {};
            for (var trackName in gdata) {
                var entry = gdata[trackName];
                if (entry && entry.genres && entry.genres.length) {
                    // Store top-5 genre strings for this track
                    trackGenres[trackName] = entry.genres.slice(0, 5).map(function(g) {
                        return g.genre;
                    });
                }
            }
            post("EBYS Slicer: genres loaded — "
                 + Object.keys(trackGenres).length + " tracks\n");
        } catch(e) {
            post("EBYS Slicer: genre chunk parse failed — " + e + "\n");
        }
    }
}

// ── DOWNBEATS CHUNK ACCUMULATOR ──────────────────────────────────────────────
// downbeats.json is sent by ws_server.js (Node) before the cached index so
// loadDownbeats() finds the data already available when it runs.
var downbeatsRaw       = null;   // parsed JSON object once all chunks arrive
var dbChunkBuf         = null;
var dbChunkTotal       = 0;
var dbChunkReceived    = 0;
var dbChunkSid         = -1;

function downbeatchunk() {
    var args = arrayfromargs(arguments);
    var sid  = parseInt(args[0]);
    var i    = parseInt(args[1]);
    var t    = parseInt(args[2]);
    var data = args.slice(3).join(' ');
    if (!dbChunkBuf || dbChunkSid !== sid) {
        if (dbChunkBuf) {
            post("EBYS Slicer: downbeatchunk stream reset (was " + dbChunkSid
                 + ", now " + sid + ") — " + dbChunkReceived + "/" + dbChunkTotal + " chunks dropped\n");
        }
        dbChunkBuf      = new Array(t);
        dbChunkTotal    = t;
        dbChunkSid      = sid;
        dbChunkReceived = 0;
    }
    if (dbChunkBuf[i] !== undefined) return; // duplicate
    dbChunkBuf[i] = data;
    dbChunkReceived++;
    if (dbChunkReceived === t) {
        var assembled = dbChunkBuf.join('');
        dbChunkBuf = null;
        try {
            downbeatsRaw = JSON.parse(assembled);
            post("EBYS Slicer: downbeats received — "
                 + Object.keys(downbeatsRaw).length + " track(s)\n");
            // If the index is already built, apply downbeats now.
            if (idx.length > 0) loadDownbeats();
        } catch(e) {
            post("EBYS Slicer: downbeats chunk parse failed — " + e + "\n");
        }
    }
}

// ── INDEX STATE ───────────────────────────────────────────────────────────────
var idx          = [];
var byTrack      = {};
var meta         = {};
var ranges       = {};

// ── DOWNBEAT STATE ────────────────────────────────────────────────────────────
// Populated by loadDownbeats() from downbeats.json (sent by ws_server).
// trackDownbeats[sourceTrackName] = { meter, bpm, avgBarMs, downbeats_ms: [...], confidence }
// Keyed by source track name so multi-track sessions get correct data per track.
// When confidence < DOWNBEAT_MIN_CONF the BPM grid is used instead.
var trackDownbeats        = {};
var DOWNBEAT_MIN_CONF     = 0.4;  // below this, fall back to BPM grid
var trackWeights = { vocals: 1.0, melody: 1.0, bass: 1.0, drums: 1.0 };
var lastIdx         = { vocals: 0,    melody: 0,    bass: 0,    drums: 0    };
var lastEndFrac     = { vocals: -1,   melody: -1,   bass: -1,   drums: -1   }; // fraction where last segment ended
var lastSourceTrack = { vocals: null, melody: null, bass: null, drums: null }; // source track of last segment

// ── PER-STEM LOOP STATE ───────────────────────────────────────────────────────
// loopState[track] = { bars: N, startIdx: i, startTime: fraction, endTime: fraction }
// When set, next() replays the same segment instead of selecting a new one.
var loopState  = { vocals: null, melody: null, bass: null, drums: null };
var loopCycles = { vocals: 0,    melody: 0,    bass: 0,    drums: 0    }; // unique id per loop cycle

// ── PLAYBACK STATE ────────────────────────────────────────────────────────────
var running   = false;
var lastSlice = null;

// ── TRANSITION MATCHING ───────────────────────────────────────────────────────
// MATCH_PROB — 0 = ignore transition, 1 = strict match (single global value)
//   How tightly the START of the next slice must match the END of the current one.
//   Applies equally to all descriptors. setMatchProb 0.8 → all descriptors match at 80%.
//   Previously per-descriptor — collapsed to single global (redundant with setWeight).
var MATCH_PROB = 0.9;

// DIR_PREF[d] — -1 = prefer decreasing, 0 = neutral, +1 = prefer increasing
//   Biases selection toward slices that evolve in a given direction.
//   setDirPref E 1  → prefer slices where energy is rising
var DIR_PREF   = { C: 0.0, S: 0.0, E: 0.0, F: 0.0, P: 0.0, H: 0.0, T: 0.0 };
var DIR_WEIGHT = 1.0;  // global scale for direction influence

// End-descriptor memory per track — updated after each slice fires.
// Stores the END values of the last played slice so the next selection
// can match against them.
var lastEndDesc = { vocals: null, melody: null, bass: null, drums: null };

// ── FOLLOW STEM ───────────────────────────────────────────────────────────────
// followStem vocals melody 0.8 bass 0.2
// Instead of matching against its own last slice, a stem reads a weighted blend
// of other stems' end descriptors. Weights must sum to 1.0.
// followStem vocals self  → reset to default (read own descriptors)
// FOLLOW_STEM[track] = [ {stem: "melody", weight: 0.8}, {stem: "bass", weight: 0.2} ]
//                   or null = use self
var FOLLOW_STEM = { vocals: null, melody: null, bass: null, drums: null };

function getBlendedEndDesc(track) {
    var follows = FOLLOW_STEM[track];
    if (!follows || follows.length === 0) return lastEndDesc[track];
    var dims   = ['C', 'E', 'F', 'P', 'H', 'T'];
    var result = {};
    for (var i = 0; i < dims.length; i++) result[dims[i]] = 0;
    for (var j = 0; j < follows.length; j++) {
        var src = lastEndDesc[follows[j].stem];
        if (!src) continue;
        var w = follows[j].weight;
        for (var i = 0; i < dims.length; i++) {
            result[dims[i]] += (src[dims[i]] || 0) * w;
        }
    }
    return result;
}

// ── UTILITY ───────────────────────────────────────────────────────────────────
function pad(n, width) {
    var s = String(n);
    while (s.length < width) s = "0" + s;
    return s;
}
function clamp(v, lo, hi) { return v < lo ? lo : v > hi ? hi : v; }

// Returns the clean source track name for a stem (strips stem suffix from filename).
// Future multi-track: meta[stem].track_name will differ per stem.
function cleanTrackName(stem) {
    var raw = (meta[stem] && meta[stem].track_name) ? String(meta[stem].track_name) : "";
    return raw.replace(/_(vocals|melody|bass|drums|other|melo)(\.\w+)?$/i, "").trim();
}

// ── BUILD INDEX ───────────────────────────────────────────────────────────────
// Read library directly from JSON file — bypasses Max.setDict / Dict API entirely.
// Max Dict JSON export prepends `{}` as a preamble (byte 1 is `}` where valid JSON
// needs `"`).  Fix: replace the leading `{}` with `{"` before parsing.

function readLibraryJSON() {
    // Primary path: ws_server.js delivered the JSON in chunks before buildIndex arrived.
    if (cachedLibrary) return cachedLibrary;
    // If chunks haven't arrived yet, log and bail — buildIndex will be retried by the user.
    post("EBYS Slicer: no cached library — send buildIndex after patch is fully loaded\n");
    return null;
}

// Thin shim so the rest of buildIndex can use .get() / .getkeys()
// without touching the Dict API at all.
// Primitives (numbers, strings, booleans) are returned as-is so that
// parseFloat(metaDict.get("BPM")) etc. work unchanged.
function wrapObj(obj) {
    if (obj === null || obj === undefined) return null;
    if (typeof obj !== "object") return obj;  // pass primitives through directly
    return {
        get:     function(k) { return wrapObj(obj[k]); },
        getkeys: function()  { return Object.keys(obj); }
    };
}

var buildIndexPending = false;  // true while waiting for chunks to finish

function buildIndex() {
    // If chunks are still in flight, defer until the last libchunk arrives.
    if (libChunkBuf !== null) {
        post("EBYS Slicer: chunks still arriving (" + libChunkReceived + "/" + libChunkTotal + ", stream " + libChunkSid + ") — deferring buildIndex\n");
        buildIndexPending = true;
        return;
    }

    buildIndexPending = false;
    idx     = [];
    byTrack = {};
    meta    = {};
    ranges  = {};
    slotMap = {};

    var lib = readLibraryJSON();
    if (!lib) {
        post("EBYS Slicer: analysis library is empty — run analysis first\n");
        return;
    }
    var d = wrapObj(lib);

    var topKeys = d.getkeys();
    if (!topKeys || !topKeys.length) {
        post("EBYS Slicer: analysis library is empty — run analysis first\n");
        return;
    }

    // ── 1. Map every library filename to its stem type and source track name ──────
    // Filenames look like "DREPTO CE3o_vocals.wav" or "439iSMT_other.wav".
    // Canonical stem type keys are: vocals / melody / bass / drums.
    var SUFFIX_TO_STEM = {};
    SUFFIX_TO_STEM["_vocals.wav"] = "vocals";
    SUFFIX_TO_STEM["_drums.wav"]  = "drums";
    SUFFIX_TO_STEM["_bass.wav"]   = "bass";
    SUFFIX_TO_STEM["_other.wav"]  = "melody";
    SUFFIX_TO_STEM["_melo.wav"]   = "melody";

    // Inner dict key → canonical stem type (library stores "melo" instead of "melody" sometimes)
    var INNER_TO_STEM = {};
    INNER_TO_STEM["vocals"] = "vocals";
    INNER_TO_STEM["melody"] = "melody";
    INNER_TO_STEM["melo"]   = "melody";
    INNER_TO_STEM["bass"]   = "bass";
    INNER_TO_STEM["drums"]  = "drums";

    // trackStemFiles[sourceName][stemType] = library top-level key (filename)
    var trackStemFiles = {};

    for (var ki = 0; ki < topKeys.length; ki++) {
        var key = String(topKeys[ki]);
        var kl  = key.toLowerCase();
        for (var suf in SUFFIX_TO_STEM) {
            var idx_suf = kl.lastIndexOf(suf);
            if (idx_suf !== -1) {
                var stemType   = SUFFIX_TO_STEM[suf];
                var sourceName = key.substring(0, idx_suf).replace(/[_\-]+$/, "").trim();
                if (!trackStemFiles[sourceName]) trackStemFiles[sourceName] = {};
                trackStemFiles[sourceName][stemType] = key;
                break;
            }
        }
    }

    // ── 2. Sort source tracks alphabetically → assign slot numbers ───────────────
    var sourceNames = [];
    for (var tn in trackStemFiles) sourceNames.push(tn);
    sourceNames.sort();

    for (var si = 0; si < sourceNames.length; si++) {
        slotMap[sourceNames[si]] = si;
    }
    post("EBYS Slicer: " + sourceNames.length + " source track(s): "
         + sourceNames.map(function(n, i){ return i + "=" + n; }).join(", ") + "\n");

    // Initialise per-stem arrays
    for (var t = 0; t < TRACKS.length; t++) {
        byTrack[TRACKS[t]] = [];
        meta[TRACKS[t]]    = { key: "", track_name: "" };
    }

    // ── 3. Load slices from every source track / stem combination ────────────────
    for (var ti = 0; ti < sourceNames.length; ti++) {
        var sourceName = sourceNames[ti];
        var slot       = slotMap[sourceName];
        var files      = trackStemFiles[sourceName];

        for (var t = 0; t < TRACKS.length; t++) {
            var track    = TRACKS[t];
            var filename = files[track];
            if (!filename) continue;  // this source track has no analysis for this stem

            var fileDict = d.get(filename);
            if (!fileDict || typeof fileDict.get !== "function") continue;

            // Inner dict key might be "melody", "melo", "vocals", etc.
            var stemDict = null;
            var tryKeys  = [track, "melo", "melody", "vocals", "drums", "bass"];
            for (var tk = 0; tk < tryKeys.length; tk++) {
                var candidate = fileDict.get(tryKeys[tk]);
                if (candidate && typeof candidate.get === "function") {
                    if (INNER_TO_STEM[tryKeys[tk]] === track || tryKeys[tk] === track) {
                        stemDict = candidate; break;
                    }
                }
            }
            // Fallback: try any key whose canonical name matches the track
            if (!stemDict) {
                var innerKeys = fileDict.getkeys ? fileDict.getkeys() : [];
                for (var ik = 0; ik < innerKeys.length; ik++) {
                    var ik_str = String(innerKeys[ik]);
                    if (INNER_TO_STEM[ik_str] === track) {
                        stemDict = fileDict.get(ik_str);
                        if (stemDict && typeof stemDict.get === "function") break;
                        stemDict = null;
                    }
                }
            }
            if (!stemDict) continue;

            var metaDict = stemDict.get("metadata");
            // BPM and BPM_confidence are NOT read — FluCoMa per-stem BPM is unreliable
            // (octave doubling on non-percussive stems). Madmom full-mix BPM is used instead
            // via trackDownbeats[slice.sourceTrack].bpm in stretchRatioForSlice() and
            // effectiveBPMForSource(). FluCoMa BPM is not stored anywhere.
            var mkey = metaDict ? String(metaDict.get("key")        || "")          : "";
            var tname= metaDict ? String(metaDict.get("track_name") || "")          : "";
            var durMs= metaDict ? (parseFloat(metaDict.get("stemDurMs"))      || 0) : 0;

            // meta stores key and track_name only — no BPM.
            meta[track] = { key: mkey, track_name: tname };
            if (durMs > 0) stemDurMs[track] = durMs;

            var slicesDict = stemDict.get("slices");
            if (!slicesDict || typeof slicesDict.getkeys !== "function") continue;

            var sliceKeys = slicesDict.getkeys();
            sliceKeys.sort();

            // Temporary array for slices belonging to this source-track/stem pair.
            // dur, end-descriptors, and T are computed within this sub-array so they
            // stay coherent (no cross-track neighbour calculations).
            var sub = [];

            for (var sk = 0; sk < sliceKeys.length; sk++) {
                var id = sliceKeys[sk];
                if (String(id).indexOf("slice_") !== 0) continue;
                var n  = parseInt(String(id).replace("slice_", "")) || 0;

                var sd = slicesDict.get(id);
                if (!sd || typeof sd.get !== "function") continue;

                var tval = function(k) {
                    var v = sd.get(k);
                    return (v === null || v === undefined || v === "") ? null : parseFloat(v);
                };
                var slice = {
                    track      : track,
                    sourceTrack: sourceName,
                    slot       : slot,
                    stemDurMs  : durMs,
                    id: id, n: n,
                    time: parseFloat(sd.get("time")) || 0,
                    C   : parseFloat(sd.get("C"))    || 0,
                    S   : parseFloat(sd.get("S"))    || 0,
                    P   : parseFloat(sd.get("P"))    || 0,
                    E   : parseFloat(sd.get("E"))    || -60,
                    F   : parseFloat(sd.get("F"))    || 0,
                    H   : parseFloat(sd.get("H"))    || 0,
                    M0  : parseFloat(sd.get("M0"))   || 0,
                    M1  : parseFloat(sd.get("M1"))   || 0,
                    M2  : parseFloat(sd.get("M2"))   || 0,
                    M3  : parseFloat(sd.get("M3"))   || 0,
                    M4  : parseFloat(sd.get("M4"))   || 0,
                    M5  : parseFloat(sd.get("M5"))   || 0,
                    tension_C: tval("tension_C"), tension_E: tval("tension_E"), tension_F: tval("tension_F"),
                    tension_P: tval("tension_P"), tension_H: tval("tension_H"), tension_T: tval("tension_T"),
                    // Analysis-driven M/S — written by add_stereo_features.py
                    // pan: -1..+1 from original mix L-R balance at slice time
                    // width: 0..1 from stem M/S ratio, normalized within stem
                    pan  : (tval("pan")   !== null ? tval("pan")   : 0),
                    width: (tval("width") !== null ? tval("width") : 0.5),
                    key: mkey, dur: LAST_SLICE_DEFAULT_DUR,
                    genres: trackGenres[sourceName] || []
                };
                sub.push(slice);
            }

            // ── Per-source-track post-processing ──────────────────────────────────
            // Infer dur from successive start times WITHIN this source track
            for (var i = 0; i < sub.length - 1; i++) {
                sub[i].dur = sub[i + 1].time - sub[i].time;
            }

            // Compute T and end-descriptors within this source track
            for (var i = 0; i < sub.length; i++) {
                var m1=sub[i].M1, m2=sub[i].M2, m3=sub[i].M3, m4=sub[i].M4, m5=sub[i].M5;
                sub[i].T = Math.sqrt((m1*m1 + m2*m2 + m3*m3 + m4*m4 + m5*m5) / 5.0);
            }
            for (var i = 0; i < sub.length - 1; i++) {
                sub[i].endC = sub[i+1].C;  sub[i].deltaC = sub[i+1].C - sub[i].C;
                sub[i].endS = sub[i+1].S;  sub[i].deltaS = sub[i+1].S - sub[i].S;
                sub[i].endE = sub[i+1].E;  sub[i].deltaE = sub[i+1].E - sub[i].E;
                sub[i].endF = sub[i+1].F;  sub[i].deltaF = sub[i+1].F - sub[i].F;
                sub[i].endP = sub[i+1].P;  sub[i].deltaP = sub[i+1].P - sub[i].P;
                sub[i].endH = sub[i+1].H;  sub[i].deltaH = sub[i+1].H - sub[i].H;
                sub[i].endT = sub[i+1].T;  sub[i].deltaT = sub[i+1].T - sub[i].T;
            }
            if (sub.length > 0) {
                var last = sub[sub.length - 1];
                last.endC=last.C; last.endS=last.S; last.endE=last.E; last.endF=last.F;
                last.endP=last.P; last.endH=last.H; last.endT=last.T;
                last.deltaC=0; last.deltaS=0; last.deltaE=0; last.deltaF=0;
                last.deltaP=0; last.deltaH=0; last.deltaT=0;
            }

            // Append to global byTrack array for this stem (slices from all source tracks)
            for (var i = 0; i < sub.length; i++) {
                byTrack[track].push(sub[i]);
                idx.push(sub[i]);
            }

            post("EBYS Slicer [" + track + "/" + sourceName + " slot=" + slot + "]: "
                 + sub.length + " slices  BPM=" + effectiveBPMForSource(sourceName).toFixed(1)
                 + "  stemDurMs=" + (durMs/1000).toFixed(2) + "s\n");
        }
    }

    // ── 4. Cap slice counts, compute ranges ──────────────────────────────────────
    for (var t = 0; t < TRACKS.length; t++) {
        var track = TRACKS[t];
        var arr   = byTrack[track];

        if (MAX_SLICES_PER_STEM > 0 && arr.length > MAX_SLICES_PER_STEM) {
            var step = arr.length / MAX_SLICES_PER_STEM;
            var sampled = [];
            for (var si = 0; si < MAX_SLICES_PER_STEM; si++) {
                sampled.push(arr[Math.round(si * step)]);
            }
            byTrack[track] = arr = sampled;
        }

        if (arr.length === 0) { ranges[track] = {}; continue; }

        var rC={min:Infinity,max:-Infinity}, rS={min:Infinity,max:-Infinity};
        var rP={min:Infinity,max:-Infinity};
        var rE={min:Infinity,max:-Infinity}, rF={min:Infinity,max:-Infinity};
        var rH={min:Infinity,max:-Infinity}, rT={min:Infinity,max:-Infinity};
        var rDur={min:Infinity,max:-Infinity};
        for (var i = 0; i < arr.length; i++) {
            var s = arr[i];
            if (s.C<rC.min)rC.min=s.C; if(s.C>rC.max)rC.max=s.C;
            if (s.S<rS.min)rS.min=s.S; if(s.S>rS.max)rS.max=s.S;
            if (s.P<rP.min)rP.min=s.P; if(s.P>rP.max)rP.max=s.P;
            if (s.E<rE.min)rE.min=s.E; if(s.E>rE.max)rE.max=s.E;
            if (s.F<rF.min)rF.min=s.F; if(s.F>rF.max)rF.max=s.F;
            if (s.H<rH.min)rH.min=s.H; if(s.H>rH.max)rH.max=s.H;
            if (s.T<rT.min)rT.min=s.T; if(s.T>rT.max)rT.max=s.T;
            if (s.dur<rDur.min)rDur.min=s.dur; if(s.dur>rDur.max)rDur.max=s.dur;
        }
        ranges[track] = { C:rC, S:rS, P:rP, E:rE, F:rF, H:rH, T:rT, dur:rDur };

        if (rC.max > rC.min) norm.C = Math.max(norm.C, rC.max - rC.min);
        if (rS.max > rS.min) norm.S = Math.max(norm.S, rS.max - rS.min);
        if (rE.max > rE.min) norm.E = Math.max(norm.E, rE.max - rE.min);
        if (rF.max > rF.min) norm.F = Math.max(norm.F, rF.max - rF.min);
        if (rP.max > rP.min) norm.P = Math.max(norm.P, rP.max - rP.min);
        if (rH.max > rH.min) norm.H = Math.max(norm.H, rH.max - rH.min);
        if (rT.max > rT.min) norm.T = Math.max(norm.T, rT.max - rT.min);
    }

    post("EBYS Slicer: index ready — " + idx.length + " total slices\n");
    outlet(1, "ready", idx.length);
    var nV = byTrack.vocals ? byTrack.vocals.length : 0;
    var nM = byTrack.melody ? byTrack.melody.length : 0;
    var nB = byTrack.bass   ? byTrack.bass.length   : 0;
    var nD = byTrack.drums  ? byTrack.drums.length  : 0;
    outlet(1, "slices", nV, nM, nB, nD);
    post("EBYS Slicer: slices — vocals=" + nV + " melody=" + nM + " bass=" + nB + " drums=" + nD + "\n");
    // Emit source track names and their slots
    for (var si = 0; si < sourceNames.length; si++) {
        outlet(1, "sourceTrack", si, sourceNames[si]);
        post("EBYS Slicer: sourceTrack " + si + " = " + sourceNames[si] + "\n");
    }
    // Ask Max to resend stem durations — stemDurMs resets on every autowatch reload
    outlet(1, "need_stemDurs");
    // Load downbeat data from allin1_tagger.py output (if present)
    loadDownbeats();
    // Persist index to JSON so it survives patch reloads
    saveIndex();
    // Compute per-stem UMAP embeddings (requires fluid objects wired in Max patch)
    feedUMAP();
}

// ── INDEX PERSISTENCE — delegated to ws_server.js (Node) ─────────────────────
// Max's File API cannot reliably open files by absolute path. All index I/O
// goes through ws_server.js which uses Node's fs module (no restrictions).
//
// SAVE: after buildIndex(), slicer sends JSON in 2 KB chunks via
//   outlet(1, "saveIdxChunk", i, total, data)
//   ws_server accumulates and writes ebys_index.json to MAX/.
//
// LOAD: ws_server reads ebys_index.json on startup and sends it to slicer
//   via idxchunk messages before the TUI connects — index is ready immediately.
//   buildIndex (triggered by TUI) overwrites this with fresh data.

var saveIdxStreamId = 0;  // increments with each saveIndex() call

function saveIndex() {
    var payload = { meta: meta, byTrack: byTrack, ranges: ranges };
    var jsonStr = JSON.stringify(payload);
    var CHUNK   = 2048;
    var total   = Math.ceil(jsonStr.length / CHUNK);
    var sid     = ++saveIdxStreamId;
    for (var i = 0; i < total; i++) {
        outlet(1, "saveIdxChunk", sid, i, total, jsonStr.substring(i * CHUNK, (i + 1) * CHUNK));
    }
    post("EBYS Slicer: index sent to ws_server (stream " + sid + ", " + total + " chunks, " + jsonStr.length + " chars)\n");
}

var idxChunkBuf      = null;
var idxChunkTotal    = 0;
var idxChunkReceived = 0;
var idxChunkSid      = -1;

function idxchunk() {
    var args = arrayfromargs(arguments);
    var sid  = parseInt(args[0]);
    var i    = parseInt(args[1]);
    var t    = parseInt(args[2]);
    var data = args.slice(3).join(' ');
    if (!idxChunkBuf || idxChunkSid !== sid) {
        if (idxChunkBuf) {
            post("EBYS Slicer: idxchunk stream reset (was " + idxChunkSid
                 + ", now " + sid + ") — " + idxChunkReceived + "/" + idxChunkTotal + " chunks dropped\n");
        }
        idxChunkBuf      = new Array(t);
        idxChunkTotal    = t;
        idxChunkSid      = sid;
        idxChunkReceived = 0;
    }
    if (idxChunkBuf[i] !== undefined) return; // duplicate
    idxChunkBuf[i] = data;
    idxChunkReceived++;
    if (idxChunkReceived !== t) return;

    var assembled = idxChunkBuf.join('');
    idxChunkBuf = null;
    try {
        var payload = JSON.parse(assembled);
        meta    = payload.meta    || {};
        ranges  = payload.ranges  || {};
        byTrack = payload.byTrack || {};
        idx = [];
        for (var tr = 0; tr < TRACKS.length; tr++) {
            var arr = byTrack[TRACKS[tr]] || [];
            for (var j = 0; j < arr.length; j++) idx.push(arr[j]);
        }
        for (var tr = 0; tr < TRACKS.length; tr++) {
            var r = ranges[TRACKS[tr]];
            if (!r) continue;
            if (r.C && r.C.max > r.C.min) norm.C = Math.max(norm.C, r.C.max - r.C.min);
            if (r.S && r.S.max > r.S.min) norm.S = Math.max(norm.S, r.S.max - r.S.min);
            if (r.E && r.E.max > r.E.min) norm.E = Math.max(norm.E, r.E.max - r.E.min);
            if (r.F && r.F.max > r.F.min) norm.F = Math.max(norm.F, r.F.max - r.F.min);
            if (r.P && r.P.max > r.P.min) norm.P = Math.max(norm.P, r.P.max - r.P.min);
            if (r.H && r.H.max > r.H.min) norm.H = Math.max(norm.H, r.H.max - r.H.min);
            if (r.T && r.T.max > r.T.min) norm.T = Math.max(norm.T, r.T.max - r.T.min);
        }
        post("EBYS Slicer: loaded " + idx.length + " slices from cached index\n");
        loadDownbeats();
        outlet(1, "ready", idx.length);
        var rawName   = (meta["vocals"] && meta["vocals"].track_name) ? meta["vocals"].track_name : "";
        var trackName = rawName.replace(/_(vocals|melody|bass|drums|melo)(\.\w+)?$/i, "").trim();
        if (trackName) outlet(1, "track_name", trackName);
        outlet(1, "need_stemDurs");
    } catch(e) {
        post("EBYS Slicer: cached index parse failed — " + e + "\n");
    }
}

// ── CANDIDATE SCORING ────────────────────────────────────────────────────────
// Lower score = better candidate.
//
// Two independent criteria:
//   1. TRANSITION MATCH — how closely does candidate.start match current.end?
//      Weighted by MATCH_PROB per descriptor (0=ignore, 1=strict).
//   2. DIRECTION PREFERENCE — does the candidate evolve the way Cricket wants?
//      Weighted by DIR_PREF per descriptor (-1=down, 0=neutral, +1=up).
//
// When both MATCH_PROB and DIR_PREF are all zero the score is always 0
// and the caller falls back to random / descriptor distance as before.

function scoreCandidate(candidate, endDesc) {
    var score = 0;
    var dims  = ['C', 'S', 'E', 'F', 'P', 'H', 'T'];
    for (var i = 0; i < dims.length; i++) {
        var d = dims[i];

        // 1. Transition match
        if (MATCH_PROB > 0 && endDesc) {
            var val = (d === 'T') ? (candidate.T || 0) : candidate[d];
            var ref = (d === 'T') ? (endDesc.T  || 0) : endDesc[d];
            var diff = (val - ref) / (norm[d] || 1);
            score += MATCH_PROB * diff * diff;
        }

        // 2. Direction preference
        // delta > 0 means this slice is evolving upward in descriptor d.
        // DIR_PREF[d] = 1 → want rising → reward high delta → subtract from score.
        if (DIR_PREF[d] !== 0) {
            var delta = (candidate['delta' + d] || 0) / (norm[d] || 1);
            score -= DIR_PREF[d] * delta * DIR_WEIGHT;
        }
    }
    return score;
}

function hasActiveCriteria() {
    return (MATCH_PROB > 0 ||
            DIR_PREF.C !== 0 || DIR_PREF.S !== 0 || DIR_PREF.E !== 0 || DIR_PREF.F !== 0 || DIR_PREF.P !== 0 ||
            DIR_PREF.H !== 0 || DIR_PREF.T !== 0);
}

// ── DOWNBEAT HELPERS ──────────────────────────────────────────────────────────

// loadDownbeats — reads ../downbeats.json and populates trackDownbeats for all stems.
// Called at the end of buildIndex() and loadIndex(), and via "reloadDownbeats" message.
function getPatcherDir() {
    var fp = patcher.filepath || "";
    var slash = fp.indexOf('/');
    if (slash > 0) fp = fp.slice(slash);
    fp = fp.replace(/[^\/\\]+$/, '');
    if (fp.length > 0 && fp[fp.length-1] !== '/') fp += '/';
    return fp;
}

// Returns the data/ directory (EBYS/data/) relative to the patch location.
// Patch lives at EBYS/src/max/ → strip max/ → strip src/ → append data/
function getDataDir() {
    var p = getPatcherDir();         // .../EBYS/src/max/
    p = p.replace(/[^\/]+\/$/, ''); // strip max/ → .../EBYS/src/
    p = p.replace(/[^\/]+\/$/, ''); // strip src/ → .../EBYS/
    return p + 'data/';
}

function loadDownbeats() {
    trackDownbeats = {};
    try {
        // Use data received via downbeatchunk from ws_server (preferred — Node resolves paths).
        // Falls back to direct file read if chunks haven't arrived yet.
        var db = downbeatsRaw;
        if (!db) {
            var f = new File(getDataDir() + "downbeats.json", "read", "TEXT");
            if (!f.isopen) { return; }
            var raw = "";
            while (!f.eof) raw += f.readline();
            f.close();
            db = JSON.parse(raw);
        }

        // Collect unique source track names from the loaded slices.
        var sourceTrackNames = [];
        var seen = {};
        for (var t = 0; t < TRACKS.length; t++) {
            var arr = byTrack[TRACKS[t]] || [];
            for (var j = 0; j < arr.length; j++) {
                var sn = arr[j].sourceTrack;
                if (sn && !seen[sn]) { seen[sn] = true; sourceTrackNames.push(sn); }
            }
        }

        if (sourceTrackNames.length === 0) {
            post("EBYS Slicer: loadDownbeats — no source tracks in index yet\n");
            return;
        }

        // For each source track, look up its entry in downbeats.json.
        var loaded = 0;
        for (var si = 0; si < sourceTrackNames.length; si++) {
            var name  = sourceTrackNames[si];
            var entry = db[name];
            if (!entry) {
                // Case-insensitive fallback
                var nl = name.toLowerCase();
                for (var k in db) {
                    if (k.toLowerCase() === nl) { entry = db[k]; break; }
                }
            }
            if (!entry) {
                post("EBYS Slicer: loadDownbeats — no entry for '" + name + "'\n");
                continue;
            }
            trackDownbeats[name] = entry;
            loaded++;
            post("EBYS Slicer: downbeats loaded — track='" + name
                 + "'  meter=" + entry.meter
                 + "  bpm=" + entry.bpm
                 + "  downbeats=" + (entry.downbeats_ms ? entry.downbeats_ms.length : 0)
                 + "  conf=" + entry.confidence + "\n");
        }

        if (loaded === 0) {
            post("EBYS Slicer: loadDownbeats — no matching entries in downbeats.json\n");
        }

    } catch(e) {
        post("EBYS Slicer: loadDownbeats error — " + e + "\n");
    }
}

// getDbForSource — returns the downbeat entry for a source track name.
// For named tracks, returns null if not found (caller must handle gracefully).
// Passing no sourceTrack (undefined/null) is allowed for single-track sessions
// and returns the first available entry — never cross-contaminates named tracks.
function getDbForSource(sourceTrack) {
    if (sourceTrack) {
        if (trackDownbeats[sourceTrack]) return trackDownbeats[sourceTrack];
        post("EBYS Slicer: WARNING — no downbeat data for '" + sourceTrack
             + "' — BPM grid fallback (run madmom_tagger.py)\n");
        return null;
    }
    // No sourceTrack specified — single-track context, return whatever is available.
    for (var k in trackDownbeats) return trackDownbeats[k];
    return null;
}

// getBarMs — average bar duration in ms for this source track.
// Uses madmom avgBarMs when confidence is high enough; falls back to BPM grid.
// sourceTrack is optional — omit for non-slice contexts (uses first available entry).
function getBarMs(track, bpm, sourceTrack) {
    var db = getDbForSource(sourceTrack);
    if (db && db.confidence >= DOWNBEAT_MIN_CONF && db.avgBarMs > 0) {
        return db.avgBarMs;
    }
    // BPM fallback — assume 4/4 (or use meter if stored)
    var meter = (db && db.meter > 0) ? db.meter : 4;
    return (60000.0 / bpm) * meter;
}

// isNearDownbeat — true if posMs is within BAR_SNAP_MS of any stored downbeat.
// sourceTrack is optional — pass slice.sourceTrack for per-track accuracy.
// Falls back to posMs % barMs < BAR_SNAP_MS when no confident downbeats available.
function isNearDownbeat(posMs, track, barMs, sourceTrack) {
    var db = getDbForSource(sourceTrack);
    if (db && db.confidence >= DOWNBEAT_MIN_CONF && db.downbeats_ms && db.downbeats_ms.length > 1) {
        var beats = db.downbeats_ms;
        for (var i = 0; i < beats.length; i++) {
            if (Math.abs(posMs - beats[i]) <= BAR_SNAP_MS) return true;
        }
        return false;
    }
    // BPM grid fallback
    var offset = posMs % barMs;
    return offset < BAR_SNAP_MS || (barMs - offset) < BAR_SNAP_MS;
}

// ── SEGMENT SELECTION ─────────────────────────────────────────────────────────
//
// How bar-alignment works (madmom mode):
//   When downbeats.json has a confident entry, isNearDownbeat() checks proximity
//   to actual detected downbeat timestamps — works for any meter, any tempo,
//   any phase offset, and electroacoustic music with drifting tempo.
//
// Fallback (BPM grid):
//   bar_ms = 60000 / BPM * meter  — assumes bar1 = t0, fixed grid.
//   Used when confidence < DOWNBEAT_MIN_CONF or no downbeats.json present.
//
// Why this matters musically:
//   Random cuts that begin mid-bar sound like edits; cuts on beat 1 of a bar
//   feel intentional and maintain the rhythmic pulse across all 4 stems.
//
function selectSegment(track) {
    var arr = (track && byTrack[track]) ? byTrack[track] : null;
    if (!arr || arr.length === 0) {
        outlet(1, "empty_pool", track || "?");
        return;
    }

    // Effective BPM for this track — use first slice's sourceTrack for madmom BPM.
    // This is a best-effort value for pool building; barMs is recomputed per-startSlice
    // after selection so the actual segment duration is always correct.
    var firstSrc = arr.length > 0 ? arr[0].sourceTrack : null;
    var bpm      = effectiveBPMForSource(firstSrc);
    var barMs    = getBarMs(track, bpm, firstSrc);
    var targetMs = barMs * SEGMENT_BARS[track];

    // Convert fractions to ms using known stem duration.
    // With multi-track, each slice carries its own stemDurMs from the library.
    // The global stemDurMs[track] is used as a fallback only.
    // Pool building uses per-slice stemDurMs so bar-alignment works across different
    // source tracks that may have different durations.
    var hasDur = false;
    for (var i = 0; i < arr.length; i++) {
        if ((arr[i].stemDurMs || 0) > 0) { hasDur = true; break; }
    }
    if (!hasDur && stemDurMs[track] > 0) hasDur = true;

    // Build candidate pool (bar-aligned or full).
    var pool = null;
    if (QUANTIZE_BARS && hasDur) {
        var aligned = [];
        for (var i = 0; i < arr.length; i++) {
            if (!sliceMatchesGenre(arr[i])) continue;
            if (!sliceMatchesKey(arr[i])) continue;
            var sliceDurMs = arr[i].stemDurMs || stemDurMs[track] || 0;
            if (sliceDurMs <= 0) { aligned.push(i); continue; }
            var posMs = arr[i].time * sliceDurMs;
            if (isNearDownbeat(posMs, track, barMs, arr[i].sourceTrack)) aligned.push(i);
        }
        if (aligned.length >= 2) pool = aligned;
    }
    if (!pool) {
        pool = [];
        for (var i = 0; i < arr.length; i++) {
            if (sliceMatchesGenre(arr[i]) && sliceMatchesKey(arr[i])) pool.push(i);
        }
        // If combined filter returns nothing, fall back to all slices
        if (pool.length === 0) {
            for (var i = 0; i < arr.length; i++) pool.push(i);
            post("EBYS Slicer [" + track + "]: genre/key filter matched 0 slices — ignoring filter\n");
        }
    }

    // Stay-or-move decision
    var startIdx;
    if (STAY_PROB[track] > 0 && Math.random() < STAY_PROB[track]
        && lastSourceTrack[track] !== null && lastEndFrac[track] >= 0) {
        // Stay on the same source track — advance to the first pool slice that
        // starts AT or AFTER where the last segment ended (forward progression).
        // If we've run off the end of the track, wrap back to the beginning.
        var stayTrack = lastSourceTrack[track];
        var afterFrac = lastEndFrac[track];
        var best = -1;
        // First pass: slices on the same track that come after the current position
        for (var pi = 0; pi < pool.length; pi++) {
            var ci = pool[pi];
            if (arr[ci].sourceTrack === stayTrack && arr[ci].time >= afterFrac) {
                if (best < 0 || arr[ci].time < arr[best].time) best = ci;
            }
        }
        // Second pass (wrap): any slice on the same track
        if (best < 0) {
            for (var pi = 0; pi < pool.length; pi++) {
                var ci = pool[pi];
                if (arr[ci].sourceTrack === stayTrack) {
                    if (best < 0 || arr[ci].time < arr[best].time) best = ci;
                }
            }
        }
        startIdx = best >= 0 ? best : pool[Math.floor(Math.random() * pool.length)];
    } else if (hasActiveCriteria()) {
        // Score every candidate — pick the one with the lowest combined score.
        var endDesc   = getBlendedEndDesc(track);
        var bestScore = Infinity;
        startIdx = pool[0];
        for (var pi = 0; pi < pool.length; pi++) {
            var sc = scoreCandidate(arr[pool[pi]], endDesc);
            if (sc < bestScore) { bestScore = sc; startIdx = pool[pi]; }
        }
    } else {
        startIdx = pool[Math.floor(Math.random() * pool.length)];
    }
    lastIdx[track]         = startIdx;
    lastSourceTrack[track] = arr[startIdx].sourceTrack;

    var startSlice = arr[startIdx];

    // Recompute barMs using the chosen startSlice's source track — critical for
    // multi-track sessions where source tracks have different BPMs/downbeats.
    // The pool-building barMs above may be from a different source track.
    var srcBpm  = effectiveBPMForSource(startSlice.sourceTrack);
    barMs       = getBarMs(track, srcBpm, startSlice.sourceTrack);
    targetMs    = barMs * SEGMENT_BARS[track];

    // Use this slice's own stemDurMs for accumulation (multi-track: different tracks
    // can have different durations; each slice knows which track it's from).
    var durMs = startSlice.stemDurMs || stemDurMs[track] || 0;

    // Accumulate consecutive slices until targetMs covered.
    // CRITICAL: only include slices from the SAME source track as startSlice.
    // This ensures each segment is a coherent excerpt from one recording,
    // not a cross-track splice mid-segment.
    var totalFrac = 0;
    var i = startIdx;
    if (durMs > 0) {
        while (i < arr.length
               && arr[i].sourceTrack === startSlice.sourceTrack
               && (totalFrac * durMs) < targetMs) {
            totalFrac += arr[i].dur;
            i++;
        }
        // Ensure minimum 1 bar
        if ((totalFrac * durMs) < barMs) totalFrac = barMs / durMs;
    } else {
        // No stem duration known — use SEGMENT_BARS * 8 slices as proxy
        // so setSegmentBars still has an effect even before stemDurMs is set
        var fallbackCount = Math.max(4, Math.round(SEGMENT_BARS[track] * 8));
        var count = 0;
        while (i < arr.length
               && arr[i].sourceTrack === startSlice.sourceTrack
               && count < fallbackCount) {
            totalFrac += arr[i].dur;
            i++;
            count++;
        }
    }

    // Emit — both values are 0-1 fractions of buffer length.
    // outlet 0: track  start_frac  end_frac
    // In Max:  start_frac * buf_ms → prepend start → play~
    //          (end_frac - start_frac) * buf_ms → delay
    var endFrac = Math.min(startSlice.time + totalFrac, 1.0);
    lastEndFrac[track] = endFrac;
    lastSlice = { track: track, time: startSlice.time, dur: totalFrac };

    // Store end-descriptors so next selection can match against them
    lastEndDesc[track] = {
        C: startSlice.endC, E: startSlice.endE,
        F: startSlice.endF, P: startSlice.endP,
        H: startSlice.endH, T: startSlice.endT
    };

    // Compute actual duration in ms for delay timing in Max (sent on outlet 0)
    var segDurMs;
    if (durMs > 0) {
        segDurMs = totalFrac * durMs;
    } else {
        // stemDurMs unknown — estimate from madmom BPM for this source track
        var bpmEst = effectiveBPMForSource(startSlice.sourceTrack);
        segDurMs = (60000.0 / bpmEst) * 4.0 * SEGMENT_BARS[track];
    }
    // Emit absolute time position in ms (for TUI timer anchor via slice_ms on outlet 1)
    var sliceMs = (durMs > 0) ? Math.round(startSlice.time * durMs) : 0;

    // Timer uses the GLOBAL bar duration, not the source track's bar duration.
    // If each stem picks a different source track (different BPMs), per-track barMs
    // would give different delay values → stems fire out of sync.
    // Using globalBPM (or FALLBACK_BPM when no override) guarantees all four stems
    // always fire at exactly the same interval: SEGMENT_BARS * (60000 / globalBPM * 4).
    // stretchRatio already compensates for per-track BPM inside karma~.
    var globalBpmForTimer = GLOBAL_BPM > 0 ? GLOBAL_BPM : FALLBACK_BPM;
    var globalBarMs       = (60000.0 / globalBpmForTimer) * 4.0;
    var snapSegDurMs;
    if (globalBarMs > 0 && SEGMENT_BARS[track] > 0) {
        snapSegDurMs = Math.round(SEGMENT_BARS[track] * globalBarMs);
    } else {
        snapSegDurMs = Math.round(segDurMs);
    }
    if (snapSegDurMs <= 0) snapSegDurMs = Math.round(segDurMs); // safety fallback

    // outlet 0: track  slot  startFrac  endFrac  stretchRatio  segDurMs
    //   track       = stem type: "vocals" | "melody" | "bass" | "drums"
    //   slot        = source track index (0 = first alphabetical, 1 = second, …)
    //   startFrac   = 0–1 fraction of buffer where segment starts
    //   endFrac     = 0–1 fraction of buffer where segment ends
    //   stretchRatio= srcBPM / globalBPM  (1.0 when no override)
    //   segDurMs    = bar-snapped segment duration — slot_router uses this for delay timing
    outlet(0, track, startSlice.slot || 0, startSlice.time, endFrac,
           stretchRatioForSlice(startSlice), snapSegDurMs);

    // Speculative preload: guess the next source track and tell buffer_manager
    // to start disk loading now — so the track is ready when the next segment fires.
    // buffer_manager ignores this if the track is already loaded.
    if (arr.length > 0) {
        var nextArr  = byTrack[track];
        var nextIdx  = Math.floor(Math.random() * nextArr.length);
        var nextSlot = (nextArr[nextIdx] && nextArr[nextIdx].slot !== undefined)
                       ? nextArr[nextIdx].slot : 0;
        outlet(0, "preload", track, nextSlot);
    }

    outlet(1, "desc",      track, startSlice.C, startSlice.S, startSlice.E, startSlice.F, startSlice.P, startSlice.H, startSlice.T,
           startSlice.tension_C, startSlice.tension_E, startSlice.tension_F,
           startSlice.tension_P, startSlice.tension_H, startSlice.tension_T);
    // Analysis-driven M/S: emit pan and width for this slice so ms_router can apply them.
    // stemMS <track> <pan> <width> — received by ws_server → forwarded to ms_router.
    outlet(1, "stemMS", track, startSlice.pan, startSlice.width);
    outlet(1, "slice_ms",  track, sliceMs);
    outlet(1, "stemTrack", track, startSlice.sourceTrack);
    outlet(1, "seg",
           track,
           startSlice.sourceTrack + ":" + startSlice.id,
           hasDur ? (Math.round(segDurMs) + "ms") : (totalFrac.toFixed(3) + " frac"),
           "(" + (segDurMs / ((60000.0 / effectiveBPMForSource(startSlice.sourceTrack)) * 4.0)).toFixed(1) + " bars)",
           startSlice.time, endFrac);
}

// ── TRANSPORT ─────────────────────────────────────────────────────────────────

function start() {
    if (idx.length === 0) { outlet(1, "index_empty"); return; }
    running = true;
    // Re-emit sourceTrack slot registrations before firing selectSegment.
    // buffer_manager.js clears slotToTrack on every autowatch reload, so
    // re-sending here ensures it always has current mappings at start time.
    // slotMap is the module-level { name → slot } dict built by buildIndex.
    var slotNames = Object.keys(slotMap).sort(function(a, b) {
        return slotMap[a] - slotMap[b];
    });
    for (var si = 0; si < slotNames.length; si++) {
        outlet(1, "sourceTrack", slotMap[slotNames[si]], slotNames[si]);
    }
    // Fire all 4 stems simultaneously — they then loop independently via "next <track>"
    for (var t = 0; t < TRACKS.length; t++) {
        selectSegment(TRACKS[t]);
    }
    post("EBYS Slicer: started — bars=" + JSON.stringify(SEGMENT_BARS)
         + "  quantize=" + QUANTIZE_BARS
         + "  stay=" + JSON.stringify(STAY_PROB) + "\n");
}

function stop() {
    running = false;
    outlet(1, "stopped");
}

// Called by play~'s done bang: "next vocals" / "next melody" / etc.
function next(track) {
    if (!running) return;
    if (track) {
        // If this stem is looping, replay the locked position
        if (loopState[track]) {
            var lp = loopState[track];
            var loopSliceRef = byTrack[track] && byTrack[track][lp.startIdx];
            var lpDurMs   = (loopSliceRef && loopSliceRef.stemDurMs) || stemDurMs[track] || 0;
            var lpSlot    = (loopSliceRef && loopSliceRef.slot) || 0;
            var loopSegMs = lpDurMs > 0 ? Math.round((lp.endTime - lp.startTime) * lpDurMs) : 4000;
            outlet(0, track, lpSlot, lp.startTime, lp.endTime, stretchRatioForSlice(loopSliceRef || {}), loopSegMs);
            // Emit desc so TUI gets fresh descriptor values for this loop cycle
            var loopSlice = byTrack[track] && byTrack[track][lp.startIdx];
            if (loopSlice) {
                outlet(1, "desc", track, loopSlice.C, loopSlice.S, loopSlice.E, loopSlice.F,
                       loopSlice.P, loopSlice.H, loopSlice.T,
                       loopSlice.tension_C, loopSlice.tension_E, loopSlice.tension_F,
                       loopSlice.tension_P, loopSlice.tension_H, loopSlice.tension_T);
                outlet(1, "stemMS", track, loopSlice.pan, loopSlice.width);
            }
            loopCycles[track]++;
            outlet(1, "seg", track, "loop" + loopCycles[track], lp.bars + "bars", "(looping)");
        } else {
            selectSegment(track);
        }
    } else {
        for (var t = 0; t < TRACKS.length; t++) selectSegment(TRACKS[t]);
    }
}

// loop <track> <bars>  — lock stem to current or next segment of N bars
function loop(track, bars) {
    var arr = byTrack[track];
    if (!arr || arr.length === 0) {
        post("EBYS Slicer: loop — no slices for " + track + "\n");
        return;
    }
    bars = parseFloat(bars) || SEGMENT_BARS;

    // Use first available slice's sourceTrack for madmom BPM — best effort for loop()
    // since we don't have a chosen slice yet. Recompute after startSlice is picked if needed.
    var firstSrc = arr.length > 0 ? arr[0].sourceTrack : null;
    var bpm      = effectiveBPMForSource(firstSrc);
    var barMs    = getBarMs(track, bpm, firstSrc);
    var targetMs = barMs * bars;
    var durMs    = stemDurMs[track] || 0;

    // Select a fresh segment as the loop anchor (same logic as selectSegment)
    var pool = [];
    for (var pi = 0; pi < arr.length; pi++) pool.push(pi);
    var startIdx = hasActiveCriteria()
        ? (function() {
            var best = pool[0], bestSc = Infinity;
            for (var pi = 0; pi < pool.length; pi++) {
                var sc = scoreCandidate(arr[pool[pi]], lastEndDesc[track]);
                if (sc < bestSc) { bestSc = sc; best = pool[pi]; }
            }
            return best;
          })()
        : pool[Math.floor(Math.random() * pool.length)];
    var startSlice = arr[startIdx];

    var totalFrac = 0, i = startIdx;
    if (durMs > 0) {
        while (i < arr.length && (totalFrac * durMs) < targetMs) {
            totalFrac += arr[i].dur; i++;
        }
        if ((totalFrac * durMs) < barMs) totalFrac = barMs / durMs;
    } else {
        var count = 0;
        while (i < arr.length && count < Math.max(4, Math.round(SEGMENT_BARS * 8))) { totalFrac += arr[i].dur; i++; count++; }
    }

    var endTime = Math.min(startSlice.time + totalFrac, 1.0);
    loopState[track] = { bars: bars, startIdx: startIdx,
                         startTime: startSlice.time, endTime: endTime };

    post("EBYS Slicer: loop " + track + " @" + bars + " bars"
         + "  [" + startSlice.time.toFixed(3) + " → " + endTime.toFixed(3) + "]\n");
    outlet(1, "loop", track, bars, "locked");
}

// unloop <track>  — release stem back to normal selection
function unloop(track) {
    if (loopState.hasOwnProperty(track)) {
        loopState[track] = null;
        post("EBYS Slicer: unloop " + track + "\n");
        outlet(1, "unloop", track);
    }
}

// unloopAll  — release all stems
function unloopAll() {
    var tracks = Object.keys(loopState);
    for (var i = 0; i < tracks.length; i++) loopState[tracks[i]] = null;
    post("EBYS Slicer: all loops released\n");
    outlet(1, "unloop", "all");
}

// ── NEAREST-NEIGHBOUR SELECTION ───────────────────────────────────────────────
//
// In Max, replace [msg "next melody"] with this chain:
//
//   outlet 1 of js slicer.js outputs after each slice:
//     "desc melody C E F P"   ← current slice descriptors
//
//   Store C E F P in four [f] boxes.
//   When delay fires → instead of "next melody", send:
//     "nextNearest melody C E F P"
//   to js slicer.js inlet.
//
// Weights control how much each descriptor matters in the distance formula.
// Send "setWeight C 1.0" etc. to tune from Max.
//
var WEIGHTS = { C: 1.0, S: 0.8, E: 2.0, F: 0.5, P: 1.5, H: 1.0, T: 1.5 };
// E weighted highest: energy continuity is most audible.
// P second: pitch continuity holds harmonic coherence.
// T second: timbre (MFCC RMS) fingerprints instrument character well.
// C: brightness continuity.
// S: spectral spread — how wide the energy band is. Slightly below C.
// H: chroma (harmonic colour) — same weight as C.
// F lowest: flatness/noisiness matters less.

function setWeight(dim, val) {
    if (WEIGHTS.hasOwnProperty(dim)) {
        WEIGHTS[dim] = parseFloat(val);
        post("EBYS Slicer: weight[" + dim + "] = " + WEIGHTS[dim] + "\n");
    }
}

// Normalisation ranges — updated at buildIndex time.
// Keeps C (0–22000 Hz) and P (0–4000 Hz) on the same scale as E (-60–0).
// H is already 0–1; T (MFCC RMS) varies ~0–200 depending on material.
var norm = { C: 1, S: 1, E: 1, F: 1, P: 1, H: 1, T: 1 };

function normalisedDist(a, b) {
    var dC = (a.C - b.C) / (norm.C || 1);
    var dS = ((a.S || 0) - (b.S || 0)) / (norm.S || 1);
    var dE = (a.E - b.E) / (norm.E || 1);
    var dF = (a.F - b.F) / (norm.F || 1);
    var dP = (a.P - b.P) / (norm.P || 1);
    var dH = (a.H - b.H) / (norm.H || 1);
    var dT = ((a.T || 0) - (b.T || 0)) / (norm.T || 1);
    return WEIGHTS.C * dC*dC
         + WEIGHTS.S * dS*dS
         + WEIGHTS.E * dE*dE
         + WEIGHTS.F * dF*dF
         + WEIGHTS.P * dP*dP
         + WEIGHTS.H * dH*dH
         + WEIGHTS.T * dT*dT;
}

// Max sends: nextNearest melody <C> <E> <F> <P>
function nextNearest(track, C, E, F, P) {
    if (!running) return;
    var arr = byTrack[track];
    if (!arr || arr.length === 0) { selectSegment(track); return; }

    var ref = { C: parseFloat(C), E: parseFloat(E),
                F: parseFloat(F), P: parseFloat(P) };

    // Find slice with smallest descriptor distance to ref.
    // Skip the slice that just played (lastIdx) to avoid looping the same cut.
    var endDesc = getBlendedEndDesc(track);
    var bestIdx = -1, bestDist = Infinity;
    for (var i = 0; i < arr.length; i++) {
        if (i === lastIdx[track]) continue;
        var d = normalisedDist(arr[i], ref) + scoreCandidate(arr[i], endDesc);
        if (d < bestDist) { bestDist = d; bestIdx = i; }
    }
    if (bestIdx < 0) bestIdx = lastIdx[track]; // fallback: repeat if only 1 slice

    lastIdx[track] = bestIdx;

    // Same duration accumulation as selectSegment
    var durMs    = stemDurMs[track] || 0;
    var hasDur   = durMs > 0;
    var bpm      = effectiveBPMForSource(arr[bestIdx] && arr[bestIdx].sourceTrack);
    var barMs    = getBarMs(track, bpm, arr[bestIdx] && arr[bestIdx].sourceTrack);
    var targetMs = barMs * SEGMENT_BARS[track];

    var totalFrac = 0, i = bestIdx;
    if (hasDur) {
        while (i < arr.length && (totalFrac * durMs) < targetMs) {
            totalFrac += arr[i].dur; i++;
        }
        if ((totalFrac * durMs) < barMs) totalFrac = barMs / durMs;
    } else {
        var count = 0;
        var fallbackCount = Math.max(4, Math.round(SEGMENT_BARS[track] * 8));
        while (i < arr.length && count < fallbackCount) {
            totalFrac += arr[i].dur; i++; count++;
        }
    }

    var s      = arr[bestIdx];
    var endFrac = Math.min(s.time + totalFrac, 1.0);
    lastSlice   = { track: track, time: s.time, dur: totalFrac };

    lastEndDesc[track] = { C: s.endC, E: s.endE, F: s.endF, P: s.endP, H: s.endH, T: s.endT };

    var sliceMs = hasDur ? Math.round(s.time * durMs) : 0;

    outlet(0, track, sliceMs, Math.round(totalFrac * durMs), stretchRatioFor(track));
    outlet(1, "desc",      track, s.C, s.E, s.F, s.P, s.H, s.T,
           s.tension_C, s.tension_E, s.tension_F,
           s.tension_P, s.tension_H, s.tension_T);
    outlet(1, "slice_ms",  track, sliceMs);
    outlet(1, "stemTrack", track, cleanTrackName(track));
    outlet(1, "seg", track, s.id,
           hasDur ? (Math.round(totalFrac * durMs) + "ms") : (totalFrac.toFixed(3) + " frac"),
           "dist=" + bestDist.toFixed(2),
           s.time, endFrac);
}

// ── PARAMETER SETTERS ─────────────────────────────────────────────────────────

function setSegmentBars(trackOrN, n) {
    // setSegmentBars 4           → all tracks
    // setSegmentBars vocals 2    → vocals only
    if (n === undefined) {
        // single-arg form: apply to all
        var val = parseFloat(trackOrN);
        if (val > 0 && val <= 64) {
            for (var t = 0; t < TRACKS.length; t++) SEGMENT_BARS[TRACKS[t]] = val;
            post("EBYS Slicer: segmentBars (all) = " + val + "\n");
            outlet(1, "segmentBars", "all", val);
            applyNow();
        }
    } else {
        var track = trackOrN;
        var val   = parseFloat(n);
        if (SEGMENT_BARS.hasOwnProperty(track) && val > 0 && val <= 64) {
            SEGMENT_BARS[track] = val;
            post("EBYS Slicer: segmentBars[" + track + "] = " + val + "\n");
            outlet(1, "segmentBars", track, val);
            if (running) selectSegment(track);
        }
    }
}

function setQuantize(v) {
    QUANTIZE_BARS = (parseInt(v) !== 0);
    post("EBYS Slicer: quantize = " + QUANTIZE_BARS + "\n");
    outlet(1, "quantize", QUANTIZE_BARS ? 1 : 0);
    applyNow();
}

// reloadDownbeats — hot-reload ../downbeats.json without re-running buildIndex.
// Send this message from Max after running allin1_tagger.py on a track that's
// already loaded (so you don't have to re-analyse in FluCoMa just to pick up
// the new downbeat data).
function reloadDownbeats() {
    loadDownbeats();
}

function setStayProb(trackOrV, v) {
    // setStayProb 0.5          → all tracks
    // setStayProb drums 0.8   → drums only
    if (v === undefined) {
        var val = clamp(parseFloat(trackOrV), 0.0, 1.0);
        for (var t = 0; t < TRACKS.length; t++) STAY_PROB[TRACKS[t]] = val;
        post("EBYS Slicer: stayProb (all) = " + val + "\n");
        outlet(1, "stayProb", "all", val);
    } else {
        var track = trackOrV;
        var val   = clamp(parseFloat(v), 0.0, 1.0);
        if (STAY_PROB.hasOwnProperty(track)) {
            STAY_PROB[track] = val;
            post("EBYS Slicer: stayProb[" + track + "] = " + val + "\n");
            outlet(1, "stayProb", track, val);
        }
    }
}

function setMaxSlices(n) {
    n = parseInt(n);
    MAX_SLICES_PER_STEM = (n > 0) ? n : 0;
    post("EBYS Slicer: maxSlices = " + (MAX_SLICES_PER_STEM || "unlimited") + "\n");
}

function setFallbackBPM(n) {
    n = parseFloat(n);
    if (n > 40 && n < 280) {
        FALLBACK_BPM = n;
        post("EBYS Slicer: fallbackBPM = " + FALLBACK_BPM + "\n");
        applyNow();
    }
}

// setGlobalBPM N  — force ALL stems to use N BPM, ignoring analysis
// setGlobalBPM 0  — clear override, resume using analyzed BPM
function setGlobalBPM(n) {
    n = parseFloat(n);
    if (n === 0) {
        GLOBAL_BPM = 0;
        post("EBYS Slicer: globalBPM cleared — using analyzed BPM\n");
        applyNow();
    } else if (n > 40 && n < 280) {
        GLOBAL_BPM = n;
        post("EBYS Slicer: globalBPM = " + GLOBAL_BPM + " — applying now, segBars=" + SEGMENT_BARS + "\n");
        outlet(1, "globalBPM", GLOBAL_BPM);
        applyNow();
    } else {
        post("EBYS Slicer: setGlobalBPM rejected value: " + n + "\n");
    }
}

// Internal helper — BPM resolution without a specific source track context.
// Falls back to FALLBACK_BPM since meta[track].BPM (FluCoMa) is no longer stored.
// Prefer effectiveBPMForSource(sourceTrack) whenever a slice or sourceTrack is available.
function effectiveBPM(track) {
    if (GLOBAL_BPM > 0) return GLOBAL_BPM;
    return FALLBACK_BPM;
}

// Per-source-track BPM — uses madmom BPM when available (more reliable than FluCoMa).
// Used for barMs calculations in selectSegment so multi-track sessions get correct
// bar durations even when source tracks have different tempos.
function effectiveBPMForSource(sourceTrack) {
    if (GLOBAL_BPM > 0) return GLOBAL_BPM;
    var db = sourceTrack && trackDownbeats[sourceTrack];
    if (db && db.bpm > 40 && db.bpm < 280) return db.bpm;
    return FALLBACK_BPM;
}

// Stretch ratio for fluid.bufstretch~ @timeratio
// = analyzedBPM / targetBPM  (>1 = stretch longer/slower, <1 = compress/faster)
// Returns 1.0 when no global BPM override is active (no stretching needed).
// Legacy — only called by nextNearest() which is unused.
// Uses FALLBACK_BPM since FluCoMa BPM is no longer stored.
// Any active code path should use stretchRatioForSlice(slice) instead.
function stretchRatioFor(track) {
    if (GLOBAL_BPM <= 0) return 1.0;
    return FALLBACK_BPM / GLOBAL_BPM;
}

// Per-slice version: uses madmom BPM for the slice's source track.
// FluCoMa per-stem BPM is never used here — it is unreliable (often detects
// octave-doubled tempo on non-percussive stems, e.g. 161 BPM for a 120 BPM track).
// madmom analyzes the full mix and is the canonical BPM source.
function stretchRatioForSlice(slice) {
    if (GLOBAL_BPM <= 0) return 1.0;
    var db = slice.sourceTrack && trackDownbeats[slice.sourceTrack];
    if (!db || !(db.bpm > 40 && db.bpm < 280)) {
        post("EBYS Slicer: WARNING — no madmom BPM for '" + slice.sourceTrack
             + "' — no stretch applied. Re-run madmom_tagger.py.\n");
        return 1.0;
    }
    return db.bpm / GLOBAL_BPM;
}

// Apply a parameter change immediately — restart all running stems now
function applyNow() {
    if (!running) { post("EBYS: not running — send :buildIndex then :start\n"); return; }
    if (idx.length === 0) { post("EBYS: index empty — send :buildIndex then :start\n"); return; }
    for (var t = 0; t < TRACKS.length; t++) selectSegment(TRACKS[t]);
}

// ── GENRE FILTER ─────────────────────────────────────────────────────────────
// setGenreFilter Techno    — only play slices from tracks tagged with "Techno"
// setGenreFilter House     — case-insensitive substring match against genre strings
// clearGenreFilter         — remove filter, play from all tracks
// listGenres               — print available genres to Max console
function setGenreFilter() {
    var parts = [];
    for (var i = 0; i < arguments.length; i++) parts.push(String(arguments[i]));
    genreFilter = parts.join(" ").trim() || null;
    if (genreFilter) {
        post("EBYS Slicer: genre filter = '" + genreFilter + "'\n");
        outlet(1, "genreFilter", genreFilter);
    } else {
        post("EBYS Slicer: genre filter cleared\n");
        outlet(1, "genreFilter", "none");
    }
}

function clearGenreFilter() {
    genreFilter = null;
    post("EBYS Slicer: genre filter cleared\n");
    outlet(1, "genreFilter", "none");
}

function listGenres() {
    var seen = {};
    for (var trackName in trackGenres) {
        var gs = trackGenres[trackName];
        post("  " + trackName + ":\n");
        for (var gi = 0; gi < gs.length; gi++) {
            var g = gs[gi];
            if (!seen[g]) { seen[g] = 0; }
            seen[g]++;
            post("    " + (gi+1) + ". " + g + "\n");
        }
    }
    var allGenres = Object.keys(seen).sort();
    post("EBYS Slicer: unique genres — " + allGenres.join(", ") + "\n");
    outlet(1, "genres", allGenres.join(","));
}

// ── DESCRIPTOR DUMP ───────────────────────────────────────────────────────────
function dumpDescriptors(trackFilter) {
    var pool = (trackFilter && byTrack[trackFilter]) ? byTrack[trackFilter] : idx;
    for (var i = 0; i < pool.length; i++) {
        var s = pool[i];
        outlet(2, s.track, s.id, s.n,
               s.C.toFixed(2), s.P.toFixed(2),
               s.E.toFixed(2), s.F.toFixed(2),
               s.time.toFixed(2), s.dur.toFixed(2));
    }
    outlet(1, "dump_done", pool.length);
}

// ── RANGE QUERY ───────────────────────────────────────────────────────────────
function sliceMatchesGenre(s) {
    if (!genreFilter) return true;
    var gf = genreFilter.toLowerCase();
    var gs = s.genres || [];
    for (var gi = 0; gi < gs.length; gi++) {
        if (gs[gi].toLowerCase().indexOf(gf) !== -1) return true;
    }
    return false;
}

function sliceMatchesKey(s) {
    if (!keyFilter) return true;
    var kf = keyFilter.toLowerCase();
    var sk = (s.key || "").toLowerCase();
    return sk.indexOf(kf) !== -1;
}

// setKeyFilter Am   — only select slices from tracks in A minor
// setKeyFilter C    — match any key starting with C (C, C#, Cm, C#m …)
// setKeyFilter ""   — clear filter
function setKeyFilter() {
    var args = [];
    for (var i = 0; i < arguments.length; i++) args.push(String(arguments[i]));
    keyFilter = args.join(" ").trim() || null;
    if (keyFilter) {
        post("EBYS Slicer: key filter = '" + keyFilter + "'\n");
        outlet(1, "keyFilter", keyFilter);
    } else {
        post("EBYS Slicer: key filter cleared\n");
        outlet(1, "keyFilter", "none");
    }
}

function clearKeyFilter() {
    keyFilter = null;
    outlet(1, "keyFilter", "none");
}

function queryRange(trackFilter, Clo, Chi, Elo, Ehi, Flo, Fhi, Plo, Phi) {
    var pool = (trackFilter && byTrack[trackFilter]) ? byTrack[trackFilter] : idx;
    var result = [];
    for (var i = 0; i < pool.length; i++) {
        var s = pool[i];
        if (s.C < Clo || s.C > Chi) continue;
        if (s.E < Elo || s.E > Ehi) continue;
        if (s.F < Flo || s.F > Fhi) continue;
        if (s.P < Plo || s.P > Phi) continue;
        if (!sliceMatchesGenre(s)) continue;
        result.push(s);
    }
    return result;
}

function selectRange() {
    var args = [];
    for (var i = 0; i < arguments.length; i++) args.push(arguments[i]);
    var trackFilter = (typeof args[0] === "string") ? args.shift() : null;
    var Clo = (args[0] !== undefined) ? parseFloat(args[0]) : -Infinity;
    var Chi = (args[1] !== undefined) ? parseFloat(args[1]) :  Infinity;
    var Elo = (args[2] !== undefined) ? parseFloat(args[2]) : -Infinity;
    var Ehi = (args[3] !== undefined) ? parseFloat(args[3]) :  Infinity;
    var Flo = (args[4] !== undefined) ? parseFloat(args[4]) : -Infinity;
    var Fhi = (args[5] !== undefined) ? parseFloat(args[5]) :  Infinity;
    var Plo = (args[6] !== undefined) ? parseFloat(args[6]) : -Infinity;
    var Phi = (args[7] !== undefined) ? parseFloat(args[7]) :  Infinity;
    var pool = queryRange(trackFilter, Clo, Chi, Elo, Ehi, Flo, Fhi, Plo, Phi);
    outlet(3, pool.length);
    if (pool.length === 0) { outlet(1, "empty_range"); return; }
    var s = pool[Math.floor(Math.random() * pool.length)];
    lastSlice = s;
    outlet(0, s.track, s.time, s.dur, stretchRatioForSlice(s));
    outlet(1, "playing", s.track, s.id, s.E.toFixed(1), s.C.toFixed(0));
}

// ── TRACK WEIGHT ──────────────────────────────────────────────────────────────
// setMatchProb 0.8  — global transition tightness (0=loose, 1=strict)
//   Applies to all descriptors equally. Per-descriptor variant removed (redundant with setWeight).
function setMatchProb(val) {
    MATCH_PROB = clamp(parseFloat(val), 0.0, 1.0);
    post("EBYS Slicer: matchProb = " + MATCH_PROB + "\n");
    outlet(1, "matchProb", MATCH_PROB);
}

// setDirPref E 1   — prefer slices where energy is rising
// setDirPref E -1  — prefer slices where energy is falling
// setDirPref E 0   — neutral (default)
function setDirPref(dim, val) {
    if (DIR_PREF.hasOwnProperty(dim)) {
        DIR_PREF[dim] = clamp(parseFloat(val), -1.0, 1.0);
        post("EBYS Slicer: dirPref[" + dim + "] = " + DIR_PREF[dim] + "\n");
    }
}

// setDirWeight 1.5 — amplify/reduce overall direction bias (default 1.0)
function setDirWeight(val) {
    DIR_WEIGHT = clamp(parseFloat(val), 0.0, 5.0);
    post("EBYS Slicer: dirWeight = " + DIR_WEIGHT + "\n");
}

// ── ENTROPY MACRO ─────────────────────────────────────────────────────────────
// setEntropy <0–1>  — ORDER (0) to CHAOS (1)
//   Single fader that simultaneously drives:
//     MATCH_PROB  : 1→0   (order=strict matching, chaos=loose)
//     STAY_PROB   : 0.8→0 (order=tends to stay on track, chaos=always jumps)
//     DIR_WEIGHT  : 0→3.0 (order=no direction forcing, chaos=strong direction)
//
//   Curves are intentionally non-linear:
//     matchProb uses (1-e)^2  so looseness accelerates toward the chaos end
//     stayProb  uses (1-e)*0.8
//     dirWeight uses e*3.0
//
function setEntropy(val) {
    var e = clamp(parseFloat(val), 0.0, 1.0);
    // Compute each sub-parameter
    var mp = Math.pow(1 - e, 2);       // 1.0 → 0.0, curved
    var sp = (1 - e) * 0.8;            // 0.8 → 0.0
    var dw = e * 3.0;                  // 0.0 → 3.0

    MATCH_PROB = mp;
    DIR_WEIGHT = dw;

    // Apply stayProb to all tracks
    for (var i = 0; i < TRACKS.length; i++) {
        STAY_PROB[TRACKS[i]] = sp;
    }

    post("EBYS Slicer: entropy=" + e.toFixed(2)
         + " → matchProb=" + mp.toFixed(3)
         + " stayProb=" + sp.toFixed(3)
         + " dirWeight=" + dw.toFixed(3) + "\n");

    outlet(1, "entropy", e, mp, sp, dw);
}

function setTrackWeight(track, w) {
    if (trackWeights.hasOwnProperty(track)) {
        trackWeights[track] = clamp(parseFloat(w), 0.0, 1.0);
        post("EBYS Slicer: weight[" + track + "] = " + trackWeights[track] + "\n");
    }
}

// ── FOLLOW STEM COMMAND ───────────────────────────────────────────────────────
// followStem vocals melody 0.8 bass 0.2
//   → vocals reads a weighted blend of melody (80%) and bass (20%) end descriptors
// followStem vocals self
//   → reset vocals to read its own descriptors (default)
// Weights are normalised to sum to 1.0.
function followStem(track) {
    if (!FOLLOW_STEM.hasOwnProperty(track)) {
        post("EBYS Slicer: followStem — unknown stem '" + track + "'\n");
        return;
    }
    // arguments[0] = track, then pairs of (stem, weight)
    if (arguments.length < 2 || String(arguments[1]) === "self") {
        FOLLOW_STEM[track] = null;
        post("EBYS Slicer: followStem[" + track + "] = self\n");
        return;
    }
    var pairs = [];
    var totalWeight = 0;
    for (var i = 1; i < arguments.length - 1; i += 2) {
        var s = String(arguments[i]);
        var w = parseFloat(arguments[i + 1]);
        if (!FOLLOW_STEM.hasOwnProperty(s)) {
            post("EBYS Slicer: followStem — unknown target stem '" + s + "'\n");
            return;
        }
        if (isNaN(w) || w < 0) {
            post("EBYS Slicer: followStem — invalid weight '" + arguments[i + 1] + "'\n");
            return;
        }
        pairs.push({ stem: s, weight: w });
        totalWeight += w;
    }
    if (pairs.length === 0) { post("EBYS Slicer: followStem — no valid pairs\n"); return; }
    // Normalise weights to sum to 1.0
    if (totalWeight > 0) {
        for (var j = 0; j < pairs.length; j++) pairs[j].weight /= totalWeight;
    }
    FOLLOW_STEM[track] = pairs;
    var msg = "EBYS Slicer: followStem[" + track + "] =";
    for (var j = 0; j < pairs.length; j++) msg += " " + pairs[j].stem + "×" + pairs[j].weight.toFixed(2);
    post(msg + "\n");
}

// ── INSPECTOR ─────────────────────────────────────────────────────────────────
function info() {
    post("── EBYS Slicer v2 ──\n");
    post("  segmentBars : vocals=" + SEGMENT_BARS.vocals + " melody=" + SEGMENT_BARS.melody + " bass=" + SEGMENT_BARS.bass + " drums=" + SEGMENT_BARS.drums + "\n");
    post("  quantize    : " + QUANTIZE_BARS + "\n");
    post("  stayProb    : vocals=" + STAY_PROB.vocals + " melody=" + STAY_PROB.melody + " bass=" + STAY_PROB.bass + " drums=" + STAY_PROB.drums + "\n");
    post("  fallbackBPM : " + FALLBACK_BPM + "\n");
    post("  globalBPM   : " + (GLOBAL_BPM > 0 ? GLOBAL_BPM + " (OVERRIDE ACTIVE)" : "off") + "\n");
    var dbKeys = Object.keys(trackDownbeats);
    if (dbKeys.length > 0) {
        for (var di = 0; di < dbKeys.length; di++) {
            var db = trackDownbeats[dbKeys[di]];
            post("  downbeats   : track='" + dbKeys[di] + "'  meter=" + db.meter + "  bpm=" + db.bpm
                 + "  avgBarMs=" + db.avgBarMs
                 + "  n=" + (db.downbeats_ms ? db.downbeats_ms.length : 0)
                 + "  conf=" + db.confidence
                 + (db.confidence < DOWNBEAT_MIN_CONF ? " (BELOW THRESHOLD → BPM grid)" : "") + "\n");
        }
    } else {
        post("  downbeats   : none (run allin1_tagger.py then send reloadDownbeats)\n");
    }
    post("  matchProb   : " + MATCH_PROB + " (global)\n");
    var followStr = "";
    for (var t = 0; t < TRACKS.length; t++) {
        var f = FOLLOW_STEM[TRACKS[t]];
        if (f) {
            var parts = [];
            for (var j = 0; j < f.length; j++) parts.push(f[j].stem + "×" + f[j].weight.toFixed(2));
            followStr += TRACKS[t] + "→[" + parts.join(", ") + "] ";
        }
    }
    post("  followStem  : " + (followStr || "all self") + "\n");
    post("  dirPref     : C=" + DIR_PREF.C + " E=" + DIR_PREF.E
                       + " F=" + DIR_PREF.F + " P=" + DIR_PREF.P
                       + " weight=" + DIR_WEIGHT + "\n");
    post("  total slices: " + idx.length + "\n");
    for (var t = 0; t < TRACKS.length; t++) {
        var track = TRACKS[t];
        var arr   = byTrack[track] || [];
        var r     = ranges[track]  || {};
        var firstSrc = arr.length > 0 ? arr[0].sourceTrack : null;
        var bpm   = effectiveBPMForSource(firstSrc);
        var barMs = getBarMs(track, bpm, firstSrc);
        post("  " + track + ": " + arr.length + " slices"
             + "  BPM=" + bpm.toFixed(1)
             + "  key=" + (meta[track] ? meta[track].key : "?") + "\n");
        if (r.E) {
            post("    seg≈" + (barMs * SEGMENT_BARS).toFixed(0) + "ms"
                 + "  (" + SEGMENT_BARS + " bars)"
                 + "  E=[" + r.E.min.toFixed(1) + "," + r.E.max.toFixed(1) + "]\n");
        }
    }
    post("  running  : " + running + "\n");
    post("  lastSlice: " + (lastSlice
         ? lastSlice.track + " @" + lastSlice.time.toFixed(0) + "ms"
         : "none") + "\n");
}

// ── UMAP — per-stem 2D embedding via fluid.umap~ ─────────────────────────────
//
// After buildIndex() the descriptor data lives in slicer.js memory (byTrack).
// We push it into fluid.dataset~ ebys.descriptors, run fluid.umap~, then
// collect the 2D output from fluid.dataset~ ebys.umap into umap_coords.json.
//
// Max patch wiring required (do this once in ebys-analyze.maxpat):
//   1. Rename objects:
//        fluid.dataset~ ebys.descriptors
//        fluid.dataset~ ebys.umap
//        fluid.umap~ @components 2 @mindist 0.1 @numneighbours 15
//   2. Wire:
//        [js slicer.js] outlet 4  →  [fluid.dataset~ ebys.descriptors]
//        [js slicer.js] outlet 4  →  [fluid.umap~]
//        [fluid.umap~] outlet 0   →  [prepend dump]  →  [fluid.dataset~ ebys.umap]
//        [fluid.dataset~ ebys.umap] outlet 0  →  [js slicer.js] inlet 1
//
// Outlets:
//   outlet 4 → fluid.dataset~ ebys.descriptors   (read, clear)
//   outlet 5 → fluid.umap~                        (fitTransform)
// Do NOT wire outlet 4 to fluid.umap~ — they must be on separate outlets.

var umapBuffer      = [];   // collects [id, x, y] during dump for current stem
var umapCurrentStem = null;
var umapStemQueue   = [];   // stems still waiting to be processed
var umapResults     = {};   // { vocals: { slice_0001: [x,y], ... }, ... }
var UMAP_FILE       = "umap_coords.json";
var MIN_UMAP_SLICES = 5;    // fluid.umap~ needs at least a few points

function feedUMAP() {
    // t-SNE is now computed in ws_server.js (Node) immediately after buildIndex.
    // No fluid.umap~ wiring needed — umapDone will broadcast when umap_coords.json is ready.
    post("EBYS UMAP: delegated to ws_server.js (Node t-SNE) — no fluid objects needed\n");
}

function feedNextUmapStem() {
    if (umapStemQueue.length === 0) {
        writeUmapCoords();
        return;
    }
    umapCurrentStem = umapStemQueue.shift();
    umapBuffer      = [];
    var arr = byTrack[umapCurrentStem];
    post("EBYS UMAP [" + umapCurrentStem + "]: writing " + arr.length + " slices…\n");

    // Write descriptor data in FluCoMa dataset JSON format so fluid.dataset~ can
    // load it with "read".  This avoids addpoint (which needs a buffer~ per point).
    // Format: {"version":1,"cols":6,"data":{"slice_0001":[C,E,F,P,H,T], ...}}
    var fname = "ebys_feed_" + umapCurrentStem + ".json";
    var f = new File(fname, "write");
    f.open();
    f.writestring('{"version":1,"cols":6,"data":{');
    for (var i = 0; i < arr.length; i++) {
        var s = arr[i];
        if (i > 0) f.writestring(",");
        f.writestring('"' + s.id + '":[' +
            s.C.toFixed(6) + "," + s.E.toFixed(6) + "," +
            s.F.toFixed(6) + "," + s.P.toFixed(6) + "," +
            s.H.toFixed(6) + "," + s.T.toFixed(6) + "]");
    }
    f.writestring("}}");
    f.close();

    // Tell fluid.dataset~ ebys.descriptors to load this file (outlet 4).
    // fluid.dataset~ read is asynchronous; wait 2 s before triggering fit.
    // (If [js slicer.js] inlet 2 is wired to fluid.dataset~ ebys.descriptors outlet 0,
    //  the bang() inlet-2 handler fires fit immediately and the timer becomes a no-op.)
    outlet(4, "read", fname);

    var t = new Task(function() {
        if (!umapCurrentStem) return;          // inlet-2 bang already fired fit — skip
        post("EBYS UMAP [" + umapCurrentStem + "]: fit ebys.descriptors → ebys.umap (timer)…\n");
        outlet(5, "fit", "ebys.descriptors", "ebys.umap");
    });
    t.schedule(2000);
}

// Receive dump stream from fluid.dataset~ ebys.umap via inlet 1.
// Each point arrives as:  messagename = slice_id,  arguments = [x, y]
function anything() {
    if (inlet !== 1) return;
    var id = String(messagename);
    var x  = parseFloat(arguments[0]);
    var y  = parseFloat(arguments[1]);
    if (id && !isNaN(x) && !isNaN(y)) {
        umapBuffer.push([id, x, y]);
    }
}

// Bang on inlet 2 = fluid.dataset~ ebys.descriptors finished reading — now safe to fit.
// Bang on inlet 1 = fluid.dataset~ ebys.umap dump is complete for this stem.
function bang() {
    if (inlet === 2) {
        // Descriptors dataset finished loading — trigger fit immediately (beats the 2 s timer).
        if (!umapCurrentStem) return;
        var stem = umapCurrentStem;
        umapCurrentStem = null;   // signal timer that fit was already sent
        post("EBYS UMAP [" + stem + "]: fit ebys.descriptors → ebys.umap (bang)…\n");
        outlet(5, "fit", "ebys.descriptors", "ebys.umap");
        umapCurrentStem = stem;   // restore so bang() inlet-1 can still collect results
        return;
    }
    if (inlet !== 1) return;
    if (umapCurrentStem) {
        var coords = {};
        for (var i = 0; i < umapBuffer.length; i++) {
            coords[umapBuffer[i][0]] = [umapBuffer[i][1], umapBuffer[i][2]];
        }
        umapResults[umapCurrentStem] = coords;
        post("EBYS UMAP [" + umapCurrentStem + "]: " + umapBuffer.length + " 2D coords collected\n");
    }
    feedNextUmapStem();  // move on to next stem (or finish)
}

function writeUmapCoords() {
    try {
        var f = new File(UMAP_FILE, "write", "TEXT");
        f.open();
        f.writestring(JSON.stringify(umapResults));
        f.close();
        post("EBYS UMAP: coords written to " + UMAP_FILE + "\n");
        outlet(1, "umapDone");   // notifies ws_server → TUI to reload
    } catch (e) {
        post("EBYS UMAP: write failed — " + e + "\n");
    }
}

// ── RESET ─────────────────────────────────────────────────────────────────────
function reset() {
    running    = false;
    idx        = [];
    byTrack    = {};
    meta       = {};
    ranges     = {};
    lastSlice       = null;
    lastIdx         = { vocals: 0,    melody: 0,    bass: 0,    drums: 0    };
    lastEndFrac     = { vocals: -1,   melody: -1,   bass: -1,   drums: -1   };
    lastSourceTrack = { vocals: null, melody: null, bass: null, drums: null };
    FOLLOW_STEM = { vocals: null, melody: null, bass: null, drums: null };
    outlet(1, "reset");
    post("EBYS Slicer: reset\n");
}
