----------------------------------------------------------------------------------------------------
-- 说明：top排行榜主界面
-------------------------------------------------------------------------------------------------------

ActivityTopRank = class("ActivityTopRankClass", Window)
local activity_top_rank_open_terminal = {
    _name = "activity_top_rank_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local topRank = ActivityTopRank:new()
        topRank:init()
        fwin:open(topRank,fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_top_rank_open_terminal)
state_machine.init()

function ActivityTopRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    app.load("client.cells.activity.activity_top_rank_cell")
    self.activity = _ED.active_activity[78]
    self.currentDayIndex = 0
    
    -- Initialize seven days activity page state machine.
    local function init_seven_days_activity_terminal()
        local activity_top_rank_help_terminal = {
            _name = "activity_top_rank_help",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.activity.top_rank.ActivityTopRankHelp")
                state_machine.excute("activity_top_rank_help_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_top_rank_select_manager_terminal = {
            _name = "activity_top_rank_select_manager",
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

        local activity_top_rank_manager_terminal = {
            _name = "activity_top_rank_manager",
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
                fwin:close(fwin:find("ActivityTopRankClass"))
                fwin:close(fwin:find("UserInformationShopClass"))
                state_machine.excute("menu_back_home_page", 0, "menu_back_home_page")               
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(activity_top_rank_help_terminal)
        state_machine.add(activity_top_rank_select_manager_terminal)
        state_machine.add(activity_top_rank_manager_terminal)
        state_machine.add(seven_days_activity_close_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity state machine.
    init_seven_days_activity_terminal()
end

function ActivityTopRank:selectDayPage(index)
    local root = self.roots[1]
    local titlePanel = ccui.Helper:seekWidgetByName(root, "Panel_title")
    titlePanel:removeBackGroundImage()
    titlePanel:setBackGroundImage("images/ui/play/wonderful_activity/top_rank_title_" .. index .. ".png")
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllItems()
    local charInfo = nil
    if index == 1 then 
        charInfo = _ED.charts.top_fight_rank_info
    elseif index == 2 then 
        charInfo = _ED.charts.top_equip_streng_rank_info
    elseif index == 3 then 
        charInfo = _ED.charts.top_soul_rank_info
    elseif index == 4 then 
        charInfo = _ED.charts.top_refine_equip_rank_info
    elseif index == 5 then 
        charInfo = _ED.charts.top_first_rank_info
    elseif index == 6 then 
        charInfo = _ED.charts.top_slick_rank_info
    elseif index == 7 then 
        charInfo = _ED.charts.top_refine_treasure_rank_info
    end
    for i=1,10 do
        local cell = ActivityTopRankCell:createCell()
        if charInfo~= nil then 
            cell:init(charInfo[i],i,index,self.currentDayIndex)
        else
            cell:init(nil,i,index,self.currentDayIndex)
        end
        listView:addChild(cell)
    end
    listView:requestRefreshView()
end

function ActivityTopRank:onUpdateDraw()
    local root = self.roots[1]
    local activity = _ED.active_activity[78]--
    if activity ~= nil then
        local activitybegTime = ccui.Helper:seekWidgetByName(root, "Text_time_1")   --开始时间
        local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_time_2")   --结束时间
        local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_time_3")   --结束时间
        activitybegTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
                                            .."%m"..tipStringInfo_time_info[2]
                                            .."%d"..tipStringInfo_time_info[10]
                                            .."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.begin_time)/1000)))
        activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
                                            .."%m"..tipStringInfo_time_info[2]
                                            .."%d"..tipStringInfo_time_info[10]
                                            .."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.end_time)/1000)))   
                                
        rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
                                        .."%m"..tipStringInfo_time_info[2]
                                        .."%d"..tipStringInfo_time_info[10]
                                            .."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.activity_draw_over_time)/1000)))    
    end
end

function ActivityTopRank:onEnterTransitionFinish()
    local csbActivityTopRank = csb.createNode("activity/wonderful/activity_top_rank.csb")
    self:addChild(csbActivityTopRank)

    local root = csbActivityTopRank:getChildByName("root")
    table.insert(self.roots, root)
    local currentDayIndex = zstring.tonumber(self.activity.activity_day_count)
    self.currentDayIndex = currentDayIndex
    for i = 1, 7 do
        local dayImageBut = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_day_" .. i),       nil, 
        {
            terminal_name = "activity_top_rank_manager",  
            next_terminal_name = "activity_top_rank_select_manager"..i, 
            next_terminal_manager = "activity_top_rank_select_manager", 
            current_activity_day = ""..i,    
            current_button_name = "Image_day_" .. i,
            but_image = "Image_day_"..i.."_0",       
            terminal_state = 1, 
            isPressedActionEnabled = false,
            _self = self
        }, 
        nil, 0)
    end
    
    if currentDayIndex > 7 then 
        currentDayIndex = 1
    end
    if currentDayIndex >= 1 then
        state_machine.excute("activity_top_rank_manager", 0,{ 
            _datas = 
            { 
                _terminal_name = "activity_top_rank_manager",
                next_terminal_name = "activity_top_rank_select_manager"..currentDayIndex, 
                next_terminal_manager = "activity_top_rank_select_manager", 
                current_activity_day = ""..currentDayIndex,    
                current_button_name = "Image_day_" .. currentDayIndex,
                but_image = "Image_day_"..currentDayIndex.."_0",       
                terminal_state = 1, 
                isPressedActionEnabled = false,
                _self = self
            }
        })
    end

    -- 帮助的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "activity_top_rank_help",     
        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)


    -- state_machine.excute("activity_top_rank_manager", 0, {
    --         _datas = 
    --         {
    --             terminal_name = "activity_top_rank_manager",  
    --             next_terminal_name = "activity_top_rank_select_manager"..self.activity.activity_day_count, 
    --             next_terminal_manager = "activity_top_rank_select_manager", 
    --             current_activity_day = ""..self.activity.activity_day_count,    
    --             current_button_name = "Image_day_"..self.activity.activity_day_count,
    --             but_image = "Image_day_"..self.activity.activity_day_count.."_0",       
    --             terminal_state = 1, 
    --             isPressedActionEnabled = false
    --         }
    --     })
    app.load("client.player.UserInformationShop")
    fwin:open(UserInformationShop:new(),fwin._view)
    self:onUpdateDraw()
end

function ActivityTopRank:onExit()
    -- state_machine.remove("activity_top_rank_help")
    -- state_machine.remove("activity_top_rank_select_manager")
    -- state_machine.remove("activity_top_rank_manager")
    -- state_machine.remove("seven_days_activity_close")
end

function ActivityTopRank:init()

end


function ActivityTopRank:drawTime(_time)
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

function ActivityTopRank:onUpdate(dt)
    --self:updateDrawActivityTime()
end

-- function ActivityTopRank:updateDrawActivityTime()
--     local root = self.roots[1]
--     local activity = self.activity
--     local surplus_time = activity.activity_over_time - ((os.time() - activity.activity_current_time) * 1000)
--     ccui.Helper:seekWidgetByName(root, "Text_time_1"):setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
--     surplus_time = activity.activity_draw_over_time - ((os.time() - activity.activity_current_time) * 1000)
--     ccui.Helper:seekWidgetByName(root, "Text_time_2"):setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
-- end