--------------------------------------------------------------------------------------------------------------
--  科技捐献未解锁cell
--------------------------------------------------------------------------------------------------------------
LegionTechnologyDonateLockCell = class("LegionTechnologyDonateLockCellClass", Window)
LegionTechnologyDonateCellSize = LegionTechnologyDonateCellSize or nil

--创建cell
local legion_technology_donate_lock_cell_create_terminal = {
    _name = "legion_technology_donate_lock_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionTechnologyDonateLockCell:new()
        local index = params[1]
        local science_id = params[2]
        cell:init(index, science_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_technology_donate_lock_cell_create_terminal)
state_machine.init()

function LegionTechnologyDonateLockCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._science_id = 0

    local function init_legion_technology_donate_lock_cell_terminal()
        local legion_technology_donate_lock_cell_look_info_terminal = {
            _name = "legion_technology_donate_lock_cell_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell

                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(legion_technology_donate_lock_cell_look_info_terminal)
        state_machine.init()
    end
    
    init_legion_technology_donate_lock_cell_terminal()
end


function LegionTechnologyDonateLockCell:updateDraw()
    local root = self.roots[1]

    local Panel_technology_icon = ccui.Helper:seekWidgetByName(root, "Panel_technology_icon")
    local Text_technology_name = ccui.Helper:seekWidgetByName(root, "Text_technology_name")
    local Text_technology_lv = ccui.Helper:seekWidgetByName(root, "Text_technology_lv")
    local Text_technology_lock_lv = ccui.Helper:seekWidgetByName(root, "Text_technology_lock_lv")
    Panel_technology_icon:removeAllChildren(true)

    local cell = state_machine.excute("props_icon_create_cell", 0, {4, 3, self._science_id, 11})
    Panel_technology_icon:addChild(cell)

    local name = dms.string(dms["union_science_mould"], self._science_id, union_science_mould.name)
    Text_technology_name:setString(name)
    Text_technology_lv:setString(string.format(red_alert_time_str[33], 0))

    local open_level = dms.int(dms["union_science_mould"], self._science_id, union_science_mould.open_level)
    Text_technology_lock_lv:setString(string.format(tipString_legion_info[18], open_level))
end

function LegionTechnologyDonateLockCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_technology_donate_lock_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if LegionTechnologyDonateCellSize == nil then
        LegionTechnologyDonateCellSize = root:getContentSize()
    end

    self:updateDraw()
end

function LegionTechnologyDonateLockCell:onEnterTransitionFinish()

end

function LegionTechnologyDonateLockCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionTechnologyDonateLockCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_technology_donate_lock_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionTechnologyDonateLockCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_technology_icon = ccui.Helper:seekWidgetByName(root, "Panel_technology_icon")
    local Text_technology_name = ccui.Helper:seekWidgetByName(root, "Text_technology_name")
    local Text_technology_lv = ccui.Helper:seekWidgetByName(root, "Text_technology_lv")
    local Text_technology_lock_lv = ccui.Helper:seekWidgetByName(root, "Text_technology_lock_lv")
    if Panel_technology_icon ~= nil then
        Panel_technology_icon:removeAllChildren(true)
        Text_technology_name:setString("")
        Text_technology_lv:setString("")
        Text_technology_lock_lv:setString("")
    end
end

function LegionTechnologyDonateLockCell:init(index, science_id)
    self._index = index
    self._science_id = science_id

    if index ~= nil and index <= 9 then
        self:onInit()
    end
    self:setContentSize(LegionTechnologyDonateCellSize)
    return self
end

function LegionTechnologyDonateLockCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_technology_donate_lock_cell, self.roots[1])
end

