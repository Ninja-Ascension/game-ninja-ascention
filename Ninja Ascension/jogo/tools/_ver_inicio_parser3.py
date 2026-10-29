"""Mostra os primeiros 30 campos do bloco do parser 3 do login_init.

Objetivo: achar onde o indice desloca. O campo 19 deveria ser user_grade (110),
mas chega '0,0,0,0,0,0,0' e o 110 aparece na posicao 26.
"""
import sys

sys.path.insert(0, 'N:/port/server')
import local_server as srv  # noqa: E402

token = srv.BANCO.abrir_sessao(61)
srv.lembrar_token(token)

resposta = srv.despacha('7\r\nlogin_init\r\n7\r\n\r\n')
tokens = resposta.split()

# Localiza o parser 3 no envelope.
try:
    inicio_parser = tokens.index('3')
except ValueError:
    raise SystemExit('parser 3 nao encontrado no envelope')

print('envelope ate o parser 3:', tokens[:inicio_parser + 1])
campos = tokens[inicio_parser + 1:]
print('total de campos do parser 3:', len(campos))
print()
for posicao in range(30):
    valor = campos[posicao] if posicao < len(campos) else '<fora>'
    if len(str(valor)) > 60:
        valor = str(valor)[:60] + '...'
    marca = '  <== nivel 110' if str(valor) == '110' else ''
    print('  [%2d] %r%s' % (posicao, valor, marca))
