-- ----------------------------------------------------------------------------------------------------
-- 说明：pvp战斗敌方技能释放控制器
-- ----------------------------------------------------------------------------------------------------
BattlePVPSkillControl = class("BattlePVPSkillControlClass", Window)

local battle_pvp_skill_control_open_terminal = {
    _name = "battle_pvp_skill_control_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattlePVPSkillControlClass"))
        local _battlePVPSkillControl = BattlePVPSkillControl:new():init(params)
        fwin:open(_battlePVPSkillControl)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_pvp_skill_control_close_terminal = {
    _name = "battle_pvp_skill_control_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattlePVPSkillControlClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_pvp_skill_control_open_terminal)
state_machine.add(battle_pvp_skill_control_close_terminal)
state_machine.init()

function BattlePVPSkillControl:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._player_sp = 0

    -- 玩家聚气最大值
    self._player_max_sp = dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_full_player, fight_config.attribute)

    -- 主公技能释放状态 
    self._majesty_info = {}

    -- 是否可以施放主公技能
    self._open_player_skill = false

    -- 怒气技能状态信息
    self._role_sp_info = {}

    -- 战斗类型 false: pve,  true pvp
    self._battle_pvp_type = false

    local function init_battle_pvp_skill_control_terminal()
        -- 释放主公技
        local battle_pvp_skill_use_majesty_skill_terminal = {
            _name = "battle_pvp_skill_use_majesty_skill",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local majesty_id = params[1]
                if majesty_id == nil or majesty_id <= 0 then
                    for i,v in pairs(instance._majesty_info) do
                        if v.majesty_use_times == 0 then
                            majesty_id = v.majesty_id
                            break
                        end
                    end
                end
                if majesty_id == 0 then
                    return
                end
                state_machine.excute("battle_scene_execute_master_skill", 0, {1, majesty_id})
                instance._player_sp = 0
                instance:updateDrawMajestyInfoByUse(majesty_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新玩家的SP
        local battle_pvp_skill_update_player_sp_terminal = {
            _name = "battle_pvp_skill_update_player_sp",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawPlayerSP(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新角色的SP
        local battle_pvp_skill_update_role_sp_terminal = {
            _name = "battle_pvp_skill_update_role_sp",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawRoleSP(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(battle_pvp_skill_use_majesty_skill_terminal)
        state_machine.add(battle_pvp_skill_update_player_sp_terminal)
        state_machine.add(battle_pvp_skill_update_role_sp_terminal)
        state_machine.init()
    end
    
    init_battle_pvp_skill_control_terminal()    
end

function BattlePVPSkillControl:updateDrawPlayerSP(sp)
    self._player_sp = math.min(self._player_max_sp, self._player_sp + sp)
    local persentSp = (self._player_sp / self._player_max_sp / 2)  * 100
    persentSp = math.max(0, math.min(50, persentSp))

    if persentSp >= 50 then
        --怒气满
        if self._open_player_skill == false then
            self._open_player_skill = true
            state_machine.excute("battle_pvp_skill_use_majesty_skill", 0, {0})
        end
    else
        self._open_player_skill = false
    end
end

function BattlePVPSkillControl:updateDrawRoleSP(params)
    for k,v in pairs(self._role_sp_info) do
        if tonumber(v.ship_id) == tonumber(params.shipId) then
            v.role = params.role
            local persentSp = (zstring.tonumber(params.sp) / zstring.tonumber(params.maxSp) / 2)  * 100
            persentSp = math.max(0, math.min(50, persentSp))

            if persentSp >= 50 then
                --怒气满
                state_machine.excute("battle_role_skill_attack", 0, {role = v.role})
            end
        end
    end
end

function BattlePVPSkillControl:initMajestyInfo()
    for i,v in pairs(_ED.other_user_info.majesty_info) do
        if zstring.tonumber(v) ~= 0 then
            local data = {
                majesty_id = tonumber(v),
                majesty_use_times = 0,
            }
            table.insert(self._majesty_info, data)
        end
    end
end

function BattlePVPSkillControl:initSpSkillInfo()
    for idx = 1, 6 do
        local shipId = _ED.other_user_info.ship_formation[idx]
        local ship = _ED.other_user_info.ship_list[shipId]
        local sp_info = {sp = 0, max_sp = 0, ship_id = 0, role = nil}
        if ship ~= nil then
            sp_info.ship_id = shipId
            sp_info.role = ship
        end
        table.insert(self._role_sp_info, sp_info)
    end
end

function BattlePVPSkillControl:updateDrawMajestyInfoByUse(majesty_id)
    local root = self.roots[1]
    for i,v in pairs(self._majesty_info) do
        if v.majesty_id == majesty_id then
            v.majesty_use_times = v.majesty_use_times + 1
        end
    end
end

function BattlePVPSkillControl:init(params)
    self:initSpSkillInfo()
    self:initMajestyInfo()
    return self
end

function BattlePVPSkillControl:onEnterTransitionFinish()
    
end

function BattlePVPSkillControl:close()

end

function BattlePVPSkillControl:destroy()

end

function BattlePVPSkillControl:onExit()

end
-- ----------------------------------------------------------------------------------------------------