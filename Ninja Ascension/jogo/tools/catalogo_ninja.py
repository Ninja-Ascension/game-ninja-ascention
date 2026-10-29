"""Mede o catalogo de ninjas elegiveis para a lista NINJA.

Reproduz EXATAMENTE o que HeroListView:getUnlockedShip() faz
(HeroListView.lua:1186-1211):

  for cada linha de prop_mould:
      se props_type == 1:                 -- carta de personagem
          se use_of_ship nao for um personagem possuido:
              se count >= split_or_merge_count -> beSynthesized
              senao                             -> nao possuido (lista)

Alem disso aplica os criterios de disponibilidade do projeto:
  - ship_mould precisa existir para use_of_ship
  - captain_type == 1 (personagem; descarta material e NPC/evento)
  - nome resolvivel em word_mould (senao o retrato/nome quebram)

Uso: python tools/catalogo_ninja.py [--detalhe]
"""
import sys
from pathlib import Path

RAIZ = Path('E:/[code]/nk')
DADOS = RAIZ / '01_conteudo_apk/assets/res/data/mould'

DETALHE = '--detalhe' in sys.argv


def tabela(nome):
    """Le uma .txt tab-separada como lista de listas (1-based como o Lua)."""
    texto = (DADOS / nome).read_text(encoding='utf8', errors='replace')
    linhas = []
    for bruta in texto.splitlines():
        if not bruta.strip():
            continue
        cels = bruta.split('\t')
        linhas.append(cels)
    return linhas


# LocalDatas.lua: id e a coluna 1; as demais sao 1-based no proprio arquivo.
# prop_mould: props_type=43, use_of_ship=40, split_or_merge_count=10
COL_PROP_TYPE = 43
COL_USE_OF_SHIP = 40
COL_SPLIT = 10

# ship_mould: captain_type=4, initial_rank_level=45, star=49,
# evolution_ids=72, word_id vem de ship_evo_mould
COL_CAPTAIN = 4
COL_RANK = 45
COL_STAR = 49
COL_EVO = 72


def col(linha, n):
    """Coluna n (1-based) de uma linha do txt, tolerante a faltas."""
    if n - 1 < len(linha):
        v = linha[n - 1].strip()
        return v
    return ''


def main():
    prop = tabela('prop_mould.txt')
    ship = tabela('ship_mould.txt')
    evo = tabela('ship_evo_mould.txt')
    word = tabela('word_mould.txt')

    ship_por_id = {}
    for linha in ship:
        try:
            ship_por_id[int(col(linha, 1))] = linha
        except ValueError:
            continue

    word_ids = set()
    for linha in word:
        try:
            word_ids.add(int(col(linha, 1)))
        except ValueError:
            continue

    def nome_existe(mould_id):
        """Resolve ship_mould.col72 -> ship_evo_mould -> word_mould, como o
        servidor faz em recruitment_local.one_ship_tokens."""
        linha = ship_por_id.get(mould_id)
        if linha is None:
            return False
        evo_ids = col(linha, COL_EVO)
        if not evo_ids:
            return False
        primeiro = evo_ids.split(',')[0].strip()
        for elinha in evo:
            if col(elinha, 1) == primeiro:
                wid = col(elinha, 2)
                try:
                    return int(wid) in word_ids
                except ValueError:
                    return False
        return False

    cartas = []
    for linha in prop:
        if col(linha, COL_PROP_TYPE) != '1':
            continue
        try:
            pid = int(col(linha, 1))
            uso = int(col(linha, COL_USE_OF_SHIP))
            split = int(col(linha, COL_SPLIT) or 0)
        except ValueError:
            continue
        cartas.append((pid, uso, split))

    print('cartas prop_mould com props_type=1: %d' % len(cartas))

    # Elegibilidade pela disponibilidade real do personagem.
    sem_ship, sem_nome, npc, ok = [], [], [], []
    for pid, uso, split in cartas:
        linha = ship_por_id.get(uso)
        if linha is None:
            sem_ship.append((pid, uso))
            continue
        if col(linha, COL_CAPTAIN) != '1':
            npc.append((pid, uso, col(linha, COL_CAPTAIN)))
            continue
        if not nome_existe(uso):
            sem_nome.append((pid, uso))
            continue
        ok.append((pid, uso, split, col(linha, COL_RANK), col(linha, COL_STAR)))

    print('  sem ship_mould correspondente : %d' % len(sem_ship))
    print('  captain_type != 1 (NPC/outro) : %d' % len(npc))
    print('  sem nome em word_mould        : %d' % len(sem_nome))
    print('  ELEGIVEIS                     : %d' % len(ok))

    unicos = {uso for _, uso, _, _, _ in ok}
    print('  personagens unicos (use_of_ship distintos): %d' % len(unicos))

    if DETALHE:
        print('\nprimeiros 15 elegiveis (prop_id, ship, split, rank, star):')
        for item in ok[:15]:
            print('  ', item)
        if sem_nome:
            print('\nsem nome (primeiros 10):', sem_nome[:10])


main()
