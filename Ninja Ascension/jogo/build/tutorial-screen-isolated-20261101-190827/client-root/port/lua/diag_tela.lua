-- port/lua/diag_tela.lua — DIAGNÓSTICO SOMENTE LEITURA da tela atual.
--
-- Por que existe: validar visualmente o login de conta salva (menu sem fundo
-- de carga, fala clicável, sem erro/espera circular) exige saber O QUE está
-- aberto. Capturar PNG não basta quando quem lê o log não vê imagens: aqui o
-- jogo despeja, como texto, a pilha real de janelas do fwin, o progresso dos
-- carregadores e os campos que o pedido nomeia (classe/pai dos carregadores,
-- totalNum, _unload, isBeginLoad, MenuClass, RoleDialogueClass).
--
-- REGRAS DURAS (nada aqui pode mudar o fluxo do jogo):
--   * não cria, fecha nem move janelas;
--   * não mexe em progresso, tutorial nem protocolo;
--   * só roda quando NR_DIAG_TELA=1 no ambiente (lançador normal não ativa);
--   * falha de widget (tolua.isnull, método ausente) vira texto, nunca exceção.
local M = {}

local ARQUIVO = 'diag-tela.log'
local INSTALADO = false

local function agora()
    return os.date('%H:%M:%S')
end

local function escrever(linha)
    local caminho = cc.FileUtils:getInstance():getWritablePath() .. ARQUIVO
    local arquivo = io.open(caminho, 'a')
    if arquivo then
        arquivo:write(linha .. '\n')
        arquivo:close()
    end
end

-- Nome de classe de um nó do fwin (tolua.isnull é barato e seguro).
local function classeDe(no)
    if no == nil then return 'nil' end
    if tolua and tolua.isnull and tolua.isnull(no) then return 'DESTRUIDO' end
    local ok, nome = pcall(function() return no:getDescription() end)
    if ok and nome then return tostring(nome) end
    return type(no)
end

-- Lista as janelas vivas por camada do fwin, na ordem usada pelo próprio
-- fwin (fwin.lua: _view é onde o menu abre, _taskbar o HUD do menu).
local CAMADAS = {
    '_background', '_frameview', '_view', '_dview', '_viewdialog', '_taskbar',
    '_ui', '_windows', '_dialog', '_notification', '_screen', '_system',
    '_display_log',
}

local function despejarJanelas()
    local partes = {}
    for _, camada in ipairs(CAMADAS) do
        local container = fwin[camada]
        if container ~= nil and not (tolua.isnull and tolua.isnull(container)) then
            local ok, filhos = pcall(function() return container:getChildren() end)
            if ok and filhos ~= nil then
                for _, filho in ipairs(filhos) do
                    if not (tolua.isnull and tolua.isnull(filho)) then
                        partes[#partes + 1] = camada .. '=' .. classeDe(filho)
                    end
                end
            end
        end
    end
    if #partes == 0 then return 'vazio' end
    return table.concat(partes, ' | ')
end

-- Estado do carregador conforme os campos citados no pedido de continuação.
local function estadoCarregador(rotulo, no)
    if no == nil then return rotulo .. '=nil' end
    if tolua and tolua.isnull and tolua.isnull(no) then return rotulo .. '=DESTRUIDO' end
    local campos = {}
    local function ler(nome, chave)
        local ok, valor = pcall(function() return no[nome] end)
        campos[#campos + 1] = chave .. '=' .. ((ok and tostring(valor)) or '?')
    end
    ler('totalNum', 'totalNum')
    ler('_unload', '_unload')
    ler('isBeginLoad', 'isBeginLoad')
    ler('LoginLoading', 'filhoLoginLoading')
    campos[#campos + 1] = 'vis=' .. tostring((pcall(function() return no:isVisible() end)))
    local pai = nil
    pcall(function() pai = no:getParent() end)
    campos[#campos + 1] = 'pai=' .. classeDe(pai)
    return rotulo .. '={' .. table.concat(campos, ' ') .. '}'
end

local function usuarioResumo()
    local u = _ED and _ED.user_info
    if not u then return 'user_info=nil' end
    return ('user_id=%s grade=%s exp=%s silver=%s'):format(
        tostring(u.user_id), tostring(u.user_grade),
        tostring(u.user_experience), tostring(u.user_silver))
end

function M.despejar(motivo)
    local partes = {
        agora() .. ' DIAG_TELA ' .. tostring(motivo),
        '  janelas: ' .. despejarJanelas(),
        '  carregadorNativo: ' .. estadoCarregador('FightLoadingCell', fwin:find('FightLoadingCellClass')),
        '  carregadorLogin: ' .. estadoCarregador('LoginLoading', fwin:find('LoginLoadingClass')),
        '  MenuClass=' .. tostring(fwin:find('MenuClass') ~= nil),
        '  RoleDialogueClass=' .. tostring(fwin:find('RoleDialogueClass') ~= nil),
        '  MissionClass=' .. tostring(fwin:find('MissionClass') ~= nil),
        '  ' .. usuarioResumo(),
    }
    escrever(table.concat(partes, '\n'))
    for _, linha in ipairs(partes) do print('DIAG_TELA ' .. linha) end
end

function M.armar()
    if INSTALADO then return end
    INSTALADO = true
    escrever(agora() .. ' DIAG_TELA armar (somente leitura)')

    -- 1) Toda troca de janela do fwin registra a pilha depois da troca.
    for _, metodo in ipairs({'open', 'close', 'show', 'hide'}) do
        local original = fwin[metodo]
        if type(original) == 'function' then
            fwin[metodo] = function(self, ...)
                local resultado = { original(self, ...) }
                local ok, erro = pcall(function()
                    M.despejar('fwin.' .. metodo .. ' ' .. classeDe((...)))
                end)
                if not ok then escrever(agora() .. ' DIAG_TELA falha em ' .. metodo .. ': ' .. tostring(erro)) end
                return unpack(resultado)
            end
        end
    end

    -- 2) Passo do carregador: registra só quando o totalNum muda, para o log
    --    contar a progressão (e provar onde ela para).
    local LoginLoading = rawget(_G, 'LoginLoading')
    if type(LoginLoading) == 'table' and type(LoginLoading.checkLoginLoading) == 'function' then
        local original = LoginLoading.checkLoginLoading
        LoginLoading.checkLoginLoading = function(self, baseWindow, loginIn, ...)
            local antes = self.totalNum
            local resultado = { pcall(original, self, baseWindow, loginIn, ...) }
            if not resultado[1] then
                escrever(agora() .. ' DIAG_TELA ERRO no passo do carregador: ' .. tostring(resultado[2]))
                pcall(function() M.despejar('erro no passo') end)
                error(resultado[2], 0)
            end
            if self.totalNum ~= antes then
                escrever(agora() .. (' DIAG_TELA progresso %s->%s loginIn=%s dono=%s'):format(
                    tostring(antes), tostring(self.totalNum), tostring(loginIn),
                    tostring(baseWindow ~= nil and baseWindow.LoginLoading == self)))
            end
            return unpack(resultado, 2)
        end
    end

    -- 3) Um despejo a cada 5 s: mostra o que está aberto quando nada mais
    --    acontece (é o caso de "tela travada"). O pulso usa o fwin._services,
    --    que o próprio fwin consome em updateLua — aqui ele só é observado,
    --    nunca consumido, e o callback se reagenda sozinho.
    local pulso = function()
        pcall(function() M.despejar('periodico') end)
        pcall(function() fwin:addService({delay = 5, callback = pulso}) end)
    end
    pcall(function() fwin:addService({delay = 5, callback = pulso}) end)
    M.despejar('armado')
end

return M
