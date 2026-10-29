"""Login automatico: token lembrado entra, e trocado a cada uso; token velho -> -68."""
import os, re, sys, tempfile
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
os.environ['NR_EXIGIR_SESSAO'] = '1'
with tempfile.TemporaryDirectory(prefix='login-auto-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    db = server.BANCO
    try:
        assert server.MODO_PUBLICO
        db.criar_conta('autologin', 'Senha123!')
        def login(segredo):
            return server.despacha('\r\n'.join(['5', 'platform_user_login', 'autologin', segredo, '']))
        def token(resp):
            achados = [t for t in resp.split(' ') if re.fullmatch(r'[\w-]{43}', t)]
            assert len(achados) == 1, resp
            return achados[0]
        r = login('Senha123!'); assert r.split(' ')[2] == '0', r
        t1 = token(r)
        r = login('@tk1:' + t1); assert r.split(' ')[2] == '0', r          # entrada automatica
        t2 = token(r); assert t2 != t1
        r = login('@tk1:' + t1); assert r.split(' ')[2] == '-68', r        # token velho
        r = login('@tk1:' + 'x' * 43); assert r.split(' ')[2] == '-68', r  # token inventado
        r = login('senha-errada'); assert r.split(' ')[2] == '-1', r       # senha errada: igual antes
        r = login('@tk1:' + t2); assert r.split(' ')[2] == '0', r
        print('LOGIN_AUTOMATICO_PASSED token lembrado entra e e trocado; vencido/inventado -> -68')
    finally:
        db._conn.close()
