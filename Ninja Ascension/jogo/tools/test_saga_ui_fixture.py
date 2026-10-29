"""Create a visual fixture with real protocol data in a private SQLite DB."""
import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='saga-ui-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import saga_local as saga
    db=server.BANCO
    try:
        account=db.criar_conta('saga_ui','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account)
        with db._conn:
            db._conn.execute('INSERT INTO local_campaign VALUES (?,120,1000000)',(account,))
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)',(account,))
            db._conn.execute('UPDATE local_resources SET gold=41977 WHERE conta_id=?',(account,))
            db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?)',(account,2105,account*1000000+2105,2))
            saved=saga.draw_state(db,account);saved.update(normal_used=50,advance_used=11,total_advance=72,normal_free=1,advance_free=1)
            saga.save_draw(db,account,saved)
        (root/'build/saga-ui-login.txt').write_text(server.resposta_login_init('1','')+' '+' '.join(saga.init_tokens(db,account)),encoding='utf8')
    finally:db.fechar()
print('SAGA_UI_FIXTURE_READY private DB only')
