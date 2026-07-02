import ollama
import os

FILE_PATH = "README.txt"
OUTPUT_PATH = "README_EDITED.txt"

# 1. Load file safely
if not os.path.exists(FILE_PATH):
    raise FileNotFoundError(f"{FILE_PATH} not found")

with open(FILE_PATH, "r") as f:
    original_text = f.read()

print("\n--- ORIGINAL FILE LOADED ---\n")

# 2. Ask AI to edit
response = ollama.chat(
    model="llama3.1",
    messages=[
        {
            "role": "user",
            "content": f"""
You are a careful technical editor.

Your task:
- Improve clarity
- Improve structure
- Keep ALL meaning intact
- Do NOT invent new features
- Do NOT remove important information unless redundant

Return ONLY the full rewritten file.

TEXT:
{original_text}
"""
        }
    ]
)

edited_text = response["message"]["content"]

# 3. Write preview file (NEVER overwrite directly)
with open(OUTPUT_PATH, "w") as f:
    f.write(edited_text)

print(f"\nAI wrote preview file: {OUTPUT_PATH}")

# 4. Ask for confirmation
choice = input("\nReplace original file? (yes/no): ").strip().lower()

if choice == "yes":
    with open(FILE_PATH, "w") as f:
        f.write(edited_text)
    print("Original file updated.")
else:
    print("No changes applied. Preview saved only.")
