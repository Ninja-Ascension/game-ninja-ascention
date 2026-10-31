-- port/lua/loader_tutorial.lua
-- Tira o jogador do loader de batalha quando NAO ha batalha a executar.
--
-- A CADEIA (comprovada no log e no codigo):
--   LoginLoading.lua:212  -- conta no tutorial (grade 1, experiencia 0):
--                             fecha o carregamento normal e abre o loader de batalha
--   FightLoading.lua:8    -- totalNum comeca em 5  (a tela mostra 9%)
--   FightLoading.lua:249  -- onUpdate sai cedo enquanto isBeginLoad == false
--   FightLoading.lua:198  -- isBeginLoad so vira true no frame "window_open_over"
--                             de utils/donghua_loading.csb, que nao dispara
--   FightLoading.lua:255  -- ao chegar em 100 chama executeMission()
--   FightLoading.lua:303-313 -- executeMission faz NADA se missionIsOver()==false
--
-- Resultado: a conta em tutorial reinicia depois de um travamento, cai nesse
-- loader, o loader espera uma batalha que aquela etapa nao tem, e fica presa
-- em 9% — sem mandar mais nada ao servidor. Conta que ja saiu do tutorial
-- (grade>1) nao entra nesse ramo, por isso o bug aparecia so no tutorial.
--
-- Correcao: se o loader ficou parado e nao ha missao de batalha a executar,
-- segue para a Home pelo MESMO caminho do jogo (LoginLoading:loadingSuccess),
-- em vez de ficar esperando um evento que nunca vem. Quando ha batalha, nada
-- muda: a batalha e pedida normalmente.
local M = {}

local ESPERA = 8.0  -- segundos parado antes de agir

local function nota(texto)
    print('HOST_LOADER_TUTORIAL ' .. texto)
    local f = io.open(cc.FileUtils:getInstance():getWritablePath() .. 'loader-tutorial.log', 'a')
    if f then f:write(os.date('%H:%M:%S') .. ' ' .. texto .. '\n') f:close() end
end

local function vivo(no)
    if no == nil then return false end
    if type(fwin) == 'table' and type(fwin._list) == 'table' then
        for _, v in pairs(fwin._list) do
            if v == no then return true end
        end
        return false
    end
    return true
end

local function temBatalha(loader)
    -- missionIsOver() do jogo diz se a etapa atual tem missao a executar.
    local ok, resultado = pcall(missionIsOver)
    if ok then return resultado == true end
    return false
end

local function seguirParaHome(loader, motivo)
    loader.__nr_seguiu_home = true
    loader._unload = true
    loader._excute_mission = false
    nota('seguindo para a Home (' .. motivo .. ') totalNum=' .. tostring(loader.totalNum))
    -- Mesma sequencia de LoginLoading:loadingSuccess (LoginLoading.lua:428-435),
    -- sem tocar em fightWindow, que nunca foi criado neste caminho.
    app.load('client.home.Menu')
    local menu = fwin:find('MenuClass')
    if menu == nil then
        local ok, erro = pcall(function() fwin:open(Menu:new(), fwin._taskbar) end)
        if not ok then
            nota('falha ao abrir Menu: ' .. tostring(erro))
        end
    end
    -- Leva a Home ao estado de missao, que e o que o tutorial espera.
    pcall(function() state_machine.excute('menu_window_open_mission', 0, 0) end)
    if vivo(loader) then fwin:close(loader) end
    local login = fwin:find('LoginLoadingClass')
    if login and vivo(login) then fwin:close(login) end
    nota('Home aberta; menu=' .. tostring(fwin:find('MenuClass') ~= nil))
end

function M.install(class)
    if type(class) ~= 'table' or class.__nr_loader_tutorial then return false end
    class.__nr_loader_tutorial = true

    local original = class.onUpdate
    if type(original) ~= 'function' then return false end

    class.onUpdate = function(self, dt, ...)
        local resultado = { original(self, dt, ...) }

        -- Conta fora do tutorial: o fluxo original cuida de tudo.
        local user = _ED and _ED.user_info
        if user == nil then return unpack(resultado) end
        local grade = tonumber(user.user_grade) or 1
        local exp = tonumber(user.user_experience) or 0
        if not (grade == 1 and exp == 0) then return unpack(resultado) end
        if self.__nr_seguiu_home or self._unload == true then return unpack(resultado) end

        -- Ainda nao comecou a carregar: o loader esta parado em 5/100.
        if self.isBeginLoad ~= true then
            self.__nr_parado_desde = self.__nr_parado_desde or os.time()
            if os.time() - self.__nr_parado_desde >= ESPERA then
                if not temBatalha(self) then
                    seguirParaHome(self, 'loader parado e sem missao de batalha')
                end
            end
            return unpack(resultado)
        end
        self.__nr_parado_desde = nil

        -- Chegou ao fim do carregamento e nao havia batalha a executar.
        if self.totalNum >= 100 and self._excute_mission == false then
            if not temBatalha(self) then
                seguirParaHome(self, 'carregamento concluido sem batalha')
            end
        end
        return unpack(resultado)
    end
    return true
end

-- FightLoadingCell nasce quando o modulo e carregado (FightLoading.lua:1).
local pendente = true
function M.armar()
    if not pendente then return end
    if M.install(rawget(_G, 'FightLoadingCell')) then
        pendente = false
        nota('hook instalado em FightLoadingCell')
    end
end

function M.ligar()
    if M.__ligado then return end
    M.__ligado = true
    local original = fwin.updateLua
    if type(original) == 'function' then
        fwin.updateLua = function(self, ...)
            local resultado = { original(self, ...) }
            M.armar()
            return unpack(resultado)
        end
    end
    M.armar()
end

return M
