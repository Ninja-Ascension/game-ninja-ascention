-- ----------------------------------------------------------------------------------------------------
-- 说明：名将 挑战 npc
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PVEChallengeFamous = class("PVEChallengeFamousClass", Window)
    
function PVEChallengeFamous:ctor()
    self.super:ctor()
	app.load("client.battle.fight.FightEnum")
	app.load("client.battle.BattleStartEffect")
	app.load("client.duplicate.MoppingResults")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	self.roots = {}
	self.actions = {}

    -- Initialize PVEChallengeFamous page state machine.
    local function init_guan_qia_terminal()
		--关卡界面的返回按钮
		local pve_challenge_famous_back_terminal = {
            _name = "pve_challenge_famous_back",
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
		local pve_challenge_famous_challenge_terminal = {
            _name = "pve_challenge_famous_challenge",
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
		
		--关卡界面的布阵按钮
		local pve_challenge_famous_formation_terminal = {
            _name = "pve_challenge_famous_formation",
            _init = function (terminal) 
                app.load("client.formation.FormationChange") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				local formationChangeWindow = FormationChange:new()
				fwin:open(formationChangeWindow, fwin._windows)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local formation_make_war_cancel_terminal = {
            _name = "formation_make_war_cancel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 	
				local Win = fwin:find("PVEChallengeFamousClass") 
				if nil ~= Win then
					Win.fbut._locked = false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(formation_make_war_cancel_terminal)
		state_machine.add(pve_challenge_famous_back_terminal)
		state_machine.add(pve_challenge_famous_challenge_terminal)
		state_machine.add(pve_challenge_famous_formation_terminal)
        state_machine.init()
    end
    
    -- call func init guan qia state machine.
    init_guan_qia_terminal()
end


function PVEChallengeFamous:onUpdateDraw()
	local root = self.roots[1]
	
	-- 头像
	local Panel_npcHead = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	local npcIconIndex = dms.int(dms["npc"], self.npcID, npc.head_pic) -1000
	local npcHead = ""
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		npcHead = string.format("images/face/big_head/big_head_%d.png", npcIconIndex)
	else
		npcHead = string.format("images/face/card_head/card_head_%d.png", npcIconIndex)
	end
	
	Panel_npcHead:setBackGroundImage(npcHead)
	
	-- 废话
	local Text_sign_msg = ccui.Helper:seekWidgetByName(self.roots[1], "Text_3")
	local signMsg = dms.string(dms["npc"], self.npcID, npc.sign_msg)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local word_info = dms.element(dms["word_mould"], zstring.tonumber(signMsg))
        signMsg = word_info[3]
    end
	Text_sign_msg:setString(signMsg)
	
	-- 体力
	local Text_attack_need_food = ccui.Helper:seekWidgetByName(self.roots[1], "Text_2")
	local attack_need_food = dms.int(dms["npc"], self.npcID, npc.attack_need_food)
	Text_attack_need_food:setString(string.format(_string_piece_info[359], attack_need_food))
	self.attack_need_food = attack_need_food
	
	--猪脚等级
	local masterLv = tonumber(_ED.user_info.user_grade)
	
	--经验获得 Text_exp
	local Text_exp = ccui.Helper:seekWidgetByName(self.roots[1], "Text_exp")
	Text_exp:setString(_string_piece_info[153] .. masterLv * 10 * dms.int(dms["npc"], self.npcID, npc.attack_need_food)/5)
	
	--银币获得 Text_money
	local Text_jinqian = ccui.Helper:seekWidgetByName(self.roots[1], "Text_jinqian")
	local money = dms.int(dms["grade_silver_reward"], masterLv, grade_silver_reward.silver)
	Text_jinqian:setString(_string_piece_info[153] .. money* dms.int(dms["npc"], self.npcID, npc.attack_need_food)/5)
	
	
	-- npc 名字
	local Text_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name")
	local npc_name = dms.string(dms["npc"], self.npcID, npc.npc_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(npc_name, "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        npc_name = name_info
    end
	Text_name:setString(npc_name)
	
	-- 画掉落
	--self:drawRewardList()
	
	--绘制奖励
	local rewardID = dms.int(dms["npc"], self.npcID, npc.drop_library)
	if rewardID > 0 then
	-------------------------------------------------------------------
		-- local rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_prop)
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
		
		if rewardMaxJade > 0 and rewardJade > 0 then
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_shuliang"):setString(rewardJade .. "~" .. rewardMaxJade)
		end	
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_yugioh
			then 
			if rewardSoul > 0 and rewardMaxSoul > 0 then 
				--产出数码魂
				local smhText = ccui.Helper:seekWidgetByName(self.roots[1], "Text_shuliang_sj")
				local smhPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shenjiang")
				if smhText ~= nil and smhPanel ~= nil then 
					ccui.Helper:seekWidgetByName(root,"Panel_5"):setVisible(true)
					smhText:setString(rewardSoul .. "~" .. rewardMaxSoul)
					smhPanel:removeAllChildren(true)
					local reward = ResourcesIconCell:createCell()
					reward:init(4, 0, -1)
					smhPanel:addChild(reward)
				end
			end
		end
	end
	
	-- 首胜奖励
	local fristRewardElement = dms.element(dms["scene_reward"], dms.int(dms["npc"], self.npcID, npc.first_reward))
	local gold = dms.atos(fristRewardElement, scene_reward.reward_gold)
	if gold ~= nil then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_zuanshi"):setString("".. gold)
	end
	
	-- 水雷魂
	local reward = ResourcesIconCell:createCell()
	reward:init(5, 0, -1)
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shuileihun"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shuileihun"):addChild(reward)
	
	-- 战斗次数
	local totalAttackTimes = dms.int(dms["npc"], self.npcID, npc.daily_attack_count)
	local surplusAttackCount = _ED.npc_current_attack_count[tonumber(self.npcID)]
	self.maxAttackCount = tonumber(totalAttackTimes)
	self.currentAttackTimes = tonumber(surplusAttackCount)
end


function PVEChallengeFamous:launchFight()
	-- --战斗请求
	if TipDlg.drawStorageTipo() == false then
		if self.canClickBtn == false then return end
		if self.currentAttackTimes >= self.maxAttackCount then
		
			TipDlg.drawTextDailog( string.format(_string_piece_info[361],self.maxAttackCount))
			
			
			state_machine.excute("pve_challenge_famous_back", 0, 0)
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
			
			local Win = fwin:find("PVEChallengeFamousClass") 
			if nil ~= Win then
				Win.fbut._locked = false
			end
			
			_ED.isLaunchBattleRegister = false
			
			state_machine.excute("formation_make_war_open_lock", 0, 0)
			
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				_ED._duplicate_current_scene_id = _ED._current_scene_id 
				_ED._duplicate_current_seat_index = self.sceneNum
				
				_ED._duplicate_current_seat_index_npc = _ED._scene_npc_id
				
				state_machine.excute("pve_challenge_famous_back", 0, 0)
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
			local Win = fwin:find("PVEChallengeFamousClass") 
			if nil ~= Win then
				Win.fbut._locked = false
			end
		
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if _ED.camp_preference_info ~= nil and _ED.camp_preference_info.count > 0 then
					local pveWin = fwin:find("PVESecondarySceneClass") 
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





function PVEChallengeFamous:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("duplicate/pve_tiaozhan_mj.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)

	
	ccui.Helper:seekWidgetByName(root,"Panel_5"):setVisible(false)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_2"), nil, {
		terminal_name = "pve_challenge_famous_back", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, nil, 2)
	
	local fbut = ccui.Helper:seekWidgetByName(root,"Button_3")
	self.fbut = fbut
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_3"), 	nil, 
	{
		terminal_name = "pve_challenge_famous_challenge", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, 
	nil, 0)
	
	-- 布阵
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), 	nil, 
	{
		terminal_name = "pve_challenge_famous_formation", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 3,
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


function PVEChallengeFamous:init(npcID, sceneID, currentPageType, sceneNum)
	self.npcID = npcID
	self.sceneID = sceneID
	self.currentPageType = currentPageType
	self.sceneNum = sceneNum
	
end


function PVEChallengeFamous:onExit()
	state_machine.remove("pve_challenge_famous_formation")
	state_machine.remove("pve_challenge_famous_back")
	state_machine.remove("pve_challenge_famous_challenge")
	state_machine.remove("formation_make_war_cancel")
	

	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end