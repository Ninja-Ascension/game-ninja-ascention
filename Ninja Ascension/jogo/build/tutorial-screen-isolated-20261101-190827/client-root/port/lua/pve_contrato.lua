-- Contrato: o alias PageView_pve_map -> PageView_pve_map_pr2 funciona com o
-- pve_main.csb REAL, e _pageViews deixa de ser nil.
--
-- Antes: LDuplicateWindow.lua:2386 pede "PageView_pve_map"; o CSB só tem
-- "PageView_pve_map_pr2". Sem o alias, _pageViews = nil e :2387
-- (removeAllPages) já estourava — e na segunda passada :110
-- (_pageViews:setVisible(true)) estourava, batendo com o log da sessão 43.
local M = {}

function M.run()
    local okAlias = pcall(require, 'pve_entry_ready')
    assert(okAlias, 'pve_entry_ready deve carregar')

    -- Carrega o CSB REAL do acervo, pela mesma via que o acervo usa.
    local no = csb.createNode('duplicate/pve_main.csb')
    assert(no ~= nil, 'pve_main.csb deve abrir')
    local root = no:getChildByName('root')
    assert(root ~= nil, 'root do pve_main.csb deve existir')
    print('PVE_CONTRATO csb aberto; root=' .. tostring(root:getName()))

    -- 1) o nome EXATO que o acervo pede não existe cru
    local cru = ccui.Helper:seekWidgetByName(root, 'PageView_pve_map')
    print('PVE_CONTRATO sem_alias encontrou=' .. tostring(cru ~= nil))

    -- 2) com o alias instalado, o mesmo pedido resolve
    local mod = require('pve_entry_ready')
    mod.install()
    local pv = ccui.Helper:seekWidgetByName(root, 'PageView_pve_map')
    print('PVE_CONTRATO com_alias encontrou=' .. tostring(pv ~= nil))
    assert(pv ~= nil, 'o alias _pr2 precisa resolver PageView_pve_map')

    -- 3) é realmente o PageView (tem a API que o acervo chama)
    local okRemove, errRemove = pcall(function() return pv.removeAllPages end)
    local okScroll = pcall(function() return pv.setCustomScrollThreshold end)
    print('PVE_CONTRATO eh_pageview removeAllPages=' .. tostring(okRemove and pv.removeAllPages ~= nil)
        .. ' setCustomScrollThreshold=' .. tostring(okScroll))

    -- 4) a chamada de :2387 e :110 agora funcionam sem estourar
    local ok7 = pcall(function() pv:removeAllPages() end)
    print('PVE_CONTRATO removeAllPages ok=' .. tostring(ok7))
    assert(ok7, 'removeAllPages nao pode mais estourar')

    local ok110 = pcall(function() pv:setVisible(true) end)
    print('PVE_CONTRATO setVisible(true) ok=' .. tostring(ok110))
    assert(ok110, ':110 nao pode mais estourar')

    -- 5) os outros dois PageViews também resolvem (abas Elite/Nightmare)
    for _, par in ipairs({ { 'PageView_pve_map_jy', 'PageView_pve_map_jy_pr2' },
                           { 'PageView_pve_map_em', 'PageView_pve_map_em_pr2' } }) do
        local w = ccui.Helper:seekWidgetByName(root, par[1])
        print('PVE_CONTRATO ' .. par[1] .. ' encontrou=' .. tostring(w ~= nil))
        assert(w ~= nil, par[1] .. ' precisa resolver via ' .. par[2])
    end

    print('PVE_CONTRATO_PASSED alias _pr2 resolve, _pageViews nao e mais nil')
end

return M
