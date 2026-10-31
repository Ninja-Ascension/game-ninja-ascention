----------------------------------------------------------------------------------------------------
-- 说明：竞技场兑换奖励list
----------------------------------------------------------------------------------------------------
AdventureArenaManagerExchangeList = class("AdventureArenaManagerExchangeListClass", Window)
AdventureArenaManagerExchangeList.__size = nil

function AdventureArenaManagerExchangeList:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.arenaInfo = nil
	self.index = 0
    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	app.load("client.adventure.cells.prop.adventure_new_prop_icon_cell")
	app.load("client.adventure.campaign.arena.AdventureArenaExchangeConfirmation")
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_arena_manager_hero_list_hero_list_terminal()
		local adventure_arena_manager_hero_list_hero_list_exchange_terminal = {
            _name = "adventure_arena_manager_hero_list_hero_list_exchange",
            _init = function (terminal)
                app.load("client.adventure.battle.AdventureBattle")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				 fwin:open(AdventureArenaExchangeConfirmation:new():init(cell.arenaInfo), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_arena_manager_hero_list_hero_list_exchange_terminal)
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_arena_manager_hero_list_hero_list_terminal()
end

function AdventureArenaManagerExchangeList:updateDraw()
	local root = self.roots[1]
	
end

function AdventureArenaManagerExchangeList:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_jingji_duihuan.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	-- 会显示2个 如果配置填了一个会出现问题
	local mouldid = dms.int(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.item_mould)
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	Panel_role:removeAllChildren(true)
	local nameHeroText = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	local namePropText = ccui.Helper:seekWidgetByName(root, "Text_propname")
	namePropText:setString("")
	namePropText:setString("")
	if dms.int(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.item_type) == 0 then--道具
		local cell = adventureNewPropIconCell:createCell()
		cell:init(0, {mould_id = mouldid}, 0, 0)
		Panel_role:addChild(cell)
		namePropText:setString(dms.string(dms["prop_mould"], mouldid, prop_mould.prop_name))
		ccui.Helper:seekWidgetByName(root, "Text_roleshuoming"):setString(dms.string(dms["prop_mould"], mouldid, prop_mould.remarks))
	elseif dms.int(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.item_type) == 1 then--武将
		local cell = AdventureHeroIconCell:createCell()
		cell:init(1, {ship_template_id = mouldid}, 1, 0, nil, nil, nil, nil, 0)
		Panel_role:addChild(cell)
		nameHeroText:setString(dms.string(dms["ship_mould"], mouldid, ship_mould.captain_name))
		ccui.Helper:seekWidgetByName(root, "Text_roleshuoming"):setString(dms.string(dms["ship_mould"], mouldid, ship_mould.introduce))
	end
	ccui.Helper:seekWidgetByName(root, "Text_xunzhang"):setString(dms.string(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.need_honor))
	if dms.int(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.ranking) == -1 then
		ccui.Helper:seekWidgetByName(root, "Image_jinbi_0"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_suipian_2"):setString(dms.string(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.reward_silver))
	else
		ccui.Helper:seekWidgetByName(root, "Image_jinbi_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_suipian_2"):setString(dms.string(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.ranking))
	end
	
	
	
	-- local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	-- Text_rolename:setString(self.arenaInfo.name)
	-- local Text_paiwei = ccui.Helper:seekWidgetByName(root, "Text_paiwei")
	-- Text_paiwei:setString(self.arenaInfo.rank)
	-- local Text_zhanli_paiwei = ccui.Helper:seekWidgetByName(root, "Text_zhanli_paiwei")
	-- Text_zhanli_paiwei:setString(self.arenaInfo.force)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xiaohao"),       nil, 
	{
		terminal_name = "adventure_arena_manager_hero_list_hero_list_exchange",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	
	-- Get size for root node.
	if AdventureArenaManagerExchangeList.__size == nil then
		local size = root:getContentSize()
		AdventureArenaManagerExchangeList.__size = size
	end

	self:updateDraw()
end

function AdventureArenaManagerExchangeList:onExit()
	cacher.freeRef("list/list_jingji_duihuan.csb", self.roots[1])
end

function AdventureArenaManagerExchangeList:init(temparenaInfo, drawIndex)
	self.arenaInfo = temparenaInfo
	-- if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	-- end

	self:setContentSize(AdventureArenaManagerExchangeList.__size)
	return self
end

function AdventureArenaManagerExchangeList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureArenaManagerExchangeList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_jingji_duihuan.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureArenaManagerExchangeList:createCell()
	local cell = AdventureArenaManagerExchangeList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

