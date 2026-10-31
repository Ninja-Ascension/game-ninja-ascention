CaptureSearchPos = class("CaptureSearchPosClass", Window)

local capture_search_pos_open_terminal = {
	_name = "capture_search_pos_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local CaptureSearchPosWindow = fwin:find("CaptureSearchPosClass")
		if CaptureSearchPosWindow ~= nil and CaptureSearchPosWindow:isVisible() == true then
			return true
		end
        state_machine.lock("capture_search_pos_open")
		fwin:open(CaptureSearchPos:new(), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local capture_search_pos_close_terminal = {
	_name = "capture_search_pos_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local CaptureSearchPosWindow = fwin:find("CaptureSearchPosClass")
		if CaptureSearchPosWindow ~= nil then
			fwin:close(CaptureSearchPosWindow)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(capture_search_pos_open_terminal)
state_machine.add(capture_search_pos_close_terminal)
state_machine.init()

function CaptureSearchPos:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local capture_resource_search_pos_terminal = {
        _name = "capture_resource_search_pos",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	instance:detachWithIME()
        	local root = self.roots[1]
        	local textX = ccui.Helper:seekWidgetByName(root, "TextField_1_x")
        	local textY = ccui.Helper:seekWidgetByName(root, "TextField_1_y")
        	local textMap = ccui.Helper:seekWidgetByName(root, "TextField_1_map")
			local TextFieldStringX = textX:getString()
			local TextFieldStringY = textY:getString()
			local TextFieldStringMap = textMap:getString()

            state_machine.excute("capture_resource_begin_search_pos", 0, {TextFieldStringMap, TextFieldStringX, TextFieldStringY})
			state_machine.excute("capture_search_pos_close", 0, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local capture_resource_search_pos_close_terminal = {
        _name = "capture_resource_search_pos_close",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	state_machine.excute("capture_search_pos_close", 0, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(capture_resource_search_pos_terminal)
    state_machine.add(capture_resource_search_pos_close_terminal)
    state_machine.init()
end

function CaptureSearchPos:init()
end

function CaptureSearchPos:detachWithIME()
	local root = self.roots[1]
	local textX = ccui.Helper:seekWidgetByName(root, "TextField_1_x")
	local textY = ccui.Helper:seekWidgetByName(root, "TextField_1_y")
	local textMap = ccui.Helper:seekWidgetByName(root, "TextField_1_map")
	textX:didNotSelectSelf()
	textY:didNotSelectSelf()
	textMap:didNotSelectSelf()
    fwin._framewindow:setPosition(cc.p(0, 0))
end

function CaptureSearchPos:onEnterTransitionFinish()
    local csbCaptureSearch = csb.createNode("secret_society/secret_society_sousuo.csb")
    local root = csbCaptureSearch:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbCaptureSearch)

    local textX = ccui.Helper:seekWidgetByName(root, "TextField_1_x")
	draw:addEditBox(textX, _string_piece_info[412], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_qianwang"), 16, cc.KEYBOARD_RETURNTYPE_DONE)
	
	local textY = ccui.Helper:seekWidgetByName(root, "TextField_1_y")
	draw:addEditBox(textY, _string_piece_info[413], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_qianwang"), 16, cc.KEYBOARD_RETURNTYPE_DONE)
	
	local textMap = ccui.Helper:seekWidgetByName(root, "TextField_1_map")
	draw:addEditBox(textMap, _string_piece_info[414], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_qianwang"), 16, cc.KEYBOARD_RETURNTYPE_DONE)


	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianwang"), nil, 
    {
        terminal_name = "capture_resource_search_pos",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_sousuo"), nil, 
    {
        terminal_name = "capture_resource_search_pos_close",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)

    state_machine.unlock("capture_search_pos_open")
end

function CaptureSearchPos:onExit()
	state_machine.remove("capture_resource_search_pos")
	state_machine.remove("capture_resource_search_pos_close")
end
