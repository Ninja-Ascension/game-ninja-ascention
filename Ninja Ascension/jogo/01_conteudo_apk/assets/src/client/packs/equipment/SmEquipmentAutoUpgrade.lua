-- ------------------------------------------------------------------------------------------------------------
--  说明：装备一键进阶
-- ------------------------------------------------------------------------------------------------------------
SmEquipmentAutoUpgrade = class("SmEquipmentAutoUpgradeClass", Window)

local sm_equipment_auto_upgrade_window_open_terminal = {
    _name = "sm_equipment_auto_upgrade_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(171) == true then
            return
        end
        if fwin:find("SmEquipmentAutoUpgradeClass") == nil then
            fwin:open(SmEquipmentAutoUpgrade:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_equipment_auto_upgrade_window_close_terminal = {
    _name = "sm_equipment_auto_upgrade_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmEquipmentAutoUpgradeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_equipment_auto_upgrade_window_open_terminal)
state_machine.add(sm_equipment_auto_upgrade_window_close_terminal)
state_machine.init()

function SmEquipmentAutoUpgrade:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._choose_ship = nil
    self._choose_index = 0
    self._level_up_times = 0
    self._max_level_up_times = 0

    self._choose_max_times = {}
    self.totalEquip = {}
    self.totalExp = 0
    self._costInfo = {}
    self._chooseLevel = 0

    self._isCostSilverEnough = false
    self._isCostOtherEnough = false
    self._isCostPropsEnough = false

    local function init_sm_equipment_auto_upgrade_terminal()
        local sm_equipment_auto_upgrade_change_level_terminal = {
            _name = "sm_equipment_auto_upgrade_change_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw(tonumber(params._datas.updateCount))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_equipment_auto_upgrade_sure_terminal = {
            _name = "sm_equipment_auto_upgrade_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship_id = instance._choose_ship.ship_id
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        playEffect(formatMusicFile("effect", 9991))
                        TipDlg.drawTextDailog(_new_interface_text[220])
                        for i,v in pairs(_ED.user_ship) do
                            setShipPushData(v.ship_id, 7, -1)
                            setShipPushData(v.ship_id, 8, -1)
                        end
                        -- state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                        state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,nil)
                        -- state_machine.excute("hero_icon_listview_icon_push_updata",0,"")
                        state_machine.excute("sm_equipment_tab_up_product_update_draw", 0, nil)
                        if fwin:find("HeroDevelopClass") ~= nil then
                            -- state_machine.excute("hero_develop_page_strength_to_update_ship", 0, _ED.user_ship[""..ship_id])
                            -- state_machine.excute("sm_equipment_qianghua_update_ship", 0, _ED.user_ship[""..ship_id])
                            -- state_machine.excute("sm_equipment_qianghua_update_ship_info", 0, nil)
                            state_machine.excute("hero_develop_back_to_update_specific_equip",0,instance._choose_index)
                        else
                            for i, v in pairs(_ED.user_formetion_status) do
                                if tonumber(v) == tonumber(ship_id) then
                                    state_machine.excute("formation_set_ship", 0, _ED.user_ship[""..ship_id])
                                    break
                                end
                            end
                        end
                        state_machine.excute("sm_equipment_auto_upgrade_window_close", 0, nil)
                        smFightingChange()
                    end
                end

                if instance._isCostSilverEnough == false then
                    -- local fightWindow = HeroPatchInformationPageGetWay:new()
                    -- fightWindow:init(0,6)
                    -- fwin:open(fightWindow, fwin._windows)
                    TipDlg.drawTextDailog(_new_interface_text[28])
                    return
                end
                if instance._isCostPropsEnough == false and instance._isCostPropsNone == true then
                    TipDlg.drawTextDailog(_new_interface_text[27])
                    return
                end
                if instance._isCostOtherEnough == false then
                    if instance._choose_index == 5 then
                        TipDlg.drawTextDailog(_string_piece_info[353])
                        -- local fightWindow = HeroPatchInformationPageGetWay:new()
                        -- fightWindow:init(0,7)
                        -- fwin:open(fightWindow, fwin._windows)
                    elseif instance._choose_index == 6 then
                        TipDlg.drawTextDailog(_new_interface_text[246])
                        -- local fightWindow = HeroPatchInformationPageGetWay:new()
                        -- fightWindow:init(0,8)
                        -- fwin:open(fightWindow, fwin._windows)
                    end
                    return
                end
                if instance._level_up_times == 0 then
                    TipDlg.drawTextDailog(_new_interface_text[240])
                    return
                end
                if instance._choose_index >= 5 then
                    local str = ""
                    for k,v in pairs(instance._costInfo) do
                        if str == "" then
                            str = v.user_equiment_id
                        else
                            str = str..","..v.user_equiment_id
                        end
                    end
                    protocol_command.treasure_onekey_escalate.param_list = instance._choose_ship.ship_id.."\r\n"..str.."\r\n"..instance._choose_index.."\r\n"..instance._chooseLevel
                    NetworkManager:register(protocol_command.treasure_onekey_escalate.code, nil, nil, nil, instance, responseCallback, false)
                else
                    local maxLevel = instance._choose_max_times[instance._level_up_times]
                    protocol_command.equipment_escalate.param_list = instance._choose_ship.ship_id.."\r\n0\r\n"..instance._choose_index.."\r\n1\r\n"..maxLevel
                    NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, instance, responseCallback, false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_equipment_auto_upgrade_change_level_terminal)
        state_machine.add(sm_equipment_auto_upgrade_sure_terminal)
        state_machine.init()
    end
    
    init_sm_equipment_auto_upgrade_terminal()
end

function SmEquipmentAutoUpgrade:getGiveExp( index )
    self.totalExp = 0
    self.totalEquip = {}
    local function fightingCapacity(a,b)
        local al = tonumber(a.user_equiment_template)
        local bl = tonumber(b.user_equiment_template)
        local result = false
        if al < bl then
            result = true
        end
        return result 
    end

    if tonumber(index) == 5 then
         for i, equip in pairs(_ED.user_equiment) do
            if tonumber(equip.equipment_type) == 4 then
                local giveExp = dms.int(dms["equipment_mould"], tonumber(equip.user_equiment_template), equipment_mould.initial_supply_escalate_exp)
                equip.giveExp = giveExp
                if giveExp > 0 then
                    self.totalExp = self.totalExp + giveExp
                    table.insert(self.totalEquip, equip)
                end
            end
        end
    elseif tonumber(index) == 6 then
        for i, equip in pairs(_ED.user_equiment) do
            if tonumber(equip.equipment_type) == 5 then
                local giveExp = dms.int(dms["equipment_mould"], tonumber(equip.user_equiment_template), equipment_mould.initial_supply_escalate_exp)
                equip.giveExp = giveExp
                if giveExp > 0 then
                    self.totalExp = self.totalExp + giveExp
                    table.insert(self.totalEquip, equip)
                end
            end
        end
    end
    table.sort(self.totalEquip, fightingCapacity)
    if #self.totalEquip == 0 then
        self._isCostPropsNone = true
    end
end

function SmEquipmentAutoUpgrade:onUpdateDraw(changeTimes)
    local root = self.roots[1]
    if changeTimes == 0 then
        self._max_level_up_times = 0
        self._level_up_times = 0
    else
        self._level_up_times = self._level_up_times + changeTimes
    end

    self._isCostSilverEnough = true
    self._isCostOtherEnough = true
    self._isCostPropsEnough = true
    self._isCostPropsNone = false

    local Text_qhzb_pz = ccui.Helper:seekWidgetByName(root, "Text_qhzb_pz")
    local Text_qhzb_jinbi_0 = ccui.Helper:seekWidgetByName(root, "Text_qhzb_jinbi_0")

    local costSilver = 0
    local costOther = 0
    local costProps = {}
    local choose_upgrade_list = {}
    local shipEquip = zstring.split(self._choose_ship.equipInfo, "|")
    local groupId = zstring.split(dms.string(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.max_rank_level), ",")[tonumber(self._choose_index)]
    local levels = zstring.split(shipEquip[1], ",")
    local picAll = zstring.split(shipEquip[2], ",")
    local expAll = zstring.split(shipEquip[3], ",")
    local oldExp = expAll[tonumber(self._choose_index)]
    local times = 0
    if self._choose_index >= 5 then
        if self.totalExp == 0 then
            self:getGiveExp(self._choose_index)
        end
        local library_group = dms.string(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.max_rank_level)
        local groupdatas = zstring.split(library_group, ",")
        library_group = tonumber(groupdatas[tonumber(self._choose_index)])
        local baseEquipmentRankInfo = _ED.baseEquipmentRankLinkInfo[""..library_group]
        local gold_factor = dms.int(dms["equipment_config"], 6, equipment_config.param)
        local totalNeedExp = 0
        local currentRankNeedExp = 0

        local maxLv = 0
        for k, v in pairs(baseEquipmentRankInfo) do
            if tonumber(k) > maxLv then
                maxLv = tonumber(k)
            end
        end
        for m=tonumber(levels[self._choose_index]), table.getn(dms["equipment_refining_experience_param"]) do
            if maxLv < m then
                break
            end
            local isAllEnough = true
            local needExp = dms.int(dms["equipment_refining_experience_param"], m, equipment_refining_experience_param.needs_experience_white)
            totalNeedExp = totalNeedExp + needExp
            currentRankNeedExp = currentRankNeedExp + needExp
            if m == tonumber(levels[self._choose_index]) then
                totalNeedExp = totalNeedExp - oldExp
                currentRankNeedExp = currentRankNeedExp - oldExp
            end
            local equipmentRankInfo = baseEquipmentRankInfo[""..m]
            if equipmentRankInfo ~= nil and m ~= tonumber(levels[self._choose_index]) then
                if totalNeedExp > self.totalExp 
                    or gold_factor * currentRankNeedExp + costSilver > tonumber(_ED.user_info.user_silver)
                    then
                    if #choose_upgrade_list > 0 then
                        local beginCount = choose_upgrade_list[#choose_upgrade_list]
                        for i=beginCount, m do
                            local needExp = dms.int(dms["equipment_refining_experience_param"], i, equipment_refining_experience_param.needs_experience_white)
                            if beginCount == i then
                                if i == tonumber(levels[self._choose_index]) then
                                    totalNeedExp = totalNeedExp + oldExp
                                    costSilver = costSilver + gold_factor * oldExp
                                else
                                    local lessRankInfo = baseEquipmentRankInfo[""..beginCount]
                                    costSilver = costSilver - tonumber(lessRankInfo.need_silver)
                                    costOther = costOther - tonumber(zstring.split(lessRankInfo.need_material, ",")[3])
                                end
                            else
                                totalNeedExp = totalNeedExp - needExp
                            end
                            -- costSilver = costSilver - gold_factor * needExp
                        end
                        break
                    end
                    if totalNeedExp > self.totalExp then
                        self._isCostPropsEnough = false
                    end
                    if gold_factor * currentRankNeedExp + costSilver > tonumber(_ED.user_info.user_silver) then
                        self._isCostSilverEnough = false
                    end
                    isAllEnough = false
                end

                -- costSilver = gold_factor * currentRankNeedExp + costSilver
                table.insert(choose_upgrade_list, m)
                times = times + 1
                if changeTimes == 0 then
                    self._level_up_times = self._level_up_times + 1
                    self._max_level_up_times = self._max_level_up_times + 1
                    table.insert(self._choose_max_times, m)
                    if maxLv == m then
                        break
                    end
                elseif changeTimes == -1 then
                    if times == self._level_up_times then
                        break
                    end
                elseif changeTimes == 1 then
                    if times == self._level_up_times then
                        break
                    end
                end
                if isAllEnough == false
                    or (tonumber(equipmentRankInfo.need_user_lv) > 0
                    and tonumber(equipmentRankInfo.need_user_lv) > tonumber(_ED.user_info.user_grade))
                    or costSilver + tonumber(equipmentRankInfo.need_silver) > tonumber(_ED.user_info.user_silver)
                    or (self._choose_index == 5
                    and costOther + tonumber(zstring.split(equipmentRankInfo.need_material, ",")[3]) > tonumber(_ED.user_info.user_honour))
                    or (self._choose_index == 6
                    and costOther + tonumber(zstring.split(equipmentRankInfo.need_material, ",")[3]) > tonumber(_ED.user_info.all_glories))
                    then
                    break
                else
                    costSilver = costSilver + tonumber(equipmentRankInfo.need_silver)
                    costOther = costOther + tonumber(zstring.split(equipmentRankInfo.need_material, ",")[3])
                    currentRankNeedExp = 0
                end
                
            end
        end
        self._costInfo = {}
        if self._isCostPropsEnough == false or self._isCostSilverEnough == false then
            -- 即使材料不足，也显示所有材料
            for k, v in pairs(self.totalEquip) do
                costProps[""..v.user_equiment_template] = zstring.tonumber(costProps[""..v.user_equiment_template]) + 1
                table.insert(self._costInfo, v)
            end

            local maxLv = choose_upgrade_list[1]
            if maxLv then
                local copyEXp = self.totalExp + oldExp
                local m_upLevels = tonumber(levels[self._choose_index])

                for m = m_upLevels, maxLv do
                    local needExp = dms.int(dms["equipment_refining_experience_param"], m, equipment_refining_experience_param.needs_experience_white)
                    if copyEXp > needExp then
                        m_upLevels = m_upLevels + 1
                        copyEXp = copyEXp - needExp
                    end
                end
                
                Text_qhzb_pz:setString(m_upLevels)

                self._chooseLevel = m_upLevels
            end

            -- 如果材料不足时的金币消耗计算
            local silver = gold_factor * self.totalExp
            Text_qhzb_jinbi_0:setString(silver)
            if tonumber(_ED.user_info.user_silver) >= tonumber(silver) then
                Text_qhzb_jinbi_0:setColor(cc.c3b(_quality_color[1][1], _quality_color[1][2], _quality_color[1][3]))
            else
                self._isCostSilverEnough = false
                Text_qhzb_jinbi_0:setColor(cc.c3b(_quality_color[6][1], _quality_color[6][2], _quality_color[6][3]))
            end

        else
            local useExp = 0
            for k,v in pairs(self.totalEquip) do
                useExp = useExp + zstring.tonumber(v.giveExp)
                costProps[""..v.user_equiment_template] = zstring.tonumber(costProps[""..v.user_equiment_template]) + 1
                table.insert(self._costInfo, v)
                if useExp >= totalNeedExp then
                    break
                end
            end
            costSilver = costSilver + useExp * gold_factor
            if costSilver <= 0 then
                costSilver = 0
            end
            if costSilver > tonumber(_ED.user_info.user_silver) 
                and #choose_upgrade_list > 1
                then
                local lastMaxCount = zstring.tonumber(choose_upgrade_list[#choose_upgrade_list])
                local beginCount = tonumber(levels[self._choose_index])
                if #choose_upgrade_list > 1 then
                    beginCount = choose_upgrade_list[#choose_upgrade_list - 1]
                end
                for i=beginCount, lastMaxCount do
                    local needExp = dms.int(dms["equipment_refining_experience_param"], i, equipment_refining_experience_param.needs_experience_white)
                    if i == beginCount then
                        if i == tonumber(levels[self._choose_index]) then
                            costSilver = costSilver + gold_factor * oldExp
                        else
                            local lessRankInfo = baseEquipmentRankInfo[""..lastMaxCount]
                            costSilver = costSilver - tonumber(lessRankInfo.need_silver)
                            costOther = costOther - tonumber(zstring.split(lessRankInfo.need_material, ",")[3])
                        end
                    end
                    costSilver = costSilver - gold_factor * needExp
                end
                self._level_up_times = self._level_up_times - 1
                self._max_level_up_times = self._max_level_up_times - 1
            end
        end
    else
        local equipment_level_param_info = dms.searchs(dms["equipment_level_param"], equipment_level_param.library_group, groupId)
        local function backToBeforLevel( lastMaxCount )
            local beginCount = tonumber(levels[self._choose_index])
            if #choose_upgrade_list > 0 then
                beginCount = choose_upgrade_list[#choose_upgrade_list]
            end
            for i=beginCount, lastMaxCount do
                if i == beginCount and i ~= tonumber(levels[self._choose_index]) then
                    local up_product_gold = dms.atoi(equipment_level_param_info[i], equipment_level_param.up_product_gold)
                    costSilver = costSilver - up_product_gold
                    local lessProps = {}
                    for j=1, 4 do
                        local propMould = dms.atoi(equipment_level_param_info[i], equipment_level_param.demand_prop_1 + (j - 1) * 2)
                        if propMould > 0 then
                            local propNumber = dms.atoi(equipment_level_param_info[i], equipment_level_param.demand_number_1 + (j - 1) * 2)
                            lessProps[""..propMould] = zstring.tonumber(lessProps[""..propMould]) + propNumber
                        end
                    end
                    for k,v in pairs(lessProps) do
                        costProps[""..k] = zstring.tonumber(costProps[""..k]) - v
                    end
                end
                local need_silver = dms.atoi(equipment_level_param_info[i], equipment_level_param.up_lv_gold)
                costSilver = costSilver - need_silver
            end
        end
        local maxLev = dms.atoi(equipment_level_param_info[table.getn(equipment_level_param_info)], equipment_level_param.equip_level)
        for m=tonumber(levels[self._choose_index]), table.getn(equipment_level_param_info) do
            local need_silver = dms.atoi(equipment_level_param_info[m], equipment_level_param.up_lv_gold)
            local up_product_gold = dms.atoi(equipment_level_param_info[m], equipment_level_param.up_product_gold)
            local is_up_product = dms.atoi(equipment_level_param_info[m], equipment_level_param.is_up_product)
            local need_user_lv = dms.atos(equipment_level_param_info[m], equipment_level_param.need_user_lv)
            local cur_lv = dms.atoi(equipment_level_param_info[m], equipment_level_param.equip_level)
            if need_user_lv ~= "-1" then
                need_user_lv = zstring.split(need_user_lv, ",")[self._choose_index]
            end
            local isAllEnough = true
            costSilver = costSilver + need_silver
            if is_up_product == 1 and m ~= tonumber(levels[self._choose_index]) then
                if costSilver > tonumber(_ED.user_info.user_silver) then
                    if #choose_upgrade_list > 0 then
                        backToBeforLevel(m)
                        break
                    end
                    isAllEnough = false
                end
                local addProps = {}
                if costSilver + up_product_gold > tonumber(_ED.user_info.user_silver) 
                    or tonumber(need_user_lv) > tonumber(_ED.user_info.user_grade)
                    then
                    isAllEnough = false
                else
                    for i=1, 4 do
                        local propMould = dms.atoi(equipment_level_param_info[m], equipment_level_param.demand_prop_1 + (i - 1) * 2)
                        if propMould > 0 then
                            local propNumber = dms.atoi(equipment_level_param_info[m], equipment_level_param.demand_number_1 + (i - 1) * 2)
                            local existNumber = tonumber(getPropAllCountByMouldId(propMould))
                            local useCount = zstring.tonumber(costProps[""..propMould]) + propNumber
                            if existNumber >= useCount then
                                addProps[""..propMould] = zstring.tonumber(addProps[""..propMould]) + propNumber
                            else
                                isAllEnough = false
                                break
                            end
                        end
                    end
                end
                if isAllEnough == true then
                    table.insert(choose_upgrade_list, m)
                    times = times + 1
                    if changeTimes == 0 then
                        self._level_up_times = self._level_up_times + 1
                        self._max_level_up_times = self._max_level_up_times + 1
                        table.insert(self._choose_max_times, m)
                        if cur_lv == maxLev then 
                            break
                        end
                    elseif changeTimes == -1 then
                        if times == self._level_up_times then
                            break
                        end
                    elseif changeTimes == 1 then
                        if times == self._level_up_times then
                            break
                        end
                    end
                    costSilver = costSilver + up_product_gold
                    for k,v in pairs(addProps) do
                        costProps[""..k] = zstring.tonumber(costProps[""..k]) + v
                    end
                else
                    if changeTimes == 0 then
                        self._level_up_times = self._level_up_times + 1
                        self._max_level_up_times = self._max_level_up_times + 1
                        table.insert(self._choose_max_times, m)
                    end
                    table.insert(choose_upgrade_list, m)
                    times = times + 1
                    break
                end
            end
        end
    end

    local root = self.roots[1]
    local ScrollView_cailiao = ccui.Helper:seekWidgetByName(root, "ScrollView_cailiao")
    ScrollView_cailiao:removeAllChildren(true)
    local panel = ScrollView_cailiao:getInnerContainer()
    panel:setContentSize(ScrollView_cailiao:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local tHeight = 0
    local tWidth = 0
    local wPosition = sSize.width/5
    local Hlindex = 0
    local m_number = math.ceil(table.nums(costProps)/5)
    local cellHeight = 0
    local cellWidth = 0
    local index = 0
    cellHeight = m_number*(ScrollView_cailiao:getContentSize().width/5)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(ScrollView_cailiao:getContentSize().width, sHeight)
    for k,v in pairs(costProps) do
        if zstring.tonumber(v) > 0 then
            local cell = nil
            if self._choose_index >= 5 then
                cell = EquipIconCell:createCell()
                cell:init(16, fundEquipWidthId(k))
                cell:showCountInfo(v)
            else
                cell = PropIconNewCell:createCell()
                cell:init(cell.enum_type._SHOW_PROP_GETWAY_INFORMATION, k)
                cell:onInit()
                cell:updateIconCountInfo(v)
            end
            index = index + 1
            panel:addChild(cell)
            tWidth = tWidth + wPosition
            if (index - 1)%5 == 0 then
                Hlindex = Hlindex + 1
                tWidth = 0
                tHeight = sHeight - wPosition * Hlindex
            end
            if index <= 5 then
                tHeight = sHeight - wPosition
            end
            cell:setPosition(cc.p(tWidth, tHeight))
        end
    end
    ScrollView_cailiao:jumpToTop()

    
    local Panel_qhzb_xh_icon = ccui.Helper:seekWidgetByName(root, "Panel_qhzb_xh_icon")
    local Text_qhzb_xh = ccui.Helper:seekWidgetByName(root, "Text_qhzb_xh")
    
    local Text_qhzb_2 = ccui.Helper:seekWidgetByName(root, "Text_qhzb_2")
    local Text_qhzb_3 = ccui.Helper:seekWidgetByName(root, "Text_qhzb_3")

    if index > 0 then
        Text_qhzb_3:setVisible(false)
    else
        Text_qhzb_3:setVisible(true)
    end

    Panel_qhzb_xh_icon:removeBackGroundImage()
    Text_qhzb_xh:setString("")
    Text_qhzb_xh:setVisible(true)
    if self._isCostPropsEnough == true then
        Text_qhzb_pz:setString(choose_upgrade_list[self._level_up_times])

        Text_qhzb_jinbi_0:setString(costSilver)
        if tonumber(_ED.user_info.user_silver) >= tonumber(costSilver) then
            Text_qhzb_jinbi_0:setColor(cc.c3b(_quality_color[1][1], _quality_color[1][2], _quality_color[1][3]))
        else
            self._isCostSilverEnough = false
            Text_qhzb_jinbi_0:setColor(cc.c3b(_quality_color[6][1], _quality_color[6][2], _quality_color[6][3]))
        end

        self._chooseLevel = choose_upgrade_list[self._level_up_times]
    end

    if self._choose_index == 5 then
        if zstring.tonumber(_ED.user_info.user_honour) >= tonumber(costOther) then
            Text_qhzb_xh:setColor(cc.c3b(_quality_color[1][1], _quality_color[1][2], _quality_color[1][3]))
        else
            self._isCostOtherEnough = false
            Text_qhzb_xh:setColor(cc.c3b(_quality_color[6][1], _quality_color[6][2], _quality_color[6][3]))
        end
        Text_qhzb_xh:setString(costOther)
        Panel_qhzb_xh_icon:setBackGroundImage("images/ui/icon/qh_pic_jjb.png")
    elseif self._choose_index == 6 then
        if zstring.tonumber(_ED.user_info.all_glories) >= tonumber(costOther) then
            Text_qhzb_xh:setColor(cc.c3b(_quality_color[1][1], _quality_color[1][2], _quality_color[1][3]))
        else
            self._isCostOtherEnough = false
            Text_qhzb_xh:setColor(cc.c3b(_quality_color[6][1], _quality_color[6][2], _quality_color[6][3]))
        end
        Text_qhzb_xh:setString(costOther)
        Panel_qhzb_xh_icon:setBackGroundImage("images/ui/icon/slb.png")

    end

    -- 如果消耗数量为0，则不显示
    if tonumber(costOther) == 0 then
        Text_qhzb_xh:setVisible(false)
        Panel_qhzb_xh_icon:setVisible(false)
    else
        Text_qhzb_xh:setVisible(true)
        Panel_qhzb_xh_icon:setVisible(true)
    end

    -- 如果没有材料时才显示“材料不足”
    if self._isCostPropsEnough == false then
        if self._isCostPropsNone == true then
            Text_qhzb_2:setString(_new_interface_text[27])
        end
    else
        Text_qhzb_2:setString("")
        Text_qhzb_2:removeAllChildren(true)
        local quality = shipOrEquipSetColour(tonumber(picAll[tonumber(self._choose_index)] + self._level_up_times - 1))
        local levelIndex = getShipNameOrder(tonumber(picAll[tonumber(self._choose_index)] + self._level_up_times - 1))

        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        _richText2:setContentSize(cc.size(440, Text_qhzb_2:getContentSize().height))
        _richText2:setAnchorPoint(cc.p(0, 0.5))
        local char_str = _new_interface_text[239].."%|"..(quality - 1).."|".._ship_types_by_color[quality].." +"..levelIndex.."%"
        if levelIndex == 0 then
            char_str = _new_interface_text[239].."%|"..(quality - 1).."|".._ship_types_by_color[quality].."%"
        end
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            Text_qhzb_2:getFontName(),
            18,
            chat_rich_text_color)
        if _ED.is_can_use_formatTextExt == false then
        else
            _richText2:formatTextExt()
        end
        local rsize = _richText2:getContentSize()
        _richText2:setPositionX(-140)
        _richText2:setPositionY(24)
        Text_qhzb_2:addChild(_richText2)
    end

    self:updateUIInfo()
end

function SmEquipmentAutoUpgrade:updateUIInfo()
    local root = self.roots[1]
    local Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")
    local Button_reduce = ccui.Helper:seekWidgetByName(root, "Button_reduce")
    Button_add:setTouchEnabled(true)
    Button_add:setHighlighted(true)
    Button_add:setBright(true)
    Button_reduce:setTouchEnabled(true)
    Button_reduce:setHighlighted(true)
    Button_reduce:setBright(true)
    if self._level_up_times == self._max_level_up_times then
        Button_add:setTouchEnabled(false)
        Button_add:setHighlighted(false)
        Button_add:setBright(false)
    end
    if self._level_up_times <= 1 then
        Button_reduce:setTouchEnabled(false)
        Button_reduce:setHighlighted(false)
        Button_reduce:setBright(false)
    end
end

function SmEquipmentAutoUpgrade:updateEquipInfo( ... )
    local root = self.roots[1]
    local Text_qhzb_name = ccui.Helper:seekWidgetByName(root, "Text_qhzb_name")
    local Panel_qhzb_icon = ccui.Helper:seekWidgetByName(root, "Panel_qhzb_icon")
    Panel_qhzb_icon:removeAllChildren(true)
    Text_qhzb_name:setString("")
    local cell = EquipIconCell:createCell()
    cell:init(16, self._choose_equip)
    Panel_qhzb_icon:addChild(cell)

    local nameindex = dms.int(dms["equipment_mould"], self._choose_equip.user_equiment_template, equipment_mould.equipment_name)
    local word_info = dms.element(dms["word_mould"], nameindex)
    local name = word_info[3]

    local shipEquip = zstring.split(self._choose_ship.equipInfo, "|")
    local newGrade = zstring.split(shipEquip[2], ",")
    if getShipNameOrder(tonumber(newGrade[tonumber(self._choose_index)])) > 0 then
        name = name.."+"..getShipNameOrder(tonumber(newGrade[tonumber(self._choose_index)]))
    end
    Text_qhzb_name:setString(name)
    local quality = shipOrEquipSetColour(tonumber(newGrade[tonumber(self._choose_index)]))
    Text_qhzb_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1], tipStringInfo_quality_color_Type[quality][2], tipStringInfo_quality_color_Type[quality][3]))
end

function SmEquipmentAutoUpgrade:onInit()
    local csbItem = csb.createNode("packs/EquipStorage/sm_equipment_qianghua_tab_1_window.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Cancel"), nil, 
    {
        terminal_name = "sm_equipment_auto_upgrade_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "sm_equipment_auto_upgrade_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "sm_equipment_auto_upgrade_change_level", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateCount = 1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduce"), nil, 
    {
        terminal_name = "sm_equipment_auto_upgrade_change_level", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateCount = -1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil, 
    {
        terminal_name = "sm_equipment_auto_upgrade_sure", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 1) 

    self:updateEquipInfo()
    self:onUpdateDraw(0)
end

function SmEquipmentAutoUpgrade:formatEquipmentRankLinkInfo( ... )
    if _ED.baseEquipmentRankLinkInfo == nil then
        _ED.baseEquipmentRankLinkInfo = {}
        for i= 1, dms.count(dms["equipment_rank_link"]) do
            local rank_link_info = {}
            local equipment_rank_link_info = dms.element(dms["equipment_rank_link"], i)
            rank_link_info.level = dms.atoi(equipment_rank_link_info, equipment_rank_link.old_equipment_mould)
            rank_link_info.library_group = dms.atoi(equipment_rank_link_info, equipment_rank_link.library_group)
            rank_link_info.need_silver = dms.atoi(equipment_rank_link_info, equipment_rank_link.need_silver)
            rank_link_info.need_material = dms.atos(equipment_rank_link_info, equipment_rank_link.need_material)
            rank_link_info.need_user_lv = zstring.tonumber(zstring.split(dms.atos(equipment_rank_link_info, equipment_rank_link.need_user_lv), ",")[rank_link_info.library_group])
            if _ED.baseEquipmentRankLinkInfo[""..rank_link_info.library_group] == nil then
                _ED.baseEquipmentRankLinkInfo[""..rank_link_info.library_group] = {}
            end
            _ED.baseEquipmentRankLinkInfo[""..rank_link_info.library_group][""..rank_link_info.level] = rank_link_info
        end
    end
end

function SmEquipmentAutoUpgrade:init(params)
    self._choose_ship = params[1]
    self._choose_equip = params[2]
    self._choose_index = self._choose_equip.m_index

    self:formatEquipmentRankLinkInfo()
    self:onInit()
    return self
end

function SmEquipmentAutoUpgrade:onExit()
    state_machine.remove("sm_equipment_auto_upgrade_change_level")
    state_machine.remove("sm_equipment_auto_upgrade_sure")
end