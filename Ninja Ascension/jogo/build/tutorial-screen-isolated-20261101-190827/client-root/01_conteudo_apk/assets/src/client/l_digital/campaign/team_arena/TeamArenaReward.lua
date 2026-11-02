--[[ ----------------------------------------------------------------------------
-- 战斗记录
--]] ----------------------------------------------------------------------------
TeamArenaReward = class("TeamArenaRewardClass", Window)

-- 打开窗口
local team_arena_reward_window_open_terminal = {
	_name = "team_arena_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaRewardClass") then
			fwin:open(TeamArenaReward:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_reward_window_close_terminal = {
	_name = "team_arena_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_reward_window_open_terminal)
state_machine.add(team_arena_reward_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.campaign.team_arena.teamarenarewardlist")

	-- Initialize team arena reward page state machine.
	local function init_team_arena_reward_terminal()
		-- 打开角色创建窗口
		local team_arena_reward_open_terminal = {
			_name = "team_arena_reward_open",
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
		local team_arena_reward_close_terminal = {
			_name = "team_arena_reward_close",
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
		local team_arena_reward_show_terminal = {
			_name = "team_arena_reward_show",
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
		local team_arena_reward_hide_terminal = {
			_name = "team_arena_reward_hide",
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

		state_machine.add(team_arena_reward_open_terminal)
		state_machine.add(team_arena_reward_close_terminal)
		state_machine.add(team_arena_reward_show_terminal)
		state_machine.add(team_arena_reward_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena reward state machine.
	init_team_arena_reward_terminal()
end

-- 对象初始化
function TeamArenaReward:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaReward:onUpdateDraw()
	local root = self.roots[1]

	-- 自己排名
	self.Text_my_raning = ccui.Helper:seekWidgetByName(root, "Text_my_raning")
	if _ED.team_arena_data.myTeamInfo then
		self.Text_my_raning:setString(_ED.team_arena_data.myTeamInfo.ranking)
	end
	-- 自己的奖励
	self.ListView_my_ranking = ccui.Helper:seekWidgetByName(root, "ListView_my_ranking")

	-- 还没有进行挑战
	self.Text_nothing = ccui.Helper:seekWidgetByName(root, "Text_nothing")

	-- 排行奖励列表
	self.ListView_preview = ccui.Helper:seekWidgetByName(root, "ListView_jjc_ph")

	local re = dms["cross_team_reward"]
	self.ListView_preview:removeAllItems()
	self.ListView_preview:removeAllChildren(true)
	-- if 
		
	local myrank = 0
	if _ED.team_arena_data.myTeamInfo and _ED.team_arena_data.myTeamInfo.ranking then
		myrank = tonumber(_ED.team_arena_data.myTeamInfo.ranking)
	end
	local myReworld = nil
	-- debug.print_r(re,"dms[cross_team_reward]")

	for k,v in pairs(re) do
		local ele = {}
		ele.rank = k
		local re = dms.searchs(dms["cross_team_reward"], 1, k)[1]
		ele.reward = re
		local cell = state_machine.excute("team_arena_reward_cell_create",0, ele)
		self.ListView_preview:addChild(cell)

		local rankt = zstring.split(re[2], ",")
		if myrank ~= 0 then
			if myrank >= tonumber(rankt[1]) and  myrank <= tonumber(rankt[2])  then
				myReworld = zstring.splits(re[3], "|", ",")
			end
		end
	end
	self.ListView_preview:jumpToTop()
	self.ListView_preview:refreshView()
	self.ListView_preview_poy = self.ListView_preview:getInnerContainer():getPositionY()

	if myrank ~= 0 then
		self.Text_nothing:setVisible(false)
		self.ListView_my_ranking:removeAllItems()
		self.ListView_my_ranking:removeAllChildren(true)
		if myReworld ~= nil then
			for i,v in pairs(myReworld) do
				local prop_data = v
				local cell = ResourcesIconCell:createCell()
				cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,{shipStar=prop_data[4]})
				-- cell:setScale(0.7)
				-- cell:setAnchorPoint(0,0.5)
				self.ListView_my_ranking:addChild(cell)
			end
			-- self.ListView_my_ranking:setItemsMargin(-50)
			self.ListView_my_ranking:requestRefreshView()
		end
	else 
		self.Text_nothing:setVisible(true)
	end

end

function TeamArenaReward:onEnterTransitionFinish()
	-- 加载TeamArenaRewardWindow界面资源.
	-- res.campaign.team_arena_reward = res/campaign/team_arena/team_arena_reward.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_reward.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_reward_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	
	self:onUpdateDraw()
end


-- @onUpdate(dt)
function TeamArenaReward:onUpdate(dt)
	-- if self.ListView_preview ~= nil then
	-- 	local size = self.ListView_preview:getContentSize()
	-- 	local posY = self.ListView_preview:getInnerContainer():getPositionY()
	-- 	if self.ListView_preview_poy == posY then
	-- 		return
	-- 	end
	-- 	self.ListView_preview_poy = posY
	-- 	local items = self.ListView_preview:getItems()
	-- 	if items[1] == nil then
	-- 		return
	-- 	end
	-- 	local itemSize = items[1]:getContentSize()
	-- 	for i, v in pairs(items) do
	-- 		local tempY = v:getPositionY() + posY
	-- 		if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
	-- 				v:unload()		
	-- 		else	
	-- 				v:reload()				
	-- 		end
	-- 	end
	-- end
end

function TeamArenaReward:onExit()
	-- 释放TeamArenaRewardWindow界面资源.
	state_machine.remove("team_arena_reward_open")
	state_machine.remove("team_arena_reward_close")
	state_machine.remove("team_arena_reward_show")
	state_machine.remove("team_arena_reward_hide")
end

function TeamArenaReward:close()
	-- window event : close.
	
end

function TeamArenaReward:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
