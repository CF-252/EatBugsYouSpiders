# EBYS Changelog

EBYS — Eat Bugs You Spider
Generative audio collage engine. Separates songs into stems, analyzes every transient slice, and plays them back in real time using spectral descriptors.

---

## 0.1.8 — 2026-07-02

### Repository restructure — portable, cloneable package

#### Folder layout
- `EBYS_INFRA/` split into `src/` with explicit subfolders: `max/` (Max JS + .maxpat), `demucs/` (Python pipeline), `tui/` (Cricket TUI)
- `Tipping_protocol/backend/` → `src/backend/`; `Tipping_protocol/frontend/` → `src/frontend/`
- All runtime data (stems, raw_uploads, temp, logs, recordings) moved to `data/` at repo root — fully gitignored
- `.bak` files moved to `src/max/archive/`

#### Path portability
- **Python** — all hardcoded `/Users/alexandregagne/Documents/EBYS/EBYS_INFRA/` paths replaced with `Path(__file__).parent`-based relative paths across `watch_demucs.py`, `scan_stems.py`, `send_to_max.py`, `import_library.py`
- **Max JS** — `getDataDir()` helper added to `streamWatcher.js`, `analyze_reader.js`, `track_loader.js`, `buffer_manager.js`, `clear_stems.js`; computes data path from `patcher.filepath` (strips `src/max/` → `src/` → repo root → `data/`). Works on any machine regardless of username or clone location
- **`slicer.js`** — `getInfraDir()` renamed `getDataDir()`, updated to navigate two levels up from `src/max/` to repo root then into `data/`; `downbeats.json` read path updated
- **`import_library.py`** — `analysis_library.json` path updated to `src/max/analysis_library.json`; `ebys.db`, `genres.json`, `downbeats.json` updated to `data/`
- **`cricket-voice.js`** — hardcoded Modelfile path in user-facing hint replaced with `path.join(__dirname, 'Modelfile')`

#### `setup.sh` (new)
- First-time install script: creates `data/` subdirs, creates `src/demucs/demucs_env/` Python venv, installs Demucs + watchdog, downloads Essentia genre models, runs `npm install` in `src/max/`, `src/tui/`, `src/backend/`, generates `com.ebys.watchdemucs.plist` with the current user's actual paths, installs it to `~/Library/LaunchAgents/` and loads the daemon
- Any contributor clones the repo, runs `bash setup.sh`, opens the patch — no manual path editing required

#### `.gitignore`
- Updated to cover new structure: `data/` (all runtime dirs), `src/demucs/demucs_env/`, `src/demucs/essentia_models/`, `src/max/` generated JSON files

#### Docs
- `docs/` reorganized into `docs/instrument/`, `docs/platform/`, `docs/protocol/`, `docs/business/`
- `docs/ARCHITECTURE.md` written — full system overview (instrument, backend, database, tipping protocol, split equation, Stripe, LINK, web radio, infrastructure, domain registrar, env vars, API reference)
- `docs/instrument/ARCHITECTURE.md` rewritten — instrument-only (Max/MSP + JS objects, FluCoMa pipeline, playback engine)
- All root `.md` files stubbed with redirect notices pointing to `docs/`

---

## 0.1.7 — 2026-06-23

### M/S Stereo + FX Send/Return Architecture

#### Max patch — master bus restructure (`ebys-analyze.maxpat`)
- **Single master bus** — removed per-stem `dac~ 1 2` (obj-712, 742, 772, 802). All four stems now sum into one stereo master via `+~` trees (obj-21000–21005). One `dac~ 1 2` (obj-21032) is the only speaker output.
- **FX send (pre-M/S, mono)** — mono sum of four `*~ 0.7` pre-M/S outputs (obj-21050–21052) feeds `*~ 0` send gain (obj-21053), controlled by `receive fxsend1` (obj-21054). Output on `dac~ 3 4` (obj-21055) → physical pedal input.
- **FX return** — `adc~ 3` (obj-21060) is the mono hardware return. `*~ 0` return gain (obj-21061) controlled by `receive fxreturn1` (obj-21062).
- **Dry/wet crossfade (insert model)** — `!- 1` (obj-21072) computes `(1 − fxSend)` applied to master L/R dry gains (obj-21070, 21071). At 100% send, dry is muted — only the pedal return is heard. This is the insert model, not the parallel/studio model.
- **Mono/stereo switchable pedal path** — `selector~ 2 1` objects (obj-21082, 21083) switch `dac~ 3/4` between: mono sum (fxStereo=0) or master L/R post-M/S (fxStereo=1). Return side: `selector~ 2 1` (obj-21092) selects between `adc~ 3` (mono) and `adc~ 4` (stereo R). `adc~ 3` always feeds L directly; the selector only controls R.
- **`receive fxstereo` + `+ 1`** — `receive fxstereo` (obj-21085) → `+ 1` (obj-21086) converts boolean 0/1 to 1/2 (selector~ is 1-indexed). `send fxstereo` (obj-21087) driven from route outlet 14.
- **Route extended** — obj-20101 `route` text extended with `fxstereo` as selector 15 (outlet 14).

#### Max patch — M/S label fix
- **6 mislabelled receive objects corrected** — drums column had melody labels and vice versa:
  - `receive width_melody` → `receive width_drums` (x≈829)
  - `receive panL_melody` → `receive panL_drums` (x≈698)
  - `receive panR_melody` → `receive panR_drums` (x≈829)
  - `receive width_drums` → `receive width_melody` (x≈1917)
  - `receive panL_drums` → `receive panL_melody` (x≈1783)
  - `receive panR_drums` → `receive panR_melody` (x≈1917)

#### New file: `ms_router.js`
- Routes TUI M/S and FX commands to Max `receive` objects via outlet 0 → route obj-20101 → send objects.
- **`width <stem> <0–1>`** — M/S stereo width per stem (0=mono, 1=full wide). Sends `width_<stem>` to patch.
- **`pan <stem> <-1–+1>`** — equal-power pan law (`L=cos((pan+1)π/4)`, `R=sin((pan+1)π/4)`). Sends `panL_<stem>` and `panR_<stem>`.
- **`fxSend <0–1>`** — send level; also drives `(1−fxSend)` dry crossfade in patch.
- **`fxReturn <0–1>`** — return level from hardware pedal.
- **`fxStereo 0|1`** — mono/stereo pedal chain switch. Sends `fxstereo` → patch selector~ objects.
- **`stemMS <track> <pan> <width>`** — called by slicer.js per-slice when `analysisDriven=true`; automatically updates pan/width from audio analysis.
- **`analysisMode on|off`** — toggles `analysisDriven`. Off = fully manual `:width` / `:pan` control.
- **`resend`** — re-pushes all current state to Max (useful after autowatch reload).
- **`anything()`** — catch-all suppresses "can't handle message" warnings (ms_router sees all ws_server outlet 0 messages in parallel).

#### `ws_server.js` — new M/S and FX command handlers
- `state.ms` object added: `{ width: {vocals,melody,bass,drums}, pan: {vocals,melody,bass,drums}, fxSend, fxReturn }`.
- New TUI commands: `:width <stem> <0–1>`, `:pan <stem> <-1–+1>`, `:fxSend <0–1>`, `:fxReturn <0–1>`, `:fxStereo 0|1`, `:analysisMode on|off`.
- `Max.addHandler('stemMS', ...)` — receives `stemMS track pan width` from slicer outlet 1; forwards to ms_router and broadcasts `{ type:'param', key:'stemMS', track, pan, width }` to TUI.

#### `slicer.js` — per-slice pan/width emission
- `buildIndex()` now reads `pan` and `width` from each slice dict (written by `add_stereo_features.py`). Defaults: `pan=0`, `width=0.5`.
- `selectSegment()` emits `outlet(1, "stemMS", track, startSlice.pan, startSlice.width)` after picking a start slice, in both the normal and loop paths.

#### New file: `add_stereo_features.py`
- Offline post-processor. Reads `analysis_library.json`, computes per-slice `pan` and `width` from audio, writes them back.
- **WIDTH** from stem M/S ratio: `rms_S / rms_M` per slice window, min-max normalized to `[0.05, 0.90]` within each stem. Demucs stems are near-mono (raw width 0.025–0.341); normalization preserves relative variation.
- **PAN** from original mix L-R energy balance: `(pwr_R − pwr_L) / (pwr_R + pwr_L)` at the same time window, scaled by `PAN_SCALE=0.6`. Follows the producer's stereo intent, not the near-mono stem signal.
- Falls back to stem for pan if original mix file not found. `--stems-only` flag forces stem-based pan.
- Usage: `python3 add_stereo_features.py` (all tracks) or `python3 add_stereo_features.py "DREPTO"` (filter).

#### Signal chain (complete)
```
karma~ → pfft~ → *~0.7 ──┬── mono sum → *~ fxSend → selector~ → dac~ 3 4 → pedal
                           │          (stereo alt: master L/R post-M/S → selector~)
               Haas→M/S→pan            adc~ 3 (L, direct) + selector~(adc~3|adc~4) → R
                           ↓
                  +~ sum (4 stems) → master L/R → *~(1−fxSend) [dry crossfade]
                                                     ↓
                                    +~ ← *~ fxReturn [FX return L/R]
                                                     ↓
                                                 dac~ 1 2
```

---

## 0.1.6 — 2026-06-23

### Meter flood fix (gate pattern)
- **Root cause confirmed** — "Node script not ready can't handle message meter" is fired by Max's C++ runtime before any JavaScript executes. `peakamp~ 4096` auto-fires at ~10.8 Hz per stem (~54 msg/s total) immediately on patch load; Node.js takes 1–3 s to init. No JS-side handler can prevent this.
- **Fix: patch-side gate** — added `gate 1` (obj-7013) in `ebys-analyze.maxpat` between the 5 prepend objects (obj-7008–7012) and node.script (obj-4030). Gate defaults closed (0). On patch load all meter messages are silently blocked.
- **Gate-open signal** — node.script outlet 0 → `sel ws_ready` (obj-7014) → bang on match → message `1` (obj-7015) → gate inlet 0. The `ws_ready` outlet call already existed in `ws_server.js` `server.listen` callback; no JS changes needed.
- **Dead handlers removed** — `ws_server.js`: removed no-op early `meter` handler (couldn't prevent C++ errors) and a duplicate `meter` handler silently overwritten by the active one.
- **3 missed direct wires caught** — initial gate edit only re-routed the 5 new prepend objects (obj-7008–7012). A pre-existing `prepend meter` (obj-5008), `prepend analysisDone` (obj-6002), and `prepend streamUpdated` (obj-9922) were still wired directly to node.script and causing the continued flood. All three now route through the same gate. Total: 8 message sources gated, 5 control-only sources (script start/stop/state, slicer.js outlet 1) left direct.

---

## 0.1.5 — 2026-06-22

### Defaults
- **`DEFAULTS.md` created** — documents all factory defaults with commands and notes
- **`STAY_PROB`** changed from `0.0` → `0.5` (coin-flip stay/move per stem)
- **`MATCH_PROB`** changed from `0.0` → `0.9` for all descriptors (strong spectral continuity: always picks the nearest neighbor, but never the same slice — variety comes from STAY_PROB moving between source tracks, not from randomizing the match)
- **`MAX_SLICES_PER_STEM`** changed from `0` (unlimited) → `200` (performance cap for large libraries)

### VU meters
- **`meter` flood fix** — Max was sending `meter` messages from a beat-detection metro before ws_server's Node script was ready; no handler existed so Max logged "can't handle message meter" thousands of times. Added a `meter` handler that silently discards 0-arg beat ticks and broadcasts 2-arg VU data (`meter <name> <level>`) as `{type:'vu'}` WebSocket messages
- **Per-stem VU bars** — new 12-char bar appended to the right of each stem's progress bar line. Green (below -12 dB), yellow (-12 to -3 dB), red (above -3 dB). Driven by `peakamp~` in Max via `meter <stem> <0–1>`. `barW` reduced by `VU_W + 1` (13 chars) to keep total width constant
- **Master VU bar** — `out: ████████████` shown in the EBYS header line, driven by `meter master <0–1>`
- **Max wiring done** — `ebys-analyze.maxpat`: 10 new objects (obj-7001–7005 peakamp~, obj-7008–7012 prepend). Taps: `*~0.7` outlet per stem (post-volume) and `+~` final sum outlet (master). 10 patchlines: audio→peakamp~, peakamp~→prepend, prepend→node.script.
- **`metro` + `loadbang` removed** — first wiring attempt incorrectly used `loadbang → metro 50 → peakamp~ inlet 1`. `peakamp~` has only one inlet (audio signal); inlet 1 does not accept message-rate bangs. Also, the metro started at patch open before `node.script` booted, causing the "Node script not ready can't handle message meter" flood. Both wiring error and flood fixed by removing metro/loadbang: `peakamp~ 4096` auto-outputs peak amplitude every 4096 samples (~93 ms) with no external trigger needed.
- **VU dot style** — `vuBar()` changed from `█/░` blocks to `●/○` dots (filled/empty circles). Color zones unchanged: green (0–-12 dB), yellow (-12–-3 dB), red (above -3 dB).

### Multi-track display + progress fixes
- **Track name fix** — `outlet(1, "stemTrack", track, cleanTrackName(track))` was passing the STEM TYPE ("vocals") to `cleanTrackName`, which reads `meta["vocals"].track_name` — the last track loaded during `buildIndex` (alphabetically last = DREPTO CE3o always). Fixed to `startSlice.sourceTrack` which is the name of the actually playing source track
- **Slice ID collision fix** — slice IDs from the analysis library are per-track integers (0, 1, 2…). Two different source tracks can both have slice id "0", making the TUI's new-slice check (`msg.id !== state.stems[name].id`) fail when switching tracks → `stemSliceStartTime` never resets → progress bar frozen at 0. Fixed by prefixing with source track: `startSlice.sourceTrack + ":" + startSlice.id`
- **`segDurMs` threading** — `ws_server.js` `melody/bass/drums` handlers were only capturing `(slot, startFrac)`, silently dropping `segDurMs`. TUI was recomputing from BPM, which gives wrong values when `state.beats.bpm` is stale or inaccurate. Now all 4 stem handlers capture the full 5-arg signature and store `segDurMs` in state. TUI `sliceBar()` uses `s.segDurMs` directly (BPM formula as fallback only)

### Max / slicer.js — stuck-loop fixes
- **`STAY_PROB` advance fix** — when STAY_PROB triggered, `startIdx` was reset to `lastIdx[track]` (exact same slice), causing infinite repetition. Fixed: now finds the earliest slice on the same source track whose `time >= lastEndFrac`. Falls back to any slice on that track if none found after. New tracking vars: `lastEndFrac` (end fraction of previous segment) and `lastSourceTrack` (source track name). Both reset in `reset()`
- **`MATCH_PROB` stays `0.9`** — high match picks the spectrally nearest neighbor but never the exact same slice. Variety comes from STAY_PROB (50% chance to move source track each cycle), not from lowering match strength.

### Max / slicer.js
- **`sourceNames is not defined` fix** — `start()` was iterating a local variable that only existed inside `buildIndex()`. Fixed by iterating `slotMap` (module-level `{ trackName → slot }` dict), sorted by slot value
- **Unequal segment duration fix (accumulated overshoot)** — `snapSegDurMs` was rounding the *accumulated* slice duration to the nearest bar, causing overshoot when a single long slice (e.g. 15 s bass) made the segment snap to 8 bars (16 000 ms) instead of the target 4 bars (8 000 ms). Fixed by using `SEGMENT_BARS[track] * barMs` exactly as the timer value
- **Unequal segment duration fix (cross-track BPM)** — when different stems chose source tracks with different analyzed BPMs, per-track `barMs` gave different `snapSegDurMs` values and stems fired out of sync. Timer now always uses `GLOBAL_BPM` (or `FALLBACK_BPM` when no override) so all four stems always fire at the same interval: `SEGMENT_BARS × (60 000 / globalBPM × 4)`. `stretchRatio` continues to compensate for per-track BPM inside karma~

### Max / slot_router.js
- **`karma~: doesn't understand "int"` fix** — `1.0 / 1.0 = 1` in JS has no fractional part; Max sends it as an int atom, which karma~'s speed inlet rejects. Fixed by adding `1e-9` epsilon (`speedFloat = speedFactor + 1e-9`) to guarantee a fractional part → float atom. The ~0.00000009% pitch difference is inaudible
- **Pitch ratio sent on every play command** — previously `stemPitch[stem]` was only sent on explicit `:pitchShift`. Now `outlet(PITCH_OUT[stem], stemPitch[stem])` fires on every `routeStem()` call so gizmo~ always has a valid ratio (default 1.0 = pass-through) even before any pitch command is issued
- **`stop()` handler** — sends `"stop"` to all four karma~ inlet 0 outlets (0, 3, 6, 9) when `:stop` is received. Called by `buffer_manager.js` forwarding `outlet(12, "stop")` via the existing wire

### Max / buffer_manager.js
- **Cross-track load race condition fix** — when slicer switched source tracks, `handlePlay` was calling `loadSrc` even while another track was already loading into the staging buffer. This corrupted `s.contents[staging]` before the previous `fluid.bufcompose~` completed, leaving the stem silent or stuck. Fixed: `handlePlay` always writes `pendingCompose` first; only calls `loadSrc` when `s.loading === false`. When a load completes, `src_done` uses `findSrc` to check both buffers — if the wrong track arrived (different source track than `pendingCompose.sourceSlot`), it immediately calls `loadSrc` for the correct track and leaves `pendingCompose` set until the right buffer is ready.
- **`playing` gate** — new module-level flag (default `false`). Set to `true` at the top of `handlePlay()`. Checked in `ring_done` before `outlet(12, ...)` — in-flight `fluid.bufcompose~` copies that complete after `:stop` are now discarded instead of restarting karma~
- **`stop()` handler** — sets `playing = false` and forwards `outlet(12, "stop")` to slot_router so karma~ objects are halted immediately

### Max / ebys-pitch.maxpat
- **FFT imaginary path fix (silence through pitch shifter)** — the two imaginary signal wires were entirely missing from the pfft~ subpatch. Added: `fftin~ outlet 1 → gizmo~ inlet 1` and `gizmo~ outlet 1 → fftout~ inlet 1`. Without the imaginary component, FFT reconstruction is impossible and gizmo~ outputs silence regardless of pitch ratio

### TUI / sdj-tui.js
- **Version bump** — title and header updated to `EBYS 0.1.5`
- **Progress bar coordinate-system fix** — bars were filling only in the last seconds of each slice because `s.pos` (karma~ ring buffer 0→1) was being compared against `sliceStart/sliceEnd` (fractions of the *full stem buffer*) — different coordinate systems. Rewrote `sliceBar()` to use wall-clock elapsed time (`Date.now() - stemSliceStartTime[name]`) instead. Progress is now accurate for the full 8 000 ms window
- **`stemSliceStartTime` tracking** — records `Date.now()` whenever a new slice id arrives on a stem; `sliceBar()` reads this to compute elapsed time
- **Progress bar bracket width fix** — bracket width was based on the actual audio length in the ring buffer (e.g. 15 s for bass) not the timer duration (8 s). Fixed by using `segDurMs / stemDurMs` so all four brackets are the same width
- **`playbackStopped` flag** — set `true` on `:stop`, cleared on `:start`. `sliceBar()` reads this flag and suppresses the wall-clock timer, freezing the cursor at position 0 instead of continuing to animate after audio stops

---

## 0.1.4 — 2026-06-19

### Max / slicer.js
- **`buffer_manager.js` fix** — wrong `filename` field in maxpat was silently invoking `track_loader.js` instead; corrected
- **Phantom `src_done` fix** — removed 3 wrong patch cords that were triggering spurious `src_done` callbacks
- **`fluid.bufcompose~` attribute fix** — `destframe` → `deststartframe` (correct attribute name)
- **`dict: cannot read dictionary: -1` fix** — removed loadbang → dict cord that fired before the dict was populated

### Time-stretching (karma~ speed wiring)
- **`stretchRatio` fix in `buffer_manager.js`** — `composePend` was silently discarding `stretchRatio`; now stored and passed through `ring_done` → `slot_router.js` as 4th argument
- **`slot_router.js` v4** — added dedicated speed outlets (12–15) wired to karma~'s right inlet (speed factor = `1/stretchRatio`); pitch follows speed tape-style
- Delay timer corrected: `delayMs = segDurMs × stretchRatio` so the next segment fires at the right moment regardless of stretch amount

### Per-stem pitch shifting (pfft~/gizmo~)
- **`ebys-pitch.maxpat`** — new pfft~ subpatch: `fftin~ 1 square` → `gizmo~` → `fftout~ 1 hamming`; `in 2` receives pitch ratio from outside, routes to gizmo~'s frequency-shift inlet; duration unchanged
- **`ebys-analyze.maxpat`** — 4× pfft~ objects (one per stem) inserted between karma~ and the mixer; slot_router outlets 16–19 wired to each pfft~ inlet 1
- **`slot_router.js` v4** — added pitch outlets (16–19) and `pitchShift / setPitchSemitones / setPitch` functions; per-stem `stemPitch` state; `setPitch all` resets all stems
- **`ws_server.js`** — intercepts `:pitchShift <stem> <semitones>` before buildIndex check; calls `Max.outlet('pitchShift', stem, semitones)`; route object outlet 22 → `prepend pitchShift` (obj-4068) → slot_router inlet 0
- TUI command: `:pitchShift melody 3` raises melody 3 semitones; `:pitchShift all 0` resets

### Code clarity
- **`slicer.js`** — added `── Role ──` header block: sequencing brain, musical decision-making, no direct DSP access
- **`slot_router.js`** — added `── Role ──` header block: audio engine parameter hub, sole owner of karma~/pfft~ messages

### Infrastructure
- **32KB JS read limit bypass** — `analysis_library.json` (~1MB) now read by `ws_server.js` (Node.js) and delivered to `slicer.js` in 2KB chunks over Max's message bus; works around Max's hard JS file read cap
- **Genre filtering** — `genres.json` delivered to slicer via the same chunked mechanism; every slice is tagged with its track's genres
- Genre filter commands: `setGenreFilter <genre>`, `clearGenreFilter`, `listGenres`

### Cricket / Training
- **`:bake` training system** — captures intent + Cricket's commands + user corrections + live descriptor state to `training_log.jsonl`
- **`convert_bakes.py`** — converts bake log to MLX fine-tuning JSONL format
- **`finetune.sh`** — one-command LoRA fine-tune on Apple Silicon via `mlx-lm`
- `mlx-lm` installed in `~/ebys-mlx-env`

### Documentation
- **`ARCHITECTURE.md`** — full pipeline documented: Analysis (Demucs → Essentia → madmom → FluCoMa → JSON) and Playback (ws_server.js → chunks → slicer.js → buffer_manager.js → karma~ → pfft~/gizmo~)
- **`PLAYBACK.md`** — updated to reflect two-axis audio engine (tempo via karma~ speed, pitch via pfft~/gizmo~) and slot_router.js role separation

---

## 0.1.3 — 2026-06-18

### TUI
- **Novelty sparkline** — per-stem `▁▂▃▄▅▆▇█` weather map showing descriptor novelty over the last 12 slices
- Sparkline updates on every slice change (event-driven, no timer)
- Global autoscale across all 4 stems with `NOVELTY_GLOBAL_MIN = 0.05` floor — prevents outlier-poisoned rescaling
- `desc` message type separated from `stem` in ws_server.js so TUI can compute novelty with fresh descriptors
- Loop cycles emit `desc` before `seg` in slicer.js — sparkline now fires for loop repetitions
- Sparkline floor uses `▁` (LOWER ONE EIGHTH BLOCK) — bottom-anchored, single-width, guaranteed across terminal fonts
- Language list column layout: equal-distribution algorithm (floor/ceil per column, max diff = 1 entry)
- Language list LRM anchor restored for RTL scripts (Arabic, Hebrew) with +8 col gap to absorb CJK width discrepancies
- `loopCycles` counter in slicer.js — each loop repetition gets a unique id (`loop1`, `loop2`, …) so TUI detects id change on every cycle
- rangeBar fallback when `rng.max === rng.min`: cursor now shows at left (position 0) instead of center
- Progress bar shows slice zone `────[████░░░]────` with elapsed/remaining within zone
- **Slice zone now pixel-accurate** — slicer.js sends real `startFrac`/`endFrac` with every `seg` message; TUI uses them directly instead of estimating from BPM/bars
- Master header track name combines all stem track names with grey ` · ` separator
- Compact 2-space layout between descriptor fields
- **MMT direction arrows** — `↑` `─` `↓` displayed between each descriptor letter and its range bar (e.g. `M↑ ━━●━━`), driven by `tension_C/E/F/P/H/T` values; `·` when no tension data available
- Space separates arrow from range bar to prevent `─` merging with `━` characters

### ws_server.js
- `desc` handler broadcasts `type:'desc'` instead of `type:'stem'` — TUI uses this to know when fresh descriptors are available
- `desc` handler now accepts and stores `tC/tE/tF/tP/tH/tT` (tension values, 0–1) from slicer
- `seg` handler now parses and stores `sliceStart`/`sliceEnd` fracs broadcast with every stem message
- `slice_ms` handler added
- `index_empty` handler added — broadcasts warning to TUI when `:start` is sent before `buildIndex`

### slicer.js
- `loopCycles` per-stem counter — loop `seg` id is now `loop1`, `loop2`, … (unique per cycle)
- Loop branch emits `desc` with loop segment's descriptor values before `seg` — enables meaningful novelty in loop mode
- All three `desc` outlets now include `tension_C/E/F/P/H/T` fields from the slice object
- All three `seg` outlets now append `startFrac` and `endFrac` so TUI can draw an accurate zone bar
- `buildIndex` now reads `tension_C/E/F/P/H/T` from each slice dict into the in-memory slice objects

### add_tension.py
- Replaces `add_mmt.py` (deleted) — now the single source of truth for momentum computation
- All TUI paths (FluCoMa-done hook and `:setMMT` command) updated to call `add_tension.py`
- Writes `tension_*` fields (not `mmt_*`) — stale `mmt_*` fields stripped from `analysis_library.json`
- `_other.wav` / `_other` added to `STEM_SUFFIXES` so Demucs melody stem groups correctly
- Output condensed: one header line + one stem summary line per track, blank line between tracks

---

## 0.1.2 — 2026-06-16

### TUI
- Renamed `win:` to `env:` in header — the slice fade shape is an envelope, not an FFT window
- Moved MMT window display to sit right after `env:` in header line
- Genre header now shows full `Parent · Sub` format (e.g. `Electronic · Techno` instead of just `Techno`)
- `:setMMT <bars>` command — sets momentum window size, reruns `add_tension.py`, sends `buildIndex` on completion
- `MMT window: N bars` displayed in header

### Analysis
- `add_tension.py` — new script that computes per-bar momentum for all 6 descriptors (C, E, F, P, H, T) and writes `tension_C/E/F/P/H/T` back to every slice in `analysis_library.json`
- Momentum algorithm: group slices by bar → average descriptor per bar → sliding window slope → normalize 0–1 → write back
- `MOMENTUM.md` — documentation for the tension script
- `tension_E` near 1.0 = energy building (drop incoming). Near 0.0 = releasing. 0.5 = stable.
- T descriptor computed on the fly as RMS of MFCC coefficients M0–M5

---

## 0.1.1 — 2026

### TUI
- Per-stem track name display — shows which file each stem is currently playing from (20-char truncation with `…`)
- Weighted genre label in header — genre reflects which stem dominates by energy × track weight
- Track browser — `:nextTrack` / `:prevTrack` cycles through all tracks in bank showing BPM, key, genre, confidence
- `:reloadDownbeats` now updates TUI locally before forwarding to Max
- Key detection displayed in header — pulled from `downbeats.json` via Essentia KeyExtractor
- match/dir parameter lines aligned with bar column
- `fmtM` fixed to 4-char output, matching `fmtDir` alignment
- Slice id moved to end of descriptor line
- `setTrackWeight` intercepted to update per-stem weight in TUI state
- `[object Object]` genre display bug fixed — now correctly extracts `.genres[0].genre`

### Max / slicer.js
- `stemTrack` message handler added to `ws_server.js` — was silently dropped before
- `track_name` handler pre-populates all stem track fields immediately on track load
- `cleanTrackName()` helper strips stem suffix from track name before display
- `outlet(1, "stemTrack", ...)` added in `selectSegment()` and `nextNearest()`

### Analysis
- Essentia KeyExtractor wired into analysis pipeline — writes `key` field to `downbeats.json`
- Key shows in TUI header; `?` when unavailable

---

## 0.1.0 — 2026 (initial working build)

### Engine
- Max/MSP patch — 4-stem playback (vocals, melody, bass, drums) via `fluid.bufcompose~` + `fluid.bufresampler~`
- `analyze_reader.js` — reads Essentia analysis JSON, skips already-analyzed tracks, emits "all analyzed" on completion
- `slice_writer.js` — writes slice data to `analysis_library.json` with M0–M5 MFCC fields
- `slicer.js` — real-time slice selection engine using descriptor distance scoring (C, E, F, P, H, T + MFCC)
- Bar-snap quantization using madmom downbeats — slices lock to bar boundaries when confidence ≥ 0.4
- Stretch ratio wired through outlet 0 for time-stretching playback
- `ws_server.js` — WebSocket bridge between Max and TUI (RFC 6455, no external deps)

### Analysis pipeline
- `genre_tagger.py` — Essentia-based genre classification, writes `genres.json`
- `madmom_tagger.py` — downbeat detection via madmom DBNDownBeatTracker, writes `downbeats.json`
- `fluid.bufmfcc~` added to `ebys-analyze.maxpat` — computes M0–M5 per slice
- `fluid.buftempogram~` added for BPM estimation
- Improved BPM estimation in `analyze_reader.js`

### TUI (sdj-tui.js)
- 4-stem progression bars with real-time position tracking
- Descriptor display per stem: M, E, F, P, H, T
- Slice timestamp display
- Status header: track, BPM, key, LUFS, dBFS, genre, beats confidence bar, quant mode
- match/dir parameter display
- Language selector — 40+ languages, localized agent name and chirp
- Cricket AI agent — Ollama-backed, reads CRICKET.md as knowledge base, mixes commands and conversation
- `:resetMemory` — two-step confirmation to wipe all analysis JSON
- `:tagBeats` — runs madmom tagger from TUI
- `:commands` toggle, `:chat` toggle, `:language` toggle
- Counter advancement fixed — completion-based, not delay loop
- Meter console flooding fixed — delayed metro 100 startup
- `dictwrap` errors in `buildIndex` fixed
- Bass/melody buffer read messages fixed (obj-245, obj-247)

### Infrastructure
- `analysis_library.json` — consolidated single dict replacing per-track dict files
- Nested JSON format fixed — correct structure for Max `dict` objects
- Clean slate command — wipes analysis JSON and resets counter

---

## Roadmap

- **0.2** — momentum wired into slice selection (`:setArc`, `:setMMT` bias)
- **0.3** — Pure Data migration (Max/MSP → PD, deadline Aug 8)
- **1.0** — stable enough to perform with, documented, demo recording
