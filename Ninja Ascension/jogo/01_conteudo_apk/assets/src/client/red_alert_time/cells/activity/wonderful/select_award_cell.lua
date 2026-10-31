--------------------------------------
-- 多选一宝箱cell
--------------------------------------
SelectAwardCell = class("SelectAwardCellClass", Window)
SelectAwardCell.__size = nil

local select_award_cell_create_terminal = {
    _name = "select_award_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SelectAwardCell:new()
        local index = params[1]
        local reward_info = params[2]
        cell:init(index, reward_info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(select_award_cell_create_terminal)
state_machine.init()

function SelectAwardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0                 -- 

    local function init_personal_fight_ranking_cell_terminal()
        local select_award_cell_select_index_terminal = {
            _name = "select_award_cell_select_index",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("activity_select_award_change_select_index", 0, cell._index)
                cell:setSelect(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(select_award_cell_select_index_terminal)
    end

    init_personal_fight_ranking_cell_terminal()
end

function SelectAwardCell:init(index, reward_info)
    self._index = index
    self._reward_info = reward_info

    -- if index ~= nil and index < 5 then
    --     self:onInit()
    -- end
    self:onInit()

    self:setContentSize(SelectAwardCell.__size)
end

function SelectAwardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.select_award_cell, "root")
    self:addChild(root)
    table.insert(self.roots, root)
    
    if SelectAwardCell.__size == nil then
        SelectAwardCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_in_1"), nil, 
    {
        terminal_name = "select_award_cell_select_index", 
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 2)

    self:updateDraw()
end

function SelectAwardCell:updateDraw()
    local root = self.roots[1]

    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_1")
    local Image_hook = ccui.Helper:seekWidgetByName(root, "Image_hook_1")
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_1")
    

    Image_hook:setVisible(false)

    local reward_info = zstring.split(self._reward_info, ",")
    local data = {
        item_value = tonumber(reward_info[3]),
        prop_type = tonumber(reward_info[2]),
        prop_item = tonumber(reward_info[1]),
    }

    Panel_props_icon:removeAllChildren(true)
    local cell = nil
    if tonumber(data.prop_type) == 6 then    
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment)) > 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,touch_type,0,false,false})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,false})
        end  
    elseif tonumber(data.prop_type) == 34 then    
        cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,touch_type,0,false,false})   
    else
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,false})
    end
    Panel_props_icon:addChild(cell)

    local name = reward_prop_list[data.prop_type]
    local quality = 4
    local prop_id = data.prop_item
    local prop_type = data.prop_type
    if prop_type == 6 then
        name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
        quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)
    elseif prop_type == 7 then
        name = dms.string(dms["equipment_mould"],prop_id,equipment_mould.equipment_name)
        quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
    elseif prop_type == 13 then
        name = dms.string(dms["ship_mould"],prop_id,ship_mould.captain_name)
        quality = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)
    elseif prop_type == 34 then
        quality = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
        name = dms.string(dms["gems_mould"],prop_id,gems_mould.name)
    elseif prop_type == 35 then
        quality = dms.int(dms["horse_mould"], prop_id, horse_mould.quality)
        name = dms.string(dms["horse_mould"], prop_id, horse_mould.horse_name)
    elseif prop_type == 36 then
        quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
        name = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.horse_spirit_name)
    end
    Text_name:setString(name)
    Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

end

function SelectAwardCell:setSelect(flag)
    local Image_hook = ccui.Helper:seekWidgetByName(self.roots[1], "Image_hook_1")
    Image_hook:setVisible(flag)
end

function SelectAwardCell:onExit()
    -- cacher.freeRef(config_csb.cells.activity.wonderful.select_award_cell, self.roots[1])
end

function SelectAwardCell:onEnterTransitionFinish()

end

function SelectAwardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SelectAwardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.select_award_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end