"""Book/accessory EXP and promotion, using equipment_rank_link and real instances."""
import json,re
from pathlib import Path
import dados_batalha as data


COMMANDS=('treasure_escalate','treasure_onekey_escalate')


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_treasure_exp(conta_id INTEGER,ship_id INTEGER,slot INTEGER,experience INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(conta_id,ship_id,slot))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_treasure_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')


def experiences(db,account,ship):
    if not db._conn.execute("SELECT 1 FROM sqlite_master WHERE name='local_treasure_exp'").fetchone():return [0]*6
    saved=dict(db._conn.execute('SELECT slot,experience FROM local_treasure_exp WHERE conta_id=? AND ship_id=?',(account,ship)).fetchall())
    return [int(saved.get(i,0)) for i in range(1,7)]


def ranks(mould,slot):
    group=data.tabela('ship_mould.txt')[str(mould)][73].split(',')[slot-1]
    return sorted((r for r in data.tabela('equipment_rank_link.txt').values() if r[16]==group),key=lambda r:int(r[1]))


def exp_needed(level):
    return int(data.tabela('equipment_refining_experience_param.txt')[str(level)][2])


def exp_price():
    rows=(line.split('\t') for line in (Path(data.MOULD).parent/'configs/equipment_config.txt').read_text(encoding='utf8').splitlines())
    return int(next(r[3] for r in rows if r[0]=='6'))


def upgrade(server,command,seq,text):
    import equipment_local as equipment
    import recruitment_local as heroes
    import hero_stats_local
    import shop_local,shop_special_local
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
        quick=command=='treasure_onekey_escalate'
        if len(fields)!=(6 if quick else 5) or fields[0]!=str(db.perfil(account)['user_id']) or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[-1]):raise ValueError('pedido_de_livro_invalido')
        ship,slot=int(fields[1]),int(fields[3]);key=fields[-1];signature=command+'|'+'|'.join(fields[1:-1])
        if slot not in (5,6):raise ValueError('slot_de_tesouro_invalido')
        supplied=fields[2];promotion_only=supplied=='0' and not quick
        if not promotion_only and not re.fullmatch(r'\d+(,\d+)*',supplied):raise ValueError('materiais_de_tesouro_invalidos')
        ids=[] if promotion_only else list(map(int,supplied.split(',')))
        if len(ids)>10000 or len(set(ids))!=len(ids):raise ValueError('materiais_de_tesouro_repetidos')
        with db._lock,db._conn:
            old=db._conn.execute('SELECT signature,reply FROM local_treasure_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
            if old:
                if old[0]!=signature:raise ValueError('identificador_reutilizado')
                return str(seq)+' '+old[1].split(' ',1)[1]
            mould=dict(heroes.all_owned(db,account)).get(ship)
            if mould is None:raise ValueError('personagem_nao_pertence_a_conta')
            table=ranks(mould,slot)
            level=equipment.levels(db,account,ship)[slot-1];quality=equipment.qualities(db,account,ship)[slot-1];experience=experiences(db,account,ship)[slot-1]
            before=(level,quality,experience);maximum=max(int(r[1]) for r in table)
            target=int(fields[4]) if quick else maximum
            if not 1<=target<=maximum or (quick and target<=level):raise ValueError('nivel_alvo_invalido')
            wallet=db._conn.execute('SELECT grade,silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
            if not wallet:raise ValueError('progresso_ausente')
            user_level,silver=map(int,wallet);currency=shop_special_local.balance(db,account,3 if slot==5 else 4)
            cost=other_cost=0;removed=[];reason='nivel_maximo_do_tesouro'
            materials=[]
            for ident in ids:
                item=db._conn.execute('SELECT mould FROM local_shop_equipment WHERE conta_id=? AND id=?',(account,ident-2000000000)).fetchone()
                row=data.tabela('equipment_mould.txt').get(str(item[0])) if item else None
                if not row or int(row[4])!=slot-1 or int(row[35])<=0:raise ValueError('material_de_tesouro_nao_possuido_ou_incompativel')
                materials.append((ident,int(row[35])))
            def promote():
                nonlocal quality,cost,other_cost,reason
                if quality>=len(table):reason='nivel_maximo_do_tesouro';return False
                row=table[quality]
                if level<int(row[1]):reason='nivel_de_promocao_nao_atingido';return False
                required=row[17].split(',');required=int(required[slot-5] if len(required)>1 else required[0])
                if required>user_level:reason='nivel_do_jogador_insuficiente';return False
                kind,amount=map(int,row[15].split(',')[1:3]);price=int(row[13])
                if kind!=(3 if slot==5 else 18) or min(price,amount)<0:raise ValueError('custo_de_promocao_invalido')
                if cost+price>silver:reason='prata_insuficiente';return False
                if other_cost+amount>currency:reason='moeda_de_promocao_insuficiente';return False
                cost+=price;other_cost+=amount;quality+=1;return True
            if promotion_only:
                if not promote():raise ValueError(reason)
            else:
                index=0
                while level<target:
                    boundary=int(table[min(quality,len(table)-1)][1])
                    if level>=boundary:
                        if not quick:reason='promocao_do_tesouro_necessaria';break
                        if not promote():break
                        continue
                    needed=exp_needed(level)
                    if needed<=0:raise ValueError('tabela_de_exp_invalida')
                    if experience>=needed:
                        experience-=needed;level+=1;continue
                    if index>=len(materials):reason='materiais_insuficientes';break
                    ident,gain=materials[index];price=gain*exp_price()
                    if cost+price>silver:reason='prata_insuficiente';break
                    cost+=price;experience+=gain;removed.append(ident);index+=1
            if before==(level,quality,experience):raise ValueError(reason)
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?',(cost,account))
            if other_cost:
                if slot==5:db._conn.execute('UPDATE local_resources SET honour=honour-? WHERE conta_id=?',(other_cost,account))
                else:db._conn.execute('UPDATE local_special_wallet SET trial=trial-? WHERE conta_id=?',(other_cost,account))
            for ident in removed:db._conn.execute('DELETE FROM local_shop_equipment WHERE conta_id=? AND id=?',(account,ident-2000000000))
            db._conn.execute('INSERT INTO local_equipment_level VALUES (?,?,?,?,?) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET level=excluded.level,quality=excluded.quality',(account,ship,slot,level,quality))
            db._conn.execute('INSERT INTO local_treasure_exp VALUES (?,?,?,?) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET experience=excluded.experience',(account,ship,slot,experience))
            metadata=heroes.one_ship_tokens(db,account,(ship,mould));metadata=metadata[metadata.index('14104'):]
            wallet_tokens=['15991',json.dumps({'wallet':{str(p):shop_special_local.balance(db,account,p) for p in shop_special_local.TABLES}},separators=(',',':'))]
            tokens=[str(seq),command,'0','22',str(silver-cost)]+metadata+shop_local.state_tokens(db,account,removed_equipment=removed)+wallet_tokens+hero_stats_local.attribute_tokens(db,account)
            reply=' '.join(tokens)
            db._conn.execute('INSERT INTO local_treasure_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
        server.log('TREASURE_UPGRADE conta=%s ship=%s slot=%s estado=%s->%s prata=%s moeda=%s consumidos=%s'%(account,ship,slot,before,(level,quality,experience),cost,other_cost,len(removed)))
        return reply
    except (server._contas.ErroConta,ValueError,KeyError,IndexError) as exc:return server.recusa(command,seq,str(exc))


def install(server):
    with server.BANCO._lock,server.BANCO._conn:schema(server.BANCO)
    for command in COMMANDS:server.MINIMOS[command]=lambda seq,text,cmd=command:upgrade(server,cmd,seq,text)
