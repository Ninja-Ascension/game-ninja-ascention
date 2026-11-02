
LimSummonMgr = class("LimSummonMgrClass")

function LimSummonMgr:initTemplate()

end

function LimSummonMgr:GetInstance()
    if _ED.limSummon.instance == nil then
        _ED.limSummon.instance = LimSummonMgr:new()
    end

    return _ED.limSummon.instance
end

function LimSummonMgr:Clear()
    _ED.limSummon.instance = nil
end

function LimSummonMgr:ctor()
    self:initTemplate()

    -- 活动状态
    self.enumActivityStatus = 
    {
        Summon = 0,         -- 召唤期
        View = 1,           -- 展示期
        End = 2,            -- 结束期
    }

    -- 购买状态
    self.enumShopItemStatus = 
    {
        unBuy = 0,
        canBuy = 1,
        overBuy = 2,
    }

    -- 同类型的活动列表
    if _ED.limSummon and _ED.limSummon.lstActivity then
        self.lstActivity = _ED.limSummon.lstActivity
    else
        self.lstActivity = {}
    end

    self:parseLocalData()
end

function LimSummonMgr:parseLocalData()
    -- 解析配置表
    self:parseLocalDataConfig()
end

function LimSummonMgr:parseLocalDataConfig()
    -- 最大保底抽数
    self.MaxCountKeepRecruit = dms.int(dms["activity_config"], 118, activity_config.param)
    -- 限时抽奖召唤券道具
    self.sPropDataRecruit = dms.string(dms["activity_config"], 119, activity_config.param)
    -- 召唤券的钻石价格
    self.nPriceRecruit = dms.int(dms["activity_config"], 120, activity_config.param)
    -- 单抽获得的积分道具
    self.sPropDataJifen = dms.string(dms["activity_config"], 121, activity_config.param)
    -- 抽奖记录保存条数
    self.nMaxCountRecord = dms.int(dms["activity_config"], 122, activity_config.param)
    -- 单页记录条数
    self.nPerCountPageRecord = dms.int(dms["activity_config"], 123, activity_config.param)

    -- 十连抽消耗的券数
    self.nCostSummonTen = 10
end

-- 得到当前活动的限定卡
function LimSummonMgr:getUpRewardItem(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return ""
    end

    local activity = _ED.active_activity[idActivity]

    return activity.sPropData
end

-- 得到当前活动的商店内容
function LimSummonMgr:getShopItemLst(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return {}
    end

    local activity = _ED.active_activity[idActivity]

    -- 商店id
    local idShop = activity.idShop

    -- 商店的抽取情况
    local lstShopItemBuyCount = activity.lstShopItemBuyCount

    -- 索引商店表
    local lstDataItem = dms.searchs(dms["time_limit_lottery_shop"], time_limit_lottery_shop.idShop, idShop)

    local curPoints = self:getCountJifen()
    local lstItem = {}
    for i,v in ipairs(lstDataItem) do
        local dataItem = v

        local infoItem = {}
        infoItem.sItem = dms.atos(dataItem, time_limit_lottery_shop.prop)
        infoItem.nLimCount = dms.atoi(dataItem, time_limit_lottery_shop.limCount)
        infoItem.refreshType = dms.atoi(dataItem, time_limit_lottery_shop.refreshType)
        infoItem.exchangeTerms = dms.atos(dataItem, time_limit_lottery_shop.condition)
        infoItem.price = dms.atoi(dataItem, time_limit_lottery_shop.price)
        infoItem.nBuyCount = lstShopItemBuyCount[i] or 0
        infoItem.remain_counts = infoItem.nLimCount - infoItem.nBuyCount
        infoItem.id = i

        infoItem.state = self:getNewShopRecruitmentListState(infoItem.remain_counts, infoItem.exchangeTerms)

        -- 设置商品的状态
        if infoItem.state == 3 then
            infoItem.status = self.enumShopItemStatus.overBuy
        elseif infoItem.state == 0 then
            if curPoints >= infoItem.price then
                infoItem.status = self.enumShopItemStatus.canBuy
            else
                infoItem.status = self.enumShopItemStatus.unBuy
            end
        else
            infoItem.status = self.enumShopItemStatus.unBuy
        end

        table.insert(lstItem, infoItem)
    end

    return lstItem
end

-- 获取商店道具状态   0代表可兑换，1代表没有数码兽，2代表未达到等级，3代表没有兑换次数
function LimSummonMgr:getNewShopRecruitmentListState(remain_counts, exchangeTerms)
	local curLevel = tonumber(_ED.user_info.user_grade)
	if remain_counts == 0 then
		return 3
	else
		local condition = zstring.split(exchangeTerms, "|")
		local propID = tonumber(condition[1])
		if propID ~= -1 then
			if fundShipWidthTemplateId(propID) == nil then
				return 1
			end
		end

		local level = tonumber(condition[2])
		if level and level ~= -1 then
			if tonumber(curLevel) < level then
				return 2
			end
		end
		
	end
	return 0
end

-- 得到当前活动的奖励预览
function LimSummonMgr:getActivityPreviewLst(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return {}
    end

    local activity = _ED.active_activity[idActivity]

    -- 索引保底奖励库
    local lstDataRewardEx = dms.searchs(dms["time_limit_lottery_library_group"], time_limit_lottery_library_group.groupID, activity.idGroupRewardEx, time_limit_lottery_library_group.groupType, 1)

    -- 索引普通奖励库
    local lstDataRewardNormal = dms.searchs(dms["time_limit_lottery_library_group"], time_limit_lottery_library_group.groupID, activity.idGroupRewardNormal, time_limit_lottery_library_group.groupType, 0)

    local allWeight = 0
    local lstPreview = {}
    for i,v in ipairs(lstDataRewardEx) do
        local dataReward = v

        local infoReward = {}
        infoReward.weight = dms.atoi(dataReward, time_limit_lottery_library_group.weightClient)
        infoReward.prop = dms.atos(dataReward, time_limit_lottery_library_group.reward)

        table.insert(lstPreview, infoReward)

        allWeight = allWeight + infoReward.weight
    end

    for i,v in ipairs(lstDataRewardNormal) do
        local dataReward = v

        local infoReward = {}
        infoReward.weight = dms.atoi(dataReward, time_limit_lottery_library_group.weightClient)
        infoReward.prop = dms.atos(dataReward, time_limit_lottery_library_group.reward)
        
        table.insert(lstPreview, infoReward)

        allWeight = allWeight + infoReward.weight
    end

    return lstPreview, allWeight
end

-- 得到当前活动的记录数
function LimSummonMgr:getActivityRecordCount(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return 0
    end

    local activity = _ED.active_activity[idActivity]

    return activity.countRecord
end

-- 得到当前活动的记录
function LimSummonMgr:getActivityRecordLst(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return {}
    end

    local activity = _ED.active_activity[idActivity]

    return activity.lstRecord
end

-- 得到当前活动的时间
function LimSummonMgr:getActivityTime(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return 0
    end

    local activity = _ED.active_activity[idActivity]

    local times = os.time() + _ED.time_add_or_sub

    local surplus_time = 0

    local surplus_time = activity.nTimeRecruitEnd/1000 - times
    if surplus_time > 0 then
        return self.enumActivityStatus.Summon, surplus_time
    end

    local surplus_time = activity.end_time/1000 - times
    if surplus_time > 0 then
        return self.enumActivityStatus.View, surplus_time
    end

    return self.enumActivityStatus.View, 0
end

-- 得到当前活动的立绘
function LimSummonMgr:getMainPic(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return 0
    end

    local activity = _ED.active_activity[idActivity]

    return activity.idBg
end

-- 得到当前活动的Icon
function LimSummonMgr:getIcon(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return 0
    end

    local activity = _ED.active_activity[idActivity]

    return activity.idIcon
end

function LimSummonMgr:noticeRefreshMainReddot()
    for i,v in pairs(self.lstActivity) do
        local idActivity = v
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, idActivity)
    end
end

-- 召唤商店是否有可兑换的数码兽，每日首次登录提醒
function LimSummonMgr:isTipCanBuyShopItem(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return false
    end

    local activity = _ED.active_activity[idActivity]

    local bTip = false
    local lstItem = LimSummonMgr:GetInstance():getShopItemLst(idActivity)
    for i,v in pairs(lstItem) do
        local shopType = tonumber(zstring.split(v.sItem,",")[1])
        if shopType == 13 and v.status == 1 then
            -- 商品是整卡,并且可兑换
            bTip = true
            break
        end
    end

    if bTip then
        -- 检查是否是新的一天
        local key = "lim_summon_can_buy_"..idActivity
        local lastTipTime = readKey(key)
        if lastTipTime == nil or lastTipTime == "" then 
            return true
        end
        local current = _ED.system_time + (os.time() - _ED.native_time)
        local temp = os.date("*t", getBaseGTM8Time(zstring.tonumber(current)))
        local m_hour    = tonumber(string.format("%02d", temp.hour))
        local m_min     = tonumber(string.format("%02d", temp.min))
        local m_sec     = tonumber(string.format("%02d", temp.sec))
    
        local newTimes = m_hour*3600 + m_min*60 + m_sec
        local refreshTime = 5 * 3600
        local oneDaySeconds = 24 * 3600
        local compareTime = oneDaySeconds
        if newTimes < refreshTime then
            compareTime = newTimes - refreshTime + oneDaySeconds
        else
            compareTime = newTimes - refreshTime
        end
    
        if current - lastTipTime >= compareTime then
            return true
        end
    end

    return false
end

function LimSummonMgr:writeTipCanBuyShopItem(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return
    end

    local activity = _ED.active_activity[idActivity]

    local key = "lim_summon_can_buy_"..idActivity

    local current = _ED.system_time + (os.time() - _ED.native_time)

    local sData = ""..current

    writeKey(key, sData)
end

-- 玩家可以十连时
function LimSummonMgr:isTipCanSummonTen(idActivity)
    local state,surplus_time = self:getActivityTime(idActivity)
    if state ~= self.enumActivityStatus.Summon then
        return false
    end

    local countProp = self:getCountPropSummon()

    local money = _ED.user_info.user_gold

    if (countProp + money/self.nPriceRecruit) >= self.nCostSummonTen then
        return true
    end

    return false
end

-- 召唤活动首次出现时
function LimSummonMgr:isTipNewActivity(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return false
    end

    local activity = _ED.active_activity[idActivity]

    local key = "lim_summon_new_activity_info_"..idActivity
    local sInfo = readKey(key)
    if sInfo == nil or sInfo == "" then
        return true
    end

    local timeEnd = zstring.tonumber(sInfo)

    -- 检查活动结束时间是否匹配
    if zstring.tonumber(activity.end_time) ~= timeEnd then
        return true
    end

    -- 检查当前时间记录中的活动是否结束
    local current = _ED.system_time + (os.time() - _ED.native_time)
    if current > timeEnd then
        return true
    end

    return false
end

function LimSummonMgr:writeTipNewActivity(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return
    end

    local activity = _ED.active_activity[idActivity]

    local key = "lim_summon_new_activity_info_"..idActivity

    local sData = ""..activity.end_time

    writeKey(key, sData)
end

-- 得到当前活动的抽取进度
function LimSummonMgr:getSummonProgress(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return 0
    end

    local activity = _ED.active_activity[idActivity]

    return activity.countKeepRecruit
end

-- 得到抽奖券的数量
function LimSummonMgr:getCountPropSummon()
    local lstData = zstring.split(self.sPropDataRecruit, ",", zstring.tonumber)

    local count = zstring.tonumber(getPropAllCountByMouldId(lstData[2]))

    return count
end

-- 得到抽奖券的id
function LimSummonMgr:getIdPropSummon()
    local lstData = zstring.split(self.sPropDataRecruit, ",", zstring.tonumber)

    return lstData[2]
end

function LimSummonMgr:getIdJifen()
    local lstData = zstring.split(self.sPropDataJifen, ",", zstring.tonumber)

    return lstData[2]
end

-- 得到积分的数量
function LimSummonMgr:getCountJifen()
    local lstData = zstring.split(self.sPropDataJifen, ",", zstring.tonumber)

    local count = zstring.tonumber(getPropAllCountByMouldId(lstData[2]))

    return count
end

-- 是否是有效的活动
function LimSummonMgr:isValidActivity(idActivity)
    if _ED.active_activity[idActivity] == nil then
        return false
    end

    return true
end

-- 添加新的活动
function LimSummonMgr:addActivity(idActivity)
    self.lstActivity[idActivity] = idActivity
end

-- 删除新的活动
function LimSummonMgr:removeActivity(idActivity)
    self.lstActivity[idActivity] = nil
end

function LimSummonMgr:getActivityLst()
    local function sortFunc(a, b)
        return a < b
    end
    table.sort(self.lstActivity, sortFunc)
    return self.lstActivity
end

function LimSummonMgr:RequestInit(idActivity, callback, state_machine_lock, instance)
    local function requestCallBack(response)
        if state_machine_lock then
            state_machine.unlock(state_machine_lock)
        end

        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if callback then
                callback()
            end
        end
    end

    if state_machine_lock then
        state_machine.lock(state_machine_lock)
    end

    protocol_command.time_limit_lottery_init.param_list = idActivity
    NetworkManager:register(protocol_command.time_limit_lottery_init.code, nil, nil, nil, nil, requestCallBack, false, nil)
end

-- 抽奖协议
function LimSummonMgr:RequestDraw(idActivity, count, callback, state_machine_lock, instance)
    local function requestCallBack(response)
        if state_machine_lock then
            state_machine.unlock(state_machine_lock)
        end

        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if callback then
                callback()
            end
        end
    end

    if state_machine_lock then
        state_machine.lock(state_machine_lock)
    end
    protocol_command.time_limit_lottery_draw.param_list = idActivity.."\r\n"..count
    NetworkManager:register(protocol_command.time_limit_lottery_draw.code, nil, nil, nil, nil, requestCallBack, false, nil)
end

-- 商店购买
function LimSummonMgr:RequestBuy(idActivity, indexProp, count, callback, state_machine_lock, instance)
    local function requestCallBack(response)
        if state_machine_lock then
            state_machine.unlock(state_machine_lock)
        end

        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if callback then
                callback()
            end
        end
    end

    if state_machine_lock then
        state_machine.lock(state_machine_lock)
    end
    protocol_command.time_limit_lottery_buy.param_list = idActivity.."\r\n"..indexProp.."\r\n"..count
    NetworkManager:register(protocol_command.time_limit_lottery_buy.code, nil, nil, nil, nil, requestCallBack, false, nil)
end

-- 查看抽奖记录
function LimSummonMgr:RequestViewRecord(idActivity, callback, state_machine_lock, instance)
    local function requestCallBack(response)
        if state_machine_lock then
            state_machine.unlock(state_machine_lock)
        end

        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if callback then
                callback()
            end
        end
    end

    if state_machine_lock then
        state_machine.lock(state_machine_lock)
    end
    protocol_command.time_limit_lottery_draw_log.param_list = idActivity
    NetworkManager:register(protocol_command.time_limit_lottery_draw_log.code, nil, nil, nil, nil, requestCallBack, false, nil)
end