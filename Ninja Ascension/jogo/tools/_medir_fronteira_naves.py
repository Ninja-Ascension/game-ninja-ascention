"""Localiza, na resposta real de login, o fim do bloco de personagens e os
campos que o parser le logo depois (have_formetion_number, formacao,
little_companion_state).

Em vez de calcular o deslocamento por aritmetica (que ja errou varias vezes),
percorre os tokens e mostra os candidatos a fronteira: o campo que deve ser
"have_formetion_number" seguido de 10 posicoes numericas e depois uma string
com virgulas.
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
i = t.index('3')

n_itens = int(t[i + 87])
print('campo 88 (user_prop_number) =', n_itens)
pos = 88 + 7 * n_itens
print('apos itens, campo', pos + 1, '=', t[i + pos])
print('campo', pos + 2, '=', t[i + pos + 1], '(esperado: user_ship_number)')

n_naves = int(t[i + pos + 1])
print('user_ship_number =', n_naves)
inicio_naves = pos + 2
print('\ninicio do 1o personagem, campo', inicio_naves + 1, '=', t[i + inicio_naves])
print('proximos 6:', t[i + inicio_naves: i + inicio_naves + 6])

# O bloco de cada personagem nao tem tamanho fixo garantido enquanto nao for
# provado; em vez de assumir 43, procura a fronteira real: a sequencia
# have_formetion_number (=1) + 10 posicoes numericas + string com virgulas.
print('\ncandidatos a fronteira (transicao do bloco de personagens):')
achou = []
for k in range(inicio_naves, min(inicio_naves + 43 * n_naves + 60, len(t) - i - 12)):
    if t[i + k] != '1':
        continue
    dez = t[i + k + 1: i + k + 11]
    dep = t[i + k + 11] if i + k + 11 < len(t) - i else ''
    ok_nums = all(x.lstrip('-').isdigit() for x in dez) and len(dez) == 10
    ok_virg = ',' in dep
    if ok_nums and ok_virg:
        achou.append((k, dez, dep[:30]))

for k, dez, dep in achou[:4]:
    print('  offset', k, '-> posicoes', dez, '| depois:', dep)

if not achou:
    print('  NENHUM — a fronteira nao esta na forma esperada')

print('\ntotal de tokens:', len(t) - i, '(a partir do codigo 3)')
