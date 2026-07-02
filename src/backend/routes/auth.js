const express = require('express')
const bcrypt  = require('bcryptjs')
const jwt     = require('jsonwebtoken')
const { createUser, findUserByUsername } = require('../db/queries')

const router = express.Router()

const JWT_SECRET = process.env.JWT_SECRET || 'ebys_dev_secret'

// POST /auth/register
// Body: { username, password, email, is_dj, is_artist }
router.post('/register', async (req, res) => {
  const { username, password, email, is_dj = false, is_artist = false } = req.body
  if (!username || !password) return res.status(400).json({ error: 'username and password required' })

  try {
    const hash = await bcrypt.hash(password, 10)
    const user = await createUser({ username, passwordHash: hash, email, is_dj, is_artist })
    const token = jwt.sign({ userId: user.id, username: user.username }, JWT_SECRET, { expiresIn: '30d' })
    res.json({ user: { id: user.id, username: user.username, is_dj: user.is_dj, is_artist: user.is_artist }, token })
  } catch (err) {
    if (err.code === '23505') return res.status(409).json({ error: 'username or email already taken' })
    res.status(500).json({ error: err.message })
  }
})

// POST /auth/login
// Body: { username, password }
router.post('/login', async (req, res) => {
  const { username, password } = req.body
  if (!username || !password) return res.status(400).json({ error: 'username and password required' })

  try {
    const user = await findUserByUsername(username)
    if (!user) return res.status(401).json({ error: 'invalid credentials' })

    const match = await bcrypt.compare(password, user.password_hash)
    if (!match) return res.status(401).json({ error: 'invalid credentials' })

    const token = jwt.sign({ userId: user.id, username: user.username }, JWT_SECRET, { expiresIn: '30d' })
    res.json({ user: { id: user.id, username: user.username, is_dj: user.is_dj, is_artist: user.is_artist }, token })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
})

// GET /auth/me  (protected — requires Authorization: Bearer <token>)
router.get('/me', requireAuth, async (req, res) => {
  res.json({ user: req.user })
})

// Middleware: verify JWT
function requireAuth(req, res, next) {
  const header = req.headers.authorization
  if (!header?.startsWith('Bearer ')) return res.status(401).json({ error: 'no token' })
  try {
    req.user = jwt.verify(header.slice(7), JWT_SECRET)
    next()
  } catch {
    res.status(401).json({ error: 'invalid token' })
  }
}

module.exports = { router, requireAuth }
