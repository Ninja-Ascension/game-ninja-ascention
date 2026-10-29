"""Compara o 6020 entregue pelo login_init com estado_inicial_cenas()."""
import os
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "port/server"))
import dados_batalha

tokens = dados_batalha.estado_inicial_cenas()
print("tokens=%d" % len(tokens))
for i, t in enumerate(tokens):
    print("  [%d] len=%d inicio=%r" % (i, len(t.split(",")), t[:40]))

with tempfile.TemporaryDirectory(prefix="cmp-", dir=ROOT / "build") as iso:
    os.environ["NR_ACCOUNTS_DIR"] = iso
    import local_server
    try:
        c = local_server.BANCO.criar_conta("cmp_cenas", "senha_forte_1")
        tok = local_server.BANCO.abrir_sessao(c["id"])
        local_server.lembrar_token(tok)
        login = local_server.resposta_login_init(
            "8", "8\r\nlogin_init\r\n22\r\n0\r\n", nome_cmd="login_init")
        campos = login.split(" ")
        n = len(campos)
        print("\nresposta tem %d campos" % n)
        pos = [i for i, f in enumerate(campos) if f == "6020"]
        print("posicoes de 6020: %r" % pos)
        for p in pos:
            entregues = campos[p + 1:p + 1 + len(tokens)]
            print("  entregues=%d" % len(entregues))
            for i, (a, b) in enumerate(zip(entregues, tokens)):
                if a != b:
                    print("  DIFERENCA no vetor %d (len %d vs %d)"
                          % (i, len(a.split(",")), len(b.split(","))))
                    print("    entrega=%r" % a[:80])
                    print("    acervo =%r" % b[:80])
                else:
                    print("  vetor %d IGUAL (%d valores)" % (i, len(a.split(","))))
    finally:
        local_server.BANCO.fechar()
