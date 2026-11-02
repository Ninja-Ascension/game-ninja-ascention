-- port/lua/diag_vez_e_numeros.lua — OBSERVAÇÃO, NÃO CORREÇÃO.
--
-- Registra na execução REAL o estado dos sinalizadores que seguram a vez e o
-- ciclo de vida do painel de dano/cura. Só lê e imprime.
--
-- Ativar: NR_DIAG_VEZ=1 no ambiente do jogo.
--
-- Sintomas relatados:
--   1) o Sasuke ataca na vez do Naruto, depois da ultimate; era para esperar.
--   2) o dano e a cura continuam na tela depois dos ataques acabarem.
--
-- O que se mede:
--   (1) roleAttacking / roleByAttacking (FightRole.lua:175-177) — decidem se a
--       vez está ocupada em FightRoleController:checkNextFight (1938).
--       moveBackArena (FightRole.lua:179) — quando true, FightRole:onUpdate
--       (10813) NÃO entrega a vez ao próximo. Ele só cai em
--       cleanAttackDataFuncN (2347) se o Y voltar ao Y base (2350).
--   (2) DrawHitDamage:onUpdate (374-387): limpa os estados e chama
--       draw_hit_damage_check_window, mas fwin:close/setVisible estão
--       comentados (378-380). Quem fecha é o terminal draw_hit_damage_exit
--       (213), disparado por FightRoleController.lua:2891 (nextRoundFight).
local M = {}
local console=print
local lines=0
local function print(message)
    console(message)
    if lines>=600 then return end
    lines=lines+1
    local path=cc.FileUtils:getInstance():getWritablePath()..'turnos-batalha.log'
    local file=io.open(path,'a')
    if file then file:write(os.date('%H:%M:%S')..' '..tostring(message)..'\n');file:close() end
end

local ligado = false
local vistos = {}
local MAX = 300
local n = 0

local function reg(chave, texto)
    if not ligado or n >= MAX then return end
    if vistos[chave] then return end
    vistos[chave] = true
    n = n + 1
    print('DIAG_VEZ ' .. texto)
end

-- Resumo dos sinalizadores de um papel.
local function estadoDe(r)
    if r == nil then return 'nil' end
    local pool = '?'
    if type(r.fight_cacher_pool) == 'table' then pool = tostring(#r.fight_cacher_pool) end
    return string.format('camp=%s pos=%s atk=%s byAtk=%s back=%s waitSkill=%s pool=%s move=%s',
        tostring(r.roleCamp),
        tostring(r._info and r._info._pos),
        tostring(r.roleAttacking),
        tostring(r.roleByAttacking),
        tostring(r.moveBackArena),
        tostring(r.waitNextSkillInfluence),
        pool, tostring(r.move_state))
end

local function instrumentarPapel(FightRole)
    if FightRole == nil or FightRole.__diag_vez then return false end
    FightRole.__diag_vez = true

    -- 1) executeAttackLogic: marca o início da vez (9227-9228)
    local ex = FightRole.executeAttackLogic
    if type(ex) == 'function' then
        FightRole.executeAttackLogic = function(self, ...)
            if ligado then
                print('DIAG_VEZ INICIO_ATAQUE ' .. estadoDe(self))
            end
            return ex(self, ...)
        end
    end

    -- 2) hetiSkillEnd: fim da habilidade especial (7621-7645)
    local heti = FightRole.hetiSkillEnd
    if type(heti) == 'function' then
        FightRole.hetiSkillEnd = function(self, ...)
            if ligado then
                print('DIAG_VEZ FIM_ULTIMATE_ANTES ' .. estadoDe(self)
                    .. ' fitAttacking=' .. tostring(FightRole.__fit_attacking))
            end
            local r = heti(self, ...)
            if ligado then
                print('DIAG_VEZ FIM_ULTIMATE_DEPOIS ' .. estadoDe(self))
            end
            return r
        end
    end

    -- 3) onUpdate: onde a vez é entregue (10813) ou travada
    local up = FightRole.onUpdate
    if type(up) == 'function' then
        FightRole.onUpdate = function(self, dt)
            local aBack, aAtk = self.moveBackArena, self.roleAttacking
            local r = up(self, dt)
            if aBack ~= self.moveBackArena or aAtk ~= self.roleAttacking then
                reg(tostring(self) .. tostring(aBack) .. tostring(aAtk),
                    'MUDOU ' .. estadoDe(self))
            end
            return r
        end
    end
    return true
end

local function instrumentarPainel(DrawHitDamage)
    if DrawHitDamage == nil or DrawHitDamage.__diag_painel then return false end
    DrawHitDamage.__diag_painel = true
    for _, nome in ipairs({ 'onUpdate', 'playExitAction', 'udpateDrawTotalDamage' }) do
        local orig = DrawHitDamage[nome]
        if type(orig) == 'function' then
            DrawHitDamage[nome] = function(self, ...)
                local r = orig(self, ...)
                if ligado then
                    local vis = '?'
                    pcall(function() vis = tostring(self:isVisible()) end)
                    local d, c = '?', '?'
                    if type(self._draw_hit_damage_states) == 'table' then
                        d = tostring(#self._draw_hit_damage_states) end
                    if type(self._draw_hit_count_states) == 'table' then
                        c = tostring(#self._draw_hit_count_states) end
                    reg(nome .. tostring(self._camp) .. vis .. d .. c,
                        string.format('PAINEL %s camp=%s visivel=%s dano=%s contagem=%s',
                            nome, tostring(self._camp), vis, d, c))
                end
                return r
            end
        end
    end
    return true
end

local function forcar()
    local a = instrumentarPapel(rawget(_G, 'FightRole'))
    local b = instrumentarPainel(rawget(_G, 'DrawHitDamage'))
    local qte=rawget(_G,'FightQTEController')
    if type(qte)=='table' and not qte.__nr_turnos_trace then
        qte.__nr_turnos_trace=true
        for _,name in ipairs({'qteToNextAttackRole','qteToAutoNextAttackRole',
            'updateDrawPowerSkillTotalDamage'}) do
            local original=qte[name]
            if type(original)=='function' then
                qte[name]=function(self,params,...)
                    if ligado then
                        local cell=type(params)=='table' or type(params)=='userdata'
                        local text='DIAG_VEZ QTE '..name..' mission='..tostring(self.missionState)
                            ..' lock='..tostring(FightRoleController.__lock_battle)
                            ..' selected='..(cell and estadoDe(params.armature) or tostring(params))
                        if name=='updateDrawPowerSkillTotalDamage' then
                            reg(text,text)
                        else print(text) end
                    end
                    return original(self,params,...)
                end
            end
        end
    end
    return a, b
end

function M.armar()
    if package.__diag_vez_numeros then return end
    package.__diag_vez_numeros = true
    ligado = os.getenv('NR_DIAG_VEZ') ~= '0'
    print('DIAG_VEZ armar ligado=' .. tostring(ligado))

    -- O carregamento real acontece em FightRoleController.lua:199, que e quem
    -- faz app.load("client.battle.landscape.FightRole"). Embrulhar app.load e
    -- o gancho mais fiavel: arma no instante em que a classe nasce.
    local loadOrig = app.load
    if type(loadOrig) == 'function' then
        app.load = function(nome, ...)
            local r = loadOrig(nome, ...)
            if nome == 'client.battle.landscape.FightRole'
                or nome == 'client.battle.fight.DrawHitDamage'
                or nome == 'client.battle.landscape.FightQTEController' then
                local a, b = forcar()
                if a or b then
                    print('DIAG_VEZ armado_em ' .. tostring(nome)
                        .. ' papel=' .. tostring(a) .. ' painel=' .. tostring(b))
                end
            end
            return r
        end
    end

    forcar()

    -- Reforca quando as classes aparecerem de fato.
    local cena = cc.Director:getInstance():getRunningScene()
    if cena ~= nil then
        pcall(function()
            cena:runAction(cc.Sequence:create(
                cc.DelayTime:create(1.0),
                cc.CallFunc:create(function()
                    local a, b = forcar()
                    print('DIAG_VEZ rearmado papel=' .. tostring(a)
                        .. ' painel=' .. tostring(b))
                end)))
        end)
    end
end

return M
