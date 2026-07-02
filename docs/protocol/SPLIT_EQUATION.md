# Split Equation

How a tip is divided between the DJ and every contributing artist.

---

## Participants

A **DJ** curates a set. They choose tracks, configure EBYS, perform.

**Artists** are everyone whose work contributed to what played. They may not be present, may not know the set happened, may not even know what EBYS is.

When a listener tips, money flows to both — automatically.

---

## The L0–L4 Transformation Ladder

Every slice EBYS plays occupies a transformation level based on how far it is from the original source material.

| Level | Description | Artist share direction |
|-------|-------------|----------------------|
| **L0** | Verbatim — original unchanged | Artist gets max |
| **L1** | Minor variation — EQ, transposition < 3 semitones | Artist still central |
| **L2** | Moderate transformation — time stretch, moderate pitch | Shared |
| **L3** | Significant transformation — composite, heavy FX, multi-stem blend | DJ gains |
| **L4** | Full synthesis — no recognizable source | DJ gets max |

The transformation level is computed per-slice by the session log. Each bar of music has a level. The tip multiplier for the DJ vs. artist tracks with level.

---

## The Follow Graph

EBYS has a follow graph: a directional graph where **following** means "I acknowledge influence and accept split participation."

An artist who doesn't follow doesn't participate in the split, even if their track plays. Following is not automatic — it's an explicit opt-in.

**If an artist is not in the follow graph:** their slice contribution is zero for the split. Their music may still play (EBYS doesn't filter it), but the portion of the tip that would have gone to them goes to the DJ instead (or accumulates in escrow, if the protocol is in claim mode).

**Claim mode:** unclaimed splits are held in escrow tied to the track's audio fingerprint. When the artist eventually joins, everything waiting for them is available. No expiry.

---

## Influence Score

For each contributing artist *a* in the follow graph, over the session S:

```
raw_influence(a) = Σ (bar_duration × L_factor(bar) × track_weight(a, bar))
```

Where:
- `bar_duration` = length of the bar in seconds
- `L_factor(bar)` = artist share factor at that transformation level (1.0 at L0, 0.0 at L4)
- `track_weight(a, bar)` = fraction of the bar's audio that came from artist *a*'s tracks

Then normalized:

```
influence_score(a) = raw_influence(a) / Σ raw_influence(all artists)
```

---

## DJ Curator Share

The DJ receives a curator share that scales with transformation level. For the session:

```
curator_share_pct = avg(L_factor_inverse(bar) × bar_weight) over all bars
```

Where `L_factor_inverse` = 1 − L_factor. At L0, curator share is near zero. At L4, curator share is near total.

Minimum curator share is always ≥ 10% regardless of transformation level. The DJ is always compensated for the act of curation.

---

## The Three-Way Split

For a tip of amount T:

```
1. Curator share   → DJ = T × max(curator_share_pct, 0.10)
2. Artist pool     = T − DJ share
3. Per-artist      → artist_a = artist_pool × influence_score(a)
```

---

## The ▲⬢▼ Notation

The deck displays the current transformation state as a triangle notation:

```
▲  Rising arc     — building toward higher transformation
⬢  Plateau        — holding transformation level
▼  Falling arc    — returning toward source material
```

This is not just cosmetic. When transformation arcs are tracked across the set, the "narrative shape" — how the transformation evolved — can become a second-order input to split calculation. A set that starts at L0, rises to L3, and returns to L0 demonstrates deliberate curation arc, and the DJ's curator share reflects that.

*(This part of the split is currently planned, not implemented.)*

---

## Worked Example

**Scenario:** 40-minute set. Three artists (A, B, C) in the follow graph. One listener tips $10.

Session breakdown:
- 20 min: Artist A tracks, mostly L1 transformation (A gets ~0.85 per bar, DJ ~0.15)
- 10 min: Artists A+B blended at L2 (A+B share ~0.50 each per bar, DJ ~0.50)
- 10 min: Full composite L3 (DJ gets ~0.80, A+B+C split ~0.20)

Raw computation (simplified):
```
A influence: (20×0.85 + 10×0.25 + 10×0.0667) = 17 + 2.5 + 0.667 = 20.167
B influence: (0 + 10×0.25 + 10×0.0667)        = 0 + 2.5 + 0.667  = 3.167
C influence: (0 + 0 + 10×0.0667)               = 0.667
Total influence: 24.0

DJ curator share: avg(0.15×20min + 0.50×10min + 0.80×10min) / 40min
                = (3 + 5 + 8) / 40 = 0.40 → 40%

DJ receives:    $10 × 0.40          = $4.00
Artist pool:    $10 − $4.00         = $6.00

A receives: $6.00 × (20.167/24.0)   = $5.04
B receives: $6.00 × (3.167/24.0)    = $0.79
C receives: $6.00 × (0.667/24.0)    = $0.17
```

Total: $4.00 + $5.04 + $0.79 + $0.17 = **$10.00** ✓

---

## Implementation

The split equation runs in `tip.js` on the backend at `/api/tip`. It reads from the session log in `ebys.db` (table: `session_bars`, columns: `track_id`, `transformation_level`, `bar_start`, `bar_duration`). Follow graph is in the `follows` table.

Current status: split calculated but artist transfers blocked pending Stripe Connect onboarding. DJ share flows through immediately.
