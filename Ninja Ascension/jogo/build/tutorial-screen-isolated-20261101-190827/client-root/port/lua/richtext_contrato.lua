-- Contrato: a adaptação ORIGINAL que fornece formatTextExt funciona.
--
-- Contexto medido (sessão 44): TuitionController.lua:924 estourava
--   "attempt to call method 'formatTextExt' (a nil value)"
-- porque o `pve_entry_ready.lua:9-10` — que define exatamente esse método —
-- NUNCA ERA INSTALADO (era um dos módulos órfãos). Agora ele é instalado por
-- instalar_adaptacoes.lua. Este contrato prova que a definição ORIGINAL,
-- sozinha, resolve o problema — sem nenhuma duplicata.
local M = {}

local function criarComTexto(txt)
    local rt = ccui.RichText:create()
    rt:ignoreContentAdaptWithSize(false)
    rt:setContentSize(cc.size(300, 0))
    rt:setAnchorPoint(cc.p(0, 0))
    local el = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255,
        txt, "fonts/FZYiHei-M20S.ttf", 20)
    rt:pushBackElement(el)
    return rt
end

function M.run()
    -- 1) o módulo original fornece o método
    local mod = require('pve_entry_ready')
    mod.install()

    local inst = ccui.RichText:create()
    print('RICHTEXT_CONTRATO existe=' .. tostring(inst.formatTextExt ~= nil))
    assert(inst.formatTextExt ~= nil, 'a adaptacao original precisa fornecer formatTextExt')

    -- 2) NÃO é função vazia: recalcula a altura de fato
    local rt = criarComTexto("Texto do tutorial do Iruka")
    local s1 = rt:getContentSize()
    print(string.format('RICHTEXT_CONTRATO antes=%.1fx%.1f', s1.width, s1.height))
    assert(s1.height == 0, 'pre-condicao: altura 0 antes do recalculo')

    local ok, err = pcall(function() rt:formatTextExt() end)
    print('RICHTEXT_CONTRATO chamada ok=' .. tostring(ok) .. ' err=' .. tostring(err))
    assert(ok, 'formatTextExt nao pode estourar')

    local s2 = rt:getContentSize()
    print(string.format('RICHTEXT_CONTRATO depois=%.1fx%.1f', s2.width, s2.height))
    assert(s2.height > 0, 'formatTextExt precisa produzir altura real, nao ser vazia')

    -- 3) o uso exato de TuitionController.lua:924-929 funciona ponta a ponta
    local m_leg = 0
    for i = 1, 3 do
        local linha = criarComTexto("linha " .. i .. " do tutorial")
        linha:formatTextExt()
        local h = linha:getContentSize().height
        m_leg = m_leg - h
        print(string.format('RICHTEXT_CONTRATO linha %d altura=%.1f m_leg=%.1f', i, h, m_leg))
        assert(h > 0, 'cada linha precisa ter altura')
    end
    assert(m_leg < 0, 'o empilhamento do acervo precisa acumular')

    print('RICHTEXT_CONTRATO_PASSED adaptacao original fornece formatTextExt com recálculo real')
end

return M
