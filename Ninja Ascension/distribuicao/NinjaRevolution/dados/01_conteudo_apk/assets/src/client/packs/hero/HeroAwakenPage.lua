-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将觉醒界面
-------------------------------------------------------------------------------------------------------
HeroAwakenPage = class("HeroAwakenPageClass", Window)
HeroAwakenPage.__userHeroFontName = nil
function HeroAwakenPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.shipId = 0        --当前武将Id
	self.ship = nil		--当前武将信息
	self.proAdvanced = {}	--突破石信息
	self.shipMouldFront = nil -- 进阶前模板ID
	self.shipMouldBack = nil  -- 进阶后模板ID
	self.materialData = nil
	self.keepOutPanel = {}	-- 遮挡层
	self.PanelCacheFightArmature = nil
	self.cacheFightArmature = nil
	self.awaken_info = nil -- 觉醒所需材料 
	self.awaken_next_info = nil --下一级觉醒属性
	--升阶前的船只属性给升阶成长用的
	-- 1：等级
	-- 2：生命
	-- 3：攻击
	-- 4：物防
	-- 5：法防
	self._advancedBefore = {}
	self._advancedBack = {}
	--需求武将表
	self.num = 0
	self.needMaterialShip ={}
	self.needShipPCount = 0
	--需求的道具表
	self.needMaterialProp ={}

	self.needEquiPCount = 0
	self.types = nil
	self.shopmould = nil
	self.needCount = 0
	self.awakenLevel = 0
	self.awakenPropNum = 0 --需要觉醒材料个数
	self.ArmatureNode_1 = nil  --觉醒成功动画
	self.ArmatureNodePanel = nil  --
	
	self.lock = false
	app.load("client.cells.ship.ship_body_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.cells.ship.ship_body_cell_new")
	
    local function init_hero_awaken_page_terminal()
	
		--让其他类刷新本类信息
		local hero_awaken_page_check_updata_by_other_page_terminal = {
            _name = "hero_awaken_page_check_updata_by_other_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then 
            		instance:onUpdateDraw()
            	end
			    
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --道具浏览
		local hero_awaken_page_props_browse_terminal = {
            _name = "hero_awaken_page_props_browse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.awaken_next_info == nil then 
            		--满级了 
            		TipDlg.drawTextDailog(_awaken_tipString_info[10])
            		return
            	end
			    app.load("client.packs.hero.HeroAwakenPropBrowse")
			    local browseWindow = HeroAwakenPropBrowse:new()
			    browseWindow:init(instance.shopmould ,instance.awakenLevel)
			 	fwin:open(browseWindow, fwin._viewdialog)  
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --装备商店
		local hero_awaken_page_shop_terminal = {
            _name = "hero_awaken_page_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    app.load("client.packs.hero.HeroAwakenShop")
			    local shop = HeroAwakenShop:new()
			    shop:init(1)
			 	fwin:open(shop, fwin._viewdialog) 
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --觉醒英雄
		local hero_awaken_page_shop_awaken_terminal = {
            _name = "hero_awaken_page_shop_awaken",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
          
            	 local function responseWearCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("hero_strengthen_page_check_updata_by_other_page",0,0)	
						state_machine.excute("hero_advanced_page_check_updata_by_other_page",0,0)
						--从上层列表背包移除
						if _ED.up_streng_reduce_ship == nil then 
							_ED.up_streng_reduce_ship = {}
						end
						
						state_machine.excute("hero_list_view_remove_cell", 0, _ED.up_streng_reduce_ship)
						_ED.up_streng_reduce_ship = nil
						
						_ED.baseFightingCount = calcTotalFormationFight()
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
	            			return
	            		end
        				instance:playAwakenAction()

						
		            end
				end
		
				local shipId = params._datas.shipId
				protocol_command.ship_awaken.param_list = shipId
				NetworkManager:register(protocol_command.ship_awaken.code, nil, nil, nil, instance, responseWearCallback, false, nil)
            
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --点击道具 查看，装备，获取
		local hero_awaken_page_props_click_terminal = {
            _name = "hero_awaken_page_props_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.packs.hero.HeroAwakenEquipInfo")
				local equipId = params._datas.equip
			    local index = params._datas.drawIndex
			    local showType = params._datas.showType
				local cell = HeroAwakenEquipInfo:new()
				cell:init(equipId,showType,index,instance.shipId)
				fwin:open(cell, fwin._dialog)

			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --穿戴后属性增加
		local hero_awaken_page_wear_success_update_page_terminal = {
            _name = "hero_awaken_page_wear_success_update_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil then 
          			instance:playWearPropAction(params)
            	end
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(hero_awaken_page_check_updata_by_other_page_terminal)	
        state_machine.add(hero_awaken_page_shop_terminal)	
        state_machine.add(hero_awaken_page_props_browse_terminal)	
        state_machine.add(hero_awaken_page_shop_awaken_terminal)  
        state_machine.add(hero_awaken_page_props_click_terminal)  
        state_machine.add(hero_awaken_page_wear_success_update_page_terminal)  
        state_machine.init()
    end
    init_hero_awaken_page_terminal()
end

function HeroAwakenPage:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self.ship = fundShipWidthId(self.shipId)
	self._advancedBefore[1] = self.ship.ship_health
	self._advancedBefore[2] = self.ship.ship_courage
	self._advancedBefore[3] = self.ship.ship_intellect
	self._advancedBefore[4] = self.ship.ship_quick
	
	local Panel_wujiang = ccui.Helper:seekWidgetByName(root,"Panel_wujiang")
	Panel_wujiang:removeAllChildren(true)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		local cell = ShipBodyCellNew:createCell()
        local temple_id = self.ship.ship_template_id
        local picIndex = dms.int(dms["ship_mould"], temple_id, ship_mould.All_icon)
        local roleShipId = dms.string(dms["ship_mould"], temple_id, ship_mould.bust_index)
        cell:init(picIndex, true, nil, roleShipId)
        Panel_wujiang:addChild(cell)
	else
		local shipCell = ShipBodyCell:createCell()
		shipCell:init({ship_template_id = self.shopmould }, 0)
		Panel_wujiang:addChild(shipCell)
	end

	local nextAwakenText = ccui.Helper:seekWidgetByName(root,"Text_20")
	local nextInfoText = ccui.Helper:seekWidgetByName(root,"Text_21")
	local levelNeedText = ccui.Helper:seekWidgetByName(root,"Text_222")
	nextAwakenText:setString("")
	nextInfoText:setString("")
	levelNeedText:setString("")
	local ship_name = ""
	if dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type) == 0 then
		name = _ED.user_info.user_name
	else
		name = self.ship.captain_name
	end
	for i=1,4 do
		local propPanel = ccui.Helper:seekWidgetByName(root,"Panel_prop_"..i)
		propPanel:removeAllChildren(true)
		propPanel:setTouchEnabled(false)
		local propImage = ccui.Helper:seekWidgetByName(root,"Image_zhuangbei_"..i)
		propImage:setVisible(false)
		local propImage = ccui.Helper:seekWidgetByName(root,"Image_zhuangbei_"..i)
		local propText = ccui.Helper:seekWidgetByName(root,"Text_props_"..i)
		propText:setVisible(false)
	end
	
	--觉醒装备
	self.awakenLevel = self.ship.awakenLevel -- 觉醒等级
	local start = math.floor(self.awakenLevel/10)
	local level = math.floor(self.awakenLevel%10)
	for i=1,6 do
		local starImage = ccui.Helper:seekWidgetByName(root,"Image_star_"..i .. "_0")
		starImage:setVisible(false)
		if i<= start then 
			starImage:setVisible(true)
		end
	end
	ccui.Helper:seekWidgetByName(root,"Text_star"):setString(""..start .._awaken_tipString_info[1])
	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(root,"Text_lv"):setString(_awaken_tipString_info[2]..level)
	else
		ccui.Helper:seekWidgetByName(root,"Text_lv"):setString(""..level .._awaken_tipString_info[2])
	end

	local shipNameText = ccui.Helper:seekWidgetByName(root,"Text_role_1")
	local shipCountsText = ccui.Helper:seekWidgetByName(root,"Text_role_0")

	local stoneText = ccui.Helper:seekWidgetByName(root,"Text_tupo")
	stoneText:setString("")
	shipNameText:setString("")
	shipCountsText:setString("")

	--消耗材料
	local stonePanel = ccui.Helper:seekWidgetByName(root,"Panel_4")
	stonePanel:removeAllChildren(true)		

	local shipPanel = ccui.Helper:seekWidgetByName(root,"Panel_4_0")
	shipPanel:removeAllChildren(true)
	local stoneCountsText = ccui.Helper:seekWidgetByName(root,"Text_tupo_0")
	stoneCountsText:setString("")
	local requirement = dms.int(dms["ship_mould"], self.shopmould, ship_mould.base_mould2)
	local awakenIndex = 1
	if requirement >= 1 then 
		--可以觉醒
		local grouds = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, requirement)
		if grouds ~= nil then 
	        for i, v in pairs(grouds) do
	            if tonumber(v[3]) == tonumber(self.awakenLevel) then
	                self.awaken_info = v
	                awakenIndex = i
	               break
	            end
	        end
    	end
	 	if self.awaken_info == nil then 
	 		--满级判断
	 		self.awaken_next_info = nil
	 	else
	 		if zstring.tonumber(self.awaken_info[4]) == -1 then 
	 			--满级判断
	 			self.awaken_next_info = nil
	 		else
	 			self.awaken_next_info = grouds[awakenIndex+1]
	 		end
	 	end
	 	
    	if self.awaken_info == nil or self.awaken_next_info == nil then 
    		--满级了
    		local awakenButton = ccui.Helper:seekWidgetByName(root, "Button_1")
    		awakenButton:setTouchEnabled(false)
    		awakenButton:setColor(cc.c3b(150, 150, 150))
    		return
    	end
    	
    	--添加额外属性
    	for i ,v in pairs(grouds) do
    		local infoString = tostring(v[14])
    		if i > awakenIndex and v[14] ~= "-1" then 
    			local start = math.floor(zstring.tonumber(v[3])/10)
				local level = math.floor(zstring.tonumber(v[3])%10)
				ccui.Helper:seekWidgetByName(root,"Text_21"):setString("".._awaken_tipString_info[5]..start .._awaken_tipString_info[1]..level .._awaken_tipString_info[2])
    			ccui.Helper:seekWidgetByName(root,"Text_20"):setString(""..v[14])
    			break
    		end
    	end
    	
		--消耗材料
		local stoneId = zstring.tonumber(self.awaken_info[9])
		if stoneId > 0 then 
			local iconCell = nil
			if __lua_project_id == __lua_project_warship_girl_b then
				iconCell = PropIconCell:createCell()
				iconCell:init(15, stoneId)
			else
				iconCell = PropIconNewCell:createCell()
				iconCell:init(13, stoneId)
			end

			stonePanel:addChild(iconCell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        stoneText:setString(setThePropsIcon(stoneId)[2])
		    else
				stoneText:setString(dms.string(dms["prop_mould"], stoneId, prop_mould.prop_name))
			end
			local totalCount = getPropAllCountByMouldId(stoneId)
			stoneCountsText:setString("" .. totalCount .."/" .. self.awaken_info[10] )
			if zstring.tonumber(totalCount) >= zstring.tonumber(self.awaken_info[10]) then 
				stoneCountsText:setColor(cc.c3b(255, 255, 255))
			else
				stoneCountsText:setColor(cc.c3b(255, 0, 0))
			end
		end
		--武将模型
		local shipCounts = zstring.tonumber(self.awaken_info[11])
		if  shipCounts > 0 then 
			local baseShipId = dms.int(dms["ship_mould"], self.shopmould, ship_mould.base_mould)
			local head = ShipHeadCell:createCell()
			head:init(nil, 5, baseShipId)
			shipPanel:addChild(head)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        --进化形象
		        local evo_image = dms.string(dms["ship_mould"], baseShipId, ship_mould.fitSkillTwo)
		        local evo_info = zstring.split(evo_image, ",")
		        --进化模板id
		        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
		        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], baseShipId, ship_mould.captain_name)]
		        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		        local word_info = dms.element(dms["word_mould"], name_mould_id)
				ship_name = word_info[3]
		        shipNameText:setString(ship_name)
		    else
				shipNameText:setString(dms.string(dms["ship_mould"], baseShipId, ship_mould.captain_name))
			end
			shipCountsText:setString("x" ..shipCounts)
		end
		--消耗金币
		if zstring.tonumber(self.awaken_info[12]) >= 0 then 
			ccui.Helper:seekWidgetByName(root,"Text_1_money"):setString(""..self.awaken_info[12])
		else
			ccui.Helper:seekWidgetByName(root,"Text_1_money"):setString("")
		end
		--需求等级

		levelNeedText:setString(string.format(_awaken_tipString_info[11],""..self.ship.ship_grade ,"".. self.awaken_info[4]))
		
    	local propStates =  zstring.split("" ..self.ship.awakenstates , ",")
    	self.awakenPropNum = 0
    	for i=1,4 do
    		local propPanel = ccui.Helper:seekWidgetByName(root,"Panel_prop_"..i)
    		local propImage = ccui.Helper:seekWidgetByName(root,"Image_zhuangbei_"..i)
    		local propText = ccui.Helper:seekWidgetByName(root,"Text_props_"..i)
    		local propId = zstring.tonumber(self.awaken_info[i+4])
    		if propId > 0 then 
    			self.awakenPropNum = self.awakenPropNum + 1
    			local iconCell = nil
				if __lua_project_id == __lua_project_warship_girl_b then
					iconCell = PropIconCell:createCell()
					iconCell:init(15, propId)
				else
					iconCell = PropIconNewCell:createCell()
					iconCell:init(13, propId)
				end
				propPanel:addChild(iconCell)
				if zstring.tonumber(propStates[i]) == 0 then 
					-- 没有装备
					local propNum = zstring.tonumber(getPropAllCountByMouldId(propId))
					if propNum == 0 then 
						--无装备去获取
						iconCell.roots[1]:setColor(cc.c3b(50, 50, 50))
						propPanel:setTouchEnabled(true)
						fwin:addTouchEventListener(propPanel, nil,
						{
							terminal_name = "hero_awaken_page_props_click", 
							equip = propId,
							drawIndex = i,
							showType = 2
						}, nil, 0)
						propText:setVisible(true)
					else
						iconCell.roots[1]:setColor(cc.c3b(50, 50, 50))
						propImage:setVisible(true)
						propPanel:setTouchEnabled(true)
						fwin:addTouchEventListener(propPanel, nil,
						{
							terminal_name = "hero_awaken_page_props_click", 
							equip = propId,
							drawIndex = i,
							showType = 1

						}, nil, 0)
					end
				else
					--已经装备上去了，此道具为消耗
					propImage:setVisible(false)
					propPanel:setTouchEnabled(true)
					fwin:addTouchEventListener(propPanel, nil,
					{
						terminal_name = "hero_awaken_page_props_click", 
						equip = propId,
						drawIndex = i,
						showType = 4

					}, nil, 0)
				end
    		end
    	end
	end
end

--播放觉醒动画
function HeroAwakenPage:playAwakenAction()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local num = self.awakenPropNum - 1
	self.ArmatureNodePanel:setVisible(true)
	self.ArmatureNode_1:setVisible(true)
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_1, num, num, false)
    self.ArmatureNode_1._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            self.ArmatureNodePanel:setVisible(false)
            armatureBack:setVisible(false)
            self:showPropertyChangeTipInfo()
            self:onUpdateDraw()
        end
    end 
end

--穿着成功后添加动画
function HeroAwakenPage:playWearPropAction(textData)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self:showPropertyChangeTipInfo(textData)
end

function HeroAwakenPage:showPropertyChangeTipInfo(textData)
	
	app.load("client.cells.utils.property_change_tip_info_cell") 
	local tipInfoWindow = PropertyChangeTipInfoAnimationCell:createCell()
	if textData == nil then 
		--播放觉醒动画
		local temp_ship = fundShipWidthId(self.shipId)
		
		local add_info = {}
		add_info[1] = temp_ship.ship_health
		add_info[2] = temp_ship.ship_courage
		add_info[3] = temp_ship.ship_intellect
		add_info[4] = temp_ship.ship_quick
		local textData = {}
		for i=1,4 do
			local diff = zstring.tonumber(add_info[i]) - zstring.tonumber(self._advancedBefore[i])
			if diff > 0 then
				table.insert(textData, {property = _equiprety_name[i], value = diff})
			end
		end
	
		tipInfoWindow:init(2,_awaken_tipString_info[6], textData)	
		fwin:open(tipInfoWindow, fwin._ui)

	else
		--播放穿着动画
		local propData = {}
		local initialValue = zstring.split(""..textData,"|")
		for i,v in pairs(initialValue) do
			local influenceType = zstring.split("".. v,",")		--每一种属性
			if table.getn(influenceType) >= 2 then 
				local index = zstring.tonumber(influenceType[1]) + 1
				table.insert(propData, {property = _equiprety_name[index], value = influenceType[2]})
			end
		end
		tipInfoWindow:init(2,_awaken_tipString_info[12], propData)	
		fwin:open(tipInfoWindow, fwin._ui)
	end

end

function HeroAwakenPage:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_juexing.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
	
	--ccui.Helper:seekWidgetByName(root,"Image_34"):setTouchEnabled(true)

	local propBowseButton = ccui.Helper:seekWidgetByName(root, "Button_33")
	self.ArmatureNodePanel = ccui.Helper:seekWidgetByName(root, "Panel_Armature")
	self.ArmatureNode_1 = self.ArmatureNodePanel:getChildByName("ArmatureNode_1") -- 觉醒动画
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
    self.ArmatureNodePanel:setVisible(false)

	fwin:addTouchEventListener(propBowseButton, nil, 
	{
		terminal_name = "hero_awaken_page_props_browse", 
		shipId = self.shipId
	}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_32"), nil,
	{
		terminal_name = "hero_awaken_page_shop", 
		shipId = self.shipId
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "hero_awaken_page_shop_awaken", 
		shipId = self.shipId
	}, nil, 0)


	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zr_back"), nil,
		{
			 func_string = [[fwin:close(fwin:find("HeroAwakenPageClass"))]],   
			shipId = self.shipId
		}, nil, 0)

	else
		if self.types == "formation" then
			app.load("client.player.UserInformationHeroStorage")
			local seq = fwin:find("UserInformationHeroStorageClass")
			if seq == nil then
				fwin:open(UserInformationHeroStorage:new(), fwin._ui)
			end
			state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
		end
		if fwin:find("UserInformationHeroStorageClass") == nil then
			if fwin:find("HeroFormationChoiceWearClass") ~= nil then
				fwin:open(UserInformationHeroStorage:new(), fwin._ui)
			end
		end
	end
	
	self:onUpdateDraw()
end

function HeroAwakenPage:close()
	
end

function HeroAwakenPage:onExit()
	state_machine.remove("hero_awaken_page_shop_awaken")
	state_machine.remove("hero_awaken_page_shop")
	state_machine.remove("hero_awaken_page_props_browse")

	if self.types == "formation" then
		local seq = fwin:find("UserInformationHeroStorageClass")
		if seq ~= nil then
			fwin:close(seq)
		end
		
	end
	if fwin:find("UserInformationHeroStorageClass") ~= nil then
		if fwin:find("HeroFormationChoiceWearClass") ~= nil then
			fwin:close(fwin:find("UserInformationHeroStorageClass"))
		end
	end
	
end

function HeroAwakenPage:init(shipId, types)
	self.shipId = shipId
	self.shopmould = fundShipWidthId(self.shipId).ship_template_id
	self.types = types
end