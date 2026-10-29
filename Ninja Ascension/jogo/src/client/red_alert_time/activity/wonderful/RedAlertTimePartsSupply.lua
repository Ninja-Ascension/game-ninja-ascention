-----------------------------
--配件补给
-----------------------------
RedAlertTimePartsSupply = class("RedAlertTimePartsSupplyClass", Window)

local red_alert_time_parts_supply_window_open_terminal = {
    _name = "red_alert_time_parts_supply_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimePartsSupplyClass") then
            local panel = RedAlertTimePartsSupply:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_parts_supply_window_open_terminal)
state_machine.init()

function RedAlertTimePartsSupply:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	
    --load lua file
    -- Initialize red_alert_time_parts_supply state machine.
    local function init_red_alert_time_parts_supply_terminal()
	
        --
        local red_alert_time_parts_supply_activity_codes_terminal = {
          _name = "red_alert_time_parts_supply_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				-- state_machine.excute("rank_window_open",0,{_datas = {list_type = 26}})
				state_machine.excute("short_cut_go_to_other_window",0,{26})
				state_machine.excute("wonderful_window_close",0,nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
        state_machine.add(red_alert_time_parts_supply_activity_codes_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_parts_supply state machine.
    init_red_alert_time_parts_supply_terminal()
end

function RedAlertTimePartsSupply:onUpdateDraw()
    local root = self.roots[1]
	
	--活动名称
	local Text_parts_supply_name = ccui.Helper:seekWidgetByName(root,"Text_parts_supply_name")
	Text_parts_supply_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
	--活动描述
	local Text_parts_supply_infor_p = ccui.Helper:seekWidgetByName(root,"Text_parts_supply_infor_p")
	Text_parts_supply_infor_p:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	
	--活动开启结束时间
	local Text_act_share_time_n = ccui.Helper:seekWidgetByName(root,"Text_parts_supply_time_n")
    Text_act_share_time_n:removeAllChildren(true)
    Text_act_share_time_n:setString("")
    local Text_parts_supply_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_parts_supply_act_time_1")
    Text_parts_supply_act_time_1:removeAllChildren(true)
    Text_parts_supply_act_time_1:setString("")
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
    -- local intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    -- if intervalTime > 1 then
    -- 	local _richText1 = ccui.RichText:create()
    -- 	_richText1:ignoreContentAdaptWithSize(false)
    -- 	local color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
    -- 	local re1 =ccui.RichElementText:create(1, color,255, startTime.."~"..endTime, config_res.font.font_name,18)
    -- 	_richText1:pushBackElement(re1)
    -- 	local color2 = cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3])
    	
    -- 	local re2 = nil
    -- 	re2 =ccui.RichElementText:create(1, color2,255, string.format(activity_str_tip[41],math.floor(intervalTime)), config_res.font.font_name,18)
    -- 	_richText1:pushBackElement(re2)
    -- 	_richText1:setAnchorPoint(0.5,0.5)
    -- 	_richText1:setContentSize(cc.size(Text_act_share_time_n:getContentSize().width,18))
    -- 	_richText1:setPositionX(Text_act_share_time_n:getPositionX()*2.5+10)
    -- 	_richText1:setPositionY(Text_act_share_time_n:getContentSize().height/2)
    -- 	Text_act_share_time_n:addChild(_richText1)
    -- else
    --     -- Text_act_share_time_n:setString(startTime.."~"..endTime)
    --     local _richText1 = ccui.RichText:create()
    --     _richText1:ignoreContentAdaptWithSize(false)
    --     local color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
    --     local re1 =ccui.RichElementText:create(1, color,255, startTime.."~"..endTime, config_res.font.font_name,18)
    --     _richText1:pushBackElement(re1)
    --     _richText1:setAnchorPoint(0.5,0.5)
    --     _richText1:setContentSize(cc.size(Text_act_share_time_n:getContentSize().width,18))
    --     _richText1:setPositionX(Text_act_share_time_n:getPositionX()*2.5+10)
    --     _richText1:setPositionY(Text_act_share_time_n:getContentSize().height/2)
    --     Text_act_share_time_n:addChild(_richText1)
    --     local time_int = cc.Label:createWithTTF("", config_res.font.font_name, 18 / CC_CONTENT_SCALE_FACTOR())
    --     time_int:setName("time_int")
    --     time_int:setAnchorPoint(cc.p(0, 0.5))
    --     time_int:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    --     time_int:setPositionX(Text_act_share_time_n:getContentSize().width/2+40)
    --     time_int:setPositionY(Text_act_share_time_n:getContentSize().height/2)
    --     time_int:setTag(100)
    --     Text_act_share_time_n:addChild(time_int)
    -- end
    local font_size = Text_parts_supply_act_time_1:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_parts_supply_act_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_parts_supply_act_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_parts_supply_act_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_parts_supply_act_time_1:addChild(time_int_1)
end

function RedAlertTimePartsSupply:onUpdate(dt)
	if self.m_times > 0 then
        self.m_times = self.m_times - dt
        -- if ccui.Helper:seekWidgetByName(self.roots[1],"Text_parts_supply_time_n"):getChildByTag(100) ~= nil then
        --     ccui.Helper:seekWidgetByName(self.roots[1],"Text_parts_supply_time_n"):getChildByTag(100):setString(string.format(activity_str_tip[62],getRedAlertTimeFormat(self.m_times)))
        -- end
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_parts_supply_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_parts_supply_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
end

function RedAlertTimePartsSupply:onEnterTransitionFinish()

end

function RedAlertTimePartsSupply:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_parts_supply)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gift_exchange"), nil, 
    {
        terminal_name = "red_alert_time_parts_supply_activity_codes", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	self:onUpdateDraw()
end

function RedAlertTimePartsSupply:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimePartsSupply:onExit()
    state_machine.remove("red_alert_time_parts_supply_activity_codes")
end
