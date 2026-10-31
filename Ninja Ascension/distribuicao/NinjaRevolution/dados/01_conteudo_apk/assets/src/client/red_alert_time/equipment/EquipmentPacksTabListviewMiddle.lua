--------------------------------------------------------------------------------------------------------------
--  中级结晶兑换
--------------------------------------------------------------------------------------------------------------
EquipmentPacksTabListviewMiddle = class("EquipmentPacksTabListviewMiddleClass", Window)

local equipment_packs_tab_listview_middle_window_open_terminal = {
    _name = "equipment_packs_tab_listview_middle_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentPacksTabListviewMiddle:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_packs_tab_listview_middle_window_open_terminal)
state_machine.init()

function EquipmentPacksTabListviewMiddle:ctor()
    self.super:ctor()
    self.roots = {}

    self._prop_id = 0
    -- Initialize equipment_packs_tab_listview_middle state machine.
    local function init_equipment_packs_tab_listview_middle_terminal()
        local equipment_packs_tab_listview_middle_show_terminal = {
            _name = "equipment_packs_tab_listview_middle_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local equipment_packs_tab_listview_middle_hide_terminal = {
            _name = "equipment_packs_tab_listview_middle_hide",
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

        local equipment_packs_tab_listview_middle_update_terminal = {
            _name = "equipment_packs_tab_listview_middle_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_packs_tab_listview_middle_show_terminal)
        state_machine.add(equipment_packs_tab_listview_middle_hide_terminal)
        state_machine.add(equipment_packs_tab_listview_middle_update_terminal)
        state_machine.init()
    end
    
    -- call func equipment_packs_tab_listview_middle create state machine.
    init_equipment_packs_tab_listview_middle_terminal()

end

function EquipmentPacksTabListviewMiddle:updateInfo( ... )
    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        v:onUpdateDraw()
    end
end

function EquipmentPacksTabListviewMiddle:updateDraw()
    local root = self.roots[1]
    
    local ListView_packs_change = ccui.Helper:seekWidgetByName(root, "ListView_packs_change")
    self._list_view = ListView_packs_change
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local result = {}
    for k, v in pairs(_ED.base_equipment_shop_info) do
        if v.shop_type == 2 then
            table.insert(result, v)
        end
    end

    local function sortFunction(a, b)
        return a.id < b.id
    end
    table.sort(result, sortFunction)

    for k, v in pairs(result) do
        local cell = state_machine.excute("equipment_parts_change_cell_create", 0, {k, v, self._prop_id})
        self._list_view:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()
    
end

function EquipmentPacksTabListviewMiddle:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_packs_change_arrow_down:setVisible(true)
        else
            self._Image_packs_change_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_packs_change_arrow_up:setVisible(true)
        else
            self._Image_packs_change_arrow_up:setVisible(false)
        end
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

function EquipmentPacksTabListviewMiddle:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_packs_tab_4_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_packs_change_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_packs_change_arrow_down")
    self._Image_packs_change_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_packs_change_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_packs_change_arrow_down:stopAllActions()
    self._Image_packs_change_arrow_up:stopAllActions()
    playActions(self._Image_packs_change_arrow_down)
    playActions(self._Image_packs_change_arrow_up)
    self._Image_packs_change_arrow_down:setVisible(false)
    self._Image_packs_change_arrow_up:setVisible(false)

    self:updateDraw()
end

function EquipmentPacksTabListviewMiddle:onEnterTransitionFinish()
    
end

function EquipmentPacksTabListviewMiddle:init(params)
    local rootWindow = params[1]
    self._prop_id = params[2]
    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentPacksTabListviewMiddle:onExit()
    state_machine.remove("equipment_packs_tab_listview_middle_show")    
    state_machine.remove("equipment_packs_tab_listview_middle_hide")
    state_machine.remove("equipment_packs_tab_listview_middle_update")
end