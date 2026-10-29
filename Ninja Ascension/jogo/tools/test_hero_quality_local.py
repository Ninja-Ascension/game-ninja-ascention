import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'));os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='quality-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import hero_quality_local as quality
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('quality_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account);uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','')
        with db._conn:
            db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,100,10000000)',(account,))
            elite=[int(r[0]) for r in quality.data.tabela('ship_mould.txt').values() if r[8]=='17'][:6]
            for index,mould in enumerate(elite,1):
                ship=1000000000+account*100000+mould
                db._conn.execute('INSERT INTO local_synthesized VALUES (?,?,?)',(account,mould,ship))
                db._conn.execute('INSERT INTO local_formation_slots VALUES (?,?,?)',(account,index,ship))
            for ship,mould in heroes.all_owned(db,account):
                db._conn.execute('INSERT INTO local_ship_rank VALUES (?,?,0,100)',(account,ship))
                for row in quality.requirements(mould):
                    for i in (2,4,6,8,10):
                        prop=int(row[i])
                        if prop>0:db._conn.execute('INSERT OR IGNORE INTO local_inventory VALUES (?,?,?,100000)',(account,prop,account*1000000+prop))
        def request(ship,props,count,key):return server.despacha('\r\n'.join(['2','ship_grow_up',uid,str(ship),'',props,'',str(count),key]))
        for ship,mould in heroes.all_owned(db,account):
            rows=quality.requirements(mould);initial=quality.quality(db,account,ship,mould)
            row=rows[initial];props=','.join(str(account*1000000+int(row[i])) for i in (2,4,6,8,10) if int(row[i])>0 and int(row[i+1])>0)+','
            before=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
            key='advance-'+str(ship);reply=request(ship,props,1,key)
            assert reply.startswith('2 ship_grow_up 0 '),reply
            assert quality.quality(db,account,ship,mould)==initial+1
            assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]==before-int(row[1])
            assert request(ship,props,1,key)==reply
            assert quality.quality(db,account,ship,mould)==initial+1
            auto=request(ship,'',2,'auto-'+str(ship));assert auto.startswith('2 ship_grow_up 0 '),auto
            assert quality.quality(db,account,ship,mould)==initial+3
            (root/'build/quality-reply.txt').write_text(auto,encoding='utf8')
        ship,mould=heroes.all_owned(db,account)[0]
        current=quality.quality(db,account,ship,mould)
        with db._conn:db._conn.execute('UPDATE local_inventory SET quantity=0 WHERE conta_id=?',(account,))
        assert ' -1 ' in request(ship,'',1,'missing')
        assert quality.quality(db,account,ship,mould)==current
        assert ' -1 ' in request(ship+9999999,'',1,'foreign')
        assert ' -1 ' in request(ship,'',0,'zero')
        with db._conn:db._conn.execute('UPDATE local_ship_rank SET level=1 WHERE conta_id=?',(account,))
        assert ' -1 ' in request(ship,'',100,'over-limit')
        with db._conn:db._conn.execute('UPDATE local_ship_rank SET level=100 WHERE conta_id=?',(account,))
        (root/'build/quality-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:assert db._conn.execute('SELECT min(quality) FROM local_hero_quality').fetchone()[0]==3
    finally:db.fechar()
print('HERO_QUALITY_SERVER_PASSED')
