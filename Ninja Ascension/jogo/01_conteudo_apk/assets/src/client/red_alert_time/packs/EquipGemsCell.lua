-----------------------------
--装备宝石属性cell
-----------------------------
EquipGemsCell = class("EquipGemsCellClass", Window)

local equip_gems_create_cell_terminal = {
    _name = "equip_gems_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local gem = params[1]
        local show_type = params[2]
        local cell = EquipGemsCell:new()
        cell:init(gem,show_type)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equip_gems_create_cell_terminal)
state_machine.init()

function EquipGemsCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.gem = nil
    self.show_type = nil
end

function EquipGemsCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_resove_title = ccui.Helper:seekWidgetByName(root,"Panel_resove_title")
    local Text_resove_no = ccui.Helper:seekWidgetByName(root,"Text_resove_no")
    local Panel_resove_infor = ccui.Helper:seekWidgetByName(root,"Panel_resove_infor")
    local Panel_resove_cell_2_icon = ccui.Helper:seekWidgetByName(root,"Panel_resove_cell_2_icon")
    Panel_resove_cell_2_icon:removeAllChildren(true)
    Panel_resove_title:setVisible(false)
    Text_resove_no:setVisible(false)
    Panel_resove_infor:setVisible(false)
    if self.show_type == 1 then -- 宝石title
        Panel_resove_title:setVisible(true)
    elseif self.show_type == 2 then -- 无宝石镶嵌
        Text_resove_no:setVisible(true)
    else
        Panel_resove_infor:setVisible(true)
    end

    -- debug.print_r(self.gem)
    if self.gem ~= nil then
        local mould_id = self.gem.mould_id
        local data = 
        {
            item_value = 1,
            prop_type = 34,
            prop_item = mould_id,
        }

        local add_attribute  = dms.string(dms["gems_mould"],mould_id,gems_mould.add_attribute)
        add_attribute = zstring.split(add_attribute,",")
        local text_title = tonumber(add_attribute[1]) + 1
        text_title = attribute[text_title]
        local text_str = tonumber(add_attribute[2])
        text_str = "+" .. text_str
        
        local Text_resove_cell_2_number = ccui.Helper:seekWidgetByName(root,"Text_resove_cell_2_number")
        local Text_resove_cell_2_attributes = ccui.Helper:seekWidgetByName(root,"Text_resove_cell_2_attributes")
        Text_resove_cell_2_attributes:setString(text_title)
        Text_resove_cell_2_number:setString(text_str)
        local cell = state_machine.excute("all_resource_create_cell",0,{5,data,self.gem,8,0})
        Panel_resove_cell_2_icon:addChild(cell)
    end

end


function EquipGemsCell:onEnterTransitionFinish()

end

function EquipGemsCell:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equip_gems_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    self:setContentSize(root:getContentSize())
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function EquipGemsCell:init(gem,show_type)
    self.gem = gem
    -- self.gem = _ED.user_gems["1"]
    self.show_type = show_type
    self:onInit()
    return self
end

function EquipGemsCell:onExit()

end
