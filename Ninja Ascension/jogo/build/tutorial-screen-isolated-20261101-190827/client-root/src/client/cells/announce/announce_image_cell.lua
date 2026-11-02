----------------------------------------------------------------------------------------------------
-- 说明：公告大图
-------------------------------------------------------------------------------------------------------
AnnounceImageCell = class("AnnounceImageCellClass", Window)

function AnnounceImageCell:ctor()
    self.super:ctor()

	self.roots = {}
	
	self.image_path = nil
end

function AnnounceImageCell:onUpdateDraw()
	local root = self.roots[1]
	root:setBackGroundImage(self.image_path)
end

function AnnounceImageCell:onEnterTransitionFinish()
	local filePath = nil
	filePath = "game_announcement/game_announcement_list_2.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("Panel_1"):getChildByName("Panel_2")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self:setContentSize(root:getContentSize())
	
	self:onUpdateDraw()
end

function AnnounceImageCell:onExit()

end

function AnnounceImageCell:init(_titleImage)
	self.image_path = _titleImage
end

function AnnounceImageCell:createCell()
	local cell = AnnounceImageCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end