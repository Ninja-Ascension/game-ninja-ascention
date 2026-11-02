-- In tutorial battles, retain the team-skill stage until its TAP is pressed.
local M={}
function M.isIntroBattle()
    local user=_ED and _ED.user_info
    if user==nil or tonumber(_ED._scene_npc_id)~=1196 then return false end
    -- The Pain sequence grants XP before its final cutscene. For opted-in
    -- tutorial profiles, the tutorial state and battle NPC remain authoritative
    -- after that grant; requiring l1e0 made the final menu hook miss the exit.
    local state=_ED.nr_initial_tutorial
    local progress=tonumber(_ED._nr_current_mission_progress)
    if state=='playing' or (state=='completed' and progress==2010136) then return true end
    return tonumber(user.user_grade)==1 and tonumber(user.user_experience)==0
end
function M.installGuard()
    if package.__nr_tap_guard or type(furyGuardTick)~='function' then return end
    package.__nr_tap_guard=true
    local original=furyGuardTick
    local originalRelease=furyGuardRelease
    if type(originalRelease)=='function' then
        furyGuardRelease=function(...)
            local team=fwin:find('FightTeamControllerClass')
            M.recovering=true
            if team and team.__nr_await_tap then team.__nr_tap_accepted=true end
            print('HOST_TUTORIAL_TAP watchdog recovery; releasing stalled mission input')
            local result={pcall(originalRelease,...)}
            M.recovering=false
            if not result[1] then error(result[2],0) end
            return unpack(result,2)
        end
    end
    furyGuardTick=function(...)
        -- Keep the mission watchdog active during the introduction too. The
        -- reconstructed route can otherwise remain paused forever if a battle
        -- QTE/input event is lost by the client.
        return original(...)
    end
end
function M.installTeam(class)
    if type(class)~='table' or class.__nr_tap_wait then return end
    local update,finish,tap=class.updateMaster,class.teamFightEnd,class.skeepTeamFight
    if type(update)~='function' or type(finish)~='function' or type(tap)~='function' then return end
    class.__nr_tap_wait=true
    class.updateMaster=function(self,...)
        self.__nr_await_tap=((M.isIntroBattle()
            or (type(missionIsOver)=='function' and missionIsOver()==false))
            and self.hero~=nil and tonumber(self.hero.roleCamp)==0)
        self.__nr_tap_accepted=false
        local result={pcall(update,self,...)}
        if not result[1] then self.__nr_await_tap=false;error(result[2],0) end
        return unpack(result,2)
    end
    class.teamFightEnd=function(self,...)
        if self.__nr_await_tap and not self.__nr_tap_accepted then
            print('HOST_TUTORIAL_TAP waiting; automatic completion deferred')
            return
        end
        local result={finish(self,...)}
        self.__nr_await_tap=false
        local qte=fwin:find('FightQTEControllerClass')
        if qte and qte.totalHurtRoot and type(qte.updateDrawPowerSkillTotalDamage)=='function' then
            qte:updateDrawPowerSkillTotalDamage(0)
        end
        return unpack(result)
    end
    class.skeepTeamFight=function(self,...)
        self.__nr_tap_accepted=true
        local result={pcall(tap,self,...)}
        self.__nr_tap_accepted=false
        if not result[1] then error(result[2],0) end
        return unpack(result,2)
    end
end
function M.installQTE(class)
    if type(class)~='table' or class.__nr_tap_qte then return end
    if type(class.qteToAutoNextAttackRole)~='function' then return end
    class.__nr_tap_qte=true
    local original=class.qteToAutoNextAttackRole
    class.qteToAutoNextAttackRole=function(self,...)
        local team=fwin:find('FightTeamControllerClass')
        if team and team.__nr_await_tap then
            -- Automatic progression passes nil/0 here. The visible TAP button
            -- passes its touch metadata, which must be allowed to release the
            -- exact wait installed by updateMaster.
            local params=select(1,...)
            local ok,data=pcall(function() return params and params._datas end)
            if not ok then data=nil end
            if M.recovering then
                team.__nr_tap_accepted=true
            elseif type(data)~='table' or data.terminal_name~='fight_qte_controller_qte_to_auto_next_attack_role_but' then
                return false
            else
                team.__nr_tap_accepted=true
                print('HOST_TUTORIAL_TAP manual TAP accepted')
            end
        end
        return original(self,...)
    end
end
return M
