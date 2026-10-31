--[[ ----------------------------------------------------------------------------
-- 私人订制主界面
--]] ----------------------------------------------------------------------------
PrivateCustomFormation = class("PrivateCustomFormationClass", Window)

-- 打开窗口
local private_custom_formation_window_open_terminal = {
	_name = "private_custom_formation_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("PrivateCustomFormationClass") then
			fwin:open(PrivateCustomFormation:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local private_custom_formation_window_close_terminal = {
	_name = "private_custom_formation_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("PrivateCustomFormationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(private_custom_formation_window_open_terminal)
state_machine.add(private_custom_formation_window_close_terminal)
state_machine.init()

-- 构造器
function PrivateCustomFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 上方选中的物品
	self._topChooseIndex = nil
	-- 下方选中的物品
	self._bottomChooseIndex = 1

	self._info = nil
	self._gear = nil
	self._optionalRewardInfo = nil

	-- load lua files.

	-- Initialize private custom formation page state machine.
	local function init_private_custom_formation_terminal()
		-- 打开角色创建窗口
		local private_custom_formation_open_terminal = {
			_name = "private_custom_formation_open",
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
		local private_custom_formation_close_terminal = {
			_name = "private_custom_formation_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("private_custom_formation_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local private_custom_formation_show_terminal = {
			_name = "private_custom_formation_show",
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
		local private_custom_formation_hide_terminal = {
			_name = "private_custom_formation_hide",
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

		-- 选中下方道具
		local private_custom_formation_select_bottom_prop_terminal = {
			_name = "private_custom_formation_select_bottom_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local index = params.index
					instance._bottomChooseIndex = index
					instance:selectBottomProp()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 选中上方道具
		local private_custom_formation_select_top_prop_terminal = {
			_name = "private_custom_formation_select_top_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local index = params.index
					instance._topChooseIndex = index

					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击确定设置奖励
		local private_custom_formation_set_reward_terminal = {
			_name = "private_custom_formation_set_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					-- 充值档位
					-- 可选奖励(选择的奖励下标  竖线分割  没有选择的-1填充 例 : 2|1|-1)

					local optionalRewardStr = instance:getOptionalRewardStr()
					local gear = self._gear

					-- print("gear = ", gear, " optionalRewardStr = ", optionalRewardStr)

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- 领取完刷新界面
							state_machine.excute("private_custom_refesh_windows", 0, nil)
							state_machine.excute("private_custom_formation_close", 0, nil)
						end
					end
					protocol_command.private_custom_reward_set.param_list = "" .. gear .. "\r\n" .. optionalRewardStr
					NetworkManager:register(protocol_command.private_custom_reward_set.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 快速跳转到列表左右两侧
		local private_custom_formation_quick_jump_terminal = {
			_name = "private_custom_formation_quick_jump",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local dir = params._datas.dir
					instance:jumpListView(dir)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(private_custom_formation_open_terminal)
		state_machine.add(private_custom_formation_close_terminal)
		state_machine.add(private_custom_formation_show_terminal)
		state_machine.add(private_custom_formation_hide_terminal)
		state_machine.add(private_custom_formation_select_bottom_prop_terminal)
		state_machine.add(private_custom_formation_select_top_prop_terminal)
		state_machine.add(private_custom_formation_set_reward_terminal)
		state_machine.add(private_custom_formation_quick_jump_terminal)
		state_machine.init()
	end
	-- call func init private custom formation state machine.
	init_private_custom_formation_terminal()
end

-- 对象初始化
function PrivateCustomFormation:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function PrivateCustomFormation:onInit(params)
	self._gear = params.gear
	self._topChooseIndex = params.index

	local privateCustomInfo = _ED.active_activity[170].privateCustomInfo
	for _, v in pairs(privateCustomInfo) do
		if tonumber(v.gear) == self._gear then
			self._info = v
			self._optionalRewardInfo = zstring.splits(self._info.optionalReward, "|", ",")
			break
		end
	end
end

function PrivateCustomFormation:updateUI()
	self:updateTopProps()
	self:selectTopProp()

	self._bottomChooseIndex = self:getBottomChooseIndex(self._topChooseIndex)
	self:updateBottomProps()
	self:selectBottomProp()
end

-- 刷新顶部道具
function PrivateCustomFormation:updateTopProps()
	local sortInfo = self:getPropSortInfo()

	self.ListView_1:removeAllItems()

	-- 每个档位奖励的数量
	local fixedRewardNum = self:getFixedRewardNum()
	local totalNum = fixedRewardNum + self:getOptionalRewardNum()

	for i = 1, totalNum do
		local info = sortInfo[i]
		local canClickItem = i > fixedRewardNum

		-- print("i = ", i, " fixedRewardNum = ", fixedRewardNum, " canClickItem = ", canClickItem)

		local cell = state_machine.excute("private_custom_item_create", 0, {info = info, buttonType = 2, index = i, canClickItem = canClickItem})
		self.ListView_1:addChild(cell)
	end

	self.ListView_1:requestRefreshView()
end

function PrivateCustomFormation:getPropSortInfo()
	local info = self._info

	local rewards = {}

	local fixedReward = zstring.splits(info.fixedReward, "|", ",")
	local optionalReward = self._optionalRewardInfo

	for _, v in ipairs(fixedReward) do
		if v[1] and v[1] ~= "" then
			table.insert(rewards, v)
		end
	end

	for _, v in ipairs(optionalReward) do
		table.insert(rewards, v)
	end

	return rewards
end

function PrivateCustomFormation:getFixedRewardNum()
	local info = self._info
	local fixedReward = zstring.splits(info.fixedReward, "|", ",")
	local length = info.fixedReward == "" and 0 or table.nums(fixedReward)
	return length
end

function PrivateCustomFormation:getOptionalRewardNum()
	local length = table.nums(self._optionalRewardInfo)
	return length
end

function PrivateCustomFormation:updateOptionalRewardInfo()
	local optionalRewardInfo = self._optionalRewardInfo

	local prop = {}
	local propsInfo = self:getBottomPropsInfo(self._topChooseIndex)
	for k, v in pairs(propsInfo) do
		if k == self._bottomChooseIndex then
			prop = v
			break
		end
	end

	local index = self._topChooseIndex - self:getFixedRewardNum()
	optionalRewardInfo[index] = prop

	self._optionalRewardInfo = optionalRewardInfo
end

function PrivateCustomFormation:getOptionalRewardStr()
	local optionalRewardStr = ""
	local result = {}

	local optionalRewardInfo = self._optionalRewardInfo

	local fixedRewardNum = self:getFixedRewardNum()
	for i, v in ipairs(optionalRewardInfo) do
		if v and tonumber(v[1]) > 0 then
			local index = self:getBottomChooseIndex(i + fixedRewardNum)
			table.insert(result, index)
		else
			table.insert(result, -1)
		end
	end

	for i = 1, #result do
		optionalRewardStr = optionalRewardStr .. result[i]
		if i < #result then
			optionalRewardStr = optionalRewardStr .. "|"
		end
	end

	return optionalRewardStr
end

-- 选择上方的一个可选道具
function PrivateCustomFormation:selectTopProp()
	local topChooseIndex = self._topChooseIndex

	local topItems = self.ListView_1:getItems()
	for k, v in pairs(topItems) do
		if k == topChooseIndex then
			v:showSelectEffect(true)
		else
			v:showSelectEffect(false)
		end
	end
end

-- 刷新底部道具库
function PrivateCustomFormation:updateBottomProps()
	self.ListView_4:removeAllItems()

	local propsInfo = self:getBottomPropsInfo(self._topChooseIndex)
	for i, v in ipairs(propsInfo) do
		local cell = state_machine.excute("private_custom_item_create", 0, {info = v, buttonType = 3, index = i, canClickItem = true})
		self.ListView_4:addChild(cell)
	end

	self.ListView_4:requestRefreshView()
end

function PrivateCustomFormation:getBottomPropsInfo(topChooseIndex)
	local info = self._info
	local index = topChooseIndex - self:getFixedRewardNum()
	-- print("index = ", index, " self._topChooseIndex = ", self._topChooseIndex, " self:getFixedRewardNum() = ", self:getFixedRewardNum())
	-- debug.print_r(info.optionalRewardLibrary, "info.optionalRewardLibrary")
	local optionalRewardLibrary = info.optionalRewardLibrary[index]
	local rewards = zstring.splits(optionalRewardLibrary, "|", ",")
	return rewards
end

-- 选中道具，显示对勾
function PrivateCustomFormation:selectBottomProp(chooseBottomIndex)
	local items = self.ListView_4:getItems()

	local bottomChooseIndex  = self._bottomChooseIndex
	for k, v in pairs(items) do
		local children = v.Panel_item:getChildren()
		local cell = children[1]
		if cell ~= nil then
			if bottomChooseIndex == k then
				cell:setChooseSelectState(true)
			else
				cell:setChooseSelectState(false)
			end
		end
	end

	-- 将选中的道具信息存入并刷新上方道具
	self:updateOptionalRewardInfo()
	self:updateTopProps()
	self:selectTopProp()
end

-- 获得下方道具选中的下标
function PrivateCustomFormation:getBottomChooseIndex(topChooseIndex)
	local bottomChooseIndex = 1

	local nowTopProp = nil
	local topSortInfo = self:getPropSortInfo()
	for i, v in ipairs(topSortInfo) do
		if i == topChooseIndex then
			nowTopProp = v
			break
		end
	end

	local bottomPropsInfo = self:getBottomPropsInfo(topChooseIndex)
	for k , v in pairs(bottomPropsInfo) do
		if nowTopProp ~= nil and v ~= nil then
			if zstring.tonumber(nowTopProp[1]) == zstring.tonumber(v[1]) 
				and zstring.tonumber(nowTopProp[2]) == zstring.tonumber(v[2]) 
				and zstring.tonumber(nowTopProp[3]) == zstring.tonumber(v[3]) 
				and zstring.tonumber(nowTopProp[4]) == zstring.tonumber(v[4]) then
					bottomChooseIndex = k
					break
			end
		end
	end

	return bottomChooseIndex
end

function PrivateCustomFormation:jumpListView(dir)
	if dir < 0 then
		self.ListView_4:jumpToLeft()
	else
		self.ListView_4:jumpToRight()
	end
	self.ListView_4:requestRefreshView()
end

function PrivateCustomFormation:onUpdateDraw()
	local root = self.roots[1]

	-- 已选列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 奖励库列表
	self.ListView_4 = ccui.Helper:seekWidgetByName(root, "ListView_4")


	self:updateUI()
end

function PrivateCustomFormation:onEnterTransitionFinish()
	-- 加载PrivateCustomFormationWindow界面资源.
	-- res.activity.private_custom.private_custom_formation = res/activity/private_custom/private_custom_formation.csb
	local csbNode = csb.createNode("activity/private_custom/private_custom_formation.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)	

	-- 确定
	self.Button_ok = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil,
	{
		terminal_name = "private_custom_formation_set_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "private_custom_formation_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 左滑按钮
	self.Button_left = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_left"), nil,
	{
		terminal_name = "private_custom_formation_quick_jump",
		terminal_state = 0,
		isPressedActionEnabled = true,
		dir = -1
	}, nil, 0)	

	-- 右滑按钮
	self.Button_right = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right"), nil,
	{
		terminal_name = "private_custom_formation_quick_jump",
		terminal_state = 0,
		isPressedActionEnabled = true,
		dir = 1
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "private_custom_formation_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function PrivateCustomFormation:onExit()
	-- 释放PrivateCustomFormationWindow界面资源.
	state_machine.remove("private_custom_formation_open")
	state_machine.remove("private_custom_formation_close")
	state_machine.remove("private_custom_formation_show")
	state_machine.remove("private_custom_formation_hide")
	state_machine.remove("private_custom_formation_select_bottom_prop")
	state_machine.remove("private_custom_formation_select_top_prop")
	state_machine.remove("private_custom_formation_set_reward")
	state_machine.remove("private_custom_formation_quick_jump")
end

function PrivateCustomFormation:close()
	-- window event : close.
	
end

function PrivateCustomFormation:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
