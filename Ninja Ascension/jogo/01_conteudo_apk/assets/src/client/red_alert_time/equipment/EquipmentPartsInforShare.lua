-- ------------------------------------------------------------------------------------------------------------
--  说明：分享出来的配件信息
-- ------------------------------------------------------------------------------------------------------------
EquipmentPartsInforShare = class("EquipmentPartsInforShareClass", Window)

--打开界面
local equipment_parts_infor_share_window_open_terminal = {
    _name = "equipment_parts_infor_share_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentPartsInforShareClass") == nil then
            local equipment_info = params[1]
            local _win = EquipmentPartsInforShare:new()
            _win:init(equipment_info)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_parts_infor_share_window_close_terminal = {
    _name = "equipment_parts_infor_share_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentPartsInforShareClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_parts_infor_share_window_open_terminal)
state_machine.add(equipment_parts_infor_share_window_close_terminal)
state_machine.init()

function EquipmentPartsInforShare:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._equipment_info = nil
    self._is_wear = false

    app.load("client.red_alert_time.cells.props.props_icon_cell")
end

--初始化界面
function EquipmentPartsInforShare:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_parts_infor_share)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_infor_close"), nil, 
    {
        terminal_name = "equipment_parts_infor_share_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "equipment_parts_infor_share_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

-- 显示信息
function EquipmentPartsInforShare:onUpdateDraw()
    local root = self.roots[1]

    -- 图标和名称
    local Panel_parts_icon = ccui.Helper:seekWidgetByName(root, "Panel_parts_icon")
    local Text_parts_name = ccui.Helper:seekWidgetByName(root, "Text_parts_name")
    Panel_parts_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell", 0, {8, 3, self._equipment_info, 7})
    Panel_parts_icon:addChild(cell)
    Text_parts_name:setString(self._equipment_info.equipment_name)
    -- 属性
    local Text_parts_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_1")         -- 强度
    local Text_parts_attribute_n_2 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_2")         -- 强化等级
    local Text_parts_attribute_n_3 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_3")         -- 改造等级
    local Text_parts_attribute_n_4 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_4")         -- 适用

    Text_parts_attribute_n_1:setString(self._equipment_info.strength)
    Text_parts_attribute_n_2:setString(self._equipment_info.upgrade_level)
    Text_parts_attribute_n_3:setString(self._equipment_info.rank_up_level)
    Text_parts_attribute_n_4:setString(tipStringInfo_tank_type_info[tonumber(self._equipment_info.influence_type)])

    local add_attr_info = zstring.split(self._equipment_info.attr, "|")

    -- 加成属性1
    local Text_parts_attribute_t_5 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_t_5")
    local Text_parts_attribute_n_5 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_5")
    local add_attr_1 = zstring.split(add_attr_info[1], ",")
    local attr_id_1 = tonumber(add_attr_1[1])
    Text_parts_attribute_t_5:setString(red_alert_time_attribute[attr_id_1 + 1] .. red_alert_time_str[29]..":")
    local is_hundred = false
    for k, v in pairs(attribute_hundred) do
        if v == attr_id_1 then
            is_hundred = true
            break
        end
    end
    if is_hundred == true then
        Text_parts_attribute_n_5:setString("" .. add_attr_1[2] .. "%")
    else
        Text_parts_attribute_n_5:setString("" .. add_attr_1[2])
    end

    -- 加成属性2
    local Text_parts_attribute_t_6 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_t_6")
    local Text_parts_attribute_n_6 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_6")
    if add_attr_info[2] == nil then
        Text_parts_attribute_t_6:setString("")
        Text_parts_attribute_n_6:setString("")
    else
        local add_attr_2 = zstring.split(add_attr_info[2], ",")
        local attr_id_2 = tonumber(add_attr_2[1])
        Text_parts_attribute_n_6:setString(red_alert_time_attribute[attr_id_2 + 1] .. red_alert_time_str[29]..":")
        local is_hundred = false
        for k, v in pairs(attribute_hundred) do
            if v == attr_id_2 then
                is_hundred = true
                break
            end
        end
        if is_hundred == true then
            Text_parts_attribute_t_6:setString("" .. add_attr_2[2] .. "%")
        else
            Text_parts_attribute_t_6:setString("" .. add_attr_2[2])
        end
    end
end

--初始化
function EquipmentPartsInforShare:init(equipment_info)
    self._equipment_info = equipment_info
    self:onInit()
end

--移除状态机
function EquipmentPartsInforShare:onExit()   

end
