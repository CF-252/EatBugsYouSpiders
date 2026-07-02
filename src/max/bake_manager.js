// EBYS — Bake Manager
//
// Handles ring buffer snapshot and restore for the bake training system.
//
// At :bake start — copies all ring buffers into snap buffers (bakeSnapshot).
// At each loop reset — copies snap buffers back into ring buffers (bakeRestore).
//
// This guarantees every loop attempt departs from identical audio material,
// so the model only sees the effect of command changes, not material drift.
//
// ── Inlet 0 messages ──────────────────────────────────────────────────────────
//   bakeSnapshot    copy ring_N_stem → snap_N_stem  (called at :bake start)
//   bakeRestore     copy snap_N_stem → ring_N_stem  (called at each loop reset)
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0  → fluid.bufcompose~  ring_0_voc → snap_0_voc
//   1  → fluid.bufcompose~  ring_1_voc → snap_1_voc
//   2  → fluid.bufcompose~  ring_0_drm → snap_0_drm
//   3  → fluid.bufcompose~  ring_1_drm → snap_1_drm
//   4  → fluid.bufcompose~  ring_0_bss → snap_0_bss
//   5  → fluid.bufcompose~  ring_1_bss → snap_1_bss
//   6  → fluid.bufcompose~  ring_0_mel → snap_0_mel
//   7  → fluid.bufcompose~  ring_1_mel → snap_1_mel
//   8  → fluid.bufcompose~  snap_0_voc → ring_0_voc
//   9  → fluid.bufcompose~  snap_1_voc → ring_1_voc
//   10 → fluid.bufcompose~  snap_0_drm → ring_0_drm
//   11 → fluid.bufcompose~  snap_1_drm → ring_1_drm
//   12 → fluid.bufcompose~  snap_0_bss → ring_0_bss
//   13 → fluid.bufcompose~  snap_1_bss → ring_1_bss
//   14 → fluid.bufcompose~  snap_0_mel → ring_0_mel
//   15 → fluid.bufcompose~  snap_1_mel → ring_1_mel

autowatch = 1;
inlets    = 1;
outlets   = 16;

var STEMS = ['voc', 'drm', 'bss', 'mel'];  // order maps to outlet pairs 0-1, 2-3, 4-5, 6-7

function triggerCopy(fromPrefix, toPrefix, outletOffset) {
    STEMS.forEach(function(sh, si) {
        [0, 1].forEach(function(n) {
            var o        = outletOffset + si * 2 + n;
            var srcName  = fromPrefix + n + "_" + sh;
            var dstName  = toPrefix   + n + "_" + sh;
            var srcBuf   = new Buffer(srcName);
            var nFrames  = srcBuf.framecount();

            if (nFrames <= 0) {
                post("bake_manager: " + srcName + " is empty — skipping\n");
                return;
            }

            outlet(o, "source",         srcName);
            outlet(o, "startframe",     0);
            outlet(o, "numframes",      nFrames);
            outlet(o, "destination",    dstName);
            outlet(o, "deststartframe", 0);
            outlet(o, "bang");
        });
    });
}

function bakeSnapshot() {
    // ring_N_stem → snap_N_stem  (outlets 0–7)
    triggerCopy("ring_", "snap_", 0);
    post("bake_manager: snapshot taken\n");
}

function bakeRestore() {
    // snap_N_stem → ring_N_stem  (outlets 8–15)
    triggerCopy("snap_", "ring_", 8);
    post("bake_manager: snapshot restored\n");
}
