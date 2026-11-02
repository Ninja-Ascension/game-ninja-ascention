----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日任务的管理器
-------------------------------------------------------------------------------------------------------
SevenDaysForEveryDayManager = class("SevenDaysForEveryDayManagerClass", Window)
    
function SevenDaysForEveryDayManager:ctor()
    self.super:ctor()
    self.roots = {}
    self.group = {
        _welfare = nil,
        _achievement1 = nil,
        _achievement2 = nil,
        _prop_buy = nil
    }

    self.activity = _ED.active_activity[42]
    self.currentDayIndex= 0
	
    -- Initialize seven days activity for every day manager page state machine.
    local function init_seven_days_activity_for_every_day_manager_terminal()
        local seven_days_activity_for_every_day_manager_change_day_terminal = {
            _name = "seven_days_activity_for_every_day_manager_change_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local currentDayIndex = params
                if instance.currentDayIndex ~= currentDayIndex then
                    instance:changeToDay(currentDayIndex)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_activity_for_every_day_manager_terminal = {
            _name = "seven_days_activity_for_every_day_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
				if terminal.select_panel ~= nil then
					terminal.select_panel:setVisible(false)
				end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
				if params._datas.current_panel_name ~= nil or params._datas.current_panel_name ~= "" then
                    terminal.select_panel = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_panel_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
				if terminal.select_panel ~= nil then
                    if __lua_project_id == __lua_project_warship_girl_b 
		    	or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
                        terminal.select_panel:setVisible(false)
                    else
                        terminal.select_panel:setVisible(true)
                    end

					
                end

                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    instance:hideListView()
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 每日福利
        local seven_days_activity_for_every_day_welfare_terminal = {
            _name = "seven_days_activity_for_every_day_welfare",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:showEveryDayWelfare()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 成就
        local seven_days_activity_for_every_day_achievement1_terminal = {
            _name = "seven_days_activity_for_every_day_achievement1",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:showEveryDayAchievement(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 成就
        local seven_days_activity_for_every_day_achievement2_terminal = {
            _name = "seven_days_activity_for_every_day_achievement2",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:showEveryDayAchievement(2)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 半价抢购
        local seven_days_activity_for_every_day_prop_buy_terminal = {
            _name = "seven_days_activity_for_every_day_prop_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:showEveryDayPropBuy()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_activity_for_every_day_manager_change_day_terminal)
        state_machine.add(seven_days_activity_for_every_day_manager_terminal)
        state_machine.add(seven_days_activity_for_every_day_welfare_terminal)
        state_machine.add(seven_days_activity_for_every_day_achievement1_terminal)
        state_machine.add(seven_days_activity_for_every_day_achievement2_terminal)
        state_machine.add(seven_days_activity_for_every_day_prop_buy_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for every day manager state machine.
    init_seven_days_activity_for_every_day_manager_terminal()
end

function SevenDaysForEveryDayManager:changeToDay(currentDayIndex)
    self.currentDayIndex = currentDayIndex
    for i, v in pairs(self.group) do
        if v ~= nil then
            if v:isVisible() == true then
                if v == self.group._welfare then
                    state_machine.excute("seven_days_activity_for_every_day_welfare_reset", 0, self.currentDayIndex)
                elseif v == self.group._achievement1 then
                    state_machine.excute("seven_days_activity_for_every_day_achievement_reset", 0, {_instance = self.group._achievement1, _currentDayIndex = self.currentDayIndex})
                elseif v == self.group._achievement2 then
                    state_machine.excute("seven_days_activity_for_every_day_achievement_reset", 0, {_instance = self.group._achievement2, _currentDayIndex = self.currentDayIndex})
                elseif v == self.group._prop_buy then
                    state_machine.excute("seven_days_activity_for_every_day_prop_buy_reset", 0, self.currentDayIndex)
                end
            else
                fwin:close(v)
                self.group[i] = nil
            end
        end
    end

    local root = self.roots[1]
    local titleStrings = zstring.split(dms.string(dms["carnival_mould"], self.currentDayIndex, carnival_mould.tags_pic_index), ",")
    local titleNames = zstring.split(dms.string(dms["carnival_mould"], self.currentDayIndex, carnival_mould.page_name), ",")
    -- 修正标题文件
	local num = 1
    for i = 1, 4 do
        ccui.Helper:seekWidgetByName(root, "Panel_daytext_"..i):setBackGroundImage(string.format("images/ui/play/wonderful_activity/seven_day/text_%s.png", titleStrings[i] or 1))
		ccui.Helper:seekWidgetByName(root, "Panel_daytext_"..i):setVisible(false)
		if i == 2 or i == 3 then
			ccui.Helper:seekWidgetByName(root, "Text_day_"..i):setString(titleNames[num])
			num = num + 1
		end
    end
	
end

function SevenDaysForEveryDayManager:hideListView()
    for i, v in pairs(self.group) do
        if v ~= nil then
            v:setVisible(false)
        end
    end
end

function SevenDaysForEveryDayManager:initEveryDayWelfare()
    local root = self.roots[1]

    app.load("client.activity.sevendays.SevenDaysForEveryDayWelfare")
    self.group._welfare = SevenDaysForEveryDayWelfare:new():init(self.currentDayIndex)
    fwin:open(self.group._welfare, fwin._view)
end

function SevenDaysForEveryDayManager:showEveryDayWelfare()
    if self.group._welfare == nil then
        self:initEveryDayWelfare()
    end
    self.group._welfare:setVisible(true)
end

function SevenDaysForEveryDayManager:initEveryDayAchievement1(_pageIndex)
    local root = self.roots[1]
    app.load("client.activity.sevendays.SevenDaysForEveryDayAchievement")
    self.group._achievement1 = SevenDaysForEveryDayAchievement:new():init(self.currentDayIndex, _pageIndex)
    fwin:open(self.group._achievement1, fwin._view)
end

function SevenDaysForEveryDayManager:initEveryDayAchievement2(_pageIndex)
    local root = self.roots[1]
    app.load("client.activity.sevendays.SevenDaysForEveryDayAchievement")
    self.group._achievement2 = SevenDaysForEveryDayAchievement:new():init(self.currentDayIndex, _pageIndex)
    fwin:open(self.group._achievement2, fwin._view)
end

function SevenDaysForEveryDayManager:showEveryDayAchievement(_pageIndex)
     if _pageIndex == 1 then
        if self.group._achievement1 == nil then
            self:initEveryDayAchievement1(_pageIndex)
        end
    elseif _pageIndex == 2 then
        if self.group._achievement2 == nil then
            self:initEveryDayAchievement2(_pageIndex)
        end
    end
    if _pageIndex == 1 then
        self.group._achievement1:setVisible(true)
    elseif _pageIndex == 2 then
        self.group._achievement2:setVisible(true)
    end
end

function SevenDaysForEveryDayManager:initEveryDayPropBuy()
    local root = self.roots[1]
    app.load("client.activity.sevendays.SevenDaysForEveryDayPropBuy")
    self.group._prop_buy = SevenDaysForEveryDayPropBuy:new():init(self.currentDayIndex)
    fwin:open(self.group._prop_buy, fwin._view)
end

function SevenDaysForEveryDayManager:showEveryDayPropBuy()
    if self.group._prop_buy == nil then
        self:initEveryDayPropBuy()
    end
    self.group._prop_buy:setVisible(true)
end

function SevenDaysForEveryDayManager:onEnterTransitionFinish()
    local csbSevenDaysForEveryDayManager = csb.createNode("activity/7days/week_Activities_day_1.csb")
    self:addChild(csbSevenDaysForEveryDayManager)

    local root = csbSevenDaysForEveryDayManager:getChildByName("root")
    table.insert(self.roots, root)
	
	local csbTrialTowerCard = csb.createNode("activity/7days/week_Activities_listview.csb")
	csbSevenDaysForEveryDayManager:addChild(csbTrialTowerCard)

    local terminal_names = {
        "seven_days_activity_for_every_day_welfare",
        "seven_days_activity_for_every_day_achievement1",
        "seven_days_activity_for_every_day_achievement2",
        "seven_days_activity_for_every_day_prop_buy",
    }

	local setPressedActionEnabled=true
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		setPressedActionEnabled=false
	end
    -- 添加控件的响应事件
    for i = 1, 4 do
        local rewardTabButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_day_"..i),   nil, 
        {
            terminal_name = "seven_days_activity_for_every_day_manager",     
            next_terminal_name = terminal_names[i],      
            current_button_name = "Button_day_"..i,
			current_panel_name = "Panel_daytext_"..i,
            but_image = "",   
            terminal_state = 0, 
            isPressedActionEnabled = setPressedActionEnabled
        }, 
        nil, 0)
        if i == 1 then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity_welfare_reward_page_tab",
            _widget = rewardTabButton,
            _invoke = nil,
            _interval = 0.5,})
        end
        if i == 2 then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity_achievement1_reward_page_tab",
            _widget = rewardTabButton,
            _invoke = nil,
            _interval = 0.5,})
        end
        if i == 3 then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity_achievement2_reward_page_tab",
            _widget = rewardTabButton,
            _invoke = nil,
            _interval = 0.5,})
        end
        if i == 4 then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity_prop_buy_reward_page_tab",
            _widget = rewardTabButton,
            _invoke = nil,
            _interval = 0.5,})
        end
    end
	
    self:changeToDay(self.currentDayIndex)
	
    state_machine.excute("seven_days_activity_for_every_day_manager", 0, 
    {
            _datas = 
            {
                terminal_name = "seven_days_activity_for_every_day_manager",     
                next_terminal_name = terminal_names[1],      
                current_button_name = "Button_day_"..1,     
				current_panel_name = "Panel_daytext_"..1,				
                but_image = "",   
                terminal_state = 0, 
                isPressedActionEnabled = true
            }
    })
end

function SevenDaysForEveryDayManager:onExit()
	state_machine.remove("seven_days_activity_for_every_day_manager_change_day")
    state_machine.remove("seven_days_activity_for_every_day_manager")
    state_machine.remove("seven_days_activity_for_every_day_welfare")
    state_machine.remove("seven_days_activity_for_every_day_achievement1")
    state_machine.remove("seven_days_activity_for_every_day_achievement2")
    state_machine.remove("seven_days_activity_for_every_day_prop_buy")

    state_machine.remove("seven_days_activity_for_every_day_achievement_reset")

    state_machine.remove("seven_days_activity_for_every_day_prop_buy_request")
    state_machine.remove("seven_days_activity_for_every_day_prop_buy_reset")

    state_machine.remove("seven_days_activity_for_every_day_welfare_reset")
end

function SevenDaysForEveryDayManager:init(dayIndex)
    self.currentDayIndex = dayIndex
    return self
end

function SevenDaysForEveryDayManager:createCell()
	local cell = SevenDaysForEveryDayManager:new()
	cell:registerOnNodeEvent(cell)
	return cell
end