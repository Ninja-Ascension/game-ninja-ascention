-- ----------------------------------------------------------------------------------------------------
-- 说明：折扣贩售
-------------------------------------------------------------------------------------------------------

ActivityDiscountSaleHelp = class("ActivityDiscountSaleHelpClass", Window)
   
local activity_discount_sale_help_window_open_terminal = {
    _name = "activity_discount_sale_help_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityDiscountSaleHelpClass") then
        	local helpWindow = ActivityDiscountSaleHelp:new()
			helpWindow:init()
			fwin:open(helpWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_discount_sale_help_window_close_terminal = {
    _name = "activity_discount_sale_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityDiscountSaleHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_discount_sale_help_window_open_terminal)
state_machine.add(activity_discount_sale_help_window_close_terminal)
state_machine.init()
  
function ActivityDiscountSaleHelp:ctor()
    self.super:ctor()
	self.roots = {}
	

    -- Initialize Home page state machine.
    local function init_activity_discount_sale_help_terminal()
    
    end
    
    init_activity_discount_sale_help_terminal()
end

function ActivityDiscountSaleHelp:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	
end

function ActivityDiscountSaleHelp:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("activity/wonderful/exchange_explanation.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_105"), nil, 
	{
		func_string = [[fwin:close(fwin:find("ActivityDiscountSaleHelpClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_269"), nil, 
    {
        func_string = [[fwin:close(fwin:find("ActivityDiscountSaleHelpClass"))]],   
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)
	
end

function ActivityDiscountSaleHelp:onExit()
	
end

function ActivityDiscountSaleHelp:init(props,needExp,getExp,shipId)
	
end
