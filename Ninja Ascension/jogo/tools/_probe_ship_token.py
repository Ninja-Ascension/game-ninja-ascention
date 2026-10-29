"""Depuração: imprime o token real do Naruto com índices, para fixar o contrato."""
import sys
import threading
from pathlib import Path

raiz = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(raiz / 'port/server'))
import recruitment_local  # noqa: E402


class BancoFalso:
    class _Cursor:
        def __init__(self, row):
            self._row = row

        def fetchone(self):
            return self._row

    def __init__(self, qualidade):
        self._conn = self
        self._lock = threading.RLock()
        self.qualidade = qualidade

    def execute(self, sql, args):
        if 'tutorial_training' in sql:
            return self._Cursor(None if self.qualidade is None else (self.qualidade,))
        if 'local_campaign' in sql:
            return self._Cursor((5198,))
        raise AssertionError('consulta inesperada: %s' % sql)


seq = recruitment_local.one_ship_tokens(BancoFalso(0), 52, (5200013, 13))
indice = seq.index('14104')
print('campos antes de 14104: %d (14104 está na posição %d)' % (indice, indice))
for j, valor in enumerate(seq):
    if j <= indice + 6:
        print('  [%02d] %r' % (j, valor))
