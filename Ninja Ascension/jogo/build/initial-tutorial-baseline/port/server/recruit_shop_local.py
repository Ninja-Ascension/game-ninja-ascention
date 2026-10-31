"""Recruit shop: recovered new_draw_card_shop offers, costs and weekly caps."""
import datetime
import json
import re
import dados_batalha as data
import normal_recruit as recruit


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_recruit_shop_buys(conta_id INTEGER,period TEXT,offer INTEGER,bought INTEGER,PRIMARY KEY(conta_id,period,offer))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_recruit_shop_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')


def period(kind):
    date = datetime.date.fromisoformat(recruit.day())
    if kind == 1:
        return 'day:' + date.isoformat()
    if kind == 2:
        year, week, _ = date.isocalendar()
        return 'week:%s:%s' % (year, week)
    if kind == 3:
        return 'month:%s:%s' % (date.year, date.month)
    raise ValueError('periodo_da_loja_invalido')


def remaining(db, account):
    result = []
    for key, row in data.tabela('new_draw_card_shop.txt').items():
        saved = db._conn.execute('SELECT bought FROM local_recruit_shop_buys WHERE conta_id=? AND period=? AND offer=?', (account, period(int(row[1])), int(key))).fetchone()
        result.append(str(max(0, int(row[3]) - (saved[0] if saved else 0))))
    return ','.join(result)


def buy(server, seq, text):
    db = server.BANCO
    command = 'new_recruitment_shop_buy'
    try:
        import recruitment_local as heroes
        from hero_training_local import inventory_tokens
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        if len(f) != 4 or f[0] != str(db.perfil(account)['user_id']) or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', f[-1]):
            raise ValueError('pedido_da_loja_recruit_invalido')
        offer, count = int(f[1]), int(f[2])
        if not 1 <= count <= 100:
            raise ValueError('quantidade_invalida')
        row = data.tabela('new_draw_card_shop.txt').get(str(offer))
        if not row or row[2] != '-1|-1':
            raise ValueError('oferta_ou_condicao_nao_suportada')
        signature = '%s:%s' % (offer, count)
        with db._lock, db._conn:
            receipt = db._conn.execute('SELECT signature,reply FROM local_recruit_shop_receipts WHERE conta_id=? AND request_id=?', (account, f[-1])).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError('identificador_reutilizado')
                return str(seq) + ' ' + receipt[1].split(' ', 1)[1]
            epoch = period(int(row[1]))
            bought = db._conn.execute('SELECT bought FROM local_recruit_shop_buys WHERE conta_id=? AND period=? AND offer=?', (account, epoch, offer)).fetchone()
            if (bought[0] if bought else 0) + count > int(row[3]):
                raise ValueError('limite_semanal_da_oferta')
            kind, coin, amount = map(int, row[5].split(','))
            reward = list(map(int, row[4].split(',')))
            if kind != 6 or reward[0] != 13 or reward[2] != 1:
                raise ValueError('configuracao_da_oferta_nao_suportada')
            balance = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, coin)).fetchone()
            if not balance or balance[0] < amount * count:
                raise ValueError('moedas_de_recruit_insuficientes')
            known = {m: s for s, m in heroes.all_owned(db, account)}
            new = []
            rewards = []
            for _ in range(count):
                mould = reward[1]
                if mould not in known:
                    ship = 1000000000 + account * 10000 + mould
                    db._conn.execute('INSERT INTO local_synthesized VALUES (?,?,?)', (account, mould, ship))
                    known[mould] = ship
                    new.append((ship, mould))
                    rewards.append((mould, 13, 1))
                else:
                    # Same duplicate conversion as the existing normal draw.
                    fragment, number = recruit.fragment(mould)
                    db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity', (account, fragment, account * 1000000 + fragment, number))
                    rewards.append((fragment, 6, number))
            db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (amount * count, account, coin))
            db._conn.execute('INSERT INTO local_recruit_shop_buys VALUES (?,?,?,?) ON CONFLICT(conta_id,period,offer) DO UPDATE SET bought=bought+excluded.bought', (account, epoch, offer, count))
            tokens = []
            for hero in new:
                tokens += heroes.one_ship_tokens(db, account, hero)
            tokens += inventory_tokens(db, account)
            payload = recruit.state_payload(db, account)
            payload['localShopNewShips'] = [str(s) for s, m in new]
            tokens += ['15005', json.dumps(payload, separators=(',', ':')), '171', '7', str(len(rewards))]
            tokens += [str(v) for item in rewards for v in item]
            reply = ' '.join([str(seq), command, '0'] + tokens)
            db._conn.execute('INSERT INTO local_recruit_shop_receipts VALUES (?,?,?,?)', (account, f[-1], signature, reply))
            return reply
    except (server._contas.ErroConta, ValueError, IndexError, KeyError) as exc:
        return server.recusa(command, seq, str(exc))


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    server.MINIMOS['new_recruitment_shop_buy'] = lambda seq, text: buy(server, seq, text)
