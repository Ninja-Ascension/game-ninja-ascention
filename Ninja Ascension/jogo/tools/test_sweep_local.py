"""Integration check for Fast Raid using only a temporary SQLite account."""
import os
import json
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'port' / 'server'))

with tempfile.TemporaryDirectory(prefix='sweep-local-', dir=ROOT / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    os.environ['NR_ENABLE_TUTORIAL'] = '0'
    import local_server as server
    import scene_rewards_local
    import sweep_local
    import mudra_local
    import player_level_local

    db = server.BANCO
    account = db.criar_conta('sweep_test', 'Temporary123!')['id']
    profile = db.perfil(account)
    user_id = str(profile['user_id'])
    server._sessao_conexao['token'] = db.abrir_sessao(account)
    scene_id, npc_id = 24, 218
    nonce = 'test_sweep_0001'

    with db._lock, db._conn:
        db._conn.execute('INSERT INTO local_campaign(conta_id,grade,silver) VALUES (?,24,0)',
                         (account,))
        db._conn.execute('INSERT INTO local_resources(conta_id,food,gold) VALUES (?,100,0)',
                         (account,))
        db._conn.execute('INSERT INTO local_pve_clears VALUES (?,?,?,3)',
                         (account, scene_id, npc_id))

    original_rewards = scene_rewards_local._npc_reward_entries
    scene_rewards_local._npc_reward_entries = lambda _reward_id: [
        (-1, 1, 125), (68, 6, 2), (1, 66, 1)]
    try:
        request = '1\r\nsweep\r\n%s\r\n%d\r\n1\r\n3\r\n0\r\n%d\r\n%s' % (
            user_id, npc_id, scene_id, nonce)
        reply = server.despacha(request)
    finally:
        scene_rewards_local._npc_reward_entries = original_rewards

    tokens = reply.split()
    assert tokens[:3] == ['1', 'sweep', '0'], reply
    sweep_at = tokens.index('52')
    count = int(tokens[sweep_at + 1])
    assert count == 3, reply
    assert db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?',
                            (account,)).fetchone()[0] == 82
    assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',
                            (account,)).fetchone()[0] == 375
    assert db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=68',
                            (account,)).fetchone()[0] == 6
    assert db._conn.execute('SELECT COUNT(*) FROM local_metals WHERE conta_id=? AND mould=1',
                            (account,)).fetchone()[0] == 3
    assert player_level_local.estado(db, account)[1] == 18
    assert '14112' in tokens, 'sweep response did not refresh alloy inventory'

    # Same request ID with a new protocol sequence returns the prior result.
    repeated = server.despacha(request.replace('1\r\nsweep', '2\r\nsweep', 1))
    repeated_tokens = repeated.split()
    assert repeated_tokens[0] == '2' and repeated_tokens[1:] == tokens[1:], repeated
    assert db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?',
                            (account,)).fetchone()[0] == 82
    assert db._conn.execute('SELECT COUNT(*) FROM local_metals WHERE conta_id=? AND mould=1',
                            (account,)).fetchone()[0] == 3

    # Reusing that ID for a different amount is rejected without a charge.
    mismatch = request.replace('\r\n3\r\n0\r\n%d\r\n%s' % (scene_id, nonce),
                              '\r\n2\r\n0\r\n%d\r\n%s' % (scene_id, nonce))
    rejected = server.despacha(mismatch.replace('1\r\nsweep', '3\r\nsweep', 1))
    assert rejected.split()[2] == '-1' and 'reutilizado' in rejected, rejected
    assert db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?',
                            (account,)).fetchone()[0] == 82

    # Older clients omit the nonce: identical protocol sequence is idempotent,
    # while a distinct sequence represents a distinct deliberate sweep.
    legacy = '8\r\nsweep\r\n%s\r\n%d\r\n1\r\n1\r\n0\r\n%d' % (
        user_id, npc_id, scene_id)
    legacy_reply = server.despacha(legacy)
    legacy_retry = server.despacha(legacy)
    assert legacy_retry == legacy_reply, legacy_retry
    legacy_next = server.despacha(legacy.replace('8\r\nsweep', '9\r\nsweep', 1))
    assert legacy_next.startswith('9 sweep 0 '), legacy_next
    assert db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?',
                            (account,)).fetchone()[0] == 70

    denied = server.despacha(
        '4\r\nsweep\r\n%s\r\n219\r\n1\r\n1\r\n0\r\n%d\r\nnot_cleared_01' %
        (user_id, scene_id))
    assert denied.split()[2] == '-1' and 'tres_estrelas' in denied, denied

    # Elite has three daily sweeps and costs 12 energy each in the source data.
    elite_scene, elite_npc = 51, 488
    with db._lock, db._conn:
        db._conn.execute('INSERT INTO local_pve_clears VALUES (?,?,?,3)',
                         (account, elite_scene, elite_npc))
    scene_rewards_local._npc_reward_entries = lambda _reward_id: [(-1, 1, 25)]
    try:
        elite = server.despacha(
            '5\r\nsweep\r\n%s\r\n%d\r\n1\r\n10\r\n0\r\n%d\r\nelite_sweep_001' %
            (user_id, elite_npc, elite_scene))
    finally:
        scene_rewards_local._npc_reward_entries = original_rewards
    elite_tokens = elite.split()
    assert elite_tokens[:3] == ['5', 'sweep', '0'], elite
    elite_at = elite_tokens.index('52')
    assert int(elite_tokens[elite_at + 1]) == 3, elite
    day = __import__('shop_local').day()
    assert db._conn.execute(
        'SELECT attempts FROM local_sweep_attempts WHERE conta_id=? AND npc=? AND reset_day=?',
        (account, elite_npc, day)).fetchone()[0] == 3
    before_food = db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?',
                                   (account,)).fetchone()[0]
    no_daily_tries = server.despacha(
        '6\r\nsweep\r\n%s\r\n%d\r\n1\r\n1\r\n0\r\n%d\r\nelite_sweep_002' %
        (user_id, elite_npc, elite_scene))
    assert no_daily_tries.split()[2] == '-1' and 'tentativas' in no_daily_tries, no_daily_tries
    assert db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?',
                            (account,)).fetchone()[0] == before_food

    # Confirm the original chapter 24 and chapter 15 drop tables decode metal 66.
    for reward_id in (859, 769):
        decoded = original_rewards(reward_id)
        assert decoded and all(kind in (1, 6, 66) for _, kind, _ in decoded), decoded

    login = server.despacha('7\r\nlogin_init_again\r\n%s' % user_id)
    assert '14111' in login and '12047' in login, login
    assert '6023 %d 4 4 3 0' % elite_npc in login, login

    island = server.despacha('8\r\nfile_island_task_info\r\n%s' % user_id)
    island_fields = island.split(' ', 4)
    assert island_fields[:4] == ['8', 'file_island_task_info', '0', '12573'], island
    assert json.loads(island_fields[4]) == {
        'mySingleTaskInfo': [], 'myJoinTaskInfo': [], 'myMultiTaskInfo': [],
        'friendMultiTaskInfo': [], 'joinFriendTaskCount': 0,
        'finishFriendTaskCount': 0,
    }, island
    assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    assert not db._conn.execute('PRAGMA foreign_key_check').fetchall()

    print('sweep_local: ok; temp account only; retries idempotent; rewards and login state verified')
    db._conn.close()
