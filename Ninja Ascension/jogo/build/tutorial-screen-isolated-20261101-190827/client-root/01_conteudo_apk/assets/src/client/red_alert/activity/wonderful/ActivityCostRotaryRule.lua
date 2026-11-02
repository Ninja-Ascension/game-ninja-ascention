-----------------------------
-- 至尊转盘规则
-----------------------------
ActivityCostRotaryRule = class("ActivityCostRotaryRuleClass", Window)

local activity_cost_rotary_rule_window_open_terminal = {
    _name = "activity_cost_rotary_rule_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        fwin:open(ActivityCostRotaryRule:new():init(), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_cost_rotary_rule_window_close_terminal = {
    _name = "activity_cost_rotary_rule_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityCostRotaryRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_cost_rotary_rule_window_open_terminal)
state_machine.add(activity_cost_rotary_rule_window_close_terminal)
state_machine.init()

function ActivityCostRotaryRule:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize NationalWarMap state machine.
    local function init_activity_cost_rotary_rule_terminal()

    end
    
    -- call func init rebirth state machine.
    init_activity_cost_rotary_rule_terminal()
end

function ActivityCostRotaryRule:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.activity_cost_rotary_rule)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --关闭 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "activity_cost_rotary_rule_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
end

function ActivityCostRotaryRule:onUpdate(dt)
    
end

function ActivityCostRotaryRule:init()
    self:onInit()
    return self
end

function ActivityCostRotaryRule:onExit()

end
