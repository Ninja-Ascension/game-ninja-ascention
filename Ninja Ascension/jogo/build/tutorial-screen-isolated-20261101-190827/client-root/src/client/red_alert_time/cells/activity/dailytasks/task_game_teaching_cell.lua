--------------------------------------------------------------------------------------------------------------
--  说明：游戏指引cell
--------------------------------------------------------------------------------------------------------------
TaskGameTeachingCell = class("TaskGameTeachingCellClass", Window)

--创建cell
local task_game_teaching_cell_create_terminal = {
    _name = "task_game_teaching_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = TaskGameTeachingCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(task_game_teaching_cell_create_terminal)
state_machine.init()

function TaskGameTeachingCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil

    app.load("client.red_alert_time.cells.props.props_mould_icon_cell")

    local function init_task_game_teaching_cell_terminal()
        local task_game_teaching_cell_update_info_terminal = {
            _name = "task_game_teaching_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._index = params.index
                cell._info = params.info
                if cell._info ~= nil then
                    if cell._index <= 8 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_game_teaching_cell_goto_terminal = {
            _name = "task_game_teaching_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local info = cell._info
                if info ~= nil then
                    state_machine.excute("task_window_close", 0, nil)
                    if info.fun_id <= 0 then
                        state_machine.excute("home_map_reset_scale", 0, nil)
                        state_machine.excute("home_map_scroll_to_panel_city", 0, {info.build_id, true, info})
                    else
                        state_machine.excute("short_cut_go_to_other_window",0,{info.fun_id, nil, info})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(task_game_teaching_cell_update_info_terminal)   
        state_machine.add(task_game_teaching_cell_goto_terminal)   
        state_machine.init()
    end 
    init_task_game_teaching_cell_terminal()
end

function TaskGameTeachingCell:updateDraw()
    local root = self.roots[1]
    local Panel_game_teaching_icon = ccui.Helper:seekWidgetByName(root, "Panel_game_teaching_icon")
    local Text_game_teaching_name = ccui.Helper:seekWidgetByName(root, "Text_game_teaching_name")
    local Text_game_teaching_infor_1 = ccui.Helper:seekWidgetByName(root, "Text_game_teaching_infor_1")

    Panel_game_teaching_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_mould_icon_cell_create", 0, {self._info.pic, 0})
    Panel_game_teaching_icon:addChild(cell)
    Text_game_teaching_name:setString(self._info.button_name)
    Text_game_teaching_infor_1:setString(self._info.distribute)
end

function TaskGameTeachingCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.task.task_game_teaching_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if TaskGameTeachingCell.__size == nil then
        TaskGameTeachingCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_game_teaching_go"), nil, 
    {
        terminal_name = "task_game_teaching_cell_goto", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function TaskGameTeachingCell:onEnterTransitionFinish()

end

function TaskGameTeachingCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function TaskGameTeachingCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.task.task_game_teaching_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function TaskGameTeachingCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_game_teaching_icon = ccui.Helper:seekWidgetByName(root, "Panel_game_teaching_icon")
    local Text_game_teaching_name = ccui.Helper:seekWidgetByName(root, "Text_game_teaching_name")
    local Text_game_teaching_infor_1 = ccui.Helper:seekWidgetByName(root, "Text_game_teaching_infor_1")
    if Panel_game_teaching_icon ~= nil then
        Panel_game_teaching_icon:removeAllChildren(true)
        Text_game_teaching_name:setString("")
        Text_game_teaching_infor_1:setString("")
    end
end

function TaskGameTeachingCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index ~= nil and self._index <= 8 then
        self:onInit()
    end
    self:setContentSize(TaskGameTeachingCell.__size)
    
    return self
end

function TaskGameTeachingCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.task.task_game_teaching_cell, self.roots[1])
end