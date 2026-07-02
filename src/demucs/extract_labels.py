#!/usr/bin/env python3
"""
EBYS — Extract genre labels from the Discogs-EffNet model metadata.

The genre_discogs400 .pb file stores the class names in its SignatureDef.
This script reads them out and writes genre_discogs400_labels.json.

Usage (with ebys-env active):
  python3 extract_labels.py
  python3 extract_labels.py --models /path/to/essentia_models
"""

import os
import sys
import json
import argparse

def extract_from_tf(pb_path):
    """Try to read class names from the TensorFlow graph SignatureDef."""
    try:
        import tensorflow as tf
        print("Trying TensorFlow SignatureDef...", file=sys.stderr)
        with tf.io.gfile.GFile(pb_path, 'rb') as f:
            gd = tf.compat.v1.GraphDef()
            gd.ParseFromString(f.read())
        # Look for any string tensors that look like label lists
        for node in gd.node:
            if node.op == 'Const' and 'dtype' in node.attr:
                dtype = node.attr['dtype'].type
                if dtype == 7:  # DT_STRING
                    vals = node.attr['value'].tensor.string_val
                    if len(vals) >= 100:
                        labels = [v.decode('utf-8') for v in vals]
                        print(f"Found {len(labels)} string values in node '{node.name}'", file=sys.stderr)
                        return labels
        return None
    except Exception as e:
        print(f"TF extract failed: {e}", file=sys.stderr)
        return None


def try_download(out_path):
    """Try known GitHub URLs for the labels file."""
    import urllib.request
    urls = [
        "https://raw.githubusercontent.com/MTG/essentia/master/src/examples/tensorflow/music_tagging/genre_discogs400-discogs-effnet-1-labels.json",
        "https://raw.githubusercontent.com/MTG/essentia/master/src/examples/tensorflow/classification/genre_discogs400-discogs-effnet-1-labels.json",
        "https://raw.githubusercontent.com/MTG/essentia/master/src/examples/tutorial/genre_discogs400-discogs-effnet-1-labels.json",
    ]
    for url in urls:
        try:
            print(f"Trying {url}", file=sys.stderr)
            with urllib.request.urlopen(url, timeout=10) as r:
                raw = r.read().decode('utf-8')
            if len(raw) > 500 and '[' in raw:
                labels = json.loads(raw)
                if len(labels) >= 100:
                    with open(out_path, 'w') as f:
                        json.dump(labels, f, indent=2)
                    print(f"Downloaded {len(labels)} labels → {out_path}", file=sys.stderr)
                    return labels
        except Exception as e:
            print(f"  failed: {e}", file=sys.stderr)
    return None


def infer_from_predictions(pb_embed, pb_genre, out_path):
    """
    Run the model on 5 seconds of silence and use the output shape
    to confirm the number of classes (can't recover names this way).
    """
    try:
        import numpy as np
        import essentia.standard as es
        audio = np.zeros(16000 * 5, dtype='float32')
        embedder  = es.TensorflowPredictEffnetDiscogs(graphFilename=pb_embed, output='PartitionedCall:1')
        predictor = es.TensorflowPredict2D(graphFilename=pb_genre,
                                           input='serving_default_model_Placeholder:0',
                                           output='PartitionedCall:0')
        emb  = embedder(audio)
        pred = predictor(emb)
        n_classes = pred.shape[-1]
        print(f"Model output shape: {pred.shape} → {n_classes} classes", file=sys.stderr)
        return n_classes
    except Exception as e:
        print(f"Inference probe failed: {e}", file=sys.stderr)
        return 400  # fallback assumption


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--models', default=os.path.join(os.path.dirname(os.path.abspath(__file__)), 'essentia_models'))
    args = ap.parse_args()

    pb_embed = os.path.join(args.models, 'discogs-effnet-bs64-1.pb')
    pb_genre = os.path.join(args.models, 'genre_discogs400-discogs-effnet-1.pb')
    out_path = os.path.join(args.models, 'genre_discogs400_labels.json')

    # Step 1 — try downloading from GitHub
    labels = try_download(out_path)
    if labels:
        print(f"Success — {len(labels)} labels saved.", file=sys.stderr)
        return

    # Step 2 — try extracting from TF graph
    if os.path.exists(pb_genre):
        labels = extract_from_tf(pb_genre)
        if labels:
            with open(out_path, 'w') as f:
                json.dump(labels, f, indent=2)
            print(f"Extracted {len(labels)} labels from graph → {out_path}")
            return

    # Step 3 — confirm class count and explain
    n = infer_from_predictions(pb_embed, pb_genre, out_path) if os.path.exists(pb_embed) else 400
    print(f"\nCould not retrieve human-readable labels automatically.", file=sys.stderr)
    print(f"The model has {n} output classes.", file=sys.stderr)
    print(f"\nManual option — open this URL in your browser and save the content as:", file=sys.stderr)
    print(f"  {out_path}", file=sys.stderr)
    print(f"\n  https://essentia.upf.edu/models/classification-heads/genre_discogs400/", file=sys.stderr)
    print(f"\nOr use numeric labels for now (genre_tagger.py handles this gracefully).", file=sys.stderr)


if __name__ == '__main__':
    main()
