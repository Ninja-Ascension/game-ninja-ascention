-----------------------------
--连续签到
-----------------------------
RedAlertTimeDaySign = class("RedAlertTimeDaySignClass", Window)

local red_alert_time_day_sign_window_open_terminal = {
    _name = "red_alert_time_day_sign_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeDaySignClass") then
			fwin:open(RedAlertTimeDaySign:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_day_sign_window_close_terminal = {
    _name = "red_alert_time_day_sign_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeDaySignClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_day_sign_window_open_terminal)
state_machine.add(red_alert_time_day_sign_window_close_terminal)
state_machine.init()

function RedAlertTimeDaySign:ctor()
    self.super:ctor()
    self.roots = {}
	self._activity = nil
	self.group = nil
	self._current_page = 0
    --load lua file

    self.m_reset_times = 0

	app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_act_daily_cell")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDaySignRetroactive")
    -- Initialize red_alert_time_day_sign state machine.
    local function init_red_alert_time_day_sign_terminal()
		
		--翻页
		local red_alert_time_day_sign_change_page_terminal = {
            _name = "red_alert_time_day_sign_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--领取
		local red_alert_time_day_sign_receive_award_terminal = {
            _name = "red_alert_time_day_sign_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("活动领取接口")
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							if response.node._current_page == 3 then
								response.node:changeSelectPage(1)
							else
								response.node:onUpdateListView(response.node._current_page)
							end
                        end
						checkRewardObtainDraw()
					end
				end		
				protocol_command.draw_activity_reward.param_list = _ED.activity_info["83"].activity_id .. "\r\n83\r\n0\r\n"..(instance._current_page-1).."\r\n0"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local red_alert_time_day_sign_change_rule_terminal = {
            _name = "red_alert_time_day_sign_change_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local red_alert_time_day_sign_update_draw_terminal = {
            _name = "red_alert_time_day_sign_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
				for i=1, #_ED.activity_info["83"].activity_data[1] do
					if tonumber(_ED.activity_info["83"].activity_data[1][i].achieve_state) ~= 2 then
						instance:changeSelectPage(i)
						return
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_day_sign_change_page_terminal)
        state_machine.add(red_alert_time_day_sign_receive_award_terminal)
        state_machine.add(red_alert_time_day_sign_change_rule_terminal)
        state_machine.add(red_alert_time_day_sign_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_day_sign state machine.
    init_red_alert_time_day_sign_terminal()
end

function RedAlertTimeDaySign:changeSelectPage( page )
    local root = self.roots[1]
    local Button_day_sign_7 = ccui.Helper:seekWidgetByName(root, "Button_day_sign_7")
    local Button_day_sign_15 = ccui.Helper:seekWidgetByName(root, "Button_day_sign_15")
    local Button_day_sign_30 = ccui.Helper:seekWidgetByName(root, "Button_day_sign_30")
    if page == self._current_page then
        if page == 1 then
            Button_day_sign_7:setHighlighted(true)
        elseif page == 2 then
            Button_day_sign_15:setHighlighted(true)
		else
			Button_day_sign_30:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_day_sign_7:setHighlighted(false)
    Button_day_sign_15:setHighlighted(false)
    Button_day_sign_30:setHighlighted(false)
    if page == 1 then
        Button_day_sign_7:setHighlighted(true)
	elseif page == 2 then	
		Button_day_sign_15:setHighlighted(true)
    else
		Button_day_sign_30:setHighlighted(true)
	end
	self:onUpdateListView(page)
end

function RedAlertTimeDaySign:onUpdateListView(page)
	local root = self.roots[1]
	local ListView_day_sign_7 = ccui.Helper:seekWidgetByName(root,"ListView_day_sign_7")
	ListView_day_sign_7:removeAllItems()
	local rewarldData = zstring.split(_ED.activity_info["83"].activity_data[1][tonumber(page)].achieve_reward, "|")
	for i=1 ,#rewarldData do
		local datas = zstring.split(rewarldData[i], ",")
		if tonumber(datas[1]) == -1 then
			datas[1] = resource_prop_id[tonumber(datas[2])]
			datas[2] = 1
		end
		local prop_type = tonumber(datas[2])
		local show_type = 6
		if tonumber(datas[2]) == 13 then --坦克
			prop_type = 3
		elseif tonumber(datas[2]) == 6 then --道具	
			prop_type = 1
		elseif tonumber(datas[2]) == 7 then --配件	
			prop_type = 7
		else
			prop_type = 1
		end
		-- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
		local cell = nil
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
		end
		ListView_day_sign_7:addChild(cell)
	end
	ListView_day_sign_7:requestRefreshView()
	
	if tonumber(_ED.activity_info["83"].activity_data[1][tonumber(page)].achieve_state) == 1 then
		ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"):setBright(true)
	else
		ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"):setBright(false)
	end
end

function RedAlertTimeDaySign:onUpdateDraw()
    self._activity = _ED.activity_info["83"]
    local root = self.roots[1]
    --标题
    ccui.Helper:seekWidgetByName(root,"Text_day_sign_title"):setString(self._activity.activity_title)
    local ListView_day_sign = ccui.Helper:seekWidgetByName(root,"ListView_day_sign")
	ListView_day_sign:removeAllItems()
	local index = 0
	for i=1,#self._activity.activity_data[tonumber(self.group)] do
		local cell = state_machine.excute("red_alert_time_act_daily_cell",0,{self._activity.activity_data[tonumber(self.group)][i], i, self._activity.activity_type,self.group})
		ListView_day_sign:addChild(cell)
	end
	ListView_day_sign:requestRefreshView()

	local Text_day_sign_day_n = ccui.Helper:seekWidgetByName(root,"Text_day_sign_day_n")
	local grand_total = zstring.split(zstring.split(self._activity.activity_add_state, "|")[1], ",")
	
	--local str = string.gsub(activity_str_tip[44], "x", grand_total[4])
    local str = string.format(activity_str_tip[44],""..grand_total[4])
	Text_day_sign_day_n:setString(str)

    -- 重置倒计时
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_day_sign_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_day_sign_act_time_2")
    Text_day_sign_act_time_2:removeAllChildren(true)
    Text_day_sign_act_time_2:setString("")
    local font_size = Text_day_sign_act_time_2:getFontSize()
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_day_sign_act_time_2:getContentSize().width/2)
    reset_time_int:setPositionY(Text_day_sign_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_day_sign_act_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[97], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_day_sign_act_time_2:getContentSize().width/2)
    reset_time_info:setPositionY(Text_day_sign_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_day_sign_act_time_2:addChild(reset_time_info)

    if self._current_page > 0 then
        if tonumber(_ED.activity_info["83"].activity_data[1][tonumber(self._current_page)].achieve_state) == 1 then
            ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"):setTouchEnabled(true)
            ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"):setBright(true)
        else
            ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"):setTouchEnabled(false)
            ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"):setBright(false)
        end
    end
end

function RedAlertTimeDaySign:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_day_sign_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_day_sign_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end
end

function RedAlertTimeDaySign:onEnterTransitionFinish()

end

function RedAlertTimeDaySign:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.day_sign)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_day_sign_close"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
	
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_receive_award", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--规则
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_day_sign_rule"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_change_rule", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	
	--7天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_day_sign_7"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_change_page", 
        terminal_state = 0,
		_page = 1,
    }, nil, 1)
	--15天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_day_sign_15"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_change_page", 
        terminal_state = 0,
		_page = 2,
    }, nil, 1)
	--30天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_day_sign_30"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_change_page", 
        terminal_state = 0,
		_page = 3,
    }, nil, 1)
	
	self:onUpdateDraw()
    local index = 0 
    for i=1, #_ED.activity_info["83"].activity_data[1] do
        if tonumber(_ED.activity_info["83"].activity_data[1][i].achieve_state) ~= 2 then
            self:changeSelectPage(i)
            return
        end
    end
	
end

function RedAlertTimeDaySign:init(params)
	self._activity = params[1]
	self.group = params[2]
	self:onInit()
    return self
end

function RedAlertTimeDaySign:onExit()
    state_machine.remove("red_alert_time_day_sign_change_page")
    state_machine.remove("red_alert_time_day_sign_receive_award")
    state_machine.remove("red_alert_time_day_sign_change_rule")
    state_machine.remove("red_alert_time_day_sign_update_draw")

end
