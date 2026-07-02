# EBYS — Architecture Reference

> **EBYS** (Eat Bugs You Spider!) is a real-time generative audio collage engine. It separates uploaded music into stems, analyzes every transient slice, indexes them by spectral descriptor, and rebuilds the music live — driven by an AI personality (Cricket) running on a local LLM.

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Pipeline at a Glance](#2-pipeline-at-a-glance)
3. [Stage 1 — Ingestion](#3-stage-1--ingestion)
4. [Stage 2 — Analysis](#4-stage-2--analysis)
5. [Stage 3 — Index Building](#5-stage-3--index-building)
6. [Stage 4 — Playback Engine](#6-stage-4--playback-engine)
7. [Stage 5 — AI Brain (Cricket)](#7-stage-5--ai-brain-cricket)
8. [Stage 6 — Terminal UI (TUI)](#8-stage-6--terminal-ui-tui)
9. [Data Files Reference](#9-data-files-reference)
10. [Max Patch Infrastructure](#10-max-patch-infrastructure)
11. [System Services](#11-system-services)
12. [Quick Reference: Who Talks to Whom](#12-quick-reference-who-talks-to-whom)

---

## 1. System Overview

Three independent processes communicate over WebSocket on port 8080:

```
┌──────────────────────────────────┐
│  watch_demucs.py                 │  ← LaunchAgent daemon (always on)
│  Demucs + Essentia + madmom      │  ← Python analysis pipeline
│  import_library.py               │  ← SQLite sync (ebys.db)
└────────────┬─────────────────────┘
             │  stems → EBYS_INFRA/stems/htdemucs/
             │  JSON  → EBYS_INFRA/{genres,downbeats}.json
             │  DB    → EBYS_INFRA/ebys.db
             │  POST  → :8080/progress
             ▼
┌──────────────────────────────────┐        WebSocket :8080
│  ebys-analyze.maxpat  (Max/MSP)  │ ◄─────────────────────► TUI (sdj-tui.js)
│  ├─ ws_server.js   (N4M Node)    │  ← bridge: Max ↔ WebSocket + t-SNE
│  ├─ slicer.js                    │  ← sequencing brain
│  ├─ buffer_manager.js            │  ← disk → src → ring buffer chain
│  ├─ slot_router.js               │  ← sole owner of karma~/pfft~ messages
│  ├─ ms_router.js                 │  ← M/S stereo + FX routing
│  ├─ analyze_reader.js            │  ← FluCoMa buffer reader
│  └─ slice_writer.js              │  ← persists analysis dict to JSON
└──────────────────────────────────┘
```

---

## 2. Pipeline at a Glance

```
Drop audio file into raw_uploads/
        │
        ▼
[watch_demucs.py]                       Stage 1 — Ingestion
  Demucs (htdemucs): vocals/drums/bass/other
  genre_tagger.py: Discogs-EffNet → genres.json
  madmom_tagger.py: downbeat/BPM detection → downbeats.json
  → writes stream.txt  (stem paths for Max)
  → POSTs stemsReady to /progress
  → import_library.py: genres + downbeats → ebys.db
        │
        ▼
[ebys-analyze.maxpat]                   Stage 2 — FluCoMa Analysis
  streamWatcher.js polls stream.txt every 1s
  FluCoMa: onset slice → C/S/E/F/P/H/M0–M5 per slice
  analyze_reader.js → slice_writer.js → analysis_library.json (~1MB)
        │
        ▼
[add_tension.py]  (run after analysis)  Stage 2b — Tension Fields
  Sliding-window bar slope → tension_C/E/F/P/H/T per slice
  Writes back to analysis_library.json
  Syncs tension columns to ebys.db
        │
[add_stereo_features.py]  (optional)   Stage 2c — Stereo Fields
  Per-slice pan (from original mix) and width (M/S from stem)
  Writes back to analysis_library.json
        │
        ▼
[ws_server.js]                          Stage 3a — Index Prep
  prepareLibraryDict(): reads analysis_library.json (Node, no size limit)
  Sends library + genres to slicer.js via hardened chunk streams
  computeAndWriteUMAP():
    extract 6-D features per stem → stem_ranges.json
    spawn tsne_worker.js (child process, stdin/stdout) → umap_coords.json
  buildIndexInProgress guard prevents duplicate builds
        │
        ▼
[slicer.js]                             Stage 3b — Index Assembly
  Assembles chunks → buildIndex()
  Groups slices by stem/track, snaps starts to downbeat grid
  Saves index back → ws_server.js (saveIdxChunk) → ebys_index.json (~2.8MB)
        │
        ▼
[slicer.js]                             Stage 4 — Live Playback
  Index already in memory
  selectSegment(): weighted descriptor distance + match/dir probs
  outlet 0 → buffer_manager.js → slot_router.js → karma~
        │
        ▼
[sdj-tui.js]                            Stage 5 — Control Surface
  Live descriptor display, BPM, LUFS, slice position, tension arrows
  Commands: :bars 2  :pitchShift melody 3  :bake
  Cricket (Ollama LLM): natural language → engine commands
```

---

## 3. Stage 1 — Ingestion

### `watch_demucs.py`
**Location:** `EBYS_INFRA/watch_demucs.py` | **Type:** Python daemon (LaunchAgent)

Entry point for all new audio. Uses `watchdog` to monitor `raw_uploads/`. On new file:

1. Runs Demucs (`htdemucs`) → 4 stems in `stems/htdemucs/<Track>/` named `<Track>_vocals.wav` etc.
2. Runs `genre_tagger.py` on the original mix
3. Runs `madmom_tagger.py` on the original mix
4. POSTs `pipelineStage` progress events to `/progress` → TUI receives them via WebSocket
5. Writes `stream.txt` with all stem paths → triggers FluCoMa analysis in Max
6. POSTs `stemsReady` to `/progress`
7. Calls `_run_import_library()` → imports updated genres + downbeats into `ebys.db`

At startup: runs `analyze_missing_tracks()` (genres + madmom on any existing stems not yet processed) and `_run_import_library()` to populate `ebys.db` from existing JSON.

Uses two separate Python environments: `demucs_env/` (Python 3.14, torch) for Demucs; system Python 3.10/3.11 (essentia + madmom) for analysis — the two are version-incompatible.

### `genre_tagger.py`
**Location:** `EBYS_INFRA/genre_tagger.py`

Classifies genre using Essentia + Discogs-EffNet (400 classes). Always runs on the original mix, never on stems — the model needs harmonic/rhythmic context. Writes top-N genres + confidence to `genres.json`.

### `madmom_tagger.py`
**Location:** `EBYS_INFRA/madmom_tagger.py`

Uses madmom's `DBNDownBeatTrackingProcessor` on the original mix:
- Time signature (meter 2/3/4), BPM, average bar duration
- Downbeat timestamps in ms (bar 1 of each bar), confidence score

Output → `downbeats.json`. `slicer.js` uses this to snap segment starts to the nearest bar boundary. Requires Python ≤ 3.11.

### `import_library.py`
**Location:** `EBYS_INFRA/import_library.py`

Imports all EBYS JSON files into `ebys.db` (SQLite). Schema:

```
tracks    (id, name, bpm, bpm_confidence, key, meter, stem_dur_ms)
slices    (id, track_id, stem, slice_key, time_frac, C,S,E,F,P,H,T, M0–M5,
           tension_C/E/F/P/H/T, pan, width)
genres    (track_id, rank, genre, confidence)
downbeats (track_id, bar_num, timestamp_ms)
```

All writes are idempotent (`INSERT ... ON CONFLICT DO UPDATE`). WAL mode enabled.

```bash
python3 import_library.py              # full import
python3 import_library.py --track "My Track"
python3 import_library.py --status    # print row counts
```

Called automatically by `watch_demucs.py` after each pipeline run and at startup. Also called by `add_tension.py` via `sync_tension()`. SQLite stays Python-only for now — `slice_writer.js` runs inside Max's JS engine which has no SQLite bindings.

### Utility Scripts

| Script | Role |
|---|---|
| `send_to_max.py` | Legacy: polls `stems/htdemucs/` every 500ms, writes `stream.txt`. Superseded by `watch_demucs.py` but the stream.txt mechanism is still used. |
| `rename_stems.py` | Migration utility: `drums.wav` → `<SongFolder>_drums.wav`. One-shot, only needed for old flat naming. |
| `scan_stems.py` / `debug_stems.py` | Diagnostics: list all stems in `htdemucs/` as JSON or pretty-print. |
| `extract_labels.py` | Extracts 400 genre class names from Essentia `.pb` model files. Run once during setup. |
| `ai_edit_file.py` / `ai_readme.py` | Dev tools using local Ollama. Not part of the EBYS runtime. |

---

## 4. Stage 2 — Analysis

### `ebys-analyze.maxpat`
**Location:** `EBYS_INFRA/MAX/ebys-analyze.maxpat` | **Type:** Main Max/MSP patch

Contains all wiring between JS objects, FluCoMa, buffers, and audio engine:
- **FluCoMa chain**: `fluid.bufonsetslice~` → `fluid.bufstats~` → `fluid.bufpitch~` → `fluid.bufmfcc~` → `fluid.bufchroma~`
- **Buffers**: `src_0/1_*` (full-length source files), `ring_0/1_*` (short segment copies), `snap_*` (bake snapshots)
- **Audio engine**: `karma~` per stem (variable-speed looping), `pfft~`/`gizmo~` (pitch shift per stem)
- **Node objects**: `node.script ws_server.js`, `node.script cricket.js`

### `ebys-pitch.maxpat`
**Location:** `EBYS_INFRA/MAX/ebys-pitch.maxpat`

Encapsulated `pfft~` sub-patch used as a bpatcher. `fftin~` → `gizmo~` → `fftout~`. `in 2` receives pitch ratio from `slot_router.js`.

### `streamWatcher.js`
**Location:** `EBYS_INFRA/MAX/streamWatcher.js` | **Type:** Max JS object

Polls `stream.txt` every 1s. On change, bangs outlet 0 → triggers the analysis counter → `analyze_reader.js` starts FluCoMa on the next batch of stems.

### `analyze_reader.js`
**Location:** `EBYS_INFRA/MAX/analyze_reader.js` | **Type:** Max JS object

Reads FluCoMa `buf~` output after each stem finishes. Iterates analysis frames (one per onset slice), extracts C/S/E/F/P/H/M0–M5, sends to `slice_writer.js`. Manages the multi-track loop: 4 stems per batch, advances a Max counter to trigger FluCoMa on the next stem. Loads `analysis_library.json` into `analysisLib` dict at startup so already-analyzed tracks skip re-analysis.

### `slice_writer.js`
**Location:** `EBYS_INFRA/MAX/slice_writer.js` | **Type:** Max JS object

Receives per-slice descriptors from `analyze_reader.js`, writes into the `analysisLib` Max dict. Handles:
- **Key detection**: Krumhansl-Schmuckler on accumulated pitch values → `metadata::key`
- **BPM/confidence metadata** per stem
- **Deduplication**: `trackExists` check before re-analyzing
- **Persistence**: writes `analysis_library.json` after each track completes

Runs inside Max's SpiderMonkey JS engine — cannot use Node.js APIs or SQLite.

### `add_tension.py`
**Location:** `EBYS_INFRA/add_tension.py` | **Type:** Offline post-processor

Adds `tension_C/E/F/P/H/T` to every slice in `analysis_library.json`:
1. Assign each slice to a bar via `downbeats.json`
2. Average all descriptors per bar
3. Sliding-window slope across bars (default window = 4 bars)
4. Normalize slopes to [0, 1]
5. Write back to `analysis_library.json`
6. Call `sync_tension()` from `import_library.py` to update only the tension columns in `ebys.db`

```bash
python3 add_tension.py                 # all tracks
python3 add_tension.py "My Track"     # one track
python3 add_tension.py --window 6     # wider smoothing window
```

### `add_stereo_features.py`
**Location:** `EBYS_INFRA/add_stereo_features.py` | **Type:** Offline post-processor

Computes per-slice `pan` and `width` and writes them back to `analysis_library.json`. Run after `add_tension.py` whenever new tracks are added.

**WIDTH** — computed from the Demucs stem file using M/S analysis: `rms_S / rms_M` per slice window. Raw values are min-max normalized within each stem to `[0.05, 0.90]`, preserving relative variation even though Demucs stems are near-mono (raw M/S ratio typically 0.025–0.341).

**PAN** — computed from the original stereo mix file (not the stem) using L-R energy balance: `(pwr_R − pwr_L) / (pwr_R + pwr_L)`, scaled by `PAN_SCALE=0.6`. Using the mix captures the producer's actual stereo intent. Falls back to the stem if the mix file is missing.

```bash
python3 add_stereo_features.py              # all tracks
python3 add_stereo_features.py "DREPTO"    # partial name filter
python3 add_stereo_features.py --stems-only # pan from stems (no mix lookup)
```

Requires: `numpy` (uses stdlib `wave` for I/O).

---

## 5. Stage 3 — Index Building

### `ws_server.js`
**Location:** `EBYS_INFRA/MAX/ws_server.js` | **Type:** N4M Node.js object (`node.script ws_server.js`)

The central nervous system. Bridges Max ↔ TUI (WebSocket :8080) and owns index building.

**Boot sequence**: on startup sends `downbeats.json` and the cached `ebys_index.json` to `slicer.js` as hardened chunk streams. If `analysis_library.json` is non-empty, sets `analysisDone = true` so new TUI clients know analysis is complete.

**buildIndex flow** (triggered by TUI command):
1. `buildIndexInProgress` guard prevents duplicate runs
2. `prepareLibraryDict()`: reads `analysis_library.json` via Node (no 32KB limit), caches in memory
3. Sends library (stream 3) + genres (stream 4) to slicer.js in 2KB chunks
4. After 500ms (FluCoMa settle time), calls `computeAndWriteUMAP()`

**computeAndWriteUMAP()**:
1. Extracts C/E/F/P/H/T feature vectors per slice per stem from cached library
2. Writes `stem_ranges.json` (descriptor min/max, used for TUI bar scaling)
3. Spawns `tsne_worker.js` as a child process via `spawn()` — communicates over stdin/stdout JSON to avoid N4M's IPC interception
4. On child exit: parses stdout JSON → writes `umap_coords.json`, broadcasts `umapDone`

**HTTP endpoint**: `POST /progress` — `watch_demucs.py` sends pipeline stage events here; ws_server broadcasts them to all TUI clients.

**Chunk stream protocol**: all chunk sends carry a `streamId` (global counter, increments per send):
```
label  streamId  chunkIndex  total  data
```
Receivers reset and warn on stream ID change, and skip duplicate chunk indexes. Prevents silent corruption when two sends interleave — critical at 50+ tracks where `ebys_index.json` requires ~11,500 chunks.

**Chunk streams sent** (all via Max outlet):
- `downbeatchunk` → slicer.js at boot
- `idxchunk` → slicer.js at boot (cached index)
- `libchunk` → slicer.js on buildIndex
- `genrechunk` → slicer.js on buildIndex

**saveIdxChunk handler**: receives `ebys_index.json` back from slicer.js in 2KB chunks, reassembles, writes to disk.

### `tsne_worker.js`
**Location:** `EBYS_INFRA/MAX/tsne_worker.js` | **Type:** Node.js child process (spawned by ws_server.js)

Runs t-SNE in a separate process so the ~5s computation doesn't block the event loop (which would drop WebSocket connections → duplicate buildIndex).

**IPC via stdin/stdout** (not fork/IPC): N4M is itself a child process of Max and uses `process.send()` / `process.on('message')` for its own IPC. Using `child_process.fork()` causes N4M to intercept and corrupt the IPC channel. `spawn()` with stdio pipes is invisible to N4M.

Receives `{ stems: [{ stem, ids, features, nIter }] }` as JSON on stdin. Runs full t-SNE per stem: perplexity-based bandwidth search, symmetrized P matrix, gradient descent with momentum and adaptive gains. Writes `{ [stem]: { coords: { [sliceId]: [x, y] }, ms } }` to stdout via `process.stdout.end()` (not `write()` + `exit()` — large JSON >64KB would be truncated if the process exits before the pipe drains).

### `slicer.js`
**Location:** `EBYS_INFRA/MAX/slicer.js` | **Type:** Max JS object — the sequencing brain

Owns all musical decisions. No DSP access.

**Chunk accumulation**: receives `libchunk`, `genrechunk`, `downbeatchunk`, `idxchunk` streams from ws_server. Each accumulator tracks `streamId` — resets with a warning log on stream change, ignores duplicate chunk indexes. `buildIndex` is deferred if chunks are still arriving.

**buildIndex()**: parses library, groups slices by stem and source track, computes end-descriptors and delta values per slice, snaps candidate starts to downbeat grid. Writes result back to ws_server via `saveIdxChunk` stream.

**selectSegment(track)**: builds a candidate pool of bar-aligned slices, then either stays on the same segment (STAY_PROB), scores all candidates by `scoreCandidate()` (transition match + directional preference), or picks randomly.

Emits outlet 0: `track  slot  startFrac  endFrac  stretchRatio  segDurMs`

**Parameters** (from TUI via ws_server → Max route → slicer inlet 0):
`setSegmentBars`, `setStayProb`, `setQuantize`, `setMatchProb`, `setDirPref`, `setDirWeight`, `setGlobalBPM`, `setFallbackBPM`, `setGenreFilter`, `setKeyFilter`, `setWeight`, `loop`, `unloop`, `followStem`, `start`, `stop`, `next`, `buildIndex`, `reset`

**Genre filtering**: once the index is built, every slice carries a `genres` array. Filter at any time:
```
setGenreFilter Techno      # only slices tagged Techno (substring, case-insensitive)
clearGenreFilter           # back to all tracks
listGenres                 # print available genres to Max console
```
If the filter matches nothing for a stem, slicer falls back to all slices for that stem so playback never stops.

**Telemetry** (outlet 1 → ws_server → TUI): `desc` (C/S/E/F/P/H/T + tension), `seg` (slice id, duration, startFrac/endFrac), `stemTrack`, `slice_ms`, `slices` (pool sizes).

---

## 6. Stage 4 — Playback Engine

### `buffer_manager.js`
**Location:** `EBYS_INFRA/MAX/buffer_manager.js` | **Type:** Max JS object

Two-level buffer architecture for zero-glitch multi-track playback:

**Level 1 — src buffers** (`src_0/1_voc/drm/bss/mel`, 8 total): full-length WAV files loaded from disk. Two slots per stem enable switching tracks without re-reading.

**Level 2 — ring buffers** (`ring_0/1_voc/drm/bss/mel`, 8 total): short pre-allocated buffers. `fluid.bufcompose~` copies the exact segment from src into a ring buffer in ~1ms (much faster than disk reads).

**Flow**: `track  slot  startFrac  endFrac  stretchRatio  segDurMs` → load src if needed → `triggerCompose()` → `fluid.bufcompose~` copies segment → `ring_done` callback → swap active/staging → send `track  ringSlot  segDurMs  stretchRatio` to `slot_router.js`.

**Bake snapshot**: `bakeSnapshot()` copies `ring_active → snap_*` for all stems. `bakeRestore()` copies back. Every training loop iteration starts from identical audio.

### `bake_manager.js`
**Location:** `EBYS_INFRA/MAX/bake_manager.js` | **Type:** Max JS object

Handles the `:bake` training snapshot system. `bakeSnapshot()` copies all ring buffers to snap buffers at `:bake` start. `bakeRestore()` copies back at every loop reset. Guarantees every training iteration starts from identical audio — the model only sees the effect of command changes, not audio drift.

### `slot_router.js`
**Location:** `EBYS_INFRA/MAX/slot_router.js` | **Type:** Max JS object — audio engine hub

The only object that sends messages to `karma~` and `pfft~`/`gizmo~`. Two independent axes:

**Tempo axis** (via karma~): `speedFactor = 1/stretchRatio` → `karma~` right inlet. When `GLOBAL_BPM` is set, slicer computes `stretchRatio = srcBPM / globalBPM`; slot_router converts to speed. Pitch follows speed (tape-style stretch).

**Pitch axis** (via pfft~/gizmo~): `setPitch stem ratio` or `setPitchSemitones stem n` → frequency ratio to `pfft~`/`gizmo~`. Pitch shift is independent of tempo — gizmo~ acts on FFT frames without changing duration.

### `ms_router.js`
**Location:** `EBYS_INFRA/MAX/ms_router.js` | **Type:** Max JS object

Routes M/S stereo and FX send/return parameters from the TUI to Max `receive` objects. Wired in parallel to `ws_server.js` outlet 0 — it sees every TUI command and handles only those it owns.

**M/S stereo per stem**: `width <stem> <0–1>` and `pan <stem> <-1–+1>` compute equal-power pan gains (`L=cos((pan+1)π/4)`, `R=sin((pan+1)π/4)`) and send `width_<stem>`, `panL_<stem>`, `panR_<stem>` to the patch.

**FX routing**: `fxSend`, `fxReturn`, and `fxStereo` drive the hardware pedal send/return chain and the mono/stereo selector.

**Analysis-driven mode** (`analysisDriven=true` default): `stemMS track pan width` messages from `slicer.js` automatically update each stem's pan and width per slice, following the per-slice values from `add_stereo_features.py`. `:analysisMode off` switches to fully manual TUI control.

| Command | Effect |
|---|---|
| `:width <stem\|all> <0–1>` | M/S stereo width (0=mono, 1=full wide) |
| `:pan <stem\|all> <-1–+1>` | Stereo pan position (-1=left, 0=center, +1=right) |
| `:fxSend <0–1>` | Send level to hardware pedal; also drives dry crossfade (insert model) |
| `:fxReturn <0–1>` | Return level from hardware pedal into main mix |
| `:fxStereo 0\|1` | 0=mono pedal chain, 1=stereo (L on 3, R on 4) |
| `:analysisMode on\|off` | Toggle analysis-driven auto pan/width vs manual control |

---

## 7. Stage 5 — AI Brain (Cricket)

### `cricket.js`
**Location:** `EBYS_INFRA/MAX/cricket.js` | **Type:** N4M Node.js object

Bridges Max to a local Ollama LLM (`llama3.1:latest` by default). Receives `ask <text>` from Max, POSTs to Ollama `/api/chat` with a system prompt encoding Cricket's personality, descriptor meanings, command vocabulary, and translation examples (e.g., "sparse → setSegmentBars 8, setStayProb 0.5"). Parses the response: command lines → Max outlet 0 → route → parameter handlers; prose lines → TUI display.

### `TUI/cricket-voice.js`
**Location:** `EBYS_INFRA/TUI/cricket-voice.js` | **Type:** Standalone Node.js script

Training session tool for building Cricket's voice. Everything you type is saved to `voice_samples.md`. Commands: `:bake` distills samples into `voice.md`, `:rule "..."` adds a behavioral rule, `:bakefranglais` bakes Q&A examples into an Ollama Modelfile. Not used during live performance.

### `TUI/test-ollama.js`
**Location:** `EBYS_INFRA/TUI/test-ollama.js` | **Type:** Standalone Node.js diagnostic

Quick Ollama connectivity test. Lists available models, sends a test message, prints which model string to use in `sdj-tui.js`.

### `convert_bakes.py`
**Location:** `EBYS_INFRA/convert_bakes.py`

Converts `training_log.jsonl` (raw `:bake` snapshots: intent + Cricket cmds + user corrections + live descriptor state) into `cricket_finetune.jsonl` (MLX/Llama instruction-response format). Each bake becomes one training example.

### `finetune.sh`
**Location:** `EBYS_INFRA/finetune.sh`

LoRA fine-tune on Apple Silicon via `mlx-lm` (batch=1, 8 layers, 600 iters). Requires 200+ bakes. Produces Cricket model tuned to your specific library and taste. Runs offline, no data leaves the machine. Takes 1–3 hours.

### Training Loop

```
User instruction ("make it darker")
        │
        ▼
  Cricket (Ollama LLM)        interprets intent → outputs engine commands
        │
        ▼
  User listens → corrects     sends additional commands manually if needed
        │
        ▼
  :bake                       TUI command — writes a training snapshot
        │
        ▼
  training_log.jsonl          one line per bake:
                                intent, cricket_cmds, user_corrections,
                                final_cmds, live descriptor state,
                                track name, BPM at bake time
```

After 200–500 bakes: `convert_bakes.py` → `finetune.sh` → fine-tuned local Cricket. The correction delta between `cricket_cmds` and `final_cmds` is the training signal.

---

## 8. Stage 6 — Terminal UI (TUI)

### `TUI/sdj-tui.js`
**Location:** `EBYS_INFRA/TUI/sdj-tui.js` | **Type:** Standalone Node.js app
**Dependencies:** `blessed` (terminal layout), `ws` (WebSocket client)

Terminal dashboard: live C/S/E/F/P/H/T per stem with tension direction arrows (↑─↓), slice position bar, segment zone, BPM, key, LUFS/dBFS, genre label, novelty sparkline per stem.

Connects to ws_server :8080. On connect: sends `buildIndex` if `analysisDone` flag is set. Auto-reconnects every 3s.

Command input is parsed locally: recognized commands (`:bars`, `:pitchShift`, `:loop`, etc.) are sent directly as WebSocket messages. Unrecognized input goes to Cricket (Ollama) which responds with prose + engine commands.

---

## 9. Data Files Reference

### `analysis_library.json`
**Location:** `MAX/` | **Size:** ~1MB | **Written by:** `slice_writer.js` | **Read by:** `ws_server.js`

Raw FluCoMa output. One top-level key per stem file:
```json
{
  "TrackName_vocals.wav": {
    "vocals": {
      "metadata": { "BPM": 128, "BPM_confidence": 0.91, "key": "Am", "stemDurMs": 139020 },
      "slices": {
        "slice_0001": { "time": 0.023, "C": 2300, "E": -24.1, "F": 0.42,
                        "P": 440, "H": 0.7, "M0": 12.1, "M5": 3.2,
                        "tension_C": 0.71, "tension_E": 0.45,
                        "pan": 0.12, "width": 0.73 }
      }
    }
  }
}
```

### `ebys_index.json`
**Location:** `MAX/` | **Size:** ~2.8MB | **Written by:** `ws_server.js` (reassembled from slicer saveIdxChunk)

Pre-built slice database: `{ meta, byTrack, ranges }`. `byTrack[stem]` is a flat array of fully hydrated slice objects (with slot, sourceTrack, dur, endC/E/F/P/H/T, deltaC/E/F/P/H/T, genres, tension_*). Cached on disk so slicer.js has it immediately at boot without a full rebuild.

### `ebys.db`
**Location:** `EBYS_INFRA/` | **Written by:** `import_library.py`, `add_tension.py`

SQLite database — the canonical queryable store. WAL mode, foreign keys on. Tables: `tracks`, `slices` (full descriptor + tension + pan/width columns), `genres`, `downbeats`. Populated incrementally by `watch_demucs.py`. Tension columns updated independently by `add_tension.py` via `sync_tension()`. Primary path for PD migration — PD will read from here instead of the JSON chain.

### `downbeats.json`
**Location:** `EBYS_INFRA/` | **Written by:** `madmom_tagger.py` | **Read by:** `ws_server.js` → slicer.js

Per track: `{ bpm, meter, avgBarMs, downbeats_ms: [...], confidence }`. Keyed by source track name (not stem filename). Confidence < 0.4 → slicer falls back to BPM grid instead of actual downbeat timestamps.

### `genres.json`
**Location:** `EBYS_INFRA/` | **Written by:** `genre_tagger.py` | **Read by:** `ws_server.js`, `sdj-tui.js`

Per track: top-N genre strings + confidence from Discogs-EffNet 400-class model. Keyed by track name without extension.

### `umap_coords.json`
**Location:** `MAX/` | **Written by:** `ws_server.js` (from tsne_worker stdout) | **Read by:** TUI

2D t-SNE coordinates per stem per slice (`{ stem: { sliceId: [x, y] } }`). Used by TUI spatial navigator — similar-sounding slices cluster together visually.

### `stem_ranges.json`
**Location:** `MAX/` | **Written by:** `ws_server.js` | **Read by:** TUI

Descriptor min/max per stem (`{ stem: { C: { min, max }, E: { min, max }, ... } }`). Used for descriptor bar scaling in the TUI.

### `training_log.jsonl`
**Location:** `EBYS_INFRA/` | **Written by:** `ws_server.js` on `:bake`

Append-only JSONL. One JSON object per bake: `{ timestamp, intent, cricket_cmds, user_corrections, final_cmds, track, bpm, stems }`. The correction delta between `cricket_cmds` and `final_cmds` is the training signal.

### `stream.txt`
**Location:** `EBYS_INFRA/` | **Written by:** `watch_demucs.py` | **Read by:** `streamWatcher.js`

Flat list of all current stem paths. Written after genre + madmom complete so FluCoMa starts with all metadata on disk. `streamWatcher.js` polls every 1s and bangs the analysis counter when content changes.

---

## 10. Max Patch Infrastructure

### Master Bus + FX + M/S Architecture

```
karma~ → pfft~/gizmo~ → *~0.7 (per-stem gain)
                         │
              ┌──────────┴─────────────────────┐
              │ PRE-M/S tap (mono)              │ POST-M/S path
              │ mono sum of 4 *~0.7 outputs     │ Haas delay → M/S encode
              │ → *~ fxSend gain                │ → equal-power pan *~
              │ → selector~ (mono|stereo)        │ → +~ stereo sum (L, R)
              │ → dac~ 3 4 (→ hardware pedal)   │ → *~(1−fxSend) dry crossfade
              │                                  │ → +~ final sum L/R
              │ adc~ 3 → L return               │     ↑ + *~ fxReturn (from adc~)
              │ selector~(adc~3|adc~4) → R ret  │
              └──────────────────────────────────┘
                                                 → dac~ 1 2 (speakers)
```

**Key design decisions:**
- **Pre-M/S FX tap** — pedals are fed from the mono mix before M/S encoding, so mono hardware pedals work cleanly regardless of stereo field
- **Insert model** — at 100% fxSend, the dry signal is fully muted (`*~(1−fxSend)` = 0). Only the pedal return is heard. Not a parallel send
- **Mono/stereo switch** — `:fxStereo 0` sends the mono sum on both `dac~ 3/4`; return from `adc~ 3` only. `:fxStereo 1` sends L/R post-M/S; `adc~ 3/4` are individual mono channels

| Channel | Direction | Role |
|---|---|---|
| dac~ 1 | out | Speaker L |
| dac~ 2 | out | Speaker R |
| dac~ 3 | out | Pedal send L (or mono sum) |
| dac~ 4 | out | Pedal send R (or mirrors 3 in mono mode) |
| adc~ 3 | in | Pedal return L (always) |
| adc~ 4 | in | Pedal return R (stereo mode only) |

### Patch Evolution Scripts (`patch_*.py`)

Python scripts that directly edit `ebys-analyze.maxpat` (JSON) without touching the Max GUI. Each creates a `.bak` before modifying.

| Script | What it did |
|---|---|
| `patch_multitrack_upgrade.py` | `play_*` → `play_0_*`, added slot 1 buffers, wired slot_router.js |
| `patch_ring_buffer_upgrade.py` | `play_0/1_*` → `src_0/1_*`, added `ring_0/1_*` buffers, replaced track_loader with buffer_manager |
| `patch_cleanup.py` | Removed 25 dead objects from the multitrack upgrade |
| `patch_tighten2/3/4.py` | UI layout passes |
| `patch_bake_snapshot.py` | Added snap_* buffers and bake_manager.js wiring |

### Deprecated / Legacy JS Objects

| Object | Status | Notes |
|---|---|---|
| `stretch_player.js` | superseded | Earlier `fluid.bufstretch~` approach; replaced by ring buffer + karma~ |
| `track_loader.js` | superseded | Replaced by `buffer_manager.js` |
| `asset_id.js` | legacy | Stable ID generation from early architecture; mostly retired |
| `bpm_from_tempogram.js` | deprecated | `fluid.buftempogram~` doesn't exist in FluCoMa; BPM from madmom now |
| `stems.js` | stub | `post("JS OBJECT WORKS\n")` only — placeholder |
| `folder_scanner.js` | utility | Scans a flat folder for audio files (wav/aif/mp3), outputs filenames |
| `scanner.js` | utility | Recursive version of folder_scanner.js, outputs full paths |
| `classifier.js` | legacy | Routes stems to drums/instruments outlet by filename pattern |

### Archive / BAK Files

| File | State captured |
|---|---|
| `EBYS_ANALYZE.maxpat.bak` | Generic most-recent backup |
| `EBYS_ANALYZE.maxpat.pre_multitrack.bak` | Before multi-track upgrade |
| `EBYS_ANALYZE.maxpat.pre_ringbuf.bak` | Before ring buffer upgrade |
| `ebys-analyze.maxpat.pre_bake_snapshot.bak` | Before bake snapshot wiring |
| `ebys-analyze.maxpat.pre_cleanup.bak` | Before dead object cleanup |
| `ebys-analyze.maxpat.pre_tighten2/3/4.bak` | Before each UI tightening pass |

---

## 11. System Services

### `com.ebys.watchdemucs.plist`
**Location:** `EBYS_INFRA/`

macOS LaunchAgent. Starts `watch_demucs.py` at login, restarts on crash. Logs to `EBYS_INFRA/logs/watchdemucs.log`.

```bash
cp com.ebys.watchdemucs.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.ebys.watchdemucs.plist
```

### Python Environments

| Environment | Python | Has | Used for |
|---|---|---|---|
| `demucs_env/` | 3.14 | torch, demucs | Stem separation |
| system / brew | 3.10–3.11 | essentia, madmom | Genre + downbeat analysis, import_library |

madmom requires Python ≤ 3.11. essentia requires Python ≤ 3.12. Incompatible with torch's Python 3.14 requirement — hence the split environments.

### Pure Data Migration Note

The 2KB chunk protocol exists solely because Max's JS engine has a 32KB file read limit and no SQLite bindings. On PD migration:
- `stream.txt` polling → filesystem watch or OSC
- 2KB chunk protocol → disappears (PD loads files natively)
- `ws_server.js` t-SNE + chunk machinery → replaced by Python scripts
- `ebys.db` becomes the primary data source — already populated by the existing Python pipeline

---

## 12. Quick Reference: Who Talks to Whom

```
watch_demucs.py
  → writes:  stems/htdemucs/<Track>/<Track>_*.wav
  → writes:  EBYS_INFRA/genres.json
  → writes:  EBYS_INFRA/downbeats.json
  → writes:  EBYS_INFRA/stream.txt
  → runs:    import_library.py  → EBYS_INFRA/ebys.db
  → POSTs:   /progress  { pipelineStage, stemsReady }

streamWatcher.js
  → polls:   stream.txt every 1s
  → bangs:   Max counter → analyze_reader.js

analyze_reader.js
  → reads:   FluCoMa buf~ objects in Max
  → sends:   descriptors → slice_writer.js

slice_writer.js
  → writes:  dict analysisLib (Max)
  → writes:  MAX/analysis_library.json

add_tension.py
  → reads:   MAX/analysis_library.json + EBYS_INFRA/downbeats.json
  → writes:  MAX/analysis_library.json  (tension_* fields)
  → updates: EBYS_INFRA/ebys.db  (tension columns only)

add_stereo_features.py
  → reads:   MAX/analysis_library.json + original mix files
  → writes:  MAX/analysis_library.json  (pan, width fields)

ws_server.js
  → reads:   MAX/analysis_library.json
  → reads:   EBYS_INFRA/downbeats.json + genres.json
  → reads:   MAX/ebys_index.json  (cached, sent to slicer at boot)
  → spawns:  tsne_worker.js  (stdin/stdout JSON)
  → writes:  MAX/umap_coords.json
  → writes:  MAX/stem_ranges.json
  → writes:  MAX/ebys_index.json  (reassembled from saveIdxChunk)
  → outlet:  downbeatchunk → slicer.js
  → outlet:  idxchunk → slicer.js
  → outlet:  libchunk → slicer.js      (on buildIndex)
  → outlet:  genrechunk → slicer.js    (on buildIndex)
  → WS:      broadcast to sdj-tui.js

slicer.js
  → receives: libchunk / genrechunk / downbeatchunk / idxchunk
  → outlet 0: track slot startFrac endFrac stretchRatio segDurMs → buffer_manager.js
  → outlet 1: desc / seg / stemTrack / slices → ws_server → TUI
  → outlet 1: saveIdxChunk (sid, i, total, data) → ws_server → ebys_index.json

buffer_manager.js
  → reads:    src_N_* buffer~ (disk WAV)
  → triggers: fluid.bufcompose~ (src → ring segment copy)
  → sends:    track ringSlot segDurMs stretchRatio → slot_router.js

slot_router.js
  → sends:    "set ring_N_stem" + "seek 0" → karma~
  → sends:    speedFactor → karma~ right inlet  (tempo axis)
  → sends:    pitch ratio → pfft~/gizmo~         (pitch axis, independent)

ms_router.js
  → reads:    TUI commands (width, pan, fxSend, fxReturn, fxStereo, analysisMode)
  → reads:    stemMS messages from slicer.js  (analysis-driven auto pan/width)
  → sends:    width_<stem>, panL_<stem>, panR_<stem>, fxsend1, fxreturn1, fxstereo → Max receive~

cricket.js
  → receives: ask <text> from Max
  → POSTs:    Ollama /api/chat (localhost:11434)
  → outlet 0: engine commands → Max route → parameter handlers

sdj-tui.js
  → WS connects to ws_server :8080
  → sends:    buildIndex, start, stop, setSegmentBars, setMatchProb,
              setDirPref, setGlobalBPM, pitchShift, loop, :bake
  → receives: desc, seg, meter, state, slices, pipelineStage,
              stemsReady, analysisDone, umapDone
```
