----------------------------------------------------------------------------------------------------
-- 说明：宠物碎片界面滑动层
-------------------------------------------------------------------------------------------------------
PetPatchListView = class("PetPatchListViewClass", Window)
   
function PetPatchListView:ctor()
    self.super:ctor()
	self.roots = {}
    self._empty = nil
	self.tSortedHeroes = {}
	PetPatchListView.checkEmpty = false
	app.load("client.utils.StorageDialog")
	app.load("client.cells.pet.pet_fragment_seat_cell")
    local function init_pet_patch_list_terminal()
		local pet_patch_sort_terminal = {
            _name = "pet_patch_sort",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function fightingCapacity(a,b)
					local aData = dms.element(dms["prop_mould"], a.user_prop_template)
					local bData = dms.element(dms["prop_mould"], b.user_prop_template)
					
					local al = dms.atoi(aData, prop_mould.prop_quality)
					local bl = dms.atoi(bData, prop_mould.prop_quality)
					local an = a.prop_number
					local bn = b.prop_number
					local result = false
					if al > bl then
						result = true
					elseif al == bl and tonumber(an) > tonumber(bn) then
						result = true
					end
					return result 
				end
				
				local function compareQuality(a,b)
					local al = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.prop_quality)
					local bl = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.prop_quality)
					local result = false
					if al > bl then
						result = true
					end	
					return result 
				end
			
				instance.tSortedHeroes = {}
				-- 各星级武将碎片数组
				local arrStarLevelHeroesWhite = {}--白
				local arrStarLevelHeroesGreen = {}--绿
				local arrStarLevelHeroesKohlrabiblue= {}--蓝
				local arrStarLevelHeroesPurple = {}--紫
				local arrStarLevelHeroesOrange = {}--橙
				local arrStarLevelHeroesRed = {}--红
				local isComposeProp = {}
				for i, prop in pairs(_ED.user_prop) do
					if zstring.tonumber(prop.user_prop_id) > 0 then
						local propData = dms.element(dms["prop_mould"], prop.user_prop_template)
						if dms.atoi(propData, prop_mould.storage_page_index) == 15 then
							local apropQuality = dms.string(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)
							if tonumber(prop.prop_number) >= dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.split_or_merge_count) then
								table.insert(isComposeProp, prop)
							else
								if tonumber(apropQuality) == 0 then
									table.insert(arrStarLevelHeroesWhite, prop)
								elseif tonumber(apropQuality) == 1 then
									table.insert(arrStarLevelHeroesGreen, prop)
								elseif tonumber(apropQuality) == 2 then
									table.insert(arrStarLevelHeroesKohlrabiblue, prop)
								elseif tonumber(apropQuality) == 3 then
									table.insert(arrStarLevelHeroesPurple, prop)
								elseif tonumber(apropQuality) == 4 then
									table.insert(arrStarLevelHeroesOrange, prop)
								elseif tonumber(apropQuality) == 5 then
									table.insert(arrStarLevelHeroesRed, prop)
								end
							end
						end
					end
				end
				table.sort(isComposeProp, compareQuality)
				table.sort(arrStarLevelHeroesWhite, fightingCapacity)
				table.sort(arrStarLevelHeroesGreen, fightingCapacity)
				table.sort(arrStarLevelHeroesKohlrabiblue, fightingCapacity)
				table.sort(arrStarLevelHeroesPurple, fightingCapacity)
				table.sort(arrStarLevelHeroesOrange, fightingCapacity)
				table.sort(arrStarLevelHeroesRed, fightingCapacity)
				
				for i=1, #isComposeProp do
					table.insert(instance.tSortedHeroes, isComposeProp[i])
				end
				for i=1, #arrStarLevelHeroesRed do
					table.insert(instance.tSortedHeroes, arrStarLevelHeroesRed[i])
				end
				for i=1, #arrStarLevelHeroesOrange do
					table.insert(instance.tSortedHeroes, arrStarLevelHeroesOrange[i])
				end
				for i=1, #arrStarLevelHeroesPurple do
					table.insert(instance.tSortedHeroes, arrStarLevelHeroesPurple[i])
				end
				for i=1, #arrStarLevelHeroesKohlrabiblue do
					table.insert(instance.tSortedHeroes, arrStarLevelHeroesKohlrabiblue[i])
				end
				for i=1, #arrStarLevelHeroesGreen do
					table.insert(instance.tSortedHeroes, arrStarLevelHeroesGreen[i])
				end
				for i=1, #arrStarLevelHeroesWhite do
					table.insert(instance.tSortedHeroes, arrStarLevelHeroesWhite[i])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pet_patch_remove_item_terminal = {
            _name = "pet_patch_remove_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local index = instance:getListIndexById(params.heroInstance.user_prop_id)
				instance:removeItem(index)
				table.remove(self.tSortedHeroes, index+1, 1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--消耗碎片时刷新
		local pet_patch_update_item_for_id_terminal = {
            _name = "pet_patch_update_item_for_id",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateItemforId(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(pet_patch_sort_terminal)
		state_machine.add(pet_patch_remove_item_terminal)
		state_machine.add(pet_patch_update_item_for_id_terminal)
        state_machine.init()
    end
    
    init_pet_patch_list_terminal()
end

function PetPatchListView:getListIndexById(_id)
	for i, v in ipairs(self.tSortedHeroes) do
		if _id == v.user_prop_id then
			return i-1
		end
	end
	return nil
end

--通过模板ID刷新cell
function PetPatchListView:onUpdateItemforId(params)
	local root = self.roots[1]
	local myListView = nil
	if __lua_project_id == __lua_project_pokemon then
		myListView = ccui.Helper:seekWidgetByName(root, "ListView_25081")
	else
		myListView = ccui.Helper:seekWidgetByName(root, "ListView_sui12")
	end
	local items = myListView:getItems()
	for i,v in pairs(items) do
		if zstring.tonumber(v.heroInstance.user_prop_template) == params then 
			state_machine.excute("pet_fragment_seat_cell_update", 0, {_datas = {cell = v}})
		end
	end
end

function PetPatchListView:removeItem(_index)
	local root = self.roots[1]
	local myListView = nil
	if __lua_project_id == __lua_project_pokemon then
		myListView = ccui.Helper:seekWidgetByName(root, "ListView_25081")
	else
		myListView = ccui.Helper:seekWidgetByName(root, "ListView_sui12")
	end
	 
	myListView:removeItem(_index)
	myListView:requestRefreshView()
end

function PetPatchListView:onUpdateFormationStates()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local myListView = nil
	if __lua_project_id == __lua_project_pokemon then
		myListView = ccui.Helper:seekWidgetByName(root, "ListView_25081")
	else
		myListView = ccui.Helper:seekWidgetByName(root, "ListView_sui12")
	end
	local items = myListView:getItems()
	for i,v in pairs(items) do
		if v.onDrawFormationStates ~= nil then 
			v:onDrawFormationStates()
		end
	end
end

function PetPatchListView:onUpdate(dt)

	if PetPatchListView.checkEmpty ~= true then
		return
	end
	local items = PetPatchListView.myListView:getItems()

	--> print(items~= nil,table.getn(items) > 0)
	if items~= nil and table.getn(items) > 0 then
		if self._empty ~= nil then
			self._empty:removeFromParent(true)
			self._empty = nil	
		end	
	else
		if self._empty == nil then
			local cell = StorageDialog:createCell()
			cell:init(8)
			self:addChild(cell)
			self._empty = cell
		end
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
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function PetPatchListView.loading(texture)
	if PetPatchListView.asyncIndex ~= nil and PetPatchListView.asyncIndex > #PetPatchListView.tSortedHeroes then
		return
	end	

	local myListView = PetPatchListView.myListView
	if myListView ~= nil then
		local cell = PetFragmentSeatCell:createCell()
		cell:init(PetPatchListView.tSortedHeroes[PetPatchListView.asyncIndex], PetPatchListView.asyncIndex)
		myListView:addChild(cell)
		PetPatchListView.asyncIndex = PetPatchListView.asyncIndex + 1
		-- myListView:requestRefreshView()
		PetPatchListView.checkEmpty = true
	end
end

function PetPatchListView:onEnterTransitionFinish()
	local csbPetPatchListView = nil
    if __lua_project_id == __lua_project_pokemon then
    	csbPetPatchListView = csb.createNode("packs/PetStorage/PetStorage_list_sui.csb")
    else
    	csbPetPatchListView = csb.createNode("packs/HeroStorage/generals_list_sui_1.csb")
    end
	self:addChild(csbPetPatchListView)
	local root = csbPetPatchListView:getChildByName("root")
	table.insert(self.roots, root)

	state_machine.excute("pet_patch_sort", 0, "pet_patch_sort.")

	if __lua_project_id == __lua_project_pokemon then
		PetPatchListView.myListView = ccui.Helper:seekWidgetByName(root, "ListView_25081")
	else
		PetPatchListView.myListView = ccui.Helper:seekWidgetByName(root, "ListView_sui12")
	end
	PetPatchListView.tSortedHeroes = self.tSortedHeroes
	PetPatchListView.asyncIndex = 1

	for i, v in ipairs(self.tSortedHeroes) do
		-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
		self.loading(nil)
	end
	self.currentListView = PetPatchListView.myListView 
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	if PetPatchListView.tSortedHeroes[1] == nil then
		PetPatchListView.checkEmpty = true
	end
end

function PetPatchListView:playCloseAction()

end

function PetPatchListView:playIntoAction()

end

function PetPatchListView:onExit()
	PetPatchListView.myListView = nil
	PetPatchListView.asyncIndex = 1
	state_machine.remove("pet_patch_sort")
	state_machine.remove("pet_patch_remove_item")
	state_machine.remove("pet_patch_update_item_for_id")
end
