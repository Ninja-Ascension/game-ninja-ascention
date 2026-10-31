----------------------------------------------------------------------------------------------------
-- 说明：强化结果cell
-------------------------------------------------------------------------------------------------------
EquipmentStrengthenResultCell = class("EquipmentStrengthenResultCellClass", Window)
EquipmentStrengthenResultCell.__size1 = nil
EquipmentStrengthenResultCell.__size2 = nil

local equipment_strengthen_result_cell_create_terminal = {
    _name = "equipment_strengthen_result_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EquipmentStrengthenResultCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_strengthen_result_cell_create_terminal)
state_machine.init()

function EquipmentStrengthenResultCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil
end

function EquipmentStrengthenResultCell:onUpdateDraw()
    local root = self.roots[1]
    if tonumber(self._info.result) ~= 0 then
        local Text_streng_fail_time = ccui.Helper:seekWidgetByName(root, "Text_streng_fail_time")
        Text_streng_fail_time:setString(string.format(red_alert_time_str[59], self._index))

        local Text_streng_fail_infor = ccui.Helper:seekWidgetByName(root, "Text_streng_fail_infor")
        if tonumber(self._info.result) == 1 then
            Text_streng_fail_infor:setString(red_alert_time_str[239])
        elseif tonumber(self._info.result) == 2 then
            Text_streng_fail_infor:setString(red_alert_time_str[53])
        else
            Text_streng_fail_infor:setString(red_alert_time_str[240])
        end
    else
        local Text_streng_time = ccui.Helper:seekWidgetByName(root, "Text_streng_time")
        Text_streng_time:setString(string.format(red_alert_time_str[59], self._index))

        for i = 1, 5 do
            local Panel_streng_state = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_"..i)
            Panel_streng_state:removeBackGroundImage()
        end

        local Text_streng_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_1")       -- 强度
        local Text_streng_attribute_n_2 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_2")       -- 强化等级
        local Text_streng_attribute_n_3 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_3")       -- 改造等级
        Text_streng_attribute_n_1:setString(self._last_info.strength)
        Text_streng_attribute_n_2:setString(self._last_info.upgrade_level)
        Text_streng_attribute_n_3:setString(self._last_info.rank_up_level)

        local Text_streng_attribute_change_1 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_1")
        local Text_streng_attribute_change_2 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_2")
        local Text_streng_attribute_change_3 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_3")
        Text_streng_attribute_change_1:setString(self._info.strength)
        Text_streng_attribute_change_2:setString(self._info.upgrade_level)
        Text_streng_attribute_change_3:setString(self._info.rank_up_level)

        local Panel_streng_state_1 = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_1")
        local Panel_streng_state_2 = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_2")
        Panel_streng_state_1:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
        Panel_streng_state_2:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)

        local last_add_attr_info = zstring.split(self._last_info.attr, "|")
        local add_attr_info = zstring.split(self._info.attr, "|")
        -- 加成属性1
        local Text_streng_attribute_4 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_4")
        local Text_streng_attribute_n_4 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_4")
        local Text_streng_attribute_change_4 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_4")
        local Panel_streng_state_4 = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_4")
        Panel_streng_state_4:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)

        local add_attr_1 = zstring.split(add_attr_info[1], ",")
        local last_add_attr_1 = zstring.split(last_add_attr_info[1], ",")
        local attr_id_1 = tonumber(add_attr_1[1])
        Text_streng_attribute_4:setString(red_alert_time_attribute[attr_id_1 + 1] .. red_alert_time_str[29]..":")
        local is_hundred = false
        for k, v in pairs(attribute_hundred) do
            if v == attr_id_1 then
                is_hundred = true
                break
            end
        end
        if is_hundred == true then
            Text_streng_attribute_n_4:setString("" .. last_add_attr_1[2] .. "%")
            Text_streng_attribute_change_4:setString("" .. add_attr_1[2] .. "%")
        else
            Text_streng_attribute_n_4:setString("" .. last_add_attr_1[2])
            Text_streng_attribute_change_4:setString("" .. add_attr_1[2])
        end

        -- 加成属性2
        local Text_streng_attribute_5 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_5")
        local Text_streng_attribute_n_5 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_5")
        local Text_streng_attribute_change_5 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_5")
        if add_attr_info[2] == nil then
            Text_streng_attribute_5:setString("")
            Text_streng_attribute_n_5:setString("")
            Text_streng_attribute_change_5:setString("")
        else
            local Panel_streng_state_5 = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_5")
            Panel_streng_state_5:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)

            local add_attr_2 = zstring.split(add_attr_info[2], ",")
            local last_add_attr_2 = zstring.split(last_add_attr_info[2], ",")
            local attr_id_2 = tonumber(add_attr_2[1])
            Text_streng_attribute_5:setString(red_alert_time_attribute[attr_id_2 + 1] .. red_alert_time_str[29]..":")
            local is_hundred = false
            for k, v in pairs(attribute_hundred) do
                if v == attr_id_2 then
                    is_hundred = true
                    break
                end
            end
            if is_hundred == true then
                Text_streng_attribute_n_5:setString("" .. last_add_attr_2[2] .. "%")
                Text_streng_attribute_change_5:setString("" .. add_attr_2[2] .. "%")
            else
                Text_streng_attribute_n_5:setString("" .. last_add_attr_2[2])
                Text_streng_attribute_change_5:setString("" .. add_attr_2[2])
            end
        end
    end
end

function EquipmentStrengthenResultCell:onEnterTransitionFinish()

end

function EquipmentStrengthenResultCell:onInit()
    local ntype = 1
    if tonumber(self._info.result) ~= 0 then
        ntype = 2
    end
    local csbItem = csb.createNode(string.format(config_csb.cells.equipment.equipment_strengthen_ten_cell, ntype))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    if tonumber(self._info.result) ~= 0 then
        if EquipmentStrengthenResultCell.__size1 == nil then
            EquipmentStrengthenResultCell.__size1 = root:getContentSize()
        end
    else
        if EquipmentStrengthenResultCell.__size2 == nil then
            EquipmentStrengthenResultCell.__size2 = root:getContentSize()
        end
    end

    self:onUpdateDraw()
end

function EquipmentStrengthenResultCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._last_info = params[3]

    self:onInit()
    if tonumber(self._info.result) ~= 0 then
        self:setContentSize(EquipmentStrengthenResultCell.__size1)
    else
        self:setContentSize(EquipmentStrengthenResultCell.__size2)
    end
end

