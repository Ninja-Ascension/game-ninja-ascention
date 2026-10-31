-- ------------------------------------------------------------------------------------------------------------
--  远征商店
-- ------------------------------------------------------------------------------------------------------------
ExpeditionShop = class("ExpeditionShopClass", Window)

local expedition_shop_window_open_terminal = {
    _name = "expedition_shop_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = ExpeditionShop:new():init(params)
        fwin:open(panel)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(expedition_shop_window_open_terminal)
state_machine.init()

function ExpeditionShop:ctor()
    self.super:ctor()
    self.roots = {}

    -- 
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._costs_amount = 0

    self._Image_expedition_shop_arrow_down = nil
    self._Image_expedition_shop_arrow_up = nil

    app.load("client.red_alert_time.cells.props.props_icon_cell")

    local function init_expedition_shop_terminal()
        local expedition_shop_show_terminal = {
            _name = "expedition_shop_show",
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

        local expedition_shop_hide_terminal = {
            _name = "expedition_shop_hide",
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

        local expedition_shop_update_terminal = {
            _name = "expedition_shop_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local expedition_shop_refresh_terminal = {
            _name = "expedition_shop_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._costs_amount == 0 then
                    instance:sureGoldUpdate(0)
                else
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureGoldUpdate, string.format(red_alert_time_str[181],instance._costs_amount))
                    fwin:open(tip,fwin._windows) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local expedition_shop_update_integral_terminal = {
            _name = "expedition_shop_update_integral",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateIntegral()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(expedition_shop_show_terminal)
        state_machine.add(expedition_shop_hide_terminal)
        state_machine.add(expedition_shop_update_terminal)
        state_machine.add(expedition_shop_refresh_terminal)
        state_machine.add(expedition_shop_update_integral_terminal)
        state_machine.init()
    end
    init_expedition_shop_terminal()
end

-- 金币刷新
function ExpeditionShop:sureGoldUpdate(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:updateDraw()
            end
        end
    end   
    if sure_number == 0 then
        protocol_command.expedition_shop_refresh.param_list = ""
        NetworkManager:register(protocol_command.expedition_shop_refresh.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

-- 远征积分刷新
function ExpeditionShop:updateIntegral()
    local root = self.roots[1]
    local Text_expedition_integral_n = ccui.Helper:seekWidgetByName(root,"Text_expedition_integral_n")
    Text_expedition_integral_n:setString(_ED.user_expedition_info.current_score)
end

function ExpeditionShop:updateDraw()
    local root = self.roots[1]
    local Text_refresh_gold_n = ccui.Helper:seekWidgetByName(root,"Text_refresh_gold_n")
    local Button_expedition_shop_refresh = ccui.Helper:seekWidgetByName(root,"Button_expedition_shop_refresh")
    local Button_expedition_shop_free_refresh = ccui.Helper:seekWidgetByName(root,"Button_expedition_shop_free_refresh")
    local Image_expedition_refresh_gold = ccui.Helper:seekWidgetByName(root,"Image_expedition_refresh_gold")
    Image_expedition_refresh_gold:setVisible(false)
    Button_expedition_shop_refresh:setVisible(false)
    Button_expedition_shop_free_refresh:setVisible(false)

    local gold_costs = zstring.split(dms.string(dms["expedition_config"], 4, expedition_config.param), ",")
    local begin_count = tonumber(_ED.expedition_shop_info.reset_shop_count) + 1
    self._costs_amount = tonumber(gold_costs[begin_count])
    if tonumber(_ED.expedition_shop_info.reset_shop_count) >= table.nums(gold_costs) then 
        self._costs_amount = tonumber(gold_costs[table.nums(gold_costs)])
    end
    if self._costs_amount == 0 then
        Text_refresh_gold_n:setString("")
        Button_expedition_shop_free_refresh:setVisible(true)
    else
        Image_expedition_refresh_gold:setVisible(true)
        Text_refresh_gold_n:setString(self._costs_amount)
        Button_expedition_shop_refresh:setVisible(true)
    end
    

    local ListView_expedition_shop = ccui.Helper:seekWidgetByName(root, "ListView_expedition_shop")
    self._list_view = ListView_expedition_shop
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local item_list = zstring.split(_ED.expedition_shop_info.item_list, ",")
    local exchange_state = zstring.split(_ED.expedition_shop_info.exchange_state, ",")
    for i=1,#item_list do
        if tonumber(item_list[i]) > 0 then
            local expedition_data = dms.element(dms["expedition_shop"], item_list[i])
            local reward_prop = zstring.split(dms.atos(expedition_data, expedition_shop.reward_prop), ",")
            local cost_prop = zstring.split(dms.atos(expedition_data, expedition_shop.cost_prop), ",")
            local cell = state_machine.excute("expedition_shop_cell_create", 0, {i,reward_prop,cost_prop,exchange_state[i]})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()

    self:updateIntegral()
end

function ExpeditionShop:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_expedition_shop_arrow_down:setVisible(true)
        else
            self._Image_expedition_shop_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_expedition_shop_arrow_up:setVisible(true)
        else
            self._Image_expedition_shop_arrow_up:setVisible(false)
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

function ExpeditionShop:onInit()
    local csbItem = csb.createNode(config_csb.campaign.expedition_shop)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_expedition_shop_refresh"), nil, 
    {
        terminal_name = "expedition_shop_refresh", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_expedition_shop_free_refresh"), nil, 
    {
        terminal_name = "expedition_shop_refresh", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self._Image_expedition_shop_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_expedition_shop_arrow_down")
    self._Image_expedition_shop_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_expedition_shop_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_expedition_shop_arrow_down:stopAllActions()
    self._Image_expedition_shop_arrow_up:stopAllActions()
    playActions(self._Image_expedition_shop_arrow_down)
    playActions(self._Image_expedition_shop_arrow_up)
    self._Image_expedition_shop_arrow_down:setVisible(false)
    self._Image_expedition_shop_arrow_up:setVisible(false)

    self:updateDraw()
end

function ExpeditionShop:onEnterTransitionFinish()
    
end

function ExpeditionShop:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function ExpeditionShop:onExit()
    state_machine.remove("expedition_shop_show")
    state_machine.remove("expedition_shop_hide")
    state_machine.remove("expedition_shop_update")
    state_machine.remove("expedition_shop_refresh")
    state_machine.remove("expedition_shop_update_integral")
end