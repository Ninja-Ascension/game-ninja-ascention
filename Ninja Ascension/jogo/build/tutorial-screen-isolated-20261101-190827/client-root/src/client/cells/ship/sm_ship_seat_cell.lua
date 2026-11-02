---------------------------------
---说明：武将信息选项卡
-- 创建时间:2017.07.12
-- 作者：李文鋆
-- 修改记录：
-- 最后修改人：
---------------------------------
SmHeroSeatCell = class("SmHeroSeatCellClass", Window)
SmHeroSeatCell.__size = nil
SmHeroSeatCell.__userHeroFontName = nil
function SmHeroSeatCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.heroInstance = nil
	self.num = nil
	app.load("client.cells.ship.ship_head_new_cell")
    local function init_SmHeroSeat_terminal()
	
		local sm_hero_seat_update_terminal = {
            _name = "sm_hero_seat_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params:onUpdateDraw()


                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --装备
        local sm_hero_seat_open_equip_terminal = {
            _name = "sm_hero_seat_open_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cells = params._datas.cells
				-- 装备，觉醒，淬炼在新的界面
				if funOpenDrawTip(96) == false then
					instance:openEquipDevelop(cells.heroInstance)
				end

				-- if funOpenDrawTip(96) == false then
				-- 	instance:openHeroDevelop(cells.heroInstance,1)
				-- end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--强化
        local sm_hero_seat_open_strengthen_terminal = {
            _name = "sm_hero_seat_open_strengthen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cells = params._datas.cells
				instance:openHeroDevelop(cells.heroInstance,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --合成
        local sm_hero_seat_open_synthesis_terminal = {
            _name = "sm_hero_seat_open_synthesis",
            _init = function (terminal) 
                --app.load("client.packs.hero.SmHeroSynthesisSuccess")
                app.load("client.reward.DrawRareReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCompoundHeroCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("hero_list_view_remove_cell", 0, "")

						local getRewardWnd = DrawRareReward:new()
						local reworldInfo = {}
						reworldInfo.show_reward_item_count = 1
						reworldInfo.show_reward_list = {}
						reworldInfo.show_reward_list[1] = {}
						reworldInfo.show_reward_list[1].item_value = 1
						reworldInfo.show_reward_list[1].prop_type = 13
						reworldInfo.show_reward_list[1].prop_item = _ED.user_ship["".._ED.recruit_success_ship_id].ship_template_id
						getRewardWnd:init(0,reworldInfo)
						fwin:open(getRewardWnd, fwin._ui)
						_ED.recruit_success_ship_id = nil
						--修改为在DrawRareReward中打开
						-- local isOver = false
						-- local schedulerID = nil
						-- local function anticlockwiseUpdate()
      --                       local obj = SmHeroSynthesisSuccess:new()
      --                   	fwin:open(obj,fwin._windows)
      --                   	isOver = true
      --                   	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID) 
      --                   end
      --                   local scheduler = cc.Director:getInstance():getScheduler()
      --                   if schedulerID ~= nil then 
      --                       scheduler:unscheduleScriptEntry(schedulerID)      
      --                   end
                        
      --                   if isOver == false then
      --                   	schedulerID = scheduler:scheduleScriptFunc(anticlockwiseUpdate,0.8,false)
      --                   end
     				else
	 					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							state_machine.unlock("sm_hero_seat_open_synthesis", 0, "")
							state_machine.excute("hero_list_view_update_cell_lock_synthesis", 0, false)
						end
					end
				end
				local props = fundPropWidthId(params._datas.cells.prop)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					state_machine.lock("sm_hero_seat_open_synthesis", 0, "")
					state_machine.excute("hero_list_view_update_cell_lock_synthesis", 0, true)
				end
				protocol_command.prop_compound.param_list = ""..props.user_prop_id.."\r\n".."1".."\r\n".."1"
				NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, params, responseCompoundHeroCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --来源
        local sm_hero_seat_open_source_terminal = {
            _name = "sm_hero_seat_open_source",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroPatchInformationPageGetWay")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cells = params._datas.cells
            	local prop = cells.prop
				
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(prop,5)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --武将信息
		local sm_hero_seat_mould_info_terminal = {
            _name = "sm_hero_seat_mould_info",
            _init = function (terminal) 
                app.load("client.formation.HeroInformation")
                app.load("client.packs.hero.SmRoleInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cells = params._datas.cells
            	local prop = cells.prop
            	if not prop then
            		return
            	end
				local ship_id = dms.string(dms["prop_mould"], prop, prop_mould.use_of_ship)
				state_machine.excute("sm_role_information_open", 0, {ship_id, 1, cells.index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新装备红点同时刷新战力
		local sm_hero_seat_update_equip_button_push_terminal = {
            _name = "sm_hero_seat_update_equip_button_push",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params
				cell:equipButtonPushDraw(cell)
				cell:updateDrawShipPower(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新强化红点同时刷新战力
		local sm_hero_seat_update_strength_button_push_terminal = {
            _name = "sm_hero_seat_update_strength_button_push",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params
				cell:strengthButtonPushDraw(cell)
				cell:updateDrawShipPower(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local sm_hero_seat_update_ship_praise_info_terminal = {
            _name = "sm_hero_seat_update_ship_praise_info",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params
				cell:updateShipPraiseInfo(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_hero_seat_update_terminal)
		state_machine.add(sm_hero_seat_open_equip_terminal)
		state_machine.add(sm_hero_seat_open_strengthen_terminal)
		state_machine.add(sm_hero_seat_open_synthesis_terminal)
		state_machine.add(sm_hero_seat_open_source_terminal)
		state_machine.add(sm_hero_seat_mould_info_terminal)
		state_machine.add(sm_hero_seat_update_equip_button_push_terminal)
		state_machine.add(sm_hero_seat_update_strength_button_push_terminal)
		state_machine.add(sm_hero_seat_update_ship_praise_info_terminal)
        state_machine.init()
    end
    
    init_SmHeroSeat_terminal()
end

function SmHeroSeatCell:openEquipDevelop(ship)
	if fwin:find("HeroIconListViewClass") == nil then
		app.load("client.packs.hero.HeroIconListView")
	   	state_machine.excute("hero_icon_listview_open",0,ship)
	   	fwin:find("HeroIconListViewClass"):setVisible(false)
   	end

   	--武将装备数据(等级|品质|经验|星级|模板)
	local shipEquip = zstring.split(ship.equipInfo, "|")
	local equipData = zstring.split(shipEquip[5], ",")
	local equipStar = zstring.split(shipEquip[4], ",")
	local equipMouldId = equipData[1]
	local equip = {}
	--装备模板id
	--初始装备
	local equipAll = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.treasureSkill)
	if tonumber(equipStar[1]) == 0 then
		local equipMouldData = zstring.split(equipAll, ",")
		equip.user_equiment_template = equipMouldData[1]
	else
		equip.user_equiment_template = equipMouldId
	end
	--装备等级
	local equipLevelData = zstring.split(shipEquip[1], ",")
	equip.user_equiment_grade = equipLevelData[1]
	--所属战船
	equip.ship_id = ship.ship_id
	equip.m_index = 1
	equip.isPacks = true

	app.load("client.packs.equipment.SmEquipmentQianghua")
	state_machine.excute("sm_equipment_qianghua_open",0,equip)

end

function SmHeroSeatCell:openHeroDevelop(ship,m_type)
	enter_type = "learn"
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		if fwin:find("HeroIconListViewClass") == nil then
			app.load("client.packs.hero.HeroIconListView")
		   	state_machine.excute("hero_icon_listview_open",0,ship)
		   	fwin:find("HeroIconListViewClass"):setVisible(false)
	   	end
   	end
	app.load("client.packs.hero.HeroDevelop")
	if fwin:find("HeroDevelopClass") ~= nil then
		state_machine.excute("formation_set_ship",0,ship)
		return
		-- fwin:close(fwin:find("HeroDevelopClass"))
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("hero_storage_return_home_page",0,"")
		_ED.ship_warehouse_enter = true
	end
	local heroDevelopWindow = HeroDevelop:new()
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		ship.shengming = zstring.tonumber(ship.ship_health)
		ship.gongji = zstring.tonumber(ship.ship_courage)
		ship.waigong = zstring.tonumber(ship.ship_intellect)
		ship.neigong = zstring.tonumber(ship.ship_quick)
	end
	-- print("=======11=====",enter_type)
	if enter_type ~= "learn" and enter_type ~= "pack" then
		enter_type = "formation"
	end
	for i,v in pairs(_ED.user_formetion_status) do
		if zstring.tonumber(v) == tonumber(ship.ship_id) then
			enter_type = "formation"
		end
	end
	heroDevelopWindow:init(ship.ship_id, "pack",m_type)
	fwin:open(heroDevelopWindow, fwin._view)


	
	-- fwin:close(fwin:find("HeroListViewClass"))
	-- fwin:close(fwin:find("HeroStorageClass"))
end

function SmHeroSeatCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
		headPanel = ccui.Helper:seekWidgetByName(root, "Panel_juese_01")
	end
	headPanel:removeAllChildren(true)
	local Text_dengji = ccui.Helper:seekWidgetByName(root, "Text_dengji")
	local Text_fighting = ccui.Helper:seekWidgetByName(root, "Text_fighting")
	local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
	local Image_ysz = ccui.Helper:seekWidgetByName(root, "Image_ysz")
	local Button_zhuangbei = ccui.Helper:seekWidgetByName(root, "Button_zhuangbei")
	local Button_qianghua = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
	local Button_hecheng = ccui.Helper:seekWidgetByName(root, "Button_hecheng")
	Button_hecheng:setVisible(false)
	local Button_laiyuan = ccui.Helper:seekWidgetByName(root, "Button_laiyuan")
	local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
	Panel_strengthen_stye:removeBackGroundImage()
	local Image_loadingbar_bg = ccui.Helper:seekWidgetByName(root, "Image_loadingbar_bg")
	local LoadingBar_number = ccui.Helper:seekWidgetByName(root, "LoadingBar_number")
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")

	if self.heroInstance ~= nil then
		local hero_head = ShipHeadNewCell:createCell()
		hero_head:init(self.heroInstance,hero_head.enum_type._SHOW_SHIP_INFORMATION,nil,{showNum = self.heroInstance.ship_grade, chooseIndex = self.index})
		if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
		else
			headPanel:addChild(hero_head)
		end

		if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
			local picIndex = 0
			local evo_mould_id = smGetSkinEvoIdChange( self.heroInstance )
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			local Panel_prop_icon = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", "".. picIndex))
			if Panel_prop_icon ~= nil then
				Panel_prop_icon:setPosition(cc.p(headPanel:getContentSize().width/2,headPanel:getContentSize().height/2))
				headPanel:addChild(Panel_prop_icon)
			end
		end

		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.heroInstance.evolution_status, "|")
		local evo_mould_id =  smGetSkinEvoIdChange(self.heroInstance)
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		local hero_name = word_info[3]
		--武将

		if getShipNameOrder(tonumber(self.heroInstance.Order)) > 0 then
	        hero_name = hero_name.." +"..getShipNameOrder(tonumber(self.heroInstance.Order))
	    end
	    local quality = shipOrEquipSetColour(tonumber(self.heroInstance.Order))
		Text_dengji:setString(hero_name)
		local color_R = tipStringInfo_quality_color_Type[quality][1]
	    local color_G = tipStringInfo_quality_color_Type[quality][2]
	    local color_B = tipStringInfo_quality_color_Type[quality][3]
	    Text_dengji:setColor(cc.c3b(color_R, color_G, color_B))
		
		local camp_preference = dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.camp_preference)
		if camp_preference> 0 and camp_preference <=3 then
			Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
		end
	    --战斗力
	    Text_fighting:setVisible(true)
		Text_fighting_n:setVisible(true)
		
		local heroFightVal = self.heroInstance.hero_fight
		if heroFightVal == nil or heroFightVal == "" then 
			heroFightVal = getShipByTalent(self.heroInstance).hero_fight
		end
		Text_fighting_n:setString(heroFightVal)
	    --Text_fighting_n:setString()

	    if Image_ysz ~= nil then
		    if zstring.tonumber(self.heroInstance.formation_index) > 0 then
		    	Image_ysz:setVisible(true)
		    else
		    	Image_ysz:setVisible(false)
		    end
		end

		if self.Image_ysd then
			self.Image_ysd:setVisible(false)
			if 1 == tonumber(self.heroInstance.combLockState) then
				self.Image_ysd:setVisible(true)
			end
		end
	    Image_loadingbar_bg:setVisible(false)
	    LoadingBar_number:setVisible(false)
	    Text_number:setVisible(false)
	    --按钮
	    Button_zhuangbei:setVisible(true)
	    Button_qianghua:setVisible(true)
	    Button_laiyuan:setVisible(false)
	else
		local hero_mould_id = dms.string(dms["prop_mould"], self.prop, prop_mould.use_of_ship)
		local hero_head = ShipHeadNewCell:createCell()
		hero_head:init(hero_mould_id,hero_head.enum_type._SHOW_HERO_FROM_WARCRAFT, false)

		if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
		else
			headPanel:addChild(hero_head)
		end

		--进化形象
		local evo_image = dms.string(dms["ship_mould"], hero_mould_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local evo_mould_id =  evo_info[dms.int(dms["ship_mould"], hero_mould_id, ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		local hero_name = word_info[3]
		Text_dengji:setString(hero_name)
		Text_dengji:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))

		local camp_preference = dms.int(dms["ship_mould"], hero_mould_id, ship_mould.camp_preference)
		if camp_preference> 0 and camp_preference <=3 then
			Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
		end
		if Image_ysz ~= nil then
			Image_ysz:setVisible(false)
		end
		Text_fighting:setVisible(false)
	    Text_fighting_n:setVisible(false)

	    --进度条
	    Image_loadingbar_bg:setVisible(true)
	    LoadingBar_number:setVisible(true)
	    Text_number:setVisible(true)
	    local currentCount = zstring.tonumber(getPropAllCountByMouldId(self.prop))
    	local demandCount = dms.int(dms["prop_mould"], self.prop, prop_mould.split_or_merge_count)
    	LoadingBar_number:setPercent(currentCount/demandCount*100)
    	Text_number:setString(currentCount.."/"..demandCount)
	    --按钮
	    Button_zhuangbei:setVisible(false)
	    Button_qianghua:setVisible(false)
	    Button_laiyuan:setVisible(true)
	    if currentCount >= demandCount then
	    	Button_hecheng:setVisible(true)
	    	local jsonFile = "sprite/sprite_wzkp.json"
	        local atlasFile = "sprite/sprite_wzkp.atlas"
	        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	        animation:setPosition(cc.p(headPanel:getContentSize().width/2,headPanel:getContentSize().height/2))
	        headPanel:addChild(animation)
	    	Button_laiyuan:setVisible(false)
	    end

	    if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
	    	local picIndex = 0
			local evo_image = dms.string(dms["ship_mould"], hero_mould_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.heroInstance.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], hero_mould_id, ship_mould.captain_name)]
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			local Panel_prop_icon = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", "".. picIndex))
			if Panel_prop_icon ~= nil then
				Panel_prop_icon:setPosition(cc.p(headPanel:getContentSize().width/2,headPanel:getContentSize().height/2))
				headPanel:addChild(Panel_prop_icon)
			end
		end
    end

    local Image_soul_warding  =  ccui.Helper:seekWidgetByName(root, "Image_soul_warding")
    if Image_soul_warding then
    	Image_soul_warding:setVisible(false)
    end
	if _ED.soul_warding_formation_hero then
		for k,v in pairs(_ED.soul_warding_formation_hero) do
			if self.heroInstance and tonumber(v.onUseShipMouldId) ==  tonumber(self.heroInstance.ship_template_id)  then
				ccui.Helper:seekWidgetByName(root, "Button_hecheng"):setVisible(false)
                ccui.Helper:seekWidgetByName(root, "Image_soul_warding"):setVisible(true)
			end
		end
	end
end

--装备按钮
function SmHeroSeatCell:getShipWarehouseShipEquipTip(ship)
	if ship == nil then
		return false
	end
	if shipEquipmentIsCanEvolution(ship) == true then
        return true
    end
    if shipEquipmentIsCanAwake(ship) == true then
        return true
    end
	-- for j = 1 , 6 do
	-- 	if equipmentIsCanEvolution(ship , j) == true then
	-- 		return true
	-- 	end
	-- 	if equipmentIsCanAwake(ship , j) == true then
	-- 		return true
	-- 	end
	-- end
	return false
end

--武将强化按钮
function SmHeroSeatCell:getShipWarehouseShipStrengthTip(ship)
	if ship == nil then
		return false
	end
	if shipIsCanEvolution(ship) == true then
		return true
	end
	if shipIsCanUpGradeStar(ship) == true then
		return true
	end
	return false
end

function SmHeroSeatCell:equipButtonPushDraw( cell )
	local root = cell.roots[1]
	if root ~= nil then
		local Button_zhuangbei = ccui.Helper:seekWidgetByName(root, "Button_zhuangbei")
		local ballEquip = Button_zhuangbei:getChildByName("ball")
		if cell:getShipWarehouseShipEquipTip(cell.heroInstance) == true then
			ballEquip:setVisible(true) 
		else
			ballEquip:setVisible(false)
		end
	end
end

function SmHeroSeatCell:strengthButtonPushDraw( cell )
	local root = cell.roots[1]
	if root ~= nil then
		local Button_qianghua = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
		local ballShip = Button_qianghua:getChildByName("ball")
		if cell:getShipWarehouseShipStrengthTip(cell.heroInstance) == true then
			ballShip:setVisible(true) 
		else
			ballShip:setVisible(false)
		end
	end
end
--刷新战力
function SmHeroSeatCell:updateDrawShipPower(cell)
	local root = cell.roots[1]
	if cell.heroInstance ~= nil then
		-- Por INSTANCIA (ship_id), NUNCA por molde: con dos copias del mismo
		-- heroe, buscar por ship_template_id devuelve una CUALQUIERA y la
		-- tarjeta se queda pintando -y abriendo con «Mejorar»- el duplicado.
		local ship = fundShipWidthId(cell.heroInstance.ship_id)
		if ship ~= nil then
			cell.heroInstance = ship
		end
		cell:onUpdateDraw()
	end
end

function SmHeroSeatCell:updateShipPraiseInfo( cell )
	local root = cell.roots[1]
	local Text_fighting_n_0 = ccui.Helper:seekWidgetByName(root, "Text_fighting_n_0")
	if Text_fighting_n_0 ~= nil then
		local Panel_good = ccui.Helper:seekWidgetByName(root, "Panel_good")
		local ship_id = 0
		if cell.heroInstance ~= nil then
			ship_id = cell.heroInstance.ship_template_id
		else
			ship_id = dms.string(dms["prop_mould"], cell.prop, prop_mould.use_of_ship)
		end
		if _ED.user_ship_praise_rank_list ~= nil 
			and _ED.user_ship_praise_rank_list[""..ship_id] ~= nil
			then
			local rank = tonumber(_ED.user_ship_praise_rank_list[""..ship_id].rank)
			if rank <= 10 then
				Text_fighting_n_0:setString(_ED.user_ship_praise_rank_list[""..ship_id].count.."(NO."..rank..")")
			else
				Text_fighting_n_0:setString(_ED.user_ship_praise_rank_list[""..ship_id].count)
			end
		else
			Text_fighting_n_0:setString("0")
		end
		Panel_good:setBackGroundImage("images/ui/icon/good_1.png")
		if _ED.user_ship_praise_state_info ~= nil then
			for k,v in pairs(_ED.user_ship_praise_state_info) do
				if tonumber(v) == tonumber(ship_id) then
					Panel_good:setBackGroundImage("images/ui/icon/good_2.png")
					break
				end
			end
		end
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
			Panel_good:setVisible(false)
			Text_fighting_n_0:setVisible(false)
			local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
			Panel_star:removeAllChildren(true)
			Panel_good:setVisible(false)
			Panel_star:setVisible(true)
			if self.heroInstance ~= nil and self.heroInstance.StarRating ~= nil then
				local initStar = tonumber(self.heroInstance.StarRating)
				neWshowShipStar(Panel_star , initStar)
			end
		end
	end
end

function SmHeroSeatCell:onEnterTransitionFinish()

end

function SmHeroSeatCell:onInit()
	local root = cacher.createUIRef("packs/HeroStorage/sm_list_generals_big.csb", "root")
	-- Desktop proportions are corrected once on the complete ninja list.
	-- Per-card correction leaves wide gaps between the original columns.
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmHeroSeatCell.__size == nil then
 		SmHeroSeatCell.__size = root:getContentSize()
 	end

 	--装备
 	local Button_zhuangbei = ccui.Helper:seekWidgetByName(root, "Button_zhuangbei")
	fwin:addTouchEventListener(Button_zhuangbei, nil, 
	{
		terminal_name = "sm_hero_seat_open_equip", 	
		terminal_state = 0, 
		cells = self,
		isPressedActionEnabled = true
	},	
	nil, 0)	

	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_ship_warehouse_ship_equip_tip",
	-- 	_widget = self.roots[1],
	-- 	_invoke = nil,
	-- 	_cell = self,
	-- 	_interval = 0.5,})
	if Button_zhuangbei:getChildByName("ball") == nil then
		local ball = cc.Sprite:create("images/ui/bar/tips.png")
		ball:setAnchorPoint(cc.p(0.7, 0.7))
		ball:setPosition(cc.p(Button_zhuangbei:getContentSize().width, Button_zhuangbei:getContentSize().height))
		Button_zhuangbei:addChild(ball)
		ball:setName("ball")
		ball:setVisible(false)
		-- DSC重塑   
		if __lua_project_id == __lua_project_l_digital then 
			local btnScaleNum = Button_zhuangbei:getScale()
			ball:setScale(1/btnScaleNum)
		end
	end

	--强化
	local Button_qianghua = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
	fwin:addTouchEventListener(Button_qianghua, nil, 
	{
		terminal_name = "sm_hero_seat_open_strengthen", 	
		terminal_state = 0, 
		cells = self,
		isPressedActionEnabled = true
	},	
	nil, 0)	
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_ship_warehouse_ship_strength_tip",
	-- 	_widget = self.roots[1],
	-- 	_invoke = nil,
	-- 	_cell = self,
	-- 	_interval = 0.5,})
	if Button_qianghua:getChildByName("ball") == nil then
		local ball = cc.Sprite:create("images/ui/bar/tips.png")
		ball:setAnchorPoint(cc.p(0.7, 0.7))
		ball:setPosition(cc.p(Button_qianghua:getContentSize().width, Button_qianghua:getContentSize().height))
		Button_qianghua:addChild(ball)
		ball:setName("ball")
		ball:setVisible(false)  
		-- DSC重塑   
		if __lua_project_id == __lua_project_l_digital then 
			local btnScaleNum = Button_qianghua:getScale()
			ball:setScale(1/btnScaleNum)
		end
	end

	--合成
	local Button_hecheng = ccui.Helper:seekWidgetByName(root, "Button_hecheng")
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		--
	else
		Button_hecheng:setTitleText(_new_interface_text[237])
	end
	fwin:addTouchEventListener(Button_hecheng, nil, 
	{
		terminal_name = "sm_hero_seat_open_synthesis", 	
		terminal_state = 0, 
		cells = self,
		isPressedActionEnabled = true
	},	
	nil, 0)	
	--追踪
	local Button_laiyuan = ccui.Helper:seekWidgetByName(root, "Button_laiyuan")
	fwin:addTouchEventListener(Button_laiyuan, nil, 
	{
		terminal_name = "sm_hero_seat_open_source", 	
		terminal_state = 0, 
		cells = self,
		isPressedActionEnabled = true
	},	
	nil, 0)	

	--查看
	if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
		local Panel_juese_01 = ccui.Helper:seekWidgetByName(root, "Panel_juese_01")
		-- fwin:addTouchEventListener(Panel_juese_01, nil, 
		-- {
		-- 	terminal_name = "sm_hero_seat_mould_info", 	
		-- 	terminal_state = 0, 
		-- 	cells = self,
		-- 	isPressedActionEnabled = true
		-- },	
		-- nil, 0)	

		ccui.Helper:seekWidgetByName(root, "Panel_wujiang"):setVisible(false)
	else
		local Panel_wujiang = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
		fwin:addTouchEventListener(Panel_wujiang, nil, 
		{
			terminal_name = "sm_hero_seat_mould_info", 	
			terminal_state = 0, 
			cells = self,
			isPressedActionEnabled = true
		},	
		nil, 0)	
	end

	-- 组合卡上阵锁定 
	self.Image_ysd = ccui.Helper:seekWidgetByName(root, "Image_ysd")
	if self.Image_ysd then
		self.Image_ysd:setVisible(false)
	end

	self:onUpdateDraw()
	self:equipButtonPushDraw(self)
	self:strengthButtonPushDraw(self)
	self:updateShipPraiseInfo(self)
end

function SmHeroSeatCell:clearUIInfo( ... )
	local root = self.roots[1]
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
		headPanel = ccui.Helper:seekWidgetByName(root, "Panel_juese_01")
	end
	if headPanel ~= nil then
		headPanel:removeAllChildren(true)
	end
	local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
	if Panel_strengthen_stye ~= nil then
		Panel_strengthen_stye:removeBackGroundImage()
		Panel_strengthen_stye:removeAllChildren(true)
	end
	local Button_qianghua = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
	if Button_qianghua ~= nil then
		if Button_qianghua:getChildByName("ball") ~= nil then
			Button_qianghua:removeChildByName("ball")
		end
		Button_qianghua:setVisible(false)
	end
	local Button_zhuangbei = ccui.Helper:seekWidgetByName(root, "Button_zhuangbei")
	if Button_zhuangbei ~= nil then
		if Button_zhuangbei:getChildByName("ball") ~= nil then
			Button_zhuangbei:removeChildByName("ball")
		end

		Button_zhuangbei:setVisible(false)
	end
	local LoadingBar_number = ccui.Helper:seekWidgetByName(root, "LoadingBar_number")
	if LoadingBar_number ~= nil then
		LoadingBar_number:setPercent(0)
	end
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	if Text_number ~= nil then
		Text_number:setString("")
	end
	local Image_loadingbar_bg = ccui.Helper:seekWidgetByName(root, "Image_loadingbar_bg")
	if Image_loadingbar_bg ~= nil then
		Image_loadingbar_bg:setVisible(false)
	end
	local Text_fighting = ccui.Helper:seekWidgetByName(root, "Text_fighting")
	if Text_fighting ~= nil then
		Text_fighting:setVisible(false)
	end
	local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
	if Text_fighting_n ~= nil then
		Text_fighting_n:setVisible(false)
	end
	local Button_shangzhen = ccui.Helper:seekWidgetByName(root, "Button_shangzhen")
	if Button_shangzhen ~= nil then
		Button_shangzhen:setVisible(false)
	end
	local Button_hecheng = ccui.Helper:seekWidgetByName(root, "Button_hecheng")
	if Button_hecheng ~= nil then
		Button_hecheng:setVisible(false)
	end
	local Button_laiyuan = ccui.Helper:seekWidgetByName(root, "Button_laiyuan")
	if Button_laiyuan ~= nil then
		Button_laiyuan:setVisible(false)
	end
end

function SmHeroSeatCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("packs/HeroStorage/sm_list_generals_big.csb", self.roots[1])
end

function SmHeroSeatCell:init(heroInstance, m_type, index)
	if m_type == 1 then
		--获得的武将
		self.heroInstance = heroInstance
	else
		--没获得的武将
		self.prop = heroInstance
	end
	self.index = index
	if index ~= nil and index < 11 then
		self:onInit()
	end
	self:setContentSize(SmHeroSeatCell.__size)
	return self
end

function SmHeroSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmHeroSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("packs/HeroStorage/sm_list_generals_big.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function SmHeroSeatCell:createCell()
	local cell = SmHeroSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
