"""Ninja School > Sculpture Mountain: buy with Ryo/gold, use, level/ninja locks, combat, login (temporary DB)."""
import os, sys, tempfile, json
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='escultura-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import constellation_local as co, ninja_school_local as school, recruitment_local as heroes
    import dados_batalha as data
    db = server.BANCO
    try:
        conta = db.criar_conta('esculteste', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        n = [0]
        def req(cmd, *a, key=None):
            n[0] += 1
            return server.despacha('\r\n'.join(['7', cmd, uid] + list(map(str, a)) + [key or 'k%d' % n[0]]))
        st = lambda r: r.split(' ')[2]
        owned = {m: s for s, m in heroes.all_owned(db, conta)}
        # a mould/slot whose ninja the account owns
        m, s = next((int(r[0]), i) for r in data.tabela('constellation_mould.txt').values()
                    for i, mm in enumerate(r[4].split(','))
                    if int(mm) in owned and co.ninja_type(int(mm)) == int(r[3]))
        group = co.mould_row(m)[5].split(',')[s]
        rows = [r for r in data.tabela('constellation_group.txt').values() if r[1] == group and r[2] == '1']
        ryo = next(int(r[0]) for r in rows if r[5].startswith('1,'))
        gold = next(int(r[0]) for r in rows if r[5].startswith('2,'))
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)', (conta,))
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (conta,))
            db._conn.execute('UPDATE local_resources SET gold=100000 WHERE conta_id=?', (conta,))
        assert st(req('constellation_buy', m, s, ryo)) == '-1'                  # level too low
        with db._conn:
            db._conn.execute('UPDATE local_campaign SET grade=110, silver=10000000 WHERE conta_id=?', (conta,))
        r = req('constellation_buy', m, s, ryo, key='a'); assert st(r) == '0' and '12567' in r, r
        assert req('constellation_buy', m, s, ryo, key='a') == r                  # retry, single charge
        assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (conta,)).fetchone()[0] == 10000000 - int(co.group_row(ryo)[5].split(',')[2])
        assert st(req('constellation_buy', m, s, ryo)) == '-1'                  # already bought
        assert st(req('constellation_exchange', m, s, gold)) == '-1'            # not bought
        r = req('constellation_buy', m, s, gold); assert st(r) == '0', r
        i = co.info(db, conta); assert i['uc'][str(m)][str(s)] == gold and sorted(i['hba'][str(m)][str(s)]) == sorted([ryo, gold])
        r = req('constellation_exchange', m, s, ryo); assert st(r) == '0' and '12568' in r
        assert co.info(db, conta)['uc'][str(m)][str(s)] == ryo and co.info(db, conta)['ctv'] == int(co.group_row(ryo)[7])
        assert st(req('constellation_buy', m, s, 9999)) == '-1'                 # unknown row
        ship = owned[int(co.mould_row(m)[4].split(',')[s])]
        mould = int(co.mould_row(m)[4].split(',')[s])
        assert school.combat_bonus(db, conta, ship, mould)[0][1] > 0
        assert '12566' in school.snapshot(db, conta)
        print('ESCULTURA_PASSED level lock, buy Ryo/gold, retry, use/switch, ctv, combat, login')
    finally:
        db._conn.close()
