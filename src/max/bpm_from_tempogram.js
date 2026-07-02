// DEPRECATED — fluid.buftempogram~ does not exist in FluCoMa. Do not use.
//
// Reads a fluid.buftempogram~ output buffer (@autocorrelation 1),
// finds the dominant lag, and converts it to BPM.
// Robust to both FluCoMa buffer orientations (frames-as-lags or channels-as-lags).
//
// Usage in Max:
//   [js bpm_from_tempogram.js stem_vocals_tempogram 512]
//   inlet 0: bang to read and compute
//   outlet 0: BPM (float) — only fires if a valid BPM is found

autowatch = 1;
inlets    = 1;
outlets   = 1;

var BUF_NAME  = jsarguments.length > 1 ? jsarguments[1] : '';
var HOP_SIZE  = jsarguments.length > 2 ? parseInt(jsarguments[2]) : 512;
var SR        = 44100;

// BPM detection range
var BPM_MIN = 60;
var BPM_MAX = 200;

function bang() {
    if (!BUF_NAME) { post('bpm_from_tempogram: no buffer name argument\n'); return; }

    var buf;
    try { buf = new Buffer(BUF_NAME); }
    catch (e) { post('bpm_from_tempogram: cannot open buffer "' + BUF_NAME + '"\n'); return; }

    var nFrames = buf.framecount();
    var nChans  = buf.channelcount();
    if (nFrames <= 0 || nChans <= 0) {
        post('bpm_from_tempogram: empty buffer "' + BUF_NAME + '"\n');
        return;
    }

    // Build lag array — handle both FluCoMa buffer orientations:
    //   A) frames = lag indices, channels = 1 (or averaged)
    //   B) channels = lag indices, frames = 1 (or averaged)
    // We pick whichever dimension is larger (= number of lags).
    var lagVals = [];
    if (nFrames >= nChans) {
        // Orientation A: frames = lags
        for (var f = 0; f < nFrames; f++) {
            var sum = 0;
            for (var c = 0; c < nChans; c++) sum += buf.peek(c, f);
            lagVals.push(sum / nChans);
        }
    } else {
        // Orientation B: channels = lags
        for (var c = 0; c < nChans; c++) {
            var sum = 0;
            for (var f = 0; f < nFrames; f++) sum += buf.peek(c, f);
            lagVals.push(sum / nFrames);
        }
    }

    // Valid lag index range for BPM_MIN–BPM_MAX
    // period_samples = lagIndex * HOP_SIZE  →  BPM = SR * 60 / period_samples
    var lagMax = Math.min(lagVals.length - 1, Math.floor((SR * 60) / (BPM_MIN * HOP_SIZE)));
    var lagMin = Math.max(1,                  Math.ceil( (SR * 60) / (BPM_MAX * HOP_SIZE)));

    if (lagMin > lagMax) {
        post('bpm_from_tempogram: lag range invalid (lagMin=' + lagMin + ' lagMax=' + lagMax + ')\n');
        return;
    }

    // Find peak lag in valid range
    var bestLag = lagMin, bestVal = -Infinity;
    for (var lag = lagMin; lag <= lagMax; lag++) {
        if (lagVals[lag] > bestVal) { bestVal = lagVals[lag]; bestLag = lag; }
    }

    // Convert lag to BPM
    var period = bestLag * HOP_SIZE;
    var bpm    = Math.round((SR * 60.0 / period) * 2) / 2;  // round to 0.5 BPM

    if (bpm < BPM_MIN || bpm > BPM_MAX) {
        post('bpm_from_tempogram: computed BPM ' + bpm + ' out of range — skipping\n');
        return;
    }

    post('bpm_from_tempogram [' + BUF_NAME + ']: lag=' + bestLag
         + '  period=' + period + ' samp  BPM=' + bpm + '\n');
    outlet(0, bpm);
}
