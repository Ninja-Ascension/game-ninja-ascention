"""Ninja School > Shamanism (artifacts): practice, confirm/cancel, limits, unlock, combat (temporary DB)."""
import os, sys, tempfile
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='xamanismo-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import artifact_local as art, ninja_school_local as school, recruitment_local as heroes
    db = server.BANCO
    try:
        conta = db.criar_conta('xamateste', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        n = [0]
        def req(cmd, *a, key=None):
            n[0] += 1
            return server.despacha('\r\n'.join(['7', cmd, uid] + list(map(str, a)) + [key or 'k%d' % n[0]]))
        st = lambda r: r.split(' ')[2]
        qty = lambda: db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=242', (conta,)).fetchone()[0]
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,60,1000000)', (conta,))
            db._conn.execute('UPDATE local_campaign SET grade=60, silver=1000000 WHERE conta_id=?', (conta,))
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (conta,))
            db._conn.execute('UPDATE local_resources SET gold=1000 WHERE conta_id=?', (conta,))
        # artifact 1 is open (achievements -1); 2 needs achievements
        assert st(req('artifact_culture', 1, 0, 1)) == '-1'                       # no practice items
        with db._conn:
            db._conn.execute('INSERT INTO local_inventory VALUES (?,242,?,100)', (conta, conta * 1000000 + 242))
        assert st(req('artifact_culture', 2, 0, 1)) == '-1'                       # locked
        assert st(req('artifact_unlock', 2)) == '-1'                              # achievements not done
        r = req('artifact_culture', 1, 2, 1); assert st(r) == '0' and '12564' in r, r
        assert qty() == 95 and db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (conta,)).fetchone()[0] == 990
        assert art.state(db, conta, 1)['attrs'] == {k: 0 for k in art.state(db, conta, 1)['attrs']}   # nothing applied yet
        pend = art.state(db, conta, 1)['pending'][0]
        assert len(pend) == 3, pend          # client row has 3 slots
        r = req('artifact_confirm', 1, 0, '1'); assert st(r) == '0' and '12563' in r, r
        attrs = art.state(db, conta, 1)['attrs']
        for k, v in pend.items():
            assert attrs[k] == max(0, min(art.limit(1, k, 60), v)), (k, v, attrs[k])
        assert st(req('artifact_confirm', 1, 0, '1')) == '-1'                     # nothing pending
        # ten practices, keep two, retry with same id does not charge again
        r = req('artifact_culture', 1, 1, 10, key='dez'); assert st(r) == '0'
        assert len(r) < 20000, len(r)  # 10x returns pending rows, not an unchanged combat snapshot.
        assert req('artifact_culture', 1, 1, 10, key='dez') == r and qty() == 45
        before = dict(art.state(db, conta, 1)['attrs'])
        assert st(req('artifact_confirm', 1, 0, '3,7')) == '0'
        # cancel discards
        req('artifact_culture', 1, 0, 1); snap = dict(art.state(db, conta, 1)['attrs'])
        assert st(req('artifact_confirm', 1, -1, 1)) == '0' and art.state(db, conta, 1)['attrs'] == snap
        # limits hold over many practices
        with db._conn: db._conn.execute('UPDATE local_inventory SET quantity=100000 WHERE conta_id=? AND mould=242', (conta,))
        for i in range(30):
            req('artifact_culture', 1, 2, 10); req('artifact_confirm', 1, 0, ','.join(map(str, range(1, 11))))
        for k, v in art.state(db, conta, 1)['attrs'].items():
            assert 0 <= v <= art.limit(1, k, 60), (k, v)
        # combat + login snapshot
        ship, mould = heroes.all_owned(db, conta)[0]
        flat = school.combat_bonus(db, conta, ship, mould)[0]
        assert flat[0] > 0 or flat[1] > 0, flat
        assert '12563' in school.snapshot(db, conta)
        print('XAMANISMO_PASSED practice(cost items/gold, pending until confirm), choose some, cancel, retry, limits, locked/unlock refused, combat, login')
    finally:
        db._conn.close()
