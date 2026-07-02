#!/usr/bin/env python3
"""
EBYS Max Patch — Bake Snapshot Upgrade Script
==============================================
Adds ring buffer snapshot/restore infrastructure for the bake training system.

4 snap buffers (one per stem) + 4 shared fluid.bufcompose~ objects.
The same 4 bufcompose~ are reused for both directions (ring→snap and snap→ring)
since bakeSnapshot and bakeRestore never overlap.

buffer_manager.js saves which ring slot was active at snapshot time and
resets the active/staging pointers on restore.

Changes applied:
  1.  Add 4 buffer~ snap_stem objects (5000ms)
  2.  Add 4 shared fluid.bufcompose~ for bake copies (outlets 14–17)
  3.  Update buffer_manager.js outlet count: 14 → 18
  4.  Wire ws_server outlet 0 → buffer_manager inlet 0 (fan-out)
  5.  Wire buffer_manager outlets 14–17 → bake bufcompose~

Run from the MAX/ folder:
    python3 patch_bake_snapshot.py
"""

import json, shutil, os

PATCH_PATH  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ebys-analyze.maxpat")
BACKUP_PATH = PATCH_PATH + ".pre_bake_snapshot.bak"

with open(PATCH_PATH) as f:
    patch = json.load(f)

boxes = patch["patcher"]["boxes"]
lines = patch["patcher"]["lines"]
changes = []

BM_ID        = "obj-9961"
WS_SERVER_ID = "obj-4030"

# ── STEP 1: Update buffer_manager outlet count 14 → 18 ───────────────────────
for b in boxes:
    nbox = b["box"]
    if nbox["id"] == BM_ID:
        nbox["numoutlets"] = 18
        nbox["outlettype"] = [""] * 18
        changes.append("UPDATE  buffer_manager.js outlets 14 → 18")

# ── STEP 2: Add 4 snap buffer~ objects ───────────────────────────────────────
SNAP_BUFS = [
    ("obj-10009", "buffer~ snap_voc 5000", [1100.0, 342.0, 150.0, 22.0]),
    ("obj-10010", "buffer~ snap_drm 5000", [1640.0, 342.0, 150.0, 22.0]),
    ("obj-10011", "buffer~ snap_bss 5000", [2180.0, 342.0, 150.0, 22.0]),
    ("obj-10012", "buffer~ snap_mel 5000", [2730.0, 342.0, 150.0, 22.0]),
]
for bid, txt, rect in SNAP_BUFS:
    boxes.append({"box": {
        "id": bid, "maxclass": "newobj",
        "numinlets": 1, "numoutlets": 2,
        "outlettype": ["signal", "bang"],
        "patching_rect": rect, "text": txt,
    }})
    changes.append(f"ADD     {txt}  ({bid})")

# ── STEP 3: Add 4 shared bake bufcompose~ objects ────────────────────────────
BAKE_COMP = [
    ("obj-10013", [1100.0, 400.0, 130.0, 22.0]),  # voc  outlet 14
    ("obj-10014", [1640.0, 400.0, 130.0, 22.0]),  # drm  outlet 15
    ("obj-10015", [2180.0, 400.0, 130.0, 22.0]),  # bss  outlet 16
    ("obj-10016", [2730.0, 400.0, 130.0, 22.0]),  # mel  outlet 17
]
for bid, rect in BAKE_COMP:
    boxes.append({"box": {
        "id": bid, "maxclass": "newobj",
        "numinlets": 1, "numoutlets": 1,
        "outlettype": ["bang"],
        "patching_rect": rect, "text": "fluid.bufcompose~",
    }})
    changes.append(f"ADD     fluid.bufcompose~ (bake)  ({bid})")

# ── STEP 4: Wire ws_server outlet 0 → buffer_manager inlet 0 ─────────────────
lines.append({"patchline": {
    "source":      [WS_SERVER_ID, 0],
    "destination": [BM_ID,        0],
}})
changes.append("WIRE    ws_server[0] → buffer_manager[0]")

# ── STEP 5: Wire buffer_manager outlets 14–17 → bake bufcompose~ ─────────────
for i, (bid, _) in enumerate(BAKE_COMP):
    lines.append({"patchline": {
        "source":      [BM_ID, 14 + i],
        "destination": [bid,   0],
    }})
    changes.append(f"WIRE    buffer_manager[{14 + i}] → {bid}")

# ── Write ─────────────────────────────────────────────────────────────────────
shutil.copy(PATCH_PATH, BACKUP_PATH)
print(f"Backup: {BACKUP_PATH}")

with open(PATCH_PATH, "w") as f:
    json.dump(patch, f, indent=4)
print(f"Written: {PATCH_PATH}")

print(f"\n{len(changes)} change(s) applied:")
for c in changes:
    print(f"  {c}")
print("\nDone. Reload ebys-analyze.maxpat in Max.")
