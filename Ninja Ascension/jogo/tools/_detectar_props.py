import importlib
import os
import sys
import tempfile

sys.path.insert(0, 'N:/port/server')
os.environ['NR_ACCOUNTS_DIR'] = tempfile.mkdtemp(dir='N:/build')
srv = importlib.import_module('local_server')
db = srv.BANCO
cid = db.criar_conta('deteccao_props', 'Temporary123!')['id']
print('conta criada:', cid)

with db._lock:
    for n, (m, q) in enumerate([(68, 3), (69, 1), (70, 5)], 1):
        db._conn.execute(
            'INSERT INTO local_inventory(conta_id,mould,instance_id,quantity) VALUES(?,?,?,?)',
            (cid, m, cid * 100000 + n, q))
    db._conn.commit()

linhas = db._conn.execute(
    'SELECT mould,instance_id,quantity FROM local_inventory WHERE conta_id=?', (cid,)).fetchall()
print('no banco:', [(r[0], r[1], r[2]) for r in linhas])

tok = db.abrir_sessao(cid)
srv.lembrar_token(tok)
partes = srv.despacha('8\r\nlogin_init\r\n').split()

achados = []
for i in range(len(partes) - 7):
    cand = partes[i:i + 7]
    if cand[0].isdigit() and len(cand[0]) >= 6 and cand[1].isdigit():
        achados.append((i, cand))

print('candidatos:')
for i, c in achados[:6]:
    print('  idx %d: %r' % (i, c))
