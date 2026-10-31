--------------------------------------------------------------------------------------------------------------
--  仓库材料
--------------------------------------------------------------------------------------------------------------
EquipmentPacksTabData = class("EquipmentPacksTabDataClass", Window)

local equipment_packs_tab_data_window_open_terminal = {
    _name = "equipment_packs_tab_data_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentPacksTabData:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_packs_tab_data_window_open_terminal)
state_machine.init()

function EquipmentPacksTabData:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = nil

    app.load("client.red_alert_time.cells.props.props_shop_packs_shop_cell")

    -- Initialize equipment_packs_tab_data state machine.
    local function init_equipment_packs_tab_data_terminal()
        local equipment_packs_tab_data_show_terminal = {
            _name = "equipment_packs_tab_data_show",
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

        local equipment_packs_tab_data_hide_terminal = {
            _name = "equipment_packs_tab_data_hide",
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
        local equipment_packs_tab_data_update_draw_terminal = {
            _name = "equipment_packs_tab_data_update_draw",
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
        state_machine.add(equipment_packs_tab_data_show_terminal)
        state_machine.add(equipment_packs_tab_data_hide_terminal)
        state_machine.add(equipment_packs_tab_data_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func equipment_packs_tab_data create state machine.
    init_equipment_packs_tab_data_terminal()

end

function EquipmentPacksTabData:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function EquipmentPacksTabData:updateDraw()
    local root = self.roots[1]
    
    local Text_equip_packs_not = ccui.Helper:seekWidgetByName(root, "Text_equip_packs_not")
    Text_equip_packs_not:setVisible(false)

    local ListView_packs_fragment = ccui.Helper:seekWidgetByName(root, "ListView_packs_fragment")
    self._list_view = ListView_packs_fragment
    self._list_view:removeAllItems()
    self._list_view:jumpToTop()

    local result = {}
    for k, v in pairs(_ED.user_prop) do
        local prop_id = tonumber(v.user_prop_template)
        if v.storage_page_index == 22 then
            local info = {}
            info.prop_id = prop_id
            info.count = tonumber(v.prop_number)
            info.order = dms.int(dms["prop_mould"], prop_id, prop_mould.trace_scene)
            table.insert(result, info)
        end
    end

    local function sortFunction(a, b)
        return a.order < b.order
    end
    table.sort(result, sortFunction)

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
        local cell = state_machine.excute("equipment_packs_tab_cell_create", 0, {i, list,3})
        self._list_view:addChild(cell)
     end 

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()

end

function EquipmentPacksTabData:pushUpdateDraw()
    if _ED.push_equipment_packs["22"] == nil then
        _ED.push_equipment_packs["22"] = {}
    end
    for k, v in pairs(_ED.user_prop) do
        local prop_id = tonumber(v.user_prop_template)
        if v.storage_page_index == 22 then
            _ED.push_equipment_packs["22"][""..v.user_prop_template] = zstring.tonumber(v.prop_number)
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

function EquipmentPacksTabData:onUpdate(dt)
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

function EquipmentPacksTabData:onInit()
    local csbItem = csb.createNode(string.format(config_csb.equipment.equipment_packs_tab_info, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
    self:pushUpdateDraw()
end

function EquipmentPacksTabData:onEnterTransitionFinish()
    
end

function EquipmentPacksTabData:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentPacksTabData:onExit()
    state_machine.remove("equipment_packs_tab_data_show")    
    state_machine.remove("equipment_packs_tab_data_hide")
    state_machine.remove("equipment_packs_tab_data_update_draw")
end