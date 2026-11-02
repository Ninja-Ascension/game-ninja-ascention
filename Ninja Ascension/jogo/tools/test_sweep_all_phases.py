"""Exercise each campaign, Elite and Nightmare Rush NPC on a temp account."""
import collections
import os
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'port' / 'server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'

with tempfile.TemporaryDirectory(prefix='sweep-all-phases-', dir=ROOT / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import dados_batalha as data
    import local_server as server
    import player_level_local
    import tutorial_campaign

    db = server.BANCO
    try:
        account = db.criar_conta('sweep_matrix', 'Temporary123!')['id']
        user_id = str(db.perfil(account)['user_id'])
        server._sessao_conexao['token'] = db.abrir_sessao(account)
        # The matrix itself is an isolated regression check; keep its requests
        # out of the operator's real server.log.
        server.log = lambda *_args, **_kwargs: None

        phase_limits = {0: 24, 1: 74, 15: 124}
        scenes = data.tabela('pve_scene.txt')
        npcs = data.tabela('npc.txt')
        work = []
        seen_npcs = set()
        for scene_key, scene in scenes.items():
            if not scene_key.isdigit():
                continue
            scene_id = int(scene_key)
            scene_type = int(scene[5])
            if scene_type not in phase_limits or scene_id > phase_limits[scene_type]:
                continue
            npc_ids = []
            for group in scene[12].split(','):
                npc_ids.extend(int(value) for value in group.split(':') if value.isdigit())
            for npc_id in npc_ids:
                npc = npcs.get(str(npc_id))
                assert npc and int(npc[107]) == scene_id, (scene_id, npc_id, 'npc mapping')
                assert int(npc[118] or 0) > 0, (scene_id, npc_id, 'energy cost')
                assert npc_id not in seen_npcs, (scene_id, npc_id, 'duplicate npc')
                seen_npcs.add(npc_id)
                work.append((scene_id, scene_type, npc_id, int(npc[118])))

        assert len(work) == 423, 'Unexpected source phase/NPC coverage: %d' % len(work)
        max_level = player_level_local.nivel_maximo()
        with db._lock, db._conn:
            db._conn.execute(
                'INSERT INTO local_campaign(conta_id,grade,silver) VALUES (?,?,0)',
                (account, max_level))
            db._conn.execute(
                'INSERT INTO local_resources(conta_id,food,gold) VALUES (?,1000000000,0)',
                (account,))
            db._conn.executemany(
                'INSERT INTO local_pve_clears VALUES (?,?,?,3)',
                ((account, scene, npc) for scene, _, npc, _ in work))

        expected_props = collections.Counter()
        expected_metals = collections.Counter()
        expected_silver = expected_food = 0
        parser_total = 0
        for seq, (scene_id, _scene_type, npc_id, cost) in enumerate(work, 1):
            nonce = 'allphase_%06d' % seq
            request = '%d\r\nsweep\r\n%s\r\n%d\r\n1\r\n1\r\n0\r\n%d\r\n%s' % (
                seq, user_id, npc_id, scene_id, nonce)
            reply = server.despacha(request)
            tokens = reply.split()
            assert tokens[:4] == [str(seq), 'sweep', '0', '52'], (
                scene_id, npc_id, reply[:240])
            count = int(tokens[4])
            assert count == 1, (scene_id, npc_id, 'wrong sweep count', count)
            parser_total += count
            i = 5
            _exp, silver, _soul = map(int, tokens[i:i + 3])
            expected_silver += silver
            expected_food += cost
            i += 3
            prop_count = int(tokens[i]); i += 1
            for _ in range(prop_count):
                ident, amount = map(int, tokens[i:i + 2]); i += 2
                expected_props[ident] += amount
            equipment_count = int(tokens[i]); i += 1
            i += equipment_count * 2
            ship_count = int(tokens[i]); i += 1
            i += ship_count * 2
            metal_count = int(tokens[i]); i += 1
            for _ in range(metal_count):
                ident, amount = map(int, tokens[i:i + 2]); i += 2
                expected_metals[ident] += amount
            i += 3  # level, EXP, and EXP required
            assert len(tokens) >= i + 2, (scene_id, npc_id, 'truncated parser 52')

        actual_props = collections.Counter(dict(db._conn.execute(
            'SELECT mould,quantity FROM local_inventory WHERE conta_id=?',
            (account,)).fetchall()))
        actual_metals = collections.Counter(dict(db._conn.execute(
            'SELECT mould,COUNT(*) FROM local_metals WHERE conta_id=? GROUP BY mould',
            (account,)).fetchall()))
        actual_silver = int(db._conn.execute(
            'SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()[0])
        actual_food = int(db._conn.execute(
            'SELECT food FROM local_resources WHERE conta_id=?', (account,)).fetchone()[0])
        assert actual_props == expected_props, (dict(expected_props), dict(actual_props))
        assert actual_metals == expected_metals, (dict(expected_metals), dict(actual_metals))
        assert actual_silver == expected_silver, (actual_silver, expected_silver)
        assert actual_food == 1000000000 - expected_food, (actual_food, expected_food)
        assert parser_total == len(work)
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
        assert not db._conn.execute('PRAGMA foreign_key_check').fetchall()

        by_type = collections.Counter(scene_type for _, scene_type, _, _ in work)
        print('ALL_PHASE_RUSH_OK scenes=72 npcs=%d rewards=%d main=%d elite=%d nightmare=%d props=%d metals=%d' % (
            len(work), parser_total, by_type[0], by_type[1], by_type[15],
            sum(expected_props.values()), sum(expected_metals.values())))
    finally:
        db._conn.close()
