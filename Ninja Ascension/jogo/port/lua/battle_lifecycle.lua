-- Scope fixes to battle loading. Never discard a missing actor's action.
local M={}
local function note(message)
    print('HOST_BATTLE_LIFECYCLE '..message)
    local path=cc.FileUtils:getInstance():getWritablePath()..'battle-lifecycle.log'
    local file=io.open(path,'a')
    if file then file:write(os.date('%H:%M:%S')..' '..message..'\n');file:close() end
end
local function keys(t)
    local result={}
    for k in pairs(t or {}) do result[#result+1]=tostring(k)..'('..type(k)..')' end
    table.sort(result);return table.concat(result,',')
end
function M.resumeSavedMenu(baseWindow)
    local user=_ED and _ED.user_info
    local login=baseWindow.LoginLoading
    if not login or not user or (tonumber(user.user_id) or 0)<=0 then return false end
    if (tonumber(user.user_grade) or 1)<=1 and (tonumber(user.user_experience) or 0)<=0 then return false end
    -- This child exists only in LoginLoading:init's initial-login branch.
    -- Ordinary battle loaders must never be redirected to the menu.
    if baseWindow.__nr_resume_saved_menu then return true end
    baseWindow.__nr_resume_saved_menu=true
    baseWindow._unload=true
    app.load('client.home.Menu')
    fwin:addService({delay=0,callback=function()
        if tolua.isnull(baseWindow) then return end
        fwin:close(baseWindow)
        local old=fwin:find('LoginLoadingClass')
        if old and not tolua.isnull(old) then fwin:close(old) end
        state_machine.excute('menu_window_open_mission',0,0)
        note('restored account: retired initial loader and resumed original menu mission')
    end})
    return true
end
function M.installLoading(class)
    if type(class)~='table' or class.__nr_battle_preload then return end
    if type(class.checkLoginLoading)~='function' then return end
    class.__nr_battle_preload=true
    local check=class.checkLoginLoading
    local activity,formation=class.loadingActivity,class.loadingFormation
    class.checkLoginLoading=function(self,baseWindow,loginIn,...)
        -- Login_init can restore a progressed account after FightLoading was
        -- created from the pre-login defaults. That loader's step 8 normally
        -- pauses for a battle_request mission; a home tutorial has no such
        -- event and leaves both the dialogue and loading background stuck.
        --
        -- _ED.user_info does NOT exist before the login reply is parsed
        -- (EnvironmentDatas.lua:33 is only a declaration; ProtocolParserCopy
        -- only assigns _ED.user_info at :182). Between FightLoadingCell:onInit
        -- and that parser this runs on every frame, so indexing _ED.user_info
        -- directly raised "attempt to compare number with nil" inside onUpdate
        -- and the loader froze at 8% forever. Missing profile = account not
        -- restored yet: never the saved-account route.
        local user=_ED and _ED.user_info
        local user_id=user and tonumber(user.user_id) or 0
        local grade=user and (tonumber(user.user_grade) or 1) or 1
        local experience=user and (tonumber(user.user_experience) or 0) or 0
        -- Pre-login frames have no profile at all: skip every experiment that
        -- depends on it instead of reading fields of a missing table.
        local known=user~=nil
        if baseWindow and known and not baseWindow.__nr_loader_note then
            baseWindow.__nr_loader_note=true
            note('loader probe totalNum='..tostring(self.totalNum)..' loginIn='..tostring(loginIn)
                ..' owner='..tostring(baseWindow.LoginLoading==self)
                ..' user_id='..tostring(user and user.user_id)
                ..' grade='..tostring(user and user.user_grade)
                ..' experience='..tostring(user and user.user_experience)
                ..' unload='..tostring(baseWindow._unload)
                ..' begin='..tostring(self.isBeginLoad)
                ..' menu='..tostring(fwin:find('MenuClass')~=nil))
        end
        if loginIn==false and baseWindow and baseWindow.LoginLoading==self and self.totalNum==8
            and user_id>0 and (grade>1 or experience>0) then
            if not baseWindow.__nr_resume_saved_menu then
                M.resumeSavedMenu(baseWindow)
            end
            return
        end
        local previous=self.__nr_preloading_battle
        -- The original method's contract identifies battle loading by these
        -- arguments. Native peer class names can change during window setup.
        self.__nr_preloading_battle=(loginIn==false and baseWindow~=nil)
        local result={pcall(check,self,baseWindow,loginIn,...)}
        self.__nr_preloading_battle=previous
        if not result[1] then error(result[2],0) end
        return unpack(result,2)
    end
    class.loadingActivity=function(self,...)
        if not self.__nr_preloading_battle and require('tutorial_disabled').enabled then return activity(self,...) end
        -- Original preload opens ActivityWindow asynchronously, then hides it
        -- immediately. The delayed open can outlive that hide/scene cleanup.
        app.load('client.activity.ActivityWindow')
        self.isLoadActivity=true
        note('preload activity module only; no delayed Event window')
    end
    class.loadingFormation=function(self,...)
        if not self.__nr_preloading_battle and require('tutorial_disabled').enabled then return formation(self,...) end
        app.load('client.formation.FormationTigerGate')
        self.isLoadFormation=true
        note('preload formation module only; no menu window')
    end
end
function M.installRoles(class)
    if type(class)~='table' or class.__nr_actor_contract then return end
    local execute=class.executeCurrentSelectRoleFightDataAddAttacker
    if type(execute)~='function' then return end
    class.__nr_actor_contract=true
    -- Persist the FIRST construction failure, before later dialogue/round
    -- callbacks obscure it with a secondary missing-actor error.
    for _,name in ipairs({'nextBattle','initHero','initMaster'}) do
        local original=class[name]
        if type(original)=='function' then
            class[name]=function(self,...)
                local args={...}
                note(name..' begin wave='..tostring(self.fightIndex))
                local result={xpcall(function() return original(self,unpack(args)) end,debug.traceback)}
                if not result[1] then
                    note(name..' FAILED '..tostring(result[2]))
                    error(result[2],0)
                end
                note(name..' end heroes={'..keys(self._hero_formation)
                    ..'} enemies={'..keys(self._master_formation)..'}')
                return unpack(result,2)
            end
        end
    end
    class.executeCurrentSelectRoleFightDataAddAttacker=function(self,data,...)
        -- Original protocol consumers use string keys for camp and seat.
        local camp=tostring(data.attacker)
        local seat=tonumber(data.attackerPos)
        assert((camp=='0' or camp=='1') and seat and seat>=1 and seat==math.floor(seat),
            'Invalid battle actor identity: '..camp..'/'..tostring(data.attackerPos))
        local key=tostring(seat)
        local actors
        if seat>6 then actors=camp=='0' and self._hero_animal_formation or self._master_animal_formation
        else actors=camp=='0' and self._hero_formation or self._master_formation end
        if not actors or not actors[key] then
            local battle=_ED and _ED.battleData or {}
            local message='Missing actor camp='..camp..' seat='..key
                ..' wave='..tostring(self.fightIndex)..' rendered={'..keys(actors)..'}'
                ..' heroes={'..keys(battle._heros)..'} armies={'..keys(battle._armys)..'}'
                ..' enemyData={'..keys(battle._armys and battle._armys[self.fightIndex]
                    and battle._armys[self.fightIndex]._data)..'}'
                ..' heroSlots='..tostring(#(self.hero_slots or {}))
                ..' enemySlots='..tostring(#(self.master_slots or {}))
            note(message)
            error(message,0)
        end
        data.attacker=camp;data.attackerPos=key
        return execute(self,data,...)
    end
end
function M.installBattleLoader(class)
    if type(class)~='table' or class.__nr_loader_instance then return end
    local attach=class.onAddLoginLoading
    if type(attach)~='function' then return end
    class.__nr_loader_instance=true
    local update=class.onUpdate
    class.onUpdate=function(self,...)
        -- Check BEFORE the original early return on _unload/isBeginLoad.
        -- Login_init can arrive after step 8 has already paused this loader.
        if M.resumeSavedMenu(self) then return end
        return update(self,...)
    end
    class.onAddLoginLoading=function(self,...)
        local result={attach(self,...)}
        local loader=self.LoginLoading
        local source=rawget(_G,'LoginLoading')
        M.installLoading(source)
        if loader and source then
            -- Native Window.new copies methods rather than looking them up.
            -- Also update peers created while their module was being loaded.
            for _,name in ipairs({'checkLoginLoading','loadingActivity','loadingFormation'}) do
                loader[name]=source[name]
            end
            note('attached battle preload methods to LoginLoading peer')
        end
        return unpack(result)
    end
end
function M.armar()
    if package.__nr_battle_lifecycle then return end
    package.__nr_battle_lifecycle=true
    local original=app.load
    require('texture_async_compat').armar()
    local tapWait=require('tutorial_tap_wait')
    local lifetime=require('window_update_lifetime')
    local visualEnd=require('combat_visual_end')
    local energy=require('menu_energy_compat')
    local function install()
        require('tutorial_disabled').install()
        require('manual_formation').install()
        M.installLoading(rawget(_G,'LoginLoading'))
        M.installRoles(rawget(_G,'FightRoleController'))
        M.installBattleLoader(rawget(_G,'FightLoadingCell'))
        tapWait.installTeam(rawget(_G,'FightTeamController'))
        tapWait.installQTE(rawget(_G,'FightQTEController'))
        tapWait.installGuard()
        lifetime.install()
        visualEnd.install(rawget(_G,'FightRole'),'cleanAttackData',false)
        visualEnd.install(rawget(_G,'FightRoleController'),'nextBattle',true)
        energy.install(rawget(_G,'Menu'))
        require('intro_menu_transition').install()
        require('pve_entry_ready').install()
        require('campaign_runtime').install()
        require('tutorial_battle_skip').install()
        require('tutorial_guide_visual').install(rawget(_G,'TuitionController'))
        require('tutorial_synthesis_target').install(rawget(_G,'TuitionController'))
        require('profile_parser_dependencies').install()
        require('shop_local').install()
        require('quest_local').install()
        require('hero_ui_compat').install()
        require('formation_lifetime').install()
        require('formation_empty_slots').install(rawget(_G,'HomeHero'))
        require('recruit_visible_hero').install(rawget(_G,'HeroRecruitSuccess'))
        require('recruit_visible_hero').installTen(rawget(_G,'HeroRecruitSuccessTen'))
        local recruitResults=require('recruit_results')
        require('recruit_lobby').install(rawget(_G,'HeroRecruitListView'))
        recruitResults.install(rawget(_G,'HeroRecruitSuccess'),1,'hero_recruit_success_renturn_shop_page')
        recruitResults.install(rawget(_G,'HeroRecruitSuccessTen'),10,'hero_recruit_success_ten_renturn_shop_page')
        recruitResults.install(rawget(_G,'HeroRecruitLegacySuccess'),1,'hero_recruit_legacy_success_renturn_shop_page')
        recruitResults.install(rawget(_G,'HeroRecruitLegacySuccessTen'),10,'hero_recruit_legacy_success_ten_renturn_shop_page')
        -- Pedido do jogador: as conversas entre personagens nao aparecem mais.
        -- A janela continua concluindo o evento (o tutorial segue avancando).
        require('esconder_dialogos').install(rawget(_G,'RoleDialogue'))
        -- _ED.mega_info fica nil porque o servidor local nao envia o bloco
        -- 12690; getAbilityFromBaMen faz pairs(nil) e derruba o cliente ao
        -- abrir a formacao (EnvironmentDatas.lua:12039).
        require('mega_info_seguro').install()
        -- Conta em tutorial que reinicia cai no loader de batalha, que espera
        -- uma batalha que a etapa pode nao ter: ficava presa em 9% sem nunca
        -- mais falar com o servidor. Ver loader_tutorial.lua.
        require('loader_tutorial').ligar()
    end
    app.load=function(...)
        local value=original(...);install();return value
    end
    install()
    note('installed')
end
return M
