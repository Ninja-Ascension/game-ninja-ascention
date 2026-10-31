--[[ ----------------------------------------------------------------------------
-- 奖励预览
--]] ----------------------------------------------------------------------------
EggPromReward = class("EggPromRewardClass", Window)

-- 打开窗口
local egg_prom_reward_window_open_terminal = {
	_name = "egg_prom_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("EggPromRewardClass") then
			fwin:open(EggPromReward:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local egg_prom_reward_window_close_terminal = {
	_name = "egg_prom_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggPromRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_reward_window_open_terminal)
state_machine.add(egg_prom_reward_window_close_terminal)
state_machine.init()

-- 构造器
function EggPromReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._eggIndex = nil
	self._rewardGroups = {}
	self._rewardOddsGroups = {}
	self._rewardData = {}
	self._rewardOdds = {}

	self.currentScrollView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0


	-- load lua files.
	app.load("client.activity.egg_prom.eggpromitem")

	-- Initialize egg prom reward page state machine.
	local function init_egg_prom_reward_terminal()
		-- 打开角色创建窗口
		local egg_prom_reward_open_terminal = {
			_name = "egg_prom_reward_open",
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
		local egg_prom_reward_close_terminal = {
			_name = "egg_prom_reward_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("egg_prom_reward_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local egg_prom_reward_show_terminal = {
			_name = "egg_prom_reward_show",
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
		local egg_prom_reward_hide_terminal = {
			_name = "egg_prom_reward_hide",
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

		state_machine.add(egg_prom_reward_open_terminal)
		state_machine.add(egg_prom_reward_close_terminal)
		state_machine.add(egg_prom_reward_show_terminal)
		state_machine.add(egg_prom_reward_hide_terminal)
		state_machine.init()
	end
	-- call func init egg prom reward state machine.
	init_egg_prom_reward_terminal()
end

-- 对象初始化
function EggPromReward:init(params)
	self._eggIndex = params
	self._rewardGroups = {"normalReward", "goldReward", "diamondReward"}
	self._rewardOddsGroups = {}
	for _, v in ipairs(self._rewardGroups) do
		self._rewardOddsGroups[v] = v .. "Probability"
	end

	if nil ~= self.onInit then
		self:onInit(params)
	end

	return self
end

function EggPromReward:onInit(params)
	local activityData = _ED.active_activity[171]

	self._rewardData = {}
	self._rewardOdds = {}

	local rewardGroup = self._rewardGroups[self._eggIndex]
	for k, v in pairs(activityData.rewardData) do
		if k == rewardGroup then
			self._rewardData = v[k]
			local oddsKey = self._rewardOddsGroups[k]
			self._rewardOdds = v[oddsKey]
			break
		end
	end

	self._rewardData = zstring.splits(self._rewardData, "|", ",")
	self._rewardOdds = zstring.split(self._rewardOdds, "|")
end

function EggPromReward:getRewardData()
	local reward = {}
	for _, v in pairs(self._rewardData) do
		table.insert(reward, v)
	end
	return reward
end

function EggPromReward:getOddsData()
	local odds = {}
	for _, v in pairs(self._rewardOdds) do
		table.insert(odds, v)
	end
	return odds
end

function EggPromReward:updateRewardList()
	local tSortedHeroes = self:getRewardData()
	local oddsDatas = self:getOddsData()

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
		local cell = state_machine.excute("egg_prom_item_create", 0, {rewardData = v, odds = oddsDatas[j]})
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

function EggPromReward:onUpdate(dt)
	-- 滑动过快容易卡死
	-- if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
	-- 	local size = self.currentScrollView:getContentSize()
	-- 	local posY = self.currentInnerContainer:getPositionY()
	-- 	if self.currentInnerContainerPosY == posY then
	-- 		return
	-- 	end
	-- 	self.currentInnerContainerPosY = posY
	-- 	local items = self.currentScrollView:getChildren()
	-- 	if items[1] == nil then
	-- 		return
	-- 	end
	-- 	local itemSize = items[1]:getContentSize()
	-- 	for i, v in pairs(items) do
	-- 		local tempY = v:getPositionY() + posY
	-- 		if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
	-- 			v:unload()
	-- 		else
	-- 			v:reload()
	-- 		end
	-- 	end
	-- end
end

function EggPromReward:onUpdateDraw()
	local root = self.roots[1]

	-- 奖励容器
	self.ScrollView_warehouse = ccui.Helper:seekWidgetByName(root, "ScrollView_warehouse")

	self:updateRewardList()
end

function EggPromReward:onEnterTransitionFinish()
	-- 加载EggPromRewardWindow界面资源.
	-- res.activity.egg_prom.egg_prom_reward = res/activity/egg_prom/egg_prom_reward.csb
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_reward.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "egg_prom_reward_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function EggPromReward:onExit()
	-- 释放EggPromRewardWindow界面资源.
	state_machine.remove("egg_prom_reward_open")
	state_machine.remove("egg_prom_reward_close")
	state_machine.remove("egg_prom_reward_show")
	state_machine.remove("egg_prom_reward_hide")
end

function EggPromReward:close()
	-- window event : close.
	
end

function EggPromReward:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
