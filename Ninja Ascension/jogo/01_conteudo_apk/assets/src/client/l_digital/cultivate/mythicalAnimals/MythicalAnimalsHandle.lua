--[[
	神兽养成数据处理类
--]]

MythicalAnimalsHandle = MythicalAnimalsHandle or {}

MythicalAnimalsHandle.AnimalPropertyTypeMap = {[96] = true, [97] = true, [98] = true, [99] = true, [102] = true, [103] = true, [104] = true}

-- server data
--------------------------------------
-- 获得所有激活的神兽数据
function MythicalAnimalsHandle.getAllMythicalAnimalsInfo()
    local info = _ED.all_mythical_animals_info
    return info
end

-- 获得神兽技能信息
function MythicalAnimalsHandle.getMythicalAnimalsSkillInfo()
    local info = _ED.mythical_animals_skill_info
    return info
end

-- 获得神兽天命信息
function MythicalAnimalsHandle.getMythicalAnimalsFateInfo()
    local info = _ED.mythical_animals_fate_info
    return info
end

-- 获得激活的神兽数据
function MythicalAnimalsHandle.getMythicalAnimalsInfoById(id)
    local info = _ED.all_mythical_animals_info[id]
    return info
end

-- 获得神兽星级
function MythicalAnimalsHandle.getMythicalAnimalsStarById(id)
    local star = 0
    if _ED.all_mythical_animals_info and _ED.all_mythical_animals_info[id] ~= nil then
        star = _ED.all_mythical_animals_info[id].star
    end
    return star
end

-- 获得神兽阶级
function MythicalAnimalsHandle.getMythicalAnimalsStageById(id)
    local step = 0
    if _ED.all_mythical_animals_info and _ED.all_mythical_animals_info[id] ~= nil then
        local stepsInfo = _ED.all_mythical_animals_info[id].stepsInfo
        step = tonumber(zstring.split(stepsInfo, ",")[1])
    end

    return step
end

-- 获得神兽神锻石已消耗数量
function MythicalAnimalsHandle.getMythicalAnimalsForgeUseCountById(id)
    local useCount = {0, 0, 0}

    if _ED.all_mythical_animals_info and _ED.all_mythical_animals_info[id] ~= nil then
        local stepsInfo = _ED.all_mythical_animals_info[id].stepsInfo
        local info = zstring.split(stepsInfo, ",")
        useCount = {tonumber(info[2]), tonumber(info[3]), tonumber(info[4])}
    end
    return useCount
end

-- 获得神兽的连携信息 0未激活 1可激活 2已激活
function MythicalAnimalsHandle.getMythicalAnimalsLegueInfoById(id)
    local result = {}

    local animalsInfo = _ED.all_mythical_animals_info[id]
    if animalsInfo ~= nil then
        local relevantActiveStatus = _ED.all_mythical_animals_info[id].relevantActiveStatus
        result = zstring.split(relevantActiveStatus, ",")

    else
        for _, v in ipairs(dms["magical_animals_relevant_mould"]) do
            local animalIdsStr = dms.atos(v, magical_animals_relevant_mould.animalIds)
            local animalIds = zstring.split(animalIdsStr, ",")

            for _, m in ipairs(animalIds) do
                if id == tonumber(m) then
                    table.insert(result, 0)
                end
            end
        end
    end

    return result
end

--------------------------------------
-- play_config
-- 获得神锻材料
function MythicalAnimalsHandle.getForgeProps()
    local rewardStr = dms.string(dms["play_config"], 211, play_config.param)
    local rewards = zstring.splits(rewardStr, "|", ",")

    return rewards
end

-- 神锻石属性加成数值
function MythicalAnimalsHandle.getForgePropAddProperty()
    local propStr = dms.string(dms["play_config"], 212, play_config.param)
    local props = zstring.splits(propStr, "|", ",")

    return props
end

-- 神兽碎片转化 重复数码兽返还碎片
function MythicalAnimalsHandle.getSameAnimalsConvertFragment()
    local str = dms.string(dms["play_config"], 213, play_config.param)
    local props = zstring.splits(str, "|", ",")

    return props
end

-- 神兽阶数重置道具消耗
function MythicalAnimalsHandle.getRestStageCostProp()
    local costStr = dms.string(dms["play_config"], 214, play_config.param)
    local cost = zstring.split(costStr, ",")

    return cost
end

-- 获得天命消耗材料
function MythicalAnimalsHandle.getDestinyProp()
    local rewardStr = dms.string(dms["play_config"], 215, play_config.param)
    local rewards = zstring.split(rewardStr, ",")

    return rewards
end

-- 获得初始的神兽加成属性
function MythicalAnimalsHandle.getAnimalsInitProperty()
    local propertyDataStr = dms.string(dms["play_config"], 216, play_config.param)
    local propertyData = zstring.splits(propertyDataStr, "|", ",")

    return propertyData
end

-- 获得初始的神兽加成属性
function MythicalAnimalsHandle.getAnimalsAttackAverageCoefficient()
    return dms.float(dms["play_config"], 221, play_config.param)
end
--------------------------------------
-- 神兽养成红点
function MythicalAnimalsHandle.isShowMythicalAnimalsRedDot()
    local isShow = false

    local data = dms["magical_animals_mould"]
    for _, v in pairs(data) do
        local id = dms.atof(v, magical_animals_mould.id)
        if MythicalAnimalsHandle.showMythicalAnimalsRedDotById(id) == true then
            isShow = true
            break
        end
    end

    -- 是否可激活下一个天命
    if isShow == false then
        isShow = MythicalAnimalsHandle.canActivateNextDestiny()
    end

    return isShow
end


-- 单个神兽的红点
function MythicalAnimalsHandle.showMythicalAnimalsRedDotById(id)
    local isShow = false
    local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(id)

    if animalsInfo == nil then
        -- 是否可激活
        isShow = MythicalAnimalsHandle.canMythicalAnimalsUpStar(id, 0)
    else
        -- 神锻红点
        isShow = MythicalAnimalsHandle.isShowForgeRedDot(id)

        -- 是否可升星
        if isShow == false then
            local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(id)
            isShow = MythicalAnimalsHandle.canMythicalAnimalsUpStar(id, curStar)
        end
        
        -- 是否可激活连携
        if isShow == false then
            isShow = MythicalAnimalsHandle.canMythicalAnimalsLeague(id)
        end
    end

    return isShow
end

-- 是否可升星（并且返回升星所需道具）
function MythicalAnimalsHandle.canMythicalAnimalsUpStar(id, star)
    local canUpStar = false
    local costProp = nil

    local upStarGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.upStarGoupId)

    for _, v in ipairs(dms["magical_animals_star_mould"]) do
        local groupId = dms.atof(v, magical_animals_star_mould.groupId)
        if groupId == upStarGoupId then
            local curStarLvl = dms.atof(v, magical_animals_star_mould.curStarLvl)

            if curStarLvl == star then
                local nextId = dms.atof(v, magical_animals_star_mould.nextId)

                if nextId ~= -1 then
                    local costPropStr = dms.string(dms["magical_animals_star_mould"], nextId, magical_animals_star_mould.costProp)
                    costProp = zstring.split(costPropStr, ",")
                    
                    -- print("id = ", id, " upStarGoupId = ", upStarGoupId, " costPropStr = ", costPropStr)
                    local havePropNum = tonumber(getPropAllCountByMouldId(costProp[2]))
                    canUpStar = havePropNum >= tonumber(costProp[3])
                end
                break
            end
        end
    end

    return canUpStar, costProp
end

-- 是否可激活连携
function MythicalAnimalsHandle.canMythicalAnimalsLeague(id)
    local count = 0
    local info = MythicalAnimalsHandle.getMythicalAnimalsLegueInfoById(id)
    for _, v in ipairs(info) do
        if tonumber(v) == 1 then
            count = count + 1
        end
    end

    return count > 0
end

-- 是否可激活下一个天命
function MythicalAnimalsHandle.canActivateNextDestiny()
    local canActivate = false

    local curStep = MythicalAnimalsHandle.getCurDestinyStep() + 1
    local curProgress = MythicalAnimalsHandle.getCurDestinyProgress()

    local destinyProp = MythicalAnimalsHandle.getDestinyProp()
    local haveCount = tonumber(getPropAllCountByMouldId(destinyProp[2]))

    local needCount = MythicalAnimalsHandle.getCurDestinyCostPropCount()

    if needCount ~= nil then
       canActivate = haveCount >= needCount 
    end

    return canActivate
end

-- 是否已装备
function MythicalAnimalsHandle.isEquipAnimalSkill(id)
    local result = false
    local info = MythicalAnimalsHandle.getSkillInfo()
    for _, v in ipairs(info) do
        if id == tonumber(v) then
            result = true
            break
        end
    end
    return result
end

--------------------------------------
-- 获得神兽系统中给神兽加的属性
function MythicalAnimalsHandle.getAnimallProperty()
    local totalData = {}

    local result = MythicalAnimalsHandle.getAnimalsTotalProperty()
    for _, v in pairs(result) do
        local propertyType = v.propertyType
        local propertyValue = v.propertyValue

        -- 如果是神兽属性
        if MythicalAnimalsHandle.AnimalPropertyTypeMap[propertyType] then
            totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
        end
    end

    return totalData
end

-- 获得神兽养成系统对全体加的属性
function MythicalAnimalsHandle.getAnimalsAddPropertyToHero()
    local totalData = {}

    local function addPropertyValue(property_add)
        for _, v in pairs(property_add) do
            local propertyType = tonumber(v[1])
            local propertyValue = tonumber(v[2])

            -- 如果是神兽属性
            if not MythicalAnimalsHandle.AnimalPropertyTypeMap[propertyType] then
                totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
            end
        end
    end

    local info = MythicalAnimalsHandle.getAllMythicalAnimalsInfo()

    -- 添加计算神兽养成系统属性的判空处理
    if info == nil or (not next(info)) then
        return {}
    end

    for id in pairs(info) do
        -- 神锻属性
        local forgeResult = {}
        local forgeProperty = MythicalAnimalsHandle.getAnimalsForgePropertyById(id)
        for k, v in pairs(forgeProperty) do
            table.insert(forgeResult, {k, v})
        end

        -- 神兽激活后的基础属性+升星属性
        local upStarResult = {}
        local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(id)
        local upStarProperty = MythicalAnimalsHandle.getAnimalsUpStarPropertyById(id, curStar - 1)
        for k, v in pairs(upStarProperty) do
            table.insert(upStarResult, {k, v})
        end

        addPropertyValue(forgeResult)
        addPropertyValue(upStarResult)
    end

    -- 连携激活的属性
    local leagueResult = {}
    local leagueProperty = MythicalAnimalsHandle.getAnimalLeagueTotalProperty()
    for k, v in pairs(leagueProperty) do
        table.insert(leagueResult, {k, v})
    end
    addPropertyValue(leagueResult)

    -- 天命属性加成(全体武将属性)
    local destinyResult = {}
    local destinyProperty = MythicalAnimalsHandle.getDestinyPropertyByType(0)
    for k, v in pairs(destinyProperty) do
        table.insert(destinyResult, {k, v})
    end
    addPropertyValue(destinyResult)

    local result = {}
    for k, v in pairs(totalData) do
        table.insert(result, {propertyType = k, propertyValue = v})
    end

    return result
end

-- 获得神兽养成系统对神兽加的属性
function MythicalAnimalsHandle.getAnimalsAddPropertyToAnimal()
    local totalData = {}

    local function addPropertyValue(property_add)
        for _, v in pairs(property_add) do
            local propertyType = tonumber(v[1])
            local propertyValue = tonumber(v[2])

            -- 如果是神兽属性
            if MythicalAnimalsHandle.AnimalPropertyTypeMap[propertyType] == true then
                totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
            end
        end
    end


    -- 攻方神兽攻击(面板显示) = 当前上阵忍者攻击力平均值*系数G（配置在表里） + 天命神兽攻击力数值加成 + 神兵连携神兽攻击加成
    local allHeroAttack = 0
    local heroCount = 0

    for i = 2, 7 do
        local shipId = _ED.formetion[i]
        if zstring.tonumber(shipId) > 0 then
            local currShip = _ED.user_ship[""..shipId]
            if currShip ~= nil and zstring.tonumber(currShip.StarRating) > 0 then
                allHeroAttack = allHeroAttack + currShip.ship_courage
                heroCount = heroCount + 1

                -- print("shipId = ", shipId, " currShip.ship_courage = ", currShip.ship_courage, " heroCount = ", heroCount, " i = ", i)
            end
        end
    end

    -- 神兽攻击之当前上阵忍者攻击力平均值
    local averageAttack = allHeroAttack / heroCount
    local coefficient = MythicalAnimalsHandle.getAnimalsAttackAverageCoefficient()
    totalData[96] = math.ceil((totalData[96] or 0) + averageAttack * coefficient)

    -- print("神兽攻击之当前上阵忍者攻击力平均值 = ", averageAttack, " 平均战力系数 = ", coefficient)


    local info = MythicalAnimalsHandle.getAllMythicalAnimalsInfo()

    -- 添加计算神兽养成系统属性的判空处理
    if info == nil or (not next(info)) then
        return {}
    end

    -- 连携激活的属性
    local leagueResult = {}
    local leagueProperty = MythicalAnimalsHandle.getAnimalLeagueTotalProperty()
    for k, v in pairs(leagueProperty) do
        table.insert(leagueResult, {k, v})
    end
    addPropertyValue(leagueResult)

    -- 天命属性加成(神兽属性)
    local destinyResult = {}
    local destinyProperty = MythicalAnimalsHandle.getDestinyPropertyByType(1)
    for k, v in pairs(destinyProperty) do
        table.insert(destinyResult, {k, v})
    end
    addPropertyValue(destinyResult)

    local result = {}
    for k, v in pairs(totalData) do
        table.insert(result, {propertyType = k, propertyValue = v})
    end

    return result
end

-- 获得神兽总属性
--[[
@1 神兽激活后的基础属性->对全体忍者属性加成
@2 神锻属性->对全体忍者属性加成
@3 升星属性->对全体忍者属性加成
@4 连携激活的属性->对全体忍者属性加成&神兽属性加成
@5 天命属性加成->对全体忍者属性加成&神兽属性加成
]]
function MythicalAnimalsHandle.getAnimalsTotalProperty()
    local totalData = {}

    local propertyToHero = MythicalAnimalsHandle.getAnimalsAddPropertyToHero()
    for k,v in pairs(propertyToHero) do
        totalData[v.propertyType] = (totalData[v.propertyType] or 0) + v.propertyValue
    end
    
    local propertyToAnimal = MythicalAnimalsHandle.getAnimalsAddPropertyToAnimal()
    for k, v in pairs(propertyToAnimal) do
        totalData[v.propertyType] = (totalData[v.propertyType] or 0) + v.propertyValue
    end

    local result = {}
    for k, v in pairs(totalData) do
        table.insert(result, {propertyType = k, propertyValue = v})
    end

    return result
end

-- 神兽连携总属性
function MythicalAnimalsHandle.getAnimalLeagueTotalProperty()
    local totalData = {}
    local function addPropertyValue(property_add)
        for _, v in pairs(property_add) do
            local propertyType = tonumber(v[1])
            local propertyValue = tonumber(v[2])

            totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
        end
    end

    -- 存储连携模板id
    local leagueMap = {}

    for i, v in ipairs(dms["magical_animals_relevant_mould"]) do
        local animalIdsStr = dms.atos(v, magical_animals_relevant_mould.animalIds)
        leagueMap[animalIdsStr] = true
    end

    -- 只匹配连携中已激活的单个神兽
    local singleLeagueMap = {}

    local propertyData = {}
    for k, v in pairs(leagueMap) do
        local leagueList = zstring.split(k, ",")

        for _, v in ipairs(leagueList) do
            local animalId = tonumber(v)
            local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(animalId)
            if animalsInfo ~= nil then
                singleLeagueMap[animalId] = true
                break
            end
        end
    end

    for id in pairs(singleLeagueMap) do
        local legueIndex = 0
        for _, data in ipairs(dms["magical_animals_relevant_mould"]) do
            local animalIdsStr = dms.atos(data, magical_animals_relevant_mould.animalIds)
            local animalIds = zstring.split(animalIdsStr, ",")

            for _, m in ipairs(animalIds) do
                if tonumber(id) == tonumber(m) then
                    legueIndex = legueIndex + 1
                    local relevantActiveStatus = MythicalAnimalsHandle.getMythicalAnimalsLegueInfoById(id)
                    local activateState = 0
                    for index, v in ipairs(relevantActiveStatus) do
                        if index == legueIndex and tonumber(v) == 2 then
                            local propertyAddStr = dms.atos(data, magical_animals_relevant_mould.propertyAdd)
                            local propertyAdd = zstring.splits(propertyAddStr, "|", ",")
                            addPropertyValue(propertyAdd)
                        end 
                    end
                    break
                end
            end
        end
    end
    return totalData
end

-- 获得技能释放顺序
function MythicalAnimalsHandle.getSkillReleaseOrder()
    local info = MythicalAnimalsHandle.getMythicalAnimalsSkillInfo()
    return tonumber(info.skillReleaseMethod)
end

-- 获得技能设置信息
function MythicalAnimalsHandle.getSkillInfo()
    local info = MythicalAnimalsHandle.getMythicalAnimalsSkillInfo()
    local result = {}

    if info and info.equippedMAMould then
        local equippedMAMould = zstring.split(info.equippedMAMould, ",")
        for _, v in ipairs(equippedMAMould) do
            table.insert(result, tonumber(v))
        end  
    end
    
    return result
end

function MythicalAnimalsHandle.getAnimalsSkillInfoById(id)
    local result = {}
    local skillList = dms.string(dms["magical_animals_mould"], id, magical_animals_mould.skillList)
    local coolRoundList = dms.string(dms["magical_animals_mould"], id, magical_animals_mould.coolRoundList)
    local needAngerList = dms.string(dms["magical_animals_mould"], id, magical_animals_mould.needAngerList)

        
    local curStar = 1
    local info = MythicalAnimalsHandle.getMythicalAnimalsInfoById(id)
    if info ~= nil then
        curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(id)
    end

    result.talentMouldId = tonumber(zstring.split(skillList, "|")[curStar])
    result.coolRound = tonumber(zstring.split(coolRoundList, "|")[curStar])
    result.needAnger = tonumber(zstring.split(needAngerList, "|")[curStar])

    return result
end

function MythicalAnimalsHandle.getCurDestinyStep()
    local info = MythicalAnimalsHandle.getMythicalAnimalsFateInfo()
    return tonumber(info.step)
end

function MythicalAnimalsHandle.getCurDestinyProgress()
    local progress = 0
    local info = MythicalAnimalsHandle.getMythicalAnimalsFateInfo()
    local progressInfo = zstring.split(info.progress, ",")

    for _, v in ipairs(progressInfo) do
        if tonumber(v) > 0 then
            progress = progress + 1
        end
    end

    return progress
end

-- 获得天命石属性加成文本
function MythicalAnimalsHandle.getDestinyPropertyString(step, progress)
    local str = ""
    for _, v in ipairs(dms["magical_animals_fate_mould"]) do
        local stage = dms.atof(v, magical_animals_fate_mould.stage)
        local destiny = dms.atof(v, magical_animals_fate_mould.destiny)

        if stage == step and destiny == progress then
            local propertyAddStr = dms.atos(v, magical_animals_fate_mould.propertyAdd)
            local propertyAdd = zstring.splits(propertyAddStr, "|", ",")
            for _, v in ipairs(propertyAdd) do
                local name, value = getHardenPropertyNameAndValue(tonumber(v[1]), tonumber(v[2]), true, tipStringInfo_magical_animals_property_name_and_value)
                str = str .. name .. value
            end
            break
        end
    end

    return str
end

-- 获得当前天命需要消耗的道具数量
function MythicalAnimalsHandle.getCurDestinyCostPropCount()
    local count = nil

    local step = MythicalAnimalsHandle.getCurDestinyStep() + 1
    local progress = MythicalAnimalsHandle.getCurDestinyProgress() + 1

    for _, v in ipairs(dms["magical_animals_fate_mould"]) do
        local stage = dms.atof(v, magical_animals_fate_mould.stage)
        local destiny = dms.atof(v, magical_animals_fate_mould.destiny)

        if stage == step and destiny == progress then
            local costPropStr = dms.atos(v, magical_animals_fate_mould.costProp)
            local costProp = zstring.split(costPropStr, ",")

            count = tonumber(costProp[3])
            break
        end
    end

    return count
end

-- 获得天命属性加成
function MythicalAnimalsHandle.getDestinyPropertyByType(addType)
    local curStep = MythicalAnimalsHandle.getCurDestinyStep()
    local curProgress = MythicalAnimalsHandle.getCurDestinyProgress()

    local totalData = {}

    local function addPropertyValue(property_add)
        for _, v in pairs(property_add) do
            local propertyType = tonumber(v[1])
            local propertyValue = tonumber(v[2])

            totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
        end
    end

    for _, v in ipairs(dms["magical_animals_fate_mould"]) do
        local stage = dms.atof(v, magical_animals_fate_mould.stage)
        local destiny = dms.atof(v, magical_animals_fate_mould.destiny)
        local propertyCategory = dms.atof(v, magical_animals_fate_mould.propertyCategory)

        -- 全体属性0 神兽属性1
        if propertyCategory == addType then
            if stage <= curStep then
                local propertyAddStr = dms.atos(v, magical_animals_fate_mould.propertyAdd)
                local propertyAdd = zstring.splits(propertyAddStr, "|", ",")

                addPropertyValue(propertyAdd)

            elseif stage == curStep + 1 and curProgress >= destiny then
                local propertyAddStr = dms.atos(v, magical_animals_fate_mould.propertyAdd)
                local propertyAdd = zstring.splits(propertyAddStr, "|", ",")

                addPropertyValue(propertyAdd)
            end
        end
    end

    -- -- 神兽初始属性
    -- if addType == 1 then
    --     local initProperty = MythicalAnimalsHandle.getAnimalsInitProperty()
    --     addPropertyValue(initProperty)
    -- end

    return totalData
end

-- 获得左侧天命石图片和名字
function MythicalAnimalsHandle.getDestinyLeftIconInfoByStage(paramStage)
    local stonePicIndex = nil
    for _, v in ipairs(dms["magical_animals_fate_mould"]) do
        local stage = dms.atof(v, magical_animals_fate_mould.stage)
        if stage == paramStage then
            stonePicIndex = dms.atof(v, magical_animals_fate_mould.stonePicIndex)
            stageMouldId = dms.atof(v, magical_animals_fate_mould.stageMouldId)
            break
        end
    end
    return stonePicIndex, stageMouldId
end

-- 获得天命阶数列表
function MythicalAnimalsHandle.getDestinyStageList()
    local stageList = {}
    for _, v in ipairs(dms["magical_animals_fate_mould"]) do
        local stage = dms.atof(v, magical_animals_fate_mould.stage)
        stageList[stage] = true
    end

    local result = {}
    for k, v in pairs(stageList) do
        table.insert(result, k)
    end

    table.sort(result, function(a, b)
        return a < b
    end)

    return result
end

-- 获得排序后神兽列表
function MythicalAnimalsHandle.getSortAnimalsList()
    local data = dms["magical_animals_mould"]

    --列表排序：
        --可以激活>可以升星>已装备>已激活未装备>未激活
    --内部排序：
        --品质>id

    local function sortFunc(a, b)
        local aQuality = dms.atof(a, magical_animals_mould.quality)
        local bQuality = dms.atof(b, magical_animals_mould.quality)

        if aQuality == bQuality then
            local aId = dms.atof(a, magical_animals_mould.id)
            local bId = dms.atof(b, magical_animals_mould.id)

            return aId < bId
        end

        return aQuality > bQuality
    end

    local sortList = {}

    local canUnlockList = {}
    local canLevelUpList = {}
    local haveEquipList = {}
    local haveActivateList = {}
    local notUnlockList = {}

    for _, v in ipairs(data) do
        local animalsId = dms.atof(v, magical_animals_mould.id)
        
        local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(animalsId)

        -- 未激活
        if animalsInfo == nil then
            if MythicalAnimalsHandle.canMythicalAnimalsUpStar(animalsId, 0) then
                -- 可激活
                table.insert(canUnlockList, v)
            else
                table.insert(notUnlockList, v)
            end
        else
            local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(animalsId)
            if MythicalAnimalsHandle.canMythicalAnimalsUpStar(animalsId, curStar) then
                -- 可升星
                table.insert(canLevelUpList, v)
            elseif MythicalAnimalsHandle.isEquipAnimalSkill(animalsId) then
                -- 已装备
                table.insert(haveEquipList, v)
            else
                -- 已激活未装备
                table.insert(haveActivateList, v)
            end
        end
    end

    table.sort(canUnlockList, sortFunc)
    for _, v in ipairs(canUnlockList) do
        table.insert(sortList, v)
    end

    table.sort(canLevelUpList, sortFunc)
    for _, v in ipairs(canLevelUpList) do
        table.insert(sortList, v)
    end

    table.sort(haveEquipList, sortFunc)
    for _, v in ipairs(haveEquipList) do
        table.insert(sortList, v)
    end

    table.sort(haveActivateList, sortFunc)
    for _, v in ipairs(haveActivateList) do
        table.insert(sortList, v)
    end

    table.sort(notUnlockList, sortFunc)
    for _, v in ipairs(notUnlockList) do
        table.insert(sortList, v)
    end

    return sortList
end

-- 获得神兽名字
function MythicalAnimalsHandle.getAnimalsNameById(id)
    local nameMouldId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.nameMouldId)
    local word_info = dms.element(dms["word_mould"], nameMouldId)
    local name = word_info[3]
    return name
end

-- 获得神兽初始属性(当前星级属性)
function MythicalAnimalsHandle.getAnimalsUpStarPropertyById(id, star)
    local totalData = {}

    local function addPropertyValue(property_add)
        for _, v in pairs(property_add) do
            local propertyType = tonumber(v[1])
            local propertyValue = tonumber(v[2])

            totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
        end
    end

    local upStarGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.upStarGoupId)

    for _, v in ipairs(dms["magical_animals_star_mould"]) do
        local groupId = dms.atof(v, magical_animals_star_mould.groupId)
        if groupId == upStarGoupId then
            local curStarLvl = dms.atof(v, magical_animals_star_mould.curStarLvl)

            if curStarLvl <= star then
                local nextId = dms.atof(v, magical_animals_star_mould.nextId)
                local propertyAddStr = dms.string(dms["magical_animals_star_mould"], nextId, magical_animals_star_mould.propertyAdd)

                local propertyAdd = zstring.splits(propertyAddStr, "|", ",")
                addPropertyValue(propertyAdd)
            end
        end
    end

    return totalData
end

-- 获得神兽神锻属性加成
function MythicalAnimalsHandle.getAnimalsForgePropertyById(id)
    local totalData = {}
    local props = MythicalAnimalsHandle.getForgePropAddProperty()
    local useCount = MythicalAnimalsHandle.getMythicalAnimalsForgeUseCountById(id)

    local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(id)

    local costPropCountList = {}
    local forgeGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.forgeGoupId)

    for _, v in ipairs(dms["magical_animals_forging_mould"]) do
        local groupId = dms.atof(v, magical_animals_forging_mould.groupId)
        if groupId == forgeGoupId then
            local curStageLvl = dms.atof(v, magical_animals_forging_mould.curStageLvl)
            if curStageLvl <= curStage then
                local costPropStr = dms.atos(v, magical_animals_forging_mould.costProp)
                if costPropStr ~= "-1" then
                    local costProp = zstring.splits(costPropStr, "|", ",")
                    for _, v in ipairs(costProp) do
                        local propId, propCount = tonumber(v[2]), tonumber(v[3])
                        costPropCountList[propId] = (costPropCountList[propId] or 0) + propCount
                    end
                end
            end
        end
    end

    local forgeProps = MythicalAnimalsHandle.getForgeProps()
    for i, v in ipairs(forgeProps) do
        local propId = tonumber(v[2])
        useCount[i] = useCount[i] + (costPropCountList[propId] or 0)
    end

    for i, v in ipairs(props) do
        totalData[tonumber(v[1])] = tonumber(v[2]) * useCount[i]
    end

    return totalData
end

-- 获得神兽阶级天赋
function MythicalAnimalsHandle.getAnimalsStageTalentById(id)
    local talentList = {}
    local forgeGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.forgeGoupId)

    for _, v in ipairs(dms["magical_animals_forging_mould"]) do
        local groupId = dms.atof(v, magical_animals_forging_mould.groupId)
        if groupId == forgeGoupId then
            local talentMouldId = dms.atof(v, magical_animals_forging_mould.talentMouldId)
            if talentMouldId > 0 then
                table.insert(talentList, talentMouldId)
            end
        end
    end

    return talentList
end

-- 获得神兽指定阶级的天赋id
function MythicalAnimalsHandle.getAnimalsCurStageTalentById(id, stage)
    local talentId = nil
    local forgeGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.forgeGoupId)

    for _, v in ipairs(dms["magical_animals_forging_mould"]) do
        local groupId = dms.atof(v, magical_animals_forging_mould.groupId)
        local curStageLvl = dms.atof(v, magical_animals_forging_mould.curStageLvl)
        if groupId == forgeGoupId and curStageLvl == stage then
            talentId = dms.atof(v, magical_animals_forging_mould.talentMouldId)
            break
        end
    end

    return talentId
end

-- 获得神兽当前阶级所拥有的天赋
function MythicalAnimalsHandle.getAnimalsTalentListById(id)
    local talentList = {}
    local forgeGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.forgeGoupId)

    local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(id)

    for _, v in ipairs(dms["magical_animals_forging_mould"]) do
        local groupId = dms.atof(v, magical_animals_forging_mould.groupId)
        local curStageLvl = dms.atof(v, magical_animals_forging_mould.curStageLvl)
        if groupId == forgeGoupId and curStageLvl <= curStage then
            local talentMouldId = dms.atof(v, magical_animals_forging_mould.talentMouldId)
            if talentMouldId > 0 then
                table.insert(talentList, talentMouldId)
            end
        end
    end

    return talentList
end

-- 获得神兽指定阶级需要的道具信息
function MythicalAnimalsHandle.getAnimalsUpStagCostPropInfoById(id, stage)
    local costProp = nil
    local forgeGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.forgeGoupId)

    for _, v in ipairs(dms["magical_animals_forging_mould"]) do
        local groupId = dms.atof(v, magical_animals_forging_mould.groupId)
        local curStageLvl = dms.atof(v, magical_animals_forging_mould.curStageLvl)
        if groupId == forgeGoupId and curStageLvl == stage + 1 then
            local costPropStr = dms.atos(v, magical_animals_forging_mould.costProp)
            costProp = zstring.splits(costPropStr, "|", ",")
            break
        end
    end

    return costProp
end

-- 获取一条连携属性
function MythicalAnimalsHandle.getAnimalsLeaguePropertyByLeagueId(id)
    local totalData = {}

    local function addPropertyValue(property_add)
        for _, v in pairs(property_add) do
            local propertyType = tonumber(v[1])
            local propertyValue = tonumber(v[2])

            totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
        end
    end

    local propertyAddStr = dms.string(dms["magical_animals_relevant_mould"], id, magical_animals_relevant_mould.propertyAdd)

    local propertyAdd = zstring.splits(propertyAddStr, "|", ",")
    addPropertyValue(propertyAdd)
    
    return totalData
end

-- 判断当前神锻进度是否已满
function MythicalAnimalsHandle.getForgeProgressIsFullById(id, index)
    local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(id)
    local costProp = MythicalAnimalsHandle.getAnimalsUpStagCostPropInfoById(id, curStage)
    local forgeUseCount = MythicalAnimalsHandle.getMythicalAnimalsForgeUseCountById(id)

    return forgeUseCount[index] >= tonumber(costProp[index][3])
end

-- 判断当前神兽是否神锻过
function MythicalAnimalsHandle.getAnimalsHaveForgeStateById(id)
    local haveForge = false

    local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(id)

    if animalsInfo ~= nil then
        local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(id)
        haveForge = curStage > 0 

        if haveForge == false then
            local forgeUseCount = MythicalAnimalsHandle.getMythicalAnimalsForgeUseCountById(id)
            for _, v in ipairs(forgeUseCount) do
                if tonumber(v) > 0 then
                    haveForge =  true
                    break
                end
            end
        end
        
    end
    return haveForge
end

-- 是否拥有足够的神锻材料
function MythicalAnimalsHandle.canHaveEnoughForgeProps()
    local haveEnoughProp = false

    local props = MythicalAnimalsHandle.getForgeProps()
    for _, v in ipairs(props) do
        local haveCount = tonumber(getPropAllCountByMouldId(v[2]))
        if haveCount >= tonumber(v[3]) then
            haveEnoughProp = true
            break
        end
    end
    return haveEnoughProp
end

-- 是否显示神锻红点
function MythicalAnimalsHandle.isShowForgeRedDot(id)
    local isShowRedDot = false
    local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(id)

    if animalsInfo then
        local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(id)

        local forgeGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.forgeGoupId)

        local maxStage = 0
        for _, v in ipairs(dms["magical_animals_forging_mould"]) do
            local groupId = dms.atof(v, magical_animals_forging_mould.groupId)
            if groupId == forgeGoupId then
                maxStage = maxStage + 1
            end
        end

        local isMax = false
        if curStage >= maxStage - 1 then
            isMax = true
        end

        if isMax == false and MythicalAnimalsHandle:canHaveEnoughForgeProps() then
            isShowRedDot = true
        end
    end

    return isShowRedDot
end

-- 是否已满星
function MythicalAnimalsHandle.isMaxStarLevel(id)
    local isMax = false
    local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(id)

    if animalsInfo then
        local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(id)

        local upStarGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.upStarGoupId)

        local maxStar = 0

        for _, v in ipairs(dms["magical_animals_star_mould"]) do
            local groupId = dms.atof(v, magical_animals_star_mould.groupId)
            if groupId == upStarGoupId then
                maxStar = maxStar + 1
            end
        end

        if curStar >= maxStar - 1 then
            isMax = true
        end
    end

    return isMax
end

-- 获得天命任务数据
function MythicalAnimalsHandle.getDestinyTaskData()
    local info = _ED.mythical_animals_fate_task_info
    if info == nil or table.nums(info) == 0 then
        return {}
    end

    local result = {}
    for _, v in pairs(info) do
        table.insert(result, v)
    end

    table.sort(result, function(a, b)
        return tonumber(a.taskType) < tonumber(b.taskType)
    end)

    return result
end

-- 获取天命任务名称和描述
function MythicalAnimalsHandle.getDestinyTaskDes(taskType)
    local name, describe = "", ""
    for _, v in ipairs(dms["magical_animals_fate_task_mould"]) do
        local mouldTaskType = dms.atof(v, magical_animals_fate_task_mould.taskType)
        if taskType == mouldTaskType then
            -- local taskNameMouldId = dms.atof(v, magical_animals_fate_task_mould.taskName)
            -- local word_info = dms.element(dms["word_mould"], taskNameMouldId)
            -- name = word_info[3]

            local taskDesMouldId = dms.atof(v, magical_animals_fate_task_mould.taskDes)
            local word_info = dms.element(dms["word_mould"], taskDesMouldId)
            describe = word_info[3]

            break
        end
    end

    return name, describe
end

-- 获取当前类型任务进度
function MythicalAnimalsHandle.getDestinyTaskProgress(taskType)
    local taskData = nil
    for i, v in pairs(_ED.mythical_animals_fate_task_info) do
        if tonumber(v.taskType) == taskType then
            taskData = v
            break
        end
    end

    local taskProgressInfo = {curProgress = 0, nextProgress = 0, taskReward = nil}

    if taskData == nil then
        return taskProgressInfo
    end

    if taskType == 1 then
        taskProgressInfo.curProgress = tonumber(taskData.todayNumber)

        for _, v in ipairs(dms["magical_animals_fate_task_mould"]) do
            local mouldTaskType = dms.atof(v, magical_animals_fate_task_mould.taskType)
            if taskType == mouldTaskType then
                taskProgressInfo.taskReward = dms.atos(v, magical_animals_fate_task_mould.taskReward)
                taskProgressInfo.nextProgress = dms.atof(v, magical_animals_fate_task_mould.taskNum)
                break
            end
        end
    else
        taskProgressInfo.curProgress = tonumber(taskData.totalNumber)

        local hasGetNumber = tonumber(taskData.hasGetNumber) + 1

        local taskIdList = {}
        for _, v in ipairs(dms["magical_animals_fate_task_mould"]) do
            local mouldTaskType = dms.atof(v, magical_animals_fate_task_mould.taskType)
            if taskType == mouldTaskType then
                local taskId = dms.atof(v, magical_animals_fate_task_mould.id)
                table.insert(taskIdList, taskId)
            end
        end

        local taskId = nil
        for i, v in ipairs(taskIdList) do
            if hasGetNumber == i then
                taskId = v
                break
            end
        end
        
        if taskId == nil then
            hasGetNumber = hasGetNumber - 1
            for i, v in ipairs(taskIdList) do
                if hasGetNumber == i then
                    taskId = v
                    break
                end
            end
        end

        if taskId ~= nil then
            local data = dms.searchs(dms["magical_animals_fate_task_mould"], 1, taskId)[1]
            taskProgressInfo.taskReward = dms.atos(data, magical_animals_fate_task_mould.taskReward)
            taskProgressInfo.nextProgress = dms.atof(data, magical_animals_fate_task_mould.taskNum)
        end
    end

    return taskProgressInfo
end

-- 获得最大的神锻等级（减1 是因为表里是从0阶开始的）
function MythicalAnimalsHandle.getMaxStageLvlById(id)
    local forgeGoupId = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.forgeGoupId)

    local maxStage = 0
    for _, v in ipairs(dms["magical_animals_forging_mould"]) do
        local groupId = dms.atof(v, magical_animals_forging_mould.groupId)
        if groupId == forgeGoupId then
            maxStage = maxStage + 1
        end
    end
    return maxStage - 1
end