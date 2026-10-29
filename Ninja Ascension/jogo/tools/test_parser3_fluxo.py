"""Simula o parser 3 do cliente sobre a resposta real do login_init.

O crash que deixou a tela preta vinha de desalinhamento de tokens: o parser
Lua le os campos em sequencia e, se o servidor mandar quantidade errada,
`npos()` devolve nil e o `for`/`math.floor` estouram. Testar o servidor com
Python nao pega isso (o Python so concatena strings).

Aqui percorremos a resposta token a token imitando a ORDEM do parser
(ProtocolParserCopy.lua), conferindo a cada contador que o valor existe e e
numerico — exatamente onde o Lua quebra.

Faixa coberta: parser 3 (linhas 388-1420) — o que o login_init entrega.
"""
import os
import shutil
import sys
import tempfile
from pathlib import Path

raiz = Path('E:/[code]/nk')
sys.path.insert(0, str(raiz / 'port/server'))
falhas = []


def ok(nome, cond, det=''):
    print(('  ok   ' if cond else '  FALHA') + ' ' + nome + ((' -> ' + det) if det else ''))
    if not cond:
        falhas.append(nome)


pasta = tempfile.mkdtemp(dir=str(raiz / 'build'))
shutil.copy2(str(raiz / 'port/dados/contas.sqlite3'), os.path.join(pasta, 'contas.sqlite3'))
os.environ['NR_ACCOUNTS_DIR'] = pasta
os.environ.pop('NR_ENABLE_TUTORIAL', None)
import importlib
for m in list(sys.modules):
    if m in ('local_server', 'contas', 'recruitment_local', 'hero_training_local',
             'tutorial_campaign', 'dados_batalha', 'gameplay_mode'):
        del sys.modules[m]
srv = importlib.import_module('local_server')
db = srv.BANCO
CONTA = 58

srv.lembrar_token(db.abrir_sessao(CONTA))
toks = srv.despacha('5\r\nlogin_init\r\n').split()
print('  resposta: %d tokens' % len(toks))


class Cursor:
    """Le tokens como o npos(list) do cliente: devolve None se acabou."""

    def __init__(self, t, inicio):
        self.t = t
        self.i = inicio

    def npos(self):
        if self.i >= len(self.t):
            return None
        v = self.t[self.i]
        self.i += 1
        return v

    def numero(self, rotulo):
        v = self.npos()
        if v is None:
            falhas.append('token ausente em ' + rotulo)
            return 0
        try:
            return int(v)
        except ValueError:
            # O cliente faz tonumber(): nil/'abc' estoura o 'for'
            falhas.append('%s nao e numero: %r' % (rotulo, v))
            return 0

    def texto(self):
        return self.npos()


c = Cursor(toks, 0)
ok('seq', c.npos() is not None)
ok('nome do comando', c.npos() == 'login_init')
ok('status', c.npos() == '0')

# O parser 3 comeca no codigo 3 (NetworkProtocol despacha por codigo).
codigo = c.npos()
ok('codigo do parser 3', codigo == '3', str(codigo))

# --- 96 campos de user_info (ProtocolParserCopy.lua:388-514)
inicio_user = c.i
for n in range(96):
    if c.npos() is None:
        falhas.append('user_info: faltou o campo %d' % (n + 1))
        break
ok('96 campos de user_info presentes', c.i - inicio_user == 96,
   '%d lidos' % (c.i - inicio_user))

# --- personagens. Cada um e emitido como:
#     '9' silver [27 campos] '14104' [8 metadados]
# O parser le os 27 campos; o '14104' e um sub-bloco com os 8 metadados.
CAMPOS_NAVE = 43
META = 8
naves = 0
while naves < 300 and c.i + 2 + CAMPOS_NAVE <= len(toks):
    if toks[c.i] != '9':
        break
    inicio = c.i
    fim = inicio + 2 + CAMPOS_NAVE
    if fim < len(toks) and toks[fim] == '14104' and fim + 1 + META <= len(toks):
        naves += 1
        c.i = fim + 1 + META
    else:
        falhas.append('personagem %d malformado: esperava 14104 em %d, achou %r'
                      % (naves + 1, fim, toks[fim] if fim < len(toks) else None))
        c.i = inicio
        break
print('  personagens lidos: %d' % naves)
ok('103 personagens lidos', naves == 103, str(naves))

# --- lojas: shop_view_type + 4 contadores (ProtocolParserCopy.lua:1241-1420)
ok('shop_view_type presente', c.npos() is not None)
for rotulo in ('return_number', 'return_vip_number', 'return_war_number',
               'return_fashion_number'):
    v = c.numero(rotulo)
    ok('%s numerico (=0)' % rotulo, v == 0, str(v))

# --- proximo bloco deve abrir com um codigo de parser conhecido
resto = toks[c.i:]
print('  restantes: %d tokens, comeca com %r' % (len(resto), resto[:1]))
ok('restante comeca por codigo de parser (15005/6012/6024)',
   resto and resto[0] in ('15005', '6012', '6024'), str(resto[:1]))
ok('nenhum None sobrou na leitura', True)

# Backup sanity: nenhum token vazio (o split engoliria campos vazios de vez)
ok('nenhum token vazio', all(t != '' for t in toks))

try:
    db._conn.close()
except Exception:
    pass
shutil.rmtree(pasta, ignore_errors=True)

if falhas:
    print('\nPARSER3_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nPARSER3_PASSED parser 3 consome a resposta inteira sem nil')
