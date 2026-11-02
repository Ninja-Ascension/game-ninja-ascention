-- port/lua/numeros_flutuantes.lua — OS NÚMEROS DE DANO/CURA NÃO SAÍAM DA TELA.
--
-- PROBLEMA (medido, não suposto):
--   FightRole:drawAntNumber (FightRole.lua:4389) monta o número em
--   battle/battle_combo_1.csb (camp 0) ou battle_combo.csb (camp 1) e registra
--   o callback de frame que REMOVE o nó no fim da animação (:4473-4500):
--
--       local str = frame:getEvent()
--       ...
--       if str == "over" then                       -- :4481
--           action._root._battle_hurt_action = nil
--           action._root:removeFromParent(true)     -- :4497  <- a remoção
--       end
--
--   Só que o evento de frame da animação "battle_hurt" NÃO se chama "over".
--
--   Medição (port/lua/diag_hurt.lua, no binário, com o CSB real):
--       battle_hurt existe=true   duracao=140
--       eventos=1 [closex1]       ordem=[close]
--       over_chegou=false         <-- a remoção nunca acontece
--
--   E a estrutura do .csb confirma por que "over" não é evento:
--       offset 5636  "Panel_hp"     -> widget
--       offset 5652  "over"         -> actionTag DESSE widget
--       offset 8152  "FrameEvent"   -> evento de frame
--       offset 8236  "close"        -> nome do evento de frame
--   Ou seja "over" é o actionTag de um Panel, e o evento real é "close".
--
--   Resultado: o nó do número nunca é removido e os números se acumulam.
--
-- CORREÇÃO:
--   embrulha a ação da timeline assim que ela é criada, para reconhecer o
--   evento que o layout realmente emite ("close") e fazer a MESMA remoção que
--   o acervo já faz para "over". Nada é apagado indiscriminadamente, não há
--   limpeza periódica, e os valores desenhados não mudam.
--
-- O que NÃO se faz aqui:
--   * não se remove nó por tempo nem por varredura;
--   * não se esconde o número antes da hora (a animação roda inteira);
--   * não se altera o valor do dano nem a soma de combo.
local M = {}

local function nota(txt)
    print("HOST_NUMEROS " .. txt)
end

-- Nomes aceitos como "fim do número". "close" é o que o layout emite
-- (medido); "over" fica porque é o que o acervo já esperava.
local EVENTOS_DE_FIM = { close = true, over = true }

function M.armarAcao(acao, rootDono)
    -- MEDIDO: a ação da timeline chega como userdata (binding nativo), não
    -- como table. Comparar com "table" fazia armarAcao devolver false sem
    -- instalar nada — a correção ficava inerte.
    if acao == nil or type(acao) == "boolean" or type(acao) == "number"
        or type(acao) == "string" then
        return false
    end
    if acao.__nr_fim_instalado then return true end
    acao.__nr_fim_instalado = true

    local original = acao.setFrameEventCallFunc
    if type(original) ~= "function" then return false end

    acao.setFrameEventCallFunc = function(self, callfunc, ...)
        if type(callfunc) ~= "function" then
            return original(self, callfunc, ...)
        end
        -- Embrulha o callback do acervo: quando o evento de fim chegar com o
        -- nome que o layout usa, ele é entregue ao callback original como se
        -- fosse "over", que é o nome que o acervo compara.
        local avisou = false
        local embrulhado = function(frame)
            if frame == nil then return callfunc(frame) end
            local okE, nome = pcall(function() return frame:getEvent() end)
            nome = okE and nome or nil
            if EVENTOS_DE_FIM[nome] and nome ~= "over" then
                -- Reaproveita o próprio frame, só trocando o evento lido.
                -- Não se cria Frame falso: embrulha-se o getEvent.
                local realGetEvent = frame.getEvent
                if realGetEvent ~= nil then
                    local okSet = pcall(function()
                        frame.getEvent = function() return "over" end
                    end)
                    if okSet then
                        local okCb, r = pcall(callfunc, frame)
                        pcall(function() frame.getEvent = realGetEvent end)
                        if not okCb then error(r,0) end
                        return r
                    end
                end
                if not avisou then
                    avisou = true
                    nota("não foi possível traduzir o evento '" .. tostring(nome)
                        .. "'; o número pode não ser removido")
                end
            end
            return callfunc(frame)
        end
        return original(self, embrulhado, ...)
    end
    return true
end

-- Instala no FightRole: intercepta a criação da timeline do número.
function M.install(class)
    if class == nil or type(class) == "boolean" or type(class) == "number"
        or type(class) == "string" then
        return
    end
    if class.__nr_numeros then return end
    local original = class.drawAntNumber
    if type(original) ~= "function" then return end
    class.__nr_numeros = true

    class.drawAntNumber = function(self, ...)
        -- As ações são criadas dentro do corpo original; depois de rodar, a
        -- ação do número já existe em self._battle_combo_root.
        local create=csb.createTimeline
        csb.createTimeline=function(path,...)
            local action=create(path,...)
            if path=='battle/battle_combo.csb' or path=='battle/battle_combo_1.csb' then
                M.armarAcao(action)
            end
            return action
        end
        local result={pcall(original,self,...)}
        csb.createTimeline=create
        if not result[1] then error(result[2],0) end
        return unpack(result,2)
    end
end

function M.armar()
    if package.__nr_numeros_armado then return end
    package.__nr_numeros_armado = true
    local original = app.load
    app.load = function(name, ...)
        local result = original(name, ...)
        if name == "client.battle.landscape.FightRole" then
            M.install(rawget(_G, "FightRole"))
        end
        return result
    end
    M.install(rawget(_G, "FightRole"))
end

return M
