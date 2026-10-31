--[[ ----------------------------------------------------------------------------
-- 规则界面
--]] ----------------------------------------------------------------------------
SecretTreasureRule = class("SecretTreasureRuleClass", Window)

-- 打开窗口
local secret_treasure_rule_window_open_terminal = {
	_name = "secret_treasure_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasureRuleClass") then
			fwin:open(SecretTreasureRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_rule_window_close_terminal = {
	_name = "secret_treasure_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasureRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_rule_window_open_terminal)
state_machine.add(secret_treasure_rule_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasureRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure rule page state machine.
	local function init_secret_treasure_rule_terminal()
		-- 打开角色创建窗口
		local secret_treasure_rule_open_terminal = {
			_name = "secret_treasure_rule_open",
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
		local secret_treasure_rule_close_terminal = {
			_name = "secret_treasure_rule_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_rule_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_rule_show_terminal = {
			_name = "secret_treasure_rule_show",
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
		local secret_treasure_rule_hide_terminal = {
			_name = "secret_treasure_rule_hide",
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

		state_machine.add(secret_treasure_rule_open_terminal)
		state_machine.add(secret_treasure_rule_close_terminal)
		state_machine.add(secret_treasure_rule_show_terminal)
		state_machine.add(secret_treasure_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init secret treasure rule state machine.
	init_secret_treasure_rule_terminal()
end

-- 对象初始化
function SecretTreasureRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SecretTreasureRule:onUpdateDraw()
	local root = self.roots[1]

end

function SecretTreasureRule:onEnterTransitionFinish()
	-- 加载SecretTreasureRuleWindow界面资源.
	-- res.activity.secret_treasure.secret_treasure_rule = res/activity/secret_treasure/secret_treasure_rule.csb
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "secret_treasure_rule_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SecretTreasureRule:onExit()
	-- 释放SecretTreasureRuleWindow界面资源.
	state_machine.remove("secret_treasure_rule_open")
	state_machine.remove("secret_treasure_rule_close")
	state_machine.remove("secret_treasure_rule_show")
	state_machine.remove("secret_treasure_rule_hide")
end

function SecretTreasureRule:close()
	-- window event : close.
	
end

function SecretTreasureRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
