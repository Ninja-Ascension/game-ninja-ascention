-- port/lua/catalogo_ninjas.lua
-- Restaura a listagem COMPLETA do catalogo NINJA (HeroListView).
--
-- Causa do problema
-- -----------------
-- HeroListView:getUnlockedShip() (HeroListView.lua:1155-1216) monta as cartas
-- NAO possuidas assim:
--
--     for cada prop_mould com props_type == 1 do
--         se use_of_ship nao esta em _ED.user_ship entao
--             se getPropAllCountByMouldId(id) >= split_or_merge_count entao
--                 table.insert(beSynthesized, id)   -- pode sintetizar
--             senao
--                 table.insert(tSortedHeroes, id)   -- << NAO POSSUIDO
--             fim
--         fim
--     fim
--
-- O ramo do "nao possuido" so roda quando a conta tem ALGUM fragmento
-- (count >= split), mas menor que o necessario. Com o inventario vazio,
-- getPropAllCountByMouldId devolve 0, 0 >= split e falso, e o ramo alternativo
-- e o `else` do `if isAdd == false`... na pratica, com 0 cartas a lista de nao
-- possuidos sai vazia e a tela mostra so o que a conta possui — que numa conta
-- nova e quase nada. Era isso que "quase desapareceu".
--
-- Correcao
-- --------
-- Reimplementa getUnlockedShip aplicando os criterios ORIGINAIS de
-- disponibilidade, sem exigir fragmento para listar:
--   * prop_mould.props_type == 1            (e uma carta de personagem)
--   * ship_mould existe para use_of_ship    (personagem real do acervo)
--   * ship_mould.captain_type == 1          (personagem; descarta material,
--                                            NPC e variante tecnica)
--   * nome resolvivel (ship_mould.col72 -> ship_evo_mould -> word_mould),
--     senao a carta mostraria nome/retrato vazios
--   * nao estar na conta (os possuidos saem daqui e vem de _ED.user_ship)
-- Os contadores de fragmento continuam sendo lidos do inventario real, entao
-- uma carta com 3/10 fragmentos mostra "3/10" e o botao de sintese conforme
-- os requisitos originais.
--
-- Nada e concedido: nao grava em _ED.user_ship nem em _ED.user_prop. So
-- amplia a LISTA. A ordem de renderizacao da tela (possuidos, separador
-- "ainda nao obtidos", nao possuidos) ja existe em HeroListView:createListView
-- (linhas 1881-1958) e passa a ter conteudo.

local M = {}

local function log(msg)
    print('[CATALOGO_NINJAS] ' .. tostring(msg))
end

-- Colunas 1-based, conforme LocalDatas.lua:
--   prop_mould: id=1, split_or_merge_count=10, use_of_ship=40, props_type=43
--   ship_mould: id=1, captain_type=4, evolution_ids=72
--   ship_evo_mould: id=1, word_id=2
local PROP_SPLIT   = 10
local PROP_USE     = 40
local PROP_TYPE    = 43
local SHIP_CAPTAIN = 4
local SHIP_EVO     = 72

local function atoi(t, n)
    local ok, v = pcall(dms.atoi, t, n)
    if ok and v ~= nil then return tonumber(v) end
    return nil
end

--- Existe nome para este personagem? Evita carta com nome/retrato em branco.
--- Mesma resolucao usada no servidor: col72 -> ship_evo_mould -> word_mould.
local function tem_nome(shipMouldId)
    local evo = dms.string(dms["ship_mould"], shipMouldId, SHIP_EVO)
    if not evo or evo == '' then return false end
    local primeiro = string.match(evo, '^([^,]*)')
    if not primeiro or primeiro == '' then return false end
    local evoRow = dms.element(dms["ship_evo_mould"], tonumber(primeiro))
    if not evoRow then return false end
    local wid = atoi(evoRow, 2)
    if wid == nil then return false end
    local palavra = dms.element(dms["word_mould"], wid)
    return palavra ~= nil
end

--- Personagem elegivel para aparecer como carta nao possuida.
local function elegivel(useOfShip)
    local linha = dms.element(dms["ship_mould"], useOfShip)
    if linha == nil then return false end
    -- captain_type 1 = personagem jogavel. 0 = material, 2 = NPC/inimigo.
    if atoi(linha, SHIP_CAPTAIN) ~= 1 then return false end
    return tem_nome(useOfShip)
end

--- Reconstroi a lista de cartas nao possuidas a partir do catalogo original.
--- Mantem os dois conjuntos do original:
---   tSortedHeroes -> nao possuidos (mostrados abaixo do separador)
---   beSynthesized -> ja tem fragmentos suficientes para sintetizar
local function getUnlockedShipOriginal(self)
    local obtainShip, jaTem = {}, {}
    for _, ship in pairs(_ED.user_ship) do
        local tmpl = ship and ship.ship_template_id
        if tmpl ~= nil and not jaTem[tostring(tmpl)] then
            jaTem[tostring(tmpl)] = true
            obtainShip[#obtainShip + 1] = tonumber(tmpl)
        end
    end

    local tSortedHeroes, beSynthesized = {}, {}
    for _, shipMould in pairs(dms["prop_mould"]) do
        local propsType = atoi(shipMould, PROP_TYPE)
        if propsType == 1 then
            local useOfShip = atoi(shipMould, PROP_USE)
            local propId = atoi(shipMould, 1)
            local possuido = false
            for _, tmpl in pairs(obtainShip) do
                if useOfShip ~= nil and useOfShip == tmpl then
                    possuido = true
                    break
                end
            end
            if not possuido and useOfShip ~= nil
               and elegivel(useOfShip) and propId ~= nil then
                -- getPropAllCountByMouldId le o inventario REAL da conta.
                local ok, count = pcall(getPropAllCountByMouldId, propId)
                local split = atoi(shipMould, PROP_SPLIT) or 0
                if not ok then count = 0 end
                count = tonumber(count) or 0
                if count >= split and split > 0 then
                    beSynthesized[#beSynthesized + 1] = propId
                else
                    tSortedHeroes[#tSortedHeroes + 1] = propId
                end
            end
        end
    end

    -- Ordem estavel: por id da carta. A tela resorta por poder/qualidade.
    table.sort(tSortedHeroes)
    table.sort(beSynthesized)
    return tSortedHeroes, beSynthesized
end

function M.instalar()
    local app = assert(rawget(_G,'app'),'Framework app not initialized')
    local ok, HeroListView = pcall(function()
        app.load('client.packs.hero.HeroListView')
        return HeroListView
    end)
    if not ok or HeroListView == nil then
        log('HeroListView indisponivel, patch nao aplicado')
        return false
    end
    if HeroListView.__catalogo_ninjas then
        return true
    end
    HeroListView.getUnlockedShip = getUnlockedShipOriginal
    HeroListView.__catalogo_ninjas = true
    log('getUnlockedShip substituido: catalogo completo, sem exigir fragmento')
    return true
end

return M
