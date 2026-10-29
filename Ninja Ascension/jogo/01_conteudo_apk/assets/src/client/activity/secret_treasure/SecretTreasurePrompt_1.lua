--[[ ----------------------------------------------------------------------------
-- 道具购买跳转界面
--]] ----------------------------------------------------------------------------
SecretTreasurePrompt_1 = class("SecretTreasurePrompt_1Class", Window)

-- 打开窗口
local secret_treasure_prompt_1_window_open_terminal = {
	_name = "secret_treasure_prompt_1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasurePrompt_1Class") then
			fwin:open(SecretTreasurePrompt_1:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_prompt_1_window_close_terminal = {
	_name = "secret_treasure_prompt_1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasurePrompt_1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_prompt_1_window_open_terminal)
state_machine.add(secret_treasure_prompt_1_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasurePrompt_1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure rule page state machine.
	local function init_secret_treasure_prompt_1_terminal()
		-- 打开角色创建窗口
		local secret_treasure_prompt_1_open_terminal = {
			_name = "secret_treasure_prompt_1_open",
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
		local secret_treasure_prompt_1_close_terminal = {
			_name = "secret_treasure_prompt_1_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_prompt_1_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_prompt_1_show_terminal = {
			_name = "secret_treasure_prompt_1_show",
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
		local secret_treasure_prompt_1_hide_terminal = {
			_name = "secret_treasure_prompt_1_hide",
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

		-- 
		local secret_treasure_prompt_1_jump_terminal = {
			_name = "secret_treasure_prompt_1_jump",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("secret_treasure_task_window_open", 0, nil)
					state_machine.excute("secret_treasure_prompt_1_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(secret_treasure_prompt_1_open_terminal)
		state_machine.add(secret_treasure_prompt_1_close_terminal)
		state_machine.add(secret_treasure_prompt_1_show_terminal)
		state_machine.add(secret_treasure_prompt_1_hide_terminal)
		state_machine.add(secret_treasure_prompt_1_jump_terminal)
		state_machine.init()
	end
	-- call func init secret treasure rule state machine.
	init_secret_treasure_prompt_1_terminal()
end

-- 对象初始化
function SecretTreasurePrompt_1:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SecretTreasurePrompt_1:onUpdateDraw()
	local root = self.roots[1]

end

function SecretTreasurePrompt_1:onEnterTransitionFinish()
	-- 加载SecretTreasurePrompt_1Window界面资源.
	-- res.activity.secret_treasure.secret_treasure_prompt_1 = res/activity/secret_treasure/secret_treasure_prompt_1.csb
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_prompt_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "secret_treasure_prompt_1_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "secret_treasure_prompt_1_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "secret_treasure_prompt_1_jump",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)


	self:onUpdateDraw()
end

function SecretTreasurePrompt_1:onExit()
	-- 释放SecretTreasurePrompt_1Window界面资源.
	state_machine.remove("secret_treasure_prompt_1_open")
	state_machine.remove("secret_treasure_prompt_1_close")
	state_machine.remove("secret_treasure_prompt_1_show")
	state_machine.remove("secret_treasure_prompt_1_hide")
	state_machine.remove("secret_treasure_prompt_1_jump")
end

function SecretTreasurePrompt_1:close()
	-- window event : close.
	
end

function SecretTreasurePrompt_1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
