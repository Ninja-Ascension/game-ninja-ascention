-----------------------------

SmActivityActiveHelp = class("SmActivityActiveHelpClass", Window)

local sm_activity_active_help_window_open_terminal = {
    _name = "sm_activity_active_help_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmActivityActiveHelpClass") == nil then
            local panel = SmActivityActiveHelp:new():init(params)
            fwin:open(panel, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_active_help_window_close_terminal = {
    _name = "sm_activity_active_help_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmActivityActiveHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_active_help_window_open_terminal)
state_machine.add(sm_activity_active_help_window_close_terminal)
state_machine.init()

function SmActivityActiveHelp:ctor()
    self.super:ctor()
    self.roots = {}
end

function SmActivityActiveHelp:onEnterTransitionFinish()

end

function SmActivityActiveHelp:onInit( )
    local csbItem = csb.createNode("activity/wonderful/sm_active_rule.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_activity_active_help_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmActivityActiveHelp:init(params)  
	self:onInit()
    return self
end

function SmActivityActiveHelp:onExit()
end
