# tools/test_local_server.py — CONFERE OS FORMATOS DE RESPOSTA do servidor
# local contra o que os parsers do acervo esperam.
#
# IMPORTANTE: este script fala com um servidor JA RODANDO em 127.0.0.1:18080
# (o mesmo que o jogo usa, ver port/server/jogar_local.bat). Ele NAO sobe o
# seu proprio servidor. Para a suite isolada (porta e banco temporarios) use
# tools/test_contas_e2e.py e tools/test_sessao_perfil.py.
#
# Contrato atual (prioridade 2 — sessao obrigatoria):
#   * vali_register exige sessao valida DA CONTA pedida (existir no banco
#     nao basta); sem token -> -1
#   * login_init sem sessao -> -1 (nunca "Convidado"/user_id fixo)
#   * 9002 exige senha correta e devolve sessao individual em 327
#   * comando desconhecido -> -3 (nao implementado), nunca sucesso generico
#   * apenas a lista SEM_OPERACAO responde ACK neutro
import os
import sys
import time
import urllib.request
import zlib

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                os.pardir, "port", "server"))
from local_server import swap  # noqa: E402

URL = "http://127.0.0.1:18080/iniServer"


def pedido(texto):
    body = swap(zlib.compress(texto.encode("utf-8"), 9))
    req = urllib.request.Request(URL, data=body, method="POST",
                                 headers={"Connection": "close"})
    with urllib.request.urlopen(req, timeout=5) as r:
        assert r.status == 200, r.status
        raw = r.read()
    return zlib.decompress(swap(raw)).decode("utf-8", "replace")


req = "0\r\nnew_get_server_list\r\nteste-ver\r\nop,plataforma,conta\r\npkg,0.0"
resp = pedido(req)
print("[teste] resposta bruta:", resp)
partes = resp.split(" ")
assert len(partes) == 10, partes
assert partes[1] == "new_get_server_list" and partes[2] == "0", partes
assert partes[3] == "58" and partes[4] == "1", partes
assert partes[6] == "Local", partes
assert partes[7] == "http://127.0.0.1:18080/iniServer", partes
assert partes[8] == "1" and partes[9] == "0", partes

# Nome unico: o freio de laco conta repeticoes no processo do servidor, e um
# nome fixo ja estaria acima do limite em execucoes seguidas.
_CMD_FAKE = "comando_inexistente_%d" % (int(time.time() * 1000) % 10**9)
resp2 = pedido("7\r\n%s\r\nx\r\ny\r\nz" % _CMD_FAKE)
print("[teste] comando desconhecido ->", resp2)
p2 = resp2.split(" ")
# Prioridade 4: comando obrigatorio desconhecido NAO vira sucesso generico.
assert p2[1] == _CMD_FAKE and p2[2] == "-3", p2

resp3 = pedido("11\r\nlogin_init\r\nv\r\nop\r\npkg,0.0\r\nacct\r\npwd\r\napp\r\n1")
p3 = resp3.split(" ")
print("[teste] login_init sem sessao ->", resp3[:80])
# Prioridade 2: sem sessao valida nao ha perfil.
# ATENCAO: o servidor roda desde o inicio do script e pode JA ter uma sessao
# lembrada de uma execucao anterior (o token vive enquanto o processo vive).
# Para este teste valer, a sessao e revogada antes — senao "sem sessao" nao
# seria "sem sessao" de verdade.
pedido("99\r\nlocal_logout\r\n\r\n\r\n")
resp3 = pedido("11\r\nlogin_init\r\nv\r\nop\r\npkg,0.0\r\nacct\r\npwd\r\napp\r\n1")
p3 = resp3.split(" ")
assert p3[2] == "-1", resp3
assert "Convidado" not in resp3, resp3

resp4 = pedido("12\r\nuser_create_time\r\n")
p4 = resp4.split(" ")
assert p4[3] == "1602" and len(p4) == 5, p4
print("[teste] user_create_time:", resp4)

# email_init esta em SEM_OPERACAO (callback vazio em LoginLoading.lua:650-653)
resp5 = pedido("13\r\nemail_init\r\nz")
assert resp5.split(" ")[2] == "0", resp5
print("[teste] ACK neutro email_init (lista SEM_OPERACAO):", resp5)

resp6 = pedido("14\r\nvali_register\r\nnao_existe_xyz\r\n1\r\nop\r\n")
assert resp6.split(" ")[2] == "-1", resp6
print("[teste] vali_register recusa conta desconhecida:", resp6)

usuario = "suite_local_1"
senha = "segredo123"
# ESTE TESTE ESCREVE NO BANCO: o platform_user_register abaixo cria a conta.
# Contra o banco de producao isso deixa contas de teste no arquivo da pessoa
# (ja aconteceu: contas "suite_local_1", "menu...", "reg..." acumuladas).
# Por isso a escrita so acontece quando o teste aponta para um banco
# descartavel. Para conferir contra um servidor de verdade, suba-o com
# NR_ACCOUNTS_DIR num diretorio temporario e defina NR_LOCAL_TEST_ALLOW_WRITE=1.
_PODE_ESCREVER = os.environ.get("NR_LOCAL_TEST_ALLOW_WRITE") == "1"
if not _PODE_ESCREVER:
    print("[teste] platform_user_register/vali_register PULADOS: "
          "este script escreve no banco e o alvo atual nao e descartavel. "
          "Defina NR_LOCAL_TEST_ALLOW_WRITE=1 com o servidor apontando para "
          "NR_ACCOUNTS_DIR temporario para executar os passos de escrita.")
    print("[teste] OK (somente leitura): formatos de resposta conferidos")
    sys.exit(0)

resp9 = pedido("18\r\nplatform_user_register\r\n%s\r\n%s\r\n%s\r\npkg"
               % (usuario, senha, senha))
p9 = resp9.split(" ")
if p9[2] == "0":
    assert p9[3] == "326" and p9[4] == usuario and len(p9) == 5, p9
    print("[teste] platform_user_register 326:", resp9)
else:
    assert "ja esta cadastrado" in resp9, resp9
    print("[teste] registro repetido recusado:", resp9)

resp8 = pedido("17\r\nplatform_user_login\r\n%s\r\n%s\r\npkg" % (usuario, senha))
p8 = resp8.split(" ")
assert p8[2] == "0" and p8[3] == "327" and p8[4] == usuario, p8
assert len(p8[5]) == 43, p8
token = p8[5]
print("[teste] platform_user_login 327 (token de sessao, mascarado):",
      p8[0], p8[1], p8[2], p8[3], p8[4], p8[5][:3] + "...")

resp8b = pedido("19\r\nplatform_user_login\r\n%s\r\nsenha_errada\r\npkg" % usuario)
assert resp8b.split(" ")[2] == "-1", resp8b
print("[teste] senha errada recusada:", resp8b)

# Contrato do vali_register:
#  - SEM token no corpo e SEM sessao nesta conexao -> recusado;
#  - DEPOIS de um platform_user_login bem-sucedido -> aceito pelo fallback da
#    sessao da conexao. Nao e furo: o acervo nao manda token em vali_register
#    (login.lua:706 manda so platform_account/server_number/platform/...),
#    entao sem esse fallback TODO GAME START era recusado e o jogador via
#    "Erro desconhecido".
resp6c = pedido("16\r\nvali_register\r\n%s\r\n1\r\nop\r\n" % usuario)
p6c = resp6c.split(" ")
assert p6c[2] == "0" and p6c[7] == usuario, resp6c
print("[teste] vali_register sem token aceito pelo fallback da sessao:", resp6c)

# conta DIFERENTE da sessao continua recusada (o fallback nao serve de passe)
resp6d = pedido("16\r\nvali_register\r\nconta_de_outra_pessoa\r\n1\r\nop\r\n")
assert resp6d.split(" ")[2] == "-1", resp6d
print("[teste] vali_register de outra conta recusado:", resp6d)

# com o token EXPLICITO no corpo: aceito, com o id REAL em platform_id.
# (precisa vir antes do logout, que revoga este token de proposito)
resp6b = pedido("15\r\nvali_register\r\n%s\r\n1\r\nop\r\n%s" % (usuario, token))
p6b = resp6b.split(" ")
assert p6b[2] == "0" and p6b[7] == usuario and len(p6b) == 8, p6b
print("[teste] vali_register com token aceito (platform_id=%s):" % p6b[5], resp6b)

# sem login nenhum nesta conexao -> recusado. Faz logout de verdade
# (C2S 990001), que revoga a sessao e limpa o fallback da conexao.
pedido("30\r\nlocal_logout\r\n\r\n\r\n")
resp6e = pedido("16\r\nvali_register\r\nninguem_autenticado\r\n1\r\nop\r\n")
assert resp6e.split(" ")[2] == "-1", resp6e
print("[teste] vali_register sem login nenhum recusado:", resp6e)

# e depois do logout o token antigo NAO volta a valer
resp6f = pedido("31\r\nvali_register\r\n%s\r\n1\r\nop\r\n%s" % (usuario, token))
assert resp6f.split(" ")[2] == "-1", resp6f
print("[teste] token revogado pelo logout recusado:", resp6f)

# login_init completo (96 tokens) precisa de uma sessao viva: entra de novo,
# porque o logout acima revogou a anterior de proposito.
resp_login = pedido("21\r\nplatform_user_login\r\n%s\r\n%s\r\npkg" % (usuario, senha))
p_login = resp_login.split(" ")
assert p_login[2] == "0" and p_login[3] == "327", p_login
token = p_login[5]

resp7 = pedido("20\r\nlogin_init\r\nv\r\nop\r\n\r\npkg\r\n%s\r\nt4\r\n%s\r\n"
               % (token, usuario))
p7 = resp7.split(" ")
assert len(p7) - 4 == 103, len(p7) - 4
# 96 tokens do parser 3 + o par "12042 <velocidade>" (parser 12042), que
# mantem getUserSpeedSum consistente entre logins (EnvironmentDatas.lua:10467).
assert "12042" in p7, "par 12042 ausente"
assert p7[p7.index("12042")+1].isdigit(), "velocidade ausente"
assert p7[2] == "0" and p7[3] == "3", p7[:4]
assert p7[4 + 17] != "", "user_name vazio"
# user_name e o nome do PERSONAGEM: comeca igual ao nome da conta e passa a
# ser o nome escolhido depois do register (C2S 9). O que nao pode acontecer
# e vir vazio nem ser de outra conta.
assert p7[4 + 17] == usuario or p7[4 + 17].startswith("Ninja_") \
       or p7[4 + 17] == "Teste_Ninja", p7[4 + 17]
print("[teste] login_init com sessao: user_id=%s user_name=%s"
      % (p7[4 + 15], p7[4 + 17]))
assert p7[4 + 15] == p6b[5], (p7[4 + 15], p6b[5])

# login_init_again: MESMO parser do login_init (ProtocolParserCopyExx.lua:815),
# 96 tokens, e o nome do comando tem de ser ecoado de volta — o cliente
# compara list[2].
resp7b = pedido("22\r\nlogin_init_again\r\n%s\r\nv\r\nop\r\n\r\npkg\r\n\r\n"
                "t4\r\n\r\n" % p7[4 + 15])
p7b = resp7b.split(" ")
assert p7b[1] == "login_init_again", p7b[:3]
assert p7b[2] == "0" and p7b[3] == "3", p7b[:4]
assert len(p7b) - 4 == 103, len(p7b) - 4
assert "12042" in p7b, "par 12042 ausente no login_init_again"
print("[teste] login_init_again: parser 3 + 12042, cmd ecoado")
assert p7b[4 + 17] != "", "user_name vazio no login_init_again"
assert p7b[4 + 17] == p7[4 + 17], (p7b[4 + 17], p7[4 + 17])
print("[teste] login_init_again: parser 3 + 12042, cmd ecoado")

# get_random_name: parser 51, UM token (ProtocolParserCopy.lua:3214-3216).
# Ocorre na criacao de personagem; sem ela o cliente abria dialogo de erro.
resp7c = pedido("23\r\nget_random_name\r\n0\r\n")
p7c = resp7c.split(" ")
assert p7c[2] == "0" and p7c[3] == "51", p7c
assert len(p7c) == 5 and p7c[4] != "", p7c
print("[teste] get_random_name: parser 51, nome=%s" % p7c[4])

# register (C2S 9) -> parser 2, UM token (user_id, ProtocolParserCopy.lua:57).
# E o passo de criar o primeiro personagem (LoginLoading.lua:212 entra nele
# com user_grade 1 / user_experience 0). Sem resposta o cliente ficava em
# laco erro->relogin->register, o que o jogador via como carregamento travado.
resp7d = pedido("24\r\nregister\r\n%s\r\n%s\r\nudid\r\nTeste_Ninja\r\n"
                "1\r\n1\r\n1\r\npkg\r\n1\r\n\r\n" % (usuario, senha))
p7d = resp7d.split(" ")
assert p7d[1] == "register" and p7d[2] == "0" and p7d[3] == "2", p7d
assert len(p7d) == 5 and p7d[4].isdigit(), p7d
print("[teste] register: parser 2, user_id=%s (nome do personagem salvo)"
      % p7d[4])
# o personagem fica gravado no perfil da conta (token 18 do login_init).
# O nome tem de ser DIFERENTE do que ja esta no perfil para provar a
# gravacao, senao uma execucao anterior satisfaz o teste por acidente.
resp_antes = pedido("26\r\nlogin_init\r\nv\r\nop\r\n\r\npkg\r\n\r\nt4\r\n\r\n")
nome_antes = resp_antes.split(" ")[4 + 17]
novo_nome = "Ninja_%s" % ("B" if nome_antes != "Ninja_B" else "C")
pedido("27\r\nregister\r\n%s\r\n%s\r\nudid\r\n%s\r\n1\r\n1\r\n1\r\npkg\r\n1\r\n\r\n"
       % (usuario, senha, novo_nome))
resp7e = pedido("28\r\nlogin_init\r\nv\r\nop\r\n\r\npkg\r\n\r\nt4\r\n\r\n")
p7e = resp7e.split(" ")
assert p7e[4 + 17] == novo_nome, (p7e[4 + 17], novo_nome)
print("[teste] apelido do personagem persistido no perfil: %s -> %s"
      % (nome_antes, p7e[4 + 17]))

# --- batalha -----------------------------------------------------------------
# battle_result_start (C2S 328): o callback do acervo le ZERO campos
# (Mission.lua:2379-2398) e nao existe parser S2C para 328 em
# ProtocolParser.lua. Sucesso com eco e o contrato.
resp_brs = pedido("29\r\nbattle_result_start\r\n%s\r\n0\r\n1\r\n1196\r\n1\r\n"
                  "1,4008,1,2" % p7e[4 + 15])
p_brs = resp_brs.split(" ")
assert p_brs[1] == "battle_result_start" and p_brs[2] == "0", p_brs
print("[teste] battle_result_start: status 0 (sem parser, como o acervo)")

# battle_field_init (C2S 19) -> parser 182 com dados REAIS das tabelas do
# acervo (npc.txt -> environment_formation.txt -> environment_ship.txt).
resp_bfi = pedido("30\r\nbattle_field_init\r\n1\r\n1196\r\n1\r\n1,4008,1,2")
p_bfi = resp_bfi.split(" ")
assert p_bfi[2] == "0" and p_bfi[3] == "182", p_bfi[:4]
assert len(p_bfi) - 4 > 20, len(p_bfi) - 4
# NPC 1196 tem 2 formacoes no acervo (4009 e 4010)
assert p_bfi[4 + 3] == "2", p_bfi[4:4 + 4]
print("[teste] battle_field_init: parser 182 com %d tokens, %s batalhas"
      % (len(p_bfi) - 4, p_bfi[4 + 3]))

# NPC sem formacao nas tabelas: recusa honesta, nunca batalha vazia
resp_bfi2 = pedido("31\r\nbattle_field_init\r\n1\r\n99999999\r\n1\r\n0")
assert resp_bfi2.split(" ")[2] == "-1", resp_bfi2
print("[teste] battle_field_init de npc inexistente recusado:", resp_bfi2)

print("[teste] OK: parser 58, 1602, 326/327, ACK neutro so da lista, "
      "status -3 para desconhecido, sessao obrigatoria em vali_register/login_init, "
      "login_init_again 3+12042, get_random_name 51, register 2, "
      "battle_result_start e battle_field_init 182")
