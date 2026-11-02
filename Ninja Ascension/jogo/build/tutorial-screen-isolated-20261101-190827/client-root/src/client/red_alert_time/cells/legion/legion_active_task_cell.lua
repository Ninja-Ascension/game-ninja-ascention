-- ------------------------------------------------------------------------------------------------------------
--  军团活跃任务cell
-- ------------------------------------------------------------------------------------------------------------
LegionActiveTaskCell = class("LegionActiveTaskCellClass", Window)
LegionActiveTaskCell.__size = nil

--创建cell
local legion_active_task_create_cell_terminal = {
    _name = "legion_active_task_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionActiveTaskCell:new()
        local index = params[1]
        local task_mould_id = params[2]
        local max_count = params[3]
        cell:init(index, task_mould_id, max_count)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_active_task_create_cell_terminal)
state_machine.init()

function LegionActiveTaskCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._task_mould_id = 0 
    self._max_count = 0

    local function init_legion_active_task_cell_terminal()
        local legion_active_task_cell_goto_terminal = {
            _name = "legion_active_task_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local achievement_mould_id = dms.int(dms["task_mould"], cell._task_mould_id, task_mould.achieve_mould_id)
                local achievement_short_id = dms.int(dms["achievement_mould"],achievement_mould_id,achievement_mould.achievement_short_id)
                state_machine.excute("short_cut_go_to_other_window",0,{achievement_short_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_active_task_cell_goto_terminal)
        state_machine.init()
    end
    init_legion_active_task_cell_terminal()
end

function LegionActiveTaskCell:updateDraw()
    local root = self.roots[1]
    local Panel_active_task_icon = ccui.Helper:seekWidgetByName(root, "Panel_active_task_icon")
    local Text_active_task_name = ccui.Helper:seekWidgetByName(root, "Text_active_task_name")
    local Text_active_task_n = ccui.Helper:seekWidgetByName(root, "Text_active_task_n")
    local Text_active_task_state_n = ccui.Helper:seekWidgetByName(root, "Text_active_task_state_n")
    Panel_active_task_icon:removeAllChildren(true)

    local cell = state_machine.excute("props_icon_create_cell",0,{1,3, self._task_mould_id,9})
    Panel_active_task_icon:addChild(cell) 

    local achievement_id = dms.int(dms["task_mould"], self._task_mould_id, task_mould.achieve_mould_id)
    local achievement_name = dms.string(dms["achievement_mould"], achievement_id, achievement_mould.achievement_name)
    local achievement_dec = dms.string(dms["achievement_mould"], achievement_id, achievement_mould.achievement_dec)
    Text_active_task_name:setString(achievement_name)
    Text_active_task_n:setString(achievement_dec)

    local info = zstring.split(_ED.union_active_info.active_task_count, ",")
    local current_count = tonumber(info[self._index])
    Text_active_task_state_n:setString(current_count.."/"..self._max_count)
end

function LegionActiveTaskCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_active_task_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionActiveTaskCell.__size == nil then
        LegionActiveTaskCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_active_task_go"), nil, 
    {
        terminal_name = "legion_active_task_cell_goto", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)   

    self:updateDraw()
end

function LegionActiveTaskCell:onEnterTransitionFinish()

end

function LegionActiveTaskCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionActiveTaskCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_active_task_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionActiveTaskCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_active_task_icon = ccui.Helper:seekWidgetByName(root, "Panel_active_task_icon")
    local Text_active_task_name = ccui.Helper:seekWidgetByName(root, "Text_active_task_name")
    local Text_active_task_n = ccui.Helper:seekWidgetByName(root, "Text_active_task_n")
    local Text_active_task_state_n = ccui.Helper:seekWidgetByName(root, "Text_active_task_state_n")
    if Panel_active_task_icon ~= nil then
        Panel_active_task_icon:removeAllChildren(true)
        Text_active_task_name:setString("")
        Text_active_task_n:setString("")
        Text_active_task_state_n:setString("")
    end
end

function LegionActiveTaskCell:init(index, task_mould_id, max_count)
    self._index = index
    self._task_mould_id = task_mould_id 
    self._max_count = max_count 
    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(LegionActiveTaskCell.__size)
    return self
end

function LegionActiveTaskCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_active_task_cell, self.roots[1])
end

