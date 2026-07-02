#!/usr/bin/env python3
"""
EBYS — Downbeat / Meter Tagger  v1

Uses madmom's DBNDownBeatTrackingProcessor to detect:
  - Time signature (meter: 2, 3, or 4)
  - BPM
  - Downbeat timestamps in ms (beat 1 of each bar)

Works on the ORIGINAL (unseparated) mix file — same as genre_tagger.py.

Output JSON:
  {
    "TrackName": {
      "meter":        4,
      "bpm":          120.3,
      "avgBarMs":     1997.4,
      "downbeats_ms": [0.0, 2000.1, 4003.7, ...],
      "beat_count":   256,
      "confidence":   0.91
    }
  }

  confidence: 1.0 = perfectly regular grid, 0.0 = chaotic (useful for
              deciding whether to use downbeats vs. BPM fallback in slicer.js)

Installation (madmom requires Python ≤ 3.11 — won't compile on 3.12+):
  brew install python@3.11
  python3.11 -m venv ~/ebys-env
  source ~/ebys-env/bin/activate
  pip install madmom --no-build-isolation
  # If Cython build fails, try:
  #   pip install cython==0.29.37 && pip install madmom --no-build-isolation
  # Or install from GitHub HEAD:
  #   pip install git+https://github.com/CPJKU/madmom

Usage:
  cd ~/wherever/EBYS   # from repo root

  # Single file
  python3 madmom_tagger.py /path/to/original_track.mp3

  # Single file, save to downbeats.json (appends / updates)
  python3 madmom_tagger.py /path/to/original_track.mp3 --out downbeats.json

  # Auto-find mix from htdemucs stems folder
  python3 madmom_tagger.py --stems-folder stems/htdemucs/TrackName --out downbeats.json

  # Batch: all tracks in htdemucs folder
  python3 madmom_tagger.py --htdemucs-root stems/htdemucs --out downbeats.json
"""

import sys
import os
import json
import argparse
import numpy as np

# ── NumPy compatibility shim for madmom ───────────────────────────────────────
# madmom was written against numpy <1.24.  Two breaking changes affect it:
#
# 1. np.float / np.int / np.bool etc. were removed in 1.24.
#    Fix: restore them as aliases for Python builtins.
#
# 2. np.asarray() on inhomogeneous sequences now raises ValueError instead of
#    silently creating an object array.  madmom's DBNDownBeatTrackingProcessor
#    does np.asarray(results)[:, 1] where results is a list of variable-length
#    arrays.  Fix: wrap np.asarray to fall back to dtype=object on ValueError.
#
# Both patches live here so they apply before ANY madmom import.

import numpy as _np_module  # alias so the patch closure can reference it

# Patch 1 — removed type aliases
for _alias, _builtin in [('float', float), ('int', int), ('complex', complex),
                          ('bool', bool), ('object', object), ('str', str)]:
    if not hasattr(_np_module, _alias):
        setattr(_np_module, _alias, _builtin)

# Patch 2 — inhomogeneous asarray
_orig_asarray = _np_module.asarray
def _compat_asarray(a, dtype=None, order=None, **kwargs):
    try:
        return _orig_asarray(a, dtype=dtype, order=order, **kwargs)
    except ValueError:
        # Inhomogeneous sequence — numpy <1.24 silently made an object array
        return _orig_asarray(a, dtype=object)
_np_module.asarray = _compat_asarray
# np is already imported above; re-bind so local uses also see the patch
np = _np_module


# ── File helpers ──────────────────────────────────────────────────────────────

MIX_EXTENSIONS = ['.wav', '.aiff', '.aif', '.mp3', '.flac', '.m4a', '.ogg', '.mp4']


def find_original_mix(stems_folder):
    """
    Search for the original mix file alongside or above the stems folder.
    htdemucs layout: stems/htdemucs/TrackName/{vocals,bass,...}.wav
    Original mix is typically in raw_uploads/ or the htdemucs parent.
    """
    stems_folder = os.path.normpath(stems_folder)
    track_name   = os.path.basename(stems_folder)
    parent       = os.path.dirname(stems_folder)   # e.g. stems/htdemucs/

    search_dirs = [
        # Prefer WAV in temp/ — madmom/soundfile cannot read MP4/AAC.
        # ffmpeg converts MP4 → WAV in temp/ before Demucs runs, so it's always there.
        os.path.join(parent, '..', '..', 'temp'),    # data/temp  (ffmpeg WAV)
        os.path.join(parent, '..', 'temp'),          # stems/temp  (alternate)
        os.path.join(parent, '..', '..', 'raw_uploads'),  # data/raw_uploads (MP4 fallback)
        os.path.join(parent, '..', 'raw_uploads'),
        parent,
        os.path.join(parent, '..'),
        os.path.join(parent, '..', '..'),
        stems_folder,
    ]

    for d in search_dirs:
        d = os.path.normpath(d)
        if not os.path.isdir(d):
            continue
        for ext in MIX_EXTENSIONS:
            candidate = os.path.join(d, track_name + ext)
            if os.path.exists(candidate):
                return candidate
    return None


def stems_for_folder(stems_folder):
    return [
        os.path.join(stems_folder, f)
        for f in os.listdir(stems_folder)
        if f.endswith('.wav')
    ]


# ── Analysis ──────────────────────────────────────────────────────────────────

def analyze_file(audio_path, beats_per_bar=(2, 3, 4)):
    """
    Run madmom downbeat detection on audio_path.
    Returns a dict with meter, bpm, avgBarMs, downbeats_ms, beat_count, confidence.
    Returns None on failure.
    """
    try:
        from madmom.features.downbeats import (
            RNNDownBeatProcessor,
            DBNDownBeatTrackingProcessor,
        )
    except ImportError:
        print(
            '\nERROR: madmom is not installed.\n'
            'Install it with:\n'
            '  python3.10 -m pip install madmom --no-build-isolation\n'
            'or from GitHub:\n'
            '  pip install git+https://github.com/CPJKU/madmom\n',
            file=sys.stderr
        )
        sys.exit(1)

    print(f'  Running RNNDownBeatProcessor …', file=sys.stderr)
    act  = RNNDownBeatProcessor()(audio_path)

    proc = DBNDownBeatTrackingProcessor(
        beats_per_bar=list(beats_per_bar),
        fps=100
    )
    beats = proc(act)
    # beats: numpy array [[time_sec, beat_number], ...]
    # beat_number resets to 1 at each bar

    if len(beats) == 0:
        print('  WARN: no beats detected', file=sys.stderr)
        return None

    # ── Meter ──────────────────────────────────────────────────────────────────
    # Most common value of the maximum beat number seen in each bar.
    max_beat = int(np.max(beats[:, 1]))
    meter    = max_beat

    # ── BPM ────────────────────────────────────────────────────────────────────
    beat_times = beats[:, 0]
    if len(beat_times) > 1:
        ibi = np.diff(beat_times)
        bpm = round(float(60.0 / np.median(ibi)), 2)
    else:
        bpm = 0.0

    # ── Downbeats ──────────────────────────────────────────────────────────────
    downbeat_times_sec = beats[beats[:, 1] == 1, 0]
    downbeat_times_ms  = [round(float(t) * 1000.0, 1) for t in downbeat_times_sec]

    # Average bar duration in ms (from inter-downbeat intervals)
    if len(downbeat_times_sec) > 1:
        bar_ibi   = np.diff(downbeat_times_sec)
        avg_bar_ms = round(float(np.median(bar_ibi)) * 1000.0, 1)
    else:
        avg_bar_ms = round(60000.0 / (bpm or 120.0) * meter, 1)

    # ── Confidence ─────────────────────────────────────────────────────────────
    # Coefficient of variation of bar durations.  Low CV → regular → high confidence.
    if len(downbeat_times_sec) > 2:
        bar_ibi  = np.diff(downbeat_times_sec)
        cv       = float(np.std(bar_ibi) / (np.mean(bar_ibi) + 1e-9))
        conf     = round(max(0.0, 1.0 - cv * 3), 3)   # x3 to make it sensitive
    else:
        conf = 0.0

    # ── Key detection (optional — requires essentia) ──────────────────────────
    key_str = '?'
    try:
        import essentia.standard as es
        print(f'  Running KeyExtractor …', file=sys.stderr)
        audio  = es.MonoLoader(filename=audio_path, sampleRate=44100)()
        key, scale, strength = es.KeyExtractor()(audio)
        if strength > 0.1:
            key_str = f'{key} {scale}'
        print(f'  key={key_str}  strength={strength:.3f}', file=sys.stderr)
    except Exception as e:
        print(f'  KeyExtractor skipped: {e}', file=sys.stderr)

    result = {
        'meter':        meter,
        'bpm':          bpm,
        'avgBarMs':     avg_bar_ms,
        'downbeats_ms': downbeat_times_ms,
        'beat_count':   int(len(beats)),
        'confidence':   conf,
        'key':          key_str,
    }

    bar = '█' * int(conf * 30)
    print(
        f'  meter={meter}/4  bpm={bpm:.1f}  '
        f'downbeats={len(downbeat_times_ms)}  conf={conf:.3f}  '
        f'{bar}',
        file=sys.stderr
    )
    return result


# ── CLI ───────────────────────────────────────────────────────────────────────

def main():
    ap = argparse.ArgumentParser(description='EBYS Downbeat/Meter Tagger (madmom)')
    ap.add_argument('mix', nargs='?', help='Original mix audio file')
    ap.add_argument('--stems-folder',
                    help='htdemucs stems folder — script finds the original mix')
    ap.add_argument('--htdemucs-root',
                    help='Batch: classify all tracks under this folder')
    ap.add_argument('--out', default=None,
                    help='Output JSON file. Default: print to stdout')
    ap.add_argument('--beats-per-bar', nargs='+', type=int, default=[2, 3, 4],
                    help='Candidate meters (default: 2 3 4)')
    args = ap.parse_args()

    jobs = []   # list of (mix_path, track_name)

    if args.mix:
        mix_path   = os.path.expanduser(args.mix)
        track_name = os.path.splitext(os.path.basename(mix_path))[0]
        jobs.append((mix_path, track_name))

    elif args.stems_folder:
        sf         = os.path.expanduser(args.stems_folder)
        track_name = os.path.basename(sf.rstrip('/'))
        mix_path   = find_original_mix(sf)
        if not mix_path:
            print(f'ERROR: cannot find original mix for "{track_name}".', file=sys.stderr)
            print(f'  Put the original file in raw_uploads/ or next to stems/htdemucs/.', file=sys.stderr)
            sys.exit(1)
        jobs.append((mix_path, track_name))

    elif args.htdemucs_root:
        root = os.path.expanduser(args.htdemucs_root)
        for track_name in sorted(os.listdir(root)):
            sf = os.path.join(root, track_name)
            if not os.path.isdir(sf):
                continue
            mix_path = find_original_mix(sf)
            if not mix_path:
                print(f'WARN: no mix found for "{track_name}" — skipping', file=sys.stderr)
                continue
            jobs.append((mix_path, track_name))

    else:
        ap.print_help()
        sys.exit(0)

    # Load existing output so we only update changed tracks
    out_path = os.path.expanduser(args.out) if args.out else None
    results  = {}
    if out_path and os.path.exists(out_path):
        try:
            with open(out_path) as f:
                results = json.load(f)
            print(f'Loaded {out_path} ({len(results)} existing tracks)', file=sys.stderr)
        except Exception as e:
            print(f'WARN: could not load {out_path}: {e}', file=sys.stderr)

    # ── Analyse ───────────────────────────────────────────────────────────────
    newly_analyzed = []
    for mix_path, track_name in jobs:
        print(f'\n→ {track_name}', file=sys.stderr)
        print(f'  mix: {mix_path}', file=sys.stderr)
        try:
            info = analyze_file(mix_path, beats_per_bar=args.beats_per_bar)
        except Exception as e:
            print(f'  ERROR: {e}', file=sys.stderr)
            import traceback; traceback.print_exc(file=sys.stderr)
            info = None

        if info:
            results[track_name] = info
            newly_analyzed.append(track_name)
        else:
            print(f'  WARN: no result for "{track_name}" — will not be written', file=sys.stderr)

    # ── Output ────────────────────────────────────────────────────────────────
    if not newly_analyzed:
        print('\nWARN: 0 tracks successfully analyzed — downbeats.json not updated', file=sys.stderr)
        sys.exit(1)

    output = json.dumps(results, indent=2, ensure_ascii=False)

    if out_path:
        with open(out_path, 'w') as f:
            f.write(output)
        print(f'\nSaved → {out_path}  ({len(newly_analyzed)} track(s): {newly_analyzed})', file=sys.stderr)
    else:
        print(output)


if __name__ == '__main__':
    main()


# ── Quick usage ───────────────────────────────────────────────────────────────
#
#   source ~/ebys-env/bin/activate       # Python 3.11 venv with madmom
#   cd ~/wherever/EBYS   # from repo root
#
#   # Single track (mix file directly):
#   python3 madmom_tagger.py /path/to/track.mp3 --out downbeats.json
#
#   # Auto-find mix from stems folder:
#   python3 madmom_tagger.py --stems-folder stems/htdemucs/TrackName --out downbeats.json
#
#   # Batch all tracks:
#   python3 madmom_tagger.py --htdemucs-root stems/htdemucs --out downbeats.json
#
#   After running, send "reloadDownbeats" to js slicer.js in Max to pick up the data.
