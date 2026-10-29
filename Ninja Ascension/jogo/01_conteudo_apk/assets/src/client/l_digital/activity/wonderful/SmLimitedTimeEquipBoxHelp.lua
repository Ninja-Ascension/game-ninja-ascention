-----------------------------
--限时宝箱规则说明
-----------------------------
SmLimitedTimeEquipBoxHelp = class("SmLimitedTimeEquipBoxHelpClass", Window)

--打开界面
local sm_limited_time_equip_box_help_open_terminal = {
	_name = "sm_limited_time_equip_box_help_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmLimitedTimeEquipBoxHelpClass") == nil then
			fwin:open(SmLimitedTimeEquipBoxHelp:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_limited_time_equip_box_help_close_terminal = {
	_name = "sm_limited_time_equip_box_help_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmLimitedTimeEquipBoxHelpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_limited_time_equip_box_help_open_terminal)
state_machine.add(sm_limited_time_equip_box_help_close_terminal)
state_machine.init()

function SmLimitedTimeEquipBoxHelp:ctor()
	self.super:ctor()
	self.roots = {}

	self._activity_type = 0

    app.load("client.l_digital.cells.activity.wonderful.sm_limited_time_equip_box_help_infor_cell")
    app.load("client.l_digital.cells.activity.wonderful.sm_limited_time_equip_box_help_reward_cell")

    local function init_sm_limited_time_equip_box_help_terminal()

    end
    init_sm_limited_time_equip_box_help_terminal()
end

function SmLimitedTimeEquipBoxHelp:onUpdateDraw()
    local root = self.roots[1]
    local ListView_xsbx_rule = ccui.Helper:seekWidgetByName(root,"ListView_xsbx_rule")
    ListView_xsbx_rule:removeAllItems()

    -- 说明
    local cell = state_machine.excute("sm_limited_time_equip_box_help_infor_cell_create", 0, "")
    ListView_xsbx_rule:addChild(cell)

    local activity_info = _ED.active_activity[self._activity_type]
    local activity_params = zstring.split(activity_info.activity_params, "!")
    local rank_reward_info = zstring.split(activity_params[3], "%$")

    -- 奖励
    for k, v in pairs(rank_reward_info) do
    	local cell = state_machine.excute("sm_limited_time_equip_box_help_reward_cell_create", 0, {k, v})
    	ListView_xsbx_rule:addChild(cell)
    end

    ListView_xsbx_rule:requestRefreshView()
end

function SmLimitedTimeEquipBoxHelp:init(params)
	self._activity_type = params[1]
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmLimitedTimeEquipBoxHelp:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_limited_time_equip_box_help_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()

end

function SmLimitedTimeEquipBoxHelp:onEnterTransitionFinish()
    
end


function SmLimitedTimeEquipBoxHelp:onExit()

end

