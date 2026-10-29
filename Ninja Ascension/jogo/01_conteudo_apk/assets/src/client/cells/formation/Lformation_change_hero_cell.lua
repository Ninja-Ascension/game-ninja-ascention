----------------------------------------------------------------------------------------------------
-- 说明：；龙虎门布阵界面武将控件
-------------------------------------------------------------------------------------------------------
LformationChangeHeroCell = class("LformationChangeHeroCell", Window)

function LformationChangeHeroCell:ctor()
    self.super:ctor()
	self.ship = nil
	self.index = nil
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.play_index = 0
	self.enum_type = {
		_FORMATION_CHANGE_SHIP_PAGE_VIEW = 1,
		_HERO_ADVANCE_SUCCESS = 2
	}
	self.armature_effic = nil
	self.normal_armature_effic = nil
	self.animation_index = nil
	self.effic_id = nil
	self.normal_effic_id = nil
	self.armature_hero = nil
	local function init_Lformation_ship_cell_terminal()
		local Lformation_ship_cell_show_ship_information_terminal = {
            _name = "Lformation_ship_cell_show_ship_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击武将全身图像后的响应逻辑
				if not self.stopFormationEvent then
					local ship = params._datas._ship
					if ship~=nil then
						app.load("client.formation.HeroInformation")
						local ship = params._datas._ship
						-- local heroInfo = HeroInformation:new()
						-- heroInfo:init(ship)
						-- fwin:open(heroInfo, fwin._ui) 
						state_machine.excute("hero_information_open_window", 0, ship)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local Lformation_ship_cell_add_action_ship_information_terminal = {
            _name = "Lformation_ship_cell_add_action_ship_information",
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
		
		local Lformation_ship_cell_play_hero_animation_terminal = {
            _name = "Lformation_ship_cell_play_hero_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local play_type = params[1]
            	local cell = params[2]
            	if cell == nil then
            		if instance ~= nil and instance.changeHeroAnimation ~= nil then
            			instance:changeHeroAnimation(play_type)
            		end
            	else
            		cell:changeHeroAnimation(play_type)
            	end
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放攻击动画
        local Lformation_ship_cell_play_hero_animation_two_terminal = {
            _name = "Lformation_ship_cell_play_hero_animation_two",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local play_type = params[1]
            	local cell = params[2]
            	if cell ~= nil then
	                if instance ~= nil then
	                    instance:changeHeroAnimationTwo(play_type,cell)
	                end
	            end
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(Lformation_ship_cell_show_ship_information_terminal)	
		state_machine.add(Lformation_ship_cell_add_action_ship_information_terminal)	
		state_machine.add(Lformation_ship_cell_play_hero_animation_terminal)	
		state_machine.add(Lformation_ship_cell_play_hero_animation_two_terminal)	
		
		state_machine.init()
	end
	init_Lformation_ship_cell_terminal()
end
function LformationChangeHeroCell:changeHeroAnimation(play_type)
	if play_type == "begin" then
		self.play_index = 14 
	else
		self.play_index = tonumber(play_type)
	end
	if self.armature_hero == nil then
		return
	end

	-- print("==============",self.play_index,self.armature_effic)
	if self.armature_effic ~= nil and self.play_index == self.animation_index then
		-- print("=================================播放")
		self.armature_effic:setVisible(true)

		csb.animationChangeToAction(self.armature_effic, 0,0, false)
	end	

	if self.normal_armature_effic ~= nil and self.play_index == 14 then
		self.normal_armature_effic:setVisible(true)
		csb.animationChangeToAction(self.normal_armature_effic, 0,0, false)
	end

	csb.animationChangeToAction(self.armature_hero, self.play_index, self.play_index, false)


end

function LformationChangeHeroCell:changeHeroAnimationTwo(play_types,cell)
    -- self.play_types = play_types
    csb.animationChangeToAction(cell.m_spine_sprites, play_types, play_types, false)
end

function LformationChangeHeroCell:onEnterTransitionFinish()


end

function LformationChangeHeroCell:getSkillAnimationIndex()
	if self.ship == nil then
		return
	end
	if tonumber(self.ship.captain_type) ~= 0 then
		return 15
	end	
	for j,k in pairs(_ED.user_ship) do
		if tonumber(k.captain_type) == 0 then
			--学艺技能
			for i , v in pairs(_ED.user_skill_equipment) do
			   if tonumber(v.equip_state) == 1 then
			   		local skillEquipment = dms.element(dms["skill_equipment_mould"],v.skill_equipment_base_mould)
			   		local skill_mould_id = dms.atoi(skillEquipment,skill_equipment_mould.skill_equipment_base_mould)
			   		local health_affects = dms.string(dms["skill_mould"],skill_mould_id,skill_mould.health_affect)
			   		-- print("============",health_affects)
			   		local health_affect = zstring.split(health_affects, ",")
			   		-- print("============",health_affect)
			   		local skill_influenceID = tonumber(health_affect[1])
			   		local after_actions = dms.int(dms["skill_influence"],skill_influenceID,skill_influence.after_action)
			   		local effic_id = dms.int(dms["skill_influence"],skill_influenceID,skill_influence.posterior_lighting_effect_id)
			   		-- print("===========",after_actions)
			   		if after_actions == nil then
			   			return 15 
			   		else
			   			return after_actions ,effic_id
			   		end
			   end
			end
		end
	end

end
function LformationChangeHeroCell:onInit()
	local filePath = "formation/FormationChange_role.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	-- Panel_buzhen_role
	local Panel_buzhen_role = ccui.Helper:seekWidgetByName(root, "Panel_buzhen_role")
	local Panel_line_role = ccui.Helper:seekWidgetByName(root, "Panel_line_role")
	if self.current_type == self.enum_type._FORMATION_CHANGE_SHIP_PAGE_VIEW then
		if self.ship~=nil and self.ship~="" then
			Panel_line_role:setVisible(true)
			Panel_buzhen_role:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_line_role_add"):setVisible(false)
			local temp_bust_index = 0
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				----------------------新的数码的形象------------------------
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(self.ship.evolution_status, "|")
				local evo_mould_id = smGetSkinEvoIdChange(self.ship)
				if zstring.tonumber(self.ship.skin_id) ~= 0 then
			    	evo_mould_id = dms.int(dms["ship_skin_mould"], self.ship.skin_id, ship_skin_mould.ship_evo_id)
			    end
				--新的形象编号
				temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				
			else
				temp_bust_index = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.bust_index)
			end

			-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
			-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
			-- cell:getAnimation():playWithIndex(0)
			-- Panel_line_role:addChild(cell)
			-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
			-- cell:setPosition(cc.p(Panel_line_role:getContentSize().width/2, 0))

			local shipPanel = Panel_line_role
			-- shipPanel:removeAllChildren(true)
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
			if animationMode == 1 then
				app.load("client.battle.fight.FightEnum")
				local armature_hero = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_l_frame_index.animation_standby], true, nil, nil, cc.p(0.5, 0))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        armature_hero:setScaleX(-1)
			    end
				self.armature_hero = armature_hero
				armature_hero.animationNameList = spineAnimations
				sp.initArmature(self.armature_hero, true)
			    local function changeActionCallback( armatureBack )	
					if self.play_index == 14 then
						if self ~= nil and self.roots ~= nil then
							state_machine.excute("Lformation_ship_cell_play_hero_animation",0,{self.animation_index,self})
						end
					elseif self.play_index == self.animation_index then
						if self ~= nil and self.roots ~= nil then
							state_machine.excute("Lformation_ship_cell_play_hero_animation",0,{0,self})
						end
					end	
			    end
			    armature_hero._invoke = changeActionCallback
			    armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
			    csb.animationChangeToAction(self.armature_hero, 0, 0, false)


			    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			    	if self.effic_id ~= nil then
						local armature_effic = sp.spine_effect(self.effic_id, effectAnimations[1], false, nil, nil, nil)	
						self.armature_effic = armature_effic
						sp.initArmature(self.armature_effic, false)
						armature_effic.animationNameList = effectAnimations
						self.armature_effic:setVisible(false)
						armature_hero:addChild(armature_effic)
					    local function changeActionEfficCallback( armatureBack )	
							armatureBack:setVisible(false)
					    end
					    armature_effic._invoke = changeActionEfficCallback
					    armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)			    		
			    	end

			    	if self.normal_effic_id ~= nil then
						local normal_armature_effic = sp.spine_effect(self.normal_effic_id, effectAnimations[1], false, nil, nil, nil)	
						self.normal_armature_effic = normal_armature_effic
						sp.initArmature(self.normal_armature_effic, false)
						normal_armature_effic.animationNameList = effectAnimations
						self.normal_armature_effic:setVisible(false)
						armature_hero:addChild(normal_armature_effic)
					    local function changeActionEfficCallback( armatureBack )	
							armatureBack:setVisible(false)
					    end
					    normal_armature_effic._invoke = changeActionEfficCallback
					    normal_armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)	
			    	end
			    end
			else
				draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
			end

			fwin:addTouchEventListener(Panel_line_role, nil, {terminal_name = "Lformation_ship_cell_show_ship_information", terminal_state = 0, _ship = self.ship}, nil, 0)
		else
			Panel_line_role:setVisible(false)
			Panel_buzhen_role:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_line_role_add"):setVisible(true)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_line_role_add"), nil, {terminal_name = "Lformation_ship_cell_add_action_ship_information", terminal_state = 0, _ship = self.ship}, nil, 0)
		end
	elseif self.current_type == self.enum_type._HERO_ADVANCE_SUCCESS then
		local temp_bust_index = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			----------------------新的数码的形象------------------------
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = smGetSkinEvoIdChange(self.ship)
			if zstring.tonumber(self.ship.skin_id) ~= 0 then
		    	evo_mould_id = dms.int(dms["ship_skin_mould"], self.ship.skin_id, ship_skin_mould.ship_evo_id)
		    end
			--新的形象编号
			temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
		else
			temp_bust_index = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.bust_index)
		end
		-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
		-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
		-- cell:getAnimation():playWithIndex(0)
		-- Panel_buzhen_role:addChild(cell)
		-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
		-- -- cell:setPosition(cc.p(Panel_buzhen_role:getContentSize().width/2, Panel_buzhen_role:getContentSize().height/2))
		-- cell:setPosition(cc.p(Panel_buzhen_role:getContentSize().width/2, 0))

		local shipPanel = Panel_buzhen_role
		-- shipPanel:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        shipSpine:setScaleX(-1)
		    end
		else
			draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
		end

		Panel_buzhen_role:setTouchEnabled(false)
		self:setTouchEnabled(false)
	else
		local temp_bust_index = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			----------------------新的数码的形象------------------------
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = smGetSkinEvoIdChange(self.ship)
			if zstring.tonumber(self.ship.skin_id) ~= 0 then
		    	evo_mould_id = dms.int(dms["ship_skin_mould"], self.ship.skin_id, ship_skin_mould.ship_evo_id)
		    end
			--新的形象编号
			temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

			local Panel_45 = ccui.Helper:seekWidgetByName(root, "Panel_45")
			if Panel_45 ~= nil then
				Panel_45:setVisible(false)
				if zstring.tonumber(self.formationType) == 2 then
				    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				    local word_info = dms.element(dms["word_mould"], name_mould_id)
				    local name = word_info[3]
				    if getShipNameOrder(tonumber(self.ship.Order)) > 0 then
				        name = name.." +"..getShipNameOrder(tonumber(self.ship.Order))
				    end
				    local quality = shipOrEquipSetColour(tonumber(self.ship.Order))
				    local color_R = tipStringInfo_quality_color_Type[quality][1]
				    local color_G = tipStringInfo_quality_color_Type[quality][2]
				    local color_B = tipStringInfo_quality_color_Type[quality][3]

					local Text_name_1 = ccui.Helper:seekWidgetByName(root, "Text_name_1")
					local Text_lv_1 = ccui.Helper:seekWidgetByName(root, "Text_lv_1")
					local Text_power_1 = ccui.Helper:seekWidgetByName(root, "Text_power_1")
				    Text_name_1:setString(name)
				    Text_name_1:setColor(cc.c3b(color_R, color_G, color_B))
					Text_lv_1:setString(self.ship.ship_grade)
					Text_power_1:setString(self.ship.hero_fight)
				end
			end
		else
			temp_bust_index = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.bust_index)
		end
		-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
		-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
		-- cell:getAnimation():playWithIndex(0)
		-- Panel_buzhen_role:addChild(cell)
		-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
		-- -- cell:setPosition(cc.p(Panel_buzhen_role:getContentSize().width/2, Panel_buzhen_role:getContentSize().height/2))
		-- cell:setPosition(cc.p(Panel_buzhen_role:getContentSize().width/2, 0))

		local shipPanel = Panel_buzhen_role
		-- shipPanel:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			local m_spine_sprites = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				m_spine_sprites:setScaleX(-1)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					m_spine_sprites.animationNameList = spineAnimations
				    sp.initArmature(m_spine_sprites, true)
				    m_spine_sprites._self = self
				    m_spine_sprites:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
				    csb.animationChangeToAction(m_spine_sprites, 0, 0, false)
					if m_spine_sprites._x == nil then
				    	m_spine_sprites._x = m_spine_sprites:getPositionX()
				    end
				    m_spine_sprites:setPositionX(m_spine_sprites._x-800)
				    self.m_spine_sprites = m_spine_sprites
				    state_machine.excute("Lformation_ship_cell_play_hero_animation_two",0,{1,self})
				    local function playOver()
		               	state_machine.excute("Lformation_ship_cell_play_hero_animation_two",0,{0,self}) 
		               --画光圈
						local camp_preference = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.camp_preference)
						local animation_name = ""
						if camp_preference == 1 then    		--攻击
							animation_name = "type_1"
						elseif camp_preference == 2 then 		--防御
							animation_name = "type_2"
						elseif camp_preference == 3 then 		--技能
							animation_name = "type_3"
						end
						local jsonFile = "sprite/spirte_type_di.json"
					    local atlasFile = "sprite/spirte_type_di.atlas"
					    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
					    animation2:setPosition(cc.p(Panel_buzhen_role:getContentSize().width/2,0))
					    animation2:setTag(999)
					    Panel_buzhen_role:addChild(animation2, -1)
					    showShipTypeImage(Panel_buzhen_role,camp_preference)

					    if self.roots ~= nil and self.roots[1] ~= nil then
						    local Panel_45 = ccui.Helper:seekWidgetByName(root, "Panel_45")
							if Panel_45 ~= nil then
				    			if zstring.tonumber(self.formationType) == 2 then
									Panel_45:setVisible(true)
								end
							end
						end
		            end
				    self.m_spine_sprites:runAction(cc.Sequence:create(cc.MoveTo:create(0.8, cc.p(m_spine_sprites._x, 0)),cc.CallFunc:create(playOver)))
				end
			end
		else
			draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
		end

		Panel_buzhen_role:setTouchEnabled(false)
		Panel_line_role:setTouchEnabled(false)
		self:setTouchEnabled(true)
		if __lua_project_id == __lua_project_l_naruto then
			--画光圈
			local camp_preference = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.camp_preference)
			local animation_name = ""
			if camp_preference == 1 then    		--攻击
				animation_name = "type_1"
			elseif camp_preference == 2 then 		--防御
				animation_name = "type_2"
			elseif camp_preference == 3 then 		--技能
				animation_name = "type_3"
			end
			local jsonFile = "sprite/spirte_type_di.json"
		    local atlasFile = "sprite/spirte_type_di.atlas"
		    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
		    animation2:setPosition(cc.p(Panel_buzhen_role:getContentSize().width/2,0))
		    animation2:setTag(999)
		    Panel_buzhen_role:addChild(animation2, -1)
		end
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		ccui.Helper:seekWidgetByName(root, "Button_dellet"):setVisible(false)
	end
					  
end

function LformationChangeHeroCell:onExit()
end

function LformationChangeHeroCell:init(ship,types,index,formationType)
	self.ship = ship
	if types ~=nil then
		self.current_type = types
	end
	if index~= nil then
		self.index = index
	end
	self.formationType = formationType

	self.animation_index,self.effic_id = self:getSkillAnimationIndex()
	
	if self.effic_id ~= nil then
        if tonumber(_ED.user_info.user_gender) == 1 then --男默认技能
            self.normal_effic_id = user_skill_effic_id[1]
        elseif tonumber(_ED.user_info.user_gender) == 2 then 
            self.normal_effic_id = user_skill_effic_id[2]
        end
	end
	self:onInit()
end
function LformationChangeHeroCell:close()
	self.armature_hero:removeAllChildren(true)
	self.armature_hero:removeFromParent()
end
function LformationChangeHeroCell:createCell()
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	--     local effect_paths = "images/ui/effice/effect_16/effect_16.ExportJson"
	--     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)	
	-- end	
	local cell = LformationChangeHeroCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

