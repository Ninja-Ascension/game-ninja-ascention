-- port/lua/session_url.lua — chave da sessao em cada pedido HTTP.
--
-- O protocolo original so identifica o jogador pelo user_id no corpo, que
-- nao e segredo. O servidor (port/server/local_server.py, MODO_PUBLICO) exige
-- a chave emitida no login. O proprio jogo ja guarda essa chave em
-- userLoginToken (parser 327, ProtocolParserCopy new_platform_user_login_information);
-- aqui ela so e anexada ao endereco como ?s=<token>, no momento do envio.
-- Nada no corpo do protocolo muda; sem chave (antes do login) o pedido segue
-- igual ao original.
local M = {}

local function semChave(url)
    local base = url:gsub('([?&])s=[A-Za-z0-9_%-]*&?', '%1'):gsub('[?&]$', '')
    return base
end

function M.endereco(url, token)
    if type(url) ~= 'string' then return url end
    local base = semChave(url)
    if type(token) ~= 'string' or not token:match('^[A-Za-z0-9_%-]+$') then return base end
    return base .. (base:find('?', 1, true) and '&' or '?') .. 's=' .. token
end

function M.install()
    if not NetworkAdaptor or not NetworkAdaptor.send or NetworkAdaptor.__nr_session_url then return end
    NetworkAdaptor.__nr_session_url = true
    local original = NetworkAdaptor.send
    NetworkAdaptor.send = function(data, ...)
        local modes = NetworkAdaptor.mode
        if type(data) == 'table' and (data.mode == nil or (modes and data.mode == modes.HTTP)) then
            data.url = M.endereco(data.url, rawget(_G, 'userLoginToken'))
        end
        return original(data, ...)
    end
end

-- Instala agora se o modulo de rede ja existe e de novo sempre que o jogo
-- (re)carregar frameworks.network.NetworkAdaptor via app.load.
function M.arm()
    M.install()
    if app and app.load and not app.__nr_session_url_load then
        app.__nr_session_url_load = true
        local load = app.load
        app.load = function(path, ...)
            local result = load(path, ...)
            if path == 'frameworks.network.NetworkAdaptor' then M.install() end
            return result
        end
    end
end

return M
