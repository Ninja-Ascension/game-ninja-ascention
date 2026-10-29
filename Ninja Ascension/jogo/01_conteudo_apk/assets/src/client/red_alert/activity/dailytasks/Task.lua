-----------------------------
--任务
-----------------------------
Task = class("TaskClass", Window)

local task_window_open_terminal = {
    _name = "task_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(63) == true then
            return
        end    
        local _Window = fwin:find("TaskClass")
        if nil == _Window then
            fwin:open(Task:new():init(), fwin._view)
        else
            state_machine.excute("task_window_show",0,"")
        end

        state_machine.excute("hero_main_window_show",0,"")
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")  
        state_machine.excute("duplicate_title_window_hide",0,"") 
        state_machine.excute("duplicate_map_window_hide",0,"")
        state_machine.excute("duplicate_manager_window_hide",0,"")   
        state_machine.excute("seven_star_map_ui_window_hide",0,"")   
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local task_window_close_terminal = {
    _name = "task_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TaskClass"))

        if fwin:find("NationalWarMapClass") ~= nil then
            state_machine.excute("home_button_for_action_window_show",0,"")  
        elseif fwin:find("DuplicateManagerClass") ~= nil then
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")  
            state_machine.excute("duplicate_map_window_show",0,"")   
            state_machine.excute("duplicate_manager_window_show",0,"")   
            state_machine.excute("hero_star_activation_window_close",0,"")
        elseif fwin:find("SevenStarClass") ~= nil then
            state_machine.excute("seven_star_map_ui_window_show",0,"")
            state_machine.excute("duplicate_map_window_show",0,"")
            state_machine.excute("player_resource_window_hide",0,"")
            state_machine.excute("home_button_for_action_window_show",0,"")
        elseif fwin:find("DuplicateManagerClass") == nil and fwin:find("DuplicateMapClass") ~= nil then
            state_machine.excute("duplicate_map_window_show", 0, nil)
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")
        else
            state_machine.excute("main_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")
        end
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_window_open_terminal)
state_machine.add(task_window_close_terminal)
state_machine.init()

function Task:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.red_alert.activity.dailytasks.TaskMainLineList")
    app.load("client.red_alert.activity.dailytasks.TaskDailyList")
    app.load("client.red_alert.activity.dailytasks.TaskAchieveList")
    app.load("client.red_alert.cells.activity.dailytasks.task_cell")
    app.load("client.red_alert.notification.push_notification_task")
    app.load("client.red_alert.campaign.soul_duplicate.SoulDuplicate")
    app.load("client.red_alert.campaign.gemduplicate.GemDuplicate")
    app.load("client.red_alert.campaign.weaponry.Weaponry")
    app.load("client.red_alert.campaign.shipmilitaryuse.ShipMilitaryUse")
    app.load("client.red_alert.campaign.trialtower.Trialtower")

    -- Initialize DuplicateTitle state machine.
    local function init_task_terminal()
         --管理
        local task_main_maneger_terminal = {
        _name = "task_main_maneger",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                -- hide child window
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)
            end 
            -- set select ui button is highlighted
           
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            terminal.page_name = params._datas.but_image
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
            end
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(true)
                terminal.select_button:setTouchEnabled(false)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }
	
		--显示界面
		local task_window_show_terminal = {
            _name = "task_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                state_machine.excute("task_main_line_list_update_listview",0,"")
                state_machine.excute("task_daily_list_update_listview",0,"")
                state_machine.excute("task_achieve_list_update_listview",0,"")
                state_machine.excute("chat_view_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--隐藏界面
		local task_window_hide_terminal = {
            _name = "task_window_hide",
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

         --主线
        local task_change_to_main_line_terminal = {
            _name = "task_change_to_main_line",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)     
                local Panel_task = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_task")
                state_machine.excute("task_main_line_list_window_open",0,{Panel_task})

                state_machine.excute("task_main_line_list_window_show",0,"")
                state_machine.excute("task_daily_list_window_hide",0,"")
                state_machine.excute("task_achieve_list_window_hide",0,"")

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
            --日常
        local task_change_to_dialy_terminal = {
            _name = "task_change_to_dialy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local Panel_task = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_task")
                state_machine.excute("task_daily_list_window_open",0,{Panel_task})
                
                state_machine.excute("task_daily_list_window_show",0,"")
                state_machine.excute("task_main_line_list_window_hide",0,"")
                state_machine.excute("task_achieve_list_window_hide",0,"")

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
          --成就
        local task_change_to_achievement_terminal = {
            _name = "task_change_to_achievement",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local Panel_task = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_task") 
                state_machine.excute("task_achieve_list_window_open",0,{Panel_task})

                state_machine.excute("task_achieve_list_window_show",0,"")
                state_machine.excute("task_main_line_list_window_hide",0,"")
                state_machine.excute("task_daily_list_window_hide",0,"")

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(task_main_maneger_terminal)
		state_machine.add(task_window_show_terminal)	
		state_machine.add(task_window_hide_terminal)
        state_machine.add(task_change_to_main_line_terminal)
        state_machine.add(task_change_to_dialy_terminal)
        state_machine.add(task_change_to_achievement_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_task_terminal()
end

function Task:onHide( ... )
    self:setVisible(false)
end

function Task:onShow( ... )
    self:setVisible(true)
end

function Task:onUpdateDraw()
    local root = self.roots[1]
end

function Task:onEnterTransitionFinish()

end
--第一次打开显示主线任务页面
function Task:openMainLine()
    local root = self.roots[1]
    state_machine.excute("task_main_maneger",0,{_datas = {
        terminal_name = "task_main_maneger",   
        next_terminal_name = "task_change_to_main_line", 
        current_button_name = "Button_task_mainline",
        but_image = "",  
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }})
end

function Task:onInit( )
    local csbItem = csb.createNode(config_csb.activity.dailytasks.task)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_back"), nil, 
    {
        terminal_name = "task_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 主线
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_mainline"), nil, 
    {
        terminal_name = "task_main_maneger",   
        next_terminal_name = "task_change_to_main_line", 
        current_button_name = "Button_task_mainline",
        but_image = "",  
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_to_main",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_task_mainline"),
    _invoke = nil,
    _interval = 0.5,})  
    
    -- 日常
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily"), nil, 
    {   
        terminal_name = "task_main_maneger",   
        next_terminal_name = "task_change_to_dialy", 
        current_button_name = "Button_task_mainline",
        but_image = "",  
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_to_dialy",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_task_daily"),
    _invoke = nil,
    _interval = 0.5,})  
    
    -- 成就
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_achievement"), nil, 
    {
        terminal_name = "task_main_maneger",   
        next_terminal_name = "task_change_to_achievement", 
        current_button_name = "Button_task_mainline",
        but_image = "",  
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_to_achievement",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_task_achievement"),
    _invoke = nil,
    _interval = 0.5,})  


    state_machine.excute("task_change_to_main_line",0,"")

	self:onUpdateDraw()	
    self:openMainLine()
end

function Task:init(scenceID,from_type)
	self:onInit()
    return self
end

function Task:close()
    local root = self.roots[1]
    local Panel_task = ccui.Helper:seekWidgetByName(root, "Panel_task")
    if Panel_task ~= nil then
        Panel_task:removeAllChildren(true)
    end
end

function Task:onExit()
    state_machine.remove("task_window_show")    
    state_machine.remove("task_window_hide")
    state_machine.remove("task_main_maneger")
    state_machine.remove("task_change_to_main_line")
    state_machine.remove("task_change_to_dialy")
    state_machine.remove("task_change_to_achievement")    
end
