--------------------------------------------------------------------------------------------------------------
--  说明：夺回黑匣子 歼灭叛军
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSnatchRebelHauntGet = class("RedAlertTimeSnatchRebelHauntGetClass", Window)

--打开界面
local red_alert_time_snatch_rebel_haunt_get_open_terminal = {
    _name = "red_alert_time_snatch_rebel_haunt_get_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeSnatchRebelHauntGet:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_snatch_rebel_haunt_get_open_terminal)
state_machine.init()

function RedAlertTimeSnatchRebelHauntGet:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._label_close_text = nil
    self._label_reset_text = nil

    self._cost_one = 0  -- 一次花费
    self._cost_all = 0  -- 全开花费
    self._is_free = 0   -- 是否免费

    self._is_over = false

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_full_vitality_cell")
    
    local function init_red_alert_time_snatch_rebel_haunt_get_terminal()
        local red_alert_time_snatch_rebel_haunt_get_show_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_get_show",
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

        local red_alert_time_snatch_rebel_haunt_get_hide_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_get_hide",
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
        local red_alert_time_snatch_rebel_haunt_get_updata_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_get_updata",
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

        local red_alert_time_snatch_rebel_haunt_get_start_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_get_start",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params._datas._type
                local activity_info = _ED.activity_info[""..instance._activity_type]

                -- _type   1；放弃，2：开始/继续，3：全开，4：重新开始
                if _type == 2 and instance._is_over == true then
                    -- 重新开始
                    _type = 4
                end

                if (_type == 2 and instance._is_free == false and instance._cost_one > tonumber(_ED.user_info.user_gold))
                    or (_type == 3 and instance._cost_all > tonumber(_ED.user_info.user_gold))
                    then
                    TipDlg.drawTextDailog(activity_str_tip[174])
                    return
                end

                if _type == 3 then
                    local all_destroy = true
                    for k, v in pairs(activity_info.activity_data[1]) do
                        if tonumber(v.achieve_state) <= 0 then
                            all_destroy = false
                            break
                        end
                    end
                    if all_destroy == true then
                        TipDlg.drawTextDailog(activity_str_tip[176])
                        return
                    end
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if _type == 1 or _type == 4 then
                                response.node:updateNewRewards()
                            end
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end 
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..instance._activity_type.."\r\n".."0".."\r\n".."0".."\r\n".._type
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_snatch_rebel_haunt_get_select_tank_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_get_select_tank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity_info = _ED.activity_info[""..instance._activity_type]
                local index = tonumber(params._datas._index)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end 
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..instance._activity_type.."\r\n".."0".."\r\n"..(index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_snatch_rebel_haunt_get_updata_terminal)
        state_machine.add(red_alert_time_snatch_rebel_haunt_get_hide_terminal)
        state_machine.add(red_alert_time_snatch_rebel_haunt_get_show_terminal)
        state_machine.add(red_alert_time_snatch_rebel_haunt_get_start_terminal)
        state_machine.add(red_alert_time_snatch_rebel_haunt_get_select_tank_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_snatch_rebel_haunt_get_terminal()
end

function RedAlertTimeSnatchRebelHauntGet:updateDraw()
    local root = self.roots[1]

    local Text_snatch_rebel_haunt_times_n = ccui.Helper:seekWidgetByName(root, "Text_snatch_rebel_haunt_times_n")       -- 当前歼敌次数
    local Panel_snatch_rebel_haunt_1 = ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_haunt_1")       -- 选择坦克
    local Panel_snatch_rebel_haunt_2 = ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_haunt_2")       -- 继续歼敌按钮
    local Panel_snatch_rebel_haunt_3 = ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_haunt_3")       -- 开始歼敌文本
    local Image_5 = ccui.Helper:seekWidgetByName(root, "Image_5")      

    Panel_snatch_rebel_haunt_1:setVisible(true)
    Panel_snatch_rebel_haunt_2:setVisible(true)
    Panel_snatch_rebel_haunt_3:setVisible(false)
    Image_5:setVisible(false)

    -- local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_info = self:getActivityInfo()
    local activity_add_state_arry = zstring.split(activity_info.activity_add_state, "!")
    local activity_add_state = zstring.split(activity_add_state_arry[1], ",")
    -- activity_add_state = "开始时间,结束时间,领奖时间,一次花费,全开花费,使用免费次数,最大免费次数,是否开始歼敌,当前歼敌次数,最大歼敌次数,拥有黑匣子数|预览奖励道具id(4个)"
    local start_state = tonumber(activity_add_state[8])
    local current_select_count = tonumber(activity_add_state[9])
    local max_select_count = tonumber(activity_add_state[10])

    local Button_snatch_rebel_haunt_go = ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_go")             -- 开始作战
    local Image_snatch_rebel_haunt_go_gold = ccui.Helper:seekWidgetByName(root, "Image_snatch_rebel_haunt_go_gold")       
    local Text_snatch_rebel_haunt_go_gold_n = ccui.Helper:seekWidgetByName(root, "Text_snatch_rebel_haunt_go_gold_n")

    local Button_snatch_rebel_haunt_all_open = ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_all_open")   -- 一键全开
    local Image_snatch_rebel_haunt_all_gold = ccui.Helper:seekWidgetByName(root, "Image_snatch_rebel_haunt_all_gold")       
    local Text_snatch_rebel_haunt_all_gold_n = ccui.Helper:seekWidgetByName(root, "Text_snatch_rebel_haunt_all_gold_n")

    local Button_snatch_rebel_haunt_not = ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_not")   -- 放弃
    local Button_snatch_rebel_haunt_begin = ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_begin")   -- 继续歼敌

    Button_snatch_rebel_haunt_go:setVisible(true)
    Button_snatch_rebel_haunt_go:setTouchEnabled(true)
    Button_snatch_rebel_haunt_go:setBright(true)
    Button_snatch_rebel_haunt_all_open:setVisible(true)
    Button_snatch_rebel_haunt_all_open:setTouchEnabled(true)
    Button_snatch_rebel_haunt_all_open:setBright(true)
    Button_snatch_rebel_haunt_not:setVisible(true)
    Button_snatch_rebel_haunt_not:setTouchEnabled(true)
    Button_snatch_rebel_haunt_not:setBright(true)

    -- 免费次数
    if tonumber(activity_add_state[6]) < tonumber(activity_add_state[7]) then
        self._is_free = true
        Image_snatch_rebel_haunt_go_gold:setVisible(false)
        Text_snatch_rebel_haunt_go_gold_n:setVisible(false)
    else
        self._is_free = false
        Image_snatch_rebel_haunt_go_gold:setVisible(true)
        Text_snatch_rebel_haunt_go_gold_n:setVisible(true)
        Text_snatch_rebel_haunt_go_gold_n:setString(activity_add_state[4])
    end
    Text_snatch_rebel_haunt_all_gold_n:setString(activity_add_state[5])
    self._cost_one = tonumber(activity_add_state[4])
    self._cost_all = tonumber(activity_add_state[5])

    self._is_over = false
    self._is_end = false

    if tonumber(activity_add_state[3]/1000) - (os.time() + _ED.time_add_or_sub) < 0 then
        -- 活动结束
        self._is_end = true
    end

    if self._is_end == true then
        Image_5:setVisible(true)
        Button_snatch_rebel_haunt_begin:setVisible(true)
        Button_snatch_rebel_haunt_begin:setTitleText(activity_str_tip[171])
        Button_snatch_rebel_haunt_go:setVisible(false)
        Panel_snatch_rebel_haunt_3:setVisible(true)

        Button_snatch_rebel_haunt_begin:setTouchEnabled(false)
        Button_snatch_rebel_haunt_begin:setBright(false)

        Button_snatch_rebel_haunt_not:setVisible(false)
        Button_snatch_rebel_haunt_all_open:setVisible(false)
        Image_snatch_rebel_haunt_all_gold:setVisible(false)
        Text_snatch_rebel_haunt_all_gold_n:setVisible(false)
    else
        if start_state == 0 then
            Image_5:setVisible(true)
            if current_select_count == 0 then       
                -- 开始歼敌
                Button_snatch_rebel_haunt_begin:setVisible(true)
                Button_snatch_rebel_haunt_begin:setTitleText(activity_str_tip[171])
                Button_snatch_rebel_haunt_go:setVisible(false)
                Panel_snatch_rebel_haunt_3:setVisible(true)

                Button_snatch_rebel_haunt_not:setVisible(false)
                Button_snatch_rebel_haunt_all_open:setVisible(false)
                Image_snatch_rebel_haunt_all_gold:setVisible(false)
                Text_snatch_rebel_haunt_all_gold_n:setVisible(false)
            elseif current_select_count < max_select_count then      
                -- 继续歼敌
                Button_snatch_rebel_haunt_begin:setVisible(false)
                Button_snatch_rebel_haunt_go:setVisible(true)

            else
                -- 重新开始
                self._is_over = true
                Button_snatch_rebel_haunt_begin:setVisible(true)
                Button_snatch_rebel_haunt_begin:setTitleText(activity_str_tip[173])
                Button_snatch_rebel_haunt_go:setVisible(false)

                Image_snatch_rebel_haunt_go_gold:setVisible(false)
                Text_snatch_rebel_haunt_go_gold_n:setVisible(false)

                Button_snatch_rebel_haunt_not:setTouchEnabled(false)
                Button_snatch_rebel_haunt_not:setBright(false)
            end
        else
            -- 选择坦克
            Button_snatch_rebel_haunt_begin:setVisible(false)
            Button_snatch_rebel_haunt_go:setVisible(true)

            Button_snatch_rebel_haunt_go:setTouchEnabled(false)
            Button_snatch_rebel_haunt_go:setBright(false)
            Button_snatch_rebel_haunt_all_open:setTouchEnabled(false)
            Button_snatch_rebel_haunt_all_open:setBright(false)
            Button_snatch_rebel_haunt_not:setTouchEnabled(false)
            Button_snatch_rebel_haunt_not:setBright(false)
        end
    end

    local activity_data = activity_info.activity_data[1]
    -- 坦克开启状态
    for i = 1, 6 do
        local Panel_snatch_rebel_haunt_tank = ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_haunt_tank_"..i)
        local Panel_snatch_rebel_icon = ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_icon_"..i)
        if self._is_end == true or tonumber(activity_data[i].achieve_state) <= 1 then
            -- 未开启
            Panel_snatch_rebel_haunt_tank:setVisible(true)
            Panel_snatch_rebel_icon:setVisible(false)
        else
            -- 已开启
            Panel_snatch_rebel_haunt_tank:setVisible(false)
            Panel_snatch_rebel_icon:setVisible(true)
        end
    end

    -- 已选择次数
    local Text_snatch_rebel_haunt_times_n = ccui.Helper:seekWidgetByName(root, "Text_snatch_rebel_haunt_times_n")
    Text_snatch_rebel_haunt_times_n:setString("")
    Text_snatch_rebel_haunt_times_n:removeAllChildren(true)
    local font_size = Text_snatch_rebel_haunt_times_n:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, ""..current_select_count, config_res.font.font_name,font_size / CC_CONTENT_SCALE_FACTOR())
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..max_select_count, config_res.font.font_name,font_size / CC_CONTENT_SCALE_FACTOR())
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_snatch_rebel_haunt_times_n:getContentSize().width/2,Text_snatch_rebel_haunt_times_n:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_snatch_rebel_haunt_times_n:getContentSize().width,19))
    Text_snatch_rebel_haunt_times_n:addChild(_richText)
end

function RedAlertTimeSnatchRebelHauntGet:updateNewRewards()
    local root = self.roots[1]
    -- local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_info = self:getActivityInfo()
    local activity_data = activity_info.activity_data[1]

    for i = 1, 6 do
        local Panel_snatch_rebel_icon = ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_icon_"..i)
        Panel_snatch_rebel_icon:removeAllChildren(true)
        local prop_info = zstring.split(activity_data[i].achieve_reward, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(prop_info[1])
        prop_data.prop_type = tonumber(prop_info[2])
        prop_data.item_value = tonumber(prop_info[3])
        local cell = createPropIconCell(prop_data, true, true, true)
        Panel_snatch_rebel_icon:addChild(cell)
    end

    -- 奖励预览
    local activity_add_state_arry = zstring.split(activity_info.activity_add_state, "!")
    local reward_info = zstring.split(activity_add_state_arry[2], "|")
    for i = 1, 4 do
        local Panel_snatch_rebel_haunt_rew = ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_haunt_rew_"..i)
        Panel_snatch_rebel_haunt_rew:removeAllChildren(true)
        local prop_info = zstring.split(reward_info[i], ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(prop_info[1])
        prop_data.prop_type = tonumber(prop_info[2])
        prop_data.item_value = tonumber(prop_info[3])
        local cell = createPropIconCell(prop_data, true, true, true)
        Panel_snatch_rebel_haunt_rew:addChild(cell)
    end
end

--初始化
function RedAlertTimeSnatchRebelHauntGet:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.snatch_rebel_haunt_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    
    -- 放弃
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_not"), nil, 
    {
        terminal_name = "red_alert_time_snatch_rebel_haunt_get_start", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 1,
    }, nil, 1)

    -- 开始歼敌
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_begin"), nil, 
    {
        terminal_name = "red_alert_time_snatch_rebel_haunt_get_start", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 2,
    }, nil, 1)

    -- 继续歼敌
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_go"), nil, 
    {
        terminal_name = "red_alert_time_snatch_rebel_haunt_get_start", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 2,
    }, nil, 1)

    -- 一键全开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_all_open"), nil, 
    {
        terminal_name = "red_alert_time_snatch_rebel_haunt_get_start", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 3,
    }, nil, 1)

    for i = 1, 6 do
        -- 选择
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_haunt_tank_"..i), nil, 
        {
            terminal_name = "red_alert_time_snatch_rebel_haunt_get_select_tank", 
            terminal_state = 0, 
            index = i,
        }, nil, 1)
    end

    self:updateNewRewards()
    self:updateDraw()
end

function RedAlertTimeSnatchRebelHauntGet:onEnterTransitionFinish()

end

function RedAlertTimeSnatchRebelHauntGet:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeSnatchRebelHauntGet:onExit()
    state_machine.remove("red_alert_time_snatch_rebel_haunt_get_show")
    state_machine.remove("red_alert_time_snatch_rebel_haunt_get_hide")
    state_machine.remove("red_alert_time_snatch_rebel_haunt_get_updata")
    state_machine.remove("red_alert_time_snatch_rebel_haunt_get_start")
    state_machine.remove("red_alert_time_snatch_rebel_haunt_get_select_tank")
end

-- 测试数据  活动数据格式
function RedAlertTimeSnatchRebelHauntGet:getActivityInfo( ... )
    local activity_info = {
        activity_dec = "无",
        activity_type = "46",
        activity_pic = "-1,-1,-1,-1,-1,-1",
        activity_state = "0",
        activity_id = "15",
        start_time = 1501297213,
            activity_data = {
            [1] = {
                [1] = {
                    achieve_index = 1,
                    achieve_complete_count = "0/1",
                    achieve_state = "2",        -- 是否已选择
                    achieve_mould_name = "幸运抽奖",
                    achieve_other_info = "-1",
                    achieve_mould_dec = "——", 
                    achieve_reward = "216,6,1",     -- 获得奖励
                },
                [2] = {
                    achieve_index = 2,
                    achieve_complete_count = "0/1",
                    achieve_state = "2",        -- 是否已选择
                    achieve_mould_name = "幸运抽奖",
                    achieve_other_info = "-1",
                    achieve_mould_dec = "——", 
                    achieve_reward = "216,6,1",     -- 获得奖励
                },
                [3] = {
                    achieve_index = 3,
                    achieve_complete_count = "0/1",
                    achieve_state = "2",        -- 是否已选择（0：未选择，>0已选择)
                    achieve_mould_name = "幸运抽奖",
                    achieve_other_info = "-1",
                    achieve_mould_dec = "——", 
                    achieve_reward = "216,6,1",     -- 获得奖励
                },
                [4] = {
                    achieve_index = 4,
                    achieve_complete_count = "0/1",
                    achieve_state = "2",        -- 是否已选择
                    achieve_mould_name = "幸运抽奖",
                    achieve_other_info = "-1",
                    achieve_mould_dec = "——", 
                    achieve_reward = "216,6,1",     -- 获得奖励
                },
                [5] = {
                    achieve_index = 5,
                    achieve_complete_count = "0/1",
                    achieve_state = "2",        -- 是否已选择
                    achieve_mould_name = "幸运抽奖",
                    achieve_other_info = "-1",
                    achieve_mould_dec = "——", 
                    achieve_reward = "216,6,1",     -- 获得奖励
                },
                [6] = {
                    achieve_index = 6,
                    achieve_complete_count = "0/1",
                    achieve_state = "2",        -- 是否已选择
                    achieve_mould_name = "幸运抽奖",
                    achieve_other_info = "-1",
                    achieve_mould_dec = "——", 
                    achieve_reward = "216,6,1",     -- 获得奖励
                },
            },
            [2] = {
                [1] = {
                    achieve_index = 1,
                    achieve_complete_count = "1/1",
                    achieve_state = "1",
                    achieve_mould_name = "大型资源箱",
                    achieve_other_info = "100",             -- 兑换话费黑匣子
                    achieve_mould_dec = "——",
                    achieve_reward = "247,6,1",
                },
            },
        },
        -- activity_add_state = "开始时间,结束时间,领奖时间,一次花费,全开花费,使用免费次数,最大免费次数,是否开始歼敌,当前歼敌次数,最大歼敌次数,拥有黑匣子数!预览奖励道具id(4个)"
        activity_add_state = "1501110000000,1501430400000,1501182001372,40,280,0,1,0,6,4,0!216,6,1|217,6,1|218,6,1|219,6,1",
        activity_title = "夺回黑匣子",
    }

    return activity_info
end