// Split Equation
//
// Structure:
//   curator_floor  — curator always earns this just for curating
//   artist_floor   — artists always earn this just for being in the corpus
//   variable_pool  — split between curator and artists based on transformation level
//
// All values are placeholders — configurable per deployment.

const CONFIG = {
  curator_floor:  0.40,  // [40%] — always
  artist_floor:   0.10,  // [10%] — always
  variable_pool:  0.50,  // [50%] — must equal 1 - curator_floor - artist_floor

  // How much of the variable pool the curator gets at each level
  // The rest goes to the artist pool
  level_curator_variable: {
    0: 0.00,  // L0 Sequential      — curator gets [0%]   of variable
    1: 0.10,  // L1 Lightly Layered — curator gets [10%]  of variable
    2: 0.50,  // L2 Heavily Layered — curator gets [50%]  of variable
    3: 1.00,  // L3 Composed        — curator gets [100%] of variable
  }
}

// Detect transformation level from session stats
//
// N:              AVG(simultaneous_n) — avg distinct source tracks (1.0 = sequential, 3.0+ = heavy)
// segmentLengths: { VOC, MEL, BAS, DRM, avg } — AVG() of each stem column across pings
//                 variance computed here from the 4 stem averages
function detectLevel(N, segmentLengths) {
  if (N <= 1.0) return 0                                       // L0 — sequential

  if (N >= 3.0                                                 // [3.0] avg sources — placeholder
      && segmentLengths.variance >= 20.0) return 3             // [20.0] avg variance — placeholder
                                                               // L3 — composed: many sources + fractured structure

  if (N >= 1.5) return 2                                       // [1.5] avg sources — placeholder
                                                               // L2 — heavily layered

  return 1                                                      // L1 — lightly layered
}

// Main split function
//
// amountCents:    total tip amount in cents
// dj:             { stripeAccountId }
// contributions:  [{ stripeAccountId, proportion }] — from getWeightedContributions()
// sessionStats:   { N, segmentLengths: { VOC, MEL, BAS, DRM, avg } }
// deck:           'ebys' | 'direct'
function calculateSplit(amountCents, dj, contributions, sessionStats, deck) {

  // Direct mode — tip goes entirely to the DJ, no artist split
  if (deck === 'direct') {
    return {
      level: null,
      payouts: [{ stripeAccountId: dj.stripeAccountId, amountCents }]
    }
  }

  // EBYS mode — full split equation
  const { N, segmentLengths } = sessionStats

  const level = detectLevel(N, segmentLengths)
  const curatorVariable = CONFIG.level_curator_variable[level]

  // Curator total = floor + their share of the variable pool
  const curatorShare = CONFIG.curator_floor + (CONFIG.variable_pool * curatorVariable)

  // Artist total = floor + remaining variable pool
  const artistShare = CONFIG.artist_floor + (CONFIG.variable_pool * (1 - curatorVariable))

  const djCut = Math.floor(amountCents * curatorShare)
  const artistPool = Math.floor(amountCents * artistShare)

  // Artist split — proportional to duration % in the set
  const payouts = contributions.map(artist => ({
    stripeAccountId: artist.stripeAccountId,
    amountCents: Math.floor(artistPool * artist.proportion)
  }))

  // DJ payout
  payouts.push({
    stripeAccountId: dj.stripeAccountId,
    amountCents: djCut
  })

  return { level, payouts }
}

module.exports = { calculateSplit, detectLevel, CONFIG }
