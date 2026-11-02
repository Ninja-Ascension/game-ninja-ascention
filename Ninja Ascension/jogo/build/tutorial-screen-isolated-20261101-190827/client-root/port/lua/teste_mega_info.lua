-- port/lua/teste_mega_info.lua
-- Reproduz o crash real e prova a correcao.
-- NR_TESTE_MEGA_INFO=1 escreve mega-info-teste.log e encerra.
local linhas = {}
local falhas = 0
local function checar(nome, condicao, detalhe)
    local linha = (condicao and '  ok    ' or '  FALHA ') .. nome
    if detalhe ~= nil then linha = linha .. ' -> ' .. tostring(detalhe) end
    linhas[#linhas + 1] = linha
    if not condicao then falhas = falhas + 1 end
end

-- 1) Reproduz o crash: pairs(nil) exatamente como EnvironmentDatas.lua:12039.
_ED.mega_info = nil
local estourou = not pcall(function()
    for k, v in pairs(_ED.mega_info) do end
end)
checar('crash reproduzido com mega_info nil', estourou)

-- 2) Instala a correcao.
local modulo = require('mega_info_seguro')
modulo.install()
checar('mega_info virou tabela', type(_ED.mega_info) == 'table')

-- 3) O trecho que quebrava agora passa.
local ok = pcall(function()
    for k, v in pairs(_ED.mega_info) do end
end)
checar('pairs funciona depois da correcao', ok)

-- 4) Nao inventa dados de super-evolucao.
checar('tabela vazia (sem dados falsos)', next(_ED.mega_info) == nil)

-- 5) Preserva dados reais quando o bloco 12690 chega.
_ED.mega_info = { { shipId = '7', info = '{"megaLevel":{"1":2}}' } }
modulo.garantir()
checar('preserva dados reais', #_ED.mega_info == 1 and _ED.mega_info[1].shipId == '7')

-- 6) Valor de tipo estranho e normalizado em vez de propagar erro.
_ED.mega_info = 'lixo'
modulo.garantir()
checar('normaliza valor invalido', type(_ED.mega_info) == 'table')

-- 7) Idempotente: nao empilha hooks no fwin.updateLua.
local antes = fwin.updateLua
modulo.install()
checar('instalacao idempotente', fwin.updateLua == antes)

local f = io.open(cc.FileUtils:getInstance():getWritablePath() .. 'mega-info-teste.log', 'w')
if f then
    f:write(table.concat(linhas, '\n') .. '\n')
    f:write(falhas == 0 and '\nMEGA_INFO_PASSED pairs(nil) nao derruba mais\n'
                    or ('\nMEGA_INFO_FAILED ' .. falhas .. ' falha(s)\n'))
    f:close()
end
os.exit(falhas == 0 and 0 or 1)
