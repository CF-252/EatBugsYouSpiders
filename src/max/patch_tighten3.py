#!/usr/bin/env python3
"""
EBYS Max Patch — Tighten-Up #3
================================
Fixes the double library-send / double t-SNE bug on patch load.

Root cause
----------
node.script ws_server.js already has @autostart 1, so ws_server starts the
instant the patch loads. A second path existed:

    loadbang (obj-437)  →  delay 2000  →  script start  →  ws_server

This fires a 'script start' 2 s after load — restarting ws_server mid-way
through the first buildIndex cycle. The TUI detects the disconnect,
reconnects, and sends another buildIndex 1.5 s later, triggering a second
full boot: 521 library chunks × 2, t-SNE × 2.

Fix: remove obj-437 (loadbang). The manual-restart button (obj-10) still
feeds the same delay 2000 → script start chain and is untouched.

Run from the MAX/ folder:
    python3 patch_tighten3.py
"""

import json, shutil, os

PATCH_PATH  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ebys-analyze.maxpat")
BACKUP_PATH = PATCH_PATH + ".pre_tighten3.bak"

with open(PATCH_PATH) as f:
    patch = json.load(f)

boxes  = patch["patcher"]["boxes"]
lines  = patch["patcher"]["lines"]
changes = []

DEAD_IDS = {"obj-437"}   # loadbang that auto-restarts ws_server 2s after load

before_boxes = len(boxes)
boxes[:] = [b for b in boxes if b["box"]["id"] not in DEAD_IDS]
removed_boxes = before_boxes - len(boxes)
changes.append(f"REMOVED {removed_boxes} object(s): {sorted(DEAD_IDS)}")

before_lines = len(lines)
lines[:] = [ln for ln in lines
            if ln["patchline"]["source"][0]      not in DEAD_IDS
            and ln["patchline"]["destination"][0] not in DEAD_IDS]
removed_lines = before_lines - len(lines)
changes.append(f"REMOVED {removed_lines} patchline(s) connected to dead objects")

shutil.copy(PATCH_PATH, BACKUP_PATH)
print(f"Backup: {BACKUP_PATH}")

with open(PATCH_PATH, "w") as f:
    json.dump(patch, f, indent=4)
print(f"Written: {PATCH_PATH}")

print(f"\n{len(changes)} change(s):")
for c in changes:
    print(f"  {c}")
print(f"\nPatch: {len(boxes)} objects, {len(lines)} lines remaining.")
print("\nDone. Reload ebys-analyze.maxpat in Max.")
