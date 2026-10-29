# port/server/dados_batalha.py — monta o parser 182 (battle_field_init) a
# partir das TABELAS DO PROPRIO ACERVO, sem inventar valores.
#
# Por que um modulo separado: local_server.py e o despachante de protocolo;
# ler res/data/mould/*.txt e responsabilidade de dados. Separar tambem deixa
# o parser testavel sozinho (tools/test_batalha.py), sem subir servidor.
#
# De onde vem cada numero (tudo do acervo, nada suposto):
#   * colunas de environment_ship / environment_formation:
#     assets/src/client/loader/LocalDatas.lua:67-84 e :131-176 (indices 1-based)
#   * layout do parser 182:
#     assets/src/client/protocol/ProtocolParserCopy.lua:6450-6700
#   * ligacao npc -> formacoes: assets/src/client/battle/report/Npc.lua
#     (formation_count + environment_formation1..N)

import os

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ_NK = os.path.abspath(os.path.join(AQUI, os.pardir, os.pardir))
MOULD = os.path.join(RAIZ_NK, "res", "data", "mould")


def _ler(nome):
    """Le uma tabela .txt do acervo como lista de linhas ja divididas por TAB.

    Latin-1 com fallback: os nomes de NPC vem em UTF-8, mas ha tabelas com
    bytes de outra codificacao. Nao explodir importa mais que ser exato numa
    coluna que nao usamos.
    """
    caminho = os.path.join(MOULD, nome)
    if not os.path.exists(caminho):
        return {}
    tabela = {}
    with open(caminho, "r", encoding="utf-8", errors="replace") as f:
        for linha in f:
            c = linha.rstrip("\n").split("\t")
            if not c or not c[0].strip():
                continue
            tabela[c[0].strip()] = c
    return tabela


_CACHE = {}


def estado_inicial_cenas():
    """S2C 6020: quatro vetores consumidos por parse_user_scene_states.

    Política explícita para o tutorial local: capítulo 1 aberto, demais
    capítulos bloqueados, zero estrelas/recompensas. Não é progresso recuperado
    do servidor antigo. A lista de IDs vem do pve_scene original.
    """
    cenas = tabela("pve_scene.txt")
    ids = sorted(int(chave) for chave in cenas if chave.isdigit())
    if not ids or 1 not in ids:
        raise ValueError("pve_scene original ausente ou sem capitulo 1")
    # So o intervalo REALMENTE definido no pve_scene (ids 1..500 no acervo).
    # Gerar "max(ids)+1" posicoes produzia vetores de 999 posicoes com
    # lixo depois do ultimo capitulo: a resposta de login chegava a ~5 KB
    # sem necessidade e o parser 6020 consulta dms.int(pve_scene, i, ...) em
    # cada posicao, que devolve nil para ids inexistentes.
    estados = ["0" if indice == 1 else "-1" for indice in ids]
    zeros = ["0"] * len(estados)
    return ["6020", ",".join(estados), ",".join(estados),
            ",".join(zeros), ",".join(zeros)]


def tabela(nome):
    if nome not in _CACHE:
        _CACHE[nome] = _ler(nome)
    return _CACHE[nome]


def _i(linha, indice, padrao=0):
    """Coluna 1-based -> int, com padrao quando vazia ou invalida."""
    try:
        return int(float(linha[indice - 1]))
    except (IndexError, ValueError, TypeError):
        return padrao


def _s(linha, indice, padrao=""):
    try:
        return linha[indice - 1]
    except IndexError:
        return padrao


def _f(linha, indice, padrao=0.0):
    try:
        return float(linha[indice - 1])
    except (IndexError, ValueError, TypeError):
        return padrao


# --- colunas (vide LocalDatas.lua) -----------------------------------------
ES = {          # environment_ship
    "name": 4, "level": 5, "gender": 6, "ship_type": 11,
    "power": 12,            # vida
    "courage": 13,          # ataque
    "pic_index": 27, "bust_index": 28, "talent": 35, "capacity": 36,
    "speed": 45,
}
EF = {          # environment_formation
    "name": 2, "level": 7,
    "seat": 8,              # seat_one; seats seguem 8..16
    "seat_last": 16,
}
NPC = {         # npc
    "name_col": 2,          # npc_name (ids de word_mould, '|'-separados)
    "formations": 8,        # formation_count
    "formation_1": 9,       # environment_formation1 (9..18)
}


def nome_do_npc(npc_id):
    """Nome do NPC resolvido por word_mould, como o acervo faz.

    npc.npc_name (LocalDatas.lua:814, coluna 2) guarda IDS de word_mould
    separados por '|'; o texto final e word_mould[id][3]
    (ex.: ProtocolParserCopy.lua:6482-6490). O parser faz essa resolucao
    sozinho, o que quebra quando o cliente ja recebeu o nome (ver o
    comentario de isGetLocalNpcName la). Mandar o nome pronto evita esse
    caminho.
    """
    npcs = tabela("npc.txt")
    linha = npcs.get(str(npc_id))
    if linha is None:
        return ""
    bruto = _s(linha, NPC["name_col"], "")
    if not bruto:
        return ""
    palavras = tabela("word_mould.txt")
    partes = []
    for pedaco in bruto.split("|"):
        pedaco = pedaco.strip()
        if not pedaco:
            continue
        w = palavras.get(pedaco)
        if w is None:
            continue
        texto = _s(w, 3, "").strip()
        if texto:
            partes.append(texto)
    return "".join(partes)


def formacao_do_npc(npc_id):
    """Devolve (lista_de_ids_de_formacao, nome_do_npc) para o NPC."""
    npcs = tabela("npc.txt")
    linha = npcs.get(str(npc_id))
    if linha is None:
        return [], ""
    qtd = _i(linha, NPC["formations"], 0)
    ids = []
    for k in range(qtd):
        fid = _i(linha, NPC["formation_1"] + k, 0)
        if fid > 0:
            ids.append(fid)
    return ids, nome_do_npc(npc_id)


def inimigos_da_formacao(formacao_id):
    """cada elemento: dict com os campos que o parser 182 espera.

    O parser le, por heroi inimigo:
      _id, _pos, _head, _power_skill_id, _fit_skill_id, _quality, _hp, _sp,
      _type, _mouldId, _scale, _name  (+ _evolution_level/_hero_speed/_max_hp
      no ramo l_naruto)
    """
    formacoes = tabela("environment_formation.txt")
    linha_f = formacoes.get(str(formacao_id))
    if linha_f is None:
        return []
    ships = tabela("environment_ship.txt")
    herois = []
    for k in range(9):
        seat = EF["seat"] + k
        ship_id = _i(linha_f, seat, 0)
        if ship_id <= 0:
            continue
        linha_s = ships.get(str(ship_id))
        if linha_s is None:
            continue
        hp = _i(linha_s, ES["power"], 1)
        if hp <= 0:
            hp = 1
        herois.append({
            "_id": str(ship_id),
            "_pos": str(k + 1),
            "_head": _s(linha_s, ES["pic_index"], "0"),
            "_power_skill_id": "0",
            "_fit_skill_id": "0",
            "_quality": str(_i(linha_s, ES["ship_type"], 0)),
            "_hp": str(hp),
            "_sp": "0",
            "_type": "1",                 # 1 = navio de ambiente
            "_mouldId": _s(linha_s, ES["pic_index"], "0"),
            "_scale": "1",
            "_name": _s(linha_s, ES["name"], ""),
            "_evolution_level": "0",
            "_hero_speed": str(_i(linha_s, ES["speed"], 0)),
            "_max_hp": str(hp),
        })
    return herois


def campo_valido(txt):
    """Token do protocolo: sem espaco, sem \\r\\n, nunca vazio.

    O corpo da resposta e separado por ESPACOS (NetworkProtocol.lua), entao
    qualquer vazio ou espaco desalinha o parser inteiro.
    """
    txt = str(txt if txt is not None else "")
    txt = txt.replace("\r", " ").replace("\n", " ").replace(" ", "_").strip()
    return txt if txt else "0"


def montar_parser_182(npc_id, dificuldade, itens_jogador, nome_jogador,
                      max_hp_jogador):
    """Constroi a lista de tokens (posicao 4 em diante) do parser 182.

    itens_jogador: lista de dicts ja com as mesmas chaves dos herois.
    A primeira batalha do jogador usa o proprio userId como objId, tipo 0.
    """
    formacoes, nome_npc = formacao_do_npc(npc_id)
    if not formacoes:
        # NPC sem formacao no acervo: nao inventamos inimigo. Devolvemos None
        # para o chamador responder erro honesto em vez de uma batalha falsa.
        return None
    # Nome do adversario ja RESOLVIDO. Se fosse vazio, o parser cairia em
    # isGetLocalNpcName e tentaria dms.element(...)[3] (ProtocolParserCopy.lua
    # :6482-6488), que devolve nil e derruba o parser com "attempt to
    # concatenate a nil value" — foi o erro observado. Preencher o nome
    # evita esse caminho, que o servidor oficial tambem evita por mandar dado.
    if nome_npc:
        nome_adversario = nome_npc
    else:
        nome_adversario = "NPC_%s" % npc_id

    t = []
    t.append("0")                       # battle_init_type: 0 = pve comum
    t.append(str(npc_id))               # objId
    t.append(str(dificuldade or 0))     # battle_level
    t.append(str(len(formacoes)))       # battle_total_count
    t.append("0")                       # attacker_priority
    t.append("0")                       # defender_priority
    t.append(campo_valido(nome_jogador))     # attacker_name
    t.append(campo_valido(nome_adversario))  # defender_name
    t.append("1")                       # attacker_head_pic
    t.append("1")                       # defender_head_pic

    herois = itens_jogador or []
    t.append(str(len(herois)))          # _hero_number
    for h in herois:
        for chave in ("_id", "_pos", "_head", "_power_skill_id",
                      "_fit_skill_id", "_quality", "_hp", "_sp", "_type",
                      "_mouldId", "_scale", "_name",
                      "_evolution_level", "_hero_speed", "_max_hp"):
            t.append(campo_valido(h.get(chave, "0")))

    t.append("0")                       # viceId
    t.append("")                        # attribute (vazio e aceito)

    for idx, fid in enumerate(formacoes):
        inimigos = inimigos_da_formacao(fid)
        if not inimigos:
            return None
        formacoes_tbl = tabela("environment_formation.txt")
        nome = campo_valido(_s(formacoes_tbl[str(fid)], EF["name"], "F%d" % fid))
        t.append(str(idx + 1))          # _battle_number
        t.append(nome)                  # _battleName
        t.append(str(len(inimigos)))    # _enemy_number
        for e in inimigos:
            for chave in ("_id", "_pos", "_head", "_power_skill_id",
                          "_fit_skill_id", "_quality", "_hp", "_sp", "_type",
                          "_mouldId", "_scale", "_name"):
                t.append(campo_valido(e.get(chave, "0")))
            # ramo l_naruto, na MESMA ordem do parser:
            #   _hero._evolution_level, _hero._hero_speed, _hero._max_hp
            t.append(campo_valido(e.get("_evolution_level", "0")))
            t.append(campo_valido(e.get("_hero_speed", "0")))
            t.append(campo_valido(e.get("_max_hp", e.get("_hp", "1"))))
    return t
