import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'));os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='recruit-shop-',dir=root/'build') as folder:
 os.environ['NR_ACCOUNTS_DIR']=folder
 import local_server as server
 import recruit_shop_local as shop
 import normal_recruit as recruit
 db=server.BANCO
 try:
  a=db.criar_conta('recruit_shop_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(a)
  server.resposta_login_init('1','');uid=str(db.perfil(a)['user_id'])
  with db._lock,db._conn:db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=excluded.quantity',(a,3105,a*1000000+3105,400))
  def buy(offer,n,key):return server.despacha('2\r\nnew_recruitment_shop_buy\r\n'+uid+'\r\n'+str(offer)+'\r\n'+str(n)+'\r\n'+key)
  def balance():return db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=3105',(a,)).fetchone()[0]
  first=buy(1,1,'first');assert first.startswith('2 new_recruitment_shop_buy 0 '),first
  assert balance()==250 and buy(1,1,'first')==first and balance()==250
  assert db._conn.execute('SELECT count(*) FROM local_synthesized WHERE conta_id=? AND mould=317',(a,)).fetchone()[0]==1
  assert buy(1,1,'second').startswith('2 new_recruitment_shop_buy 0 ')
  assert balance()==100 and shop.remaining(db,a).split(',')[0]=='0'
  assert ' -1 ' in buy(1,1,'over-limit') and balance()==100
  assert ' -1 ' in buy(2,1,'insufficient') and balance()==100
  assert ' -1 ' in buy(2,1,'first') and balance()==100
  fragment,_=recruit.fragment(317)
  assert db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(a,fragment)).fetchone()[0]>0
  print('RECRUIT_SHOP_PASSED original cost, new hero, duplicate conversion, receipt replay, weekly cap and balance refusal')
 finally:db._conn.close()
