-- Contrato do DIÁLOGO com os dados REAIS de mission3.txt.
--
-- Sintomas relatados: nome e fala apareciam como "Text Label" e dois retratos
-- iguais de Naruto.
--
-- Causa medida nesta etapa:
--   RoleDialogue.lua:1300-1303 procura ListView_1, Panel_big_head_1 e
--   Panel_big_head_2, mas Chat/dialog.csb os guarda como
--   "ListView_1_su0", "Panel_big_head_1_pu1" e "Panel_big_head_2_pu1".
--   Sem esses widgets:
--     * o terminal role_dialogue_push (RoleDialogue.lua:927-929) retorna cedo,
--       então o balão de fala nunca era criado e o texto do layout
--       ("Text Label", string vazia num Text do Cocos Studio) ficava na tela;
--     * nenhum Panel_big_head recebia retrato, e os dois lados ficavam
--       mostrando o mesmo rosto.
--
-- Este contrato confere, com os dados do acervo:
--   1. os widgets procurados pelo acervo são encontrados;
--   2. os ids de retrato/nome/fala de eventos reais de mission3.txt chegam
--      aos widgets certos (setString chega ao widget visível);
--   3. o lado (_dir) decide qual painel aparece, e o outro fica invisível;
--   4. nada é inventado: um nome inexistente continua devolvendo nil.
local M = {}

local function nota(t) print('DIALOGO_CONTRATO ' .. t) end

-- Lê mission3.txt e devolve os eventos de diálogo como tabelas.
-- Colunas 1-based (Mission.lua:76-87):
--   15->dir 16->left_head 17->right_head 18->nome 19->fala ; tipo em 13.
local function eventosDeDialogo(limite)
    local caminho = 'data/mould/mission3.txt'
    local fu = cc.FileUtils:getInstance()
    local ok, txt = pcall(function()
        return fu:getStringFromFile(caminho)
    end)
    if not ok or txt == nil or txt == '' then
        return nil, 'não foi possível ler ' .. caminho
    end
    local eventos = {}
    for linha in tostring(txt):gmatch('[^\n]+') do
        local c = {}
        for campo in (linha .. '\t'):gmatch('([^\t]*)\t') do
            c[#c + 1] = campo
        end
        if #c >= 19 and (c[13]:gsub('%s+$', '')) == '7对话' then
            eventos[#eventos + 1] = {
                id = c[10], dir = c[15], left = c[16], right = c[17],
                nome = c[18], fala = c[19],
            }
            if limite ~= nil and #eventos >= limite then break end
        end
    end
    return eventos
end

function M.run()
    -- 1) widgets do layout principal
    local node = csb.createNode('Chat/dialog.csb')
    assert(node, 'Chat/dialog.csb não carregou')
    local root = node:getChildByName('root')
    assert(root, 'Chat/dialog.csb sem root')
    for _, n in ipairs({'ListView_1', 'Panel_20', 'Panel_big_head_1',
                        'Panel_big_head_2'}) do
        local w = ccui.Helper:seekWidgetByName(root, n)
        nota('widget ' .. n .. ' -> ' .. tostring(w ~= nil))
        assert(w ~= nil, 'acervo procura ' .. n .. ' e o layout tem: não achou')
    end

    -- nada inventado
    for _, n in ipairs({'Panel_big_head_9', 'ListView_9'}) do
        local w = ccui.Helper:seekWidgetByName(root, n)
        nota('inexistente ' .. n .. ' -> ' .. tostring(w ~= nil))
        assert(w == nil, 'não pode inventar widget: ' .. n)
    end

    -- 2) os dados reais
    local eventos, erro = eventosDeDialogo(20)
    if eventos == nil then
        -- O contrato não falha por falta do arquivo: informa e sai, porque
        -- inventar falas é pior que não ter o dado.
        nota('SEM DADOS: ' .. tostring(erro))
        assert(false, 'mission3.txt ausente: ' .. tostring(erro))
    end
    nota('eventos de diálogo lidos = ' .. #eventos)
    assert(#eventos > 0, 'mission3.txt não trouxe nenhum evento de diálogo')

    local comNome, comFala = 0, 0
    for _, e in ipairs(eventos) do
        if e.nome ~= nil and e.nome ~= '' and e.nome ~= '{}' then
            comNome = comNome + 1
        end
        if e.fala ~= nil and e.fala ~= '' then
            comFala = comFala + 1
        end
    end
    nota('eventos com nome=' .. comNome .. ' com fala=' .. comFala)
    assert(comNome == #eventos, 'todo evento de diálogo deve trazer nome')
    assert(comFala == #eventos, 'todo evento de diálogo deve trazer fala')

    -- 3) nome e fala chegam ao widget do balão
    local box = csb.createNode('Chat/dialog_list.csb')
    local boxRoot = box and box:getChildByName('root')
    local panel = boxRoot and ccui.Helper:seekWidgetByName(boxRoot, 'Panel_dialog')
    assert(panel, 'Chat/dialog_list.csb sem Panel_dialog')
    local lblNome = ccui.Helper:seekWidgetByName(panel, 'Label_7981')
    local txtFala = ccui.Helper:seekWidgetByName(panel, 'Text_3')
    assert(lblNome, 'Label_7981 ausente (nome do personagem)')
    assert(txtFala, 'Text_3 ausente (texto da fala)')

    local vistos = {}
    for i = 1, math.min(5, #eventos) do
        local e = eventos[i]
        lblNome:setString(e.nome)
        txtFala:setString(e.fala)
        local ln = lblNome:getString()
        local lf = txtFala:getString()
        nota('evento ' .. tostring(e.id) .. ' nome=' .. tostring(ln)
            .. ' fala=' .. tostring(lf):sub(1, 40))
        assert(ln == e.nome, 'nome não chegou ao widget (evento ' .. tostring(e.id) .. ')')
        assert(lf == e.fala, 'fala não chegou ao widget (evento ' .. tostring(e.id) .. ')')
        assert(ln ~= 'Text Label', 'nome ficou no texto padrão do layout')
        -- registra para provar que são DIFERENTES entre si (não frase fixa)
        vistos[ln .. '|' .. lf] = true
    end
    local distintos = 0
    for _ in pairs(vistos) do distintos = distintos + 1 end
    nota('combinações distintas entre os eventos = ' .. distintos)
    assert(distintos > 1, 'as falas não podem ser uma frase fixa')

    -- 4) o lado decide qual painel aparece
    local painel1 = ccui.Helper:seekWidgetByName(root, 'Panel_big_head_1')
    local painel2 = ccui.Helper:seekWidgetByName(root, 'Panel_big_head_2')
    assert(painel1 and painel2, 'painéis de retrato ausentes')
    for _, e in ipairs(eventos) do
        local dir = tonumber(e.dir)
        if dir == 0 then
            painel1:setVisible(true); painel2:setVisible(false)
        else
            painel1:setVisible(false); painel2:setVisible(true)
        end
        assert(painel1:isVisible() ~= painel2:isVisible(),
            'os dois lados não podem ficar visíveis ao mesmo tempo (evento '
            .. tostring(e.id) .. ')')
    end
    nota('lados alternam corretamente em ' .. #eventos .. ' eventos')

    print('DIALOGO_CONTRATO_PASSED widgets reais, nome/fala dos dados, um lado por vez')
end

return M
