"""Prova, em banco temporário, o que o servidor envia para o Naruto (molde 13).

Chama o código REAL do servidor (recruitment_local.one_ship_tokens) e decodifica
o token resultante, em vez de recalcular colunas à parte — assim o teste não
pode passar por acidente se a implementação mudar.

Contrato que o cliente original exige:
  * Order (posição 9 do parser do user_ship) = initial_rank_level
  * StarRating (metadata[3])                 = ship_star
  * mission3 grupo 4 exige wjmp:13-1 (Order >= 1) para sair da fala 30402
"""
import sqlite3
import sys
from pathlib import Path

raiz = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(raiz / 'port/server'))
import dados_batalha as data  # noqa: E402
import recruitment_local  # noqa: E402

linha = data.tabela('ship_mould.txt')['13']
rank = int(float(linha[44]))   # initial_rank_level (col 45)
star = int(float(linha[48]))   # ship_star (col 49)
print('ship_mould[13] initial_rank_level=%d  ship_star=%d' % (rank, star))


class BancoFalso:
    """Banco mínimo em memória com as duas consultas usadas por one_ship_tokens."""

    class _Cursor:
        def __init__(self, row):
            self._row = row

        def fetchone(self):
            return self._row

    def __init__(self, qualidade):
        self._conn = self
        self._lock = __import__('threading').RLock()
        self.qualidade = qualidade

    def execute(self, sql, args):
        if 'tutorial_training' in sql:
            return self._Cursor(None if self.qualidade is None else (self.qualidade,))
        if 'local_campaign' in sql:
            return self._Cursor((5198,))
        raise AssertionError('consulta inesperada: %s' % sql)


def tokens(qualidade):
    return recruitment_local.one_ship_tokens(BancoFalso(qualidade), 52, (5200013, 13))


def decodificar(seq):
    """Lê Order/StarRating do bloco 14104, que é a fonte real no cliente.

    O parser do user_ship (ProtocolParserCopy.lua:613) zera StarRating e fixa
    evolution_status; os valores verdadeiros chegam pelo 14104
    (ProtocolParserCopyExx.lua:11831-11843):
      metadata = [ship_id, evolution_status, Order, StarRating, skillLevel, ...]
    """
    inicio = seq.index('14104')
    metadata = seq[inicio + 1:]
    ordem = metadata[2]
    estrela = metadata[3]
    return ordem, metadata[2], metadata[3]


falhas = []
for qualidade, esperado_rank, esperado_estrela in (
        (None, rank, star),          # conta sem registro de treino
        (0, rank, star),             # antes da primeira melhoria
        (1, max(rank, 1), max(star, 1)),  # melhoria concluída
):
    ordem, quality, estrela = decodificar(tokens(qualidade))
    estado = 'ok' if (int(ordem) == esperado_rank and int(estrela) == esperado_estrela) else 'FALHOU'
    if estado != 'ok':
        falhas.append('qualidade=%s -> Order=%s Star=%s (esperado %s/%s)'
                      % (qualidade, ordem, estrela, esperado_rank, esperado_estrela))
    print('tutorial_training.quality=%-4s -> Order=%-2s StarRating=%-2s  %s'
          % (qualidade, ordem, estrela, estado))

# O que o guia avalia: mission3 grupo 4 só avança com wjmp:13-1 (Order >= 1).
ordem_inicial, _, estrela_inicial = decodificar(tokens(0))
ordem_treinada, _, estrela_treinada = decodificar(tokens(1))
if int(ordem_inicial) >= 1:
    falhas.append('Order inicial deveria ser 0 (wjmp:13-1 ainda não satisfeito)')
if int(estrela_inicial) < 1:
    falhas.append('StarRating inicial %s: getHeroStars devolve 1 para rank 0' % estrela_inicial)
if int(ordem_treinada) < 1:
    falhas.append('após a melhoria, Order %s não satisfaz wjmp:13-1' % ordem_treinada)

if falhas:
    print('\nSHIP_RANK_FAILED')
    for motivo in falhas:
        print('  - ' + motivo)
    sys.exit(1)
print('\nSHIP_RANK_PASSED Order/StarRating seguem ship_mould e a melhoria satisfaz wjmp:13-1')
