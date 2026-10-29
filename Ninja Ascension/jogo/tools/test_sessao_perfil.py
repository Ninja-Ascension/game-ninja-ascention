"""Testes de VINCULO SESSAO/CONTA/PERFIL (prioridade 2).

Cobre exatamente o que a suite generica nao cobre:
  * vali_register com conta existente mas SEM sessao
  * login_init sem autenticacao
  * token da conta A pedindo a conta B
  * alternancia entre duas contas (isolamento)
  * sessao apos logout e apos expiracao
  * user_id real entregue pelo parser (token 16 do 327/3)

Roda em porta e banco temporarios no disco E:, sem tocar no banco real.

    python tools/test_sessao_perfil.py
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

# Diretorio de testes SEMPRE no disco E: (nunca no C:, como pedido).
_DIR_TESTES = os.path.join(NK, "build", "probe-writable")
os.makedirs(_DIR_TESTES, exist_ok=True)

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


def corpo_login_init(token, conta, versao="1.66012", idioma="pt_BR"):
    """Corpo REAL do login_init (ProtocolCommanderCopy.lua:100-129):
    versao, idioma, param_list, userLoginPackageName, userLoginToken,
    getPlatformParam(), m_sUin, m_sSessionId
    """
    return montar(1, "login_init", versao, idioma, "", "com.hyqggw.kkk",
                  token or "", "t4", conta or "", "")


def main():
    import urllib.request
    import contas

    tmpdir = tempfile.mkdtemp(prefix="nrsessao_", dir=_DIR_TESTES)
    porta = porta_livre()
    env = dict(os.environ)
    env["NR_ACCOUNTS_DIR"] = tmpdir
    env["NR_PORT"] = str(porta)
    env["PYTHONIOENCODING"] = "utf-8"
    # O teste importa local_server para ler perfis direto do banco. Se o
    # processo do teste importar ANTES de apontar o diretório, ele abre o
    # banco de producao; apontamos aqui, antes do import de local_server.
    os.environ["NR_ACCOUNTS_DIR"] = tmpdir
    os.environ["NR_PORT"] = str(porta)

    # DEVNULL, nao PIPE: o servidor escreve uma linha de log por pedido; com
    # stdout num PIPE que ninguem le, o buffer (~64 KB) enche e o processo
    # BLOQUEIA dentro de log() — foi exatamente isso que travava o teste no
    # meio da alternancia de contas.
    srv = subprocess.Popen([sys.executable, os.path.join(SRV, "local_server.py")],
                           cwd=SRV, env=env,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    url = "http://127.0.0.1:%d/iniServer" % porta

    def enviar(texto):
        # Connection: close evita reaproveitar socket que o servidor fechou
        # (http.server fecha por omissao e o cliente urllib pode tentar reusar).
        dados = swap(zlib.compress(texto.encode("utf-8"), 9))
        req = urllib.request.Request(url, data=dados,
                                     headers={"Connection": "close"})
        ultimo = None
        for tentativa in range(3):
            try:
                with urllib.request.urlopen(req, timeout=10) as r:
                    return zlib.decompress(swap(r.read())).decode("utf-8", "replace")
            except Exception as exc:   # noqa: BLE001
                ultimo = exc
                time.sleep(0.1)
        raise ultimo

    def campo(resp, i):
        p = resp.split(" ")
        return p[i] if i < len(p) else None

    try:
        pronto = False
        for _ in range(50):
            try:
                enviar(montar(0, "new_get_server_list", "v", "pc", "pkg"))
                pronto = True
                break
            except Exception:
                time.sleep(0.2)
        ok(pronto, "servidor sobe")
        if not pronto:
            return relatorio()

        # DUAS INSTANCIAS NAO COMPARTILHAM O MESMO ARQUIVO SQLITE.
        # O subprocesso do servidor e o processo do teste abririam o mesmo
        # contas.sqlite3 e uma escrita de um pode bloquear a outra. Aqui o
        # teste le/mexe numa CÓPIA própria do banco logo depois de cada
        # operação que precisa inspecionar dados.
        def banco_direto():
            import shutil
            copia = os.path.join(tmpdir, "inspecao.sqlite3")
            shutil.copyfile(os.path.join(tmpdir, "contas.sqlite3"), copia)
            return contas.Banco(copia)

        def perfis_por_nome():
            b = banco_direto()
            try:
                with b._lock:
                    linhas = b._conn.execute(
                        "SELECT c.display_name, p.user_id FROM perfis p"
                        " JOIN contas c ON c.id = p.conta_id").fetchall()
                return {r["display_name"]: r["user_id"] for r in linhas}
            finally:
                b.fechar()

        # duas contas com perfis distintos
        for nome in ("alfa", "beta"):
            enviar(montar(1, "platform_user_register", nome, "senha123",
                          "senha123", "com.hyqggw.kkk"))
        r_a = enviar(montar(2, "platform_user_login", "alfa", "senha123", "com.hyqggw.kkk"))
        token_a = campo(r_a, 5)
        r_b = enviar(montar(3, "platform_user_login", "beta", "senha123", "com.hyqggw.kkk"))
        token_b = campo(r_b, 5)
        ok(token_a and token_b and token_a != token_b,
           "cada conta recebe sessao propria", (token_a, token_b))

        perfis = perfis_por_nome()
        id_a = perfis["alfa"]
        id_b = perfis["beta"]
        ok(id_a != id_b, "perfis tem user_id distintos", (id_a, id_b))

        print("\n[1] vali_register com conta existente mas SEM sessao")
        r = enviar(montar(10, "vali_register", "alfa", "1", "t4", "android"))
        ok(campo(r, 2) == "-1", "recusado (existir conta nao basta)", r)

        print("\n[2] vali_register com token + conta (sessao legitima)")
        r = enviar(montar(11, "vali_register", "alfa", "1", "t4", "android", token_a))
        ok(campo(r, 2) == "0" and campo(r, 7) == "alfa", "aceito", r)
        ok(campo(r, 5) == str(id_a), "platform_id = conta real", (campo(r, 5), id_a))

        print("\n[3] token da conta A pedindo a conta B")
        r = enviar(montar(12, "vali_register", "beta", "1", "t4", "android", token_a))
        ok(campo(r, 2) == "-1", "recusado (sessao de outra conta)", r)

        print("\n[4] login_init sem autenticacao (servidor recem-iniciado)")
        # Servidor NOVO, sem nenhuma 327 emitida: nao ha sessao de conexao
        # nem token no pedido -> tem de recusar. Instancia isolada para que
        # este caso nao dependa da sessao das contas acima.
        tmp2 = tempfile.mkdtemp(prefix="nrsessao_limpo_", dir=_DIR_TESTES)
        porta2 = porta_livre()
        env2 = dict(env)
        env2["NR_ACCOUNTS_DIR"] = tmp2
        env2["NR_PORT"] = str(porta2)
        srv2 = subprocess.Popen(
            [sys.executable, os.path.join(SRV, "local_server.py")],
            cwd=SRV, env=env2,
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        url2 = "http://127.0.0.1:%d/iniServer" % porta2
        try:
            for _ in range(50):
                try:
                    enviar(montar(0, "new_get_server_list", "v", "pc", "pkg"))
                    break
                except Exception:
                    time.sleep(0.2)

            def enviar2(texto):
                dados = swap(zlib.compress(texto.encode("utf-8"), 9))
                req = urllib.request.Request(url2, data=dados,
                                             headers={"Connection": "close"})
                with urllib.request.urlopen(req, timeout=10) as rr:
                    return zlib.decompress(swap(rr.read())).decode("utf-8", "replace")

            r = enviar2(corpo_login_init(None, None))
            ok(campo(r, 2) == "-1", "login_init recusado sem nenhuma sessao", r[:70])
            ok("Convidado" not in r, "NAO cai no fallback 'Convidado'", r[:70])
            # conta existente mas sem sessao tambem e recusada
            enviar2(montar(1, "platform_user_register", "gama", "senha123",
                           "senha123", "com.hyqggw.kkk"))
            r = enviar2(montar(2, "vali_register", "gama", "1", "t4", "android"))
            ok(campo(r, 2) == "-1", "vali_register sem sessao recusado", r[:70])
            r = enviar2(corpo_login_init(None, "gama"))
            ok(campo(r, 2) == "-1", "login_init com conta mas sem sessao recusado",
               r[:70])
        finally:
            if srv2.poll() is None:
                srv2.kill()
            try:
                srv2.stdout.close()
            except Exception:
                pass

        print("\n[5] login_init com token explicito por conta (user_id real)")
        r = enviar(corpo_login_init(token_a, "alfa"))
        p = r.split(" ")
        ok(campo(r, 2) == "0" and campo(r, 3) == "3", "login_init aceito", r[:40])
        # 96 tokens do parser 3 + "12042 <velocidade>" (parser 12042), que
        # mantem getUserSpeedSum consistente (EnvironmentDatas.lua:10467).
        ok(len(p) - 4 == 103 and "12042" in p,
           "96 tokens + 12042", len(p) - 4)
        ok(p[4 + 15] == str(id_a), "token 16 (user_id) = perfil da conta A",
           (p[4 + 15], id_a))
        ok(p[4 + 17] == "alfa", "token 18 (user_name) = alfa", p[4 + 17])

        r = enviar(corpo_login_init(token_b, "beta"))
        p = r.split(" ")
        ok(p[4 + 15] == str(id_b), "token 16 (user_id) = perfil da conta B",
           (p[4 + 15], id_b))
        ok(p[4 + 17] == "beta", "token 18 (user_name) = beta", p[4 + 17])

        print("\n[6] token de A com conta B no login_init")
        r = enviar(corpo_login_init(token_a, "beta"))
        ok(campo(r, 2) == "-1", "recusado: nao entrega perfil de outra conta", r[:70])

        print("\n[7] alternancia entre contas nao mistura perfis")
        vistos = []
        for i in range(8):
            tok, nome, esperado = ((token_a, "alfa", id_a) if i % 2 == 0
                                   else (token_b, "beta", id_b))
            rr = enviar(corpo_login_init(tok, nome))
            pp = rr.split(" ")
            vistos.append(pp[4 + 15] == str(esperado) and pp[4 + 17] == nome)
        ok(all(vistos), "8 alternancias mantiveram o isolamento", vistos)

        print("\n[8] sessao apos logout")
        r = enviar(montar(20, "local_logout", token_a, "alfa"))
        ok(campo(r, 2) == "0", "local_logout respondido", r)
        r = enviar(corpo_login_init(token_a, "alfa"))
        ok(campo(r, 2) == "-1", "token revogado nao autentica mais", r[:70])
        r = enviar(corpo_login_init(token_b, "beta"))
        ok(campo(r, 2) == "0", "a OUTRA conta continua valida", r[:40])

        print("\n[9] sessao expirada")
        # Envelhece a sessao da conta beta escrevendo no banco do SERVIDOR
        # (processo dono do arquivo): gera a sessao pelo proprio protocolo
        # (login novo de beta) e depois empurra o vencimento para tras.
        r = enviar(montar(21, "platform_user_login", "beta", "senha123",
                          "com.hyqggw.kkk"))
        token_velho = campo(r, 5)
        ok(campo(r, 2) == "0" and token_velho, "sessao nova de beta emitida")
        import sqlite3
        bconn = sqlite3.connect(os.path.join(tmpdir, "contas.sqlite3"), timeout=10)
        try:
            bconn.execute("UPDATE sessoes SET expira_em = ? WHERE token = ?",
                          (contas.agora_ms() - 1000, token_velho))
            bconn.commit()
        finally:
            bconn.close()
        r = enviar(corpo_login_init(token_velho, "beta"))
        ok(campo(r, 2) == "-1", "sessao expirada recusada", r[:70])

        print("\n[10] token invalido/aleatorio")
        r = enviar(corpo_login_init("A" * 43, "beta"))
        ok(campo(r, 2) == "-1", "token inexistente recusado", r[:70])

        print("\n[11] login por token lembrado rotaciona a sessao")
        r = enviar(montar(30, "platform_user_login", "beta",
                          "@tk1:" + token_b, "com.hyqggw.kkk"))
        novo = campo(r, 5)
        ok(campo(r, 2) == "0" and novo and novo != token_b,
           "novo token emitido", (campo(r, 2), bool(novo)))
        r = enviar(corpo_login_init(token_b, "beta"))
        ok(campo(r, 2) == "-1", "token antigo revogado na rotacao", r[:60])
        r = enviar(corpo_login_init(novo, "beta"))
        ok(campo(r, 2) == "0", "token novo funciona", r[:40])

        print("\n[12] get_system_notice: sem anuncio, sem abrir janela")
        # O cliente abre a janela de anuncio por QUALQUER resposta valida, e no
        # projeto l_naruto essa janela quebra no Axmol (shader). Por isso o
        # sentinela server_number%1000==999 (login.lua:1935) evita o pedido, e
        # a resposta em si e um anuncio VAZIO valido do parser 999.
        r = enviar(montar(40, "get_system_notice", ""))
        ok(campo(r, 2) == "0" and campo(r, 3) == "999",
           "parser 999 respondido (sem dialogo de erro)", r[:50])
        ok(campo(r, 4) == "", "anuncio vazio (nada a exibir)", r[:60])
        # a lista de servidores traz o sentinela do acervo
        rl = enviar(montar(41, "new_get_server_list", "v", "pc", "pkg"))
        pl = rl.split(" ")
        ok(pl[2] == "0" and pl[3] == "58", "lista no parser 58", rl[:60])
        num = int(pl[5])
        ok(num % 1000 == 999,
           "server_number com sentinela 999 (acervo nao pede anuncio)", num)

        print("\n[13] comando obrigatorio desconhecido NAO vira sucesso")
        r = enviar(montar(41, "comando_que_nao_existe", "x"))
        ok(campo(r, 2) == "-3", "status de nao implementado", r)

        print("\n[14] logs nao guardam token nem senha completos")
        time.sleep(0.2)
        logpath = os.path.join(SRV, "server.log")
        with open(logpath, "r", encoding="utf-8", errors="replace") as f:
            tail = f.read()[-200000:]
        ok(token_a not in tail and token_b not in tail,
           "tokens completos ausentes do log")
        ok("senha123" not in tail, "senhas ausentes do log")
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
