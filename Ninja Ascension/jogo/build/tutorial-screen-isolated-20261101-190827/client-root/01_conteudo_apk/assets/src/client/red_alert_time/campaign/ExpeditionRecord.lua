-- ------------------------------------------------------------------------------------------------------------
--  说明：远征战报
-- ------------------------------------------------------------------------------------------------------------
ExpeditionRecord = class("ExpeditionRecordClass", Window)

--打开界面
local expedition_record_window_open_terminal = {
    _name = "expedition_record_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = ExpeditionRecord:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(expedition_record_window_open_terminal)
state_machine.init()

function ExpeditionRecord:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_vs_fighting_arrow_down = nil
    self._Image_vs_fighting_arrow_up = nil

    local function init_expedition_record_terminal()
        local expedition_record_show_terminal = {
            _name = "expedition_record_show",
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

        local expedition_record_hide_terminal = {
            _name = "expedition_record_hide",
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
        local expedition_record_update_list_info_terminal = {
            _name = "expedition_record_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(expedition_record_show_terminal)
        state_machine.add(expedition_record_hide_terminal)
        state_machine.add(expedition_record_update_list_info_terminal)
        state_machine.init()
    end
    init_expedition_record_terminal()
end

function ExpeditionRecord:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function ExpeditionRecord:onUpdateDraw()
    local root = self.roots[1]
    local ListView_expedition_record = ccui.Helper:seekWidgetByName(root, "ListView_expedition_record")
    self._list_view = ListView_expedition_record
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    self._Image_vs_fighting_arrow_down:setVisible(false)
    self._Image_vs_fighting_arrow_up:setVisible(false)
    
    local grand_type = battle_enum._fight_type._fight_type_201
    if _ED.city_resource_battle_report ~= nil and _ED.city_resource_battle_report[grand_type] ~= nil then
        local result = {}
        for k, v in pairs(_ED.city_resource_battle_report[grand_type]) do
            table.insert(result, v)
        end
        function sortLoad( a, b )
            return zstring.tonumber(a.time) > zstring.tonumber(b.time)
        end
        table.sort(result, sortLoad)
        local max_record_count = dms.int(dms["expedition_config"], 2, expedition_config.param)
        for i = 1, max_record_count do
            if result[i] ~= nil then
                local cell = state_machine.excute("expedition_record_create_cell", 0, {result[i], i})
                self._list_view:addChild(cell)
            end
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function ExpeditionRecord:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_vs_fighting_arrow_down:setVisible(true)
        else
            self._Image_vs_fighting_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_vs_fighting_arrow_up:setVisible(true)
        else
            self._Image_vs_fighting_arrow_up:setVisible(false)
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

function ExpeditionRecord:onInit()
    local csbItem = csb.createNode(config_csb.campaign.expedition_record)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_vs_fighting_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_expedition_record_arrow_down")
    self._Image_vs_fighting_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_expedition_record_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_vs_fighting_arrow_down:stopAllActions()
    self._Image_vs_fighting_arrow_up:stopAllActions()
    playActions(self._Image_vs_fighting_arrow_down)
    playActions(self._Image_vs_fighting_arrow_up)
    self._Image_vs_fighting_arrow_down:setVisible(false)
    self._Image_vs_fighting_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function ExpeditionRecord:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function ExpeditionRecord:onExit()
    state_machine.remove("expedition_record_show")
    state_machine.remove("expedition_record_hide")
    state_machine.remove("expedition_record_update_list_info")
end