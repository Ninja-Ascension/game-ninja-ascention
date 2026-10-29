-- ------------------------------------------------------------------------------------------------------------
--  说明：装备分解
-- ------------------------------------------------------------------------------------------------------------
EquipmentPartsDecompose = class("EquipmentPartsDecomposeClass", Window)

--打开界面
local equipment_parts_decompose_window_open_terminal = {
    _name = "equipment_parts_decompose_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentPartsDecomposeClass") == nil then
            local decompose_type = params[1]
            local equipments = params[2]
            local _win = EquipmentPartsDecompose:new()
            _win:init(decompose_type, equipments)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_parts_decompose_window_close_terminal = {
    _name = "equipment_parts_decompose_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentPartsDecomposeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_parts_decompose_window_open_terminal)
state_machine.add(equipment_parts_decompose_window_close_terminal)
state_machine.init()

function EquipmentPartsDecompose:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._decompose_type = decompose_type
    self._equipments = equipments

    self._get_props = {}                -- 分解后可获得的道具

    app.load("client.red_alert_time.cells.props.props_icon_cell")
     -- Initialize alert_home state machine.
    local function init_equipment_parts_decompose_terminal()
        --确定分解
        local equipment_parts_decompose_sure_terminal = {
            _name = "equipment_parts_decompose_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._decompose_type == 1 then       -- 分解配件
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    state_machine.excute("equipment_parts_decompose_window_close", 0, "")
                                end
                                checkRewardObtainDraw()
                                state_machine.excute("equipment_parts_infor_window_close", 0, "")
                                state_machine.excute("equipment_packs_tab_fitting_update_draw", 0, "")
                                state_machine.excute("equipment_packs_tab_data_update_draw", 0, "")
                                state_machine.excute("equipment_packs_tab_exchange_update_draw", 0, "")
                                state_machine.excute("equipment_strengthen_reform_window_close", 0, "")
                                state_machine.excute("notification_center_update", 0, "push_notification_equipment_packs")
                                state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_data")
                            end
                            checkPlayEffect(20)
                        end
                    end

                    local str = ""
                    for k, v in pairs(instance._equipments) do
                        str = str..v.equip_id..","
                    end

                    protocol_command.equipment_return.param_list = str
                    NetworkManager:register(protocol_command.equipment_return.code, nil, nil, nil, instance, responseCallback, false, nil)
                elseif instance._decompose_type == 2 then       -- 分解碎片
                    local prop_id_str = ""
                    local prop_count_str = ""

                    for k, v in pairs(instance._equipments) do
                        prop_id_str = prop_id_str .. v.user_prop_id .. ","
                        prop_count_str = prop_count_str .. v.prop_number .. ","
                    end

                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                state_machine.excute("equipment_parts_decompose_window_close", 0, "")
                            end
                            checkRewardObtainDraw()
                            state_machine.excute("equipment_parts_fragment_infor_close", 0, "")
                            state_machine.excute("equipment_packs_tab_chip_update_draw", 0, "")
                            state_machine.excute("equipment_packs_tab_data_update_draw", 0, "")
                            state_machine.excute("equipment_packs_tab_exchange_update_draw", 0, "")
                            state_machine.excute("notification_center_update", 0, "push_notification_equipment_packs")
                            state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_data")
                        end
                    end
                    protocol_command.prop_use.param_list = prop_id_str.."\r\n"..prop_count_str.."\r\n-1\r\n-1"
                    NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        state_machine.add(equipment_parts_decompose_sure_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_equipment_parts_decompose_terminal()
end

--初始化界面
function EquipmentPartsDecompose:onInit()
    local csbItem = nil
    if table.nums(self._get_props) < 4 then
        csbItem = csb.createNode(string.format(config_csb.equipment.equipment_parts_decompose_n, 1))
    else
        csbItem = csb.createNode(string.format(config_csb.equipment.equipment_parts_decompose_n, 2))
    end
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_decompose_close"), nil, 
    {
        terminal_name = "equipment_parts_decompose_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "equipment_parts_decompose_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_decompose_sure"), nil, 
    {
        terminal_name = "equipment_parts_decompose_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_decompose_cancel"), nil, 
    {
        terminal_name = "equipment_parts_decompose_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

-- 显示信息
function EquipmentPartsDecompose:onUpdateDraw()
    local root = self.roots[1]

    local Text_parts_attribute_t_1 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_t_1")

    local get_props = {}

    local count = 0
    local describe = ""
    if self._decompose_type == 1 then           -- 分解配件
        count = table.nums(self._equipments)
        describe = red_alert_time_str[45]
    elseif self._decompose_type == 2 then           -- 分解碎片
        for k, v in pairs(self._equipments) do
            count = count + tonumber(v.prop_number)
        end
        describe = red_alert_time_str[46]
    end
    Text_parts_attribute_t_1:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[221], "fonts/simhei.ttf",22)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, count, "fonts/simhei.ttf",22)
    _richText:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, describe, "fonts/simhei.ttf",22)
    _richText:pushBackElement(re3)
    _richText:setPosition(cc.p(Text_parts_attribute_t_1:getContentSize().width/2,Text_parts_attribute_t_1:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_parts_attribute_t_1:getContentSize().width,22))
    Text_parts_attribute_t_1:addChild(_richText)

    local result = {}
    for k, v in pairs(self._get_props) do
        local info = {}
        info.prop_id = tonumber(k)
        info.prop_count = v
        info.order = dms.int(dms["prop_mould"], info.prop_id, prop_mould.trace_scene)
        table.insert(result, info)
    end

    local function sortFunction(a, b)
        return a.order < b.order
    end
    table.sort(result, sortFunction)

    local index = 1
    for k, v in pairs(result) do
        local Panel_parts_icon = ccui.Helper:seekWidgetByName(root, "Panel_parts_icon_"..index)
        Panel_parts_icon:removeAllChildren(true)
        local cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, v.prop_id, 1, v.prop_count})
        Panel_parts_icon:addChild(cell)
        index = index + 1
    end
end

function EquipmentPartsDecompose:getProps()
    local get_props = {}
    if self._decompose_type == 1 then           -- 分解配件
        for k, v in pairs(self._equipments) do
            local props = zstring.split(v.refining_items, "|")
            -- 分解的材料
            for i, prop_info_str in pairs(props) do
                local prop_info = zstring.split(prop_info_str, ",")
                local prop_id = prop_info[1]
                local prop_count = prop_info[3]
                if get_props[""..prop_id] == nil then
                    get_props[""..prop_id] = 0
                end
                get_props[""..prop_id] = get_props[""..prop_id] + tonumber(prop_count)
            end
            -- 强化返还材料
            local back_ratio = dms.int(dms["equipment_mould"], v.equipment_mould_id, equipment_mould.awaken_equipment_id)
            local quality = tonumber(v.grow_level)
            local upgrade_level = tonumber(v.upgrade_level)
            local cost_gem = 0
            for i = 1, upgrade_level do
                if quality == 1 then        -- 绿色配件
                    cost_gem = cost_gem + dms.int(dms["equipment_level_requirement"], i, equipment_level_requirement.silver_amount)
                else
                    local index = equipment_level_requirement.cost_gem_1 + (quality - 2) * 2
                    cost_gem = cost_gem + dms.int(dms["equipment_level_requirement"], i, index)
                end
            end
            cost_gem = math.ceil(cost_gem * back_ratio / 100)
            local prop_id = 1
            if get_props[""..prop_id] == nil then
                get_props[""..prop_id] = 0
            end
            get_props[""..prop_id] = get_props[""..prop_id] + tonumber(cost_gem)
            -- 改造返还材料
            local reform_need_ids = zstring.split(dms.string(dms["equipment_mould"], v.equipment_mould_id, equipment_mould.awaken_need_resource), ",")
            local rank_up_level = tonumber(v.rank_up_level)
            for i = 1, rank_up_level do
                reform_need_id = tonumber(reform_need_ids[i])
                local need_props = zstring.split(dms.string(dms["equipment_remake"], reform_need_id, equipment_remake.need_props), "|")
                for i, prop_info_str in pairs(need_props) do
                    local prop_info = zstring.split(prop_info_str, ",")
                    local prop_id = prop_info[1]
                    local prop_count = prop_info[3]
                    if get_props[""..prop_id] == nil then
                        get_props[""..prop_id] = 0
                    end
                    prop_count = math.ceil(prop_count * back_ratio / 100)
                    get_props[""..prop_id] = get_props[""..prop_id] + tonumber(prop_count)
                end
            end
        end
    elseif self._decompose_type == 2 then           -- 分解碎片
        for k, v in pairs(self._equipments) do
            local prop_id = tonumber(v.user_prop_template)
            local scene_reward_id = dms.int(dms["prop_mould"], prop_id, prop_mould.addition_group_index)
            local props = zstring.split(dms.string(dms["scene_reward"], scene_reward_id, scene_reward.reward_items), "|")
            for i, prop_info_str in pairs(props) do
                local prop_info = zstring.split(prop_info_str, ",")
                local prop_id = prop_info[1]
                local prop_count = prop_info[3] * tonumber(v.prop_number)
                if get_props[""..prop_id] == nil then
                    get_props[""..prop_id] = 0
                end
                get_props[""..prop_id] = get_props[""..prop_id] + tonumber(prop_count)
            end
        end
    end

    for k, v in pairs(get_props) do
        if v <= 0 then
            get_props[""..k] = nil
        end
    end

    self._get_props = get_props
end

--初始化
function EquipmentPartsDecompose:init(decompose_type, equipments)
    self._decompose_type = decompose_type
    self._equipments = equipments

    self:getProps()
    self:onInit()
end

--移除状态机
function EquipmentPartsDecompose:onExit()
    state_machine.remove("equipment_parts_decompose_sure")
end