-----------------------------

SmRoleInfomationRebirthHelp = class("SmRoleInfomationRebirthHelpClass", Window)

local sm_role_infomation_rebirth_help_open_terminal = {
	_name = "sm_role_infomation_rebirth_help_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmRoleInfomationRebirthHelpClass") == nil then
			fwin:open(SmRoleInfomationRebirthHelp:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_role_infomation_rebirth_help_close_terminal = {
	_name = "sm_role_infomation_rebirth_help_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmRoleInfomationRebirthHelpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_role_infomation_rebirth_help_open_terminal)
state_machine.add(sm_role_infomation_rebirth_help_close_terminal)
state_machine.init()

function SmRoleInfomationRebirthHelp:ctor()
	self.super:ctor()
	self.roots = {}
end

function SmRoleInfomationRebirthHelp:onUpdateDraw( ... )
	local root = self.roots[1]
    local ListView_rule = ccui.Helper:seekWidgetByName(root, "ListView_rule")
    ListView_rule:removeAllItems()

    local csbItem = csb.createNode("packs/HeroStorage/generals_rebirth_rule.csb")
    root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    ListView_rule:addChild(root)
end

function SmRoleInfomationRebirthHelp:init(params)
	self:onInit()
    return self
end

function SmRoleInfomationRebirthHelp:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_rule.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_help_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
	self:onUpdateDraw()
end

function SmRoleInfomationRebirthHelp:onEnterTransitionFinish()
end

function SmRoleInfomationRebirthHelp:onExit()
end
