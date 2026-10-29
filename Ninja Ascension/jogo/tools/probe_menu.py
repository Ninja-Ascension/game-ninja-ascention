"""Sonda do caminho ate o menu: registra, entra e pede os comandos que o
cliente pede depois do login (vali_register -> login_init), conferindo que as
respostas vindas do acervo chegam com os parsers certos.

    python tools/probe_menu.py
"""
import os
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
NK = os.path.abspath(os.path.join(AQUI, os.pardir))
sys.path.insert(0, os.path.join(NK, "port", "server"))
sys.path.insert(0, AQUI)

from protocol_probe import enviar, montar  # noqa: E402

FALHAS = []


def ok(cond, nome, extra=""):
    if cond:
        print("  [OK]   " + nome)
    else:
        print("  [FALHA] " + nome + ("  -> " + str(extra) if extra else ""))
        FALHAS.append(nome)


def main():
    usuario = "menu%d" % (os.getpid() % 100000)
    senha = "senha123"

    print("[1] Cadastro")
    r = enviar(montar(1, "platform_user_register", usuario, senha, senha,
                      "com.hyqggw.kkk"))
    ok(r.split(" ")[2] == "0", "registro ok", r)

    print("[2] Login (token de sessao)")
    r = enviar(montar(2, "platform_user_login", usuario, senha, "com.hyqggw.kkk"))
    p = r.split(" ")
    ok(p[2] == "0" and p[3] == "327", "login devolve 327", r)
    token = p[5]
    ok(len(token) == 43, "token 43 chars", token)

    print("[3] new_get_server_list (lista local)")
    r = enviar(montar(3, "new_get_server_list", "1.0.0", "local,pc,probe", "pkg,1"))
    p = r.split(" ")
    ok(p[2] == "0" and p[3] == "58", "lista responde parser 58", r)
    ok("127.0.0.1:18080" in r, "servidor local na lista", r)

    print("[4] vali_register (entrada no jogo)")
    r = enviar(montar(4, "vali_register", usuario, "1", "t4", "android"))
    p = r.split(" ")
    ok(p[2] == "0" and p[3] == "57", "vali_register aceita conta autenticada", r)
    ok(p[4] == "2", "register_type 2 (conta do sistema proprio)", r)

    print("[5] login_init (perfil da conta)")
    r = enviar(montar(5, "login_init", "com.hyqggw.kkk"))
    p = r.split(" ")
    ok(p[2] == "0" and p[3] == "3", "login_init responde parser 3", r[:80] + "...")
    toks = p[4:]
    ok(len(toks) == 96, "login_init tem 96 tokens", len(toks))
    if len(toks) == 96:
        ok(toks[15] != "",
           "user_id preenchido (%s)" % toks[15], toks[15])
        ok(toks[17] == usuario, "user_name = conta autenticada", toks[17])

    print("[6] user_create_time")
    r = enviar(montar(6, "user_create_time", ""))
    p = r.split(" ")
    ok(p[2] == "0" and p[3] == "1602", "create_time parser 1602", r)

    print("[7] Comandos de inicializacao (ACK neutro, sem dialogo de erro)")
    for seq, cmd in enumerate(["email_init", "union_init", "keep_alive"], start=7):
        r = enviar(montar(seq, cmd, ""))
        p = r.split(" ")
        # ACK neutro = "seq cmd 0" (3 tokens, SEM codigo de parser):
        # NetworkProtocol.lua:145-148 sai no break e o cliente nem abre caixa
        # de erro. Qualquer 4o token dispararia um parser S2C.
        ok(len(p) == 3 and p[1] == cmd and p[2] == "0",
           "%s ACK neutro (3 tokens)" % cmd, r)

    print("\n" + "=" * 60)
    if FALHAS:
        print("FALHAS: %d" % len(FALHAS))
        for f in FALHAS:
            print("  - " + f)
        return 1
    print("SUCESSO: caminho ate o login_init completo")
    return 0


if __name__ == "__main__":
    sys.exit(main())
