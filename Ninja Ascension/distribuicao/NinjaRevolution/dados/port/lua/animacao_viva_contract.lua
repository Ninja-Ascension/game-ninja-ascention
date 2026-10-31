-- Contrato (vivo): o nó REAL do acervo aceita todos os índices do enum.
--
-- Usa o mesmo ponto de entrada do acervo: sp.spine(json, atlas, scale).
--
-- Antes da correção, playWithIndex(38) — o 绝技 do Naruto — fazia
-- display.lua:427 ler animationNameList[39] = nil e o binding nativo
-- estourava:
--   native_spine.lua:32: bad argument #4 to 'nrSpineCommand'
--     (string expected, got nil)
local M = {}

function M.run()
    local anim = require('indices_de_animacao')
    print('ANIM_VIVO armado=' .. tostring(package.__nr_anim == true))

    local enum = rawget(_G, '_enum_animation_l_frame_index')
    assert(type(enum) == 'table', 'enumeração ausente')

    -- Mesmo formato que display.lua:295-296 usa.
    local json = 'sprite/spirte_102101.json'
    local atlas = 'sprite/spirte_102101.atlas'

    local okC, no = pcall(sp.spine, json, atlas, 1)
    print('ANIM_VIVO criar ok=' .. tostring(okC) .. ' erro=' .. tostring(no))
    if not okC or no == nil then
        print('ANIM_VIVO_SEM_NO')
        return
    end

    local lista = no.animationNameList
    print('ANIM_VIVO animacoes=' .. tostring(type(lista) == 'table' and #lista or '?'))
    if type(lista) ~= 'table' or #lista == 0 then
        print('ANIM_VIVO_SEM_LISTA')
        return
    end

    -- O acervo sempre inicializa o armature depois de criar (display.lua:403):
    -- é initArmature que instala getAnimation/playWithIndex.
    local okI2, errI2 = pcall(sp.initArmature, no, true)
    print('ANIM_VIVO initArmature ok=' .. tostring(okI2) .. ' erro=' .. tostring(errI2))
    assert(okI2, 'initArmature falhou: ' .. tostring(errI2))

    local jueji = enum.animation_new_skill_13_jueji
    print('ANIM_VIVO jueji_enum=' .. tostring(jueji)
        .. ' tamanho_lista=' .. tostring(#lista)
        .. ' estouraria=' .. tostring(jueji >= #lista))

    local obj = no:getAnimation()
    print('ANIM_VIVO getAnimation=' .. tostring(obj))
    assert(obj ~= nil, 'nó sem getAnimation')

    -- 1) o índice do 绝技 não pode estourar E tem de tocar 13_jueji
    print('ANIM_VIVO chamando playWithIndex(' .. tostring(jueji) .. ')')
    local okP, errP = pcall(function() obj:playWithIndex(jueji) end)
    print('ANIM_VIVO playWithIndex(' .. tostring(jueji) .. ') ok='
        .. tostring(okP) .. ' erro=' .. tostring(errP))
    assert(okP, 'ainda estoura no índice do 绝技: ' .. tostring(errP))

    -- confere que a posição traduzida é a da animação 13_jueji
    local indiceReal = anim.traduzir(lista, jueji,
        anim.acaoDoIndice(jueji))
    local nomeReal = lista[indiceReal + 1]
    print('ANIM_VIVO traduzido=' .. tostring(indiceReal)
        .. ' nome=' .. tostring(nomeReal))
    assert(nomeReal ~= nil and anim.numeroDoNome(nomeReal) == '13',
        'o 绝技 deveria tocar 13_jueji, tocou ' .. tostring(nomeReal))

    -- 2) todos os índices do enum
    local estouros, aceitos = 0, 0
    local total = 0
    for acao, indice in pairs(enum) do
        if type(indice) == 'number' then
            total = total + 1
            local okI, eI = pcall(function() obj:playWithIndex(indice) end)
            if okI then aceitos = aceitos + 1
            else
                estouros = estouros + 1
                print('ANIM_VIVO ESTOURO ' .. tostring(acao) .. '=' .. tostring(indice)
                    .. ' :: ' .. tostring(eI))
            end
        end
    end
    print('ANIM_VIVO total=' .. total .. ' aceitos=' .. aceitos
        .. ' estouros=' .. estouros)
    assert(estouros == 0, 'algum índice do enum ainda estoura o nativo')

    print('ANIM_VIVO_PASSED nó real aceita todos os índices do enum sem estourar')
end

return M
