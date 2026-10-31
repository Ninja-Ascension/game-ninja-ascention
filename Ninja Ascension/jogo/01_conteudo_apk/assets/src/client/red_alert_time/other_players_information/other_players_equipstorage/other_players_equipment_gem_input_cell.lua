--------------------------------------------------------------------------------------------------------------
--  说明：副本单个控件项
--------------------------------------------------------------------------------------------------------------
OtherPlayersEquipmentGemInputCell = class("OtherPlayersEquipmentGemInputCellClass", Window)
OtherPlayersEquipmentGemInputCell.__size = nil

local other_players_equipment_gem_input_create_cell_terminal = {
    _name = "other_players_equipment_gem_input_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local gem_id = params[2]
        local equip = params[3]
        local cell = OtherPlayersEquipmentGemInputCell:new()
        cell:init(index,gem_id,equip)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_equipment_gem_input_create_cell_terminal)
state_machine.init()

function OtherPlayersEquipmentGemInputCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.index = nil
    self.gem_id = nil
    self.equip = nil
	 -- Initialize other_players_equipment_gem_input_cell state machine.
    local function init_other_players_equipment_gem_input_cell_terminal()
		
        state_machine.init()
    end
    
    -- call func DuplicateListCell create state machine.
    init_other_players_equipment_gem_input_cell_terminal()

end

function OtherPlayersEquipmentGemInputCell:checkIsCanInlay()
    local table_gem_type = {}
    for i,v in pairs(self.equip.jewelrys) do
        if tonumber(v) ~= 0 then
            local gem = _ED.other_user_gems[""..v]
            local gem_type = dms.int(dms["gems_mould"],gem.mould_id,gems_mould.gem_type)
            table.insert(table_gem_type,gem_type)
        end
    end

    for i,v in pairs(_ED.other_user_gems) do
        local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
        local have_type = false
        for i,v in pairs(table_gem_type) do
            if gem_type == v then
                have_type = true
                break
            end
        end

        if tonumber(v.equip_id) > 0 or have_type == true then
        else
            return true
        end
    end
    return false
end

function OtherPlayersEquipmentGemInputCell:updateDraw()
    local root = self.roots[1]
    -- print("========scenceID",tonumber(_ED.scene_current_state[self.scenceID]),self.scenceID)
    local Button_icon_bg = ccui.Helper:seekWidgetByName(root,"Button_icon_bg")
    local Panel_gem_icon = ccui.Helper:seekWidgetByName(root,"Panel_gem_icon")
    local Image_icon_bg_1 = ccui.Helper:seekWidgetByName(root,"Image_icon_bg_1")
    Button_icon_bg:setVisible(false)
    Panel_gem_icon:setVisible(false)
    Image_icon_bg_1:setVisible(false)
    if self.gem_id == 0 then 
        Button_icon_bg:setVisible(true)
    else
        Panel_gem_icon:setVisible(true)
        Panel_gem_icon:removeAllChildren(true)
        Panel_gem_icon:setTouchEnabled(true)
        local gem = _ED.other_user_gems[""..self.gem_id]
        local data = 
        {
            item_value = 1,
            prop_type = 34,
            prop_item = gem.mould_id,
        }
        local cell = state_machine.excute("all_resource_create_cell",0,{7,data,gem,8,0})
        Panel_gem_icon:addChild(cell)
    end
end



function OtherPlayersEquipmentGemInputCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.packs.equipstorage.equipment_gem_input_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)    
    table.insert(self.roots, root) 

    local Button_icon_bg = ccui.Helper:seekWidgetByName(root,"Button_icon_bg")
    if OtherPlayersEquipmentGemInputCell.__size == nil then
        local __size = Button_icon_bg:getContentSize()
        OtherPlayersEquipmentGemInputCell.__size = __size
    end
	self:updateDraw()
end

function OtherPlayersEquipmentGemInputCell:onEnterTransitionFinish()

end

function OtherPlayersEquipmentGemInputCell:init(index,gem_id,equip)
	self.index = index
    self.gem_id = tonumber(gem_id)
    self.equip = equip
    self:onInit()
    self:setContentSize(OtherPlayersEquipmentGemInputCell.__size)
end

function OtherPlayersEquipmentGemInputCell:onExit()
  
end