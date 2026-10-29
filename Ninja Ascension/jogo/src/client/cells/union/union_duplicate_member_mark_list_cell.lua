--------------------------------------------------------------------------------------------------------------
--  说明：军团副本成员战绩列表
--------------------------------------------------------------------------------------------------------------
UnionDuplicateMemberMarkListCell = class("UnionDuplicateMemberMarkListCellClass", Window)

function UnionDuplicateMemberMarkListCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate member mark list cell state machine.
    local function init_union_duplicate_member_mark_list_cell_terminal()
	
		
        state_machine.init()
    end
    -- call func init  union duplicate member mark list cell state machine.
    init_union_duplicate_member_mark_list_cell_terminal()

end

function UnionDuplicateMemberMarkListCell:updateDraw()

end

function UnionDuplicateMemberMarkListCell:onInit()
	self:updateDraw()
end

function UnionDuplicateMemberMarkListCell:onEnterTransitionFinish()

end

function UnionDuplicateMemberMarkListCell:init()
	self:onInit()
	return self
end

function UnionDuplicateMemberMarkListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionDuplicateMemberMarkListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
end
function UnionDuplicateMemberMarkListCell:onExit()

end

function UnionDuplicateMemberMarkListCell:createCell()
	local cell = UnionDuplicateMemberMarkListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
