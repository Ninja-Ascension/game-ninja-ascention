--------------------------------------------------------------------------------------------------------------
--  说明：大师训练营兑换cell
--------------------------------------------------------------------------------------------------------------
training_camp_change_list_cell = class("training_camp_change_list_cellClass", Window)
training_camp_change_list_cell.__size = nil

--创建cell
local training_camp_change_list_cell_terminal = {
    _name = "training_camp_change_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = training_camp_change_list_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(training_camp_change_list_cell_terminal)
state_machine.init()

function training_camp_change_list_cell:ctor()
	self.super:ctor()
	self.roots = {}
    self.activity = {}
    self._idex = 1
    self.unlock = false -- 是否可以解锁
    self.porinfo = {} 
    app.load("client.activity.traingcamp.TrainigCampChange")
end

function training_camp_change_list_cell:updateDrawInfo()
    local root = self.roots[1]
    local info = json.decode(_ED.active_activity[157].activity_params)
   
    local Image_icon_change_choose = ccui.Helper:seekWidgetByName(root, "Image_icon_change_choose")  --选择框
    Image_icon_change_choose:setVisible(false)
    
    local Text_camp_name = ccui.Helper:seekWidgetByName(root, "Text_camp_name")  --名称
    local Panel_camp_change_icon = ccui.Helper:seekWidgetByName(root, "Panel_camp_change_icon")  --图标
    Panel_camp_change_icon:removeAllChildren(true)
    local rewards = zstring.split(_ED.training_camp_reward_info.exchangeReard[self._idex], ",")
    if #(rewards[1]) ~= 0 then
        local rewardType = zstring.tonumber(rewards[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if rewards[4] ~= nil and tonumber(rewards[4]) ~= -1 then
                table.shipStar = tonumber(rewards[4])
            end
            cell:init(rewardType,0, tonumber(rewards[2]),nil,nil,nil,false,1,table)
        else
            cell:init(rewardType, 0, tonumber(rewards[2]),nil,nil,nil,false,1)
        end
       
        Panel_camp_change_icon:addChild(cell) 
        local props = self:getPropByType(rewardType,tonumber(rewards[2]))

        Text_camp_name:setString(props.mould_name.." x"..rewards[3])
        local quality = tonumber(props.prop_quality)
        Text_camp_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))

        self.porinfo = {props.mould_name,quality}
    end
    self:onUpdateInfo()
end

function training_camp_change_list_cell:onUpdateInfo( )
    local Panel_change_props_unlock = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_change_props_unlock")  --解锁
    local Text_change_buy_time = ccui.Helper:seekWidgetByName(self.roots[1], "Text_change_buy_time")    --限购
    local info = json.decode(_ED.active_activity[157].activity_params)
    
    if tonumber(self.activity[4]) == 1 then
        Text_change_buy_time:setString(string.format(tipStringInfo_training_camp_name[1],info.exchange_info["".. self._idex]).."/"..self.activity[5])
    elseif tonumber(self.activity[4]) == 2 then
        Text_change_buy_time:setString(string.format(tipStringInfo_training_camp_name[2],info.exchange_info["".. self._idex]).."/"..self.activity[5])
    else
        Text_change_buy_time:setString(tipStringInfo_training_camp_name[7])
    end
    if  tonumber(self.activity[6]) > tonumber(info.userActivityInfo.level) then
        Panel_change_props_unlock:setVisible(true)
       Text_change_buy_time:setString(string.format(tipStringInfo_training_camp_name[3],self.activity[6]))
    else
        Panel_change_props_unlock:setVisible(false)
    end
end

function training_camp_change_list_cell:getPropByType(_type,mould_id)
    local prop = {}
    prop.type= _type
    prop.mould_id = mould_id
    local prop_info = nil
    if prop.type == 6 then
        prop_info = dms.element(dms["prop_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                prop.mould_name = setThePropsIcon(prop.mould_id)[2]
            end
        end
        if prop.prop_quality == nil then
            prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
        end
        prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            prop.mould_remarks = drawPropsDescription(prop.mould_id)
        end
    elseif prop.type == 7 then
        prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
        end
        prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
        if prop.prop_quality == 0 then
            prop.prop_quality = 3
        end
        prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
    end
    return prop
end

function training_camp_change_list_cell:onUpdate(dt)
    
end


function training_camp_change_list_cell:onInit()
    local root  = cacher.createUIRef("activity/wonderful/training_camp_change_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
    if training_camp_change_list_cell.__size == nil then
        training_camp_change_list_cell.__size = root:getContentSize()
    end
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_camp_buy"), nil, 
    {
        terminal_name = "training_camp_change_check", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
        idex= self._idex,
        lock_state = self.unlock,
        popinfo = self.porinfo,
    }, nil, 1)
     
    self:clearUIInfo()
	self:updateDrawInfo()
end

function training_camp_change_list_cell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function training_camp_change_list_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_change_buy_time = ccui.Helper:seekWidgetByName(root, "Text_change_buy_time")    --限购
    local Text_camp_name = ccui.Helper:seekWidgetByName(root, "Text_camp_name")  --名称
    local Panel_camp_change_icon = ccui.Helper:seekWidgetByName(root, "Panel_camp_change_icon")  --图标
    
    if Text_change_buy_time then
        Text_change_buy_time:setString("")
        Text_camp_name:setString("")
        Panel_camp_change_icon:removeAllChildren(true)
    end
end

function training_camp_change_list_cell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function training_camp_change_list_cell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/training_camp_change_cell.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function training_camp_change_list_cell:init(params)
    self.activity = params[1][1]
    self._idex = params[2]
	self:onInit()
    self:setContentSize(training_camp_change_list_cell.__size)
    return self
end

function training_camp_change_list_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/training_camp_change_cell.csb", self.roots[1])
end