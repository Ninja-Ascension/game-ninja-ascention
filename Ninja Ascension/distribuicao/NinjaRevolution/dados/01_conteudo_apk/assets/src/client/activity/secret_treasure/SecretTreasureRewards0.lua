--[[ ----------------------------------------------------------------------------
-- 奖励设置
--]] ----------------------------------------------------------------------------
SecretTreasureRewards0 = class("SecretTreasureRewards0Class", Window)

-- 打开窗口
local secret_treasure_rewards0_window_open_terminal = {
	_name = "secret_treasure_rewards0_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasureRewards0Class") then
			fwin:open(SecretTreasureRewards0:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_rewards0_window_close_terminal = {
	_name = "secret_treasure_rewards0_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasureRewards0Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_rewards0_window_open_terminal)
state_machine.add(secret_treasure_rewards0_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasureRewards0:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.currentScrollView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	-- load lua files.

	-- Initialize secret treasure rewards0 page state machine.
	local function init_secret_treasure_rewards0_terminal()
		-- 打开角色创建窗口
		local secret_treasure_rewards0_open_terminal = {
			_name = "secret_treasure_rewards0_open",
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
		local secret_treasure_rewards0_close_terminal = {
			_name = "secret_treasure_rewards0_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_rewards0_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_rewards0_show_terminal = {
			_name = "secret_treasure_rewards0_show",
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
		local secret_treasure_rewards0_hide_terminal = {
			_name = "secret_treasure_rewards0_hide",
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

		-- 刷新列表
		local secret_treasure_rewards0_update_scrollview_terminal = {
			_name = "secret_treasure_rewards0_update_scrollview",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local tabType = instance._tabType

					if params and params._datas and params._datas._tabType then
						tabType = params._datas._tabType
					end

					instance.Button_zjjl:setHighlighted(tabType == 0)
					instance.Button_jjjl:setHighlighted(tabType == 1)

					instance.Text_tips:setVisible(tabType == 1)

					instance:updateScrollView(tabType)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(secret_treasure_rewards0_open_terminal)
		state_machine.add(secret_treasure_rewards0_close_terminal)
		state_machine.add(secret_treasure_rewards0_show_terminal)
		state_machine.add(secret_treasure_rewards0_hide_terminal)
		state_machine.add(secret_treasure_rewards0_update_scrollview_terminal)
		state_machine.init()
	end
	-- call func init secret treasure rewards0 state machine.
	init_secret_treasure_rewards0_terminal()
end

-- 对象初始化
function SecretTreasureRewards0:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SecretTreasureRewards0:getNormalFloorBigReward()
	local tSortedHeroes = SecretTreasureHandle.getSecretAllNormalFinalRewardsInfo()
	return tSortedHeroes
end

function SecretTreasureRewards0:getSpecialFloorBigReward()
	local tSortedHeroes = SecretTreasureHandle.getSecretAllSpecialFinalRewardsInfo()
	return tSortedHeroes
end

function SecretTreasureRewards0:updateScrollView(tabType)
	local tSortedHeroes = {}
	if tabType == 0 then
		tSortedHeroes = self:getNormalFloorBigReward()
	else
		tSortedHeroes = self:getSpecialFloorBigReward()
	end

	local m_ScrollView = self.ScrollView_warehouse
	m_ScrollView:removeAllChildren(true)

	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)

	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
	local wPosition = sWidth/6

	local Hlindex = 0
	local number = #tSortedHeroes
	local m_number = math.ceil(number/6)

	cellHeight = m_number*(m_ScrollView:getContentSize().width/6)

	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local first = nil
	for j, v in pairs(tSortedHeroes) do
		local cell = state_machine.excute("secret_treasure_item_create", 0, {type = 2, reward = v})
		panel:addChild(cell)
		if j == 1 then
			first = cell
		end
		tWidth = tWidth + wPosition

		if (j-1)%6 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - wPosition*Hlindex - 25
		end
		if j <= 6 then
			tHeight = sHeight - wPosition - 15
		end
		cell:setPosition(cc.p(tWidth - 10, tHeight))
	end
	m_ScrollView:jumpToTop()

	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function SecretTreasureRewards0:onUpdate(dt)
    -- if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
    --     local size = self.currentScrollView:getContentSize()
    --     local posY = self.currentInnerContainer:getPositionY()
    --     if self.currentInnerContainerPosY == posY then
    --         return
    --     end
    --     self.currentInnerContainerPosY = posY
    --     local items = self.currentScrollView:getChildren()
    --     if items[1] == nil then
    --         return
    --     end
    --     local itemSize = items[1]:getContentSize()
    --     for i, v in pairs(items) do
    --         local tempY = v:getPositionY() + posY
    --         if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
    --             v:unload()
    --         else
    --             v:reload()
    --         end
    --     end
    -- end
end

function SecretTreasureRewards0:onUpdateDraw()
	local root = self.roots[1]

	-- 奖励列表
	self.ScrollView_warehouse = ccui.Helper:seekWidgetByName(root, "ScrollView_warehouse")

	-- tips
	self.Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")

	local floorNumberStr = ""
	local data = SecretTreasureHandle.getSecretData()
	local specialRewardFloorList = zstring.split(data.specialRewardTier, "|")
	for i, v in ipairs(specialRewardFloorList) do
		local floor = tonumber(v) + 1
		floorNumberStr = floorNumberStr .. floor
		if i ~= #specialRewardFloorList then
			floorNumberStr = floorNumberStr .. ","
		end
	end

	local str = string.format(tipStringInfo_activity_secret_treasure[4], floorNumberStr)
	self.Text_tips:setString(str)

	local isSpecial = SecretTreasureHandle.getSecretIsSpecialFloor()
	if isSpecial then
		self._tabType = 1
	else
		self._tabType = 0
	end
	state_machine.excute("secret_treasure_rewards0_update_scrollview", 0, nil)
end

function SecretTreasureRewards0:onEnterTransitionFinish()
	-- 加载SecretTreasureRewards0Window界面资源.
	-- res.activity.secret_treasure.secret_treasure_rewards_0 = res/activity/secret_treasure/secret_treasure_rewards_0.csb
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_rewards_0.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 终极奖励选择
	self.Button_zjjl = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zjjl"), nil,
	{
		terminal_name = "secret_treasure_rewards0_update_scrollview",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_tabType = 0
	}, nil, 0)	

	-- 究极奖励选择
	self.Button_jjjl = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jjjl"), nil,
	{
		terminal_name = "secret_treasure_rewards0_update_scrollview",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_tabType = 1
	}, nil, 0)	

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "secret_treasure_rewards0_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SecretTreasureRewards0:onExit()
	-- 释放SecretTreasureRewards0Window界面资源.
	state_machine.remove("secret_treasure_rewards0_open")
	state_machine.remove("secret_treasure_rewards0_close")
	state_machine.remove("secret_treasure_rewards0_show")
	state_machine.remove("secret_treasure_rewards0_hide")
	state_machine.remove("secret_treasure_rewards0_update_scrollview")
end

function SecretTreasureRewards0:close()
	-- window event : close.
	
end

function SecretTreasureRewards0:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
