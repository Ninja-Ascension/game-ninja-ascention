----------------------------------------------------------------------------------------------------
-- 说明：日常活动副本
-------------------------------------------------------------------------------------------------------
PVEDailyActivityCopyRewardRanking = class("PVEDailyActivityCopyRewardRankingClass", Window)

function PVEDailyActivityCopyRewardRanking:ctor()
    self.super:ctor()
    self.roots = {}

    self.copyId = 0
    self.needFood = 0

	local function init_pve_daily_activity_copy_reward_ranking_terminal()

		local pve_daily_activity_copy_reward_ranking_close_terminal = {
            _name = "pve_daily_activity_copy_reward_ranking_close",
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

        local pve_daily_activity_copy_reward_ranking_request_fight_terminal = {
            _name = "pve_daily_activity_copy_reward_ranking_request_fight",
            _init = function (terminal)
                app.load("client.battle.BattleStartEffect")
                app.load("client.battle.fight.FightEnum")
                app.load("client.cells.prop.prop_buy_prompt")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               instance:challenge(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pve_daily_activity_copy_reward_ranking_close_terminal)
        state_machine.add(pve_daily_activity_copy_reward_ranking_request_fight_terminal)
        state_machine.init()
	end
	init_pve_daily_activity_copy_reward_ranking_terminal()
end


function PVEDailyActivityCopyRewardRanking:challenge(params)
	-- 判断是否有可挑次数
	if self:getFightCount() <= 0 then
		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			local vipLevel = zstring.tonumber(_ED.vip_grade)
			local resetCountElement = dms.element(dms["base_consume"], 54)
			local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
			local buytimes = zstring.tonumber(_ED.game_activity_buy_times)
			if buytimes < attackCount then   -- 已购买次数小于可购买次数
				TipDlg.drawTextDailog(_string_piece_info[253])
				return false
			else
				if vipLevel < _ED.max_vip_level then
					local vipLevel = zstring.tonumber(_ED.vip_grade) + 1
					local resetCountElement = dms.element(dms["base_consume"], 54)
					local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
					state_machine.excute("shortcut_open_recharge_tip_dialog", 0, {1, vipLevel, attackCount})
					return false
				else
					TipDlg.drawTextDailog(_string_piece_info[253])
					return false
				end
			end
		else
			local vipLevel = zstring.tonumber(_ED.vip_grade)
			local vipLevel = zstring.tonumber(_ED.vip_grade) + 1
			if vipLevel < _ED.max_vip_level then
				local resetCountElement = dms.element(dms["base_consume"], 54)
				local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
				state_machine.excute("shortcut_open_recharge_tip_dialog", 0, {1, vipLevel, attackCount})
				return false
			else
				TipDlg.drawTextDailog(_string_piece_info[253])
				return false
			end
		end	
	end
	-- 体力足的提示
	if self.needFood > zstring.tonumber(_ED.user_info.user_food) then
		fwin:open(PropBuyPrompt:new():init(31, 1), fwin._dialog)
		return
	end
	local function responseDailyInstanceCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			_ED._current_scene_id = 0
			_ED._scene_npc_id = dms.string(dms["daily_instance_mould"], tonumber(response.node.copyId), daily_instance_mould.npc)
			_ED._npc_difficulty_index = 0
			_ED._npc_addition_params = ""
			_ED._daily_copy_npc_id = response.node.copyId

			local battleStartEffectWindow = BattleStartEffect:new()
			-- battleStartEffectWindow:init(_enum_fight_type._fight_type_101 + response.node.copyId - 1)
			battleStartEffectWindow:init(_enum_fight_type._fight_type_101)
			fwin:cleanView(fwin._windows)
			fwin:open(battleStartEffectWindow, fwin._windows)
		end
	end

	local function launchBattle()
		protocol_command.daily_instance.param_list = ""..self.copyId
		NetworkManager:register(protocol_command.daily_instance.code, nil, nil, nil, self, responseDailyInstanceCallback, false, nil)
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
			local rid = self.npc
			protocol_command.camp_preference.param_list = ""..rid.."\r\n".."0"
			NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, nil, responseCampPreferenceCallback, false, nil)
		else
			launchBattle()
		end
	end
end


function PVEDailyActivityCopyRewardRanking:getFightCount()
    local vipLevel = zstring.tonumber(_ED.vip_grade)
    local attackCountElement = dms.element(dms["base_consume"], 53)
	self.fightCount = dms.atoi(attackCountElement, base_consume.vip_0_value + vipLevel) - zstring.tonumber(_ED.game_activity_times)

    return self.fightCount
end

function PVEDailyActivityCopyRewardRanking:init(_copyId, _needFood)
    self.copyId = _copyId
    self.needFood = _needFood
    return self
end

function PVEDailyActivityCopyRewardRanking:onUpdateDraw()
	local root = self.roots[1]
    local elementData = dms.element(dms["daily_instance_mould"], tonumber(self.copyId))
    self.npc = dms.atoi(elementData, daily_instance_mould.npc)
    -- 标题
    ccui.Helper:seekWidgetByName(root, "Text_tz_1"):setString(dms.atos(elementData, daily_instance_mould.instance_name))

    -- 达成条件
    ccui.Helper:seekWidgetByName(root, "Text_003"):setString(dms.atos(elementData, daily_instance_mould.extra_reward_condition))

    -- 奖励说明
    ccui.Helper:seekWidgetByName(root, "Text_004"):setString(dms.atos(elementData, daily_instance_mould.extra_reward_depic))

    local needParams = zstring.split(dms.atos(elementData, daily_instance_mould.extra_reward), "|")
    local nCount = #needParams
    -- if nCount > 8 then
    --     nCount = 8
    -- end
    for i=1,12 do
    	local image = ccui.Helper:seekWidgetByName(root, "Image_3_" .. i)
        if image ~= nil then 
        	image:setVisible(false)
        end
    end
    for i = 1, nCount do
        local params = zstring.split(needParams[i], ",")
        local needValue = params[1]
        local rewardValue = params[2]
        local text003 = ccui.Helper:seekWidgetByName(root, "Text_003_" .. i)
        local text004 = ccui.Helper:seekWidgetByName(root, "Text_004_" .. i)
        local image = ccui.Helper:seekWidgetByName(root, "Image_3_" .. i)
        if image ~= nil then 
        	image:setVisible(true)
        end
        if text003 ~= nil and text004 ~= nil then 
        	text003:setString(needValue)
        	text004:setString(rewardValue)
        end
    end
end

function PVEDailyActivityCopyRewardRanking:onEnterTransitionFinish()
	local csbPVEDailyActivityCopyRewardRanking = csb.createNode("duplicate/GameActivity/GameActivity_tz.csb")
    local root = csbPVEDailyActivityCopyRewardRanking:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVEDailyActivityCopyRewardRanking)
	
	-- 更新界面信息
	self:onUpdateDraw()

    -- 关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tz_1"), nil, 
    {
        terminal_name = "pve_daily_activity_copy_reward_ranking_close",     
        current_button_name = "Button_tz_1",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 2)

    -- 请求战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tz_2"), nil, 
    {
        terminal_name = "pve_daily_activity_copy_reward_ranking_request_fight",     
        current_button_name = "Button_tz_2",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 0)
end

function PVEDailyActivityCopyRewardRanking:onExit()
	state_machine.remove("pve_daily_activity_copy_reward_ranking_close")
    state_machine.remove("pve_daily_activity_copy_reward_ranking_request_fight")
end