-- port/lua/teste_esconder_dialogos.lua
-- Executado pelo próprio jogo (NR_TESTE_DIALOGOS=1): valida o hook de ocultar
-- diálogos com um RoleDialogue simulado que imita o original, grava o
-- resultado em dialogos-teste.log e encerra o processo.
local function relatar(linhas, falhou)
    local caminho = cc.FileUtils:getInstance():getWritablePath() .. 'dialogos-teste.log'
    local arquivo = io.open(caminho, 'w')
    if arquivo then
        arquivo:write(table.concat(linhas, '\n') .. '\n')
        arquivo:close()
    end
    print(table.concat(linhas, '\n'))
    os.exit(falhou and 1 or 0)
end

local linhas, falhas = {}, {}

local function checar(nome, ok, detalhe)
    linhas[#linhas + 1] = (ok and '  ok    ' or '  FALHA ') .. nome
        .. (detalhe ~= nil and (' -> ' .. tostring(detalhe)) or '')
    if not ok then falhas[#falhas + 1] = nome end
end

local ok, erro = pcall(function()
    -- Janela simulada com o contrato real de RoleDialogue.
    local papel = {}
    function papel:onEnterTransitionFinish()
        self.roots = { { visivel = true, setVisible = function(r, v) r.visivel = v end } }
    end
    function papel:touchNextMission()
        self.avancou = (self.avancou or 0) + 1
        if self.eventIndex + 2 <= #self.missions then
            self.eventIndex = self.eventIndex + 1
        else
            self.fechou = true
        end
    end
    function papel:updateChat() end
    function papel:isVisible() return self.visivelok ~= false end
    papel.__index = papel

    local modulo = require('esconder_dialogos')
    modulo.install(papel)

    local servicos = {}
    fwin._list = {}
    local guardarAdd = fwin.addService
    fwin.addService = function(self, s) servicos[#servicos + 1] = s end

    local function rodarServicos()
        local pendentes, n = servicos, 0
        servicos = {}
        for _, s in ipairs(pendentes) do s.callback(s.params, s); n = n + 1 end
        return n
    end

    local janela = setmetatable({ missions = { 1, 2, 3 }, eventIndex = 1 }, papel)
    fwin._list[#fwin._list + 1] = janela   -- janela viva no registro do fwin
    janela:onEnterTransitionFinish()
    checar('arte escondida ao montar', janela.roots[1].visivel == false)
    checar('toque automatico agendado', rodarServicos() >= 1)
    checar('avancou sem o jogador tocar', janela.avancou == 1, janela.avancou)

    for i = 1, 2 do
        janela.roots[1].visivel = true
        janela:updateChat()
        checar('fala ' .. i .. ' reocultada', janela.roots[1].visivel == false)
        rodarServicos()
    end
    checar('sequencia inteira avancou', janela.avancou >= 3, janela.avancou)
    checar('fechou no fim da lista', janela.fechou == true)

    local antes = papel.onEnterTransitionFinish
    modulo.install(papel)
    checar('instalacao idempotente', papel.onEnterTransitionFinish == antes)

    janela.visivelok = false
    local avancos = janela.avancou
    janela:onEnterTransitionFinish()
    rodarServicos()
    checar('janela invisivel nao avanca', janela.avancou == avancos)

    -- Janela REMOVIDA do registro (já fechada): o serviço pendente não pode
    -- tocar nela — era daqui que vinha o crash em Node_isVisible.
    janela.visivelok = true
    local removida = setmetatable({ missions = { 1, 2, 3 }, eventIndex = 1 }, papel)
    fwin._list[#fwin._list + 1] = removida
    removida:onEnterTransitionFinish()
    for i = #fwin._list, 1, -1 do
        if fwin._list[i] == removida then table.remove(fwin._list, i) end
    end
    rodarServicos()
    checar('janela fechada nao avanca (sem crash)', removida.avancou == nil)

    fwin.addService = guardarAdd
end)

if not ok then
    linhas[#linhas + 1] = 'ERRO: ' .. tostring(erro)
    falhas[#falhas + 1] = 'excecao'
end

if #falhas > 0 then
    linhas[#linhas + 1] = ''
    linhas[#linhas + 1] = 'ESCONDER_DIALOGOS_FAILED: ' .. table.concat(falhas, ', ')
    relatar(linhas, true)
end
linhas[#linhas + 1] = ''
linhas[#linhas + 1] = 'ESCONDER_DIALOGOS_PASSED arte oculta, tutorial avanca, sequencia completa'
relatar(linhas, false)
