-- Contrato do portão do TAP (FightRole.lua:7273-7288).
--
-- O fluxo TAP/habilidade de time só liga se:
--     shipEffect = dms.string(dms["ship_mould"], mouldId,
--                             ship_mould.screen_attack_effect)
--     if shipEffect ~= nil and tonumber(shipEffect) > -1 then
--         excute("update_fight_team_controller_data", ...)
--
-- Medido antes da correção: dms["ship_mould"] era nil (a tabela existe em
-- data/mould/ship_mould.txt, 539096 bytes, 2052 linhas, mas nada a carregava
-- no boot), então o portão nunca abria e as habilidades ficavam travadas.
--
-- Aqui: carrega pelos campos que estavam sendo usados e confere que o portão
-- abre para personagens reais do tutorial.
local M = {}

function M.run()
    -- 1) a tabela
    local tabela = dms.load('data/mould/ship_mould.txt')
    print('TAP_CONTRATO linhas=' .. tostring(type(tabela) == 'table' and #tabela or 'nil'))
    assert(type(tabela) == 'table' and #tabela > 0,
        'ship_mould.txt não carregou')

    -- 2) os campos de configuração usados pelo acervo
    assert(type(ship_mould) == 'table', 'ship_mould (campos) ausente')
    local col = ship_mould.screen_attack_effect
    print('TAP_CONTRATO coluna screen_attack_effect=' .. tostring(col))
    assert(col ~= nil, 'coluna screen_attack_effect não definida')

    -- 3) o portão abre para ids reais?
    local abertos, fechados, erros = 0, 0, 0
    local exemplos = {}
    for i = 1, math.min(400, #tabela) do
        local linha = tabela[i]
        if linha ~= nil then
            local id = tostring(linha):match('^(%d+)')
            if id ~= nil then
                local ok, valor = pcall(function()
                    return dms.string(tabela, tonumber(id), col)
                end)
                if not ok then
                    erros = erros + 1
                else
                    local n = tonumber(valor)
                    if n ~= nil and n > -1 then
                        abertos = abertos + 1
                        if #exemplos < 3 then
                            exemplos[#exemplos + 1] = id .. '=' .. tostring(valor)
                        end
                    else
                        fechados = fechados + 1
                    end
                end
            end
        end
    end
    print('TAP_CONTRATO portao_abre=' .. abertos .. ' fecha=' .. fechados
        .. ' erros=' .. erros .. ' exemplos=[' .. table.concat(exemplos, ', ') .. ']')
    assert(erros == 0, 'consulta ao ship_mould não pode estourar')
    assert(abertos > 0, 'nenhum personagem abriria o portão do TAP')

    -- 4) não inventa: id inexistente não abre o portão
    local okInex, valorInex = pcall(function()
        return dms.string(tabela, 999999999, col)
    end)
    local abreInex = false
    if okInex and tonumber(valorInex) ~= nil and tonumber(valorInex) > -1 then
        abreInex = true
    end
    print('TAP_CONTRATO id inexistente abre portao=' .. tostring(abreInex))
    assert(abreInex == false, 'id inexistente não pode abrir o portão')

    print('TAP_CONTRATO_PASSED ship_mould carrega e o portão do TAP abre com dados reais')
end

return M
