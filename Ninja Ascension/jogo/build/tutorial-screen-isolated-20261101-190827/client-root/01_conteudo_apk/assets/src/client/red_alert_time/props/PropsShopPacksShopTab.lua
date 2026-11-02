--------------------------------------------------------------------------------------------------------------
--  商店页
--------------------------------------------------------------------------------------------------------------
PropsShopPacksShopTab = class("PropsShopPacksShopTabClass", Window)

local props_shop_packs_shop_tab_window_open_terminal = {
    _name = "props_shop_packs_shop_tab_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = PropsShopPacksShopTab:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(props_shop_packs_shop_tab_window_open_terminal)
state_machine.init()

function PropsShopPacksShopTab:ctor()
    self.super:ctor()
    self.roots = {}

    -- 
    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_shop_arrow_down = nil
    self._Image_shop_arrow_up = nil

    self._last_page_index = 1

    self._shop_page_datas = {}

    app.load("client.red_alert_time.cells.props.props_shop_packs_shop_cell")

    -- Initialize props_shop_packs_shop_tab state machine.
    local function init_props_shop_packs_shop_tab_terminal()
        -- 切换页面
        local props_shop_packs_shop_tab_change_page_terminal = {
            _name = "props_shop_packs_shop_tab_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._last_page_index = params._datas.page_index
                instance:updateInfos()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local props_shop_packs_shop_tab_update_terminal = {
            _name = "props_shop_packs_shop_tab_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateInfos()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_shop_packs_shop_tab_change_page_terminal)
        state_machine.add(props_shop_packs_shop_tab_update_terminal)
        state_machine.init()
    end
    init_props_shop_packs_shop_tab_terminal()
end

function PropsShopPacksShopTab:updateInfos( ... )
    local root = self.roots[1]
    for i = 1, 4 do
        local Button_packs = ccui.Helper:seekWidgetByName(root, "Button_shop_"..i)
        if i == self._last_page_index then
            Button_packs:setHighlighted(true)
            Button_packs:setTouchEnabled(false)
        else
            Button_packs:setHighlighted(false)
            Button_packs:setTouchEnabled(true)
        end
    end
    self._list_view:jumpToTop()
    self._Image_shop_arrow_down:setVisible(false)
    self._Image_shop_arrow_up:setVisible(false)

    local pack_type = self._last_page_index - 1
    local result = {}
    if self._shop_page_datas[""..pack_type] == nil then
        self._shop_page_datas[""..pack_type] = {}
        for k, v in pairs(_ED.base_avatar_shop_info) do
            if v.shop_type == pack_type then
                table.insert(result, v)
            end
        end

        local function sortFunction(a, b)
            return a.id < b.id
        end
        table.sort(result, sortFunction)
        self._shop_page_datas[""..pack_type] = result
    else
        result = self._shop_page_datas[""..pack_type]
    end

    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("props_shop_packs_shop_cell_update_info", 0, {cell = v, index = k, info = result[k], pack_type = self._last_page_index})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("props_shop_packs_shop_cell_create", 0, {i, result[i], self._last_page_index})
            self._list_view:addChild(cell)
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function PropsShopPacksShopTab:updateDraw()
    local root = self.roots[1]

    for i = 1, 4 do
        local Button_packs = ccui.Helper:seekWidgetByName(root, "Button_shop_"..i)
        if i == self._last_page_index then
            Button_packs:setHighlighted(true)
            Button_packs:setTouchEnabled(false)
        else
            Button_packs:setHighlighted(false)
            Button_packs:setTouchEnabled(true)
        end
    end

    local ListView_shop = ccui.Helper:seekWidgetByName(root, "ListView_shop")
    self._list_view = ListView_shop
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local pack_type = self._last_page_index - 1
    local result = {}
    if self._shop_page_datas[""..pack_type] == nil then
        self._shop_page_datas[""..pack_type] = {}
        for k, v in pairs(_ED.base_avatar_shop_info) do
            if v.shop_type == pack_type then
                table.insert(result, v)
            end
        end

        local function sortFunction(a, b)
            return a.id < b.id
        end
        table.sort(result, sortFunction)
        self._shop_page_datas[""..pack_type] = result
    else
        result = self._shop_page_datas[""..pack_type]
    end

    for k, v in pairs(result) do
        local cell = state_machine.excute("props_shop_packs_shop_cell_create", 0, {k, v, self._last_page_index})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function PropsShopPacksShopTab:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_shop_arrow_down:setVisible(true)
        else
            self._Image_shop_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_shop_arrow_up:setVisible(true)
        else
            self._Image_shop_arrow_up:setVisible(false)
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

function PropsShopPacksShopTab:onInit()
    local csbItem = csb.createNode(config_csb.props.props_shop_packs_shop_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    for i = 1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop_"..i), nil, 
        {
            terminal_name = "props_shop_packs_shop_tab_change_page", 
            terminal_state = 0, 
            page_index = i,
        }, nil, 1) 
    end

    self._Image_shop_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_shop_arrow_down")
    self._Image_shop_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_shop_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_shop_arrow_down:stopAllActions()
    self._Image_shop_arrow_up:stopAllActions()
    playActions(self._Image_shop_arrow_down)
    playActions(self._Image_shop_arrow_up)
    self._Image_shop_arrow_down:setVisible(false)
    self._Image_shop_arrow_up:setVisible(false)


    self:updateDraw()
end

function PropsShopPacksShopTab:onEnterTransitionFinish()
    
end

function PropsShopPacksShopTab:init(params)
    local rootWindow = params[1]

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function PropsShopPacksShopTab:onExit()
    state_machine.remove("props_shop_packs_shop_tab_change_page")
    state_machine.remove("props_shop_packs_shop_tab_update")
end