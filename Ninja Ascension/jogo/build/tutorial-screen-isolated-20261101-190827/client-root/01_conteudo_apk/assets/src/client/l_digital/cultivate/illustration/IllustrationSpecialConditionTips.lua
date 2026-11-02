--[[ ----------------------------------------------------------------------------
-- 卡册升级提示界面
--]] ----------------------------------------------------------------------------
IllustrationSpecialConditionTips = class("IllustrationSpecialConditionTipsClass", Window)

-- 打开窗口
local illustration_special_condition_tips_window_open_terminal = {
	_name = "illustration_special_condition_tips_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationSpecialConditionTipsClass") then
			fwin:open(IllustrationSpecialConditionTips:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_special_condition_tips_window_close_terminal = {
	_name = "illustration_special_condition_tips_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationSpecialConditionTipsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_special_condition_tips_window_open_terminal)
state_machine.add(illustration_special_condition_tips_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationSpecialConditionTips:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._cardMouldIDs = {}

	-- load lua files.
	app.load("client.l_digital.cultivate.illustration.IllustrationActivate")
	-- Initialize illustration tips page state machine.
	local function init_illustration_special_condition_tips_terminal()
		-- 打开角色创建窗口
		local illustration_special_condition_tips_open_terminal = {
			_name = "illustration_special_condition_tips_open",
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
		local illustration_special_condition_tips_close_terminal = {
			_name = "illustration_special_condition_tips_close",
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
		local illustration_special_condition_tips_show_terminal = {
			_name = "illustration_special_condition_tips_show",
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
		local illustration_special_condition_tips_hide_terminal = {
			_name = "illustration_special_condition_tips_hide",
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

		-- 打开组合卡册激活界面
		local illustration_special_condition_tips_open_activite_window_terminal = {
			_name = "illustration_special_condition_tips_open_activite_window",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cardMouldId = self._cardMouldIDs[math.random(1, #self._cardMouldIDs)]
				state_machine.excute("illustration_activate_window_open", 0, {cardMouldId})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(illustration_special_condition_tips_open_terminal)
		state_machine.add(illustration_special_condition_tips_close_terminal)
		state_machine.add(illustration_special_condition_tips_show_terminal)
		state_machine.add(illustration_special_condition_tips_hide_terminal)
		state_machine.add(illustration_special_condition_tips_open_activite_window_terminal)
		state_machine.init()
	end
	-- call func init illustration tips state machine.
	init_illustration_special_condition_tips_terminal()
end

-- 对象初始化
function IllustrationSpecialConditionTips:init(params)
	self._show_data = params
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationSpecialConditionTips:onUpdateDraw()
	local root = self.roots[1]

	local str = tipStringInfo_illustration_tip[15]
	local count, cardMouldIDs  = IllustrationHandle.getHideConditionFinishCount()

	self._cardMouldIDs = cardMouldIDs

	self.Text_18:setString(string.format(str, count))

	if count == 0 then
		self.Panel_1:setVisible(false)
	end
end

function IllustrationSpecialConditionTips:onEnterTransitionFinish()
	-- 加载IllustrationSpecialConditionTipsWindow界面资源.
	-- res.cultivate.illustration.illustration_tips_0 = res/cultivate/illustration/illustration_tips_0.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_tips_0.csb")
	local root = csbNode:getChildByName("root")

	-- local action = csb.createTimeline("cultivate/illustration/illustration_tips_0.csb") 
	
	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
	-- csbNode:runAction(action)	

	table.insert(self.roots, root)
	self:addChild(csbNode)
	
	self.Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18")

	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	fwin:addTouchEventListener(self.Panel_1, nil,{
		terminal_name = "illustration_special_condition_tips_open_activite_window", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)

	self:onUpdateDraw()
end

function IllustrationSpecialConditionTips:onExit()
	-- 释放IllustrationSpecialConditionTipsWindow界面资源.
	state_machine.remove("illustration_special_condition_tips_open")
	state_machine.remove("illustration_special_condition_tips_close")
	state_machine.remove("illustration_special_condition_tips_show")
	state_machine.remove("illustration_special_condition_tips_hide")
	state_machine.remove("illustration_special_condition_tips_open_activite_window")
end

function IllustrationSpecialConditionTips:close()
	-- window event : close.
	
end

function IllustrationSpecialConditionTips:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
