--[[ ----------------------------------------------------------------------------
-- 获奖记录窗口
--]] ----------------------------------------------------------------------------
LimPoolRecord = class("LimPoolRecordClass", Window)

-- 打开窗口
local lim_pool_record_window_open_terminal = {
	_name = "lim_pool_record_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LimPoolRecordClass") then
			fwin:open(LimPoolRecord:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local lim_pool_record_window_close_terminal = {
	_name = "lim_pool_record_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LimPoolRecordClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_record_window_open_terminal)
state_machine.add(lim_pool_record_window_close_terminal)
state_machine.init()

-- 构造器
function LimPoolRecord:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._noticeInfo = nil
	self._activityType = 0					-- 当前活动类型

	-- load lua files.
	app.load("client.activity.lim_pool.limpoolrecordlist")

	-- Initialize lim pool record page state machine.
	local function init_lim_pool_record_terminal()
		-- 打开角色创建窗口
		local lim_pool_record_open_terminal = {
			_name = "lim_pool_record_open",
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
		local lim_pool_record_close_terminal = {
			_name = "lim_pool_record_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_record_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local lim_pool_record_show_terminal = {
			_name = "lim_pool_record_show",
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
		local lim_pool_record_hide_terminal = {
			_name = "lim_pool_record_hide",
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

		state_machine.add(lim_pool_record_open_terminal)
		state_machine.add(lim_pool_record_close_terminal)
		state_machine.add(lim_pool_record_show_terminal)
		state_machine.add(lim_pool_record_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool record state machine.
	init_lim_pool_record_terminal()
end

-- 对象初始化
function LimPoolRecord:init(params)
	self._activityType = params
	self._noticeInfo = _ED.active_activity[self._activityType].noticeInfo or {}
	return self
end

function LimPoolRecord:getSortRecordList()
	local noticeInfo = self._noticeInfo
	local sortNoticeInfo = {}
	for _, v in pairs(noticeInfo) do
		table.insert(sortNoticeInfo, v)
	end

	table.sort(sortNoticeInfo, function(a, b)
		return tonumber(a.updateTime) > tonumber(b.updateTime)
	end)

	return sortNoticeInfo
end

function LimPoolRecord:updateRecordList()
	local ListView_record = self.ListView_record
	ListView_record:removeAllItems()

	self.Text_nothing:setVisible(false)

	local news = self:getSortRecordList()
	if news == nil or #news == 0 then
		self.Text_nothing:setVisible(true)
	else
		for _, v in ipairs(news) do
			local cell = state_machine.excute("lim_pool_record_list_create", 0, v)
			ListView_record:addChild(cell)
		end
		ListView_record:jumpToTop()
		ListView_record:requestRefreshView()
	end
end

function LimPoolRecord:onUpdateDraw()
	local root = self.roots[1]

	-- 记录显示列表
	self.ListView_record = ccui.Helper:seekWidgetByName(root, "ListView_record")

	-- 无记录提示（默认隐藏）
	self.Text_nothing = ccui.Helper:seekWidgetByName(root, "Text_nothing")

	self:updateRecordList()
end

function LimPoolRecord:onEnterTransitionFinish()
	-- 加载LimPoolRecordWindow界面资源.
	-- res.activity.lim_pool.lim_pool_record = res/activity/lim_pool/lim_pool_record.csb
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_record.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "lim_pool_record_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function LimPoolRecord:onExit()
	-- 释放LimPoolRecordWindow界面资源.
	state_machine.remove("lim_pool_record_open")
	state_machine.remove("lim_pool_record_close")
	state_machine.remove("lim_pool_record_show")
	state_machine.remove("lim_pool_record_hide")
end

function LimPoolRecord:close()
	-- window event : close.
	
end

function LimPoolRecord:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
