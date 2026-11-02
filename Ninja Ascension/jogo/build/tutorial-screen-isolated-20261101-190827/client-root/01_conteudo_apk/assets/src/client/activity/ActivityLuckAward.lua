--[[ ----------------------------------------------------------------------------
-- 幸运占卜活动界面
--]] ----------------------------------------------------------------------------
ActivityLuckAward = class("ActivityLuckAwardClass", Window)

-- 打开窗口
local activity_luck_award_window_open_terminal = {
	_name = "activity_luck_award_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityLuckAwardClass") then
			fwin:open(ActivityLuckAward:new():init(params), fwin._view)
		else
			state_machine.excute("activity_luck_award_show", 0, params)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_luck_award_window_close_terminal = {
	_name = "activity_luck_award_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityLuckAwardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_award_window_open_terminal)
state_machine.add(activity_luck_award_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityLuckAward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.type = 1 
	-- load lua files.
	app.load("client.cells.activity.activity_luck_award_cell")

	-- Initialize activity luck award page state machine.
	local function init_activity_luck_award_terminal()
		-- 打开角色创建窗口
		local activity_luck_award_open_terminal = {
			_name = "activity_luck_award_open",
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
		local activity_luck_award_close_terminal = {
			_name = "activity_luck_award_close",
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
		local activity_luck_award_show_terminal = {
			_name = "activity_luck_award_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
					instance.type = params[2]
					instance:updateList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local activity_luck_award_hide_terminal = {
			_name = "activity_luck_award_hide",
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

		state_machine.add(activity_luck_award_open_terminal)
		state_machine.add(activity_luck_award_close_terminal)
		state_machine.add(activity_luck_award_show_terminal)
		state_machine.add(activity_luck_award_hide_terminal)
		state_machine.init()
	end
	-- call func init activity luck award state machine.
	init_activity_luck_award_terminal()
end

-- 对象初始化
function ActivityLuckAward:init(params)
	local rootWindow = params[1] 
	self.type = params[2]
	if nil ~= rootWindow then
		self._rootWindows = rootWindow
	end
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityLuckAward:onUpdateDraw()
	local root = self.roots[1]

	-- 奖励列表
	self.ListView_luck_list = ccui.Helper:seekWidgetByName(root, "ListView_luck_list")

	self:updateList()
end


function ActivityLuckAward:updateList()
	self.ListView_luck_list:removeAllItems()
	if self.type == 1 then
		local key_test = {}
		for i, v in pairs(_ED.active_activity[161].activity_Info) do
			local exchangeInfos = zstring.split(v.activityInfo_need_day, "@")
			local item = dms.searchs(dms["activity_lucky_divine_reward"], 1,exchangeInfos[1],2,1)
			if item ~= nil then
				item[6] = v.activityInfo_reward_select
				table.insert(key_test,item)
			end
		end
		local total = table.nums(key_test)
		for i, v in pairs(key_test) do
			local cell = state_machine.excute("activity_luck_award_cell_create",0, {type=self.type,num=total,data=v})
			self.ListView_luck_list:addChild(cell)
		end
	else
		local key_test = {}
		for i, v in pairs(_ED.active_activity[161].activity_Info) do
			local exchangeInfos = zstring.split(v.activityInfo_need_day, "@")
			local item = dms.searchs(dms["activity_lucky_divine_reward"], 1,exchangeInfos[1],2,2)
			if item ~= nil then
				item[6] = v.activityInfo_reward_select
				table.insert(key_test,item)
			end
		end
		local total = table.nums(key_test)
		for i, v in pairs(key_test) do
			local cell = state_machine.excute("activity_luck_award_cell_create",0, {type=self.type,num=i,data=v})
			self.ListView_luck_list:addChild(cell)
		end
	end
	self.ListView_luck_list:refreshView()
	self.ListView_luck_list_poy = self.ListView_luck_list:getInnerContainer():getPositionY()
	self.ListView_luck_list:jumpToTop()
end

function ActivityLuckAward:onEnterTransitionFinish()
	-- 加载ActivityLuckAwardWindow界面资源.
	-- res.activity.activity_luck_award = res/activity/activity_luck_award.csb
	local csbNode = csb.createNode("Lucky/activity_luck_award.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self:onUpdateDraw()
	
end

-- @onUpdate(dt)
function ActivityLuckAward:onUpdate(dt)
	-- if self.ListView_luck_list ~= nil then
	-- 	local size = self.ListView_luck_list:getContentSize()
	-- 	local posY = self.ListView_luck_list:getInnerContainer():getPositionY()
	-- 	if self.ListView_luck_list_poy == posY then
	-- 		return
	-- 	end
	-- 	self.ListView_luck_list_poy = posY
	-- 	local items = self.ListView_luck_list:getItems()
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

function ActivityLuckAward:onExit()
	-- 释放ActivityLuckAwardWindow界面资源.
	state_machine.remove("activity_luck_award_open")
	state_machine.remove("activity_luck_award_close")
	state_machine.remove("activity_luck_award_show")
	state_machine.remove("activity_luck_award_hide")
end

function ActivityLuckAward:close()
	-- window event : close.
	
end

function ActivityLuckAward:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
