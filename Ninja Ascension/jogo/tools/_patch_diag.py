"""Adiciona um log de diagnostico temporario no login_init.

Mostra os tokens nas posicoes que o cliente usa como user_equiment_number e
user_ship_number, medidos DEPOIS de a resposta ser montada (mesmo texto que
vai pelo HTTP).
"""
import io

P = 'E:/[code]/nk/port/server/local_server.py'
s = io.open(P, encoding='utf8').read()

alvo = '              + ["12042", str(velocidade)])'
if alvo not in s:
    raise SystemExit('alvo nao encontrado')

novo = (alvo + '\n'
        "    _diag = tokens.split() if isinstance(tokens, list) else str(tokens).split()\n"
        "    if len(_diag) > 93:\n"
        "        log('DIAG qtd=%d idx89=%r idx90=%r idx91=%r idx92=%r'\n"
        "            % (len(_diag), _diag[89], _diag[90], _diag[91], _diag[92]))")

s = s.replace(alvo, novo, 1)
io.open(P, 'w', encoding='utf8', newline='').write(s)
print('patch diagnostico aplicado')
