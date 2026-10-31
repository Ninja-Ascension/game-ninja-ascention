-- ------------------------------------------------------------------------------------------------------------
--  说明：装备强化和改造
-- ------------------------------------------------------------------------------------------------------------
EquipmentStrengthenReform = class("EquipmentStrengthenReformClass", Window)

--打开界面
local equipment_strengthen_reform_window_open_terminal = {
    _name = "equipment_strengthen_reform_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentStrengthenReformClass") == nil then
            local page_index = params._datas.page_index
            local equipment_id = params._datas.equipment_id
            local equipment_cell = params._datas.equipment_cell
            if fwin:find("EquipmentStrengthenReformClass") == nil then
                local _win = EquipmentStrengthenReform:new()
                _win:init(page_index, equipment_id, equipment_cell)
                fwin:open(_win,fwin._ui)

                state_machine.excute("equipment_parts_infor_window_close", 0, "")
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_strengthen_reform_window_close_terminal = {
    _name = "equipment_strengthen_reform_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentStrengthenReformClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_strengthen_reform_window_open_terminal)
state_machine.add(equipment_strengthen_reform_window_close_terminal)
state_machine.init()

function EquipmentStrengthenReform:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 1：强化，2：改造
    self._last_page_index = 0

    self._pages = {}

    self._need_update = false        -- 是否有强化过装备需要刷新

     -- Initialize alert_home state machine.
    local function init_equipment_strengthen_reform_terminal()
        --显示所有
        local equipment_strengthen_reform_window_show_terminal = {
            _name = "equipment_strengthen_reform_window_show",
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
        local equipment_strengthen_reform_window_hide_terminal = {
            _name = "equipment_strengthen_reform_window_hide",
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
        local equipment_strengthen_reform_change_page_terminal = {
            _name = "equipment_strengthen_reform_change_page",
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

        local equipment_strengthen_reform_need_update_terminal = {
            _name = "equipment_strengthen_reform_need_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._need_update = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭
        local equipment_strengthen_reform_on_close_terminal = {
            _name = "equipment_strengthen_reform_on_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._need_update == true then
                    if tonumber(_ED.user_equiment[""..instance._equipment_id].is_equiped) == 1 then
                        state_machine.excute("props_icon_update_draw", 0, instance._equipment_cell)
                        state_machine.excute("equipment_parts_tab_update_draw_attribute", 0, "")
                    else
                        state_machine.excute("equipment_packs_tab_fitting_update_draw", 0, "")
                    end
                end
                state_machine.excute("main_window_update_resource", 0, "")
                state_machine.excute("equipment_packs_tab_data_update_draw", 0, "")
                state_machine.excute("equipment_strengthen_reform_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_strengthen_reform_window_show_terminal)
        state_machine.add(equipment_strengthen_reform_window_hide_terminal)  
        state_machine.add(equipment_strengthen_reform_change_page_terminal)  
        state_machine.add(equipment_strengthen_reform_need_update_terminal)  
        state_machine.add(equipment_strengthen_reform_on_close_terminal)  
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_equipment_strengthen_reform_terminal()
end

--显示
function EquipmentStrengthenReform:onShow()
   self:setVisible(true)
end

--隐藏
function EquipmentStrengthenReform:onHide()
   self:setVisible(false)
end

--初始化界面
function EquipmentStrengthenReform:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_strengthen_reform)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment_close"), nil, 
    {
        terminal_name = "equipment_strengthen_reform_on_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment_strengthen"), nil, 
    {
        terminal_name = "equipment_strengthen_reform_change_page", 
        terminal_state = 0, 
        page_index = 1,
    }, nil, 1)   

    -- 改造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment_reform"), nil, 
    {
        terminal_name = "equipment_strengthen_reform_change_page", 
        terminal_state = 0, 
        page_index = 2,
    }, nil, 1)   

    self:onUpdateDraw()
end

-- 显示信息
function EquipmentStrengthenReform:onUpdateDraw()
    local root = self.roots[1]

    local Panel_strengthen_reform_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_reform_tab_box")
    local Button_equipment_strengthen = ccui.Helper:seekWidgetByName(root, "Button_equipment_strengthen")
    local Button_equipment_reform = ccui.Helper:seekWidgetByName(root, "Button_equipment_reform")

    for i, page in pairs(self._pages) do 
        page:setVisible(false)
    end   

    if self._last_page_index == 1 then
        Button_equipment_strengthen:setHighlighted(true)
        Button_equipment_strengthen:setTouchEnabled(false)
        Button_equipment_reform:setHighlighted(false)
        Button_equipment_reform:setTouchEnabled(true)
        if self._pages["1"] == nil then
            self._pages["1"] = state_machine.excute("equipment_strengthen_tab_window_open", 0, {Panel_strengthen_reform_tab_box, self._equipment_id})
        end
        self._pages["1"]:setVisible(true)
    else
        Button_equipment_strengthen:setHighlighted(false)
        Button_equipment_strengthen:setTouchEnabled(true)
        Button_equipment_reform:setHighlighted(true)
        Button_equipment_reform:setTouchEnabled(false)

        if self._pages["2"] == nil then
            self._pages["2"] = state_machine.excute("equipment_reform_tab_window_open", 0, {Panel_strengthen_reform_tab_box, self._equipment_id})
        end
        self._pages["2"]:setVisible(true)
    end


end

--初始化
function EquipmentStrengthenReform:init(page_index, equipment_id, equipment_cell)
    self._last_page_index = page_index
    self._equipment_id = equipment_id
    self._equipment_cell = equipment_cell
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function EquipmentStrengthenReform:onExit()
    state_machine.remove("equipment_strengthen_reform_window_show")
    state_machine.remove("equipment_strengthen_reform_window_hide")
    state_machine.remove("equipment_strengthen_reform_change_page")
    state_machine.remove("equipment_strengthen_reform_need_update")
    state_machine.remove("equipment_strengthen_reform_on_close")
end