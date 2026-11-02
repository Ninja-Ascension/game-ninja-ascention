--[[ ----------------------------------------------------------------------------
-- 排行窗口
--]] ----------------------------------------------------------------------------
LimPoolRanking = class("LimPoolRankingClass", Window)

-- 打开窗口
local lim_pool_ranking_window_open_terminal = {
	_name = "lim_pool_ranking_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LimPoolRankingClass") then
			fwin:open(LimPoolRanking:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local lim_pool_ranking_window_close_terminal = {
	_name = "lim_pool_ranking_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LimPoolRankingClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_ranking_window_open_terminal)
state_machine.add(lim_pool_ranking_window_close_terminal)
state_machine.init()

-- 构造器
function LimPoolRanking:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._rankInfo = nil
	self._activityType = 0					-- 当前活动类型

	-- load lua files.
	app.load("client.activity.lim_pool.limpoolrankinglist")

	-- Initialize lim pool ranking page state machine.
	local function init_lim_pool_ranking_terminal()
		-- 打开角色创建窗口
		local lim_pool_ranking_open_terminal = {
			_name = "lim_pool_ranking_open",
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
		local lim_pool_ranking_close_terminal = {
			_name = "lim_pool_ranking_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_ranking_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local lim_pool_ranking_show_terminal = {
			_name = "lim_pool_ranking_show",
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
		local lim_pool_ranking_hide_terminal = {
			_name = "lim_pool_ranking_hide",
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

		state_machine.add(lim_pool_ranking_open_terminal)
		state_machine.add(lim_pool_ranking_close_terminal)
		state_machine.add(lim_pool_ranking_show_terminal)
		state_machine.add(lim_pool_ranking_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool ranking state machine.
	init_lim_pool_ranking_terminal()
end

-- 对象初始化
function LimPoolRanking:init(params)
	-- {
	-- 	"userInfo": 1,
	-- 	"nickName": "Tome",
	-- 	"score": 0,
	-- 	"rank": -1,
	-- 	"updateTime": 1578381557329
	-- }
	self._activityType = params[1]
	self._rankInfo = _ED.active_activity[self._activityType].rankInfo
	self._rankRewards = _ED.active_activity[self._activityType].info.randRewards

	return self
end

function LimPoolRanking:onUpdateDraw()
	local root = self.roots[1]

	-- 排行列表
	self.ListView_ranking = ccui.Helper:seekWidgetByName(root, "ListView_ranking")

	-- 自己的排名
	self.Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")

	self:updateRankList()
	self:updateMyRank()
end

function LimPoolRanking:updateMyRank()
	local myRankInfo = nil
	local isOnRanking = 0
	if _ED.active_activity[self._activityType].myRankInfo then
		myRankInfo = _ED.active_activity[self._activityType].myRankInfo
		
		-- 是否上榜
		if myRankInfo.rank and myRankInfo.visible and tonumber(myRankInfo.visible) == 1 then
			isOnRanking = 1
		end
	end
	
	self.Text_ranking:setString(isOnRanking == 1 and myRankInfo.rank or tipStringInfo_activity_limit_pool[4])
end

function LimPoolRanking:getRewardByRank(rank)
	local rankRewards = self._rankRewards
	local tempStr = ""
	for _, v in ipairs(rankRewards) do
		if rank >= tonumber(v.maxIndex) and rank <= tonumber(v.minIndex) then
			tempStr = v.indexRankReward
		end
	end
	local rewards = zstring.splits(tempStr, "|", ",")
	return rewards
end

function LimPoolRanking:getSortRankInfo()
	local rankInfo = self._rankInfo
	local sortRankInfo = {}
	-- 将排名奖励数据放进数组
	for _, v in pairs(rankInfo) do
		local rewards = self:getRewardByRank(tonumber(v.rank))
		v.rewards = rewards
		table.insert(sortRankInfo, v)
	end

	table.sort(sortRankInfo, function(a, b)
		local rankA = tonumber(a.rank)
		local rankB = tonumber(b.rank)

		if rankA == rankB then
			local updateTimeA = tonumber(a.updateTime)
			local updateTimeB = tonumber(b.updateTime)
			return updateTimeA < updateTimeB
		else
			return rankA < rankB
		end
		return false
	end)

	return sortRankInfo
end

function LimPoolRanking:updateRankList()
	self.ListView_ranking:removeAllItems()
	-- local rankListInfo = {{rank = 1, name = "11", point = 999, rewards = {{6, 317, 15}}}, {rank = 2, name = "22", point = 888, rewards = {{6, 318, 15}}},{rank = 3, name = "33", point = 777, rewards = {{6, 318, 15}}},{rank = 4, name = "44", point = 666, rewards = {{6, 319, 15}}}}
	local sortRankInfo = self:getSortRankInfo()
	for i, v in ipairs(sortRankInfo) do
		local cell = state_machine.excute("lim_pool_ranking_list_create", 0, {{index = i, data = v}, self._activityType})
		self.ListView_ranking:addChild(cell)
	end
	self.ListView_ranking_poy = self.ListView_ranking:getInnerContainer():getPositionY()
	self.ListView_ranking:jumpToTop()
	self.ListView_ranking:requestRefreshView()
end

function LimPoolRanking:onEnterTransitionFinish()
	-- 加载LimPoolRankingWindow界面资源.
	-- res.activity.lim_pool.lim_pool_ranking = res/activity/lim_pool/lim_pool_ranking.csb
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_ranking.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "lim_pool_ranking_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

-- @onUpdate(dt)
function LimPoolRanking:onUpdate(dt)
	if self.ListView_ranking ~= nil then
		local size = self.ListView_ranking:getContentSize()
		local posY = self.ListView_ranking:getInnerContainer():getPositionY()
		if self.ListView_ranking_poy == posY then
			return
		end
		self.ListView_ranking_poy = posY
		local items = self.ListView_ranking:getItems()
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

function LimPoolRanking:onExit()
	-- 释放LimPoolRankingWindow界面资源.
	state_machine.remove("lim_pool_ranking_open")
	state_machine.remove("lim_pool_ranking_close")
	state_machine.remove("lim_pool_ranking_show")
	state_machine.remove("lim_pool_ranking_hide")
end

function LimPoolRanking:close()
	-- window event : close.
	
end

function LimPoolRanking:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
