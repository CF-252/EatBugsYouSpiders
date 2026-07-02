# Playback Engine

The EBYS playback engine runs in Max/MSP. It receives slice commands from `slicer.js` via Node.js, manages four independent audio streams (one per stem), and outputs a stereo mix with M/S processing and FX.

---

## 2-Level Buffer Architecture

Each stem has two buffers:

**Level 1 — Source buffer** (`stem_vocals`, `stem_melody`, `stem_bass`, `stem_drums`): holds the full audio for the current source track. When `slicer.js` selects a new track for a stem, the source buffer is loaded via `buffer~`. Loading is non-interruptive — the previous track continues playing while the new one loads.

**Level 2 — Slice buffer** (`vocals_slice`, `melody_slice`, etc.): a short buffer holding exactly the current segment. When the bar clock fires, the engine extracts the selected slice from the source buffer using `fluid.bufselect~`, time-stretches if needed (`fluid.bufstretch~`), and fires `play~` on the slice buffer.

This two-level approach means:
- The source buffer swap (loading a new 5-minute track) is amortized over the whole track — it happens in background, not at the bar boundary
- The slice buffer is always ready — the current segment is in place before the clock fires
- Time stretching (when `stretchRatio ≠ 1.0`) is applied to the short slice, not the full track

---

## Four-Stem Signal Flow

```
slicer.js  →  Node.js (port 7777)  →  Max external (js object)  →  route stem_name
    │
    └── "vocals startFrac endFrac stretchRatio"
                ↓
        unpack f f f
        │           │           └── stretchRatio → store
        │           └── endFrac × framecount → endFrame
        └── startFrac × framecount → startFrame
                ↓
        fluid.bufselect~ (source → vocals_slice)
                ↓ done bang
        fluid.bufstretch~ (timeratio stretchRatio)
                ↓ done bang
        play~ vocals_slice → dac~ 1 2 (after M/S processing)
```

The same signal flow runs independently for all four stems. They share the global bar clock for timing, but their audio paths are completely independent.

---

## Bar Clock

The bar clock is a single delay loop running in Max. It fires every `(60 / BPM) × 4 × SEGMENT_BARS` seconds. When it fires, it sends a bang to all four stems simultaneously — each stem extracts its next slice and begins playback.

All stems fire on the same beat. BPM differences between source tracks are handled by `stretchRatio` (time-stretching the slice to fit the global tempo), not by adjusting the clock.

---

## M/S Stereo Processing

Each stem passes through a mid-side (M/S) matrix:

```
M (mid) = L + R
S (side) = L − R

width control:
    mid_out  = M × mid_gain
    side_out = S × side_gain

L_out = (mid_out + side_out) / 2
R_out = (mid_out − side_out) / 2
```

`mid_gain` and `side_gain` are derived from the `:width` command value and the `add_stereo_features.py` analysis per slice.

When analysis-driven mode is on, pan and width update automatically per slice. The system reads the `pan` and `stereo_width` descriptor values from the slice's row in the database and sends them to Max via OSC at slice load time.

---

## FX Send / Return

The master bus has a hardware FX insert:

```
master mix → dac~ 3 4 (send to hardware pedal)
adc~ 3 4 (return from hardware pedal) → output mix
```

The `fxSend` and `fxReturn` controls set the send/return levels independently. At `fxSend 1.0`, the dry signal is muted and only the pedal return is heard — insert model. At `fxSend 0.5`, dry and wet are blended.

When `fxStereo 1` is set, the master L/R is sent on dac~ 3/4 and the return is read from adc~ 3 (L) and adc~ 4 (R) — true stereo insert. Otherwise (default), a mono mix is sent on both 3 and 4, and only adc~ 3 is read (centered in the return mix).

---

## VU Meters

The TUI displays VU meters for each stem. These are driven by `meter~` objects in Max reporting peak dB. The values are sent from Max to the TUI via OSC:

```
/vu/vocals  -12.3
/vu/melody  -8.1
/vu/bass    -6.7
/vu/drums   -4.5
```

The TUI renders them as ASCII bar meters with dB values. Update rate: 100ms.

---

## Pitch Shift

Pitch shifting is done per-stem via `pfft~` + `gizmo~` in Max. Frequency-domain pitch shift — duration unchanged.

```
:pitchShift vocals +3     → +3 semitones on the vocals stem
:pitchShift bass -2       → -2 semitones on the bass stem
:pitchShift all 0         → reset all stems to 0 semitones
```

Pitch shift is applied before M/S processing.

---

## Karma~ (Buffer Player)

`karma~` is a high-quality buffer player in Max/MSP that handles polyphonic playback with variable rate and pitch. In EBYS, `karma~` is used as an alternative to `play~` for tracks that need more sophisticated looping or blending behavior.

Each stem can optionally use `karma~` instead of `play~` for its slice playback. The `stretchRatio` in this case maps to `karma~`'s rate parameter rather than running through `fluid.bufstretch~`.

Current implementation: `play~` is the primary playback object. `karma~` integration is partially implemented and planned for the EBYS-A1 hardware instrument where polyphonic blending is a key feature.

---

## Max Patch Files

```
EBYS_INFRA/max/
├── ebys_main.maxpat          ← master patch (routing, bar clock, output)
├── ebys_stem.maxpat          ← stem subpatch (instantiated ×4)
├── ebys_ms.maxpat            ← M/S matrix subpatch
├── ebys_fx.maxpat            ← FX send/return subpatch
├── ebys_vu.maxpat            ← VU meter display
└── ebys_link.maxpat          ← LINK protocol (in progress)
```
