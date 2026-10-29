"""Ninja School > Ninja Saga: buy panel, draws (free/tickets/limits/guarantee/extra), marks synthesis,
activate/star/reset, achievements unlock chapters, combat, login (temporary DB)."""
import os, sys, tempfile, json
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='saga-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import saga_local as sg, ninja_school_local as school, recruitment_local as heroes
    import dados_batalha as data
    db = server.BANCO
    try:
        conta = db.criar_conta('sagateste', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        n = [0]
        def req(cmd, *a, key=None):
            n[0] += 1
            return server.despacha('\r\n'.join(['7', cmd, uid] + list(map(str, a)) + [key or 'k%d' % n[0]]))
        st = lambda r: r.split(' ')[2]
        qty = lambda p: sg.item_count(db, conta, p)
        initial_draw_info=sg.draw_info(db,conta)
        assert initial_draw_info['normalDrawMaxNumber']==50
        assert initial_draw_info['advanceDrawMaxNumber']==8000
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,100,100000000)', (conta,))
            db._conn.execute('UPDATE local_campaign SET silver=100000000 WHERE conta_id=?', (conta,))
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (conta,))
            db._conn.execute('UPDATE local_resources SET gold=100000 WHERE conta_id=?', (conta,))
        # buy panel: normal x1 (Ryo) and advanced x10 (gold) give draw tickets
        r = req('biographies_buy_prop', 0, 0, 5); assert st(r) == '0' and '171' in r, r
        assert qty(2105) == 5
        r = req('biographies_buy_prop', 1, 1, 1); assert st(r) == '0', r
        assert qty(2106) == 10 and db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (conta,)).fetchone()[0] == 100000 - 2280
        # draws: first normal x1 is free, then tickets; each prize is a 32 event
        r = req('biographies_draw', 0, 1); assert st(r) == '0' and '32' in r.split(' '), r
        assert qty(2105) == 5
        r = req('biographies_draw', 0, 1); assert st(r) == '0' and qty(2105) == 4
        r = req('biographies_draw', 1, 10, key='dez'); assert st(r) == '0', r
        assert req('biographies_draw', 1, 10, key='dez') == r and qty(2106) == 0      # retry, one charge
        assert st(req('biographies_draw', 1, 10)) == '-1'                             # no tickets
        assert sg.draw_info(db, conta)['totalAdvanceDrawNumber'] == 10
        # extra reward needs 20 advanced draws
        assert st(req('biographies_get_extra_reward')) == '-1'
        with db._conn: sg.give_item(db, conta, 2106, 10)
        assert st(req('biographies_draw', 1, 10)) == '0'
        r = req('biographies_get_extra_reward'); assert st(r) == '0' and '171' in r, r
        # mark synthesis
        row = list(data.tabela('mark_synthesis.txt').values())[0]
        target = int(row[1].split(',')[1]); mat = [int(x) for x in row[2].split(',')]
        if qty(mat[1]) < mat[2]: assert st(req('biographies_mark_synthesis', target)) == '-1'
        with db._conn: sg.give_item(db, conta, mat[1], mat[2])
        m0, t0 = qty(mat[1]), qty(target)
        r = req('biographies_mark_synthesis', target); assert st(r) == '0' and qty(target) == t0 + 1 and qty(mat[1]) == m0 - mat[2], r
        # activate needs marks; chapter 2 locked until achievement 3
        b1 = 1; mark = sg.triples(sg.bio_row(b1)[2])[0]
        b2 = next(int(r[0]) for r in data.tabela('biographies_mould.txt').values() if r[4] == '2')
        assert st(req('biographies_activate', b1)) in ('-1', '0')
        with db._conn:
            for r in data.tabela('biographies_mould.txt').values():
                for k, i, c in sg.triples(r[2]): sg.give_item(db, conta, i, c * 3)
            for r in data.tabela('biographies_star_mould.txt').values():
                for k, i, c in sg.triples(r[3]): sg.give_item(db, conta, i, c)
        if b1 not in sg.bios(db, conta):
            assert st(req('biographies_activate', b1)) == '0'
        assert st(req('biographies_activate', b2)) == '-1'                           # chapter 2 locked
        assert st(req('biographies_advance', b1)) == '-1'                            # stars locked (achievement 11)
        for r in data.tabela('biographies_mould.txt').values():
            if r[4] == '1' and int(r[0]) not in sg.bios(db, conta):
                assert st(req('biographies_activate', r[0])) == '0'
        v = sg.achievement_value(db, conta)
        for a in (1, 2, 3):
            assert st(req('biographies_achieve_activate', a)) == ('0' if v >= int(data.tabela('biographies_achieve.txt')[str(a)][1]) else '-1')
        assert sg.chapters(db, conta)[1]['unlock'] == 1
        assert st(req('biographies_activate', b2)) == '0'
        with db._conn: db._conn.execute('INSERT OR IGNORE INTO local_saga_achieve VALUES (?,11)', (conta,))
        assert st(req('biographies_advance', b1)) == '0' and sg.bios(db, conta)[b1] == 1
        r = req('biographies_rebirth', b1); assert st(r) == '0' and sg.bios(db, conta)[b1] == 0, r
        # combat + login + rank
        ship, mould = heroes.all_owned(db, conta)[0]
        assert school.combat_bonus(db, conta, ship, mould)[0][0] > 0
        snap = school.snapshot(db, conta)
        for code in ('12668', '12670', '12671', '12672', '12673', '12674'): assert code in snap, code
        rk = server.despacha('\r\n'.join(['8', 'biographies_rank', uid, '0'])); assert st(rk) == '0', rk
        print('SAGA_PASSED buy panel, draws(free/tickets/retry/limit), extra reward, marks synthesis, activate/chapter lock/achievements/star/reset, combat, login, rank')
    finally:
        db._conn.close()
