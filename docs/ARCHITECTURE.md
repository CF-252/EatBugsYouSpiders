# EBYS — System Architecture

> **EBYS** (Eat Bugs You Spider!) is a neural DJ instrument, a web radio, and an open tipping protocol. This document covers the full system — all layers from the instrument to the backend, Stripe, the database, the registrar, and infrastructure.
>
> For the instrument internals (Max patch, slicer, buffer engine, Cricket), see `docs/instrument/ARCHITECTURE.md`.

---

## Table of Contents

1. [System Topology](#1-system-topology)
2. [The Instrument Layer](#2-the-instrument-layer)
3. [The Backend](#3-the-backend)
4. [Database](#4-database)
5. [Session Logging](#5-session-logging)
6. [The Tipping Protocol](#6-the-tipping-protocol)
7. [The Split Equation](#7-the-split-equation)
8. [Stripe Integration](#8-stripe-integration)
9. [The LINK Protocol](#9-the-link-protocol)
10. [Web Radio](#10-web-radio)
11. [Infrastructure](#11-infrastructure)
12. [The Registrar](#12-the-registrar)
13. [Environment Variables](#13-environment-variables)
14. [API Reference](#14-api-reference)

---

## 1. System Topology

```
┌─────────────────────────────────────────────────────────────────┐
│  INSTRUMENT (local, laptop)                                     │
│  Max/MSP + Node.js (N4M)                                        │
│  watch_demucs.py + FluCoMa analysis pipeline                   │
│  sdj-tui.js (TUI control surface)                               │
└──────────────────────────┬──────────────────────────────────────┘
                           │  HTTP   POST /slices/ping
                           │  HTTP   POST /slices/log
                           │  HTTP   POST /slices/session/open
                           │  HTTP   POST /slices/session/close
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│  BACKEND  (Railway, Node.js/Express)                            │
│  server.js                                                      │
│  ├── /auth        JWT registration + login                      │
│  ├── /slices      session + slice + ping logging                │
│  ├── /tips        Stripe Checkout + webhook + split             │
│  └── /accounts    Stripe Connect onboarding                     │
│                                                                 │
│  PostgreSQL (Railway)                                           │
│  users · tracks · sessions · slices · pings · tips · payouts   │
└──────────────────────────┬──────────────────────────────────────┘
                           │
             ┌─────────────┼─────────────┐
             │             │             │
             ▼             ▼             ▼
        Stripe         Listener      Stripe Connect
        Checkout       (browser)     (DJ + artist
        /create        tip.html      bank accounts)
             │
             └── Stripe webhook → /tips/webhook
                                   → calculateSplit()
                                   → stripe.transfers (to DJ + artists)

┌─────────────────────────────────────────────────────────────────┐
│  WEB RADIO  (Icecast / Liquidsoap)                              │
│  Max audio out → BlackHole → Liquidsoap → Icecast stream       │
│  Radio page: now-playing, tip button, artist thumbnails         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  DOMAIN  (eatbugsyouspider.com / .org)                          │
│  Cargo → Cloudflare (in progress)                              │
│  Cloudflare → Railway backend (custom domain)                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. The Instrument Layer

The instrument runs locally on a laptop. It handles everything audio: stem separation, spectral analysis, real-time slice selection, playback, AI control surface.

**Key processes:**
- `watch_demucs.py` — daemon that ingests audio, runs Demucs + Essentia + madmom
- `ebys-analyze.maxpat` — Max/MSP patch (FluCoMa analysis + playback engine)
- `sdj-tui.js` — terminal control surface

**Backend communication:** the instrument POSTs to the backend every 4 bars (ping), on each slice change (log), and when the DJ opens/closes a session. It does not receive commands from the backend — the instrument is authoritative over what played.

See `docs/instrument/ARCHITECTURE.md` for the full instrument internals.

---

## 3. The Backend

**Runtime:** Node.js + Express  
**Deployment:** Railway  
**Database:** PostgreSQL (Railway managed)  
**Entry point:** `Tipping_protocol/backend/server.js`

Four route modules:

| Route | File | Role |
|---|---|---|
| `/auth` | `routes/auth.js` | Registration, login, JWT middleware |
| `/slices` | `routes/slices.js` | Session open/close, slice logging, pings |
| `/tips` | `routes/tips.js` | Stripe Checkout, webhook, split |
| `/accounts` | `routes/accounts.js` | Stripe Connect onboarding for DJs/artists |

**Note on raw body:** Stripe webhooks require the raw request body for signature verification. `express.raw({ type: 'application/json' })` is mounted on `/tips/webhook` before `express.json()` — order matters.

---

## 4. Database

The database is the source of truth for who can receive payouts and what tracks are in the EBYS corpus.

### Users table
```sql
users (
  id                SERIAL PRIMARY KEY,
  username          VARCHAR(255) UNIQUE,   -- public DJ or artist name
  password_hash     VARCHAR(255),          -- null until account claimed
  email             VARCHAR(255) UNIQUE,
  is_dj             BOOLEAN DEFAULT false,
  is_artist         BOOLEAN DEFAULT false,
  stripe_account_id VARCHAR(255),          -- Stripe Connect account (required for payouts)
  solana_wallet     VARCHAR(255),          -- for CRKT conversion (optional)
  created_at        TIMESTAMP DEFAULT NOW()
)
```

**Unclaimed accounts:** artists can accumulate earnings before registering. The track fingerprint is the key — when an artist claims their account, their pending payouts are linked. `password_hash` is null until claimed.

**Roles:** a user can be both a DJ (`is_dj = true`) and an artist (`is_artist = true`).

### Tracks table
```sql
tracks (
  id          SERIAL PRIMARY KEY,
  title       VARCHAR(255),
  artist_id   INTEGER REFERENCES users(id),
  fingerprint VARCHAR(255) UNIQUE,   -- audio fingerprint for unclaimed matching
  created_at  TIMESTAMP DEFAULT NOW()
)
```

The `fingerprint` field links tracks to their artist even before the artist has an account. When a tip fires and `artist_id` is null on a track, the payout goes to escrow (currently: stays as `pending` with a null `stripe_account_id`, flagged for later).

### Auth flow

```
POST /auth/register  { username, password, email, is_dj, is_artist }
  → bcrypt hash → createUser() → JWT (30d expiry)
  → returns { user, token }

POST /auth/login  { username, password }
  → findUserByUsername() → bcrypt.compare() → JWT
  → returns { user, token }

GET /auth/me  (Bearer token)
  → requireAuth middleware → returns { user }
```

JWT is signed with `JWT_SECRET` (env var). Token expiry is 30 days — **token refresh not yet implemented** (backlog).

---

## 5. Session Logging

The session log is what makes the split equation possible. Without accurate session data, tips can't be distributed correctly.

### Session lifecycle

```
DJ opens Max + TUI
        │
POST /slices/session/open  { venue, mode, deck }
        │ returns { sessionId }
        │
        ▼
EBYS plays (instrument running)
        │
        ├── POST /slices/log  { sessionId, trackName, durationMs }
        │     — on every slice change (per stem)
        │
        └── POST /slices/ping  { sessionId, simultaneousN, segVoc/Mel/Bas/Drm, segVariance }
              — every 4 bars (based on current BPM)
              — 120 BPM → every 8s
              —  90 BPM → every 10.6s
              —  60 BPM → every 16s
        │
POST /slices/session/close  { sessionId }
        │ → triggers batch split for any pending venue tips
```

### Pings table

```sql
pings (
  session_id     INTEGER REFERENCES sessions(id),
  simultaneous_n FLOAT,   -- distinct source tracks across all stems right now
  seg_voc        FLOAT,   -- segment length for vocals stem (bars)
  seg_mel        FLOAT,   -- segment length for melody stem (bars)
  seg_bas        FLOAT,   -- segment length for bass stem (bars)
  seg_drm        FLOAT,   -- segment length for drums stem (bars)
  seg_variance   FLOAT,   -- variance across the 4 stems — L3 signal
  recorded_at    TIMESTAMP DEFAULT NOW()
)
```

`simultaneous_n` and `seg_variance` are the two signals the split equation uses to detect transformation level. They come from EBYS's live state — not computed after the fact.

---

## 6. The Tipping Protocol

### Web mode

```
Listener is on the radio page during a live set
        │
[TIP THIS SET]  → POST /tips/create  { amountCents, sessionId, mode: 'web' }
        │ returns { clientSecret }
        │
Stripe.js completes the payment (card / Apple Pay)
        │
Stripe → POST /tips/webhook  payment_intent.succeeded
        │
runSplit(paymentIntentId, sessionId, amountCents, tipTime)
        │ tipTime = exact moment of the tip
        │ session log is cut at this timestamp
        │ only what played before the tip counts
        │
stripe.transfers → DJ + contributing artists
```

### Venue mode

```
Listener taps card at the venue (any time during the night)
        │
POST /tips/create  { amountCents, sessionId, mode: 'venue' }
        │
Stripe webhook fires → payment_intent.succeeded
        │ mode = 'venue' → tip held as pending
        │ no split yet
        │
DJ closes the session at end of night
        │
POST /slices/session/close → triggers POST /tips/close-session
        │
All pending tips split at once using the full session log
        │
stripe.transfers → DJ + contributing artists
```

**Key difference:** web tips are split at the moment of payment (using what played up to then). Venue tips are held until session close and then split over the full set.

### tip_direction (▲⬢▼)

Each tip has a `tip_direction` field (`'up'`, `'equal'`, `'down'`). Currently stored but not used in split calculation. Planned: direction modifies the curator's variable pool share within the level.

---

## 7. The Split Equation

**File:** `Tipping_protocol/backend/split.js`

### Transformation levels

| Level | Name | Signal | Curator variable |
|---|---|---|---|
| L0 | Sequential | `avg_N ≤ 1.0` | 0% |
| L1 | Lightly Layered | `avg_N > 1.0` | 10% |
| L2 | Heavily Layered | `avg_N ≥ 1.5` | 50% |
| L3 | Composed | `avg_N ≥ 3.0` AND `seg_variance ≥ 20` | 100% |

`avg_N` = `AVG(simultaneous_n)` across all pings for the session (up to tipTime).  
`seg_variance` = `AVG(seg_variance)` from pings — variance across the 4 stem segment lengths, pre-computed by `ws_server.js`.

### Formula

```
CONFIG:
  curator_floor   = 40%   (always, regardless of level)
  artist_floor    = 10%   (always, regardless of level)
  variable_pool   = 50%   (curator and artists split this based on level)

curator_share = curator_floor + (variable_pool × level_curator_variable[level])
artist_share  = artist_floor  + (variable_pool × (1 − level_curator_variable[level]))

dj_cut      = tip × curator_share
artist_pool = tip × artist_share

per_artist  = artist_pool × artist.proportion
```

`artist.proportion` comes from `getWeightedContributions()` — duration each artist's tracks occupied in the session log, normalized to sum to 1.0.

### Direct mode

When `deck = 'direct'` (non-EBYS performance, card reader only): full tip goes to the DJ, no split.

---

## 8. Stripe Integration

### Stripe Checkout (listener payments)

- **`stripe.paymentIntents.create`** — called on `/tips/create`. Returns `clientSecret` to frontend.
- **`stripe.webhooks.constructEvent`** — called on `/tips/webhook`. Validates signature using `STRIPE_WEBHOOK_SECRET`. Processes `payment_intent.succeeded`.
- Currency: `cad`
- Payment methods: card, Apple Pay, Google Pay (via `automatic_payment_methods: { enabled: true }`)

### Stripe Connect (DJ and artist payouts)

- **`stripe.accounts.create`** — called on `/accounts/onboard`. Creates an Express account (type `'express'`, country `'CA'`).
- **`stripe.accountLinks.create`** — generates a hosted onboarding URL. The DJ/artist fills out their bank details directly with Stripe. EBYS never sees banking info.
- **`stripe.transfers.create`** — called inside `runSplit()` after the split equation runs. One transfer per recipient. `transfer_group = paymentIntentId` links all transfers from the same tip.

**Current blocker:** DJs and artists don't have connected Stripe accounts yet. Transfers fail with "no destination account." Fix: build the DJ profile page with the Stripe Connect onboarding flow (`/accounts/onboard`).

### Stripe keys

| Variable | Used for |
|---|---|
| `STRIPE_SECRET_KEY` | All server-side Stripe calls |
| `STRIPE_WEBHOOK_SECRET` | Webhook signature verification |

Both are Railway env vars. Never committed to git.

---

## 9. The LINK Protocol

LINK is the multi-deck synchronization layer for live performance with two or more EBYS decks in the same space.

**What it does:**
- **Clock sync** — all decks share the same bar grid. Bar boundaries are synchronized.
- **Arc visibility** — each deck's TUI shows other decks' current transformation level (▲⬢▼). DJs see each other's state and can coordinate or contrast.
- **Selection sync** (optional) — decks can avoid playing the same track simultaneously, mirror each other, or play complementary descriptor neighborhoods.

**The missile switch** — a two-key confirmation sequence (`:link arm` on both decks, `:link fire` to execute) that drops all connected decks to a specific state simultaneously.

**Network:** UDP multicast on the local network. No internet. Leader-based clock: first deck to start is the clock leader. No central coordinator.

**Status:** clock sync implemented. Arc visibility in progress. Missile switch designed, not yet wired. Selection sync designed, not started.

See `docs/instrument/LINK.md` for full command reference.

---

## 10. Web Radio

The radio streams live EBYS performances to listeners anywhere.

```
Max/MSP audio output (stereo 44.1kHz)
        │
BlackHole (macOS virtual audio device)
        │
Liquidsoap — encodes stream (ogg/mp3)
        │
Icecast — serves the stream
        │
Radio page — embedded player, now-playing display, tip button
```

**Now-playing:** ws_server.js broadcasts `stemTrack` messages every slice change. The radio page subscribes via WebSocket and updates the display in real time (track name, artist, transformation level).

**Tipping from the radio:** the tip button calls `/tips/create` with the active `sessionId`. Stripe Checkout opens in the same page. The tip is split at the moment of payment.

**Status:** streaming works. Now-playing display works. Temperature entropy indicator (planned) will show the `δT` climate signal live on the page.

---

## 11. Infrastructure

### Railway

The backend runs on Railway. Environment variables are set in Railway's dashboard — never in code or git.

**Domain:** Railway provides a `.railway.app` subdomain. Custom domain (`eatbugsyouspider.com`) requires pointing Cloudflare DNS to Railway's CNAME.

**PostgreSQL:** Railway managed Postgres. Connection string in `DATABASE_URL` env var.

### Python environments (instrument-side)

| Environment | Python | Libraries | Used for |
|---|---|---|---|
| `demucs_env/` | 3.14 | torch, demucs | Stem separation |
| System | 3.10–3.11 | essentia, madmom | Genre + downbeat analysis |
| `~/ebys-mlx-env` | — | mlx-lm | Cricket LoRA fine-tuning (Apple Silicon) |

---

## 12. The Registrar

The domain registrar is where `eatbugsyouspider.com` and `eatbugsyouspider.org` live and where DNS is managed.

**Current state:** both domains are registered on **Cargo**.

**Target state:** transferred to **Cloudflare Registrar**.

Cloudflare is the right long-term home because:
- DNS management is in the same place as DDoS protection and SSL
- Cloudflare → Railway CNAME for the backend (custom domain on `eatbugsyouspider.com`)
- Cloudflare → Icecast for the stream subdomain (e.g. `stream.eatbugsyouspider.com`)
- Cargo offers no useful features beyond basic registration

**Transfer process:**
1. Email Cargo support requesting EPP (authorization) codes for both domains
2. Unlock the domains in Cargo's dashboard
3. In Cloudflare Registrar: initiate transfer, enter EPP codes
4. Approve the transfer email (sent to domain contact email)
5. Transfer completes in 5–7 days
6. Update nameservers to Cloudflare's in Cloudflare dashboard
7. Add DNS records: Railway CNAME + Icecast A record

**Status:** EPP codes not yet requested. Cargo support email pending.

---

## 13. Environment Variables

All set in Railway dashboard. Never committed to git (`.env` is gitignored).

| Variable | Used by | Notes |
|---|---|---|
| `DATABASE_URL` | `db/queries.js` | PostgreSQL connection string |
| `STRIPE_SECRET_KEY` | `routes/tips.js`, `routes/accounts.js` | Server-side Stripe API key |
| `STRIPE_WEBHOOK_SECRET` | `routes/tips.js` | Webhook signature verification |
| `JWT_SECRET` | `routes/auth.js` | JWT signing key |
| `PORT` | `server.js` | Railway sets this automatically |
| `BASE_URL` | `routes/accounts.js` | Full URL for Stripe Connect redirect URLs |

---

## 14. API Reference

### Auth

| Method | Path | Auth | Body | Returns |
|---|---|---|---|---|
| POST | `/auth/register` | — | `{ username, password, email, is_dj, is_artist }` | `{ user, token }` |
| POST | `/auth/login` | — | `{ username, password }` | `{ user, token }` |
| GET | `/auth/me` | Bearer | — | `{ user }` |

### Sessions + Slices

| Method | Path | Auth | Body | Returns |
|---|---|---|---|---|
| POST | `/slices/session/open` | Bearer | `{ venue, mode, deck }` | `{ sessionId }` |
| POST | `/slices/log` | — | `{ sessionId, trackName, durationMs }` | `{ ok }` |
| POST | `/slices/ping` | — | `{ sessionId, simultaneousN, segVoc, segMel, segBas, segDrm, segVariance }` | `{ ok }` |
| POST | `/slices/session/close` | — | `{ sessionId }` | `{ closed, tipsSplit }` |

### Tips

| Method | Path | Auth | Body | Returns |
|---|---|---|---|---|
| POST | `/tips/create` | — | `{ amountCents, sessionId, mode }` | `{ clientSecret }` |
| POST | `/tips/webhook` | Stripe-Signature header | raw body | `{ received }` |
| POST | `/tips/test` | — | `{ sessionId, amountCents }` | `{ level, payouts, contributions }` |

### Accounts

| Method | Path | Auth | Body | Returns |
|---|---|---|---|---|
| POST | `/accounts/onboard` | — | `{ userId, email }` | `{ onboardingUrl, stripeAccountId }` |
