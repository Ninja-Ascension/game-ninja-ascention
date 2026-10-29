"""Original prop_sell sales: inventory, silver payout, validation and replay."""
import os
import sys
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port' / 'server'))
os.environ['NR_ENABLE_TUTORIAL'] = '0'

with tempfile.TemporaryDirectory(prefix='prop-sales-', dir=root / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import dados_batalha as data
    import shop_local

    db = server.BANCO
    try:
        account = db.criar_conta('propselltest', 'Temporary123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(account)
        uid = str(db.perfil(account)['user_id'])

        def request(*pairs, sequence='31', user_id=None):
            values = [str(x) for pair in pairs for x in pair]
            return server.despacha('\r\n'.join(
                [sequence, 'prop_sell', user_id or uid] + values))

        def quantity(mould):
            row = db._conn.execute(
                'SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',
                (account, mould)).fetchone()
            return int(row[0]) if row else 0

        def silver():
            row = db._conn.execute(
                'SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
            return int(row[0]) if row else 0

        prices = data.tabela('prop_mould.txt')
        assert int(prices['224'][3]) == 500 and int(prices['225'][3]) == 1000
        with db._conn:
            shop_local.grant(db, account, 6, 224, 7)
            shop_local.grant(db, account, 6, 225, 2)
            shop_local.grant(db, account, 6, 226, 1)
            shop_local.grant(db, account, 6, 2001, 1)  # silver_price=0

        id224 = account * 1000000 + 224
        id225 = account * 1000000 + 225
        id226 = account * 1000000 + 226
        id2001 = account * 1000000 + 2001

        single = request((id224, 3))
        assert single.startswith('31 prop_sell 0 27 1500 1500 37 '), single
        assert single.endswith(f'37 {id224} 4'), single
        assert quantity(224) == 4 and silver() == 1500

        batch = request((id224, 4), (id225, 2), sequence='32')
        assert batch.startswith('32 prop_sell 0 27 4000 5500 '), batch
        assert f'37 {id224} 0' in batch and batch.endswith(f'37 {id225} 0'), batch
        assert quantity(224) == 0 and quantity(225) == 0 and silver() == 5500

        # The same full-stack request cannot pay a second time after removal.
        repeated = request((id224, 4), (id225, 2), sequence='33')
        assert ' -1 item_nao_encontrado_na_bag' in repeated, repeated
        assert silver() == 5500

        # Invalid later entries reject the whole batch without partial mutation.
        invalid_batch = request((id226, 1), (id2001, 1), sequence='34')
        assert ' -1 item_nao_pode_ser_vendido' in invalid_batch, invalid_batch
        assert quantity(226) == 1 and quantity(2001) == 1 and silver() == 5500

        too_many = request((id226, 2), sequence='35')
        assert ' -1 quantidade_maior_que_o_inventario' in too_many, too_many
        assert quantity(226) == 1 and silver() == 5500
        duplicate = request((id226, 1), (id226, 1), sequence='36')
        assert ' -1 item_repetido_na_venda' in duplicate, duplicate
        assert quantity(226) == 1 and silver() == 5500
        assert ' -1 perfil_invalido' in request((id226, 1), sequence='37', user_id='-1')
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
        print('PROP_SELL_PASSED single, batch/shop sale, original silver prices, zero-price rejection, atomic validation and repeat protection')
    finally:
        db.fechar()
