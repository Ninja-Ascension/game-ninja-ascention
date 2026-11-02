-- ------------------------------------------------------------------------------------------------------------
--  仓库配件
-- ------------------------------------------------------------------------------------------------------------
EquipmentPacksTabFitting = class("EquipmentPacksTabFittingClass", Window)

local equipment_packs_tab_fitting_window_open_terminal = {
    _name = "equipment_packs_tab_fitting_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentPacksTabFitting:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_packs_tab_fitting_window_open_terminal)
state_machine.init()

function EquipmentPacksTabFitting:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = nil

    app.load("client.red_alert_time.cells.props.props_shop_packs_shop_cell")

    -- Initialize equipment_packs_tab_fitting state machine.
    local function init_equipment_packs_tab_fitting_terminal()
        local equipment_packs_tab_fitting_show_terminal = {
            _name = "equipment_packs_tab_fitting_show",
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

        local equipment_packs_tab_fitting_hide_terminal = {
            _name = "equipment_packs_tab_fitting_hide",
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
        local equipment_packs_tab_fitting_update_draw_terminal = {
            _name = "equipment_packs_tab_fitting_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 批量分解
        local equipment_packs_tab_batch_decompose_terminal = {
            _name = "equipment_packs_tab_batch_decompose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local can_decompose = false
                for k, v in pairs(_ED.user_equiment) do
                    if tonumber(v.is_equiped) == 0 
                        and v.armor_type == 0
                        and (v.grow_level == 1 or v.grow_level == 2)
                        then
                        can_decompose = true
                    end
                end
                if can_decompose == true then
                    state_machine.excute("equipment_parts_batch_decompose_window_open", 0, {_datas = {decompose_type = 1}})
                else
                    TipDlg.drawTextDailog(red_alert_time_str[47])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_packs_tab_fitting_show_terminal)
        state_machine.add(equipment_packs_tab_fitting_hide_terminal)
        state_machine.add(equipment_packs_tab_fitting_update_draw_terminal)
        state_machine.add(equipment_packs_tab_batch_decompose_terminal)
        state_machine.init()
    end
    
    -- call func equipment_packs_tab_fitting create state machine.
    init_equipment_packs_tab_fitting_terminal()

end

function EquipmentPacksTabFitting:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function EquipmentPacksTabFitting:updateDraw()
    local root = self.roots[1]

    local Text_equip_packs_not = ccui.Helper:seekWidgetByName(root, "Text_equip_packs_not")
    Text_equip_packs_not:setVisible(false)

    local ListView_packs = ccui.Helper:seekWidgetByName(root, "ListView_packs")
    self._list_view = ListView_packs
    self._list_view:removeAllItems()
    self._list_view:jumpToTop()

    function sortFunction(a, b)
        if tonumber(a.grow_level) > tonumber(b.grow_level)
            or (tonumber(a.grow_level) == tonumber(b.grow_level) and tonumber(a.rank_up_level) > tonumber(b.rank_up_level))
            or (tonumber(a.grow_level) == tonumber(b.grow_level) and tonumber(a.rank_up_level) == tonumber(b.rank_up_level) and tonumber(a.upgrade_level) > tonumber(b.upgrade_level))
            or (tonumber(a.grow_level) == tonumber(b.grow_level) and tonumber(a.rank_up_level) == tonumber(b.rank_up_level) and tonumber(a.upgrade_level) == tonumber(b.upgrade_level) and tonumber(a.equipment_mould_id) < tonumber(b.equipment_mould_id))
            then
            return true
        end
        return false
    end

    local result = {}
    for k, v in pairs(_ED.user_equiment) do
        if tonumber(v.is_equiped) == 0 and v.armor_type == 0 then  
            table.insert(result, v)
        end
    end
    table.sort(result, sortFunction)

    if #result == 0 then
        Text_equip_packs_not:setVisible(true)
    end

    local cell_line = {}
    local index = 0
    local info = {}
    for k, v in pairs(result) do
        table.insert(info, v)
        if index == 0 then
            table.insert(cell_line, info)
        end
        index = index + 1
        if index == 4 then
            index = 0
            info = {}
        end
    end

    for k, v in pairs(cell_line) do
        local cell = state_machine.excute("equipment_packs_tab_cell_create", 0, {k, v, 1})
        self._list_view:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

    state_machine.excute("equipment_packs_tab_update_equipment_number", 0, #result)
end

function EquipmentPacksTabFitting:pushUpdateDraw()
    if _ED.push_equipment_parts == nil then
        _ED.push_equipment_parts = {}
    end
    for k, v in pairs(_ED.user_equiment) do
        if tonumber(v.is_equiped) == 0 and v.armor_type == 0 then  
            _ED.push_equipment_parts[""..v.equip_id] = zstring.tonumber(v.equipment_mould_id)
        end
    end

    local str = ""
    for k, v in pairs(_ED.user_equiment) do
        if tonumber(v.is_equiped) == 0 and v.armor_type == 0 then
            local equipment_mould_id = _ED.push_equipment_parts[""..v.equip_id]
            if zstring.tonumber(v.equipment_mould_id) == zstring.tonumber(equipment_mould_id) then
                if str == "" then
                    str = zstring.tonumber(v.equip_id) ..","..zstring.tonumber(v.equipment_mould_id)
                else
                    str = str .."|"..zstring.tonumber(v.equip_id) ..","..zstring.tonumber(v.equipment_mould_id)
                end
            end
        end
    end
    cc.UserDefault:getInstance():setStringForKey(getKey("push_equipment_parts"), str)
end

function EquipmentPacksTabFitting:onUpdate(dt)
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

function EquipmentPacksTabFitting:onInit()
    local csbItem = csb.createNode(string.format(config_csb.equipment.equipment_packs_tab_info, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 批量分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_batch_decompositon"), nil, 
    {
        terminal_name = "equipment_packs_tab_batch_decompose", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        decompose_type = 1,
    }, nil, 1)  

    self:updateDraw()
    self:pushUpdateDraw()
end

function EquipmentPacksTabFitting:onEnterTransitionFinish()
    
end

function EquipmentPacksTabFitting:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentPacksTabFitting:onExit()
    state_machine.remove("equipment_packs_tab_fitting_show")    
    state_machine.remove("equipment_packs_tab_fitting_hide")
    state_machine.remove("equipment_packs_tab_fitting_update_draw")
    state_machine.remove("equipment_packs_tab_batch_decompose")
end