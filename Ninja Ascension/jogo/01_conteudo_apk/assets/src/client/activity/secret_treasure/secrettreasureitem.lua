--[[ ----------------------------------------------------------------------------
-- 道具
--]] ----------------------------------------------------------------------------
SecretTreasureItem = class("SecretTreasureItemClass", Window)
SecretTreasureItem.__size = nil

-- 创建Cell实例
local secret_treasure_item_create_terminal = {
	_name = "secret_treasure_item_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SecretTreasureItem then
			local cell = SecretTreasureItem:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_item_create_terminal)
state_machine.init()

-- 构造器
function SecretTreasureItem:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure item page state machine.
	local function init_secret_treasure_item_terminal()
		-- 设置奖励
		local secret_treasure_item_set_reward_terminal = {
			_name = "secret_treasure_item_set_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local _self = params._datas._self

				local rewardIndex = _self._reward.index
				local rewardContent = _self._reward.rewardContent
				state_machine.excute("secret_treasure_prompt_2_window_open", 0, {rewardIndex, rewardContent})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开选择终极奖励面板
		local secret_treasure_item_open_final_reward_select_terminal = {
			_name = "secret_treasure_item_open_final_reward_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local root = params._datas._self
				
				local canGoNext = SecretTreasureHandle.canGoToNextFloor()
				if canGoNext then
					-- 打开确认跳转弹窗
					state_machine.excute("secret_treasure_prompt_3_window_open", 0, nil)
				else
					state_machine.excute("secret_treasure_rewards0_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(secret_treasure_item_set_reward_terminal)
		state_machine.add(secret_treasure_item_open_final_reward_select_terminal)
	end
	-- call func init secret treasure item state machine.
	init_secret_treasure_item_terminal()
end

-- 对象初始化
function SecretTreasureItem:init(params)
	self._type = params.type
	self._reward = params.reward

	self:onInit(params)
	self:setContentSize(SecretTreasureItem.__size)
	return self
end

function SecretTreasureItem:updateUI()
	fwin:removeTouchEventListener(self.Panel_item)
	self.CheckBox_skip:setVisible(false)
	self.CheckBox_skip:setTouchEnabled(false)

	self.Image_add:setVisible(false)
	self.Image_wjs:setVisible(false)
	self.Image_wsz:setVisible(false)
	self.Text_45:setVisible(false)

	if self._type == 1 then
		-- 点击icon是设置终极宝物
		-- 长按是查看宝物详情
		self.Panel_item:setTouchEnabled(true)
		fwin:addTouchEventListener(self.Panel_item, nil,
		{
			terminal_name = "secret_treasure_item_open_final_reward_select",
			terminal_state = 0,
			isPressedActionEnabled = true,
			_self = self
		}, nil, 0)

		self.Text_45:setVisible(false)

		if self._reward == nil or self._reward == "" then
			self.Image_add:setVisible(true)
		else
			self.Image_add:setVisible(false)
			self:updateReward(self._reward)
		end
	elseif self._type == 2 then
		local remainTimes = self._reward.remainSetCount
		local maxTimes = self._reward.maxSetCount
		self.Text_45:setString(remainTimes .. "/" .. maxTimes)
		self.Text_45:setVisible(true)

		local isGray = nil
		if remainTimes == 0 then
			isGray = true
		end

		local reward = self._reward.rewardContent
		self:updateReward(reward, false, isGray)

		local isSelect = self._reward.isSelect
		self.CheckBox_skip:setVisible(true)
		self.CheckBox_skip:setSelected(isSelect)

		local canSelect = self._reward.canSelect
		if canSelect then
			self.Panel_item:setTouchEnabled(true)
			fwin:addTouchEventListener(self.Panel_item, nil,
			{
				terminal_name = "secret_treasure_item_set_reward",
				terminal_state = 0,
				isPressedActionEnabled = true,
				_self = self
			}, nil, 0)
		else
			self.Image_wjs:setVisible(true)
		end
	else
		self.Text_45:setVisible(false)
		-- 未设置
		self.Image_wsz:setVisible(true)
	end
end

function SecretTreasureItem:updateReward(reward, notShowCount, isGray)
	self.Panel_item:removeAllChildren(true)

	local cell = self:addResourcesIconCell(reward, notShowCount)
	if isGray then
		cell:setGrayState(true)
	else
		cell:setGrayState(false)
	end

	self.Panel_item:addChild(cell)
end

function SecretTreasureItem:addResourcesIconCell(propData, notShowCount)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])

	local count = tonumber(propData[3])
	if notShowCount == true then
		count = 0
	end

	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, count, tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, count, tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function SecretTreasureItem:onUpdateDraw()
	local root = self.roots[1]

	-- 加号
	self.Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")

	self.Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")

	self.Panel_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_1")

	self.Image_wjs = ccui.Helper:seekWidgetByName(root, "Image_wjs")

	self.Image_wsz = ccui.Helper:seekWidgetByName(root, "Image_wsz")

	self.CheckBox_skip = ccui.Helper:seekWidgetByName(root, "CheckBox_skip")

	self.Text_45 = ccui.Helper:seekWidgetByName(root, "Text_45")

	self:updateUI()
end

function SecretTreasureItem:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")
	Image_add:setVisible(false)

	local Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")
	Panel_item:removeAllChildren(true)

	local Panel_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_1")
	Panel_effect_1:removeAllChildren(true)

	local Image_wjs = ccui.Helper:seekWidgetByName(root, "Image_wjs")
	Image_wjs:setVisible(false)

	local Image_wsz = ccui.Helper:seekWidgetByName(root, "Image_wsz")
	Image_wsz:setVisible(false)

	local CheckBox_skip = ccui.Helper:seekWidgetByName(root, "CheckBox_skip")
	CheckBox_skip:setVisible(false)

	local Text_45 = ccui.Helper:seekWidgetByName(root, "Text_45")
	Text_45:setVisible(false)
end

function SecretTreasureItem:onEnterTransitionFinish()
	
end

function SecretTreasureItem:onInit(params)
	-- 加载SecretTreasureItemWindow界面资源.
	-- res.activity.secret_treasure.secret_treasure_item = res/activity/secret_treasure/secret_treasure_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/secret_treasure/secret_treasure_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SecretTreasureItem.__size == nil then
		SecretTreasureItem.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function SecretTreasureItem:onExit()
	-- 释放SecretTreasureItemWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/secret_treasure/secret_treasure_item.csb", root)
	-- ]]
end

function SecretTreasureItem:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SecretTreasureItem:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/secret_treasure/secret_treasure_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
