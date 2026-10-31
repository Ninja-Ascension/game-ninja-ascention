-- ------------------------------------------------------------------------------------------------------------
--  说明：配件
-- ------------------------------------------------------------------------------------------------------------
Equipment = class("EquipmentClass", Window)

--打开界面
local equipment_window_open_terminal = {
    _name = "equipment_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if funOpenDrawTip(156) == true then
            return
        end
        if fwin:find("EquipmentClass") == nil then
            local _win = Equipment:new()
            _win:init(page_index)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_window_close_terminal = {
    _name = "equipment_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentClass"))
        state_machine.excute("player_fight_update_draw", 0, "")
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_window_open_terminal)
state_machine.add(equipment_window_close_terminal)
state_machine.init()

function Equipment:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 1：配件，2：仓库
    self._last_page_index = 1

    self._pages = {}

    app.load("client.red_alert_time.equipment.EquipmentPacksTab")
    app.load("client.red_alert_time.equipment.EquipmentPartsTab")
    app.load("client.red_alert_time.equipment.EquipmentPacksTabFitting")
    app.load("client.red_alert_time.equipment.EquipmentPacksTabChip")
    app.load("client.red_alert_time.equipment.EquipmentPacksTabData")
    app.load("client.red_alert_time.equipment.EquipmentPacksTabExchange")
    app.load("client.red_alert_time.equipment.EquipmentStrengthenReform")
    app.load("client.red_alert_time.equipment.EquipmentStrengthenTab")
    app.load("client.red_alert_time.equipment.EquipmentReformTab")
    app.load("client.red_alert_time.equipment.EquipmentPartsInfor")
    app.load("client.red_alert_time.equipment.EquipmentPartsDecompose")
    app.load("client.red_alert_time.equipment.EquipmentPartsBatchDecompose")
    app.load("client.red_alert_time.equipment.EquipmentChangeInfor")

    app.load("client.red_alert_time.equipment.EquipmentPacksTabListviewLow")
    app.load("client.red_alert_time.equipment.EquipmentPacksTabListviewMiddle")
    app.load("client.red_alert_time.equipment.EquipmentPacksTabListviewHigh")
    app.load("client.red_alert_time.equipment.EquipmentPartsFragmentInfor")
    app.load("client.red_alert_time.equipment.EquipmentStrengthenResult")
    
     -- Initialize alert_home state machine.
    local function init_equipment_terminal()
        --显示所有
        local equipment_window_show_terminal = {
            _name = "equipment_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local equipment_window_hide_terminal = {
            _name = "equipment_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 切换页面
        local equipment_change_page_terminal = {
            _name = "equipment_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._last_page_index = params._datas.page_index
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_window_show_terminal)
        state_machine.add(equipment_window_hide_terminal)  
        state_machine.add(equipment_change_page_terminal)  
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_equipment_terminal()
end

--显示
function Equipment:onShow()
   self:setVisible(true)
end

--隐藏
function Equipment:onHide()
   self:setVisible(false)
end

--初始化界面
function Equipment:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment_close"), nil, 
    {
        terminal_name = "equipment_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 配件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment_parts"), nil, 
    {
        terminal_name = "equipment_change_page", 
        terminal_state = 0, 
        page_index = 1,
    }, nil, 1)   
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment_parts",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_equipment_parts"),
    _invoke = nil,
    _interval = 0.2,})

    -- 仓库
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment_packs"), nil, 
    {
        terminal_name = "equipment_change_page", 
        terminal_state = 0, 
        page_index = 2,
    }, nil, 1)   
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment_packs",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_equipment_packs"),
    _invoke = nil,
    _interval = 0.2,})

    self:onUpdateDraw()
end

-- 显示信息
function Equipment:onUpdateDraw()
    local root = self.roots[1]

    local Panel_equipment_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_equipment_tab_box")
    local Button_equipment_parts = ccui.Helper:seekWidgetByName(root, "Button_equipment_parts")
    local Button_equipment_packs = ccui.Helper:seekWidgetByName(root, "Button_equipment_packs")

    for i, page in pairs(self._pages) do 
        page:setVisible(false)
    end   

    if self._last_page_index == 1 then
        Button_equipment_parts:setHighlighted(true)
        Button_equipment_parts:setTouchEnabled(false)
        Button_equipment_packs:setHighlighted(false)
        Button_equipment_packs:setTouchEnabled(true)
        if self._pages["1"] == nil then
            self._pages["1"] = state_machine.excute("equipment_parts_tab_window_open", 0, {Panel_equipment_tab_box})
        end
        self._pages["1"]:setVisible(true)
    else
        Button_equipment_parts:setHighlighted(false)
        Button_equipment_parts:setTouchEnabled(true)
        Button_equipment_packs:setHighlighted(true)
        Button_equipment_packs:setTouchEnabled(false)

        if self._pages["2"] == nil then
            self._pages["2"] = state_machine.excute("equipment_packs_tab_window_open", 0, {Panel_equipment_tab_box})
        end
        self._pages["2"]:setVisible(true)
    end


end

--初始化
function Equipment:init()
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function Equipment:onExit()
    state_machine.remove("equipment_window_show")
    state_machine.remove("equipment_window_hide")
    state_machine.remove("equipment_change_page")
end