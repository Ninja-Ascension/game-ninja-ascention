----------------------------------------------------------------------------------------------------
-- 说明：装备碎片界面滑动层
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipPatchListView = class("EquipPatchListViewClass", Window)
   
function EquipPatchListView:ctor()
    self.super:ctor()
	self.roots = {}
    self.tSortedHeroes = {}
	self.isComposeProp = {}
	self.arrStarLevelHeroesWhite = {}--白
	self.arrStarLevelHeroesGreen = {}--绿
	self.arrStarLevelHeroesBlue = {}--蓝
	self.arrStarLevelHeroesPurple = {}--紫
	self.arrStarLevelHerosOrange = {} --橙
	self.arrStarLevelHerosRed = {} --红
	self._empty = nil
	EquipPatchListView.checkEmpty = false

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	app.load("client.utils.StorageDialog")
    local function init_equip_patch_list_terminal()
		local equip_patch_list_page_terminal = {
            _name = "equip_patch_list_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_patch_remove_item_terminal = {
            _name = "equip_patch_remove_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local index = instance:getListIndexById(params.equipmentInstance.user_prop_id)
				table.remove(instance.tSortedHeroes, index+1,1)
				instance:removeItem(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_patch_onupdate_all_terminal = {
            _name = "equip_patch_onupdate_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
            		if instance ~= nil and instance.onUpdateAllListCell ~= nil then
            			instance:onUpdateAllListCell()
            		end
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_patch_list_page_terminal)
		state_machine.add(equip_patch_remove_item_terminal)
		state_machine.add(equip_patch_onupdate_all_terminal)
        state_machine.init()
    end
    
    init_equip_patch_list_terminal()
end

function EquipPatchListView:onUpdateAllListCell( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	    self.tSortedHeroes = {}
		self.isComposeProp = {}
		self.arrStarLevelHeroesWhite = {}--白
		self.arrStarLevelHeroesGreen = {}--绿
		self.arrStarLevelHeroesBlue= {}--蓝
		self.arrStarLevelHeroesPurple = {}--紫
		self.arrStarLevelHerosOrange = {} --橙
		self.arrStarLevelHerosRed = {}-- 红
		local function fightingCapacity(a,b)
			
			local al = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.prop_quality)
			local bl = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.prop_quality)
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
		
		local function fnSortOfHero()
			
			for i, prop in pairs(_ED.user_prop) do
				if zstring.tonumber(prop.user_prop_id) > 0 then
					if dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.storage_page_index) == 3 then
						local apropQuality = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)
						if tonumber(prop.prop_number) >= dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.split_or_merge_count) then
							table.insert(self.isComposeProp, prop)
						else	
							if tonumber(apropQuality) == 0 then
								table.insert(self.arrStarLevelHeroesWhite, prop)
							elseif tonumber(apropQuality) == 1 then
								table.insert(self.arrStarLevelHeroesGreen, prop)
							elseif tonumber(apropQuality) == 2 then
								table.insert(self.arrStarLevelHeroesBlue, prop)
							elseif tonumber(apropQuality) == 3 then
								table.insert(self.arrStarLevelHeroesPurple, prop)
							elseif tonumber(apropQuality) == 4 then
								table.insert(self.arrStarLevelHerosOrange, prop)
							elseif tonumber(apropQuality) == 5 then
								table.insert(self.arrStarLevelHerosRed, prop)
							end
						end
					end
				end
			end
			table.sort(self.isComposeProp, compareQuality)
			table.sort(self.arrStarLevelHeroesWhite, fightingCapacity)
			table.sort(self.arrStarLevelHeroesGreen, fightingCapacity)
			table.sort(self.arrStarLevelHeroesBlue, fightingCapacity)
			table.sort(self.arrStarLevelHeroesPurple, fightingCapacity)
			table.sort(self.arrStarLevelHerosOrange, fightingCapacity)
			table.sort(self.arrStarLevelHerosRed, fightingCapacity)
			
			for i=1, #self.isComposeProp do
				table.insert(self.tSortedHeroes, self.isComposeProp[i])
			end
			for i=1, #self.arrStarLevelHerosRed do
				table.insert(self.tSortedHeroes, self.arrStarLevelHerosRed[i])
			end
			for i=1, #self.arrStarLevelHerosOrange do
				table.insert(self.tSortedHeroes, self.arrStarLevelHerosOrange[i])
			end
			for i=1, #self.arrStarLevelHeroesPurple do
				table.insert(self.tSortedHeroes, self.arrStarLevelHeroesPurple[i])
			end
			for i=1, #self.arrStarLevelHeroesBlue do
				table.insert(self.tSortedHeroes, self.arrStarLevelHeroesBlue[i])
			end
			for i=1, #self.arrStarLevelHeroesGreen do
				table.insert(self.tSortedHeroes, self.arrStarLevelHeroesGreen[i])
			end
			for i=1, #self.arrStarLevelHeroesWhite do
				table.insert(self.tSortedHeroes, self.arrStarLevelHeroesWhite[i])
			end
			return self.tSortedHeroes
		end
		
		local root = self.roots[1]
		local hero = fnSortOfHero()
		local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
		myListView:removeAllItems()
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(hero) do
			local cell = EquipPatchListCell:createCell()
			cell:init(v, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(myListView, EquipPatchListCell.__size)
				myListView:addChild(multipleCell)
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
		myListView:requestRefreshView()
		self.currentListView = myListView
		self.currentInnerContainer = self.currentListView:getInnerContainer()
		self.currentListView:getInnerContainer():setPositionY(-1)	
		if hero[1] == nil then
			EquipPatchListView.checkEmpty = true
		end
	end
end

function EquipPatchListView:getListIndexById(_id)
	for i, v in ipairs(self.tSortedHeroes) do
		if _id == v.user_prop_id then
			return i-1
		end
	end
	return nil
end

function EquipPatchListView:removeItem(_index)
	local root = self.roots[1]
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self:createListView()
		-- local items = myListView:getItems()
		-- local equippatch = self.tSortedHeroes[_index + 1]
		-- for i, v in pairs(items) do
		-- 	if v.child1 ~= nil and v.child1.equipmentInstance.user_prop_id == equippatch.user_prop_id then
		-- 		v.child1:removeFromParent(true)
		-- 		v.child1 = nil
		-- 	end
		-- 	if v.child2 ~= nil and v.child2.equipmentInstance.user_prop_id == equippatch.user_prop_id then
		-- 		v.child2:removeFromParent(true)
		-- 		v.child2 = nil
		-- 	end
		-- 	state_machine.excute("multiple_list_view_cell_manager", 0, v)
		-- end
	else	
		myListView:removeItem(_index)
	end
end

function EquipPatchListView:onUpdateCheckEmpty(dt)
-- print("\n\n EquipPatchListView.checkEmpty \n",EquipPatchListView.checkEmpty)
	if EquipPatchListView.checkEmpty ~= true then
		return
	end
	local items = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1"):getItems()
	if items~= nil and table.getn(items) > 0 then
		if self._empty ~= nil then
			self._empty:removeFromParent(true)
			self._empty = nil	
		end	
	else
		if self._empty == nil then
			local cell = StorageDialog:createCell()
			cell:init(2)
			self:addChild(cell)
			self._empty = cell
		end
	end
end

function EquipPatchListView:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_close", false)
	end
end

function EquipPatchListView:playIntoAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
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

function EquipPatchListView:onEnterTransitionFinish()
    local csbEquipPatchListView = csb.createNode("packs/EquipStorage/equipment_listview.csb")
	self:addChild(csbEquipPatchListView)
	local root = csbEquipPatchListView:getChildByName("root")
	table.insert(self.roots, root)

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local action = csb.createTimeline("packs/EquipStorage/equipment_listview.csb")
	    csbEquipPatchListView:runAction(action)
	    self.m_action = action
	    --self:playIntoAction()
	end
	
	ccui.Helper:seekWidgetByName(root, "Panel_1"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Button_5069"):setVisible(false)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Label_5075"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Label_5074"):setVisible(false)
	end
	-- --排序
	-- local dEquipmentFragment={}
	-- local dEnableFrag={}
	-- local dDisableFrag={}
	-- local function getFragArray()--得到宝物数组
		-- local pIndex = 1
		-- for i, prop in pairs(_ED.user_prop) do
			-- if prop.user_prop_id ~= nil then
				-- if dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.storage_page_index) == 3 then
					-- dEquipmentFragment[pIndex] = prop
					-- pIndex = pIndex + 1
				-- end
			-- end
		-- end
	-- end
	
	-- local pIndex=1
	-- getFragArray() --得到装备碎片数组
	-- for i, prop in pairs(dEquipmentFragment) do
		-- local aequipData = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.split_or_merge_count)
		-- local apropQuality = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)		--碎片a的品质
		-- if(tonumber(prop.prop_number) >= aequipData) then
			-- dEnableFrag[pIndex]=prop
			-- pIndex=pIndex+1
		-- end
	-- end
	
	-- pIndex=1
	-- for i, prop in pairs(dEquipmentFragment) do
		-- local aequipData = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.split_or_merge_count)
		-- local apropQuality = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)		--碎片a的品质
		-- if(tonumber(prop.prop_number)<tonumber(aequipData)) then
			-- dDisableFrag[pIndex]=prop
			-- pIndex=pIndex+1
		-- end
	-- end
	
	-- local userQuaityFunc = function(a,b)
		-- local aequipData = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.split_or_merge_count)	--碎片a合并时所需要的量
		-- local apropQuality = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.prop_quality)		--碎片a的品质
		-- local bequipData = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.split_or_merge_count)	--碎片a合并时所需要的量
		-- local bpropQuality = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.prop_quality)		--碎片a的品质
		-- local ret=false
		-- if apropQuality > bpropQuality then
			-- ret=true
		-- end
		-- return ret
	-- end
	
	-- local userNumberFunc = function(a,b)
		-- local aequipData = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.split_or_merge_count)	--碎片a合并时所需要的量
		-- local apropQuality = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.prop_quality)		--碎片a的品质
		-- local bequipData = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.split_or_merge_count)	--碎片a合并时所需要的量
		-- local bpropQuality = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.prop_quality)		--碎片a的品质
		-- local ret=false
		-- if apropQuality == bpropQuality and a.prop_number < b.prop_number then
			-- ret=true
		-- end
		-- return ret
	-- end
	
	-- table.sort(dDisableFrag, userNumberFunc)
	-- table.sort(dEnableFrag, userNumberFunc)
	-- table.sort(dEnableFrag, userQuaityFunc)
	-- table.sort(dDisableFrag, userQuaityFunc)
	
	
	-- local lastArray={}
	-- pIndex=1
	-- for i, prop in pairs(dEnableFrag) do
		-- lastArray[pIndex]=prop
		-- pIndex=pIndex+1
		-- local aequipData = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.split_or_merge_count)	--碎片a合并时所需要的量
		-- local apropQuality = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)		--碎片a的品质
	-- end
	
	-- for i, prop in pairs(dDisableFrag) do
		-- lastArray[pIndex]=prop
		-- pIndex=pIndex+1
		-- local aequipData = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.split_or_merge_count)	--碎片a合并时所需要的量
		-- local apropQuality = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)	--碎片a合并时所需要的量
	-- end
	
	-----------------------------------------------------------------------
	local function fightingCapacity(a,b)
		
		local al = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.prop_quality)
		local bl = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.prop_quality)
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
	
	local function fnSortOfHero()
		
		for i, prop in pairs(_ED.user_prop) do
			if zstring.tonumber(prop.user_prop_id) > 0 then
				if dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.storage_page_index) == 3 then
					local apropQuality = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)
					if tonumber(prop.prop_number) >= dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.split_or_merge_count) then
						table.insert(self.isComposeProp, prop)
					else	
						if tonumber(apropQuality) == 0 then
							table.insert(self.arrStarLevelHeroesWhite, prop)
						elseif tonumber(apropQuality) == 1 then
							table.insert(self.arrStarLevelHeroesGreen, prop)
						elseif tonumber(apropQuality) == 2 then
							table.insert(self.arrStarLevelHeroesBlue, prop)
						elseif tonumber(apropQuality) == 3 then
							table.insert(self.arrStarLevelHeroesPurple, prop)
						elseif tonumber(apropQuality) == 4 then
							table.insert(self.arrStarLevelHerosOrange, prop)
						elseif tonumber(apropQuality) == 5 then
							table.insert(self.arrStarLevelHerosRed, prop)
						end
					end
				end
			end
		end
		table.sort(self.isComposeProp, compareQuality)
		table.sort(self.arrStarLevelHeroesWhite, fightingCapacity)
		table.sort(self.arrStarLevelHeroesGreen, fightingCapacity)
		table.sort(self.arrStarLevelHeroesBlue, fightingCapacity)
		table.sort(self.arrStarLevelHeroesPurple, fightingCapacity)
		table.sort(self.arrStarLevelHerosOrange, fightingCapacity)
		table.sort(self.arrStarLevelHerosRed, fightingCapacity)
		
		for i=1, #self.isComposeProp do
			table.insert(self.tSortedHeroes, self.isComposeProp[i])
		end
		for i=1, #self.arrStarLevelHerosRed do
			table.insert(self.tSortedHeroes, self.arrStarLevelHerosRed[i])
		end
		for i=1, #self.arrStarLevelHerosOrange do
			table.insert(self.tSortedHeroes, self.arrStarLevelHerosOrange[i])
		end
		for i=1, #self.arrStarLevelHeroesPurple do
			table.insert(self.tSortedHeroes, self.arrStarLevelHeroesPurple[i])
		end
		for i=1, #self.arrStarLevelHeroesBlue do
			table.insert(self.tSortedHeroes, self.arrStarLevelHeroesBlue[i])
		end
		for i=1, #self.arrStarLevelHeroesGreen do
			table.insert(self.tSortedHeroes, self.arrStarLevelHeroesGreen[i])
		end
		for i=1, #self.arrStarLevelHeroesWhite do
			table.insert(self.tSortedHeroes, self.arrStarLevelHeroesWhite[i])
		end
		return self.tSortedHeroes
	end
	
	hero = fnSortOfHero()
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	
	-- for i, prop in pairs(hero) do
	-- 	local cellitem = EquipPatchListCell:createCell()
	-- 	cellitem:init(prop)
	-- 	myListView:addChild(cellitem)
	-- end

	EquipPatchListView.myListView = myListView
	EquipPatchListView.hero = hero
	EquipPatchListView.asyncIndex = 1
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(hero) do
			local cell = EquipPatchListCell:createCell()
			cell:init(v, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(myListView, EquipPatchListCell.__size)
				myListView:addChild(multipleCell)
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
		for i,v in pairs(hero) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			self.loading(nil)
		end
	end
	myListView:requestRefreshView()

	self.currentListView = myListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

	if hero[1] == nil then
		EquipPatchListView.checkEmpty = true
	end
end

function EquipPatchListView.loading(texture)
	if EquipPatchListView.asyncIndex ~= nil and EquipPatchListView.asyncIndex > #EquipPatchListView.hero then
		return
	end	

	local myListView = EquipPatchListView.myListView
	if myListView ~= nil then
		local cell = EquipPatchListCell:createCell()
		cell:init(EquipPatchListView.hero[EquipPatchListView.asyncIndex], EquipPatchListView.asyncIndex)
		myListView:addChild(cell)
		EquipPatchListView.asyncIndex = EquipPatchListView.asyncIndex + 1
		-- myListView:requestRefreshView()
		EquipPatchListView.checkEmpty = true
	end
end
function EquipPatchListView:createListView()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local hero = self.tSortedHeroes
		local myListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
		
		myListView:removeAllItems()
		EquipPatchListView.hero = hero
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(hero) do
			local cell = EquipPatchListCell:createCell()
			cell:init(v, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(myListView, EquipPatchListCell.__size)
				myListView:addChild(multipleCell)
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
end
function EquipPatchListView:onUpdate(dt)
	self:onUpdateCheckEmpty(dt)
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

function EquipPatchListView:onExit()
	EquipPatchListView.myListView = nil
	EquipPatchListView.asyncIndex = 1
	state_machine.remove("equip_patch_list_page")
	state_machine.remove("equip_patch_remove_item")
	state_machine.remove("equip_patch_onupdate_all")
end
