"""Login com token lembrado inválido não pode mais dar "erro desconhecido".

Reproduz o que aconteceu na prática: o cliente guardou um token no
UserDefault, o servidor reiniciou/zerou as sessões e o próximo login mandava
"@tk1:<token velho>". Antes, o servidor respondia
    platform_user_login -1 "Sessao invalida."
e o jogo mostrava erro desconhecido em laço, sem forma de entrar.

Contrato esperado agora:
  * conta existente + token desconhecido -> sessão reemitida (status 0);
  * conta inexistente                    -> continua recusando;
  * token válido                          -> segue funcionando (rotaciona);
  * zerar_conta NÃO apaga a tabela de sessões.
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


# 0) O script de reset não pode apagar credenciais.
origem_reset = (raiz / 'tools/zerar_conta.py').read_text(encoding='utf-8')
lista = origem_reset[origem_reset.index('PROGRESSO = ['):origem_reset.index(']', origem_reset.index('PROGRESSO = ['))]
checar('zerar_conta nao apaga sessoes', "'sessoes'" not in lista)

with tempfile.TemporaryDirectory(prefix='login-test-', dir=str(raiz / 'build')) as pasta:
    os.environ['NR_ACCOUNTS_DIR'] = pasta
    server = importlib.import_module('local_server')
    db = server.BANCO
    conta = db.criar_conta('login_test', 'Temporary123!')['id']
    token_valido = db.abrir_sessao(conta)

    def login(nome, segredo):
        return server.despacha('1\r\nplatform_user_login\r\n%s\r\n%s\r\ncom.ninja' % (nome, segredo))

    # 1) Senha em texto continua entrando.
    r = login('login_test', 'Temporary123!')
    checar('login por senha', ' -1 ' not in r and 'platform_user_login 0' in r, r[:90])

    # 2) Token lembrado VÁLIDO (fluxo normal do cliente).
    r = login('login_test', '@tk1:' + token_valido)
    checar('token lembrado valido', 'platform_user_login 0' in r, r[:90])

    # 3) O CASO DO BUG: token que o servidor não conhece mais.
    r = login('login_test', '@tk1:token-que-nao-existe-mais')
    checar('token desconhecido reemite sessao', 'platform_user_login 0' in r, r[:120])
    checar('nao responde mais Sessao invalida', 'Sessao invalida' not in r)

    # 4) Conta inexistente continua sendo recusada (não vira porta aberta).
    r = login('conta_que_nao_existe', '@tk1:qualquer')
    checar('conta inexistente recusada', ' -1 ' in r or 'platform_user_login -1' in r, r[:100])

    # 5) Depois da recuperação, o fluxo inteiro (vali_register + login_init) anda.
    r = server.despacha('2\r\nvali_register\r\nlogin_test\r\n1\r\ncom.ninja\r\n')
    checar('vali_register apos recuperacao', 'vali_register 0' in r, r[:80])
    r = server.despacha('3\r\nlogin_init\r\n')
    checar('login_init apos recuperacao', 'login_init 0' in r, r[:80])

    try:
        db._conn.close()
    except Exception:
        pass

if falhas:
    print('\nLOGIN_TOKEN_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nLOGIN_TOKEN_PASSED token invalido recupera sessao; conta inexistente continua recusada')
