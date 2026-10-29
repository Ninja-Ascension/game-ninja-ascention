"""Shop transactions, replay protection, rollback, stock and saved equipment."""
import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='shop-test-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import shop_local as shop
    db=server.BANCO
    try:
        account=db.criar_conta('shop_test','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','')
        with db._conn:db._conn.execute('UPDATE local_resources SET gold=10000,jade=1000 WHERE conta_id=?',(account,))
        def request(command,*args):return server.despacha('\r\n'.join(['2',command,uid]+list(map(str,args))))
        def amount():return db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
        def jade():return db._conn.execute('SELECT jade FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
        def payload(reply):return json.loads(reply.split(' 15990 ')[1].split(' ')[0])
        first=request('ship_bounty',3,'free');assert first.startswith('2 ship_bounty 0 '),first
        assert len(payload(first)['results'])==1 and amount()==10000
        assert jade()==1001
        assert request('ship_bounty',3,'free')==first
        assert jade()==1001
        assert ' -1 ' in request('ship_batch_bounty',3,'free')
        second=request('ship_bounty',3,'paid');assert amount()==9920,second
        with db._conn:
            shop.grant(db,account,6,240,10)
            db._conn.execute('UPDATE local_inventory SET quantity=10 WHERE conta_id=? AND mould=240',(account,))
        ten=request('ship_batch_bounty',3,'keys');assert len(payload(ten)['results'])==10 and amount()==9920,ten
        assert db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=240',(account,)).fetchone()[0]==0
        paidten=request('ship_batch_bounty',3,'gold');assert amount()==9240,paidten
        assert request('ship_batch_bounty',3,'gold')==paidten
        assert jade()==1022
        original=shop.choose
        shop.choose=lambda group:[7,145,1]
        equip=request('ship_bounty',3,'equipment');assert amount()==9160,equip
        assert len(payload(equip)['equipmentCompact'])>=1
        shop.choose=lambda group:[6,9999999,1]
        bad=request('ship_bounty',3,'bad-item');assert ' -1 ' in bad and amount()==9160,bad
        assert jade()==1023
        shop.choose=original
        with db._conn:db._conn.execute('UPDATE local_resources SET gold=0 WHERE conta_id=?',(account,))
        assert ' -1 ' in request('ship_batch_bounty',3,'insufficient')
        init=request('shop_frags_init');assert init.startswith('2 shop_frags_init 0 15001 '),init
        assert request('shop_frags_init','').startswith('2 shop_frags_init 0 15001 ')
        offer=db._conn.execute('SELECT slot,good FROM local_shop_offers WHERE conta_id=? ORDER BY slot',(account,)).fetchone()
        row=shop.data.tabela('avatar_shop.txt')[str(offer[1])];cost=int(row[3].split(',')[2])
        before=db._conn.execute('SELECT jade FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
        trade=request('shop_frags_exchange',offer[0],1,'exchange');assert trade.startswith('2 shop_frags_exchange 0 '),trade
        assert db._conn.execute('SELECT jade FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]==before-cost
        assert request('shop_frags_exchange',offer[0],1,'exchange')==trade
        assert ' -1 ' in request('shop_frags_exchange',offer[0],0,'zero')
        general=request('secret_shop_init');assert general.startswith('2 secret_shop_init 0 197 '),general
        assert request('secret_shop_init','')==general,'Original empty param_list rejected'
        assert ' -1 ' in request('secret_shop_init','unexpected')
        assert request('secret_shop_init')==general,'Opening the shop rerolled stock'
        with db._conn:
            db._conn.execute('UPDATE local_campaign SET silver=10000000 WHERE conta_id=?',(account,))
            db._conn.execute('UPDATE local_resources SET gold=10000 WHERE conta_id=?',(account,))
        buy=request('secret_shop_exchange',0,'buy-general');assert buy.startswith('2 secret_shop_exchange 0 '),buy
        assert request('secret_shop_exchange',0,'buy-general')==buy
        assert ' -1 ' in request('secret_shop_exchange',0,'sold-out')
        assert ' -1 ' in request('secret_shop_exchange',-1,'negative-slot')
        assert request('secret_shop_init')!=general,'Sold stock not persisted'
        (root/'build/shop-general.txt').write_text(request('secret_shop_init'),encoding='utf8')
        before_refresh=amount()
        refresh=request('secret_shop_refresh','refresh-1');assert refresh.startswith('2 secret_shop_refresh 0 '),refresh
        assert amount()==before_refresh-20 and ' 197 ' in refresh
        assert request('secret_shop_refresh','refresh-1')==refresh and amount()==before_refresh-20
        (root/'build/shop-refresh.txt').write_text(refresh,encoding='utf8')
        assert all(offer['stock']==1 for offer in json.loads(db._conn.execute('SELECT offers FROM local_general_shop WHERE conta_id=?',(account,)).fetchone()[0]))
        second_refresh=request('secret_shop_refresh','refresh-2');assert amount()==before_refresh-50,second_refresh
        with db._conn:db._conn.execute('UPDATE local_general_shop SET refreshes=20 WHERE conta_id=?',(account,))
        assert ' -1 ' in request('secret_shop_refresh','limit') and amount()==before_refresh-50
        with db._conn:
            db._conn.execute('UPDATE local_general_shop SET refreshes=0 WHERE conta_id=?',(account,))
            db._conn.execute('UPDATE local_resources SET gold=0 WHERE conta_id=?',(account,))
            db._conn.execute('UPDATE local_campaign SET silver=0 WHERE conta_id=?',(account,))
        stock_before=request('secret_shop_init')
        assert ' -1 ' in request('secret_shop_exchange',0,'poor')
        assert request('secret_shop_init')==stock_before,'Failed purchase changed stock'
        assert ' -1 ' in request('secret_shop_refresh','poor-refresh')
        with db._conn:db._conn.execute('UPDATE local_general_shop SET period=period-1 WHERE conta_id=?',(account,))
        assert ' -1 ' in request('secret_shop_exchange',0,'expired-offer')
        for name,reply in [('login',server.resposta_login_init('1','')),('single',first),('ten',paidten),('equipment',equip),('exchange',trade)]:
            (root/('build/shop-'+name+'.txt')).write_text(reply,encoding='utf8')
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:
        assert db._conn.execute('SELECT count(*) FROM local_shop_equipment').fetchone()[0]>=1
        assert db._conn.execute('SELECT draws FROM local_shop_state').fetchone()[0]==23
        assert db._conn.execute('SELECT count(*) FROM local_general_shop').fetchone()[0]==1
    finally:db.fechar()
print('SHOP_LOCAL_SERVER_PASSED')
