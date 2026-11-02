--------------------------------------------------------------------------------------------------------------
--  说明：装甲车间
--------------------------------------------------------------------------------------------------------------
Armor = class("ArmorClass", Window)

--打开界面
local armor_window_open_terminal = {
    _name = "armor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(204) == true then
            return
        end
        if nil == fwin:find("ArmorClass") then
          fwin:open(Armor:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local armor_window_close_terminal = {
    _name = "armor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(armor_window_open_terminal)
state_machine.add(armor_window_close_terminal)
state_machine.init()

function Armor:ctor()
    self.super:ctor()
    self.roots = {}

    self._choosePage = 0
    self._current_page = 0

    self._production_panel = nil
    self._equipment_panel = nil
    self._pack_panel = nil

    app.load("client.red_alert_time.armor.ArmorProduction")
    app.load("client.red_alert_time.armor.ArmorEquipment")
    app.load("client.red_alert_time.armor.ArmorPack")

    app.load("client.red_alert_time.armor.ArmorInfor")
    app.load("client.red_alert_time.armor.ArmorSuitEffectLook")
    app.load("client.red_alert_time.armor.ArmorUp")
    app.load("client.red_alert_time.armor.ArmorBatchChoose")
    app.load("client.red_alert_time.armor.ArmorInstall")
    app.load("client.red_alert_time.armor.ArmorSell")
    app.load("client.red_alert_time.armor.ArmorProductionOnce")
    app.load("client.red_alert_time.armor.ArmorProductionTen")

    app.load("client.red_alert_time.cells.armor.armor_packs_cell")
    app.load("client.red_alert_time.cells.armor.armor_up_cell")
    app.load("client.red_alert_time.cells.armor.armor_production_show_cell")
    app.load("client.red_alert_time.cells.armor.armor_formation_cell")
    app.load("client.red_alert_time.cells.armor.armor_suit_icon_cell")
    app.load("client.red_alert_time.cells.armor.armor_install_cell")

    local function init_armor_terminal()
        local armor_change_page_terminal = {
            _name = "armor_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas.page))
                if instance._current_page == 3 then
                    _ED.push_user_have_armor_count = 0
                    _ED.push_user_armor_packs_count = 0
                    state_machine.excute("notification_center_update", 0, "push_notification_armor_pack")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_change_page_terminal)    
        state_machine.init()
    end
    init_armor_terminal()
end

function Armor:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_armor_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_armor_tab_box")
    local Button_armor_production = ccui.Helper:seekWidgetByName(root, "Button_armor_production")
    local Button_armor = ccui.Helper:seekWidgetByName(root, "Button_armor")
    local Button_armor_pack = ccui.Helper:seekWidgetByName(root, "Button_armor_pack")
    if page == self._current_page then
        if page == 1 then
            Button_armor_production:setHighlighted(true)
        elseif page == 2 then
            Button_armor:setHighlighted(true)
        else
            Button_armor_pack:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_armor_production:setHighlighted(false)
    Button_armor:setHighlighted(false)
    Button_armor_pack:setHighlighted(false)
    state_machine.excute("armor_production_hide", 0, nil)
    state_machine.excute("armor_equipment_hide", 0, nil)
    state_machine.excute("armor_pack_hide", 0, nil)
    if page == 1 then
        Button_armor_production:setHighlighted(true)
        if self._production_panel == nil then
            self._production_panel = state_machine.excute("armor_production_window_open", 0, {Panel_armor_tab_box})
        else
            state_machine.excute("armor_production_show", 0, nil)
        end
    elseif page == 2 then
        Button_armor:setHighlighted(true)
        if self._equipment_panel == nil then
            self._equipment_panel = state_machine.excute("armor_equipment_window_open", 0, {Panel_armor_tab_box})
        else
            state_machine.excute("armor_equipment_show", 0, nil)
        end
    else
        Button_armor_pack:setHighlighted(true)
        if self._pack_panel == nil then
            self._pack_panel = state_machine.excute("armor_pack_window_open", 0, {Panel_armor_tab_box})
        else
            state_machine.excute("armor_pack_show", 0, nil)
        end
    end
end

function Armor:onInit(params)
    local csbItem = csb.createNode(config_csb.armor.armor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_close"), nil, 
    {
        terminal_name = "armor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_production"), nil, 
    {
        terminal_name = "armor_change_page", 
        terminal_state = 0, 
        page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_armor_production",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_armor_production"),
        _invoke = nil,
        _production_type = 0,
        _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor"), nil, 
    {
        terminal_name = "armor_change_page", 
        terminal_state = 0, 
        page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_armor_equipment",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_armor"),
        _invoke = nil,
        _formation_type = self._index,
        _interval = 0.2,})
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_pack"), nil, 
    {
        terminal_name = "armor_change_page", 
        terminal_state = 0, 
        page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_armor_pack",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_armor_pack"),
        _invoke = nil,
        _formation_type = self._index,
        _interval = 0.2,})
    
    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function Armor:onEnterTransitionFinish()

end

function Armor:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
    return self
end

function Armor:onExit()
    state_machine.remove("armor_change_page")
end