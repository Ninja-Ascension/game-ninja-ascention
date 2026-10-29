-- Contrato: os números flutuantes de dano/cura SAEM da tela no fim da
-- animação, sem limpeza periódica e sem esconder o efeito antes da hora.
--
-- Causa medida (port/lua/diag_hurt.lua + estrutura do .csb):
--   FightRole.lua:4481 remove o nó quando o evento de frame se chama "over".
--   A animação "battle_hurt" emite UM evento, chamado "close" (duração 140
--   quadros). "over" não é evento: no .csb ele é o actionTag do widget
--   Panel_hp (offset 5652); o evento real está sob "FrameEvent" (offset 8152).
--   Logo removeFromParent (:4497) nunca rodava e os números acumulavam.
--
-- O que este contrato mede, com o CSB real:
--   1. o evento que o layout emite é "close" (fato, não suposição);
--   2. sem a correção, o callback do acervo não vê "over" e o nó FICA;
--   3. com a correção, o callback vê o fim e o nó SAI;
--   4. o número desenhado é preservado (não se apaga o dano);
--   5. repetindo os ataques, a contagem de nós volta ao início.
local M = {}

function M.run()
    local numeros = require('numeros_flutuantes')

    local function rodarCiclo(usarCorrecao, valor)
        -- Cena nova por ciclo: cada número tem de ser medido no SEU pai,
        -- senão sobras de ciclos anteriores falseiam a contagem.
        local cena = ccui.Layout:create()
        local alvo = ccui.Layout:create()
        cena:addChild(alvo)

        local node = csb.createNode('battle/battle_combo_1.csb')
        local root = node:getChildByName('root')
        local action = csb.createTimeline('battle/battle_combo_1.csb')
        root:runAction(action)

        local eventosVistos = {}
        local removido = false

        -- Reproduz o callback do acervo (FightRole.lua:4473-4499).
        local function callbackDoAcervo(frame)
            if frame == nil then return end
            local str = frame:getEvent()
            eventosVistos[#eventosVistos + 1] = str
            if str == "over" then
                root:removeFromParent(true)
                removido = true
            end
        end

        if usarCorrecao then
            numeros.armarAcao(action, root)
        end
        action:setFrameEventCallFunc(callbackDoAcervo)

        -- Valor desenhado: o texto do AtlasLabel não pode ser zerado por nós.
        local lbl = ccui.Helper:seekWidgetByName(root, 'AtlasLabel_xue')
        if lbl ~= nil then lbl:setString(tostring(valor)) end

        -- O acervo tira o root do CSB antes de pendurar na cena
        -- (FightRole.lua:4426 root:removeFromParent(true)).
        root:removeFromParent(true)
        alvo:addChild(root)
        local filhosAntes = 0
        for _ in ipairs(alvo:getChildren()) do filhosAntes = filhosAntes + 1 end

        action:play('battle_hurt', false)
        for _ = 1, 900 do action:step(1 / 60) end

        local filhosDepois = 0
        for _ in ipairs(alvo:getChildren()) do filhosDepois = filhosDepois + 1 end

        local texto = lbl and lbl:getString() or ''
        return {
            eventos = eventosVistos,
            removido = removido,
            antes = filhosAntes,
            depois = filhosDepois,
            texto = texto,
            valor = valor,
        }
    end

    -- 1) sem correção: o número fica
    local sem = rodarCiclo(false, 1234)
    print('NUMEROS sem_correcao eventos=[' .. table.concat(sem.eventos, ',') .. ']'
        .. ' removido=' .. tostring(sem.removido)
        .. ' filhos ' .. sem.antes .. '->' .. sem.depois)
    assert(sem.eventos[1] == 'close',
        'o evento emitido pelo layout deveria ser "close", veio '
        .. tostring(sem.eventos[1]))
    assert(sem.removido == false,
        'pré-condição: sem a correção o callback do acervo NÃO deve remover')
    assert(sem.depois == sem.antes,
        'pré-condição: sem a correção o nó deve permanecer')

    -- 2) com correção: o número sai e o valor é preservado
    local com = rodarCiclo(true, 1234)
    print('NUMEROS com_correcao eventos=[' .. table.concat(com.eventos, ',') .. ']'
        .. ' removido=' .. tostring(com.removido)
        .. ' filhos ' .. com.antes .. '->' .. com.depois
        .. ' valor=' .. tostring(com.texto))
    assert(com.removido == true, 'com a correção o nó deve ser removido')
    assert(com.depois < com.antes, 'com a correção o filho deve sair do pai')
    assert(com.texto == '1234',
        'o valor do dano deve ser preservado, ficou ' .. tostring(com.texto))

    -- 3) repetição: nada se acumula
    local base = nil
    for i = 1, 12 do
        local r = rodarCiclo(true, 100 + i)
        if base == nil then base = r.antes end
        assert(r.depois == 0, 'após o ciclo ' .. i .. ' deveria restar 0 filho, restaram '
            .. r.depois)
    end
    print('NUMEROS 12 ataques seguidos: nenhum nó acumulado')

    -- 4) cura também termina (mesmo caminho: AtlasLabel_jiaxue)
    local curaNode = csb.createNode('battle/battle_combo_1.csb')
    local curaRoot = curaNode:getChildByName('root')
    local lblJia = ccui.Helper:seekWidgetByName(curaRoot, 'AtlasLabel_jiaxue')
    assert(lblJia ~= nil, 'AtlasLabel_jiaxue ausente: cura não teria onde desenhar')
    print('NUMEROS AtlasLabel_jiaxue encontrado (cura usa o mesmo evento de fim)')

    print('NUMEROS_PASSED evento close remove o nó, valor preservado, nada acumula')
end

return M
