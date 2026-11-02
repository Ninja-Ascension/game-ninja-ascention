-----------------------------
--战力排行的活动奖励
-----------------------------
SmRankActivityAward = class("SmRankActivityAwardClass", Window)
SmRankActivityAward.__size = nil

local sm_rank_activity_award_window_open_terminal = {
    _name = "sm_rank_activity_award_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmRankActivityAward:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_rank_activity_award_window_open_terminal)
state_machine.init()

function SmRankActivityAward:ctor()
    self.super:ctor()
    self.roots = {}
    self._list_view = nil
    self._list_view_posy = 0

    app.load("client.l_digital.cells.activity.wonderful.sm_activity_award_cell")
    local function init_sm_rank_activity_award_terminal()
		--显示界面
		local sm_rank_activity_award_show_terminal = {
            _name = "sm_rank_activity_award_show",
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
		local sm_rank_activity_award_hide_terminal = {
            _name = "sm_rank_activity_award_hide",
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

		state_machine.add(sm_rank_activity_award_show_terminal)	
		state_machine.add(sm_rank_activity_award_hide_terminal)

        state_machine.init()
    end
    init_sm_rank_activity_award_terminal()
end

function SmRankActivityAward:onHide()
    local root = self.roots[1]
    local ListView_tab_1 = ccui.Helper:seekWidgetByName(root, "ListView_tab_1")
    ListView_tab_1:jumpToTop()
    ListView_tab_1:removeAllItems()
    self:setVisible(false)
    self:stopAllActions()
end

function SmRankActivityAward:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function SmRankActivityAward:getTimeFormatYMDHMS( m_time )
    local temp = os.date("*t",getBaseGTM8Time(m_time))

    local m_month   = string.format("%02d", temp.month)
    local m_day     = string.format("%02d", temp.day)
    local m_hour    = string.format("%02d", temp.hour)
    local m_min     = string.format("%02d", temp.min)
    local m_sec     = string.format("%02d", temp.sec)


    local timeString = m_month .._activity_full_service_times_tips[2].. m_day .._activity_full_service_times_tips[3].. m_hour .._activity_full_service_times_tips[4]
    return timeString
end

function SmRankActivityAward:getTimeFormatTwo( m_time )
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

function SmRankActivityAward:onUpdateDraw()
    local root = self.roots[1]
    
    local ListView_tab_1 = ccui.Helper:seekWidgetByName(root, "ListView_tab_1")
    ListView_tab_1:removeAllItems()
    local index = 1
    local activity = _ED.active_activity[86]
    local activity_params = _ED.active_activity[86].activity_params
    local paramsdatas = zstring.split(activity_params,"!")
    local params = zstring.split(paramsdatas[1],",")
    for i, v in pairs(activity.activity_Info) do
        if index <= tonumber(params[1]) then
            local cell = state_machine.excute("sm_activity_award_cell",0,{v, index})
            ListView_tab_1:addChild(cell)
            index = index + 1
        end
    end
    ListView_tab_1:requestRefreshView()

    self._list_view = ListView_tab_1
    self._list_view_posy = self._list_view:getInnerContainer():getPositionY()

    local Text_top_tips_1 = ccui.Helper:seekWidgetByName(root, "Text_top_tips_1")
    local strs2 = string.format(_activity_full_service_rankings_tips[5],self:getTimeFormatTwo(zstring.tonumber(paramsdatas[3])/1000))
    Text_top_tips_1:setString(strs2)
end

function SmRankActivityAward:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_posy == posY then
            return
        end
        self._list_view_posy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height /2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmRankActivityAward:onEnterTransitionFinish()

end

function SmRankActivityAward:onInit( )
    local csbItem = csb.createNode("activity/wonderful/sm_fighting_up_tab_1.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmRankActivityAward.__size == nil then
        SmRankActivityAward.__size = root:getContentSize()
    end
    self:setContentSize(SmRankActivityAward.__size)

    self:onUpdateDraw()
    
end

function SmRankActivityAward:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmRankActivityAward:onExit()
    state_machine.remove("sm_rank_activity_award_show")    
    state_machine.remove("sm_rank_activity_award_hide")
end
