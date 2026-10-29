"""Upscale one character's spine pages with Real-ESRGAN anime 6B (CPU) and
rewrite atlas/json so the character keeps its on-screen size.
Usage: python upscale_spine.py <form_id> [factor=2]
Originals are read from jogo/build/arte_original (copied there first)."""
import json, re, shutil, sys
from pathlib import Path
import numpy as np, torch, torch.nn as nn, torch.nn.functional as F
from PIL import Image, ImageFilter
torch.backends.mkldnn.enabled = False  # oneDNN crashes (int divide by zero) on this VPS CPU

HERE = Path(__file__).resolve().parent
SPRITE = HERE.parents[1] / '01_conteudo_apk/assets/res/sprite'
ORIG = HERE.parent / 'arte_original'


class RDB(nn.Module):
    def __init__(s, nf=64, gc=32):
        super().__init__()
        s.conv1 = nn.Conv2d(nf, gc, 3, 1, 1); s.conv2 = nn.Conv2d(nf + gc, gc, 3, 1, 1)
        s.conv3 = nn.Conv2d(nf + 2 * gc, gc, 3, 1, 1); s.conv4 = nn.Conv2d(nf + 3 * gc, gc, 3, 1, 1)
        s.conv5 = nn.Conv2d(nf + 4 * gc, nf, 3, 1, 1); s.l = nn.LeakyReLU(0.2, True)
    def forward(s, x):
        x1 = s.l(s.conv1(x)); x2 = s.l(s.conv2(torch.cat((x, x1), 1)))
        x3 = s.l(s.conv3(torch.cat((x, x1, x2), 1))); x4 = s.l(s.conv4(torch.cat((x, x1, x2, x3), 1)))
        return s.conv5(torch.cat((x, x1, x2, x3, x4), 1)) * 0.2 + x


class RRDB(nn.Module):
    def __init__(s, nf=64, gc=32):
        super().__init__(); s.rdb1 = RDB(nf, gc); s.rdb2 = RDB(nf, gc); s.rdb3 = RDB(nf, gc)
    def forward(s, x): return s.rdb3(s.rdb2(s.rdb1(x))) * 0.2 + x


class RRDBNet(nn.Module):
    def __init__(s, nb=6, nf=64, gc=32):
        super().__init__()
        s.conv_first = nn.Conv2d(3, nf, 3, 1, 1)
        s.body = nn.Sequential(*[RRDB(nf, gc) for _ in range(nb)])
        s.conv_body = nn.Conv2d(nf, nf, 3, 1, 1)
        s.conv_up1 = nn.Conv2d(nf, nf, 3, 1, 1); s.conv_up2 = nn.Conv2d(nf, nf, 3, 1, 1)
        s.conv_hr = nn.Conv2d(nf, nf, 3, 1, 1); s.conv_last = nn.Conv2d(nf, 3, 3, 1, 1)
        s.l = nn.LeakyReLU(0.2, True)
    def forward(s, x):
        f = s.conv_first(x); f = f + s.conv_body(s.body(f))
        f = s.l(s.conv_up1(F.interpolate(f, scale_factor=2, mode='nearest')))
        f = s.l(s.conv_up2(F.interpolate(f, scale_factor=2, mode='nearest')))
        return s.conv_last(s.l(s.conv_hr(f)))


def load_model():
    m = RRDBNet()
    w = torch.load(HERE / 'RealESRGAN_x4plus_anime_6B.pth', map_location='cpu', weights_only=True)
    m.load_state_dict(w.get('params_ema', w), strict=True)
    m.eval(); torch.set_num_threads(max(1, torch.get_num_threads()))
    return m


@torch.no_grad()
def sr(model, rgb, tile=256, pad=10):
    """x4 super-resolution of an HxWx3 uint8 array, tiled."""
    h, w, _ = rgb.shape
    x = torch.from_numpy(rgb).permute(2, 0, 1).float().div(255).unsqueeze(0)
    out = torch.zeros(1, 3, h * 4, w * 4)
    for y0 in range(0, h, tile):
        for x0 in range(0, w, tile):
            ya, xa = max(0, y0 - pad), max(0, x0 - pad)
            yb, xb = min(h, y0 + tile + pad), min(w, x0 + tile + pad)
            o = model(x[:, :, ya:yb, xa:xb])
            oy, ox = (y0 - ya) * 4, (x0 - xa) * 4
            th, tw = min(tile, h - y0) * 4, min(tile, w - x0) * 4
            out[:, :, y0 * 4:y0 * 4 + th, x0 * 4:x0 * 4 + tw] = o[:, :, oy:oy + th, ox:ox + tw]
    return out.clamp(0, 1).mul(255).round().byte()[0].permute(1, 2, 0).numpy()


def upscale_page(model, src, dst, k):
    im = Image.open(src).convert('RGBA')
    a = np.array(im)
    alpha = a[:, :, 3]
    # Bleed colour into transparent pixels so edges do not pick up black halos.
    rgb_img = Image.fromarray(a[:, :, :3])
    mask = Image.fromarray(alpha)
    blur = rgb_img.filter(ImageFilter.GaussianBlur(3))
    rgb_img = Image.composite(rgb_img, blur, mask.point(lambda v: 255 if v > 0 else 0))
    big = Image.fromarray(sr(model, np.array(rgb_img)))
    # Alpha: Lanczos is enough (SR on alpha doubles the CPU time).
    big_a = Image.fromarray(alpha).resize((im.width * 4, im.height * 4), Image.LANCZOS)
    size = (im.width * k, im.height * k)
    out = Image.merge('RGBA', (*big.resize(size, Image.LANCZOS).split(), big_a.resize(size, Image.LANCZOS)))
    out.save(dst, optimize=True)


def main():
    form = sys.argv[1]; k = int(sys.argv[2]) if len(sys.argv) > 2 else 2
    ORIG.mkdir(exist_ok=True)
    for p in SPRITE.glob('spirte_%s*' % form):
        if not (ORIG / p.name).exists(): shutil.copy2(p, ORIG / p.name)
    model = load_model()
    lines = (ORIG / ('spirte_%s.atlas' % form)).read_text(encoding='utf-8').split('\n')
    out, scaled, inpage, dbl = [], set(), False, False
    for l in lines:
        if not l.strip(): inpage = False; out.append(l); continue
        if not inpage and l.endswith('.png'):
            inpage = True; dbl = l.startswith('spirte_%s' % form); out.append(l)
            if dbl:
                print('page', l, flush=True); upscale_page(model, ORIG / l, SPRITE / l, k)
            continue
        m = re.match(r'^(\s*)(size|xy|orig|offset): ?(-?\d+), ?(-?\d+)$', l)
        if m and dbl:
            out.append('%s%s: %d, %d' % (m.group(1), m.group(2), int(m.group(3)) * k, int(m.group(4)) * k)); continue
        if inpage and dbl and not l.startswith((' ', 'size', 'format', 'filter', 'repeat')): scaled.add(l)
        out.append(l)
    (SPRITE / ('spirte_%s.atlas' % form)).write_text('\n'.join(out), encoding='utf-8', newline='\n')
    j = json.loads((ORIG / ('spirte_%s.json' % form)).read_text(encoding='utf-8'))
    for slot in j['skins']['default'].values():
        for name, a in slot.items():
            if a.get('name', name) in scaled and a.get('type', 'region') == 'region':
                a['width'] *= k; a['height'] *= k
                a['scaleX'] = a.get('scaleX', 1.0) / k; a['scaleY'] = a.get('scaleY', 1.0) / k
    (SPRITE / ('spirte_%s.json' % form)).write_text(json.dumps(j, separators=(',', ':')), encoding='utf-8')
    print('ok', len(scaled), 'regioes')


if __name__ == '__main__':
    main()
