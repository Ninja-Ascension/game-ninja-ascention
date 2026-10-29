"""Display name persistence and validation in a private account database."""
import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='profile-test-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as s
    import profile_local
    db=s.BANCO
    try:
        assert 'user_info_modify' in s.MINIMOS,'Rename handler missing on server startup'
        account=db.criar_conta('profile_test','Temporary123!')['id']
        s._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        def rename(value,user=uid,kind='0'):
            return s.despacha('\r\n'.join(['9','user_info_modify',user,kind,value]))
        assert rename('Ninja&nbsp;&amp;&nbsp;Teste')=='9 user_info_modify 0 12033 '+uid+' Ninja&nbsp;&amp;&nbsp;Teste'
        assert db.perfil(account)['user_name']=='Ninja & Teste'
        assert s.despacha('11\r\nregister\r\nprofile_test\r\nx\r\nx\r\nKage_Ninja').startswith('11 register 0 ')
        assert db.perfil(account)['user_name']=='Ninja & Teste','Repeated register replaced the edited name'
        assert 'Ninja&nbsp;&amp;&nbsp;Teste' in s.resposta_login_init('10','')
        for value,user,kind in [('x','999','0'),('x',uid,'1'),('',uid,'0'),('a'*21,uid,'0'),('A&#10;B',uid,'0')]:
            assert ' -1 ' in rename(value,user,kind)
        assert db.perfil(account)['user_name']=='Ninja & Teste'
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:assert db.perfil(account)['user_name']=='Ninja & Teste'
    finally:db.fechar()
print('PROFILE_LOCAL_PASSED rename, protocol, validation, relogin, database reopen')
