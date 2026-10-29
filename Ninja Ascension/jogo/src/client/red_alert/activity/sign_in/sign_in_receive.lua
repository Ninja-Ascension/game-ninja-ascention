-----------------------------
--签到获得
-----------------------------
SignInReceive = class("SignInReceiveClass", Window)

local sign_in_receive_window_open_terminal = {
    _name = "sign_in_receive_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _window = fwin:find("SignInReceiveClass")
        if nil == _window then
            local reward_data = params[1]
            local need_vip = params[2]
            local index = params[3]
            fwin:open(SignInReceive:new():init(reward_data,need_vip,index), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sign_in_receive_window_close_terminal = {
    _name = "sign_in_receive_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SignInReceiveClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sign_in_receive_window_open_terminal)
state_machine.add(sign_in_receive_window_close_terminal)
state_machine.init()

function SignInReceive:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize SignInReceive state machine.
    local function init_sign_in_receive_terminal()

        --购买
        local sign_in_receive_sure_terminal = {
            _name = "sign_in_receive_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("reward_obtain_window_open",0,{1015})
                    state_machine.excute("sign_in_update_state",0,"")    
                    state_machine.excute("sign_in_receive_window_close",0,"") 
                end
            end
            local login_day = tonumber(zstring.split(_ED.activity_info["15"].activity_add_state,",")[2])
            protocol_command.draw_activity_reward.param_list = _ED.activity_info["15"].activity_id .."\r\n" .. "15" .. "\r\n" .. "1" .."\r\n" .. (login_day - 1)
            NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --购买
        local sign_in_receive_recharge_terminal = {
            _name = "sign_in_receive_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("recharge_dialog_window_open",0,"") 
                state_machine.excute("sign_in_receive_window_close",0,"")     
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sign_in_receive_sure_terminal)
        state_machine.add(sign_in_receive_recharge_terminal)
        state_machine.init()
    end
    
    -- call func init SignInReceive state machine.
    init_sign_in_receive_terminal()
end

function SignInReceive:onUpdateDraw()
    local root = self.roots[1]
    local reward_data = self._reward_data
    local prop_type = reward_data.prop_type
    local prop_id = reward_data.prop_item
    -- 道具icon
    local cell = nil
    local name = ""
    if tonumber(prop_type) == 6 then        --道具
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(reward_data.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(reward_data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,reward_data,reward_data,touch_type,0,false,true})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        end  
        name = dms.string(dms["prop_mould"],prop_id,prop_mould.prop_name)
        quality = dms.int(dms["prop_mould"],prop_id,prop_mould.prop_quality)   
        dec = dms.string(dms["prop_mould"],prop_id,prop_mould.remarks)
    elseif tonumber(prop_type) == 7 then    --装备
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = dms.string(dms["equipment_mould"],prop_id,equipment_mould.equipment_name)
        quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
        dec = dms.string(dms["equipment_mould"],prop_id,equipment_mould.trace_remarks)
    elseif tonumber(prop_type) == 13 then   --英雄
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = dms.string(dms["ship_mould"],prop_id,ship_mould.captain_name)
        quality  = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)  
        dec = dms.string(dms["ship_mould"],prop_id,ship_mould.introduce)  
    elseif tonumber(prop_type) == 34 then   --宝石
        cell = state_machine.excute("all_resource_create_cell",0,{5,reward_data,reward_data,touch_type,0,false,true})   
        name = dms.string(dms["gems_mould"],prop_id,gems_mould.name)
        quality  = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
        local add_attribute  = dms.string(dms["gems_mould"],prop_id,gems_mould.add_attribute)
        add_attribute = zstring.split(add_attribute,",")
        local text_title = tonumber(add_attribute[1])
        text_title = attribute[text_title+1]
        local text_str = tonumber(add_attribute[2])
        text_str = "  +" .. text_str
        dec = ""

        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
         local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, text_title, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
         local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, text_str, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_props_information:getContentSize().width/2,Text_props_information:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_props_information:getContentSize().width,18))
        Text_props_information:addChild(_richText)
    elseif tonumber(prop_type) == 1 then    --金币
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = _my_gane_name[1]     
        dec = _All_tip_string_info_description._fundNameDescription
    elseif tonumber(prop_type) == 2 then    --钻石
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = _my_gane_name[2]
        dec = _All_tip_string_info_description._crystalNameDescription  
    elseif tonumber(prop_type) == 3 then
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = _my_gane_name[3]
        dec = _All_tip_string_info_description._reputationDescription    
    elseif tonumber(prop_type) == 5 then    --英魂
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = _my_gane_name[5]
        dec = _All_tip_string_info_description._soulJadeNameDescription  
    elseif tonumber(prop_type) == 12 then   --体力
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = _my_gane_name[9]
        dec = _All_tip_string_info_description._physicalStrengthDescription  
    elseif tonumber(prop_type) == 28 then   --军团贡献
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = _my_gane_name[16]
        dec = _All_tip_string_info_description._unionContributionDescription  
    elseif tonumber(prop_type) == 31 then   --军功
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = red_alert_resouce_tip[1][1]
        dec = red_alert_resouce_tip[1][2]
    elseif tonumber(prop_type) == 32 then   --粮草
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = red_alert_resouce_tip[2][1]
        dec = red_alert_resouce_tip[2][2]
    elseif tonumber(prop_type) == 33 then   --木材
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = _my_gane_name[13]
        dec = red_alert_all_str[143]       
    elseif tonumber(prop_type) == 35 then   --马
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = dms.string(dms["horse_mould"],prop_id,horse_mould.horse_name)
        quality  = dms.int(dms["horse_mould"],prop_id,horse_mould.quality)
    elseif tonumber(prop_type) == 36 then   --马魂
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.horse_spirit_name)
        quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
        local level = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.level)
        if level == -1 then 
            dec = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.desc)
        else
            local attributes  = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.attributes)
            attributes = zstring.split(attributes,",")
            local text_title = tonumber(attributes[1])
            text_title = attribute[text_title+1]
            local text_str = tonumber(attributes[2])
            text_str = "  +" .. text_str
            dec = ""

            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)       
             local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, text_title, "fonts/simhei.ttf",18)
            _richText:pushBackElement(re1)  
             local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, text_str, "fonts/simhei.ttf",18)
            _richText:pushBackElement(re2)
            _richText:setPosition(cc.p(Text_props_information:getContentSize().width/2,Text_props_information:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_props_information:getContentSize().width,18))
            Text_props_information:addChild(_richText)
        end
    elseif tonumber(prop_type) == 37 then   --龙马碎片
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = red_alert_resouce_tip[3]
        dec = red_alert_resouce_tip[3]
    elseif tonumber(prop_type) == 38 then   --马魂碎片
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = red_alert_resouce_tip[4]
        dec = red_alert_resouce_tip[4]
    elseif tonumber(prop_type) == 39 then   --vip经验
        cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        name = _All_tip_string_info._vipExp
        dec = red_alert_resouce_tip[5]
    end

    -- 道具icon
    local Panel_icon = ccui.Helper:seekWidgetByName(root,"Panel_icon")
    Panel_icon:addChild(cell)
    -- 数量
    local Text_rewead_number = ccui.Helper:seekWidgetByName(root,"Text_rewead_number")
    Text_rewead_number:setString(reward_data.item_value)
    -- 名称
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString(name)
    -- 描述
    local Text_information = ccui.Helper:seekWidgetByName(root,"Text_information")
    Text_information:setString(dec)

    --签到天数
    local Text_sign_day = ccui.Helper:seekWidgetByName(root,"Text_sign_day")
    Text_sign_day:setString(string.format(red_alert_all_str[197],self._index))

    local Button_sure = ccui.Helper:seekWidgetByName(root,"Button_sure")
    local Button_receive = ccui.Helper:seekWidgetByName(root,"Button_receive")
    Button_sure:setVisible(false)
    Button_receive:setVisible(false)
    local sign_activity = _ED.activity_info["15"]
    local activity_add_state = zstring.split(sign_activity.activity_add_state,",")
    if tonumber(activity_add_state[2]) < tonumber(self._index) then
        Button_sure:setVisible(true)
    else
        Button_receive:setVisible(true)
    end
end

function SignInReceive:onEnterTransitionFinish()

end

function SignInReceive:onInit( )
    local csbItem = csb.createNode(config_csb.activity.sign_in.sign_in_receive)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sign_1_close"), nil, 
    {
        terminal_name = "sign_in_receive_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_receive"), nil, 
    {
        terminal_name = "sign_in_receive_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- buy
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_shop_buy"), nil, 
    {
        terminal_name = "sign_in_receive_recharge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sure"), nil, 
    {
        terminal_name = "sign_in_receive_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    self:onUpdateDraw() 
end

function SignInReceive:init(reward_data,need_vip,index)
    self._reward_data = reward_data
    self._need_vip = need_vip
    self._index = index
    self:onInit()
    return self
end

function SignInReceive:onExit()
    state_machine.remove("sign_in_receive_sure")
    state_machine.remove("sign_in_receive_recharge")
end
