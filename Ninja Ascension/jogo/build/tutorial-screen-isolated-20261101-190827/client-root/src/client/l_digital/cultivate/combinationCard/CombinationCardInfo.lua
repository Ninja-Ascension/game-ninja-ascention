--[[ ----------------------------------------------------------------------------
-- 组合卡介绍
--]] ----------------------------------------------------------------------------
CombinationCardInfo = class("CombinationCardInfoClass", Window)

-- 打开窗口
local comb_card_Info_window_open_terminal = {
	_name = "comb_card_Info_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if nil == fwin:find("CombinationCardInfoClass") then
			fwin:open(CombinationCardInfo:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local comb_card_Info_window_close_terminal = {
	_name = "comb_card_Info_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CombinationCardInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(comb_card_Info_window_open_terminal)
state_machine.add(comb_card_Info_window_close_terminal)
state_machine.init()

-- 构造器
function CombinationCardInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	-- var

	-- load lua files.

	-- Initialize CombinationCardInfo page state machine.
	local function init_comb_card_Info_terminal()
		-- 打开角色创建窗口
		local comb_card_Info_open_terminal = {
			_name = "comb_card_Info_open",
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
		local comb_card_Info_close_terminal = {
			_name = "comb_card_Info_close",
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
		local comb_card_Info_show_terminal = {
			_name = "comb_card_Info_show",
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
		local comb_card_Info_hide_terminal = {
			_name = "comb_card_Info_hide",
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

		state_machine.add(comb_card_Info_open_terminal)
		state_machine.add(comb_card_Info_close_terminal)
		state_machine.add(comb_card_Info_show_terminal)
		state_machine.add(comb_card_Info_hide_terminal)
		state_machine.init()
	end
	-- call func init CombinationCardInfo state machine.
	init_comb_card_Info_terminal()
end

-- 对象初始化
function CombinationCardInfo:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CombinationCardInfo:onUpdateDraw()

end

function CombinationCardInfo:onEnterTransitionFinish()
	-- 加载comb_card_InfoWindow界面资源.
	-- res.cultivate.silk_bag_help = res/cultivate/silk_bag_help.csb
	local csbNode = csb.createNode("cultivate/Combination_card/Combination_card_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_matrix_rule_text__close"), nil,
	{
		terminal_name = "comb_card_Info_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CombinationCardInfo:onExit()
	-- 释放comb_card_InfoWindow界面资源.
	state_machine.remove("comb_card_Info_open")
	state_machine.remove("comb_card_Info_close")
	state_machine.remove("comb_card_Info_show")
	state_machine.remove("comb_card_Info_hide")
end

function CombinationCardInfo:close()
	-- window event : close.
	
end

function CombinationCardInfo:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------