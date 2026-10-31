----------------------------------------------------------------------------------------------------
-- 说明：七日活动帮助界面
-------------------------------------------------------------------------------------------------------

SevenDaysActivityHelp = class("SevenDaysActivityHelpClass", Window)
local seven_days_activity_help_open_terminal = {
    _name = "seven_days_activity_help_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(SevenDaysActivityHelp:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(seven_days_activity_help_open_terminal)
state_machine.init()

function SevenDaysActivityHelp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self.rest_time = 0
    self.time_text = nil
    self.currProgress = nil
    -- Initialize seven days activity page state machine.
    local function init_seven_days_activity_help_terminal()
        local seven_days_activity_help_close_terminal = {
            _name = "seven_days_activity_help_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_activity_show_hero_info_terminal = {
            _name = "seven_days_activity_show_hero_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local heroMouldId = params._datas.hero_id
                app.load("client.packs.hero.HeroPatchInformation")
                local cell = HeroPatchInformation:new()
                cell:init(heroMouldId, nil , nil, 2)
                fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_activity_get_final_reward_terminal = {
            _name = "seven_days_activity_get_final_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                function showConfirmTip(instance, n)
                    if n == 0 then
                        local progress =  math.floor(tonumber(instance.currProgress[1]) / 10) 
                        local index_array = zstring.split(dms.string(dms["carnival_mould"] , 6, carnival_mould.achive) , ",")
                        local index = index_array[progress]
                        local function responseDrawWeekRewardCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(47)
                                fwin:open(getRewardWnd, fwin._ui)
                                if response.node ~= nil then
                                    response.node:updateDrawButton(1)
                                end
                            end
                        end
                        protocol_command.draw_week_reward.param_list = "8" .. "\r\n" .. "4" ..  "\r\n" .. index .. "\r\n" .. "-1"
                        NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, instance, responseDrawWeekRewardCallback, false, nil)
                    end
                end
                if tonumber(instance.currProgress[1]) < 100 then
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    tip:init(instance, showConfirmTip, _new_interface_text[299])
                    fwin:open(tip, fwin._ui)
                else
                    showConfirmTip(instance, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_activity_get_final_reward_terminal)
        state_machine.add(seven_days_activity_help_close_terminal)
        state_machine.add(seven_days_activity_show_hero_info_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity help state machine.
    init_seven_days_activity_help_terminal()
end

function SevenDaysActivityHelp:onUpdate(dt)
    if self.rest_time > 0 and self.time_text ~= nil then
        self.rest_time = self.rest_time - dt
        self.time_text:setString(self:getTimeString(self.rest_time).._new_interface_text[298])
        if self.rest_time <= 0 then
            self:updateDrawButton()
        end
    end
end

function SevenDaysActivityHelp:getTimeString(_time)
    local timeString = ""
    local now_time = math.max(zstring.tonumber(_time),0)
    now_time = math.floor(now_time)
    local day = math.floor(now_time/86400)
    if day > 0 then
        now_time = math.floor(now_time%86400)
    end
    local hour = string.format("%02d", math.floor(now_time/3600))
    local minute = string.format("%02d", math.floor((now_time%3600)/60))
    if now_time > 0 and now_time < 60 then
        minute = 1
    end
    if day > 0 then
        timeString = timeString .. day ..tipStringInfo_mine_info[4]
    end
    if day <= 0 and tonumber(hour) <= 0 then
    else
        timeString = timeString .. hour ..tipStringInfo_mine_info[5]
    end
    timeString = timeString .. minute ..tipStringInfo_mine_info[6]
    return timeString
end

function SevenDaysActivityHelp:updateDrawButton( params )
    local root = self.roots[1]
    local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_1")

    Button_1:setTouchEnabled(false)
    Button_1:setBright(false)
    if params ~= nil then
        self.time_text:setVisible(true)
        self.time_text:setString(red_alert_all_str[55])
    else
        if tonumber(self.currProgress[2]) > 0 then
            self.time_text:setVisible(true)
            self.time_text:setString(red_alert_all_str[55])
        elseif tonumber(self.currProgress[1]) >= 100 then
            Button_1:setTouchEnabled(true)
            Button_1:setBright(true)
            self.time_text:setVisible(false)
        elseif self.rest_time <= 0 and tonumber(self.currProgress[1]) >= 10 then
            Button_1:setTouchEnabled(true)
            Button_1:setBright(true)
            self.time_text:setVisible(false)
        end
    end
end

function SevenDaysActivityHelp:onUpdateDraw()
    local root = self.roots[1]
    local activity = _ED.active_activity[42]
    local currProgress = activity.activity_addition_param
    if currProgress == nil or currProgress == "" then
        currProgress = "0,0" -- 当前进度，领取次数
    end
    currProgress = zstring.split(currProgress , ",")
    local currComplete = 0
    for i , v in pairs(activity.seven_days_rewards) do
        if i < 6 then
            local achieveIdS = zstring.splits(dms.string(dms["carnival_mould"] , i ,carnival_mould.achive),"|", ",")
            for j , w in pairs(v.achievement_pages) do
                for k , u in pairs(w._achievement_rewards) do
                    local nowpersent = u.complete_count
                    local maxpersent = 0
                    local achieveId = achieveIdS[j][k]
                    local dailyTaskMould = dms.element(dms["achieve"], achieveId)
                    local param2 = dms.atoi(dailyTaskMould,achieve.param2) 
                    local param3 = dms.atoi(dailyTaskMould,achieve.param3) 
                    if param3 ~= -1 then
                        maxpersent = param3
                    else 
                        maxpersent = param2
                    end
                    if tonumber(u.state) == 1 and tonumber(nowpersent) >= tonumber(maxpersent) then
                        currComplete = currComplete + 1
                    end
                end
            end
        end
    end
    currProgress = currComplete..","..currProgress[2]
    local progressArray = zstring.split(currProgress , ",")
    --进度
    local Text_jd = ccui.Helper:seekWidgetByName(root, "Text_jd")
    Text_jd:setString(progressArray[1].."/100")
    --当前可领
    local Text_dq = ccui.Helper:seekWidgetByName(root, "Text_dq")
    local currNumber = math.floor(tonumber(progressArray[1]) / 10) * 10
    Text_dq:setString(currNumber.."/100")
    --下档可领
    local nextNumber = math.min(currNumber + 10 ,100)
    local Text_xd = ccui.Helper:seekWidgetByName(root, "Text_xd")
    Text_xd:setString(nextNumber.."/100")

    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    LoadingBar_1:setPercent(tonumber(progressArray[1]))
    local Text_title_1 = ccui.Helper:seekWidgetByName(root, "Text_title_1")
    Text_title_1:setString(progressArray[1])
    local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
    local width = LoadingBar_1:getContentSize().width
    Panel_4:setPositionX(Panel_4:getPositionX() + width * tonumber(progressArray[1])/100)

    --需进度达到
    local Text_need = ccui.Helper:seekWidgetByName(root, "Text_need")
    Text_need:setString(string.format(activity_tip_str_info[4], nextNumber))

    self.currProgress = progressArray
    self.rest_time = activity.activity_over_time/1000 + activity.activity_current_time - os.time() - 24 * 3600 + (_ED.system_time - _ED.native_time)*2
    self.time_text = ccui.Helper:seekWidgetByName(root, "Text_time")

    local Panel_props_dh = ccui.Helper:seekWidgetByName(root, "Panel_props_dh")
    Panel_props_dh:removeAllChildren(true)
    local jsonFile = "sprite/sprite_props_light.json"
    local atlasFile = "sprite/sprite_props_light.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    Panel_props_dh:addChild(animation)

    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local achieveIdS = zstring.split(dms.string(dms["carnival_mould"] , 6 ,carnival_mould.achive),",")
    local reward = zstring.split(dms.string(dms["achieve"] , tonumber(achieveIdS[1]) ,achieve.reward_value),",")
    app.load("client.cells.utils.resources_icon_cell")
    local cell = ResourcesIconCell:createCell()
    cell:init(tonumber(reward[1]),tonumber(reward[3]) * 10,tonumber(reward[2]), nil, false, false, true)
    Panel_props_icon:addChild(cell)

    self:updateDrawButton()
end

function SevenDaysActivityHelp:onEnterTransitionFinish()
end

function SevenDaysActivityHelp:onInit( ... )
    local csbSevenDaysActivity = csb.createNode("activity/7days/week_Activities_bangzhu.csb")
    self:addChild(csbSevenDaysActivity)

    local root = csbSevenDaysActivity:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("activity/7days/week_Activities_bangzhu.csb")
    table.insert(self.actions, action)
    csbSevenDaysActivity:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            fwin:close(self)
        end
        
    end)
    
    -- 武将头像的点击事件
    for i = 1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_4_"..i),       nil, 
        {
            terminal_name = "seven_days_activity_show_hero_info",       
            terminal_state = 0, 
            hero_id = _seven_day_activity_reward_hero_ids[i],
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end

    -- 确定的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "seven_days_activity_get_final_reward",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 关闭的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),       nil, 
    {
        terminal_name = "seven_days_activity_help_close",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    self:onUpdateDraw()
end

function SevenDaysActivityHelp:init( params )
    if params ~= nil and params.rootWindow ~= nil then
        self._rootWindows = params.rootWindow
    end
    self:onInit()
    return self
end

function SevenDaysActivityHelp:onExit()
	state_machine.remove("seven_days_activity_help_close")
    state_machine.remove("seven_days_activity_show_hero_info")
    state_machine.remove("seven_days_activity_get_final_reward")
end
