"""Ninja School backend test on a temporary database (never the real profile)."""
import json, os, sys, tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='school-',dir=root/'build',ignore_cleanup_errors=True) as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import ninja_school_local as school
    import hero_stats_local as stats
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('school_test','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','')
        with db._conn:
            db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,110,100000000)',(account,))
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)',(account,))
        def call(cmd,*args): return server.despacha('\r\n'.join(['2',cmd,uid]+list(map(str,args))))
        def silver(): return db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
        def gold(): return db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
        def stock(prop):
            row=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,prop)).fetchone()
            return row[0] if row else 0
        def give(prop,n):
            with db._conn:
                db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=excluded.quantity',(account,prop,account*1000000+prop,n))
        def refused(reply,reason): assert reply.split(' ')[2]=='-1' and reason in reply,reply
        owned=dict((m,s) for s,m in heroes.all_owned(db,account))
        slots=heroes._slots_locked(db,account)
        front=next(int(s) for s in slots[:3] if s!='0'); back=next(int(s) for s in slots[3:] if s!='0')
        mould_of={s:m for m,s in owned.items()}
        def eff(ship): return stats.effective(db,account,ship,mould_of[ship])

        # --- initialization of the original screens
        for cmd in school.INIT_COMMANDS:
            reply=call(cmd,'')
            assert reply.startswith('2 '+cmd+' 0 '),reply

        # --- talents: level up, costs, retries, prerequisites
        f0,b0=eff(front),eff(back); before=silver()
        reply=call('ship_talent_level_up',1,2,'first')
        assert reply.startswith('2 ship_talent_level_up 0 '),reply
        assert ' 15995 ' in reply and ' 12559 ' in reply,'talent reply must refresh attributes'
        assert school.state(db,account)['talents']['1']==2
        assert school.state(db,account)['talentPoints']==9996
        assert silver()==before-15000
        assert call('ship_talent_level_up',1,2,'first')==reply
        refused(call('ship_talent_level_up',1,3,'first'),'identificador_reutilizado')
        refused(call('ship_talent_level_up',2,'prerequisite'),'talento_anterior_insuficiente')
        refused(call('ship_talent_level_up',1,100,'cap'),'talento_no_nivel_maximo')
        refused(call('ship_talent_level_up',8,'page'),'pagina_de_talento_bloqueada')

        # --- talents in combat: talent 1 level 2 = front row HP+320, back row ATK+40
        f1,b1=eff(front),eff(back)
        assert f1['health']>f0['health']+319 and abs(f1['courage']-f0['courage'])<1e-6,(f0,f1)
        assert b1['courage']>b0['courage']+39 and abs(b1['health']-b0['health'])<1e-6,(b0,b1)
        # Class talents (page B) use camp_preference: 1 ATK, 3 Skill, 2 DEF.
        flat,percent,props,_=school.combat_bonus(db,account,front,mould_of[front])
        assert flat[0]==320 and flat[1]==0 and percent==[0,0,0,0] and props=={},(flat,percent,props)

        # --- talent reset: 500 diamonds, refunds silver and talent points
        with db._conn: db._conn.execute('UPDATE local_resources SET gold=100 WHERE conta_id=?',(account,))
        refused(call('ship_talent_reset','poor'),'diamantes_insuficientes')
        assert school.state(db,account)['talents']['1']==2
        with db._conn: db._conn.execute('UPDATE local_resources SET gold=1000 WHERE conta_id=?',(account,))
        before=silver()
        reply=call('ship_talent_reset','reset1')
        assert reply.startswith('2 ship_talent_reset 0 25 -500 500 22 '),reply
        assert ' 171 7 2 -1 1 15000 -1 34 4 ' in reply,reply
        assert school.state(db,account)['talents']=={} and school.state(db,account)['talentPoints']==10000
        assert silver()==before+15000 and gold()==500
        assert call('ship_talent_reset','reset1')==reply and gold()==500
        refused(call('ship_talent_reset','reset2'),'nenhum_talento_para_redefinir')
        f2=eff(front); assert abs(f2['health']-f0['health'])<1e-6,'reset must remove talent bonus'

        # --- digital spirit
        group,index,attr=school.spirit_slot(mould_of[front])
        props_cfg=[tuple(map(int,p.split(','))) for p in school.data.tabela('ship_spirit_group.txt')[str(group)][4].split('|')]
        reply=call('ship_spirit_init',front)
        assert reply=='2 ship_spirit_init 0 12560 %d:1,0,1'%front,reply
        refused(call('ship_spirit_level_up',group,front,2,'s0'),'presentes_insuficientes')
        refused(call('ship_spirit_level_up',group+1,front,2,'s1'),'ninja_fora_do_grupo_de_espirito')
        refused(call('ship_spirit_level_up',group,999,2,'s2'),'ninja_nao_possuido')
        big=props_cfg[2]; give(big[1],3)
        speed0=eff(front)['speed']
        reply=call('ship_spirit_level_up',group,front,2,'s3')
        assert reply.startswith('2 ship_spirit_level_up 0 6024 '),reply
        # ship_spirit_param stall 1 levels 1..3 need 20 each; the big gift gives 60.
        assert big[3]==60 and school.spirit_state(school.state(db,account),front)==(4,0,1)
        assert stock(big[1])==2 and ' 12560 %d:4,0,1 '%front in reply
        row=school.spirit_attributes()[(attr,1,4)]
        assert eff(front)['speed']==speed0+float(row[5]),(eff(front)['speed'],speed0,row)
        assert call('ship_spirit_level_up',group,front,2,'s3')==reply and stock(big[1])==2
        # batch gift (one of the middle item) and gift-all
        give(props_cfg[1][1],1)
        reply=call('ship_spirit_batch_level_up',group,front,'0,1,0','b1')
        assert reply.split(' ')[2]=='0' and stock(props_cfg[1][1])==0,reply
        reply=call('ship_spirit_level_up',group,front,-1,'all')
        assert reply.split(' ')[2]=='0' and stock(big[1])==0,reply
        refused(call('ship_spirit_level_up',group,front,-1,'none'),'presente_ausente')
        # stall transition: last level of stall 1 leads to stall 2 level 1
        s=school.state(db,account); s['spirits'][str(front)]=[20,0,1]
        with db._conn: school.save(db,account,s)
        give(big[1],1); call('ship_spirit_level_up',group,front,2,'stall')
        assert school.spirit_state(school.state(db,account),front)==(1,10,2)
        # maximum (ship_config 48 = 600, last stall 15)
        s=school.state(db,account); s['spirits'][str(front)]=[600,0,15]
        with db._conn: school.save(db,account,s)
        give(big[1],1); refused(call('ship_spirit_level_up',group,front,2,'max'),'espirito_no_nivel_maximo')
        assert stock(big[1])==1
        s=school.state(db,account); s['spirits'][str(front)]=[4,0,1]
        with db._conn: school.save(db,account,s)

        # --- relogin carries the persisted state
        login=server.despacha('9\r\nlogin_init')
        assert '%d:4,0,1'%front in login and ' 12560 ' in login and ' 15995 ' in login
        info=json.loads(login.split(' 15997 ',1)[1].split(' ',1)[0])
        assert info['local_ship_spirit'][str(front)]=='%d:4,0,1'%front
        (root/'build/school-login.txt').write_text(login,encoding='utf8')
        print('NINJA_SCHOOL_BACKEND_PASSED talents(level/reset/refund/combat), spirit(init/gift/batch/all/stall/cap/speed), retries, relogin')
    finally: db._conn.close()
