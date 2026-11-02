-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛规则
-------------------------------------------------------------------------------------------------------
WorldBossRuleWindow = class("WorldBossRuleWindowClass", Window)

local world_boss_rule_window_open_terminal = {
    _name = "world_boss_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:open(WorldBossRuleWindow:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local world_boss_rule_window_close_terminal = {
    _name = "world_boss_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("WorldBossRuleWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_boss_rule_window_open_terminal)
state_machine.add(world_boss_rule_window_close_terminal)
state_machine.init()

function WorldBossRuleWindow:ctor()
    self.super:ctor()
    self.roots = {}
end

function WorldBossRuleWindow:onUpdate(dt)

end

function WorldBossRuleWindow:onUpdateDraw()

end

function WorldBossRuleWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/world_boss/world_boss_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "world_boss_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
end

function WorldBossRuleWindow:init()

end

function WorldBossRuleWindow:onExit()

end