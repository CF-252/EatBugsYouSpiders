// EBYS — Slot Router  v4
//
// ── Role ──────────────────────────────────────────────────────────────────────
// Slot Router is the audio engine parameter hub of EBYS.  It owns all DSP
// settings: it is the only JS object that sends messages to karma~ or pfft~.
//
// Responsibilities:
//   - Tempo axis: translates stretchRatio → karma~ speed factor (right inlet),
//     so playback is faster/slower without slicer.js knowing about audio objects
//   - Buffer switching: tells each karma~ which ring buffer to play and seeks it
//   - Delay timing: computes the stretched segment duration so the next segment
//     fires at the right moment
//   - Pitch axis: translates semitone offsets → frequency ratios and sends them
//     to pfft~/gizmo~ per stem, fully independent of tempo
//
// Slot Router does NOT make musical decisions.  It receives ready-to-play
// commands from buffer_manager.js and real-time parameter changes from
// ws_server.js (via the route object).  All sequencing logic lives in slicer.js.
// ──────────────────────────────────────────────────────────────────────────────
//
// Receives play commands from buffer_manager.js and drives karma~ + pfft~/gizmo~.
//
// Two independent axes:
//   TEMPO  — karma~ speed inlet (right) = 1/stretchRatio
//              pitch follows as a tape side-effect (slower → lower)
//   PITCH  — pfft~/gizmo~ pitch ratio per stem, fully independent of duration
//              setPitch melody 1.5   → raise melody ~8 semitones, no timing change
//
// Input format (from buffer_manager outlet 12):
//   vocals  ringSlot  segDurMs  stretchRatio
//   melody  ringSlot  segDurMs  stretchRatio
//   bass    ringSlot  segDurMs  stretchRatio
//   drums   ringSlot  segDurMs  stretchRatio
//
// Commands:
//   setPitch vocals 1.0           → reset (no shift)
//   setPitch melody 1.5           → raise melody by ~8 semitones
//   setPitchSemitones melody 3    → raise melody 3 semitones (2^(3/12))
//   setPitch all 1.0              → reset all stems
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0  → karma~ vocals   inlet 0   "set ring_N_voc"
//   1  → karma~ vocals   inlet 0   seek 0 (via t b b f → play)
//   2  → delay  vocals             segDurMs
//   3  → karma~ melody  inlet 0   "set ring_N_mel"
//   4  → karma~ melody  inlet 0   seek 0
//   5  → delay  melody            segDurMs
//   6  → karma~ bass    inlet 0   "set ring_N_bss"
//   7  → karma~ bass    inlet 0   seek 0
//   8  → delay  bass              segDurMs
//   9  → karma~ drums   inlet 0   "set ring_N_drm"
//  10  → karma~ drums   inlet 0   seek 0
//  11  → delay  drums             segDurMs
//  12  → karma~ vocals  inlet 1   speed factor (1/stretchRatio, tape tempo)
//  13  → karma~ melody  inlet 1   speed factor
//  14  → karma~ bass    inlet 1   speed factor
//  15  → karma~ drums   inlet 1   speed factor
//  16  → pfft~/gizmo~ vocals      pitch ratio (independent of duration)
//  17  → pfft~/gizmo~ melody      pitch ratio
//  18  → pfft~/gizmo~ bass        pitch ratio
//  19  → pfft~/gizmo~ drums       pitch ratio

autowatch = 1;
inlets    = 1;
outlets   = 20;

var STEM_SHORT = { vocals: "voc", melody: "mel", bass: "bss", drums: "drm" };
var STEM_BASE  = { vocals: 0,     melody: 3,     bass: 6,     drums: 9     };
var SPEED_OUT  = { vocals: 12,    melody: 13,    bass: 14,    drums: 15    };
var PITCH_OUT  = { vocals: 16,    melody: 17,    bass: 18,    drums: 19    };

// Per-stem pitch ratio for gizmo~ — independent of tempo.
// 1.0 = no shift. 2^(n/12) for n semitones.
var stemPitch = { vocals: 1.0, melody: 1.0, bass: 1.0, drums: 1.0 };

function routeStem(stem, ringSlot, segDurMs, stretchRatio) {
    var sh   = STEM_SHORT[stem];
    var base = STEM_BASE[stem];
    if (sh === undefined) { post("slot_router: unknown stem '" + stem + "'\n"); return; }

    stretchRatio = parseFloat(stretchRatio) || 1.0;

    // Tempo: karma~ plays at 1/stretchRatio speed → pitch follows (tape-style)
    // Actual playback duration = segDurMs * stretchRatio → delay must match
    var speedFactor = 1.0 / stretchRatio;
    var delayMs     = Math.round(parseFloat(segDurMs) * stretchRatio) || 1000;
    var bufName     = "ring_" + parseInt(ringSlot) + "_" + sh;

    // karma~ right inlet requires a Max float atom, not int.
    // In Max JS, any number with no fractional part (e.g. 1.0) is sent as int.
    // Add a negligible epsilon to guarantee a fractional part → float atom.
    // The 1e-9 difference in speed is completely inaudible (~0.00000009% pitch shift).
    var speedFloat = speedFactor + 1e-9;
    outlet(PITCH_OUT[stem], stemPitch[stem]);      // ensure gizmo~ always has a valid ratio
    outlet(SPEED_OUT[stem], speedFloat);           // karma~ speed inlet (float)
    // Stop BEFORE switching buffer — ensures stop, set, seek, and play all fire
    // in the same scheduler tick via slot_router, with correct ordering guaranteed.
    // The delay objects no longer have direct stop→karma~ connections; all stop
    // messages now flow through here so they are always followed immediately by
    // the new buffer set and play without any external timing dependency.
    outlet(base + 0, "stop");                      // stop karma~ before buffer switch
    outlet(base + 0, "set", bufName);              // switch karma~ buffer
    outlet(base + 2, delayMs);                     // delay time (stretched)
    outlet(base + 1, 0);                           // seek 0 → play

    if (stretchRatio !== 1.0) {
        post("slot_router [" + stem + "]: speed=" + speedFactor.toFixed(3)
             + "  stretch=" + stretchRatio.toFixed(3)
             + "  delay=" + delayMs + "ms\n");
    }
}

function vocals(ringSlot, segDurMs, stretchRatio) { routeStem("vocals", ringSlot, segDurMs, stretchRatio); }
function melody(ringSlot, segDurMs, stretchRatio) { routeStem("melody", ringSlot, segDurMs, stretchRatio); }
function bass  (ringSlot, segDurMs, stretchRatio) { routeStem("bass",   ringSlot, segDurMs, stretchRatio); }
function drums (ringSlot, segDurMs, stretchRatio) { routeStem("drums",  ringSlot, segDurMs, stretchRatio); }

// ── Per-stem pitch control ────────────────────────────────────────────────────
// Sends pitch ratio directly to the gizmo~ inside each stem's pfft~.
// Pitch is independent of playback speed — only affects frequency content.

function setPitch(stem, ratio) {
    ratio = parseFloat(ratio);
    if (isNaN(ratio) || ratio <= 0) {
        post("slot_router: setPitch — invalid ratio " + ratio + "\n"); return;
    }
    var targets = (String(stem) === "all")
        ? ["vocals", "melody", "bass", "drums"]
        : [String(stem)];

    for (var i = 0; i < targets.length; i++) {
        var t = targets[i];
        if (!stemPitch.hasOwnProperty(t)) {
            post("slot_router: setPitch — unknown stem '" + t + "'\n"); continue;
        }
        stemPitch[t] = ratio;
        outlet(PITCH_OUT[t], ratio);
        post("slot_router: pitch[" + t + "] = " + ratio.toFixed(4)
             + "  (" + (Math.log(ratio) / Math.log(2) * 12).toFixed(2) + " st)\n");
    }
}

function setPitchSemitones(stem, n) {
    n = parseFloat(n);
    if (isNaN(n)) { post("slot_router: setPitchSemitones — invalid value\n"); return; }
    setPitch(stem, Math.pow(2, n / 12.0));
}

// pitchShift — TUI command :pitchShift <stem> <semitones>
// Alias for setPitchSemitones, named to match the TUI command directly.
function pitchShift(stem, semitones) {
    setPitchSemitones(stem, semitones);
}

// ── Stop ──────────────────────────────────────────────────────────────────────
// Called when buffer_manager forwards "stop" via outlet 12.
// Sends the karma~ "stop" message to all four stems via their inlet 0 outlets.
// Also cancels each delay so the next "next <stem>" doesn't fire after stop.
function stop() {
    outlet(0,  "stop");   // karma~ vocals  inlet 0
    outlet(3,  "stop");   // karma~ melody  inlet 0
    outlet(6,  "stop");   // karma~ bass    inlet 0
    outlet(9,  "stop");   // karma~ drums   inlet 0
    // Delays may still fire but slicer.js ignores them when running=false.
    post("slot_router: stopped all karma~ objects\n");
}
