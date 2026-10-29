-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面2
-------------------------------------------------------------------------------------------------------
HeroPatchInformationPageTwo = class("HeroPatchInformationPageTwoClass", Window)

function HeroPatchInformationPageTwo:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipId = nil
	self.from_type = nil
    local function init_hero_patch_information_page_two_terminal()
		
		-- 声音
		local hero_patch_information_page_music_terminal = {
            _name = "hero_patch_information_page_music",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local id = params._datas._id
				local tempMusicIndex = dms.int(dms["ship_mould"], id, ship_mould.sound_index)
			if tempMusicIndex > 0 then
				playEffect(formatMusicFile("effect", tempMusicIndex))
			end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--去获取
		local hero_patch_information_page_get_terminal = {
            _name = "hero_patch_information_page_get",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ship = params._datas._ship
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(ship)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_patch_information_page_music_terminal)
		state_machine.add(hero_patch_information_page_get_terminal)
        state_machine.init()
    end
    init_hero_patch_information_page_two_terminal()
end

function HeroPatchInformationPageTwo:onUpdateDraw()
	local root = self.roots[1]
	
	local Panel_juese = ccui.Helper:seekWidgetByName(root, "Panel_juese")				 --武将全身图
	local Panel_zhenying = ccui.Helper:seekWidgetByName(root, "Panel_zhenying") 		 --武将阵营
	local Panel_21 = ccui.Helper:seekWidgetByName(root, "Panel_21") 					 --武将类型
	local Text_name_1 = ccui.Helper:seekWidgetByName(root, "Text_name_1") 				 --武将名字
	local ListView_3 = ccui.Helper:seekWidgetByName(root, "ListView_3") 				 --滑动层
	local titleText = ccui.Helper:seekWidgetByName(root, "Text_shuma") 				 	 --标题
	local dataId = 0 
	if tonumber(self.classTypes) == 1 then
		dataId = self.shipId.goods_id
	elseif tonumber(self.classTypes) == 2 then
		dataId = self.shipId
	else
		dataId = dms.int(dms["prop_mould"], self.shipId.user_prop_template, prop_mould.use_of_ship)
	end
	local name = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], dataId, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], dataId, ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
		name = word_info[3]
    else
		name = dms.string(dms["ship_mould"], dataId, ship_mould.captain_name)
	end
	
	local name = dms.string(dms["ship_mould"], dataId, ship_mould.captain_name)
	local zhenying = dms.int(dms["ship_mould"], dataId, ship_mould.capacity)
	local picIndex = dms.int(dms["ship_mould"], dataId, ship_mould.All_icon)
	local heroType = dms.int(dms["ship_mould"], dataId, ship_mould.camp_preference)
	local quality = dms.int(dms["ship_mould"], dataId, ship_mould.ship_type)+1

	local captain_type = dms.int(dms["ship_mould"], dataId, ship_mould.captain_type)
	if captain_type == 3 then
		--宠物
		titleText:setString(_pet_tipString_info[1])
	end
		
	if __lua_project_id == __lua_project_yugioh then
		local Panel_shuxing = ccui.Helper:seekWidgetByName(root, "Panel_shuxing")
		local Panel_zhongzu = ccui.Helper:seekWidgetByName(root, "Panel_zhongzu")
		Panel_shuxing:removeBackGroundImage()
		Panel_zhongzu:removeBackGroundImage()
		local faction_id = dms.string(dms["ship_mould"], dataId, ship_mould.faction_id)
		local attribute_id = dms.string(dms["ship_mould"], dataId, ship_mould.attribute_id)
		Panel_shuxing:setBackGroundImage(string.format("images/ui/quality/shuxing_%s.png", attribute_id))
		Panel_zhongzu:setBackGroundImage(string.format("images/ui/quality/zhongzu_%s.png", faction_id))
	end

	Text_name_1:setString(name)
	Text_name_1:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		Panel_juese:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
	end
	local horn = ccui.Helper:seekWidgetByName(root, "Button_shengying")
	self.horn = horn
	self.horn:setVisible(hasShipSound(dataId))
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		if zhenying == 0 then
			Panel_zhenying:setBackGroundImage("images/ui/quality/pve_leixing_0.png")
		elseif zhenying == 1 then 	 --魏国
			Panel_zhenying:setBackGroundImage("images/ui/quality/pve_leixing_1.png")
		elseif zhenying == 2 then	--蜀国
			Panel_zhenying:setBackGroundImage("images/ui/quality/pve_leixing_2.png")
		elseif zhenying == 3 then	--吴国
			Panel_zhenying:setBackGroundImage("images/ui/quality/pve_leixing_3.png")
		elseif zhenying == 4 then	--群雄
			Panel_zhenying:setBackGroundImage("images/ui/quality/pve_leixing_4.png")
		end
	end
	
	if heroType == 0 then
	elseif heroType == 1 then
		Panel_21:setBackGroundImage("images/ui/quality/leixing_1.png")
	elseif heroType == 2 then
		Panel_21:setBackGroundImage("images/ui/quality/leixing_2.png")
	elseif heroType == 3 then
		Panel_21:setBackGroundImage("images/ui/quality/leixing_3.png")
	elseif heroType == 4 then
		Panel_21:setBackGroundImage("images/ui/quality/leixing_4.png")
	end
	
	if captain_type == 3 then 
		---宠物信息
		app.load("client.packs.pet.PetPatchInformationPageTwoChild")
		local cell = PetPatchInformationPageTwoChild:createCell()
		local ship_mould_id = nil
		if type(self.shipId) == "table" then 
			ship_mould_id = dms.int(dms["prop_mould"],self.shipId.user_prop_template,prop_mould.use_of_ship)
		else
			ship_mould_id = self.shipId
		end
		
		cell:init(ship_mould_id)
		ListView_3:addChild(cell)
	else
		local relationship_id = 0
		local talent_id = 0
		local prop = dms.searchs(dms["ship_mould"], ship_mould.id, dataId)
		local heroId = nil
		if prop ~= nil then
			for i, v in pairs(prop) do
				heroId = v[1]
				relationship_id = zstring.split(v[30],",")
				talent_id = zstring.split(v[31],"|")
			end
		end
		
		local drawLot = {}
		for i = 1, table.getn(relationship_id) do
			drawLot[i] = {}
			local relationship_id = relationship_id[i]		--缘分id
			local relationship_status = 0
			local relationship_name = dms.string(dms["fate_relationship_mould"], relationship_id, fate_relationship_mould.relation_name)
			local relationship_describe = dms.string(dms["fate_relationship_mould"], relationship_id, fate_relationship_mould.relation_describe)
			drawLot[i][1] = relationship_status
			drawLot[i][2] = relationship_name
			drawLot[i][3] = relationship_describe
		end
		
		local drawTalent = {}
		for i = 1, table.getn(talent_id) do
			drawTalent[i] = {}
			local talent_id = zstring.split(talent_id[i],",")		--缘分id
			local talent_status = 0
			local talent_name = dms.string(dms["talent_mould"], talent_id[3], talent_mould.talent_name)
			local talent_describe = dms.string(dms["talent_mould"], talent_id[3], talent_mould.talent_describe)
			drawTalent[i][1] = talent_status
			drawTalent[i][2] = talent_name
			drawTalent[i][3] = talent_describe
		end
		
		local skill = {}

		if (__lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert) 
			and self.from_type == 9 
			then
			app.load("client.cells.ship.l_ship_hero_base_information_cell_formation")
			local cell = LHeroBaseInformationFormation:createCell()
			ListView_3:removeAllItems()
			cell:init(self.ship)
			ListView_3:addChild(cell)
			for i =1, 4 do
				if i == 1 then
					local cell = HeroPatchInformationPageTwoChild:createCell()
					cell:init(dataId,i-1,skill)
					ListView_3:addChild(cell)
				elseif i == 2 then
					if drawLot[1][2] ~= nil then
						local cell = HeroPatchInformationPageTwoChild:createCell()
						cell:init(dataId,i-1,drawLot)
						ListView_3:addChild(cell)
					end
				elseif i == 3 then
					if drawTalent[1][2] ~= nil then
						local cell = HeroPatchInformationPageTwoChild:createCell()
						cell:init(dataId,i-1,drawTalent)
						ListView_3:addChild(cell)
					end
				elseif i == 4 then
					local cell = HeroPatchInformationPageTwoChild:createCell()
					cell:init(dataId,i-1,nil)
					ListView_3:addChild(cell)
				end
			end	

			ListView_3:requestRefreshView()	
		else
			for i =1, 4 do
				if i == 1 then
					local cell = HeroPatchInformationPageTwoChild:createCell()
					cell:init(dataId,i-1,skill)
					ListView_3:addChild(cell)
				elseif i == 2 then
					if drawLot[1][2] ~= nil then
						local cell = HeroPatchInformationPageTwoChild:createCell()
						cell:init(dataId,i-1,drawLot)
						ListView_3:addChild(cell)
					end
				elseif i == 3 then
					if drawTalent[1][2] ~= nil then
						local cell = HeroPatchInformationPageTwoChild:createCell()
						cell:init(dataId,i-1,drawTalent)
						ListView_3:addChild(cell)
					end
				elseif i == 4 then
					local cell = HeroPatchInformationPageTwoChild:createCell()
					cell:init(dataId,i-1,nil)
					ListView_3:addChild(cell)
				end
			end
		end
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
		{
			terminal_name = "hero_patch_information_page_get", 
			terminal_state = 0, 
			_ship = dataId,
			isPressedActionEnabled = true
		}, nil, 0)
		
		

	fwin:addTouchEventListener(horn, nil, 
	{
		-- func_string = [[state_machine.excute("hero_patch_information_page_music", 0, "hero_patch_information_page_music.'")]]
		terminal_name = "hero_patch_information_page_music", 
		terminal_state = 0, 
		_id = dataId,
		isPressedActionEnabled = true
	}, nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local function addhero( ... )
			local Panel_juese=ccui.Helper:seekWidgetByName(root, "Panel_juese")
			local temp_bust_index = 0
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				----------------------新的数码的形象------------------------
				--进化形象
				local evo_image = nil
				if type(self.shipId) ~= "table" then
					evo_image = dms.string(dms["ship_mould"], self.shipId, ship_mould.fitSkillTwo)
				else
					evo_image = dms.string(dms["ship_mould"], dataId, ship_mould.fitSkillTwo)
				end
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				-- local ship_evo = zstring.split(ship.evolution_status, "|")
				local evo_mould_id = 0
				if type(self.shipId) ~= "table" then
					evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.shipId, ship_mould.captain_name)]
				else
					evo_mould_id = evo_info[dms.int(dms["ship_mould"], dataId, ship_mould.captain_name)]
				end
				--新的形象编号
				temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			else
				if type(self.shipId) ~= "table" then
					temp_bust_index = dms.int(dms["ship_mould"], self.shipId, ship_mould.bust_index)
				else
					temp_bust_index = dms.int(dms["ship_mould"], dataId, ship_mould.bust_index)
				end
			end
			if temp_bust_index ~= nil then

				Panel_juese:removeAllChildren(true)
				draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_juese, nil, nil, cc.p(0.5, 0))
				if animationMode == 1 then
					app.load("client.battle.fight.FightEnum")
					local shipSpine = sp.spine_sprite(Panel_juese, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						shipSpine:setScaleX(-1)
					end
				else
					draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", Panel_juese, -1, nil, nil, cc.p(0.5, 0))
				end
			end
		end 
		local se = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
				addhero()
			end)})
		self:runAction(se)
	end
	
end

function HeroPatchInformationPageTwo:onEnterTransitionFinish()

end

function HeroPatchInformationPageTwo:onLoad( ... )

	local csbHeroPatchInformationPageTwo = csb.createNode("packs/Fragmentation_information.csb")
    self:addChild(csbHeroPatchInformationPageTwo)
	local root = csbHeroPatchInformationPageTwo:getChildByName("root")
	table.insert(self.roots, root)	 
	self:onUpdateDraw()
	
end
function HeroPatchInformationPageTwo:close( ... )

	local root = self.roots[1]
	if root == nil then
		return
	end
	local ListView_3 = ccui.Helper:seekWidgetByName(root, "ListView_3")
	ListView_3:removeAllItems()
	local Panel_juese=ccui.Helper:seekWidgetByName(root, "Panel_juese")
	Panel_juese:removeAllChildren(true)
end

function HeroPatchInformationPageTwo:onExit()
	state_machine.remove("hero_patch_information_page_music")
	state_machine.remove("hero_patch_information_page_get")
end

function HeroPatchInformationPageTwo:init(shipId ,classTypes,from_type,ship)
	self.shipId = shipId
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	-- 	if type(self.shipId) ~= "table" then
	-- 		self.shipId = {user_prop_template = self.shipId}
	-- 	end
	-- end
	self.classTypes = classTypes
	self.from_type = from_type
	self.ship = ship

	self:setContentSize(HeroPatchInformation.__size)
end

function HeroPatchInformationPageTwo:createCell()
	local cell = HeroPatchInformationPageTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end