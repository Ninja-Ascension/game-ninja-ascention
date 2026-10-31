-----------------------------
--诺曼的馈赠
-----------------------------
RedAlertTimeRechargeBonus = class("RedAlertTimeRechargeBonusClass", Window)

local red_alert_time_recharge_bonus_window_open_terminal = {
    _name = "red_alert_time_recharge_bonus_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeRechargeBonusClass") then
			fwin:open(RedAlertTimeRechargeBonus:new():init(), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_recharge_bonus_window_close_terminal = {
    _name = "red_alert_time_recharge_bonus_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeRechargeBonusClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_recharge_bonus_window_open_terminal)
state_machine.add(red_alert_time_recharge_bonus_window_close_terminal)
state_machine.init()

function RedAlertTimeRechargeBonus:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_times = 0
	app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_recharge_bonus_cell")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    local function init_red_alert_time_recharge_bonus_terminal()
        -- 规则
        local red_alert_time_recharge_bonus_rule_terminal = {
            _name = "red_alert_time_recharge_bonus_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,82)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 刷新
        local red_alert_time_recharge_bonus_update_draw_terminal = {
            _name = "red_alert_time_recharge_bonus_update_draw",
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
		
        state_machine.add(red_alert_time_recharge_bonus_rule_terminal)
        state_machine.add(red_alert_time_recharge_bonus_update_draw_terminal)
        state_machine.init()
    end
    init_red_alert_time_recharge_bonus_terminal()
end


function RedAlertTimeRechargeBonus:onUpdateDraw()
	-- debug.print_r(_ED.activity_info["82"])
    local activity_type = _ED.activity_info["82"]
    local root = self.roots[1]
    local Text_recharge_bonus_name = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_name")
    Text_recharge_bonus_name:setString(activity_type.activity_title)
	local ListView_recharge_bonus = ccui.Helper:seekWidgetByName(root,"ListView_recharge_bonus")
	ListView_recharge_bonus:removeAllItems()
	for i=1,#activity_type.activity_data[1] do
		local cell = state_machine.excute("red_alert_time_recharge_bonus_cell",0,{activity_type.activity_data[1][i], i, 82,1})
		ListView_recharge_bonus:addChild(cell)
	end
	ListView_recharge_bonus:requestRefreshView()
	
	local Text_privilege_chest_buy_gold_n = ccui.Helper:seekWidgetByName(root,"Text_privilege_chest_buy_gold_n")
    local Image_buy_gold = ccui.Helper:seekWidgetByName(root,"Image_buy_gold")
	local datas = zstring.split(activity_type.activity_add_state, "|")
	local stase = zstring.split(datas[1], ",")
	Text_privilege_chest_buy_gold_n:setString(stase[4])
    local Position_x = Text_privilege_chest_buy_gold_n:getPositionX() + Text_privilege_chest_buy_gold_n:getContentSize().width
    Image_buy_gold:setPositionX(Position_x + 20)

    -- 时间
    local Text_recharge_bonus_infor_p_4 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_infor_p_4")
    Text_recharge_bonus_infor_p_4:setString("")
    Text_recharge_bonus_infor_p_4:removeAllChildren(true)
    local Text_recharge_bonus_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_act_time_1")
    Text_recharge_bonus_act_time_1:setString("")
    Text_recharge_bonus_act_time_1:removeAllChildren(true)
    local Text_recharge_bonus_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_act_time_2")
    Text_recharge_bonus_act_time_2:setString("")
    Text_recharge_bonus_act_time_2:removeAllChildren(true)
    local activity_add_state = zstring.split(activity_type.activity_add_state,",")
    local startTime =  tonumber(activity_add_state[1])
    local endTime = tonumber(activity_add_state[2])
    if startTime > 0 and endTime > 0 then
        startTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(startTime / 1000))
        endTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(endTime / 1000-1))

        local font_size = Text_recharge_bonus_act_time_1:getFontSize()
        local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_info_1:setName("time_info_1")
        time_info_1:setAnchorPoint(cc.p(0, 0.5))
        time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info_1:setPositionX(0)
        time_info_1:setPositionY(Text_recharge_bonus_act_time_1:getContentSize().height / 2)
        time_info_1:setTag(200)
        Text_recharge_bonus_act_time_1:addChild(time_info_1)
        local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_int_1:setName("time_int_1")
        time_int_1:setAnchorPoint(cc.p(0, 0.5))
        time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int_1:setPositionX(time_info_1:getContentSize().width)
        time_int_1:setPositionY(Text_recharge_bonus_act_time_1:getContentSize().height / 2)
        time_int_1:setTag(100)
        Text_recharge_bonus_act_time_1:addChild(time_int_1)

        local time_info_2 = cc.Label:createWithTTF(activity_str_tip[94], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_info_2:setName("time_info_2")
        time_info_2:setAnchorPoint(cc.p(1, 0.5))
        time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info_2:setPositionX(Text_recharge_bonus_act_time_2:getContentSize().width - 80)
        time_info_2:setPositionY(Text_recharge_bonus_act_time_2:getContentSize().height / 2)
        time_info_2:setTag(200)
        Text_recharge_bonus_act_time_2:addChild(time_info_2)
        local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_int_2:setName("time_int_2")
        time_int_2:setAnchorPoint(cc.p(0, 0.5))
        time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int_2:setPositionX(Text_recharge_bonus_act_time_2:getContentSize().width - 80)
        time_int_2:setPositionY(Text_recharge_bonus_act_time_2:getContentSize().height / 2)
        time_int_2:setTag(100)
        Text_recharge_bonus_act_time_2:addChild(time_int_2)
    end

    local timesData = zstring.split(activity_type.activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
end

function RedAlertTimeRechargeBonus:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_recharge_bonus_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_recharge_bonus_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        local server_time = getCurrentGTM8Time()
        local leave_time = 86400 - (server_time.hour * 3600 + server_time.min * 60 + server_time.sec)
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_recharge_bonus_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_recharge_bonus_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(leave_time))
        end
        if leave_time <= 0 then
            self:onUpdateDraw()
        end
        if self.m_times <= 0 then
            self.m_times = 0
            -- state_machine.excute("red_alert_time_center_update_first",0,_ED.activity_info["82"].activity_type)
            -- state_machine.excute("red_alert_time_recharge_bonus_window_close",0,_ED.activity_info["82"].activity_type)
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_recharge_bonus_window_close")
        end
    end
end


function RedAlertTimeRechargeBonus:onEnterTransitionFinish()

end

function RedAlertTimeRechargeBonus:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.recharge_bonus)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_close"), nil, 
    {
        terminal_name = "red_alert_time_recharge_bonus_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
	
	--充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_buy"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_recharge_bonus_rule", 
        terminal_state = 0,
        touch_black = true, 
    }, nil, 1)
	
	self:onUpdateDraw()
end

function RedAlertTimeRechargeBonus:init()
	self:onInit()
    return self
end

function RedAlertTimeRechargeBonus:onExit()
    state_machine.remove("red_alert_time_recharge_bonus_rule")
    state_machine.remove("red_alert_time_recharge_bonus_update_draw")

end
