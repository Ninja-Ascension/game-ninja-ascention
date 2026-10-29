import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'));os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='dinner-',dir=root/'build') as folder:
 os.environ['NR_ACCOUNTS_DIR']=folder
 import local_server as server
 import energia
 db=server.BANCO
 try:
  account=db.criar_conta('dinner_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account)
  uid=str(db.perfil(account)['user_id']);server.resposta_login_init('1','')
  with db._lock,db._conn:
   db._conn.execute('UPDATE perfis SET criada_em=0 WHERE conta_id=?',(account,))
   db._conn.execute('UPDATE local_resources SET food=60,gold=100 WHERE conta_id=?',(account,))
  actual=energia.cycle;day,seconds,origin=actual()
  energia.cycle=lambda:(day,10*3600,origin)
  def call(slot):return server.despacha('2\r\ndinner_time\r\n'+uid+'\r\n'+str(slot))
  def wallet():return tuple(db._conn.execute('SELECT food,gold FROM local_resources WHERE conta_id=?',(account,)).fetchone())
  reply=call(1);assert reply.startswith('2 dinner_time 0 29 60 120 '),reply
  assert wallet()==(120,100)
  assert call(1).startswith('2 dinner_time 0 29 0 120 ') and wallet()==(120,100)
  assert ' -1 ' in call(2) and wallet()==(120,100)
  energia.cycle=lambda:(day,22*3600,origin)
  assert call(3).startswith('2 dinner_time 0 29 60 180 ') and wallet()==(180,80)
  assert call(3).startswith('2 dinner_time 0 29 0 180 ') and wallet()==(180,80)
  assert server.despacha('2\r\ndinner_init\r\n'+uid+'\r\n').startswith('2 dinner_init 0 194 ')
  state=server.despacha('2\r\npower_swallow\r\n'+uid+'\r\n');assert state.split()[-1].split('|')[0].startswith('1,') and state.split()[-1].split('|')[2].startswith('1,')
  energia.cycle=lambda:(day+'-test',22*3600,origin+86400)
  with db._lock,db._conn:db._conn.execute('UPDATE local_resources SET gold=0 WHERE conta_id=?',(account,))
  assert ' -1 ' in call(1) and wallet()==(180,0)
  assert ' -1 ' in call(0)
  assert ' -1 ' in server.despacha('2\r\ndinner_time\r\n999999\r\n1')
  assert not db._conn.execute('SELECT 1 FROM local_energy_claims WHERE day=?',(day+'-test',)).fetchone()
  energia.cycle=actual
  print('DINNER_TIME_PASSED original 60 stamina, free/paid windows, future refusal, retry without duplicate charge, persistent flags, balance refusal and identity')
 finally:db._conn.close()
