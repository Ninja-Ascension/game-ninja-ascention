-- ------------------------------------------------------------------------------------------------------------
--  说明：操作
-- ------------------------------------------------------------------------------------------------------------
EquipmentPartsFragmentInfor = class("EquipmentPartsFragmentInforClass", Window)

--打开界面
local equipment_parts_fragment_infor_open_terminal = {
    _name = "equipment_parts_fragment_infor_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentPartsFragmentInforClass") == nil then
            local _win = EquipmentPartsFragmentInfor:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_parts_fragment_infor_close_terminal = {
    _name = "equipment_parts_fragment_infor_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentPartsFragmentInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_parts_fragment_infor_open_terminal)
state_machine.add(equipment_parts_fragment_infor_close_terminal)
state_machine.init()

function EquipmentPartsFragmentInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop_id = 0   -- 模板id
    self._prop = 0      -- 实例

    self._prop_count = 0       -- 拥有碎片数量
    self._need_prop_count = 0       -- 合成需要碎片数量
    self._chip_count = 0            -- 拥有万能碎片数量

    local function init_equipment_parts_fragment_infor_terminal()
        --分解
        local equipment_parts_fragment_infor_decompose_terminal = {
            _name = "equipment_parts_fragment_infor_decompose",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local equipments = {instance._prop}
                state_machine.excute("equipment_parts_decompose_window_open", 0, {2, equipments})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --合成
        local equipment_parts_fragment_infor_wear_terminal = {
            _name = "equipment_parts_fragment_infor_wear",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._prop_count + instance._chip_count < instance._need_prop_count then
                    TipDlg.drawTextDailog(red_alert_time_str[57])
                    state_machine.excute("equipment_parts_fragment_infor_close", 0, "")
                elseif instance._prop_count >= instance._need_prop_count then
                    instance:sureCompound(0)
                else
                    local need_chip_count = instance._need_prop_count - instance._prop_count
                    local change_of_equipment = dms.int(dms["prop_mould"], instance._prop_id, prop_mould.change_of_equipment)
                    local equipment_name = dms.string(dms["equipment_mould"], change_of_equipment, equipment_mould.equipment_name)
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureCompound, string.format(red_alert_time_str[84], need_chip_count, equipment_name))
                    fwin:open(tip, fwin._windows)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_parts_fragment_infor_decompose_terminal)    
        state_machine.add(equipment_parts_fragment_infor_wear_terminal)    
        state_machine.init()
    end
    init_equipment_parts_fragment_infor_terminal()
end

-- 确定合成
function EquipmentPartsFragmentInfor:sureCompound(sure_number)
    local function responseCombiningCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                state_machine.excute("equipment_parts_fragment_infor_close", 0, "")
            end
            state_machine.excute("equipment_packs_tab_chip_update_draw", 0, "")
            state_machine.excute("equipment_packs_tab_fitting_update_draw", 0, "")
            checkRewardObtainDraw()
        end
    end
    if sure_number == 0 then
        if self._prop == nil then
            return
        end
        protocol_command.prop_compound.param_list = self._prop.user_prop_id.."\r\n0\r\n1"
        NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, self, responseCombiningCallback, false, nil) 
    end
end

--初始化界面
function EquipmentPartsFragmentInfor:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_parts_fragment_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_fragment_close"), nil, 
    {
        terminal_name = "equipment_parts_fragment_infor_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "equipment_parts_fragment_infor_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_fragment_synthesis"), nil, 
    {
        terminal_name = "equipment_parts_fragment_infor_wear", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_fragment_reform"), nil, 
    {
        terminal_name = "equipment_parts_fragment_infor_decompose", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

-- 显示信息
function EquipmentPartsFragmentInfor:onUpdateDraw()
    local root = self.roots[1]

    local Panel_parts_fragment_icon = ccui.Helper:seekWidgetByName(root, "Panel_parts_fragment_icon")
    Panel_parts_fragment_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell", 0, {9, 7, self._prop_id, 1, self._prop.count})
    Panel_parts_fragment_icon:addChild(cell)

    local Text_fragment_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_fragment_attribute_n_1")
    local Text_fragment_attribute_n_2 = ccui.Helper:seekWidgetByName(root, "Text_fragment_attribute_n_2")
    local Text_fragment_attribute_n_3 = ccui.Helper:seekWidgetByName(root, "Text_fragment_attribute_n_3")
    local Text_fragment_attribute_n_4 = ccui.Helper:seekWidgetByName(root, "Text_fragment_attribute_n_4")
    local Text_fragment_attribute_n_5 = ccui.Helper:seekWidgetByName(root, "Text_fragment_attribute_n_5")
    local Text_fragment_attribute_n_6 = ccui.Helper:seekWidgetByName(root, "Text_fragment_attribute_n_6")

    local Text_fragment_attribute_t_5 = ccui.Helper:seekWidgetByName(root, "Text_fragment_attribute_t_5")
    local Text_fragment_attribute_t_6 = ccui.Helper:seekWidgetByName(root, "Text_fragment_attribute_t_6")

    local split_or_merge_count = dms.int(dms["prop_mould"], self._prop_id, prop_mould.split_or_merge_count)
    local change_of_equipment = dms.int(dms["prop_mould"], self._prop_id, prop_mould.change_of_equipment)

    local influence_type = dms.int(dms["equipment_mould"], change_of_equipment, equipment_mould.influence_type)
    local equipment_name = dms.string(dms["equipment_mould"], change_of_equipment, equipment_mould.equipment_name)
    Text_fragment_attribute_n_1:setString(tipStringInfo_tank_type_info[influence_type])
    Text_fragment_attribute_n_4:setString(equipment_name)
    
    Text_fragment_attribute_n_2:setString(self._prop.prop_number.."/"..split_or_merge_count)

    self._prop_count = tonumber(self._prop.prop_number)
    self._need_prop_count = tonumber(split_or_merge_count)

    -- 万能碎片数量
    local chip_id = dms.int(dms["prop_config"], 16, prop_config.param)
    local prop_count = 0 
    if fundPropWidthId(chip_id) ~= nil then 
        local token = fundPropWidthId(chip_id)
        prop_count = zstring.tonumber(token.prop_number)
    end
    Text_fragment_attribute_n_3:setString(prop_count)
    self._chip_count = prop_count

    -- 装备加成属性
    local initial_value = dms.string(dms["equipment_mould"], change_of_equipment, equipment_mould.initial_value)
    local add_attr_info = zstring.split(initial_value, "|")
    -- 加成属性1
    local add_attr_1 = zstring.split(add_attr_info[1], ",")
    local attr_id_1 = tonumber(add_attr_1[1])
    Text_fragment_attribute_t_5:setString(red_alert_time_attribute[attr_id_1 + 1] .. red_alert_time_str[29]..":")
    local is_hundred = false
    for k, v in pairs(attribute_hundred) do
        if v == attr_id_1 then
            is_hundred = true
            break
        end
    end
    if is_hundred == true then
        Text_fragment_attribute_n_5:setString("" .. add_attr_1[2] .. "%")
    else
        Text_fragment_attribute_n_5:setString("" .. add_attr_1[2])
    end

    -- 加成属性2
    if add_attr_info[2] == nil then
        Text_fragment_attribute_t_6:setString("")
        Text_fragment_attribute_n_6:setString("")
    else
        local add_attr_2 = zstring.split(add_attr_info[2], ",")
        local attr_id_2 = tonumber(add_attr_2[1])
        Text_fragment_attribute_t_6:setString(red_alert_time_attribute[attr_id_2 + 1] .. red_alert_time_str[29]..":")
        local is_hundred = false
        for k, v in pairs(attribute_hundred) do
            if v == attr_id_2 then
                is_hundred = true
                break
            end
        end
        if is_hundred == true then
            Text_fragment_attribute_n_6:setString("" .. add_attr_2[2] .. "%")
        else
            Text_fragment_attribute_n_6:setString("" .. add_attr_2[2])
        end
    end
end

--初始化
function EquipmentPartsFragmentInfor:init(params)
    self._prop_id = params[1]
    self._prop = params[2]
    self:onInit()
end

--移除状态机
function EquipmentPartsFragmentInfor:onExit()   
    state_machine.remove("equipment_parts_fragment_infor_decompose")
    state_machine.remove("equipment_parts_fragment_infor_wear")
end
