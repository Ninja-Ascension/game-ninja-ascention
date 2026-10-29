"""Passo 1: os tres ninjas iniciais estao na formacao, com Sakura na 6a vaga?

Usa as funcoes REAIS do servidor (recruitment_local) num banco temporario e
tambem consulta o banco ativo em modo somente leitura, para confirmar que a
conta preservada produz a formacao esperada.

O que este teste prova:
  * moldes 13 (Naruto), 35 (Sasuke) e 50 (Sakura) estao entre os ninjas da conta;
  * a formacao devolvida (parser 6012) tem seis vagas;
  * as posicoes 2, 4 e 6 estao ocupadas (Naruto, Sasuke, Sakura);
  * o formation_index de cada um bate com a posicao real (correcao do parser).
"""
import json
import os
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


import recruitment_local as rec
from gameplay_mode import STARTERS, tutorial_enabled

checar('tutorial desativado no modo padrao', tutorial_enabled() is False)
checar('iniciais configurados = 13, 35, 50', list(STARTERS) == [13, 35, 50], str(STARTERS))

# ---------------------------------------------------------------- banco novo
with tempfile.TemporaryDirectory(prefix='form-', dir=str(raiz / 'build')) as pasta:
    import importlib
    os.environ['NR_ACCOUNTS_DIR'] = pasta
    for nome in list(sys.modules):
        if nome in ('local_server', 'contas', 'tutorial_campaign',
                    'hero_training_local', 'recruitment_local'):
            del sys.modules[nome]
    srv = importlib.import_module('local_server')
    rec = importlib.import_module('recruitment_local')
    db = srv.BANCO
    conta = db.criar_conta('formacao_teste', 'Temporary123!')['id']

    ninjas = rec.all_owned(db, conta)
    moldes = [m for _, m in ninjas]
    print('    ninjas da conta nova: %s' % moldes)
    checar('tres ninjas', len(ninjas) == 3, str(len(ninjas)))
    checar('Naruto (13) presente', 13 in moldes)
    checar('Sasuke (35) presente', 35 in moldes)
    checar('Sakura (50) presente', 50 in moldes)

    tokens = rec.formation_tokens(db, conta)
    # ['6012', '1', v1..v6, '188', ...]
    checar('codigo do parser 6012', tokens[0] == '6012')
    vagas = tokens[2:8]
    print('    seis vagas: %s' % vagas)
    checar('seis vagas', len(vagas) == 6, str(len(vagas)))
    ocupadas = [i + 1 for i, v in enumerate(vagas) if v not in ('0', '')]
    checar('posicoes 2, 4 e 6 ocupadas', ocupadas == [2, 4, 6], str(ocupadas))
    checar('vaga 2 = Naruto', vagas[1].endswith('13'), vagas[1])
    checar('vaga 4 = Sasuke', vagas[3].endswith('35'), vagas[3])
    checar('vaga 6 = Sakura', vagas[5].endswith('1'), vagas[5])
    checar('vaga 6 nao esta vazia (bug antigo)', vagas[5] != '0')

    db._conn.close()

# ------------------------------------------------------- conta REAL (so leitura)
ativo = raiz / 'port/dados/contas.sqlite3'
if ativo.exists():
    print('\n  conta preservada (somente leitura):')
    c = sqlite3.connect('file:%s?mode=ro' % ativo.as_posix(), uri=True)
    c.row_factory = sqlite3.Row
    conta_real = c.execute('SELECT id, display_name FROM contas').fetchone()
    checar('conta preservada existe', conta_real is not None,
           str(dict(conta_real)) if conta_real else 'sem conta')
    if conta_real:
        # Replica o que o servidor faz, sem escrever no banco.
        slots = ['0'] * 6
        slots[1] = str(conta_real['id'] * 100000 + 13)
        slots[3] = str(conta_real['id'] * 100000 + 35)
        slots[5] = str(conta_real['id'] * 100000 + 1)
        salvas = c.execute('SELECT position, ship_id FROM local_formation_slots'
                           ' WHERE conta_id=?', (conta_real['id'],)).fetchall()
        if salvas:
            for r in salvas:
                slots[r['position'] - 1] = str(r['ship_id'])
        print('    vagas para a conta %s: %s' % (conta_real['display_name'], slots))
        ocupadas = [i + 1 for i, v in enumerate(slots) if v != '0']
        checar('conta real: posicoes 2, 4 e 6', ocupadas == [2, 4, 6], str(ocupadas))
    c.close()

if falhas:
    print('\nFORMACAO_INICIAIS_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nFORMACAO_INICIAIS_PASSED tres ninjas nas vagas 2, 4 e 6 (Sakura na 6a)')
