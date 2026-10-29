"""Throwaway probe: locate which contas.py call blocks test_single_account."""
import sys
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]


def trace(frame, event, arg):
    if event == 'call' and 'contas.py' in frame.f_code.co_filename:
        print('CALL', frame.f_code.co_name, flush=True)
    return None


sys.settrace(trace)
sys.path.insert(0, str(root / 'port/server'))
from contas import Banco  # noqa: E402

print('imported', flush=True)
with tempfile.TemporaryDirectory(prefix='probe-', dir=root / 'build') as folder:
    db = Banco(str(Path(folder) / 't.sqlite3'))
    print('banco ok', flush=True)
    a = db.criar_conta('old_test_a', 'Temporary123!')['id']
    print('criar 1 ok', flush=True)
    db.criar_conta('old_test_b', 'Temporary123!')
    print('criar 2 ok', flush=True)
    db.abrir_sessao(a)
    print('sessao ok', flush=True)
    db.concluir_intro(a)
    print('intro ok', flush=True)
print('done', flush=True)
