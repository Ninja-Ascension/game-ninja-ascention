--[[
	秘境之旅活动数据处理类
--]]

SecretTreasureHandle = SecretTreasureHandle or {}
SecretTreasureHandle._secretData = nil
SecretTreasureHandle._secretRewardData = nil

-- 获得消耗道具的ID，数量
function SecretTreasureHandle.getSecretCostPropID()
	local costPropStr = dms.string(dms["activity_config"], 72, activity_config.param)
	local costPropInfo = zstring.split(costPropStr, ",")

	return tonumber(costPropInfo[2]), tonumber(costPropInfo[3])
end

-- clear
function SecretTreasureHandle.restoreData()
    SecretTreasureHandle._secretData = nil
    SecretTreasureHandle._secretRewardData = nil
end

-- 获得活动数据
function SecretTreasureHandle.getSecretData()
    -- if SecretTreasureHandle._secretData == nil then
        SecretTreasureHandle._secretData = SecretTreasureHandle.handleActivityData()
    -- end
    return SecretTreasureHandle._secretData
end

-- 获得奖励数据
function SecretTreasureHandle.getSecretRewardData()
    -- if SecretTreasureHandle._secretRewardData == nil then
        SecretTreasureHandle._secretRewardData = SecretTreasureHandle.handleActivityRewardData()
    -- end
    return SecretTreasureHandle._secretRewardData
end

-- 解析服务器返回的初始化数据
function SecretTreasureHandle.handleActivityData()
    local secretData = _ED.active_activity[173].secretData

    SecretTreasureHandle._secretData = secretData

    -- debug.print_r(SecretTreasureHandle._secretData, "SecretTreasureHandle._secretData")

    return SecretTreasureHandle._secretData
end

function SecretTreasureHandle.handleActivityRewardData()
    local secretRewardData = _ED.active_activity[173].secretRewardData
    SecretTreasureHandle._secretRewardData = secretRewardData

    -- debug.print_r(SecretTreasureHandle._secretRewardData, "SecretTreasureHandle._secretRewardData")

    return SecretTreasureHandle._secretRewardData
end

-- 获得层数
function SecretTreasureHandle.getSecretFloorNumber()
	local data = SecretTreasureHandle.getSecretData()
	return zstring.tonumber(data.currentTier) + 1
end

-- 获得是否点击开始寻宝 false没开始 true已开始
function SecretTreasureHandle.getSecretGameIsBegin()
	local data = SecretTreasureHandle.getSecretData()
	return data.isBegin
end

-- 获得普通奖励列表对应奖励的领奖状态 0没领取 2已领取
function SecretTreasureHandle.getSecretCommonRewardState(index)
	local data = SecretTreasureHandle.getSecretData()
	local commonRewardStatus = zstring.split(data.commonRewardStatus, "|")
	
	return tonumber(commonRewardStatus[index])
end

-- 获得普通奖励信息
function SecretTreasureHandle.getSecretCommonRewards()
	local data = SecretTreasureHandle.getSecretRewardData()
	local rewards = zstring.splits(data.reward0, "|", ",")

	return rewards
end

-- 获得最终大奖信息
function SecretTreasureHandle.getSecretFinalReward()
	local data = SecretTreasureHandle.getSecretData()
	local rewardInfo = zstring.split(data.currentUltimateReward, ",")
	if table.nums(rewardInfo) >= 3 then
		return rewardInfo
	end
	return nil
end

-- 该牌子是否翻转 28个数据 0未翻牌 2已翻牌 3传送门已翻牌
function SecretTreasureHandle.getSecretCardTurnState(index)
	local data = SecretTreasureHandle.getSecretData()
	local turnState = zstring.split(data.isReversal, "|")

	return tonumber(turnState[index])
end

-- 任务信息
function SecretTreasureHandle.getSecretTaskInfo()
	local data = SecretTreasureHandle.getSecretData()
	return data.taskJson
end

-- 判断当前层是否是特殊层
function SecretTreasureHandle.getSecretIsSpecialFloor()
	local isSpecial = false

	local data = SecretTreasureHandle.getSecretData()
	local curFloor = SecretTreasureHandle.getSecretFloorNumber()

	local specialRewardFloorList = zstring.split(data.specialRewardTier, "|")
	for _, v in pairs(specialRewardFloorList) do
		if curFloor == (tonumber(v) + 1) then
			isSpecial = true
			break
		end
	end
	return isSpecial
end

-- 全部终极奖励的信息
-- return 终极大奖奖励信息 剩余可设置数量 最大可设置数量
function SecretTreasureHandle.getSecretAllNormalFinalRewardsInfo()
	local data = SecretTreasureHandle.getSecretData()
	-- 终极奖励设置剩余次数
	local remainSetCountStr = data.canSetNumber1
	local remainSetCountList = zstring.split(remainSetCountStr, "|")

	-- 选中的终极奖励下标
	local selectRewardIndex = tonumber(data.currentUltimateRewardIndex) + 1
	local canSelect = true
	if SecretTreasureHandle.getSecretIsSpecialFloor() then
		selectRewardIndex = nil
		canSelect = false
	end

	local rewardData = SecretTreasureHandle.getSecretRewardData()
	local dataReward = rewardData.reward1

	local rewardContentList = zstring.splits(dataReward.rewardContent, "|", ",")
	local maxSetCountList = zstring.split(dataReward.canSetNumber, "|")

	local result = {}
	local totalCount = table.nums(rewardContentList)
	for i = 1, totalCount do
		local rewardContent = rewardContentList[i]
		local remainSetCount = tonumber(remainSetCountList[i])
		local maxSetCount = tonumber(maxSetCountList[i])

		local isSelect = false
		if selectRewardIndex and selectRewardIndex == i then
			isSelect = true
		end

		table.insert(result, {index = i, rewardContent = rewardContent, remainSetCount = remainSetCount, maxSetCount = maxSetCount, isSelect = isSelect, canSelect = canSelect})
	end

	-- debug.print_r(result, "全部终极奖励的信息")

	return result
end

-- 全部究极奖励的信息
-- return 究极大奖奖励信息 剩余可设置数量 最大可设置数量
function SecretTreasureHandle.getSecretAllSpecialFinalRewardsInfo()
	local data = SecretTreasureHandle.getSecretData()
	-- 究极奖励设置剩余次数
	local remainSetCountStr = data.canSetNumber2
	local remainSetCountList = zstring.split(remainSetCountStr, "|")

	-- 选中的究极奖励下标
	local selectRewardIndex = tonumber(data.currentUltimateRewardIndex) + 1
	local canSelect = true
	if not SecretTreasureHandle.getSecretIsSpecialFloor() then
		selectRewardIndex = nil
		canSelect = false
	end

	local rewardData = SecretTreasureHandle.getSecretRewardData()
	local dataReward = rewardData.reward2

	local rewardContentList = zstring.splits(dataReward.rewardContent, "|", ",")
	local maxSetCountList = zstring.split(dataReward.canSetNumber, "|")

	local result = {}
	local totalCount = table.nums(rewardContentList)
	for i = 1, totalCount do
		local rewardContent = rewardContentList[i]
		local remainSetCount = tonumber(remainSetCountList[i])
		local maxSetCount = tonumber(maxSetCountList[i])

		local isSelect = false
		if selectRewardIndex and selectRewardIndex == i then
			isSelect = true
		end

		table.insert(result, {index = i, rewardContent = rewardContent, remainSetCount = remainSetCount, maxSetCount = maxSetCount, isSelect = isSelect, canSelect = canSelect})
	end

	-- debug.print_r(result, "全部究极奖励的信息")

	return result
end

-- 能否进入下一层（或者能否更换终极奖励）
function SecretTreasureHandle.canGoToNextFloor()
	local data = SecretTreasureHandle.getSecretData()
	return data.canGoToNext == true
end

-- 当次抽奖是否获取到终极奖励
function SecretTreasureHandle.isGotFinalReward()
	local data = SecretTreasureHandle.getSecretData()
	return data.isWin == true
end

-- 是否所有的牌子都翻完了
function SecretTreasureHandle.getSecretAllCardTurn()
	local data = SecretTreasureHandle.getSecretData()
	local turnState = zstring.split(data.isReversal, "|")

	local isTurnAllCard = true
	for _, v in pairs(turnState) do
		if tonumber(v) == 0 then
			isTurnAllCard = false
			break
		end
	end

	return isTurnAllCard
end