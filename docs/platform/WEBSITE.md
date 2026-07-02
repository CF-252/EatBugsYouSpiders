# EBYS Website

The public face of the platform — radio, events, community, and the buy link for cricket powder.

---

## Pages

### / (Home / Radio)

The main page. The stream is immediately playable — no login, no account, no barrier. The now-playing display shows the current track, artist, and transformation level. The tip button is always visible during live sets.

Below the player: recent sessions, top-tipped sets, featured artists.

The temperature indicator sits near the player: current δT, current entropy, what it means for the mix.

### /events

Upcoming performances. Each event has a date, a DJ name, and a link to the radio page for that session. DJs submit events through their profile. No approval flow — submit and it shows up.

Past events link to archived session replays.

### /artists

A directory of artists in the EBYS ecosystem. Search by genre, city, tag. Artist pages show their submitted tracks, their presence in past sessions (how often their music played), and their public CRKT earning status (opt-in).

### /dj

DJ profile / session management. Requires login. This is where the DJ:
- Opens a new session
- Sees their session history and tip earnings
- Manages Stripe Connect for payouts
- Submits events to the calendar

Currently under construction. Auth exists (JWT). The session opening flow works. The UI is minimal.

### /tip/:sessionId

The tip page for a specific session. Accessible from the radio page during live sets, and from session archives for replays. Shows the DJ name, set duration, contributing artists. Payment via Stripe Checkout.

The current tip.html is live and functional.

### /buy

The cricket protein powder store. Simple product page — one SKU to start. White-label product, branded packaging. Add to cart → Stripe Checkout → shipped.

The CRKT connection: the buy page explains that a portion of every purchase distributes to CRKT holders (artists and DJs who earned through the protocol). Buying powder = supporting the community.

---

## Domain

Current status: eatbugsyouspider.com and .org are registered on Cargo.

Next step: transfer to Cloudflare for DNS management, SSL, and better DDoS protection. Requires EPP codes from Cargo — support email pending.

Cloudflare will also allow connecting the Railway backend to the domain with custom nameservers.

---

## Design Language

- **Dark background** — the deck is a dark interface. The website inherits this.
- **Monospace type** — the TUI is the soul of the instrument. The website font echoes it.
- **Spider** — the EatBugsYouSpider character appears on every page. Small, present, watching.
- **Transformation indicators** — ▲⬢▼ used everywhere transformation level is shown. Not explained, just present.
- **No hero copy** — no tagline, no elevator pitch at the top. The stream starts. The music explains it.

---

## Mixer Console (Visual)

The radio page includes a live visualization of the EBYS deck state:

```
┌── VOCALS ────────────────────────────────┐
│ track: "Track Name"  L2  ▲              │
│ ████████████████░░░░░░░░░  +2.1dB       │
└──────────────────────────────────────────┘
┌── MELODY ────────────────────────────────┐
│ track: "Track Name"  L1  ⬢              │
│ ██████████░░░░░░░░░░░░░░░  +0.4dB       │
└──────────────────────────────────────────┘
┌── BASS ──────────────────────────────────┐
│ track: "Track Name"  L1  ⬢              │
│ ████████████████████████  +3.0dB        │
└──────────────────────────────────────────┘
┌── DRUMS ─────────────────────────────────┐
│ track: "Track Name"  L0  ▼              │
│ ███████████████████░░░░░  +1.8dB        │
└──────────────────────────────────────────┘
```

Updates every bar via WebSocket from the backend. The visualization is informational but also the aesthetic center of the page — the instrument visible to the listener.
