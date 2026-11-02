----------------------------------------------------------------------------------------------------
-- 说明：宠物界面滑动层
-- 创建时间
-- 作者：李潮
-------------------------------------------------------------------------------------------------------
PetListView = class("PetListViewClass", Window)
   
function PetListView:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.tSortedPets = {}
	
	---------------------------------------------------------------------------
	-- 用于下拉效果
	---------------------------------------------------------------------------
	self.isRunning = false
	
	self.expansionaryIndex = nil
	
	self.runningExpansionCell = nil
	self.runningExpansionCellHeight = 0
	---------------------------------------------------------------------------
	self._empty = nil
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	self.formationCell = nil  -- 上阵的CELL
	app.load("client.cells.pet.pet_seat_cell")
	app.load("client.utils.StorageDialog")
    local function init_pet_list_view_terminal()
		-- 宠物数量显示
		local pet_show_hero_counts_terminal = {
            _name = "pet_show_hero_counts",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local usedheroStorageNumber = 0
				local openheroStorageNumber = "0"
				for i, hero in pairs(_ED.user_ship) do
					if hero.ship_id ~= nil then
						local shipData = dms.element(dms["ship_mould"], hero.ship_template_id)
						if dms.atoi(shipData, ship_mould.captain_type) == 3 then
							usedheroStorageNumber = usedheroStorageNumber + 1
						end
					end
				end
				if usedheroStorageNumber == 0 then 
					instance:onDrawEmptyStates(true)
				else
					instance:onDrawEmptyStates(false)
				end
				openheroStorageNumber = _ED.pet_use
				ccui.Helper:seekWidgetByName(instance.roots[1], "Label_5075"):setString(usedheroStorageNumber.."/"..openheroStorageNumber)
				return true
			end,
            _terminal = nil,
            _terminals = nil
        }
		
		--新增宠物
		local pet_list_view_insert_cell_terminal = {
            _name = "pet_list_view_insert_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local listIndex = instance:getListIndexByShipId(instance:getSortedPets(), params)
				if listIndex ~= nil then
					local cell = PetSeatCell:createCell()
					cell:init(_ED.user_ship[""..params], nil, 0)
					instance:insertCell(cell, listIndex)
				end
				_ED.recruit_success_ship_ids = ""
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pet_list_view_remove_cell_terminal = {
            _name = "pet_list_view_remove_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				for i, v in pairs(params) do
					instance:removeCellByShipId(v.ship_id)
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pet_list_view_update_cell_terminal = {
            _name = "pet_list_view_update_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateCellByShipId(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--下拉动画
		local pet_expansion_action_start_terminal = {
            _name = "pet_expansion_action_start",
            _init = function (terminal) 
                app.load("client.cells.pet.pet_expansion_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isRunning == true or params._datas.cell.heroInstance == nil then
					return
				end
			
				local _ship_id = params._datas.cell.heroInstance.ship_id
			
				local _PetListView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_25081")
				local _listIndex = instance:getListIndexByShipId(instance:getSortedPets(), _ship_id)
				local _cell = _PetListView:getItem(_listIndex)

				local expansion_pad = ccui.Helper:seekWidgetByName(_cell.roots[1], "Panel_xiala")
				if expansion_pad == nil then 
					return
				end
				
				local offsetY = expansion_pad:getParent():getContentSize().height - 30 / CC_CONTENT_SCALE_FACTOR()

				local isBottom = false
				local function expansionOn()
					local function expansionActionOverCallback()
						instance.isRunning = false
						if isBottom == true then
							_PetListView:getInnerContainer():setPositionY(0)
						end
						isBottom = false
					end

					instance.isRunning = true 
					instance.expansionaryIndex = _listIndex
					instance.runningExpansionCell = _cell
					instance.runningExpansionCell:retain()
					instance.runningExpansionCellHeight = instance.runningExpansionCell:getContentSize().height
					
					ccui.Helper:seekWidgetByName(params._datas.cell.roots[1], "Button_xia"):setVisible(false)
					ccui.Helper:seekWidgetByName(params._datas.cell.roots[1], "Button_shou"):setVisible(true)
					
					expansion_pad:removeAllChildren(true)
					local expansionCell = PetExpansionsCell:createCell()
					expansionCell:init(params._datas.cell.heroInstance,params._datas.cell)
					expansion_pad:addChild(expansionCell)
					_cell.roots[2] = expansionCell.roots[1]

			
					expansion_pad:getParent():runAction(cc.Sequence:create(
										cc.MoveBy:create(0.5, cc.p(0, offsetY)), 
										cc.DelayTime:create(0.05),
										cc.CallFunc:create(expansionActionOverCallback)
										))
					expansion_pad:runAction(cc.Sequence:create(cc.MoveBy:create(0.5, cc.p(0, -offsetY))))
				end
				
				local function expansionOff()
					local function expansionActionOverCallback1()
						instance.isRunning = false
						instance.expansionaryIndex = nil
						instance.runningExpansionCell:release()
						instance.runningExpansionCell = nil
						expansion_pad:removeAllChildren(true)
					end
				
					instance.isRunning = true 
					
					ccui.Helper:seekWidgetByName(params._datas.cell.roots[1], "Button_xia"):setVisible(true)
					ccui.Helper:seekWidgetByName(params._datas.cell.roots[1], "Button_shou"):setVisible(false)
					
					if params._off == true then
						local expansion_pad_parent = expansion_pad:getParent()
						expansion_pad_parent:setPosition(expansion_pad_parent._pos)
						expansion_pad:setPosition(expansion_pad._pos)
						expansionActionOverCallback1()
						_PetListView:requestRefreshView()
					else
						expansion_pad:getParent():runAction(cc.Sequence:create(
											cc.MoveBy:create(0.5, cc.p(0, -offsetY)), 
											cc.DelayTime:create(0.05),
											cc.CallFunc:create(expansionActionOverCallback1)
											))
						expansion_pad:runAction(cc.Sequence:create(cc.MoveBy:create(0.5, cc.p(0, offsetY))))
					end
				end
				
				if nil == instance.expansionaryIndex then
					-- 弹出
					expansionOn()
				elseif _listIndex == instance.expansionaryIndex then
					-- 收回
					expansionOff()
				else
					-- 换个弹出
					local old_expansion_pad = ccui.Helper:seekWidgetByName(instance.runningExpansionCell.roots[1], "Panel_xiala")
					old_expansion_pad:removeAllChildren(true)
					
					old_expansion_pad:getParent():setPositionY(old_expansion_pad:getParent():getPositionY() - offsetY)
					old_expansion_pad:setPositionY(old_expansion_pad:getPositionY() + offsetY)
					
					instance.runningExpansionCell:setContentSize(cc.size(instance.runningExpansionCell:getContentSize().width, instance.runningExpansionCellHeight))
					_PetListView:requestRefreshView()
					
					ccui.Helper:seekWidgetByName(instance.runningExpansionCell.roots[1], "Button_xia"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.runningExpansionCell.roots[1], "Button_shou"):setVisible(false)
					-----------------------------------------------------------
					expansionOn()
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新上阵信息
		local pet_list_view_update_formation_terminal = {
            _name = "pet_list_view_update_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil then 
				
					local listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_25081")
					PetListView.tSortedPets = instance:getSortedPets()
					PetListView.asyncIndex = 1
					listView:removeAllItems()
					
					for i, v in ipairs(PetListView.tSortedPets) do
						instance.loading(nil)
					end
					listView:jumpToTop()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_show_hero_counts_terminal)
		state_machine.add(pet_list_view_insert_cell_terminal)
		state_machine.add(pet_list_view_remove_cell_terminal)
		state_machine.add(pet_list_view_update_cell_terminal)
		state_machine.add(pet_expansion_action_start_terminal)
		state_machine.add(pet_list_view_update_formation_terminal)
        state_machine.init()
    end
    
    init_pet_list_view_terminal()
end

function PetListView:cleanListView()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_25081")
	local items = listView:getItems()
	
	for i, v in pairs(items) do
		local status = false
		for j, q in pairs(_ED.user_ship) do
			if tonumber(v.heroInstance.ship_template_id) == tonumber(q.ship_template_id) then
				status = true
			end
		end
		if status == false then
			listView:removeItem(listView:getIndex(v))
		end
	end
end

function PetListView:onDrawEmptyStates(isEmpty)
	if isEmpty == true then 
		if self._empty == nil then 	
			local cell = StorageDialog:createCell()
			cell:init(7)
			self:addChild(cell)
			self._empty = cell
		end		
	else
		if self._empty ~= nil then 	
			self._empty:removeFromParent(true)
			self._empty = nil	
		end	
	end
end

function PetListView:getSortedPets()
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
	--驯养
	local arrBusyEquipPets = {}
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
			if zstring.tonumber(_ED.formation_pet_id) == zstring.tonumber(ship.ship_id) then
				table.insert(arrBusyPets, ship)
			elseif zstring.tonumber(ship.pet_equip_ship_id) > 0 then 
				table.insert(arrBusyEquipPets, ship)
			elseif dms.atoi(shipData, ship_mould.captain_type) == 3 then
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
	table.sort(arrBusyPets, fightingCapacity)
	table.sort(arrBusyEquipPets, fightingCapacity)
	table.sort(arrStarLevelpetsWhite, fightingCapacity)
	table.sort(arrStarLevelpetsGreen, fightingCapacity)
	table.sort(arrStarLevelpetsKohlrabiblue, fightingCapacity)
	table.sort(arrStarLevelpetsPurple, fightingCapacity)
	table.sort(arrStarLevelpetsOrange, fightingCapacity)
	table.sort(arrStarLevelpetsRed, fightingCapacity)
	table.sort(arrStarLevelpetsGold, fightingCapacity)
	-- 把已排序好的上阵宠物加入到 宠物排序数组中
	for i=1, #arrBusyPets do
		table.insert(tSortedPets, arrBusyPets[i])
	end

	for i=1, #arrBusyEquipPets do
		table.insert(tSortedPets, arrBusyEquipPets[i])
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

function PetListView:getListIndexByShipId(_sortedpets, _shipId)
	for i, v in ipairs(_sortedpets) do
		if _shipId == v.ship_id then
			return i-1
		end
	end
	return nil
end

function PetListView:insertCell(_cell, _index)
	local _PetListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_25081")
	--添加取值保险,至少是在合法index范围
	_index = math.max(_index, 0)
	_index = math.min(_index, table.getn(_PetListView:getItems()))
	
	_PetListView:insertCustomItem(_cell, _index)
	_PetListView:requestRefreshView()
	state_machine.excute("pet_show_hero_counts", 0, "pet_show_hero_counts.")
end

function PetListView:removeCellByShipId(_ship_id)
	local _PetListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_25081")
	local cells = _PetListView:getItems()

	for i, cell in pairs(cells) do
		if zstring.tonumber(cell.heroInstance.ship_id) == zstring.tonumber(_ship_id) then
			_PetListView:removeItem(_PetListView:getIndex(cell))
		end
	end
	_PetListView:requestRefreshView()
	state_machine.excute("pet_show_hero_counts", 0, "pet_show_hero_counts.")
end

function PetListView:updateCellByShipId(_ship_id)
	local _PetListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_25081")
	local cells = _PetListView:getItems()

	for i, cell in pairs(cells) do
		if tonumber(cell.heroInstance.ship_id) == tonumber(_ship_id) then
			state_machine.excute("pet_seat_update", 0, cell)
			break
		end
	end
end

function PetListView:onUpdate(dt)
	if self.isRunning == false or self.runningExpansionCell == nil or self.runningExpansionCell.roots[1] == nil then
	else
		local expansion_pad = ccui.Helper:seekWidgetByName(self.runningExpansionCell.roots[1], "Panel_xiala")
		local offsetY = (expansion_pad:getParent():getPositionY() - expansion_pad:getPositionY()) / 2
		
		self.runningExpansionCell:setContentSize(cc.size(self.runningExpansionCell:getContentSize().width, self.runningExpansionCellHeight + offsetY))
		ccui.Helper:seekWidgetByName(self.roots[1], "ListView_25081"):requestRefreshView()
	end	

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
				if v == self.runningExpansionCell then
					v:setContentSize(HeroSeatCell.__size)
					state_machine.excute("pet_expansion_action_start", 0, {_datas = {cell = v}, _off = true})
				end
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function PetListView.loading(texture)
	local myListView = PetListView.myListView
	if myListView ~= nil then
		local cell = PetSeatCell:createCell()
		cell:init(PetListView.tSortedPets[PetListView.asyncIndex], nil, PetListView.asyncIndex)
		myListView:addChild(cell)
		PetListView.asyncIndex = PetListView.asyncIndex + 1
	end
end

function PetListView:onEnterTransitionFinish()
    local csbPetListView = nil
    if __lua_project_id == __lua_project_pokemon then
    	csbPetListView = csb.createNode("packs/PetStorage/PetStorage_list_sui.csb")
    else
    	csbPetListView = csb.createNode("packs/HeroStorage/generals_list_sui.csb")
    end
	local root = csbPetListView:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbPetListView)
	state_machine.excute("pet_show_hero_counts", 0, "pet_show_hero_counts.")
	self.tSortedPets = self:getSortedPets()
	local hero_storage_sell_button = ccui.Helper:seekWidgetByName(root, "Button_5069")
	if hero_storage_sell_button ~= nil then
		hero_storage_sell_button:setVisible(false)
	end

	PetListView.myListView = ccui.Helper:seekWidgetByName(root, "ListView_25081")
	PetListView.tSortedPets = self.tSortedPets
	PetListView.asyncIndex = 1
	for i, v in ipairs(self.tSortedPets) do
		self.loading(nil)
	end

	PetListView.myListView:requestRefreshView()
	
	self.currentListView = PetListView.myListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end


function PetListView:playCloseAction()
	
end

function PetListView:playIntoAction()

end

function PetListView:onExit()
	PetListView.myListView = nil
	PetListView.asyncIndex = 1
	state_machine.remove("pet_show_hero_counts")
	state_machine.remove("pet_list_view_show_pet_list_view_sell")
	state_machine.remove("pet_list_view_insert_cell")
	state_machine.remove("pet_list_view_remove_cell")
	state_machine.remove("pet_expansion_action_start")
	state_machine.remove("pet_list_view_update_cell")
	state_machine.remove("pet_list_view_update_formation")
end
