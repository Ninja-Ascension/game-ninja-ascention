"""Character names are unique per server (temporary database)."""
import os, sys, tempfile
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='nomes-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    db = server.BANCO
    try:
        a = db.criar_conta('jogador_a', 'Senha123!')['id']
        b = db.criar_conta('jogador_b', 'Senha123!')['id']
        def entrar(conta):
            server._sessao_conexao['token'] = db.abrir_sessao(conta)
            server._pedido.token = None
            return db.perfil(conta)
        # create character with the same chosen name on both accounts
        pa = entrar(a)
        assert server.despacha('\r\n'.join(['1', 'register', 'jogador_a', '0', '0', 'Kage_Ninja'])).split(' ')[2] == '0'
        pb = entrar(b)
        assert server.despacha('\r\n'.join(['1', 'register', 'jogador_b', '0', '0', 'kage_ninja'])).split(' ')[2] == '0'
        na, nb = db.perfil(a)['user_name'], db.perfil(b)['user_name']
        assert na == 'Kage_Ninja' and nb.lower() != na.lower() and nb.lower().startswith('kage_ninja'), (na, nb)
        # explicit rename to a taken name is refused, to a free one accepted
        entrar(b)
        uid = str(db.perfil(b)['user_id'])
        r = server.despacha('\r\n'.join(['2', 'user_info_modify', uid, '0', 'KAGE_NINJA']))
        assert r.split(' ')[2] == '-1', r
        assert db.perfil(b)['user_name'] == nb
        r = server.despacha('\r\n'.join(['3', 'user_info_modify', uid, '0', 'Itachi&nbsp;Uchiha']))
        assert r.split(' ')[2] == '0' and db.perfil(b)['user_name'] == 'Itachi Uchiha', r
        # suggested random names never collide with names in use
        for _ in range(60):
            nome = server.despacha('\r\n'.join(['4', 'get_random_name', '0'])).split(' ')[4]
            assert not db.apelido_em_uso(nome), nome
        print('NOMES_UNICOS_PASSED register suffix, rename refusal, case-insensitive, random suggestion')
    finally:
        db._conn.close()
