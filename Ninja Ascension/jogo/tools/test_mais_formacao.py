"""Passo 2: o "+" da formacao — adicionar, retirar, substituir e salvar.

Usa o formato que o cliente REALMENTE envia (Formation.lua:759-763):

    ship_id \\r\\n posicao \\r\\n "1"

  * posicao 1..6  -> coloca o ninja na vaga (troca com quem estiver la)
  * posicao 0     -> retira o ninja da formacao

e confirma que a formacao sobrevive a um RELOGIN (nova sessao), que e o
"salvar" que o usuario pediu para testar.
"""
import importlib
import os
import shutil
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


pasta = tempfile.mkdtemp(prefix='mais-', dir=str(raiz / 'build'))
os.environ['NR_ACCOUNTS_DIR'] = pasta
for nome in list(sys.modules):
    if nome in ('local_server', 'contas', 'tutorial_campaign',
                'hero_training_local', 'recruitment_local'):
        del sys.modules[nome]
srv = importlib.import_module('local_server')
rec = importlib.import_module('recruitment_local')
db = srv.BANCO
conta = db.criar_conta('mais_teste', 'Temporary123!')['id']

naruto = str(conta * 100000 + 13)
sasuke = str(conta * 100000 + 35)
sakura = str(conta * 100000 + 1)


def slots():
    return rec.formation_tokens(db, conta)[2:8]


def enviar(ship, posicao, modo='1'):
    srv.lembrar_token(db.abrir_sessao(conta))
    r = srv.despacha('77\r\nformation_change\r\n%s\r\n%s\r\n%s\r\n'
                     % (ship, posicao, modo))
    return r.split()


def ok_resposta(r):
    return len(r) > 2 and r[1] == 'formation_change' and r[2] == '0'


print('    inicial: %s' % slots())
checar('inicial: 2,4,6 ocupadas',
       [i + 1 for i, v in enumerate(slots()) if v != '0'] == [2, 4, 6], str(slots()))

# 1) MOVER para vaga vazia: Naruto da 2 para a 1.
r = enviar(naruto, 1)
s = slots()
print('    Naruto -> vaga 1: %s  (resposta %s)' % (s, r[:3]))
checar('mover responde status 0', ok_resposta(r), str(r[:4]))
checar('Naruto na vaga 1', s[0] == naruto, s[0])
checar('vaga 2 ficou vazia (era a do Naruto)', s[1] == '0', s[1])
checar('Sasuke e Sakura intactos', s[3] == sasuke and s[5] == sakura, str(s))

# 2) SUBSTITUIR: Sasuke na vaga 1, ocupada pelo Naruto.
r = enviar(sasuke, 1)
s = slots()
print('    Sasuke -> vaga 1: %s  (resposta %s)' % (s, r[:3]))
checar('substituir responde status 0', ok_resposta(r), str(r[:4]))
checar('Sasuke na vaga 1', s[0] == sasuke, s[0])
checar('Naruto foi para a vaga do Sasuke (4)', s[3] == naruto, s[3])
checar('Sakura continua na 6', s[5] == sakura, s[5])

# 3) RETIRAR: posicao 0 tira o ninja da formacao.
r = enviar(sakura, 0)
s = slots()
print('    Sakura -> posicao 0: %s  (resposta %s)' % (s, r[:3]))
checar('retirar responde status 0', ok_resposta(r), str(r[:4]))
checar('vaga 6 vazia', s[5] == '0', s[5])

# 4) RECOLOCAR (o "+" de verdade): Sakura de volta na vaga 6.
r = enviar(sakura, 6)
s = slots()
print('    Sakura -> vaga 6: %s  (resposta %s)' % (s, r[:3]))
checar('recolocar responde status 0', ok_resposta(r), str(r[:4]))
checar('Sakura voltou para a vaga 6', s[5] == sakura, s[5])

# 5) Modo "2": arrastar entre vagas (FormationChange.lua:512).
r = enviar(naruto, 2, '2')
s = slots()
print('    Naruto -> vaga 2 (modo 2): %s  (resposta %s)' % (s, r[:3]))
checar('modo 2 aceito', ok_resposta(r), str(r[:4]))
checar('Naruto na vaga 2', s[1] == naruto, s[1])

# 6) SALVAR: relogin e a formacao continua igual.
antes = rec.formation_tokens(db, conta)
db.abrir_sessao(conta)            # nova sessao = relogin
depois = rec.formation_tokens(db, conta)
print('    antes do relogin : %s' % antes[:9])
print('    depois do relogin: %s' % depois[:9])
checar('formacao sobrevive ao relogin', antes == depois, '%s != %s' % (antes[:9], depois[:9]))
checar('vaga 6 preservada (Sakura)', depois[7] == sakura, str(depois[2:9]))

# 7) Recusas.
r = enviar('99999999', 1)
checar('recusa ninja nao possuido', not ok_resposta(r), str(r[:4]))
r = enviar(naruto, 9)
checar('recusa posicao invalida', not ok_resposta(r), str(r[:4]))
r = enviar(naruto, 1, '7')
checar('recusa modo invalido', not ok_resposta(r), str(r[:4]))

# Fecha o banco ANTES de apagar a pasta: no Windows o arquivo fica travado
# enquanto qualquer conexao estiver aberta.
try:
    db._conn.close()
except Exception:
    pass
try:
    shutil.rmtree(pasta, ignore_errors=True)
except Exception:
    pass

if falhas:
    print('\nMAIS_FORMACAO_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nMAIS_FORMACAO_PASSED adicionar, retirar, substituir, arrastar e salvar')
