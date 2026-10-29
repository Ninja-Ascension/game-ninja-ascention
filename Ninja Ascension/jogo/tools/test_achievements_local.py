"""Ninja School > Achievements and general achievement progress (Shamanism unlock) (temporary DB)."""
import os, sys, tempfile
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='conquistas-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import achievements_local as ac, artifact_local as art, ninja_school_local as school
    db = server.BANCO
    try:
        conta = db.criar_conta('conqteste', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        req = lambda cmd, *a: server.despacha('\r\n'.join(['7', cmd, uid] + list(map(str, a))))
        st = lambda r: r.split(' ')[2]
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,10,0)', (conta,))
        # achievement 1 ("function opened") needs level 40
        assert st(req('draw_achievement_reward', 1)) == '-1'
        with db._conn: db._conn.execute('UPDATE local_campaign SET grade=40 WHERE conta_id=?', (conta,))
        r = req('draw_achievement_reward', 1); assert st(r) == '0' and '12565' in r, r
        t = r.split(' '); assert t[t.index('12565') + 1] == '10' and '1:-1' in t[t.index('12565') + 2].split(','), t[:6]
        assert req('draw_achievement_reward', 1) == r.replace('7 draw', '7 draw')     # repeat: same state, no double points
        assert ac.score(db, conta) == 10
        # stage stars feed type 34
        with db._conn:
            for i in range(1, 161): db._conn.execute('INSERT INTO local_pve_clears VALUES (?,?,?,3)', (conta, 1 + i // 20, i))
        f = ac.facts(db, conta); assert f['stage_stars'] == 480
        row5 = ac.data.tabela('achievement.txt')['5']; assert ac.progress(f, row5) >= ac.target(row5)
        assert st(req('draw_achievement_reward', 5)) == '0'
        # general achievements: level 32 -> 385 done, others not; artifact 2 still locked
        assert ac.completed(db, conta, 385) and not ac.completed(db, conta, 389)
        assert st(server.despacha('\r\n'.join(['7', 'artifact_unlock', uid, '2', 'x1']))) == '-1'
        # chapter 12, ten stages -> 389; then the rest of artifact 2 conditions decide
        with db._conn:
            for i in range(1, 11): db._conn.execute('INSERT OR IGNORE INTO local_pve_clears VALUES (?,12,?,3)', (conta, 5000 + i))
        assert ac.completed(db, conta, 389)
        snap = school.snapshot(db, conta)
        assert '12565' in snap and '3501' in snap
        assert len(snap[snap.index('3501') + 1].split(',')) >= 1199
        print('CONQUISTAS_PASSED level gate, claim once, points, stage stars, general progress for Shamanism, snapshot')
    finally:
        db._conn.close()
