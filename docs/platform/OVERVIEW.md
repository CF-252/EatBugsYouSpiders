# EBYS — Overview

**Eat Bugs You Spider!** — a neural DJ deck, a web radio, and an open tipping protocol.

EBYS is a research-creation project. It is currently live as a working prototype. The instrument runs. The radio streams. The tipping protocol is active. Nothing described here is speculative beyond what's explicitly marked as planned.

---

## What EBYS Is

EBYS is three things simultaneously:

**1. An instrument.** A DJ deck powered by a neural analysis engine. The DJ loads a music library. EBYS slices every track into bars, extracts 6 spectral descriptors per slice, and builds a similarity index. During performance, it selects and sequences slices in real time, trying to maintain spectral continuity across cuts while allowing the DJ to steer the energy, transformation level, and direction. The instrument runs locally on a laptop connected to Max/MSP. The TUI (terminal UI) is the control surface.

**2. A radio.** A web radio that streams live EBYS performances and plays archived sets. The radio page shows what's playing: track, artist, transformation level. Listeners can tip the set from the radio page. The tip automatically splits between the DJ and all contributing artists.

**3. A protocol.** An open tipping protocol for music performances. Listeners tip in dollars — no app, no account, no crypto required. The split runs automatically. Artists and DJs choose independently whether to receive dollars or convert to CRKT (a revenue-share token backed by cricket protein powder margin).

---

## File Map

```
EBYS/
├── docs/
│   ├── README.md              ← this index
│   ├── platform/              ← what EBYS is (you are here)
│   ├── protocol/              ← tipping, split, token
│   ├── instrument/            ← the engine, the AI, the hardware
│   └── business/              ← cricket powder company
│
├── Tipping_protocole/
│   └── backend/               ← Node.js API (tip.js, auth.js, slicer.js)
│
├── EBYS_INFRA/               ← Max patch, Python analysis scripts
│   ├── python/
│   │   ├── ingest.py
│   │   ├── analyze.py
│   │   ├── add_stereo_features.py
│   │   ├── add_tension.py
│   │   └── build_index.py
│   └── max/                  ← .maxpat files
│
└── ARCHITECTURE.md           ← canonical system reference
```

---

## What's Built

- **Python analysis pipeline** — ingest, HTDemucs stem separation, madmom BPM/beat detection, Essentia/FluCoMa descriptor extraction, tension/momentum calculation, FAISS index building
- **Max/MSP playback engine** — 4-stem karma~ buffer system, slice sequencing, M/S stereo, pitch shift, FX send/return
- **Node.js backend** — REST API, SQLite database (ebys.db), Stripe payment processing, JWT auth, Railway deployment
- **TUI** — terminal control surface (sdj-tui.js / cricket-voice.js)
- **Web radio page** — live stream, now-playing, tip button
- **Tipping flow** — tip.html → Stripe → split calculation → DJ payout (artist payouts pending Stripe Connect onboarding)

---

## What's Next

- **Stripe Connect onboarding** for DJs and artists (artist payouts currently blocked)
- **Token refresh** — silent renewal of active JWTs before expiry
- **DJ profile page** — logged-in DJ opens sessions, sees stats, manages Stripe Connect
- **Domain transfer** — eatbugsyouspider.com/.org from Cargo to Cloudflare
- **EBYS-A1** — hardware instrument
- **CRKT on-chain** — token implementation (currently in-database only)
- **Card reader** — physical venue tipping device
