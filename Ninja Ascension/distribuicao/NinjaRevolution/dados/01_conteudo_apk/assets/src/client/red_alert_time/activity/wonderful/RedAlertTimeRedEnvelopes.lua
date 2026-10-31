-----------------------------
--红包大派送
-----------------------------
RedAlertTimeRedEnvelopes = class("RedAlertTimeRedEnvelopesClass", Window)

local red_alert_time_red_rnvelopes_window_open_terminal = {
    _name = "red_alert_time_red_rnvelopes_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeRedEnvelopesClass") then
            local panel = RedAlertTimeRedEnvelopes:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_red_rnvelopes_window_open_terminal)
state_machine.init()

function RedAlertTimeRedEnvelopes:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
    --load lua file
    -- Initialize red_alert_time_red_rnvelopes state machine.
    local function init_red_alert_time_red_rnvelopes_terminal()
	
        --
        local red_alert_time_red_rnvelopes_activity_codes_terminal = {
          _name = "red_alert_time_red_rnvelopes_activity_codes",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				local acitvity = _ED.activity_info[""..instance.activity_type]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							instance:onUpdateDraw()
							checkRewardObtainDraw()
							TipDlg.drawTextDailog(activity_str_tip[61])
						end
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..instance.activity_type.."\r\n".."0".."\r\n"..tonumber(_ED.activity_info[""..instance.activity_type].activity_data[1][1].achieve_index)-1
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         local red_alert_time_red_rnvelopes_activity_tips_terminal = {
          _name = "red_alert_time_red_rnvelopes_activity_tips",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
          		local datas = {}
          		datas[1] = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_red_envelopes_buy_gold_n"):getString()
          		datas[2] = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_red_envelopes_vouchers_minus_n"):getString()
				state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = datas, m_type = 17}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         local red_alert_time_red_rnvelopes_rule_infor_terminal = {
          _name = "red_alert_time_red_rnvelopes_rule_infor",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				state_machine.excute("red_alert_time_rule_infor_window_open",0,instance.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         local red_alert_time_red_rnvelopes_update_window_terminal = {
          _name = "red_alert_time_red_rnvelopes_update_window",
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
		
        state_machine.add(red_alert_time_red_rnvelopes_activity_codes_terminal)
        state_machine.add(red_alert_time_red_rnvelopes_activity_tips_terminal)
        state_machine.add(red_alert_time_red_rnvelopes_rule_infor_terminal)
        state_machine.add(red_alert_time_red_rnvelopes_update_window_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_red_rnvelopes state machine.
    init_red_alert_time_red_rnvelopes_terminal()
end

function RedAlertTimeRedEnvelopes:onUpdateDraw()
    local root = self.roots[1]
	--活动名称
	local Text_red_envelopes_name = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_name")
	Text_red_envelopes_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
	--活动描述
	local Text_red_envelopes_p_2 = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_p_2")
	Text_red_envelopes_p_2:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	
	--活动开启结束时间
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
	local intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
	self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    -- 结束和关闭倒计时
    local Text_red_envelopes_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_act_time_1")
    Text_red_envelopes_act_time_1:removeAllChildren(true)
    Text_red_envelopes_act_time_1:setString("")
    local font_size = Text_red_envelopes_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_red_envelopes_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_red_envelopes_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_red_envelopes_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_red_envelopes_act_time_1:addChild(time_int)
	
	--宝箱图
	local Panel_red_envelopes_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_red_envelopes_icon_1")
	Panel_red_envelopes_icon_1:removeAllChildren(true)
	local datas = zstring.split("551,6,1", ",")
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
	local cell = nil
	if prop_type == 7 then
		local equip_datas = {}
		equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
		equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
		cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), 0})
	else
		cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), 0,nil,tonumber(datas[1])})
	end
	ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
	ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
	ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_quality_icon"):removeAllChildren(true)
	Panel_red_envelopes_icon_1:addChild(cell)
	-- 551,6,1
	local reward = zstring.split(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_reward, "|")
	for i=1, 4 do
		local Panel_red_envelopes_icon = ccui.Helper:seekWidgetByName(root, string.format("Panel_red_envelopes_icon_%s", i+1))
		Panel_red_envelopes_icon:removeAllChildren(true)
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
		Panel_red_envelopes_icon:addChild(cell)
	end
	--拥有金币
	local Text_red_envelopes_gold_n = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_gold_n")
	Text_red_envelopes_gold_n:setString(_ED.user_info.user_gold)
	--拥有的代金卷
	local Text_red_envelopes_vouchers_n = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_vouchers_n")
	Text_red_envelopes_vouchers_n:setString(timesData[3])
	--原价
	local Text_red_envelopes_old_price_n = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_old_price_n")
	Text_red_envelopes_old_price_n:setString(timesData[4])
	
	--可抵扣的数量
	local minus = 0
	local Text_red_envelopes_vouchers_minus_p = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_vouchers_minus_p")
	--local str = string.gsub(activity_str_tip[54],"!x@",tonumber(timesData[5])*100)
	local str = string.format(activity_str_tip[54],tonumber(timesData[5])*100)
	Text_red_envelopes_vouchers_minus_p:setString(str)
	if tonumber(timesData[3]) > tonumber(timesData[4])*tonumber(timesData[5]) then
		minus = tonumber(timesData[4])*tonumber(timesData[5])
	else
		minus = tonumber(timesData[3])
	end	
	--代金卷的数量
	local Text_red_envelopes_vouchers_minus_n = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_vouchers_minus_n")
	Text_red_envelopes_vouchers_minus_n:setString(minus)
	
	--消耗的数量
	local Text_red_envelopes_buy_gold_n = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_buy_gold_n")
	Text_red_envelopes_buy_gold_n:setString(tonumber(timesData[4]) - minus)
end

function RedAlertTimeRedEnvelopes:onUpdate(dt)
	if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_red_envelopes_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_red_envelopes_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
end

function RedAlertTimeRedEnvelopes:onEnterTransitionFinish()

end

function RedAlertTimeRedEnvelopes:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_red_envelopes)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--购买
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_red_envelopes_buy"), nil, 
    {
        terminal_name = "red_alert_time_red_rnvelopes_activity_tips", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cell = self,
    }, nil, 1)

    -- 规则
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_red_envelopes_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_red_rnvelopes_rule_infor", 
        terminal_state = 0, 
        touch_black = true,
		cell = self,
    }, nil, 1)
	self:onUpdateDraw()
end

function RedAlertTimeRedEnvelopes:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeRedEnvelopes:onExit()
    state_machine.remove("red_alert_time_red_rnvelopes_activity_codes")
    state_machine.remove("red_alert_time_red_rnvelopes_rule_infor")
end
