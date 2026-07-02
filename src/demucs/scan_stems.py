from pathlib import Path
import json

# Relative to this file: src/demucs/ → src/ → EBYS/ → data/stems/htdemucs
ROOT = Path(__file__).parent.parent.parent / "data" / "stems" / "htdemucs"

dataset = []

for song_folder in ROOT.iterdir():
    if song_folder.is_dir():

        song_name = song_folder.name

        for stem in song_folder.glob("*.wav"):

            dataset.append({
                "song": song_name,
                "file": stem.name,
                "path": str(stem),
                "stem_type": stem.stem  # drums, bass, vocals, etc.
            })

print(json.dumps(dataset, indent=2))
