FightSpiritXilianConfirm = class("FightSpiritXilianConfirmClass", Window)

-- 打开窗口
local fight_spirit_xilian_confirm_window_open_terminal = {
	_name = "fight_spirit_xilian_confirm_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritXilianConfirmClass") then
			fwin:open(FightSpiritXilianConfirm:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_xilian_confirm_window_close_terminal = {
	_name = "fight_spirit_xilian_confirm_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritXilianConfirmClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_xilian_confirm_window_open_terminal)
state_machine.add(fight_spirit_xilian_confirm_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritXilianConfirm:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh att page state machine.
	local function init_fight_spirit_xilian_confirm_terminal()
		-- 打开角色创建窗口
		local fight_spirit_xilian_confirm_open_terminal = {
			_name = "fight_spirit_xilian_confirm_open",
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
		local fight_spirit_xilian_confirm_close_terminal = {
			_name = "fight_spirit_xilian_confirm_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_xilian_confirm_window_close", nil, {})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_xilian_confirm_show_terminal = {
			_name = "fight_spirit_xilian_confirm_show",
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
		local fight_spirit_xilian_confirm_hide_terminal = {
			_name = "fight_spirit_xilian_confirm_hide",
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

		-- 确认洗练
		local fight_spirit_xilian_confirm_ok_terminal = {
			_name = "fight_spirit_xilian_confirm_ok",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_xilian_request", 0, {callback = function ()
					state_machine.excute("fight_spirit_xilian_confirm_close", 0, {})
				end})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(fight_spirit_xilian_confirm_open_terminal)
		state_machine.add(fight_spirit_xilian_confirm_close_terminal)
		state_machine.add(fight_spirit_xilian_confirm_show_terminal)
		state_machine.add(fight_spirit_xilian_confirm_hide_terminal)
		state_machine.add(fight_spirit_xilian_confirm_ok_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh att state machine.
	init_fight_spirit_xilian_confirm_terminal()
end

-- 对象初始化
function FightSpiritXilianConfirm:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritXilianConfirm:onInit(params)
	self.xilianLockStates = params.xilianLockStates
	self.fightSpirit = params.fightSpirit
end

function FightSpiritXilianConfirm:onUpdateDraw()
	local root = self.roots[1]
end

function FightSpiritXilianConfirm:onEnterTransitionFinish()
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_prompt.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_xilian_confirm_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qd"), nil,
	{
		terminal_name = "fight_spirit_xilian_confirm_ok",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "fight_spirit_xilian_confirm_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	self:onUpdateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_skip"), function (sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if not _ED.notOpenFightSpiritXilianConfirm then
            	_ED.notOpenFightSpiritXilianConfirm = true
            else
            	_ED.notOpenFightSpiritXilianConfirm = false
            end
        end
    end)
end

function FightSpiritXilianConfirm:onExit()
	-- 释放FightSpiritXilianConfirmWindow界面资源.
	state_machine.remove("fight_spirit_xilian_confirm_open")
	state_machine.remove("fight_spirit_xilian_confirm_close")
	state_machine.remove("fight_spirit_xilian_confirm_show")
	state_machine.remove("fight_spirit_xilian_confirm_hide")
	state_machine.remove("fight_spirit_xilian_confirm_ok")
end

function FightSpiritXilianConfirm:close()
	-- window event : close.
	
end

function FightSpiritXilianConfirm:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
