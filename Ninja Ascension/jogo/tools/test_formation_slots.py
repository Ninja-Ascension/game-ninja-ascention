import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='1' # legacy six-character fixture; direct-menu starters have a separate test
with tempfile.TemporaryDirectory(prefix='formation-slots-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('formation_test','Temporary123!')['id']
        uid=str(db.perfil(account)['user_id']);server._sessao_conexao['token']=db.abrir_sessao(account)
        for mould in (1,2,3,4,5):
            db._conn.execute('INSERT INTO local_synthesized VALUES (?,?,?)',(account,mould,account*100000+mould))
        db._conn.commit()
        def request(mould,position,mode='1',extra=True):
            fields=['1','formation_change',uid,str(account*100000+mould),str(position),mode]
            if extra:fields.append('0')
            return server.despacha('\r\n'.join(fields))
        for mould,position in zip((1,2,3,4,5),(1,3,4,5,6)):
            assert request(mould,position).startswith('1 formation_change 0 ')
        slots=heroes.formation_tokens(db,account)[2:8]
        assert len(set(slots))==6 and '0' not in slots,slots
        assert request(1,6).startswith('1 formation_change 0 ')
        swapped=heroes.formation_tokens(db,account)[2:8]
        assert swapped[5]==str(account*100000+1) and swapped[0]==str(account*100000+5)
        assert len(set(swapped))==6
        assert request(1,6,'-1').startswith('1 formation_change 0 ')
        assert heroes.formation_tokens(db,account)[7]=='0'
        final_reply=request(1,6,extra=False)
        assert final_reply.startswith('1 formation_change 0 ')
        (root/'build/formation-six-reply.txt').write_text(final_reply,encoding='utf8')
        assert ' -1 ' in request(1,7)
        assert ' -1 ' in request(9999,1)
        (root/'build/formation-six-login.txt').write_text(server.resposta_login_init('2',''),encoding='utf8')
        path=db.caminho;db.fechar()
        from contas import Banco
        db=Banco(path)
        assert len(set(heroes.formation_tokens(db,account)[2:8]))==6
    finally:db.fechar()
print('FORMATION_SLOTS_PASSED actual five-field request, six heroes, swap, removal, legacy request, ownership and relogin')
