--------------------------------------------------------------------------------------------------------------
--  说明：任务标题列表项控件
--------------------------------------------------------------------------------------------------------------
TaskTitleCell = class("TaskTitleCellClass", Window)
TaskTitleCell.__size = nil

--创建cell
local task_title_create_cell_terminal = {
    _name = "task_title_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = TaskTitleCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(task_title_create_cell_terminal)
state_machine.init()

function TaskTitleCell:ctor()
	self.super:ctor()
	self.roots = {}

	self._task_type = nil 
end

function TaskTitleCell:updateDraw()
    local root = self.roots[1]
    local Text_main_task_title = ccui.Helper:seekWidgetByName(root,"Text_main_task_title")
    Text_main_task_title:setString(tipString_task_info[self._task_type])
end

function TaskTitleCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.task.task_main_cell_1, "root")
    self:addChild(root)
    -- local csbItem = csb.createNode(config_csb.cells.task.task_main_cell_1)
    -- self:addChild(csbItem)
    -- local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if TaskTitleCell.__size == nil then
        TaskTitleCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function TaskTitleCell:onEnterTransitionFinish()

end

function TaskTitleCell:init(params)
    self._task_type = params[1]
    self:onInit()
    self:setContentSize(TaskTitleCell.__size)
    return self
end

function TaskTitleCell:clearUIInfo()
    local root = self.roots[1]
    local Text_main_task_title = ccui.Helper:seekWidgetByName(root,"Text_main_task_title")
    if Text_main_task_title ~= nil then
        Text_main_task_title:setString("")
    end
end

function TaskTitleCell:unload( ... )
    -- body
end

function TaskTitleCell:reload( ... )
    -- body
end

function TaskTitleCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.task.task_main_cell_1, self.roots[1])
end