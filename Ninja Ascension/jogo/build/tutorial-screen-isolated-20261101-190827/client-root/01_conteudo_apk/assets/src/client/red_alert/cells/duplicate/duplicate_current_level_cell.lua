-----------------------------
--指引箭头
-----------------------------
DuplicateCurrentLevelCell = class("DuplicateCurrentLevelCellClass", Window)

--创建cell
local duplicate_current_level_create_cell_terminal = {
    _name = "duplicate_current_level_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = DuplicateCurrentLevelCell:new()
        cell:init()
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_current_level_create_cell_terminal)
state_machine.init()

function DuplicateCurrentLevelCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end

function DuplicateCurrentLevelCell:onUpdateDraw()

end

function DuplicateCurrentLevelCell:onEnterTransitionFinish()

end

function DuplicateCurrentLevelCell:onInit( )
    local csbItem = csb.createNode(config_csb.cells.duplicate.duplicate_current_level_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- local action = csb.createTimeline(config_csb.cells.duplicate.duplicate_current_level_cell)
    -- action:setTimeSpeed(app.getTimeSpeed())

    -- table.insert(self.actions, action)

    -- csbItem:runAction(action)
    -- action:play("current_Level", true)
    self:onUpdateDraw() 

end

function DuplicateCurrentLevelCell:init() 
    self:onInit()
    return self
end

function DuplicateCurrentLevelCell:onExit()

end
