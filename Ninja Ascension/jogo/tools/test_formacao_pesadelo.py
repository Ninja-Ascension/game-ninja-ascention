"""Teste do comando 9018 (get_hard_copy_user_formation) em banco temporário.

Segue o padrão dos outros testes de servidor (test_recruitment_local.py):
banco temporário + server.despacha, sem subir HTTP.

O que o cliente exige (LDuplicateWindow.lua:3089-3102 + parser 12407,
ProtocolParserCopyExx.lua:3288-3312):
  * status 0 — sem isso o callback não dispara updateHeroIcons e a tela fica
    parada (era o travamento em 9%);
  * EXATAMENTE um campo de dados: user_formation;
  * "-1" é o valor documentado para "usa a formação atual".
"""
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


with tempfile.TemporaryDirectory(prefix='formacao-test-', dir=str(raiz / 'build')) as pasta:
    os.environ['NR_ACCOUNTS_DIR'] = pasta
    import local_server as server  # noqa: E402

    db = server.BANCO
    conta = db.criar_conta('formacao_test', 'Temporary123!')['id']
    server._sessao_conexao['token'] = db.abrir_sessao(conta)
    uid = str(db.perfil(conta)['user_id'])

    # Pedido real do cliente: seq / cmd / user_id (ProtocolCommanderCopyExx:5173).
    pedido = '7\r\nget_hard_copy_user_formation\r\n%s' % uid
    resposta = server.despacha(pedido)
    print('    resposta: %r' % resposta)

    partes = resposta.split()
    checar('não é erro de não implementado', 'nao_implementado' not in resposta)
    checar('status 0', len(partes) > 2 and partes[2] == '0', resposta[:120])
    campos = partes[3:]
    checar('exatamente um campo de dados', len(campos) == 1, repr(campos))
    checar('formação "-1" (usa a atual)', campos[:1] == ['-1'], repr(campos[:1]))
    checar('resposta estável ao repetir', server.despacha(pedido) == resposta)

    # Um pedido de outra conta não pode vazar a formação da primeira.
    outra = db.criar_conta('formacao_outra', 'Temporary123!')['id']
    outro_uid = str(db.perfil(outra)['user_id'])
    if outro_uid != uid:
        alheia = server.despacha('8\r\nget_hard_copy_user_formation\r\n' + outro_uid)
        checar('recusa quando o user_id não é da sessão',
               ' -1' not in alheia or alheia.split()[2] != '0',
               alheia[:100])

    # Windows não deixa apagar o arquivo com a conexão aberta: fecha antes de
    # o TemporaryDirectory limpar a pasta.
    try:
        db._conn.close()
    except Exception:
        pass

if falhas:
    print('\nHARD_COPY_FORMATION_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nHARD_COPY_FORMATION_PASSED status 0 + um campo user_formation=-1')
