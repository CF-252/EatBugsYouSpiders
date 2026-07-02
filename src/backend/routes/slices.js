const express = require('express')
const router = express.Router()
const { logSlice, logPing, openSession, closeSession } = require('../db/queries')
const { requireAuth } = require('./auth')

// EBYS opens a session when the DJ starts playing
// POST /slices/session/open
// Requires: Authorization: Bearer <token>
// Body: { venue, mode: 'web' | 'venue', deck: 'ebys' | 'direct' }
//   djId comes from the token — you can only open a session as yourself
router.post('/session/open', requireAuth, async (req, res) => {
  const djId = req.user.userId
  const { venue, mode, deck = 'ebys' } = req.body

  try {
    const session = await openSession(djId, venue, mode, deck)
    res.json({ sessionId: session.id })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})


// POST /slices/log
// Body: { sessionId, trackName, durationMs }
// trackName = EBYS source track name (e.g. "DREPTO CE3o") — looked up/created automatically
router.post('/log', async (req, res) => {
  const { sessionId, trackName, durationMs } = req.body

  try {
    await logSlice(sessionId, trackName, durationMs)
    res.json({ ok: true })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})


// EBYS pings the backend every 4 bars (calculated from current BPM)
// Captures full system state regardless of what caused it — manual command or probabilistic engine
//
// ping_interval_ms = (4 bars × 4 beats × 60000) / BPM
//   120 BPM → every 8s
//    90 BPM → every 10.6s
//    60 BPM → every 16s
//
// POST /slices/ping
// Body: {
//   sessionId,
//   simultaneousN,              — distinct source tracks across stems right now
//   segVoc, segMel, segBas, segDrm,  — per-stem segment lengths (bars)
//   segVariance                 — variance across the 4 stems (pre-computed in ws_server.js)
// }
router.post('/ping', async (req, res) => {
  const { sessionId, simultaneousN, segVoc, segMel, segBas, segDrm, segVariance } = req.body

  try {
    await logPing(sessionId, simultaneousN, segVoc, segMel, segBas, segDrm, segVariance)
    res.json({ ok: true })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})


// DJ closes the session at end of set
// Triggers batch split for all pending venue tips
// POST /slices/session/close
// Body: { sessionId }
router.post('/session/close', async (req, res) => {
  const { sessionId } = req.body

  try {
    await closeSession(sessionId)

    // Trigger batch split for venue tips
    const response = await fetch(`http://localhost:${process.env.PORT}/tips/close-session`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ sessionId })
    })

    const result = await response.json()
    res.json({ closed: true, tipsSplit: result.settled })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})


module.exports = router
