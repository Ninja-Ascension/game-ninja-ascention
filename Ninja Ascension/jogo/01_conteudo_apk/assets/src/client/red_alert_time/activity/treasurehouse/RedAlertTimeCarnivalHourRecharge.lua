-- ------------------------------------------------------------------------------------------------------------
--  说明：狂欢时刻充值好礼
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeCarnivalHourRecharge = class("RedAlertTimeCarnivalHourRechargeClass", Window)

--打开界面
local red_alert_time_carnival_hour_recharge_open_terminal = {
    _name = "red_alert_time_carnival_hour_recharge_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeCarnivalHourRecharge:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_carnival_hour_recharge_open_terminal)
state_machine.init()

function RedAlertTimeCarnivalHourRecharge:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_carnival_hour_arrow_down = nil
    self._Image_carnival_hour_arrow_up = nil
    
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seek_treasure_rank_cell")

    local function init_red_alert_time_carnival_hour_recharge_terminal()
        local red_alert_time_carnival_hour_recharge_show_terminal = {
            _name = "red_alert_time_carnival_hour_recharge_show",
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

        local red_alert_time_carnival_hour_recharge_hide_terminal = {
            _name = "red_alert_time_carnival_hour_recharge_hide",
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

        local red_alert_time_carnival_hour_recharge_update_draw_terminal = {
            _name = "red_alert_time_carnival_hour_recharge_update_draw",
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

        state_machine.add(red_alert_time_carnival_hour_recharge_show_terminal)
        state_machine.add(red_alert_time_carnival_hour_recharge_hide_terminal)
        state_machine.add(red_alert_time_carnival_hour_recharge_update_draw_terminal)
        state_machine.init()
    end
    init_red_alert_time_carnival_hour_recharge_terminal()
end

function RedAlertTimeCarnivalHourRecharge:onUpdateDraw()
    local root = self.roots[1]

    local activity_info = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_data = activity_info.activity_data[2]

    local ListView_carnival_hour = ccui.Helper:seekWidgetByName(root, "ListView_carnival_hour")
    ListView_carnival_hour:jumpToTop()
    self._list_view = ListView_carnival_hour

    local result = activity_data

    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_carnival_hour_all_cell_update_info", 0, 
            {cell = v, info = result[k], index = k, a_type = activity_info.activity_type, group = 2})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_carnival_hour_all_cell_create", 0, {result[i], i, activity_info.activity_type, 2})
            self._list_view:addChild(cell)
        end
    end
    
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function RedAlertTimeCarnivalHourRecharge:onUpdate(dt)
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

function RedAlertTimeCarnivalHourRecharge:onInit()
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

    self:onUpdateDraw()
end

function RedAlertTimeCarnivalHourRecharge:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeCarnivalHourRecharge:onExit()
    state_machine.remove("red_alert_time_carnival_hour_recharge_show")
    state_machine.remove("red_alert_time_carnival_hour_recharge_hide")
    state_machine.remove("red_alert_time_carnival_hour_recharge_update_draw")
end