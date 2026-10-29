"""Cliente de teste do protocolo: monta o pedido EXATAMENTE como o jogo
(zlib + swap-modo-0) e envia para o servidor local, decodificando a resposta.
Serve para validar o fluxo Entrar/Criar conta sem depender de clique manual.

Uso:
    python tools/protocol_probe.py register usuario senha
    python tools/protocol_probe.py login usuario senha
    python tools/protocol_probe.py login_token usuario <token>
    python tools/protocol_probe.py vali usuario
"""
import os
import sys
import zlib

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(AQUI, os.pardir, "port", "server"))

import urllib.request  # noqa: E402


def _pad0(b):
    r = len(b) % 8
    return b + b"\x00" * (8 - r) if r else b


def swap(data):
    d = _pad0(data)
    out = bytearray(len(d))
    for o in range(0, len(d) - 7, 8):
        out[o:o + 4] = d[o + 4:o + 8]
        out[o + 4:o + 8] = d[o:o + 4]
    return bytes(out)


def enviar(corpo, url="http://127.0.0.1:18080/iniServer"):
    dados = swap(zlib.compress(corpo.encode("utf-8"), 9))
    req = urllib.request.Request(url, data=dados)
    with urllib.request.urlopen(req, timeout=10) as r:
        bruto = r.read()
    return zlib.decompress(swap(bruto)).decode("utf-8", "replace")


def montar(seq, cmd, *linhas):
    return "\r\n".join([str(seq), cmd] + list(linhas))


def main(argv):
    if len(argv) < 2:
        print(__doc__)
        return 2
    acao = argv[1]
    if acao == "register" and len(argv) >= 4:
        print(enviar(montar(1, "platform_user_register",
                            argv[2], argv[3], argv[3], "com.hyqggw.kkk")))
    elif acao == "login" and len(argv) >= 4:
        print(enviar(montar(2, "platform_user_login",
                            argv[2], argv[3], "com.hyqggw.kkk")))
    elif acao == "login_token" and len(argv) >= 4:
        print(enviar(montar(3, "platform_user_login",
                            argv[2], "@tk1:" + argv[3], "com.hyqggw.kkk")))
    elif acao == "vali" and len(argv) >= 3:
        print(enviar(montar(4, "vali_register",
                            argv[2], "1", "t4", "android")))
    elif acao == "sair":
        print(enviar(montar(5, "logout", "")))
    else:
        print(__doc__)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
