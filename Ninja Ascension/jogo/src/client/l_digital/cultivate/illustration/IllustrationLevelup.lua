--[[ ----------------------------------------------------------------------------
-- 属性总览界面
--]] ----------------------------------------------------------------------------
IllustrationLevelup = class("IllustrationLevelupClass", Window)

-- 打开窗口
local illustration_levelup_window_open_terminal = {
	_name = "illustration_levelup_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationLevelupClass") then
			fwin:open(IllustrationLevelup:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_levelup_window_close_terminal = {
	_name = "illustration_levelup_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationLevelupClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_levelup_window_open_terminal)
state_machine.add(illustration_levelup_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationLevelup:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	-- var
	self._ship_mould_id = nil
	self._is_combine_card = nil

	-- load lua files.

	-- Initialize illustration levelup page state machine.
	local function init_illustration_levelup_terminal()
		-- 打开角色创建窗口
		local illustration_levelup_open_terminal = {
			_name = "illustration_levelup_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local illustration_levelup_close_terminal = {
			_name = "illustration_levelup_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local illustration_levelup_show_terminal = {
			_name = "illustration_levelup_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local illustration_levelup_hide_terminal = {
			_name = "illustration_levelup_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 升級
		local illustration_levelup_click_terminal = {
			_name = "illustration_levelup_click",
			_init = function (terminal)
				app.load("client.l_digital.cultivate.illustration.IllustrationLevelupDone")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.lock("illustration_levelup_click")
				local perCardDatas = instance._per_card_data
				local cardId = perCardDatas.cardMouldId
				local is_combine_card = instance._is_combine_card

				local function responseCallBack( response )
					state_machine.unlock("illustration_levelup_click")
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("illustration_refush_bar_list", 0,"")
						state_machine.excute("illustration_levelup_done_window_open", 0,{perCardDatas, is_combine_card})
						state_machine.excute("illustration_levelup_window_close", 0,"")
					end
				end

				protocol_command.user_card_info_advance.param_list = ""..cardId
				NetworkManager:register(protocol_command.user_card_info_advance.code, nil, nil, nil, instance, responseCallBack, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(illustration_levelup_open_terminal)
		state_machine.add(illustration_levelup_close_terminal)
		state_machine.add(illustration_levelup_show_terminal)
		state_machine.add(illustration_levelup_hide_terminal)
		state_machine.add(illustration_levelup_click_terminal)
		state_machine.init()
	end
	-- call func init illustration levelup state machine.
	init_illustration_levelup_terminal()
end

function IllustrationLevelup:onUpdateDraw()
	local root = self.roots[1]
	local canAim = true
	-- 卡数据
	local cardDatas = self._per_card_data
	local mouldId = self._is_combine_card and cardDatas.cardMouldId or cardDatas.shipMouldId

	-- 角色头像
	self.Panel_charactor = ccui.Helper:seekWidgetByName(root, "Panel_charactor")
	self.Panel_charactor:removeAllChildren(true)

	local icon = IllustrationHandle.createHeroIcon(mouldId, self._is_combine_card)
	icon:setAnchorPoint(cc.p(0.5,0.5))
	local size = self.Panel_charactor:getContentSize()
	icon:setPosition(cc.p(size.width/2,size.height/2))
	self.Panel_charactor:addChild(icon)

	-- 角色名称
	self.Text_charactor_name = ccui.Helper:seekWidgetByName(root, "Text_charactor_name")
	local nameStr = IllustrationHandle.getCardName(mouldId, self._is_combine_card)
	self.Text_charactor_name:setString(nameStr)

	-- 升级前单卡级别
	self.Text_before_title = ccui.Helper:seekWidgetByName(root, "Text_before_title")
	self.Text_before_title:setString(string.format( tipStringInfo_illustration_tip[1],cardDatas.cardStar))

	-- 卡册評分:
	self.Text_before_1_n = ccui.Helper:seekWidgetByName(root, "Text_before_1_n")
	-- 升级前卡册评分值
	self.Text_before_1_t = ccui.Helper:seekWidgetByName(root, "Text_before_1_t")
	self.Text_before_1_t:setString(tostring(cardDatas.cardScore))

	-- 消耗,当前加成,下一级加成,本级分值加权
	local consume,curAdd,nextAdd,markAdd = IllustrationHandle.getUpLevelConsume(mouldId, cardDatas.cardStar, self._is_combine_card)
	if -1 == tonumber(curAdd) then
		for i=2,4 do
			local Text_before_n = ccui.Helper:seekWidgetByName(root, string.format("Text_before_%d_n",i))
			Text_before_n:setString(tipStringInfo_property_name_and_value[tostring(i - 2)])
			local Text_before_t = ccui.Helper:seekWidgetByName(root, string.format("Text_before_%d_t",i))
			Text_before_t:setString("+" .. "0"..string_equiprety_name_vlua_type[i - 1])
		end
	else
		local curAddDatas = zstring.split(curAdd,"|")
		for i=1,#curAddDatas do
			local datas = zstring.split(curAddDatas[i],",")
			local addType = tonumber(datas[1])
			local addVal = tonumber(datas[2])
				
			local propertyName, propertyValue = getPropertyNameAndValue(addType, addVal)

			local Text_before_n = ccui.Helper:seekWidgetByName(root, string.format("Text_before_%d_n",i + 1))
			local Text_before_t = ccui.Helper:seekWidgetByName(root, string.format("Text_before_%d_t",i + 1))

			Text_before_n:setString(propertyName)
			Text_before_t:setString(propertyValue)
		end
	end
	

	-- 升级后单卡级别
	self.Text_after_title = ccui.Helper:seekWidgetByName(root, "Text_after_title")
	self.Text_after_title:setString(string.format( tipStringInfo_illustration_tip[1],cardDatas.cardStar + 1))

	-- 卡册評分:
	self.Text_after_1_n = ccui.Helper:seekWidgetByName(root, "Text_after_1_n")
	-- 升级后卡册评分值
	self.Text_after_1_t = ccui.Helper:seekWidgetByName(root, "Text_after_1_t")
	self.Text_after_1_t:setString(tostring(cardDatas.cardScore + markAdd))

	local afterAddDatas = zstring.split(nextAdd,"|")
	for i=1,#afterAddDatas do
		local datas = zstring.split(afterAddDatas[i],",")
		local addType = tonumber(datas[1])
		local addVal = tonumber(datas[2])

		local propertyName, propertyValue = getPropertyNameAndValue(addType, addVal)

		local Text_after_n = ccui.Helper:seekWidgetByName(root, string.format("Text_after_%d_n",i + 1))
		local Text_after_t = ccui.Helper:seekWidgetByName(root, string.format("Text_after_%d_t",i + 1))

		Text_after_n:setString(propertyName)
		Text_after_t:setString(propertyValue)
	end

	-- 达到%s星
	self.Text_star_t = ccui.Helper:seekWidgetByName(root, "Text_star_t")
	self.Text_star_n = ccui.Helper:seekWidgetByName(root, "Text_star_n")
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	
	if not self._is_combine_card then		
		self.Text_star_t:setString(string.format(self.Text_star_t:getString(),cardDatas.cardStar + 1))
		if tonumber(getStrongestShipByTemplateId(cardDatas.shipMouldId).StarRating) < tonumber(cardDatas.cardStar + 1) then
			canAim = false
			self.Text_star_t:setColor(IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[2]))
			self.Text_star_t:setColor(IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[2]))
		else
			self.Text_star_t:setColor(IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[3]))
			self.Text_star_t:setColor(IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[3]))
		end
	else
		self.Text_star_t:setVisible(false)
		self.Text_star_n:setVisible(false)
		self.Text_1:setVisible(false)
	end

	-- 升级消耗道具图标

	local propDatas = zstring.splits(consume, "|", ",")
	for i = 1, 2 do
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_cost_"..i)

		local prop = propDatas[i]
		if prop then
			panel:setVisible(true)

			local Panel_xs_one = ccui.Helper:seekWidgetByName(root, "Panel_xs_one_"..i)
			local Text_props_t_1 = ccui.Helper:seekWidgetByName(root, "Text_props_t_" .. (2 * i - 1))
			local Text_props_t_2 = ccui.Helper:seekWidgetByName(root, "Text_props_t_" .. (2 * i))

			local propType = tonumber(prop[1])
	        local propId = tonumber(prop[2])
	        local aimNum = tonumber(prop[3])

	    	-- 升级消耗道具图标
			Panel_xs_one:removeAllChildren(true)
			local haveNum = 0
			
			if fundPropWidthId(propId) then
				haveNum = tonumber(fundPropWidthId(propId).prop_number)
			end
			local cell = ResourcesIconCell:createCell()
			cell:init(propType,0,propId,nil,nil,true,true)
			cell:setAnchorPoint(cc.p(0.5,0.5))     
			cell:setPosition(cc.p(Panel_xs_one:getContentSize().width/2,Panel_xs_one:getContentSize().height/2))
			Panel_xs_one:addChild(cell)
			
			Text_props_t_1:setString(haveNum)
			Text_props_t_2:setString(aimNum)
			if tonumber(haveNum) >= aimNum then
				Text_props_t_1:setColor(IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[3]))
				Text_props_t_2:setColor(IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[3]))
			else
				Text_props_t_1:setColor(IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[2]))
				Text_props_t_2:setColor(IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[2]))
				canAim = false
			end
		else
			panel:setVisible(false)
		end
	end
	
	if canAim then
		self.Button_lvlup:setEnabled(true)
		self.Button_lvlup:setBright(true)
	else
		self.Button_lvlup:setEnabled(false)
		self.Button_lvlup:setBright(false)
	end

end

function IllustrationLevelup:onEnterTransitionFinish()
	-- 加载IllustrationLevelupWindow界面资源.
	-- res.cultivate.illustration.illustration_levelup = res/cultivate/illustration/illustration_levelup.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_levelup.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 升级按钮
	self.Button_lvlup = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lvlup"), nil,
	{
		terminal_name = "illustration_levelup_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "illustration_levelup_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

-- 对象初始化
function IllustrationLevelup:init(params)
	self._per_card_data = params[1]
	self._is_combine_card = params[2]
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationLevelup:onExit()
	-- 释放IllustrationLevelupWindow界面资源.
	state_machine.remove("illustration_levelup_open")
	state_machine.remove("illustration_levelup_close")
	state_machine.remove("illustration_levelup_show")
	state_machine.remove("illustration_levelup_hide")
	state_machine.remove("illustration_levelup_click")
end

function IllustrationLevelup:close()
	-- window event : close.
	
end

function IllustrationLevelup:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
