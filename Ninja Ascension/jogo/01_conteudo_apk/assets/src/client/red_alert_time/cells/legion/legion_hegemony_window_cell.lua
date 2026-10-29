-- ------------------------------------------------------------------------------------------------------------
--  军团争霸各军团报名cell
-- ------------------------------------------------------------------------------------------------------------
LegionHegemonyWindowCell = class("LegionHegemonyWindowCellClass", Window)
LegionHegemonyWindowCell.__size = nil

--创建cell
local legion_hegemony_window_cell_create_terminal = {
    _name = "legion_hegemony_window_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionHegemonyWindowCell:new()
        local index = params[1]
        local info_data = params[2]
        cell:init(index, info_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_hegemony_window_cell_create_terminal)
state_machine.init()

function LegionHegemonyWindowCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_legion_hegemony_window_cell_terminal()

    end
    
    init_legion_hegemony_window_cell_terminal()
end


function LegionHegemonyWindowCell:updateDraw()
    local root = self.roots[1]
    local Text_hegemony_tropps_fight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_tropps_fight_n")
    local Text_hegemony_lv_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_lv_n")
    local Text_hegemony_name_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_name_n")
    local Text_hegemony_pepole_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_pepole_n")

    Text_hegemony_tropps_fight_n:setString(exChangeNumToString(self._info_data.fight_number))
    Text_hegemony_lv_n:setString(self._info_data.level)
    Text_hegemony_name_n:setString(self._info_data.name)
    Text_hegemony_pepole_n:setString(self._info_data.person_number)

end

function LegionHegemonyWindowCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_hegemony_window_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionHegemonyWindowCell.__size == nil then
        LegionHegemonyWindowCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionHegemonyWindowCell:onEnterTransitionFinish()

end

function LegionHegemonyWindowCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionHegemonyWindowCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_window_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionHegemonyWindowCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_hegemony_tropps_fight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_tropps_fight_n")
    local Text_hegemony_lv_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_lv_n")
    local Text_hegemony_name_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_name_n")
    local Text_hegemony_pepole_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_pepole_n")
    if Text_hegemony_tropps_fight_n ~= nil then
        Text_hegemony_tropps_fight_n:setString("")
        Text_hegemony_lv_n:setString("")
        Text_hegemony_name_n:setString("")
        Text_hegemony_pepole_n:setString("")
    end
end

function LegionHegemonyWindowCell:init(index, info_data)
    self._index = index 
    self._info_data = info_data
    if index ~= nil and index <= 9 then
        self:onInit()
    end
    self:setContentSize(LegionHegemonyWindowCell.__size)
    return self
end

function LegionHegemonyWindowCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_window_cell, self.roots[1])
end

