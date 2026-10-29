-----------------------------
--推送红点
-----------------------------
PushCell = class("PushCellClass", Window)

--创建cell
local puch_create_cell_terminal = {
    _name = "puch_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PushCell:new()
        cell:init()
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(puch_create_cell_terminal)
state_machine.init()

function PushCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end

function PushCell:onUpdateDraw()

end

function PushCell:onEnterTransitionFinish()

end

function PushCell:onInit( )
    local csbItem = csb.createNode(config_csb.cells.push_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 

end

function PushCell:init() 
    self:onInit()
    return self
end

function PushCell:onExit()

end
