"""Passo 3: abrir o primeiro NPC do mapa (o lobo).

O que estava errado: `battle_field_init` mandava UM heroi ficticio
(_pos="1", _mouldId="0"). O parser 182 indexa por posicao
(ProtocolParserCopy.lua:6551) e usa _mouldId para carregar o modelo na cena;
com molde 0 o NPC nao abria.

O que este teste prova:
  * o parser 182 carrega os tres ninjas da formacao real;
  * cada um leva a posicao em que esta (2, 4, 6) e o molde verdadeiro;
  * nenhum heroi tem _mouldId "0";
  * formacao vazia => recusa com motivo, em vez de batalha falsa.
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


pasta = tempfile.mkdtemp(prefix='lobo-', dir=str(raiz / 'build'))
os.environ['NR_ACCOUNTS_DIR'] = pasta
os.environ.pop('NR_ENABLE_TUTORIAL', None)
for nome in list(sys.modules):
    if nome in ('local_server', 'contas', 'tutorial_campaign', 'dados_batalha',
                'hero_training_local', 'recruitment_local', 'gameplay_mode'):
        del sys.modules[nome]
srv = importlib.import_module('local_server')
rec = importlib.import_module('recruitment_local')
db = srv.BANCO
conta = db.criar_conta('lobo_teste', 'Temporary123!')['id']
perfil = db.perfil(conta)
usuario = str(perfil['user_id'])
nome = perfil['user_name']

herois = rec.herois_da_formacao(db, conta, usuario, nome)
print('    herois: %s' % [(h['_pos'], h['_mouldId']) for h in herois])
checar('tres herois na formacao', len(herois) == 3, str(len(herois)))
checar('posicoes 2, 4 e 6',
       [h['_pos'] for h in herois] == ['2', '4', '6'], str([h['_pos'] for h in herois]))
checar('moldes reais 13, 35, 50',
       [h['_mouldId'] for h in herois] == ['13', '35', '50'], str([h['_mouldId'] for h in herois]))
checar('nenhum molde zero (causa do NPC nao abrir)',
       all(h['_mouldId'] not in ('0', '') for h in herois), '')
checar('nenhum id zero', all(h['_id'] not in ('0', '') for h in herois), '')
checar('nomes preenchidos', all(h['_name'] for h in herois), '')

# Parser 182 completo com o NPC 1 (primeiro do acervo).
toks = srv._dados_batalha.montar_parser_182('1', '0', herois, nome, 10000)
checar('parser 182 montado', toks is not None and len(toks) > 0,
       '%d tokens' % (len(toks) if toks else 0))
if toks:
    # Layout: 0 tipo, 1 objId, 2 nivel, 3 total, 4/5 prioridades,
    # 6/7 nomes, 8/9 cabeças, 10 _hero_number, depois 15 campos por heroi.
    checar('_hero_number = 3', toks[10] == '3', toks[10])
    campo_mould = 10  # indice do molde dentro do bloco de 15 campos
    posicoes, moldes = [], []
    base = 11
    for i in range(3):
        bloco = toks[base + i * 15: base + (i + 1) * 15]
        posicoes.append(bloco[1])          # _pos
        moldes.append(bloco[9])            # _mouldId
    print('    parser: posicoes=%s moldes=%s' % (posicoes, moldes))
    checar('parser: posicoes 2,4,6', posicoes == ['2', '4', '6'], str(posicoes))
    checar('parser: moldes 13,35,50', moldes == ['13', '35', '50'], str(moldes))

# Formacao VAZIA: o caminho real do cliente e retirar um a um (posicao 0),
# que grava '0' nas vagas — nao DELETE. Com as seis vagas em 0, o servidor
# deve recusar a batalha com motivo, em vez de inventar combatente.
for ship in ('100013', '100035', '100001'):
    srv.lembrar_token(db.abrir_sessao(conta))
    srv.despacha('78\r\nformation_change\r\n%s\r\n0\r\n1\r\n' % ship)
vazio = rec.herois_da_formacao(db, conta, usuario, nome)
checar('formacao vazia devolve lista vazia', vazio == [],
       str([(h['_pos'], h['_mouldId']) for h in vazio]))

# E o login NAO recoloca o que o jogador tirou (exigencia do documento).
slots_depois = rec.formation_tokens(db, conta)[2:8]
checar('login nao recoloca ninja removido', slots_depois == ['0'] * 6, str(slots_depois))

try:
    db._conn.close()
except Exception:
    pass
shutil.rmtree(pasta, ignore_errors=True)

if falhas:
    print('\nLOBO_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nLOBO_PASSED parser 182 leva a formacao real (3 ninjas, moldes certos)')
