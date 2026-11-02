--------------------------------------------------------------------------------------------------------------
--  说明：火线将领界面1
--------------------------------------------------------------------------------------------------------------
RedAlertTimeLeaderSeniorTransfer = class("RedAlertTimeLeaderSeniorTransferClass", Window)

--打开界面
local red_alert_time_leader_senior_transfer_open_terminal = {
	_name = "red_alert_time_leader_senior_transfer_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeLeaderSeniorTransferClass") == nil then
    		fwin:open(RedAlertTimeLeaderSeniorTransfer:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_leader_senior_transfer_close_terminal = {
	_name = "red_alert_time_leader_senior_transfer_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeLeaderSeniorTransferClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_leader_senior_transfer_open_terminal)
state_machine.add(red_alert_time_leader_senior_transfer_close_terminal)
state_machine.init()

function RedAlertTimeLeaderSeniorTransfer:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    -- 奖励绘制
    self.m_times = 0
    self.accept_the_prize = false
    self.isFree = false
    self._activity_type = nil
    self.tenNeedGod = 0
    self.oneNeedGod = 0
    self.tenNeedGodOld = 0
    self.discount = 0
    self.m_reset_times = 0
    self.text_reset_times = nil
    self.text_m_times = nil 
	app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorOnce")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorTen")
    local function init_red_alert_time_leader_senior_transfer_terminal()
        local red_alert_time_leader_senior_transfer_show_terminal = {
            _name = "red_alert_time_leader_senior_transfer_show",
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

        local red_alert_time_leader_senior_transfer_hide_terminal = {
            _name = "red_alert_time_leader_senior_transfer_hide",
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
        local red_alert_time_leader_senior_reward_show_terminal = {
            _name = "red_alert_time_leader_senior_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity_add_state_arry = zstring.split(instance._activity_type.activity_add_state,"|")
                local activity_add_state = zstring.split(activity_add_state_arry[1],",")
                local reworld = zstring.split(dms.string(dms["scene_reward"], tonumber(activity_add_state[13]), scene_reward.reward_items),"|")
                state_machine.excute("red_alert_time_box_preview_window_open",0,{reworld , activity_str_tip[113]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local red_alert_time_leader_senior_get_terminal = {
            _name = "red_alert_time_leader_senior_get",
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
                    state_machine.excute("red_alert_time_leader_senior_sure_hoose_recruit",0,{0})
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
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold,cost,curr_type}, m_type = 27}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local red_alert_time_leader_senior_sure_hoose_recruit_terminal = {
            _name = "red_alert_time_leader_senior_sure_hoose_recruit",
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
                        if choose_type == 1 then
                            if fwin:find("RedAlertTimeLeaderSeniorTenClass") ~= nil then
                                state_machine.excute("red_alert_time_leader_senior_ten_update_draw", 0, nil)
                            else
                                state_machine.excute("red_alert_time_leader_senior_ten_window_open", 0, {instance._activity_type.activity_type, instance.tenNeedGod, instance.tenNeedGodOld, instance.discount})
                            end
                        else
                            if fwin:find("RedAlertTimeLeaderSeniorOnceClass") ~= nil then
                                state_machine.excute("red_alert_time_leader_senior_once_update_draw", 0, nil)
                            else
                                state_machine.excute("red_alert_time_leader_senior_once_window_open", 0, {instance._activity_type.activity_type, instance.oneNeedGod, false})
                            end
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n"..choose_type
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_leader_senior_get_rule_terminal = {
            _name = "red_alert_time_leader_senior_get_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,99)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_leader_senior_updata_isFree_terminal = {
            _name = "red_alert_time_leader_senior_updata_isFree",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawIsFree()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_leader_senior_updata_isFree_terminal)
        state_machine.add(red_alert_time_leader_senior_transfer_show_terminal)
        state_machine.add(red_alert_time_leader_senior_transfer_hide_terminal)
        state_machine.add(red_alert_time_leader_senior_reward_show_terminal)
        state_machine.add(red_alert_time_leader_senior_get_terminal)
        state_machine.add(red_alert_time_leader_senior_sure_hoose_recruit_terminal)
        state_machine.add(red_alert_time_leader_senior_get_rule_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_leader_senior_transfer_terminal()
end
function RedAlertTimeLeaderSeniorTransfer:updateDrawIsFree()
    --是否免费
    local root = self.roots[1]
    local Text_leader_senior_reward_free = ccui.Helper:seekWidgetByName(root, "Text_leader_senior_reward_free")
    local Image_leader_senior_gold_0 = ccui.Helper:seekWidgetByName(root, "Image_leader_senior_gold_0")
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_arry[1],",")
    local Button_leader_senior_one_recruit = ccui.Helper:seekWidgetByName(root, "Button_leader_senior_one_recruit")
    local blueButtonTexture = config_res.images.ui.share.blue_button
    local yellowButtonTexture = config_res.images.ui.share.yellow_button
    local grayButtonTexture = config_res.images.ui.share.gray_button
    if tonumber(activity_add_state[5]) < tonumber(activity_add_state[6]) then
        self.isFree = true
        Text_leader_senior_reward_free:setString(red_alert_time_str[71])
        Image_leader_senior_gold_0:setVisible(false)
        Button_leader_senior_one_recruit:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
    else
        self.isFree = false
        Text_leader_senior_reward_free:setString(activity_add_state[8])
        Image_leader_senior_gold_0:setVisible(true)
        Button_leader_senior_one_recruit:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
    end
end

function RedAlertTimeLeaderSeniorTransfer:updateDraw()
    local root = self.roots[1]
	--信息
    local Text_leader_senior_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_leader_senior_infor_p_1")
	Text_leader_senior_infor_p_1:setString(self._activity_type.activity_dec)
	-- 时间
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_arry[1],",")
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
        time_str = activity_str_tip[92]
    else
        self.m_times = ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        time_str = activity_str_tip[93]
    end

    -- 结束和关闭倒计时
    local Text_leader_senior_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_leader_senior_act_time_1")
    Text_leader_senior_act_time_1:removeAllChildren(true)
    Text_leader_senior_act_time_1:setString("")
    Text_leader_senior_act_time_1:setVisible(true)
    local font_size = Text_leader_senior_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_leader_senior_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_leader_senior_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_leader_senior_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_leader_senior_act_time_1:addChild(time_int)
    self.text_m_times = Text_leader_senior_act_time_1
    --下次免费倒计时
    local Text_leader_senior_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_leader_senior_act_time_2")
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    Text_leader_senior_act_time_2:removeAllChildren(true)
    Text_leader_senior_act_time_2:setString("")
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_leader_senior_act_time_2:getContentSize().width - 80)
    reset_time_int:setPositionY(Text_leader_senior_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_leader_senior_act_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_leader_senior_act_time_2:getContentSize().width - 80)
    reset_time_info:setPositionY(Text_leader_senior_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_leader_senior_act_time_2:addChild(reset_time_info)
    self.text_reset_times = Text_leader_senior_act_time_2

	local reworld = zstring.split(dms.string(dms["scene_reward"], tonumber(activity_add_state[13]), scene_reward.reward_items),"|")
	for i=1, 6 do
		local Panel_leader_senior_icon = ccui.Helper:seekWidgetByName(root,"Panel_leader_senior_icon_"..i)
        local Text_leader_senior_attribute = ccui.Helper:seekWidgetByName(root,"Text_leader_senior_attribute_"..i)
		Panel_leader_senior_icon:removeAllChildren(true)
        Panel_leader_senior_icon:removeBackGroundImage()
		
		local datas = zstring.split(reworld[i], ",")
		local cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, tonumber(datas[1]), 3, 1,true})
		Panel_leader_senior_icon:addChild(cell)
        local ship_info = dms.string(dms["ship_mould"], tonumber(datas[1]), ship_mould.skill_describe)
        local Text_leader_senior_attribute = ccui.Helper:seekWidgetByName(root, "Text_leader_senior_attribute_"..i)
        Text_leader_senior_attribute:setString(ship_info)
	end

    -- 折扣
    local Text_leader_senior_discount_n = ccui.Helper:seekWidgetByName(root,"Text_leader_senior_discount_n")
    local curr = tonumber(activity_add_state[11])
    curr = math.round(curr)
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr = (10 - curr) * 10
    end
    local discounts = string.format(activity_str_tip[22],""..curr)
    Text_leader_senior_discount_n:setString(discounts)
    self.discount = tonumber(activity_add_state[11])
	-- 10次折后价
	local Text_leader_senior_gold_n = ccui.Helper:seekWidgetByName(root,"Text_leader_senior_gold_n")
	Text_leader_senior_gold_n:setString(activity_add_state[9])
    self.tenNeedGod = tonumber(activity_add_state[9])
    self.oneNeedGod = tonumber(activity_add_state[8])
    self.tenNeedGodOld = tonumber(activity_add_state[10])
	-- 10次现价
	local Text_leader_senior_ten_old_gold_n = ccui.Helper:seekWidgetByName(root,"Text_leader_senior_ten_old_gold_n")
	Text_leader_senior_ten_old_gold_n:setString(activity_add_state[10])

    local Button_leader_senior_one_recruit = ccui.Helper:seekWidgetByName(root, "Button_leader_senior_one_recruit")
    local Button_leader_senior_ten_recruit = ccui.Helper:seekWidgetByName(root, "Button_leader_senior_ten_recruit")
    if isEnd == true then
        Button_leader_senior_one_recruit:setBright(false)
        Button_leader_senior_one_recruit:setTouchEnabled(false)
        Button_leader_senior_ten_recruit:setBright(false)
        Button_leader_senior_ten_recruit:setTouchEnabled(false)
    else
        Button_leader_senior_one_recruit:setBright(true)
        Button_leader_senior_one_recruit:setTouchEnabled(true)
        Button_leader_senior_ten_recruit:setBright(true)
        Button_leader_senior_ten_recruit:setTouchEnabled(true)
    end
    self:updateDrawIsFree()
end

--初始化
function RedAlertTimeLeaderSeniorTransfer:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.leader_senior_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	
	--奖励预览
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_senior_look_reward"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_reward_show", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
	
	--单次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_senior_one_recruit"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 0,
    }, nil, 1)
	
	--10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_senior_ten_recruit"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 1,
    }, nil, 1)

    --规则查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_senior_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_get_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:updateDraw()

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_text)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_luck_draw)
end

function RedAlertTimeLeaderSeniorTransfer:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.text_m_times ~= nil and self.text_m_times:getChildByTag(100) ~= nil then
            self.text_m_times:getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self.accept_the_prize == true then
                state_machine.excute("red_alert_time_center_find",0,"red_alert_time_leader_senior_window_close")
            else
                self:updateDraw()
                state_machine.excute("red_alert_time_leader_senior_once_update_button",0,"")
                state_machine.excute("red_alert_time_leader_senior_ten_update_button",0,"")
                state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_leader_senior")
            end
        end
    end
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self.text_reset_times ~= nil and self.text_reset_times:getChildByTag(100) ~= nil then
            self.text_reset_times:getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:updateDraw()
        end
    end
end

function RedAlertTimeLeaderSeniorTransfer:onEnterTransitionFinish()

end

function RedAlertTimeLeaderSeniorTransfer:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeLeaderSeniorTransfer:onExit()
    state_machine.remove("red_alert_time_leader_senior_transfer_show")
    state_machine.remove("red_alert_time_leader_senior_transfer_hide")
    state_machine.remove("red_alert_time_leader_senior_reward_show")
    state_machine.remove("red_alert_time_leader_senior_get")
    state_machine.remove("red_alert_time_leader_senior_sure_hoose_recruit")
    state_machine.remove("red_alert_time_leader_senior_get_rule")
    state_machine.remove("red_alert_time_leader_senior_updata_isFree")
end