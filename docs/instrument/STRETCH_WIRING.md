# EBYS — Time Stretch Wiring Guide

## What changed in the JS files

**slicer.js** — outlet 0 now outputs 4 values instead of 3:
```
track  startFrac  endFrac  stretchRatio
```
`stretchRatio` = `analyzedBPM / GLOBAL_BPM`  
→ 1.0 when no global BPM override (no stretching)  
→ e.g. 1.33 when track is 120 BPM and you set `@setGlobalBPM 90` (stretch longer = slower)  
→ e.g. 0.75 when track is 90 BPM and you set `@setGlobalBPM 120` (compress = faster)

This is the correct value for `fluid.bufstretch~ @timeratio`.

**analyze_reader.js** — BPM estimation replaced with comb-filter scoring.  
Tests every BPM 60–200, finds the one that best explains the onset grid including  
subdivisions (×0.25, ×0.5, ×1, ×2, ×3, ×4). Much more accurate for complex material.

---

## What to add in the Max patch — per stem

Do this **4 times**, once for each stem (vocals, melo, bass, drums).  
The example below uses **vocals**. Replace buffer names for the other stems.

### Step 1 — Add a slice buffer

Create a new buffer~ to hold the extracted slice before stretching:
```
buffer~ vocals_slice 10000 2
```
(10 seconds stereo — it will be resized automatically by fluid.bufselect~)

Create a second buffer for the stretched result:
```
buffer~ vocals_stretched 10000 2
```

### Step 2 — Capture the 4th argument (stretchRatio)

The slicer's outlet 0 currently goes through `route vocals` and you unpack `startFrac endFrac`.  
Now add a third unpack slot to capture `stretchRatio`:

**Change:** `unpack f f` → `unpack f f f`

The third outlet of unpack gives you the stretchRatio.

### Step 3 — Extract the slice with fluid.bufselect~

After `unpack f f f`, you need startFrame and numFrames in samples (not fractions).  
Use `info~ stem_vocals` to get the total framecount, then:

```
startFrac  →  [* framecount]  →  startFrame
endFrac    →  [* framecount]  →  endFrame
endFrame - startFrame         →  numFrames
```

Wire up:
```
fluid.bufselect~ @source stem_vocals @destination vocals_slice
```
Send it the message:
```
startframe <startFrame> numframes <numFrames>
```
Then trigger it with a **bang**.

When `fluid.bufselect~` finishes it outputs a bang from its right outlet.

### Step 4 — Stretch with fluid.bufstretch~

On the done bang from `fluid.bufselect~`, trigger:
```
fluid.bufstretch~ @source vocals_slice @destination vocals_stretched
```
with the message:
```
timeratio <stretchRatio> pitchratio 1.0 fftsize 2048 hopsize 512 windowsize 2048
```
Then bang it.

`pitchratio 1.0` keeps the pitch unchanged — only the tempo changes.  
When done, `fluid.bufstretch~` outputs a bang from its right outlet.

### Step 5 — Play the stretched buffer

On the done bang from `fluid.bufstretch~`, tell `play~` to play `vocals_stretched`:

```
play~ vocals_stretched
```

Send it: `startframe 0` then bang.

The existing "done bang → next vocals" logic stays the same — just point it at `play~ vocals_stretched` instead of `play~ stem_vocals`.

---

## Sequencing summary (signal flow)

```
slicer outlet 0: "vocals startFrac endFrac stretchRatio"
    │
    ├─ route vocals
    │       │
    │   unpack f f f
    │   │        │       └── stretchRatio → store
    │   │        └── endFrac * N → endFrame
    │   └── startFrac * N → startFrame
    │
    ├─► fluid.bufselect~ (startFrame, numFrames) ──bang──►
    │                                                      │
    │                                              fluid.bufstretch~ (timeratio) ──bang──►
    │                                                                                      │
    │                                                                              play~ vocals_stretched
    │                                                                                      │
    └────────────────────────────────────── done bang → "next vocals" ◄───────────────────┘
```
