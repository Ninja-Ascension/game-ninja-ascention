-- ------------------------------------------------------------------------------------------------------------
--  征战增益详情
-- ------------------------------------------------------------------------------------------------------------
PveTroopsAttributeCell = class("PveTroopsAttributeCellClass", Window)
PveTroopsAttributeCell.__size = nil

--创建cell
local pve_troops_attribute_cell_create_terminal = {
    _name = "pve_troops_attribute_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PveTroopsAttributeCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(pve_troops_attribute_cell_create_terminal)
state_machine.init()

function PveTroopsAttributeCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._talent_id = 0
    self._have_lv = 0
    local function init_pve_troops_attribute_cell_terminal()
        
        state_machine.init()
    end
    
    init_pve_troops_attribute_cell_terminal()
end

function PveTroopsAttributeCell:updateDraw()
    local root = self.roots[1]
    local talent_mould_element = dms.element(dms["talent_mould"],self._talent_id)
    -- name
    local Text_attribute_name = ccui.Helper:seekWidgetByName(root,"Text_attribute_name")
    local talent_name = dms.atos(talent_mould_element, talent_mould.talent_name)
    Text_attribute_name:setString(talent_name)

    -- Lv
    local Text_attribute_lv = ccui.Helper:seekWidgetByName(root,"Text_attribute_lv")
    Text_attribute_lv:setString(string.format(red_alert_all_str[117],self._index))

    local Text_attribute_state = ccui.Helper:seekWidgetByName(root,"Text_attribute_state")
    if self._have_lv >= self._index then
        Text_attribute_state:setString(red_alert_time_str[105])
        Text_attribute_state:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
    else
        Text_attribute_state:setString(red_alert_time_str[104])
        Text_attribute_state:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    end

    local Text_attribute_infor = ccui.Helper:seekWidgetByName(root,"Text_attribute_infor")
    local talent_describe = dms.atos(talent_mould_element, talent_mould.talent_describe)
    Text_attribute_infor:setString(talent_describe)

    local Text_attribute_lock_t = ccui.Helper:seekWidgetByName(root,"Text_attribute_lock_t")
    Text_attribute_lock_t:setString(red_alert_time_str[106])

    local Text_attribute_lock_infor = ccui.Helper:seekWidgetByName(root,"Text_attribute_lock_infor")
    local talent_star_dec = dms.atos(talent_mould_element, talent_mould.talent_star_dec)
    Text_attribute_lock_infor:setString(talent_star_dec)
    

end

function PveTroopsAttributeCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.pve.pve_troops_attribute_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if PveTroopsAttributeCell.__size == nil then
        PveTroopsAttributeCell.__size = root:getContentSize()
    end


    self:updateDraw()
end

function PveTroopsAttributeCell:onEnterTransitionFinish()

end

function PveTroopsAttributeCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PveTroopsAttributeCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.pve.pve_troops_attribute_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function PveTroopsAttributeCell:clearUIInfo()
    local root = self.roots[1]
    local Text_attribute_name = ccui.Helper:seekWidgetByName(root, "Text_attribute_name")
    local Text_attribute_lv = ccui.Helper:seekWidgetByName(root, "Text_attribute_lv")
    local Text_attribute_state = ccui.Helper:seekWidgetByName(root, "Text_attribute_state")
    local Text_attribute_infor = ccui.Helper:seekWidgetByName(root, "Text_attribute_infor")
    local Text_attribute_lock_infor = ccui.Helper:seekWidgetByName(root, "Text_attribute_lock_infor")
    if Text_attribute_name ~= nil then
        Text_attribute_name:setString("")
        Text_attribute_lv:setString("")
        Text_attribute_state:setString("")
        Text_attribute_infor:setString("")
        Text_attribute_lock_infor:setString("")
    end
end

function PveTroopsAttributeCell:init(params)
    self._index = params[1]
    self._talent_id = params[2]
    self._have_lv = params[3]
    if self._index ~= nil and self._index <= 7 then
        self:onInit()
    end
    self:setContentSize(PveTroopsAttributeCell.__size)
    return self
end

function PveTroopsAttributeCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.pve.pve_troops_attribute_cell, self.roots[1])
end

