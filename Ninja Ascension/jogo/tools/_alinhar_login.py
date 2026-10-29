"""Compara, posicao a posicao, o bloco do login com o que o parser espera.

Le do parser (ProtocolParserCopy.lua) os campos ativos ate user_ship_number,
e do servidor a resposta real de login_init. Mostra lado a lado onde o
alinhamento se rompe, em vez de tentar adivinhar o indice do contador.
"""
import os
import re
import shutil
import sys
import tempfile
from pathlib import Path

raiz = Path('E:/[code]/nk')
FONTE = raiz / '01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
sys.path.insert(0, str(raiz / 'port/server'))

# ---------- 1) campos esperados, na ordem do parser ----------
linhas = FONTE.read_text(encoding='utf8', errors='replace').splitlines()


def codigo(n):
    return re.sub(r'--.*$', '', linhas[n - 1])


campos = []
pilha = []
i = 240
while i <= 514:
    c = codigo(i).strip()
    if not c:
        i += 1
        continue
    if re.match(r'^if\s', c):
        txt = c
        j = i
        while 'then' not in txt and j < 514:
            j += 1
            txt += ' ' + codigo(j).strip()
        nomes = re.findall(r'__lua_project_(\w+)', txt)
        pilha.append('l_naruto' in nomes if nomes else None)
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
    k = c.count('npos(list)')
    if k and all(p for p in pilha):
        m = re.search(r'(\w+)\s*=\s*(?:tonumber\()?npos\(list\)', c)
        for _ in range(k):
            campos.append((len(campos) + 1, (m.group(1) if m else '<tabela>'), i))
    i += 1

print('parser: %d campos ativos antes dos personagens' % len(campos))

# ---------- 2) resposta real ----------
pasta = tempfile.mkdtemp(dir=str(raiz / 'build'))
shutil.copy2(str(raiz / 'port/dados/contas.sqlite3'), os.path.join(pasta, 'contas.sqlite3'))
os.environ['NR_ACCOUNTS_DIR'] = pasta
import importlib
for m in list(sys.modules):
    if m in ('local_server', 'contas', 'recruitment_local', 'hero_training_local',
             'tutorial_campaign', 'dados_batalha', 'gameplay_mode'):
        del sys.modules[m]
srv = importlib.import_module('local_server')
db = srv.BANCO
srv.lembrar_token(db.abrir_sessao(58))
toks = srv.despacha('5\r\nlogin_init\r\n').split()
inicio = toks.index('3') + 1        # primeiro token do parser 3
servidor = toks[inicio:]
print('servidor: resposta com %d tokens apos o codigo 3' % len(servidor))

# ---------- 3) compara ----------
# Onde esta user_ship_number no servidor? O valor deve ser o numero de naves.
import recruitment_local as rec
naves = len(rec.all_owned(db, 58))
print('personagens esperados: %d' % naves)
pos = [k + 1 for k, v in enumerate(servidor[:300]) if v == str(naves)]
print('valor %d aparece nas posicoes 1..300: %s' % (naves, pos))

print('\nprimeiros %d campos, parser vs servidor:' % min(len(campos), 62))
for idx, nome, linha in campos[:62]:
    real = servidor[idx - 1] if idx - 1 < len(servidor) else '<fim>'
    marca = '' if nome == '<tabela>' else '  <<<'
    print('%3d  %-24s parse=%-14s serv=%-14s%s'
          % (idx, nome, '', real, marca if nome in ('user_prop_number', 'user_ship_number') else ''))

try:
    db._conn.close()
except Exception:
    pass
shutil.rmtree(pasta, ignore_errors=True)
