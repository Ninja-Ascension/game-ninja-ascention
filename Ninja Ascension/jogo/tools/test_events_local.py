"""Exercise every local Event row against an isolated account and SQLite file."""
import datetime as dt
import json
import os
from pathlib import Path
import sys
import tempfile

root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='events-test-',dir=root/'build',ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import events_local as events
    db=server.BANCO
    try:
        # Run a complete seven-day sale edition in an isolated config. The
        # production schedule remains tied to the selected wiki server.
        campaign_config=json.loads(events.CONFIG.read_text(encoding='utf8'))
        sale=next(c for c in campaign_config['campaigns'] if c['id']=='discount')
        sale['schedule']={'start_at':dt.datetime.now(dt.timezone.utc).isoformat(),
                          'end_at':(dt.datetime.now(dt.timezone.utc)+dt.timedelta(days=1)).isoformat(),
                          'utc_offset_minutes':-180}
        test_config=Path(folder)/'events-test.json'
        test_config.write_text(json.dumps(campaign_config,ensure_ascii=False),encoding='utf8')
        events.CONFIG=test_config
        account=db.criar_conta('eventstest','Testing123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        with db._conn:
            db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES(?,110,1000000)',(account,))
            db._conn.execute('INSERT OR REPLACE INTO local_resources(conta_id,gold,food) VALUES(?,100000,0)',(account,))
            db._conn.execute('INSERT OR REPLACE INTO local_vip VALUES(?,20)',(account,))
            start=dt.datetime.now()-dt.timedelta(days=6)
            db._conn.execute('UPDATE perfis SET criada_em=? WHERE conta_id=?',(int(start.timestamp()*1000),account))
            events.record(db,account,'spend',5000)
            events.record(db,account,'weapon',100)
            assert events.credit(db,account,'test:credit',1000)
            before=events.balance(db,account)
            assert not events.credit(db,account,'test:credit',1000)
            assert events.balance(db,account)==before
            # Real authored stages provide the account facts used by Party tasks.
            import dados_batalha as data
            for sid in range(1,10):
                for npc in data.tabela('pve_scene.txt')[str(sid)][12].split(','):
                    db._conn.execute('INSERT OR IGNORE INTO local_pve_clears VALUES(?,?,?,3)',(account,sid,int(npc)))

        def request(cmd,*args):
            return server.despacha('\r\n'.join(['7',cmd,uid]+list(map(str,args))))
        def success(reply):
            assert reply.split(' ')[2]=='0',reply[:200]
            payload=json.loads(reply.split(' '+events.PARSER+' ',1)[1])
            assert ' ' not in reply.split(' '+events.PARSER+' ',1)[1]
            return payload
        def snapshot():
            return (events.balance(db,account),[tuple(x) for x in db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? ORDER BY mould',(account,))],db._conn.execute('SELECT COUNT(*) FROM local_event_claims').fetchone()[0])
        assert len(success(request('local_event_init','event'))['pages'])==len([c for c in events.configuration() if c['period']!='seven'])
        assert len(success(request('local_event_init','seven'))['pages'])==7
        (root/'build/events-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        (root/'build/events-native-fixture.json').write_text(json.dumps({'event':events.payload(db,account,'event'),'seven':events.payload(db,account,'seven')},ensure_ascii=False),encoding='utf8')
        success(request('local_event_action','event','fund','invest','invest:1'))
        # Server-scheduled shop: both currencies and VIP gates are enforced.
        sale_rows=next(c for c in events.configuration() if c['id']=='discount')['rows']
        assert len(sale_rows)==14 and all(r['day']==(i+1)//2 for i,r in enumerate(sale_rows,1))
        before=snapshot()
        assert request('local_event_action','event','discount','4','future:4').split(' ')[2]!='0'
        assert snapshot()==before
        sale['schedule']={'start_at':(dt.datetime.now(dt.timezone.utc)-dt.timedelta(days=6)).isoformat(),
                          'end_at':(dt.datetime.now(dt.timezone.utc)+dt.timedelta(days=1)).isoformat(),
                          'utc_offset_minutes':-180}
        test_config.write_text(json.dumps(campaign_config,ensure_ascii=False),encoding='utf8')
        before=events.balance(db,account)
        bought=success(request('local_event_action','event','discount','4','sale:4'))
        assert bought['rewards']==[[47,13,1]]
        after=events.balance(db,account)
        assert after['gold']==before['gold']-400 and after['ryo']==before['ryo']-2000
        assert db._conn.execute('SELECT COUNT(*) FROM local_synthesized WHERE conta_id=? AND mould=47',(account,)).fetchone()[0]==1
        saved=snapshot()
        assert request('local_event_action','event','discount','4','sale:4')==request('local_event_action','event','discount','4','sale:4')
        assert snapshot()==saved
        total=0
        for c in events.configuration():
            mode='seven' if c['period']=='seven' else 'event'
            for row in c['rows']:
                if c['id']=='discount' and row['id']=='4': continue
                key=(c['id']+':'+row['id']).replace('_','-')
                reply=request('local_event_action',mode,c['id'],row['id'],key)
                payload=success(reply)
                if c['id']=='ramen': (root/'build/events-ramen-reply.txt').write_text(reply,encoding='utf8')
                assert payload['rewards']==row['rewards']
                saved=snapshot()
                assert request('local_event_action',mode,c['id'],row['id'],key)==reply
                assert snapshot()==saved,'Replay changed wallet or items'
                assert request('local_event_action',mode,c['id'],row['id'],key+':again').split(' ')[2]!='0'
                assert snapshot()==saved,'Second request ID duplicated reward'
                total+=1
        # Read-only refresh must not credit rewards.
        saved=snapshot();success(request('local_event_init','event'));assert snapshot()==saved
        # A failed purchase rolls back its spend counter and wallet debit.
        original_config=events.CONFIG
        bad=json.loads(original_config.read_text(encoding='utf8'))
        c=next(c for c in bad['campaigns'] if c['id']=='discount')
        c['rows'].append(dict(id='invalid',label='Invalid',metric='none',target=0,cost=99,rewards=[[999999999,6,1]]))
        invalid=Path(folder)/'invalid.json';invalid.write_text(json.dumps(bad),encoding='utf8');events.CONFIG=invalid
        before=snapshot();spend=events.metric(db,account,c,'spend')
        assert request('local_event_action','event','discount','invalid','rollback:1').split(' ')[2]!='0'
        assert snapshot()==before and events.metric(db,account,c,'spend')==spend
        events.CONFIG=original_config
        with db._conn:
            db._conn.execute('UPDATE perfis SET criada_em=? WHERE conta_id=?',(int((dt.datetime.now()-dt.timedelta(days=9)).timestamp()*1000),account))
        assert not any(r['available'] for p in success(request('local_event_init','seven'))['pages'] for r in p['rows'])
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        print('EVENTS_PASSED rows=%d; all campaigns; balances; preview=grant; replay; rollback; expired Party; integrity=ok'%total)
    finally:
        db._conn.close()
