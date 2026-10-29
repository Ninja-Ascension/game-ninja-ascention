"""Testes de ponta a ponta das contas: rede REAL (zlib + swap) + banco temporario.

Roda sem tocar no banco de producao: NR_ACCOUNTS_DIR aponta para um diretorio
temporario e o servidor e iniciado em uma porta livre dentro do proprio teste.

    python tools/test_contas_e2e.py
"""
import os
import socket
import subprocess
import sys
import tempfile
import time
import zlib

AQUI = os.path.dirname(os.path.abspath(__file__))
NK = os.path.abspath(os.path.join(AQUI, os.pardir))
SRV = os.path.join(NK, "port", "server")
sys.path.insert(0, SRV)

FALHAS = []
TOTAL = 0


def ok(cond, nome, extra=""):
    global TOTAL
    TOTAL += 1
    if cond:
        print("  [OK]   " + nome)
    else:
        print("  [FALHA] " + nome + ("  -> " + str(extra) if extra else ""))
        FALHAS.append(nome)


# --- codec do jogo (igual ao NetworkAdaptor: zlib + swap das metades) -------
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


def porta_livre():
    s = socket.socket()
    s.bind(("127.0.0.1", 0))
    p = s.getsockname()[1]
    s.close()
    return p


def montar(seq, cmd, *linhas):
    return "\r\n".join([str(seq), cmd] + [str(x) for x in linhas])


def main():
    import urllib.request

    tmpdir = tempfile.mkdtemp(prefix="nrcontas_")
    porta = porta_livre()
    env = dict(os.environ)
    env["NR_ACCOUNTS_DIR"] = tmpdir
    env["NR_PORT"] = str(porta)
    env["PYTHONIOENCODING"] = "utf-8"
    # O proprio teste importa local_server para inspecionar perfis: aponta o
    # banco dele para o mesmo diretorio temporario ANTES do import.
    os.environ["NR_ACCOUNTS_DIR"] = tmpdir
    os.environ["NR_PORT"] = str(porta)

    srv = subprocess.Popen(
        [sys.executable, os.path.join(SRV, "local_server.py")],
        cwd=SRV, env=env,
        # DEVNULL: um PIPE que ninguem le enche e bloqueia o servidor dentro
        # de log() no meio da suite (o buffer ronda 64 KB).
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
    )
    url = "http://127.0.0.1:%d/iniServer" % porta

    def enviar(corpo):
        dados = swap(zlib.compress(corpo.encode("utf-8"), 9))
        req = urllib.request.Request(url, data=dados)
        with urllib.request.urlopen(req, timeout=10) as r:
            return zlib.decompress(swap(r.read())).decode("utf-8", "replace")

    try:
        # espera o servidor subir
        pronto = False
        for _ in range(50):
            try:
                enviar(montar(0, "new_get_server_list", "v", "local,pc", "pkg"))
                pronto = True
                break
            except Exception:
                time.sleep(0.2)
        ok(pronto, "servidor sobe na porta livre e responde o handshake")
        if not pronto:
            return relatorio()

        print("\n[1] Cadastro valido")
        r = enviar(montar(1, "platform_user_register",
                          "ana", "senha123", "senha123", "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "0" and r.split(" ")[3] == "326",
           "cadastro responde 326 status 0", r)

        print("\n[2] Campos vazios")
        r = enviar(montar(2, "platform_user_register", "", "", "", "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "-1", "cadastro com campos vazios e recusado", r)
        ok("Informe o nome" in r, "mensagem de erro especifica (nome)", r)

        print("\n[3] Usuario duplicado")
        r = enviar(montar(3, "platform_user_register",
                          "ANA", "senha123", "senha123", "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "-1" and "ja esta cadastrado" in r,
           "duplicado recusado com mensagem clara", r)

        print("\n[4] Senhas diferentes")
        r = enviar(montar(4, "platform_user_register",
                          "bia", "senha123", "senha456", "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "-1" and "nao conferem" in r,
           "senhas diferentes recusadas", r)

        print("\n[5] Nome invalido")
        r = enviar(montar(5, "platform_user_register",
                          "a", "senha123", "senha123", "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "-1", "nome curto recusado", r)
        r = enviar(montar(6, "platform_user_register",
                          "com|pipe", "senha123", "senha123", "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "-1", "caractere incompativel com o protocolo recusado", r)

        print("\n[6] Credenciais incorretas")
        r = enviar(montar(7, "platform_user_login",
                          "ana", "errada", "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "-1", "senha errada recusada", r)

        print("\n[7] Usuario inexistente")
        r = enviar(montar(8, "platform_user_login",
                          "ninguem", "senha123", "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "-1", "usuario inexistente recusado", r)

        print("\n[8] Login correto + sessao individual")
        r = enviar(montar(9, "platform_user_login",
                          "ana", "senha123", "com.hyqggw.kkk"))
        p = r.split(" ")
        ok(p[2] == "0" and p[3] == "327", "login responde 327 status 0", r)
        token = p[5]
        ok(len(token) == 43, "token tem 43 caracteres (formato do acervo)", len(token))
        import contas
        ok(contas.token_valido(token), "token passa em account_sys_valid_token")
        ok(token != contas.novo_token(), "token nao e constante")
        r2 = enviar(montar(10, "platform_user_login",
                           "ana", "senha123", "com.hyqggw.kkk"))
        ok(r2.split(" ")[5] != token, "cada login gera um token diferente")

        print("\n[9] Login por token lembrado")
        r = enviar(montar(11, "platform_user_login",
                          "ana", "@tk1:" + token, "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "0", "token lembrado autentica", r)
        # A rotacao REVOGA o token antigo e emite um novo: os passos seguintes
        # precisam do token atual.
        token_atual = r.split(" ")[5]
        ok(token_atual != token, "rotacao emitiu token novo")


        print("\n[10] vali_register exige SESSAO da propria conta")
        # O acervo NAO manda token em vali_register (login.lua:706 manda so
        # platform_account/server_number/platform/user_account_platform), por
        # isso o servidor cai na sessao da conexao aberta pelo login acima.
        # Sem esse fallback TODO GAME START era recusado e o jogador via
        # "Erro desconhecido" na tela.
        r = enviar(montar(12, "vali_register", "ana", "1", "t4", "android"))
        ok(r.split(" ")[2] == "0", "vali_register usa a sessao da conexao", r)
        # O fallback NAO serve de passe para OUTRA conta.
        r = enviar(montar(13, "vali_register", "outra_conta", "1", "t4", "android"))
        ok(r.split(" ")[2] == "-1", "conta DIFERENTE da sessao NAO entra", r)
        # Token antigo (revogado pela rotacao) -> recusa.
        r = enviar(montar(16, "vali_register", "ana", "1", "t4", "android",
                          token))
        ok(r.split(" ")[2] == "-1", "token revogado NAO entra", r)
        # Token atual da propria conta -> aceita. (o cruzamento entre contas
        # e provado em test_sessao_perfil.py)
        r = enviar(montar(14, "vali_register", "ana", "1", "t4", "android",
                          token_atual))
        ok(r.split(" ")[2] == "0" and r.split(" ")[3] == "57",
           "conta com a propria sessao entra", r)
        r = enviar(montar(13, "vali_register", "fantasma", "1", "t4", "android"))
        ok(r.split(" ")[2] == "-1", "conta inexistente NAO entra", r)

        print("\n[11] Perfis isolados entre contas")
        import local_server as ls
        c1 = ls.BANCO.autenticar("ana", "senha123")
        ls.BANCO.criar_conta("carla", "senha123", "senha123")
        c2 = ls.BANCO.autenticar("carla", "senha123")
        p1 = ls.BANCO.perfil(c1["id"])
        p2 = ls.BANCO.perfil(c2["id"])
        ok(p1["user_id"] != p2["user_id"], "contas diferentes -> user_id diferente")
        ok(ls.BANCO.total_contas() >= 2, "banco guarda as contas")

        print("\n[12] Senha nunca em texto puro")
        import sqlite3
        con = sqlite3.connect(os.path.join(tmpdir, "contas.sqlite3"))
        hashes = [x[0] for x in con.execute("SELECT senha_hash FROM contas")]
        ok(all(h.startswith("pbkdf2_sha256$") for h in hashes),
           "todos os hashes sao PBKDF2")
        ok(not any("senha123" in h for h in hashes), "senha nao aparece no banco")
        con.close()

        print("\n[13] Logout invalida a sessao")
        r = enviar(montar(14, "platform_user_login",
                          "ana", "senha123", "com.hyqggw.kkk"))
        tok = r.split(" ")[5]
        ls.BANCO.revogar_sessao(tok)
        r = enviar(montar(15, "platform_user_login",
                          "ana", "@tk1:" + tok, "com.hyqggw.kkk"))
        ok(r.split(" ")[2] == "-1", "token revogado nao autentica mais", r)

        print("\n[14] Persistencia entre reinicios do servidor")
        srv.terminate()
        try:
            srv.wait(timeout=10)
        except Exception:
            srv.kill()
        srv2 = subprocess.Popen(
            [sys.executable, os.path.join(SRV, "local_server.py")],
            cwd=SRV, env=env,
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
        )
        pronto = False
        for _ in range(50):
            try:
                enviar(montar(0, "new_get_server_list", "v", "local,pc", "pkg"))
                pronto = True
                break
            except Exception:
                time.sleep(0.2)
        ok(pronto, "servidor reinicia sobre o mesmo banco")
        if pronto:
            r = enviar(montar(16, "platform_user_login",
                              "ana", "senha123", "com.hyqggw.kkk"))
            ok(r.split(" ")[2] == "0", "conta cadastrada sobrevive ao reinicio", r)
        srv2.terminate()
        try:
            srv2.wait(timeout=10)
        except Exception:
            srv2.kill()

        print("\n[15] Servidor desligado")
        try:
            enviar(montar(17, "platform_user_login", "ana", "senha123", "com.hyqggw.kkk"))
            ok(False, "sem servidor o cliente deve falhar (nao respondeu)")
        except Exception:
            ok(True, "servidor desligado gera falha de rede no cliente")
    finally:
        if srv.poll() is None:
            srv.kill()
        try:
            srv.stdout.close()
        except Exception:
            pass

    return relatorio()


def relatorio():
    print("\n" + "=" * 60)
    if FALHAS:
        print("FALHAS: %d de %d" % (len(FALHAS), TOTAL))
        for f in FALHAS:
            print("  - " + f)
        return 1
    print("SUCESSO: %d/%d verificacoes" % (TOTAL, TOTAL))
    return 0


if __name__ == "__main__":
    sys.exit(main())
