-- port/lua/painel_de_dano.lua — A JANELA DE DANO/CURA SAI DA TELA AO TERMINAR.
--
-- CAUSA (medida nos CSBs reais e no código do acervo):
--   A janela de dano/cura é fechada por frame events
--   (DrawHitDamage.lua onEnterTransitionFinish, 528-603):
--       :534  espera "combo_damage_move_xs_over"   -> playExitAction()  OK
--       :586  espera "zongshanghai_move_over"      -> animação normal   OK
--       :600  espera "zongshanghai_move_over"      -> SAÍDA do dano total
--
--   Mas playExitAction (:366-372) toca
--       hit_damage_action:play("zongshanghai_move_xs", false)
--   e essa animação emite o evento
--       "zongshanghai_move_xs_over"
--   (medido nos .csb: os eventos existentes são zongshanghai_big_move_over,
--   zongshanghai_move_over e zongshanghai_move_xs_over; idem nos _batter com
--   prefixo combo_damage_).
--
--   Como a saída nunca emite "zongshanghai_move_over", o callback de :600
--   nunca casa: a janela anima para fora e fica VIVA na tela depois da
--   animação — é o dano/cura que continua depois dos ataques acabarem.
--   O caminho de expiração por tempo (onUpdate :376-386) também não fecha,
--   porque :378-380 (fwin:close / setVisible(false)) estão comentados.
--
-- CORREÇÃO:
--   quando o frame event da saída chega com o nome que o CSB realmente emite,
--   ele é entregue ao callback do acervo como o nome que ele espera. O
--   fechamento continua sendo o do acervo (fwin:close(self), :601), pela
--   mesma ação e no mesmo instante em que ele já fecharia no original.
--
--   Mesmo mecanismo já usado e provado em port/lua/numeros_flutuantes.lua.
--   Nada de temporizador, nada de setVisible, nenhum valor de dano alterado.
local M = {}

local function nota(t) print("PAINEL_DANO " .. t) end

M.fechamentos = 0

-- Evento emitido pela animação de saída  /  evento que o acervo compara (:600)
local EMITIDO = "zongshanghai_move_xs_over"
local ESPERADO = "zongshanghai_move_over"

-- Embrulha a ação de saída para traduzir só esse evento.
function M.armarAcao(acao)
    if acao == nil or type(acao) == "boolean" or type(acao) == "number"
        or type(acao) == "string" then
        return false
    end
    if acao.__nr_painel_acao then return true end
    acao.__nr_painel_acao = true

    local original = acao.setFrameEventCallFunc
    if type(original) ~= "function" then return false end

    acao.setFrameEventCallFunc = function(self, callfunc, ...)
        if type(callfunc) ~= "function" then
            return original(self, callfunc, ...)
        end
        local embrulhado = function(frame)
            if frame == nil then return callfunc(frame) end
            local okE, nome = pcall(function() return frame:getEvent() end)
            nome = okE and nome or nil
            if nome == EMITIDO then
                M.fechamentos = M.fechamentos + 1
                local realGet = frame.getEvent
                if realGet ~= nil then
                    local okSet = pcall(function()
                        frame.getEvent = function() return ESPERADO end
                    end)
                    if okSet then
                        -- Garante a restauração mesmo se o callback estourar,
                        -- para nenhum frame do acervo ficar alterado.
                        local okCb, r = pcall(callfunc, frame)
                        pcall(function() frame.getEvent = realGet end)
                        if not okCb then error(r, 0) end
                        return r
                    end
                end
            end
            return callfunc(frame)
        end
        return original(self, embrulhado, ...)
    end
    return true
end

-- Instala no DrawHitDamage: a ação de saída é self.actions[2], criada dentro
-- de onEnterTransitionFinish (:591).
function M.install(class)
    if class == nil or type(class) == "boolean" or type(class) == "number"
        or type(class) == "string" then
        return false
    end
    if class.__nr_painel then return true end
    local original = class.onEnterTransitionFinish
    if type(original) ~= "function" then return false end
    class.__nr_painel = true

    class.onEnterTransitionFinish = function(self, ...)
        local create=csb.createTimeline
        csb.createTimeline=function(path,...)
            local action=create(path,...)
            if path=='battle/injury_settlement.csb' or path=='battle/injury_settlement_0.csb' then
                M.armarAcao(action)
            end
            return action
        end
        local result={pcall(original,self,...)}
        csb.createTimeline=create
        if not result[1] then error(result[2],0) end
        return unpack(result,2)
    end
    nota("instalado em DrawHitDamage.onEnterTransitionFinish")
    return true
end

-- A classe nasce quando o acervo carrega; aplica no carregamento e agora.
function M.armar()
    local cls = rawget(_G, "DrawHitDamage")
    local ok = M.install(cls)
    if ok then return true end
    if package.__nr_painel_ref then return false end
    package.__nr_painel_ref = true
    local load = app and app.load
    if type(load) ~= "function" then return false end
    app.load = function(nome, ...)
        local r = load(nome, ...)
        if nome == "client.battle.fight.DrawHitDamage" then
            M.install(rawget(_G, "DrawHitDamage"))
        end
        return r
    end
    nota("aguardando o carregamento de DrawHitDamage")
    return true
end

return M
