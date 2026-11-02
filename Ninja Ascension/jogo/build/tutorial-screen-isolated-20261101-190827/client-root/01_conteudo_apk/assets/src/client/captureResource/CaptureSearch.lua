CaptureSearch = class("CaptureSearchClass", Window)

local capture_search_open_terminal = {
	_name = "capture_search_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local CaptureSearchWindow = fwin:find("CaptureSearchClass")
		if CaptureSearchWindow ~= nil and CaptureSearchWindow:isVisible() == true then
			return true
		end
        state_machine.lock("capture_search_open")
		fwin:open(CaptureSearch:new(), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local capture_search_close_terminal = {
	_name = "capture_search_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local CaptureSearchWindow = fwin:find("CaptureSearchClass")
		if CaptureSearchWindow ~= nil then
			fwin:close(CaptureSearchWindow)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(capture_search_open_terminal)
state_machine.add(capture_search_close_terminal)
state_machine.init()

function CaptureSearch:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local capture_resource_search_terminal = {
        _name = "capture_resource_search",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            state_machine.excute("capture_resource_begin_search_capture", 0, params._datas.index)
			state_machine.excute("capture_search_close", 0, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local capture_resource_search_close_terminal = {
        _name = "capture_resource_search_close",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            state_machine.excute("capture_search_close", 0, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(capture_resource_search_terminal)
    state_machine.add(capture_resource_search_close_terminal)
    state_machine.init()
end

function CaptureSearch:init()
end

function CaptureSearch:onEnterTransitionFinish()
    local csbCaptureSearch = csb.createNode("secret_society/secret_look.csb")
    local root = csbCaptureSearch:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbCaptureSearch)

    local action = csb.createTimeline("secret_society/secret_look.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("sousuo_1", false)

    for i=1,5 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_city_ts_"..i), nil, 
	    {
	        terminal_name = "capture_resource_search",
	        terminal_state = 0, 
	        isPressedActionEnabled = false,
	        index = i
	    }, nil, 0)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_21"), nil, 
    {
        terminal_name = "capture_resource_search_close",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    state_machine.unlock("capture_search_open")
end

function CaptureSearch:onExit()
	state_machine.remove("capture_resource_search")
	state_machine.remove("capture_resource_search_close")
end
