from pathlib import Path

STEMS_DIR = Path("stems/htdemucs")

print("Looking inside:", STEMS_DIR.resolve())

for folder in STEMS_DIR.iterdir():
    if folder.is_dir():
        print("\nFolder:", folder.name)
        for f in folder.glob("*.wav"):
            print("  File:", f.name)
