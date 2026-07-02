# EBYS — Default Settings

All parameters listed here are the **factory defaults** — values active at startup before any command is sent. Use the commands below to override them during a session or performance. Changes are not persisted across restarts; to make a new default permanent, edit this file and the corresponding variable in `slicer.js` / `sdj-tui.js`.

---

## Timing

| Parameter | Default | Command | Notes |
|-----------|---------|---------|-------|
| **Fallback BPM** | `120` | `:setFallbackBPM <n>` | Used when madmom analysis returned 0 or is unavailable. All 4 stems use this as the global bar clock unless overridden. |
| **Global BPM** | off | `:setGlobalBPM <n>` | Forces all stems to a fixed BPM, overriding per-track analysis. `:setGlobalBPM 0` restores analyzed BPM. |
| **Segment length** | `4 bars` | `:setSegmentBars <n>` | How many bars each loop segment lasts. All four stems always use the same value — different lengths per stem are possible via `:setSegmentBars <stem> <n>` but are the user's explicit choice. |
| **Quantize** | `on` | `:setQuantize 0\|1` | When on, segment starts snap to bar-grid downbeats detected by madmom. Keeps cuts rhythmically grounded. Turn off for more abstract, free-floating slicing. |

---

## Selection

| Parameter | Default | Command | Notes |
|-----------|---------|---------|-------|
| **Stay probability** | `0.5` (per stem) | `:setStayProb <stem> <0–1>` | Probability that a stem stays on its current source track for the next segment. `0` = always move, `1` = never move. `0.5` = coin flip each cycle. |
| **Descriptor matching** | `0.9` (all descriptors) | `:setWeight <descriptor> <0–1>` | How strongly EBYS tries to match spectral continuity across cuts. Applied to all 6 descriptors (C, E, F, P, H, T). `0` = pure random, `1` = strict match. `0.9` = always picks the spectrally nearest neighbor (continuity), but never the exact same slice. Variety comes from STAY_PROB moving between source tracks. |
| **Direction preference** | `0.0` (neutral) | `:setDirPref <descriptor> <-1–1>` | Per-descriptor bias: `+1` = prefer rising, `-1` = prefer falling, `0` = neutral. |
| **Direction weight** | `1.0` | `:setDirWeight <0–∞>` | Global scale multiplier for all direction preferences. |
| **Max slices per stem** | `200` | `:setMaxSlices <n>` | Caps the selection pool per stem. Keeps selection fast with large libraries. `0` = unlimited. |

---

## Momentum (MMT)

| Parameter | Default | Command | Notes |
|-----------|---------|---------|-------|
| **MMT window** | `4 bars` | `:setMMT <bars>` | Sliding window used by `add_tension.py` to compute per-bar momentum for all 6 descriptors. Reruns tension calculation and sends `buildIndex` on change. Smaller = more sensitive to short-term energy swings. Larger = broader arc tracking. |

---

## Bake

| Parameter | Default | Command | Notes |
|-----------|---------|---------|-------|
| **Bake loop window** | `4 bars` | `:bakeloop <bars>` | Loop window length captured during `:bake start`. |

---

## Pitch

| Parameter | Default | Command | Notes |
|-----------|---------|---------|-------|
| **Pitch shift** | `0 semitones` (all stems) | `:pitchShift <stem> <semitones>` | Frequency-only shift via pfft~/gizmo~. Duration unchanged. `:pitchShift all 0` resets all stems. |

---

## M/S Stereo

| Parameter | Default | Command | Notes |
|-----------|---------|---------|-------|
| **Analysis-driven mode** | `on` | `:analysisMode on\|off` | When on, pan and width update automatically per slice from `add_stereo_features.py` values. Off = fully manual control. |
| **Width** | `0.5` (per stem) | `:width <stem\|all> <0–1>` | M/S stereo width. 0 = mono, 1 = full pseudo-stereo (Haas side channel). In analysis-driven mode, overridden per slice. |
| **Pan** | `0.0` (center, per stem) | `:pan <stem\|all> <-1–+1>` | Stereo pan using equal-power law. -1 = hard left, 0 = center, +1 = hard right. In analysis-driven mode, overridden per slice. |

---

## FX Send / Return

| Parameter | Default | Command | Notes |
|-----------|---------|---------|-------|
| **FX send level** | `0.0` | `:fxSend <0–1>` | Send level to hardware pedal (dac~ 3/4). Also controls dry crossfade: at 1.0, dry is fully muted — only the pedal return is heard (insert model). |
| **FX return level** | `0.0` | `:fxReturn <0–1>` | Return level from hardware pedal (adc~ 3/4) into the main mix. |
| **FX stereo mode** | `0` (mono) | `:fxStereo 0\|1` | 0 = mono pedal: same signal on dac~ 3+4, return from adc~ 3 only (centered). 1 = stereo pedal: master L/R on dac~ 3/4, adc~ 3 = L return, adc~ 4 = R return. |

---

## Notes

- **Stems always fire in sync.** All four stems (vocals, melody, bass, drums) use the same global bar clock for the delay timer. Per-track BPM differences are handled by `stretchRatio` inside karma~, not by adjusting the timer.
- **Stay probability is per-stem.** `:setStayProb all 0.5` sets all four at once; `:setStayProb vocals 0` lets vocals roam while others stay.
- **Descriptor matching applies to transitions.** MATCH_PROB shapes how the *next* segment is chosen relative to where the *current* segment ends, not to the absolute descriptor value of the chosen slice.
