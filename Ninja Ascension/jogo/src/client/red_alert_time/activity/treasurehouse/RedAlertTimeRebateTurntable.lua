-----------------------------
-- 返利转盘
-----------------------------
RedAlertTimeRebateTurntable = class("RedAlertTimeRebateTurntableClass", Window)

local red_alert_time_rebate_turntable_window_open_terminal = {
    _name = "red_alert_time_rebate_turntable_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeRebateTurntableClass") then
            local panel = RedAlertTimeRebateTurntable:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_rebate_turntable_window_close_terminal = {
    _name = "red_alert_time_rebate_turntable_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("RedAlertTimeRebateTurntableClass")
        fwin:close(activityWindow)
        _ED.show_reward_list_group_ex = {}
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_rebate_turntable_window_open_terminal)
state_machine.add(red_alert_time_rebate_turntable_window_close_terminal)
state_machine.init()

function RedAlertTimeRebateTurntable:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._activity_info = nil
    self._activity_type = 0

    self.m_times = 0
    self._label_close_text = nil

    self._leave_count = 0
    self._current_index = 0
    self._image_point = nil

    self._is_running = false

    local function init_red_alert_time_rebate_turntable_terminal()
        -- 刷新
        local red_alert_time_rebate_turntable_update_draw_terminal = {
            _name = "red_alert_time_rebate_turntable_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_rebate_turntable_record_terminal = {
            _name = "red_alert_time_rebate_turntable_record",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_running == false then
                    local activity_info = _ED.activity_info[""..instance._activity_type]
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                -- 返利记录
                                -- state_machine.excute("red_alert_time_festival_each_record_window_open",0,response.node._activity_type)
                            end
                        end
                    end
                    -- 请求返利记录
                    protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
                    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                else
                    state_machine.excute("red_alert_time_rebate_turntable_end_round", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_rebate_turntable_start_round_terminal = {
            _name = "red_alert_time_rebate_turntable_start_round",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_running == false then
                    if self._leave_count <= 0 then
                        TipDlg.drawTextDailog(activity_str_tip[210])
                        return
                    end
                    -- 开始转盘
                    local activity_info = _ED.activity_info[""..instance._activity_type]
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:startRound()
                                state_machine.excute("red_alert_time_rebate_turntable_update_draw", 0, "")
                            end
                        end
                    end
                    protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
                    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                    
                    -- instance:startRound()
                    -- state_machine.excute("red_alert_time_rebate_turntable_update_draw", 0, "")
                else
                    state_machine.excute("red_alert_time_rebate_turntable_end_round", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_rebate_turntable_end_round_terminal = {
            _name = "red_alert_time_rebate_turntable_end_round",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.lock("red_alert_time_rebate_turntable_end_round", 0, 0)
                instance:endRound()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_rebate_turntable_go_to_recharge_terminal = {
            _name = "red_alert_time_rebate_turntable_go_to_recharge",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_running == false then
                    state_machine.excute("recharge_dialog_window_open", 0, "")
                else
                    state_machine.excute("red_alert_time_rebate_turntable_end_round", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_rebate_turntable_update_draw_terminal)
        state_machine.add(red_alert_time_rebate_turntable_record_terminal)
        state_machine.add(red_alert_time_rebate_turntable_start_round_terminal)
        state_machine.add(red_alert_time_rebate_turntable_end_round_terminal)
        state_machine.add(red_alert_time_rebate_turntable_go_to_recharge_terminal)
        state_machine.init()
    end
    init_red_alert_time_rebate_turntable_terminal()
end

function RedAlertTimeRebateTurntable:startRound()
    if self._is_running == true then
        return
    end
    self._is_running = true
    local root = self.roots[1]
    for i = 1, 8 do
        local rebate_turntable_hook = ccui.Helper:seekWidgetByName(root, "rebate_turntable_hook_"..i)
        rebate_turntable_hook:setVisible(false)
    end

    local need_time = 4         -- 一圈需要时间
    local round_info = {
        {round_count = 3, speed = 16},
        {round_count = 2, speed = 8},
        {round_count = 1, speed = 4},
    }
    
    local actions = {}
    for _, info in pairs(round_info) do
        local angle = 0
        if info.round_count >= 1 then
            angle = 360 * (info.round_count - 1) + math.random(360)
        else
            angle = math.random(360 * info.round_count)
        end
        local tick_time = angle * need_time / (360 * info.speed)
        local rotate_act = cc.RotateBy:create(tick_time, angle)
        table.insert(actions, rotate_act)
    end
    
    local function callback(sender)
        state_machine.excute("red_alert_time_rebate_turntable_end_round", 0, "")
    end
    
    self._image_point:runAction(cc.Sequence:create(actions[1], actions[2], actions[3], actions[4],
        cc.CallFunc:create(callback)))
end

function RedAlertTimeRebateTurntable:endRound()
    if self._is_running == false then
        return
    end
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    -- activity_add_state = "活动起始时间，活动关闭时间，已使用次数，可使用总次数，转盘返利位置，返利百分比1..8"
    -- activity_info.activity_add_state = "1504713600000,1504972800000,1,2,5,5,10,15,20,25,30,50,100"

    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")
    local need_time = 4         -- 一圈需要时间
    local end_index = tonumber(activity_add_state[5])         -- 最后停留位置

    local each_angle = 360 / 8      -- 每个奖励段角度
    local end_angle = each_angle * (end_index - 1) + math.random(5, each_angle - 5)
    local current_angle = self._image_point:getRotation() % 360
    
    local angle = end_angle - current_angle
    if angle < 0 then
        angle = angle + 360
    end
    local tick_time = math.min(2, angle * need_time / 360)

    local function callback(sender)
        if sender ~= nil and  sender.__self ~= nil and sender.__self.roots ~= nil and sender.__self.roots[1] ~= nil then
            sender.__self._is_running = false
            sender:setRotation(end_angle)
            local rebate_turntable_hook = ccui.Helper:seekWidgetByName(sender.__self.roots[1], "rebate_turntable_hook_"..end_index)
            if rebate_turntable_hook ~= nil then
                rebate_turntable_hook:setVisible(true)
            end
            checkRewardObtainDraw()
            state_machine.unlock("red_alert_time_rebate_turntable_end_round", 0, 0)
        end
    end

    self._image_point:stopAllActions()
    self._image_point:runAction(cc.Sequence:create(
        cc.RotateBy:create(tick_time, angle),
        cc.CallFunc:create(callback)))
end

-- 刷新界面
function RedAlertTimeRebateTurntable:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]

    -- activity_add_state = "活动起始时间，活动关闭时间，已使用次数，可使用总次数，转盘返利位置，返利百分比1..8"
    -- activity_info.activity_add_state = "1504713600000,1504972800000,1,2,5,5,10,15,20,25,30,50,100"
    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")

    -- 活动信息
    local Text_festival_each_child_tit = ccui.Helper:seekWidgetByName(root, "Text_festival_each_child_tit")
    Text_festival_each_child_tit:setString(self._activity_info.activity_title)

    local Text_rebate_turntable_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_rebate_turntable_infor_p_1")
    Text_rebate_turntable_infor_p_1:setString(self._activity_info.activity_dec)

    -- 转盘次数
    local Text_rebate_turntable_have_time_n = ccui.Helper:seekWidgetByName(root, "Text_rebate_turntable_have_time_n")
    local current_count = tonumber(activity_add_state[3])
    local total_count = tonumber(activity_add_state[4])
    local leave_count = total_count - current_count
    Text_rebate_turntable_have_time_n:setString(leave_count)
    self._leave_count = leave_count

    -- 按钮状态
    local Button_rebate_turntable_record = ccui.Helper:seekWidgetByName(root, "Button_rebate_turntable_record")
    if current_count == 0 then
        Button_rebate_turntable_record:setTouchEnabled(false)
        Button_rebate_turntable_record:setBright(false)
    else
        Button_rebate_turntable_record:setTouchEnabled(true)
        Button_rebate_turntable_record:setBright(true)
    end

    -- 返利信息
    for i = 1, 8 do
        local Text_rebate_turntable_icon_n = ccui.Helper:seekWidgetByName(root, "Text_rebate_turntable_icon_n_"..i)
        Text_rebate_turntable_icon_n:setString(activity_add_state[5 + i].."%")
    end

    -- 结束倒计时
    self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)

    local Text_rebate_turntable_time_1 = ccui.Helper:seekWidgetByName(root,"Text_rebate_turntable_time_1")
    Text_rebate_turntable_time_1:removeAllChildren(true)
    Text_rebate_turntable_time_1:setString("")
    local time_info, time_int = createActivityTimeLable(Text_rebate_turntable_time_1, 0, activity_str_tip[93], getRedAlertTimeActivityFormat(self.m_times))
    Text_rebate_turntable_time_1:addChild(time_info)
    Text_rebate_turntable_time_1:addChild(time_int)
    self._label_close_text = time_int
end

function RedAlertTimeRebateTurntable:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_rebate_turntable_window_close")
        end
    end
end

function RedAlertTimeRebateTurntable:onEnterTransitionFinish()

end

function RedAlertTimeRebateTurntable:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.rebate_turntable)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local Image_rebate_turntable_pointer = ccui.Helper:seekWidgetByName(root, "Image_rebate_turntable_pointer")
    self._image_point = Image_rebate_turntable_pointer
    self._image_point.__self = self

    -- 关闭响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebate_turntable_close"), nil, 
    {
        terminal_name = "red_alert_time_rebate_turntable_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 返利记录
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebate_turntable_record"), nil, 
    {
        terminal_name = "red_alert_time_rebate_turntable_record", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 开始转盘
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebate_turntable_o"), nil, 
    {
        terminal_name = "red_alert_time_rebate_turntable_start_round", 
        terminal_state = 0, 
    }, nil, 1)

    -- 开始转盘
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebate_turntable_begin"), nil, 
    {
        terminal_name = "red_alert_time_rebate_turntable_start_round", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebate_turntable_recharge"), nil, 
    {
        terminal_name = "red_alert_time_rebate_turntable_go_to_recharge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:onUpdateDraw()
end

function RedAlertTimeRebateTurntable:init(params)
    self._activity_info = params[1]
    self._activity_type = self._activity_info.activity_type
    self:onInit()
    return self
end

function RedAlertTimeRebateTurntable:onExit()
    state_machine.remove("red_alert_time_rebate_turntable_update_draw")
    state_machine.remove("red_alert_time_rebate_turntable_record")
    state_machine.remove("red_alert_time_rebate_turntable_start_round")
    state_machine.remove("red_alert_time_rebate_turntable_end_round")
    state_machine.remove("red_alert_time_rebate_turntable_go_to_recharge")
end
