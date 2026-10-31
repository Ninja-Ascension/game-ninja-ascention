-- Prova dos efeitos finitos versus loops intencionais (item 4).
--
-- Contexto: na captura enviada pelo usuario havia efeitos repetindo na tela.
-- Causa comprovada desta sessao: o enum de eventos do adapter estava no
-- formato do Spine 3.x (COMPLETE=3), enquanto o runtime e' Spine 2.1
-- (COMPLETE=2, ver build/deps/spine-2.1.25/.../AnimationState.h:42-44).
-- Como o handler era registrado na chave errada,
-- csb.changeAction_animationEventCallFunc nunca era chamado, _invoke nunca
-- rodava e deleteEffect nunca removia o efeito: ele ficava na tela para
-- sempre. O trace nativo provou o descompasso (SPINE_DISPATCH type=3 sem
-- handler) e, depois da correcao, type=2 com handler.
--
-- Esta prova cobre os DOIS lados, para nao transformar "parar de repetir" em
-- "apagar tudo":
--   A) efeito FINITO (sp.initArmature(node, false)) deve ser removido;
--   B) efeito em LOOP intencional (loop=true / _LastsCountTurns=-1) deve
--      CONTINUAR na tela.
local M = {}

local function novoNo()
    local no = cc.Node:create()
    return no
end

function M.run()
    assert(type(csb.changeAction_animationEventCallFunc) == 'function',
        'callback de animacao do acervo ausente')
    assert(type(deleteEffect) == 'function', 'deleteEffect ausente')

    -- ---------- A) efeito finito ----------
    local anim = sp.spine('sprite/effice_guochang.json',
        'sprite/effice_guochang.atlas', 1, 0, 'animation2', true, nil)
    assert(anim, 'animacao nao criada')
    local pai = novoNo()
    pai:addChild(anim)

    sp.initArmature(anim, false)            -- loop = false
    assert(anim._LastsCountTurns == 1, 'efeito finito deveria ter 1 turno')
    assert(anim._invoke == deleteEffect, '_invoke deveria ser deleteEffect')
    anim:getAnimation():setMovementEventCallFunc(
        csb.changeAction_animationEventCallFunc)

    local duracao = anim:getAnimationDurationEx('animation2')
    local passos = math.ceil((duracao + 0.02) * 60)
    for _ = 1, passos do cc.nrSpineCommand(anim, 'advance', 1 / 60) end

    local aindaLigado = anim:getParent() ~= nil
    print('PROVA_FINITO duracao=' .. duracao .. ' passos=' .. passos
        .. ' turnos=' .. tostring(anim._LastsCountTurns)
        .. ' aindaNaCena=' .. tostring(aindaLigado))
    assert(not aindaLigado,
        'efeito finito NAO foi removido: continua repetindo na tela')

    -- ---------- B) loop intencional ----------
    local loop = sp.spine('sprite/effice_guochang.json',
        'sprite/effice_guochang.atlas', 1, 0, 'animation2', true, nil)
    assert(loop, 'animacao de loop nao criada')
    local pai2 = novoNo()
    pai2:addChild(loop)

    sp.initArmature(loop, true)             -- loop = true (intencional)
    assert(loop._LastsCountTurns == -1, 'loop deveria ter -1 turno')
    loop:getAnimation():setMovementEventCallFunc(
        csb.changeAction_animationEventCallFunc)

    for _ = 1, passos * 2 do cc.nrSpineCommand(loop, 'advance', 1 / 60) end

    local loopNaCena = loop:getParent() ~= nil
    print('PROVA_LOOP turnos=' .. tostring(loop._LastsCountTurns)
        .. ' aindaNaCena=' .. tostring(loopNaCena))
    assert(loopNaCena,
        'loop intencional foi removido por engano: o efeito deveria continuar')

    -- limpeza da prova
    if loop:getParent() then loop:removeFromParent() end
    print('PROVA_EFEITOS_CONCLUIDA finito removido e loop preservado')
end

return M
