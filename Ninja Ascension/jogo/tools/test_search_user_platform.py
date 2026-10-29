"""search_user_platform precisa dar SUCESSO quando há conta salva.

O travamento na tela de login vinha daqui. O cliente (login.lua:1737-1766) só
faz algo dentro de:

    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        ... abre janela de conta OU entra automaticamente ...
    end

Não existe `else`. Com status negativo, nada acontece e a tela fica parada.
O servidor recusava sempre que não havia sessão na conexão (o caso logo após
reiniciar o servidor), e a conta única salva nunca era usada.

Contrato verificado:
  1. com conta no banco e servidor recém-iniciado -> sucesso (status 0);
  2. o token devolvido é válido e serve para o próximo pedido;
  3. sem nenhuma conta no banco -> continua recusando (primeira execução);
  4. com sessão lembrada -> segue funcionando como antes.
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


def novo_servidor(pasta):
    """Importa o servidor do zero, como num boot novo (sessão da conexão vazia)."""
    os.environ['NR_ACCOUNTS_DIR'] = pasta
    for nome in list(sys.modules):
        if nome in ('local_server', 'contas', 'dados_batalha', 'tutorial_campaign',
                    'recruitment_local', 'hero_training_local', 'formacao_pesadelo',
                    'energia'):
            del sys.modules[nome]
    return importlib.import_module('local_server')


# 1) Primeira execução: banco vazio -> recusa é o correto.
with tempfile.TemporaryDirectory(prefix='login-vazio-', dir=str(raiz / 'build')) as pasta:
    srv = novo_servidor(pasta)
    r = srv.despacha('1\r\nsearch_user_platform\r\n')
    checar('banco vazio recusa (primeira execucao)',
           ' -1 ' in r and 'search_user_platform -1' in r, r[:90])
    srv.BANCO._conn.close()

# 2) Com conta salva e servidor recém-iniciado: TEM de dar sucesso.
with tempfile.TemporaryDirectory(prefix='login-conta-', dir=str(raiz / 'build')) as pasta:
    srv = novo_servidor(pasta)
    conta = srv.BANCO.criar_conta('conta_salva', 'Temporary123!')['id']
    # Simula servidor recém-iniciado: nenhuma sessão lembrada na conexão.
    srv.esquecer_token()

    r = srv.despacha('1\r\nsearch_user_platform\r\n')
    print('    resposta: %r' % r[:120])
    # Formato da resposta 327: seq / cmd / status / "327" / conta / token / pacote / tempo
    partes = r.split()
    checar('status de sucesso (o cliente so age com status >= 0)',
           len(partes) > 2 and partes[2] == '0', r[:100])
    checar('devolve a conta salva', 'conta_salva' in r)
    token = partes[5] if len(partes) > 5 else ''
    checar('devolve um token', len(token) > 20, 'indice 5 = %r' % token[:16])
    # 3) O token devolvido vale para o login seguinte (fluxo automático).
    if token:
        r2 = srv.despacha('2\r\nplatform_user_login\r\nconta_salva\r\n@tk1:%s\r\ncom.hyqggw.kkk' % token)
        checar('token do search vale no login', 'platform_user_login 0' in r2, r2[:100])

    # 4) Depois disso a sessão fica lembrada e o fluxo continua.
    r3 = srv.despacha('3\r\nsearch_user_platform\r\n')
    checar('com sessao lembrada continua sucesso', 'search_user_platform 0' in r3, r3[:90])
    srv.BANCO._conn.close()

# 5) Duas contas: não escolhe uma "no chute".
with tempfile.TemporaryDirectory(prefix='login-duas-', dir=str(raiz / 'build')) as pasta:
    srv = novo_servidor(pasta)
    srv.BANCO.criar_conta('conta_a', 'Temporary123!')
    srv.BANCO.criar_conta('conta_b', 'Temporary123!')
    srv.esquecer_token()
    r = srv.despacha('1\r\nsearch_user_platform\r\n')
    checar('duas contas: nao escolhe sozinho', ' -1 ' in r or 'search_user_platform -1' in r, r[:90])
    srv.BANCO._conn.close()

if falhas:
    print('\nSEARCH_PLATFORM_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nSEARCH_PLATFORM_PASSED conta salva responde sucesso; banco vazio recusa')
