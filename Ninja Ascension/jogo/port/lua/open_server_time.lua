-- port/lua/open_server_time.lua — PREENCHE _ED.open_server_time COM DADO REAL.
--
-- CAUSA, MEDIDA NA EXECUÇÃO AO VIVO (sessão 44, console do jogo):
--
--   LUA ERROR: EnvironmentDatas.lua:5261: attempt to perform arithmetic on
--              a nil value
--   stack: EnvironmentDatas.lua:5261 funOpenDrawTip
--          Home.lua:7446 onUpdate
--          fwin.lua:725
--
--   :5261 (ramo l_naruto, :5255-5268) faz:
--       local day = (tonumber(_ED.system_time)
--                    - tonumber(_ED.open_server_time)/1000
--                    + (os.time() - tonumber(_ED.native_time))) / 86400
--
--   CORREÇÃO DA MINHA ANÁLISE ANTERIOR (estava errada e foi medida):
--   eu tinha suposto que `_ED.system_time` vinha no login. NÃO VEM.
--   O único lugar que escreve `_ED.system_time` é parse_return_system_time
--   (ProtocolParserCopyExx.lua:1709-1716), que responde ao comando
--   `system_time` (12001) — e o cliente NUNCA o envia (o ponto que o pediria,
--   Menu.lua:2411, está comentado no próprio acervo).
--   O log do boot confirmou: "OPEN_SERVER_TIME sem system_time/native_time;
--   nada a preencher". Ou seja: os DOIS campos podem faltar, não só
--   open_server_time.
--
--   Portanto a adaptação não pode esperar dado que nunca chega. Ela usa a
--   única fonte de tempo verdadeira disponível neste cliente: o relógio
--   local (os.time()), que é exatamente a base que o resto do acervo usa
--   para esses cálculos (:5261 combina os.time() com native_time).
--
-- O QUE É PREENCHIDO E POR QUÊ ESSES VALORES SÃO VERDADEIROS:
--   native_time      = os.time()  -> agora, no relógio desta máquina.
--   system_time      = os.time()  -> sem sincronização com servidor, o
--                      "horário do servidor" para este cliente É o relógio
--                      local; isso torna time_add_or_sub = 0 (sem
--                      deslocamento), que é a verdade deste servidor local.
--   open_server_time = os.time()  -> este servidor local abriu agora; a
--                      idade em dias é 0, o que é verdade.
--
--   NENHUM desses valores é um desbloqueio: com idade 0, `day > 1` é falso,
--   então funOpenDrawTip segue o caminho normal de verificação de
--   nível/scene/npc (:5271-5274) e não abre nada por conta disto.
--
--   Se algum dia o servidor informar os tempos reais (parser 12001 ou um
--   campo no login), este módulo NÃO os sobrescreve: ele só preenche nil.
local M = {}

local function nota(t) print('OPEN_SERVER_TIME ' .. t) end

-- Preenche o que estiver faltando, usando os dados reais disponíveis.
-- Idempotente: chamar várias vezes não muda nada já preenchido.
function M.armar()
    if type(_ED) ~= "table" then return false end
    local agora = os.time()
    local mudou = false

    if _ED.native_time == nil then
        _ED.native_time = agora
        mudou = true
    end
    -- system_time só existe com o comando 12001; sem ele, o relógio local é a
    -- base coerente.
    if _ED.system_time == nil then
        _ED.system_time = agora
        mudou = true
    end
    if _ED.open_server_time == nil then
        -- Abertura = o instante desta primeira sincronização. Como o relógio
        -- do servidor foi fixado no mesmo instante, a diferença é 0.
        local base = tonumber(_ED.system_time) or agora
        _ED.open_server_time = base * 1000    -- ms, unidade de :5261
        mudou = true
    end
    if _ED.time_add_or_sub == nil then
        local st = tonumber(_ED.system_time)
        if st ~= nil then
            _ED.time_add_or_sub = st - (tonumber(_ED.native_time) or agora)
            mudou = true
        end
    end

    if mudou then
        nota(string.format('preenchido system_time=%s native_time=%s '
            .. 'open_server_time=%s', tostring(_ED.system_time),
            tostring(_ED.native_time), tostring(_ED.open_server_time)))
    end
    return mudou
end

-- Roda de novo quando o login trouxer tempos novos (relogin/recarga).
-- Não depende de um parser específico existir: instala no próprio
-- app.load, que é a via por onde Mission/LoginLoading entram.
function M.instalarNoLogin()
    if package.__nr_open_server_time then return end
    package.__nr_open_server_time = true
    local load = app.load
    if type(load) ~= "function" then return end
    app.load = function(nome, ...)
        local r = load(nome, ...)
        -- Depois de qualquer carga relevante, garante os campos de tempo.
        M.armar()
        -- A Home pode ter acabado de carregar: protege o onUpdate dela.
        if tostring(nome):match('home%.Home$') then M.armarHome() end
        return r
    end
    nota("reforco instalado em app.load")
end

-- Reforço específico para a janela que estoura: antes do primeiro onUpdate
-- da Home, os campos precisam existir.
function M.armarHome()
    local Home = rawget(_G, 'Home')
    if type(Home) ~= 'table' or Home.__nr_tempos_home then return end
    local original = Home.onUpdate
    if type(original) ~= 'function' then return end
    Home.__nr_tempos_home = true
    Home.onUpdate = function(self, dt)
        M.armar()
        return original(self, dt)
    end
    nota("Home.onUpdate protegido")
end

return M
