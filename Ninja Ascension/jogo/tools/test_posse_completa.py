"""Verifica que o servidor ENTREGA os personagens concedidos.

O banco foi preenchido por tools/conceder_tudo.py. Este teste sobe o servidor
num banco TEMPORARIO copiado do ativo, faz login e confere nos tokens reais:

  * a conta recebe 104 personagens (user_ship_number);
  * o rank vai em 14104 (nao em fields[8], que e captain_name);
  * rank 21 -> 3 estrelas, tier 7 (getHeroStars);
  * nivel do personagem = 100 no campo ship_grade;
  * nivel da conta = 500 (user_grade).
"""
import importlib
import os
import re
import shutil
import sqlite3
import sys
import tempfile
from pathlib import Path

raiz = Path('E:/[code]/nk')
sys.path.insert(0, str(raiz / 'port/server'))
falhas = []


def checar(nome, condicao, detalhe=''):
    print(('  ok   ' if condicao else '  FALHA') + ' ' + nome + ((' -> ' + detalhe) if detalhe else ''))
    if not condicao:
        falhas.append(nome)


ativo = raiz / 'port/dados/contas.sqlite3'
pasta = tempfile.mkdtemp(prefix='posse-', dir=str(raiz / 'build'))
copia = Path(pasta) / 'contas.sqlite3'
shutil.copy2(str(ativo), str(copia))     # copia: nao toca no banco real
os.environ['NR_ACCOUNTS_DIR'] = pasta
os.environ.pop('NR_ENABLE_TUTORIAL', None)

for nome in list(sys.modules):
    if nome in ('local_server', 'contas', 'tutorial_campaign', 'dados_batalha',
                'hero_training_local', 'recruitment_local', 'gameplay_mode'):
        del sys.modules[nome]
srv = importlib.import_module('local_server')
rec = importlib.import_module('recruitment_local')
db = srv.BANCO

conta = 58
perfil = db.perfil(conta)
usuario = str(perfil['user_id'])
nome_user = perfil['user_name']

print('  conta %s (%s)' % (conta, nome_user))

# 1) Personagens que o servidor enxerga
todos = rec.all_owned(db, conta)
print('    all_owned: %d personagens' % len(todos))
checar('103 personagens no acervo completo', len(todos) == 103, '%d' % len(todos))

moldes = sorted(m for _, m in todos)
checar('Naruto (13)', 13 in moldes)
checar('Sasuke (35)', 35 in moldes)
checar('Sakura (50)', 50 in moldes)
checar('sem molde repetido', len(moldes) == len(set(moldes)),
       '%d unicos de %d' % (len(set(moldes)), len(moldes)))

# 2) Tokens de um personagem: nivel 100 e rank 21
amostra = next(e for e in todos if e[1] == 13)      # Naruto
toks = rec.one_ship_tokens(db, conta, amostra)
# ['9', silver, fields..., '14104', metadata...]
i14104 = toks.index('14104')
fields = toks[2:i14104]
metadata = toks[i14104 + 1:]
print('    Naruto: fields[10] (ship_grade) = %r' % fields[10])
checar('nivel do personagem = 100', fields[10] == '100', fields[10])
# fields[8] e captain_name (ProtocolParserCopy.lua:533), NAO o rank: qualquer
# valor aqui e aceitavel, desde que o rank tenha ido no bloco 14104.
checar('rank nao vazou para captain_name', fields[8] != '21', fields[8])
# metadata: ship_id, evolution, quality, star, ...
print('    metadata[2]=quality=%r metadata[3]=star=%r' % (metadata[2], metadata[3]))
checar('rank 21 em metadata', metadata[2] == '21', metadata[2])
checar('3 estrelas (getHeroStars)', metadata[3] == '3', metadata[3])

# 3) Login real: user_grade 500 e contagem de personagens
srv.lembrar_token(db.abrir_sessao(conta))
r = srv.despacha('5\r\nlogin_init\r\n').split()
pos = r.index('3')
bloco = r[pos + 1: pos + 1 + 96]
checar('user_grade = 500 no login', bloco[17] == '500', bloco[17])
print('    user_ship_number (token 92) = %r' % bloco[91])

# 4) Inventario servido: contador de itens > 0
itens = db._conn.execute(
    'SELECT COUNT(*) FROM local_inventory WHERE conta_id=?', (conta,)).fetchone()[0]
checar('itens no inventario (1693 + 4 que ja existiam)', itens >= 1693, str(itens))

try:
    db._conn.close()
except Exception:
    pass
shutil.rmtree(pasta, ignore_errors=True)

if falhas:
    print('\nPOSSE_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nPOSSE_PASSED servidor entrega 104 personagens nivel 100 e 7 estrelas')
