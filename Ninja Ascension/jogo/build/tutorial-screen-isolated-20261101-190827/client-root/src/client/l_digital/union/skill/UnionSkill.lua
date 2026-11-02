--------------------------------------------------------------------------------------------------------------
--  说明：军团技能主界面
--------------------------------------------------------------------------------------------------------------
UnionSkill = class("UnionSkillClass", Window)

function UnionSkill:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union skill machine.
    local function init_union_skill_terminal()
		--打开界面
        local union_skill_open_terminal = {
            _name = "union_skill_open",
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
		local union_skill_close_terminal = {
            _name = "union_skill_close",
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
        local union_skill_hide_event_terminal = {
            _name = "union_skill_hide_event",
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
        local union_skill_show_event_terminal = {
            _name = "union_skill_show_event",
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
		local union_skill_refresh_terminal = {
            _name = "union_skill_refresh",
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
		--帮助信息
		local union_skill_look_help_info_terminal = {
            _name = "union_skill_look_help_info",
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
		--界面切换控制
		local union_skill_select_page_terminal = {
            _name = "union_skill_select_page",
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
		--打开学习技能界面
		local union_skill_open_learn_list_terminal = {
            _name = "union_skill_open_learn_list",
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
		--打开技能管理界面
		local union_skill_open_manage_terminal = {
            _name = "union_skill_open_manage",
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
		
		state_machine.add(union_skill_open_terminal)
		state_machine.add(union_skill_close_terminal)
		state_machine.add(union_skill_hide_event_terminal)
		state_machine.add(union_skill_show_event_terminal)
		state_machine.add(union_skill_refresh_terminal)
		state_machine.add(union_skill_look_help_info_terminal)
		state_machine.add(union_skill_select_page_terminal)
		state_machine.add(union_skill_open_learn_list_terminal)
		state_machine.add(union_skill_open_manage_terminal)
        state_machine.init()
    end
    
    -- call func init union skill  machine.
    init_union_skill_terminal()

end

function UnionSkill:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionSkill:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionSkill:updateDraw()

end

function UnionSkill:onInit()
	self:updateDraw()
end

function UnionSkill:onEnterTransitionFinish()

end

function UnionSkill:init()
	self:onInit()
	return self
end

function UnionSkill:onExit()
	state_machine.remove("union_skill_open")
	state_machine.remove("union_skill_close")
	state_machine.remove("union_skill_hide_event")
	state_machine.remove("union_skill_show_event")
	state_machine.remove("union_skill_refresh")
	state_machine.remove("union_skill_look_help_info")
	state_machine.remove("union_skill_select_page")
	state_machine.remove("union_skill_open_learn_list")
	state_machine.remove("union_skill_open_manage")
end