"""Percorre a resposta REAL de login_init com as mesmas regras do parser 3 e
mostra em que token cada leitura cai. Assim a fronteira do bloco de
personagens e MEDIDA, nao deduzida.

Uso: python tools/rastrear_login.py
"""
import os
import shutil
import sys
import tempfile

sys.path.insert(0, 'N:/port/server')
p = tempfile.mkdtemp(dir='N:/build')
shutil.copy2('N:/port/dados/contas.sqlite3', p + '/contas.sqlite3')
os.environ['NR_ACCOUNTS_DIR'] = p

import local_server as s

db = s.BANCO
s.lembrar_token(db.abrir_sessao(61))
bruto = s.despacha('5\r\nlogin_init\r\n')
t = bruto.split()
# A resposta e: <seq> <nome_cmd> <status> <codigo_parser> <campos...>.
# t.index('3') pega o PRIMEIRO '3' do texto, que pode ser outro valor
# (ex.: um status). Ancorar nos quatro primeiros tokens.
seq_, nome_, status_, codigo_ = t[0], t[1], t[2], t[3]
assert codigo_ == '3', 'codigo do parser 3 nao esta no 4o token: %r' % (codigo_,)
i = 4

cursor = [0]


def npos(nome=''):
    v = t[i + cursor[0]] if i + cursor[0] < len(t) else '<FIM>'
    cursor[0] += 1
    return v


def ton(v):
    try:
        return int(v)
    except (TypeError, ValueError):
        return None


def marca(titulo):
    print('  --- %-28s cursor=%d' % (titulo, cursor[0]))


print('=== bloco de 88 campos (1..87 fixos + contador) ===')
# Os campos 1..87 sao fixos; o 88 e o contador de itens lido logo abaixo.
for n in range(1, 88):
    npos()
marca('apos 87 campos')

n_itens = ton(npos())
marca('apos user_prop_number (%s)' % n_itens)

for _ in range((n_itens or 0) * 7):
    npos()
marca('apos %s itens' % n_itens)

n_equip = ton(npos())
marca('apos user_equiment_number (%s)' % n_equip)

# Laço de equipamentos: 11 campos cada (ProtocolParserCopy.lua:448-512)
for _ in range((n_equip or 0) * 11):
    npos()
marca('apos %s equipamentos' % n_equip)

n_naves = ton(npos())
marca('apos user_ship_number (%s)' % n_naves)
inicio = cursor[0]

print('\n=== laço de personagens (49 campos fixos, contadores 0) ===')
for k in range(n_naves or 0):
    antes = cursor[0]
    ship_id = npos()
    tmpl = npos()
    for _ in range(31):          # campos 3..33
        npos()
    for _ in range(2):           # 34 relationship_count, 35 talent_count
        npos()
    for _ in range(8):           # 36..43 ship_train_info
        npos()
    for _ in range(2):           # 44..45 skill_level, skill_value
        npos()
    for _ in range(4):           # 46..49 awaken*
        npos()
    print('  personagem %d: inicio offset %d, id=%s tmpl=%s -> fim offset %d'
          % (k + 1, antes, ship_id, tmpl, cursor[0]))
marca('apos %s personagens' % n_naves)
print('  total consumido pelo bloco:', cursor[0] - inicio)

print('\n=== depois do bloco ===')
print('  token no cursor:', t[i + cursor[0]][:60])
print('  proximos 12    :', [x[:14] for x in t[i + cursor[0]: i + cursor[0] + 12]])
print('\n  se o parser leu have_formetion_number aqui, deve ser um inteiro pequeno')
print('  total do payload lido ate aqui:', cursor[0], 'de', len(t) - i)
