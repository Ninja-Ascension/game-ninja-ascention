--------------------------------------------------------------------------------------------------------------
--  说明：阵营对决-战斗信息
--------------------------------------------------------------------------------------------------------------
CampPkBattleMyInfo = class("CampPkBattleMyInfoClass", Window)

--打开界面
local camp_pk_battle_my_info_open_terminal = {
	_name = "camp_pk_battle_my_info_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = CampPkBattleMyInfo:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

local camp_pk_battle_my_info_close_terminal = {
    _name = "camp_pk_battle_my_info_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CampPkBattleMyInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(camp_pk_battle_my_info_open_terminal)
state_machine.add(camp_pk_battle_my_info_close_terminal)
state_machine.init()

function CampPkBattleMyInfo:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    local function init_camp_pk_battle_my_info_terminal()
        local camp_pk_battle_my_info_update_terminal = {
            _name = "camp_pk_battle_my_info_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_battle_my_info_update_terminal)
        state_machine.init()
    end
    
    init_camp_pk_battle_my_info_terminal()
end

function CampPkBattleMyInfo:updateDraw()
    local root = self.roots[1]
    local Text_camp_pk_battle_troops_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_troops_n")
    local Text_camp_pk_battle_meritorious_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_meritorious_n")
    local Text_camp_pk_battle_vic_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_vic_n")
    local Text_camp_pk_battle_camp_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_camp_n")
    local Text_camp_pk_battle_integral_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_integral_n")
    local Text_camp_pk_battle_straight_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_straight_n")

    Text_camp_pk_battle_troops_n:setString(_ED.camp_pk_battle_user_info.live_percent.."%")
    Text_camp_pk_battle_meritorious_n:setString(_ED.camp_pk_battle_user_info.get_con)
    Text_camp_pk_battle_vic_n:setString(_ED.camp_pk_battle_user_info.win_times)
    if tonumber(_ED.camp_pk_user_info.camp_state) == 0 then
        Text_camp_pk_battle_camp_n:setString(tipStringInfo_campaign_info[44])
        Text_camp_pk_battle_camp_n:setColor(cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]))
    elseif tonumber(_ED.camp_pk_user_info.camp_state) == 1 then
        Text_camp_pk_battle_camp_n:setString(tipStringInfo_campaign_info[45])
        Text_camp_pk_battle_camp_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    end
    Text_camp_pk_battle_integral_n:setString(_ED.camp_pk_battle_user_info.get_score)
    Text_camp_pk_battle_straight_n:setString(_ED.camp_pk_battle_user_info.max_straight_times)
end

function CampPkBattleMyInfo:onInit()
    local csbItem = csb.createNode(string.format(config_csb.cells.campaign.camp_pk_battle_cell, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function CampPkBattleMyInfo:onEnterTransitionFinish()

end

function CampPkBattleMyInfo:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function CampPkBattleMyInfo:onExit()
    state_machine.remove("camp_pk_battle_my_info_update")
end