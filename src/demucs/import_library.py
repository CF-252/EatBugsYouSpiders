#!/usr/bin/env python3
"""
import_library.py — Import EBYS JSON files into SQLite (ebys.db).

Reads:
  MAX/analysis_library.json   — FluCoMa slices per stem per track
  genres.json                 — Essentia genre tags per track
  downbeats.json              — madmom downbeat/BPM data per track

Writes:
  ebys.db                     — canonical queryable store for PD migration

This script is ADDITIVE and IDEMPOTENT — safe to run multiple times.
It uses INSERT OR REPLACE / ON CONFLICT DO UPDATE so existing rows are
updated, not duplicated.

Usage:
  python3 import_library.py              # full import
  python3 import_library.py --track "My Track"   # one track only (partial match)
  python3 import_library.py --status    # print DB counts and exit
"""

import json, sqlite3, math, os, sys, argparse
from collections import defaultdict

# Relative to this file: src/demucs/ → src/ → EBYS/ (repo root)
_src_dir  = os.path.dirname(os.path.abspath(__file__))
_root_dir = os.path.dirname(os.path.dirname(_src_dir))
_data_dir = os.path.join(_root_dir, 'data')

DB_PATH        = os.path.join(_data_dir, 'ebys.db')
LIB_PATH       = os.path.join(_root_dir, 'src', 'max', 'analysis_library.json')
GENRES_PATH    = os.path.join(_data_dir, 'genres.json')
DOWNBEATS_PATH = os.path.join(_data_dir, 'downbeats.json')

STEM_SUFFIXES = [
    '_vocals.wav', '_melody.wav', '_bass.wav', '_drums.wav', '_other.wav',
    '_vocals',     '_melody',     '_bass',     '_drums',     '_other',
]

CANONICAL_STEMS = {'vocals', 'melody', 'bass', 'drums'}

# analysis_library.json uses these inner keys for stems
STEM_INNER_MAP = {
    'vocals': 'vocals',
    'melody': 'melody',
    'bass':   'bass',
    'drums':  'drums',
}


def strip_suffix(name):
    for s in STEM_SUFFIXES:
        if name.endswith(s):
            return name[: -len(s)]
    return name


def slice_T(s):
    """Timbre scalar = RMS of MFCC coefficients M0–M5."""
    vals = [float(s.get(f'M{i}', 0) or 0) for i in range(6)]
    return math.sqrt(sum(v * v for v in vals) / max(len(vals), 1))


# ── Schema ────────────────────────────────────────────────────────────────────

def create_schema(conn):
    conn.executescript("""
        PRAGMA journal_mode = WAL;
        PRAGMA foreign_keys = ON;

        CREATE TABLE IF NOT EXISTS tracks (
            id             INTEGER PRIMARY KEY,
            name           TEXT    UNIQUE NOT NULL,
            bpm            REAL    DEFAULT 0,
            bpm_confidence REAL    DEFAULT 0,
            key            TEXT    DEFAULT '',
            meter          INTEGER DEFAULT 4,
            stem_dur_ms    REAL    DEFAULT 0
        );

        CREATE TABLE IF NOT EXISTS slices (
            id          INTEGER PRIMARY KEY,
            track_id    INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
            stem        TEXT    NOT NULL CHECK(stem IN ('vocals','melody','bass','drums')),
            slice_key   TEXT    NOT NULL,
            time_frac   REAL    DEFAULT 0,
            C   REAL DEFAULT 0,
            S   REAL DEFAULT 0,
            E   REAL DEFAULT 0,
            F   REAL DEFAULT 0,
            P   REAL DEFAULT 0,
            H   REAL DEFAULT 0,
            T   REAL DEFAULT 0,
            M0  REAL DEFAULT 0,
            M1  REAL DEFAULT 0,
            M2  REAL DEFAULT 0,
            M3  REAL DEFAULT 0,
            M4  REAL DEFAULT 0,
            M5  REAL DEFAULT 0,
            tension_C REAL,
            tension_E REAL,
            tension_F REAL,
            tension_P REAL,
            tension_H REAL,
            tension_T REAL,
            UNIQUE(track_id, stem, slice_key)
        );

        CREATE TABLE IF NOT EXISTS genres (
            track_id   INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
            rank       INTEGER NOT NULL,
            genre      TEXT    NOT NULL,
            confidence REAL    DEFAULT 0,
            PRIMARY KEY (track_id, rank)
        );

        CREATE TABLE IF NOT EXISTS downbeats (
            track_id     INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
            bar_num      INTEGER NOT NULL,
            timestamp_ms REAL    NOT NULL,
            PRIMARY KEY (track_id, bar_num)
        );

        CREATE INDEX IF NOT EXISTS idx_slices_stem       ON slices(stem);
        CREATE INDEX IF NOT EXISTS idx_slices_track_id   ON slices(track_id);
        CREATE INDEX IF NOT EXISTS idx_slices_track_stem ON slices(track_id, stem);
    """)
    conn.commit()


# ── Upsert helpers ─────────────────────────────────────────────────────────────

def upsert_track(conn, name, bpm=0, bpm_conf=0, key='', meter=4, stem_dur_ms=0):
    conn.execute("""
        INSERT INTO tracks (name, bpm, bpm_confidence, key, meter, stem_dur_ms)
        VALUES (?, ?, ?, ?, ?, ?)
        ON CONFLICT(name) DO UPDATE SET
            bpm            = excluded.bpm,
            bpm_confidence = excluded.bpm_confidence,
            key            = excluded.key,
            meter          = excluded.meter,
            stem_dur_ms    = excluded.stem_dur_ms
    """, (name, bpm, bpm_conf, key, meter, stem_dur_ms))
    return conn.execute("SELECT id FROM tracks WHERE name = ?", (name,)).fetchone()[0]


def get_or_create_track(conn, name):
    row = conn.execute("SELECT id FROM tracks WHERE name = ?", (name,)).fetchone()
    if row:
        return row[0]
    conn.execute("INSERT INTO tracks (name) VALUES (?)", (name,))
    conn.commit()
    return conn.execute("SELECT id FROM tracks WHERE name = ?", (name,)).fetchone()[0]


# ── Analysis library import ───────────────────────────────────────────────────

def import_library(conn, lib, filter_track=None):
    """
    lib : parsed analysis_library.json
    Keys are like "MyTrack_vocals.wav", values are {vocals: {metadata, slices}, ...}
    """
    # Group file entries by base track name
    groups = defaultdict(dict)  # base_name → {stem: stem_data}
    for file_key, file_data in lib.items():
        base = strip_suffix(file_key)
        if filter_track and filter_track.lower() not in base.lower():
            continue
        for inner_stem, stem_data in file_data.items():
            canonical = STEM_INNER_MAP.get(inner_stem)
            if canonical is None:
                continue
            groups[base][canonical] = stem_data

    total_slices = 0
    for base_name, stems in groups.items():
        # Pick BPM/key from first stem that has them
        bpm = 0; bpm_conf = 0; key = ''; stem_dur = 0; meter = 4
        for stem_name in ('vocals', 'melody', 'bass', 'drums'):
            if stem_name not in stems:
                continue
            meta = stems[stem_name].get('metadata', {})
            b = float(meta.get('BPM', 0) or 0)
            if b > 0:
                bpm      = b
                bpm_conf = float(meta.get('BPM_confidence', 0) or 0)
                key      = str(meta.get('key', '') or '')
                stem_dur = float(meta.get('stemDurMs', 0) or 0)
                break

        track_id = upsert_track(conn, base_name, bpm, bpm_conf, key, meter, stem_dur)

        for stem_name, stem_data in stems.items():
            slices_dict = stem_data.get('slices', {})
            rows = []
            for slice_key, s in slices_dict.items():
                T = slice_T(s)
                rows.append((
                    track_id, stem_name, slice_key,
                    float(s.get('time', 0) or 0),
                    float(s.get('C', 0) or 0),
                    float(s.get('S', 0) or 0),
                    float(s.get('E', 0) or -60),
                    float(s.get('F', 0) or 0),
                    float(s.get('P', 0) or 0),
                    float(s.get('H', 0) or 0),
                    T,
                    float(s.get('M0', 0) or 0),
                    float(s.get('M1', 0) or 0),
                    float(s.get('M2', 0) or 0),
                    float(s.get('M3', 0) or 0),
                    float(s.get('M4', 0) or 0),
                    float(s.get('M5', 0) or 0),
                    s.get('tension_C'),
                    s.get('tension_E'),
                    s.get('tension_F'),
                    s.get('tension_P'),
                    s.get('tension_H'),
                    s.get('tension_T'),
                ))
            conn.executemany("""
                INSERT INTO slices
                    (track_id, stem, slice_key, time_frac,
                     C, S, E, F, P, H, T, M0, M1, M2, M3, M4, M5,
                     tension_C, tension_E, tension_F, tension_P, tension_H, tension_T)
                VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
                ON CONFLICT(track_id, stem, slice_key) DO UPDATE SET
                    time_frac  = excluded.time_frac,
                    C=excluded.C, S=excluded.S, E=excluded.E, F=excluded.F,
                    P=excluded.P, H=excluded.H, T=excluded.T,
                    M0=excluded.M0, M1=excluded.M1, M2=excluded.M2,
                    M3=excluded.M3, M4=excluded.M4, M5=excluded.M5,
                    tension_C = COALESCE(excluded.tension_C, tension_C),
                    tension_E = COALESCE(excluded.tension_E, tension_E),
                    tension_F = COALESCE(excluded.tension_F, tension_F),
                    tension_P = COALESCE(excluded.tension_P, tension_P),
                    tension_H = COALESCE(excluded.tension_H, tension_H),
                    tension_T = COALESCE(excluded.tension_T, tension_T)
            """, rows)
            total_slices += len(rows)

        n = sum(len(s.get('slices', {})) for s in stems.values())
        print(f'  {base_name}: {n} slices across {len(stems)} stem(s)')

    conn.commit()
    return total_slices


# ── Genres import ─────────────────────────────────────────────────────────────

def import_genres(conn, genres_db):
    for track_name, data in genres_db.items():
        track_id = get_or_create_track(conn, track_name)
        conn.execute("DELETE FROM genres WHERE track_id = ?", (track_id,))
        genre_list = data.get('genres', [])
        for rank, g in enumerate(genre_list[:10]):
            genre_str = g.get('genre', '') if isinstance(g, dict) else str(g)
            confidence = float(g.get('confidence', 0)) if isinstance(g, dict) else 0.0
            conn.execute(
                "INSERT INTO genres (track_id, rank, genre, confidence) VALUES (?,?,?,?)",
                (track_id, rank, genre_str, confidence),
            )
    conn.commit()


# ── Downbeats import ──────────────────────────────────────────────────────────

def import_downbeats(conn, beats_db):
    for track_name, data in beats_db.items():
        track_id = get_or_create_track(conn, track_name)
        conn.execute("DELETE FROM downbeats WHERE track_id = ?", (track_id,))
        for bar_num, ts in enumerate(data.get('downbeats_ms', [])):
            conn.execute(
                "INSERT INTO downbeats (track_id, bar_num, timestamp_ms) VALUES (?,?,?)",
                (track_id, bar_num, float(ts)),
            )
        # Update BPM/meter on the track from downbeats data if not already set
        bpm   = float(data.get('bpm', 0) or 0)
        meter = int(data.get('meter', 4) or 4)
        if bpm > 0:
            conn.execute(
                "UPDATE tracks SET bpm = ?, meter = ? WHERE id = ? AND bpm = 0",
                (bpm, meter, track_id),
            )
    conn.commit()


# ── Tension sync (called from add_tension.py) ─────────────────────────────────

def sync_tension(conn, lib):
    """
    Update only the tension_* columns in an existing DB from a freshly
    computed analysis_library dict (after add_tension.py has run).
    Fast: targeted UPDATE per slice, no INSERT/DELETE.
    """
    updated = 0
    for file_key, file_data in lib.items():
        base = strip_suffix(file_key)
        row  = conn.execute("SELECT id FROM tracks WHERE name = ?", (base,)).fetchone()
        if not row:
            continue
        track_id = row[0]
        for inner_stem, stem_data in file_data.items():
            canonical = STEM_INNER_MAP.get(inner_stem)
            if canonical is None:
                continue
            for slice_key, s in stem_data.get('slices', {}).items():
                tc = s.get('tension_C')
                te = s.get('tension_E')
                tf = s.get('tension_F')
                tp = s.get('tension_P')
                th = s.get('tension_H')
                tt = s.get('tension_T')
                if tc is None:
                    continue
                conn.execute("""
                    UPDATE slices SET
                        tension_C=?, tension_E=?, tension_F=?,
                        tension_P=?, tension_H=?, tension_T=?
                    WHERE track_id=? AND stem=? AND slice_key=?
                """, (tc, te, tf, tp, th, tt, track_id, canonical, slice_key))
                updated += 1
    conn.commit()
    return updated


# ── Main ──────────────────────────────────────────────────────────────────────

def open_db():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA journal_mode = WAL")
    conn.execute("PRAGMA foreign_keys = ON")
    create_schema(conn)
    return conn


def main():
    parser = argparse.ArgumentParser(description='Import EBYS JSON files into SQLite')
    parser.add_argument('--track',  help='Import only this track (partial name match)')
    parser.add_argument('--status', action='store_true', help='Print DB counts and exit')
    args = parser.parse_args()

    conn = open_db()

    if args.status:
        n_tracks  = conn.execute("SELECT COUNT(*) FROM tracks").fetchone()[0]
        n_slices  = conn.execute("SELECT COUNT(*) FROM slices").fetchone()[0]
        n_genres  = conn.execute("SELECT COUNT(DISTINCT track_id) FROM genres").fetchone()[0]
        n_beats   = conn.execute("SELECT COUNT(DISTINCT track_id) FROM downbeats").fetchone()[0]
        print(f'ebys.db — {n_tracks} tracks  {n_slices} slices  '
              f'{n_genres} with genres  {n_beats} with downbeats')
        conn.close()
        return

    # 1. Analysis library → slices table
    if os.path.exists(LIB_PATH):
        print('Importing analysis library...')
        with open(LIB_PATH) as f:
            lib = json.load(f)
        n = import_library(conn, lib, filter_track=args.track)
        print(f'  → {n} slice rows upserted')
    else:
        print(f'WARNING: {LIB_PATH} not found — skipping slices')

    # 2. Genres (always full refresh unless --track filter)
    if os.path.exists(GENRES_PATH) and not args.track:
        print('Importing genres...')
        with open(GENRES_PATH) as f:
            genres_db = json.load(f)
        import_genres(conn, genres_db)
        print(f'  → {len(genres_db)} track(s) genre data imported')

    # 3. Downbeats (always full refresh unless --track filter)
    if os.path.exists(DOWNBEATS_PATH) and not args.track:
        print('Importing downbeats...')
        with open(DOWNBEATS_PATH) as f:
            beats_db = json.load(f)
        import_downbeats(conn, beats_db)
        print(f'  → {len(beats_db)} track(s) downbeat data imported')

    # Summary
    n_tracks = conn.execute("SELECT COUNT(*) FROM tracks").fetchone()[0]
    n_slices = conn.execute("SELECT COUNT(*) FROM slices").fetchone()[0]
    print(f'\nebys.db: {n_tracks} tracks  {n_slices} total slices')

    conn.close()


if __name__ == '__main__':
    main()
