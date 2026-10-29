"""Classifica a tela atual comparando a captura com fundos de telas conhecidas.

Sem um modelo que veja imagens, a comparacao e numerica: a captura do jogo
e reduzida e comparada (distancia media) com a cor de fundo/padrao de cada
tela. Nao substitui olhar a tela, mas diz objetivamente QUAL tela esta aberta.
"""
import sys

from PIL import Image


def perfil(im):
    pequeno = im.convert('RGB').resize((32, 22))
    return list(pequeno.getdata())


def distancia(a, b):
    return sum(abs(x[0] - y[0]) + abs(x[1] - y[1]) + abs(x[2] - y[2])
               for x, y in zip(a, b)) / (len(a) * 3)


alvo = perfil(Image.open(sys.argv[1]))
for caminho in sys.argv[2:]:
    try:
        outro = perfil(Image.open(caminho))
    except Exception as exc:
        print(caminho, 'erro', exc)
        continue
    print('%.2f %s' % (distancia(alvo, outro), caminho))
