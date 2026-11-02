-- port/lua/instalar_adaptacoes.lua — LIGA AS ADAPTAÇÕES QUE ESTAVAM ÓRFÃS.
--
-- CAUSA COMPROVADA (sessão 43, build/probe-writable/intro-menu.log 02:58:56):
--
--   OPEN FAILED boot_map.lua:440: invalid arguments in function
--              'lua_ax_ui_Helper_seekWidgetByName'
--   stack: pve_entry_ready.lua:30 seekWidgetByName
--          Menu.lua:182 excute
--
--   e, na tela do PVE:
--   LDuplicateWindow.lua:110  LDuplicateWindow._pageViews:setVisible(true)
--   -> _ED._pageViews era nil, então o resto da abertura não rodava e o
--   centro da tela ficava vazio (sem mapas, sem NPCs, sem botões).
--
--   POR QUE: os módulos abaixo existiam no disco, com as correções que o
--   jogador pediu para preservar, mas NENHUM estava sendo carregado pelo
--   boot_map.lua. Todo o trabalho estava inerte:
--     intro_menu_transition, texture_async_compat, menu_energy_compat,
--     pve_entry_ready, window_update_lifetime, combat_visual_end,
--     tutorial_tap_wait.
--
--   A prova de que estavam inertes: LDuplicateWindow.lua:2386 pede
--   `PageView_pve_map`, e o pve_main.csb só tem `PageView_pve_map_pr2`.
--   O alias `_pr2` mora em pve_entry_ready.lua e nunca era instalado, então
--   _pageViews ficava nil e :2387 (`removeAllPages`) já quebrava antes de
--   :110 — batendo exatamente com o log.
--
-- O QUE ESTE ARQUIVO FAZ:
--   aplica cada adaptação AGORA, se a classe já existir; senão reagenda para
--   o instante em que app.load carregar aquela classe. Nada é reimplementado
--   aqui: cada módulo continua sendo a fonte única da sua correção, e todos
--   têm guarda interna (__nr_*) contra instalação dupla.
local M = {}

local function nota(t) print('INSTALAR ' .. t) end

-- Uma adaptação = { nome, função que aplica, classes que precisam existir }
-- A função recebe as classes resolvidas (algumas são opcionais).
local ADAPTACOES = {
    {
        nome = 'texture_async_compat',
        precisa = nil,   -- patcheia cc/cacheTextures: não depende de classe
        aplica = function()
            local ok, mod = pcall(require, 'texture_async_compat')
            if not ok then return false, tostring(mod) end
            return pcall(mod.armar)
        end,
    },
    {
        nome = 'pve_entry_ready',
        -- aliases PageView_pve_map -> _pr2 e a espera da página PVE.
        -- Só há o que envolver depois que a classe carregar; até lá precisa
        -- voltar a ser tentado (ver AO_CARREGAR.LDuplicateWindow).
        precisa = { 'LDuplicateWindow' },
        aplica = function()
            local ok, mod = pcall(require, 'pve_entry_ready')
            if not ok then return false, tostring(mod) end
            return pcall(mod.install)
        end,
    },
    {
        nome = 'window_update_lifetime',
        precisa = nil,
        aplica = function()
            local ok, mod = pcall(require, 'window_update_lifetime')
            if not ok then return false, tostring(mod) end
            return pcall(mod.install)
        end,
    },
    {
        nome = 'intro_menu_transition',
        precisa = { 'MenuClass' },
        aplica = function()
            local ok, mod = pcall(require, 'intro_menu_transition')
            if not ok then return false, tostring(mod) end
            return pcall(mod.install)
        end,
    },
    {
        nome = 'menu_energy_compat',
        precisa = { 'Menu' },
        aplica = function()
            local ok, mod = pcall(require, 'menu_energy_compat')
            if not ok then return false, tostring(mod) end
            return pcall(mod.install, rawget(_G, 'Menu'))
        end,
    },
}

-- Mapa classe-do-acervo -> módulos que querem ser avisados quando ela carregar.
local AO_CARREGAR = {
    Menu = { 'menu_energy_compat' },
    MenuClass = { 'intro_menu_transition' },
    -- pve_entry_ready envolve LDuplicateWindow.onEnterTransitionFinish, mas
    -- no boot a classe ainda não existe: sem esta linha ele era aplicado com
    -- `class == nil`, ligava a flag de "instalado" e NUNCA mais era tentado.
    -- Medido em jogo: o centro do PVE ficava vazio (só as abas apareciam).
    LDuplicateWindow = { 'pve_entry_ready' },
}

local feito = {}

local function existeClasse(nome)
    local v = rawget(_G, nome)
    return type(v) == 'table'
end

local function tentar(ad)
    if feito[ad.nome] then return true end
    if ad.precisa then
        for _, c in ipairs(ad.precisa) do
            if not existeClasse(c) then return false end
        end
    end
    local ok, res = ad.aplica()
    -- `aplica` devolve o pcall: (ok_da_chamada, retorno_da_função). Uma
    -- adaptação pode rodar sem estourar e AINDA dizer que não se aplicou
    -- (pve_entry_ready devolve false enquanto LDuplicateWindow não carregar).
    -- Nesse caso NÃO pode ser marcada como feita, senão nunca é tentada de
    -- novo — foi exatamente esse buraco que deixou o centro do PVE vazio.
    if ok and res ~= false then
        feito[ad.nome] = true
        nota(ad.nome .. ' instalado')
        return true
    end
    if ok then
        nota(ad.nome .. ' aguarda a classe carregar')
        return false
    end
    nota(ad.nome .. ' ainda nao aplicavel: ' .. tostring(res))
    return false
end

local function instalarGanchoDeCarga()
    if package.__nr_instalar_gancho then return end
    package.__nr_instalar_gancho = true
    local load = app.load
    if type(load) ~= 'function' then return end
    app.load = function(nome, ...)
        local r = load(nome, ...)
        -- nome é "client.home.Menu"; a classe é o último segmento
        local curto = tostring(nome):match('([%w_]+)$')
        local alvos = curto and AO_CARREGAR[curto]
        if alvos then
            for _, alvo in ipairs(alvos) do
                for _, ad in ipairs(ADAPTACOES) do
                    if ad.nome == alvo then tentar(ad) end
                end
            end
        end
        return r
    end
end

function M.armar()
    instalarGanchoDeCarga()
    local n = 0
    for _, ad in ipairs(ADAPTACOES) do
        if tentar(ad) then n = n + 1 end
    end
    nota(('aplicadas agora: %d de %d (as demais esperam a classe carregar)')
        :format(n, #ADAPTACOES))
    return n
end

-- Para testes: lista o que está instalado.
function M.estado()
    local t = {}
    for _, ad in ipairs(ADAPTACOES) do
        t[ad.nome] = feito[ad.nome] == true
    end
    return t
end

return M
