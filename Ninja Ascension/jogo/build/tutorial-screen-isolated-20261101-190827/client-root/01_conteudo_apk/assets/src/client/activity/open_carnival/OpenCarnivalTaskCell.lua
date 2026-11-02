-- 任务类型页签cell
OpenCarnivalTaskCell = class("OpenCarnivalTaskCellClass", Window)
OpenCarnivalTaskCell.__size = nil

-- 创建Cell实例
local open_carnival_task_cell_create_terminal = {
    _name = "open_carnival_task_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if OpenCarnivalTaskCell then
            local cell = OpenCarnivalTaskCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(open_carnival_task_cell_create_terminal)
state_machine.init()

-- 构造器
function OpenCarnivalTaskCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._cur_type = nil -- 当前绘制类型
    self._select_type = nil  -- 当前选中类型
end

-- 对象初始化
function OpenCarnivalTaskCell:init(params)
    self._cur_type = params[1]
    self._select_type = params[2]
    self._btn_name = params[3]
    self:onInit(params)
    self:setContentSize(OpenCarnivalTaskCell.__size)
    return self
end

function OpenCarnivalTaskCell:onUpdateDraw()
    local root = self.roots[1]
    self.Text_type_up = ccui.Helper:seekWidgetByName(root, "Text_type_up")
    self.Text_type_up:setString(self._btn_name)
    self.Text_type_down = ccui.Helper:seekWidgetByName(root, "Text_type_down")
    self.Text_type_down:setString(self._btn_name)
    self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")
    local isSelect =  self._select_type == self._cur_type
    self:onRefrushBtn(isSelect)
end

function OpenCarnivalTaskCell:onRefrushBtn(isSelect)
    self.Button_type:setTouchEnabled(not isSelect)
    self.Button_type:setHighlighted(isSelect)
    self.Text_type_up:setVisible(isSelect)
    self.Text_type_down:setVisible(not isSelect)
end

function OpenCarnivalTaskCell:showRedTip(flag)
    self.Image_red:setVisible(flag)
end

function OpenCarnivalTaskCell:onInit(params)
    local root = cacher.createUIRef("activity/open_carnival/open_carnival_task_cell.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if OpenCarnivalTaskCell.__size == nil then
        OpenCarnivalTaskCell.__size = root:getContentSize()
    end

    self.Button_type = ccui.Helper:seekWidgetByName(root, "Button_type")
    fwin:addTouchEventListener(
        self.Button_type,
        nil,
        {
            terminal_name = "open_carnival_window_change_type",
            terminal_state = 0,
            m_type = self._cur_type
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function OpenCarnivalTaskCell:onExit()
    local root = self.roots[1]
    cacher.freeRef("activity/open_carnival/open_carnival_task_cell.csb", root)
end

