-- ------------------------------------------------------------------------------------------------------------
--  说明：军团城市战战报
-- ------------------------------------------------------------------------------------------------------------
LegionCityRecordListView = class("LegionCityRecordListViewClass", Window)

--打开界面
local legion_city_record_liseview_open_terminal = {
    _name = "legion_city_record_liseview_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionCityRecordListView:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_record_liseview_open_terminal)
state_machine.init()

function LegionCityRecordListView:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._from_type = 0

    app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    local function init_legion_city_record_liseview_terminal()
        local legion_city_record_liseview_show_terminal = {
            _name = "legion_city_record_liseview_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params[1]
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_record_liseview_hide_terminal = {
            _name = "legion_city_record_liseview_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params[1]
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_record_liseview_update_list_info_terminal = {
            _name = "legion_city_record_liseview_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params[1]
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_record_liseview_show_terminal)
        state_machine.add(legion_city_record_liseview_hide_terminal)
        state_machine.add(legion_city_record_liseview_update_list_info_terminal)
        state_machine.init()
    end
    init_legion_city_record_liseview_terminal()
end

function LegionCityRecordListView:onUpdateDraw(sort_index)
    local root = self.roots[1]
    local ListView_legion_city_record = ccui.Helper:seekWidgetByName(root, "ListView_legion_city_record")
    ListView_legion_city_record:removeAllItems()
    ListView_legion_city_record:jumpToTop()
    self._list_view = ListView_legion_city_record

    local result = {}
    if self._from_type == 1 then
        if _ED.city_resource_battle_report ~= nil and _ED.city_resource_battle_report[10007] ~= nil then
            result = _ED.city_resource_battle_report[10007]
        end
    else
        if _ED.city_resource_battle_report ~= nil and _ED.city_resource_battle_report[210] ~= nil then
            result = _ED.city_resource_battle_report[210]
        end
    end

    local function sortFunction(a, b)
        return tonumber(a.time) > tonumber(b.time)
    end
    table.sort(result, sortFunction)

    for k, v in pairs(result) do
        local cell = state_machine.excute("legion_city_record_cell_create", 0, {k, v})
        self._list_view:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function LegionCityRecordListView:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
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

function LegionCityRecordListView:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_record_liseview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function LegionCityRecordListView:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._from_type = params[2]
    self:onInit()
    return self
end

function LegionCityRecordListView:onExit()

end