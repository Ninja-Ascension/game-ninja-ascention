import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'));os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='level-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import hero_level_local as levels
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('level_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account);uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','')
        with db._conn:db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,100,10000000)',(account,))
        foods=[]
        for row in levels.data.tabela('prop_mould.txt').values():
            food=levels.data.tabela('ship_mould.txt').get(row[39])
            if food and int(food[54])>0:foods.append((int(row[0]),int(food[54])))
        prop,value=foods[0];instance=account*1000000+prop
        with db._conn:db._conn.execute('INSERT OR REPLACE INTO local_inventory VALUES (?,?,?,?)',(account,prop,instance,10000))
        owned=heroes.all_owned(db,account);ship,mould=owned[0]
        def request(ship,amount,key,seq='2',item=instance):return server.MINIMOS['ship_escalate'](seq,'\r\n'.join([seq,'ship_escalate',uid,'0',str(ship),str(item)+':'+str(amount),key]))
        initial=levels.state(db,account,ship,mould)
        count=max(1,(initial[2]+value-1)//value)
        reply=request(ship,count,'first');assert reply.startswith('2 ship_escalate 0 '),reply
        assert levels.state(db,account,ship,mould)[0]>1
        quantity=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,prop)).fetchone()[0]
        assert request(ship,count,'first','3')=='3 '+reply.split(' ',1)[1]
        assert db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,prop)).fetchone()[0]==quantity
        assert ' -1 ' in request(ship+999999,1,'foreign')
        assert ' -1 ' in request(ship,100000,'missing')
        assert ' -1 ' in request(ship,0,'zero')
        assert ' -1 ' in request(ship,1,'invalid',item=9999)
        for current,mould in owned:
            if current!=ship:assert levels.state(db,account,current,mould)[0]==1
        payload=json.loads(reply.split('15993 ',1)[1]);assert payload['experience']>=0 and payload['needed']>0
        (root/'build/hero-level-reply.txt').write_text(reply,encoding='utf8')
        (root/'build/hero-level-login.txt').write_text(server.resposta_login_init('9',''),encoding='utf8')
        print('HERO_LEVEL_TEST_PASSED: EXP items, level gain, atomic failures, retry, persistence in login')
    finally:db._conn.close()
