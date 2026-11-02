-----------------------------
--连续小充
-----------------------------
RedAlertTimeActivityThreeDayRecharge = class("RedAlertTimeActivityThreeDayRechargeClass", Window)

local red_alert_time_three_day_recharge_window_open_terminal = {
    _name = "red_alert_time_three_day_recharge_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeActivityThreeDayRechargeClass") then
            local panel = RedAlertTimeActivityThreeDayRecharge:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_three_day_recharge_window_open_terminal)
state_machine.init()

function RedAlertTimeActivityThreeDayRecharge:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
    self.m_times = 0
    app.load("client.red_alert_time.activity.wonderful.RedAlertTime7DaysReward")

    local function init_red_alert_time_three_day_recharge_terminal()
	
        --
        local red_alert_time_three_day_recharge_updata_terminal = {
            _name = "red_alert_time_three_day_recharge_updata",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local red_alert_time_three_day_recharge_activity_codes_terminal = {
          _name = "red_alert_time_three_day_recharge_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                -- local cell = params._datas.cell
                local acitvity = _ED.activity_info["89"]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                            checkRewardObtainDraw()
                        end
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n89\r\n0\r\n0\r\n0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
         local red_alert_time_three_day_recruit_activity_codes_terminal = {
          _name = "red_alert_time_three_day_recruit_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                -- local cell = params._datas.cell
                local acitvity = _ED.activity_info["89"]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                            checkRewardObtainDraw()
                        end
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n89\r\n0\r\n0\r\n0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
        state_machine.add(red_alert_time_three_day_recruit_activity_codes_terminal)
        state_machine.add(red_alert_time_three_day_recharge_activity_codes_terminal)
        state_machine.add(red_alert_time_three_day_recharge_updata_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_troops_assembled state machine.
    init_red_alert_time_three_day_recharge_terminal()
end

function RedAlertTimeActivityThreeDayRecharge:onUpdateDraw()
    local root = self.roots[1]
    local activity_data = _ED.activity_info[""..self.activity_type].activity_data
    local ListView_act_share_reward = ccui.Helper:seekWidgetByName(root, "ListView_act_share_reward")
    ListView_act_share_reward:removeAllItems()
    local reward = zstring.split(activity_data[1][1].achieve_reward, "|")
    for i=1, #reward do
        local datas = zstring.split(reward[i], ",")
        if tonumber(datas[1]) == -1 then
            datas[1] = resource_prop_id[tonumber(datas[2])]
            datas[2] = 1
        end
        local prop_type = tonumber(datas[2])
        local show_type = 6
        local prop_from_type = 3
        if tonumber(datas[2]) == 13 then --坦克
            prop_type = 3
            prop_from_type = 10
        elseif tonumber(datas[2]) == 6 then --道具    
            prop_type = 1
            prop_from_type = 1
        elseif tonumber(datas[2]) == 7 then --配件    
            prop_type = 7
            prop_from_type = 4
        else
            prop_type = 1
            prop_from_type = 1
        end
        -- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
        local cell = nil
        if prop_type == 7 then
            local equip_datas = {}
            equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
            equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
        else
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
        end
        ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
        ListView_act_share_reward:addChild(cell)
    end
    ListView_act_share_reward:requestRefreshView()

    local Text_three_day_recharge_name = ccui.Helper:seekWidgetByName(root, "Text_three_day_recharge_name") --名称
    Text_three_day_recharge_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
    local Text_three_day_recharge_infor_p = ccui.Helper:seekWidgetByName(root, "Text_three_day_recharge_infor_p") -- 描述
    Text_three_day_recharge_infor_p:setString(_ED.activity_info[""..self.activity_type].activity_dec)

    local Text_three_day_recharge_time_t = ccui.Helper:seekWidgetByName(root, "Text_three_day_recharge_time_t")
    Text_three_day_recharge_time_t:removeAllChildren(true)
    Text_three_day_recharge_time_t:setString("")
    Text_three_day_recharge_time_t:setVisible(true)
    local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    local font_size = Text_three_day_recharge_time_t:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_three_day_recharge_time_t:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_three_day_recharge_time_t:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_three_day_recharge_time_t:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_three_day_recharge_time_t:addChild(time_int_1)

    local Text_three_day_recharge_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_three_day_recharge_act_time_2")
    Text_three_day_recharge_act_time_2:removeAllChildren(true)
    Text_three_day_recharge_act_time_2:setString("")
    local time_info_2 = cc.Label:createWithTTF(activity_str_tip[97], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_three_day_recharge_act_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_three_day_recharge_act_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_three_day_recharge_act_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_three_day_recharge_act_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_three_day_recharge_act_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_three_day_recharge_act_time_2:addChild(time_int_2)

    local Text_act_share_tit = ccui.Helper:seekWidgetByName(root, "Text_act_share_tit") --标题
    Text_act_share_tit:setString(activity_data[1][1].achieve_mould_name)

    local Button_act_share_rec = ccui.Helper:seekWidgetByName(root,"Button_act_share_rec")
    local Text_act_share_not = ccui.Helper:seekWidgetByName(root,"Text_act_share_not")
    local counts = zstring.split(activity_data[1][1].achieve_complete_count, "/")
    if tonumber(activity_data[1][1].achieve_state) == 1 and tonumber(counts[1]) == tonumber(counts[2]) then
        Button_act_share_rec:setVisible(true)
        Text_act_share_not:setVisible(false)
    elseif tonumber(activity_data[1][1].achieve_state) == 2 then
        Button_act_share_rec:setVisible(false)
        Text_act_share_not:setVisible(true)
        Text_act_share_not:setString(activity_str_tip[2])
    else
        Button_act_share_rec:setVisible(false)
        Text_act_share_not:setVisible(true)
        Text_act_share_not:setString(activity_str_tip[8])
    end

    local Text_three_day_recharge_p = ccui.Helper:seekWidgetByName(root, "Text_three_day_recharge_p") --充值天数
    Text_three_day_recharge_p:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    _richText2:setContentSize(cc.size(Text_three_day_recharge_p:getContentSize().width, Text_three_day_recharge_p:getContentSize().height))
    _richText2:setAnchorPoint(cc.p(0, 0.5))
    
    local last_day = tonumber(counts[2]) - tonumber(counts[1])
    local char_str = string.format(activity_str_tip[32],""..counts[1],""..last_day)
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        char_str, 
        cc.c3b(189, 206, 224),
        cc.c3b(189, 206, 224),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)
        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        _richText2:setPositionY(Text_three_day_recharge_p:getContentSize().height/2)
    Text_three_day_recharge_p:addChild(_richText2)

    local LoadingBar_three_day_recharge_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_three_day_recharge_bar")
    local persent_exp = zstring.tonumber(counts[1]) * 48
    LoadingBar_three_day_recharge_bar:setPercent(persent_exp)

    for i,v in pairs(activity_data[2]) do
        local Panel_three_day_recharge_icon = ccui.Helper:seekWidgetByName(root,string.format("Panel_three_day_recharge_icon_%s", i))
        local Panel_three_day_recharge_props = ccui.Helper:seekWidgetByName(root,string.format("Panel_three_day_recharge_props_%s", i))
        Panel_three_day_recharge_props:removeAllChildren(true)
        if v.achieve_reward == "-1" then
            Panel_three_day_recharge_icon:setVisible(false)
        else
            Panel_three_day_recharge_icon:setVisible(true)
            local rewarld = zstring.split(v.achieve_reward, "|")
            local datas = zstring.split(rewarld[1], ",")
            if tonumber(datas[1]) == -1 then
                datas[1] = resource_prop_id[tonumber(datas[2])]
            end
            local pic_index = zstring.split(dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.pic_index),",")
            local quality_icon = cc.Sprite:create(string.format(config_res.images.ui.props.props, pic_index[1]))
            quality_icon:setPosition(cc.p(Panel_three_day_recharge_props:getContentSize().width/2,Panel_three_day_recharge_props:getContentSize().height/2))
            Panel_three_day_recharge_props:addChild(quality_icon)

            if tonumber(v.achieve_state) >= 1 then
                display:ungray(quality_icon)
            else
                display:gray(quality_icon)
            end
        end
    end

end

function RedAlertTimeActivityThreeDayRecharge:onUpdate(dt)
    local server_time = getCurrentGTM8Time()
    local leave_time = 86400 - (server_time.hour * 3600 + server_time.min * 60 + server_time.sec)
    if ccui.Helper:seekWidgetByName(self.roots[1],"Text_three_day_recharge_act_time_2"):getChildByTag(100) ~= nil then
        ccui.Helper:seekWidgetByName(self.roots[1],"Text_three_day_recharge_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(leave_time))
    end
    if leave_time <= 0 then
        self:onUpdateDraw()
    end
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_three_day_recharge_time_t"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_three_day_recharge_time_t"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
end

function RedAlertTimeActivityThreeDayRecharge:onEnterTransitionFinish()

end


function RedAlertTimeActivityThreeDayRecharge:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_three_day_recharge)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_three_day_recharge_sign"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
    }, nil, 3)
    for i=1, 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,string.format("Panel_three_day_recharge_icon_%s", i)), nil, 
        {
            terminal_name = "red_alert_time_7_days_reward_window_open", 
            terminal_state = 0, 
            cells = self,
            index = i,
        }, nil, 1)
    end
    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"), nil, 
    {
        terminal_name = "red_alert_time_three_day_recruit_activity_codes", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self,
    }, nil, 1)

	self:onUpdateDraw()
end

function RedAlertTimeActivityThreeDayRecharge:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeActivityThreeDayRecharge:onExit()
    state_machine.remove("red_alert_time_three_day_recharge_updata")
    state_machine.remove("red_alert_time_three_day_recharge_activity_codes")
    state_machine.remove("red_alert_time_three_day_recruit_activity_codes")
end
