-----------------------------
--秘宝探险
-----------------------------
RedAlertTimeTreasureQuest = class("RedAlertTimeTreasureQuestClass", Window)

local red_alert_time_treasure_quest_window_open_terminal = {
    _name = "red_alert_time_treasure_quest_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeTreasureQuestClass") then
            local panel = RedAlertTimeTreasureQuest:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_treasure_quest_window_open_terminal)
state_machine.init()

function RedAlertTimeTreasureQuest:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    --load lua file
    -- Initialize red_alert_time_treasure_quest state machine.
    local function init_red_alert_time_treasure_quest_terminal()
	
        --
        local red_alert_time_treasure_quest_activity_codes_terminal = {
          _name = "red_alert_time_treasure_quest_activity_codes",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				local cell = params._datas.cell
				local acitvity = _ED.activity_info[""..cell.activity_type]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							cell:onUpdateDraw()
							checkRewardObtainDraw()
						end
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.activity_type.."\r\n".."0".."\r\n"..tonumber(_ED.activity_info[""..cell.activity_type].activity_data[1][1].achieve_index)-1
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
		local red_alert_time_treasure_quest_jump_world_terminal = {
          _name = "red_alert_time_treasure_quest_jump_world",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
          		state_machine.excute("wonderful_window_close", 0, 0)
				state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
		local red_alert_time_treasure_quest_go_to_terminal = {
          _name = "red_alert_time_treasure_quest_go_to",
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
		
		
        state_machine.add(red_alert_time_treasure_quest_activity_codes_terminal)
        state_machine.add(red_alert_time_treasure_quest_jump_world_terminal)
        state_machine.add(red_alert_time_treasure_quest_go_to_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_treasure_quest state machine.
    init_red_alert_time_treasure_quest_terminal()
end

function RedAlertTimeTreasureQuest:onUpdateDraw()
    local root = self.roots[1]
	--活动名称
	local Text_treasure_quest_name = ccui.Helper:seekWidgetByName(root,"Text_treasure_quest_name")
	Text_treasure_quest_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
	--活动描述
	local Text_treasure_quest_infor = ccui.Helper:seekWidgetByName(root,"Text_treasure_quest_infor")
	Text_treasure_quest_infor:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	
	--活动开启结束时间
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
	local intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
	self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    -- 结束和关闭倒计时
    local Text_act_share_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_1")
    Text_act_share_act_time_1:removeAllChildren(true)
    Text_act_share_act_time_1:setString("")
    local font_size = Text_act_share_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_act_share_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_act_share_act_time_1:addChild(time_int)
	
	local Panel_treasure_quest_icon_5 = ccui.Helper:seekWidgetByName(root,"Panel_treasure_quest_icon_5")
	Panel_treasure_quest_icon_5:removeAllChildren(true)
	local datas = zstring.split(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_reward, ",")
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
	local m_number = 0
	for i, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(datas[1]) then
			m_number = tonumber(v.prop_number)	
		end
	end

	local cell = nil
	if prop_type == 7 then
		local equip_datas = {}
		equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
		equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
		cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), m_number})
	else
		cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), m_number,nil,tonumber(datas[1])})
	end
	Panel_treasure_quest_icon_5:addChild(cell)
	local isSynthesis = true
	local rewarld = zstring.split(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_other_info, ",")
	for i=1, 4 do
		local Panel_treasure_quest_icon = ccui.Helper:seekWidgetByName(root, string.format("Panel_treasure_quest_icon_%s", i))
		Panel_treasure_quest_icon:removeAllChildren(true)
		local datas = {}
		local index = 0
		if i == 1 then
			index = 0
		elseif i==2 then
			index = 4
		elseif i==3 then
			index = 8
		elseif i==4 then
			index = 12
		end
		for j=1,4 do
			datas[j] = rewarld[index+j]
		end
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
		local cell = nil
		local number = 0
		for w, v in pairs(_ED.user_prop) do
			if tonumber(v.user_prop_template) == tonumber(datas[1]) then
				number = tonumber(v.prop_number)	
			end
		end
		if number == 0 then
			isSynthesis = false
		end
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), number})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), number,nil,tonumber(datas[1])})
		end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
		Panel_treasure_quest_icon:addChild(cell)
	end

	if isSynthesis == false then
		ccui.Helper:seekWidgetByName(root,"Button_treasure_quest_synthesis"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_treasure_quest_synthesis"):setBright(false)
	else
		ccui.Helper:seekWidgetByName(root,"Button_treasure_quest_synthesis"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root,"Button_treasure_quest_synthesis"):setBright(true)	
	end
	--宝箱钥匙
	local Panel_treasure_quest_box_icon = ccui.Helper:seekWidgetByName(root,"Panel_treasure_quest_box_icon")
	Panel_treasure_quest_box_icon:removeAllChildren(true)
	local number = 0
	for i, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == 694 then
			number = tonumber(v.prop_number)	
		end
	end
	local cell = state_machine.excute("props_icon_create_cell",0,{6, 1, 694, 1, number,nil,694})
	Panel_treasure_quest_box_icon:addChild(cell)
end

function RedAlertTimeTreasureQuest:onUpdate(dt)
	if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
end

function RedAlertTimeTreasureQuest:onEnterTransitionFinish()

end

function RedAlertTimeTreasureQuest:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_treasure_quest)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	--前往
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_treasure_quest_go"), nil, 
    {
        terminal_name = "red_alert_time_treasure_quest_jump_world", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	--合成
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_treasure_quest_synthesis"), nil, 
    {
        terminal_name = "red_alert_time_treasure_quest_activity_codes", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cell = self,
    }, nil, 1)
	--规则
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_treasure_quest_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_treasure_quest_go_to", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cell = self,
    }, nil, 1)

	
	self:onUpdateDraw()
end

function RedAlertTimeTreasureQuest:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeTreasureQuest:onExit()
    state_machine.remove("red_alert_time_treasure_quest_activity_codes")
end
