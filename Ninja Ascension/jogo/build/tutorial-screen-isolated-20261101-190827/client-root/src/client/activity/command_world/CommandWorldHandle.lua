--[[
	号令天下活动数据处理类
--]]
CommandWorldHandle = CommandWorldHandle or {}

-- 获得跑马灯信息
function CommandWorldHandle.getCommandWorldRunHorseInfo()
	local runHorseInfo = _ED.active_activity[174].runHorseInfo or {}
	return runHorseInfo
end

-- 获得公会积分等级信息
function CommandWorldHandle.getCommandWorldUnionScoreRewardInfo()
	local unionScoreRewardInfo = _ED.active_activity[174].unionScoreRewardInfo or {}
	return unionScoreRewardInfo
end

-- 获得任务信息
function CommandWorldHandle.getCommandWorldTaskInfo()
	local taskInfo = _ED.active_activity[174].taskInfo or {}
	return taskInfo
end

-- 返回号令天下商店信息
function CommandWorldHandle.getCommandWorldShopInfo()
	local shopInfo = _ED.active_activity[174].shopInfo or {}
	return shopInfo
end

-- 清空排行信息
function CommandWorldHandle.clearCommandWorldRankInfo()
	_ED.active_activity[174].rankInfo = {myRankNumber = -1, myselfScore = 0, allRankInfo = {}}
end

-- 返回号令天下排行信息
function CommandWorldHandle.getCommandWorldRankInfo()
	local rankInfo = _ED.active_activity[174].rankInfo or {}
	return rankInfo
end

-- 获得荣耀榜信息
function CommandWorldHandle.getCommandWorldGloryInfo()
	local gloryInfo = _ED.active_activity[174].gloryInfo or {}
	return gloryInfo
end

-- 获得所有奖励信息
function CommandWorldHandle.getCommandWorldAllRewardsInfo()
	local allRewardsInfo = _ED.active_activity[174].allRewardsInfo or {}
	return allRewardsInfo
end

-- 获得本服/跨服排行结束时间信息
function CommandWorldHandle.getCommandWorldEndTimeInfo()
	local serverEndTime = _ED.active_activity[174].serverEndTime or {}
	return serverEndTime
end

-----
-- 获得公会积分奖励信息
function CommandWorldHandle.getCommandWorldUnionScoreRewardsInfo(level)
	local result = {}
	local unionLevelReward = CommandWorldHandle.getCommandWorldAllRewardsInfo().unionLevelReward
	
	local tempStr = unionLevelReward[""..level]
	if tempStr then
		result = zstring.splits(tempStr, "|", ",")
	end
	return result
end

-- 获得活跃任务奖励信息
function CommandWorldHandle.getCommandWorldTaskRewardsInfo(taskId)
	local result = {}
	local taskRewardJSON = CommandWorldHandle.getCommandWorldAllRewardsInfo().taskRewardJSON
		
	if taskRewardJSON then
		for _, v in pairs(taskRewardJSON) do
			if tonumber(v.taskId) == taskId then
				result = zstring.splits(v.reward, "|", ",")
				break
			end
		end
	end
	return result
end

-- 获得号令忍界排行榜数量
function CommandWorldHandle.getCommandWorldRankCount(isCrossServer)
	local data = isCrossServer and CommandWorldHandle.getCommandWorldAllRewardsInfo().crossServerPersonalRewardJSON or CommandWorldHandle.getCommandWorldAllRewardsInfo().singleServerPersonalRewardJSON
	local result = {}

	for _, v in pairs(data) do
		table.insert(result, v)
	end

	return #result
end

-- 获得本服排行榜个人奖励信息
function CommandWorldHandle.getCommandWorldSingleServerPersonRankRewardsInfo(rank)
	local result = {}
	local singleServerPersonalRewardJSON = CommandWorldHandle.getCommandWorldAllRewardsInfo().singleServerPersonalRewardJSON
	
	local tempStr = singleServerPersonalRewardJSON[""..rank]
	if tempStr then
		result = zstring.splits(tempStr.reward, "|", ",")
	end
	return result
end

-- 获得本服排行工会奖励信息
function CommandWorldHandle.getCommandWorldSingleServerUnionRankRewardsInfo(rank)
	local result = {}
	local singleServerUnionRewardJSON = CommandWorldHandle.getCommandWorldAllRewardsInfo().singleServerUnionRewardJSON
	
	local tempStr = singleServerUnionRewardJSON[""..rank]
	if tempStr then
		result = zstring.splits(tempStr.reward, "|", ",")
	end
	return result
end

-- 获得跨服排行榜个人奖励信息
function CommandWorldHandle.getCommandWorldCrossServerPersonRankRewardsInfo(rank)
	local result = {}
	local crossServerPersonalRewardJSON = CommandWorldHandle.getCommandWorldAllRewardsInfo().crossServerPersonalRewardJSON
	
	local tempStr = crossServerPersonalRewardJSON[""..rank]
	if tempStr then
		result = zstring.splits(tempStr.reward, "|", ",")
	end
	return result
end

-- 获得跨服排行全服奖励信息
function CommandWorldHandle.getCommandWorldCrossServerRankRewardsInfo(rank)
	local result = {}
	local singleServerRewardJSON = CommandWorldHandle.getCommandWorldAllRewardsInfo().singleServerRewardJSON
	
	local tempStr = singleServerRewardJSON[""..rank]
	if tempStr then
		result = zstring.splits(tempStr.reward, "|", ",")
	end
	return result
end

-- 根据商店类型获得对应商店信息
function CommandWorldHandle.getCommandWorldShopInfoByType(tabType)
	local shopInfo = CommandWorldHandle.getCommandWorldShopInfo()
	local result = {}
	if tabType == 1 then
		result = shopInfo.advanceExchange
	elseif tabType == 2 then
		result = shopInfo.normalExchange
	elseif tabType == 3 then
		result = shopInfo.goldExchange
	end
	return result
end

-- 获得我的排名和积分
function CommandWorldHandle.getCommandWorldMyRankInfo()
	local info = CommandWorldHandle.getCommandWorldRankInfo()
	return {myRankNumber = tonumber(info.myRankNumber), myselfScore = tonumber(info.myselfScore)}
end

-- 获得排行榜信息
function CommandWorldHandle.getCommandWorldAllRankInfo()
	local info = CommandWorldHandle.getCommandWorldRankInfo()
	return info.allRankInfo
end

-- 获得排行榜前三名信息
function CommandWorldHandle.getCommandWorldRankInfoByRank(rank)
	local info = CommandWorldHandle.getCommandWorldAllRankInfo()

	return info[rank]
end

-- 获得本服排行结束时间
function CommandWorldHandle.getCommandWorldSingleServerEndTime()
	local info = CommandWorldHandle.getCommandWorldEndTimeInfo()
	return info.localEndTime
end

-- 获得跨服排行结束时间
function CommandWorldHandle.getCommandWorldCrossServerEndTime()
	local info = CommandWorldHandle.getCommandWorldEndTimeInfo()
	return info.crossEndTime
end

-- 获得活动立绘Id
function CommandWorldHandle.getCommandWorldBgImgId()
	local info = CommandWorldHandle.getCommandWorldEndTimeInfo()
	return tonumber(info.pictureId)
end

-- 获得活动结束时间
function CommandWorldHandle.getCommandWorldActivityEndTime()
	local end_time = _ED.active_activity[174].end_time
	return end_time
end

-- 根据排名获得荣耀榜信息
-- rank_type 1 本服榜  2 跨服榜
function CommandWorldHandle.getCommandWorldGloryInfoByRank(rank_type , rank)
	local gloryInfo = CommandWorldHandle.getCommandWorldGloryInfo()
	local crossGloryRankInfo = gloryInfo.crossGloryRankInfo
	local selfGloryRankInfo = gloryInfo.selfGloryRankInfo
	local gloryRankInfo = nil
	if rank_type == 1 then
		if selfGloryRankInfo ~= nil then
			gloryRankInfo = selfGloryRankInfo
		end
	elseif rank_type == 2 then
		if crossGloryRankInfo ~= nil then
			gloryRankInfo = crossGloryRankInfo
		end
	end

	local result = {}
	for _, v in pairs(gloryRankInfo) do
		if tonumber(v.rankNumber) > 0 then
			table.insert(result, v)
		end
	end

	table.sort(result, function(a, b)
		return tonumber(a.rankNumber) < tonumber(b.rankNumber)
	end)

	return result[rank]
end

-- 判断荣耀榜是否有人上榜
function CommandWorldHandle.getCommandWorldHaveGloryInfo()
	local result = false
	local gloryInfo = CommandWorldHandle.getCommandWorldGloryInfo()
	local time = CommandWorldHandle.getCommandWorldEndTimeInfo()
	local localEndTime = time.localEndTime
	local crossEndTime = time.crossEndTime
	local diff_localEndTime = difftime(localEndTime)
	local diff_crossEndTime = difftime(crossEndTime)

	if gloryInfo ~= nil then
		local rank_info_arr = {}

		local gloryRankInfo = nil
		
		if diff_localEndTime < 0 and diff_crossEndTime >= 0 then
			if gloryInfo.selfGloryRankInfo ~= nil then
				gloryRankInfo = gloryInfo.selfGloryRankInfo
			end
		end

		if diff_crossEndTime < 0 then
			if gloryInfo.selfGloryRankInfo ~= nil then
				for k,v in pairs(gloryInfo.selfGloryRankInfo) do
					table.insert( rank_info_arr, v)
				end
			end
			
			if gloryInfo.crossGloryRankInfo ~= nil then
				for k,v in pairs(gloryInfo.crossGloryRankInfo) do
					table.insert( rank_info_arr, v)
				end
			end
			
			gloryRankInfo = rank_info_arr
		end

		if gloryRankInfo ~= nil and table.nums(gloryRankInfo) > 0 then
			for _, v in pairs(gloryRankInfo) do
				if v ~=nil then
					if tonumber(v.rankNumber) > 0 then
						result = true
						break
					end
				end
			end
		end
	end

	return result
end

-- 判断金币商店的上忍捐献道具是否卖完
function CommandWorldHandle.getCommandWorldGoldShopHaveBuy()
	local sellOut = true

	local costPropDatas = zstring.splits(dms.string(dms["activity_config"], 76, activity_config.param), "|", ",")
	local highestPropId = tonumber(costPropDatas[3][2])

	local goldShopInfo = CommandWorldHandle.getCommandWorldShopInfoByType(3)
	for _, v in pairs(goldShopInfo) do
		local exchangePropStr = zstring.splits(v.exchangeProp, "|", ",")
		local exchangeProp = exchangePropStr[1]
		local exchangePropId = tonumber(exchangeProp[2])

		if exchangePropId == highestPropId and tonumber(v.currentNumber) == tonumber(v.maxNumber) then
			sellOut = true
			break
		end
	end

	return sellOut
end

-- 是否可领公会积分的奖励
function CommandWorldHandle.getCommandWorldCanGetUniScoreReward()
	local canGet = false
	local index = nil

	local data = CommandWorldHandle.getCommandWorldUnionScoreRewardInfo()

	if data.status then
		local status = zstring.split(data.status, ",")
		for i, v in ipairs(status) do
			if tonumber(v) == 1 then
				canGet = true
				index = i
				break
			end
		end
	end
	return canGet, index
end

-- 2活跃任务，4商店，5荣耀榜 的红点显示
function CommandWorldHandle.getCommandWorldShowRedDotByType(buttonType)
	local isShow = false

	if buttonType == 2 then
		local data = CommandWorldHandle.getCommandWorldTaskInfo()
		for _, v in pairs(data) do
			if tonumber(v.status) == 1 then
				isShow = true
				break
			end
		end
	elseif buttonType == 4 then
		for i = 1, 3 do
			local shopInfo = CommandWorldHandle.getCommandWorldShopInfoByType(i)
			for _, v in pairs(shopInfo or {}) do
				if tonumber(v.currentNumber) ~= tonumber(v.maxNumber) then
					isShow = true
					break
				end
			end
		end
	elseif buttonType == 5 then
		local gloryInfo = CommandWorldHandle.getCommandWorldGloryInfo()
		for _, v in pairs(gloryInfo) do
			if tonumber(v.status) == 1 then
				isShow = true
				break
			end
		end
	end

	return isShow
end

-- 活动外部红点显示
function CommandWorldHandle.getCommandWorldIsShowRedDot()
	local isShow = false

	-- 公会积分奖励红点
	local isShow = CommandWorldHandle:getCommandWorldCanGetUniScoreReward()

	-- 活跃任务
	if isShow == false then
		isShow = CommandWorldHandle.getCommandWorldShowRedDotByType(2)
	end

	-- 商店
	if isShow == false then
		isShow = CommandWorldHandle.getCommandWorldShowRedDotByType(4)
	end

	-- 荣耀榜
	if isShow == false then
		isShow = CommandWorldHandle.getCommandWorldShowRedDotByType(5)
	end

	return isShow
end

-- 玩家是否加入公会
function CommandWorldHandle.getCommandWorldRoleIsInUnion()
	local isInUnion = false

	local myUnionScoreData = CommandWorldHandle.getCommandWorldUnionScoreRewardInfo()
	if myUnionScoreData.unionId ~= nil then
		isInUnion = tonumber(myUnionScoreData.unionId) ~= -1
	end

	return isInUnion
end

