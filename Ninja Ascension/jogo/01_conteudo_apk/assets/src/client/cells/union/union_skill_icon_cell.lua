--------------------------------------------------------------------------------------------------------------
--  说明：军团技能技能图标
--------------------------------------------------------------------------------------------------------------
UnionSkillIconCell = class("UnionSkillIconCellClass", Window)

function UnionSkillIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union skill icon cell state machine.
    local function init_union_skill_icon_cell_terminal()
		-- 点击查看技能信息
		local union_skill_icon_cell_look_skill_info_terminal = {
            _name = "union_skill_icon_cell_look_skill_info",
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
		state_machine.add(union_skill_icon_cell_look_skill_info_terminal)
        state_machine.init()
    end
    -- call func init union skill icon cell  state machine.
    init_union_logo_icon_cell_terminal()

end

function UnionSkillIconCell:updateDraw()

end

function UnionSkillIconCell:onInit()
	self:updateDraw()
end

function UnionSkillIconCell:onEnterTransitionFinish()

end

function UnionSkillIconCell:init()
	self:onInit()
	return self
end

function UnionSkillIconCell:onExit()

end

function UnionSkillIconCell:createCell()
	local cell = UnionSkillIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
