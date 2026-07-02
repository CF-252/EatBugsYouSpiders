// EBYS — Stretch Player  v1
//
// Central sequencer for the bufselect → bufstretch → play chain.
// Handles all 4 stems, keeps per-stem state during async processing.
//
// ── Inlets ────────────────────────────────────────────────────────────────────
//   0  route <stem> startFrac endFrac stretchRatio   — initiate stretch+play
//      (prepend vocals/melody/bass/drums routes here from Max route object)
//   1  done_select <stem>   — fluid.bufselect~ done bang (prepend done_select stem)
//   2  done_stretch <stem>  — fluid.bufstretch~ done bang (prepend done_stretch stem)
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0  vocals  → fluid.bufselect~    (@startframe, @numframes, bang)
//   1  melody  → fluid.bufselect~
//   2  bass    → fluid.bufselect~
//   3  drums   → fluid.bufselect~
//   4  vocals  → fluid.bufstretch~   (@timeratio, bang)
//   5  melody  → fluid.bufstretch~
//   6  bass    → fluid.bufstretch~
//   7  drums   → fluid.bufstretch~
//   8  vocals  → play~ vocals_stretched  (start 0.)
//   9  melody  → play~ melody_stretched
//   10 bass    → play~ bass_stretched
//   11 drums   → play~ drums_stretched

autowatch = 1;
inlets    = 3;
outlets   = 12;

// play_* = playback buffers (loaded by track_loader.js).
// stem_* = analysis buffers (loaded by analyze_reader.js) — do NOT reference those here.
// play_N_* = per-slot playback buffers (slot 0 = first alphabetical track).
// stretch_player reads from slot 0 by default; extend for multi-slot stretch later.
var STEM_CFG = {
    vocals: { src: 'ring_0_voc', idx: 0 },
    melody: { src: 'ring_0_mel', idx: 1 },
    bass:   { src: 'ring_0_bss', idx: 2 },
    drums:  { src: 'ring_0_drm', idx: 3 },
};

// Per-stem pending state while async processing runs
var pending = {};

// ── Command routing ───────────────────────────────────────────────────────────
// Max routes messages by first word.  Each function name = stem name.

function vocals(startFrac, endFrac, stretchRatio) { play('vocals', startFrac, endFrac, stretchRatio); }
function melody(startFrac, endFrac, stretchRatio) { play('melody', startFrac, endFrac, stretchRatio); }
function bass(startFrac, endFrac, stretchRatio)   { play('bass',   startFrac, endFrac, stretchRatio); }
function drums(startFrac, endFrac, stretchRatio)  { play('drums',  startFrac, endFrac, stretchRatio); }

// ── Inlet 0: start a stretch-play for a stem ─────────────────────────────────
function play(stem, startFrac, endFrac, stretchRatio) {
    var cfg = STEM_CFG[stem];
    if (!cfg) { post('stretch_player: unknown stem "' + stem + '"\n'); return; }

    var srcBuf     = new Buffer(cfg.src);
    var totalFrames = srcBuf.framecount();
    if (totalFrames <= 0) {
        post('stretch_player: ' + cfg.src + ' has no frames — is it loaded?\n');
        return;
    }

    var startFrame = Math.round(parseFloat(startFrac)  * totalFrames);
    var numFrames  = Math.round((parseFloat(endFrac) - parseFloat(startFrac)) * totalFrames);
    if (numFrames <= 0) { post('stretch_player: zero-length slice for ' + stem + '\n'); return; }

    stretchRatio = parseFloat(stretchRatio) || 1.0;
    pending[stem] = { stretchRatio: stretchRatio };

    // Configure and trigger fluid.bufselect~
    // Messages arrive in order; outlet N → fluid.bufselect~ for this stem
    outlet(cfg.idx, '@startframe', startFrame);
    outlet(cfg.idx, '@numframes',  numFrames);
    outlet(cfg.idx, 'bang');

    post('stretch_player [' + stem + ']: select ' + startFrame + ' + ' + numFrames
         + ' frames  ratio=' + stretchRatio.toFixed(3) + '\n');
}

// ── Inlet 1: bufselect~ done → trigger bufstretch~ ───────────────────────────
function done_select(stem) {
    var cfg = STEM_CFG[stem];
    var p   = pending[stem];
    if (!cfg || !p) { post('stretch_player: done_select for unknown/idle stem "' + stem + '"\n'); return; }

    outlet(cfg.idx + 4, '@timeratio', p.stretchRatio);
    outlet(cfg.idx + 4, '@pitchratio', 1.0);   // pitch-preserving
    outlet(cfg.idx + 4, 'bang');
}

// ── Inlet 2: bufstretch~ done → trigger play~ ────────────────────────────────
function done_stretch(stem) {
    var cfg = STEM_CFG[stem];
    if (!cfg) return;

    // 'start 0.' plays the stretched buffer from the very beginning
    outlet(cfg.idx + 8, 'start', 0.0);

    if (pending[stem]) delete pending[stem];
}

// ── Inlet 1/2 dispatch ───────────────────────────────────────────────────────
// Max routes inlet messages by function name.  done_select / done_stretch
// are called with the stem name as their first argument when
// [prepend done_select vocals] etc. are connected to inlets 1 and 2.
