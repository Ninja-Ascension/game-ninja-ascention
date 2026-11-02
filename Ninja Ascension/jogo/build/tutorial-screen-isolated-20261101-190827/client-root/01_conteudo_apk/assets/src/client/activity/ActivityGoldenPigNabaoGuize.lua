--[[ ----------------------------------------------------------------------------
-- 金猪纳宝规则
--]] ----------------------------------------------------------------------------
ActivityGoldenPigNabaoGuize = class("ActivityGoldenPigNabaoGuizeClass", Window)

-- 打开窗口
local activity_golden_pig_nabao_guize_window_open_terminal = {
	_name = "activity_golden_pig_nabao_guize_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityGoldenPigNabaoGuizeClass") then
			fwin:open(ActivityGoldenPigNabaoGuize:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_golden_pig_nabao_guize_window_close_terminal = {
	_name = "activity_golden_pig_nabao_guize_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityGoldenPigNabaoGuizeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_golden_pig_nabao_guize_window_open_terminal)
state_machine.add(activity_golden_pig_nabao_guize_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityGoldenPigNabaoGuize:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize shop paihang guize page state machine.
	local function init_activity_golden_pig_nabao_guize_terminal()
		-- 打开角色创建窗口
		local activity_golden_pig_nabao_guize_open_terminal = {
			_name = "activity_golden_pig_nabao_guize_open",
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
		local activity_golden_pig_nabao_guize_close_terminal = {
			_name = "activity_golden_pig_nabao_guize_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance.actions[1]:play("window_close", false)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local activity_golden_pig_nabao_guize_show_terminal = {
			_name = "activity_golden_pig_nabao_guize_show",
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
		local activity_golden_pig_nabao_guize_hide_terminal = {
			_name = "activity_golden_pig_nabao_guize_hide",
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

		state_machine.add(activity_golden_pig_nabao_guize_open_terminal)
		state_machine.add(activity_golden_pig_nabao_guize_close_terminal)
		state_machine.add(activity_golden_pig_nabao_guize_show_terminal)
		state_machine.add(activity_golden_pig_nabao_guize_hide_terminal)
		state_machine.init()
	end
	-- call func init shop paihang guize state machine.
	init_activity_golden_pig_nabao_guize_terminal()
end

-- 对象初始化
function ActivityGoldenPigNabaoGuize:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityGoldenPigNabaoGuize:onUpdateDraw()
	local root = self.roots[1]

	-- 滚动容器
	self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")

end

function ActivityGoldenPigNabaoGuize:onEnterTransitionFinish()
	-- 加载ActivityGoldenPigNabaoGuizeWindow界面资源.
	-- res.shop.activity_golden_pig_nabao_guize = res/shop/activity_golden_pig_nabao_guize.csb
	local csbNode = csb.createNode("Lucky/Lucky_number_guize.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local action = csb.createTimeline("Lucky/Lucky_number_guize.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            state_machine.excute("activity_golden_pig_nabao_guize_window_close", 0, "")
        end
        
    end)

	-- 关闭
	self.Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "activity_golden_pig_nabao_guize_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ActivityGoldenPigNabaoGuize:onExit()
	-- 释放ActivityGoldenPigNabaoGuizeWindow界面资源.
	state_machine.remove("activity_golden_pig_nabao_guize_open")
	state_machine.remove("activity_golden_pig_nabao_guize_close")
	state_machine.remove("activity_golden_pig_nabao_guize_show")
	state_machine.remove("activity_golden_pig_nabao_guize_hide")
end

function ActivityGoldenPigNabaoGuize:close()
	-- window event : close.
	
end

function ActivityGoldenPigNabaoGuize:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
