--[[ ----------------------------------------------------------------------------
-- 公会援助主界面
--]] ----------------------------------------------------------------------------
LegionAssistance = class("LegionAssistanceClass", Window)

-- 打开窗口
local legion_assistance_window_open_terminal = {
	_name = "legion_assistance_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LegionAssistanceClass") then
			fwin:open(LegionAssistance:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local legion_assistance_window_close_terminal = {
	_name = "legion_assistance_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("union_unlock_state_machine", 0, nil)
		fwin:close(fwin:find("LegionAssistanceClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_assistance_window_open_terminal)
state_machine.add(legion_assistance_window_close_terminal)
state_machine.init()

-- 构造器
function LegionAssistance:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.assistanceInfo = {}
	self.myAssistanceInfo = {}
	self.rewardNum = 0
	self.userState = 0
	self.abilityCountMap = {}
	self.memberInfoMap = {}

	-- load lua files.

	app.load("client.l_digital.union.legionAssistance.LegionAssistanceRecord")
	app.load("client.l_digital.union.legionAssistance.LegionAssistanceRule")
	app.load("client.l_digital.union.legionAssistance.LegionAssistanceWindow1")
	app.load("client.l_digital.union.legionAssistance.LegionAssistanceWindow2")
	app.load("client.l_digital.union.legionAssistance.LegionAssistanceList")

	-- Initialize legion assistance page state machine.
	local function init_legion_assistance_terminal()
		-- 打开角色创建窗口
		local legion_assistance_open_terminal = {
			_name = "legion_assistance_open",
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
		local legion_assistance_close_terminal = {
			_name = "legion_assistance_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("legion_assistance_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local legion_assistance_show_terminal = {
			_name = "legion_assistance_show",
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
		local legion_assistance_hide_terminal = {
			_name = "legion_assistance_hide",
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

		-- 打开公会援助记录
		local legion_assistance_all_record_open_terminal = {
			_name = "legion_assistance_all_record_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- state_machine.excute("legion_assistance_record_window_open", 0, nil)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							state_machine.excute("legion_assistance_record_window_open", 0, nil)
						end
					end
				end
				NetworkManager:register(protocol_command.union_assistance_all_record.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开碎片求助界面
		local legion_assistance_ask_debris_open_terminal = {
			_name = "legion_assistance_ask_debris_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("legion_assistance_window1_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开规则界面
		local legion_assistance_help_rule_open_terminal = {
			_name = "legion_assistance_help_rule_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("legion_assistance_rule_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新公会援助界面
		local legion_assistance_refresh_main_ui_terminal = {
			_name = "legion_assistance_refresh_main_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:refeshAssistInfo()
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(legion_assistance_open_terminal)
		state_machine.add(legion_assistance_close_terminal)
		state_machine.add(legion_assistance_show_terminal)
		state_machine.add(legion_assistance_hide_terminal)

		state_machine.add(legion_assistance_all_record_open_terminal)
		state_machine.add(legion_assistance_ask_debris_open_terminal)
		state_machine.add(legion_assistance_help_rule_open_terminal)
		state_machine.add(legion_assistance_refresh_main_ui_terminal)

		state_machine.init()
	end
	-- call func init legion assistance state machine.
	init_legion_assistance_terminal()
end

-- 对象初始化
function LegionAssistance:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function LegionAssistance:onInit()
	self:setAbilityCountMap()
	self:setMemberInfoMap()
	self:refeshAssistInfo()
end

function LegionAssistance:refeshAssistInfo()
	local info = _ED.union.union_assistance_info

	-- 求助信息
	self.assistanceInfo = info.assistanceInfo

	-- 自身求助信息
	self.myAssistanceInfo = info.myAssistanceInfo

	-- 已获得捐赠奖励数量; 英雄碎片
	self.rewardNumShip = tonumber(info.rewardNumShip)

	-- 已获得捐赠奖励数量; 武器碎片
	self.rewardNumEquipment = tonumber(info.rewardNumEquipment)

	-- 用户是否可求助 (0:不可 1:可)
	self.userState = tonumber(info.userState)

	-- 更新公会币数量
	_ED.union.user_union_info.rest_contribution = tonumber(info.contribution)
end

function LegionAssistance:setAbilityCountMap()
	-- 13,5|14,4|15,3|16,2|17,1
	local config = zstring.split(dms.string(dms["union_config"], 66, union_config.param), "|")
	local abilityCountMap = {}
	for k, v in pairs(config) do
		local data = zstring.split(v, ",")
		local ability, count = tonumber(data[1]), tonumber(data[2])
		abilityCountMap[ability] = count
	end

	local weapon_count = dms.int(dms["union_config"], 70, union_config.param)
	abilityCountMap['weapon'] = weapon_count
	self.abilityCountMap = abilityCountMap
end

function LegionAssistance:setMemberInfoMap()
	local memberInfoMap = {}
	for _, v in pairs(_ED.union.union_member_list_info) do
		local userId = tonumber(v.id)
		memberInfoMap[userId] = v
	end

	self.memberInfoMap = memberInfoMap
end

function LegionAssistance:getAllAskList()
	-- 所有的求助信息
	local allAskList = {}

	local myAssistanceInfo = self.myAssistanceInfo
	for _, v in pairs(myAssistanceInfo) do
		table.insert(allAskList, v)
	end

	-- 其他求助信息
	local notCompleteAskList = {}
	local completeAskList = {}
	local assistanceInfo = self.assistanceInfo
	for k, v in pairs(assistanceInfo) do
		local shipMouldId = dms.int(dms["prop_mould"], tonumber(v.askPropId), prop_mould.use_of_ship)
		local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
		local remainCount = 0
		if shipMouldId > 0 then
			remainCount = self.abilityCountMap[ability] - tonumber(v.gotPropNum)
		else
			remainCount = self.abilityCountMap['weapon']
		end

		if remainCount > 0 then
			table.insert(notCompleteAskList, v)
		else
			table.insert(completeAskList, v)
		end
	end

	-- 排序函数
	local function sortByAskTime(a, b)
		local askTimeA = tonumber(a.askTime)
		local askTimeB = tonumber(b.askTime)

		return askTimeA > askTimeB
	end

	-- table.sort(notCompleteAskList, sortByAskTime)
	-- table.sort(completeAskList, sortByAskTime)

	for _, v in ipairs(notCompleteAskList) do
		table.insert(allAskList, v)
	end

	for _, v in ipairs(completeAskList) do
		table.insert(allAskList, v)
	end

	table.sort(allAskList, sortByAskTime)

	return allAskList
end

function LegionAssistance:updateAllDonateList()
	self.ListView_assistance:removeAllItems()
	local askList = self:getAllAskList()
	for i, v in ipairs(askList) do
		local unionData = self.memberInfoMap[tonumber(v.userId)]

		local cell = state_machine.excute("legion_assistance_list_create", 0, {index = i, data = v, abilityCountMap = self.abilityCountMap, unionData = unionData})
		self.ListView_assistance:addChild(cell)
	end
	self.ListView_assistance_poy = self.ListView_assistance:getInnerContainer():getPositionY()
	self.ListView_assistance:jumpToTop()
	self.ListView_assistance:requestRefreshView()
end

function LegionAssistance:showNothingUI()
	self.ListView_assistance:removeAllItems()
	self.Text_nothing:setVisible(true)
end

function LegionAssistance:updateLoadingProgress()
	local rewardNum = self.rewardNum
	local maxRewardNum_1 = dms.int(dms["union_config"], 68, union_config.param)
	local maxRewardNum_2 = dms.int(dms["union_config"], 72, union_config.param)

	self.Text_num_2:setString(tostring(maxRewardNum_1))
	self.Text_num_2_1:setString(tostring(maxRewardNum_2))

	self.Text_num_1:setString(tostring(self.rewardNumShip))
	self.Text_num_1_1:setString(tostring(self.rewardNumEquipment))
end

function LegionAssistance:updateUI()
	local recordCount = table.nums(self.assistanceInfo) + table.nums(self.myAssistanceInfo)

	if recordCount <= 0 then
		self:showNothingUI()
	else
		self.Text_nothing:setVisible(false)
		self:updateAllDonateList()
	end

	self:updateLoadingProgress()
	
	self.Button_ask:setTouchEnabled(self.userState == 1)
	self.Button_ask:setBright(self.userState == 1)

	self.Image_1:setVisible(self.userState == 1)
	self.Image_2:setVisible(self.userState == 0)
end

function LegionAssistance:onUpdateDraw()
	local root = self.roots[1]

	-- 公会援助主界面列表
	self.ListView_assistance = ccui.Helper:seekWidgetByName(root, "ListView_assistance")

	-- 英雄胸片每日捐赠最大值
	self.Text_num_2 = ccui.Helper:seekWidgetByName(root, "Text_num_2")

	-- 武器碎片每日捐赠
	self.Text_num_2_1 = ccui.Helper:seekWidgetByName(root, "Text_num_2_1")

	-- 每日已捐赠数 英雄碎片
	self.Text_num_1 = ccui.Helper:seekWidgetByName(root, "Text_num_1")

	-- 每日可捐赠总数 武器碎片
	self.Text_num_1_1 = ccui.Helper:seekWidgetByName(root, "Text_num_1_1")

	-- 无记录提示（默认隐藏）
	self.Text_nothing = ccui.Helper:seekWidgetByName(root, "Text_nothing")

	-- 求助图片
	self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")

	-- 已求助图片
	self.Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")

	self:updateUI()
end

function LegionAssistance:onEnterTransitionFinish()
	-- 加载LegionAssistanceWindow界面资源.
	-- res.legion.legion_assistance = res/legion/legion_assistance.csb
	local csbNode = csb.createNode("legion/legion_assistance.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 公会援助记录入口
	self.Button_record = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_record"), nil,
	{
		terminal_name = "legion_assistance_all_record_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 碎片求助按钮
	self.Button_ask = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ask"), nil,
	{
		terminal_name = "legion_assistance_ask_debris_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 规则按钮
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "legion_assistance_help_rule_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "legion_assistance_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

-- @onUpdate(dt)
function LegionAssistance:onUpdate(dt)
	if self.ListView_assistance ~= nil then
		local size = self.ListView_assistance:getContentSize()
		local posY = self.ListView_assistance:getInnerContainer():getPositionY()
		if self.ListView_assistance_poy == posY then
			return
		end
		self.ListView_assistance_poy = posY
		local items = self.ListView_assistance:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
				v:unload()
			else	
				v:reload()				
			end
		end
	end
end

function LegionAssistance:onExit()
	-- 释放LegionAssistanceWindow界面资源.
	state_machine.remove("legion_assistance_open")
	state_machine.remove("legion_assistance_close")
	state_machine.remove("legion_assistance_show")
	state_machine.remove("legion_assistance_hide")

	state_machine.remove("legion_assistance_all_record_open")
	state_machine.remove("legion_assistance_ask_debris_open")
	state_machine.remove("legion_assistance_help_rule_open")
	state_machine.remove("legion_assistance_refresh_main_ui")
end

function LegionAssistance:close()
	-- window event : close.
	
end

function LegionAssistance:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
