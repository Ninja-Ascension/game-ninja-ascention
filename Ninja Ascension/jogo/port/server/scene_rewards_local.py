"""Original scene star chests, saved inventory and one receipt per chest."""
import json,secrets
import dados_batalha as data
from hero_training_local import inventory_tokens
from tutorial_campaign import scene_tokens

def _draw_group(group_id):
    """Roll one original scene_reward_drop library group."""
    rows=[r for r in data.tabela('scene_reward_drop.txt').values()
          if len(r)>4 and r[1]==str(group_id)]
    if not rows:
        return None
    if len(rows)!=1:
        raise ValueError('biblioteca_de_recompensa_ambigua')
    row=rows[0]
    draw_type=int(row[2]);draws=int(row[3])
    if draw_type not in (1,2) or draws<0:
        raise ValueError('biblioteca_de_recompensa_invalida')
    entries=[]
    for raw in row[4].split('|'):
        if not raw:continue
        parts=raw.split(',')
        if len(parts)!=4:raise ValueError('entrada_de_recompensa_invalida')
        ident,kind=int(parts[0]),int(parts[1])
        low,high=map(int,parts[2].split('-'))
        wlow,whigh=map(int,parts[3].split('-'))
        if low<0 or high<low:raise ValueError('quantidade_de_recompensa_invalida')
        if wlow<=0 or whigh<wlow:continue
        if kind==6 and str(ident) not in data.tabela('prop_mould.txt'):
            raise ValueError('item_de_recompensa_ausente')
        if kind not in (1,2,3,4,5,6,7,34):
            raise ValueError('tipo_de_recompensa_nao_suportado')
        entries.append((ident,kind,low,high,wlow,whigh))
    if not entries and draws:
        raise ValueError('biblioteca_de_recompensa_vazia')
    output=[]
    for _ in range(draws):
        if draw_type==1:
            selected=entries
        else:
            total=max(entry[5] for entry in entries)
            roll=1+secrets.randbelow(total)
            selected=[next((entry for entry in entries if entry[4]<=roll<=entry[5]),None)]
            if selected[0] is None:
                raise ValueError('faixa_de_sorteio_sem_item')
        for ident,kind,low,high,_,_ in selected:
            amount=low+(secrets.randbelow(high-low+1) if high>low else 0)
            if amount:output.append((ident,kind,amount))
    return output

def _npc_reward_entries(reward_id):
    extended=data.tabela('scene_reward_ex.txt').get(str(reward_id))
    if not extended or len(extended)<=6:
        raise ValueError('recompensa_de_npc_ausente')
    output=[]
    for specification in extended[6].split('|'):
        if specification in ('','0','-1'):continue
        parts=specification.split(',',1)
        if len(parts)!=2 or not parts[0].isdigit():
            raise ValueError('biblioteca_de_recompensa_invalida')
        bounds=list(map(int,parts[1].split('-',1)))
        if len(bounds)!=2 or bounds[0]<0 or bounds[1]<bounds[0]:
            raise ValueError('quantidade_de_biblioteca_invalida')
        group=_draw_group(parts[0])
        if group is None:
            # Some original NPC rows reference removed optional libraries;
            # use their still-present scene_reward record for its fixed drops.
            base=data.tabela('scene_reward.txt').get(str(reward_id))
            if not base:
                raise ValueError('biblioteca_e_recompensa_original_ausentes')
            return _base_reward_entries(base)
        for _ in range(bounds[0]+(secrets.randbelow(bounds[1]-bounds[0]+1) if bounds[1]>bounds[0] else 0)):
            output.extend(group)
    if not output:
        base=data.tabela('scene_reward.txt').get(str(reward_id))
        if base:return _base_reward_entries(base)
        raise ValueError('recompensa_de_npc_vazia')
    return output

def _base_reward_entries(reward):
    output=[]
    for kind,raw in enumerate(reward[2:7],1):
        amount=int(raw or 0)
        if amount>0:output.append((-1,kind,amount))
    for raw in (reward[7] if len(reward)>7 else '').split('|'):
        if raw in ('','0','-1'):continue
        parts=raw.split(',');amount,ident=map(int,parts[:2])
        chance=parts[2] if len(parts)>2 else '1/1'
        numerator,denominator=map(int,chance.split('/')) if '/' in chance else (int(chance),1)
        if denominator<=0 or not 0<=numerator<=denominator:
            raise ValueError('probabilidade_de_item_invalida')
        if secrets.randbelow(denominator)<numerator:output.append((ident,6,amount))
    return output

def _apply_npc_reward(db,account,items):
    import shop_local
    db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)',(account,))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)',(account,))
    for ident,kind,amount in items:
        if kind==1:db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(amount,account))
        elif kind==2:db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?',(amount,account))
        elif kind==3:db._conn.execute('UPDATE local_resources SET honour=honour+? WHERE conta_id=?',(amount,account))
        elif kind==4:db._conn.execute('UPDATE local_resources SET soul=soul+? WHERE conta_id=?',(amount,account))
        elif kind==5:db._conn.execute('UPDATE local_resources SET jade=jade+? WHERE conta_id=?',(amount,account))
        elif kind in (6,7):shop_local.grant(db,account,kind,ident,amount)
        elif kind==34:
            if ident!=-1:raise ValueError('id_de_ponto_de_talento_invalido')
            import ninja_school_local
            ninja_school_local.schema(db)
            state=ninja_school_local.state(db,account)
            state['talentPoints']=int(state.get('talentPoints',0))+amount
            ninja_school_local.save(db,account,state)
        else:raise ValueError('tipo_de_recompensa_nao_suportado')

def install(server):
    db=server.BANCO
    with db._lock,db._conn:
        db._conn.execute('''CREATE TABLE IF NOT EXISTS local_npc_chest_rewards(
            conta_id INTEGER NOT NULL,scene INTEGER NOT NULL,npc INTEGER NOT NULL,
            tier INTEGER NOT NULL,items TEXT NOT NULL,
            PRIMARY KEY(conta_id,scene,npc,tier))''')
    def draw(seq,text):
        try:
            account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            # The client may end the parameter list with an empty line.
            lines=[line for line in server._linhas(text) if line.strip()]
            if len(lines)!=3 or lines[0]!=str(db.perfil(account)['user_id']):raise ValueError('perfil_invalido')
            scene,index=int(lines[1]),int(lines[2]);definition=data.tabela('pve_scene.txt').get(str(scene))
            if not definition:raise ValueError('cena_invalida')
            rewards=definition[10].split(',');thresholds=definition[11].split(',')
            if not 0<=index<len(rewards) or index>=len(thresholds):raise ValueError('bau_invalido')
            reward=data.tabela('scene_reward.txt').get(rewards[index])
            if not reward:raise ValueError('recompensa_invalida')
            if any(reward[i] not in ('','0','-1') for i in (8,10)):raise ValueError('bau_com_equipamento_ou_personagem_nao_suportado')
            currencies=list(map(int,reward[2:7]))
            with db._lock:
                receipt=db._conn.execute('SELECT items FROM local_scene_rewards WHERE conta_id=? AND scene=? AND chest=?',(account,scene,index)).fetchone()
                fresh=receipt is None
                if receipt:items=json.loads(receipt[0])
                else:
                    stars=db._conn.execute('SELECT COALESCE(SUM(stars),0) FROM local_pve_clears WHERE conta_id=? AND scene=?',(account,scene)).fetchone()[0]
                    if stars<int(thresholds[index]):raise ValueError('estrelas_insuficientes')
                    items=[]
                    for kind,amount in enumerate(currencies,1):
                        if amount>0:items.append([-1,kind,amount])
                    for entry in reward[7].split('|'):
                        if entry in ('','0','-1'):continue
                        parts=entry.split(',');quantity,mould=int(parts[0]),int(parts[1])
                        numerator,denominator=map(int,parts[2].split('/')) if len(parts)>2 else (1,1)
                        if denominator<=0 or not 0<=numerator<=denominator:raise ValueError('probabilidade_invalida')
                        if str(mould) not in data.tabela('prop_mould.txt'):raise ValueError('item_invalido')
                        if secrets.randbelow(denominator)<numerator:items.append([mould,6,quantity])
                    import initial_tutorial
                    if scene==1 and index==0 and initial_tutorial.managed(db,account):
                        items=initial_tutorial.chest_items()
                    with db._conn:
                        db._conn.execute('INSERT OR IGNORE INTO local_campaign VALUES (?,1,0)',(account,))
                        db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(currencies[0],account))
                        db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)',(account,))
                        db._conn.execute('UPDATE local_resources SET gold=gold+?,honour=honour+?,soul=soul+?,jade=jade+? WHERE conta_id=?',tuple(currencies[1:])+ (account,))
                        for mould,kind,quantity in items:
                            if kind==6:
                                db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                                                 (account,mould,account*1000000+mould,quantity))
                        db._conn.execute('INSERT INTO local_scene_rewards VALUES (?,?,?,?)',(account,scene,index,json.dumps(items)))
                silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
                gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
            tokens=[str(seq),'draw_scene_rewad','0','22',str(silver),'25',str(currencies[1] if fresh else 0),str(gold)]
            tokens+=inventory_tokens(db,account)+scene_tokens(db,account)+['171','0',str(len(items))]
            for item in items:tokens+=list(map(str,item))
            return ' '.join(tokens)
        except (server._contas.ErroConta,ValueError,IndexError) as exc:
            return server.recusa('draw_scene_rewad',seq,str(exc))
    server.MINIMOS['draw_scene_rewad']=draw

    def draw_npc(seq,text):
        try:
            account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            lines=[line for line in server._linhas(text) if line.strip()]
            if len(lines)<3 or lines[0]!=str(db.perfil(account)['user_id']):
                raise ValueError('perfil_invalido')
            scene,index=int(lines[1]),int(lines[2])
            tier=int(lines[3]) if len(lines)>3 else 0
            definition=data.tabela('pve_scene.txt').get(str(scene))
            if not definition:raise ValueError('cena_invalida')
            scene_type=int(definition[5])
            if scene_type not in (0,1,15):raise ValueError('tipo_de_cena_nao_suportado')
            if tier not in ((0,1) if scene_type==15 else (0,)):
                raise ValueError('tipo_de_bau_invalido')
            npcs=[v for v in definition[17].split(',') if v.isdigit()]
            reward_layers=definition[18].split('|')
            if index<0 or index>=len(npcs) or tier>=len(reward_layers):
                raise ValueError('bau_de_npc_invalido')
            rewards=[v for v in reward_layers[tier].split(',') if v not in ('','-1')]
            if len(rewards)!=len(npcs):raise ValueError('mapa_de_recompensa_invalido')
            npc=int(npcs[index]);reward_id=rewards[index]
            if data.tabela('npc.txt').get(str(npc),[None]*108)[107]!=str(scene):
                raise ValueError('npc_fora_da_cena')
            clear=db._conn.execute('SELECT stars FROM local_pve_clears WHERE conta_id=? AND scene=? AND npc=?',(account,scene,npc)).fetchone()
            if not clear or int(clear[0])<=0:raise ValueError('vença_o_npc_antes_de_resgatar')
            if tier==1 and int(clear[0])<3:raise ValueError('tres_estrelas_insuficientes')
            with db._lock,db._conn:
                receipt=db._conn.execute('SELECT items FROM local_npc_chest_rewards WHERE conta_id=? AND scene=? AND npc=? AND tier=?',(account,scene,npc,tier)).fetchone()
                fresh=receipt is None
                if fresh:
                    items=_npc_reward_entries(reward_id)
                    _apply_npc_reward(db,account,items)
                    db._conn.execute('INSERT INTO local_npc_chest_rewards VALUES (?,?,?,?,?)',(account,scene,npc,tier,json.dumps(items)))
                else:items=json.loads(receipt[0])
                silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
                resources=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                gold=resources[0] if resources else 0
            tokens=[str(seq),'draw_scene_npc_rewad','0','22',str(silver),'25',str(gold)]
            tokens+=inventory_tokens(db,account)+scene_tokens(db,account)
            tokens+=['171','0',str(len(items))]
            for item in items:tokens+=list(map(str,item))
            tokens+=(['12409',str(npc)] if tier==1 else ['374',str(npc)])
            return ' '.join(tokens)
        except (server._contas.ErroConta,ValueError,IndexError,TypeError,KeyError) as exc:
            return server.recusa('draw_scene_npc_rewad',seq,str(exc))
    server.MINIMOS['draw_scene_npc_rewad']=draw_npc

    def draw_all(seq,text):
        try:
            account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            lines=[line for line in server._linhas(text) if line.strip()]
            if len(lines)!=2 or lines[0]!=str(db.perfil(account)['user_id']):
                raise ValueError('perfil_invalido')
            scene_type=int(lines[1])
            if scene_type not in (0,1,15):
                raise ValueError('tipo_de_cena_invalido')

            scenes=[]
            for scene_id,definition in data.tabela('pve_scene.txt').items():
                try:
                    if int(definition[5])==scene_type:
                        scenes.append((int(scene_id),definition))
                except (ValueError,IndexError,TypeError):
                    continue
            scenes.sort(key=lambda item:item[0])
            if not scenes:
                raise ValueError('cenas_indisponiveis')

            claimed_items=[]
            with db._lock, db._conn:
                for scene_id,definition in scenes:
                    cleared=db._conn.execute(
                        'SELECT COUNT(*) FROM local_pve_clears WHERE conta_id=? AND scene=?',
                        (account,scene_id)).fetchone()[0]
                    if not cleared:
                        continue
                    stars=db._conn.execute(
                        'SELECT COALESCE(SUM(stars),0) FROM local_pve_clears WHERE conta_id=? AND scene=?',
                        (account,scene_id)).fetchone()[0]
                    reward_ids=definition[10].split(',')
                    thresholds=definition[11].split(',')
                    for index,reward_id in enumerate(reward_ids):
                        if index>=len(thresholds) or stars<int(thresholds[index]):
                            continue
                        receipt=db._conn.execute(
                            'SELECT 1 FROM local_scene_rewards WHERE conta_id=? AND scene=? AND chest=?',
                            (account,scene_id,index)).fetchone()
                        if receipt:
                            continue
                        reward=data.tabela('scene_reward.txt').get(reward_id)
                        if not reward:
                            raise ValueError('recompensa_indisponivel')
                        if any(reward[i] not in ('','0','-1') for i in (8,10)):
                            raise ValueError('bau_com_equipamento_ou_personagem_nao_suportado')

                        currencies=list(map(int,reward[2:7]))
                        items=[[-1,kind,amount] for kind,amount in enumerate(currencies,1) if amount>0]
                        for entry in reward[7].split('|'):
                            if entry in ('','0','-1'):
                                continue
                            parts=entry.split(',')
                            quantity,mould=int(parts[0]),int(parts[1])
                            numerator,denominator=map(int,parts[2].split('/')) if len(parts)>2 else (1,1)
                            if denominator<=0 or not 0<=numerator<=denominator:
                                raise ValueError('probabilidade_invalida')
                            if str(mould) not in data.tabela('prop_mould.txt'):
                                raise ValueError('item_invalido')
                            if secrets.randbelow(denominator)<numerator:
                                items.append([mould,6,quantity])

                        db._conn.execute('INSERT OR IGNORE INTO local_campaign VALUES (?,1,0)',(account,))
                        db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',
                                          (currencies[0],account))
                        db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)',(account,))
                        db._conn.execute(
                            'UPDATE local_resources SET gold=gold+?,honour=honour+?,soul=soul+?,jade=jade+? WHERE conta_id=?',
                            tuple(currencies[1:])+(account,))
                        for mould,kind,quantity in items:
                            if kind==6:
                                db._conn.execute(
                                    'INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                                    (account,mould,account*1000000+mould,quantity))
                        db._conn.execute(
                            'INSERT INTO local_scene_rewards VALUES (?,?,?,?)',
                            (account,scene_id,index,json.dumps(items)))
                        claimed_items.extend(items)

                silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                if silver is None:
                    silver=(0,)
                resources=db._conn.execute(
                    'SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                gold=resources[0] if resources else 0

            tokens=[str(seq),'one_key_draw_scene_reward','0','22',str(silver[0]),'25',str(gold)]
            tokens+=inventory_tokens(db,account)+scene_tokens(db,account)+['171','0',str(len(claimed_items))]
            for item in claimed_items:
                tokens+=list(map(str,item))
            return ' '.join(tokens)
        except (server._contas.ErroConta,ValueError,IndexError,TypeError) as exc:
            return server.recusa('one_key_draw_scene_reward',seq,str(exc) or 'recompensa_indisponivel')

    server.MINIMOS['one_key_draw_scene_reward']=draw_all
