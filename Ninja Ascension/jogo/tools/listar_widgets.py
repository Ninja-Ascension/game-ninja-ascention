"""Lista widgets de um layout Cocos 2.1 (JSON convertido) com posicao e tamanho."""
import json
import sys
from pathlib import Path

arq = Path(sys.argv[1])
alvo = (sys.argv[2] if len(sys.argv) > 2 else None)
dados = json.loads(arq.read_text(encoding='utf8'))


def opt(no):
    return (no.get('options') or {}).get('data') or {}


def andar(no, prof=0):
    d = opt(no)
    nome = d.get('name', '?')
    tipo = no.get('classname', '?')
    pos = d.get('position') or {}
    tam = d.get('size') or {}
    vis = d.get('visible')
    vis = (vis or {}).get('value', True) if isinstance(vis, dict) else vis
    linha = '%s%s [%s] pos=(%s,%s) tam=(%s,%s) vis=%s' % (
        '  ' * prof, nome, tipo, pos.get('x'), pos.get('y'),
        tam.get('x'), tam.get('y'), vis)
    if alvo is None or alvo.lower() in str(nome).lower():
        print(linha)
    for filho in no.get('children', []) or []:
        andar(filho, prof + 1)


andar(dados.get('nodeTree') or dados)
