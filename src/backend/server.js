require('dotenv').config()
const express = require('express')
const app = express()

// Stripe webhooks need raw body — must come before express.json()
app.use('/tips/webhook', express.raw({ type: 'application/json' }))
app.use(express.json())
app.use(express.static('public'))

const tipsRouter     = require('./routes/tips')
const slicesRouter   = require('./routes/slices')
const accountsRouter = require('./routes/accounts')
const { router: authRouter } = require('./routes/auth')

app.use('/tips',     tipsRouter)
app.use('/slices',   slicesRouter)
app.use('/accounts', accountsRouter)
app.use('/auth',     authRouter)

const PORT = process.env.PORT || 3000
app.listen(PORT, () => console.log(`EBYS backend running on port ${PORT}`))
