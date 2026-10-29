-- ----------------------------------------------------------------------------------------------------
-- 说明：回收界面装备分解界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipChooseForResolve = class("EquipChooseForResolveClass", Window)

function EquipChooseForResolve:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self.sortEquip = {}
	self.selectMaxCount = 5
	self.selectCount = 0

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

    -- Initialize EquipChooseForResolve page state machine.
    local function init_equip_choose_terminal()
       local equip_choose_resolve_sort_terminal = {
            _name = "equip_choose_resolve_sort",
            _init = function (terminal) 
                terminal._sortEquip = {}
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function chooseEquip()
					local list = {}
					local j = 1
					for i, v in pairs(_ED.user_equiment) do
						local shipId = v.user_equiment_id
						local shipData = dms.element(dms["equipment_mould"], v.user_equiment_template)
						local shipQuality = dms.atoi(shipData, equipment_mould.grow_level)
						local equipType = nil
						if dms.atoi(shipData, equipment_mould.equipment_type) <= 3 then
							equipType = 1
						end
						if (equipType == 1 
							and zstring.tonumber(v.ship_id) == 0
							and dms.atoi(shipData, equipment_mould.refining_get_of_stone) >= 0 )
							or dms.atoi(shipData, equipment_mould.refining_items) ~= -1 
							then
							list[j] = v
							j = j+1
						end
					end
					return list
				end
				
				local function compare(a, b)
					local a_quality = dms.int(dms["equipment_mould"], a.user_equiment_template, equipment_mould.grow_level)
					local b_quality = dms.int(dms["equipment_mould"], b.user_equiment_template, equipment_mould.grow_level)
					if a_quality > b_quality then
						return false
					elseif a_quality == b_quality then
						if a.user_equiment_grade > b.user_equiment_grade then
							return false
						end
					end
					return true
				end
				
				local function sortList(list)
					local count = #list
					
					for i=1, count do
						for j=1, count-i do
							if compare(list[j], list[j+1]) == false then
								list[j], list[j+1] = list[j+1], list[j]
							end
						end
					end
					return list
				end
				
				terminal._sortEquip = sortList(chooseEquip())
				return true
            end,
            _terminal = nil,
            _terminals = nil,
			_sortEquip = {}
        }
		
		-- 退回到上一层界面
		local equip_choose_resolve_back_terminal = {
            _name = "equip_choose_resolve_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("EquipChooseForResolveClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 关闭
		local equip_choose_resolve_close_terminal = {
            _name = "equip_choose_resolve_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local equips = {}
				local ListView_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
				local cells = ListView_1:getItems()
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then
					for i, cell in pairs(cells) do
						if cell.child1 ~= nil and cell.child1.status == true then
							table.insert(equips, cell.child1.equipmentInstance)
						end
						if cell.child2 ~= nil and cell.child2.status == true then
							table.insert(equips, cell.child2.equipmentInstance)
						end
					end
				else
					for i, cell in pairs(cells) do
						if cell.status == true then
							table.insert(equips, cell.equipmentInstance)
						end
					end
				end
				state_machine.excute("equip_resolve_update_info", 0, {_datas = {needEquipInfo = equips}})
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
					local obj = fwin:find("EquipChooseForResolveClass")
					if obj ~= nil then
						local action = obj.actions[1]
						if action ~= nil and action:IsAnimationInfoExists("window_close") == true then
							obj.actions[1]:play("window_close", false)
						else
							state_machine.excute("equip_choose_resolve_back", 0, 0)
						end
					end
				else
					state_machine.excute("menu_show_event", 0, "menu_show_event.")
					fwin:close(instance)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_resolve_page_check_conut_terminal = {
            _name = "equip_resolve_page_check_conut",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				if tempCell.status == false then
					if instance.selectCount >= instance.selectMaxCount then
						TipDlg.drawTextDailog(_string_piece_info[95])
					else
						ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(true)
						tempCell.status = true
						instance.selectCount = instance.selectCount + 1
					end
				else
					ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(false)
					tempCell.status = false
					instance.selectCount = instance.selectCount - 1
				end
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_xzzb_2"):setString(instance.selectCount)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(equip_choose_resolve_sort_terminal)
		state_machine.add(equip_choose_resolve_back_terminal)
		state_machine.add(equip_choose_resolve_close_terminal)
		state_machine.add(equip_resolve_page_check_conut_terminal)
        state_machine.init()
    end
    
    init_equip_choose_terminal()
end

function EquipChooseForResolve.loading(texture)
	local myListView = EquipChooseForResolve.myListView
	if myListView ~= nil then
		local cell = EquipChooseListCell:createCell()
		cell:init(EquipChooseForResolve.sortEquip[EquipChooseForResolve.asyncIndex], 1, EquipChooseForResolve.asyncIndex)
		myListView:addChild(cell)
		EquipChooseForResolve.asyncIndex = EquipChooseForResolve.asyncIndex + 1
		-- myListView:requestRefreshView()

		for i, ship in pairs(EquipChooseForResolve._self.equips) do
			if ship == cell.equipmentInstance then
				cell.status = true
				ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10"):setVisible(true)
			end
		end
	end
end

function EquipChooseForResolve:onUpdateDraw()
	state_machine.excute("equip_choose_resolve_sort", 0, "")
	self.sortEquip = state_machine.find("equip_choose_resolve_sort")._sortEquip
	local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	app.load("client.cells.equip.equip_choose_list_cell")
	-- for i,v in ipairs(self.sortEquip) do
	-- 	local cellList = EquipChooseListCell:createCell()
	-- 	cellList:init(v, 1)
	-- 	ListView_1:addChild(cellList)
	-- end
	-- local cells = ListView_1:getItems()
	-- for i, cell in pairs(cells) do
	-- 	for i, ship in pairs(self.equips) do
	-- 		if ship == cell.equipmentInstance then
	-- 			cell.status = true
	-- 			ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10"):setVisible(true)
	-- 		end
	-- 	end
	-- end

	EquipChooseForResolve._self = self
	EquipChooseForResolve.myListView = ListView_1
	EquipChooseForResolve.sortEquip = self.sortEquip
	EquipChooseForResolve.asyncIndex = 1
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
		for i,v in pairs(self.sortEquip) do
			local cell = EquipChooseListCell:createCell()
			cell:init(v, 1, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(ListView_1, EquipChooseListCell.__size)
				ListView_1:addChild(multipleCell)
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

			for i, ship in pairs(EquipChooseForResolve._self.equips) do
				if ship == cell.equipmentInstance then
					cell.status = true
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10"):setVisible(true)
				end
			end
		end
	else
		for i, v in ipairs(self.sortEquip) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			self.loading(nil)
		end
	end
	ListView_1:requestRefreshView()

	self.currentListView = ListView_1
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_xzzb_2"):setString(self.selectCount)
end

function EquipChooseForResolve:onUpdate(dt)
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

function EquipChooseForResolve:onEnterTransitionFinish()
	local csbEquipChoose = csb.createNode("packs/EquipStorage/equipment_sell.csb")
    local root = csbEquipChoose:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)

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
            state_machine.excute("equip_choose_resolve_back", 0, 0)
        end
    end)

    if action:IsAnimationInfoExists("window_open") == true then
    	action:play("window_open", false)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "equip_choose_resolve_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xzzb_qd"), nil, 
	{
		terminal_name = "equip_choose_resolve_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)
    
	self:onUpdateDraw()
	ccui.Helper:seekWidgetByName(root, "Panel_xzzb_sell"):setVisible(false)
end

function EquipChooseForResolve:onExit()
	EquipChooseForResolve.myListView = nil
	EquipChooseForResolve.asyncIndex = 1
	state_machine.remove("equip_choose_resolve_sort")
	state_machine.remove("equip_choose_resolve_back")
	state_machine.remove("equip_choose_resolve_close")
	state_machine.remove("equip_resolve_page_check_conut")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

function EquipChooseForResolve:init(equips)
	self.equips = equips
	self.selectCount = #equips
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
end
