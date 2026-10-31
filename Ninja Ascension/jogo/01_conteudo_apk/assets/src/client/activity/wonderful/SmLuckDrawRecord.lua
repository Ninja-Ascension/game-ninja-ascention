--[[ ----------------------------------------------------------------------------
-- 获奖记录弹窗
--]] ----------------------------------------------------------------------------
SmLuckDrawRecord = class("SmLuckDrawRecordClass", Window)

-- 打开窗口
local sm_luck_draw_record_window_open_terminal = {
	_name = "sm_luck_draw_record_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmLuckDrawRecordClass") then
			fwin:open(SmLuckDrawRecord:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_luck_draw_record_window_close_terminal = {
	_name = "sm_luck_draw_record_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmLuckDrawRecordClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_luck_draw_record_window_open_terminal)
state_machine.add(sm_luck_draw_record_window_close_terminal)
state_machine.init()

-- 构造器
function SmLuckDrawRecord:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
    app.load("client.activity.wonderful.smluckdrawrecordlist")

	-- Initialize sm luck draw record page state machine.
	local function init_sm_luck_draw_record_terminal()
		-- 打开角色创建窗口
		local sm_luck_draw_record_open_terminal = {
			_name = "sm_luck_draw_record_open",
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
		local sm_luck_draw_record_close_terminal = {
			_name = "sm_luck_draw_record_close",
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
		local sm_luck_draw_record_show_terminal = {
			_name = "sm_luck_draw_record_show",
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
		local sm_luck_draw_record_hide_terminal = {
			_name = "sm_luck_draw_record_hide",
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

		state_machine.add(sm_luck_draw_record_open_terminal)
		state_machine.add(sm_luck_draw_record_close_terminal)
		state_machine.add(sm_luck_draw_record_show_terminal)
		state_machine.add(sm_luck_draw_record_hide_terminal)
		state_machine.init()
	end
	-- call func init sm luck draw record state machine.
	init_sm_luck_draw_record_terminal()
end

-- 对象初始化
function SmLuckDrawRecord:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SmLuckDrawRecord:onUpdateDraw()
	local root = self.roots[1]

	-- 获奖记录列表
	self.ListView_rank_list = ccui.Helper:seekWidgetByName(root, "ListView_rank_list")

	-- 当没有记录时显示
	self.Text_no_play = ccui.Helper:seekWidgetByName(root, "Text_no_play")
end


function SmLuckDrawRecord:onEnterTransitionFinish()
	-- 加载SmLuckDrawRecordWindow界面资源.
	-- res.activity.wonderful.sm_luck_draw_record = res/activity/wonderful/sm_luck_draw_record.csb
	local csbNode = csb.createNode("activity/wonderful/sm_luck_draw_record.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "sm_luck_draw_record_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:initData()
	self:onUpdateDraw()
end


function SmLuckDrawRecord:onExit()
	-- 释放SmLuckDrawRecordWindow界面资源.
	state_machine.remove("sm_luck_draw_record_open")
	state_machine.remove("sm_luck_draw_record_close")
	state_machine.remove("sm_luck_draw_record_show")
	state_machine.remove("sm_luck_draw_record_hide")
end

-- 更新界面信息 
function SmLuckDrawRecord:onUpdateDrawInfo()
	local root = self.roots[1]

	if _ED.active_activity[162].pullRecord ~= nil and #_ED.active_activity[162].pullRecord > 0 then
		self.ListView_rank_list:setVisible(true)
		self.Text_no_play:setVisible(false)
	else
		self.ListView_rank_list:setVisible(false)
		self.Text_no_play:setVisible(true)
	end

	for i,v in pairs(_ED.active_activity[162].pullRecord) do
		local data = {}
		data.rank = i
		data.record = v
		local cell= state_machine.excute("sm_luck_draw_record_list_create", 0, data)
		self.ListView_rank_list:addChild(cell)
	end

	self.ListView_rank_list:refreshView()
	self.ListView_rank_list_poy = self.ListView_rank_list:getInnerContainer():getPositionY()
	self.ListView_rank_list:jumpToTop()
end

function SmLuckDrawRecord:initData()
	local function responseChanllengeCallback(response)
		if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
			return
		end
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			response.node:onUpdateDrawInfo()
		else
		end
	end
	NetworkManager:register(protocol_command.get_lucky_pull_rod_lottery_record.code, nil, nil, nil, self, responseChanllengeCallback, false, nil)
end

-- @onUpdate(dt)
function SmLuckDrawRecord:onUpdate(dt)
	
	if self.ListView_rank_list ~= nil then
		local size = self.ListView_rank_list:getContentSize()
		local posY = self.ListView_rank_list:getInnerContainer():getPositionY()
		if self.ListView_rank_list_poy == posY then
			return
		end
		self.ListView_rank_list_poy = posY
		local items = self.ListView_rank_list:getItems()
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

function SmLuckDrawRecord:close()
	-- window event : close.
	
end

function SmLuckDrawRecord:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
