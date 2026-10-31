"""Ninja School > Index (illustration / 卡册), following the client rules.

Client sources: client/l_digital/cultivate/illustration/IllustrationHandle.lua
and cells/cultivate/illustration/illustration_cell.lua.

Tables (0-based columns):
  card_mould    0 id, 1 ship_id (-1 = combination card), 2 ship_group
                (combination: required ninja moulds), 3 special_condition, ...
  card_unblock  0 id, 1 ability (quality group; combination card: its id),
                2 level, 3 consume "type,prop,count|...", 4 next id (-1 = max),
                5 mark (score of this level), 6 mark_add, 7 property_add
                "kind,value|..." (total for this level, not incremental)
  card_achieve  0 id, 1 score needed, 2 property_add (one tier each; tiers add up)

Rules (IllustrationHandle):
  - single card: activate when the account owns that ninja (level 0, free);
    level up while card level + 1 <= ninja star, paying the next row's consume.
    Quality group = max(ship_mould.ability, 15).
  - combination card: needs every ninja of ship_group with a card at level >= 7
    AND its special conditions; special-condition progress is not tracked by
    this port yet, so combination cards are refused instead of faking it.
Effects: the sum of current-level property_add of every card (normalAddition)
plus every reached card_achieve tier (achieveAddition) applies to all ninjas.
"""
import json
import dados_batalha as data

COMMANDS = ('user_card_info_activate', 'user_card_info_advance', 'user_card_info_rank')
SHIP_ABILITY = 8          # ship_mould.ability (LocalDatas.lua: ability = 9, 1-based)


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_index_cards (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, card INTEGER NOT NULL, star INTEGER NOT NULL, PRIMARY KEY(conta_id, card))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_index_receipts (conta_id INTEGER, request_id TEXT, signature TEXT, reply TEXT, PRIMARY KEY(conta_id, request_id))')


def card_row(card):
    return data.tabela('card_mould.txt')[str(card)]


def is_combination(card):
    return int(card_row(card)[2].split(',')[0]) > 0


def group(card):
    if is_combination(card):
        return int(card)
    ship = card_row(card)[1]
    return max(15, int(data.tabela('ship_mould.txt')[ship][SHIP_ABILITY]))


_LEVELS = {}


def level_row(card, level):
    if not _LEVELS:
        for row in data.tabela('card_unblock.txt').values():
            _LEVELS[(row[1], int(row[2]))] = row
    return _LEVELS.get((str(group(card)), level))


def pairs(text):
    if not text or text.strip() in ('', '-1'):
        return []
    return [(int(k), float(v)) for k, v in (p.split(',') for p in text.split('|'))]


def fmt(totals):
    def num(v):
        return str(int(v)) if float(v).is_integer() else repr(round(v, 6))
    return '|'.join('%d,%s' % (k, num(v)) for k, v in sorted(totals.items())) or '0,0'


def cards(db, account):
    with db._lock:
        return {int(c): int(s) for c, s in db._conn.execute(
            'SELECT card, star FROM local_index_cards WHERE conta_id=? ORDER BY card', (account,))}


def summary(db, account):
    """(totalScore, achieveAdd dict, normalAdd dict, entries)."""
    owned = cards(db, account)
    score = 0; normal = {}; entries = []
    for card, star in owned.items():
        row = level_row(card, star)
        mark = int(row[5]) if row else 0
        score += mark
        for k, v in pairs(row[7] if row else ''):
            normal[k] = normal.get(k, 0) + v
        ship = card_row(card)[1]
        entries.append(dict(id=card, cardStar=star, cardMouldId=card, cardScore=mark,
                            shipMouldId=int(ship) if ship != '-1' else -1))
    achieve = {}
    for row in data.tabela('card_achieve.txt').values():
        if row[1].lstrip('-').isdigit() and score >= int(row[1]):
            for k, v in pairs(row[2]):
                achieve[k] = achieve.get(k, 0) + v
    return score, achieve, normal, entries


def info(db, account):
    """illustration_info_init for the local 15997 snapshot."""
    score, achieve, normal, entries = summary(db, account)
    return {'totalScore': score, 'achieveAdditionProperty': fmt(achieve),
            'normalAdditionProperty': fmt(normal), 'userCardInfoList': entries}


def bonus(db, account):
    """Index effects for every ninja: list of (kind, amount)."""
    _, achieve, normal, _ = summary(db, account)
    total = dict(normal)
    for k, v in achieve.items():
        total[k] = total.get(k, 0) + v
    return list(total.items())


def tokens(db, account, code):
    """Original 12662/12663/12664 layout."""
    score, achieve, normal, entries = summary(db, account)
    out = [code, str(score), fmt(achieve), fmt(normal), str(len(entries))]
    for e in entries:
        out += [str(e['id']), str(e['cardStar']), str(e['cardMouldId']), str(e['cardScore']), str(e['shipMouldId'])]
    return out


def owned_moulds(db, account):
    import recruitment_local as heroes
    return {int(m): int(s) for s, m in heroes.all_owned(db, account)}


def ninja_star(db, account, mould):
    import hero_development_local as dev
    ship = owned_moulds(db, account).get(int(mould))
    return dev.state(db, account, ship, mould)['star'] if ship is not None else 0


def activate(db, account, card):
    if card in cards(db, account):
        raise ValueError('carta_ja_ativada')
    if is_combination(card):
        owned = cards(db, account)
        for mould in card_row(card)[2].split(','):
            single = next((int(r[0]) for r in data.tabela('card_mould.txt').values() if r[1] == mould), None)
            if single is None or owned.get(single, -1) < 7:
                raise ValueError('carta_combinada_requer_cartas_nivel_7')
        raise ValueError('condicoes_especiais_da_carta_combinada_nao_implementadas')
    if int(card_row(card)[1]) not in owned_moulds(db, account):
        raise ValueError('ninja_nao_possuido')
    if level_row(card, 0) is None:
        raise ValueError('carta_sem_configuracao')
    db._conn.execute('INSERT INTO local_index_cards VALUES (?,?,0)', (account, card))


def advance(db, account, card):
    owned = cards(db, account)
    if card not in owned:
        raise ValueError('carta_nao_ativada')
    star = owned[card]
    row = level_row(card, star)
    if row is None or row[4] == '-1':
        raise ValueError('carta_no_nivel_maximo')
    nxt = data.tabela('card_unblock.txt')[row[4]]
    if not is_combination(card) and star + 1 > ninja_star(db, account, card_row(card)[1]):
        raise ValueError('estrelas_do_ninja_insuficientes')
    costs = []
    for part in nxt[3].split('|'):
        kind, prop, count = map(int, part.split(','))
        if kind != 6:
            raise ValueError('custo_de_carta_nao_suportado')
        have = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, prop)).fetchone()
        if not have or have[0] < count:
            raise ValueError('itens_insuficientes')
        costs.append((prop, count))
    for prop, count in costs:
        db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (count, account, prop))
    db._conn.execute('UPDATE local_index_cards SET star=star+1 WHERE conta_id=? AND card=?', (account, card))


def rank(db, account):
    import profile_local
    rows = []
    with db._lock:
        contas = db._conn.execute('SELECT DISTINCT conta_id FROM local_index_cards').fetchall()
    for (conta,) in contas:
        p = db.perfil(conta)
        grade = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (conta,)).fetchone()
        rows.append(dict(userId=str(p['user_id']), headPic=profile_local.head(db, conta), headFrame='',
                         userLevel=grade[0] if grade else 1, nickName=p['user_name'].replace(' ', ' '),
                         unionName='', score=summary(db, conta)[0]))
    rows.sort(key=lambda r: -r['score'])
    for i, r in enumerate(rows, 1):
        r['user_rank'] = i
    mine = next((r for r in rows if r['userId'] == str(db.perfil(account)['user_id'])), None)
    return {'rankSize': len(rows), 'rankInfo': rows,
            'myRank': mine['user_rank'] if mine else -1,
            'myRankInfo': {'score': summary(db, account)[0]}}


def execute(server, cmd, seq, text):
    import re
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if not fields or fields[0] != str(db.perfil(account)['user_id']):
            raise ValueError('conta_do_index_invalida')
        if cmd == 'user_card_info_rank':
            return ' '.join([str(seq), cmd, '0', '12665', json.dumps(rank(db, account), separators=(',', ':'), ensure_ascii=False)])
        if len(fields) != 3 or not fields[1].isdigit() or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', fields[2]):
            raise ValueError('pedido_do_index_invalido')
        card = int(fields[1]); key = fields[2]; signature = cmd + '|' + fields[1]
        card_row(card)
        import hero_training_local, hero_stats_local
        with db._lock, db._conn:
            receipt = db._conn.execute('SELECT signature, reply FROM local_index_receipts WHERE conta_id=? AND request_id=?', (account, key)).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError('identificador_reutilizado')
                return str(seq) + ' ' + receipt[1].split(' ', 1)[1]
            if cmd == 'user_card_info_activate':
                activate(db, account, card); code = '12663'
            else:
                advance(db, account, card); code = '12664'
            reply = ' '.join([str(seq), cmd, '0'] + hero_training_local.inventory_tokens(db, account)
                             + tokens(db, account, code) + hero_stats_local.attribute_tokens(db, account))
            db._conn.execute('INSERT INTO local_index_receipts VALUES (?,?,?,?)', (account, key, signature, reply))
        server.log('INDEX cmd=%s conta=%s carta=%s' % (cmd, account, card))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'index_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
