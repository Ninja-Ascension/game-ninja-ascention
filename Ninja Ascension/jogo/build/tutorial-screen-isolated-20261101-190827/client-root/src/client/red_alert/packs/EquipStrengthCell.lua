-----------------------------
--装备强化属性cell
-----------------------------
EquipStrengthCell = class("EquipStrengthCellClass", Window)

local equip_strength_create_cell_terminal = {
    _name = "equip_strength_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local dec_table = params[1]
        local cell = EquipStrengthCell:new()
        cell:init(dec_table)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equip_strength_create_cell_terminal)
state_machine.init()

function EquipStrengthCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.dec_table = nil
    
end

function EquipStrengthCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_title = ccui.Helper:seekWidgetByName(root,"Panel_title")
    local Panel_resove_attirbute = ccui.Helper:seekWidgetByName(root,"Panel_resove_attirbute")
    Panel_title:setVisible(false)
    Panel_resove_attirbute:setVisible(false)

    local Text_resove_cell_attributes_1 = ccui.Helper:seekWidgetByName(root,"Text_resove_cell_attributes_1")
    local Text_resove_cell_strength_number = ccui.Helper:seekWidgetByName(root,"Text_resove_cell_strength_number")
    if self.dec_table == nil then
        Panel_title:setVisible(true)
    else
        Panel_resove_attirbute:setVisible(true)
        Text_resove_cell_attributes_1:setString(self.dec_table.dec_name)
        Text_resove_cell_strength_number:setString(self.dec_table.dec)
    end
end


function EquipStrengthCell:onEnterTransitionFinish()

end

function EquipStrengthCell:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equip_strength_cell)
	local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
	self:addChild(root)
    table.insert(self.roots, root)
    self:setContentSize(root:getContentSize())
	self:onUpdateDraw()	
end

function EquipStrengthCell:init(dec_table)
    self.dec_table = dec_table
	self:onInit()
    return self
end

function EquipStrengthCell:onExit()

end
