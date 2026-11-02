--------------------------------------------------------------------------------------------------------------
--  配件车间配件
--------------------------------------------------------------------------------------------------------------
EquipmentPartsTab = class("EquipmentPartsTabClass", Window)

local equipment_parts_tab_window_open_terminal = {
    _name = "equipment_parts_tab_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentPartsTab:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_parts_tab_window_open_terminal)
state_machine.init()

function EquipmentPartsTab:ctor()
    self.super:ctor()
    self.roots = {}

    self.pageIndex = 1

    self._cell_pages = {}

    app.load("client.red_alert_time.cells.equipment.equipment_parts_page_cell")
    app.load("client.red_alert_time.cells.equipment.equipment_parts_icon_cell")
    -- Initialize equipment_parts_tab state machine.
    local function init_equipment_parts_tab_terminal()
        --翻页
        local equipment_parts_tab_scoll_pageindex_terminal = {
            _name = "equipment_parts_tab_scoll_pageindex",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local to_turn_page = params._datas.to_turn_page + instance.pageIndex - 1
                instance:scrollToPageIndex(to_turn_page)
                instance:updateAttr()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --刷新
        local equipment_parts_tab_update_draw_cell_terminal = {
            _name = "equipment_parts_tab_update_draw_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local equipment_type = params
                state_machine.excute("equipment_parts_page_cell_update_draw", 0, instance._cell_pages[""..equipment_type])
                instance:updateAttr()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --刷新加成属性
        local equipment_parts_tab_update_draw_attribute_terminal = {
            _name = "equipment_parts_tab_update_draw_attribute",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateAttr()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local equipment_parts_tab_supply_terminal = {
            _name = "equipment_parts_tab_supply",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("short_cut_go_to_other_window", 0, {26})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local equipment_parts_tab_scroll_to_page_terminal = {
            _name = "equipment_parts_tab_scroll_to_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local to_turn_page = params._datas.page - 1
                instance:scrollToPageIndex(to_turn_page)
                instance:updateAttr()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   


        state_machine.add(equipment_parts_tab_scoll_pageindex_terminal)
        state_machine.add(equipment_parts_tab_update_draw_cell_terminal)
        state_machine.add(equipment_parts_tab_update_draw_attribute_terminal)
        state_machine.add(equipment_parts_tab_supply_terminal)
        state_machine.add(equipment_parts_tab_scroll_to_page_terminal)
        state_machine.init()
    end
    
    -- call func equipment_parts_tab create state machine.
    init_equipment_parts_tab_terminal()

end

function EquipmentPartsTab:updateDraw()    
    local root = self.roots[1]

    local PageView_equip = ccui.Helper:seekWidgetByName(root, "PageView_equip")
    PageView_equip:removeAllChildren(true)
    PageView_equip._items = {}
    for i = 1, 4 do
        local cell = state_machine.excute("equipment_parts_page_cell_create", 0, {i})
        self._cell_pages[""..i] = cell
        PageView_equip:addPage(cell)
        table.insert(PageView_equip._items, cell)
    end

    self:updateAttr()
end

-- 刷新加成属性
function EquipmentPartsTab:updateAttr()
    local root = self.roots[1]
    -- 显示加成属性
    local wear_equips = {}
    for k, v in pairs(_ED.user_equiment) do
        if tonumber(v.is_equiped) == 1 
            and tonumber(v.influence_type) == self.pageIndex 
            and v.armor_type == 0
            then
            table.insert(wear_equips, v)
        end
    end

    local add_attrs = {}        -- 加成属性
    add_attrs["4"] = 0
    add_attrs["5"] = 0
    add_attrs["44"] = 0
    add_attrs["45"] = 0
    local total_strength = 0    -- 总强度
    for k, v in pairs(wear_equips) do
        total_strength = total_strength + tonumber(v.strength)
        local attr_info = zstring.split(v.attr, "|")
        for i, info_str in pairs(attr_info) do
            local info = zstring.split(info_str, ",")
            local attr_id = tonumber(info[1])
            if add_attrs[""..attr_id] == nil then
                add_attrs[""..attr_id] = 0
            end
            add_attrs[""..attr_id] = add_attrs[""..attr_id] + tonumber(info[2])
        end
    end

    -- 血量加成
    local Text_equip_output_n = ccui.Helper:seekWidgetByName(root, "Text_equip_output_n")
    Text_equip_output_n:setString(add_attrs["4"].."%")
    -- 攻击加成
    local Text_equip_attack_n = ccui.Helper:seekWidgetByName(root, "Text_equip_attack_n")
    Text_equip_attack_n:setString(add_attrs["5"].."%")
    -- 防护加成
    local Text_equip_protect_n = ccui.Helper:seekWidgetByName(root, "Text_equip_protect_n")
    Text_equip_protect_n:setString(add_attrs["44"])
    -- 穿透加成
    local Text_equip_pass_n = ccui.Helper:seekWidgetByName(root, "Text_equip_pass_n")
    Text_equip_pass_n:setString(add_attrs["45"])

    -- 总强度
    local Text_equip_strength_n = ccui.Helper:seekWidgetByName(root, "Text_equip_strength_n")
    Text_equip_strength_n:setString(total_strength)
end

--初始化页面选择按钮
function EquipmentPartsTab:initPageViewScrollTouchListen()
    local root = self.roots[1]
    local PageView_equip = ccui.Helper:seekWidgetByName(root, "PageView_equip")
    if __lua_project_id == __lua_project_pacific_rim then
        PageView_equip:setCustomScrollThreshold(PageView_equip:getContentSize().width / 5)
    end
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local nowPageIndex = sender:getCurPageIndex()
            if nowPageIndex == 0 then
                self.pageIndex = 1 
            elseif nowPageIndex == 1 then
                self.pageIndex = 2 
            elseif nowPageIndex == 2 then
                self.pageIndex = 3 
            elseif nowPageIndex == 3 then
                self.pageIndex = 4 
            end
            self:turnButtonCheckShow()
            self:updateAttr()
            if self._cell_pages[""..(self.pageIndex)] ~= nil then
                self._cell_pages[""..(self.pageIndex)]:reload()
            end
            if self._cell_pages[""..(self.pageIndex+1)] ~= nil then
                self._cell_pages[""..(self.pageIndex+1)]:reload()
            end
        end
    end 
    PageView_equip:addEventListener(pageViewEvent)
end

--翻页
function EquipmentPartsTab:scrollToPageIndex(pageIndex)
    local root = self.roots[1]
    local PageView_equip = ccui.Helper:seekWidgetByName(root,"PageView_equip")
    PageView_equip:scrollToPage(pageIndex)
end

function EquipmentPartsTab:turnButtonCheckShow()
    local root = self.roots[1]
    local Button_equim_page_left = ccui.Helper:seekWidgetByName(root,"Button_equim_page_left")
    local Button_equim_page_right = ccui.Helper:seekWidgetByName(root,"Button_equim_page_right")
    if self.pageIndex == 1 then
        Button_equim_page_left:setVisible(false)
    else
        Button_equim_page_left:setVisible(true)
    end

    if self.pageIndex == 4 then
        Button_equim_page_right:setVisible(false)
    else
        Button_equim_page_right:setVisible(true)
    end

    for i = 1, 4 do
        local Image_page_hook = ccui.Helper:seekWidgetByName(root, "Image_page_hook_"..i)
        if i == self.pageIndex then
            Image_page_hook:setVisible(true)
        else
            Image_page_hook:setVisible(false)
        end
    end

    for i = 1, 4 do
        local Button_type = ccui.Helper:seekWidgetByName(root,"Button_type_"..i)
        if Button_type ~= nil then
            if i == self.pageIndex then
                Button_type:setHighlighted(true)
            else
                Button_type:setHighlighted(false)
            end
        end
    end
end

function EquipmentPartsTab:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_parts_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 左翻页
    local Button_equim_page_left = ccui.Helper:seekWidgetByName(root,"Button_equim_page_left")
    fwin:addTouchEventListener(Button_equim_page_left, nil, 
    {
        terminal_name = "equipment_parts_tab_scoll_pageindex", 
        terminal_state = 0, 
        touch_scale = true,
        to_turn_page = -1,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 右翻页
    local Button_equim_page_right = ccui.Helper:seekWidgetByName(root,"Button_equim_page_right")
    fwin:addTouchEventListener(Button_equim_page_right, nil, 
    {
        terminal_name = "equipment_parts_tab_scoll_pageindex", 
        terminal_state = 0, 
        touch_scale = true,
        to_turn_page = 1,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 配件补给
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_parts_supply"), nil, 
    {
        terminal_name = "equipment_parts_tab_supply", 
        terminal_state = 0, 
        touch_scale = true,
        to_turn_page = 1,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    for i = 1, 4 do
        local Button_type = ccui.Helper:seekWidgetByName(root,"Button_type_"..i)
        if Button_type ~= nil then 
            fwin:addTouchEventListener(Button_type, nil, 
            {
                terminal_name = "equipment_parts_tab_scroll_to_page", 
                terminal_state = 0, 
                page = i,
            }, nil, 1)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment",
            _widget = Button_type,
            _invoke = nil,
            _index = i,
            _interval = 0.2,}) 
        end 
    end

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    Button_equim_page_right:stopAllActions()
    Button_equim_page_left:stopAllActions()
    playActions(Button_equim_page_right)
    playActions(Button_equim_page_left)

    self.pageIndex = 1

    self:updateDraw()
    self:initPageViewScrollTouchListen()
    self:turnButtonCheckShow()
end

function EquipmentPartsTab:onEnterTransitionFinish()
    
end

function EquipmentPartsTab:init(params)
    local rootWindow = params[1]

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentPartsTab:onExit()
    state_machine.remove("equipment_parts_tab_scoll_pageindex")
    state_machine.remove("equipment_parts_tab_update_draw_cell")
    state_machine.remove("equipment_parts_tab_update_draw_attribute")
    state_machine.remove("equipment_parts_tab_supply")
    state_machine.remove("equipment_parts_tab_scroll_to_page")
end