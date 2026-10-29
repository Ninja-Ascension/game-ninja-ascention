--[[ ----------------------------------------------------------------------------
-- 规则
--]] ----------------------------------------------------------------------------
NewRecruitRule = class("NewRecruitRuleClass", Window)

-- 打开窗口
local new_recruit_rule_window_open_terminal = {
	_name = "new_recruit_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("NewRecruitRuleClass") then
			fwin:open(NewRecruitRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local new_recruit_rule_window_close_terminal = {
	_name = "new_recruit_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("NewRecruitRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_rule_window_open_terminal)
state_machine.add(new_recruit_rule_window_close_terminal)
state_machine.init()

-- 构造器
function NewRecruitRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize service carnival rule page state machine.
	local function init_new_recruit_rule_terminal()
		-- 打开角色创建窗口
		local new_recruit_rule_open_terminal = {
			_name = "new_recruit_rule_open",
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
		local new_recruit_rule_close_terminal = {
			_name = "new_recruit_rule_close",
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
		local new_recruit_rule_show_terminal = {
			_name = "new_recruit_rule_show",
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
		local new_recruit_rule_hide_terminal = {
			_name = "new_recruit_rule_hide",
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

		state_machine.add(new_recruit_rule_open_terminal)
		state_machine.add(new_recruit_rule_close_terminal)
		state_machine.add(new_recruit_rule_show_terminal)
		state_machine.add(new_recruit_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init service carnival rule state machine.
	init_new_recruit_rule_terminal()
end

-- 对象初始化
function NewRecruitRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function NewRecruitRule:onUpdateDraw()
	local root = self.roots[1]

end

function NewRecruitRule:onEnterTransitionFinish()
	-- 加载NewRecruitRuleWindow界面资源.
	local csbNode = csb.createNode("shop/new_recruit_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "new_recruit_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function NewRecruitRule:onExit()
	-- 释放NewRecruitRuleWindow界面资源.
	state_machine.remove("new_recruit_rule_open")
	state_machine.remove("new_recruit_rule_close")
	state_machine.remove("new_recruit_rule_show")
	state_machine.remove("new_recruit_rule_hide")
end

function NewRecruitRule:close()
	-- window event : close.
	
end

function NewRecruitRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
