"""Isolated test of recovered mission 2010133; no player database access."""
from pathlib import Path
import os,sys,tempfile
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='intro-reward-',dir=root/'build') as folder:
 os.environ['NR_ACCOUNTS_DIR']=folder
 import local_server as server
 db=server.BANCO
 try:
  a=db.criar_conta('intro_test_a','Temporary123!')
  b=db.criar_conta('intro_test_b','Temporary123!')
  aid,bid=a['id'],b['id']
  token=db.abrir_sessao(aid)
  server._sessao_conexao['token']=token
  uid=str(db.perfil(aid)['user_id'])
  request='1\r\nget_resource\r\n'+uid+'\r\n8-0,1'
  assert server.resposta_get_resource('1',request)=='1 get_resource 0 41 1'
  assert server.resposta_get_resource('2',request)=='2 get_resource 0 41 1'
  assert db.experiencia_tutorial(aid)==1 and db.experiencia_tutorial(bid)==0
  assert ' -1 ' in server.resposta_get_resource('3','3\r\nget_resource\r\n'+str(db.perfil(bid)['user_id'])+'\r\n8-0,1')
  assert ' -1 ' in server.resposta_get_resource('4','4\r\nget_resource\r\n'+uid+'\r\n8-0,999')
  db.revogar_sessao(token)
  assert ' -1 ' in server.resposta_get_resource('5',request)
  path=db._conn.execute('PRAGMA database_list').fetchone()[2]
 finally: db.fechar()
 from contas import Banco
 reopened=Banco(path)
 try: assert reopened.experiencia_tutorial(aid)==1 and reopened.experiencia_tutorial(bid)==0
 finally: reopened.fechar()
print('INTRO_REWARD_PASSED exact reward, retries, account isolation, auth, persistence')
