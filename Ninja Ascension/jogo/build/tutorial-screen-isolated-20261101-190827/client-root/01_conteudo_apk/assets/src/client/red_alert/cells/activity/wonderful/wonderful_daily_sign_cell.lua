--------------------
-- 登录送cell
--------------------

WonderfulDailySignCell = class("WonderfulDailySignCellClass", Window)
WonderfulDailySignCell.__size = nil

local wonderful_daily_sign_cell_create_terminal = {
    _name = "wonderful_daily_sign_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local info = params[2]
        local cell = WonderfulDailySignCell:new()
        cell:init(index, info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(wonderful_daily_sign_cell_create_terminal)
state_machine.init()

function WonderfulDailySignCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0                 --cell显示天数
    self._info = nil

    local function init_wonderful_daily_sign_cell_terminal()
        --领取签到奖励
        local wonderful_daily_sign_click_receive_terminal = {
            _name = "wonderful_daily_sign_click_receive",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1043})
                        state_machine.excute("wonderful_daily_sign_set_positionx", 0, "")
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["43"].activity_id .. "\r\n43\r\n0\r\n"..(cell._index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(wonderful_daily_sign_click_receive_terminal)
        state_machine.init()
    end

    init_wonderful_daily_sign_cell_terminal()
end

function WonderfulDailySignCell:init(index, info)
    self._index = index
    self._info = info

    self:onInit()
    self:setContentSize(WonderfulDailySignCell.__size)
    return self
end

function WonderfulDailySignCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.activity.wonderful.wonderful_denglusong_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if WonderfulDailySignCell.__size == nil then
        WonderfulDailySignCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
    {
        terminal_name = "wonderful_daily_sign_click_receive", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)  

    self:updateDraw()
end

function WonderfulDailySignCell:updateDraw()
    local root = self.roots[1]

    local Text_day_number = ccui.Helper:seekWidgetByName(root, "Text_day_number")           --签到天数
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")         --道具图标
    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")           --道具名
    local Image_get = ccui.Helper:seekWidgetByName(root, "Image_get")
    local Button_receive = ccui.Helper:seekWidgetByName(root, "Button_receive")             --领取按钮
    local Text_receive = ccui.Helper:seekWidgetByName(root, "Text_receive")                 --领取文本

    Text_day_number:setString(self._index)
    Panel_props_icon:removeAllChildren(true)
    Image_get:setVisible(false)

    local state = tonumber(self._info.achieve_state)

    if state == 1 then         -- 可签到
        Button_receive:setBright(true)
        Button_receive:setTouchEnabled(true)
        Text_receive:setString(tipStringInfo_wonderful_sign_str[3])
    elseif state == 0 then                                  -- 未签到
        Button_receive:setBright(false)
        Button_receive:setTouchEnabled(false)
        Text_receive:setString(tipStringInfo_wonderful_sign_str[2])
    else                                                    -- 已签到
        Button_receive:setBright(false)
        Button_receive:setTouchEnabled(false)
        Text_receive:setString(tipStringInfo_wonderful_sign_str[1])
        Image_get:setVisible(true)
    end

    local reward_info = zstring.split(self._info.achieve_reward, ",")
    local data = {
        item_value = tonumber(reward_info[3]),
        prop_type = tonumber(reward_info[2]),
        prop_item = tonumber(reward_info[1]),
    }

    local cell = nil
    if tonumber(data.prop_type) == 6 then    
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment)) > 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,touch_type,0,false,true})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,true})
        end  
    elseif tonumber(data.prop_type) == 34 then    
        cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,touch_type,0,false,true})   
    else
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,true})
    end
    Panel_props_icon:addChild(cell)

    local reward_data = self:getRewardData(data)
    Text_props_name:setString(reward_data.name)
    Text_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[reward_data.quality+1][1],tipStringInfo_quality_color_Type[reward_data.quality+1][2],tipStringInfo_quality_color_Type[reward_data.quality+1][3]))

end

function WonderfulDailySignCell:getRewardData(data)
    local reward_data = {}

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

    reward_data.name = name
    reward_data.quality = quality

    return reward_data
end

function WonderfulDailySignCell:onExit()
end

function WonderfulDailySignCell:onEnterTransitionFinish()

end
