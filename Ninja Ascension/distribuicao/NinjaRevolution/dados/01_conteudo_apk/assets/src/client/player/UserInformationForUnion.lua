--------------------------------------------------------------------------------------------------------------
--  说明：军团主界面玩家信息
--------------------------------------------------------------------------------------------------------------
UserInformationForUnion = class("UserInformationForUnionClass", Window)

function UserInformationForUnion:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union user information for union machine.
    local function init_user_information_for_union_terminal()
		--打开界面
        local user_information_for_union_open_terminal = {
            _name = "user_information_for_union_open",
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
		
		--关闭界面
		local user_information_for_union_close_terminal = {
            _name = "user_information_for_union_close",
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
		-- 隐藏界面
        local user_information_for_union_hide_event_terminal = {
            _name = "user_information_for_union_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local user_information_for_union_show_event_terminal = {
            _name = "user_information_for_union_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local user_information_for_union_refresh_terminal = {
            _name = "user_information_for_union_refresh",
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
		-- 用户信息显示
		local user_information_for_union_show_all_info_terminal = {
            _name = "user_information_for_union_show_all_info",
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
		state_machine.add(user_information_for_union_open_terminal)
		state_machine.add(user_information_for_union_close_terminal)
		state_machine.add(user_information_for_union_hide_event_terminal)
		state_machine.add(user_information_for_union_show_event_terminal)
		state_machine.add(user_information_for_union_refresh_terminal)
		state_machine.add(user_information_for_union_show_all_info_terminal)
        state_machine.init()
    end
    
    -- call func init union user information for union  machine.
    init_user_information_for_union_terminal()

end

function UserInformationForUnion:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UserInformationForUnion:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UserInformationForUnion:updateDraw()

end

function UserInformationForUnion:onInit()
	self:updateDraw()
end

function UserInformationForUnion:onEnterTransitionFinish()

end

function UserInformationForUnion:init()
	self:onInit()
	return self
end

function UserInformationForUnion:onExit()
	state_machine.remove("user_information_for_union_open")
	state_machine.remove("user_information_for_union_close")
	state_machine.remove("user_information_for_union_hide_event")
	state_machine.remove("user_information_for_union_show_event")
	state_machine.remove("user_information_for_union_refresh")
	state_machine.remove("user_information_for_union_show_all_info")

end