----------------------------------------------------------------------------------------------------
-- 说明：排位赛list
----------------------------------------------------------------------------------------------------
AdventureArenaWarcraftListCell = class("AdventureArenaWarcraftListCellClass", Window)
AdventureArenaWarcraftListCell.__size = nil

function AdventureArenaWarcraftListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.warcraftInfo = nil
	self.index = 0
	self.bg_index = 0
	self.csbName = ""
    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
    app.load("client.adventure.utils.AdventureSprite")
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_warcraft_list_cell_terminal()
		local adventure_arena_warcraft_list_battle_terminal = {
            _name = "adventure_arena_warcraft_list_battle",
            _init = function (terminal)
                app.load("client.adventure.battle.AdventureBattle")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
	            local function responseFightCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                    		or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
                    		or __lua_project_id == __lua_project_yugioh 
                    		or __lua_project_id == __lua_project_warship_girl_b 
                    		then 
                    		app.load("client.battle.BattleStartEffect")
                    		fwin:cleanView(fwin._windows)
                    		local bse = BattleStartEffect:new()
							bse:init(_enum_fight_type._fight_type_107)
							fwin:open(bse, fwin._windows)
						elseif __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
	            			app.load("client.battle.BattleStartEffect")
							app.load("client.battle.fight.FightEnum")
	                        fwin:cleanView(fwin._windows)
							fwin:freeAllMemeryPool()
							local bse = BattleStartEffect:new()
							bse:init(_enum_fight_type._fight_type_107)
							fwin:open(bse, fwin._windows)
						else
							fwin:removeAll()
                        	cc.Director:getInstance():purgeCachedData()
       						_ED._battle_map_type = 1
                        	fwin:open(AdventureBattle:new():init(), fwin._background)	
                    	end
                       	
                    end
                end
 				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
 					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
 					or __lua_project_id == __lua_project_yugioh 
 					or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
 					or __lua_project_id == __lua_project_warship_girl_b 
 					then 
 					local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	 				
 					protocol_command.warcraft_fight.param_list = currentServerNumber .. "\r\n" .. cell.warcraftInfo.id .."\r\n" .. cell.warcraftInfo.server_number
                	NetworkManager:register(protocol_command.warcraft_fight.code, _ED.union_fight_url, nil, nil, instance, responseFightCallBack, false, nil)
				else
					protocol_command.warcraft_fight.param_list = "" .. cell.warcraftInfo.id
                	NetworkManager:register(protocol_command.warcraft_fight.code, nil, nil, nil, instance, responseFightCallBack, false, nil)
 				end
                
                
            end,
            _terminal = nil,
            _terminals = nil
        }

        --查看阵容
		local adventure_arena_warcraft_list_fighter_see_info_terminal = {
            _name = "adventure_arena_warcraft_list_fighter_see_info",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftFighterInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
                local function responseSeeInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureArenaWarcraftFighterInfo:new(),fwin._windows)        
                    end
                end
                
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_warship_girl_b 
					then 
					--暂时不做这个
 					-- local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
 					-- protocol_command.warcraft_see_user_formation.param_list = currentServerNumber .. "\r\n" .. cell.warcraftInfo.id .."\r\n" .. cell.warcraftInfo.server_number
      --           	NetworkManager:register(protocol_command.warcraft_see_user_formation.code, _ED.union_fight_url, nil, nil, instance, responseSeeInfoCallBack, false, nil)
				else
	                protocol_command.warcraft_see_user_formation.param_list = "" .. cell.warcraftInfo.id.."\r\n".. cell.warcraftInfo.player_type 
	                NetworkManager:register(protocol_command.warcraft_see_user_formation.code, nil, nil, nil, nil, responseSeeInfoCallBack, true, nil)
       			end
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_arena_warcraft_list_battle_terminal)
        state_machine.add(adventure_arena_warcraft_list_fighter_see_info_terminal)
       
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_warcraft_list_cell_terminal()
end

function AdventureArenaWarcraftListCell:updateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role")
	rolePanel:removeAllChildren(true)
	rolePanel:removeBackGroundImage()
	local is_digimon = true --数码宝贝
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		is_digimon = true
	else
		is_digimon = false
	end
	local bgPanel = ccui.Helper:seekWidgetByName(root, "Panel_list_bg")
	bgPanel:removeAllChildren(true)
	bgPanel:removeBackGroundImage()
	if zstring.tonumber(_ED.warcraft_info.current_state) == 1 or zstring.tonumber(_ED.warcraft_info.current_state) == 2 then 
		if is_digimon == true then 
			bgPanel:setBackGroundImage("images/ui/slots/pws_list_1.png")
		else
			bgPanel:setBackGroundImage("images/ui/bar/bar_list_04.png")	
		end
	else
		if is_digimon == true then 
			bgPanel:setBackGroundImage("images/ui/slots/pws_list.png")
		else
			bgPanel:setBackGroundImage("images/ui/bar/bar_list_03.png")
		end
	end

	if is_digimon == true then 
		app.load("client.cells.ship.ship_head_new_cell")
		local cell = ShipHeadNewCell:createCell()
		cell:init(self.warcraftInfo.picIndex,10)
		rolePanel:addChild(cell)
	else
		if zstring.tonumber(self.warcraftInfo.player_type) == 0 then 
			--rolePanel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(self.warcraftInfo.picIndex) ))	
			local armature1 = AdventureSpriteRole:create(zstring.tonumber(self.warcraftInfo.picIndex))
	    	armature1:setPosition(cc.p(rolePanel:getContentSize().width/2,-rolePanel:getContentSize().height/2))
	    	rolePanel:addChild(armature1)
		else
			if zstring.tonumber(self.warcraftInfo.picIndex) == 0 then 
				self.warcraftInfo.picIndex = 1
			end
			local armature1 = AdventureSpriteRole:create(zstring.tonumber(self.warcraftInfo.picIndex))
	    	armature1:setPosition(cc.p(rolePanel:getContentSize().width/2,-rolePanel:getContentSize().height/2))
	    	rolePanel:addChild(armature1)
		end
	end
	

	--背景
	local backgroundPanel = ccui.Helper:seekWidgetByName(root, "Panel_duanwei_di")
	backgroundPanel:removeAllChildren(true)
	local titleId = zstring.tonumber(self.warcraftInfo.titleId)
	local titletype = 1
	if titleId >= 1 and titleId <= 5 then 
		--青铜
		titletype = 1
	elseif titleId >= 6 and titleId <= 10 then 
		--白银
		titletype = 2
	elseif titleId >= 11 and titleId <= 15 then 
		--黄金
		titletype = 3
	elseif titleId >= 16 and titleId <= 20 then 
		--铂金
		titletype = 4
	elseif titleId >= 21 and titleId <= 25 then 
		--铂金
		titletype = 5
	elseif titleId >= 26 then 
		--大师
		titletype = 6
	end
	if zstring.tonumber(self.warcraftInfo.rank) == 1 then 
		titletype = 7
	end
	if zstring.tonumber(self.warcraftInfo.rank) == 2 then 
		titletype = 8
	end
	if zstring.tonumber(self.warcraftInfo.rank) == 3 then 
		titletype = 9
	end
	
	if is_digimon == true then 
		backgroundPanel:setBackGroundImage(string.format("images/ui/play/pws/arena_%s.png",""..titletype))
	else
		backgroundPanel:setBackGroundImage(string.format("images/ui/play/arena/arena_%s.png",""..titletype))
	end
	if is_digimon == true then 
		ccui.Helper:seekWidgetByName(root, "Text_rolename"):setString("S".. math.floor(tonumber(self.warcraftInfo.server_number)%1000) .. " " .. self.warcraftInfo.nickname)
	else
		ccui.Helper:seekWidgetByName(root, "Text_rolename"):setString("" .. self.warcraftInfo.nickname)
	end
	
	if  zstring.tonumber(self.warcraftInfo.rank) == 0  then 
		if is_digimon == true then 
			ccui.Helper:seekWidgetByName(root, "Text_paiwei"):setString(warcraft_tip[1])	
		else
			ccui.Helper:seekWidgetByName(root, "Text_paiwei"):setString(_string_piece_info[440])	
		end
	else
		ccui.Helper:seekWidgetByName(root, "Text_paiwei"):setString("" .. self.warcraftInfo.rank)	
	end
	
	local titleName = dms.string(dms["warcraft_mould"], self.warcraftInfo.titleId, warcraft_mould.title_name)
	ccui.Helper:seekWidgetByName(root, "Text_pw_name"):setString(titleName)

	local Text_duanwei = ccui.Helper:seekWidgetByName(root, "Text_duanwei")
	if Text_duanwei ~= nil then
		Text_duanwei:setString(titleName)
	end
	
	local fightButton = ccui.Helper:seekWidgetByName(root, "Button_3")
	if zstring.tonumber(self.warcraftInfo.fightState) == 0  then 
		fightButton:setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_yitiaozhan"):setVisible(false)
	else
		fightButton:setVisible(false)
		
		ccui.Helper:seekWidgetByName(root, "Text_yitiaozhan"):setVisible(true)

	end
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString("" .. self.warcraftInfo.fighting)
	else
		ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString("" .. getResourceValueToStringForAdventure(self.warcraftInfo.fighting))
	end
	
end

function AdventureArenaWarcraftListCell:onInit()
	self.roots = {}

	local root = cacher.createUIRef(self.csbName, "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"),       nil, 
	{
		terminal_name = "adventure_arena_warcraft_list_battle",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role"),       nil, 
	{
		terminal_name = "adventure_arena_warcraft_list_fighter_see_info",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	-- Get size for root node.
	if AdventureArenaWarcraftListCell.__size == nil then
		local size = root:getContentSize()
		AdventureArenaWarcraftListCell.__size = size
	end

	self:updateDraw()
end

function AdventureArenaWarcraftListCell:onExit()
	cacher.freeRef(self.csbName, self.roots[1])
	self.roots = nil
end

function AdventureArenaWarcraftListCell:init(temparenaInfo, drawIndex,bgIndex)
	self.warcraftInfo = temparenaInfo
	self.index = drawIndex
	self.bg_index = bgIndex
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		self.csbName = "campaign/Arena/list_jingji_paiweisai_0.csb"
	else
		self.csbName = "list/list_jingji_paiweisai_0.csb"
	end
	-- if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	-- end
	
	self:setContentSize(AdventureArenaWarcraftListCell.__size)
	return self
end

function AdventureArenaWarcraftListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureArenaWarcraftListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef(self.csbName, root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureArenaWarcraftListCell:createCell()
	local cell = AdventureArenaWarcraftListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

