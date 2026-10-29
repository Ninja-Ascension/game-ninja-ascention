"""Main quest (draw_achieve_reward): progress, chain order, rewards once, -1 state (temporary DB)."""
import os, sys, tempfile
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='missao-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import achievements_local as ac
    db = server.BANCO
    try:
        conta = db.criar_conta('missaoteste', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        req = lambda i: server.despacha('\r\n'.join(['7', 'draw_achieve_reward', uid, str(i)]))
        st = lambda r: r.split(' ')[2]
        money = lambda: (db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (conta,)).fetchone()[0],
                         db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (conta,)).fetchone()[0])
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)', (conta,))
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (conta,))
        assert st(req(1)) == '-1'                                  # level 1 < 2
        with db._conn: db._conn.execute('UPDATE local_campaign SET grade=5 WHERE conta_id=?', (conta,))
        assert st(req(2)) == '-1'                                  # 1 must be taken first
        s0, g0 = money()
        r = req(1); assert st(r) == '0' and '171 24' in r, r
        assert money() == (s0 + 2000, g0 + 10)                      # reward of achieve 1: 10 gold + 2000 Ryo
        assert req(1).split(' ')[2] == '0' and money() == (s0 + 2000, g0 + 10)    # repeat: nothing more
        t = r.split(' '); vals = t[t.index('3501') + 1].split(',')
        assert vals[0] == '-1', vals[:3]                            # shown as taken
        assert st(req(2)) == '0' and st(req(3)) == '-1'             # level 5 < 6
        assert st(req(999999)) == '-1'
        print('MISSAO_PRINCIPAL_PASSED level gate, chain order, rewards once, taken=-1, unknown refused')
    finally:
        db._conn.close()
