-- Contrato: a animação 绝技 (índice 38 no enum) toca até o FIM num nó real,
-- entrega o evento de término ao handler do acervo, e o ataque conclui.
--
-- Elo (c) "conclusão do ataque" e (d) "habilidade do Naruto": sem o fim da
-- animação o tutorial nunca é liberado e a onda 1 trava.
--
-- Caminho real do acervo (display.lua:403-466):
--   sp.initArmature(no) instala no,getAnimation, no.playWithIndex e
--   no.setMovementEventCallFunc — este último liga o handler no evento
--   ANIMATION_COMPLETE do nó (não em getAnimation()).
--
-- Antes da correção o play estourava (native_spine.lua:32) e nenhum evento
-- de término era produzido.
local M = {}

function M.run()
    require('texture_async_compat').testMenuLoader()
    local anim = require('indices_de_animacao')
    local enum = rawget(_G, '_enum_animation_l_frame_index')
    assert(type(enum) == 'table', 'enumeração ausente')

    local okC, no = pcall(sp.spine, 'sprite/spirte_102101.json',
        'sprite/spirte_102101.atlas', 1)
    if not okC or no == nil then
        print('ANIM_FIM_SEM_NO ' .. tostring(no))
        return
    end
    pcall(sp.initArmature, no, false)

    local lista = no.animationNameList
    local jueji = enum.animation_new_skill_13_jueji

    -- O próprio display.lua instala setMovementEventCallFunc no NÓ.
    print('ANIM_FIM tem_setMovementEventCallFunc='
        .. tostring(type(no.setMovementEventCallFunc) == 'function'))
    assert(type(no.setMovementEventCallFunc) == 'function',
        'o nó precisa de setMovementEventCallFunc: é ele que liga o fim da animação')

    local chamadas = 0
    local okSet = pcall(function()
        no:setMovementEventCallFunc(function(armatureBack, movementType, movementID)
            chamadas = chamadas + 1
        end)
    end)
    print('ANIM_FIM handler_registrado=' .. tostring(okSet))

    -- Toca a 绝技 pelo índice do enum (é o que o acervo pede).
    local obj = no:getAnimation()
    local okP, errP = pcall(function() obj:playWithIndex(jueji) end)
    print('ANIM_FIM playWithIndex(' .. tostring(jueji) .. ') ok='
        .. tostring(okP) .. ' erro=' .. tostring(errP))
    assert(okP, 'play falhou: ' .. tostring(errP))
    assert(chamadas==0,'Completion callback fired at animation start')

    local indiceReal = anim.traduzir(lista, jueji, anim.acaoDoIndice(jueji))
    local nomeReal = lista[indiceReal + 1]
    print('ANIM_FIM animacao=' .. tostring(nomeReal)
        .. ' posicao=' .. tostring(indiceReal))
    assert(nomeReal ~= nil and anim.numeroDoNome(nomeReal) == '13',
        'deveria tocar 13_jueji, tocou ' .. tostring(nomeReal))

    -- Avança o tempo do nó real até a animação acabar.
    for _ = 1, 900 do
        local okU = pcall(function() obj:update(1 / 60) end)
        if not okU then break end
    end

    print('ANIM_FIM chamadas_do_handler=' .. chamadas)
    assert(chamadas > 0,
        'a animação não entregou ANIMATION_COMPLETE: o ataque não conclui')
    assert(chamadas==1,'Finite ultimate repeated its completion callback')
    local actor=sp.SkeletonAnimation:create('sprite/spirte_102101.json',
        'sprite/spirte_102101.atlas',1)
    sp.initArmature(actor,true)
    local role={armature=actor,current_fight_data={}}
    actor._self=role
    actor._actionIndex=jueji;actor._nextAction=jueji
    local starts=0
    actor._invoke=function(node)
        if node._actionIndex==jueji then
            starts=starts+1
            node._nextAction=enum.animation_standby
        end
    end
    actor:setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    actor:playWithIndex(jueji)
    assert(starts==1,'Combat effects waited for animation completion')
    for _=1,240 do actor:update(1/60) end
    assert(starts==1,'Combat effects started twice')
    actor:clearTracks()

    print('ANIM_FIM_PASSED 绝技 toca até o fim e entrega o fim ao handler do acervo')
end

return M
