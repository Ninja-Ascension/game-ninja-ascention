"""Simula o parser 3 campo a campo numa conta NOVA (vazia).

Mostra exatamente em que posicao o parser pede um token que nao existe —
que e o que causa "'for' limit must be a number" (tonumber(nil)) e
"bad argument (number expected, got nil)".
"""
import importlib
import os
import shutil
import sys
import tempfile
from pathlib import Path

raiz = Path('E:/[code]/nk')
pasta = tempfile.mkdtemp(dir=str(raiz / 'build'))
shutil.copy2(str(raiz / 'port/dados/contas.sqlite3'),
             os.path.join(pasta, 'contas.sqlite3'))
os.environ['NR_ACCOUNTS_DIR'] = pasta
sys.path.insert(0, str(raiz / 'port/server'))
for m in list(sys.modules):
    if m in ('local_server', 'contas', 'recruitment_local'):
        del sys.modules[m]
srv = importlib.import_module('local_server')
db = srv.BANCO

nome = 'simul_' + str(os.getpid() % 10000)
conta = db.criar_conta(nome, 'senha123')['id']
srv.lembrar_token(db.abrir_sessao(conta))
toks = srv.despacha('5\r\nlogin_init\r\n').split()
inicio = toks.index('3')
print('conta nova id=%d, tokens apos o 3: %d' % (conta, len(toks) - inicio))

pos = inicio


def campo(nome_campo):
    global pos
    if pos >= len(toks):
        print('  !! FALTOU TOKEN em %s (campo %d)' % (nome_campo, pos - inicio + 1))
        return None
    v = toks[pos]
    pos += 1
    return v


def inteiro(nome_campo):
    v = campo(nome_campo)
    try:
        return int(v)
    except (TypeError, ValueError):
        print('  !! %s nao e numero: %r' % (nome_campo, v))
        return None


print('\n-- 88 campos escalares --')
for k in range(88):
    if campo('escalar%d' % (k + 1)) is None:
        break

print('\n-- contador de itens (campo 89) --')
n_itens = inteiro('user_prop_number')
print('  user_prop_number =', n_itens)
if n_itens:
    for _ in range(n_itens * 7):
        campo('item')

print('\n-- bloco de equipamentos (28 campos, contador zero) --')
n_equip = inteiro('user_equiment_number')
print('  user_equiment_number =', n_equip)
if n_equip:
    for _ in range(n_equip * 11):
        campo('equipamento')
else:
    # Sem equipamentos o parser NAO le os 27 campos restantes desse bloco
    # quando o contador e 0? Nao: ele le sempre (sao escalares do usuario,
    # nao do equipamento). Por isso a cauda do servidor tem 28 campos.
    for _ in range(27):
        campo('cauda_equip')

print('\n-- contador de personagens --')
n_naves = inteiro('user_ship_number')
print('  user_ship_number =', n_naves)
if n_naves:
    for k in range(n_naves):
        for _ in range(43):
            campo('personagem%d' % (k + 1))

print('\n-- proximos 8 tokens (deveriam ser codigos de outros parsers) --')
print(' ', toks[pos:pos + 8])
print('\nposicao final: %d de %d' % (pos, len(toks)))

try:
    db._conn.close()
except Exception:
    pass
shutil.rmtree(pasta, ignore_errors=True)
