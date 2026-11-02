-----------------------------
--幸运抽奖
-----------------------------
RedAlertTimeLuckyDraw = class("RedAlertTimeLuckyDrawClass", Window)

local red_alert_time_lucky_draw_window_open_terminal = {
    _name = "red_alert_time_lucky_draw_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeLuckyDrawClass") then
			fwin:open(RedAlertTimeLuckyDraw:new():init(), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_lucky_draw_window_close_terminal = {
    _name = "red_alert_time_lucky_draw_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("home_map_update_tanke_info", 0, nil)
        fwin:close(fwin:find("RedAlertTimeLuckyDrawClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_lucky_draw_window_open_terminal)
state_machine.add(red_alert_time_lucky_draw_window_close_terminal)
state_machine.init()

function RedAlertTimeLuckyDraw:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0
	--抽奖状态0抽奖前的消耗，1开始抽奖，2抽奖完成
	self._ordinary_lottery_status = 0
	self._advanced_lottery_status = 0

    self.m_reset_times = 0

    self._base_panel_scale = 1
	
	self._params = nil
	app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
	
    -- Initialize red_alert_time_lucky_draw state machine.
    local function init_red_alert_time_lucky_draw_terminal()
		--翻页
		local red_alert_time_lucky_draw_change_page_terminal = {
            _name = "red_alert_time_lucky_draw_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            if funOpenDrawTip(params._datas._fun_open) == true then
		            return
		        end 
		        for i=1,9 do
		        	local Panel_draw_icon = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Panel_draw_icon_%s",i))
		        	Panel_draw_icon:setScale(instance._base_panel_scale)
		        	Panel_draw_icon:stopAllActions()
		        	state_machine.unlock("red_alert_time_lucky_draw_all_lucky_draw")
		        end
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local red_alert_time_lucky_draw_lottery_terminal = {
            _name = "red_alert_time_lucky_draw_lottery",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							local status = 0
							if response.node._current_page == 1 then
								status = response.node._ordinary_lottery_status
							else
								status = response.node._advanced_lottery_status
							end
							if status == 0 then
								if response.node._current_page == 1 then
									response.node._ordinary_lottery_status = 1
								else
									response.node._advanced_lottery_status = 1
								end
								response.node:onUpdateDraw(response.node._current_page)
							end
						end
					end
				end		
				protocol_command.draw_activity_reward.param_list = _ED.activity_info["46"].activity_id .. "\r\n".."46".."\r\n"..(instance._current_page-1).."\r\n".."0".."\r\n0"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_lucky_draw_all_lottery_terminal = {
            _name = "red_alert_time_lucky_draw_all_lottery",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:updateDrawBoxAll()
							checkRewardObtainDraw()
						end
					end
				end	
				protocol_command.draw_activity_reward.param_list = _ED.activity_info["46"].activity_id .. "\r\n".."46".."\r\n"..(instance._current_page-1).."\r\n".."0".."\r\n1"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--免费抽奖
		local red_alert_time_lucky_draw_free_lucky_draw_terminal = {
            _name = "red_alert_time_lucky_draw_free_lucky_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _params = zstring.split(_ED.activity_info["46"].activity_add_state, "|")
				-- self._params = _params
				local datasInfo = zstring.split(_params[instance._current_page], ",")
				if tonumber(datasInfo[4]) > tonumber(_ED.vip_grade) then
					datasInfo[1] = "1"
				end
				local conuts = 0
				for i, v in pairs(_ED.user_prop) do
					if tonumber(v.user_prop_template) == dms.int(dms["prop_config"], 20, prop_config.param) then
						conuts = tonumber(v.prop_number)
					end
				end
				if tonumber(datasInfo[1]) ~= 0 then
					if tonumber(instance._current_page) == 1 then
						if conuts < 1 then
							state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_draw_one_gold_n"):getString(), m_type = 14}})
							return
						end
					else
						if conuts < 3 then	
							state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_draw_one_gold_n"):getString(), m_type = 14}})
							return
						end
					end
				end
				state_machine.excute("red_alert_time_lucky_draw_lottery",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--全部开启
		local red_alert_time_lucky_draw_all_lucky_draw_terminal = {
            _name = "red_alert_time_lucky_draw_all_lucky_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("red_alert_time_lucky_draw_all_lucky_draw")
            	local _params = zstring.split(_ED.activity_info["46"].activity_add_state, "|")
            	local fun_open = {232,233}
            	if funOpenDrawTip(fun_open[self._current_page]) == true then
		            return
		        end 
				-- self._params = _params
				local datasInfo = zstring.split(_params[self._current_page], ",")
				if tonumber(datasInfo[4]) > tonumber(_ED.vip_grade) then
					datasInfo[1] = "1"
				end
				if tonumber(datasInfo[1]) == 0 then
					TipDlg.drawTextDailog(activity_str_tip[53])
					state_machine.unlock("red_alert_time_lucky_draw_all_lucky_draw")
					return
				end
				local conuts = 0
				for i, v in pairs(_ED.user_prop) do
					if tonumber(v.user_prop_template) == dms.int(dms["prop_config"], 20, prop_config.param) then
						conuts = tonumber(v.prop_number)
					end
				end
				if tonumber(instance._current_page) == 1 then
					if conuts < 9 then
						ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_draw_open"):setVisible(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1],"Image_15_0_0"):setVisible(false)
						state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_draw_all_gold_n"):getString(), m_type = 15}})
						return
					end
				else
					if conuts < 3*9 then	
						ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_draw_open"):setVisible(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1],"Image_15_0_0"):setVisible(false)
						state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_draw_all_gold_n"):getString(), m_type = 15}})
						return
					end
				end
				state_machine.excute("red_alert_time_lucky_draw_all_lottery",0,0)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回抽奖
		local red_alert_time_lucky_draw_return_draw_terminal = {
            _name = "red_alert_time_lucky_draw_return_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local status = 0
				if instance._current_page == 1 then
					status = instance._ordinary_lottery_status
				else
					status = instance._advanced_lottery_status
				end
				if status == 2 then
					if instance._current_page == 1 then
						instance._ordinary_lottery_status = 0
					else
						instance._advanced_lottery_status = 0
					end
					instance:onUpdateDraw(instance._current_page)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--选择号码
		local red_alert_time_lucky_draw_select_number_terminal = {
            _name = "red_alert_time_lucky_draw_select_number",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("red_alert_time_lucky_draw_select_number")
				local index = tonumber(params._datas._index)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:updateDrawbox(index)
							checkRewardObtainDraw()
							checkPlayEffect(66)

						end
					end
					state_machine.unlock("red_alert_time_lucky_draw_select_number")
				end	
				protocol_command.draw_activity_reward.param_list = _ED.activity_info["46"].activity_id .. "\r\n".."46".."\r\n"..(instance._current_page-1).."\r\n".."0".."\r\n"..(10+index)
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 解锁
		local red_alert_time_lucky_draw_unlock_terminal = {
            _name = "red_alert_time_lucky_draw_unlock",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_draw_open"):setVisible(true)
                ccui.Helper:seekWidgetByName(instance.roots[1],"Image_15_0_0"):setVisible(true)
            	state_machine.unlock("red_alert_time_lucky_draw_all_lucky_draw")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_lucky_draw_change_page_terminal)
        state_machine.add(red_alert_time_lucky_draw_free_lucky_draw_terminal)
        state_machine.add(red_alert_time_lucky_draw_all_lucky_draw_terminal)
        state_machine.add(red_alert_time_lucky_draw_return_draw_terminal)
        state_machine.add(red_alert_time_lucky_draw_select_number_terminal)
        state_machine.add(red_alert_time_lucky_draw_lottery_terminal)
        state_machine.add(red_alert_time_lucky_draw_all_lottery_terminal)
        state_machine.add(red_alert_time_lucky_draw_unlock_terminal)

        state_machine.init()
    end
    
    -- call func init red_alert_time_lucky_draw state machine.
    init_red_alert_time_lucky_draw_terminal()
end

function RedAlertTimeLuckyDraw:updateRewardPreview()
    local root = self.roots[1]

    local reward_ids = {}
    for i = 1, dms.count(dms["secret_shop_info"]) do
        local show_type_info = zstring.split(dms.string(dms["secret_shop_info"], i, secret_shop_info.show_type), ",")
        if tonumber(_ED.user_info.user_grade) >= tonumber(show_type_info[1]) 
            and tonumber(_ED.user_info.user_grade) <= tonumber(show_type_info[2])
            and self._current_page == tonumber(show_type_info[3])
            then
            table.insert(reward_ids, i)
        end
    end
    for i = 1, #reward_ids do
        local Panel_draw_reward = ccui.Helper:seekWidgetByName(root,"Panel_draw_reward_"..i)
        if Panel_draw_reward ~= nil then
            Panel_draw_reward:removeAllChildren(true)
            local itemsData = dms.element(dms["secret_shop_info"], tonumber(reward_ids[i]))
            local number = dms.atoi(itemsData,secret_shop_info.number)
            local item_type = dms.atoi(itemsData,secret_shop_info.item_type)

            prop_data = {}
            prop_data.prop_item = dms.atoi(itemsData,secret_shop_info.mould_id)
            prop_data.prop_type = 0
            prop_data.item_value = number
            if item_type == 0 then  --道具
                prop_data.prop_type = 6
            elseif item_type == 1 then      --坦克
                prop_data.prop_type = 13
            elseif item_type == 2 then      --配件
                prop_data.prop_type = 7
            else
                prop_data.prop_type = 6
            end
            local cell = createPropIconCell(prop_data, true, false, true)
            Panel_draw_reward:addChild(cell)
        end
    end
end

function RedAlertTimeLuckyDraw:updateDrawBoxAll()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root,"Panel_draw_open"):setVisible(false)
    ccui.Helper:seekWidgetByName(root,"Image_15_0_0"):setVisible(false)
	local _params = zstring.split(_ED.activity_info["46"].activity_add_state, "|")
	local boxDatas = _params[self._current_page+3+(self._current_page-1)]
	local boxInfo = zstring.split(boxDatas, ",")
	for i=1,9 do
		-- if i~= index then
		local itemsData = dms.element(dms["secret_shop_info"], tonumber(boxInfo[i]))
		local number = dms.atoi(itemsData,secret_shop_info.number)
		local item_type = dms.atoi(itemsData,secret_shop_info.item_type)
		local prop_type = 3
		if item_type == 0 then	--道具
			prop_type = 1
		elseif item_type == 1 then		--坦克
			prop_type = 3
		elseif item_type == 2 then		--配件
			prop_type = 7
		else
			prop_type = 1
		end
		function blinkInCallback1(sender)
			ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):setBackGroundImage(string.format("images/ui/wonderful/lucky_draw_box_%s_2.png", self._current_page))
		end
		
		function blinkInCallback2(sender)
			checkPlayEffect(66)
			ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):removeBackGroundImage()
			local cell = state_machine.excute("props_icon_create_cell",0,{6, 3, dms.atoi(itemsData,secret_shop_info.mould_id), prop_type, number})
			ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
			if prop_type == 3 then
				ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
			end
			ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):addChild(cell)
			ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):setTouchEnabled(false)
		end
		
		function blinkInCallback3(sender)
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_luck_draw/effect_luck_draw.ExportJson")
			local armature3 = ccs.Armature:create("effect_luck_draw")
			armature3:getAnimation():playWithIndex(0)
			armature3:setPosition(ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):getContentSize().width/2,ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):getContentSize().height/2)
			ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):addChild(armature3,100)
			state_machine.unlock("red_alert_time_lucky_draw_all_lucky_draw")
		end
		
		function blinkOutCallback1(sender)
			if i==9 then
				local status = 0
				if self._current_page == 1 then
					status = self._ordinary_lottery_status
				else
					status = self._advanced_lottery_status
				end
				if status == 0 then
					if self._current_page == 1 then
						self._ordinary_lottery_status = 2
					else
						self._advanced_lottery_status = 2
					end
				end
				ccui.Helper:seekWidgetByName(root,"Image_bg"):setTouchEnabled(true)
				ccui.Helper:seekWidgetByName(root,"Text_draw_operation_1"):setVisible(true)
				ccui.Helper:seekWidgetByName(root,"Text_draw_operation_2"):setVisible(false)
			end
		end
		ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):runAction(cc.Sequence:create(
			 		cc.DelayTime:create(0.1+i*0.2),
					cc.CallFunc:create(blinkInCallback1),
					cc.DelayTime:create(0.2),
					cc.CallFunc:create(blinkInCallback2),
					cc.Spawn:create(cc.ScaleTo:create(0.1, 0.1 * self._base_panel_scale)),
					cc.Spawn:create(cc.ScaleTo:create(0.3, 1.5 * self._base_panel_scale)),
					cc.CallFunc:create(blinkInCallback3),
					cc.DelayTime:create(0.1),
					cc.Spawn:create(cc.ScaleTo:create(0.1, self._base_panel_scale)),
					cc.CallFunc:create(blinkOutCallback1)
			 		))
		-- end
	end
end

function RedAlertTimeLuckyDraw:updateDrawbox(index)
	local root = self.roots[1]
	local _params = zstring.split(_ED.activity_info["46"].activity_add_state, "|")
	local boxDatas = _params[self._current_page+3+(self._current_page-1)]
	local boxInfo = zstring.split(boxDatas, ",")
	local Panel_draw_icon = ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",index))
	Panel_draw_icon:setBackGroundImage(string.format("images/ui/wonderful/lucky_draw_box_%s_2.png", self._current_page))
	local itemsData = dms.element(dms["secret_shop_info"], tonumber(boxInfo[index]))
	local number = dms.atoi(itemsData,secret_shop_info.number)
	local item_type = dms.atoi(itemsData,secret_shop_info.item_type)
	local prop_type = 3
	if item_type == 0 then	--道具
		prop_type = 1
	elseif item_type == 1 then		--坦克
		prop_type = 3
	elseif item_type == 2 then		--配件
		prop_type = 7
	else
		prop_type = 1
	end
	
	function blinkInCallback1(sender)
		Panel_draw_icon:removeBackGroundImage()
		local cell = state_machine.excute("props_icon_create_cell",0,{6, 3, dms.atoi(itemsData,secret_shop_info.mould_id), prop_type, number})
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		if prop_type == 3 then
			ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
		end
		Panel_draw_icon:addChild(cell,100)
		for i=1,9 do
			ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):setTouchEnabled(false)
		end
	end
	
	function blinkInCallback2(sender)
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_act_draw_light/effect_act_draw_light.ExportJson")
		local armature2 = ccs.Armature:create("effect_act_draw_light")
		armature2:getAnimation():playWithIndex(0)
		armature2:setPosition(Panel_draw_icon:getContentSize().width/2,Panel_draw_icon:getContentSize().height/2)
		Panel_draw_icon:addChild(armature2,-1)
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_luck_draw/effect_luck_draw.ExportJson")
		local armature3 = ccs.Armature:create("effect_luck_draw")
		armature3:getAnimation():playWithIndex(0)
		armature3:setPosition(Panel_draw_icon:getContentSize().width/2,Panel_draw_icon:getContentSize().height/2)
		Panel_draw_icon:addChild(armature3,100)
	end
	
	function blinkOutCallback1(sender)
		for i=1,9 do
			if i~= index then
				local data = dms.element(dms["secret_shop_info"], tonumber(boxInfo[i]))
				local number = dms.atoi(data,secret_shop_info.number)
				local item_type = dms.atoi(data,secret_shop_info.item_type)
				local prop_type = 3
				if item_type == 0 then	--道具
					prop_type = 1
				elseif item_type == 1 then		--坦克
					prop_type = 3
				elseif item_type == 2 then		--配件
					prop_type = 7
				else
					prop_type = 1
				end
				ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):removeBackGroundImage()
				local cell = state_machine.excute("props_icon_create_cell",0,{6, 3, dms.atoi(data,secret_shop_info.mould_id), prop_type, number})
				ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
				if prop_type == 3 then
					ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
				end
				ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)):addChild(cell)
			end
		end
		
		local status = 0
		if self._current_page == 1 then
			status = self._ordinary_lottery_status
		else
			status = self._advanced_lottery_status
		end
		
		if status == 1 then
			if self._current_page == 1 then
				self._ordinary_lottery_status = 2
			else
				self._advanced_lottery_status = 2
			end
		end
		ccui.Helper:seekWidgetByName(root,"Image_bg"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root,"Text_draw_operation_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Text_draw_operation_2"):setVisible(false)
	end
	
	Panel_draw_icon:runAction(cc.Sequence:create(
			 		cc.DelayTime:create(0.1),
					cc.CallFunc:create(blinkInCallback1),
					cc.Spawn:create(cc.ScaleTo:create(0.1, 0.1 * self._base_panel_scale)),
					cc.Spawn:create(cc.ScaleTo:create(0.3, 1.5 * self._base_panel_scale)),
					cc.DelayTime:create(0.1),
					cc.Spawn:create(cc.ScaleTo:create(0.1, self._base_panel_scale)),
					cc.CallFunc:create(blinkInCallback2),
					cc.DelayTime:create(0.2),
			 		cc.CallFunc:create(blinkOutCallback1)
			 		))
end

function RedAlertTimeLuckyDraw:onUpdateDraw(page)
    local root = self.roots[1]
	--箱子资源
    local box_closure = string.format("images/ui/wonderful/lucky_draw_box_%s_1.png", page)
	local box_open = string.format("images/ui/wonderful/lucky_draw_box_%s_2.png", page)
	
	local status = 0
	local isFREE = true
	local _params = zstring.split(_ED.activity_info["46"].activity_add_state, "|")
	-- self._params = _params
	local datasInfo = zstring.split(_params[self._current_page], ",")
	if tonumber(_params[self._current_page+3+(self._current_page-1)]) == -1 or tonumber(_params[self._current_page+2+(self._current_page-1)]) == 1 then
		if self._current_page == 1 then
			self._ordinary_lottery_status = 0
		else
			self._advanced_lottery_status = 0
		end
	else
		if self._current_page == 1 then
			self._ordinary_lottery_status = 1
		else
			self._advanced_lottery_status = 1
		end
	end
	if tonumber(datasInfo[4]) > tonumber(_ED.vip_grade) then
		datasInfo[1] = "1"
	end
	
	if tonumber(datasInfo[1]) == 0 then
		isFREE = true
	else
		isFREE = false
	end
	local one_key_vip_limit = ""
	if self._current_page == 1 then
		status = self._ordinary_lottery_status
		one_key_vip_limit = activity_str_tip[55]..tonumber(datasInfo[5])..activity_str_tip[56]..activity_str_tip[57]
		if verifySupportLanguage(_lua_release_language_en) == true then
			one_key_vip_limit = activity_str_tip[55]..tonumber(datasInfo[5])..activity_str_tip[56]
		end
		if tonumber(_ED.vip_grade) >= tonumber(datasInfo[5]) then
			ccui.Helper:seekWidgetByName(root,"Text_draw_all_gold_p"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Button_draw_all"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root,"Button_draw_all"):setBright(true)
		else
			ccui.Helper:seekWidgetByName(root,"Text_draw_all_gold_p"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Button_draw_all"):setTouchEnabled(false)
			ccui.Helper:seekWidgetByName(root,"Button_draw_all"):setBright(false)
		end
	else
		status = self._advanced_lottery_status
		one_key_vip_limit = activity_str_tip[55]..tonumber(datasInfo[5])..activity_str_tip[56]..activity_str_tip[57]
		if verifySupportLanguage(_lua_release_language_en) == true then
			one_key_vip_limit = activity_str_tip[55]..tonumber(datasInfo[5])..activity_str_tip[56]
		end
		if tonumber(_ED.vip_grade) >= tonumber(datasInfo[5]) then
			ccui.Helper:seekWidgetByName(root,"Text_draw_all_gold_p"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Button_draw_all"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root,"Button_draw_all"):setBright(true)
		else
			ccui.Helper:seekWidgetByName(root,"Text_draw_all_gold_p"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Button_draw_all"):setTouchEnabled(false)
			ccui.Helper:seekWidgetByName(root,"Button_draw_all"):setBright(false)
		end
	end
	ccui.Helper:seekWidgetByName(root,"Text_draw_all_gold_p"):setString(one_key_vip_limit)
	for i=1, 9 do
		local Panel_draw_icon = ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i))
		Panel_draw_icon:removeAllChildren(true)
		Panel_draw_icon:removeBackGroundImage()
		Panel_draw_icon:setBackGroundImage(box_closure)
		if status == 0 then
			Panel_draw_icon:setTouchEnabled(false)
		else
			Panel_draw_icon:setTouchEnabled(true)
		end
	end
	local Text_draw_have_lucky_gold_n = ccui.Helper:seekWidgetByName(root,"Text_draw_have_lucky_gold_n")
	local Text_draw_have_lucky_gold_p = ccui.Helper:seekWidgetByName(root,"Text_draw_have_lucky_gold_p")
	local Text_draw_all_gold_n = ccui.Helper:seekWidgetByName(root,"Text_draw_all_gold_n")
	local conuts = 0
	for i, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == dms.int(dms["prop_config"], 20, prop_config.param) then
			conuts = tonumber(v.prop_number)
		end
	end
	if status == 0 then--进抽奖前的消耗
		ccui.Helper:seekWidgetByName(root,"Panel_draw_open"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Image_15_0_0"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Text_draw_operation_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_draw_operation_2"):setVisible(false)
		if isFREE == true then	--如果有免费次数
			ccui.Helper:seekWidgetByName(root,"Panel_draw_free"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Panel_draw_have_lucky"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Image_draw_one_gold_icon"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Text_draw_one_gold_n"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Text_draw_all_gold_n"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Button_draw_free_one"):setTitleText(activity_str_tip[6])
		else
			Text_draw_have_lucky_gold_p:removeAllChildren(true)
			Text_draw_have_lucky_gold_n:setString(conuts)
			if conuts > 0 then
				ccui.Helper:seekWidgetByName(root,"Panel_draw_free"):setVisible(false)
				ccui.Helper:seekWidgetByName(root,"Panel_draw_have_lucky"):setVisible(true)
				if self._current_page > 1 then
					if conuts >= 3 then
						ccui.Helper:seekWidgetByName(root,"Text_draw_one_gold_n"):setVisible(false)
						ccui.Helper:seekWidgetByName(root,"Image_draw_one_gold_icon"):setVisible(false)
						ccui.Helper:seekWidgetByName(root,"Button_draw_free_one"):setTitleText(activity_str_tip[46])
					else
						ccui.Helper:seekWidgetByName(root,"Text_draw_one_gold_n"):setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Image_draw_one_gold_icon"):setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Button_draw_free_one"):setTitleText(activity_str_tip[7])
					end
				else
					ccui.Helper:seekWidgetByName(root,"Image_draw_one_gold_icon"):setVisible(false)
					ccui.Helper:seekWidgetByName(root,"Text_draw_one_gold_n"):setVisible(false)
					ccui.Helper:seekWidgetByName(root,"Button_draw_free_one"):setTitleText(activity_str_tip[46])
				end
			else
				ccui.Helper:seekWidgetByName(root,"Panel_draw_free"):setVisible(false)
				ccui.Helper:seekWidgetByName(root,"Panel_draw_have_lucky"):setVisible(true)
				ccui.Helper:seekWidgetByName(root,"Image_draw_one_gold_icon"):setVisible(true)
				ccui.Helper:seekWidgetByName(root,"Text_draw_one_gold_n"):setVisible(true)
				ccui.Helper:seekWidgetByName(root,"Button_draw_free_one"):setTitleText(activity_str_tip[7])
			end
		end
		local Button_text_draw_free_one = ccui.Helper:seekWidgetByName(root,"Button_text_draw_free_one")
		if Button_text_draw_free_one ~= nil then
			Button_text_draw_free_one:setString(ccui.Helper:seekWidgetByName(root,"Button_draw_free_one"):getTitleText())
			ccui.Helper:seekWidgetByName(root,"Button_draw_free_one"):setTitleText("")
		end
		local Text_draw_one_gold_n = ccui.Helper:seekWidgetByName(root,"Text_draw_one_gold_n")
		local mouldId = dms.int(dms["prop_config"], 20, prop_config.param)
		local consumption = dms.int(dms["prop_mould"], mouldId, prop_mould.shop_of_gold)
		if conuts > 0 then
			local number = tonumber(datasInfo[3]) - consumption*conuts
			if number <= 0 then
				number = 0
			end
			Text_draw_one_gold_n:setString(number)
			local number2 = tonumber(datasInfo[3])*9 - consumption*conuts
			if number2 <= 0 then
				number2 = 0
			end
			Text_draw_all_gold_n:setString(number2)
		else
			Text_draw_one_gold_n:setString(datasInfo[3])
			Text_draw_all_gold_n:setString(datasInfo[3]*9)
		end
		local num = 1
		if page == 2 then
			num = 3
		end
		local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[50], "fonts/simhei.ttf",26)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, num, "fonts/simhei.ttf",26)
        _richText:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[51], "fonts/simhei.ttf",26)
        _richText:pushBackElement(re3)
        local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, datasInfo[3], "fonts/simhei.ttf",26)
        _richText:pushBackElement(re4)
        local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[52], "fonts/simhei.ttf",26)
        _richText:pushBackElement(re5)
        _richText:setPosition(cc.p(Text_draw_have_lucky_gold_p:getContentSize().width/2,Text_draw_have_lucky_gold_p:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_draw_have_lucky_gold_p:getContentSize().width,26))

        if isFREE == true then
        	Text_draw_have_lucky_gold_p:removeAllChildren(true)
        else
        	Text_draw_have_lucky_gold_p:addChild(_richText)
        end
	elseif status == 1 then--开始选宝箱抽奖
		ccui.Helper:seekWidgetByName(root,"Text_draw_operation_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_draw_operation_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Panel_draw_open"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_15_0_0"):setVisible(false)
	else --抽奖结束
		ccui.Helper:seekWidgetByName(root,"Text_draw_operation_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Text_draw_operation_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Panel_draw_open"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_15_0_0"):setVisible(false)
	end
	if status == 2 then
		ccui.Helper:seekWidgetByName(root,"Image_bg"):setTouchEnabled(true)
	else
		ccui.Helper:seekWidgetByName(root,"Image_bg"):setTouchEnabled(false)
	end

	-- 重置倒计时
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_draw_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_draw_act_time_2")
    Text_draw_act_time_2:removeAllChildren(true)
    Text_draw_act_time_2:setString("")
    local font_size = Text_draw_act_time_2:getFontSize()
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(0, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(0)
    reset_time_info:setPositionY(Text_draw_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(reset_time_info:getContentSize().width)
    reset_time_int:setPositionY(Text_draw_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_draw_act_time_2:addChild(reset_time_int)
    Text_draw_act_time_2:addChild(reset_time_info)
end

function RedAlertTimeLuckyDraw:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_draw_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_draw_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw(self._current_page)
        end
    end
end

function RedAlertTimeLuckyDraw:onEnterTransitionFinish()

end

function RedAlertTimeLuckyDraw:onInit( )
    local csbItem = csb.createNode(config_csb.activity.lucky_draw)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

  	self.__check_covers = true
    root.__cwindow = self
	Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    local Panel_draw_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_draw_icon_1")
    self._base_panel_scale = Panel_draw_icon_1:getScale()
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_draw_close"), nil, 
    {
        terminal_name = "red_alert_time_lucky_draw_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
	
	--普通
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ordinary_draw"), nil, 
    {
        terminal_name = "red_alert_time_lucky_draw_change_page", 
        terminal_state = 0,
		_page = 1,
		_fun_open = 230,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_ordinary_lottery_push",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_ordinary_draw"),
    _m_type = 3,
    _invoke = nil,
    _interval = 0.1,})
    
	
	--高级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_senior_draw"), nil, 
    {
        terminal_name = "red_alert_time_lucky_draw_change_page", 
        terminal_state = 0,
		_page = 2,
		_fun_open = 231,
    }, nil, 1)
    if tonumber(_ED.user_info.user_grade) > 10 then
	    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_advanced_lottery_push",
	    _widget = ccui.Helper:seekWidgetByName(root, "Button_senior_draw"),
	    _m_type = 3,
	    _invoke = nil,
	    _interval = 0.1,})
	end
	
	--免费抽奖
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_draw_free_one"), nil, 
    {
        terminal_name = "red_alert_time_lucky_draw_free_lucky_draw", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--一键全开
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_draw_all"), nil, 
    {
        terminal_name = "red_alert_time_lucky_draw_all_lucky_draw", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--返回抽奖
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_bg"), nil, 
    {
        terminal_name = "red_alert_time_lucky_draw_return_draw", 
        terminal_state = 0,
    }, nil, 1)
	
	--抽奖
	for i=1, 9 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,string.format("Panel_draw_icon_%s",i)), nil, 
		{
			terminal_name = "red_alert_time_lucky_draw_select_number", 
			terminal_state = 0,
			touch_scale = true,
			touch_scale_xy = 0.95, 
			_index = i,
		}, nil, 1)
	end
	-- debug.print_r(_ED.activity_info["46"])
	-- self:onUpdateDraw()
	self:changeSelectPage(1)
end

function RedAlertTimeLuckyDraw:changeSelectPage( page )
    local root = self.roots[1]
    local Button_ordinary_draw = ccui.Helper:seekWidgetByName(root, "Button_ordinary_draw")
    local Button_senior_draw = ccui.Helper:seekWidgetByName(root, "Button_senior_draw")
    if page == self._current_page then
        if page == 1 then
            Button_ordinary_draw:setHighlighted(true)
        elseif page == 2 then
            Button_senior_draw:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_ordinary_draw:setHighlighted(false)
    Button_senior_draw:setHighlighted(false)
    if page == 1 then
        Button_ordinary_draw:setHighlighted(true)
    else
		Button_senior_draw:setHighlighted(true)
	end
	self:onUpdateDraw(page)
    self:updateRewardPreview()
end

function RedAlertTimeLuckyDraw:init()
	self:onInit()
    self:setTouchEnabled(true)
    return self
end

function RedAlertTimeLuckyDraw:onExit()
    state_machine.remove("red_alert_time_lucky_draw_change_page")
    state_machine.remove("red_alert_time_lucky_draw_free_lucky_draw")
    state_machine.remove("red_alert_time_lucky_draw_all_lucky_draw")
    state_machine.remove("red_alert_time_lucky_draw_return_draw")
    state_machine.remove("red_alert_time_lucky_draw_select_number")
    state_machine.remove("red_alert_time_lucky_draw_lottery")
    state_machine.remove("red_alert_time_lucky_draw_all_lottery")
    state_machine.remove("red_alert_time_lucky_draw_unlock")
end
