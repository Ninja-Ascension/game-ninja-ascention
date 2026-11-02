-- ----------------------------------------------------------------------------------------------------
-- 说明：装备出售界面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipSell = class("EquipSellClass", Window)
   
function EquipSell:ctor()
    self.super:ctor()
	self._cover = true
	self.roots = {}
	self.actions = {}
	self.data = {}
	self.selNum = 0
	self.selMoney = 0
	self.status = false
	self.istrue = false

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

    -- Initialize Home page state machine.
    local function init_equip_sell_terminal()
    	local equip_sell_return_equipment_page_close_terminal = {
            _name = "equip_sell_return_equipment_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("equip_list_view_remove_cell", 0, "equip_list_view_remove_cell.")
				fwin:close(fwin:find("EquipSellClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local equip_sell_return_equipment_page_terminal = {
            _name = "equip_sell_return_equipment_page",
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
					local obj = fwin:find("EquipSellClass")
					if obj ~= nil then
						local action = obj.actions[1]
						if action ~= nil and action:IsAnimationInfoExists("window_close") == true then
							obj.actions[1]:play("window_close", false)
						else
							state_machine.excute("equip_sell_return_equipment_page_close", 0, 0)
						end
					end
				else
					state_machine.excute("equip_list_view_remove_cell", 0, "equip_list_view_remove_cell.")
					fwin:close(instance)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_sell_choose_quality_terminal = {
            _name = "equip_sell_choose_quality",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if self.istrue == false then
					TipDlg.drawTextDailog(_string_piece_info[109])
				else
					if self.status == true then
						local cell = EquipSellChooseByQuality:new()
						cell:init(params._datas._sort)
						fwin:open(cell, fwin._dialog)
					else
						TipDlg.drawTextDailog(_string_piece_info[108])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_sell_sure_sell_terminal = {
            _name = "equip_sell_sure_sell",
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
            		if instance.selNum == 0 then
            			TipDlg.drawTextDailog(_string_piece_info[109])
            			return
            		end
            	end
				if self.istrue == false then
					TipDlg.drawTextDailog(_string_piece_info[109])
				else
					local root = instance.roots[1]
					local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
					local items = listView:getItems()
					local num = 1
					instance.data = {}
					for i, v in pairs(items) do
						if v.__cname == "MultipleListViewCellClass" then
							if v.child1 ~= nil then
								local cell = v.child1
								local equipmentInstance = cell.equipmentInstance
							
								if cell.status == true then
									instance.data[num] =  equipmentInstance
									num = num + 1
								end
							end
							if v.child2 ~= nil then
								local cell = v.child2
								local equipmentInstance = cell.equipmentInstance
							
								if cell.status == true then
									instance.data[num] =  equipmentInstance
									num = num + 1
								end
							end
						else
							local cell = v
							local equipmentInstance = cell.equipmentInstance
							
							if cell.status == true then
								instance.data[num] =  equipmentInstance
								num = num + 1
							end
						end
					end
					local EquipSellTip = EquipSellTip:new()
					EquipSellTip:init(instance.data)
					fwin:open(EquipSellTip, fwin._dialog)
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 批量出售道具
		local equip_sell_batch_sell_terminal = {
            _name = "equip_sell_batch_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				local tempQuality = params._datas.quality
				local tempStatus =params._datas.status
				local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
				local items = listView:getItems()
				for i, v in pairs(items) do
					if v.__cname == "MultipleListViewCellClass" then
						if v.child1 ~= nil then
							state_machine.excute("equip_choose_list_page_choose_update", 0, {_datas = {cell = v.child1, quality = tempQuality, status = tempStatus}})
						end
						if v.child2 ~= nil then
							state_machine.excute("equip_choose_list_page_choose_update", 0, {_datas = {cell = v.child2, quality = tempQuality, status = tempStatus}})
						end
					else
						state_machine.excute("equip_choose_list_page_choose_update", 0, {_datas = {cell = v, quality = tempQuality, status = tempStatus}})
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 刷新选中数量与金钱
		local equip_sell_update_cell_status_terminal = {
            _name = "equip_sell_update_cell_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params.cell
				local equipmentInstance = params.equipmentInstance
				if cell.status == true then
					instance.selNum = instance.selNum + 1
					instance.selMoney = instance.selMoney + equipmentInstance.sell_price
				else 
					instance.selNum = math.max(instance.selNum - 1,0)
					instance.selMoney =math.max(instance.selMoney - equipmentInstance.sell_price,0)
				end
				instance:updateSellInfo()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 出售成功刷新界面
		local equip_sell_true_update_cell_status_terminal = {
            _name = "equip_sell_true_update_cell_status",
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
		
		state_machine.add(equip_sell_return_equipment_page_close_terminal)
		state_machine.add(equip_sell_return_equipment_page_terminal)
		state_machine.add(equip_sell_choose_quality_terminal)
		state_machine.add(equip_sell_sure_sell_terminal)
		state_machine.add(equip_sell_batch_sell_terminal)
		state_machine.add(equip_sell_update_cell_status_terminal)
		state_machine.add(equip_sell_true_update_cell_status_terminal)

        state_machine.init()
    end
    
    init_equip_sell_terminal()
end

function EquipSell:cleanListView()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local items = listView:getItems()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		listView:removeAllItems()
		self:onUpdateDraw()
	else
		for i, v in pairs(items) do
			if v.__cname == "MultipleListViewCellClass" then
				if v.child1 ~= nil and v.child1.status == true then
					v.child1:removeFromParent(true)
					v.child1 = nil
				end
				if v.child2 ~= nil and v.child2.status == true then
					v.child2:removeFromParent(true)
					v.child2 = nil
				end
				state_machine.excute("multiple_list_view_cell_manager", 0, v)
			else
				if v.status == true then
					listView:removeItem(listView:getIndex(v))
				end
			end
		end
	end
	self.selNum = 0
	self.selMoney = 0
	-- self.status = false
	self:updateSellInfo()
	self.data = {}
	local item = listView:getItems()
	local tip = false
	for i, v in pairs(item) do
		tip = true
	end
	if tip == false then
		self.status = false
	end
end

function EquipSell:updateSellInfo()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_zbshul"):setString(self.selNum)
	ccui.Helper:seekWidgetByName(root, "Text_zbjiag"):setString(self.selMoney)
end

function EquipSell:loading_cell()
	if EquipSell.cacheListView == nil then
		return 
	end
	
	local cell = EquipChooseListCell:createCell()
	cell:init(self.all[EquipSell.asyncIndex], nil, EquipSell.asyncIndex)
	EquipSell.cacheListView:addChild(cell)
	-- EquipSell.cacheListView:requestRefreshView()
	EquipSell.asyncIndex = EquipSell.asyncIndex + 1
end

function EquipSell:onUpdateDraw()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_zb"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Panel_xzzb_sell"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Panel_xzzb_choose"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_zb"):setVisible(true)
	
	
	
	local hero = {}
	
	for i, v in pairs(_ED.user_equiment) do
		hero[i] = v
	end
	local whiteNum = 1
	local greenNum = 1
	local blueNum = 1
	local purpleNum = 1
	local yellowNum = 1
	local redNum = 1
	local allNum = 1
	local white = {}
	local green = {}
	local blue = {}
	local purple = {}
	local yellow = {}
	local red = {}
	self.all = {}
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	for i,v in pairs(hero) do
		if (dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.is_sell) == 1)
		    and (dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.equipment_type) < 4 )
			and zstring.tonumber(v.ship_id) == 0 then
				if dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 0 then
					white[whiteNum] = v
					whiteNum = whiteNum + 1
					self.status = true
				elseif dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 1 then
					green[greenNum] = v
					greenNum = greenNum + 1
					self.status = true
				elseif dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 2 then
					blue[blueNum] = v
					blueNum = blueNum + 1
					self.status = true
				elseif dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 3 then
					purple[purpleNum] = v
					purpleNum = purpleNum + 1
					self.status = true
				elseif dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 4 then
					yellow[yellowNum] = v
					yellowNum = yellowNum + 1
					self.status = true
				elseif dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 5 then
					red[redNum] = v
					redNum = redNum + 1
					self.status = true
				end
		end
	end
	
	for i, v in pairs(white) do
		self.all[allNum] = v
		allNum = allNum + 1
	end
	for i, v in pairs(green) do
		self.all[allNum] = v
		allNum = allNum + 1
	end
	for i, v in pairs(blue) do
		self.all[allNum] = v
		allNum = allNum + 1
	end
	for i, v in pairs(purple) do
		self.all[allNum] = v
		allNum = allNum + 1
	end
	for i, v in pairs(yellow) do
		self.all[allNum] = v
		allNum = allNum + 1
	end
	for i, v in pairs(red) do
		self.all[allNum] = v
		allNum = allNum + 1
	end

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	EquipSell.asyncIndex = 1
	EquipSell.cacheListView = listView
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(self.all) do
			local cell = EquipChooseListCell:createCell()
			cell:init(v, nil, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(listView, EquipChooseListCell.__size)
				listView:addChild(multipleCell)
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
			self.istrue = true
		end
	else
		for i, v in pairs(self.all) do
			-- local cell = EquipChooseListCell:createCell()
			-- cell:init(v)
			-- listView:addChild(cell)
			
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
			self:loading_cell(nil)	
			
			self.istrue = true
		end
	end

	listView:requestRefreshView()


	self.currentListView = listView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

	if self.istrue == false then
		TipDlg.drawTextDailog(_string_piece_info[109])
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "equip_sell_choose_quality", terminal_state = 0, _sort = self.all,isPressedActionEnabled = true
		-- func_string = [[state_machine.excute("equip_sell_choose_quality", 0, "click equip_sell_choose_quality.'")]], isPressedActionEnabled = true
	}, 
	nil, 1)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {func_string = [[state_machine.excute("equip_sell_sure_sell", 0, "click equip_sell_sure_sell.'")]], isPressedActionEnabled = true}, nil, 0)
end

function EquipSell:onUpdate(dt)
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

function EquipSell:onEnterTransitionFinish()
    local csbEquipSell = csb.createNode("packs/EquipStorage/equipment_sell.csb")
	local root = csbEquipSell:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbEquipSell)

	local backButton = ccui.Helper:seekWidgetByName(root, "Button_1")
	fwin:addTouchEventListener(backButton, nil, {func_string = [[state_machine.excute("equip_sell_return_equipment_page", 0, "click treasure_sell_return_treasure_page.'")]], isPressedActionEnabled = true}, nil,2)
	
	self:onUpdateDraw()
	self:updateSellInfo()

	local action = csb.createTimeline("packs/EquipStorage/equipment_sell.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then

        elseif str == "window_close_over" then
            state_machine.excute("equip_sell_return_equipment_page_close", 0, 0)
        end
    end)

    if action:IsAnimationInfoExists("window_open") == true then
    	action:play("window_open", false)
	end
end
function EquipSell:close()
 	--关闭时清空选中状态
	EquipSellChooseByQuality.white = false
	EquipSellChooseByQuality.blue = false
	EquipSellChooseByQuality.green = false
end
function EquipSell:onExit()
	EquipSell.asyncIndex = 1
	EquipSell.cacheListView = nil

	state_machine.remove("equip_sell_return_equipment_page_close")
	state_machine.remove("equip_sell_return_equipment_page")
	state_machine.remove("equip_sell_choose_quality")
	state_machine.remove("equip_sell_sure_sell")
	state_machine.remove("equip_sell_batch_sell")
	state_machine.remove("equip_sell_update_cell_status")
	state_machine.remove("equip_sell_true_update_cell_status")

end
