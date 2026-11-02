-- port/lua/account_ui.lua — ADAPTADOR DA TELA DE CONTA (Entrar / Criar conta).
--
-- PROBLEMA (medido no acervo + console do usuário):
--   * a janela de conta do próprio jogo (AccountSysManager, login/register/
--     register_prompt_1.csb) abre em login.lua:1727-1774 dentro de
--     Login:onEnterTransitionFinish. Essa função RODA neste port (é ela que
--     monta o fundo e o START), então o que falha é um passo de dentro do
--     bloco: AccountSysFloatingWindow:onEnterTransitionFinish usa
--     cc.Director:getInstance():getOpenGLView():getFrameSize()
--     (AccountSysFloatingWindow.lua:213), e no Axmol getOpenGLView é um shim
--     para getRenderView, que NÃO tem getFrameSize.
--   * enquanto o popup de idioma está aberto (modal, tela cheia) nada mais
--     recebe toque.
--
-- O que este adaptador faz — nada de recriar a UI do zero:
--   1. completa o shim do engine: getFrameSize/getVisibleSize no view;
--   2. instala os globais de pré-requisito que faltarem (m_account_sys_*);
--   3. depois que a janela Login existe, abre UMA vez a janela de conta do
--      próprio acervo (account_sys_manager_open), que é a tela com
--      Button_login / Button_register e os TextField_1/2 e 3/4/4_0;
--   4. NÃO faz login automático de convidado.
-- Só ativa com a flag local_sdk_adapter do app.config (jogo adaptado).
local M = {}

local tentativas = 0
local TENTATIVAS_MAX = 400
local aberto = false
-- Fechado pelo jogador (botão Voltar): só reabre quando o ACERVO pedir
-- (GAME START sem conta autenticada, login.lua:407-414), nunca pelo relógio
-- do vigia.
local fechadoPeloJogador = false

local function nota(txt)
    print("HOST_ACCOUNT_UI " .. txt)
end

-- 1) shim do view: métodos de tamanho que o acervo chama.
local function completarView()
    local ok, view = pcall(function()
        return cc.Director:getInstance():getOpenGLView()
    end)
    if not ok or view == nil then
        return false
    end
    if view.getFrameSize == nil then
        -- RenderView não expõe getFrameSize; a janela do jogo é a mesma
        -- coisa que o tamanho desenhável.
        view.getFrameSize = function()
            return cc.Director:getInstance():getWinSize()
        end
    end
    if view.getVisibleSize == nil then
        view.getVisibleSize = function()
            return cc.Director:getInstance():getWinSize()
        end
    end
    if view.getVisibleOrigin == nil then
        view.getVisibleOrigin = function()
            return cc.p(0, 0)
        end
    end
    return true
end

local function garantirGlobais()
    if m_account_sys_user_name == nil then m_account_sys_user_name = "" end
    if m_account_sys_user_password == nil then m_account_sys_user_password = "" end
    if m_account_sys_floating_switch == nil then m_account_sys_floating_switch = false end
    if m_login_search_user == nil then m_login_search_user = false end
end

local function desativarLoginAutomatico()
    -- Login automatico do acervo (AccountSysManager:onUpdataDraw 278-308):
    -- com account_automatic_login == "2" (CheckBox_1 marcado pelo jogador) e
    -- uma conta lembrada em name_local, o jogo entra sozinho usando o token
    -- salvo (tok_local, "@tk1:"). Antes este adaptador gravava "1" a cada
    -- abertura e a caixa nunca ficava marcada; agora a escolha do jogador e
    -- respeitada. Sem a caixa marcada (padrao) o jogo continua comecando na
    -- tela de conta. Token vencido -> servidor responde -68, o acervo esquece
    -- o token e mostra a janela de novo.
end

local function abrirFlutuante()
    -- Janela flutuante de conta do acervo (login.lua:1730-1734): mostra a
    -- conta conectada (senha sempre em asteriscos) e tem o terminal de
    -- sair/trocar conta (account_sys_floating_switch).
    if fwin:find("AccountSysFloatingWindowClass") ~= nil then
        return
    end
    local ok, err = pcall(function()
        app.load("client.login.Manager.AccountSysFloatingWindow")
        local janela = AccountSysFloatingWindow:new()
        fwin:open(janela, fwin._taskbar)
    end)
    if not ok then
        nota("botao de conta flutuante falhou: " .. tostring(err))
    end
end

local function instalarTravaDeEnviosDuplicados()
    -- O próprio NetworkManager:register já recusa um comando repetido
    -- enquanto ele está na fila (NetworkManager.lua:127-130), mas o pedido
    -- SAI da fila assim que é enviado: dois toques rápidos em "Entrar"
    -- mandam dois 9002. Aqui os dois comandos de conta são embrulhados com
    -- a assinatura real (NetworkManager.lua:122); um pedido em voo bloqueia
    -- o seguinte e o callback libera a trava quando a resposta chega.
    if type(NetworkManager) ~= "table" or type(NetworkManager.register) ~= "function" then
        return false
    end
    if package.__nr_trava_contas then return true end
    package.__nr_trava_contas = true
    local original = NetworkManager.register
    local emVoo = {}
    NetworkManager.register = function(self, _command, _url, _mode, _nType, _node,
                                       _handler, _showWaitView, _timeOut, _unreconnect,
                                       _str, _pos)
        if _command == 9001 or _command == 9002 then
            if emVoo[_command] then
                nota("pedido duplicado descartado (codigo " .. tostring(_command) .. ")")
                return nil
            end
            emVoo[_command] = true
            local function liberar()
                emVoo[_command] = nil
            end
            local handler = _handler
            if handler == nil then
                -- Sem callback (falha de rede sem retorno): libera em 2 s
                -- para não deixar o formulário travado para sempre.
                local sched = cc.Director:getInstance():getScheduler()
                local id
                id = sched:scheduleScriptFunc(function()
                    liberar()
                    sched:unscheduleScriptEntry(id)
                end, 2.0, false)
            else
                _handler = function(...)
                    liberar()
                    return handler(...)
                end
            end
        end
        return original(self, _command, _url, _mode, _nType, _node, _handler,
                        _showWaitView, _timeOut, _unreconnect, _str, _pos)
    end
    nota("trava de envios duplicados ativa (9001/9002)")
    return true
end

local function mascararSenhasDoCadastro()
    -- No acervo, os campos de senha do cadastro são ccui.EditBox criados por
    -- draw:addEditBoxEx (display.lua:867/903) por cima dos TextField_4 e
    -- TextField_4_0. Para OperatorName "t4" o original passa
    -- KEYBOARD_RETURNTYPE_DONE no parâmetro da bandeira
    -- (AccountSysRegister.lua:249-254), então o EditBox sai como
    -- EDITBOX_INPUT_MODE_SINGLELINE (6) e as senhas apareciam em claro.
    -- EDITBOX_INPUT_FLAG_PASSWORD = 0 é o valor certo no Axmol
    -- (EditBox::InputFlag::PASSWORD é o primeiro do enum, UIEditBox.h:171).
    -- Aqui procuramos o EditBox de cada campo e reaplicamos a bandeira.
    local janela = fwin:find("AccountSysRegisterClass")
    if janela == nil or janela.roots == nil or janela.roots[1] == nil then
        return
    end
    local root = janela.roots[1]
    for _, nome in ipairs({ "TextField_4", "TextField_4_0" }) do
        local campo = ccui.Helper:seekWidgetByName(root, nome)
        if campo ~= nil and campo.__nr_mascarado ~= true then
            local okPos, pCampo = pcall(function() return cc.p(campo:getPosition()) end)
            local okKids, filhos = pcall(function() return root:getChildren() end)
            if okPos and okKids and filhos ~= nil then
                for _, filho in ipairs(filhos) do
                    local okTipo, tipo = pcall(function() return tolua.type(filho) end)
                    if okTipo and tipo == "ccui.EditBox" then
                        local okP2, p2 = pcall(function() return filho:getPosition() end)
                        if okP2 and p2 ~= nil
                            and math.abs(p2.x - pCampo.x) < 2
                            and math.abs(p2.y - pCampo.y) < 40 then
                            local ok = pcall(function()
                                filho:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
                            end)
                            if ok then
                                campo.__nr_mascarado = true
                                nota("senha mascarada em " .. nome)
                            end
                        end
                    end
                end
            end
        end
    end
end

local guardarReaberturaAposLogin
function guardarReaberturaAposLogin()
    -- login.lua:1736-1752 abre a janela de conta E manda search_user_platform;
    -- a resposta abre a janela de novo (account_sys_manager_open). No acervo
    -- ela chegava com a janela ainda aberta (vira so um "update"). Aqui o
    -- login automatico (onUpdataDraw) responde ANTES, fecha a janela, e a
    -- resposta atrasada reabria uma janela nova pedindo senha. Depois de um
    -- login bom (login_vali_register destravado pelo acervo) essa reabertura
    -- e ignorada. Trocar de conta cria um Login novo, que trava o START de
    -- novo (login.lua:1729), entao a janela volta a abrir normalmente.
    if state_machine == nil or state_machine.add == nil then return false end
    -- Instala no momento em que AccountSysManager.lua registra o terminal
    -- (login.lua abre a janela antes do primeiro tick do vigia).
    if not state_machine.__nr_guarda_add then
        state_machine.__nr_guarda_add = true
        local add = state_machine.add
        state_machine.add = function(term, ...)
            local r = add(term, ...)
            if type(term) == "table" and term._name == "account_sys_manager_open" then
                guardarReaberturaAposLogin()
            end
            return r
        end
    end
    local terminal = state_machine._terminals and state_machine._terminals["account_sys_manager_open"]
    if terminal == nil or terminal.__nr_guarda then return terminal ~= nil end
    local original = terminal._invoke
    terminal.__nr_guarda = true
    terminal._invoke = function(term, instance, params)
        local vali = state_machine.find("login_vali_register")
        if fwin:find("AccountSysManagerClass") == nil and vali ~= nil and vali._lock ~= true
            and m_account_sys_floating_switch ~= true then
            nota("janela de conta nao reaberta: conta ja autenticada (login automatico)")
            return true
        end
        return original(term, instance, params)
    end
    return true
end

local function abrirJanelaDeConta()
    local loginWin = fwin:find("LoginClass")
    if loginWin == nil or loginWin:isVisible() ~= true then
        return false
    end
    -- Não abre com o popup de idioma na frente (ele é modal).
    if fwin:find("ChooseLanguagePopupClass") ~= nil then
        return false
    end
    if fwin:find("AccountSysManagerClass") ~= nil then
        aberto = true
        -- Pode ter sido o próprio acervo reabrindo (GAME START com
        -- login_vali_register travado, login.lua:407-414): nesse caso a
        -- janela é do jogador de novo, e o vigia volta a considerá-la aberta.
        if fechadoPeloJogador then
            fechadoPeloJogador = false
            nota("janela de conta reaberta pelo acervo (GAME START)")
        end
        return true
    end
    -- Já autenticado nesta sessão? Aí o START é quem manda; não reabre a
    -- janela por cima do jogo (o jogador fecha/entra de novo pelo botão).
    if m_sUin ~= nil and m_sUin ~= "" and fwin:find("AccountSysRegisterClass") == nil then
        aberto = true
        return true
    end
    -- O jogador fechou com Voltar e ainda não pediu nada: NÃO reabrir.
    -- Antes o vigia reabria no tick seguinte, o que fazia o Voltar parecer
    -- quebrado. Quem reabre é o acervo, no GAME START (login.lua:407-414).
    if fechadoPeloJogador and not podeReabrir() then
        return false
    end
    -- SEM conta autenticada: trava o START, como o próprio acervo faz em
    -- login.lua:1729. Sem este lock o GAME START entraria no jogo sem
    -- autenticação nenhuma (login_check_first:407-414 só reabre a janela
    -- porque o terminal está travado). O destrave vem do próprio acervo
    -- quando o login dá certo (AccountSysManager.lua:127 / Register:138).
    if state_machine ~= nil and state_machine.find ~= nil then
        local vali = state_machine.find("login_vali_register")
        if vali ~= nil and vali._lock ~= true then
            state_machine.lock("login_vali_register")
            nota("login_vali_register travado (START exige conta)")
        end
    end
    local ok, err = pcall(function()
        app.load("client.login.Manager.AccountSysManager")
        app.load("client.login.Manager.AccountSysRegister")
        guardarReaberturaAposLogin()
        state_machine.excute("account_sys_manager_open", 0, "account_sys_manager_open.")
    end)
    if not ok then
        nota("falha ao abrir a janela de conta: " .. tostring(err))
        return false
    end
    aberto = true
    nota("janela de conta aberta (Entrar / Criar conta)")
    abrirFlutuante()
    return true
end

local function fechouJanela()
    return fwin:find("AccountSysManagerClass") == nil
        and fwin:find("AccountSysRegisterClass") == nil
end

-- Reabrir depois de o jogador fechar com Voltar: quem decide é o ACERVO.
-- Em login.lua:407-414 o GAME START, com login_vali_register travado e sem
-- janela aberta, chama account_sys_manager_open por conta propria — é a
-- reabertura previsível que o jogador espera. O vigia daqui NÃO pode
-- competir com isso (era o que fazia o Voltar parecer quebrado: a janela
-- voltava no tick de 1 s, antes de qualquer clique).
local function podeReabrir()
    return false
end

local function tentar()
    if not completarView() then return false end
    -- O alias de nomes de widget (boot_map 0c) pode nao ter conseguido
    -- instalar no boot, quando ccui ainda nao existia. Aqui as classes de UI
    -- ja estao carregadas: tenta de novo.
    if package.__nr_alias_widgets_armar ~= nil then
        pcall(package.__nr_alias_widgets_armar)
    end
    garantirGlobais()
    desativarLoginAutomatico()
    guardarReaberturaAposLogin()
    instalarTravaDeEnviosDuplicados()
    mascararSenhasDoCadastro()
    -- Se o jogador FECHOU a janela (Voltar), respeitar: não reabrir no tick
    -- seguinte (era o que fazia o botão Voltar parecer quebrado). A
    -- reabertura possível vem do acervo, no GAME START sem conta.
    if aberto and fechouJanela() then
        aberto = false
        fechadoPeloJogador = true
        nota("janela de conta fechada; so reabre se o jogador pedir (GAME START)")
    end
    return abrirJanelaDeConta()
end

-- 5) Campos de texto (usuario/senha). AccountSysManager.lua:423-445 entrega o
-- toque dos paineis Panel_Username/Panel_Password ao EditBox chamando
-- edit:touchDownAction(...), metodo do cocos2d-x antigo que abria o teclado.
-- O Axmol nao tem esse metodo (o acervo testa "~= nil" e o clique morria em
-- silencio); o equivalente publico e EditBox:openKeyboard().
function M.pontesDoEditBox()
    local classe = rawget(_G, "ccui") and ccui.EditBox
    if classe == nil or classe.touchDownAction ~= nil or classe.openKeyboard == nil then return end
    classe.touchDownAction = function(self, _, eventType)
        if eventType == nil or eventType == ccui.TouchEventType.ended then
            self:openKeyboard()
        end
    end
    nota("EditBox.touchDownAction -> openKeyboard (campos de usuario/senha)")
end

-- Android: only the auto-login reopen guard (no EditBox/desktop shims).
function M.guardaLoginAutomatico()
    return guardarReaberturaAposLogin()
end

function M.armar()
    if app == nil or app.configJson == nil or app.configJson.local_sdk_adapter ~= true then
        return
    end
    pcall(M.pontesDoEditBox)
    -- Digitacao dentro do jogo (cursor "|") em vez da caixa nativa do Windows.
    pcall(function() require("editbox_inline").armar() end)
    pcall(guardarReaberturaAposLogin)
    if package.__nr_account_ui then return end
    package.__nr_account_ui = true
    -- Vigia leve (1 s) e permanente: abre a janela de conta quando o Login
    -- existe, mascara as senhas do cadastro quando ele abre e reabre a
    -- janela depois de sair da conta. Enquanto o jogo já está logado, cada
    -- tick só consulta fwin:find.
    local sched = cc.Director:getInstance():getScheduler()
    sched:scheduleScriptFunc(function()
        local ok = pcall(tentar)
        if not ok then
            return
        end
        -- Relatório único do registro de terminais DEPOIS que o Login foi
        -- construído (o dump do boot roda antes do ctor e sempre mostra só os
        -- 16 do framework). É o que prova se os terminais do login existem.
        if not package.__nr_terminais_depois then
            local sm = rawget(_G, "state_machine")
            if sm ~= nil and type(sm._terminals) == "table"
                and sm._terminals["login_vali_register"] ~= nil then
                package.__nr_terminais_depois = true
                local nomes = {}
                for k in pairs(sm._terminals) do nomes[#nomes + 1] = tostring(k) end
                table.sort(nomes)
                print("HOST_START_TRACE terminais DEPOIS do Login (" .. #nomes .. "): "
                    .. table.concat(nomes, ","))
                print("HOST_START_TRACE login_vali_register EXISTE -> START pode funcionar")
            end
        end
        if not aberto then
            tentativas = tentativas + 1
            if tentativas == TENTATIVAS_MAX then
                nota("timeout: a janela LoginClass nao ficou visivel")
            end
        end
    end, 1.0, false)
end

return M
