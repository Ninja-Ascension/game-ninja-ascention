-- Contrato: seekWidgetByName nao pode estourar com nome invalido.
--
-- CAUSA MEDIDA (sessao 43, intro-menu.log 02:58:56):
--   Menu.lua:181  if params._datas.animation_name ~= nil
--                    or params._datas.animation_name ~= "" then
--   Menu.lua:182  terminal.animation_panel = ccui.Helper:seekWidgetByName(
--                     instance.roots[1], params._datas.animation_name)
--
-- A condicao e um `or` entre `~= nil` e `~= ""`, que e SEMPRE verdadeira:
-- mesmo com animation_name == nil a linha 182 roda e entrega nil ao seek.
-- O nativo responde "invalid arguments in ... seekWidgetByName" e a abertura
-- do menu para no meio — por isso o centro do PVE nunca era preenchido.
--
-- O padrao aparece em muitos arquivos do acervo (nunca pode ser falso), por
-- isso a correcao fica no WRAPPER: nome invalido -> não encontrado (nil),
-- que e exatamente o que `if terminal.animation_panel ~= nil` (:185) espera.
local M = {}

function M.run()
    -- 1) o padrao do acervo e sempre verdadeiro (prova da causa)
    local nilValor = nil
    local condicao = (nilValor ~= nil) or (nilValor ~= "")
    print('SEEK_CONTRATO padrao_or_com_nil=' .. tostring(condicao))
    assert(condicao == true, 'pre-condicao: o padrao do acervo e sempre verdadeiro')

    local no = csb.createNode('duplicate/pve_main.csb')
    local root = no and no:getChildByName('root')
    assert(root ~= nil, 'root real necessario')

    -- 2) nome nil NAO pode estourar
    local okNil, rNil = pcall(function()
        return ccui.Helper:seekWidgetByName(root, nil)
    end)
    print('SEEK_CONTRATO nome_nil ok=' .. tostring(okNil)
        .. ' resultado=' .. tostring(okNil and rNil))
    assert(okNil, 'nome nil nao pode estourar: ' .. tostring(rNil))
    assert(rNil == nil, 'nome nil deve devolver nil')

    -- 3) nome de tipo errado tambem nao estoura
    for _, ruim in ipairs({ 123, {}, true }) do
        local okR, rR = pcall(function()
            return ccui.Helper:seekWidgetByName(root, ruim)
        end)
        print('SEEK_CONTRATO nome_' .. type(ruim) .. ' ok=' .. tostring(okR)
            .. ' resultado=' .. tostring(okR and rR))
        assert(okR, 'nome ' .. type(ruim) .. ' nao pode estourar: ' .. tostring(rR))
        assert(rR == nil, 'nome invalido deve devolver nil')
    end

    -- 4) nome VALIDO continua achando (nada foi quebrado)
    local okBom, rBom = pcall(function()
        return ccui.Helper:seekWidgetByName(root, 'PageView_pve_map')
    end)
    print('SEEK_CONTRATO nome_valido ok=' .. tostring(okBom)
        .. ' achou=' .. tostring(okBom and rBom ~= nil))
    assert(okBom and rBom ~= nil, 'nome valido precisa continuar achando')

    -- 5) e o nome de um widget comum do CSB
    local okRoot, rRoot = pcall(function()
        return ccui.Helper:seekWidgetByName(root, 'PageView')
    end)
    print('SEEK_CONTRATO widget_comum achou=' .. tostring(okRoot and rRoot ~= nil))

    print('SEEK_CONTRATO_PASSED nome invalido vira nil, nome valido continua achando')
end

return M
