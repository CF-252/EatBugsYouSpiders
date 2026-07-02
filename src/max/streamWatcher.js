// streamWatcher.js — polls stream.txt every 1s, bangs on content change.
// Replaces filewatch (unreliable for paths outside Max's search path).
// Outlet 0: bang when stream.txt changes.

autowatch = 0;
inlets   = 0;   // no inlet — auto-starts, nothing to bang externally
outlets  = 1;

// Compute data/ dir relative to this patch — works on any machine.
// Patch lives at EBYS/src/max/  →  strip "max/"  →  strip "src/"  →  append "data/"
function getDataDir() {
    var p = patcher.filepath;
    var slash = p.indexOf('/');
    if (slash > 0) p = p.slice(slash);   // normalise Max volume prefix
    p = p.replace(/[^\/]+$/, '');        // strip filename  → .../src/max/
    p = p.replace(/[^\/]+\/$/, '');      // strip max/      → .../src/
    p = p.replace(/[^\/]+\/$/, '');      // strip src/      → .../EBYS/
    return p + 'data/';
}

var STREAM_PATH = getDataDir() + "stream.txt";
var lastContent = null;
var pollTask    = null;

function readFile() {
    var f = new File(STREAM_PATH, "read", "TEXT");
    if (!f || !f.isopen) return null;
    var lines = [];
    while (true) {
        var line = f.readline();
        if (line === null || line === undefined) break;
        lines.push(line);
    }
    f.close();
    return lines.join("\n");
}

function poll() {
    var content = readFile();

    if (content !== null) {
        if (lastContent === null) {
            // First read — establish baseline silently
            lastContent = content;
            post("streamWatcher: baseline set (" + content.split("\n").filter(function(l){return l.trim();}).length + " lines)\n");
        } else if (content !== lastContent) {
            lastContent = content;
            var lines = content.split("\n").filter(function(l){ return l.trim(); });
            if (lines.length > 0) {
                post("streamWatcher: change detected → bang (" + lines.length + " stems)\n");
                outlet(0, "bang");
            } else {
                post("streamWatcher: stream.txt empty — skipping bang\n");
            }
        }
    }

    // Always reschedule
    pollTask = new Task(poll, this);
    pollTask.schedule(1000);
}

// Start after 300ms so Max is fully initialized
var _init = new Task(poll, this);
_init.schedule(300);
