--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅动态时间
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingTrendsTimesCell = class("UnionTheMeetingTrendsTimesCellClass", Window)
UnionTheMeetingTrendsTimesCell.__size = nil

function UnionTheMeetingTrendsTimesCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.infoData = nil
	
	 -- Initialize union the meeting  trends list cell state machine.
    local function init_union_the_meeting_trends_other_cell_terminal()
		
        state_machine.init()
    end
    -- call func init union the meeting  trends list cell state machine.
    init_union_the_meeting_trends_other_cell_terminal()

end

function UnionTheMeetingTrendsTimesCell:updateDraw()
	local root = self.roots[1]
	

end

function UnionTheMeetingTrendsTimesCell:onInit()
	local root = cacher.createUIRef("legion/legion_pro_hall_dongtai_list_date.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    if UnionTheMeetingTrendsTimesCell.__size == nil then
        UnionTheMeetingTrendsTimesCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function UnionTheMeetingTrendsTimesCell:onEnterTransitionFinish()

end

function UnionTheMeetingTrendsTimesCell:init(infoData, index)
	self.infoData = infoData
    self:onInit()
	self:setContentSize(UnionTheMeetingTrendsTimesCell.__size)
	return self
end

function UnionTheMeetingTrendsTimesCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionTheMeetingTrendsTimesCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    cacher.freeRef("legion/legion_pro_hall_dongtai_list_date.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function UnionTheMeetingTrendsTimesCell:onExit()
	cacher.freeRef("legion/legion_pro_hall_dongtai_list_date.csb", self.roots[1])
end

function UnionTheMeetingTrendsTimesCell:createCell()
	local cell = UnionTheMeetingTrendsTimesCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
