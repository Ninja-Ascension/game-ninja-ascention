-- Contrato: _ED.open_server_time (e os companheiros) existem antes de a Home
-- rodar, e o cálculo de EnvironmentDatas.lua:5261 não estoura mais.
--
-- CAUSA MEDIDA NA EXECUÇÃO AO VIVO (sessão 44): o erro continuava aparecendo
-- porque a versão anterior desta correção esperava `_ED.system_time` do
-- login — e esse campo NUNCA chega. Só parse_return_system_time (:1710) o
-- escreve, e o cliente não envia o comando 12001.
local M = {}

-- A MESMA expressão do acervo (:5261), isolada.
local function diasDesdeAbertura(openDay)
    local day = (tonumber(_ED.system_time)
        - tonumber(_ED.open_server_time) / 1000
        + (os.time() - tonumber(_ED.native_time))) / 86400
    return day, day < openDay
end

function M.run()
    local mod = require('open_server_time')

    local salvo = { _ED.system_time, _ED.native_time, _ED.open_server_time,
                    _ED.time_add_or_sub }

    -- 1) O CENÁRIO REAL: todos os campos nil, como logo após o login.
    _ED.system_time = nil
    _ED.native_time = nil
    _ED.open_server_time = nil
    _ED.time_add_or_sub = nil

    local okAntes = pcall(diasDesdeAbertura, 2)
    print('OPEN_CONTRATO cenário_real_estoura=' .. tostring(not okAntes))
    assert(not okAntes, 'pre-condicao: com tudo nil o calculo deve estourar')

    -- 2) A adaptação preenche e o cálculo passa a funcionar
    local mudou = mod.armar()
    print('OPEN_CONTRATO armar mudou=' .. tostring(mudou)
        .. ' system_time=' .. tostring(_ED.system_time)
        .. ' native_time=' .. tostring(_ED.native_time)
        .. ' open_server_time=' .. tostring(_ED.open_server_time))
    assert(_ED.open_server_time ~= nil, 'open_server_time continua nil')
    assert(_ED.system_time ~= nil, 'system_time continua nil')
    assert(_ED.native_time ~= nil, 'native_time continua nil')

    local okD, day = pcall(diasDesdeAbertura, 2)
    print('OPEN_CONTRATO calculo ok=' .. tostring(okD)
        .. ' dias=' .. tostring(day))
    assert(okD, 'o calculo de :5261 nao pode mais estourar')

    -- 3) servidor recém-aberto => idade 0, não bloqueia por dia
    print('OPEN_CONTRATO idade<1=' .. tostring(day < 1))
    assert(day < 1, 'servidor recem-aberto deveria ter idade ~0 dia')
    print('OPEN_CONTRATO time_add_or_sub=' .. tostring(_ED.time_add_or_sub))

    -- 4) é idempotente e NÃO sobrescreve valor informado pelo servidor
    local antes = _ED.open_server_time
    local mudou2 = mod.armar()
    print('OPEN_CONTRATO idempotente mudou=' .. tostring(mudou2))
    assert(mudou2 == false, 'segunda chamada nao deveria mudar nada')
    assert(_ED.open_server_time == antes, 'valor mudou na segunda chamada')

    local informado = 1600000000000
    _ED.open_server_time = informado
    mod.armar()
    print('OPEN_CONTRATO preserva_servidor=' ..
        tostring(_ED.open_server_time == informado))
    assert(_ED.open_server_time == informado,
        'nao pode sobrescrever o valor que o servidor mandou')

    -- 5) a Home fica protegida (onUpdate envolto)
    local Home = rawget(_G, 'Home')
    if type(Home) == 'table' and type(Home.onUpdate) == 'function' then
        print('OPEN_CONTRATO home_protegida=' ..
            tostring(Home.__nr_tempos_home == true))
    else
        print('OPEN_CONTRATO home_protegida=home_ainda_nao_carregada')
    end

    -- restaura o estado de teste
    _ED.system_time, _ED.native_time, _ED.open_server_time,
        _ED.time_add_or_sub = salvo[1], salvo[2], salvo[3], salvo[4]

    print('OPEN_CONTRATO_PASSED campos de tempo garantidos, :5261 sem estouro')
end

return M
