-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束奖励物品显示界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------				
BattleRewardDrop = class("BattleRewardDropClass", Window)

local is2002 = false
if __lua_project_id == __lua_project_warship_girl_a 
or __lua_project_id == __lua_project_warship_girl_b
or __lua_project_id == __lua_project_digimon_adventure 
or __lua_project_id == __lua_project_red_alert_time 
or __lua_project_id == __lua_project_pacific_rim  
or __lua_project_id == __lua_project_naruto 
or __lua_project_id == __lua_project_pokemon 
or __lua_project_id == __lua_project_rouge 
or __lua_project_id == __lua_project_yugioh 
or __lua_project_id == __lua_project_koone 
then
	if dev_version >= 2002 then
		is2002 = true
	end
end
function BattleRewardDrop:ctor()
	self.super:ctor()
	
	self.roots = {}
	
	self.hasEquip = false -- 装备
	self.hasShip = false -- 在这里，武将碎片归类与武将，而不是道具
	self.hasProp = false -- 道具
	self.hasThunder = false -- 水雷魂
	self.thunderList = {}
	self.hasHonour = false -- 荣誉(舾装分解)
	self.honourList = {}
	self.equipList = {}
	self.equipListProp = {}
	self.shipList = {}
	self.shipListProp = {}
	self.propList = {}
	self.all = {}
	self.allStatus = {}
	self.num = 1
	self.numTwo = 1
	
	self.dropItems = {}
	
	self.dropItemsProp = {}
	self.dropItemsShip = {}
	self.dropItemsEquip = {}
	self.isPlayDrawDropAction = false
	self.isDrawDropBoxProp = false
	self.isDrawDropBoxShip = false
	self.isDrawDropBoxEquip = false
	self.dropBoxListIndex = 1
	self.dropBoxList = {}
	self.dropItemsPropIndex = 1
	self.dropItemsShipIndex = 1
	self.dropItemsEquipIndex = 1
	self.dropItemsCount = 0
	 
	
	self._interval = 0
	app.load("client.campaign.worldboss.BetrayArmyNpcArrival")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.battle.BattleRewardDropIcon")
	app.load("client.battle.BattleRewardDropIconBox")
	app.load("client.battle.BattleLevelUp")
	
	
	local function init_battle_reward_drop_terminal()
		local battle_reward_drop_close_terminal = {
            _name = "battle_reward_drop_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.dropItemsCount > 0 then
            		return false
            	end
				fwin:close(instance)
				
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then
					fwin:close(fwin:find("BattleRewardClass"))
				end
				
				fwin:close(fwin:find("BattleSceneClass"))
				
				-- 有升级,播升级
				if true == _ED.user_is_level_up then
					fwin:open(BattleLevelUp:new(), fwin._viewdialog) 
					return
				end

				
				-- fwin:open(Menu:new(), fwin._taskbar)
				-- state_machine.excute("menu_manager", 1, {_datas = {next_terminal_name = "menu_show_home_page", but_image = 1}})
				-- fwin:removeAll()
				-- cacher.removeAllObject(_object)
				fwin:close(fwin:find("BattleSceneClass"))
                cacher.removeAllTextures()
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
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		local battle_reward_drop_init_terminal = {
            _name = "battle_reward_drop_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- params -- rewardList
				-- prop_item, prop_type, item_value
				for i, item in pairs(params.show_reward_list) do
					if tonumber(item.prop_type) == 6 then -- 道具
						if dms.int(dms["prop_mould"], item.prop_item, prop_mould.change_of_equipment) > 0 then -- 装备
							self.hasProp = true
							table.insert(self.equipListProp, item)
						elseif dms.int(dms["prop_mould"], item.prop_item, prop_mould.use_of_ship) > 0 
							and dms.int(dms["prop_mould"], item.prop_item, prop_mould.props_type) ~= 16 
						 then -- 武将
							self.hasProp = true
							table.insert(self.shipListProp, item)
						else
							self.hasProp = true
							table.insert(self.propList, item)
						end	
					elseif tonumber(item.prop_type) == 7 then -- 装备
						self.hasEquip = true
						table.insert(self.equipList, item)
					elseif tonumber(item.prop_type) == 13 then -- 武将
						self.hasShip = true
						table.insert(self.shipList, item)
					elseif tonumber(item.prop_type) == 4 then
						self.hasHonour = true
						table.insert(self.honourList, item)
					elseif tonumber(item.prop_type) == 5 then
						self.hasThunder = true
						table.insert(self.thunderList, item)
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		local battle_reward_drop_draw_terminal = {
            _name = "battle_reward_drop_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if true == is2002 then
					instance:drawDropAction()
				else
					instance:drawDropAll()
				end
				self.dropItemsCount = self.dropItemsCount - 1
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		local battle_reward_drop_repeat_attack_terminal = {
		    _name = "battle_reward_drop_repeat_attack",
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
								_ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0, resultBuffer)
								local orderList = {}
								_ED._fightModule:initFightOrder(_ED.user_info, orderList)

								responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
							end
                        end
                        protocol_command.battle_result_start.param_list = "".._enum_fight_type._fight_type_0.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
                        NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)

					end
					launchBattle()

		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		local battle_reward_drop_next_attack_terminal = {
	    _name = "battle_reward_prop_next_attack",
	    _init = function (terminal) 
	        
	    end,
	    _inited = false,
	    _instance = self,
	    _state = 0,
	    _invoke = function(terminal, instance, params)
	    	local currentNpcID = tonumber(_ED._scene_npc_id)
			 
			local next_npc_id = dms.int(dms["npc"],currentNpcID,npc.next_npc_id)
    		local next_NpcSceneID = dms.int(dms["npc"],next_npc_id,npc.scene_id)
    		if next_npc_id == -1 then
    			return
    		end
			if next_NpcSceneID == -1 then
				return
			end
			
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

		state_machine.add(battle_reward_drop_close_terminal)
		state_machine.add(battle_reward_drop_init_terminal)
		state_machine.add(battle_reward_drop_draw_terminal)
		state_machine.add(battle_reward_drop_repeat_attack_terminal)
		state_machine.add(battle_reward_drop_next_attack_terminal)
        state_machine.init()
	end
	
	init_battle_reward_drop_terminal()
end	

function BattleRewardDrop:onUpdate(dt)
	-- self._interval = self._interval + dt
	-- if self._interval >= 2 then
		-- local root = self.roots[1]
		-- ccui.Helper:seekWidgetByName(root, "Panel_9"):setVisible(true)
	-- end
	-- if self.dropItemsCount > 0 and self._interval >= 3 and (#self.dropItemsProp == 0 and self.dropItemsShip == 0 and #self.dropItemsEquip == 0)  then
	-- 	self.dropItemsCount = 0
	-- 	local root = self.roots[1]
	-- 	ccui.Helper:seekWidgetByName(root, "Panel_9"):setVisible(true)
	-- end
	
 	if self.openTime ~= nil then
		local t = os.time() - self.openTime
		if t >= 5 or self.dropItemsCount <= 0 then
			self.close_tip:setVisible(true)
			self.close_pad:setTouchEnabled(true)
		end
	end
	
	if true == self.isPlayDrawDropAction then
		local root = self.roots[1]
		if #self.dropItemsProp > 0 then
			if false == self.isDrawDropBoxProp  then
				self.isDrawDropBoxProp = true 
				
				local iconBox = BattleRewardDropIconBox:createCell()
				iconBox:init(1)
				self.dropBoxList[self.dropBoxListIndex]:addChild(iconBox)
				self.dropBoxListIndex = self.dropBoxListIndex +1
			end

			local cell = table.remove(self.dropItemsProp, 1, 1)
			local pathName =  string.format("Panel_%d_%d", self.dropBoxListIndex - 1, self.dropItemsPropIndex)
			local sp = self.dropBoxList[self.dropBoxListIndex - 1]
			local ep = ccui.Helper:seekWidgetByName(root, pathName)
			if nil ~= ep and  nil ~= sp and nil ~= cell then
				self.dropItemsPropIndex =  self.dropItemsPropIndex +1
				self:playDrawDropAction(sp,ep,cell)
				
			end
		elseif #self.dropItemsShip > 0 then
			if false == self.isDrawDropBoxShip  then
				self.isDrawDropBoxShip = true 
				
				local iconBox = BattleRewardDropIconBox:createCell()
				iconBox:init(2)
				self.dropBoxList[self.dropBoxListIndex]:addChild(iconBox)
				self.dropBoxListIndex = self.dropBoxListIndex +1
			end
			
			
			local cell = table.remove(self.dropItemsShip, 1, 1)
			local pathName =  string.format("Panel_%d_%d", self.dropBoxListIndex - 1, self.dropItemsShipIndex)
			local sp = self.dropBoxList[self.dropBoxListIndex - 1]
			local ep = ccui.Helper:seekWidgetByName(root, pathName)
			
			if nil ~= ep and  nil ~= sp and nil ~= cell then
				self.dropItemsShipIndex =  self.dropItemsShipIndex +1
				self:playDrawDropAction(sp,ep,cell)
				
			end
			
		elseif #self.dropItemsEquip > 0 then
			if false == self.isDrawDropBoxEquip  then
				self.isDrawDropBoxEquip = true 
				
				local iconBox = BattleRewardDropIconBox:createCell()
				iconBox:init(3)
				self.dropBoxList[self.dropBoxListIndex]:addChild(iconBox)
				self.dropBoxListIndex = self.dropBoxListIndex +1
			end
			
			local cell = table.remove(self.dropItemsEquip, 1, 1)
			local pathName =  string.format("Panel_%d_%d", self.dropBoxListIndex - 1, self.dropItemsEquipIndex)
			local sp = self.dropBoxList[self.dropBoxListIndex - 1]
			local ep = ccui.Helper:seekWidgetByName(root, pathName)
			
			if nil ~= ep and  nil ~= sp and nil ~= cell then
				self.dropItemsEquipIndex =  self.dropItemsEquipIndex +1
				self:playDrawDropAction(sp,ep,cell)
			end
		else
			
			self.isPlayDrawDropAction = false
		
		end
	end
end

function BattleRewardDrop:drawDropAll()
	
	if table.getn(self.dropItems) > 0 then
		local tempCell = self.dropItems[1]
		tempCell._listView:addChild(tempCell.cell)
		tempCell.cell:release()
		tempCell._listView:requestRefreshView()
		table.remove(self.dropItems, "1")
	end
end


function BattleRewardDrop:playDrawDropAction(sp,ep,cell)
	self.isPlayDrawDropAction = false 
	
	local sx,sy = sp:getPosition()
	local ex,ey = ep:getPosition()
	
	self.close_pad:addChild(cell)
	
	cell:setPosition(cc.p(sx, sy))
	
	local _self = self
	local function keepOverFunc ()
		_self.isPlayDrawDropAction = true
		playEffect(formatMusicFile("button", 4))
		-- _self.dropItemsCount = _self.dropItemsCount - 1
		-- print("_self.dropItemsCount:", _self.dropItemsCount)
		-- if _self.dropItemsCount <= 0 then
		-- 	local root = _self.roots[1]
		-- 	ccui.Helper:seekWidgetByName(root, "Panel_9"):setVisible(true)
		-- end
		
		local dropItemsPropIndex = self.dropItemsPropIndex-1
		local dropItemsShipIndex = self.dropItemsShipIndex-1
		local dropItemsEquipIndex = self.dropItemsEquipIndex-1
		if #self.dropItems - 1 == dropItemsPropIndex + dropItemsShipIndex + dropItemsEquipIndex then
			_self.close_tip:setVisible(true)
			_self.close_pad:setTouchEnabled(true)
		end
	end
	cell:runAction(cc.Sequence:create(cc.MoveTo:create(0.2*(self.dropBoxListIndex - 1), cc.p(ex,ey)),cc.CallFunc:create(keepOverFunc)))
end
		

function BattleRewardDrop:drawDropAction()
	self.isPlayDrawDropAction = true 
end
				

function BattleRewardDrop:onEnterTransitionFinish()
	local csbDrop = csb.createNode("battle/victory_in_battle_drop.csb")
    self:addChild(csbDrop)
	
	local root = csbDrop:getChildByName("root")
	table.insert(self.roots, root)
	
	
	self.dropBoxList = {
		ccui.Helper:seekWidgetByName(root, "Panel_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_4"),
		ccui.Helper:seekWidgetByName(root, "Panel_5"),
	}
	self.close_tip = ccui.Helper:seekWidgetByName(root, "Panel_9")
	self.close_tip:setVisible(false)

	local close_pad = ccui.Helper:seekWidgetByName(root, "Panel_2")
	self.close_pad = close_pad
	self.close_pad:setTouchEnabled(false)
	fwin:addTouchEventListener(close_pad, nil, {terminal_name = "battle_reward_drop_close", terminal_state = 1, touch_scale = false}, nil, 0)
	--> print("self.hasEquipself.hasEquipself.hasEquip,,,,,,,,,",self.hasEquip,self.hasShip,self.hasProp)
	local typeIndex = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local Button_chongfutiaozhan = ccui.Helper:seekWidgetByName(root,"Button_chongfutiaozhan")
		local Button_xiayizhan = ccui.Helper:seekWidgetByName(root,"Button_xiayizhan")	
		fwin:addTouchEventListener(Button_chongfutiaozhan, nil, 
        {
            terminal_name = "battle_reward_drop_repeat_attack",
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, nil, 0)
        fwin:addTouchEventListener(Button_xiayizhan, nil, 
        {
            terminal_name = "battle_reward_prop_next_attack",
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, nil, 0)	
		
		if true == _ED.user_is_level_up or _ED._is_eve_battle == true or tonumber(_ED._current_scene_type) == 3 then
			Button_chongfutiaozhan:setVisible(false)
			Button_xiayizhan:setVisible(false)
			_ED._is_eve_battle = false
		elseif false == _ED.user_is_level_up and _ED._is_eve_battle == false then
			Button_chongfutiaozhan:setVisible(true)
			Button_xiayizhan:setVisible(true)
		end
		local next_npc_id = dms.int(dms["npc"], _ED._scene_npc_id, npc.next_npc_id)
		local next_NpcSceneID = dms.int(dms["npc"], next_npc_id, npc.scene_id)
		if next_npc_id == -1 or next_NpcSceneID == -1 then
			Button_xiayizhan:setVisible(false)
		end

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        	then
	        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
				or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 
				or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
	        	if nil ~= Button_chongfutiaozhan then
	        		Button_chongfutiaozhan:setVisible(false)
	        	end
	        	if nil ~= Button_xiayizhan then
	        		Button_xiayizhan:setVisible(false)
	        	end
			end
		end
	end
	if self.hasShip == true then
		-- draw type
		typeIndex = typeIndex + 1
		ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_%d", 2+typeIndex)):setBackGroundImage("images/ui/battle/diaoluo_wujiang_small.png")

		
		for i, v in ipairs(self.shipList) do
			--> print("武将获得", v.prop_item, v.item_value)
			-- draw icon and insert
			for m = 1, zstring.tonumber(v.item_value) do
				local cell = BattleRewardDropIcon:createCell()
				local tables = {nil, 9, v.prop_item}
				cell:init(tables, 2)
				cell:retain()
				table.insert(self.dropItems, {cell = cell, _listView = ccui.Helper:seekWidgetByName(self.roots[1], string.format("ListView_%d", typeIndex))})
				
				table.insert(self.dropItemsShip, cell)
			end
		end
	end
	
	if self.hasProp == true then
		-- draw type
		typeIndex = typeIndex + 1
		ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_%d", 2+typeIndex)):setBackGroundImage("images/ui/battle/diaoluo_daoju_small.png")
		
		-- draw list
		for i, v in ipairs(self.propList) do
			--> print("道具获得", v.prop_item, v.item_value)
			-- draw icon and insert
			for m = 1, zstring.tonumber(v.item_value) do
				local cell = BattleRewardDropIcon:createCell()
				local tables = {15, v.prop_item}
				cell:init(tables, 1)
				--> print("道具获得3", v.prop_item, v.item_value)
				cell:retain()
				--> print("道具获得5", v.prop_item, v.item_value)
				table.insert(self.dropItems, {cell = cell, _listView = ccui.Helper:seekWidgetByName(self.roots[1], string.format("ListView_%d", typeIndex))})
				
				table.insert(self.dropItemsProp,cell)
			end
		end
		
				
		-- draw list
		for i, v in ipairs(self.shipListProp) do
			--> print("武将碎片获得", v.prop_item, v.item_value)

			for m = 1, zstring.tonumber(v.item_value) do
				local cell = BattleRewardDropIcon:createCell()
				local tables = {19,v.prop_item}
				cell:init(tables, 1)
				cell:retain()
				table.insert(self.dropItems, {cell = cell, _listView = ccui.Helper:seekWidgetByName(self.roots[1], string.format("ListView_%d", typeIndex))})
				
				table.insert(self.dropItemsShip, cell)
			end
		end
		
		-- draw list
		for i, v in ipairs(self.equipListProp) do
			--> print("装备碎片获得", v.prop_item, v.item_value)
			-- draw icon and insert
			for m = 1, zstring.tonumber(v.item_value) do
				local cell = BattleRewardDropIcon:createCell()
				local tables = {19, v.prop_item}
				cell:init(tables, 1)
				cell:retain()
				table.insert(self.dropItems, {cell = cell, _listView = ccui.Helper:seekWidgetByName(self.roots[1], string.format("ListView_%d", typeIndex))})
				
				table.insert(self.dropItemsEquip, cell)
			end
		end
		
	end
	
	if self.hasHonour == true then
		typeIndex = typeIndex + 1
		ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_%d", 2+typeIndex)):setBackGroundImage("images/ui/battle/diaoluo_daoju_small.png")
		for i, v in ipairs(self.honourList) do
			-- for m = 1, zstring.tonumber(v.item_value) do
				local cell = BattleRewardDropIcon:createCell()
				local tables = {4, v.item_value}
				cell:init(tables, 4)
				cell:retain()
				table.insert(self.dropItems, {cell = cell, _listView = ccui.Helper:seekWidgetByName(self.roots[1], string.format("ListView_%d", typeIndex))})
				
				table.insert(self.dropItemsProp, cell)
			-- end
		end
	end
	
	if self.hasThunder == true then
		typeIndex = typeIndex + 1
		ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_%d", 2+typeIndex)):setBackGroundImage("images/ui/battle/diaoluo_daoju_small.png")
		for i, v in ipairs(self.thunderList) do
			-- draw icon and insert
			-- for m = 1, zstring.tonumber(v.item_value) do
				local cell = BattleRewardDropIcon:createCell()
				local tables = {5, v.item_value}
				cell:init(tables, 5)
				cell:retain()
				table.insert(self.dropItems, {cell = cell, _listView = ccui.Helper:seekWidgetByName(self.roots[1], string.format("ListView_%d", typeIndex))})
			
				table.insert(self.dropItemsProp, cell)
			-- end
		end
	end
	
	if self.hasEquip == true then
		-- draw type
		typeIndex = typeIndex + 1
		ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_%d", 2+typeIndex)):setBackGroundImage("images/ui/battle/diaoluo_zhuangbei_small.png")
		
		
		
		for i, v in ipairs(self.equipList) do
			--> print("装备获得", v.prop_item, v.item_value)
			-- draw icon and insert
			for m = 1, zstring.tonumber(v.item_value) do
				local cell = BattleRewardDropIcon:createCell()
				local tables = {8,nil,v.prop_item}
				cell:init(tables, 3)
				cell:retain()
				table.insert(self.dropItems, {cell = cell, _listView = ccui.Helper:seekWidgetByName(self.roots[1], string.format("ListView_%d", typeIndex))})
				
				table.insert(self.dropItemsEquip, cell)
			end
		end
	end
	
	-- 记录界面展开的时间
	self.openTime = os.time()
	
	self.dropItemsCount = #self.dropItems
	state_machine.excute("battle_reward_drop_draw", 0, "")
end

function BattleRewardDrop:onExit()
	state_machine.remove("battle_reward_drop_close")
	state_machine.remove("battle_reward_drop_init")
	state_machine.remove("battle_reward_drop_draw")
	state_machine.remove("battle_reward_drop_repeat_attack")
	state_machine.remove("battle_reward_drop_next_attack")
end