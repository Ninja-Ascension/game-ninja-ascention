--[[ ----------------------------------------------------------------------------
-- 捐赠记录窗口
--]] ----------------------------------------------------------------------------
LegionAssistanceRecord = class("LegionAssistanceRecordClass", Window)

-- 打开窗口
local legion_assistance_record_window_open_terminal = {
	_name = "legion_assistance_record_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LegionAssistanceRecordClass") then
			fwin:open(LegionAssistanceRecord:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local legion_assistance_record_window_close_terminal = {
	_name = "legion_assistance_record_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LegionAssistanceRecordClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_assistance_record_window_open_terminal)
state_machine.add(legion_assistance_record_window_close_terminal)
state_machine.init()

-- 构造器
function LegionAssistanceRecord:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.union.legionAssistance.LegionAssistanceRecordList")

	-- Initialize legion assistance record page state machine.
	local function init_legion_assistance_record_terminal()
		-- 打开角色创建窗口
		local legion_assistance_record_open_terminal = {
			_name = "legion_assistance_record_open",
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
		local legion_assistance_record_close_terminal = {
			_name = "legion_assistance_record_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("legion_assistance_record_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local legion_assistance_record_show_terminal = {
			_name = "legion_assistance_record_show",
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
		local legion_assistance_record_hide_terminal = {
			_name = "legion_assistance_record_hide",
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

		-- 查看记录
		local legion_assistance_record_draw_terminal = {
			_name = "legion_assistance_record_draw",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local tabType = params._datas._tabType

				-- DSC重塑
				if __lua_project_id == __lua_project_l_digital then
					instance:controlButtonState(tabType == 0)
				else
					instance.Button_all:setBright(tabType ~= 0)
					instance.Button_mine:setBright(tabType ~= 1)
				end

				instance:updateRecordList(tabType)

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(legion_assistance_record_open_terminal)
		state_machine.add(legion_assistance_record_close_terminal)
		state_machine.add(legion_assistance_record_show_terminal)
		state_machine.add(legion_assistance_record_hide_terminal)

		state_machine.add(legion_assistance_record_draw_terminal)

		state_machine.init()
	end
	-- call func init legion assistance record state machine.
	init_legion_assistance_record_terminal()
end

-- 对象初始化
function LegionAssistanceRecord:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function LegionAssistanceRecord:onInit()
	self:refreshRecordInfo()
end

-- 捐赠记录信息
function LegionAssistanceRecord:refreshRecordInfo()
	-- {
	-- 	"totalRecord": [{
	-- 		"time": 123456789101,
	-- 		"donor": "哈哈哈",
	-- 		"beneficiary": "呵呵呵",
	-- 		"propId": 1234
	-- 	}],
	-- 	"myRecord": [{
	-- 		"time": 123456789101,
	-- 		"donor": "哈哈哈",
	-- 		"beneficiary": "呵呵呵",
	-- 		"propId": 1234
	-- 	}]
	-- }

	local info = _ED.union.union_assistance_record_info
	self.totalRecord = info.totalRecord
	self.myRecord = info.myRecord
end

function LegionAssistanceRecord:getRecordList(tabType)
	local recordTempList = (tabType == 0) and self.totalRecord or self.myRecord
	local recordList = {}
	for _, v in pairs(recordTempList) do
		table.insert(recordList, v)
	end

	table.sort(recordList, function(a, b)
		local timeA = tonumber(a.time)
		local timeB = tonumber(b.time)
		return timeA > timeB
	end)

	return recordList
end

-- 0 所有 1 我的
function LegionAssistanceRecord:updateRecordList(tabType)
	self.ListView_record_list:removeAllItems()

	local askList = self:getRecordList(tabType)
	for i, v in ipairs(askList) do
	-- for i = 1, 10 do
		-- local v = {
		-- 	time = 1577691782000,
		-- 	donor = "哈哈哈",
		-- 	beneficiary = "呵呵呵",
		-- 	propId = 1
		-- }
		local cell = state_machine.excute("legion_assistance_record_list_create", 0, {index = i, data = v})
		self.ListView_record_list:addChild(cell)
	end
	self.ListView_record_list_poy = self.ListView_record_list:getInnerContainer():getPositionY()
	self.ListView_record_list:jumpToTop()
	self.ListView_record_list:requestRefreshView()
end

function LegionAssistanceRecord:controlButtonState(buttonAllPressState)
	self.Button_all:setHighlighted(buttonAllPressState)
	self.Text_all_1:setVisible(not buttonAllPressState)
	self.Text_all_2:setVisible(buttonAllPressState)

	self.Button_mine:setHighlighted(not buttonAllPressState)
	self.Text_mine_1:setVisible(buttonAllPressState)
	self.Text_mine_2:setVisible(not buttonAllPressState)
end

function LegionAssistanceRecord:onUpdateDraw()
	local root = self.roots[1]

	-- 记录显示列表
	self.ListView_record_list = ccui.Helper:seekWidgetByName(root, "ListView_record_list")

	-- 无记录提示（默认隐藏）
	self.Text_nothing = ccui.Helper:seekWidgetByName(root, "Text_nothing")

	-- 显示禁用状态的button图片
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		-- 所有记录
		self.Text_mine_1 = ccui.Helper:seekWidgetByName(root, "Text_mine_1")
		self.Text_mine_2 = ccui.Helper:seekWidgetByName(root, "Text_mine_2")

		-- 我的记录
		self.Text_all_1 = ccui.Helper:seekWidgetByName(root, "Text_all_1")
		self.Text_all_2 = ccui.Helper:seekWidgetByName(root, "Text_all_2")

		self:controlButtonState(true)
	else
		self.Button_all:setBright(false)
	end

	self:updateRecordList(0)
end

function LegionAssistanceRecord:onEnterTransitionFinish()
	-- 加载LegionAssistanceRecordWindow界面资源.
	-- res.legion.legion_assistance_record = res/legion/legion_assistance_record.csb
	local csbNode = csb.createNode("legion/legion_assistance_record.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 我的记录按钮
	self.Button_mine = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mine"), nil,
	{
		terminal_name = "legion_assistance_record_draw",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_tabType = 1,
	}, nil, 0)	

	-- 所有记录按钮
	self.Button_all = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all"), nil,
	{
		terminal_name = "legion_assistance_record_draw",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_tabType = 0,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "legion_assistance_record_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

-- @onUpdate(dt)
function LegionAssistanceRecord:onUpdate(dt)
	if self.ListView_record_list ~= nil then
		local size = self.ListView_record_list:getContentSize()
		local posY = self.ListView_record_list:getInnerContainer():getPositionY()
		if self.ListView_record_list_poy == posY then
			return
		end
		self.ListView_record_list_poy = posY
		local items = self.ListView_record_list:getItems()
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

function LegionAssistanceRecord:onExit()
	-- 释放LegionAssistanceRecordWindow界面资源.
	state_machine.remove("legion_assistance_record_open")
	state_machine.remove("legion_assistance_record_close")
	state_machine.remove("legion_assistance_record_show")
	state_machine.remove("legion_assistance_record_hide")

	state_machine.remove("legion_assistance_record_draw")
end

function LegionAssistanceRecord:close()
	-- window event : close.
	
end

function LegionAssistanceRecord:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
