-- Contrato: os widgets que o acervo procura em battle_UI.csb precisam ser
-- encontrados mesmo quando o layout os guarda com o sufixo de plataforma.
--
-- Medição de origem (server.log, sessão 28, 23:04-23:05):
--   FightUI.lua:1428: attempt to index local 'Label_2p_name' (a nil value)
--     in function 'updateDrawPlayerInfo'
--     in function 'addTigerGateFightUI' (Fight.lua:2945)
--
-- O CSB real tem:
--   Label_1p_name*12          (sem sufixo -> o código achava)
--   Label_2p_name*12_pr1      (com sufixo -> o código NÃO achava)
--
-- Verifica também que a regra não inventa widget: um nome que não existe em
-- nenhuma variante continua devolvendo nil.
local M = {}

function M.run()
    local root = csb.createNode('battle/battle_UI.csb'):getChildByName('root')
    assert(root, 'battle_UI.csb sem root')

    -- Nomes que o acervo procura sem sufixo, e que o layout tem com sufixo.
    -- Cada um no SEU layout (Panel_2 vive em battle_ready.csb, não aqui).
    local devemExistir = {
        'Label_1p_name',      -- controle: existe sem sufixo
        'Label_2p_name',      -- era o nil do crash (:1428)
        'Label_2p_speed_n',   -- mesma família
        'Button_htj_tg',
        'Panel_hetijiguangx',
        'Panel_shenshou',     -- o painel do 神兽 (existe como _pr1)
    }
    local faltam = {}
    for _, nome in ipairs(devemExistir) do
        local w = ccui.Helper:seekWidgetByName(root, nome)
        print('LABEL_CONTRATO ' .. nome .. ' -> ' .. tostring(w ~= nil))
        if w == nil then faltam[#faltam + 1] = nome end
    end
    local ready = csb.createNode('battle/battle_ready.csb'):getChildByName('root')
    local p2 = ccui.Helper:seekWidgetByName(ready, 'Panel_2')
    print('LABEL_CONTRATO Panel_2 (battle_ready.csb) -> ' .. tostring(p2 ~= nil))
    if p2 == nil then faltam[#faltam + 1] = 'Panel_2' end
    assert(#faltam == 0, 'widgets nao encontrados: ' .. table.concat(faltam, ', '))

    -- A regra procura por núcleo; não pode devolver um widget qualquer.
    for _, nome in ipairs({'Label_2p_name_inexistente', 'Panel_nao_existe_xyz'}) do
        local w = ccui.Helper:seekWidgetByName(root, nome)
        print('LABEL_CONTRATO ' .. nome .. ' -> ' .. tostring(w ~= nil))
        assert(w == nil, 'a regra NAO pode inventar widget para ' .. nome)
    end

    -- setString precisa CHEGAR ao widget: é o passo que a janela de diálogo e
    -- a barra de nomes usam. Escreve e relê.
    local lbl = ccui.Helper:seekWidgetByName(root, 'Label_2p_name')
    assert(lbl, 'Label_2p_name continua ausente')
    lbl:setString('Sasuke')
    local ok, lido = pcall(function() return lbl:getString() end)
    print('LABEL_CONTRATO setString chegou=' .. tostring(ok and lido == 'Sasuke')
        .. ' valor=' .. tostring(ok and lido or '?'))
    assert(ok and lido == 'Sasuke', 'setString nao chegou ao widget')

    print('LABEL_CONTRATO_PASSED sufixo _pr1 alcançado, nada inventado, setString chega')
end

return M
