# EBYS — Tech Stack

## Stem Separation
**HTDemucs** (Facebook Research)
Separates audio into 4 stems: vocals, melody, bass, drums.

## Beat Detection
**madmom** (Austrian Research Institute for Artificial Intelligence)
Onset detection, BPM, rhythmic grid.

## Genre Classification
**Essentia** + discogs-effnet model (Music Technology Group, Barcelona)
400 genre classes from Discogs training data.

## Audio Descriptors
**FluCoMa**

| Symbol | Descriptor | Musical meaning |
|--------|------------|-----------------|
| C | Spectral Centroid | Brightness / harshness |
| E | Loudness (LUFS) | Energy / intensity |
| F | Spectral Flatness | Noise vs. tone |
| P | Pitch (Hz) | Fundamental frequency |
| H | Chroma | Dominant pitch class / tonality |
| T | Timbre (MFCC RMS) | Timbral fingerprint |

## Language Model
**Llama 3.1** via Ollama (runs locally)
Translates natural language into slicer commands.
8 languages natively: English, French, German, Italian, Spanish, Portuguese, Hindi, Thai.
Extended with community dictionaries: inuktitut, ojibwe, zulu.

## Audio Engine
**Pure Data** (migrating from Max/MSP)
Open source. AGPL-3.0 compatible.

## Web Interface
**HTML / CSS**
Zero-CSS base. Skin system: one skin = one CSS file, user-created and shareable.

## License
**AGPL-3.0**
Copyleft. Covers network use. Code must stay open even when deployed as a service.
