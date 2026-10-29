"""Arena milestone rewards use original mould data and credit talent points once."""
import os
import sys
import tempfile
import json
import time
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port' / 'server'))

with tempfile.TemporaryDirectory(prefix='arena-rewards-', dir=root / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    os.environ['NR_ENABLE_TUTORIAL'] = '0'
    import local_server as server
    import arena_local as arena
    import ninja_school_local as school

    db = server.BANCO
    try:
        account = db.criar_conta('arena_reward_test', 'Temporary123!')['id']
        with db._lock, db._conn:
            arena.schema(db)
            arena.state(db, account)
            db._conn.execute('UPDATE local_arena SET score=10 WHERE conta_id=?', (account,))
            before = school.state(db, account)['talentPoints']
            arena.claim(db, account, 'score', 5)
            assert school.state(db, account)['talentPoints'] == before + 1
            try:
                arena.claim(db, account, 'score', 5)
            except ValueError as exc:
                assert str(exc) == 'recompensa_ja_recebida'
            else:
                raise AssertionError('Arena talent-point reward could be claimed twice')
            assert school.state(db, account)['talentPoints'] == before + 1

            rival = db.criar_conta('arena_rival_test', 'Temporary123!')['id']
            arena.state(db, rival)
            with db._conn:
                db._conn.execute('UPDATE local_arena SET rank=-1 WHERE conta_id=?', (account,))
                db._conn.execute('UPDATE local_arena SET rank=1 WHERE conta_id=?', (rival,))
                db._conn.execute('UPDATE local_arena SET rank=2 WHERE conta_id=?', (account,))
                db._conn.execute(
                    'INSERT INTO local_arena_matches(id,conta_id,target,rank,started,payload) VALUES (?,?,?,?,?,?)',
                    ('match-once', account, rival, 1, int(time.time()), json.dumps({
                        'uid': db.perfil(rival)['user_id'], 'name': 'Arena&nbsp;Rival', 'head': 1,
                        'level': 9, 'power': 321, 'speed': 44})))
            arena_state = arena.state(db, account)
            arena.launch(server, db, account, arena_state, ['1', '2', '1', 'match-once'])
            assert arena.score(db, account) == 12
            assert arena.state(db, account)['remain'] == 4
            assert arena.state(db, account)['rank'] == 1
            report = arena.report_tokens(db, account)
            assert report[:2] == ['14700', '1'], report
            fields = report[2:18]
            assert fields[6:9] == ['Arena&nbsp;Rival', '321', '0'], fields
            assert fields[10] == '11' and fields[13] == '44', fields
            assert fields[9].split(',')[3:5] == ['2', '1'], fields
            server._sessao_conexao['token'] = db.abrir_sessao(account)
            wire_reply=arena.execute(server,'battlefield_report_get','9','11,1011')
            wire_tokens=wire_reply.split(' ')
            assert wire_tokens[2:5] == ['0','14700','1'], wire_reply
            stamp=db._conn.execute('SELECT report_time FROM local_arena_reports WHERE id=?',('match-once',)).fetchone()[0]
            replay=arena.execute(server,'battlefield_report_battle_info_get','10',
                '10\r\nbattlefield_report_battle_info_get\r\n%s\r\n11\r\n%s'
                %(db.perfil(account)['user_id'],stamp)).split(' ',4)
            assert replay[2]=='-1' and replay[3]=='dados_historicos_de_replay_nao_disponiveis',replay
            arena.launch(server, db, account, arena_state, ['1', '2', '1', 'match-once'])
            assert arena.score(db, account) == 12
            assert arena.state(db, account)['remain'] == 4
            assert db._conn.execute('SELECT COUNT(*) FROM local_arena_reports WHERE conta_id=?',(account,)).fetchone()[0] == 1
            with db._conn:
                db._conn.execute('UPDATE local_arena SET cd=0 WHERE conta_id=?',(account,))
            started=arena.launch(server,db,account,arena.state(db,account),['2','0'])
            match=json.loads(started[1])
            # Storage contract fixture, not a claim of historical server format.
            init='100\r\nbattle_field_init\r\n0\r\n182\r\n11 1 1 1'
            fight='100\r\nenvironment_fight\r\n0\r\n39\r\n0 10 0'
            bundle=json.dumps(dict(version=1,initHex=init.encode().hex(),fightHex=fight.encode().hex()),separators=(',',':'))
            arena.launch(server,db,account,arena.state(db,account),['2','2','0',match['matchId'],bundle])
            score_after=arena.score(db,account)
            arena.launch(server,db,account,arena.state(db,account),['2','2','0',match['matchId'],bundle])
            assert arena.score(db,account)==score_after
            timestamp=db._conn.execute('SELECT report_time FROM local_arena_reports WHERE id=?',(match['matchId'],)).fetchone()[0]
            request='10\r\nbattlefield_report_battle_info_get\r\n%s\r\n11\r\n%s'%(db.perfil(account)['user_id'],timestamp)
            replay=arena.execute(server,'battlefield_report_battle_info_get','10',request).split(' ',4)
            assert replay[2:4]==['0','15981'],replay
            record=json.loads(replay[4])
            assert bytes.fromhex(record['initHex']).decode()==init
            assert bytes.fromhex(record['fightHex']).decode()==fight
            other=db.criar_conta('arena_private_test','Temporary123!')['id']
            server._sessao_conexao['token']=db.abrir_sessao(other)
            private=arena.execute(server,'battlefield_report_battle_info_get','10','10\r\nbattlefield_report_battle_info_get\r\n%s\r\n11\r\n%s'%(db.perfil(other)['user_id'],timestamp))
            assert private.split(' ')[2]=='-1'
            server._sessao_conexao['token']=db.abrir_sessao(account)
            record['fightHex']=record['fightHex'][:-2]+'31'
            try:arena.recorded_packets(json.dumps(record),None)
            except ValueError:pass
            else:raise AssertionError('Corrupt replay accepted')

            report=arena.report_tokens(db,account)
            assert report[:2] == ['14700','2'], report
            results={report[i+8] for i in range(2,len(report),16)}
            assert results == {'0','1'}, report
            assert db._conn.execute('SELECT COUNT(*) FROM local_arena_reports WHERE conta_id=?',(account,)).fetchone()[0] == 2
            # Incremental engine journals persist atomically, even without protocol 39.
            with db._conn:
                db._conn.execute('UPDATE local_arena SET cd=0 WHERE conta_id=?',(account,))
            match3=json.loads(arena.launch(server,db,account,arena.state(db,account),['2','0'])[1])
            journal=dict(version=2,matchId=match3['matchId'],win='1',initHex=init.encode().hex(),events=[
                dict(kind='protocol',dataHex=init.encode().hex()),
                dict(kind='round',dataHex=b'actual-round-output'.hex()),
                dict(kind='action',dataHex=b'actual-action-output'.hex()),
                dict(kind='skip',dataHex=b'actual-skip-output'.hex())])
            archive=json.dumps(journal,separators=(',',':'))
            arena.launch(server,db,account,arena.state(db,account),['2','2','1',match3['matchId'],archive])
            saved=db._conn.execute('SELECT replay,report_time FROM local_arena_reports WHERE id=?',(match3['matchId'],)).fetchone()
            saved_record=json.loads(saved[0]);assert saved_record['events']==journal['events']
            assert saved_record['archiveSha256']
            previous_score=arena.score(db,account);previous_remain=arena.state(db,account)['remain']
            arena.launch(server,db,account,arena.state(db,account),['2','2','1',match3['matchId'],archive])
            assert arena.score(db,account)==previous_score and arena.state(db,account)['remain']==previous_remain
            assert db._conn.execute('SELECT replay FROM local_arena_reports WHERE id=?',(match3['matchId'],)).fetchone()[0]==saved[0]
            saved_record['events'][1]['dataHex']=b'changed'.hex()
            try:arena.recorded_packets(json.dumps(saved_record),1)
            except ValueError:pass
            else:raise AssertionError('Modified journal passed checksum')
            db._conn.commit()
            request='10\r\nbattlefield_report_battle_info_get\r\n%s\r\n11\r\n%s'%(db.perfil(account)['user_id'],saved[1])
            assert 'atualize_o_cliente' in arena.execute(server,'battlefield_report_battle_info_get','10',request)
            request+='\r\njournal-v2'
            unavailable=arena.execute(server,'battlefield_report_battle_info_get','10',request)
            assert unavailable.split(' ',4)[2:4]==['0','15981']
            assert json.loads(unavailable.split(' ',4)[4])['events']==journal['events']
            assert json.loads(unavailable.split(' ',4)[4])['uiBattleData']==match3['battle_data']
            for _ in range(2):
                assert arena.execute(server,'battlefield_report_battle_info_get','10',request).split(' ',4)[2]=='0'
            assert arena.score(db,account)==previous_score and arena.state(db,account)['remain']==previous_remain
            db._conn.commit()
            import sqlite3
            disk_path=db._conn.execute('PRAGMA database_list').fetchone()[2]
            from contextlib import closing
            with closing(sqlite3.connect(disk_path)) as reopened:
                persisted=reopened.execute('SELECT replay FROM local_arena_reports WHERE id=?',(match3['matchId'],)).fetchone()[0]
                assert persisted==saved[0]
            assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    finally:
        db.fechar()

print('ARENA_REWARDS_PASSED original score reward and match settlement are once-only')
