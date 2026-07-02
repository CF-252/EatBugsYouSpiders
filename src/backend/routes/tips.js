const express = require('express')
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY)
const { calculateSplit } = require('../split')
const { getSessionLog, getWeightedContributions, getAvgSessionStats, getPendingVenueTips, recordPayout, markTipSplit } = require('../db/queries')
const router = express.Router()


// Step 1 — Listener initiates a tip
// Frontend calls this, gets a clientSecret, completes payment with Stripe.js
//
// POST /tips/create
// Body: { amountCents: 500, sessionId: 'session_xxx', mode: 'web' | 'venue' }
router.post('/create', async (req, res) => {
  const { amountCents, sessionId, mode } = req.body

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountCents,
      currency: 'cad',
      metadata: { sessionId, mode },
      automatic_payment_methods: { enabled: true }
    })

    res.json({ clientSecret: paymentIntent.client_secret })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})


// Step 2 — Stripe confirms payment via webhook
// Stripe calls this after the listener's card is charged
//
// POST /tips/webhook
router.post('/webhook', async (req, res) => {
  const sig = req.headers['stripe-signature']
  let event

  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    )
  } catch (err) {
    return res.status(400).send(`Webhook error: ${err.message}`)
  }

  if (event.type === 'payment_intent.succeeded') {
    const paymentIntent = event.data.object
    const { sessionId, mode } = paymentIntent.metadata
    const amountCents = paymentIntent.amount
    const tipTime = new Date(paymentIntent.created * 1000)

    if (mode === 'web') {
      // Web: split immediately using everything that played up to this moment
      await runSplit(paymentIntent.id, sessionId, amountCents, tipTime)
    }
    // Venue: hold as pending — split runs when DJ closes session
  }

  res.json({ received: true })
})


// Step 3 (venue only) — DJ closes the session at end of night
// All pending tips split at once using the full session log
//
// POST /tips/close-session
// Body: { sessionId }
router.post('/close-session', async (req, res) => {
  const { sessionId } = req.body

  try {
    const pendingTips = await getPendingVenueTips(sessionId)

    for (const tip of pendingTips) {
      await runSplit(tip.stripe_payment_intent_id, sessionId, tip.amount_cents, null)
    }

    res.json({ settled: pendingTips.length })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})


// TEST ONLY — simulates a tip without Stripe
// POST /tips/test
// Body: { sessionId, amountCents }
router.post('/test', async (req, res) => {
  const { sessionId, amountCents } = req.body

  try {
    const sessionLog                  = await getSessionLog(sessionId)
    const contributions               = await getWeightedContributions(sessionId, null)
    const { avgN, segmentLengths }    = await getAvgSessionStats(sessionId, null)

    const { level, payouts } = calculateSplit(
      amountCents,
      sessionLog.dj,
      contributions,
      { N: avgN, segmentLengths },
      sessionLog.deck
    )

    res.json({ level, payouts, avgN, segmentLengths, contributions, amountCents })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})


// Core split logic
// tipTime: exact moment of web tip (cuts session log there)
//          null for venue (uses full session)
async function runSplit(paymentIntentId, sessionId, amountCents, tipTime) {
  const sessionLog              = await getSessionLog(sessionId)
  const contributions           = await getWeightedContributions(sessionId, tipTime)
  const { avgN, segmentLengths } = await getAvgSessionStats(sessionId, tipTime)

  const { level, payouts } = calculateSplit(
    amountCents,
    sessionLog.dj,
    contributions,
    { N: avgN, segmentLengths },
    sessionLog.deck
  )

  for (const payout of payouts) {
    const transfer = await stripe.transfers.create({
      amount: payout.amountCents,
      currency: 'cad',
      destination: payout.stripeAccountId,
      transfer_group: paymentIntentId
    })

    await recordPayout(paymentIntentId, payout.stripeAccountId, payout.amountCents, transfer.id)
  }

  await markTipSplit(paymentIntentId)
}


module.exports = router
