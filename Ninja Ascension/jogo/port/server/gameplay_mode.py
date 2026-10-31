"""Per-profile tutorial mode, with explicit overrides only for isolated tests."""
import json,os
from pathlib import Path
CONFIG=json.loads((Path(__file__).resolve().parents[1]/'gameplay.json').read_text(encoding='utf8'))
def test_override():
    directory=os.environ.get('NR_ACCOUNTS_DIR')
    override=os.environ.get('NR_ENABLE_TUTORIAL')
    production=Path(__file__).resolve().parents[1]/'dados'
    if directory and Path(directory).resolve()!=production.resolve() and override is not None:
        return override=='1'
    return None

def tutorial_enabled(db=None, account=None):
    override=test_override()
    if override is not None:return override
    if db is None:
        import sys
        server=sys.modules.get('local_server') or sys.modules.get('__main__')
        if not server or not hasattr(server,'BANCO'):return False
        db=server.BANCO
        try:account=db.sessao_de(server._sessao_da_conexao())['conta_id']
        except (server._contas.ErroConta,AttributeError):return False
    if account is None:return False
    from initial_tutorial import state
    return state(db,account) in ('choice','playing')
STARTERS=tuple(CONFIG['starter_moulds'])
