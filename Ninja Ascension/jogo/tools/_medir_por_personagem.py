"""Mede quantos tokens o parser 3 consome POR PERSONAGEM, exatamente.

Diferente da contagem ingenua (que soma todos os ramos), aqui seguimos o
caminho do projeto Naruto:

  * ramos `if` que citam __lua_project_l_naruto -> rodam
  * ramos que citam OUTROS projetos -> nao rodam
  * campos comentados (--) -> nao contam
  * lacos controlados por contador: contam 1 token de cabecalho + N * tamanho

Imprime o total e a decomposicao, para comparar com one_ship_tokens.
"""
import re
from pathlib import Path

raiz = Path('E:/[code]/nk')
FONTE = raiz / '01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
linhas = FONTE.read_text(encoding='utf8', errors='replace').splitlines()

INICIO, FIM = 517, 1236          # laco de personagens


def codigo(n):
    return re.sub(r'--.*$', '', linhas[n - 1])


# Constantes de OUTROS projetos: se a condicao so cita estes, nao roda.
OUTROS = (
    'l_digital', 'l_dragonball', 'l_dragonball2', 'l_pokemon', 'onepiece',
    'l_naruto',  # tratado a parte: a presenca dele faz rodar
    'adventure', 'rouge', 'yugioh', 'pokemon', 'digimon_adventure',
    'gragon_tiger_gate', 'naruto', 'warship_girl_b',
)


def condicao_roda(texto):
    """True/False/None para o projeto Naruto."""
    nomes = re.findall(r'__lua_project_(\w+)', texto)
    if not nomes:
        return None                      # condicao de dado, nao de projeto
    if 'l_naruto' in nomes:
        return True
    return False


eventos = []
pilha = []          # cada item: (tipo, ativo) onde tipo in ('if','else')
i = INICIO
while i <= FIM:
    c = codigo(i).strip()
    if not c:
        i += 1
        continue

    # Abre if
    m = re.match(r'^if\s+(.+?)\s+then\b', c)
    if m or re.match(r'^if\s', c):
        txt = c
        j = i
        # condicao pode continuar em varias linhas ate 'then'
        while 'then' not in txt and j < FIM:
            j += 1
            txt += ' ' + codigo(j).strip()
        decisao = condicao_roda(txt)
        pilha.append(['if', decisao])
        eventos.append(('if', i, decisao, txt[:60]))
        i = j + 1
        continue

    if re.match(r'^else\b', c):
        if pilha and pilha[-1][0] == 'if':
            d = pilha[-1][1]
            pilha[-1][1] = None if d is None else (not d)
            eventos.append(('else', i, pilha[-1][1], ''))
        i += 1
        continue

    if re.match(r'^end\b', c):
        if pilha:
            pilha.pop()
            eventos.append(('end', i, None, ''))
        i += 1
        continue

    # Conta campos
    qtd = c.count('npos(list)')
    if qtd:
        ativo = all(p[1] for p in pilha)
        eventos.append(('campo', i, ativo, c[:60], qtd))

    i += 1

ativos = [e for e in eventos if e[0] == 'campo' and e[2] is True]
inativos = [e for e in eventos if e[0] == 'campo' and e[2] is False]
indef = [e for e in eventos if e[0] == 'campo' and e[2] is None]

print('campos ATIVOS no caminho Naruto (sem lacos): %d' % sum(e[4] for e in ativos))
print('campos em ramo de OUTRO projeto (nao rodam): %d' % sum(e[4] for e in inativos))
print('campos em condicao de dado (indefinido): %d' % sum(e[4] for e in indef))

if indef:
    print('\n--- indefinidos (precisam de decisao manual) ---')
    for e in indef:
        print('  linha %4d (%d campos): %s' % (e[1], e[4], e[3]))

print('\n--- ATIVOS, linha a linha ---')
for e in ativos:
    print('  linha %4d (%d) %s' % (e[1], e[4], e[3]))
