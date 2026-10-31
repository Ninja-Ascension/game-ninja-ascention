-- port/lua/data_paths.lua — CORREÇÃO DE CAMINHO DA PRÉ-CARGA DE DADOS.
--
-- PROBLEMA (medido, não suposto):
--   LocalDatas.lua:6310-6335 monta localData_list de dois jeitos:
--     * projetos red_alert / l_digital / l_pokemon / ... (6311-6316) usam o
--       manifesto res/configs/data/data_path_config.lua, que tem os caminhos
--       CERTOS ("data/mould/equipment_mould.txt");
--     * os DEMAIS (o nosso "t4") caem no else (6334) e usam uma lista FLAT
--       antiga que pede "data/equipment_mould.txt" na RAIZ de data/.
--   Os arquivos de facto moram em data/mould/. O motor chama
--   cc.FileUtils::fullPathForFilename, não acha, imprime
--   "No file found at data/..." e o dms.load grava a tabela VAZIA
--   (local_datas.lua:16-65). O laço de pré-carga (6641-6658) NÃO aborta,
--   então o jogo segue — mas 35 tabelas ficam vazias sem necessidade.
--
-- O QUE ESTE ADAPTADOR FAZ:
--   embrulha dms.load; quando o caminho pedido não existe mas existe em
--   data/mould/, carrega do caminho certo e mantém a CHAVE original
--   (dms["equipment_mould"]), que é como o resto do código consulta.
--   Nada do acervo é editado; só o caminho é corrigido.
--
-- O que NÃO é tratado aqui: os 13 arquivos que não existem nos recursos em
--   lugar nenhum (eram baixados como patch no cliente Android). Esses
--   continuam como tabela vazia — inventar conteúdo é pior.
local M = {}

local function nota(txt)
    print("HOST_DATA_PATHS " .. txt)
end

local corrigidos = 0
local pedidos_ausentes = {}

-- Só a raiz de data/ é remapeada: data/x.txt -> data/mould/x.txt. As
-- subpastas de domínio (data/configs/, data/errors/, ...) têm layout próprio
-- e não ganham um "mould/" inventado.
local function varianteEmMould(caminho)
    local dir, nome = caminho:match("^(.*)[/\\]([^/\\]+)$")
    if dir ~= "data" then
        return nil
    end
    return "data/mould/" .. nome
end

-- A primeira pergunta é feita ao próprio motor; usei o fullPathForFilename
-- porque é ele que o dms.load acaba chamando. Como ele IMPRIME o aviso
-- "No file found" só de ser consultado, a existência é testada antes com
-- FileUtils::isFileExist, que não escreve nada no console.

local function existe(caminho)
    local ok, r = pcall(function()
        return cc.FileUtils:getInstance():isFileExist(caminho)
    end)
    return ok and r == true
end

function M.armar()
    if package.__nr_data_paths then return true end
    if type(dms) ~= "table" or type(dms.load) ~= "function" then
        return false
    end
    package.__nr_data_paths = true
    local original = dms.load

    -- Arquivos que NÃO existem nos recursos em lugar nenhum (confirmado por
    -- tools/auditar_dados_ausentes.py: nem em data/, nem em data/mould/).
    -- Foram baixados como patch pelo cliente Android, então a tabela fica
    -- vazia — é o que já acontecia. Não se inventa conteúdo: só se evita
    -- repetir o aviso do motor a cada consulta.
    local AUSENTES = {
        ["data/daily_task_mould.txt"] = true,
        ["data/equipment_fashion_level.txt"] = true,
        ["data/equipment_fashion_pokedex.txt"] = true,
        ["data/equipment_fashion_skill.txt"] = true,
        ["data/equipment_fashion_talent.txt"] = true,
        ["data/equipment_level_requirement.txt"] = true,
        ["data/mould/pokemon_high.txt"] = true,
        ["data/mould/unparalleled_reward_param.txt"] = true,
        ["data/configs/experiment_config.txt"] = true,
        ["data/partner_bounty_library.txt"] = true,
        ["data/pirates_config.txt"] = true,
        ["data/ship_force_mould.txt"] = true,
        ["data/strategy_param.txt"] = true,
        ["data/union_npc.txt"] = true,
        ["data/union_pve_scene.txt"] = true,
    }

    dms.load = function(caminho)
        if type(caminho) == "string" and not existe(caminho) then
            if AUSENTES[caminho] then
                -- registra uma vez e devolve a tabela vazia em cache, como o
                -- próprio dms.load faria depois de carregar o arquivo vazio.
                if pedidos_ausentes[caminho] == nil then
                    pedidos_ausentes[caminho] = true
                end
                local chave = caminho:gsub("^.*[/\\]", ""):gsub("%.[^.]*$", "")
                if dms[chave] == nil then
                    dms[chave] = {}
                end
                return dms[chave]
            end
            -- o caminho pedido não existe: o mesmo arquivo está em data/mould/?
            local alternativo = varianteEmMould(caminho)
            if alternativo ~= nil and existe(alternativo) then
                -- dms.load grava pela chave SEM pasta; é essa que o código
                -- consulta (dms["equipment_mould"]). Carregando o caminho
                -- alternativo a chave sai igual, então nada precisa ser
                -- renomeado depois.
                corrigidos = corrigidos + 1
                return original(alternativo)
            end
        end
        return original(caminho)
    end
    nota("ativo (data/*.txt -> data/mould/*.txt quando o arquivo existe lá)")
    return true
end

-- Resumo impresso uma vez, depois da pré-carga, para o console não virar
-- uma parede de avisos do motor.
function M.resumir()
    local n = 0
    for _ in pairs(pedidos_ausentes) do n = n + 1 end
    nota(string.format(
        "resumo: %d tabela(s) carregada(s) do caminho correto (data/mould/)", corrigidos))
    if n > 0 then
        nota(string.format(
            "%d arquivo(s) realmente ausentes dos recursos (patch do cliente "
            .. "Android; carregam vazio)", n))
    end
end

return M
