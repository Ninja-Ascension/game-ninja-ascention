-- port/lua/garantir_begin_load.lua
-- Destrava o carregamento quando a animacao de abertura nao dispara o evento.
--
-- SINTOMA REAL: a tela de carregamento para em 9% (totalNum=5, o valor inicial
-- de FightLoading.lua:8) e o cliente nunca mais fala com o servidor.
-- battle-lifecycle.log mostrava:  loader probe totalNum=5 ... begin=false
--
-- CAUSA: FightLoadingCell:onUpdate (FightLoading.lua:249) faz
--     if self.isBeginLoad == false then return end
-- e `isBeginLoad` so vira true no frame "window_open_over" da animacao
-- utils/donghua_loading.csb (FightLoading.lua:198-199). No ramo do Naruto
-- (linha 206-219) a atribuicao correspondente esta COMENTADA. Se o evento do
-- timeline nao chega, o loader fica parado em 9% indefinidamente.
--
-- Correcao: rede de seguranca por tempo. Se a janela esta viva, visivel e
-- ainda nao comecou a carregar depois de alguns segundos, liga o isBeginLoad.
-- Nao substitui a animacao: apenas garante que o fluxo nao trava.
local M = {}

local ESPERA_PADRAO = 6.0  -- segundos: tempo de sobra para a abertura rodar

local function nota(texto)
    print('HOST_BEGIN_LOAD ' .. texto)
    local f = io.open(cc.FileUtils:getInstance():getWritablePath() .. 'begin-load.log', 'a')
    if f then f:write(os.date('%H:%M:%S') .. ' ' .. texto .. '\n') f:close() end
end

-- True quando o no ainda existe (tocar num no destruido derruba o cliente).
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

function M.install(class)
    if type(class) ~= 'table' then return false end
    if class.__nr_begin_load then return true end
    local entrada = class.onEnterTransitionFinish
    if type(entrada) ~= 'function' then return false end
    class.__nr_begin_load = true

    class.onEnterTransitionFinish = function(self, ...)
        local resultado = { entrada(self, ...) }
        if self.__nr_espera_agendada then return unpack(resultado) end
        self.__nr_espera_agendada = true
        fwin:addService({delay = ESPERA_PADRAO, callback = function()
            if not vivo(self) then return end
            if self.isBeginLoad == true then return end
            -- Ja encerrado/recarregado por outro caminho: nao mexer.
            if self._unload == true then return end
            self.isBeginLoad = true
            nota('isBeginLoad ligado pela rede de seguranca (totalNum='
                .. tostring(self.totalNum) .. ')')
        end})
        return unpack(resultado)
    end
    return true
end

-- A classe nasce quando client.battle.landscape.FightLoading e carregado
-- (FightLoading.lua:1: FightLoadingCell = class(...)), o que acontece DEPOIS
-- do boot. Tentar no boot nao acha nada, por isso tenta de novo a cada frame
-- ate conseguir — o custo enquanto nao existe e um rawget.
local pendente = true
function M.armar()
    if not pendente then return end
    if M.install(rawget(_G, 'FightLoadingCell')) then
        pendente = false
        nota('hook instalado em FightLoadingCell')
    end
end

function M.atualizar()
    M.armar()
end

-- Instala o rearme global uma unica vez.
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
