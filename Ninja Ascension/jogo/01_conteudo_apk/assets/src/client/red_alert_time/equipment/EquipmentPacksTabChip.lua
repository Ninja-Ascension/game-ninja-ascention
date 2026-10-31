--------------------------------------------------------------------------------------------------------------
--  仓库碎片
--------------------------------------------------------------------------------------------------------------
EquipmentPacksTabChip = class("EquipmentPacksTabChipClass", Window)

local equipment_packs_tab_chip_window_open_terminal = {
    _name = "equipment_packs_tab_chip_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentPacksTabChip:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_packs_tab_chip_window_open_terminal)
state_machine.init()

function EquipmentPacksTabChip:ctor()
    self.super:ctor()
    self.roots = {}

    self._all_combining_info = {}
    self._all_refining_info = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = nil

    self._is_empty = true          -- 仓库是否有碎片

    app.load("client.red_alert_time.cells.props.props_shop_packs_shop_cell")

    -- Initialize equipment_packs_tab_chip state machine.
    local function init_equipment_packs_tab_chip_terminal()
        local equipment_packs_tab_chip_show_terminal = {
            _name = "equipment_packs_tab_chip_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:pushUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local equipment_packs_tab_chip_hide_terminal = {
            _name = "equipment_packs_tab_chip_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新
        local equipment_packs_tab_chip_update_draw_terminal = {
            _name = "equipment_packs_tab_chip_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local posY = instance._list_view_poy
                instance:updateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local equipment_packs_tab_chip_auto_combining_terminal = {
            _name = "equipment_packs_tab_chip_auto_combining",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_empty == true then
                    TipDlg.drawTextDailog(red_alert_time_str[244])
                    return
                end

                local function responseCombiningCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("equipment_packs_tab_fitting_update_draw", 0, nil)
                        state_machine.excute("equipment_packs_tab_chip_update_draw", 0, nil)
                        checkRewardObtainDraw()
                        state_machine.excute("notification_center_update", 0, "push_notification_equipment_packs")
                        state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_fit")
                        state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_chip_compose")
                    end
                end
                local info = ""
                local count = 0
                local count_info = ""
                for k,v in pairs(instance._all_combining_info) do
                    if count == 0 then
                        info = info..v[1].user_prop_id
                        count_info = count_info..v[2]
                    else
                        info = info..","..v[1].user_prop_id
                        count_info = count_info..","..v[2]
                    end
                    count = count + 1
                end
                if count == 0 then
                    TipDlg.drawTextDailog(red_alert_time_str[55])
                    return
                end
                protocol_command.prop_compound.param_list = info.."\r\n0\r\n"..count_info
                NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, instance, responseCombiningCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 批量分解
        local equipment_packs_tab_chip_batch_decompose_terminal = {
            _name = "equipment_packs_tab_chip_batch_decompose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_empty == true then
                    TipDlg.drawTextDailog(red_alert_time_str[48])
                else
                    state_machine.excute("equipment_parts_batch_decompose_window_open", 0, {_datas = {decompose_type = 2, all_refining_info = instance._all_refining_info}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_packs_tab_chip_show_terminal)
        state_machine.add(equipment_packs_tab_chip_hide_terminal)
        state_machine.add(equipment_packs_tab_chip_update_draw_terminal)
        state_machine.add(equipment_packs_tab_chip_auto_combining_terminal)
        state_machine.add(equipment_packs_tab_chip_auto_refining_terminal)
        state_machine.add(equipment_packs_tab_chip_batch_decompose_terminal)
        state_machine.init()
    end
    
    -- call func equipment_packs_tab_chip create state machine.
    init_equipment_packs_tab_chip_terminal()
end

function EquipmentPacksTabChip:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function EquipmentPacksTabChip:updateDraw()
    local root = self.roots[1]

    local Text_equip_packs_not = ccui.Helper:seekWidgetByName(root, "Text_equip_packs_not")
    Text_equip_packs_not:setVisible(false)

    local ListView_packs_fragment = ccui.Helper:seekWidgetByName(root, "ListView_packs_fragment")
    self._list_view = ListView_packs_fragment
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    self._all_combining_info = {}
    self._all_refining_info = {}
    
    local combining_info = {}       -- 可合成
    local not_combining_info = {}   -- 不可合成
    local chip_info = nil           -- 万能碎片
    local chip_id = dms.int(dms["prop_config"], 16, prop_config.param)
    for k, v in pairs(_ED.user_prop) do
        local prop_id = tonumber(v.user_prop_template)
        if v.storage_page_index == 21 then
            local info = {}
            info.prop = v
            info.prop_id = prop_id
            info.count = tonumber(v.prop_number)
            info.order = dms.int(dms["prop_mould"], prop_id, prop_mould.trace_scene)

            if info.prop_id == chip_id then
                chip_info = info
            else
                self._is_empty = false

                local split_or_merge_count = dms.int(dms["prop_mould"], prop_id, prop_mould.split_or_merge_count)
                if split_or_merge_count > 0 and tonumber(v.prop_number) >= split_or_merge_count then
                    table.insert(self._all_combining_info, {v, math.floor(tonumber(v.prop_number)/split_or_merge_count)})
                    table.insert(combining_info, info)
                else
                    table.insert(not_combining_info, info)
                end

                local prop_quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)
                if prop_quality <= 2 then
                    if self._all_refining_info[""..prop_quality] == nil then
                        self._all_refining_info[""..prop_quality] = {}
                    end
                    table.insert(self._all_refining_info[""..prop_quality], v)
                end
            end
        end
    end

    local function sortFunction(a, b)
        return a.order < b.order
    end
    table.sort(combining_info, sortFunction)
    table.sort(not_combining_info, sortFunction)

    local result = {}
    if chip_info ~= nil then
        table.insert(result, chip_info)
    end
    for k, v in pairs(combining_info) do
        table.insert(result, v)
    end
    for k, v in pairs(not_combining_info) do
        table.insert(result, v)
    end

    local max_line = 0
    if #result <= 0 then
        Text_equip_packs_not:setVisible(true)
    elseif #result % 4 == 0 then
        max_line = #result / 4
    else
        max_line = math.floor(#result / 4) + 1
    end

    for i=1,max_line do
        local list = {result[(i-1)*4+1],result[(i-1)*4+2],result[(i-1)*4+3],result[(i-1)*4+4]}
        local cell = state_machine.excute("equipment_packs_tab_cell_create", 0, {i, list,2})
        self._list_view:addChild(cell)
     end 

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()
end

function EquipmentPacksTabChip:pushUpdateDraw()
    if _ED.push_equipment_packs["21"] == nil then
        _ED.push_equipment_packs["21"] = {}
    end
    for k, v in pairs(_ED.user_prop) do
        if v.storage_page_index == 21 then
            _ED.push_equipment_packs["21"][""..v.user_prop_template] = zstring.tonumber(v.prop_number)
        end
    end

    local str = ""
    for i=21,22 do
        if _ED.push_equipment_packs[""..i] == nil then
            _ED.push_equipment_packs[""..i] = {}
        end
        local base_info = _ED.push_equipment_packs[""..i]
        for k, v in pairs(_ED.user_prop) do
            if v.storage_page_index == i then
                local count = base_info[""..v.user_prop_template]
                if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
                else
                    if str == "" then
                        str = i..","..v.user_prop_template ..","..zstring.tonumber(v.prop_number)
                    else
                        str = str .."|"..i..","..v.user_prop_template ..","..zstring.tonumber(v.prop_number)
                    end
                end
            end
        end
    end
    cc.UserDefault:getInstance():setStringForKey(getKey("push_equipment_packs"), str)
end

function EquipmentPacksTabChip:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function EquipmentPacksTabChip:onInit()
    local csbItem = csb.createNode(string.format(config_csb.equipment.equipment_packs_tab_info, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_key_synthesis"), nil, 
    {
        terminal_name = "equipment_packs_tab_chip_auto_combining", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment_pack_chip_compose",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_key_synthesis"),
        _invoke = nil,
        _interval = 0.2,})

    -- 批量分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_batch_decompositon"), nil, 
    {
        terminal_name = "equipment_packs_tab_chip_batch_decompose", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  
    
    self:updateDraw()
    self:pushUpdateDraw()
end

function EquipmentPacksTabChip:onEnterTransitionFinish()
    
end

function EquipmentPacksTabChip:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentPacksTabChip:onExit()
    state_machine.remove("equipment_packs_tab_chip_show")    
    state_machine.remove("equipment_packs_tab_chip_hide")
    state_machine.remove("equipment_packs_tab_chip_update_draw")
    state_machine.remove("equipment_packs_tab_chip_auto_combining")
    state_machine.remove("equipment_packs_tab_chip_auto_refining")
    state_machine.remove("equipment_packs_tab_chip_batch_decompose")
end