"""Private DB: normal/quick book EXP, promotion, currencies, rollback and retry."""
import json,os,sys,tempfile,sqlite3
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='treasure-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import treasure_local as treasure
    import equipment_local as equipment
    import recruitment_local as heroes
    import hero_stats_local as stats
    db=server.BANCO
    try:
        account=db.criar_conta('book_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=db.perfil(account)['user_id'];server.resposta_login_init('1','');ship,mould=heroes.all_owned(db,account)[0]
        with db._conn:
            db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,120,100000000)',(account,))
            db._conn.execute('UPDATE local_resources SET honour=100000 WHERE conta_id=?',(account,))
            db._conn.execute('INSERT OR REPLACE INTO local_special_wallet VALUES (?,100000,0)',(account,))
        def request(materials,key,slot=6,target=None,owner=ship,seq='2'):
            command='treasure_escalate' if target is None else 'treasure_onekey_escalate'
            fields=[seq,command,uid,owner,materials,slot]+([] if target is None else [target])+[key]
            return server.despacha('\r\n'.join(map(str,fields)))
        def grant(mould,amount=1):
            with db._conn:
                return [2000000000+db._conn.execute('INSERT INTO local_shop_equipment(conta_id,mould) VALUES (?,?)',(account,mould)).lastrowid for _ in range(amount)]
        def balance():return db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
        def state():return equipment.levels(db,account,ship)[5],equipment.qualities(db,account,ship)[5],treasure.experiences(db,account,ship)[5]
        assert 'nivel_de_promocao_nao_atingido' in request(0,'too-early')
        first=grant(186)[0];before=balance();base=stats.effective(db,account,ship,mould)
        (root/'build/treasure-before-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        reply=request(first,'normal');assert reply.startswith('2 treasure_escalate 0 '),reply
        assert state()==(2,0,15),state()
        assert balance()==before-30*treasure.exp_price()
        assert stats.effective(db,account,ship,mould)['property_values']!=base['property_values']
        assert db._conn.execute('SELECT 1 FROM local_shop_equipment WHERE id=?',(first-2000000000,)).fetchone() is None
        (root/'build/treasure-normal-reply.txt').write_text(reply,encoding='utf8')
        saved=balance();assert request(first,'normal',seq='8').split(' ',1)[1]==reply.split(' ',1)[1];assert balance()==saved
        assert 'identificador_reutilizado' in request(0,'normal')
        assert ' -1 ' in request(first,'spent')
        wrong=grant(183)[0];assert ' -1 ' in request(wrong,'wrong-type')
        material=grant(188,30);text=','.join(map(str,material));before=balance()
        assert ' -1 ' in request(str(material[0])+','+str(material[0]),'duplicate')
        assert ' -1 ' in request(material[0],'foreign',owner=ship+999999)
        assert ' -1 ' in request(material[0],'bad-slot',slot=4)
        assert ' -1 ' in request(material[0],'bad-target',target=999)
        # Fail after mutation to prove the debit, deletion and state all roll back.
        original=heroes.one_ship_tokens
        def fail(*args,**kwargs):raise ValueError('injected_reply_failure')
        heroes.one_ship_tokens=fail
        try:assert 'injected_reply_failure' in request(material[0],'rollback')
        finally:heroes.one_ship_tokens=original
        assert balance()==before and state()==(2,0,15)
        assert db._conn.execute('SELECT 1 FROM local_shop_equipment WHERE id=?',(material[0]-2000000000,)).fetchone()
        (root/'build/treasure-quick-before-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        quick=request(text,'quick',target=20);assert quick.startswith('2 treasure_onekey_escalate 0 '),quick
        assert state()[0]==20 and state()[1]==1,state()
        payload=json.loads(quick.split(' 15990 ',1)[1].split(' ',1)[0]);removed=payload['removedEquipment']
        assert 0<len(removed)<len(material)
        promotion_cost=sum(int(r[13]) for r in treasure.ranks(mould,6) if int(r[1])<20)
        assert balance()==before-len(removed)*500*treasure.exp_price()-promotion_cost
        trial=db._conn.execute('SELECT trial FROM local_special_wallet WHERE conta_id=?',(account,)).fetchone()[0]
        assert trial==100000-sum(int(r[15].split(',')[2]) for r in treasure.ranks(mould,6) if int(r[1])<20)
        (root/'build/treasure-quick-reply.txt').write_text(quick,encoding='utf8')
        assert 'identificador_reutilizado' in request(text,'quick')
        after=balance();assert request(text,'quick',target=20,seq='9').split(' ',1)[1]==quick.split(' ',1)[1];assert balance()==after
        with db._conn:db._conn.execute('UPDATE local_special_wallet SET trial=0 WHERE conta_id=?',(account,))
        assert 'moeda_de_promocao_insuficiente' in request(0,'no-currency')
        assert balance()==after
        with db._conn:db._conn.execute('UPDATE local_special_wallet SET trial=100000 WHERE conta_id=?',(account,))
        promoted=request(0,'promotion');assert promoted.startswith('2 treasure_escalate 0 '),promoted
        assert state()[0:2]==(20,2)
        before=balance()
        with db._conn:db._conn.execute('UPDATE local_campaign SET silver=0 WHERE conta_id=?',(account,))
        remaining=next(i for i in material if str(i) not in set(removed))
        # Stored overflow can advance without another item; once exhausted no debit/deletion occurs.
        result=request(remaining,'no-money',target=25)
        assert balance()==0
        assert db._conn.execute('SELECT 1 FROM local_shop_equipment WHERE id=?',(remaining-2000000000,)).fetchone()
        # Slot 5 uses Arena currency; slot 6 uses Trial currency.
        with db._conn:
            db._conn.execute('UPDATE local_campaign SET silver=? WHERE conta_id=?',(before,account))
            db._conn.execute('INSERT INTO local_equipment_level VALUES (?,?,5,10,0)',(account,ship))
        honour=db._conn.execute('SELECT honour FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
        assert request(0,'slot-five',slot=5).startswith('2 treasure_escalate 0 ')
        assert db._conn.execute('SELECT honour FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]==honour-100
        # Account-level gate and final level refuse without consuming resources.
        gated=next(r for r in treasure.ranks(mould,6) if r[17]!='-1')
        with db._conn:
            db._conn.execute('UPDATE local_equipment_level SET level=?,quality=? WHERE conta_id=? AND ship_id=? AND slot=6',(int(gated[1]),int(gated[14])-1,account,ship))
            db._conn.execute('UPDATE local_campaign SET grade=1 WHERE conta_id=?',(account,))
        before=balance();assert 'nivel_do_jogador_insuficiente' in request(0,'level-gate');assert balance()==before
        with db._conn:db._conn.execute('UPDATE local_equipment_level SET level=120,quality=22 WHERE conta_id=? AND ship_id=? AND slot=6',(account,ship))
        assert 'nivel_maximo_do_tesouro' in request(0,'max-book')
        assert 'nivel_alvo_invalido' in request(remaining,'max-quick',target=120)
        info=equipment.equip_info(db,account,ship,mould);assert info in server.resposta_login_init('1','')
        path=db.caminho;db._conn.close();db._conn=sqlite3.connect(path,check_same_thread=False);db._conn.row_factory=sqlite3.Row
        assert equipment.equip_info(db,account,ship,mould)==info
        assert request(first,'normal').split(' ',1)[1]==reply.split(' ',1)[1]
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        print('TREASURE_TEST_PASSED normal/quick, exact EXP and costs, promotions, currencies, ownership, limits, atomic rollback, durable replay, persisted UI/stats')
    finally:db.fechar()
