"""Original scene star chests, saved inventory and one receipt per chest."""
import json,secrets
import dados_batalha as data
from hero_training_local import inventory_tokens
from tutorial_campaign import scene_tokens

def install(server):
    db=server.BANCO
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
