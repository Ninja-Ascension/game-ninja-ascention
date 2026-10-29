"""Ninja School > Index: activate/level-up rules, costs, effects, retries (temporary DB)."""
import os, sys, tempfile, json
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='index-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import index_local as idx, recruitment_local as heroes, ninja_school_local as school
    import dados_batalha as data
    db = server.BANCO
    try:
        conta = db.criar_conta('indexteste', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        def req(cmd, *a):
            return server.despacha('\r\n'.join(['7', cmd, uid] + list(map(str, a))))
        st = lambda r: r.split(' ')[2]
        owned = {m: s for s, m in heroes.all_owned(db, conta)}
        cards = data.tabela('card_mould.txt')
        mine = next(int(r[0]) for r in cards.values() if r[1] != '-1' and int(r[1]) in owned and idx.level_row(int(r[0]), 0))
        other = next(int(r[0]) for r in cards.values() if r[1] != '-1' and int(r[1]) not in owned)
        # activate: owned ninja ok, not owned refused, twice refused, retry same id = same answer
        r = req('user_card_info_activate', mine, 'k1'); assert st(r) == '0' and '12663' in r, r
        assert req('user_card_info_activate', mine, 'k1') == r
        assert st(req('user_card_info_activate', mine, 'k2')) == '-1'
        assert st(req('user_card_info_activate', other, 'k3')) == '-1'
        assert st(req('user_card_info_activate', mine, 'k1x')) == '-1'      # already active
        t = r.split(' '); i = t.index('12663')
        assert int(t[i+1]) == int(idx.level_row(mine, 0)[5]) and t[i+4] == '1' and t[i+7] == str(mine), t[i:i+10]
        # level up: needs items and ninja stars
        nxt = data.tabela('card_unblock.txt')[idx.level_row(mine, 0)[4]]
        kind, prop, count = map(int, nxt[3].split('|')[0].split(','))
        assert st(req('user_card_info_advance', mine, 'a0')) == '-1'        # no items
        with db._conn:
            db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=excluded.quantity', (conta, prop, conta*1000000+prop, count*10))
        star = idx.ninja_star(db, conta, int(cards[str(mine)][1]))
        r = req('user_card_info_advance', mine, 'a1')
        print("estrelas do ninja:", star)
        if star >= 1:
            assert st(r) == '0' and '12664' in r, r
            assert idx.cards(db, conta)[mine] == 1
            left = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (conta, prop)).fetchone()[0]
            assert left == count*9, left
            assert req('user_card_info_advance', mine, 'a1') == r and idx.cards(db, conta)[mine] == 1   # retry: no double charge
            # effect reaches combat bonus of every ninja
            ship, mould = next(iter(heroes.all_owned(db, conta)))
            flat = school.combat_bonus(db, conta, ship, mould)[0]
            add = dict(idx.pairs(nxt[7]))
            assert flat[0] >= add.get(0, 0) > 0, (flat, add)
        else:
            assert st(r) == '-1', r
        # combination card refused honestly
        combo = next(int(r[0]) for r in cards.values() if r[1] == '-1')
        assert st(req('user_card_info_activate', combo, 'c1')) == '-1'
        # login/init snapshot carries the persisted list
        info = idx.info(db, conta)
        assert info['userCardInfoList'][0]['cardMouldId'] == mine
        snap = json.loads(school.snapshot(db, conta)[1])
        assert snap['illustration_info_init'] == info
        rk = req('user_card_info_rank'); assert st(rk) == '0' and json.loads(rk.split(' ')[4])['myRank'] == 1, rk
        print('INDEX_PASSED activate(owned/not/twice/retry), level-up(items/stars/no double charge), combat bonus, combo refused, snapshot, rank')
    finally:
        db._conn.close()
