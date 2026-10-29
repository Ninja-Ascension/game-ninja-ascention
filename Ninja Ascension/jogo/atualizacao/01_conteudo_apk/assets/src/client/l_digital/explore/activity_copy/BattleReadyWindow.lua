-- ----------------------------------------------------------------------------------------------------
-- 说明：数码冒险活动副本主界面
-------------------------------------------------------------------------------------------------------
BattleReadyWindow = class("BattleReadyWindowClass", Window)

local battle_ready_window_open_terminal = {
    _name = "battle_ready_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if state_machine.excute("activity_copy_window_check_battle_cd", 0, 0) == true then
            state_machine.excute("battle_ready_window_close")
            if nil == fwin:find("BattleReadyWindowClass") then
                fwin:open(BattleReadyWindow:new():init(params), fwin._view)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_ready_window_close_terminal = {
    _name = "battle_ready_window_close",
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
        fwin:close(fwin:find("BattleReadyWindowClass"))
        fwin:close(fwin:find("UserTopInfoAClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_ready_window_open_terminal)
state_machine.add(battle_ready_window_close_terminal)
state_machine.init()

function BattleReadyWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua file
    app.load("client.cells.ship.hero_icon_list_cell")

    app.load("client.packs.hero.HeroFormationChoiceWear")

    -- var
    self._current_page_index = 1
    self._scene = nil
    self._scene_id = 0
    self._npc_id = 0
    self.currentSceneType = 0
    self.activity_copy_formation_status_info_key = nil
    self.activity_copy_formation_info_key = nil

    self.listData = {}

    -- Initialize explore window state machine.
    local function init_battle_ready_window_terminal()
        local battle_ready_window_open_fun_window_terminal = {
            _name = "battle_ready_window_open_fun_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local pageType = params._datas.page_type
                if 1 == pageType then
                    TipDlg.drawTextDailog("缺少界面资源")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ready_window_oen_key_formation_window_terminal = {
            _name = "battle_ready_window_oen_key_formation_window",
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

        local battle_ready_window_formation_change_request_terminal = {
            _name = "battle_ready_window_formation_change_request",
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

        local battle_ready_window_formation_change_back_terminal = {
            _name = "battle_ready_window_formation_change_back",
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

        local battle_ready_window_formation_change_terminal = {
            _name = "battle_ready_window_formation_change",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isOver = false
                local ListView_huodong_guaka_line = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_huodong_guaka_line")
                local items = ListView_huodong_guaka_line:getItems()
                for i, v in pairs(items) do
                    if v.ship ~= nil then
                        isOver = true
                        break
                    end
                end

                if isOver == false then
                    TipDlg.drawTextDailog(_new_interface_text[143])
                    return
                end
                
                -- for k,v in pairs(_ED.formetion) do
                --     if k > 1 then
                --         if tonumber(v) > 0 then
                --             _ED.user_ship[""..v] = getShipByTalent(_ED.user_ship[""..v])
                --         end
                --     end
                -- end

                app.load("client.formation.FormationChange")
                state_machine.excute("formation_change_window_open", 0, {"battle_ready_window_join_battle", "battle_ready_window_formation_change_request", "battle_ready_window_formation_change_back"})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ready_window_join_battle_terminal = {
            _name = "battle_ready_window_join_battle",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("battle_ready_window_join_battle")
                -- 战斗请求
                local function responseBattleInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        --state_machine.excute("page_stage_fight_data_deal", 0, 0)
                    
                        cacher.removeAllTextures()
                        
                        fwin:cleanView(fwin._windows)
                        cc.Director:getInstance():purgeCachedData()
                        
                        -- 记录上次战斗是否选择的最后的NPC
                        LDuplicateWindow._infoDatas._isLastNpc = instance.npcState == 1 and true or false
                        LDuplicateWindow._infoDatas._isNewNPCAction = false
                        
                        local bse = BattleStartEffect:new()
                        bse:init(instance.currentSceneType)
                        fwin:open(bse, fwin._windows)
                    end
                end

                local function responseBattleStartCallback( response )
                    state_machine.unlock("battle_ready_window_join_battle")
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.battle.report.BattleReport")
                        app.load("client.battle.BattleStartEffect")

                        _ED.user_info.last_user_grade = _ED.user_info.user_grade
                        _ED.user_info.last_user_experience = _ED.user_info.user_experience
                        _ED.user_info.last_user_grade_need_experience = _ED.user_info.user_grade_need_experience
                        
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
                        if instance.currentSceneType ~= nil then
                            fightType = instance.currentSceneType
                        end
                        if fightType == 1 then
                            fightType = _enum_fight_type._fight_type_108
                        end
                        _ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
                        local orderList = {}
                        _ED._fightModule:initFightOrder(_ED.user_info, orderList)
                        
                        responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                    end
                end

                local formationInfo = ""
                for i, v in pairs(_ED.user_formetion_status) do
                    local ship = _ED.user_ship[""..v]
                    if ship ~= nil then
                        if formationInfo == "" then
                            formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        else
                            formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        end
                    else
                        if formationInfo == "" then
                            formationInfo = "0,0,0,0"
                        else
                            formationInfo = formationInfo.."|".."0,0,0,0"
                        end
                    end
                end
                _ED._current_scene_id = instance._scene_id
                _ED._scene_npc_id = instance._npc_id
                _ED._npc_difficulty_index = 1
                protocol_command.battle_result_start.param_list = "".. instance.currentSceneType .."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n0\r\n"..formationInfo
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ready_window_open_join_formation_window_terminal = {
            _name = "battle_ready_window_open_join_formation_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.activity_battle_copy_formation_limit = nil
                if instance.currentSceneType == 52 then
                    _ED.activity_battle_copy_formation_limit = 3
                end
                state_machine.excute("hero_formation_choice_wear_window_open", 0, {params._datas.cell_index, 1, -1, nil, "battle_ready_window_join_formation", params._datas.cell_index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ready_window_join_formation_terminal = {
            _name = "battle_ready_window_join_formation",
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

        state_machine.add(battle_ready_window_open_fun_window_terminal)
        state_machine.add(battle_ready_window_oen_key_formation_window_terminal)
        state_machine.add(battle_ready_window_formation_change_request_terminal)
        state_machine.add(battle_ready_window_formation_change_back_terminal)
        state_machine.add(battle_ready_window_formation_change_terminal)
        state_machine.add(battle_ready_window_join_battle_terminal)
        state_machine.add(battle_ready_window_open_join_formation_window_terminal)
        state_machine.add(battle_ready_window_join_formation_terminal)
        state_machine.init()
    end

    -- call func init explore window state machine.
    init_battle_ready_window_terminal()
end

function BattleReadyWindow:init(params)
    local sceneIndex = params[1]
    local npcIndex = params[2]
    local scene = params[3]

    local sceneType = dms.atos(scene, pve_scene.scene_type)

    -- local scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, sceneType)
    -- local scene = scenes[1]
    local npcs = nil
    local npcId = 0
    _ED._activity_copy_battle_index = npcIndex
    if tonumber(sceneType) == 51 then
        local scene_data = zstring.split(dms.atos(scene, pve_scene.npcs), ",")
        npcs = zstring.split(scene_data[npcIndex], ":")

        local current = _ED.system_time + (os.time() - _ED.native_time) - 5*60*60
        -- local weekDay = os.date("%w",os.time())
        local weekDay = tonumber(os.date("%w", getBaseGTM8Time(current)))
        if weekDay == 0 then
            weekDay = 7
        end

        local serviceDay = tonumber(_ED.m_open_service_number)
        local week_num = serviceDay and math.ceil(serviceDay/7) or nil

        local index = week_num and week_num%3 or 0
        local temp = {1,2,3,1,2,3}
        local temp_week = {[1] = 1, [3] = 2, [5] = 3, [7] = 4}
        local ids = {}
        for i,v in ipairs(temp) do
            if (index + 1) <= i and (index + 5) >= i then
                table.insert(ids, v)
            end
        end
        local openid = serviceDay and serviceDay%3 or 1
        if #ids > 0 then
            local weekSlot = temp_week[weekDay]
            if weekSlot then
                openid = ids[weekSlot] or openid
            end
        end
        if openid and openid >0 then
            npcId = npcs[openid]
        end
    else
        npcs = zstring.split(dms.atos(scene, pve_scene.npcs), ",")
        npcId = npcs[npcIndex]
    end

    self._current_page_index = sceneIndex
    self._scene = scene
    self._scene_id = dms.atos(scene, pve_scene.id)
    self._npc_id = npcId
    self.currentSceneType = dms.atoi(scene, pve_scene.scene_type)

    _ED.user_formetion_status_copy = {}
    _ED.formetion_copy = {}
    table.merge(_ED.user_formetion_status_copy, _ED.user_formetion_status)
    table.merge(_ED.formetion_copy, _ED.formetion)


    self.activity_copy_formation_status_info_key = "activity_copy_formation_status_info_" .. self.currentSceneType
    self.activity_copy_formation_info_key = "activity_copy_formation_info_" .. self.currentSceneType

    -- cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_status_info_key), "")
    -- cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_info_key), "")

    if self.currentSceneType == 52 then
        for i, v in pairs(_ED.user_formetion_status) do
            _ED.user_formetion_status[i] = "0"
        end
        for i, v in pairs(_ED.formetion) do
            _ED.formetion[i] = "0"
        end
    end

    local activity_copy_formation_status_info = cc.UserDefault:getInstance():getStringForKey(getKey(self.activity_copy_formation_status_info_key), "")
    local activity_copy_formation_info = cc.UserDefault:getInstance():getStringForKey(getKey(self.activity_copy_formation_info_key), "")
    if nil == activity_copy_formation_status_info or "" == activity_copy_formation_status_info or nil == activity_copy_formation_info or "" == activity_copy_formation_info then
        cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
        cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_info_key), zstring.concat(_ED.formetion, ","))
    else
        _ED.user_formetion_status = zstring.split(activity_copy_formation_status_info, ",")
        _ED.formetion = zstring.split(activity_copy_formation_info, ",")
    end
    return self
end

function BattleReadyWindow:oneKeyFormationChange()
    state_machine.unlock("battle_ready_window_oen_key_formation_window")

    local nMaxCount = self:getFormationCount()
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
    if self.currentSceneType == 51 then
        local sameShipList = {}
        local noSameShipList = {}
        for i, ship in pairs(_ED.user_ship) do
            if ship.ship_id ~= nil then
                local isSame = false
                for j, w in pairs(self.listData) do
                    local moulds = dms.int(dms["environment_ship"], w, environment_ship.directing)
                    if moulds == tonumber(ship.ship_template_id) then
                        isSame = true
                    end
                end
                if isSame == true then
                    table.insert(sameShipList, ship) 
                else
                    table.insert(noSameShipList, ship)
                end
            end
        end
        table.sort(sameShipList, fightingCapacity)
        table.sort(noSameShipList, fightingCapacity)
        _ED.m_activity_battle_fight_type_51_list = ""
        local index = 0
        for i, v in pairs(sameShipList) do
            table.insert(fightShipList, v) 
            index = index + 1
            if index == 1 then
                _ED.m_activity_battle_fight_type_51_list = v.ship_template_id
            else
                _ED.m_activity_battle_fight_type_51_list = _ED.m_activity_battle_fight_type_51_list..","..v.ship_template_id
            end
        end
        for i, v in pairs(noSameShipList) do
            table.insert(fightShipList, v)
        end
    else
        if self.currentSceneType == 52 then
            for i, ship in pairs(_ED.user_ship) do
                if ship.ship_id ~= nil then
                    local camp_preference = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.camp_preference)
                    if 3 == camp_preference then
                        table.insert(fightShipList, ship) 
                    end
                end
            end
            table.sort(fightShipList, fightingCapacity)
        else
            for i, ship in pairs(_ED.user_ship) do
                if ship.ship_id ~= nil then
                    table.insert(fightShipList, ship) 
                end
            end
            table.sort(fightShipList, fightingCapacity)
            local function courageCapacity(a,b)
                local al = tonumber(a.ship_courage)
                local bl = tonumber(b.ship_courage)
                local result = false
                if al < bl then
                    result = true
                end
                return result 
            end
            
            local courageShipList = {}
            for i=1, 6 do
                table.insert(courageShipList, fightShipList[i]) 
            end
            table.sort(courageShipList, courageCapacity)
            fightShipList = courageShipList
        end
    end

    local str = ""
    for i = 1, 6 do
        _ED.formetion[i + 1] = 0
        _ED.user_formetion_status[i] = 0
        if i <= nMaxCount then
            local ship = fightShipList[i]
            local shipId = zstring.tonumber(_ED.formetion[i + 1])
            if nil ~= ship then
                if self.currentSceneType == 52 then
                    local camp_preference = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.camp_preference)
                    if 3 == camp_preference then
                        _ED.formetion[i + 1] = ship.ship_id
                        _ED.user_formetion_status[i] = ship.ship_id
                    end
                else
                    _ED.formetion[i + 1] = ship.ship_id
                    _ED.user_formetion_status[i] = ship.ship_id
                end
            end
        end
    end

    -- for j, v in pairs(_ED.user_formetion_status) do
    --     if j <= nMaxCount then
    --         local isHave = false
    --         for i = 1, 6 do
    --             if i <= nMaxCount then
    --                 local shipId = zstring.tonumber(_ED.formetion[i + 1])
    --                 if shipId > -1 then
    --                     if zstring.tonumber(v) == shipId then
    --                         isHave = true
    --                         break
    --                     end
    --                 end
    --             end
    --         end
    --         if false == isHave then
    --             _ED.user_formetion_status[j] = 0
    --             for i = 1, 6 do
    --                 if i <= nMaxCount then
    --                     local shipId = zstring.tonumber(_ED.formetion[i + 1])
    --                     if shipId > -1 then
    --                         for o, p in pairs(_ED.user_formetion_status) do
    --                             if zstring.tonumber(p) == shipId then
    --                                 isHave = true
    --                                 break
    --                             end
    --                         end
    --                         if false == isHave then
    --                             _ED.user_formetion_status[j] = shipId
    --                             break
    --                         end
    --                     end
    --                 end
    --             end
    --         end
    --     end
    -- end

    -- debug.print_r(_ED.user_formetion_status)
    -- debug.print_r(_ED.formetion)
    
    cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_info_key), zstring.concat(_ED.formetion, ","))

    self:onUpdateDrawFormation()

    -- local function responseChangeFormation(response)
    --     state_machine.unlock("battle_ready_window_oen_key_formation_window")
    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    --         if response.node.roots ~= nil then
    --             response.node:onUpdateDrawFormation()
    --         end
    --     end
    -- end

    -- protocol_command.formation_change.param_list = str
    -- NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, self, responseChangeFormation, false, nil)
end

function BattleReadyWindow:formationChange(params)
    cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_info_key), zstring.concat(_ED.formetion, ","))
end

function BattleReadyWindow:getFormationCount()
    local nMaxCount = 6
    -- local currentLevel = zstring.tonumber(_ED.user_info.user_grade)
    -- if dms.int(dms["fun_open_condition"], 28, fun_open_condition.level) <= currentLevel then
    --     nMaxCount = nMaxCount + 1
    -- end
    -- if dms.int(dms["fun_open_condition"], 29, fun_open_condition.level) <= currentLevel then
    --     nMaxCount = nMaxCount + 1
    -- end
    -- if dms.int(dms["fun_open_condition"], 30, fun_open_condition.level) <= currentLevel then
    --     nMaxCount = nMaxCount + 1
    -- end
    -- if dms.int(dms["fun_open_condition"], 31, fun_open_condition.level) <= currentLevel then
    --     nMaxCount = nMaxCount + 1
    -- end
    -- if dms.int(dms["fun_open_condition"], 32, fun_open_condition.level) <= currentLevel then
    --     nMaxCount = nMaxCount + 1
    -- end
    return nMaxCount
end

function BattleReadyWindow:joinFormtion(params)
    state_machine.excute("hero_formation_choice_wear_window_close", 0, 0)

    local nMaxCount = self:getFormationCount()

    local cell_index = params[1]
    local ship_id = params[2]

    local ship = _ED.user_ship["" .. ship_id]

    if self.currentSceneType == 52 then
        local camp_preference = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.camp_preference)
        if 3 ~= camp_preference then
            return
        end
    end

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
    
    cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey(self.activity_copy_formation_info_key), zstring.concat(_ED.formetion, ","))

    self:onUpdateDrawFormation()
end

function BattleReadyWindow:onDrawDefenderFormationListView(listView)
    local root = self.roots[1]
    --通过npc获取环境阵型,再通过环境阵型获得环境战船
    self.listData = {}
    for i=1, 3 do
        local formation = dms.int(dms["npc"], self._npc_id, npc.environment_formation1+i-1)
        if formation > 0 then
            for j=1, 3 do
                local seat =  dms.int(dms["environment_formation"], formation, environment_formation.seat_one+j-1)
                if seat > 0 then
                    table.insert(self.listData, seat)
                end
            end
        end
    end
    --通过环境战船画掉落的碎片头像
    for i,v in pairs(self.listData) do
        local moulds = dms.int(dms["environment_ship"], v, environment_ship.directing)
        local cell = HeroIconListCell:createCell()
        local ship = {}
        ship.ship_template_id = moulds
        ship.evolution_status = "2|2,2,2,0"
        ship.Order = 8
        ship.StarRating = 0
        ship.ship_grade = ""
        ship.ship_id = -1
        cell:init(ship, i,true)
        listView:addChild(cell)
    end
    listView:requestRefreshView()
end

function BattleReadyWindow:onDrawRewardListView(listView, rewardInfoString)
    local isHaveActivity = false
    if self.currentSceneType == 2 then
        if _ED.active_activity[99] ~= nil and _ED.active_activity[99] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 2 then
        if _ED.active_activity[131] ~= nil and _ED.active_activity[131] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 3 then
        if _ED.active_activity[133] ~= nil and _ED.active_activity[133] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 4 then
        if _ED.active_activity[132] ~= nil and _ED.active_activity[132] ~= "" then
            isHaveActivity = true
        end
    end
    local rewardInfoArr = zstring.split(rewardInfoString, "|")
    for i, v in pairs(rewardInfoArr) do
        local info = zstring.split(v, ",")
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{info[2],info[1],info[3]},false,false,false,true})
        listView:addChild(cell)
        if isHaveActivity == true then
            cell:setActivityDouble(true)
        end
        -- if info[2] == "1" then
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(1, tonumber(info[3]), -1)
        --     cell:hideCount(true)
        --     listView:addChild(cell)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- elseif info[2] == "2" then
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(2, tonumber(info[3]), -1)
        --     cell:hideCount(true)
        --     listView:addChild(cell)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- elseif info[2] == "6" then
        --     local cell = PropIconCell:createCell()
        --     local reawrdID = tonumber(info[1])
        --     local rewardNum = tonumber(info[3])
        --     cell:hideNameAndCount()
        --     cell:init(23, {user_prop_template = reawrdID, prop_number = rewardNum}, nil, false)
        --     listView:addChild(cell)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- elseif info[2] == "7" then
        --     local reawrdID = tonumber(info[1])
        --     local rewardNum = tonumber(info[3])
            
        --     local tmpTable = {
        --         user_equiment_template = reawrdID,
        --         mould_id = reawrdID,
        --         user_equiment_grade = 1
        --     }
            
        --     local cell = EquipIconCell:createCell()
        --     cell:hideNameAndCount()
        --     cell:init(10, tmpTable, reawrdID, nil, false)
        --     listView:addChild(cell)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- end
    end
end

function BattleReadyWindow:onHeadDraw()
    local roots = cacher.createUIRef("campaign/maoxian_batle_role_same.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)
    
    return roots
end

function BattleReadyWindow:onUpdateDrawFormation( ... )
    local root = self.roots[1]

    local nMaxCount = self:getFormationCount()

    local ListView_huodong_guaka_line = ccui.Helper:seekWidgetByName(root, "ListView_huodong_guaka_line")
    ListView_huodong_guaka_line:removeAllItems()

    local sameShip = nil
    if self.currentSceneType == 51 then
        -- if _ED.m_activity_battle_fight_type_51_list ~= nil and _ED.m_activity_battle_fight_type_51_list ~= "" then
        --     sameShip= zstring.split(_ED.m_activity_battle_fight_type_51_list, ",")
        --     _ED.m_activity_battle_fight_type_51_list = ""
        -- end
        local index = 1
        sameShip = {}
        for i=1,6 do
            local is_same = false
            local ship = _ED.user_ship["".._ED.user_formetion_status[i]]
            for j, w in pairs(self.listData) do
                local moulds = dms.int(dms["environment_ship"], w, environment_ship.directing)
                if ship ~= nil and moulds == tonumber(ship.ship_template_id) then
                    table.insert(sameShip, ship.ship_template_id)
                    break
                end
            end
        end
        _ED.m_activity_battle_fight_type_51_list = ""
    end
    for i= 1, 6 do
        local cell = HeroIconListCell:createCell()
        local ship = _ED.user_ship["".._ED.user_formetion_status[i]]
        if nil ~= ship then
            cell:init(ship, i, true, nil,nil,true)
            local Image_line_role = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_line_role")
            if nil ~= Image_line_role then
                Image_line_role:setVisible(false)
            end

            if cell:getChildByTag(1024) ~= nil then 
                cell:removeChildByTag(1024)
            end
            if self.currentSceneType == 51 then
                if sameShip ~= nil then
                    for j,w in pairs(sameShip) do
                        if tonumber(ship.ship_template_id) == tonumber(w) then
                            local sames = self:onHeadDraw()
                            sames:setTag(1024)
                            sames:setScale(0.5)
                            cell:addChild(sames)
                            sames:setPosition(cc.p(0,0))
                            local Panel_prop = ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_prop")
                            sames:setPosition(cc.p(sames:getPositionX()+Panel_prop:getContentSize().width/2,sames:getPositionY()+Panel_prop:getContentSize().height/2))
                            if _ED.m_activity_battle_fight_type_51_list == "" or _ED.m_activity_battle_fight_type_51_list == nil then
                                _ED.m_activity_battle_fight_type_51_list = w
                            else
                                _ED.m_activity_battle_fight_type_51_list = _ED.m_activity_battle_fight_type_51_list..","..w
                            end
                            break
                        end
                    end
                end
            end
        else
            cell:init(nil,i, true, nil,nil,true)
        end

        if i <= nMaxCount then
            -- 上阵
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
            {
                terminal_name = "battle_ready_window_open_join_formation_window",
                cell_index = i,
                isPressedActionEnabled = true
            },
            nil,0)
        end
        ccui.Helper:seekWidgetByName(cell.roots[1], "Text_equip_lv"):setString("")
        ListView_huodong_guaka_line:addChild(cell) 
    end
end

function BattleReadyWindow:onUpdateDraw( ... )
    local root = self.roots[1]

    -- 更新标题信息
    local Panel_huodong_guaka_title = ccui.Helper:seekWidgetByName(root, "Panel_huodong_guaka_title")
    Panel_huodong_guaka_title:removeBackGroundImage()
    Panel_huodong_guaka_title:setBackGroundImage("images/ui/play/huodng_tiaozhan_text_" .. self._current_page_index .. ".png")

    -- 更新背景信息
    local Panel_huodong_guaka_fun_pic = ccui.Helper:seekWidgetByName(root, "Panel_huodong_nandu_pic_bg")
    Panel_huodong_guaka_fun_pic:removeBackGroundImage()
    Panel_huodong_guaka_fun_pic:setBackGroundImage("images/ui/play/huodong_guanka_pic_bg_" .. self._current_page_index .. ".png")

    local ListView_huodong_guaka_enemy_icon = ccui.Helper:seekWidgetByName(root, "ListView_huodong_guaka_enemy_icon")
    ListView_huodong_guaka_enemy_icon:setVisible(false)
    -- 绘制敌方部队信息
    if self.currentSceneType == 51 then
        local Image_huodong_enemy = ccui.Helper:seekWidgetByName(root, "Image_huodong_enemy")
        Image_huodong_enemy:setVisible(true)
        ListView_huodong_guaka_enemy_icon:setVisible(true)
        ListView_huodong_guaka_enemy_icon:removeAllItems()
        self:onDrawDefenderFormationListView(ListView_huodong_guaka_enemy_icon)

        -- state_machine.excute("battle_ready_window_oen_key_formation_window", 0, 0)
    end

    -- 绘制副本奖励信息
    local ListView_huodong_guaka_drop_icon = ccui.Helper:seekWidgetByName(root, "ListView_huodong_guaka_drop_icon")
    ListView_huodong_guaka_drop_icon:removeAllItems()
    self:onDrawRewardListView(ListView_huodong_guaka_drop_icon, dms.string(dms["scene_reward_ex"], dms.string(dms["npc"], self._npc_id, npc.drop_library), scene_reward_ex.show_reward))

    -- 绘制阵容信息
    self:onUpdateDrawFormation()
end

function BattleReadyWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/huodong_guaka_fb_tiaozhan.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self.listData = {}
    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_daoju_back"), nil, 
    {
        terminal_name = "battle_ready_window_close",
        isPressedActionEnabled = true
    },
    nil,0)

    -- 一键布阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_line"), nil, 
    {
        terminal_name = "battle_ready_window_oen_key_formation_window", 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 开始战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_zd"), nil, 
    {
        terminal_name = "battle_ready_window_formation_change", 
        isPressedActionEnabled = true
    },
    nil,0)

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
        fwin:close(fwin:find("UserTopInfoAClass"))
        app.load("client.player.UserTopInfoA")
        fwin:open(UserTopInfoA:new(), fwin._view)
    end

    self:onUpdateDraw()
end

function BattleReadyWindow:onExit()
    cacher.freeRef("campaign/maoxian_batle_role_same.csb", self.roots[2])
    state_machine.remove("battle_ready_window_open_fun_window")
    state_machine.remove("battle_ready_window_oen_key_formation_window")
    state_machine.remove("battle_ready_window_formation_change_request")
    state_machine.remove("battle_ready_window_formation_change_back")
    state_machine.remove("battle_ready_window_formation_change")
    state_machine.remove("battle_ready_window_join_battle")
    state_machine.remove("battle_ready_window_open_join_formation_window")
    state_machine.remove("battle_ready_window_join_formation")
end

function BattleReadyWindow:destory(window)

end