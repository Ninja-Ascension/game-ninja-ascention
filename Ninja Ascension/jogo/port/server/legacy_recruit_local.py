"""Legacy Recruit reconstructed from the original APK client and tables."""
import re
import secrets

import dados_batalha as data


# Command types in HeroRecruitListView.lua -> original partner_bounty_param row.
DRAWS = {
    ("ship_bounty", "1"): ("1", 1),
    ("ship_bounty", "2"): ("2", 1),
    ("ship_batch_bounty", "1"): ("9", 10),
    ("ship_batch_bounty", "2"): ("4", 10),
    ("ship_batch_bounty", "4"): ("12", 100),
}


def schema(db):
    db._conn.execute(
        "CREATE TABLE IF NOT EXISTS local_legacy_recruit_state ("
        "conta_id INTEGER PRIMARY KEY, free_day TEXT NOT NULL, "
        "silver_free INTEGER NOT NULL DEFAULT 0, silver_next_ms INTEGER NOT NULL DEFAULT 0, "
        "premium_free INTEGER NOT NULL DEFAULT 0, premium_draws INTEGER NOT NULL DEFAULT 0)"
    )
    db._conn.execute(
        "CREATE TABLE IF NOT EXISTS local_legacy_recruit_receipts ("
        "conta_id INTEGER NOT NULL, request_id TEXT NOT NULL, signature TEXT NOT NULL, "
        "reply TEXT NOT NULL, PRIMARY KEY(conta_id, request_id))"
    )


def _day():
    import normal_recruit
    return normal_recruit.day()


def _state(db, account):
    """Initialize/reset daily free quotas from the recovered original table."""
    today = _day()
    with db._lock:
        db._conn.execute("INSERT OR IGNORE INTO local_legacy_recruit_state "
                         "(conta_id,free_day,silver_free,premium_free) VALUES (?,?,?,?)",
                         (account, today,
                          int(data.tabela("partner_bounty_param.txt")["1"][2]),
                          int(data.tabela("partner_bounty_param.txt")["2"][2])))
        row = db._conn.execute(
            "SELECT free_day,silver_free,silver_next_ms,premium_free,premium_draws "
            "FROM local_legacy_recruit_state WHERE conta_id=?", (account,)
        ).fetchone()
        if row[0] != today:
            db._conn.execute(
                "UPDATE local_legacy_recruit_state SET free_day=?,silver_free=?,"
                "silver_next_ms=0,premium_free=? WHERE conta_id=?",
                (today, int(data.tabela("partner_bounty_param.txt")["1"][2]),
                 int(data.tabela("partner_bounty_param.txt")["2"][2]), account),
            )
            row = (today, int(data.tabela("partner_bounty_param.txt")["1"][2]),
                   0, int(data.tabela("partner_bounty_param.txt")["2"][2]), row[4])
    return tuple(row)


def login_tokens(db, account):
    """Nine values consumed by parse_login_init's three free_info entries."""
    import time
    state = _state(db, account)
    now_ms = int(time.time() * 1000)
    silver_wait = max(0, int(state[2]) - now_ms)
    return [str(silver_wait), "0", str(int(state[1])),
            "0", "0", str(int(state[3])),
            "0", "0", "0"]


def _choose(group, allowed_kinds=None):
    rows = [r for r in data.tabela("bounty_hero_param.txt").values()
            if int(r[1]) == group and int(r[5]) > 0
            and (allowed_kinds is None or int(r[6].split(",", 1)[0]) in allowed_kinds)]
    total = sum(int(r[5]) for r in rows)
    if total <= 0:
        raise ValueError("biblioteca_de_recrutamento_sem_premio_permitido")
    roll = secrets.randbelow(total)
    for row in rows:
        roll -= int(row[5])
        if roll < 0:
            return int(row[0]), list(map(int, row[6].split(",")))[:3]
    raise ValueError("sorteio_de_recrutamento_invalido")


def _groups(row, count, free=False, free_group_index=0):
    if count == 1:
        pool = row[6 if free_group_index == 0 else 7].split(",") if free else row[8].split(",")
        if not pool or not pool[0]:
            raise ValueError("grupo_de_recrutamento_ausente")
        return [int(pool[0])]
    groups = [int(g) for values in row[10].split("|")
              for g in values.split(",") if g]
    if len(groups) < count:
        raise ValueError("grupos_de_recrutamento_insuficientes")
    return groups[:count]


def _give_item(db, account, mould, quantity):
    if str(mould) not in data.tabela("prop_mould.txt") or quantity <= 0:
        raise ValueError("item_de_recrutamento_invalido")
    db._conn.execute(
        "INSERT INTO local_inventory VALUES (?,?,?,?) "
        "ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity",
        (account, mould, account * 1000000 + mould, quantity),
    )


def _prop_add_tokens(db, account, mould, quantity):
    """Emit parser 32 so the original recruit result screen sees the gain.

    Parser 6024 replaces the whole bag and does not append to
    ``_ED.new_reward_object``. The Recruit UI expects an incremental parser 32
    update, which both updates the bag and records the gained quantity.
    """
    row = data.tabela("prop_mould.txt").get(str(mould))
    if not row:
        raise ValueError("item_de_recrutamento_invalido")
    owned = db._conn.execute(
        "SELECT instance_id FROM local_inventory WHERE conta_id=? AND mould=?",
        (account, mould),
    ).fetchone()
    if not owned:
        raise ValueError("item_de_recrutamento_ausente_apos_sorteio")

    def col(index, default="0"):
        value = row[index - 1] if len(row) >= index else default
        value = str(value or default)
        # The game's response protocol is whitespace-tokenized.
        return "_".join(value.split()) or default

    # parse_user_prop_add, ProtocolParserCopy.lua:1803-1819
    return ["32", str(owned[0]), str(mould), col(2), col(3), col(4),
            col(58), str(quantity), col(25), col(26), col(27), col(28),
            col(29), col(9), col(39), str(int(__import__("time").time()))]


def _apply_reward(db, account, known, bounty_id, reward):
    import normal_recruit
    kind, mould, quantity = reward
    display_id = -1
    if kind == 13:
        if str(mould) not in data.tabela("ship_mould.txt"):
            raise ValueError("personagem_de_recrutamento_ausente")
        if mould not in known:
            ship = 1000000000 + account * 100000 + mould
            db._conn.execute("INSERT INTO local_synthesized VALUES (?,?,?)",
                             (account, mould, ship))
            known[mould] = ship
            display_id = ship
        else:
            # Use the same duplicate-to-character-fragments policy as the
            # active Ascension recruit system.
            mould, quantity = normal_recruit.fragment(mould)
            kind = 6
    if kind == 6:
        _give_item(db, account, mould, quantity)
    elif kind == 1:
        db._conn.execute("UPDATE local_campaign SET silver=silver+? WHERE conta_id=?",
                         (quantity, account))
    elif kind != 13:
        raise ValueError("tipo_de_premio_de_recrutamento_nao_suportado")
    # Parser 166's random_patch_id is a mould/template ID used by
    # ShipPictureTenCell; a database ship instance ID belongs only in parser 9.
    return display_id, mould, bounty_id, (mould, kind, quantity), kind == 13 and display_id > 0


def _execute(server, command, seq, text, fallback):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())["conta_id"]
        fields = server._linhas(text)
        # Some NetworkManager builds terminate every request with CRLF. The
        # original client command builder does not add one, but accepting the
        # optional empty trailing line keeps the request shape stable across
        # both transport paths without weakening validation of real fields.
        while fields and fields[-1] == "":
            fields.pop()
        if len(fields) < 2 or (command, fields[1]) not in DRAWS:
            return fallback(seq, text)
        expected_user_id = str(db.perfil(account)["user_id"])
        if not fields or fields[0] != expected_user_id:
            option = fields[1] if len(fields) > 1 and fields[1].isdigit() else "?"
            server.log(
                "LEGACY_RECRUIT invalid_shape command=%s fields=%d lengths=%s "
                "user_match=%s option=%s"
                % (command, len(fields), [len(value) for value in fields[:8]],
                   bool(fields) and fields[0] == expected_user_id, option)
            )
            raise ValueError("pedido_de_recrutamento_invalido")
        request_id_pattern = r"[0-9A-Za-z:-]{1,100}"
        if len(fields) == 3:
            request_id = fields[2]
        elif (len(fields) == 4
              and re.fullmatch(request_id_pattern, fields[2])
              and re.fullmatch(request_id_pattern, fields[3])):
            # The installed client can append a transport-generated request
            # ID after the stable ID already placed in param_list by the
            # Recruit screen. Keep the first (retry-stable) ID for receipts.
            request_id = fields[2]
            server.log("LEGACY_RECRUIT duplicate_transport_request_id command=%s" % command)
        else:
            server.log(
                "LEGACY_RECRUIT invalid_shape command=%s fields=%d lengths=%s user_match=True"
                % (command, len(fields), [len(value) for value in fields[:8]])
            )
            raise ValueError("pedido_de_recrutamento_invalido")
        if not re.fullmatch(request_id_pattern, request_id):
            raise ValueError("identificador_de_pedido_invalido")
        row_id, count = DRAWS[(command, fields[1])]
        cfg = data.tabela("partner_bounty_param.txt").get(row_id)
        if not cfg:
            raise ValueError("configuracao_de_recrutamento_ausente")
        signature = "%s|%s|%s" % (command, fields[1], row_id)

        import recruitment_local as heroes
        with db._lock, db._conn:
            schema(db)
            receipt = db._conn.execute(
                "SELECT signature,reply FROM local_legacy_recruit_receipts "
                "WHERE conta_id=? AND request_id=?", (account, request_id)
            ).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError("identificador_reutilizado")
                return str(seq) + " " + receipt[1].split(" ", 1)[1]

            db._conn.execute("INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)", (account,))
            db._conn.execute("INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)", (account,))
            # Rows 1/2 are single costs; rows 9/12 already contain the total
            # Ryo cost for 10x/100x. Premium row 4 is the original 10x price.
            silver_cost = int(cfg[3])
            gold_cost = int(cfg[4])
            silver = db._conn.execute(
                "SELECT silver FROM local_campaign WHERE conta_id=?", (account,)
            ).fetchone()[0]
            gold = db._conn.execute(
                "SELECT gold FROM local_resources WHERE conta_id=?", (account,)
            ).fetchone()[0]
            state = _state(db, account)
            now_ms = __import__("time").time_ns() // 1000000
            use_free = False
            free_group_index = 0
            if command == "ship_bounty" and fields[1] == "1" and state[1] > 0 and now_ms >= state[2]:
                use_free = True
                cooldown_ms = int(cfg[5])
                next_free_ms = now_ms + cooldown_ms if state[1] > 1 else 0
                db._conn.execute(
                    "UPDATE local_legacy_recruit_state SET silver_free=silver_free-1,silver_next_ms=? WHERE conta_id=?",
                    (next_free_ms, account),
                )
            elif command == "ship_bounty" and fields[1] == "2" and state[3] > 0:
                use_free = True
                free_group_index = 0 if state[4] == 0 else 1
                db._conn.execute(
                    "UPDATE local_legacy_recruit_state SET premium_free=premium_free-1 WHERE conta_id=?",
                    (account,),
                )
            if use_free:
                silver_cost = 0
                gold_cost = 0
            if silver < silver_cost:
                raise ValueError("ryo_insuficiente")
            if gold < gold_cost:
                raise ValueError("gold_insuficiente")
            db._conn.execute("UPDATE local_campaign SET silver=silver-? WHERE conta_id=?",
                             (silver_cost, account))
            db._conn.execute("UPDATE local_resources SET gold=gold-? WHERE conta_id=?",
                             (gold_cost, account))

            known = {m: ship for ship, m in heroes.all_owned(db, account)}
            results, new_ships = [], []
            groups = _groups(cfg, count, use_free, free_group_index)
            premium_single = command == "ship_bounty" and fields[1] == "2"
            premium_character_group = int(cfg[8].split(",")[0]) if premium_single else None
            # Preserve the original full-ninja draw identity for presentation
            # when its actual reward is converted to fragments. This does not
            # change the charge, grant, draw order or receipt transaction.
            duplicate_bounties = set()
            for group in groups:
                if premium_single:
                    # Gold 1x must yield a character; _apply_reward converts
                    # an already-owned character into its configured fragments.
                    # Some legacy free sub-pools contain ordinary items, so
                    # fall back to the configured paid Gold character pool.
                    try:
                        bounty_id, reward = _choose(group, {13})
                    except ValueError as exc:
                        if str(exc) != "biblioteca_de_recrutamento_sem_premio_permitido":
                            raise
                        bounty_id, reward = _choose(premium_character_group, {13})
                else:
                    bounty_id, reward = _choose(group)
                ship_id, display_mould, bounty_id, actual, is_new = _apply_reward(
                    db, account, known, bounty_id, reward
                )
                if reward[0] == 13 and actual[1] == 6:
                    duplicate_bounties.add(bounty_id)
                if is_new:
                    new_ships.append((ship_id, actual[0]))
                results.append((display_mould, bounty_id, actual))

            if fields[1] == "2":
                db._conn.execute(
                    "UPDATE local_legacy_recruit_state SET premium_draws=premium_draws+? WHERE conta_id=?",
                    (count, account),
                )
            premium_draws = db._conn.execute(
                "SELECT premium_draws FROM local_legacy_recruit_state WHERE conta_id=?", (account,)
            ).fetchone()[0]

            tokens = [str(seq), command, "0"]
            for hero in new_ships:
                tokens += heroes.one_ship_tokens(db, account, hero)

            # Parser 6024 only replaces the bag and does not append to the
            # Recruit reward panel. Send parser 32/27 in draw order so the bag
            # is updated and the original 100x summary has one entry per draw.
            silver_gain = sum(actual[2] for _, _, actual in results if actual[1] == 1)
            silver = db._conn.execute(
                "SELECT silver FROM local_campaign WHERE conta_id=?", (account,)
            ).fetchone()[0]
            gold = db._conn.execute(
                "SELECT gold FROM local_resources WHERE conta_id=?", (account,)
            ).fetchone()[0]
            # Correctly use the original currency parsers: shop_local.balances
            # treats its delta as a gold change and is not suitable for a Ryo
            # purchase. Keep the final balance consistent after both the cost
            # and any Ryo reward in the draw.
            silver_after_cost = silver - silver_gain
            if silver_cost:
                tokens += ["28", str(silver_cost), str(silver_after_cost)]
            if gold_cost:
                tokens += ["26", str(gold_cost), str(gold)]

            item_gain = {}
            for _, _, actual in results:
                if actual[1] == 6:
                    item_gain[actual[0]] = item_gain.get(actual[0], 0) + actual[2]
            item_seen = {}
            for _, _, actual in results:
                mould, kind, quantity = actual
                if kind == 1:
                    silver_after_cost += quantity
                    tokens += ["27", str(quantity), str(silver_after_cost)]
                elif kind == 6:
                    item_seen[mould] = item_seen.get(mould, 0) + quantity
                    owned = db._conn.execute(
                        "SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?",
                        (account, mould),
                    ).fetchone()
                    total_owned = int(owned[0]) if owned else 0
                    before_draw = total_owned - item_gain[mould]
                    tokens += _prop_add_tokens(
                        db, account, mould, before_draw + item_seen[mould]
                    )

            # Parser 166 drives the original Recruit reveal. Its first field
            # is a character mould ID, or -1 for a non-character draw. The
            # original 10x screen uses -1 to consume the matching item/Ryo
            # entry from _ED.new_reward_object. Sending an item mould here
            # makes the client render that item as a ninja and attach the
            # ninja's skill panel to it.
            tokens += ["166", str(len(results))]
            for display_mould, bounty_id, actual in results:
                is_character = actual[1] == 13
                tokens += [str(display_mould if is_character else -1),
                           str(bounty_id if is_character or bounty_id in duplicate_bounties else 0)]
            if count == 1:
                # parse_get_ship_bounty_fragment, l_naruto branch (118).
                tab = 1 if fields[1] == "1" else 2
                hero_id = results[0][2][0] if results[0][2][1] == 13 else -1
                state = _state(db, account)
                now_ms = __import__("time").time_ns() // 1000000
                wait = max(0, int(state[2]) - now_ms) if tab == 1 else 0
                remaining = int(state[1]) if tab == 1 else int(state[3])
                tokens += ["118", str(tab), str(wait), "0", str(remaining),
                           str(hero_id), str(premium_draws)]
            reply = " ".join(tokens)
            db._conn.execute(
                "INSERT INTO local_legacy_recruit_receipts VALUES (?,?,?,?)",
                (account, request_id, signature, reply),
            )
        server.log("LEGACY_RECRUIT command=%s account=%s draws=%s silver=%s gold=%s" %
                   (command, account, count, silver_cost, gold_cost))
        return reply
    except (server._contas.ErroConta, ValueError, IndexError, KeyError, TypeError) as exc:
        return server.recusa(command, seq, str(exc) or "recrutamento_indisponivel")


def install(server):
    db = server.BANCO
    with db._lock, db._conn:
        schema(db)
    for command in ("ship_bounty", "ship_batch_bounty"):
        previous = server.MINIMOS.get(command)
        if previous is not None:
            server.MINIMOS[command] = (
                lambda seq, text, cmd=command, fallback=previous:
                _execute(server, cmd, seq, text, fallback)
            )
