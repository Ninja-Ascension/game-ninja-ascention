UnionFightingBegin = class("UnionFightingBeginClass", Window)

local union_fighting_begin_open_terminal = {
	_name = "union_fighting_begin_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(UnionFightingBegin:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_begin_close_terminal = {
	_name = "union_fighting_begin_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingBeginClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_begin_open_terminal)
state_machine.add(union_fighting_begin_close_terminal)
state_machine.init()

function UnionFightingBegin:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function UnionFightingBegin:onInit(params)
	local csbNode = csb.createNode(config_csb.big_map.map_legion_battle_open)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local action = csb.createTimeline(config_csb.big_map.map_legion_battle_open)
    table.insert(self.actions, action)

    csbNode:runAction(action)

    action:play("window_open", false)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_over" then
		    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_223"), nil, 
		    {
		        terminal_name = "union_fighting_begin_close", 
		        terminal_state = 0,
		        isPressedActionEnabled = true
		    }, 
		    nil, 0)
        end
    end)
end

function UnionFightingBegin:onEnterTransitionFinish()
end

function UnionFightingBegin:init()
    self:onInit()
	return self
end

function UnionFightingBegin:onExit()

end
