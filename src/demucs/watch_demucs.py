import subprocess
import time
import os
import re
import json
import urllib.request
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


# =========================
# PROGRESS REPORTING
# POSTs pipelineStage events to ws_server.js /progress endpoint.
# ws_server broadcasts to all TUI clients.
# =========================
WS_SERVER_PROGRESS_URL = "http://localhost:8080/progress"

def post_progress(data):
    try:
        body = json.dumps(data).encode('utf-8')
        req = urllib.request.Request(
            WS_SERVER_PROGRESS_URL, data=body,
            headers={'Content-Type': 'application/json'}, method='POST'
        )
        urllib.request.urlopen(req, timeout=1)
    except Exception:
        pass  # TUI not connected — silent

# =========================
# PATHS  (all relative — works on any machine)
# =========================
SRC_DIR  = Path(__file__).parent          # EBYS/src/demucs/
ROOT_DIR = SRC_DIR.parent.parent          # EBYS/ (repo root)
DATA_DIR = ROOT_DIR / "data"

RAW_UPLOADS = DATA_DIR / "raw_uploads"
STEMS_DIR   = DATA_DIR / "stems"
TEMP_DIR    = DATA_DIR / "temp"

RAW_UPLOADS.mkdir(parents=True, exist_ok=True)
STEMS_DIR.mkdir(parents=True, exist_ok=True)
TEMP_DIR.mkdir(parents=True, exist_ok=True)


# =========================
# PYTHON SELECTION
# =========================
# demucs_env: for Demucs itself (needs torch, Python 3.14)
DEMUCS_PYTHON = str(SRC_DIR / "demucs_env" / "bin" / "python3")

# Analysis python: needs essentia + madmom (requires Python ≤ 3.11)
# Try candidates in order; first one that has both wins.
def _find_analysis_python():
    candidates = [
        "/opt/homebrew/bin/python3.10",   # ideal: madmom + essentia sweet spot
        "/opt/homebrew/bin/python3.11",
        "/usr/local/bin/python3.10",
        "/usr/local/bin/python3.11",
        "/opt/homebrew/bin/python3",
        "/usr/local/bin/python3",
        DEMUCS_PYTHON,   # last resort
    ]
    for py in candidates:
        if not Path(py).exists():
            continue
        r = subprocess.run([py, "-c", "import madmom, essentia"], capture_output=True)
        if r.returncode == 0:
            print(f"Analysis python: {py}")
            return py
    # Fallback: just needs essentia (genre_tagger) or madmom separately
    for py in candidates:
        if Path(py).exists():
            print(f"Analysis python fallback: {py}")
            return py
    return DEMUCS_PYTHON

ANALYSIS_PYTHON = _find_analysis_python()

# Subprocess env with Homebrew in PATH (needed for ffmpeg inside madmom)
SUBPROCESS_ENV = os.environ.copy()
SUBPROCESS_ENV["PATH"] = "/opt/homebrew/bin:/usr/local/bin:" + SUBPROCESS_ENV.get("PATH", "")


# =========================
# STARTUP ANALYSIS
# Run genre + madmom on any existing track not yet in genres.json / downbeats.json
# =========================
def analyze_missing_tracks():
    ht_root = STEMS_DIR / "htdemucs"
    if not ht_root.exists():
        return

    genres_path    = DATA_DIR / "genres.json"
    downbeats_path = DATA_DIR / "downbeats.json"

    try:
        genres_db = json.load(open(genres_path)) if genres_path.exists() else {}
    except Exception:
        genres_db = {}
    try:
        beats_db = json.load(open(downbeats_path)) if downbeats_path.exists() else {}
    except Exception:
        beats_db = {}

    missing = []
    for folder in sorted(ht_root.iterdir()):
        if not folder.is_dir():
            continue
        name = folder.name
        in_genres = any(name in k or k in name for k in genres_db)
        in_beats  = any(name in k or k in name for k in beats_db)
        if not in_genres or not in_beats:
            missing.append(name)

    if not missing:
        print("startup: all tracks already analyzed ✓")
        return

    print(f"startup: {len(missing)} track(s) need analysis: {missing}")
    HT_ROOT = str(ht_root)

    print("startup → genre_tagger.py ...")
    subprocess.run(
        [ANALYSIS_PYTHON, str(SRC_DIR / "genre_tagger.py"),
         "--htdemucs-root", HT_ROOT,
         "--out", str(genres_path)],
        env=SUBPROCESS_ENV
    )

    print("startup → madmom_tagger.py ...")
    subprocess.run([
        ANALYSIS_PYTHON, str(SRC_DIR / "madmom_tagger.py"),
        "--htdemucs-root", HT_ROOT,
        "--out", str(downbeats_path),
    ], env=SUBPROCESS_ENV)

    print("startup: analysis complete ✓")

analyze_missing_tracks()


# =========================
# SQLITE IMPORT HELPER
# =========================
def _run_import_library():
    """Import genres + downbeats (and any existing slices) into ebys.db."""
    import_script = SRC_DIR / "import_library.py"
    if not import_script.exists():
        return
    try:
        r = subprocess.run(
            [ANALYSIS_PYTHON, str(import_script)],
            capture_output=True, text=True, timeout=60,
            env=SUBPROCESS_ENV
        )
        if r.stdout.strip():
            print(f"import_library: {r.stdout.strip()}")
        if r.returncode != 0 and r.stderr.strip():
            print(f"import_library ERROR: {r.stderr.strip()}")
    except Exception as e:
        print(f"import_library failed: {e}")


# Run once at startup to populate DB from existing JSON files
_run_import_library()


# =========================
# WATCHER HANDLER
# =========================
class AudioHandler(FileSystemEventHandler):

    def process_file(self, filepath: Path):

        print("\n========================")
        print("NEW FILE:", filepath)
        print("========================")

        ext = filepath.suffix.lower()

        # -------------------------
        # INPUT HANDLING
        # -------------------------
        if ext == ".mp4":
            wav_path = TEMP_DIR / f"{filepath.stem}.wav"

            subprocess.run([
                "/opt/homebrew/bin/ffmpeg", "-y",
                "-i", str(filepath),
                str(wav_path)
            ])

            target_audio = wav_path

        elif ext == ".wav":
            target_audio = filepath

        else:
            print("Unsupported file type")
            return

        print("Processing:", target_audio.name)

        original_name = target_audio.stem
        ht_root = STEMS_DIR / "htdemucs"
        song_folder = None

        # -------------------------
        # SKIP IF STEMS ALREADY EXIST
        # -------------------------
        if ht_root.exists():
            for folder in ht_root.iterdir():
                if folder.is_dir() and any(folder.glob(f"{original_name}_*.wav")):
                    print(f"Stems already exist for '{original_name}' — skipping Demucs")
                    song_folder = folder
                    break

        if song_folder is None:
            # -------------------------
            # RUN DEMUCS (stream progress to TUI)
            # -------------------------
            post_progress({'type': 'pipelineStage', 'stage': 'demucs',
                           'status': 'start', 'track': original_name, 'percent': 0})

            demucs_env = SUBPROCESS_ENV.copy()
            demucs_env["PYTHONUNBUFFERED"] = "1"
            proc = subprocess.Popen([
                DEMUCS_PYTHON,
                "-m", "demucs",
                "-o", str(STEMS_DIR),
                str(target_audio)
            ], stderr=subprocess.PIPE, stdout=subprocess.DEVNULL, env=demucs_env)

            # Parse tqdm progress from stderr (uses \r for in-place updates)
            buf = b''
            last_pct = -1
            for chunk in iter(lambda: proc.stderr.read(64), b''):
                buf += chunk
                parts = re.split(b'[\r\n]', buf)
                buf = parts[-1]
                for part in parts[:-1]:
                    line = part.decode('utf-8', errors='replace')
                    m = re.search(r'(\d+)%', line)
                    if m:
                        pct = int(m.group(1))
                        if pct != last_pct:
                            last_pct = pct
                            print(f"Demucs: {pct}%")
                            post_progress({'type': 'pipelineStage', 'stage': 'demucs',
                                           'status': 'progress', 'track': original_name, 'percent': pct})
            proc.wait()
            post_progress({'type': 'pipelineStage', 'stage': 'demucs',
                           'status': 'done', 'track': original_name})

            print("Demucs finished")

            if not ht_root.exists():
                print("No htdemucs folder found")
                return

            # Demucs always names the output folder after the input stem
            song_folder = ht_root / original_name
            if not song_folder.exists() or not list(song_folder.glob("*.wav")):
                print(f"Expected folder not found: {song_folder}")
                return

            print("Using folder:", song_folder.name)

            # -------------------------
            # RENAME FILES
            # -------------------------
            for f in list(song_folder.glob("*.wav")):
                new_name = f"{original_name}_{f.stem}.wav"
                new_path = f.parent / new_name
                print(f"Renaming {f.name} -> {new_name}")
                try:
                    f.rename(new_path)
                except Exception as e:
                    print("Rename error:", e)

            print("DONE\n")

        # -------------------------
        # RUN ANALYSIS PIPELINE  (genre + madmom BEFORE stream.txt write)
        # stream.txt is written last so streamWatcher only fires when the
        # full track (Demucs + genre + madmom) is ready for FluCoMa.
        # -------------------------
        HT_ROOT = str(STEMS_DIR / "htdemucs")

        print("→ genre_tagger.py ...")
        post_progress({'type': 'pipelineStage', 'stage': 'genre',
                       'status': 'start', 'track': original_name})
        r_genre = subprocess.run(
            [ANALYSIS_PYTHON, str(SRC_DIR / "genre_tagger.py"),
             "--htdemucs-root", HT_ROOT,
             "--out", str(DATA_DIR / "genres.json")],
            env=SUBPROCESS_ENV, capture_output=True, text=True
        )
        if r_genre.stderr.strip():
            print(f"genre_tagger output:\n{r_genre.stderr.strip()}")
        if r_genre.returncode != 0:
            print(f"genre_tagger FAILED (code {r_genre.returncode})")
            post_progress({'type': 'pipelineStage', 'stage': 'genre',
                           'status': 'error', 'track': original_name,
                           'msg': f'code {r_genre.returncode}'})
        else:
            post_progress({'type': 'pipelineStage', 'stage': 'genre',
                           'status': 'done', 'track': original_name})

        print("→ madmom_tagger.py ...")
        post_progress({'type': 'pipelineStage', 'stage': 'madmom',
                       'status': 'start', 'track': original_name})
        r_madmom = subprocess.run([
            ANALYSIS_PYTHON, str(SRC_DIR / "madmom_tagger.py"),
            "--htdemucs-root", HT_ROOT,
            "--out", str(DATA_DIR / "downbeats.json"),
        ], env=SUBPROCESS_ENV, capture_output=True, text=True)
        # Always print madmom output — it exits 0 even on analysis failure
        if r_madmom.stderr.strip():
            print(f"madmom_tagger output:\n{r_madmom.stderr.strip()}")
        if r_madmom.stdout.strip():
            print(f"madmom_tagger stdout:\n{r_madmom.stdout.strip()}")
        if r_madmom.returncode != 0:
            print(f"madmom_tagger FAILED (code {r_madmom.returncode})")
            post_progress({'type': 'pipelineStage', 'stage': 'madmom',
                           'status': 'error', 'track': original_name,
                           'msg': f'code {r_madmom.returncode}'})
        else:
            # Verify downbeats.json was actually populated
            db_path = DATA_DIR / "downbeats.json"
            try:
                db = json.load(open(db_path)) if db_path.exists() else {}
                if db:
                    post_progress({'type': 'pipelineStage', 'stage': 'madmom',
                                   'status': 'done', 'track': original_name})
                else:
                    print("madmom_tagger WARNING: downbeats.json is empty — madmom may have failed silently")
                    post_progress({'type': 'pipelineStage', 'stage': 'madmom',
                                   'status': 'error', 'track': original_name,
                                   'msg': 'downbeats.json empty — check watchdemucs.log'})
            except Exception as e:
                print(f"madmom_tagger WARNING: could not verify downbeats.json: {e}")
                post_progress({'type': 'pipelineStage', 'stage': 'madmom',
                               'status': 'done', 'track': original_name})

        # -------------------------
        # UPDATE stream.txt  (all tracks, 4 lines per track, fixed order per batch)
        # Written AFTER genre+madmom so FluCoMa has all data ready immediately.
        # Max counter cycles 1-4 per track: 1=vocals 2=drums 3=bass 4=melody
        # -------------------------
        STEM_ORDER = [
            ('vocals', 'vocals'),
            ('drums',  'drums'),
            ('bass',   'bass'),
            ('other',  'melody'),
        ]

        ht_root = STEMS_DIR / "htdemucs"
        all_lines = []
        if ht_root.exists():
            for track_folder in sorted(ht_root.iterdir()):
                if not track_folder.is_dir():
                    continue
                track_base = track_folder.name
                batch = []
                for demucs_stem, label in STEM_ORDER:
                    matches = list(track_folder.glob(f"*_{demucs_stem}.wav"))
                    exact = track_folder / f"{track_base}_{demucs_stem}.wav"
                    stem_file = exact if exact.exists() else (matches[0] if matches else None)
                    if stem_file:
                        batch.append(f"{label} {stem_file}")
                    else:
                        print(f"  ⚠  missing {demucs_stem} for '{track_base}'")
                if batch:
                    all_lines.extend(batch)

        if all_lines:
            stream_path = DATA_DIR / "stream.txt"
            with open(stream_path, 'w') as f:
                f.write('\n'.join(all_lines) + '\n')
            n_tracks = len(all_lines) // 4
            print(f"stream.txt → {len(all_lines)} stems ({n_tracks} tracks)")

            # Notify TUI + Max that stems are written and FluCoMa can start.
            # ws_server.js receives this via /stems-ready and emits stemsReady to Max.
            post_progress({'type': 'stemsReady', 'track': original_name,
                           'n_tracks': n_tracks})
        else:
            print("⚠  no stems found to write to stream.txt")

        # Import updated genres + downbeats into SQLite.
        # Slice rows are imported after FluCoMa analysis completes (ws_server analysisDone).
        _run_import_library()

        print("✓ pipeline complete\n")



    def on_created(self, event):

        if event.is_directory:
            return

        filepath = Path(event.src_path)
        filename = filepath.name
        print("🔥 WATCHER TRIGGERED:", event.src_path)

        # Notify TUI immediately — before any processing
        post_progress({'type': 'fileDetected', 'filename': filename})

        time.sleep(2)
        self.process_file(filepath)


# =========================
# START WATCHER
# =========================
observer = Observer()
observer.schedule(AudioHandler(), str(RAW_UPLOADS), recursive=False)
observer.start()

print("Watching raw_uploads...")

try:
    while True:
        time.sleep(1)

except KeyboardInterrupt:
    observer.stop()

observer.join()
