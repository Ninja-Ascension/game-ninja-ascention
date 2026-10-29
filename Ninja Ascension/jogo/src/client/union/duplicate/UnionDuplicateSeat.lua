--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景列表界面
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSeat = class("UnionDuplicateSeatClass", Window)

function UnionDuplicateSeat:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate seat machine.
    local function init_union_duplicate_seat_terminal()
		--打开界面
        local union_duplicate_seat_open_terminal = {
            _name = "union_duplicate_seat_open",
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
		local union_duplicate_seat_close_terminal = {
            _name = "union_duplicate_seat_close",
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
        local union_duplicate_seat_hide_event_terminal = {
            _name = "union_duplicate_seat_hide_event",
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
        local union_duplicate_seat_show_event_terminal = {
            _name = "union_duplicate_seat_show_event",
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
		local union_duplicate_seat_refresh_terminal = {
            _name = "union_duplicate_seat_refresh",
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
		state_machine.add(union_duplicate_seat_open_terminal)
		state_machine.add(union_duplicate_seat_close_terminal)
		state_machine.add(union_duplicate_seat_hide_event_terminal)
		state_machine.add(union_duplicate_seat_show_event_terminal)
		state_machine.add(union_duplicate_seat_refresh_terminal)
        state_machine.init()
    end
    
    -- call func init union duplicate seat machine.
    init_union_duplicate_seat_terminal()

end

function UnionDuplicateSeat:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionDuplicateSeat:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionDuplicateSeat:updateDraw()

end

function UnionDuplicateSeat:onInit()
	self:updateDraw()
end

function UnionDuplicateSeat:onEnterTransitionFinish()

end

function UnionDuplicateSeat:init()
	self:onInit()
	return self
end

function UnionDuplicateSeat:onExit()
	state_machine.remove("union_duplicate_seat_open")
	state_machine.remove("union_duplicate_seat_close")
	state_machine.remove("union_duplicate_seat_hide_event")
	state_machine.remove("union_duplicate_seat_show_event")
	state_machine.remove("union_duplicate_seat_refresh")

end