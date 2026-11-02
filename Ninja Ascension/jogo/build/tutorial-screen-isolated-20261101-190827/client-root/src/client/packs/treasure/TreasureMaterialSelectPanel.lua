---------------------------------
-- 说明：宝物强化 --材料选择界面
-- 创建时间:2015.03.17
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureMaterialSelectPanel = class("TreasureMaterialSelectPanelClass", Window)

function TreasureMaterialSelectPanel:ctor()
    self.super:ctor()
	
	app.load("client.cells.treasure.treasure_sell_seat_cell")
	
	-- 定义封装类中的变量
	self.roots = {}					--界面中的UI根节点，供模块获取界面中的UI元素实例
	self.selectedTreasure = {}		--记录强化界面已经选择的宝物数组 init方法传入 本类中也会进行修改
	self.currentTreasure = nil
	self.selectCount = 0			--保存 已经选择的数量
	self.cacheSelectCountText = nil --缓存 显示已经选择数量的文本
	self.actions = {}
	self.treasureListView = nil		--listView控件

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	
    -- Initialize HeroSeat state machine.
    local function init_treasure_material_select_terminal()
		
		local treasure_sell_return_xinfa_page_close_terminal = {
            _name = "treasure_sell_return_xinfa_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(fwin:find("TreasureMaterialSelectPanelClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回宝物强化界面
		local treasure_material_return_treasure_strengthen_terminal = {
            _name = "treasure_material_return_treasure_strengthen",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local selectedTreasures = {}
				local cells = instance.treasureListView:getItems()
				for i, cell in pairs(cells) do
					if cell.status == true then
						table.insert(selectedTreasures, cell.treasureInstance)
					end
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					local obj = fwin:find("TreasureMaterialSelectPanelClass")
					if obj ~= nil then
						local action = obj.actions[1]
						if action ~= nil and action:IsAnimationInfoExists("window_close") == true then
							obj.actions[1]:play("window_close", false)
						else
							state_machine.excute("treasure_strengthen_from_material", 0, { _datas = {selected = selectedTreasures}})
							fwin:close(instance)
						end
					end
					
				else
					--> print("-*-*-*-*--*-*-*-*-*-*-*", #selectedTreasures)
					state_machine.excute("treasure_strengthen_from_material", 0, { _datas = {selected = selectedTreasures}})
					fwin:close(instance)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--确认
		local treasure_material_select_ok_terminal = {
            _name = "treasure_material_select_ok",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)		
				--把已经选择的给强化界面
				local selectedTreasures = {}
				local cells = instance.treasureListView:getItems()
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then
					for i, cell in pairs(cells) do
						if cell.child1 ~= nil and cell.child1.status == true then
							table.insert(selectedTreasures, cell.child1.treasureInstance)
						end
						if cell.child2 ~= nil and cell.child2.status == true then
							table.insert(selectedTreasures, cell.child2.treasureInstance)
						end
					end
				else
					for i, cell in pairs(cells) do
						if cell.status == true then
							table.insert(selectedTreasures, cell.treasureInstance)
						end
					end
				end
				--> print("-*-*-*-*--*-*-*-*-*-*-*", #selectedTreasures)
				state_machine.excute("treasure_strengthen_from_material", 0, { _datas = {selected = selectedTreasures}})
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--有一个宝物被选中了
		local treasure_material_selected_one_terminal = {
            _name = "treasure_material_selected_one",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local tempCell = params._datas.cell
				if tempCell.status == false then
					if self.selectCount < 5 then
						tempCell.status = true
						if tempCell.statusBoxArt ~= nil then
							tempCell.statusBoxArt:setVisible(true)
						end
						self.selectCount = self.selectCount + 1
					else
						if __lua_project_id == __lua_project_warship_girl_b
							or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
							or __lua_project_id == __lua_project_yugioh
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge
							then
							TipDlg.drawTextDailog(_string_piece_info[384])
						else
							TipDlg.drawTextDailog(_string_piece_info[428])
						end
					end
				elseif tempCell.status == true then
					tempCell.status = false
					if tempCell.statusBoxArt ~= nil then
						tempCell.statusBoxArt:setVisible(false)
					end
					self.selectCount = self.selectCount - 1
				end
				self.cacheSelectCountText:setString(tostring(self.selectCount))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(treasure_material_return_treasure_strengthen_terminal)
		state_machine.add(treasure_material_select_ok_terminal)
		state_machine.add(treasure_material_selected_one_terminal)
		state_machine.add(treasure_sell_return_xinfa_page_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasure_material_select_terminal()
end

--从显示列表中删除treasure选项卡
function TreasureMaterialSelectPanel:removeSelectedTreasure(tmpTable, value)

	local index = 1
	for i, v in pairs(tmpTable) do
		if v == value then
			table.remove(tmpTable, index)
			break
		end
		index = index + 1
	end
end

function TreasureMaterialSelectPanel:loading_cell()
	if TreasureMaterialSelectPanel.cacheListView == nil then
		return 
	end
	
	local cell = TreasureSellSeatCell:createCell()
	cell:init(self.dTreasureArray[TreasureMaterialSelectPanel.asyncIndex], 2, TreasureMaterialSelectPanel.asyncIndex)
	TreasureMaterialSelectPanel.cacheListView:addChild(cell)
	-- TreasureMaterialSelectPanel.cacheListView:requestRefreshView()
	TreasureMaterialSelectPanel.asyncIndex = TreasureMaterialSelectPanel.asyncIndex + 1
	for i, equip in pairs(self.selectedTreasure) do
		if equip == cell.treasureInstance then
			cell.status = true
			if cell.statusBoxArt ~= nil then
				cell.statusBoxArt:setVisible(true)
			end
		end
	end
end

--更新显示区域 初始化使用就行了 不要没事就刷哦
function TreasureMaterialSelectPanel:onUpdateListView()

	--刷新listview
	self.dTreasureArray = self:getSortedTreasure()
	self.treasureListView:removeAllItems()
	
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	TreasureMaterialSelectPanel.asyncIndex = 1
	TreasureMaterialSelectPanel.cacheListView = self.treasureListView
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(self.dTreasureArray) do
			local cell = TreasureSellSeatCell:createCell()
			cell:init(v, 2, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(self.treasureListView, TreasureSellSeatCell.__size)
				self.treasureListView:addChild(multipleCell)
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
			for i, equip in pairs(self.selectedTreasure) do
				if equip == cell.treasureInstance then
					cell.status = true
					if cell.statusBoxArt ~= nil then
						cell.statusBoxArt:setVisible(true)
					end
				end
			end
		end
	else
		for i,v in pairs(self.dTreasureArray) do
			-- local cell = TreasureSellSeatCell:createCell()
			-- cell:init(v, 2)
			-- self.treasureListView:addChild(cell)
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
			self:loading_cell(nil)
		end
		-- local cells = self.treasureListView:getItems()
		-- for i, cell in pairs(cells) do
			-- for s, treasure in pairs(self.selectedTreasure) do
				-- if treasure == cell.treasureInstance then
					-- cell.status = true
					-- cell.statusBoxArt:setVisible(true)
				-- end
			-- end
		-- end
	end
	self.treasureListView:requestRefreshView()

	self.currentListView = self.treasureListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

	--更新显示的数量
	self.cacheSelectCountText:setString(tostring(self.selectCount))
	
end

function TreasureMaterialSelectPanel:onUpdate(dt)
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

function TreasureMaterialSelectPanel:onEnterTransitionFinish()

	--获取美术资源 --强化材料选择
    local csbTreasureRefine = csb.createNode("packs/TreasureStorage/treasure_sell.csb")
	local root = csbTreasureRefine:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local action = csb.createTimeline("packs/TreasureStorage/treasure_sell.csb")
		table.insert(self.actions, action)
		root:runAction(action)
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end

			local str = frame:getEvent()
			if str == "window_open_over" then

			elseif str == "window_close_over" then
				state_machine.excute("treasure_sell_return_xinfa_page_close", 0, 0)
			end
		end)

		if action:IsAnimationInfoExists("window_open") == true then
			action:play("window_open", false)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_xzbw_sell"):setVisible(false)
	--返回宝物强化界面 Panel_xzbw_sell
	local treasure_material_retrun_button = ccui.Helper:seekWidgetByName(root, "Button_1")
	fwin:addTouchEventListener(treasure_material_retrun_button, nil, 
	{
		terminal_name = "treasure_material_return_treasure_strengthen", 
		next_terminal_name = "", 
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--确认
	local treasure_material_ok_button = ccui.Helper:seekWidgetByName(root, "Button_xzbw_qd")
	fwin:addTouchEventListener(treasure_material_ok_button, nil, 
	{
		terminal_name = "treasure_material_select_ok", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		selectedTable = self.selectedTreasure
	}, 
	nil, 0)
	
	--宝物选择面板
	local treasure_material_select = ccui.Helper:seekWidgetByName(root, "Panel_xzbw_choose")
	treasure_material_select:setVisible(true)
	
	--缓存self.treasureListView
	self.treasureListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	
	--缓存 显示已经选择数量的文本
	self.cacheSelectCountText = ccui.Helper:seekWidgetByName(root, "Text_xzbw_2")
	
	--更新显示区域
	self:onUpdateListView()
end

--获得我拥有的材料数组 包含判断如果已经装备将会被过滤
function TreasureMaterialSelectPanel:getSortedTreasure()
	
	 -- 宝物排序
	self.dTreasureArray={}
	
	--得到宝物数组
	local function getTrArray()
		local pIndex = 1
		for i, trInfo in pairs(_ED.user_equiment) do
			if tonumber(trInfo.equipment_type) > 3  and tonumber(trInfo.equipment_type) < 6 and tonumber(trInfo.ship_id) == 0 
			-- and tonumber(self.currentTreasure.ship_id) ~= tonumber(trInfo.ship_id) 
			and dms.int(dms["equipment_mould"], tonumber(trInfo.user_equiment_template), equipment_mould.grow_level) < 5 or tonumber(trInfo.equipment_type) == 8 then
				if tonumber(self.currentTreasure.user_equiment_id) ~= tonumber(trInfo.user_equiment_id) then
					self.dTreasureArray[pIndex] = trInfo
					pIndex = pIndex + 1			
				end
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
		
		local result = false
		
		if ( ae>0 and 
			(
				((be>0) and (aq<bq)) 
				or (((be > 0) and (aq<bq)) 
				or ((be > 0) and (aq==bq) and (ar < br)) 
				or ((be > 0) and (aq==bq) and (ar == br) and (at < bt)) )
				or (be <= 0) 
				or (aq>bq)
				or ((aq==bq)and (ar < br))
				or ((aq==bq)and (ar == br) and (at < bt))
			)
		) then
			result = true
		elseif( ae<=0 and (
			((be <= 0) and (aq<bq))
			or ((be <= 0) and (aq<bq))
			or ((be <= 0) and (aq == bq) and (ar<br))
			or ((be <= 0) and (aq==bq) and (ar==br) and (at < bt))
		) 
		) then
			result = true
		end
		
		return result 
	end
	
	getTrArray()
	table.sort(self.dTreasureArray, userTrSortFunc)
	return self.dTreasureArray
end

function TreasureMaterialSelectPanel:init(value, currentTreasure)
	self.selectedTreasure = value
	self.selectCount = #self.selectedTreasure
	self.currentTreasure = currentTreasure
end

function TreasureMaterialSelectPanel:onExit()
	TreasureMaterialSelectPanel.asyncIndex = 1
	TreasureMaterialSelectPanel.cacheListView = nil

	state_machine.remove("treasure_material_select_ok")
	state_machine.remove("treasure_material_return_treasure_strengthen")
	state_machine.remove("treasure_material_selected_one")
	state_machine.remove("treasure_sell_return_xinfa_page_close")
end
