-----------------------------
--兄弟同享的活动页
-----------------------------
RedAlertTimeBrothersActivty = class("RedAlertTimeBrothersActivtyClass", Window)

local red_alert_time_brothers_activty_window_open_terminal = {
    _name = "red_alert_time_brothers_activty_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = RedAlertTimeBrothersActivty:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_brothers_activty_window_open_terminal)
state_machine.init()

function RedAlertTimeBrothersActivty:ctor()
    self.super:ctor()
    self.roots = {}
    
    self.activityInfo = nil
    self.m_times = 0
    app.load("client.red_alert_time.props.PropsInforPrompt")

    local function init_red_alert_time_brothers_activty_terminal()
		--显示界面
		local red_alert_time_brothers_activty_show_terminal = {
            _name = "red_alert_time_brothers_activty_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- local prop_id = params._datas.mould_info[1]
                -- state_machine.excute("props_infor_prompt_window_open", 0, {prop_id})
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local red_alert_time_brothers_activty_hide_terminal = {
            _name = "red_alert_time_brothers_activty_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 规则
		local red_alert_time_brothers_activty_rule_terminal = {
            _name = "red_alert_time_brothers_activty_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance.activityInfo[1].activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_brothers_activty_shop_terminal = {
            _name = "red_alert_time_brothers_activty_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local prop_id = params._datas.mould_info[1]
                state_machine.excute("props_infor_prompt_window_open", 0, {prop_id})
                -- instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(red_alert_time_brothers_activty_show_terminal)	
		state_machine.add(red_alert_time_brothers_activty_hide_terminal)
        state_machine.add(red_alert_time_brothers_activty_rule_terminal)
		state_machine.add(red_alert_time_brothers_activty_shop_terminal)
        state_machine.init()
    end
    init_red_alert_time_brothers_activty_terminal()
end

function RedAlertTimeBrothersActivty:onHide()
    self:setVisible(false)
end

function RedAlertTimeBrothersActivty:onShow()
    self:setVisible(true)
end

function RedAlertTimeBrothersActivty:onUpdateDraw()
    local root = self.roots[1]
    local Text_brothers_share_infor_p = ccui.Helper:seekWidgetByName(root,"Text_brothers_share_infor_p")
	Text_brothers_share_infor_p:setString(self.activityInfo[1].activity_dec)
	
	--时间
	local Text_brothers_share_time = ccui.Helper:seekWidgetByName(root,"Text_brothers_share_time")
	local timesData = zstring.split(self.activityInfo[1].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000)

    local Text_brothers_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_brothers_act_time_1")
    Text_brothers_act_time_1:setString("")
    Text_brothers_act_time_1:removeAllChildren(true)
    local Text_brothers_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_brothers_act_time_2")
    Text_brothers_act_time_2:setString("")
    Text_brothers_act_time_2:removeAllChildren(true)
    local font_size = Text_brothers_act_time_1:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_brothers_act_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_brothers_act_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_brothers_act_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_brothers_act_time_1:addChild(time_int_1)

    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    -- self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

	for i=1,#self.activityInfo[1].activity_data[1] do
		local Text_brothers_box_name = ccui.Helper:seekWidgetByName(root,string.format("Text_brothers_box_name_%s",i))
        local mould_info = zstring.split(self.activityInfo[1].activity_data[1][i].achieve_reward,",")
        local quality = dms.int(dms["prop_mould"], mould_info[1], prop_mould.prop_quality)+1
        Text_brothers_box_name:setColor(cc.c3b(color_Type[quality][1], color_Type[quality][2], color_Type[quality][3]))
		Text_brothers_box_name:setString(dms.string(dms["prop_mould"], mould_info[1], prop_mould.prop_name))
		
		local Text_brothers_box_price = ccui.Helper:seekWidgetByName(root,string.format("Text_brothers_box_price_%s",i))
        local Text_brothers_box_price_1 = ccui.Helper:seekWidgetByName(root,string.format("Text_brothers_box_price_%s1",i))
        local fontSize = Text_brothers_box_price:getFontSize()
		local _richText = ccui.RichText:create()
		_richText:ignoreContentAdaptWithSize(false)
		local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
		local datas = zstring.split(activity_str_tip[26], ",")
		local re1 =ccui.RichElementText:create(1, color,255, datas[1], config_res.font.font_name,fontSize)
		_richText:pushBackElement(re1)
		local color2 = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
		local counts = zstring.split(self.activityInfo[1].activity_data[1][i].achieve_complete_count, "/")
		local re2 = ccui.RichElementText:create(1, color2,255, tonumber(counts[2]), config_res.font.font_name,fontSize)
        local re3 =ccui.RichElementText:create(1, color,255, datas[2], config_res.font.font_name,fontSize)

        if Text_brothers_box_price_1 ~= nil then
            local _richText1 = ccui.RichText:create()
            _richText1:ignoreContentAdaptWithSize(false)
            _richText1:pushBackElement(re2)
            _richText1:pushBackElement(re3)
            _richText1:setAnchorPoint(0.5,0.5)
            _richText1:setContentSize(cc.size(Text_brothers_box_price:getContentSize().width,fontSize))
            _richText1:setPositionX(Text_brothers_box_price:getContentSize().width/2)
            _richText1:setPositionY(Text_brothers_box_price:getContentSize().height/2)
            Text_brothers_box_price_1:addChild(_richText1)
        else
            _richText:pushBackElement(re2)
            _richText:pushBackElement(re3)
        end

		_richText:setAnchorPoint(0.5,0.5)
		_richText:setContentSize(cc.size(Text_brothers_box_price:getContentSize().width,fontSize))
		_richText:setPositionX(Text_brothers_box_price:getContentSize().width/2)
		_richText:setPositionY(Text_brothers_box_price:getContentSize().height/2)
		Text_brothers_box_price:addChild(_richText)	
	end
end

function RedAlertTimeBrothersActivty:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_brothers_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_brothers_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_brothers_share_window_close")
        end
    end
end

function RedAlertTimeBrothersActivty:onEnterTransitionFinish()

end

function RedAlertTimeBrothersActivty:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.brothers_share_tab_1)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    
	--活动
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_brothers_share_charge"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
		_page = 1,
    }, nil, 1)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_brothers_share_rule"), nil, 
    {
        terminal_name = "red_alert_time_brothers_activty_rule", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    for i=1,6 do
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_icon_"..i), nil, 
	    {
	        terminal_name = "red_alert_time_brothers_activty_shop", 
	        terminal_state = 0,
	        touch_black = true,
            _index = 7 - i,
            mould_info = zstring.split(self.activityInfo[1].activity_data[1][i].achieve_reward,","),
	    }, nil, 1)
    end
	
    
	self:onUpdateDraw()
end

function RedAlertTimeBrothersActivty:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self.activityInfo = params[2]    
	self:onInit()
    return self
end

function RedAlertTimeBrothersActivty:onExit()
    state_machine.remove("red_alert_time_brothers_activty_show")
    state_machine.remove("red_alert_time_brothers_activty_hide")
    state_machine.remove("red_alert_time_brothers_activty_rule")
    state_machine.remove("red_alert_time_brothers_activty_shop")
end
