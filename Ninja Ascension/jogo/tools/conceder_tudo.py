"""Concede a conta atual TODOS os personagens (7 estrelas) e muitos itens.

Decisoes (confirmadas com o usuario):
  * 109 personagens UNICOS, nao os 353 moldes: a tabela ship_mould repete o
    mesmo personagem em varias formas (Naruto aparece em 13,73,115,157,199,241).
    Ficamos com o molde que tem progressao propria (col79 != -1), que e a
    forma jogavel.
  * Personagem DIRETO, nao fragmento: gravamos em local_synthesized, a mesma
    tabela que o sistema de sintese usa, entao o personagem entra como
    possuido e sobrevive ao relogin.
  * 7 estrelas: rank 21 em local_ship_rank. getHeroStars
    (EnvironmentDatas.lua:5792) converte 21 -> 3 estrelas, tier 7.

Uso:
    python tools/conceder_tudo.py            # mostra o que faria
    python tools/conceder_tudo.py --aplicar  # grava

Faz backup do banco antes de gravar.
"""
import shutil
import sqlite3
import sys
import time
from pathlib import Path

RAIZ = Path('E:/[code]/nk')
BANCO = RAIZ / 'port/dados/contas.sqlite3'
sys.path.insert(0, str(RAIZ / 'port/server'))
import dados_batalha as dados

APLICAR = '--aplicar' in sys.argv
RANK_MAX = 21          # 3 estrelas no tier 7 = o "7 estrelas" do jogo
NIVEL_CONTA_MAX = 500  # grade_silver_reward.txt vai de 1 a 500
NIVEL_PERSONAGEM_MAX = 100  # power_exp_param.txt: col3 vai de 1 a 100
QTD_ITEM = 9999        # "sem do": itens em quantidade alta
RECURSOS = {
    'gold': 999999999,
    'food': 999999999,
    'endurance': 9999,
    'honour': 999999999,
    'soul': 999999999,
    'jade': 999999999,
}

print('alvo:', BANCO)
if not BANCO.exists():
    sys.exit('banco nao encontrado')

c = sqlite3.connect(str(BANCO))
c.row_factory = sqlite3.Row
conta = c.execute('SELECT id, display_name FROM contas').fetchone()
if conta is None:
    sys.exit('nenhuma conta no banco')
print('conta:', conta['id'], conta['display_name'])
conta_id = conta['id']

# ---------------------------------------------------------------- personagens
moldes = dados.tabela('ship_mould.txt')


def nome_de(mould):
    """Nome do personagem, ou None se o acervo estiver incompleto.

    O acervo recuperado tem buracos: alguns ship_evo_mould apontam para um id
    de word_mould que nao existe. Esses personagens nao carregam (nem teriam
    nome), entao ficam de fora da concessao.
    """
    try:
        evo = dados.tabela('ship_evo_mould.txt')[moldes[str(mould)][71].split(',')[0]]
        palavra = dados.tabela('word_mould.txt').get(str(evo[1]))
        if not palavra or len(palavra) < 3 or not palavra[2]:
            return None
        return palavra[2].replace(' ', '_')
    except Exception:
        return None


# Um molde por personagem: tipo 1 (personagem real), com progressao (col79).
escolhido = {}
for chave, linha in moldes.items():
    if len(linha) < 79 or linha[3] != '1':
        continue
    if linha[78] == '-1':          # sem progressao = variante de evento/inimigo
        continue
    nome = nome_de(chave)
    if nome is None:               # acervo incompleto: personagem nao carrega
        continue
    atual = escolhido.get(nome)
    # prefere o de menor id (a forma base/recrutavel)
    if atual is None or int(chave) < int(atual):
        escolhido[nome] = chave

print('\npersonagens unicos com progressao: %d' % len(escolhido))
amostra = sorted(escolhido.items(), key=lambda kv: int(kv[1]))[:10]
print('  amostra:', ', '.join('%s(%s)' % (n, m) for n, m in amostra))

# ---------------------------------------------------------------- itens
# Materiais e consumiveis: tipo 0 nao sao personagens.
itens = []
for chave, linha in moldes.items():
    if len(linha) >= 79 and linha[3] == '0':
        itens.append(chave)
print('itens (moldes tipo 0): %d' % len(itens))

# ---------------------------------------------------------------- escrita
if not APLICAR:
    print('\n(modo simulacao) rode com --aplicar para gravar')
    print('  gravaria %d personagens e %d itens, rank %d'
          % (len(escolhido), len(itens), RANK_MAX))
    c.close()
    sys.exit(0)

backup = BANCO.with_suffix('.sqlite3.bak-%s' % time.strftime('%Y%m%d-%H%M%S'))
c.close()
shutil.copy2(str(BANCO), str(backup))
print('\nbackup:', backup.name)

c = sqlite3.connect(str(BANCO))
c.row_factory = sqlite3.Row
# As tabelas novas so existem depois que o servidor abre o banco (o schema
# real vive em contas.py). Garante aqui para o script funcionar sozinho.
c.executescript("""
CREATE TABLE IF NOT EXISTS local_ship_rank (
    conta_id INTEGER NOT NULL,
    ship_id INTEGER NOT NULL,
    rank_level INTEGER NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY(conta_id,ship_id)
);
CREATE TABLE IF NOT EXISTS local_campaign (
    conta_id INTEGER PRIMARY KEY, grade INTEGER NOT NULL DEFAULT 1,
    silver INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS local_resources (
    conta_id INTEGER PRIMARY KEY, gold INTEGER DEFAULT 0, food INTEGER DEFAULT 0,
    endurance INTEGER DEFAULT 0, honour INTEGER DEFAULT 0, soul INTEGER DEFAULT 0,
    jade INTEGER DEFAULT 0
);
""")
colunas = {r[1] for r in c.execute('PRAGMA table_info(local_ship_rank)')}
if 'level' not in colunas:
    c.execute('ALTER TABLE local_ship_rank ADD COLUMN level INTEGER NOT NULL DEFAULT 1')
c.commit()
try:
    # ship_ids estaveis e fora da faixa dos iniciais (conta*100000+1/13/35).
    base = conta_id * 100000
    criados = 0
    for nome, mould in escolhido.items():
        ship_id = base + 1000 + int(mould)
        c.execute('INSERT OR IGNORE INTO local_synthesized(conta_id,mould,ship_id)'
                  ' VALUES (?,?,?)', (conta_id, int(mould), ship_id))
        criados += 1

    # Rank e nivel de TODOS os personagens da conta (inclusive os iniciais e
    # os sintetizados): o pedido e "todos no maximo".
    todos = [r[0] for r in c.execute(
        'SELECT ship_id FROM local_synthesized WHERE conta_id=?', (conta_id,))]
    todos += [r[0] for r in c.execute(
        'SELECT ship_id FROM tutorial_recruit WHERE conta_id=?', (conta_id,))]
    # iniciais (Naruto/Sasuke/Sakura) existem mesmo sem linha no banco
    todos += [base + 1, base + 13, base + 35]
    for ship_id in set(todos):
        c.execute('INSERT OR REPLACE INTO local_ship_rank(conta_id,ship_id,rank_level,level)'
                  ' VALUES (?,?,?,?)',
                  (conta_id, int(ship_id), RANK_MAX, NIVEL_PERSONAGEM_MAX))
    print('  rank/nivel aplicado a %d personagens' % len(set(todos)))

    dados_itens = 0
    for mould in itens:
        instance_id = base + 500000 + int(mould)
        c.execute('INSERT OR REPLACE INTO local_inventory(conta_id,mould,instance_id,quantity)'
                  ' VALUES (?,?,?,?)', (conta_id, int(mould), instance_id, QTD_ITEM))
        dados_itens += 1

    # Nivel da conta (grade) e recursos.
    c.execute('INSERT OR REPLACE INTO local_campaign(conta_id,grade,silver)'
              ' VALUES (?,?,?)', (conta_id, NIVEL_CONTA_MAX, 999999999))
    campos = ','.join(RECURSOS)
    valores = ','.join('?' * len(RECURSOS))
    c.execute('INSERT OR REPLACE INTO local_resources(conta_id,%s) VALUES (?,%s)'
              % (campos, valores), (conta_id, *RECURSOS.values()))

    c.commit()
    # Remove personagens gravados por execucoes anteriores que nao carregam
    # (mould cujo nome nao existe no acervo): sem isso eles ficariam no login.
    validos = {int(m) for m in escolhido.values()}
    removidos = 0
    for mould, ship_id in c.execute(
            'SELECT mould, ship_id FROM local_synthesized WHERE conta_id=?',
            (conta_id,)).fetchall():
        if int(mould) not in validos:
            c.execute('DELETE FROM local_synthesized WHERE conta_id=? AND mould=?',
                      (conta_id, mould))
            c.execute('DELETE FROM local_ship_rank WHERE conta_id=? AND ship_id=?',
                      (conta_id, ship_id))
            removidos += 1
    if removidos:
        c.commit()
        print('  removidos %d personagens sem dados no acervo' % removidos)

    print('\ngravado:')
    print('  personagens : %d (rank %d, nivel %d)'
          % (criados, RANK_MAX, NIVEL_PERSONAGEM_MAX))
    print('  itens       : %d (x%d cada)' % (dados_itens, QTD_ITEM))
    print('  nivel conta : %d' % NIVEL_CONTA_MAX)
    print('  recursos    : %s' % RECURSOS)
    print('  total posse : %d registros' % c.execute(
        'SELECT COUNT(*) FROM local_synthesized WHERE conta_id=?', (conta_id,)).fetchone()[0])
except Exception:
    c.rollback()
    raise
finally:
    c.close()

print('\npronto. Reabra o jogo (ou reloge) para ver os personagens.')
