"""Resume uma captura: dimensoes, cores dominantes e brilho medio."""
import sys
from collections import Counter

from PIL import Image

for caminho in sys.argv[1:]:
    im = Image.open(caminho).convert('RGB')
    pequeno = im.resize((80, 54))
    cores = Counter(pequeno.getdata())
    brilho = sum(sum(c) for c in pequeno.getdata()) / (80 * 54 * 3)
    print(caminho)
    print('  tamanho', im.size, 'brilho_medio=%.1f' % brilho,
          'cores_distintas=%d' % len(cores))
    for cor, qtd in cores.most_common(5):
        print('   ', cor, qtd)
