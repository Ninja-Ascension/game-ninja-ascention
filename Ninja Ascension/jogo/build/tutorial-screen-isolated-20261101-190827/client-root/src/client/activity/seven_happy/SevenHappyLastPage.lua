----------------------------------------------------------------------------------------------------
-- 说明：七天乐终极奖励界面
-------------------------------------------------------------------------------------------------------

SevenHappyLastPage = class("SevenHappyLastPageClass", Window)
local seven_days_activity_help_open_terminal = {
    _name = "sevenHappyLastPage_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(SevenHappyLastPage:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_days_activity_help_open_terminal)
state_machine.init()

function SevenHappyLastPage:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self.rest_time = 0
    self.time_text = nil
    self.currProgress = nil

    local function init_seven_days_activity_help_terminal()

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
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd, fwin._ui)
                                if response.node ~= nil then
                                    response.node:updateDrawButton(1)
                                end
                            end
                        end

                        local req = {}
                        req.actId = _ED.active_activity[137].activity_id
                        req.actType = 137
                        req.rType = 1
                        req.rDay = 0
                        req.rPage = 0
                        req.rIndex = 0

                        local reqStr = json.encode(req)
                        protocol_command.reward_happy_n_day.param_list = reqStr
                        NetworkManager:register(protocol_command.reward_happy_n_day.code, nil, nil, nil, instance, callback, false, nil)

                    end
                end

                if tonumber(instance.totalCount) < 100 then
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
        state_machine.init()
    end
    
    init_seven_days_activity_help_terminal()
end

function SevenHappyLastPage:onUpdate(dt)
    if self.rest_time > 0 and self.time_text ~= nil then
        self.rest_time = self.rest_time - dt
        self.time_text:setString(self:getTimeString(self.rest_time).._new_interface_text[298])
        if self.rest_time <= 0 then
            self:updateDrawButton()
        end
    end
end

function SevenHappyLastPage:getTimeString(_time)
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

function SevenHappyLastPage:updateDrawButton(params)
    local root = self.roots[1]
    local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_1")

    Button_1:setTouchEnabled(false)
    Button_1:setBright(false)

    if params ~= nil then
        self.time_text:setVisible(true)
        self.time_text:setString(red_alert_all_str[55])
    else
        -- 已领取
        if self.rewardTotalCount == 1 then
            self.time_text:setVisible(true)
            self.time_text:setString(red_alert_all_str[55])

        elseif self.rest_time <= 0 then
            if self.totalCount < 10 then
                Button_1:setTouchEnabled(false)
                Button_1:setBright(false)
                self.time_text:setString(_new_interface_text[34])
            else
                Button_1:setTouchEnabled(true)
                Button_1:setBright(true)
                self.time_text:setString(_new_interface_text[34])
            end
        end

    end
end

function SevenHappyLastPage:onUpdateDraw()
    local root = self.roots[1]
    local activity = _ED.active_activity[137]

    --当前可领
    local Text_dq = ccui.Helper:seekWidgetByName(root, "Text_dq")
    local currNumber = math.floor(self.totalCount / 10) * 10
    Text_dq:setString(currNumber .. "/100")

    --下档可领
    local nextNumber = math.min(currNumber + 10, 100)
    local Text_xd = ccui.Helper:seekWidgetByName(root, "Text_xd")
    Text_xd:setString(nextNumber .. "/100")

    -- 进度条
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    LoadingBar_1:setPercent(self.totalCount)

    -- 游标文字
    local Text_title_1 = ccui.Helper:seekWidgetByName(root, "Text_title_1")
    Text_title_1:setString(self.totalCount)

    -- 游标位置
    local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
    local width = LoadingBar_1:getContentSize().width
    Panel_4:setPositionX(Panel_4:getPositionX() + width * self.totalCount / 100)

    self.currProgress = progressArray

    -- 时间
    local current = _ED.system_time + (os.time() - _ED.native_time)
    self.rest_time = activity.end_time / 1000 - current - 1 * 24 * 60 * 60
    self.time_text = ccui.Helper:seekWidgetByName(root, "Text_time")

    -- 奖励图标
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local reward = zstring.split(self.lastGiftData, ",")
    app.load("client.cells.utils.resources_icon_cell")
    local cell = ResourcesIconCell:createCell()
    cell:init(tonumber(reward[1]), tonumber(reward[3]), tonumber(reward[2]), nil, false, false, true)
    Panel_props_icon:addChild(cell)

    self:updateDrawButton()
end

function SevenHappyLastPage:onEnterTransitionFinish()
end

function SevenHappyLastPage:onInit( ... )
    local csbSevenDaysActivity = csb.createNode("activity/7days/week_Activities_bangzhu.csb")
    self:addChild(csbSevenDaysActivity)

    local root = csbSevenDaysActivity:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("activity/7days/week_Activities_bangzhu.csb")
    table.insert(self.actions, action)
    csbSevenDaysActivity:runAction(action)
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

    -- 确定的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "seven_days_activity_get_final_reward",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function SevenHappyLastPage:init(params)
    if params ~= nil and params.rootWindow ~= nil then
        self._rootWindows = params.rootWindow
    end

    self.lastGiftData = _ED.active_activity[137].activity_Info[tonumber(_ED.active_activity[137].activity_count)].activityInfo_reward_select
    -- print("终极奖励" .. self.lastGiftData)

    local userStr = _ED.active_activity[137].activity_params
    local userData = json.decode(userStr)

    -- 当前任务进度
    self.totalCount = tonumber(userData.totalCount)

    -- 是否领取终极奖励，0未，1已领取
    self.rewardTotalCount = tonumber(userData.rewardTotalCount)

    self:onInit()
    return self
end

function SevenHappyLastPage:onExit()
    state_machine.remove("seven_days_activity_get_final_reward")
end
