"""Depuração: por que fields[8] não chega ao token?"""
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


for qualidade in (0, 1):
    seq = recruitment_local.one_ship_tokens(BancoFalso(qualidade), 52, (5200013, 13))
    fim = seq.index('14104')
    print('qualidade=%s  len=%d  seq[8]=%r  seq[9]=%r  metadata[2:4]=%r'
          % (qualidade, fim, seq[8], seq[9], seq[fim + 1:fim + 5]))
