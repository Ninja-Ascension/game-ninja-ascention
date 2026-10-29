-- port/lua/limpar_conta_local.lua
-- Limpa a conta salva no cliente para o registro/cadastro aparecer do zero.
--
-- Por que: UserDefault guarda name_local / pass_local / platform_account_*
-- da ultima sessao. Com o banco zerado, esses valores apontam para contas
-- que nao existem mais; o cliente tentaria entrar, levaria recusa e voltaria
-- para a tela de conta. Limpar faz o fluxo comecar limpo.
--
-- Executado uma vez pelo jogo com NR_LIMPAR_CONTA=1 e encerra.
local CAMINHO = cc.FileUtils:getInstance():getWritablePath() .. 'limpar-conta.log'
local arquivo = io.open(CAMINHO, 'w')
local function relatar(texto)
    if arquivo then arquivo:write(texto .. '\n') arquivo:flush() end
    print(texto)
end

local CHAVES = {
    'name_local', 'pass_local',
    'platform_account_name', 'platform_account_id',
    'platform_account_Automatic_login',
}

local ok, erro = pcall(function()
    local ud = cc.UserDefault:getInstance()
    for _, chave in ipairs(CHAVES) do
        local antes = ud:getStringForKey(chave, '')
        ud:setStringForKey(chave, '')
        local depois = ud:getStringForKey(chave, '')
        relatar(string.format('%s: %q -> %q', chave, antes, depois))
        if depois ~= '' then error('nao limpou ' .. chave) end
    end
    ud:flush()
end)

relatar(ok and 'CONTA_LIMPA' or ('FALHOU: ' .. tostring(erro)))
if arquivo then arquivo:flush() arquivo:close() arquivo = nil end
os.exit(ok and 0 or 1)
