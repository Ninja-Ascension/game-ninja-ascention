--[[ ----------------------------------------------------------------------------
-- 查看他人信息
--]] ----------------------------------------------------------------------------
TeamArenaRule = class("TeamArenaRuleClass", Window)

-- 打开窗口
local team_arena_rule_window_open_terminal = {
	_name = "team_arena_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaRuleClass") then
			fwin:open(TeamArenaRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_rule_window_close_terminal = {
	_name = "team_arena_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_rule_window_open_terminal)
state_machine.add(team_arena_rule_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena enemy1 page state machine.
	local function init_team_arena_rule_terminal()
		-- 打开角色创建窗口
		local team_arena_rule_open_terminal = {
			_name = "team_arena_rule_open",
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
		local team_arena_rule_close_terminal = {
			_name = "team_arena_rule_close",
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
		local team_arena_rule_show_terminal = {
			_name = "team_arena_rule_show",
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
		local team_arena_rule_hide_terminal = {
			_name = "team_arena_rule_hide",
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

		state_machine.add(team_arena_rule_open_terminal)
		state_machine.add(team_arena_rule_close_terminal)
		state_machine.add(team_arena_rule_show_terminal)
		state_machine.add(team_arena_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena enemy1 state machine.
	init_team_arena_rule_terminal()
end

-- 对象初始化
function TeamArenaRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaRule:onUpdateDraw()
	local root = self.roots[1]

end

function TeamArenaRule:onEnterTransitionFinish()
	-- 加载TeamArenaRuleWindow界面资源.
	-- res.campaign.team_arena.team_arena_enemy_1 = res/campaign/team_arena/team_arena_enemy_1.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function TeamArenaRule:onExit()
	-- 释放TeamArenaRuleWindow界面资源.
	state_machine.remove("team_arena_rule_open")
	state_machine.remove("team_arena_rule_close")
	state_machine.remove("team_arena_rule_show")
	state_machine.remove("team_arena_rule_hide")
end

function TeamArenaRule:close()
	-- window event : close.
	
end

function TeamArenaRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
