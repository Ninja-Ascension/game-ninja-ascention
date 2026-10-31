-----------------------------
--传奇英雄
-----------------------------
RedAlertTimeLeaderSeniorLegend = class("RedAlertTimeLeaderSeniorLegendClass", Window)

local red_alert_time_leader_senior_legend_window_open_terminal = {
    _name = "red_alert_time_leader_senior_legend_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeLeaderSeniorLegendClass") then
            fwin:open(RedAlertTimeLeaderSeniorLegend:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_leader_senior_legend_window_close_terminal = {
    _name = "red_alert_time_leader_senior_legend_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.show_reward_list_group_ex = {}
        fwin:close(fwin:find("RedAlertTimeLeaderSeniorLegendClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_leader_senior_legend_window_open_terminal)
state_machine.add(red_alert_time_leader_senior_legend_window_close_terminal)
state_machine.init()

function RedAlertTimeLeaderSeniorLegend:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 

    self.m_times = 0
    self.isFree = false
    self.leader_id = 0

    self.m_times = 0
    self.m_reset_times = 0
    self._label_close_text = nil
    self._label_reset_text = nil

    app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorOnce")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorTen")
    app.load("client.red_alert_time.leader.LeaderExchangeInfo")

    app.load("client.red_alert_time.cells.leader.leader_big_head_cell")

    local function init_red_alert_time_leader_senior_legend_terminal()
        -- 英雄属性
        local red_alert_time_leader_senior_legend_look_infor_terminal = {
            _name = "red_alert_time_leader_senior_legend_look_infor",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("leader_exchange_info_window_open", 0, {instance.leader_id,nil, 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 奖励
        local red_alert_time_leader_senior_legend_reward_preview_terminal = {
            _name = "red_alert_time_leader_senior_legend_reward_preview",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local activity_data = instance._activity_type.activity_data[1][1]
                local reward_info = zstring.split(activity_data.achieve_reward,"|")
                state_machine.excute("red_alert_time_box_preview_window_open",0,{reward_info , activity_str_tip[113]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 招募
        local red_alert_time_leader_senior_legend_get_terminal = {
            _name = "red_alert_time_leader_senior_legend_get",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local curr_type = params._datas._type
                if curr_type == 1 and instance.isFree == true then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    return
                end
                if curr_type == 0 and instance.isFree == true then
                    state_machine.excute("red_alert_time_leader_senior_legend_sure_choose_recruit",0,{0})
                else
                    local need_gold = 0
                    local cost = 0
                    if curr_type == 0 then
                        need_gold = instance.oneNeedGod
                        cost = 1
                    else
                        cost = 10
                        need_gold = instance.tenNeedGod
                    end
                    if tonumber(need_gold) > tonumber(_ED.user_info.user_gold) then
                        TipDlg.drawTextDailog(tipStringInfo_campaign_info[16])
                        return
                    end
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold,cost,curr_type}, m_type = 31}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_leader_senior_legend_sure_choose_recruit_terminal = {
            _name = "red_alert_time_leader_senior_legend_sure_choose_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local choose_type = params[1]
                local acitvity = _ED.activity_info[""..instance._activity_type.activity_type]
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if choose_type == 1 then
                                if fwin:find("RedAlertTimeLeaderSeniorTenClass") ~= nil then
                                    state_machine.excute("red_alert_time_leader_senior_ten_update_draw", 0, nil)
                                else
                                    state_machine.excute("red_alert_time_leader_senior_ten_window_open", 0, {response.node._activity_type.activity_type, response.node.tenNeedGod, response.node.tenNeedGodOld, response.node.discount})
                                end
                            else
                                if fwin:find("RedAlertTimeLeaderSeniorOnceClass") ~= nil then
                                    state_machine.excute("red_alert_time_leader_senior_once_update_draw", 0, nil)
                                else
                                    state_machine.excute("red_alert_time_leader_senior_once_window_open", 0, {response.node._activity_type.activity_type, response.node.oneNeedGod, false})
                                end
                            end
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n"..choose_type
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 规则
        local red_alert_time_leader_senior_legend_get_rule_terminal = {
            _name = "red_alert_time_leader_senior_legend_get_rule",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看记录
        local red_alert_time_leader_senior_legend_look_reward_terminal = {
            _name = "red_alert_time_leader_senior_legend_look_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local activity_add_state_arry = zstring.split(instance._activity_type.activity_add_state,"!")
                local reworld = nil
                if activity_add_state_arry[3] ~= "0" then
                    reworld = zstring.split(activity_add_state_arry[3], "|")
                end
                state_machine.excute("red_alert_time_box_preview_window_open",0,{reworld , activity_str_tip[164]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local red_alert_time_leader_senior_legend_update_draw_terminal = {
            _name = "red_alert_time_leader_senior_legend_update_draw",
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

        state_machine.add(red_alert_time_leader_senior_legend_look_infor_terminal)
        state_machine.add(red_alert_time_leader_senior_legend_reward_preview_terminal)
        state_machine.add(red_alert_time_leader_senior_legend_get_terminal)
        state_machine.add(red_alert_time_leader_senior_legend_sure_choose_recruit_terminal)
        state_machine.add(red_alert_time_leader_senior_legend_get_rule_terminal)
        state_machine.add(red_alert_time_leader_senior_legend_look_reward_terminal)
        state_machine.add(red_alert_time_leader_senior_legend_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_leader_senior_legend state machine.
    init_red_alert_time_leader_senior_legend_terminal()
end

-- 将领信息
function RedAlertTimeLeaderSeniorLegend:updateLeaderInfo()
    local root = self.roots[1]

    local ship_info = dms.element(dms["ship_mould"], self.leader_id)
    local name = dms.atos(ship_info, ship_mould.captain_name)
    local skill_name = dms.atos(ship_info, ship_mould.skill_name)
    local introduce = dms.atos(ship_info, ship_mould.introduce)  
    local skill_describe = dms.atos(ship_info, ship_mould.skill_describe)  
    local ship_type =  dms.atoi(ship_info, ship_mould.ship_type) 

    -- 头像
    local Panel_leader_legend_icon = ccui.Helper:seekWidgetByName(root,"Panel_leader_legend_icon")
    Panel_leader_legend_icon:removeAllChildren(true)
    local cell = state_machine.excute("leader_big_head_create_cell", 0, {self.leader_id, nil, 10})
    Panel_leader_legend_icon:addChild(cell)
    -- 名称
    local Text_leader_legend_name = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_name")
    Text_leader_legend_name:setString(name)

    -- 品阶
    for i = 1, 4 do
        local Image_leader_legend_orders = ccui.Helper:seekWidgetByName(root,"Image_leader_legend_orders_"..i)
        if i <= ship_type then
            Image_leader_legend_orders:setVisible(true)
        else
            Image_leader_legend_orders:setVisible(false)
        end
    end

    -- 特点
    local Text_leader_legend_point_n = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_point_n")
    Text_leader_legend_point_n:setString(skill_describe)

    -- 国籍
    local Text_leader_legend_nation_n = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_nation_n")
    Text_leader_legend_nation_n:setString(skill_name)

    -- 简介
    local Text_leader_legend_information = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_information")
    Text_leader_legend_information:setString(introduce)
end

function RedAlertTimeLeaderSeniorLegend:onUpdateDraw()
    local root = self.roots[1]

    local activity_info = _ED.activity_info[""..self._activity_type.activity_type]
    self._activity_type = activity_info

    local activity_add_state_arry = zstring.split(activity_info.activity_add_state,"!")
    local activity_add_state = zstring.split(activity_add_state_arry[1],",")
    local other_info = zstring.split(activity_add_state_arry[2],"|")
    other_info = zstring.split(other_info[1], ",")
    -- 名称
    local Text_leader_legend_tit = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_tit")
    Text_leader_legend_tit:setString(activity_info.activity_title)
    -- 描述
    local Text_leader_legend_p_1 = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_p_1")
    Text_leader_legend_p_1:setString(activity_info.activity_dec)

    -- 是否有免费招募
    local Button_leader_senior_one_recruit = ccui.Helper:seekWidgetByName(root, "Button_leader_senior_one_recruit")
    local Image_leader_senior_gold_one = ccui.Helper:seekWidgetByName(root, "Image_leader_senior_gold_one")
    local Text_leader_senior_gold__one = ccui.Helper:seekWidgetByName(root, "Text_leader_senior_gold__one")
    if tonumber(other_info[1]) < tonumber(other_info[2]) then
        self.isFree = true
        Button_leader_senior_one_recruit:setTitleText(red_alert_time_str[71])
        Image_leader_senior_gold_one:setVisible(false)
        Text_leader_senior_gold__one:setVisible(false)
    else
        self.isFree = false
        Button_leader_senior_one_recruit:setTitleText(activity_str_tip[114])
        Image_leader_senior_gold_one:setVisible(true)
        Text_leader_senior_gold__one:setVisible(true)
    end

    -- 招募花费
    local Text_leader_senior_gold_n = ccui.Helper:seekWidgetByName(root,"Text_leader_senior_gold_n")
    local Text_leader_senior_ten_old_gold_n = ccui.Helper:seekWidgetByName(root,"Text_leader_senior_ten_old_gold_n")
    self.tenNeedGod = tonumber(other_info[4])
    self.oneNeedGod = tonumber(other_info[3])
    self.tenNeedGodOld = tonumber(activity_add_state[9])
    self.discount = tonumber(other_info[5])
    Text_leader_senior_gold__one:setString(self.oneNeedGod)
    Text_leader_senior_gold_n:setString(self.tenNeedGod)
    Text_leader_senior_ten_old_gold_n:setString(self.tenNeedGodOld)

    -- 点亮星星数
    for i = 1, 4 do
        local Panel_leader_legend_recruit_st = ccui.Helper:seekWidgetByName(root,"Panel_leader_legend_recruit_st_"..i)
        Panel_leader_legend_recruit_st:removeBackGroundImage()
        local state = tonumber(activity_add_state[i + 4])
        if state > 0 then
            Panel_leader_legend_recruit_st:setBackGroundImage("images/ui/wonderful/leader_senior_star.png")
        else
            Panel_leader_legend_recruit_st:setBackGroundImage("images/ui/wonderful/leader_senior_star_grad.png")
        end
    end

    -- 最新奖励记录
    local Text_leader_legend_get_rew = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_get_rew")
    if activity_add_state_arry[3] ~= "0" then
        local prop_name = ""
        local rewards = zstring.split(activity_add_state_arry[3], "|")
        local reward_info = zstring.split(rewards[#rewards], ",")
        if tonumber(reward_info[2]) == 6 then
            prop_name = dms.string(dms["prop_mould"], reward_info[1], prop_mould.prop_name)
        elseif tonumber(reward_info[2]) == 13 then
            prop_name = dms.string(dms["ship_mould"], reward_info[1], ship_mould.captain_name)
        end
        Text_leader_legend_get_rew:setString(string.format(activity_str_tip[165], prop_name, tonumber(reward_info[3])))
    else
        Text_leader_legend_get_rew:setString("")
    end


    local Text_leader_legend_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_act_time_1")
    local Text_leader_legend_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_leader_legend_act_time_2")
    Text_leader_legend_act_time_1:setString("")
    Text_leader_legend_act_time_1:removeAllChildren(true)
    Text_leader_legend_act_time_2:setString("")
    Text_leader_legend_act_time_2:removeAllChildren(true)
    -- 结束时间
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    local font_size = Text_leader_legend_act_time_1:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_leader_legend_act_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_leader_legend_act_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_leader_legend_act_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_leader_legend_act_time_1:addChild(time_int_1)
    self._label_close_text = time_int_1
    self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))

    -- 重置时间
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    local time_info_2 = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_leader_legend_act_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_leader_legend_act_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_leader_legend_act_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_leader_legend_act_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_leader_legend_act_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_leader_legend_act_time_2:addChild(time_int_2)
    self._label_reset_text = time_int_2
    self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
end

function RedAlertTimeLeaderSeniorLegend:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_text ~= nil then
            self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("notification_center_update", 0, "red_alert_time_leader_senior_legend_window_close")
        end
    end
end

function RedAlertTimeLeaderSeniorLegend:onEnterTransitionFinish()

end

function RedAlertTimeLeaderSeniorLegend:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.leader_senior_legend)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 活动数据
    -- activity_add_state = "活动起始时间,活动关闭时间,当前时间，累计抽取次数，第一颗星，第二颗星，第三颗星，第四颗星,折扣前金币
                        -- ！已使用免费次数 ,每日免费次数，单次抽取金币，10连抽金币，折扣|第一颗星，次数下限，抽取概率，次数上限|第二颗星，次数下限，抽取概率，次数上限|第三颗星，次数下限，抽取概率，次数上限|第四颗星，次数下限，抽取概率，次数上限|4颗星未全部点亮库组，4颗星全部点亮库组
                        -- ！20个奖励记录(没有时为0)"
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"!")
    local other_info = zstring.split(activity_add_state_arry[2],"|")
    local scene_reward_info = zstring.split(other_info[6], ",")
    local reward_info = zstring.split(dms.string(dms["scene_reward"], tonumber(scene_reward_info[2]), scene_reward.reward_items),",")
    self.leader_id = tonumber(reward_info[1])
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_leader_legend_close"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_legend_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    --英雄属性
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_legend_attritbute"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_legend_look_infor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --奖励预览
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_senior_look_reward"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_legend_reward_preview", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --单次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_senior_one_recruit"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_legend_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)
    
    --10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_senior_ten_recruit"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_legend_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 1,
    }, nil, 1)

    --规则查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_legend_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_legend_get_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --查看记录
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_legend_look"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_legend_look_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)


    self:onUpdateDraw()
    self:updateLeaderInfo()
end

function RedAlertTimeLeaderSeniorLegend:init(params)
    self._activity_type = params[1]
    self:onInit()
    return self
end

function RedAlertTimeLeaderSeniorLegend:onExit()
    state_machine.remove("red_alert_time_leader_senior_legend_look_infor")
    state_machine.remove("red_alert_time_leader_senior_legend_reward_preview")
    state_machine.remove("red_alert_time_leader_senior_legend_get")
    state_machine.remove("red_alert_time_leader_senior_legend_get_rule")
    state_machine.remove("red_alert_time_leader_senior_legend_look_reward")
    state_machine.remove("red_alert_time_leader_senior_legend_sure_choose_recruit")
    state_machine.remove("red_alert_time_leader_senior_legend_update_draw")
end
