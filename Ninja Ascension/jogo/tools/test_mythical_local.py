"""Ninja School > Tailed Beasts: activate, stars, forge/stage/reset, links, skill, combat, login (temporary DB)."""
import os, sys, tempfile, json
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='bestas-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import mythical_local as my, ninja_school_local as school, recruitment_local as heroes
    db = server.BANCO
    try:
        conta = db.criar_conta('bestateste', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        n = [0]
        def req(cmd, *a, key=None):
            n[0] += 1
            return server.despacha('\r\n'.join(['7', cmd, uid] + list(map(str, a)) + [key or 'k%d' % n[0]]))
        st = lambda r: r.split(' ')[2]
        GYUKI, KURAMA = 3, 4
        frag = {b: my.triples(my.star_row(b, 1)[5])[0][1] for b in (1, 2, GYUKI, KURAMA)}
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (conta,))
            db._conn.execute('UPDATE local_resources SET gold=1000 WHERE conta_id=?', (conta,))
        assert st(req('magical_animals_activate', KURAMA)) == '-1'               # no fragments
        with db._conn:
            for b, p in frag.items(): my.give_item(db, conta, p, 100000)
            for _, p, _ in my.triples(my.cfg(211)): my.give_item(db, conta, p, 100000)
        r = req('magical_animals_activate', KURAMA, key='a'); assert st(r) == '0' and '12676' in r, r
        assert req('magical_animals_activate', KURAMA, key='a') == r and my.beasts(db, conta)[KURAMA]['star'] == 1
        assert st(req('magical_animals_activate', KURAMA)) == '-1'               # twice
        while my.star_row(KURAMA, my.beasts(db, conta)[KURAMA]['star'] + 1):
            assert st(req('magical_animals_advance_star', KURAMA)) == '0'
        assert st(req('magical_animals_advance_star', KURAMA)) == '-1'           # max star
        # APK getAnimalsUpStarPropertyById sums every reached star.
        # Kurama's five increments total these values, before any forging.
        cumulative = {}
        for kind, amount in my.bonus(db, conta):
            cumulative[kind] = cumulative.get(kind, 0) + amount
        assert cumulative == {0: 518397.0, 1: 77756.0, 2: 25917.0}, cumulative
        # forge: one-key fills one stone, all three -> next stage
        for i in range(3): assert st(req('magical_animals_forging', KURAMA, i, 2)) == '0'
        s = my.beasts(db, conta)[KURAMA]; assert s['stage'] == 1 and s['stones'] == [0, 0, 0], s
        assert st(req('magical_animals_forging', KURAMA, 0, 0)) == '0' and my.beasts(db, conta)[KURAMA]['stones'][0] == 1
        r = req('magical_animals_steps_rebirth', KURAMA); assert st(r) == '0' and '171' in r, r
        assert my.beasts(db, conta)[KURAMA]['stage'] == 0
        # link between beasts 1 and 2 needs both
        assert st(req('magical_animals_activate', 1)) == '0'
        assert my.link_status(db, conta, 1).split(',')[0] == '0'
        assert st(req('magical_animals_activate', 2)) == '0'
        assert my.link_status(db, conta, 1).split(',')[0] == '1'
        assert st(req('magical_animals_relevant_active', 1, 0)) == '0'
        assert my.link_status(db, conta, 1).split(',')[0] == '2' and my.link_status(db, conta, 2).split(',')[0] == '2'
        # skill equip and release method
        assert st(req('magical_animals_set_skill', '%d,%d' % (KURAMA, 1))) == '0'
        assert st(req('magical_animals_set_skill', '99')) == '-1'
        assert st(req('magical_animals_set_skill_release_method', 1)) == '0' and my.skill(db, conta) == {'equippedMAMould': '4,1,-1', 'skillReleaseMethod': 1}
        assert st(req('magical_animals_activate_fate', 1)) == '-1'               # no target parameter in original
        assert st(req('magical_animals_activate_fate')) == '-1'                 # no gems, no progress
        assert my.fate_count(db, conta) == 0
        before_fate = my.bonus(db, conta)
        with db._conn:
            my.give_item(db, conta, 2329, 3)
        assert st(req('magical_animals_activate_fate')) == '-1'                 # first node costs four
        assert my.item_count(db, conta, 2329) == 3
        with db._conn:
            my.give_item(db, conta, 2329, 11108)
            my.give_item(db, conta, 2239, 14099)
        r = req('magical_animals_activate_fate', key='destiny-all')
        assert st(r) == '0', r
        assert req('magical_animals_activate_fate', key='destiny-all') == r
        assert my.fate_count(db, conta) == 495
        assert my.fate_info(db, conta) == {'step': 99, 'progress': '0,0,0,0,0'}
        assert my.item_count(db, conta, 2329) == my.item_count(db, conta, 2239) == 0
        assert st(req('magical_animals_activate_fate')) == '-1'                 # no extra charge at max
        assert sum(v for k,v in my.bonus(db, conta) if k == 1) > sum(v for k,v in before_fate if k == 1)
        ship, mould = heroes.all_owned(db, conta)[0]
        assert school.combat_bonus(db, conta, ship, mould)[0][0] > 0
        snap = school.snapshot(db, conta); assert '12675' in snap
        assert {x['maMouldId'] for x in json.loads(snap[snap.index('12675') + 1])} == {1, 2, KURAMA}
        print('BESTAS_PASSED activate, cumulative stars, forge/reset, links, skill, destiny costs/full/retry/max, combat, login')
    finally:
        db._conn.close()
