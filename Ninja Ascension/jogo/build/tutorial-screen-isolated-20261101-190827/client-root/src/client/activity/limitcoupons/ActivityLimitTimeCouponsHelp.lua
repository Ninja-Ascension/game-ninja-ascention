-- ----------------------------------------------------------------------------------------------------
-- 说明：限时优惠帮助
-------------------------------------------------------------------------------------------------------

ActivityLimitTimeCouponsHelp = class("ActivityLimitTimeCouponsHelpClass", Window)
   
local activity_limit_time_coupons_help_window_open_terminal = {
    _name = "activity_limit_time_coupons_help_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityLimitTimeCouponsHelpClass") then
        	local helpWindow = ActivityLimitTimeCouponsHelp:new()
			helpWindow:init()
			fwin:open(helpWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_limit_time_coupons_help_window_close_terminal = {
    _name = "activity_limit_time_coupons_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityLimitTimeCouponsHelpClass"))
        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_limit_time_coupons_help_window_open_terminal)
state_machine.add(activity_limit_time_coupons_help_window_close_terminal)
state_machine.init()
  
function ActivityLimitTimeCouponsHelp:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
    -- Initialize Home page state machine.
    local function init_activity_limit_time_coupons_help_terminal()
        
    end
    
    init_activity_limit_time_coupons_help_terminal()
end

function ActivityLimitTimeCouponsHelp:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
end

function ActivityLimitTimeCouponsHelp:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("activity/wonderful/limited_time_discount_help.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_105"), nil, 
	{
		terminal_name = "activity_limit_time_coupons_help_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_269"), nil, 
    {
        terminal_name = "activity_limit_time_coupons_help_window_close",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)
end

function ActivityLimitTimeCouponsHelp:onExit()
end

function ActivityLimitTimeCouponsHelp:init()
	
end
