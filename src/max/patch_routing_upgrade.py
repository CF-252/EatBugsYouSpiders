#!/usr/bin/env python3
"""
EBYS Max Patch — Audio Routing Upgrade
=======================================
Wires up all new controls from the JS routing layer into the Max signal chain.

Changes:
  1. setStemGain   — insert receive gain_<stem> + *~ after each *~0.7 (per-stem fader)
  2. setMasterGain — receive master_gain → *~1 before dac~ 1 2 (master fader)
  3. per-stem fxSend — replace global fxsend1 tap with per-stem *~0 controls
  4. spatial_router.js — add JS object, wire from ws_server
  5. 4-channel spatial output — receive gain_FL/FR/RL/RR per stem → dac~ 5 6 7 8
  6. Update eq_router route to dispatch gain_* messages
  7. Update ms_router route to dispatch master_gain + fxsend_* messages

Output channel map:
  dac~ 1 2 = stereo reduction (existing, unchanged)
  dac~ 3 4 = FX send loop (existing, unchanged)
  dac~ 5 6 = FL FR (front spatial)
  dac~ 7 8 = RL RR (rear spatial)

Run from the MAX/ folder:
    python3 patch_routing_upgrade.py
"""

import json, shutil, os

PATCH_PATH  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ebys-analyze.maxpat")
BACKUP_PATH = PATCH_PATH + ".pre_routing_upgrade.bak"

with open(PATCH_PATH) as f:
    patch = json.load(f)

boxes   = patch["patcher"]["boxes"]
lines   = patch["patcher"]["lines"]
changes = []

# ── Helpers ───────────────────────────────────────────────────────────────────

def get_box(oid):
    for b in boxes:
        if b["box"]["id"] == oid:
            return b["box"]
    return None

def remove_wire(src_id, src_out, dst_id, dst_in):
    before = len(lines)
    lines[:] = [ln for ln in lines if not (
        ln["patchline"]["source"]      == [src_id, src_out] and
        ln["patchline"]["destination"] == [dst_id, dst_in]
    )]
    if len(lines) < before:
        changes.append(f"REMOVE  {src_id}[{src_out}] → {dst_id}[{dst_in}]")
    else:
        changes.append(f"SKIP    {src_id}[{src_out}] → {dst_id}[{dst_in}]  (not found)")

def wire(src_id, src_out, dst_id, dst_in):
    lines.append({"patchline": {"source": [src_id, src_out], "destination": [dst_id, dst_in]}})
    changes.append(f"WIRE    {src_id}[{src_out}] → {dst_id}[{dst_in}]")

def add_obj(bid, text, x, y, nin=2, nout=1, outtype=None, w=160.0):
    if outtype is None:
        outtype = ["signal"] * nout
    boxes.append({"box": {
        "id": bid, "maxclass": "newobj",
        "numinlets": nin, "numoutlets": nout,
        "outlettype": outtype,
        "patching_rect": [x, y, w, 22.0],
        "text": text
    }})
    changes.append(f"ADD     {bid}: {text}")

def add_msg_receive(bid, name, x, y):
    """Message-rate receive (for gain floats sent to *~ right inlet)."""
    add_obj(bid, f"receive {name}", x, y, nin=1, nout=1, outtype=[""], w=180.0)

def add_sig_mul(bid, default, x, y):
    """*~ signal multiplier with message right inlet."""
    add_obj(bid, f"*~ {default}", x, y, nin=2, nout=1, outtype=["signal"], w=52.0)

def add_sig_add(bid, x, y):
    add_obj(bid, "+~", x, y, nin=2, nout=1, outtype=["signal"], w=40.0)

def add_send(bid, name, x, y):
    add_obj(bid, f"send {name}", x, y, nin=1, nout=0, outtype=[], w=180.0)

def add_dac(bid, ch1, ch2, x, y):
    add_obj(bid, f"dac~ {ch1} {ch2}", x, y, nin=3, nout=0, outtype=[], w=80.0)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 1 — STEM GAIN *~ INSERTS
# Insert receive gain_<stem> + *~ between *~0.7 and its signal-path destinations.
# FX taps (21050/21051/21052) are handled in Step 2.
# ─────────────────────────────────────────────────────────────────────────────

STEMS = [
    # stem     , *~0.7 id , x_pos  , non-FX destinations
    ("vocals", "obj-711", 146.3,  [("obj-20008",0),("obj-20012",0),("obj-20013",0),("obj-6001",0)]),
    ("drums",  "obj-741", 791.9,  [("obj-20018",0),("obj-20022",0),("obj-20023",0),("obj-6002",0)]),
    ("bass",   "obj-771", 1289.3, [("obj-20028",0),("obj-20032",0),("obj-20033",0)]),
    ("melody", "obj-801", 1828.1, [("obj-20038",0),("obj-20042",0),("obj-20043",0)]),
]

gain_mul_id = {}   # stem -> new *~1 gain object id

for idx, (stem, src_id, sx, non_fx_dests) in enumerate(STEMS):
    rcv_id = f"obj-2300{idx*2}"      # 23000 23002 23004 23006
    mul_id = f"obj-2300{idx*2+1}"    # 23001 23003 23005 23007
    gain_mul_id[stem] = mul_id

    # Remove original wires from *~0.7 to signal-path objects
    for dst_id, dst_in in non_fx_dests:
        remove_wire(src_id, 0, dst_id, dst_in)

    # Add receive gain_<stem> and *~ 1 (default gain 1 = unity)
    add_msg_receive(rcv_id, f"gain_{stem}", sx + 110.0, 2628.0)
    add_sig_mul(mul_id, 1, sx, 2628.0)

    # *~0.7 → new *~gain; receive → *~gain right inlet
    wire(src_id, 0, mul_id, 0)
    wire(rcv_id, 0, mul_id, 1)

    # Rewire original destinations from new *~gain
    for dst_id, dst_in in non_fx_dests:
        wire(mul_id, 0, dst_id, dst_in)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2 — PER-STEM FX SENDS
# Replace single global fxsend1 tap with individual *~ per stem.
# Old chain: *~0.7 → +~(21050/51/52) → *~0(21053) × fxsend1
# New chain: gain_*~ → per-stem *~0 × fxsend_<stem> → +~sum → *~0(21053) × fxsend1
#   (fxsend1 remains as master FX output level; per-stem controls pre-mix amounts)
# ─────────────────────────────────────────────────────────────────────────────

# Remove old taps from *~0.7 to FX summing buses
remove_wire("obj-711", 0, "obj-21050", 0)
remove_wire("obj-741", 0, "obj-21050", 1)
remove_wire("obj-771", 0, "obj-21051", 1)
remove_wire("obj-801", 0, "obj-21052", 1)
# Remove the old summing chain links (we'll rebuild them)
remove_wire("obj-21050", 0, "obj-21051", 0)
remove_wire("obj-21051", 0, "obj-21052", 0)
remove_wire("obj-21052", 0, "obj-21053", 0)

FX_Y = 4020.0
fx_mul_ids = {}

for i, stem in enumerate(["vocals", "drums", "bass", "melody"]):
    rcv_id = f"obj-2300{8 + i*2}"    # 23008 23010 23012 23014
    mul_id = f"obj-2300{8 + i*2+1}"  # 23009 23011 23013 23015
    fx_mul_ids[stem] = mul_id
    bx = 600.0 + i * 100.0

    add_msg_receive(rcv_id, f"fxsend_{stem}", bx + 85.0, FX_Y)
    add_sig_mul(mul_id, 0, bx, FX_Y + 30.0)

    wire(gain_mul_id[stem], 0, mul_id, 0)   # tap from stem gain
    wire(rcv_id, 0, mul_id, 1)              # receive fxsend_<stem> → right inlet

# New FX summing chain
add_sig_add("obj-23016", 640.0, 4090.0)
add_sig_add("obj-23017", 640.0, 4120.0)
add_sig_add("obj-23018", 640.0, 4150.0)

wire(fx_mul_ids["vocals"], 0, "obj-23016", 0)
wire(fx_mul_ids["drums"],  0, "obj-23016", 1)
wire("obj-23016", 0, "obj-23017", 0)
wire(fx_mul_ids["bass"],   0, "obj-23017", 1)
wire("obj-23017", 0, "obj-23018", 0)
wire(fx_mul_ids["melody"], 0, "obj-23018", 1)
wire("obj-23018", 0, "obj-21053", 0)   # → existing *~0 × fxsend1 master level

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3 — MASTER GAIN
# Add receive master_gain → right inlet of both *~1 objects before dac~ 1 2
# obj-21070 (*~1, L) is at x=204, y=3328
# obj-21071 (*~1, R) is at x=354, y=3431
# ─────────────────────────────────────────────────────────────────────────────

add_msg_receive("obj-23019", "master_gain", 310.0, 3380.0)
wire("obj-23019", 0, "obj-21070", 1)
wire("obj-23019", 0, "obj-21071", 1)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 4 — UPDATE eq_router ROUTE  (add gain_* tokens → outlets 16-19)
# ─────────────────────────────────────────────────────────────────────────────

eq_route = get_box("obj-22001")
eq_route["text"] += " gain_vocals gain_drums gain_bass gain_melody"
changes.append("UPDATE  obj-22001 route: appended gain_* tokens (outlets 16-19)")

eq_gain_sends = [
    ("obj-23020", "gain_vocals", 5598.0, 515.0),
    ("obj-23021", "gain_drums",  5725.0, 540.0),
    ("obj-23022", "gain_bass",   5850.0, 515.0),
    ("obj-23023", "gain_melody", 5975.0, 540.0),
]
for i, (bid, name, x, y) in enumerate(eq_gain_sends):
    add_send(bid, name, x, y)
    wire("obj-22001", 16 + i, bid, 0)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 5 — UPDATE ms_router ROUTE  (add master_gain + fxsend_* → outlets 15-19)
# ─────────────────────────────────────────────────────────────────────────────

ms_route = get_box("obj-20101")
ms_route["text"] += " master_gain fxsend_vocals fxsend_drums fxsend_bass fxsend_melody"
changes.append("UPDATE  obj-20101 route: appended master_gain + fxsend_* tokens (outlets 15-19)")

ms_new_sends = [
    ("obj-23024", "master_gain",   6680.0, 620.0),
    ("obj-23025", "fxsend_vocals", 6680.0, 655.0),
    ("obj-23026", "fxsend_drums",  6800.0, 620.0),
    ("obj-23027", "fxsend_bass",   6800.0, 655.0),
    ("obj-23028", "fxsend_melody", 6920.0, 620.0),
]
for i, (bid, name, x, y) in enumerate(ms_new_sends):
    add_send(bid, name, x, y)
    wire("obj-20101", 15 + i, bid, 0)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 6 — ADD js spatial_router.js + route + 16 send objects
# ─────────────────────────────────────────────────────────────────────────────

add_obj("obj-23029", "js spatial_router.js", 7100.0, 240.0, nin=1, nout=2, outtype=["",""])

wire("obj-4030", 0, "obj-23029", 0)   # ws_server → spatial_router

SPATIAL_TOKENS = (
    "gain_FL_vocals gain_FR_vocals gain_RL_vocals gain_RR_vocals "
    "gain_FL_drums  gain_FR_drums  gain_RL_drums  gain_RR_drums  "
    "gain_FL_bass   gain_FR_bass   gain_RL_bass   gain_RR_bass   "
    "gain_FL_melody gain_FR_melody gain_RL_melody gain_RR_melody"
)
add_obj("obj-23030", f"route {SPATIAL_TOKENS}", 7100.0, 280.0,
        nin=1, nout=17, outtype=[""]*17, w=1500.0)
wire("obj-23029", 0, "obj-23030", 0)

CH_ORDER   = ["FL", "FR", "RL", "RR"]
STEM_ORDER = ["vocals", "drums", "bass", "melody"]

spatial_send_ids = {}
send_obj_num = 23031
for si, stem in enumerate(STEM_ORDER):
    for ci, ch in enumerate(CH_ORDER):
        bid  = f"obj-{send_obj_num}"
        name = f"gain_{ch}_{stem}"
        spatial_send_ids[(ch, stem)] = bid
        outlet_idx = si * 4 + ci
        sx = 7100.0 + outlet_idx * 95.0
        sy = 340.0
        add_send(bid, name, sx, sy)
        wire("obj-23030", outlet_idx, bid, 0)
        send_obj_num += 1

# send_obj_num is now 23047

# ─────────────────────────────────────────────────────────────────────────────
# STEP 7 — SPATIAL AUDIO CHAIN (16 receive + *~ pairs + 4 summing trees + 2 dac~)
# Output: dac~ 5 6 = FL FR,  dac~ 7 8 = RL RR
# ─────────────────────────────────────────────────────────────────────────────

audio_mul_ids = {}   # (ch, stem) -> mul obj id
obj_num = send_obj_num   # 23047

X0    = 600.0
X_STP = 78.0   # spacing between columns

for si, stem in enumerate(STEM_ORDER):
    for ci, ch in enumerate(CH_ORDER):
        col    = si * 4 + ci
        bx     = X0 + col * X_STP
        name   = f"gain_{ch}_{stem}"
        rcv_id = f"obj-{obj_num}"
        mul_id = f"obj-{obj_num+1}"
        audio_mul_ids[(ch, stem)] = mul_id

        add_msg_receive(rcv_id, name, bx + 40.0, 4200.0)
        add_sig_mul(mul_id, 0, bx, 4245.0)

        wire(rcv_id, 0, mul_id, 1)                     # receive → right inlet (gain)
        wire(gain_mul_id[stem], 0, mul_id, 0)          # stem audio → left inlet (signal)
        obj_num += 2

# Four summing trees: one per output channel (FL FR RL RR)
sum_final_ids = {}   # ch -> id of last +~

for ci, ch in enumerate(CH_ORDER):
    bx = X0 + ci * (4 * X_STP) + 1.5 * X_STP   # center of each channel group

    s0 = f"obj-{obj_num}"
    s1 = f"obj-{obj_num+1}"
    s2 = f"obj-{obj_num+2}"
    sum_final_ids[ch] = s2

    add_sig_add(s0, bx, 4310.0)
    add_sig_add(s1, bx, 4355.0)
    add_sig_add(s2, bx, 4400.0)

    wire(audio_mul_ids[(ch,"vocals")], 0, s0, 0)
    wire(audio_mul_ids[(ch,"drums")],  0, s0, 1)
    wire(s0, 0, s1, 0)
    wire(audio_mul_ids[(ch,"bass")],   0, s1, 1)
    wire(s1, 0, s2, 0)
    wire(audio_mul_ids[(ch,"melody")], 0, s2, 1)

    obj_num += 3

# dac~ 5 6 (FL FR) and dac~ 7 8 (RL RR)
dac_front = f"obj-{obj_num}"
dac_rear  = f"obj-{obj_num+1}"

add_dac(dac_front, 5, 6, X0 + 1.5 * X_STP, 4460.0)
add_dac(dac_rear,  7, 8, X0 + (2*4 + 1.5) * X_STP, 4460.0)

wire(sum_final_ids["FL"], 0, dac_front, 0)
wire(sum_final_ids["FR"], 0, dac_front, 1)
wire(sum_final_ids["RL"], 0, dac_rear,  0)
wire(sum_final_ids["RR"], 0, dac_rear,  1)

# ─────────────────────────────────────────────────────────────────────────────
# WRITE
# ─────────────────────────────────────────────────────────────────────────────

shutil.copy(PATCH_PATH, BACKUP_PATH)
print(f"Backup:  {BACKUP_PATH}")

with open(PATCH_PATH, "w") as f:
    json.dump(patch, f, indent=4)
print(f"Written: {PATCH_PATH}")

print(f"\n{len(changes)} change(s):")
for c in changes:
    print(f"  {c}")

print(f"\nPatch: {len(boxes)} objects, {len(lines)} lines.")
print("""
Done. In Max:
  1. Close and reopen ebys-analyze.maxpat
  2. Send 'resend' to eq_router.js and ms_router.js to push current state to new receives
  3. Spatial: set positions with 'setJoystick vocals center' etc.
  4. Test: setStemGain vocals 0.5  →  vocals fader drops to half
            setMasterGain 0.8     →  master output -2dB
            fxSend vocals 0.7     →  vocals sends 70% to FX bus
""")
