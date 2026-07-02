import os

BASE_DIR = "stems"

STEMS = ["drums.wav", "bass.wav", "vocals.wav", "other.wav"]

for song_folder in os.listdir(BASE_DIR):
    song_path = os.path.join(BASE_DIR, song_folder)

    if not os.path.isdir(song_path):
        continue

    print("\nProcessing:", song_folder)

    for file_name in os.listdir(song_path):

        if file_name.lower() not in STEMS:
            continue

        old_path = os.path.join(song_path, file_name)

        new_name = f"{song_folder}_{file_name}"
        new_path = os.path.join(song_path, new_name)

        os.rename(old_path, new_path)

        print("renamed:", file_name, "→", new_name)

