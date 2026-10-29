"""Atualizacao automatica do cliente PC (servida por HTTP GET).

A pasta publicada (padrao: <jogo>/atualizacao, ou NR_ATUALIZACAO_DIR) espelha a
estrutura da pasta "dados" do cliente distribuido, mais o proprio iniciador na
raiz ("Ninja Revolution.exe"). O iniciador baixa:

  GET /atualizacao/manifesto.json   -> {"versao": n, "arquivos": [{caminho, sha256, tamanho}]}
  GET /atualizacao/arquivos/<caminho> -> bytes do arquivo

e substitui so os arquivos cujo SHA-256 local difere. Nada aqui toca no banco.
"""
import hashlib
import json
import os
import threading
import urllib.parse

RAIZ_JOGO = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), os.pardir, os.pardir))
# Caminhos que o cliente aceita receber (o iniciador valida de novo do lado dele).
PREFIXOS = ("port/", "01_conteudo_apk/", "build/windows-probe-native/")
RAIZ_PERMITIDOS = ("NinjaAscension.exe", "Ninja Revolution.exe", "DIAGNOSTICO.cmd")

_trava = threading.Lock()
_cache = {}  # caminho -> (mtime_ns, tamanho, sha256)


def pasta():
    return os.path.abspath(os.environ.get("NR_ATUALIZACAO_DIR") or os.path.join(RAIZ_JOGO, "atualizacao"))


def caminho_valido(rel):
    if not rel or "\\" in rel or rel.startswith("/") or ":" in rel:
        return False
    partes = rel.split("/")
    if any(p in ("", ".", "..") for p in partes):
        return False
    return rel in RAIZ_PERMITIDOS or rel.startswith(PREFIXOS)


def _sha256(arquivo):
    h = hashlib.sha256()
    with open(arquivo, "rb") as f:
        for bloco in iter(lambda: f.read(1 << 20), b""):
            h.update(bloco)
    return h.hexdigest()


def manifesto():
    base = pasta()
    arquivos = []
    if os.path.isdir(base):
        for atual, _, nomes in os.walk(base):
            for nome in nomes:
                completo = os.path.join(atual, nome)
                rel = os.path.relpath(completo, base).replace(os.sep, "/")
                if not caminho_valido(rel):
                    continue
                st = os.stat(completo)
                with _trava:
                    item = _cache.get(rel)
                    if not item or item[0] != st.st_mtime_ns or item[1] != st.st_size:
                        item = (st.st_mtime_ns, st.st_size, _sha256(completo))
                        _cache[rel] = item
                arquivos.append({"caminho": rel, "sha256": item[2], "tamanho": item[1]})
    arquivos.sort(key=lambda a: a["caminho"])
    versao = hashlib.sha256("".join(a["caminho"] + a["sha256"] for a in arquivos).encode()).hexdigest()[:16]
    return {"versao": versao, "arquivos": arquivos}


def responder(handler, caminho_url):
    """Atende GET /atualizacao/...; devolve False se a rota nao for dele."""
    caminho = urllib.parse.unquote(urllib.parse.urlsplit(caminho_url).path)
    if caminho == "/atualizacao/manifesto.json":
        corpo = json.dumps(manifesto(), separators=(",", ":")).encode("utf-8")
        tipo = "application/json"
    elif caminho.startswith("/atualizacao/arquivos/"):
        rel = caminho[len("/atualizacao/arquivos/"):]
        completo = os.path.join(pasta(), *rel.split("/")) if caminho_valido(rel) else None
        if not completo or not os.path.isfile(completo):
            handler.send_response(404)
            handler.send_header("Content-Length", "0")
            handler.send_header("Connection", "close")
            handler.end_headers()
            return True
        with open(completo, "rb") as f:
            corpo = f.read()
        tipo = "application/octet-stream"
    else:
        return False
    handler.send_response(200)
    handler.send_header("Content-Type", tipo)
    handler.send_header("Content-Length", str(len(corpo)))
    handler.send_header("Connection", "close")
    handler.end_headers()
    handler.wfile.write(corpo)
    return True
