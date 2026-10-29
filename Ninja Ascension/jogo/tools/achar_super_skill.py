"""Varre tabelas de missao do acervo e lista as linhas cujo execute_type
(coluna definida em Mission.lua) e' 45 = "角色释放绝技" (liberar habilidade
especial). Mission.lua:74 mission_execute_type = 13, :76 mission_param1 = 15.

Somente leitura: nao altera nenhum arquivo.
"""
import os
import sys

NK = r"E:\[code]\nk"
DATA = os.path.join(NK, r"01_conteudo_apk\assets\res\data")

COL_EXEC = 13   # mission_execute_type
COL_P1 = 15     # mission_param1
COL_P2 = 16     # mission_param2


def linhas(caminho):
    with open(caminho, "rb") as f:
        bruto = f.read()
    # Os .txt do acervo sao UTF-8 (as vezes com escapes); decodifica tolerante.
    texto = bruto.decode("utf-8", "replace")
    for n, linha in enumerate(texto.splitlines(), 1):
        if not linha.strip():
            continue
        yield n, linha.split("\t")


def main():
    alvos = []
    for raiz, _, arquivos in os.walk(DATA):
        for nome in arquivos:
            if nome.endswith(".txt"):
                alvos.append(os.path.join(raiz, nome))

    achados = 0
    for caminho in alvos:
        try:
            for n, cols in linhas(caminho):
                if len(cols) <= COL_EXEC:
                    continue
                if cols[COL_EXEC].strip() == "45":
                    p1 = cols[COL_P1].strip() if len(cols) > COL_P1 else "?"
                    p2 = cols[COL_P2].strip() if len(cols) > COL_P2 else "?"
                    # id da missao costuma estar na coluna 1
                    mid = cols[0].strip()
                    unico = os.path.relpath(caminho, DATA)
                    print(f"{unico}:{n} id={mid} execute_type=45 "
                          f"camp(param1)={p1} coord(param2)={p2}")
                    achados += 1
        except OSError as e:
            print(f"ERRO {caminho}: {e}", file=sys.stderr)

    print(f"\nTOTAL de linhas execute_type=45: {achados}")


if __name__ == "__main__":
    main()
