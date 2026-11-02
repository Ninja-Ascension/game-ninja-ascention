-- ------------------------------------------------------------------------------------------------------------
--  说明：军团切磋战报
-- ------------------------------------------------------------------------------------------------------------
LegionPKRecord = class("LegionPKRecordClass", Window)

--打开界面
local legion_pk_record_open_terminal = {
    _name = "legion_pk_record_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionPKRecord:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_pk_record_open_terminal)
state_machine.init()

function LegionPKRecord:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._choose_page = 0

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_vs_fighting_arrow_down = nil
    self._Image_vs_fighting_arrow_up = nil

    local function init_legion_pk_record_terminal()
        local legion_pk_record_show_terminal = {
            _name = "legion_pk_record_show",
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

        local legion_pk_record_hide_terminal = {
            _name = "legion_pk_record_hide",
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

        local legion_pk_record_change_page_terminal = {
            _name = "legion_pk_record_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changePage(params._datas.page)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_pk_record_update_list_info_terminal = {
            _name = "legion_pk_record_update_list_info",
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

        state_machine.add(legion_pk_record_show_terminal)
        state_machine.add(legion_pk_record_hide_terminal)
        state_machine.add(legion_pk_record_change_page_terminal)
        state_machine.add(legion_pk_record_update_list_info_terminal)
        state_machine.init()
    end
    init_legion_pk_record_terminal()
end

function LegionPKRecord:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function LegionPKRecord:changePage( page )
    local root = self.roots[1]
    local Button_legion_fighting = ccui.Helper:seekWidgetByName(root, "Button_legion_fighting")
    local Button_personal_fighting = ccui.Helper:seekWidgetByName(root, "Button_personal_fighting")
    Button_legion_fighting:setHighlighted(false)
    Button_personal_fighting:setHighlighted(false)
    if page == 1 then
        Button_legion_fighting:setHighlighted(true)
    else
        Button_personal_fighting:setHighlighted(true)
    end
    if self._choose_page == page then
        return
    end
    self._choose_page = page
    self:onUpdateDraw()
end

function LegionPKRecord:onUpdateDraw()
    local root = self.roots[1]
    local Text_not_vs_fighting = ccui.Helper:seekWidgetByName(root, "Text_not_vs_fighting")
    local ListView_vs_fighting = ccui.Helper:seekWidgetByName(root, "ListView_vs_fighting")
    self._list_view = ListView_vs_fighting
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    Text_not_vs_fighting:setVisible(true)

    self._Image_vs_fighting_arrow_down:setVisible(false)
    self._Image_vs_fighting_arrow_up:setVisible(false)

    if _ED.city_resource_battle_report ~= nil then
        if self._choose_page == 1 and _ED.city_resource_battle_report[10001] ~= nil then
            Text_not_vs_fighting:setVisible(false)
            function sortLoad( a, b )
                return zstring.tonumber(a.time) > zstring.tonumber(b.time)
            end
            table.sort(_ED.city_resource_battle_report[10001], sortLoad)
            for i, v in pairs(_ED.city_resource_battle_report[10001]) do
                local cell = state_machine.excute("legion_pk_record_create_cell", 0, {v, i})
                self._list_view:addChild(cell)
            end
        elseif self._choose_page == 2 and _ED.city_resource_battle_report[24] ~= nil then
            Text_not_vs_fighting:setVisible(false)
            function sortLoad( a, b )
                return zstring.tonumber(a.time) > zstring.tonumber(b.time)
            end
            table.sort(_ED.city_resource_battle_report[24], sortLoad)
            for i, v in pairs(_ED.city_resource_battle_report[24]) do
                local cell = state_machine.excute("legion_pk_record_create_cell", 0, {v, i})
                self._list_view:addChild(cell)
            end
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function LegionPKRecord:onUpdate(dt)
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

function LegionPKRecord:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_member_vs_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_fighting"), nil, 
    {
        terminal_name = "legion_pk_record_change_page", 
        terminal_state = 0, 
        touch_black = true,
        page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_personal_fighting"), nil, 
    {
        terminal_name = "legion_pk_record_change_page", 
        terminal_state = 0, 
        touch_black = true,
        page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vs_troops_infor"), nil, 
    {
        terminal_name = "legion_member_vs_help_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_vs_fighting_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_vs_fighting_arrow_down")
    self._Image_vs_fighting_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_vs_fighting_arrow_up")
    
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

    self:changePage(1)
end

function LegionPKRecord:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionPKRecord:onExit()
    state_machine.remove("legion_pk_record_show")
    state_machine.remove("legion_pk_record_hide")
    state_machine.remove("legion_pk_record_change_page")
    state_machine.remove("legion_pk_record_update_list_info")
end