----------------------------------------------------------------------------------------------------
-- 说明：武将碎片界面滑动层
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroPatchListView = class("HeroPatchListViewClass", Window)
   
function HeroPatchListView:ctor()
    self.super:ctor()
	self.roots = {}
    self._empty = nil
	self.tSortedHeroes = {}
	HeroPatchListView.checkEmpty = false
	app.load("client.utils.StorageDialog")
    local function init_hero_patch_list_terminal()
		local hero_patch_sort_terminal = {
            _name = "hero_patch_sort",
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
						if dms.atoi(propData, prop_mould.storage_page_index) == 5 then
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
		
		local hero_patch_remove_item_terminal = {
            _name = "hero_patch_remove_item",
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
		
		state_machine.add(hero_patch_sort_terminal)
		state_machine.add(hero_patch_update_one_terminal)
		state_machine.add(hero_patch_remove_item_terminal)
        state_machine.init()
    end
    
    init_hero_patch_list_terminal()
end

function HeroPatchListView:getListIndexById(_id)
	for i, v in ipairs(self.tSortedHeroes) do
		if _id == v.user_prop_id then
			return i-1
		end
	end
	return nil
end

function HeroPatchListView:removeItem(_index)
	local root = self.roots[1]
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_sui12")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		state_machine.excute("hero_patch_sort",0,"")
		self:updatelistview()
		-- local items = myListView:getItems()
		-- local equippatch = self.tSortedHeroes[_index + 1]
		-- for i, v in pairs(items) do
		-- 	if v.child1 ~= nil and v.child1.heroInstance.user_prop_id == equippatch.user_prop_id then
		-- 		v.child1:removeFromParent(true)
		-- 		v.child1 = nil
		-- 	end
		-- 	if v.child2 ~= nil and v.child2.heroInstance.user_prop_id == equippatch.user_prop_id then
		-- 		v.child2:removeFromParent(true)
		-- 		v.child2 = nil
		-- 	end
		-- 	state_machine.excute("multiple_list_view_cell_manager", 0, v)
		-- end
	else
		myListView:removeItem(_index)
	end
end

function HeroPatchListView:onUpdate(dt)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		if HeroPatchListView.checkEmpty ~= true then
			return
		end
	end
	local items = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_sui12"):getItems()
	--> print(items~= nil,table.getn(items) > 0)
	if items~= nil and table.getn(items) > 0 then
		if self._empty ~= nil then
			self._empty:removeFromParent(true)
			self._empty = nil	
		end	
	else
		if self._empty == nil then
			local cell = StorageDialog:createCell()
			cell:init(1)
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

function HeroPatchListView.loading(texture)
	if HeroPatchListView.asyncIndex ~= nil and HeroPatchListView.asyncIndex > #HeroPatchListView.tSortedHeroes then
		return
	end	

	local myListView = HeroPatchListView.myListView
	if myListView ~= nil then
		local cell = HeroFragmentSeatCell:createCell()
		cell:init(HeroPatchListView.tSortedHeroes[HeroPatchListView.asyncIndex], HeroPatchListView.asyncIndex)
		myListView:addChild(cell)
		HeroPatchListView.asyncIndex = HeroPatchListView.asyncIndex + 1
		-- myListView:requestRefreshView()
		HeroPatchListView.checkEmpty = true
	end
end

function HeroPatchListView:onEnterTransitionFinish()
    local csbHeroPatchListView = csb.createNode("packs/HeroStorage/generals_list_sui_1.csb")
	self:addChild(csbHeroPatchListView)
	local root = csbHeroPatchListView:getChildByName("root")
	table.insert(self.roots, root)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    	Animations_PlayOpenMainUI({self}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN)
    elseif __lua_project_id == __lua_project_legendary_game then
		local action = csb.createTimeline("packs/HeroStorage/generals_list_sui_1.csb")
	    csbHeroPatchListView:runAction(action)
	    self.m_action = action
	    self:playIntoAction()
	end
	
	state_machine.excute("hero_patch_sort", 0, "hero_patch_sort.")
	
	-- local myListView = root:getChildByName("ListView_sui12")
	
	-- for i, v in ipairs(self.tSortedHeroes) do
	-- 	local cell = HeroFragmentSeatCell:createCell()
	-- 	cell:init(v)
	-- 	myListView:addChild(cell)
	-- end
	
	-- myListView:jumpToTop()

	HeroPatchListView.myListView = ccui.Helper:seekWidgetByName(root, "ListView_sui12")
	HeroPatchListView.tSortedHeroes = self.tSortedHeroes
	HeroPatchListView.asyncIndex = 1
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(self.tSortedHeroes) do
			local cell = HeroFragmentSeatCell:createCell()
			cell:init(v, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(HeroPatchListView.myListView, HeroFragmentSeatCell.__size)
				HeroPatchListView.myListView:addChild(multipleCell)
				multipleCell.prev = preMultipleCell
				if preMultipleCell ~= nil then
					preMultipleCell.next = multipleCell
				end
			end
			multipleCell:addNode(cell)
			if multipleCell.child2 ~= nil then
				preMultipleCell = multipleCell
				multipleCell = nil
			end
		end
	else
		for i, v in ipairs(self.tSortedHeroes) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			self.loading(nil)
		end
	end

	HeroListView.myListView:requestRefreshView()

	self.currentListView = HeroPatchListView.myListView 
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	if HeroPatchListView.tSortedHeroes[1] == nil then
		HeroPatchListView.checkEmpty = true
	end
end
function HeroPatchListView:updatelistview()
	app.load("client.cells.utils.multiple_list_view_cell")
	local preMultipleCell = nil
	local multipleCell = nil
	HeroPatchListView.myListView:removeAllItems()
	for i,v in pairs(self.tSortedHeroes) do
		local cell = HeroFragmentSeatCell:createCell()
		cell:init(v, i)
		if multipleCell == nil then
			multipleCell = MultipleListViewCell:createCell()
			multipleCell:init(HeroPatchListView.myListView, HeroFragmentSeatCell.__size)
			HeroPatchListView.myListView:addChild(multipleCell)
			multipleCell.prev = preMultipleCell
			if preMultipleCell ~= nil then
				preMultipleCell.next = multipleCell
			end
		end
		multipleCell:addNode(cell)
		if multipleCell.child2 ~= nil then
			preMultipleCell = multipleCell
			multipleCell = nil
		end
	end
end
function HeroPatchListView:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:onClose()
	elseif __lua_project_id == __lua_project_legendary_game then
		self.m_action:play("window_close", false)
	end
end

function HeroPatchListView:playIntoAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		self.m_action:play("window_open", false)
		self.m_action:setTimeSpeed(app.getTimeSpeed())
		self.m_action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "window_open_over" then
	        	
	        elseif str == "window_close_over" then
	            self:onClose()
	        end
	    end)
	end
end

function HeroPatchListView:onExit()
	HeroPatchListView.myListView = nil
	HeroPatchListView.asyncIndex = 1
	state_machine.remove("hero_patch_sort")
	state_machine.remove("hero_patch_update_one")
	state_machine.remove("hero_patch_remove_item")
end
