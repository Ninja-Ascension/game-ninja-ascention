-- ------------------------------------------------------------------------------------------------------------
--  说明：军资集结全服
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeFundingFullService = class("RedAlertTimeFundingFullServiceClass", Window)

--打开界面
local red_alert_time_funding_full_service_open_terminal = {
    _name = "red_alert_time_funding_full_service_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeFundingFullService:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_funding_full_service_open_terminal)
state_machine.init()

function RedAlertTimeFundingFullService:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_seek_rank_arrow_down = nil
    self._Image_seek_rank_arrow_up = nil

    local function init_red_alert_time_funding_full_service_terminal()
        local red_alert_time_funding_full_service_show_terminal = {
            _name = "red_alert_time_funding_full_service_show",
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

        local red_alert_time_funding_full_service_hide_terminal = {
            _name = "red_alert_time_funding_full_service_hide",
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

        local red_alert_time_funding_full_service_receive_terminal = {
            _name = "red_alert_time_funding_full_service_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local acitvity = instance._activity_type
				local index = tonumber(params._datas._index)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:onUpdateDraw()
                        end
                        state_machine.excute("notification_center_update", 0, "push_notification_funding_full_service")
						checkRewardObtainDraw()
					end
				end
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..instance._activity_type.activity_type.."\r\n".."0".."\r\n"..(tonumber(acitvity.activity_data[1][index].achieve_index) -1).."\r\n".."0"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_funding_full_service_update_draw_terminal = {
            _name = "red_alert_time_funding_full_service_update_draw",
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

        local red_alert_time_funding_full_service_update_military_terminal = {
            _name = "red_alert_time_funding_full_service_update_military",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateShowMilitary()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_funding_full_service_show_terminal)
        state_machine.add(red_alert_time_funding_full_service_hide_terminal)
        state_machine.add(red_alert_time_funding_full_service_receive_terminal)
        state_machine.add(red_alert_time_funding_full_service_update_draw_terminal)
        state_machine.add(red_alert_time_funding_full_service_update_military_terminal)
        state_machine.init()
    end
    init_red_alert_time_funding_full_service_terminal()
end


function RedAlertTimeFundingFullService:onUpdateDraw()
    local root = self.roots[1]
    self._activity_type = _ED.activity_info["78"]
    for i=1,#self._activity_type.activity_data[1] do
		local ListView_funding_reward = ccui.Helper:seekWidgetByName(root,"ListView_funding_reward_"..i)
		ListView_funding_reward:removeAllItems()
		local rewarldData = zstring.split(self._activity_type.activity_data[1][i].achieve_reward, "|")
		for j=1 ,#rewarldData do
			local datas = zstring.split(rewarldData[j], ",")
			if tonumber(datas[1]) == -1 then
				datas[1] = resource_prop_id[tonumber(datas[2])]
				datas[2] = 1
			end
			local prop_type = tonumber(datas[2])
			local show_type = 9
            local prop_from_type = 3
			if tonumber(datas[2]) == 13 then --坦克
				prop_type = 3
                prop_from_type = 10
			elseif tonumber(datas[2]) == 6 then --道具	
				prop_type = 1
                prop_from_type = 1
                local pic_index = dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.pic_index)
                pic_index = zstring.split(pic_index, ",")
                local prop_name = dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.prop_name)
                if tonumber(pic_index[3]) == nil then
                    show_type = 6
                end
			elseif tonumber(datas[2]) == 7 then --配件	
				prop_type = 7
                prop_from_type = 4
			else
				prop_type = 1
                prop_from_type = 1
			end
			-- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
			local cell = nil
			if prop_type == 7 then
				local equip_datas = {}
				equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
				equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
				cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
			else
				cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
			end
			-- ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
			ListView_funding_reward:addChild(cell)
		end
		ListView_funding_reward:requestRefreshView()
		local Button_funding_rec = ccui.Helper:seekWidgetByName(root,"Button_funding_rec_"..i)
		local Text_funding_not = ccui.Helper:seekWidgetByName(root,"Text_funding_not_"..i)
        local rewarldData = zstring.split(self._activity_type.activity_data[1][i].achieve_complete_count, "/")
        if tonumber(self._activity_type.activity_data[1][i].achieve_state) == 1 then
			Button_funding_rec:setVisible(true)
			Text_funding_not:setVisible(false)
		else
			Button_funding_rec:setVisible(false)
			Text_funding_not:setVisible(true)
			if tonumber(self._activity_type.activity_data[1][i].achieve_state) == 0 then
				Text_funding_not:setColor(chat_rich_text_color[6])
				Text_funding_not:setString(activity_str_tip[8])
                if _ED.activity_to_full_service >= zstring.tonumber(rewarldData[2]) then
                    Button_funding_rec:setVisible(true)
                    Text_funding_not:setVisible(false)
                end    
			else
				Text_funding_not:setColor(chat_rich_text_color[1])
				Text_funding_not:setString(activity_str_tip[2])
			end
		end
		local Text_funding_n = ccui.Helper:seekWidgetByName(root,"Text_funding_n_"..i)
		
		Text_funding_n:setString(rewarldData[2]/10)
	end
	local LoadingBar_integral_bar_1 = ccui.Helper:seekWidgetByName(root,"LoadingBar_integral_bar_1")

	local rewarldData = zstring.split(self._activity_type.activity_data[1][1].achieve_complete_count, "/")
    local LoadingBarCell = zstring.tonumber(rewarldData[2])/5
    local number = 0
    for i=1, #self._activity_type.activity_data[1] do
        local index = #self._activity_type.activity_data[1]-i+1
        local rewarldData = zstring.split(self._activity_type.activity_data[1][index].achieve_complete_count, "/")
        if _ED.activity_to_full_service >= tonumber(rewarldData[2]) then
            number = number + LoadingBarCell
        else
            if index < 5 then
                local rewarldData2 = zstring.split(self._activity_type.activity_data[1][index+1].achieve_complete_count, "/")
                if _ED.activity_to_full_service >= tonumber(rewarldData2[2]) then
                    local add_number = (_ED.activity_to_full_service - tonumber(rewarldData2[2])) / (tonumber(rewarldData[2]) - tonumber(rewarldData2[2])) * LoadingBarCell
                    number = number + add_number
                end
            else
                number = _ED.activity_to_full_service / tonumber(rewarldData[2]) * LoadingBarCell
            end
        end
    end
	local persent_exp = number / zstring.tonumber(rewarldData[2]) *100
    LoadingBar_integral_bar_1:setPercent(persent_exp)
	
	local Text_funding_aggregation_t_2 = ccui.Helper:seekWidgetByName(root,"Text_funding_aggregation_t_2")
    Text_funding_aggregation_t_2:removeAllChildren(true)
	--Text_funding_aggregation_t_2:setString((_ED.activity_to_full_service/10)..activity_str_tip[43])
    local footSize = Text_funding_aggregation_t_2:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, _ED.activity_to_full_service/10, config_res.font.font_name, footSize)
    _richText:pushBackElement(re1)
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[43], config_res.font.font_name, footSize)
    _richText:pushBackElement(re2)
    _richText:setAnchorPoint(0.5,0.5)
    _richText:setContentSize(cc.size(Text_funding_aggregation_t_2:getContentSize().width, Text_funding_aggregation_t_2:getContentSize().height))
    _richText:setPosition(cc.p(Text_funding_aggregation_t_2:getContentSize().width/2, Text_funding_aggregation_t_2:getContentSize().height/2))
    Text_funding_aggregation_t_2:addChild(_richText)
end

function RedAlertTimeFundingFullService:updateShowMilitary()
    -- 刷新军资
    local root = self.roots[1]
    local Text_funding_aggregation_t_2 = ccui.Helper:seekWidgetByName(root,"Text_funding_aggregation_t_2")
    Text_funding_aggregation_t_2:removeAllChildren(true)
    --Text_funding_aggregation_t_2:setString((_ED.activity_to_full_service/10)..activity_str_tip[43])
    local footSize = Text_funding_aggregation_t_2:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, _ED.activity_to_full_service/10, config_res.font.font_name, footSize)
    _richText:pushBackElement(re1)
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[43], config_res.font.font_name, footSize)
    _richText:pushBackElement(re2)
    _richText:setAnchorPoint(0.5,0.5)
    _richText:setContentSize(cc.size(Text_funding_aggregation_t_2:getContentSize().width, Text_funding_aggregation_t_2:getContentSize().height))
    _richText:setPosition(cc.p(Text_funding_aggregation_t_2:getContentSize().width/2, Text_funding_aggregation_t_2:getContentSize().height/2))
    Text_funding_aggregation_t_2:addChild(_richText)

    -- 刷新按钮领奖状态
    self._activity_type = _ED.activity_info["78"]
    for i=1,#self._activity_type.activity_data[1] do
        local Button_funding_rec = ccui.Helper:seekWidgetByName(root,"Button_funding_rec_"..i)
        local Text_funding_not = ccui.Helper:seekWidgetByName(root,"Text_funding_not_"..i)
        local rewarldData = zstring.split(self._activity_type.activity_data[1][i].achieve_complete_count, "/")
        if tonumber(self._activity_type.activity_data[1][i].achieve_state) == 1 then
            Button_funding_rec:setVisible(true)
            Text_funding_not:setVisible(false)
        else
            Button_funding_rec:setVisible(false)
            Text_funding_not:setVisible(true)
            if tonumber(self._activity_type.activity_data[1][i].achieve_state) == 0 then
                Text_funding_not:setColor(chat_rich_text_color[6])
                Text_funding_not:setString(activity_str_tip[8])
                if _ED.activity_to_full_service >= zstring.tonumber(rewarldData[2]) then
                    Button_funding_rec:setVisible(true)
                    Text_funding_not:setVisible(false)
                end    
            else
                Text_funding_not:setColor(chat_rich_text_color[1])
                Text_funding_not:setString(activity_str_tip[2])
            end
        end
    end

    -- 刷新进度条
    local LoadingBar_integral_bar_1 = ccui.Helper:seekWidgetByName(root,"LoadingBar_integral_bar_1")

    local rewarldData = zstring.split(self._activity_type.activity_data[1][1].achieve_complete_count, "/")
    local LoadingBarCell = zstring.tonumber(rewarldData[2])/5
    local number = 0
    for i=1, #self._activity_type.activity_data[1] do
        local index = #self._activity_type.activity_data[1]-i+1
        local rewarldData = zstring.split(self._activity_type.activity_data[1][index].achieve_complete_count, "/")
        if _ED.activity_to_full_service >= tonumber(rewarldData[2]) then
            number = number + LoadingBarCell
        else
            if index < 5 then
                local rewarldData2 = zstring.split(self._activity_type.activity_data[1][index+1].achieve_complete_count, "/")
                if _ED.activity_to_full_service >= tonumber(rewarldData2[2]) then
                    local add_number = (_ED.activity_to_full_service - tonumber(rewarldData2[2])) / (tonumber(rewarldData[2]) - tonumber(rewarldData2[2])) * LoadingBarCell
                    number = number + add_number
                end
            else
                number = _ED.activity_to_full_service / tonumber(rewarldData[2]) * LoadingBarCell
            end
        end
    end
    local persent_exp = number / zstring.tonumber(rewarldData[2]) *100
    LoadingBar_integral_bar_1:setPercent(persent_exp)
end

function RedAlertTimeFundingFullService:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.funding_aggregation_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	
	--前往充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_buy"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)
	
	
	for i=1, 5 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_funding_rec_"..i), nil, 
		{
			terminal_name = "red_alert_time_funding_full_service_receive", 
			terminal_state = 0, 
			touch_scale = true,
			touch_scale_xy = 0.95, 
			cells = self,
			_index = i,
		}, nil, 1)
	end
	
	self:onUpdateDraw()
end

function RedAlertTimeFundingFullService:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeFundingFullService:onExit()
    state_machine.remove("red_alert_time_funding_full_service_show")
    state_machine.remove("red_alert_time_funding_full_service_hide")
    state_machine.remove("red_alert_time_funding_full_service_receive")
    state_machine.remove("red_alert_time_funding_full_service_update_draw")
    state_machine.remove("red_alert_time_funding_full_service_update_military")
end