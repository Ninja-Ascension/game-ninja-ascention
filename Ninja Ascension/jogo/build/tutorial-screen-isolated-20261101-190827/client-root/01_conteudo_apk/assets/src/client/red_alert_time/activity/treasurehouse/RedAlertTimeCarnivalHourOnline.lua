-- ------------------------------------------------------------------------------------------------------------
--  说明：狂欢时刻在线奖励
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeCarnivalHourOnline = class("RedAlertTimeCarnivalHourOnlineClass", Window)

--打开界面
local red_alert_time_carnival_hour_online_open_terminal = {
    _name = "red_alert_time_carnival_hour_online_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeCarnivalHourOnline:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_carnival_hour_online_open_terminal)
state_machine.init()

function RedAlertTimeCarnivalHourOnline:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_carnival_hour_arrow_down = nil
    self._Image_carnival_hour_arrow_up = nil
    
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seek_treasure_rank_cell")

    local function init_red_alert_time_carnival_hour_online_terminal()
        local red_alert_time_carnival_hour_online_show_terminal = {
            _name = "red_alert_time_carnival_hour_online_show",
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

        local red_alert_time_carnival_hour_online_hide_terminal = {
            _name = "red_alert_time_carnival_hour_online_hide",
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

        local red_alert_time_carnival_hour_online_update_draw_terminal = {
            _name = "red_alert_time_carnival_hour_online_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateOnlineInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_carnival_hour_online_show_terminal)
        state_machine.add(red_alert_time_carnival_hour_online_hide_terminal)
        state_machine.add(red_alert_time_carnival_hour_online_update_draw_terminal)
        state_machine.init()
    end
    init_red_alert_time_carnival_hour_online_terminal()
end

-- 刷新在线奖励
function RedAlertTimeCarnivalHourOnline:onUpdateOnlineInfo()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_data = activity_info.activity_data[1]

    local data = nil
    local result = {}
    for k, v in pairs(activity_data) do
        if v.achieve_other_info == "-1" then
            table.insert(result, v)
        end
    end
    for k, v in pairs(result) do
        if tonumber(v.achieve_state) ~= 2 then
            data = v
            break
        end
    end
    if data == nil then
        data = result[#result]
    end 

    local ListView_carnival_hour = ccui.Helper:seekWidgetByName(root, "ListView_carnival_hour")
    local items = ListView_carnival_hour:getItems()
    local cell = items[1]
    if cell == nil then
        cell = state_machine.excute("red_alert_time_carnival_hour_all_cell_create", 0, {data, 1, activity_info.activity_type, 1})
        ListView_carnival_hour:addChild(cell)
    else
        state_machine.excute("red_alert_time_carnival_hour_all_cell_update_info", 0, 
            {cell = cell, info = data, index = 1, a_type = activity_info.activity_type, group = 1})
    end
end

function RedAlertTimeCarnivalHourOnline:onUpdateDraw()
    local root = self.roots[1]

    local activity_info = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_data = activity_info.activity_data[1]

    local ListView_carnival_hour = ccui.Helper:seekWidgetByName(root, "ListView_carnival_hour")
    self._list_view = ListView_carnival_hour
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    self:onUpdateOnlineInfo()

    local result = {}
    for k, v in pairs(activity_data) do
        if v.achieve_other_info ~= "-1" then
            table.insert(result, v)
        end
    end

    local index = 1
    for i,v in pairs(result) do
        index = index + 1
        local cell = state_machine.excute("red_alert_time_carnival_hour_all_cell_create", 0, {result[i], index, activity_info.activity_type, 1})
        self._list_view:addChild(cell)
    end
    
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function RedAlertTimeCarnivalHourOnline:onUpdate(dt)
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

function RedAlertTimeCarnivalHourOnline:onInit()
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

function RedAlertTimeCarnivalHourOnline:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeCarnivalHourOnline:onExit()
    state_machine.remove("red_alert_time_carnival_hour_online_show")
    state_machine.remove("red_alert_time_carnival_hour_online_hide")
    state_machine.remove("red_alert_time_carnival_hour_online_update_draw")
end