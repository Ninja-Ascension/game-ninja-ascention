"""Great Shinobi challenge battles from the original pve_scene catalog."""
import os, sys, tempfile, time
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='great-shinobi-', dir=root / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import dados_batalha as data
    import tutorial_campaign as campaign
    db = server.BANCO
    try:
        account = db.criar_conta('greatshinobitest', 'Temporary123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(account)
        uid = str(db.perfil(account)['user_id'])

        def req(command, *args):
            return server.despacha('\r\n'.join(['7', command, uid] + list(map(str, args))))

        # A loss is acknowledged and releases the pending battle without
        # awarding progress; the same challenge can then be started again.
        assert campaign.remaining_great_shinobi(db, account, 347) == 2
        assert req('battle_result_start', 0, 151, 1182, 1, 0, '1,4001,1,2') == '7 battle_result_start 0'
        failed = req('battle_result_fail', 151, 1182, '1,4001,1,2')
        assert failed.startswith('7 battle_result_fail 0 217 1'), failed[:120]
        assert campaign.remaining_great_shinobi(db, account, 347) == 1
        assert 590 <= campaign.cooldown_great_shinobi(db, account, 347) <= 600
        cooldown_block = req('battle_result_start', 0, 151, 1182, 1, 0, '1,4001,1,2')
        assert 'desafio_em_recarga_' in cooldown_block, cooldown_block
        with db._lock, db._conn:
            db._conn.execute(
                'UPDATE local_great_shinobi_attempts SET cooldown_until=? '
                'WHERE conta_id=? AND activity_id=347', (int(time.time()) - 1, account))
        assert campaign.cooldown_great_shinobi(db, account, 347) == 0
        assert db._conn.execute('SELECT COUNT(*) FROM local_pve_clears WHERE conta_id=?', (account,)).fetchone()[0] == 0
        assert ' -1 ' in req('battle_result_verify', 0, 151, '1-1182', 3, 1, 1)

        # Match the original client catalog: Ryo, EXP, Illusion (three NPC
        # alternatives per stage), and Technical Operations / Skill Challenge.
        for scene in (151, 152, 153, 154):
            group = data.tabela('pve_scene.txt')[str(scene)][12].split(',')[0]
            npc = int(group.split(':')[0])
            assert req('battle_result_start', 0, scene, npc, 1, 0, '1,4001,1,2') == '7 battle_result_start 0'
            # Match command_battle_field_init in ProtocolCommanderCopy.lua:
            # user_id, battle_init_type, scene, npc, difficulty, sender.
            field = req('battle_field_init', 0, scene, npc, 1, '2,%s,1,6' % scene)
            parts = field.split()
            assert parts[2] == '0' and parts[3] == '182', (scene, npc, field[:160])
            # battle_result_verify adds user_id and battle_init_type before
            # the five result fields, as command_battle_result_verify does.
            result = req('battle_result_verify', 0, scene, '1-%d' % npc, 3, 1, 1)
            assert result.split()[2] == '0', (scene, npc, result[:160])
            if scene == 151:
                assert '217 0' in result, result[-120:]
                assert campaign.remaining_great_shinobi(db, account, 347) == 0
                # Replaying the same verification must not spend a second try.
                repeated = req('battle_result_verify', 0, scene, '1-%d' % npc, 3, 1, 1)
                assert '217 0' in repeated, repeated[-120:]
                assert campaign.remaining_great_shinobi(db, account, 347) == 0
                blocked = req('battle_result_start', 0, scene, npc, 1, 0, '1,4001,1,2')
                assert 'tentativas_diarias_esgotadas' in blocked, blocked
            elif scene == 152:
                assert '218 1' in result, result[-120:]
                assert campaign.remaining_great_shinobi(db, account, 348) == 1
                assert 590 <= campaign.cooldown_great_shinobi(db, account, 348) <= 600
            elif scene == 154:
                assert '12405 52,1' in result, result[-120:]
                assert campaign.remaining_great_shinobi(db, account, 350) == 1
                assert 590 <= campaign.cooldown_great_shinobi(db, account, 350) <= 600
            assert db._conn.execute('SELECT stars FROM local_pve_clears WHERE conta_id=? AND scene=? AND npc=?',
                                    (account, scene, npc)).fetchone()[0] == 3

        login_counts = campaign.login_attempt_tokens(db, account)
        assert login_counts[:6] == ['217', '0', '218', '1', '12405', '52,1'], login_counts
        assert login_counts[6] == '470', login_counts
        cooldowns = list(map(int, login_counts[7].split(',')))
        assert len(cooldowns) == 4 and cooldowns[0] == 0
        assert cooldowns[1] > int(time.time() * 1000)
        assert cooldowns[2] == 0 and cooldowns[3] > int(time.time() * 1000)
        login = req('login_init_again')
        assert '217 0 218 1 12405 52,1 470 ' in login, login[-180:]

        states = list(map(int, campaign.scene_tokens(db, account)[1].split(',')))
        assert states[150] == 1 and states[151] == 1 and states[152] == 1 and states[153] == 1, states[150:154]
        print('GREAT_SHINOBI_PASSED Ryo/EXP/Illusion/Skill start, field, victory; loss ACK/retry; saved challenge progress')
    finally:
        db.fechar()
