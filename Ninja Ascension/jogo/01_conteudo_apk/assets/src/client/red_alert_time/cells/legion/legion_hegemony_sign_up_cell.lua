-- ------------------------------------------------------------------------------------------------------------
--  军团争霸报名cell
-- ------------------------------------------------------------------------------------------------------------
LegionHegemonySignUpCell = class("LegionHegemonySignUpCellClass", Window)
LegionHegemonySignUpCell.__size = nil

--创建cell
local legion_hegemony_sign_up_cell_create_terminal = {
    _name = "legion_hegemony_sign_up_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionHegemonySignUpCell:new()
        local index = params[1]
        local info_data = params[2]
        cell:init(index, info_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_hegemony_sign_up_cell_create_terminal)
state_machine.init()

function LegionHegemonySignUpCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_legion_hegemony_sign_up_cell_terminal()

    end
    
    init_legion_hegemony_sign_up_cell_terminal()
end


function LegionHegemonySignUpCell:updateDraw()
    local root = self.roots[1]
    local Text_hegemony_tropps_fight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_tropps_fight_n")
    local Text_hegemony_lv_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_lv_n")
    local Text_hegemony_name_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_name_n")

    Text_hegemony_tropps_fight_n:setString(exChangeNumToString(self._info_data.fight_number))
    Text_hegemony_lv_n:setString(self._info_data.level)
    Text_hegemony_name_n:setString(self._info_data.name)

    local color = cc.c3b(color_Type[1][1], color_Type[2][2], color_Type[3][3])
    if tonumber(self._info_data.user_id) == tonumber(_ED.user_info.user_id) then
        color = cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3])
    end

    Text_hegemony_tropps_fight_n:setColor(color)
    Text_hegemony_lv_n:setColor(color)
    Text_hegemony_name_n:setColor(color)
end

function LegionHegemonySignUpCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_hegemony_sign_up_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionHegemonySignUpCell.__size == nil then
        LegionHegemonySignUpCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionHegemonySignUpCell:onEnterTransitionFinish()

end

function LegionHegemonySignUpCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionHegemonySignUpCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_sign_up_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionHegemonySignUpCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_hegemony_tropps_fight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_tropps_fight_n")
    local Text_hegemony_lv_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_lv_n")
    local Text_hegemony_name_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_name_n")
    if Text_hegemony_tropps_fight_n ~= nil then
        Text_hegemony_tropps_fight_n:setString("")
        Text_hegemony_lv_n:setString("")
        Text_hegemony_name_n:setString("")
    end
end

function LegionHegemonySignUpCell:init(index, info_data)
    self._index = index 
    self._info_data = info_data
    if index ~= nil and index <= 11 then
        self:onInit()
    end
    self:setContentSize(LegionHegemonySignUpCell.__size)
    return self
end

function LegionHegemonySignUpCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_sign_up_cell, self.roots[1])
end

