-- ----------------------------------------------------------------------------------------------------
-- 说明：秘宝规则
-------------------------------------------------------------------------------------------------------
TreasureRuleWindow = class("TreasureRuleWindowClass", Window)

local treasure_rule_window_open_terminal = {
    _name = "treasure_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("TreasureRuleWindowClass") == nil then
            fwin:open(TreasureRuleWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local treasure_rule_window_close_terminal = {
    _name = "treasure_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("TreasureRuleWindowClass") then
            fwin:close(fwin:find("TreasureRuleWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(treasure_rule_window_open_terminal)
state_machine.add(treasure_rule_window_close_terminal)
state_machine.init()

function TreasureRuleWindow:ctor()
    self.super:ctor()
    self.roots = {}
end

function TreasureRuleWindow:init(params)
    return self
end

function TreasureRuleWindow:onUpdate(dt)
end

function TreasureRuleWindow:onUpdateDraw()
    local root = self.roots[1]
end


function TreasureRuleWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/wonderful/rare_treasure_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil, 
    {
        terminal_name = "treasure_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function TreasureRuleWindow:onExit()

end
