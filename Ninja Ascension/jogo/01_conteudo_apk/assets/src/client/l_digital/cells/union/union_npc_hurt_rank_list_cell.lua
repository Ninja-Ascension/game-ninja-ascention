--------------------------------------------------------------------------------------------------------------
--  说明：公会副本npc成员伤害
--------------------------------------------------------------------------------------------------------------
UnionNpcHurtRankListCell = class("UnionNpcHurtRankListCellClass", Window)
UnionNpcHurtRankListCell.__size = nil
function UnionNpcHurtRankListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.l_digital.cells.union.union_logo_icon_cell")
	 -- Initialize union rank list cell state machine.
    local function init_union_npc_hurt_rank_list_cell_terminal()

        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_npc_hurt_rank_list_cell_terminal()

end

function UnionNpcHurtRankListCell:updateDraw()
	local root = self.roots[1]
	local Image_bg = ccui.Helper:seekWidgetByName(root, "Image_bg")
	if tonumber(self.index)%2 == 0 then
		Image_bg:setVisible(false)
	else
		Image_bg:setVisible(true)
	end

	local Text_hurt = ccui.Helper:seekWidgetByName(root, "Text_hurt")
	Text_hurt:setString(self.example.user_hurt)

	local Text_wj_name = ccui.Helper:seekWidgetByName(root, "Text_wj_name")
	Text_wj_name:setString(self.example.user_name)

	for i=1, 3 do
		ccui.Helper:seekWidgetByName(root, "Image_ranking_"..i):setVisible(false)
	end

	if tonumber(self.index) <= 3 then
		ccui.Helper:seekWidgetByName(root, "Image_ranking_"..tonumber(self.index)):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_ranking"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Text_ranking"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_ranking"):setString(self.index)
	end
end

function UnionNpcHurtRankListCell:onInit()

	local csbUnionNpcHurtRankListCell= csb.createNode("legion/sm_legion_pve_window_hurt_rank_list.csb")
    local root = csbUnionNpcHurtRankListCell:getChildByName("root")
    table.insert(self.roots, root)
	 
    self:addChild(csbUnionNpcHurtRankListCell)
	if UnionNpcHurtRankListCell.__size == nil then
		UnionNpcHurtRankListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	

	self:updateDraw()
end

function UnionNpcHurtRankListCell:onEnterTransitionFinish()

end

function UnionNpcHurtRankListCell:init(example,index,last)
	self.example = example
	self.index = index
	if index < 5 then
		self:onInit()
	end
	self:setContentSize(UnionNpcHurtRankListCell.__size)
	-- self:onInit()
	return self
end

function UnionNpcHurtRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionNpcHurtRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_pve_window_hurt_rank_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function UnionNpcHurtRankListCell:onExit()
	cacher.freeRef("legion/sm_legion_pve_window_hurt_rank_list.csb", self.roots[1])
end

function UnionNpcHurtRankListCell:createCell()
	local cell = UnionNpcHurtRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
