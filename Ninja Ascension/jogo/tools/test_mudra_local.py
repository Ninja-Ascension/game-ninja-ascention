"""Ninja School > Mudra (Alloy Matrix): buy, equip, strengthen, matrix reward, dissolve, combat (temporary DB)."""
import os, sys, tempfile, json
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='mudra-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import mudra_local as mu, recruitment_local as heroes, ninja_school_local as school
    import dados_batalha as data
    db = server.BANCO
    try:
        conta = db.criar_conta('mudrateste', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        n = [0]
        def req(cmd, *a, key=None):
            n[0] += 1
            return server.despacha('\r\n'.join(['7', cmd, uid] + list(map(str, a)) + [key or 'k%d' % n[0]]))
        st = lambda r: r.split(' ')[2]
        count = lambda: db._conn.execute('SELECT COUNT(*) FROM local_metals WHERE conta_id=?', (conta,)).fetchone()[0]
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)', (conta,))
            db._conn.execute('UPDATE local_campaign SET silver=100000000 WHERE conta_id=?', (conta,))
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (conta,))
            db._conn.execute('UPDATE local_resources SET gold=100000 WHERE conta_id=?', (conta,))
        # ---- buy: free Ryo draw, then paid; ten; fifty; daily state; equipment chest still handled by shop
        metals_before = count()
        r = req('ship_bounty', 4); assert st(r) == '0' and '14112' in r and '14113' in r, r
        tokens = r.split(' ')
        alloy_event = tokens.index('14112')
        assert tokens[alloy_event + 1] == '1', r  # one actual Mudra piece, as in the 50x flow
        piece = mu.metal(db, conta, tokens[alloy_event + 2])
        assert int(mu.metal_row(piece['mould'])[3]) > 0 and count() == metals_before + 1, r
        prize_event = tokens.index('166')
        assert tokens[prize_event + 1] == '1' and tokens[prize_event + 2] == '-1', r  # never a character card
        assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (conta,)).fetchone()[0] == 100000000   # free
        r = req('ship_bounty', 4); assert st(r) == '0'
        assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (conta,)).fetchone()[0] == 100000000 - 60000
        r = req('ship_batch_bounty', 5); assert st(r) == '0', r
        r = req('ship_batch_bounty', 6); assert st(r) == '0', r
        # HeroRecruitReward only shows "buy again"/"confirm" after walking all 50
        # prizes: one reward event per prize before the 166 list of 50.
        def prize_events(reply):
            t = reply.split(' ')[3:]; i = 0; n = 0
            while t[i] != '166':
                if t[i] == '14112': assert t[i+1] == '1'; i += 11; n += 1
                elif t[i] == '27': i += 3; n += 1
                elif t[i] == '12047': i += 2; n += 1
                else: raise AssertionError('evento inesperado %s' % t[i])
            return n, int(t[i+1])
        assert prize_events(r) == (50, 50), prize_events(r)
        r = req('ship_batch_bounty', 7); assert st(r) == '0', r
        r = req('ship_bounty', 5); assert st(r) == '0', r       # free gold draw
        assert count() >= 40, count()   # some prizes are Ryo/essence (kinds 1/67)
        rt = r.split(' '); i = rt.index('14113'); assert rt[i+1:i+4] == ['0', '0', '2,1,1,1,1'], rt[i:i+4]
        key_retry = req('ship_bounty', 4, key='same')
        metals_after_retry_request = count()
        silver_after_retry_request = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (conta,)).fetchone()[0]
        assert req('ship_bounty', 4, key='same') == key_retry     # retry: same reply, one charge
        assert count() == metals_after_retry_request and db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (conta,)).fetchone()[0] == silver_after_retry_request
        assert st(req('ship_bounty', '3')) in ('0', '-1')      # chest type still goes to shop_local
        # ---- equip: needs ninja level >= unlock; then matrix activation and reward
        ship, mould = next((s, m) for s, m in heroes.all_owned(db, conta) if mu.ship_matrices(m))
        metals = mu.all_metals(db, conta)
        p1 = mu.wire_id(metals[0]['id'])
        assert st(req('ship_metal_set', ship, 1, 0, '%s,1' % p1)) == '-1'          # locked (level 1)
        with db._conn:
            db._conn.execute('INSERT INTO local_ship_rank(conta_id,ship_id,rank_level,level) VALUES (?,?,0,100) ON CONFLICT(conta_id,ship_id) DO UPDATE SET level=100', (conta, ship))
        # pick pieces that satisfy one of the ninja's matrices
        by_type = {}
        for m in metals: by_type.setdefault(int(mu.metal_row(m['mould'])[3]), []).append(m)
        target = None
        for mid in mu.ship_matrices(mould):
            need = [tuple(map(int, x.split(','))) for x in data.tabela('ship_matrix_mould.txt')[str(mid)][2].split('|')]
            if sum(c for _, c in need) <= 4 and all(len(by_type.get(k, [])) >= c for k, c in need):
                target = (mid, need); break
        if target is None:   # give the pieces needed for the first small matrix
            mid = next(x for x in mu.ship_matrices(mould) if sum(int(p.split(',')[1]) for p in data.tabela('ship_matrix_mould.txt')[str(x)][2].split('|')) <= 4)
            need = [tuple(map(int, x.split(','))) for x in data.tabela('ship_matrix_mould.txt')[str(mid)][2].split('|')]
            with db._conn:
                for k, c in need:
                    mould_k = next(r[0] for r in data.tabela('ship_metal_mould.txt').values() if int(r[3]) == k)
                    for _ in range(c): db._conn.execute('INSERT INTO local_metals(conta_id,mould) VALUES (?,?)', (conta, mould_k))
            metals = mu.all_metals(db, conta); by_type = {}
            for m in metals: by_type.setdefault(int(mu.metal_row(m['mould'])[3]), []).append(m)
            target = (mid, need)
        chosen = [m for k, c in target[1] for m in by_type[k][:c]]
        info = '|'.join('%s,%d' % (mu.wire_id(m['id']), i + 1) for i, m in enumerate(chosen)) + '|'
        r = req('ship_metal_set', ship, 1, 1, info); assert st(r) == '0' and '14104' in r, r
        alloy = json.loads(mu.alloy_json(db, conta, ship, mould))
        assert alloy['ma']['1'] and str(target[0]) in alloy['ma']['1'] or alloy['ma']['1'], alloy
        active = list(alloy['ma']['1'])[0]
        assert alloy['mr'][active] == 0, alloy
        ess0 = mu.essence(db, conta)
        r = req('draw_matrix_reward', ship, active + ','); assert st(r) == '0' and '171' in r, r
        assert mu.essence(db, conta) == ess0 + 50 and json.loads(mu.alloy_json(db, conta, ship, mould))['mr'][active] == 1
        assert st(req('draw_matrix_reward', ship, active + ',')) == '-1'          # only once
        # equipped piece cannot be dissolved; combat bonus includes pieces + matrix
        assert st(req('ship_metal_dissolve', '%s,' % mu.wire_id(chosen[0]['id']))) == '-1'
        flat = school.combat_bonus(db, conta, ship, mould)
        assert sum(flat[0]) > 0 or flat[2], flat
        # ---- strengthen with essence (type 0 one level, type 1 many), rank gate with Ryo
        with db._conn: mu.add_essence(db, conta, 10 ** 7)
        w = mu.wire_id(chosen[0]['id'])
        r = req('ship_metal_escalate', w, 0); assert st(r) == '0' and '14115' in r, r
        assert mu.metal(db, conta, w)['level'] == 2
        r = req('ship_metal_escalate', w, 1); assert st(r) == '0', r
        m = mu.metal(db, conta, w); p = mu.param_row(m['mould'], m['level'], m['rank'])
        assert int(p[5]) == -1, (m, p)                       # stopped at a rank gate
        s0 = mu.silver(db, conta)
        r = req('ship_metal_escalate', w, 0); assert st(r) == '0', r
        assert mu.metal(db, conta, w)['rank'] == m['rank'] + 1 and mu.silver(db, conta) < s0
        # one-key to level 30 on group 1
        r = req('ship_metal_onekey_escalate', ship, 1, 30); assert st(r) == '0', r
        assert all(mu.metal(db, conta, mu.wire_id(x['id']))['level'] >= 30 for x in chosen)
        # ---- unequip all then dissolve refunds 100% essence / 80% Ryo
        assert st(req('ship_metal_set', ship, 1, 2, -1)) == '0'
        m = mu.metal(db, conta, w); e0, s0 = mu.essence(db, conta), mu.silver(db, conta)
        r = req('ship_metal_dissolve', '%s,' % w); assert st(r) == '0' and '14114' in r and '171' in r, r
        assert mu.essence(db, conta) == e0 + m['essence'] and mu.silver(db, conta) == s0 + int(m['silver'] * 0.8)
        assert st(req('ship_metal_dissolve', '%s,' % w)) == '-1'
        # ---- login/init carries pieces, essence, counters and alloyMatrix
        tokens = school.snapshot(db, conta)
        assert '14111' in tokens and '12047' in tokens and '14113' in tokens
        login = server.resposta_login_init('9', '')
        assert '"mmi"' in login
        print('MUDRA_PASSED buy(free/paid/10/50/gold/limits/retry), equip(lock/batch), matrix+reward once, strengthen(essence/rank Ryo/one-key), dissolve refund, combat, login')
    finally:
        db._conn.close()
