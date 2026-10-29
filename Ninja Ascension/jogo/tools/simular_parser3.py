"""Simula o parser 3 (parse_login_init) sobre a resposta real do servidor.

Percorre os campos na mesma ordem que ProtocolParserCopy.lua e diz, para cada
contador, se o valor que o servidor mandou e o esperado. Assim os erros de
alinhamento aparecem aqui, sem precisar abrir o jogo e ver tela preta.

Uso: python tools/simular_parser3.py [conta_id]
"""
import importlib
import os
import re
import shutil
import sys
import tempfile
from pathlib import Path

raiz = Path('E:/[code]/nk')
FONTE = raiz / '01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
conta = int(sys.argv[1]) if len(sys.argv) > 1 else 58

# ---------------------------------------------------------------- resposta
pasta = tempfile.mkdtemp(dir=str(raiz / 'build'))
shutil.copy2(str(raiz / 'port/dados/contas.sqlite3'),
             os.path.join(pasta, 'contas.sqlite3'))
os.environ['NR_ACCOUNTS_DIR'] = pasta
sys.path.insert(0, str(raiz / 'port/server'))
for m in list(sys.modules):
    if m in ('local_server', 'contas', 'recruitment_local', 'hero_training_local',
             'tutorial_campaign', 'dados_batalha', 'gameplay_mode'):
        del sys.modules[m]
srv = importlib.import_module('local_server')
db = srv.BANCO
srv.lembrar_token(db.abrir_sessao(conta))
bruto = srv.despacha('5\r\nlogin_init\r\n').split()

# O parser 3 comeca NO token "3": esse token e o primeiro campo lido
# (parser_fun recebe a lista ja posicionada no codigo). Nao somar 1 aqui.
try:
    inicio = bruto.index('3')
except ValueError:
    print('ERRO: resposta nao tem o codigo 3')
    raise SystemExit(1)

# ---------------------------------------------------------------- simulacao
pos = inicio
falhas = []


def campo(nome):
    """Le um campo, como npos(list) faria."""
    global pos
    if pos >= len(bruto):
        falhas.append('%s: acabaram os tokens (pos %d)' % (nome, pos))
        return None
    v = bruto[pos]
    pos += 1
    return v


def num(nome):
    v = campo(nome)
    try:
        return int(v)
    except (TypeError, ValueError):
        falhas.append('%s: esperava numero, veio %r' % (nome, v))
        return 0


def esperado(nome, valor, querido, tolerancia_zero=True):
    """Confere um contador. tolerancia_zero: 'valor' pode ser 0 legitimamente."""
    ok = (valor == querido) if tolerancia_zero else (valor == querido)
    marca = 'ok ' if ok else 'ERRO'
    print('  %s %-26s = %-12s (esperado %s)' % (marca, nome, valor, querido))
    if not ok:
        falhas.append('%s = %s, esperado %s' % (nome, valor, querido))


import recruitment_local as rec
import hero_training_local as hero

print('== parser 3: campos 1..88 (escalares) ==')
for _ in range(88):
    campo('escalar')
print('  (88 campos lidos; pos=%d)' % pos)

print('== contador de itens ==')
n_itens = num('user_prop_number')
itens = srv._itens_do_inventario(conta)
esperado('user_prop_number', n_itens, len(itens))

print('== %d itens x 7 campos ==' % n_itens)
for _ in range(n_itens * 7):
    campo('item')

print('== equipamentos ==')
n_equip = num('user_equiment_number')
esperado('user_equiment_number', n_equip, 0)
# Se houver equipamentos, cada um custa 11 campos no ramo Naruto.
for _ in range(n_equip * 11):
    campo('equipamento')

print('== personagens ==')
n_naves = num('user_ship_number')
donos = rec.all_owned(db, conta)
print('  contas com personagem: %d disponiveis' % len(donos))
# Quantos o servidor realmente mandou: 43 campos por personagem ate o
# proximo codigo de parser conhecido.
restante = len(bruto) - pos
print('  tokens restantes apos o contador: %d' % restante)

for i in range(n_naves):
    base = pos
    for _ in range(43):
        campo('personagem')
    ship_id = bruto[base]
    mould = bruto[base + 1]
    print('  personagem %d: ship_id=%s mould=%s' % (i + 1, ship_id, mould))

print()
if falhas:
    print('FALHAS (%d):' % len(falhas))
    for f in falhas[:20]:
        print('  -', f)
    print('PARSER3_FAILED')
else:
    print('PARSER3_OK')
print('posicao final:', pos, 'de', len(bruto))

try:
    db._conn.close()
except Exception:
    pass
shutil.rmtree(pasta, ignore_errors=True)
