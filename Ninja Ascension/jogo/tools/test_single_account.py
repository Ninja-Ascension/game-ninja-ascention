from pathlib import Path
import sys,tempfile
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
from contas import Banco,ErroConta
# Explicit release lock: the live account is being preserved on purpose. The
# lock file lives next to the TEMPORARY database, never beside contas.sqlite3.
with tempfile.TemporaryDirectory(prefix='single-account-',dir=root/'build') as folder:
    path=str(Path(folder)/'test.sqlite3')
    db=Banco(path)
    (Path(folder)/'release.lock').write_text('test',encoding='utf8')
    first=db.criar_conta('old_test_a','Temporary123!')['id']
    db.criar_conta('old_test_b','Temporary123!')
    token=db.abrir_sessao(first)
    db.concluir_intro(first)
    try:
        db.resetar_para_conta_unica()
        raise AssertionError('Reset ran without the operator lock')
    except ErroConta as exc:
        assert exc.codigo=='conta_em_uso','unexpected refusal: '+exc.codigo
    assert db.total_contas()==2,'Refused reset still deleted accounts'
    assert db.resetar_para_conta_unica(liberar_conta_em_uso=True)==2
    for table in ('contas','sessoes','perfis','tutorial_progress'):
        assert db._conn.execute('SELECT COUNT(*) FROM '+table).fetchone()[0]==0
    account=db.criar_conta('only_account','Temporary123!')['id']
    try:db.criar_conta('second_account','Temporary123!');raise AssertionError('Second account allowed')
    except ErroConta as exc:assert exc.codigo=='conta_unica'
    assert db.autenticar('only_account','Temporary123!')['id']==account
    db.concluir_intro(account);db.fechar()
    db=Banco(path)
    assert db.experiencia_tutorial(account)==1
    try:db.criar_conta('third_account','Temporary123!');raise AssertionError('Constraint not persisted')
    except ErroConta as exc:assert exc.codigo=='conta_unica'
    assert db._conn.execute('PRAGMA foreign_key_check').fetchall()==[]
    db.fechar()
print('SINGLE_ACCOUNT_PASSED reset, sessions revoked, one account, login, persistent progress and DB constraint')
