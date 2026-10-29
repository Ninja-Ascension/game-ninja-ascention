-----------------------------
--连续7天充值
-----------------------------
RedAlertTimeSevenDayRecruit = class("RedAlertTimeSevenDayRecruitClass", Window)

local red_alert_time_seven_day_recruit_window_open_terminal = {
    _name = "red_alert_time_seven_day_recruit_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeSevenDayRecruitClass") then
            local panel = RedAlertTimeSevenDayRecruit:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_seven_day_recruit_window_open_terminal)
state_machine.init()

function RedAlertTimeSevenDayRecruit:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
    self._max_sign_day = 0

	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	app.load("client.red_alert_time.activity.wonderful.RedAlertTime7DaysReward")
	
    --load lua file
    -- Initialize red_alert_time_seven_day_recruit state machine.
    local function init_red_alert_time_seven_day_recruit_terminal()
	
        --
        local red_alert_time_seven_day_recruit_activity_codes_terminal = {
          _name = "red_alert_time_seven_day_recruit_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				-- local cell = params._datas.cell
				local acitvity = _ED.activity_info["79"]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:onUpdateDraw()
							checkRewardObtainDraw()
						end
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n79\r\n0\r\n0\r\n0"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         local red_alert_time_seven_day_recruit_supplemented_terminal = {
          _name = "red_alert_time_seven_day_recruit_supplemented",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
          		local activity_info = _ED.activity_info["79"]
          		local timesData = zstring.split(activity_info.activity_add_state, ",")
          		local todayFinishState = zstring.tonumber(timesData[8])
          		if tonumber(timesData[4]) >= 7 then
					state_machine.excute("recharge_dialog_window_open",0,"")
				else
					if todayFinishState == 0 then
		          		if tonumber(timesData[6]) - tonumber(timesData[4]) > 1 then
							state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = instance, m_type = 20}})
						else
							state_machine.excute("recharge_dialog_window_open",0,"")
		          		end
		          	else
		          		if tonumber(timesData[6]) - tonumber(timesData[4]) >= 1 then
							state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = instance, m_type = 20}})
						else
							state_machine.excute("recharge_dialog_window_open",0,"")
		          		end
		          	end
		        end
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         local red_alert_time_seven_day_recruit_supplemented_confirm_terminal = {
          _name = "red_alert_time_seven_day_recruit_supplemented_confirm",
          _init = function (terminal) 
              
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				-- local cell = params._datas.cell
				local acitvity = _ED.activity_info["79"]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:onUpdateDraw()
						end
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n".."79".."\r\n".."0".."\r\n".."0".."\r\n1"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         local red_alert_time_seven_day_recruit_update_draw_terminal = {
          _name = "red_alert_time_seven_day_recruit_update_draw",
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
		
        state_machine.add(red_alert_time_seven_day_recruit_activity_codes_terminal)
        state_machine.add(red_alert_time_seven_day_recruit_supplemented_terminal)
        state_machine.add(red_alert_time_seven_day_recruit_supplemented_confirm_terminal)
        state_machine.add(red_alert_time_seven_day_recruit_update_draw_terminal)

        state_machine.init()
    end
    
    -- call func init red_alert_time_seven_day_recruit state machine.
    init_red_alert_time_seven_day_recruit_terminal()
end

function RedAlertTimeSevenDayRecruit:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self.activity_type]
	--活动名称
	local Text_seven_day_recruit_name = ccui.Helper:seekWidgetByName(root,"Text_seven_day_recruit_name")
	Text_seven_day_recruit_name:setString(activity_info.activity_title)
	--活动描述
	local Text_seven_day_recruit_infor_p = ccui.Helper:seekWidgetByName(root,"Text_seven_day_recruit_infor_p")
	Text_seven_day_recruit_infor_p:setString(activity_info.activity_dec)
	
	local Text_act_share_tit = ccui.Helper:seekWidgetByName(root,"Text_act_share_tit")
	Text_act_share_tit:setString(activity_info.activity_data[1][1].achieve_mould_name)
	
	local ListView_act_share_reward = ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward")
	ListView_act_share_reward:removeAllItems()
	local reward = zstring.split(activity_info.activity_data[1][1].achieve_reward, "|")
	for i=1, #reward do
		local datas = zstring.split(reward[i], ",")
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
			prop_from_type = 4
		else
			prop_type = 1
			prop_from_type = 1
		end
		-- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
		local cell = nil
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
		end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
		ListView_act_share_reward:addChild(cell)
	end
	ListView_act_share_reward:requestRefreshView()

	--进度描述
	local Text_seven_day_recruit_p = ccui.Helper:seekWidgetByName(root,"Text_seven_day_recruit_p")
	Text_seven_day_recruit_p:removeAllChildren(true)
	local _richText2 = ccui.RichText:create()
	_richText2:ignoreContentAdaptWithSize(false)
	_richText2:setContentSize(cc.size(Text_seven_day_recruit_p:getContentSize().width, Text_seven_day_recruit_p:getContentSize().height))
	_richText2:setAnchorPoint(cc.p(0, 0.5))
	local counts = zstring.split(activity_info.activity_data[1][1].achieve_complete_count, "/")
	--local strs = string.gsub(activity_str_tip[32], "x", counts[1])
	--local char_str = string.gsub(strs, "y", tonumber(counts[2]) - tonumber(counts[1]))
    self._max_sign_day = tonumber(counts[2])
	local last_day = tonumber(counts[2]) - tonumber(counts[1])
	local char_str = string.format(activity_str_tip[32],""..counts[1],""..last_day)
	local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		char_str, 
		cc.c3b(189, 206, 224),
		cc.c3b(189, 206, 224),
		0, 
		0, 
		config_res.font.font_name, 
		20,
		chat_rich_text_color)
		_richText2:formatTextExt()
		local rsize = _richText2:getContentSize()
		_richText2:setPositionY(Text_seven_day_recruit_p:getContentSize().height/2)
		-- _richText2:setPositionX(Text_seven_day_recruit_p:getContentSize().width/2)
		Text_seven_day_recruit_p:addChild(_richText2)
	
	local LoadingBar_seven_day_recruit_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_seven_day_recruit_bar")
    local persent_exp = zstring.tonumber(counts[1]) * 16
    LoadingBar_seven_day_recruit_bar:setPercent(persent_exp)
	
	local Button_act_share_rec = ccui.Helper:seekWidgetByName(root,"Button_act_share_rec")
	local Text_act_share_not = ccui.Helper:seekWidgetByName(root,"Text_act_share_not")
	if tonumber(activity_info.activity_data[1][1].achieve_state) == 1 and tonumber(counts[1]) == tonumber(counts[2]) then
		Button_act_share_rec:setVisible(true)
		Text_act_share_not:setVisible(false)
	elseif tonumber(activity_info.activity_data[1][1].achieve_state) == 2 then
		Button_act_share_rec:setVisible(false)
		Text_act_share_not:setVisible(true)
		Text_act_share_not:setString(activity_str_tip[2])
	else
		Button_act_share_rec:setVisible(false)
		Text_act_share_not:setVisible(true)
		Text_act_share_not:setString(activity_str_tip[8])
	end
	
	for i,v in pairs(activity_info.activity_data[2]) do
		local Panel_seven_day_recruit_icon = ccui.Helper:seekWidgetByName(root,string.format("Panel_seven_day_recruit_icon_%s", i))
		local Panel_seven_day_recruit_props = ccui.Helper:seekWidgetByName(root,string.format("Panel_seven_day_recruit_props_%s", i))
		Panel_seven_day_recruit_props:removeAllChildren(true)
		-- display:ungray(Panel_seven_day_recruit_props)
		if v.achieve_reward == "-1" then
			Panel_seven_day_recruit_icon:setVisible(false)
		else
			Panel_seven_day_recruit_icon:setVisible(true)
			local rewarld = zstring.split(v.achieve_reward, "|")
			local datas = zstring.split(rewarld[1], ",")
			if tonumber(datas[1]) == -1 then
				datas[1] = resource_prop_id[tonumber(datas[2])]
			end
			local pic_index = zstring.split(dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.pic_index),",")
			local quality_icon = cc.Sprite:create(string.format(config_res.images.ui.props.props, pic_index[1]))
			quality_icon:setPosition(cc.p(Panel_seven_day_recruit_props:getContentSize().width/2,Panel_seven_day_recruit_props:getContentSize().height/2))
			Panel_seven_day_recruit_props:addChild(quality_icon)
			
			if tonumber(v.achieve_state) >= 1 then
				display:ungray(quality_icon)
			else
				display:gray(quality_icon)
			end
		end
	end
	-- 活动开启结束时间
	local Text_red_envelopes_time_n = ccui.Helper:seekWidgetByName(root,"Text_seven_day_recruit_time_n")
	Text_red_envelopes_time_n:removeAllChildren(true)
    Text_red_envelopes_time_n:setString("")
    local Text_seven_day_recruit_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_seven_day_recruit_act_time_1")
    local Text_seven_day_recruit_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_seven_day_recruit_act_time_2")
    Text_seven_day_recruit_act_time_1:removeAllChildren(true)
    Text_seven_day_recruit_act_time_1:setString("")
    Text_seven_day_recruit_act_time_2:removeAllChildren(true)
    Text_seven_day_recruit_act_time_2:setString("")
	local timesData = zstring.split(activity_info.activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
	self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    local font_size = Text_seven_day_recruit_act_time_1:getFontSize()
	local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_seven_day_recruit_act_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_seven_day_recruit_act_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_seven_day_recruit_act_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_seven_day_recruit_act_time_1:addChild(time_int_1)

    local time_info_2 = cc.Label:createWithTTF(activity_str_tip[97], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_seven_day_recruit_act_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_seven_day_recruit_act_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_seven_day_recruit_act_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_seven_day_recruit_act_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_seven_day_recruit_act_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_seven_day_recruit_act_time_2:addChild(time_int_2)

	local experienceNumber = ((tonumber(timesData[1])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
	local todayFinishState = zstring.tonumber(timesData[8])
	if tonumber(timesData[4]) >= 7 then
		ccui.Helper:seekWidgetByName(root,"Button_seven_day_recruit_sign"):setTitleText(red_alert_time_str[30])
	else
		if todayFinishState == 0 then
			if tonumber(timesData[6]) - tonumber(timesData[4]) > 1 then
				ccui.Helper:seekWidgetByName(root,"Button_seven_day_recruit_sign"):setTitleText(activity_str_tip[23])
			else
				ccui.Helper:seekWidgetByName(root,"Button_seven_day_recruit_sign"):setTitleText(red_alert_time_str[30])
			end
		else
			if tonumber(timesData[6]) - tonumber(timesData[4]) >= 1 then
				ccui.Helper:seekWidgetByName(root,"Button_seven_day_recruit_sign"):setTitleText(activity_str_tip[23])
			else
				ccui.Helper:seekWidgetByName(root,"Button_seven_day_recruit_sign"):setTitleText(red_alert_time_str[30])
			end
		end
	end
end

function RedAlertTimeSevenDayRecruit:onUpdate(dt)
	if self.m_times > 0 then
        self.m_times = self.m_times - dt

		if ccui.Helper:seekWidgetByName(self.roots[1],"Text_seven_day_recruit_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_seven_day_recruit_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        local server_time = getCurrentGTM8Time()
        local leave_time = 86400 - (server_time.hour * 3600 + server_time.min * 60 + server_time.sec)
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_seven_day_recruit_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_seven_day_recruit_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(leave_time))
        end
        if leave_time <= 0 then
	        self:onUpdateDraw()
	    end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
end

function RedAlertTimeSevenDayRecruit:onEnterTransitionFinish()

end

function RedAlertTimeSevenDayRecruit:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_seven_day_recruit)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--
	for i=1, 7 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,string.format("Panel_seven_day_recruit_icon_%s", i)), nil, 
		{
			terminal_name = "red_alert_time_7_days_reward_window_open", 
			terminal_state = 0, 
			-- touch_scale = true,
			-- touch_scale_xy = 0.95, 
			cells = self,
			index = i,
		}, nil, 1)
	end
	
	--补签
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_seven_day_recruit_sign"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_recruit_supplemented", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self,
    }, nil, 1)
	
	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_recruit_activity_codes", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self,
    }, nil, 1)
	
	self:onUpdateDraw()
end

function RedAlertTimeSevenDayRecruit:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeSevenDayRecruit:onExit()
    state_machine.remove("red_alert_time_seven_day_recruit_activity_codes")
    state_machine.remove("red_alert_time_seven_day_recruit_supplemented")
    state_machine.remove("red_alert_time_seven_day_recruit_supplemented_confirm")
    state_machine.remove("red_alert_time_seven_day_recruit_update_draw")
end
