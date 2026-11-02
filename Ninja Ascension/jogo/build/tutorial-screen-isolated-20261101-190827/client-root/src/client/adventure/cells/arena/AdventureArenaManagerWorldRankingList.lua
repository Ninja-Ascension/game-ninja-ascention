----------------------------------------------------------------------------------------------------
-- 说明：世界排名的list
----------------------------------------------------------------------------------------------------
AdventureArenaManagerWorldRankingList = class("AdventureArenaManagerWorldRankingListClass", Window)
AdventureArenaManagerWorldRankingList.__size = nil

function AdventureArenaManagerWorldRankingList:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.arenaInfo = nil
	self.index = 0
    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_arena_manager_world_ranking_list_terminal()
		
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_arena_manager_world_ranking_list_terminal()
end

function AdventureArenaManagerWorldRankingList:updateDraw()
	local root = self.roots[1]
	
end

function AdventureArenaManagerWorldRankingList:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_jingji_shijiepm.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	local cell = AdventureHeroIconCell:createCell()
	Panel_role:removeAllChildren(true)
	cell:init(0, {ship_template_id = self.arenaInfo.user_template[1]}, 1, 0, nil, nil, nil, nil, 0)
	Panel_role:addChild(cell)
	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	Text_rolename:setString(self.arenaInfo.user_name)
	local Text_paiwei = ccui.Helper:seekWidgetByName(root, "Text_paiwei")--奖励
	Text_paiwei:setString(self.arenaInfo.user_reward_reputation)
	local Text_zhanli_jinji = ccui.Helper:seekWidgetByName(root, "Text_zhanli_jinji")--战力
	Text_zhanli_jinji:setString(self.arenaInfo.user_reward_gold)
	local Text_mingci_jinji = ccui.Helper:seekWidgetByName(root, "Text_mingci_jinji")
	if zstring.tonumber(self.arenaInfo.user_rank) > 3 then
		ccui.Helper:seekWidgetByName(root, "Image_mingci_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_mingci_2"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Image_mingci_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_mingci_2"):setVisible(true)
	end
	Text_mingci_jinji:setString(self.arenaInfo.user_rank)
	
	-- Get size for root node.
	if AdventureArenaManagerWorldRankingList.__size == nil then
		local size = root:getContentSize()
		AdventureArenaManagerWorldRankingList.__size = size
	end

	self:updateDraw()
end

function AdventureArenaManagerWorldRankingList:onExit()
	cacher.freeRef("list/list_jingji_shijiepm.csb", self.roots[1])
end

function AdventureArenaManagerWorldRankingList:init(temparenaInfo, drawIndex)
	self.arenaInfo = temparenaInfo
	-- if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	-- end

	self:setContentSize(AdventureArenaManagerWorldRankingList.__size)
	return self
end

function AdventureArenaManagerWorldRankingList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureArenaManagerWorldRankingList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_jingji_shijiepm.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureArenaManagerWorldRankingList:createCell()
	local cell = AdventureArenaManagerWorldRankingList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

