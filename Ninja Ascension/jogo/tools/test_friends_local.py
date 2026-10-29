"""Friend request, accept and reciprocal-list checks using a temporary DB."""
import os, sys, tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port' / 'server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'

with tempfile.TemporaryDirectory(prefix='friends-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    db = server.BANCO
    try:
        a = db.criar_conta('friend_a', 'Senha123!')['id']
        b = db.criar_conta('friend_b', 'Senha123!')['id']
        uid_a, uid_b = str(db.perfil(a)['user_id']), str(db.perfil(b)['user_id'])

        def req(account, command, *args):
            server._sessao_conexao['token'] = db.abrir_sessao(account)
            uid = str(db.perfil(account)['user_id'])
            return server.despacha('\r\n'.join(['7', command, uid, *map(str, args)]))

        reply = req(a, 'friend_request', uid_b, 1)
        assert reply.split(' ')[2] == '0', reply
        assert db._conn.execute('SELECT COUNT(*) FROM local_friend_request WHERE sender=? AND target=?', (a, b)).fetchone()[0] == 1
        inbox = req(b, 'friend_update')
        assert inbox.split(' ').index('378') >= 0 and uid_a in inbox, inbox

        accepted = req(b, 'friend_pass', uid_a, 1)
        assert accepted.split(' ')[2] == '0', accepted
        assert db._conn.execute('SELECT COUNT(*) FROM local_friend WHERE (a=? AND b=?) OR (a=? AND b=?)', (a, b, b, a)).fetchone()[0] == 2
        assert req(a, 'friend_update').split(' ')[2] == '0'
        assert req(b, 'friend_update').split(' ')[2] == '0'

        # Gift stamina using the original 198/199/200 response parsers.
        sent = req(a, 'present_endurance', uid_b)
        assert sent.split(' ')[2] == '0' and '198 %s 1' % uid_b in sent, sent
        assert req(a, 'present_endurance', uid_b).split(' ')[2] == '0'  # repeat is not a second gift
        assert db._conn.execute('SELECT COUNT(*) FROM local_friend_endurance WHERE sender=? AND target=?', (a, b)).fetchone()[0] == 1
        refreshed = req(a, 'friend_update').split()
        assert refreshed[refreshed.index(uid_b) + 8] == '1', refreshed
        gifts = req(b, 'draw_endurance_init').split()
        parser = gifts.index('199')
        assert gifts[parser + 1:parser + 3] == ['20', '1'], gifts
        gift_id = gifts[parser + 3]
        food_row = db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?', (b,)).fetchone()
        before_food = food_row[0] if food_row else 0
        claimed = req(b, 'draw_endurance', gift_id, 1)
        assert claimed.split(' ')[2] == '0' and '29 3 %d' % (before_food + 3) in claimed, claimed
        assert db._conn.execute('SELECT claimed FROM local_friend_endurance WHERE id=?', (gift_id,)).fetchone()[0] == 1
        assert req(b, 'draw_endurance', gift_id, 1).split(' ')[2] == '0'
        assert db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?', (b,)).fetchone()[0] == before_food + 3

        removed = req(a, 'friend_del', uid_b)
        assert removed.split(' ')[2] == '0', removed
        assert db._conn.execute('SELECT COUNT(*) FROM local_friend WHERE a IN (?,?) AND b IN (?,?)', (a, b, a, b)).fetchone()[0] == 0
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
        print('FRIENDS_PASSED request/accept/remove, send/receive stamina, repeat safety, temporary SQLite integrity ok')
    finally:
        db._conn.close()
