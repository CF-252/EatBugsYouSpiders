#!/usr/bin/env python3
"""
add_stereo_features.py — per-slice pan and width from stereo audio.

WIDTH:  demuced stem's M/S ratio (rms_S / rms_M) for each slice window,
        then min-max normalized across all slices of that stem.
        Gives meaningful relative variation even when Demucs stems are near-mono.

PAN:    original stereo mix's L-R energy balance at the same time window.
        This follows the producer's stereo intent — much more meaningful than
        reading near-zero L-R from the separated stems.

Both fields are written to analysis_library.json as:
  slices::slice_NNNN::pan    float  -1..+1   (-1=left, 0=center, +1=right)
  slices::slice_NNNN::width  float   0..1    (0=mono, 1=full pseudo-stereo)

Requires: numpy (stdlib wave for I/O)

Usage:
  python3 add_stereo_features.py                 # all tracks
  python3 add_stereo_features.py "DREPTO"        # partial match
  python3 add_stereo_features.py --stems-only    # skip original mix, pan from stems
"""

import json, math, os, sys, wave, struct
import numpy as np

BASE_DIR     = os.path.dirname(os.path.abspath(__file__))
ANALYSIS_PATH = os.path.join(BASE_DIR, 'MAX', 'analysis_library.json')
STEMS_DIR    = os.path.join(BASE_DIR, 'stems', 'htdemucs')
TEMP_DIR     = os.path.join(BASE_DIR, 'temp')

# How far outside the [-1,+1] range pan values are allowed after normalization.
# 1.0 means full range; 0.6 is gentler (keeps panning subtle).
PAN_SCALE   = 0.6
# Width output range — avoids pure mono (0) and fully synthetic wide (1).
WIDTH_LO    = 0.05
WIDTH_HI    = 0.90

STEM_SUFFIXES = {
    '_vocals.wav': 'vocals',
    '_drums.wav':  'drums',
    '_bass.wav':   'bass',
    '_other.wav':  'melody',
    '_melody.wav': 'melody',
}

# ── Audio helpers ─────────────────────────────────────────────────────────────

def read_wav_stereo(path):
    """Read a stereo WAV fully into a (N,2) float32 array. Raises on mono."""
    with wave.open(path, 'rb') as w:
        ch = w.getnchannels()
        sr = w.getframerate()
        sw = w.getsampwidth()
        n  = w.getnframes()
        raw = w.readframes(n)
    if ch == 1:
        # mono: duplicate to stereo
        if sw == 2:
            s = np.frombuffer(raw, dtype='<i2').astype(np.float32) / 32768.0
        else:
            s = np.frombuffer(raw, dtype='<i4').astype(np.float32) / 2147483648.0
        y = np.stack([s, s], axis=1)
    elif ch == 2:
        if sw == 2:
            s = np.frombuffer(raw, dtype='<i2').astype(np.float32) / 32768.0
        else:
            s = np.frombuffer(raw, dtype='<i4').astype(np.float32) / 2147483648.0
        y = s.reshape(-1, 2)
    else:
        raise ValueError(f"Unsupported channel count: {ch}")
    return y, sr

def slice_window(y, sr, start_ms, end_ms, min_frames=64):
    """Return the (N,2) slice of y between start_ms and end_ms."""
    s = max(0, int(start_ms * sr / 1000))
    e = min(len(y), max(s + min_frames, int(end_ms * sr / 1000)))
    return y[s:e]

def ms_stats(chunk):
    """Return (width_raw, pan_raw) from a stereo chunk."""
    L, R = chunk[:, 0], chunk[:, 1]
    M    = (L + R) * 0.5
    S    = (L - R) * 0.5
    rms_M = math.sqrt(float(np.mean(M ** 2))) + 1e-9
    rms_S = math.sqrt(float(np.mean(S ** 2)))
    pwr_L = float(np.mean(L ** 2))
    pwr_R = float(np.mean(R ** 2))
    width_raw = rms_S / rms_M                           # 0 = mono, higher = wider
    pan_raw   = (pwr_R - pwr_L) / (pwr_R + pwr_L + 1e-9)  # -1..+1
    return width_raw, pan_raw

# ── Normalisation ─────────────────────────────────────────────────────────────

def minmax_norm(values, lo_out, hi_out):
    """Min-max normalise a list to [lo_out, hi_out]. Returns list."""
    lo = min(values)
    hi = max(values)
    span = hi - lo
    if span < 1e-9:
        return [lo_out + (hi_out - lo_out) * 0.5] * len(values)
    return [lo_out + (hi_out - lo_out) * (v - lo) / span for v in values]

# ── Core ──────────────────────────────────────────────────────────────────────

def find_mix_file(track_base):
    """Find the original mix file for a track base name, or None."""
    for ext in ('.wav', '.mp3', '.aif', '.aiff', '.flac'):
        p = os.path.join(TEMP_DIR, track_base + ext)
        if os.path.exists(p):
            return p
    return None

def process_library_key(lib_key, lib_entry, stems_only=False):
    """
    Compute pan/width for all slices in one library entry (one stem file).
    Returns True if any slices were modified.
    """
    # Decode key → track_base + stem_name
    track_base = None
    stem_name  = None
    for suf, sn in STEM_SUFFIXES.items():
        if lib_key.endswith(suf):
            track_base = lib_key[:-len(suf)]
            stem_name  = sn
            break
    if track_base is None:
        print(f'  ⚠  unrecognised key format: {lib_key!r}')
        return False

    # Library entry has one key = stem_name (vocals/drums/bass/melody)
    stem_data  = lib_entry.get(stem_name) or lib_entry.get(list(lib_entry.keys())[0] if lib_entry else '')
    if not stem_data:
        return False
    slices_dict = stem_data.get('slices', {})
    if not slices_dict:
        return False
    metadata    = stem_data.get('metadata', {})
    dur_ms      = float(metadata.get('stemDurMs', 0.0))
    if dur_ms == 0:
        print(f'  ⚠  stemDurMs missing for {track_base}/{stem_name}')
        return False

    # Locate stem WAV
    stem_file = os.path.join(STEMS_DIR, track_base, lib_key)
    if not os.path.exists(stem_file):
        print(f'  ⚠  stem file not found: {stem_file}')
        return False

    # Locate original mix (for pan)
    mix_file = None if stems_only else find_mix_file(track_base)
    if mix_file is None and not stems_only:
        # Fall back: pan from stems themselves
        mix_file = stem_file

    # Load audio
    try:
        stem_audio, stem_sr = read_wav_stereo(stem_file)
    except Exception as e:
        print(f'  ⚠  cannot read stem: {e}')
        return False

    mix_audio = stem_audio
    mix_sr    = stem_sr
    if mix_file and mix_file != stem_file:
        try:
            mix_audio, mix_sr = read_wav_stereo(mix_file)
        except Exception as e:
            print(f'  ⚠  cannot read mix ({e}) — using stem for pan')
            mix_audio, mix_sr = stem_audio, stem_sr

    # Sort slices by time
    slice_keys = sorted(slices_dict.keys())
    n_slices   = len(slice_keys)

    # Compute start/end ms for each slice
    times_frac = [float(slices_dict[k].get('time', 0.0)) for k in slice_keys]
    start_ms   = [t * dur_ms for t in times_frac]
    end_ms     = [start_ms[i+1] if i + 1 < n_slices else dur_ms
                  for i in range(n_slices)]

    # Compute raw stats per slice
    raw_widths, raw_pans = [], []
    for i, key in enumerate(slice_keys):
        s_chunk = slice_window(stem_audio, stem_sr, start_ms[i], end_ms[i])
        m_chunk = slice_window(mix_audio,  mix_sr,  start_ms[i], end_ms[i])
        w_raw, _ = ms_stats(s_chunk)   # width from stem
        _, p_raw = ms_stats(m_chunk)   # pan from mix
        raw_widths.append(w_raw)
        raw_pans.append(p_raw)

    # Normalise width across all slices of this stem
    norm_widths = minmax_norm(raw_widths, WIDTH_LO, WIDTH_HI)
    # Pan: scale without remapping so centre stays centre
    norm_pans   = [max(-1.0, min(1.0, p * PAN_SCALE / (max(abs(p) for p in raw_pans) + 1e-9)))
                   for p in raw_pans] if any(abs(p) > 1e-6 for p in raw_pans) else raw_pans

    # Write back
    for i, key in enumerate(slice_keys):
        slices_dict[key]['width'] = round(norm_widths[i], 4)
        slices_dict[key]['pan']   = round(norm_pans[i],   4)

    src = 'mix' if (mix_file and mix_file != stem_file) else 'stem'
    print(f'  {stem_name:8s}: {n_slices:4d} slices  '
          f'width [{min(norm_widths):.2f}–{max(norm_widths):.2f}]  '
          f'pan [{min(norm_pans):+.2f}–{max(norm_pans):+.2f}]  (pan from {src})')
    return True

# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    filter_name = None
    stems_only  = False
    for a in sys.argv[1:]:
        if a == '--stems-only':
            stems_only = True
        elif not a.startswith('--'):
            filter_name = a.lower()

    with open(ANALYSIS_PATH) as f:
        lib = json.load(f)

    keys = list(lib.keys())
    if filter_name:
        keys = [k for k in keys if filter_name in k.lower()]
        print(f'Filtering to {len(keys)} key(s) matching "{filter_name}"')

    # Group by track_base for cleaner output
    from collections import OrderedDict
    groups = OrderedDict()
    for k in keys:
        base = k
        for suf in STEM_SUFFIXES:
            if k.endswith(suf):
                base = k[:-len(suf)]; break
        groups.setdefault(base, []).append(k)

    changed = 0
    for base, lib_keys in groups.items():
        print(f'\n{base[:50]}')
        for lk in lib_keys:
            if process_library_key(lk, lib[lk], stems_only=stems_only):
                changed += 1

    if changed == 0:
        print('\nNothing processed.')
        return

    print(f'\nSaving {changed} modified entries to analysis_library.json…')
    with open(ANALYSIS_PATH, 'w') as f:
        json.dump(lib, f)
    print('Done.')

if __name__ == '__main__':
    main()
