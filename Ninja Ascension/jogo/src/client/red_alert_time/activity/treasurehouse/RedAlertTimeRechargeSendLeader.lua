-----------------------------
--充值送将领活动
-----------------------------
RedAlertTimeRechargeSendLeader = class("RedAlertTimeRechargeSendLeaderClass", Window)

local red_alert_time_recharge_send_leader_window_open_terminal = {
    _name = "red_alert_time_recharge_send_leader_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeRechargeSendLeaderClass") then
            fwin:open(RedAlertTimeRechargeSendLeader:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_recharge_send_leader_window_close_terminal = {
    _name = "red_alert_time_recharge_send_leader_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.show_reward_list_group_ex = {}
        fwin:close(fwin:find("RedAlertTimeRechargeSendLeaderClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_recharge_send_leader_window_open_terminal)
state_machine.add(red_alert_time_recharge_send_leader_window_close_terminal)
state_machine.init()

function RedAlertTimeRechargeSendLeader:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_info = nil 
    self.activity_type = 0

    self.m_times = 0
    self.m_reset_times = 0
    self._label_close_text = nil
    self._label_reset_text = nil

    self._max_sign_day = 0

    app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorOnce")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorTen")
    app.load("client.red_alert_time.leader.LeaderExchangeInfo")

    app.load("client.red_alert_time.cells.leader.leader_big_head_cell")

    local function init_red_alert_time_recharge_send_leader_terminal()
        -- 规则
        local red_alert_time_recharge_send_leader_get_rule_terminal = {
            _name = "red_alert_time_recharge_send_leader_get_rule",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local red_alert_time_recharge_send_leader_update_draw_terminal = {
            _name = "red_alert_time_recharge_send_leader_update_draw",
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

        local red_alert_time_recharge_send_leader_supplemented_terminal = {
            _name = "red_alert_time_recharge_send_leader_supplemented",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local activity_info = _ED.activity_info[""..instance.activity_type]
                local timesData = zstring.split(activity_info.activity_add_state, ",")
                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = instance, m_type = 32}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_recharge_send_leader_supplemented_confirm_terminal = {
            _name = "red_alert_time_recharge_send_leader_supplemented_confirm",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- local cell = params._datas.cell
                local acitvity = _ED.activity_info[""..instance.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取
        local red_alert_time_recharge_send_leader_get_reward_terminal = {
          _name = "red_alert_time_recharge_send_leader_get_reward",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                -- local cell = params._datas.cell
                local acitvity = _ED.activity_info[""..instance.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                            checkRewardObtainDraw()
                        end
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n0\r\n0\r\n0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

        state_machine.add(red_alert_time_recharge_send_leader_get_rule_terminal)
        state_machine.add(red_alert_time_recharge_send_leader_update_draw_terminal)
        state_machine.add(red_alert_time_recharge_send_leader_supplemented_terminal)
        state_machine.add(red_alert_time_recharge_send_leader_supplemented_confirm_terminal)
        state_machine.add(red_alert_time_recharge_send_leader_get_reward_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_recharge_send_leader state machine.
    init_red_alert_time_recharge_send_leader_terminal()
end

function RedAlertTimeRechargeSendLeader:onUpdateDraw()
    local root = self.roots[1]

    -- local activity_info = _ED.activity_info[""..self.activity_type]
    local activity_info = _ED.activity_info[""..79]
    self._activity_info = activity_info
    local activity_add_state = zstring.split(activity_info.activity_add_state,",")

    -- 名称
    local Text_recharge_send_leader_tit = ccui.Helper:seekWidgetByName(root,"Text_recharge_send_leader_tit")
    Text_recharge_send_leader_tit:setString(activity_info.activity_title)
    -- 描述
    local Text_recharge_send_leader_p_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_send_leader_p_1")
    Text_recharge_send_leader_p_1:setString(activity_info.activity_dec)

    local Text_recharge_send_leader_time_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_send_leader_time_1")
    local Text_recharge_send_leader_time_2 = ccui.Helper:seekWidgetByName(root,"Text_recharge_send_leader_time_2")
    Text_recharge_send_leader_time_1:setString("")
    Text_recharge_send_leader_time_1:removeAllChildren(true)
    Text_recharge_send_leader_time_2:setString("")
    Text_recharge_send_leader_time_2:removeAllChildren(true)
    -- 结束时间
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    local font_size = Text_recharge_send_leader_time_1:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_recharge_send_leader_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_recharge_send_leader_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_recharge_send_leader_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_recharge_send_leader_time_1:addChild(time_int_1)
    self._label_close_text = time_int_1
    self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))

    -- 重置时间
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    local time_info_2 = cc.Label:createWithTTF(activity_str_tip[97], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_recharge_send_leader_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_recharge_send_leader_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_recharge_send_leader_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_recharge_send_leader_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_recharge_send_leader_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_recharge_send_leader_time_2:addChild(time_int_2)
    self._label_reset_text = time_int_2
    self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))

    -- 奖励
    local rewards = zstring.split(activity_info.activity_data[1][1].achieve_reward, "|")
    for i = 1, #rewards do
        local Panel_recharge_send_leader = ccui.Helper:seekWidgetByName(root,"Panel_recharge_send_leader_"..i)
        if Panel_recharge_send_leader ~= nil then
            Panel_recharge_send_leader:removeAllChildren(true)
            local info = zstring.split(rewards[i], ",")
            local prop_data = {}
            prop_data.prop_item = tonumber(info[1])
            prop_data.prop_type = tonumber(info[2])
            prop_data.item_value = tonumber(info[3])
            local cell = createPropIconCell(prop_data, false, true, true)
            Panel_recharge_send_leader:addChild(cell)
        end
    end

    --进度描述
    local Text_recharge_send_leader_p_t = ccui.Helper:seekWidgetByName(root,"Text_recharge_send_leader_p_t")
    Text_recharge_send_leader_p_t:setString("")
    Text_recharge_send_leader_p_t:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    _richText2:setContentSize(cc.size(Text_recharge_send_leader_p_t:getContentSize().width, Text_recharge_send_leader_p_t:getContentSize().height))
    _richText2:setAnchorPoint(cc.p(0.5, 0.5))
    local counts = zstring.split(activity_info.activity_data[1][1].achieve_complete_count, "/")
    self._max_sign_day = tonumber(counts[2])
    local last_day = tonumber(counts[2]) - tonumber(counts[1])
    local char_str = string.format(activity_str_tip[169], activity_add_state[7],""..counts[1],""..last_day)
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        char_str, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)
    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPosition(cc.p(Text_recharge_send_leader_p_t:getContentSize().width, Text_recharge_send_leader_p_t:getContentSize().height))
    Text_recharge_send_leader_p_t:addChild(_richText2)
    
    local LoadingBar_recharge_send_leader_day = ccui.Helper:seekWidgetByName(root,"LoadingBar_recharge_send_leader_day")
    local persent_exp = zstring.tonumber(counts[1]) * 24.5 - 1
    LoadingBar_recharge_send_leader_day:setPercent(persent_exp)

    local Button_recharge_send_leader_rec = ccui.Helper:seekWidgetByName(root,"Button_recharge_send_leader_rec")
    local Button_recharge_send_leader_sgin = ccui.Helper:seekWidgetByName(root,"Button_recharge_send_leader_sgin")

    -- 领取状态
    local activity_data = activity_info.activity_data[1][1]
    if tonumber(activity_data.achieve_state) == 1 and tonumber(counts[1]) == tonumber(counts[2]) then
        Button_recharge_send_leader_rec:setTitleText(activity_str_tip[170])
        Button_recharge_send_leader_rec:setTouchEnabled(true)
        Button_recharge_send_leader_rec:setBright(true)
    elseif tonumber(activity_data.achieve_state) == 2 then
        Button_recharge_send_leader_rec:setTitleText(activity_str_tip[2])
        Button_recharge_send_leader_rec:setTouchEnabled(false)
        Button_recharge_send_leader_rec:setBright(false)
    else
        Button_recharge_send_leader_rec:setTitleText(activity_str_tip[170])
        Button_recharge_send_leader_rec:setTouchEnabled(false)
        Button_recharge_send_leader_rec:setBright(false)
    end

    -- 补签状态
    local need_sign = false
    Button_recharge_send_leader_sgin:setTouchEnabled(false)
    Button_recharge_send_leader_sgin:setBright(false)
    if tonumber(activity_data.achieve_state) > 0 or tonumber(counts[1]) == tonumber(counts[2]) then
        need_sign = false
    else
        local todayFinishState = zstring.tonumber(activity_add_state[8])
        if tonumber(activity_add_state[4]) >= 7 then
        else
            if todayFinishState == 0 then
                if tonumber(activity_add_state[6]) - tonumber(activity_add_state[4]) > 1 then
                    Button_recharge_send_leader_sgin:setTouchEnabled(true)
                    Button_recharge_send_leader_sgin:setBright(true)
                end
            else
                if tonumber(activity_add_state[6]) - tonumber(activity_add_state[4]) >= 1 then
                    Button_recharge_send_leader_sgin:setTouchEnabled(true)
                    Button_recharge_send_leader_sgin:setBright(true)
                end
            end
        end
    end

    -- 礼包价值
    local Text_recharge_send_leader_pck_reward = ccui.Helper:seekWidgetByName(root,"Text_recharge_send_leader_pck_reward")
    -- Text_recharge_send_leader_pck_reward:setString(activity_add_state[9])
    Text_recharge_send_leader_pck_reward:setString("3888")

    -- 奖励图标
    local Panel_recharge_send_leader_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_recharge_send_leader_icon_1")
    Panel_recharge_send_leader_icon_1:removeAllChildren(true)
    local info = zstring.split("551,6,1", ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(info[1])
    prop_data.prop_type = tonumber(info[2])
    prop_data.item_value = tonumber(info[3])
    local cell = createPropIconCell(prop_data, false, false, false)
    Panel_recharge_send_leader_icon_1:addChild(cell)
end

function RedAlertTimeRechargeSendLeader:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_text ~= nil then
            self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("notification_center_update", 0, "red_alert_time_recharge_send_leader_window_close")
        end
    end
end

function RedAlertTimeRechargeSendLeader:onEnterTransitionFinish()

end

function RedAlertTimeRechargeSendLeader:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.recharge_send_leader)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 活动数据
    -- activity_add_state = "开始时间,结束时间,领奖时间,已签到天数,0,今日天数,补签花费金币,今日充值状态,礼包价值"
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_send_leader_close"), nil, 
    {
        terminal_name = "red_alert_time_recharge_send_leader_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_send_leader_rec"), nil, 
    {
        terminal_name = "red_alert_time_recharge_send_leader_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --补签
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_send_leader_sgin"), nil, 
    {
        terminal_name = "red_alert_time_recharge_send_leader_supplemented", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_send_leader_recharge"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)

    --规则查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_send_leader_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_recharge_send_leader_get_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)


    self:onUpdateDraw()
end

function RedAlertTimeRechargeSendLeader:init(params)
    self._activity_info = params[1]
    self.activity_type = self._activity_info.activity_type
    self:onInit()
    return self
end

function RedAlertTimeRechargeSendLeader:onExit()
    state_machine.remove("red_alert_time_recharge_send_leader_get_rule")
    state_machine.remove("red_alert_time_recharge_send_leader_update_draw")
    state_machine.remove("red_alert_time_recharge_send_leader_supplemented")
    state_machine.remove("red_alert_time_recharge_send_leader_supplemented_confirm")
    state_machine.remove("red_alert_time_recharge_send_leader_get_reward")
end
