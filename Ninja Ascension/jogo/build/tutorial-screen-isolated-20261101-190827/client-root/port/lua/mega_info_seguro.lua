-- port/lua/mega_info_seguro.lua
-- Torna _ED.mega_info sempre uma tabela, evitando crash no FormationTigerGate.
--
-- CRASH REAL (log do servidor, 13:06:20):
--   EnvironmentDatas.lua:12039: bad argument #1 to 'pairs'
--     (table expected, got nil)
--     in function 'getAbilityFromBaMen'
--     in function 'updateDrawShipInfo'   (FormationTigerGate.lua:4602)
--
-- CAUSA: _ED.mega_info so passa a existir quando o servidor envia o bloco
-- 12690 (parse_mega_info, ProtocolParserCopyExx.lua:7256-7261) dentro do
-- login_init. O servidor local nao envia esse bloco, entao a variavel fica nil
-- e getAbilityFromBaMen (EnvironmentDatas.lua:12039) chama pairs(nil).
--
-- A funcao ja trata tudo o que precisa: se o navio nao e do tipo 8, retorna
-- antes de usar mega_info. Basta o valor ser uma tabela vazia. Nao inventamos
-- dados de super-evolucao: sem o bloco, a conta simplesmente nao tem nenhuma.
local M = {}

local function nota(texto)
    print('HOST_MEGA_INFO ' .. texto)
    local f = io.open(cc.FileUtils:getInstance():getWritablePath() .. 'mega-info.log', 'a')
    if f then f:write(os.date('%H:%M:%S') .. ' ' .. texto .. '\n') f:close() end
end

local function garantir()
    if _ED == nil then return end
    if _ED.mega_info == nil then
        _ED.mega_info = {}
        nota('mega_info inicializado como tabela vazia')
    elseif type(_ED.mega_info) ~= 'table' then
        -- Valor estranho vindo de dados salvos: normaliza em vez de quebrar.
        _ED.mega_info = {}
        nota('mega_info normalizado (era ' .. type(_ED.mega_info) .. ')')
    end
end

function M.install()
    if M.__instalado then return end
    M.__instalado = true
    garantir()
    -- O bloco 12690 pode chegar durante o login_init e recriar a tabela; e o
    -- _ED pode ser limpo em troca de conta. Reafirma por frame, custo de um
    -- teste de igualdade.
    local original = fwin.updateLua
    if type(original) == 'function' then
        fwin.updateLua = function(self, ...)
            local resultado = { original(self, ...) }
            garantir()
            return unpack(resultado)
        end
    end
end

M.garantir = garantir
return M
