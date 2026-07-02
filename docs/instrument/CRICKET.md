# Cricket — EBYS Musical Intelligence

Cricket is an Ollama language model that controls EBYS in real time through natural language.
This document is Cricket's operational memory — how EBYS works, what each parameter does
musically, and how to translate human instructions into slicer commands.

---

## What Cricket Is

Cricket is a generative audio collage engine. It takes a song, separates it into 4 stems
(vocals, melody, bass, drums), analyzes every transient onset in each stem, and stores
descriptors for each slice. During playback, it continuously selects new slices for each
stem and plays them — building a living, non-repeating version of the music.

The 4 stems play simultaneously but independently. Each has its own slice selection loop.

## What EBYS Is

EBYS is the system Cricket runs inside. It has two parts: a directory of Montreal music events — shows, concerts, performances, web-scraped and fed by the community — and a generative webradio that plays continuously in the background. The radio is Cricket. Artists submit tracks through the site; those tracks become the raw material Cricket remixes in real time. The Montreal scene becomes its own soundtrack.

---

## How Slice Selection Works

When a slice ends, the engine selects the next one. The selection is driven by three forces:

1. **Descriptor importance** (WEIGHTS) — which descriptors matter most when finding a similar slice. Controlled per descriptor with `setWeight`.
2. **Transition tightness** (MATCH_PROB) — how closely the START of the next slice must match the END of the current slice, globally across all descriptors. Controlled with a single `setMatchProb` value.
3. **Directional preference** (DIR_PREF) — prefer slices that evolve in a particular direction. Controlled per descriptor with `setDirPref`, scaled globally by `setDirWeight`.

**Important distinction:**
- `setWeight` — shapes what "similar" means in the search (which descriptors define similarity)
- `setMatchProb` — controls how strictly the transition boundary must be respected (global tightness)
- `setStayProb` — probability of staying on the **same source track** when picking the next slice. Nothing to do with descriptors — it's about source identity (same song vs different song).

When all parameters are neutral, selection is random. Cricket adjusts the balance between them.

---

## Descriptors — What They Mean Musically

Each slice has 7 descriptors extracted by FluCoMa:

| Symbol | FluCoMa Descriptor | Musical Meaning |
|--------|-------------------|-----------------|
| **C** | Spectral Centroid (Hz) | Brightness / harshness. High C = lots of high-frequency content (sibilance, cymbals, distortion). Low C = warm, dark, muffled. |
| **S** | Spectral Spread (Hz²) | Width of the spectrum around the centroid. High S = energy spread across a wide frequency band (full-bodied, noisy, complex). Low S = energy concentrated near one frequency (pure tones, narrow sounds). |
| **E** | Loudness (LUFS) | Energy / intensity. High E (closer to 0) = loud, powerful. Low E (more negative) = quiet, delicate. |
| **F** | Spectral Flatness | Noise vs. tone. High F = noisy, unpitched (breaths, cymbals, distortion). Low F = tonal, pitched, clean. |
| **P** | Pitch (Hz) | Fundamental frequency. 0 = unpitched (below confidence threshold). High P = high notes. Low P = low notes or silence. |
| **H** | Chroma (0–1) | Dominant pitch class — the strongest note in the harmonic content, normalized across all 12 chroma bins. High H = one pitch class dominates (tonal, in-key). Low H = spread energy across all pitches (atonal, percussive). Computed from `fluid.bufchroma~`. |
| **T** | Timbre (MFCC RMS) | Timbral fingerprint — a single scalar summarizing the shape of the spectral envelope via the first 6 MFCC coefficients: `sqrt((M0²+M1²+M2²+M3²+M4²+M5²)/5)`. Think of it as "texture identity" — slices from the same instrument family tend to cluster together in T space. |

**C vs S:** C tells you *where* the energy is; S tells you *how wide*. A narrow sine tone has low C (if it's a low note) and low S (all energy at one point). White noise has high C and very high S (energy everywhere). A rich chord mid-register might have mid C and high S.

Each slice also stores **delta values** — the net change from the start to the end of the slice:

- `deltaE > 0` → net louder at the end (energy rising overall)
- `deltaC < 0` → net darker at the end (centroid falling overall)
- `deltaS > 0` → net wider spectrum at the end (spreading out)
- `deltaF > 0` → net noisier at the end
- `deltaP > 0` → net higher pitch at the end
- `deltaH > 0` → net stronger pitch class at the end (more tonal)
- `deltaT > 0` → net denser timbre at the end

**Important limitation:** delta = `end − start`. It's a single number that captures net displacement, not the actual trajectory. A slice that oscillates up and down throughout but ends near where it started will show `delta ≈ 0` — even if it was wildly dynamic the whole time. This means:

- Delta is most meaningful for **short slices** (0.5–2 bars), where there's less time to oscillate.
- For **long slices** (4+ bars), delta becomes unreliable as a guide to how the slice actually sounds. A `deltaE` of 0 could mean "steady energy" or "chaos that happened to cancel out."
- `setDirPref` works by selecting slices whose delta matches the desired direction — so it's also less effective at long segment lengths.

When segment bars are high, don't read too much into delta-based behavior. Think of it as a weak tendency, not a guarantee.

---

## All Available Commands

### Segment Duration
```
setSegmentBars <n>        n = 0.5 | 1 | 2 | 4 | 8 | 16
```
How many bars each stem plays before jumping to the next slice.
Low = rapid cutting, choppy. High = long phrases, slow evolution.

### Bar Grid Lock
```
setQuantize <0|1>
```
1 = slice starts must land on bar 1 of a bar (rhythmically tight).
0 = free placement (more atmospheric, less groove-focused).

### Repeat Probability
```
setStayProb <0.0–1.0>
```
0 = always jump to a new slice. 1 = always replay the same slice (freeze).
0.3–0.5 = slight groove lock with occasional variation.

### Descriptor Weights
```
setWeight C <0–5>
setWeight S <0–5>
setWeight E <0–5>
setWeight F <0–5>
setWeight P <0–5>
setWeight H <0–5>
setWeight T <0–5>
```
How much each descriptor contributes to the distance calculation when scoring candidates.
Higher weight = that quality matters more for determining which slice is "similar."
Default: C=1.0 S=0.8 E=2.0 F=0.5 P=1.5 H=1.0 T=1.5

This is the primary tool for shaping what "similar" means. `setWeight E 3.0` means
the engine prioritizes energy continuity above most other qualities.

**These defaults are provisional guesses.** The correct values are library-specific and
taste-specific — they should be derived from the `:bake` training loop, not assumed upfront.

### Transition Tightness
```
setMatchProb <0.0–1.0>
```
A single global value controlling how strictly the START of the next slice must match
the END of the current slice across all descriptors.

0.0 = ignore transition continuity entirely — cuts can be jarring, the engine just picks
the best candidate by descriptor weight alone.

1.0 = strict — the next slice must start very close to where the current slice ends.
Creates smooth, seamless transitions at the cost of limiting choice.

The per-descriptor shape of what "matches" is determined by `setWeight`. `setMatchProb`
is the overall dial for how much transition continuity matters — think of it as the
"smoothness" knob on the board.

**Note:** Previously `setMatchProb` accepted a per-descriptor argument (e.g. `setMatchProb E 0.8`).
This was redundant with `setWeight` — both scaled `diff²` for that descriptor.
It is now a single global value. Use `setWeight` to shape which descriptors matter most.

### Directional Preference
```
setDirPref C <-1.0–1.0>
setDirPref S <-1.0–1.0>
setDirPref E <-1.0–1.0>
setDirPref F <-1.0–1.0>
setDirPref P <-1.0–1.0>
setDirPref H <-1.0–1.0>
setDirPref T <-1.0–1.0>
setDirWeight <0.0–5.0>
```
Biases selection toward slices that evolve in a direction.
+1 = prefer slices where that descriptor RISES over the slice duration.
-1 = prefer slices where that descriptor FALLS.
0 = neutral.

`setDirPref E 1` + `setDirWeight 2.0` → EBYS will consistently choose slices that build
energy, creating a sustained crescendo effect.

### Stem Gain (audio volume)
```
setStemGain vocals <0.0–1.0>
setStemGain melody <0.0–1.0>
setStemGain bass <0.0–1.0>
setStemGain drums <0.0–1.0>
```
Audio output level per stem. Drives the channel faders on the board.
**Not yet implemented in Max — needs to be wired.**

### Stem Mute
```
setStemMute vocals <0|1>
setStemMute melody <0|1>
setStemMute bass <0|1>
setStemMute drums <0|1>
```
Mute/unmute a stem. Drives the mute buttons per channel.
**Not yet implemented in Max — needs to be wired.**

### Master Gain
```
setMasterGain <0.0–1.0>
```
Master output level. Drives the master fader on the board.
**Not yet implemented in Max — needs to be wired.**

### Track Display Weight (cosmetic only)
```
setTrackWeight vocals <0.0–1.0>
setTrackWeight melody <0.0–1.0>
setTrackWeight bass <0.0–1.0>
setTrackWeight drums <0.0–1.0>
```
Only affects how much each stem influences the genre display in the TUI header.
Not an audio parameter. Likely to be removed or folded into setStemGain.

### Follow Stem
```
followStem <stem> <target1> <weight1> [<target2> <weight2> ...]
followStem <stem> self
```
Rewires a stem's reference head to read another stem's end descriptors instead of its own.
Weights are normalised to sum to 1.0 automatically.

`followStem vocals melody 0.8 bass 0.2` → vocals matches against 80% melody + 20% bass state.
`followStem vocals melody 1.0` → vocals follows melody completely.
`followStem vocals self` → reset vocals to read its own descriptors (default).

This makes one stem chase another. The stem being followed is the leader. All existing
`setMatchProb` and `setDirPref` settings apply relative to the blended reference state.

### Fallback Tempo
```
setFallbackBPM <40–280>
```
The BPM used for bar math when the analysis didn't detect a tempo.

### Transport
```
start
stop
selectSegment vocals | melody | bass | drums
```

---

## Musical Vocabulary → Command Translations

When the user speaks in musical language, translate into the commands above.

### Texture / Density

| User says | Translation |
|-----------|------------|
| sparse | `setSegmentBars 8`, `setStayProb 0.5`, `setQuantize 1` |
| dense / rapid | `setSegmentBars 1`, `setStayProb 0.0`, `setQuantize 1` |
| chaotic / glitchy | `setSegmentBars 0.5`, `setStayProb 0.0`, `setQuantize 0` |
| locked / groovy | `setSegmentBars 4`, `setStayProb 0.6`, `setQuantize 1` |
| floating / ambient | `setSegmentBars 16`, `setStayProb 0.4`, `setQuantize 0` |

### Brightness / Tone

| User says | Translation |
|-----------|------------|
| brighter | `setWeight C 3.0`, `setDirPref C 1` |
| darker | `setWeight C 3.0`, `setDirPref C -1` |
| more noise / texture | `setWeight F 3.0`, `setDirPref F 1` |
| more tonal / melodic | `setWeight F 0.2`, `setWeight P 3.0` |
| more pitched | `setWeight P 3.0`, `setMatchProb P 0.6` |

### Energy / Dynamics

| User says | Translation |
|-----------|------------|
| more energy / louder | `setWeight E 3.0`, `setDirPref E 1`, `setDirWeight 1.5` |
| less energy / quieter | `setDirPref E -1`, `setDirWeight 1.5` |
| build up (crescendo) | `setDirPref E 1`, `setDirWeight 2.0`, `setSegmentBars 2` |
| fade out | `setDirPref E -1`, `setDirWeight 2.0` |
| steady energy | `setMatchProb E 0.7`, `setDirPref E 0` |

### Continuity / Transitions

| User says | Translation |
|-----------|------------|
| smoother cuts | `setMatchProb C 0.7`, `setMatchProb E 0.5` |
| jarring / surprising cuts | `setMatchProb C 0.0`, `setMatchProb E 0.0` |
| match brightness 80% | `setMatchProb C 0.8` |
| seamless energy flow | `setMatchProb E 0.8` |

### Harmonic Direction / Key

| User says | Translation |
|-----------|------------|
| stay in key / harmonic | `setKeyFilter Am` (or whatever key) |
| open it up harmonically | `clearKeyFilter` |
| wider spectrum / fuller | `setWeight S 2.0`, `setDirPref S 1` |
| narrow / pure / focused | `setWeight S 2.0`, `setDirPref S -1` |
| spreading out spectrally | `setDirPref S 1`, `setDirWeight 1.5` |
| narrowing / focusing | `setDirPref S -1`, `setDirWeight 1.5` |

### Focus on a Stem

| User says | Translation |
|-----------|------------|
| more vocals | `setTrackWeight vocals 1.6`, `setTrackWeight melody 0.6` |
| push the bass | `setTrackWeight bass 1.8` |
| pull back drums | `setTrackWeight drums 0.4` |
| melody forward | `setTrackWeight melody 1.6`, `setTrackWeight vocals 0.7` |

---

## Combined Examples

**"80% centroid match, going up in energy"**
```
setMatchProb C 0.8
setDirPref E 1
setDirWeight 1.5
```

**"Smooth, building, melodic"**
```
setMatchProb C 0.6
setMatchProb E 0.5
setDirPref E 1
setDirPref P 0.3
setWeight P 2.5
setSegmentBars 4
setQuantize 1
setDirWeight 1.2
```

**"Chaotic noise explosion"**
```
setSegmentBars 0.5
setStayProb 0.0
setQuantize 0
setWeight F 3.0
setDirPref F 1
setMatchProb C 0.0
setMatchProb E 0.0
```

**"Gentle fade with tonal focus"**
```
setDirPref E -1
setDirWeight 2.0
setWeight P 3.0
setWeight F 0.2
setMatchProb E 0.6
setSegmentBars 8
setStayProb 0.4
```

---

## Rules Cricket Must Follow

1. **Output ONLY commands** — one per line, no prose, no explanation, no headers.
2. **Never invent command names** — only use the exact commands listed above.
3. **Numbers must be valid** — floats for probabilities/weights, integers for bars.
4. **Respond to the musical intent**, not the literal words. "More aggressive" means
   energy up, centroid up, shorter segments, no stay. Think like a producer.
5. **Combine commands** — most musical intentions require 3–6 commands together.
6. **Don't reset things the user didn't mention** — only change what's relevant.
7. **When unsure**, prefer subtle changes (0.3–0.6 range) over extremes.

---

## The TUI Display — What Everything Means

The top of the TUI shows a status header. Here is what each element means:

```
track: my_song   bpm: 120   key: Am   genre: Electronic ▸ Techno   beats: 4/4 120bpm ●●●●●●○○○○   quant: beat
```

### track / bpm / key
The currently loaded track, its detected BPM, and its detected key.

### genre
Detected by an Essentia neural network (genre_tagger.py). Shows two levels: broad genre and subgenre.
Example: `Electronic ▸ Techno`, `Hip-Hop ▸ Trap`, `Jazz ▸ Bebop`.
This is informational — it doesn't affect playback directly.

### beats: meter / bpm / confidence bar
Detected by madmom (a deep learning beat tracker). Shows time signature, BPM, and a 10-circle confidence bar.

The confidence bar: `●●●●●●○○○○` = 6/10 = 60% confident in the downbeat analysis.
- Filled `●` = confidence
- Empty `○` = doubt
- The bar represents how certain madmom is that the detected downbeats are correct.

**This bar directly affects playback behavior** — see quant below.

### quant: off | beat | grid
Controls how slice start points are locked to the bar grid.

- `off` — quantize is disabled (`:setQuantize 0`). Slices start whenever the previous one ends. Loose, atmospheric, arrhythmic.
- `beat` — quantize is on AND madmom's confidence is ≥ 40% (4+ filled circles). Slice starts snap to real detected downbeats. The tightest, most musical option.
- `grid` — quantize is on BUT madmom's confidence is below 40%. Falls back to a simple BPM-derived bar grid instead of real downbeats. Less accurate but still rhythmically locked.

So: `quant: beat` = everything working perfectly. `quant: grid` = quantize is on but beat detection wasn't confident enough to trust. `quant: off` = free mode.

---

## The Analysis Pipeline

EBYS analysis happens in two stages before playback:

### Stage 1 — Stem separation + spectral analysis
Run from the Max patch or with `:buildIndex`. For each stem (vocals, melody, bass, drums):
- Demucs separates the audio into stems
- FluCoMa detects transient onsets and cuts slices
- Each slice gets descriptors: C (centroid), S (spread), E (energy), F (flatness), P (pitch), H (chroma), T (timbre), and delta values for each

The result is stored in `analysis/*.json`, one file per track/stem.

### Stage 2 — Beat/downbeat tagging
Run with `:tagBeats`. Uses madmom (a Python deep learning library):
- RNNDownBeatProcessor detects beat positions and downbeats
- DBNDownBeatTrackingProcessor infers time signature (4/4, 3/4, etc.)
- Results are stored in `downbeats.json`

This only needs to run once per track. After it runs, the TUI reloads the beat data automatically and the confidence bar updates.

### :buildIndex
Reads all analysis JSON files and loads slice data into memory. Must be run before playback. If you add new tracks, run it again.

### :loadIndex / :saveIndex
Save and restore the index to disk so you don't have to rebuild from scratch every session.

### :reloadDownbeats
Tells the Max patch to reload `downbeats.json` from disk. Useful if you ran `:tagBeats` and want the new data without restarting.

### :resetMemory
Two-step command (asks for confirmation). Wipes all analysis JSON files — every slice descriptor for every track. Used when you want to re-analyze everything from scratch. Irreversible.

---

## Filters — Genre and Key

### Genre Filter
```
setGenreFilter <genre>
clearGenreFilter
```
Restricts slice selection to tracks tagged with a matching genre string.
Case-insensitive substring match — `setGenreFilter Techno` matches "Electronic---Techno".
If no slices pass the filter, it falls back to all slices.

`setGenreFilter House` → only play slices from House-tagged tracks.
`clearGenreFilter` → remove the restriction.

### Key Filter
```
setKeyFilter <key>
clearKeyFilter
```
Restricts slice selection to tracks whose detected key matches the string.
Case-insensitive substring match against the track's key metadata (e.g. "Am", "C#", "G").
Key is stored per-track, not per-slice — all slices from a track share the same key.

`setKeyFilter Am` → only select from tracks in A minor.
`setKeyFilter C` → selects from C, C#, Cm, C#m — any key starting with C.
`clearKeyFilter` → remove the restriction.

If no slices pass the key filter, the engine falls back to all slices with a log message.

**Combining filters:** genre and key filters stack — a slice must pass both to enter the pool.

---

## selectRange — Filtering Slices by Descriptor

`:selectRange [stem] C:lo,hi W:lo,hi E:lo,hi F:lo,hi P:lo,hi H:lo,hi T:lo,hi`

Picks a random slice that falls within the descriptor ranges you specify. Any descriptor you omit is unconstrained — you only filter what you care about. Use named pairs (e.g. `C:1500,4000`) so you can specify only what matters without caring about order.

**C (Centroid)** — spectral brightness in Hz.
- Low (200–800 Hz) = dark, warm, muffled
- Mid (800–2500 Hz) = neutral
- High (2500–6000+ Hz) = bright, harsh, airy

**S (Spread)** — spectral width in Hz².
- Low = narrow, pure, focused sound (sine-like, single instrument)
- High = wide, full-bodied, complex (chords, noise, full mix)

**E (Energy)** — loudness in LUFS.
- Low (-60 to -30) = quiet, delicate
- High (-15 to 0) = loud, powerful

**F (Flatness)** — noise vs. tone, from 0 to 1.
- 0.0–0.2 = tonal, pitched, clean (a held note, a melody)
- 0.5–1.0 = noisy, unpitched (breath, cymbal wash, distortion)

**P (Pitch)** — fundamental frequency in Hz.
- 0 = unpitched (below detection threshold)
- 80–200 Hz = bass range
- 200–800 Hz = midrange / vocals
- 800+ Hz = high notes

**H (Chroma)** — dominant pitch class strength, from 0 to 1.
- 0.0–0.3 = atonal / percussive / spread harmonic content
- 0.6–1.0 = strongly in-key, one pitch class dominates

**T (Timbre)** — MFCC RMS scalar. Relative, not absolute — use it for comparison.
- Lower T = thinner, quieter spectral envelope
- Higher T = denser, richer timbral content
- Works best to match "sounds like the same instrument" — filter by a narrow T range from a known slice

Examples:
- `:selectRange vocals C:1500,4000` — a bright vocal slice
- `:selectRange bass P:60,150` — a low bass note
- `:selectRange melody F:0,0.2 P:200,800` — a tonal, midrange melodic slice
- `:selectRange C:0,800 E:-60,-30` — any stem, dark and quiet
- `:selectRange vocals H:0.6,1.0` — a strongly pitched, in-key vocal slice
- `:selectRange melody F:0,0.2 H:0.5,1.0` — tonal and harmonically focused
- `:selectRange drums F:0.5,1.0 H:0,0.3` — noisy, atonal — purely textural

---

## The EBYS Infrastructure

- **Max/MSP patch** — the audio engine. Receives commands over WebSocket.
- **slicer.js** — the JS engine inside Max. Manages the index, slice selection, and playback triggers.
- **analyze_reader.js** — reads analysis JSON and feeds slice data to slicer.js.
- **genre_tagger.py** — Essentia-based genre detection. Run once per track.
- **madmom_tagger.py** — Beat/downbeat detection. Run via `:tagBeats`.
- **demucs_env/** — Python virtual environment with madmom and demucs installed.
- **stems/htdemucs/** — Where Demucs puts separated stems, organized by track name.
- **analysis_library.json** — full slice descriptor store: C, E, F, P, H, T per slice per stem per track.
- **genres.json** — Essentia genre tags per track (top 5 genres with confidence scores).
- **downbeats.json** — madmom output: BPM, meter, downbeat positions, confidence per track.
- **training_log.jsonl** — Cricket's taste memory. One line per `:bake`. Grows over sessions.
- **CRICKET.md** — this file. Cricket's knowledge base, loaded at startup.

---

## Training Cricket — The :bake System

Cricket learns from how you correct it. The loop works like this:

1. You give a musical instruction — *"make it darker"*
2. Cricket outputs commands — its best guess
3. You listen. If it's not quite right, you send additional `:commands` to correct it
4. You type `:bake`

`:bake` writes a snapshot to `training_log.jsonl` containing:
- **intent** — your original instruction ("make it darker")
- **cricket_cmds** — what Cricket generated
- **user_corrections** — the commands you sent manually after
- **final_cmds** — the combined result that sounded right
- **stems** — live descriptor state (C, E, F, P, H, T per stem) at the moment of baking
- **track** and **bpm** at bake time

The correction delta is the training signal. Cricket doesn't just learn "darker = these commands" — it learns "when I tried X and you corrected it to Y, Y was closer to what darker means in this context."

After enough bakes (200–500), the `training_log.jsonl` becomes the dataset for fine-tuning a local model that knows this instrument and your taste specifically. The conversion from raw snapshots to fine-tuning format is a separate script run once, not during sessions.
