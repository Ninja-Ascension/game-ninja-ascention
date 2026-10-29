"""Compara as duas listas de pre-carga do acervo com o que existe nos recursos.

CONTEXTO (medido):
  LocalDatas.lua:6310-6335 monta localData_list de duas formas:
    - PROJETOS red_alert/l_digital/l_pokemon/... -> data_path_config (manifesto
      com caminhos corretos, ex "data/mould/equipment_mould.txt")
    - DEMAIS (o nosso "t4") -> uma lista FLAT antiga que pede
      "data/equipment_mould.txt" na raiz de data/
  Os arquivos de facto moram em data/mould/. Por isso o console do usuario
  mostra "No file found at data/equipment_mould.txt" mesmo com o arquivo
  presente: e o caminho da lista que esta errado, nao o arquivo.

    python tools/auditar_dados_ausentes.py
"""
import os
import re
import sys

NK = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(NK, "01_conteudo_apk", "assets", "src")
RES = os.path.join(NK, "res")
LOCAL = os.path.join(SRC, "client", "loader", "LocalDatas.lua")
MANIFEST = os.path.join(RES, "configs", "data", "data_path_config.lua")


def ler(p):
    with open(p, "r", encoding="utf-8", errors="replace") as f:
        return f.read()


def lista_flat():
    t = ler(LOCAL)
    ini = t.index("localData_list = {", t.index("else", t.index("localData_list = {}")))
    fim = t.index("\n\t}", ini)
    vistos, saida = set(), []
    for p in re.findall(r'"(data/[^"]+)"', t[ini:fim]):
        if p not in vistos:
            vistos.add(p)
            saida.append(p)
    return saida


def manifesto():
    t = ler(MANIFEST)
    vistos, saida = set(), []
    for p in re.findall(r'"(data/[^"]+)"', t):
        if p not in vistos:
            vistos.add(p)
            saida.append(p)
    return saida


def existe(caminho_rel):
    return os.path.exists(os.path.join(RES, caminho_rel))


def resolve_em_mould(caminho_rel):
    """data/x.txt -> data/mould/x.txt (o mesmo arquivo, caminho certo)."""
    d, nome = os.path.split(caminho_rel)
    alt = os.path.join(d, "mould", nome)
    return alt if existe(alt) else None


def main():
    flat = lista_flat()
    manif = manifesto()

    print("== lista FLAT (o nosso build t4 usa esta) ==")
    print("entradas: %d" % len(flat))
    faltando = [p for p in flat if not existe(p)]
    print("nao resolvem no caminho pedido: %d" % len(faltando))
    corrigiveis, sem_arquivo = [], []
    for p in faltando:
        alt = resolve_em_mould(p)
        (corrigiveis if alt else sem_arquivo).append((p, alt))
    print("  -> existem em data/mould/ (so o caminho esta errado): %d"
          % len(corrigiveis))
    print("  -> nao existem em lugar nenhum dos recursos:            %d"
          % len(sem_arquivo))

    print()
    print("== manifesto data_path_config.lua (o que o acervo usa nos"
          " outros projetos) ==")
    print("entradas: %d" % len(manif))
    m_falta = [p for p in manif if not existe(p)]
    print("ausentes no manifesto: %d" % len(m_falta))
    for p in m_falta:
        print("   %s" % p)

    print()
    print("== arquivos SEM NENHUMA COPIA nos recursos ==")
    nomes = set(p for p, _ in sem_arquivo)
    for p in sorted(nomes):
        print("   %s" % p)
    print("(total %d)" % len(nomes))

    print()
    print("== conclusao ==")
    if corrigiveis:
        print("* %d arquivos existem, mas a lista flat procura no nivel errado:"
              % len(corrigiveis))
        print("  o mesmo arquivo esta em data/mould/. E o aviso do console.")
    if nomes:
        print("* %d arquivos nao existem nos recursos extraidos do APK (nem"
              % len(nomes))
        print("  em data/, nem em data/mould/): sao dados que o cliente Android")
        print("  baixava por patch em tempo de execucao. O acervo tolera a")
        print("  ausencia (local_datas.lua devolve tabela vazia; o laco nao")
        print("  aborta), entao nao se inventa conteudo.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
