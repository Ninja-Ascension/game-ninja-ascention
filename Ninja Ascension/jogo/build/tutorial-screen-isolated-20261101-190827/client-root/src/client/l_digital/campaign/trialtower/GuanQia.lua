-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双单个npc
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
GuanQia = class("GuanQiaClass", Window)

local function trialShipFightPower(ship)
    return tonumber(ship and ship.hero_fight) or 0
end

local function normalizeTrialFormation()
    local seen = {}
    local changed = false
    local requiredGrade = dms.int(dms["play_config"], 24, play_config.param)

    if type(_ED.user_formetion_status) ~= "table" then
        _ED.user_formetion_status = {}
        changed = true
    end
    if type(_ED.formetion) ~= "table" then
        _ED.formetion = {}
        changed = true
    end
    if _ED.formetion[1] == nil then
        _ED.formetion[1] = "0"
        changed = true
    end

    for slot = 1, 6 do
        local rawId = tonumber(_ED.user_formetion_status[slot])
        local ship = rawId and rawId > 0 and _ED.user_ship[""..rawId] or nil
        local trial = ship and _ED.user_try_ship_infos[""..ship.ship_id] or nil
        local hp = trial and tonumber(trial.newHp) or (ship and tonumber(ship.ship_health)) or 0
        local id = "0"

        if ship ~= nil and hp > 0 and (tonumber(ship.ship_grade) or 0) >= requiredGrade
            and not seen[tostring(ship.ship_id)] then
            id = tostring(ship.ship_id)
            seen[id] = true
        end

        if tostring(_ED.user_formetion_status[slot] or "0") ~= id
            or tostring(_ED.formetion[slot + 1] or "0") ~= id then
            changed = true
        end
        _ED.user_formetion_status[slot] = id
        _ED.formetion[slot + 1] = id
    end

    if changed then
        cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
        cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_info"), zstring.concat(_ED.formetion, ","))
    end
end
    
function GuanQia:ctor()
    self.super:ctor()
	app.load("client.battle.fight.FightEnum")
	app.load("client.cells.ship.hero_icon_list_cell")
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
	
	self.ship_info = {}
	self.battle_integral_list = {}
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
          	 	if nil ~= _ED.user_formetion_status_copy then
		            _ED.user_formetion_status = _ED.user_formetion_status_copy
		            _ED.user_formetion_status_copy = nil
		        end
		        if nil ~= _ED.formetion_copy then
		            _ED.formetion = _ED.formetion_copy
		            _ED.formetion_copy = nil
		        end
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

        --一键布阵
        local guan_qia_oen_key_formation_window_terminal = {
            _name = "guan_qia_oen_key_formation_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:oneKeyFormationChange(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guan_qia_open_join_formation_window_terminal = {
            _name = "guan_qia_open_join_formation_window",
            _init = function (terminal) 
            	app.load("client.l_digital.campaign.trialtower.SmTrialTowerChangeWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_trial_tower_change_window_open", 0, params._datas._pages)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guan_qia_formation_terminal = {
            _name = "guan_qia_formation",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:joinFormtion(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guan_qia_formation_change_request_terminal = {
            _name = "guan_qia_formation_change_request",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:formationChange(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guan_qia_formation_change_back_terminal = {
            _name = "guan_qia_formation_change_back",
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

        -- 阵型变更
        local guan_qia_formation_change_terminal = {
            _name = "guan_qia_formation_change",
            _init = function (terminal)
                app.load("client.formation.FormationChange") 
                app.load("client.home.HomeHero") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                print("[NINJA_TRIAL_TRACE][client] desafiar clicado indice="..tostring(params and params._datas and params._datas._pages))
                for i,v in pairs(_ED.user_formetion_status) do
                    if tonumber(v) > 0 then
                        _ED.three_kingdoms_battle_index = tonumber(params._datas._pages)
                        app.load("client.formation.FormationChange")
                        state_machine.excute("formation_change_window_open", 0, {"guan_qia_into_battle", "guan_qia_formation_change_request", "guan_qia_formation_change_back"})
                        -- local formationChangeWindow = FormationChange:new()
                        -- fwin:open(formationChangeWindow, fwin._windows)
                        return
                    end
                end
                TipDlg.drawTextDailog(_new_interface_text[143])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进入战斗
        local guan_qia_into_battle_terminal = {
            _name = "guan_qia_into_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:fight(_ED.three_kingdoms_battle_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(trial_tower_formation_terminal)
		state_machine.add(guan_qia_back_activity_terminal)
		state_machine.add(trial_tower_challenge_terminal)
		state_machine.add(guan_qia_open_change_window_terminal)
		state_machine.add(guan_qia_oen_key_formation_window_terminal)
		state_machine.add(guan_qia_open_join_formation_window_terminal)
		state_machine.add(guan_qia_formation_terminal)
		state_machine.add(guan_qia_formation_change_terminal)
        state_machine.add(guan_qia_into_battle_terminal)
        state_machine.add(guan_qia_formation_change_request_terminal)
		state_machine.add(guan_qia_formation_change_back_terminal)

        state_machine.init()
    end
    
    -- call func init guan qia state machine.
    init_guan_qia_terminal()
end


function GuanQia:onUpdateDraw()
	local root = self.roots[1]
	for i=1, 3 do
		local Sprite = ccui.Helper:seekWidgetByName(root,"Sprite_"..i)
		local Panel_yc = ccui.Helper:seekWidgetByName(root,"Panel_yc_"..i)
		local Panel_emeny = ccui.Helper:seekWidgetByName(root,"Panel_emeny_"..i)
		if Sprite == nil or Panel_yc == nil or Panel_emeny == nil then
			print("[NINJA_TRIAL_TRACE][client] render inimigo incompleto indice="..i
				.." sprite="..tostring(Sprite ~= nil).." card="..tostring(Panel_yc ~= nil)
				.." painel="..tostring(Panel_emeny ~= nil))
		else
		local maxStar = 0
		local drawShip = 0
		for j, v in pairs(self.ship_info[i]) do
			if tonumber(v) ~= 0 then
				if drawShip == 0 then
					drawShip = dms.int(dms["environment_ship"], v, environment_ship.bust_index)
				end
			end
		end

		local temp_bust_index = drawShip
		if tonumber(temp_bust_index) and tonumber(temp_bust_index) > 0 then
			local armature_hero = sp.spine_sprite(Panel_emeny, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			armature_hero.animationNameList = spineAnimations
			sp.initArmature(armature_hero, true)
		end
		end
	end

end

function GuanQia:fight(index)

	_ED.three_kingdoms_battle_integral = self.battle_integral_list[tonumber(index)]
	
	-- 战斗请求
	local function responseBattleInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--state_machine.excute("page_stage_fight_data_deal", 0, 0)
            --记录战斗的是第几个
            cc.UserDefault:getInstance():setStringForKey(getKey("GuanBattleIndex"), index)
            cc.UserDefault:getInstance():flush()

			cacher.removeAllTextures()
			
			fwin:cleanView(fwin._windows)
			cc.Director:getInstance():purgeCachedData()
			
			local bse = BattleStartEffect:new()
			bse:init(54)
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
			local fightType = 0
			fightType = _enum_fight_type._fight_type_54
            _ED.three_kingdoms_npc_fight = self.three_kingdoms_npc_fight[tonumber(index)]
            if zstring.tonumber(_ED.three_kingdoms_npc_fight) < 1000 then
                _ED.three_kingdoms_npc_fight = 1000
            end
            _ED._fightModule:initSpecialFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
			-- _ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
            for j, w in pairs(_ED.three_kingdoms_view.atrribute) do
                local buff_info = zstring.split(w[1] ,":")
                local shipId = tonumber(buff_info[2])
                local attribute_value = zstring.split(dms.string(dms["three_kingdoms_attribute"], tonumber(buff_info[1]), three_kingdoms_attribute.attribute_value),",")
                local value_info = attribute_value[1]..","..tonumber(attribute_value[2])*tonumber(w[2])
                for i, v in pairs(_ED.user_info.battleCache.attackerObjects) do
                    if shipId < 0 or shipId == tonumber(v.id) then
                        v:addPropertyValues(value_info)
                    end
                end
            end
             for i, v in pairs(_ED.user_info.battleCache.attackerObjects) do
                if _ED.user_try_ship_infos[""..v.id] ~= nil then
                    -- v.healthPoint = v.healthPoint * (zstring.tonumber(_ED.user_try_ship_infos[""..v.id].maxHp)/100)
                    -- 新增一个变量专门为了处理试炼回血bug068
                    v.healthPoint_from_try = _ED.user_try_ship_infos["" .. v.id].newHp
                    v.skillPoint = zstring.tonumber(_ED.user_try_ship_infos[""..v.id].newanger)
                end
            end
            for i,v in pairs(_ED.battleData._heros) do
                if _ED.user_try_ship_infos[v._id] ~= nil then
                    v._current_hp = tonumber(v._hp) * (zstring.tonumber(_ED.user_try_ship_infos[""..v._id].maxHp)/100)
                    v._current_sp = zstring.tonumber(_ED.user_try_ship_infos[""..v._id].newanger)
                end
            end
			local orderList = {}
			_ED._fightModule:initFightOrder(_ED.user_info, orderList)
            
			responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
		else
			_ED._current_scene_id = ""
			_ED._scene_npc_id = ""
			_ED.trial_scene_npc_id = ""
			_ED._npc_difficulty_index = ""
			_ED.trial_star_Magnification = 1
		end
    end
    -- _ED.battleData.battle_init_type = _enum_fight_type._fight_type_102
    -- protocol_command.battle_result_start.param_list = "".._enum_fight_type._fight_type_102.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
    -- print("protocol_command.battle_result_start.param_list=="..protocol_command.battle_result_start.param_list)
    -- NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, true, nil)
    responseBattleStartCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
	end
	
	local npcs = zstring.split(_ED.three_kingdoms_npc_formation_infos, ",")
	_ED._current_scene_id = dms.string(dms["play_config"], 26, play_config.param)
	_ED._scene_npc_id = npcs[tonumber(index)]
	_ED.trial_scene_npc_id = npcs[tonumber(index)]
	_ED._npc_difficulty_index = "1"
	_ED.trial_star_Magnification = 1
	if tonumber(index) == 1 then
		_ED.trial_star_Magnification = 1
	elseif tonumber(index) == 2 then
		_ED.trial_star_Magnification = 3
	else
		_ED.trial_star_Magnification = 5
	end

	launchBattle()
end

function GuanQia:onUpdateDrawFormation( ... )
	local root = self.roots[1]
	local newFight = 0
    for i=1,6 do
        if tonumber(_ED.user_formetion_status[i]) ~= tonumber(_ED.formetion[i + 1]) then
            _ED.formetion[i + 1] = _ED.user_formetion_status[i]
        end
    end
	for i=1, 6 do
		local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root,"Panel_digimon_icon_"..i)
		Panel_digimon_icon:removeAllChildren(true)
		local cell = HeroIconListCell:createCell()
        local ship = _ED.user_ship["".._ED.user_formetion_status[i]]
        local LoadingBar_hp = ccui.Helper:seekWidgetByName(root,"LoadingBar_hp_"..i)
        local LoadingBar_mp = ccui.Helper:seekWidgetByName(root,"LoadingBar_mp_"..i)
        LoadingBar_hp:setVisible(false)
        LoadingBar_mp:setVisible(false)
        if nil ~= ship then
            LoadingBar_hp:setVisible(true)
            LoadingBar_mp:setVisible(true)
            if nil ~= _ED.user_try_ship_infos[""..ship.ship_id] and tonumber(_ED.user_try_ship_infos[""..ship.ship_id].newHp) <= 0 then
                _ED.user_formetion_status[i] = "0"
                _ED.formetion[i + 1] = "0"
                LoadingBar_hp:setVisible(false)
                LoadingBar_mp:setVisible(false)
            end
            if tonumber(ship.ship_grade) >= dms.int(dms["play_config"], 24, play_config.param) then
                if _ED.user_try_ship_infos[""..ship.ship_id] ~= nil and tonumber(_ED.user_try_ship_infos[""..ship.ship_id].newHp) > 0 then
                    cell:init(ship, i, true)
                    local Image_line_role = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_line_role")
                    if nil ~= Image_line_role then
                        Image_line_role:setVisible(false)
                    end

                	Panel_digimon_icon:addChild(cell)

                	
                	LoadingBar_hp:setPercent(tonumber(_ED.user_try_ship_infos[""..ship.ship_id].maxHp))
                	
                    local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
                	LoadingBar_mp:setPercent(tonumber(_ED.user_try_ship_infos[""..ship.ship_id].newanger)/tonumber(fightParams[4])*100)
                	
                	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
                    {
                        terminal_name = "guan_qia_open_join_formation_window",
                        _pages = i,
                        isPressedActionEnabled = true
                    },
                    nil,0)

                    local buffShip = nil
                    buffShip = ship
                    local ship_base_intellect = zstring.tonumber(ship.ship_base_intellect)
                    local ship_base_courage = zstring.tonumber(ship.ship_base_courage)
                    local crit_add = zstring.tonumber(ship.crit_add)
                    local parry_add = zstring.tonumber(ship.parry_add)
                    local add_ship_base_intellect = 0
                    local add_ship_base_courage = 0
                    local add_crit_add = 0
                    local add_parry_add = 0
                    for j, w in pairs(_ED.three_kingdoms_view.atrribute) do
                        local buff_info = zstring.split(w[1] ,":")
                        local attribute_value = zstring.split(dms.string(dms["three_kingdoms_attribute"], tonumber(buff_info[1]), three_kingdoms_attribute.attribute_value),",")
                        local values = tonumber(attribute_value[2])*tonumber(w[2])
                        if tonumber(attribute_value[1]) == 42 then
                            --反伤

                        elseif tonumber(attribute_value[1]) == 8 then
                            --暴击
                            add_crit_add = add_crit_add + values
                            -- buffShip.crit_add = zstring.tonumber(ship.crit_add) + values
                        elseif tonumber(attribute_value[1]) == 6 then
                            --防御
                            add_ship_base_intellect = add_ship_base_intellect + values
                            -- buffShip.ship_base_intellect = zstring.tonumber(buffShip.ship_base_intellect) + values
                        elseif tonumber(attribute_value[1]) == 10 then
                            --各挡
                            add_parry_add = add_parry_add + values
                            -- buffShip.parry_add = zstring.tonumber(ship.parry_add) + values
                        elseif tonumber(attribute_value[1]) == 5 then
                            --攻击
                            add_ship_base_courage = add_ship_base_courage + values
                            -- buffShip.ship_base_courage = zstring.tonumber(buffShip.ship_base_courage) + values
                        elseif tonumber(attribute_value[1]) == 40 then
                            --吸血
                        end
                    end
                    buffShip.crit_add = zstring.tonumber(ship.crit_add) + add_crit_add
                    buffShip.ship_base_intellect = zstring.tonumber(buffShip.ship_base_intellect)*(1+add_ship_base_intellect)
                    buffShip.parry_add = zstring.tonumber(ship.parry_add) + add_parry_add
                    buffShip.ship_base_courage = zstring.tonumber(buffShip.ship_base_courage)*(1+add_ship_base_courage)
                    newFight = newFight + tonumber(getShipByTalent(buffShip).hero_fight)
                    ship.ship_base_courage = ship_base_courage
                    ship.ship_base_intellect = ship_base_intellect
                    ship.crit_add = crit_add
                    ship.parry_add = parry_add
                    -- newFight = newFight + tonumber(ship.hero_fight)
                end
            end
        end
	end
	local Text_all_fighting = ccui.Helper:seekWidgetByName(root,"Text_all_fighting")
	Text_all_fighting:setString(newFight)
end

function GuanQia:getFormationCount()
    local nMaxCount = 6
    return nMaxCount
end

--一键上阵
function GuanQia:oneKeyFormationChange()
    -- state_machine.unlock("battle_ready_window_oen_key_formation_window")

    local nMaxCount = self:getFormationCount()
    local candidateCount = 0
    local rosterCount = 0
    if type(_ED.user_ship) == "table" then
        for _ in pairs(_ED.user_ship) do rosterCount = rosterCount + 1 end
    end
    print("[NINJA_TRIAL_TRACE][client] quick_formation inicio roster="..rosterCount)

    local function fightingCapacity(a,b)
        local al = trialShipFightPower(a)
        local bl = trialShipFightPower(b)
        if al ~= bl then return al > bl end
        return tonumber(a.ship_id) < tonumber(b.ship_id)
    end

    local fightShipList = {}
    for i, ship in pairs(_ED.user_ship) do
	    if ship.ship_id ~= nil then
	        local shipId = tostring(ship.ship_id)
	        local trialInfo = _ED.user_try_ship_infos and _ED.user_try_ship_infos[shipId] or nil
	        local remainingHp = trialInfo and tonumber(trialInfo.newHp)
	            or tonumber(ship.ship_health) or 0
	        if dms.int(dms["play_config"], 24, pirates_config.param) <= (tonumber(ship.ship_grade) or 0)
	            and remainingHp > 0 then
	            if trialInfo == nil then
	                _ED.user_try_ship_infos = _ED.user_try_ship_infos or {}
	                _ED.user_try_ship_infos[shipId] = {
	                    newHp = remainingHp, maxHp = 100, newanger = 0, id = ship.ship_id
	                }
	            end
	            table.insert(fightShipList, ship)
	            candidateCount = candidateCount + 1
	        end
        end
    end
    table.sort(fightShipList, fightingCapacity)
    print("[NINJA_TRIAL_TRACE][client] quick_formation candidatos="..candidateCount)

    local str = ""
    for i = 1, 6 do
        _ED.formetion[i + 1] = 0
        _ED.user_formetion_status[i] = 0
        if i <= nMaxCount then
            local ship = fightShipList[i]
            local shipId = zstring.tonumber(_ED.formetion[i + 1])
            if nil ~= ship and nil ~= _ED.user_try_ship_infos[""..ship.ship_id] then
                if tonumber(_ED.user_try_ship_infos[""..ship.ship_id].newHp) > 0 then
                    _ED.formetion[i + 1] = ship.ship_id
                    _ED.user_formetion_status[i] = ship.ship_id
                end
            end
        end
    end
    
    cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_info"), zstring.concat(_ED.formetion, ","))
	local selectedCount = 0
	for i=1, nMaxCount do
	    if tonumber(_ED.user_formetion_status[i]) and tonumber(_ED.user_formetion_status[i]) > 0 then
	        selectedCount = selectedCount + 1
	    end
	end
	print("[NINJA_TRIAL_TRACE][client] quick_formation selecionados="..selectedCount)

    self:onUpdateDrawFormation()
end

function GuanQia:formationChange(params)
    for i=1,6 do
        if tonumber(_ED.user_formetion_status[i]) ~= tonumber(_ED.formetion[i+1]) then
            _ED.user_formetion_status[i] = _ED.formetion[i+1]
        end
    end
    cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_info"), zstring.concat(_ED.formetion, ","))
end


--阵型变更
function GuanQia:joinFormtion(params)

    local nMaxCount = self:getFormationCount()

    local cell_index = params[1]
    local ship_id = params[2]

    for i, v in pairs(_ED.user_formetion_status) do
        if zstring.tonumber(v) <= 0 and i <= nMaxCount then
            cell_index = i
            break
        end
    end

    local old_ship_id = zstring.tonumber(_ED.user_formetion_status[cell_index])
    _ED.user_formetion_status[cell_index] = ship_id
    for i = 1, 6 do
        local shipId = zstring.tonumber(_ED.formetion[i + 1])
        if i <= nMaxCount then
            if shipId > 0 then
                if old_ship_id == shipId then
                    _ED.formetion[i + 1] = ship_id
                    break
                end
            else
                _ED.formetion[i + 1] = ship_id
                break
            end
        end
    end
    
    cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_info"), zstring.concat(_ED.formetion, ","))

    self:onUpdateDrawFormation()
    state_machine.excute("sm_trial_tower_change_window_close", 0, "")

end

function GuanQia:initData()
	local root = self.roots[1]
	_ED.user_formetion_status_copy = {}
    _ED.formetion_copy = {}
    table.merge(_ED.user_formetion_status_copy, _ED.user_formetion_status)
    table.merge(_ED.formetion_copy, _ED.formetion)

    --如果数据没有说明全部满血
    if _ED.user_try_ship_infos == nil or _ED.user_try_ship_infos == "" or table.nums(_ED.user_try_ship_infos) <= 0 then
        _ED.user_try_ship_infos = {}
    end
    for i, v in pairs(_ED.user_ship) do
        local ships = {}
        ships.newHp = v.ship_health
        ships.maxHp = 100                   --血量的百分比
        ships.newanger = 0
        ships.id = v.ship_id
        if _ED.user_try_ship_infos[""..v.ship_id] == nil then
            _ED.user_try_ship_infos[""..v.ship_id] = ships
        -- else
        --     _ED.user_try_ship_infos[v.ship_id].newHp = tonumber(_ED.user_ship[""..v.ship_id].ship_health)*(tonumber(_ED.user_try_ship_infos[v.ship_id].maxHp)/100)
        end
    end

    for i, v in pairs(_ED.user_formetion_status) do
        _ED.user_formetion_status[i] = "0"
    end
    for i, v in pairs(_ED.formetion) do
        _ED.formetion[i] = "0"
    end

    local trial_copy_formation_status_info = cc.UserDefault:getInstance():getStringForKey(getKey("trial_copy_formation_status_info"), "")
    local trial_copy_formation_info = cc.UserDefault:getInstance():getStringForKey(getKey("trial_copy_formation_info"), "")
    if nil == trial_copy_formation_status_info or "" == trial_copy_formation_status_info or nil == trial_copy_formation_info or "" == trial_copy_formation_info then
        cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
        cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_info"), zstring.concat(_ED.formetion, ","))
    else
        _ED.user_formetion_status = zstring.split(trial_copy_formation_status_info, ",")
        _ED.formetion = zstring.split(trial_copy_formation_info, ",")
        -- FURY_ALINEACION_LOCAL: la alineacion guardada en el telefono puede nombrar heroes que el rol ya no tiene (borrado de la beta): hueco vacio y se guarda limpia
        local fury_stale = false
        for i, v in pairs(_ED.user_formetion_status) do
            if (tonumber(v) or 0) > 0 and _ED.user_ship[""..v] == nil then _ED.user_formetion_status[i] = "0"; fury_stale = true end
        end
        for i = 2, #_ED.formetion do
            local v = _ED.formetion[i]
            if (tonumber(v) or 0) > 0 and _ED.user_ship[""..v] == nil then _ED.formetion[i] = "0"; fury_stale = true end
        end
        if fury_stale then
            cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
            cc.UserDefault:getInstance():setStringForKey(getKey("trial_copy_formation_info"), zstring.concat(_ED.formetion, ","))
        end
        -- FURY_ALINEACION_LOCAL fin
    end

    normalizeTrialFormation()
	
end

function GuanQia:setObjectInfo()
    local root = self.roots[1]
    local function findTrialWidget(name)
        local widget = ccui.Helper:seekWidgetByName(root, name)
        if widget == nil then
            print("[NINJA_TRIAL_TRACE][client] widget ausente="..name)
        end
        return widget
    end
    local integral_Interval = zstring.split(dms.string(dms["play_config"], 23, play_config.param), "!")
    local intervalData = nil
    for i, v in pairs(integral_Interval) do
        local datas = zstring.split(v, "|")
        local levels = zstring.split(datas[1], ",")
        if tonumber(_ED.user_info.user_grade) <= tonumber(levels[2]) then
            intervalData = datas
            break
        end
    end

    --计算战力
    local function fightingCapacity(a,b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local fightShipList = {}

    for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil then
            if dms.int(dms["play_config"], 24, pirates_config.param) <= tonumber(ship.ship_grade) then
                table.insert(fightShipList, ship) 
            end
        end
    end
    table.sort(fightShipList, fightingCapacity)

    local fightShip = 0
    for i=1, 6 do
        if fightShipList[i] ~= nil then
            fightShip = fightShip + tonumber(getShipByTalent(fightShipList[i]).hero_fight)
        end
    end

    local Panel_2 = ccui.Helper:seekWidgetByName(root,"Panel_2")
    --找到npc
    print("[NINJA_TRIAL_TRACE][client] setObjectInfo npc_ids="..tostring(_ED.three_kingdoms_npc_formation_infos))
    local npcs = zstring.split(_ED.three_kingdoms_npc_formation_infos, ",")
    print("[NINJA_TRIAL_TRACE][client] setObjectInfo total="..#npcs)

    local ratio = zstring.split(dms.string(dms["play_config"], 29, pirates_config.param),",")

    local try_ship_datas = zstring.split(_ED.user_try_ship_datas, "-")
    local death_level = 0
    --获取之前打了哪个
    local GuanBattleIndex = cc.UserDefault:getInstance():getStringForKey(getKey("GuanBattleIndex"), "")
    if GuanBattleIndex ~= nil and GuanBattleIndex ~= "" and tonumber(GuanBattleIndex) ~= -1 then
        death_level = tonumber(GuanBattleIndex)
    end
    if try_ship_datas[2] ~= nil then
        local try_info = zstring.split(try_ship_datas[2], ",")
        if tonumber(_ED.integral_current_index) == tonumber(try_info[1]) then
            death_level = tonumber(try_info[2])
        end
    end
    self.three_kingdoms_npc_fight = {}
    for i=1, 3 do
        local Sprite = Panel_2:getChildByName("Sprite_"..i)

        local Image_lock = Sprite:getChildByName("Image_lock_"..i)
        Image_lock:setVisible(false)
        local Button_img = Sprite:getChildByName("Button_tz_"..i)
        Button_img:setVisible(false)
        local Panel_yc = Sprite:getChildByName("Panel_yc_"..i)
        if death_level == 0 then
            Panel_yc:setVisible(true)
            Button_img:setVisible(true)
        else
            if death_level == i then
                Panel_yc:setVisible(true)
                Button_img:setVisible(true)
            else
                Panel_yc:setVisible(false)
                Image_lock:setVisible(true)
            end
        end
        local Panel_emeny = Panel_yc:getChildByName("Panel_emeny_"..i)
        Panel_emeny:removeAllChildren(true)
        --找到npc的环境阵型
        local environment_formation1 = dms.string(dms["npc"], tonumber(npcs[i]), npc.environment_formation1)
        print("[NINJA_TRIAL_TRACE][client] npc="..tostring(npcs[i]).." formacao="..tostring(environment_formation1))
        
        --通过环境阵型找到环境战船
        self.ship_info[i] = {}
        for j=1, 6 do
            local ship = dms.int(dms["environment_formation"], environment_formation1, environment_formation.seat_one+j-1)
            self.ship_info[i][j] = ship
        end

        --基础积分加成
        local Text_jifen_plus = findTrialWidget("Text_jifen_plus_"..i)
        local addition_data = zstring.split(dms.string(dms["play_config"], 32, play_config.param),"|")
        local addition_info = 0
        for j,v in pairs(addition_data) do
            local addition = zstring.split(v,",")
            if tonumber(_ED.vip_grade) >= tonumber(addition[1]) then
                addition_info = tonumber(addition[2])
            end
        end
        if Text_jifen_plus ~= nil then
            if addition_info == 0 then
                Text_jifen_plus:setString("")
            else
                Text_jifen_plus:setString("+"..addition_info.."%")
            end
        end

        --基础积分
        local Text_jifen = findTrialWidget("Text_jifen_"..i)
        local interval_info = zstring.split(intervalData[2], ",")
        local tolerance = zstring.split(intervalData[3], ",")
        --基础积分+（公差）*（第几次怪物层-1）
        local total_score = math.floor((tonumber(interval_info[i])+zstring.tonumber(tolerance[i])*math.floor(tonumber(_ED.integral_current_index)/2)))-- * (1 + addition_info/100))
        if Text_jifen ~= nil then Text_jifen:setString(total_score) end
        self.battle_integral_list[i] = {}
        self.battle_integral_list[i] = total_score

        --基础倍率
        local Text_star_n = findTrialWidget("Text_star_n_"..i)
        if Text_star_n ~= nil then
            if i==1 then
                Text_star_n:setString("1")
            elseif i==2 then
                Text_star_n:setString("3")
            else
                Text_star_n:setString("5")
            end
        end
        --战力
        -- O CSB coloca este label em um nivel diferente em algumas variantes
        -- de idioma; procurar a arvore inteira evita nil no setString abaixo.
        local Text_fighting = findTrialWidget("Text_fighting_"..i)
        
        if fightShip < zstring.tonumber(dms.int(dms["play_config"], 78, play_config.param)) then
            fightShip = zstring.tonumber(dms.int(dms["play_config"], 78, play_config.param))
        end
        local enemyFight
        if i == 1 then
            enemyFight = math.ceil(fightShip*tonumber(self.info))
        else
            enemyFight = math.ceil(fightShip*tonumber(self.info)*tonumber(ratio[i-1]))
        end
        table.insert(self.three_kingdoms_npc_fight, enemyFight)
        if Text_fighting ~= nil then
            Text_fighting:setString(enemyFight)
        else
            print("[NINJA_TRIAL_TRACE][client] widget Text_fighting_"..i.." ausente")
        end
        -- Text_fighting:setString(dms.int(dms["environment_formation"], environment_formation1, environment_formation.combat_force))
        
        --名称
        local Text_name = findTrialWidget("Text_name_"..i)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            local name_info = ""
            local name_data = zstring.split(dms.string(dms["npc"], tonumber(npcs[i]), npc.npc_name), "|")
            for i, v in pairs(name_data) do
                local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
                name_info = name_info..word_info[3]
            end
            if Text_name ~= nil then Text_name:setString(name_info) end
        else    
            if Text_name ~= nil then
                Text_name:setString(dms.string(dms["npc"], tonumber(npcs[i]), npc.npc_name))
            end
        end
    end
end

function GuanQia:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_2.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)

    self:setObjectInfo()
    self:initData()
    self:onUpdateDrawFormation()
    self:onUpdateDraw()
	
	-- 关闭窗口

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, {
		func_string = [[state_machine.excute("guan_qia_back_activity", 0, "guan_qia_back_activity.'")]],
		isPressedActionEnabled = true,
	}, nil, 3)
	
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

	--一键上阵
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_quick_formation"), nil, 
    {
        terminal_name = "guan_qia_oen_key_formation_window", 
        isPressedActionEnabled = true
    },
    nil,0)

	for i=1, 6 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_"..i), nil, 
	    {
	        terminal_name = "guan_qia_open_join_formation_window", 
	        _pages = i,
	        isPressedActionEnabled = true
	    },
	    nil,0)
	end

	--挑战
	local Panel_2 = ccui.Helper:seekWidgetByName(root,"Panel_2")
	
	for i=1, 3 do
        local challengeButton = ccui.Helper:seekWidgetByName(root, "Button_tz_"..i)
        if challengeButton ~= nil then
        fwin:addTouchEventListener(challengeButton, nil, 
        {
            terminal_name = "guan_qia_formation_change", 
            _pages = i,
            isPressedActionEnabled = true
        },
        nil,0)
        else
            print("[NINJA_TRIAL_TRACE][client] botao desafiar ausente indice="..i)
        end
	end
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
    state_machine.remove("trial_tower_formation")
    state_machine.remove("guan_qia_back_activity")
    state_machine.remove("trial_tower_challenge")
    state_machine.remove("guan_qia_open_change_window")
    state_machine.remove("guan_qia_oen_key_formation_window")
    state_machine.remove("guan_qia_open_join_formation_window")
    state_machine.remove("guan_qia_formation")
    state_machine.remove("guan_qia_formation_change")
    state_machine.remove("guan_qia_into_battle")
    state_machine.remove("guan_qia_formation_change_request")
    state_machine.remove("guan_qia_formation_change_back")
end
