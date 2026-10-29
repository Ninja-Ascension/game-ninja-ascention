"""Avatar change and original player EXP rule (temporary database, tutorial off)."""
import os, sys, tempfile
from pathlib import Path
root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'
with tempfile.TemporaryDirectory(prefix='perfil-nivel-', dir=root / 'build', ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import profile_local, player_level_local as nivel
    import dados_batalha as data
    db = server.BANCO
    try:
        conta = db.criar_conta('perfil_nivel', 'Senha123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(conta)
        uid = str(db.perfil(conta)['user_id'])
        def req(cmd, *args):
            return server.despacha('\r\n'.join(['7', cmd, uid] + list(map(str, args))))
        def login_field(n):
            # numbered fields of local_server.resposta_login_init; field 18 is
            # the (unique) character name, used as the anchor
            t = server.resposta_login_init('9', '').split(' ')
            return t[t.index(profile_local.wire_name(db.perfil(conta)['user_name'])) + n - 18]

        # ---- avatar
        assert login_field(31) == '1'
        livres = profile_local.allowed_heads(db, conta)
        assert {1, 2, 3, 4, 5, 6, 7, 8} <= livres, livres
        heroi = max(livres - set(range(1, 9)))          # avatar of an owned starter ninja
        assert req('user_info_modify', 1, heroi) == '7 user_info_modify 0'
        assert login_field(31) == str(heroi)
        assert req('user_info_modify', 1, 999999).split(' ')[2] == '-1'   # not unlocked
        assert req('user_info_modify', 1, 'abc').split(' ')[2] == '-1'
        assert login_field(31) == str(heroi)
        assert req('user_info_modify', 2, 'x').split(' ')[2] == '-1'      # other types still refused

        # ---- EXP: level 1 needs table[2]; login never sends "l1e0"
        assert login_field(19) == '1' and login_field(30) == str(nivel.necessario(1)) and login_field(29) == '1'
        assert login_field(21) == str(nivel.capacidade_energia(1))
        custo = int(data.tabela('npc.txt')['1'][118])
        assert custo > 0
        assert req('battle_result_start', 0, 1, 1, 1, '1,4001,1,2') == '7 battle_result_start 0'
        r = req('battle_result_verify', 0, 1, '1-1', 3, 1, 1).split(' ')
        grade, exp, need = nivel.estado(db, conta)
        # level 2 needs 7, a 6-energy battle leaves level 1 with 6 EXP
        assert (grade, exp) == ((1, custo) if custo < nivel.necessario(1) else (grade, exp)), (grade, exp)
        assert '41' in r and r[r.index('41') + 1] == str(exp), r
        # repeated result for the same battle: same answer, no extra EXP
        r2 = req('battle_result_verify', 0, 1, '1-1', 3, 1, 1)
        assert r2.split(' ')[2] == '0' and nivel.estado(db, conta)[1] == exp, r2
        # second battle crosses level 2: parser 40 sent, energy reward applied
        comida_antes = db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?', (conta,)).fetchone()[0]
        assert req('battle_result_start', 0, 1, 1, 1, '1,4001,1,2') == '7 battle_result_start 0'
        r = req('battle_result_verify', 0, 1, '1-1', 3, 1, 1).split(' ')
        grade, exp, need = nivel.estado(db, conta)
        assert grade == 2 and exp == 2 * custo - nivel.necessario(1), (grade, exp)
        assert r[r.index('40') + 1:r.index('40') + 3] == ['2', str(nivel.necessario(2))], r
        bonus = int(data.tabela('user_experience_param.txt')['2'][8])
        assert db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?', (conta,)).fetchone()[0] == comida_antes + bonus
        assert '29' in r and r[r.index('29') + 1] == str(bonus), r
        assert login_field(19) == '2' and login_field(29) == str(exp) and login_field(30) == str(nivel.necessario(2))
        # a big gain crosses several levels at once; max level clamps
        with db._conn: g, e, n, subiu, _ = nivel.ganhar(db, conta, 10_000_000)
        assert g == nivel.nivel_maximo() and e == 0 and subiu
        print('PERFIL_E_NIVEL_PASSED avatar validate/persist, EXP=energy, level-up 40/41/29, retry-safe, max level')
    finally:
        db._conn.close()
