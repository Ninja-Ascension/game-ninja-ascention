--[[ ----------------------------------------------------------------------------
-- 抽卡界面
--]] ----------------------------------------------------------------------------
RoleBiographyDivine = class("RoleBiographyDivineClass", Window)

-- 打开窗口
local role_biography_divine_window_open_terminal = {
	_name = "role_biography_divine_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyDivineClass") then
			fwin:open(RoleBiographyDivine:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_divine_window_close_terminal = {
	_name = "role_biography_divine_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyDivineClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_divine_window_open_terminal)
state_machine.add(role_biography_divine_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyDivine:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.user_silver = 0
	self.user_gold = 0

	-- load lua files.
	app.load("client.utils.PropNotEnoughTip")

	-- Initialize ninja biographies divine page state machine.
	local function init_role_biography_divine_terminal()
		-- 打开角色创建窗口
		local role_biography_divine_open_terminal = {
			_name = "role_biography_divine_open",
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
		local role_biography_divine_close_terminal = {
			_name = "role_biography_divine_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_divine_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_divine_show_terminal = {
			_name = "role_biography_divine_show",
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
		local role_biography_divine_hide_terminal = {
			_name = "role_biography_divine_hide",
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

		-- 普通/高级 抽奖1/10
		local role_biography_divine_draw_terminal = {
			_name = "role_biography_divine_draw",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local drawTimes = params._datas._drawTimes
					local drawType = params._datas._drawType
					local m_type = params._datas._m_type
					instance:startDraw(drawTimes, drawType, m_type)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 奖励预览
		local role_biography_divine_reward_preview_terminal = {
			_name = "role_biography_divine_reward_preview",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_rewards_preview_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 跳转篇章界面
		local role_biography_divine_jump_chapter_terminal = {
			_name = "role_biography_divine_jump_chapter",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 关闭列传界面
				state_machine.excute("role_biography_window_close", 0, nil)
				-- 关闭占卜界面
				state_machine.excute("role_biography_divine_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 买道具
		local role_biography_divine_buy_terminal = {
			_name = "role_biography_divine_buy",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local buyType = params._datas._buyType
				state_machine.excute("role_biography_exchange_window_open", 0, buyType)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新道具数量
		local role_biography_divine_refresh_count_terminal = {
			_name = "role_biography_divine_refresh_count",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updatePropCount()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面
		local role_biography_divine_refresh_ui_terminal = {
			_name = "role_biography_divine_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 领取额外奖励
		local role_biography_divine_get_extra_reward_terminal = {
			_name = "role_biography_divine_get_extra_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					-- print("领取额外奖励")
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							state_machine.excute("role_biography_divine_refresh_ui", 0, nil)
						end
					end
					NetworkManager:register(protocol_command.biographies_get_extra_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		

		state_machine.add(role_biography_divine_open_terminal)
		state_machine.add(role_biography_divine_close_terminal)
		state_machine.add(role_biography_divine_show_terminal)
		state_machine.add(role_biography_divine_hide_terminal)
		state_machine.add(role_biography_divine_draw_terminal)
		state_machine.add(role_biography_divine_reward_preview_terminal)
		state_machine.add(role_biography_divine_jump_chapter_terminal)
		state_machine.add(role_biography_divine_buy_terminal)
		state_machine.add(role_biography_divine_refresh_count_terminal)
		state_machine.add(role_biography_divine_refresh_ui_terminal)
		state_machine.add(role_biography_divine_get_extra_reward_terminal)

		state_machine.init()
	end
	-- call func init ninja biographies divine state machine.
	init_role_biography_divine_terminal()
end

-- 对象初始化
function RoleBiographyDivine:init(params)
	
	return self
end

function RoleBiographyDivine:updateUI()
	self._drawInfo = RoleBiographyHandle.getBiographyDrawInfo()
	
	self:updateNormalUI()
	self:updateSpecialUI()

	self:updatePropCount()

	self:updateRightBottom()
end

function RoleBiographyDivine:updateRightBottom()
	-- 高级已经抽取的总次数
	local totalDrawTimes = tonumber(self._drawInfo.totalAdvanceDrawNumber)
	-- 当前已领奖的次数
	local getRewardTimes = tonumber(self._drawInfo.haveGet)

	local data = zstring.split(dms.string(dms["play_config"], 209, play_config.param), "|")
	local totalStepNums = table.nums(data)
	local nextStep = (getRewardTimes % totalStepNums) + 1
	
	local nextStepValue = tonumber(data[nextStep])

	local needMinusNums = 0
	if getRewardTimes > 0 then
		for i = 0, getRewardTimes - 1 do
			local step = (i % totalStepNums) + 1
			local value = tonumber(data[step])
			needMinusNums = needMinusNums + value
		end
	end

	local remainTimes = totalDrawTimes - needMinusNums

	local str = tipStringInfo_role_biography[21]
	self.Text_buy_2:setString(string.format(str, remainTimes, nextStepValue))

	local rewards = zstring.split(dms.string(dms["play_config"], 210, play_config.param), "|")
	local propData = zstring.split(rewards[nextStep], ",")

	-- debug.print_r(propData)

	self.Panel_daoju_2:removeAllChildren(true)
	local cell = self:addResourcesIconCell(propData)
	self.Panel_daoju_2:addChild(cell)

	-- 是否可领奖
	local curDrawLimit = remainTimes >= nextStepValue
	self.Panel_daoju_2:setTouchEnabled(curDrawLimit)

	self.Image_hint:setVisible(curDrawLimit)
end

function RoleBiographyDivine:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function RoleBiographyDivine:updateNormalUI()
	local normalDrawFreeNumber = tonumber(self._drawInfo.normalDrawFreeNumber)
	-- print("normalDrawFreeNumber = ", normalDrawFreeNumber)
	if normalDrawFreeNumber > 0 then
		self.Text_gm10:setString(string.format(tipStringInfo_role_biography[15], normalDrawFreeNumber))
	else
		self.Text_gm10:setString(tipStringInfo_role_biography[16])
	end
	
	local data = zstring.split(dms.string(dms["play_config"], 203, play_config.param), ",")
	local propID = tonumber(data[2])
	local count = tonumber(data[3])

	local havePropNum = tonumber(getPropAllCountByMouldId(propID))
	self.Text_alloy_buy_jb_one_n:setString(count .. "/" .. havePropNum)

	local count1 = count * 10
	self.Text_alloy_buy_jb_ten_n:setString(count1 .. "/" .. havePropNum)

	local normalDrawMaxNumber = tonumber(self._drawInfo.normalDrawMaxNumber)
	local data1 = zstring.split(dms.string(dms["play_config"], 197, play_config.param), ",")
	self.Text_alloy_buy_one_time_n:setString((data1[1] - normalDrawMaxNumber) .. "/" .. (data1[1]))
end

function RoleBiographyDivine:updateSpecialUI()
	local advanceDrawFreeNumber = tonumber(self._drawInfo.advanceDrawFreeNumber)
	-- print("advanceDrawFreeNumber = ", advanceDrawFreeNumber)
	if advanceDrawFreeNumber > 0 then
		self.Text_gm1_0:setString(string.format(tipStringInfo_role_biography[15], advanceDrawFreeNumber))
	else
		self.Text_gm1_0:setString(tipStringInfo_role_biography[16])
	end
	
	local data = zstring.split(dms.string(dms["play_config"], 204, play_config.param), ",")
	local propID = tonumber(data[2])
	local count = tonumber(data[3])

	local havePropNum = tonumber(getPropAllCountByMouldId(propID))
	self.Text_alloy_buy_diamo_one_n:setString(count .. "/" .. havePropNum)

	local count1 = count * 10
	self.Text_alloy_buy_diamo_ten_n:setString(count1 .. "/" .. havePropNum)

	local advanceDrawMaxNumber = tonumber(self._drawInfo.advanceDrawMaxNumber)
	local data1 = zstring.split(dms.string(dms["play_config"], 197, play_config.param), ",")
	self.Text_alloy_buy_ten_time_n:setString((data1[2] - advanceDrawMaxNumber) .. "/" .. (data1[2]))
end

function RoleBiographyDivine:updatePropCount()
	-- 需要替换成活动所需要的道具
	local propID1 = tonumber(zstring.split(dms.string(dms["play_config"], 203, play_config.param), ",")[2])
	local propID2 = tonumber(zstring.split(dms.string(dms["play_config"], 204, play_config.param), ",")[2])

	local havePropNum1 = tonumber(getPropAllCountByMouldId(propID1))
	local havePropNum2 = tonumber(getPropAllCountByMouldId(propID2))

	self.Text_111:setString(havePropNum1)
	self.Text_121:setString(havePropNum2)

	local haveGold = tonumber(_ED.user_info.user_gold)
	self.Text_ghb:setString(haveGold)
end

function RoleBiographyDivine:startDraw(drawTimes, drawType, m_type)
	-- 没有免费次数并且道具不足
	if not self:haveFreeTimes(drawType, drawTimes) then
		if not self:haveEnoughProp(drawType, drawTimes) then
			state_machine.excute("prop_not_enough_tip_window_open", 0, {openWindowTerminalName = "role_biography_exchange_window_open", openWindowTerminalParams = drawType})
			return true
		end
	end

	state_machine.lock("role_biography_divine_draw")
	local function responseCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				if fwin:find("HeroRecruitSuccessClass") ~= nil then
					fwin:close(fwin:find("HeroRecruitSuccessClass"))
				end

				if fwin:find("HeroRecruitSuccessTenClass") ~= nil then
					fwin:close(fwin:find("HeroRecruitSuccessTenClass"))
				end

				getSceneReward(7)
				_ED.show_reward_list_group_ex = {}

				if drawTimes == 1 then
					local obj = HeroRecruitSuccess:new()
					obj:setRanking(herorIndex, m_type, true)
					fwin:open(obj, fwin._ui)
				elseif drawTimes == 10 then
					local obj = HeroRecruitSuccessTen:new()
					obj:setRanking(herorIndex, m_type, true)
					fwin:open(obj, fwin._ui)
				end
				
				state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
				state_machine.excute("role_biography_divine_refresh_ui", 0, nil)
			else
				state_machine.unlock("role_biography_divine_draw")
			end
		else
			state_machine.unlock("role_biography_divine_draw")
		end
		_ED.prop_chest_store_recruiting = false
	end

	_ED.new_prop_object = {}
	_ED.recruit_success_ship_id = nil
	_ED.new_reward_object = {}
	_ED.prop_chest_store_recruiting = true

	-- print("drawType = ", drawType, " drawTimes = ", drawTimes)

	protocol_command.biographies_draw.param_list = "" .. drawType .. "\r\n" .. drawTimes
	NetworkManager:register(protocol_command.biographies_draw.code, nil, nil, nil, self, responseCallback, false, nil)
end

-- 是否还有免费的次数
function RoleBiographyDivine:haveFreeTimes(drawType, drawTimes)
	local freeTimes = 0
	if drawTimes == 1 then
		if drawType == 0 then
			freeTimes = tonumber(self._drawInfo.normalDrawFreeNumber)
		else
			freeTimes = tonumber(self._drawInfo.advanceDrawFreeNumber)
		end
	end
	return freeTimes > 0
end

-- 是否有足够的道具
function RoleBiographyDivine:haveEnoughProp(drawType, drawTimes)
	local configIndex = drawType == 0 and 203 or 204
	local configData = zstring.split(dms.string(dms["play_config"], configIndex, play_config.param), ",")

	local propID = tonumber(configData[2])
	local havePropNum = tonumber(getPropAllCountByMouldId(propID))

	local needPropCount = tonumber(configData[3]) * drawTimes

	-- print("drawType = ", drawType, " havePropNum = ", havePropNum, " needPropCount = ", needPropCount)
	return havePropNum >= needPropCount
end

function RoleBiographyDivine:onUpdateDraw()
	local root = self.roots[1]

	-- 一次抽取金币数值
	self.Text_alloy_buy_jb_one_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_buy_jb_one_n")

	-- 十次抽取金币数值
	self.Text_alloy_buy_jb_ten_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_buy_jb_ten_n")

	self.Text_alloy_buy_jb_one_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_buy_jb_one_n")

	self.Text_alloy_buy_jb_ten_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_buy_jb_ten_n")

	self.Text_alloy_buy_diamo_one_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_buy_diamo_one_n")

	self.Text_alloy_buy_diamo_ten_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_buy_diamo_ten_n")

	self.Text_alloy_buy_one_time_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_buy_one_time_n")

	self.Text_alloy_buy_ten_time_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_buy_ten_time_n")


	-- 普通1次按钮文本
    self.Text_gm10 = ccui.Helper:seekWidgetByName(self.Button_alloy_buy_jb_one, "Text_gm10") or self.Button_alloy_buy_jb_one:getChildByName("Text_gm10*12")

	-- 高级一次按钮文本
    self.Text_gm1_0 = ccui.Helper:seekWidgetByName(self.Button_alloy_buy_diamo_one, "Text_gm1_0") or self.Button_alloy_buy_diamo_one:getChildByName("Text_gm1_0*12")

	self.Text_111 = ccui.Helper:seekWidgetByName(root, "Text_111")

	self.Text_121 = ccui.Helper:seekWidgetByName(root, "Text_121")

	self.Text_ghb = ccui.Helper:seekWidgetByName(root, "Text_ghb")

	self.Text_buy_1 = ccui.Helper:seekWidgetByName(root, "Text_buy_1")
	self.Text_buy_1_0 = ccui.Helper:seekWidgetByName(root, "Text_buy_1_0")
	self.Text_buy_1_0_0 = ccui.Helper:seekWidgetByName(root, "Text_buy_1_0_0")
	
	self.Text_buy_2 = ccui.Helper:seekWidgetByName(root, "Text_buy_2")
	self.Panel_daoju_2 = ccui.Helper:seekWidgetByName(root, "Panel_daoju_2")
	fwin:addTouchEventListener(self.Panel_daoju_2, nil,
	{
		terminal_name = "role_biography_divine_get_extra_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Text_buy_1:setVisible(false)
	self.Text_buy_1_0:setVisible(false)
	self.Text_buy_1_0_0:setVisible(false)

	self.Image_hint = ccui.Helper:seekWidgetByName(root, "Image_hint")

	self:updateUI()
    require('saga_layout').reflow(self)
end

function RoleBiographyDivine:onEnterTransitionFinish()
	-- 加载RoleBiographyDivineWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_divine = res/cultivate/ninja_biographies/ninja_biographies_divine.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_divine.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_draw_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_draw_back"), nil,
	{
		terminal_name = "role_biography_divine_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 普通1次
	self.Button_alloy_buy_jb_one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_alloy_buy_jb_one"), nil,
	{
		terminal_name = "role_biography_divine_draw",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_drawType = 0,
		_drawTimes = 1,
		_m_type = 12
	}, nil, 0)	

	-- 普通10次
	self.Button_alloy_buy_jb_ten = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_alloy_buy_jb_ten"), nil,
	{
		terminal_name = "role_biography_divine_draw",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_drawType = 0,
		_drawTimes = 10,
		_m_type = 12
	}, nil, 0)

	-- 高级1次
	self.Button_alloy_buy_diamo_one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_alloy_buy_diamo_one"), nil,
	{
		terminal_name = "role_biography_divine_draw",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_drawType = 1,
		_drawTimes = 1,
		_m_type = 13
	}, nil, 0)	

	-- 高级10次
	self.Button_alloy_buy_diamo_ten = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_alloy_buy_diamo_ten"), nil,
	{
		terminal_name = "role_biography_divine_draw",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_drawType = 1,
		_drawTimes = 10,
		_m_type = 13
	}, nil, 0)	

		
	-- 奖励预览
	self.Button_task = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task"), nil,
	{
		terminal_name = "role_biography_divine_reward_preview",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 跳转篇章
	self.Button_imprint = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_imprint"), nil,
	{
		terminal_name = "role_biography_divine_jump_chapter",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 普通道具购买
	self.Button_jinbi_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jinbi_add"), nil,
	{
		terminal_name = "role_biography_divine_buy",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_buyType = 0
	}, nil, 0)

	-- 高级道具购买
	self.Button_zuanshi_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zuanshi_add"), nil,
	{
		terminal_name = "role_biography_divine_buy",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_buyType = 1
	}, nil, 0)

	-- 金币购买
	self.Button_tili_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tili_add"), nil,
	{
		terminal_name = "activity_home_recharge_button",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)


	self:onUpdateDraw()
end

function RoleBiographyDivine:onUpdate(dt)
	-- if self.user_silver ~= _ED.user_info.user_silver 
	-- 	and self.Text_sliver ~= nil then
	-- 	self.user_silver = _ED.user_info.user_silver

	-- 	if tonumber( self.user_silver)> 10000 then
	-- 		self.Text_sliver:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	-- 	else
	-- 		self.Text_sliver:setString(self.user_silver)
	-- 	end
	-- end
	
	if self.user_gold ~= _ED.user_info.user_gold 
		and self.Text_ghb ~= nil then
		self.user_gold = _ED.user_info.user_gold

		if tonumber( self.user_gold)> 1000000 then
			self.Text_ghb:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self.Text_ghb:setString(self.user_gold)
		end
	end
end

function RoleBiographyDivine:onExit()
	-- 释放RoleBiographyDivineWindow界面资源.
	state_machine.remove("role_biography_divine_open")
	state_machine.remove("role_biography_divine_close")
	state_machine.remove("role_biography_divine_show")
	state_machine.remove("role_biography_divine_hide")
	state_machine.remove("role_biography_divine_draw")
	state_machine.remove("role_biography_divine_reward_preview")
	state_machine.remove("role_biography_divine_jump_chapter")
	state_machine.remove("role_biography_divine_buy")
	state_machine.remove("role_biography_divine_refresh_count")
	state_machine.remove("role_biography_divine_refresh_ui")
	state_machine.remove("role_biography_divine_get_extra_reward")
end

function RoleBiographyDivine:close()
	-- window event : close.
	
end

function RoleBiographyDivine:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
