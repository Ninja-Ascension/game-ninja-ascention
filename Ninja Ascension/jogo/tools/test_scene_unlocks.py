import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='scene-unlocks-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import tutorial_campaign as campaign
    import dados_batalha as data
    db=server.BANCO
    try:
        account=db.criar_conta('unlock_test','Temporary123!')['id']
        def states():return list(map(int,campaign.scene_tokens(db,account)[1].split(',')))
        before=states();assert len(before)==500 and before[0]==0 and before[1]==-1 and before[50]==-1
        def complete(scene):
            for group in data.tabela('pve_scene.txt')[str(scene)][12].split(','):
                alternatives=[npc for npc in group.split(':') if npc.isdigit()]
                if alternatives:db._conn.execute('INSERT OR IGNORE INTO local_pve_clears VALUES (?,?,?,3)',(account,scene,int(alternatives[0])))
            db._conn.commit()
        complete(1);after=states()
        assert after[0]==3 and after[1]==0 and after[50]==0 and after[2]==-1
        complete(2);assert states()[2]==0
        assert states()[150]==-1,'Level 15 map unlocked below its requirement'
        db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,15,0)',(account,));db._conn.commit()
        assert states()[150]==0
        complete(51);assert states()[100]==0
        db._conn.execute('UPDATE local_campaign SET grade=1 WHERE conta_id=?',(account,));db._conn.commit()
        assert states()[50]>=0,'Existing victory was hidden'
        db._conn.execute('UPDATE local_campaign SET grade=37 WHERE conta_id=?',(account,));db._conn.commit()
        assert states()[152]==0,'Illusion Challenge must unlock at its configured level'
        db._conn.execute('INSERT OR IGNORE INTO local_pve_clears VALUES (?,?,?,3)',(account,153,1387));db._conn.commit()
        assert states()[152]==1,'One difficulty variant should clear one Illusion Challenge stage'
        complete(153);assert states()[152]==6,'All six alternative NPC groups should clear the challenge'
        catalog=[dict(id=int(key),name=row[2],level=int(row[4]),type=int(row[5]),previous=row[16],npcs=row[12])
                 for key,row in data.tabela('pve_scene.txt').items() if key.isdigit()]
        (root/'build/scene-catalog.json').write_text(json.dumps(catalog,ensure_ascii=False,indent=2),encoding='utf8')
    finally:db.fechar()
print('SCENE_UNLOCKS_PASSED 500 definitions, correct previous chapter, normal/elite/nightmare, level gates, persisted wins')
