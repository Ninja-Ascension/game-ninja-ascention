-----------------------------
--试炼扫荡标签信息
-----------------------------
SmTrialTowerSweepInfo = class("SmTrialTowerSweepInfoClass", Window)

local sm_trial_tower_sweep_info_window_open_terminal = {
    _name = "sm_trial_tower_sweep_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		fwin:open(SmTrialTowerSweepInfo:new():init(params))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_trial_tower_sweep_info_window_open_terminal)
state_machine.init()

function SmTrialTowerSweepInfo:ctor()
    self.super:ctor()
    self.roots = {}

    self._base_info = {}
    self._current_type = 0
    self._current_floor = 0
    self._choose_buff_state = {}
    self._buff_buy_number = 0
    self._old_buff_floor = 0

    local function init_sm_trial_tower_sweep_info_terminal()
        local sm_trial_tower_sweep_info_update_terminal = {
            _name = "sm_trial_tower_sweep_info_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_sweep_info_next_terminal = {
            _name = "sm_trial_tower_sweep_info_next",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._current_type == 3 then
                    function showConfirmTip(instance,n)
                        if n == 0 then
                            state_machine.excute("sm_trial_tower_sweep_window_close", 0, nil)
                        end
                    end
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    tip:init(instance, showConfirmTip, _new_interface_text[227])
                    fwin:open(tip, fwin._ui)
                elseif instance._current_type == 2 then
                    for i= instance._old_buff_floor+1, instance._current_floor do
                        if dms.string(dms["three_kingdoms_config"], i, three_kingdoms_config.npc_id) ~= "-1" then
                            for j, w in pairs(_ED.user_try_ship_infos) do
                                local percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                                --每次战斗胜利后加血和怒
                                if tonumber(_ED.user_ship[""..w.id].ship_grade) > 10 then
                                    if tonumber(w.newHp) > 0 then
                                        local addAll = zstring.split(dms.string(dms["play_config"], 52, play_config.param), ",")
                                        local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
                                        w.newHp = zstring.tonumber(w.newHp) + zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*(addAll[1]/100)
                                        if zstring.tonumber(w.newHp) > zstring.tonumber(_ED.user_ship[""..w.id].ship_health) then
                                            w.newHp = zstring.tonumber(_ED.user_ship[""..w.id].ship_health)
                                            percentage = 100
                                        else
                                            percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                                        end
                                        w.newanger = zstring.tonumber(w.newanger) + zstring.tonumber(fightParams[4])*(addAll[2]/100)
                                        if zstring.tonumber(w.newanger) > zstring.tonumber(fightParams[4]) then
                                            w.newanger = zstring.tonumber(fightParams[4])
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if instance._old_buff_floor ~= instance._current_floor then
                        instance._old_buff_floor = instance._current_floor
                    end

                    local buffData = zstring.split(dms.string(dms["three_kingdoms_config"], instance._current_floor, three_kingdoms_config.attribute_add_id), "|")
                    local buff_need = zstring.split(buffData[2],",")
                    local buff_info = zstring.split(buffData[1],",")
                    
                    for j,w in pairs(buff_info) do
                        local isOver = false
                        for i,v in pairs(instance._choose_buff_state) do
                            if tonumber(w) == tonumber(v.store_id) then
                                isOver = true
                            end
                        end
                        if isOver == false then
                            local store = {}
                            store.store_id = w
                            store.shipid = -1
                            store.id = -1
                            table.insert(instance._choose_buff_state, store)
                        end
                    end

                    local function responseGetServerListCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("sm_trial_tower_sweep_update", 0, nil)
                            state_machine.excute("sm_trial_tower_update_buff_info",0,"")
                        end
                    end

                    local buff_info = ""
                    table.sort(instance._choose_buff_state, function(c1, c2)
                        if c1 ~= nil 
                            and c2 ~= nil 
                            and zstring.tonumber(c1.store_id) < zstring.tonumber(c2.store_id) then
                            return true
                        end
                        return false
                    end)
                    local index = 0
                    for i,v in pairs(instance._choose_buff_state) do
                        if tonumber(v.id) > 0 then
                            local list = zstring.split( dms.string(dms["three_kingdoms_attribute"], v.id, three_kingdoms_attribute.attribute_value),",")
                            --战前处理的血量和怒气的加成
                            if tonumber(list[1]) == 4 or tonumber(list[1]) == 41 or tonumber(list[1]) == 999 then
                                if tonumber(list[1]) == 4 then
                                    --加血
                                    if tonumber(v.shipid) == -1 then
                                        for j,w in pairs(_ED.user_try_ship_infos) do
                                            --满血的就不管了
                                            if tonumber(w.maxHp) < 100 then
                                                --计算出加成后的血量百分比
                                                w.maxHp = tonumber(w.maxHp) + tonumber(list[2])
                                                if tonumber(w.maxHp) > 100 then
                                                    w.maxHp = 100
                                                end
                                                _ED.user_try_ship_infos[""..w.id].newHp = tonumber(_ED.user_ship[""..w.id].ship_health)*(tonumber(w.maxHp)/100)
                                            end
                                        end
                                    else
                                        _ED.user_try_ship_infos[""..v.shipid].maxHp = tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) + tonumber(list[2])
                                        if tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) > 100 then
                                            _ED.user_try_ship_infos[""..v.shipid].maxHp = 100
                                        end
                                        _ED.user_try_ship_infos[""..v.shipid].newHp = tonumber(_ED.user_ship[""..v.shipid].ship_health)*(tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp)/100)
                                    end
                                elseif tonumber(list[1]) == 41 then 
                                    --加怒
                                    local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
                                    if tonumber(v.shipid) == -1 then
                                        for j,w in pairs(_ED.user_try_ship_infos) do
                                            if tonumber(w.newanger) < tonumber(fightParams[4]) then
                                                w.newanger = tonumber(w.newanger) + tonumber(list[2])
                                                if tonumber(w.newanger) > tonumber(fightParams[4]) then
                                                    w.newanger = tonumber(fightParams[4])
                                                end 
                                                _ED.user_try_ship_infos[""..w.id].newanger = tonumber(w.newanger)
                                            end
                                        end
                                    else
                                        _ED.user_try_ship_infos[""..v.shipid].newanger = tonumber(_ED.user_try_ship_infos[""..v.shipid].newanger) + tonumber(list[2])
                                        if tonumber(_ED.user_try_ship_infos[""..v.shipid].newanger) > tonumber(fightParams[4]) then
                                            _ED.user_try_ship_infos[""..v.shipid].newanger = tonumber(fightParams[4])
                                        end
                                    end
                                elseif tonumber(list[1]) == 999 then
                                    --复活
                                    _ED.user_try_ship_infos[""..v.shipid].maxHp = tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp) + tonumber(list[2])
                                    _ED.user_try_ship_infos[""..v.shipid].newHp = tonumber(_ED.user_ship[""..v.shipid].ship_health)*(tonumber(_ED.user_try_ship_infos[""..v.shipid].maxHp)/100)
                                end
                            end
                        end
                        if tonumber(v.shipid) < 0 then
                            index = index + 1
                            if index == 1 then
                                buff_info = tonumber(v.id)..":"..tonumber(v.shipid)
                            else
                                buff_info = buff_info .."|"..tonumber(v.id)..":"..tonumber(v.shipid)
                            end
                        end
                    end

                    if instance._buff_buy_number == 0 then
                        local jumpFloor = dms.int(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade))
                        for i= instance._current_floor+1, jumpFloor do
                            if dms.string(dms["three_kingdoms_config"], i, three_kingdoms_config.npc_id) ~= "-1" then
                                for j, w in pairs(_ED.user_try_ship_infos) do
                                    local percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                                    --每次战斗胜利后加血和怒
                                    if tonumber(_ED.user_ship[""..w.id].ship_grade) > 10 then
                                        if tonumber(w.newHp) > 0 then
                                            local addAll = zstring.split(dms.string(dms["play_config"], 52, play_config.param), ",")
                                            local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
                                            w.newHp = zstring.tonumber(w.newHp) + zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*(addAll[1]/100)
                                            if zstring.tonumber(w.newHp) > zstring.tonumber(_ED.user_ship[""..w.id].ship_health) then
                                                w.newHp = zstring.tonumber(_ED.user_ship[""..w.id].ship_health)
                                                percentage = 100
                                            else
                                                percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                                            end
                                            w.newanger = zstring.tonumber(w.newanger) + zstring.tonumber(fightParams[4])*(addAll[2]/100)
                                            if zstring.tonumber(w.newanger) > zstring.tonumber(fightParams[4]) then
                                                w.newanger = zstring.tonumber(fightParams[4])
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    local strs = ""
                    for j, w in pairs(_ED.user_try_ship_infos) do
                        if strs ~= "" then
                            strs = strs.."|"..w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                        else
                            strs = w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                        end
                    end
                    local buffDatas = zstring.split(buff_info,"|")
                    buff_info = ""
                    for i , v in pairs(buffDatas) do
                        if i<= 3 then
                            if i == 1 then
                                buff_info = v
                            else
                                buff_info = buff_info .. "|" .. v
                            end 
                        end
                    end
                    protocol_command.three_kingdoms_sweep.param_list = "2\r\n".._ED.three_kingdoms_view.current_max_stars.."\r\n0\r\n"..instance._current_floor.."\r\n"..buff_info.."\r\n"..strs.."\r\n0"
                    NetworkManager:register(protocol_command.three_kingdoms_sweep.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                else
                    state_machine.excute("sm_trial_tower_sweep_update", 0, instance._current_type)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_sweep_info_choose_buff_terminal = {
            _name = "sm_trial_tower_sweep_info_choose_buff",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- _ED.three_kingdoms_view.current_max_stars = tonumber(_ED.three_kingdoms_view.current_max_stars) - tonumber(params[1])
                local selectdata = {}
                selectdata.store_id = dms.int(dms["three_kingdoms_attribute"], params[2], three_kingdoms_attribute.store_id)
                selectdata.id = params[2]
                selectdata.shipid = params[3]
                table.insert(instance._choose_buff_state, selectdata)
                instance:chooseBuff()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_sweep_info_open_all_terminal = {
            _name = "sm_trial_tower_sweep_info_open_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local times = {1,2,5,10}
                times = times[index]
                function showConfirmTip(instance, n)
                    if n == 0 then
                        local function responseUsePropCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local rewardList = getSceneReward(37)
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(nil, rewardList)
                                fwin:open(getRewardWnd, fwin._ui)
                                state_machine.excute("sm_trial_tower_sweep_info_update_reward_info", 0, nil)
                                state_machine.excute("sm_trial_tower_update_info", 0, nil)

                                if _ED.active_activity[134] ~= nil and _ED.active_activity[134] ~= "" then
                                    local rewardListView = ccui.Helper:seekWidgetByName(getRewardWnd.roots[1], "ListView_136")
                                    local _tables = rewardListView:getItems()
                                    for i, cell in pairs(_tables) do
                                        if 1 == tonumber(cell.item[1]) then
                                            if cell.setActivityDouble ~= nil then
                                                cell:setActivityDouble(true)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        protocol_command.three_kingdoms_sweep.param_list = "4\r\n0\r\n0\r\n0\r\n0\r\n\r\n"..times.."\r\n"
                        NetworkManager:register(protocol_command.three_kingdoms_sweep.code, nil, nil, nil, instance, responseUsePropCallback,false, nil)
                    end
                end
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(cell, showConfirmTip, string.format(_new_interface_text[300], self._totalCost[index]))
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_sweep_info_update_reward_info_terminal = {
            _name = "sm_trial_tower_sweep_info_update_reward_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateRewardInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_sweep_info_update_terminal)
        state_machine.add(sm_trial_tower_sweep_info_next_terminal)
        state_machine.add(sm_trial_tower_sweep_info_choose_buff_terminal)
        state_machine.add(sm_trial_tower_sweep_info_open_all_terminal)
        state_machine.add(sm_trial_tower_sweep_info_update_reward_info_terminal)
        state_machine.init()
    end
    init_sm_trial_tower_sweep_info_terminal()
end

function SmTrialTowerSweepInfo:chooseBuff(  )
    local root = self.roots[1]
    if self._current_type == 2 then
        local Text_star_n = ccui.Helper:seekWidgetByName(root, "Text_star_n")
        -- local Text_floor = ccui.Helper:seekWidgetByName(root, "Text_floor")
        -- local Text_floor_sy = ccui.Helper:seekWidgetByName(root, "Text_floor_sy")
        -- local Button_next = ccui.Helper:seekWidgetByName(root, "Button_next")
        -- local Sprite_next = Button_next:getChildByName("Sprite_next")
        -- local Sprite_next_floor = Button_next:getChildByName("Sprite_next_floor")
        Text_star_n:setString(_ED.three_kingdoms_view.current_max_stars)
        -- Sprite_next:setVisible(true)
        -- Sprite_next_floor:setVisible(false)
        -- Text_floor_sy:setString(_ED.three_kingdoms_view.current_max_stars)
    end
end

function SmTrialTowerSweepInfo:updateRewardInfo( ... )
    local jumpFloor = dms.string(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade))
    local root = self.roots[1]
    local Text_floor = ccui.Helper:seekWidgetByName(root, "Text_floor")
    local ListView_box = ccui.Helper:seekWidgetByName(root, "ListView_box")
    Text_floor:setString(jumpFloor)
    ListView_box:removeAllItems()
    local rewardInfo = zstring.split(_ED.three_kings_vip_sweep_reward_info, "|")
    local function sortFunc( a, b )
        local floorA = tonumber(zstring.split(a, ":")[1])
        local floorB = tonumber(zstring.split(b, ":")[1])
        return floorA < floorB
    end
    table.sort(rewardInfo, sortFunc)
    local costInfo = zstring.split(dms.string(dms["play_config"], 27, play_config.param), ",")
    local totalCost = {0,0,0,0}
    for k,v in pairs(self._base_info[2]) do
        v = rewardInfo[k]
        local onceCost = 0
        local info = zstring.split(v, ":")
        local buyTimes = tonumber(info[2])
        for i=1,10 do
            if buyTimes <= 0 then
                buyTimes = 1
            end
            local index = buyTimes - 1 + i
            if index > #costInfo then
                index = #costInfo
            end
            local cost = tonumber(costInfo[index])
            onceCost = onceCost + cost
            if i == 1 then
                totalCost[1] = totalCost[1] + onceCost
            elseif i == 2 then
                totalCost[2] = totalCost[2] + onceCost
            elseif i == 5 then
                totalCost[3] = totalCost[3] + onceCost
            elseif i == 10 then
                totalCost[4] = totalCost[4] + onceCost
            end
        end
        local cell = state_machine.excute("sm_trial_tower_sweep_list_cell_create", 0, {info[1], tonumber(info[2]) - 1})
        ListView_box:addChild(cell)
    end
    self._totalCost = totalCost
    for k,v in pairs(totalCost) do
        local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n_"..k)
        Text_zuanshi_n:setString(v)
    end
end

function SmTrialTowerSweepInfo:onUpdateDraw()
    local root = self.roots[1]
    local jumpFloor = dms.string(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade))
    if self._current_type == 1 then
        local Text_floor = ccui.Helper:seekWidgetByName(root, "Text_floor")
        Text_floor:setString(jumpFloor)
        local ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")
        ListView_reward:removeAllItems()
        local rewardInfo = getSceneReward(37)
        for k,v in pairs(rewardInfo.show_reward_list) do
            if tonumber(v.prop_type) == 1 and tonumber(v.item_value) > 0 then
                local cell = ResourcesIconCell:createCell()
                cell:init(v.prop_type, tonumber(v.item_value),-1,nil,nil,true,true)
                local quality = 3
                ListView_reward:addChild(cell)
                -- cell.roots[1]:setPositionX(cell.roots[1]:getPositionX() + (k -1) * 100)
                local name = _All_tip_string_info._fundName
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
                nameCell:setString(name)

                if _ED.active_activity[134] ~= nil and _ED.active_activity[134] ~= "" then
                    cell:setActivityDouble(true)
                end
            end
            if tonumber(v.prop_type) == 7 and tonumber(v.item_value) > 0 then
                local cell = ResourcesIconCell:createCell()
                cell:init(v.prop_type, tonumber(v.item_value), v.prop_item,nil,nil,true,true,nil,{equipQuality = 0})
                ListView_reward:addChild(cell)
                -- cell.roots[1]:setPositionX(cell.roots[1]:getPositionX() + (k -1) * 100)
                local nameindex = dms.int(dms["equipment_mould"], v.prop_item, equipment_mould.equipment_name)
                local word_info = dms.element(dms["word_mould"], nameindex)
                local name = word_info[3]
                local quality = dms.int(dms["equipment_mould"], v.prop_item, equipment_mould.trace_npc_index) + 1
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
                nameCell:setString(name)
            end
            if tonumber(v.prop_type) == 18 and tonumber(v.item_value) > 0 then
                local cell = ResourcesIconCell:createCell()
                cell:init(v.prop_type, tonumber(v.item_value),-1, nil, false, true, true)
                ListView_reward:addChild(cell)
                -- cell.roots[1]:setPositionX(cell.roots[1]:getPositionX() + (k -1) * 100)
                local quality = 3
                local name = _All_tip_string_info._glories
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
                nameCell:setString(name)
            end
            if tonumber(v.prop_type) == 6 and tonumber(v.item_value) > 0 then
                local propData = {tonumber(v.prop_type), tonumber(v.prop_item), tonumber(v.item_value)}
                local cell = DrawHandle.drawIcon(propData)
                ListView_reward:addChild(cell)

                local nameCell = cell:getName()

                local quality = getItemNameAndQuality(propData)[2]
                nameCell:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
                
                local name = getItemNameAndQuality(propData)[1]
                nameCell:setString(name)
            end
        end
        local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.TrialTowerBuyBuff)
        if fun_is_open == true then
            fwin:addService({
                callback = function ( params )
                    self:showClkAni()
                    fwin:addService({
                        callback = function ( params )
                            state_machine.excute("sm_trial_tower_sweep_info_next",0,
                            {
                                _datas = {
                                    terminal_state = 0, 
                                    touch_scale = true,
                                    touch_scale_xy = 0.95, 
                                    touch_black = true,
                                }
                            })
                        end,
                        delay = 0.5,
                        params = nil
                    })
                end,
                delay = 1,
                params = nil
            })
            self:setButtonEnable()
        end
    elseif self._current_type == 2 then
        local Text_star_n = ccui.Helper:seekWidgetByName(root, "Text_star_n")
        local Text_floor = ccui.Helper:seekWidgetByName(root, "Text_floor")
        local Text_floor_sy = ccui.Helper:seekWidgetByName(root, "Text_floor_sy")
        local Button_next = ccui.Helper:seekWidgetByName(root, "Button_next")
        local Sprite_next = Button_next:getChildByName("Sprite_next")
        local Sprite_next_floor = Button_next:getChildByName("Sprite_next_floor")
        local sweep_buff_info = zstring.split(_ED.three_kings_vip_sweep_buff_info, "|")
        local function sortFunc( a, b )
            local floorA = tonumber(zstring.split(a, ":")[1])
            local floorB = tonumber(zstring.split(b, ":")[1])
            return floorA < floorB
        end
        table.sort(sweep_buff_info, sortFunc)
        Sprite_next:setVisible(false)
        Sprite_next_floor:setVisible(false)
        local chooseFloor = 0
        self._current_floor = 0
        for k,v in pairs(self._base_info[1]) do
            v = sweep_buff_info[k]
            local info = zstring.split(v, ":")
            local floor = tonumber(info[1])
            info = zstring.split(info[2], ",")
            local isChooseed = false
            for k1,v1 in pairs(info) do
                if tonumber(v1) ~= 0 then
                    isChooseed = true
                    break
                end
            end
            chooseFloor = chooseFloor + 1
            self._current_floor = floor
            if isChooseed == false then
                break
            end
        end
        if chooseFloor == table.nums(self._base_info[1]) then
            Sprite_next:setVisible(true)
        else
            Sprite_next_floor:setVisible(true)
        end
        Text_floor:setString(table.nums(self._base_info[1]) - chooseFloor)
        self._buff_buy_number = table.nums(self._base_info[1]) - chooseFloor
        Text_star_n:setString(_ED.three_kingdoms_view.current_max_stars)
        Text_floor_sy:setString(string.format(_new_interface_text[228], self._current_floor))
        local buffData = zstring.split(dms.string(dms["three_kingdoms_config"], self._current_floor, three_kingdoms_config.attribute_add_id), "|")
        local buff_info = zstring.split(buffData[1],",")
        local buff_need = zstring.split(buffData[2],",")
        for i=1, 3 do
            local Panel_sxxz = ccui.Helper:seekWidgetByName(root, "Panel_sxxz_"..i)
            Panel_sxxz:removeAllChildren(true)
            local cell = state_machine.excute("sm_trial_tower_Addition_cell", 0, {buff_info[i],buff_need[i],i,2})
            Panel_sxxz:addChild(cell)
        end

        local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.TrialTowerBuyBuff)
        if fun_is_open == true then
            fwin:addService({
                callback = function ( params )
                    state_machine.excute("sm_trial_tower_sweep_info_next",0,
                    {
                        _datas = {
                            terminal_state = 0, 
                            touch_scale = true,
                            touch_scale_xy = 0.95, 
                            touch_black = true,
                        }
                    })
                end,
                delay = 0.3,
                params = nil
            })

            self:setButtonEnable()
        end
    elseif self._current_type == 3 then
        self:updateRewardInfo()
        _ED.smTrialTower_autoFlag = nil
    end
end

function SmTrialTowerSweepInfo:onEnterTransitionFinish()

end
function SmTrialTowerSweepInfo:showClkAni()
    local root = self.roots[1]
    local Panel_button_autolight = ccui.Helper:seekWidgetByName(root, "Panel_button_autolight")
    Panel_button_autolight:removeAllChildren(true)
    local jsonFile = "images/ui/effice/effect_nexticon/effect_nexticon.json"
    local atlasFile = "images/ui/effice/effect_nexticon/effect_nexticon.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
    animation:setPosition(cc.p(Panel_button_autolight:getContentSize().width/2,Panel_button_autolight:getContentSize().height/2))
    Panel_button_autolight:addChild(animation)
end

function SmTrialTowerSweepInfo:setButtonEnable()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Button_next"):setEnabled(false)
end

function SmTrialTowerSweepInfo:onInit( )
    local csbItem = csb.createNode(string.format("campaign/TrialTower/sm_trial_tower_rweep_tab_%d.csb", self._current_type))
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"), nil, 
    {
        terminal_name = "sm_trial_tower_sweep_info_next", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    if self._current_type == 3 then
        for i=1,4 do
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_open_"..i), nil, 
            {
                terminal_name = "sm_trial_tower_sweep_info_open_all", 
                terminal_state = 0, 
                touch_scale = true,
                touch_scale_xy = 0.95, 
                touch_black = true,
                index = i,
            }, nil, 1)
        end
    end

    self:onUpdateDraw()
end

function SmTrialTowerSweepInfo:init(params)
    self._rootWindows = params[1]
    self._base_info = params[2]
    local isRequest = params[3]
    if isRequest == true then
        self._current_type = 1
    else
        local sweep_buff_info = zstring.split(_ED.three_kings_vip_sweep_buff_info, "|")
        local function sortFunc( a, b )
            local floorA = tonumber(zstring.split(a, ":")[1])
            local floorB = tonumber(zstring.split(b, ":")[1])
            return floorA < floorB
        end
        table.sort(sweep_buff_info, sortFunc)
        local index = 0
        for k,v in pairs(self._base_info[1]) do
            v = sweep_buff_info[k]
            local info = zstring.split(v, ":")
            local floor = tonumber(info[1])
            info = zstring.split(info[2], ",")
            local isChooseed = false
            for k1,v1 in pairs(info) do
                if tonumber(v1) ~= 0 then
                    isChooseed = true
                    break
                end
            end
            if isChooseed == false then
                break
            end
            index = index + 1
        end
        if index == table.nums(self._base_info[1]) then
            self._current_type = 3
        else
            self._current_type = 2
        end
    end
	self:onInit()
    return self
end

function SmTrialTowerSweepInfo:onExit()
    state_machine.remove("sm_trial_tower_sweep_info_update")
    state_machine.remove("sm_trial_tower_sweep_info_next")
    state_machine.remove("sm_trial_tower_sweep_info_choose_buff")
    state_machine.remove("sm_trial_tower_sweep_info_open_all")
    state_machine.remove("sm_trial_tower_sweep_info_update_reward_info")
end
