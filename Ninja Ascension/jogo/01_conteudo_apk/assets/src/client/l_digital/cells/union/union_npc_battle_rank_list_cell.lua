--------------------------------------------------------------------------------------------------------------
--  说明：公会副本npc战斗排行榜
--------------------------------------------------------------------------------------------------------------
UnionNpcBattleRankListCell = class("UnionNpcBattleRankListCellClass", Window)
UnionNpcBattleRankListCell.__size = nil
function UnionNpcBattleRankListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.l_digital.cells.union.union_logo_icon_cell")
	 -- Initialize union rank list cell state machine.
    local function init_union_npc_battle_rank_list_cell_terminal()

        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_npc_battle_rank_list_cell_terminal()

end

function UnionNpcBattleRankListCell:updateDraw()
	local root = self.roots[1]
	local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	for i=1,3 do
		ccui.Helper:seekWidgetByName(root, "Image_ranking_"..i):setVisible(false)
	end
	if tonumber(self.index) <= 3 then
		ccui.Helper:seekWidgetByName(root, "Image_ranking_"..tonumber(self.index)):setVisible(true)
		Text_ranking:setString("")
	else
		Text_ranking:setString(self.index)
	end

	local Panel_legion_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_icon") 

	local quality = tonumber(self.example.union_icon)
	local cell = CnionLogoIconCell:createCell()
	cell:init(1,quality,1)
	Panel_legion_icon:removeAllChildren(true)
	Panel_legion_icon:addChild(cell)

	local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name") 
	Text_legion_name:setString(self.example.union_name)

	local Text_tg_time = ccui.Helper:seekWidgetByName(root, "Text_tg_time")
	if zstring.tonumber(self.example.kill_time) == -1 then
		Text_tg_time:setString("")
	else
		Text_tg_time:setString(os.date("%Y".."-".."%m".."-".."%d".." ".."%H"..":".."%m", zstring.tonumber(self.example.kill_time)/1000))
	end
end

function UnionNpcBattleRankListCell:onInit()

	local csbUnionNpcBattleRankListCell= csb.createNode("legion/sm_legion_pve_window_rank_list.csb")
    local root = csbUnionNpcBattleRankListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	
	 local action = csb.createTimeline("legion/sm_legion_pve_window_rank_list.csb")
	 root:runAction(action)
	 
    self:addChild(csbUnionNpcBattleRankListCell)
	if UnionNpcBattleRankListCell.__size == nil then
		UnionNpcBattleRankListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	

	self:updateDraw()
end

function UnionNpcBattleRankListCell:onEnterTransitionFinish()

end

function UnionNpcBattleRankListCell:init(example,index,last)
	self.example = example
	self.index = index
	if index < 5 then
		self:onInit()
	end
	self:setContentSize(UnionNpcBattleRankListCell.__size)
	-- self:onInit()
	return self
end

function UnionNpcBattleRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionNpcBattleRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_pve_window_rank_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function UnionNpcBattleRankListCell:onExit()
	cacher.freeRef("legion/sm_legion_pve_window_rank_list.csb", self.roots[1])
end

function UnionNpcBattleRankListCell:createCell()
	local cell = UnionNpcBattleRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
