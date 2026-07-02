#!/usr/bin/env python3
"""
EBYS Max Patch — Multi-Track Upgrade Script
============================================
Modifies ebys-analyze.maxpat to support multi-source-track playback:

1. Renames play_vocals/drums/bass/melo buffer~/karma~/info~ objects to play_0_* scheme
2. Adds 4 new buffer~ objects for slot 1 (play_1_voc/drm/bss/mel)
3. Adds js slot_router.js object and wires it to karma~ / t b b f / delay objects
4. Removes old route→unpack→*→t b b f routing (replaced by slot_router.js)
5. Removes old (endFrac-startFrac)*f → delay connections (slot_router.js sends segDurMs)
6. Updates load gate: sel 3 → sel 7 (8 buffers = 2 tracks × 4 stems)
7. Updates track_loader status outlet: 5 → 24
8. Connects track_loader slot 1 outlets (5-8) → play_1_* buffers

Run from the MAX/ folder:
    python3 patch_multitrack_upgrade.py
"""

import json, copy, sys, os

PATCH_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ebys-analyze.maxpat")
BACKUP_PATH = PATCH_PATH + ".pre_multitrack.bak"

# ── Load ──────────────────────────────────────────────────────────────────────
with open(PATCH_PATH) as f:
    patch = json.load(f)

boxes = patch["patcher"]["boxes"]
lines = patch["patcher"]["lines"]

# Build lookup maps
id_to_box_wrapper = {b["box"]["id"]: b for b in boxes}  # id → {"box": {...}}
id_to_nbox        = {b["box"]["id"]: b["box"] for b in boxes}
id_to_txt         = {b["box"]["id"]: b["box"].get("text","") for b in boxes}

changes = []

# ─────────────────────────────────────────────────────────────────────────────
# STEP 1 — Rename existing play_* buffer~/karma~/info~ objects to play_0_* scheme
# ─────────────────────────────────────────────────────────────────────────────
RENAMES = {
    # old text           → new text
    "buffer~ play_vocals": "buffer~ play_0_voc",
    "buffer~ play_drums" : "buffer~ play_0_drm",
    "buffer~ play_bass"  : "buffer~ play_0_bss",
    "buffer~ play_melo"  : "buffer~ play_0_mel",
    "karma~ play_vocals" : "karma~ play_0_voc",
    "karma~ play_drums"  : "karma~ play_0_drm",
    "karma~ play_bass"   : "karma~ play_0_bss",
    "karma~ play_melo"   : "karma~ play_0_mel",
    "info~ play_vocals"  : "info~ play_0_voc",
    "info~ play_drums"   : "info~ play_0_drm",
    "info~ play_bass"    : "info~ play_0_bss",
    "info~ play_melo"    : "info~ play_0_mel",
}
for b in boxes:
    nbox = b["box"]
    old = nbox.get("text", "")
    if old in RENAMES:
        nbox["text"] = RENAMES[old]
        changes.append(f"RENAME  {old!r} → {RENAMES[old]!r}  ({nbox['id']})")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2 — Update load gate: sel 3 → sel 7  (8 buffers with 2 tracks)
# ─────────────────────────────────────────────────────────────────────────────
for b in boxes:
    nbox = b["box"]
    if nbox.get("text","") == "sel 3" and nbox["id"] == "obj-9951":
        nbox["text"] = "sel 7"
        changes.append("RENAME  'sel 3' → 'sel 7'  (obj-9951)")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3 — Update track_loader status outlet: 5 → 24
# ─────────────────────────────────────────────────────────────────────────────
for ln in lines:
    pl = ln["patchline"]
    if pl["source"][0] == "obj-9961" and pl["source"][1] == 5:
        pl["source"][1] = 24
        changes.append("OUTLET  track_loader[5]→print  updated to  track_loader[24]→print")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 4 — Remove old patchlines
# ─────────────────────────────────────────────────────────────────────────────
REMOVE_LINES = [
    # (src_id, src_port, dst_id, dst_port)
    # route vocals/drums/bass/melody → unpack objects (replaced by slot_router)
    ("obj-554", 0, "obj-12",  0),
    ("obj-554", 1, "obj-45",  0),
    ("obj-554", 2, "obj-161", 0),
    ("obj-554", 3, "obj-186", 0),
    # startFrac*f → t b b f  (replaced by slot_router outlet 1/4/7/10)
    ("obj-19",  0, "obj-25",  0),   # vocals
    ("obj-52",  0, "obj-54",  0),   # drums
    ("obj-160", 0, "obj-61",  0),   # melody
    ("obj-185", 0, "obj-172", 0),   # bass
    # (endFrac-startFrac)*f → delay right inlet  (replaced by slot_router segDurMs)
    ("obj-21",  0, "obj-28",  1),   # vocals delay time
    ("obj-49",  0, "obj-53",  1),   # drums delay time
    ("obj-76",  0, "obj-63",  1),   # melody delay time
    ("obj-183", 0, "obj-187", 1),   # bass delay time
]

def make_key(src_id, src_port, dst_id, dst_port):
    return (src_id, src_port, dst_id, dst_port)

remove_set = set(make_key(*r) for r in REMOVE_LINES)
original_count = len(lines)
lines[:] = [
    ln for ln in lines
    if make_key(
        ln["patchline"]["source"][0], ln["patchline"]["source"][1],
        ln["patchline"]["destination"][0], ln["patchline"]["destination"][1]
    ) not in remove_set
]
removed = original_count - len(lines)
changes.append(f"REMOVE  {removed} patchlines (route→unpack and *→t b b f and -→delay)")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 5 — Add new buffer~ objects for slot 1
# ─────────────────────────────────────────────────────────────────────────────
NEW_BUFFERS = [
    ("obj-9978", "buffer~ play_1_voc", [1228.0, 310.0, 150.0, 22.0]),
    ("obj-9979", "buffer~ play_1_drm", [1770.0, 310.0, 150.0, 22.0]),
    ("obj-9980", "buffer~ play_1_bss", [2360.0, 310.0, 150.0, 22.0]),
    ("obj-9981", "buffer~ play_1_mel", [2947.0, 310.0, 150.0, 22.0]),
]
for bid, txt, rect in NEW_BUFFERS:
    boxes.append({"box": {
        "id": bid,
        "maxclass": "newobj",
        "numinlets": 1,
        "numoutlets": 2,
        "outlettype": ["signal", "bang"],
        "patching_rect": rect,
        "text": txt,
    }})
    changes.append(f"ADD     {txt}  ({bid})")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 6 — Add js slot_router.js object
# ─────────────────────────────────────────────────────────────────────────────
SLOT_ROUTER_ID = "obj-9982"
boxes.append({"box": {
    "id": SLOT_ROUTER_ID,
    "maxclass": "newobj",
    "numinlets": 1,
    "numoutlets": 12,
    "outlettype": ["", "", "", "", "", "", "", "", "", "", "", ""],
    "patching_rect": [47.78761446475983, 1140.0, 130.0, 22.0],
    "text": "js slot_router.js",
}})
changes.append(f"ADD     js slot_router.js  ({SLOT_ROUTER_ID})")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 7 — Add new patchlines
# ─────────────────────────────────────────────────────────────────────────────
# (src_id, src_port, dst_id, dst_port)
ADD_LINES = [
    # track_loader slot 1 outlets → play_1_* buffers
    ("obj-9961", 5, "obj-9978", 0),
    ("obj-9961", 6, "obj-9979", 0),
    ("obj-9961", 7, "obj-9980", 0),
    ("obj-9961", 8, "obj-9981", 0),
    # play_1_* done-bangs → load gate counter
    ("obj-9978", 1, "obj-9950", 0),
    ("obj-9979", 1, "obj-9950", 0),
    ("obj-9980", 1, "obj-9950", 0),
    ("obj-9981", 1, "obj-9950", 0),
    # slicer outlet 0 → slot_router inlet 0
    ("obj-551", 0, SLOT_ROUTER_ID, 0),
    # slot_router → karma~ (buffer switch via 'set play_N_stem' messages)
    (SLOT_ROUTER_ID,  0, "obj-710",  0),   # vocals:  set play_N_voc → karma~ play_0_voc
    (SLOT_ROUTER_ID,  3, "obj-800",  0),   # melody:  set play_N_mel → karma~ play_0_mel
    (SLOT_ROUTER_ID,  6, "obj-770",  0),   # bass:    set play_N_bss → karma~ play_0_bss
    (SLOT_ROUTER_ID,  9, "obj-740",  0),   # drums:   set play_N_drm → karma~ play_0_drm
    # slot_router → t b b f (seek sample position)
    (SLOT_ROUTER_ID,  1, "obj-25",   0),   # vocals
    (SLOT_ROUTER_ID,  4, "obj-61",   0),   # melody
    (SLOT_ROUTER_ID,  7, "obj-172",  0),   # bass
    (SLOT_ROUTER_ID, 10, "obj-54",   0),   # drums
    # slot_router → delay right inlet (segDurMs sets delay time)
    (SLOT_ROUTER_ID,  2, "obj-28",   1),   # vocals delay
    (SLOT_ROUTER_ID,  5, "obj-63",   1),   # melody delay
    (SLOT_ROUTER_ID,  8, "obj-187",  1),   # bass delay
    (SLOT_ROUTER_ID, 11, "obj-53",   1),   # drums delay
]

for src_id, src_port, dst_id, dst_port in ADD_LINES:
    lines.append({"patchline": {
        "destination": [dst_id, dst_port],
        "source":      [src_id, src_port],
    }})
changes.append(f"ADD     {len(ADD_LINES)} patchlines (slot_router wiring + track_loader slot 1 + load gate)")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 8 — Write backup + updated patch
# ─────────────────────────────────────────────────────────────────────────────
import shutil
shutil.copy(PATCH_PATH, BACKUP_PATH)
print(f"Backup written: {BACKUP_PATH}")

with open(PATCH_PATH, "w") as f:
    json.dump(patch, f, indent=4)
print(f"Patch written:  {PATCH_PATH}")

print(f"\n{len(changes)} change(s) applied:")
for c in changes:
    print(f"  {c}")

print("\nDone. Open ebys-analyze.maxpat in Max to verify.")
