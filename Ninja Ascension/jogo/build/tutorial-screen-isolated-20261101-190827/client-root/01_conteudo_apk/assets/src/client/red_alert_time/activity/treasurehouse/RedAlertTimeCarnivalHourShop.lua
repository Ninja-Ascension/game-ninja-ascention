-- ------------------------------------------------------------------------------------------------------------
--  说明：狂欢时刻折扣卖场
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeCarnivalHourShop = class("RedAlertTimeCarnivalHourShopClass", Window)

--打开界面
local red_alert_time_carnival_hour_shop_open_terminal = {
    _name = "red_alert_time_carnival_hour_shop_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeCarnivalHourShop:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_carnival_hour_shop_open_terminal)
state_machine.init()

function RedAlertTimeCarnivalHourShop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_carnival_hour_arrow_down = nil
    self._Image_carnival_hour_arrow_up = nil
    
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seek_treasure_rank_cell")

    local function init_red_alert_time_carnival_hour_shop_terminal()
        local red_alert_time_carnival_hour_shop_show_terminal = {
            _name = "red_alert_time_carnival_hour_shop_show",
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

        local red_alert_time_carnival_hour_shop_hide_terminal = {
            _name = "red_alert_time_carnival_hour_shop_hide",
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

        local red_alert_time_carnival_hour_shop_update_draw_terminal = {
            _name = "red_alert_time_carnival_hour_shop_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._list_view ~= nil then
                    local posY = instance._list_view_poy
                    instance:onUpdateDraw()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)  
                    instance._list_view_poy = posY + 1
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_carnival_hour_shop_request_shop_info_terminal = {
            _name = "red_alert_time_carnival_hour_shop_request_shop_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity_info = _ED.activity_info[""..instance._activity_type.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                            state_machine.excute("red_alert_time_carnival_hour_update_shop_reset_time", 0, "")
                        end
                    end
                end     
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n"..(2).."\r\n"..(0).."\r\n".."2"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_carnival_hour_shop_show_terminal)
        state_machine.add(red_alert_time_carnival_hour_shop_hide_terminal)
        state_machine.add(red_alert_time_carnival_hour_shop_update_draw_terminal)
        state_machine.add(red_alert_time_carnival_hour_shop_request_shop_info_terminal)
        state_machine.init()
    end
    init_red_alert_time_carnival_hour_shop_terminal()
end

function RedAlertTimeCarnivalHourShop:onUpdateDraw()
    local root = self.roots[1]

    local activity_info = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_data = activity_info.activity_data[3]

    local ListView_carnival_hour = ccui.Helper:seekWidgetByName(root, "ListView_carnival_hour")
    ListView_carnival_hour:jumpToTop()
    self._list_view = ListView_carnival_hour

    local result = {}
    if _ED.carnival_hour_shop_list ~= nil then
        for i = 1, #_ED.carnival_hour_shop_list do
            for k, v in pairs(activity_data) do
                if tonumber(v.achieve_index) == _ED.carnival_hour_shop_list[i] + 1 then
                    table.insert(result, v)
                end
            end
        end
    end

    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_carnival_hour_time_limit_cell_update_info", 0, 
            {cell = v, info = result[k], index = k, a_type = activity_info.activity_type, group = 3})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_carnival_hour_time_limit_cell_create", 0, {result[i], i, activity_info.activity_type, 3})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function RedAlertTimeCarnivalHourShop:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_carnival_hour_arrow_down:setVisible(true)
        else
            self._Image_carnival_hour_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_carnival_hour_arrow_up:setVisible(true)
        else
            self._Image_carnival_hour_arrow_up:setVisible(false)
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

function RedAlertTimeCarnivalHourShop:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.carnival_hour_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_carnival_hour_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_carnival_hour_arrow_down")
    self._Image_carnival_hour_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_carnival_hour_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_carnival_hour_arrow_down:stopAllActions()
    self._Image_carnival_hour_arrow_up:stopAllActions()
    playActions(self._Image_carnival_hour_arrow_down)
    playActions(self._Image_carnival_hour_arrow_up)
    self._Image_carnival_hour_arrow_down:setVisible(false)
    self._Image_carnival_hour_arrow_up:setVisible(false)

    state_machine.excute("red_alert_time_carnival_hour_shop_request_shop_info", 0, "")
end

function RedAlertTimeCarnivalHourShop:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeCarnivalHourShop:onExit()
    state_machine.remove("red_alert_time_carnival_hour_shop_show")
    state_machine.remove("red_alert_time_carnival_hour_shop_hide")
    state_machine.remove("red_alert_time_carnival_hour_shop_update_draw")
    state_machine.excute("red_alert_time_carnival_hour_shop_request_shop_info")
end