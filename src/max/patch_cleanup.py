#!/usr/bin/env python3
"""
EBYS Max Patch — Dead Object Cleanup Script
============================================
Removes 25 dead objects left over from the multitrack upgrade.
These are the old segment-duration calculation chains
(unpack f f f → * → -) that were disconnected but never deleted
when slot_router.js took over that responsibility.

Dead objects removed:
  4 × unpack f f f  (no inputs)
  8 × *             (fed by unpack, output to dead -)
  4 × -             (no outputs)
  9 × label boxes   (durMs / endMs / StartMs, all orphaned)

Run from the MAX/ folder:
    python3 patch_cleanup.py
"""

import json, shutil, os

PATCH_PATH  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ebys-analyze.maxpat")
BACKUP_PATH = PATCH_PATH + ".pre_cleanup.bak"

with open(PATCH_PATH) as f:
    patch = json.load(f)

boxes = patch["patcher"]["boxes"]
lines = patch["patcher"]["lines"]

DEAD_IDS = {
    # unpack f f f — no inputs, only feed dead chains
    "obj-186", "obj-161", "obj-45", "obj-12",
    # * multipliers — fed by unpack, output only to dead -
    "obj-184", "obj-185",   # bass stem
    "obj-159", "obj-160",   # melody stem
    "obj-51",  "obj-52",    # drums stem
    "obj-19",  "obj-20",    # vocals stem
    # - subtractors — no outputs at all
    "obj-183", "obj-76", "obj-49", "obj-21",
    # orphaned label boxes
    "obj-174", "obj-178", "obj-180",   # bass:    durMs / endMs / StartMs
    "obj-64",  "obj-65",  "obj-66",    # drums:   durMs / endMs / StartMs
    "obj-32",  "obj-31",  "obj-29",    # vocals:  durMs / endMs / StartMs
}

before_boxes = len(boxes)
before_lines = len(lines)

boxes[:] = [b for b in boxes if b["box"]["id"] not in DEAD_IDS]
lines[:] = [ln for ln in lines
            if ln["patchline"]["source"][0]      not in DEAD_IDS
            and ln["patchline"]["destination"][0] not in DEAD_IDS]

removed_boxes = before_boxes - len(boxes)
removed_lines = before_lines - len(lines)

shutil.copy(PATCH_PATH, BACKUP_PATH)
print(f"Backup: {BACKUP_PATH}")

with open(PATCH_PATH, "w") as f:
    json.dump(patch, f, indent=4)
print(f"Written: {PATCH_PATH}")
print(f"\nRemoved {removed_boxes} dead objects and {removed_lines} patchlines.")
print(f"Patch: {len(boxes)} objects, {len(lines)} lines remaining.")
print("\nDone. Reload ebys-analyze.maxpat in Max.")
