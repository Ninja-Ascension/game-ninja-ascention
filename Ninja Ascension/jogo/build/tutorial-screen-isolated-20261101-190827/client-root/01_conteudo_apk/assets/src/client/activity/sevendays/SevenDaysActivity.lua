----------------------------------------------------------------------------------------------------
-- 说明：七日活动主界面
-------------------------------------------------------------------------------------------------------

SevenDaysActivity = class("SevenDaysActivityClass", Window)
    
function SevenDaysActivity:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.activity = _ED.active_activity[42]
	
    self._Text_time_1 = nil
    self._Text_time_2 = nil

    -- Initialize seven days activity page state machine.
    local function init_seven_days_activity_terminal()
        local seven_days_activity_help_terminal = {
            _name = "seven_days_activity_help",
            _init = function (terminal) 
                app.load("client.activity.sevendays.SevenDaysActivityHelp")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:open(SevenDaysActivityHelp:new(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_activity_every_day_tasks_manager_terminal = {
            _name = "seven_days_activity_every_day_tasks_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local currentActivityDay = zstring.tonumber(params._datas.current_activity_day)
                state_machine.excute("seven_days_activity_for_every_day_manager_change_day", 0, currentActivityDay)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local seven_days_activity_manager_terminal = {
            _name = "seven_days_activity_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local currentActivityDayCount = zstring.tonumber(instance.activity.activity_day_count)
                local selectActivityDayCount = zstring.tonumber(params._datas.current_activity_day)
                -- if currentActivityDayCount < selectActivityDayCount then
                    -- TipDlg.drawTextDailog(_string_piece_info[302])
                    -- return
                -- end
				
				_ED._sevenDaysActivity_currentActivityDayCount = currentActivityDayCount
				_ED._sevenDaysActivity_selectActivityDayCount = selectActivityDayCount

                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    -- terminal.select_button:setHighlighted(false)
                    terminal.select_button:setVisible(false)
                end
                if params._datas.but_image ~= nil or params._datas.but_image ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.but_image)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    -- terminal.select_button:setHighlighted(true)
                    terminal.select_button:setVisible(true)
                end

                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    terminal.last_terminal_name = params._datas.next_terminal_manager
                    state_machine.excute(params._datas.next_terminal_manager, 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local seven_days_activity_close_terminal = {
			_name = "seven_days_activity_close",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:close(fwin:find("SevenDaysActivityClass"))
				fwin:close(fwin:find("UserInformationShopClass"))
				state_machine.excute("menu_back_home_page", 0, "menu_back_home_page") 				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
        state_machine.add(seven_days_activity_help_terminal)
		state_machine.add(seven_days_activity_every_day_tasks_manager_terminal)
        state_machine.add(seven_days_activity_manager_terminal)
		state_machine.add(seven_days_activity_close_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity state machine.
    init_seven_days_activity_terminal()
end






function SevenDaysActivity:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime > 0 then
        timeString = timeString .. _hourTime .._string_piece_info[271]
    end
    if _minutesTime > 0 then
        timeString = timeString .. _minutesTime .._string_piece_info[270]
    end
    if _secondsTime > 0 then
        timeString = timeString .. _secondsTime .._string_piece_info[165]
    end
    return timeString
end

function SevenDaysActivity:onUpdate(dt)
    self:updateDrawActivityTime()
end

function SevenDaysActivity:updateDrawActivityTime()
    local root = self.roots[1]
    local activity = self.activity
    local surplus_time = activity.activity_over_time - ((os.time() - activity.activity_current_time) * 1000)
    self._Text_time_1:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
    surplus_time = activity.activity_draw_over_time - ((os.time() - activity.activity_current_time) * 1000)
    self._Text_time_2:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function SevenDaysActivity:onUpdateDraw()
    local root = self.roots[1]

end

function SevenDaysActivity:onEnterTransitionFinish()
    local csbSevenDaysActivity = csb.createNode("activity/7days/week_Activities.csb")
    self:addChild(csbSevenDaysActivity)

    local root = csbSevenDaysActivity:getChildByName("root")
    table.insert(self.roots, root)

    -- npc action
    local action = csb.createTimeline("activity/7days/week_Activities.csb")
    table.insert(self.actions, action)
    csbSevenDaysActivity:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("Image_26_ing", true)

    local currentDayIndex = zstring.tonumber(self.activity.activity_day_count)
    self._Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")
    self._Text_time_2 = ccui.Helper:seekWidgetByName(root, "Text_time_2")
    for i = 1, 7 do
        local dayImageBut = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_day_" .. i),       nil, 
        {
            terminal_name = "seven_days_activity_manager",  
            next_terminal_name = "seven_days_activity_every_day_tasks_manager"..i, 
            next_terminal_manager = "seven_days_activity_every_day_tasks_manager", 
            current_activity_day = ""..i,    
            current_button_name = "Image_day_" .. i,
            but_image = "Image_day_"..i.."_0",       
            terminal_state = 1, 
            isPressedActionEnabled = false
        }, 
        nil, 0)
        if currentDayIndex >= i then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity_every_day_reward",
            _widget = dayImageBut,
            _invoke = nil,
            _interval = 0.5,
            _dayIndex = i})
        end
    end

    -- 帮助的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "seven_days_activity_help",     
        current_button_name = "Button_1",
        but_image = "Image_help",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)


	--返回按钮
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7day_back"), nil, 
		{
			terminal_name = "seven_days_activity_close", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil,0)
	end
	
    local button_names = {
        "Button_fl",
        "Button_fb",
        "Button_qh",
        "Button_qg",
    }

    -- for i, v in pairs() do
    --     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, v),       nil, 
    --     {
    --         terminal_name = "seven_days_activity_erery_day_tasks_manager",     
    --         -- next_terminal_name = "seven_days_activity_erery_day_copy",     
    --         current_button_name = v,
    --         but_image = "Image_day_"..i,       
    --         terminal_state = 0, 
    --         isPressedActionEnabled = true
    --     }, 
    --     nil, 0)
    -- end


    state_machine.excute("seven_days_activity_manager", 0, {
            _datas = 
            {
                terminal_name = "seven_days_activity_manager",  
                next_terminal_name = "seven_days_activity_every_day_tasks_manager"..self.activity.activity_day_count, 
                next_terminal_manager = "seven_days_activity_every_day_tasks_manager", 
                current_activity_day = ""..self.activity.activity_day_count,    
                current_button_name = "Image_day_"..self.activity.activity_day_count,
                but_image = "Image_day_"..self.activity.activity_day_count.."_0",       
                terminal_state = 1, 
                isPressedActionEnabled = false
            }
        })

    app.load("client.activity.sevendays.SevenDaysForEveryDayManager")
    self:addChild(SevenDaysForEveryDayManager:createCell():init(zstring.tonumber(self.activity.activity_day_count)))

    app.load("client.player.UserInformationShop")
    fwin:open(UserInformationShop:new(),fwin._view)
end


function SevenDaysActivity:onExit()
    state_machine.remove("seven_days_activity_help")
    state_machine.remove("seven_days_activity_every_day_tasks_manager")
    state_machine.remove("seven_days_activity_manager")
	state_machine.remove("seven_days_activity_close")

end

function SevenDaysActivity:init()

end

function SevenDaysActivity:createCell()
	local cell = SevenDaysActivity:new()
	cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 1)
	return cell
end