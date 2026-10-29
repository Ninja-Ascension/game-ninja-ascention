-- Prova isolada: o caminho REAL de FightRound.lua:72-93, sem o harness.
--
-- Por que existe: no contrato (port/lua/tutorial_contract.lua), a animacao da
-- segunda onda e criada e tem duracao, mas closed=0 e started=0. A hipotese
-- original (callback gravado na classe em vez da instancia) foi REFUTADA: em
-- display.lua:455 skeletonNode e o parametro de sp.initArmature, portanto a
-- INSTANCIA. Esta prova roda exatamente a sequencia do FightRound para achar
-- a diferenca real entre o contrato e a execucao normal.
local M = {}

function M.run()
    assert(sp and sp.SkeletonAnimation, 'adapter Spine nativo ausente')
    assert(type(sp.initArmature) == 'function', 'sp.initArmature ausente')

    local chamado = 0
    local anim = sp.spine('sprite/effice_guochang.json',
        'sprite/effice_guochang.atlas', 1, 0, 'animation2', true, nil)
    assert(anim, 'animacao nao criada')

    -- Sequencia identica a FightRound.lua:74-91
    anim._self = {}
    sp.initArmature(anim, false)
    print('PROVA _LastsCountTurns=' .. tostring(anim._LastsCountTurns))
    print('PROVA _invoke e deleteEffect=' ..
        tostring(anim._invoke == deleteEffect))

    anim._invoke = function() chamado = chamado + 1 end
    anim:getAnimation():setMovementEventCallFunc(
        csb.changeAction_animationEventCallFunc)

    print('PROVA instancia.changeActionCallfunc=' ..
        tostring(anim.changeActionCallfunc ~= nil))
    print('PROVA sp.EventType.ANIMATION_COMPLETE=' ..
        tostring(sp.EventType and sp.EventType.ANIMATION_COMPLETE))
    -- Lista TODAS as chaves gravadas: se nao houver 3, o registro foi feito
    -- sob outra chave e o despacho nunca o encontra.
    local chaves = {}
    if anim.__nrSpineHandlers then
        for k, v in pairs(anim.__nrSpineHandlers) do
            chaves[#chaves + 1] = tostring(k) .. '=' .. type(v)
        end
    end
    print('PROVA chaves registradas=[' .. table.concat(chaves, ', ') .. ']')
    print('PROVA handler COMPLETE=' ..
        tostring(anim.__nrSpineHandlers ~= nil
            and anim.__nrSpineHandlers[sp.EventType.ANIMATION_COMPLETE] ~= nil))
    print('PROVA getAnimation devolve a propria instancia=' ..
        tostring(anim:getAnimation() == anim))

    -- Avanca como o contrato faz (60 Hz), contando despachos.
    -- Instrumenta o despacho para saber se o handler Lua e' chamado e com que
    -- tipo: o trace nativo mostrou SPINE_DISPATCH type=3 chegando ao Lua.
    local despachos = {}
    local originalDispatch = __nrSpineDispatch
    __nrSpineDispatch = function(node, kind, event)
        despachos[#despachos + 1] = tostring(kind)
        print('PROVA dispatch kind=' .. tostring(kind)
            .. ' mesmoObjeto=' .. tostring(node == anim)
            .. ' handlersDoNo=' .. tostring(node.__nrSpineHandlers)
            .. ' handlersDaAnim=' .. tostring(anim.__nrSpineHandlers)
            .. ' temHandlerPara=' .. tostring(
                node.__nrSpineHandlers ~= nil
                and node.__nrSpineHandlers[kind] ~= nil))
        return originalDispatch(node, kind, event)
    end
    local duracao = anim:getAnimationDurationEx('animation2')
    local passos = math.ceil((duracao + 0.02) * 60)
    for _ = 1, passos do cc.nrSpineCommand(anim, 'advance', 1 / 60) end
    __nrSpineDispatch = originalDispatch
    print('PROVA passos=' .. passos .. ' duracao=' .. duracao ..
        ' callback=' .. chamado .. ' tipos=' .. table.concat(despachos, ','))

    anim:clearTracks()
    print('PROVA_SEQUENCIA_CONCLUIDA')
end

return M
