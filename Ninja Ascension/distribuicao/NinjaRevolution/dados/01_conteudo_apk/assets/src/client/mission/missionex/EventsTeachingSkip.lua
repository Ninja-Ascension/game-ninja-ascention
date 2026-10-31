-- ----------------------------------------------------------------------------------------------------
-- 说明：事件跳过
-------------------------------------------------------------------------------------------------------
EventsTeachingSkip = class("EventsTeachingSkipClass", Window)

--打开界面
local events_teaching_skip_open_terminal = {
    _name = "events_teaching_skip_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EventsTeachingSkipClass") == nil then
            local _win = EventsTeachingSkip:new()
            _win:init(params)
            fwin:open(_win,fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local events_teaching_skip_swap_terminal = {
    _name = "events_teaching_skip_swap",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local win = fwin:find("EventsTeachingSkipClass")
        if nil ~= win then
            win:retain()

            fwin:close(win)
            fwin:open(win, win._windows)

            win:release()
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


--关闭界面
local events_teaching_skip_close_terminal = {
    _name = "events_teaching_skip_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EventsTeachingSkipClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(events_teaching_skip_open_terminal)
state_machine.add(events_teaching_skip_swap_terminal)
state_machine.add(events_teaching_skip_close_terminal)
state_machine.init()

function EventsTeachingSkip:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
	app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")

    -- var
    self._mission = nil
	
     -- Initialize alert_home state machine.
    local function init_props_batch_use_terminal()
        --跳过
        local events_teaching_skip_jump_over_terminal = {
            _name = "events_teaching_skip_jump_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local tuitionWindow = fwin:find("TuitionControllerClass")
                if nil ~= tuitionWindow then
                    tuitionWindow:setVisible(false)
                end
                local roleDialogueWindow = fwin:find("RoleDialogueClass")
                if nil ~= roleDialogueWindow then
                    roleDialogueWindow:setVisible(false)
                end
                fwin:close(fwin:find("WindowLockClass"))
                state_machine.excute("events_teaching_skip_hide", 0, 0)
                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = "", m_type = 7}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新数据
        local events_teaching_skip_update_data_terminal = {
            _name = "events_teaching_skip_update_data",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateData(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --隐藏
        local events_teaching_skip_hide_terminal = {
            _name = "events_teaching_skip_hide",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --显示
        local events_teaching_skip_show_terminal = {
            _name = "events_teaching_skip_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --关闭
        local events_teaching_skip_exit_terminal = {
            _name = "events_teaching_skip_exit",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("EventsTeachingSkipClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--跳过确认
		local events_teaching_skip_jump_carried_out_terminal = {
            _name = "events_teaching_skip_jump_carried_out",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.skipMission ~= nil then
                    instance:skipMission()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(events_teaching_skip_jump_over_terminal)
        state_machine.add(events_teaching_skip_update_data_terminal)
        state_machine.add(events_teaching_skip_hide_terminal)
        state_machine.add(events_teaching_skip_show_terminal)
        state_machine.add(events_teaching_skip_exit_terminal)
        state_machine.add(events_teaching_skip_jump_carried_out_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_props_batch_use_terminal()
end

function EventsTeachingSkip:updateData( mission )
    self._mission = mission
    local missionParam13 = self._mission[mission_param.mission_param13]
    if nil ~= missionParam13 and #missionParam13 > 0 then
        local missionParam13A = zstring.split(missionParam13, "|")
        if #missionParam13A >=3 then
            local XY = zstring.split(missionParam13A[3], ",")
            self:setPosition(cc.p(XY[1], XY[2]))
        end
    end
end

function EventsTeachingSkip:skipMission()
    local missionParam13 = self._mission[mission_param.mission_param13]
    if nil ~= missionParam13 and #missionParam13 > 0 then
        local missionParam13A = zstring.split(missionParam13, "|")
        if #missionParam13A > 1 then
            local arr = zstring.split(missionParam13A[1], ",")
            if nil ~= arr and #arr > 2 then
                _ED._mission_execute = zstring.split(missionParam13A[2], ",")
                local function responseMissionSkipInfoCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED._mission_1 = arr[1]
                        _ED._mission_2 = arr[2]
                        _ED._mission_3 = arr[3]

                        local keyName = "skip_mission_grop_ids"
                        writeKey(keyName, missionParam13A[1] or "")

                        arr = zstring.split(missionParam13A[2], ",")

                        fwin:close(fwin:find("WindowLockClass"))
                        fwin:close(fwin:find("TuitionControllerClass"))
                        fwin:close(fwin:find("RoleDialogueClass"))
                        state_machine.excute("util_tips_window_close", 0, 0)
                        state_machine.excute("events_teaching_skip_close", 0, 0)

                        clearMission()
                        checkMissionSkipTo(arr[1], arr[2], tonumber(arr[3]) - 1)

                        -- local nCount = #fwin._list
                        -- for i=1, nCount do
                        --     local v = fwin._list[nCount - i + 1]
                        --     if nil ~= v and v._view ~= nil and v._view == fwin._ui 
                        --         and "redAlertTimeMineEventQueueMarchClass" ~= v.__cname
                        --         and "redAlertTimeMineEventQueueStruckClass" ~= v.__cname
                        --         and "redAlertTimeMineEventQueueDefenseClass" ~= v.__cname
                        --         then
                        --         fwin:close(v)
                        --     end
                        -- end
                    else
                        NetworkManager:register(protocol_command.mission_skip_info.code, nil, nil, nil, nil, responseMissionSkipInfoCallback, false, nil)
                    end
                end
                protocol_command.mission_skip_info.param_list = "" .. missionParam13
                NetworkManager:register(protocol_command.mission_skip_info.code, nil, nil, nil, nil, responseMissionSkipInfoCallback, false, nil)
            end
        end
    end
end


--初始化界面
function EventsTeachingSkip:onInit(params)
    local csbItem = csb.createNode(config_csb.mission.missionex.events_teaching_skip)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_skip"), nil, 
    {
        terminal_name = "events_teaching_skip_jump_over", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    self:onUpdateDraw()
end

-- 显示信息
function EventsTeachingSkip:onUpdateDraw()
    local root = self.roots[1]

end

--初始化
function EventsTeachingSkip:init(params)
    self:onInit(params)
    self:updateData(params)
end

--移除状态机
function EventsTeachingSkip:onExit()
    -- state_machine.remove("events_teaching_skip_show")
    -- state_machine.remove("events_teaching_skip_update_data")
    -- state_machine.remove("events_teaching_skip_exit")
    -- state_machine.remove("events_teaching_skip_jump_carried_out")
end
