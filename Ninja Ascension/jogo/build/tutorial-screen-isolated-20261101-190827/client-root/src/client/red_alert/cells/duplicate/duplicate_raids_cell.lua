--------------------------------------------------------------------------------------------------------------
--  说明：副本扫荡单个控件项
--------------------------------------------------------------------------------------------------------------
DuplicateRaidsCell = class("DuplicateRaidsCellClass", Window)
DuplicateRaidsCell.__size1 = nil
DuplicateRaidsCell.__size2 = nil

local duplicate_raids_create_cell_terminal = {
    _name = "duplicate_raids_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local reward_data = params[1]
        local index = params[2]  
        local list_one = params[3]    
        local cell = DuplicateRaidsCell:new()
        cell:init(reward_data,index,list_one)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_raids_create_cell_terminal)
state_machine.init()

function DuplicateRaidsCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.reward_data = nil 
    self.index = nil
	 -- Initialize DuplicateRaidsCell state machine.
    local function init_duplicate_raids_cell_terminal()
		
        state_machine.init()
    end
    
    -- call func DuplicateRaidsCell create state machine.
    init_duplicate_raids_cell_terminal()

end

function DuplicateRaidsCell:updateDraw()
    local root = self.roots[1]
    local col_number = 1
    local col = self:getAllNumbers()
    local Panel_raids_1 = ccui.Helper:seekWidgetByName(root,"Panel_raids_1")
    local Panel_raids_2 = ccui.Helper:seekWidgetByName(root,"Panel_raids_2")
    local Panel_raids_3 = ccui.Helper:seekWidgetByName(root,"Panel_raids_3")
    Panel_raids_1:setVisible(false)
    Panel_raids_2:setVisible(false)
    Panel_raids_3:setVisible(false)
    if tonumber(col) > 5 then
        col_number = 2
    end
    ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_1"):removeAllChildren(true)
    ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_2"):removeAllChildren(true)
    if self.reward_data == nil and (tonumber(self.index) == 11 or tonumber(self.index) == 2) then 
        Panel_raids = ccui.Helper:seekWidgetByName(root,"Panel_raids_3")
    else
        Panel_raids = ccui.Helper:seekWidgetByName(root,"Panel_raids_"..col_number)
    end
    Panel_raids:setVisible(true)
    local Panel_duplicate_raids_1 = ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_"..col_number)
    Panel_duplicate_raids_1:removeAllChildren(true)
    local Text_duplicate_raids_finish = ccui.Helper:seekWidgetByName(root,"Text_duplicate_raids_finish")
    local Text_duplicate_raids_time = ccui.Helper:seekWidgetByName(root,"Text_duplicate_raids_time_"..col_number)
    local Image_time_bg_1 = ccui.Helper:seekWidgetByName(root,"Image_time_bg_1_"..col_number)
    local Image_time_bg_2 = ccui.Helper:seekWidgetByName(root,"Image_time_bg_2_"..col_number)
    
    if self.reward_data == nil then
        Text_duplicate_raids_finish:setVisible(true)
        Text_duplicate_raids_time:setVisible(false)
        if nil ~= Image_time_bg_1 then
            Image_time_bg_1:setVisible(false)
            Image_time_bg_2:setVisible(false)
        end
        return
    else
        Text_duplicate_raids_finish:setVisible(false)
        Text_duplicate_raids_time:setVisible(true)
        if nil ~= Image_time_bg_1 then
            Image_time_bg_1:setVisible(true)
            Image_time_bg_2:setVisible(true)
        end
        Text_duplicate_raids_time:setString(string.format(red_alert_all_str[14],self.index))
        if tonumber(self.index) == 12 or self.list_one ~= nil then 
            Text_duplicate_raids_time:setString(red_alert_all_str[200])
            Text_duplicate_raids_time:setVisible(false)
            Image_time_bg_1:setVisible(false)
            Image_time_bg_2:setVisible(false)
        end
    end

    local index = 0
    for i,prop in pairs(self.reward_data.show_reward_list) do
        local prop_type = prop.prop_type
        local cell = nil
        if prop_type == 1 then
            cell = state_machine.excute("all_resource_create_cell",0,{2,prop,prop,9,0,false})
        elseif prop_type == 2 then
            cell = state_machine.excute("all_resource_create_cell",0,{2,prop,prop,9,0,false})
        elseif prop_type == 6 then
            local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], prop.prop_item, prop_mould.change_of_equipment))
            local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],prop.prop_item, prop_mould.use_of_ship)) 
            if equipment_mould_id > 0 or ship_mould_id > 0 then  
                cell = state_machine.excute("all_resource_create_cell",0,{3,prop,prop,9,0,false})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,prop,prop,9,0,false})
            end  
        elseif prop_type == 7 then
            cell = state_machine.excute("all_resource_create_cell",0,{6,prop,prop,9,0,false})
            
        elseif prop_type == 13 then
            cell= state_machine.excute("all_resource_create_cell",0,{7,prop,prop,9,0,false})
        elseif prop_type == 34 then
            cell= state_machine.excute("all_resource_create_cell",0,{5,prop,prop,9,0,false})
        elseif prop_type == 36 then
            cell= state_machine.excute("all_resource_create_cell",0,{5,prop,prop,9,0,false})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,prop,prop,9,0,false})
        end 
        cell:setAnchorPoint(cc.p(0,0))
        local cell_height = cell:getContentSize().height
        local cell_width = cell:getContentSize().width
        if col_number == 1 then 
            cell:setPosition(cc.p((i-1)*cell_width,0))
        else
            if tonumber(i) > 5 then 
                cell:setPosition(cc.p((i-6)*cell_width,0))
            else
                cell:setPosition(cc.p((i-1)*cell_width,cell_height))
            end
        end
        Panel_duplicate_raids_1:addChild(cell)
    end
    if col > 5 then
        self:setContentSize(DuplicateRaidsCell.__size2)
    else
        self:setContentSize(DuplicateRaidsCell.__size1)
    end
end

function DuplicateRaidsCell:getAllNumbers( )
    local reward_data = self.reward_data
    if self.reward_data == nil then
        return 1
    end
    return tonumber(reward_data.show_reward_item_count)
end

function DuplicateRaidsCell:getColNumbers( ... )
    if self.reward_data == nil then
        return 1
    end
    local all_numbers = self:getAllNumbers()

    local col = 0
    local col_number = 5
    if all_numbers % col_number == 0 then
        col = all_numbers / col_number
    else
        col = math.floor(all_numbers / col_number) + 1
    end
    return col
end

function DuplicateRaidsCell:onInit() 
    local root = cacher.createUIRef(config_csb.cells.duplicate.duplicate_raids_cell, "root")
    self:addChild(root)
    if DuplicateRaidsCell.__size2 == nil then
        local Panel_raids_2 = ccui.Helper:seekWidgetByName(root,"Panel_raids_2")
        DuplicateRaidsCell.__size2 = Panel_raids_2:getContentSize()
    end
    if DuplicateRaidsCell.__size1 == nil then
        local Panel_raids_1 = ccui.Helper:seekWidgetByName(root,"Panel_raids_1")
        DuplicateRaidsCell.__size1 = Panel_raids_1:getContentSize()
    end

    table.insert(self.roots, root) 
	self:updateDraw()
end

function DuplicateRaidsCell:onEnterTransitionFinish()

end

function DuplicateRaidsCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function DuplicateRaidsCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_duplicate_raids_1 = ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_1")
    Panel_duplicate_raids_1:removeAllChildren(true)
    local Panel_duplicate_raids_2 = ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_2")
    Panel_duplicate_raids_2:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.duplicate.duplicate_raids_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function DuplicateRaidsCell:init(reward_data,index,list_one)
    self.reward_data = reward_data
    self.index = index
    self.list_one = list_one
    if self.index ~= nil and self.index < 4 then
	   self:onInit()
    end
    local col = self:getAllNumbers()
    if col > 5 then
        self:setContentSize(DuplicateRaidsCell.__size2)
    else
        self:setContentSize(DuplicateRaidsCell.__size1)
    end
    return self
end

function DuplicateRaidsCell:onExit()
    local Panel_duplicate_raids_1 = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_duplicate_raids_1")
    if Panel_duplicate_raids_1 ~= nil then
        Panel_duplicate_raids_1:removeAllChildren(true)
    end
    local Panel_duplicate_raids_2 = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_duplicate_raids_2")
    if Panel_duplicate_raids_2 ~= nil then
        Panel_duplicate_raids_2:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.duplicate.duplicate_raids_cell, self.roots[1])
end