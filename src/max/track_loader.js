// EBYS — Track Loader  v2  (multi-track)
//
// Scans the htdemucs stems folder and loads ALL tracks at startup.
// Each track is assigned a SLOT (0-based, alphabetical order).
// slicer.js uses the same sort order, so slot N here = slot N in slicer.
//
// Buffer naming convention (mirrors the Max patch buffer~ objects):
//   play_0_voc   play_0_drm   play_0_bss   play_0_mel   ← slot 0
//   play_1_voc   play_1_drm   play_1_bss   play_1_mel   ← slot 1
//   …  up to MAX_SLOTS - 1
//
// ── Inlet messages ────────────────────────────────────────────────────────────
//   scan         — re-scan htdemucs folder (also runs on startup)
//   loadAll      — load all found tracks into their slots (also runs on startup)
//   load N       — load only the track at slot index N
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0   → umenu           "clear" then "append <slot>: <name>" for each track
//   1   → buffer~ play_0_voc   "read <path>"
//   2   → buffer~ play_0_drm   "read <path>"
//   3   → buffer~ play_0_bss   "read <path>"
//   4   → buffer~ play_0_mel   "read <path>"
//   5   → buffer~ play_1_voc   "read <path>"
//   6   → buffer~ play_1_drm   "read <path>"
//   7   → buffer~ play_1_bss   "read <path>"
//   8   → buffer~ play_1_mel   "read <path>"
//   …   (4 outlets per slot)
//   N   → status strings   "loading <name>", "tracks N", "error …"
//         where N = MAX_SLOTS * 4 + 1  (last outlet)

autowatch = 1;

// Maximum number of track slots supported.
// Increase this AND add matching buffer~ objects in the Max patch if you need more.
var MAX_SLOTS = 6;

inlets  = 1;
outlets = MAX_SLOTS * 4 + 1;   // 4 stem outlets per slot + 1 status outlet

var STATUS_OUTLET = MAX_SLOTS * 4;  // last outlet = status

// Path to htdemucs stems — computed relative to patch, works on any machine.
function getDataDir() {
    var p = patcher.filepath;
    var slash = p.indexOf('/');
    if (slash > 0) p = p.slice(slash);
    p = p.replace(/[^\/]+$/, '');    // strip filename  → .../src/max/
    p = p.replace(/[^\/]+\/$/, ''); // strip max/      → .../src/
    p = p.replace(/[^\/]+\/$/, ''); // strip src/      → .../EBYS/
    return p + 'data/';
}
var HT_PATH = getDataDir() + "stems/htdemucs";

// htdemucs stem suffixes in stem order: vocals, drums, bass, melo/other.
// The outlet offset within each slot: 0=voc, 1=drm, 2=bss, 3=mel.
var SUFFIXES = ["_vocals.wav", "_drums.wav", "_bass.wav", "_other.wav"];

// Populated by scan(); sorted alphabetically to match slicer.js slot assignment.
var trackNames = [];

// ── Utilities ─────────────────────────────────────────────────────────────────

// Returns the base outlet index for slot N.
// Slot 0: outlets 1-4, slot 1: outlets 5-8, etc.
// (Outlet 0 is umenu; STATUS_OUTLET is the last outlet.)
function slotBaseOutlet(slot) {
    return slot * 4 + 1;
}

// ── scan ──────────────────────────────────────────────────────────────────────
// Lists subfolder names in HT_PATH, sorts alphabetically, assigns slot numbers.
function scan() {
    trackNames = [];

    var folder = new Folder(HT_PATH);
    if (!folder || folder.end) {
        post("track_loader: cannot open " + HT_PATH + "\n");
        outlet(STATUS_OUTLET, "error", "htdemucs folder not found");
        return;
    }

    while (!folder.end) {
        var name = folder.filename;
        if (name && name.charAt(0) !== '.') {
            trackNames.push(name);
        }
        folder.next();
    }
    folder.close();

    // Sort alphabetically — MUST match slicer.js buildIndex sort order.
    trackNames.sort();

    // Cap to MAX_SLOTS
    if (trackNames.length > MAX_SLOTS) {
        post("track_loader: " + trackNames.length + " tracks found; capping to "
             + MAX_SLOTS + " (increase MAX_SLOTS to load more)\n");
        trackNames = trackNames.slice(0, MAX_SLOTS);
    }

    // Update umenu
    outlet(0, "clear");
    for (var i = 0; i < trackNames.length; i++) {
        outlet(0, "append", i + ": " + trackNames[i]);
    }

    outlet(STATUS_OUTLET, "tracks", trackNames.length);
    post("track_loader: " + trackNames.length + " track(s) found: "
         + trackNames.map(function(n, i){ return i + "=" + n; }).join(", ") + "\n");
}

// ── load ──────────────────────────────────────────────────────────────────────
// Loads one track (by slot index) into its 4 play_N_* buffers.
function load(index) {
    index = parseInt(index);

    if (trackNames.length === 0) {
        post("track_loader: list empty — send 'scan' first\n");
        outlet(STATUS_OUTLET, "error", "no tracks — run scan first");
        return;
    }
    if (index < 0 || index >= trackNames.length) {
        post("track_loader: index " + index + " out of range (0–"
             + (trackNames.length - 1) + ")\n");
        return;
    }

    var name = trackNames[index];
    var base = HT_PATH + "/" + name + "/" + name;
    var baseOutlet = slotBaseOutlet(index);

    post("track_loader: loading slot " + index + " '" + name + "' → "
         + "play_" + index + "_voc/drm/bss/mel\n");

    for (var si = 0; si < SUFFIXES.length; si++) {
        var path   = base + SUFFIXES[si];
        var outlet_n = baseOutlet + si;
        outlet(outlet_n, "read", path);
    }

    outlet(STATUS_OUTLET, "loading", name, index);
}

// ── loadAll ───────────────────────────────────────────────────────────────────
// Loads all found tracks into their respective slots.
// Called automatically on startup after scan() completes.
function loadAll() {
    if (trackNames.length === 0) {
        post("track_loader: no tracks to load — htdemucs folder empty?\n");
        outlet(STATUS_OUTLET, "error", "no tracks found");
        return;
    }
    post("track_loader: loading all " + trackNames.length + " track(s) into slots…\n");
    for (var i = 0; i < trackNames.length; i++) {
        load(i);
    }
}

// ── Auto-scan + load on patch open ───────────────────────────────────────────
// Deferred 500 ms so Max finishes wiring before we push to the umenu/buffers.
var _init = new Task(function() {
    scan();
    loadAll();
}, this);
_init.schedule(500);
