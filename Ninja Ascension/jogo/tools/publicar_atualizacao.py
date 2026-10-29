"""Publica arquivos do cliente PC para a atualizacao automatica.

Uso:
  python tools/publicar_atualizacao.py --automatico      # tudo que mudou nos scripts/config do cliente
  python tools/publicar_atualizacao.py port/lua/x.lua ...  # arquivos especificos (caminho dentro de "dados")
  python tools/publicar_atualizacao.py --listar          # mostra o que esta publicado

Copia cada arquivo para <jogo>/atualizacao/<caminho> (servido pelo servidor em
/atualizacao/...) e tambem para distribuicao/NinjaRevolution, para o pacote
completo continuar igual ao que os jogadores recebem.
"""
import hashlib
import os
import shutil
import sys
from pathlib import Path

JOGO = Path(__file__).resolve().parents[1]
PACOTE = JOGO.parent / "distribuicao" / "NinjaRevolution"
PUBLICADO = Path(os.environ.get("NR_ATUALIZACAO_DIR") or JOGO / "atualizacao")
sys.path.insert(0, str(JOGO / "port" / "server"))
import atualizacao_cliente  # noqa: E402  (mesma validacao de caminhos do servidor)

# Origem especial de alguns arquivos do pacote.
ORIGEM = {
    "NinjaAscension.exe": JOGO / "tools" / "launcher" / "NinjaAscension.exe",
    "Ninja Revolution.exe": JOGO / "tools" / "launcher" / "Ninja Revolution.exe",
    "DIAGNOSTICO.cmd": JOGO.parent / "distribuicao" / "DIAGNOSTICO.cmd",
    "port/resources/servidor.txt": JOGO / "port" / "resources" / "servidor.txt.vps",
}
# Varridos no modo --automatico (os assets grandes so entram se listados).
AUTOMATICO = ["port/lua", "port/resources", "port/data", "port/gameplay.json", "01_conteudo_apk/assets/src"]
IGNORAR = {"port/resources/servidor.txt.vps"}


# Binarios do cliente: a distribuicao usa a compilacao Release (sem DLLs de
# depuracao), servida no mesmo caminho .../NinjaResourceProbe/Debug/ que o
# iniciador ja conhece.
BINARIOS = "build/windows-probe-native/bin/NinjaResourceProbe/Debug/"
RELEASE = JOGO / "build" / "windows-release" / "bin" / "NinjaResourceProbe" / "Release"


def binarios_release():
    return sorted(BINARIOS + p.name for p in RELEASE.iterdir()
                  if p.is_file() and p.suffix.lower() in (".exe", ".dll"))


def origem(rel):
    if rel.startswith(BINARIOS) and (RELEASE / rel[len(BINARIOS):]).is_file():
        return RELEASE / rel[len(BINARIOS):]
    return ORIGEM.get(rel, JOGO / rel)


def destino_pacote(rel):
    return PACOTE / rel if rel in atualizacao_cliente.RAIZ_PERMITIDOS else PACOTE / "dados" / rel


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest() if p.is_file() else None


def candidatos():
    for item in AUTOMATICO:
        base = JOGO / item
        arquivos = [base] if base.is_file() else sorted(p for p in base.rglob("*") if p.is_file())
        for p in arquivos:
            rel = p.relative_to(JOGO).as_posix()
            if rel not in IGNORAR and atualizacao_cliente.caminho_valido(rel):
                yield rel
    yield from binarios_release()
    yield "port/resources/servidor.txt"
    yield "Ninja Revolution.exe"
    yield "NinjaAscension.exe"
    yield "DIAGNOSTICO.cmd"


def publicar(rel):
    if not atualizacao_cliente.caminho_valido(rel):
        raise SystemExit("caminho nao permitido: " + rel)
    src = origem(rel)
    if not src.is_file():
        raise SystemExit("arquivo nao encontrado: " + str(src))
    destinos=[PUBLICADO / rel]
    # Bootstrap remains on the server for old installations, not in new packages.
    if rel!='Ninja Revolution.exe':destinos.append(destino_pacote(rel))
    for dst in destinos:
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
    print("publicado:", rel)


def main(args):
    if args == ["--listar"]:
        m = atualizacao_cliente.manifesto()
        print("versao", m["versao"], "-", len(m["arquivos"]), "arquivo(s)")
        for a in m["arquivos"]:
            print(" ", a["caminho"], a["tamanho"], a["sha256"][:12])
        return
    if args == ["--automatico"]:
        alterados = [rel for rel in candidatos() if sha(origem(rel)) != sha(PUBLICADO/rel if rel=='Ninja Revolution.exe' else destino_pacote(rel))]
        if not alterados:
            print("nada mudou desde o pacote distribuido")
        for rel in alterados:
            publicar(rel)
        return
    if not args:
        print(__doc__)
        return
    for rel in args:
        publicar(rel.replace("\\", "/"))


if __name__ == "__main__":
    main(sys.argv[1:])
