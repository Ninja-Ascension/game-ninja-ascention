"""Reconstroi a sequencia EXATA de tokens que o parser 3 consome.

Em vez de contar `npos()` solto (que erra em ramos condicionais), este script
interpreta o fluxo do parser para o projeto Naruto e devolve a lista de campos
na ordem real, marcando os contadores de laco. Serve para comparar com o que o
servidor emite.

Metodo: caminha linha a linha entre INICIO e FIM, decide cada `if` pelo valor
conhecido das constantes do projeto (__lua_project_l_naruto), e registra:
  * cada npos(list) na ordem
  * cada laco `for ... do` com o contador que o controla e quantas vezes roda
"""
import re
import sys
from pathlib import Path

raiz = Path('E:/[code]/nk')
FONTE = raiz / '01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
INICIO, FIM = 240, 1420

linhas = FONTE.read_text(encoding='utf8', errors='replace').splitlines()


def codigo(n):
    """Linha sem comentario."""
    return re.sub(r'--.*$', '', linhas[n - 1])


# Constantes do projeto: o build e do Naruto.
PROJETO = 'l_naruto'


def avaliar_condicao(txt):
    """Decide a condicao para o projeto Naruto.

    Formato tipico:
        if __lua_project_id == __lua_project_l_digital or ... == __lua_project_l_naruto
    Devolve True/False/None (None = nao decidivel estaticamente).
    """
    txt = ' '.join(txt.split())
    nomes = re.findall(r'__lua_project_(\w+)', txt)
    if not nomes:
        return None
    if PROJETO in nomes:
        return True
    # Nao cita o projeto: e uma condicao de dado (ex.: ship_type >= 2).
    if not any(n.startswith('l_') or n in (
            'digital', 'dragonball', 'dragonball2', 'pokemon', 'onepiece',
            'adventure', 'rouge', 'yugioh', 'naruto', 'digimon') for n in nomes):
        return None
    return False


# Primeiro passo: mostrar todos os contadores e lacos do trecho, para
# montar a arvore de decisao correta.
eventos = []
i = INICIO
while i <= FIM:
    c = codigo(i).strip()
    if c:
        m = re.match(r'_ED\.(\w+)\s*=\s*(?:tonumber\()?npos\(list\)', c)
        if m:
            eventos.append(('campo', i, m.group(1)))
        m = re.match(r'_ED\.user_ship_number', c)
        if m:
            eventos.append(('ship_number', i, 'user_ship_number'))
        m = re.match(r'for\s+(\w+)\s*=\s*(.+?)\s+do', c)
        if m:
            eventos.append(('laco', i, m.group(2)))
        if re.match(r'else\s*$', c):
            eventos.append(('else', i, ''))
        if re.match(r'end\s*$', c):
            eventos.append(('end', i, ''))
    i += 1

print('eventos relevantes no parser 3 (linhas %d-%d):\n' % (INICIO, FIM))
for tipo, n, info in eventos:
    if tipo == 'laco':
        print('  %-12s linha %4d  for = %s' % (tipo, n, info))
    elif tipo in ('else', 'end'):
        print('  %-12s linha %4d' % (tipo, n))
    else:
        print('  %-12s linha %4d  %s' % (tipo, n, info))

print('\ntotal de eventos: %d' % len(eventos))
