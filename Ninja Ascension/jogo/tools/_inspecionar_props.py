import importlib
import os
import sys
import tempfile

sys.path.insert(0, 'N:/port/server')
os.environ['NR_ACCOUNTS_DIR'] = tempfile.mkdtemp(dir='N:/build')
srv = importlib.import_module('local_server')
db = srv.BANCO
cid = db.criar_conta('inspecao_props', 'Temporary123!')['id']

with db._lock:
    for n, (m, q) in enumerate([(68, 3), (69, 1)], 1):
        db._conn.execute(
            'INSERT INTO local_inventory(conta_id,mould,instance_id,quantity) VALUES(?,?,?,?)',
            (cid, m, cid * 100000 + n, q))
    db._conn.commit()

tok = db.abrir_sessao(cid)
srv.lembrar_token(tok)
r = srv.despacha('8\r\nlogin_init\r\n').split()
print('total tokens:', len(r))
for i, v in enumerate(r[:6], 1):
    print('  %d: %r' % (i, v))
print('posicoes de 68:', [i for i, v in enumerate(r) if v == '68'])
print('posicoes de 69:', [i for i, v in enumerate(r) if v == '69'])
print('contexto ao redor do 68:')
for i, v in enumerate(r):
    if v == '68':
        print('   ', r[max(0, i - 3):i + 9])
