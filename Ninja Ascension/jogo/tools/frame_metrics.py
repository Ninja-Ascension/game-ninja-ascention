# Technical pixel diagnostics for probe captures (NO visual verdicts).
# Usage: python tools/frame_metrics.py <image> [image...]
import sys
from PIL import Image
import numpy as np

def metrics(path):
    im = Image.open(path).convert('RGB')
    a = np.asarray(im, dtype=np.uint8)
    h, w, _ = a.shape
    flat = a.reshape(-1, 3)
    uniq = len(np.unique(flat, axis=0))
    mean = flat.mean(axis=0)
    # share of near-black and near-white pixels (logo screens are usually
    # high-contrast two-tone; the probe UI is gray panels on dark background)
    dark = float((flat.max(axis=1) < 32).mean())
    white = float((flat.min(axis=1) > 224).mean())
    # variance across the frame (high = photographic/art content, low = flat UI)
    std = flat.std(axis=0)
    # region split: center third vs border ring (logo often centered)
    cy0, cy1 = h // 3, 2 * h // 3
    cx0, cx1 = w // 3, 2 * w // 3
    center = a[cy0:cy1, cx0:cx1].reshape(-1, 3)
    border = np.concatenate([a[:cy0].reshape(-1, 3), a[cy1:].reshape(-1, 3)])
    print(f"{path}")
    print(f"  size={w}x{h} unique_colors={uniq}")
    print(f"  mean_rgb=({mean[0]:.0f},{mean[1]:.0f},{mean[2]:.0f}) std_rgb=({std[0]:.0f},{std[1]:.0f},{std[2]:.0f})")
    print(f"  near_black={dark:.2%} near_white={white:.2%}")
    print(f"  center_unique={len(np.unique(center, axis=0))} border_unique={len(np.unique(border, axis=0))}")
    print(f"  center_std=({center.std(axis=0)[0]:.0f},{center.std(axis=0)[1]:.0f},{center.std(axis=0)[2]:.0f}) "
          f"border_std=({border.std(axis=0)[0]:.0f},{border.std(axis=0)[1]:.0f},{border.std(axis=0)[2]:.0f})")

for p in sys.argv[1:]:
    metrics(p)
