#!/usr/bin/env python3
"""
EBYS Max Patch — Tighten-Up #2
================================
Removes 9 confirmed-dead objects + 4 dead patchlines.
Fixes 1 missing wire: meter data now reaches ws_server.js.

Dead objects removed:
  3 × label box  obj-46 obj-47 obj-48       melody durMs/endMs/StartMs (missed in cleanup #1)
  2 × loadbang   obj-5009 obj-9900          orphan — no outputs, fired on load and did nothing
  4 × f          obj-111 obj-211 obj-311 obj-411   dead sample-rate stores from info~ ring_0_*

Dead patchlines removed:
  info~ ring_0_voc[6]  → obj-111[0]  (f)
  info~ ring_0_drm[6]  → obj-411[0]  (f)
  info~ ring_0_bss[6]  → obj-311[0]  (f)
  info~ ring_0_mel[6]  → obj-211[0]  (f)

Bug fix — missing wire added:
  obj-5008[0] (prepend meter)  →  obj-4030[0] (ws_server.js)
  The fluid.loudness~ → snapshot~ → pak → prepend meter chain was fully wired
  but its output never reached ws_server.js, so the TUI never received real-time
  LUFS/dBFS meter data. Now it does.

Run from the MAX/ folder:
    python3 patch_tighten2.py
"""

import json, shutil, os

PATCH_PATH  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ebys-analyze.maxpat")
BACKUP_PATH = PATCH_PATH + ".pre_tighten2.bak"

with open(PATCH_PATH) as f:
    patch = json.load(f)

boxes  = patch["patcher"]["boxes"]
lines  = patch["patcher"]["lines"]
changes = []

# ── STEP 1: Remove dead objects ───────────────────────────────────────────────
DEAD_IDS = {
    # melody stem duration labels — missed in cleanup #1
    "obj-46", "obj-47", "obj-48",
    # orphan loadbangs — booted on load, had no outputs
    "obj-5009", "obj-9900",
    # dead f objects — stored ring buffer sample rate but output went nowhere
    "obj-111", "obj-211", "obj-311", "obj-411",
}

before_boxes = len(boxes)
boxes[:] = [b for b in boxes if b["box"]["id"] not in DEAD_IDS]
removed_boxes = before_boxes - len(boxes)
changes.append(f"REMOVED {removed_boxes} dead objects: {sorted(DEAD_IDS)}")

# ── STEP 2: Remove dead patchlines (to/from dead objects) ────────────────────
before_lines = len(lines)
lines[:] = [ln for ln in lines
            if ln["patchline"]["source"][0]      not in DEAD_IDS
            and ln["patchline"]["destination"][0] not in DEAD_IDS]
removed_lines = before_lines - len(lines)
changes.append(f"REMOVED {removed_lines} patchlines connected to dead objects")

# ── STEP 3: Add missing meter wire ───────────────────────────────────────────
# prepend meter (obj-5008) outlet 0  →  ws_server.js (obj-4030) inlet 0
METER_WIRE = {"patchline": {"source": ["obj-5008", 0], "destination": ["obj-4030", 0]}}

# Guard: don't add if already present
already = any(
    ln["patchline"]["source"] == ["obj-5008", 0]
    and ln["patchline"]["destination"] == ["obj-4030", 0]
    for ln in lines
)
if not already:
    lines.append(METER_WIRE)
    changes.append("WIRE    obj-5008[0] (prepend meter) → obj-4030[0] (ws_server.js)  [BUG FIX]")
else:
    changes.append("SKIP    meter wire already present")

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
