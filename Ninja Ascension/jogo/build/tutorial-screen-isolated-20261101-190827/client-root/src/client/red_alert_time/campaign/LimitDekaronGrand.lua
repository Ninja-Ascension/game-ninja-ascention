-- ------------------------------------------------------------------------------------------------------------
--  说明：极限挑战战报
-- ------------------------------------------------------------------------------------------------------------
LimitDekaronGrand = class("LimitDekaronGrandClass", Window)

--打开界面
local limit_dekaron_grand_window_open_terminal = {
    _name = "limit_dekaron_grand_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LimitDekaronGrand:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

local limit_dekaron_grand_window_close_terminal = {
    _name = "limit_dekaron_grand_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimitDekaronGrandClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(limit_dekaron_grand_window_open_terminal)
state_machine.add(limit_dekaron_grand_window_close_terminal)
state_machine.init()

function LimitDekaronGrand:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_dekarona_battlefield_arrow_down = nil
    self._Image_dekarona_battlefield_arrow_up = nil

    local function init_limit_dekaron_grand_terminal()
        local limit_dekaron_grand_show_terminal = {
            _name = "limit_dekaron_grand_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                if _ED.city_resource_battle_report ~= nil then
                    _ED.city_resource_battle_report[202] = nil
                end
                protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_202
                NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local limit_dekaron_grand_hide_terminal = {
            _name = "limit_dekaron_grand_hide",
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
        local limit_dekaron_grand_update_list_info_terminal = {
            _name = "limit_dekaron_grand_update_list_info",
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

        local limit_dekaron_grand_battle_rule_terminal = {
            _name = "limit_dekaron_grand_battle_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,6)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(limit_dekaron_grand_show_terminal)
        state_machine.add(limit_dekaron_grand_hide_terminal)
        state_machine.add(limit_dekaron_grand_update_list_info_terminal)
        state_machine.add(limit_dekaron_grand_battle_rule_terminal)
        state_machine.init()
    end
    init_limit_dekaron_grand_terminal()
end

function LimitDekaronGrand:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function LimitDekaronGrand:onUpdateDraw()
    local root = self.roots[1]
    local ListView_limit_battlefield = ccui.Helper:seekWidgetByName(root, "ListView_limit_battlefield")
    self._list_view = ListView_limit_battlefield
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    self._Image_dekarona_battlefield_arrow_down:setVisible(false)
    self._Image_dekarona_battlefield_arrow_up:setVisible(false)

    local grand_type = battle_enum._fight_type._fight_type_202
    if _ED.city_resource_battle_report ~= nil and _ED.city_resource_battle_report[grand_type] ~= nil then
        local result = {}
        for k, v in pairs(_ED.city_resource_battle_report[grand_type]) do
            table.insert(result, v)
        end
        
        function sortLoad( a, b )
            return zstring.tonumber(a.time) > zstring.tonumber(b.time)
        end
        table.sort(result, sortLoad)
        for i, v in pairs(result) do
            local cell = state_machine.excute("limit_dekaron_grand_create_cell", 0, {v, i})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function LimitDekaronGrand:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_dekarona_battlefield_arrow_down:setVisible(true)
        else
            self._Image_dekarona_battlefield_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_dekarona_battlefield_arrow_up:setVisible(true)
        else
            self._Image_dekarona_battlefield_arrow_up:setVisible(false)
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

function LimitDekaronGrand:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.limit_dekarona_tab, 4))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_grand_close"), nil, 
    {
        terminal_name = "limit_dekaron_grand_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_battlefield_infor"), nil, 
    {
        terminal_name = "limit_dekaron_grand_battle_rule", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_dekarona_battlefield_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_dekarona_battlefield_arrow_down")
    self._Image_dekarona_battlefield_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_dekarona_battlefield_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_dekarona_battlefield_arrow_down:stopAllActions()
    self._Image_dekarona_battlefield_arrow_up:stopAllActions()
    playActions(self._Image_dekarona_battlefield_arrow_down)
    playActions(self._Image_dekarona_battlefield_arrow_up)
    self._Image_dekarona_battlefield_arrow_down:setVisible(false)
    self._Image_dekarona_battlefield_arrow_up:setVisible(false)

    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    if _ED.city_resource_battle_report ~= nil then
        _ED.city_resource_battle_report[202] = nil
    end
    protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_202
    NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)
end

function LimitDekaronGrand:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LimitDekaronGrand:onExit()
    state_machine.remove("limit_dekaron_grand_show")
    state_machine.remove("limit_dekaron_grand_hide")
    state_machine.remove("limit_dekaron_grand_update_list_info")
    state_machine.remove("limit_dekaron_grand_battle_rule")
end