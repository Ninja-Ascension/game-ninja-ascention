"""Local campaign persistence and original S2C contracts (no invented missions)."""
import re
import time
from datetime import datetime, timedelta
import dados_batalha as data
from gameplay_mode import tutorial_enabled


# Original pve_scene IDs and their daily-attempt parser slots. The source
# play_config gives two attempts for Ryo (2), EXP (7), and Skill (16).
GREAT_SHINOBI_DAILY = {
    151: (347, 2, 217),  # Ryo Challenge
    152: (348, 2, 218),  # EXP Challenge
    154: (350, 2, 12405),  # Skill Challenge (scene type 52)
}
GREAT_SHINOBI_COOLDOWN_SECONDS = 10 * 60


def _daily_reset_day():
    # play_config's original UI says the daily reset occurs at 05:00 local.
    return (datetime.now().astimezone() - timedelta(hours=5)).date().isoformat()


def remaining_great_shinobi(db, account, activity_id):
    info = next((value for value in GREAT_SHINOBI_DAILY.values()
                 if value[0] == int(activity_id)), None)
    if info is None:
        raise ValueError('desafio_diario_invalido')
    return _great_shinobi_state(db, account, int(activity_id), info[1])[0]


def _great_shinobi_state(db, account, activity_id, daily_limit):
    day = _daily_reset_day()
    with db._lock:
        row = db._conn.execute(
            'SELECT reset_day,remaining,cooldown_until FROM local_great_shinobi_attempts '
            'WHERE conta_id=? AND activity_id=?', (account, activity_id)).fetchone()
    if not row or row[0] != day:
        return daily_limit, 0
    remaining = int(row[1])
    cooldown = max(0, int(row[2]) - int(time.time())) if remaining > 0 else 0
    return remaining, cooldown


def cooldown_great_shinobi(db, account, activity_id):
    info = next((value for value in GREAT_SHINOBI_DAILY.values()
                 if value[0] == int(activity_id)), None)
    if info is None:
        raise ValueError('desafio_diario_invalido')
    return _great_shinobi_state(db, account, int(activity_id), info[1])[1]


def _consume_great_shinobi(db, account, scene):
    info = GREAT_SHINOBI_DAILY.get(int(scene))
    if not info:
        return None
    activity_id, daily_limit, parser = info
    day = _daily_reset_day()
    remaining, _ = _great_shinobi_state(db, account, activity_id, daily_limit)
    if remaining <= 0:
        raise ValueError('tentativas_diarias_esgotadas')
    remaining -= 1
    cooldown_until = int(time.time()) + GREAT_SHINOBI_COOLDOWN_SECONDS
    db._conn.execute(
        'INSERT INTO local_great_shinobi_attempts '
        '(conta_id,activity_id,reset_day,remaining,cooldown_until) VALUES (?,?,?,?,?) '
        'ON CONFLICT(conta_id,activity_id) DO UPDATE SET '
        'reset_day=excluded.reset_day,remaining=excluded.remaining,'
        'cooldown_until=excluded.cooldown_until',
        (account, activity_id, day, remaining, cooldown_until))
    return parser, remaining


def _attempt_parser_tokens(db, account, scene, include_cooldown=True):
    info = GREAT_SHINOBI_DAILY.get(int(scene))
    if not info:
        return []
    activity_id, daily_limit, parser = info
    remaining = remaining_great_shinobi(db, account, activity_id)
    tokens = []
    if parser == 12405:
        # parse_user_scene_info_battle_state reads "scene_type,remaining".
        tokens += ['12405', '52,%d' % remaining]
    else:
        tokens += [str(parser), str(remaining)]
    # ActivityCopyWindow already renders its countdown from parser 470. Its
    # four comma-separated entries correspond to Ryo, EXP, Illusion and Skill.
    # The client expects absolute Unix milliseconds, just like the original.
    if include_cooldown:
        tokens += _cooldown_parser_tokens(db, account)
    return tokens


def _cooldown_parser_tokens(db, account):
    pages = {347: 0, 348: 1, 349: 2, 350: 3}
    values = ['0'] * 4
    day = _daily_reset_day()
    with db._lock:
        rows = db._conn.execute(
            'SELECT activity_id,reset_day,remaining,cooldown_until '
            'FROM local_great_shinobi_attempts WHERE conta_id=?', (account,)
        ).fetchall()
    for activity_id, reset_day, remaining, cooldown_until in rows:
        page = pages.get(int(activity_id))
        if page is None or reset_day != day or int(remaining) <= 0:
            continue
        if int(cooldown_until) > int(time.time()):
            values[page] = str(int(cooldown_until) * 1000)
    return ['470', ','.join(values)]


def login_attempt_tokens(db, account):
    """Restore daily counters from the saved server state after a login."""
    tokens = []
    for scene in (151, 152, 154):
        tokens += _attempt_parser_tokens(db, account, scene, include_cooldown=False)
    # Always initialize the client cooldown array, including accounts that
    # have not attempted any Great Shinobi challenge today.
    tokens += _cooldown_parser_tokens(db, account)
    return tokens


def mission_index():
    result = {}
    # tabela() indexes by first column; missions repeat that column, so read
    # every physical row instead of discarding all but each group's last event.
    from pathlib import Path
    for number in (1, 2, 3):
        path = Path(data.MOULD) / ('mission%d.txt' % number)
        for order,line in enumerate(path.read_text(encoding='utf8', errors='replace').splitlines()):
            row = line.split('\t')
            if len(row) >= 15 and row[9].lstrip('-').isdigit() and int(row[9]) > 0:
                result[int(row[9])] = (number, row, order)
    return result


MISSIONS = mission_index()

def resume_record(db,account):
    """Local checkpoint inside the original login record field, no new parser."""
    if not tutorial_enabled():return ''
    with db._lock:
        rows=db._conn.execute('SELECT progress FROM tutorial_events WHERE conta_id=? AND mould LIKE ?',
                             (account,'3:%')).fetchall()
    candidates=[MISSIONS[row[0]] for row in rows if row[0] in MISSIONS and MISSIONS[row[0]][0]==3]
    if not candidates:return ''
    _,row,_=max(candidates,key=lambda item:item[2])
    return 'nr_local_resume&%s,%s,%s' % (db.perfil(account)['user_id'],row[0],row[9])


def campaign(db, account):
    with db._lock:
        row = db._conn.execute('SELECT grade,silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
        clears = db._conn.execute('SELECT scene,npc,stars FROM local_pve_clears WHERE conta_id=?', (account,)).fetchall()
    return (int(row[0]), int(row[1]), list(clears)) if row else (1, 0, list(clears))


def scene_tokens(db, account):
    grade, _, clears = campaign(db, account)
    scenes = data.tabela('pve_scene.txt')
    ids = sorted(int(key) for key in scenes if key.isdigit())
    completed = {(int(row[0]), int(row[1])): int(row[2]) for row in clears}
    with db._lock:
        claims=db._conn.execute('SELECT scene,chest FROM local_scene_rewards WHERE conta_id=?',(account,)).fetchall()
    masks={}
    for scene,chest in claims:masks[scene]=masks.get(scene,0)|(1<<chest)
    def npc_groups(row):
        # Some original scenes store difficulty alternatives in one slot,
        # e.g. Illusion Challenge: easy:normal:hard NPC ids separated by ':'.
        return [[int(npc) for npc in group.split(':') if npc.isdigit()]
                for group in row[12].split(',') if group]
    states, stars = [], []
    for scene in ids:
        row = scenes[str(scene)]
        groups = npc_groups(row)
        count = 0
        for group in groups:
            if not any((scene, npc) in completed for npc in group):
                break
            count += 1
        # LocalDatas.lua: open_level=5, open_scene=16 (successors),
        # by_open_scene=17 (prerequisites). Reading column 16 creates a
        # forward dependency cycle and keeps the next chapter locked forever.
        previous = [int(x) for x in row[16].split(',') if x.isdigit() and int(x)>0]
        def cleared(prior):
            definition=scenes.get(str(prior))
            if not definition:return False
            required=npc_groups(definition)
            return bool(required) and all(
                any((prior,npc) in completed for npc in group)
                for group in required if group)
        unlocked = grade>=int(row[4]) and all(cleared(prior) for prior in previous)
        # Do not hide already persisted victories from an older local version.
        unlocked = unlocked or count>0
        states.append(str(count if unlocked else -1))
        stars.append(str(sum(value for (s,_),value in completed.items() if s==scene)))
    return ['6020', ','.join(states), ','.join(states), ','.join(stars), ','.join(str(masks.get(scene,0)) for scene in ids)]


def npc_tokens(db, account):
    npcs=data.tabela('npc.txt')
    max_id=max(int(key) for key in npcs if key.isdigit())
    states=['0']*max_id
    for _,npc,_ in campaign(db,account)[2]:
        row=npcs.get(str(npc))
        if row:
            states[int(npc)-1]=str(int(row[7])+1)
    vector=','.join(states)
    zeros=','.join('0' for _ in states)
    return ['6022',vector,vector,zeros,zeros,'0','0']


def install(server):
    db = server.BANCO
    with db._lock, db._conn:
        # Last battle whose result was already applied: a repeated
        # battle_result_verify gets the same answer without new rewards/EXP.
        db._conn.execute('CREATE TABLE IF NOT EXISTS local_battle_done (conta_id INTEGER PRIMARY KEY, scene INTEGER, npc INTEGER, difficulty INTEGER)')

    def identity(text, command):
        lines = server._linhas(text)
        session = db.sessao_de(server._sessao_da_conexao())
        if not lines or lines[0].strip() != str(db.perfil(session['conta_id'])['user_id']):
            raise ValueError('perfil_invalido')
        return session['conta_id'], lines

    def education(seq, text):
        if not tutorial_enabled():
            try:
                identity(text,'education_change')
                return '%s education_change 0' % seq
            except (server._contas.ErroConta,ValueError) as exc:
                return server.recusa('education_change',seq,str(exc))
        try:
            account, lines = identity(text,'education_change')
            if len(lines)!=2 or not re.fullmatch(r'\d+',lines[1].strip()):
                raise ValueError('etapa_invalida')
            progress = int(lines[1])
            if progress not in MISSIONS:
                raise ValueError('etapa_ausente_no_acervo')
            definition=MISSIONS[progress]
            mould = '%s:%s' % (definition[0],definition[1][0])
            with db._lock:
                previous=db._conn.execute('SELECT progress FROM tutorial_events WHERE conta_id=? AND mould=?',(account,mould)).fetchone()
                if previous is None or MISSIONS.get(previous[0],(0,[], -1))[2]<=definition[2]:
                    db._conn.execute('INSERT OR REPLACE INTO tutorial_events VALUES (?,?,?)', (account,mould,progress))
                db._conn.commit()
            server.log('tutorial etapa=%s conta_id=%s salva' % (progress,account))
            return '%s education_change 0' % seq
        except (server._contas.ErroConta, ValueError) as exc:
            return server.recusa('education_change',seq,str(exc))

    # Keep a stable reference to the base dispatcher when control.py reloads
    # this module; wrapping the previous wrapper would stack state checks.
    original_start = getattr(server, '_tutorial_campaign_original_start', None)
    if original_start is None:
        original_start = server.MINIMOS['battle_result_start']
        server._tutorial_campaign_original_start = original_start
    def start(seq,text):
        try:
            account, lines=identity(text,'battle_result_start')
            if len(lines)<5: raise ValueError('batalha_invalida')
            scene,npc,difficulty=int(lines[2]),int(lines[3]),int(lines[4])
            counter=GREAT_SHINOBI_DAILY.get(scene)
            if counter:
                if remaining_great_shinobi(db,account,counter[0]) <= 0:
                    raise ValueError('tentativas_diarias_esgotadas')
                wait=cooldown_great_shinobi(db,account,counter[0])
                if wait > 0:
                    raise ValueError('desafio_em_recarga_%ds' % wait)
            response=original_start(seq,text)
            if response.split(' ')[2]=='0':
                with db._lock:
                    db._conn.execute('INSERT OR REPLACE INTO local_battle_pending VALUES (?,?,?,?)',(account,scene,npc,difficulty))
                    db._conn.commit()
            return response
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('battle_result_start',seq,str(exc))

    def verify(seq,text):
        try:
            account,lines=identity(text,'battle_result_verify')
            if len(lines)<7: raise ValueError('resultado_incompleto')
            scene=int(lines[2]); npc=int(lines[3].split('-')[-1]); stars=int(lines[4]); difficulty=int(lines[5])
            if not 0<=stars<=3 or not 1<=difficulty<=3 or lines[6].strip()!='1': raise ValueError('resultado_invalido')
            with db._lock:
                pending=db._conn.execute('SELECT scene,npc,difficulty FROM local_battle_pending WHERE conta_id=?',(account,)).fetchone()
            repetido=False
            if not pending or tuple(pending)!=(scene,npc,difficulty):
                with db._lock:
                    feito=db._conn.execute('SELECT scene,npc,difficulty FROM local_battle_done WHERE conta_id=?',(account,)).fetchone()
                if not feito or tuple(feito)!=(scene,npc,difficulty): raise ValueError('batalha_nao_iniciada')
                repetido=True
            npc_row=data.tabela('npc.txt').get(str(npc))
            if not npc_row or str(scene)!=npc_row[107]: raise ValueError('npc_fora_da_cena')
            grade,silver,_=campaign(db,account)
            changed=False
            nivel=None
            if stars>0 and not repetido:
                reward=npc_row[110].split('|')[difficulty-1].split(',')
                with db._lock:
                    exists=db._conn.execute('SELECT stars FROM local_pve_clears WHERE conta_id=? AND scene=? AND npc=?',(account,scene,npc)).fetchone()
                    if exists is None:
                        # Guided (tutorial) mode only: one level per first clear,
                        # preserving each level-triggered lesson. Normal play uses
                        # the original EXP rule below (player_level_local).
                        if tutorial_enabled():
                            grade=min(grade+1,max(int(k) for k in data.tabela('user_experience_param.txt') if k.isdigit()))
                        silver+=int(reward[0]);changed=True
                        db._conn.execute('INSERT INTO local_pve_clears VALUES (?,?,?,?)',(account,scene,npc,stars))
                        db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,?,?)',(account,grade,silver))
                        db._conn.execute('INSERT INTO tutorial_progress VALUES (?,0) ON CONFLICT(conta_id) DO UPDATE SET experiencia=0',(account,))
                    elif stars>exists[0]:
                        db._conn.execute('UPDATE local_pve_clears SET stars=? WHERE conta_id=? AND scene=? AND npc=?',(stars,account,scene,npc))
                    if not tutorial_enabled():
                        # Original rule: every victory grants player EXP equal
                        # to the battle's energy cost (npc.attack_need_food).
                        import player_level_local
                        nivel=player_level_local.ganhar(db,account,int(npc_row[118] or 0))
                    db._conn.execute('DELETE FROM local_battle_pending WHERE conta_id=?',(account,))
                    db._conn.execute('INSERT OR REPLACE INTO local_battle_done VALUES (?,?,?,?)',(account,scene,npc,difficulty))
                    if scene in GREAT_SHINOBI_DAILY:
                        _consume_great_shinobi(db,account,scene)
                    db._conn.commit()
            tokens=[str(seq),'battle_result_verify','0']
            import hero_training_local
            hero_training_local.prepare(db,account)
            _,silver,_=campaign(db,account)
            tokens+=['22',str(silver)]
            if nivel:
                novo_grade,exp,need,subiu,energia=nivel
                if subiu:tokens+=['40',str(novo_grade),str(need)]
                tokens+=['41',str(exp)]
                if energia:
                    with db._lock:
                        comida=db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
                    tokens+=['29',str(energia),str(comida)]
            elif changed:
                levels=data.tabela('user_experience_param.txt')
                need=levels.get(str(grade+1),levels[str(grade)])[2]
                tokens+=['40',str(grade),need,'41','0']
            tokens+=scene_tokens(db,account)+npc_tokens(db,account)
            tokens+=hero_training_local.inventory_tokens(db,account)
            tokens+=_attempt_parser_tokens(db,account,scene)
            server.log('PVE resultado salvo cena=%s npc=%s estrelas=%s nivel=%s primeira_vitoria=%s' % (scene,npc,stars,grade,changed))
            return ' '.join(tokens)
        except (server._contas.ErroConta,ValueError,IndexError) as exc:
            return server.recusa('battle_result_verify',seq,str(exc))

    original_fail = getattr(server, '_tutorial_campaign_original_fail', None)
    if original_fail is None:
        original_fail = server.MINIMOS['battle_result_fail']
        server._tutorial_campaign_original_fail = original_fail
    def fail(seq,text):
        try:
            account,lines=identity(text,'battle_result_fail')
            scene=int(lines[1]) if len(lines)>1 and lines[1].isdigit() else 0
            npc=int(lines[2]) if len(lines)>2 and lines[2].isdigit() else 0
            with db._lock:
                pending=db._conn.execute(
                    'SELECT scene,npc FROM local_battle_pending WHERE conta_id=?',
                    (account,)).fetchone()
            response=original_fail(seq,text)
            if (scene in GREAT_SHINOBI_DAILY and pending
                    and tuple(pending)==(scene,npc)
                    and response.split(' ')[2]=='0'):
                with db._lock,db._conn:
                    _consume_great_shinobi(db,account,scene)
                response += ' ' + ' '.join(_attempt_parser_tokens(db,account,scene))
            return response
        except (server._contas.ErroConta,ValueError,IndexError) as exc:
            return server.recusa('battle_result_fail',seq,str(exc))

    def clear_info(seq,text):
        try:
            identity(text,'get_copy_clear_user_info')
            # No online ranking exists locally. Original parser 12406 with
            # NPC zero initializes its table and represents no recorded player.
            return '%s get_copy_clear_user_info 0 12406 0' % seq
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('get_copy_clear_user_info',seq,str(exc))

    server.MINIMOS.update(education_change=education,battle_result_start=start,
                         battle_result_verify=verify,battle_result_fail=fail,
                         get_copy_clear_user_info=clear_info)
