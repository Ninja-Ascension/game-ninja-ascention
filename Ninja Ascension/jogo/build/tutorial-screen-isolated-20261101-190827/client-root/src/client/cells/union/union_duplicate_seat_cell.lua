--------------------------------------------------------------------------------------------------------------
--  说明：军团副本章节元素
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSeatCell = class("UnionDuplicateSeatCellClass", Window)
UnionDuplicateSeatCell.__sizeOne = nil
UnionDuplicateSeatCell.__sizeTwo = nil
UnionDuplicateSeatCell.__sizeThree = nil
UnionDuplicateSeatCell.__sizeFour = nil
function UnionDuplicateSeatCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.seatId = 0
	self.celltype = 0
end

function UnionDuplicateSeatCell:updateDraw()
	local root = self.roots[1]
	local open_scene_id = tonumber(_ED.union.union_current_scene_id) --当前章节
	local seatId = self.seatId--章节索引

	local Text_16_4 = ccui.Helper:seekWidgetByName(root,"Text_16_4")
	local scene_name = dms.string(dms["union_pve_scene"], self.seatId,union_pve_scene.scene_name)
	Text_16_4:setString("")
	Text_16_4:setString(scene_name)

	local Text_14_2 = ccui.Helper:seekWidgetByName(root,"Text_14_2")
	Text_14_2:setString("")
	Text_14_2:setString(_string_piece_info[97]..seatId.._string_piece_info[98])

	local Panel_3_67 = ccui.Helper:seekWidgetByName(root,"Panel_3_67")
	Panel_3_67:setVisible(true)

	local Image_10_4 = ccui.Helper:seekWidgetByName(root,"Image_10_4")
	if seatId < open_scene_id then
		Image_10_4:setVisible(true)
	else
		Image_10_4:setVisible(false)
	end
	local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")
 	Panel_role:removeBackGroundImage()
    Panel_role:setBackGroundImage(string.format("images/ui/pve_sn/union_pve_%d.png",seatId))

	local Panel_1 = ccui.Helper:seekWidgetByName(root,"Panel_1")
	if seatId == open_scene_id then
		Panel_1:setVisible(true)
	else
		Panel_1:setVisible(false)
	end

	--local Panel_level = ccui.Helper:seekWidgetByName(root,"Panel_level")	
	if seatId > open_scene_id then
		Panel_role:setColor(cc.c3b(50, 50, 50))
	else
		Panel_role:setColor(cc.c3b(255, 255, 255))
	end
end

function UnionDuplicateSeatCell:onInit()
	local filepath = string.format("legion/legion_pve_chapter_r_%d.csb",self.celltype)
    local root = cacher.createUIRef(filepath,"root")
    table.insert(self.roots, root)
    self:addChild(root)
    local Panel_125 = ccui.Helper:seekWidgetByName(root,"Panel_level")	
    if self.celltype == 1 and UnionDuplicateSeatCell.__sizeOne == nil then
		UnionDuplicateSeatCell.__sizeOne = Panel_125:getContentSize()
		self:setContentSize(UnionDuplicateSeatCell.__sizeOne)
	elseif self.celltype == 2 and UnionDuplicateSeatCell.__sizeTwo == nil then	
		UnionDuplicateSeatCell.__sizeTwo = Panel_125:getContentSize()
		self:setContentSize(UnionDuplicateSeatCell.__sizeTwo)
	elseif self.celltype == 3 and UnionDuplicateSeatCell.__sizeThree == nil then
		UnionDuplicateSeatCell.__sizeThree = Panel_125:getContentSize()
		self:setContentSize(UnionDuplicateSeatCell.__sizeThree)
	elseif self.celltype == 4 and UnionDuplicateSeatCell.__sizeFour == nil then
		UnionDuplicateSeatCell.__sizeFour = Panel_125:getContentSize()
		self:setContentSize(UnionDuplicateSeatCell.__sizeFour)
	end

	local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")
	fwin:addTouchEventListener(Panel_role,  nil, 
    {
        terminal_name = "union_duplicate_cell_enter_pve_scene",
        terminal_state = 0,
        _seat_id = self.seatId
    }, 
    nil, 0)
	self:updateDraw()
end

function UnionDuplicateSeatCell:onEnterTransitionFinish()
end

function UnionDuplicateSeatCell:init(seatId,index,celltype)
	local open_scene_id = tonumber(_ED.union.union_current_scene_id) + 1
	self.seatId = seatId
	self.celltype = celltype
	if celltype == 0 then
		self.celltype = 4
	end
	--if index ~= nil and (index <= open_scene_id and index >= open_scene_id - 8) then
		self:onInit()	
	--end	
	if celltype == 1 then
		self:setContentSize(UnionDuplicateSeatCell.__sizeOne)
	elseif celltype == 2 then
		self:setContentSize(UnionDuplicateSeatCell.__sizeTwo)
	elseif celltype == 3 then
		self:setContentSize(UnionDuplicateSeatCell.__sizeThree)
	elseif celltype == 4 then
		self:setContentSize(UnionDuplicateSeatCell.__sizeFour)
	end	
	return self
end

function UnionDuplicateSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionDuplicateSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local filepath = string.format("legion/legion_pve_chapter_r_%d.csb",self.celltype)
	cacher.freeRef(filepath, root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
	UnionDuplicateSeatCell.__sizeOne = nil
	UnionDuplicateSeatCell.__sizeTwo = nil
	UnionDuplicateSeatCell.__sizeThree = nil
	UnionDuplicateSeatCell.__sizeFour = nil
end
function UnionDuplicateSeatCell:onExit()
	local filepath = string.format("legion/legion_pve_chapter_r_%d.csb",self.celltype)
	cacher.freeRef(filepath, self.roots[1])
end

function UnionDuplicateSeatCell:createCell()
	local cell = UnionDuplicateSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
