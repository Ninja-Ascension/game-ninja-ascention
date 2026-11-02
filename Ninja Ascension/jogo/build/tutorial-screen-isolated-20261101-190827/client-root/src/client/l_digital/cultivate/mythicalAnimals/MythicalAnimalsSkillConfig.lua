--[[ ----------------------------------------------------------------------------
-- 神兽技能顺序设置
--]] ----------------------------------------------------------------------------
MythicalAnimalsSkillConfig = class("MythicalAnimalsSkillConfigClass", Window)

-- 打开窗口
local mythical_animals_skill_config_window_open_terminal = {
	_name = "mythical_animals_skill_config_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsSkillConfigClass") then
			fwin:open(MythicalAnimalsSkillConfig:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_skill_config_window_close_terminal = {
	_name = "mythical_animals_skill_config_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsSkillConfigClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_skill_config_window_open_terminal)
state_machine.add(mythical_animals_skill_config_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsSkillConfig:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_skill_config_terminal()
		-- 打开角色创建窗口
		local mythical_animals_skill_config_open_terminal = {
			_name = "mythical_animals_skill_config_open",
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
		local mythical_animals_skill_config_close_terminal = {
			_name = "mythical_animals_skill_config_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_skill_config_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_skill_config_show_terminal = {
			_name = "mythical_animals_skill_config_show",
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
		local mythical_animals_skill_config_hide_terminal = {
			_name = "mythical_animals_skill_config_hide",
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

		-- 确定
		local mythical_animals_skill_config_sure_terminal = {
			_name = "mythical_animals_skill_config_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local mySelectIndex = instance._mySelectIndex

					local oldSkillReleaseOrder = MythicalAnimalsHandle.getSkillReleaseOrder()
					if oldSkillReleaseOrder == mySelectIndex then
						state_machine.excute("mythical_animals_skill_config_close", 0, nil)
						return
					end

					print("mySelectIndex = ", mySelectIndex)

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then


							state_machine.excute("mythical_animals_skill_config_close", 0, nil)
						end
					end
					protocol_command.magical_animals_set_skill_release_method.param_list = "" .. mySelectIndex
					NetworkManager:register(protocol_command.magical_animals_set_skill_release_method.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_skill_config_open_terminal)
		state_machine.add(mythical_animals_skill_config_close_terminal)
		state_machine.add(mythical_animals_skill_config_show_terminal)
		state_machine.add(mythical_animals_skill_config_hide_terminal)
		state_machine.add(mythical_animals_skill_config_sure_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_skill_config_terminal()
end

-- 对象初始化
function MythicalAnimalsSkillConfig:init(params)
	self._mySelectIndex = MythicalAnimalsHandle.getSkillReleaseOrder()

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsSkillConfig:onUpdateDraw()
	local root = self.roots[1]

	self.Text_info_1 = ccui.Helper:seekWidgetByName(root, "Text_info_1")
	self.Text_title_1 = ccui.Helper:seekWidgetByName(root, "Text_title_1")
	self.Text_info_2 = ccui.Helper:seekWidgetByName(root, "Text_info_2")
	self.Text_title_2 = ccui.Helper:seekWidgetByName(root, "Text_title_2")

	self.Text_title_1:setString(tipStringInfo_magical_animals_word[15])
	self.Text_info_1:setString(tipStringInfo_magical_animals_word[16])
	
	self.Text_title_2:setString(tipStringInfo_magical_animals_word[17])
	self.Text_info_2:setString(tipStringInfo_magical_animals_word[18])
	
	self:updateCheckBox(self._mySelectIndex)
end

function MythicalAnimalsSkillConfig:updateCheckBox(mySelectIndex)
    self.CheckBox_1:setTouchEnabled(mySelectIndex ~= 0)
    self.CheckBox_2:setTouchEnabled(mySelectIndex ~= 1)

    self.CheckBox_1:setSelected(mySelectIndex == 0)
    self.CheckBox_2:setSelected(mySelectIndex == 1)

    self._mySelectIndex = mySelectIndex
end

function MythicalAnimalsSkillConfig:onEnterTransitionFinish()
	-- 加载MythicalAnimalsSkillConfigWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_skill_config = res/cultivate/Mythical_animals/mythical_animals_skill_config.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_skill_config.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "mythical_animals_skill_config_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 确定
	self.Button_mythical_animals_skill_ok = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mythical_animals_skill_ok"), nil,
	{
		terminal_name = "mythical_animals_skill_config_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.CheckBox_1 = ccui.Helper:seekWidgetByName(root, "CheckBox_1")
	self.CheckBox_2 = ccui.Helper:seekWidgetByName(root, "CheckBox_2")

	local function selectedEvent(sender, eventType)
		if eventType == ccui.CheckBoxEventType.selected then
			self:updateCheckBox(sender.index)
		elseif eventType == ccui.CheckBoxEventType.unselected then

		end
	end

	self.CheckBox_1.index = 0
	self.CheckBox_1:addEventListener(selectedEvent)

	self.CheckBox_2.index = 1
	self.CheckBox_2:addEventListener(selectedEvent)

	self:onUpdateDraw()
end

function MythicalAnimalsSkillConfig:onExit()
	-- 释放MythicalAnimalsSkillConfigWindow界面资源.
	state_machine.remove("mythical_animals_skill_config_open")
	state_machine.remove("mythical_animals_skill_config_close")
	state_machine.remove("mythical_animals_skill_config_show")
	state_machine.remove("mythical_animals_skill_config_hide")
	state_machine.remove("mythical_animals_skill_config_sure")
end

function MythicalAnimalsSkillConfig:close()
	-- window event : close.
	
end

function MythicalAnimalsSkillConfig:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
