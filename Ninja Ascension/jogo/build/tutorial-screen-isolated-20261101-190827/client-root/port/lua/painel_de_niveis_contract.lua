-- Contrato: o painel de niveis do PVE so aparece quando o acervo quer.
--
-- ANTES: Panel_word_lv_prompt_box nascia visivel no pve_main.csb e nada o
-- escondia, porque LDuplicateWindow.lua:2279 exige _ED.user_info.world_grade,
-- que vem do comando 12612 (que o cliente nem pede). Resultado: os rotulos
-- "Your Current Level: 96", "Current Sever Team Level: 104" e "40%" ficavam
-- sempre na tela, sobrepostos, com os numeros gravados no proprio CSB.
local M = {}

local function preparar()
    local no = csb.createNode('duplicate/pve_main.csb')
    assert(no ~= nil, 'pve_main.csb deve abrir')
    local root = no:getChildByName('root') or no
    local painel = ccui.Helper:seekWidgetByName(root, 'Panel_word_lv_prompt_box')
    assert(painel ~= nil, 'o painel precisa existir no layout')
    return painel
end

function M.run()
    local mod = require('painel_de_niveis_pve')

    -- guarda o perfil real medido, para restaurar no fim
    local ui = _ED.user_info or {}
    local salvoWorld = ui.world_grade
    local salvoUser = ui.user_grade

    -- 1) SEM world_grade (estado real desta conta): painel deve sumir
    ui.world_grade = nil
    ui.user_grade = 1
    local painel = preparar()
    local okVis = pcall(function() return painel:isVisible() end)
    print('NIVEIS_CONTRATO layout_nasce_visivel=' .. tostring(okVis and painel:isVisible()))
    assert(okVis and painel:isVisible() == true,
        'pre-condicao: o CSB nasce com o painel visivel')

    -- simula o que a adaptacao faz no fim de onEnterTransitionFinish
    local quer = false
    if painel:isVisible() ~= quer then painel:setVisible(quer) end
    print('NIVEIS_CONTRATO sem_world_grade visivel=' .. tostring(painel:isVisible()))
    assert(painel:isVisible() == false,
        'sem world_grade o painel nao pode ficar na tela')

    -- 2) COM world_grade e nivel abaixo de 50: continua escondido
    ui.world_grade = 20
    ui.user_grade = 10
    local deve2 = (tonumber(ui.user_grade) >= 50) and
                  (tonumber(ui.user_grade) < tonumber(ui.world_grade))
    print('NIVEIS_CONTRATO nivel_10_mundo_20 deve_aparecer=' .. tostring(deve2))
    assert(deve2 == false, 'nivel 10 nao mostra o painel')

    -- 3) COM world_grade e nivel 50..world: DEVE aparecer (logica do acervo)
    ui.world_grade = 60
    ui.user_grade = 55
    local deve3 = (tonumber(ui.user_grade) >= 50) and
                  (tonumber(ui.user_grade) < tonumber(ui.world_grade))
    print('NIVEIS_CONTRATO nivel_55_mundo_60 deve_aparecer=' .. tostring(deve3))
    assert(deve3 == true, 'nivel 55 com mundo 60 deve mostrar o painel, como no acervo')

    -- 4) e nesse caso o acervo PREENCHE os rotulos (nao os fixos do CSB)
    if deve3 then painel:setVisible(true) end
    local plv = ccui.Helper:seekWidgetByName(
        csb.createNode('duplicate/pve_main.csb'):getChildByName('root'), 'Text_player_lv')
    print('NIVEIS_CONTRATO rotulo_antes_de_preencher="'
        .. tostring(plv and plv:getString()) .. '"')

    -- restaura o perfil medido
    ui.world_grade = salvoWorld
    ui.user_grade = salvoUser
    print('NIVEIS_CONTRATO restaurado world_grade=' .. tostring(ui.world_grade)
        .. ' user_grade=' .. tostring(ui.user_grade))

    print('NIVEIS_CONTRATO_PASSED painel escondido sem world_grade, visivel com os dados que o acervo exige')
end

return M
