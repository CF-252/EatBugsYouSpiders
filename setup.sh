#!/usr/bin/env bash
# =============================================================================
# EBYS — First-Time Setup
# Run once after cloning: bash setup.sh
# =============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMUCS_SRC="$REPO_DIR/src/demucs"
DATA_DIR="$REPO_DIR/data"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║       EBYS — First-Time Setup        ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Repo: $REPO_DIR"
echo ""

# ── 1. Runtime directories ────────────────────────────────────────────────────
echo "▸ Creating runtime directories..."
mkdir -p \
  "$DATA_DIR/stems" \
  "$DATA_DIR/raw_uploads" \
  "$DATA_DIR/temp" \
  "$DATA_DIR/logs" \
  "$DATA_DIR/recordings"
echo "  ✓ data/ directories ready"

# ── 2. Python virtual environment (Demucs) ───────────────────────────────────
VENV="$DEMUCS_SRC/demucs_env"
if [ -d "$VENV" ]; then
  echo "▸ demucs_env already exists — skipping"
else
  echo "▸ Creating demucs_env (Python 3.x)..."
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install --upgrade pip --quiet
  "$VENV/bin/pip" install demucs watchdog --quiet
  echo "  ✓ demucs_env created"
fi

# ── 3. Essentia models ────────────────────────────────────────────────────────
MODELS_DIR="$DEMUCS_SRC/essentia_models"
if [ -d "$MODELS_DIR" ] && [ "$(ls -A "$MODELS_DIR" 2>/dev/null)" ]; then
  echo "▸ essentia_models already present — skipping"
else
  echo "▸ Downloading Essentia genre models (~120 MB)..."
  mkdir -p "$MODELS_DIR"
  curl -L -o "$MODELS_DIR/discogs-effnet-bs64-1.pb" \
    "https://essentia.upf.edu/models/feature-extractors/discogs-effnet/discogs-effnet-bs64-1.pb"
  curl -L -o "$MODELS_DIR/genre_discogs400-discogs-effnet-1.pb" \
    "https://essentia.upf.edu/models/classification-heads/genre_discogs400/genre_discogs400-discogs-effnet-1.pb"
  curl -L -o "$MODELS_DIR/genre_discogs400_labels.json" \
    "https://essentia.upf.edu/models/classification-heads/genre_discogs400/genre_discogs400-discogs-effnet-1.json"
  echo "  ✓ models downloaded"
fi

# ── 4. Node dependencies ──────────────────────────────────────────────────────
echo "▸ Installing Node dependencies..."
if [ -f "$REPO_DIR/src/max/package.json" ]; then
  (cd "$REPO_DIR/src/max" && npm install --silent)
  echo "  ✓ src/max"
fi
if [ -f "$REPO_DIR/src/tui/package.json" ]; then
  (cd "$REPO_DIR/src/tui" && npm install --silent)
  echo "  ✓ src/tui"
fi
if [ -f "$REPO_DIR/src/backend/package.json" ]; then
  (cd "$REPO_DIR/src/backend" && npm install --silent)
  echo "  ✓ src/backend"
fi

# ── 5. LaunchAgent (watch_demucs daemon) ────────────────────────────────────
LAUNCH_AGENTS="$HOME/Library/LaunchAgents"
PLIST_DEST="$LAUNCH_AGENTS/com.ebys.watchdemucs.plist"
DEMUCS_PY="$DEMUCS_SRC/demucs_env/bin/python3"
SCRIPT="$DEMUCS_SRC/watch_demucs.py"
LOG="$DATA_DIR/logs/watchdemucs.log"

mkdir -p "$LAUNCH_AGENTS"

echo "▸ Generating LaunchAgent plist..."
cat > "$PLIST_DEST" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ebys.watchdemucs</string>

    <key>ProgramArguments</key>
    <array>
        <string>$DEMUCS_PY</string>
        <string>$SCRIPT</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>$LOG</string>

    <key>StandardErrorPath</key>
    <string>$LOG</string>

    <key>WorkingDirectory</key>
    <string>$DEMUCS_SRC</string>
</dict>
</plist>
PLIST

echo "  ✓ plist written to $PLIST_DEST"

# Unload existing (ignore error if not loaded)
launchctl unload "$PLIST_DEST" 2>/dev/null || true

# Load the new one
launchctl load "$PLIST_DEST"
echo "  ✓ LaunchAgent loaded (daemon will auto-start on login)"

# ── 6. Backend .env reminder ──────────────────────────────────────────────────
if [ ! -f "$REPO_DIR/src/backend/.env" ]; then
  echo ""
  echo "⚠  No .env found in src/backend/"
  echo "   Copy .env.example and fill in your credentials:"
  echo "   cp src/backend/.env.example src/backend/.env"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════╗"
echo "║           Setup complete ✓           ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Open src/max/ebys-analyze.maxpat in Max 8"
echo "  2. Drop an audio file into data/raw_uploads/"
echo "  3. Watch the TUI:  node src/tui/sdj-tui.js"
echo ""
