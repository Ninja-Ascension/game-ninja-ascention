-- 彩蛋的逻辑处理
EasterEggHandle = class("EasterEggHandle")
-- 显示轮播指引界面
function EasterEggHandle.showEggGuide(sender)
    if sender.guideCell == nil then
        local activityInfo = _ED.active_activity[191].activity_info
        local curDay = EasterEggHandle.getEasterEggDays()
        local showData = zstring.split(dms.string(dms["activity_config"], 124, activity_config.param), "|")
        local showList = {} -- 配置的轮播列表
        for i, v in ipairs(showData) do
            if i <= curDay then
                local info = zstring.split(v, ",")
                for k, val in ipairs(info) do
                    local item = activityInfo[val..""]
                    if item then 
                        local haveGet = tonumber(item.haveGet)
                        local eggInfo = dms.searchs(dms["easter_event_mould"], easter_egg_mould.ID, item.eventId)[1]
                        local maxGet = tonumber(eggInfo[easter_egg_mould.limit])
                        if haveGet < maxGet then
                            app.load("client.activity.easter_egg.EasterEggGuide")
                            local cell = state_machine.excute("easter_egg_guide_window_open", 0, "")
                            sender:addChild(cell)
                            sender.guideCell = cell
                            return
                        end
                    end
                end
            end
        end
    end
end

-- 彩蛋领奖处理 eventInfo:完成事件信息,格式:事件1,事件2 callBack:回调
function EasterEggHandle.showEasterEggReward(eventInfo, callBack)
    local function requestCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.activity.easter_egg.EasterEggReward")
            local getRewardWnd = EasterEggReward:new()
            getRewardWnd:init(7, eventInfo, callBack)
            fwin:open(getRewardWnd, fwin._dialog)
            _ED.active_activity[191].activity_task = nil
            state_machine.excute("easter_egg_guide_play_refrush", 0, "")
        end
    end
    protocol_command.mysterious_egg_receive_reward.param_list = eventInfo .. ""
    NetworkManager:register(protocol_command.mysterious_egg_receive_reward.code, nil, nil, nil, nil, requestCallBack, false, nil)
end

-- 彩蛋小游戏和任务完成提示 
function EasterEggHandle.showTaskAndSmall()
    local eventInfo = _ED.active_activity[191].activity_task
    local eggData = zstring.split(eventInfo .. "", ",")
    for i, v in ipairs(eggData) do
        local eggInfo = dms.searchs(dms["easter_event_mould"], easter_egg_mould.ID, v)
        if eggInfo then
            local eggType = tonumber(eggInfo[1][easter_egg_mould.type])
            if eggType == 3 then
                local eggSmallType = zstring.split(eggInfo[1][easter_egg_mould.condition], ",")[1]
                if tonumber(eggSmallType) == 62 then
                    -- 摇奖小游戏,需要摇奖结束再请求奖励
                else
                    -- 打开小游戏提示界面
                    app.load("client.activity.easter_egg.EasterEggSmall")
                    state_machine.excute("easter_egg_small_window_open", 0, {eggInfo = eggInfo[1]})
                    -- 其他小游戏直接领奖
                    EasterEggHandle.showEasterEggReward(eventInfo)
                end
                return
            end
        end
    end

    -- 任务型直接领奖
    EasterEggHandle.showEasterEggReward(eventInfo)
end

-- 摇奖游戏请求领奖
function EasterEggHandle.showRequstReward()
    if _ED.active_activity[191] and _ED.active_activity[191].activity_task ~= nil then
        local eggData = zstring.split(_ED.active_activity[191].activity_task .. "", ",")
        for i, v in ipairs(eggData) do
            local eggInfo = dms.searchs(dms["easter_event_mould"], easter_egg_mould.ID, v)
            if eggInfo then
                -- 打开小游戏提示界面
                app.load("client.activity.easter_egg.EasterEggSmall")
                state_machine.excute("easter_egg_small_window_open", 0, {eggInfo = eggInfo[1]})
                EasterEggHandle.showEasterEggReward(_ED.active_activity[191].activity_task)
                return
            end
        end
    end
end

-- 获取活动开始天数
function EasterEggHandle.getEasterEggDays()
    if _ED.active_activity[191] == nil then 
        return 1
    end
    local startTime = _ED.active_activity[191].begin_time / 1000
    local curTime = _ED.system_time + (os.time() - _ED.native_time)
    local cutDay = GetNumberOfDaysInterval(startTime,curTime) + 1
    return cutDay
end
