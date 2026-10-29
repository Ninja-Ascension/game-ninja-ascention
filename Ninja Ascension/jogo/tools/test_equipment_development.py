"""Private SQLite tests for Awaken, Quench, reroll, locks and durable charging."""
import json,os,sys,tempfile,sqlite3
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'));os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='equipment-develop-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import equipment_development_local as development
    import equipment_local as equipment
    import recruitment_local as heroes
    import hero_stats_local as stats
    db=server.BANCO
    try:
        account=db.criar_conta('awaken_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=db.perfil(account)['user_id'];server.resposta_login_init('1','');ship,mould=heroes.all_owned(db,account)[0]
        with db._conn:db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,120,100000000)',(account,))
        def request(command,*args,key='test',seq='2',owner=ship,slot=1):
            return server.despacha('\r\n'.join(map(str,[seq,command,uid,owner,slot,*args,key])))
        def awaken(key,slot=1):return request('equipment_up_star',key=key,slot=slot)
        def quantity(item):
            return (db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,item)).fetchone() or [0])[0]
        def silver():return db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
        def grant(item,count):
            with db._conn:db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',(account,item,account*1000000+item,count))
        def fund_awaken(slot):
            stars,templates=development.appearance(db,account,ship,mould)
            equip=development.data.tabela('equipment_mould.txt')[str(templates[slot-1])]
            row=next(r for r in development.data.tabela('equipment_star.txt').values() if r[1]==equip[46] and int(r[2])==stars[slot-1])
            for pair in row[5].split('|'):
                kind,item,count=map(int,pair.split(','))
                if kind==6:grant(item,count)
                elif kind==7:
                    with db._conn:
                        for _ in range(count):db._conn.execute('INSERT INTO local_shop_equipment(conta_id,mould) VALUES (?,?)',(account,item))
                else:raise AssertionError(pair)
        assert ' -1 ' in awaken('missing')
        assert ' -1 ' in request('equipment_harden',1,key='gated')
        assert ' -1 ' in request('equipment_up_star',key='foreign',owner=ship+999999)
        assert ' -1 ' in request('equipment_up_star',key='bad-slot',slot=7)
        fund_awaken(1)
        before=stats.effective(db,account,ship,mould)
        (root/'build/equip-awaken-before-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        first=awaken('first');assert first.startswith('2 equipment_up_star 0 '),first
        assert development.appearance(db,account,ship,mould)[0][0]==1
        assert development.appearance(db,account,ship,mould)[1][0]==104
        assert quantity(223)==0
        assert not db._conn.execute('SELECT 1 FROM local_shop_equipment WHERE conta_id=? AND mould=104',(account,)).fetchone()
        assert stats.effective(db,account,ship,mould)['courage']>before['courage']
        after=silver();assert awaken('first').split(' ',1)[1]==first.split(' ',1)[1] and silver()==after
        assert 'identificador_reutilizado' in request('equipment_up_star',key='first',slot=2)
        # A failure after resource mutation must roll back the whole operation.
        fund_awaken(1);inventory=quantity(223);original=heroes.one_ship_tokens
        def fail(*args,**kwargs):raise ValueError('injected_failure')
        heroes.one_ship_tokens=fail
        try:assert 'injected_failure' in awaken('rollback')
        finally:heroes.one_ship_tokens=original
        assert quantity(223)==inventory and development.appearance(db,account,ship,mould)[0][0]==1
        for star in range(2,6):
            if star>2:fund_awaken(1)
            reply=awaken('star-'+str(star));assert reply.startswith('2 equipment_up_star 0 '),reply
            assert development.appearance(db,account,ship,mould)[0][0]==star
        (root/'build/equip-awaken-reply.txt').write_text(reply,encoding='utf8')
        assert 'despertar_no_limite' in awaken('max-star')
        # Both non-weapon slots use their own awakening templates and prop costs.
        for slot in (5,6):
            fund_awaken(slot);assert awaken('slot-'+str(slot),slot).startswith('2 equipment_up_star 0 ')
            assert development.appearance(db,account,ship,mould)[0][slot-1]==1
        grant(2073,1000);grant(2079,10);grant(2080,10)
        development.secrets.randbelow=lambda n:n-1 # no crit; range draws at the upper bound
        (root/'build/equip-quench-before-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        balance=silver();stones=quantity(2073)
        reply=request('equipment_harden',1,key='quench-one');assert reply.startswith('2 equipment_harden 0 '),reply
        assert development.state(db,account,ship,1)['exp']==400
        assert silver()==balance-1000 and quantity(2073)==stones-1
        saved=development.state(db,account,ship,1)
        assert request('equipment_harden',1,key='quench-one',seq='9').split(' ',1)[1]==reply.split(' ',1)[1]
        assert development.state(db,account,ship,1)==saved
        balance=silver();stones=quantity(2073)
        quick=request('equipment_harden',2,key='quench-quick');assert quick.startswith('2 equipment_harden 0 '),quick
        saved=development.state(db,account,ship,1)
        assert saved['level']==1 and saved['exp']==200 and len(saved['entries'])==1,saved
        assert silver()==balance-7000 and quantity(2073)==stones-7
        for target in (2,3):
            reply=request('equipment_harden',2,key='level-'+str(target));assert reply.startswith('2 equipment_harden 0 '),reply
        saved=development.state(db,account,ship,1);assert len(saved['entries'])==2
        assert request('equipment_harden_locking',1,1,key='lock').startswith('2 equipment_harden_locking 0 ')
        locked=development.state(db,account,ship,1)['entries'][0][:];locks=quantity(2079);rerolls=quantity(2080)
        reroll=request('equipment_harden_replace',key='reroll');assert reroll.startswith('2 equipment_harden_replace 0 '),reroll
        saved=development.state(db,account,ship,1)
        assert saved['entries'][0]==locked and len(saved['previous'])==2 and saved['lock']==0
        assert quantity(2079)==locks-1 and quantity(2080)==rerolls-1
        assert request('equipment_harden_replace',key='reroll',seq='3').split(' ',1)[1]==reroll.split(' ',1)[1]
        assert quantity(2079)==locks-1 and quantity(2080)==rerolls-1
        assert ' -1 ' in request('equipment_harden_locking',3,1,key='bad-lock')
        assert request('equipment_harden_locking',1,2,key='unlock').startswith('2 equipment_harden_locking 0 ')
        # Missing stones and silver must not advance state or create a receipt.
        with db._conn:db._conn.execute('UPDATE local_campaign SET silver=0 WHERE conta_id=?',(account,))
        before=development.state(db,account,ship,1);stones=quantity(2073)
        assert ' -1 ' in request('equipment_harden',2,key='no-money')
        assert development.state(db,account,ship,1)==before and quantity(2073)==stones
        with db._conn:db._conn.execute('UPDATE local_campaign SET silver=100000000 WHERE conta_id=?',(account,))
        # Critical EXP follows play_config; the receipt saves the rolled result.
        development.secrets.randbelow=lambda n:0
        before=development.state(db,account,ship,1)['exp']
        assert request('equipment_harden',1,key='critical').startswith('2 equipment_harden 0 ')
        assert development.state(db,account,ship,1)['exp']==before+800
        (root/'build/equip-quench-reply.txt').write_text(request('equipment_harden_locking',1,1,key='native-lock'),encoding='utf8')
        info=equipment.equip_info(db,account,ship,mould);harden=development.state(db,account,ship,1)
        login=server.resposta_login_init('1','');assert info in login and ' 14207 ' in login
        (root/'build/equip-developed-login.txt').write_text(login,encoding='utf8')
        # Unlock all three entries, advance their tiers and stop exactly at cap.
        development.secrets.randbelow=lambda n:n-1
        for target in range(4,16):
            assert request('equipment_harden',2,key='tier-'+str(target)).startswith('2 equipment_harden 0 ')
            current=development.state(db,account,ship,1)
            assert current['level']==target
            assert len(current['entries'])==sum(target>=n for n in (1,3,6))
            assert all(e[0]==sum(target>=n for n in (9,12,15)) for e in current['entries'])
        before=silver();stones=quantity(2073)
        assert ' -1 ' in request('equipment_harden',2,key='harden-cap')
        assert silver()==before and quantity(2073)==stones
        # Restore fixture state in the private DB for the reopen assertion.
        with db._conn:db._conn.execute('UPDATE local_equipment_harden SET state=? WHERE conta_id=? AND ship_id=? AND slot=1',(json.dumps(harden),account,ship))
        path=db.caminho;db._conn.close();db._conn=sqlite3.connect(path,check_same_thread=False);db._conn.row_factory=sqlite3.Row
        assert development.state(db,account,ship,1)==harden
        assert awaken('first').split(' ',1)[1]==first.split(' ',1)[1]
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        print('EQUIPMENT_DEVELOPMENT_PASSED awakening 0..5, transformed templates, exact materials, normal/quick Quench, critical EXP, locks/reroll, rollback, replay, persisted login/stats')
    finally:db.fechar()
