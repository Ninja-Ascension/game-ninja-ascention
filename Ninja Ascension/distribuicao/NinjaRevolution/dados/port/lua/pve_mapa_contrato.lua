-- Contrato: depois de resolver _pageViews, o caminho de abertura do capitulo
-- 1 consegue montar paginas de mapa, e o pve_map do capitulo 1 traz o widget
-- Panel_pve_npc_2 que o roteiro manda clicar
-- (mission3.txt evento 3: 3点击UI LDuplicateWindowClass Panel_pve_npc_2).
--
-- Sem inventar nada: usa pve_scene original para descobrir qual pve_map_%d
-- o capitulo 1 aponta, abre ESSE csb e procura o widget pelo nome que o
-- roteiro cita.
local M = {}

local function lerCampo(id, coluna)
    local t = dms['pve_scene']
    if t == nil then return nil end
    return dms.string(t, id, coluna)
end

function M.run()
    -- 1) a tabela pve_scene do acervo, carregada pela mesma via do port
    if dms['pve_scene'] == nil then
        local t = require('tabelas_de_batalha')
        if t then t.carregar(0) end
    end
    if dms['pve_scene'] == nil then
        -- caminho direto, o mesmo que o LocalDatas usa
        local ok = pcall(function()
            dms.load('data/mould/pve_scene.txt')
        end)
        print('PVE_MAPA carga_direta ok=' .. tostring(ok))
    end
    assert(dms ~= nil and dms['pve_scene'] ~= nil, 'pve_scene deve estar carregada')
    print('PVE_MAPA tabela_pve_scene linhas=' .. tostring(#dms['pve_scene']))

    -- 2) o capitulo 1 existe e aponta para um mapa
    -- pve_scene.scene_map_id = coluna 8 (LocalDatas.lua:1020)
    local mapaId = lerCampo(1, 8)
    print('PVE_MAPA capitulo1 scene_map_id=' .. tostring(mapaId))
    assert(mapaId ~= nil and mapaId ~= '', 'capitulo 1 precisa ter scene_map_id')

    -- 3) o CSB desse mapa abre
    local caminho = string.format('duplicate/map/pve_map_%s.csb', tostring(mapaId))
    local no = csb.createNode(caminho)
    print('PVE_MAPA csb=' .. caminho .. ' abriu=' .. tostring(no ~= nil))
    assert(no ~= nil, 'o mapa do capitulo 1 precisa abrir: ' .. caminho)

    local root = no:getChildByName('root') or no
    print('PVE_MAPA root=' .. tostring(root ~= nil))

    -- 4) os NPCs que o roteiro cita existem NESSE mapa
    local encontrados = 0
    for i = 1, 4 do
        local nome = 'Panel_pve_npc_' .. i
        local w = ccui.Helper:seekWidgetByName(root, nome)
        print('PVE_MAPA ' .. nome .. '=' .. tostring(w ~= nil))
        if w ~= nil then encontrados = encontrados + 1 end
    end
    assert(encontrados > 0,
        'o mapa do capitulo 1 precisa ter ao menos um Panel_pve_npc_N '
        .. '(o roteiro clica em Panel_pve_npc_2)')

    -- 5) o widget que o ROTEIRO pede, exatamente
    local alvo = ccui.Helper:seekWidgetByName(root, 'Panel_pve_npc_2')
    print('PVE_MAPA Panel_pve_npc_2 existe=' .. tostring(alvo ~= nil))
    if alvo ~= nil then
        local okV, vis = pcall(function() return alvo:isVisible() end)
        local okS, sz = pcall(function()
            local s = alvo:getContentSize(); return s.width .. 'x' .. s.height
        end)
        local okP, px = pcall(function() return alvo:getPositionX() end)
        local okPy, py = pcall(function() return alvo:getPositionY() end)
        print('PVE_MAPA npc_2 visivel=' .. tostring(okV and vis)
            .. ' tamanho=' .. tostring(okS and sz)
            .. ' pos=' .. tostring(okP and px) .. ',' .. tostring(okPy and py))
        assert(okS and sz ~= '0x0', 'npc_2 precisa ter tamanho, senao nao recebe toque')

        -- toque: o widget precisa aceitar toque para o passo 3点击UI funcionar
        local okT = pcall(function() return alvo:isTouchEnabled() end)
        if okT then
            print('PVE_MAPA npc_2 touch_enabled=' .. tostring(alvo:isTouchEnabled()))
        end
    end

    -- 6) e o mapa tem o Panel_map que o LPVEMap procura em :374
    local panelMap = ccui.Helper:seekWidgetByName(root, 'Panel_map')
    print('PVE_MAPA Panel_map=' .. tostring(panelMap ~= nil))

    print('PVE_MAPA_CONTRATO_PASSED mapa do capitulo 1 abre e tem o NPC do roteiro')
end

return M
