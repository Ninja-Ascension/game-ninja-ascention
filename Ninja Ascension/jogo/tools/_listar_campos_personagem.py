"""Lista, em ASCII, os campos 28-60 que o parser 3 le por personagem no ramo
do Naruto, para comparar com o que one_ship_tokens emite hoje.
"""
import io
import re

P = r'N:/01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
ls = io.open(P, encoding='utf8', errors='replace').read().splitlines()


def limpa(n):
    linha = ls[n - 1]
    i = linha.find('--')
    if i >= 0:
        linha = linha[:i]
    return linha.strip()


pilha = []
i = 570
k = 0
while i <= 795:
    c = limpa(i)
    if not c:
        i += 1
        continue
    if re.match(r'^if\b', c):
        texto, j = c, i
        while 'then' not in texto and j < i + 8:
            j += 1
            texto += ' ' + limpa(j)
        cond = texto[3:].split(' then')[0]
        outro = ('__lua_project_id ==' in cond and 'naruto' not in cond
                 and 'adventure' in cond)
        pilha.append(not outro)
        i = j + 1
        continue
    if re.match(r'^elseif\b', c) or re.match(r'^else\b', c):
        if pilha:
            pilha[-1] = False
        i += 1
        continue
    if re.match(r'^end\b', c):
        if pilha:
            pilha.pop()
        i += 1
        continue
    if re.match(r'^for\b', c) or re.match(r'^while\b', c):
        pilha.append(True)
        i += 1
        continue
    if all(pilha):
        for _ in re.findall(r'npos\(list\)', c):
            k += 1
            # Nome do campo: parte antes do '='
            nome = c.split('=')[0].strip().split('.')[-1]
            nome = re.sub(r'[^A-Za-z0-9_]', '', nome)
            print('%2d L%-4d %s' % (k, i, nome[:38]))
    i += 1
