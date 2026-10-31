-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险扣除事件
-------------------------------------------------------------------------------------------------------
AdventureCutEvent = class("AdventureCutEventClass", Window)

local adventure_cut_event_open_terminal = {
    _name = "adventure_cut_event_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureCutEventClass") == nil then
            fwin:open(AdventureCutEvent:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_cut_event_close_terminal = {
    _name = "adventure_cut_event_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("AdventureCutEventClass") then
            fwin:close(fwin:find("AdventureCutEventClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_cut_event_open_terminal)
state_machine.add(adventure_cut_event_close_terminal)
state_machine.init()

function AdventureCutEvent:ctor()
    self.super:ctor()
    self.roots = {}
end

function AdventureCutEvent:init(params)
    return self
end

function AdventureCutEvent:onUpdate(dt)
end

function AdventureCutEvent:onUpdateDraw()
    local root = self.roots[1]
    local Text_6 = ccui.Helper:seekWidgetByName(root, "Text_6")
    Text_6:setString(string.format(tipStringInfo_pikachu_tips[2], tonumber(_ED.reduce_user_silver)))
end


function AdventureCutEvent:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/adventure/adv_type.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil, 
    {
        terminal_name = "adventure_cut_event_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function AdventureCutEvent:onExit()

end
