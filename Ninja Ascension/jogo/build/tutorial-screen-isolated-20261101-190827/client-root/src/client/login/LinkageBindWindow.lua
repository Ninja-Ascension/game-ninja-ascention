--[[ ----------------------------------------------------------------------------
-- 
--]] ----------------------------------------------------------------------------
LinkageBindWindow = class("LinkageBindWindowClass", Window)

-- 打开窗口
local linkage_bind_window_open_terminal = {
	_name = "linkage_bind_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LinkageBindWindowClass") then
			fwin:open(LinkageBindWindow:new():init(params), fwin._view)
		end
		-- local activityData = _ED.active_activity[119]
		-- local function responseRewardCallback (response)
	 --        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	 --        	print("----------")
	 --        end
	 --    end
	 --    print(".............>>>>")
	 --    protocol_command.linkage_bind.param_list = "gszyw@163.com"
	 --    NetworkManager:register(protocol_command.linkage_bind.code, nil, nil, nil, instance, responseRewardCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local linkage_bind_window_close_terminal = {
	_name = "linkage_bind_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LinkageBindWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(linkage_bind_window_open_terminal)
state_machine.add(linkage_bind_window_close_terminal)
state_machine.init()

-- 构造器
function LinkageBindWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize linkage bind page state machine.
	local function init_linkage_bind_terminal()
		-- 打开角色创建窗口
		local linkage_bind_open_terminal = {
			_name = "linkage_bind_open",
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
		local linkage_bind_close_terminal = {
			_name = "linkage_bind_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if fwin:find("platformSDKLoginMoveClass") ~= nil then
					fwin:find("platformSDKLoginMoveClass"):setVisible(true)
				end
				state_machine.excute("linkage_bind_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local linkage_bind_show_terminal = {
			_name = "linkage_bind_show",
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
		local linkage_bind_hide_terminal = {
			_name = "linkage_bind_hide",
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
		
		local linkage_bind_request_bind_terminal = {
            _name = "linkage_bind_request_bind",
            _init = function (terminal) 
            	
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local account_name = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1")
            	local names = zstring.exchangeTo(account_name:getString())
				local function responseRewardCallback (response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			        	state_machine.excute("linkage_bind_close", 0, 0)
			        end
			    end
			    if names == nil then
			    	names = ""
			    end
			    protocol_command.linkage_bind.param_list = names
			    NetworkManager:register(protocol_command.linkage_bind.code, nil, nil, nil, instance, responseRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(linkage_bind_open_terminal)
		state_machine.add(linkage_bind_close_terminal)
		state_machine.add(linkage_bind_show_terminal)
		state_machine.add(linkage_bind_hide_terminal)
		state_machine.add(linkage_bind_request_bind_terminal)
		state_machine.init()
	end
	-- call func init linkage bind state machine.
	init_linkage_bind_terminal()
end

function LinkageBindWindow:init()
	return self
end

function LinkageBindWindow:onInit()

end

function LinkageBindWindow:onEnterTransitionFinish()
	-- -- 加载LinkageBindWindowWindow界面资源.
	-- -- res.activity.wonderful.limited_time_good_packs = res/activity/wonderful/limited_time_good_packs.csb
	local csbNode = csb.createNode("login/register/register_prompt_9.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	--确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_login"),nil, 
    {
        terminal_name = "linkage_bind_request_bind",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_register"),nil, 
    {
        terminal_name = "linkage_bind_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

	--账号
    local Panel_Username = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_Username")
    local TextField_1 = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_1")
    local textField1 = draw:addEditBoxEx(TextField_1, account_sys_manager_tips[9], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_login"), 60, cc.KEYBOARD_RETURNTYPE_DONE)
    Panel_Username:addTouchEventListener(function ( sender, eventType )
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if textField1.touchDownAction ~= nil then
                textField1:touchDownAction(textField1, eventType)
            end
        end
    end)

	-- -- 奖励领取
	-- self.Button_lingqu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"), nil,
	-- {
	-- 	terminal_name = "linkage_bind_request_bind",
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true,
	-- }, nil, 0)
end

function LinkageBindWindow:onExit()
	state_machine.remove("linkage_bind_open")
	state_machine.remove("linkage_bind_close")
	state_machine.remove("linkage_bind_show")
	state_machine.remove("linkage_bind_hide")
	state_machine.remove("linkage_bind_request_bind")
end

function LinkageBindWindow:close()
	-- window event : close.
	
end

function LinkageBindWindow:destroy(window)
	-- window event : destroy.
	
end
-- ~END
-- ----------------------------------------------------------------------------
