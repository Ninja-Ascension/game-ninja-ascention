-- port/lua/teste_begin_load.lua
-- Prova que a rede de seguranca destrava o loader em 9%.
-- Roda dentro do jogo (NR_TESTE_BEGIN_LOAD=1) e encerra com os.exit(0/1).
local linhas = {}
local falhas = 0
local function checar(nome, condicao, detalhe)
    local linha = (condicao and '  ok    ' or '  FALHA ') .. nome
    if detalhe ~= nil then linha = linha .. ' -> ' .. tostring(detalhe) end
    linhas[#linhas + 1] = linha
    if not condicao then falhas = falhas + 1 end
end

local ok, modulo = pcall(require, 'garantir_begin_load')
if not ok then
    linhas[#linhas + 1] = '  FALHA require: ' .. tostring(modulo)
    local f = io.open(cc.FileUtils:getInstance():getWritablePath() .. 'begin-load-teste.log', 'w')
    if f then f:write(table.concat(linhas, '\n') .. '\n') f:close() end
    os.exit(1)
end

-- Stub do fwin: guarda os servicos sem depender do loop real.
local servicos = {}
local guardar = fwin.addService
fwin.addService = function(self, s) servicos[#servicos + 1] = s end
fwin._list = fwin._list or {}

local classe = {}
function classe:onEnterTransitionFinish() self.montou = true end
checar('install funciona', modulo.install(classe) == true)
checar('instalacao idempotente', modulo.install(classe) == true)

-- O hook ficou na classe; uma "instancia" so precisa cair nele via __index.
local function novaInstancia(campos)
    return setmetatable(campos or {}, { __index = classe })
end

-- 2) Reproduz o travamento: isBeginLoad nunca vira true.
local janela = novaInstancia({ totalNum = 5, isBeginLoad = false })
fwin._list[#fwin._list + 1] = janela
local ok2, erro2 = pcall(function() janela:onEnterTransitionFinish() end)
checar('montou a janela', ok2 and janela.montou == true, erro2)
checar('nada ligado na hora', janela.isBeginLoad == false)
checar('agendou a rede de seguranca', #servicos == 1, #servicos)

-- 3) O servico, ao rodar, liga o carregamento.
local ok3, erro3 = pcall(function() servicos[1].callback() end)
checar('rede de seguranca ligou isBeginLoad', ok3 and janela.isBeginLoad == true,
       ok3 and tostring(janela.isBeginLoad) or tostring(erro3))

-- 4) Nao mexe numa janela ja descarregada.
servicos = {}
local fechada = novaInstancia({ totalNum = 5, isBeginLoad = false, _unload = true })
fwin._list[#fwin._list + 1] = fechada
local ok4 = pcall(function()
    fechada:onEnterTransitionFinish()
    servicos[1].callback()
end)
checar('nao liga em janela descarregada', ok4 and fechada.isBeginLoad == false)

-- 5) Nao toca em janela JA removida do fwin (no destruido derruba o cliente).
servicos = {}
local removida = novaInstancia({ totalNum = 5, isBeginLoad = false })
fwin._list[#fwin._list + 1] = removida
local ok5 = pcall(function()
    removida:onEnterTransitionFinish()
    for i = #fwin._list, 1, -1 do
        if fwin._list[i] == removida then table.remove(fwin._list, i) end
    end
    servicos[1].callback()
end)
checar('nao toca em janela fechada', ok5 and removida.isBeginLoad == false)

-- 6) Rearme: quando a classe aparece como global, armar() a encontra.
_G.FightLoadingCell = { onEnterTransitionFinish = function(self) self.montou = true end }
local ok6, erro6 = pcall(modulo.armar)
checar('armar instalou o hook', ok6 and _G.FightLoadingCell.__nr_begin_load == true, erro6)
_G.FightLoadingCell = nil

fwin.addService = guardar
local f = io.open(cc.FileUtils:getInstance():getWritablePath() .. 'begin-load-teste.log', 'w')
if f then
    f:write(table.concat(linhas, '\n') .. '\n')
    f:write(falhas == 0 and '\nBEGIN_LOAD_PASSED rede de seguranca destrava o loader\n'
                    or ('\nBEGIN_LOAD_FAILED ' .. falhas .. ' falha(s)\n'))
    f:close()
end
os.exit(falhas == 0 and 0 or 1)
