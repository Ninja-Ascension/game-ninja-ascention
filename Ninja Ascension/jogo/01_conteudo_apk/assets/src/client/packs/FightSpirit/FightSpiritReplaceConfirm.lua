FightSpiritReplaceConfirm = class("FightSpiritReplaceConfirmClass", Window)

-- 打开窗口
local fight_spirit_replace_confirm_window_open_terminal = {
	_name = "fight_spirit_replace_confirm_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritReplaceConfirmClass") then
			fwin:open(FightSpiritReplaceConfirm:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_replace_confirm_window_close_terminal = {
	_name = "fight_spirit_replace_confirm_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritReplaceConfirmClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_replace_confirm_window_open_terminal)
state_machine.add(fight_spirit_replace_confirm_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritReplaceConfirm:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh att page state machine.
	local function init_fight_spirit_replace_confirm_terminal()
		-- 打开角色创建窗口
		local fight_spirit_replace_confirm_open_terminal = {
			_name = "fight_spirit_replace_confirm_open",
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
		local fight_spirit_replace_confirm_close_terminal = {
			_name = "fight_spirit_replace_confirm_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_replace_confirm_window_close", nil, {})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_replace_confirm_show_terminal = {
			_name = "fight_spirit_replace_confirm_show",
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
		local fight_spirit_replace_confirm_hide_terminal = {
			_name = "fight_spirit_replace_confirm_hide",
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

		-- 确认合成
		local fight_spirit_replace_confirm_ok_terminal = {
			_name = "fight_spirit_replace_confirm_ok",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				--是否替换战魂
				_ED.whetherReplaceFightSpirit = params._datas.isReplace
				state_machine.excute(instance.next_terminal_name, 0, {_datas = {_ship = instance.ship}})
				state_machine.excute("fight_spirit_replace_confirm_close", 0, {})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(fight_spirit_replace_confirm_open_terminal)
		state_machine.add(fight_spirit_replace_confirm_close_terminal)
		state_machine.add(fight_spirit_replace_confirm_show_terminal)
		state_machine.add(fight_spirit_replace_confirm_hide_terminal)
		state_machine.add(fight_spirit_replace_confirm_ok_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh att state machine.
	init_fight_spirit_replace_confirm_terminal()
end

-- 对象初始化
function FightSpiritReplaceConfirm:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritReplaceConfirm:onInit(params)
	self.next_terminal_name = params.next_terminal_name
	self.ship = params.ship
end

function FightSpiritReplaceConfirm:onUpdateDraw()
	local root = self.roots[1]
end

function FightSpiritReplaceConfirm:onEnterTransitionFinish()
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_prompt_2.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_replace_confirm_ok",
		terminal_state = 0,
		isPressedActionEnabled = true,
		isReplace = false,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qd"), nil,
	{
		terminal_name = "fight_spirit_replace_confirm_ok",
		terminal_state = 0,
		isPressedActionEnabled = true,
		isReplace = true,
	}, nil, 0)	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "fight_spirit_replace_confirm_ok",
		terminal_state = 0,
		isPressedActionEnabled = true,
		isReplace = false,
	}, nil, 0)	
	
	self:onUpdateDraw()
end

function FightSpiritReplaceConfirm:onExit()
	-- 释放FightSpiritReplaceConfirmWindow界面资源.
	state_machine.remove("fight_spirit_replace_confirm_open")
	state_machine.remove("fight_spirit_replace_confirm_close")
	state_machine.remove("fight_spirit_replace_confirm_show")
	state_machine.remove("fight_spirit_replace_confirm_hide")
	state_machine.remove("fight_spirit_replace_confirm_ok")
end

function FightSpiritReplaceConfirm:close()
	-- window event : close.
	
end

function FightSpiritReplaceConfirm:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
