"""Compara a resposta de union_init com os 14 campos de parse_union_init.

parse_union_init (ProtocolParserCopy.lua:7988-8008), ramo Naruto, le nesta
ordem: union_id, union_grade, union_icon, union_kuang, union_name, bulletin,
watchword, members, union_contribution, union_worship, union_duplicate_chapte,
union_member_num, approval_status, union_rank.
"""
import sys

sys.path.insert(0, 'N:/port/server')
import local_server as srv  # noqa: E402

ESPERADO = [
    'union_id', 'union_grade', 'union_icon', 'union_kuang', 'union_name',
    'bulletin', 'watchword', 'members', 'union_contribution', 'union_worship',
    'union_duplicate_chapte', 'union_member_num', 'approval_status',
    'union_rank',
]
NUMEROS = {
    'union_id', 'union_grade', 'union_icon', 'union_kuang', 'members',
    'union_contribution', 'union_worship', 'union_duplicate_chapte',
    'union_member_num', 'approval_status', 'union_rank',
}

resposta = srv.despacha('1\r\nunion_init\r\n')
tokens = resposta.split()

print('envelope:', tokens[:4])
campos = tokens[4:]
print('campos   :', len(campos), '(esperado %d)' % len(ESPERADO))
print()

falhas = []
if tokens[1] != 'union_init':
    falhas.append('nome do comando')
if tokens[2] != '0':
    falhas.append('status != 0')
if tokens[3] != '1001':
    falhas.append('parser != 1001')
if len(campos) != len(ESPERADO):
    falhas.append('quantidade de campos')

for posicao, (nome, valor) in enumerate(zip(ESPERADO, campos), start=1):
    situacao = ''
    if valor == '':
        falhas.append('%s vazio (desloca indices)' % nome)
        situacao = ' <-- VAZIO'
    elif nome in NUMEROS:
        try:
            float(valor)
        except ValueError:
            falhas.append('%s nao numerico (%r)' % (nome, valor))
            situacao = ' <-- NAO NUMERICO'
    if nome == 'union_grade':
        situacao += '  <-- destrava o cadeado'
    print('  %2d %-24s %r%s' % (posicao, nome, valor, situacao))

print()
if falhas:
    print('FALHOU:', '; '.join(falhas))
    sys.exit(1)
print('OK: 14 campos na ordem do parser, nenhum vazio, numeros validos')
