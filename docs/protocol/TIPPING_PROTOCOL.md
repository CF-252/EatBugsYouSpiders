# Tipping Protocol

An open protocol for tipping DJ sets and live music performances. The protocol is the same everywhere — what changes is the precision of the information available behind it.

Listeners tip in dollars. No crypto required. Artists and DJs choose what to do with what they receive.

---

## Three Levels of Precision

### Level 1 — Web Radio (EBYS)
Full precision. EBYS has complete visibility into the mix at every moment: every track, every slice, every stem, the follow graph, the transformation level. The split is calculated automatically and precisely across the DJ and every contributing artist.

The listener tips at any moment. The system knows exactly what was playing across the entire session — which tracks contributed, how much, how the follow graph evolved, what the transformation level was. The split reflects the whole set.

```
Listener tips $5 on the web radio
    ↓
Split equation runs over the full session log
    ↓
DJ receives curator share
Each contributing artist receives their proportional share
    ↓
Each recipient independently chooses: dollars or CRKT
```

### Level 2 — Venue (EBYS + Card Reader)
Same precision as web radio on the backend — EBYS is running, the session log is complete. The difference is the input: a physical card tap instead of a web interface.

The listener taps whenever — at the door, mid-set, on the way out. It doesn't matter. The tip covers the whole set regardless of when the tap happens. There is no timestamp mechanic at the venue. The card reader is a blunt instrument: you tap, you tip, the whole session gets calculated.

```
Listener taps card at any point during the night
    ↓
Protocol retrieves the full session log up to that moment
    ↓
Split equation runs over the whole set
    ↓
DJ and artists split automatically
    ↓
Each recipient chooses: dollars or CRKT
```

The listener sees nothing of the machinery. They tap, they're done.

### Level 3 — Venue (Non-EBYS + Card Reader)
Minimal precision. The card reader knows which DJ is performing. Nothing else. The full tip goes to the DJ — the artists in that set are invisible to the protocol.

```
Listener taps card
    ↓
Full tip goes to the DJ
    ↓
DJ chooses: dollars or CRKT
Artists: not visible, not included
```

---

## The Card Reader

A small physical device at the venue — at the door, at the bar, near the stage. Tap your card or phone. The amount is fixed or tiered ($2 / $5 / custom). Done in one second, no app, no account, no phone screen required.

The reader knows the active session. If EBYS is running, the reader connects to it and the full split machinery operates in the background. If EBYS isn't running, the reader routes the tip to the DJ only.

The DJ chooses their level of precision by choosing their setup. EBYS gives them the full picture. Everything else is a simplified version of the same protocol.

---

## Listener Experience

**Web radio:**
```
[TIP THIS SET]  $1  $5  $10  [custom]
```
Pay by card, Apple Pay, whatever. No account. No crypto. The split happens invisibly.

**Venue:**
```
[tap card or phone on reader]
```
One gesture. No screen interaction. The rest is automatic.

---

## Artist and DJ Experience

After a tipped set, each recipient receives a notification:

```
You received $X.XX from a tip on [set name / date]
→ Cash out to bank
→ Convert to CRKT (cricket protein powder revenue share)
```

Set a default once, never think about it again. Or decide per payout. If they never respond, earnings accumulate in escrow tied to their audio fingerprint — no expiry, no fees.

---

## Protocol Principles

- **Listeners pay in dollars** — no crypto required, ever
- **Artists opt into crypto** — CRKT conversion is a choice, not a default
- **Precision scales with setup** — EBYS gives full split, anything else gives what it can
- **Physical and digital are the same protocol** — card reader and web interface feed the same system
- **Open standard** — any platform or venue can implement the card reader or web interface
