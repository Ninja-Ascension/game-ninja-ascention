----------------------------------------------------------------------------------------------------
-- 说明：选择上阵战宠
-------------------------------------------------------------------------------------------------------

PetFormationChoiceWear = class("PetFormationChoiceWearClass", Window)
   
function PetFormationChoiceWear:ctor()
    self.super:ctor()
	self.roots = {}
	self.current_type = 0
	self.enum_type = {
		_PET_FORMATION_INFO = 1,	-- 宠物信息中弹出
		_PET_FORMATION = 2,	-- 阵容中弹出
		_PET_FORMATION_BATTLE = 3,--布阵时换宠
		_PET_EQUIP = 4,--驯养
	}
	self._data = nil
	
	self.isShowFightHero = false
	self.shipId = nil
	self.chooseShips = {}

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	
    local function init_pet_formation_choice_terminal()
		
		local pet_formation_choice_back_terminal = {
            _name = "pet_formation_choice_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				state_machine.excute("menu_show_event", 0, "menu_show_event.")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local request_choice_pet_the_battle_terminal = {
            _name = "request_choice_pet_the_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.current_type == instance.enum_type._THE_BATTLE_RESOURCE_PARTNERS then
            		state_machine.excute("secret_formationChange_add_role_to_formation", 0, params.ship_id.."|"..instance._data)
					fwin:close(instance)
				else
					state_machine.excute("choice_pet_battle_request", 0, params.ship_id.."|"..instance._data)
					fwin:close(instance)
					state_machine.excute("menu_show_event", 0, "menu_show_event.")
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local request_choice_pet_the_partners_terminal = {
            _name = "request_choice_pet_the_partners",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("choice_pet_partners_request", 0, params.ship_id.."|"..instance._data)
				fwin:close(instance)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pet_choice_show_fight_hero_terminal = {
            _name = "pet_choice_show_fight_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
				if instance.isShowFightHero == false then
					if _ED.formation_pet_id ~= nil and _ED.formation_pet_id ~= 0 then
						local listview = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_list")
						local cell = PetFormationChoiceWear:createHeroWear(_ED.user_ship["".. _ED.formation_pet_id],self.current_type, nil, 0)
						
						listview:insertCustomItem(cell, 0)
					end
					instance.isShowFightHero = true
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(false)
				elseif instance.isShowFightHero == true then
					if _ED.formation_pet_id ~= nil and _ED.formation_pet_id ~= 0 then
						local listview = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_list")
						listview:removeItem(0)
					end
					instance.isShowFightHero = false
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(true)
				end
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

		local request_choice_pet_update_terminal = {
            _name = "request_choice_pet_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:onUpdateDraw()
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(pet_formation_choice_back_terminal)
		state_machine.add(request_choice_pet_the_battle_terminal)
		state_machine.add(request_choice_pet_the_partners_terminal)
		state_machine.add(pet_choice_show_fight_hero_terminal)
		state_machine.add(request_choice_pet_update_terminal)
        state_machine.init()
    end

    init_pet_formation_choice_terminal()
end

function PetFormationChoiceWear:sortAnother(ship)
	return false
end

--上阵排序
function PetFormationChoiceWear:getSortedHeroes()
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end

	local tSortedPets = {}
	-- 上阵宠物数组
	local arrBusyPets = {}
	-- 各星级宠物数组
	local arrStarLevelpetsWhite = {}--白
	local arrStarLevelpetsGreen = {}--绿
	local arrStarLevelpetsKohlrabiblue= {}--蓝
	local arrStarLevelpetsPurple = {}--紫
	local arrStarLevelpetsOrange = {}--橙
	local arrStarLevelpetsRed = {}--红
	local arrStarLevelpetsGold = {}--金
	-- 主角放在第一位

	for i, ship in pairs(_ED.user_ship) do
		if ship.ship_id ~= nil then
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			local isResource = false
			local heroBaseTemplate = dms.atoi(shipData,ship_mould.base_mould)
			
			if zstring.tonumber(_ED.formation_pet_id) == zstring.tonumber(ship.ship_id) then
				--上阵英雄
				isResource = true
			end
			if dms.atoi(shipData, ship_mould.captain_type) == 3 then
				--驯养排序
				if self.current_type == 4 then
					for k,v in pairs(_ED.user_ship_equip_pet) do
						local petId = "" .._ED.user_ship[""..v].pet_equip_id
						local petData = dms.element(dms["ship_mould"],_ED.user_ship[petId].ship_template_id)
						local petBaseTemplate = dms.atoi(petData,ship_mould.base_mould)
						if zstring.tonumber(v) == zstring.tonumber(ship.ship_id)
							or heroBaseTemplate == petBaseTemplate
						 then 
							isResource = true
							break
						end
					end
				else
					--驯养的
					if zstring.tonumber(ship.pet_equip_ship_id) > 0 then 
						table.insert(arrBusyPets, ship)
						isResource = true
					end
				end
				if isResource == false then
					if dms.atoi(shipData, ship_mould.ship_type) == 0 then
						table.insert(arrStarLevelpetsWhite, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
						table.insert(arrStarLevelpetsGreen, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
						table.insert(arrStarLevelpetsKohlrabiblue, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
						table.insert(arrStarLevelpetsPurple, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
						table.insert(arrStarLevelpetsOrange, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
						table.insert(arrStarLevelpetsRed, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
						table.insert(arrStarLevelpetsGold, ship)
					end 
				end
			end
		end
	end
	table.sort(arrBusyPets, fightingCapacity)
	table.sort(arrStarLevelpetsWhite, fightingCapacity)
	table.sort(arrStarLevelpetsGreen, fightingCapacity)
	table.sort(arrStarLevelpetsKohlrabiblue, fightingCapacity)
	table.sort(arrStarLevelpetsPurple, fightingCapacity)
	table.sort(arrStarLevelpetsOrange, fightingCapacity)
	table.sort(arrStarLevelpetsRed, fightingCapacity)
	table.sort(arrStarLevelpetsGold, fightingCapacity)
	-- -- 把已排序好的上阵宠物加入到 宠物排序数组中
	for i=1, #arrBusyPets do
		table.insert(tSortedPets, arrBusyPets[i])
	end
	for i=1, #arrStarLevelpetsGold do
		table.insert(tSortedPets, arrStarLevelpetsGold[i])
	end
	for i=1, #arrStarLevelpetsRed do
		table.insert(tSortedPets, arrStarLevelpetsRed[i])
	end
	for i=1, #arrStarLevelpetsOrange do
		table.insert(tSortedPets, arrStarLevelpetsOrange[i])
	end
	for i=1, #arrStarLevelpetsPurple do
		table.insert(tSortedPets, arrStarLevelpetsPurple[i])
	end
	for i=1, #arrStarLevelpetsKohlrabiblue do
		table.insert(tSortedPets, arrStarLevelpetsKohlrabiblue[i])
	end
	for i=1, #arrStarLevelpetsGreen do
		table.insert(tSortedPets, arrStarLevelpetsGreen[i])
	end
	for i=1, #arrStarLevelpetsWhite do
		table.insert(tSortedPets, arrStarLevelpetsWhite[i])
	end
	
	return tSortedPets
end

function PetFormationChoiceWear.loading(texture)
	local myListView = PetFormationChoiceWear.myListView
	local hero_id = nil
	if PetFormationChoiceWear._self.chooseShips ~= nil then 
		hero_id = PetFormationChoiceWear._self.chooseShips.ship_id
	end

	if myListView ~= nil then
		local cell = PetFormationChoiceWear:createHeroWear(PetFormationChoiceWear.tSortedHeroes[PetFormationChoiceWear.asyncIndex],
			PetFormationChoiceWear._self.current_type,hero_id, PetFormationChoiceWear.asyncIndex)
		table.insert(PetFormationChoiceWear._self.roots, cell.roots[1])
		myListView:addChild(cell)
		PetFormationChoiceWear.asyncIndex = PetFormationChoiceWear.asyncIndex + 1
	end
end

function PetFormationChoiceWear:createHeroWear(ship,_type,id, index)
	local cell = PetFormationWearListCell:createCell()
	cell:init(ship,_type,id, index)
	return cell
end

function PetFormationChoiceWear:onUpdateDraw()
	local root = self.roots[1]
	
	ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
	
	local listview = ccui.Helper:seekWidgetByName(root, "ListView_list")

	ccui.Helper:seekWidgetByName(root, "Text_words"):setString(_pet_tipString_info[3])
	listview:removeAllItems()
	
	PetFormationChoiceWear._self = self
	PetFormationChoiceWear.myListView = listview
	PetFormationChoiceWear.tSortedHeroes = self:getSortedHeroes()
	PetFormationChoiceWear.asyncIndex = 1

	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	for i, v in ipairs(PetFormationChoiceWear.tSortedHeroes) do
		self.loading(nil)
	end
	
	listview:requestRefreshView()

	self.currentListView = listview
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function PetFormationChoiceWear:onUpdate(dt)
	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.currentListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function PetFormationChoiceWear:onEnterTransitionFinish()
	app.load("client.cells.pet.pet_formation_wear_list_cell")
    local csbEquipStorage = csb.createNode("packs/HeroStorage/generals_Choice.csb")
	self:addChild(csbEquipStorage)
	self.roots = {}
	local root = csbEquipStorage:getChildByName("root")
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fanhui_lwj"), nil, {terminal_name = "pet_formation_choice_back", terminal_state = 0, _data = nil, isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_Check"), nil, {terminal_name = "pet_choice_show_fight_hero", terminal_state = 0}, nil, 0)
	self:onUpdateDraw()
end

function PetFormationChoiceWear:init(_type, choose_ships)
	--print("-----------------------------------------------------------",_ship_id)
	self.current_type = _type
	if choose_ships ~= nil then
		self.chooseShips = choose_ships
	end
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
end

function PetFormationChoiceWear:onExit()
	PetFormationChoiceWear.myListView = nil
	PetFormationChoiceWear.asyncIndex = 1
	state_machine.remove("pet_formation_choice_back")
	state_machine.remove("request_choice_pet_the_battle")
	state_machine.remove("pet_choice_show_fight_hero")
	state_machine.remove("request_choice_pet_update")
	--state_machine.remove("choice_pet_battle_request")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

function PetFormationChoiceWear:createCell()
	local Equip = PetFormationChoiceWear:new()
	Equip:registerOnNodeEvent(Equip)
	return Equip
end
