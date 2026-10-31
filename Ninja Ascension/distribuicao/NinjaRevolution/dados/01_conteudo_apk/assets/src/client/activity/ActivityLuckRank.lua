--[[ ----------------------------------------------------------------------------
-- 幸运占卜排行榜窗口界面
--]] ----------------------------------------------------------------------------
ActivityLuckRank = class("ActivityLuckRankClass", Window)

-- 打开窗口
local activity_luck_rank_window_open_terminal = {
	_name = "activity_luck_rank_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityLuckRankClass") then
			fwin:open(ActivityLuckRank:new():init(params), fwin._view)
		else
			state_machine.excute("activity_luck_rank_show", 0, 0)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_luck_rank_window_close_terminal = {
	_name = "activity_luck_rank_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityLuckRankClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_rank_window_open_terminal)
state_machine.add(activity_luck_rank_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityLuckRank:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.cells.activity.activity_luck_rank_cell")

	-- Initialize activity luck rank page state machine.
	local function init_activity_luck_rank_terminal()
		-- 打开角色创建窗口
		local activity_luck_rank_open_terminal = {
			_name = "activity_luck_rank_open",
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
		local activity_luck_rank_close_terminal = {
			_name = "activity_luck_rank_close",
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
		local activity_luck_rank_show_terminal = {
			_name = "activity_luck_rank_show",
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
		local activity_luck_rank_hide_terminal = {
			_name = "activity_luck_rank_hide",
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

		
		state_machine.add(activity_luck_rank_open_terminal)
		state_machine.add(activity_luck_rank_close_terminal)
		state_machine.add(activity_luck_rank_show_terminal)
		state_machine.add(activity_luck_rank_hide_terminal)
		state_machine.init()
	end
	-- call func init activity luck rank state machine.
	init_activity_luck_rank_terminal()
end

-- 对象初始化
function ActivityLuckRank:init(params)
	-- local rootWindow = params[1] 
	-- if nil ~= rootWindow then
	-- 	self._rootWindows = rootWindow
	-- end
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityLuckRank:onUpdateDraw()
	local root = self.roots[1]

	-- 确定按键
	self.Button_luck_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_confirm"), nil,
	{
		terminal_name = "activity_luck_rank_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	self.Button_luck_confirm:setTouchEnabled(true)
	-- 排行榜列表
	self.ListView_luck_rank_list = ccui.Helper:seekWidgetByName(root, "ListView_luck_rank_list")

	-- 我的排名
	self.Text_activity_mine_ranking = ccui.Helper:seekWidgetByName(root, "Text_activity_mine_ranking")
	self.Image_mine_tips = ccui.Helper:seekWidgetByName(root, "Image_mine_tips")
	-- 获取排行榜数据
	local function responseChanllengeCallback(response)
		if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
			return
		end
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			response.node:updateList()
		else
			
		end
	end
	-- protocol_command.act_divination_ranking.param_list = {uuid=_ED.uuid,token=_ED.token,handle=protocol_command.act_divination_ranking.command}
	NetworkManager:register(protocol_command.get_lucky_divine_rank_info.code, nil, nil, nil, self, responseChanllengeCallback, false, nil)

end

function ActivityLuckRank:onEnterTransitionFinish()
	-- 加载ActivityLuckRankWindow界面资源.
	-- res.activity.activity_luck_rank = res/activity/activity_luck_rank.csb
	local csbNode = csb.createNode("Lucky/activity_luck_rank.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self.rankAward = {}

	for i, v in pairs(_ED.active_activity[161].activity_Info) do
		local exchangeInfos = zstring.split(v.activityInfo_need_day, "@")
		local item = dms.searchs(dms["activity_lucky_divine_reward"], 1,exchangeInfos[1],2,2)
		if item ~= nil then
			item[6] = v.activityInfo_reward_select
			table.insert(self.rankAward,item)
		end
	end
	self:onUpdateDraw()
end
-- 更新列表
function ActivityLuckRank:updateList()
	
	self.ListView_luck_rank_list:removeAllItems()
	self.ListView_luck_rank_list:removeAllChildren(true)
	local myrank = nil
	for i=1,50,1 do
		local v = {}
		v.rank = i
		for k, j in pairs(self.rankAward) do
			if i <= tonumber(j[1][4]) then
				v.reward = j[6]
				break
			end
		end
		v.rankInfo = _ED.divineRankingInfo[i]
		local cell = state_machine.excute("activity_luck_rank_cell_create",0, v)
		self.ListView_luck_rank_list:addChild(cell)
		if v.rankInfo~=nil and (tonumber(v.rankInfo.userId) == tonumber(_ED.user_info.user_id)) then
			myrank = i
		end
	end
	self.ListView_luck_rank_list:refreshView()
	self.ListView_luck_rank_list_poy = self.ListView_luck_rank_list:getInnerContainer():getPositionY()
	self.ListView_luck_rank_list:jumpToTop()
	if myrank~=nil then
		self.Text_activity_mine_ranking:setString(myrank)
	else
		-- self.Text_activity_mine_ranking:setString("未上榜")
	end
	if table.nums(_ED.divineRankingInfo) > 0  then
		self.Image_mine_tips:setVisible(false)
	else
		self.Image_mine_tips:setVisible(true)
	end
end
-- @onUpdate(dt)
function ActivityLuckRank:onUpdate(dt)
	
	if self.ListView_luck_rank_list ~= nil then
		local size = self.ListView_luck_rank_list:getContentSize()
		local posY = self.ListView_luck_rank_list:getInnerContainer():getPositionY()
		if self.ListView_luck_rank_list_poy == posY then
			return
		end
		self.ListView_luck_rank_list_poy = posY
		local items = self.ListView_luck_rank_list:getItems()
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

function ActivityLuckRank:onExit()
	-- 释放ActivityLuckRankWindow界面资源.
	state_machine.remove("activity_luck_rank_open")
	state_machine.remove("activity_luck_rank_close")
	state_machine.remove("activity_luck_rank_show")
	state_machine.remove("activity_luck_rank_hide")
	
end

function ActivityLuckRank:close()
	-- window event : close.
	
end

function ActivityLuckRank:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
