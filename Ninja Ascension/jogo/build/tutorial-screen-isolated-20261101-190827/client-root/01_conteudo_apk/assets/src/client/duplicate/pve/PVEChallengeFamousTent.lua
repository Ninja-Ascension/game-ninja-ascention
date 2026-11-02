-- ----------------------------------------------------------------------------------------------------
-- 说明：帐篷挑战界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PVEChallengeFamousTent = class("PVEChallengeFamousTentClass", Window)
    

function PVEChallengeFamousTent:ctor()
    self.super:ctor()
	app.load("client.battle.fight.FightEnum")
	app.load("client.battle.BattleStartEffect")
	app.load("client.duplicate.MoppingResults")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	self.roots = {}
	self.actions = {}
	
    -- Initialize PVEChallengeFamousTent page state machine.
    local function init_guan_qia_terminal()
		--关卡界面的返回按钮
		local pve_challenge_famous_tent_back_terminal = {
            _name = "pve_challenge_famous_tent_back",
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
		
		--关卡界面的挑战按钮
		local pve_challenge_famous_tent_challenge_terminal = {
            _name = "pve_challenge_famous_tent_challenge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 	
				instance:launchFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	
		-- local formation_make_war_cancel_terminal = {
            -- _name = "formation_make_war_cancel",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 	
				-- local Win = fwin:find("PVEChallengeFamousTentClass") 
				-- if nil ~= Win then
					-- Win.fbut._locked = false
				-- end
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(formation_make_war_cancel_terminal)
		state_machine.add(pve_challenge_famous_tent_back_terminal)
		state_machine.add(pve_challenge_famous_tent_challenge_terminal)
		-- state_machine.add(pve_challenge_famous_formation_terminal)
        state_machine.init()
    end
    
    -- call func init guan qia state machine.
    init_guan_qia_terminal()
end


function PVEChallengeFamousTent:onUpdateDraw()
	local root = self.roots[1]
	
	-- 头像
	local Panel_npcHead = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4")
	local npcIconIndex = dms.int(dms["npc"], self.npcID, npc.head_pic) -1000
	local npcHead = ""
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		npcHead = string.format("images/face/big_head/big_head_%d.png", npcIconIndex)
	else
		npcHead = string.format("images/face/card_head/card_head_%d.png", npcIconIndex)
	end
	Panel_npcHead:setBackGroundImage(npcHead)
	-- 描述
	local Text_sign_msg = ccui.Helper:seekWidgetByName(self.roots[1], "Text_3")
	local signMsg = dms.string(dms["pve_scene"], self.sceneID, pve_scene.brief_introduction)
	Text_sign_msg:setString(signMsg)
	-- 名字
	local Text_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_12")
	local namet = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
	Text_name:setString(namet)
	
	--绘制奖励
	local rewardID = dms.int(dms["npc"], self.npcID, npc.first_reward)
	
	if rewardID > 0 then
	-------------------------------------------------------------------
		local rewardTotal = 1
		local rewardMoney = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_silver))
		local rewardGold = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_gold))
		local rewardHonor = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_honor))
		local rewardSoul = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul))
		local rewardJade = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade))
		local rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_prop)
		local rewardEquListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_equipment)
		local rewardShipListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_ship)
		local rewardMaxJade = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade_max))
		local rewardMaxSoul = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul_max))
		
		local count = 1
		if rewardMoney > 0 then
			if count <= 4 then
				local reward = ResourcesIconCell:createCell()
				reward:init(1, rewardMoney, -1)
				local rewardPanel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_icon_%d",count))
				rewardPanel:addChild(reward)
				count = count + 1
			end
		end
		
		if rewardGold > 0 then
			if count <= 4 then
				local reward = ResourcesIconCell:createCell()
				reward:init(2, rewardGold, -1)
				local rewardPanel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_icon_%d",count))
				rewardPanel:addChild(reward)
				count = count + 1
			end	
		end
		
		if rewardHonor > 0 then
			if count <= 4 then
				local reward = ResourcesIconCell:createCell()
				reward:init(3, rewardHonor, -1)
				local rewardPanel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_icon_%d",count))
				rewardPanel:addChild(reward)
				count = count + 1
			end	
		end
		
		if rewardSoul > 0 then
			if count <= 4 then
				local reward = ResourcesIconCell:createCell()
				reward:init(4, rewardSoul, -1)
				local rewardPanel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_icon_%d",count))
				rewardPanel:addChild(reward)
				count = count + 1
			end	

		else
			
		end

		if rewardJade~=nil and rewardJade > 0 then
			if count <= 4 then
				local reward = ResourcesIconCell:createCell()
				reward:init(5, rewardJade, -1)
				local rewardPanel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_icon_%d",count))
				rewardPanel:addChild(reward)
				count = count + 1
			end	
		end

		--绘制道具
		if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
		------------------------------------------------------------
			local rewardProp = zstring.split(rewardItemListStr, "|")
			if table.getn(rewardProp) > 0 then
				for i,v in pairs(rewardProp) do
					local rewardPropInfo = zstring.split(v, ",")
					if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
						if count <= 4 then
							local reward = PropIconCell:createCell()
							local reawrdID = tonumber(rewardPropInfo[2])
							local rewardNum = tonumber(rewardPropInfo[1])
							reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum}, nil, false)
							local rewardPanel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_icon_%d",count))
							rewardPanel:addChild(reward)
							count = count + 1
						end	
					end
				end
			end
		--------------------------------------------------------
		end
		
		--绘制装备
		if rewardEquListStr ~= nil and rewardEquListStr ~= 0 and rewardEquListStr ~= "" then
		------------------------------------------------------------
			local rewardProp = zstring.split(rewardEquListStr, "|")
			if table.getn(rewardProp) > 0 then
				for i,v in pairs(rewardProp) do
					local rewardPropInfo = zstring.split(v, ",")
					if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
						if count <= 4 then
							local reawrdID = tonumber(rewardPropInfo[2])
							local rewardNum = tonumber(rewardPropInfo[1])*doublePower
							local tmpTable = {
								user_equiment_template = reawrdID,
								mould_id = reawrdID,
								user_equiment_grade = 1
							}
							
							local eic = EquipIconCell:createCell()
							eic:init(10, tmpTable, reawrdID, nil, false, rewardNum)
							local rewardPanel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_icon_%d",count))
							rewardPanel:addChild(reward)
							count = count + 1
						end	
					end
				end
			end
		--------------------------------------------------------
		end
		
		--奖励武将 rewardShipListStr
		if rewardShipListStr ~= nil and rewardShipListStr ~= 0 and rewardShipListStr ~= "" then
		------------------------------------------------------------
			local rewardProp = zstring.split(rewardShipListStr, "|")
			if table.getn(rewardProp) > 0 then
				for i,v in pairs(rewardProp) do
					local rewardPropInfo = zstring.split(v, ",")
					if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
						-- app.load("client.cells.prop.prop_icon_cell")
						-- 等级,数量,id,概率
						if count <= 4 then
							local reward = ShipHeadCell:createCell()
							local reawrdID = tonumber(rewardPropInfo[3])
							local rewardLv = tonumber(rewardPropInfo[1])
							local rewardNums = tonumber(rewardPropInfo[2])
							reward:init(nil,13, reawrdID,rewardNums)
							local rewardPanel = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_icon_%d",count))
							rewardPanel:addChild(reward)
							count = count + 1
						end	
					end
				end
			end
		--------------------------------------------------------
		end
	-------------------------------------------------------------------
	end
	
	

	

	
	-- 战斗次数
	local totalAttackTimes = dms.int(dms["npc"], self.npcID, npc.daily_attack_count)
	local surplusAttackCount = _ED.npc_current_attack_count[tonumber(self.npcID)]
	self.maxAttackCount = tonumber(totalAttackTimes)
	self.currentAttackTimes = tonumber(surplusAttackCount)
end


function PVEChallengeFamousTent:launchFight()
	-- --战斗请求
	if TipDlg.drawStorageTipo() == false then
		if self.canClickBtn == false then return end
		if self.currentAttackTimes >= self.maxAttackCount then
		
			TipDlg.drawTextDailog( string.format(_string_piece_info[361],self.maxAttackCount))
			
			
			state_machine.excute("pve_challenge_famous_tent_back", 0, 0)
			return
		end
		
		-- 处理 开战时 体力不足 -----------------
		if zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(self.attack_need_food) then
			app.load("client.cells.prop.prop_buy_prompt")
			
			local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
			local mid = zstring.tonumber(config[15])
			
			local win = PropBuyPrompt:new()
			win:init(mid)
			fwin:open(win, fwin._ui)
			return
		end
		
		---[[
		--DOTO 战斗请求
		local function responseBattleInitCallback(response)
			
			local Win = fwin:find("PVEChallengeFamousTentClass") 
			if nil ~= Win then
				Win.fbut._locked = false
			end
			
			_ED.isLaunchBattleRegister = false
			
			state_machine.excute("formation_make_war_open_lock", 0, 0)
			
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				_ED._duplicate_current_scene_id = _ED._current_scene_id 
				_ED._duplicate_current_seat_index = self.sceneNum
				
				_ED._duplicate_current_seat_index_npc = _ED._scene_npc_id
				
				state_machine.excute("pve_challenge_famous_tent_back", 0, 0)
				state_machine.excute("page_stage_fight_data_deal", 0, 0)
				cacher.removeAllTextures()
				fwin:cleanView(fwin._windows)
				cc.Director:getInstance():purgeCachedData()
				local bse = BattleStartEffect:new()
				bse:init(1)
				fwin:open(bse, fwin._windows)
			end
			
			
			
		end
		
		local function launchBattle()
			
			local bseWin = fwin:find("BattleStartEffectClass")
			local fightWin = fwin:find("FightClass")
			if nil ~= bseWin or nil ~= fightWin then
				return
			end
			
			if _ED.isLaunchBattleRegister == true then
				return
			end
			
			_ED.isLaunchBattleRegister = true
			
			if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
				app.load("client.battle.report.BattleReport")
				local fightModule = FightModule:new()
				fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0)
				fightModule:doFight()
				
				responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
			else
				self.fbut._locked = true
				local  battleFieldInitParam = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
				protocol_command.battle_field_init.param_list = battleFieldInitParam
				NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
			end
		end
		
		local function responseCampPreferenceCallback(response)
			local Win = fwin:find("PVEChallengeFamousTentClass") 
			if nil ~= Win then
				Win.fbut._locked = false
			end
		
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if _ED.camp_preference_info ~= nil and _ED.camp_preference_info.count > 0 then
					local pveWin = fwin:find("PVEStageClass") 
					if nil == pveWin then
						return
					end
						
					app.load("client.formation.FormationChangeMakeWar") 
					
					local makeWar = FormationChangeMakeWar:new()
					makeWar:init(launchBattle)
					fwin:open(makeWar, fwin._ui)
				else
					launchBattle()
				end
			end
		end
		

		-- 启动出战事件
		self.npcID = zstring.tonumber(self.npcID)
		local sceneParam = "nc".._ED.npc_state[self.npcID]
		if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..self.npcID, nil, true, sceneParam, false) == false then
			_ED.npc_last_state[self.npcID] = "".._ED.npc_state[self.npcID]

			_ED._current_scene_id = self.sceneID
			_ED._scene_npc_id = self.npcID
			_ED._npc_difficulty_index = "1"

			if __lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_koone
			then
				-- -- 引入相克系统战斗前请求

				if missionIsOver() == false then
					launchBattle()
				else
					_ED._battle_init_type = "0"
					protocol_command.camp_preference.param_list = "".._ED._scene_npc_id.."\r\n".."0"
					NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, nil, responseCampPreferenceCallback, false, nil)
				end
			else
				launchBattle()
			end
		end
	end
end





function PVEChallengeFamousTent:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("duplicate/gameelite_inter_window.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)

	
	-- ccui.Helper:seekWidgetByName(root,"Panel_5"):setVisible(false)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_2"), nil, {
		terminal_name = "pve_challenge_famous_tent_back", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, nil, 2)
	
	local fbut = ccui.Helper:seekWidgetByName(root,"Button_3")
	self.fbut = fbut
	
	if self.isPass < 0 then
		fbut:setTouchEnabled(false)
		fbut:setBright(false)
	end
	if self.npcState > 0 then
		local btt = ccui.Helper:seekWidgetByName(root,"Image_tongguan")
		btt:setVisible(true)
		fbut:setVisible(false)
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_3"), 	nil, 
	{
		terminal_name = "pve_challenge_famous_tent_challenge", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, 
	nil, 0)
	


	self:onUpdateDraw()
	
	-- npc 语音
	local tempMusicIndex = dms.int(dms["npc"],  self.npcID, npc.sound_index)
	if tempMusicIndex ~= nil and tempMusicIndex > 0  then
		playEffect(formatMusicFile("effect", tempMusicIndex))
	end
	
end


function PVEChallengeFamousTent:init(npcID, sceneID, currentPageType, sceneNum, isPass, npcState)
	self.npcID = npcID
	self.sceneID = sceneID
	self.currentPageType = currentPageType
	self.sceneNum = sceneNum
	self.isPass = isPass
	self.npcState = npcState
end


function PVEChallengeFamousTent:onExit()
	-- state_machine.remove("pve_challenge_famous_formation")
	state_machine.remove("pve_challenge_famous_tent_back")
	state_machine.remove("pve_challenge_famous_tent_challenge")
	-- state_machine.remove("formation_make_war_cancel")
	

	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end