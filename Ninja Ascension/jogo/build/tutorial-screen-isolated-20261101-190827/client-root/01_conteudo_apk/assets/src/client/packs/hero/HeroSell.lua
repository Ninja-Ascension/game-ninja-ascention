---------------------------------
---武将出售
---------------------------------

HeroSell = class("HeroSellClass", Window)
   
function HeroSell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.data = {}
	self.selNum = 0
	self.selMoney = 0
	self.sortShip = nil
	self.status = false
	self.istrue = false
	self.index = 0 --标记是否播放动画 如果是1 不播放
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	
    local function init_HeroSell_terminal()
    	local hero_sell_return_hero_storage_page_close_terminal = {
            _name = "hero_sell_return_hero_storage_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("hero_list_view_remove_cell_by_sell", 0, "hero_list_view_remove_cell_by_sell.")
				state_machine.excute("hero_show_hero_counts", 0, "hero_show_hero_counts.")
				fwin:close(instance)			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local hero_sell_return_hero_storage_page_terminal = {
            _name = "hero_sell_return_hero_storage_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
					local obj = fwin:find("HeroSellClass")
					if obj ~= nil then
						local action = obj.actions[1]
						if action ~= nil and action:IsAnimationInfoExists("window_close") == true then
							obj.actions[1]:play("window_close", false)
						else
							state_machine.excute("hero_sell_return_hero_storage_page_close", 0, 0)
						end
					end
				else
					state_machine.excute("hero_list_view_remove_cell_by_sell", 0, "hero_list_view_remove_cell_by_sell.")
					state_machine.excute("hero_show_hero_counts", 0, "hero_show_hero_counts.")
					fwin:close(instance)	
				end		
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_choose_quality_terminal = {
            _name = "hero_sell_choose_quality",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.istrue == false then
					TipDlg.drawTextDailog(_string_piece_info[112])
				else
					if instance.status == true then
						local cell = HeroSellChooseByQuality:new()
						--> print("koooooooooooooooooooooooooooooooooooooooooooooooooooooooo------------------------------------")
						cell:init(params._datas._sort)
						fwin:open(cell, fwin._dialog)
					else
						TipDlg.drawTextDailog(_string_piece_info[114])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_sure_sell_terminal = {
            _name = "hero_sell_sure_sell",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroSellTipTwo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.istrue == false then
					TipDlg.drawTextDailog(_string_piece_info[112])
				else
					local root = instance.roots[1]
					local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
					local items = listView:getItems()
					local num = 1
					instance.data = {}
					local status = false
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
						for i, v in pairs(items) do
							if v.child1 ~= nil then
								local cell = v.child1
								local heroInstance = cell.heroInstance
								
								if cell.status == true then
									instance.data[num] =  heroInstance
									num = num + 1
									if tonumber(heroInstance.ship_type) > 3 then
										status = true
									end
								end
							end
							if v.child2 ~= nil then
								local cell = v.child2
								local heroInstance = cell.heroInstance
								
								if cell.status == true then
									instance.data[num] =  heroInstance
									num = num + 1
									if tonumber(heroInstance.ship_type) > 3 then
										status = true
									end
								end
							end
						end
					else
						for i, v in pairs(items) do
							local cell = v
							local heroInstance = cell.heroInstance
							
							if cell.status == true then
								instance.data[num] =  heroInstance
								num = num + 1
								if tonumber(heroInstance.ship_type) > 3 then
									status = true
								end
							end
						end
					end
					if num == 1 then
						TipDlg.drawTextDailog(_string_piece_info[350])
						return
					end	
					if status == false then
						local heroSellTip = HeroSellTip:new()
						heroSellTip:init(instance.data)
						fwin:open(heroSellTip, fwin._dialog)
					else
						local heroSellTip = HeroSellTipTwo:new()
						heroSellTip:init(instance.data)
						fwin:open(heroSellTip, fwin._dialog)
					end
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_batch_sell_terminal = {
            _name = "hero_sell_batch_sell",
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
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
					for i, v in pairs(items) do
						if v.child1 ~= nil then
							state_machine.excute("hero_choose_list_page_choose_update", 0, {_datas = {cell = v.child1, quality = tempQuality, status = tempStatus}})
						end
						if v.child2 ~= nil then
							state_machine.excute("hero_choose_list_page_choose_update", 0, {_datas = {cell = v.child2, quality = tempQuality, status = tempStatus}})
						end
					end
				else
					for i, v in pairs(items) do
						state_machine.excute("hero_choose_list_page_choose_update", 0, {_datas = {cell = v, quality = tempQuality, status = tempStatus}})
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_update_cell_status_terminal = {
            _name = "hero_sell_update_cell_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params.cell
				local heroInstance = params.heroInstance
				if cell.status == true then
					instance.selNum = instance.selNum + 1
					instance.selMoney = instance.selMoney + dms.int(dms["ship_mould"], heroInstance.ship_template_id, ship_mould.sell_get_money)
				else 
					instance.selNum = instance.selNum - 1
					instance.selMoney = instance.selMoney - dms.int(dms["ship_mould"], heroInstance.ship_template_id, ship_mould.sell_get_money)
				end
				instance:updateSellInfo()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_sell_true_update_cell_status_terminal = {
            _name = "hero_sell_true_update_cell_status",
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
		
		local hero_sell_sort_terminal = {
            _name = "hero_sell_sort",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function fightingCapacity(a,b)
					local al = tonumber(a.hero_fight)
					local bl = tonumber(b.hero_fight)
					local result = false
					if al > bl then
						result = true
					end
					return result 
				end
			
				local tSortedHeroes = {}
				local arrStarLevelHeroesWhite = {}
				local arrStarLevelHeroesGreen = {}
				local arrStarLevelHeroesBlue = {}
				local arrStarLevelHeroesPurple = {}
				local arrStarLevelHeroesYellow = {}
				local arrStarLevelHeroesRed = {}
				for i, ship in pairs(_ED.user_ship) do
					local inRosouce = false
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						if ship.inResourceFromation == true then
							inRosouce = true
						end
					end
					local captain_type = dms.int(dms["ship_mould"],ship.ship_template_id,ship_mould.captain_type)
					if captain_type == 3 then 
						--宠物
						inRosouce = true
					end
					if ship.ship_id ~= nil and inRosouce == false then
						local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
						if dms.atoi(shipData, ship_mould.captain_type) == 0 then
							
						elseif zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
							
						else
							if dms.atoi(shipData, ship_mould.ship_type) == 0 then
								table.insert(arrStarLevelHeroesWhite, ship)
								instance.status = true
							elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
								table.insert(arrStarLevelHeroesGreen, ship)
								instance.status = true
							elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
								table.insert(arrStarLevelHeroesBlue, ship)
								instance.status = true
							elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
								table.insert(arrStarLevelHeroesPurple, ship)
								instance.status = true
							elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
								table.insert(arrStarLevelHeroesYellow, ship)
								instance.status = true
							elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
								table.insert(arrStarLevelHeroesRed, ship)
								instance.status = true
							end 
						end
					end
				end
				table.sort(arrStarLevelHeroesWhite, fightingCapacity)
				table.sort(arrStarLevelHeroesGreen, fightingCapacity)
				table.sort(arrStarLevelHeroesBlue, fightingCapacity)
				table.sort(arrStarLevelHeroesPurple, fightingCapacity)
				table.sort(arrStarLevelHeroesYellow, fightingCapacity)
				table.sort(arrStarLevelHeroesRed, fightingCapacity)
				
				for i=1, #arrStarLevelHeroesWhite do
					table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
				end
				for i=1, #arrStarLevelHeroesGreen do
					table.insert(tSortedHeroes, arrStarLevelHeroesGreen[i])
				end
				for i=1, #arrStarLevelHeroesBlue do
					table.insert(tSortedHeroes, arrStarLevelHeroesBlue[i])
				end
				for i=1, #arrStarLevelHeroesPurple do
					table.insert(tSortedHeroes, arrStarLevelHeroesPurple[i])
				end
				for i=1, #arrStarLevelHeroesYellow do
					table.insert(tSortedHeroes, arrStarLevelHeroesYellow[i])
				end
				for i=1, #arrStarLevelHeroesRed do
					table.insert(tSortedHeroes, arrStarLevelHeroesRed[i])
				end
				instance.sortShip = tSortedHeroes
				if instance.status == false then
					TipDlg.drawTextDailog(_string_piece_info[112])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_sell_return_hero_storage_page_close_terminal)
		state_machine.add(hero_sell_return_hero_storage_page_terminal)
		state_machine.add(hero_sell_choose_quality_terminal)
		state_machine.add(hero_sell_sure_sell_terminal)
		state_machine.add(hero_sell_batch_sell_terminal)
		state_machine.add(hero_sell_update_cell_status_terminal)
		state_machine.add(hero_sell_true_update_cell_status_terminal)
		state_machine.add(hero_sell_sort_terminal)

        state_machine.init()
    end
    
    init_HeroSell_terminal()
end

function HeroSell:cleanListView()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local items = listView:getItems()
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
		
	self.selNum = 0
	self.selMoney = 0
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
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--print("------------------")
		state_machine.excute("hero_sell_return_hero_storage_page_close",0,"")
		local _herosell = HeroSell:new()
		_herosell:init(1)
		fwin:open(_herosell, fwin._window)
	end
end

function HeroSell:init(index)
	self.index = index
end
function HeroSell:updateSellInfo()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_wjshul"):setString(""..self.selNum)
	ccui.Helper:seekWidgetByName(root, "Text_wjjiag"):setString(""..self.selMoney)
end

-- function HeroSell.loading(texture)
	-- if HeroSell.asyncIndex ~= nil and HeroSell.asyncIndex > #HeroSell.sortShip then
		-- return
	-- end	

	-- local myListView = HeroSell.myListView
	-- if myListView ~= nil then
		-- local cell = HeroChooseListCell:createCell()
		-- cell:init(HeroSell.sortShip[HeroSell.asyncIndex])
		-- myListView:addChild(cell)
		-- HeroSell.asyncIndex = HeroSell.asyncIndex + 1
		-- myListView:requestRefreshView()
	-- end
-- end

function HeroSell:onUpdateDraw()
	local root = self.roots[1]
	
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(self.sortShip) do
			local cell = HeroChooseListCell:createCell()
			cell:init(v, nil, nil, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(listView, HeroChooseListCell.__size)
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
		for i,v in ipairs(self.sortShip) do
			local cell = HeroChooseListCell:createCell()
			cell:init(v, nil, nil, i)
			self.istrue = true
			listView:addChild(cell)
		end
	end

	listView:requestRefreshView()

	self.currentListView = listView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

	-- HeroSell.myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	-- HeroSell.sortShip = self.sortShip
	-- HeroSell.asyncIndex = 1
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- for i, v in ipairs(self.sortShip) do
		-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
		-- self.istrue = true
	-- end
end

function HeroSell:onUpdate(dt)
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

function HeroSell:onEnterTransitionFinish()
    local csbHeroSell = csb.createNode("packs/HeroStorage/generals_sell.csb")
    self:addChild(csbHeroSell)
	
	local root = csbHeroSell:getChildByName("root")
	table.insert(self.roots, root)

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
            state_machine.excute("hero_sell_return_hero_storage_page_close", 0, 0)
        end
    end)
    if action:IsAnimationInfoExists("window_open") == true then
		--print("self.index",self.index)
    	if self.index ~= 1 then
			action:play("window_open", false)
		end
	end
	
	ccui.Helper:seekWidgetByName(root, "Panel_xzwj_choose"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_xzwj_sell"):setVisible(true)
	state_machine.excute("hero_sell_sort", 0, "click hero_sell_sort.'")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, {func_string = [[state_machine.excute("hero_sell_return_hero_storage_page", 0, "click generals_sell_return_generals_page.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {func_string = [[state_machine.excute("hero_sell_sure_sell", 0, "click hero_sell_sure_sell.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	
	
	self:onUpdateDraw()
	self:updateSellInfo()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "hero_sell_choose_quality", terminal_state = 0, _sort = self.sortShip,isPressedActionEnabled = true
		-- func_string = [[state_machine.excute("hero_sell_choose_quality", 0, "click hero_sell_choose_quality.'")]]
	}, 
	nil, 0)
end


function HeroSell:onExit()
	HeroSell.myListView = nil
	HeroSell.asyncIndex = 1
	state_machine.remove("hero_sell_return_hero_storage_page_close")
	state_machine.remove("hero_sell_return_hero_storage_page")
	state_machine.remove("hero_sell_choose_quality")
	state_machine.remove("hero_sell_sure_sell")
	state_machine.remove("hero_sell_batch_sell")
	state_machine.remove("hero_sell_update_cell_status")
	state_machine.remove("hero_sell_true_update_cell_status")
	state_machine.remove("hero_sell_sort")
end