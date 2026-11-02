-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛规则
-------------------------------------------------------------------------------------------------------
ExplorationRuleWindow = class("ExplorationRuleWindowClass", Window)

local exploration_rule_window_open_terminal = {
    _name = "exploration_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:open(ExplorationRuleWindow:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_rule_window_close_terminal = {
    _name = "exploration_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("ExplorationRuleWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_rule_window_open_terminal)
state_machine.add(exploration_rule_window_close_terminal)
state_machine.init()

function ExplorationRuleWindow:ctor()
    self.super:ctor()
    self.roots = {}
end

function ExplorationRuleWindow:onUpdate(dt)

end

function ExplorationRuleWindow:onUpdateDraw()

end

function ExplorationRuleWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "exploration_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
end

function ExplorationRuleWindow:init()

end

function ExplorationRuleWindow:onExit()

end