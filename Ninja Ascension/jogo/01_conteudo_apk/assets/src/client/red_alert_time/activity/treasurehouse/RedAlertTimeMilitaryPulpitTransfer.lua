--------------------------------------------------------------------------------------------------------------
--  说明：军事讲坛界面1
--------------------------------------------------------------------------------------------------------------
RedAlertTimeMilitaryPulpitTransfer = class("RedAlertTimeMilitaryPulpitTransferClass", Window)

--打开界面
local red_alert_time_military_pulpit_transfer_open_terminal = {
	_name = "red_alert_time_military_pulpit_transfer_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeMilitaryPulpitTransferClass") == nil then
    		fwin:open(RedAlertTimeMilitaryPulpitTransfer:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_military_pulpit_transfer_close_terminal = {
	_name = "red_alert_time_military_pulpit_transfer_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeMilitaryPulpitTransferClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_military_pulpit_transfer_open_terminal)
state_machine.add(red_alert_time_military_pulpit_transfer_close_terminal)
state_machine.init()

function RedAlertTimeMilitaryPulpitTransfer:ctor()
	self.super:ctor()
	self.roots = {}
    self._once_gold = 0
	self._ten_gold = 0
    self._m_type = 0
    self.have_free_times = false
    self.m_times = 0
    self.accept_the_prize = false
    self.page = 1
    self.time_text = nil
	
    local function init_red_alert_time_military_pulpit_transfer_terminal()
        local red_alert_time_military_pulpit_transfer_show_terminal = {
            _name = "red_alert_time_military_pulpit_transfer_show",
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

        local red_alert_time_military_pulpit_transfer_hide_terminal = {
            _name = "red_alert_time_military_pulpit_transfer_hide",
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

        -- 学习
        local red_alert_time_military_pulpit_transfer_explore_terminal = {
            _name = "red_alert_time_military_pulpit_transfer_explore",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local m_type = params._datas._type
                local activity_add_state = zstring.split(instance._activity_type.activity_add_state,",")
                if tonumber(activity_add_state[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
                else
                    TipDlg.drawTextDailog(activity_str_tip[88])
                    return
                end
                if tonumber(m_type) > 0 and instance.have_free_times == true then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    return
                end
                instance._m_type = m_type
                local shop_of_gold = 0
                local count = 0
                if m_type == 0 then
                    shop_of_gold = self._once_gold
                    count = 1
                    if instance.have_free_times == true then
                        instance:costTransferExplore(0)
                        return
                    end
                else
                    if instance.have_free_times == true then
                        TipDlg.drawTextDailog(activity_str_tip[77])
                        return
                    end
                    shop_of_gold = self._ten_gold
                    count = 10
                end
                --state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {shop_of_gold,count}, m_type = 29}})
                local tip = ConfirmTip:new()
                tip:init(instance, instance.costTransferExplore, string.format(activity_str_tip[131], shop_of_gold,count))
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 子界面切换
        local red_alert_time_military_pulpit_transfer_change_page_terminal = {
            _name = "red_alert_time_military_pulpit_transfer_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params._datas._type
                instance.page = page
                instance:changePage( )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local red_alert_time_military_pulpit_transfer_updata_terminal = {
            _name = "red_alert_time_military_pulpit_transfer_updata",
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
        local red_alert_time_military_pulpit_transfer_rank_updata_terminal = {
            _name = "red_alert_time_military_pulpit_transfer_rank_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:rankInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_military_pulpit_transfer_rank_updata_terminal)
        state_machine.add(red_alert_time_military_pulpit_transfer_updata_terminal)
        state_machine.add(red_alert_time_military_pulpit_transfer_change_page_terminal)
        state_machine.add(red_alert_time_military_pulpit_transfer_show_terminal)
        state_machine.add(red_alert_time_military_pulpit_transfer_hide_terminal)
        state_machine.add(red_alert_time_military_pulpit_transfer_explore_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_military_pulpit_transfer_terminal()
end

function RedAlertTimeMilitaryPulpitTransfer:costTransferExplore(sure_number)
    local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
    local have_free = self.have_free_times
    local page = self.page - 1
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.unlock("red_alert_time_military_pulpit_transfer_explore") 
            if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                response.node:drawUpdateButton()
                if self._m_type == 0 then
                    state_machine.excute("red_alert_time_secret_get_window_open", 0, {self._once_gold,acitvity.activity_id,self._activity_type.activity_type,page})
                else
                    state_machine.excute("red_alert_time_secret_get_ten_window_open", 0, {self._ten_gold,acitvity.activity_id,self._activity_type.activity_type,page})
                end
            end
            if have_free == true then
                state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_military_pulpit_free")
            end
        else
            state_machine.unlock("red_alert_time_military_pulpit_transfer_explore") 
        end
    end
    if sure_number == 0 then  
        _ED.show_reward_list_group_ex = {}
        state_machine.lock("red_alert_time_military_pulpit_transfer_explore")  
        protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n"..self._m_type.."\r\n"..page
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
    end
end

function RedAlertTimeMilitaryPulpitTransfer:drawUpdateButton()
	local root = self.roots[1]
	local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state_arry = zstring.split(acitvity.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_arry[self.page + 1],",")
    -- 折扣
    local Text_military_pulpit_discount_n = ccui.Helper:seekWidgetByName(root,"Text_military_pulpit_discount_n")
    local curr = tonumber(activity_add_state[7])
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr = (10 - curr) * 10
    end
    local discounts = string.format(activity_str_tip[22],""..curr)
    Text_military_pulpit_discount_n:setString(discounts)
    -- 10次折后价
    local Text_military_pulpit_gold_ten_n = ccui.Helper:seekWidgetByName(root,"Text_military_pulpit_gold_ten_n")
    self._ten_gold = tonumber(activity_add_state[5])
    Text_military_pulpit_gold_ten_n:setString(self._ten_gold)
    -- 10次现价
    local Text_military_pulpit_old_gold = ccui.Helper:seekWidgetByName(root,"Text_military_pulpit_old_gold")
    Text_military_pulpit_old_gold:setString(tonumber(activity_add_state[6]))
    -- 单次价格
    local Text_military_pulpit_gold_one_n = ccui.Helper:seekWidgetByName(root,"Text_military_pulpit_gold_one_n")
    self._once_gold = tonumber(activity_add_state[4])
    Text_military_pulpit_gold_one_n:setString(self._once_gold)

    --是否免费
    local Button_military_pulpit_study_one = ccui.Helper:seekWidgetByName(root,"Button_military_pulpit_study_one")
    local blueButtonTexture = config_res.images.ui.share.blue_button
    local yellowButtonTexture = config_res.images.ui.share.yellow_button
    local grayButtonTexture = config_res.images.ui.share.gray_button
	if tonumber(activity_add_state[1]) >=tonumber(activity_add_state[2]) or self.accept_the_prize == true then
		ccui.Helper:seekWidgetByName(root,"Image_military_pulpit_gold"):setVisible(true)
        Button_military_pulpit_study_one:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
        Button_military_pulpit_study_one:setTitleText(activity_str_tip[152])
        self.have_free_times = false
	else
		ccui.Helper:seekWidgetByName(root,"Image_military_pulpit_gold"):setVisible(false)
        Text_military_pulpit_gold_one_n:setString("")
        Button_military_pulpit_study_one:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
        Button_military_pulpit_study_one:setTitleText(activity_str_tip[132])
        self.have_free_times = true
	end
    --按钮状态
    local Button_military_pulpit_primary = ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_primary")
    local Button_military_pulpit_intermediate = ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_intermediate")
    local Button_military_pulpit_senior = ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_senior")
    Button_military_pulpit_primary:setHighlighted(false)
    Button_military_pulpit_intermediate:setHighlighted(false)
    Button_military_pulpit_senior:setHighlighted(false)
    if self.page == 1 then
        Button_military_pulpit_primary:setHighlighted(true)
    elseif self.page == 2 then
        Button_military_pulpit_intermediate:setHighlighted(true)
    else
        Button_military_pulpit_senior:setHighlighted(true)
    end
end
function RedAlertTimeMilitaryPulpitTransfer:changePage( )
    local root = self.roots[1]
    local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state_arry = zstring.split(acitvity.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_arry[self.page + 1],",")
    --子页面说明
    local Text_military_pulpit_p_1 = ccui.Helper:seekWidgetByName(root, "Text_military_pulpit_p_1")
    local Text_military_pulpit_p_2 = ccui.Helper:seekWidgetByName(root, "Text_military_pulpit_p_2")
    Text_military_pulpit_p_1:setString(string.format(activity_str_tip[122], activity_str_tip[122 + self.page] ,activity_str_tip[125 + self.page]))
    Text_military_pulpit_p_2:setString(string.format(activity_str_tip[129], tonumber(activity_add_state[3])))

    local ScrollView_military_pulpit_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_military_pulpit_icon")
    ScrollView_military_pulpit_icon:removeAllChildren(true)
    local contentSize = ScrollView_military_pulpit_icon:getContentSize()
    local rewardData = zstring.split(dms.string(dms["scene_reward"], tonumber(activity_add_state[8]), scene_reward.reward_items),"|")
    local rewardGroup = {}
    local cell_height = 0
    local cell_width = 0
    local tocalHeight = 0
    for i,v in pairs(rewardData) do
        local temp_tab = zstring.split(v, ",")
        local reward_data = {
            item_value = temp_tab[3],
            prop_type = temp_tab[2],
            prop_item = temp_tab[1],
        }
        local cell = nil
        if tonumber(reward_data.prop_type) == 6 then    
            cell = state_machine.excute("props_icon_create_cell",0,{6,1,reward_data.prop_item,1,reward_data.item_value})
        elseif tonumber(reward_data.prop_type) == 13 then    
            cell = state_machine.excute("props_icon_create_cell",0,{2,9,reward_data.prop_item,3,reward_data.item_value,true})
        elseif tonumber(reward_data.prop_item) <= 0 then    
            local prop_item = resource_prop_id[tonumber(reward_data.prop_type)]
            cell = state_machine.excute("props_icon_create_cell",0,{6,1,prop_item,1,reward_data.item_value})
        end
        if cell_height == 0 then 
            cell_height = cell:getContentSize().height + 35
        end
        if cell_width == 0 then 
            cell_width = cell:getContentSize().width
        end
        table.insert(rewardGroup, cell)
        ScrollView_military_pulpit_icon:addChild(cell)
    end
    tocalHeight = cell_height * (math.ceil( #rewardData / 5 ))
    tocalHeight = math.max(tocalHeight , contentSize.height)
    ScrollView_military_pulpit_icon:setInnerContainerSize(cc.size(contentSize.width, tocalHeight))
    for i, v in pairs(rewardGroup) do
        local wight_n = (i - 1) % 5
        local height_n = math.floor((i - 1) / 5) + 1
        local interval = (contentSize.width - 20 - 5 * cell_width) / 4
        v:setPosition(cc.p(wight_n * ( interval + cell_width ) + 10 , tocalHeight - cell_height * height_n + 35))
    end
    self:drawUpdateButton()
end

function RedAlertTimeMilitaryPulpitTransfer:rankInfo()
    local root = self.roots[1]
    local Text_military_pulpit_rank_n = ccui.Helper:seekWidgetByName(root,"Text_military_pulpit_rank_n")
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"|")
    local currGrage = zstring.split(activity_add_state_arry[5],",")
    local str2 = string.format(activity_str_tip[121], tonumber(currGrage[2]))
    local str1 = activity_str_tip[19]..str2
    Text_military_pulpit_rank_n:setString(str1)
    if _ED.military_pulpit_points_ranking ~= nil then
        for i,v in pairs(_ED.military_pulpit_points_ranking) do
            if v.name == _ED.user_info.user_name then
                str1 = v.rank
                Text_military_pulpit_rank_n:setString(str1)
            end
        end
    end
end

function RedAlertTimeMilitaryPulpitTransfer:updateDraw()
    local root = self.roots[1]
	--信息
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local Text_military_pulpit_infor_p = ccui.Helper:seekWidgetByName(root, "Text_military_pulpit_infor_p")
	Text_military_pulpit_infor_p:setString(self._activity_type.activity_dec)
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
    local Text_military_pulpit_time_1 = ccui.Helper:seekWidgetByName(root,"Text_military_pulpit_time_1")
    Text_military_pulpit_time_1:removeAllChildren(true)
    Text_military_pulpit_time_1:setString("")
    local font_size = Text_military_pulpit_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_military_pulpit_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_military_pulpit_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_military_pulpit_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_military_pulpit_time_1:addChild(time_int)
    self.time_text = Text_military_pulpit_time_1

    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    local Text_military_pulpit_time_2 = ccui.Helper:seekWidgetByName(root,"Text_military_pulpit_time_2")
    Text_military_pulpit_time_2:removeAllChildren(true)
    Text_military_pulpit_time_2:setString("")
    local reset_time_int = cc.Label:createWithTTF(getRedAlertTimeActivityFormat(self.m_reset_times), config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_military_pulpit_time_2:getContentSize().width/2)
    reset_time_int:setPositionY(Text_military_pulpit_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_military_pulpit_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_military_pulpit_time_2:getContentSize().width/2)
    reset_time_info:setPositionY(Text_military_pulpit_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_military_pulpit_time_2:addChild(reset_time_info)
    self.reset_time_text = Text_military_pulpit_time_2

    if self.accept_the_prize == true or self.m_times < 24 * 3600 then
        Text_military_pulpit_time_2:setVisible(false)
    else
        Text_military_pulpit_time_2:setVisible(true)
    end

    --学分
    local Text_military_pulpit_credit_n = ccui.Helper:seekWidgetByName(root,"Text_military_pulpit_credit_n") 
    local currGrage = zstring.split(activity_add_state_arry[5],",")
    Text_military_pulpit_credit_n:setString(currGrage[1])

    self:changePage(self.page)

    local Button_military_pulpit_study_one = ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_study_one")
    local Button_military_pulpit_study_ten = ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_study_ten")
    if isEnd == true then
        Button_military_pulpit_study_one:setBright(false)
        Button_military_pulpit_study_one:setTouchEnabled(false)
        Button_military_pulpit_study_ten:setBright(false)
        Button_military_pulpit_study_ten:setTouchEnabled(false)
    else
        Button_military_pulpit_study_one:setBright(true)
        Button_military_pulpit_study_one:setTouchEnabled(true)
        Button_military_pulpit_study_ten:setBright(true)
        Button_military_pulpit_study_ten:setTouchEnabled(true)
    end
end

--初始化
function RedAlertTimeMilitaryPulpitTransfer:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.military_pulpit_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	
	--子界面切换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_primary"), nil, 
    {
        terminal_name = "red_alert_time_military_pulpit_transfer_change_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_treasurehouse_military_pulpit_free",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_primary"),
    _invoke = nil,
    _index = 1,
    _interval = 0.3,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_intermediate"), nil, 
    {
        terminal_name = "red_alert_time_military_pulpit_transfer_change_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_treasurehouse_military_pulpit_free",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_intermediate"),
    _invoke = nil,
    _index = 2,
    _interval = 0.3,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_senior"), nil, 
    {
        terminal_name = "red_alert_time_military_pulpit_transfer_change_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_treasurehouse_military_pulpit_free",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_senior"),
    _invoke = nil,
    _index = 3,
    _interval = 0.3,})
	
	--单次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_study_one"), nil, 
    {
        terminal_name = "red_alert_time_military_pulpit_transfer_explore", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 0,
    }, nil, 1)
	
	--10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_pulpit_study_ten"), nil, 
    {
        terminal_name = "red_alert_time_military_pulpit_transfer_explore", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 1,
    }, nil, 1)

    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                response.node:rankInfo()
            end
        end
    end
    local rank = 0
    for k,v in pairs(self._activity_type.activity_data[1]) do
        if tonumber(v.achieve_state) == 0 then
            rank = k
            break
        end
    end
    protocol_command.draw_activity_reward.param_list = self._activity_type.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n"..(rank - 1).."\r\n".."2".."\r\n".."0"
    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil) 

    self:updateDraw()
end

function RedAlertTimeMilitaryPulpitTransfer:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self.reset_time_text ~= nil and self.reset_time_text:getChildByTag(100) ~= nil then
            self.reset_time_text:getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:updateDraw()
            state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_military_pulpit_free")
            state_machine.excute("red_alert_time_secret_get_updata_button_type", 0, 1)
            state_machine.excute("red_alert_time_secret_get_ten_updata_button_type", 0, 1) -- 免费次数刷新
        end
    end

    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.time_text ~= nil and self.time_text:getChildByTag(100) ~= nil then
            self.time_text:getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self.accept_the_prize == true then
                --state_machine.excute("red_alert_time_center_find",0,"red_alert_time_military_pulpit_transfer_close")
            else
                self:updateDraw()
                state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_military_pulpit_rank")
                state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_military_pulpit_free")
                state_machine.excute("red_alert_time_secret_get_updata_button_type", 0, 2)
                state_machine.excute("red_alert_time_secret_get_ten_updata_button_type", 0, 2) -- 活动结束刷新
            end
        end
    end
end

function RedAlertTimeMilitaryPulpitTransfer:onEnterTransitionFinish()

end

function RedAlertTimeMilitaryPulpitTransfer:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeMilitaryPulpitTransfer:onExit()
    state_machine.remove("red_alert_time_military_pulpit_transfer_show")
    state_machine.remove("red_alert_time_military_pulpit_transfer_hide")
    state_machine.remove("red_alert_time_military_pulpit_transfer_explore")
    state_machine.remove("red_alert_time_military_pulpit_transfer_change_page")
    state_machine.remove("red_alert_time_military_pulpit_transfer_updata")
    state_machine.remove("red_alert_time_military_pulpit_transfer_rank_updata")
end