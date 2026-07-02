const express = require('express')
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY)
const router = express.Router()

// Onboard a new DJ or artist to Stripe Connect
// They get a link to fill out their bank details directly with Stripe
// EBYS never sees their banking info
//
// POST /accounts/onboard
// Body: { userId: 'user_xxx', email: 'artist@example.com' }
router.post('/onboard', async (req, res) => {
  const { userId, email } = req.body

  try {
    // Create a Stripe Connect Express account for this person
    const account = await stripe.accounts.create({
      type: 'express',
      country: 'CA',
      email,
      capabilities: {
        transfers: { requested: true }
      }
    })

    // Generate onboarding link — they fill out their own bank details
    const accountLink = await stripe.accountLinks.create({
      account: account.id,
      refresh_url: `${process.env.BASE_URL}/accounts/onboard/retry`,
      return_url: `${process.env.BASE_URL}/accounts/onboard/complete`,
      type: 'account_onboarding'
    })

    // Save account.id mapped to userId in your database here

    res.json({ onboardingUrl: accountLink.url, stripeAccountId: account.id })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})

module.exports = router
