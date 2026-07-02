// tsne_worker.js — t-SNE in a child process, communicating via stdin/stdout JSON.
//
// stdin/stdout is used instead of fork() IPC because N4M (node.script) intercepts
// process.send / ChildProcess message events for its own Max↔Node comms, which
// corrupts the IPC channel.  Plain stdio is invisible to N4M.
//
// Protocol: parent writes JSON({ stems }) to stdin, child writes JSON(results) to stdout.

'use strict';

function runTSNE(features, opts) {
    opts = opts || {};
    const perplexity = Math.min(opts.perplexity || 30, Math.floor(features.length / 3));
    const nIter = opts.nIter || 250;
    const lr    = opts.lr    || 200;
    const n = features.length;
    const dim = features[0].length;

    if (n < 5) return features.map(() => [(Math.random()-0.5)*0.1, (Math.random()-0.5)*0.1]);

    // Normalise each dimension to [0,1]
    const mins = [], rngs = [];
    for (let j = 0; j < dim; j++) {
        let mn = Infinity, mx = -Infinity;
        for (let i = 0; i < n; i++) {
            if (features[i][j] < mn) mn = features[i][j];
            if (features[i][j] > mx) mx = features[i][j];
        }
        mins.push(mn); rngs.push(mx > mn ? mx - mn : 1);
    }
    const X = features.map(f => f.map((v, j) => (v - mins[j]) / rngs[j]));

    // Pairwise squared distances
    const D2 = Array.from({length: n}, (_, i) =>
        Array.from({length: n}, (_, j) => {
            if (i === j) return 0;
            let s = 0;
            for (let k = 0; k < dim; k++) { const d = X[i][k] - X[j][k]; s += d*d; }
            return s;
        })
    );

    // Conditional probabilities with perplexity-based bandwidth search
    const P = Array.from({length: n}, () => new Array(n).fill(0));
    const logPerp = Math.log(perplexity);
    for (let i = 0; i < n; i++) {
        let lo = -Infinity, hi = Infinity, beta = 1;
        for (let t = 0; t < 50; t++) {
            let sum = 0;
            for (let j = 0; j < n; j++) { if (i !== j) sum += Math.exp(-D2[i][j] * beta); }
            if (sum === 0) sum = 1e-10;
            let H = 0;
            for (let j = 0; j < n; j++) {
                if (i === j) continue;
                const p = Math.exp(-D2[i][j] * beta) / sum;
                if (p > 1e-12) H -= p * Math.log(p);
            }
            const diff = H - logPerp;
            if (Math.abs(diff) < 1e-5) break;
            if (diff > 0) { lo = beta; beta = hi === Infinity ? beta * 2 : (beta + hi) / 2; }
            else          { hi = beta; beta = lo === -Infinity ? beta / 2 : (beta + lo) / 2; }
        }
        let sum = 0;
        for (let j = 0; j < n; j++) { if (i !== j) sum += Math.exp(-D2[i][j] * beta); }
        if (sum === 0) sum = 1e-10;
        for (let j = 0; j < n; j++) P[i][j] = i === j ? 0 : Math.exp(-D2[i][j] * beta) / sum;
    }

    // Symmetrise
    const Ps = Array.from({length: n}, (_, i) =>
        Array.from({length: n}, (_, j) => Math.max((P[i][j] + P[j][i]) / (2*n), 1e-12))
    );

    // Random init
    const Y     = Array.from({length: n}, () => [(Math.random()-0.5)*0.01, (Math.random()-0.5)*0.01]);
    const iY    = Array.from({length: n}, () => [0, 0]);
    const gains = Array.from({length: n}, () => [1, 1]);

    for (let iter = 0; iter < nIter; iter++) {
        const exag = iter < 100 ? 4 : 1;
        const num = Array.from({length: n}, (_, i) =>
            Array.from({length: n}, (_, j) => {
                if (i === j) return 0;
                const dx = Y[i][0]-Y[j][0], dy = Y[i][1]-Y[j][1];
                return 1 / (1 + dx*dx + dy*dy);
            })
        );
        let sumQ = 0;
        for (let i = 0; i < n; i++) for (let j = 0; j < n; j++) sumQ += num[i][j];
        if (sumQ === 0) sumQ = 1e-10;

        const dY = Array.from({length: n}, () => [0, 0]);
        for (let i = 0; i < n; i++) {
            for (let j = 0; j < n; j++) {
                if (i === j) continue;
                const pq   = exag * Ps[i][j] - num[i][j] / sumQ;
                const mult = 4 * pq * num[i][j];
                dY[i][0] += mult * (Y[i][0] - Y[j][0]);
                dY[i][1] += mult * (Y[i][1] - Y[j][1]);
            }
        }
        const mom = iter < 20 ? 0.5 : 0.8;
        for (let i = 0; i < n; i++) {
            for (let k = 0; k < 2; k++) {
                const sameSign = (dY[i][k] > 0) === (iY[i][k] > 0);
                gains[i][k] = sameSign ? Math.max(0.01, gains[i][k] * 0.8) : gains[i][k] + 0.2;
                iY[i][k] = mom * iY[i][k] - lr * gains[i][k] * dY[i][k];
                Y[i][k] += iY[i][k];
            }
        }
        if (iter % 50 === 0) {
            let cx = 0, cy = 0;
            for (let i = 0; i < n; i++) { cx += Y[i][0]; cy += Y[i][1]; }
            cx /= n; cy /= n;
            for (let i = 0; i < n; i++) { Y[i][0] -= cx; Y[i][1] -= cy; }
        }
    }
    return Y;
}

// Read JSON from stdin, run t-SNE, write JSON to stdout.
let inputJson = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', chunk => { inputJson += chunk; });
process.stdin.on('end', () => {
    try {
        const { stems } = JSON.parse(inputJson);
        const results = {};
        for (const { stem, ids, features, nIter } of stems) {
            const t0 = Date.now();
            const embedding = runTSNE(features, { nIter });
            const coords = {};
            for (let i = 0; i < ids.length; i++) {
                coords[ids[i]] = [embedding[i][0], embedding[i][1]];
            }
            results[stem] = { coords, ms: Date.now() - t0 };
        }
        // Use end() instead of write()+exit() — large JSON (>64KB) would be
        // truncated if the process exits before the pipe buffer drains.
        // end() keeps the event loop alive until the stream is fully flushed,
        // then Node exits naturally.
        process.stdout.end(JSON.stringify(results));
    } catch(e) {
        process.stderr.write('tsne_worker error: ' + e + '\n');
        process.exit(1);
    }
});
