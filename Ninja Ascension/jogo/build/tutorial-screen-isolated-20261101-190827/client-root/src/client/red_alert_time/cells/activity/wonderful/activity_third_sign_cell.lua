ActiveThirdSignCell = class("ActiveThirdSignCellClass", Window)
ActiveThirdSignCell.__size = nil

local activity_third_sign_create_cell_terminal = {
    _name = "activity_third_sign_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local info_data = params[2]
        local signDay = params[3]
        local sign_info = params[4]
        local cell = ActiveThirdSignCell:new()
        cell:init(index, info_data, signDay, sign_info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_third_sign_create_cell_terminal)
state_machine.init()

function ActiveThirdSignCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._signDay = 0
    self._sign_info = 0
    local function init_activity_third_sign_cell_terminal()
  		local activity_third_sign_cell_get_reward_terminal = {
            _name = "activity_third_sign_cell_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)  
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1021})
                        state_machine.excute("activity_third_sign_update_rotary_times", 0, "")
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["21"].activity_id .. "\r\n21\r\n1\r\n"..instance._sign_info
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)           
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

  		state_machine.add(activity_third_sign_cell_get_reward_terminal)
        state_machine.init()
    end
    
    init_activity_third_sign_cell_terminal()
end

function ActiveThirdSignCell:updateDraw()
    local root = self.roots[1]
    local BitmapFontLabel_number = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_number")
    local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward")
    local Text_yuanbao = ccui.Helper:seekWidgetByName(root,"Text_yuanbao")
    local Text_yuanbao_numaber = ccui.Helper:seekWidgetByName(root,"Text_yuanbao_numaber")
    local Text_infor_v = ccui.Helper:seekWidgetByName(root,"Text_infor_v")
    local Button_third_receive = ccui.Helper:seekWidgetByName(root,"Button_third_receive")
    local Text_rec = ccui.Helper:seekWidgetByName(root,"Text_rec")
    local Text_rec_no = ccui.Helper:seekWidgetByName(root,"Text_rec_no")
    local Image_h_receive = ccui.Helper:seekWidgetByName(root,"Image_h_receive")
    Panel_reward:removeAllChildren(true)

    Text_rec:setVisible(false)
    Text_rec_no:setVisible(false)
    Image_h_receive:setVisible(false)
    Button_third_receive:setVisible(true)
    Button_third_receive:setBright(true)
    Button_third_receive:setTouchEnabled(true)

    local rewards = zstring.split(dms.atos(self._info_data, every_three_sign_in_mould.three_sign_reward), ",")
    local times = dms.atoi(self._info_data, every_three_sign_in_mould.three_sign_finish_need_info)

    BitmapFontLabel_number:setString(""..times)
    Text_infor_v:setString(""..times)
    Text_yuanbao_numaber:setString("X"..rewards[3])

    if times > self._signDay then
        Text_rec_no:setVisible(true)
        Button_third_receive:setBright(false)
        Button_third_receive:setTouchEnabled(false)
    else
        Text_rec:setVisible(true)
    end

    self:updateCellName(rewards[2], rewards[1], Text_yuanbao)
    local data = 
    {
        item_value = rewards[3],
        prop_type = rewards[2],
        prop_item = rewards[1],
    }

    -- local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
    if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
        or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
        cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
    else
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
    end  
    Panel_reward:addChild(cell)
end

function ActiveThirdSignCell:updateCellName( prop_type, prop_id, Text_yuanbao )
    local quality = 4
    local name = ""
    if tonumber(prop_type) == 1 then
        name = _All_tip_string_info._fundName
        quality = 4
    elseif tonumber(prop_type) == 2 then
        name = _All_tip_string_info._crystalName
        quality = 4 
    elseif tonumber(prop_type) == 3 then
        name = _All_tip_string_info._reputation
        quality = 4         
    elseif tonumber(prop_type) == 5 then
        name = _All_tip_string_info._hero
        quality = 4
    elseif tonumber(prop_type) == 6 then
        name = dms.string(dms["prop_mould"],prop_id,prop_mould.prop_name)
        quality = dms.int(dms["prop_mould"],prop_id,prop_mould.prop_quality)
    elseif tonumber(prop_type) == 7 then
        name = dms.string(dms["equipment_mould"],prop_id,equipment_mould.equipment_name)
        quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
    elseif tonumber(prop_type) == 12 then
        name = _All_tip_string_info._energyName
        quality = 4
    elseif tonumber(prop_type) == 13 then
        name = dms.string(dms["ship_mould"],prop_id,ship_mould.captain_name)
        quality = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)
    elseif tonumber(prop_type) == 28 then   --军团贡献
        name = _All_tip_string_info._guide
        quality = 4
    elseif tonumber(prop_type) == 31 then       --战神令
        name = _All_tip_string_info._zhanshenling
        quality = 4
    elseif tonumber(prop_type) == 32 then       --气势值
        name = _All_tip_string_info._qishizhi
        quality = 4
    elseif tonumber(prop_type) == 33 then       --木材
        name = _All_tip_string_info._martix
        quality = 4
    elseif tonumber(prop_type) == 34 then       --宝石
        name = dms.string(dms["gems_mould"],prop_id,gems_mould.name)
        quality = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
    elseif tonumber(prop_type) == 35 then       -- 马
        name = dms.string(dms["horse_mould"],prop_id,horse_mould.horse_name)
        quality = dms.int(dms["horse_mould"], prop_id, horse_mould.quality)
    elseif tonumber(prop_type) == 36 then       --马魂
        name = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.horse_spirit_name)
        quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
    elseif tonumber(prop_type) == 37 then       --龙马碎片
        name = _All_tip_string_info._horse_spirit
        quality = 4
    elseif tonumber(prop_type) == 38 then       --马魂碎片
        name = _All_tip_string_info._horse
        quality = 4
    elseif tonumber(prop_type) == 39 then       --VIP经验
        name = _All_tip_string_info._vipExp
        quality = 4
    end
    Text_yuanbao:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_yuanbao:setString(name)
end

function ActiveThirdSignCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.activity_third_sign_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ActiveThirdSignCell.__size == nil then
        ActiveThirdSignCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_third_receive"), nil, 
    {
        terminal_name = "activity_third_sign_cell_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:updateDraw()
end

function ActiveThirdSignCell:onEnterTransitionFinish()

end

function ActiveThirdSignCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function ActiveThirdSignCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward")
    Panel_reward:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.activity.wonderful.activity_third_sign_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function ActiveThirdSignCell:init(index, info_data, signDay, sign_info)
    self._info_data = info_data
    self._signDay = signDay
    self._sign_info = sign_info
    if index ~= nil and index < 6 then
        self:onInit()
    end
    self:setContentSize(ActiveThirdSignCell.__size)
    return self
end

function ActiveThirdSignCell:onExit()
    local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward")
    if Panel_reward ~= nil then
        Panel_reward:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.activity_third_sign_cell, self.roots[1])
end