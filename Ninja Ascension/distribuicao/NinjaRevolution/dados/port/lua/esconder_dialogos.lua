-- port/lua/esconder_dialogos.lua
-- PEDIDO DO JOGADOR: "retire todos os dialogos do jogo que sobrepoem a tela com
-- personagens, ou seja conversas entre personagens". Escopo escolhido: a CAIXA
-- VISUAL some, mas o tutorial CONTINUA avancando (o evento nao e pulado).
--
-- Por que nao basta esconder:
--   RoleDialogueClass e quem entrega o evento de dialogo ao tutorial. Em
--   Mission.lua:2420-2433 o evento execute_type_dialog cria a janela, e o
--   avanco acontece no toque (:role_dialogue_touch -> touchNextMission,
--   RoleDialogue.lua:637-655) que executa "role_dialogue_out"; e esse
--   role_dialogue_out (:83-89) que fecha a janela e chama saveExecuteEvent,
--   gravando o progresso (education_change) e liberando o proximo evento.
--   Se a janela apenas sumir, ninguem toca nela e o guia trava ali.
--
-- Solucao: a janela continua existindo e concluindo o evento normalmente, mas
-- a arte (retrato/caixa/texto) fica invisivel e o toque e disparado pelo
-- proprio jogo, sem esperar o jogador.
local M={}

local function nota(texto)
    local caminho = cc.FileUtils:getInstance():getWritablePath() .. 'dialogos-ocultos.log'
    local arquivo = io.open(caminho, 'a')
    if arquivo then
        arquivo:write(os.date('%H:%M:%S ') .. texto .. '\n')
        arquivo:close()
    end
end

-- Deixa invisivel tudo o que a janela desenhou, preservando a estrutura: o
-- evento precisa continuar sendo concluido pela mesma janela.
local function esconderArte(janela)
    if require('initial_tutorial').state=='playing' then return 0 end
    local escondidos = 0
    for _, raiz in ipairs(janela.roots or {}) do
        if raiz and raiz.setVisible then
            raiz:setVisible(false)
            escondidos = escondidos + 1
        end
    end
    return escondidos
end

-- Dispara o mesmo caminho que o toque do jogador usaria.
local function avancar(janela)
    if janela.__nr_avanco_pedido then return end
    janela.__nr_avanco_pedido = true
    local ok, erro = pcall(function()
        -- touchNextMission trata "proximo evento" e "fim da lista" do mesmo
        -- jeito que o toque real (RoleDialogue.lua:637-655).
        janela:touchNextMission()
    end)
    if not ok then
        nota('erro ao avancar: ' .. tostring(erro))
    end
    janela.__nr_avanco_pedido = false
end

-- A janela pode ter sido FECHADA entre o agendamento e a execucao do servico
-- (o proprio role_dialogue_out fecha em 0,2 s). Chamar :isVisible() num no ja
-- destruido lanca "invalid 'obj' in function 'lua_ax_base_Node_isVisible'" e
-- vira crash do cliente. Aqui a checagem e feita sem tocar no no morto:
--   * window_alive confere o registro vivo do fwin;
--   * se o no nao esta mais na cena, nada e feito.
local function podeAvancar(janela)
    if janela == nil or janela.__nr_fechando == true then return false end
    -- fwin._list é o registro canônico das janelas vivas (fwin.lua:415): se a
    -- janela não está mais lá, já foi fechada e não deve ser tocada.
    if type(fwin) == 'table' and type(fwin._list) == 'table' then
        local vivo = false
        for _, v in pairs(fwin._list) do
            if v == janela then vivo = true break end
        end
        if not vivo then return false end
    end
    -- isVisible só é chamado DEPOIS da checagem acima, e dentro de pcall: um
    -- nó já destruído lançaria "invalid 'obj' in Node_isVisible" (crash real
    -- registrado pelo cliente em esconder_dialogos.lua:74).
    if janela.visivelok == false then return false end
    if type(janela.isVisible) == 'function' then
        local ok, visivel = pcall(janela.isVisible, janela)
        if ok and visivel == false then return false end
    end
    return true
end

-- Agenda o toque automatico com seguranca (sem isVisible em no destruido).
local function agendarAvanco(janela, marca)
    if require('initial_tutorial').state=='playing' then return end
    if janela[marca] ~= nil then return end
    janela[marca] = true
    fwin:addService({delay = 0.35, callback = function()
        janela[marca] = nil
        if not podeAvancar(janela) then return end
        local ok, erro = pcall(avancar, janela)
        if not ok then nota('avanco ignorado: ' .. tostring(erro)) end
    end})
end

function M.install(class)
    if type(class) ~= 'table' or class.__nr_dialogo_oculto then return end
    local entrada = class.onEnterTransitionFinish
    local toque = class.touchNextMission
    if type(entrada) ~= 'function' or type(toque) ~= 'function' then return end
    class.__nr_dialogo_oculto = true

    -- 1) Oculta a arte assim que a janela termina de montar.
    class.onEnterTransitionFinish = function(self, ...)
        local resultado = { entrada(self, ...) }
        local quantos = esconderArte(self)
        nota('dialogo oculto (raizes=' .. quantos .. ')')
        -- O toque automatico espera um pouco: a janela ainda precisa rodar a
        -- animacao de entrada e registrar os terminais do estado.
        agendarAvanco(self, '__nr_toque_agendado')
        return unpack(resultado)
    end

    -- 2) Cada nova fala reusa a mesma janela (role_dialogue_push + updateChat,
    --    Mission.lua:2426-2428). Reoculta e avanca de novo, para a sequencia
    --    inteira passar sem que nada apareca na tela.
    local atualizar = class.updateChat
    if type(atualizar) == 'function' then
        class.updateChat = function(self, ...)
            local resultado = { atualizar(self, ...) }
            esconderArte(self)
            agendarAvanco(self, '__nr_toque_agendado2')
            return unpack(resultado)
        end
    end
end

return M
