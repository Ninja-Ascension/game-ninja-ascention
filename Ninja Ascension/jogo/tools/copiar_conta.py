"""Adiciona a uma ou mais contas tudo o que uma conta de origem possui.

Uso:
    python tools/copiar_conta.py ORIGEM DESTINO [DESTINO...]            (simulacao)
    python tools/copiar_conta.py ORIGEM DESTINO [DESTINO...] --aplicar  (grava)

ORIGEM/DESTINO = nome do personagem (perfis.user_name) ou id da conta.

Regras (nada da conta de destino e apagado):
  - quantidades somam: itens, ouro/energia/resistencia/honra/alma/jade, prata,
    pontos de habilidade, pontos de talento, carteira especial;
  - progresso fica com o maior: nivel do jogador, estrelas das fases,
    nivel/qualidade/rank/EXP de cada ninja, nivel de cada talento;
  - ninjas e equipamentos que o destino nao tem sao criados com os IDs do
    destino (IDs deste servidor sao derivados do numero da conta);
  - a formacao so e copiada se o destino ainda nao montou a sua;
  - nao copia: recibos de pedidos, lojas/missoes do dia, perfil, tutorial.
Antes de gravar faz backup com a API de backup do SQLite. Cada par
origem->destino so pode ser aplicado uma vez (tabela local_account_copy).
Com o servidor ligado, os jogadores afetados devem sair e entrar de novo.
"""
import json, os, sqlite3, sys, time
from pathlib import Path

BANCO = Path(os.environ.get('NR_ACCOUNTS_DIR') or Path(__file__).resolve().parents[1] / 'port' / 'dados') / 'contas.sqlite3'
NINJA_BASE = 1000000000


def conta(c, chave):
    row = c.execute('SELECT conta_id FROM perfis WHERE lower(user_name)=lower(?)', (chave,)).fetchone()
    if row is None and chave.isdigit():
        row = c.execute('SELECT id FROM contas WHERE id=?', (int(chave),)).fetchone()
    if row is None:
        raise SystemExit('conta nao encontrada: %s' % chave)
    return row[0]


def ninja(ship, origem, destino):
    base = ship - NINJA_BASE if ship >= NINJA_BASE else ship
    if base // 100000 != origem:
        raise ValueError('ninja %s nao pertence a conta %s' % (ship, origem))
    return ship + (destino - origem) * 100000


def item(instance, origem, destino):
    if instance // 1000000 != origem:
        raise ValueError('item %s nao pertence a conta %s' % (instance, origem))
    return instance + (destino - origem) * 1000000


def copiar(c, o, d, log):
    def todos(sql):
        return c.execute(sql, (o,)).fetchall()

    def um(sql, *args):
        return c.execute(sql, args).fetchone()

    # itens
    for mould, inst, qtd in todos('SELECT mould,instance_id,quantity FROM local_inventory WHERE conta_id=?'):
        c.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                  (d, mould, item(inst, o, d), qtd))
    log('itens', len(todos('SELECT 1 FROM local_inventory WHERE conta_id=?')))

    # recursos
    r = um('SELECT gold,food,endurance,honour,soul,jade FROM local_resources WHERE conta_id=?', o)
    if r:
        c.execute('INSERT OR IGNORE INTO local_resources(conta_id,food,endurance) VALUES (?,60,150)', (d,))
        c.execute('UPDATE local_resources SET gold=gold+?,food=food+?,endurance=endurance+?,honour=honour+?,soul=soul+?,jade=jade+? WHERE conta_id=?', (*r, d))
        log('recursos (ouro,energia,resistencia,honra,alma,jade) +', r)

    # nivel do jogador e prata
    r = um('SELECT grade,silver FROM local_campaign WHERE conta_id=?', o)
    if r:
        c.execute('INSERT INTO local_campaign(conta_id,grade,silver) VALUES (?,?,?) ON CONFLICT(conta_id) DO UPDATE SET grade=max(grade,excluded.grade),silver=silver+excluded.silver', (d, *r))
        log('nivel', r[0], 'prata +', r[1])

    for tabela, coluna in (('local_hero_skill_points', 'points'),):
        r = um('SELECT %s FROM %s WHERE conta_id=?' % (coluna, tabela), o)
        if r:
            c.execute('INSERT INTO %s(conta_id,%s) VALUES (?,?) ON CONFLICT(conta_id) DO UPDATE SET %s=%s+excluded.%s' % (tabela, coluna, coluna, coluna, coluna), (d, r[0]))
            log('pontos de habilidade +', r[0])
    r = um('SELECT trial,clan FROM local_special_wallet WHERE conta_id=?', o)
    if r:
        c.execute('INSERT INTO local_special_wallet VALUES (?,?,?) ON CONFLICT(conta_id) DO UPDATE SET trial=trial+excluded.trial,clan=clan+excluded.clan', (d, *r))

    # fases
    for scene, npc, stars in todos('SELECT scene,npc,stars FROM local_pve_clears WHERE conta_id=?'):
        c.execute('INSERT INTO local_pve_clears VALUES (?,?,?,?) ON CONFLICT(conta_id,scene,npc) DO UPDATE SET stars=max(stars,excluded.stars)', (d, scene, npc, stars))
    log('fases', len(todos('SELECT 1 FROM local_pve_clears WHERE conta_id=?')))

    # ninjas
    for mould, ship in todos('SELECT mould,ship_id FROM local_synthesized WHERE conta_id=?'):
        c.execute('INSERT OR IGNORE INTO local_synthesized VALUES (?,?,?)', (d, mould, ninja(ship, o, d)))
    r = um('SELECT ship_id,mould FROM tutorial_recruit WHERE conta_id=?', o)
    if r:
        c.execute('INSERT OR IGNORE INTO tutorial_recruit VALUES (?,?,?)', (d, ninja(r[0], o, d), r[1]))
    log('ninjas', len(todos('SELECT 1 FROM local_synthesized WHERE conta_id=?')))

    for ship, exp in todos('SELECT ship_id,experience FROM local_hero_exp WHERE conta_id=?'):
        c.execute('INSERT INTO local_hero_exp VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET experience=max(experience,excluded.experience)', (d, ninja(ship, o, d), exp))
    for ship, q in todos('SELECT ship_id,quality FROM local_hero_quality WHERE conta_id=?'):
        c.execute('INSERT INTO local_hero_quality VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET quality=max(quality,excluded.quality)', (d, ninja(ship, o, d), q))
    for ship, rank, level in todos('SELECT ship_id,rank_level,level FROM local_ship_rank WHERE conta_id=?'):
        alvo = ninja(ship, o, d)
        atual = um('SELECT rank_level,level FROM local_ship_rank WHERE conta_id=? AND ship_id=?', d, alvo)
        if atual is None or (rank, level) > tuple(atual):
            c.execute('INSERT OR REPLACE INTO local_ship_rank VALUES (?,?,?,?)', (d, alvo, rank, level))
    for ship, state in todos('SELECT ship_id,state FROM local_hero_development WHERE conta_id=?'):
        alvo = ninja(ship, o, d)
        atual = um('SELECT state FROM local_hero_development WHERE conta_id=? AND ship_id=?', d, alvo)
        if atual is None or json.loads(atual[0]).get('star', 0) < json.loads(state).get('star', 0):
            c.execute('INSERT OR REPLACE INTO local_hero_development VALUES (?,?,?)', (d, alvo, state))
    for ship, state in todos('SELECT ship_id,state FROM local_hero_gates WHERE conta_id=?'):
        c.execute('INSERT OR IGNORE INTO local_hero_gates VALUES (?,?,?)', (d, ninja(ship, o, d), state))

    # formacao: so se o destino ainda nao tem
    if um('SELECT 1 FROM local_formation_slots WHERE conta_id=?', d) is None:
        for pos, ship in todos('SELECT position,ship_id FROM local_formation_slots WHERE conta_id=?'):
            c.execute('INSERT INTO local_formation_slots VALUES (?,?,?)', (d, pos, ninja(ship, o, d) if ship else 0))
        log('formacao copiada')
    else:
        log('formacao do destino mantida')

    # equipamentos
    eq = todos('SELECT mould FROM local_shop_equipment WHERE conta_id=?')
    for (mould,) in eq:
        c.execute('INSERT INTO local_shop_equipment(conta_id,mould) VALUES (?,?)', (d, mould))
    log('equipamentos', len(eq))

    # escola ninja
    r = um('SELECT state FROM local_ninja_school WHERE conta_id=?', o)
    if r:
        src = json.loads(r[0])
        atual = um('SELECT state FROM local_ninja_school WHERE conta_id=?', d)
        dst = json.loads(atual[0]) if atual else {}
        tal = dst.setdefault('talents', {})
        for k, v in src.get('talents', {}).items():
            tal[k] = max(int(tal.get(k, 0)), int(v))
        dst['talentPoints'] = int(dst.get('talentPoints', 0)) + int(src.get('talentPoints', 0))
        for k, v in src.items():
            dst.setdefault(k, v)
        c.execute('INSERT OR REPLACE INTO local_ninja_school VALUES (?,?)', (d, json.dumps(dst)))
        log('escola ninja: talentos', tal, 'pontos', dst['talentPoints'])


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    aplicar = '--aplicar' in sys.argv
    if len(args) < 2:
        raise SystemExit(__doc__)
    c = sqlite3.connect(BANCO, timeout=30, isolation_level=None)
    c.execute('PRAGMA busy_timeout=30000')
    o = conta(c, args[0])
    destinos = [conta(c, a) for a in args[1:]]
    if o in destinos:
        raise SystemExit('origem e destino iguais')
    if aplicar:
        pasta = BANCO.parent / 'backups'
        pasta.mkdir(exist_ok=True)
        alvo = pasta / ('contas-antes-copia-%s.sqlite3' % time.strftime('%Y%m%d-%H%M%S'))
        b = sqlite3.connect(alvo)
        with b:
            c.backup(b)
        ok = b.execute('PRAGMA integrity_check').fetchone()[0]
        b.close()
        if ok != 'ok':
            raise SystemExit('backup com problema: %s' % ok)
        print('backup:', alvo)
    c.execute('CREATE TABLE IF NOT EXISTS local_account_copy (origem INTEGER, destino INTEGER, feito_em TEXT, PRIMARY KEY(origem,destino))')
    c.execute('BEGIN IMMEDIATE')
    try:
        for d in destinos:
            nome = c.execute('SELECT user_name FROM perfis WHERE conta_id=?', (d,)).fetchone()[0]
            if c.execute('SELECT feito_em FROM local_account_copy WHERE origem=? AND destino=?', (o, d)).fetchone():
                raise SystemExit('copia %s -> %s ja foi aplicada antes; nada foi alterado' % (o, d))
            print('== conta %s (%s)' % (d, nome))
            copiar(c, o, d, lambda *m: print('  ', *m))
            c.execute('INSERT INTO local_account_copy VALUES (?,?,?)', (o, d, time.strftime('%Y-%m-%d %H:%M:%S')))
        if c.execute('PRAGMA foreign_key_check').fetchall():
            raise RuntimeError('chave estrangeira invalida')
        if aplicar:
            c.execute('COMMIT')
            print('APLICADO. Os jogadores devem sair e entrar de novo no jogo.')
        else:
            c.execute('ROLLBACK')
            print('SIMULACAO (nada gravado). Use --aplicar para gravar.')
    except BaseException:
        if c.in_transaction:
            c.execute('ROLLBACK')
        raise


if __name__ == '__main__':
    main()
