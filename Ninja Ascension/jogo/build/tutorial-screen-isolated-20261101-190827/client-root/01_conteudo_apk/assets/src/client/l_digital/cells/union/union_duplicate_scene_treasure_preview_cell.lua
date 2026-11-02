--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景宝藏预览奖励框
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSceneTreasurePreviewCell = class("UnionDuplicateSceneTreasurePreviewCellClass", Window)

function UnionDuplicateSceneTreasurePreviewCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate scene treasure preview cell state machine.
    local function init_union_duplicate_scene_treasure_preview_cell_terminal()
		
        state_machine.init()
    end
    -- call func init union duplicate scene treasure preview cell state machine.
    init_union_duplicate_scene_treasure_preview_cell_terminal()

end

function UnionDuplicateSceneTreasurePreviewCell:updateDraw()

end

function UnionDuplicateSceneTreasurePreviewCell:onInit()
	self:updateDraw()
end

function UnionDuplicateSceneTreasurePreviewCell:onEnterTransitionFinish()

end

function UnionDuplicateSceneTreasurePreviewCell:init()
	self:onInit()
	return self
end

function UnionDuplicateSceneTreasurePreviewCell:onExit()

end

function UnionDuplicateSceneTreasurePreviewCell:createCell()
	local cell = UnionDuplicateSceneTreasurePreviewCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
