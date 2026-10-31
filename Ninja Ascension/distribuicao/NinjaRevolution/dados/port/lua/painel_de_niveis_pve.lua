-- port/lua/painel_de_niveis_pve.lua — O PAINEL DE NIVEIS DO PVE APARECIA SEMPRE,
-- COM OS NUMEROS PADRAO DO LAYOUT.
--
-- SINTOMA DO JOGADOR (execução real): "Há textos e valores sobrepostos no
-- canto inferior esquerdo."
--
-- CAUSA COMPROVADA (medida no binário, pve_labels_sonda / pve_arvore_sonda):
--   Todo o bloco fica dentro de Panel_word_lv_prompt_box, no canto inferior
--   esquerdo (x 20..214, y 27..118), e todos os rótulos estão VISÍVEIS:
--     Text_dh_info_0_0      pos=29,88   "Your Current Level:"
--     Text_player_lv        pos=168,81  "96"
--     Text_dh_info_0        pos=29,118  "Current Sever Team Level:"
--     Text_severs_lv        pos=214,110 "104"
--     Text_duplicate_exp_lv pos=168,32  "40%"
--   Medidos 12 pares de caixas sobrepostas nessa região.
--
--   Os valores 96 / 104 / 40% estão GRAVADOS NO PRÓPRIO pve_main.csb
--   (conferido byte a byte: as três strings existem no arquivo). Ou seja:
--   não são o perfil do jogador — são texto padrão do layout que nunca foi
--   sobrescrito nem escondido.
--
--   POR QUE O ACERVO NÃO ESCONDE:
--   LDuplicateWindow.lua:2279-2316 mostra o painel SOMENTE dentro do bloco
--       if _ED.user_info.world_grade and tonumber(user_grade) >= 50 ... then
--           Panel_word_lv_prompt_box:setVisible(true)
--           ... setString nos rótulos ...
--   `world_grade` vem do comando assíncrono 12612 (parse_world_grade,
--   ProtocolParserCopyExx.lua:7216); o cliente nem o solicita. Quando ele é
--   nil — que é o caso aqui — o bloco inteiro é PULADO, inclusive o
--   setVisible. Como o layout já nasce com o painel visível, ele fica na
--   tela mostrando os números fixos do CSB, sobrepostos uns nos outros.
--
-- CORREÇÃO:
--   reproduz a intenção explícita do acervo: sem world_grade confirmado, o
--   painel não deve aparecer. Quando o servidor informar world_grade e o
--   jogador estiver no nível que o acervo exige (user_grade >= 50), a lógica
--   ORIGINAL roda intacta e preenche os rótulos com os dados reais.
--
--   Isto não inventa número, não desbloqueia nada e não altera o painel em
--   nenhum caso em que o acervo já o preencheria.
local M = {}

local function nota(t) print('PAINEL_NIVEIS ' .. t) end

-- O mesmo predicado do acervo (LDuplicateWindow.lua:2279), lido do estado
-- real — nenhuma constante nova.
local function deveAparecer()
    local ui = _ED and _ED.user_info
    if type(ui) ~= 'table' then return false end
    local world = tonumber(ui.world_grade)
    local user = tonumber(ui.user_grade)
    if world == nil then return false end          -- servidor não informou
    if user == nil then return false end
    return user >= 50 and user < world
end

function M.armarJanela(janela)
    if type(janela) ~= 'table' or janela.__nr_painel_niveis then return end
    local original = janela.onEnterTransitionFinish
    if type(original) ~= 'function' then return end
    janela.__nr_painel_niveis = true

    janela.onEnterTransitionFinish = function(self, ...)
        local r = { original(self, ...) }
        local ok, err = pcall(function()
            local root = self.roots and self.roots[1]
            if root == nil then return end
            local painel = ccui.Helper:seekWidgetByName(root, 'Panel_word_lv_prompt_box')
            if painel == nil then return end
            local quer = deveAparecer()
            local okv, visivel = pcall(function() return painel:isVisible() end)
            if okv and visivel ~= quer then
                painel:setVisible(quer)
                nota('painel de niveis visivel=' .. tostring(quer)
                    .. ' (world_grade=' .. tostring(_ED and _ED.user_info and _ED.user_info.world_grade)
                    .. ' user_grade=' .. tostring(_ED and _ED.user_info and _ED.user_info.user_grade) .. ')')
            end
        end)
        if not ok then nota('falha ao ajustar o painel: ' .. tostring(err)) end
        return unpack(r)
    end
    nota('LDuplicateWindow instrumentada')
end

function M.armar()
    if package.__nr_painel_niveis_boot then return end
    package.__nr_painel_niveis_boot = true
    local load = app.load
    if type(load) ~= 'function' then return end
    app.load = function(nome, ...)
        local r = load(nome, ...)
        if tostring(nome):match('LDuplicateWindow$') then
            M.armarJanela(rawget(_G, 'LDuplicateWindow'))
            if type(r) == 'table' then M.armarJanela(r) end
        end
        return r
    end
    -- se a classe já estiver carregada
    M.armarJanela(rawget(_G, 'LDuplicateWindow'))
end

return M
