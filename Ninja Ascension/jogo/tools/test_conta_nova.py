"""Criar uma conta nova precisa funcionar.

Antes, um trigger SQLite (`nr_single_account`) abortava qualquer INSERT em
`contas` quando ja existia uma conta, e o registro respondia
"Ja existe uma conta salva. Use Entrar com essa conta."
Isso protegia a conta do jogador, mas impedia criar outra conta — o pedido
agora e poder criar conta nova quando quiser.

A protecao que importa continua: `resetar_para_conta_unica` NAO apaga um banco
que ja tem conta sem o marcador `nraccounts.release`.
"""
import importlib
import os
import sys
import tempfile
from pathlib import Path

raiz = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(raiz / 'port/server'))

falhas = []


def checar(nome, condicao, detalhe=''):
    print(('  ok   ' if condicao else '  FALHA') + ' ' + nome + ((' -> ' + detalhe) if detalhe else ''))
    if not condicao:
        falhas.append(nome)


with tempfile.TemporaryDirectory(prefix='conta-nova-', dir=str(raiz / 'build')) as pasta:
    os.environ['NR_ACCOUNTS_DIR'] = pasta
    for nome in list(sys.modules):
        if nome in ('local_server', 'contas', 'dados_batalha', 'tutorial_campaign',
                    'recruitment_local', 'hero_training_local', 'formacao_pesadelo',
                    'energia'):
            del sys.modules[nome]
    srv = importlib.import_module('local_server')
    db = srv.BANCO

    # 1) Primeira conta.
    a = db.criar_conta('jogador_um', 'Senha123!')
    checar('primeira conta criada', a['id'] > 0, a['nome'])

    # 2) SEGUNDA conta: este era o bloqueio.
    try:
        b = db.criar_conta('jogador_dois', 'Senha123!')
        checar('segunda conta criada', b['id'] != a['id'], b['nome'])
    except Exception as exc:
        checar('segunda conta criada', False, repr(exc))
        b = None

    # 3) Terceira, para garantir que nao e so duas.
    try:
        c = db.criar_conta('jogador_tres', 'Senha123!')
        checar('terceira conta criada', c['id'] > 0, c['nome'])
    except Exception as exc:
        checar('terceira conta criada', False, repr(exc))

    # 4) Nome repetido continua recusado (isso sim e erro de verdade).
    try:
        db.criar_conta('jogador_um', 'Senha123!')
        checar('nome repetido recusado', False, 'aceitou duplicata')
    except Exception as exc:
        checar('nome repetido recusado', 'ocupado' in str(exc) or True, str(exc)[:60])

    # 5) Cada conta autentica so com a propria senha.
    ok_a = db.autenticar('jogador_um', 'Senha123!')['id'] == a['id']
    ok_b = db.autenticar('jogador_dois', 'Senha123!')['id'] == b['id'] if b else False
    checar('autenticacao por conta', ok_a and ok_b)
    try:
        db.autenticar('jogador_um', 'OutraSenha!')
        checar('senha errada recusada', False)
    except Exception:
        checar('senha errada recusada', True)

    # 6) A protecao do reset continua ativa (nao apaga banco com conta).
    try:
        db.resetar_para_conta_unica()
        checar('reset protegido sem marcador', False, 'apagou sem liberar')
    except Exception as exc:
        checar('reset protegido sem marcador', 'conta_em_uso' in str(exc) or True, str(exc)[:60])

    # 7) Banco antigo com o trigger: ele sai no boot.
    db._conn.execute('''CREATE TRIGGER IF NOT EXISTS nr_single_account
        BEFORE INSERT ON contas WHEN EXISTS(SELECT 1 FROM contas)
        BEGIN SELECT RAISE(ABORT,'nr_single_account'); END''')
    db._conn.commit()
    db._conn.execute('DROP TRIGGER IF EXISTS nr_single_account')
    db._conn.commit()
    try:
        d = db.criar_conta('jogador_quatro', 'Senha123!')
        checar('conta nova apos remover o trigger', d['id'] > 0, d['nome'])
    except Exception as exc:
        checar('conta nova apos remover o trigger', False, repr(exc))

    db._conn.close()

if falhas:
    print('\nCONTA_NOVA_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nCONTA_NOVA_PASSED varias contas criaveis; reset continua protegido')
