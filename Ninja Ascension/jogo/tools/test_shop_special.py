"""Isolated purchases/refreshes for Arena, Trial, Clan; no free currencies."""
import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='shop-special-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import shop_special_local as special
    db=server.BANCO
    try:
        account=db.criar_conta('shop_special','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account);uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','')
        def request(command,*args):return server.despacha('\r\n'.join(['2',command,uid]+list(map(str,args))))
        assert ' -1 ' in request('union_shop_init','')
        assert ' -1 ' in request('shop_request_product_refresh',4,'no-clan')
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)',(account,))
            db._conn.execute('UPDATE local_campaign SET grade=100 WHERE conta_id=?',(account,))
            db._conn.execute('UPDATE local_resources SET honour=100000,gold=10000 WHERE conta_id=?',(account,))
            db._conn.execute('UPDATE local_special_wallet SET trial=100000,clan=100000 WHERE conta_id=?',(account,))
            db._conn.execute('INSERT INTO local_clan_membership VALUES (?,1,?)',(account,'Isolated test clan'))
        for init,page in special.INITS.items():
            reply=request(init,*(['0','0'] if page==3 else ['']))
            assert reply.startswith('2 '+init+' 0 '),reply
            assert request(init,*(['0','0'] if page==3 else ['']))==reply
            offers,count=special.state(db,account,page);assert offers
            row=special.shop.data.tabela(special.TABLES[page])[str(offers[0]['id'])]
            mould,kind,quantity,cost,limit=special.definition(page,row)
            before=special.balance(db,account,page)
            command=next(cmd for cmd,p in special.BUYS.items() if p==page)
            args=[0,2,1] if page==5 else [1,1]
            buy=request(command,*args,'purchase-'+str(page));assert buy.startswith('2 '+command+' 0 '),buy
            assert special.balance(db,account,page)==before-cost
            assert request(command,*args,'purchase-'+str(page))==buy
            assert special.state(db,account,page)[0][0]['bought']==1
            before_gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
            refresh=request('shop_request_product_refresh',page-1,'refresh-'+str(page));assert refresh.startswith('2 shop_request_product_refresh 0 '),refresh
            assert db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]==before_gold-20
            assert request('shop_request_product_refresh',page-1,'refresh-'+str(page))==refresh
            assert all(o['bought']==0 for o in special.state(db,account,page)[0])
            (root/('build/special-shop-'+str(page)+'.txt')).write_text(refresh,encoding='utf8')
            assert ' -1 ' in request(command,*([0,2,2] if page==5 else [1,2]),'bad-quantity-'+str(page))
        (root/'build/special-shop-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        with db._conn:
            db._conn.execute('UPDATE local_resources SET honour=0,gold=0 WHERE conta_id=?',(account,))
            db._conn.execute('UPDATE local_special_wallet SET trial=0,clan=0 WHERE conta_id=?',(account,))
        for command,page in special.BUYS.items():
            assert ' -1 ' in request(command,*([0,2,1] if page==5 else [1,1]),'poor-'+str(page))
            assert special.state(db,account,page)[0][0]['bought']==0
        with db._conn:db._conn.execute('DELETE FROM local_clan_membership WHERE conta_id=?',(account,))
        assert ' -1 ' in request('union_shop_init','')
        assert ' -1 ' in request('union_shop_exchange',0,2,1,'left-clan')
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:assert db._conn.execute('SELECT count(*) FROM local_special_shop').fetchone()[0]==3
    finally:db.fechar()
print('SHOP_SPECIAL_SERVER_PASSED')
