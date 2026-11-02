-- 天数页签cell
OpenCarnivalDayCell = class("OpenCarnivalDayCellClass", Window)
OpenCarnivalDayCell.__size = nil

-- 创建Cell实例
local open_carnival_day_cell_create_terminal = {
    _name = "open_carnival_day_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if OpenCarnivalDayCell then
            local cell = OpenCarnivalDayCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(open_carnival_day_cell_create_terminal)
state_machine.init()

-- 构造器
function OpenCarnivalDayCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._cur_day = nil -- 当前绘制天数
    self._select_day = nil  -- 当前选中天数
end

-- 对象初始化
function OpenCarnivalDayCell:init(params)
    self._cur_day = params[1]
    self._select_day = params[2]
    self:onInit(params)
    self:setContentSize(OpenCarnivalDayCell.__size)
    return self
end

function OpenCarnivalDayCell:onUpdateDraw()
    local root = self.roots[1]
    self.Text_day_up = ccui.Helper:seekWidgetByName(root, "Text_day_up")
    self.Text_day_down = ccui.Helper:seekWidgetByName(root, "Text_day_down")
    self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")
    self.Image_finish = ccui.Helper:seekWidgetByName(root, "Image_finish")
    self.Text_day_up:setString(tipStringInfo_open_carnival_tip[self._cur_day])
    self.Text_day_down:setString(tipStringInfo_open_carnival_tip[self._cur_day])
    local isSelect =  self._select_day == self._cur_day
    self:onRefrushBtn(isSelect)
end

function OpenCarnivalDayCell:onRefrushBtn(isSelect)
    self.Button_day:setTouchEnabled(not isSelect)
    self.Button_day:setHighlighted(isSelect)
    self.Text_day_up:setVisible(isSelect)
    self.Text_day_down:setVisible(not isSelect)
end

function OpenCarnivalDayCell:showRedTip(flag)
    self.Image_red:setVisible(flag)
end

function OpenCarnivalDayCell:showFinishTip(flag)
    self.Image_finish:setVisible(flag)
end

function OpenCarnivalDayCell:onInit(params)
    local root = cacher.createUIRef("activity/open_carnival/open_carnival_day_cell.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if OpenCarnivalDayCell.__size == nil then
        OpenCarnivalDayCell.__size = root:getContentSize()
    end

    self.Button_day = ccui.Helper:seekWidgetByName(root, "Button_day")
    fwin:addTouchEventListener(
        self.Button_day,
        nil,
        {
            terminal_name = "open_carnival_window_change_day",
            terminal_state = 0,
            m_day = self._cur_day
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function OpenCarnivalDayCell:onExit()
    local root = self.roots[1]
    cacher.freeRef("activity/open_carnival/open_carnival_day_cell.csb", root)
end

