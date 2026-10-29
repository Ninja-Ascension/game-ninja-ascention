"""Le os nomes de ANIMACAO de um .csb binario do Cocos Studio.

Motivo: getAnimationInfo() no binding Lua estoura quando o nome nao existe
(animationInfo_to_luaval -> lua_pushstring com ponteiro invalido, 0xc0000005).
Entao lemos os nomes direto do arquivo, sem passar pelo binding.

Formato do .csb: cabecalho de 8 bytes, depois blocos com strings terminadas
em NUL. Os nomes de animacao aparecem no bloco de AnimationInfo. Aqui
listamos todas as strings imprimiveis e destacamos as que parecem nomes de
animacao/evento.
"""
import re
import sys
from pathlib import Path

caminho = Path(sys.argv[1])
dados = caminho.read_bytes()

# Strings ASCII imprimiveis com pelo menos 3 caracteres.
strings = [s.decode("ascii") for s in re.findall(rb"[\x20-\x7e]{3,}", dados)]

alvo = [s for s in strings if "combo_damage" in s or "zongshanghai" in s]
print("arquivo: %s (%d bytes)" % (caminho.name, len(dados)))
print()
print("strings com combo_damage/zongshanghai, na ordem do arquivo:")
for s in alvo:
    print("  %r" % s)

print()
print("todas as strings (primeiras 60):")
for s in strings[:60]:
    print("  %r" % s)
