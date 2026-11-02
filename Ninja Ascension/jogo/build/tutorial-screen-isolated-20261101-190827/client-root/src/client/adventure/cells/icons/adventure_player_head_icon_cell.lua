----------------------------------------------------------------------------------------------------
-- 说明：好友列表项
----------------------------------------------------------------------------------------------------
AdventurePlayerHeadIconCell = class("AdventurePlayerHeadIconCellClass", Window)

function AdventurePlayerHeadIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.headImageId = 0
	
	-- Initialize adventure player head icon cell state machine.
	local function init_adventure_player_head_icon_cell_terminal()

        state_machine.init()
	end

	-- call func init adventure player head icon cell state machine.
	init_adventure_player_head_icon_cell_terminal()
end

function AdventurePlayerHeadIconCell:onEnterTransitionFinish()

end

function AdventurePlayerHeadIconCell:onInit()
	local csbAdventurePlayerHeadIconCell = csb.createNode("icon/item_role.csb")
 	local root = csbAdventurePlayerHeadIconCell:getChildByName("root")
    table.insert(self.roots, root)

    root:removeFromParent(false)
 	self:addChild(root)
end

function AdventurePlayerHeadIconCell:onExit()

end

function AdventurePlayerHeadIconCell:init(headImageId)
	self.headImageId = headImageId
	self:onInit()
	return self
end

function AdventurePlayerHeadIconCell:createCell()
	local cell = AdventurePlayerHeadIconCell:new()
	-- cell:registerOnNodeEvent(cell)
	return cell
end

