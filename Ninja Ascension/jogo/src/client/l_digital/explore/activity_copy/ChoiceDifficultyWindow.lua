-- ----------------------------------------------------------------------------------------------------
-- 说明：数码冒险活动副本主界面
-------------------------------------------------------------------------------------------------------
ChoiceDifficultyWindow = class("ChoiceDifficultyWindowClass", Window)

local choice_difficulty_window_open_terminal = {
    _name = "choice_difficulty_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("choice_difficulty_window_close")
        if nil == fwin:find("ChoiceDifficultyWindowClass") then
            fwin:open(ChoiceDifficultyWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local choice_difficulty_window_close_terminal = {
    _name = "choice_difficulty_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ChoiceDifficultyWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(choice_difficulty_window_open_terminal)
state_machine.add(choice_difficulty_window_close_terminal)
state_machine.init()

function ChoiceDifficultyWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.needLvArray = {}
    self._current_page_index = 1
    self._have_times = 0

    -- Initialize explore window state machine.
    local function init_choice_difficulty_window_terminal()
        local choice_difficulty_window_open_fun_window_terminal = {
            _name = "choice_difficulty_window_open_fun_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cellIndex = params._datas.cell_index
                if 0 <= params._datas.open_state and tonumber(_ED.user_info.user_grade) >= instance.needLvArray[tonumber(cellIndex)] then
                    if instance._have_times == 0 then
                        TipDlg.drawTextDailog(_new_interface_text[178])
                        return
                    end
                    if instance.open_index + 1 < tonumber(cellIndex) then
                        TipDlg.drawTextDailog(string.format(_new_interface_text[132], instance.needLvArray[tonumber(cellIndex)]))
                        return
                    end
                    app.load("client.l_digital.explore.activity_copy.BattleReadyWindow")
                    state_machine.excute("battle_ready_window_open", 0, {instance._current_page_index, cellIndex, instance._current_scene})
                else
                    TipDlg.drawTextDailog(string.format(_new_interface_text[132], instance.needLvArray[tonumber(cellIndex)]))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local choice_difficulty_window_join_battle_terminal = {
            _name = "choice_difficulty_window_join_battle",
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

        local choice_difficulty_window_sweep_terminal = {
            _name = "choice_difficulty_window_sweep",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._have_times == 0 then
                    TipDlg.drawTextDailog(_new_interface_text[178])
                    return
                end
                -- El servidor rechaza el barrido durante el enfriamiento de 10
                -- minutos (error 596), pero el cliente solo miraba la cuenta
                -- atras al abrir la batalla normal (BattleReadyWindow.lua:15).
                -- Tiene que ir ANTES del lock: si no, el `return` deja el
                -- terminal bloqueado para siempre porque solo lo desbloquean
                -- las respuestas del servidor.
                if state_machine.excute("activity_copy_window_check_battle_cd", 0, 0) ~= true then
                    return
                end
                state_machine.lock("choice_difficulty_window_sweep")

                local cellIndex = params._datas.cell_index

                local sceneIndex = instance._current_page_index
                local npcIndex = cellIndex
                local scene = instance._current_scene
                local sceneType = dms.atos(scene, pve_scene.scene_type)

                local npcId = 0
                if tonumber(sceneType) == 51 then
                --     local scene_data = zstring.split(dms.atos(scene, pve_scene.npcs), ",")
                --     local npcs = zstring.split(scene_data[npcIndex], ":")
                --     local openid = tonumber(_ED.m_open_service_number)%3
                --     if openid <= 0 then
                --         openid = 1
                --     elseif openid >= 4 then
                --         openid = 3
                --     end

                --     npcId = npcs[openid]
                -- else
                --     local npcs = zstring.split(dms.atos(scene, pve_scene.npcs), ",")
                --     npcId = npcs[npcIndex]
                -- end
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


                _ED._current_scene_id = dms.atos(scene, pve_scene.id)
                _ED._scene_npc_id = npcId
                _ED._npc_difficulty_index = 1
                
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
                local function responseBattleStartCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if nil ~= response.node and nil ~= response.node.roots then
                            fwin:addService({
                                callback = function ( params )
                                    local function responseEnvironmentFightCallback( response )
                                        state_machine.unlock("choice_difficulty_window_sweep")
                                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                            if nil ~= response.node and nil ~= response.node.roots then
                                                -- 更新主界面信息
                                                state_machine.excute("activity_copy_window_on_update_draw", 0, 0)

                                                app.load("client.l_digital.explore.activity_copy.ActivityCopySweep")
                                                state_machine.excute("activity_copy_sweep_window_open", 0, {sceneIndex})
                                            end
                                        end
                                    end
                                    if tonumber(sceneType) == 51 then
                                        local ship_list = {}
                                        for i=1, 3 do
                                            local formation = dms.int(dms["npc"], _ED._scene_npc_id, npc.environment_formation1+i-1)

                                            if formation > 0 then
                                                for j=1, 3 do
                                                    local seat =  dms.int(dms["environment_formation"], formation, environment_formation.seat_one+j-1)
                                                    if seat > 0 then
                                                        local moulds = dms.int(dms["environment_ship"], seat, environment_ship.directing)
                                                        table.insert(ship_list, moulds)
                                                    end
                                                end
                                            end
                                        end

                                        local index = 0
                                        local shipInfos = "-1"
                                        for i, ship in pairs(_ED.user_ship) do
                                            if ship.ship_id ~= nil then
                                                local isSame = false
                                                for j, w in pairs(ship_list) do
                                                    if tonumber(w) == tonumber(ship.ship_template_id) then
                                                        isSame = true
                                                        break
                                                    end
                                                end
                                                if isSame == true then
                                                    index = index + 1
                                                    if index == 1 then
                                                        shipInfos = ship.ship_template_id
                                                    else
                                                        shipInfos = shipInfos..","..ship.ship_template_id
                                                    end
                                                end
                                            end
                                        end
                                        protocol_command.battle_result_verify.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".. 3 .."\r\n".. 1 .."\r\n".."1" .. "\r\n" .. shipInfos
                                    else
                                        local reward_prop = dms.string(dms["scene_reward_ex"], dms.string(dms["npc"], _ED._scene_npc_id, npc.drop_library), scene_reward_ex.reward_prop)
                                        local rewardPropId = zstring.split(reward_prop, ",")[1]
                                        local rewards = dms.searchs(dms["scene_reward_drop"], scene_reward_drop.library_group, rewardPropId)
                                        local result = ""
                                        if #rewards > 0 then
                                            local infos = zstring.split(rewards[1][scene_reward_drop.drop_group_data], "|")
                                            for k,v in pairs(infos) do
                                                local oneReward = zstring.split(v, ",")
                                                local countInfo = zstring.split(oneReward[3], "-")
                                                if k == 1 then
                                                    result = oneReward[2]..","..oneReward[1]..","..countInfo[1]
                                                else
                                                    result = result.."!"..oneReward[2]..","..oneReward[1]..","..countInfo[1]
                                                end
                                            end
                                        end
                                        protocol_command.battle_result_verify.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".. 3 .."\r\n".. 1 .."\r\n".."1" .. "\r\n" .. result or ""--_ED._activity_copy_drop_info_str
                                    end
                                    protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .."\r\n"..formationInfo
                                    NetworkManager:register(protocol_command.battle_result_verify.code, nil, nil, nil, instance, responseEnvironmentFightCallback, false, nil)
                                end,
                                params = response.node
                            })
                        end
                    else
                        state_machine.unlock("choice_difficulty_window_sweep")
                    end
                end

                
                protocol_command.battle_result_start.param_list = "".. sceneType .."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n0\r\n"..formationInfo
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, instance, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(choice_difficulty_window_open_fun_window_terminal)
        state_machine.add(choice_difficulty_window_join_battle_terminal)
        state_machine.add(choice_difficulty_window_sweep_terminal)
        state_machine.init()
    end

    -- call func init explore window state machine.
    init_choice_difficulty_window_terminal()
end

function ChoiceDifficultyWindow:init(params)
    self._current_page_index = params[1]
    self._current_scene = params[2]
    return self
end

function ChoiceDifficultyWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/huodong_guaka_fb_nandu.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_fb_nandu_close"), nil, 
    {
        terminal_name = "choice_difficulty_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)

    local ListView_nandu_list = ccui.Helper:seekWidgetByName(root, "ListView_nandu_list")
    local items = ListView_nandu_list:getChildren()
    local npcs = nil
    if dms.atoi(self._current_scene, pve_scene.scene_type) == 51 then
        npcs = {}
        local scene_data = zstring.split(dms.atos(self._current_scene, pve_scene.npcs), ",")
        for i=1, #scene_data do
            local npclist = zstring.split(scene_data[i], ":")
            npcs[i] = {}
            npcs[i] = npclist[1]
        end
    else
        npcs = zstring.split(dms.atos(self._current_scene, pve_scene.npcs), ",")
    end

    -- 剩余的挑战次数
    -- Great Shinobi Ryo/EXP attempts use the original daily limits (2 and 7).
    -- Keep server-provided remaining counts; use the configured limits only
    -- when this server has not supplied a value yet.
    if nil == _ED.activity_pve_times[347] then
        _ED.activity_pve_times[347] = dms.string(dms["play_config"], 2, play_config.param)
    end
    if nil == _ED.activity_pve_times[348] then
        _ED.activity_pve_times[348] = dms.string(dms["play_config"], 7, play_config.param)
    end
    if nil == _ED.activity_pve_times[349] then
        _ED.activity_pve_times[349] = dms.string(dms["play_config"], 14, play_config.param)
    end
    if nil == _ED.activity_pve_times[350] then
        _ED.activity_pve_times[350] = dms.string(dms["play_config"], 16, play_config.param)
    end

    local cnfCounts = {
        _ED.activity_pve_times[347],
        _ED.activity_pve_times[348],
        _ED.activity_pve_times[349],
        _ED.activity_pve_times[350],
    }
    local nfCount = cnfCounts[self._current_page_index] or "0"
    self._have_times = tonumber(nfCount)
    local addTimes = 0
    if self._current_page_index == 1 then
        if _ED.active_activity[101] ~= nil and _ED.active_activity[101] ~= "" then
            addTimes = tonumber(_ED.active_activity[101].activity_Info[1].activityInfo_need_day)
        end
    elseif self._current_page_index == 2 then -- 经验副本次数增加
        if _ED.active_activity[128] ~= nil and _ED.active_activity[128] ~= "" then
            addTimes = tonumber(_ED.active_activity[128].activity_Info[1].activityInfo_need_day)
        end
    elseif self._current_page_index == 3 then -- 幻像挑战副本次数增加
        if _ED.active_activity[130] ~= nil and _ED.active_activity[130] ~= "" then
            addTimes = tonumber(_ED.active_activity[130].activity_Info[1].activityInfo_need_day)
        end
    elseif self._current_page_index == 4 then -- 幻像挑战副本次数增加
        if _ED.active_activity[129] ~= nil and _ED.active_activity[129] ~= "" then
            addTimes = tonumber(_ED.active_activity[129].activity_Info[1].activityInfo_need_day)
        end
    end
    
    self.open_index = 0
    for i, v in pairs(items) do
        v.roots = {v}
        self.needLvArray[i] = dms.int(dms["npc"],tonumber(npcs[i]) ,npc.attack_level_limit)
        local openState = tonumber(_ED.npc_state[tonumber(npcs[i])])
        local Panel_nandu_pic_lock = ccui.Helper:seekWidgetByName(v, "Panel_nandu_pic_lock_" .. i)
        if openState >= 0 and tonumber(_ED.user_info.user_grade) >= self.needLvArray[i] then
            Panel_nandu_pic_lock:setBackGroundImage("images/ui/play/ndxz_pic_01.png") -- 字母d
        else
            Panel_nandu_pic_lock:setBackGroundImage("images/ui/play/ndxz_pic_03.png") -- 锁
        end
        if self.open_index + 1 < i then
            Panel_nandu_pic_lock:setBackGroundImage("images/ui/play/ndxz_pic_03.png") -- 锁
        end

        local Button_nandu_saodang= ccui.Helper:seekWidgetByName(v, "Button_nandu_saodang_" .. i)
        self.open_index = self.open_index + 1
        if openState < 3 then
            Button_nandu_saodang:setVisible(false)
        else
            fwin:addTouchEventListener(Button_nandu_saodang, nil, 
            {
                terminal_name = "choice_difficulty_window_sweep", 
                cell_index = i,
                isPressedActionEnabled = true
            },
            nil,0)
        end

        local Panel_nandu_list = ccui.Helper:seekWidgetByName(v, "Panel_nandu_list_" .. i)
        fwin:addTouchEventListener(Panel_nandu_list, nil, 
        {
            terminal_name = "choice_difficulty_window_open_fun_window", 
            cell_index = i,
            open_state = openState,
            isPressedActionEnabled = true
        },
        nil,0)
    end
end

function ChoiceDifficultyWindow:onExit()
    state_machine.remove("choice_difficulty_window_open_fun_window")
    state_machine.remove("choice_difficulty_window_join_battle")
    state_machine.remove("choice_difficulty_window_sweep")
end

function ChoiceDifficultyWindow:destory(window)

end
