"""Painel GM do NinjaAscension (so na propria VPS: http://127.0.0.1:18090).

- Senha em jogo/port/dados/painel_gm_senha.txt (criada na primeira execucao).
- Busca jogador, ve moedas/VIP/bag, da item, moedas e VIP, limpa a bag.
- Antes de cada alteracao faz backup consistente do banco (API SQLite).
- O jogador ve as mudancas ao sair e entrar de novo na conta.
Uso: python jogo/port/server/painel_gm.py
"""
import html, http.server, json, secrets, sqlite3, sys, time, urllib.parse
from pathlib import Path

AQUI = Path(__file__).resolve().parent
DADOS = AQUI.parent / 'dados'
BANCO = DADOS / 'contas.sqlite3'
BACKUPS = DADOS / 'backups_painel'
SENHA_ARQ = DADOS / 'painel_gm_senha.txt'
JOGO = AQUI.parents[1]
sys.path.insert(0, str(AQUI))
import dados_batalha  # noqa: E402

if not SENHA_ARQ.exists():
    SENHA_ARQ.write_text(secrets.token_urlsafe(12), encoding='utf-8')
SENHA = SENHA_ARQ.read_text(encoding='utf-8').strip()
SESSOES = set()
_NOMES = {}


def nome_item(mould):
    if not _NOMES:
        words = {}
        for base in (JOGO / '01_conteudo_apk/assets/res/data/mould/word_mould.txt',
                     JOGO / '01_conteudo_apk/assets/res/language/pt_BR/data/mould/word_mould.txt'):
            if base.exists():
                for line in base.read_text(encoding='utf-8', errors='replace').splitlines():
                    c = line.split('\t')
                    if len(c) > 2:
                        words[c[1]] = c[2]
        for k, row in dados_batalha.tabela('prop_mould.txt').items():
            _NOMES[str(k).strip()] = words.get(row[1], row[1]) if len(row) > 1 else ''
    return _NOMES.get(str(mould), '?')


def conn():
    c = sqlite3.connect(BANCO, timeout=10)
    c.execute('PRAGMA foreign_keys=ON')
    c.execute('CREATE TABLE IF NOT EXISTS local_vip (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, grade INTEGER NOT NULL)')
    return c


def backup(motivo):
    BACKUPS.mkdir(exist_ok=True)
    dst = BACKUPS / ('contas-%s-%s.sqlite3' % (time.strftime('%Y%m%d-%H%M%S'), motivo))
    with sqlite3.connect(BANCO, timeout=10) as s, sqlite3.connect(dst) as b:
        s.backup(b)
        if b.execute('PRAGMA integrity_check').fetchone()[0] != 'ok':
            raise RuntimeError('backup com problema, nada foi alterado')
    for old in sorted(BACKUPS.glob('contas-*.sqlite3'))[:-40]:   # keep the 40 newest
        old.unlink()


def jogadores(c, busca=''):
    q = '%' + busca + '%'
    return c.execute('''SELECT p.conta_id, p.user_name, c.nome, COALESCE(v.grade,0), COALESCE(k.grade,1)
        FROM perfis p JOIN contas c ON c.id=p.conta_id LEFT JOIN local_vip v ON v.conta_id=p.conta_id
        LEFT JOIN local_campaign k ON k.conta_id=p.conta_id
        WHERE p.user_name LIKE ? OR c.nome LIKE ? ORDER BY p.conta_id''', (q, q)).fetchall()


def acao(c, conta, f):
    tipo = f.get('acao', '')
    n = lambda k: int(f.get(k, '0') or 0)
    if tipo == 'item':
        mould, qtd = n('mould'), n('qtd')
        if str(mould) not in dados_batalha.tabela('prop_mould.txt') or qtd == 0:
            return 'Item inexistente ou quantidade zero.'
        backup('item')
        if qtd > 0:
            c.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                      (conta, mould, conta * 1000000 + mould, qtd))
        else:
            c.execute('UPDATE local_inventory SET quantity=quantity+? WHERE conta_id=? AND mould=?', (qtd, conta, mould))
        c.execute('DELETE FROM local_inventory WHERE conta_id=? AND quantity<=0', (conta,))
        return 'Item %s (%s) x%d aplicado.' % (mould, nome_item(mould), qtd)
    if tipo == 'moedas':
        backup('moedas')
        c.execute('UPDATE local_resources SET gold=MAX(0,gold+?), jade=MAX(0,jade+?) WHERE conta_id=?', (n('gold'), n('jade'), conta))
        c.execute('UPDATE local_campaign SET silver=MAX(0,silver+?) WHERE conta_id=?', (n('silver'), conta))
        return 'Moedas aplicadas.'
    if tipo == 'vip':
        vip = max(0, min(20, n('vip')))
        backup('vip')
        c.execute('INSERT INTO local_vip VALUES(?,?) ON CONFLICT(conta_id) DO UPDATE SET grade=excluded.grade', (conta, vip))
        return 'VIP %d definido.' % vip
    if tipo == 'limpar_bag' and f.get('confirmar') == 'LIMPAR':
        backup('limpar_bag')
        c.execute('DELETE FROM local_inventory WHERE conta_id=?', (conta,))
        return 'Bag limpa.'
    if tipo == 'limpar_bag':
        return 'Digite LIMPAR para confirmar.'
    return ''


CSS = '''body{font-family:sans-serif;background:#1b1d22;color:#e8e8e8;margin:0;padding:16px}
a{color:#7cc4ff}table{border-collapse:collapse;width:100%;margin:8px 0}td,th{border:1px solid #333;padding:4px 8px;text-align:left}
input,button{padding:6px;margin:2px;background:#2a2d34;color:#eee;border:1px solid #555;border-radius:4px}
button{background:#3a6ea5;cursor:pointer}.box{background:#24272e;padding:12px;border-radius:8px;margin:10px 0}
.msg{background:#2f5d3a;padding:8px;border-radius:6px}.danger{background:#8a2f2f}'''


def page(body):
    return ('<!doctype html><meta charset=utf-8><title>Painel GM</title><style>%s</style>'
            '<h2>NinjaAscension - Painel GM</h2>%s' % (CSS, body)).encode('utf-8')


class H(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def logged(self):
        ck = self.headers.get('Cookie', '')
        return any(p.strip() == 'gm=' + s for s in SESSOES for p in ck.split(';'))

    def send(self, body, extra=None):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        for k, v in (extra or {}).items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)

    def form(self):
        n = int(self.headers.get('Content-Length', 0) or 0)
        return {k: v[0] for k, v in urllib.parse.parse_qs(self.rfile.read(n).decode()).items()}

    def login_page(self, erro=''):
        self.send(page('<div class=box><form method=post action=/login>Senha: <input type=password name=senha autofocus>'
                       '<button>Entrar</button></form>%s</div>' % ('<p class="msg danger">Senha errada</p>' if erro else '')))

    def do_POST(self):
        u = urllib.parse.urlparse(self.path)
        f = self.form()
        if u.path == '/login':
            if secrets.compare_digest(f.get('senha', ''), SENHA):
                s = secrets.token_urlsafe(24); SESSOES.add(s)
                self.send_response(303); self.send_header('Set-Cookie', 'gm=%s; HttpOnly; SameSite=Strict' % s)
                self.send_header('Location', '/'); self.end_headers(); return
            return self.login_page(True)
        if not self.logged():
            return self.login_page()
        conta = int(f.get('conta', '0') or 0)
        try:
            with conn() as c:
                msg = acao(c, conta, f)
        except Exception as e:  # show the error, change nothing else
            msg = 'Erro: %s' % e
        return self.jogador(conta, msg)

    def do_GET(self):
        u = urllib.parse.urlparse(self.path)
        q = {k: v[0] for k, v in urllib.parse.parse_qs(u.query).items()}
        if not self.logged():
            return self.login_page()
        if u.path == '/jogador':
            return self.jogador(int(q.get('conta', '0') or 0))
        if u.path == '/itens':
            busca = q.get('q', '').lower()
            rows = [(k, nome_item(k)) for k in dados_batalha.tabela('prop_mould.txt')]
            rows = [r for r in rows if busca in r[1].lower() or busca == str(r[0])][:200]
            t = ''.join('<tr><td>%s</td><td>%s</td></tr>' % (k, html.escape(nm)) for k, nm in rows)
            return self.send(page('<a href=/>&larr; jogadores</a><div class=box><form>Buscar item: <input name=q value="%s"><button>Buscar</button></form>'
                                  '<table><tr><th>ID</th><th>Nome</th></tr>%s</table></div>' % (html.escape(busca), t)))
        busca = q.get('q', '')
        with conn() as c:
            rows = jogadores(c, busca)
        t = ''.join('<tr><td>%d</td><td><a href="/jogador?conta=%d">%s</a></td><td>%s</td><td>%d</td><td>%d</td></tr>'
                    % (r[0], r[0], html.escape(r[1]), html.escape(r[2]), r[4], r[3]) for r in rows)
        self.send(page('<div class=box><form>Buscar jogador: <input name=q value="%s"><button>Buscar</button></form> <a href=/itens>Lista de itens</a>'
                       '<table><tr><th>Conta</th><th>Personagem</th><th>Login</th><th>Nivel</th><th>VIP</th></tr>%s</table></div>' % (html.escape(busca), t)))

    def jogador(self, conta, msg=''):
        with conn() as c:
            p = c.execute('SELECT user_name FROM perfis WHERE conta_id=?', (conta,)).fetchone()
            if not p:
                return self.send(page('<a href=/>&larr; voltar</a><p>Conta nao encontrada.</p>'))
            r = c.execute('SELECT gold,jade FROM local_resources WHERE conta_id=?', (conta,)).fetchone() or (0, 0)
            s = c.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (conta,)).fetchone() or (0,)
            vip = c.execute('SELECT grade FROM local_vip WHERE conta_id=?', (conta,)).fetchone() or (0,)
            bag = c.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? ORDER BY mould', (conta,)).fetchall()
        hid = '<input type=hidden name=conta value=%d>' % conta
        t = ''.join('<tr><td>%d</td><td>%s</td><td>%d</td></tr>' % (m, html.escape(nome_item(m)), q) for m, q in bag)
        body = '''<a href=/>&larr; jogadores</a> | <a href=/itens target=_blank>lista de itens</a>
        %s<h3>%s (conta %d)</h3>
        <div class=box>Ouro: <b>%d</b> &nbsp; Joias (jade): <b>%d</b> &nbsp; Prata: <b>%d</b> &nbsp; VIP: <b>%d</b></div>
        <div class=box><form method=post>%s<input type=hidden name=acao value=item>Dar item: ID <input name=mould size=7> Quantidade <input name=qtd size=6 value=1>
        <button>Aplicar</button> <small>(quantidade negativa remove)</small></form></div>
        <div class=box><form method=post>%s<input type=hidden name=acao value=moedas>Somar: Ouro <input name=gold size=8 value=0> Jade <input name=jade size=8 value=0>
        Prata <input name=silver size=10 value=0> <button>Aplicar</button></form></div>
        <div class=box><form method=post>%s<input type=hidden name=acao value=vip>VIP <input name=vip size=3 value=%d> <button>Definir</button></form></div>
        <div class=box><form method=post>%s<input type=hidden name=acao value=limpar_bag>Limpar bag inteira: digite LIMPAR <input name=confirmar size=8>
        <button class=danger>Limpar</button></form></div>
        <div class=box><b>Bag (%d itens)</b><table><tr><th>ID</th><th>Nome</th><th>Qtd</th></tr>%s</table></div>
        <p><small>O jogador ve as mudancas ao sair e entrar de novo.</small></p>''' % (
            '<p class=msg>%s</p>' % html.escape(msg) if msg else '', html.escape(p[0]), conta,
            r[0], r[1], s[0], vip[0], hid, hid, hid, vip[0], hid, len(bag), t)
        self.send(page(body))


if __name__ == '__main__':
    print('Painel GM: http://127.0.0.1:18090  (senha em %s)' % SENHA_ARQ)
    http.server.ThreadingHTTPServer(('127.0.0.1', 18090), H).serve_forever()
