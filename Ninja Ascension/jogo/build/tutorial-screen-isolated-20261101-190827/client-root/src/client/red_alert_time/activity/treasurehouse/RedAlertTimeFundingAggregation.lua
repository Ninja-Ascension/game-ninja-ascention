-----------------------------
--军资集结
-----------------------------
RedAlertTimeFundingAggregation = class("RedAlertTimeFundingAggregationClass", Window)

local red_alert_time_funding_aggregation_window_open_terminal = {
    _name = "red_alert_time_funding_aggregation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeFundingAggregationClass") then
			fwin:open(RedAlertTimeFundingAggregation:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_funding_aggregation_window_close_terminal = {
    _name = "red_alert_time_funding_aggregation_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeFundingAggregationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_funding_aggregation_window_open_terminal)
state_machine.add(red_alert_time_funding_aggregation_window_close_terminal)
state_machine.init()

function RedAlertTimeFundingAggregation:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0
    self._turntable_panel = nil
    self._rank_panel = nil
    self._reward_panel = nil
    self._rule_panel = nil

    self.m_times = 0
	
	-- app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFundingAggregationRank")
	-- app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFundingAggregationReward")
	-- app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFundingAggregationTransfer")
	-- app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFundingAggregationRule")
	-- app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seek_treasure_rank_cell")
	
    --load lua file
    -- Initialize red_alert_time_funding_aggregation state machine.
    local function init_red_alert_time_funding_aggregation_terminal()
    
        -- 切换界面
        local red_alert_time_funding_aggregation_change_page_terminal = {
          _name = "red_alert_time_funding_aggregation_change_page",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 
		 local red_alert_time_funding_aggregation_change_rule_terminal = {
            _name = "red_alert_time_funding_aggregation_change_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_funding_aggregation_change_page_terminal)
        state_machine.add(red_alert_time_funding_aggregation_change_rule_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_funding_aggregation state machine.
    init_red_alert_time_funding_aggregation_terminal()
end

function RedAlertTimeFundingAggregation:updateDraw()
	local root = self.roots[1]
    --标题
    ccui.Helper:seekWidgetByName(root, "Text_recharge_bonus_name"):setString(self._activity_type.activity_title)
	--内容
	local Text_recharge_bonus_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_recharge_bonus_infor_p_1")
	Text_recharge_bonus_infor_p_1:setString(self._activity_type.activity_dec)
	
	-- 活动开启结束时间
	local Text_recharge_bonus_infor_p_4 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_infor_p_4")
	local timesData = zstring.split(self._activity_type.activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
	
    local Text_brothers_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_brothers_act_time_1")
    Text_brothers_act_time_1:setString("")
    Text_brothers_act_time_1:removeAllChildren(true)
    local Text_brothers_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_brothers_act_time_2")
    Text_brothers_act_time_2:setString("")
    Text_brothers_act_time_2:removeAllChildren(true)
    local font_size = Text_brothers_act_time_1:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_brothers_act_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_brothers_act_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_brothers_act_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_brothers_act_time_1:addChild(time_int_1)

    local time_info_2 = cc.Label:createWithTTF(activity_str_tip[98], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_brothers_act_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_brothers_act_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_brothers_act_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_brothers_act_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_brothers_act_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_brothers_act_time_2:addChild(time_int_2)
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
end

function RedAlertTimeFundingAggregation:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_brothers_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_brothers_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        local server_time = getCurrentGTM8Time()
        local leave_time = 86400 - (server_time.hour * 3600 + server_time.min * 60 + server_time.sec)
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_brothers_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_brothers_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(leave_time))
        end
        if leave_time <= 0 then
            self:updateDraw()
        end
        if self.m_times <= 0 then
            self.m_times = 0
            local activity_type = self._activity_type.activity_type
            -- state_machine.excute("red_alert_time_funding_aggregation_window_close",0,0)
            
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_funding_aggregation_window_close")
        end
    end
end

function RedAlertTimeFundingAggregation:changeSelectPage( page )
	-- debug.print_r(self._activity_type)
    local root = self.roots[1]
    local Panel_funding_aggregation_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_funding_aggregation_tab_box")
    local Button_brothers_activty = ccui.Helper:seekWidgetByName(root, "Button_brothers_activty")
    local Button_brothers_package = ccui.Helper:seekWidgetByName(root, "Button_brothers_package")
    if page == self._current_page then
        if page == 1 then
            Button_brothers_activty:setHighlighted(true)
        elseif page == 2 then
            Button_brothers_package:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_brothers_activty:setHighlighted(false)
    Button_brothers_package:setHighlighted(false)
    state_machine.excute("red_alert_time_funding_full_service_hide", 0, nil)
    state_machine.excute("red_alert_time_funding_personal_hide", 0, nil)
    if page == 1 then
        Button_brothers_activty:setHighlighted(true)
        if self._turntable_panel == nil then
            self._turntable_panel = state_machine.excute("red_alert_time_funding_full_service_open", 0, {Panel_funding_aggregation_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_funding_full_service_show", 0, nil)
        end
    elseif page == 2 then
        Button_brothers_package:setHighlighted(true)
        if self._rank_panel == nil then
            self._rank_panel = state_machine.excute("red_alert_time_funding_personal_open", 0, {Panel_funding_aggregation_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_funding_personal_show", 0, nil)
        end
    end
end

function RedAlertTimeFundingAggregation:onEnterTransitionFinish()

end

function RedAlertTimeFundingAggregation:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.funding_aggregation)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_close"), nil, 
    {
        terminal_name = "red_alert_time_funding_aggregation_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_brothers_activty"), nil, 
    {
        terminal_name = "red_alert_time_funding_aggregation_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_funding_full_service",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_brothers_activty"),
    _m_type = 3,
    _invoke = nil,
    _interval = 0.3,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_brothers_package"), nil, 
    {
        terminal_name = "red_alert_time_funding_aggregation_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_funding_personal",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_brothers_package"),
    _m_type = 3,
    _invoke = nil,
    _interval = 0.3,})
	
	--规则
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_funding_aggregation_change_rule", 
        terminal_state = 0, 
        touch_black = true, 
    }, nil, 1)
    -- if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
    --     self:changeSelectPage(tonumber(params._datas._page))
    -- else
        self:changeSelectPage(1)
    -- end
	self:updateDraw()
end

function RedAlertTimeFundingAggregation:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeFundingAggregation:onExit()
    state_machine.remove("red_alert_time_funding_aggregation_change_page")
    state_machine.remove("red_alert_time_funding_aggregation_change_rule")
end
