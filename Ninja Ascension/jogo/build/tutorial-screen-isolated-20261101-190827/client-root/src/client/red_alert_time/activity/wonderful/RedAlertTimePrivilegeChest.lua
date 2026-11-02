-----------------------------
--特权宝箱
-----------------------------
RedAlertTimePrivilegeChest = class("RedAlertTimePrivilegeChestClass", Window)

local red_alert_time_privilege_chest_window_open_terminal = {
    _name = "red_alert_time_privilege_chest_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimePrivilegeChestClass") then
            local panel = RedAlertTimePrivilegeChest:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_privilege_chest_window_open_terminal)
state_machine.init()

function RedAlertTimePrivilegeChest:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
	
    --load lua file
    -- Initialize red_alert_time_privilege_chest state machine.
    local function init_red_alert_time_privilege_chest_terminal()
	
        --
        local red_alert_time_privilege_chest_activity_codes_terminal = {
          _name = "red_alert_time_privilege_chest_activity_codes",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				local cell = params._datas.cell
				local acitvity = _ED.activity_info[""..cell.activity_type]
				local activity_info = _ED.activity_info[""..cell.activity_type].activity_data[1][cell._current_page]
				local reward = zstring.split(activity_info.achieve_reward, "|")
				local _objects = zstring.split(activity_info.achieve_other_info,",")
				if tonumber(_objects[3]) > tonumber(_ED.user_info.user_gold) then
					TipDlg.drawTextDailog(red_alert_all_str[79])
					return
				end
				local function responseBuyCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							local datas = zstring.split(reward[1], ",")
							local prop = fundPropWidthId(datas[1])
							_ED.show_reward_list_group_ex = {}
							local function responseCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									if response.node ~= nil and response.node.roots ~= nil then
										response.node:onUpdateDraw()
										response.node:onUpdateDrawPage(response.node._current_page)
										checkRewardObtainDraw()
									end
								end
							end
							protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n".."1".."\r\n".."-1".."\r\n".."-1"
                			NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, response.node, responseCallback, false, nil)
						end
					end
				end
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.activity_type.."\r\n".."0".."\r\n"..tonumber(activity_info.achieve_index)-1
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseBuyCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 
		local red_alert_time_privilege_chest_page_terminal = {
            _name = "red_alert_time_privilege_chest_page",
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
		
		--规则
		local red_alert_time_privilege_chest_rule_terminal = {
          _name = "red_alert_time_privilege_chest_rule",
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

        -- 刷新购买次数
		local red_alert_time_privilege_chest_buy_time_terminal = {
          _name = "red_alert_time_privilege_chest_buy_time",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				instance:onUpdateBuyTime()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_privilege_chest_activity_codes_terminal)
        state_machine.add(red_alert_time_privilege_chest_page_terminal)
        state_machine.add(red_alert_time_privilege_chest_rule_terminal)
        state_machine.add(red_alert_time_privilege_chest_buy_time_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_privilege_chest state machine.
    init_red_alert_time_privilege_chest_terminal()
end

function RedAlertTimePrivilegeChest:onUpdateDraw()
    local root = self.roots[1]
	--活动名称
	local Text_privilege_chest_name = ccui.Helper:seekWidgetByName(root,"Text_privilege_chest_name")
	Text_privilege_chest_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
	--活动描述
	local Text_privilege_chest_infor_p = ccui.Helper:seekWidgetByName(root,"Text_privilege_chest_infor_p")
	Text_privilege_chest_infor_p:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	
	--活动开启结束时间
	local Text_act_share_time_n = ccui.Helper:seekWidgetByName(root,"Text_privilege_chest_time_n")
	local Text_privilege_chest_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_privilege_chest_act_time_1")
    Text_act_share_time_n:removeAllChildren(true)
    Text_act_share_time_n:setString("")
    Text_privilege_chest_act_time_1:removeAllChildren(true)
    Text_privilege_chest_act_time_1:setString("")
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
	-- local intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
	self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
	-- if intervalTime > 1 then
	-- 	local _richText1 = ccui.RichText:create()
	-- 	_richText1:ignoreContentAdaptWithSize(false)
	-- 	local color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
	-- 	local re1 =ccui.RichElementText:create(1, color,255, startTime.."~"..endTime, config_res.font.font_name,18)
	-- 	_richText1:pushBackElement(re1)
	-- 	local color2 = cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3])
	-- 	local re2 = nil
	-- 	re2 =ccui.RichElementText:create(1, color2,255, string.format(activity_str_tip[41],math.floor(intervalTime)), config_res.font.font_name,18)
	-- 	_richText1:pushBackElement(re2)
	-- 	_richText1:setAnchorPoint(0.5,0.5)
	-- 	_richText1:setContentSize(cc.size(Text_act_share_time_n:getContentSize().width,18))
	-- 	_richText1:setPositionX(Text_act_share_time_n:getPositionX()*2.5+10)
	-- 	_richText1:setPositionY(Text_act_share_time_n:getContentSize().height/2)
	-- 	Text_act_share_time_n:addChild(_richText1)
	-- else
	-- 	-- Text_act_share_time_n:setString(startTime.."~"..endTime)
	-- 	local _richText1 = ccui.RichText:create()
	-- 	_richText1:ignoreContentAdaptWithSize(false)
	-- 	local color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
	-- 	local re1 =ccui.RichElementText:create(1, color,255, startTime.."~"..endTime, config_res.font.font_name,18)
	-- 	_richText1:pushBackElement(re1)
	-- 	_richText1:setAnchorPoint(0.5,0.5)
	-- 	_richText1:setContentSize(cc.size(Text_act_share_time_n:getContentSize().width,18))
	-- 	_richText1:setPositionX(Text_act_share_time_n:getPositionX()*2.5+10)
	-- 	_richText1:setPositionY(Text_act_share_time_n:getContentSize().height/2)
	-- 	Text_act_share_time_n:addChild(_richText1)
 --        local time_int = cc.Label:createWithTTF("", config_res.font.font_name, 18 / CC_CONTENT_SCALE_FACTOR())
 --        time_int:setName("time_int")
 --        time_int:setAnchorPoint(cc.p(0, 0.5))
 --        time_int:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
 --        time_int:setPositionX(Text_act_share_time_n:getContentSize().width/2+40)
 --        time_int:setPositionY(Text_act_share_time_n:getContentSize().height/2)
 --        time_int:setTag(100)
 --        Text_act_share_time_n:addChild(time_int)
	-- end	
    local font_size = Text_privilege_chest_act_time_1:getFontSize()
	local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_privilege_chest_act_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_privilege_chest_act_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_privilege_chest_act_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_privilege_chest_act_time_1:addChild(time_int_1)
end

function RedAlertTimePrivilegeChest:changeSelectPage( page )
    local root = self.roots[1]
    local Button_privilege_chest_lv_1 = ccui.Helper:seekWidgetByName(root, "Button_privilege_chest_lv_1")
    local Button_privilege_chest_lv_2 = ccui.Helper:seekWidgetByName(root, "Button_privilege_chest_lv_2")
    local Button_privilege_chest_lv_3 = ccui.Helper:seekWidgetByName(root, "Button_privilege_chest_lv_3")
    if page == self._current_page then
        if page == 1 then
            Button_privilege_chest_lv_1:setHighlighted(true)
        elseif page == 2 then
            Button_privilege_chest_lv_2:setHighlighted(true)
        elseif page == 3 then
            Button_privilege_chest_lv_3:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_privilege_chest_lv_1:setHighlighted(false)
    Button_privilege_chest_lv_2:setHighlighted(false)
    Button_privilege_chest_lv_3:setHighlighted(false)
    if page == 1 then
        Button_privilege_chest_lv_1:setHighlighted(true)
	elseif page == 2 then
		Button_privilege_chest_lv_2:setHighlighted(true)
	elseif page == 3 then
		Button_privilege_chest_lv_3:setHighlighted(true)
	end
	self:onUpdateDrawPage(page)
end

function RedAlertTimePrivilegeChest:onUpdateDrawPage(page)
	local root = self.roots[1]
	--图片底
	local Panel_privilege_chest_text = ccui.Helper:seekWidgetByName(root, "Panel_privilege_chest_text")
	Panel_privilege_chest_text:setBackGroundImage(string.format("images/ui/wonderful/red_privilege_chest_text_%d.png", tonumber(page)))
	--宝箱图
	local Panel_privilege_chest_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_privilege_chest_icon_1")
	Panel_privilege_chest_icon_1:removeAllChildren(true)
	local reward = zstring.split(_ED.activity_info[""..self.activity_type].activity_data[1][tonumber(page)].achieve_reward, "|")
	local datas = zstring.split(reward[1], ",")
	if tonumber(datas[1]) == -1 then
		datas[1] = resource_prop_id[tonumber(datas[2])]
		datas[2] = 1
	end
	local prop_type = tonumber(datas[2])
	local show_type = 1
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
	if prop_type == 7 then
		local equip_datas = {}
		equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
		equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
		cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, equip_datas, tonumber(prop_type), 0})
	else
		cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), 0,nil,tonumber(datas[1])})
	end
	Panel_privilege_chest_icon_1:addChild(cell)
	--奖励内容
	local reward = zstring.split(_ED.activity_info[""..self.activity_type].activity_data[2][tonumber(page)].achieve_reward, "|")
	for i = 1, 4 do
		local Panel_privilege_chest_icon = ccui.Helper:seekWidgetByName(root, string.format("Panel_privilege_chest_icon_%s", i+1))
		Panel_privilege_chest_icon:removeAllChildren(true)
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
		Panel_privilege_chest_icon:addChild(cell)
	end
	self:onUpdateBuyTime()
end

function RedAlertTimePrivilegeChest:onUpdateBuyTime()
	local root = self.roots[1]
	--vip可购买次数
	local Text_privilege_chest_buy_time_n = ccui.Helper:seekWidgetByName(root, "Text_privilege_chest_buy_time_n")
	Text_privilege_chest_buy_time_n:removeAllChildren(true)
	local production_count_max = dms.int(dms["base_consume"], 98+tonumber(self._current_page), tonumber(_ED.vip_grade) + 4)
	local activity_add_state = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state,",")
	local number = production_count_max - tonumber(activity_add_state[3+tonumber(self._current_page)])
	local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, number, "fonts/simhei.ttf",20)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..production_count_max, "fonts/simhei.ttf",20)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_privilege_chest_buy_time_n:getContentSize().width/2,Text_privilege_chest_buy_time_n:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_privilege_chest_buy_time_n:getContentSize().width,20))
    Text_privilege_chest_buy_time_n:addChild(_richText)

    -- VIP等级
	local Text_privilege_chest_vip_n = ccui.Helper:seekWidgetByName(root, "Text_privilege_chest_vip_n")
	Text_privilege_chest_vip_n:setString(string.format(activity_str_tip[76],"".._ED.vip_grade))

	--消耗宝石数
	local Text_privilege_chest_buy_gold_n = ccui.Helper:seekWidgetByName(root, "Text_privilege_chest_buy_gold_n")
	local _objects = zstring.split(_ED.activity_info[""..self.activity_type].activity_data[1][tonumber(self._current_page)].achieve_other_info,",")
	Text_privilege_chest_buy_gold_n:setString(_objects[3])
	
	if number > 0 then
		ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_buy"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_buy"):setBright(true)
	else
		ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_buy"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_buy"):setBright(false)
	end
end

function RedAlertTimePrivilegeChest:onUpdate(dt)
	if self.m_times > 0 then
        self.m_times = self.m_times - dt
  --       if ccui.Helper:seekWidgetByName(self.roots[1],"Text_privilege_chest_time_n"):getChildByTag(100) ~= nil then
		-- 	ccui.Helper:seekWidgetByName(self.roots[1],"Text_privilege_chest_time_n"):getChildByTag(100):setString(string.format(activity_str_tip[62],getRedAlertTimeFormat(self.m_times)))
		-- end
		if ccui.Helper:seekWidgetByName(self.roots[1],"Text_privilege_chest_act_time_1"):getChildByTag(100) ~= nil then
		  	ccui.Helper:seekWidgetByName(self.roots[1],"Text_privilege_chest_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
		end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
end

function RedAlertTimePrivilegeChest:onEnterTransitionFinish()

end

function RedAlertTimePrivilegeChest:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_privilege_chest)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_lv_1"), nil, 
    {
        terminal_name = "red_alert_time_privilege_chest_page", 
        terminal_state = 0, 
		_page = 1,
    }, nil, 1)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_lv_2"), nil, 
    {
        terminal_name = "red_alert_time_privilege_chest_page", 
        terminal_state = 0, 
		_page = 2,
    }, nil, 1)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_lv_3"), nil, 
    {
        terminal_name = "red_alert_time_privilege_chest_page", 
        terminal_state = 0, 
		_page = 3,
    }, nil, 1)
	
	--规则
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_rule"), nil, 
    {
        terminal_name = "red_alert_time_privilege_chest_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--充值
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--购买
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_privilege_chest_buy"), nil, 
    {
        terminal_name = "red_alert_time_privilege_chest_activity_codes", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cell = self,
    }, nil, 1)
	
	
	self:onUpdateDraw()
	self:changeSelectPage(1)
end

function RedAlertTimePrivilegeChest:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimePrivilegeChest:onExit()
    state_machine.remove("red_alert_time_privilege_chest_activity_codes")
    state_machine.remove("red_alert_time_privilege_chest_page")
    state_machine.remove("red_alert_time_privilege_chest_rule")
    state_machine.remove("red_alert_time_privilege_chest_buy_time")
end
