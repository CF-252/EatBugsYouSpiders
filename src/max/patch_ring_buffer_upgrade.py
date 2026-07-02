#!/usr/bin/env python3
"""
EBYS Max Patch — Ring Buffer + bufcompose~ Upgrade Script
==========================================================
Transforms the patch from the multi-track state (play_0/1_* buffers) to
the two-level ring buffer + fluid.bufcompose~ architecture:

  Level 1 — src_N_stem buffers (8 total, full tracks, disk-loaded on demand)
  Level 2 — ring_N_stem buffers (8 total, pre-allocated 5s, segment-sized copies)

Changes applied:
  1.  Rename buffer~ play_0/1_* → src_0/1_*
  2.  Rename karma~  play_0_*   → karma~ ring_0_*   (initial buffer name)
  3.  Rename info~   play_0_*   → info~  ring_0_*
  4.  Rename js track_loader.js → js buffer_manager.js (update outlet count to 14)
  5.  Remove load gate objects (counter, sel 7, t b b b, msg boxes)
  6.  Remove track_loader UI objects (umenu, prepend load, print)
  7.  Remove dead route object (obj-554)
  8.  Remove all patchlines involving removed objects, plus:
      slicer[0]→slot_router and track_loader slot-1 connections
  9.  Add 8 ring buffer~ objects pre-allocated at 5000ms
  10. Add 4 fluid.bufcompose~ objects
  11. Add 8 prepend objects for src buffer done-bangs
  12. Add 4 prepend objects for bufcompose done-bangs
  13. Wire: slicer[0,1]→buffer_manager, buffer_manager→src/bufcompose/slot_router,
      done-bangs→prepend→buffer_manager

Run from the MAX/ folder:
    python3 patch_ring_buffer_upgrade.py
"""

import json, shutil, os

PATCH_PATH  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ebys-analyze.maxpat")
BACKUP_PATH = PATCH_PATH + ".pre_ringbuf.bak"

with open(PATCH_PATH) as f:
    patch = json.load(f)

boxes = patch["patcher"]["boxes"]
lines = patch["patcher"]["lines"]

changes = []

# ── STEP 1: Rename text of existing objects ───────────────────────────────────
RENAMES = {
    "buffer~ play_0_voc": "buffer~ src_0_voc",
    "buffer~ play_0_drm": "buffer~ src_0_drm",
    "buffer~ play_0_bss": "buffer~ src_0_bss",
    "buffer~ play_0_mel": "buffer~ src_0_mel",
    "buffer~ play_1_voc": "buffer~ src_1_voc",
    "buffer~ play_1_drm": "buffer~ src_1_drm",
    "buffer~ play_1_bss": "buffer~ src_1_bss",
    "buffer~ play_1_mel": "buffer~ src_1_mel",
    "karma~ play_0_voc":  "karma~ ring_0_voc",
    "karma~ play_0_drm":  "karma~ ring_0_drm",
    "karma~ play_0_bss":  "karma~ ring_0_bss",
    "karma~ play_0_mel":  "karma~ ring_0_mel",
    "info~ play_0_voc":   "info~ ring_0_voc",
    "info~ play_0_drm":   "info~ ring_0_drm",
    "info~ play_0_bss":   "info~ ring_0_bss",
    "info~ play_0_mel":   "info~ ring_0_mel",
}
for b in boxes:
    nbox = b["box"]
    old  = nbox.get("text", "")
    if old in RENAMES:
        nbox["text"] = RENAMES[old]
        changes.append(f"RENAME  {old!r} → {RENAMES[old]!r}  ({nbox['id']})")

# ── STEP 2: Update js track_loader → buffer_manager (text + outlet count) ────
BM_ID = "obj-9961"   # reuse the same object, just retextured
for b in boxes:
    nbox = b["box"]
    if nbox["id"] == BM_ID and "track_loader" in nbox.get("text", ""):
        nbox["text"]        = "js buffer_manager.js"
        nbox["numoutlets"]  = 14
        nbox["outlettype"]  = [""] * 14
        changes.append(f"UPDATE  obj-9961 → js buffer_manager.js  (14 outlets)")

# ── STEP 3: Remove obsolete objects ──────────────────────────────────────────
REMOVE_IDS = {
    "obj-9950",  # counter (load gate)
    "obj-9951",  # sel 7
    "obj-9952",  # t b b b
    "obj-9953",  # message buildIndex
    "obj-9954",  # delay 500
    "obj-9955",  # comment (may not exist)
    "obj-9956",  # message start
    "obj-9962",  # umenu (track_loader UI)
    "obj-9963",  # prepend load
    "obj-9964",  # print track_loader
    "obj-554",   # route vocals drums bass melody (dead end)
}
before = len(boxes)
boxes[:] = [b for b in boxes if b["box"]["id"] not in REMOVE_IDS]
changes.append(f"REMOVE  {before - len(boxes)} objects  (load gate + track_loader UI + route)")

# ── STEP 4: Remove obsolete patchlines ───────────────────────────────────────
REMOVE_EXACT = {
    # slicer direct → slot_router (now goes through buffer_manager)
    ("obj-551",  0, "obj-9982", 0),
    # slicer → dead route object
    ("obj-551",  0, "obj-554",  0),
    # track_loader slot-1 outlets → play_1_* (now wired from buffer_manager)
    ("obj-9961", 5, "obj-9978", 0),
    ("obj-9961", 6, "obj-9979", 0),
    ("obj-9961", 7, "obj-9980", 0),
    ("obj-9961", 8, "obj-9981", 0),
    # play_1_* done-bangs → old counter
    ("obj-9978", 1, "obj-9950", 0),
    ("obj-9979", 1, "obj-9950", 0),
    ("obj-9980", 1, "obj-9950", 0),
    ("obj-9981", 1, "obj-9950", 0),
}

def lkey(ln):
    pl = ln["patchline"]
    return (pl["source"][0], pl["source"][1],
            pl["destination"][0], pl["destination"][1])

def touches_removed(ln):
    pl = ln["patchline"]
    return pl["source"][0] in REMOVE_IDS or pl["destination"][0] in REMOVE_IDS

before_l = len(lines)
lines[:] = [ln for ln in lines
            if lkey(ln) not in REMOVE_EXACT and not touches_removed(ln)]
changes.append(f"REMOVE  {before_l - len(lines)} patchlines")

# ── STEP 5: Add ring buffer~ objects (pre-allocated 5000 ms each) ─────────────
NEW_RING = [
    ("obj-9983", "buffer~ ring_0_voc 5000", [1100.0, 260.0, 150.0, 22.0]),
    ("obj-9984", "buffer~ ring_1_voc 5000", [1260.0, 260.0, 150.0, 22.0]),
    ("obj-9985", "buffer~ ring_0_drm 5000", [1640.0, 260.0, 150.0, 22.0]),
    ("obj-9986", "buffer~ ring_1_drm 5000", [1800.0, 260.0, 150.0, 22.0]),
    ("obj-9987", "buffer~ ring_0_bss 5000", [2180.0, 260.0, 150.0, 22.0]),
    ("obj-9988", "buffer~ ring_1_bss 5000", [2340.0, 260.0, 150.0, 22.0]),
    ("obj-9989", "buffer~ ring_0_mel 5000", [2730.0, 260.0, 150.0, 22.0]),
    ("obj-9990", "buffer~ ring_1_mel 5000", [2890.0, 260.0, 150.0, 22.0]),
]
for bid, txt, rect in NEW_RING:
    boxes.append({"box": {
        "id": bid, "maxclass": "newobj",
        "numinlets": 1, "numoutlets": 2,
        "outlettype": ["signal", "bang"],
        "patching_rect": rect, "text": txt,
    }})
    changes.append(f"ADD     {txt}  ({bid})")

# ── STEP 6: Add fluid.bufcompose~ objects (one per stem) ──────────────────────
NEW_COMPOSE = [
    ("obj-9992", "fluid.bufcompose~", [1100.0, 1160.0, 130.0, 22.0]),
    ("obj-9993", "fluid.bufcompose~", [1640.0, 1160.0, 130.0, 22.0]),
    ("obj-9994", "fluid.bufcompose~", [2180.0, 1160.0, 130.0, 22.0]),
    ("obj-9995", "fluid.bufcompose~", [2730.0, 1160.0, 130.0, 22.0]),
]
for bid, txt, rect in NEW_COMPOSE:
    boxes.append({"box": {
        "id": bid, "maxclass": "newobj",
        "numinlets": 1, "numoutlets": 1,
        "outlettype": ["bang"],
        "patching_rect": rect, "text": txt,
    }})
    changes.append(f"ADD     {txt}  ({bid})")

# ── STEP 7: Add prepend objects for done-bang tagging ─────────────────────────
NEW_PREPENDS = [
    # src buffer done-bangs (8 prepends)
    ("obj-9997",  "prepend src_done voc 0", [1100.0, 360.0, 140.0, 22.0]),
    ("obj-9998",  "prepend src_done voc 1", [1260.0, 360.0, 140.0, 22.0]),
    ("obj-9999",  "prepend src_done drm 0", [1640.0, 360.0, 140.0, 22.0]),
    ("obj-10000", "prepend src_done drm 1", [1800.0, 360.0, 140.0, 22.0]),
    ("obj-10001", "prepend src_done bss 0", [2180.0, 360.0, 140.0, 22.0]),
    ("obj-10002", "prepend src_done bss 1", [2340.0, 360.0, 140.0, 22.0]),
    ("obj-10003", "prepend src_done mel 0", [2730.0, 360.0, 140.0, 22.0]),
    ("obj-10004", "prepend src_done mel 1", [2890.0, 360.0, 140.0, 22.0]),
    # bufcompose~ done-bangs (4 prepends)
    ("obj-10005", "prepend ring_done voc",  [1100.0, 1210.0, 130.0, 22.0]),
    ("obj-10006", "prepend ring_done drm",  [1640.0, 1210.0, 130.0, 22.0]),
    ("obj-10007", "prepend ring_done bss",  [2180.0, 1210.0, 130.0, 22.0]),
    ("obj-10008", "prepend ring_done mel",  [2730.0, 1210.0, 130.0, 22.0]),
]
for bid, txt, rect in NEW_PREPENDS:
    boxes.append({"box": {
        "id": bid, "maxclass": "newobj",
        "numinlets": 1, "numoutlets": 1,
        "outlettype": [""],
        "patching_rect": rect, "text": txt,
    }})
    changes.append(f"ADD     {txt}  ({bid})")

# ── STEP 8: Wire everything ───────────────────────────────────────────────────
# Object ID maps
SRC_IDS  = { "voc": ("obj-9970","obj-9978"), "drm": ("obj-9971","obj-9979"),
             "bss": ("obj-9972","obj-9980"), "mel": ("obj-9973","obj-9981") }
RING_IDS = { "voc": ("obj-9983","obj-9984"), "drm": ("obj-9985","obj-9986"),
             "bss": ("obj-9987","obj-9988"), "mel": ("obj-9989","obj-9990") }
COMP_IDS = { "voc": "obj-9992", "drm": "obj-9993",
             "bss": "obj-9994", "mel": "obj-9995" }
PRE_SRC  = { "voc": ("obj-9997","obj-9998"),  "drm": ("obj-9999","obj-10000"),
             "bss": ("obj-10001","obj-10002"), "mel": ("obj-10003","obj-10004") }
PRE_RING = { "voc": "obj-10005", "drm": "obj-10006",
             "bss": "obj-10007", "mel": "obj-10008" }

# buffer_manager src outlets: voc→(0,1), drm→(2,3), bss→(4,5), mel→(6,7)
BM_SRC_OUT  = { "voc": (0,1), "drm": (2,3), "bss": (4,5), "mel": (6,7) }
# buffer_manager compose outlets: voc→8, drm→9, bss→10, mel→11
BM_COMP_OUT = { "voc": 8, "drm": 9, "bss": 10, "mel": 11 }

BM = BM_ID   # "obj-9961"
SLICER = "obj-551"
SLOT_ROUTER = "obj-9982"

ADD_LINES = [
    # slicer outlet 0 → buffer_manager (play + preload messages)
    (SLICER, 0, BM, 0),
    # slicer outlet 1 → buffer_manager (sourceTrack slot→name mapping)
    (SLICER, 1, BM, 0),
    # buffer_manager outlet 12 → slot_router
    (BM, 12, SLOT_ROUTER, 0),
]

STEMS = ["voc", "drm", "bss", "mel"]
for sh in STEMS:
    out0, out1 = BM_SRC_OUT[sh]
    src0, src1 = SRC_IDS[sh]
    pre0, pre1 = PRE_SRC[sh]

    # buffer_manager → src_0 and src_1 (disk load commands)
    ADD_LINES.append((BM, out0, src0, 0))
    ADD_LINES.append((BM, out1, src1, 0))

    # buffer_manager → fluid.bufcompose~ (copy params + bang)
    ADD_LINES.append((BM, BM_COMP_OUT[sh], COMP_IDS[sh], 0))

    # src_0 done-bang → prepend → buffer_manager
    ADD_LINES.append((src0, 1, pre0, 0))
    ADD_LINES.append((pre0, 0, BM,   0))

    # src_1 done-bang → prepend → buffer_manager
    ADD_LINES.append((src1, 1, pre1, 0))
    ADD_LINES.append((pre1, 0, BM,   0))

    # bufcompose~ done-bang → prepend → buffer_manager
    ADD_LINES.append((COMP_IDS[sh], 0, PRE_RING[sh], 0))
    ADD_LINES.append((PRE_RING[sh], 0, BM,           0))

for src_id, src_port, dst_id, dst_port in ADD_LINES:
    lines.append({"patchline": {
        "source":      [src_id, src_port],
        "destination": [dst_id, dst_port],
    }})
changes.append(f"ADD     {len(ADD_LINES)} patchlines")

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
