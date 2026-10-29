"""Le o login_init com sessao valida e mostra o nivel usado no cadeado FIGHT.

Precisa de sessao porque resposta_login_init recusa sem ela. Abrimos a sessao
da conta 61 direto no banco, como os testes do projeto fazem.
"""
import re
import sys

sys.path.insert(0, 'N:/port/server')

import contas  # noqa: E402
import local_server as srv  # noqa: E402

CONTA = 61

banco = srv.BANCO
token = banco.abrir_sessao(CONTA)
srv.lembrar_token(token)

resposta = srv.despacha('7\r\nlogin_init\r\n7\r\n\r\n')
tokens = resposta.split()
print('status do envelope:', tokens[2] if len(tokens) > 2 else '?')
print('total de tokens  :', len(tokens))

campos = tokens[4:]
print()

# O parser parse_login_init consome o bloco 3; localizamos o inicio real
# pelos valores conhecidos para nao depender de indice fixo.
indice_grade = None
for posicao, valor in enumerate(campos):
    if valor == '110':
        indice_grade = posicao
        break

rotulos = {
    18: 'user_grade (campo 19)',
    28: 'user_experience (campo 29)',
    37: 'capture_name (campo 38)',
    41: 'capture_vip_grade (campo 42)',
}
for posicao in sorted(rotulos):
    valor = campos[posicao] if posicao < len(campos) else '<fora>'
    print('  [%2d] %-28s %r' % (posicao, rotulos[posicao], valor))

nivel_texto = campos[18] if len(campos) > 18 else None
print()
print('nivel no campo 19:', repr(nivel_texto))
print('onde "110" aparece:', indice_grade)

try:
    nivel = int(float(nivel_texto))
except (TypeError, ValueError):
    nivel = None

if nivel is None:
    print('NIVEL NAO NUMERICO -> o cadeado nao pode ser liberado por nivel')
else:
    print('nivel numerico    :', nivel)
    for botao, exigido in [('1', 18), ('2', 24), ('3', 32), ('5', 38),
                           ('6', 32), ('7', 25), ('8', 45), ('9', 40)]:
        estado = 'LIBERADO' if nivel >= exigido else 'TRANCADO'
        print('  botao %s exige %-3d -> %s' % (botao, exigido, estado))
