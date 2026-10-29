import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'));os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='stats-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import hero_stats_local as stats
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('stats_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account);uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','')
        ship,mould=heroes.all_owned(db,account)[0]
        with db._conn:
            db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,100,100000000)',(account,))
            db._conn.execute('INSERT OR REPLACE INTO local_ship_rank VALUES (?,?,0,100)',(account,ship))
            for ident in stats.data.tabela('prop_mould.txt'):db._conn.execute('INSERT OR REPLACE INTO local_inventory VALUES (?,?,?,?)',(account,int(ident),account*1000000+int(ident),1000000))
        initial=stats.effective(db,account,ship,mould)
        (root/'build/stats-before-login.txt').write_text(server.despacha('9\r\nlogin_init'),encoding='utf8')
        request='\r\n'.join(['2','ship_grow_up',uid,str(ship),'','','','1','stats-advance'])
        reply=server.despacha(request);assert reply.startswith('2 ship_grow_up 0 '),reply
        after=stats.effective(db,account,ship,mould)
        assert after['speed']==initial['speed']+5
        assert after['health']>initial['health'] and after['courage']>initial['courage']
        assert stats.effective(db,account,ship,mould)==after
        server.despacha(request);assert stats.effective(db,account,ship,mould)==after
        promote=server.despacha('\r\n'.join(['3','ship_awaken',uid,str(ship),'stats-star']))
        assert promote.startswith('3 ship_awaken 0 '),promote
        final=stats.effective(db,account,ship,mould)
        assert final['speed']==after['speed']+20 and final['health']>after['health']
        assert any(v['is_activited']=='1' for v in final['bonds'])
        report=heroes.herois_da_formacao(db,account,uid,'stats_test')
        combat=next(v for v in report if v['_id']==str(ship))
        assert int(combat['_max_hp'])==int(final['health']) and int(combat['_hero_speed'])==int(final['speed'])
        with db._conn:db._conn.execute('UPDATE local_ship_rank SET level=99 WHERE conta_id=? AND ship_id=?',(account,ship))
        assert stats.effective(db,account,ship,mould)['speed']==final['speed']
        with db._conn:db._conn.execute('UPDATE local_ship_rank SET level=100 WHERE conta_id=? AND ship_id=?',(account,ship))
        login=server.despacha('10\r\nlogin_init')
        (root/'build/stats-after-login.txt').write_text(login,encoding='utf8')
        (root/'build/stats-update.txt').write_text('4 stats_update 0 '+' '.join(stats.snapshot_tokens(db,account)),encoding='utf8')
        print('HERO_STATS_TEST_PASSED Advance +5, star +20, no speed per level, bond bonuses, battle HP and idempotency')
    finally:db._conn.close()
