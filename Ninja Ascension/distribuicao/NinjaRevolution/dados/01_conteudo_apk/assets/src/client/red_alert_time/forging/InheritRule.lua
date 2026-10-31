-----------------------------
-- 规则
-----------------------------
InheritRule = class("InheritRuleClass", Window)
--打开
local inherit_rule_window_open_terminal = {
    _name = "inherit_rule_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(InheritRule:new():init(), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local inherit_rule_window_close_terminal = {
    _name = "inherit_rule_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("InheritRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(inherit_rule_window_open_terminal)
state_machine.add(inherit_rule_window_close_terminal)
state_machine.init()

function InheritRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end

function InheritRule:onInit( )
    local csbItem = csb.createNode(config_csb.forging.inherit_rule)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    -- local action = csb.createTimeline(config_csb.forging.inherit_rule)
    -- table.insert(self.actions, action)
    -- csbItem:runAction(action)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "inherit_rule_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

end

function InheritRule:init()
	self:onInit()
    return self
end

function InheritRule:onExit()
end