----------------------------------------------------------------------------------------------------
-- 说明：装备界面滑动层
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipListView = class("EquipListViewClass", Window)
   
function EquipListView:ctor()
    self.super:ctor()
	self.roots = {}
	self._empty = nil
	EquipListView.checkEmpty = false
	---------------------------------------------------------------------------
	-- 用于下拉效果
	---------------------------------------------------------------------------
	self.isRunning = false
	
	self.expansionaryIndex = nil
	
	self.runningExpansionCell = nil
	self.runningExpansionCellHeight = 0


	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	---------------------------------------------------------------------------
	app.load("client.utils.StorageDialog")
    local function init_equip_list_view_terminal()
		local equip_listView_page_terminal = {
            _name = "equip_list_view_page",
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
		
		-- 装备数量显示
		local equip_show_equip_counts_terminal = {
            _name = "equip_show_equip_counts",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local usedEquipmentStorageNumber = 0
				local openEquipmentStorageNumber = "0"
				for i, equip in pairs(_ED.user_equiment) do
					if equip.user_equiment_id ~= nil then
						if dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.equipment_type) < 4  then
							usedEquipmentStorageNumber = usedEquipmentStorageNumber+1
						end
					end
				end
				openEquipmentStorageNumber = _ED.equiment_bag_open
				ccui.Helper:seekWidgetByName(instance.roots[1], "Label_5075"):setString(usedEquipmentStorageNumber.."/"..openEquipmentStorageNumber)
				return true
			end,
            _terminal = nil,
            _terminals = nil
        }
		
		--强化后的排序
		local equip_list_view_del_and_insert_cell_terminal = {
            _name = "equip_list_view_del_and_insert_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params ~= nil and params._datas._cell ~= nil and params._datas._cell.equipmentInstance ~= nil then
					local id = params._datas._cell.equipmentInstance.user_equiment_id
					local listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
					local items = listView:getItems()
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then
						-- for i,v in pairs(items) do
						-- 	if v.child1 ~= nil and v.child1 == params._datas._cell then
						-- 		local listIndex = instance:getListIndexByShipId(instance:getSortedEquip(), id)
						-- 		if listIndex ~= i-1 then
						-- 			v.child1:removeFromParent(true)
						-- 			v.child1 = nil
						-- 			state_machine.excute("equip_list_view_insert_cell", 0, id)
						-- 		end	
						-- 	end
						-- 	if v.child2 ~= nil and v.child2 == params._datas._cell then
						-- 		local listIndex = instance:getListIndexByShipId(instance:getSortedEquip(), id)
						-- 		if listIndex ~= i-1 then
						-- 			v.child2:removeFromParent(true)
						-- 			v.child2 = nil
						-- 			state_machine.excute("equip_list_view_insert_cell", 0, id)
						-- 		end	
						-- 	end
						-- end
					else
						for i,v in pairs(items) do
							if v == params._datas._cell then
								local listIndex = instance:getListIndexByShipId(instance:getSortedEquip(), id)
								if listIndex ~= i-1 then
									listView:removeItem(i-1)
									state_machine.excute("equip_list_view_insert_cell", 0, id)
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
		
		--插入
		local equip_list_view_insert_cell_terminal = {
            _name = "equip_list_view_insert_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local listIndex = instance:getListIndexByShipId(instance:getSortedEquip(), params)
				if listIndex ~= nil then
					local cell = EquipListCell:createCell()
					cell:init(_ED.user_equiment[""..params], 1)
					instance:insertCell(cell, listIndex)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--删除
		local equip_list_view_remove_cell_terminal = {
            _name = "equip_list_view_remove_cell",
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
		
		-- 出售按钮
		local equip_list_view_show_equip_list_view_sell_terminal = {
            _name = "equip_list_view_show_equip_list_view_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(EquipSell:new(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--下拉动画
		local equip_expansion_action_start_terminal = {
            _name = "equip_expansion_action_start",
            _init = function (terminal) 
                app.load("client.cells.equip.equip_list_tan_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isRunning == true or  params._datas.cell.equipmentInstance == nil then
					return
				end
			
				local _equip_id = params._datas.cell.equipmentInstance.user_equiment_id
			
				local _herolistView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
				local _listIndex = instance:getListIndexByEquipId(instance:getSortedEquip(), _equip_id)
				local _cell = _herolistView:getItem(_listIndex)
				local expansion_pad = ccui.Helper:seekWidgetByName(_cell.roots[1], "Panel_xiala")
				
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
					local expansionCell = EquipListTanCell:createCell()
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
				-- 对所有子节点刷新界面
		local equip_list_view_show_equip_list_view_update_allcell_terminal = {
            _name = "equip_list_view_show_equip_list_view_update_allcell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:updateAllCell()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_listView_page_terminal)
		state_machine.add(equip_show_equip_counts_terminal)
		state_machine.add(equip_list_view_show_equip_list_view_sell_terminal)
		state_machine.add(equip_expansion_action_start_terminal)
		state_machine.add(equip_list_view_insert_cell_terminal)
		state_machine.add(equip_list_view_remove_cell_terminal)
		state_machine.add(equip_list_view_del_and_insert_cell_terminal)
        state_machine.add(equip_list_view_show_equip_list_view_update_allcell_terminal)
        state_machine.init()
    end
    
    init_equip_list_view_terminal()
end
function EquipListView:updateAllCell()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local items = listView:getItems()
	for i,v in pairs(items) do
		if v.child1 ~= nil then
			if v.child1.roots[1] ~= nil then
				v.child1:onUpdateDraw()
			end
		end
		if v.child2 ~= nil then
			if v.child2.roots[1] ~= nil then
				v.child2:onUpdateDraw()
			end
		end
	end
end
function EquipListView:cleanListView()
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
				if tonumber(item.equipmentInstance.user_equiment_id) == tonumber(q.user_equiment_id) then
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
				if tonumber(v.equipmentInstance.user_equiment_id) == tonumber(q.user_equiment_id) then
					status = true
				end
			end
			if status == false then
				listView:removeItem(listView:getIndex(v))
			end
		end
	end
end

function EquipListView:insertCell(_cell, _index)
	local _herolistView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local items = _herolistView:getItems()
		local preMultipleCell = nil
		local multipleCell = nil
		for i, v in pairs(items) do
			if ((i-1) * 2) == _index then
				preMultipleCell = v.prev
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(_herolistView, EquipListCell.__size)
				_herolistView:insertCustomItem(multipleCell, i - 1)
				if preMultipleCell ~= nil then
					preMultipleCell.next = multipleCell
				end
				multipleCell.prev = preMultipleCell
				v.prev = multipleCell
				multipleCell.next = v
				multipleCell:addNode(_cell)
				break
			end 
			if ((i-1) * 2 + 1) == _index then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(_herolistView, EquipListCell.__size)
				_herolistView:insertCustomItem(multipleCell, i)
				if v.next ~= nil then
					v.next.prev = multipleCell
					multipleCell.next = v.next
				end
				v.next = multipleCell
				multipleCell.prev = v

				if v.child2 ~= nil then
					v.child2:retain()
					v.child2:removeFromParent(false)
					multipleCell:addNode(v.child2)
					v.child2:release()
					v.child2 = nil
				end
				v:addNode(_cell)
				break
			end 
		end
		items = _herolistView:getItems()
		for i, v in pairs(items) do
			state_machine.excute("multiple_list_view_cell_manager", 0, v)
		end
	else
		_herolistView:insertCustomItem(_cell, _index)
	end
	state_machine.excute("equip_show_equip_counts", 0, "equip_show_equip_counts.")
end

function EquipListView:getListIndexByShipId(_sortedHeroes, _shipId)
	for i, v in ipairs(_sortedHeroes) do
		if _shipId == v.user_equiment_id then
			return i-1
		end
	end
	return nil
end

function EquipListView:getSortedEquip()
	local sortEquip = {}
	local swapSortEquip = {}
	for i, equip in pairs(_ED.user_equiment) do
		if equip.user_equiment_id ~= nil then
			-- dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)
			if dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.equipment_type) < 4 then
				local temp = equip
				local pos = 1
				for p, v in pairs(sortEquip) do
					if temp ~= nil and (
					(tonumber(equip.ship_id) > 0 and (
							tonumber(v.ship_id) <=0 or
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.grow_level)) or 
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) or
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) == dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)and 
							(tonumber(v.user_equiment_grade) < tonumber(equip.user_equiment_grade)))
						)) or
						(tonumber(v.ship_id) <=0 and ((dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.grow_level)) or 
					(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level)< dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) or 
					((dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) == dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) and (tonumber(v.user_equiment_grade) < tonumber(equip.user_equiment_grade)))
					))
					) then
						swapSortEquip[pos] = temp
						pos = pos + 1
						temp = nil
					end
					swapSortEquip[pos] = v
					pos = pos + 1
				end
				if temp ~= nil then
					swapSortEquip[pos] = temp
					temp = nil
				end
				sortEquip = nil
				sortEquip = {}
				for t, s in pairs(swapSortEquip) do
					sortEquip[t] = s
				end
				swapSortEquip = nil
				swapSortEquip = {}
			end	
		end
	end
	return sortEquip
end

function EquipListView:getListIndexByEquipId(_sortedEquip, _Id)
	for i, v in ipairs(_sortedEquip) do
		if _Id == v.user_equiment_id then
			return i-1
		end
	end
	return nil
end


function EquipListView:onUpdate(dt)
	if EquipListView.checkEmpty == true then
	
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
					v:setContentSize(EquipListCell.__size)
					state_machine.excute("equip_expansion_action_start", 0, {_datas = {cell = v}, _off = true})
				end
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function EquipListView.loading(texture)
	local myListView = EquipListView.myListView
	if myListView ~= nil then
		local cell = EquipListCell:createCell()
		cell:init(EquipListView.sortEquip[EquipListView.asyncIndex], EquipListView.asyncIndex)
		myListView:addChild(cell)
		EquipListView.asyncIndex = EquipListView.asyncIndex + 1
		-- myListView:requestRefreshView()
		-- EquipListView.checkEmpty = true
	end
	
	-- EquipPatchListView.loading(texture)
end

function EquipListView:onEnterTransitionFinish()
    local csbEquipListView = csb.createNode("packs/EquipStorage/equipment_listview.csb")
	self:addChild(csbEquipListView)

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local action = csb.createTimeline("packs/EquipStorage/equipment_listview.csb")
	    csbEquipListView:runAction(action)
	    self.m_action = action
	    --self:playIntoAction()
	end

	local root = csbEquipListView:getChildByName("root")
	table.insert(self.roots, root)
	state_machine.excute("equip_show_equip_counts", 0, "equip_show_equip_counts.")

	EquipStorage._equip_storage_sell_button = ccui.Helper:seekWidgetByName(root, "Button_5069")
	fwin:addTouchEventListener(EquipStorage._equip_storage_sell_button, nil, {func_string = [[state_machine.excute("equip_list_view_show_equip_list_view_sell", 0, "click .'")]], isPressedActionEnabled = true}, nil, 0)	
	
	
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	--排序
	local sortEquip = self:getSortedEquip()
	-- for i,v in pairs(sortEquip) do
	-- 	local cell = EquipListCell:createCell()
	-- 	cell:init(v)
	-- 	myListView:addChild(cell)
	-- end

	EquipListView.myListView = myListView
	EquipListView.sortEquip = sortEquip
	EquipListView.asyncIndex = 1
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(sortEquip) do
			local cell = EquipListCell:createCell()
			cell:init(v, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(myListView, EquipListCell.__size)
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
		-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		for i,v in pairs(sortEquip) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			-- status = true
			self.loading(nil)
		end
	end
	myListView:requestRefreshView()

	self.currentListView = myListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	if sortEquip[1] == nil then
		EquipListView.checkEmpty = true
	end
end

function EquipListView:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_close", false)
	end
end

function EquipListView:playIntoAction()
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

function EquipListView:onExit()
	self:playCloseAction()
	EquipListView.myListView = nil
	EquipListView.asyncIndex = 1
	state_machine.remove("equip_list_view_page")
	state_machine.remove("equip_show_equip_counts")
	state_machine.remove("equip_list_view_show_equip_list_view_sell")
	state_machine.remove("equip_expansion_action_start")
	state_machine.remove("equip_list_view_insert_cell")
	state_machine.remove("equip_list_view_remove_cell")
	state_machine.remove("equip_list_view_del_and_insert_cell")
	state_machine.remove("equip_list_view_show_equip_list_view_update_allcell")
end
