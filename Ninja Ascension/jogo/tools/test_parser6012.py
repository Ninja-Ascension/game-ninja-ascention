"""O parser 6012 le exatamente o que o servidor manda?

Parser (ProtocolParserCopyExx.lua:4-9):
    formation_type = npos(list)          -- 1 token
    for i = 2, 7: _ED.formetion[i]       -- 6 tokens
    => 7 tokens no total

Servidor (recruitment_local.formation_tokens):
    ['6012', '1', v1..v6, '188', '<lista>']
    o '6012' e o codigo do parser; sobram '1' + 6 vagas = 7 tokens.

Se a contagem nao casar, o cliente leria a vaga errada para cada ninja e a
formacao apareceria trocada — sintoma parecido com o bug da Sakura.
"""
import importlib
import os
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


with tempfile.TemporaryDirectory(prefix='parser6012-', dir=str(raiz / 'build')) as pasta:
    os.environ['NR_ACCOUNTS_DIR'] = pasta
    for nome in list(sys.modules):
        if nome in ('local_server', 'contas', 'tutorial_campaign',
                    'hero_training_local', 'recruitment_local'):
            del sys.modules[nome]
    srv = importlib.import_module('local_server')
    rec = importlib.import_module('recruitment_local')
    db = srv.BANCO
    conta = db.criar_conta('parser_teste', 'Temporary123!')['id']

    tokens = rec.formation_tokens(db, conta)
    print('    tokens: %s' % tokens)

    checar('primeiro token e o codigo do parser', tokens[0] == '6012', tokens[0])

    # O parser consome tudo depois do codigo: 1 tipo + 6 vagas.
    consumidos = tokens[1:]
    checar('7 tokens para o parser (tipo + 6 vagas)',
           len(consumidos) >= 7, 'tem %d, precisa 7' % len(consumidos))

    tipo = consumidos[0]
    vagas = consumidos[1:7]
    checar('tipo de formacao e "1"', tipo == '1', tipo)
    checar('seis vagas lidas', len(vagas) == 6, str(vagas))
    print('    o parser monta _ED.formetion = ["%s", %s]' % (tipo, ', '.join('"%s"' % v for v in vagas)))

    # Simula exatamente o laco do parser corrigido (2..7), comparando com cada
    # ship_id como o cliente faz. Vagas vazias valem "0" e nao coincidem com
    # nenhum ship_id real (todos >= 5800000), por isso nao geram falso positivo
    # — agrupar por valor daria [1,3,5] para o "0", o que nao acontece no jogo.
    formetion = {1: tipo}
    for i in range(2, 8):
        formetion[i] = vagas[i - 2]

    ships = {'Naruto': '100013', 'Sasuke': '100035', 'Sakura': '100001'}
    indices = {}
    for nome, ship_id in ships.items():
        posicao = ''
        for n in range(2, 8):
            if formetion[n] == ship_id:
                posicao = str(n - 1)
                break
        indices[nome] = posicao
    print('    formation_index atribuido: %s' % indices)

    checar('vaga 6 (i=7) e lida', formetion[7] != '', str(formetion[7]))
    checar('Sakura na 6a recebe index 6', indices['Sakura'] == '6', indices['Sakura'])
    checar('Naruto na 2a recebe index 2', indices['Naruto'] == '2', indices['Naruto'])
    checar('Sasuke na 4a recebe index 4', indices['Sasuke'] == '4', indices['Sasuke'])
    checar('nenhum ficou sem posicao', all(v != '' for v in indices.values()), str(indices))
    checar('indices distintos (bug antigo marcava todos "1")',
           len(set(indices.values())) == 3, str(sorted(indices.values())))

    db._conn.close()

if falhas:
    print('\nPARSER6012_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nPARSER6012_PASSED contagem e indices batem com o cliente')
