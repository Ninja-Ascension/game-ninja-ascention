"""power_swallow (parser 194) precisa preencher _ED._add_enger_info.

O crash real no log:
    CRASH DO CLIENTE: Home.lua:2136: utils.lua:9: attempt to index local 'str'
    (a nil value)   -- zstring.split(_ED._add_enger_info, "|")

`_add_enger_info` só existe depois do parser 194 (ProtocolParserCopy.lua:7142),
que responde ao power_swallow. Sem ele a Home quebra em laço — foi o travamento
logo após resgatar a Sakura no recrutamento.

Contrato (parser 194 lê 3 tokens, nesta ordem):
    [1] _add_enger        (numérico)
    [2] _add_enger_time   (numérico)
    [3] _add_enger_info   "estado,horário|estado,horário|..." com 4 períodos
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


with tempfile.TemporaryDirectory(prefix='energia-test-', dir=str(raiz / 'build')) as pasta:
    os.environ['NR_ACCOUNTS_DIR'] = pasta
    server = importlib.import_module('local_server')
    db = server.BANCO
    conta = db.criar_conta('energia_test', 'Temporary123!')['id']
    server._sessao_conexao['token'] = db.abrir_sessao(conta)
    uid = str(db.perfil(conta)['user_id'])

    # Pedido real: seq / cmd / user_id / param_list (ProtocolCommanderCopy:2565).
    resposta = server.despacha('9\r\npower_swallow\r\n%s\r\n' % uid)
    print('    resposta: %r' % resposta)

    partes = resposta.split()
    checar('status 0', len(partes) > 2 and partes[2] == '0', resposta[:90])
    checar('nao e mais pendencia', 'nao_implementado' not in resposta)
    checar('envia o codigo do parser 194', partes[3] == '194' if len(partes) > 3 else False,
           repr(partes[3:4]))

    campos = partes[4:]
    checar('tres tokens (enger, time, info)', len(campos) == 3, repr(len(campos)))
    if len(campos) == 3:
        checar('_add_enger numerico', campos[0].lstrip('-').isdigit(), repr(campos[0]))
        checar('_add_enger_time numerico', campos[1].lstrip('-').isdigit(), repr(campos[1]))
        info = campos[2]
        # _add_enger_info nunca pode ser vazio/nil: e exatamente o que quebrva.
        checar('_add_enger_info nao vazio', info != '', repr(info))
        itens = info.split('|')
        checar('quatro periodos', len(itens) == 4, repr(itens))
        checar('cada periodo tem estado,hora', all(',' in i for i in itens), repr(itens))
        checar('estado 0 (nao resgatado)', all(i.split(',')[0] == '0' for i in itens), repr(itens))

    # draw_endurance_init: parser 199, dois tokens (remain_times, get_count).
    resposta = server.despacha('10\r\ndraw_endurance_init\r\n%s\r\n' % uid)
    print('    resposta: %r' % resposta)
    partes = resposta.split()
    checar('endurance: status 0', len(partes) > 2 and partes[2] == '0', resposta[:90])
    checar('endurance: nao e pendencia', 'nao_implementado' not in resposta)
    checar('endurance: parser 199', partes[3] == '199' if len(partes) > 3 else False, repr(partes[3:4]))
    checar('endurance: dois tokens', len(partes[4:]) == 2, repr(partes[4:]))

    try:
        db._conn.close()
    except Exception:
        pass

if falhas:
    print('\nENERGIA_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nENERGIA_PASSED power_swallow 194 preenche _add_enger_info (Home nao quebra)')
