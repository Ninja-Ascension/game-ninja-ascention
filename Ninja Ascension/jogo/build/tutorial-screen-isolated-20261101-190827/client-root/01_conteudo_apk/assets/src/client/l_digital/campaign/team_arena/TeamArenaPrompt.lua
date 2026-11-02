--[[ ----------------------------------------------------------------------------
-- 查看他人队伍信息
--]] ----------------------------------------------------------------------------
TeamArenaPrpt = class("TeamArenaPrptClass", Window)

-- 打开窗口
local team_arena_prpt_window_open_terminal = {
	_name = "team_arena_prpt_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaPrptClass") then
			fwin:open(TeamArenaPrpt:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_prpt_window_close_terminal = {
	_name = "team_arena_prpt_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaPrptClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_prpt_window_open_terminal)
state_machine.add(team_arena_prpt_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaPrpt:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena prompt page state machine.
	local function init_team_arena_prpt_terminal()
		-- 打开角色创建窗口
		local team_arena_prpt_open_terminal = {
			_name = "team_arena_prpt_open",
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
		local team_arena_prpt_close_terminal = {
			_name = "team_arena_prpt_close",
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
		local team_arena_prpt_show_terminal = {
			_name = "team_arena_prpt_show",
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
		local team_arena_prpt_hide_terminal = {
			_name = "team_arena_prpt_hide",
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

		local team_arena_prpt_ok_terminal = {
			_name = "team_arena_prpt_ok",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute(instance.data.machine,0, instance.data.data)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(team_arena_prpt_ok_terminal)

		state_machine.add(team_arena_prpt_open_terminal)
		state_machine.add(team_arena_prpt_close_terminal)
		state_machine.add(team_arena_prpt_show_terminal)
		state_machine.add(team_arena_prpt_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena prompt state machine.
	init_team_arena_prpt_terminal()
end

-- 对象初始化
function TeamArenaPrpt:init(params)
	self.data = params
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaPrpt:onUpdateDraw()
	local root = self.roots[1]

	-- "是否请离该队员",--3
	-- "是否退出该队伍",--4
	-- "是否提交队伍",--5
	-- "是否转让队伍",--6
	local type = tonumber(self.data.type)
	self.Text_141:setString(tipStringInfo_team_arena[type])

end

function TeamArenaPrpt:onEnterTransitionFinish()
	-- 加载TeamArenaPrptWindow界面资源.
	-- res.campaign.team_arena.team_arena_prpt = res/campaign/team_arena/team_arena_prpt.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_prompt.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定
	self.Button_ok = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil,
	{
		terminal_name = "team_arena_prpt_ok",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "team_arena_prpt_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Text_141 = ccui.Helper:seekWidgetByName(root, "Text_141")

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_prpt_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function TeamArenaPrpt:onExit()
	-- 释放TeamArenaPrptWindow界面资源.
	state_machine.remove("team_arena_prpt_open")
	state_machine.remove("team_arena_prpt_close")
	state_machine.remove("team_arena_prpt_show")
	state_machine.remove("team_arena_prpt_hide")
	state_machine.remove("team_arena_prpt_ok")

end

function TeamArenaPrpt:close()
	-- window event : close.
	
end

function TeamArenaPrpt:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
