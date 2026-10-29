--[[ ----------------------------------------------------------------------------
-- 卡册规则界面
--]] ----------------------------------------------------------------------------
IllustrationRule = class("IllustrationRuleClass", Window)

-- 打开窗口
local illustration_rule_window_open_terminal = {
	_name = "illustration_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationRuleClass") then
			fwin:open(IllustrationRule:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_rule_window_close_terminal = {
	_name = "illustration_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_rule_window_open_terminal)
state_machine.add(illustration_rule_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize illustration rule page state machine.
	local function init_illustration_rule_terminal()
		-- 打开角色创建窗口
		local illustration_rule_open_terminal = {
			_name = "illustration_rule_open",
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
		local illustration_rule_close_terminal = {
			_name = "illustration_rule_close",
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
		local illustration_rule_show_terminal = {
			_name = "illustration_rule_show",
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
		local illustration_rule_hide_terminal = {
			_name = "illustration_rule_hide",
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

		state_machine.add(illustration_rule_open_terminal)
		state_machine.add(illustration_rule_close_terminal)
		state_machine.add(illustration_rule_show_terminal)
		state_machine.add(illustration_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init illustration rule state machine.
	init_illustration_rule_terminal()
end

-- 对象初始化
function IllustrationRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationRule:onUpdateDraw()
	local root = self.roots[1]

	-- 规则滚动框
	self.ScrollView_rule_t = ccui.Helper:seekWidgetByName(root, "ScrollView_rule_t")

end

function IllustrationRule:onEnterTransitionFinish()
	-- 加载IllustrationRuleWindow界面资源.
	-- res.cultivate.illustration.illustration_rule = res/cultivate/illustration/illustration_rule.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "illustration_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function IllustrationRule:onExit()
	-- 释放IllustrationRuleWindow界面资源.
	state_machine.remove("illustration_rule_open")
	state_machine.remove("illustration_rule_close")
	state_machine.remove("illustration_rule_show")
	state_machine.remove("illustration_rule_hide")
end

function IllustrationRule:close()
	-- window event : close.
	
end

function IllustrationRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
