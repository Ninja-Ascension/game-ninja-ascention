-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE场景NPC信息
-------------------------------------------------------------------------------------------------------
NPCInformation = class("NPCInformationClass", Window)

function NPCInformation:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.npcId 	 = "2"			--npc ID
	self.sceneId = "1"			--场景 ID
	self.count 	 = "" --npc的介绍
	self.npcCurStar = 2  		--一个关卡已获得npc星星
	
    -- Initialize NPCInformation page state machine.
    local function init_npc_information_terminal()	
        -- 请求PVE副本战斗
        local npc_information_request_sweep_terminal = {
            _name = "npc_information_request_sweep",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)      
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		 
		-- 请求PVE副本战斗
		local npc_information_request_fight_terminal = {
            _name = "npc_information_request_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)		
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local duplicate_show_list_1_terminal = {
            _name = "touch_colose",
            _init = function (terminal)          
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("PveTwoSceneClass"))
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--布阵
		local duplicate_touch_formation_terminal = {
            _name = "duplicate_touch_formation",
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
		--挑战
		local duplicate_touch_button_challenge_terminal = {
            _name = "touch_button_challenge",
            _init = function (terminal)          
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--DOTO 战斗请求
					local function responseBattleInitCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							BattleSceneClass.Draw()
						end
					end
					_ED._current_scene_id = self.sceneId
					_ED._scene_npc_id = self.npcId
					_ED._npc_difficulty_index = "1"
					
					if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
						app.load("client.battle.report.BattleReport")
						local fightModule = FightModule:new()
						fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0)
						fightModule:doFight()
						
						responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
					else
						protocol_command.battle_field_init.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
						NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
					end
					
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(npc_information_request_sweep_terminal)
        state_machine.add(duplicate_show_list_1_terminal)
        state_machine.add(npc_information_request_fight_terminal)
        state_machine.add(duplicate_touch_formation_terminal)
        state_machine.add(duplicate_touch_button_challenge_terminal)
        state_machine.init()
    end
    
    -- call func init NPCInformation state machine.
    init_npc_information_terminal()
end

function NPCInformation:onUpdateDraw()
	-- 实现实现pve场景的绘制
	local root = self.roots[1]
	local npcSay = ccui.Helper:seekWidgetByName(root, "Text_1")				--NPC信息
	local challengeNumber = ccui.Helper:seekWidgetByName(root, "Text_4")	--挑战次数
	local npcImage = ccui.Helper:seekWidgetByName(root, "Panel_role_box")	--NPC形象
	local npcName = ccui.Helper:seekWidgetByName(root, "Label_2266")		--NPC名字
			
	local physicalStrength = ccui.Helper:seekWidgetByName(root, "Text_6")			--消耗体力			
	local silverCoin = ccui.Helper:seekWidgetByName(root, "Text_7")					--获得银币			
	local experience = ccui.Helper:seekWidgetByName(root, "Text_10")				--获得经验		

	npcSay:setString(self.count)
	-- 绘制挑战次数
	local totalAttackTime = dms.string(dms["npc"],self.npcId,npc.daily_attack_count)
	local surplusAttackCount =self.npcId--tonumber(totalAttackTime) - tonumber(_ED.npc_current_attack_count[dms.string(dms["npc"],self.npcId,npc.id)]) --可以攻击次数
	local attackStr = ""
	attackStr = attackStr..surplusAttackCount
	attackStr = attackStr.."/"
	attackStr = attackStr..totalAttackTime
	challengeNumber:setString(attackStr)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(dms.string(dms["npc"],self.npcId,npc.npc_name), "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        npcName:setString(name_info)				--绘制名字
    else
    	npcName:setString(dms.string(dms["npc"],self.npcId,npc.npc_name))				--绘制名字
    end
	
	
	physicalStrength:setString(dms.string(dms["npc"],self.npcId,npc.attack_need_food))	--绘制消耗体力
	
	--绘制头像
	local copyCount = dms.string(dms["npc"],self.npcId,npc.difficulty_include_count)
	for i =1,copyCount do
		local rewardList = zstring.split(dms.string(dms["npc"],self.npcId,npc.difficulty_reward) ,"|")
		local rewardInfo = zstring.split(rewardList[i],",")
		silverCoin:setString(rewardInfo[1])
		experience:setString(rewardInfo[2])
		local imageId = dms.string(dms["npc"],self.npcId,npc.head_pic)
		headIcon = string.format("images/ui/props/props_%s.png", imageId)
		npcImage:setBackGroundImage(headIcon)
	end
	
	--绘制星星状态
	-- [[
	local maxStar = tonumber(dms.string(dms["npc"],self.npcId,npc.difficulty_include_count))
	local CurStar = self.npcCurStar --tonumber(_ED.npc_state[dms.string(dms["npc"],self.npcId,npc.id)])
	if CurStar == 1 then  
		ccui.Helper:seekWidgetByName(root,"Image_6"):setVisible(false)
	elseif CurStar == 2 then 
		ccui.Helper:seekWidgetByName(root,"Image_6"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Image_6_0"):setVisible(false)
	elseif CurStar == 3 then
		ccui.Helper:seekWidgetByName(root,"Image_6"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Image_6_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Image_6_1"):setVisible(false)
	end
	--]]
	--绘制奖励
	local rewardItem = {
		"Panel_1",
		"Panel_1_0",
		"Panel_1_0_0",
		"Panel_1_0_0_0",
		"Panel_1_0_0_0_0"
		}
	local library = dms.string(dms["scene_reward"],npc.drop_library,scene_reward.reward_prop)
	local rewardProp = zstring.split(library,"|")
	if table.getn(rewardProp) > 0 then
		for i,v in pairs(rewardProp) do
			local rewardPropInfo = zstring.split(v,",")
			if tonumber(rewardPropInfo[1])>0 and tonumber(rewardPropInfo[2])>0 then
				app.load("client.cells.prop.prop_icon_cell")
				local reward = PropIconCell:createCell()
				local reawrdID = tonumber(rewardPropInfo[2])
				local rewardNum = tonumber(rewardPropInfo[1])
				reward:init(6, {user_prop_template = reawrdID, prop_number = rewardNum})
				local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[i])
				mRewardItem:addChild(reward)
			end
		end
	end
end

function NPCInformation:onEnterTransitionFinish()
	local csbNPCinformation = csb.createNode("duplicate/elite_copy_drop.csb")
    local root = csbNPCinformation:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNPCinformation)
	
	local action = csb.createTimeline("duplicate/elite_copy_drop.csb")
    csbNPCinformation:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)

    -- 界面中的UI控件的响应
	local npcInfoOfFormationButton = ccui.Helper:seekWidgetByName(root, "Button_1234")	--布阵按钮	
	local ButtonColose = ccui.Helper:seekWidgetByName(root, "Button_colose")	--退出	
	local ButtonChallenge = ccui.Helper:seekWidgetByName(root, "Button_2265")		--挑战	
	
	fwin:addTouchEventListener(ButtonColose, nil, {terminal_name = "touch_colose", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(npcInfoOfFormationButton, nil, {func_string = [[state_machine.excute("duplicate_touch_formation", 0, "click duplicate_touch_formation.'")]], isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ButtonChallenge, nil, {func_string = [[state_machine.excute("touch_button_challenge", 0, "click touch_button_challenge.'")]], isPressedActionEnabled = true}, nil, 0)
    -- 绘制图信息
    self:onUpdateDraw()
end

function NPCInformation:onExit()
    state_machine.remove("npc_information_request_sweep")
    state_machine.remove("npc_information_request_fight")
	
	state_machine.remove("touch_colose")
    state_machine.remove("duplicate_touch_formation")
    state_machine.remove("touch_button_challenge")
end

function NPCInformation:init(npcId)
	self.npcId = npcId
	self.npcCurStar = tonumber(_ED.npc_state[tonumber(""..npcId)])
	self.count = dms.string(dms["npc"], self.npcId, npc.get_star_describe)
end

