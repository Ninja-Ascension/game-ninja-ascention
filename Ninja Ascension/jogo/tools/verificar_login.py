"""Verificacao objetiva da resposta de login_init contra o parser 3.

Nao imprime payload: so os contadores e a assinatura de cada bloco.
Sai com codigo != 0 se algo estiver fora de ordem.
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

CONTA = int(sys.argv[1]) if len(sys.argv) > 1 else 61
db = s.BANCO
s.lembrar_token(db.abrir_sessao(CONTA))
t = s.despacha('5\r\nlogin_init\r\n').split()

falhas = []


def check(cond, msg):
    if cond:
        print('  OK   ' + msg)
    else:
        print('  FALHA ' + msg)
        falhas.append(msg)


check(t[:4] == ['5', 'login_init', '0', '3'],
      'cabecalho seq/login_init/status/codigo3 = %r' % (t[:4],))
campos = t[4:]

# Nenhum campo pode ser vazio: o parse do cliente separa por tab e '' some.
vazios = [k + 1 for k, v in enumerate(campos) if v == '']
check(not vazios, 'nenhum campo vazio (deslocaria o parser): %s'
      % (vazios[:5] if vazios else 'ok'))

i = 0


def take(n=1):
    global i
    v = campos[i:i + n]
    i += n
    return v[0] if n == 1 else v


# 87 campos fixos + contador de itens
for _ in range(87):
    take()
n_itens = int(take())
check(n_itens >= 0, 'user_prop_number (campo 88) = %d' % n_itens)

# itens: 7 tokens cada
itens = [take(7) for _ in range(n_itens)]
check(all(len(x) == 7 for x in itens), '%d item(ns), 7 campos cada' % n_itens)

n_equip = int(take())
check(n_equip == 0, 'user_equiment_number = %d' % n_equip)
if n_equip:
    for _ in range(n_equip * 11):
        take()

n_naves = int(take())
check(n_naves >= 0, 'user_ship_number = %d' % n_naves)

naves = []
for _ in range(n_naves):
    f = take(43)               # 43 campos por personagem (ramo l_naruto)
    naves.append((f[0], f[1]))
check(all(a not in ('', '0') for a, _ in naves),
      'cada personagem comeca por ship_id valido')
print('       personagens: %s' % [(a, b) for a, b in naves][:6])

n_form = int(take())
check(n_form == 1, 'have_formetion_number = %d' % n_form)
posicoes = take(10)
check(len(posicoes) == 10 and all(x.lstrip('-').isdigit() for x in posicoes),
      'formacao com 10 posicoes numericas: %s' % (posicoes,))
espaco = [take()]
check(',' in ' '.join(espaco), 'little_companion_state = %r' % (espaco,))

# Os dois ultimos campos do parser 3 (ProtocolParserCopy.lua:966-967).
acum = take(2)
check(all(x.lstrip('-').isdigit() for x in acum),
      'user_accumulate_buy_god/camp_god = %s' % (acum,))

resto = campos[i:]
check(resto and resto[0] == '12042',
      'proximo codigo de parser depois do bloco 3 = %r' % (resto[:1],))
print('       codigos seguintes: %s'
      % [x for x in resto if x.isdigit() and len(x) in (4, 5)][:8])
print('       tokens lidos pelo parser 3: %d de %d' % (i, len(campos)))

print()
print('RESULTADO:', 'LOGIN_OK' if not falhas else 'LOGIN_FALHOU (%d)' % len(falhas))
sys.exit(0 if not falhas else 1)
