-----------------------------
--红妆觉醒
-----------------------------
EquipmentAwaken = class("EquipmentAwakenClass", Window)

local equipment_awaken_window_open_terminal = {
    _name = "equipment_awaken_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil ==  fwin:find("EquipmentAwakenClass") then
            local equip = params[1]
            if equip == nil then
                return
            end
            fwin:open(EquipmentAwaken:new():init(equip), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equipment_awaken_window_close_terminal = {
    _name = "equipment_awaken_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentAwakenClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_awaken_window_open_terminal)
state_machine.add(equipment_awaken_window_close_terminal)
state_machine.init()

function EquipmentAwaken:ctor()
    self.super:ctor()
    self.roots = {}
    self.equip = nil
    self.cost_equip_id = nil
    self.have_prop_number = nil
    self.need_prop_number = nil
    
    --load lua file 
    app.load("client.red_alert_time.campaign.weaponry.Weaponry")
    -- Initialize equipment_awaken state machine.
    local function init_equipment_awaken_terminal()
        --觉醒
        local equipment_awaken_sure_terminal = {
            _name = "equipment_awaken_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(instance.cost_equip_id) == 0 or instance.need_prop_number > instance.have_prop_number then
                    TipDlg.drawTextDailog(red_alert_all_str[29])
                    return 
                end
                local reward_data = instance:getEquipRefinningReward()
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("equipment_awaken_window_close",0,"")
                        state_machine.excute("equipment_update_after_awaken",0,"")

                        if #reward_data.show_reward_list ~= 0 then
                            state_machine.excute("reward_obtain_window_open",0,{nil,reward_data})
                        end
                    end
                end

                protocol_command.awaken_equipment.param_list = self.equip.user_equiment_id .. "\r\n" .. self.cost_equip_id
                NetworkManager:register(protocol_command.awaken_equipment.code, nil, nil, nil, nil, responseCallback, false, nil)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --掉落跳转
        local equipment_awaken_goto_drop_way_terminal = {
            _name = "equipment_awaken_goto_drop_way",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        state_machine.add(equipment_awaken_sure_terminal)
        state_machine.add(equipment_awaken_goto_drop_way_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_equipment_awaken_terminal()
end


function EquipmentAwaken:getNeedSilver(equip,level)
    local suit_id = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.suit_id)
    local need_silver = dms.int(dms["equipment_level_requirement"], level, equipment_level_requirement.silver_amount)
    -- print("==========y",need_silver)
    if need_silver == nil then
        return 0 
    end
    --不同装备套装对应强化系数（套装ID,计算参数|...）
    -- 不同装备部位对应强化系数（装备部位,计算参数|...)
    local equip_suit_id_table = dms.string(dms["equipment_config"],1,equipment_config.param)
    equip_suit_id_table = zstring.split(equip_suit_id_table,"|")
    -- debug.print_r(equip_suit_id_table)
    local equip_type_table = dms.string(dms["equipment_config"],2,equipment_config.param)
    equip_type_table = zstring.split(equip_type_table,"|")
    -- debug.print_r(equip_type_table)
    for i,v in pairs(equip_suit_id_table) do
        local temp_data = zstring.split(v,",")
        -- print("=====================1=====================",v)
        local suit_id_temp = tonumber(temp_data[1])
        if suit_id == suit_id_temp then
            local tempx = tonumber(temp_data[2]) -- 计算系数1 
            -- print("==========x",tempx,temp_data[2])
            need_silver = need_silver *tempx
        end
    end

    for i,v in pairs(equip_type_table) do
        local temp_data = zstring.split(v,",")
        -- print("=====================2=====================",v)
        local equip_type = tonumber(temp_data[1])
        if tonumber(equip.equipment_type) == equip_type then
            local tempx = tonumber(temp_data[2]) -- 计算系数2
            -- print("==========y",tempx,temp_data[2])
            need_silver = need_silver *tempx
        end
    end

    return need_silver
end

function EquipmentAwaken:getEquipRefinningReward()
    local all_reward_datas = {}
    all_reward_datas.show_reward_list = {}

    local back_silvers = 0
    local equip = _ED.user_equiment[""..self.cost_equip_id]
    local equip_mould_id = equip.user_equiment_template
    
    for i = 1 , (tonumber(equip.user_equiment_grade) - 1) do 
        local lostSilver = self:getNeedSilver(equip,i)
        back_silvers = back_silvers + lostSilver
    end     

    if back_silvers ~= 0 then
        local data = 
        {
            item_value = back_silvers,
            prop_type = 1,
            prop_item = -1,
        }
        table.insert(all_reward_datas.show_reward_list,data)
    end 

    for i,v in pairs(equip.jewelrys) do
        if tonumber(v) > 0 then
            if _ED.user_gems[""..v] ~= nil then
                local data = 
                {
                    item_value = 1,
                    prop_type = 34,
                    prop_item = _ED.user_gems[""..v].mould_id,
                }
                table.insert(all_reward_datas.show_reward_list,data)
            end
        end
    end
    
    return all_reward_datas
end

function EquipmentAwaken:onUpdateDraw()
    local root = self.roots[1]
    local equip = self.equip

    local awaken_equipment_id = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.awaken_equipment_id)

    local init_pow_number = dms.string(dms["equipment_mould"],awaken_equipment_id,equipment_mould.initial_value)
    local additive_attribute = dms.string(dms["equipment_mould"],awaken_equipment_id,equipment_mould.additive_attribute)
    local grow_value = dms.string(dms["equipment_mould"],awaken_equipment_id,equipment_mould.grow_value)
    local equipment_name = dms.string(dms["equipment_mould"],awaken_equipment_id,equipment_mould.equipment_name)
    local quality = dms.int(dms["equipment_mould"],awaken_equipment_id,equipment_mould.grow_level)
    grow_value = zstring.split(grow_value,"|")
    local init_grow_value = zstring.split(grow_value[1],",")
    init_grow_value = init_grow_value[4]

    local equip_grow_type = 0 -- 成长类型

    init_pow_number = zstring.split(init_pow_number,",")
    equip_grow_type = tonumber(init_pow_number[1])
    init_pow_number = tonumber(init_pow_number[2]) 
    local add_str = attribute[tonumber(equip_grow_type)+1]

    local other_add_str = ""
    local other_add_number = 0

    if additive_attribute ~= "-1" then
        additive_attribute = zstring.split(additive_attribute,",")
        other_add_str = tonumber(additive_attribute[1])
        other_add_number = tonumber(additive_attribute[2])
    end

    local Text_equipment_name = ccui.Helper:seekWidgetByName(root,"Text_equipment_name")
    Text_equipment_name:setString(equipment_name)
    Text_equipment_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

    local Panel_equipemt_picture = ccui.Helper:seekWidgetByName(root,"Panel_equipemt_picture") -- 装备大icon 
    local Text_attribute_1 = ccui.Helper:seekWidgetByName(root,"Text_attribute_1") -- 描述1 
    local Text_attribute_2 = ccui.Helper:seekWidgetByName(root,"Text_attribute_2") -- 描述2 
    local Text_attribute_3 = ccui.Helper:seekWidgetByName(root,"Text_attribute_3") -- 描述3
    
    Text_attribute_1:setString(red_alert_all_str[19]..add_str)
    Text_attribute_2:setString(red_alert_all_str[20]..add_str)
    Text_attribute_3:setString(attribute[other_add_str])
    
    local Text_attribute_v_1 = ccui.Helper:seekWidgetByName(root,"Text_attribute_v_1") -- 属性值1
    local Text_attribute_v_2 = ccui.Helper:seekWidgetByName(root,"Text_attribute_v_2") -- 属性值2
    local Text_attribute_v_3 = ccui.Helper:seekWidgetByName(root,"Text_attribute_v_3") -- 属性值3
    
    Text_attribute_v_1:setString("+" .. init_pow_number)
    Text_attribute_v_2:setString("+" .. init_grow_value)
    Text_attribute_v_3:setString("+" .. other_add_number)
    
    local all_icon = dms.int(dms["equipment_mould"],awaken_equipment_id,equipment_mould.All_icon)
    Panel_equipemt_picture:setBackGroundImage("images/ui/big_props/big_props_".. all_icon .. ".png")

    local awaken_need_resource = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.awaken_need_resource)
    local need_str = zstring.split(awaken_need_resource,"|")
    local datas = {}
    for i,v in pairs(need_str) do
        local data = zstring.split(v,",")
        datas[i] = {
             item_value = data[3],
             prop_type = data[2],
             prop_item = data[1],
        }
    end

    local Panel_needs_picture_1 = ccui.Helper:seekWidgetByName(root,"Panel_needs_picture_1") -- 需求同品质装备图
    Panel_needs_picture_1:removeAllChildren(true)
    local cell1 = state_machine.excute("all_resource_create_cell",0,{2,datas[1],datas[1],8,0,false,false})  
    Panel_needs_picture_1:addChild(cell1)
    local Panel_needs_picture_2 = ccui.Helper:seekWidgetByName(root,"Panel_needs_picture_2") -- 需求红装精华图
    Panel_needs_picture_2:removeAllChildren(true)
    local cell2 = state_machine.excute("all_resource_create_cell",0,{2,datas[2],datas[2],8,0,false,false})  
    Panel_needs_picture_2:addChild(cell2)    
    local Text_needs_v_1 = ccui.Helper:seekWidgetByName(root,"Text_needs_v_1") -- 数量
    Text_needs_v_1:setString("x"..datas[1].item_value)
    local Text_needs_v_2 = ccui.Helper:seekWidgetByName(root,"Text_needs_v_2") -- 数量
    Text_needs_v_2:setString("x"..datas[2].item_value)
    local Text_needs_had_v_1 = ccui.Helper:seekWidgetByName(root,"Text_needs_had_v_1") -- 已有
    local Text_needs_had_v_2 = ccui.Helper:seekWidgetByName(root,"Text_needs_had_v_2") -- 已有

    local have_equip , equip_id = self:getEquipHave(datas[1].prop_item)
    local have_prop = self:getPropHave(datas[2].prop_item)
    Text_needs_had_v_1:setString(string.format(red_alert_all_str[18],have_equip))
    Text_needs_had_v_2:setString(string.format(red_alert_all_str[18],have_prop))
    self.have_prop_number = have_prop
    self.need_prop_number = tonumber(datas[2].item_value)
    self.cost_equip_id = equip_id
end

function EquipmentAwaken:getEquipHave(equip_mould_id)
    local numbers = 0
    local equip_id = 0
    for i,v in pairs(_ED.user_equiment) do
        if tonumber(v.rela_state) == 0 and tonumber(v.ship_id) == 0 then
            if tonumber(v.user_equiment_template) == tonumber(equip_mould_id) then
                numbers = numbers + 1
                equip_id = tonumber(v.user_equiment_id)
            end
        end
    end
    return numbers,equip_id
end

function EquipmentAwaken:getPropHave(prop_mould_id)
    local numbers = 0
    for i,v in pairs(_ED.user_prop) do
        if tonumber(v.user_prop_template) == tonumber(prop_mould_id) then
            numbers = tonumber(v.prop_number)
        end
    end
    return numbers
end

function EquipmentAwaken:onEnterTransitionFinish()

end

function EquipmentAwaken:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment_awaken)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "equipment_awaken_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
   
    -- 觉醒
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_awaken"), nil, 
    {
        terminal_name = "equipment_awaken_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
   
    -- 掉落
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_needs_drop"), nil, 
    {
        terminal_name = "weaponry_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)  
	self:onUpdateDraw()	
end


function EquipmentAwaken:init(equip)
    self.equip = equip
    self.equip_mould_id = equip.user_equiment_template
	self:onInit()
    return self
end

function EquipmentAwaken:onExit()
    state_machine.remove("equipment_awaken_sure")
    state_machine.remove("equipment_awaken_goto_drop_way")
end
