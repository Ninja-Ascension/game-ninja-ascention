-- port/lua/ligar_login_automatico.lua
-- Liga a entrada automatica na conta salva, escrevendo pelo proprio
-- cc.UserDefault (nao editando o binario a mao).
--
-- Por que: login.lua:1741 le "platform_account_Automatic_login". Sem a chave,
-- o cliente abre a janela de conta pedindo senha em vez de entrar direto
-- (login.lua:1743-1749). Era o que parecia "erro desconhecido" ao abrir.
--
-- Executado uma vez pelo jogo com NR_LOGIN_AUTOMATICO=1 e encerra.
local caminho = cc.FileUtils:getInstance():getWritablePath() .. 'ligar-login-auto.log'
local arquivo = io.open(caminho, 'w')
local function relatar(texto)
    if arquivo then arquivo:write(texto .. '\n') arquivo:close() arquivo = nil end
    print(texto)
end

local ok, erro = pcall(function()
    local ud = cc.UserDefault:getInstance()
    -- Qual conta salva existe (o nome tambem e usado pelo fluxo de conta).
    local nome = ud:getStringForKey('name_local', '')
    local senha = ud:getStringForKey('pass_local', '')
    relatar('conta salva presente=' .. tostring(nome ~= '' and nome ~= nil))
    relatar('senha salva presente=' .. tostring(senha ~= '' and senha ~= nil))
    -- Qualquer valor nao vazio faz o cliente seguir o ramo "automatico"
    -- (login.lua:1742: automatic == nil or automatic == "" -> pede senha).
    ud:setStringForKey('platform_account_Automatic_login', '1')
    ud:flush()
    local lido = ud:getStringForKey('platform_account_Automatic_login', '')
    relatar('platform_account_Automatic_login=' .. tostring(lido))
    if tostring(lido) ~= '1' then
        error('gravar a chave nao funcionou')
    end
end)

if not ok then
    relatar('FALHOU: ' .. tostring(erro))
    os.exit(1)
end
relatar('LOGIN_AUTOMATICO_LIGADO')
os.exit(0)
