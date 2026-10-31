-- ----------------------------------------------------------------------------------------------------
-- 说明：宝物出售界面
-- 创建时间2015-03-03 21:31
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

TreasuresSell = class("TreasuresSellClass", Window)
    
function TreasuresSell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	
	self.selectedCount = 0			-- 总共选择了多少个宝物
	self.totalMoney = 0				-- 一共可卖多少钱
	
	self.selectedTreasure = {}		-- 缓存总共选择了多少个宝物的实例
	
	self.cacheCountText = nil		-- 缓存显示数量的控件
	self.cacheMoneyText = nil		-- 缓存显示总价的控件
	
	self.treasureListView = nil		-- 保存宝物的ListView控件

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	
	self.selectGrow = 0				-- 缓存自动选择 品质值
	self.status = false
	self.sort = {}
	app.load("client.cells.treasure.treasure_sell_seat_cell")
	app.load("client.packs.treasure.TreasureSellTips")
	app.load("client.packs.treasure.TreasureAutoSelectPanel")
    
    -- Initialize TreasuresSell page state machine.
    local function init_treasures_sell_terminal()
		local treasure_sell_return_treasure_page_close_terminal = {
            _name = "treasure_sell_return_treasure_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(fwin:find("TreasuresSellClass"))
				state_machine.excute("menu_show_event", 0, "event menu_hide_event.")
				state_machine.excute("treasure_storage_sell_remove_cell", 0, "event treasure_storage_sell_remove_cell.")
				state_machine.excute("treasure_storage_back_treasure_storages", 0, "click treasure_storage_back_treasure_storages.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--返回宝物仓库界面
		local treasure_sell_return_treasure_page_terminal = {
            _name = "treasure_sell_return_treasure_page",
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
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
					local obj = fwin:find("TreasuresSellClass")
					if obj ~= nil then
						local action = obj.actions[1]
						if action ~= nil and action:IsAnimationInfoExists("window_close") == true then
							obj.actions[1]:play("window_close", false)
						else
							state_machine.excute("treasure_sell_return_treasure_page_close", 0, 0)
						end
					end
				else
					fwin:close(instance)
					state_machine.excute("menu_show_event", 0, "event menu_hide_event.")
					state_machine.excute("treasure_storage_sell_remove_cell", 0, "event treasure_storage_sell_remove_cell.")
					state_machine.excute("treasure_storage_back_treasure_storages", 0, "click treasure_storage_back_treasure_storages.")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--出售按钮按下 并且弹出提示弹窗
		local treasure_sell_tips_terminal = {
            _name = "treasure_sell_tips",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--> print("treasure_sell_excute_terminal")
				--fwin:close(instance)
				--state_machine.excute("treasure_storage_back_treasure_storages", 0, "click treasure_storage_back_treasure_storages.")
				if self.selectedCount > 0 then
					local tst = TreasureSellTip:new()
					local tmpStr = _string_piece_info[55] .. self.selectedCount .. _string_piece_info[56] .. self.totalMoney .. _string_piece_info[57]
					tst:init(tmpStr)
					fwin:open(tst, fwin._windows)
				else
					TipDlg.drawTextDailog(_string_piece_info[171])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--最终确认出售
		local treasure_sell_excute_terminal = {
            _name = "treasure_sell_excute",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if self.selectedCount > 0 then
					self:excuteSellTreasure()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--自动选择
		local treasure_sell_auto_select_terminal = {
            _name = "treasure_sell_auto_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--> print("treasure_sell_auto_select_terminal")
				if self.status == true then
					local cell = TreasureAutoSelectPanel:new()
					cell:init(self.sort)
					fwin:open(cell, fwin._windows)
				else
					TipDlg.drawTextDailog(_string_piece_info[169])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新宝物列表
		local treasure_sell_refresh_list_terminal = {
            _name = "treasure_sell_refresh_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				self.selectedCount = 0
				self.totalMoney = 0
				instance:onUpdateListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--按品质选择宝物
		local treasure_sell_select_form_grow_terminal = {
            _name = "treasure_sell_select_form_grow",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.selectGrow = tonumber(params[1])
				instance:selectFromGrow(instance.selectGrow)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--按品质取【消选】择宝物
		local treasure_sell_cancel_select_form_grow_terminal = {
            _name = "treasure_sell_cancel_select_form_grow",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.selectGrow = tonumber(params[1])
				instance:cancelSelectFromGrow(instance.selectGrow)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--选择一个宝物
		local treasure_sell_selected_on_off_terminal = {
            _name = "treasure_sell_selected_on_off",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- local cell = params._datas.cell
				-- local statusBoxArt = params._datas.cell.statusBoxArt
				-- if statusBoxArt:isVisible() == true then
				-- 	statusBoxArt:setVisible(false)
				-- 	self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
				-- 	self.totalMoney = self.totalMoney - cell.myPrice				-- 一共可卖多少钱
				-- 	self:removeSelectedTreasure(self.selectedTreasure, cell.treasureInstance)
				-- else
				-- 	statusBoxArt:setVisible(true)
				-- 	self.selectedCount = self.selectedCount + 1						-- 总共选择了多少个宝物
				-- 	self.totalMoney = self.totalMoney + cell.myPrice				-- 一共可卖多少钱
				-- 	table.insert(self.selectedTreasure, cell.treasureInstance)
				-- end

				local cell = params._datas.cell
				local statusBoxArt = cell.statusBoxArt
				if cell.selected == true then
					cell.selected = false
					self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
					self.totalMoney = self.totalMoney - cell.myPrice				-- 一共可卖多少钱
					self:removeSelectedTreasure(self.selectedTreasure, cell.treasureInstance)
				else
					cell.selected = true
					self.selectedCount = self.selectedCount + 1						-- 总共选择了多少个宝物
					self.totalMoney = self.totalMoney + cell.myPrice				-- 一共可卖多少钱
					table.insert(self.selectedTreasure, cell.treasureInstance)
				end
				if statusBoxArt ~= nil then
					statusBoxArt:setVisible(cell.selected)
				end
				--更新数据
				self:updateCountAndPrice()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(treasure_sell_return_treasure_page_close_terminal)
		state_machine.add(treasure_sell_auto_select_terminal)
		state_machine.add(treasure_sell_tips_terminal)
		state_machine.add(treasure_sell_return_treasure_page_terminal)
		state_machine.add(treasure_sell_refresh_list_terminal)
		state_machine.add(treasure_sell_selected_on_off_terminal)
		state_machine.add(treasure_sell_select_form_grow_terminal)
		state_machine.add(treasure_sell_cancel_select_form_grow_terminal)
		state_machine.add(treasure_sell_excute_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasures_sell_terminal()
end


function TreasuresSell:removeSelectedTreasure(tmpTable, value)
	local index = 1
	for i, v in pairs(tmpTable) do
		if v == value then
			table.remove(tmpTable, index)
			break
		end
		index = index + 1
	end
end

--按品质选择宝物
function TreasuresSell:selectFromGrow(grow)

	--得到宝物数组
	for i, trInfo in pairs(self.treasureListView:getItems()) do
		if trInfo.__cname == "MultipleListViewCellClass" then
			if trInfo.child1 ~= nil then
				local tmpGrow = dms.int(dms["equipment_mould"], trInfo.child1.treasureInstance.user_equiment_template, equipment_mould.grow_level) + 1
				if trInfo.child1.selected == false then
					trInfo.child1.selected = true
					self.selectedCount = self.selectedCount + 1						-- 总共选择了多少个宝物
					self.totalMoney = self.totalMoney + trInfo.child1.myPrice				-- 一共可卖多少钱
					table.insert(self.selectedTreasure, trInfo.child1.treasureInstance)
					if trInfo.child1.statusBoxArt ~= nil then
						trInfo.child1.statusBoxArt:setVisible(true)
					end
				end
			end
			if trInfo.child2 ~= nil then
				local tmpGrow = dms.int(dms["equipment_mould"], trInfo.child2.treasureInstance.user_equiment_template, equipment_mould.grow_level) + 1
				if trInfo.child2.selected == false then
					trInfo.child2.selected = true
					self.selectedCount = self.selectedCount + 1						-- 总共选择了多少个宝物
					self.totalMoney = self.totalMoney + trInfo.child2.myPrice				-- 一共可卖多少钱
					table.insert(self.selectedTreasure, trInfo.child2.treasureInstance)
					if trInfo.child2.statusBoxArt ~= nil then
						trInfo.child2.statusBoxArt:setVisible(true)
					end
				end
			end
		else
			local tmpGrow = dms.int(dms["equipment_mould"], trInfo.treasureInstance.user_equiment_template, equipment_mould.grow_level) + 1
			-- if tmpGrow == grow then
			-- 	if trInfo.statusBoxArt:isVisible() == false then
			-- 		trInfo.statusBoxArt:setVisible(true)
			-- 		self.selectedCount = self.selectedCount + 1						-- 总共选择了多少个宝物
			-- 		self.totalMoney = self.totalMoney + trInfo.myPrice				-- 一共可卖多少钱
			-- 		table.insert(self.selectedTreasure, trInfo.treasureInstance)
			-- 	end
			-- -- elseif tmpGrow ~= grow then
			-- 	-- trInfo.statusBoxArt:setVisible(false)
			-- 	-- if trInfo.statusBoxArt:isVisible() == true then
			-- 		-- self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
			-- 		-- self.totalMoney = self.totalMoney - trInfo.myPrice				-- 一共可卖多少钱
			-- 	-- end
			-- end

			if tmpGrow == grow then
				if trInfo.selected == false then
					trInfo.selected = true
					self.selectedCount = self.selectedCount + 1						-- 总共选择了多少个宝物
					self.totalMoney = self.totalMoney + trInfo.myPrice				-- 一共可卖多少钱
					table.insert(self.selectedTreasure, trInfo.treasureInstance)
					if trInfo.statusBoxArt ~= nil then
						trInfo.statusBoxArt:setVisible(true)
					end
				end
			end
		end
	end
	--更新选中数量和总价格
	self:updateCountAndPrice()
end

--按品质选【取消】择宝物
function TreasuresSell:cancelSelectFromGrow(grow)

	--得到宝物数组
	for i, trInfo in pairs(self.treasureListView:getItems()) do
		if trInfo.__cname == "MultipleListViewCellClass" then
			if trInfo.child1 ~= nil then
				local tmpGrow = dms.int(dms["equipment_mould"], trInfo.child1.treasureInstance.user_equiment_template, equipment_mould.grow_level) + 1
				-- if tmpGrow == grow then
				-- 	if trInfo.statusBoxArt:isVisible() == true then
				-- 		trInfo.statusBoxArt:setVisible(false)
				-- 		self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
				-- 		self.totalMoney = self.totalMoney - trInfo.myPrice				-- 一共可卖多少钱
				-- 		-- table.insert(self.selectedTreasure, trInfo.treasureInstance)
				-- 		self:removeSelectedTreasure(self.selectedTreasure, trInfo.treasureInstance)
				-- 	end
				-- end

				if tmpGrow == grow then
					if trInfo.child1.selected == true then
						trInfo.child1.selected = false
						self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
						self.totalMoney = self.totalMoney - trInfo.child1.myPrice				-- 一共可卖多少钱
						-- table.insert(self.selectedTreasure, trInfo.treasureInstance)
						self:removeSelectedTreasure(self.selectedTreasure, trInfo.child1.treasureInstance)
						if trInfo.child1.statusBoxArt ~= nil then
							trInfo.child1.statusBoxArt:setVisible(false)
						end
					end
				end
			end
			if trInfo.child2 ~= nil then
				local tmpGrow = dms.int(dms["equipment_mould"], trInfo.child2.treasureInstance.user_equiment_template, equipment_mould.grow_level) + 1
				-- if tmpGrow == grow then
				-- 	if trInfo.statusBoxArt:isVisible() == true then
				-- 		trInfo.statusBoxArt:setVisible(false)
				-- 		self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
				-- 		self.totalMoney = self.totalMoney - trInfo.myPrice				-- 一共可卖多少钱
				-- 		-- table.insert(self.selectedTreasure, trInfo.treasureInstance)
				-- 		self:removeSelectedTreasure(self.selectedTreasure, trInfo.treasureInstance)
				-- 	end
				-- end

				if tmpGrow == grow then
					if trInfo.child2.selected == true then
						trInfo.child2.selected = false
						self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
						self.totalMoney = self.totalMoney - trInfo.child2.myPrice				-- 一共可卖多少钱
						-- table.insert(self.selectedTreasure, trInfo.treasureInstance)
						self:removeSelectedTreasure(self.selectedTreasure, trInfo.child2.treasureInstance)
						if trInfo.child2.statusBoxArt ~= nil then
							trInfo.child2.statusBoxArt:setVisible(false)
						end
					end
				end
			end
		else
			local tmpGrow = dms.int(dms["equipment_mould"], trInfo.treasureInstance.user_equiment_template, equipment_mould.grow_level) + 1
			-- if tmpGrow == grow then
			-- 	if trInfo.statusBoxArt:isVisible() == true then
			-- 		trInfo.statusBoxArt:setVisible(false)
			-- 		self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
			-- 		self.totalMoney = self.totalMoney - trInfo.myPrice				-- 一共可卖多少钱
			-- 		-- table.insert(self.selectedTreasure, trInfo.treasureInstance)
			-- 		self:removeSelectedTreasure(self.selectedTreasure, trInfo.treasureInstance)
			-- 	end
			-- end

			if tmpGrow == grow then
				if trInfo.selected == true then
					trInfo.selected = false
					self.selectedCount = self.selectedCount - 1						-- 总共选择了多少个宝物
					self.totalMoney = self.totalMoney - trInfo.myPrice				-- 一共可卖多少钱
					-- table.insert(self.selectedTreasure, trInfo.treasureInstance)
					self:removeSelectedTreasure(self.selectedTreasure, trInfo.treasureInstance)
					if trInfo.statusBoxArt ~= nil then
						trInfo.statusBoxArt:setVisible(false)
					end
				end
			end
		end
	end
	--更新选中数量和总价格
	self:updateCountAndPrice()
end
function TreasuresSell:afterExcuteSellTreasure( )
			--更新金钱
			--_ED.user_info.user_silver = _ED.user_info.user_silver + self.totalMoney
	--删除宝物
	TipDlg.drawTextDailog(_string_piece_info[93]..self.totalMoney)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		for i, v in pairs(self.selectedTreasure) do
			self:delTreasureForID(v)
		end
		self:onUpdateListView(false)
		state_machine.excute("treasure_list_view_del_and_insert_cell",0,"")
		
	else
		for i, v in pairs(self.selectedTreasure) do
			self:delTreasureForID(v)					
			self:removeListViewFormTreasure(v)
		end
	end
	self:resetCountAndPrice()
	self.selectedTreasure = {}
	--刷新顶部信息
	state_machine.excute("user_info_hero_storage_update", 0, "click user_info_hero_storage_update.")
end
--确认出售道具叭叭叭叭叭 撸服务器去
function TreasuresSell:excuteSellTreasure()
	
	--服务器返回
	local function responseSellHeroCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil then
				response.node:afterExcuteSellTreasure()
			end
			--更新金钱
			--_ED.user_info.user_silver = _ED.user_info.user_silver + self.totalMoney
			-- --删除宝物
			-- TipDlg.drawTextDailog(_string_piece_info[93]..self.totalMoney)
			-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			-- 	for i, v in pairs(self.selectedTreasure) do
			-- 		self:delTreasureForID(v)
			-- 	end
			-- 	self:onUpdateListView()
			-- 	state_machine.excute("treasure_list_view_del_and_insert_cell",0,"")
				
			-- else
			-- 	for i, v in pairs(self.selectedTreasure) do
			-- 		self:delTreasureForID(v)					
			-- 		self:removeListViewFormTreasure(v)
			-- 	end
			-- end
			-- self:resetCountAndPrice()
			-- self.selectedTreasure = {}
			-- --刷新顶部信息
			-- state_machine.excute("user_info_hero_storage_update", 0, "click user_info_hero_storage_update.")
			-- state_machine.excute("treasure_storage_back_treasure_storages", 0, "click treasure_storage_back_treasure_storages.")
		-- else
			--> print("q12341231890742389473274823784723984792374982739847982379842738")
		end
	end
	
	local temp = nil
	for i, v in pairs(self.selectedTreasure) do
		if i == 1 then
			--> print("12312kmasdklasjdklasjdkasjdlkasjlkjaskldjasd", v.user_equiment_id)
			temp = v.user_equiment_id
		else
			temp = temp .. "," .. v.user_equiment_id
		end
	end
	
	--撸服务器
	protocol_command.equipment_sell.param_list = temp
	NetworkManager:register(protocol_command.equipment_sell.code, nil, nil, nil, self, responseSellHeroCallback, false, nil)
end


--从显示列表中删除treasure选项卡
function TreasuresSell:removeListViewFormTreasure(treasure)
	for i, v in pairs(self.treasureListView:getItems()) do
		if v.__cname == "MultipleListViewCellClass" then
			if v.child1 ~= nil and v.child1.treasureInstance == treasure then
				v.child1:removeFromParent(true)
				v.child1 = nil
			end
			if v.child2 ~= nil and v.child2.treasureInstance == treasure then
				v.child2:removeFromParent(true)
				v.child2 = nil
			end
			state_machine.excute("multiple_list_view_cell_manager", 0, v)
		else
			if v.treasureInstance == treasure then
				self.treasureListView:removeItem(i - 1)
			end
		end
	end
end

--从数据中心中删除一个宝物（装备）
function TreasuresSell:delTreasureForID(treasureInstace)
	for i, v in pairs(_ED.user_equiment) do
		if v.user_equiment_id == treasureInstace.user_equiment_id then
			table.remove(_ED.user_equiment, i)
			break
		end
	end
end

function TreasuresSell.loading(texture)
	local myListView = TreasuresSell.myListView
	if myListView ~= nil then
		local cell = TreasureSellSeatCell:createCell()
		cell:init(TreasuresSell.dTreasureArray[TreasuresSell.asyncIndex], 1, TreasuresSell.asyncIndex)
		myListView:addChild(cell)
		TreasuresSell.asyncIndex = TreasuresSell.asyncIndex + 1
		-- myListView:requestRefreshView()
	end
end

function TreasuresSell:onUpdateListView(isShowTips)
	--local root = self.roots[1]
	local dTreasureArray = self:getSortedTreasure()
	self.sort = dTreasureArray
	self.treasureListView:removeAllItems()
	local status = false
	-- for i,v in pairs(dTreasureArray) do
	-- 	local cell = TreasureSellSeatCell:createCell()
	-- 	cell:init(v, 1)
	-- 	self.treasureListView:addChild(cell)
	-- 	status = true
	-- end

	TreasuresSell.myListView = self.treasureListView
	TreasuresSell.dTreasureArray = dTreasureArray
	TreasuresSell.asyncIndex = 1
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
		for i,v in pairs(dTreasureArray) do
			local cell = TreasureSellSeatCell:createCell()
			cell:init(v, 1, i)
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
		end
	else
		for i,v in pairs(dTreasureArray) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			self.loading(nil)
			status = true
		end
	end
	self.treasureListView:requestRefreshView()

	self.currentListView = self.treasureListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	if status == false and isShowTips ~= false then
		TipDlg.drawTextDailog(_string_piece_info[168])
	end
	self:updateCountAndPrice()
end

function TreasuresSell:getSortedTreasure()
	 -- 宝物排序
	local dTreasureArray={}
	
	--得到宝物数组
	local function getTrArray()
		local pIndex = 1
		for i, trInfo in pairs(_ED.user_equiment) do
			if tonumber(trInfo.equipment_type) > 3  and tonumber(trInfo.equipment_type) < 6 and tonumber(trInfo.ship_id) == 0 then
				dTreasureArray[pIndex]=trInfo
				pIndex = pIndex + 1
				local level = dms.int(dms["equipment_mould"], tonumber(trInfo.user_equiment_template), equipment_mould.grow_level)
				if level >= 0 and level <= 2 then
					self.status = true
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
	table.sort(dTreasureArray, userTrSortFunc)
	return dTreasureArray
end


function TreasuresSell:onUpdate(dt)
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

function TreasuresSell:onEnterTransitionFinish()
    local csbTreasuresSell = csb.createNode("packs/TreasureStorage/treasure_sell.csb")
    local root = csbTreasuresSell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbTreasuresSell)

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
            state_machine.excute("treasure_sell_return_treasure_page_close", 0, 0)
        end
    end)

    if action:IsAnimationInfoExists("window_open") == true then
    	action:play("window_open", false)
	end
	
	-- 显示宝物出售主界面
	-- local treasure_sell_bottom_panel = ccui.Helper:seekWidgetByName(root, "Panel_zb")
	-- treasure_sell_bottom_panel:setVisible(true)
	
	-- 显示宝物出售美术文字
	local treasure_sell_title_art = ccui.Helper:seekWidgetByName(root, "Image_bw")
	treasure_sell_title_art:setVisible(true)
	treasure_sell_title_art:setTouchEnabled(false)
	
	-- 缓存ListView
	self.treasureListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	
	-- 缓存显示数量的控件 缓存显示总价的控件
	self.cacheCountText = ccui.Helper:seekWidgetByName(root, "Text_zbshul")
	self.cacheCountText:setVisible(true)
	self.cacheMoneyText = ccui.Helper:seekWidgetByName(root, "Text_zbjiag")
	self.cacheMoneyText:setVisible(true)
	
	-- 按品质选择按钮
	self:addTouchEventFunc("Button_2", "treasure_sell_auto_select", true)
	
	-- 出售按钮
	self:addTouchEventFunc("Button_3", "treasure_sell_tips", true)
	
	-- 返回宝物仓库界面
	self:addTouchEventFunc("Button_1", "treasure_sell_return_treasure_page", true )
	
	-- 更新列表
	self:onUpdateListView()
	
	-- 更新选择的数量个总价格
	--self:updateCountAndPrice()
end

--更新总数和价格
function TreasuresSell:updateCountAndPrice()
	self.cacheCountText:setString(self.selectedCount)
	self.cacheMoneyText:setString(self.totalMoney)
end

--重置总数和价格
function TreasuresSell:resetCountAndPrice()
	self.selectedCount = 0
	self.totalMoney = 0
	self.cacheCountText:setString(self.selectedCount)
	self.cacheMoneyText:setString(self.totalMoney)
end

--通用按钮点击事件添加
function TreasuresSell:addTouchEventFunc(uiName, eventName, actionMode)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		next_terminal_name = "", 
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = actionMode
	},
	nil, 2)
	return tmpArt
end

function TreasuresSell:close()
 	--关闭时清空选中状态
	TreasureAutoSelectPanel.blue = false
	TreasureAutoSelectPanel.green = false
end

function TreasuresSell:onExit()
	TreasuresSell.myListView = nil
	TreasuresSell.asyncIndex = 1
	state_machine.remove("treasure_sell_return_treasure_page_close")
	state_machine.remove("treasure_sell_tips")
	state_machine.remove("treasure_sell_auto_select")
	state_machine.remove("treasure_sell_return_treasure_page")
	state_machine.remove("treasure_sell_refresh_list")
	state_machine.remove("treasure_sell_selected_on_off")
	state_machine.remove("treasure_sell_select_form_grow")
	state_machine.remove("treasure_sell_cancel_select_form_grow")
	state_machine.remove("treasure_sell_excute")
end
