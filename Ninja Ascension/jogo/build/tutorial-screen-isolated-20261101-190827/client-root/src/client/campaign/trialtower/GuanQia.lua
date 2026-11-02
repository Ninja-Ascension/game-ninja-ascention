-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双单个npc
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
GuanQia = class("GuanQiaClass", Window)
    
function GuanQia:ctor()
    self.super:ctor()
	app.load("client.battle.fight.FightEnum")
	self.roots = {}
	self.actions = {}
	self.challenge ={  -- 以下是对应的数据格式
		-- npcHead = "images/face/14008.png",
		-- npcdialogue = game_infomation_tip_str[11],
		-- customsindex =game_infomation_tip_str[12],
		-- GuanqiaCondition = game_infomation_tip_str[13],
		-- challengeinfo={
			-- {silver = "800",prestige = "40",strength = "5160"},
			-- {silver = "1600",prestige = "80",strength = "5848"},
			-- {silver = "2400",prestige = "120",strength = "6536"},
		-- }
	}
	
	
    -- Initialize GuanQia page state machine.
    local function init_guan_qia_terminal()
		--关卡界面的返回按钮
		local guan_qia_back_activity_terminal = {
            _name = "guan_qia_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				fwin:close(instance)
				--instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--关卡界面的挑战按钮
		local trial_tower_challenge_terminal = {
            _name = "trial_tower_challenge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				-- fwin:close(instance)
				instance:fight( params._datas.showType)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--关卡界面的布阵按钮
		local trial_tower_formation_terminal = {
            _name = "trial_tower_formation",
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
		
		state_machine.add(trial_tower_formation_terminal)
		state_machine.add(guan_qia_back_activity_terminal)
		state_machine.add(trial_tower_challenge_terminal)
        state_machine.init()
    end
    
    -- call func init guan qia state machine.
    init_guan_qia_terminal()
end


function GuanQia:onUpdateDraw()
	
	local Panel_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_10")
	local Text_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_10")
	local Text_11 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_11")
	local Text_12 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_12")
	local Text_130 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_130")
	
	
	Text_10:setString(self.challenge.npcdialogue)

	Text_11:setString(string.format(tipStringInfo_trialTower[8],self.challenge.customsindex))
	Text_130:setString(self.challenge.name)
	
	Text_12:setString(self.challenge.GuanqiaCondition)
	
	Panel_10:setBackGroundImage(self.challenge.npcHead)

	for i, v in ipairs(self.challenge.challengeinfo) do
		local pnRootString = string.format("Panel_1%d", i + 5)
		local pnRoot = ccui.Helper:seekWidgetByName(self.roots[1], pnRootString)
		local Text_simplesilver = ccui.Helper:seekWidgetByName(pnRoot, "Text_38_0")
		local Text_simpleprestige = ccui.Helper:seekWidgetByName(pnRoot, "Text_39_0")
		local Text_simplestrength = ccui.Helper:seekWidgetByName(pnRoot, string.format("Text_%d_0", i+3))
		Text_simplesilver:setString(v.silver)
		Text_simpleprestige:setString(v.prestige)
		
		local count = tonumber(v.strength)
		local str = ""
		if count >= 100000 then
			local w = math.floor(count/10000)
			str = w .. string_equiprety_name[38]
		else
			str = count
		end
		Text_simplestrength:setString(str)
	end
end

function GuanQia:fight(index)
	-- --战斗请求
	local function responseBattleInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			
			local achievementIndex = response.node.info.achievementIndex
			_ED.three_kingdoms_view.achievementIndex = achievementIndex
			
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			
			else
				fwin:close(response.node)
				fwin:close(fwin:find("TrialTowerClass"))
			end

			local bse = BattleStartEffect:new()
			bse:init(_enum_fight_type._fight_type_102)
			fwin:open(bse, fwin._windows)

		end
	end
	
	
	local function launchBattle()
		local degree = {0,1,2}
		protocol_command.three_kingdoms_fight.param_list = degree[index]
		NetworkManager:register(protocol_command.three_kingdoms_fight.code, nil, nil, nil, self, responseBattleInitCallback, false, nil)

	end
	
	if missionIsOver() == false then
		launchBattle()
	else
		if __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_koone
		then
			local function responseCampPreferenceCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
					if _ED.camp_preference_info ~= nil and _ED.camp_preference_info.count > 0 then
						app.load("client.formation.FormationChangeMakeWar") 
						
						local makeWar = FormationChangeMakeWar:new()
						
						makeWar:init(launchBattle)
						
						fwin:open(makeWar, fwin._ui)
					else
						launchBattle()
					end
				end
			end
			_ED._battle_init_type = "0"
			local rid = self.info.npcMID
			protocol_command.camp_preference.param_list = ""..rid.."\r\n".."0"
			NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, nil, responseCampPreferenceCallback, false, nil)
		else
			launchBattle()
		end
	end
end

function GuanQia:initData()
	
	--取该npc的环境阵型
	local npcMID = self.info.npcMID
	
	local strength_1 = dms.int(dms["npc"], tonumber(npcMID), npc.environment_formation1)
	local strength_2 = dms.int(dms["npc"], tonumber(npcMID), npc.environment_formation2)
	local strength_3 = dms.int(dms["npc"], tonumber(npcMID), npc.environment_formation3)
	
	local combat_force_1 = dms.string(dms["environment_formation"], strength_1, environment_formation.combat_force)
	local combat_force_2 = dms.string(dms["environment_formation"], strength_2, environment_formation.combat_force)
	local combat_force_3 = dms.string(dms["environment_formation"], strength_3, environment_formation.combat_force)
	
	--难度奖励
	--取三国配置表中奖励id, 取找场景奖励中的钱和声望
	local reward = zstring.split(dms.string(dms["npc"], tonumber(npcMID), npc.difficulty_reward), "|")
	
	local reward_1 = zstring.split(reward[1], ",")
	local reward_2 = zstring.split(reward[2], ",")
	local reward_3 = zstring.split(reward[3], ",")
	local npcHead = ""
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		npcHead = string.format("images/face/big_head/big_head_%d.png", self.info.npcIconIndex)
	else
		npcHead = string.format("images/face/card_head/card_head_%d.png", self.info.npcIconIndex)
	end
	self.challenge ={
		npcHead = npcHead,
		npcdialogue = self.info.paopao,--该npc的话
		customsindex = self.info.num,
		GuanqiaCondition = self.info.guanqiaCondition, --该关卡的条件
		name = self.info.name,
		challengeinfo={
			{silver = reward_1[1],prestige = reward_1[2],strength = combat_force_1},
			{silver = reward_2[1],prestige = reward_2[2],strength = combat_force_2},
			{silver = reward_3[1],prestige = reward_3[2],strength = combat_force_3},
		}
		
	}
end

function GuanQia:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_2.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)

	self:initData()
	self:onUpdateDraw()

	--少三中该界面没有开启和关闭动画
	-- local action = csb.createTimeline("campaign/TrialTower/trial_tower_2.csb")	
    -- table.insert(self.actions, action )
    -- csbCampaign:runAction(action)
    -- action:setFrameEventCallFunc(function (frame)
        -- if nil == frame then
            -- return
        -- end

        -- local str = frame:getEvent()
        -- if str == "open" then
        -- elseif str == "close" then
        	-- fwin:close(self)
        -- end
    -- end)
    -- action:play("window_open", false)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_4"), nil, {
		func_string = [[state_machine.excute("guan_qia_back_activity", 0, "guan_qia_back_activity.'")]],
		isPressedActionEnabled = true,
	}, nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_5"), 	nil, 
	{
		terminal_name = "trial_tower_challenge", 	
		next_terminal_name = "trial_tower_challenge", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 1,
		target = self
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_5_0"), 	nil, 
	{
		terminal_name = "trial_tower_challenge", 	
		next_terminal_name = "trial_tower_challenge", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 2,
		target = self
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_5_1"), 	nil, 
	{
		terminal_name = "trial_tower_challenge", 	
		next_terminal_name = "trial_tower_challenge", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 3,
		target = self
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), 	nil, 
	{
		terminal_name = "trial_tower_formation", 	
		next_terminal_name = "trial_tower_formation", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		showType = 3,
		target = self
	}, 
	nil, 0)
	
	
end

-- _info = {
-- npcMID = npcMID,
-- num = num,
-- name = name,
-- paopao = paopao,
-- npcIconIndex = npcIconIndex,
-- guanqiaCondition = self.GuanqiaCondition,	
-- achievementIndex = self.achievementIndex,		
-- }
function GuanQia:init(info)
	self.info = info
end


function GuanQia:onExit()
	state_machine.remove("guan_qia_back_activity")
	state_machine.remove("trial_tower_challenge")
	state_machine.remove("trial_tower_formation")
	
end
