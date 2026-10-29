-----------------------------
--消消乐
-----------------------------
RedAlertTimeEliminateMusic = class("RedAlertTimeEliminateMusicClass", Window)

local red_alert_time_eliminate_music_window_open_terminal = {
    _name = "red_alert_time_eliminate_music_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeEliminateMusicClass") then
			fwin:open(RedAlertTimeEliminateMusic:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_eliminate_music_window_close_terminal = {
    _name = "red_alert_time_eliminate_music_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.show_reward_list_group_ex = {}
        fwin:close(fwin:find("RedAlertTimeEliminateMusicClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_eliminate_music_window_open_terminal)
state_machine.add(red_alert_time_eliminate_music_window_close_terminal)
state_machine.init()

function RedAlertTimeEliminateMusic:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0
    self._turntable_panel = nil
    self._rank_panel = nil
    self.m_times = 0
	
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeEliminateMusicTransfer")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeEliminateMusicTask")
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_eliminate_music_task_cell")
	
    local function init_red_alert_time_eliminate_music_terminal()
    
        -- 切换界面
        local red_alert_time_eliminate_music_change_page_terminal = {
          _name = "red_alert_time_eliminate_music_change_page",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
        state_machine.add(red_alert_time_eliminate_music_change_page_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_eliminate_music state machine.
    init_red_alert_time_eliminate_music_terminal()
end


function RedAlertTimeEliminateMusic:changeSelectPage( page )
    local root = self.roots[1]
    --标题
    ccui.Helper:seekWidgetByName(root, "Text_brothers_share_tit"):setString(self._activity_type.activity_title)
    
    local Panel_brothers_share_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_brothers_share_tab_box")
    local Button_brothers_activty = ccui.Helper:seekWidgetByName(root, "Button_brothers_activty")
    local Button_brothers_package = ccui.Helper:seekWidgetByName(root, "Button_brothers_package")
    if page == self._current_page then
        if page == 1 then
            Button_brothers_activty:setHighlighted(true)
        elseif page == 2 then
            Button_brothers_package:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_brothers_activty:setHighlighted(false)
    Button_brothers_package:setHighlighted(false)

    state_machine.excute("red_alert_time_eliminate_music_transfer_hide", 0, nil)
    state_machine.excute("red_alert_time_eliminate_music_task_hide", 0, nil)

    if page == 1 then
        Button_brothers_activty:setHighlighted(true)
        if self._turntable_panel == nil then
            self._turntable_panel = state_machine.excute("red_alert_time_eliminate_music_transfer_open", 0, {Panel_brothers_share_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_eliminate_music_transfer_show", 0, nil)
        end
    elseif page == 2 then
        Button_brothers_package:setHighlighted(true)
        if self._rank_panel == nil then
            self._rank_panel = state_machine.excute("red_alert_time_eliminate_music_task_open", 0, {Panel_brothers_share_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_eliminate_music_task_show", 0, nil)
        end
    end
end

function RedAlertTimeEliminateMusic:onEnterTransitionFinish()

end

function RedAlertTimeEliminateMusic:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.eliminate_music)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_brothers_share_close"), nil, 
    {
        terminal_name = "red_alert_time_eliminate_music_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_brothers_activty"), nil, 
    {
        terminal_name = "red_alert_time_eliminate_music_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_brothers_package"), nil, 
    {
        terminal_name = "red_alert_time_eliminate_music_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_treasurehouse_eliminate_music",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_brothers_package"),
    _invoke = nil,
    _interval = 0.3,})
    
    self:changeSelectPage(1)

    local timesData = zstring.split(self._activity_type.activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
end

function RedAlertTimeEliminateMusic:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt

        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_eliminate_music_window_close")
        end
    end
end


function RedAlertTimeEliminateMusic:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeEliminateMusic:onExit()
    state_machine.remove("red_alert_time_eliminate_music_change_page")
end
