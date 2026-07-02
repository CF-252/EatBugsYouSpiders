#!/bin/bash
# EBYS — Fine-tune Cricket on Apple Silicon (MLX + LoRA)
#
# Prerequisites (run once):
#   pip install mlx-lm
#
# Usage:
#   ./finetune.sh             — convert bakes + fine-tune
#   ./finetune.sh --convert   — convert bakes only (check output before training)
#   ./finetune.sh --train     — train only (conversion already done)

set -e
INFRA_DIR="$(cd "$(dirname "$0")" && pwd)"
EBYS_DIR="$(dirname "$INFRA_DIR")"

LOG="$INFRA_DIR/training_log.jsonl"
DATA="$INFRA_DIR/cricket_finetune.jsonl"
MODEL_OUT="$INFRA_DIR/cricket_lora"

# Base model — same family as what Ollama runs
BASE_MODEL="meta-llama/Meta-Llama-3-8B-Instruct"

# ── Check log exists ──────────────────────────────────────────────────────────
if [ ! -f "$LOG" ]; then
    echo "No training_log.jsonl found."
    echo "Play EBYS and use :bake to collect training data first."
    exit 1
fi

BAKE_COUNT=$(wc -l < "$LOG" | tr -d ' ')
echo "Found $BAKE_COUNT bakes in training_log.jsonl"

if [ "$BAKE_COUNT" -lt 50 ]; then
    echo "Warning: $BAKE_COUNT bakes is low. Aim for 200+ for meaningful fine-tuning."
    echo "Continue anyway? (y/N)"
    read -r ans
    [[ "$ans" =~ ^[Yy]$ ]] || exit 0
fi

# ── Step 1: Convert ───────────────────────────────────────────────────────────
if [ "$1" != "--train" ]; then
    echo ""
    echo "── Converting bakes to fine-tuning format ──────────────────────────"
    python3 "$INFRA_DIR/convert_bakes.py" --input "$LOG" --output "$DATA"
fi

if [ "$1" == "--convert" ]; then
    echo "Conversion done. Review $DATA before running --train."
    exit 0
fi

# ── Step 2: Fine-tune ─────────────────────────────────────────────────────────
echo ""
echo "── Fine-tuning Cricket (LoRA on $BASE_MODEL) ──────────────────────────"
echo "Output: $MODEL_OUT"
echo "This will take 1-3 hours on Apple Silicon. The fan will spin."
echo ""

mkdir -p "$MODEL_OUT"

# MLX LoRA fine-tuning
# --batch-size 1 and --grad-checkpoint keep memory under 16GB
python3 -m mlx_lm.lora \
    --model         "$BASE_MODEL" \
    --train \
    --data          "$DATA" \
    --batch-size    1 \
    --num-layers    8 \
    --iters         600 \
    --learning-rate 1e-5 \
    --grad-checkpoint \
    --adapter-path  "$MODEL_OUT"

echo ""
echo "── Done ─────────────────────────────────────────────────────────────────"
echo "Fine-tuned adapter saved to: $MODEL_OUT"
echo ""
echo "Test it:"
echo "  python3 -m mlx_lm.generate \\"
echo "    --model $BASE_MODEL \\"
echo "    --adapter-path $MODEL_OUT \\"
echo "    --prompt 'make it darker'"
echo ""
echo "To use in EBYS: run ./use_cricket_local.sh (coming soon)"
