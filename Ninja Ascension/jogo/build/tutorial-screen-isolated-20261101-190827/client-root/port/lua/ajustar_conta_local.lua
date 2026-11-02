-- port/lua/ajustar_conta_local.lua
-- Aponta a conta salva no cliente para a conta local correta e desliga o
-- pedido de senha.
--
-- Por que: o cliente guarda em UserDefault "name_local"/"pass_local" a conta
-- da ultima sessao. Tentativas anteriores de login gravaram ali contas
-- criadas por engano (59/60), que foram apagadas do banco. Com o login
-- automatico ligado, o cliente tentaria entrar com uma conta inexistente.
--
-- Executado uma vez pelo jogo com NR_AJUSTAR_CONTA=1 e encerra.
local CAMINHO = cc.FileUtils:getInstance():getWritablePath() .. 'ajustar-conta.log'
local arquivo = io.open(CAMINHO, 'w')
local function relatar(texto)
    if arquivo then arquivo:write(texto .. '\n') arquivo:flush() end
    print(texto)
end

-- Conta local valida: a unica que existe no banco do servidor.
local CONTA = 'gfwp96380418'
local SENHA = 'ninja123'

local ok, erro = pcall(function()
    local ud = cc.UserDefault:getInstance()
    relatar('antes: name_local=' .. tostring(ud:getStringForKey('name_local', '')))
    relatar('antes: plataforma=' .. tostring(ud:getStringForKey('platform_account_name', '')))

    ud:setStringForKey('name_local', CONTA)
    ud:setStringForKey('pass_local', SENHA)
    -- O cliente usa platform_account_name/id em varios pontos do fluxo.
    ud:setStringForKey('platform_account_name', CONTA)
    ud:setStringForKey('platform_account_Automatic_login', '1')
    ud:flush()

    local lido_nome = ud:getStringForKey('name_local', '')
    local lido_senha = ud:getStringForKey('pass_local', '')
    local lido_auto  = ud:getStringForKey('platform_account_Automatic_login', '')
    relatar('depois: name_local=' .. tostring(lido_nome))
    relatar('depois: senha presente=' .. tostring(lido_senha ~= '' and lido_senha ~= nil))
    relatar('depois: automatico=' .. tostring(lido_auto))
    if lido_nome ~= CONTA then error('name_local nao gravou') end
    if lido_auto ~= '1' then error('automatico nao gravou') end
end)

relatar(ok and 'CONTA_AJUSTADA' or ('FALHOU: ' .. tostring(erro)))
if arquivo then arquivo:flush() arquivo:close() arquivo = nil end
os.exit(ok and 0 or 1)
