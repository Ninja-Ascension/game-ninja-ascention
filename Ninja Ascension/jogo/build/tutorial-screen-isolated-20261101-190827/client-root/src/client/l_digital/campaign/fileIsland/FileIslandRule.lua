-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛规则
-------------------------------------------------------------------------------------------------------
FileIslandRule = class("FileIslandRuleClass", Window)

local fileIsland_window_rule_window_open_terminal = {
    _name = "fileIsland_window_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:open(FileIslandRule:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local fileIsland_window_rule_window_close_terminal = {
    _name = "fileIsland_window_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("FileIslandRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_window_rule_window_open_terminal)
state_machine.add(fileIsland_window_rule_window_close_terminal)
state_machine.init()

function FileIslandRule:ctor()
    self.super:ctor()
    self.roots = {}
end

function FileIslandRule:onUpdate(dt)

end

function FileIslandRule:onUpdateDraw()

end

function FileIslandRule:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/explore/explore_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule_closed"), nil, 
    {
        terminal_name = "fileIsland_window_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
end

function FileIslandRule:init()

end

function FileIslandRule:onExit()

end