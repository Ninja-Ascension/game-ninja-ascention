"""Simula o parser 3 do cliente campo a campo e mostra onde cada contador cai.

Le a resposta real de login_init e percorre exatamente como
ProtocolParserCopy.lua:parse_login_init faz, seguindo os lacoes de verdade.
Serve para descobrir em QUAL campo o cliente le um valor absurdo (ex.:
user_equiment_number grande -> _ED.user_equiment[id] com id nil na linha 494).
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
campos = t[4:]

i = 0


def take(n=1):
    global i
    v = campos[i:i + n]
    i += n
    return v[0] if n == 1 else v


# --- cabecalho: 87 campos fixos + contador de itens
for _ in range(87):
    take()
n_itens = int(take())
print('campo 88 user_prop_number = %d' % n_itens)

# --- itens: cada um custa 7 campos (ids 1,2,3,5,6,7,8 - linhas 396-410)
for k in range(n_itens):
    take(7)
print('apos %d itens -> cursor %d' % (n_itens, i))

# --- equipamentos (444-484): o contador e lido aqui
n_equip = int(take())
print('user_equiment_number = %d  (cursor %d)' % (n_equip, i))
if n_equip:
    print('  !! o cliente vai indexar _ED.user_equiment[id]; precisa ser 0')
    for k in range(n_equip):
        equip_id = take()
        take()                       # mould
        take(3)                      # nome, preco, tipo
        take(3)                      # ability, grade, exprience
        take()                       # growup_value
        take(2)                      # refine_level, refine_param
        take(2)                      # linhas 484: 2 campos
        print('  equip %d id=%r' % (k + 1, equip_id))

# --- personagens
n_naves = int(take())
print('user_ship_number = %d  (cursor %d)' % (n_naves, i))
for k in range(n_naves):
    sid = take()
    tmpl = take()
    take(25)          # 3..27 do ramo l_naruto
    rel = int(take())
    if rel:
        take(rel * 2)
    tal = int(take())
    if tal:
        take(tal * 2)
    take(8)           # treino
    take(2)           # skill
    take(4)           # awaken
    print('  personagem %d id=%s tmpl=%s' % (k + 1, sid, tmpl))

n_form = int(take())
print('have_formetion_number = %d  (cursor %d)' % (n_form, i))
for k in range(n_form):
    take(10)

take()                # little_companion_state
take()                # 966 buy_god
take()                # 967 camp_god
print('fim do parser 3 -> cursor %d' % i)
print('proximo token      : %r' % (campos[i] if i < len(campos) else '<FIM>'))
print('  (deve ser 12042)')
