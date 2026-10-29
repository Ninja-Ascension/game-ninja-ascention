"""Inspeciona o bloco AnimationInfo de um .csb binario.

O nome de uma animacao e um EventFrame tem o mesmo texto no arquivo, entao
so olhar as strings nao distingue. Aqui imprimimos o contexto binario para
entender a estrutura do bloco.
"""
import sys
from pathlib import Path

caminho = Path(sys.argv[1])
dados = caminho.read_bytes()

for marca in (b"combo_damage_move\x00", b"combo_damage_move_xs\x00",
              b"combo_damage_move_xs_over\x00"):
    i = dados.find(marca)
    print("=== %r em offset %d ===" % (marca.decode().rstrip("\x00"), i))
    if i < 0:
        continue
    trecho = dados[max(0, i - 32):i + 48]
    print("hex:", trecho.hex(" "))
    print("txt:", repr(trecho))
    print()
