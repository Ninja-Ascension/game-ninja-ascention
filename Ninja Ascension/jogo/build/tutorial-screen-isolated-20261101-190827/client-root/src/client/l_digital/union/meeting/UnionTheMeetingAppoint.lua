--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅任命界面
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingAppoint = class("UnionTheMeetingAppointClass", Window)

function UnionTheMeetingAppoint:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union the meeting appoint machine.
    local function init_union_the_meeting_appoint_terminal()
		--打开界面
        local union_the_meeting_appoint_open_terminal = {
            _name = "union_the_meeting_appoint_open",
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
		local union_the_meeting_appoint_close_terminal = {
            _name = "union_the_meeting_appoint_close",
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
        local union_the_meeting_appoint_hide_event_terminal = {
            _name = "union_the_meeting_appoint_hide_event",
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
        local union_the_meeting_appoint_show_event_terminal = {
            _name = "union_the_meeting_appoint_show_event",
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
		local union_the_meeting_appoint_refresh_list_terminal = {
            _name = "union_the_meeting_appoint_refresh_list",
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
		-- 移交军团长
		local union_the_meeting_appoint_over_union_head_terminal = {
            _name = "union_the_meeting_appoint_over_union_head",
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
		-- 任命副团长
		local union_the_meeting_appoint_adjutant_terminal = {
            _name = "union_the_meeting_appoint_adjutant",
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
		-- 罢免职位 
		local union_the_meeting_appoint_recall_terminal = {
            _name = "union_the_meeting_appoint_recall",
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
		
		state_machine.add(union_the_meeting_appoint_open_terminal)
		state_machine.add(union_the_meeting_appoint_close_terminal)
		state_machine.add(union_the_meeting_appoint_hide_event_terminal)
		state_machine.add(union_the_meeting_appoint_show_event_terminal)
		state_machine.add(union_the_meeting_appoint_refresh_list_terminal)
		state_machine.add(union_the_meeting_appoint_over_union_head_terminal)
		state_machine.add(union_the_meeting_appoint_adjutant_terminal)
		state_machine.add(union_the_meeting_appoint_recall_terminal)
        state_machine.init()
    end
    
    -- call func init  union the meeting appoint  machine.
    init_union_the_meeting_appoint_terminal()

end

function UnionTheMeetingAppoint:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionTheMeetingAppoint:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionTheMeetingAppoint:updateDraw()

end

function UnionTheMeetingAppoint:onInit()
	self:updateDraw()
end

function UnionTheMeetingAppoint:onEnterTransitionFinish()

end

function UnionTheMeetingAppoint:init()
	self:onInit()
	return self
end

function UnionTheMeetingAppoint:onExit()
	state_machine.remove("union_the_meeting_appoint_open")
	state_machine.remove("union_the_meeting_appoint_close")
	state_machine.remove("union_the_meeting_appoint_hide_event")
	state_machine.remove("union_the_meeting_appoint_show_event")
	state_machine.remove("union_the_meeting_appoint_refresh_list")
	state_machine.remove("union_the_meeting_appoint_over_union_head")
	state_machine.remove("union_the_meeting_appoint_adjutant")
	state_machine.remove("union_the_meeting_appoint_recall")
end