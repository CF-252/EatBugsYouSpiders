// EBYS — MS Router  v1
//
// ── Role ──────────────────────────────────────────────────────────────────────
// ms_router.js owns all stereo and FX routing parameters.
// It receives commands from ws_server.js (via TUI) and forwards them to the
// appropriate Max `receive` objects in the patch.
//
// ── Commands (inlet 0) ────────────────────────────────────────────────────────
//   width  <stem> <0–1>      — M/S stereo width per stem (0=mono, 1=full wide)
//   pan    <stem> <-1–+1>    — stereo pan position (-1=left, 0=center, +1=right)
//   fxSend   <0–1>           — send level from master mix to dac~ 3 4
//   fxReturn <0–1>           — return level from adc~ 3 4 to main mix
//
// Stems: vocals | melody | bass | drums | all
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0  → named receive objects (via Max `send` messaging)
//        send width_vocals <v>   send panL_vocals <v>   send panR_vocals <v>
//        send fxsend1 <v>        send fxreturn1 <v>
//   1  → status to ws_server (for TUI feedback)
//        param key value
// ──────────────────────────────────────────────────────────────────────────────

autowatch = 1;
inlets    = 1;
outlets   = 2;

var TRACKS = ['vocals', 'melody', 'bass', 'drums'];

// Current state (for info / recall)
var state = {
    width:       { vocals: 0, melody: 0, bass: 0, drums: 0 },
    pan:         { vocals: 0, melody: 0, bass: 0, drums: 0 },
    fxSend:      { vocals: 0, melody: 0, bass: 0, drums: 0 },  // per-stem send levels
    fxReturn:    0,       // single return to master bus
    masterGain:  1.0,     // setMasterGain 0–1 (master fader)
};

// Analysis mode: when true, stemMS messages from slicer drive pan/width automatically.
// Set to false via :analysisMode off to allow fully manual TUI control.
var analysisDriven = true;

// ── Helpers ───────────────────────────────────────────────────────────────────

function clamp(v, lo, hi) { return v < lo ? lo : v > hi ? hi : v; }

// Equal-power pan → L/R gain pair
// pan = -1 (full left) … 0 (center) … +1 (full right)
// L = cos((pan+1)*pi/4)  R = sin((pan+1)*pi/4)
function panGains(pan) {
    var angle = (clamp(pan, -1, 1) + 1) * Math.PI / 4;
    return { L: Math.cos(angle), R: Math.sin(angle) };
}

function sendToMax(name, value) {
    // Use Max's `send` mechanism: outlet a message that will be caught by `receive <name>`
    // In Max JS, you can't call send() directly, but you CAN use outlet + a patch-level
    // route/send. Instead we use a simpler approach: output "send <name> <value>" on outlet 0
    // and the patch uses [route send] → [prepend <name>] → [send <name>].
    //
    // Simpler: we connect ms_router outlet 0 to individual `receive` objects via Max wiring.
    // Each param gets its own outlet, but that would need many outlets.
    //
    // Best approach for Max JS: use the `send` function if available, or output a tagged message.
    // We output: name value  — the patch routes on first word via route objects wired to receives.
    outlet(0, name, value);
}

function applyWidth(stem, w) {
    w = clamp(parseFloat(w) || 0, 0, 1);
    state.width[stem] = w;
    sendToMax('width_' + stem, w);
    outlet(1, 'param', 'width_' + stem, w);
    post('ms_router: width[' + stem + '] = ' + w.toFixed(3) + '\n');
}

function applyPan(stem, p) {
    p = clamp(parseFloat(p) || 0, -1, 1);
    state.pan[stem] = p;
    var g = panGains(p);
    sendToMax('panL_' + stem, g.L);
    sendToMax('panR_' + stem, g.R);
    outlet(1, 'param', 'panL_' + stem, g.L);
    outlet(1, 'param', 'panR_' + stem, g.R);
    post('ms_router: pan[' + stem + '] = ' + p.toFixed(3)
         + '  L=' + g.L.toFixed(3) + ' R=' + g.R.toFixed(3) + '\n');
}

// ── Command handlers ──────────────────────────────────────────────────────────

function width(stem, value) {
    if (!stem) return;
    var targets = (String(stem) === 'all') ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        if (state.width.hasOwnProperty(targets[i])) applyWidth(targets[i], value);
    }
}

function pan(stem, value) {
    if (!stem) return;
    var targets = (String(stem) === 'all') ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        if (state.pan.hasOwnProperty(targets[i])) applyPan(targets[i], value);
    }
}

// fxSend <stem> <0–1>  — per-stem send level to FX bus
// fxSend all <0–1>    — set all stems at once
// In Max: each stem's send goes to a *~ that feeds the FX bus (dac~ 3 4)
// so each stem can be independently sent to the reverb/delay/etc.
function fxSend(stem, value) {
    // Back-compat: if only one argument, treat as global (set all)
    if (value === undefined) { value = stem; stem = 'all'; }
    var v = clamp(parseFloat(value) || 0, 0, 1);
    var targets = String(stem) === 'all' ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        var t = targets[i];
        if (!state.fxSend.hasOwnProperty(t)) continue;
        state.fxSend[t] = v;
        sendToMax('fxsend_' + t, v);
        outlet(1, 'param', 'fxSend_' + t, v);
        post('ms_router: fxSend[' + t + '] = ' + v.toFixed(3) + '\n');
    }
}

// :fxStereo 0 | 1  (or off | on)
// 0 = mono  — same mono sum on dac~ 3+4, return from adc~ 3 only (default, for mono pedals)
// 1 = stereo — master L/R on dac~ 3/4 separately, return from adc~ 3 (L) and adc~ 4 (R)
function fxStereo(val) {
    var v = (String(val) === '1' || String(val).toLowerCase() === 'on') ? 1 : 0;
    sendToMax('fxstereo', v);
    outlet(1, 'param', 'fxStereo', v);
    post('ms_router: fxStereo = ' + (v ? 'stereo' : 'mono') + '\n');
}

function fxReturn(value) {
    var v = clamp(parseFloat(value) || 0, 0, 1);
    state.fxReturn = v;
    sendToMax('fxreturn1', v);
    outlet(1, 'param', 'fxReturn', v);
    post('ms_router: fxReturn = ' + v.toFixed(3) + '\n');
}

// ── setMasterGain ─────────────────────────────────────────────────────────────
// setMasterGain <0–1>  — master output fader
// 0 = silence, 1 = full. Drives master_gain receive in the patch.
function setMasterGain(value) {
    var v = clamp(parseFloat(value) || 0, 0, 1);
    state.masterGain = v;
    sendToMax('master_gain', v);
    outlet(1, 'param', 'masterGain', v);
    post('ms_router: masterGain = ' + v.toFixed(3) + '\n');
}

function info() {
    post('ms_router state:\n');
    for (var i = 0; i < TRACKS.length; i++) {
        var t = TRACKS[i];
        post('  ' + t + ': width=' + state.width[t].toFixed(2)
             + '  pan=' + state.pan[t].toFixed(2) + '\n');
    }
    post('  fxSend: vocals=' + state.fxSend.vocals.toFixed(2)
         + ' melody=' + state.fxSend.melody.toFixed(2)
         + ' bass='   + state.fxSend.bass.toFixed(2)
         + ' drums='  + state.fxSend.drums.toFixed(2) + '\n');
    post('  fxReturn=' + state.fxReturn.toFixed(2)
         + '  masterGain=' + state.masterGain.toFixed(2) + '\n');
}

// ── Analysis-driven M/S ───────────────────────────────────────────────────────
// Called by ws_server when slicer.js emits stemMS after each slice selection.
// Only fires when analysisMode = true (default).
// TUI :analysisMode off  → manual control  (width/pan commands still work either way)
// TUI :analysisMode on   → restore automatic analysis-driven M/S
function stemMS(track, panVal, widthVal) {
    if (!analysisDriven) return;
    var t = String(track);
    if (!state.pan.hasOwnProperty(t)) {
        post('ms_router: stemMS — unknown track "' + t + '"\n');
        return;
    }
    applyPan(t, panVal);
    applyWidth(t, widthVal);
}

// :analysisMode on | off | 1 | 0
// on  = slicer drives pan/width per slice automatically (default)
// off = manual control via :width / :pan TUI commands only
function analysisMode(val) {
    var v = String(val).toLowerCase();
    analysisDriven = (v === 'on' || v === '1' || v === 'true');
    post('ms_router: analysisDriven = ' + analysisDriven + '\n');
    outlet(1, 'param', 'analysisMode', analysisDriven ? 1 : 0);
}

// Catch-all: suppress "can't handle message" warnings for commands that belong
// to other JS objects (buffer_manager, slot_router, etc.) — ms_router is wired
// in parallel to ws_server outlet 0 so it sees every TUI command.
function anything() {}

// Re-push all current state to Max (e.g., after autowatch reload)
function resend() {
    for (var i = 0; i < TRACKS.length; i++) {
        var t = TRACKS[i];
        applyWidth(t, state.width[t]);
        applyPan(t, state.pan[t]);
    }
    for (var i = 0; i < TRACKS.length; i++) {
        fxSend(TRACKS[i], state.fxSend[TRACKS[i]]);
    }
    fxReturn(state.fxReturn);
    setMasterGain(state.masterGain);
    post('ms_router: resent all params\n');
}
