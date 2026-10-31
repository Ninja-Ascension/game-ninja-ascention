--------------------------------------------------------------------------------------------------------------
--  说明：欢乐团购购买记录cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeFestivalEachChildRecordCell = class("RedAlertTimeFestivalEachChildRecordCellClass", Window)
RedAlertTimeFestivalEachChildRecordCell.__size = nil

--创建cell
local red_alert_time_festival_each_child_record_cell_create_terminal = {
    _name = "red_alert_time_festival_each_child_record_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeFestivalEachChildRecordCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_festival_each_child_record_cell_create_terminal)
state_machine.init()

function RedAlertTimeFestivalEachChildRecordCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._index = 0
    self._info = nil
    self._activity_type = 0
     
    local function init_red_alert_time_festival_each_child_record_cell_terminal()

    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_festival_each_child_record_cell_terminal()

end

function RedAlertTimeFestivalEachChildRecordCell:updateDraw()
    local root = self.roots[1]
    
    -- 时间
    local Text_festival_each_child_record_time = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_record_time")
    local time_str = os.date("%Y.%m.%d %H:%M:%S", tonumber(self._info.time) - _ED.GTM_Time)
    Text_festival_each_child_record_time:setString(string.format(activity_str_tip[197], ""..self._index, time_str))

    -- 集福信息
    local Text_festival_each_child_record = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_record")
    Text_festival_each_child_record:setString(string.format(activity_str_tip[198], exChangeNumToString(self._info.use_gold), exChangeNumToString(self._info.get_gold)))
end 

function RedAlertTimeFestivalEachChildRecordCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.festival_each_child_record_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeFestivalEachChildRecordCell.__size == nil then
        RedAlertTimeFestivalEachChildRecordCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function RedAlertTimeFestivalEachChildRecordCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function RedAlertTimeFestivalEachChildRecordCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_festival_each_child_record_time = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_record_time")
    local Text_festival_each_child_record = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_record")
    if Text_festival_each_child_record_time ~= nil then
        Text_festival_each_child_record_time:setString("")
        Text_festival_each_child_record:setString("")
    end
end

function RedAlertTimeFestivalEachChildRecordCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeFestivalEachChildRecordCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.festival_each_child_record_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeFestivalEachChildRecordCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._activity_type = params[3]
    -- if index ~= nil and index <= 3 then
       self:onInit()
    -- end
    self:setContentSize(RedAlertTimeFestivalEachChildRecordCell.__size)
    return self
end

function RedAlertTimeFestivalEachChildRecordCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.festival_each_child_record_cell, self.roots[1])
end