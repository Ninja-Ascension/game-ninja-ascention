-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束奖励结算界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
BattleReward = class("BattleRewardClass", Window)

function BattleReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.rewardList = nil
	app.load("client.battle.BattleLevelUp")
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		then
		app.load("client.red_alert_time.formation.Formation")
		app.load("client.red_alert_time.cells.props.props_icon_cell")
	end

	self._loadIndex = 0
	self._load_over = false
	self.isendanimation = false
	self:onLoad()
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim  
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_yugioh
	 then
		_ED.user_is_level_up = false
		if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
			_ED.user_is_level_up = true
		end
	end
	self.showbutton = false
	local function init_battle_reward_terminal()

			local battle_reward_repeat_attack_terminal = {
			    _name = "battle_reward_repeat_attack",
			    _init = function (terminal) 
			        
			    end,
			    _inited = false,
			    _instance = self,
			    _state = 0,
			    _invoke = function(terminal, instance, params)
			    		--英雄副本直接提示没次数了
			    	if tonumber(_ED._current_scene_type) == 3 then
						TipDlg.drawTextDailog(_string_piece_info[113])
			    		return
			    	end
			    	--判断体力
			    	local currentNpcID = tonumber(_ED._scene_npc_id)
			    	local attack_need_food = dms.int(dms["npc"], currentNpcID, npc.attack_need_food)
			    	if zstring.tonumber(_ED.user_info.user_food) < attack_need_food then
						app.load("client.cells.prop.prop_buy_prompt")
						
						local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
						local mid = zstring.tonumber(config[15])
						
						local win = PropBuyPrompt:new()
						win:init(mid)
						fwin:open(win, fwin._ui)
						return
					end
			    	--判断次数
					local totalAttackTimes = dms.int(dms["npc"], currentNpcID, npc.daily_attack_count)
					local surplusAttackCount = tonumber(_ED.npc_current_attack_count[currentNpcID])

					if surplusAttackCount >= totalAttackTimes then
						TipDlg.drawTextDailog(_string_piece_info[113])
						return
					end

					fwin:close(instance)

					local win = fwin:find("BattleSceneClass")
					local fight = fwin:find("FightClass")
					if nil ~= fight then
						fwin:close(win)
					end
				

					-- 战斗请求
					local function responseBattleInitCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							--state_machine.excute("page_stage_fight_data_deal", 0, 0)
						
							cacher.removeAllTextures()
							
							fwin:cleanView(fwin._windows)
							cc.Director:getInstance():purgeCachedData()
							
							-- 记录上次战斗是否选择的最后的NPC
							LDuplicateWindow._infoDatas._isLastNpc = true
							LDuplicateWindow._infoDatas._isNewNPCAction = false
							
							local bse = BattleStartEffect:new()
							bse:init(1)
							fwin:open(bse, fwin._windows)
						end
					end
					
					local function launchBattle()
						app.load("client.battle.fight.FightEnum")
						local fightType = state_machine.excute("fight_get_current_fight_type", 0, nil)
                        local function responseBattleStartCallback( response )
                        	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                        	app.load("client.battle.report.BattleReport")
								
								local resultBuffer = {}
								if _ED._fightModule == nil then
									_ED._fightModule = FightModule:new()
								end
								_ED.attackData = {
									roundCount = _ED._fightModule.totalRound,
									roundData ={}
								}
								if _ED._scene_npc_id == nil or _ED._scene_npc_id == "" or tonumber(_ED._scene_npc_id) == 0 then
									_ED._scene_npc_id = _ED._scene_npc_copy_net_id
								end
								_ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0, resultBuffer)
								local orderList = {}
								_ED._fightModule:initFightOrder(_ED.user_info, orderList)

								responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
							end
                        end
                        _ED._scene_npc_copy_net_id = _ED._scene_npc_id
                        protocol_command.battle_result_start.param_list = "".._enum_fight_type._fight_type_0.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
                        NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)

					end
					launchBattle()

			        return true
			    end,
			    _terminal = nil,
			    _terminals = nil
			}

			local battle_reward_next_attack_terminal = {
		    _name = "battle_reward_next_attack",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
				fwin:close(instance)
				local win = fwin:find("BattleSceneClass")
				local fight = fwin:find("FightClass")
				if nil ~= fight then
					fwin:close(win)
					cacher.removeAllTextures()
					fwin:reset(nil)
					app.load("client.home.Menu")
					fwin:open(Menu:new(), fwin._taskbar)
				end
				local currentNpcID = tonumber(_ED._scene_npc_id)
				 
				local next_npc_id = dms.int(dms["npc"],currentNpcID,npc.next_npc_id)
        		local next_NpcSceneID = dms.int(dms["npc"],next_npc_id,npc.scene_id)
        		if next_npc_id == -1 then
        			return
        		end
				if next_NpcSceneID == -1 then
					return
				end
        		-- _ED._current_scene_id = next_NpcSceneID
        		-- _ED._scene_npc_id = next_npc_id
        		-- print("=============",_ED._current_scene_type,_ED._current_scene_id,_ED._scene_npc_id)
			    state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
	            {
	                _type = _ED._current_scene_type, 
	                _sceneId = next_NpcSceneID,
	                _npcid = next_npc_id
	            })
		        return true
			    end,
			    _terminal = nil,
			    _terminals = nil
			}

	        -- 关闭窗口
			local battle_reward_close_terminal = {
	            _name = "battle_reward_close",
	            _init = function (terminal) 
	                
	            end,
	            _inited = false,
	            _instance = self,
	            _state = 0,
	            _invoke = function(terminal, instance, params)
					fwin:close(instance)
					fwin:close(fwin:find("BattleSceneClass"))
					fwin:close(fwin:find("FightUIClass"))
					fwin:close(fwin:find("FightMapClass"))
					fwin:close(fwin:find("FightClass"))
					fwin:close(fwin:find("BattleRewardClass"))
					state_machine.excute("legion_pk_record_update_list_info", 0, nil)
					state_machine.excute("pve_parts_supply_tab_update_draw", 0, nil)
					state_machine.excute("pve_parts_supply_tab_complete_chapter", 0, nil)
					state_machine.excute("pve_armor_tab_update_draw", 0, nil)
					state_machine.excute("expedition_update_draw", 0, nil)
					state_machine.excute("limit_dekaron_challenge_update_draw", 0, nil)
					state_machine.excute("enemy_strike_fight_update_hp_info", 0, {true})
					state_machine.excute("legion_pve_update_draw", 0, "")
					state_machine.excute("guard_battle_show_battle_result", 0, "")
					checkRewardObtainDraw()
					checkEffectLevelUp()
					state_machine.excute("home_map_update_build", 0, nil)
					state_machine.excute("pve_map_update2_draw", 0, 0) 
			  --       state_machine.excute("home_button_window_show", 0, 0)
			  --       state_machine.excute("main_window_show", 0, 0)
					-- if zstring.tonumber(_ED._battle_init_type) == 0 then 
					-- 	state_machine.excute("pve_manager_window_open", 0, "")
					-- 	state_machine.excute("pve_map_open", 0, {_ED._current_scene_id})
					-- end
	                return true
	            end,
	            _terminal = nil,
	            _terminals = nil
	        }
			
			 -- 维修关闭
			local battle_reward_service_close_terminal = {
	            _name = "battle_reward_service_close",
	            _init = function (terminal) 
	                
	            end,
	            _inited = false,
	            _instance = self,
	            _state = 0,
	            _invoke = function(terminal, instance, params)
					state_machine.excute("formation_window_open", 0, {_datas = {form_type = 3,page = 3}})
					state_machine.excute("battle_reward_close", 0, "")
	                return true
	            end,
	            _terminal = nil,
	            _terminals = nil
	        }

			state_machine.add(battle_reward_repeat_attack_terminal)
			state_machine.add(battle_reward_next_attack_terminal)
			state_machine.add(battle_reward_close_terminal)
			state_machine.add(battle_reward_service_close_terminal)
			state_machine.init()
	end

	init_battle_reward_terminal()

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self:onInit()
	end
end	

function BattleReward:init(fightType)
	self._fight_type = fightType
end

function BattleReward:onEnterTransitionFinish()
	-- print("_==========================",_ED._current_scene_id,_ED._scene_npc_id)
end

function BattleReward.onImageLoaded(texture)
	
end

function BattleReward:onArmatureDataLoad(percent)
	
end

function BattleReward:onArmatureDataLoadEx(percent)
	self._loadIndex = self._loadIndex + 1
	if percent >= 1 or self._loadIndex > 1 then
		if self._load_over == false then
			self._load_over = true
			self:onInit()
		end
	end
end

function BattleReward:onLoad()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return
	end
	local effect_paths = {
		"images/ui/effice/effect_22/effect_22.ExportJson",
		"images/ui/effice/effect_26/effect_26.ExportJson"
	}
	self._loadIndex = 0
	for i, v in pairs(effect_paths) do
		local fileName = v
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
	end
end

function BattleReward:drawWinStar(number)
	local root = self.roots[1]
	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	local s_number = 0
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_battle_win_star/effect_battle_win_star.ExportJson")
	local armature = ccs.Armature:create("effect_battle_win_star")
	if tonumber(number) == 3 then
		s_number = 0
	elseif tonumber(number) == 2 then
		s_number = 2
	else
		s_number = 4
	end
	draw.initArmatureTwo(armature, nil, 1, 0, 1, s_number)
	local function changeActionCallback( armatureBack )
		draw.initArmatureTwo(armature, nil, -1, 0, 1, s_number+1)
	end
	armature._invoke = changeActionCallback
	armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	armature:setPosition(cc.p(Panel_star:getContentSize().width/2,Panel_star:getContentSize().height/2))
	Panel_star:addChild(armature)
	armature:getAnimation():setFrameEventCallFunc(
    function(bone,evt,originFrameIndex,currentFrameIndex)
        local tempArmature = bone:getArmature()
        if tempArmature:isVisible() == true then
            if evt == "play_sound_1" then
            	checkPlayEffect(76)
            elseif evt == "play_sound_2" then
            	checkPlayEffect(76)
            elseif evt == "play_sound_3" then
            	checkPlayEffect(76)
            end
        end
    end)
end

function BattleReward:onInit()
	local csbvictory = csb.createNode("battle/victory_in_battle.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)

	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vic_close"), nil, 
	{
        terminal_name = "battle_reward_close",
        terminal_state = 0,
        touch_scale_xy = 0.95, 
    }, nil, 3)

	local bTouch = false
	local action = csb.createTimeline("battle/victory_in_battle.csb")
	
	csbvictory:runAction(action)
	if tonumber(_ED.battleData.battle_init_type) == 105 then--名舰战役灯塔副本掉落取首胜奖励数据
		self.rewardList = getSceneReward(41)
	elseif tonumber(_ED.battleData.battle_init_type) == 11 then
		self.rewardList = getSceneReward(13)
	elseif tonumber(_ED.battleData.battle_init_type) == 202 then
		self.rewardList = getSceneReward(38)
	elseif tonumber(_ED.battleData.battle_init_type) == 201 then
		self.rewardList = getSceneReward(84)
	elseif tonumber(_ED.battleData.battle_init_type) == 107 then
		self.rewardList = getSceneReward(141)
	else
		self.rewardList = getSceneReward(2)
	end
	-- local rewardNumber = 0

	local ListView_rew_icon = ccui.Helper:seekWidgetByName(root, "ListView_rew_icon")
	
	-- local AnimatedReward = {}
	local listViewSize = ListView_rew_icon:getContentSize()
	local nCoount = 0
	local tWidth = 0
	local iemsMargin = ListView_rew_icon:getItemsMargin()
	if nil ~= self.rewardList then
		local result = {}
	    for i,v in pairs(self.rewardList.show_reward_list) do
	        if result[""..v.prop_type] == nil then
	            result[""..v.prop_type] = {}
	        end
	        if result[""..v.prop_type][""..v.prop_item] == nil then 
	            result[""..v.prop_type][""..v.prop_item] = {item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
	        end
	        result[""..v.prop_type][""..v.prop_item].item_value = tonumber(v.item_value) + tonumber(result[""..v.prop_type][""..v.prop_item].item_value)
	    end
	    local info = {}
	    for k,v in pairs(result) do
	        for k1,v1 in pairs(v) do
	        	if tonumber(v1.prop_type) < 46 
	        		and tonumber(v1.prop_type) ~= 28
	        		then
	            	table.insert(info, v1)
	            end
	        end
	    end
		for i,v in pairs(info) do
			-- local reward_prop_id = 0
			local cell = nil
			local rewardType = tonumber(v.prop_type)
			local propItem = tonumber(v.prop_item)
			if propItem == -1 then
				if tonumber(resource_prop_id[rewardType]) ~= 3 then
					cell = state_machine.excute("props_icon_create_cell",0,{6, 1, resource_prop_id[rewardType], 1, v.item_value})
				end
			elseif rewardType == 6 then
				cell = state_machine.excute("props_icon_create_cell",0,{6, 1, propItem, 1, v.item_value})
			elseif rewardType == 7 then
				cell = state_machine.excute("props_icon_create_cell",0,{8, 14, propItem, 15, nil, true})
			elseif rewardType == 13 then
				cell = state_machine.excute("props_icon_create_cell",0,{6, 10, propItem, 3, v.item_value, true})
				ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
			end
			if nil ~= cell then
				ListView_rew_icon:addChild(cell)
				if nCoount > 0 then
					tWidth = tWidth + iemsMargin
				end
				nCoount = nCoount + 1
			end
		end

		tWidth = tWidth + PropsIconCell.__size.width * nCoount
		local viewWidth = listViewSize.width * ListView_rew_icon:getScaleX()
		if viewWidth > tWidth then
			-- local containerLayer = ListView_rew_icon:getInnerContainer()
			ListView_rew_icon:setPositionX(ListView_rew_icon:getPositionX() + viewWidth / 2 - tWidth / 2+20)
			ListView_rew_icon:setTouchEnabled(false)
		end
	end
	-- showGetAnimated(root,AnimatedReward)
	-- checkRewardObtainDraw()
    
	if tonumber(_ED.battleData.battle_init_type) == 9 or tonumber(_ED.battleData.battle_init_type) == 10 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
			if __lua_project_id ~= __lua_project_warship_girl_b and __lua_project_id ~= __lua_project_digimon_adventure and __lua_project_id ~= __lua_project_pokemon
				and __lua_project_id ~= __lua_project_rouge and __lua_project_id ~= __lua_project_yugioh then 
				ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
			end
			
			ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(false)
		end
		ccui.Helper:seekWidgetByName(root, "Text_1"):setVisible(false)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then		
			ccui.Helper:seekWidgetByName(root, "Text_1_0"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_7"):setVisible(false)
		end
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local Button_chongfutiaozhan = ccui.Helper:seekWidgetByName(root,"Button_chongfutiaozhan")
		local Button_xiayizhan = ccui.Helper:seekWidgetByName(root,"Button_xiayizhan")
			fwin:addTouchEventListener(Button_chongfutiaozhan, nil, 
	        {
	            terminal_name = "battle_reward_repeat_attack",
	            terminal_state = 0, 
	            isPressedActionEnabled = true
	        }, nil, 0)
	        fwin:addTouchEventListener(Button_xiayizhan, nil, 
	        {
	            terminal_name = "battle_reward_next_attack",
	            terminal_state = 0, 
	            isPressedActionEnabled = true
	        }, nil, 0)

		local status = false
		if self.rewardList ~= nil then
			for i, item in pairs(self.rewardList.show_reward_list) do
				if tonumber(item.prop_type) == 6 then -- 道具
					if dms.int(dms["prop_mould"], item.prop_item, prop_mould.change_of_equipment) > 0 then -- 装备
						status = true
					elseif dms.int(dms["prop_mould"], item.prop_item, prop_mould.use_of_ship) > 0 then -- 武将
						status = true
					else
						status = true
					end	
				elseif tonumber(item.prop_type) == 7 then -- 装备
					status = true
				elseif tonumber(item.prop_type) == 13 then -- 武将
					status = true
				elseif tonumber(item.prop_type) == 4 then			--水雷魂和荣誉
					status = true
				elseif tonumber(item.prop_type) == 5 then
					status = true
				end
			end
		end

	    if _ED.user_is_level_up == true or status == true then
	     	Button_chongfutiaozhan:setVisible(false)
	     	Button_xiayizhan:setVisible(false)
	    end
	end
	local function window_open_action_play()
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
				self.isendanimation = true
				-- print("======window_open====")		
				local win_pic_show_panel = ccui.Helper:seekWidgetByName(root, "Panel_10_ck")
				local win_pic_loop_panel = ccui.Helper:seekWidgetByName(root, "Panel_11_cs")
				win_pic_loop_panel:setVisible(true)
				win_pic_show_panel:setVisible(false)
				action:play("window_open", false)
		else
			action:gotoFrameAndPlay(0, action:getDuration(), false)
		end
		-- print("==========设置监听2")
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end

			local str = frame:getEvent()
			if str == "over" then
				bTouch = true
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					then

					local status = false
					if self.rewardList ~= nil then
						for i, item in pairs(self.rewardList.show_reward_list) do
							if tonumber(item.prop_type) == 6 then -- 道具
								if dms.int(dms["prop_mould"], item.prop_item, prop_mould.change_of_equipment) > 0 then -- 装备
									status = true
								elseif dms.int(dms["prop_mould"], item.prop_item, prop_mould.use_of_ship) > 0 then -- 武将
									status = true
								else
									status = true
								end	
							elseif tonumber(item.prop_type) == 7 then -- 装备
								status = true
							elseif tonumber(item.prop_type) == 13 then -- 武将
								status = true
							elseif tonumber(item.prop_type) == 4 then			--水雷魂和荣誉
								status = true
							elseif tonumber(item.prop_type) == 5 then
								status = true
							end
						end
					end
					-- print("======================0000======================",_ED.user_is_level_up,status,_ED._is_eve_battle,_ED._current_scene_type)
					if _ED.user_is_level_up == false and status == false and _ED._is_eve_battle == false and tonumber(_ED._current_scene_type) ~= 3  then
						local unlock_npc = dms.int(dms["npc"], _ED._scene_npc_id, npc.unlock_npc)

						local Button_chongfutiaozhan = ccui.Helper:seekWidgetByName(root,"Button_chongfutiaozhan")
						local Button_xiayizhan = ccui.Helper:seekWidgetByName(root,"Button_xiayizhan")
						Button_chongfutiaozhan:setVisible(true)
						if __lua_project_id == __lua_project_gragon_tiger_gate 
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
							if tonumber(unlock_npc) ~= nil and tonumber(unlock_npc) == -1 then
								Button_xiayizhan:setVisible(false)
							else
								Button_xiayizhan:setVisible(true)
							end
						else
							Button_xiayizhan:setVisible(true)
						end
					end
					self.showbutton = true
				end
			elseif str == "show" then
				local expLoadingButton = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
				local expCount = tonumber(_ED.user_info.last_user_experience)/tonumber(_ED.user_info.last_user_grade_need_experience)*100
				expLoadingButton:setPercent(expCount)
				--> print("exp", _ED.user_info.last_user_experience, _ED.user_info.last_user_grade_need_experience)
				local rewardExpCount = tonumber(getRewardValueWithType(self.rewardList, 8))/tonumber(_ED.user_info.last_user_grade_need_experience)*100
				local isLevelup = false
				local levelLabel = ccui.Helper:seekWidgetByName(root, "Text_8")
				local function update(delta)
					local sc = 3
					if (100-expCount)< 3 then
						sc = 100-expCount
					end
					if rewardExpCount < sc then
						sc = rewardExpCount
					end
					rewardExpCount = rewardExpCount - sc
					
					if rewardExpCount<sc then
						expCount = tonumber(_ED.user_info.user_experience)/tonumber(_ED.user_info.last_user_grade_need_experience)*100
					else
						expCount = expCount + sc
					end
					if expCount >= 100 then
						isLevelup = true
						expCount = 0
						rewardExpCount = rewardExpCount * tonumber(_ED.user_info.last_user_grade_need_experience) / tonumber(_ED.user_info.user_grade_need_experience)
					end
					
					if tonumber(_ED.user_info.user_experience) == 0 and rewardExpCount > 0 then
						isLevelup = true
					end
					if (tonumber(_ED.user_info.last_user_experience)+getRewardValueWithType(self.rewardList, 8))/tonumber(_ED.user_info.last_user_grade_need_experience)*100 >= 100 then
						isLevelup = true
					end
					-- 当前是否处于可升级状态
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
						or __lua_project_id == __lua_project_red_alert
						or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon
						or __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_rouge
						or __lua_project_id == __lua_project_yugioh
		 			then
					else
						_ED.user_is_level_up = false
					end
					if rewardExpCount <= 0 then
						self:unscheduleUpdate()
						-- draw.setButtonTouchEnabled(confirmButton, true)
						if isLevelup == true  and _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
							--> print("open BattleLevelUp window!!!")
							_ED.user_is_level_up = true
							
							--fwin:open(BattleLevelUp:new(), fwin._viewdialog) 
							-- require "script/transformers/battle/BattleLevelUp"	
							if verifySupportLanguage(_lua_release_language_en) == true then
								levelLabel:setString(_string_piece_info[6].._ED.user_info.user_grade)
							else
								levelLabel:setString(_ED.user_info.user_grade.._string_piece_info[6])
							end
							-- LuaClasses["BattleLevelUpClass"]._rewardInfo = getSceneReward(3)
							-- if LuaClasses["BattleLevelUpClass"]._rewardInfo ~= nil then
								-- LuaClasses["BattleLevelUpClass"].Draw(scene)
							-- end
						end
						
						-- if __lua_project_id == __lua_project_all_star then
							-- draw.setVisible(BattleReward._uiLayer, "Button_1119", true)
						-- end
					end
					if csbvictory ~= nil then
						expLoadingButton:setPercent(expCount)
					end
				end
				self:unscheduleUpdate()
				self:scheduleUpdateWithPriorityLua(update, 0)
					
				local function onNodeEvent(tag)
					if tag == "exit" then
						self:unscheduleUpdate()
					end
				end

				self:registerScriptHandler(onNodeEvent)
			elseif str == "battle_ganglv_1_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.1))
				end
			elseif str == "battle_ganglv_2_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.3))
				end
			elseif str == "battle_ganglv_3_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.5))
				end
			elseif str == "battle_ganglv_4_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.7))
				end
			elseif str == "battle_ganglv_5_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.9))
				end
			elseif str == "battle_ganglv_6_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*1))
				end
			elseif str == "battle_ganglv_7_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*1))
				end
			elseif str == "battle_exp_1_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.1))
				end
			elseif str == "battle_exp_2_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.3))
				end
			elseif str == "battle_exp_3_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.5))
				end
			elseif str == "battle_exp_4_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.7))
				end
			elseif str == "battle_exp_5_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.9))
				end
			elseif str == "battle_exp_6_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*1))
				end
			elseif str == "battle_exp_7_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*1))
				end
			end
		end)
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then

		local npcData = dms.element(dms["npc"], _ED._scene_npc_id)	
		local npcCurStar = tonumber(_ED.npc_state[dms.atoi(npcData, npc.id)])
		if _ED.battleData.battle_init_type == 6 or _ED.battleData.battle_init_type == 3 or tonumber(_ED.battleData.battle_init_type) == 9 or tonumber(_ED.battleData.battle_init_type) == 10 then
			npcCurStar = 0
		end
		if _ED._is_eve_battle == true then
			npcCurStar = 3
			local Button_chongfutiaozhan = ccui.Helper:seekWidgetByName(root,"Button_chongfutiaozhan")
			local Button_xiayizhan = ccui.Helper:seekWidgetByName(root,"Button_xiayizhan")
			Button_chongfutiaozhan:setVisible(false)
			Button_xiayizhan:setVisible(false)
		end
		if npcCurStar == 1 then
			if zstring.tonumber(_ED.battleData.battle_init_type) == _enum_fight_type._fight_type_108 then 
				ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_awaken_tipString_info[13] .. " " .. _awaken_tipString_info[18])					--绘制奖励星数
			else
				ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[174] .. " " .. _string_piece_info[179])					--绘制奖励星数	
			end
		elseif npcCurStar == 2 then
			if zstring.tonumber(_ED.battleData.battle_init_type) == _enum_fight_type._fight_type_108 then 				
				ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_awaken_tipString_info[14] .. " " .. _awaken_tipString_info[17])					--绘制奖励星数
			else
				ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[175] .. " " .. _string_piece_info[178])					--绘制奖励星数
			end
		elseif npcCurStar == 3 then
			if zstring.tonumber(_ED.battleData.battle_init_type) == _enum_fight_type._fight_type_108 then 
				ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_awaken_tipString_info[15] .. " " .. _awaken_tipString_info[16])					--绘制奖励星数				
			else
				ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[176] .. " " .. _string_piece_info[177])					--绘制奖励星数
			end
		end
		local function ThreeStarAnimation(_stars)
			local stars = _stars
			local Panel_star_3 = ccui.Helper:seekWidgetByName(root, "Panel_star_3")
			local ArmatureNode_star_3 = Panel_star_3:getChildByName("ArmatureNode_star_3")
			local animation = ArmatureNode_star_3:getAnimation()
			local AnimationEventCallFunc = function()
				 -- window_open_action_play()
			end	
			animation:playWithIndex(0, 0, 0)
			animation:setMovementEventCallFunc(AnimationEventCallFunc)
			Panel_star_3:setVisible(true)

		end

		local function TwoStarAnimation(_stars)
			local stars = _stars
			local Panel_star_2 = ccui.Helper:seekWidgetByName(root, "Panel_star_2")
			local ArmatureNode_star_2 = Panel_star_2:getChildByName("ArmatureNode_star_2")
			local animation = ArmatureNode_star_2:getAnimation()
			local AnimationEventCallFunc = function()
				 ThreeStarAnimation(stars)
			end	
			animation:playWithIndex(0, 0, 0)
			animation:setMovementEventCallFunc(AnimationEventCallFunc)
			Panel_star_2:setVisible(true)

		end

		local function oneStarAnimation(_stars)
			local stars = _stars
			local Panel_star_1 = ccui.Helper:seekWidgetByName(root, "Panel_star_1")
			local ArmatureNode_star_1 = Panel_star_1:getChildByName("ArmatureNode_star_1")
			local animation = ArmatureNode_star_1:getAnimation()
			local AnimationEventCallFunc = function()
				if stars == 1 then
				 	-- window_open_action_play()
				elseif stars == 3 then
					TwoStarAnimation(stars)
				end
			end	
			animation:playWithIndex(0, 0, 0)
			animation:setMovementEventCallFunc(AnimationEventCallFunc)
			Panel_star_1:setVisible(true)
		end




		local function overAnimationStartFunc()
			local win_pic_show_panel = ccui.Helper:seekWidgetByName(root, "Panel_10_ck")
			local win_pic_loop_panel = ccui.Helper:seekWidgetByName(root, "Panel_11_cs")
			local win_pic_show_armature = win_pic_show_panel:getChildByName("ArmatureNode_2")
			local win_pic_animation = win_pic_show_armature:getAnimation()
			
			local winPicShowAnimationEventCallFunc = function(armatureBack,movementType,movementID)
				-- ccs.MovementEventType = {
					-- start = 0,
					-- complete = 1,
					-- loopComplete = 2,
				-- }
				-- ccui.Helper:seekWidgetByName(root, "Panel_12"):setVisible(true)
				if npcCurStar == 0 then
					window_open_action_play()
				end
				win_pic_show_panel:setVisible(false)
				win_pic_loop_panel:setVisible(true)
			end
			
			-- ccui.Helper:seekWidgetByName(root, "Panel_12"):setVisible(false)
			-- action:gotoFrameAndPlay(0, 0, false)
			win_pic_animation:setMovementEventCallFunc(winPicShowAnimationEventCallFunc)
			win_pic_show_panel:setVisible(true)
			win_pic_loop_panel:setVisible(false)
		end
		overAnimationStartFunc()
		-- action:play("window_open_win", false)
		-- action:setFrameEventCallFunc(function (frame)
		-- 	if nil == frame then
		-- 		return
		-- 	end

		-- 	local str = frame:getEvent()
		-- 	if str == "window_open_win_over" then
		-- 		overAnimationStartFunc()
		-- 	end
		-- end)
		ccui.Helper:seekWidgetByName(root, "Panel_12"):setVisible(true)	
		action:play("window_open_xing", false)
		-- print("==========设置监听1")
		local index = 0
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end
			if self.isendanimation == true then
				return
			end
				local str = frame:getEvent()
				if str == "xingxing" then
					-- print("=========星星动画===========")
					if npcCurStar == 2 then
						TwoStarAnimation(npcCurStar)
					elseif npcCurStar == 1 then
						oneStarAnimation(npcCurStar)
					elseif npcCurStar == 3 then
						oneStarAnimation(npcCurStar)
					end

					if npcCurStar ~= 0 then
						-- print("=========抖动记录=============")
						action:play("douping", false)
					end
				elseif str == "douping_1" then
					-- print("=======震动1==========")
					index = index + 1
					if index > npcCurStar then
						window_open_action_play()
						return
					end
					-- print("=======震动1==========")
					action:play("douping_donghua",false)
					
				elseif str == "dongping_donghu_over" then	
					-- print("=========",index)
					if index <= npcCurStar then
						-- print("=======震动结束")
						local se = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
							-- print("=======震动结束")
							action:play("douping", false)
						end)})
						self:runAction(se)
					else
						-- local se = cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function(sender)
						-- 	window_open_action_play()
						-- end)})
						-- self:runAction(se)		
					end
				end
		end)	
	elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	else
		window_open_action_play()
	end
	
	if __lua_project_id == __lua_project_digimon_adventure 
		-- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		local win_show_panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
		local win_show_armature = win_show_panel:getChildByName("ArmatureNode_2")
	
		draw.initArmature(win_show_armature, nil, -1, 0, 1)
		csb.animationChangeToAction(win_show_armature, 0, 1, false)
	end

	local sceneData = dms.element(dms["pve_scene"],_ED._current_scene_id)

	if (dms.atoi(sceneData, pve_scene.scene_type)==0) then
		_ED._fight_win_count = _ED._fight_win_count+1
	end

	-- playEffect(formatMusicFile("effect", 9996))
	
	-- -- local function responseTriggerSceneSurpriseCallback(_cObj, _tJsd)
		-- -- local pNode = tolua.cast(_cObj, "CCNode")
		-- -- local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		-- -- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
			-- -- if __lua_project_id == __lua_project_bleach then
				-- -- if _ED.secret_shopPerson_prop_info.prop_count ~= nil then
					-- -- require "script/transformers/activity/WonderfulActivityComeInMysteryPerson"
					-- -- LuaClasses["WonderfulActivityComeInMysteryPersonClass"].Draw()
				-- -- end
			-- -- end
			-- -- require "script/transformers/scene/SceneDropReward"
			-- -- LuaClasses["SceneDropRewardClass"]:Draw()
			
		-- -- end
		-- -- _ED._fight_win_count = 0	
	-- -- end
	
	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended and bTouch == true then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				if self.showbutton == false then
					return
				end
			end
			if _ED.battleData.battle_init_type == 6  then
				-- LuaClasses["MainWindowClass"].closeWindow(LuaClasses["BattleReward"])
				-- LuaClasses["MainWindowClass"].Draw()
				-- require "script/transformers/activity/TrialTower"
				-- if __lua_project_id==__lua_project_all_star then
					-- local mylist = {"9","21","22","23","24"}
					-- local musicIndex = math.random(1,5)
					-- playBgm(formatMusicFile("background", mylist[musicIndex]))
				-- end
				-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["TrialTowerClass"])
			else
				-- if LuaClasses["DuplicateClass"]._pageIndex == 2 or  LuaClasses["DuplicateClass"]._pageIndex == 3 then

					-- LuaClasses["MainWindowClass"].Draw()
				-- else
					-- LuaClasses["PlotSceneClass"].Draw()
					-- protocol_command.trigger_scene_surprise.param_list = "".._ED._fight_win_count
					-- Sender(protocol_command.trigger_scene_surprise.code, nil, nil, nil, nil, responseTriggerSceneSurpriseCallback,-1)
				-- end	
				local status = false
				if self.rewardList ~= nil then
					for i, item in pairs(self.rewardList.show_reward_list) do
						if tonumber(item.prop_type) == 6 then -- 道具
							if dms.int(dms["prop_mould"], item.prop_item, prop_mould.change_of_equipment) > 0 then -- 装备
								status = true
							elseif dms.int(dms["prop_mould"], item.prop_item, prop_mould.use_of_ship) > 0 then -- 武将
								status = true
							else
								status = true
							end	
						elseif tonumber(item.prop_type) == 7 then -- 装备
							status = true
						elseif tonumber(item.prop_type) == 13 then -- 武将
							status = true
						elseif tonumber(item.prop_type) == 4 then			--水雷魂和荣誉
							status = true
						elseif tonumber(item.prop_type) == 5 then
							status = true
						end
					end
				end
				if status == true then
					--> print("self.rewardList------------",self.rewardList)
					app.load("client.battle.BattleRewardDrop")
					local dropLayer = BattleRewardDrop:new()
					--> print("self.rewardList", self.rewardList)
					state_machine.excute("battle_reward_drop_init", 1, self.rewardList)
					fwin:open(dropLayer, fwin._view)
					
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
						ccui.Helper:seekWidgetByName(root, "Panel_2"):setVisible(false)
					else
						fwin:close(self)
					end	
				else
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						_ED._is_eve_battle = false
					end
					fwin:close(instance)
					
					
					-- 有升级,播升级
					--print("=======================",_ED.user_is_level_up)
					if true == _ED.user_is_level_up then
						fwin:open(BattleLevelUp:new(), fwin._viewdialog) 
						return
					end
					
					
					fwin:close(fwin:find("BattleSceneClass"))
					-- fwin:removeAll()
					-- cacher.removeAllObject(_object)
                	cacher.removeAllTextures()
      --           	fwin:reset(nil, nil, function( ... )
						-- -- fwin:removeAll()
						-- app.load("client.home.Menu")
						-- fwin:open(Menu:new(), fwin._taskbar)
						-- state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
      --           	end)
                	fwin:reset(nil)
						-- fwin:removeAll()
					app.load("client.home.Menu")
					fwin:open(Menu:new(), fwin._taskbar)

					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
							or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
							or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					        	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					        	then
								state_machine.excute("explore_window_open", 0, 0)
								state_machine.excute("explore_window_open_fun_window", 0, nil)
							else
								state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
							end
						else
							state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
						end
					else
						state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
					end
					-- if __lua_project_id == __lua_project_gragon_tiger_gate
						-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						-- then
						-- state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
						-- {
							-- _type 	 = LDuplicateWindow._infoDatas._type, 
							-- _sceneId = LDuplicateWindow._infoDatas._chapter
						-- })
					-- else
					
						-- local is2002 = false
						-- if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b
							 -- or __lua_project_id == __lua_project_digimon_adventure 
							 -- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
							 -- or __lua_project_id == __lua_project_naruto 
							 -- or __lua_project_id == __lua_project_pokemon 
							-- or __lua_project_id == __lua_project_rouge 
							-- or __lua_project_id == __lua_project_yugioh then
							-- if dev_version >= 2002 then
								-- is2002 = true
							-- end
						-- end
						
						-- if true == is2002 then
							-- _ED._current_scene_id = _ED._duplicate_current_scene_id
							-- _ED._current_seat_index = _ED._duplicate_current_seat_index
							-- _ED._last_page_type = 1
							
							-- state_machine.excute("menu_manager", 0, 
								-- {
									-- _datas = {
										-- terminal_name = "menu_manager", 	
										-- next_terminal_name = "menu_show_duplicate", 	
										-- current_button_name = "Button_duplicate", 	
										-- but_image = "Image_duplicate", 	
										-- terminal_state = 0, 
										-- isPressedActionEnabled = true
									-- }
								-- }
							-- )
							
							-- state_machine.excute("shortcut_open_duplicate_window", 0, nil)
						
						-- else
							-- -- 定位到副本
								-- _ED._current_scene_id = _ED._duplicate_sceneID
								-- _ED._current_seat_index = _ED._duplicate_npcIndex
								-- _ED._last_page_type = 1
								
								-- state_machine.excute("menu_manager", 0, 
									-- {
										-- _datas = {
											-- terminal_name = "menu_manager", 	
											-- next_terminal_name = "menu_show_duplicate", 
											-- current_button_name = "Button_duplicate",
											-- but_image = "Image_duplicate", 		
											-- terminal_state = 0, 
											-- isPressedActionEnabled = true
										-- }
									-- }
								-- )
							
						-- end
					-- end
				end
			end
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end
	
	
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then

	else
		ccui.Helper:seekWidgetByName(root, "Panel_2"):addTouchEventListener(backPlotScene)
		local expCount = tonumber(_ED.user_info.last_user_experience)/tonumber(_ED.user_info.last_user_grade_need_experience)*100
		ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent(expCount)
		
		local levelLabel = ccui.Helper:seekWidgetByName(root, "Text_8")
		if verifySupportLanguage(_lua_release_language_en) == true then
			if tonumber(_ED.user_info.last_user_grade_need_experience) ~= tonumber(_ED.user_info.user_grade_need_experience) then
				levelLabel:setString(_string_piece_info[6]..(tonumber(_ED.user_info.user_grade)-1))
			else
				levelLabel:setString(_string_piece_info[6].._ED.user_info.user_grade)
			end
		else
			if tonumber(_ED.user_info.last_user_grade_need_experience) ~= tonumber(_ED.user_info.user_grade_need_experience) then
				levelLabel:setString(""..(tonumber(_ED.user_info.user_grade)-1).._string_piece_info[6])
			else
				levelLabel:setString(_ED.user_info.user_grade.._string_piece_info[6])
			end
		end
	end
	-- if self.rewardList == nil then
		--> print("没有战斗奖励。")
	-- else
		
		--奖励银币
		-- ccui.Helper:seekWidgetByName(root, "Text_5"):setString(getRewardValueWithType(self.rewardList, 1))
		--奖励的经验
		-- ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..getRewardValueWithType(self.rewardList, 8))
	-- end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local npcData = dms.element(dms["npc"], _ED._scene_npc_id)
		
		local npcCurStar = tonumber(_ED.npc_state[dms.atoi(npcData, npc.id)])
		
		-- 更改为 用战场初始化信息 中场景类型来判定 绘制星星
		-- 6 为试炼 3为宝物经验
		if _ED.battleData.battle_init_type == 6 or _ED.battleData.battle_init_type == 3 or tonumber(_ED.battleData.battle_init_type) == 9 or tonumber(_ED.battleData.battle_init_type) == 10 then
			npcCurStar = 0
		end
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			npcCurStar = _ED.battle_result_star_count
			local Panel_win = ccui.Helper:seekWidgetByName(root, "Panel_win")
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_battle_win/effect_battle_win.ExportJson")
			local armature = ccs.Armature:create("effect_battle_win")
			draw.initArmatureTwo(armature, nil, 1, 0, 1, 0)
			local function changeActionCallback( armatureBack )
				draw.initArmatureTwo(armature, nil, -1, 0, 1, 1)
				self:drawWinStar(npcCurStar)
			end
			armature._invoke = changeActionCallback
			armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
			armature:setPosition(cc.p(Panel_win:getContentSize().width/2,Panel_win:getContentSize().height/2))
			Panel_win:addChild(armature)
		
			-- for i = 1, 3 do
				-- ccui.Helper:seekWidgetByName(root, string.format("Image_star_%d", i)):setVisible(i <= npcCurStar and true or false)
				-- --星星动画
			-- end
		else
			for i = 1, 3 do
				ccui.Helper:seekWidgetByName(root, string.format("Image_%d", 3+i)):setVisible(i <= npcCurStar and true or false)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
					ccui.Helper:seekWidgetByName(root, string.format("Image_%d", 11+i)):setVisible(i <= npcCurStar and true or false)
				end	
			end
		end
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		else
			if __lua_project_id == __lua_project_digimon_adventure 
				-- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_warship_girl_b
				or __lua_project_id == __lua_project_yugioh 
				then
				if npcCurStar == 1 then
					if zstring.tonumber(_ED.battleData.battle_init_type) == 0 then 
						ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[174] .. " " .. _string_piece_info[179])					--绘制奖励星数
					else
						ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_awaken_tipString_info[13] .. " " .. _awaken_tipString_info[18])					--绘制奖励星数
					end
					
				elseif npcCurStar == 2 then
					if zstring.tonumber(_ED.battleData.battle_init_type) == 0 then 
						ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[175] .. " " .. _string_piece_info[178])					--绘制奖励星数
					else
						ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_awaken_tipString_info[14] .. " " .. _awaken_tipString_info[17])					--绘制奖励星数
					end
				elseif npcCurStar == 3 then
					if zstring.tonumber(_ED.battleData.battle_init_type) == 0 then 
						ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[176] .. " " .. _string_piece_info[177])					--绘制奖励星数
					else
						ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_awaken_tipString_info[15] .. " " .. _awaken_tipString_info[16])					--绘制奖励星数
					end
				end
			else
				if npcCurStar == 1 then
					ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[174] .. " " .. _string_piece_info[179])					--绘制奖励星数
				elseif npcCurStar == 2 then
					ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[175] .. " " .. _string_piece_info[178])					--绘制奖励星数
				elseif npcCurStar == 3 then
					ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(_string_piece_info[176] .. " " .. _string_piece_info[177])					--绘制奖励星数
				end	
			end
		end

	end
	
	
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		--我方消耗
		local Text_me_loss_n = ccui.Helper:seekWidgetByName(root, "Text_me_loss_n")
		Text_me_loss_n:setString(string.format("%.0f", tonumber(_ED.fighting_loss.our_side_percentage)).."%")--临时数据
		--敌方消耗
		local Text_enemy_loss_n = ccui.Helper:seekWidgetByName(root, "Text_enemy_loss_n")
		Text_enemy_loss_n:setString(string.format("%.0f", tonumber(_ED.fighting_loss.the_enemy_percentage)).."%")

		-- 维修部队
		local Button_repair_troops = ccui.Helper:seekWidgetByName(root, "Button_repair_troops")
		fwin:addTouchEventListener(Button_repair_troops, nil, 
		{
			terminal_name = "battle_reward_service_close",
			terminal_state = 0,
			touch_scale = true,
        	touch_scale_xy = 0.95,
		}, nil, 1)

		local isHaveRepairTank = false
		for k, v in pairs(_ED.user_ship) do
	        if v.captain_type ~= 3 then
	            if tonumber(v.lose_ship_count) > 0 then
	            	isHaveRepairTank = true
	            end
	        end
	    end
		if isHaveRepairTank == true then
			Button_repair_troops:setBright(true)
			Button_repair_troops:setTouchEnabled(true)
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_battle_reward_repair",
		    _widget = Button_repair_troops,
		    _invoke = nil,
		    _interval = 0.2,})
		else
			Button_repair_troops:setBright(false)
			Button_repair_troops:setTouchEnabled(false)
		end

		if __lua_project_id == __lua_project_pacific_rim then
			stopBgm()
		end
		checkPlayEffect(46)
	end
	--[[
	local self.rewardList = nil
	
	-- 05-17记录:试练塔胜利失败给的是普通副本的奖励-----
	self.rewardList = getSceneReward(2)
	----------------------------------------------------
	
	--奖励银币
	local rewardMoney = BattleReward._widget:getWidgetByName("Label_money_value")
	draw.text(rewardMoney,getRewardValueWithType(self.rewardList, 1))
	
	--奖励将魂
	local rewardSoul = BattleReward._widget:getWidgetByName("Label_fragment_value")
	draw.text(rewardSoul,getRewardValueWithType(self.rewardList, 4))
	
	
	--奖励的经验
	local rewardExp = BattleReward._widget:getWidgetByName("Label_1101")
	local rewardExpInfo = getRewardValueWithType(self.rewardList, 8)
	draw.text(rewardExp,""..rewardExpInfo)
	
	--绘制物品奖励
	local itemRewardList = BattleReward._widget:getWidgetByName("ScrollView_1140")
	
		--绘制星星的方法
	local function drawCellStar(cell,Maxcount,count)
		local startListView = ListView:create()
		local starImange = ImageView:create()
		startListView:setItemModel(starImange)
		for i=1,Maxcount do
			if count>=i then
				starImange:loadTexture("images/ui/state/o_stars.png")
			else
				starImange:loadTexture("images/ui/state/c_stars.png")
			end
			startListView:setDirection(ccui.ListViewDirection.horizontal)
			startListView:setSize(ccuiizeMake(starImange:getSize().width * Maxcount,starImange:getSize().height))
			startListView:setPosition(ccp(-startListView:getSize().width/2+starImange:getSize().width/4,-starImange:getSize().height/2))
			startListView:pushBackDefaultItem()	
		end
		cell:addChild(startListView)
	end
	local shareButton = tolua.cast(BattleReward._uiLayer:getWidgetByName("Button_fenxiang"),"Button")
	draw.setButtonTouchEnabled(shareButton, false)
	
	local confirmButton = tolua.cast(BattleReward._uiLayer:getWidgetByName("Button_1119"),"Button")
	
	if __lua_project_id == __lua_project_all_star then
		draw.setVisible(BattleReward._uiLayer, "Button_1119", false)
	end
	
	draw.setButtonTouchEnabled(confirmButton, false)
	confirmButton:addTouchEventListener(backPlotScene)
	local expLoadingButton = tolua.cast(BattleReward._uiLayer:getWidgetByName("LoadingBar_1115"),"LoadingBar")
	local expCount = tonumber(LuaClasses["BattleSceneClass"]._lastExp)/tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp)*100
	expLoadingButton:setPercent(expCount)
 
	local rewardExpCount = tonumber(getRewardValueWithType(self.rewardList, 8))/tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp)*100
	local isLevelup = false
	local levelLabel = tolua.cast(BattleReward._uiLayer:getWidgetByName("LabelAtlas_1113"),"LabelAtlas")
	local function update(delta)
		local sc = 3
		if (100-expCount)< 3 then
			sc = 100-expCount
		end
		if rewardExpCount < sc then
			sc = rewardExpCount
		end
		rewardExpCount = rewardExpCount - sc
		
		if rewardExpCount<sc then
			expCount = tonumber(_ED.user_info.user_experience)/tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp)*100
		else
			expCount = expCount + sc
		end
        if expCount >= 100 then
			isLevelup = true
            expCount = 0
			rewardExpCount = rewardExpCount * tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp) / tonumber(_ED.user_info.user_grade_need_experience)
		end
		
		if tonumber(_ED.user_info.user_experience) == 0 and rewardExpCount > 0 then
			isLevelup = true
		end
		if (tonumber(LuaClasses["BattleSceneClass"]._lastExp)+rewardExpInfo)/tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp)*100 >= 100 then
			isLevelup = true
		end
		
		if rewardExpCount <= 0 then
			self:unscheduleUpdate()
			draw.setButtonTouchEnabled(confirmButton, true)
			if isLevelup == true then
				require "script/transformers/battle/BattleLevelUp"	
				levelLabel:setStringValue(_ED.user_info.user_grade)
				LuaClasses["BattleLevelUpClass"]._rewardInfo = getSceneReward(3)
				if LuaClasses["BattleLevelUpClass"]._rewardInfo ~= nil then
					LuaClasses["BattleLevelUpClass"].Draw(scene)
				end
			end
			
			if __lua_project_id == __lua_project_all_star then
				draw.setVisible(BattleReward._uiLayer, "Button_1119", true)
			end
			
		end
		
        if self._uiLayer ~= nil then
            expLoadingButton:setPercent(expCount)
        end
    end

    self:scheduleUpdateWithPriorityLua(update, 0)
		
	local function onNodeEvent(tag)
        if tag == "exit" then
            self:unscheduleUpdate()
        end
    end

    self:registerScriptHandler(onNodeEvent)
	
	if tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp) ~= tonumber(_ED.user_info.user_grade_need_experience) then
		levelLabel:setStringValue(tonumber(_ED.user_info.user_grade)-1)
	else
		levelLabel:setStringValue(tonumber(_ED.user_info.user_grade))
	end
	
	local fightRewardStar = BattleReward._uiLayer:getWidgetByName("ImageView_1086")
	
	local npcData = elementAt(NPC, tonumber(_ED._scene_npc_id))
	local maxStar = npcData:atoi(npc.difficulty_include_count)
	
	local npcCurStar = tonumber(_ED.npc_state[npcData:atoi(npc.id)])
	
	-- 更改为 用战场初始化信息 中场景类型来判定 绘制星星
	-- 6 为试炼 3为宝物经验
	if _ED.battleData.battle_init_type == 6 or _ED.battleData.battle_init_type == 3 then
		npcCurStar = 0
		maxStar = 3
	end
	
	drawCellStar(fightRewardStar, maxStar, npcCurStar)
	
	local function calculateIconType(number)
		local iconid = 3009
		if number >=1 and number<=9999 then
			iconid = 3009
		elseif number>=10000 and number<=99999 then
			iconid = 3011
		elseif number >=100000 then
			iconid = 3013
		end
		return iconid
	end
	
	ActionManager:shareManager():playActionByName("interface/victory_in_battle.json","Animation0")
	
	GUIReader:shareReader():widgetFromCacheJsonFile("interface/victory_in_battle.json", "Panel_850", -1)
	
	GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 0)
	local itemIndex = 4
	local itemIndexCount = 4
	local itemWidth = 0
	local itemWidthPlace = 0
	for i, item in pairs(self.rewardList.show_reward_list) do
		if tonumber(item.prop_type) == 6 then
			itemIndexCount = itemIndexCount + 1
		elseif tonumber(item.prop_type) == 7 then
			if tonumber(item.item_value) >= 10 then
				itemIndexCount = itemIndexCount + 1
			else
				for j = 1 , tonumber(item.item_value) do
					itemIndexCount = itemIndexCount + 1
				end
			end
		elseif tonumber(item.prop_type) == 13 then
			if tonumber(item.item_value) >= 10  then
				itemIndexCount = itemIndexCount + 1
			else
				for j = 1 , tonumber(item.item_value) do
					itemIndexCount = itemIndexCount + 1
				end
			end
		end
		local itemOffsety = nil
		if __lua_project_id == __lua_project_all_star then
			itemOffsety = math.ceil(itemIndexCount/3)-1
		else
			itemOffsety = math.ceil(itemIndexCount/3)-2
		end
		if tonumber(itemOffsety)*60 >= itemRewardList:getSize().height then
			tolua.cast(itemRewardList,"ScrollView"):setInnerContainerSize(ccuiize(itemRewardList:getSize().width, tonumber(itemOffsety)*60))
			itemWidthPlace = tonumber(itemOffsety)*60
		else
			itemWidthPlace = itemRewardList:getSize().height
		end
	end
	
	for i, item in pairs(self.rewardList.show_reward_list) do
	
		if tonumber(item.prop_type) == 6 then
			local itemCell = draw.drawGiftPropIcon(item.prop_item, tonumber(item.item_value))
			local itemOffsety = math.ceil(itemIndex/3)-2
			if __lua_project_id == __lua_king_of_adventure 
			or __lua_project_id == __lua_project_koone then
				itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*58,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
			else
				itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*80,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
			end
			itemRewardList:addChild(itemCell)
			itemWidth = itemCell:getSize().height
			itemIndex = itemIndex + 1
		elseif tonumber(item.prop_type) == 7 then
			if tonumber(item.item_value) >= 10 then
				local itemCell = draw.drawGiftEquipIcon(item.prop_item, tonumber(item.item_value))
				local itemOffsety = math.ceil(itemIndex/3)-2
				if __lua_project_id == __lua_king_of_adventure 
				or __lua_project_id == __lua_project_koone then
					itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*58,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
				else
					itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*80,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
				end
				itemRewardList:addChild(itemCell)
				itemWidth = itemCell:getSize().height
				itemIndex = itemIndex + 1
			else
				for j = 1 , tonumber(item.item_value) do
					local itemCell = draw.drawGiftEquipIcon(item.prop_item, 0)
					local itemOffsety = math.ceil(itemIndex/3)-2
					if __lua_project_id == __lua_king_of_adventure 
					or __lua_project_id == __lua_project_koone then
						itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*58,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
					else
						itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*80,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
					end
					itemRewardList:addChild(itemCell)
					itemWidth = itemCell:getSize().height
					itemIndex = itemIndex + 1
				end
			end
		elseif tonumber(item.prop_type) == 13 then
			if tonumber(item.item_value) >= 10  then
				local itemCell = draw.drawGiftHeroIcon(item.prop_item)
				local itemOffsety = math.ceil(itemIndex/3)-2
				if __lua_project_id == __lua_king_of_adventure 
				or __lua_project_id == __lua_project_koone then
					itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*58,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
				else
					itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*80,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
				end
				itemRewardList:addChild(itemCell)
				itemWidth = itemCell:getSize().height
				itemIndex = itemIndex + 1
			else
				for j = 1 , tonumber(item.item_value) do
					local itemCell = draw.drawGiftHeroIcon(item.prop_item)
					local itemOffsety = math.ceil(itemIndex/3)-2
					if __lua_project_id == __lua_king_of_adventure 
					or __lua_project_id == __lua_project_koone then
						itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*58,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
					else
						itemCell:setPosition(ccp(itemCell:getPositionX()+10+((itemIndex-1)%3)*80,itemWidthPlace-itemCell:getSize().height-tonumber(itemOffsety)*60))
					end
					itemRewardList:addChild(itemCell)
					itemWidth = itemCell:getSize().height
					itemIndex = itemIndex + 1
				end
			end
		end
	end	]]
end

function BattleReward:onExit()
	state_machine.remove("battle_reward_repeat_attack")
	state_machine.remove("battle_reward_next_attack")

end
-- END
-- ----------------------------------------------------------------------------------------------------