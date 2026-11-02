
-- ----------------------------------------------------------------------------------------------------
-- 说明：角色突破
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
AscendingOrder = class("AscendingOrderClass", Window)

function AscendingOrder:ctor()
    self.super:ctor()
	self.roots = {}


	self.play_types = 0
	self.hero_state = false
	self.hero_animation = nil
	self.armature_effic = nil
	self.normal_armature_effic = nil
	self.animation_index = nil
	self.effic_id = nil
	self.normal_effic_id = nil
    --Initialize AscendingOrder page state machine.
    local function init_AscendingOrder_terminal()
	
		-- local ascending_order_close_terminal = {
            -- _name = "ascending_order_close",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 			
                -- fwin:open(AscendingOrder:new(), fwin._view)
				-- fwin:close(instance)

                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		        --播放攻击动画
        local ascendingorder_play_hero_animation_terminal = {
            _name = "ascendingorder_play_hero_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:changeHeroAnimation(params)
            	end
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(ascendingorder_play_hero_animation_terminal)
		 --state_machine.add(ascending_order_close_terminal)
        state_machine.init()
     end
    -- -- call func init hom state machine.
     init_AscendingOrder_terminal()
end
function AscendingOrder:changeHeroAnimation(play_types)
	self.play_types = play_types

	-- print("==============",self.play_index,self.armature_effic)
	if self.armature_effic ~= nil and self.play_types == self.animation_index then
		-- print("=================================播放")
		self.armature_effic:setVisible(true)

		csb.animationChangeToAction(self.armature_effic, 0,0, false)
	end	

	if self.normal_armature_effic ~= nil and self.play_types == 14 then
		self.normal_armature_effic:setVisible(true)
		csb.animationChangeToAction(self.normal_armature_effic, 0,0, false)
	end

	csb.animationChangeToAction(self.hero_animation, play_types, play_types, false)


end
function AscendingOrder:drawPlayer(playerPanel)
	local shipId = self.ship.ship_template_id

	if nil ~= shipId then
		app.load("client.cells.ship.ship_body_cell")
		local shipMID = tonumber(shipId)
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert
			then
			local temp_bust_index = 0
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				----------------------新的数码的形象------------------------
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], shipMID, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(self.ship.evolution_status, "|")
				local evo_mould_id = evo_info[tonumber(ship_evo[1])]
				--新的形象编号
				temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			else
				temp_bust_index = dms.int(dms["ship_mould"], shipMID, ship_mould.bust_index)
			end
			-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
			-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
			-- cell:getAnimation():playWithIndex(0)
			-- playerPanel:removeAllChildren(true)
			-- playerPanel:addChild(cell)
			-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
			-- -- cell:setPosition(cc.p(playerPanel:getContentSize().width/2, playerPanel:getContentSize().height/2))
			-- cell:setPosition(cc.p(playerPanel:getContentSize().width/2, 0))

			local shipPanel = playerPanel
			shipPanel:removeAllChildren(true)
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
			if animationMode == 1 then
				app.load("client.battle.fight.FightEnum")
				local hero_animation = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        hero_animation:setScaleX(-1)
			    end
				self.hero_animation = hero_animation

				hero_animation.animationNameList = spineAnimations
				sp.initArmature(hero_animation, true)
			    hero_animation._self = self
				local function changeActionCallback( armatureBack )	
				local play_types = armatureBack._self.play_types
				local hero_state = armatureBack._self.hero_state
					if play_types == 14 then
						state_machine.excute("ascendingorder_play_hero_animation",0,self.animation_index)
					elseif play_types == self.animation_index then
						state_machine.excute("ascendingorder_play_hero_animation",0,0)
						hero_state = true
					elseif play_types == 0 and hero_state == true then
						armatureBack._invoke = nil
						-- armatureBack._self:showClosePanelUI(armatureBack._index)
					end
			    end
			    hero_animation._invoke = changeActionCallback
			    hero_animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
				csb.animationChangeToAction(hero_animation, 0, 0, false)


			    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			    	if self.effic_id ~= nil then
						local armature_effic = sp.spine_effect(self.effic_id, effectAnimations[1], false, nil, nil, nil)	
						self.armature_effic = armature_effic
						sp.initArmature(self.armature_effic, false)
						armature_effic.animationNameList = effectAnimations
						self.armature_effic:setVisible(false)
						self.hero_animation:addChild(armature_effic)
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
						self.hero_animation:addChild(normal_armature_effic)
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
		else
			local cell = ShipBodyCell:createCell()
				cell:initShipMID(shipMID)
				playerPanel:addChild(cell)
				self.roleCell = cell
				cell:setTouchEnabled(false)
				cell:setSwallowTouches(false)
			end
		end

end

function AscendingOrder:setTextString(name, text)
	ccui.Helper:seekWidgetByName(self.roots[1], name):setString(tostring(text))
end


function AscendingOrder:drawResult()
	--app.load("client.packs.hero.HeroAdvanceSuccess")
	-- self.ship
	--> print("self.ship.ship_template_id-------------------",self.ship.ship_template_id)
	local index = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.All_icon)
	--> print("index------------", index)
	--local shipMouldFront = dms.element(dms["ship_mould"], self.ship.ship_template_id)
	--> print("self.shipMouldFront", shipMouldFront)
	-- local rankLevelBack = dms.atoi(shipMouldFront, ship_mould.initial_rank_level)  	--进阶后的进阶等级
	-- local rankLevelFront = rankLevelBack												--进阶后的进阶等级
	-- local ship_name = self.ship.captain_name												--战船名称
	
	-- if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then --
			-- ship_name = _ED.user_info.user_name
	-- end

	-- -- 进阶后的属性描述 rankLevelBack
	-- local talent_id = dms.atos(shipMouldFront, ship_mould.talent_id)  --进阶hou的进阶等级
	-- local talent_id_ship = zstring.zsplit(talent_id, "|")				--进阶的表
	-- local talent = zstring.zsplit(talent_id_ship[rankLevelBack], ",")
	-- local talent_name = dms.string(dms["talent_mould"], talent[3], talent_mould.talent_name) 			-- 进阶后解锁属性
	-- local talent_describe = dms.string(dms["talent_mould"], talent[3], talent_mould.talent_describe) 	-- 进阶后解锁属性
	
	local _advancedBefore = {}
	local _advancedBack = self.oldShipData
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
		local shipMouldFront = dms.element(dms["ship_mould"], self.ship.ship_template_id)
		local rankLevelBack = dms.atoi(shipMouldFront, ship_mould.ship_type)
		-- print("----------m0",rankLevelBack)
		-- print("----",shipMouldFront)
		local talent_id = dms.atos(shipMouldFront, ship_mould.talent_id)  --进阶hou的进阶等级
		--print("----",talent_id)
		local talent_id_ship = zstring.split(talent_id, "|")				--进阶的表
		--print("----",talent_id_ship)

		local talent = zstring.split(talent_id_ship[rankLevelBack], ",")
		--print("----",talent)
		local talent_name = dms.string(dms["talent_mould"], talent[3], talent_mould.talent_name) 			-- 进阶后解锁属性
		--print("----",talent_name)
		
		local talent_describe = dms.string(dms["talent_mould"], talent[3], talent_mould.talent_describe)
		self:setTextString("Text_2", talent_name)
		self:setTextString("Text_4", talent_describe)
		_advancedBefore[1] = self.ship.ship_grade
		_advancedBefore[2] = zstring.tonumber(self.ship.ship_courage) - zstring.tonumber(_advancedBack[2])
		_advancedBefore[3] = zstring.tonumber(self.ship.ship_intellect) - zstring.tonumber(_advancedBack[3])
		_advancedBefore[4] = zstring.tonumber(self.ship.ship_health) - zstring.tonumber(_advancedBack[4])
		_advancedBefore[5] = zstring.tonumber(self.ship.ship_quick) - zstring.tonumber(_advancedBack[5])
	else
		_advancedBefore[1] = self.ship.ship_grade
		_advancedBefore[2] = self.ship.ship_courage
		_advancedBefore[3] = self.ship.ship_intellect
		_advancedBefore[4] = self.ship.ship_health
		_advancedBefore[5] = self.ship.ship_quick	
	end
	-- _advancedBack[1] = self.oldShipData[1] - _advancedBefore[1]
	-- _advancedBack[2] = self.oldShipData[2] - _advancedBefore[2]
	-- _advancedBack[3] = self.oldShipData[3] - _advancedBefore[3]
	-- _advancedBack[4] = self.oldShipData[4] - _advancedBefore[4]
	-- _advancedBack[5] = self.oldShipData[5] - _advancedBefore[5]

	-- local _advancedBack = {}
	-- _advancedBack[1] = nil
	-- _advancedBack[2] = _ED.add_ship_power  		--战船生命加成
	-- _advancedBack[3] = _ED.add_ship_courage     	--战船攻击加成
	-- _advancedBack[4] = _ED.add_ship_intellect 		--战船物防加成
	-- _advancedBack[5] = _ED.add_ship_nimable     	--战船法防加成	
	-- _advancedBack[2] = 10  		--战船生命加成
	-- _advancedBack[3] = 20     	--战船攻击加成
	-- _advancedBack[4] = 30 		--战船物防加成
	-- _advancedBack[5] = 49    	--战船法防加成	
	
	-- local successPage = HeroAdvanceSuccess:new()
	-- successPage:init(self.ship, _advancedBefore, _advancedBack, nil)
	-- --fwin:open(successPage, fwin._dialog)
	-- self.heroAdvancePanel:addChild(successPage)
	-- --self.roots[1]:addChild(successPage)
	--> print("11111111111111111111111")
	
	--天赋属性名
	--self:setTextString("Text_3", talent_name)
	
	--天赋数值
	--self:setTextString("Text_4", talent_describe)
	
	--解锁天赋名
	 --self:setTextString("Text_2", talent_name)
	
	--名字1
	--self:setTextString("Text_5", ship_name.."+"..tostring(rankLevelFront))
	
	--名字2
	--self:setTextString("Text_6", ship_name.."+"..tostring(rankLevelBack))
	
	--攻击
	self:setTextString("Text_45", _advancedBefore[2])
	
	--装甲
	self:setTextString("Text_45_0", _advancedBefore[3])
	
	--生命
	self:setTextString("Text_45_0_0", _advancedBefore[4])
	
	--防空
	self:setTextString("Text_45_0_0_0", _advancedBefore[5])
	
	--攻击 增加的
	self:setTextString("Text_41", "+".._advancedBack[2])
	
	--装甲 增加的
	self:setTextString("Text_42", "+".._advancedBack[3])
	
	--生命 增加的
	self:setTextString("Text_42_0", "+".._advancedBack[4])
	
	--防空 增加的
	self:setTextString("Text_42_0_0", "+".._advancedBack[5])
	
	
end

function AscendingOrder:onEnterTransitionFinish()
	local csbItem = csb.createNode("destiny/ascending_order.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbItem)

    -- local action = csb.createTimeline("destiny/ascending_order.csb")
    -- csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)

	-- local root = csbAscendingOrder:getChildByName("root")
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0"), nil, {func_string = [[state_machine.excute("AscendingOrder_show_arena", 0, "AscendingOrder_show_arena.'")]]}, nil, 0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0_0"), nil, {func_string = [[state_machine.excute("AscendingOrder_show_snatch", 0, "AscendingOrder_show_arena.'")]]}, nil, 0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_55848_0"), nil, {func_string = [[state_machine.excute("AscendingOrder_show_palace", 0, "AscendingOrder_show_palace.'")]]}, nil, 0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_55848_ziyuan"), nil, {func_string = [[state_machine.excute("AscendingOrder_show_mineral_res", 0, "AscendingOrder_show_mineral_res.'")]]}, nil, 0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_55848_0_0"), nil, {func_string = [[state_machine.excute("AscendingOrder_show_trial_tower", 0, "AscendingOrder_show_arena.'")]]}, nil, 0)
	
	self.playerPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shenjiang")
	self.heroAdvancePanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_9")
	
	self.resultRolePanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_tupo")
	
	self.playerPanel:setSwallowTouches(true)
	self.playerPanel:setTouchEnabled(true)
	
	
	self:drawPlayer(self.playerPanel)
	self:drawResult()

	local function trigger_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			if math.abs(__epoint.x - __spoint.x) < 5 then
				if 2 == self.frameState then
					fwin:close(self)
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						app.load("client.cells.destiny.destiny_add_property_info_cell") 
						local destinyAddPropertyInfoCell = DestinyAddPropertyInfoCell:new()
						fwin:open(destinyAddPropertyInfoCell, fwin._windows)
					end
				elseif 1 == self.frameState then
					self.frameState = 2
					self.playerPanel:setVisible(false)
					self.playerPanel:removeChild(self.roleCell)
					-- self.action:stop()
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						self.playerPanel:removeAllChildren(true)
					end
					self:drawPlayer(self.resultRolePanel)
					self.heroAdvancePanel:setVisible(true)
					self.action:play("close_1", false)
				end
			end
		end
	end
	
	
	self.frameState = 0
	self.action = csb.createTimeline("destiny/ascending_order.csb")
	
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		local str = frame:getEvent()
		if str == "next_close" then
			self.frameState = 1
			--这个 Panel_dh 角色形象里面的,穿透到这来了..........
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				state_machine.excute("ascendingorder_play_hero_animation",0,14)	
			end
			local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
			if nil ~= Panel_dh then
				Panel_dh:addTouchEventListener(trigger_onTouchEvent)
			end
		end
    end)
	self.action:play("open_1", false)
	self.roots[1]:runAction(self.action)
	
	local Panel_103 = ccui.Helper:seekWidgetByName(root, "Panel_103")
	Panel_103:setSwallowTouches(true)
	Panel_103:setTouchEnabled(true)
	
	
	Panel_103:addTouchEventListener(trigger_onTouchEvent)
end


-- oldShipData[1] = self.ship.ship_grade
-- oldShipData[2] = self.ship.ship_health
-- oldShipData[3] = self.ship.ship_courage
-- oldShipData[4] = self.ship.ship_intellect
-- oldShipData[5] = self.ship.ship_quick
-- 当前的实例对象,非id
function AscendingOrder:getSkillAnimationIndex()
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
function AscendingOrder:init(ship, oldShipData)
	self.ship = ship
	self.oldShipData = oldShipData

	self.animation_index,self.effic_id = self:getSkillAnimationIndex()
	
	if self.effic_id ~= nil then
        if tonumber(_ED.user_info.user_gender) == 1 then --男默认技能
            self.normal_effic_id = user_skill_effic_id[1]
        elseif tonumber(_ED.user_info.user_gender) == 2 then 
            self.normal_effic_id = user_skill_effic_id[2]
        end
	end	
end

function AscendingOrder:onExit()
	state_machine.remove("ascending_order_close")
	state_machine.remove("ascendingorder_play_hero_animation")
end

--return AscendingOrder:new()