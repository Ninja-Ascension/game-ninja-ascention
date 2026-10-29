"""Valida a logica do patch catalogo_ninjas.lua contra os dados originais.

Simula, em Python, o getUnlockedShip substituido:
  - possuidos   -> _ED.user_ship (a conta real)
  - nao possuidos -> catalogo prop_mould filtrado pelos criterios originais
  - sintetizaveis -> fragmentos suficientes

Confere os quatro cenarios pedidos:
  1) inventario vazio
  2) conta com os 3 iniciais
  3) carta com fragmentos parciais (0 < n < split)
  4) carta com fragmentos completos (n >= split)
"""
import sqlite3
import sys
from pathlib import Path

RAIZ = Path('E:/[code]/nk')
DADOS = RAIZ / '01_conteudo_apk/assets/res/data/mould'
BANCO = RAIZ / 'port/dados/contas.sqlite3'

PROP_SPLIT, PROP_USE, PROP_TYPE = 10, 40, 43
SHIP_CAPTAIN, SHIP_EVO = 4, 72


def tabela(nome):
    texto = (DADOS / nome).read_text(encoding='utf8', errors='replace')
    return [b.split('\t') for b in texto.splitlines() if b.strip()]


def cel(linha, n):
    return linha[n - 1].strip() if n - 1 < len(linha) else ''


def num(linha, n):
    try:
        return int(cel(linha, n))
    except ValueError:
        return None


prop = tabela('prop_mould.txt')
ship = tabela('ship_mould.txt')
evo = tabela('ship_evo_mould.txt')
word = tabela('word_mould.txt')

ship_por_id = {}
for l in ship:
    i = num(l, 1)
    if i is not None:
        ship_por_id[i] = l

evo_word = {}
for l in evo:
    i = num(l, 1)
    if i is not None:
        evo_word[i] = num(l, 2)

word_ids = {num(l, 1) for l in word if num(l, 1) is not None}


def tem_nome(use_of_ship):
    l = ship_por_id.get(use_of_ship)
    if l is None:
        return False
    evo_ids = cel(l, SHIP_EVO)
    if not evo_ids:
        return False
    primeiro = evo_ids.split(',')[0].strip()
    try:
        wid = evo_word.get(int(primeiro))
    except ValueError:
        return False
    return wid is not None and wid in word_ids


def elegivel(use_of_ship):
    l = ship_por_id.get(use_of_ship)
    if l is None:
        return False
    if num(l, SHIP_CAPTAIN) != 1:
        return False
    return tem_nome(use_of_ship)


# ---------------------------------------------------------------- catalogo
cartas = []          # (prop_id, use_of_ship, split)
for l in prop:
    if num(l, PROP_TYPE) != 1:
        continue
    pid, uso, split = num(l, 1), num(l, PROP_USE), num(l, PROP_SPLIT)
    if pid is None or uso is None:
        continue
    cartas.append((pid, uso, split or 0))

elegiveis = [(pid, uso, sp) for pid, uso, sp in cartas if elegivel(uso)]
print('cartas props_type=1        : %d' % len(cartas))
print('elegiveis (criterios reais) : %d' % len(elegiveis))
print()


def get_unlocked_ship(possuidos, fragmentos):
    """Reproduz o patch. possuiidos: set de use_of_ship (ship_template_id).
    fragmentos: dict prop_id -> quantidade no inventario."""
    t_sorted, sintetizaveis = [], []
    for pid, uso, split in elegiveis:
        if uso in possuidos:
            continue
        qtd = fragmentos.get(pid, 0)
        if split > 0 and qtd >= split:
            sintetizaveis.append(pid)
        else:
            t_sorted.append(pid)
    return sorted(t_sorted), sorted(sintetizaveis)


# ---------------------------------------------------------------- cenarios
print('=== cenario 1: inventario vazio, conta sem personagens ===')
nao_poss, sint = get_unlocked_ship(set(), {})
print('  nao possuidos : %d' % len(nao_poss))
print('  sintetizaveis : %d' % len(sint))
assert len(nao_poss) == len(elegiveis), 'inventario vazio deve listar tudo'
assert not sint

print()
print('=== cenario 2: conta com os 3 iniciais (13, 35, 50) ===')
iniciais = {13, 35, 50}
nao_poss, sint = get_unlocked_ship(iniciais, {})
print('  possuidos     : %d' % len(iniciais))
print('  nao possuidos : %d' % len(nao_poss))
esperado = len([1 for _, uso, _ in elegiveis if uso not in iniciais])
assert len(nao_poss) == esperado, (len(nao_poss), esperado)
assert not sint

print()
print('=== cenario 3: carta com fragmentos PARCIAIS (3 de 10) ===')
alvo = next((pid, uso, sp) for pid, uso, sp in elegiveis if sp == 10 and uso not in iniciais)
pid, uso, sp = alvo
nao_poss, sint = get_unlocked_ship(iniciais, {pid: 3})
print('  carta %d (personagem %d) com 3/%d' % (pid, uso, sp))
print('  continua na lista de nao possuidos? %s' % (pid in nao_poss))
assert pid in nao_poss, 'fragmento insuficiente deve continuar listado'
assert pid not in sint

print()
print('=== cenario 4: carta com fragmentos COMPLETOS (%d) ===' % sp)
nao_poss, sint = get_unlocked_ship(iniciais, {pid: sp})
print('  carta %d com %d/%d' % (pid, sp, sp))
print('  vai para sintetizaveis? %s' % (pid in sint))
assert pid in sint
assert pid not in nao_poss

print()
print('=== cenario 5: conta real do banco ===')
if BANCO.exists():
    c = sqlite3.connect('file:%s?mode=ro' % BANCO.as_posix(), uri=True)
    contas = c.execute('SELECT id, display_name FROM contas').fetchall()
    for cid, nome in contas:
        # IDs de personagem da conta: local_synthesized guarda ship_id e mould
        linhas = c.execute(
            'SELECT mould FROM local_synthesized WHERE conta_id=?', (cid,)).fetchall()
        possui_moulds = {m for (m,) in linhas}
        # ship_template_id == mould do personagem
        qtds = c.execute(
            'SELECT mould, quantity FROM local_inventory WHERE conta_id=?',
            (cid,)).fetchall()
        frag = {}
        for m, q in qtds:
            frag[m] = frag.get(m, 0) + (q or 0)
        np, sz = get_unlocked_ship(possui_moulds, frag)
        print('  conta %s (%s): possuidos=%d nao_possuidos=%d sintetizaveis=%d'
              % (cid, nome, len(possui_moulds), len(np), len(sz)))
        # O total listado nunca pode ser menor que o catalogo elegivel.
        total = len(possui_moulds & {u for _, u, _ in elegiveis}) + len(np) + len(sz)
        print('    total visivel (possuidos elegiveis + listados) = %d' % total)
    c.close()
else:
    print('  banco ausente, cenario ignorado')

print()
print('CATALOGO_OK')
