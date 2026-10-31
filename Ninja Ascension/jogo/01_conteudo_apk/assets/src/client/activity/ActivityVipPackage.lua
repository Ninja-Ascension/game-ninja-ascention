-- ----------------------------------------------------------------------------------------------------
-- 说明：VIP礼包
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityVipPackage = class("ActivityVipPackageClass", Window)
    
function ActivityVipPackage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.loaded = false
	
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.activity.vip_package_select_cell")
	app.load("client.utils.TimeUtil")
	
	self.pageview_index = nil
	self.vip_package_info = {}
	self.activity_time = nil
	self.last_activity_time = nil
	self.current_say_index = 0
	self._Text_925 = nil
	
    -- Initialize ActivityVipPackage state machine.
    local function init_ActivityVipPackage_terminal()
		--购买
		local activity_vip_package_buy_yes_terminal = {
            _name = "activity_vip_package_buy_yes",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params ~= nil and type(params) == "table" then
					local status = params.status
					if status ~= nil and status ~= 1 then
						return
					end
				end
			
				local function responseVipPackageBuyCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							_ED.vip_package_buy_state[self.pageview_index+1] = "1"
							response.node:updateBuyBtnState()
							
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd,fwin._ui)
						end
					end
				end
				local activity = _ED.active_activity[40]
				if __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					then
					protocol_command.get_activity_reward.param_list = ""..activity.activity_id.."\r\n"..self.pageview_index.."\r\n".."1"
				else	
					protocol_command.get_activity_reward.param_list = ""..activity.activity_id.."\r\n"..self.pageview_index.."\r\n1"
				end	
				NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseVipPackageBuyCallback, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 购买回调
        local activity_vip_package_buy_terminal = {
            _name = "activity_vip_package_buy",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local current_info = instance.vip_package_info[instance.pageview_index + 1]
				local needGold = tonumber(current_info.final_cost)
				local needVIP = tonumber(current_info.vip_level)
				local currentGold = zstring.tonumber(_ED.user_info.user_gold)
				local currentVIP = zstring.tonumber(_ED.vip_grade)
				
				if needVIP > currentVIP then
					-- 不可购买
					state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
					{
						terminal_name = "shortcut_open_recharge_window", 
						terminal_state = 0, 
						_msg = _string_piece_info[274], 
						_datas= 
						{

						}
					})
				elseif needGold > currentGold then
					-- 不可购买
					state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
					{
						terminal_name = "shortcut_open_recharge_window", 
						terminal_state = 0, 
						_msg = _string_piece_info[273], 
						_datas= 
						{

						}
					})
				else
					-- 可购买
					state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
					{
						terminal_name = "activity_vip_package_buy_yes", 
						terminal_state = 0, 
						_msg = string.format(_string_piece_info[356], current_info.vip_level), 
						_datas= 
						{

						}
					})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 刷新
        local activity_vip_package_update_terminal = {
            _name = "activity_vip_package_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local list_index = params
				instance.pageview_index = list_index
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 选中按钮，隐藏红色边框
        local activity_vip_package_focusallOff_terminal = {
            _name = "activity_vip_package_focusallOff",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				local listview = ccui.Helper:seekWidgetByName(root, "ListView_94")
				for i, v in pairs(listview:getItems()) do
					v:focusOff()
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 点击人物
        local activity_vip_package_change_word_terminal = {
            _name = "activity_vip_package_change_word",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				
				instance.current_say_index = (instance.current_say_index + 1) % 2
				local pernson_info = _vip_qianming[instance.pageview_index + 1]
				ccui.Helper:seekWidgetByName(root, "Text_269"):setString(pernson_info[instance.current_say_index + 2])
	
				local action = instance.actions[1]
				action:play("window_open", false)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(activity_vip_package_buy_terminal)
        state_machine.add(activity_vip_package_update_terminal)
        state_machine.add(activity_vip_package_focusallOff_terminal)
        state_machine.add(activity_vip_package_change_word_terminal)
        state_machine.add(activity_vip_package_buy_yes_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityVipPackage state machine.
    init_ActivityVipPackage_terminal()
    
    self._load_over = false
	-- self:onLoad()
end

function ActivityVipPackage:onUpdate(dt)
	-- 重置倒计时定时器
	if self.loaded == false then
		return
	end
	
	if self._Text_925 == nil then 
		return
	end
	
	if self.activity_time - os.time() >= 0 then
		self.activity_time = self.activity_time - os.time()
		
		if self.last_activity_time - self.activity_time >= 1 and self.activity_time >= 0 then
			
			self.last_activity_time = self.activity_time
			
			-- print(os.date("%d"..tipStringInfo_time_info[4]
						  -- .."%H"..tipStringInfo_time_info[5]
						  -- .."%M"..tipStringInfo_time_info[6]
						  -- .."%S"..tipStringInfo_time_info[7]
						  -- , self.activity_time))
			-- debug.print_r(os.date("*t", self.activity_time))	
			
			local time_info = nil
			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				time_info = formatTime(self.activity_time)
			else
				time_info = os.date("*t", self.activity_time)
			end
			local format_string = ""
			if zstring.tonumber(time_info.day) > 0 then
				format_string = format_string .. time_info.day .. tipStringInfo_time_info[4]
			end
			if zstring.tonumber(time_info.hour) > 0 then
				format_string = format_string .. time_info.hour .. tipStringInfo_time_info[5]
			end
			
			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				if zstring.tonumber(time_info.minute) > 0 then
					format_string = format_string .. time_info.minute .. tipStringInfo_time_info[6]
				end
				format_string = format_string .. time_info.second .. tipStringInfo_time_info[7]
			else
				if zstring.tonumber(time_info.min) > 0 then
					format_string = format_string .. time_info.min .. tipStringInfo_time_info[6]
				end
				format_string = format_string .. time_info.sec .. tipStringInfo_time_info[7]
			end
			
			
			self._Text_925:setString(format_string)
		end
		self.activity_time = self.activity_time + os.time()
	end	
	
end

function ActivityVipPackage:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	
	local current_info = self.vip_package_info[self.pageview_index + 1]
	
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_91"):setString(current_info.vip_level)
	ccui.Helper:seekWidgetByName(root, "Text_923"):setString(string.format(_string_piece_info[352], current_info.vip_level))
	ccui.Helper:seekWidgetByName(root, "Text_919"):setString(current_info.final_cost)
	ccui.Helper:seekWidgetByName(root, "Text_921"):setString(current_info.origin_cost)
	self._Text_925 = ccui.Helper:seekWidgetByName(root, "Text_925")
	
	local propPad = ccui.Helper:seekWidgetByName(root, "Panel_17")
	local _type = tonumber(current_info.res_type)
	local _mould = current_info.mould_id
	local _num = tonumber(current_info.res_num)
	
	if _type == 1 then--银币
		local cell = propMoneyIcon:createCell()
		cell:init("1", _num, nil)
		propPad:addChild(cell)
	end
	if _type == 2 then--金币
		local cell = propMoneyIcon:createCell()
		cell:init("2", _num, nil)
		propPad:addChild(cell)
	end
	if _type == 3 then--声望
		local cell = propMoneyIcon:createCell()
		cell:init("3", _num, nil)
		propPad:addChild(cell)
	end
	if _type == 4 then--舰魂
		local cell = propMoneyIcon:createCell()
		cell:init("4", _num, nil)
		propPad:addChild(cell)
	end
	if _type == 5 then--水雷魂
		local cell = propMoneyIcon:createCell()
		cell:init("5", _num, nil)
		propPad:addChild(cell)
	end
	if _type == 6 then--道具
		local cell = PropIconCell:createCell()
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			cell:init(24, _mould, _num)
		else
			cell:init(26, _mould, _num)
		end
		propPad:addChild(cell)
	end
	if _type == 7 then--装备
		local cell = EquipIconCell:createCell()
		cell:init(10, nil, _mould, nil, nil, _num)
		propPad:addChild(cell)
	end
	
	local person_pad = ccui.Helper:seekWidgetByName(root, "Panel_1")
	local pernson_info = _vip_qianming[self.pageview_index + 1]
	if __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh then
		person_pad:setBackGroundImage(string.format("images/face/big_head/big_head_%s.png", pernson_info[1]))
	else
		person_pad:setBackGroundImage(string.format("images/face/card_head/card_head_%s.png", pernson_info[1]))
	end
	
	ccui.Helper:seekWidgetByName(root, "Text_269"):setString(pernson_info[self.current_say_index + 2])
	
	local action = self.actions[1]
	action:play("window_open", false)
	
	self:updateBuyBtnState()
end

function ActivityVipPackage:initSelectList()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root, "ListView_94")
	for i, v in ipairs(self.vip_package_info) do
		local cell = VipPackageSelectCell:createCell()
		cell:init(v.vip_level, i - 1)
		listview:addChild(cell)
		
		if i == 1 then
			cell:focusOn()
		end
	end
end

function ActivityVipPackage:updateBuyBtnState()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	local buy_btn = ccui.Helper:seekWidgetByName(root, "Button_98")
	if _ED.vip_package_buy_state[self.pageview_index+1] == "1" then
		buy_btn:setEnabled(false)
		buy_btn:setBright(false)
	else
		buy_btn:setEnabled(true)
		buy_btn:setBright(true)
	end
end

function ActivityVipPackage:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true

	self:onLoad()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, false)
 	self:onInit()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityVipPackage:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self.actions = {}
	self.vip_package_info = {}
	self:unregisterOnNoteUpdate(self)
end

function ActivityVipPackage:onEnterTransitionFinish()

end

function ActivityVipPackage:onLoad()
	local activity = _ED.active_activity[40]
	if activity ~= nil then
		self.activity_time = activity.activity_login_day        --下次活动重置时间间隔
		self.last_activity_time = self.activity_time
		
		local vip_data = zstring.split(activity.activity_extra_prame, "!") 	--vip礼包对应档位
		vip_data = vip_data[1]
		
		local vip_buy_state_data = activity.activity_extra_prame2 			--vip礼包对应档位购买状态
		
		local each_vip_data = zstring.split(vip_data, "|")
		for i, v in ipairs(each_vip_data) do
			local temp_data = zstring.split(v, ",")
			-- vip等级,原价,折价,资源类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备),道具,数量
			table.insert(self.vip_package_info, {
				vip_level 	= temp_data[1],
				origin_cost = temp_data[2],
				final_cost	= temp_data[3],
				res_type 	= temp_data[4],
				mould_id 	= temp_data[5],
				res_num 	= temp_data[6],
			})
		end
		
		local each_vip_buy_data = zstring.split(vip_buy_state_data, ",")
		_ED.vip_package_buy_state = _ED.vip_package_buy_state or each_vip_buy_data
		
		self.pageview_index = 0
	end
end

function ActivityVipPackage:onInit()
	local csbVipPackage = csb.createNode("activity/wonderful/vip_package.csb")
    local root = csbVipPackage:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbVipPackage)
	
	local action = csb.createTimeline("activity/wonderful/vip_package.csb")
	csbVipPackage:runAction(action)
	table.insert(self.actions, action) -- window_open
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self, false)
	
	self:initSelectList()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_98"), nil, 
		{
			terminal_name = "activity_vip_package_buy", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil,0)
		
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1"), nil, 
		{
			terminal_name = "activity_vip_package_change_word", 
			terminal_state = 0, 
			touch_scale = true
		},
		nil,0)	
end

function ActivityVipPackage:onExit()
	
end

function ActivityVipPackage:init()

end


function ActivityVipPackage:createCell()
	local cell = ActivityVipPackage:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end