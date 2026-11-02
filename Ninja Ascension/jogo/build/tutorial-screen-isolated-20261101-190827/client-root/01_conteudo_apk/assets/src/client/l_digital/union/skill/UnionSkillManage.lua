--------------------------------------------------------------------------------------------------------------
--  说明：军团技能管理界面
--------------------------------------------------------------------------------------------------------------
UnionSkillManage = class("UnionSkillManageClass", Window)

function UnionSkillManage:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union skill manage machine.
    local function init_union_skill_manage_terminal()
		--打开界面
        local union_skill_manage_open_terminal = {
            _name = "union_skill_manage_open",
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
		local union_skill_manage_close_terminal = {
            _name = "union_skill_manage_close",
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
        local union_skill_manage_hide_event_terminal = {
            _name = "union_skill_manage_hide_event",
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
        local union_skill_manage_show_event_terminal = {
            _name = "union_skill_manage_show_event",
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
		local union_skill_manage_refresh_terminal = {
            _name = "union_skill_manage_refresh",
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
		state_machine.add(union_skill_manage_open_terminal)
		state_machine.add(union_skill_manage_close_terminal)
		state_machine.add(union_skill_manage_hide_event_terminal)
		state_machine.add(union_skill_manage_show_event_terminal)
		state_machine.add(union_skill_manage_refresh_terminal)
        state_machine.init()
    end
    
    -- call func init union skill manage machine.
    init_union_skill_manage_terminal()

end

function UnionSkillManage:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionSkillManage:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionSkillManage:updateDraw()

end

function UnionSkillManage:onInit()
	self:updateDraw()
end

function UnionSkillManage:onEnterTransitionFinish()

end

function UnionSkillManage:init()
	self:onInit()
	return self
end

function UnionSkillManage:onExit()
	state_machine.remove("union_skill_manage_open")
	state_machine.remove("union_skill_manage_close")
	state_machine.remove("union_skill_manage_hide_event")
	state_machine.remove("union_skill_manage_show_event")
	state_machine.remove("union_skill_manage_refresh")

end