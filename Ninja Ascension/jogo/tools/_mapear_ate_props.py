"""Lista a sequencia EXATA de npos(list) do parser 3, com aninhamento.

Mostra quais leituras sao incondicionais e quais estao dentro de 'if'.
Assim da para saber quantos campos o parser consome antes de chegar em
user_prop_number (linha 388) para um perfil vazio.
"""
import io
import re
from pathlib import Path

p = Path('E:/[code]/nk/01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua')
linhas = io.open(p, encoding='utf8', errors='replace').read().splitlines()


def limpa(n):
    return re.sub(r'--.*$', '', linhas[n - 1])


pilha = []      # cada item: True se o ramo atual executa
pos = 0
i = 72
saida = []
while i <= 390:
    c = limpa(i).strip()
    if not c:
        i += 1
        continue
    if re.match(r'^function\b', c):
        i += 1
        continue
    if re.match(r'^if\b', c):
        # Junta as continuacoes ate 'then'
        texto, j = c, i
        while 'then' not in texto and j < i + 6:
            j += 1
            texto += ' ' + limpa(j).strip()
        cond = texto[3:].split(' then')[0]
        # Perfil vazio: assume os ramos de projeto Naruto como verdadeiros.
        verdade = ('__lua_project_naruto' in cond
                   or '__lua_project_l_naruto' in cond
                   or '__lua_project_id ==' in cond)
        pilha.append(verdade)
        i = j + 1
        continue
    if re.match(r'^elseif\b', c):
        if pilha:
            pilha[-1] = False
        i += 1
        continue
    if re.match(r'^else\b', c):
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
        saida.append((i, 'LACO: ' + c[:60], None))
        pilha.append(None)
        i += 1
        continue
    for m in re.finditer(r'(\w+)\s*=\s*(?:tonumber\()?npos\(list\)', c):
        ativo = all(x is True for x in pilha)
        if ativo:
            pos += 1
            if pos >= 78:
                saida.append((i, 'campo %d: %s' % (pos, m.group(1)), True))
        else:
            if pos >= 70:
                saida.append((i, '(condicional) %s' % m.group(1), False))
    i += 1

print('=== leituras a partir do campo 78 ===')
for linha, texto, ativo in saida:
    marca = ' ' if ativo else '~'
    print('%s linha %5d  %s' % (marca, linha, texto))
print()
print('total de campos incondicionais ate a linha 390:', pos)
