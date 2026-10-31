"""Covers original Ninja Trial chest drops and replay protection in a temp DB."""
import os
import sys
import tempfile
from pathlib import Path
from unittest.mock import patch

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port' / 'server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'

with tempfile.TemporaryDirectory(prefix='ninja-trial-chests-', dir=root / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import ninja_trial_local as trial

    db = server.BANCO
    server.log = lambda *_args: None
    try:
        def prepare(name):
            account = db.criar_conta(name, 'Temporary123!')['id']
            uid = str(db.perfil(account)['user_id'])
            server._sessao_conexao['token'] = db.abrir_sessao(account)
            init = server.despacha('\r\n'.join(['1', 'three_kingdoms_init', uid]))
            assert '12558' in init, init
            db._conn.execute(
                'INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)',
                (account,))
            # Floor 4 is the first reward chest in the original table.
            db._conn.execute(
                'UPDATE local_ninja_trial SET floor=3,stars=0 WHERE conta_id=?',
                (account,))
            return account, uid

        def claim(account, uid, sequence, rolls):
            server._sessao_conexao['token'] = db.abrir_sessao(account)
            args = ['54', '157', '0', '0', '0', '4', '', '', '', '0']
            with patch.object(trial.random, 'randint', side_effect=rolls):
                return server.despacha('\r\n'.join(
                    [str(sequence), 'three_kingdoms_launch', uid] + args))

        equipment_account, equipment_uid = prepare('trialchestequip')
        # Reward 2042 uses groups 1511 and 1513. These rolls select equipment
        # 186 from the first group and 10,000 silver from the second.
        reply = claim(equipment_account, equipment_uid, 2,
                      [1, 162, 1, 1, 1312, 10000])
        assert 'three_kingdoms_launch 0 343' in reply, reply
        equipment = db._conn.execute(
            'SELECT mould FROM local_shop_equipment WHERE conta_id=?',
            (equipment_account,)).fetchall()
        assert (186,) in [tuple(row) for row in equipment], equipment
        silver = db._conn.execute(
            'SELECT silver FROM local_campaign WHERE conta_id=?',
            (equipment_account,)).fetchone()[0]
        assert silver == 10000, silver
        repeat = claim(equipment_account, equipment_uid, 3,
                       [1, 162, 1, 1, 1312, 10000])
        assert repeat.startswith('3 three_kingdoms_launch 0'), repeat
        assert db._conn.execute(
            'SELECT mould FROM local_shop_equipment WHERE conta_id=?',
            (equipment_account,)).fetchall() == equipment
        assert db._conn.execute(
            'SELECT silver FROM local_campaign WHERE conta_id=?',
            (equipment_account,)).fetchone()[0] == silver

        prestige_account, prestige_uid = prepare('trialchestprestige')
        # The same chest tables also include type 18 and ordinary props.
        reply = claim(prestige_account, prestige_uid, 4,
                      [1, 1, 10, 1, 1, 1])
        assert 'three_kingdoms_launch 0 343' in reply, reply
        wallet = db._conn.execute(
            'SELECT trial FROM local_special_wallet WHERE conta_id=?',
            (prestige_account,)).fetchone()
        prop = db._conn.execute(
            'SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=231',
            (prestige_account,)).fetchone()
        assert wallet and wallet[0] == 10, wallet
        assert prop and prop[0] == 1, prop
        repeat = claim(prestige_account, prestige_uid, 5,
                       [1, 1, 10, 1, 1, 1])
        assert repeat.startswith('5 three_kingdoms_launch 0'), repeat
        assert db._conn.execute(
            'SELECT trial FROM local_special_wallet WHERE conta_id=?',
            (prestige_account,)).fetchone()[0] == 10
        assert db._conn.execute(
            'SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=231',
            (prestige_account,)).fetchone()[0] == 1

        print('OK: original chest pools grant equipment, currency, prestige and props; repeat claims do not duplicate rewards.')
    finally:
        db.fechar()
