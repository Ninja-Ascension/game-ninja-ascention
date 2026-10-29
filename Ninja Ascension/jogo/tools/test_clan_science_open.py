"""The clan Donation/Research Institute panel gets parser 14627 from source data."""
import os
import sys
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port' / 'server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'

with tempfile.TemporaryDirectory(prefix='clan-science-', dir=root / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    db = server.BANCO
    try:
        account = db.criar_conta('clan_science_test', 'Temporary123!')['id']
        token = db.abrir_sessao(account)
        server._sessao_conexao['token'] = token
        uid = str(db.perfil(account)['user_id'])
        with db._lock, db._conn:
            db._conn.execute("INSERT INTO local_clan(name,created,level,exp) VALUES ('ScienceTest',1,4,125)")
            clan = db._conn.execute('SELECT id FROM local_clan WHERE name=?', ('ScienceTest',)).fetchone()[0]
            db._conn.execute('INSERT INTO local_clan_member VALUES (?,?,3,0,1)', (account, clan))
        reply = server.despacha('\r\n'.join(['7', 'union_science_init', uid, str(clan)]))
        fields = reply.split()
        assert fields[:3] == ['7', 'union_science_init', '0'], reply
        assert fields[3] == '14627', reply
        assert len(fields[4].split('|')) == len(fields[5].split('|')) == 9, reply
        assert fields[4].split('|')[0] == '4,125,0,0,0,0', reply
        assert fields[4].split('|')[1:] == ['1,0,0,0,0,0'] * 8, reply
        assert fields[5].split('|') == ['0,0,0,0,0,0'] * 9, reply
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    finally:
        db._conn.close()

print('CLAN_DONATION_PANEL_PASSED original parser shape and clan baseline from temporary DB')
