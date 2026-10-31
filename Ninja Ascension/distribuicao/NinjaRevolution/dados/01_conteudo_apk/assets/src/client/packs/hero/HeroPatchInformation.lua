-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面
-------------------------------------------------------------------------------------------------------
HeroPatchInformation = class("HeroPatchInformationClass", Window)

HeroPatchInformation.__size = cc.size(640, 582)
function HeroPatchInformation:ctor()
	
	closeLastWindow("HeroPatchInformationClass")
	
    self.super:ctor()
	self.roots = {}
	self.tabCtrlList = {}
	self.types = nil
	self.classType = 0
	self.sell = nil
	self.from_type = nil
	self._is_pet = false -- 是否是宠物
	app.load("client.packs.hero.HeroPatchInformationPageOne")
	app.load("client.packs.hero.HeroPatchInformationPageTwo")
	app.load("client.packs.hero.HeroPatchInformationPageTwoChild")
	app.load("client.packs.hero.HeroPatchInformationPageThree")
	app.load("client.packs.hero.HeroPatchInformationPageFour")
	app.load("client.packs.hero.HeroPatchInformationPageFourChild")
    local function init_hero_patch_information_terminal()
		
		local hero_patch_information_close_terminal = {
            _name = "hero_patch_information_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--左侧的按钮响应,上翻页
		
		local pageview_to_up_terminal = {
            _name = "pageview_to_up",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:ChangePageView("up")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --右侧的按钮响应,下翻页
        local pageview_to_down_terminal = {
            _name = "pageview_to_down",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:ChangePageView("down")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(hero_patch_information_close_terminal)
		state_machine.add(pageview_to_up_terminal)
		state_machine.add(pageview_to_down_terminal)
        state_machine.init()
    end
    init_hero_patch_information_terminal()
end
function HeroPatchInformation:ChangePageView(whereButton)
	--上下按钮的响应
	local  _PageView = ccui.Helper:seekWidgetByName(self.roots[1],"PageView_1")
	local  _items = _PageView:getPages()
	local  _pagenumber = #_items

	local  pageindex = _PageView:getCurPageIndex()
	if whereButton == "up" then
		if pageindex ~= 0 then
			_PageView:scrollToPage(pageindex-1)
		end
	elseif whereButton == "down" then
		if pageindex ~= _pagenumber-1  then --ps:pageindex从0开始索引的
			_PageView:scrollToPage(pageindex+1)
		end
	end

	local  pageIndexAfterMove = _PageView:getCurPageIndex()
	
	local upbtn = ccui.Helper:seekWidgetByName(self.roots[1],"Button_7")
	local downbtn = ccui.Helper:seekWidgetByName(self.roots[1],"Button_8")
	if pageIndexAfterMove == 0 then
		upbtn:setVisible(false)
	else
		upbtn:setVisible(true)
	end

	if whereButton ~= "init" then
		if pageIndexAfterMove == _pagenumber-1  then --ps:pageindex从0开始索引的
			downbtn:setVisible(false)
		else
			downbtn:setVisible(true)
		end
	end
end
function HeroPatchInformation:onUpdateDraw()
	local root = self.roots[1]
	
	local lightTwo = ccui.Helper:seekWidgetByName(root, "Image_tab_wj_3_1")
	local darkTwo = ccui.Helper:seekWidgetByName(root, "Image_tab_wj_1_1")
	
	local lightOne = ccui.Helper:seekWidgetByName(root, "Image_tab_wj_3_0")
	local darkOne = ccui.Helper:seekWidgetByName(root, "Image_tab_wj_1_0")
	
	local lightThree = ccui.Helper:seekWidgetByName(root, "Image_tab_wj_3_2")
	local darkThree = ccui.Helper:seekWidgetByName(root, "Image_tab_wj_1_2")
	
	local lightFour = ccui.Helper:seekWidgetByName(root, "Image_tab_wj_3_3")
	local darkFour = ccui.Helper:seekWidgetByName(root, "Image_tab_wj_1_3")
	
	local PageView_1 = ccui.Helper:seekWidgetByName(root, "PageView_1")
	
	local cellList = {}
	
	if self.classType ==1 then
		--神将商店头像点击跳过来
		local prop = dms.searchs(dms["prop_mould"], prop_mould.use_of_ship, self.shipId.goods_id)
		local id = nil
		if prop ~= nil then
			for i, v in pairs(prop) do
				if tonumber(v[9]) == 1 then
					id = v[1]
				end
			end
		end
		
		if id ~= nil then
			local cell_one = HeroPatchInformationPageOne:createCell()
			cell_one:init(id)
			PageView_1:addPage(cell_one)
			table.insert(self.tabCtrlList, lightOne)
			table.insert(cellList, cell_one)
		else
			darkOne:setVisible(true)
		end	
		
		if self.shipId ~= nil then
			local cell_two = HeroPatchInformationPageTwo:createCell()
			cell_two:init(self.shipId,self.classType)
			PageView_1:addPage(cell_two)
			table.insert(self.tabCtrlList, lightTwo)
			table.insert(cellList, cell_two)
		else
			darkTwo:setVisible(true)
		end
		local zoariumSkill = dms.int(dms["ship_mould"], self.shipId.goods_id, ship_mould.zoarium_skill)
		if zoariumSkill ~= nil and zoariumSkill > 0 then
			local cell_three = HeroPatchInformationPageThree:createCell()
			cell_three:init(self.shipId.goods_id,2)
			PageView_1:addPage(cell_three)
			table.insert(self.tabCtrlList, lightThree)
			table.insert(cellList, cell_three)
		else
			darkThree:setVisible(true)
		end
		
		local fate_relationship = dms.string(dms["ship_mould"], self.shipId.goods_id, ship_mould.relationship_id)
		if fate_relationship ~= nil and fate_relationship ~= "" then
			
			local cell_four = HeroPatchInformationPageFour:createCell()
			cell_four:init(self.shipId.goods_id,2)
			PageView_1:addPage(cell_four)
			table.insert(self.tabCtrlList, lightFour)
			table.insert(cellList, cell_four)
		else
			darkFour:setVisible(true)
		end
		
	elseif self.sell == 2 then
		local prop = dms.searchs(dms["prop_mould"], prop_mould.use_of_ship, self.shipId)
		local id = nil
		if prop ~= nil then
			for i, v in pairs(prop) do
				if tonumber(v[9]) == 1 then
					id = v[1]
				end
			end
		end
		if id ~= nil then
			local cell_one = HeroPatchInformationPageOne:createCell()
			cell_one:init(id)
			PageView_1:addPage(cell_one)
			table.insert(self.tabCtrlList, lightOne)
			table.insert(cellList, cell_one)
		else
			darkOne:setVisible(true)
		end	
		
		if self.shipId ~= nil then
			local cell_two = HeroPatchInformationPageTwo:createCell()
			cell_two:init(self.shipId,2,self.from_type,self.ship_duixiang)
			PageView_1:addPage(cell_two)
			table.insert(self.tabCtrlList, lightTwo)
			table.insert(cellList, cell_two)
			lightTwo:setVisible(true)
		else
			darkTwo:setVisible(true)
		end
		

		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then
			local function addPages()
				local zoariumSkill = dms.int(dms["ship_mould"], self.shipId, ship_mould.zoarium_skill)
				if zoariumSkill ~= nil and zoariumSkill > 0 then
					local cell_three = HeroPatchInformationPageThree:createCell()
					cell_three:init(self.shipId,2)
					PageView_1:addPage(cell_three)
					table.insert(self.tabCtrlList, lightThree)
					table.insert(cellList, cell_three)
				else
					darkThree:setVisible(true)
				end
				
				local fate_relationship = dms.string(dms["ship_mould"], self.shipId, ship_mould.relationship_id)
				if fate_relationship ~= nil and fate_relationship ~= "" then
					
					local cell_four = HeroPatchInformationPageFour:createCell()
					cell_four:init(self.shipId,2)
					PageView_1:addPage(cell_four)
					table.insert(self.tabCtrlList, lightFour)
					table.insert(cellList, cell_four)
				else
					darkFour:setVisible(true)
				end
			end

			cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,addPages,self)  
		else
			local zoariumSkill = dms.int(dms["ship_mould"], self.shipId, ship_mould.zoarium_skill)
			if zoariumSkill ~= nil and zoariumSkill > 0 then
				local cell_three = HeroPatchInformationPageThree:createCell()
				cell_three:init(self.shipId,2)
				PageView_1:addPage(cell_three)
				table.insert(self.tabCtrlList, lightThree)
				table.insert(cellList, cell_three)
			else
				darkThree:setVisible(true)
			end
			
			local fate_relationship = dms.string(dms["ship_mould"], self.shipId, ship_mould.relationship_id)
			if fate_relationship ~= nil and fate_relationship ~= "" then
				
				local cell_four = HeroPatchInformationPageFour:createCell()
				cell_four:init(self.shipId,2)
				PageView_1:addPage(cell_four)
				table.insert(self.tabCtrlList, lightFour)
				table.insert(cellList, cell_four)
			else
				darkFour:setVisible(true)
			end
		end
	
	elseif self.types == 3 then -- 阵容缘分
		local fate_relationship = dms.string(dms["ship_mould"], self.shipId.ship_template_id, ship_mould.relationship_id)
		if fate_relationship ~= nil and fate_relationship ~= "" then
			local cell_four = HeroPatchInformationPageFour:createCell()
			cell_four:init(self.shipId.ship_template_id,3)
			PageView_1:addPage(cell_four)
			table.insert(self.tabCtrlList, lightFour)
			table.insert(cellList, cell_four)
		else
			darkFour:setVisible(true)
		end
	else
		local dataId = dms.int(dms["prop_mould"], self.shipId.user_prop_template, prop_mould.use_of_ship)
		local captain_type = dms.int(dms["ship_mould"], dataId, ship_mould.captain_type)
		if captain_type == 3 then 
			
			self._is_pet = true
		end
		if self.shipId ~= nil then
			local cell_one = HeroPatchInformationPageOne:createCell()
			cell_one:init(self.shipId.user_prop_template)
			PageView_1:addPage(cell_one)
			table.insert(self.tabCtrlList, lightOne)
			table.insert(cellList, cell_one)
		else
			darkOne:setVisible(true)
		end	
		
		if dataId ~= nil and dataId > 0 then
			local cell_two = HeroPatchInformationPageTwo:createCell()
			cell_two:init(self.shipId)
			PageView_1:addPage(cell_two)
			table.insert(self.tabCtrlList, lightTwo)
			table.insert(cellList, cell_two)
		else
			darkTwo:setVisible(true)
		end
		
		local zoariumSkill = dms.int(dms["ship_mould"], dataId, ship_mould.zoarium_skill)
		if zoariumSkill ~= nil and zoariumSkill > 0 then
			local cell_three = HeroPatchInformationPageThree:createCell()
			cell_three:init(self.shipId)
			PageView_1:addPage(cell_three)
			table.insert(self.tabCtrlList, lightThree)
			table.insert(cellList, cell_three)
		else
			darkThree:setVisible(true)
		end
		
		local fate_relationship = dms.string(dms["ship_mould"], dataId, ship_mould.relationship_id)
		if fate_relationship ~= nil and fate_relationship ~= "" then
			local cell_four = HeroPatchInformationPageFour:createCell()
			cell_four:init(self.shipId)
			PageView_1:addPage(cell_four)
			table.insert(self.tabCtrlList, lightFour)
			table.insert(cellList, cell_four)
		else
			darkFour:setVisible(true)
		end	
	end
	PageView_1.tabCtrlList = self.tabCtrlList
	if self.types == 3 then
		if darkOne:isVisible() == false then
			PageView_1:scrollToPage(0)
		end
	elseif self.sell ~= 2 then
		lightOne:setVisible(true)
	else
		if darkOne:isVisible() == false then
			local one = cellList[1]
			local two = cellList[2]
			cellList[1] = two
			cellList[2] = one
			PageView_1:scrollToPage(1)
		end
	end
	
	local function pageViewEvent(sender, eventType)
		if eventType == ccui.PageViewEventType.turning then
			local pageView = sender
			local pageIndex = pageView:getCurPageIndex() + 1
			local tempTabCtrlList = pageView.tabCtrlList
			for i, v in pairs(tempTabCtrlList) do
				if v ~= nil then
					v:setVisible(false)
				end
			end
			pageView.__self:onUpdateDrawPetPage(pageIndex)
			tempTabCtrlList[pageIndex]:setVisible(true)
		end
	end 

	PageView_1:addEventListener(pageViewEvent)
	PageView_1.__self = self
	pageindex = PageView_1:getCurPageIndex() + 1
	self:onUpdateDrawPetPage(pageindex)
	if self.types == 2 then
		local one = cellList[1]
		local two = cellList[2]
		cellList[1] = two
		cellList[2] = one
		PageView_1:scrollToPage(1)
	elseif self.types == 1 then
		PageView_1:scrollToPage(0)
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local index = 0
		local function repetBack( ... )
			index = index + 1
			if index > #cellList then
				self:stopAllActions()
				return
			end
			local v = cellList[index]
			if v ~= nil then
				v:onLoad()
			end
		end
		repetBack()
		self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(repetBack))))
	end
end

function HeroPatchInformation:onUpdateDrawPetPage(pageindex)
	local root = self.roots[1]
	local Panel_pet = ccui.Helper:seekWidgetByName(root, "Panel_pet")
	if Panel_pet ~= nil and self._is_pet then 
		--有宠物了
		Panel_pet:setVisible(true)
		local fragmentOff = ccui.Helper:seekWidgetByName(root, "Image_tab_1_pet")
		local fragmentOn = ccui.Helper:seekWidgetByName(root, "Image_tab_3_pet")
		local petOff = ccui.Helper:seekWidgetByName(root, "Image_tab_1_0_pet")
		local petOn = ccui.Helper:seekWidgetByName(root, "Image_tab_3_0_pet")
		
		petOff:setVisible(pageindex == 1)
		petOn:setVisible(pageindex == 2)
		fragmentOff:setVisible(pageindex == 2)
		fragmentOn:setVisible(pageindex == 1)
	end
end
function HeroPatchInformation:onEnterTransitionFinish()
	local csbHeroPatchInformation= csb.createNode("packs/Detailed_information.csb")
	local action = csb.createTimeline("packs/Detailed_information.csb")
    csbHeroPatchInformation:runAction(action)
	action:play("window_open", false)
    self:addChild(csbHeroPatchInformation)
	local root = csbHeroPatchInformation:getChildByName("root")
	table.insert(self.roots, root)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
		ccui.Helper:seekWidgetByName(root, "Panel_wj"):setVisible(true)
		fwin:addTouchEventListener(Panel_2, nil, {func_string = [[state_machine.excute("hero_patch_information_close", 0, "hero_patch_information_close.'")]]}, nil, 0)
	elseif __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then 
		local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
		local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
		fwin:addTouchEventListener(Panel_6, nil, {func_string = [[state_machine.excute("hero_patch_information_close", 0, "hero_patch_information_close.'")]]}, nil, 0)
		fwin:addTouchEventListener(Panel_2, nil, {func_string = [[state_machine.excute("hero_patch_information_close", 0, "hero_patch_information_close.'")]]}, nil, 0)
	end
	self:onUpdateDraw()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "button_close_1"), nil, {func_string = [[state_machine.excute("hero_patch_information_close", 0, "hero_patch_information_close.'")]], 
									isPressedActionEnabled = true}, nil, 2)

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local button_7 = ccui.Helper:seekWidgetByName(root, "Button_7")
		local button_8 = ccui.Helper:seekWidgetByName(root, "Button_8")
		fwin:addTouchEventListener(button_7,nil,
		{
			terminal_name = "pageview_to_up", 
			terminal_state = 0
		},
		nil,0)
		fwin:addTouchEventListener(button_8,nil,
		{
			terminal_name = "pageview_to_down", 
			terminal_state = 0
		},
		nil,0)

		self:ChangePageView("init")--初始化按钮状态
	end
end

function HeroPatchInformation:onExit()
	state_machine.remove("hero_patch_information_close")
	state_machine.remove("pageview_to_up")
	state_machine.remove("pageview_to_down")
end

function HeroPatchInformation:init(shipId, types, classType, sell,from_type,ship)
	self.shipId = shipId

	self.types = types
	self.classType = classType
	self.sell = sell	--出售界面条转过来(第一位传入的是武将模板id)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.from_type = from_type
		self.ship_duixiang = ship
	end
end