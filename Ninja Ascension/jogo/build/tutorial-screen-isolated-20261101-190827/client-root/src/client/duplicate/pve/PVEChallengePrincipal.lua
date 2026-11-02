-- ----------------------------------------------------------------------------------------------------
-- 说明：主线 挑战 npc
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PVEChallengePrincipal = class("PVEChallengePrincipalClass", Window)
    
function PVEChallengePrincipal:ctor()
    self.super:ctor()
	app.load("client.battle.fight.FightEnum")
	app.load("client.battle.BattleStartEffect")
	app.load("client.duplicate.MoppingResults")
	app.load("client.duplicate.pve.PVEResetNPCAttackCount")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
	self.roots = {}
	self.actions = {}

	
	
    -- Initialize PVEChallengePrincipal page state machine.
    local function init_guan_qia_terminal()
		--关卡界面的返回按钮
		local pve_challenge_principal_back_terminal = {
            _name = "pve_challenge_principal_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 	
            	local lastTuition = instance ~= nil and instance.lastTuition or nil
				fwin:close(instance)
            	if lastTuition ~= nil then		
              		lastTuition:setVisible(true)
              	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--关卡界面的挑战按钮
		local pve_challenge_principal_challenge_terminal = {
            _name = "pve_challenge_principal_challenge",
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
		local pve_challenge_principal_formation_terminal = {
            _name = "pve_challenge_principal_formation",
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
		
		-- 扫荡
		local pve_challenge_principal_mopup_terminal = {
            _name = "pve_challenge_principal_mopup",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				
				instance:launchMopup()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 重置
		local pve_challenge_principal_reset_terminal = {
            _name = "pve_challenge_principal_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				
				
				instance:resetMopup()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 扫荡了更新
		
		
		local pve_challenge_principal_sweep_over_update_draw_terminal = {
            _name = "pve_challenge_principal_sweep_over_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				
				instance:updateMopup()
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
				local Win = fwin:find("PVEChallengePrincipalClass") 
				if nil ~= Win then
					Win.fbut._locked = false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(formation_make_war_cancel_terminal)
		state_machine.add(pve_challenge_principal_sweep_over_update_draw_terminal)
		state_machine.add(pve_challenge_principal_reset_terminal)
		state_machine.add(pve_challenge_principal_mopup_terminal)
		state_machine.add(pve_challenge_principal_back_terminal)
		state_machine.add(pve_challenge_principal_challenge_terminal)
		state_machine.add(pve_challenge_principal_formation_terminal)
        state_machine.init()
    end
    
    -- call func init guan qia state machine.
    init_guan_qia_terminal()
end


function PVEChallengePrincipal:onUpdateDraw()
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
	local Text_attack_need_food = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tili")
	local attack_need_food = dms.int(dms["npc"], self.npcID, npc.attack_need_food)
	Text_attack_need_food:setString(attack_need_food)
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
	

	-- 画星星
	local maxStar = 3
	local curStar = 0
	if zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) ~= 0 then
		curStar = tonumber(_ED.npc_max_state[tonumber(""..self.npcID)])
	else
		curStar = tonumber(_ED.npc_state[tonumber(""..self.npcID)])
	end

	if maxStar == curStar then
		self.isNpcThreeStar = true
	else
		self.isNpcThreeStar = false
	end
	
	for i = 1 , maxStar do
		if i <= curStar then
			ccui.Helper:seekWidgetByName(self.roots[1], string.format("Image_xing_%d",i)):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(self.roots[1], string.format("Image_xing_%d_0",i)):setVisible(true)
		end
	end
	
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
	
	-- 绘制 哪个战斗加事件
	local Panel_tz = ccui.Helper:seekWidgetByName(root,"Panel_tz")
	local Panel_sdtz = ccui.Helper:seekWidgetByName(root,"Panel_sdtz")
	Panel_tz:setVisible(false)
	Panel_sdtz:setVisible(false)

	local challengeBtnName = ""
	if self.isNpcThreeStar == false then
		challengeBtnName = "Button_3_24"
		Panel_tz:setVisible(true)
	else
		-- 普通的
		challengeBtnName = "Button_3"
		Panel_sdtz:setVisible(true)
	end
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		challengeBtnName = "Button_3"
	end
	local fbut = ccui.Helper:seekWidgetByName(root,challengeBtnName)
	self.fbut = fbut
	fwin:addTouchEventListener(fbut, 	nil, 
	{
		terminal_name = "pve_challenge_principal_challenge", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, 
	nil, 0)

	if zstring.tonumber(_ED.user_info.user_grade) <= 10 and self._tuition == nil and self.lastTuition ~= nil and missionIsOver() == true then	
		self._tuition = TuitionController:new():init(nil)
		local psize = fbut:getContentSize()
		self._tuition:setPosition(cc.p(psize.width / 2, psize.height / 2))
		fbut:addChild(self._tuition, 1000)
		self._tuition:unlockWindow(nil)
		self.lastTuition:setVisible(false)
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		Panel_sdtz:setVisible(true)
		Panel_tz:setVisible(false)
		local environment_formation1 = dms.string(dms["npc"], self.npcID, npc.environment_formation1)
		local formation_info = dms.element(dms["environment_formation"], self.npcID)
		
		-- 推荐战力
		local Text_enemy_formtion = ccui.Helper:seekWidgetByName(root,"Text_enemy_formtion")
		local combat_force = dms.atoi(formation_info, environment_formation.combat_force)	
		Text_enemy_formtion:removeAllChildren(true)
	    local _richText_1 = ccui.RichText:create()
	    _richText_1:ignoreContentAdaptWithSize(false) 
	    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[16], "fonts/simhei.ttf",22)
	    _richText_1:pushBackElement(re1)  
	    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]),255, exChangeNumToString(combat_force), "fonts/simhei.ttf",22)
	    _richText_1:pushBackElement(re2)
	    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, ")", "fonts/simhei.ttf",22)
	    _richText_1:pushBackElement(re3)
	    _richText_1:setPosition(cc.p(Text_enemy_formtion:getContentSize().width/2,Text_enemy_formtion:getContentSize().height/2))
	    _richText_1:setContentSize(cc.size(Text_enemy_formtion:getContentSize().width,22))
	    Text_enemy_formtion:addChild(_richText_1)

	    -- 获得奖励
	    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
	    Text_get_reward:removeAllChildren(true)
	    local on_hook_reward = dms.int(dms["npc"], self.npcID, npc.on_hook_reward)
	    local wait_time = dms.string(dms["npc"], self.npcID, npc.wait_time)
	    local _richText_2 = ccui.RichText:create()
	    _richText_2:ignoreContentAdaptWithSize(false) 
	    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[17], "fonts/simhei.ttf",20)
	    _richText_2:pushBackElement(re1)  
	    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, on_hook_reward, "fonts/simhei.ttf",20)
	    _richText_2:pushBackElement(re2)
	    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " "..red_alert_time_str[18], "fonts/simhei.ttf",20)
	    _richText_2:pushBackElement(re3)
	    local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, exChangeNumToString(wait_time), "fonts/simhei.ttf",20)
	    _richText_2:pushBackElement(re4)
	    _richText_2:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2))
	    _richText_2:setContentSize(cc.size(Text_get_reward:getContentSize().width,20))
	    Text_get_reward:addChild(_richText_2)

	    -- 有几率获得
	    local Text_get_n = ccui.Helper:seekWidgetByName(root,"Text_get_n")
	    Text_get_n:removeAllChildren(true)
	    local _richText_3 = ccui.RichText:create()
	    _richText_3:ignoreContentAdaptWithSize(false) 
	    local drop_library = dms.int(dms["npc"], self.npcID, npc.drop_library)
	    local add_numbers = {}
	    if drop_library > 0 then
	    	local drop_library = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_items)
        	reward_items = zstring.split(reward_items,"|")
        	for i,reward in ipairs(reward_items) do
        		local reward_tab = zstring.split(reward,",")
        		local prop_item = tonumber(reward_tab[1])
        		local prop_quality = dms.int(dms["prop_mould"], prop_item, prop_mould.prop_quality)
        		local prop_name = dms.string(dms["prop_mould"], prop_item, prop_mould.prop_name)
        		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        prop_name = setThePropsIcon(prop_item)[2]
			    end
        		local data = {prop_name,prop_quality}
        		table.insert(add_numbers,data)
        	end
	        for i,v in pairs(add_numbers) do
	        	local re1 = nil 
	        	local re2 = nil
	        	re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[v[2]+1][1],color_Type[v[2]+1][2],color_Type[v[2]+1][3]),255, v[1], "fonts/simhei.ttf",20)
		        _richText:pushBackElement(re1)  
		        if i == #add_numbers then
		            re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,"","fonts/simhei.ttf",20)
		            _richText:pushBackElement(re2)
		        else
		            re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,"、","fonts/simhei.ttf",20)
		            _richText:pushBackElement(re2)
		        end
	        end
	        _richText_3:setPosition(cc.p(Text_get_n:getContentSize().width/2,Text_get_n:getContentSize().height/2))
		    _richText_3:setContentSize(cc.size(Text_get_n:getContentSize().width,20))
		    Text_get_n:addChild(_richText_3)
        end

		local seat_one = dms.atoi(formation_info, environment_formation.seat_one)
		local seat_two = dms.atoi(formation_info, environment_formation.seat_two)
		local seat_three = dms.atoi(formation_info, environment_formation.seat_three)
		local seat_four = dms.atoi(formation_info, environment_formation.seat_four)
		local seat_five = dms.atoi(formation_info, environment_formation.seat_five)
		local seat_six = dms.atoi(formation_info, environment_formation.seat_six)
		local seat_info = {seat_one,seat_two,seat_three,seat_four,seat_five,seat_six}

		

		local seat_one_nums = dms.int(dms["environment_ship"], seat_one, environment_ship.level)
		local seat_two_nums = dms.int(dms["environment_ship"], seat_two, environment_ship.level)
		local seat_three_nums = dms.int(dms["environment_ship"], seat_three, environment_ship.level)
		local seat_four_nums = dms.int(dms["environment_ship"], seat_four, environment_ship.level)
		local seat_five_nums = dms.int(dms["environment_ship"], seat_five, environment_ship.level)
		local seat_six_nums = dms.int(dms["environment_ship"], seat_six, environment_ship.level)
		local seat_nums_info = {seat_one_nums,seat_two_nums,seat_three_nums,seat_four_nums,seat_five_nums,seat_six_nums}

		for i=1,6 do
			local Panel_form_point = ccui.Helper:seekWidgetByName(root,"Panel_form_point_"..i)
			local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
	        Panel_formation_tank:removeAllChildren(true)
	        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
	        Panel_formation_leader:removeAllChildren(true)

	        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, seat_info[i], seat_nums_info[i],2})
	        Panel_formation_tank:addChild(cell)

	        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,2,2})
	        Panel_formation_leader:addChild(cell)
		end
	end

	self:updateBattleTimes()
	
	-- -- 画掉落
	self:drawRewardList()
end

function PVEChallengePrincipal:updateBattleTimes()

-- 绘制挑战次数
	local totalAttackTimes = dms.int(dms["npc"], self.npcID, npc.daily_attack_count)
	local surplusAttackCount = _ED.npc_current_attack_count[tonumber(self.npcID)]
	local Text_cishu = ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu")
	Text_cishu:setString((totalAttackTimes - surplusAttackCount) .. "/" .. totalAttackTimes)
	self.maxAttackCount = tonumber(totalAttackTimes)
	self.currentAttackTimes = tonumber(surplusAttackCount)
	local finalBattleTimes = totalAttackTimes - surplusAttackCount
	self.cacheBattleTenBtn:setVisible(finalBattleTimes > 0)
	self.cacheBattleTenResetBtn:setVisible(finalBattleTimes <= 0)
	if (finalBattleTimes > 10) then finalBattleTimes = 10 end
	--更新扫荡上面的文字
	if verifySupportLanguage(_lua_release_language_en) == true then
		self.cacheBattleTimesText:setString(_string_piece_info[358]..finalBattleTimes)
	else
		self.cacheBattleTimesText:setString(_string_piece_info[358]..finalBattleTimes .. _string_piece_info[70])
	end
end


function PVEChallengePrincipal:drawRewardList()
	-- 判定当前是否处于 双倍
	local doublePower = 1
	
	if nil ~= _ED.active_activity[44] then
		doublePower = 2
		
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_1212"):setVisible(true)
	end
	
	

	local listViewReward = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	listViewReward:removeAllItems()
	--绘制奖励
	local rewardID = dms.int(dms["npc"], self.npcID, npc.drop_library)
	
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
		
		-- if rewardMaxJade > 0 and rewardJade > 0 then
			-- self.cacheBattlePropText:setString(rewardJade .. "~" .. rewardMaxJade)
		-- end	
		
		if rewardMoney > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(1, rewardMoney, -1)
			listViewReward:addChild(reward)
		end
		
		if rewardGold > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(2, rewardGold, -1)
			listViewReward:addChild(reward)
		end
		
		if rewardHonor > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(3, rewardHonor, -1)
			listViewReward:addChild(reward)
		end
		
		if rewardSoul > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(4, rewardSoul, -1)
			listViewReward:addChild(reward)
			
			--ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_3_7_7"):setBackGroundImage(string.format("images/ui/props/props_%d.png", 4007))
			--ccui.Helper:seekWidgetByName(self.roots[1], "Text_18_18_18"):setString(rewardSoul)
		else
			--ccui.Helper:seekWidgetByName(self.roots[1], "Text_tl_1_0_12_12_12"):setString(" ")
			--ccui.Helper:seekWidgetByName(self.roots[1], "Text_20_20"):setString(" ")
		end

		if rewardJade~=nil and rewardJade > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(5, rewardJade, -1)
			listViewReward:addChild(reward)
		end

		--绘制道具
		if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
		------------------------------------------------------------
			local rewardProp = zstring.split(rewardItemListStr, "|")
			if table.getn(rewardProp) > 0 then
				for i,v in pairs(rewardProp) do
					local rewardPropInfo = zstring.split(v, ",")
					if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
						
						local reward = PropIconCell:createCell()
						local reawrdID = tonumber(rewardPropInfo[2])
						local rewardNum = tonumber(rewardPropInfo[1])*doublePower
						reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum}, nil, false)
						listViewReward:addChild(reward)
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
						
						local reawrdID = tonumber(rewardPropInfo[2])
						local rewardNum = tonumber(rewardPropInfo[1])*doublePower
						local tmpTable = {
							user_equiment_template = reawrdID,
							mould_id = reawrdID,
							user_equiment_grade = 1
						}
						
						local eic = EquipIconCell:createCell()
						eic:init(10, tmpTable, reawrdID, nil, false, rewardNum)
						listViewReward:addChild(eic)
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
						local reward = ShipHeadCell:createCell()
						local reawrdID = tonumber(rewardPropInfo[3])
						local rewardLv = tonumber(rewardPropInfo[1])
						local rewardNums = tonumber(rewardPropInfo[2])
						reward:init(nil,13, reawrdID,rewardNums)
						listViewReward:addChild(reward)
					end
				end
			end
		--------------------------------------------------------
		end
	-------------------------------------------------------------------
	end
end


function PVEChallengePrincipal:launchFight()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		_ED._current_scene_id = self.sceneID
		_ED._scene_npc_id = self.npcID
		_ED._npc_difficulty_index = "1"
		state_machine.excute("formation_window_open",0,{_datas = {form_type = 2}})
		return
	end
	
	-- --战斗请求
	if TipDlg.drawStorageTipo() == false then
		if self.canClickBtn == false then return end
		if self.currentAttackTimes >= self.maxAttackCount then
			TipDlg.drawTextDailog(_string_piece_info[113])
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
			
			_ED.isLaunchBattleRegister = false
			
			state_machine.excute("formation_make_war_open_lock", 0, 0)
		
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				_ED._duplicate_current_scene_id = _ED._current_scene_id 
					
				_ED._duplicate_current_seat_index = self.sceneNum
				
				state_machine.excute("pve_challenge_principal_back", 0, 0)

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
				fightModule:doFight(responseBattleInitCallback)
				
				responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
			else
				local  battleFieldInitParam = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
				protocol_command.battle_field_init.param_list = battleFieldInitParam
				NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
			end
		end
		
		local function responseCampPreferenceCallback(response)
			local Win = fwin:find("PVEChallengePrincipalClass") 
			if nil ~= Win then
				Win.fbut._locked = false
			end
			
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.launchFight ~= nil then
					if _ED.camp_preference_info ~= nil and _ED.camp_preference_info.count > 0 then
					
						local pveWin = fwin:find("PVESecondarySceneClass") 
						if nil == pveWin then
							return
						end
					
						app.load("client.formation.FormationChangeMakeWar") 
						
						local makeWar = FormationChangeMakeWar:new()
						makeWar:init(launchBattle, response.node._tuition)
						fwin:open(makeWar, fwin._ui)
					else
						launchBattle()
					end
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
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_koone
			then
				-- -- 引入相克系统战斗前请求

				if missionIsOver() == false then
					launchBattle()
				else
					self.fbut._locked = true
					_ED._battle_init_type = "0"
					protocol_command.camp_preference.param_list = "".._ED._scene_npc_id.."\r\n".."0"
					NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, self, responseCampPreferenceCallback, false, nil)
				end
			elseif __lua_project_id == __lua_project_yugioh  then 

				self.fbut._locked = true
				_ED._battle_init_type = "0"
				protocol_command.camp_preference.param_list = "".._ED._scene_npc_id.."\r\n".."0"
				NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, self, responseCampPreferenceCallback, false, nil)
			else
				launchBattle()
			end
		end
	end
end

-- 扫荡
function PVEChallengePrincipal:launchMopup()
	if TipDlg.drawStorageTipo() == false then
		local myLv = tonumber(_ED.user_info.user_grade)
		local myVip = tonumber(_ED.vip_grade)
		local needLv = dms.int(dms["fun_open_condition"], 38, fun_open_condition.level)
		local needVip = dms.int(dms["fun_open_condition"], 38, fun_open_condition.vip_level)
		if myLv < needLv or myVip < needVip then
			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 38, fun_open_condition.tip_info))
			return
		end
		local star = tonumber(_ED.npc_state[tonumber(""..self.npcID)])
		
		if star < 3 then
			if star == 0 then
				TipDlg.drawTextDailog(_string_piece_info[327])
				return
			else
				TipDlg.drawTextDailog(_string_piece_info[328])
				return
			end
		end

		local currentNpcID = self.npcID							-- NPCID
		local DifficultyID = 1												-- 攻击下标
		local surplusTimes = 1--self.maxAttackCount - self.currentAttackTimes	-- 扫荡次数
		local elseContent  = "0"											-- 扫荡类型
		
		local totalAttackTimes = dms.int(dms["npc"], self.npcID, npc.daily_attack_count)
		local surplusAttackCount = _ED.npc_current_attack_count[tonumber(self.npcID)]
		local finalBattleTimes = totalAttackTimes - surplusAttackCount
		if (finalBattleTimes > 10) then finalBattleTimes = 10 end
		surplusTimes = finalBattleTimes
		
		if tonumber(surplusTimes) <= 0 then
			TipDlg.drawTextDailog(_string_piece_info[113])
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

		-- 打开扫荡界面
		fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"pve_challenge_principal_sweep_over_update_draw", self}), fwin._window)
		-- 关闭自己
		fwin:close(self)
	end

end

-- 重置
function PVEChallengePrincipal:resetMopup()

	if getPVENPCResidualCount(self.npcID) > 0 then
		local view = PVEResetNPCAttackCount:new():init(1, self.npcID, 0, 0, {"click_battle_ten_reset_update_draw", self})
		fwin:open(view, fwin._windows)
	else
		TipDlg.drawTextDailog(_string_piece_info[252])
	end
end



-- 更新
function PVEChallengePrincipal:updateMopup()

	self:updateBattleTimes()
end


function PVEChallengePrincipal:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("duplicate/pve_tiaozhan.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)



	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_2"), nil, {
		terminal_name = "pve_challenge_principal_back", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, nil, 2)
	
	-- 扫荡
	self.cacheBattleTenBtn = ccui.Helper:seekWidgetByName(root,"Button_4")
	fwin:addTouchEventListener(self.cacheBattleTenBtn, 	nil, 
	{
		terminal_name = "pve_challenge_principal_mopup", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, 
	nil, 0)
	
	self.cacheBattleTimesText = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_1")
	
	-- 重置
	self.cacheBattleTenResetBtn = ccui.Helper:seekWidgetByName(root,"Button_cz")
	fwin:addTouchEventListener(self.cacheBattleTenResetBtn, 	nil, 
	{
		terminal_name = "pve_challenge_principal_reset", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, 
	nil, 0)
	
	-- 布阵
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), 	nil, 
	{
		terminal_name = "pve_challenge_principal_formation", 	
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


function PVEChallengePrincipal:init(npcID, sceneID, currentPageType, sceneNum, lastTuition)
	self.npcID = npcID
	self.sceneID = sceneID
	self.currentPageType = currentPageType
	self.sceneNum = sceneNum
	self.lastTuition = lastTuition
end


function PVEChallengePrincipal:onExit()
	state_machine.remove("pve_challenge_principal_formation")
	state_machine.remove("pve_challenge_principal_reset")
	state_machine.remove("pve_challenge_principal_mopup")
	state_machine.remove("pve_challenge_principal_back")
	state_machine.remove("pve_challenge_principal_sweep_over_update_draw")
	state_machine.remove("pve_challenge_principal_challenge")
	state_machine.remove("formation_make_war_cancel")
	

	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end
