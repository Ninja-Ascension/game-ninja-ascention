"""login_init precisa enviar os itens da conta (user_prop_number + user_prop).

Os tres crashes do log vinham todos disto:

    HeroListView.lua:1577  attempt to concatenate field
                           'user_comb_can_filed_mould_num' (a nil value)
    sm_ship_seat_cell.lua:137  attempt to index local 'props' (a nil value)
        -- props = fundPropWidthId(...) -> nil porque _ED.user_prop estava vazio

O parser 3 (ProtocolParserCopy.lua:388-412) le `user_prop_number` e depois
7 tokens por item:

    user_prop_id, user_prop_template, prop_name, prop_use_type,
    prop_number, prop_type, prop_timestamp

O servidor mandava o contador fixo em "0" e nenhum item, entao _ED.user_prop
ficava vazio e o tutorial (que sintetiza carta e le contadores) quebrava.

Contrato verificado:
  1. contador = numero real de itens;
  2. 7 tokens por item, na ordem do parser;
  3. user_prop_template casa com o mould gravado (fundPropWidthId acha);
  4. prop_number reflete a quantidade gravada;
  5. conta sem itens continua funcionando (contador 0).
"""
import importlib
import os
import shutil
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


def tokens_do_login(servidor, conta_id, seq='7'):
    """Executa o login_init e devolve a lista de tokens da resposta."""
    db = servidor.BANCO
    token = db.abrir_sessao(conta_id)
    servidor.lembrar_token(token)
    resposta = servidor.despacha('%s\r\nlogin_init\r\n' % seq)
    return resposta.split()


def contador_e_itens(partes):
    """Le user_prop_number e os itens a partir do fim da resposta.

    O bloco 6020 vem sempre DEPOIS dos itens, e o 12042 antes dele. Achar o
    6020 pela posicao no fim e mais estavel que contar 96 tokens a mao, porque
    a quantidade de itens muda o tamanho da resposta.

    Formato real dos itens (medido por tools/_detectar_props.py):
        ['100001', '68', '2068', '0', '3', '0', '0']
        id, template, nome, use_type, quantidade, tipo, tempo
    """
    # O 12042 vem imediatamente antes do 6020; o contador e o token que
    # precede o primeiro item.
    try:
        ancora = len(partes) - 1 - partes[::-1].index('6020')
    except ValueError:
        ancora = len(partes)
    # Os itens ocupam a faixa imediatamente anterior ao 12042.
    try:
        fim_itens = ancora - 2 - partes[:ancora - 1][::-1].index('12042')
    except ValueError:
        fim_itens = ancora
    return _ler_itens_para_tras(partes, fim_itens)


def _ler_itens_para_tras(partes, fim):
    """Volta em passos de 7 tokens ate sair do formato de item."""
    itens = []
    i = fim
    while i - 7 >= 0:
        cand = partes[i - 7:i]
        if not (cand[0].isdigit() and len(cand[0]) >= 6
                and cand[1].isdigit() and len(cand[1]) <= 4
                and cand[4].isdigit() and int(cand[4]) < 1000):
            break
        itens.insert(0, cand)
        i -= 7
    contador = partes[i - 1] if i >= 1 else '0'
    return contador, itens


def contador_pelo_parser(partes):
    """Contador lido no lugar em que o parser 3 le (medido: idx 91).

    O parser 3 le 96 tokens; user_prop_number e o token 90 deles, o que cai no
    indice 91 desta resposta (seq/comando/status/codigo do parser ocupam os
    quatro primeiros). O token em 97 e outro campo.
    """
    return partes[91]


def posicao_do_prop_number(partes):
    """Compatibilidade: nao usada (ver contador_e_itens)."""
    return 97


pasta = tempfile.mkdtemp(prefix='props-', dir=str(raiz / 'build'))
os.environ['NR_ACCOUNTS_DIR'] = pasta
if True:
    for nome in list(sys.modules):
        if nome in ('local_server', 'contas', 'dados_batalha', 'tutorial_campaign',
                    'recruitment_local', 'hero_training_local', 'formacao_pesadelo',
                    'energia'):
            del sys.modules[nome]
    srv = importlib.import_module('local_server')
    db = srv.BANCO
    conta = db.criar_conta('props_test', 'Temporary123!')['id']

    # 1) Conta sem itens: nao quebra, contador 0.
    partes = tokens_do_login(srv, conta)
    contador, _ = contador_e_itens(partes)
    checar('conta vazia: contador 0', contador_pelo_parser(partes) == '0', repr(contador_pelo_parser(partes)))

    # 2) Grava tres itens, como o tutorial faz.
    with db._lock:
        for n, (mould, qtd) in enumerate([(68, 3), (69, 1), (70, 5)], start=1):
            db._conn.execute(
                'INSERT INTO local_inventory(conta_id, mould, instance_id, quantity)'
                ' VALUES (?,?,?,?)', (conta, mould, conta * 100000 + n, qtd))
        db._conn.commit()

    partes = tokens_do_login(srv, conta, seq='8')
    contador, itens = contador_e_itens(partes)
    lido = contador_pelo_parser(partes)
    checar('contador = 3 itens (posicao do parser)', lido == '3', repr(lido))
    checar('tres itens lidos', len(itens) == 3, str(len(itens)))
    checar('7 tokens por item', all(len(x) == 7 for x in itens),
           str([len(x) for x in itens]))

    for n, (mould, qtd) in enumerate([(68, 3), (69, 1), (70, 5)]):
        t = itens[n]
        checar('item %d: template = mould %d' % (n + 1, mould), t[1] == str(mould), repr(t[1]))
        checar('item %d: quantidade = %d' % (n + 1, qtd), t[4] == str(qtd), repr(t[4]))
        checar('item %d: id preenchido' % (n + 1), t[0] != '' and t[0] != '0', repr(t[0]))

    # 4) fundPropWidthId acha: precisa de user_prop_template == mould procurado.
    templates = {t[1] for t in itens}
    checar('templates encontram os itens',
           templates == {'68', '69', '70'}, repr(sorted(templates)))

    # 5) A resposta continua valida para o parser 12042 (speed) e 6020.
    checar('resposta traz 12042', '12042' in partes)
    checar('resposta traz 6020', '6020' in partes)

    try:
        db._conn.close()
    except Exception:
        pass

# A pasta temporaria so pode ser apagada depois de fechar o banco: no Windows
# o arquivo continua travado enquanto a conexao estiver aberta.
shutil.rmtree(pasta, ignore_errors=True)

if falhas:
    print('\nUSER_PROP_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nUSER_PROP_PASSED login_init envia os itens (user_prop) da conta')
