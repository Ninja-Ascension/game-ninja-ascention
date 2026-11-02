--------------------------------------------------------------------------------------------------------------
--  背包页
--------------------------------------------------------------------------------------------------------------
PropsShopPacksPacksTab = class("PropsShopPacksPacksTabClass", Window)

local props_shop_packs_packs_tab_window_open_terminal = {
    _name = "props_shop_packs_packs_tab_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = PropsShopPacksPacksTab:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(props_shop_packs_packs_tab_window_open_terminal)
state_machine.init()

function PropsShopPacksPacksTab:ctor()
    self.super:ctor()
    self.roots = {}

    -- 
    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_packs_arrow_down = nil
    self._Image_packs_arrow_up = nil

    self._last_page_index = 1

    app.load("client.red_alert_time.cells.props.props_shop_packs_packs_cell")

    -- Initialize props_shop_packs_packs_tab state machine.
    local function init_props_shop_packs_packs_tab_terminal()
        -- 切换页面
        local props_shop_packs_packs_tab_change_page_terminal = {
            _name = "props_shop_packs_packs_tab_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params._datas ~= nil and params._datas.page_index ~= nil then
                    instance._last_page_index = params._datas.page_index
                end
                instance:jumpToTop()
                state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local props_shop_packs_packs_tab_update_draw_terminal = {
            _name = "props_shop_packs_packs_tab_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local posY = instance._list_view_poy
                instance:updateInfos()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)  
                instance._list_view_poy = posY + 1

                instance:pushUpdateDraw()
                if instance._last_page_index == 1 then
                    _ED.push_user_resources_count = 0
                elseif instance._last_page_index == 2 then
                    _ED.push_user_fight_count = 0
                elseif instance._last_page_index == 3 then
                    _ED.push_user_treasure_box_count = 0
                else
                    _ED.push_user_other_count = 0
                end
                state_machine.excute("notification_center_update", 0, "push_notification_packs")
                state_machine.excute("notification_center_update", 0, "push_notification_pack_resources")
                state_machine.excute("notification_center_update", 0, "push_notification_pack_fight")
                state_machine.excute("notification_center_update", 0, "push_notification_pack_treasure_box")
                state_machine.excute("notification_center_update", 0, "push_notification_pack_treasure_other")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(props_shop_packs_packs_tab_change_page_terminal)
        state_machine.add(props_shop_packs_packs_tab_update_draw_terminal)
        state_machine.init()
    end
    
    init_props_shop_packs_packs_tab_terminal()
end

function PropsShopPacksPacksTab:jumpToTop()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end
 

function PropsShopPacksPacksTab:updateInfos( ... )
    local root = self.roots[1]
    for i = 1, 4 do
        local Button_packs = ccui.Helper:seekWidgetByName(root, "Button_packs_"..i)
        if i == self._last_page_index then
            Button_packs:setHighlighted(true)
            Button_packs:setTouchEnabled(false)
        else
            Button_packs:setHighlighted(false)
            Button_packs:setTouchEnabled(true)
        end
    end
    local Text_packs_not_propmt = ccui.Helper:seekWidgetByName(root, "Text_packs_not_propmt")
    Text_packs_not_propmt:setVisible(false)
    -- self._list_view:jumpToTop()

    self._Image_packs_arrow_down:setVisible(false)
    self._Image_packs_arrow_up:setVisible(false)

    local pack_type = self._last_page_index + 15         -- 仓库分页类型
    local result = {}
    for k, v in pairs(_ED.user_prop) do
        local prop_id = tonumber(v.user_prop_template)
        if pack_type == v.storage_page_index then
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

    if #result <= 0 then
        Text_packs_not_propmt:setVisible(true)
        self._list_view:setVisible(false)
    else
        self._list_view:setVisible(true)

        local items = self._list_view:getItems()
        for k,v in pairs(items) do
            state_machine.excute("props_shop_packs_packs_cell_update_info", 0, {cell = v, index = k, info = result[k], pack_type = self._last_page_index})
        end

        if #items > #result then
            local index = 0
            for i=#result + 1, #items do
                self._list_view:removeItem(#items - index - 1)
                index = index + 1
            end
        elseif #items < #result then
            for i=#items + 1, #result do
                local cell = state_machine.excute("props_shop_packs_packs_cell_create", 0, {i, result[i], self._last_page_index})
                self._list_view:addChild(cell)
            end
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function PropsShopPacksPacksTab:updateDraw()
    local root = self.roots[1]

    for i = 1, 4 do
        local Button_packs = ccui.Helper:seekWidgetByName(root, "Button_packs_"..i)
        if i == self._last_page_index then
            Button_packs:setHighlighted(true)
            Button_packs:setTouchEnabled(false)
        else
            Button_packs:setHighlighted(false)
            Button_packs:setTouchEnabled(true)
        end
    end
	local Text_packs_not_propmt = ccui.Helper:seekWidgetByName(root, "Text_packs_not_propmt")
	Text_packs_not_propmt:setVisible(false)
    local ListView_packs = ccui.Helper:seekWidgetByName(root, "ListView_packs")
    self._list_view = ListView_packs
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local pack_type = self._last_page_index + 15         -- 仓库分页类型
    local result = {}
    for k, v in pairs(_ED.user_prop) do
        local prop_id = tonumber(v.user_prop_template)
        if pack_type == v.storage_page_index then
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
    if #result <= 0 then
       Text_packs_not_propmt:setVisible(true)
    else
        for k, v in pairs(result) do
            local cell = state_machine.excute("props_shop_packs_packs_cell_create", 0, {k, v, self._last_page_index})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function PropsShopPacksPacksTab:pushUpdateDraw()
    if _ED.push_user_prop == nil then
        _ED.push_user_prop = {}
    end
    local pack_type = self._last_page_index + 15         -- 仓库分页类型
    for k, v in pairs(_ED.user_prop) do
        if pack_type == v.storage_page_index and nil ~= _ED.push_user_prop[""..pack_type] then
            _ED.push_user_prop[""..pack_type][""..v.user_prop_template] = zstring.tonumber(v.prop_number)
        end
    end
    local str = ""
    for i=16,19 do
        if _ED.push_user_prop[""..i] == nil then
            _ED.push_user_prop[""..i] = {}
        end
        local base_info = _ED.push_user_prop[""..i]
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
    cc.UserDefault:getInstance():setStringForKey(getKey("push_user_prop"), str)
end

function PropsShopPacksPacksTab:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_packs_arrow_down:setVisible(true)
        else
            self._Image_packs_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_packs_arrow_up:setVisible(true)
        else
            self._Image_packs_arrow_up:setVisible(false)
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

function PropsShopPacksPacksTab:onInit()
    local csbItem = csb.createNode(config_csb.props.props_shop_packs_packs_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    _ED.push_user_resources_count = 0

    for i = 1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_packs_"..i), nil, 
        {
            terminal_name = "props_shop_packs_packs_tab_change_page", 
            terminal_state = 0, 
            page_index = i,
        }, nil, 1) 
    end

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_pack_resources",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_packs_1"),
    _invoke = nil,
    _interval = 0.2,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_pack_fight",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_packs_2"),
    _invoke = nil,
    _interval = 0.2,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_pack_treasure_box",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_packs_3"),
    _invoke = nil,
    _interval = 0.2,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_pack_treasure_other",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_packs_4"),
    _invoke = nil,
    _interval = 0.2,})

    self._Image_packs_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_packs_arrow_down")
    self._Image_packs_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_packs_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_packs_arrow_down:stopAllActions()
    self._Image_packs_arrow_up:stopAllActions()
    playActions(self._Image_packs_arrow_down)
    playActions(self._Image_packs_arrow_up)
    self._Image_packs_arrow_down:setVisible(false)
    self._Image_packs_arrow_up:setVisible(false)


    self:updateDraw()
    self:pushUpdateDraw()
end

function PropsShopPacksPacksTab:onEnterTransitionFinish()
    
end

function PropsShopPacksPacksTab:init(params)
    local rootWindow = params[1]

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function PropsShopPacksPacksTab:onExit()
    state_machine.remove("props_shop_packs_packs_tab_change_page")
    state_machine.remove("props_shop_packs_packs_tab_update_draw")
end