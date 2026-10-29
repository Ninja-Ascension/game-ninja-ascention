"""Mostra, em UTF-8, as colunas dos eventos do mission3 pedidos na linha de comando."""
import io
import sys

ARQ = r'N:\01_conteudo_apk\assets\res\language\pt_BR\data\mould\mission3.txt'
alvos = set(sys.argv[1:])
linhas = io.open(ARQ, encoding='utf8', errors='replace').read().splitlines()
saida = io.open(r'N:\build\mission3-eventos.txt', 'w', encoding='utf8')
saida.write('total linhas %d\n' % len(linhas))
for i, linha in enumerate(linhas):
    colunas = linha.split('\t')
    if len(colunas) >= 15 and colunas[9] in alvos:
        saida.write('--- linha %d (grupo %s seq %s)\n' % (i + 1, colunas[0], colunas[1]))
        for j, valor in enumerate(colunas):
            if valor != '':
                saida.write('  [%02d] %s\n' % (j, valor))
saida.close()
print('escrito N:\\build\\mission3-eventos.txt')
