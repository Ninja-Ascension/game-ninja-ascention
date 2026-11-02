--------------------------------------------------------------------------------------------------------------
--  说明：军团技能技能信息界面
--------------------------------------------------------------------------------------------------------------
UnionSkillInformation = class("UnionSkillInformationClass", Window)

function UnionSkillInformation:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union skill information state machine.
    local function init_union_skill_information_terminal()
		--打开界面
        local union_skill_information_open_terminal = {
            _name = "union_skill_information_open",
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
		local union_skill_information_close_terminal = {
            _name = "union_skill_information_close",
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
		
		state_machine.add(union_skill_information_open_terminal)
		state_machine.add(union_skill_information_close_terminal)
        state_machine.init()
    end
    
    -- call func init union skill information state machine.
    init_union_skill_information_terminal()

end

function UnionSkillInformation:updateDraw()

end

function UnionSkillInformation:onInit()
	self:updateDraw()
end

function UnionSkillInformation:onEnterTransitionFinish()

end

function UnionSkillInformation:init()
	self:onInit()
	return self
end

function UnionSkillInformation:onExit()
	state_machine.remove("union_skill_information_open")
	state_machine.remove("union_skill_information_close")
end