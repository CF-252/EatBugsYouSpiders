# EBYS Platform

A platform for live music performance, streaming, and artist compensation — built on an open tipping protocol.

---

## Radio Modes

The EBYS radio can operate in three modes depending on what the DJ is doing:

**Live mode** — the DJ is performing in real time. EBYS is running, the stream is active, the session log is live. Listeners can tip the set while it's happening.

**Replay mode** — an archived performance is streaming. Same interface, same tip button, same split equation — the session log is static. Useful for long-tail listening and for artists to continue earning from past performances.

**Unattended mode** — EBYS runs autonomously. The system selects and sequences slices without a human DJ driving the TUI. Useful for continuous background streaming between live sets. Curator share goes to the system account (eventually distributed as community funds).

---

## Radio Stack

```
Max/MSP (audio playback, local)
    ↓ audio
Icecast / Liquidsoap (stream encoding)
    ↓ stream
Web radio page (listener)
    ↓ tip event
backend API → Stripe → split → DJ + artists
```

Current audio output: stereo 44.1kHz, ogg/mp3. The TUI runs on the same machine as Max. Audio routing: Max → system audio out → Icecast capture via BlackHole virtual device (macOS).

---

## The Web Interface

The listener-facing interface is intentionally minimal:

- **Now playing** — track name, artist, transformation level indicator (▲⬢▼)
- **Tip button** — fixed tiers ($1 / $5 / $10) + custom amount
- **Stream player** — one click to listen, no account required
- **Artist thumbnails** — small portraits of contributing artists with follow links

No accounts required to listen or tip. The tip flow is Stripe Checkout — card, Apple Pay, Google Pay. Done in 30 seconds.

---

## What's Built / What's Next

**Built:**
- Web radio page (streaming)
- Tip flow with Stripe payment
- Session logging (ebys.db)
- Split equation (calculated, not yet transferred to artists)
- Basic auth (DJ login)
- Node.js API on Railway

**Next:**
- Artist payouts via Stripe Connect
- DJ profile / session management UI
- Replay mode for archived sets
- Temperature entropy trigger (live display + algorithm feed)
- Mobile-responsive radio page
- Domain on Cloudflare (currently on Cargo)

---

## The Temperature Connection

When today's temperature exceeds the 10-year rolling average for this date, the EBYS engine increases entropy — the probability that a stem switches to a different source track on the next segment. The formula:

```
entropy = clamp(0.5 + (δT / 5.0), 0.0, 1.0)
```

Where δT = today's temperature − historical average (same calendar date, 10-year window).

At entropy 0.5 (normal conditions), the engine is balanced — spectral continuity drives choices but variety is preserved. At entropy 1.0 (extreme heat), the engine is maximally experimental — it prioritizes variety over continuity, increasing the probability of surprising combinations.

This is displayed on the radio page as a live climate indicator. Listeners see the temperature differential and understand why tonight's mix sounds the way it does.

The climate indicator is also the honest marketing moment: the instrument performs differently because of climate. The powder you can buy from the same page reduces your contribution to that differential. The connection is structural, not rhetorical.
