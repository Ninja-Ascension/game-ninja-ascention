"""Two players at the same time against a real server in PUBLIC mode.

Runs on a temporary database and listens only on 127.0.0.1 (NR_EXIGIR_SESSAO=1
turns on the public-mode rules without exposing anything).
"""
import os, subprocess, sys, tempfile, time, urllib.request, socket
from pathlib import Path
root = Path(__file__).resolve().parents[1]
PORT = 18182

sys.path.insert(0, str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='sessao-', dir=root/'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = os.path.join(folder, 'cliente')  # only for importing wrap/unwrap
    os.makedirs(os.environ['NR_ACCOUNTS_DIR'])
    import local_server as codec
    env = {k: v for k, v in os.environ.items() if not k.startswith('NR_')}
    env.update(NR_ACCOUNTS_DIR=folder, NR_PORT=str(PORT), NR_EXIGIR_SESSAO='1', NR_ENABLE_TUTORIAL='0')
    proc = subprocess.Popen([sys.executable, '-u', str(root/'port/server/local_server.py')], cwd=str(root), env=env,
                            stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
    try:
        for _ in range(80):
            try: socket.create_connection(('127.0.0.1', PORT), 0.2).close(); break
            except OSError: time.sleep(0.25)
        else: raise SystemExit('servidor nao subiu: ' + proc.stderr.read().decode(errors='replace')[-800:])

        def call(lines, token=None, text_wire=True):
            url = 'http://127.0.0.1:%d/iniServer' % PORT + ('?s=' + token if token else '')
            url += ('&' if '?' in url else '?') + 'nr_transport=text-v1' if text_wire else ''
            text = '\r\n'.join(lines)
            body = text.encode() if text_wire else codec.wrap(text)
            with urllib.request.urlopen(urllib.request.Request(url, body, method='POST'), timeout=30) as r:
                raw = r.read()
                return raw.decode() if text_wire else codec.unwrap(raw)

        request = ['0','new_get_server_list','test','op,platform,account','pkg,0.0']
        assert call(request) == call(request, text_wire=False)
        assert call(['0','operation_unknown_for_test']).split()[2] == '-3'
        tokens = {}
        for name in ('jogadorA', 'jogadorB'):
            assert call(['1', 'platform_user_register', name, 'Senha123!', 'Senha123!', 'pkg']).split(' ')[2] == '0'
            reply = call(['2', 'platform_user_login', name, 'Senha123!', 'pkg']).split(' ')
            assert reply[2] == '0' and reply[3] == '327', reply
            tokens[name] = reply[5]
        for name in tokens:
            for text_wire in (True,False):
                registered=call(['20','vali_register',name,'999'],tokens[name],text_wire=text_wire).split()
                assert registered[:6]==['20','vali_register','0','57','2','1'],registered
                assert int(registered[6])>0 and registered[7]==name,registered
        for text_wire in (True,False):
            reply=call(['21','login_init'],tokens['jogadorA'],text_wire=text_wire)
            assert reply.split()[2]=='0' and 'jogadorA' in reply and 'jogadorB' not in reply
            clock=reply.split()[3:6]
            assert clock[0]=='12001' and int(clock[1])>=int(clock[2])>0,clock
        # No saved account is handed out without a key.
        assert call(['3', 'search_user_platform']) == '3 search_user_platform 0'
        # A remembered-login with a wrong key no longer issues a session.
        assert call(['4', 'platform_user_login', 'jogadorA', '@tk1:' + 'x'*43, 'pkg']).split(' ')[2] == '-68'   # recusado; -68 faz o cliente esquecer o token
        # Wrong password still refused.
        assert call(['4', 'platform_user_login', 'jogadorA', 'errada', 'pkg']).split(' ')[2] == '-1'

        # Each key opens its own account, interleaved, without crossing.
        login_a = call(['5', 'login_init'], tokens['jogadorA'])
        login_b = call(['6', 'login_init'], tokens['jogadorB'])
        assert login_a.split(' ')[2] == '0' and login_b.split(' ')[2] == '0'
        assert 'jogadorA' in login_a and 'jogadorB' not in login_a
        assert 'jogadorB' in login_b and 'jogadorA' not in login_b
        assert call(['7', 'login_init'], tokens['jogadorA']).count('jogadorA') == login_a.count('jogadorA')
        # Without a key, or with an invented one, there is no identity.
        assert call(['8', 'login_init']).split(' ')[2] == '-1'
        assert call(['9', 'login_init'], 'y'*43).split(' ')[2] == '-1'
        # The search with a key returns that player's own account.
        found = call(['10', 'search_user_platform'], tokens['jogadorB']).split(' ')
        assert found[3] == '327' and found[4].lower() == 'jogadorb', found
        print('ANDROID_HTTP_TRANSPORT_PASSED text/binary server lists and login match; two temporary accounts isolated; invalid sessions and unknown operation rejected')
    finally:
        proc.terminate(); proc.wait(10)
        codec.BANCO._conn.close()
