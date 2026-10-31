"""Initial Naruto, one persisted Sakura draw and the starting formation."""
import json
import dados_batalha as data
import math
from gameplay_mode import tutorial_enabled, STARTERS

def all_owned(db,account):
    # mission3's first quality lesson explicitly targets the initial mould 13.
    result=[(account*100000+13,13)]
    if not tutorial_enabled(db,account) and not __import__('initial_tutorial').managed(db,account):
        result=[(account*100000+(1 if mould==50 else mould),mould) for mould in STARTERS]
    recruit=owned(db,account)
    if recruit and recruit[1] not in {m for _,m in result}:result.append(recruit)
    with db._lock:
        extra=db._conn.execute('SELECT ship_id,mould FROM local_synthesized WHERE conta_id=? ORDER BY mould',(account,)).fetchall()
    result.extend(tuple(row) for row in extra if row[1] not in {m for _,m in result})
    # Ninjas hidden from this account (kept, not deleted; GM tests).
    with db._lock:
        db._conn.execute('CREATE TABLE IF NOT EXISTS local_hidden_ships (conta_id INTEGER NOT NULL, mould INTEGER NOT NULL, PRIMARY KEY(conta_id, mould))')
        hidden={r[0] for r in db._conn.execute('SELECT mould FROM local_hidden_ships WHERE conta_id=?',(account,))}
    return [r for r in result if r[1] not in hidden]

def owned(db,account):
    with db._lock:
        row=db._conn.execute('SELECT ship_id,mould FROM tutorial_recruit WHERE conta_id=?',(account,)).fetchone()
    return tuple(row) if row else None

def init_tokens(db,account):
    if not tutorial_enabled(db,account):
        from normal_recruit import state_payload
        return ['15005',json.dumps(state_payload(db,account),separators=(',',':'))]
    has=not tutorial_enabled(db,account) or owned(db,account) is not None
    payload={'totalDraw':int(has),'totalFreeDraw':int(not has),'newRecruitmentShop':recruit_shop_remain()}
    return ['15005',json.dumps(payload,separators=(',',':'))]

def _slots_locked(db,account):
    saved=db._conn.execute('SELECT position,ship_id FROM local_formation_slots WHERE conta_id=?',(account,)).fetchall()
    if saved:
        slots=['0']*6
        for position,ship in saved:slots[position-1]=str(ship)
        return slots
    slots=['0']*6
    slots[1]=str(account*100000+13)
    if not tutorial_enabled(db,account) and not __import__('initial_tutorial').managed(db,account):
        slots[3]=str(account*100000+35)
        slots[5]=str(account*100000+1)
    row=db._conn.execute('SELECT ship_id,position FROM tutorial_formation WHERE conta_id=?',(account,)).fetchone()
    if row:slots[int(row[1])-1]=str(row[0])
    return slots

def formation_tokens(db,account):
    with db._lock:slots=_slots_locked(db,account)
    return ['6012','1']+slots+['188',','.join(slots)]


def herois_da_formacao(db, account, usuario, nome):
    """Herois do jogador para o parser 182, na ordem das vagas 1..6.

    O parser indexa por _pos (ProtocolParserCopy.lua:6551), entao cada heroi
    precisa levar a posicao em que esta e o molde real (_mouldId) que o
    cliente usa para carregar o modelo na cena de batalha. Mandar _mouldId 0
    (como era antes) fazia o NPC nao abrir.

    Devolve [] quando a formacao esta vazia — o chamador recusa com motivo em
    vez de inventar um combatente.
    """
    slots = _slots_locked(db, account)
    r = data.tabela('ship_mould.txt')
    herois = []
    for posicao, ship_id in enumerate(slots, 1):
        if not ship_id or ship_id == '0':
            continue
        entrada = next((e for e in all_owned(db, account) if str(e[0]) == str(ship_id)), None)
        if entrada is None:
            continue
        _ship, mould = entrada
        linha = r.get(str(mould))
        if linha is None:
            continue

        def col(n, _l=linha):
            return _l[n - 1] if len(_l) >= n else '0'

        import hero_stats_local
        import hero_quality_local
        with db._lock:
            stats=hero_stats_local.effective(db,account,ship_id,mould)
            quality=hero_quality_local.quality(db,account,ship_id,mould)
        herois.append({
            '_id': str(ship_id),
            '_pos': str(posicao),
            '_head': col(4) or '1',
            '_power_skill_id': col(37) or '0',
            '_fit_skill_id': '0',
            '_quality': str(quality),
            '_hp': str(int(stats['health'])),
            '_sp': '0',
            '_type': '0',
            '_mouldId': str(mould),
            '_scale': '1',
            '_name': nome,
            '_evolution_level': '0',
            '_hero_speed': str(int(stats['speed'])),
            '_max_hp': str(int(stats['health'])),
        })
    return herois

def ship_tokens(db,account,only_mould=None):
    result=[]
    for entry in all_owned(db,account):
        if only_mould is None or entry[1]==only_mould:result+=one_ship_tokens(db,account,entry)
    return result

def _tipo_de_nave(col):
    """ship_type no formato 'a|b'. O parser 3 (ProtocolParserCopy.lua:577) le
    o campo como texto; esquema vazio quebra a montagem da carta, entao usa
    um par neutro quando a planilha nao traz o dado."""
    tipo = col(5) if callable(col) else ''
    if not tipo or '|' not in tipo:
        return '0|-1'
    return tipo


def one_ship_tokens(db,account,entry):
    ship,mould=entry
    r=data.tabela('ship_mould.txt')[str(mould)]
    def col(n): return r[n-1]
    # Nome do personagem: ship_mould.col72 -> ship_evo_mould -> word_mould.
    # O acervo recuperado tem buracos: ha entradas de ship_evo_mould cujo id
    # de nome nao existe em word_mould (ex.: personagem 347 -> 25116). Sem
    # tolerar isso, o login inteiro caia com KeyError e nenhum personagem
    # carregava. O personagem continua aparecendo, so com nome generico.
    name='Ninja_%s' % mould
    try:
        evo=data.tabela('ship_evo_mould.txt')[col(72).split(',')[0]]
        palavra=data.tabela('word_mould.txt').get(str(evo[1]))
        if palavra and len(palavra)>2 and palavra[2]:
            name=palavra[2].replace(' ','_')
    except (KeyError,IndexError,AttributeError) as exc:
        db_nome = getattr(db,'log_nome_faltando',None)
        if callable(db_nome):
            db_nome(mould,exc)
    # Nivel e rank vem do BANCO, nao da planilha: a planilha so traz o valor
    # inicial de cada personagem. Nivel maximo = 100 (power_exp_param.txt).
    # Rank 21 -> 3 estrelas no tier 7 = o "7 estrelas" (getHeroStars).
    with db._lock:
        prog=db._conn.execute(
            'SELECT rank_level, level FROM local_ship_rank WHERE conta_id=? AND ship_id=?',
            (account,ship)).fetchone()
    nivel=int(prog[1]) if prog and len(prog)>1 and prog[1] else 1
    rank=int(prog[0]) if prog and prog[0] else int(col(45) or 0)
    # Ordem EXATA do ramo l_naruto (ProtocolParserCopy.lua:523-558): 27 campos.
    # ATENCAO: o 'if' da linha 519 inclui __lua_project_l_naruto, entao ESTE e
    # o ramo usado. O bloco a partir da linha 570 ('else') tem 33 campos
    # (ship_place, ship_force, *_grade_type...) e NAO roda neste projeto.
    # Depois dos 27 vem (linhas 704-756):
    #   28 relationship_count   (+2 por relacao)
    #   29 talent_count         (+2 por talento)
    #   30..37 ship_train_info (8 valores)
    #   38..39 skill_level, skill_value
    #   40..43 awakenLevel, awakenstates, combLockState, combUpLockState
    # Total com os dois contadores em 0: 43.
    #
    # Nenhum campo pode ser '' (string vazia): a resposta e separada por tab e
    # '' nao gera token, deslocando todos os campos seguintes em 1.
    import ninja_school_local as school
    with db._lock:spirit=school.spirit_token(ship,school.state(db,account))
    fields=[str(ship),           # 1  ship_id
            str(mould),          # 2  ship_template_id
            col(53),             # 3  ship_base_template_id
            '0',                 # 4  captain_type
            spirit,              # 5 spirit state: ship:level,affinity,tier (persisted)
            '0',                 # 6  ship_fighting_spirit
            '0',                 # 7  ship_skin_info
            '0|-1',              # 8  ship_type
            col(36) or '-',      # 9  captain_name
            name,                # 10 ship_name
            str(nivel),          # 11 ship_grade = NIVEL do personagem
            col(13),             # 12 ship_health
            col(14),             # 13 ship_courage
            col(15),             # 14 ship_intellect
            col(16),             # 15 ship_quick
            '0',                 # 16 initial_sp_increase
            '-',                 # 17 property_values (nunca vazio)
            col(37),             # 18 ship_picture
            str(math.floor((float(col(14))*.5+float(col(13))*.1+(float(col(15))+float(col(16)))*.75)*7.5)),  # 19 hero_fight
            col(10),             # 20 ship_leader
            col(11),             # 21 ship_wisdom
            col(28),             # 22 skill_mould
            '0',                 # 23 skill_name
            '0',                 # 24 skill_describe
            col(29),             # 25 deadly_skill_mould
            '0',                 # 26 exprience
            '0',                 # 27 grade_need_exprience
            '0',                 # 28 relationship_count (laco 706)
            '0',                 # 29 talent_count       (laco 716)
            '0','0','0','0','0','0','0','0',   # 30-37 ship_train_info
            '0','0',             # 38-39 skill_level, skill_value
            '0','0','0','0',     # 40-43 awakenLevel, awakenstates,
    ]                        #        combLockState, combUpLockState
    # This function emits code 9, NOT the shorter inline parser-3 record.
    import hero_level_local
    with db._lock:
        nivel,experience,required=hero_level_local.state(db,account,ship,mould)
    base_col=col
    import hero_stats_local
    with db._lock:stats=hero_stats_local.effective(db,account,ship,mould)
    def col(n):
        if 13<=n<=16:return str(stats[('health','courage','intellect','quick')[n-13]])
        if n==12:return str(stats['speed'])
        return base_col(n)
    # Code 9 has ship_place, growth fields, eight equipment slots and a
    # description before training. Mixing these structures shifts metadata.
    import hero_power_local
    character_power=hero_power_local.character(db,account,ship,mould,stats)
    fields=[str(ship),str(mould),col(53),'0',col(4),'0','0','0|-1',col(36),
            name,name,str(nivel),col(13),col(14),col(15),col(16),
            '0','',col(37),str(character_power),
            col(10),col(11),col(12),'0','0','0','0',col(28),'0','0',col(29),
            '0','0','0','0','0','0','0']
    fields+=['0']*8+['0','0','-']+['0']*10

    import hero_development_local as development
    with db._lock:develop=development.state(db,account,ship,mould)
    fields[5]=str(ship)+':1,0,1'
    fields[6]=development.soul_text(develop)
    fields[17]=stats['property_values']
    bonds=stats['bonds']
    relationship_fields=[str(len(bonds))]
    for bond in bonds:relationship_fields += [bond['relationship_id'],bond['is_activited']]
    fields[46:47]=relationship_fields
    fields[33]=str(experience)
    fields[34]=str(required)

    # Indices nomeados de ship_mould (LocalDatas.lua:1246-1325):
    #   initial_rank_level=45 -> "品阶" (Order), lido pelo parser 14104
    #   ship_star=49          -> "星级" (StarRating), idem
    # O parser do user_ship (ProtocolParserCopy.lua:613) zera StarRating e fixa
    # evolution_status; os valores reais chegam depois pelo bloco 14104
    # (ProtocolParserCopyExx.lua:11831-11843). Por isso o bloco abaixo e a
    # unica fonte de Order/StarRating, e ele estava mandando col(45) tambem
    # como StarRating: o Naruto ficava com Star 0 em vez de 1 (getHeroStars
    # devolve estrela 1 para rank 0, EnvironmentDatas:5797). Efeito real: o
    # guia mission3 grupo 4 nao reconhecia o primeiro avanco e voltava a fala
    # 30402 em laco, pois wjmp:13-1 exige Order >= 1 (Mission.lua:1348-1355).
    quality=col(45)
    star=col(49)
    # Rank/estrela efetivos, ja lidos acima de local_ship_rank. O rank da
    # planilha (col 45) e so o inicial.
    # ATENCAO: o rank NAO vai em fields[8] — esse campo e captain_name no
    # parser (ProtocolParserCopy.lua:533). Ele alimenta o bloco 14104.
    if rank>0:
        quality=str(rank)
        # espelha getHeroStars: 3 estrelas cheias, tier = rank/3
        star=str(3 if rank%3==0 else rank%3)
    if mould==13 and rank==0:
        with db._lock:
            state=db._conn.execute('SELECT quality FROM tutorial_training WHERE conta_id=?',(account,)).fetchone()
        # LOCAL: a primeira melhoria fica em tutorial_training.quality.
        # O guia mede Order (wjmp:13-1), entao concluir a melhoria precisa
        # elevar o rank para no minimo 1; a estrela acompanha o molde.
        if state and int(state[0])>0 and rank==0:
            quality=str(int(state[0]))
            star=str(max(int(star),1))
            # O rank NAO vai em fields[8] (la e captain_name, linha 533).
            # Ele so alimenta o bloco 14104, via metadata abaixo.
    from gameplay_mode import tutorial_enabled
    if not tutorial_enabled(db,account):
        from hero_quality_local import quality as normal_quality
        quality=str(normal_quality(db,account,ship,mould))
    import equipment_local
    with db._lock:equipment=equipment_local.equip_info(db,account,ship,mould)
    metadata=[str(ship),'1|0,0,0,0',quality,str(develop['star']),','.join(map(str,develop['skills'])),
              equipment,__import__('potential_local').text(db,account,ship),__import__('mudra_local').alloy_json(db,account,ship,mould)]
    with db._lock:
        state=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
    silver=str(state[0] if state else 0)
    import time
    with db._lock:
        points_row=db._conn.execute('SELECT points FROM local_hero_skill_points WHERE conta_id=?',(account,)).fetchone()
        points=points_row[0] if points_row else 1000000
    import equipment_development_local
    with db._lock:harden=equipment_development_local.snapshot(db,account,ship)
    return ['9',silver]+fields+['14104']+metadata+['12040',str(points)+','+str(int(time.time()*1000))+',0']+harden

def install(server):
    db=server.BANCO
    def draw(seq,text):
        if not tutorial_enabled():
            from normal_recruit import draw as normal_draw
            return normal_draw(server,seq,text)
        try:
            session=db.sessao_de(server._sessao_da_conexao())
            account=session['conta_id'];lines=server._linhas(text)
            if len(lines)!=2 or lines[0]!=str(db.perfil(account)['user_id']) or lines[1]!='1':
                raise ValueError('somente_convocacao_inicial_unica')
            # mission3 group 3, execute type 46 explicitly equips this mould.
            from tutorial_campaign import MISSIONS
            row=next(value[1] for value in MISSIONS.values() if value[0]==3
                     and value[1][0]=='3' and value[1][12].startswith('46'))
            mould=int(row[14])
            with db._lock:
                db._conn.execute('INSERT OR IGNORE INTO tutorial_recruit VALUES (?,?,?)',
                                 (account,account*100000+1,mould))
                db._conn.commit()
            tokens=[str(seq),'new_recruitment_system','0']+init_tokens(db,account)
            tokens+=ship_tokens(db,account,only_mould=mould)+['15006','-1']
            server.log('TUTORIAL_RECRUIT granted/restored conta_id=%s mould=%s' % (account,mould))
            return ' '.join(tokens)
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('new_recruitment_system',seq,str(exc))
    def formation(seq,text):
        """Troca de formacao no formato que o cliente REALMENTE envia.

        Formatos encontrados nos scripts originais:

        Formation.lua:759-763 (tela principal):
            ship_id \r\n posicao \r\n "1"      -> coloca; posicao 0 retira
        FormationChangeMakeWar.lua:435-439:
            ship_id \r\n posicao                -> duas linhas, sem modo
        FormationChange.lua:510-512:
            ship_id \r\n posicao \r\n "2"      -> arrastar entre vagas

        O handler antigo exigia user_id na primeira linha e modo 1/-1, que
        nenhum script envia: toda troca caia em ninja_nao_possuido ou
        modo_invalido, e por isso o "+" nao funcionava.
        """
        try:
            session=db.sessao_de(server._sessao_da_conexao());account=session['conta_id']
            lines=[l.strip() for l in server._linhas(text) if l.strip()!='']
            if not lines:raise ValueError('pedido_vazio')

            # Caminhos antigos prefixam o user_id; aceitamos as duas formas.
            user_id=str(db.perfil(account)['user_id'])
            if len(lines)>=2 and lines[0]==user_id:
                lines=lines[1:]

            ship_id=lines[0]
            entry=next((e for e in all_owned(db,account) if str(e[0])==ship_id),None)
            if not entry:raise ValueError('ninja_nao_possuido')
            position=int(lines[1]) if len(lines)>1 else 0
            mode=lines[2] if len(lines)>2 else '1'
            if mode not in ('1','2','-1'):raise ValueError('modo_invalido')
            if not 0<=position<=6:raise ValueError('posicao_invalida')

            with db._lock:
                slots=_slots_locked(db,account);ship=str(entry[0])
                if position==0 or mode=='-1':
                    anterior=slots.index(ship) if ship in slots else None
                    if anterior is None:raise ValueError('ninja_fora_da_formacao')
                    if mode=='-1' and position not in (0,anterior+1):
                        raise ValueError('ninja_fora_da_posicao')
                    slots[anterior]='0'
                    change=['56','-1',str(anterior+1),ship,'-1']
                else:
                    previous=slots.index(ship) if ship in slots else None
                    displaced=slots[position-1]
                    if previous is not None and previous!=position-1:
                        slots[previous]=displaced
                    slots[position-1]=ship
                    change=['56',ship,str(position),displaced,
                            str(previous+1 if previous is not None else -1)]
                with db._conn:
                    for index,value in enumerate(slots,1):
                        db._conn.execute('INSERT OR REPLACE INTO local_formation_slots VALUES (?,?,?)',(account,index,int(value)))
            server.log('formation_change conta=%s ship=%s pos=%s modo=%s -> %s'
                       % (account,ship,position,mode,slots))
            return ' '.join([str(seq),'formation_change','0']+change+formation_tokens(db,account))
        except (server._contas.ErroConta,ValueError) as exc:
            server.log('formation_change RECUSADO: %s' % exc)
            return server.recusa('formation_change',seq,str(exc))
    server.MINIMOS['new_recruitment_system']=draw
    server.MINIMOS['formation_change']=formation


def recruit_shop_remain():
    # Comma list of remaining buys per new_draw_card_shop row (client splits it).
    from pathlib import Path
    import dados_batalha
    p = Path(dados_batalha.MOULD) / 'new_draw_card_shop.txt'
    try:
        rows = [l.split('	') for l in p.read_text(encoding='utf-8').splitlines() if l.strip()]
        return ','.join(r[3] for r in rows if len(r) > 3)
    except OSError:
        return ''
