--[[
	
    author: Rock
    time:2020-07-10 15:29:26
--]]

--[[ ----------------------------------------------------------------------------
-- 淬炼规则界面
--]] ----------------------------------------------------------------------------
SmEquipmentQunenchingRule = class("SmEquipmentQunenchingRuleClass", Window)

-- 打开窗口
local equipment_qunenching_window_open_terminal = {
	_name = "equipment_qunenching_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmEquipmentQunenchingRuleClass") then
			fwin:open(SmEquipmentQunenchingRule:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local equipment_qunenching_window_close_terminal = {
	_name = "equipment_qunenching_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmEquipmentQunenchingRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(equipment_qunenching_window_open_terminal)
state_machine.add(equipment_qunenching_window_close_terminal)
state_machine.init()

-- 构造器
function SmEquipmentQunenchingRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize illustration rule page state machine.
	local function init_equipment_qunenching_terminal()
		-- 打开角色创建窗口
		local equipment_qunenching_open_terminal = {
			_name = "equipment_qunenching_open",
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
		local equipment_qunenching_close_terminal = {
			_name = "equipment_qunenching_close",
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
		local equipment_qunenching_show_terminal = {
			_name = "equipment_qunenching_show",
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
		local equipment_qunenching_hide_terminal = {
			_name = "equipment_qunenching_hide",
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

		state_machine.add(equipment_qunenching_open_terminal)
		state_machine.add(equipment_qunenching_close_terminal)
		state_machine.add(equipment_qunenching_show_terminal)
		state_machine.add(equipment_qunenching_hide_terminal)
		state_machine.init()
	end
	-- call func init illustration rule state machine.
	init_equipment_qunenching_terminal()
end

-- 对象初始化
function SmEquipmentQunenchingRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SmEquipmentQunenchingRule:onUpdateDraw()
	local root = self.roots[1]
end

function SmEquipmentQunenchingRule:onEnterTransitionFinish()
	-- 加载SmEquipmentQunenchingRuleWindow界面资源.
	-- res.cultivate.illustration.equipment_qunenching = res/cultivate/illustration/equipment_qunenching.csb
	local csbNode = csb.createNode("packs/EquipStorage/sm_equipment_qianghua_tab_3_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "equipment_qunenching_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SmEquipmentQunenchingRule:onExit()
	-- 释放SmEquipmentQunenchingRuleWindow界面资源.
	state_machine.remove("equipment_qunenching_open")
	state_machine.remove("equipment_qunenching_close")
	state_machine.remove("equipment_qunenching_show")
	state_machine.remove("equipment_qunenching_hide")
end

function SmEquipmentQunenchingRule:close()
	-- window event : close.
	
end

function SmEquipmentQunenchingRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
