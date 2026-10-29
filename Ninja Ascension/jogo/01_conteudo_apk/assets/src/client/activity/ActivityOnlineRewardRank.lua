----------------------------------------------------------------------------------------------------
-- 说明：在线奖励活动主界面
-------------------------------------------------------------------------------------------------------

ActivityOnlineRewardRank = class("ActivityOnlineRewardRankClass", Window)
local activity_online_reward_open_terminal = {
    _name = "activity_online_reward_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local topRank = ActivityOnlineRewardRank:new()
        topRank:init()
        fwin:open(topRank,fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_online_reward_open_terminal)
state_machine.init()

function ActivityOnlineRewardRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.time_text = nil 
    self.reward_states = nil
    app.load("client.cells.activity.activity_online_reward_list_cell")
    app.load("client.utils.TimeUtil")
    self.activity = _ED.active_activity[80]
    self.current_total_time = 0
    
    -- Initialize seven days activity page state machine.
    local function init_seven_days_activity_terminal()
       
        local activity_online_reward_rank_select_manager_terminal = {
            _name = "activity_online_reward_rank_select_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local currentActivityDay = zstring.tonumber(params._datas.current_activity_day)
                if params._datas._self ~= nil and params._datas._self.roots ~= nil then 
                    params._datas._self:selectDayPage(currentActivityDay)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_online_reward_rank_manager_terminal = {
            _name = "activity_online_reward_rank_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
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
                fwin:close(fwin:find("ActivityOnlineRewardRankClass"))
                fwin:close(fwin:find("UserInformationShopClass"))
                state_machine.excute("menu_back_home_page", 0, "menu_back_home_page")               
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_online_reward_rank_select_manager_terminal)
        state_machine.add(activity_online_reward_rank_manager_terminal)
        state_machine.add(seven_days_activity_close_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity state machine.
    init_seven_days_activity_terminal()
end

function ActivityOnlineRewardRank:selectDayPage(index)
    local root = self.roots[1]
    if _ED.on_linde_gift_info == nil or root == nil then 
        return
    end
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1") 
    local rewards = dms.searchs(dms["online_gift_mould"], online_gift_mould.page_index,index)
    listView:removeAllItems()
    for k,v in pairs(rewards) do
        local cell = ActivityOnlineRewardListCell:createCell()
        cell:init(v,index)
        listView:addChild(cell)
    end
    listView:requestRefreshView()
end

function ActivityOnlineRewardRank:onUpdateDraw()
    local root = self.roots[1]
    local activity = _ED.active_activity[80]--
    if activity ~= nil then
        local activitybegTime = ccui.Helper:seekWidgetByName(root, "Text_time_1")   --开始时间
        local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_time_2")   --结束时间
        self.reward_states = zstring.split("" .. _ED.on_linde_gift_info.reward_states, ",")
        --local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_time_3")   --结束时间
        activitybegTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
                                            .."%m"..tipStringInfo_time_info[2]
                                            .."%d"..tipStringInfo_time_info[10]
                                            .."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.begin_time)/1000)))
        activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
                                            .."%m"..tipStringInfo_time_info[2]
                                            .."%d"..tipStringInfo_time_info[10]
                                            .."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.end_time)/1000)))   
                                
        -- rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
        --                                 .."%m"..tipStringInfo_time_info[2]
        --                                 .."%d"..tipStringInfo_time_info[10]
        --                                     .."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.activity_draw_over_time)/1000)))    
    end
end

function ActivityOnlineRewardRank:onEnterTransitionFinish()
    local csbActivityOnlineRewardRank = csb.createNode("activity/wonderful/activity_online_reward.csb")
    self:addChild(csbActivityOnlineRewardRank)
    local root = csbActivityOnlineRewardRank:getChildByName("root")
    table.insert(self.roots, root)
    local currentDayIndex = zstring.tonumber(self.activity.activity_day_count)
    self.current_total_time = _ED.on_linde_gift_info.current_online_time[currentDayIndex]
    for i = 1, 3 do
        local dayImageBut = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_day_" .. i),       nil, 
        {
            terminal_name = "activity_online_reward_rank_manager",  
            next_terminal_name = "activity_online_reward_rank_select_manager"..i, 
            next_terminal_manager = "activity_online_reward_rank_select_manager", 
            current_activity_day = ""..i,    
            current_button_name = "Image_day_" .. i,
            but_image = "Image_day_"..i.."_0",       
            terminal_state = 1, 
            isPressedActionEnabled = false,
            _self = self
        }, 
        nil, 0)
    end
    self.time_text = ccui.Helper:seekWidgetByName(root, "Text_time_v")
    if currentDayIndex > 2 then 
        currentDayIndex = 1
    end
    if currentDayIndex >= 1 then
        state_machine.excute("activity_online_reward_rank_manager", 0,{ 
            _datas = 
            { 
                _terminal_name = "activity_online_reward_rank_manager",
                next_terminal_name = "activity_online_reward_rank_select_manager"..currentDayIndex, 
                next_terminal_manager = "activity_online_reward_rank_select_manager", 
                current_activity_day = ""..currentDayIndex,    
                current_button_name = "Image_day_" .. currentDayIndex,
                but_image = "Image_day_"..currentDayIndex.."_0",       
                terminal_state = 1, 
                isPressedActionEnabled = false,
                _self = self
            }
        })
    end


    app.load("client.player.UserInformationShop")
    fwin:open(UserInformationShop:new(),fwin._view)
    self:onUpdateDraw()
end

function ActivityOnlineRewardRank:onExit()
    state_machine.remove("activity_online_reward_rank_select_manager")
    state_machine.remove("activity_online_reward_rank_manager")
    state_machine.remove("seven_days_activity_close")
end

function ActivityOnlineRewardRank:init()

end


function ActivityOnlineRewardRank:drawTime(_time)
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

function ActivityOnlineRewardRank:onUpdate(dt)
    self:updateDrawActivityTime()
end

function ActivityOnlineRewardRank:updateDrawActivityTime()
    local root = self.roots[1]
    if self.time_text ~= nil then 
        local current_time = (os.time() - _ED.on_linde_gift_info.current_system_time ) + self.current_total_time
        
        local timeTabel = formatTime(current_time)
        local str = timeTabel.hour ..":"
        str = str .. string.format("%02d"..":", timeTabel.minute)
        str = str .. string.format("%02d".."", timeTabel.second)

        self.time_text:setString(str)
    end
end