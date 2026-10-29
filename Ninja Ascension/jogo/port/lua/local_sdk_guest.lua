-- port/lua/local_sdk_guest.lua — ADAPTADOR DO SDK LOCAL (conta do próprio jogo).
--
-- CADEIA REAL: no Windows o handlePlatformRequest do acervo TERMINA CEDO
-- (ThirdpartySupporter.lua:2183-2187: plataforma desktop -> return) e nada
-- no acervo fica no lugar dos callbacks do SDK: os flags m_sdk_init_success /
-- m_sdk_login_success não viram true e o GAME START morre nas filas 433-439
-- de login.lua (excute platform_manager_sdk_init / platform_manager_login,
-- silêncio).
--
-- A função de callbacks do acervo (handlePlatformResponse) é um LOCAL do
-- chunk (ThirdpartySupporter.lua:346-348), inacessível de fora. Então este
-- adaptador replica o EFEITO exato dos dois branches relevantes:
--   * ENTERED_THE_GAME = 130 -> init do SDK (502-509)
--   * LOGIN = 10 -> login do SDK + re-busca da lista (513-525)
--
-- NÃO existe login automático de convidado. m_sUin é preenchido pelo
-- servidor local no S2C 327 do platform_user_login (ProtocolParser.lua:1194),
-- isto é, só depois de uma conta REAL se autenticar (ver port/server/contas.py).
--
-- Este arquivo NÃO toca no protocolo (respostas seguem vindo do servidor
-- local) e só ativa com a flag local_sdk_adapter do app.config do jogo.
--
-- Traçado: state_machine.excute é embrulhado para os terminais da cadeia
-- login→menu, imprimindo os globals do momento (HOST_SDK_TRACE) — sem
-- isso um terminal silencioso não se distingue de um clique perdido.

local M = {}

local ATAQUES_MAX = 400
local ataques = 0
local instalado = false

local terminaisRastreados = {
    ["login_check_first"] = true,
    ["login_vali_register"] = true,
    ["platform_manager_sdk_init"] = true,
    ["platform_manager_sdk_init_success"] = true,
    ["platform_manager_login"] = true,
    ["platform_manager_login_success"] = true,
    ["login_get_server_list"] = true,
    ["login_select_server"] = true,
    ["login_ui_control"] = true,
    ["login_enter_game"] = true,
    ["account_sys_manager_open"] = true,
    ["account_sys_manager_login_define"] = true,
    ["account_sys_register_open"] = true,
    ["account_sys_register_login_define"] = true,
    ["account_sys_register_login"] = true,
    ["account_sys_floating_open"] = true,
    ["login_platform_account"] = true,
}

-- client.mission.Mission define executeMissionExt (Mission.lua:1519) e as
-- constantes mission_mould_* / touch_off_mission_*, mas só é carregado mais
-- tarde, pela tela de carregamento. O checkUserLogin (login.lua:630) chama
-- executeMissionExt ANTES disso e caía em "attempt to call global
-- 'executeMissionExt' (a nil value)" — o login morria exatamente depois do
-- vali_register, que é onde o jogador via a tela de carregamento travada.
-- Carregamos o módulo aqui, que é só definir funções/constantes globais.
local function garantirMission()
    if type(executeMissionExt) == "function" then return true end
    local ok, err = pcall(function() app.load("client.mission.Mission") end)
    if not ok then
        print("HOST_LOCAL_SDK aviso: nao consegui carregar Mission.lua: "
            .. tostring(err))
        return false
    end
    if type(executeMissionExt) == "function" then
        print("HOST_LOCAL_SDK Mission.lua carregado (executeMissionExt pronta)")
        return true
    end
    return false
end

-- ReconnectView precisa mostrar uma mensagem UTILIZAVEL quando a conexao
-- falha. O acervo confia em Panel_5322 existir e chama :setVisible direto
-- (ReconnectView.lua:366/375/382). Se o widget faltar, a janela de erro
-- quebra com "attempt to index local 'Panel_5322'" e o jogador fica sem
-- mensagem nenhuma.
--
-- O alias Panel_5322->Panel_5322_pr2 (boot_map.lua) resolve o caso real.
-- Esta guarda cobre o resto: transforma nil em um objeto inerte, para que
-- os textos (Label_5324 / Label_5324_0), que o acervo JA protege com nil,
-- aparecam normalmente.
local function instalarGuardaDaReconexao()
    local Protect = {}
    Protect.__index = function(_, chave)
        if chave == "setVisible" or chave == "setString"
            or chave == "setTitleText" or chave == "addClickEventListener"
            or chave == "setScale" or chave == "setPosition"
            or chave == "setTouchEnabled" or chave == "setOpacity" then
            return function() end
        end
        if chave == "isVisible" then
            return function() return false end
        end
        return function() return nil end
    end
    Protect.__newindex = function() end
    local function novoInerte()
        return setmetatable({}, Protect)
    end
    -- Instala depois que ccui existir (o modulo pode ser carregado antes).
    local tentativas = 0
    local function armar()
        if ccui == nil or ccui.Helper == nil then return false end
        if package.__nr_guarda_reconexao then return true end
        package.__nr_guarda_reconexao = true
        local seek = ccui.Helper.seekWidgetByName
        local PROTEGIDOS = { ["Panel_5322"] = true, ["Panel_5322_en"] = true }
        ccui.Helper.seekWidgetByName = function(...)
            local nome = select(select("#", ...), ...)
            local no = seek(...)
            if no == nil and type(nome) == "string" and PROTEGIDOS[nome] then
                print("HOST_RECONNECT widget ausente '" .. nome
                    .. "' -> objeto inerte (mensagem segue visivel)")
                return novoInerte()
            end
            return no
        end
        print("HOST_RECONNECT guarda instalada")
        return true
    end
    package.__nr_guarda_reconexao_armar = armar
    if not armar() then
        local sched = cc.Director:getInstance():getScheduler()
        local entry
        entry = sched:scheduleScriptFunc(function()
            tentativas = tentativas + 1
            if armar() or tentativas > 300 then
                sched:unscheduleScriptEntry(entry)
            end
        end, 0.1, false)
    end
end

local function estado()
    return "m_sUin=" .. tostring(m_sUin)
        .. " adapter=" .. tostring(app ~= nil and app.configJson ~= nil and app.configJson.local_sdk_adapter)
        .. " init=" .. tostring(m_sdk_init_success)
        .. " login=" .. tostring(m_sdk_login_success)
end

-- Diagnostico da cadeia nome do NPC (ProtocolParserCopy.lua:6482-6490):
--   npc.npc_name -> dms.string(npc, id, 2) -> zstring.split("|") ->
--   dms.element(word_mould, wmId) -> word_info[3]
local function diagnosticarNomeDoNpc()
    if package.__nr_diag_nome then return end
    package.__nr_diag_nome = true
    local function tipo(v)
        if v == nil then return "nil" end
        return type(v)
    end
    local ok, err = pcall(function()
        if dms == nil then print("HOST_NOME_DIAG dms nil") return end
        local arquivo = dms["npc"]
        print("HOST_NOME_DIAG dms['npc'] tipo=" .. tipo(arquivo)
            .. " linhas=" .. tostring(arquivo ~= nil and #arquivo or 0))
        if arquivo == nil then return end
        print("HOST_NOME_DIAG dms.string(npc,1196,2)="
            .. tostring(dms.string(dms["npc"], 1196, 2)))
    end)
    if not ok then
        print("HOST_NOME_DIAG erro: " .. tostring(err))
    end
end

-- MODULOS Lua QUE O ACERVO CARREGA NO BLOCO DE ENTRADA DO LOGIN.
--
-- AssetsManager.lua:140-157 (terminal assets_manager_manager_assets_into_login_page)
-- faz esta sequencia. Medido: TuitionController nao existia em tempo de
-- execucao, e Mission.lua:3037 (evento 3点击UI do tutorial) faz
--     fwin:open(TuitionController:new():init(mission), ...)
-- -> "attempt to index global 'TuitionController' (a nil value)": o dialogo
-- do tutorial NAO avanca. O arquivo existe no acervo
-- (client/mission/tuition/TuitionController.lua); so nao era carregado.
local MODULOS_QUE_FALTAM = {
    "client.mission.tuition.TuitionController",  -- AssetsManager.lua:153
    -- BattleScene e carregado em AssetsManager.lua:151, mas esse arquivo NAO
    -- define a classe: a definicao de BattleSceneClass esta inteira
    -- comentada (BattleScene.lua:35 em diante). No fim dele ha so a
    -- delegacao: app.load("client.battle.logics.attack_logic")
    -- (BattleScene.lua:3495), e e attack_logic.lua:61 que define
    -- BattleSceneClass = class("BattleSceneClass", Window).
    --
    -- Sintoma medido quando essa classe nao entra:
    --   Fight.lua:1625  fwin:open(BattleSceneClass:new(), fwin._background)
    -- estoura "attempt to index global 'BattleSceneClass' (a nil value)";
    -- Fight:init morre, a batalha nunca monta e o que sobra na tela e uma
    -- janela vazia (sem cena atras). Carregar aqui garante a classe antes.
    -- Ordem OBRIGATORIA, medida em duas tentativas:
    --
    --  1a tentativa (attack_logic antes de BattleScene):
    --     attack_logic.lua:6661  battle_execute._playEffectMusic = ...
    --     "attempt to index global 'battle_execute' (a nil value)".
    --     battle_execute e criado em BattleScene.lua:3493.
    --
    --  2a tentativa (sem as tabelas de batalha):
    --     attack_logic.lua:136  dms.int(dms["durationmt"], 1, 1) / 60.0
    --     "attempt to perform arithmetic on a nil value".
    --
    -- Portanto: primeiro as tabelas (effect/duration*.txt), depois
    -- BattleScene (que cria battle_execute e, no fim, delegA move_logic e
    -- attack_logic). move_logic e attack_logic ficam na lista apenas como
    -- rede de seguranca, para o erro aparecer identificado aqui caso
    -- BattleScene nao consiga carrega-los.
    "client.battle.BattleScene",
    "client.battle.logics.move_logic",
    "client.battle.logics.attack_logic",
}

-- TABELAS que o carregador de attack_logic exige.
--
-- Medido: client/battle/logics/attack_logic.lua:136 faz
--   local moveToTargetTime1 = dms.int(dms["durationmt"], 1, 1) / 60.0
-- Se dms["durationmt"] for nil, dms.int devolve nil e "nil / 60.0" estoura
-- "attempt to perform arithmetic on a nil value". Com isso o require de
-- BattleScene falha no meio, BattleSceneClass nunca e criada, e mais tarde
-- Fight.lua:1625 estoura "attempt to index global 'BattleSceneClass'".
--
-- No acervo essas tabelas sao carregadas por localData_attack_logic
-- (client/loader/LocalDatas.lua:6711-6713), chamada em AssetsManager.lua:150
-- ANTES do app.load("client.battle.BattleScene") da linha 151. Aqui
-- reproduzimos essa ordem explicitamente.
local TABELAS_DE_BATALHA = {
    "effect/duration.txt",
    "effect/durationmt.txt",
}

local function carregarTabelasDeBatalha()
    if type(dms) ~= "table" or type(dms.load) ~= "function" then return false end
    local faltou = false
    for _, nome in ipairs(TABELAS_DE_BATALHA) do
        local ok, err = pcall(dms.load, nome)
        if not ok then
            faltou = true
            print("HOST_TABELAS_BATALHA pendente: " .. nome .. " ("
                .. tostring(err) .. ")")
        end
    end
    return not faltou
end

local function carregarModulosQueFaltam()
    if package.__nr_modulos_faltando then return true end
    if type(app) ~= "table" or type(app.load) ~= "function" then return false end
    -- As tabelas vem primeiro: attack_logic le dms["durationmt"] no topo do
    -- arquivo, na hora do require, nao dentro de uma funcao.
    if not carregarTabelasDeBatalha() then
        return false
    end
    local faltou = false
    for _, nome in ipairs(MODULOS_QUE_FALTAM) do
        -- A global que cada modulo precisa definir. Sem isto o check por
        -- nome-curto (attack_logic -> global "attack_logic") nunca detecta
        -- nada: o arquivo define BattleSceneClass, nao "attack_logic".
        local exigido = (nome == "client.battle.BattleScene"
                         and "BattleSceneClass") or nome:match("([^%.]+)$")
        if _G[exigido] == nil then
            -- Se o require falhou numa tentativa anterior, o LuaJIT guarda o
            -- erro em package.loaded[modulo] ("previous error loading
            -- module") e toda tentativa seguinte devolve o mesmo erro velho
            -- sem executar o arquivo. Limpamos a marca para que a nova
            -- tentativa (agora com as tabelas carregadas) realmente rode.
            if package.loaded[nome] ~= nil then
                package.loaded[nome] = nil
                app.preload[nome] = nil
            end
            local ok, err = pcall(app.load, nome)
            if not ok then
                faltou = true
                print("HOST_MODULOS pendente: " .. nome .. " ("
                    .. tostring(err) .. ")")
            elseif _G[exigido] == nil then
                faltou = true
                print("HOST_MODULOS pendente: " .. nome .. " nao definiu " .. exigido)
            else
                print("HOST_MODULOS " .. nome .. " carregado (" .. exigido .. ")")
            end
        end
    end
    if faltou then
        return false
    end
    return true
end

-- TABELAS DE DADOS QUE O ACERVO NAO CARREGA.
--
-- Medido (nao suposto): em client/loader/LocalDatas.lua:6134 a linha
--     dms.load("data/npc.txt")
-- esta COMENTADA, embora as vizinhas usadas em batalha estejam ativas
-- (:6719 ship_mould, :6720 environment_ship). Resultado em tempo de
-- execucao: dms["npc"] == nil.
--
-- Isso derruba o parser 182 (ProtocolParserCopy.lua:6482-6490): ele faz
--     local localNpcName = dms.string(dms["npc"], objId, npc.npc_name) -- nil
--     local name_data = zstring.split(localNpcName, "|")               -- nil
--     name_info = name_info .. word_info[3]        -- nil -> erro
-- que e exatamente o "attempt to concatenate a nil value" na linha 6488.
--
-- A correcao e CARREGAR a tabela que o acervo esqueceu de carregar — o
-- mesmo dms.load que ele usa para as tabelas vizinhas. Nada do acervo e
-- editado, e nenhum nil vira string vazia para esconder o erro: com a
-- tabela carregada, o nome e resolvido de verdade (NPC 1196 -> "Tsunade").
local TABELAS_QUE_FALTAM = {
    "data/npc.txt",          -- LocalDatas.lua:6134 (comentado no acervo)
    -- word_mould: mesma historia, e sem ela o parser 182 quebra no passo
    -- seguinte. Comprovado pela sonda (HOST_SONDA_NPC):
    --   dms.string(npc,1196,2) -> "1"
    --   zstring.split -> {"1"}
    --   dms.element(word_mould, 1) -> nil      <-- aqui nascia o nil
    -- O arquivo existe em data/mould/word_mould.txt (linha 1 = "Tsunade",
    -- coluna 3); simplesmente nao era carregado.
    "data/word_mould.txt",
}

-- Preparacao EXTRA que o acervo faz e que precisa vir depois do load.
-- AssetsManager.lua:145-148 (projeto l_naruto, que e o nosso) faz:
--     dms.load("data/mould/word_mould.txt")
--     dms.format("word_mould", 2)
-- dms.format (local_datas.lua) indexa a tabela pelo conteudo da coluna 2,
-- deixando-a no formato que dms.element/dms.string esperam. Sem ele a
-- tabela fica so com linhas cruas e as consultas erram.
local FORMATAR = {
    ["word_mould"] = 2,
}

local function carregarTabelasQueFaltam()
    if package.__nr_tabelas_faltando then return true end
    if dms == nil or cc == nil or cc.dms_load == nil then return false end
    -- ORDEM IMPORTA (medido): o SDK e instalado no stage do boot ANTES de
    -- port/lua/data_paths.lua armar o remapeamento data/x.txt -> data/mould/x.txt
    -- (boot_map.lua stage 5b). Chamando aqui antes disso, o caminho
    -- "data/npc.txt" nao existe e o dms_load falha. Por isso so marcamos
    -- como feito quando a tabela realmente carregou, e o chamador tenta de
    -- novo mais tarde.
    package.__nr_tabelas_faltando = true
    local faltou = false
    for _, caminho in ipairs(TABELAS_QUE_FALTAM) do
        local nome = caminho:match("([^/]+)%.txt$")
        if dms[nome] == nil then
            local ok, err = pcall(function()
                dms.load(caminho)
            end)
            if not ok then
                faltou = true
                print("HOST_TABELAS pendente: " .. caminho .. " ("
                    .. tostring(err) .. ")")
            elseif dms[nome] == nil then
                faltou = true
                print("HOST_TABELAS pendente: " .. caminho .. " carregou vazio")
            else
                print("HOST_TABELAS " .. caminho .. " carregado ("
                    .. tostring(#dms[nome]) .. " linhas)")
                -- Formato pos-load, igual ao que o acervo aplica
                -- (AssetsManager.lua:147). Feito uma vez so.
                local coluna = FORMATAR[nome]
                if coluna ~= nil and type(dms.format) == "function" then
                    local okf, errf = pcall(dms.format, nome, coluna)
                    if okf then
                        print("HOST_TABELAS " .. nome .. " formatado por coluna "
                            .. tostring(coluna))
                    else
                        print("HOST_TABELAS " .. nome .. " dms.format falhou: "
                            .. tostring(errf))
                    end
                end
            end
        end
    end
    if faltou then
        package.__nr_tabelas_faltando = nil
        return false
    end
    return true
end

-- SONDA EXATA do parser 182 (ProtocolParserCopy.lua:6482-6490).
-- Reproduz, passo a passo, as MESMAS expressoes do parser, para provar em
-- qual delas o valor e nil — em vez de deduzir lendo o codigo.
function M.sondarNomeDoNpc(npc_id)
    npc_id = npc_id or 1196
    local function t(v)
        if v == nil then return "nil" end
        return type(v) .. "=" .. tostring(v):sub(1, 40)
    end
    local linhas = {}
    local function add(s) linhas[#linhas+1] = s end
    local ok, err = pcall(function()
        add("dms['npc'] " .. (dms and dms["npc"] and ("ok linhas=" .. #dms["npc"]) or "NIL"))
        local coluna = 2
        local localNpcName = dms.string(dms["npc"], npc_id, coluna)
        add("dms.string(npc," .. npc_id .. ",2) -> " .. t(localNpcName))
        local dados = zstring.split(localNpcName, "|")
        add("zstring.split -> " .. t(dados))
        if type(dados) == "table" then
            for i, v in pairs(dados) do
                local num = zstring.tonumber(v)
                add("  parte[" .. tostring(i) .. "]=" .. t(v) .. " num=" .. t(num))
                local w = dms.element(dms["word_mould"], num)
                add("    dms.element(word_mould," .. tostring(num) .. ") -> " .. t(w))
                if type(w) == "table" then
                    add("    word_info[3] -> " .. t(w[3]))
                elseif type(w) == "string" then
                    add("    dms.string(word_mould,num,3) -> "
                        .. t(dms.string(dms["word_mould"], num, 3)))
                end
            end
        end
    end)
    if not ok then add("EXCECAO: " .. tostring(err)) end
    print("HOST_SONDA_NPC " .. table.concat(linhas, " || "))
    return linhas
end

-- Nova tentativa ate a tabela entrar (ou desistir depois de ~30 s).
function M.insistirNasTabelas()
    if package.__nr_tabelas_insistindo then return end
    package.__nr_tabelas_insistindo = true
    local tentativas = 0
    local function passo()
        tentativas = tentativas + 1
        local prontas = carregarTabelasQueFaltam()
        local modulos = carregarModulosQueFaltam()
        if (prontas and modulos) or tentativas > 300 then
            if package.__nr_parar_insistencia ~= nil then
                pcall(package.__nr_parar_insistencia)
                package.__nr_parar_insistencia = nil
            end
            -- Tabela pronta: reproduz o parser 182 com as MESMAS expressoes.
            pcall(M.sondarNomeDoNpc, 1196)
        end
    end
    if cc ~= nil and cc.Director ~= nil then
        local sched = cc.Director:getInstance():getScheduler()
        local entry = sched:scheduleScriptFunc(passo, 0.1, false)
        package.__nr_parar_insistencia = function()
            sched:unscheduleScriptEntry(entry)
        end
    else
        passo()
    end
end

local function sintetizarInitSdk()
    -- Efeito EXato do branch ENTERED_THE_GAME do acervo
    -- (ThirdpartySupporter.lua:502-509, projeto t4-quick).
    if m_sdk_init_success ~= true then
        m_sdk_init_success = true
        print("HOST_LOCAL_SDK init pronto (" .. estado() .. ")")
        if state_machine ~= nil then
            state_machine.excute("platform_manager_sdk_init_success", 0, "platform_manager_sdk_init_success.")
        end
    end
    return true
end

local function sintetizarLoginSucesso()
    -- Efeito EXato do branch LOGIN_SUCCESS do acervo
    -- (ThirdpartySupporter.lua:513-525, ramo t4-quick).
    --
    -- A conta NÃO é inventada aqui: o 327 do servidor local já gravou m_sUin
    -- (ProtocolParser.lua:1194). Sem conta autenticada o login do SDK não é
    -- dado como pronto — o jogo volta à tela de conta em vez de entrar como
    -- fantasma.
    if m_sUin == nil or m_sUin == "" then
        print("HOST_LOCAL_SDK login adiado: nenhuma conta autenticada (m_sUin vazio)")
        return false
    end
    if m_sdk_login_success ~= true then
        m_loading_start = true
        m_sdk_login_success = true
        print("HOST_LOCAL_SDK login pronto (" .. estado() .. ")")
        if state_machine ~= nil then
            state_machine.excute("platform_manager_login_success", 0, { platformInfo = m_sUin })
            state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
        end
    end
    return true
end

local CODIGO_LOGOUT_LOCAL = 990001

local function registrarComandoDeLogout()
    -- NetworkProtocol.command_func chama protocol_command[NOME].command_fun
    -- para montar o corpo. O comando de logout é extensão do servidor local
    -- (o acervo não tem logout HTTP), então a tabela é registrada AQUI, no
    -- adaptador, sem editar ProtocolCommander.
    if type(protocol_command) ~= "table" then return false end
    if protocol_command.local_logout ~= nil then return true end
    protocol_command.local_logout = {
        code = CODIGO_LOGOUT_LOCAL,
        command = "local_logout",
        param_list = "",
        command_fun = function(str)
            str = str .. "\r\n"
            str = str .. "local_logout"
            str = str .. "\r\n"
            str = str .. (userLoginToken == nil and "" or userLoginToken)
            str = str .. "\r\n"
            str = str .. (m_sUin == nil and "" or m_sUin)
            str = str .. "\r\n"
            return str
        end,
    }
    return true
end

local function revogarSessaoNoServidor()
    -- Sair da conta precisa invalidar a sessão NO SERVIDOR (prioridade 2,
    -- item 6). No acervo o LOGOUT é mensagem de SDK (ThirdpartySupporter
    -- .lua:23, tipo 20) e não existe comando HTTP de logout: o servidor
    -- oficial confiava no SDK da plataforma. Aqui mandamos "local_logout"
    -- (implementado em port/server/local_server.py), que revoga a sessão
    -- apresentada. Falha de rede não pode impedir a saída do jogador.
    if type(NetworkManager) ~= "table" or type(NetworkManager.register) ~= "function" then
        print("HOST_LOCAL_SDK logout: NetworkManager indisponivel")
        return
    end
    if userLoginToken == nil or userLoginToken == "" then
        print("HOST_LOCAL_SDK logout: sem token de sessao para revogar")
        return
    end
    if not registrarComandoDeLogout() then
        print("HOST_LOCAL_SDK logout: protocol_command indisponivel")
        return
    end
    local ok = pcall(function()
        NetworkManager:register(CODIGO_LOGOUT_LOCAL, app.configJson.url, nil, nil, nil,
            function(response)
                print("HOST_LOCAL_SDK logout status="
                    .. tostring(response ~= nil and response.PROTOCOL_STATUS))
            end, false, nil, false)
    end)
    if not ok then
        print("HOST_LOCAL_SDK logout: pedido nao enviado")
    end
end

local function limparEstadoDoCliente()
    -- Estado da conta no cliente: m_sUin, token e cache de plataforma. O
    -- acervo já zera parte disso em account_sys_floating_switch
    -- (AccountSysFloatingWindow.lua:73-105); aqui garantimos o resto para
    -- que a próxima conta não herde nada da anterior.
    m_sUin = ""
    userLoginToken = nil
    userLoginPackageName = nil
    if _ED ~= nil then
        _ED.user_platform = {}
        _ED.default_user = nil
    end
    print("HOST_LOCAL_SDK logout: estado do cliente limpo")
end

local function instalarTraceDeStart()
    -- GAME START passa por login_vali_register, cujo _invoke RETORNA sem
    -- fazer nada quando a precarga das tabelas não terminou
    -- (login.lua:444-451). Sem traço, isso é indistinguível de "o clique
    -- não chegou". Aqui embru lhamos Login:precargaHecha e o terminal para
    -- imprimir o estado real toda vez que o START é tentado.
    if package.__nr_trace_start then return end
    package.__nr_trace_start = true

    -- instrumenta a guarda do terminal. Lê state_machine._terminals direto:
    -- state_machine.find imprime um erro no log toda vez que não acha, e isso
    -- viraria spam a cada excute.
    if type(state_machine) == "table" and type(state_machine._terminals) == "table" then
        local t = state_machine._terminals["login_vali_register"]
        if not package.__nr_dump_terminais then
            package.__nr_dump_terminais = true
            local nomes = {}
            for k, _ in pairs(state_machine._terminals) do
                nomes[#nomes + 1] = tostring(k)
            end
            table.sort(nomes)
            print("HOST_START_TRACE terminais registrados (" .. #nomes .. "): "
                .. table.concat(nomes, ","))
        end
        if t == nil then
            if not package.__nr_start_avisou then
                package.__nr_start_avisou = true
                print("HOST_START_TRACE terminal login_vali_register ainda nao existe")
            end
        elseif type(t._invoke) ~= "function" then
            print("HOST_START_TRACE terminal sem _invoke")
        elseif not t.__nr_traced then
            local orig = t._invoke
            t.__nr_traced = true
            t._invoke = function(terminal, instance, params)
                local completa = instance ~= nil and instance._isLoadLocalDataComplete
                local hecho = false
                if instance ~= nil and type(instance.precargaHecha) == "function" then
                    local ok, r = pcall(function() return instance:precargaHecha() end)
                    hecho = ok and r or ("ERRO:" .. tostring(r))
                end
                print("HOST_START_TRACE vali_register | dadosLocais=" .. tostring(completa)
                    .. " precarga=" .. tostring(hecho)
                    .. " m_sUin=" .. tostring(m_sUin)
                    .. " trava=" .. tostring(terminal ~= nil and terminal._lock))
                local ok2, e = pcall(orig, terminal, instance, params)
                if not ok2 then
                    print("HOST_START_TRACE ERRO em login_vali_register: " .. tostring(e))
                end
                return ok2 and e or nil
            end
            print("HOST_START_TRACE instalado (login_vali_register)")
        end
    end
end

local function tentarInstalar()
    if instalado then return true end
    if type(handlePlatformRequest) ~= "function" then return false end
    if app == nil or app.configJson == nil then return false end
    if app.configJson.local_sdk_adapter ~= true then
        instalado = true   -- modo puro: sem jogo adaptado, não toca em nada
        return true
    end
    if package.__nr_local_sdk_guest then return true end
    package.__nr_local_sdk_guest = true

    -- (1) handlePlatformRequest: no desktop o original é no-op (guard de
    -- plataforma em 2183-2187); aqui os dois pedidos do fluxo t4-quick
    -- produzem o efeito original dos seus callbacks (funções acima).
    local original = handlePlatformRequest
    _G.handlePlatformRequest = function(request, messageType, messageText)
        if messageType == 130 then        -- ENTERED_THE_GAME (ThirdpartySupporter.lua:51)
            return sintetizarInitSdk()
        elseif messageType == 10 then     -- LOGIN (ThirdpartySupporter.lua:18)
            return sintetizarLoginSucesso()
        elseif messageType == 20 then     -- LOGOUT (ThirdpartySupporter.lua:23)
            revogarSessaoNoServidor()
            limparEstadoDoCliente()
            -- Depois faz o que o original faria (branch LOGOUT_SUCCESS / tela
            -- de login); o original é no-op no desktop, então nada a chamar.
            return true
        end
        return original(request, messageType, messageText)
    end

    -- (2) Traçado dos terminais da cadeia de clique (state_machine global do
    -- framework; só estes nomes imprimem).
    --
    -- Além do nome, mostra o RESULTADO e captura erros: um terminal que
    -- levanta erro em silêncio parecia "fluxo parado" (o jogo ficava na
    -- tela de conta sem nenhum aviso). Com o pcall aqui, a falha real
    -- aparece no console como HOST_SDK_TRACE ERRO.
    if type(state_machine) == "table" and type(state_machine.excute) == "function"
        and not package.__nr_sdk_trace then
        local excuteOriginal = state_machine.excute
        state_machine.excute = function(name, state, params)
            if terminaisRastreados[name] then
                -- O terminal login_vali_register nasce quando Login é
                -- construído, depois de armar(): tenta instalar o traço aqui,
                -- no primeiro excute da cadeia.
                instalarTraceDeStart()
                print("HOST_SDK_TRACE excute " .. tostring(name) .. " | " .. estado())
                local ok, r1, r2 = pcall(excuteOriginal, name, state, params)
                if not ok then
                    print("HOST_SDK_TRACE ERRO em " .. tostring(name) .. ": " .. tostring(r1))
                    return nil
                end
                if name == "login_get_server_list" or name == "login_vali_register"
                    or name == "login_enter_game" then
                    print("HOST_SDK_TRACE resultado " .. tostring(name) .. " -> "
                        .. tostring(r1) .. " m_loading_start=" .. tostring(m_loading_start))
                end
                return r1, r2
            end
            return excuteOriginal(name, state, params)
        end
        package.__nr_sdk_trace = true
    end

    instalado = true
    instalarTraceDeStart()
    -- Antes de qualquer login: o fluxo de entrada chama executeMissionExt.
    if type(app) == "table" and type(app.load) == "function" then
        garantirMission()
    end
    instalarGuardaDaReconexao()
    -- Pode falhar aqui (o remapeamento de caminho de data_paths ainda nao
    -- esta armado); insistirNasTabelas tenta de novo ate entrar.
    carregarTabelasQueFaltam()
    carregarModulosQueFaltam()
    M.insistirNasTabelas()
    M.instalarSondaDeBatalha()
    M.instalarSondaDeJanelas()
    M.instalarSondaDeEventos()
    -- O Mission e carregado depois do SDK; tenta de novo por alguns quadros.
    pcall(function()
        local sched = cc.Director:getInstance():getScheduler()
        local tentativas = 0
        local entrada
        entrada = sched:scheduleScriptFunc(function()
            tentativas = tentativas + 1
            M.instalarSondaDeEventos()
            M.instalarSondaDeBatalhaFight()
            M.instalarSondaDoLoading()
            -- Diagnostico da propria sonda: mostra o que ja existe.
            if tentativas % 50 == 1 then
                print(string.format(
                    "HOST_SONDA_ESTADO t=%d MissionClass=%s FightModule=%s "
                    .. "FightLoadingCell=%s eventos=%s fight=%s loading=%s",
                    tentativas, type(MissionClass), type(_G.FightModule),
                    type(_G.FightLoadingCell),
                    tostring(package.__nr_sonda_eventos),
                    tostring(package.__nr_sonda_fight),
                    tostring(package.__nr_sonda_loading)))
            end
            -- As classes de batalha so nascem depois do login, entao a sonda
            -- NAO pode desistir cedo: fica tentando enquanto o jogo roda
            -- (~10 min a 0,1 s). Cada sonda arquiva a propria marca quando
            -- instala, e instalar duas vezes nao duplica nada.
            if tentativas > 6000 then
                sched:unscheduleScriptEntry(entrada)
            end
        end, 0.1, false)
    end)
    print("HOST_LOCAL_SDK instalado (síntese 130/11 sem convidado + traçado)")
    return true
end

-- SONDA DA TRANSICAO PARA A BATALHA.
--
-- Sintoma: o carregamento termina, os personagens e os textos aparecem, mas o
-- fundo fica PRETO e a batalha nao comeca. Medido no log do servidor:
--   1) FormationTigerGate.lua:5931 -> "Shader compile failed!"
--   2) FightLoading.lua:292 -> addTigerGateFightUI (nil)  <- consequencia de 1
--   3) fwin.lua:938 -> retain de obj invalido            <- consequencia de 2
--   4) FightLoadingCell PERMANECE vivo na hierarquia (camada de carregamento
--      nunca encerrada), e e ela que cobre a cena de preto.
--
-- Esta sonda so OBSERVA: registra cada createNode, o CSB e o que a cena tem.
-- Nao corrige nada e nao troca de cena.
function M.instalarSondaDeBatalha()
    if package.__nr_sonda_batalha then return end
    package.__nr_sonda_batalha = true

    -- 1) cada csb.createNode: mostra arquivo, existencia e o retorno
    local csbTabela = _G.csb
    if type(csbTabela) == "table" and type(csbTabela.createNode) == "function" then
        local original = csbTabela.createNode
        csbTabela.createNode = function(nome)
            local caminho = (csbTabela.rootPath or "") .. tostring(nome)
            local existe = false
            pcall(function()
                existe = cc.FileUtils:getInstance():isFileExist(caminho)
            end)
            print("HOST_CSB createNode " .. tostring(nome)
                .. " existe=" .. tostring(existe))
            local ok, noOuErro = pcall(original, nome)
            if not ok then
                -- Diagnostico: o erro de shader vem de dentro do CSLoader e nao
                -- diz qual widget/textura o disparou. Registramos o contexto
                -- util: qual CSB, e o estado do cache de texturas/shaders.
                print("HOST_CSB createNode FALHOU " .. tostring(nome)
                    .. " | erro=" .. tostring(noOuErro))
                local partes = {}
                local okf = pcall(function()
                    local tc = cc.Director:getInstance():getTextureCache()
                    partes[#partes+1] = "texturas=" .. tostring(
                        (tc.getCachedTextureInfo ~= nil) and "info" or "?")
                end)
                if not okf then
                    partes[#partes+1] = "falha ao consultar cache"
                end
                partes[#partes+1] = "arquivo=" .. caminho
                print("HOST_CSB contexto: " .. table.concat(partes, " ; "))
                error(noOuErro, 0)
            end
            print("HOST_CSB createNode OK " .. tostring(nome)
                .. " -> " .. (noOuErro ~= nil and "node" or "nil"))
            return noOuErro
        end
    end

    -- 2) retrato da cena quando a batalha deveria estar de pe
    M.retratarCena = function(rotulo)
        rotulo = rotulo or "?"
        local partes = {}
        local function add(s) partes[#partes+1] = s end
        local ok, err = pcall(function()
            local cena = cc.Director:getInstance():getRunningScene()
            if cena == nil then add("cena=NIL") return end
            add("cena=" .. tostring(cena))
            local function visitar(no, prof, contador)
                if contador.n > 60 then return end
                contador.n = contador.n + 1
                local nome = nil
                pcall(function() nome = no:getName() end)
                local vis, opac = nil, nil
                pcall(function() vis = no:isVisible() end)
                pcall(function() opac = no:getOpacity() end)
                add(string.rep(" ", prof) .. tostring(nome)
                    .. " vis=" .. tostring(vis)
                    .. " op=" .. tostring(opac))
                local filhos = nil
                pcall(function() filhos = no:getChildren() end)
                if filhos ~= nil then
                    for _, f in ipairs(filhos) do
                        visitar(f, prof + 1, contador)
                    end
                end
            end
            visitar(cena, 0, { n = 0 })
        end)
        if not ok then add("EXCECAO: " .. tostring(err)) end
        print("HOST_CENA[" .. rotulo .. "] " .. table.concat(partes, " | "))
    end
end

-- SONDA DE JANELAS (fwin:open).
--
-- Sintoma: depois das correcoes, aparece uma janela intitulada "Event" com
-- recursos no topo, coluna lateral vazia e botao X — em vez da batalha do
-- tutorial. Precisamos saber QUAL classe foi aberta, EM QUE camada e QUEM a
-- abriu (pilha). Nao se deduz pelo texto do titulo.
function M.instalarSondaDeJanelas()
    if package.__nr_sonda_janelas then return end
    if type(fwin) ~= "table" or type(fwin.open) ~= "function" then return end
    package.__nr_sonda_janelas = true
    local original = fwin.open
    -- Nome da camada a partir da tabela usada pelo chamador.
    local function camada(layer)
        if layer == fwin._view then return "view" end
        if layer == fwin._windows then return "windows" end
        if layer == fwin._dialog then return "dialog" end
        if layer == fwin._system then return "system" end
        if layer == fwin._display_log then return "display_log" end
        return "outra"
    end
    -- Preserve the colon-call ABI: fwin:open(window, layer) passes fwin first.
    -- Dropping that parameter discarded the requested container and changed
    -- which windows createFight's cleanView calls destroyed.
    fwin.open = function(self, janela, layer, ...)
        -- A janela e uma instancia de Window (o acervo a identifica por
        -- __cname, ver fwin:find em fwin.lua:1311-1320). Lemos
        -- explicitamente cada campo, sem pcall unico que engole o erro.
        local classe = "?"
        if janela ~= nil then
            local achou = false
            for _, campo in ipairs({ "__cname", "className", "_name" }) do
                local okv, valor = pcall(function() return janela[campo] end)
                if okv and type(valor) == "string" and valor ~= "" then
                    classe = valor
                    achou = true
                    break
                end
            end
            if not achou then
                local okn, nome = pcall(function() return janela:getName() end)
                if okn and type(nome) == "string" and nome ~= "" then
                    classe = nome
                end
            end
        end
        -- Pilha resumida: as 4 primeiras origens fora do fwin.
        local pilha = {}
        pcall(function()
            local t = debug.traceback("", 2) or ""
            for linha in t:gmatch("[^\n]+") do
                local arq, num = linha:match("([%w_%./\\%-]+%.lua):(%d+)")
                if arq ~= nil and not arq:find("fwin%.lua") then
                    pilha[#pilha+1] = arq:match("([%w_%-]+%.lua)$") .. ":" .. num
                    if #pilha >= 4 then break end
                end
            end
        end)
        print("HOST_JANELA open classe=" .. classe
            .. " camada=" .. camada(layer)
            .. " de=" .. table.concat(pilha, " <- "))
        local r1, r2 = original(self, janela, layer, ...)
        -- Descobrir a classe de verdade. O __cname de class("XClass", ...)
        -- fica na METATABELA da instancia (indexacao v.__cname funciona em
        -- fwin:find, fwin.lua:1314, porque la a comparacao e feita pelo
        -- proprio runtime Lua). Aqui tentamos, em ordem: indexacao direta,
        -- metatabela, e por fim o _list com o objeto devolvido por push.
        if classe == "?" and janela ~= nil then
            local candidatos = { janela, r1 }
            for _, obj in ipairs(candidatos) do
                if obj ~= nil and classe == "?" then
                    local ok1, n1 = pcall(function() return obj.__cname end)
                    if ok1 and type(n1) == "string" and n1 ~= "" then
                        classe = n1
                    else
                        local ok2, n2 = pcall(function()
                            local mt = getmetatable(obj)
                            if type(mt) == "table" then return mt.__cname end
                        end)
                        if ok2 and type(n2) == "string" and n2 ~= "" then
                            classe = n2
                        end
                    end
                end
            end
        end
        print("HOST_JANELA aberta classe=" .. classe
            .. " camada=" .. camada(layer))
        -- Retrato de TODAS as janelas vivas logo depois de cada abertura:
        -- e assim que se prova qual camada cobre a batalha, em vez de supor.
        if type(fwin._list) == "table" then
            local votos, ordem = {}, {}
            for _, v in pairs(fwin._list) do
                if v ~= nil then
                    local okn, nome = pcall(function() return v.__cname end)
                    if okn and type(nome) == "string" then
                        if votos[nome] == nil then ordem[#ordem+1] = nome end
                        votos[nome] = (votos[nome] or 0) + 1
                    end
                end
            end
            local partes = {}
            for _, nome in ipairs(ordem) do
                partes[#partes+1] = nome .. "x" .. votos[nome]
            end
            print("HOST_JANELAS vivas (" .. #ordem .. "): "
                .. table.concat(partes, ","))
        end
        return r1, r2
    end
    print("HOST_JANELA sonda instalada")
end

-- SONDA DE CORRIDA DE ESTADO.
--
-- A sequencia do tutorial depende de executar o evento seguinte ao terminar o
-- anterior. Instrumenta saveExecuteEvent/executeNextEvent do Mission para
-- registrar o evento corrente — e assim ver onde a sequencia desvia.
function M.instalarSondaDeEventos()
    if package.__nr_sonda_eventos then return end
    -- As funcoes do Mission vivem na INSTANCIA (a global "mission"), nao na
    -- classe: Mission.lua usa "executeTouchUI = function()" e
    -- "function MissionClass:ctor()", que registram na instancia.
    local alvo = nil
    if type(mission) == "table" then alvo = mission end
    if alvo == nil and type(MissionClass) == "table" then alvo = MissionClass end
    if alvo == nil then return end
    local alvos = {
        "saveExecuteEvent", "executeNextEvent", "executeEvent",
        "executeTouchUI", "executeMission",
    }
    -- So marca como instalado quando achou ao menos uma funcao.
    local quantos = 0
    for _, nome in ipairs(alvos) do
        if type(alvo[nome]) == "function" then
            quantos = quantos + 1
            local original = alvo[nome]
            alvo[nome] = function(...)
                local info = ""
                pcall(function()
                    info = "missao=" .. tostring(mission and mission.id)
                        .. " tipo=" .. tostring(mission and mission.type)
                end)
                print("HOST_EVENTO " .. nome .. " " .. info)
                -- Preserva os retornos: o Mission usa o valor destas chamadas
                -- para decidir se segue para o proximo evento.
                return original(...)
            end
        end
    end
    if quantos > 0 then
        package.__nr_sonda_eventos = true
        print("HOST_EVENTO sonda instalada em " .. quantos .. " funcoes")
    end
end

-- SONDA DA MONTAGEM DA BATALHA (FightModule).
--
-- Medido: depois de battle_result_start o processo morre SEM record_crash,
-- ou seja sem excecao Lua — e um encerramento nativo. O caminho executado e
-- responseBattleStartCallback (Mission.lua:2379-2398) ->
-- _ED._fightModule:initFight -> initBattleField -> parser 182 -> ...
-- Esta sonda imprime a entrada e a SAIDA de cada etapa; a ultima etapa que
-- imprime "antes" sem imprimir "depois" e o ponto exato da morte.
function M.instalarSondaDeBatalhaFight()
    if package.__nr_sonda_fight then return end
    -- O FightModule so e carregado dentro de responseBattleStartCallback
    -- (Mission.lua:2381 app.load + 2384 FightModule:new), no projeto
    -- l_naruto. Entao nao basta sondar a classe: e preciso pegar a
    -- INSTANCIA no momento em que ela e criada. Enganchamos FightModule:new
    -- e, assim que o primeiro objeto nasce, enganchamos os metodos dele e
    -- registramos cada etapa da montagem da batalha. A ultima etapa que
    -- imprime "antes" sem imprimir "depois" e o ponto exato da morte.
    local Classe = _G.FightModule
    if type(Classe) ~= 'table' then return end
    if Classe.__nr_marca_new then
        package.__nr_sonda_fight = true
        return
    end
    local newOriginal = Classe.new
    if type(newOriginal) ~= 'function' then return end
    Classe.__nr_marca_new = true
    Classe.new = function(...)
        local objeto = newOriginal(...)
        print('HOST_FIGHT instancia criada')
        local alvos = { 'initFight', 'initBattleField', 'initFightOrder',
                        'initAttackerBattleInfo' }
        for _, nome in ipairs(alvos) do
            if type(objeto[nome]) == 'function'
                and not objeto['__nr_marca_' .. nome] then
                objeto['__nr_marca_' .. nome] = true
                local original = objeto[nome]
                objeto[nome] = function(self, ...)
                    print('HOST_FIGHT antes ' .. nome)
                    local ret = { original(self, ...) }
                    print('HOST_FIGHT depois ' .. nome)
                    return unpack(ret)
                end
            end
        end
        return objeto
    end
    package.__nr_sonda_fight = true
    print('HOST_FIGHT sonda instalada em FightModule:new')
end

-- SONDA DO FightLoadingCell: descobre por que self.totalNum fica nil.
--
-- Medido: FightLoading.lua:294  self.totalNum = self.totalNum + 1
-- estoura "attempt to perform arithmetic on field 'totalNum' (a nil value)",
-- mesmo o ctor (linha 8) fazendo self.totalNum = 5. Ou seja: ou o ctor nunca
-- rodou nessa instancia, ou o campo foi apagado depois. A sonda registra, no
-- ctor, no init e no onUpdate, a identidade do objeto e o valor do campo.
function M.instalarSondaDoLoading()
    if package.__nr_sonda_loading then return end
    local Classe = _G.FightLoadingCell
    if type(Classe) ~= 'table' then return end
    local ctor = Classe.ctor
    local init = Classe.init
    local update = Classe.onUpdate
    if type(ctor) ~= 'function' or type(update) ~= 'function' then return end
    package.__nr_sonda_loading = true
    Classe.ctor = function(self, ...)
        ctor(self, ...)
        print(string.format('HOST_LOADING ctor obj=%s totalNum=%s',
            tostring(self), tostring(self.totalNum)))
    end
    if type(init) == 'function' then
        Classe.init = function(self, ...)
            local r = init(self, ...)
            print(string.format('HOST_LOADING init obj=%s totalNum=%s type=%s',
                tostring(self), tostring(self.totalNum), tostring(self.currentType)))
            return r
        end
    end
    local avisou = false
    Classe.onUpdate = function(self, dt)
        if self.totalNum == nil and not avisou then
            avisou = true
            print(string.format(
                'HOST_LOADING onUpdate totalNum NIL obj=%s ctorRodou=%s',
                tostring(self), tostring(self.__nr_ctor_rodou)))
        end
        return update(self, dt)
    end
    print('HOST_LOADING sonda instalada')
end

function M.armar()
    if tentarInstalar() then return end
    local sched = cc.Director:getInstance():getScheduler()
    local id
    id = sched:scheduleScriptFunc(function()
        ataques = ataques + 1
        if tentarInstalar() or ataques >= ATAQUES_MAX then
            if not instalado then
                print("HOST_LOCAL_SDK timeout: handlePlatformRequest nunca apareceu")
            end
            sched:unscheduleScriptEntry(id)
        end
    end, 0.5, false)
end

return M
