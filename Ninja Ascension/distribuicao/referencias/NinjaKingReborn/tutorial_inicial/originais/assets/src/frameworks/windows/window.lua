


Window = class("WindowClass",function(instance, ...)


    local layer = ccui.Layout:create()
    layer:setAnchorPoint(cc.p(0, 0))
    layer:setContentSize(cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY))
    local multi = instance.__cmulti
    if multi == false then
        local flayer = fwin:find(instance.__cname)
        multi = flayer == nil and true or false
	end

    fwin._instance = fwin._instance + 1
    layer._instanceId = fwin._instance

    return layer, multi
end)

function Window:ctor()

end

function Window:scheduler(_scheduleName, _func, _interval, _paused)
    if self.schedules == nil then
        self.schedules = {}
    end
    local schedulerEntry = app.scheduler:scheduleScriptFunc(_func, _interval, false)
    self.schedules[_scheduleName] = schedulerEntry
    return schedulerEntry
end

function Window:unscheduler(_unscheduleName)
    local schedulerEntry = self.schedules[_unscheduleName]
    if schedulerEntry ~= nil then
        app.scheduler:unscheduleScriptEntry(schedulerEntry)
        self.schedules[_unscheduleName] = nil
    end
end

function Window:registerOnNodeEvent(_windows)
    _windows.onNodeEvent = function (event)
        if event == "enter" then
        	if _windows.onEnter ~= nil then
        		_windows:onEnter()
        	end
        elseif event == "enterTransitionFinish" then
        	if _windows.onEnterTransitionFinish ~= nil then
        		_windows:onEnterTransitionFinish()
        	end
        elseif event == "exitTransitionStart" then
        	if _windows.onExitTransitionStart ~= nil then
        		_windows:onExitTransitionStart()
        	end
        elseif event == "exit" then
            _windows:unscheduleUpdate()
        	if _windows.onExit ~= nil then
        		_windows:onExit()
        	end
        elseif event == "cleanup" then
        	if _windows.onCleanup ~= nil then
        		_windows:onCleanup()
        		_windows._isDeathed = true
        	end
        end
    end

	_windows:registerScriptHandler(_windows.onNodeEvent)
end

function Window:registerOnNoteUpdate(_windows, _interval)
    if _windows.onUpdate ~= nil then
        _windows.onNoteUpdate = function (dt)







                if _windows.onUpdate ~= nil then

                    _windows:onUpdate(fury_game_speed ~= nil and fury_game_speed.real_dt(dt) or dt)
        	    end







    	end
        if _windows.__cdt ~= nil then
            _windows:runAction(cc.RepeatForever:create(
                cc.Sequence:create(
                    cc.DelayTime:create(_windows.__cdt),


                    cc.CallFunc:create(function ( sender )



                            sender:onUpdate(fury_game_speed ~= nil and fury_game_speed.real_dt(sender.__cdt) or sender.__cdt)







                    end))
                )
            )
        else
    	   _windows:scheduleUpdateWithPriorityLua(_windows.onNoteUpdate,  _interval or 0)
        end
    end
end

function Window:unregisterOnNoteUpdate(_windows)
    _windows:unscheduleUpdate()
    _windows.onNoteUpdate = nil
end

function Window:addTimer(_func, _delay, _interval, _loop, _params)
    if not self.timers then
        self.timers = {}
    end
    local timer = {
        func = _func,
        delay = _delay,
        interval = interval,
        ditime = _delay + _interval,
        loop = _loop,
        time = 0.0,
        over = false,
        params = _params
    }
    table.insert(self.timers, timer)







end

function Window:timerLua(dt)




    if self.time == nil then
        self.time = 0.0
    end
    self.time = self.time + tonumber(dt)
    if self.timers ~= nil then
        for i, v in ipairs(self.timers) do
            if v ~= nil and v.over ~= true then
                v.time = v.time + dt
                if v.time > v.ditime then
                    v.time = v.time - v.ditime
                    if v.func ~= nil then
                        v.func(v.params)
                    end
                    if v.loop ~= true then
                        v.over = true
                    end
                end
            end
        end
    end
end





function Window:updateLua(dt)
    self:onUpdate(dt)
end

function Window:onEnter()

end

function Window:enter()
    self.time = 0.0
    self:onEnter()
end

function Window:onEnterTransitionFinish()

end

function Window:enterTransitionFinish()
    self:onEnterTransitionFinish()
end

function Window:onExitTransitionStart()

end

function Window:exitTransitionStart()
    self:onExitTransitionStart()
end

function Window:onCheckCovers(window)
    if nil ~= window and true == window.__check_covers then
        fwin:checkCovers(nil, window)
    end
end

function Window:onExit()

end

function Window:exitLua(window)
    if self.schedules ~= nil then
        for i, v in pairs(self.schedules) do
            self:unscheduler(i)
        end
    end
    self:onExit()
end

function Window:onCleanup(window)

end

function Window:cleanupLua(window)
    self:onCleanup()
end

function Window:open(window)

end

function Window:hide(window)

end

function Window:back(window)

end

function Window:close(window)

end

function Window:clean()

end

function Window:destroy(window)
    if nil ~= window and true == window.__check_covers then
        fwin:unAllCovers(nil, false, window)
    end
end

function Window:quit(window)

end

