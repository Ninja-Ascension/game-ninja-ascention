"""Protocol smoke for Ninja Trial battle settlements using a temporary DB."""
import os
import sys
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port' / 'server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'

with tempfile.TemporaryDirectory(prefix='ninja-trial-', dir=root / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server

    db = server.BANCO
    try:
        account = db.criar_conta('ninjatrialtest', 'Temporary123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(account)
        uid = str(db.perfil(account)['user_id'])

        def trial_request(command, *args):
            return server.despacha('\r\n'.join(['7', command, uid] +
                                                 list(map(str, args))))

        initial = trial_request('three_kingdoms_init')
        assert ' 0 343 0 0 0  0 0 0 347 ' in initial, initial
        import re
        assert '12558' in initial, initial
        npc_ids = initial.split()[initial.split().index('12558') + 7].split(',')
        assert len(npc_ids) == 3 and all(x.isdigit() for x in npc_ids), initial
        import ninja_trial_local
        first_stars, first_score = sorted(x for x in ninja_trial_local._battle_choices(db,account,1,list(map(int,npc_ids)),int(npc_ids[0])) if x[0]==3)[0]

        # The original launch payload has an empty field between HP data and
        # the buff data. Preserve it; removing empty lines shifts the fields.
        payload = ['54', '157', npc_ids[0], str(first_stars), '1', '1',
                   '100001:649,50,100', '', '', str(first_score), '1,1,1,1']
        first = trial_request('three_kingdoms_launch', *payload)
        assert ' three_kingdoms_launch 0 343 3 3 3  1 0 0 347 ' in first, first
        assert ('12558 %s %s %s' % (first_score,first_score,first_score)) in first, first

        # Same semantic packet under a new sequence must not count twice.
        replay = server.despacha('\r\n'.join(['8', 'three_kingdoms_launch',
                                               uid] + payload))
        assert replay.startswith('8 three_kingdoms_launch 0 343'), replay
        state = db._conn.execute(
            'SELECT floor,stars FROM local_ninja_trial WHERE conta_id=?',
            (account,)).fetchone()
        assert tuple(state) == (1, 3), state

        # The original floor 2 is a buff selection; the server stores the
        # configured attribute values, then unlocks floor 3.
        buff = trial_request('three_kingdoms_launch', 54, 157, 0, 0, 0, 2,
                   '100001:600,0,100', '1:-1|3:-1', '', 0)
        assert ' three_kingdoms_launch 0 343 ' in buff and '1:-1,1|3:-1,1' in buff, buff
        state = db._conn.execute('SELECT floor,buffs FROM local_ninja_trial WHERE conta_id=?',
                                 (account,)).fetchone()
        assert state[0] == 2 and state[1] == '1:-1,1|3:-1,1', tuple(state)

        # Clear original fight floor 3 and claim the configured floor 4 chest.
        current = buff.split()[buff.split().index('12558') + 7].split(',')
        third_stars, third_score = sorted(x for x in ninja_trial_local._battle_choices(db,account,3,list(map(int,current)),int(current[0])) if x[0]==3)[0]
        third = trial_request('three_kingdoms_launch', 54, 157, current[0], third_stars, 1, 3,
                    '100001:600,0,100', '', '', third_score, '1,1,1,1')
        assert ' three_kingdoms_launch 0 343 ' in third, third
        chest = trial_request('three_kingdoms_launch', 54, 157, 0, 0, 0, 4,
                    '', '', '', 0)
        assert ' 171 37 ' in chest, chest
        assert db._conn.execute("SELECT 1 FROM local_ninja_trial_claims WHERE conta_id=? AND kind='chest' AND item_id=4",(account,)).fetchone()
        wallet_before = tuple(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()) + tuple(db._conn.execute('SELECT gold,honour,soul,jade FROM local_resources WHERE conta_id=?',(account,)).fetchone())
        inventory_before = tuple(tuple(r) for r in db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? ORDER BY mould',(account,)).fetchall())
        duplicate_chest = trial_request('three_kingdoms_launch', 54, 157, 0, 0, 0, 4,
                              '', '', '', 0)
        assert duplicate_chest.startswith('7 three_kingdoms_launch 0'), duplicate_chest
        wallet_after = tuple(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()) + tuple(db._conn.execute('SELECT gold,honour,soul,jade FROM local_resources WHERE conta_id=?',(account,)).fetchone())
        inventory_after = tuple(tuple(r) for r in db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? ORDER BY mould',(account,)).fetchall())
        assert wallet_after == wallet_before and inventory_after == inventory_before

        # Claim the original score reward once; the repeat is rejected without
        # consuming anything a second time. Ranking type 5 is the original UI.
        score_claim = trial_request('three_kingdoms_draw_score_reward', 1)
        assert 'three_kingdoms_draw_score_reward 0 343' in score_claim, score_claim
        before_repeat = tuple(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()) + tuple(db._conn.execute('SELECT gold,honour,soul,jade FROM local_resources WHERE conta_id=?',(account,)).fetchone())
        inventory_repeat_before = tuple(tuple(r) for r in db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? ORDER BY mould',(account,)).fetchall())
        score_repeat = trial_request('three_kingdoms_draw_score_reward', 1)
        assert ' -1 recompensa_trial_ja_recebida' in score_repeat, score_repeat
        after_repeat = tuple(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()) + tuple(db._conn.execute('SELECT gold,honour,soul,jade FROM local_resources WHERE conta_id=?',(account,)).fetchone())
        inventory_repeat_after = tuple(tuple(r) for r in db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? ORDER BY mould',(account,)).fetchall())
        assert before_repeat == after_repeat and inventory_repeat_before == inventory_repeat_after
        ranking = server.despacha('\r\n'.join(['9','order_get_info',uid,'5','1','50']))
        assert '12607' in ranking and ' 1 ' in ranking, ranking

        # A purchase retries with the same sequence idempotently; a new
        # sequence represents a separate user-confirmed purchase.
        db._conn.execute('INSERT OR IGNORE INTO local_special_wallet(conta_id) VALUES (?)',(account,))
        db._conn.execute('UPDATE local_special_wallet SET trial=1000 WHERE conta_id=?',(account,))
        db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id,gold) VALUES (?,1000)',(account,))
        shop_req='\r\n'.join(['40','dignified_shop_buy',uid,'9','1'])
        shop_first=server.despacha(shop_req)
        assert ' dignified_shop_buy 0 ' in shop_first, shop_first
        shop_balance=db._conn.execute('SELECT trial FROM local_special_wallet WHERE conta_id=?',(account,)).fetchone()[0]
        shop_inventory=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=6',(account,)).fetchone()[0]
        shop_replay=server.despacha(shop_req)
        assert shop_replay.startswith('40 dignified_shop_buy 0'), shop_replay
        assert db._conn.execute('SELECT trial FROM local_special_wallet WHERE conta_id=?',(account,)).fetchone()[0]==shop_balance
        assert db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=6',(account,)).fetchone()[0]==shop_inventory

        # Original loss shape (floor=-1) is acknowledged without progress.
        loss = trial_request('three_kingdoms_launch', 54, 157, 0, 0, 1, -1,
                   '4001:25,0,25', '', '', 0)
        assert ' 0 343 6 6 0 ' in loss and ' 4 0 -1 347 ' in loss, loss
        treasure = re.search(r' 381 (\d+) 0(?:\s|$)', loss)
        assert treasure, loss
        state = db._conn.execute(
            'SELECT floor,stars FROM local_ninja_trial WHERE conta_id=?',
            (account,)).fetchone()
        assert tuple(state) == (4, 6), state

        db._conn.execute('UPDATE local_resources SET gold=5000 WHERE conta_id=?',(account,))
        treasure_id=treasure.group(1)
        buy_req='\r\n'.join(['41','unparallel_purchase',uid,treasure_id])
        buy_first=server.despacha(buy_req)
        assert ' 381 %s 1 ' % treasure_id in buy_first, buy_first
        gold_after=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
        buy_replay=server.despacha(buy_req)
        assert buy_replay.startswith('41 unparallel_purchase 0'), buy_replay
        assert db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]==gold_after

        # Verify the VIP sweep and its original buff/chest purchase sequence
        # on a second temporary account with an eligible level and VIP.
        sweep_account=db.criar_conta('ninjatrialsweep','Temporary123!')['id']
        sweep_uid=str(db.perfil(sweep_account)['user_id'])
        import vip_local
        vip_local.set_grade(db,sweep_account,10)
        db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,40,0)',(sweep_account,))
        db._conn.execute('UPDATE local_campaign SET grade=40 WHERE conta_id=?',(sweep_account,))
        db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id,gold) VALUES (?,50000)',(sweep_account,))
        server._sessao_conexao['token']=db.abrir_sessao(sweep_account)
        sweep_init=server.despacha('\r\n'.join(['60','three_kingdoms_init',sweep_uid]))
        assert '12558' in sweep_init, sweep_init
        vip=10
        import dados_batalha as trial_data
        consume=trial_data.tabela('base_consume.txt')['66']
        # SmTrialTowerSweep.lua advances from the configured last-cleared
        # floor to jumpFloor by adding one.
        jump=int(consume[min(3+vip,len(consume)-1)])+1
        play=ninja_trial_local
        levels=['!']
        intervals=play._cfg(23).split('!')
        interval=next(x.split('|') for x in intervals if int(x.split('|')[0].split(',')[1])>=40)
        base=list(map(int,interval[1].split(',')));tolerance=list(map(int,interval[2].split(',')))
        multiplier=1.0
        for rule in play._cfg(32).split('|'):
            req,percent=map(int,rule.split(','))
            if vip>=req:multiplier=1+percent/100
        battles=sum(1 for i in range(1,jump) if trial_data.tabela('three_kingdoms_config.txt')[str(i)][2]!='-1')
        expected_score=sum(__import__('math').floor((base[2]+tolerance[2]*i)*multiplier*2.5) for i in range(battles))
        sweep_payload=['0',str(battles*15),str(expected_score),str(jump),'0','','0']
        sweep_req='\r\n'.join(['61','three_kingdoms_sweep',sweep_uid]+sweep_payload)
        sweep_reply=server.despacha(sweep_req)
        assert 'three_kingdoms_sweep 0 343' in sweep_reply, sweep_reply
        sweep_state=db._conn.execute('SELECT floor,stars,score,vip_sweep FROM local_ninja_trial WHERE conta_id=?',(sweep_account,)).fetchone()
        assert tuple(sweep_state)==(jump-1,battles*15,expected_score,1), tuple(sweep_state)
        duplicate_sweep=server.despacha('\r\n'.join(['62','three_kingdoms_sweep',sweep_uid]+sweep_payload))
        assert ' -1 varredura_vip_trial_ja_usada_hoje' in duplicate_sweep, duplicate_sweep
        # Update sweep-buff selection and buy one batch of each configured
        # floor chest; retrying the identical sequence cannot charge twice.
        buff_floor=2
        sweep_buff=server.despacha('\r\n'.join(['63','three_kingdoms_sweep',sweep_uid,'2',str(battles*15),'0',str(buff_floor),'1:-1','100001:500,0,100','0']))
        assert 'three_kingdoms_sweep 0 343' in sweep_buff, sweep_buff
        db._conn.execute('UPDATE local_resources SET gold=50000 WHERE conta_id=?',(sweep_account,))
        bulk='\r\n'.join(['64','three_kingdoms_sweep',sweep_uid,'4','0','0','0','0','','1',''])
        bulk_first=server.despacha(bulk)
        assert ' 171 37 ' in bulk_first, bulk_first
        paid_gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(sweep_account,)).fetchone()[0]
        bulk_repeat=server.despacha(bulk)
        assert bulk_repeat.startswith('64 three_kingdoms_sweep 0'), bulk_repeat
        assert db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(sweep_account,)).fetchone()[0]==paid_gold

        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
        print('NINJA_TRIAL_PASSED fights, buffs, chests, score/rank, shops, VIP skip/sweep and repeat-charge checks')
    finally:
        db.fechar()
