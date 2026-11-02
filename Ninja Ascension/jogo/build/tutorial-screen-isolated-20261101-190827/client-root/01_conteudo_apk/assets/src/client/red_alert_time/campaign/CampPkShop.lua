-- ------------------------------------------------------------------------------------------------------------
--  阵营对决商店
-- ------------------------------------------------------------------------------------------------------------
CampPkShop = class("CampPkShopClass", Window)

local camp_pk_shop_window_open_terminal = {
    _name = "camp_pk_shop_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = CampPkShop:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

local camp_pk_shop_window_close_terminal = {
    _name = "camp_pk_shop_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CampPkShopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(camp_pk_shop_window_open_terminal)
state_machine.add(camp_pk_shop_window_close_terminal)
state_machine.init()

function CampPkShop:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._costs_amount = 0

    self._Image_camp_pk_shop_arrow_down = nil
    self._Image_camp_pk_shop_arrow_up = nil

    app.load("client.red_alert_time.cells.props.props_icon_cell")

    -- Initialize camp_pk_shop state machine.
    local function init_camp_pk_shop_terminal()
        local camp_pk_shop_show_terminal = {
            _name = "camp_pk_shop_show",
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

        local camp_pk_shop_hide_terminal = {
            _name = "camp_pk_shop_hide",
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

        local camp_pk_shop_update_terminal = {
            _name = "camp_pk_shop_update",
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
        state_machine.add(camp_pk_shop_update_terminal)

        local camp_pk_shop_refresh_terminal = {
            _name = "camp_pk_shop_refresh",
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
        state_machine.add(camp_pk_shop_update_terminal)
        state_machine.add(camp_pk_shop_refresh_terminal)
        state_machine.add(camp_pk_shop_show_terminal)
        state_machine.add(camp_pk_shop_hide_terminal)
        state_machine.init()
    end
    
    init_camp_pk_shop_terminal()
end

-- 金币刷新
function CampPkShop:sureGoldUpdate(sure_number)
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
        protocol_command.camp_duel_shop_refresh.param_list = ""
        NetworkManager:register(protocol_command.camp_duel_shop_refresh.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function CampPkShop:updateDraw()
    local root = self.roots[1]
    local Text_camp_pk_meritorious_n = ccui.Helper:seekWidgetByName(root,"Text_camp_pk_meritorious_n")
    local Text_camp_pk_refresh_gold_n = ccui.Helper:seekWidgetByName(root,"Text_camp_pk_refresh_gold_n")
    local Button_camp_pk_shop_refresh = ccui.Helper:seekWidgetByName(root,"Button_camp_pk_shop_refresh")
    local Button_camp_pk_gold_refresh = ccui.Helper:seekWidgetByName(root,"Button_camp_pk_gold_refresh")
    local Image_camp_pk_refresh_gold = ccui.Helper:seekWidgetByName(root,"Image_camp_pk_refresh_gold")
    Image_camp_pk_refresh_gold:setVisible(false)
    Button_camp_pk_shop_refresh:setVisible(false)
    Button_camp_pk_gold_refresh:setVisible(false)
    Text_camp_pk_refresh_gold_n:setVisible(true)

    Text_camp_pk_meritorious_n:setString(_ED.camp_pk_user_info.total_con)
    local gold_costs = zstring.split(dms.string(dms["camp_duel_config"], 13, camp_duel_config.param), ",")
    local begin_count = tonumber(_ED.camp_pk_shop_info.refresh_times) + 1
    self._costs_amount = tonumber(gold_costs[begin_count])
    if tonumber(_ED.camp_pk_shop_info.refresh_times) >= table.nums(gold_costs) then 
        self._costs_amount = tonumber(gold_costs[table.nums(gold_costs)])
    end
    if self._costs_amount == 0 then
        Text_camp_pk_refresh_gold_n:setString("")
        Button_camp_pk_shop_refresh:setVisible(true)
    else
        Button_camp_pk_gold_refresh:setVisible(true)
        Image_camp_pk_refresh_gold:setVisible(true)
        Text_camp_pk_refresh_gold_n:setString(self._costs_amount)
        Button_camp_pk_shop_refresh:setTitleText(red_alert_time_str[180])
    end
    

    local ListView_camp_pk_shop = ccui.Helper:seekWidgetByName(root, "ListView_camp_pk_shop")
    self._list_view = ListView_camp_pk_shop
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local item_list = zstring.split(_ED.camp_pk_shop_info.prop_ids, ",")
    local recharge_states = zstring.split(_ED.camp_pk_shop_info.recharge_states, ",")
    for i=1,#item_list do
        if tonumber(item_list[i]) > 0 then
            local expedition_data = dms.element(dms["camp_duel_shop"], item_list[i])
            local reward_prop = zstring.split(dms.atos(expedition_data, camp_duel_shop.reward_prop), ",")
            local cost_prop = zstring.split(dms.atos(expedition_data, camp_duel_shop.cost_prop), ",")
            local cell = state_machine.excute("camp_pk_shop_cell_create", 0, {i,reward_prop,cost_prop,recharge_states[i]})
            self._list_view:addChild(cell)
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function CampPkShop:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_camp_pk_shop_arrow_down:setVisible(true)
        else
            self._Image_camp_pk_shop_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_camp_pk_shop_arrow_up:setVisible(true)
        else
            self._Image_camp_pk_shop_arrow_up:setVisible(false)
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

function CampPkShop:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.camp_pk_tab, 4))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_pk_shop_refresh"), nil, 
    {
        terminal_name = "camp_pk_shop_refresh", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_pk_gold_refresh"), nil, 
    {
        terminal_name = "camp_pk_shop_refresh", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self._Image_camp_pk_shop_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_camp_pk_shop_arrow_down")
    self._Image_camp_pk_shop_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_camp_pk_shop_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_camp_pk_shop_arrow_down:stopAllActions()
    self._Image_camp_pk_shop_arrow_up:stopAllActions()
    playActions(self._Image_camp_pk_shop_arrow_down)
    playActions(self._Image_camp_pk_shop_arrow_up)
    self._Image_camp_pk_shop_arrow_down:setVisible(false)
    self._Image_camp_pk_shop_arrow_up:setVisible(false)

    self:updateDraw()
end

function CampPkShop:onEnterTransitionFinish()
    
end

function CampPkShop:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    
    self:onInit()
    return self
end

function CampPkShop:onExit()
    state_machine.remove("camp_pk_shop_update")
    state_machine.remove("camp_pk_shop_refresh")
    state_machine.remove("camp_pk_shop_show")
    state_machine.remove("camp_pk_shop_hide")
end