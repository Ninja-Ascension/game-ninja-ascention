# Fase 2 — servidor LOCAL de protocolo mínimo (permissão única aprovada).
# Escopo (ver port/server/data_minimos.txt):
#   * escuta SOMENTE em 127.0.0.1:18080 (nenhum contato com rede externa)
#   * fala o protocolo do acervo: pedido = zlib(deflate) + swap-modo-0;
#     resposta do mesmo jeito
#   * responde new_get_server_list com 1 servidor "Local" 127.0.0.1:18080
#   * comandos desconhecidos -> ACK neutro "seq cmd 0" (status 0, SEM
#     código de parser: NetworkProtocol.lua:145-148 trata como sucesso
#     sem diálogo; log marcado [AVISO] para virar resposta real depois)
# Nada de conteúdo de gameplay é criado aqui.
import http.server
import os
import threading
import urllib.parse
import re
import zlib
import sys
from datetime import datetime as _dt
from time import time as st_time

# Endereco de escuta. Padrao: so esta maquina. Qualquer outro valor (ou
# NR_EXIGIR_SESSAO=1) liga o MODO PUBLICO: cada pedido precisa trazer a chave
# da sessao (?s=<token> no endereco), sem sessao global nem conta "lembrada".
HOST = os.environ.get("NR_HOST", "127.0.0.1")
MODO_PUBLICO = (HOST not in ("127.0.0.1", "localhost", "::1")
                or os.environ.get("NR_EXIGIR_SESSAO", "0") == "1")
# 18080 por padrao; NR_PORT deixa a suite de testes subir uma instancia
# isolada numa porta livre sem brigar com a de producao.
PORT = int(os.environ.get("NR_PORT", "18080"))

def _pad0(b):
    r = len(b) % 8
    return b + b"\x00" * (8 - r) if r else b

def swap(data):
    """modo 0 do Blowfish do acervo: troca as metades de cada bloco de 8."""
    d = _pad0(data)
    out = bytearray(len(d))
    for o in range(0, len(d) - 7, 8):
        out[o:o + 4] = d[o + 4:o + 8]
        out[o + 4:o + 8] = d[o:o + 4]
    return bytes(out)

def wrap(text):
    return swap(zlib.compress(text.encode("utf-8"), 9))

def unwrap(body):
    return zlib.decompress(swap(body)).decode("utf-8", "replace")

# --- batalha: battle_result_start (328) e battle_field_init (19) ------------
# O ciclo login -> primeira batalha parava aqui: o cliente mandava
# battle_result_start, recebia -3 e reiniciava o login em laco.
#
# Os dois callbacks do acervo LEEM ZERO CAMPOS:
#   * responseBattleStartCallback  (Mission.lua:2379-2398) so testa
#     RESPONSE_SUCCESS e PROTOCOL_STATUS >= 0 e chama battle_field_init;
#   * responseBattleFieldInitCallback (Mission.lua:2280-2314) so testa os
#     mesmos dois campos e abre a cena Fight.
# Por isso battle_result_start nao tem parser S2C em ProtocolParser.lua:
# a resposta certa e ACK de sucesso, sem token nenhum. Isso NAO e "sucesso
# vazio" para esconder buraco: e o contrato, e o -3 anterior e que estava
# errado (ProtocolParser.lua nao registra parser para 328; confere-se por
# ausencia de "battle_result_start" na tabela de parsers).
#
# battle_field_init TEM parser (182, ProtocolParserCopy.lua:6450-6700) e
# precisa de dados reais: sao montados por dados_batalha.py a partir das
# tabelas do proprio acervo (npc/environment_formation/environment_ship).

def _estado_batalha_da_conexao():
    """Batalha iniciada nesta sessao: {npc, dificuldade, total, indice}."""
    return _BATALHA_ATUAL.setdefault(_sessao_da_conexao() or "local", {})


# Uma batalha em andamento por sessao (antes era uma unica para o servidor).
_BATALHA_ATUAL = {}


def _guardar_batalha(npc_id, dificuldade, total):
    atual = _estado_batalha_da_conexao()
    atual.clear()
    atual.update({
        "npc": str(npc_id), "dificuldade": str(dificuldade or "0"),
        "total": int(total or 0), "indice": 0,
    })


def handle_battle_result_start(seq, texto=""):
    """battle_result_start (C2S 328) -> ACK de sucesso (sem parser).

    Pedido (Mission.lua:2400):
      seq \\r\\n battle_result_start \\r\\n <user_id> \\r\\n <fight_type> \\r\\n
      <scene_id> \\r\\n <npc_id> \\r\\n <dificuldade> \\r\\n <senderStr>
    """
    l = _linhas(texto)
    try:
        tipo = l[1].strip() if len(l) > 1 else "0"
        cena = l[2].strip() if len(l) > 2 else "0"
        npc = l[3].strip() if len(l) > 3 else "0"
        dificuldade = l[4].strip() if len(l) > 4 else "0"
        remetente = l[5].strip() if len(l) > 5 else ""
    except Exception:
        tipo, cena, npc, dificuldade, remetente = "0", "0", "0", "0", ""
    try:
        formacoes, _ = _dados_batalha.formacao_do_npc(npc)
    except Exception as exc:
        log("battle_result_start: falha lendo tabelas para npc=%s: %s"
            % (npc, exc))
        formacoes = []
    if not formacoes:
        # NPC sem formacao no acervo: recusar honestamente e melhor que
        # abrir uma batalha sem inimigos (que travaria dentro do Fight).
        log("battle_result_start RECUSA npc=%s sem formacao nas tabelas" % npc)
        return recusa("battle_result_start", seq, "npc_sem_formacao")
    _guardar_batalha(npc, dificuldade, len(formacoes))
    log("battle_result_start tipo=%s cena=%s npc=%s dif=%s sender=%s "
        "-> %d batalha(s)" % (tipo, cena, npc, dificuldade, remetente,
                              len(formacoes)))
    # NAO anexar o parser 6020 aqui. Motivos medidos no acervo:
    #  * o callback de battle_result_start (Mission.lua:2379-2398) le ZERO
    #    campos: so testa RESPONSE_SUCCESS e PROTOCOL_STATUS >= 0;
    #  * o codigo 6020 significa parse_user_scene_states no S2C
    #    (ProtocolParser.lua:3107) e alimenta _ED.scene_max_state, lido
    #    pelas telas de MENU de PVE (Menu.lua:648, PVEStage.lua:356,
    #    LPVEScene.lua:365) — nao pelo fluxo de batalha;
    #  * envia-lo aqui gerava uma resposta de 5026 caracteres (quatro
    #    vetores) para uma chamada que espera ACK, e o cliente FECHAVA
    #    durante o processamento (ultimo HOST_XHR sem resposta no log).
    # O estado de cenas vai no login_init (ver resposta_login_init).
    return " ".join([seq, "battle_result_start", "0"])


def handle_battle_result_fail(seq, texto=""):
    """battle_result_fail (C2S 6100): acknowledge a lost PVE fight safely.

    The original client sends user_id, scene_id, npc_id and formation data;
    it expects no parser payload. A loss grants no rewards or progress and
    releases the pending battle so another attempt can start.
    """
    try:
        session = BANCO.sessao_de(_sessao_da_conexao())
        lines = _linhas(texto)
        if not lines or lines[0].strip() != str(BANCO.perfil(session["conta_id"])["user_id"]):
            raise ValueError("perfil_invalido")
        account = session["conta_id"]
        if len(lines) >= 3 and lines[1].strip().isdigit() and lines[2].strip().isdigit():
            scene, npc = int(lines[1]), int(lines[2])
            with BANCO._lock, BANCO._conn:
                pending = BANCO._conn.execute(
                    "SELECT scene,npc FROM local_battle_pending WHERE conta_id=?",
                    (account,)).fetchone()
                if pending and tuple(pending) != (scene, npc):
                    raise ValueError("batalha_invalida")
                BANCO._conn.execute("DELETE FROM local_battle_pending WHERE conta_id=?", (account,))
        log("battle_result_fail conta=%s sem recompensa" % account)
        return "%s battle_result_fail 0" % seq
    except (_contas.ErroConta, ValueError) as exc:
        return recusa("battle_result_fail", seq, str(exc))


def _herois_da_formacao_batalha(conta_id, usuario, nome):
    """Herois do jogador para o parser 182 (delegado ao modulo de formacao).

    Fica aqui, no local_server, porque battle_field_init e registrado aqui e
    este modulo nao e recarregado — mas a LOGICA mora em recruitment_local,
    que le a formacao salva. Import tardio: se o modulo de formacao falhar,
    a batalha recusa com motivo em vez de derrubar o servidor.
    """
    try:
        import recruitment_local
        return recruitment_local.herois_da_formacao(BANCO, conta_id, usuario, nome)
    except Exception as exc:
        log("battle_field_init: erro lendo formacao: %s" % exc)
        return []


def handle_battle_field_init(seq, texto=""):
    """battle_field_init (C2S 19) -> parser 182 com dados das tabelas.

    Pedido (ProtocolCommanderCopy.lua:268):
      seq \\r\\n battle_field_init \\r\\n <user_id> \\r\\n <battle_init_type> \\r\\n
      <scene_id> \\r\\n <npc_id> \\r\\n <dificuldade> \\r\\n <senderStr>
    """
    # ProtocolCommanderCopy.lua includes user_id and _battle_init_type before
    # the scene parameters. The previous handler read those two fields as the
    # scene/NPC, so real client requests (unlike the old local test fixture)
    # could never select the challenge opponent.
    l = _linhas(texto)
    token = _sessao_da_conexao()
    try:
        sessao = BANCO.sessao_de(token)
        if len(l) < 5 or l[0].strip() != str(BANCO.perfil(sessao["conta_id"])["user_id"]):
            raise ValueError("perfil_invalido")
        cena, npc, dificuldade = l[2].strip(), l[3].strip(), l[4].strip()
        if not (cena.isdigit() and npc.isdigit() and dificuldade.isdigit()):
            raise ValueError("batalha_invalida")
        npc_row = _dados_batalha.tabela("npc.txt").get(npc)
        if not npc_row or str(cena) != npc_row[107]:
            raise ValueError("npc_fora_da_cena")
    except (_contas.ErroConta, ValueError) as exc:
        return recusa("battle_field_init", seq, str(exc))

    perfil = BANCO.perfil(sessao["conta_id"])
    usuario = str(perfil["user_id"])
    nome = perfil.get("user_name") or sessao["nome"]

    # Herois do jogador: a FORMACAO REAL, nos moldes do cliente.
    #
    # O parser 182 indexa por POSICAO (ProtocolParserCopy.lua:6551:
    #   battleData._heros[_hero._pos] = _hero)
    # e usa _mouldId para carregar o modelo 3D. Antes o servidor mandava um
    # unico heroi ficticio com _pos="1" e _mouldId="0": o cliente tentava
    # montar a cena com um modelo inexistente e o NPC nao abria (o "lobo").
    jogador = _herois_da_formacao_batalha(sessao["conta_id"], usuario, nome)
    if not jogador:
        log("battle_field_init RECUSA conta=%s: formacao vazia" % sessao["nome"])
        return recusa("battle_field_init", seq, "formacao_vazia")
    try:
        toks = _dados_batalha.montar_parser_182(
            npc, dificuldade, jogador, nome, 10000)
    except Exception as exc:
        log("battle_field_init: erro montando parser 182 npc=%s: %s"
            % (npc, exc))
        toks = None
    if toks is None:
        log("battle_field_init RECUSA npc=%s sem dados completos nas tabelas"
            % npc)
        return recusa("battle_field_init", seq, "npc_sem_dados_de_batalha")
    log("battle_field_init conta=%s cena=%s npc=%s dif=%s -> parser 182 "
        "(%d tokens)" % (sessao["nome"], cena, npc, dificuldade, len(toks)))
    return " ".join([seq, "battle_field_init", "0", "182"] + toks)

# Instante em que ESTE processo subiu: e o "open_server_time" verdadeiro deste
# servidor local (ver resposta_system_time). Definido aqui, antes de qualquer
# handler, para nao depender da ordem de execucao do modulo.
SERVIDOR_INICIADO_EM = st_time()

# Nome exibido na lista. O protocolo separa campos por espaco ASCII; o espaco
# inseparavel (U+00A0) aparece igual na tela e nao divide o campo.
NOME_SERVIDOR = os.environ.get("NR_SERVER_NAME", "Servidor 1").replace(" ", "\u00a0")
_HOST_VALIDO = re.compile(r"^[A-Za-z0-9.\-]+(:[0-9]{1,5})?$")


def endereco_publico():
    """server_link que o cliente usa depois da lista (login_vali_register,
    login_init). Antes era sempre 127.0.0.1, o que so funciona na propria
    maquina. Agora: NR_PUBLIC_URL, ou o Host pelo qual o jogador chegou."""
    fixo = os.environ.get("NR_PUBLIC_URL")
    if fixo:
        return fixo
    host = getattr(_pedido, "host", None)
    if not host or not _HOST_VALIDO.match(host):
        host = "127.0.0.1:%d" % PORT
    elif ":" not in host:
        # O XHR nativo do cliente manda o Host SEM a porta; sem ela o jogo
        # tentaria a porta 80 (medido: "HOST_NET_GUARD bloqueado ->
        # http://181.215.236.218/iniServer").
        host = "%s:%d" % (host, PORT)
    return "http://%s/iniServer" % host


def resposta_lista_servidores(seq):
    # 1 servidor, tipo 1 (normal), estado de atualizacao 0 (sem campo extra
    # no parser 58). server_number = 999: sentinela do PROPRIO acervo para
    # "nao mostrar anuncio" (login.lua:1935), que evita GameAnnouncement.lua,
    # quebrado no Axmol. server_link: URL completo, usado verbatim no XHR
    # (no Windows o NetworkManager nao prefixa http://).
    return " ".join([seq, "new_get_server_list", "0", "58", "1", "999",
                     NOME_SERVIDOR, endereco_publico(), "1", "0"])

MINIMOS = {
    # dados mínimos ROTULADOS aprovados em permissão única:
    # 1 servidor: nome "Local", link 127.0.0.1:18080, tipo 1 (normal),
    # estado de atualização 0 (não consome campo extra no parser 58).
    #
    # server_number = 999: é o sentinela do PRÓPRIO acervo para "não mostrar
    # anúncio" (login.lua:1935: zstring.tonumber(v.server_number)%1000==999
    # => isShowData=false). Sem ele o cliente pede get_system_notice e abre a
    # janela de anúncio, que no projeto l_naruto usa GameAnnouncement.lua e
    # quebra no Axmol ("Shader compile failed", GameAnnouncement.lua:247),
    # derrubando o fluxo de login. Com o sentinela o pedido nem parte.
    "new_get_server_list": lambda seq: resposta_lista_servidores(seq),
    # keep-alive: eco neutro status 0 (sem tokens seguintes -> nenhum parser,
    # nenhum diálogo; NetworkManager.lua registerKeepAlive)
    "keep_alive": lambda seq: " ".join([seq, "keep_alive", "0"]),
    # record_crash: ACK neutro status 0 (o cliente reporta o crash anterior
    # do UserDefault no boot; eco sem dado nenhum; evita abrir o diálogo de
    # rede repetidamente conforme o protocolo original).
    "record_crash": lambda seq: " ".join([seq, "record_crash", "0"]),
}


def handle_get_random_name(seq, texto=""):
    """get_random_name (C2S 6) -> parser 51 (ProtocolParserCopy.lua:3214-3216).

    O parser lê UM token e guarda em _ED.current_random_name. Pedido:
    `seq \\r\\n get_random_name \\r\\n <selectIndex>` — o índice só escolhe o
    estilo do nome no servidor oficial.

    Ocorre na tela de criação de personagem, logo depois do login. Sem
    resposta válida o cliente abre o diálogo de erro de protocolo (era o que
    aparecia ao jogador assim que o carregamento terminava).
    """
    l = _linhas(texto)
    indice = l[0].strip() if l and l[0] else "0"
    try:
        semente = int(indice)
    except ValueError:
        semente = 0
    # Sorteado e unico no servidor: com varios jogadores, um nome fixo por
    # indice fazia todos virarem "Kage_Ninja".
    import random
    prefixos = ["Kage", "Shinobi", "Ryu", "Hana", "Tora", "Sora", "Kaze"]
    sufixos = ["Ninja", "Ronin", "Sensei", "Shogun", "Musha", "Kunoichi"]
    nome = BANCO.apelido_livre("%s_%s" % (random.choice(prefixos), random.choice(sufixos)))
    log("get_random_name indice=%s -> %s" % (indice, nome))
    return " ".join([seq, "get_random_name", "0", "51", nome])


def resposta_register(seq, texto=""):
    """register (C2S 9, register_game_account) -> parser 2 parse_register.

    parser 2 lê UM token (ProtocolParserCopy.lua:57-67): o user_id do
    personagem. É o passo de "criar o primeiro personagem": o LoginLoading
    entra nele quando o login_init devolve user_grade 1 e user_experience 0
    ("l1e0", LoginLoading.lua:212), e o callback (responseStartGame) só segue
    para o menu depois desta resposta.

    Como o servidor recusava (-3 nao_implementado), o cliente ficava em laço:
    erro de protocolo -> relogin -> register -> erro. Era a "tela de
    carregamento travada".

    Pedido (LoginLoading.lua:106-126):
      account \\r\\n password \\r\\n udid \\r\\n userName \\r\\n avatar \\r\\n
      camp \\r\\n gender \\r\\n appName \\r\\n server \\r\\n invite

    O user_id devolvido é o do PERFIL da conta (o personagem pertence à
    conta). O nome escolhido é gravado no perfil, para o jogador reencontrar
    o próprio personagem ao voltar.
    """
    l = _linhas(texto)
    conta = l[0].strip() if len(l) > 0 else ""
    apelido = l[3].strip() if len(l) > 3 else ""
    try:
        sessao = BANCO.sessao_de(_sessao_da_conexao(), conta)
    except _contas.ErroConta as e:
        return recusa("register", seq, "conta_nao_autenticada (%s)" % e.codigo)
    perfil = BANCO.perfil(sessao["conta_id"])
    user_id = str(perfil["user_id"])
    with BANCO._lock:
        renamed = BANCO._conn.execute('SELECT 1 FROM local_profile_edits WHERE conta_id=?',(sessao['conta_id'],)).fetchone()
    if apelido and not renamed:
        try:
            BANCO.definir_apelido(sessao["conta_id"],
                                  BANCO.apelido_livre(apelido, sessao["conta_id"]))
        except Exception as e:                      # nunca derruba o login
            log("register: nao gravei apelido (%s)" % e)
    log("register conta=%s user_id=%s apelido=%s"
        % (sessao["nome"], user_id, apelido or "-"))
    return " ".join([seq, "register", "0", "2", user_id])


def resposta_login_init_again(seq, texto=""):
    """login_init_again (C2S 95) -> parser parse_return_all_user_info.

    ProtocolParserCopyExx.lua:815 confirma que `login_init_again` usa o MESMO
    parser que `login_init` (o que muda é só o comando). Por isso a resposta
    é a mesma forma de 96 tokens, reaproveitando resposta_login_init — nada é
    inventado aqui.

    O pedido é: `seq \\r\\n login_init_again \\r\\n <user_id> \\r\\n <param_list>`
    (ProtocolCommanderCopy.lua:1297-1303), onde param_list é o mesmo bloco do
    login_init. O user_id explícito não é usado como identidade: a conta vem
    da sessão, como em todo o resto.
    """
    return resposta_login_init(seq, texto, nome_cmd="login_init_again")

# Services do LoginLoading (ramo l_naruto) com callbacks vazios/nil: o eco
# status 0 SEM tokens seguintes não dispara nenhum parser S2C (o loop do
# parser_func não acha código) e o estado local fica neutro.
def _eco_neutro(cmd):
    def _eco(seq):
        return " ".join([seq, cmd, "0"])
    return _eco

# union_init NAO esta mais aqui: virou resposta real (resposta_union_init,
# junto ao registro em MINIMOS). Responder vazio deixava union_grade nil e o
# cadeado da tela FIGHT nunca saia.
for _cmd in ["ship_purify_init", "email_init",
             "keep_alive", "record_crash"]:
    if _cmd not in MINIMOS:
        MINIMOS[_cmd] = _eco_neutro(_cmd)

# user_create_time (código 560): parser 1602 consome 1 token
# os.date consumers expect seconds, using the persisted character creation.
def resposta_user_create_time(seq,texto=""):
    try:
        session=BANCO.sessao_de(_sessao_da_conexao())
        created=BANCO.perfil(session['conta_id'])['criada_em']//1000
        return ' '.join([seq,'user_create_time','0','1602',str(created)])
    except _contas.ErroConta as exc:
        return recusa('user_create_time',seq,exc.codigo)
MINIMOS['user_create_time']=resposta_user_create_time

# ---- vali_register (código 7 -> parser 57, ProtocolParserCopy.lua 3366+) ----
# register_type 2 monta a sessão convidada local (nickname/padrões do próprio
# código do parser): tokens "2 isRegister platform_id platform_account".
# isRegister=1 => is_registered=true => login.lua:575 excuta login_enter_game.
# platform_account ECOA o que o jogo mandou (linha 2 do pedido) para o
# login_init validar a mesma conta; fallback convidado_local (data_minimos).
def _conta_autenticada(nome):
    """Devolve o nome canônico se `nome` é uma conta real do banco; senão None."""
    chave = _contas.normalizar_nome(nome)
    if chave == "":
        return None
    with BANCO._lock:
        row = BANCO._conn.execute(
            "SELECT display_name FROM contas WHERE nome = ?", (chave,)).fetchone()
    return row["display_name"] if row else None


def _contas_por_nome(nome):
    """{id, nome} da conta canônica, ou None se ela não existe."""
    chave = _contas.normalizar_nome(nome)
    if chave == "":
        return None
    with BANCO._lock:
        row = BANCO._conn.execute(
            "SELECT id, display_name FROM contas WHERE nome = ?", (chave,)).fetchone()
    return {"id": row["id"], "nome": row["display_name"]} if row else None


def resposta_vali_register(seq, texto=""):
    # Pedido (login.lua:706/708/745):
    #   seq \r\n vali_register \r\n platform_account \r\n server_number \r\n ...
    # platform_account é a conta autenticada (m_sUin gravado pelo 327).
    #
    # EXISTIR NO BANCO NAO COMPROVA AUTENTICACAO: este comando agora exige
    # uma sessao de servidor valida. O token chega no proprio pedido porque
    # o cliente ja o reenvia (userLoginToken, ProtocolParser.lua:1197 ->
    # command_login_init/ProtocolCommanderCopy.lua:119); se algum caminho
    # não mandar, cai para a sessão da conexão (última 327 desta máquina,
    # ver _sessao_da_conexao). Sem sessão -> recusa.
    conta, token = _identidade_do_pedido(texto)
    if conta is None:
        linhas = [x.strip() for x in (texto or "").split("\r\n")]
        conta = linhas[2] if len(linhas) > 2 else ""
    if not token:
        token = _sessao_da_conexao()
    try:
        sessao = BANCO.sessao_de(token, conta)
    except _contas.ErroConta as e:
        return recusa("vali_register", seq,
                      "conta_nao_autenticada (%s)" % e.codigo)
    log("vali_register conta=%s sessao=%s" % (sessao["nome"], _mascarado(token)))
    # Parser 57 reads register_type, isRegister, platform_id, account.
    # All authenticated accounts already own their persisted initial profile.
    # An account ID here (e.g. 62) is not the boolean "1": it starts character
    # creation again and its tutorial callback stalls when tutorials are off.
    return " ".join([seq, "vali_register", "0", "57",
                     "2", "1", str(sessao["conta_id"]), sessao["nome"]])

def _conta_do(texto, padrao="convidado_local"):
    try:
        linhas = [x.strip() for x in texto.split("\r\n")]
        if len(linhas) > 2 and linhas[2]:
            return linhas[2]
    except Exception:
        pass
    return padrao

# ---- S2C 327 (ProtocolParser.lua:1193-1244) ----
# Consumido por search_user_platform (C2S 3, janela de conta) e
# platform_user_login (C2S 9002: AccountSysManager:161). Tokens:
# m_sUin, userLoginToken, userLoginPackageName, userAccountCreateTime.
# O parser monta user_platform[conta], seta m_sUin e excuta
# login_get_server_list no fim — é o que autentica a conta do sistema
# próprio (config_operation.AccountManager = true).
#
# ADAPTAÇÃO (documentada em data_minimos item 09): o token passa a ser a
# sessão individual e imprevisível do banco (43 chars base64url, que é o
# formato que account_sys_valid_token exige, AccountSysManager.lua:38-41).
# No login por token, o campo da senha chega como "@tk1:<token>"
# (account_sys_login_secret, AccountSysManager.lua:60-70).
import contas as _contas
import dados_batalha as _dados_batalha
from gameplay_mode import tutorial_enabled

PKG = "com.hyqggw.kkk"
_token_por_conta = {}   # conta_id -> último token emitido (só para /sair)


def resposta_327(cmd, seq, conta, token, criada_ms):
    return " ".join([seq, cmd, "0", "327",
                     conta, token, PKG, str(criada_ms)])


def recusa(cmd, seq, mensagem):
    """Status negativo: o cliente abre a caixa de erro (NetworkProtocol.lua:184).

    Usado APENAS para credenciais/registro inválidos — comandos
    desconhecidos continuam com ACK neutro.
    """
    log("recusa cmd=%s seq=%s motivo=%s" % (cmd, seq, mensagem))
    return " ".join([seq, cmd, "-1", mensagem])


def _linhas(texto):
    """Linhas do pedido depois do cabeçalho (seq, cmd).

    O pedido completo é: seq \r\n cmd \r\n <corpo...>  (ver despacha), então
    o corpo começa na linha 2 — as funções antigas do arquivo usavam essa
    mesma convenção (linhas[2] = conta).
    """
    return [x.strip() for x in (texto or "").split("\r\n")][2:]


def _mascarado(s):
    """Nunca registrar token/senha completa: só o começo, para depurar."""
    if not s:
        return "''"
    if len(s) <= 6:
        return "'***'"
    return "'%s...(%d)'" % (s[:3], len(s))


def _identidade_do_pedido(texto):
    """Extrai (conta, token) do corpo de um pedido já autenticado.

    Layout medido em command_login_init (ProtocolCommanderCopy.lua:100-129):
      seq, cmd, <versao>, <idioma>, <param_list>, <userLoginPackageName>,
      <userLoginToken>, <getPlatformParam()>, <m_sUin>, <m_sSessionId>
    ou seja, no corpo (_linhas):  0 versao, 1 idioma, 2 param_list,
      3 userLoginPackageName, 4 userLoginToken, 5 platformParam,
      6 m_sUin (conta), 7 m_sSessionId

    Para vali_register (login.lua:706/708/745) o corpo é
      0 platform_account, 1 server_number, 2 plataforma, 3 tipo
    A conta e o token são procurados nos DOIS formatos, sem depender de um
    comando específico: a conta é o primeiro campo que casa com um nome
    cadastrado e o token é o primeiro que parece um token de sessão.
    """
    l = _linhas(texto)
    conta = None
    token = None
    for campo in l:
        if token is None and _contas.token_valido(campo):
            token = campo
        elif conta is None and campo and _conta_autenticada(campo) is not None:
            conta = campo
    return conta, token


def handle_platform_user_register(seq, texto):
    """platform_user_register (C2S 9001, AccountSysRegister.lua:64-74).

    Pedido: usuario \r\n senha \r\n confirmacao \r\n <PackageName>
    Resposta: 326 (ProtocolParser.lua:1161-1188), token m_sUin.
    """
    l = _linhas(texto)
    nome = l[0] if len(l) > 0 else ""
    senha = l[1] if len(l) > 1 else ""
    confirmacao = l[2] if len(l) > 2 else ""
    try:
        conta = BANCO.criar_conta(nome, senha, confirmacao)
    except _contas.ErroConta as e:
        return recusa("platform_user_register", seq, e.mensagem)
    log("conta criada id=%d nome=%s..." % (conta["id"], conta["nome"][:3]))
    return " ".join([seq, "platform_user_register", "0", "326", conta["nome"]])


def handle_platform_user_login(seq, texto):
    """platform_user_login (C2S 9002, AccountSysManager.lua:150-161).

    Pedido: usuario \r\n segredo \r\n <PackageName>
    segredo = senha em texto, ou "@tk1:<token>" para sessão lembrada.
    Resposta: 327 com token NOVO (sessão individual).
    """
    l = _linhas(texto)
    nome = l[0] if len(l) > 0 else ""
    segredo = l[1] if len(l) > 1 else ""
    try:
        if segredo.startswith(_contas.TOKEN_SEGREDO_PREFIXO):
            token_antigo = segredo[len(_contas.TOKEN_SEGREDO_PREFIXO):]
            try:
                sessao = BANCO.sessao_de(token_antigo, nome)
            except _contas.ErroConta:
                if MODO_PUBLICO:
                    # Em rede aberta, saber o nome da conta nao basta: o
                    # jogador digita a senha de novo.
                    raise
                # O cliente guardou um token que este servidor não conhece mais
                # (banco recriado, sessão revogada/expirada). Recusar aqui deixa
                # o jogador preso: o jogo só mostra "Sessao invalida." e repete.
                # A conta existe e é a mesma, então a sessão é reemitida — a
                # identidade vem do banco, não do token velho.
                conta = _contas_por_nome(nome)
                if conta is None:
                    raise
                log("token lembrado invalido para conta=%s: reemitindo sessao" % nome)
            else:
                conta = {"id": sessao["conta_id"], "nome": sessao["nome"]}
                # Reuso do token lembrado: a sessão antiga é revogada e uma nova
                # é emitida, então um token vazado não fica válido para sempre.
                BANCO.revogar_sessao(token_antigo)
        else:
            conta = BANCO.autenticar(nome, segredo)
    except _contas.ErroConta as e:
        if segredo.startswith(_contas.TOKEN_SEGREDO_PREFIXO):
            # -68: AccountSysManager.lua:133-145 esquece o token guardado e
            # mostra a janela de conta de novo (login automatico vencido).
            log("recusa cmd=platform_user_login seq=%s motivo=token_lembrado_invalido" % seq)
            return " ".join([seq, "platform_user_login", "-68", e.mensagem])
        return recusa("platform_user_login", seq, e.mensagem)
    token = BANCO.abrir_sessao(conta["id"])
    perfil = BANCO.perfil(conta["id"])
    # Lembra a sessão recém-emitida. O acervo NÃO manda token em vali_register
    # (login.lua:706 manda só platform_account, server_number, platform,
    # user_account_platform), então ele precisa cair no fallback da sessão da
    # conexão. Sem esta linha o fallback era sempre None e TODO GAME START era
    # recusado com "Erro desconhecido" na tela — foi exatamente o que
    # aconteceu no teste do usuário. Continua não sendo fonte de verdade:
    # sessao_de() revalida (revogada/expirada é recusada) e o token só vale
    # para este processo em 127.0.0.1.
    lembrar_token(token)
    log("login ok conta=%s sessao=%s perfil_user_id=%d" % (
        conta["nome"], _mascarado(token), perfil["user_id"]))
    return resposta_327("platform_user_login", seq, conta["nome"], token,
                        _contas.agora_ms())


def handle_search_user_platform(seq, texto):
    """search_user_platform (C2S 3): consulta a conta lembrada pelo cliente.

    COMPORTAMENTO DO CLIENTE (login.lua:1737-1766) — o que estava travando:
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            ... abre a janela de conta OU entra automaticamente ...
        end
    Fora desse `if` NÃO existe `else`. Se o servidor recusa (status negativo),
    a callback não faz nada e a tela de login fica parada esperando — era o
    "erro" ao abrir o jogo. Por isso, quando existe conta salva neste servidor
    local, a resposta é de SUCESSO (327) mesmo sem token lembrado: quem decide
    entre "pedir senha" e "entrar direto" é a flag
    platform_account_Automatic_login (login.lua:1741).

    Sem nenhuma conta no banco a recusa é correta: é o fluxo de primeira
    execução, em que o cliente precisa criar conta.
    """
    chave = _sessao_da_conexao()
    if chave is not None:
        try:
            sessao = BANCO.sessao_de(chave)
        except _contas.ErroConta:
            chave = None
        else:
            return resposta_327("search_user_platform", seq, sessao["nome"], chave,
                                _contas.agora_ms())
    if MODO_PUBLICO:
        # A janela de conta ja esta aberta (login.lua:1753); ACK sem parser
        # faz o cliente pedir usuario/senha. Nenhuma conta e entregue.
        log("search_user_platform sem sessao (modo publico): pedindo login")
        return " ".join([seq, "search_user_platform", "0"])
    # Sem sessão na conexão (o servidor acabou de subir): se há conta salva,
    # ela é a conta "lembrada" desta instalação. O token devolvido é novo e
    # válido — o cliente o usa nos próximos pedidos.
    conta = _conta_unica_salva()
    if conta is None:
        return recusa("search_user_platform", seq, "conta_nao_informada")
    token = BANCO.abrir_sessao(conta["id"])
    lembrar_token(token)
    log("search_user_platform sem sessao: usando a conta salva conta=%s" % conta["nome"])
    return resposta_327("search_user_platform", seq, conta["nome"], token,
                        _contas.agora_ms())


def _conta_unica_salva():
    """A conta local a usar quando o cliente nao informa qual.

    Antes exigia existir EXATAMENTE uma conta no banco; com duas, devolvia
    None e o search_user_platform recusava com "conta_nao_informada" — a tela
    de login aparecia mas nao avancava, dando a impressao de que nao dava
    para digitar. Agora, havendo varias, escolhe a que tem perfil e mais
    progresso (a mais antiga com user_id), que e a conta real do jogador;
    contas criadas por engano ficam de fora sem precisar apagar nada.
    """
    with BANCO._lock:
        linhas = BANCO._conn.execute(
            """SELECT c.id, c.display_name,
                      (SELECT COUNT(*) FROM perfis p WHERE p.conta_id=c.id) AS tem_perfil,
                      (SELECT COALESCE(SUM(i.quantity),0)
                         FROM local_inventory i WHERE i.conta_id=c.id) AS itens
                 FROM contas c
                ORDER BY tem_perfil DESC, itens DESC, c.id ASC""").fetchall()
    if not linhas:
        return None
    escolhida = linhas[0]
    if len(linhas) > 1:
        log("ha %d contas no banco; usando a conta %s (%s)"
            % (len(linhas), escolhida["id"], escolhida["display_name"]))
    return {"id": escolhida["id"], "nome": escolhida["display_name"]}


# O cliente guarda o token no UserDefault e o reenvia em cada pedido
# (userLoginToken), então a identidade de uma requisição vem DO PRÓPRIO
# PEDIDO sempre que ele a traz. O C2S 3 (search_user_platform) não leva
# credencial nenhuma: para ele, e para pedidos legados sem token, usa-se a
# sessão da conexão — a última 327 emitida para esta instância local do
# servidor. É uma conveniência de UMA máquina local (o servidor só escuta
# em 127.0.0.1), não a fonte de verdade: `sessao_de` revalida sempre e
# recusa token revogado/expirado.
_sessao_conexao = {"token": None}
# Chave da sessao trazida pelo PEDIDO atual (?s=<token>), por thread do
# ThreadingHTTPServer. Quando presente, e a unica identidade usada.
_pedido = threading.local()


def _sessao_da_conexao():
    pedido = getattr(_pedido, "token", None)
    if pedido is not None:
        try:
            BANCO.sessao_de(pedido)
        except _contas.ErroConta:
            return None
        return pedido
    if MODO_PUBLICO:
        # Sem chave no pedido nao ha identidade: nada de sessao global.
        return None
    token = _sessao_conexao["token"]
    if token is None:
        return None
    try:
        BANCO.sessao_de(token)
    except _contas.ErroConta:
        _sessao_conexao["token"] = None
        return None
    return token


def lembrar_token(token):
    # O restante DESTE pedido (mesma thread) ja enxerga a sessao nova.
    _pedido.token = token
    if not MODO_PUBLICO:
        _sessao_conexao["token"] = token


def esquecer_token():
    _pedido.token = None
    _sessao_conexao["token"] = None


BANCO = _contas.abrir_banco_padrao()


def handle_local_logout(seq, texto):
    """local_logout (C2S 990001) — extensão do servidor local.

    O acervo NÃO tem comando HTTP de logout: sair é a mensagem de SDK LOGOUT
    (ThirdpartySupporter.lua:23) que o servidor oficial via pela plataforma.
    Como aqui a sessão é nossa, o adaptador cliente manda este pedido para
    que a sessão seja revogada de verdade (prioridade 2, item 6).

    Pedido: <token> \\r\\n <conta>
    Resposta: ACK neutro (status 0 sem parser) — nada é exibido ao jogador.
    """
    l = _linhas(texto)
    token = l[0].strip() if l and l[0] else ""
    revogado = False
    if _contas.token_valido(token):
        revogado = BANCO.revogar_sessao(token)
    # Sair SEMPRE encerra a sessão desta conexão, mesmo que o cliente não
    # tenha mandado o token (pedido vazio, cliente antigo, ou falha ao montar
    # o corpo). Sem isto a sessão lembrada sobrevivia ao logout e o próximo
    # vali_register era aceito como se o jogador ainda estivesse autenticado —
    # exactamente o oposto do contrato de sessão.
    if token == "":
        lembrado = _sessao_conexao["token"]
        if lembrado is not None:
            revogado = BANCO.revogar_sessao(lembrado) or revogado
    if _sessao_conexao["token"] == token:
        _sessao_conexao["token"] = None
    log("local_logout sessao=%s revogada=%s" % (_mascarado(token), revogado))
    return " ".join([seq, "local_logout", "0"])


def handle_get_system_notice(seq, texto=""):
    """get_system_notice (C2S 66) -> parser 999 (ProtocolParserCopyEx.lua:4-7).

    NÃO HÁ ANÚNCIO NO MODO LOCAL. O problemA é COMO dizer isso ao cliente.

    O acervo (login.lua:1958-1995) só abre a janela de anúncio quando
    `response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0`. Como
    RESPONSE_SUCCESS é HTTP 200 (NetworkAdaptor.lua:596), QUALQUER resposta
    válida abre a janela. E no projeto l_naruto ela cai em
    client/red_alert_time/game_announcement/GameAnnouncement.lua, cujo
    csb.createNode não compila o shader no Axmol
    ("ASSERT FAILED ON LUA EXECUTE: Shader compile failed!",
    GameAnnouncement.lua:247 — observado ao vivo). Ou seja: responder
    "sucesso" derruba o fluxo de login por um motivo que não tem nada a ver
    com conta.

    Um status negativo também não serve: NetworkProtocol.lua:170-187 trata
    list[4] como CÓDIGO DE PARSER quando numérico e como MENSAGEM DE ERRO
    quando não — nos dois casos abre o diálogo de erro da NetworkView.

    Saída honesta e sem efeito colateral: a lista de servidores marca o
    servidor com o sentinela que o PRÓPRIO acervo usa para "não mostrar
    anúncio" (server_number % 1000 == 999, login.lua:1935). Com ele,
    login.lua:1936 faz isShowData = false, o pedido de anúncio nem é feito
    e nenhuma janela abre. Aqui, se ainda assim o pedido chegar (cliente
    sem o sentinela), respondemos um anúncio vazio válido — o
    GameAnnouncement não é aberto porque o pedido não parte.
    """
    return " ".join([seq, "get_system_notice", "0", "999", ""])

MINIMOS["search_user_platform"] = handle_search_user_platform
MINIMOS["platform_user_login"] = handle_platform_user_login
MINIMOS["platform_user_register"] = handle_platform_user_register
MINIMOS["vali_register"] = resposta_vali_register
MINIMOS["local_logout"] = handle_local_logout
MINIMOS["get_system_notice"] = handle_get_system_notice

# ---- login_init (código 8 -> parser 3, ProtocolParserCopy.lua 72-1014) ----
# 96 tokens na ordem exata do parse_login_init para __lua_project_id=27
# (l_naruto). Contadores 0 => nenhum item filho. Campos de tempo usam o
# relógio local (factual); strings vazias são tokens "" preservados pelo
# lua_string_splits (utils.lua 219-237). Dados rotulados/literais: apenas
# system_notice "-" e gender 1. user_id e user_name vêm do PERFIL da conta
# autenticada que fez o pedido — nunca de uma conta fixa nem da última
# sessão global.
def _itens_do_inventario(conta_id):
    """Itens reais da conta, na ordem que o parser 3 espera.

    Fonte: tabela local_inventory (mould, instance_id, quantity). O cliente
    monta _ED.user_prop a partir disso (ProtocolParserCopy.lua:388-412) e o
    tutorial usa essa lista para sintetizar cartas e ler contadores. Devolver
    vazio fazia HeroListView.lua:1577 e sm_ship_seat_cell.lua:137 estourarem.
    """
    with BANCO._lock:
        linhas = BANCO._conn.execute(
            "SELECT mould, instance_id, quantity FROM local_inventory"
            " WHERE conta_id=? ORDER BY instance_id", (conta_id,)).fetchall()
    return [{"mould": r["mould"], "instance_id": r["instance_id"],
             "quantity": r["quantity"]} for r in linhas]


_NOMES_PROP = {}


def _nome_do_prop(mould):
    """prop_name da tabela original (LocalDatas.lua:948: coluna 2)."""
    if not _NOMES_PROP:
        tabela = _dados_batalha.tabela("prop_mould.txt")
        for chave, colunas in tabela.items():
            if len(colunas) > 1:
                _NOMES_PROP[str(chave).strip()] = colunas[1]
    return _NOMES_PROP.get(str(mould).strip(), "")


def _assentos_de_formacao(grade):
    """Vagas de formacao liberadas para o nivel da conta.

    user_experience_param.txt so vai ate o nivel maximo do jogo original; com
    a conta no teto (500) a linha existe, mas se o nivel passar do fim da
    tabela o acesso direto estourava KeyError e derrubava o login. Cai para a
    ultima linha — o nivel mais alto libera todas as vagas.
    """
    try:
        tabela = _dados_batalha.tabela('user_experience_param.txt')
        chave = str(grade)
        if chave in tabela:
            return str(tabela[chave][5])
        maior = max((k for k in tabela if k.isdigit()), key=int, default=None)
        if maior is not None:
            return str(tabela[maior][5])
    except Exception as exc:
        log("unlocked formation seats: %s" % exc)
    return "6"


def resposta_login_init(seq, texto="", nome_cmd="login_init"):
    import datetime
    agora = datetime.datetime.now()
    hoje_zero = agora.replace(hour=0, minute=0, second=0, microsecond=0)
    ms = int(agora.timestamp() * 1000)
    zero_ms = int(hoje_zero.timestamp() * 1000)
    Z = "0"
    # Perfil da conta AUTENTICADA por ESTE pedido. A identidade vem do próprio
    # login_init (userLoginToken/m_sUin, ProtocolCommanderCopy.lua:117-127);
    # só cai para a sessão da conexão quando o pedido não a traz. Não existe
    # mais perfil "Convidado": sem sessão válida o comando é RECUSADO.
    conta_pedida, token = _identidade_do_pedido(texto)
    if not token:
        token = _sessao_da_conexao()
    try:
        sessao = BANCO.sessao_de(token, conta_pedida)
    except _contas.ErroConta as e:
        return recusa("login_init", seq, "sem_sessao_valida (%s)" % e.codigo)
    perfil = BANCO.perfil(sessao["conta_id"])
    user_id = str(perfil["user_id"])
    user_name = perfil["user_name"]
    from tutorial_campaign import campaign, scene_tokens, npc_tokens
    import hero_training_local
    hero_training_local.prepare(BANCO,sessao['conta_id'])
    if not tutorial_enabled(BANCO,sessao['conta_id']):
        with BANCO._lock, BANCO._conn:
            BANCO._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id,food,endurance) VALUES (?,60,150)',(sessao['conta_id'],))
    campaign_grade, campaign_silver, _ = campaign(BANCO, sessao['conta_id'])
    with BANCO._lock:
        wallet=BANCO._conn.execute('SELECT gold,food,endurance,honour,soul,jade FROM local_resources WHERE conta_id=?',
                                  (sessao['conta_id'],)).fetchone()
    wallet=list(wallet) if wallet else [0]*6
    # Itens da conta. O parser 3 (ProtocolParserCopy.lua:388-412) le
    # `user_prop_number` e depois 7 tokens por item; enquanto o servidor
    # mandava "0", _ED.user_prop ficava vazio e o tutorial quebrava ao tentar
    # sintetizar carta / concatenar contadores:
    #   HeroListView.lua:1577  user_comb_can_filed_mould_num nil
    #   sm_ship_seat_cell.lua:137  fundPropWidthId() -> nil (props nil)
    itens = _itens_do_inventario(sessao["conta_id"])
    log("%s: %d itens no inventario da conta %s"
        % (nome_cmd, len(itens), sessao["conta_id"]))
    # Personagens enviados no login: SOMENTE os que a formacao referencia.
    # formula.getUserFight (formula.lua:824-828) faz
    #     _ED.user_ship[""..v].hero_fight
    # para cada id da formacao. Se o login nao trouxer o personagem, essa
    # busca devolve nil e o cliente cai em "abnormal data, please login
    # again". Por isso o conjunto enviado e exatamente o da primeira
    # formacao (os 3 iniciais), com user_ship_number batendo com quantos
    # blocos vieram.
    import recruitment_local as _rec_tmp
    # Personagens enviados no login: TODOS os que a conta possui.
    #
    # Duas exigencias do cliente:
    #   1) formula.getUserFight (formula.lua:824-828) faz
    #      _ED.user_ship[""..v].hero_fight para cada id da formacao; se o
    #      personagem nao vier, a busca devolve nil e o cliente mostra
    #      "abnormal data, please login again".
    #   2) A lista NINJA (HeroListView) tambem le _ED.user_ship. Mandando so
    #      os 3 da formacao, a lista aparecia quase vazia mesmo com a conta
    #      cheia.
    # Por isso vai a lista inteira: ela satisfaz (1) porque contem a
    # formacao, e (2) porque mostra tudo o que o jogador tem.
    import recruitment_local as _rec_tmp
    naves_login = _rec_tmp.all_owned(BANCO, sessao["conta_id"])
    # Conta recem-criada sem nenhum registo de posse: manda os 3 iniciais
    # para o laco nao ficar vazio e o menu montar.
    if not naves_login:
        naves_login = [e for e in _rec_tmp.all_owned(BANCO, sessao["conta_id"])
                       if e[1] in (13, 35, 50)][:3]
    # Protocol 9 and metadata 14104 have their own layouts. Do not splice
    # partial slices of them into the different parser-3 character structure.
    naves_login_tokens = []
    log("%s: enviando %d personagem(ns) no login"
        % (nome_cmd, len(naves_login)))
    # Quantos personagens o login vai anunciar em user_ship_number (campo 82).
    # Precisa bater com o numero de blocos que ship_tokens emite, senao o
    # parser le menos personagens do que recebe e desalinha o resto.
    import recruitment_local as _rec_login
    naves = _rec_login.all_owned(BANCO, sessao["conta_id"])
    toks_prop = []
    for item in itens:
        # Ordem exigida pelo parser (linhas 396-410).
        toks_prop.extend([
            str(item["instance_id"]),      # user_prop_id
            str(item["mould"]),            # user_prop_template
            _nome_do_prop(item["mould"]),  # prop_name
            "0",                           # prop_use_type
            str(item["quantity"]),         # prop_number
            "0",                           # prop_type
            "0",                           # prop_timestamp
        ])
    log("login_init conta=%s user_id=%s sessao=%s"
        % (user_name, user_id, _mascarado(token)))
    import legacy_recruit_local as _legacy_recruit_login
    recruit_free_info = _legacy_recruit_login.login_tokens(BANCO, sessao['conta_id'])
    toks = [
        Z,                              # 1 server_review
        Z,                              # 2 user_force
        str(ms),                        # 3 system_time (ms)
        agora.strftime("%Y-%m-%d_%H:%M:%S"),  # 4 system_time_format (sem espaço!)
        str(zero_ms),                   # 5 today_before_dawn (data, ms)
        "00:00:00",                     # 6 today_before_dawn (hora)
        "-",                            # 7 system_notice (rotulado)
        npc_tokens(BANCO,sessao['conta_id'])[1], # 8 complete NPC state, needed by high-level feature checks
        Z,                              # 9 environment_formetion_state
        Z,                              # 10 npc_max_state
        "0,0,0,0,0,0,0",                # 11 npc_current_attack_count
        "0,0,0,0,0,0,0",                # 12 npc_current_buy_count
        Z,                              # 13 user_fun_state
        Z,                              # 14 user_invite
        Z,                              # 15 friend_active
        user_id,                        # 16 user_id (perfil da conta)
        _tutorial_campaign.resume_record(BANCO,sessao['conta_id']) or Z, # 17 persisted local tutorial checkpoint
        __import__('profile_local').wire_name(user_name), # 18 escaped display name
        str(campaign_grade),            # 19 user_grade (persisted local campaign)
        str(wallet[1]),                  # 20 user_food
        str(max(wallet[1],60) if tutorial_enabled(BANCO,sessao['conta_id']) else __import__('player_level_local').capacidade_energia(campaign_grade)), # 21 max_user_food (user_experience_param)
        str(wallet[2]),                  # 22 endurance
        str(max(wallet[2],150)),         # 23 max_endurance
        str(campaign_silver),            # 24 user_silver
        str(wallet[0]),                  # 25 user_gold
        str(wallet[3]),                  # 26 user_honour
        str(wallet[4]),                  # 27 soul
        str(wallet[5]),                  # 28 jade
        str(BANCO.experiencia_tutorial(sessao["conta_id"]) if tutorial_enabled(BANCO,sessao['conta_id']) else max(1 if campaign_grade==1 else 0, __import__('player_level_local').estado(BANCO,sessao["conta_id"])[1])), # 29 user_experience; never "l1e0", which forces the intro battle (LoginLoading.lua:212)
        Z if tutorial_enabled(BANCO,sessao['conta_id']) else str(__import__('player_level_local').necessario(campaign_grade)), # 30 user_grade_need_experience
        Z if tutorial_enabled(BANCO,sessao['conta_id']) else str(__import__('profile_local').head(BANCO,sessao["conta_id"])), # 31 persisted avatar
        Z,                              # 32 user_image_id
        "1",                            # 33 user_gender (índice >=1)
        Z,                              # 34 user_train
        Z,                              # 35 user_train_ship
        Z,                              # 36 user_ship
        _assentos_de_formacao(campaign_grade),  # 37 unlocked formation seats
        "-",                            # 38 capture_name (nunca vazio)
        Z,                              # 39 capture_id
        Z,                              # 40 capture_head
        Z,                              # 41 capture_grade
        Z,                              # 42 capture_vip_grade
        Z,                              # 43 arena_reward_number (contador)
        # Campos 44-88 (medidos no parser a partir de parse_login_init,
        # linha 72): treino, bolsas, CDs, desafios e friend_number (81).
        # Nao ha amigos na conta local, entao o laco de amigos nao roda e os
        # campos 82-88 (friend_id/head/name/grade/popularity/vip/capture_id)
        # nao existem no fluxo; eles so aparecem quando friend_number > 0.
        Z, Z, Z, Z, Z, Z, Z, Z,         # 44-51
        Z, Z, Z, Z,                     # 52-55
        Z, Z, Z, Z,                     # 56-59
        Z, Z,                           # 60-61
        __import__('vip_local').grade(BANCO,sessao['conta_id']),  # 62 vip_grade
        Z, Z, Z, Z, Z, Z,               # 63-68
        Z,                              # 69
        Z, Z,                           # 70-71
        Z,                              # 72 arena_number (contador)
        Z,                              # 73 login_and_exit
        Z, Z, Z, Z, Z,                  # 74-78
        Z,                              # 79
        *recruit_free_info,             # 80-88: original recruit free state (3 categories)
        Z,                              # 89 friend_number
        str(len(itens)),                # 90 user_prop_number (native npos trace)
    ]
    # Measured using the original npos function: item count is read 90,
    # equipment count 91, ship count 92, formation count 93, companions 94,
    # recruitment counters 95 and 96 (before the next protocol block).
    assert len(toks) == 90, 'login prefix must end at item counter 90, got %d' % len(toks)
    # Contagem medida LINHA A LINHA no parser (parse_login_init, linha 72):
    #   73 leituras incondicionais ate a linha 363
    #   + a linha 365 e 'for n=1,3 do' com 3 npos dentro -> 9 campos (78-86)
    #   + friend_number (87)
    #   + user_prop_number (90), confirmed by native execution rather than static counting
    # O laco 'for n=1,3' era o ponto que eu vinha errando: sao 9 campos, nao
    # 3, porque npos() roda tres vezes por iteracao. Somar isso errado
    # deslocava o contador em 6 posicoes e o parser recebia nil em
    # user_prop_number -> "'for' limit must be a number" (linha 392).
    assert len(toks) == 90, len(toks)
    # Ordem EXATA depois do contador de itens (medida no parser):
    #   itens (7 tokens cada)                        -> linha 447 'end'
    #   user_equiment_number (linha 444)
    #   laco de equipamentos (11 campos cada)        -> 0 aqui, nao roda
    #   user_ship_number (linha 514)
    #   laco de personagens (43 campos cada)
    # Se os itens forem para o fim, user_ship_number passa a ler o ID do
    # primeiro item: o parser roda milhoes de iteracoes e morre em
    # ProtocolParserCopy.lua:565 (ship_health nil) -> tela preta.
    cabeca = toks            # campos 1..88

    # O nome do comando é ecoado: ProtocolParserCopyExx.lua:815 compara
    # list[2] com "login_init"/"login_init_again", e protocolos de S2C são
    # despachados pelo nome que vem na resposta.
    # Parser 12042 (ProtocolParserCopyExx.lua:1975-1993) DEPOIS do 3: o cliente
    # percorre os codigos de parser em sequencia (NetworkProtocol.lua:141-163),
    # entao a mesma resposta entrega os dois.
    #
    # Por que isto e obrigatorio (item 2 do pedido do jogador: "confira a
    # atualizacao dos valores de velocidade, preservando a verificacao de
    # consistencia"): getUserSpeedSum (EnvironmentDatas.lua:10430-10477) roda
    # no fim do login_init e faz
    #     speed_sum = tonumber(_ED.ship_all_speed_info)
    #     old_speed_sum = aeslua.encrypt(speed_sum)
    # e na proxima vez compara decrypt(old_speed_sum) com speed_sum. Como
    # _ED.ship_all_speed_info SO e preenchido pelo parser 12042, e o acervo
    # nunca PEDE esse comando (o servidor oficial o envia), ele ficava nil ->
    # speed_sum nil -> old_speed_sum virava lixo -> no login seguinte a
    # comparacao falhava e o jogo abria a ReconnectView, que por sua vez
    # quebrava em Panel_5322. Ou seja: este token e o que mantem a
    # verificacao FUNCIONANDO em vez de falso-positiva.
    #
    # A velocidade vem dos atributos atuais dos ninjas, incluindo os bonus
    # confirmados de Advance (+5) e promocao por estrela (+20).
    import hero_stats_local as _stats
    import recruitment_local as _stats_heroes
    with BANCO._lock:
        velocidade = int(sum(_stats.effective(BANCO,sessao['conta_id'],ship,mould)['speed'] for ship,mould in _stats_heroes.all_owned(BANCO,sessao['conta_id'])))
    # Monta na ordem EXATA do parser 3 (parse_login_init, linha 72):
    #   campos 1..88  (termina no contador de itens, user_prop_number)
    #   itens         (7 tokens cada, quantos o contador acima disser)
    #   user_equiment_number (0: sem equipamentos, o laco nao roda)
    #   user_ship_number (quantos personagens vem em seguida)
    cauda = [
        Z,                              # user_equiment_number (contador) = 0
        Z,                              # parser-3 ships; explicit protocol-9 blocks follow
    ]
    # Fim do parser 3 (ProtocolParserCopy.lua:794-835), nesta ordem EXATA.
    # Precisa vir ANTES do codigo 12042: o parser 3 le these campos antes de
    # devolver o controle; se chegarem depois, ele consome '12042' como
    # have_formetion_number e as 10 posicoes seguintes como formacao, e
    # estoura em ProtocolParserCopy.lua:832 ("attempt to compare number with
    # nil") porque o primeiro token de 12042 e texto nao numerico.
    import recruitment_local as _rec_form
    _form = _rec_form.formation_tokens(BANCO, sessao['conta_id'])
    # formation_tokens devolve ['6012', '<n>', '<...>', '<10 posicoes>'].
    _posicoes = _form[-1].split(',')
    if len(_posicoes) < 10:
        _posicoes += ['0'] * (10 - len(_posicoes))
    # Os DOIS ultimos campos do parser 3 (ProtocolParserCopy.lua:966-967:
    # user_accumulate_buy_god e user_accumulate_camp_god) vem depois do
    # little_companion_state. Sem eles a resposta fica um campo curta e todo o
    # resto desliza: o cliente le o '12042' como contador de equipamento, cai
    # em ProtocolParserCopy.lua:494 ("table index is nil") e a tela fica preta.
    _fim_parser3 = ['0','0,0,0,0,0,0','0','0']
    # Parser 3 can synchronously trigger high-level activity checks. Scenes
    # must already exist then; parser 6020 only needs the loaded data tables.
    # High-level Home notifications run while the profile is being parsed.
    # Original parser 361 replaces the legacy numeric daily reward default
    # with a list before those notifications can iterate it. No local daily
    # tasks/rewards are offered yet (zero points, empty claimed-index list).
    tokens = ([seq, nome_cmd, "0", "12001", str(ms), str(int(SERVIDOR_INICIADO_EM*1000))]
              + scene_tokens(BANCO,sessao['conta_id'])
              + ["361", "0", "", "0", "3"]
              + toks + toks_prop + cauda
              + naves_login_tokens
              + _fim_parser3
              + ["12042", str(velocidade)])
    log('LOGIN_LAYOUT prefix=%d items=%d separate_characters=%d' % (len(toks),len(itens),len(naves_login)))

    # Original combo-card parser: empty local collection and zero unlocked slots.
    tokens += ['471','[]','[]','0','0']
    # Home reads energy notification periods immediately on entry, before
    # a separate asynchronous power_swallow request can complete.
    import energia
    tokens += ['194','0','0','|'.join(energia.info_tokens(BANCO,sessao['conta_id']))]

    # Parser 6020 (parse_user_scene_states, ProtocolParser.lua:3107) DEPOIS do
    # 3 e do 12042: o cliente percorre os codigos de parser em sequencia
    # (NetworkProtocol.lua:141-163).
    #
    # Por que aqui e nao em battle_result_start: _ED.scene_max_state alimenta
    # as telas de MENU de PVE (Menu.lua:648-655, PVEStage.lua:356,
    # LPVEScene.lua:365), que o jogador abre depois do login. E no
    # Mission.lua:2283 (responseBattleFieldInitCallback) o campo e percorrido
    # com pairs(); se for nil, o pairs estoura e a batalha nao monta.
    # Entregar no login garante o campo pronto antes de qualquer um dos dois.
    #
    # Politica explicita: capitulo 1 aberto, demais bloqueados (-1), sem
    # estrelas nem recompensas. Nao e progresso recuperado de um servidor
    # antigo; e o estado inicial coerente para uma conta nova, derivado do
    # proprio pve_scene do acervo.
    try:
        tokens = tokens + scene_tokens(BANCO, sessao['conta_id']) + npc_tokens(BANCO, sessao['conta_id'])
    except Exception as exc:
        log("%s: estado de cenas indisponivel: %s" % (nome_cmd, exc))
    import recruitment_local
    for entry in naves_login:
        tokens += recruitment_local.one_ship_tokens(BANCO,sessao['conta_id'],entry)
    tokens += recruitment_local.formation_tokens(BANCO,sessao['conta_id'])
    # ORDEM DOS BLOCOS (cada codigo abre um parser proprio):
    #   parser 3    -> os 96 campos + itens (o laco de personagens fica vazio)
    #   6012        -> formacao
    #   6024        -> inventario
    #   15005       -> recrutamento (JSON)
    #
    # Os personagens NAO sao injetados no login. O laco de user_ship do
    # parser 3 le uma sequencia longa de campos por personagem (dados,
    # relacoes, talentos, treino, awaken...) e injetar os 103 desalinhava o
    # resto da resposta: o cliente nao carregava (tela preta / login nao
    # abria). Enquanto esse mapeamento nao estiver provado contra o parser,
    # eles ficam GRAVADOS no banco (local_synthesized + local_ship_rank),
    # sem quebrar o login. user_ship_number ja vai 0 no bloco acima.
    # A formacao e o little_companion_state ja foram para dentro do parser 3,
    # junto com os personagens (ver _fim_parser3 acima). Nao repetir aqui.
    tokens += hero_training_local.inventory_tokens(BANCO,sessao['conta_id'])
    tokens += recruitment_local.init_tokens(BANCO,sessao['conta_id'])
    import shop_local
    tokens += shop_local.state_tokens(BANCO,sessao['conta_id'])
    import shop_special_local
    tokens += shop_special_local.wallet_tokens(BANCO,sessao['conta_id'])
    import quest_local
    with BANCO._lock,BANCO._conn:
        tokens += quest_local.state_tokens(BANCO,sessao['conta_id'])
    import tutorial_campaign
    tokens += tutorial_campaign.login_attempt_tokens(BANCO,sessao['conta_id'])
    tokens += __import__('initial_tutorial').login_tokens(BANCO,sessao['conta_id'])
    return " ".join(tokens)

def resposta_get_resource(seq, texto=""):
    """Recovered intro event 2010133 grants exactly 8-0,1 (one XP)."""
    lines = _linhas(texto)
    try:
        session = BANCO.sessao_de(_sessao_da_conexao())
    except _contas.ErroConta:
        return recusa("get_resource", seq, "sem_sessao_valida")
    profile = BANCO.perfil(session["conta_id"])
    if len(lines) != 2 or lines[0].strip() != str(profile["user_id"]):
        return recusa("get_resource", seq, "perfil_invalido")
    if lines[1].strip() != "8-0,1":
        return recusa("get_resource", seq, "recurso_nao_implementado")
    import initial_tutorial
    if initial_tutorial.managed(BANCO,session['conta_id']) and initial_tutorial.state(BANCO,session['conta_id'])!='playing':
        return recusa('get_resource',seq,'introducao_nao_esta_ativa')
    experience = BANCO.concluir_intro(session["conta_id"])
    # Original parser 41 reads exactly one token: user_experience.
    return " ".join([seq, "get_resource", "0", "41", str(experience)])

def resposta_system_time(seq, texto=""):
    """system_time (C2S 119) -> parse_return_system_time (S2C 12001).

    Contrato original (ProtocolParserCopyExx.lua:1709-1717):
        _ED.system_time      = npos(list)    -- 1o token (ms)
        _ED.open_server_time = npos(list)    -- 2o token (ms)
        _ED.system_time      = tonumber(_ED.system_time)/1000
        _ED.native_time      = os.time()
        _ED.time_add_or_sub  = _ED.system_time - _ED.native_time

    Por que existe: `open_server_time` NAO vem no login_init (o parser do login
    e parse_return_all_user_info, que nao o define) — ele so e escrito aqui.
    Sem ele, EnvironmentDatas.funOpenDrawTip:5261 faz

        (tonumber(_ED.system_time) - tonumber(_ED.open_server_time)/1000 + ...)

    e estoura "attempt to perform arithmetic on a nil value" a cada quadro em
    Home.lua:7446 (onUpdate). Era a excecao que se repetia na tela do PVE.

    Os dois tokens sao tempos REAIS: o instante atual e o instante em que este
    servidor local subiu (o "instante de abertura" verdadeiro deste servidor).
    Sao exatamente os 2 tokens que o parser consome — nem mais, nem menos.
    """
    agora_ms = int(st_time() * 1000)
    abertura_ms = int(SERVIDOR_INICIADO_EM * 1000)
    return " ".join([seq, "system_time", "0", "12001",
                     str(agora_ms), str(abertura_ms)])

def resposta_union_init(seq, texto=""):
    """union_init (C2S 127) -> parse_union_init (S2C 1001).

    Contrato original (ProtocolParserCopy.lua:7988-8008), ramo do Naruto:
    o parser le EXATAMENTE 14 tokens, nesta ordem:

        1 union_id                 4 union_kuang    7 watchword   10 union_worship
        2 union_grade              5 union_name     8 members     11 union_duplicate_chapte
        3 union_icon               6 bulletin       9 union_contribution
                                                                   12 union_member_num
                                                                   (ramo digital/dragonball/
                                                                    pokemon/onepiece/naruto:)
                                                                   13 approval_status
                                                                   14 union_rank

    Por que existe: antes este comando caia no ACK neutro (SEM_OPERACAO) e
    respondia sem tokens, entao _ED.union.union_info ficava vazio e
    union_grade era nil. EnvironmentDatas.funOpenDrawTip:5286 faz

        if union_level > zstring.tonumber(_ED.union.union_info.union_grade)

    e a comparacao com nil impedia o retorno false. Como o cadeado da tela
    FIGHT (ExploreWindow:240-251) fica visivel quando funOpenDrawTip nao
    devolve false, TODOS os botoes apareciam trancados mesmo com o jogador no
    nivel 110.

    Conta sem cla: union_id 0 e union_grade 0 (numeros, nunca nil), que e o que
    o parser espera e o que evita a comparacao invalida. Nada aqui inventa um
    cla: o jogador continua sem cla, apenas com o contador zerado e valido.

    Textos vazios usam '-' (nunca ''): string vazia nao gera token e deslocaria
    os 14 indices.
    """
    atual = _resposta_union_atual()
    # Ordem e quantidade casam com parse_union_init. Numeros como str().
    campos = [
        str(atual["union_id"]),        # 1  union_id
        str(atual["union_grade"]),     # 2  union_grade  <- o que destrava o cadeado
        str(atual["union_icon"]),      # 3  union_icon
        str(atual["union_kuang"]),     # 4  union_kuang
        atual["union_name"],           # 5  union_name (texto)
        "-",                           # 6  bulletin (texto)
        "-",                           # 7  watchword (texto)
        str(atual["members"]),         # 8  members
        str(atual["union_contribution"]),  # 9  union_contribution
        str(atual["union_worship"]),   # 10 union_worship
        str(atual["union_duplicate_chapte"]),  # 11 union_duplicate_chapte
        str(atual["union_member_num"]),  # 12 union_member_num
        str(atual["approval_status"]),  # 13 approval_status (ramo Naruto)
        str(atual["union_rank"]),      # 14 union_rank (ramo Naruto)
    ]
    assert len(campos) == 14, len(campos)
    return " ".join([seq, "union_init", "0", "1001"] + campos)


def _resposta_union_atual():
    """Estado de cla da sessao atual.

    Lido de local_clan_membership. Sem cla, devolve zeros VALIDOS (o parser
    precisa de numeros); com cla, devolve o que estiver gravado. Nenhum campo
    fica nil para nao repetir a comparacao invalida que travava a tela FIGHT.
    """
    vazio = {
        "union_id": 0, "union_grade": 0, "union_icon": 0, "union_kuang": 0,
        "union_name": "-", "members": 0, "union_contribution": 0,
        "union_worship": 0, "union_duplicate_chapte": 0, "union_member_num": 0,
        "approval_status": 0, "union_rank": 0,
    }
    try:
        session = BANCO.sessao_de(_sessao_da_conexao())
    except Exception:
        return vazio
    try:
        linha = BANCO._conn.execute(
            "SELECT clan_id, clan_name FROM local_clan_membership WHERE conta_id = ?",
            (session["conta_id"],)).fetchone()
    except Exception:
        return vazio
    if not linha:
        return vazio
    atual = dict(vazio)
    atual["union_id"] = int(linha[0] or 0)
    atual["union_name"] = linha[1] or "-"
    return atual


MINIMOS["union_init"] = resposta_union_init
MINIMOS["get_resource"] = resposta_get_resource
MINIMOS["login_init"] = resposta_login_init
# system_time (C2S 119 -> parser 12001, 2 tokens): preenche _ED.open_server_time,
# que o login_init NAO entrega. Sem ele, EnvironmentDatas:5261 estoura por
# quadro em Home.lua:7446.
MINIMOS["system_time"] = resposta_system_time
# login_init_again: mesmo parser de login_init (ProtocolParserCopyExx.lua:815).
# Chega logo depois do vali_register, na tela de carregamento; sem ela o
# cliente abria o diálogo de erro de protocolo.
MINIMOS["login_init_again"] = resposta_login_init_again
# get_random_name (parser 51, 1 token): nome sugerido na criação de personagem.
MINIMOS["get_random_name"] = handle_get_random_name
# register (C2S 9 -> parser 2, 1 token): criacao do primeiro personagem.
# Sem ele o cliente entrava em laco erro->relogin->register, o que o jogador
# via como "carregamento travado".
MINIMOS["register"] = resposta_register
# Batalha: sem estes dois o login entrava em laco erro->relogin.
MINIMOS["battle_result_start"] = handle_battle_result_start
MINIMOS["battle_result_fail"] = handle_battle_result_fail
MINIMOS["battle_field_init"] = handle_battle_field_init

def despacha(text):
    seq = "0"
    cmd = ""
    try:
        lines = text.split("\r\n")
        seq = (lines[0].strip() or "0") if lines else "0"
        cmd = lines[1].strip() if len(lines) > 1 else ""
    except Exception:
        pass
    # record_crash carrega o TEXTO do erro Lua do cliente (app.lua:385-396).
    # Registrá-lo é o que permite diagnosticar um fluxo que para sem aviso:
    # antes o corpo era descartado e o crash ficava invisível.
    if cmd == "record_crash":
        corpo = "\n".join((text.split("\r\n")[2:]))
        log("[CRASH DO CLIENTE] " + corpo.replace("\n", " | ")[:600])
    fn = MINIMOS.get(cmd)
    if fn is not None:
        if cmd in ('battle_result_start','battle_field_init','battle_result_verify','get_resource',
                   'formation_change','new_recruitment_system','ship_grow_up','ship_awaken',
                   'prop_compound','draw_scene_rewad'):
            try:
                account=BANCO.sessao_de(_sessao_da_conexao())['conta_id']
                if __import__('initial_tutorial').state(BANCO,account)=='choice':
                    return recusa(cmd,seq,'escolha_fazer_ou_pular_tutorial_primeiro')
            except _contas.ErroConta:
                pass # The original handler reports the authentication error.
        try:
            resp = fn(seq, text)
        except TypeError:
            resp = fn(seq)
        # Status real da resposta (recusas de conta saem com -1).
        partes = resp.split(" ")
        status = partes[2] if len(partes) > 2 else "?"
        log(f"cmd={cmd} seq={seq} -> status={status} ({len(resp)} chars)")
        return resp
    if cmd in SEM_OPERACAO:
        # Lista EXPLÍCITA (ver SEM_OPERACAO): comandos que o contrato do
        # acervo permite responder sem efeito — ACK neutro (status 0, sem
        # código de parser): a bomba do cliente sai no break de
        # NetworkProtocol.lua:145-148 e o callback dispara RESPONSE_SUCCESS,
        # então NUNCA abre o diálogo de erro da NetworkView.
        log(f"cmd={cmd} seq={seq} sem operacao (lista explicita) -> ACK neutro")
        return " ".join([seq, cmd, "0"])
    # Fora da lista: NÃO se esconde o que não está implementado. O comando
    # vira erro visível e fica registrado como pendência.
    #
    log(f"[PENDENTE] cmd={cmd or '?'} seq={seq} OBRIGATORIO E NAO "
        f"IMPLEMENTADO")
    return " ".join([seq, cmd or "unknown", "-3", "nao_implementado"])


# Comandos que saem do cliente entre login e menu e que NÃO têm efeito útil
# neste port. Cada um tem o motivo medido — nada aqui é "sucesso genérico"
# para esconder buraco: os que importam para o ciclo login→menu→batalha estão
# implementados acima. Registrado também em port/server/data_minimos.txt.
SEM_OPERACAO = {
    # Crash reporter do próprio acervo (app.lua:385-396): reporta o erro
    # anterior no boot. Não há coletor de crashes local; um ACK neutro é o
    # mesmo que o servidor oficial faria sem processar.
    "record_crash",
    # Keep-alive do NetworkManager (registerKeepAlive): o servidor oficial
    # responde vazio e o cliente só conta a batida.
    "keep_alive",
    # union_init ainda não tem estado de jogo além do resumo neutro.
    "union_init",
    # education_change is persisted by tutorial_campaign; it is not a no-op.
    # Lista de servidores: implementado (parser 58) — declarado para leitura.
}

# Log SEMPRE ao lado deste arquivo (não relativo ao CWD: importar o módulo
# de outro diretório não pode derrubar nada). Lock: ThreadingHTTPServer
# despacha conexões em threads — sem lock as linhas podem intercalar.
import threading as _threading
_logpath = os.path.join(os.path.dirname(os.path.abspath(__file__)), "server.log")
_logf = open(_logpath, "a", encoding="utf-8")
_loglock = _threading.Lock()
# Diagnóstico opcional: registra o corpo bruto de battle_result_start /
# battle_field_init para conferir quais ids o cliente realmente enviou.
_log_corpo = os.environ.get("NR_LOG_CORPO", "0") == "1"


def log(line):    # Timestamp local (HH:MM:SS) para isolar no arquivo a sessão de cada
    # pessoa: os greps por 'cmd='/'[AVISO]' continuam batendo igual.
    linha = f"[HOST_SERVER][{_dt.now().strftime('%H:%M:%S')}] " + line
    try:
        print(linha, flush=True)
    except Exception:
        pass
    try:
        with _loglock:
            _logf.write(linha + "\n")
            _logf.flush()
    except Exception:
        pass

class Handler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            n = int(self.headers.get("Content-Length") or 0)
            if n < 0:
                raise ValueError("negativo")
        except ValueError:
            self.send_response(400)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        body = self.rfile.read(n) if n else b""
        consulta = urllib.parse.parse_qs(urllib.parse.urlsplit(self.path).query)
        text_wire = consulta.get("nr_transport") == ["text-v1"]
        try:
            text = body.decode("utf-8") if text_wire else unwrap(body)
        except Exception as exc:
            log(f"ERRO unwrap path={urllib.parse.urlsplit(self.path).path} len={len(body)} header={body[:8].hex()} swapped={swap(body)[:8].hex()}: {exc}")
            self.send_response(500)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        log(f"POST path={self.path} bytes={len(body)} primeira-linha="
            f"{text.splitlines()[0][:60] if text else '?'}")
        # Corpo de comandos de batalha: necessário para montar o parser 182 com
        # os ids REAIS (cena/npc/dificuldade) que o cliente pediu.
        # Fica atrás de NR_LOG_CORPO=1 porque o corpo tem até centenas de bytes
        # e o log de um servidor normal vira ruído; ligue quando precisar
        # conferir quais ids o cliente enviou.
        if _log_corpo and text and len(text.splitlines()) > 1:
            _c = text.splitlines()[1].strip()
            if _c in ("battle_result_start", "battle_field_init"):
                log("[CORPO] %s = %r" % (_c, text[:400]))
        consulta = urllib.parse.parse_qs(urllib.parse.urlsplit(self.path).query)
        chave = (consulta.get("s") or [None])[0]
        _pedido.token = chave if _contas.token_valido(chave) else None
        _pedido.host = self.headers.get("Host")
        try:
            answer = despacha(text)
            resp = answer.encode("utf-8") if text_wire else wrap(answer)
        finally:
            _pedido.token = None
            _pedido.host = None
        self.send_response(200)               # RESPONSE_SUCCESS..+7 aceito
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(resp)))
        self.send_header("Connection", "close")
        self.end_headers()
        self.wfile.write(resp)

    def do_GET(self):
        # Atualizacao automatica do cliente PC (ver atualizacao_cliente.py).
        import atualizacao_cliente
        if atualizacao_cliente.responder(self, self.path):
            log("ATUALIZACAO GET %s de %s" % (self.path[:140], self.client_address[0]))
            return
        self.send_response(200)
        body = b"NR local protocol stage"
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Connection", "close")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):  # silencia o log padrão do http.server
        pass

import tutorial_campaign as _tutorial_campaign
_tutorial_campaign.install(sys.modules[__name__])
import tutorial_skip as _tutorial_skip
_tutorial_skip.install(sys.modules[__name__])
import recruitment_local as _recruitment_local
_recruitment_local.install(sys.modules[__name__])
import hero_training_local as _hero_training_local
_hero_training_local.install(sys.modules[__name__])
import tutorial_synthesis as _tutorial_synthesis
_tutorial_synthesis.install(sys.modules[__name__])
import scene_rewards_local as _scene_rewards_local
_scene_rewards_local.install(sys.modules[__name__])
import ninja_trial_local as _ninja_trial_local
_ninja_trial_local.install(sys.modules[__name__])
import worldboss_local as _worldboss_local
_worldboss_local.install(sys.modules[__name__])
import purify_local as _purify_local
_purify_local.install(sys.modules[__name__])
# Comando 9018 (formação do pesadelo): a LDuplicateWindow espera esta resposta
# antes de pintar os heróis; sem ela o carregador de batalha parava em 9%.
import formacao_pesadelo as _formacao_pesadelo
_formacao_pesadelo.install(sys.modules[__name__])
# power_swallow (parser 194): sem esta resposta _ED._add_enger_info ficava nil
# e Home.lua:2136 quebrava ao abrir a Home (crash em laço após o recrutamento).
import energia as _energia
_energia.install(sys.modules[__name__])
import mail_local as _mail_local
_mail_local.install(sys.modules[__name__])
import friends_local as _friends_local
_friends_local.install(sys.modules[__name__])
import profile_local as _profile_local
_profile_local.install(sys.modules[__name__])
import online_reward_local as _online_reward_local
_online_reward_local.install(sys.modules[__name__])
import shop_local as _shop_local
_shop_local.install(sys.modules[__name__])
import shop_general_local as _shop_general_local
_shop_general_local.install(sys.modules[__name__])
import shop_special_local as _shop_special_local
_shop_special_local.install(sys.modules[__name__])
import quest_local as _quest_local
_quest_local.install(sys.modules[__name__])
import player_level_local as _player_level_local
_player_level_local.install(sys.modules[__name__])
# Mudra wraps ship_bounty/ship_batch_bounty, so it installs after shop_local.
import mudra_local as _mudra_local
_mudra_local.install(sys.modules[__name__])
import legacy_recruit_local as _legacy_recruit_local
_legacy_recruit_local.install(sys.modules[__name__])

if __name__ == "__main__":
    # Windows: http.server liga allow_reuse_address=1 (SO_REUSEADDR), que
    # PERMITE dois processos escutarem a mesma porta e a conexões caírem
    # em qualquer um deles. Para o servidor local isso é bug, não feature:
    # a segunda instância deve falhar rápido com mensagem amigável.
    http.server.ThreadingHTTPServer.allow_reuse_address = False
    try:
        srv = http.server.ThreadingHTTPServer((HOST, PORT), Handler)
    except OSError as exc:
        # Porta ocupada: quase sempre outra instância deste servidor ja esta
        # no ar (ex.: uma janela BASE.cmd antiga, ou um servidor iniciado em
        # segundo plano). A instancia antiga serve igual, entao o certo e
        # avisar em vez de derrubar: nada aqui precisa ser "consertado".
        log(f"porta {PORT} ocupada ({exc}); provavelmente outra instância "
            f"deste servidor já responde em http://{HOST}:{PORT}")
        print("", flush=True)
        print("  A BASE JA ESTA NO AR em outra janela.", flush=True)
        print("  Nao e preciso abrir outra: o jogo conecta na que ja existe.", flush=True)
        print("", flush=True)
        print("  Se voce NAO reconhece a outra janela (por exemplo, um servidor",
              flush=True)
        print("  iniciado em segundo plano), encerre-a e abra BASE.cmd de novo:",
              flush=True)
        print("", flush=True)
        print("      powershell -NoProfile -Command \"Get-Process python"
              " | Stop-Process -Force\"", flush=True)
        print("", flush=True)
        raise SystemExit(0)
    log(f"listening http://{HOST}:{PORT} (" + ("MODO PUBLICO: sessao por pedido" if MODO_PUBLICO else "somente esta maquina") + ")")
    # Canal de controle (porta separada): permite recarregar os modulos de
    # regra sem reiniciar o servidor nem derrubar a sessao do jogador.
    try:
        import controle
        controle.iniciar(sys.modules[__name__], log)
    except Exception as exc:
        log('[CONTROLE] nao iniciou (%s): recarga manual continua possivel '
            'reiniciando o servidor' % exc)
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass
