--------------------------------------------------------------------------------------------------------------
--  说明：军团排行榜列表(副本，等级)
--------------------------------------------------------------------------------------------------------------
UnionRankListCell = class("UnionRankListCellClass", Window)
UnionRankListCell.__size = nil
function UnionRankListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		app.load("client.l_digital.cells.union.union_logo_icon_cell")
	else
		app.load("client.cells.union.union_logo_icon_cell")
	end
	 -- Initialize union rank list cell state machine.
    local function init_union_rank_list_cell_terminal()
	
		
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_rank_list_cell_terminal()

end

function UnionRankListCell:updateDraw()
	local root = self.roots[1]
	-- Panel_365
		--Text_274
	ccui.Helper:seekWidgetByName(root, "Text_4_10"):setString(self.example.union_president_name)
	ccui.Helper:seekWidgetByName(root, "Text_4_11"):setString(self.example.union_member)
	-- ccui.Helper:seekWidgetByName(root, "Text_16"):setString(self.example.union_watchword)
	ccui.Helper:seekWidgetByName(root, "Text_274_0"):setString(self.example.union_name)
	ccui.Helper:seekWidgetByName(root, "Text_274"):setString(self.example.union_level)
	local rankcount =tonumber(self.example.union_rank)
	ccui.Helper:seekWidgetByName(root, "Image_021"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_022"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_023"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_106"):setString("")
	if rankcount == 1 then
		ccui.Helper:seekWidgetByName(root, "Image_021"):setVisible(true)
	elseif rankcount== 2 then
		ccui.Helper:seekWidgetByName(root, "Image_022"):setVisible(true)
	elseif rankcount== 3 then
		ccui.Helper:seekWidgetByName(root, "Image_023"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Text_106"):setString(rankcount)
	end
	
	
	local icon = ccui.Helper:seekWidgetByName(root, "Panel_365")


	local quality = tonumber(self.example.union_icon)
	local kuang = tonumber(self.example.union_kuang)
	local cell = CnionLogoIconCell:createCell()
	cell:init(kuang,quality,nil)
	icon:removeAllChildren(true)
	icon:addChild(cell)
end

function UnionRankListCell:onInit()

	local csbUnionRankListCell= csb.createNode("legion/legion_rank_list.csb")
    local root = csbUnionRankListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	
	 local action = csb.createTimeline("legion/legion_rank_list.csb")
	 root:runAction(action)
	 action:play("list_view_cell_open", false)
	 
    self:addChild(csbUnionRankListCell)
	if UnionRankListCell.__size == nil then
		UnionRankListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	
	
	self:updateDraw()
end

function UnionRankListCell:onEnterTransitionFinish()

end

function UnionRankListCell:init(example,index,last)

	self.last = last
	self.example = example
	self.index = index
	self.activityIndex = activityIndex
	if index < 5 then
		self:onInit()
	end
	self:setContentSize(UnionRankListCell.__size)
	-- self:onInit()
	return self
end

function UnionRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/legion_list_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function UnionRankListCell:onExit()
	cacher.freeRef("legion/legion_list_list.csb", self.roots[1])
end

function UnionRankListCell:createCell()
	local cell = UnionRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
