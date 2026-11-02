--[[ ----------------------------------------------------------------------------
-- 战魂页签
--]] ----------------------------------------------------------------------------
FightSpiritZhTab = class("FightSpiritZhTabClass", Window)

-- 打开窗口
local fight_Spirit_zh_tab_window_open_terminal = {
	_name = "fight_Spirit_zh_tab_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritZhTabClass") then
			fwin:open(FightSpiritZhTab:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_Spirit_zh_tab_window_close_terminal = {
	_name = "fight_Spirit_zh_tab_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritZhTabClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_Spirit_zh_tab_window_open_terminal)
state_machine.add(fight_Spirit_zh_tab_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritZhTab:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh tab page state machine.
	local function init_fight_Spirit_zh_tab_terminal()
		-- 打开角色创建窗口
		local fight_Spirit_zh_tab_open_terminal = {
			_name = "fight_Spirit_zh_tab_open",
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
		local fight_Spirit_zh_tab_close_terminal = {
			_name = "fight_Spirit_zh_tab_close",
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
		local fight_Spirit_zh_tab_show_terminal = {
			_name = "fight_Spirit_zh_tab_show",
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
		local fight_Spirit_zh_tab_hide_terminal = {
			_name = "fight_Spirit_zh_tab_hide",
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

		state_machine.add(fight_Spirit_zh_tab_open_terminal)
		state_machine.add(fight_Spirit_zh_tab_close_terminal)
		state_machine.add(fight_Spirit_zh_tab_show_terminal)
		state_machine.add(fight_Spirit_zh_tab_hide_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh tab state machine.
	init_fight_Spirit_zh_tab_terminal()
end

-- 对象初始化
function FightSpiritZhTab:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritZhTab:onUpdateDraw()
	local root = self.roots[1]

	-- 战魂1号位
	self.Panel_stone_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_stone_icon_1")

	-- 战魂2号位
	self.Panel_stone_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_stone_icon_2")

	-- 战魂3号位
	self.Panel_stone_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_stone_icon_3")

	-- 战魂4号位
	self.Panel_stone_icon_4 = ccui.Helper:seekWidgetByName(root, "Panel_stone_icon_4")

	-- 详情按钮
	self.Button_install = ccui.Helper:seekWidgetByName(root, "Button_install")

	-- 强化属性
	self.Text_atk = ccui.Helper:seekWidgetByName(root, "Text_atk")

	-- 强化属性
	self.Text_def = ccui.Helper:seekWidgetByName(root, "Text_def")

	-- 强化属性
	self.Text_hp = ccui.Helper:seekWidgetByName(root, "Text_hp")

	-- 属性数值
	self.Text_atk_num = ccui.Helper:seekWidgetByName(root, "Text_atk_num")

	-- 属性数值
	self.Text_def_num = ccui.Helper:seekWidgetByName(root, "Text_def_num")

	-- 属性数值
	self.Text_hp_num = ccui.Helper:seekWidgetByName(root, "Text_hp_num")

	-- 两件套数值
	self.Text_two_info = ccui.Helper:seekWidgetByName(root, "Text_two_info")

	-- 四件套数值
	self.Text_four_info = ccui.Helper:seekWidgetByName(root, "Text_four_info")

	-- 套装技能描述
	self.Text_skill = ccui.Helper:seekWidgetByName(root, "Text_skill")

end

function FightSpiritZhTab:onEnterTransitionFinish()
	-- 加载FightSpiritZhTabWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_zh_att = res/packs/FightSpirit/FightSpirit_zh_att.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_zh_att.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 战魂属性详情
	self.Button_det_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det_1"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 套装属性详情
	self.Button_det_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det_2"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_Spirit_zh_tab_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function FightSpiritZhTab:onExit()
	-- 释放FightSpiritZhTabWindow界面资源.
	state_machine.remove("fight_Spirit_zh_tab_open")
	state_machine.remove("fight_Spirit_zh_tab_close")
	state_machine.remove("fight_Spirit_zh_tab_show")
	state_machine.remove("fight_Spirit_zh_tab_hide")
end

function FightSpiritZhTab:close()
	-- window event : close.
	
end

function FightSpiritZhTab:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
