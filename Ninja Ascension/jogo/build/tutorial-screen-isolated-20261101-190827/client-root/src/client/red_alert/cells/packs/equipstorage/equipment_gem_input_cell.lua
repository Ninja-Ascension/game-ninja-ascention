--------------------------------------------------------------------------------------------------------------
--  说明：副本单个控件项
--------------------------------------------------------------------------------------------------------------
EquipmentGemInputCell = class("EquipmentGemInputCellClass", Window)
EquipmentGemInputCell.__size = nil

local equipment_gem_input_create_cell_terminal = {
    _name = "equipment_gem_input_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local gem_id = params[2]
        local equip = params[3]
        local cell = EquipmentGemInputCell:new()
        cell:init(index,gem_id,equip)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_gem_input_create_cell_terminal)
state_machine.init()

function EquipmentGemInputCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.index = nil
    self.gem_id = nil
    self.equip = nil
	 -- Initialize equipment_gem_input_cell state machine.
    local function init_equipment_gem_input_cell_terminal()

		local equipment_gem_input_cell_inlay_terminal = {
            _name = "equipment_gem_input_cell_inlay",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell 
                state_machine.excute("equipment_gem_input_window_open",0,{cell.index,cell.equip})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local equipment_gem_input_cell_level_up_terminal = {
            _name = "equipment_gem_input_cell_level_up",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell 
                state_machine.excute("equipment_gem_attribute_window_open",0,{cell.equip,cell.index,cell.gem_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local equipment_gem_input_cell_no_gems_can_inlay_terminal = {
            _name = "equipment_gem_input_cell_no_gems_can_inlay",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog(red_alert_all_str[82])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(equipment_gem_input_cell_inlay_terminal)
        state_machine.add(equipment_gem_input_cell_level_up_terminal)
        state_machine.add(equipment_gem_input_cell_no_gems_can_inlay_terminal)
        state_machine.init()
    end
    
    -- call func DuplicateListCell create state machine.
    init_equipment_gem_input_cell_terminal()

end

function EquipmentGemInputCell:checkIsCanInlay()
    local table_gem_type = {}
    for i,v in pairs(self.equip.jewelrys) do
        if tonumber(v) ~= 0 then
            local gem = _ED.user_gems[""..v]
            local gem_type = dms.int(dms["gems_mould"],gem.mould_id,gems_mould.gem_type)
            table.insert(table_gem_type,gem_type)
        end
    end

    for i,v in pairs(_ED.user_gems) do
        local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
        local have_type = false
        for k,m in pairs(table_gem_type) do
            if gem_type == m then
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

function EquipmentGemInputCell:updateDraw()
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
        if self:checkIsCanInlay() == true then
        --打开宝石镶嵌
            fwin:addTouchEventListener(Button_icon_bg, nil, 
            {
                terminal_name = "equipment_gem_input_cell_inlay", 
                terminal_state = 0,
                cell = self, 
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }, nil, 0)
            local actions = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.3,1.1),cc.ScaleTo:create(0.3,1)))
            Image_icon_bg_1:setVisible(true)
            Button_icon_bg:runAction(actions)
        else
            --没有可以镶嵌的宝石
            fwin:addTouchEventListener(Button_icon_bg, nil, 
            {
                terminal_name = "equipment_gem_input_cell_no_gems_can_inlay", 
                terminal_state = 0,
                cell = self, 
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }, nil, 0)
            Image_icon_bg_1:setVisible(false)
            Button_icon_bg:stopAllActions()
       end
    else
        Panel_gem_icon:setVisible(true)
        Panel_gem_icon:removeAllChildren(true)
        Panel_gem_icon:setTouchEnabled(true)
        local gem = _ED.user_gems[""..self.gem_id]
        local data = 
        {
            item_value = 1,
            prop_type = 34,
            prop_item = gem.mould_id,
        }
        local cell = state_machine.excute("all_resource_create_cell",0,{7,data,gem,8,0,true,true,3})
        Panel_gem_icon:addChild(cell)

        --打开宝石融合
        fwin:addTouchEventListener(Panel_gem_icon, nil, 
        {
            terminal_name = "equipment_gem_input_cell_level_up", 
            terminal_state = 0,
            cell = self, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
    end
end



function EquipmentGemInputCell:onInit() 
    local root = cacher.createUIRef(config_csb.cells.packs.equipstorage.equipment_gem_input_cell,"root")
    self:addChild(root)    
    table.insert(self.roots, root) 

    local Button_icon_bg = ccui.Helper:seekWidgetByName(root,"Button_icon_bg")
    if EquipmentGemInputCell.__size == nil then
        local __size = Button_icon_bg:getContentSize()
        EquipmentGemInputCell.__size = __size
    end
	self:updateDraw()
end

function EquipmentGemInputCell:onEnterTransitionFinish()

end

--清除缓存
function EquipmentGemInputCell:close()
    local root = self.roots[1]
    local Panel_gem_icon = ccui.Helper:seekWidgetByName(root,"Panel_gem_icon")
    Panel_gem_icon:removeAllChildren(true)
end

function EquipmentGemInputCell:init(index,gem_id,equip)
	self.index = index
    self.gem_id = tonumber(gem_id)
    self.equip = equip
    self:onInit()
    self:setContentSize(EquipmentGemInputCell.__size)
end

function EquipmentGemInputCell:onExit()
    local Panel_gem_icon = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_gem_icon")
    if Panel_gem_icon ~= nil then
        Panel_gem_icon:removeAllChildren(true)
    end
   cacher.freeRef(config_csb.cells.packs.equipstorage.equipment_gem_input_cell, self.roots[1])
end