-- ----------------------------------------------------------------------------------------------------
-- 说明：探索积分
-------------------------------------------------------------------------------------------------------
ExplorationAllFinishCatchRule = class("ExplorationAllFinishCatchRuleClass", Window)

local exploration_all_finish_catch_rule_window_open_terminal = {
    _name = "exploration_all_finish_catch_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExplorationAllFinishCatchRuleClass") == nil then
            fwin:open(ExplorationAllFinishCatchRule:new():init(params), fwin._view)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_all_finish_catch_rule_window_close_terminal = {
    _name = "exploration_all_finish_catch_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationAllFinishCatchRuleClass") then
            fwin:close(fwin:find("ExplorationAllFinishCatchRuleClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_all_finish_catch_rule_window_open_terminal)
state_machine.add(exploration_all_finish_catch_rule_window_close_terminal)
state_machine.init()

function ExplorationAllFinishCatchRule:ctor()
    self.super:ctor()
    self.roots = {}
end

function ExplorationAllFinishCatchRule:init(params)
    return self
end

function ExplorationAllFinishCatchRule:onUpdate(dt)

end

function ExplorationAllFinishCatchRule:onUpdateDraw()
    local root = self.roots[1]
end

function ExplorationAllFinishCatchRule:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_catch_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 开启
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "exploration_all_finish_catch_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
end

function ExplorationAllFinishCatchRule:onExit()

end
