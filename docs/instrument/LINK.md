# EBYS LINK Protocol

EBYS LINK is the multi-deck synchronization layer. When two or more EBYS decks are running in the same performance context — same room, same session, same network — LINK coordinates their timing, transformation arcs, and (optionally) their slice selections.

---

## What LINK Does

Without LINK, each EBYS deck is autonomous. It runs its own bar clock, selects its own slices, maintains its own transformation state. Two decks performing together drift unless manually synchronized.

With LINK active:
- **All decks share a bar clock.** Bar boundaries are synchronized. When one deck fires a segment, all decks fire on the same bar grid.
- **Transformation arcs are visible across decks.** Each deck can see what transformation level the other decks are at. A DJ on deck 2 who sees deck 1 rising toward L3 might choose to hold at L1 — creating contrast rather than collision.
- **Slice selections can coordinate.** Two decks can be set to avoid playing the same track simultaneously, or to specifically mirror each other (unison mode).

---

## The Missile Switch

The missile switch is LINK's dramatic control: a two-key confirmation (like a nuclear launch sequence) that synchronizes all connected decks to a specific state simultaneously.

```
:link arm      (arms the missile switch — both DJs must confirm)
:link fire     (second DJ confirms — all decks sync immediately)
:link abort    (cancel the armed state)
```

The missile switch is used at peak moments: two decks dropping to L0 simultaneously, or both going L4 together for a full composite blast. Without the missile switch, transitions are independent. With it, they're synchronized for maximum impact.

---

## Sync Layers

LINK operates on three layers of synchronization:

**Layer 1 — Clock sync:** All decks share the same bar grid. This is always on when LINK is active. A late-joining deck quantizes its next segment start to the existing grid.

**Layer 2 — Arc sync:** Decks share transformation level information. Each deck's TUI shows a small sidebar with other decks' current levels. DJs can choose to coordinate or contrast, but they can see each other's state.

**Layer 3 — Selection sync:** Decks can coordinate slice selection. Modes:
- `avoid` — never play the same track as another deck simultaneously
- `mirror` — try to play the same track as another deck (unison feel)
- `complement` — play complementary descriptor neighborhoods (high-energy + low-energy, or melodic + rhythmic)

Layer 3 is always off by default. It requires explicit activation by both decks.

---

## Commands

```
:link on                    Activate LINK (discover decks on local network)
:link off                   Deactivate LINK (revert to autonomous)
:link status                Show connected decks, their transformation levels, sync mode
:link mode avoid|mirror|complement|off   Set Layer 3 sync mode
:link arm                   Arm the missile switch
:link fire                  Execute the missile switch (requires all armed decks to fire)
:link abort                 Abort armed missile switch
```

---

## The ▲⬢▼ Display in LINK Context

When LINK is active, the TUI displays all connected decks' transformation states:

```
DECK 1  [you]   VOCALS L2 ▲  MELODY L2 ⬢  BASS L1 ⬢  DRUMS L0 ▼
DECK 2  [DJ_B]  VOCALS L3 ▲  MELODY L2 ▲  BASS L2 ▲  DRUMS L1 ▲
```

Deck 2 is rising across all stems — they're heading toward L3/L4 territory. As DJ on deck 1, you can choose to:
- Match the arc (both decks together toward peak transformation)
- Hold at L1 (counterpoint — calm beneath their chaos)
- Drop to L0 (maximum contrast — clean source beneath their synthesis)

LINK makes these choices visible and coordinated. Without LINK, each DJ is working in the dark about what the other is doing.

---

## Network Protocol

LINK uses UDP multicast on the local network. Each deck broadcasts its state (bar count, transformation levels per stem, session ID) at the bar boundary. All decks listen for broadcasts from others.

No central coordinator. Any deck can join or leave without affecting the others. The clock sync is leader-based: the first deck to start a session is the clock leader. If the leader disconnects, the deck with the longest uptime takes over.

**Security:** LINK is local-network only. There is no internet-based LINK. Sessions are identified by a random session token broadcast in the state packet — decks only synchronize with others that share the same token.

---

## Status

LINK is designed but not fully implemented. Clock sync is implemented. Arc visibility (Layer 2) is in progress. The missile switch mechanic is designed but not yet wired. Layer 3 selection sync is designed, not started.
