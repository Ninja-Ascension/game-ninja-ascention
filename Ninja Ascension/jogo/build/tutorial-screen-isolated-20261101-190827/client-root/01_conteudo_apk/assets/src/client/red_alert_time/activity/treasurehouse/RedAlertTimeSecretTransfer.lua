--------------------------------------------------------------------------------------------------------------
--  说明：科威特的秘密规则
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSecretTransfer = class("RedAlertTimeSecretTransferClass", Window)

--打开界面
local red_alert_time_secret_transfer_open_terminal = {
	_name = "red_alert_time_secret_transfer_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeSecretTransferClass") == nil then
    		fwin:open(RedAlertTimeSecretTransfer:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_secret_transfer_close_terminal = {
	_name = "red_alert_time_secret_transfer_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeSecretTransferClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_secret_transfer_open_terminal)
state_machine.add(red_alert_time_secret_transfer_close_terminal)
state_machine.init()

function RedAlertTimeSecretTransfer:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    -- 奖励绘制
    self._panel_list = {}
    self._image_list = {}
    self._once_gold = 0
	self._ten_gold = 0
    self._m_type = 0
    self.have_free_times = false
    self.m_times = 0
    self.m_reset_times = 0
    self.accept_the_prize = false
    self.ranking_refresh_time = 0
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRedAlertTimeSecretChest")
	
    local function init_red_alert_time_secret_transfer_terminal()
        local red_alert_time_secret_transfer_show_terminal = {
            _name = "red_alert_time_secret_transfer_show",
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

        local red_alert_time_secret_transfer_hide_terminal = {
            _name = "red_alert_time_secret_transfer_hide",
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

        -- 探索
        local red_alert_time_secret_transfer_explore_terminal = {
            _name = "red_alert_time_secret_transfer_explore",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("red_alert_time_secret_transfer_explore")
				local m_type = params._datas._type
                local activity_add_state = zstring.split(instance._activity_type.activity_add_state,",")
                if tonumber(activity_add_state[10])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
                else
                    TipDlg.drawTextDailog(activity_str_tip[88])
                    state_machine.unlock("red_alert_time_secret_transfer_explore")
                    return
                end
                if tonumber(m_type) > 0 and instance.have_free_times == true then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    state_machine.unlock("red_alert_time_secret_transfer_explore")
                    return
                end
                instance._m_type = m_type
                local shop_of_gold = 0
                local count = 0
                if m_type == 0 then
                    shop_of_gold = self._once_gold
                    count = 1
                    if tonumber(activity_add_state[5]) < tonumber(activity_add_state[6]) then
                        instance:costTransferExplore(0)
                        return
                    end
                else
                    shop_of_gold = self._ten_gold
                    count = 10
                end
                local tip = ConfirmTip:new()
                tip:init(instance, instance.costTransferExplore, string.format(red_alert_time_str[215], shop_of_gold,count))
                fwin:open(tip, fwin._windows)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 预览
        local red_alert_time_secret_transfer_preview_terminal = {
            _name = "red_alert_time_secret_transfer_preview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mould_id = params[1]
				local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
				local reworld = zstring.split(dms.string(dms["scene_reward"], tonumber(activity_add_state[9]), scene_reward.reward_items),"|")
				for i=1,#reworld do
					local datas = zstring.split(reworld[i], ",")
					if tonumber(mould_id) == tonumber(datas[1]) then
						state_machine.excute("red_alert_time_red_alert_time_secret_chest_window_open", 0, {i,activity_add_state[9]})
					end
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_secret_transfer_show_terminal)
        state_machine.add(red_alert_time_secret_transfer_hide_terminal)
        state_machine.add(red_alert_time_secret_transfer_explore_terminal)
        state_machine.add(red_alert_time_secret_transfer_preview_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_secret_transfer_terminal()
end

function RedAlertTimeSecretTransfer:costTransferExplore( sure_number )
    local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                self:drawUpdateButton()
                if self._m_type == 0 then
                    state_machine.excute("red_alert_time_secret_get_window_open", 0, {self._once_gold,acitvity.activity_id,self._activity_type.activity_type})
                else
                    state_machine.excute("red_alert_time_secret_get_ten_window_open", 0, {self._ten_gold,acitvity.activity_id,self._activity_type.activity_type})
                end
            end
            _ED.show_reward_list_group_ex = {}
        end
    end     
    if sure_number == 0 then
        protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n"..self._m_type
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
    else
        state_machine.unlock("red_alert_time_secret_transfer_explore")
    end
end

function RedAlertTimeSecretTransfer:drawUpdateButton()
	local root = self.roots[1]
	local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
	if tonumber(activity_add_state[5]) >=tonumber(activity_add_state[6]) then
		ccui.Helper:seekWidgetByName(root,"Panel_seek_treasure_one"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_seek_treasure_free"):setVisible(false)
        self.have_free_times = false
	else
		ccui.Helper:seekWidgetByName(root,"Panel_seek_treasure_one"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_seek_treasure_free"):setVisible(true)
        self.have_free_times = true
	end
end

function RedAlertTimeSecretTransfer:updateDraw()
    local root = self.roots[1]
	--信息
    local Text_seek_treasure_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_infor_p_1")
	Text_seek_treasure_infor_p_1:setString(self._activity_type.activity_dec)
	-- 时间
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
    local startTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[1] / 1000))
    local endTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[10] / 1000) - 1)
    local isEnd = false
    if tonumber(activity_add_state[10])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        -- endTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[10] / 1000) - 1)
        isEnd = false
    else
        isEnd = true
        -- endTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[2] / 1000) - 1)
    end
    self.accept_the_prize = isEnd
    local intervalTime = 0
    local time_str = ""
    if isEnd == true then
        self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        intervalTime = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        time_str = activity_str_tip[92]
    else
        self.m_times = ((tonumber(activity_add_state[10])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        intervalTime = ((tonumber(activity_add_state[10])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        time_str = activity_str_tip[93]
    end

    -- 结束和关闭倒计时
    local Text_seek_treasure_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_act_time_1")
    Text_seek_treasure_act_time_1:removeAllChildren(true)
    Text_seek_treasure_act_time_1:setString("")
    local font_size = Text_seek_treasure_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_seek_treasure_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_seek_treasure_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_seek_treasure_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_seek_treasure_act_time_1:addChild(time_int)

    -- 重置倒计时
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_seek_treasure_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_act_time_2")
    Text_seek_treasure_act_time_2:removeAllChildren(true)
    Text_seek_treasure_act_time_2:setString("")
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_seek_treasure_act_time_2:getContentSize().width - 80)
    reset_time_int:setPositionY(Text_seek_treasure_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_seek_treasure_act_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_seek_treasure_act_time_2:getContentSize().width - 80)
    reset_time_info:setPositionY(Text_seek_treasure_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_seek_treasure_act_time_2:addChild(reset_time_info)

	local reworld = zstring.split(dms.string(dms["scene_reward"], tonumber(activity_add_state[9]), scene_reward.reward_items),"|")
	for i=1, 20 do
		local Panel_seek_treasure_icon = ccui.Helper:seekWidgetByName(root,"Panel_seek_treasure_icon_"..i)
		Panel_seek_treasure_icon:removeAllChildren(true)
        Panel_seek_treasure_icon:removeBackGroundImage()
		
		local datas = zstring.split(reworld[i], ",")
		if tonumber(datas[1]) == -1 then
			datas[1] = resource_prop_id[tonumber(datas[2])]
			datas[2] = 1
		end
		local prop_type = tonumber(datas[2])
		local show_type = 9
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
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 13, equip_datas, tonumber(prop_type), 0})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 13, tonumber(datas[1]), tonumber(prop_type), 0})
		end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setVisible(false)
		Panel_seek_treasure_icon:addChild(cell)
	end

    -- 折扣
    local Text_seek_treasure_discount_n = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_discount_n")
    local curr = 10*tonumber(activity_add_state[8])
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr = (10 - curr) * 10
    end
    --local discounts = string.gsub(activity_str_tip[22], "x", curr)
    local discounts = string.format(activity_str_tip[22],""..curr)
    Text_seek_treasure_discount_n:setString(discounts)
	-- 10次折后价
	local Text_seek_treasure_ten_gold_n = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_ten_gold_n")
    self._ten_gold = math.ceil(tonumber(activity_add_state[7])*10*tonumber(activity_add_state[8]))
	Text_seek_treasure_ten_gold_n:setString(self._ten_gold)
	-- 10次现价
	local Text_seek_treasure_ten_old_gold_n = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_ten_old_gold_n")
	Text_seek_treasure_ten_old_gold_n:setString(tonumber(activity_add_state[7])*10)
	-- 单次折后价
	local Text_seek_treasure_one_gold_n = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_one_gold_n")
	Text_seek_treasure_one_gold_n:setString(math.ceil(tonumber(activity_add_state[7])*tonumber(activity_add_state[8])))
	-- 单次现价
	local Text_seek_treasure_one_old_gold_n = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_one_gold_n")
    self._once_gold = activity_add_state[7]
	Text_seek_treasure_one_old_gold_n:setString(self._once_gold)
	self:drawUpdateButton()

    local Button_seek_treasure_free = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_free")
    local Button_seek_treasure_one = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_one")
    local Button_seek_treasure_seek_ten = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_seek_ten")
    if isEnd == true then
        Button_seek_treasure_free:setBright(false)
        Button_seek_treasure_free:setTouchEnabled(false)
        Button_seek_treasure_one:setBright(false)
        Button_seek_treasure_one:setTouchEnabled(false)
        Button_seek_treasure_seek_ten:setBright(false)
        Button_seek_treasure_seek_ten:setTouchEnabled(false)
    else
        Button_seek_treasure_free:setBright(true)
        Button_seek_treasure_free:setTouchEnabled(true)
        Button_seek_treasure_one:setBright(true)
        Button_seek_treasure_one:setTouchEnabled(true)
        Button_seek_treasure_seek_ten:setBright(true)
        Button_seek_treasure_seek_ten:setTouchEnabled(true)
    end
end

--初始化
function RedAlertTimeSecretTransfer:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	
	--免费
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_free"), nil, 
    {
        terminal_name = "red_alert_time_secret_transfer_explore", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 0,
    }, nil, 1)
	
	--单次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_one"), nil, 
    {
        terminal_name = "red_alert_time_secret_transfer_explore", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 0,
    }, nil, 1)
	
	--10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_seek_ten"), nil, 
    {
        terminal_name = "red_alert_time_secret_transfer_explore", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 1,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeSecretTransfer:onUpdate(dt)
    if self.accept_the_prize == false then
        if self.ranking_refresh_time <= 0 then
            self.ranking_refresh_time = self.ranking_refresh_time + dt
            if self.ranking_refresh_time >= 5*60 then
                self:rankingRefresh()
                self.ranking_refresh_time = 0
            end
        end
    end
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_seek_treasure_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_seek_treasure_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:updateDraw()
        end
    end
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_seek_treasure_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_seek_treasure_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self.accept_the_prize == true then
                state_machine.excute("red_alert_time_center_find",0,"red_alert_time_secret_transfer_close")
            else
                self:updateDraw()
            end
        end
    end
end

function RedAlertTimeSecretTransfer:onEnterTransitionFinish()

end

function RedAlertTimeSecretTransfer:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	-- debug.print_r(self._activity_type)
	self:onInit()
    return self
end

function RedAlertTimeSecretTransfer:onExit()
    state_machine.remove("red_alert_time_secret_transfer_show")
    state_machine.remove("red_alert_time_secret_transfer_hide")
    state_machine.remove("red_alert_time_secret_transfer_explore")
    state_machine.remove("red_alert_time_secret_transfer_preview")
end