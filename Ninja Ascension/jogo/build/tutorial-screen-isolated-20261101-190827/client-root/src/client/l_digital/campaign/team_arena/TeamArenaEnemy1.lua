--[[ ----------------------------------------------------------------------------
-- 查看他人信息
--]] ----------------------------------------------------------------------------
TeamArenaEnemy1 = class("TeamArenaEnemy1Class", Window)

-- 打开窗口
local team_arena_enemy1_window_open_terminal = {
	_name = "team_arena_enemy1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaEnemy1Class") then
			fwin:open(TeamArenaEnemy1:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_enemy1_window_close_terminal = {
	_name = "team_arena_enemy1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaEnemy1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_enemy1_window_open_terminal)
state_machine.add(team_arena_enemy1_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaEnemy1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena enemy1 page state machine.
	local function init_team_arena_enemy1_terminal()
		-- 打开角色创建窗口
		local team_arena_enemy1_open_terminal = {
			_name = "team_arena_enemy1_open",
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
		local team_arena_enemy1_close_terminal = {
			_name = "team_arena_enemy1_close",
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
		local team_arena_enemy1_show_terminal = {
			_name = "team_arena_enemy1_show",
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
		local team_arena_enemy1_hide_terminal = {
			_name = "team_arena_enemy1_hide",
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

		state_machine.add(team_arena_enemy1_open_terminal)
		state_machine.add(team_arena_enemy1_close_terminal)
		state_machine.add(team_arena_enemy1_show_terminal)
		state_machine.add(team_arena_enemy1_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena enemy1 state machine.
	init_team_arena_enemy1_terminal()
end

-- 对象初始化
function TeamArenaEnemy1:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaEnemy1:onUpdateDraw()
	local root = self.roots[1]

	-- 玩家名称
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 玩家组织
	self.Text_guild_n = ccui.Helper:seekWidgetByName(root, "Text_guild_n")

	-- 玩家战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")

	-- 服务器
	self.Text_server_n = ccui.Helper:seekWidgetByName(root, "Text_server_n")

	-- 玩家头像
	self.Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")

	-- 玩家角色1
	self.Panel_player_icon_1_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_1")

	-- 玩家角色2
	self.Panel_player_icon_1_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_2")

	-- 玩家角色3
	self.Panel_player_icon_1_3 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_3")

	-- 玩家角色4
	self.Panel_player_icon_1_4 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_4")

	-- 玩家角色5
	self.Panel_player_icon_1_5 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_5")

	-- 玩家角色6
	self.Panel_player_icon_1_6 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_6")

end

function TeamArenaEnemy1:onEnterTransitionFinish()
	-- 加载TeamArenaEnemy1Window界面资源.
	-- res.campaign.team_arena.team_arena_enemy_1 = res/campaign/team_arena/team_arena_enemy_1.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_enemy_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_enemy1_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function TeamArenaEnemy1:onExit()
	-- 释放TeamArenaEnemy1Window界面资源.
	state_machine.remove("team_arena_enemy1_open")
	state_machine.remove("team_arena_enemy1_close")
	state_machine.remove("team_arena_enemy1_show")
	state_machine.remove("team_arena_enemy1_hide")
end

function TeamArenaEnemy1:close()
	-- window event : close.
	
end

function TeamArenaEnemy1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
