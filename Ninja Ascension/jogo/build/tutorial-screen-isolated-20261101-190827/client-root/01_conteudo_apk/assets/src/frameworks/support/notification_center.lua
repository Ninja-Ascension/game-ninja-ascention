local NotificationCenter = {running = true}
local notificationers = {}
local wait_notificationers = {}

-- notificationer infomation
-- local notificationer = {
--     _terminal_name,
--     _widget,
--     _invoke,
--     _interval,
--     _elapsed,
--     _deadth,
-- }

-- Initialize notification center state machine.
local function init_notification_center_terminal()
    local notification_center_register_terminal = {
        _name = "notification_center_register",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            for i, v in pairs(wait_notificationers) do
                if v._widget == params._widget then
                    return
                end
            end
            for i, v in pairs(notificationers) do
                if v._widget == params._widget then
                    return
                end
            end
            local notificationer = {
                _terminal_name = params._terminal_name,
                _widget = params._widget,
                _invoke = params._invoke,
                _interval = zstring.tonumber(params._interval),
                _elapsed = 0,
                _deadth = false,
                _running = true,
                _update = true,
                _datas = params
            }
            if notificationer._widget ~= nil 
                and ((notificationer._terminal_name ~= nil and notificationer._terminal_name ~= "") or notificationer._invoke ~= nil)
                and notificationer._interval >= 0
                and notificationer._widget.getParent ~= nil 
                and notificationer._widget:getParent() ~= nil 
                then
                if notificationer._interval <= 0 then
                    notificationer._interval = 1
                end
                notificationer._widget:retain()
                table.insert(wait_notificationers, notificationer)
            end
            app.notification_center.running = true
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local notification_center_update_terminal = {
        _name = "notification_center_update",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            for i, v in pairs(notificationers) do
                if v._terminal_name == params then
                    v._update = true
                    -- v._update = false
                    -- if (v._terminal_name ~= nil and v._terminal_name ~= "") then
                    --     state_machine.excute(v._terminal_name, 0, v)
                    -- elseif v._invoke ~= nil then
                    --     v._invoke(v)
                    -- end
                end
            end
            app.notification_center.running = true
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local notification_center_remove_terminal = {
        _name = "notification_center_remove",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            for i = #notificationers, 1, -1 do
                v = notificationers[i]
                if v._terminal_name == params then
                    v._deadth = true
                    table.remove(notificationers, i)
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local notification_center_remove_widget_terminal = {
        _name = "notification_center_remove_widget",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local widget = params._widget
            for i, v in pairs(wait_notificationers) do
                if v._widget == widget then
                    table.remove(wait_notificationers, i)
                    break
                end
            end
            for i, v in pairs(notificationers) do
                if v._widget == widget then
                    table.remove(notificationers, i)
                    break
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(notification_center_register_terminal)
    state_machine.add(notification_center_update_terminal)
    state_machine.add(notification_center_remove_terminal)
    state_machine.add(notification_center_remove_widget_terminal)
    state_machine.init()
end
init_notification_center_terminal()

function NotificationCenter.updateNotificationCenter(dt)
    for i, v in pairs(wait_notificationers) do
        table.insert(notificationers, v)
    end
    
    wait_notificationers = {}

    for i, v in pairs(notificationers) do
        if v._deadth == false and v._widget.getParent ~= nil and v._widget:getParent() ~= nil then
            v._elapsed = v._elapsed + dt
            if v._elapsed >= v._interval or true == v._update then
                v._elapsed = 0
                v._update = false
                if (v._terminal_name ~= nil and v._terminal_name ~= "") then
                    state_machine.excute(v._terminal_name, 0, v)
                elseif v._invoke ~= nil then
                    v._invoke(v)
                end
            end
        else
            if v._widget ~= nil then
                v._widget:release()
                v._widget = nil
            end
            v._deadth = true
        end
    end


    for i, v in pairs(notificationers) do
        if v._deadth == true then
            table.remove(notificationers, i)
        end
    end
end
return NotificationCenter