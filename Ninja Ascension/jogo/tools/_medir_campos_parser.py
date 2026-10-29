"""Quantos tokens o parser de user_ship consome vs. quantos o servidor manda.

O parser (ProtocolParserCopy.lua:517-1236) le os campos de CADA personagem
em sequencia. Se o servidor mandar menos tokens que o parser espera, npos()
devolve nil nos ultimos e o parser morre com erro de tipo — derrubando o
login inteiro (tela preta / tela de login que nao abre).

Este script le a faixa do parser, conta os npos() que NAO estao comentados e
compara com o tamanho do bloco que one_ship_tokens produz.
"""
import re
import sys
from pathlib import Path

raiz = Path('E:/[code]/nk')
PARQUER = raiz / '01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
sys.path.insert(0, str(raiz / 'port/server'))

INICIO, FIM = 517, 1236


def npos_na_faixa():
    """Conta chamadas npos(list) ativas (ignora linhas comentadas com --)."""
    linhas = PARQUER.read_text(encoding='utf8', errors='replace').splitlines()
    total = 0
    detalhe = []
    for n in range(INICIO, FIM + 1):
        linha = linhas[n - 1]
        # Remove comentario de fim de linha para nao contar campo comentado.
        codigo = re.sub(r'--.*$', '', linha)
        qtd = codigo.count('npos(list)')
        if qtd:
            total += qtd
            detalhe.append((n, qtd, codigo.strip()[:70]))
    return total, detalhe


total, detalhe = npos_na_faixa()
print('campos lidos pelo parser por personagem: %d' % total)
print('linhas com npos ativo: %d' % len(detalhe))

import shutil
import tempfile
import os
pasta = tempfile.mkdtemp(dir=str(raiz / 'build'))
shutil.copy2(str(raiz / 'port/dados/contas.sqlite3'), os.path.join(pasta, 'contas.sqlite3'))
os.environ['NR_ACCOUNTS_DIR'] = pasta
import importlib
import local_server, recruitment_local as rec
db = local_server.BANCO

ship, mould = rec.all_owned(db, 58)[0]
toks = rec.one_ship_tokens(db, 58, (ship, mould))
# toks = ['9', silver] + fields + ['14104'] + metadata
i = toks.index('14104')
fields = toks[2:i]
print('\nservidor manda %d campos por personagem' % len(fields))
print('faltam %d campos' % (total - len(fields)) if total > len(fields)
      else 'sobram %d campos' % (len(fields) - total))

try:
    db._conn.close()
except Exception:
    pass
shutil.rmtree(pasta, ignore_errors=True)
