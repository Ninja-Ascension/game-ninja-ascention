"""Ninja Soul equipment uses a disposable database; never live accounts."""
import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='soul-test-',dir=root/'build') as folder:
 os.environ['NR_ACCOUNTS_DIR']=folder
 import local_server as server
 import fight_spirit_local as soul
 import recruitment_local as heroes
 import hero_stats_local as stats
 db=server.BANCO
 try:
  account=db.criar_conta('soul_test','Temporary123!')['id']
  server._sessao_conexao['token']=db.abrir_sessao(account)
  uid=str(db.perfil(account)['user_id']);server.resposta_login_init('1','')
  ship,mould=heroes.all_owned(db,account)[0]
  with db._lock,db._conn:
   ids=soul.grant_test_set(db,account,'fixture')
   assert soul.grant_test_set(db,account,'fixture')==ids
  assert len(soul.owned(db,account))==4
  before=stats.effective(db,account,ship,mould)
  def call(command,*args):
   return server.despacha('2\r\n'+command+'\r\n'+uid+('\r\n'+'\r\n'.join(map(str,args)) if args else ''))
  assert call('fight_spirit_init').startswith('2 fight_spirit_init 0 14130 4 ')
  values=','.join(map(str,ids))
  reply=call('fight_spirit_change',ship,values,'equip')
  assert reply.startswith('2 fight_spirit_change 0 '),reply
  assert call('fight_spirit_change',ship,values,'equip')==reply
  assert soul.seats(db,account)[ship]==ids
  after=stats.effective(db,account,ship,mould)
  assert after['health']>before['health']
  assert ' -1 ' in call('fight_spirit_change',ship,','.join(map(str,ids[::-1])),'wrong-slot')
  assert soul.seats(db,account)[ship]==ids
  assert call('fight_spirit_lock',ids[0],1,'lock').startswith('2 fight_spirit_lock 0 ')
  assert call('fight_spirit_change',ship,'-1,-1,-1,-1','remove').startswith('2 fight_spirit_change 0 ')
  assert stats.effective(db,account,ship,mould)['health']==before['health']
  assert len(soul.owned(db,account))==4
  print('FIGHT_SPIRIT_TEST_PASSED grant once, initialize, equip, retry, wrong slot refusal, lock, remove, stats restored')
 finally:db._conn.close()
