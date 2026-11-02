-- port/lua/teste_loader_tutorial.lua
-- Reproduz o ciclo do jogador: travou, reiniciou, conta ainda no tutorial,
-- tela parada em 9% (totalNum=5) e nada mais vai ao servidor.
-- NR_TESTE_LOADER_TUTORIAL=1 escreve loader-tutorial-teste.log e encerra.
local linhas = {}
local falhas = 0
local function checar(nome, condicao, detalhe)
    local linha = (condicao and '  ok    ' or '  FALHA ') .. nome
    if detalhe ~= nil then linha = linha .. ' -> ' .. tostring(detalhe) end
    linhas[#linhas + 1] = linha
    if not condicao then falhas = falhas + 1 end
end

local modulo = require('loader_tutorial')

-- Cenografico: registra o que o hook fez, sem mexer no jogo real.
local aberto, executado, fechado = nil, nil, nil
_G.app = _G.app or {}
local salvarAppLoad = app.load
app.load = function(nome) aberto = nome end
local salvarStateMachine = state_machine
local salvarFwin = { find = fwin.find, open = fwin.open, close = fwin.close }
fwin.find = function(self, nome) return nil end
fwin.open = function(self, janela) aberto = 'Menu' end
fwin.close = function(self, janela) fechado = true end
state_machine.excute = function(self, nome, ...) executado = nome return true end
_G.Menu = { new = function() return {} end }
_G.missionIsOver = function() return false end   -- etapa SEM batalha
_G.tolua = _G.tolua or { isnull = function() return false end }

local classe = { totalNum = 5, isBeginLoad = false, _unload = false, _excute_mission = true }
function classe:onUpdate(dt) end

checar('install funciona', modulo.install(classe) == true)
checar('instalacao idempotente', modulo.install(classe) == true)

local function novoLoader(campos)
    local l = setmetatable({}, { __index = classe })
    for k, v in pairs(campos or {}) do l[k] = v end
    return l
end

-- 1) Conta no tutorial, loader parado em 5 (9%): nao age na hora.
_ED = _ED or {}
_ED.user_info = { user_grade = '1', user_experience = '0' }
local loader = novoLoader()
loader:onUpdate(0.016)
checar('nao age no primeiro frame', aberto == nil)

-- 2) Depois da espera, sem missao de batalha, segue para a Home.
loader.__nr_parado_desde = os.time() - 100
loader:onUpdate(0.016)
checar('abriu a Home', aberto == 'client.home.Menu', tostring(aberto))
checar('abriu o estado de missao', executado == 'menu_window_open_mission', tostring(executado))
checar('nao repete (marca aplicada)', loader.__nr_seguiu_home == true)
checar('marcou _unload', loader._unload == true)

-- 3) COM batalha na etapa: nao sequestra o fluxo.
aberto, executado = nil, nil
missionIsOver = function() return true end
local comBatalha = novoLoader({ __nr_parado_desde = os.time() - 100 })
comBatalha:onUpdate(0.016)
checar('nao desvia quando ha batalha', aberto == nil and executado == nil)

-- 4) Conta JA fora do tutorial (grade > 1): o hook nao interfere.
missionIsOver = function() return false end
aberto = nil
_ED.user_info = { user_grade = '3', user_experience = '5' }
local foraTutorial = novoLoader({ __nr_parado_desde = os.time() - 100 })
foraTutorial:onUpdate(0.016)
checar('nao interfere fora do tutorial', aberto == nil)

-- 5) Loader que JA comecou a carregar e nao tem batalha: segue ao fim.
_ED.user_info = { user_grade = '1', user_experience = '0' }
aberto, executado = nil, nil
local carregado = novoLoader({ totalNum = 100, isBeginLoad = true, _excute_mission = false })
carregado:onUpdate(0.016)
checar('carregamento concluido sem batalha vai para a Home', aberto == 'client.home.Menu', tostring(aberto))

-- Restaura o ambiente do jogo.
app.load = salvarAppLoad
fwin.find, fwin.open, fwin.close = salvarFwin.find, salvarFwin.open, salvarFwin.close

local f = io.open(cc.FileUtils:getInstance():getWritablePath() .. 'loader-tutorial-teste.log', 'w')
if f then
    f:write(table.concat(linhas, '\n') .. '\n')
    f:write(falhas == 0 and '\nLOADER_TUTORIAL_PASSED nao fica preso em 9%\n'
                    or ('\nLOADER_TUTORIAL_FAILED ' .. falhas .. ' falha(s)\n'))
    f:close()
end
os.exit(falhas == 0 and 0 or 1)
