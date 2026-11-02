--------------------------------------------------------------------------------------------------------------
--  猎鹰突击收集
--------------------------------------------------------------------------------------------------------------
RedAlertTimeFalconAssaultCollotion = class("RedAlertTimeFalconAssaultCollotionClass", Window)

--打开界面
local red_alert_time_falcon_assault_collotion_open_terminal = {
    _name = "red_alert_time_falcon_assault_collotion_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = RedAlertTimeFalconAssaultCollotion:new():init(params)
        fwin:open(panel)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_falcon_assault_collotion_open_terminal)
state_machine.init()

function RedAlertTimeFalconAssaultCollotion:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 定义变量
    self._activity_type = 0
    self._tank_id = 0
    self._reform_tank_id = 0

    self._is_free = false
    self._is_end = false

    self.m_times = 0
    self.m_reset_times = 0
    self._label_close_text = nil
    self._label_reset_text = nil

    -- 加载lua文件
    
    -- 初始化状态机
    local function init_red_alert_time_falcon_assault_collotion_terminal()
        local red_alert_time_falcon_assault_collotion_show_terminal = {
            _name = "red_alert_time_falcon_assault_collotion_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_falcon_assault_collotion_hide_terminal = {
            _name = "red_alert_time_falcon_assault_collotion_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local red_alert_time_falcon_assault_collotion_update_draw_terminal = {
            _name = "red_alert_time_falcon_assault_collotion_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 奖励
        local red_alert_time_falcon_assault_collotion_reward_preview_terminal = {
            _name = "red_alert_time_falcon_assault_collotion_reward_preview",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local activity_info = _ED.activity_info[""..instance._activity_type]
                local activity_data = activity_info.activity_data[1][1]
                local reward_info = zstring.split(activity_data.achieve_reward,"|")
                state_machine.excute("red_alert_time_box_preview_window_open",0,{reward_info , activity_str_tip[200]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 招募
        local red_alert_time_falcon_assault_collotion_get_terminal = {
            _name = "red_alert_time_falcon_assault_collotion_get",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local curr_type = params._datas._type
                if curr_type == 1 and instance._is_free == true then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    return
                end
                if curr_type == 0 and instance._is_free == true then
                    state_machine.excute("red_alert_time_falcon_assault_collotion_sure_choose_recruit",0,{0})
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
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold,cost,curr_type}, m_type = 38}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_falcon_assault_collotion_sure_choose_recruit_terminal = {
            _name = "red_alert_time_falcon_assault_collotion_sure_choose_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local choose_type = params[1]
                local acitvity = _ED.activity_info[""..instance._activity_type]
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if choose_type == 1 then
                                if fwin:find("RedAlertTimeLeaderSeniorTenClass") ~= nil then
                                    state_machine.excute("red_alert_time_leader_senior_ten_update_draw", 0, nil)
                                else
                                    state_machine.excute("red_alert_time_leader_senior_ten_window_open", 0, {response.node._activity_type, response.node.tenNeedGod, response.node.tenNeedGodOld, response.node.discount})
                                end
                            else
                                if fwin:find("RedAlertTimeLeaderSeniorOnceClass") ~= nil then
                                    state_machine.excute("red_alert_time_leader_senior_once_update_draw", 0, nil)
                                else
                                    state_machine.excute("red_alert_time_leader_senior_once_window_open", 0, {response.node._activity_type, response.node.oneNeedGod, false})
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

        local red_alert_time_falcon_assault_collotion_get_rule_terminal = {
            _name = "red_alert_time_falcon_assault_collotion_get_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_falcon_assault_collotion_update_draw_terminal)
        state_machine.add(red_alert_time_falcon_assault_collotion_hide_terminal)
        state_machine.add(red_alert_time_falcon_assault_collotion_show_terminal)
        state_machine.add(red_alert_time_falcon_assault_collotion_reward_preview_terminal)
        state_machine.add(red_alert_time_falcon_assault_collotion_get_terminal)
        state_machine.add(red_alert_time_falcon_assault_collotion_sure_choose_recruit_terminal)
        state_machine.add(red_alert_time_falcon_assault_collotion_get_rule_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_falcon_assault_collotion_terminal()
end

 -- 坦克信息
function RedAlertTimeFalconAssaultCollotion:updateTankInfo()
    local root = self.roots[1]
    local tank_data = dms.element(dms["ship_mould"], self._reform_tank_id)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)
    local pic_index = dms.atos(tank_data, ship_mould.All_icon)
    local output = dms.atoi(tank_data, ship_mould.initial_power)
    local attack = dms.atoi(tank_data, ship_mould.initial_courage)
    local load = dms.atoi(tank_data, ship_mould.ability)
    local talent_ids = zstring.split(dms.atos(tank_data, ship_mould.talent_id),"|")

    -- 名称
    local Text_falcon_assault_name = ccui.Helper:seekWidgetByName(root,"Text_falcon_assault_name")
    Text_falcon_assault_name:setString(tank_name)

    -- 图标
    local Panel_falcon_assault_icon = ccui.Helper:seekWidgetByName(root,"Panel_falcon_assault_icon")
    Panel_falcon_assault_icon:removeBackGroundImage()
    Panel_falcon_assault_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic_index))

    -- 属性
    local Text_output_n_1 = ccui.Helper:seekWidgetByName(root,"Text_output_n_1")
    local Text_output_n_2 = ccui.Helper:seekWidgetByName(root,"Text_output_n_2")
    local Text_output_n_3 = ccui.Helper:seekWidgetByName(root,"Text_output_n_3")
    Text_output_n_1:setString(attack)
    Text_output_n_2:setString(output)
    Text_output_n_3:setString(load)

    -- 技能
    local Text_festival_each_child_p_n = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_p_n")
    Text_festival_each_child_p_n:removeAllChildren(true)
    Text_festival_each_child_p_n:setString("")
    local skill_infor = ""
    for k, v in pairs(talent_ids) do
        local info = zstring.split(v, ",")
        local talent_name = dms.string(dms["talent_mould"], tonumber(info[3]), talent_mould.talent_name)
        local talent_des = dms.string(dms["talent_mould"], tonumber(info[3]), talent_mould.talent_describe)
        if tonumber(info[1]) == 0 then
            skill_infor = skill_infor.."%|2|"..talent_name..":".."%"
        else
            skill_infor = skill_infor.."%|3|"..talent_name..":".."%"
        end
        skill_infor = skill_infor..talent_des.."\r\n"
    end

    local font_size = Text_festival_each_child_p_n:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local rt2, count2, text2 = draw.richTextCollectionMethod(_richText, 
        skill_infor, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        font_size,
        chat_rich_text_color)

    _richText:setContentSize(cc.size(Text_festival_each_child_p_n:getContentSize().width, Text_festival_each_child_p_n:getContentSize().height))  
    _richText:setPosition(cc.p(Text_festival_each_child_p_n:getContentSize().width / 2, Text_festival_each_child_p_n:getContentSize().height / 2))  
    Text_festival_each_child_p_n:addChild(_richText)
end

function RedAlertTimeFalconAssaultCollotion:updateDraw()
    local root = self.roots[1]

    local activity_info = _ED.activity_info[""..self._activity_type]
    -- activity_add_state = "活动起始时间,活动关闭时间,当前时间，坦克id， 改造坦克id，已使用免费次数 ,每日免费次数，单次抽取金币，10连抽金币，折扣，10连抽原价
    --                       !收集记录记录(没有时为0)"
    local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "!")
    local activity_add_state = zstring.split(activity_add_state_arr[1], ",")

    -- 改造信息
    local Text_festival_each_child_time_n = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_time_n")
    local Text_festival_each_child_time_n_0 = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_time_n_0")
    self._tank_id = tonumber(activity_add_state[4])
    self._reform_tank_id = tonumber(activity_add_state[5])
    local tank_count = 0
    local reform_tank_count = 0
    local tank_info = fundShipWidthTemplateId(self._tank_id)
    if tank_info ~= nil then
        tank_count = tonumber(tank_info.current_count)
    end
    local reform_tank_info =  fundShipWidthTemplateId(self._reform_tank_id)
    if reform_tank_info ~= nil then
        reform_tank_count = tonumber(reform_tank_info.current_count)
    end
    Text_festival_each_child_time_n:setString(tank_count)
    Text_festival_each_child_time_n_0:setString(reform_tank_count)

    -- 收集状态
    local Button_festival_each_child_record = ccui.Helper:seekWidgetByName(root,"Button_festival_each_child_record")
    local Button_festival_each_child = ccui.Helper:seekWidgetByName(root,"Button_festival_each_child")

    local Panel_festival_each_child_gold_one = ccui.Helper:seekWidgetByName(root, "Panel_festival_each_child_gold_one")
    local Button_festival_each_child_one = ccui.Helper:seekWidgetByName(root,"Button_festival_each_child_one")
    local Text_festival_each_child_gold_one_n = ccui.Helper:seekWidgetByName(root, "Text_festival_each_child_gold_one_n")

    local Text_festival_each_child_gold_n = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_gold_n")
    local Text_festival_each_dis_ten_n = ccui.Helper:seekWidgetByName(root,"Text_festival_each_dis_ten_n")

    self._is_free = false
    self._is_end = false
    if tonumber(activity_add_state[3]/1000) - (os.time() + _ED.time_add_or_sub) < 0 then
        self._is_end = true
    elseif tonumber(activity_add_state[6]) < tonumber(activity_add_state[7]) then
        self._is_free = true
    end

    if self._is_free == true then
        Button_festival_each_child_record:setVisible(true)
        Panel_festival_each_child_gold_one:setVisible(false)
    else
        Button_festival_each_child_record:setVisible(false)
        Panel_festival_each_child_gold_one:setVisible(true)
    end

    if self._is_end == true then
        Button_festival_each_child_one:setTouchEnabled(false)
        Button_festival_each_child_one:setBright(false)
        Button_festival_each_child:setTouchEnabled(false)
        Button_festival_each_child:setBright(false)
    else
        Button_festival_each_child_one:setTouchEnabled(true)
        Button_festival_each_child_one:setBright(true)
        Button_festival_each_child:setTouchEnabled(true)
        Button_festival_each_child:setBright(true)
    end

    self.tenNeedGod = tonumber(activity_add_state[9])
    self.oneNeedGod = tonumber(activity_add_state[8])
    self.tenNeedGodOld = tonumber(activity_add_state[11])
    self.discount = tonumber(activity_add_state[10])

    Text_festival_each_child_gold_one_n:setString(self.oneNeedGod)
    Text_festival_each_child_gold_n:setString(self.tenNeedGod)

    local curr = tonumber(self.discount)
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr = (10 - curr) * 10
    end
    local discounts = string.format(activity_str_tip[22],""..curr)
    Text_festival_each_dis_ten_n:setString(discounts)

    -- 收集记录
    local ListView_falcon_record = ccui.Helper:seekWidgetByName(root,"ListView_falcon_record")
    ListView_falcon_record:removeAllItems()
    local reward_info = {}
    if activity_add_state_arr[2] ~= "0" then
        reward_info = zstring.split(activity_add_state_arr[2], "|")
    end
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local reward = {}
        reward.prop_item = tonumber(info[1])
        reward.prop_type = tonumber(info[2])
        reward.item_value = tonumber(info[3])
        local cell = createPropIconCell(reward, true, true, true)
        ListView_falcon_record:addChild(cell)
    end

    ListView_falcon_record:requestRefreshView()

    -- 显示倒计时
    self._is_end = false
    if tonumber(activity_add_state[3]/1000) - (os.time() + _ED.time_add_or_sub) < 0 then
        self._is_end = true
    end

    local time_str = activity_str_tip[93]
    if self._is_end == false then
        self.m_times = tonumber(activity_add_state[3]) / 1000 - (os.time() + _ED.time_add_or_sub)
    else
        self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)
        time_str = activity_str_tip[92]
    end

    local Text_festival_blessing_time_1 = ccui.Helper:seekWidgetByName(root,"Text_festival_blessing_time_1")
    Text_festival_blessing_time_1:removeAllChildren(true)
    Text_festival_blessing_time_1:setString("")
    local time_info, time_int = createActivityTimeLable(Text_festival_blessing_time_1, 0, time_str, "")
    Text_festival_blessing_time_1:addChild(time_info)
    Text_festival_blessing_time_1:addChild(time_int)
    self._label_close_text = time_int
    
    -- 重置时间
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_festival_blessing_time_2 = ccui.Helper:seekWidgetByName(root,"Text_festival_blessing_time_2")
    Text_festival_blessing_time_2:removeAllChildren(true)
    Text_festival_blessing_time_2:setString("")
    local reset_time_info, reset_time_int = createActivityTimeLable(Text_festival_blessing_time_2, 0, activity_str_tip[96], "")
    Text_festival_blessing_time_2:addChild(reset_time_info)
    Text_festival_blessing_time_2:addChild(reset_time_int)
    self._label_reset_text = reset_time_int
end

function RedAlertTimeFalconAssaultCollotion:onUpdate(dt)
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
            if self._is_end == false then
                self:onUpdateDraw()
            end
        end
    end
end

--初始化
function RedAlertTimeFalconAssaultCollotion:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.falcon_assault_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    --免费
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_each_child_record"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_collotion_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)

    --单次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_each_child_one"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_collotion_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)
    
    --10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_each_child"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_collotion_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 1,
    }, nil, 1)

    --奖励查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_each_child_record_0"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_collotion_reward_preview", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --规则查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_blessing_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_collotion_get_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:updateDraw()
    self:updateTankInfo()
end

function RedAlertTimeFalconAssaultCollotion:onEnterTransitionFinish()

end

function RedAlertTimeFalconAssaultCollotion:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    -- 初始化参数
    self:onInit()
    return self
end

function RedAlertTimeFalconAssaultCollotion:onExit()
    -- 移除状态机
    state_machine.remove("red_alert_time_falcon_assault_collotion_show")
    state_machine.remove("red_alert_time_falcon_assault_collotion_hide")
    state_machine.remove("red_alert_time_falcon_assault_collotion_update_draw")
    state_machine.remove("red_alert_time_falcon_assault_collotion_reward_preview")
    state_machine.remove("red_alert_time_falcon_assault_collotion_get")
    state_machine.remove("red_alert_time_falcon_assault_collotion_sure_choose_recruit")
    state_machine.remove("red_alert_time_falcon_assault_collotion_get_rule")
end