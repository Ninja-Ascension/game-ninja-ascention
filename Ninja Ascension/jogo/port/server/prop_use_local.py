"""Open / use items (prop_use: instance, count, choose index).

prop_mould (0-based): 17 food, 18 endurance, 19 Ryo, 20 gold, 30/32/34 item
and 31/33/35 counts given on use, 44 addition_group_index = scene_reward_ex
library (random chest) whose column 2 lists the prizes of a choose chest
(SmPropChoose.lua:256-257). Reward window: 171 type 4 (SmPropWarehouse).
Prize kinds handled: 1 Ryo, 2 gold, 6 item, 7 equipment; anything else is
refused before the item is consumed.
"""
COMMANDS = ('prop_use',)


def triples_show(text):
    out = []
    for p in (text or '').split('|'):
        if p and p != '-1':
            mould, kind, n = p.split(',')[:3]
            out.append((int(kind), int(mould), int(n)))
    return out


def use(db, account, instance, count, choose):
    import dados_batalha as data, saga_local, shop_local
    mould = int(instance) - account * 1000000
    row = data.tabela('prop_mould.txt').get(str(mould))
    have = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, mould)).fetchone()
    if not row or not have:
        raise ValueError('item_nao_possuido')
    if not 1 <= count <= min(have[0], 999):
        raise ValueError('quantidade_invalida')
    prizes = []
    for _ in range(count):
        for kind, col in ((1, 19), (2, 20)):
            if int(float(row[col] or 0)) > 0:
                prizes.append((kind, -1, int(float(row[col]))))
        for c in (30, 32, 34):
            if int(row[c] or 0) > 0 and int(row[c + 1] or 0) > 0:
                prizes.append((6, int(row[c]), int(row[c + 1])))
        lib = row[44] if len(row) > 44 else '-1'
        if lib not in ('', '-1', '0') and lib in data.tabela('scene_reward_ex.txt'):
            if choose > 0:
                options = triples_show(data.tabela('scene_reward_ex.txt')[lib][2])
                if choose > len(options):
                    raise ValueError('escolha_invalida')
                prizes.append(options[choose - 1])
            else:
                prizes += saga_local.roll_library(lib)
    if not prizes:
        raise ValueError('item_sem_uso_neste_servidor')
    if any(k not in (1, 2, 6, 7) for k, _, _ in prizes):
        raise ValueError('premio_do_item_ainda_nao_suportado')
    db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (count, account, mould))
    db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)', (account,))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (account,))
    gold = 0; shown = []
    for kind, ident, n in prizes:
        if kind == 2:
            db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?', (n, account)); gold += n
        else:
            shop_local.grant(db, account, kind, ident, n)
        shown.append((ident if kind in (6, 7) else -1, kind, n))
    from hero_training_local import inventory_tokens
    s = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()[0]
    g = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()[0]
    return (inventory_tokens(db, account) + ['22', str(s), '25', str(gold), str(g)] + shop_local.state_tokens(db, account)
            + ['171', '4', str(len(shown))] + [str(x) for r in shown for x in r])


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        body = f[1:] if f and f[0] == str(db.perfil(account)['user_id']) else f
        instance, count = int(body[0]), int(body[1])
        choose = int(body[2]) if len(body) > 2 and body[2].lstrip('-').isdigit() else 0
        with db._lock, db._conn:
            reply = ' '.join([str(seq), cmd, '0'] + use(db, account, instance, count, choose))
        server.log('USAR_ITEM conta=%s item=%s qtd=%s escolha=%s' % (account, instance, count, choose))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'item_indisponivel')


def install(server):
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
