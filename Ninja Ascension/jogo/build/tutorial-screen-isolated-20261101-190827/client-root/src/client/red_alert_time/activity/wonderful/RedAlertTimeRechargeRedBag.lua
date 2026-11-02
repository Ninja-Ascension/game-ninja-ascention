-----------------------------
--充值红包,充值福利,将领进阶
-----------------------------
RedAlertTimeRechargeRedBag = class("RedAlertTimeRechargeRedBagClass", Window)

local red_alert_time_recharge_red_bag_window_open_terminal = {
    _name = "red_alert_time_recharge_red_bag_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeRechargeRedBagClass") then
            local panel = RedAlertTimeRechargeRedBag:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_recharge_red_bag_window_open_terminal)
state_machine.init()

function RedAlertTimeRechargeRedBag:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
	self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self.originalButtonText = nil
    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil
    self.Text_promp_n_Poy = nil
    --load lua file
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
    -- Initialize red_alert_time_recharge_red_bag state machine.
    local function init_red_alert_time_recharge_red_bag_terminal()
	
        --
        local red_alert_time_recharge_red_bag_activity_update_terminal = {
          _name = "red_alert_time_recharge_red_bag_activity_update",
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
         local red_alert_time_recharge_red_bag_go_terminal = {
          _name = "red_alert_time_recharge_red_bag_go",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                if instance.activity_type == 45 
                    or instance.activity_type == 41 
                    or instance.activity_type == 80 
                    or instance.activity_type == 32 
                    or instance.activity_type == 12 
                    then
                    state_machine.excute("recharge_dialog_window_open",0,"recharge_dialog_window_open.") 
                else
                    state_machine.excute("short_cut_go_to_other_window",0,{12})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
        
        state_machine.add(red_alert_time_recharge_red_bag_go_terminal)
        state_machine.add(red_alert_time_recharge_red_bag_activity_update_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_recharge_red_bag state machine.
    init_red_alert_time_recharge_red_bag_terminal()
end

function RedAlertTimeRechargeRedBag:onUpdateDraw()
    local root = self.roots[1]
	local ListView_act_share = ccui.Helper:seekWidgetByName(root,"ListView_act_share")
    local Button_recharge = ccui.Helper:seekWidgetByName(root,"Button_recharge")
    local blueButtonTexture = config_res.images.ui.share.blue_button
    local yellowButtonTexture = config_res.images.ui.share.yellow_button
    local grayButtonTexture = config_res.images.ui.share.gray_button
    if self.activity_type == 90 then
        Button_recharge:setTitleText(activity_str_tip[108])
        Button_recharge:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
    else
        Button_recharge:setTitleText(self.originalButtonText)
        Button_recharge:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
    end
	ListView_act_share:removeAllItems()
	local index = 1
	for i=1, #_ED.activity_info[""..self.activity_type].activity_data[1] do
	-- for i,v in pairs(_ED.activity_info["44"].activity_data[2]) do
		local cell = state_machine.excute("red_alert_time_act_share_create_cell",0,{_ED.activity_info[""..self.activity_type].activity_data[1][i],index,self.activity_type,1})
        ListView_act_share:addChild(cell)
		index = index + 1 
	end
	self._list_view = ListView_act_share
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	--活动名称
	local Text_act_share_name = ccui.Helper:seekWidgetByName(root,"Text_act_share_name")
	Text_act_share_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
	--活动描述
	local Text_act_share_infor = ccui.Helper:seekWidgetByName(root,"Text_act_share_infor")
	Text_act_share_infor:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	--活动开启结束时间
	local Text_act_share_time_n = ccui.Helper:seekWidgetByName(root,"Text_act_share_time_n")
    local Text_act_share_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_1")
    local Text_act_share_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_2")
    Text_act_share_act_time_2:removeAllChildren(true)
    Text_act_share_act_time_2:setString("")
	local Text_promp_n = ccui.Helper:seekWidgetByName(root,"Text_promp_n")
	Text_act_share_time_n:setString(activity_str_tip[14])
    Text_act_share_act_time_1:setString(activity_str_tip[95]..activity_str_tip[14])
	Text_promp_n:removeAllChildren(true)
    Text_promp_n:setString("")
	if tonumber(self.activity_type) == 45 
        then
		local _richText2 = ccui.RichText:create()
		_richText2:ignoreContentAdaptWithSize(false)
		_richText2:setContentSize(cc.size(root:getContentSize().width,40))
		_richText2:setAnchorPoint(cc.p(0.5, 0.5))
		local numbers = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state,",")
        local dataset = string.format(activity_str_tip[9],""..numbers[2])
		local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		dataset, 
		cc.c3b(255, 255, 255),
		cc.c3b(255, 255, 255),
		0, 
		0, 
		config_res.font.font_name, 
		20,
		chat_rich_text_color)
		_richText2:formatTextExt()
		local rsize = _richText2:getContentSize()
		_richText2:setPositionX(Text_promp_n:getPositionX()*3/2)
		_richText2:setPositionY(-Text_promp_n:getContentSize().height/2)
		Text_promp_n:addChild(_richText2)
    elseif tonumber(self.activity_type) == 12 
        or tonumber(self.activity_type) == 80 
        then
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        _richText2:setContentSize(cc.size(root:getContentSize().width,40))
        _richText2:setAnchorPoint(cc.p(0.5, 0.5))
        local numbers = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state,",")
        local dataset = string.format(activity_str_tip[196],""..numbers[3])
        if tonumber(self.activity_type) == 80 then
            dataset = string.format(activity_str_tip[9],""..numbers[4])
        end
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        dataset, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)
        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        _richText2:setPositionX(Text_promp_n:getPositionX()*3/2)
        _richText2:setPositionY(-Text_promp_n:getContentSize().height/2)
        Text_promp_n:addChild(_richText2)
    elseif tonumber(self.activity_type) == 90 then
        Text_promp_n:setString(activity_str_tip[107])
        if self.Text_promp_n_Poy == nil then
           self.Text_promp_n_Poy = Text_promp_n:getPositionY() - Text_promp_n:getContentSize().height
        end
        Text_promp_n:setPositionY(self.Text_promp_n_Poy)
	end
    if tonumber(self.activity_type) == 41 
        or tonumber(self.activity_type) == 80 
        or tonumber(self.activity_type) == 32 
        or tonumber(self.activity_type) == 12 
        or tonumber(self.activity_type) == 90 
        then
        Text_act_share_time_n:removeAllChildren(true)
        Text_act_share_time_n:setString("")
        Text_act_share_act_time_1:removeAllChildren(true)
        Text_act_share_act_time_1:setString("")
        local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
        local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
        local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
        local intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

        local font_size = Text_act_share_act_time_1:getFontSize()
        local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_info_1:setName("time_info_1")
        time_info_1:setAnchorPoint(cc.p(0, 0.5))
        time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info_1:setPositionX(0)
        time_info_1:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
        time_info_1:setTag(200)
        Text_act_share_act_time_1:addChild(time_info_1)
        local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_int_1:setName("time_int_1")
        time_int_1:setAnchorPoint(cc.p(0, 0.5))
        time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int_1:setPositionX(time_info_1:getContentSize().width)
        time_int_1:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
        time_int_1:setTag(100)
        Text_act_share_act_time_1:addChild(time_int_1)

    end
    if tonumber(self.activity_type) == 90 
        or tonumber(self.activity_type) == 41 
        or tonumber(self.activity_type) == 12 
        then
    else
        local font_size = Text_act_share_act_time_2:getFontSize()
        local time_info_2 = cc.Label:createWithTTF(activity_str_tip[94], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_info_2:setName("time_info_2")
        time_info_2:setAnchorPoint(cc.p(1, 0.5))
        time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info_2:setPositionX(Text_act_share_act_time_2:getContentSize().width - 80)
        time_info_2:setPositionY(Text_act_share_act_time_2:getContentSize().height / 2)
        time_info_2:setTag(200)
        Text_act_share_act_time_2:addChild(time_info_2)
        local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_int_2:setName("time_int_2")
        time_int_2:setAnchorPoint(cc.p(0, 0.5))
        time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int_2:setPositionX(Text_act_share_act_time_2:getContentSize().width - 80)
        time_int_2:setPositionY(Text_act_share_act_time_2:getContentSize().height / 2)
        time_int_2:setTag(100)
        Text_act_share_act_time_2:addChild(time_int_2)
    end
end

function RedAlertTimeRechargeRedBag:onUpdate(dt)
    local server_time = getCurrentGTM8Time()
    local leave_time = 86400 - (server_time.hour * 3600 + server_time.min * 60 + server_time.sec)
    if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_2"):getChildByTag(100) ~= nil then
        ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(leave_time))
    end
    if leave_time <= 0 then
        self:onUpdateDraw()
    end
    if tonumber(self.activity_type) == 41 
        or tonumber(self.activity_type) == 80
        or tonumber(self.activity_type) == 32 
        or tonumber(self.activity_type) == 12 
        or tonumber(self.activity_type) == 90
        then
        if self.m_times > 0 then
            self.m_times = self.m_times - dt

            if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100) ~= nil then
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
            end
            if self.m_times <= 0 then
                self.m_times = 0
                state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
            end
        end
    end
	if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_act_share_arrow_down:setVisible(true)
        else
            self._Image_act_share_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_act_share_arrow_up:setVisible(true)
        else
            self._Image_act_share_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function RedAlertTimeRechargeRedBag:onEnterTransitionFinish()

end

function RedAlertTimeRechargeRedBag:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_share_tab_1)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

  	self._Image_act_share_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_down")
    self._Image_act_share_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_act_share_arrow_down:stopAllActions()
    self._Image_act_share_arrow_up:stopAllActions()
    playActions(self._Image_act_share_arrow_down)
    playActions(self._Image_act_share_arrow_up)
    self._Image_act_share_arrow_down:setVisible(false)
    self._Image_act_share_arrow_up:setVisible(false)
	
	--去充值和领奖
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge"), nil, 
    {
        terminal_name = "red_alert_time_recharge_red_bag_go", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    if self.originalButtonText == nil then
        self.originalButtonText = ccui.Helper:seekWidgetByName(root,"Button_recharge"):getTitleText()
    end
	
	self:onUpdateDraw()
end

function RedAlertTimeRechargeRedBag:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeRechargeRedBag:onExit()
    state_machine.remove("red_alert_time_recharge_red_bag_go")
    state_machine.remove("red_alert_time_recharge_red_bag_activity_update")
end
