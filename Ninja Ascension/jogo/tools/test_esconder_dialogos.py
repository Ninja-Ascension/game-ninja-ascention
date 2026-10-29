"""Teste do hook que oculta os diálogos mantendo o tutorial avançando.

Roda em LuaJIT separado, com um RoleDialogue simulado que imita o original:
  * onEnterTransitionFinish monta self.roots (a arte);
  * touchNextMission é o avance real (RoleDialogue.lua:637-655);
  * updateChat é chamado a cada nova fala.

Contrato verificado:
  1. a arte fica invisível;
  2. touchNextMission é chamado sozinho (sem o jogador tocar);
  3. a sequência inteira de falas passa (updateChat reoculta cada uma);
  4. nada quebra se a janela já estiver fechada.
"""
import shutil
import subprocess
import sys
from pathlib import Path

raiz = Path(__file__).resolve().parents[1]
modulo = raiz / 'port/lua/esconder_dialogos.lua'

luajit = shutil.which('luajit')
for candidato in (raiz / 'build/windows-probe-native').rglob('luajit.exe'):
    luajit = luajit or str(candidato)
    break

roteiro = r'''
-- Ambiente mínimo que o módulo espera do jogo.
local servicos = {}
fwin = { addService = function(self, s) table.insert(servicos, s) end }
cc = { FileUtils = { getInstance = function()
    return { getWritablePath = function() return "build/" end }
end } }

local RoleDialogue = {}
function RoleDialogue:onEnterTransitionFinish()
    self.roots = { { visivel = true, setVisible = function(r, v) r.visivel = v end } }
end
function RoleDialogue:touchNextMission()
    self.avancou = (self.avancou or 0) + 1
    if self.missions and self.eventIndex and self.eventIndex + 2 <= #self.missions then
        self.eventIndex = self.eventIndex + 1
    else
        self.fechou = true
    end
end
function RoleDialogue:updateChat() end
function RoleDialogue:isVisible() return self.visivelok ~= false end
RoleDialogue.__index = RoleDialogue

local M = assert(loadfile("port/lua/esconder_dialogos.lua"))()
M.install(RoleDialogue)

local function rodarServicos()
    local pendentes, executados = servicos, 0
    servicos = {}
    for _, s in ipairs(pendentes) do
        s.callback(s.params, s); executados = executados + 1
    end
    return executados
end

local falhas = {}
local function checar(nome, ok, detalhe)
    print((ok and "  ok   " or "  FALHA ") .. nome .. (detalhe and (" -> " .. tostring(detalhe)) or ""))
    if not ok then table.insert(falhas, nome) end
end

-- 1) Janela com uma sequência de 3 falas.
local janela = setmetatable({ missions = {1,2,3}, eventIndex = 1 }, RoleDialogue)
janela:onEnterTransitionFinish()
checar("arte escondida ao montar", janela.roots[1].visivel == false)
checar("toque automatico agendado", rodarServicos() >= 1)
checar("avanco ocorreu sem toque do jogador", janela.avancou == 1, janela.avancou)

-- 2) Cada nova fala reoculta e avança de novo.
for i = 1, 2 do
    janela.roots[1].visivel = true
    janela:updateChat()
    checar("fala " .. i .. " reocultada", janela.roots[1].visivel == false)
    rodarServicos()
end
checar("sequencia inteira avancou", janela.avancou >= 3, janela.avancou)
checar("janela fechou no fim da lista", janela.fechou == true)

-- 3) Instalar duas vezes não duplica o hook.
local antes = RoleDialogue.onEnterTransitionFinish
M.install(RoleDialogue)
checar("instalacao idempotente", RoleDialogue.onEnterTransitionFinish == antes)

-- 4) Janela invisível/fechada não recebe toque.
janela.visivelok = false
local avancosAntes = janela.avancou
janela:onEnterTransitionFinish()
rodarServicos()
checar("janela fechada nao avanca", janela.avancou == avancosAntes)

if #falhas > 0 then
    print("\nESCONDER_DIALOGOS_FAILED: " .. table.concat(falhas, ", "))
    os.exit(1)
end
print("\nESCONDER_DIALOGOS_PASSED arte oculta, tutorial avanca, sequencia completa")
os.exit(0)
'''

if not luajit:
    print('LuaJIT nao encontrado; teste nao executado.')
    sys.exit(1)

resultado = subprocess.run([luajit, '-e', roteiro], cwd=str(raiz),
                           capture_output=True, text=True)
print(resultado.stdout.strip())
if resultado.stderr.strip():
    print(resultado.stderr.strip())
sys.exit(resultado.returncode)
