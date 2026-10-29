-----------------------------
--战力排行活动规则介绍
-----------------------------
SmActivityRankRules = class("SmActivityRankRulesClass", Window)

local sm_activity_rank_rules_window_open_terminal = {
    _name = "sm_activity_rank_rules_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmActivityRankRules:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_rank_rules_window_open_terminal)
state_machine.init()

function SmActivityRankRules:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}

    local function init_sm_activity_rank_rules_terminal()
		--显示界面
		local sm_activity_rank_rules_show_terminal = {
            _name = "sm_activity_rank_rules_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_activity_rank_rules_hide_terminal = {
            _name = "sm_activity_rank_rules_hide",
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

		state_machine.add(sm_activity_rank_rules_show_terminal)	
		state_machine.add(sm_activity_rank_rules_hide_terminal)

        state_machine.init()
    end
    init_sm_activity_rank_rules_terminal()
end

function SmActivityRankRules:onHide()
    self:setVisible(false)
end

function SmActivityRankRules:onShow()
    self:setVisible(true)
end

function SmActivityRankRules:getTimeFormatYMDHMS( m_time )
    local temp = os.date("*t",getBaseGTM8Time(m_time))

    local m_month   = string.format("%02d", temp.month)
    local m_day     = string.format("%02d", temp.day)
    local m_hour    = string.format("%02d", temp.hour)
    local m_min     = string.format("%02d", temp.min)
    local m_sec     = string.format("%02d", temp.sec)


    local timeString = m_month .._activity_full_service_times_tips[2].. m_day .._activity_full_service_times_tips[3].. m_hour .._activity_full_service_times_tips[4]
    return timeString
end

function SmActivityRankRules:getTimeFormatTwo( m_time )
    local temp = os.date("*t",getBaseGTM8Time(m_time))

    local m_month   = string.format("%02d", temp.month)
    local m_day     = string.format("%02d", temp.day)
    local m_hour    = string.format("%02d", temp.hour)
    local m_min     = string.format("%02d", temp.min)
    local m_sec     = string.format("%02d", temp.sec)

    local str = _activity_full_service_times_tips[5]
    if tonumber(m_hour) >= 18 then
        str = _activity_full_service_times_tips[7]
    elseif tonumber(m_hour) >= 12 and tonumber(m_hour) < 18 then
        str = _activity_full_service_times_tips[6]
    elseif tonumber(m_hour) >=0 and tonumber(m_hour) < 12 then
        str = _activity_full_service_times_tips[5]
    end

    local timeString = m_month .._activity_full_service_times_tips[2].. m_day .._activity_full_service_times_tips[3]..str.. m_hour ..":".. m_min
    return timeString
end


function SmActivityRankRules:onUpdateDraw()
    local root = self.roots[1]
    local Text_rule_1 = ccui.Helper:seekWidgetByName(root, "Text_rule_1")
    local Text_rule_2 = ccui.Helper:seekWidgetByName(root, "Text_rule_2")
    local Text_rule_3 = ccui.Helper:seekWidgetByName(root, "Text_rule_3")
    local Text_rule_4 = ccui.Helper:seekWidgetByName(root, "Text_rule_4")
    local activity = _ED.active_activity[86]
    local activity_params = _ED.active_activity[86].activity_params
    local paramsdatas = zstring.split(activity_params,"!")
    local strs1 = string.format(_activity_full_service_rankings_tips[1],self:getTimeFormatYMDHMS(zstring.tonumber(_ED.active_activity[86].begin_time)/1000).."-"..self:getTimeFormatYMDHMS(zstring.tonumber(_ED.active_activity[86].end_time)/1000))
    Text_rule_1:setString(strs1)

    local strs2 = string.format(_activity_full_service_rankings_tips[2],self:getTimeFormatTwo(zstring.tonumber(paramsdatas[3])/1000))
    Text_rule_2:setString(strs2)

    Text_rule_3:setString(_activity_full_service_rankings_tips[3])
    
    local strs4 = string.format(_activity_full_service_rankings_tips[4],zstring.tonumber(paramsdatas[2]))
    Text_rule_4:setString(strs4)
end

function SmActivityRankRules:onUpdate(dt)
    
end

function SmActivityRankRules:onEnterTransitionFinish()

end

function SmActivityRankRules:onInit( )
    local csbItem = csb.createNode("activity/wonderful/sm_fighting_up_tab_5.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self:onUpdateDraw()
end

function SmActivityRankRules:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmActivityRankRules:onExit()
    state_machine.remove("sm_activity_rank_rules_show")    
    state_machine.remove("sm_activity_rank_rules_hide")
end
