-- EBYS Database Schema

-- Artists and DJs
CREATE TABLE users (
  id                SERIAL PRIMARY KEY,
  username          VARCHAR(255) UNIQUE NOT NULL,  -- public DJ name
  password_hash     VARCHAR(255),                  -- null until account claimed
  email             VARCHAR(255) UNIQUE,
  is_dj             BOOLEAN DEFAULT false,
  is_artist         BOOLEAN DEFAULT false,
  stripe_account_id VARCHAR(255),                  -- Stripe Connect account
  solana_wallet     VARCHAR(255),                  -- for CRKT conversion (optional)
  created_at        TIMESTAMP DEFAULT NOW()
);

-- Tracks in the EBYS corpus
CREATE TABLE tracks (
  id            SERIAL PRIMARY KEY,
  title         VARCHAR(255),
  artist_id     INTEGER REFERENCES users(id),
  fingerprint   VARCHAR(255) UNIQUE,  -- audio fingerprint
  created_at    TIMESTAMP DEFAULT NOW()
);

-- A session = one DJ set
CREATE TABLE sessions (
  id            SERIAL PRIMARY KEY,
  dj_id         INTEGER REFERENCES users(id),
  venue         VARCHAR(255),         -- null if web radio
  mode          VARCHAR(50),          -- 'web' or 'venue' (tip timing)
  deck          VARCHAR(50) DEFAULT 'ebys',  -- 'ebys' or 'direct' (split mode)
  status        VARCHAR(50) DEFAULT 'active',  -- 'active' or 'closed'
  started_at    TIMESTAMP DEFAULT NOW(),
  closed_at     TIMESTAMP
);

-- Every slice EBYS plays gets logged
CREATE TABLE slices (
  id            SERIAL PRIMARY KEY,
  session_id    INTEGER REFERENCES sessions(id),
  track_id      INTEGER REFERENCES tracks(id),
  duration_ms   INTEGER,              -- how long this slice played
  played_at     TIMESTAMP DEFAULT NOW()
);

-- Periodic system state ping — fired every 4 bars (based on current BPM)
-- Captures full state regardless of what caused it: manual command or probabilistic engine
-- Used to compute avg segment length variance (L3) and avg simultaneous N
CREATE TABLE pings (
  id             SERIAL PRIMARY KEY,
  session_id     INTEGER REFERENCES sessions(id),
  simultaneous_n FLOAT,   -- distinct source tracks across stems right now
  seg_voc        FLOAT,   -- segment length for vocals stem (bars)
  seg_mel        FLOAT,   -- segment length for melody stem (bars)
  seg_bas        FLOAT,   -- segment length for bass stem (bars)
  seg_drm        FLOAT,   -- segment length for drums stem (bars)
  seg_variance   FLOAT,   -- variance across the 4 stems (pre-computed) — L3 signal
  recorded_at    TIMESTAMP DEFAULT NOW()
);

-- Tips from listeners
CREATE TABLE tips (
  id                        SERIAL PRIMARY KEY,
  session_id                INTEGER REFERENCES sessions(id),
  amount_cents              INTEGER,
  stripe_payment_intent_id  VARCHAR(255) UNIQUE,
  tip_direction             VARCHAR(10) DEFAULT 'equal',  -- 'up' (▲), 'down' (▼), 'equal' (⬢)
  status                    VARCHAR(50) DEFAULT 'pending', -- 'pending', 'split', 'failed'
  mode                      VARCHAR(50),  -- 'web' or 'venue'
  created_at                TIMESTAMP DEFAULT NOW()
);

-- Record of each payout after split runs
CREATE TABLE payouts (
  id            SERIAL PRIMARY KEY,
  tip_id        INTEGER REFERENCES tips(id),
  user_id       INTEGER REFERENCES users(id),
  amount_cents  INTEGER,
  stripe_transfer_id VARCHAR(255),
  created_at    TIMESTAMP DEFAULT NOW()
);
