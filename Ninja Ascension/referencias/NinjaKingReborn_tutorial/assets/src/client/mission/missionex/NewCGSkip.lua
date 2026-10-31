
NewCGSkip = class("NewCGSkipClass", Window)


local new_cg_skip_window_open_terminal = {
	_name = "new_cg_skip_window_open",
	_init = function (terminal)

	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("NewCGSkipClass") then
			fwin:open(NewCGSkip:new():init(params), fwin._system)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}


local new_cg_skip_window_close_terminal = {
	_name = "new_cg_skip_window_close",
	_init = function (terminal)

	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("NewCGSkipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_cg_skip_window_open_terminal)
state_machine.add(new_cg_skip_window_close_terminal)
state_machine.init()


function NewCGSkip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}



	self.deleteEffectCallback = nil




	local function init_new_cg_skip_terminal()

		local new_cg_skip_open_terminal = {
			_name = "new_cg_skip_open",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		local new_cg_skip_close_terminal = {
			_name = "new_cg_skip_close",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local windowLock = fwin:find("WindowLockClass")
                if windowLock == nil then
                    fwin:open(WindowLock:new():init(), fwin._windows)
                end

				if instance ~= nil then
					if instance.deleteEffectCallback ~= nil and instance.armatureBack ~= nil then
						instance.deleteEffectCallback(instance.armatureBack)
					end

					state_machine.excute("new_cg_skip_window_close", 0, 0)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		local new_cg_skip_show_terminal = {
			_name = "new_cg_skip_show",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)

				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		local new_cg_skip_hide_terminal = {
			_name = "new_cg_skip_hide",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)

				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(new_cg_skip_open_terminal)
		state_machine.add(new_cg_skip_close_terminal)
		state_machine.add(new_cg_skip_show_terminal)
		state_machine.add(new_cg_skip_hide_terminal)
		state_machine.init()
	end

	init_new_cg_skip_terminal()
end


function NewCGSkip:init(params)
	self.deleteEffectCallback = params.deleteEffectCallback
	self.armatureBack = params.armatureBack
	return self
end

function NewCGSkip:onUpdateDraw()
	local root = self.roots[1]
end

function NewCGSkip:onEnterTransitionFinish()


	local csbNode = csb.createNode("events_interpretation/new_event_cg_skip.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)


	local function trigger_onTouchEvent(sender, eventType)
		local donateType = sender:getTag()
		if eventType == ccui.TouchEventType.began then

		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			state_machine.excute("new_cg_skip_close", 0, 0)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_1"):addTouchEventListener(trigger_onTouchEvent)

	self:onUpdateDraw()
end

function NewCGSkip:onExit()

	state_machine.remove("new_cg_skip_open")
	state_machine.remove("new_cg_skip_close")
	state_machine.remove("new_cg_skip_show")
	state_machine.remove("new_cg_skip_hide")
end

function NewCGSkip:close()


end

function NewCGSkip:destroy(window)


end



