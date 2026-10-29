"""Conta os campos que o parser 3 le por personagem, no ramo do Naruto.

Considera:
  - linhas comentadas (--) ignoradas, como faz o Lua
  - blocos 'if __lua_project_id == X then' que NAO incluem o Naruto sao
    pulados (ex.: 620-625 e do ramo adventure)

Imprime so ASCII para nao quebrar no console do Windows.
"""
import io
import re

P = r'N:/01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua'
ls = io.open(P, encoding='utf8', errors='replace').read().splitlines()

# Ramos que NAO rodam no projeto l_naruto (usado aqui).
ADVENTURE = 'adventure'


def limpa(n):
    """Remove comentario de linha; devolve '' se a linha for toda comentario."""
    linha = ls[n - 1]
    # Comentario de bloco --[[ ... ]] e tratado de forma conservadora:
    i = linha.find('--')
    if i >= 0:
        linha = linha[:i]
    return linha.strip()


def ascii_ok(s):
    return all(ord(ch) < 128 for ch in s)


campos = []
# Acompanha blocos 'if' para saber se o ramo roda no Naruto.
pilha = []      # cada item: True (roda), False (nao roda)
i = 570
dentro = False
while i <= 800:
    c = limpa(i)
    if not c:
        i += 1
        continue
    if re.match(r'^if\b', c):
        # Junta continuacoes ate 'then'
        texto, j = c, i
        while 'then' not in texto and j < i + 8:
            j += 1
            texto += ' ' + limpa(j)
        cond = texto[3:].split(' then')[0]
        # Roda se menciona naruto, OU se nao e exclusivo de outro projeto.
        exclusivo_outro = ('__lua_project_id ==' in cond
                           and 'naruto' not in cond
                           and 'adventure' in cond)
        pilha.append(not exclusivo_outro)
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
    ativo = all(pilha)
    achados = re.findall(r'npos\(list\)', c)
    if achados:
        for _ in achados:
            campos.append((i, ativo))
    i += 1

ativos = [x for x in campos if x[1]]
print('total de npos no trecho 570-800        :', len(campos))
print('  que RODAM no Naruto                  :', len(ativos))
print('  pulados (ramos de outro projeto)     :', len(campos) - len(ativos))
print()
print('ultimos campos ativos (linha):')
for linha, _ in ativos[-12:]:
    print('   L%d' % linha)
print()
print('=> bloco por personagem (Naruto, contadores 0) = %d campos' % len(ativos))
