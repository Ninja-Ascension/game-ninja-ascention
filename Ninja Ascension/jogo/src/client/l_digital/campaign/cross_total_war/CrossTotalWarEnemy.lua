--[[ ----------------------------------------------------------------------------
-- 玩家信息界面
--]] ----------------------------------------------------------------------------
CrossTotalWarEnemy = class("CrossTotalWarEnemyClass", Window)

-- 打开窗口
local cross_total_war_enemy_window_open_terminal = {
	_name = "cross_total_war_enemy_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarEnemyClass") then
			fwin:open(CrossTotalWarEnemy:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_enemy_window_close_terminal = {
	_name = "cross_total_war_enemy_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarEnemyClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_enemy_window_open_terminal)
state_machine.add(cross_total_war_enemy_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarEnemy:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cross total war enemy page state machine.
	local function init_cross_total_war_enemy_terminal()
		-- 打开角色创建窗口
		local cross_total_war_enemy_open_terminal = {
			_name = "cross_total_war_enemy_open",
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
		local cross_total_war_enemy_close_terminal = {
			_name = "cross_total_war_enemy_close",
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
		local cross_total_war_enemy_show_terminal = {
			_name = "cross_total_war_enemy_show",
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
		local cross_total_war_enemy_hide_terminal = {
			_name = "cross_total_war_enemy_hide",
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

		state_machine.add(cross_total_war_enemy_open_terminal)
		state_machine.add(cross_total_war_enemy_close_terminal)
		state_machine.add(cross_total_war_enemy_show_terminal)
		state_machine.add(cross_total_war_enemy_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war enemy state machine.
	init_cross_total_war_enemy_terminal()
end

-- 对象初始化
function CrossTotalWarEnemy:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CrossTotalWarEnemy:onUpdateDraw()
	local root = self.roots[1]

	-- 玩家名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 玩家公会名
	self.Text_guild_n = ccui.Helper:seekWidgetByName(root, "Text_guild_n")

	-- 玩家服务器
	self.Text_server_n = ccui.Helper:seekWidgetByName(root, "Text_server_n")

	-- 战斗力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")

	-- 玩家1队角色1
	self.Panel_player_icon_1_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_1")

	-- 玩家1队角色2
	self.Panel_player_icon_1_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_2")

	-- 玩家1队角色3
	self.Panel_player_icon_1_3 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_3")

	-- 玩家1队角色4
	self.Panel_player_icon_1_4 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_4")

	-- 玩家1队角色5
	self.Panel_player_icon_1_5 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_5")

	-- 玩家1队角色6
	self.Panel_player_icon_1_6 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_6")

	-- 玩家2队角色1
	self.Panel_player_icon_2_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2_1")

	-- 玩家2队角色2
	self.Panel_player_icon_2_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2_2")

	-- 玩家2队角色3
	self.Panel_player_icon_2_3 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2_3")

	-- 玩家2队角色4
	self.Panel_player_icon_2_4 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2_4")

	-- 玩家2队角色5
	self.Panel_player_icon_2_5 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2_5")

	-- 玩家2队角色6
	self.Panel_player_icon_2_6 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2_6")

	-- 玩家3队角色1（默认问号）
	self.Panel_player_icon_3_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3_1")

	-- 玩家3队角色2（默认问号）
	self.Panel_player_icon_3_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3_2")

	-- 玩家3队角色3（默认问号）
	self.Panel_player_icon_3_3 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3_3")

	-- 玩家3队角色4（默认问号）
	self.Panel_player_icon_3_4 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3_4")

	-- 玩家3队角色5（默认问号）
	self.Panel_player_icon_3_5 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3_5")

	-- 玩家3队角色6（默认问号）
	self.Panel_player_icon_3_6 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3_6")

end

function CrossTotalWarEnemy:onEnterTransitionFinish()
	-- 加载CrossTotalWarEnemyWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_enemy = res/campaign/cross_total_war/cross_total_war_enemy.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_enemy.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "cross_total_war_enemy_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CrossTotalWarEnemy:onExit()
	-- 释放CrossTotalWarEnemyWindow界面资源.
	state_machine.remove("cross_total_war_enemy_open")
	state_machine.remove("cross_total_war_enemy_close")
	state_machine.remove("cross_total_war_enemy_show")
	state_machine.remove("cross_total_war_enemy_hide")
end

function CrossTotalWarEnemy:close()
	-- window event : close.
	
end

function CrossTotalWarEnemy:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
