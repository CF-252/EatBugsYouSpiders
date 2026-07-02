// EBYS — Buffer Manager  v2
//
// Two-level ring buffer architecture for scalable multi-source-track playback.
//
// ── LEVEL 1: Source buffers (src_N_stem) ─────────────────────────────────────
//   2 per stem × 4 stems = 8 buffer~ objects (src_0/1_voc/drm/bss/mel).
//   src.active  = slot currently used for composition (don't overwrite)
//   src.staging = slot available for loading the next source track
//
// ── LEVEL 2: Ring buffers (ring_N_stem) ──────────────────────────────────────
//   2 per stem × 4 stems = 8 small pre-allocated buffer~ objects.
//   fluid.bufcompose~ copies the exact segment from src → ring.staging (~1ms).
//   After compose: ring.active ↔ ring.staging swap; karma~ plays ring.active.
//
// ── Inlet 0 messages ─────────────────────────────────────────────────────────
//   vocals    sourceSlot  startFrac  endFrac  stretchRatio  segDurMs  → play
//   melody    sourceSlot  ...
//   bass      sourceSlot  ...
//   drums     sourceSlot  ...
//   preload   stem  sourceSlot    → speculative disk preload
//   sourceTrack  slotIdx  ...nameParts  → register slot → track name mapping
//   src_done  stemShort  srcSlot   → src buffer~ finished loading from disk
//   ring_done stemShort            → fluid.bufcompose~ finished copy
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0  → buffer~ src_0_voc   "read <path>"
//   1  → buffer~ src_1_voc   "read <path>"
//   2  → buffer~ src_0_drm   "read <path>"
//   3  → buffer~ src_1_drm   "read <path>"
//   4  → buffer~ src_0_bss   "read <path>"
//   5  → buffer~ src_1_bss   "read <path>"
//   6  → buffer~ src_0_mel   "read <path>"
//   7  → buffer~ src_1_mel   "read <path>"
//   8  → fluid.bufcompose~ voc  (source/startframe/numframes/destination/deststartframe/bang)
//   9  → fluid.bufcompose~ drm
//  10  → fluid.bufcompose~ bss
//  11  → fluid.bufcompose~ mel
//  12  → slot_router inlet 0  "vocals ringSlot segDurMs stretchRatio"
//  13  → status / print
//  14  → fluid.bufcompose~ bake voc  (shared — used for both ring→snap and snap→ring)
//  15  → fluid.bufcompose~ bake drm
//  16  → fluid.bufcompose~ bake bss
//  17  → fluid.bufcompose~ bake mel

autowatch = 1;
inlets    = 1;
outlets   = 18;

// ── Configuration ────────────────────────────────────────────────────────────
// Path computed relative to patch — works on any machine.
function getDataDir() {
    var p = patcher.filepath;
    var slash = p.indexOf('/');
    if (slash > 0) p = p.slice(slash);
    p = p.replace(/[^\/]+$/, '');    // strip filename  → .../src/max/
    p = p.replace(/[^\/]+\/$/, ''); // strip max/      → .../src/
    p = p.replace(/[^\/]+\/$/, ''); // strip src/      → .../EBYS/
    return p + 'data/';
}
var HT_PATH  = getDataDir() + "stems/htdemucs";
var SUFFIXES = { voc: "_vocals.wav", drm: "_drums.wav", bss: "_bass.wav", mel: "_other.wav" };
var SHORT    = { vocals: "voc", melody: "mel", bass: "bss", drums: "drm" };
var FULL     = { voc: "vocals", mel: "melody", bss: "bass", drm: "drums" };
var STEMS    = ["voc", "drm", "bss", "mel"];

// Outlets to each src buffer pair per stem
var SRC_OUTLETS  = { voc: [0, 1], drm: [2, 3], bss: [4, 5], mel: [6, 7] };
// Outlet to each fluid.bufcompose~ per stem
var COMP_OUTLET  = { voc: 8, drm: 9, bss: 10, mel: 11 };

// ── Slot → track name map ─────────────────────────────────────────────────────
var slotToTrack = {};

// ── Per-stem state ────────────────────────────────────────────────────────────
function makeSrc() {
    return {
        active:   0,
        staging:  1,
        contents: [-1, -1],
        loading:  false,
        pendingCompose: null
    };
}
function makeRing() {
    return { active: 0, staging: 1 };
}

var src          = { voc: makeSrc(),  mel: makeSrc(),  bss: makeSrc(),  drm: makeSrc()  };
var ring         = { voc: makeRing(), mel: makeRing(), bss: makeRing(), drm: makeRing() };
var composePend  = { voc: null,       mel: null,       bss: null,       drm: null       };

// ── Playback gate ─────────────────────────────────────────────────────────────
// Set to false by stop() so in-flight bufcompose~ copies don't trigger karma~.
// Cleared back to true by any incoming play command.
var playing = false;

// ── Last-routed play params ───────────────────────────────────────────────────
// Updated every time ring_done fires a play command to slot_router.
// Used by bakeRestore so it can re-trigger karma~ with the same timing after restore.
var lastRouted = { voc: null, mel: null, bss: null, drm: null };

// ── Bake snapshot state ───────────────────────────────────────────────────────
// Saves which ring slot was active at :bake start so restore knows where to put it back.
var bakeActiveSlot    = { voc: 0, mel: 0, bss: 0, drm: 0 };
// Saves the play params (ringSlot, segDurMs, stretchRatio) captured at bakeSnapshot time.
// Replayed to slot_router once all bake_done confirms arrive.
var bakeSnapshotPlay  = { voc: null, mel: null, bss: null, drm: null };

// Tracks which stems are mid-restore (waiting for bufcompose~ done-bang).
// ring state is NOT updated until the copy confirms.
var bakeRestorePending = { voc: false, mel: false, bss: false, drm: false };
var bakeRestoringSlot  = { voc: 0, mel: 0, bss: 0, drm: 0 };

// Shared bake bufcompose~ outlets (used for both directions)
var BAKE_OUTLET = { voc: 14, drm: 15, bss: 16, mel: 17 };

// ── Core helpers ──────────────────────────────────────────────────────────────

function findSrc(sh, sourceSlot) {
    var s = src[sh];
    if (s.contents[0] === sourceSlot) return 0;
    if (s.contents[1] === sourceSlot) return 1;
    return -1;
}

function loadSrc(sh, sourceSlot) {
    var trackName = slotToTrack[sourceSlot];
    if (!trackName) {
        post("buffer_manager: no name for sourceSlot " + sourceSlot + " — send buildIndex first\n");
        return false;
    }
    var s = src[sh];
    var path = HT_PATH + "/" + trackName + "/" + trackName + SUFFIXES[sh];
    s.contents[s.staging] = sourceSlot;
    s.loading = true;
    outlet(SRC_OUTLETS[sh][s.staging], "read", path);
    post("buffer_manager [" + sh + "]: loading slot " + sourceSlot
         + " (" + trackName + ") → src_" + s.staging + "_" + sh + "\n");
    return true;
}

function triggerCompose(sh, srcSlot, startFrac, endFrac, stretchRatio, segDurMs) {
    var srcBuf  = new Buffer("src_" + srcSlot + "_" + sh);
    var total   = srcBuf.framecount();
    if (total <= 0) {
        post("buffer_manager [" + sh + "]: src_" + srcSlot + "_" + sh + " is empty\n");
        return;
    }

    var startFrame = Math.round(parseFloat(startFrac) * total);
    var numFrames  = Math.round((parseFloat(endFrac) - parseFloat(startFrac)) * total);
    if (numFrames <= 0) {
        post("buffer_manager [" + sh + "]: zero-length segment, skipping\n");
        return;
    }

    var dstBuf = "ring_" + ring[sh].staging + "_" + sh;
    composePend[sh] = {
        srcSlot:      srcSlot,
        segDurMs:     parseFloat(segDurMs) || 1000,
        stretchRatio: parseFloat(stretchRatio) || 1.0
    };

    var co = COMP_OUTLET[sh];
    outlet(co, "source",          "src_" + srcSlot + "_" + sh);
    outlet(co, "startframe",      startFrame);
    outlet(co, "numframes",       numFrames);
    outlet(co, "destination",     dstBuf);
    outlet(co, "deststartframe",  0);
    outlet(co, "bang");

    post("buffer_manager [" + sh + "]: compose src_" + srcSlot + "_" + sh
         + "[" + startFrame + "+" + numFrames + "] → " + dstBuf + "\n");
}

// ── Play handler ──────────────────────────────────────────────────────────────
function handlePlay(sh, sourceSlot, startFrac, endFrac, stretchRatio, segDurMs) {
    playing = true;   // re-arm gate; any incoming play command restarts playback
    var s = src[sh];
    var found = findSrc(sh, sourceSlot);

    if (found !== -1) {
        // Track already loaded in one of our two src buffers — compose immediately.
        triggerCompose(sh, found, startFrac, endFrac, stretchRatio, segDurMs);
        return;
    }

    // Track not loaded yet — save what we want to play.
    s.pendingCompose = { sourceSlot: sourceSlot, startFrac: startFrac,
                         endFrac: endFrac, stretchRatio: stretchRatio, segDurMs: segDurMs };

    if (s.loading) {
        // A load is already in progress.
        if (s.contents[s.staging] === sourceSlot) {
            // It's loading exactly what we need — wait for src_done.
            post("buffer_manager [" + sh + "]: queuing after active load (slot " + sourceSlot + ")\n");
        } else {
            // Loading the WRONG track. Don't interrupt — wait for src_done, which will
            // see that pendingCompose.sourceSlot doesn't match and re-route to loadSrc.
            // (Calling loadSrc here would corrupt the in-flight read by overwriting
            //  s.contents[staging] before the buffer data arrives.)
            post("buffer_manager [" + sh + "]: load in progress for slot " + s.contents[s.staging]
                 + ", need slot " + sourceSlot + " — will re-route after load completes\n");
        }
    } else {
        // Nothing loading — start now.
        if (!loadSrc(sh, sourceSlot)) {
            post("buffer_manager [" + sh + "]: cannot load slot " + sourceSlot + "\n");
        }
    }
}

// ── Preload handler ───────────────────────────────────────────────────────────
function handlePreload(sh, sourceSlot) {
    var s = src[sh];
    if (findSrc(sh, sourceSlot) !== -1) return;
    if (s.loading) return;
    loadSrc(sh, sourceSlot);
}

// ── Message dispatchers ───────────────────────────────────────────────────────

function vocals(sourceSlot, startFrac, endFrac, stretchRatio, segDurMs) {
    handlePlay("voc", parseInt(sourceSlot), parseFloat(startFrac),
               parseFloat(endFrac), parseFloat(stretchRatio), parseFloat(segDurMs));
}
function melody(sourceSlot, startFrac, endFrac, stretchRatio, segDurMs) {
    handlePlay("mel", parseInt(sourceSlot), parseFloat(startFrac),
               parseFloat(endFrac), parseFloat(stretchRatio), parseFloat(segDurMs));
}
function bass(sourceSlot, startFrac, endFrac, stretchRatio, segDurMs) {
    handlePlay("bss", parseInt(sourceSlot), parseFloat(startFrac),
               parseFloat(endFrac), parseFloat(stretchRatio), parseFloat(segDurMs));
}
function drums(sourceSlot, startFrac, endFrac, stretchRatio, segDurMs) {
    handlePlay("drm", parseInt(sourceSlot), parseFloat(startFrac),
               parseFloat(endFrac), parseFloat(stretchRatio), parseFloat(segDurMs));
}

function preload(stem, sourceSlot) {
    var sh = SHORT[String(stem)];
    if (sh) handlePreload(sh, parseInt(sourceSlot));
}

// ── Stop ──────────────────────────────────────────────────────────────────────
// Called when the TUI sends :stop.  Clears the playback gate so any
// fluid.bufcompose~ copies that complete after this point are discarded
// instead of re-triggering karma~ via outlet 12.
// Also forwards "stop" to slot_router (via outlet 12) so it can send
// the karma~ "stop" message to all four stems.
function stop() {
    playing = false;
    outlet(12, "stop");   // → slot_router stop() → karma~ "stop" all stems
    post("buffer_manager: stopped (playback gate closed)\n");
}

function sourceTrack() {
    var args = arrayfromargs(arguments);
    if (args.length < 1) return;
    var slotIdx = parseInt(args[0]);
    var name = [];
    for (var i = 1; i < args.length; i++) name.push(String(args[i]));
    slotToTrack[slotIdx] = name.join(" ");
    post("buffer_manager: slot " + slotIdx + " = '" + slotToTrack[slotIdx] + "'\n");
    outlet(13, "registered", slotIdx, slotToTrack[slotIdx]);
}

// Called when a src buffer~ done-bang fires
function src_done(stemShort, srcSlot) {
    var sh = String(stemShort);
    srcSlot = parseInt(srcSlot);
    var s = src[sh];

    if (srcSlot !== s.staging) {
        post("buffer_manager [" + sh + "]: src_done for unexpected slot " + srcSlot + "\n");
        return;
    }

    s.loading = false;
    post("buffer_manager [" + sh + "]: src_" + srcSlot + "_" + sh + " ready (track slot "
         + s.contents[srcSlot] + ")\n");

    // Swap active ↔ staging: the just-loaded buffer becomes active, the old one is free.
    var tmp = s.active; s.active = s.staging; s.staging = tmp;

    var pc = s.pendingCompose;
    if (!pc) return;  // preload only — nothing to play

    // Check if the track we need is now available in either buffer.
    var foundNow = findSrc(sh, pc.sourceSlot);
    if (foundNow !== -1) {
        // Found — compose immediately.
        s.pendingCompose = null;
        triggerCompose(sh, foundNow, pc.startFrac, pc.endFrac, pc.stretchRatio, pc.segDurMs);
    } else {
        // The load that just finished was for a DIFFERENT track (arrived while we were
        // waiting for a different slot).  Start loading what we actually need now.
        post("buffer_manager [" + sh + "]: wrong track loaded — re-routing to slot " + pc.sourceSlot + "\n");
        loadSrc(sh, pc.sourceSlot);
        // pendingCompose stays set — will resolve on the next src_done.
    }
}

// Called when fluid.bufcompose~ done-bang fires
function ring_done(stemShort) {
    var sh = String(stemShort);

    // GUARD: check composePend BEFORE swapping ring state.
    // fluid.bufcompose~ can fire a spurious done-bang at patch init or if two bangs
    // race.  If we swap ring.active ↔ ring.staging when composePend is null, the
    // NEXT compose writes into the buffer karma~ is currently playing; bufcompose~
    // may then fail silently (no done-bang) → permanent silence.
    var cp = composePend[sh];
    if (!cp) {
        post("buffer_manager [" + sh + "]: ring_done with no pending compose — ignoring\n");
        return;
    }

    var r  = ring[sh];
    var tmp = r.active; r.active = r.staging; r.staging = tmp;

    src[sh].active  = cp.srcSlot;
    src[sh].staging = 1 - cp.srcSlot;
    composePend[sh] = null;

    // Gate: if stop() was called while this bufcompose~ was in-flight, discard.
    if (!playing) { return; }

    // Save for bakeRestore replay, then pass to slot_router.
    lastRouted[sh] = { ringSlot: r.active, segDurMs: cp.segDurMs, stretchRatio: cp.stretchRatio };
    outlet(12, FULL[sh], r.active, cp.segDurMs, cp.stretchRatio);
    post("buffer_manager [" + sh + "]: play ring_" + r.active + "_" + sh
         + "  " + Math.round(cp.segDurMs) + "ms"
         + "  stretch=" + cp.stretchRatio.toFixed(3) + "\n");
}

// ── Bake snapshot / restore ───────────────────────────────────────────────────

function bakeCopy(srcName, dstName, sh) {
    var srcBuf  = new Buffer(srcName);
    var nFrames = srcBuf.framecount();
    if (nFrames <= 0) {
        post("buffer_manager bake [" + sh + "]: " + srcName + " is empty — skipping\n");
        return;
    }
    var o = BAKE_OUTLET[sh];
    outlet(o, "source",         srcName);
    outlet(o, "startframe",     0);
    outlet(o, "numframes",      nFrames);
    outlet(o, "destination",    dstName);
    outlet(o, "deststartframe", 0);
    outlet(o, "bang");
}

function bakeSnapshot() {
    STEMS.forEach(function(sh) {
        var activeSlot        = ring[sh].active;
        bakeActiveSlot[sh]    = activeSlot;
        // Freeze the play params at this moment so bakeRestore can replay them.
        bakeSnapshotPlay[sh]  = lastRouted[sh]
            ? { ringSlot: activeSlot, segDurMs: lastRouted[sh].segDurMs, stretchRatio: lastRouted[sh].stretchRatio }
            : null;
        // Snapshot copy doesn't need completion tracking — it doesn't affect ring state.
        bakeCopy("ring_" + activeSlot + "_" + sh, "snap_" + sh, sh);
        post("buffer_manager bakeSnapshot [" + sh + "]: ring_" + activeSlot + "_" + sh
             + " → snap_" + sh
             + (bakeSnapshotPlay[sh] ? "  dur=" + Math.round(bakeSnapshotPlay[sh].segDurMs) + "ms" : "  (no play params yet)")
             + "\n");
    });
    post("buffer_manager: bakeSnapshot fired for all stems\n");
}

function bakeRestore() {
    // Kick off async copies for all 4 stems.
    // ring[sh].active is NOT updated here — it moves in bake_done() once the copy confirms.
    STEMS.forEach(function(sh) {
        var savedSlot          = bakeActiveSlot[sh];
        bakeRestorePending[sh] = true;
        bakeRestoringSlot[sh]  = savedSlot;
        bakeCopy("snap_" + sh, "ring_" + savedSlot + "_" + sh, sh);
        post("buffer_manager bakeRestore [" + sh + "]: snap_" + sh
             + " → ring_" + savedSlot + "_" + sh + "  (pending…)\n");
    });
}

// Called when a bake fluid.bufcompose~ done-bang fires.
// Message from patch: "bake_done voc" / "bake_done drm" / "bake_done bss" / "bake_done mel"
// (wired via: bufcompose~ outlet 0 → prepend bake_done <stem> → buffer_manager inlet 0)
function bake_done(stemShort) {
    var sh = String(stemShort);
    if (!bakeRestorePending[sh]) {
        // This was a snapshot copy completing, not a restore — nothing to do.
        return;
    }
    bakeRestorePending[sh] = false;
    var savedSlot = bakeRestoringSlot[sh];

    // Now safe to flip ring state — the copy is confirmed complete.
    ring[sh].active  = savedSlot;
    ring[sh].staging = 1 - savedSlot;
    post("buffer_manager bake_done [" + sh + "]: restore confirmed"
         + " — ring.active = " + savedSlot + "\n");

    // Check if all 4 stems have confirmed.
    var allDone = STEMS.every(function(s) { return !bakeRestorePending[s]; });
    if (allDone) {
        post("buffer_manager: bakeRestore COMPLETE — all stems restored\n");

        // Re-trigger slot_router with the snapshot play params so karma~ plays
        // the restored ring buffer immediately (not waiting for next segment).
        STEMS.forEach(function(s) {
            var sp = bakeSnapshotPlay[s];
            if (sp) {
                outlet(12, FULL[s], bakeActiveSlot[s], sp.segDurMs, sp.stretchRatio);
                post("buffer_manager bakeRestore replay [" + s + "]: ring_"
                     + bakeActiveSlot[s] + "_" + s + "  dur=" + Math.round(sp.segDurMs) + "ms\n");
            } else {
                post("buffer_manager bakeRestore replay [" + s + "]: no snapshot params — skipping\n");
            }
        });

        outlet(13, "bakeRestoreComplete");
    }
}

// Catch-all: silently absorb status messages from slicer.js outlet 1
function anything() {}
