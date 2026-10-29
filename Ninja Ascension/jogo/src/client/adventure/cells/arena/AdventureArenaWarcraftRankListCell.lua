----------------------------------------------------------------------------------------------------
-- 说明：排行榜列表
----------------------------------------------------------------------------------------------------
AdventureArenaWarcraftRankListCell = class("AdventureArenaWarcraftRankListCellClass", Window)
AdventureArenaWarcraftRankListCell.__size = nil

function AdventureArenaWarcraftRankListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.index = 1
	self.current_type = 0 -- 1 本周 2 上周
	self.rankInfo = nil
	app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_warcraft_shop_list_cell_terminal()
		-- local adventure_arena_warcraft_shop_buy_terminal = {
  --           _name = "adventure_arena_warcraft_shop_buy",
  --           _init = function (terminal)
  --               app.load("client.adventure.reward.AdventureTipReward")
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
		-- 		local cell = params._datas.cell
	 --            local function responseBuyCallBack(response)
  --                   if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
  --                   	local rewardlist = getSceneReward(61)
  --                   	if rewardlist ~= nil then 
  --                   		fwin:open(AdventureTipReward:new():init(rewardlist), fwin._windows)
  --                   	end
  --              			response.node:updateDraw()
  --                   end
  --               end
 
  --               protocol_command.warcraft_shop_buy.param_list = "" ..cell.current_type .. "\r\n".. cell.index
  --               NetworkManager:register(protocol_command.warcraft_shop_buy.code, nil, nil, nil, cell, responseBuyCallBack, false, nil)
            
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }
	
  --       state_machine.add(adventure_arena_warcraft_shop_buy_terminal)

  --       state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_warcraft_shop_list_cell_terminal()
end

function AdventureArenaWarcraftRankListCell:updateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString("".. self.rankInfo.fighting)
	ccui.Helper:seekWidgetByName(root, "Text_rolename"):setString(self.rankInfo.nickname)
	local titleText = ccui.Helper:seekWidgetByName(root, "Text_paiwei")
	titleText:setString(dms.string(dms["warcraft_mould"], self.rankInfo.titleId, warcraft_mould.title_name))-- 当前段位
	local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role")
	rolePanel:removeAllChildren(true)
	rolePanel:removeBackGroundImage()
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		app.load("client.cells.ship.ship_head_new_cell")
		local cell = ShipHeadNewCell:createCell()
		cell:init(self.rankInfo.picIndex,10)
		rolePanel:addChild(cell)
		local num = math.floor(tonumber(self.rankInfo.server_number)%1000)
		ccui.Helper:seekWidgetByName(root, "Text_rolename"):setString("S"..num.." "..self.rankInfo.nickname)
	else
		local cell = AdventureHeroIconCell:createCell()
		cell:init(0, {ship_template_id = self.rankInfo.picIndex}, 1, 0, nil, nil, nil, nil, 0)
		rolePanel:addChild(cell)
		ccui.Helper:seekWidgetByName(root, "Text_rolename"):setString(self.rankInfo.nickname)
	end
	
	local numPanel = ccui.Helper:seekWidgetByName(root, "Panel_number")
	numPanel:removeAllChildren(true)
	numPanel:removeBackGroundImage()
	titleText:setColor((cc.c3b(0, 255, 0)))
	local rankText = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1")
	if zstring.tonumber(self.rankInfo.rank) <= 3 and zstring.tonumber(self.rankInfo.rank) then 
		numPanel:setBackGroundImage(string.format("images/ui/number/ranking_%d.png", zstring.tonumber(self.rankInfo.rank)))	
		rankText:setVisible(false)
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			titleText:setString(warcraft_tip[9 + zstring.tonumber(self.rankInfo.rank)])
		else
			titleText:setString(_string_piece_info[449 + zstring.tonumber(self.rankInfo.rank)])
		end
		
		titleText:setColor((cc.c3b(255, 0, 0)))
	else
		rankText:setVisible(true)
		rankText:setString(""..self.rankInfo.rank)
		if zstring.tonumber(self.rankInfo.titleId) == 26 then 
			titleText:setColor((cc.c3b(255, 255, 0)))	
		end
	end
	
end

function AdventureArenaWarcraftRankListCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_pws_phb.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	-- Get size for root node.
	if AdventureArenaWarcraftRankListCell.__size == nil then
		local size = root:getContentSize()
		AdventureArenaWarcraftRankListCell.__size = size
	end

	self:updateDraw()
end

function AdventureArenaWarcraftRankListCell:onExit()
	cacher.freeRef("list/list_pws_phb.csb", self.roots[1])
	self.roots = nil
end

function AdventureArenaWarcraftRankListCell:init(rankInfo,drawIndex)
	self.rankInfo = rankInfo
	self.index = drawIndex
	--if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	--end

	self:setContentSize(AdventureArenaWarcraftRankListCell.__size)
	return self
end

function AdventureArenaWarcraftRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureArenaWarcraftRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_pws_phb.csb", root)
	
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureArenaWarcraftRankListCell:createCell()
	local cell = AdventureArenaWarcraftRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

