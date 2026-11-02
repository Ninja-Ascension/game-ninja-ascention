--[[ ----------------------------------------------------------------------------
-- 幸运占卜排行榜窗口界面
--]] ----------------------------------------------------------------------------
ActivityLuckRecord = class("ActivityLuckRecordClass", Window)

-- 打开窗口
local activity_luck_record_window_open_terminal = {
	_name = "activity_luck_record_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityLuckRecordClass") then
			fwin:open(ActivityLuckRecord:new():init(params), fwin._view)
		else
			state_machine.excute("activity_luck_record_show", 0, 0)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_luck_record_window_close_terminal = {
	_name = "activity_luck_record_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityLuckRecordClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_record_window_open_terminal)
state_machine.add(activity_luck_record_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityLuckRecord:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.cells.activity.activity_luck_record_cell")

	-- Initialize activity luck rank page state machine.
	local function init_activity_luck_record_terminal()
		-- 打开角色创建窗口
		local activity_luck_record_open_terminal = {
			_name = "activity_luck_record_open",
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
		local activity_luck_record_close_terminal = {
			_name = "activity_luck_record_close",
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
		local activity_luck_record_show_terminal = {
			_name = "activity_luck_record_show",
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
		local activity_luck_record_hide_terminal = {
			_name = "activity_luck_record_hide",
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

		
		state_machine.add(activity_luck_record_open_terminal)
		state_machine.add(activity_luck_record_close_terminal)
		state_machine.add(activity_luck_record_show_terminal)
		state_machine.add(activity_luck_record_hide_terminal)
		state_machine.init()
	end
	-- call func init activity luck rank state machine.
	init_activity_luck_record_terminal()
end

-- 对象初始化
function ActivityLuckRecord:init(params)
	-- local rootWindow = params[1] 
	-- if nil ~= rootWindow then
	-- 	self._rootWindows = rootWindow
	-- end
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityLuckRecord:onUpdateDraw()
	local root = self.roots[1]

	-- 确定按键
	self.Button_luck_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_confirm"), nil,
	{
		terminal_name = "activity_luck_record_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	self.Button_luck_confirm:setTouchEnabled(true)
	-- 排行榜列表
	self.ListView_luck_rank_list = ccui.Helper:seekWidgetByName(root, "ListView_luck_rank_list")
end

function ActivityLuckRecord:onEnterTransitionFinish()
	-- 加载ActivityLuckRecordWindow界面资源.
	-- res.activity.activity_luck_record = res/activity/activity_luck_zhabbujilu.csb
	local csbNode = csb.createNode("Lucky/activity_luck_zhabbujilu.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self:onUpdateDraw()
	self:updateList()
end
-- 更新列表
function ActivityLuckRecord:updateList()
	
	self.ListView_luck_rank_list:removeAllItems()
	self.ListView_luck_rank_list:removeAllChildren(true)
	local record = _ED.active_activity[161].activity_params.divineRecord or {}
	local count = table.nums(record)
	for i, v in pairs(record) do
		local cell = state_machine.excute("activity_luck_record_cell_create",0, {i,record[count-i+1]})
		self.ListView_luck_rank_list:addChild(cell)
	end
	self.ListView_luck_rank_list:refreshView()
	self.ListView_luck_rank_list_poy = self.ListView_luck_rank_list:getInnerContainer():getPositionY()
	if self.ListView_luck_rank_list._poy==nil then
		self.ListView_luck_rank_list._poy=self.ListView_luck_rank_list_poy	
	end
	self.ListView_luck_rank_list:jumpToTop()
end
-- @onUpdate(dt)
function ActivityLuckRecord:onUpdate(dt)
	
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

function ActivityLuckRecord:onExit()
	-- 释放ActivityLuckRecordWindow界面资源.
	state_machine.remove("activity_luck_record_open")
	state_machine.remove("activity_luck_record_close")
	state_machine.remove("activity_luck_record_show")
	state_machine.remove("activity_luck_record_hide")
	
end

function ActivityLuckRecord:close()
	-- window event : close.
	
end

function ActivityLuckRecord:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
