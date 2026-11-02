----------------------------------------------------------------------------------------------------
-- 说明：新服庆典终极奖励界面
-------------------------------------------------------------------------------------------------------

ServiceCarnivalFinalReward = class("ServiceCarnivalFinalRewardClass", Window)
local service_carnival_final_reward_open_terminal = {
    _name = "service_carnival_final_reward_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(ServiceCarnivalFinalReward:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(service_carnival_final_reward_open_terminal)
state_machine.init()

function ServiceCarnivalFinalReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self.rest_time = 0
    -- 当前所处阶段
    self.curStage = 0
    self.time_text = nil

    app.load("client.cells.utils.resources_icon_cell")
    
    local function init_seven_days_activity_help_terminal()

        local service_carnival_get_final_reward_terminal = {
            _name = "service_carnival_get_final_reward",
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

                                fwin:addService({
                                    callback = function ( params )
                                        state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_7happy_page_push")
                                        state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_7happy_day_push")
                                        state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_page_push")
			                            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 182)
                                    end,
                                    delay = 0,
                                })
                            end
                        end

                        local req = {}
                        req.actId = _ED.active_activity[183].activity_id
                        req.actType = 183
                        req.rType = 1
                        req.rDay = 0
                        req.rPage = 0
                        req.rIndex = 0

                        local reqStr = json.encode(req)
                        protocol_command.carnival_n_day.param_list = reqStr
                        NetworkManager:register(protocol_command.carnival_n_day.code, nil, nil, nil, instance, callback, false, nil)

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

        state_machine.add(service_carnival_get_final_reward_terminal)
        state_machine.init()
    end
    
    init_seven_days_activity_help_terminal()
end

-- 当前所处阶段
function ServiceCarnivalFinalReward:getCurStage()
    local finalRewardIdxInfo = self:getFinalRewardInfo()
    local needNumsInfo = {}
    self.curStage = #finalRewardIdxInfo
    for i, v in ipairs(finalRewardIdxInfo) do
        local needNums = dms.int(dms["achieve"], v, achieve.param2)
        if self.totalCount < needNums then
            self.curStage = i - 1
            break
        end
    end
end

function ServiceCarnivalFinalReward:onUpdate(dt)
    if self.rest_time > 0 and self.time_text ~= nil then
        self.rest_time = self.rest_time - dt
        self.time_text:setString(self:getTimeString(self.rest_time).._new_interface_text[298])
        if self.rest_time <= 0 then
            self:updateDrawButton()
        end
    end
end

function ServiceCarnivalFinalReward:getTimeString(_time)
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

function ServiceCarnivalFinalReward:updateDrawButton(params)
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
            if self.curStage < 1 then
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

-- 获取所有任务的总数量
function ServiceCarnivalFinalReward:getAllTaskNumbers()
    local allTaskNums = 0
    for i = 1, 5 do
        local taskIdxStr = dms.string(dms["new_server_carnival"], i, new_server_carnival.taskString)
        local taskIdxInfo = zstring.splits(taskIdxStr, "|", ",")
        for _, v in ipairs(taskIdxInfo) do
            allTaskNums = allTaskNums + table.nums(v)
        end
    end

    return allTaskNums
end

-- 获取最后一天的奖励下标列表
function ServiceCarnivalFinalReward:getFinalRewardInfo()
    local finalIdxStr = dms.string(dms["new_server_carnival"], 6, new_server_carnival.taskString)
    local finalIdxInfo = zstring.split(finalIdxStr, ",", tonumber)

    return finalIdxInfo
end

function ServiceCarnivalFinalReward:getRewardInfoByID(achieveID)
    local rewardStr = dms.string(dms["achieve"], achieveID, achieve.reward_value)
    local rewardInfo = zstring.split(rewardStr, ",", tonumber)

    return rewardInfo
end

function ServiceCarnivalFinalReward:updateDrawProgress(curPercent)
    local root = self.roots[1]

    -- 进度条
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    -- 游标文字
    local Text_title_1 = ccui.Helper:seekWidgetByName(root, "Text_title_1")
    -- 游标位置
    local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")

    LoadingBar_1:setPercent(curPercent)
    Text_title_1:setString(curPercent)
    local width = LoadingBar_1:getContentSize().width
    Panel_4:setPositionX(Panel_4:getPositionX() + width * curPercent / 100)

end

function ServiceCarnivalFinalReward:onUpdateDraw()
    local root = self.roots[1]

    self.time_text = ccui.Helper:seekWidgetByName(root, "Text_time")
    local Text_dq = ccui.Helper:seekWidgetByName(root, "Text_dq")
    local Text_dqkl = ccui.Helper:seekWidgetByName(root, "Text_dqkl")
    local Text_xd = ccui.Helper:seekWidgetByName(root, "Text_xd")
    local Text_xdkl = ccui.Helper:seekWidgetByName(root, "Text_xdkl")
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")

    local activity = _ED.active_activity[183]

    local allTaskNums = self:getAllTaskNumbers()
    local curPercent = math.floor(self.totalCount / allTaskNums * 100)

    local finalRewardIdxInfo = self:getFinalRewardInfo()
    local allRewardStage = #finalRewardIdxInfo
    local finalAchieveID = finalRewardIdxInfo[allRewardStage]
    local rewardInfo = self:getRewardInfoByID(finalAchieveID)
    -- 最大可获得奖励数量
    local maxRewardNums = rewardInfo[3] 

    -- 当前可领
    local curAchieveID = finalRewardIdxInfo[self.curStage]
    local curNumber = self.curStage == 0 and 0 or self:getRewardInfoByID(curAchieveID)[3]
    Text_dq:setString(curNumber .. "/" .. maxRewardNums)
    
    -- 当前阶段
    local curStageStr = string.format(tipStringInfo_service_sevenday_type_name[4], self.curStage * 10)
    Text_dqkl:setString(curStageStr)

    -- 下档可领
    local nextProStage = math.min(self.curStage + 1, allRewardStage)
    local nextAchieveID = finalRewardIdxInfo[nextProStage]
    local nextNumber = self:getRewardInfoByID(nextAchieveID)[3]
    Text_xd:setString(nextNumber .. "/" .. maxRewardNums)

    -- 下档阶段
    local nextStageStr = string.format(tipStringInfo_service_sevenday_type_name[5], nextProStage * 10)
    Text_xdkl:setString(nextStageStr)

    -- 时间
    local current = _ED.system_time + (os.time() - _ED.native_time)
    self.rest_time = activity.end_time / 1000  - current - 1 * 24 * 60 * 60

    -- 奖励图标
    Panel_props_icon:removeAllChildren(true)
    local cell = ResourcesIconCell:createCell()
    cell:init(tonumber(rewardInfo[1]), tonumber(rewardInfo[3]), tonumber(rewardInfo[2]), nil, false, false, true)
    Panel_props_icon:addChild(cell)

    self:updateDrawButton()
    self:updateDrawProgress(curPercent)
end

function ServiceCarnivalFinalReward:onEnterTransitionFinish()
end

function ServiceCarnivalFinalReward:onInit( ... )
    local csbSevenDaysActivity = csb.createNode("activity/service_carnival/service_carnival_final_reward.csb")
    self:addChild(csbSevenDaysActivity)

    local root = csbSevenDaysActivity:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("activity/service_carnival/service_carnival_final_reward.csb")
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
        terminal_name = "service_carnival_get_final_reward",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function ServiceCarnivalFinalReward:init(params)
    if params ~= nil and params.rootWindow ~= nil then
        self._rootWindows = params.rootWindow
    end

    self.lastGiftData = _ED.active_activity[183].activity_Info[tonumber(_ED.active_activity[183].activity_count)].activityInfo_reward_select
    -- print("终极奖励" .. self.lastGiftData)

    local userStr = _ED.active_activity[183].activity_params
    local userData = json.decode(userStr)

    -- 当前任务进度
    self.totalCount = tonumber(userData.totalCount)
    -- 是否领取终极奖励，0未，1已领取
    self.rewardTotalCount = tonumber(userData.rewardTotalCount)

    self:getCurStage()
    self:onInit()
    return self
end

function ServiceCarnivalFinalReward:onExit()
    state_machine.remove("service_carnival_get_final_reward")
end
