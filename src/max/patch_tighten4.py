#!/usr/bin/env python3
"""
EBYS Max Patch — Tighten-Up #4
================================
Fixes two bugs + restores auto-start.

Bug 1: libchunk/genrechunk never reached slicer.js
-------------------------------------------------------
ws_server sends libchunk and genrechunk out outlet 0. These messages go
through route obj-4041 (which only routes known commands like buildIndex,
start, stop, etc.). Non-matching messages fall through to the route's else
outlet [24] — which was unconnected. So slicer.js never received library
chunks, cachedLibrary stayed null, and buildIndex always failed with
"no cached library".

Fix: connect obj-4041[24] (else) → obj-551[0] (slicer.js). All unmatched
messages (libchunk, genrechunk, setKeyFilter, clearKeyFilter, etc.) now
reach slicer.js. Slicer ignores unknown messages automatically.

Bug 2: @autostart 1 doesn't work for node.script
-------------------------------------------------------
Removing obj-437 (loadbang) in tighten3 meant nothing auto-started
ws_server. node.script @autostart 1 is not a valid attribute in Max/N4M.

Fix: add a new loadbang that triggers delay 500 → script start. 500ms is
enough for Max to finish loading the patch before ws_server starts. The
old delay 2000 was causing the double-boot by restarting ws_server mid-
way through the first buildIndex cycle.

(The actual double-buildIndex root cause — ws_server sending analysisDone
on every TUI connect — is fixed separately in ws_server.js.)

Run from the MAX/ folder:
    python3 patch_tighten4.py
"""

import json, shutil, os

PATCH_PATH  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ebys-analyze.maxpat")
BACKUP_PATH = PATCH_PATH + ".pre_tighten4.bak"

with open(PATCH_PATH) as f:
    patch = json.load(f)

boxes  = patch["patcher"]["boxes"]
lines  = patch["patcher"]["lines"]
changes = []

# ── STEP 1: Change delay 2000 → delay 500 ────────────────────────────────────
for b in boxes:
    if b["box"]["id"] == "obj-4038" and b["box"].get("text") == "delay 2000":
        b["box"]["text"] = "delay 500"
        changes.append("CHANGED obj-4038 delay 2000 → delay 500")
        break

# ── STEP 2: Add new loadbang for auto-start ───────────────────────────────────
# obj-4038 (delay 500) is near y=2774. Place the new loadbang above it.
new_lb = {
    "box": {
        "id": "obj-437",   # reuse the ID we removed in tighten3
        "maxclass": "newobj",
        "numinlets": 1,
        "numoutlets": 1,
        "outlettype": ["bang"],
        "patching_rect": [45.37037265300751, 2740.740694999695, 58.0, 22.0],
        "text": "loadbang"
    }
}
boxes.append(new_lb)
changes.append("ADDED obj-437 (loadbang) for auto-start near delay 500")

# Wire loadbang → delay 500
lb_wire = {"patchline": {"source": ["obj-437", 0], "destination": ["obj-4038", 0]}}
lines.append(lb_wire)
changes.append("WIRE obj-437[0] (loadbang) → obj-4038[0] (delay 500)")

# ── STEP 3: Wire route else outlet [24] → slicer.js [0] ─────────────────────
# obj-4041 is the route object; outlet 24 is its else outlet.
# obj-551 is slicer.js.
already = any(
    ln["patchline"]["source"] == ["obj-4041", 24]
    and ln["patchline"]["destination"][0] == "obj-551"
    for ln in lines
)
if not already:
    else_wire = {"patchline": {"source": ["obj-4041", 24], "destination": ["obj-551", 0]}}
    lines.append(else_wire)
    changes.append("WIRE obj-4041[24] (route else) → obj-551[0] (slicer.js)  — libchunk/genrechunk path")
else:
    changes.append("SKIP route-else→slicer wire already present")

# ── Write ─────────────────────────────────────────────────────────────────────
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
