-- Contrato: a saída do painel de dano/cura entrega ao acervo o evento que ele
-- espera, e a janela é fechada pelo mesmo fwin:close do acervo.
--
-- Antes: a animação de saída emite "zongshanghai_move_xs_over" e o callback
-- de DrawHitDamage.lua:600 compara com "zongshanghai_move_over" -> nunca casa
-- e a janela fica na tela depois do ataque.
local M = {}

-- Frame falso com o nome de evento que se quer testar.
local function frameCom(nome)
    return {
        getEvent = function() return nome end,
    }
end

function M.run()
    local painel = require('painel_de_dano')
    painel.armar()
    print('PAINEL_CONTRATO fechamentos_antes=' .. tostring(painel.fechamentos))

    -- Ação falsa com a mesma forma que o acervo usa.
    local registrado = nil
    local acao = {
        setFrameEventCallFunc = function(self, cb)
            registrado = cb
        end,
    }
    local ok = painel.armarAcao(acao)
    print('PAINEL_CONTRATO armarAcao=' .. tostring(ok))
    assert(ok, 'armarAcao deveria instalar na acao')

    -- O acervo registra o callback dele (DrawHitDamage.lua:594-603), que
    -- começa com "if nil == frame then return end".
    local fechou = 0
    local visto = nil
    acao:setFrameEventCallFunc(function(frame)
        if nil == frame then return end
        local nome = frame:getEvent()
        visto = nome
        if nome == 'zongshanghai_move_over' then
            fechou = fechou + 1
        end
    end)
    assert(registrado ~= nil, 'o callback do acervo deveria estar registrado')

    -- 1) o evento REAL da saída deve fechar
    registrado(frameCom('zongshanghai_move_xs_over'))
    print('PAINEL_CONTRATO evento_real xs_over -> fechou=' .. fechou
        .. ' nome_visto=' .. tostring(visto))
    assert(fechou == 1, 'o evento de saida real deveria fechar a janela')

    -- 2) outros eventos não fecham
    registrado(frameCom('zongshanghai_big_move_over'))
    registrado(frameCom('zongshanghai_move_over'))
    print('PAINEL_CONTRATO outros_eventos -> fechou=' .. fechou
        .. ' (move_over fecha 1 vez, como no acervo)')
    assert(fechou == 2, 'move_over fecha; big_move_over nao')

    -- 3) frame nil nao pode estourar
    local okN = pcall(function() registrado(nil) end)
    print('PAINEL_CONTRATO frame_nil ok=' .. tostring(okN))
    assert(okN, 'frame nil nao pode estourar')

    -- 4) o getEvent do frame e restaurado depois
    local f = frameCom('zongshanghai_move_xs_over')
    local antes = f.getEvent
    registrado(f)
    print('PAINEL_CONTRATO getEvent_restaurado=' .. tostring(f.getEvent == antes))
    assert(f.getEvent == antes, 'o frame deve ser restaurado apos o callback')

    print('PAINEL_CONTRATO_PASSED saida do painel entrega o evento certo e fecha')
end

return M
