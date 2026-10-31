-----------------------------
--节日祝福活动记录
-----------------------------
RedAlertTimeFestivalEachRecord = class("RedAlertTimeFestivalEachRecordClass", Window)

local red_alert_time_festival_each_record_window_open_terminal = {
    _name = "red_alert_time_festival_each_record_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeFestivalEachRecordClass") then
            local panel = RedAlertTimeFestivalEachRecord:new():init(params)
            fwin:open(panel, fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_festival_each_record_window_close_terminal = {
    _name = "red_alert_time_festival_each_record_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("RedAlertTimeFestivalEachRecordClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_festival_each_record_window_open_terminal)
state_machine.add(red_alert_time_festival_each_record_window_close_terminal)
state_machine.init()

function RedAlertTimeFestivalEachRecord:ctor()
    self.super:ctor()
    self.roots = {}
    self.activity_type = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_festival_each_child_record_cell")

    local function init_red_alert_time_festival_each_record_terminal()

    end
    init_red_alert_time_festival_each_record_terminal()
end

function RedAlertTimeFestivalEachRecord:onUpdateDraw()
    local root = self.roots[1]
    local ListView_festival_each_child_record = ccui.Helper:seekWidgetByName(root,"ListView_festival_each_child_record")
    ListView_festival_each_child_record:removeAllItems()

    local result = _ED.festival_bless_activity_record

    for k, v in pairs(result) do
        local cell = state_machine.excute("red_alert_time_festival_each_child_record_cell_create", 0, {k, v, self._activity_type})
        ListView_festival_each_child_record:addChild(cell)
    end

    ListView_festival_each_child_record:requestRefreshView()

    self._list_view = ListView_festival_each_child_record
    self._list_view_poy = ListView_festival_each_child_record:getInnerContainer():getPositionY()
    self._list_view_height = ListView_festival_each_child_record:getInnerContainer():getPositionY()
end

function RedAlertTimeFestivalEachRecord:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
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

function RedAlertTimeFestivalEachRecord:onEnterTransitionFinish()

end

function RedAlertTimeFestivalEachRecord:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.festival_each_child_record)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_festival_each_child_record_close"), nil, 
    {
        terminal_name = "red_alert_time_festival_each_record_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_festival_each_record_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function RedAlertTimeFestivalEachRecord:init(params)
    self._activity_type = params[1]
    self._record_info = params[2]
    self:onInit()
    return self
end

function RedAlertTimeFestivalEachRecord:onExit()
    state_machine.remove("red_alert_time_festival_each_record_activity_codes")
end
