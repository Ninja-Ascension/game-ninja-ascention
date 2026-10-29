-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的选择武将升级界面
-------------------------------------------------------------------------------------------------------
ChooseHeroToStreng = class("ChooseHeroToStrengClass", Window)

function ChooseHeroToStreng:ctor()
    self.super:ctor()
	self.roots = {}
	self.sortShip = {}
	self.selectMaxCount = 5
	self.selectCount = 0
	self.strenShipId = nil

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	
	app.load("client.utils.ConfirmTip")
	
    local function init_choose_hero_to_streng_page_terminal()
		local hero_exp_sort_terminal = {
            _name = "hero_exp_sort",
            _init = function (terminal) 
                terminal._sortShip = {}
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
				local arrStarLevelHeroesExpHeros = {}
				for i, ship in pairs(_ED.user_ship) do
					local inRosouce = false
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						if ship.inResourceFromation == true then
							inRosouce = true
						end
					end
					local captain_type = dms.int(dms["ship_mould"],ship.ship_template_id,ship_mould.captain_type)
					if captain_type == 3 then 
						--宠物
						inRosouce = true
					end
			
					if ship.ship_id ~= nil and self.strenShipId ~= ship.ship_id and inRosouce == false then
						local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
						if dms.atoi(shipData, ship_mould.captain_type) == 0 then
							
						elseif zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
							
						else
							if tonumber(dms.atoi(shipData, ship_mould.captain_type)) == 2 then
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									table.insert(arrStarLevelHeroesExpHeros,ship)
								elseif __lua_project_id == __lua_project_warship_girl_b 
									or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
									or __lua_project_id == __lua_project_rouge 
									or __lua_project_id == __lua_project_yugioh 
									then
									if dms.atoi(shipData, ship_mould.ship_type) == 0 then
										table.insert(arrStarLevelHeroesWhite, ship)
									elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
										table.insert(arrStarLevelHeroesGreen, ship)
									elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
										table.insert(arrStarLevelHeroesYellow, ship)
									elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
										table.insert(arrStarLevelHeroesPurple, ship)
									elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
										table.insert(arrStarLevelHeroesBlue, ship)		
									end
								end
							elseif dms.atoi(shipData, ship_mould.ship_type) == 0 then
								table.insert(arrStarLevelHeroesWhite, ship)
							elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
								table.insert(arrStarLevelHeroesGreen, ship)
							elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
							--elseif tonumber(ship.ship_template_id) ==1148 then
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									table.insert(arrStarLevelHeroesBlue, ship)
								else
									table.insert(arrStarLevelHeroesYellow, ship)
								end
							elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
							--elseif tonumber(ship.ship_template_id) ==1149 then
								table.insert(arrStarLevelHeroesPurple, ship)
							elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
							--elseif tonumber(ship.ship_template_id) == 1150 then
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									table.insert(arrStarLevelHeroesYellow, ship)
								else
									table.insert(arrStarLevelHeroesBlue, ship)
								end
							end 
						end
					end
				end
				table.sort(arrStarLevelHeroesExpHeros,fightingCapacity)
				table.sort(arrStarLevelHeroesWhite, fightingCapacity)
				table.sort(arrStarLevelHeroesGreen, fightingCapacity)
				table.sort(arrStarLevelHeroesBlue, fightingCapacity)
				table.sort(arrStarLevelHeroesPurple, fightingCapacity)
				table.sort(arrStarLevelHeroesYellow, fightingCapacity)
				for i=1, #arrStarLevelHeroesExpHeros do
					-- print("-------",arrStarLevelHeroesExpHeros[i].captain_name)
					table.insert(tSortedHeroes, arrStarLevelHeroesExpHeros[i])
				end
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
				terminal._sortShip = tSortedHeroes
				return true
            end,
            _terminal = nil,
            _terminals = nil,
			_sortShip = {}
        }
		
		-- 关闭
		local choose_hero_to_streng_page_close_terminal = {
            _name = "choose_hero_to_streng_page_close",
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
				state_machine.excute("hero_strengthen_page_update_info", 0, {_datas = {needShipInfo = ships}})
				
				state_machine.excute("choose_hero_to_streng_page_cancel", 0, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		
		local choose_hero_to_streng_page_cancel_terminal = {
            _name = "choose_hero_to_streng_page_cancel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				fwin:close(instance)
				local TOPInfoWidget = fwin:find("UserInformationHeroStorageClass") 
				if TOPInfoWidget ~= nil then
					TOPInfoWidget:setVisible(true)
				end	
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_strengthen_page_check_full_terminal = {
            _name = "hero_strengthen_page_check_full",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				local win = fwin:find("ChooseHeroToStrengClass")
				
				if nil == win or nil == params or nil == params._datas or nil == params._datas.cell then
					return
				end

				local getExp = instance.getExp
				local gradeNeedExprience = instance.gradeNeedExprience
				local cellExp = getOfferOfExp(params._datas.cell.heroInstance.ship_id)
				
				local captainGrade = tonumber(_ED.user_info.user_grade)	--主角等级
				local AllExp = 0			--可获总经验
				local NeedExp = zstring.tonumber(_ED.user_ship[instance.strenShipId].grade_need_exprience) --需要多少经验
				local ship_grade = tonumber(_ED.user_ship[instance.strenShipId].ship_grade)				  --战船当前等级
				
				local mid = fundShipWidthId(instance.strenShipId).ship_template_id
				local expType = 1
				
				local qtype = dms.int(dms["ship_mould"], mid, ship_mould.ship_type)
				expType = qtype + 4
				
				-- 获取当前品质武将升级到
				for i = ship_grade+1, captainGrade do
					AllExp = AllExp + dms.int(dms["ship_experience_param"], i, expType)
				end
				AllExp = AllExp + gradeNeedExprience
				
				if missionIsOver() == true and params._datas.cell.status == false and tonumber(getExp) + tonumber(cellExp) > tonumber(AllExp)  then

					if instance.selectCount >= instance.selectMaxCount then
						TipDlg.drawTextDailog(_string_piece_info[53])
					else
						-- 取消选中
						params._datas.cell:setSelected(false)

						instance:tipFullExp(params._datas.cell)
					end
				
					
				else
					state_machine.excute("hero_strengthen_page_check_conut", 0, {_datas = {cell = params._datas.cell}})
				end
	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_strengthen_page_check_conut_terminal = {
            _name = "hero_strengthen_page_check_conut",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				local cellExp = getOfferOfExp(tempCell.heroInstance.ship_id)
				if tempCell.status == false then
					if instance.selectCount >= instance.selectMaxCount then
						TipDlg.drawTextDailog(_string_piece_info[53])
					else
						ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(true)
						tempCell.status = true
						instance.selectCount = instance.selectCount + 1
						instance.getExp = instance.getExp + cellExp
					end
				else
					ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(false)
					tempCell.status = false
					instance.selectCount = instance.selectCount - 1
					instance.getExp = instance.getExp - cellExp
				end
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_exp_v"):setString(instance.getExp)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_sucsi_v"):setString(instance.gradeNeedExprience)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(choose_hero_to_streng_page_cancel_terminal)
		state_machine.add(hero_strengthen_page_check_full_terminal)
		state_machine.add(hero_exp_sort_terminal)
		state_machine.add(choose_hero_to_streng_page_close_terminal)
		state_machine.add(hero_strengthen_page_check_conut_terminal)
        state_machine.init()
    end
    init_choose_hero_to_streng_page_terminal()
end

function ChooseHeroToStreng.loading(texture)
	local myListView = ChooseHeroToStreng.myListView
	if myListView ~= nil then
		local cell = HeroChooseListCell:createCell()
		cell:init(ChooseHeroToStreng.sortShip[ChooseHeroToStreng.asyncIndex], 1, ChooseHeroToStreng.asyncIndex, ChooseHeroToStreng.asyncIndex)
		myListView:addChild(cell)
		ChooseHeroToStreng.asyncIndex = ChooseHeroToStreng.asyncIndex + 1
		-- myListView:requestRefreshView()

		for i, ship in pairs(ChooseHeroToStreng._self.ships) do
			if ship == cell.heroInstance then
				cell.status = true
				if ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10") ~= nil then
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10"):setVisible(true)
				end	
			end
		end
	end
end


function ChooseHeroToStreng:updateExp(tempCell)
	local cellExp = getOfferOfExp(tempCell.heroInstance.ship_id)
	if tempCell.status == true then
		if self.selectCount >= self.selectMaxCount then
			TipDlg.drawTextDailog(_string_piece_info[53])
		else
			
			self.selectCount = self.selectCount + 1
			self.getExp = self.getExp + cellExp
		end
	else
		
		self.selectCount = self.selectCount - 1
		self.getExp = self.getExp - cellExp
	end
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_exp_v"):setString(self.getExp)
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_sucsi_v"):setString(self.gradeNeedExprience)
end

function ChooseHeroToStreng:showConfirmTip(n)
	if n == 0 then
		-- yes
		self.indexCell:setSelected(true)
		self:updateExp(self.indexCell)
	else
		-- no
	end
end

function ChooseHeroToStreng:tipFullExp(cell)
	self.indexCell = cell
	
	local tip = ConfirmTip:new()
	tip:init(self, self.showConfirmTip, _string_piece_info[369])
	fwin:open(tip,fwin._ui)
end

function ChooseHeroToStreng:onUpdateDraw()
	state_machine.excute("hero_exp_sort", 0, "")
	self.sortShip = state_machine.find("hero_exp_sort")._sortShip
	local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	app.load("client.cells.ship.hero_choose_list_cell")
	-- for i,v in ipairs(self.sortShip) do
	-- 	local cellList = HeroChooseListCell:createCell()
	-- 	cellList:init(v, 1,i)
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
	ListView_1:removeAllItems()
	ChooseHeroToStreng._self = self
	ChooseHeroToStreng.myListView = ListView_1
	ChooseHeroToStreng.sortShip = self.sortShip
	ChooseHeroToStreng.asyncIndex = 1
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
		for i,v in pairs(self.sortShip) do
			local cell = HeroChooseListCell:createCell()
			cell:init(v, 1, i, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
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
			for i, ship in pairs(ChooseHeroToStreng._self.ships) do
				if ship == cell.heroInstance then
					cell.status = true
					if ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10") ~= nil then
						ccui.Helper:seekWidgetByName(cell.roots[1], "Image_10"):setVisible(true)
					end	
				end
			end
		end
	else
		for i, v in ipairs(self.sortShip) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			self.loading(nil)
		end
	end

	ListView_1:requestRefreshView()

	self.currentListView = ListView_1
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_exp_v"):setString(self.getExp)
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_sucsi_v"):setString(self.gradeNeedExprience)
end

function ChooseHeroToStreng:onUpdate(dt)
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

function ChooseHeroToStreng:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/choose_material.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(true)
	table.insert(self.roots, root)
    self:addChild(root)
    
	local TOPInfoWidget = fwin:find("UserInformationHeroStorageClass") 
	if TOPInfoWidget ~= nil then
		TOPInfoWidget:setVisible(false)
	end	
	
	self:onUpdateDraw()
	
	local view_panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(view_panel, "Button_1"), nil, 
	{
		terminal_name = "choose_hero_to_streng_page_cancel", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(view_panel, "Button_4"), nil, 
	{
		terminal_name = "choose_hero_to_streng_page_close", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	},
	nil, 0)
end

function ChooseHeroToStreng:onExit()
	ChooseHeroToStreng.myListView = nil
	ChooseHeroToStreng.asyncIndex = 1
	state_machine.remove("hero_exp_sort")
	state_machine.remove("choose_hero_to_streng_page_close")
	state_machine.remove("hero_strengthen_page_check_conut")
	state_machine.remove("choose_hero_to_streng_page_cancel")
	
end

function ChooseHeroToStreng:init(ships, strenShipId)
	self.ships = ships
	for i,v in pairs(ships) do
		if v ~= nil then
			self.selectCount = self.selectCount + 1
		end
	end
	self.strenShipId = strenShipId
	self.gradeNeedExprience = _ED.user_ship[strenShipId].grade_need_exprience
	self.getExp = 0
	for i,v in pairs(self.ships) do
		self.getExp = self.getExp + getOfferOfExp(v.ship_id)
	end
end