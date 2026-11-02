--[[ ----------------------------------------------------------------------------
-- 飘字界面
--]] ----------------------------------------------------------------------------
CommandWorldPopUp = class("CommandWorldPopUpClass", Window)

-- 打开窗口
local command_world_pop_up_window_open_terminal = {
	_name = "command_world_pop_up_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		-- if nil == fwin:find("CommandWorldPopUpClass") then
			fwin:open(CommandWorldPopUp:new():init(params), fwin._view)
		-- end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_pop_up_window_close_terminal = {
	_name = "command_world_pop_up_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldPopUpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_pop_up_window_open_terminal)
state_machine.add(command_world_pop_up_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorldPopUp:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure rule page state machine.
	local function init_command_world_pop_up_terminal()
		-- 打开角色创建窗口
		local command_world_pop_up_open_terminal = {
			_name = "command_world_pop_up_open",
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
		local command_world_pop_up_close_terminal = {
			_name = "command_world_pop_up_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_pop_up_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_pop_up_show_terminal = {
			_name = "command_world_pop_up_show",
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
		local command_world_pop_up_hide_terminal = {
			_name = "command_world_pop_up_hide",
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

		state_machine.add(command_world_pop_up_open_terminal)
		state_machine.add(command_world_pop_up_close_terminal)
		state_machine.add(command_world_pop_up_show_terminal)
		state_machine.add(command_world_pop_up_hide_terminal)
		state_machine.init()
	end
	-- call func init secret treasure rule state machine.
	init_command_world_pop_up_terminal()
end

-- 对象初始化
function CommandWorldPopUp:init(params)
	self._donateType = params.donateType
	self._donateCount = params.donateCount

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CommandWorldPopUp:onUpdateDraw()
	local root = self.roots[1]

	local addScoreStr = zstring.split(dms.string(dms["activity_config"], 75, activity_config.param), ",")
	local badgePropsStr = zstring.splits(dms.string(dms["activity_config"], 76, activity_config.param), "|", ",")

	local donateType = self._donateType
	local donateCount = self._donateCount
	
	local score = donateCount * tonumber(addScoreStr[donateType])

	local Text_point = ccui.Helper:seekWidgetByName(root, "Text_point")
	Text_point:setString(string.format(tipStringInfo_command_world[3], score))

	local getBadgePropCount = donateCount * tonumber(badgePropsStr[donateType][3])

	local Text_badge_up = ccui.Helper:seekWidgetByName(root, "Text_badge_up")
	Text_badge_up:setString("+" .. getBadgePropCount)

	for i = 1, 3 do
		local Image_icon = ccui.Helper:seekWidgetByName(root, "Image_icon_"..i)
		if donateType == i then
			Image_icon:setVisible(true)
		else
			Image_icon:setVisible(false)
		end
	end

	local action = self.actions[1]
	action:play("animation_pop_up", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "exit" then
        	state_machine.excute("command_world_pop_up_window_close", 0, nil)
        end
    end)
end

function CommandWorldPopUp:onEnterTransitionFinish()
	-- 加载CommandWorldPopUpWindow界面资源.
	-- res.activity.command_world.command_world_pop_up = res/activity/command_world/command_world_pop_up.csb
	local csbNode = csb.createNode("activity/command_world/command_world_pop_up.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local action = csb.createTimeline("activity/command_world/command_world_pop_up.csb")
    table.insert(self.actions, action)
    root:runAction(action)


	self:onUpdateDraw()
end

function CommandWorldPopUp:onExit()
	-- 释放CommandWorldPopUpWindow界面资源.
	state_machine.remove("command_world_pop_up_open")
	state_machine.remove("command_world_pop_up_close")
	state_machine.remove("command_world_pop_up_show")
	state_machine.remove("command_world_pop_up_hide")
end

function CommandWorldPopUp:close()
	-- window event : close.
	
end

function CommandWorldPopUp:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
