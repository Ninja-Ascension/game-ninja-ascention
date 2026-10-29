--[[ ----------------------------------------------------------------------------
-- 新招募系统提示购买窗口
--]] ----------------------------------------------------------------------------
NewRecruitBuyTips = class("NewRecruitBuyTipsClass", Window)

-- 打开窗口
local new_recruit_buy_tips_window_open_terminal = {
	_name = "new_recruit_buy_tips_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("NewRecruitBuyTipsClass") then
			fwin:open(NewRecruitBuyTips:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local new_recruit_buy_tips_window_close_terminal = {
	_name = "new_recruit_buy_tips_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("NewRecruitBuyTipsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_buy_tips_window_open_terminal)
state_machine.add(new_recruit_buy_tips_window_close_terminal)
state_machine.init()

-- 构造器
function NewRecruitBuyTips:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool tips page state machine.
	local function init_new_recruit_buy_tips_terminal()
		-- 打开角色创建窗口
		local new_recruit_buy_tips_open_terminal = {
			_name = "new_recruit_buy_tips_open",
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
		local new_recruit_buy_tips_close_terminal = {
			_name = "new_recruit_buy_tips_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("new_recruit_buy_tips_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local new_recruit_buy_tips_show_terminal = {
			_name = "new_recruit_buy_tips_show",
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
		local new_recruit_buy_tips_hide_terminal = {
			_name = "new_recruit_buy_tips_hide",
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

		-- 跳转购买钻石
		local new_recruit_buy_tips_jump_windows_terminal = {
			_name = "new_recruit_buy_tips_jump_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("activity_home_recharge_button", 0, nil)
                state_machine.excute("new_recruit_buy_tips_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(new_recruit_buy_tips_open_terminal)
		state_machine.add(new_recruit_buy_tips_close_terminal)
		state_machine.add(new_recruit_buy_tips_show_terminal)
		state_machine.add(new_recruit_buy_tips_hide_terminal)
		state_machine.add(new_recruit_buy_tips_jump_windows_terminal)
		state_machine.init()
	end
	-- call func init lim pool tips state machine.
	init_new_recruit_buy_tips_terminal()
end

-- 对象初始化
function NewRecruitBuyTips:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function NewRecruitBuyTips:onUpdateDraw()
	local root = self.roots[1]
    self.Text_desc = ccui.Helper:seekWidgetByName(root, "Text_1")
    self.Text_desc:setString(new_recruit_shop_str[8])

    self.Text_tittle = ccui.Helper:seekWidgetByName(root, "Text_tittle")
    self.Text_tittle:setString(new_recruit_shop_str[14])
end

function NewRecruitBuyTips:onEnterTransitionFinish()
    local csbRechargeTipDialog = csb.createNode("utils/common_popup_4.csb")
    local root = csbRechargeTipDialog:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbRechargeTipDialog)

    local action = csb.createTimeline("utils/common_popup_4.csb")
    if action:IsAnimationInfoExists("window_open") == true then
        csbRechargeTipDialog:runAction(action)
        action:play("window_open", false)
    end

	-- 跳转获取页面
	self.Button_to_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "new_recruit_buy_tips_jump_windows",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消按钮
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "new_recruit_buy_tips_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

    -- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "new_recruit_buy_tips_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function NewRecruitBuyTips:onExit()
	-- 释放LimPoolTipsWindow界面资源.
	state_machine.remove("new_recruit_buy_tips_open")
	state_machine.remove("new_recruit_buy_tips_close")
	state_machine.remove("new_recruit_buy_tips_show")
	state_machine.remove("new_recruit_buy_tips_hide")
	state_machine.remove("new_recruit_buy_tips_jump_windows")
end

function NewRecruitBuyTips:close()
	-- window event : close.
	
end

function NewRecruitBuyTips:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
