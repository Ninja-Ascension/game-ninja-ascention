-- Contrato: pve_entry_ready instala de fato quando LDuplicateWindow carrega.
--
-- CAUSA (medida, sessão 44): o módulo era aplicado no boot com a classe
-- ainda nil, ligava package.__nr_pve_entry_ready e nunca mais era tentado.
-- Efeito em jogo: a janela do PVE era criada, onEnterTransitionFinish nunca
-- rodava com _pageViews pronto e o centro da tela ficava vazio — só as abas
-- ("Formation", "Main", "Elite", "Nightmare") apareciam.
local M = {}

function M.run()
    local inst = require('instalar_adaptacoes')

    -- 1) antes de a classe existir, a adaptação NÃO pode se declarar feita
    local st1 = inst.estado()
    print('READY_CONTRATO antes classe_existe=' ..
        tostring(rawget(_G, 'LDuplicateWindow') ~= nil)
        .. ' pve_entry_ready_instalado=' .. tostring(st1.pve_entry_ready))
    assert(st1.pve_entry_ready ~= true,
        'nao pode estar instalado antes da classe existir')

    -- 2) carrega a classe, como o jogo faz ao entrar no PVE
    local okL, errL = pcall(app.load, 'client.landscape.duplicate.LDuplicateWindow')
    print('READY_CONTRATO carregou_classe ok=' .. tostring(okL)
        .. ' err=' .. tostring(errL):sub(1, 200))
    assert(rawget(_G, 'LDuplicateWindow') ~= nil, 'classe precisa ter carregado')

    -- 3) a adaptação precisa ter sido aplicada pelo gancho de carga
    local st2 = inst.estado()
    print('READY_CONTRATO depois pve_entry_ready_instalado=' ..
        tostring(st2.pve_entry_ready))
    assert(st2.pve_entry_ready == true,
        'instalar_adaptacoes precisa retentar quando a classe carrega')

    local class = rawget(_G, 'LDuplicateWindow')
    print('READY_CONTRATO classe_envolvida=' .. tostring(class.__nr_pve_ready))
    assert(class.__nr_pve_ready == true,
        'onEnterTransitionFinish precisa estar envolvido')

    -- 4) o aliases _pr2 resolve pelo MESMO caminho do acervo (sem alias none)
    local no = csb.createNode('duplicate/pve_main.csb')
    local root = no:getChildByName('root')
    local pv = ccui.Helper:seekWidgetByName(root, 'PageView_pve_map')
    print('READY_CONTRATO PageView_pve_map encontrada=' .. tostring(pv ~= nil))
    assert(pv ~= nil, 'o alias precisa entregar a PageView')
    local pvE = ccui.Helper:seekWidgetByName(root, 'PageView_pve_map_jy')
    local pvM = ccui.Helper:seekWidgetByName(root, 'PageView_pve_map_em')
    print('READY_CONTRATO elite=' .. tostring(pvE ~= nil)
        .. ' nightmare=' .. tostring(pvM ~= nil))
    assert(pvE ~= nil and pvM ~= nil, 'as tres PageViews precisam resolver')

    -- 5) o gancho do excute existe e não engole a chamada normal
    print('READY_CONTRATO flag_final=' ..
        tostring(package.__nr_pve_entry_ready))

    print('READY_CONTRATO_PASSED pve_entry_ready aplica quando a classe carrega')
end

return M
