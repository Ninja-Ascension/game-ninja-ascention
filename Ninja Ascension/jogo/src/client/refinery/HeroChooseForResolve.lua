-- ----------------------------------------------------------------------------------------------------
-- 说明：回收界面武将分解界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroChooseForResolve = class("HeroChooseForResolveClass", Window)

function HeroChooseForResolve:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self.sortShip = {}
	self.selectMaxCount = 5
	self.selectCount = 0

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

    -- Initialize HeroChooseForResolve page state machine.
    local function init_hero_choose_terminal()
       local hero_choose_resolve_sort_terminal = {
            _name = "hero_choose_resolve_sort",
            _init = function (terminal) 
                terminal._sortShip = {}
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function chooseHero()
					local list = {}
					local j = 1
					for i, v in pairs(_ED.user_ship) do
						local inRosouce = false
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							if v.inResourceFromation == true then
								inRosouce = true
							end
						end
						local captain_type = dms.int(dms["ship_mould"],v.ship_template_id,ship_mould.captain_type)
						if captain_type == 3 then 
							--宠物
							inRosouce = true
						end
						if inRosouce == false then
							local shipId = v.ship_id
							local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
							local shipQuality = dms.atoi(shipData, ship_mould.ship_type)
							if tonumber(v.ship_base_template_id) < 1148 or tonumber(v.ship_base_template_id) > 1150 then
								if shipQuality >= 1 and (zstring.tonumber(v.formation_index) == 0)
								  and (zstring.tonumber(v.little_partner_formation_index) == 0) then
									list[j] = v
									j = j+1
								end
							end
						end
					end
					return list
				end
				
				local function compare(a, b)
					local a_quality = dms.int(dms["ship_mould"], a.ship_template_id, ship_mould.ship_type)
					local b_quality = dms.int(dms["ship_mould"], b.ship_template_id, ship_mould.ship_type)
					if a_quality > b_quality then
						return false
					elseif a_quality == b_quality then
						if tonumber(a.ship_grade) > tonumber(b.ship_grade) then
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
				
				terminal._sortShip = sortList(chooseHero())
				return true
            end,
            _terminal = nil,
            _terminals = nil,
			_sortShip = {}
        }
		
		-- 关闭
		local hero_choose_resolve_page_close_terminal = {
            _name = "hero_choose_resolve_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ships = {}
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
							table.insert(ships, cell.child1.heroInstance)
						end
						if cell.child2 ~= nil and cell.child2.status == true then
							table.insert(ships, cell.child2.heroInstance)
						end
					end
				else
					for i, cell in pairs(cells) do
						if cell.status == true then
							table.insert(ships, cell.heroInstance)
						end
					end
				end
				state_machine.excute("hero_resolve_update_info", 0, {_datas = {needShipInfo = ships}})
				-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then			--龙虎门项目控制
				-- 	fwin:close(instance)
				-- elseif __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				-- 	state_machine.excute("hero_choose_resolve_page_cancel", 0, "hero_choose_resolve_page_cancel.")
				-- else
				-- 	fwin:close(instance)
				-- end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 关闭
		local hero_choose_resolve_close_terminal = {
            _name = "hero_choose_resolve_close",
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
					local obj = fwin:find("HeroChooseForResolveClass")
					if obj ~= nil then
						local action = obj.actions[1]
						if action ~= nil and action:IsAnimationInfoExists("window_close") == true then
							obj.actions[1]:play("window_close", false)
						else
							state_machine.excute("hero_choose_resolve_page_close", 0, 0)
						end
					end
				else
					state_machine.excute("hero_choose_resolve_page_close", 0, 0)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_resolve_page_check_conut_terminal = {
            _name = "hero_resolve_page_check_conut",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				if tempCell.status == false then
					if instance.selectCount >= instance.selectMaxCount then
						TipDlg.drawTextDailog(_string_piece_info[53])
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
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_xzwj_2"):setString(instance.selectCount)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_choose_resolve_sort_terminal)
		state_machine.add(hero_choose_resolve_page_close_terminal)
		state_machine.add(hero_choose_resolve_close_terminal)
		state_machine.add(hero_resolve_page_check_conut_terminal)
        state_machine.init()
    end
    
    init_hero_choose_terminal()
end

function HeroChooseForResolve.loading(texture)
	local myListView = HeroChooseForResolve.myListView
	if myListView ~= nil then
		local cell = HeroChooseListCell:createCell()
		cell:init(HeroChooseForResolve.sortShip[HeroChooseForResolve.asyncIndex], 2, nil, HeroChooseForResolve.asyncIndex)
		myListView:addChild(cell)
		HeroChooseForResolve.asyncIndex = HeroChooseForResolve.asyncIndex + 1
		-- myListView:requestRefreshView()

		for i, ship in pairs(HeroChooseForResolve._self.ships) do
			if ship == cell.heroInstance then
				cell.status = true
				local choose_image = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10")
				if choose_image ~= nil and choose_image.setVisible ~= nil then
					choose_image:setVisible(true)
				end	
			end
		end
	end
end

function HeroChooseForResolve:onUpdateDraw()
	state_machine.excute("hero_choose_resolve_sort", 0, "")
	self.sortShip = state_machine.find("hero_choose_resolve_sort")._sortShip
	local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	app.load("client.cells.ship.hero_choose_list_cell")
	-- for i,v in ipairs(self.sortShip) do
	-- 	local cellList = HeroChooseListCell:createCell()
	-- 	cellList:init(v, 2)
	-- 	ListView_1:addChild(cellList)
	-- end
	-- local cells = ListView_1:getItems()
	-- for i, cell in pairs(cells) do
	-- 	for i, ship in pairs(self.ships) do
	-- 		if ship == cell.heroInstance then
	-- 			cell.status = true
	-- 			ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10"):setVisible(true)
	-- 		end
	-- 	end
	-- end

	HeroChooseForResolve._self = self
	HeroChooseForResolve.myListView = ListView_1
	HeroChooseForResolve.sortShip = self.sortShip
	HeroChooseForResolve.asyncIndex = 1
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		local number = 1
		for i,v in pairs(self.sortShip) do
			--print("------------------------",i,v.captain_type)
			if tonumber(v.captain_type) == 2 then
			else			
			local cell = HeroChooseListCell:createCell()
				cell:init(v, 2, nil, number)
				number = number + 1
				if multipleCell == nil then
					multipleCell = MultipleListViewCell:createCell()
					--print("HeroChooseListCell.__size",HeroChooseListCell.__size)
					multipleCell:init(ListView_1, HeroChooseListCell.__size)	
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
				for i, ship in pairs(HeroChooseForResolve._self.ships) do
					if ship == cell.heroInstance then
						cell.status = true
						local choose_image = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10")
						if choose_image ~= nil and choose_image.setVisible ~= nil then
							choose_image:setVisible(true)
						end	
					end
				end
			end
		end
	else
		-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		for i, v in ipairs(self.sortShip) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			self.loading(nil)
		end
	end

	ListView_1:requestRefreshView()

	self.currentListView = ListView_1
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_xzwj_2"):setString(self.selectCount)
	--> print("!!!!!!!!!!!!!", #self.sortShip)
end

function HeroChooseForResolve:onUpdate(dt)
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


function HeroChooseForResolve:onEnterTransitionFinish()
	local csbHeroChoose = csb.createNode("packs/HeroStorage/generals_sell.csb")
    local root = csbHeroChoose:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then	
		local action = csb.createTimeline("packs/HeroStorage/generals_sell.csb")
		table.insert(self.actions, action)
		root:runAction(action)
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end

			local str = frame:getEvent()
			if str == "window_open_over" then

			elseif str == "window_close_over" then
				state_machine.excute("hero_choose_resolve_page_close", 0, 0)
			end
		end)

		if action:IsAnimationInfoExists("window_open") == true then
			action:play("window_open", false)
		end
	end
	
	self:onUpdateDraw()
	ccui.Helper:seekWidgetByName(root, "Panel_xzwj_choose"):setVisible(true)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "hero_choose_resolve_close", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xzwj_qd"), nil, 
	{
		terminal_name = "hero_choose_resolve_close", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	},
	nil, 2)
end

function HeroChooseForResolve:onExit()
	state_machine.excute("menu_show_event", 0, "menu_show_event.")
	HeroChooseForResolve.myListView = nil
	HeroChooseForResolve.asyncIndex = 1
	state_machine.remove("hero_choose_resolve_sort")
	state_machine.remove("hero_choose_resolve_page_close")
	state_machine.remove("hero_choose_resolve_close")
	state_machine.remove("hero_resolve_page_check_conut")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

function HeroChooseForResolve:init(ships)
	self.ships = ships
	self.selectCount = #ships
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
end
