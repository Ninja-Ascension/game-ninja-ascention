"""Persist the player's display name and avatar using the original parsers."""
import html
import unicodedata
import dados_batalha as data

def wire_name(name):
    return name.replace('&','&amp;').replace(' ','&nbsp;')

def basic_heads():
    # user_config 15: default avatar plus extra avatars available from start.
    from pathlib import Path
    path=Path(data.MOULD).parent/'configs'/'user_config.txt'
    for line in path.read_text(encoding='utf-8').splitlines():
        row=line.split('\t')
        if row[0]=='15':return [int(x) for x in row[3].split(',') if x.strip().isdigit()]
    raise ValueError('avatares_basicos_ausentes')

def allowed_heads(db,account):
    """Same rule as SmPlayerSystemSetChangeHead.lua:185-224: basic avatars plus
    the form of every evolution stage reached by an owned ninja (this port
    sends evolution stage 1 for every ninja)."""
    import recruitment_local as heroes
    heads=set(basic_heads())
    evo=data.tabela('ship_evo_mould.txt')
    for _,mould in heroes.all_owned(db,account):
        row=data.tabela('ship_mould.txt').get(str(mould))
        stages=row[71].split(',') if row and len(row)>71 else []
        if stages and stages[0] in evo:heads.add(int(evo[stages[0]][4]))
    return heads

def head(db,account):
    with db._lock:
        row=db._conn.execute('SELECT head FROM local_profile_head WHERE conta_id=?',(account,)).fetchone()
    return int(row[0]) if row else basic_heads()[0]

def install(server):
    db=server.BANCO
    with db._lock,db._conn:
        db._conn.execute('CREATE TABLE IF NOT EXISTS local_profile_edits (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE)')
        db._conn.execute('CREATE TABLE IF NOT EXISTS local_profile_head (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, head INTEGER NOT NULL)')
    def modify(seq,text):
        try:
            account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            fields=server._linhas(text)
            uid=str(db.perfil(account)['user_id'])
            if len(fields)!=3 or fields[0]!=uid:
                raise ValueError('alteracao_de_perfil_nao_suportada')
            if fields[1]=='1':
                # Avatar (SmPlayerSystemSetChangeHead.lua:105): the client sets
                # user_info.user_head itself on success; login_init sends it back.
                choice=int(fields[2]) if fields[2].isdigit() else -1
                if choice not in allowed_heads(db,account):
                    raise ValueError('avatar_nao_liberado')
                with db._lock,db._conn:
                    db._conn.execute('INSERT INTO local_profile_head VALUES (?,?) ON CONFLICT(conta_id) DO UPDATE SET head=excluded.head',(account,choice))
                server.log('PERFIL avatar conta=%s head=%s'%(account,choice))
                return ' '.join([str(seq),'user_info_modify','0'])
            if fields[1]!='0':
                raise ValueError('alteracao_de_perfil_nao_suportada')
            name=html.unescape(fields[2]).replace(' ',' ').strip()
            if not name or len(name)>20 or any(unicodedata.category(c).startswith('C') for c in name):
                raise ValueError('apelido_invalido')
            name=db.definir_apelido(account,name)
            with db._lock,db._conn:
                db._conn.execute('INSERT OR IGNORE INTO local_profile_edits VALUES (?)',(account,))
            return ' '.join([str(seq),'user_info_modify','0','12033',uid,wire_name(name)])
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('user_info_modify',seq,str(exc))
    server.MINIMOS['user_info_modify']=modify
