-- In tutorial battles, retain the team-skill stage until its TAP is pressed.
local M={}
function M.isIntroBattle()
    local user=_ED and _ED.user_info
    return user~=nil and tonumber(user.user_grade)==1
        and tonumber(user.user_experience)==0 and tonumber(_ED._scene_npc_id)==1196
end
function M.installGuard()
    if package.__nr_tap_guard or type(furyGuardTick)~='function' then return end
    package.__nr_tap_guard=true
    local original=furyGuardTick
    furyGuardTick=function(...)
        -- This watchdog clears mission locks and requests automatic attacks.
        -- The recovered introduction must progress from its real events/input.
        if M.isIntroBattle() then return end
        local team=fwin:find('FightTeamControllerClass')
        if team and team.__nr_await_tap then return end
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
        if team and team.__nr_await_tap then return false end
        return original(self,...)
    end
end
return M
