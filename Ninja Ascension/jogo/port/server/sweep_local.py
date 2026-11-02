"""Campaign Fast Raid using the original NPC drops and an idempotent receipt."""
import hashlib
import re
import time

import dados_batalha as data
from tutorial_campaign import campaign_scene_allowed, npc_tokens

COMMANDS = ('sweep',)
LEGACY_RETRY_SECONDS = 60


def schema(db):
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_sweep_attempts(
        conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        npc INTEGER NOT NULL,reset_day TEXT NOT NULL,attempts INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY(conta_id,npc))''')
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_sweep_receipts(
        conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        request_id TEXT NOT NULL,signature TEXT NOT NULL,reply TEXT NOT NULL,
        created INTEGER NOT NULL,PRIMARY KEY(conta_id,request_id))''')


def _identity(server, text):
    db = server.BANCO
    fields = server._linhas(text)
    session = db.sessao_de(server._sessao_da_conexao())
    if not fields or fields[0].strip() != str(db.perfil(session['conta_id'])['user_id']):
        raise ValueError('perfil_invalido')
    return int(session['conta_id'])


def login_tokens(db, account):
    """Restore per-NPC daily sweep counts; the main login restores metals."""
    day = __import__('shop_local').day()
    with db._lock:
        rows = db._conn.execute(
            'SELECT npc,attempts FROM local_sweep_attempts WHERE conta_id=? AND reset_day=?',
            (account, day)).fetchall()
    clears = {(int(npc), int(stars)) for _, npc, stars in
              db._conn.execute('SELECT scene,npc,stars FROM local_pve_clears WHERE conta_id=?',
                               (account,)).fetchall()}
    result = []
    for npc, attempts in rows:
        stars = next((s for n, s in clears if n == int(npc)), 0)
        result += ['6023', str(npc), str(stars + 1 if stars else 0),
                   str(stars + 1 if stars else 0), str(attempts), '0']
    return result


def _reward_fields(items):
    totals = {}
    for ident, kind, amount in items:
        key = (int(kind), int(ident))
        totals[key] = totals.get(key, 0) + int(amount)
    props = [(ident, amount) for (kind, ident), amount in sorted(totals.items()) if kind == 6]
    equipment = [(ident, amount) for (kind, ident), amount in sorted(totals.items()) if kind == 7]
    metals = [(ident, amount) for (kind, ident), amount in sorted(totals.items()) if kind == 66]
    silver = sum(amount for (kind, _), amount in totals.items() if kind == 1)
    soul = sum(amount for (kind, _), amount in totals.items() if kind == 4)
    other = {kind for kind, _ in totals if kind not in (1, 4, 6, 7, 66)}
    if other:
        raise ValueError('tipo_de_recompensa_de_varredura_nao_suportado')
    return silver, soul, props, equipment, metals


def _run(seq, text, server):
    db = server.BANCO
    try:
        account = _identity(server, text)
        fields = [value for value in server._linhas(text)[1:] if value.strip()]
        if len(fields) < 5 or len(fields) > 7:
            raise ValueError('pedido_de_varredura_invalido')
        npc_id, difficulty, requested, sweep_type, scene_id = map(int, fields[:5])
        extra = fields[5] if len(fields) >= 6 else ''
        nonce = fields[6] if len(fields) >= 7 else ''
        if extra and not nonce and ',' not in extra:
            nonce, extra = extra, ''
        if extra:
            raise ValueError('varredura_automatica_nao_suportada')
        if not 1 <= requested <= 50 or difficulty != 1 or sweep_type != 0:
            raise ValueError('parametros_de_varredura_invalidos')
        if nonce and not re.fullmatch(r'[A-Za-z0-9_-]{8,80}', nonce):
            raise ValueError('identificador_de_varredura_invalido')

        scene = data.tabela('pve_scene.txt').get(str(scene_id))
        npc = data.tabela('npc.txt').get(str(npc_id))
        if not scene or not npc or not campaign_scene_allowed(scene_id, scene):
            raise ValueError('fase_fora_do_conteudo_disponivel')
        if int(scene[5]) not in (0, 1, 15):
            raise ValueError('tipo_de_cena_nao_suportado')
        if str(npc_id) not in {part for part in re.split(r'[:,]', scene[12]) if part.isdigit()}:
            raise ValueError('npc_fora_da_cena')
        if int(npc[107]) != scene_id:
            raise ValueError('npc_fora_da_cena')
        if not int(npc[118] or 0):
            raise ValueError('custo_de_varredura_indisponivel')

        day = __import__('shop_local').day()
        signature = '|'.join(map(str, (npc_id, difficulty, requested, sweep_type,
                                        scene_id, extra)))
        legacy_key = '%s|%s|%s' % (account, server._sessao_da_conexao(), seq)
        request_id = nonce or ('legacy-' + hashlib.sha256(legacy_key.encode()).hexdigest())
        now = int(time.time())
        with db._lock, db._conn:
            db._conn.execute(
                'DELETE FROM local_sweep_receipts WHERE conta_id=? AND created<?',
                (account, now - 30 * 24 * 60 * 60))
            receipt = db._conn.execute(
                'SELECT signature,reply,created FROM local_sweep_receipts WHERE conta_id=? AND request_id=?',
                (account, request_id)).fetchone()
            if receipt and (nonce or now - int(receipt[2]) <= LEGACY_RETRY_SECONDS):
                if receipt[0] != signature:
                    raise ValueError('identificador_de_varredura_reutilizado')
                return str(seq) + ' ' + receipt[1]
            if receipt:
                db._conn.execute('DELETE FROM local_sweep_receipts WHERE conta_id=? AND request_id=?',
                                 (account, request_id))

            clear = db._conn.execute(
                'SELECT stars FROM local_pve_clears WHERE conta_id=? AND scene=? AND npc=?',
                (account, scene_id, npc_id)).fetchone()
            if not clear or int(clear[0]) < 3:
                raise ValueError('fase_precisa_de_tres_estrelas')

            import shop_local
            import scene_rewards_local
            import player_level_local
            import mudra_local
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)',
                             (account,))
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id,food) VALUES (?,60)',
                             (account,))
            mudra_local.schema(db)
            wallet = db._conn.execute('SELECT food,gold FROM local_resources WHERE conta_id=?',
                                      (account,)).fetchone()
            food_before, gold_before = map(int, wallet)
            cost = int(npc[118])
            requested = min(requested, max(0, food_before // cost))
            if int(scene[5]) == 1:
                db._conn.execute(
                    'INSERT OR IGNORE INTO local_sweep_attempts VALUES (?,?,?,0)',
                    (account, npc_id, day))
                attempt = db._conn.execute(
                    'SELECT attempts FROM local_sweep_attempts WHERE conta_id=? AND npc=? AND reset_day=?',
                    (account, npc_id, day)).fetchone()
                daily_limit = int(npc[117] or 0)
                requested = min(requested, max(0, daily_limit - int(attempt[0])))
            if requested <= 0:
                raise ValueError('sem_tentativas_ou_energia_para_varrer')

            db._conn.execute('UPDATE local_resources SET food=food-? WHERE conta_id=?',
                             (cost * requested, account))
            reward_rows = []
            all_metals = []
            for _ in range(requested):
                drops = scene_rewards_local._npc_reward_entries(int(npc[114]))
                silver, soul, props, equipment, metals = _reward_fields(drops)
                metal_cursor = int(db._conn.execute(
                    'SELECT COALESCE(MAX(id),0) FROM local_metals WHERE conta_id=?',
                    (account,)).fetchone()[0])
                scene_rewards_local._apply_npc_reward(db, account, drops)
                level = player_level_local.ganhar(db, account, cost)
                reward_rows.append((cost, silver, soul, props, equipment, metals, level[:3]))
                new_metal_ids = db._conn.execute(
                    'SELECT id FROM local_metals WHERE conta_id=? AND id>? ORDER BY id',
                    (account, metal_cursor)).fetchall()
                for (rowid,) in new_metal_ids:
                    all_metals.append(mudra_local.metal(
                        db, account, mudra_local.wire_id(rowid)))

            if int(scene[5]) == 1:
                db._conn.execute('UPDATE local_sweep_attempts SET attempts=attempts+? '
                                 'WHERE conta_id=? AND npc=? AND reset_day=?',
                                 (requested, account, npc_id, day))

            final_food = int(db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?',
                                              (account,)).fetchone()[0])
            final_gold = int(db._conn.execute(
                'SELECT gold FROM local_resources WHERE conta_id=?',
                (account,)).fetchone()[0])
            grade, exp, need = player_level_local.estado(db, account)
            silver_total = int(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',
                                                (account,)).fetchone()[0])
            tokens = [str(seq), 'sweep', '0', '52', str(len(reward_rows))]
            for exp_gain, row_silver, row_soul, props, equipment, metals, level in reward_rows:
                tokens += [str(exp_gain), str(row_silver), str(row_soul), str(len(props))]
                for ident, amount in props:
                    tokens += [str(ident), str(amount)]
                tokens += [str(len(equipment))]
                for ident, amount in equipment:
                    tokens += [str(ident), str(amount)]
                tokens += ['0', str(len(metals))]
                for ident, amount in metals:
                    tokens += [str(ident), str(amount)]
                tokens += list(map(str, level))
            tokens += [str(now), str(now)]

            tokens += ['22', str(silver_total)]
            tokens += ['25', str(final_gold - gold_before), str(final_gold)]
            tokens += ['29', str(final_food - food_before), str(final_food)]
            tokens += ['40', str(grade), str(need), '41', str(exp)]
            tokens += scene_rewards_local.scene_tokens(db, account)
            tokens += npc_tokens(db, account)
            tokens += scene_rewards_local.inventory_tokens(db, account)
            tokens += mudra_local.change_tokens(db, account, all_metals)
            tokens += ['12047', str(mudra_local.essence(db, account))]
            tokens += ['6023', str(npc_id), str(int(clear[0]) + 1),
                       str(int(clear[0]) + 1), str(requested), '0']
            reply = ' '.join(tokens)
            db._conn.execute('INSERT INTO local_sweep_receipts VALUES (?,?,?,?,?)',
                             (account, request_id, signature,
                              ' '.join(tokens[1:]), now))
        server.log('SWEEP cena=%s npc=%s vezes=%s comida=%s conta=%s' %
                   (scene_id, npc_id, requested, cost * requested, account))
        return reply
    except (server._contas.ErroConta, ValueError, IndexError, TypeError, KeyError) as exc:
        return server.recusa('sweep', seq, str(exc) or 'varredura_indisponivel')


def install(server):
    db = server.BANCO
    with db._lock, db._conn:
        schema(db)
    server.MINIMOS['sweep'] = lambda seq, text: _run(seq, text, server)

    if not hasattr(server, '_sweep_original_login'):
        server._sweep_original_login = server.MINIMOS['login_init']
        server._sweep_original_login_again = server.MINIMOS['login_init_again']
    for command, attribute in (('login_init', '_sweep_original_login'),
                               ('login_init_again', '_sweep_original_login_again')):
        original = getattr(server, attribute)
        def wrapped(seq, text, original=original):
            response = original(seq, text)
            if len(response.split(' ')) < 3 or response.split(' ')[2] != '0':
                return response
            try:
                account = db.sessao_de(server._sessao_da_conexao())['conta_id']
                extra = login_tokens(db, account)
                return response + (' ' + ' '.join(extra) if extra else '')
            except (server._contas.ErroConta, ValueError, KeyError, IndexError):
                return response
        server.MINIMOS[command] = wrapped

    # Fast Raid invokes the existing File Island refresh callback after showing
    # rewards; register its read-only task-info response in the same reloadable
    # rule module so a live server can pick it up without a process restart.
    import file_island_local
    file_island_local.install(server)
