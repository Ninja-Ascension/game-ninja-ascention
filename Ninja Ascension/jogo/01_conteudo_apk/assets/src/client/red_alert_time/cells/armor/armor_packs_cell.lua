----------------------------------------------------------------------------------------------------
-- 说明：装甲仓库列表cell
-------------------------------------------------------------------------------------------------------
ArmorPacksCell = class("ArmorPacksCellClass", Window)
ArmorPacksCell.__size = nil

local armor_packs_cell_create_terminal = {
    _name = "armor_packs_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArmorPacksCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_packs_cell_create_terminal)
state_machine.init()

function ArmorPacksCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._prop_type = 0             -- 1：装甲，2：经验
    self._info = nil
    self._state = 0                 -- 1：仓库，2：出售，3：升级

    self._is_selected = false       -- 是否选中
    self._cost = 0                  -- 获得宝石/经验值
    self._id = 0                    -- 实例id

    local function init_armor_packs_cell_terminal()
        -- 升级
        local armor_packs_cell_up_terminal = {
            _name = "armor_packs_cell_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local armor_info = cell._info
                state_machine.excute("armor_up_window_open", 0, {armor_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_packs_cell_update_info_terminal = {
            _name = "armor_packs_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params.cell
                local index = params.index
                cell._info = params._info
                cell._prop_type = params._prop_type
                if cell._info ~= nil and cell._prop_type > 0 then
                    cell:getArmorCost()
                    if index <= 8 then
                        cell:reload()
                        cell:onUpdateDraw()
                    else
                        cell:unload()
                    end
                end
                cell:setSelected(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_packs_cell_change_state_terminal = {
            _name = "armor_packs_cell_change_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                cell._state = params[2]
                cell:getArmorCost()
                if cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:changeState()
                end
                cell:setSelected(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_packs_cell_change_selected_terminal = {
            _name = "armor_packs_cell_change_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local is_selected = params._datas.is_selected
                cell._is_selected = is_selected

                local add_gem = cell._cost
                if cell._is_selected == false then
                    add_gem = -add_gem
                end
                if cell._state == 2 then
                    state_machine.excute("armor_pack_update_sell_gem", 0, add_gem)
                elseif cell._state == 3 then
                    state_machine.excute("armor_up_update_get_exp", 0, add_gem)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 批量选择是否选中
        local armor_packs_cell_set_batch_choose_terminal = {
            _name = "armor_packs_cell_set_batch_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                local selected_tables = params[2]
                cell:setBatchChoose(selected_tables)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(armor_packs_cell_up_terminal)
        state_machine.add(armor_packs_cell_update_info_terminal)
        state_machine.add(armor_packs_cell_change_state_terminal)
        state_machine.add(armor_packs_cell_change_selected_terminal)
        state_machine.add(armor_packs_cell_set_batch_choose_terminal)
        state_machine.init()
    end
    init_armor_packs_cell_terminal()         
end

function ArmorPacksCell:setBatchChoose(selected_tables)
    local index = 1
    if self._prop_type == 1 then
        index = self._info.grow_level + 1
    elseif self._prop_type == 2 then
        index = self._info.quality + 1
    end

    local is_selected = selected_tables[self._prop_type][index]
    self:setSelected(is_selected)
end

function ArmorPacksCell:isSelected()
    return self._is_selected
end

function ArmorPacksCell:setSelected(selected)
    self._is_selected = selected
    if self.roots ~= nil and self.roots[1] ~= nil then
        local root = self.roots[1]
        local CheckBox_armor_packs_choose = ccui.Helper:seekWidgetByName(root,"CheckBox_armor_packs_choose")
        CheckBox_armor_packs_choose:setSelected(self._is_selected)
    end
end

function ArmorPacksCell:getArmorCost()
    if self._prop_type == 1 then
        self._id = self._info.equip_id
        if self._state == 2 then
            self._cost = dms.int(dms["equipment_mould"], self._info.equipment_mould_id, equipment_mould.silver_price)
        elseif self._state == 3 then
            local init_exp = dms.int(dms["equipment_mould"], self._info.equipment_mould_id, equipment_mould.initial_supply_escalate_exp)
            local level = tonumber(self._info.upgrade_level)
            local quailty = tonumber(self._info.grow_level)
            self._cost = init_exp
            for i = 2, level do
                local add_exp = dms.int(dms["equipment_level_requirement"], i, equipment_level_requirement.need_exp_1 + quailty)
                self._cost = self._cost + add_exp
            end
        end
    elseif self._prop_type == 2 then
        self._id = self._info.user_prop_id
        if self._state == 2 then
            self._cost = self._info.sell_system_price
        elseif self._state == 3 then
            self._cost = dms.int(dms["prop_mould"], self._info.user_prop_template, prop_mould.buff_of_battle_experience_count)
        end
    end
end

function ArmorPacksCell:changeState()
    local root = self.roots[1]
    local Button_armor_packs_up = ccui.Helper:seekWidgetByName(root,"Button_armor_packs_up")
    local Text_armor_packs_exp_n = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_exp_n")
    local CheckBox_armor_packs_choose = ccui.Helper:seekWidgetByName(root,"CheckBox_armor_packs_choose")

    if self._prop_type == 1 and self._state == 1 then
        Button_armor_packs_up:setVisible(true)
    else
        Button_armor_packs_up:setVisible(false)
    end
    if self._state == 1 then
        Text_armor_packs_exp_n:setVisible(false)
        CheckBox_armor_packs_choose:setVisible(false)
    elseif self._state == 2 then
        Text_armor_packs_exp_n:setVisible(true)
        CheckBox_armor_packs_choose:setVisible(true)
        Text_armor_packs_exp_n:setString(armor_tip_str[11]..exChangeNumToString(self._cost))
    elseif self._state == 3 then
        Text_armor_packs_exp_n:setVisible(true)
        CheckBox_armor_packs_choose:setVisible(true)
        Text_armor_packs_exp_n:setString(armor_tip_str[12]..exChangeNumToString(self._cost))
    end
end

function ArmorPacksCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_armor_packs_icon = ccui.Helper:seekWidgetByName(root,"Panel_armor_packs_icon")
    local Text_armor_packs_exp_name = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_exp_name")
    local Text_armor_packs_skill = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_skill")
    local Text_armor_packs_exp_infor = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_exp_infor")
    local CheckBox_armor_packs_choose = ccui.Helper:seekWidgetByName(root,"CheckBox_armor_packs_choose")
    Panel_armor_packs_icon:removeAllChildren(true)

    local quality = 0
    if self._prop_type == 1 then
        local cell = state_machine.excute("props_icon_create_cell", 0, {8, 14, self._info.equipment_mould_id, 15, nil, nil, self._info})
        Panel_armor_packs_icon:addChild(cell)
        Text_armor_packs_exp_name:setString(self._info.equipment_name)
        Text_armor_packs_exp_infor:setString(self._info.trace_remarks)
        quality = self._info.grow_level

        local attr_info = zstring.split(self._info.attr, ",")
        local attr_name = red_alert_time_attribute[tonumber(attr_info[1]) + 1]
        local attr_value = tonumber(attr_info[2])
        Text_armor_packs_skill:setString(""..attr_name.."+"..attr_value.."%")
    else
         local cell = state_machine.excute("props_icon_create_cell", 0, {4, 1, self._info.user_prop_template, 1})
        Panel_armor_packs_icon:addChild(cell)

        Text_armor_packs_exp_name:setString(self._info.prop_name)
        Text_armor_packs_skill:setString("")
        Text_armor_packs_exp_infor:setString(self._info.prop_function_remark)
        quality = self._info.quality
    end
    CheckBox_armor_packs_choose:setSelected(self._is_selected)

    if __lua_project_id == __lua_project_pacific_rim then
        Text_armor_packs_exp_name:setColor(cc.c3b(color_Type[quality + 1][1], color_Type[quality + 1][2], color_Type[quality + 1][3]))
    end

    self:changeState()
end

function ArmorPacksCell:onEnterTransitionFinish()

end

function ArmorPacksCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.armor.armor_packs_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if ArmorPacksCell.__size == nil then
        ArmorPacksCell.__size = root:getContentSize()
    end

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_armor_packs_up"), nil, 
    {
        terminal_name = "armor_packs_cell_up",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    local function checkboxTouchListener( sender, eventType )
        if eventType == ccui.CheckBoxEventType.selected then
            state_machine.excute("armor_packs_cell_change_selected", 0, {_datas = {cell = self, is_selected = true}})
        elseif eventType == ccui.CheckBoxEventType.unselected then
            state_machine.excute("armor_packs_cell_change_selected", 0, {_datas = {cell = self, is_selected = false}})
        end
    end
    local CheckBox_armor_packs_choose = ccui.Helper:seekWidgetByName(root,"CheckBox_armor_packs_choose")
    CheckBox_armor_packs_choose:addEventListener(checkboxTouchListener)

    self:onUpdateDraw()
end

function ArmorPacksCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_packs_cell, self.roots[1])
end

function ArmorPacksCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ArmorPacksCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_packs_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ArmorPacksCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_armor_packs_icon = ccui.Helper:seekWidgetByName(root,"Panel_armor_packs_icon")
    local Text_armor_packs_exp_name = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_exp_name")
    local Text_armor_packs_exp_infor = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_exp_infor")
    local Text_armor_packs_exp_n = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_exp_n")
    local Text_armor_packs_skill = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_skill")
    if Panel_armor_packs_icon ~= nil then
        Panel_armor_packs_icon:removeAllChildren(true)
        Text_armor_packs_exp_name:setString("")
        Text_armor_packs_exp_infor:setString("")
        Text_armor_packs_exp_n:setString("")
        Text_armor_packs_skill:setString("")
    end
end

function ArmorPacksCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._prop_type = params[3]             -- 1：装甲，2：经验
    self._state = params[4]                 -- 1：仓库，2：出售，3：升级

    self:getArmorCost()

    if self._index <= 8 then
       self:onInit()
    end
    self:setContentSize(ArmorPacksCell.__size)
end

