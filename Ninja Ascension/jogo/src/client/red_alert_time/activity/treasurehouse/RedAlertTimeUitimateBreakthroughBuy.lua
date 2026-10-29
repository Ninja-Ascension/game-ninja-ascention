--------------------------------------------------------------------------------------------------------------
--  极限突破研究
--------------------------------------------------------------------------------------------------------------
RedAlertTimeUitimateBreakthroughBuy = class("RedAlertTimeUitimateBreakthroughBuyClass", Window)

--打开界面
local red_alert_time_uitimate_breakthrough_buy_open_terminal = {
    _name = "red_alert_time_uitimate_breakthrough_buy_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeUitimateBreakthroughBuy:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_uitimate_breakthrough_buy_open_terminal)
state_machine.init()

function RedAlertTimeUitimateBreakthroughBuy:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 定义变量
    self._activity_type = 0
    self._prop_id_1 = 0
    self._prop_id_2 = 0

    self._is_end = false
    self._is_free = false
    self.m_times = 0
    self.m_reset_times = 0
    self._label_close_text = nil
    self._label_reset_text = nil

    self.oneNeedGod = 0
    self.tenNeedGod = 0
    self.superNeedGod = 0
    self.discount = 0
    self.tenNeedGodOld = 0
    self._need_vip = 0
    
    -- 初始化状态机
    local function init_red_alert_time_uitimate_breakthrough_buy_terminal()
        local red_alert_time_uitimate_breakthrough_buy_show_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_buy_show",
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

        local red_alert_time_uitimate_breakthrough_buy_hide_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_buy_hide",
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
        local red_alert_time_uitimate_breakthrough_buy_update_draw_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_buy_update_draw",
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

        local red_alert_time_uitimate_breakthrough_buy_reward_preview_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_buy_reward_preview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local activity_info = _ED.activity_info[""..instance._activity_type]
                local activity_data = activity_info.activity_data[1][index]
                local reward_info = zstring.split(activity_data.achieve_reward, "|")
                state_machine.excute("red_alert_time_box_preview_window_open",0,{reward_info , activity_str_tip[203]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_uitimate_breakthrough_buy_get_rule_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_buy_get_rule",
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

        -- 招募
        local red_alert_time_uitimate_breakthrough_buy_get_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_buy_get",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local curr_type = params._datas._type
                if curr_type == 2 and tonumber(_ED.vip_grade) < instance._need_vip then
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {}, m_type = 40}})
                    return
                end
                if curr_type ~= 0 and instance._is_free == true then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    return
                end
                if curr_type == 0 and instance._is_free == true then
                    state_machine.excute("red_alert_time_uitimate_breakthrough_buy_sure_choose_recruit",0,{0})
                else
                    local need_gold = 0
                    local cost = 0
                    if curr_type == 0 then
                        need_gold = instance.oneNeedGod
                        cost = 1
                    elseif curr_type == 1 then
                        cost = 10
                        need_gold = instance.tenNeedGod
                    else
                        cost = 1
                        need_gold = instance.superNeedGod
                    end
                    if tonumber(need_gold) > tonumber(_ED.user_info.user_gold) then
                        TipDlg.drawTextDailog(tipStringInfo_campaign_info[16])
                        return
                    end
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold,cost,curr_type}, m_type = 39}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_uitimate_breakthrough_buy_sure_choose_recruit_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_buy_sure_choose_recruit",
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
                                    state_machine.excute("red_alert_time_leader_senior_once_window_open", 0, {response.node._activity_type, response.node.oneNeedGod, false, choose_type})
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

        state_machine.add(red_alert_time_uitimate_breakthrough_buy_update_draw_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_buy_hide_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_buy_show_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_buy_reward_preview_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_buy_get_rule_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_buy_get_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_buy_sure_choose_recruit_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_uitimate_breakthrough_buy_terminal()
end

function RedAlertTimeUitimateBreakthroughBuy:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]

    -- activity_add_state = "开始时间,结束时间,领奖时间,免费次数,免费最大次数,单抽金币,10连金币,超级实验金币,折扣,10连原价,超级实验剩余次数,超级实验最大次数,超级实验需要VIP等级,核心1id，核心2id，改造坦克1id，改造坦克2id
    --                     !获奖记录"      
    local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "!")
    local activity_add_state = zstring.split(activity_add_state_arr[1], ",")

    local Text_seek_treasure_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_infor_p_1")
    Text_seek_treasure_infor_p_1:setString(activity_info.activity_dec)

    -- 奖励信息
    for i = 1, 2 do
        local Panel_uitimate_breakthrough_icon = ccui.Helper:seekWidgetByName(root,"Panel_uitimate_breakthrough_icon_"..i)
        local Text_uitimate_breakthrough_name = ccui.Helper:seekWidgetByName(root,"Text_uitimate_breakthrough_name_"..i)
        local Text_uitimate_breakthrough_have_n = ccui.Helper:seekWidgetByName(root,"Text_uitimate_breakthrough_have_n_"..i)
        local prop_id = tonumber(activity_add_state[13 + i])
        local prop_name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
        local prop_count = 0
        local prop = fundPropWidthId(prop_id)
        if prop ~= nil then
            prop_count = tonumber(prop.prop_number)
        end

        Panel_uitimate_breakthrough_icon:removeAllChildren(true)
        local prop_data = {}
        prop_data.prop_item = prop_id
        prop_data.prop_type = 6
        prop_data.item_value = 0
        local cell = createPropIconCell(prop_data, false, false, true)
        Panel_uitimate_breakthrough_icon:addChild(cell)

        Text_uitimate_breakthrough_name:setString(prop_name)
        Text_uitimate_breakthrough_have_n:setString(prop_count)
    end

    local activity_data = activity_info.activity_data[1]
    for i = 1, 3 do
        local Panel_uitimate_breakthrough_graduate = ccui.Helper:seekWidgetByName(root,"Panel_uitimate_breakthrough_graduate_"..i)
        Panel_uitimate_breakthrough_graduate:removeBackGroundImage()

        local ship_id = tonumber(activity_data[i].achieve_other_info)
        local pic_index = dms.string(dms["ship_mould"], ship_id, ship_mould.All_icon)
        Panel_uitimate_breakthrough_graduate:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic_index))
    end

    -- 按钮状态
    self._is_free = false
    self._is_end = false
    if tonumber(activity_add_state[3]/1000) - (os.time() + _ED.time_add_or_sub) < 0 then
        self._is_end = true
    elseif tonumber(activity_add_state[4]) < tonumber(activity_add_state[5]) then
        self._is_free = true
    end

    local Button_uitimate_experiment_free = ccui.Helper:seekWidgetByName(root,"Button_uitimate_experiment_free")
    local Panel_uitimate_experiment_gold_one = ccui.Helper:seekWidgetByName(root,"Panel_uitimate_experiment_gold_one")
    local Button_uitimate_experiment_one = ccui.Helper:seekWidgetByName(root,"Button_uitimate_experiment_one")
    local Button_uitimate_experiment_ten = ccui.Helper:seekWidgetByName(root,"Button_uitimate_experiment_ten")
    local Button_uitimate_experiment_up = ccui.Helper:seekWidgetByName(root,"Button_uitimate_experiment_up")
    local Text_uitimate_experiment_gold_one_n = ccui.Helper:seekWidgetByName(root,"Text_uitimate_experiment_gold_one_n")
    local Text_uitimate_experiment_gold_ten_n = ccui.Helper:seekWidgetByName(root,"Text_uitimate_experiment_gold_ten_n")
    local Text_uitimate_experiment_old_gold_n = ccui.Helper:seekWidgetByName(root,"Text_uitimate_experiment_old_gold_n")
    local Text_uitimate_experiment_gold_n = ccui.Helper:seekWidgetByName(root,"Text_uitimate_experiment_gold_n")
    local Text_festival_each_dis_ten_n = ccui.Helper:seekWidgetByName(root,"Text_festival_each_dis_ten_n")
    Button_uitimate_experiment_one:setTouchEnabled(true)
    Button_uitimate_experiment_one:setBright(true)
    Button_uitimate_experiment_ten:setTouchEnabled(true)
    Button_uitimate_experiment_ten:setBright(true)
    Button_uitimate_experiment_up:setTouchEnabled(true)
    Button_uitimate_experiment_up:setBright(true)

    if self._is_free == true then
        Button_uitimate_experiment_free:setVisible(true)
        Panel_uitimate_experiment_gold_one:setVisible(false)
    else
        Button_uitimate_experiment_free:setVisible(false)
        Panel_uitimate_experiment_gold_one:setVisible(true)
    end

    self.oneNeedGod = tonumber(activity_add_state[6])
    self.tenNeedGod = tonumber(activity_add_state[7])
    self.discount = tonumber(activity_add_state[9])
    self.tenNeedGodOld = tonumber(activity_add_state[10])
    self._need_vip = tonumber(activity_add_state[13])
    self.superNeedGod = tonumber(activity_add_state[8])

    local leave_count = tonumber(activity_add_state[11])
    local total_count = tonumber(activity_add_state[12])

    Text_uitimate_experiment_gold_one_n:setString(self.oneNeedGod)
    Text_uitimate_experiment_gold_ten_n:setString(self.tenNeedGod)
    Text_uitimate_experiment_old_gold_n:setString(self.tenNeedGodOld)
    Text_uitimate_experiment_gold_n:setString(self.superNeedGod.."("..leave_count.."/"..total_count..")")

    local curr = tonumber(self.discount)
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr = (10 - curr) * 10
    end
    local discounts = string.format(activity_str_tip[22],""..curr)
    Text_festival_each_dis_ten_n:setString(discounts)

    if leave_count <= 0 then
        Button_uitimate_experiment_up:setTouchEnabled(false)
        Button_uitimate_experiment_up:setBright(false)
    end

    if self._is_end == true then
        Button_uitimate_experiment_one:setTouchEnabled(false)
        Button_uitimate_experiment_one:setBright(false)
        Button_uitimate_experiment_ten:setTouchEnabled(false)
        Button_uitimate_experiment_ten:setBright(false)
        Button_uitimate_experiment_up:setTouchEnabled(false)
        Button_uitimate_experiment_up:setBright(false)
    end

    -- 显示倒计时
    local time_str = activity_str_tip[93]
    if self._is_end == false then
        self.m_times = tonumber(activity_add_state[3]) / 1000 - (os.time() + _ED.time_add_or_sub)
    else
        self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)
        time_str = activity_str_tip[92]
    end

    local Text_seek_treasure_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_act_time_1")
    Text_seek_treasure_act_time_1:removeAllChildren(true)
    Text_seek_treasure_act_time_1:setString("")
    local time_info, time_int = createActivityTimeLable(Text_seek_treasure_act_time_1, 0, time_str, "")
    Text_seek_treasure_act_time_1:addChild(time_info)
    Text_seek_treasure_act_time_1:addChild(time_int)
    self._label_close_text = time_int
    
    -- 重置时间
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_seek_treasure_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_act_time_2")
    Text_seek_treasure_act_time_2:removeAllChildren(true)
    Text_seek_treasure_act_time_2:setString("")
    local reset_time_info, reset_time_int = createActivityTimeLable(Text_seek_treasure_act_time_2, 0, activity_str_tip[96], "")
    Text_seek_treasure_act_time_2:addChild(reset_time_info)
    Text_seek_treasure_act_time_2:addChild(reset_time_int)
    self._label_reset_text = reset_time_int
end

function RedAlertTimeUitimateBreakthroughBuy:onUpdate(dt)
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
function RedAlertTimeUitimateBreakthroughBuy:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.uitimate_breakthrough_tab, 1))    
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    --免费
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_uitimate_experiment_free"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_buy_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)

    --单次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_uitimate_experiment_one"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_buy_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)
    
    --10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_uitimate_experiment_ten"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_buy_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 1,
    }, nil, 1)

    --超级实验
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_uitimate_experiment_up"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_buy_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 2,
    }, nil, 1)

    --奖励查看
    for i = 1, 3 do
        local Panel_uitimate_breakthrough_graduate = ccui.Helper:seekWidgetByName(root, "Panel_uitimate_breakthrough_graduate_"..i)
        Panel_uitimate_breakthrough_graduate:setTouchEnabled(true)
        fwin:addTouchEventListener(Panel_uitimate_breakthrough_graduate, nil, 
        {
            terminal_name = "red_alert_time_uitimate_breakthrough_buy_reward_preview", 
            terminal_state = 0, 
            index = i,
        }, nil, 1)
    end

    --规则查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_april_fools_happy_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_buy_get_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:onUpdateDraw()
end

function RedAlertTimeUitimateBreakthroughBuy:onEnterTransitionFinish()

end

function RedAlertTimeUitimateBreakthroughBuy:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeUitimateBreakthroughBuy:onExit()
    -- 移除状态机
    state_machine.remove("red_alert_time_uitimate_breakthrough_buy_show")
    state_machine.remove("red_alert_time_uitimate_breakthrough_buy_hide")
    state_machine.remove("red_alert_time_uitimate_breakthrough_buy_update_draw")
    state_machine.remove("red_alert_time_uitimate_breakthrough_buy_reward_preview")
    state_machine.remove("red_alert_time_uitimate_breakthrough_buy_get_rule")
    state_machine.remove("red_alert_time_uitimate_breakthrough_buy_get")
    state_machine.remove("red_alert_time_uitimate_breakthrough_buy_sure_choose_recruit")
end