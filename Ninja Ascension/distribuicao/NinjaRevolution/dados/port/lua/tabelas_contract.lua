-- Contrato: as tabelas de batalha estão em memória depois do boot.
--
-- Sem elas, o portão do TAP em FightRole.lua:7285 nunca abre e as habilidades
-- ficam bloqueadas. Ver o comentário de port/lua/tabelas_de_batalha.lua para a
-- causa (o ramo l_naruto de localData_attack_logic não carrega nada).
--
-- Este contrato não força energia, não pula tutorial e não mexe em bloqueio:
-- só confere que o DADO que o acervo consulta existe.
local M = {}

local TABELAS = {
    "ship_mould",
    "environment_ship",
    "skill_influence",
    "skill_mould",
}

function M.run()
    local carregadas = 0
    for _, nome in ipairs(TABELAS) do
        local tab = dms[nome]
        local n = (type(tab) == "table") and #tab or 0
        print('TABELAS_CONTRATO ' .. nome .. ' carregada=' .. tostring(tab ~= nil)
            .. ' linhas=' .. tostring(n))
        assert(tab ~= nil, 'tabela ausente: ' .. nome)
        assert(n > 0, 'tabela vazia: ' .. nome)
        carregadas = carregadas + 1
    end
    print('TABELAS_CONTRATO carregadas=' .. carregadas .. '/' .. #TABELAS)

    -- A coluna que o portão do TAP usa precisa existir.
    assert(type(ship_mould) == "table", 'campos de ship_mould ausentes')
    local col = ship_mould.screen_attack_effect
    assert(col ~= nil, 'coluna screen_attack_effect não definida')

    -- E precisa devolver valor para personagens reais.
    local comValor = 0
    local tab = dms["ship_mould"]
    for i = 1, math.min(50, #tab) do
        local id = tostring(tab[i]):match('^(%d+)')
        if id ~= nil then
            local ok, v = pcall(function()
                return dms.string(tab, tonumber(id), col)
            end)
            if ok and tonumber(v) ~= nil then
                comValor = comValor + 1
            end
        end
    end
    print('TABELAS_CONTRATO screen_attack_effect com valor em ' .. comValor .. ' dos 50 primeiros')
    assert(comValor > 0, 'nenhum personagem tem screen_attack_effect: o portão não abriria')

    -- Não inventa: tabela que não existe no acervo continua sem carga.
    local ausente = dms["ship_rank_up_param"]
    print('TABELAS_CONTRATO ship_rank_up_param (ausente no acervo) = '
        .. tostring(ausente ~= nil))

    print('TABELAS_CONTRATO_PASSED tabelas de batalha em memória, portão do TAP com dado')
end

return M
