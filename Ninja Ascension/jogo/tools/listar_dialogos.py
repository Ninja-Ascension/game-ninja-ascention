"""Lista eventos de DIALOGO reais do tutorial, com os campos que
RoleDialogue:init le (Mission.lua:76-87):

    mission_param1 = 15 -> _dir       (lado: 0 esquerda, 1 direita)
    mission_param2 = 16 -> left_head  (retrato esquerdo)
    mission_param3 = 17 -> right_head (retrato direito)
    mission_param4 = 18 -> _name      (nome do personagem)
    mission_param5 = 19 -> _string    (fala)

execute_type fica na coluna 13 (Mission.lua:74) e o valor de dialogo em
execute_type_dialog.

Somente leitura.
"""
import os
import sys

NK = r"E:\[code]\nk"
DATA = os.path.join(NK, r"01_conteudo_apk\assets\res\data")

COL_EXEC = 13
C_DIR, C_LEFT, C_RIGHT, C_NAME, C_MSG = 15, 16, 17, 18, 19


def valor_dialogo():
    alvo = None
    caminho = os.path.join(NK, r"01_conteudo_apk\assets\src\client\mission\Mission.lua")
    with open(caminho, "rb") as f:
        for linha in f.read().decode("utf-8", "replace").splitlines():
            if "execute_type_dialog" in linha and "=" in linha and '"' in linha:
                # execute_type_dialog = "N对话"
                ini = linha.split('"')[1] if '"' in linha else ""
                digs = "".join(ch for ch in ini if ch.isdigit())
                if digs:
                    alvo = digs
    return alvo


def main():
    alvo = valor_dialogo()
    print(f"execute_type de dialogo = {alvo!r}")

    for nome in ("mission2.txt",):
        caminho = os.path.join(DATA, "mould", nome)
        if not os.path.exists(caminho):
            print(f"FALTA {caminho}")
            continue
        with open(caminho, "rb") as f:
            texto = f.read().decode("utf-8", "replace")
        print(f"\n=== {nome} ===")
        achou = 0
        for n, linha in enumerate(texto.splitlines(), 1):
            cols = linha.split("\t")
            if len(cols) <= C_MSG:
                continue
            if cols[COL_EXEC].strip() != alvo:
                continue
            achou += 1
            if achou > 12:
                continue
            print(f"  linha {n} id={cols[0].strip()}")
            print(f"     dir={cols[C_DIR]!r} left={cols[C_LEFT]!r} "
                  f"right={cols[C_RIGHT]!r}")
            print(f"     nome={cols[C_NAME]!r}")
            print(f"     fala={cols[C_MSG]!r}")
        print(f"  total de dialogos: {achou}")


if __name__ == "__main__":
    main()
