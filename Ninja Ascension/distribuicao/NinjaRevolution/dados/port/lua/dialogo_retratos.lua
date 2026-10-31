-- port/lua/dialogo_retratos.lua — UM RETRATO POR VEZ NA JANELA DE DIÁLOGO.
--
-- PROBLEMA (medido, não suposto):
--   RoleDialogue.lua:821 escolhe o painel do falante assim:
--       seekWidgetByName(_parent, string.format("Panel_big_head_%d", self._dir+1))
--   ou seja _dir=0 -> Panel_big_head_1, _dir=1 -> Panel_big_head_2.
--
--   Só que NADA no acervo esconde o painel do OUTRO lado. O terminal
--   role_dialogue_left_role_out (RoleDialogueWidget/RoleDialogueLeftRoleWidget.lua:87)
--   tem a linha que dispararia a saída COMENTADA:
--       -- params.headWidget.action:play("left_role_out", false)
--   então o evento "left_role_out" nunca chega, o removeFromParent (:142) não
--   acontece e o retrato antigo fica na tela.
--
--   Medição (port/lua/diag_retratos.lua, no binário, com o Chat/dialog.csb
--   real, sequência de _dir de mission3.txt = 1,1,0,1,0):
--       p1_filhos_inicio=1 p2_filhos_inicio=1
--       dir=1 criado  p1=1 p2=2
--       dir=0 criado  p1=2 p2=2
--       retratos_totais_apos_5_falas=4   -> os dois lados acumulam
--
--   E os dados de mission3.txt trazem left_head == right_head na maioria das
--   linhas (ex.: 1000016/1000016, 1000021/1000021). Resultado na tela: DOIS
--   retratos iguais — exatamente o sintoma relatado.
--
-- CORREÇÃO:
--   embrulha RoleDialogue:init. Depois de o acervo calcular self._dir, o
--   painel do falante fica visível e o do outro lado fica oculto. Nada mais
--   muda: os ids de retrato, o nome e a fala continuam vindo dos dados, e o
--   acervo segue criando o widget do lado certo.
--
--   Não se apaga nó nenhum e não se substitui retrato: só se ajusta a
--   visibilidade do painel que o layout já separa por lado.
--
-- O que NÃO se faz aqui: inventar falas, trocar os ids, forçar _dir, ou
-- esconder a janela quando os ids forem iguais (o dado é o dado).
local M = {}

local function nota(txt)
    print("HOST_DIALOGO " .. txt)
end

-- Encontra os dois painéis de retrato a partir da raiz da janela.
local function paineis(root)
    if root == nil then return nil, nil end
    local p1 = ccui.Helper:seekWidgetByName(root, "Panel_big_head_1")
    local p2 = ccui.Helper:seekWidgetByName(root, "Panel_big_head_2")
    return p1, p2
end

-- Mostra só o painel do lado de _dir (0 = esquerda/1, 1 = direita/2).
function M.aplicarLado(root, dir)
    local p1, p2 = paineis(root)
    if p1 == nil or p2 == nil then
        return false
    end
    if tonumber(dir) == 1 then
        p1:setVisible(false)
        p2:setVisible(true)
    else
        p1:setVisible(true)
        p2:setVisible(false)
    end
    return true
end

function M.install(class)
    if type(class) ~= "table" or class.__nr_dialogo_lado then return end
    local original = class.init
    if type(original) ~= "function" then return end
    class.__nr_dialogo_lado = true
    local avisou = false

    class.init = function(self, ...)
        local result = original(self, ...)
        -- Neste ponto o acervo já calculou self._dir a partir dos dados.
        local root = self.roots and self.roots[1]
        if root ~= nil then
            local ok = M.aplicarLado(root, self._dir)
            if not ok and not avisou then
                avisou = true
                nota("painéis de retrato não encontrados neste layout; "
                    .. "lado do falante não ajustado")
            end
        end
        return result
    end
end

function M.armar()
    if package.__nr_dialogo_lado_armado then return end
    package.__nr_dialogo_lado_armado = true
    local original = app.load
    app.load = function(name, ...)
        local result = original(name, ...)
        if name == "client.mission.missionex.RoleDialogue" then
            M.install(rawget(_G, "RoleDialogue"))
        end
        return result
    end
    M.install(rawget(_G, "RoleDialogue"))
end

return M
