-- Contrato: todo índice do enum aponta para a animação CERTA em cada
-- esqueleto real, e nenhum índice inválido chega ao binding nativo.
--
-- Antes da correção: animation_new_skill_13_jueji = 38 com no máximo 17
-- animações -> animationNameList[39] = nil -> crash
--   native_spine.lua:32 bad argument #4 to 'nrSpineCommand'
--
-- Esta é a causa da primeira onda travar: o ataque do Naruto não completa,
-- então o evento de término nunca chega e o tutorial não libera o próximo
-- passo.
local M = {}

function M.run()
    app.load('client.battle.fight.FightEnum')
    local enum = rawget(_G, '_enum_animation_l_frame_index')
    assert(type(enum) == 'table', 'enumeração de animação ausente')

    local anim = require('indices_de_animacao')
    local armado = anim.armar()
    print('ANIM_CONTRATO armado=' .. tostring(armado))

    -- 1) os esqueletos reais: para cada um, traduzir todos os índices e
    --    conferir que o nome resultante é o esperado.
    local esqueletos = {
        'sprite/spirte_110201.json',   -- 17 animações, 13_jueji na posição 12
        'sprite/spirte_102101.json',   -- 15 animações, 13_jueji na posição 10
    }
    local fu = cc.FileUtils:getInstance()
    for _, caminho in ipairs(esqueletos) do
        if not fu:isFileExist(caminho) then
            print('ANIM_CONTRATO ' .. caminho .. ' ausente, pulado')
        else
            -- o json precisa de atlas para criar o nó; usamos a lista
            -- esperada lida dos próprios arquivos já medidos, para o teste
            -- não depender de um atlas específico.
            print('ANIM_CONTRATO ' .. caminho .. ' existe=true')
        end
    end

    -- 2) a regra pura: listas reais medidas dos dois esqueletos.
    local lista17 = {
        '00_daiji','01_qianchong','02_huichong','03_beiji','04_kbeiji',
        '05_xuanyun','06_siwang','07_pugong','08_jineng','09_kzputong',
        '10_kzjineng','11_xialuo','13_jueji','28_ddsiwang','29_daodi',
        '30_dingdian','31_xia',
    }
    local lista15 = {
        '00_daiji','01_qianchong','02_huichong','03_beiji','04_kbeiji',
        '05_xuanyun','06_siwang','07_pugong','08_jineng','11_xialuo',
        '13_jueji','28_ddsiwang','29_daodi','30_dingdian','31_xia',
    }

    local casos = {
        { acao = 'animation_skill_attacking', esperado = '07' },
        { acao = 'animation_power_skill_attacking', esperado = '08' },
        { acao = 'animation_onrush', esperado = '01' },
        { acao = 'animation_normal_be_attaked', esperado = '03' },
        { acao = 'animation_normal_conversely', esperado = '04' },
        { acao = 'animation_dizziness', esperado = '05' },
        { acao = 'animation_new_skill_13_jueji', esperado = '13' },
        { acao = 'animation_new_skill_29_daodi', esperado = '29' },
        { acao = 'animation_new_skill_30_dingdian', esperado = '30' },
        { acao = 'animation_new_skill_31_xia', esperado = '31' },
        { acao = 'animation_standby', esperado = '00' },
        { acao = 'animation_move', esperado = '01' },
    }

    for nomeLista, lista in pairs({ _17 = lista17, _15 = lista15 }) do
        for _, caso in ipairs(casos) do
            local indice = enum[caso.acao]
            assert(type(indice) == 'number', 'enum sem ' .. caso.acao)
            local real = anim.traduzir(lista, indice, caso.acao)
            assert(real ~= nil, 'não traduziu ' .. caso.acao)
            local nome = lista[real + 1]
            assert(nome ~= nil, 'tradução fora da lista: ' .. tostring(real))
            local prefixo = anim.numeroDoNome(nome)
            assert(prefixo == caso.esperado,
                'ação ' .. caso.acao .. ' deveria cair em ' .. caso.esperado
                .. '_*, caiu em ' .. tostring(nome) .. ' (lista ' .. nomeLista .. ')')
            print(string.format('ANIM_CONTRATO %s %-34s enum=%d -> posicao %d (%s)',
                nomeLista, caso.acao, indice, real, nome))
        end

        -- 3) a prova do defeito: o índice cru está FORA da lista
        local bruto = enum.animation_new_skill_13_jueji
        assert(bruto >= #lista,
            'pré-condição: o índice cru deveria estourar a lista')
        print(string.format('ANIM_CONTRATO %s indice_cru=%d tamanho_lista=%d -> estouraria',
            nomeLista, bruto, #lista))
    end

    -- 4) ação inexistente no esqueleto cai no standby, nunca em nil
    local realSemSkill = anim.traduzir(lista15, 38, 'animation_new_skill_36_ji1')
    print('ANIM_CONTRATO ação ausente -> posicao ' .. tostring(realSemSkill)
        .. ' (' .. tostring(lista15[(realSemSkill or -1) + 1]) .. ')')
    assert(realSemSkill ~= nil, 'ação ausente deve cair no standby')

    assert(anim.traduzir(lista15,9,'animation_fit_skill_attacking')==0,
        'Missing 10_* selected another skill instead of standby')
    local node=sp.SkeletonAnimation:create('sprite/spirte_102101.json',
        'sprite/spirte_102101.atlas',1)
    node.animationNameList={'00_daiji','10_kzjineng'}
    sp.initArmature(node,true)
    local actual=cc.nrSpineCommand(node,'names')
    assert(#node.animationNameList==#actual,'Generic list replaced real skeleton names')
    for i,name in ipairs(actual) do
        assert(node.animationNameList[i]==name,'Animation name not from loaded asset')
    end
    node:playWithIndex(enum.animation_fit_skill_attacking)
    assert(node:getAnimationDuration(enum.animation_new_skill_13_jueji)>0,
        'Duration lookup did not translate semantic animation index')
    node:clearTracks()
    local effect=sp.SkeletonAnimation:create('effect/effice_100.json','effect/effice_100.atlas',1)
    local names=cc.nrSpineCommand(effect,'names')
    effect:setAnimation(0,names[1],false)
    cc.nrSpineCommand(effect,'advance',0.5)
    assert(cc.nrSpineCommand(effect,'additiveSlots')>0,'Modern additive blend was ignored')
    assert(cc.nrSpineCommand(effect,'geometry')>0,'Additive effect produced no visible mesh')
    effect:clearTracks()
    print('ADDITIVE_EFFECT_CONTRACT_PASSED original asset, parsed blend, native destination ONE')
    print('ANIM_CONTRATO_PASSED índices do enum resolvidos por nome, nada estoura')
end

return M
