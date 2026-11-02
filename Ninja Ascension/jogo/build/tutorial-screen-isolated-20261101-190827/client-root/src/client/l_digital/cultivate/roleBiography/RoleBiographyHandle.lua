--[[
	忍列传数据处理类
--]]

RoleBiographyHandle = RoleBiographyHandle or {}

RoleBiographyHandle.totalPropertyData = nil

-- 获得所有激活的忍列传数据
function RoleBiographyHandle.getAllBiographyInfo()
    local info = {}

    local allInfo = _ED.all_biographies_info or {}

    for _, v in pairs(allInfo) do
        info[tonumber(v.biographiesMouldId)] = tonumber(v.biographiesStar)
    end

    return info
end

-- 获得成就数据
function RoleBiographyHandle.getBiographyAchieveInfo()
    return _ED.biographies_achieve_info or {}
end

-- 获得篇章数据
function RoleBiographyHandle.getBiographyChapterInfo()
    return _ED.biographies_chapter_info or {}
end

-- 获得抽奖数据
function RoleBiographyHandle.getBiographyDrawInfo()
    return _ED.biographies_draw_info or {}
end

-- 获得奖励预览数据
function RoleBiographyHandle.getBiographyDrawRewardsInfo()
    local result = {}

    local normalRewards = zstring.splits(_ED.biographies_draw_rewards_info.normal, "|", ",")

    for _, v in pairs(normalRewards) do
        table.insert(result, v)
    end

    local advanceRewards = zstring.splits(_ED.biographies_draw_rewards_info.advance, "|", ",")
    for _, v in pairs(advanceRewards) do
        table.insert(result, v)
    end

    return result
end

-- 获得排行榜数据
function RoleBiographyHandle.getBiographyRankInfo()
    local rankInfo = _ED.biographies_rank_info

    local allRankInfo = rankInfo.allRankInfo
    if allRankInfo then
        table.sort(allRankInfo, function (a, b)
            return tonumber(a.rankNumber) < tonumber(b.rankNumber)
        end)
    end

    return allRankInfo or {}
end

--获得我的排行榜排名
function RoleBiographyHandle.getBiographyMyRank()
    local rankInfo = _ED.biographies_rank_info

    return tonumber(rankInfo.myRankNumber) or -1
end

-- 获取章节是否开启/升星功能是否开启
function RoleBiographyHandle.getChapterLockState(chapterId)
    local unlock, canAdvance = false, false

    local info = RoleBiographyHandle.getBiographyChapterInfo()
    for _, v in pairs(info) do
        if (tonumber(v.index) + 1) == chapterId then
            unlock = tonumber(v.unlock) == 1
            canAdvance = tonumber(v.canAdvance) == 1
            break
        end
    end
    return unlock, canAdvance
end

function RoleBiographyHandle.getBiographyActivateCountByChapterId(chapterId)
    local acitvateCount = 0

    local info = RoleBiographyHandle.getAllBiographyInfo()
    for biographyId in pairs(info) do
        local id = dms.int(dms["biographies_mould"], biographyId, biographies_mould.chapterId)
        if id == chapterId then
            acitvateCount = acitvateCount + 1
        end
    end

    local maxCount = #RoleBiographyHandle.getBiographiesByChapterId(chapterId)

    return acitvateCount, maxCount
end

function RoleBiographyHandle.getBiographyIsActivate(biographyId)
    local isActivate = false
    local info = RoleBiographyHandle.getAllBiographyInfo()
    if info[biographyId] then
        isActivate = true
    end

    return isActivate
end

-- 当前是否满星
function RoleBiographyHandle.getIsMaxStar(biographyId)
    local star = RoleBiographyHandle.getAllBiographyInfo()[biographyId]
    
    -- 表里是从 0-8 所以最后要减1
    local maxStar = 0

    local data = dms.searchs(dms["biographies_star_mould"], biographies_star_mould.biographies_mould_id, biographyId)
    if data ~= nil then
        maxStar = table.nums(data)
    end

    return star == (maxStar - 1)
end

--是否可升星
function RoleBiographyHandle.getBiographyCanLevelUp(biographyId)
	-- 是否启用一键合成
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.RoleBiographyCompose)

    local canNormalLevelUp = nil            -- 可正常升星
    local canComposeLevelUp = false         -- 合成可升星

    -- 满足章节升星开启条件
    local chapterId = dms.int(dms["biographies_mould"], biographyId, biographies_mould.chapterId)
    local _, canAdvance = RoleBiographyHandle.getChapterLockState(chapterId)


    -- print("是否可升星 canAdvance = ", canAdvance)

    -- 满足道具消耗
    local haveEnoughProp = false
    local costStr = RoleBiographyHandle.getUpLevelCostById(biographyId)
    if costStr then
        local cost = zstring.splits(costStr, "|", ",")
        for _, v in ipairs(cost) do
            local haveCount = tonumber(getPropAllCountByMouldId(v[2]))
            if haveCount >= tonumber(v[3]) then
                if canNormalLevelUp == nil then
                    canNormalLevelUp = true
                end
            else
                if fun_is_open then
                    canComposeLevelUp = RoleBiographyHandle.getCurImprintComposeIsEnough(v)
                end

                canNormalLevelUp = false
                if canNormalLevelUp == false and canComposeLevelUp == false then
                    break
                end
            end
        end
    end
    canNormalLevelUp = canNormalLevelUp and canAdvance
    canComposeLevelUp = canComposeLevelUp and canAdvance

    return canNormalLevelUp, canComposeLevelUp
end

--是否可激活
function RoleBiographyHandle.getBiographyCanActivte(biographyId)
	-- 是否启用一键合成
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.RoleBiographyCompose)
    local canNormalActivate = nil           -- 可正常激活
    local canComposeActivate = false        -- 合成可激活

    local isActivate = RoleBiographyHandle.getBiographyIsActivate(biographyId)

    if isActivate == false then
        local signetCostStr = dms.string(dms["biographies_mould"], biographyId, biographies_mould.signet_cost)
        local signetCost = zstring.splits(signetCostStr, "|", ",")

        for _, v in ipairs(signetCost) do
            local haveCount = tonumber(getPropAllCountByMouldId(v[2]))
            if haveCount >= tonumber(v[3]) then
                if canNormalActivate == nil then
                    canNormalActivate = true
                end
            else
                if fun_is_open then
                    canComposeActivate = RoleBiographyHandle.getCurImprintComposeIsEnough(v)
                end
                canNormalActivate = false
                if canComposeActivate == false and canNormalActivate == false then
                    break
                end
            end
        end
    end


    return canNormalActivate, canComposeActivate
end

-- 获取当前成就值
function RoleBiographyHandle.getCurAchievementValue()
    local info = RoleBiographyHandle.getBiographyAchieveInfo()

    return tonumber(info.totalAchieveNumber)
end

-- 获取该印记是否属于奖励库里的
function RoleBiographyHandle.getPropIsInRewards(propId)
    local result = false

    local info = RoleBiographyHandle.getBiographyDrawRewardsInfo()
    for _, v in ipairs(info) do
        local id = tonumber(v[2])
        if propId == id then
            result = true
            break
        end
    end
    
    return result
end

-- =================
-- 篇章红点
function RoleBiographyHandle.showChapterDotByChapterId(chapterId)
    local isShow = false

    if RoleBiographyHandle.getChapterLockState(chapterId) == true then
        local biographies = RoleBiographyHandle.getBiographiesByChapterId(chapterId)
        for _, v in pairs(biographies) do
            local biographyId = dms.atof(v, biographies_mould.id)
            -- print("biographyId = ", biographyId)
            isShow = RoleBiographyHandle.showDotByBiographyId(biographyId)

            if isShow == true then
                break
            end
        end
    end

    return isShow
end

-- 列传红点
function RoleBiographyHandle.showDotByBiographyId(biographyId)
    local isShow = false
    local canActivate, canComposeActivate = RoleBiographyHandle.getBiographyCanActivte(biographyId)
    -- print("canActivate = ", canActivate)
    if canActivate == true or canComposeActivate == true then
        isShow = true
    end

    if isShow == false then
        local canUpLevel, canComposeLevelUp = RoleBiographyHandle.getBiographyCanLevelUp(biographyId)
        -- print("canUpLevel = ", canUpLevel)
        if canUpLevel == true or canComposeLevelUp == true then
            isShow = true
        end
    end

    return isShow
end

-- 成就按钮红点
function RoleBiographyHandle.showAchieveDot()
    local isShow = false

    local curValue = tonumber(RoleBiographyHandle.getCurAchievementValue())
    if curValue == nil then return false end
    for _, v in pairs(dms["biographies_achieve"]) do
        local id = dms.atof(v, biographies_achieve.id)
        -- 是否解锁
        local condition_1 = RoleBiographyHandle.getAchievementIsUnlock(id)
        local selectValue = dms.atof(v, biographies_achieve.achievementValue)
        -- 成就值是否达到
        local condition_2 = tonumber(selectValue) ~= nil and curValue >= tonumber(selectValue)

        local canActivate = (not condition_1) and condition_2
        -- print("成就值是否达到 canActivate = ", canActivate)
        if canActivate then
            isShow = true
            break
        end
    end

    return isShow
end

-- 忍列传养成红点
-- 当玩家有忍列传可以激活时,需要红点提示
-- 当玩家忍列传成就就可以激活时,需要红点提示
-- 当玩家忍列传可以升星时,需要红点提示
function RoleBiographyHandle.isShowRoleBiographyRedDot()
    local isShow = false

    for _, v in pairs(dms["biographies_section_mould"]) do
        local chapterId = dms.atof(v, biographies_section_mould.id)
        isShow = RoleBiographyHandle.showChapterDotByChapterId(chapterId)
        if isShow == true then
            break
        end
    end

    if not isShow then
        isShow = RoleBiographyHandle.showAchieveDot()
    end

    -- print("isShow = ", isShow)

    return isShow
end

-- 根据章节Id获取数据表的列传数据
function RoleBiographyHandle.getBiographiesByChapterId(chapterId)
    local result = {}

    local biographyDatas = dms["biographies_mould"]
    for i, v in ipairs(biographyDatas) do
        local id = dms.atof(v, biographies_mould.chapterId)
        if id == chapterId then
            table.insert(result, v)
        end
    end

    return result
end

-- 根据印记道具id 查找可以组合成的列传
function RoleBiographyHandle.getAllBiographyDatasByPropId(propId)
    local result = {}

    local biographyDatas = dms["biographies_mould"]
    for i, v in ipairs(biographyDatas) do
        local signetCostStr = dms.atos(v, biographies_mould.signet_cost)
        local signetCost = zstring.splits(signetCostStr, "|", ",")

        for _, cost in ipairs(signetCost) do
            local id = tonumber(cost[2])
            if id == propId then
                local biographyId = dms.atof(v, biographies_mould.id)
                table.insert(result, v)
            end
        end
    end

    return result
end

-- 获取章节数据
function RoleBiographyHandle.getChapterDatas()
    local chapterDatas = dms["biographies_section_mould"]
    return chapterDatas
end

-- 获取下一级成就名称
function RoleBiographyHandle.getNextActivateAchieveName()
    local nextId = -1

    local info = RoleBiographyHandle.getBiographyAchieveInfo()
    local achieveStatus = zstring.split(info.achieveStatusInfo or "", ",")
    for id, status in ipairs(achieveStatus) do
        if tonumber(status) == 0 then
            nextId = id
            break
        end
    end

    local name = nil
    if nextId ~= -1 then
        local name_mould_id = dms.int(dms["biographies_achieve"], nextId, biographies_achieve.name)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        name = word_info[3]
    end

    return name
end

-- 根据列传id 获取下一级升星消耗
function RoleBiographyHandle.getUpLevelCostById(biographyId)
    local cost = nil
    local curStar = RoleBiographyHandle.getAllBiographyInfo()[biographyId]
    if curStar then
        local data = dms.searchs(dms["biographies_star_mould"], biographies_star_mould.biographies_mould_id, biographyId, biographies_star_mould.star, curStar + 1)
        if data ~= nil and data[1] ~= nil then
            cost = dms.atos(data[1], biographies_star_mould.costProp)
        end
    end
    return cost
end

-- 根据列传id 获取下一级升星属性
function RoleBiographyHandle.getUpLevelPropertyById(biographyId)
    local property_add = nil
    local curStar = RoleBiographyHandle.getAllBiographyInfo()[biographyId]
    -- print("获取下一级升星属性 curStar = ", curStar)
    if curStar then
        local data = dms.searchs(dms["biographies_star_mould"], biographies_star_mould.biographies_mould_id, biographyId, biographies_star_mould.star, curStar + 1)
        if data ~= nil and data[1] ~= nil then
            property_add = dms.atos(data[1], biographies_star_mould.property_add)
        end
    end
    -- debug.print_r(property_add)
    return property_add
end

-- 根据列传id 获取当前等级升星属性
function RoleBiographyHandle.getCurUpLevelPropertyById(biographyId)
    local property_add = nil
    local curStar = RoleBiographyHandle.getAllBiographyInfo()[biographyId]
    if curStar then
        local data = dms.searchs(dms["biographies_star_mould"], biographies_star_mould.biographies_mould_id, biographyId, biographies_star_mould.star, curStar)
        if data ~= nil and data[1] ~= nil then
            property_add = dms.atos(data[1], biographies_star_mould.property_add)
        end
    end
    -- debug.print_r(property_add)
    return property_add
end

-- 获取当前区间内成就的进度
function RoleBiographyHandle.getAchievementAddValue()
    local curValue = RoleBiographyHandle.getCurAchievementValue()

    local curAchievementId = nil

    local curProgressValue = 0
    local maxProgressValue = 0

    local maxAchievementId = dms.count(dms["biographies_achieve"])
    local maxValue = dms.int(dms["biographies_achieve"], maxAchievementId, biographies_achieve.achievementValue)

    -- print(maxAchievementId, maxValue)
    if curValue >= maxValue then
        local preValue = 0
        local preAchievementId = maxAchievementId - 1
        if preAchievementId > 0 then
            local preData = dms.element(dms["biographies_achieve"], preAchievementId)
            preValue = dms.atof(preData, biographies_achieve.achievementValue)
        else
            preValue = 0
        end

        maxProgressValue = maxValue - preValue
        curProgressValue = maxValue - preValue

        curAchievementId = nil
    else
        local biographiesAchieveDatas = dms["biographies_achieve"]
        for _, v in ipairs(biographiesAchieveDatas) do
            local value = dms.atof(v, biographies_achieve.achievementValue)
            if curValue < value then
                local preValue = 0
                curAchievementId = dms.atof(v, biographies_achieve.id)

                local preAchievementId = curAchievementId - 1
                if preAchievementId > 0 then
                    local preData = dms.element(dms["biographies_achieve"], preAchievementId)
                    preValue = dms.atof(preData, biographies_achieve.achievementValue)
                else
                    preValue = 0
                end

                maxProgressValue = value - preValue
                curProgressValue = curValue - preValue
                break
            end
        end
    end

    return curAchievementId, curProgressValue, maxProgressValue
end

-- 创建多边形印记icon
function RoleBiographyHandle.addSpecialIconCell(propData, canTouch, isShowHave)
    local propId = tonumber(propData[2])
    -- print("propId = ", propId)
    local cell = state_machine.excute("role_biography_icon_cell_create", 0, {propId = propId, canTouch = canTouch, isShowHave = isShowHave})
    return cell
end

-- 属性控件colorType 1白色 colorType 2属性总览红色 3成就白色 4激活列传成功黄色 5升星成功红色
function RoleBiographyHandle.addPropertyCell(propertyDatas, colorType)
    local data = {}
    for _, v in ipairs(propertyDatas) do
       table.insert(data, v)
    end

    local cell = nil
    if colorType == 1 then
        cell = state_machine.excute("role_biography_property_cell_1_create", 0, data)
    elseif colorType == 2 then
        cell = state_machine.excute("role_biography_property_cell_2_create", 0, data)
    elseif colorType == 3 then
        cell = state_machine.excute("role_biography_property_cell_3_create", 0, data)
    elseif colorType == 4 then
        cell = state_machine.excute("role_biography_property_cell_4_create", 0, data)
    elseif colorType == 5 then
        cell = state_machine.excute("role_biography_property_cell_5_create", 0, data)
    end
   
    return cell
end

-- 清除总属性
function RoleBiographyHandle.clearTotalPropertyData()
    RoleBiographyHandle.totalPropertyData = nil
end

-- 总属性
function RoleBiographyHandle.getTotalPropertyData()
    if RoleBiographyHandle.totalPropertyData ~= nil then
        return RoleBiographyHandle.totalPropertyData
    end

    local totalData = {}

    local function addPropertyValue(property_add)
        for _, v in pairs(property_add) do
            local propertyType = tonumber(v[1])
            local propertyValue = tonumber(v[2])

            totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
        end
    end

    -- local time1 = os.clock()
    -- print("time1 = ", time1)
    -- 列传激活属性 + 列传升星属性
    local biographyInfo = RoleBiographyHandle.getAllBiographyInfo()
    for biographyId, curStar in pairs(biographyInfo) do
        local property_add_str = dms.string(dms["biographies_mould"], biographyId, biographies_mould.property_add)
        local property_add_1 = zstring.splits(property_add_str, "|", ",")
        addPropertyValue(property_add_1)

        local data = dms.searchs(dms["biographies_star_mould"], biographies_star_mould.biographies_mould_id, biographyId)
        if data ~= nil then
            for _, v in ipairs(data) do
                local star = dms.atof(v, biographies_star_mould.star)
                if curStar > 0 and curStar >= star then
                    local property_add_str = dms.atos(v, biographies_star_mould.property_add)
                    if property_add_str ~= "-1" then
                        local property_add_2 = zstring.splits(property_add_str, "|", ",")
                        addPropertyValue(property_add_2)
                    end
                end
            end
        end
    end

    -- 成就激活属性
    local info = RoleBiographyHandle.getBiographyAchieveInfo()
    local achieveStatus = zstring.split(info.achieveStatusInfo or "", ",")
    for i, v in ipairs(achieveStatus) do
        if tonumber(v) == 1 then
            local property_add_str = dms.string(dms["biographies_achieve"], i, biographies_achieve.property_add)
            if property_add_str ~= "-1" then
                local property_add_3 = zstring.splits(property_add_str, "|", ",")
                addPropertyValue(property_add_3)
            end
        end
    end

    -- local time2 = os.clock()
    -- print("time2 = ", time2)
    -- print("diff = ", time2 - time1)

    RoleBiographyHandle.totalPropertyData = totalData

    return totalData
end

-- 该成就是否已激活
function RoleBiographyHandle.getAchievementIsUnlock(id)
    local isActivate = false

    local info = RoleBiographyHandle.getBiographyAchieveInfo()
    local achieveStatus = zstring.split(info.achieveStatusInfo or "", ",")
    for i, v in ipairs(achieveStatus) do
        if i == id then
            isActivate = (tonumber(v) == 1)
            break
        end
    end

    return isActivate
end

-- 判断该印记是否是幻彩印记
function RoleBiographyHandle.judgeImprintIsColorful(propId)
    local quality = dms.int(dms["prop_mould"], propId, prop_mould.prop_quality)
    return quality == 7
end

-- 得到幻彩印记合成所需要的普通印记
function RoleBiographyHandle.getImprintCompoundNeedProps(propId)
    local compoundNeedProps = {}
    for _, v in pairs(dms["mark_synthesis"]) do
        local compound_prop = dms.atos(v, mark_synthesis.compound_prop)
        local compound_prop_id = zstring.split(compound_prop, ",")[2]

        if tonumber(compound_prop_id) == tonumber(propId) then
            local consume_props = dms.atos(v, mark_synthesis.consume_props)
            compoundNeedProps = zstring.splits(consume_props, "|", ",")
            break
        end
    end

    return compoundNeedProps
end

-- 获取该印记合成所需要的所有材料
function RoleBiographyHandle.getCurImprintComposeNeedByProp(propInfo)
    local propID = tonumber(propInfo[2])
    local needCounts = tonumber(propInfo[3])
    local allCostProp = {}
    local needCostProp = RoleBiographyHandle.getImprintCompoundNeedProps(propID)
    for _, v in ipairs(needCostProp) do
        for i = 1, needCounts do
            table.insert(allCostProp, v)
        end
    end

    return allCostProp
end

-- 判断印记合成材料是否足够
function RoleBiographyHandle.getCurImprintComposeIsEnough(propInfo)
    local propIsEnough = false
    local isColorful = RoleBiographyHandle.judgeImprintIsColorful(tonumber(propInfo[2]))
    if isColorful == true then
        local costPropInfos = RoleBiographyHandle.getCurImprintComposeNeedByProp(propInfo)
        for i, v in ipairs(costPropInfos) do
            local costNums = tonumber(v[3])
            local haveCount = tonumber(getPropAllCountByMouldId(v[2]))
            if haveCount >= costNums then
                propIsEnough = true
            else
                propIsEnough = false
                break
            end
        end
        
    end

    return propIsEnough
end

-- 获取激活时需要合成的印记信息
function RoleBiographyHandle.getBiographyComposeByActivate(biographyId)
    local canComposeProp = {}           -- 可合成道具信息
    local signetCostStr = dms.string(dms["biographies_mould"], biographyId, biographies_mould.signet_cost)
    local signetCost = zstring.splits(signetCostStr, "|", ",")
    for _, v in ipairs(signetCost) do
        local haveCount = tonumber(getPropAllCountByMouldId(v[2]))
        if haveCount < tonumber(v[3]) then
            table.insert(canComposeProp, v)
        end
    end

    return canComposeProp
end

-- 获取升星时需要合成的印记信息
function RoleBiographyHandle.getBiographyComposeByLevelUp(biographyId)
    local canComposeProp = {}           -- 可合成道具信息
    local costStr = RoleBiographyHandle.getUpLevelCostById(biographyId)
    if costStr then
        local cost = zstring.splits(costStr, "|", ",")
        for _, v in ipairs(cost) do
            local haveCount = tonumber(getPropAllCountByMouldId(v[2]))
            if haveCount < tonumber(v[3]) then
                table.insert(canComposeProp, v)
            end
        end
    end

    return canComposeProp
end

-- 获取忍列传名称
function RoleBiographyHandle.getBiographyNameByID(biographyId)
    local data = dms.element(dms["biographies_mould"], biographyId)
	local name_mould_id = dms.atos(data, biographies_mould.name)

	local word_info = dms.element(dms["word_mould"], name_mould_id)
	local name = word_info[3]

    return name
end

-- 获取忍列传图片索引
function RoleBiographyHandle.getBiographyPicByID(biographyId)
    local data = dms.element(dms["biographies_mould"], biographyId)
	local picIdx = dms.atof(data, biographies_mould.pic)

    return picIdx
end
