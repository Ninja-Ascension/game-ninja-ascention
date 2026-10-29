--------------------------------------------------------------------------------------------------------------
--  说明：军团副本成员战绩
--------------------------------------------------------------------------------------------------------------
UnionDuplicateMemberMark = class("UnionDuplicateMemberMarkClass", Window)

function UnionDuplicateMemberMark:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate member mark state machine.
    local function init_union_duplicate_member_mark_terminal()
		--打开界面
        local union_duplicate_member_mark_open_terminal = {
            _name = "union_duplicate_member_mark_open",
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
		local union_duplicate_member_mark_close_terminal = {
            _name = "union_duplicate_member_mark_close",
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
		
		state_machine.add(union_duplicate_member_mark_open_terminal)
		state_machine.add(union_duplicate_member_mark_close_terminal)
        state_machine.init()
    end
    
    -- call func init union duplicate member mark state machine.
    init_union_duplicate_member_mark_terminal()

end

function UnionDuplicateMemberMark:updateDraw()

end

function UnionDuplicateMemberMark:onInit()
	self:updateDraw()
end

function UnionDuplicateMemberMark:onEnterTransitionFinish()

end

function UnionDuplicateMemberMark:init()
	self:onInit()
	return self
end

function UnionDuplicateMemberMark:onExit()
	state_machine.remove("union_duplicate_member_mark_open")
	state_machine.remove("union_duplicate_member_mark_close")

end