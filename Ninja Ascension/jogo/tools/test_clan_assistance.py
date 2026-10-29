"""Clan assistance protocol and original reward 76, using only a temp SQLite DB."""
import json
import os
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'port' / 'server'))

with tempfile.TemporaryDirectory(prefix='clan-assistance-', dir=ROOT / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    os.environ['NR_ENABLE_TUTORIAL'] = '0'
    import local_server as server
    import clan_assistance_local as assistance

    db = server.BANCO
    try:
        requester = db.criar_conta('assist_requester', 'Temporary123!')['id']
        donor = db.criar_conta('assist_donor', 'Temporary123!')['id']
        assistance.install(server)
        with db._lock, db._conn:
            clan_id = db._conn.execute(
                "INSERT INTO local_clan(name,created) VALUES ('AssistanceTest',1)").lastrowid
            db._conn.execute('INSERT INTO local_clan_member VALUES (?,?,1,0,1)',
                             (requester, clan_id))
            db._conn.execute('INSERT INTO local_clan_member VALUES (?,?,3,0,1)',
                             (donor, clan_id))
            for account in (requester, donor):
                db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)',
                                 (account,))
                db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)',
                                 (account,))
            prop = 25  # Original prop_mould row, fragment for ship mould 24 (ability 15).
            for account, quantity in ((requester, 1), (donor, 1)):
                db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?)',
                                 (account, prop, account * 1000000 + prop, quantity))

        requester_uid = db.perfil(requester)['user_id']
        donor_uid = db.perfil(donor)['user_id']
        requester_token = db.abrir_sessao(requester)
        donor_token = db.abrir_sessao(donor)

        def send(token, command, body):
            server._pedido.token = token
            return server.MINIMOS[command](1, '1\r\n' + command + '\r\n' + body)

        request_reply = send(requester_token, 'union_assistance_seek_help',
                             f'{requester_uid}\r\n{requester * 1000000 + prop}')
        assert 'union_assistance_seek_help 0 14679' in request_reply
        info = json.loads(request_reply.split('14679 ', 1)[1].split(' 1001', 1)[0])
        assert info['myAssistanceInfo'][0]['askPropId'] == prop
        assert info['myAssistanceInfo'][0]['gotPropNum'] == 0

        before = db._conn.execute(
            'SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',
            (donor, prop)).fetchone()[0]
        donation_reply = send(donor_token, 'union_assistance_donate',
                              f'{donor_uid}\r\n{requester_uid}\r\n6,{prop},1')
        assert 'union_assistance_donate 0 14679' in donation_reply
        after = db._conn.execute(
            'SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',
            (donor, prop)).fetchone()[0]
        # The donation spends one 25; the official reward 76 returns one 25,
        # so the net inventory count matches the original balance.
        assert after == before
        assert db._conn.execute(
            'SELECT got FROM local_clan_assistance_request WHERE conta_id=?',
            (requester,)).fetchone()[0] == 1
        assert db._conn.execute(
            'SELECT contribution FROM local_clan_member WHERE conta_id=?',
            (donor,)).fetchone()[0] == 80
        assert '171 7 5' in donation_reply
        assert db._conn.execute(
            'SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=25',
            (donor,)).fetchone()[0] == 1
        assert db._conn.execute(
            'SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=239',
            (donor,)).fetchone()[0] == 1
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    finally:
        db.fechar()

print('CLAN_ASSISTANCE_PASSED request, donation, configured contribution, reward 76, temp DB integrity')
