"""Original premium ticket: spend once, 10x, free priority and atomic rollback."""
import os
from pathlib import Path
import sys
import tempfile

root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='recruit-ticket-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as s
    import legacy_recruit_local as recruit
    db=s.BANCO
    try:
        account=db.criar_conta('ticketcheck','Temporary123!')['id']
        s._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        s.resposta_login_init('1','')
        def setup(n,gold=0,free=0):
            with db._conn:
                db._conn.execute('INSERT OR REPLACE INTO local_inventory VALUES (?,239,?,?)',(account,account*1000000+239,n))
                db._conn.execute('UPDATE local_resources SET gold=? WHERE conta_id=?',(gold,account))
                db._conn.execute('INSERT OR REPLACE INTO local_legacy_recruit_state VALUES (?,?,0,0,?,0)',(account,recruit._day(),free))
        def req(count,key):
            return s.despacha('\r\n'.join(['7','ship_bounty' if count==1 else 'ship_batch_bounty',uid,'2',key]))
        def ticket():
            return db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=239',(account,)).fetchone()[0]
        def gold():
            return db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
        setup(11)
        output=root/'build/recruit-ticket';output.mkdir(exist_ok=True)
        (output/'login.txt').write_text(s.resposta_login_init('1',''),encoding='utf8')
        first=req(1,'ticket-one');assert first.startswith('7 ship_bounty 0 '),first
        (output/'single.txt').write_text(first,encoding='utf8')
        assert ticket()==10 and gold()==0 and ' 6024 ' in first
        assert req(1,'ticket-one')==first and ticket()==10
        ten=req(10,'ticket-ten');assert ten.startswith('7 ship_batch_bounty 0 '),ten
        assert ticket()==0 and gold()==0
        assert req(10,'ticket-ten')==ten and ticket()==0
        setup(9)
        assert req(10,'missing-tenth').split(' ')[2]=='-1'
        assert ticket()==9 and gold()==0
        setup(9,2280)
        assert req(10,'gold-fallback').split(' ')[2]=='0'
        assert ticket()==9 and gold()==0
        setup(2,free=1)
        assert req(1,'free-first').split(' ')[2]=='0'
        assert ticket()==2 and gold()==0
        setup(2)
        original=recruit._choose
        def fail(*args):raise ValueError('injected ticket failure')
        recruit._choose=fail
        assert req(1,'rollback-ticket').split(' ')[2]=='-1'
        assert ticket()==2 and gold()==0
        recruit._choose=original
        assert req(1,'rollback-ticket').split(' ')[2]=='0' and ticket()==1
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        print('RECRUIT_TICKET_PASSED single, ten, repeat, insufficient, gold fallback, free priority, rollback')
    finally:db.fechar()
