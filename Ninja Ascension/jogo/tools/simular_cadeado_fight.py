"""Simula funOpenDrawTip para os botoes da tela FIGHT com os dados reais.

Reimplementa em Python a mesma decisao de EnvironmentDatas.lua:5202-5294,
usando os valores que o servidor local realmente envia. Assim sabemos, campo
por campo, qual condicao deixa o cadeado ligado.

Entrada da tabela: res/data/mould/fun_open_condition.txt (11 colunas).
"""
import io
import sys

sys.path.insert(0, 'N:/port/server')
import local_server as srv  # noqa: E402

TABELA = 'N:/01_conteudo_apk/assets/res/data/mould/fun_open_condition.txt'
ID_BLOCO = 3  # parser do login_init (bloco do perfil)

# ---------------------------------------------------------------- login real
token = srv.BANCO.abrir_sessao(61)
srv.lembrar_token(token)
resposta = srv.despacha('7\r\nlogin_init\r\n7\r\n\r\n')
tokens = resposta.split()

# O envelope real e: seq, cmd, status, '6020', '6020...', '3,product...', ...
# O bloco 6020 vem antes. Localizamos o parser 3 como TOKEN EXATO.
if tokens[3] == '6020' and len(tokens) > 5:
    inicio = 5  # tokens[4] e o produto do 6020; tokens[5] e o parser 3
    if tokens[inicio] != '3':
        inicio = tokens.index('3', 3)
else:
    inicio = tokens.index('3')

campos = tokens[inicio + 1:]
print('campos do bloco 3:', len(campos))

nivel = campos[18]
print('user_grade (campo 19 do bloco):', repr(nivel))

# ---------------------------------------------------------------- tabela
alvos = {}
for linha in io.open(TABELA, encoding='utf8', errors='replace').read().splitlines():
    p = linha.split('\t')
    if p and p[0].strip() in {'91', '92', '93', '94', '186', '187',
                              '188', '189', '190'}:
        alvos[p[0].strip()] = p

# ---------------------------------------------------------------- simulacao
def inteiro(texto, padrao=0):
    try:
        return int(float(texto))
    except (TypeError, ValueError):
        return padrao

nivel_utilizador = inteiro(nivel, None)
print('nivel interpretado:', nivel_utilizador)
print()

botoes = [('1', '91'), ('2', '92'), ('3', '93'), ('4', '94'), ('5', '186'),
          ('6', '187'), ('7', '188'), ('8', '189'), ('9', '190')]

print('%-7s %-6s %-8s %-9s %-8s %s' % ('BOTAO', 'ID', 'LEVEL', 'OPEN_DAY',
                                       'VIP', 'VEREDITO'))
for rotulo, ident in botoes:
    p = alvos.get(ident)
    if p is None:
        print('%-7s %-6s %s' % (rotulo, ident, 'ID AUSENTE -> TRANCADO'))
        continue
    level = inteiro(p[3])
    vip = inteiro(p[4])
    open_day = inteiro(p[9], -1)

    motivos = []
    if nivel_utilizador is None:
        motivos.append('user_grade nao numerico')
    elif level > nivel_utilizador:
        motivos.append('nivel %d > %d' % (level, nivel_utilizador))
    if vip > 0:
        motivos.append('exige VIP %d' % vip)
    if open_day > 1:
        motivos.append('exige %d dias de servidor' % open_day)

    veredito = 'TRANCADO' if motivos else 'LIBERADO'
    print('%-7s %-6s %-8d %-9d %-8d %s %s' % (
        rotulo, ident, level, open_day, vip, veredito,
        ('(' + '; '.join(motivos) + ')') if motivos else ''))
