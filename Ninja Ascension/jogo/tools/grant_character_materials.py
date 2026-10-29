"""Auditable, idempotent material top-up; dry run unless --apply is specified."""
import argparse,csv,datetime,re,sqlite3,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'port/server'))
import dados_batalha as data
from contas import Banco

def select_materials(db,account):
    props=data.tabela('prop_mould.txt');words={r[1]:r[2] for r in data.tabela('word_mould.txt').values()}
    def text(key):return words.get(str(key),'')
    selected={}
    def add(ident,reason):
        if str(ident) in props:selected.setdefault(int(ident),set()).add(reason)
    for row in data.tabela('ship_grow_requirement.txt').values():
        for column in (2,4,6,8,10):
            if column<len(row) and int(row[column])>0:add(row[column],'ship_grow_requirement')
    for row in data.tabela('awaken_requirement.txt').values():
        if int(row[8])>0:add(row[8],'awaken_requirement')
    for row in data.tabela('ship_spirit_group.txt').values():
        for entry in row[4].split('|'):
            pieces=entry.split(',')
            if len(pieces)>1 and pieces[0]=='6':add(pieces[1],'ship_spirit_group')
    owned={13,35,50}
    for row in db._conn.execute('SELECT mould FROM local_synthesized WHERE conta_id=?',(account,)):owned.add(row[0])
    for row in db._conn.execute('SELECT mould FROM tutorial_recruit WHERE conta_id=?',(account,)):owned.add(row[0])
    strong=re.compile(r'\b(enhance|enhancement|advance|advancement|awakening|awaken|exp|experience|training|potential|breakthrough|refining|refine|talent|chakra|skill|cultivation|promotion|soul stone|soul crystal|ninja essence)\b',re.I)
    excluded=re.compile(r'\b(chest|box|pack|bag|ticket|key|voucher|gift|giftpack|fukubukuro|avatar|frame|recruit|summon|rename)\b',re.I)
    for ident,row in props.items():
        name=text(row[1]);description=text(row[2])
        if int(row[8])==3:add(ident,'character_exp_item')
        fragment=len(row)>42 and row[42]=='1'
        if fragment and int(row[39]) in owned:add(ident,'owned_character_fragment')
        if not fragment and len(name)<80 and not excluded.search(name):
            if strong.search(name):add(ident,'material_name')
            if re.search(r'(ninja|cursed seal|tailed beast|spirit beast)',description,re.I) and re.search(r'(upgrade|enhance|advance|awaken|train|develop|EXP)',description,re.I):add(ident,'material_description')
            if re.search(r'(cursed seal|six path force|mind.awake|shaman contract)',name,re.I):add(ident,'character_special_material')
        if not fragment and 'universal' in name.lower() and ('fragment' in name.lower() or 'debris' in name.lower()):add(ident,'universal_fragment')
    return [{'id':ident,'name':text(props[str(ident)][1]),'description':text(props[str(ident)][2]),'source':';'.join(sorted(reasons))} for ident,reasons in sorted(selected.items())]

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--account',required=True,type=int);parser.add_argument('--quantity',type=int,default=10000);parser.add_argument('--apply',action='store_true')
    args=parser.parse_args()
    if not 1<=args.quantity<=1000000:raise ValueError('Invalid quantity')
    db=Banco(str(ROOT/'port/dados/contas.sqlite3'))
    try:
        profile=db._conn.execute('SELECT user_name FROM perfis WHERE conta_id=?',(args.account,)).fetchone()
        if not profile:raise ValueError('Account not found')
        materials=select_materials(db,args.account)
        report=ROOT/'build'/'character-materials-grant.csv'
        with report.open('w',encoding='utf-8-sig',newline='') as f:
            writer=csv.DictWriter(f,fieldnames=['id','name','description','source']);writer.writeheader();writer.writerows(materials)
        if args.apply:
            protected={table:[tuple(r) for r in db._conn.execute('SELECT * FROM '+table+' WHERE conta_id=?',(args.account,))] for table in ('perfis','local_campaign','local_resources','local_formation_slots','local_synthesized')}
            backup=ROOT/'build'/('contas-before-character-materials-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S')+'.sqlite3')
            destination=sqlite3.connect(str(backup));db._conn.backup(destination);destination.close()
            before={row[0]:row[1] for row in db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=?',(args.account,))}
            with db._conn:
                for item in materials:
                    db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=MAX(quantity,excluded.quantity)',(args.account,item['id'],args.account*1000000+item['id'],args.quantity))
            for item in materials:
                saved=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(args.account,item['id'])).fetchone()[0]
                assert saved==max(args.quantity,before.get(item['id'],0))
            assert db._conn.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
            for table,rows in protected.items():
                assert [tuple(r) for r in db._conn.execute('SELECT * FROM '+table+' WHERE conta_id=?',(args.account,))]==rows,'Unexpected change: '+table
            print('APPLIED backup='+backup.name)
        print('account=%s name=%s item_types=%s quantity_minimum=%s report=%s'%(args.account,profile[0],len(materials),args.quantity,report))
        for item in materials[:35]:print(('%s: %s [%s]'%(item['id'],item['name'],item['source'])).encode('ascii','backslashreplace').decode())
    finally:db.fechar()

if __name__=='__main__':main()
