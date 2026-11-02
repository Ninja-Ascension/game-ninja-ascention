--[[ ----------------------------------------------------------------------------
-- 获取忍者令窗口
--]] ----------------------------------------------------------------------------
LimPoolTips = class("LimPoolTipsClass", Window)

-- 打开窗口
local lim_pool_tips_window_open_terminal = {
	_name = "lim_pool_tips_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LimPoolTipsClass") then
			fwin:open(LimPoolTips:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local lim_pool_tips_window_close_terminal = {
	_name = "lim_pool_tips_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LimPoolTipsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_tips_window_open_terminal)
state_machine.add(lim_pool_tips_window_close_terminal)
state_machine.init()

-- 构造器
function LimPoolTips:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool tips page state machine.
	local function init_lim_pool_tips_terminal()
		-- 打开角色创建窗口
		local lim_pool_tips_open_terminal = {
			_name = "lim_pool_tips_open",
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
		local lim_pool_tips_close_terminal = {
			_name = "lim_pool_tips_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_tips_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local lim_pool_tips_show_terminal = {
			_name = "lim_pool_tips_show",
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
		local lim_pool_tips_hide_terminal = {
			_name = "lim_pool_tips_hide",
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

		-- 跳转获取次数界面
		local lim_pool_tips_jump_windows_terminal = {
			_name = "lim_pool_tips_jump_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_open_get_cost_prop_window", 0, 0)

				if fwin:find("HeroRecruitSuccessClass") ~= nil then
					fwin:close(fwin:find("HeroRecruitSuccessClass"))
				end

				if fwin:find("HeroRecruitSuccessTen") ~= nil then
					fwin:close(fwin:find("HeroRecruitSuccessTen"))
				end

				state_machine.excute("lim_pool_tips_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(lim_pool_tips_open_terminal)
		state_machine.add(lim_pool_tips_close_terminal)
		state_machine.add(lim_pool_tips_show_terminal)
		state_machine.add(lim_pool_tips_hide_terminal)
		state_machine.add(lim_pool_tips_jump_windows_terminal)
		state_machine.init()
	end
	-- call func init lim pool tips state machine.
	init_lim_pool_tips_terminal()
end

-- 对象初始化
function LimPoolTips:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function LimPoolTips:onUpdateDraw()
	local root = self.roots[1]

end

function LimPoolTips:onEnterTransitionFinish()
	-- 加载LimPoolTipsWindow界面资源.
	-- res.activity.lim_pool.lim_pool_tips = res/activity/lim_pool/lim_pool_tips.csb
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_tips.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 跳转获取页面
	self.Button_to_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_to_get"), nil,
	{
		terminal_name = "lim_pool_tips_jump_windows",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "lim_pool_tips_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function LimPoolTips:onExit()
	-- 释放LimPoolTipsWindow界面资源.
	state_machine.remove("lim_pool_tips_open")
	state_machine.remove("lim_pool_tips_close")
	state_machine.remove("lim_pool_tips_show")
	state_machine.remove("lim_pool_tips_hide")
	state_machine.remove("lim_pool_tips_jump_windows")
end

function LimPoolTips:close()
	-- window event : close.
	
end

function LimPoolTips:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
