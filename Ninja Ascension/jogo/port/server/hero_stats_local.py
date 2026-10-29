"""Authoritative local stats and recovered character bonds; no cached increments."""
import json
from functools import lru_cache
from pathlib import Path

@lru_cache(maxsize=None)
def coefficient(group,key):
    path=Path(data.MOULD).parent/"configs"/"fight_config.txt"
    for line in path.read_text(encoding="utf-8").splitlines():
        row=line.split("\t")
        if row[0]==str(group):
            return dict((int(k),float(v)) for k,v in (x.split(",") for x in row[3].split("|")))[int(key)]
    raise ValueError("coeficiente_de_atributo_ausente")
import dados_batalha as data

def relationships(db,account,mould):
    import recruitment_local as heroes
    owned={str(m) for _,m in heroes.all_owned(db,account)}
    result=[]
    for ident in data.tabela('ship_mould.txt')[str(mould)][29].split(','):
        row=data.tabela('fate_relationship_mould.txt').get(ident)
        if not row:continue
        active=True;requirements=0
        for i in range(3,15,2):
            if int(row[i])<=0:continue
            requirements+=1
            # Equipment bonds require the specified item actually equipped;
            # an item in the inventory is not evidence of activation.
            if row[i+1]!='0' or row[i] not in owned:active=False
        result.append((ident,active and requirements>0))
    return result

def effective(db,account,ship,mould):
    import hero_level_local as levels
    import hero_quality_local as quality
    import hero_development_local as development
    r=data.tabela('ship_mould.txt')[str(mould)]
    level,_,_=levels.state(db,account,ship,mould)
    order=quality.quality(db,account,ship,mould)
    develop=development.state(db,account,ship,mould)
    star=develop['star']
    # Recovered coefficients: A/B add base growth units, C/D add per-level
    # growth. This is the explicit local reconstruction, not a server dump.
    base_bonus=coefficient(1,star)+coefficient(2,order)
    growth_bonus=coefficient(3,star)+coefficient(4,order)
    units=base_bonus+(level-1)*(1+growth_bonus)
    values=[float(r[i])+units*float(r[i+11]) for i in range(12,16)]
    import hero_gates_local as gates
    gate_state=gates.state(db,account,ship)
    for page,gate_level in gate_state['megaLevel'].items():
        if int(page) not in (1,3,5,7):continue
        row=gates.row_for('mega_property.txt',int(r[8]),int(page))
        for index in range(int(gate_level)+1):
            for pair in row[index+3].split('|'):
                kind,amount=pair.split(',');kind=int(kind)
                if 0<=kind<=3:values[kind]+=float(amount)
    properties={}
    for index,faction in enumerate(r[74].split(',')):
        soul=data.tabela('ship_soul_mould.txt').get(faction)
        if not soul or order<int(soul[1]):continue
        soul_level=develop['souls'][index][0]
        bonus=next((v for v in data.tabela('ship_soul_addition_property_param.txt').values() if v[1]==soul[3] and int(v[2])==soul_level),None)
        if bonus and bonus[3] not in ('-1','0',''):
            for pair in bonus[3].split('|'):
                kind,amount=pair.split(',');kind=int(kind);amount=float(amount)
                if 0<=kind<=3:values[kind]+=amount
                else:properties[kind]=properties.get(kind,0)+amount
    # Ninja School talents and digital spirit (original tables; see
    # ninja_school_local.combat_bonus for the local position/class rules).
    import ninja_school_local as school
    school_flat,school_percent,school_properties,school_speed=school.combat_bonus(db,account,ship,mould)
    import equipment_local
    equipment,equipment_properties=equipment_local.bonus(db,account,ship,mould,with_properties=True)
    values=[v+school_flat[i]+equipment[i] for i,v in enumerate(values)]
    for kind,amount in school_properties.items():properties[kind]=properties.get(kind,0)+amount
    for kind,amount in equipment_properties.items():properties[kind]=properties.get(kind,0)+amount
    import fight_spirit_local
    for kind, amount in fight_spirit_local.bonus(db,account,ship).items():
        if 0<=kind<=3:values[kind]+=amount
        else:properties[kind]=properties.get(kind,0)+amount
    property_values='|'.join(str(k)+':'+str(round(v,6)) for k,v in sorted(properties.items())) or '0:0'
    bonds=relationships(db,account,mould);percent=[p/100 for p in school_percent]
    for ident,active in bonds:
        if active:
            row=data.tabela('fate_relationship_mould.txt')[ident]
            for i in range(4):percent[i]+=float(row[15+i])/100
    values=[v*(1+percent[i]) for i,v in enumerate(values)]
    # User-confirmed Advance rule: +5 initiative per completed quality step.
    # User-confirmed original promotion rule: +20 per star gained; level gives none.
    advance=max(0,quality.quality(db,account,ship,mould)-int(r[44]))
    # Spirit speed_add is the cumulative value stored in ship_spirit_mould.
    speed=float(r[11])+advance*5+max(0,star-int(r[48]))*20+school_speed
    return dict(ship=str(ship),health=values[0],courage=values[1],intellect=values[2],quick=values[3],speed=speed,property_values=property_values,bonds=[dict(relationship_id=k,is_activited='1' if active else '0') for k,active in bonds])

def attribute_tokens(db,account):
    import recruitment_local as heroes
    values=[effective(db,account,ship,mould) for ship,mould in heroes.all_owned(db,account)]
    speed=sum(v['speed'] for v in values)
    # Ninja School achievements: the speed of every claimed achievement
    # (achievement.achievement_speed, SmCultivateAchieveWindow.lua:195) adds to team speed.
    import achievements_local
    speed+=achievements_local.score(db,account)
    import hero_gates_local
    return hero_gates_local.snapshot(db,account)+['15995',json.dumps(values,separators=(',',':')),'12042',str(int(speed))]

def snapshot_tokens(db,account):
    import ninja_school_local
    return ninja_school_local.snapshot(db,account)+attribute_tokens(db,account)

def install(server):
    original=server.despacha
    commands={'login_init','login_init_again','equipment_escalate','ship_escalate','ship_grow_up','ship_awaken','ship_skill_level_up','ship_skill_level_up_one_key','ship_soul_level_up','formation_change','new_recruitment_system','prop_compound','mega_unblock','mega_level_up','mega_use_skill','fight_spirit_change'}
    def dispatch(text):
        reply=original(text)
        command=text.split('\r\n')[1] if '\r\n' in text else ''
        if command in commands and len(reply.split(' ',3))>=3 and reply.split(' ',3)[2]=='0':
            session=server.BANCO.sessao_de(server._sessao_da_conexao())
            with server.BANCO._lock:
                reply+=' '+' '.join(snapshot_tokens(server.BANCO,session['conta_id']))
        return reply
    server.despacha=dispatch
