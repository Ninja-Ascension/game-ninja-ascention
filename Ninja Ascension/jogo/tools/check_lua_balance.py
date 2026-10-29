"""Verificador de balanceamento de blocos Lua.

Nao e um parser completo: conta abertura/fechamento de blocos ignorando
strings, comentarios de linha (--) e comentarios de bloco (--[[ ]]).
Serve para pegar erro grosseiro de 'end' faltando antes de reiniciar o jogo.
"""
import re
import sys

P = sys.argv[1] if len(sys.argv) > 1 else 'E:/[code]/nk/port/lua/progresso_carregamento.lua'
src = open(P, encoding='utf8').read()

ABRE = {'function', 'if', 'for', 'while', 'do', 'repeat'}


def tokeniza(s):
    """Devolve apenas as palavras-chave fora de strings e comentarios."""
    i = 0
    n = len(s)
    saida = []
    while i < n:
        c = s[i]
        # comentario de bloco
        if s.startswith('--[[', i):
            j = s.find(']]', i + 4)
            i = n if j < 0 else j + 2
            continue
        # comentario de linha
        if s.startswith('--', i):
            j = s.find('\n', i)
            i = n if j < 0 else j + 1
            continue
        # string longa
        if s.startswith('[[', i):
            j = s.find(']]', i + 2)
            i = n if j < 0 else j + 2
            continue
        # strings
        if c in ('"', "'"):
            q = c
            i += 1
            while i < n:
                if s[i] == '\\':
                    i += 2
                    continue
                if s[i] == q:
                    i += 1
                    break
                i += 1
            continue
        if c.isalpha() or c == '_':
            j = i
            while j < n and (s[j].isalnum() or s[j] == '_'):
                j += 1
            saida.append(s[i:j])
            i = j
            continue
        i += 1
    return saida


peso = 0
pilha = []
for tok in tokeniza(src):
    if tok in ('function', 'if', 'do', 'repeat'):
        # 'for ... do' e 'while ... do' nao abrem DUAS vezes
        if tok == 'do' and pilha and pilha[-1] == 'for':
            continue
        if tok == 'do' and pilha and pilha[-1] == 'while':
            continue
        pilha.append(tok)
        peso += 1
    elif tok == 'for' or tok == 'while':
        pilha.append(tok)
        peso += 1
    elif tok == 'end':
        if not pilha:
            print('ERRO: end sem abertura correspondente')
            sys.exit(1)
        pilha.pop()
        peso -= 1
    elif tok == 'until':
        if pilha and pilha[-1] == 'repeat':
            pilha.pop()
            peso -= 1

print('%s' % P)
print('blocos abertos e nao fechados: %d' % peso)
if pilha:
    print('pilha restante: %s' % pilha[:10])
print('RESULTADO: %s' % ('BALANCEADO' if peso == 0 else 'DESBALANCEADO'))
sys.exit(0 if peso == 0 else 1)
