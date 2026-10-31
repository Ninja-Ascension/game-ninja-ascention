"""Ninja School > Tailed Beasts (magical animals / 神兽), following the client.

Client: client/l_digital/cultivate/mythicalAnimals/*.lua (MythicalAnimalsHandle).
Parsers: 12675 all beasts [{maMouldId, star, stepsInfo "stage,s1,s2,s3",
relevantActiveStatus "0,1,2,.."}], 12676 one beast, 12677 skill
{equippedMAMould "id,id", skillReleaseMethod}, 12678 fate {step, progress},
12679 fate tasks.

Tables (0-based): magical_animals_mould 5 star group, 6 forge group;
magical_animals_star_mould 1 group, 2 star, 3 next id, 4 stats of that star
(for every ninja), 5 fragments to reach it; magical_animals_forging_mould
1 group, 2 stage, 3 next id, 4 stones for the next stage;
magical_animals_relevant_mould 1 beasts, 2 star needed, 3 stats.
play_config 211 forge stones, 212 stats per stone, 214 forge reset cost.
Stats with types 96-104 belong to the beast itself (AnimalPropertyTypeMap)
and are not added to the ninjas.
Destiny nodes consume their table costs in order and persist account-wide.
Not implemented yet: fate task rewards - refused instead of faked.
"""
import json
import dados_batalha as data

COMMANDS = ('magical_animals_activate', 'magical_animals_advance_star', 'magical_animals_forging',
            'magical_animals_steps_rebirth', 'magical_animals_relevant_active', 'magical_animals_set_skill',
            'magical_animals_set_skill_release_method', 'magical_animals_activate_fate',
            'magical_animals_activate_get_fate_task_reward')
BEAST_ONLY = {96, 97, 98, 99, 102, 103, 104}


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_beasts (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, beast INTEGER NOT NULL, star INTEGER NOT NULL DEFAULT 1, stage INTEGER NOT NULL DEFAULT 0, stones TEXT NOT NULL DEFAULT "0,0,0", forged TEXT NOT NULL DEFAULT "0,0,0", links TEXT NOT NULL DEFAULT "", PRIMARY KEY(conta_id, beast))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_beast_skill (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, equipped TEXT NOT NULL DEFAULT "", method INTEGER NOT NULL DEFAULT 0)')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_beast_receipts (conta_id INTEGER, request_id TEXT, signature TEXT, reply TEXT, PRIMARY KEY(conta_id, request_id))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_beast_fate (conta_id INTEGER PRIMARY KEY REFERENCES contas(id), activated INTEGER NOT NULL DEFAULT 0)')


def fate_rows():
    return sorted(data.tabela('magical_animals_fate_mould.txt').values(), key=lambda r: (int(r[1]), int(r[3])))


def fate_count(db, account):
    if not db._conn.execute("SELECT 1 FROM sqlite_master WHERE name='local_beast_fate'").fetchone():
        return 0
    row = db._conn.execute('SELECT activated FROM local_beast_fate WHERE conta_id=?', (account,)).fetchone()
    return int(row[0]) if row else 0


def fate_info(db, account):
    reached = fate_rows()[:fate_count(db, account)]
    if not reached:
        return {'step': 0, 'progress': '0,0,0,0,0'}
    row = reached[-1]; stage, progress = int(row[1]), int(row[3])
    if progress == 5:
        return {'step': stage, 'progress': '0,0,0,0,0'}
    return {'step': stage - 1, 'progress': ','.join('1' if i < progress else '0' for i in range(5))}


def activate_fate(db, account):
    # The original button is a one-key activation with no target parameter.
    if not beasts(db, account):
        raise ValueError('besta_nao_ativada')
    reached = fate_count(db, account); rows = fate_rows(); before = reached
    for row in rows[reached:]:
        costs = triples(row[7])
        if any(kind != 6 or amount <= 0 for kind, _, amount in costs):
            raise ValueError('custo_de_destino_invalido')
        if any(item_count(db, account, prop) < amount for _, prop, amount in costs):
            break
        for _, prop, amount in costs:
            take(db, account, prop, amount)
        reached += 1
    if reached == before:
        raise ValueError('destino_no_maximo' if reached == len(rows) else 'gemas_do_destino_insuficientes')
    db._conn.execute('INSERT INTO local_beast_fate VALUES (?,?) ON CONFLICT(conta_id) DO UPDATE SET activated=excluded.activated', (account, reached))


_CFG = {}


def cfg(n):
    if not _CFG:
        from pathlib import Path
        for line in (Path(data.MOULD).parent / 'configs' / 'play_config.txt').read_text(encoding='utf-8').splitlines():
            row = line.split('\t')
            if len(row) > 3:
                _CFG[row[0]] = row[3]
    return _CFG[str(n)]


def beast_row(b):
    return data.tabela('magical_animals_mould.txt')[str(b)]


def star_row(b, star):
    g = beast_row(b)[5]
    return next((r for r in data.tabela('magical_animals_star_mould.txt').values() if r[1] == g and int(r[2]) == star), None)


def stage_row(b, stage):
    g = beast_row(b)[6]
    return next((r for r in data.tabela('magical_animals_forging_mould.txt').values() if r[1] == g and int(r[2]) == stage), None)


def links_of(b):
    return [r for r in sorted(data.tabela('magical_animals_relevant_mould.txt').values(), key=lambda r: int(r[0]))
            if str(b) in r[1].split(',')]


def pairs(text):
    return [] if not text or text == '-1' else [(int(k), float(v)) for k, v in (p.split(',') for p in text.split('|') if p)]


def triples(text):
    return [] if not text or text == '-1' else [tuple(int(x) for x in p.split(',')) for p in text.split('|') if p]


def beasts(db, account):
    rows = db._conn.execute('SELECT beast, star, stage, stones, forged, links FROM local_beasts WHERE conta_id=?', (account,)).fetchall()
    return {r[0]: dict(star=r[1], stage=r[2], stones=[int(x) for x in r[3].split(',')],
                       forged=[int(x) for x in r[4].split(',')], links=r[5]) for r in rows}


def save(db, account, b, s):
    db._conn.execute('INSERT OR REPLACE INTO local_beasts VALUES (?,?,?,?,?,?,?)',
                     (account, b, s['star'], s['stage'], ','.join(map(str, s['stones'])), ','.join(map(str, s['forged'])), s['links']))


def link_status(db, account, b):
    have = beasts(db, account)
    done = set((have.get(b) or {}).get('links', '').split(',')) - {''}
    out = []
    for r in links_of(b):
        if r[0] in done:
            out.append('2')
        else:
            ok = all(int(x) in have and have[int(x)]['star'] >= int(r[2]) for x in r[1].split(','))
            out.append('1' if ok else '0')
    return ','.join(out)


def info(db, account, b, s):
    return {'maMouldId': b, 'star': s['star'], 'stepsInfo': '%d,%s' % (s['stage'], ','.join(map(str, s['stones']))),
            'relevantActiveStatus': link_status(db, account, b)}


def skill(db, account):
    r = db._conn.execute('SELECT equipped, method FROM local_beast_skill WHERE conta_id=?', (account,)).fetchone()
    # Always the 3 skill slots, -1 = empty (MythicalAnimalsSkill.lua builds the
    # new list from slots 1..3 and sends nothing when the list is empty).
    slots = [x for x in (r[0] if r else '').split(',') if x.strip()]
    slots = (slots + ['-1'] * 3)[:3]
    return {'equippedMAMould': ','.join(slots), 'skillReleaseMethod': r[1] if r else 0}


def j(v):
    return json.dumps(v, separators=(',', ':'))


def init_tokens(db, account):
    have = beasts(db, account)
    return ['12675', j([info(db, account, b, s) for b, s in sorted(have.items())]),
            '12677', j(skill(db, account)), '12678', j(fate_info(db, account)), '12679', j({})]


def bonus(db, account):
    out = []
    with db._lock:
        have = beasts(db, account)
        per_stone = [v for _, v in pairs(cfg(212))]
        kinds = [k for k, _ in pairs(cfg(212))]
        for b, s in have.items():
            # Original MythicalAnimalsHandle.getAnimalsUpStarPropertyById:
            # each reached star adds its own row, rather than replacing
            # the accumulated bonuses with the latest star's increment.
            for reached_star in range(1, s['star'] + 1):
                sr = star_row(b, reached_star)
                if sr is None:
                    raise ValueError('tabela_de_estrelas_da_besta_incompleta')
                out += pairs(sr[4])
            for i in range(3):
                n = s['forged'][i] + s['stones'][i]
                if n:
                    out.append((kinds[i], per_stone[i] * n))
            done = set(s['links'].split(',')) - {''}
            for r in links_of(b):
                if r[0] in done:
                    out += pairs(r[3])
        for row in fate_rows()[:fate_count(db, account)]:
            if row[5] == '0':
                out += pairs(row[6])
    return [(k, v) for k, v in out if k not in BEAST_ONLY]


def item_count(db, account, prop):
    r = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, prop)).fetchone()
    return r[0] if r else 0


def take(db, account, prop, n):
    if item_count(db, account, prop) < n:
        raise ValueError('itens_insuficientes')
    db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (n, account, prop))


def give_item(db, account, prop, n):
    db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                     (account, prop, account * 1000000 + prop, n))


def activate(db, account, b):
    if b in beasts(db, account):
        raise ValueError('besta_ja_ativada')
    nxt = star_row(b, 1)
    for _, prop, n in triples(nxt[5]):
        take(db, account, prop, n)
    s = dict(star=1, stage=0, stones=[0, 0, 0], forged=[0, 0, 0], links='')
    save(db, account, b, s)
    return b


def advance(db, account, b):
    s = beasts(db, account).get(b)
    if not s:
        raise ValueError('besta_nao_ativada')
    nxt = star_row(b, s['star'] + 1)
    if not nxt:
        raise ValueError('besta_no_maximo')
    for _, prop, n in triples(nxt[5]):
        take(db, account, prop, n)
    s['star'] += 1
    save(db, account, b, s)
    return b


def forging(db, account, b, idx, kind):
    s = beasts(db, account).get(b)
    if not s:
        raise ValueError('besta_nao_ativada')
    if idx not in (0, 1, 2) or kind not in (0, 1, 2, 3):
        raise ValueError('forja_invalida')
    nxt = stage_row(b, s['stage'] + 1)
    if not nxt:
        raise ValueError('forja_no_maximo')
    need = [n for _, _, n in triples(nxt[4])]
    stones = [p for _, p, _ in triples(cfg(211))]
    missing = need[idx] - s['stones'][idx]
    if missing <= 0:
        raise ValueError('pedra_completa_neste_estagio')
    have = item_count(db, account, stones[idx])
    n = 1 if kind in (0, 1) else min(have, missing)
    if n <= 0 or have < n:
        raise ValueError('pedras_insuficientes')
    take(db, account, stones[idx], n)
    s['stones'][idx] += n
    if all(s['stones'][i] >= need[i] for i in range(3)):
        s['forged'] = [s['forged'][i] + s['stones'][i] for i in range(3)]
        s['stones'] = [0, 0, 0]
        s['stage'] += 1
    save(db, account, b, s)
    return b


def rebirth(db, account, b):
    s = beasts(db, account).get(b)
    if not s or (s['stage'] == 0 and not any(s['stones'])):
        raise ValueError('nada_para_redefinir')
    kind, _, cost = (int(x) for x in cfg(214).split(','))
    if kind != 2:
        raise ValueError('custo_nao_suportado')
    gold = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
    if not gold or gold[0] < cost:
        raise ValueError('gold_insuficiente')
    db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?', (cost, account))
    stones = [p for _, p, _ in triples(cfg(211))]
    rewards = []
    for i in range(3):
        n = s['forged'][i] + s['stones'][i]
        if n:
            give_item(db, account, stones[i], n)
            rewards.append((stones[i], 6, n))
    s.update(stage=0, stones=[0, 0, 0], forged=[0, 0, 0])
    save(db, account, b, s)
    return b, ['25', str(-cost), str(gold[0] - cost), '171', '7', str(len(rewards))] + [str(x) for r in rewards for x in r]


def link(db, account, b, index):
    s = beasts(db, account).get(b)
    rows = links_of(b)
    if not s or not 0 <= index < len(rows):
        raise ValueError('conexao_invalida')
    if link_status(db, account, b).split(',')[index] != '1':
        raise ValueError('conexao_indisponivel')
    rid = rows[index][0]
    for x in rows[index][1].split(','):          # the link is shared by every beast in it
        other = beasts(db, account).get(int(x))
        if other is not None:
            done = set(other['links'].split(',')) - {''}
            done.add(rid)
            other['links'] = ','.join(sorted(done, key=int))
            save(db, account, int(x), other)
    return b


def set_skill(db, account, text):
    slots = [int(x) for x in text.split(',') if x.strip()]
    if not 1 <= len(slots) <= 3:
        raise ValueError('posicoes_de_tecnica_invalidas')
    # Some client builds send only the occupied positions. The UI's three
    # slots use -1 for an empty technique, so normalize omitted trailing slots
    # to that same original empty value before persisting.
    slots += [-1] * (3 - len(slots))
    ids = [i for i in slots if i > 0]
    have = beasts(db, account)
    if any(i not in have for i in ids) or len(set(ids)) != len(ids):
        raise ValueError('besta_nao_ativada')
    s = skill(db, account)
    db._conn.execute('INSERT OR REPLACE INTO local_beast_skill VALUES (?,?,?)', (account, ','.join(map(str, slots)), s['skillReleaseMethod']))


def set_method(db, account, m):
    s = skill(db, account)
    db._conn.execute('INSERT OR REPLACE INTO local_beast_skill VALUES (?,?,?)', (account, s['equippedMAMould'], m))


def execute(server, cmd, seq, text):
    import re, hero_stats_local
    from hero_training_local import inventory_tokens
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if not fields or fields[0] != str(db.perfil(account)['user_id']):
            raise ValueError('conta_das_bestas_invalida')
        if cmd == 'magical_animals_activate_get_fate_task_reward':
            raise ValueError('destino_das_bestas_ainda_nao_implementado')
        if not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', fields[-1]):
            raise ValueError('identificador_de_pedido_invalido')
        key = fields[-1]; body = fields[1:-1]; signature = cmd + '|' + '|'.join(body)
        with db._lock, db._conn:
            receipt = db._conn.execute('SELECT signature, reply FROM local_beast_receipts WHERE conta_id=? AND request_id=?', (account, key)).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError('identificador_reutilizado')
                return str(seq) + ' ' + receipt[1].split(' ', 1)[1]
            extra = []; changed = None
            if cmd == 'magical_animals_activate_fate':
                if body:
                    raise ValueError('pedido_de_destino_invalido')
                activate_fate(db, account)
            elif cmd == 'magical_animals_activate': changed = activate(db, account, int(body[0]))
            elif cmd == 'magical_animals_advance_star': changed = advance(db, account, int(body[0]))
            elif cmd == 'magical_animals_forging': changed = forging(db, account, int(body[0]), int(body[1]), int(body[2]))
            elif cmd == 'magical_animals_steps_rebirth': changed, extra = rebirth(db, account, int(body[0]))
            elif cmd == 'magical_animals_relevant_active': changed = link(db, account, int(body[0]), int(body[1]))
            elif cmd == 'magical_animals_set_skill': set_skill(db, account, body[0] if body else '')
            else: set_method(db, account, int(body[0]))
            result = inventory_tokens(db, account) + extra + init_tokens(db, account)
            if changed is not None:
                result += ['12676', j(info(db, account, changed, beasts(db, account)[changed]))]
            reply = ' '.join([str(seq), cmd, '0'] + result + hero_stats_local.attribute_tokens(db, account))
            db._conn.execute('INSERT INTO local_beast_receipts VALUES (?,?,?,?)', (account, key, signature, reply))
        server.log('BESTAS cmd=%s conta=%s pedido=%s' % (cmd, account, '|'.join(body)))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'bestas_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
