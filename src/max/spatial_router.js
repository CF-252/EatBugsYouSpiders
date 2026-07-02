// EBYS — Spatial Router  v1
//
// ── Role ──────────────────────────────────────────────────────────────────────
// spatial_router.js owns 4-channel spatial positioning for each stem.
// A joystick position (named or X/Y) is mapped to gains on four speakers:
//   FL = Front Left   FR = Front Right
//   RL = Rear Left    RR = Rear Right
//
// Uses inverse-distance amplitude panning (simplified VBAP for quad).
// Width blends between a point source (width=0) and equal energy across all
// four channels (width=1).
//
// ── Commands (inlet 0) ────────────────────────────────────────────────────────
//   setJoystick <stem> <position>     — named position (see POSITIONS below)
//   setJoystick <stem> <x> <y>        — continuous X/Y (-1 to +1 each axis)
//   setSpatialWidth <stem> <0–1>      — point source → full diffuse
//   setJoystick all <position|x y>    — apply to all stems
//
//   Named positions (8 directions + center):
//     center      front       back
//     left        right
//     front-left  front-right
//     back-left   back-right
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0  → named receive objects in Max (4 channels per stem, 16 values total)
//        gain_FL_vocals  0.7
//        gain_FR_vocals  0.7
//        gain_RL_vocals  0.0
//        gain_RR_vocals  0.0
//        (repeat for melody, bass, drums)
//   1  → status to ws_server
//        param  spatialPos_vocals   center
//        param  spatialWidth_vocals 0.0
// ──────────────────────────────────────────────────────────────────────────────

autowatch = 1;
inlets    = 1;
outlets   = 2;

var TRACKS = ['vocals', 'melody', 'bass', 'drums'];
var SPKRS  = ['FL', 'FR', 'RL', 'RR'];

// Speaker positions in XY space (x: -1=left +1=right, y: -1=back +1=front)
var SPKR_POS = {
    FL: { x: -1,  y:  1  },
    FR: { x:  1,  y:  1  },
    RL: { x: -1,  y: -1  },
    RR: { x:  1,  y: -1  },
};

// Named joystick positions → XY coords
var POSITIONS = {
    'center':       { x:  0,  y:  0  },
    'front':        { x:  0,  y:  1  },
    'back':         { x:  0,  y: -1  },
    'left':         { x: -1,  y:  0  },
    'right':        { x:  1,  y:  0  },
    'front-left':   { x: -1,  y:  1  },
    'front-right':  { x:  1,  y:  1  },
    'back-left':    { x: -1,  y: -1  },
    'back-right':   { x:  1,  y: -1  },
};

// Current state per stem
var state = {
    vocals: { x: 0, y: 0, width: 0, posName: 'center' },
    melody: { x: 0, y: 0, width: 0, posName: 'center' },
    bass:   { x: 0, y: 0, width: 0, posName: 'center' },
    drums:  { x: 0, y: 0, width: 0, posName: 'center' },
};

// ── Math ─────────────────────────────────────────────────────────────────────

function clamp(v, lo, hi) { return v < lo ? lo : v > hi ? hi : v; }

// Compute raw gains for a point source at (x, y) using inverse distance.
// Max possible distance in the unit square is 2*sqrt(2) ≈ 2.828.
function pointGains(x, y) {
    var gains = {};
    var sumSq = 0;
    var MAX_DIST = 2 * Math.SQRT2;

    for (var i = 0; i < SPKRS.length; i++) {
        var s   = SPKRS[i];
        var sp  = SPKR_POS[s];
        var dx  = x - sp.x;
        var dy  = y - sp.y;
        var dist = Math.sqrt(dx * dx + dy * dy);
        var g   = Math.max(0, 1 - dist / MAX_DIST);
        gains[s] = g;
        sumSq += g * g;
    }

    // Constant-power normalization
    var norm = sumSq > 0 ? (1 / Math.sqrt(sumSq)) : 1;
    for (var i = 0; i < SPKRS.length; i++) {
        gains[SPKRS[i]] *= norm;
    }

    return gains;
}

// Blend between point source and equal-energy spread based on width (0–1)
function computeGains(x, y, width) {
    var pg    = pointGains(x, y);
    var equal = 0.5;   // equal energy across 4 channels: each = 1/sqrt(4) = 0.5
    var gains = {};

    for (var i = 0; i < SPKRS.length; i++) {
        var s = SPKRS[i];
        gains[s] = pg[s] * (1 - width) + equal * width;
    }

    return gains;
}

// ── Output ────────────────────────────────────────────────────────────────────

function sendGains(stem) {
    var s  = state[stem];
    var g  = computeGains(s.x, s.y, s.width);

    for (var i = 0; i < SPKRS.length; i++) {
        var ch = SPKRS[i];
        outlet(0, 'gain_' + ch + '_' + stem, g[ch]);
    }

    outlet(1, 'param', 'spatialPos_'   + stem, s.posName);
    outlet(1, 'param', 'spatialWidth_' + stem, s.width);

    post('spatial_router: ' + stem + ' [' + s.posName + ']'
         + '  FL=' + g.FL.toFixed(2) + ' FR=' + g.FR.toFixed(2)
         + ' RL=' + g.RL.toFixed(2) + ' RR=' + g.RR.toFixed(2) + '\n');
}

// ── Commands ──────────────────────────────────────────────────────────────────

function setJoystick() {
    var args = arrayfromargs(arguments);
    // args[0] = stem, args[1] = position name OR x value, args[2] = y value (optional)
    if (args.length < 2) return;

    var stem  = String(args[0]);
    var targets = (stem === 'all') ? TRACKS : [stem];

    var x, y, posName;

    if (args.length === 2) {
        // Named position: setJoystick vocals center
        var name = String(args[1]).toLowerCase();
        if (!POSITIONS.hasOwnProperty(name)) {
            post('spatial_router: unknown position "' + name + '" — valid: '
                 + Object.keys(POSITIONS).join(', ') + '\n');
            return;
        }
        x = POSITIONS[name].x;
        y = POSITIONS[name].y;
        posName = name;
    } else {
        // XY: setJoystick vocals -0.5 0.8
        x = clamp(parseFloat(args[1]) || 0, -1, 1);
        y = clamp(parseFloat(args[2]) || 0, -1, 1);
        // Find closest named position for display
        posName = closestPositionName(x, y);
    }

    for (var i = 0; i < targets.length; i++) {
        var t = targets[i];
        if (!state[t]) continue;
        state[t].x       = x;
        state[t].y       = y;
        state[t].posName = posName;
        sendGains(t);
    }
}

function setSpatialWidth(stem, val) {
    if (!stem) return;
    var w = clamp(parseFloat(val) || 0, 0, 1);
    var targets = (String(stem) === 'all') ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        var t = targets[i];
        if (!state[t]) continue;
        state[t].width = w;
        sendGains(t);
        post('spatial_router: width[' + t + '] = ' + w.toFixed(2) + '\n');
    }
}

// Find the named position closest to given XY (for display label on continuous input)
function closestPositionName(x, y) {
    var best = 'center';
    var bestDist = Infinity;
    for (var name in POSITIONS) {
        var p  = POSITIONS[name];
        var dx = x - p.x;
        var dy = y - p.y;
        var d  = dx * dx + dy * dy;
        if (d < bestDist) { bestDist = d; best = name; }
    }
    return best;
}

function info() {
    post('spatial_router state:\n');
    for (var i = 0; i < TRACKS.length; i++) {
        var t = TRACKS[i];
        var s = state[t];
        var g = computeGains(s.x, s.y, s.width);
        post('  ' + t + ': pos=' + s.posName
             + '  x=' + s.x.toFixed(2) + ' y=' + s.y.toFixed(2)
             + '  width=' + s.width.toFixed(2) + '\n');
        post('    FL=' + g.FL.toFixed(2) + ' FR=' + g.FR.toFixed(2)
             + ' RL=' + g.RL.toFixed(2) + ' RR=' + g.RR.toFixed(2) + '\n');
    }
}

// Re-push all current gains to Max
function resend() {
    for (var i = 0; i < TRACKS.length; i++) sendGains(TRACKS[i]);
    post('spatial_router: resent all params\n');
}

// Catch-all: suppress warnings from parallel-wired commands
function anything() {}
