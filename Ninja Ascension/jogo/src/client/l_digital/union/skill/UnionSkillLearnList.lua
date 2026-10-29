--------------------------------------------------------------------------------------------------------------
--  说明：军团技能学习列表界面
--------------------------------------------------------------------------------------------------------------
UnionSkillLearnList = class("UnionSkillLearnListClass", Window)

function UnionSkillLearnList:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union skill learn list machine.
    local function init_union_skill_learn_list_terminal()
		--打开界面
        local union_skill_learn_list_open_terminal = {
            _name = "union_skill_learn_list_open",
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
		local union_skill_learn_list_close_terminal = {
            _name = "union_skill_learn_list_close",
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
        local union_skill_learn_list_hide_event_terminal = {
            _name = "union_skill_learn_list_hide_event",
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
        local union_skill_learn_list_show_event_terminal = {
            _name = "union_skill_learn_list_show_event",
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
		local union_skill_learn_list_refresh_terminal = {
            _name = "union_skill_learn_list_refresh",
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
		state_machine.add(union_skill_learn_list_open_terminal)
		state_machine.add(union_skill_learn_list_close_terminal)
		state_machine.add(union_skill_learn_list_hide_event_terminal)
		state_machine.add(union_skill_learn_list_show_event_terminal)
		state_machine.add(union_skill_learn_list_refresh_terminal)
        state_machine.init()
    end
    
    -- call func init union skill learn list machine.
    init_union_skill_learn_list_terminal()

end

function UnionSkillLearnList:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionSkillLearnList:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionSkillLearnList:updateDraw()

end

function UnionSkillLearnList:onInit()
	self:updateDraw()
end

function UnionSkillLearnList:onEnterTransitionFinish()

end

function UnionSkillLearnList:init()
	self:onInit()
	return self
end

function UnionSkillLearnList:onExit()
	state_machine.remove("union_skill_learn_list_open")
	state_machine.remove("union_skill_learn_list_close")
	state_machine.remove("union_skill_learn_list_hide_event")
	state_machine.remove("union_skill_learn_list_show_event")
	state_machine.remove("union_skill_learn_list_refresh")

end