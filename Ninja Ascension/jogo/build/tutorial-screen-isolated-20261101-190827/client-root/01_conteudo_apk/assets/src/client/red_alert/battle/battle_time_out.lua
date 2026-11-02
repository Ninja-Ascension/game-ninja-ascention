-- ----------------------------------------------------------------------------------------------------
-- 说明：中断战斗
-- ----------------------------------------------------------------------------------------------------
BattleTimeOut = class("BattleTimeOutClass", Window)

local battle_time_out_window_open_terminal = {
    _name = "battle_time_out_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battle_time_out_ui = BattleTimeOut:new():init()
        fwin:open(_battle_time_out_ui,fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_time_out_window_close_terminal = {
    _name = "battle_time_out_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("battle_ui_resume_game",0,"")
        fwin:close(fwin:find("BattleTimeOutClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_time_out_window_open_terminal)
state_machine.add(battle_time_out_window_close_terminal)
state_machine.init()

function BattleTimeOut:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
local function init_battle_time_out_terminal()
        --退出战斗
        local battle_time_out_leave_fight_terminal = {
            _name = "battle_time_out_leave_fight",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- cacher.removeAllTextures()
                -- fwin:reset(nil)
                fwin:removeAll()
                cacher.destorySystemCacher()
                if _ED._battle_init_type == battle_enum._fight_type._fight_type_0 then      -- 普通
                    clearMission()
                    -- state_machine.excute("duplicate_manager_window_open",0,{1})
                    state_machine.excute("duplicate_title_window_open",0,"")
                    state_machine.excute("duplicate_map_window_open",0,"")
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_1 then  -- 精英
                    -- state_machine.excute("duplicate_manager_window_open",0,{2})
                    state_machine.excute("duplicate_title_window_open",0,"")
                    state_machine.excute("duplicate_map_window_open",0,"")
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_15 then -- 炼狱
                    -- state_machine.excute("duplicate_manager_window_open",0,{3})
                    state_machine.excute("duplicate_title_window_open",0,"")
                    state_machine.excute("duplicate_map_window_open",0,"")
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_10 
                    or _ED._battle_init_type == battle_enum._fight_type._fight_type_23    -- 攻城拔寨
                    or _ED._battle_init_type == battle_enum._fight_type._fight_type_105    -- 个人资源争夺
                    then
                    state_machine.excute("campaign_window_open",0,"")
                    state_machine.excute("raiders_cut_window_open",0,"")
                    -- state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1}})
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_11 then
                    state_machine.excute("tourneyfield_window_open",0,"")
                    state_machine.excute("tourneyfield_officer_window_open",0,"")
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_16 then --宝石
                    state_machine.excute("campaign_window_open",0,"")
                    state_machine.excute("gem_duplicate_window_open",0,"")
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_17 then -- 兵器
                    state_machine.excute("campaign_window_open",0,"")
                    state_machine.excute("weaponry_window_open",0,"")
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then  -- 将魂试炼
                    state_machine.excute("campaign_window_open",0,"")
                    state_machine.excute("soul_duplicate_window_open",0,"")
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_19 then  -- 运送军资
                    state_machine.excute("campaign_window_open",0,"")
                    state_machine.excute("ship_military_use_window_open",0,"")
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_102 then
                    state_machine.excute("campaign_window_open",0,"")
                    state_machine.excute("trialtower_window_open",0,"")      
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_21 then  -- 工会组队争霸
                    app.load("client.red_alert.union.Union")
                    state_machine.excute("union_open", 0, "")
                    state_machine.excute("union_team_fight_window_open", 0, nil)
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_22 then  -- 阿拉希之战
                    app.load("client.red_alert.union.Union")
                    state_machine.excute("union_open", 0, "")
                    state_machine.excute("union_get_physical_fight_window_open", 0, nil)
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_103 then -- 神兵副本
                    app.load("client.red_alert.god_weaponry.GodWeaponryDuplicate")
                    state_machine.excute("god_weaponry_duplicate_window_open",0,_ED._god_weaponry_duplicate_level)
                elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_104 then -- 七星台
                    state_machine.excute("seven_star_window_open",0,"")
                    state_machine.excute("seven_star_map_ui_window_open",0,"")
                    state_machine.excute("duplicate_map_window_open",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(battle_time_out_leave_fight_terminal)
        state_machine.init()
    end
    
    -- call func battle_time_out create state machine.
    init_battle_time_out_terminal()    
end

function BattleTimeOut:init()
    self:onInit()
    return self
end


function BattleTimeOut:onEnterTransitionFinish()
end

function BattleTimeOut:onInit()
    local csbItem = csb.createNode(config_csb.battle.battle_time_out)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.battle.battle_time_out)
    table.insert(self.actions,action)
    csbItem:runAction(action)

    --继续
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_battle_time_out_carry_on"), nil, 
    {
        terminal_name = "battle_time_out_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    --退出
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_battle_time_out_drop_out"), nil, 
    {
        terminal_name = "battle_time_out_leave_fight", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)         
end

function BattleTimeOut:close()

end

function BattleTimeOut:destroy()

end

function BattleTimeOut:onExit()
    state_machine.remove("battle_time_out_leave_fight")
end
-- ----------------------------------------------------------------------------------------------------