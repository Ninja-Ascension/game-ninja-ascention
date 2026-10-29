"""Extrai a lista ordenada dos campos que o parser de user_ship consome.

Le ProtocolParserCopy.lua na faixa do parser de user_ship e devolve, campo a
campo, a linha de origem e a expressao. Serve de fonte unica para montar o
bloco de tokens: a ordem do arquivo E a ordem do protocolo.

Saida: tools/_campos_usership.txt (nome sugerido + linha), para conferencia.
"""
import re
from pathlib import Path

raiz = Path('E:/[code]/nk')
PARQUER = raiz / '01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
INICIO, FIM = 517, 1236

linhas = PARQUER.read_text(encoding='utf8', errors='replace').splitlines()

campos = []
for n in range(INICIO, FIM + 1):
    linha = linhas[n - 1]
    codigo = re.sub(r'--.*$', '', linha)
    for m in re.finditer(r'(\w+)\s*=\s*npos\(list\)', codigo):
        campos.append((len(campos) + 1, m.group(1), n))
    for m in re.finditer(r'npos\(list\)', codigo):
        if not re.search(r'\w+\s*=\s*npos\(list\)', codigo[:m.end()]):
            campos.append((len(campos) + 1, '<sem-nome>', n))

print('total de campos: %d' % len(campos))
alvo = raiz / 'tools/_campos_usership.txt'
with alvo.open('w', encoding='utf8') as f:
    for idx, nome, linha in campos:
        f.write('%3d\t%s\tlinha %d\n' % (idx, nome, linha))
print('lista escrita em', alvo)

# Mostra os primeiros e os que tem nome de contador (lacos).
print('\nprimeiros 25:')
for idx, nome, linha in campos[:25]:
    print('  %3d  %-34s (linha %d)' % (idx, nome, linha))

lacos = [c for c in campos if 'count' in c[1].lower() or 'number' in c[1].lower()]
print('\ncampos que sao contadores (controlam lacos): %d' % len(lacos))
for idx, nome, linha in lacos:
    print('  %3d  %-34s (linha %d)' % (idx, nome, linha))
