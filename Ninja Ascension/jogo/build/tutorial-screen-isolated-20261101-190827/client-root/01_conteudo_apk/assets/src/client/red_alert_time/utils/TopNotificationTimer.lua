---------------------------------------------------------------------------------------------
-- 说明：定时器
---------------------------------------------------------------------------------------------
TopNotificationTimer = class("TopNotificationTimerClass", Window)

local top_notification_timer_open_terminal = {
    _name = "top_notification_timer_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
       	local window = fwin:find("TopNotificationTimerClass")
        if window == nil then
	        fwin:open(TopNotificationTimer:new():init(), fwin._notification)
	    end
    end,
    _terminal = nil,
    _terminals = nil
}

local top_notification_timer_close_terminal = {
    _name = "top_notification_timer_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
      	fwin:close(fwin:find("TopNotificationTimerClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(top_notification_timer_open_terminal)
state_machine.add(top_notification_timer_close_terminal)
state_machine.init()

function TopNotificationTimer:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
end

function TopNotificationTimer:onUpdate(dt)
	state_machine.excute("main_window_update_timer", 0, dt)
end

function TopNotificationTimer:init()
	return self
end

function TopNotificationTimer:onEnterTransitionFinish()
    
end

function TopNotificationTimer:onExit()
end
