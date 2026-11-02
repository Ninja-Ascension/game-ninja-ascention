--[[ ----------------------------------------------------------------------------
-- 奖励列表
--]] ----------------------------------------------------------------------------
SecretTreasureRewards = class("SecretTreasureRewardsClass", Window)

-- 打开窗口
local secret_treasure_rewards_window_open_terminal = {
	_name = "secret_treasure_rewards_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasureRewardsClass") then
			fwin:open(SecretTreasureRewards:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_rewards_window_close_terminal = {
	_name = "secret_treasure_rewards_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasureRewardsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_rewards_window_open_terminal)
state_machine.add(secret_treasure_rewards_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasureRewards:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.currentScrollView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	-- load lua files.

	-- Initialize secret treasure rewards page state machine.
	local function init_secret_treasure_rewards_terminal()
		-- 打开角色创建窗口
		local secret_treasure_rewards_open_terminal = {
			_name = "secret_treasure_rewards_open",
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
		local secret_treasure_rewards_close_terminal = {
			_name = "secret_treasure_rewards_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_rewards_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_rewards_show_terminal = {
			_name = "secret_treasure_rewards_show",
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
		local secret_treasure_rewards_hide_terminal = {
			_name = "secret_treasure_rewards_hide",
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

		state_machine.add(secret_treasure_rewards_open_terminal)
		state_machine.add(secret_treasure_rewards_close_terminal)
		state_machine.add(secret_treasure_rewards_show_terminal)
		state_machine.add(secret_treasure_rewards_hide_terminal)
		state_machine.init()
	end
	-- call func init secret treasure rewards state machine.
	init_secret_treasure_rewards_terminal()
end

-- 对象初始化
function SecretTreasureRewards:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SecretTreasureRewards:updateUI()
	self:updateFloorNumber()
	self:updateFinnalReward()
	self:updateScrollView()
end

-- 更新层数
function SecretTreasureRewards:updateFloorNumber()
	local curFloor = SecretTreasureHandle.getSecretFloorNumber()
	self.Text_round:setString(string.format(tipStringInfo_activity_secret_treasure[1], curFloor))
end

function SecretTreasureRewards:updateFinnalReward()
	self.Panel_final:removeAllChildren(true)

	local reward = SecretTreasureHandle.getSecretFinalReward()
	local cell = nil
	if reward then
		cell = self:addResourcesIconCell(reward)
		self:judgeFinalPropHaveSelect(cell)
	else
		cell = state_machine.excute("secret_treasure_item_create", 0, {type = 3, reward = nil})
	end

	self.Panel_final:addChild(cell)
end

function SecretTreasureRewards:addResourcesIconCell(propData)
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

function SecretTreasureRewards:getNormalPropList()
	local tSortedHeroes = SecretTreasureHandle.getSecretCommonRewards()
	return tSortedHeroes
end

function SecretTreasureRewards:updateScrollView()
	local tSortedHeroes = self:getNormalPropList()

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
		-- 调用仓库控件 useType = 
		local cell = self:addResourcesIconCell(v)
		self:judgePropHaveSelect(cell, j)
		panel:addChild(cell)
		if j == 1 then
			first = cell
		end
		tWidth = tWidth + wPosition

		if (j-1)%6 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - wPosition*Hlindex  
		end
		if j <= 6 then
			tHeight = sHeight - wPosition
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()

	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

-- 判断普通道具是否已领取
function SecretTreasureRewards:judgePropHaveSelect(cell, index)
	local haveGotReward = SecretTreasureHandle.getSecretCommonRewardState(index) == 2
	cell:setChooseSelectState(haveGotReward)
end

-- 判断终极道具是否已领取
function SecretTreasureRewards:judgeFinalPropHaveSelect(cell)

end

function SecretTreasureRewards:onUpdate(dt)
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

function SecretTreasureRewards:onUpdateDraw()
	local root = self.roots[1]

	-- 第%s層
	self.Text_round = ccui.Helper:seekWidgetByName(root, "Text_round")

	-- 普通奖励列表
	self.ScrollView_warehouse = ccui.Helper:seekWidgetByName(root, "ScrollView_warehouse")

	-- 终极奖励容器
	self.Panel_final = ccui.Helper:seekWidgetByName(root, "Panel_final")

	self:updateUI()
end

function SecretTreasureRewards:onEnterTransitionFinish()
	-- 加载SecretTreasureRewardsWindow界面资源.
	-- res.activity.secret_treasure.secret_treasure_rewards = res/activity/secret_treasure/secret_treasure_rewards.csb
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_rewards.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "secret_treasure_rewards_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SecretTreasureRewards:onExit()
	-- 释放SecretTreasureRewardsWindow界面资源.
	state_machine.remove("secret_treasure_rewards_open")
	state_machine.remove("secret_treasure_rewards_close")
	state_machine.remove("secret_treasure_rewards_show")
	state_machine.remove("secret_treasure_rewards_hide")
end

function SecretTreasureRewards:close()
	-- window event : close.
	
end

function SecretTreasureRewards:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
