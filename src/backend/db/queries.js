const { Pool } = require('pg')
const pool = new Pool({ connectionString: process.env.DATABASE_URL })

// Get the full session log for a session
// Returns DJ, all contributing artists, and the aggregate mix stats
async function getSessionLog(sessionId) {
  // Get session + DJ
  const sessionResult = await pool.query(
    `SELECT s.*, u.stripe_account_id as dj_stripe_account
     FROM sessions s
     JOIN users u ON u.id = s.dj_id
     WHERE s.id = $1`,
    [sessionId]
  )
  const session = sessionResult.rows[0]

  // Get all slices, grouped by track/artist
  // Sum duration per artist — that's their proportional weight
  const slicesResult = await pool.query(
    `SELECT
       u.id as artist_id,
       u.stripe_account_id,
       SUM(sl.duration_ms) as total_ms
     FROM slices sl
     JOIN tracks t ON t.id = sl.track_id
     JOIN users u ON u.id = t.artist_id
     WHERE sl.session_id = $1
     GROUP BY u.id, u.stripe_account_id`,
    [sessionId]
  )

  const artists = slicesResult.rows.map(row => ({
    artistId: row.artist_id,
    stripeAccountId: row.stripe_account_id,
    totalMs: parseInt(row.total_ms)
  }))

  return {
    dj: { stripeAccountId: session.dj_stripe_account },
    artists,
    mode: session.mode,
    deck: session.deck || 'ebys'
  }
}

// Open a session when the DJ starts playing
// deck: 'ebys' (full split equation) | 'direct' (100% to DJ, no artist split)
async function openSession(djId, venue, mode, deck = 'ebys') {
  const result = await pool.query(
    `INSERT INTO sessions (dj_id, venue, mode, deck) VALUES ($1, $2, $3, $4) RETURNING *`,
    [djId, venue, mode, deck]
  )
  return result.rows[0]
}

// Find or create a track record by source name.
// EBYS identifies tracks by filename (e.g. "DREPTO CE3o") — we use that as the fingerprint.
// artist_id is left NULL until the artist registers a Stripe account.
async function upsertTrack(name) {
  const result = await pool.query(
    `INSERT INTO tracks (title, fingerprint)
     VALUES ($1, $2)
     ON CONFLICT (fingerprint) DO UPDATE SET title = EXCLUDED.title
     RETURNING id`,
    [name, name]
  )
  return result.rows[0].id
}

// Log a slice as EBYS plays it.
// trackName = EBYS source track name (e.g. "DREPTO CE3o") — looked up/created automatically.
// durationMs = segment duration in ms (from slicer.js snapSegDurMs).
async function logSlice(sessionId, trackName, durationMs) {
  const trackId = await upsertTrack(trackName)
  await pool.query(
    `INSERT INTO slices (session_id, track_id, duration_ms)
     VALUES ($1, $2, $3)`,
    [sessionId, trackId, Math.round(durationMs)]
  )
}

// Get artist contributions by duration — what % of the set did each artist's tracks occupy?
// upToTime: for web tips (cut at exact tip moment). null = full session (venue).
//
// Note: follow-weighted variant (duration × avg follow weight per time window) was considered
// but dropped in favour of pure duration — simpler, more predictable for artists.
// The follow_states table and logFollowState() are kept for potential future use.
async function getWeightedContributions(sessionId, upToTime = null) {
  const timeFilter = upToTime ? `AND sl.played_at <= $2` : ''
  const params = upToTime ? [sessionId, upToTime] : [sessionId]

  const result = await pool.query(
    `SELECT
       u.id                    AS artist_id,
       u.stripe_account_id,
       SUM(sl.duration_ms)     AS total_ms
     FROM slices sl
     JOIN tracks t ON t.id = sl.track_id
     JOIN users  u ON u.id = t.artist_id
     WHERE sl.session_id = $1 ${timeFilter}
     GROUP BY u.id, u.stripe_account_id
     ORDER BY total_ms DESC`,
    params
  )

  // Normalize to proportions (0.0 to 1.0, sums to 1.0)
  const totalMs = result.rows.reduce((sum, r) => sum + parseFloat(r.total_ms), 0)

  return result.rows.map(row => ({
    artistId: row.artist_id,
    stripeAccountId: row.stripe_account_id,
    proportion: parseFloat(row.total_ms) / totalMs
  }))
}

// Log a periodic system state ping from EBYS
// seg_avg is pre-computed in ws_server.js; individual stems stored for per-stem history
async function logPing(sessionId, simultaneousN, segVoc, segMel, segBas, segDrm, segVariance) {
  await pool.query(
    `INSERT INTO pings (session_id, simultaneous_n, seg_voc, seg_mel, seg_bas, seg_drm, seg_variance)
     VALUES ($1, $2, $3, $4, $5, $6, $7)`,
    [sessionId, simultaneousN, segVoc, segMel, segBas, segDrm, segVariance]
  )
}

// Get avg stats from ping log
// upToTime: for web tips (cut at tip moment). null = full session (venue).
async function getAvgSessionStats(sessionId, upToTime = null) {
  const timeFilter = upToTime ? `AND recorded_at <= $2` : ''
  const params = upToTime ? [sessionId, upToTime] : [sessionId]

  const result = await pool.query(
    `SELECT
       AVG(simultaneous_n) AS avg_n,
       AVG(seg_voc)        AS avg_voc,
       AVG(seg_mel)        AS avg_mel,
       AVG(seg_bas)        AS avg_bas,
       AVG(seg_drm)        AS avg_drm,
       AVG(seg_variance)   AS avg_variance
     FROM pings
     WHERE session_id = $1 ${timeFilter}`,
    params
  )

  const row = result.rows[0]
  return {
    avgN: parseFloat(row?.avg_n) || 1.0,
    segmentLengths: {
      VOC:      parseFloat(row?.avg_voc)      || 8,
      MEL:      parseFloat(row?.avg_mel)      || 8,
      BAS:      parseFloat(row?.avg_bas)      || 8,
      DRM:      parseFloat(row?.avg_drm)      || 8,
      variance: parseFloat(row?.avg_variance) || 0,
    }
  }
}

// Create a new user (registration)
async function createUser({ username, passwordHash, email, is_dj, is_artist }) {
  const result = await pool.query(
    `INSERT INTO users (username, password_hash, email, is_dj, is_artist)
     VALUES ($1, $2, $3, $4, $5) RETURNING id, username, is_dj, is_artist`,
    [username, passwordHash, email, is_dj, is_artist]
  )
  return result.rows[0]
}

// Find user by username (login)
async function findUserByUsername(username) {
  const result = await pool.query(
    `SELECT * FROM users WHERE username = $1`,
    [username]
  )
  return result.rows[0] || null
}

// Close a session (end of venue set)
async function closeSession(sessionId) {
  await pool.query(
    `UPDATE sessions SET status = 'closed', closed_at = NOW() WHERE id = $1`,
    [sessionId]
  )
}

// Get all pending venue tips for a session (to batch split on close)
async function getPendingVenueTips(sessionId) {
  const result = await pool.query(
    `SELECT * FROM tips
     WHERE session_id = $1 AND mode = 'venue' AND status = 'pending'`,
    [sessionId]
  )
  return result.rows
}

// Record a payout
async function recordPayout(tipId, userId, amountCents, stripeTransferId) {
  await pool.query(
    `INSERT INTO payouts (tip_id, user_id, amount_cents, stripe_transfer_id)
     VALUES ($1, $2, $3, $4)`,
    [tipId, userId, amountCents, stripeTransferId]
  )
}

// Mark a tip as split
async function markTipSplit(tipId) {
  await pool.query(
    `UPDATE tips SET status = 'split' WHERE id = $1`,
    [tipId]
  )
}

module.exports = {
  createUser,
  findUserByUsername,
  openSession,
  getSessionLog,
  getWeightedContributions,
  getAvgSessionStats,
  upsertTrack,
  logSlice,
  logPing,
  closeSession,
  getPendingVenueTips,
  recordPayout,
  markTipSplit
}
