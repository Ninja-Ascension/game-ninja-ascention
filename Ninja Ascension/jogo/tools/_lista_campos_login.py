"""Gera a lista EXATA dos campos 1..N do parser 3 antes dos personagens.

Em vez de manter a lista a mao (que ja errou varias vezes), este script le o
parser e imprime, campo a campo, a linha de origem. A saida serve para
conferir o bloco `toks` do resposta_login_init.
"""
import re
from pathlib import Path

raiz = Path('E:/[code]/nk')
FONTE = raiz / '01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
linhas = FONTE.read_text(encoding='utf8', errors='replace').splitlines()


def codigo(n):
    return re.sub(r'--.*$', '', linhas[n - 1])


OUTROS = ('l_digital', 'l_dragonball', 'l_dragonball2', 'l_pokemon',
          'onepiece', 'adventure', 'rouge', 'yugioh', 'pokemon',
          'digimon_adventure', 'gragon_tiger_gate', 'warship_girl_b')


def condicao_roda(txt):
    nomes = re.findall(r'__lua_project_(\w+)', txt)
    if not nomes:
        return None
    return 'l_naruto' in nomes


campos = []
pilha = []
i = 240
FIM = 514
while i <= FIM:
    c = codigo(i).strip()
    if not c:
        i += 1
        continue
    if re.match(r'^if\s', c):
        txt = c
        j = i
        while 'then' not in txt and j < FIM:
            j += 1
            txt += ' ' + codigo(j).strip()
        pilha.append(condicao_roda(txt))
        i = j + 1
        continue
    if re.match(r'^else\b', c):
        if pilha:
            d = pilha[-1]
            pilha[-1] = None if d is None else (not d)
        i += 1
        continue
    if re.match(r'^end\b', c):
        if pilha:
            pilha.pop()
        i += 1
        continue
    qtd = c.count('npos(list)')
    if qtd:
        ativo = all(p for p in pilha)
        m = re.search(r'(\w+)\s*=\s*(?:tonumber\()?npos\(list\)', c)
        nome = m.group(1) if m else '<tabela>'
        if ativo:
            campos.append((len(campos) + 1, nome, i))
    i += 1

print('campos ATIVOS antes dos personagens: %d' % len(campos))
print()
for idx, nome, linha in campos:
    marca = '  <-- CONTADOR DE PERSONAGENS' if nome == 'user_ship_number' else ''
    print('%3d  %-30s (linha %4d)%s' % (idx, nome, linha, marca))
