# add_tension.py

Computes **tension fields** for every slice in `analysis_library.json` and writes them back in place. Run this once after analysis, or again any time you add new tracks.

---

## What it does

For each stem of each track, it runs 5 steps:

1. **Assign slices to bars** — each slice has a normalized `time` field (0–1). Multiplying by `stemDurMs` gives the absolute position in milliseconds. That position is compared against `downbeats_ms` from `downbeats.json` to find which bar the slice belongs to.

2. **Average descriptors per bar** — all slices in a given bar are grouped and their descriptor values averaged. This gives one value per bar per descriptor (C, E, F, P, H, T).

3. **Sliding-window slope** — for each bar `b`, the slope is `avg[b + half] − avg[b − half]`. A positive slope means the descriptor is rising at that point in the track (building). Negative means falling (releasing). The window size defaults to 4 bars (so `half = 2`).

4. **Normalize to [0, 1]** — the raw slopes span a different range for every descriptor and every track. Normalizing maps the most negative slope to `0.0` and the most positive slope to `1.0`, making all tension values comparable.

5. **Write back to each slice** — every slice in a bar gets the tension value for that bar. Six new fields are added: `tension_C`, `tension_E`, `tension_F`, `tension_P`, `tension_H`, `tension_T`.

---

## The 6 tension fields

| Field | Descriptor | What it detects |
|---|---|---|
| `tension_E` | Energy (LUFS) | Volume/loudness build — most reliable indicator of a drop incoming |
| `tension_C` | Spectral centroid | Brightness opening up — filter sweeps, highs entering |
| `tension_F` | Spectral flatness | Noise floor rising — white noise layering in |
| `tension_P` | Pitch | Melodic ascent, pitch risers |
| `tension_H` | Chroma (0–1) | Harmonic density — more notes/chords stacking |
| `tension_T` | Timbre (MFCC RMS) | Timbral shift — new instrument textures entering |

`T` is not stored directly in the slice. It is computed on the fly as the RMS of the 6 MFCC coefficients (`M0`–`M5`): `sqrt(mean(M0² … M5²))`.

---

## Usage

```bash
# Process all tracks in analysis_library.json
python3 add_tension.py

# Process one track (partial name match, case-insensitive)
python3 add_tension.py "439iSMT"

# Change window size (default 4 bars)
python3 add_tension.py --window 6
```

A larger window gives a smoother, more gradual tension curve. A smaller window reacts faster to local changes.

---

## Files

| File | Role |
|---|---|
| `MAX/analysis_library.json` | Read + written in place. Tension fields added to each slice. |
| `downbeats.json` | Read only. Provides `downbeats_ms` (bar-1 timestamps in ms) per track. |

The script matches tracks across the two files by stripping the stem suffix (`_vocals.wav`, `_drums.wav`, etc.) from the `analysis_library.json` key and looking up the result in `downbeats.json`. Partial matching is used as a fallback.

---

## Output example

```json
{
  "slice_0081": {
    "time": 0.057,
    "C": 2812.1,
    "E": -22.1,
    "F": 8258.3,
    "H": 0.27,
    "M0": -191.8,
    "tension_C": 0.39,
    "tension_E": 0.55,
    "tension_F": 0.44,
    "tension_P": 0.00,
    "tension_H": 0.35,
    "tension_T": 0.43
  }
}
```

`tension_P = 0.00` for drums is expected — no tonal pitch in a percussive stem.

---

## When to run

- After running the Essentia analysis pipeline on a new track
- After re-running `madmom_tagger.py` (downbeats changed)
- As a batch over all tracks when first setting up the library

The script is fast — pure math on stored numbers, no audio loading. 100 tracks with 500 slices each processes in under 5 seconds.
