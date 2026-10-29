-- Contrato: a janela de diálogo mostra UM retrato por vez, do lado do falante.
--
-- Causa medida: RoleDialogue.lua:821 mostra o painel do lado do falante
-- (Panel_big_head_<dir+1>) e NUNCA esconde o do outro lado; a animação de
-- saída do retrato está comentada em RoleDialogueLeftRoleWidget.lua:87, então
-- o retrato antigo não é removido. Com left_head == right_head (como em
-- mission3.txt) isso desenha dois rostos iguais.
--
-- A correção é port/lua/dialogo_retratos.lua; aqui se prova que ela mantém
-- exatamente um painel visível, sempre o do falante, e que ela não inventa
-- comportamento quando o layout não tem os painéis.
local M = {}

function M.run()
    local node = csb.createNode('Chat/dialog.csb')
    assert(node, 'Chat/dialog.csb não carregou')
    local root = node:getChildByName('root')
    local parent = root and ccui.Helper:seekWidgetByName(root, 'Panel_20')
    assert(parent, 'Panel_20 ausente')

    local p1 = ccui.Helper:seekWidgetByName(parent, 'Panel_big_head_1')
    local p2 = ccui.Helper:seekWidgetByName(parent, 'Panel_big_head_2')
    assert(p1 and p2, 'painéis de retrato ausentes')

    local retratos = require('dialogo_retratos')

    -- Sequência real de _dir em mission3.txt (eventos 30202..30305).
    local sequencia = {1, 1, 0, 1, 0, 0, 1, 1}
    for _, dir in ipairs(sequencia) do
        local alvo = (dir == 1) and p2 or p1
        if alvo:getChildByTag(501) == nil then
            local w = ccui.Widget:create()
            w:setTag(501)
            alvo:addChild(w)
        end
        local ok = retratos.aplicarLado(root, dir)
        assert(ok, 'aplicarLado falhou')
        local visiveis = (p1:isVisible() and 1 or 0) + (p2:isVisible() and 1 or 0)
        assert(visiveis == 1, 'devem ficar exatamente 1 painel visível, veio '
            .. visiveis .. ' (dir=' .. dir .. ')')
        if dir == 1 then
            assert(p2:isVisible(), 'dir=1 deve mostrar o painel direito')
        else
            assert(p1:isVisible(), 'dir=0 deve mostrar o painel esquerdo')
        end
    end
    print('DIALOGO_RETRATO 8 falas reais: um painel visível por vez, no lado do falante')

    -- Não inventa: sem os painéis, devolve false em vez de estourar.
    local vazio = ccui.Layout:create()
    local okVazio = retratos.aplicarLado(vazio, 0)
    print('DIALOGO_RETRATO layout sem painéis -> ' .. tostring(okVazio))
    assert(okVazio == false, 'sem os painéis deve devolver false')

    print('DIALOGO_RETRATO_PASSED um retrato por vez, lado do falante, sem inventar')
end

return M
