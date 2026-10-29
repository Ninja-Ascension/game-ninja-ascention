"""Aid Team uses original unlock/upgrade requirements on a temporary account."""
import os
import sys
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port' / 'server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'

with tempfile.TemporaryDirectory(prefix='aid-team-', dir=root / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import dados_batalha as data
    import hero_quality_local as quality
    import recruitment_local as heroes
    import soul_guard_local as aid

    db = server.BANCO
    try:
        account = db.criar_conta('aid_test', 'Temporary123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(account)
        uid = str(db.perfil(account)['user_id'])
        with db._lock, db._conn:
            db._conn.execute('INSERT INTO local_campaign(conta_id,grade,silver) VALUES (?,50,10000000) '
                             'ON CONFLICT(conta_id) DO UPDATE SET grade=50,silver=10000000', (account,))
            quality.schema(db)
            candidates = [int(r[0]) for r in data.tabela('ship_mould.txt').values()
                          if int(r[0]) not in {13, 35, 50}][:4]
            for mould in candidates:
                ship = 1000000000 + account * 100000 + mould
                db._conn.execute('INSERT INTO local_synthesized VALUES (?,?,?)', (account, mould, ship))
                db._conn.execute('INSERT INTO local_ship_rank VALUES (?,?,40,100)', (account, ship))
                db._conn.execute('INSERT INTO local_hero_quality VALUES (?,?,8)', (account, ship))
            db._conn.execute('INSERT OR REPLACE INTO local_inventory VALUES (?,?,?,1000)',
                             (account, 360, account * 1000000 + 360))

        seq = 0
        def req(command, *args):
            global seq
            seq += 1
            return server.despacha('\r\n'.join(['7', command, uid, *map(str, args), 'aid-%d' % seq]))

        assert len([x for x in heroes.all_owned(db, account) if x[1] in candidates]) == 4
        unlocked = req('soul_gruad_un_lock', 1)
        assert unlocked.split(' ')[2] == '0' and '12661' in unlocked, unlocked
        assert aid.slots(db, account)[1][0] == 0

        mould = candidates[0]
        equipped = req('soul_gruad_use_ship_mould', 1, mould)
        assert equipped.split(' ')[2] == '0' and aid.slots(db, account)[1][1] == mould, equipped

        upgraded = req('soul_gruad_level_up', 1)
        assert upgraded.split(' ')[2] == '0' and aid.slots(db, account)[1][0] == 1, upgraded
        assert aid.info(db, account)['1']['onUseShipMouldId'] == mould
        assert aid.bonus(db, account)
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    finally:
        db._conn.close()

print('AID_TEAM_PASSED original unlock conditions, equip, Ryo/item upgrade, stats and temporary SQLite integrity')
