-- ------------------------------------------------------------------------------------------------------------
--  慷慨馈赠的充值红包界面
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeLargesseGiveHotBuy = class("RedAlertTimeLargesseGiveHotBuyClass", Window)

local red_alert_time_largesse_give_hot_buy_window_open_terminal = {
	_name = "red_alert_time_largesse_give_hot_buy_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
    	local tab = RedAlertTimeLargesseGiveHotBuy:new():init(params)
    	fwin:open(tab)
    	return tab	 
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(red_alert_time_largesse_give_hot_buy_window_open_terminal)
state_machine.init()

function RedAlertTimeLargesseGiveHotBuy:ctor()
	self.super:ctor()
	self.roots = {}
	self._label_close_time = 0
	self.accept_the_prize = nil
    self._prop_id = 0
	app.load("client.red_alert_time.cells.activity.treasurehouse.activity_largesse_give_hot_buy_cell")
    app.load("client.red_alert_time.props.propsUseRedEnvelopes")

	local function init_red_alert_time_largesse_give_hot_buy_terminal()
		--显示界面
		local red_alert_time_largesse_give_hot_buy_show_terminal = {
			_name = "red_alert_time_largesse_give_hot_buy_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
		        instance:setVisible(true)
			end,
			_terminal = nil,
			_terminals = nil
		}
		--刷新
		local red_alert_time_largesse_give_hot_buy_update_terminal = {
			_name = "red_alert_time_largesse_give_hot_buy_update",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
		        instance:updateDraw()
			end,
			_terminal = nil,
			_terminals = nil
		}
		--领取红包
		local red_alert_time_largesse_give_hot_buy_get_reward_terminal = {
			_name = "red_alert_time_largesse_give_hot_buy_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
                local acitvity = _ED.activity_info[""..instance._activity_type.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        checkRewardObtainDraw()
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)  

			end,
			_terminal = nil,
			_terminals = nil
		}
		--规则
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

        local red_alert_time_largesse_give_hot_buy_use_porp_terminal = {
            _name = "red_alert_time_largesse_give_hot_buy_use_porp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local prop = fundPropWidthId(instance._prop_id)
                if prop ~= nil then
                    state_machine.excute("props_use_red_envelopes_window_open",0,{prop})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_funding_aggregation_change_rule_terminal)
		state_machine.add(red_alert_time_largesse_give_hot_buy_get_reward_terminal)
		state_machine.add(red_alert_time_largesse_give_hot_buy_update_terminal)
		state_machine.add(red_alert_time_largesse_give_hot_buy_show_terminal)
        state_machine.add(red_alert_time_largesse_give_hot_buy_use_porp_terminal)
		state_machine.init()
	end	
	init_red_alert_time_largesse_give_hot_buy_terminal()
end

function RedAlertTimeLargesseGiveHotBuy:updateDraw()
	local root = self.roots[1]

	self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
	--提示
	local Text_recharge_bonus_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_infor_p_1")    
	Text_recharge_bonus_infor_p_1:setString(self._activity_type.activity_dec)
	--剩余时间
	local activity_info = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_info[1],",")
	local isEnd = false    --是否完全结束
	self.accept_the_prize = isEnd
	if tonumber(activity_add_state[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        isEnd = false
    else
        isEnd = true
        --活动结束，领奖时需要隐藏的内容
    end
	local Text_recharge_bonus_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_act_time_1")
    local time_str = activity_str_tip[93]
	if isEnd == true then
		self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))) 
        time_str = activity_str_tip[92]
    else
    	self.m_times = ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        time_str = activity_str_tip[93]
    end
    Text_recharge_bonus_act_time_1:removeAllChildren(true)
    Text_recharge_bonus_act_time_1:setString("")
    local font_size = Text_recharge_bonus_act_time_1:getFontSize()
    
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_recharge_bonus_act_time_1:getContentSize().height / 2)
    Text_recharge_bonus_act_time_1:addChild(time_info)
    
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_recharge_bonus_act_time_1:getContentSize().height / 2)
    Text_recharge_bonus_act_time_1:addChild(time_int)
    self._label_close_time = time_int   
	--累计充值
	local Text_largesse_give_t_1_n = ccui.Helper:seekWidgetByName(root,"Text_largesse_give_t_1_n")				
	Text_largesse_give_t_1_n:setString(activity_add_state[4])
	--可赠送红包
	local Text_largesse_give_red_n = ccui.Helper:seekWidgetByName(root,"Text_largesse_give_red_n")				
	local prop = fundPropWidthId(activity_add_state[11])
    local count = 0
    if prop ~= nil then
        count = tonumber(prop.prop_number)
    end
    Text_largesse_give_red_n:setString(count)
    self._prop_id = tonumber(activity_add_state[11])

	--红包图像
	local Panel_largesse_give_red_icon = ccui.Helper:seekWidgetByName(root,"Panel_largesse_give_red_icon")      
	Panel_largesse_give_red_icon:removeAllChildren(true)
    local prop_data = {}
    prop_data.prop_item = tonumber(activity_add_state[11])
    prop_data.prop_type = tonumber(6)
    prop_data.item_value = tonumber(activity_add_state[6])
    local cell = createPropIconCell(prop_data, true, false, true)
    Panel_largesse_give_red_icon:addChild(cell)
	--红包提示
	local Text_largesse_give_red_infor = ccui.Helper:seekWidgetByName(root,"Text_largesse_give_red_infor")      
    local infor = string.format(activity_str_tip[177], activity_add_state[7], activity_add_state[8], 1)
    Text_largesse_give_red_infor:removeAllChildren(true)
    Text_largesse_give_red_infor:setString("")

    local font_size = Text_largesse_give_red_infor:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local rt2, count2, text2 = draw.richTextCollectionMethod(_richText, 
        infor, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        font_size,
        chat_rich_text_color)

    _richText:setContentSize(cc.size(Text_largesse_give_red_infor:getContentSize().width, Text_largesse_give_red_infor:getContentSize().height))  
    _richText:setPosition(cc.p(Text_largesse_give_red_infor:getContentSize().width / 2, Text_largesse_give_red_infor:getContentSize().height / 2))  
    Text_largesse_give_red_infor:addChild(_richText)

	--领取按钮
	local Button_largesse_give_rec = ccui.Helper:seekWidgetByName(root,"Button_largesse_give_rec")                 
    if tonumber(activity_add_state[6]) > 0 then
        Button_largesse_give_rec:setTouchEnabled(true)
        Button_largesse_give_rec:setBright(true)
    else
        Button_largesse_give_rec:setTouchEnabled(false)
        Button_largesse_give_rec:setBright(false)
    end

    local Button_largesse_give_red = ccui.Helper:seekWidgetByName(root,"Button_largesse_give_red")                
    if count <= 0 then
        Button_largesse_give_red:setTouchEnabled(false)
        Button_largesse_give_red:setBright(false)
    else
        Button_largesse_give_red:setTouchEnabled(true)
        Button_largesse_give_red:setBright(true)
    end
	
	local ListView_largesse_give = ccui.Helper:seekWidgetByName(root,"ListView_largesse_give")
	ListView_largesse_give:removeAllItems()
	local result = _ED.activity_info[""..self._activity_type.activity_type].activity_data[2]
    local index = 1
    for i = #result, 1, -1 do
        local cell = state_machine.excute("activity_largesse_give_hot_buy_create_cell", 0, {index, result[i], self._activity_type.activity_type, 2})
        ListView_largesse_give:addChild(cell)
        index = index + 1
    end	
    ListView_largesse_give:requestRefreshView()
end	

function RedAlertTimeLargesseGiveHotBuy:onUpdate(dt)
    if self.m_times > 0 and self._label_close_time ~= nil then
        self.m_times = self.m_times - dt
        self._label_close_time:setString(getRedAlertTimeActivityFormat(self.m_times))
        if self.m_times <= 0 then
            if self.accept_the_prize == true then
                state_machine.excute("red_alert_time_center_find",0,"red_alert_time_largesse_give_window_close")
            else
                self:updateDraw()
            end
        end
    end
end

function RedAlertTimeLargesseGiveHotBuy:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.largesse_give_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_funding_aggregation_change_rule", 
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    --领取红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_largesse_give_rec"), nil, 
    {
        terminal_name = "red_alert_time_largesse_give_hot_buy_get_reward", 
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    --赠送红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_largesse_give_red"), nil, 
    {
        terminal_name = "red_alert_time_largesse_give_hot_buy_use_porp",
        terminal_state = 0,
        touch_black = true,
        page_index = 2,
    },
    nil,1)
    --前往充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_largesse_give_recharge"), nil, 
    {
        terminal_name = "main_window_open_recharge",
        terminal_state = 0,
        touch_black = true,
        choose_type = 1,
    },
    nil,1)
    self:updateDraw()
end

function RedAlertTimeLargesseGiveHotBuy:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeLargesseGiveHotBuy:onExit()
    state_machine.remove("red_alert_time_largesse_give_hot_buy_show")
    state_machine.remove("red_alert_time_largesse_give_hot_buy_update")
    state_machine.remove("red_alert_time_largesse_give_hot_buy_get_reward")
    state_machine.remove("red_alert_time_largesse_give_hot_buy_use_porp")
end