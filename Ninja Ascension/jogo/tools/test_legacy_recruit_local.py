"""Exercise legacy Recruit gains, parser output, costs and duplicate requests."""
import os
import sys
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / "port" / "server"))
os.environ["NR_ENABLE_TUTORIAL"] = "0"

with tempfile.TemporaryDirectory(prefix="legacy-recruit-", dir=root / "build") as folder:
    os.environ["NR_ACCOUNTS_DIR"] = folder
    import local_server as server
    import legacy_recruit_local as recruit
    import recruitment_local as heroes
    import normal_recruit as normal

    db = server.BANCO
    try:
        account = db.criar_conta("legacy_recruit_test", "Temporary123!")["id"]
        server._sessao_conexao["token"] = db.abrir_sessao(account)
        uid = str(db.perfil(account)["user_id"])
        server.resposta_login_init("1", "")
        with db._conn:
            db._conn.execute(
                "INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,5000000)",
                (account,),
            )
            db._conn.execute(
                "INSERT OR IGNORE INTO local_resources(conta_id,gold,jade) VALUES (?,100000,0)",
                (account,),
            )
            db._conn.execute("UPDATE local_campaign SET silver=5000000 WHERE conta_id=?", (account,))
            db._conn.execute("UPDATE local_resources SET gold=100000 WHERE conta_id=?", (account,))
            db._conn.execute(
                "INSERT OR REPLACE INTO local_legacy_recruit_state "
                "(conta_id,free_day,silver_free,silver_next_ms,premium_free,premium_draws) "
                "VALUES (?,? ,0,0,0,0)", (account, recruit._day())
            )

        original_choose = recruit._choose
        choices = {}

        def forced_choose(group, allowed_kinds=None):
            chosen = choices.get(group, (1, [6, 68, 3]))
            if allowed_kinds is not None and chosen[1][0] not in allowed_kinds:
                raise ValueError("biblioteca_de_recrutamento_sem_premio_permitido")
            return chosen

        recruit._choose = forced_choose

        def request(command, kind, count, request_id, trailing_crlf=False,
                    extra_request_id=None):
            payload = "\r\n".join(["11", command, uid, str(kind), request_id])
            if extra_request_id is not None:
                payload += "\r\n" + extra_request_id
            if trailing_crlf:
                payload += "\r\n"
            return server.despacha(payload)

        def balance(sql, column):
            return db._conn.execute(sql, (account,)).fetchone()[0]

        def parser_166(reply):
            tokens = reply.split()
            start = tokens.index("166")
            count = int(tokens[start + 1])
            return [tuple(map(int, tokens[start + 2 + i * 2:start + 4 + i * 2]))
                    for i in range(count)]

        # Single Ryo draw includes one item gain in the original parser format.
        item_one = request("ship_bounty", 1, 1, "one-item",
                           extra_request_id="transport-generated-id")
        assert " 32 " in f" {item_one} ", item_one
        assert " 171 " not in f" {item_one} ", item_one
        assert parser_166(item_one) == [(-1, 0)], item_one
        assert balance("SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=68", "quantity") == 3
        assert request("ship_bounty", 1, 1, "one-item",
                       extra_request_id="transport-retry-id") == item_one
        assert balance("SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=68", "quantity") == 3

        # A Ryo result is both credited and sent to parser 27 for the reward UI.
        choices[1] = (70, [1, -1, 10000])
        ryo_one = request("ship_bounty", 1, 1, "one-ryo")
        assert " 28 20000 4960000 " in f" {ryo_one} ", ryo_one
        assert " 27 10000 4970000 " in f" {ryo_one} ", ryo_one
        assert parser_166(ryo_one) == [(-1, 0)], ryo_one
        assert balance("SELECT silver FROM local_campaign WHERE conta_id=?", "silver") == 4970000

        # New character: the reveal uses its mould ID; parser 9 owns the instance ID.
        choices[31] = next(
            (int(mould), [13, int(mould), 1])
            for mould in recruit.data.tabela("ship_mould.txt")
            if int(mould) not in {m for _, m in heroes.all_owned(db, account)}
        )
        char_one = request("ship_bounty", 2, 1, "one-character")
        assert " 166 1 " + str(choices[31][1][1]) + " " + str(choices[31][0]) in char_one, char_one
        assert parser_166(char_one) == [(choices[31][1][1], choices[31][0])]
        assert heroes.all_owned(db, account)

        # The original 10x result pairs each character draw with parser 166 and
        # each item/Ryo draw with the corresponding entry from new_reward_object.
        choices.update({group: (group, [6, 68, group]) for group in range(4, 11)})
        choices[7] = (70, [1, -1, 250])
        mixed_ship = next(
            int(mould) for mould in recruit.data.tabela("ship_mould.txt")
            if int(mould) not in {m for _, m in heroes.all_owned(db, account)}
        )
        choices[4] = (4, [13, mixed_ship, 1])
        # NetworkManager may add a final CRLF to the POST body; it must not
        # turn a valid purchase into a malformed request.
        ten = request("ship_batch_bounty", 1, 10, "ten-mixed", trailing_crlf=True)
        assert " 166 10 " in f" {ten} ", ten
        assert ten.count(" 32 ") == 8, ten.count(" 32 ")
        assert ten.count(" 27 ") == 1, ten.count(" 27 ")
        assert " 171 " not in f" {ten} ", ten
        ten_pairs = parser_166(ten)
        assert ten_pairs[8] == (mixed_ship, 4), ten_pairs
        assert all(pair == (-1, 0) for i, pair in enumerate(ten_pairs) if i != 8), ten_pairs
        assert balance("SELECT silver FROM local_campaign WHERE conta_id=?", "silver") == 4790250
        assert request("ship_batch_bounty", 1, 10, "ten-mixed") == ten
        assert balance("SELECT silver FROM local_campaign WHERE conta_id=?", "silver") == 4790250

        # Premium 1x/10x and Ryo 100x use their original configured costs.
        premium_one = request("ship_bounty", 2, 1, "premium-one")
        assert " 26 240 99520 " in f" {premium_one} ", premium_one
        premium_ten = request("ship_batch_bounty", 2, 10, "premium-ten")
        assert " 26 2280 97240 " in f" {premium_ten} ", premium_ten
        choices[7] = (7, [6, 68, 7])
        hundred = request("ship_batch_bounty", 4, 100, "ryo-hundred")
        assert " 28 1800000 " in f" {hundred} ", hundred
        assert " 166 100 " in f" {hundred} ", hundred
        # Group 4 uses the mixed ninja acquired above. Its repeated copies
        # become fragments but retain bounty 4 for the duplicate presentation.
        # Ordinary item draws must still have bounty 0.
        hundred_pairs=parser_166(hundred)
        assert all(pair in ((-1,0),(-1,4)) for pair in hundred_pairs),hundred_pairs
        group_list=recruit.data.tabela('partner_bounty_param.txt')['12'][10]
        configured_groups=[value for group in group_list.split('|') for value in group.split(',')][:100]
        assert hundred_pairs.count((-1,4))==configured_groups.count('4')
        assert request("ship_batch_bounty", 4, 100, "ryo-hundred") == hundred
        assert balance("SELECT silver FROM local_campaign WHERE conta_id=?", "silver") == 2990250
        assert balance("SELECT gold FROM local_resources WHERE conta_id=?", "gold") == 97240

        # Gold 1x only draws a character. A new character is recorded as such;
        # an owned character becomes fragments, even if the free sub-pool is
        # an item-only legacy group. Retrying the same request cannot add them twice.
        gold_character = next(
            int(mould) for mould in recruit.data.tabela("ship_mould.txt")
            if int(mould) not in {m for _, m in heroes.all_owned(db, account)}
        )
        choices[31] = (310, [13, gold_character, 1])
        gold_new = request("ship_bounty", 2, 1, "gold-single-new")
        assert parser_166(gold_new) == [(gold_character, 310)], gold_new
        assert " 13 " in f" {gold_new} ", gold_new
        assert balance("SELECT gold FROM local_resources WHERE conta_id=?", "gold") == 97000

        fragment_mould, fragment_quantity = normal.fragment(gold_character)
        fragment_before = db._conn.execute(
            "SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?",
            (account, fragment_mould),
        ).fetchone()
        fragment_before = fragment_before[0] if fragment_before else 0
        with db._conn:
            db._conn.execute(
                "UPDATE local_legacy_recruit_state SET premium_free=1,premium_draws=1 WHERE conta_id=?",
                (account,),
            )
        choices[3] = (303, [6, 68, 7])
        gold_duplicate = request("ship_bounty", 2, 1, "gold-single-duplicate")
        assert parser_166(gold_duplicate) == [(-1, 310)], gold_duplicate
        assert " 32 " in f" {gold_duplicate} ", gold_duplicate
        assert request("ship_bounty", 2, 1, "gold-single-duplicate") == gold_duplicate
        fragment_after = db._conn.execute(
            "SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?",
            (account, fragment_mould),
        ).fetchone()[0]
        assert fragment_after == fragment_before + fragment_quantity, (fragment_before, fragment_after)

        recruit._choose = original_choose
        path = db.caminho
    finally:
        db.fechar()

    from contas import Banco
    db = Banco(path)
    try:
        assert db._conn.execute(
            "SELECT COUNT(*) FROM local_legacy_recruit_receipts WHERE conta_id=?", (account,)
        ).fetchone()[0] == 9
    finally:
        db.fechar()

source = (root / "01_conteudo_apk/assets/src/client/shop/recruit/HeroRecruitListView.lua").read_text(encoding="utf8")
assert "blockRecruitDrawDuringVisualTest" not in source
assert "NetworkManager:register(protocol_command.ship_bounty.code" in source
assert "NetworkManager:register(protocol_command.ship_batch_bounty.code" in source
print("LEGACY_RECRUIT_GAINS_AND_CLICK_PASSED")
