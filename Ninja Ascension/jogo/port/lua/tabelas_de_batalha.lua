-- port/lua/tabelas_de_batalha.lua — CARREGA AS TABELAS DE BATALHA QUE FALTAVAM.
--
-- CAUSA (medida, não suposta):
--   client/loader/LocalDatas.lua:6711 define localData_attack_logic(), que
--   carrega as tabelas de batalha. Mas o corpo é:
--
--       if <projeto red_alert/digital/dragonball/pokemon/onepiece/l_naruto> then
--           -- 台灣: NADA
--       else
--           dms.load("data/ship_mould.txt")          -- :6719
--           dms.load("data/environment_ship.txt")
--           dms.load("data/damage_reward_silver_param.txt")
--           dms.load("data/skill_influence.txt")
--           dms.load("data/skill_mould.txt")
--           dms.load("data/ship_rank_up_param.txt")
--       end
--
--   Ou seja: para __lua_project_l_naruto (o nosso caso) as tabelas NÃO são
--   carregadas ali. Medição no binário (port/lua/sonda_tabelas.lua):
--       ship_mould carregada=false
--       environment_ship carregada=false
--       skill_influence carregada=false
--       skill_mould carregada=false
--   e o AssetsManager.lua:150 chama localData_attack_logic() exatamente uma
--   vez, sem nenhum carregamento compensatório em outro lugar.
--
-- CONSEQUÊNCIA medida (o que trava as habilidades):
--   client/battle/landscape/FightRole.lua:7273-7288 só dispara o fluxo do TAP
--   (update_fight_team_controller_data, que por sua vez chama
--   fight_ui_change_battle_heti_state -> mostra Button_htj_tg) quando
--       shipEffect = dms.string(dms["ship_mould"], mouldId,
--                               ship_mould.screen_attack_effect)
--   existe e é > -1. Com dms["ship_mould"] == nil, shipEffect fica nil, o if
--   nunca entra, o botão TAP nunca aparece e as habilidades ficam bloqueadas.
--
-- CORREÇÃO:
--   carrega os arquivos que o ramo else carregaria, pelos mesmos caminhos do
--   acervo, usando o próprio dms.load (que o port/lua/data_paths.lua remapeia
--   de data/x.txt para data/mould/x.txt quando necessário).
--   Nada é inventado: se o arquivo não existir, a carga não acontece e o
--   resumo diz qual faltou.
--
--   NÃO se força energia, não se pula o tutorial e não se remove bloqueio
--   algum: só se fornece o dado que o portão do próprio acervo já consultava.
local M = {}

local function nota(txt) print("HOST_TABELAS " .. txt) end

-- Os mesmos nomes que o ramo else de localData_attack_logic usa.
local TABELAS = {
    "data/ship_mould.txt",
    "data/environment_ship.txt",
    "data/damage_reward_silver_param.txt",
    "data/skill_influence.txt",
    "data/skill_mould.txt",
    "data/ship_rank_up_param.txt",
}

-- Registra o resultado de cada carga, uma única vez.
local carregadas, ausentes = {}, {}

local function caminhoExiste(caminho, fu)
    if fu:isFileExist(caminho) then return true end
    -- data_paths.lua remapeia data/x.txt -> data/mould/x.txt
    local alternativo = caminho:gsub("^data/", "data/mould/")
    return fu:isFileExist(alternativo)
end

function M.carregar(vezes)
    local fu = cc.FileUtils:getInstance()
    -- Reexecuta só quando o estado mudou: se todas as tabelas já estão em
    -- memória, não há o que fazer. A checagem é feita por tabela, por isso
    -- não se usa um cache de "já rodei" que impediria a recarga após relogin.
    local faltandoAlguma = false
    for _, caminho in ipairs(TABELAS) do
        local chave = caminho:gsub("^.*/", ""):gsub("%.txt$", "")
        if dms[chave] == nil then
            faltandoAlguma = true
            break
        end
    end
    if not faltandoAlguma and vezes ~= 0 then
        return
    end

    for _, caminho in ipairs(TABELAS) do
        local chaveTabela = caminho:gsub("^.*/", ""):gsub("%.txt$", "")
        if dms[chaveTabela] ~= nil then
            carregadas[chaveTabela] = #(dms[chaveTabela] or {})
        elseif caminhoExiste(caminho, fu) then
            local ok, res = pcall(dms.load, caminho)
            if ok and dms[chaveTabela] ~= nil then
                carregadas[chaveTabela] = #dms[chaveTabela]
            else
                ausentes[chaveTabela] = "falha ao carregar " .. caminho
            end
        else
            ausentes[chaveTabela] = "arquivo ausente"
        end
    end

    local lista = {}
    for nome, n in pairs(carregadas) do
        lista[#lista + 1] = nome .. "=" .. tostring(n)
    end
    table.sort(lista)
    nota("carregadas: " .. table.concat(lista, " "))

    local faltando = {}
    for nome, motivo in pairs(ausentes) do
        faltando[#faltando + 1] = nome .. "(" .. motivo .. ")"
    end
    table.sort(faltando)
    if #faltando > 0 then
        nota("sem carga: " .. table.concat(faltando, " "))
    end
end

function M.armar()
    if package.__nr_tabelas_batalha then return end
    package.__nr_tabelas_batalha = true
    -- A carga tem de acontecer antes de qualquer batalha. Embrulha o próprio
    -- localData_attack_logic e os pontos de entrada de batalha do acervo:
    -- assim o dado existe quando FightRole/FightModule/ConfigDB consultarem,
    -- e nada depende de quando o login termina.
    local originais = {}

    local function envolver(nome, globais)
        local original = rawget(_G, nome)
        if type(original) ~= "function" then return end
        originais[nome] = original
        _G[nome] = function(...)
            local r = original(...)
            M.carregar(1)
            return r
        end
    end
    envolver("localData_attack_logic")

    -- Carga imediata também: cobre o caso de o login já ter passado.
    M.carregar(0)

    -- E garante que a carga aconteça de novo se o dms for limpo por um
    -- relogin (AssetsManager refaz o fluxo com fwin:clean).
    local originalLoad = app.load
    if type(originalLoad) == "function" then
        app.load = function(name, ...)
            local r = originalLoad(name, ...)
            if name == "client.loader.LocalDatas"
                or name == "client.battle.report.FightModule" then
                M.carregar(2)
            end
            return r
        end
    end
    return originais
end

return M
