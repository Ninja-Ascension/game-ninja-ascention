--------------------------------------------------------------------------------------------------------------
--  说明：军团技能列表
--------------------------------------------------------------------------------------------------------------
UnionSkillListCell = class("UnionSkillListCellClass", Window)

function UnionSkillListCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union skill list cell state machine.
    local function init_union_skill_list_cell_terminal()
		--刷新
		 local union_skill_list_cell_refresh_info_terminal = {
            _name = "union_skill_list_cell_refresh_info",
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
		--学习
		local union_skill_list_cell_button_learn_terminal = {
            _name = "union_skill_list_cell_button_learn",
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
		--开启
		local union_skill_list_cell_button_open_terminal = {
            _name = "union_skill_list_cell_button_open",
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
		--提升
		local union_skill_list_cell_button_promote_terminal = {
            _name = "union_skill_list_cell_button_promote",
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
		state_machine.add(union_skill_list_cell_refresh_info_terminal)
		state_machine.add(union_skill_list_cell_button_learn_terminal)
		state_machine.add(union_skill_list_cell_button_open_terminal)
		state_machine.add(union_skill_list_cell_button_promote_terminal)
        state_machine.init()
    end
    -- call func init union skill list cell state machine.
    init_union_skill_list_cell_terminal()

end

function UnionSkillListCell:updateDraw()

end

function UnionSkillListCell:onInit()
	self:updateDraw()
end

function UnionSkillListCell:onEnterTransitionFinish()

end

function UnionSkillListCell:init()
	self:onInit()
	return self
end

function UnionSkillListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionSkillListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
end
function UnionSkillListCell:onExit()

end

function UnionSkillListCell:createCell()
	local cell = UnionSkillListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
