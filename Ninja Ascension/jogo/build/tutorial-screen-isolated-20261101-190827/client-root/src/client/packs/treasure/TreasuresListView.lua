----------------------------------------------------------------------------------------------------
-- 说明：
-------------------------------------------------------------------------------------------------------
TreasuresListView = class("TreasuresListViewClass", Window)
   
function TreasuresListView:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.utils.StorageDialog")
	--缓存listview
	self.cacheListView = nil		--缓存listview
	
	---------------------------------------------------------------------------
	-- 用于下拉效果
	---------------------------------------------------------------------------
	self.isRunning = false
	
	self.expansionaryIndex = nil
	
	self.runningExpansionCell = nil
	self.runningExpansionCellHeight = 0
	---------------------------------------------------------------------------

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	
	app.load("client.packs.treasure.TreasuresSell")
	app.load("client.cells.treasure.treasure_seat_cell")
	
    local function init_equip_list_view_terminal()
		
		--更新listview中一个元素
		local treasure_storage_update_listview_terminal = {
            _name = "treasure_storage_update_listview",
            _init = function (terminal) 
			end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				self:refreshListViewForTreasure(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--宝物出售
		local treasure_storage_sell_terminal = {
            _name = "treasure_storage_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("treasure_expansion_close", 0, "click treasure_expansion_close.")
				state_machine.excute("treasure_storage_hide_treasure_storages", 0, "click treasure_storage_hide_treasure_storages.")
				state_machine.excute("menu_hide_event", 0, "event menu_hide_event.")
				fwin:open(TreasuresSell:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--强化后的排序
		local treasure_list_view_del_and_insert_cell_terminal = {
            _name = "treasure_list_view_del_and_insert_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local id = params.user_equiment_id
				local listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
				local items = listView:getItems()
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then
					TreasuresListView.dTreasureArray = instance:getSortedTreasure()
					instance:createListView()
					instance:onUpdateTreasureCount()
					-- for i, v in pairs(items) do
					-- 	if v.child1 ~= nil and tonumber(v.child1.treasureInstance.user_equiment_id) == tonumber(id) then
					-- 		TreasuresListView.dTreasureArray = instance:getSortedTreasure()
					-- 		instance:createListView()
					-- 		break
					-- 	end
					-- 	if v.child2 ~= nil and tonumber(v.child2.treasureInstance.user_equiment_id) == tonumber(id) then
					-- 		TreasuresListView.dTreasureArray = instance:getSortedTreasure()
					-- 		instance:createListView()
					-- 		break
					-- 	end
					-- end
				else
					for i, v in pairs(items) do
						if tonumber(v.treasureInstance.user_equiment_id) == tonumber(id) then
							local listIndex = instance:getListIndexByTreasureId(instance:getSortedTreasure(), id)
							if listIndex ~= i-1 then
								listView:removeItem(i-1)
								if listIndex ~= nil then
									local cell = TreasureSeatCell:createCell()
									cell:init(_ED.user_equiment[""..id], 0)
									listView:insertCustomItem(cell, listIndex)
								end
							end	
						end
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--删除
		local treasure_storage_sell_remove_cell_terminal = {
            _name = "treasure_storage_sell_remove_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:cleanListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--下拉动画
		local treasure_expansion_action_start_terminal = {
            _name = "treasure_expansion_action_start",
            _init = function (terminal) 
                app.load("client.cells.treasure.treasure_expansion_cell.lua")
				app.load("client.packs.treasure.TreasureControllerPanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				--[[------测试代码
				state_machine.excute("treasure_storage_hide_treasure_storages", 0, "click treasure_storage_hide_treasure_storages.")
				local tcp = TreasureControllerPanel:new()
				tcp:setCurrentTreasure(params._datas.currentTreasure)
				fwin:open(tcp, fwin._windows)
				--]]--------------------------------------------------------------------------------
				
				if instance.isRunning == true then
					return
				end
				
				local _equip_id = params._datas.cell.treasureInstance.user_equiment_id
			
				local _herolistView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
				local _listIndex = instance:getListIndexByTreasureId(instance:getSortedTreasure(), _equip_id)
				local _cell = _herolistView:getItem(_listIndex)
				local expansion_pad = ccui.Helper:seekWidgetByName(_cell.roots[1], "Panel_xiala")

				if expansion_pad == nil then 
					--防止报错
					return
				end
				
				local offsetY = expansion_pad:getParent():getContentSize().height - 30 / CC_CONTENT_SCALE_FACTOR()
				
				local isBottom = false
				local function expansionOn()
					local function expansionActionOverCallback()
						instance.isRunning = false
						if isBottom == true then
							_herolistView:getInnerContainer():setPositionY(0)
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
					local expansionCell = TreasureExpansionCell:createCell()
					expansionCell:init(params._datas.cell)
					expansion_pad:addChild(expansionCell)

					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then
						local innerList = _herolistView:getInnerContainer()
						local cellPositonY = _cell:getPositionY()
						local innerPostionY = innerList:getPositionY()
						if cellPositonY + innerPostionY <= offsetY and cellPositonY > offsetY then
							innerList:setPositionY(innerPostionY + _cell:getContentSize().height)
						elseif cellPositonY < offsetY then
							isBottom = true
						end
					end
					
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
						_herolistView:requestRefreshView()
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
					_herolistView:requestRefreshView()
					
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
		
		state_machine.add(treasure_storage_sell_terminal)
		state_machine.add(treasure_expansion_action_start_terminal)
		state_machine.add(treasure_storage_sell_remove_cell_terminal)
		state_machine.add(treasure_storage_update_listview_terminal)
		state_machine.add(treasure_list_view_del_and_insert_cell_terminal)
        state_machine.init()
    end
    
    init_equip_list_view_terminal()
end

function TreasuresListView:cleanListView()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local items = listView:getItems()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local function checkEquipmentActive(item)
			if item == nil then
				return true
			end
			local status = false
			for j, q in pairs(_ED.user_equiment) do
				if tonumber(item.treasureInstance.user_equiment_id) == tonumber(q.user_equiment_id) then
					status = true
				end
			end
			return status
		end
		for i, v in pairs(items) do
			if checkEquipmentActive(v.child1) == false then
				v.child1:removeFromParent(true)
				v.child1 = nil
			end
			if checkEquipmentActive(v.child2) == false then
				v.child2:removeFromParent(true)
				v.child2 = nil
			end
			if v.child1 == nil and v.child2 == nil then
				listView:removeItem(listView:getIndex(v))
			end
		end
		items = listView:getItems()
		for i, v in pairs(items) do
			state_machine.excute("multiple_list_view_cell_manager", 0, v)
		end
	else
		for i, v in pairs(items) do
			local status = false
			for j, q in pairs(_ED.user_equiment) do
				if tonumber(v.treasureInstance.user_equiment_id) == tonumber(q.user_equiment_id) then
					status = true
				end
			end
			if status == false then
				listView:removeItem(listView:getIndex(v))
			end
		end
	end
end

function TreasuresListView:getSortedTreasure()
	 -- 宝物排序
	local dTreasureArray={}
	
	--得到宝物数组
	local function getTrArray()
		local pIndex = 1
		for i, trInfo in pairs(_ED.user_equiment) do
			if tonumber(trInfo.equipment_type) > 3  and tonumber(trInfo.equipment_type) < 6 or tonumber(trInfo.equipment_type) == 8 then
				dTreasureArray[pIndex]=trInfo
				pIndex = pIndex + 1
			end
		end
	end
	
	local userTrSortFunc = function(a,b)
		--获取品质
		local aq = dms.int(dms["equipment_mould"], tonumber(a.user_equiment_template), equipment_mould.grow_level)
		local bq = dms.int(dms["equipment_mould"], tonumber(b.user_equiment_template), equipment_mould.grow_level)
		--是否装备
		local ae=tonumber(a.ship_id)
		local be=tonumber(b.ship_id)
		--装备类型
		local at = dms.int(dms["equipment_mould"], tonumber(a.user_equiment_template), equipment_mould.equipment_type)
		local bt = dms.int(dms["equipment_mould"], tonumber(b.user_equiment_template), equipment_mould.equipment_type)
		--获取品级
		local ar = dms.int(dms["equipment_mould"], tonumber(a.user_equiment_template), equipment_mould.rank_level)	
		local br = dms.int(dms["equipment_mould"], tonumber(b.user_equiment_template), equipment_mould.rank_level)	
		--获取等级
		local ag = tonumber(a.user_equiment_grade)
		local bg = tonumber(b.user_equiment_grade)
		
		
		local result = false
		
		if ( ae>0 and 
			(
				((be>0) and (aq>bq)) 
				or (((be > 0) and (aq>bq)) 
				or ((be > 0) and (aq==bq) and (ag > bg)) 
				or ((be > 0) and (aq==bq) and (ag==bg) and (ar > br)) 
				or ((be > 0) and (aq==bq) and (ag==bg) and (ar == br) and (at > bt)) )
				or (be <= 0) 
				or (aq>bq)
				or ((aq==bq)and (ag > bg))
				or ((aq==bq)and (ag==bg) and (ar > br)) 
				or ((aq==bq)and (ag==bg) and (ar == br) and (at > bt)) 
			)
		) then
			result = true
		elseif( ae<=0 and (
			((be <= 0) and (aq>bq))
			or ((be <= 0) and (aq>bq))
			or ((be <= 0) and (aq == bq) and (ag>bg))
			or ((be <= 0) and (aq == bq) and (ag==bg) and (ar>br))
			or ((be <= 0) and (aq == bq) and (ag==bg) and (ar==br) and (at > bt))
		) 
		) then
			result = true
		end
		
		return result 
	end
	
	getTrArray()
	table.sort(dTreasureArray, userTrSortFunc)
	return dTreasureArray
end


function TreasuresListView:getListIndexByTreasureId(_sortedTreasure, _Id)
	for i, v in ipairs(_sortedTreasure) do
		if _Id == v.user_equiment_id then
			return i-1
		end
	end
	return nil
end

--帧循环
function TreasuresListView:onUpdate(dt)
	if self.isRunning == false or self.runningExpansionCell == nil then
	else
		local expansion_pad = ccui.Helper:seekWidgetByName(self.runningExpansionCell.roots[1], "Panel_xiala")
		local offsetY = (expansion_pad:getParent():getPositionY() - expansion_pad:getPositionY()) / 2
		self.runningExpansionCell:setContentSize(cc.size(self.runningExpansionCell:getContentSize().width, self.runningExpansionCellHeight + offsetY))
		ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1"):requestRefreshView()
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
					v:setContentSize(TreasureSeatCell.__size)
					state_machine.excute("treasure_expansion_action_start", 0, {_datas = {cell = v}, _off = true})
				end
				v:unload()
			else
				v:reload()
			end
		end
	end
end

--更新listview中的元素
function TreasuresListView:refreshListViewForTreasure(treasure)

	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then 
		for i, v in pairs(self.cacheListView:getItems()) do
			if zstring.tonumber(v.treasureInstance.user_equiment_id) == zstring.tonumber(treasure.user_equiment_id) then
				v:init(treasure)
				v:onUpdatePanel()
				break
			end
		end
	else
		for i, v in pairs(self.cacheListView:getItems()) do
			if v.treasureInstance == treasure then
				v:init(treasure)
				v:onUpdatePanel()
				break
			end
		end
	end
end

--从显示列表中删除treasure选项卡
-- function TreasuresListView:removeListViewFormTreasure(treasure)
	-- for i, v in pairs(self.cacheListView:getItems()) do
		-- if v.treasureInstance == treasure then
			-- self.cacheListView:removeItem(i - 1)
		-- end
	-- end
-- end

--更新宝物数量显示
function TreasuresListView:onUpdateTreasureCount()
	--更新宝物数量显示
	local pIndex = 0
	for i, trInfo in pairs(_ED.user_equiment) do
		if tonumber(trInfo.equipment_type) > 3  and tonumber(trInfo.equipment_type) < 6 or tonumber(trInfo.equipment_type) == 8 then
			pIndex = pIndex + 1
		end
	end
	
	local root = self.roots[1]
	local textNums = ccui.Helper:seekWidgetByName(root, "Label_5075")
	textNums:setString(pIndex .. game_infomation_tip_str[10])
end

function TreasuresListView.loading(texture)
	local myListView = TreasuresListView.myListView
	if myListView ~= nil then
		local cell = TreasureSeatCell:createCell()
		cell:init(TreasuresListView.dTreasureArray[TreasuresListView.asyncIndex], TreasuresListView.asyncIndex)
		myListView:addChild(cell)
		TreasuresListView.asyncIndex = TreasuresListView.asyncIndex + 1
		-- myListView:requestRefreshView()
	end
end

function TreasuresListView:createListView()
	app.load("client.cells.utils.multiple_list_view_cell")
	TreasuresListView.myListView:removeAllItems()
	local preMultipleCell = nil
	local multipleCell = nil
	local status = false
	for i,v in pairs(TreasuresListView.dTreasureArray) do
		local cell = TreasureSeatCell:createCell()
		cell:init(v, i)
		if multipleCell == nil then
			multipleCell = MultipleListViewCell:createCell()
			multipleCell:init(TreasuresListView.myListView, TreasureSeatCell.__size)
			TreasuresListView.myListView:addChild(multipleCell)
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
		status = true
	end

	TreasuresListView.myListView:requestRefreshView()
	self.currentListView = TreasuresListView.myListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	if self.currentInnerContainerPosY ~= 0 then
		self.currentInnerContainer:setPositionY(self.currentInnerContainerPosY)
	end
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	return status
end

function TreasuresListView:onEnterTransitionFinish()

    local csbTreasuresListView = csb.createNode("packs/EquipStorage/equipment_listview.csb")
	self:addChild(csbTreasuresListView)
	local root = csbTreasuresListView:getChildByName("root")
	table.insert(self.roots, root)
	
	local sellBtn = ccui.Helper:seekWidgetByName(root, "Button_5069")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local action = csb.createTimeline("packs/EquipStorage/equipment_listview.csb")
	    csbTreasuresListView:runAction(action)
	    self.m_action = action
	    --self:playIntoAction()
	end
	--宝物出售按钮事件添加
	local sellBtn = ccui.Helper:seekWidgetByName(root, "Button_5069")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		local pIndex = 0
		for i, trInfo in pairs(_ED.user_equiment) do
			if tonumber(trInfo.equipment_type) > 3  and tonumber(trInfo.equipment_type) < 6 or tonumber(trInfo.equipment_type) == 8 then
				pIndex = pIndex + 1
			end
		end
		if pIndex == 0 then
			sellBtn:setTouchEnabled(false)
		else
			sellBtn:setTouchEnabled(true)
		end
	else
		sellBtn:setTouchEnabled(true)
	end
	fwin:addTouchEventListener(sellBtn, nil, 
	{
		func_string = [[state_machine.excute("treasure_storage_sell", 0, "click treasure_storage_sell.")]],
		isPressedActionEnabled = true
	},
	nil, 0)
	
	--缓存listview
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.cacheListView = myListView
	local status = false
    local dTreasureArray = self:getSortedTreasure()
	-- for i,v in pairs(dTreasureArray) do
	-- 	local cell = TreasureSeatCell:createCell()
	-- 	cell:init(v)
	-- 	myListView:addChild(cell)
	-- 	status = true
	-- end

	TreasuresListView.myListView = myListView
	TreasuresListView.dTreasureArray = dTreasureArray
	TreasuresListView.asyncIndex = 1
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		status = self:createListView()
	else
		for i,v in pairs(dTreasureArray) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			status = true
			self.loading(nil)
		end

		myListView:requestRefreshView()
	end

	self.currentListView = myListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

	if status == false then
		local cell = StorageDialog:createCell()
		cell:init(3)
		-- fwin:open(cell, fwin._view)
		self:addChild(cell)
	end
	--更新宝物数量
	self:onUpdateTreasureCount()
end

function TreasuresListView:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_close", false)
	end
end

function TreasuresListView:playIntoAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_open", false)
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

function TreasuresListView:onExit()
	TreasuresListView.myListView = nil
	TreasuresListView.asyncIndex = 1
	state_machine.remove("treasure_storage_sell")
	state_machine.remove("treasure_expansion_action_start")
	state_machine.remove("treasure_storage_sell_remove_cell")
	state_machine.remove("treasure_storage_update_listview")
	state_machine.remove("treasure_list_view_del_and_insert_cell")
end
