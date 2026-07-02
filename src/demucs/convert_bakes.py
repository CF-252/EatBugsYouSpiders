#!/usr/bin/env python3
"""
EBYS — Bake Converter  v1

Converts training_log.jsonl (raw :bake snapshots) into cricket_finetune.jsonl
(MLX / Llama fine-tuning format).

Each bake becomes one training example:
  - system:    Cricket's system prompt (from CRICKET.md)
  - user:      intent + live descriptor state at bake time
  - assistant: final_cmds (Cricket's attempt + user corrections combined)

Usage:
  python3 convert_bakes.py
  python3 convert_bakes.py --input training_log.jsonl --output cricket_finetune.jsonl
  python3 convert_bakes.py --stats       # just print stats, don't write
"""

import json
import argparse
import os
import sys
from pathlib import Path

# ── Paths ─────────────────────────────────────────────────────────────────────
INFRA_DIR   = Path(__file__).parent
EBYS_DIR    = INFRA_DIR.parent
LOG_PATH    = INFRA_DIR / 'training_log.jsonl'
OUTPUT_PATH = INFRA_DIR / 'cricket_finetune.jsonl'
CRICKET_MD  = EBYS_DIR  / 'CRICKET.md'

# ── System prompt ─────────────────────────────────────────────────────────────
def load_system_prompt():
    if CRICKET_MD.exists():
        return CRICKET_MD.read_text().strip()
    return "You are Cricket, the control interface for EBYS."

# ── State formatter ───────────────────────────────────────────────────────────
def format_stems(stems):
    """Format live descriptor state into a readable context string."""
    if not stems:
        return "(no state)"
    lines = []
    for stem_name, stem in stems.items():
        parts = []
        for key in ['C', 'E', 'F', 'P', 'H', 'T']:
            v = stem.get(key)
            if v is not None:
                parts.append(f"{key}={v:.1f}" if isinstance(v, float) else f"{key}={v}")
        genre = stem.get('track', '')
        if genre:
            parts.append(f"track={genre}")
        if parts:
            lines.append(f"  {stem_name}: {', '.join(parts)}")
    return '\n'.join(lines) if lines else "(no state)"

# ── Conversion ────────────────────────────────────────────────────────────────
def convert(log_path, output_path, stats_only=False):
    system_prompt = load_system_prompt()

    snapshots = []
    with open(log_path) as f:
        for i, line in enumerate(f):
            line = line.strip()
            if not line:
                continue
            try:
                snapshots.append(json.loads(line))
            except json.JSONDecodeError as e:
                print(f"  skip line {i+1}: {e}", file=sys.stderr)

    print(f"Loaded {len(snapshots)} snapshots from {log_path}")

    skipped  = 0
    examples = []

    for s in snapshots:
        intent     = (s.get('intent') or '').strip()
        final_cmds = s.get('final_cmds') or []
        corrections = s.get('user_corrections') or []

        # Skip bakes with no intent or no commands
        if not intent:
            skipped += 1
            continue
        if not final_cmds:
            skipped += 1
            continue

        # Build the user message: intent + descriptor state
        state_str  = format_stems(s.get('stems') or {})
        track      = s.get('track', '')
        bpm        = s.get('bpm', 0)

        user_parts = [intent]
        context_parts = []
        if track:
            context_parts.append(f"track: {track}")
        if bpm:
            context_parts.append(f"bpm: {bpm}")
        if state_str and state_str != "(no state)":
            context_parts.append(f"stems:\n{state_str}")
        if context_parts:
            user_parts.append('\n[state]\n' + '\n'.join(context_parts))

        user_msg      = '\n'.join(user_parts)
        assistant_msg = '\n'.join(final_cmds)

        examples.append({
            "messages": [
                {"role": "system",    "content": system_prompt},
                {"role": "user",      "content": user_msg},
                {"role": "assistant", "content": assistant_msg},
            ]
        })

    print(f"Converted: {len(examples)}  skipped: {skipped}")

    # Print a few examples for inspection
    print("\n── Sample (first 2 examples) ──────────────────────────────────")
    for ex in examples[:2]:
        print(f"\nINTENT:  {ex['messages'][1]['content'][:120]}")
        print(f"TARGET:  {ex['messages'][2]['content']}")
        print(f"CORRECTIONS in this bake: {len([s for s in snapshots if s.get('user_corrections')])} total bakes had corrections")

    if stats_only:
        intents_with_corrections = sum(1 for s in snapshots if s.get('user_corrections'))
        print(f"\n── Stats ───────────────────────────────────────────────────────")
        print(f"  Total bakes:             {len(snapshots)}")
        print(f"  Usable examples:         {len(examples)}")
        print(f"  Bakes with corrections:  {intents_with_corrections}")
        print(f"  Bakes without:           {len(snapshots) - intents_with_corrections}")
        return

    with open(output_path, 'w') as f:
        for ex in examples:
            f.write(json.dumps(ex) + '\n')

    print(f"\nWritten to {output_path}")
    print(f"Ready for: mlx_lm.lora --train --data {output_path}")

# ── CLI ───────────────────────────────────────────────────────────────────────
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Convert EBYS bake log to fine-tuning format')
    parser.add_argument('--input',  default=str(LOG_PATH),    help='Path to training_log.jsonl')
    parser.add_argument('--output', default=str(OUTPUT_PATH), help='Path to output JSONL')
    parser.add_argument('--stats',  action='store_true',      help='Print stats only, no output file')
    args = parser.parse_args()

    if not os.path.exists(args.input):
        print(f"No training log found at {args.input}")
        print("Play EBYS and use :bake to collect training data first.")
        sys.exit(1)

    convert(args.input, args.output, stats_only=args.stats)
