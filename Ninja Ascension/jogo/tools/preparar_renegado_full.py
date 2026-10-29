"""Explicit GM grant for RenegadoBR; validate on SQLite memory clone before commit."""
import sys, sqlite3, threading, types, json, datetime, math
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'port/server'))
import dados_batalha as data, recruitment_local as heroes, hero_development_local as dev
import hero_quality_local as quality, equipment_local as eq, equipment_development_local as ed
import treasure_local as treasure, mudra_local as mudra, hero_gates_local as gates, hero_stats_local as stats
ACCOUNT=62

def apply(c):
    db=types.SimpleNamespace(_conn=c,_lock=threading.RLock())
    assert c.execute('SELECT user_name FROM perfis WHERE conta_id=?',(ACCOUNT,)).fetchone()[0]=='RenegadoBR'
    owned=heroes.all_owned(db,ACCOUNT)
    main={r[0] for r in c.execute('SELECT ship_id FROM local_formation_slots WHERE conta_id=?',(ACCOUNT,))}
    assert len(main)==6
    report={'account':'RenegadoBR','ninjas':len(owned),'main':[], 'mudras_created':0}
    for ship,mould in owned:
        r=data.tabela('ship_mould.txt')[str(mould)]
        old=c.execute('SELECT rank_level,level FROM local_ship_rank WHERE conta_id=? AND ship_id=?',(ACCOUNT,ship)).fetchone()
        level=max(100,int(old[1]) if old else 1)
        order=max(quality.quality(db,ACCOUNT,ship,mould),len(quality.requirements(mould)))
        assert order>=19
        c.execute('INSERT INTO local_ship_rank VALUES (?,?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET level=excluded.level',(ACCOUNT,ship,old[0] if old else 0,level))
        c.execute('INSERT INTO local_hero_quality VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET quality=excluded.quality',(ACCOUNT,ship,order))
        state=dev.state(db,ACCOUNT,ship,mould);state['star']=max(7,state['star'])
        if ship in main:
            state['souls']=[[20,0] for _ in r[74].split(',')]
            for soul_id in r[74].split(','):
                soul=data.tabela('ship_soul_mould.txt')[soul_id]
                assert any(row[1]==soul[3] and row[2]=='20' for row in data.tabela('ship_soul_addition_property_param.txt').values())
            report['main'].append({'ship':ship,'mould':mould,'souls':r[74].split(',')})
        c.execute('INSERT INTO local_hero_development VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET state=excluded.state',(ACCOUNT,ship,json.dumps(state,separators=(',',':'))))
        # Six equipment slots, correct awakening transformation chain per ninja.
        for slot,base in enumerate(map(int,r[72].split(',')),1):
            if slot<=4:
                rows=eq.rows(mould,slot);maxlevel=max(rows)
                config={x[0]:x[3] for line in (Path(data.MOULD).parent/'configs/equipment_config.txt').read_text(encoding='utf8').splitlines() if len(x:=line.split('\t'))>3}
                q=max(int(part.split(',')[0]) for part in config['1'].split('|'))
            else:
                rows=treasure.ranks(mould,slot);maxlevel=max(int(x[1]) for x in rows);q=len(rows)
            current=c.execute('SELECT level,quality FROM local_equipment_level WHERE conta_id=? AND ship_id=? AND slot=?',(ACCOUNT,ship,slot)).fetchone()
            maxlevel=max(maxlevel,current[0] if current else 0);q=max(q,current[1] if current else 0)
            c.execute('INSERT INTO local_equipment_level VALUES (?,?,?,?,?) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET level=excluded.level,quality=excluded.quality',(ACCOUNT,ship,slot,maxlevel,q))
            template=base
            for star in range(5):
                er=data.tabela('equipment_mould.txt')[str(template)]
                sr=next(x for x in data.tabela('equipment_star.txt').values() if x[1]==er[46] and int(x[2])==star)
                assert sr[3]!='-1'
                template=int(er[42]) if int(er[42])>0 else template
            c.execute('INSERT INTO local_equipment_awaken VALUES (?,?,?,?,?) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET star=excluded.star,template=excluded.template',(ACCOUNT,ship,slot,5,template))
            c.execute('INSERT INTO local_treasure_exp VALUES (?,?,?,0) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET experience=0',(ACCOUNT,ship,slot))
            harden=ed.state(db,ACCOUNT,ship,slot);harden['level']=int(ed.config(182));harden['exp']=0
            ed.harden_row(slot,harden['level']);ed.update_entries(slot,harden);harden['previous']=[]
            c.execute('INSERT INTO local_equipment_harden VALUES (?,?,?,?) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET state=excluded.state',(ACCOUNT,ship,slot,json.dumps(harden,separators=(',',':'))))
        # Fill each formation with a compatible matrix, preserving existing pieces.
        for idx in (1,2,3):
            count=mudra.slot_count(idx)
            candidates=[]
            for mid in mudra.ship_matrices(mould):
                row=data.tabela('ship_matrix_mould.txt')[str(mid)]
                shapes=[int(k) for part in row[2].split('|') for k,n in [part.split(',')] for _ in range(int(n))]
                if len(shapes)<=count:candidates.append((len(shapes),mid,shapes))
            assert candidates
            shapes=max(candidates)[2];shapes=shapes+[1]*(count-len(shapes))
            for pos,shape in enumerate(shapes,1):
                saved=c.execute('SELECT m.id,m.mould FROM local_metal_slots s JOIN local_metals m ON m.id=s.metal WHERE s.conta_id=? AND s.ship=? AND s.idx=? AND s.pos=?',(ACCOUNT,ship,idx,pos)).fetchone()
                if saved:shape=int(mudra.metal_row(saved[1])[3])
                metal=next(int(x[0]) for x in data.tabela('ship_metal_mould.txt').values() if int(x[3])==shape and x[5]=='6' and x[4] in ('2','4'))
                assert mudra.param_row(metal,120,11)
                if saved:c.execute('UPDATE local_metals SET mould=?,rank=11,level=120,exp=0 WHERE id=?',(metal,saved[0]))
                else:
                    ident=c.execute('INSERT INTO local_metals(conta_id,mould,rank,level,exp) VALUES (?,?,11,120,0)',(ACCOUNT,metal)).lastrowid
                    c.execute('INSERT INTO local_metal_slots VALUES (?,?,?,?,?)',(ACCOUNT,ship,idx,pos,ident));report['mudras_created']+=1
        gate=gates.state(db,ACCOUNT,ship)
        for page in range(1,9):
            gates.row_for('mega_unblock.txt',int(r[8]),page)
            gate['megaLevel'].setdefault(str(page),0)
        c.execute('INSERT INTO local_hero_gates VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET state=excluded.state',(ACCOUNT,ship,json.dumps(gate,separators=(',',':'))))
    # Verify render/stat paths and constraints for every granted character.
    for ship,mould in owned:
        value=stats.effective(db,ACCOUNT,ship,mould)
        assert all(math.isfinite(value[k]) and value[k]>=0 for k in ('health','courage','intellect','quick'))
        assert sum(len(v) for v in mudra.slots(db,ACCOUNT,ship).values())==18
        assert len(gates.state(db,ACCOUNT,ship)['megaLevel'])==8
    assert c.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
    return report

if __name__=='__main__':
    live=sqlite3.connect(ROOT/'port/dados/contas.sqlite3',timeout=30)
    snapshot=sqlite3.connect(':memory:');live.backup(snapshot)
    with snapshot: result=apply(snapshot)
    print('DRY_RUN_OK',json.dumps(result))
    if '--apply' in sys.argv:
        stamp=datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f')
        backup=ROOT/('port/dados/contas-backup-antes-full-renegado-'+stamp+'.sqlite3')
        with sqlite3.connect(backup) as b:
            live.backup(b);assert b.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        with live:
            live.execute('BEGIN IMMEDIATE');result=apply(live)
        result['backup']=str(backup)
        (ROOT/('port/dados/entrega-full-renegado-'+stamp+'.json')).write_text(json.dumps(result,indent=2),encoding='utf8')
        print('COMMITTED',json.dumps(result))
    live.close();snapshot.close()
