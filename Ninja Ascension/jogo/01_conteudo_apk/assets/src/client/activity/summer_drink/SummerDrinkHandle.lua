--[[
	夏日酷饮活动数据处理类
--]]

SummerDrinkHandle = SummerDrinkHandle or {}
SummerDrinkHandle.summerDrinkData = nil
SummerDrinkHandle.summerDrinkRewardData = nil

-- clear
function SummerDrinkHandle.restoreSummerDrinkData()
    SummerDrinkHandle.summerDrinkData = nil
    SummerDrinkHandle.summerDrinkRewardData = nil
end

-- 获得活动数据
function SummerDrinkHandle.getSummerDrinkData()
    if SummerDrinkHandle.summerDrinkData == nil then
        SummerDrinkHandle.summerDrinkData = SummerDrinkHandle.handleActivityData()
    end
    return SummerDrinkHandle.summerDrinkData
end

-- 获得任务奖励数据
function SummerDrinkHandle.getSummerDrinkRewardData()
    if SummerDrinkHandle.summerDrinkRewardData == nil then
        SummerDrinkHandle.summerDrinkRewardData = SummerDrinkHandle.handleActivityRewardData()
    end
    return SummerDrinkHandle.summerDrinkRewardData
end

-- 解析服务器返回的初始化数据
function SummerDrinkHandle.handleActivityData()
    local result = {}

    local summerDrinkData = _ED.active_activity[172].summerDrinkData
    for _, v in ipairs(summerDrinkData) do
        local index = tonumber(v.i) + 1
        local data = {
            totalProgress = tonumber(v.tp),
            curProgress = tonumber(v.cp),
            isReward = tonumber(v.flag) -- 领奖状态（0不可领取，1可领取，2已领取）
        }
        -- 如果成就ID存在
        if tonumber(v.n)then
            data.achieveID = tonumber(v.n)
        end
        result[index] = data
    end

    SummerDrinkHandle.summerDrinkData = result

    -- debug.print_r(SummerDrinkHandle.summerDrinkData, "SummerDrinkHandle.summerDrinkData")

    return SummerDrinkHandle.summerDrinkData
end

function SummerDrinkHandle.handleActivityRewardData()
    local result = {}

    local summerDrinkRewardData = _ED.active_activity[172].summerDrinkRewardData
    for _, v in ipairs(summerDrinkRewardData) do
        local tempStr = zstring.splits(v, "|", ",")

        table.insert(result, tempStr)
    end

    SummerDrinkHandle.summerDrinkRewardData = result

    -- debug.print_r(SummerDrinkHandle.summerDrinkRewardData, "SummerDrinkHandle.summerDrinkRewardData")

    return SummerDrinkHandle.summerDrinkRewardData
end

-- 是否可领奖（用于入口红点）
function SummerDrinkHandle.canGetReward()
    local redDotFlag = false
    local data = SummerDrinkHandle.handleActivityData()
    for _, v in pairs(data) do
        if v.isReward == 1 then
            redDotFlag = true
            break
        end
    end
    return redDotFlag
end

-- 获得某个任务是否可领取 领奖状态（0不可领取，1可领取，2已领取）
function SummerDrinkHandle.getTaskRewardState(index)
    local data = SummerDrinkHandle.getSummerDrinkData()
    return data[index].isReward
end

-- 获得任务奖励内容
function SummerDrinkHandle.getTaskReward(index)
    local data = SummerDrinkHandle.getSummerDrinkRewardData()
    return data[index]
end

-- 人物图片下标
function SummerDrinkHandle.getHeadIndex(mouldId)
    local temp_bust_index = nil
     --进化形象
    local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
    
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = nil
    evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
    local baseShip = fundShipWidthTemplateId(mouldId)
    if baseShip ~= nil then
        local ship_evo = zstring.split(baseShip.evolution_status, "|")
        evo_mould_id = smGetSkinEvoIdChange( baseShip )
    end
    --新的形象编号
    temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

    return temp_bust_index
end