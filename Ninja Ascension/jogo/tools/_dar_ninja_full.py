"""GM: give a ninja to an account maxed like RenegadoBR's Rinne Sharingan
(account 62, ship 1006200382): level, stars, quality, skills, seals, weapons,
weapon awakening/refine, 18 red mudras and Eight Gates progress.
Usage (from jogo/port): python ../tools/_dar_ninja_full.py <mould> <formation pos> [account]
Backs the database up first (SQLite backup API)."""
import sqlite3, time, sys
sys.path.insert(0, 'server')
import dados_batalha as d

mould = int(sys.argv[1]); pos = int(sys.argv[2]); acc = int(sys.argv[3]) if len(sys.argv) > 3 else 62
s = sqlite3.connect('dados/contas.sqlite3')
b = sqlite3.connect('dados/contas-backup-antes-full-%d-conta%d-' % (mould, acc) + time.strftime('%Y%m%d-%H%M%S') + '.sqlite3')
s.backup(b); b.close()
src, src_acc = 1006200382, 62
dst = 1000000000 + acc * 100000 + mould
s.execute('DELETE FROM local_hidden_ships WHERE conta_id=? AND mould=?', (acc, mould)) if s.execute("SELECT 1 FROM sqlite_master WHERE name='local_hidden_ships'").fetchone() else None
if not s.execute('SELECT 1 FROM local_synthesized WHERE conta_id=? AND mould=?', (acc, mould)).fetchone():
    s.execute('INSERT INTO local_synthesized VALUES (?,?,?)', (acc, mould, dst))
else:
    dst = s.execute('SELECT ship_id FROM local_synthesized WHERE conta_id=? AND mould=?', (acc, mould)).fetchone()[0]
for t in ('local_hero_development', 'local_hero_quality', 'local_ship_rank', 'local_hero_exp', 'local_equipment_level', 'local_equipment_harden', 'local_hero_gates'):
    s.execute(f'DELETE FROM {t} WHERE conta_id=? AND ship_id=?', (acc, dst))
    for r in s.execute(f'SELECT * FROM {t} WHERE conta_id=? AND ship_id=?', (src_acc, src)).fetchall():
        r = list(r); r[0] = acc; r[1] = dst
        s.execute(f'INSERT INTO {t} VALUES ({",".join("?" * len(r))})', r)
s.execute('DELETE FROM local_equipment_awaken WHERE conta_id=? AND ship_id=?', (acc, dst))
em = d.tabela('equipment_mould.txt')
for slot, tpl in enumerate(d.tabela('ship_mould.txt')[str(mould)][72].split(','), 1):
    for _ in range(5):
        if tpl in em and int(em[tpl][42]) > 0 and em[tpl][42] in em:
            tpl = em[tpl][42]
    s.execute('INSERT INTO local_equipment_awaken VALUES (?,?,?,?,?)', (acc, dst, slot, 5, int(tpl)))
s.execute('DELETE FROM local_metal_slots WHERE conta_id=? AND ship=?', (acc, dst))
for idx, p, metal in s.execute('SELECT idx,pos,metal FROM local_metal_slots WHERE conta_id=? AND ship=?', (src_acc, src)).fetchall():
    m = s.execute('SELECT mould FROM local_metals WHERE id=?', (metal,)).fetchone()[0]
    nid = s.execute('INSERT INTO local_metals(conta_id,mould,rank,level) VALUES (?,?,11,120)', (acc, m)).lastrowid
    s.execute('INSERT INTO local_metal_slots VALUES (?,?,?,?,?)', (acc, dst, idx, p, nid))
s.execute('INSERT OR REPLACE INTO local_formation_slots VALUES (?,?,?)', (acc, pos, dst))
s.commit()
print(acc, mould, dst, s.execute('select * from local_formation_slots where conta_id=? order by position', (acc,)).fetchall())
