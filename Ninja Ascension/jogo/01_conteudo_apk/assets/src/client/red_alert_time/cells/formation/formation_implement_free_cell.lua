----------------------------------------------------------------------------------------------------
-- 说明：行军队列空闲列表cell
-------------------------------------------------------------------------------------------------------
FormationImplementFreeCell = class("FormationImplementFreeCellClass", Window)
FormationImplementFreeCell.__size = nil

local formation_implement_free_cell_create_terminal = {
    _name = "formation_implement_free_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = FormationImplementFreeCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_implement_free_cell_create_terminal)
state_machine.init()

function FormationImplementFreeCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0

    local function init_formation_implement_free_cell_terminal()
        local formation_implement_free_cell_goto_terminal = {
            _name = "formation_implement_free_cell_goto",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("short_cut_go_to_other_window", 0, {14})
                state_machine.excute("formation_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(formation_implement_free_cell_goto_terminal)
        state_machine.init()
    end
    init_formation_implement_free_cell_terminal()         
end

function FormationImplementFreeCell:onUpdateDraw()
    local root = self.roots[1]

end


function FormationImplementFreeCell:onEnterTransitionFinish()

end

function FormationImplementFreeCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_implement_free_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if FormationImplementFreeCell.__size == nil then
        FormationImplementFreeCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_quicken") , nil, 
    {
        terminal_name = "formation_implement_free_cell_goto", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)  

    self:onUpdateDraw()
end

function FormationImplementFreeCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_implement_free_cell, self.roots[1])
end

function FormationImplementFreeCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function FormationImplementFreeCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_implement_free_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationImplementFreeCell:clearUIInfo()
    local root = self.roots[1]
end

function FormationImplementFreeCell:init(params)
    self._index = params[1]

    self:onInit()
    self:setContentSize(FormationImplementFreeCell.__size)
end

