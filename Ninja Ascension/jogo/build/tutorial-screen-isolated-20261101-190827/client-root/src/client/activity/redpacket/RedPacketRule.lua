-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服排行规则
-------------------------------------------------------------------------------------------------------
RedPacketRule = class("RedPacketRuleClass", Window)

local red_pack_rule_window_open_terminal = {
    _name = "red_packet_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedPacketRuleClass") == nil then
            fwin:open(RedPacketRule:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_pack_rule_window_close_terminal = {
    _name = "red_packet_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("RedPacketRuleClass") then
            fwin:close(fwin:find("RedPacketRuleClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_pack_rule_window_open_terminal)
state_machine.add(red_pack_rule_window_close_terminal)
state_machine.init()

function RedPacketRule:ctor()
    self.super:ctor()
    self.roots = {}
end

function RedPacketRule:init(params)
    return self
end

function RedPacketRule:onUpdate(dt)
end

function RedPacketRule:onUpdateDraw()
    local root = self.roots[1]
end


function RedPacketRule:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/wonderful/red_packet_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
  
    self:addChild(csbNode)
     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_rule_close"), nil, 
    {
        terminal_name = "red_packet_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function RedPacketRule:onExit()

end
