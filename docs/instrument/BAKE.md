# BAKE — Training Loop

Baking is how EBYS learns from a performance. The DJ identifies a sequence they want to reinforce — a specific combination of slices, a transition, an arc that worked — and locks it in. The system captures that loop and uses it to weight future selections: it will prefer paths that resemble what was just baked.

Baking is always DJ-initiated. The engine never bakes on its own.

---

## Commands

| Command | Description |
|---------|-------------|
| `:bakeloop <bars>` | Set the loop window size for the next bake. Default: 4 bars. |
| `:bake start` | Begin capturing the loop. EBYS records exactly what plays for the next `bakeloop` bars across all four stems. |
| `:bake end` | End the capture. The captured sequence is locked in as a positive training example. Index weights update immediately. |
| `:bake abort` | Abandon the capture without writing anything. The loop is discarded. |

---

## What Happens During a Bake

### `:bake start`

EBYS switches to **bake mode**. The current playback continues without interruption. Under the hood, the system begins recording every slice selection: which track, which bar, which descriptor values were matched, what the stay/move decision was.

Visual indicator in the TUI: `[BAKE ACTIVE]` replaces the normal status line.

### `:bake end`

The captured sequence is written to a bake snapshot in `ebys.db`:

```sql
INSERT INTO bake_snapshots (session_id, stem, track_id, slice_id, bar_idx, descriptors)
```

After writing, the index builder re-runs (`build_index.py`) with the bake snapshot as a weighted positive example. Slices that appeared in the snapshot get a preference boost in future nearest-neighbor searches. Transitions that occurred (slice A → slice B on the same stem) get a transition weight boost.

### Effect on Future Selections

After baking:
- Slices in the snapshot appear more frequently in the selection pool
- The transitions that occurred in the baked loop are preferenced over other transitions
- The effect decays over time (exponential decay per bar) unless the DJ bakes again

The bake is not a lock — the engine can still deviate. It's a preference, not a rule. This preserves the generative character of the instrument while allowing the DJ to teach it.

---

## Bake Snapshot Lock

During `:bake start` → `:bake end`, the system locks the current loop in memory. If anything changes the index (a new track ingestion, a `:setMMT` command that retriggers tension calculation), the bake capture continues but is flagged as potentially stale. A stale bake is still written but marked `stale = 1` in the database.

The DJ can inspect bake history:

```
:bakes          list all bake snapshots for this session
:bakes show <n> show the slice sequence from bake n
:bakes clear    remove all bake weights from the index (resets to fresh)
```

---

## The Bakeloop Command

`:bakeloop <bars>` sets the window before calling `:bake start`. If you call `:bake start` without setting the loop first, the default (4 bars) is used.

The bakeloop window determines how much the DJ needs to listen before ending — it's the commitment window. Set it short (1–2 bars) for quick captures of tight transitions. Set it long (8–16 bars) for capturing a full arc.

You cannot change the bakeloop window after `:bake start` — the window is fixed at the moment capture begins.

---

## Practical Use

The bake workflow during performance:

```
1. Notice a great moment — the engine found something unexpected that works
2. :bakeloop 4        (or whatever the moment's length is)
3. :bake start        (the moment has already started — let it finish)
4. (wait 4 bars)
5. :bake end          (the moment is locked in)
6. Continue performing — the engine will find this path again
```

Or, if you want to capture something you're about to create:

```
1. :bakeloop 8        (set up an 8-bar arc)
2. :bake start        (begin — now steer the TUI to create the arc you want)
3. (steer for 8 bars using `:setStayProb`, descriptor weight commands, etc.)
4. :bake end          (the arc you built is now a weighted example)
```

---

## Database Schema

```sql
CREATE TABLE bake_snapshots (
    id          INTEGER PRIMARY KEY,
    session_id  TEXT,
    stem        TEXT,         -- vocals | melody | bass | drums
    track_id    INTEGER,
    slice_id    INTEGER,
    bar_idx     INTEGER,
    descriptors TEXT,         -- JSON: {C, E, F, P, H, T}
    stale       INTEGER DEFAULT 0,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);
```
