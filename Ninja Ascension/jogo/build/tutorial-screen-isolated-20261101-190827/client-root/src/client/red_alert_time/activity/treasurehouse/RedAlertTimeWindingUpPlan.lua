--------------------------------------------------------------------------------------------------------------
--  说明：清盘计划
--------------------------------------------------------------------------------------------------------------
RedAlertTimeWindingUpPlan = class("RedAlertTimeWindingUpPlanClass", Window)

--打开界面
local red_alert_time_winding_up_plan_open_terminal = {
	_name = "red_alert_time_winding_up_plan_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeWindingUpPlanClass") == nil then
    		fwin:open(RedAlertTimeWindingUpPlan:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_winding_up_plan_close_terminal = {
	_name = "red_alert_time_winding_up_plan_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeWindingUpPlanClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_winding_up_plan_open_terminal)
state_machine.add(red_alert_time_winding_up_plan_close_terminal)
state_machine.init()

function RedAlertTimeWindingUpPlan:ctor()
	self.super:ctor()
	self.roots = {}
    self._activity_type = nil
    self.m_times = 0
    self.accept_the_prize = nil
    self._round = 0
    self.roundImage = nil
    self._image_list = {}
	app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_winding_up_plan_cell")
    local function init_red_alert_time_winding_up_plan_terminal()
        local red_alert_time_winding_up_plan_show_terminal = {
            _name = "red_alert_time_winding_up_plan_show",
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

        local red_alert_time_winding_up_plan_hide_terminal = {
            _name = "red_alert_time_winding_up_plan_hide",
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

        -- 开始清盘
        local red_alert_time_winding_up_plan_start_terminal = {
            _name = "red_alert_time_winding_up_plan_start",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("red_alert_time_winding_up_plan_start")
                local acitvity = _ED.activity_info[""..instance._activity_type.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:beginRotary()
                        end
                    else
                        state_machine.unlock("red_alert_time_winding_up_plan_start") 
                    end
                end 
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..instance._activity_type.activity_type.."\r\n".."0".."\r\n".."0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 刷新
        local red_alert_time_winding_up_plan_updata_terminal = {
            _name = "red_alert_time_winding_up_plan_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 规则
        local red_alert_time_winding_up_plan_rule_open_terminal = {
            _name = "red_alert_time_winding_up_plan_rule_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,96)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_winding_up_plan_rule_open_terminal)
        state_machine.add(red_alert_time_winding_up_plan_updata_terminal)
        state_machine.add(red_alert_time_winding_up_plan_hide_terminal)
        state_machine.add(red_alert_time_winding_up_plan_start_terminal)
        state_machine.add(red_alert_time_winding_up_plan_show_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_winding_up_plan_terminal()
end

function RedAlertTimeWindingUpPlan:endRotary( ... )
    self._round = 0
    state_machine.unlock("red_alert_time_winding_up_plan_start")
    local function playActionOne(sender)
        if sender.roots ~= nil then
            sender:stopAllActions()
            sender:updateDraw()
        end
        checkRewardObtainDraw()
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end

function RedAlertTimeWindingUpPlan:beginRotary( ... )
    local root = self.roots[1]
    local index = 0
    local delayTime = 0
    local max_times = 0
    self._round = self._round + 1
    if self._round == 1 then
        delayTime = 0.08
        max_times = 12
    elseif self._round == 2 then
        delayTime = 0.1
        max_times = self:getRewardIndex()
    end

    local function playActionOne(sender)
        index = index + 1
        if index == 1 then
            self.roundImage:setVisible(true)
        end
        if index > max_times then
            sender:stopAllActions()
            if sender._round ~= 2 then
                sender:beginRotary()
            else
                sender:endRotary()
            end
        else
            local cell_index = math.floor((index - 1 )%12) + 1
            for k,v in pairs(sender._image_list) do
                if k == cell_index then
                    self.roundImage:setPosition(cc.p(v:getPositionX() - 7 , v:getPositionY() - 7 ))
                    break
                end
            end
        end
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(delayTime),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end
function RedAlertTimeWindingUpPlan:getRewardIndex()
    local index = 0
    local reward_data = getSceneReward(1096)
    local data = reward_data.show_reward_list[1]
    local rewarldData = self._activity_type.activity_data[1]
    for i, v in pairs(rewarldData) do
        local curr_reward = zstring.split(v.achieve_reward, ",")
        if tonumber(data.prop_item) == tonumber(curr_reward[1])
            and tonumber(data.prop_type) == tonumber(curr_reward[2]) 
            and tonumber(data.item_value) == tonumber(curr_reward[3])
            then
            index = tonumber(v.achieve_index)
            break
        end
    end
    return index
end

function RedAlertTimeWindingUpPlan:updateDrawButton()
    local root = self.roots[1]
    local Button_winding_up_plan_begin = ccui.Helper:seekWidgetByName(root, "Button_winding_up_plan_begin")
    local Text_winding_up_plan_time_n = ccui.Helper:seekWidgetByName(root, "Text_winding_up_plan_time_n") -- 当前拥有次数
    local Text_winding_up_plan_all_time_n = ccui.Helper:seekWidgetByName(root, "Text_winding_up_plan_all_time_n") -- 总转盘次数
    local activity_data = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state = zstring.split(activity_data.activity_add_state,",")
    Text_winding_up_plan_all_time_n:setString(activity_add_state[5])
    local currNumber = math.min(math.floor(tonumber(activity_add_state[6]) / tonumber(activity_add_state[4])) , tonumber(activity_add_state[5])) 
    currNumber =  currNumber - tonumber(activity_add_state[7])
    Text_winding_up_plan_time_n:setString(currNumber)
    if currNumber > 0 then
        Button_winding_up_plan_begin:setTouchEnabled(true)
        Button_winding_up_plan_begin:setBright(true)
    else
        Button_winding_up_plan_begin:setTouchEnabled(false)
        Button_winding_up_plan_begin:setBright(false)
    end
end


function RedAlertTimeWindingUpPlan:updateDraw()
    self.roundImage:setVisible(false) 
    local root = self.roots[1]
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    --标题
    ccui.Helper:seekWidgetByName(root, "Text_winding_up_plan_name"):setString(self._activity_type.activity_title)
    --信息
    local Text_winding_up_plan_p_1 = ccui.Helper:seekWidgetByName(root, "Text_winding_up_plan_p_1")
    local Text_winding_up_plan_p_2 = ccui.Helper:seekWidgetByName(root, "Text_winding_up_plan_p_2")
    Text_winding_up_plan_p_1:setString(self._activity_type.activity_dec)
    Text_winding_up_plan_p_2:setVisible(false)
    -- 时间
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
    local startTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[1] / 1000))
    local endTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[3] / 1000) - 1)
    local isEnd = false
    if tonumber(activity_add_state[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        isEnd = false
    else
        isEnd = true
    end
    self.accept_the_prize = isEnd
    local time_str = ""
    if isEnd == true then
        self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        time_str = activity_str_tip[111]
    else
        self.m_times = ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        time_str = activity_str_tip[93]
    end

    -- 结束/关闭倒计时
    local Text_recharge_bonus_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_act_time_1")
    Text_recharge_bonus_act_time_1:removeAllChildren(true)
    Text_recharge_bonus_act_time_1:setString("")
    Text_recharge_bonus_act_time_1:setVisible(true)
    local font_size = Text_recharge_bonus_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_recharge_bonus_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_recharge_bonus_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_recharge_bonus_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_recharge_bonus_act_time_1:addChild(time_int)
    self:updateDrawButton()

    --奖励
    local rewarldData = self._activity_type.activity_data[1]
    self._image_list = {}
    for i=1 ,#rewarldData do
        local getRewardState = rewarldData[i].achieve_state
        local Panel_winding_up_plan_rew = ccui.Helper:seekWidgetByName(root, "Panel_winding_up_plan_rew_"..i)
        Panel_winding_up_plan_rew:removeAllChildren(true)
        local cell = state_machine.excute("red_alert_time_winding_up_plan_cell",0,{rewarldData[i]})
        Panel_winding_up_plan_rew:addChild(cell)
        table.insert(self._image_list,Panel_winding_up_plan_rew)
        if tonumber(rewarldData[i].achieve_state) >= 1 then
            Panel_winding_up_plan_rew:setColor(cc.c3b(79,85,85))
        end
    end   
end

--初始化
function RedAlertTimeWindingUpPlan:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.winding_up_plan)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_winding_up_plan_close"), nil, 
    {
        terminal_name = "red_alert_time_winding_up_plan_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_winding_up_plan_recharge"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --开始清盘
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_winding_up_plan_begin"), nil, 
    {
        terminal_name = "red_alert_time_winding_up_plan_start", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_winding_up_plan_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_winding_up_plan_rule_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
    local Panel_top_box = ccui.Helper:seekWidgetByName(root, "Panel_top_box")
    self.roundImage = cc.Sprite:create(config_res.images.ui.wonderful.winding_up_plan_reward_box_bg)
    self.roundImage:setAnchorPoint(cc.p(0,0))
    Panel_top_box:addChild(self.roundImage)
    self.roundImage:setVisible(false)

    self:updateDraw()
end

function RedAlertTimeWindingUpPlan:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_recharge_bonus_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_recharge_bonus_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self.accept_the_prize == true then
                state_machine.excute("red_alert_time_center_find",0,"red_alert_time_winding_up_plan_close")
            else
                state_machine.excute("red_alert_time_winding_up_plan_updata", 0, "")
            end
        end
    end
end

function RedAlertTimeWindingUpPlan:onEnterTransitionFinish()

end

function RedAlertTimeWindingUpPlan:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeWindingUpPlan:onExit()
    state_machine.remove("red_alert_time_winding_up_plan_show")
    state_machine.remove("red_alert_time_winding_up_plan_hide")
    state_machine.remove("red_alert_time_winding_up_plan_start")
    state_machine.remove("red_alert_time_winding_up_plan_updata")
    state_machine.remove("red_alert_time_winding_up_plan_rule_open")
end