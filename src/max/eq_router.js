// EBYS — EQ Router  v1
//
// ── Role ──────────────────────────────────────────────────────────────────────
// eq_router.js owns all per-stem EQ and trim parameters.
// It receives commands from ws_server.js (via TUI) and computes biquad filter
// coefficients on the fly, sending them to the appropriate biquad~ objects in
// the patch via receive objects.
//
// ── Signal chain position ────────────────────────────────────────────────────
//   pfft~/gizmo~ → *~(trim) → biquad~(low) → biquad~(mid) → biquad~(high)
//                                                               → *~0.7 → FX tap → M/S → pan
//
// ── EQ Bands ─────────────────────────────────────────────────────────────────
//   Low   — low shelf,  fc=80 Hz,    Q=0.7,  range ±12 dB  (kill = -96 dB)
//   Mid   — bell/peak,  fc=1000 Hz,  Q=0.7,  range ±12 dB
//   High  — high shelf, fc=10000 Hz, Q=0.7,  range ±12 dB
//   Trim  — input gain, range ±12 dB (0 dB default = 1.0 linear)
//
// ── Commands (inlet 0) ────────────────────────────────────────────────────────
//   eqLow  <stem> <dB>   — low shelf gain  (-96 to +12 dB; -96 = kill)
//   eqMid  <stem> <dB>   — mid peak gain   (-96 to +12 dB; -96 = kill)
//   eqHigh <stem> <dB>   — high shelf gain (-96 to +12 dB; -96 = kill)
//   trim   <stem> <dB>   — input gain      (-12 to +12 dB)
//
//   Stems: vocals | melody | bass | drums | all
//
// ── Outlets ───────────────────────────────────────────────────────────────────
//   0  → biquad~ coefficients and trim gain via patch receive objects
//   1  → status to ws_server (for TUI feedback)
// ──────────────────────────────────────────────────────────────────────────────

autowatch = 1;
inlets    = 1;
outlets   = 2;

var TRACKS  = ['vocals', 'melody', 'bass', 'drums'];
var SR      = 44100;   // sample rate — update if you use a different rate

// EQ band defaults — low and high shelves are fixed frequency; mid is parametric
var EQ_BANDS = {
    low:  { type: 'lowshelf',  fc: 80,    Q: 0.7 },
    mid:  { type: 'peak',      fc: 1000,  Q: 0.7 },   // fc overridden per stem via eqMidFreq
    high: { type: 'highshelf', fc: 10000, Q: 0.7 },
};

// Mid frequency range: 200 Hz – 8000 Hz
var MID_FC_MIN = 200;
var MID_FC_MAX = 8000;

// Current state per stem:
//   low/mid/high = gain dB  |  midFreq = mid bell center Hz  |  trim = input gain dB
//   gain = channel fader (0–1 linear)  |  mute = 0|1
var state = {
    vocals: { low: 0, mid: 0, midFreq: 1000, high: 0, trim: 0, gain: 1.0, mute: 0 },
    melody: { low: 0, mid: 0, midFreq: 1000, high: 0, trim: 0, gain: 1.0, mute: 0 },
    bass:   { low: 0, mid: 0, midFreq: 1000, high: 0, trim: 0, gain: 1.0, mute: 0 },
    drums:  { low: 0, mid: 0, midFreq: 1000, high: 0, trim: 0, gain: 1.0, mute: 0 },
};

// ── Biquad coefficient math ───────────────────────────────────────────────────
// All formulas from Audio EQ Cookbook (Robert Bristow-Johnson).
// Max biquad~ argument order: a1  a2  b0  b1  b2   (normalized by a0)

function clamp(v, lo, hi) { return v < lo ? lo : v > hi ? hi : v; }

function lowShelf(fc, gainDB, Q) {
    var A  = Math.pow(10, gainDB / 40);
    var w0 = 2 * Math.PI * fc / SR;
    var cw = Math.cos(w0);
    var sw = Math.sin(w0);
    var al = sw / (2 * Q);

    var b0 =  A * ((A + 1) - (A - 1) * cw + 2 * Math.sqrt(A) * al);
    var b1 =  2 * A * ((A - 1) - (A + 1) * cw);
    var b2 =  A * ((A + 1) - (A - 1) * cw - 2 * Math.sqrt(A) * al);
    var a0 =       (A + 1) + (A - 1) * cw + 2 * Math.sqrt(A) * al;
    var a1 = -2 * ((A - 1) + (A + 1) * cw);
    var a2 =       (A + 1) + (A - 1) * cw - 2 * Math.sqrt(A) * al;

    return [a1/a0, a2/a0, b0/a0, b1/a0, b2/a0];
}

function highShelf(fc, gainDB, Q) {
    var A  = Math.pow(10, gainDB / 40);
    var w0 = 2 * Math.PI * fc / SR;
    var cw = Math.cos(w0);
    var sw = Math.sin(w0);
    var al = sw / (2 * Q);

    var b0 =  A * ((A + 1) + (A - 1) * cw + 2 * Math.sqrt(A) * al);
    var b1 = -2 * A * ((A - 1) + (A + 1) * cw);
    var b2 =  A * ((A + 1) + (A - 1) * cw - 2 * Math.sqrt(A) * al);
    var a0 =       (A + 1) - (A - 1) * cw + 2 * Math.sqrt(A) * al;
    var a1 =  2 * ((A - 1) - (A + 1) * cw);
    var a2 =       (A + 1) - (A - 1) * cw - 2 * Math.sqrt(A) * al;

    return [a1/a0, a2/a0, b0/a0, b1/a0, b2/a0];
}

function peak(fc, gainDB, Q) {
    var A  = Math.pow(10, gainDB / 40);
    var w0 = 2 * Math.PI * fc / SR;
    var cw = Math.cos(w0);
    var al = Math.sin(w0) / (2 * Q);

    var b0 =  1 + al * A;
    var b1 = -2 * cw;
    var b2 =  1 - al * A;
    var a0 =  1 + al / A;
    var a1 = -2 * cw;
    var a2 =  1 - al / A;

    return [a1/a0, a2/a0, b0/a0, b1/a0, b2/a0];
}

// fcOverride is optional — used for mid band to pass per-stem midFreq
function computeCoefs(band, gainDB, fcOverride) {
    var b  = EQ_BANDS[band];
    var fc = fcOverride || b.fc;
    if (b.type === 'lowshelf')  return lowShelf(fc,  gainDB, b.Q);
    if (b.type === 'highshelf') return highShelf(fc, gainDB, b.Q);
    return peak(fc, gainDB, b.Q);
}

// ── Send helpers ──────────────────────────────────────────────────────────────

function sendCoefs(stem, band, gainDB) {
    // For mid band, pass the per-stem parametric frequency
    var fcOverride = (band === 'mid') ? state[stem].midFreq : undefined;
    var coefs = computeCoefs(band, gainDB, fcOverride);
    // Output: eq_<band>_coef_<stem>  a1 a2 b0 b1 b2
    // The patch routes this to the matching biquad~ via receive+prepend chain.
    outlet(0, 'eq_' + band + '_coef_' + stem,
           coefs[0], coefs[1], coefs[2], coefs[3], coefs[4]);
    outlet(1, 'param', 'eq' + band[0].toUpperCase() + band.slice(1) + '_' + stem, gainDB);
}

function sendTrim(stem, gainDB) {
    var linear = Math.pow(10, gainDB / 20);
    outlet(0, 'trim_' + stem, linear);
    outlet(1, 'param', 'trim_' + stem, gainDB);
}

// ── Command handlers ──────────────────────────────────────────────────────────

function applyEQ(stem, band, db) {
    db = clamp(parseFloat(db) || 0, -96, 12);
    state[stem][band] = db;
    sendCoefs(stem, band, db);
    post('eq_router: eq' + band + '[' + stem + '] = ' + db.toFixed(1) + ' dB\n');
}

function eqLow(stem, db) {
    if (!stem) return;
    var targets = String(stem) === 'all' ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        if (state[targets[i]]) applyEQ(targets[i], 'low', db);
    }
}

function eqMid(stem, db) {
    if (!stem) return;
    var targets = String(stem) === 'all' ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        if (state[targets[i]]) applyEQ(targets[i], 'mid', db);
    }
}

function eqHigh(stem, db) {
    if (!stem) return;
    var targets = String(stem) === 'all' ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        if (state[targets[i]]) applyEQ(targets[i], 'high', db);
    }
}

// ── eqMidFreq — parametric mid center frequency ───────────────────────────────
// eqMidFreq <stem> <hz>   — set mid bell center frequency (200–8000 Hz)
// Recomputes mid biquad coefficients at the new frequency with current gain.
function eqMidFreq(stem, hz) {
    if (!stem) return;
    var fc = clamp(parseFloat(hz) || 1000, MID_FC_MIN, MID_FC_MAX);
    var targets = String(stem) === 'all' ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        var t = targets[i];
        if (!state[t]) continue;
        state[t].midFreq = fc;
        sendCoefs(t, 'mid', state[t].mid);   // recompute with new freq, same gain
        outlet(1, 'param', 'eqMidFreq_' + t, fc);
        post('eq_router: midFreq[' + t + '] = ' + fc.toFixed(0) + ' Hz\n');
    }
}

function trim(stem, db) {
    if (!stem) return;
    db = clamp(parseFloat(db) || 0, -12, 12);
    var targets = String(stem) === 'all' ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        if (state[targets[i]]) {
            state[targets[i]].trim = db;
            sendTrim(targets[i], db);
            post('eq_router: trim[' + targets[i] + '] = ' + db.toFixed(1) + ' dB\n');
        }
    }
}

// ── setStemGain ───────────────────────────────────────────────────────────────
// setStemGain <stem> <0–1>  — channel fader (post-EQ output level)
// 0 = silence, 1 = full, 0.75 = unity for most DJ contexts
function setStemGain(stem, val) {
    if (!stem) return;
    var v = clamp(parseFloat(val) || 0, 0, 1);
    var targets = String(stem) === 'all' ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        var t = targets[i];
        if (!state[t]) continue;
        state[t].gain = v;
        // Apply mute on top: if muted, output 0 regardless of fader
        var effective = state[t].mute ? 0 : v;
        outlet(0, 'gain_' + t, effective);
        outlet(1, 'param', 'gain_' + t, v);
        post('eq_router: gain[' + t + '] = ' + v.toFixed(3) + '\n');
    }
}

// ── setStemMute ───────────────────────────────────────────────────────────────
// setStemMute <stem> <0|1>  — mute button (0=unmute, 1=mute)
function setStemMute(stem, val) {
    if (!stem) return;
    var v = (parseInt(val) === 1 || String(val) === 'on') ? 1 : 0;
    var targets = String(stem) === 'all' ? TRACKS : [String(stem)];
    for (var i = 0; i < targets.length; i++) {
        var t = targets[i];
        if (!state[t]) continue;
        state[t].mute = v;
        // Mute overrides gain: output 0 when muted
        var effective = v ? 0 : state[t].gain;
        outlet(0, 'gain_' + t, effective);
        outlet(1, 'param', 'mute_' + t, v);
        post('eq_router: mute[' + t + '] = ' + (v ? 'MUTED' : 'on') + '\n');
    }
}

function info() {
    for (var i = 0; i < TRACKS.length; i++) {
        var t = TRACKS[i];
        var s = state[t];
        post('eq_router: ' + t + ' — trim=' + s.trim.toFixed(1)
             + ' low=' + s.low.toFixed(1)
             + ' mid=' + s.mid.toFixed(1) + 'dB@' + s.midFreq.toFixed(0) + 'Hz'
             + ' high=' + s.high.toFixed(1) + ' dB'
             + '  gain=' + s.gain.toFixed(2)
             + (s.mute ? '  [MUTED]' : '') + '\n');
    }
}

// Re-push all state to Max (e.g. after autowatch reload)
function resend() {
    for (var i = 0; i < TRACKS.length; i++) {
        var t = TRACKS[i];
        sendTrim(t, state[t].trim);
        sendCoefs(t, 'low',  state[t].low);
        sendCoefs(t, 'mid',  state[t].mid);   // uses state[t].midFreq internally
        sendCoefs(t, 'high', state[t].high);
        var effective = state[t].mute ? 0 : state[t].gain;
        outlet(0, 'gain_' + t, effective);
    }
    post('eq_router: resent all params\n');
}

// Catch-all: suppress warnings for commands owned by other JS objects
function anything() {}
