#!/usr/bin/env python3
"""
EBYS — Genre Tagger  v2

Classifies the ORIGINAL (unseparated) audio file using Essentia + Discogs-EffNet,
then writes the genre result to ALL stems from that track.

Why the original file, not the stems?
  The model was trained on full mixes. Isolated stems lack the harmonic and
  rhythmic context needed for reliable genre identification. Bass alone, drums
  alone, or vocals alone all give noisy or wrong results.

Usage:
  source ~/ebys-env/bin/activate
  cd ~/wherever/EBYS   # from repo root

  # Classify one track — pass the original mix file
  python3 genre_tagger.py /path/to/original_track.mp3

  # Classify and save JSON
  python3 genre_tagger.py /path/to/original_track.mp3 --out genres.json

  # Point to a demucs output folder — script finds the original mix automatically
  python3 genre_tagger.py --stems-folder stems/htdemucs/TrackName

  # Batch: classify all tracks in an htdemucs folder
  python3 genre_tagger.py --htdemucs-root stems/htdemucs --out genres.json
"""

import sys
import os
import json
import argparse
import numpy as np


# ── Helpers ───────────────────────────────────────────────────────────────────

def load_labels(models_dir):
    lb_file = os.path.join(models_dir, 'genre_discogs400_labels.json')
    if not os.path.exists(lb_file):
        print('WARN: labels file not found — using numeric labels', file=sys.stderr)
        print('  Fix: curl -s "https://essentia.upf.edu/models/classification-heads/genre_discogs400/genre_discogs400-discogs-effnet-1.json"'
              ' | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin)[\'classes\'], indent=2))"'
              ' > essentia_models/genre_discogs400_labels.json', file=sys.stderr)
        return [f'class_{i:03d}' for i in range(400)]

    try:
        with open(lb_file) as f:
            raw = f.read().strip()
        labels = json.loads(raw)
        if isinstance(labels, list) and len(labels) >= 100:
            print(f'Loaded {len(labels)} genre labels', file=sys.stderr)
            return labels
    except Exception as e:
        print(f'WARN: could not parse labels ({e})', file=sys.stderr)

    return [f'class_{i:03d}' for i in range(400)]


def classify_file(audio_path, embedder, predictor, labels, top_n=5):
    """Classify a single audio file — works best on full mixes."""
    import essentia.standard as es

    # EffNet requires 16 kHz mono
    audio = es.MonoLoader(filename=audio_path, sampleRate=16000)()
    if len(audio) == 0:
        return []

    # Stage 1 — extract embeddings (~1 frame per second)
    embeddings  = embedder(audio)

    # Stage 2 — classify each frame
    predictions = predictor(embeddings)

    # Average across all frames
    avg = np.mean(predictions, axis=0)

    top_idx = np.argsort(avg)[::-1][:top_n]
    return [
        {'genre': labels[i], 'confidence': round(float(avg[i]), 4)}
        for i in top_idx
    ]


def find_original_mix(stems_folder):
    """
    Given a demucs stem folder (stems/htdemucs/TrackName/),
    try to find the original mix file in known locations.

    demucs is typically run as:
      demucs -o stems/ original.mp3
    which creates:
      stems/htdemucs/original/original_vocals.wav ...

    So the original is likely one level above htdemucs/, or wherever
    the user keeps their source files.
    """
    track_name = os.path.basename(stems_folder.rstrip('/'))

    # temp/ WAV is preferred — essentia MonoLoader reads wav natively without
    # needing ffmpeg in its subprocess PATH. mp4/m4a require ffmpeg which may
    # not be visible to essentia's internal loader even when it's in PATH.
    search_roots = [
        os.path.join(stems_folder, '..', '..', '..', 'temp'),        # data/temp (wav)
        os.path.join(stems_folder, '..', '..', '..', 'raw_uploads'), # data/raw_uploads
        os.path.join(stems_folder, '..', '..', '..'),
        os.path.join(stems_folder, '..', '..', '..', 'originals'),
        os.path.join(stems_folder, '..', '..', '..', 'tracks'),
        os.path.join(stems_folder, '..', '..', '..', 'music'),
        os.path.expanduser('~/Music'),
        os.path.expanduser('~/Downloads'),
    ]
    # wav/flac/aiff first — formats essentia can read without ffmpeg
    exts_preferred = ['.wav', '.flac', '.aiff', '.aif']
    exts_fallback  = ['.mp3', '.m4a', '.ogg', '.mp4']

    for ext_list in (exts_preferred, exts_fallback):
        for root in search_roots:
            root = os.path.normpath(root)
            if not os.path.isdir(root):
                continue
            for fname in os.listdir(root):
                name_no_ext, ext = os.path.splitext(fname)
                if ext.lower() in ext_list and name_no_ext == track_name:
                    return os.path.join(root, fname)

    return None


def stems_for_folder(stems_folder):
    """List stem WAVs in a demucs output folder."""
    if not os.path.isdir(stems_folder):
        return []
    return [
        os.path.join(stems_folder, f)
        for f in os.listdir(stems_folder)
        if f.endswith('.wav')
    ]


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    ap = argparse.ArgumentParser(
        description='EBYS Genre Tagger — classify original mix, tag all stems'
    )
    ap.add_argument('mix', nargs='?', default=None,
                    help='Original (unseparated) audio file to classify')
    ap.add_argument('--raw-folder', default=None,
                    help='Folder of original mix files (e.g. raw_uploads/) — batch-classifies all audio files inside')
    ap.add_argument('--stems-folder', default=None,
                    help='Demucs output folder for one track (auto-finds the original mix)')
    ap.add_argument('--htdemucs-root', default=None,
                    help='Root htdemucs/ folder — batch-classifies all tracks inside')
    ap.add_argument('--models', default=os.path.join(os.path.dirname(os.path.abspath(__file__)), 'essentia_models'),
                    help='Folder with .pb model files and labels JSON')
    ap.add_argument('--top',  type=int, default=5,  help='Top N genres to report (default 5)')
    ap.add_argument('--out',  default=None,          help='Save JSON output to this file')
    args = ap.parse_args()

    # ── Verify model files ────────────────────────────────────────────────────
    pb_embed = os.path.join(args.models, 'discogs-effnet-bs64-1.pb')
    pb_genre = os.path.join(args.models, 'genre_discogs400-discogs-effnet-1.pb')

    for f in [pb_embed, pb_genre]:
        if not os.path.exists(f):
            print(f'ERROR: missing model file: {f}', file=sys.stderr)
            sys.exit(1)

    labels = load_labels(args.models)

    import essentia.standard as es
    print('Loading models...', file=sys.stderr)
    embedder  = es.TensorflowPredictEffnetDiscogs(graphFilename=pb_embed, output='PartitionedCall:1')
    predictor = es.TensorflowPredict2D(graphFilename=pb_genre,
                                       input='serving_default_model_Placeholder:0',
                                       output='PartitionedCall:0')

    # ── Build job list: (mix_file, [stem_files]) ──────────────────────────────
    jobs = []  # list of (mix_path, track_name, [stem_paths])

    if args.raw_folder:
        # Batch: every audio file in the folder is a track
        raw_root     = os.path.expanduser(args.raw_folder)
        htdemucs_root = os.path.join(raw_root, '..', 'stems', 'htdemucs')
        exts = {'.mp3', '.wav', '.flac', '.aiff', '.aif', '.m4a', '.ogg', '.mp4'}
        for fname in sorted(os.listdir(raw_root)):
            name_no_ext, ext = os.path.splitext(fname)
            if ext.lower() not in exts:
                continue
            mix_path   = os.path.join(raw_root, fname)
            stem_dir   = os.path.normpath(os.path.join(htdemucs_root, name_no_ext))
            stem_files = stems_for_folder(stem_dir) if os.path.isdir(stem_dir) else []
            jobs.append((mix_path, name_no_ext, stem_files))

    elif args.mix:
        mix_path   = os.path.expanduser(args.mix)
        track_name = os.path.splitext(os.path.basename(mix_path))[0]
        jobs.append((mix_path, track_name, []))

    elif args.stems_folder:
        sf = os.path.expanduser(args.stems_folder)
        track_name = os.path.basename(sf.rstrip('/'))
        mix_path   = find_original_mix(sf)
        stem_files = stems_for_folder(sf)
        if not mix_path:
            print(f'WARN: could not find original mix for "{track_name}"', file=sys.stderr)
            print( '  Place the original audio file alongside your stems folder or pass it directly:', file=sys.stderr)
            print(f'  python3 genre_tagger.py /path/to/{track_name}.mp3', file=sys.stderr)
            sys.exit(1)
        jobs.append((mix_path, track_name, stem_files))

    elif args.htdemucs_root:
        root = os.path.expanduser(args.htdemucs_root)
        for track_name in os.listdir(root):
            sf = os.path.join(root, track_name)
            if not os.path.isdir(sf):
                continue
            mix_path   = find_original_mix(sf)
            stem_files = stems_for_folder(sf)
            if not mix_path:
                print(f'WARN: original mix not found for "{track_name}" — skipping', file=sys.stderr)
                continue
            jobs.append((mix_path, track_name, stem_files))

    else:
        ap.print_help()
        sys.exit(0)

    # ── Classify ──────────────────────────────────────────────────────────────
    results = {}

    for mix_path, track_name, stem_files in jobs:
        print(f'\n→ {track_name}', file=sys.stderr)
        print(f'  mix: {os.path.basename(mix_path)}', file=sys.stderr)

        try:
            genres = classify_file(mix_path, embedder, predictor, labels, top_n=args.top)
        except Exception as e:
            print(f'  ERROR: {e}', file=sys.stderr)
            genres = []

        # Print results
        for g in genres:
            bar = '█' * int(g['confidence'] * 30)
            print(f"  {g['confidence']:.3f} {bar:<30}  {g['genre']}", file=sys.stderr)

        # Attribute genre to all stems
        track_result = {
            'mix':   os.path.basename(mix_path),
            'genres': genres,
            'stems': {
                os.path.splitext(os.path.basename(s))[0]: genres
                for s in stem_files
            }
        }
        results[track_name] = track_result

    # ── Output ────────────────────────────────────────────────────────────────
    output = json.dumps(results, indent=2, ensure_ascii=False)

    if args.out:
        with open(args.out, 'w') as f:
            f.write(output)
        print(f'\nSaved → {args.out}', file=sys.stderr)
    else:
        print(output)


if __name__ == '__main__':
    main()


# ── Quick usage ───────────────────────────────────────────────────────────────
#
# source ~/ebys-env/bin/activate
# cd ~/wherever/EBYS   # from repo root
#
# # Pass the original mix directly:
# python3 genre_tagger.py /path/to/track.mp3
#
# # Or let the script find it from the stems folder:
# python3 genre_tagger.py --stems-folder stems/htdemucs/TrackName
#
# # Save output:
# python3 genre_tagger.py /path/to/track.mp3 --out genres.json
