-- ------------------------------------------------------------------------------------------------------------
--  说明：装备批量分解
-- ------------------------------------------------------------------------------------------------------------
EquipmentPartsBatchDecompose = class("EquipmentPartsBatchDecomposeClass", Window)

--打开界面
local equipment_parts_batch_decompose_window_open_terminal = {
    _name = "equipment_parts_batch_decompose_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentPartsBatchDecomposeClass") == nil then
            local decompose_type = params._datas.decompose_type
            local all_refining_info = params._datas.all_refining_info
            local _win = EquipmentPartsBatchDecompose:new()
            _win:init(decompose_type, all_refining_info)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_parts_batch_decompose_window_close_terminal = {
    _name = "equipment_parts_batch_decompose_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentPartsBatchDecomposeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_parts_batch_decompose_window_open_terminal)
state_machine.add(equipment_parts_batch_decompose_window_close_terminal)
state_machine.init()

function EquipmentPartsBatchDecompose:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._decompose_b = false         -- 是否分解B级配件
    self._decompose_c = false         -- 是否分解C级配件

    app.load("client.red_alert_time.cells.props.props_icon_cell")
     -- Initialize alert_home state machine.
    local function init_equipment_parts_batch_decompose_terminal()
        --确定分解
        local equipment_parts_batch_decompose_sure_terminal = {
            _name = "equipment_parts_batch_decompose_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local equipments = {}
                local decompose_quality = 0         -- 分解装备品质
                if instance._decompose_c:isSelected() == true then      -- 分级c级配件
                    decompose_quality = 1
                elseif instance._decompose_b:isSelected() == true then      -- 分级b级配件
                    decompose_quality = 2
                else
                    TipDlg.drawTextDailog(red_alert_time_str[43])
                    return
                end

                if instance._decompose_type == 1 then   -- 分解配件
                    for k, v in pairs(_ED.user_equiment) do
                        if tonumber(v.is_equiped) == 0 
                            and v.grow_level == decompose_quality 
                            and v.armor_type == 0
                            then
                            table.insert(equipments, v)
                        end
                    end
                elseif instance._decompose_type == 2 then   -- 分解碎片
                    equipments = self._all_refining_info[""..decompose_quality]
                end

                if equipments == nil or table.nums(equipments) == 0 then
                    if instance._decompose_type == 1 then
                        TipDlg.drawTextDailog(red_alert_time_str[47])
                    else
                        TipDlg.drawTextDailog(red_alert_time_str[48])
                    end
                    return
                end

                state_machine.excute("equipment_parts_decompose_window_open", 0, {instance._decompose_type, equipments})
                state_machine.excute("equipment_parts_batch_decompose_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择分解C级
        local equipment_parts_batch_decompose_C_terminal = {
            _name = "equipment_parts_batch_decompose_C",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._decompose_b:isSelected() == true then
                    instance._decompose_b:setSelected(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择分解B级
        local equipment_parts_batch_decompose_B_terminal = {
            _name = "equipment_parts_batch_decompose_B",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._decompose_c:isSelected() == true then
                    instance. _decompose_c:setSelected(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_parts_batch_decompose_sure_terminal)
        state_machine.add(equipment_parts_batch_decompose_C_terminal)
        state_machine.add(equipment_parts_batch_decompose_B_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_equipment_parts_batch_decompose_terminal()
end

--初始化界面
function EquipmentPartsBatchDecompose:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_parts_batch_decompose)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_batch_decompose_close"), nil, 
    {
        terminal_name = "equipment_parts_batch_decompose_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "equipment_parts_batch_decompose_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_decompose_sure"), nil, 
    {
        terminal_name = "equipment_parts_batch_decompose_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 分解C级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_batch_quality_1"), nil, 
    {
        terminal_name = "equipment_parts_batch_decompose_C", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 分解B级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_batch_quality_2"), nil, 
    {
        terminal_name = "equipment_parts_batch_decompose_B", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

-- 显示信息
function EquipmentPartsBatchDecompose:onUpdateDraw()
    local root = self.roots[1]

    local CheckBox_batch_quality_1 = ccui.Helper:seekWidgetByName(root, "CheckBox_batch_quality_1")
    local CheckBox_batch_quality_2 = ccui.Helper:seekWidgetByName(root, "CheckBox_batch_quality_2")
    CheckBox_batch_quality_1:setSelected(false)
    CheckBox_batch_quality_2:setSelected(false)

    self._decompose_c = CheckBox_batch_quality_1
    self._decompose_b = CheckBox_batch_quality_2

    local Text_batch_decompose_title = ccui.Helper:seekWidgetByName(root, "Text_batch_decompose_title")
    local Text_batch_quality_name_1 = ccui.Helper:seekWidgetByName(root, "Text_batch_quality_name_1")
    local Text_batch_quality_name_2 = ccui.Helper:seekWidgetByName(root, "Text_batch_quality_name_2")

    if self._decompose_type == 1 then
        Text_batch_quality_name_1:setString(red_alert_time_str[39])
        Text_batch_quality_name_2:setString(red_alert_time_str[40])
        Text_batch_decompose_title:setString(red_alert_time_str[241])
    else
        Text_batch_quality_name_1:setString(red_alert_time_str[41])
        Text_batch_quality_name_2:setString(red_alert_time_str[42])
        Text_batch_decompose_title:setString(red_alert_time_str[242])
    end
end

--初始化
function EquipmentPartsBatchDecompose:init(decompose_type, all_refining_info)
    self._decompose_type = decompose_type       -- 1：配件，2：碎片
    self._all_refining_info = all_refining_info
    self:onInit()
end

--移除状态机
function EquipmentPartsBatchDecompose:onExit()
    state_machine.remove("equipment_parts_batch_decompose_sure")
    state_machine.remove("equipment_parts_batch_decompose_C")
    state_machine.remove("equipment_parts_batch_decompose_B")
end