-----------------------------
--月卡
-----------------------------
RedAlertTimeMonthCard = class("RedAlertTimeMonthCardClass", Window)

local red_alert_time_month_card_open_terminal = {
    _name = "red_alert_time_month_card_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeMonthCardClass") then
            local panel = RedAlertTimeMonthCard:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_month_card_open_terminal)
state_machine.init()

function RedAlertTimeMonthCard:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil

    self.m_reset_times = 0
    self.text_next_time_1 = nil
    --load lua file

    -- Initialize month_card state machine.
    local function init_month_card_terminal()
        --充值or领奖
        local red_alert_time_month_card_recharge_or_reward_terminal = {
            _name = "red_alert_time_month_card_recharge_or_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currType = params._datas._type
                local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
                if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[_drawMonth[currType][1]] ~= nil and _ED.month_card[_drawMonth[currType][1]] ~= "" 
                    and tonumber(_ED.month_card[_drawMonth[currType][1]].surplus_month_card_time) ~= 0 then
                    state_machine.excute("red_alert_time_month_card_get_reward",0,{_datas = { _type = currType}})
                else
                    state_machine.excute("red_alert_time_month_card_recharge",0,{_datas = { _type = currType}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --充值
        local red_alert_time_month_card_recharge_terminal = {
            _name = "red_alert_time_month_card_recharge",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currType = params._datas._type 
                local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
                local crossPiece = dms.searchs(dms["top_up_goods"], top_up_goods.money, _drawMonth[currType][4])
                local _additional = _drawMonth[6]
                local _nameMonthCard = _drawMonth[3]
                m_reqcharge_info.rechargeIndex = crossPiece[1][1]
                m_reqcharge_info.isMonthCard = 1
                m_reqcharge_info.additional = _additional
                m_reqcharge_info.nameMonthCard = _nameMonthCard
                local function responseGetServerListCallback(response)
                    fwin:close(fwin:find("ConnectingViewClass"))
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.recharge_result.recharge_id = _ED.recharge_result.recharge_id.."_".._drawMonth[currType][1]
                        if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
                            state_machine.excute("platform_request_for_payment", 0, "")
                            return
                        end
                        state_machine.excute("red_alert_time_check_the_order_to_refresh", 0, "")
                    end
                end
                fwin:open(ConnectingView:new(), fwin._windows)
                protocol_command.request_top_up_order_number.param_list = "".._drawMonth[currType][1].."\r\n"..m_sPayMould
                NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --请求效验订单刷新列表
        local red_alert_time_check_the_order_to_refresh_terminal = {
            _name = "red_alert_time_check_the_order_to_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("red_alert_time_wonderful_update_push",0,1)
                    end
                end
                if app.configJson.UserAccountPlatformName ~= "jar-world" then
                    if m_play_pay_type~= nil and m_play_pay_type~="" then
                        protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id..m_play_pay_type
                    else
                        protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id
                    end
                else
                    protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
                end
                NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --领取
        local red_alert_time_month_card_get_reward_terminal = {
            _name = "red_alert_time_month_card_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currType = params._datas._type
                local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        checkRewardObtainDraw()
						state_machine.excute("red_alert_time_wonderful_update_push",0,1)
					end
				end
				protocol_command.draw_month_card_reward.param_list = "".._drawMonth[params._datas._type][1]
                NetworkManager:register(protocol_command.draw_month_card_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新
        local red_alert_time_month_card_update_draw_terminal = {
            _name = "red_alert_time_month_card_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDrawButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local red_alert_time_month_card_rule_infor_terminal = {
            _name = "red_alert_time_month_card_rule_infor",
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
        
        state_machine.add(red_alert_time_check_the_order_to_refresh_terminal) 
        state_machine.add(red_alert_time_month_card_recharge_or_reward_terminal) 
        state_machine.add(red_alert_time_month_card_recharge_terminal)
        state_machine.add(red_alert_time_month_card_get_reward_terminal) 
        state_machine.add(red_alert_time_month_card_rule_infor_terminal)
        state_machine.add(red_alert_time_month_card_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init month_card state machine.
    init_month_card_terminal()
end

function RedAlertTimeMonthCard:onUpdateDrawButton()
    local root = self.roots[1]
    local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
    self.text_next_time_1 = ccui.Helper:seekWidgetByName(root,"Text_act_card_next_time_n_1")
    local Text_act_card_next_time_t_1 = ccui.Helper:seekWidgetByName(root,"Text_act_card_next_time_t_1")
    self.text_next_time_1:setVisible(false)
    Text_act_card_next_time_t_1:setVisible(false)
    for i = 1 , 2 do
        local panel = ccui.Helper:seekWidgetByName(root,"Panel_act_card_d_"..i)
        local Button_act_card_rec = ccui.Helper:seekWidgetByName(root,"Button_act_card_rec_"..i)
        local Button_act_card_day_add = ccui.Helper:seekWidgetByName(root,"Button_act_card_day_add_"..i)
        Button_act_card_day_add:setTouchEnabled(true)
        Button_act_card_day_add:setBright(true)
        if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[_drawMonth[i][1]] ~= nil and _ED.month_card[_drawMonth[i][1]] ~= "" 
            and tonumber(_ED.month_card[_drawMonth[i][1]].surplus_month_card_time) ~= 0 then
            local month_data = _ED.month_card[_drawMonth[i][1]]
            panel:setVisible(true)
            self.text_next_time_1:setVisible(true)
            Text_act_card_next_time_t_1:setVisible(true)
            -- 剩余天数
            local Text_act_card_day_n = ccui.Helper:seekWidgetByName(root,"Text_act_card_day_n_"..i)
            Text_act_card_day_n:setString(month_data.surplus_month_card_time..tipStringInfo_time_info[4])
            Button_act_card_rec:setTitleText(activity_str_tip[5])
            if tonumber(month_data.draw_month_card_state) == 0 then --未领取
                Button_act_card_rec:setTouchEnabled(true)
                Button_act_card_rec:setBright(true)
            else
                Button_act_card_rec:setTouchEnabled(false)
                Button_act_card_rec:setBright(false)
            end
            if tonumber(month_data.surplus_month_card_time) >= 90 then
                Button_act_card_day_add:setTouchEnabled(false)
                Button_act_card_day_add:setBright(false)
            end
        else
            panel:setVisible(false)
            if _string_piece_info[217] == "$" then 
                Button_act_card_rec:setTitleText(_string_piece_info[217].._drawMonth[i][4])
            else
                Button_act_card_rec:setTitleText(_drawMonth[i][4].._string_piece_info[217])
            end 
            Button_act_card_rec:setTouchEnabled(true)
            Button_act_card_rec:setBright(true)
        end
    end
end

function RedAlertTimeMonthCard:onUpdate( dt )
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self.text_next_time_1 ~= nil then
            self.text_next_time_1:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            local server_time = getCurrentGTM8Time()
            self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
            self:onUpdateDrawButton()
        end
    end
end

function RedAlertTimeMonthCard:onUpdateDraw( ... )
    local root = self.roots[1]
    --时间
    local Text_act_card_time_t = ccui.Helper:seekWidgetByName(root, "Text_act_card_time_t")
    Text_act_card_time_t:setString(activity_str_tip[14])

    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    self:drawReward(1)
    self:drawReward(2)
end

function RedAlertTimeMonthCard:drawReward( cardIndex )
    local root = self.roots[1]
    local ListView_card_reward = ccui.Helper:seekWidgetByName(root, "ListView_card_reward_"..cardIndex)
    ListView_card_reward:removeAllItems()
    local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
    local month_data = _drawMonth[cardIndex]
    local daily_reward = dms.atos(month_data,top_up_goods.daily_reward)
    reward_items = zstring.split(daily_reward,"|")
    for i,reward in ipairs(reward_items) do
        local datas = zstring.split(reward, ",")
		if tonumber(datas[1]) == -1 then
			datas[1] = resource_prop_id[tonumber(datas[2])]
			datas[2] = 1
		end
		local prop_type = tonumber(datas[2])
		local show_type = 6
		local prop_from_type = 3
		if tonumber(datas[2]) == 13 then --坦克
			prop_type = 3
			prop_from_type = 10
		elseif tonumber(datas[2]) == 6 then --道具	
			prop_type = 1
			prop_from_type = 1
		elseif tonumber(datas[2]) == 7 then --配件	
			prop_type = 7
			prop_from_type = 3
		else
			prop_type = 1
			prop_from_type = 1
		end
		local cell = nil
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
		    if tonumber(datas[1]) == 2 then
                ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString(activity_str_tip[52])
            end    
        end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
        ListView_card_reward:addChild(cell)
    end
    ListView_card_reward:requestRefreshView()
end

function RedAlertTimeMonthCard:onEnterTransitionFinish()

end

function RedAlertTimeMonthCard:onInit( )
    self:removeAllChildren(true)
    self.roots = {}
    local csbItem = nil
    csbItem = csb.createNode(config_csb.activity.act_card)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --去充值和领奖(档位1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_card_rec_1"), nil, 
    {
        terminal_name = "red_alert_time_month_card_recharge_or_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 1, 
    }, nil, 1)
    --补签(档位1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_card_day_add_1"), nil, 
    {
        terminal_name = "red_alert_time_month_card_recharge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 1, 
    }, nil, 1)
    --去充值和领奖(档位2)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_card_rec_2"), nil, 
    {
        terminal_name = "red_alert_time_month_card_recharge_or_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 2,
    }, nil, 1)
    --补签(档位2)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_card_day_add_2"), nil, 
    {
        terminal_name = "red_alert_time_month_card_recharge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 2, 
    }, nil, 1)

    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_card_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_month_card_rule_infor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_act_card_box"), nil, 
    {
        terminal_name = "red_alert_time_month_card_rule_infor", 
        terminal_state = 0, 
    }, nil, 0)

  	self:onUpdateDraw()
    self:onUpdateDrawButton()
end

function RedAlertTimeMonthCard:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeMonthCard:onExit()
    state_machine.remove("red_alert_time_month_card_recharge_or_reward")
    state_machine.remove("red_alert_time_month_card_recharge")
    state_machine.remove("red_alert_time_month_card_get_reward")
    state_machine.remove("red_alert_time_month_card_update_draw")
    state_machine.remove("red_alert_time_month_card_rule_infor")
end
