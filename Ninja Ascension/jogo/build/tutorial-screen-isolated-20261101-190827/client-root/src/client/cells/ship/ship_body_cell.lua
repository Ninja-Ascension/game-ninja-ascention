----------------------------------------------------------------------------------------------------
-- 说明：武将的全身图绘制
-------------------------------------------------------------------------------------------------------
ShipBodyCell = class("ShipBodyCellClass", Window)

function ShipBodyCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = nil
	self.current_type = 0
	self.enum_type = {
		_SHOW_SHIP_INFORMATION = 1,				-- 进入武将信息界面
		_GOTO_FORMATION_INTERFACE = 2,			-- 进入阵容界面
		_INTO_ARENE_FIGHT = 3,					-- 进入竞技场战斗
		_HERO_STRENGTHEN  = 4,					-- 绘制升级武将里的升级元素
		_SHIP_FORMATION_HERO = 5				-- 武将信息界面的翻页绘制页
	}
	self.ship = nil		-- 当前要绘制的战船实现数据对对象
	self.ships = nil	-- 升级界面要用到的一键获取的五个船实例
	self.num = nil
	self._ship = nil
	self._picIndex = nil 
	self.shipMID = nil --当前要显示的模板id
	self._lastStatus = nil
	self._equip = nil 
	-- 初始化武将全身像事件响应需要使用的状态机
	local function init_ship_body_cell_terminal()
		
		-- 设计在阵容界面，点击武将全身图像需要处理的逻辑
		local ship_body_cell_show_ship_information_terminal = {
            _name = "ship_body_cell_show_ship_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击武将全身图像后的响应逻辑
				if not self.stopFormationEvent then
					local ship = params._datas._ship
					state_machine.excute("open_formation_head_info", 0, ship)
					if ship~=nil then
						if ship == -4 then 
							--查看宠物
							app.load("client.packs.pet.PetInformation")
							local ship = _ED.user_ship["" .. _ED.formation_pet_id]
							state_machine.excute("pet_information_open_window", 0, {ship,2})
						else
							app.load("client.formation.FormationSeeHeroIn")
							local heroInfo = FormationSeeHeroIn:new()
							heroInfo:init(ship)
							fwin:open(heroInfo, fwin._ui) 
						end
						
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 设计在阵容界面，点击无图像需要处理的逻辑
		local ship_body_cell_add_action_ship_information_terminal = {
            _name = "ship_body_cell_add_action_ship_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击武将全身图像后的响应逻辑
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
					local addIndex = -1
					for i=2, 7 do
						if zstring.tonumber(_ED.formetion[i]) == 0 then
							addIndex = i - 1
							break
						end
					end
					if not self.stopFormationEvent then
						-- local openLevels = {}
						-- openLevels = dms.searchs(dms["user_experience_param"], user_experience_param.battle_unit, addIndex+1)
						state_machine.excute("open_add_ship_window", 0, {_index = addIndex, _type = 1, _shipId = -1})
					end
				else
					if not self.stopFormationEvent then
						state_machine.excute("open_add_ship_window", 0, params._datas._data)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 设计在时装界面，点击武将全身图像需要处理的逻辑
		local ship_body_cell_show_fashion_information_terminal = {
            _name = "ship_body_cell_show_fashion_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.packs.fashion.FashionInformation")
            	state_machine.excute("fashion_information_open", 0, params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(ship_body_cell_show_ship_information_terminal)	
		state_machine.add(ship_body_cell_add_action_ship_information_terminal)	
		state_machine.add(ship_body_cell_show_fashion_information_terminal)	
        state_machine.init()
	end
	init_ship_body_cell_terminal()
end

function ShipBodyCell:setStopFormationEvent(isStop)
	--> print("ShipBodyCell:setStopFormationEvent------------------------------", isStop)
	self.stopFormationEvent = isStop
end

function ShipBodyCell:onUpdateDraw()
	local root = self.roots[1]
	local shipImage = nil
	local shippanel = nil

	if nil ~= self.shipMID then
		--local action = csb.createTimeline("card/card_role.csb")
		-- root:runAction(action)
		-- action:gotoFrameAndPlay(0, action:getDuration(), true)
		
		shippanel = ccui.Helper:seekWidgetByName(root, "Panel_card_role")
		shipImage = ccui.Helper:seekWidgetByName(root, "Panel_dh")
		local picIndex = dms.int(dms["ship_mould"], self.shipMID, ship_mould.All_icon)
		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			if dms.int(dms["ship_mould"], tonumber(self.shipMID), ship_mould.captain_type) == 0 then
				local fashionEquip, pic = getUserFashion()
				if fashionEquip ~= nil and pic ~= nil then
					picIndex = pic
				end
			end
		end
		shipImage:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
		--shippanel:setPosition(cc.p((fwin._width-shippanel:getContentSize().width)/2, shippanel:getPositionY()))
		shipImage:setVisible(true)
		shippanel:setVisible(true)
	elseif self._picIndex ~= nil then
		shipImage = ccui.Helper:seekWidgetByName(root, "Panel_14")
		shipImage:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self._picIndex))
	else
		if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
			if __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge  
				then 
				shipImage = ccui.Helper:seekWidgetByName(root, "Panel_image") 
				shippanel = ccui.Helper:seekWidgetByName(root, "Panel_spine")	--spine动画
			else
				shipImage = ccui.Helper:seekWidgetByName(root, "Panel_dh")
				shippanel = ccui.Helper:seekWidgetByName(root, "Panel_card_role")	
			end
		else
			if __lua_project_id == __lua_project_yugioh  
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
			 	then 
				shipImage = ccui.Helper:seekWidgetByName(root, "Panel_image") 
				shippanel = ccui.Helper:seekWidgetByName(root, "Panel_spine")	--spine动画
			else
				shipImage = ccui.Helper:seekWidgetByName(root, "Panel_14")
			end
		end
	
	
		if self.ship ~= nil then
			local picIndex = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.All_icon)
			local spIndex = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.movement)
			local isPet = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.captain_type) == 3 
			if __lua_project_id == __lua_project_warship_girl_a 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				then
				if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then
					local isGetAni = false
					if __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_yugioh 
						then
						isGetAni = true
					else
						isGetAni = false
					end
					local fashionEquip, pic = getUserFashion(isGetAni)
					if fashionEquip ~= nil and pic ~= nil then
						picIndex = pic
						spIndex = picIndex
					end
				end
			end
				
			if __lua_project_id == __lua_project_yugioh
				or __lua_project_id == __lua_project_pokemon 
				then
				app.load("client.battle.fight.FightEnum")
				shippanel:removeAllChildren(true)
				if spIndex > 0 then 
					local jsonFile = ""
		            local atlasFile = ""
		            if __lua_project_id == __lua_project_yugioh then
			            atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", spIndex)
						jsonFile = string.format("sprite/spirte_battle_card_%s.json", spIndex)
					else
						atlasFile = string.format("sprite/big_head_%s.atlas", spIndex)
						jsonFile = string.format("sprite/big_head_%s.json", spIndex)
					end
		            local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
                		spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)
		            shippanel:addChild(spArmature)
		            spArmature:setPosition(cc.p(shippanel:getContentSize().width/2, 0))
				else
					shipImage:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
					if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then 
						local action = csb.createTimeline("card/card_hero_1.csb")
						root:runAction(action)
						action:play("role_dh", true)
					end
				end
			else
				if isPet then 
					if spIndex > 0 then 
						--需要调用SPINE动画
						shipImage = ccui.Helper:seekWidgetByName(root, "Panel_spine") 
						shipImage:removeAllChildren(true)
						shipImage:removeBackGroundImage()
						app.load("client.battle.fight.FightEnum")
						local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", spIndex)
						local jsonFile = string.format("sprite/spirte_battle_card_%s.json", spIndex)
						local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
                		spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)
		            	shipImage:addChild(spArmature)
		            	spArmature:setPosition(cc.p(shipImage:getContentSize().width/2, 0))
					else
						shipImage:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
					end
				else
					shipImage:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
				end
			end
			
			if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
				if tonumber(self.ship.captain_type) ~= 0 then
					local camp_preference = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.camp_preference)
					if camp_preference > 0 then
						local Panel_zhenying = ccui.Helper:seekWidgetByName(root, "Panel_zhenying")
						if Panel_zhenying ~= nil then
							Panel_zhenying:setBackGroundImage(string.format("images/ui/quality/leixing_%d.png", camp_preference))
						end
					end
				end
				
				-- local capacity = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.capacity)
				-- ccui.Helper:seekWidgetByName(root, "Panel_shuxin"):setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", capacity))
			end
		else
			--shipImage:setBackGroundImage(string.format("images/face/big_head/unopened.png", 0))

		
			local csbshipImage = csb.createNode("formation/line_up_xuanzejuese.csb")
			local csbshipImage_root = csbshipImage:getChildByName("root")
			shipImage:addChild(csbshipImage)
			
			-- local openLevel = {}
			-- for i=1, 6 do
				-- openLevel[i] =  dms.string(dms["open_formation_grid_param"], i, open_formation_grid_param.open_need_level)
			-- end
			
			-- table.sort(openLevel, function(a, b)
				-- return a < b
			-- end)
			local openLevel = {}
			openLevel = dms.searchs(dms["user_experience_param"], user_experience_param.battle_unit, self.num)
			-- ccui.Helper:seekWidgetByName(root, "Text_1"):setString(openLevel[1][2])

			if tonumber(self._ship) == -2 then
				ccui.Helper:seekWidgetByName(csbshipImage_root, "Text_kaiqi"):setString(openLevel[1][2])
				local Panel_jikaiqi=ccui.Helper:seekWidgetByName(csbshipImage_root,"Panel_jikaiqi")
				Panel_jikaiqi:setVisible(true)
			elseif tonumber(self._ship) == -1 then
				local Image_keshangzhen = ccui.Helper:seekWidgetByName(csbshipImage_root, "Image_keshangzhen")
				Image_keshangzhen:setVisible(true)
				local Image_2 = ccui.Helper:seekWidgetByName(csbshipImage_root, "Image_2")
				if Image_2 ~= nil then 
					Image_2:setVisible(false)
				end
			elseif tonumber(self._ship) == -6 then
				local Image_keshangzhen = ccui.Helper:seekWidgetByName(csbshipImage_root, "Image_keshangzhen")
				local Image_1 = ccui.Helper:seekWidgetByName(csbshipImage_root, "Image_1")
				Image_1:setVisible(false)
				local Image_2 = ccui.Helper:seekWidgetByName(csbshipImage_root, "Image_2")
				if Image_2 ~= nil then 
					Image_2:setVisible(true)
				end
			end
		end
		
		if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
			if __lua_project_id == __lua_project_yugioh  
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then 
				shipImage:setSwallowTouches(true)
				ccui.Helper:seekWidgetByName(root, "Panel_image"):setSwallowTouches(true)	
			else
				shipImage:setSwallowTouches(true)
				ccui.Helper:seekWidgetByName(root, "Panel_role"):setSwallowTouches(true)	
			end
			
		else
			shipImage:setSwallowTouches(true)
		end

		if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
			if __lua_project_id == __lua_project_yugioh  
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then 
			else
				ccui.Helper:seekWidgetByName(root, "Panel_pve"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_name"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
				shippanel:setPosition(cc.p((fwin._width-shippanel:getContentSize().width)/2, shippanel:getPositionY()))
			end
			
		end
		if self.current_type == self.enum_type._SHIP_FORMATION_HERO then
			if __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then 
			else
				shipImage:setPosition(cc.p((fwin._width-shipImage:getContentSize().width), shipImage:getPositionY()))
			end
			
		end
	end
end


function ShipBodyCell:onEnterTransitionFinish()

end

function ShipBodyCell:onInit()
	local csbItem = nil
	
	-- 实在搞不懂这些if了,就干脆把其他的全放 else里,不碰它们
	if nil ~= self.shipMID then
		csbItem = csb.createNode("card/card_role.csb")
		local root = csbItem:getChildByName("root")
		root:removeFromParent(false)
		self:addChild(root)
		table.insert(self.roots, root)
		
		ccui.Helper:seekWidgetByName(root, "Panel_pve"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_name"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
		
		local action = csb.createTimeline("card/card_role.csb")
		root:runAction(action)
		self.actions = action
		-- action:gotoFrameAndPlay(0, action:getDuration(), true)
		action:play("Panel_role_dt", true)
		
		self:onUpdateDraw()
		-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
  --   	cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
  	elseif self._picIndex ~= nil then  -- 用于时装界面
  		csbItem = csb.createNode("card/card_hero.csb")
		local root = csbItem:getChildByName("root")
		root:removeFromParent(false)
		self:addChild(root)
		table.insert(self.roots, root)
		
		
		local action = csb.createTimeline("card/card_hero.csb")

		root:runAction(action)
		self.actions = action
		-- action:gotoFrameAndPlay(0, action:getDuration(), true)
		action:play("role_dh", true)
		-- ccui.Helper:seekWidgetByName(root, "Panel_14")
		self:onUpdateDraw()
		-- Panel_14
		
		if self._equip ~= nil then
			ccui.Helper:seekWidgetByName(root, "Panel_role_xy"):setVisible(true)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role_xy"), nil, 
			{
			    terminal_name = "ship_body_cell_show_fashion_information", 
			    terminal_state = 0,
			    _cell = self,
			    _equip = self._equip,
			    isPressedActionEnabled = false
			}, 
			nil, 0)
		else
			ccui.Helper:seekWidgetByName(root, "Panel_14"):setTouchEnabled(false)
		end
	else
	
		if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
			csbItem = csb.createNode("card/card_role.csb")
			
		else
			csbItem = csb.createNode("card/card_hero.csb")
			
		end
		if __lua_project_id == __lua_project_yugioh  
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then 
			--游戏王用
			csbItem = csb.createNode("card/card_hero_1.csb")
		end
		local root = csbItem:getChildByName("root")
		root:removeFromParent(false)
		self:addChild(root)
		table.insert(self.roots, root)
	
		if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION  then
			if __lua_project_id == __lua_project_yugioh  
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then 
			else
				local action = csb.createTimeline("card/card_role.csb")
				root:runAction(action)
				self.actions = action
				-- action:gotoFrameAndPlay(0, action:getDuration(), true)
				action:play("Panel_role_dt", true)
			end
			
		end
			
		self:onUpdateDraw()
		-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
  --   	cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)

		if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
			if self.ship ~= nil then
				if __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					then 
					local PanelImage = ccui.Helper:seekWidgetByName(root, "Panel_image")
					PanelImage:setTouchEnabled(true)
					fwin:addTouchEventListener(PanelImage, nil, {terminal_name = "ship_body_cell_show_ship_information", terminal_state = 0, _ship = self.ship}, nil, 0)
				else
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_dh"), nil, {terminal_name = "ship_body_cell_show_ship_information", terminal_state = 0, _ship = self.ship}, nil, 0)
				end
				
			else
				fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_dh"), nil, {terminal_name = "ship_body_cell_add_action_ship_information", terminal_state = 0, _ship = self.ship}, nil, 0)
			end
			-- local action = csb.createTimeline("card/card_role.csb")
			-- csbFormation:runAction(action)
			-- action:gotoFrameAndPlay(0, action:getDuration(), false)
		else
			--> debug.log(true, "error")
		end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			
			-- local openLevels = {}
			-- openLevels = dms.searchs(dms["user_experience_param"], user_experience_param.battle_unit, addIndex+1)
			-- ccui.Helper:seekWidgetByName(root, "Text_1"):setString(openLevel[1][2])
			if self.ship ~= nil then
				-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role"), nil, {terminal_name = "ship_body_cell_show_ship_information", terminal_state = 0, _ship = self.ship}, nil, 0)
			else
				if self._lastStatus == 2 then
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role"), nil, {terminal_name = "ship_body_cell_add_action_ship_information", terminal_state = 0, _ship = self.ship}, nil, 0)
				end
			end
	
		end
	end
	
end

function ShipBodyCell:onExit()
	-- -- state_machine.remove("ship_body_cell_show_ship_information")
	-- state_machine.remove("ship_body_cell_add_action_ship_information")
end

--self.ship,1,nil,self.moveLayer._current_cell._index,self.moveLayer._current_cell._ship,self._lastStatus)
function ShipBodyCell:init(ship, interfaceType, ships,num,_ship,_lastStatus)
	if ship~=nil then
		self.ship = ship
	end
	if ships~=nil then
		self.ships = ships
	end
	if num~=nil then
		self.num = num
	end
	if _ship~=nil then
		self._ship = _ship
	end
	self.current_type = interfaceType
	if _lastStatus ~= nil then
		self._lastStatus = _lastStatus
	end

	self:onInit()
end

-- 看不懂 init里的各种神奇参数,另写个初始化参数接口,只传ship模板id
function ShipBodyCell:initShipMID(shipMID,picIndex,equip)
	self.shipMID = shipMID 
	self._picIndex =picIndex
	self._equip = equip
	self:onInit()
end

function ShipBodyCell:createCell()
	local cell = ShipBodyCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

