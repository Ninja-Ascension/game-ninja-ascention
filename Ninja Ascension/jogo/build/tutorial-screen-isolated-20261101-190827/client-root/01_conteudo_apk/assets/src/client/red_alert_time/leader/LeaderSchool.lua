--------------------------------------------------------------------------------------------------------------
--  说明：将领学堂
--------------------------------------------------------------------------------------------------------------
LeaderSchool = class("LeaderSchoolClass", Window)

--打开界面
local leader_school_window_open_terminal = {
	_name = "leader_school_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(157) == true then
            return
        end
        if nil == fwin:find("LeaderSchoolClass") then
		  fwin:open(LeaderSchool:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local leader_school_window_close_terminal = {
	_name = "leader_school_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderSchoolClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(leader_school_window_open_terminal)
state_machine.add(leader_school_window_close_terminal)
state_machine.init()

function LeaderSchool:ctor()
	self.super:ctor()
	self.roots = {}

    self._choosePage = 0
    self._recruitPanel = nil
    self._leaderPanel = nil
    self._exchangePanel = nil

    app.load("client.red_alert_time.leader.LeaderRecruit")
    app.load("client.red_alert_time.leader.LeaderRecruitOnce")
    app.load("client.red_alert_time.leader.LeaderRecruitTen")
    app.load("client.red_alert_time.leader.LeaderTeamList")
    app.load("client.red_alert_time.leader.LeaderExchangeList")
    app.load("client.red_alert_time.leader.LeaderInfo")
    app.load("client.red_alert_time.leader.LeaderExchangeInfo")
    app.load("client.red_alert_time.leader.LeaderLeaderUp")
    app.load("client.red_alert_time.leader.LeaderSynopsisWindow")
    app.load("client.red_alert_time.leader.LeaderStarUp")
    app.load("client.red_alert_time.leader.LeaderSkillLvUp")
    app.load("client.red_alert_time.leader.LeaderRecruitGetSynthesis")

    app.load("client.red_alert_time.cells.leader.leader_cell")
    app.load("client.red_alert_time.cells.leader.leader_soul_cell")
    app.load("client.red_alert_time.cells.leader.leader_prop_use_cell")
    app.load("client.red_alert_time.cells.leader.leader_infor_cell_out")
    app.load("client.red_alert_time.cells.leader.leader_infor_skill_window_cell")
    app.load("client.red_alert_time.cells.leader.leader_big_head_cell")
    app.load("client.red_alert_time.cells.equipment.equipment_reform_props_cell")

    local function init_leader_school_terminal()
        local leader_school_change_page_terminal = {
            _name = "leader_school_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas.page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_school_change_page_terminal)	
        state_machine.add(leader_school_hide_terminal)    
        state_machine.init()
    end
    init_leader_school_terminal()
end

function LeaderSchool:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_leader_school_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_leader_school_tab_box")
    local Button_recruit = ccui.Helper:seekWidgetByName(root, "Button_recruit")
    local Button_leader = ccui.Helper:seekWidgetByName(root, "Button_leader")
    local Button_leader_soul = ccui.Helper:seekWidgetByName(root, "Button_leader_soul")
    if page == self._current_page then
        if page == 1 then
            Button_recruit:setHighlighted(true)
        elseif page == 2 then
            Button_leader:setHighlighted(true)
        else
            Button_leader_soul:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_recruit:setHighlighted(false)
    Button_leader:setHighlighted(false)
    Button_leader_soul:setHighlighted(false)
    state_machine.excute("leader_recruit_hide", 0, nil)
    state_machine.excute("leader_team_list_hide", 0, nil)
    state_machine.excute("leader_exchange_list_hide", 0, nil)
    if page == 1 then
        Button_recruit:setHighlighted(true)
        if self._recruitPanel == nil then
            self._recruitPanel = state_machine.excute("leader_recruit_window_open", 0, {Panel_leader_school_tab_box})
        else
            state_machine.excute("leader_recruit_show", 0, nil)
        end
    elseif page == 2 then
        Button_leader:setHighlighted(true)
        if self._leaderPanel == nil then
            self._leaderPanel = state_machine.excute("leader_team_list_window_open", 0, {Panel_leader_school_tab_box})
        else
            state_machine.excute("leader_team_list_show", 0, nil)
        end
    else
        Button_leader_soul:setHighlighted(true)
        if self._exchangePanel == nil then
            self._exchangePanel = state_machine.excute("leader_exchange_list_window_open", 0, {Panel_leader_school_tab_box})
        else
            state_machine.excute("leader_exchange_list_show", 0, nil)
        end
    end
end

function LeaderSchool:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_school)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_school_close"), nil, 
    {
        terminal_name = "leader_school_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit"), nil, 
    {
        terminal_name = "leader_school_change_page", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        touch_black = true,
        page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader"), nil, 
    {
        terminal_name = "leader_school_change_page", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        touch_black = true,
        page = 2,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_soul"), nil, 
    {
        terminal_name = "leader_school_change_page", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        touch_black = true,
        page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_leader_exhange",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_leader_soul"),
        _invoke = nil,
        _interval = 0.2,})
    
    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function LeaderSchool:onEnterTransitionFinish()

end

function LeaderSchool:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function LeaderSchool:onExit()
    state_machine.remove("leader_school_change_page")
end