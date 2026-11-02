-----------------------------
--科技飙升
-----------------------------
RedAlertTimeActivityActUpScientific = class("RedAlertTimeActivityActUpScientificClass", Window)

local red_alert_time_act_up_scientific_window_open_terminal = {
    _name = "red_alert_time_act_up_scientific_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeActivityActUpScientificClass") then
            local panel = RedAlertTimeActivityActUpScientific:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_act_up_scientific_window_open_terminal)
state_machine.init()

function RedAlertTimeActivityActUpScientific:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
    self.m_times = 0

    local function init_red_alert_time_act_up_scientific_terminal()
	
        --升级科技
        local red_alert_time_goto_up_scientific_terminal = {
            _name = "red_alert_time_goto_up_scientific",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	state_machine.excute("short_cut_go_to_other_window",0,{10})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_goto_up_scientific_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_troops_assembled state machine.
    init_red_alert_time_act_up_scientific_terminal()
end

function RedAlertTimeActivityActUpScientific:onUpdateDraw()
    local root = self.roots[1]
    local Text_up_scientific_p_2 = ccui.Helper:seekWidgetByName(root, "Text_up_scientific_p_2") -- 描述
	local Text_up_scientific_time_n = ccui.Helper:seekWidgetByName(root, "Text_up_scientific_time_n") -- 时间
    local Text_up_scientific_time_t = ccui.Helper:seekWidgetByName(root, "Text_up_scientific_time_t")
    local Text_up_scientific_name = ccui.Helper:seekWidgetByName(root, "Text_up_scientific_name") --名称
    Text_up_scientific_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
    Text_up_scientific_p_2:setString(_ED.activity_info[""..self.activity_type].activity_dec)
    Text_up_scientific_time_n:setVisible(false)
    Text_up_scientific_time_t:removeAllChildren(true)
    Text_up_scientific_time_t:setString("")
    local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    local font_size = Text_up_scientific_time_t:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_up_scientific_time_t:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_up_scientific_time_t:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_up_scientific_time_t:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_up_scientific_time_t:addChild(time_int_1)
end

function RedAlertTimeActivityActUpScientific:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_up_scientific_time_t"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_up_scientific_time_t"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
end

function RedAlertTimeActivityActUpScientific:onEnterTransitionFinish()

end


function RedAlertTimeActivityActUpScientific:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_up_scientific)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
    --升级科技
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up_scientific_up"), nil, 
    {
        terminal_name = "red_alert_time_goto_up_scientific", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 3)

	self:onUpdateDraw()
end

function RedAlertTimeActivityActUpScientific:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeActivityActUpScientific:onExit()
    state_machine.remove("red_alert_time_goto_up_scientific")
end
