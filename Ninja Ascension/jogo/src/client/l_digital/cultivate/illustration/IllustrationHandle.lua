--[[
	卡册数据处理类
    author: Rock
    time:2019-12-31 17:23:04
--]]

IllustrationHandle = IllustrationHandle or {}
IllustrationHandle.achieveDatas = nil
IllustrationHandle.allHeroList = nil

-- 获得所有可上阵卡
function IllustrationHandle.getAllCard()
    local allHeroList = {}
    if nil == IllustrationHandle.allHeroList then
        for i, shipMould in pairs(dms["prop_mould"]) do
            local isAdd = false
            if tonumber(dms.atoi(shipMould, prop_mould.props_type)) == 1 then
                local hero_mould_id = dms.string(dms["prop_mould"], dms.atoi(shipMould, prop_mould.id), prop_mould.use_of_ship)
                if IllustrationHandle.switchCardId(hero_mould_id) then
                    table.insert( allHeroList,tonumber(hero_mould_id) )
                end
            end
        end
        IllustrationHandle.allHeroList = allHeroList
    else
        allHeroList = IllustrationHandle.allHeroList
    end

    return allHeroList
end

-- 返回攻防血对应属性和品质卡组
function IllustrationHandle.getCardShipByPhase(phaseIndex,qualityList)
    
    local allHeroList = IllustrationHandle.getAllCard()
    local allShipList = {}

    for k,heroId in pairs(allHeroList) do
        local campPreference = dms.int(dms["ship_mould"], tonumber(heroId), ship_mould.camp_preference)
        local qualityNum = dms.int(dms["ship_mould"], tonumber(heroId), ship_mould.ability)
        if campPreference == tonumber(phaseIndex) then
            for k,v in pairs(qualityList) do
                if tonumber(v) == qualityNum then
                    table.insert(allShipList, tonumber(heroId))
                end
            end
        
        end
    end

    local function AbilityCapacity(a,b)
        local al = dms.int(dms["ship_mould"], tonumber(a), ship_mould.ability)
        local bl = dms.int(dms["ship_mould"], tonumber(b), ship_mould.ability)
        local result = false
        if al > bl then
            result = true
        end
        local cardA = IllustrationHandle.getCardDataByShipMouldId(al)
        local cardB = IllustrationHandle.getCardDataByShipMouldId(bl)
        if cardA and cardB then
            if al == bl then
                local k1 = tonumber(cardA.cardScore)
                local k2 = tonumber(cardB.cardScore)
                if k1 > k2 then
                    return true
                end
            end
        end
        
        return result 
    end
    local finalList = {}    -- 最終卡列表
    local canUnlock = {}    -- 可激活
    local canUpLevel = {}   -- 可升级
    local haveUnlock = {}   -- 已激活
    local lock = {}         -- 未激活 
    for k,v in pairs(allShipList) do
        if IllustrationHandle.getUnlockByShipMouldId(v) then
            table.insert( canUnlock, v )
        elseif IllustrationHandle.getFlagLevelup(v) then
            table.insert( canUpLevel, v )
        elseif nil ~= IllustrationHandle.getCardDataByShipMouldId(v) then
            table.insert( haveUnlock, v )
        else
            table.insert( lock, v )
        end
    end

    table.sort(canUnlock,AbilityCapacity)
    table.sort(canUpLevel,AbilityCapacity)
    table.sort(haveUnlock,AbilityCapacity)
    table.sort(lock,AbilityCapacity)

    for k,v in pairs(canUnlock) do
        table.insert(finalList,v)
    end

    for k,v in pairs(canUpLevel) do
        table.insert(finalList,v)
    end

    for k,v in pairs(haveUnlock) do
        table.insert(finalList,v)
    end

    for k,v in pairs(lock) do
        table.insert(finalList,v)
    end
    -- 卡排序(卡状态>资质)
    
    return finalList
end

-- 通过卡册ID查找对应武将shipMouldId
function IllustrationHandle.switchShipMouldId(cardId)
    local cardDatas = dms.searchs(dms["card_mould"], 1, cardId)
    local shipMouldId = tonumber(cardDatas[1][2])

    return shipMouldId
end

-- 通过武将shipMouldId查找对应卡册ID
function IllustrationHandle.switchCardId(mouldId)
    local cardDatas = dms.searchs(dms["card_mould"], 2, mouldId)
    local cardIds = nil
    if cardDatas then
        cardIds = cardDatas[1][1]
    end
    
    return cardIds
end

-- 通过shipMouldId查找服务器对应卡册数据
function IllustrationHandle.getCardDataByShipMouldId(mouldId)
    if nil == _ED.illustration_info_init then
        return nil
    end

    local preCardData = nil
    local cardInfo = _ED.illustration_info_init.userCardInfoList
    if cardInfo and 0 ~= #cardInfo then
        for k,v in pairs(cardInfo) do
            if tonumber(v.shipMouldId) == mouldId then
                preCardData = v
                break
            end
        end
    end
    return preCardData
end

-- 返回卡服务器册值成就数据
function IllustrationHandle.getAchieveByServer()
    local totalScore = nil 
    local totalAdd = nil
    local normalAdd = nil
    local Datas = _ED.illustration_info_init
    if nil ~= Datas then
        normalAdd = Datas.normalAdditionProperty        -- 评分累计加成
        totalScore = Datas.totalScore                   -- 总评分
        totalAdd = Datas.achieveAdditionProperty      -- 总加成
    end

    return normalAdd,tonumber(totalScore),totalAdd
end

-- 通过shipMouldId某张卡册是否能激活
function IllustrationHandle.getUnlockByShipMouldId(mouldId)
    if nil ~= IllustrationHandle.getCardDataByShipMouldId(mouldId) then
        return false
    end
    local flag = false
    for k,ship in pairs(_ED.user_ship) do
        if tonumber(mouldId) == tonumber(ship.ship_template_id) then
            flag = true
            break
        end
    end
    return flag
end

-- 攻防技是否能激活
function IllustrationHandle.getPhaseFlagUnlockAllCard(typeId)
    local qualityList = {13,14,15,16,17}
    for k,v in pairs(IllustrationHandle.getCardShipByPhase(typeId,qualityList)) do
        if nil == IllustrationHandle.getCardDataByShipMouldId(tonumber(v)) then
            for i,ship in pairs(_ED.user_ship) do
                if tonumber(v) == tonumber(ship.ship_template_id) then
                    return true
                end
            end
        end
    end
    return false
end

-- 有没有卡可以激活
function IllustrationHandle.getFlagUnlockAllCard()
    local result = false
    for k,v in pairs(IllustrationHandle.getAllCard()) do
        if nil == IllustrationHandle.getCardDataByShipMouldId(tonumber(v)) then
            for i,ship in pairs(_ED.user_ship) do
                if tonumber(v) == tonumber(ship.ship_template_id) then
                    result = true
                    break
                end
            end
        end
    end

    if not result then
        local combineCards = IllustrationHandle.getCombineCards()
        for _, v in pairs(combineCards) do
            local combineCardData = IllustrationHandle.getCombineCardDataByCardId(v)
            local cardDatas = IllustrationHandle.getCardDataByCardMouldId(v)
            local canUnlock = IllustrationHandle.getCombineCardCanUnlock(combineCardData)
            if cardDatas == nil and canUnlock == true then
                result = true
                break
            end
        end
    end

    return result
end

-- 单卡册是否可升级
function IllustrationHandle.getFlagLevelup(mouldId, isCombineCard)
    local flag = false
    local needProp = nil

    local function canLevelUpFunc(mouldId, cardStar, isCombineCard)
        local flag = false
        local needProp = nil
        local consume = IllustrationHandle.getUpLevelConsume(mouldId, cardStar, isCombineCard)
        if nil ~= consume then
            local propDatas = zstring.splits(consume, "|", ",")

            for _, prop in pairs(propDatas) do
                local propType = tonumber(prop[1])
                local propId = tonumber(prop[2])
                local aimNum = tonumber(prop[3])

                local haveNum = 0
            
                if fundPropWidthId(propId) then
                    haveNum = tonumber(fundPropWidthId(propId).prop_number)
                end

                if haveNum < aimNum then
                    -- 将缺少的道具信息一起存储
                    flag = false
                    needProp = {propType, propId, aimNum - haveNum}
                    break
                end
                flag = true
            end
        end
        return flag, needProp
    end

    if isCombineCard then
        local cardDatas = IllustrationHandle.getCardDataByCardMouldId(mouldId)
        if cardDatas then
            local cardStar = tonumber(cardDatas.cardStar)    -- 等级
            local maxLevel = IllustrationHandle.getCombineCardMaxLevel(mouldId) 
            if cardStar < maxLevel then
                flag, needProp = canLevelUpFunc(mouldId, cardStar, isCombineCard)
            end
        end
    else
        local perCardData = IllustrationHandle.getCardDataByShipMouldId(mouldId)
        if perCardData and getShipByTemplateId(mouldId) then
           local cardStar = tonumber(perCardData.cardStar)    -- 等级
           local userShipStar = tonumber(getShipByTemplateId(mouldId).StarRating)   -- 当前武将星级
           if (cardStar + 1) <= userShipStar then -- 可以升级
                flag, needProp = canLevelUpFunc(mouldId, cardStar, isCombineCard)
           end
        end
    end

    return flag, needProp
end

-- 是否有卡可以升级
function IllustrationHandle.getFlagUplevelAllCard()
    local canUpList = {}
    local needPropTemp = {}

    if nil == _ED.illustration_info_init then 
        return canUpList, needPropTemp
    end

    local cardInfo = _ED.illustration_info_init.userCardInfoList
    if nil == cardInfo then
        return canUpList, needPropTemp
    end
    
    for k,v in pairs(cardInfo) do
        local isCombineCard = IllustrationHandle.judgeCardIsCombineCard(tonumber(v.cardMouldId))
        local mouldId = isCombineCard and tonumber(v.cardMouldId) or tonumber(v.shipMouldId)
        local canUp, needProp = IllustrationHandle.getFlagLevelup(mouldId, isCombineCard)
        if canUp then
            table.insert(canUpList, {mouldId = mouldId, isCombineCard = isCombineCard})
        elseif needProp then
            -- needPropTemp = needPropTemp + needProp
            table.insert(needPropTemp, needProp)
            -- if nil == needPropTemp then
            --     needPropTemp = needProp
            -- elseif needProp < needPropTemp then
            --     needPropTemp = needProp
            -- end
        end
    end
    
    return canUpList,needPropTemp
end

-- 攻防技是否可以升级
function IllustrationHandle.getPhaseFlagUplevelAllCard(typeId)
    if nil == _ED.illustration_info_init then 
        return nil,0
    end
    local cardInfo = _ED.illustration_info_init.userCardInfoList
    if nil == cardInfo then
        return nil,0
    end
    local canUpList = {}
    for k,v in pairs(cardInfo) do
        local campPreference = dms.int(dms["ship_mould"], tonumber(v.shipMouldId), ship_mould.camp_preference)
        if tonumber(typeId) == campPreference then
            local canUp = IllustrationHandle.getFlagLevelup(tonumber(v.shipMouldId))
            if canUp then
                table.insert(canUpList,v.shipMouldId)
            end
        end
    end

    return canUpList
end

-- 获得卡册名字
function IllustrationHandle.getCardName(mouldId, isCombineCard)
    local hero_name = ""
    
    if isCombineCard then
        local combine_card_data = IllustrationHandle.getCombineCardDataByCardId(mouldId)
        local name_mould_id = tonumber(combine_card_data[ship_illustration_card_mould.combine_name])
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        hero_name = word_info[3]
    else
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local evo_mould_id =  evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        hero_name = word_info[3]
    end

    return hero_name
end


-- 人物图片下标
function IllustrationHandle.getHeadIndex(mouldId, isCombineCard)
    local temp_bust_index = nil
    if isCombineCard then
        local combine_card_data = IllustrationHandle.getCombineCardDataByCardId(mouldId)
        temp_bust_index = tonumber(combine_card_data[ship_illustration_card_mould.combine_img_id])
    else
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
    end

    return temp_bust_index
end

-- 获取升级消耗
function IllustrationHandle.getUpLevelConsume(mouldId, curLevel, isCombineCard)
    local qualityNum = 15
    if isCombineCard then
        qualityNum = mouldId
    else
        qualityNum = dms.int(dms["ship_mould"], mouldId, ship_mould.ability)
        if 15 > qualityNum then
            qualityNum = 15
        end
    end

    local consume = nil -- 升级消耗
    local mark = nil    -- 当前评分
    local markAdd = nil -- 当前等级评分加值
    local curAdd = nil  -- 当前加成
    local nextId = nil  -- 下一等级Id
    local nextAdd = nil -- 获取下一级加成
    local elements = dms.searchs(dms["card_unblock"],ship_illustration_consume_mould.ability,qualityNum)
    for k,v in pairs(elements) do
        local level = tonumber(v[ship_illustration_consume_mould.level])
        if curLevel == level then
            nextId = tonumber(v[ship_illustration_consume_mould.next])
            mark = tonumber(v[ship_illustration_consume_mould.mark])
            curAdd = v[ship_illustration_consume_mould.property_add]
            break
        end
    end

    if nextId and -1 ~= nextId then
        nextAdd = dms.string(dms["card_unblock"],nextId,ship_illustration_consume_mould.property_add)
        consume = dms.string(dms["card_unblock"],nextId,ship_illustration_consume_mould.consume)
        markAdd = dms.string(dms["card_unblock"],nextId,ship_illustration_consume_mould.mark_add)
    end

    return consume,curAdd,nextAdd,markAdd
end

-- 获取成就加成
function IllustrationHandle.getAchieveAdd(mark)
    local achieveAdd = nil 
    local aimMark = nil
    local flag = false
    local aimId = nil
    local allAchieve = IllustrationHandle.getAllAchieveAdd()
    if mark >= tonumber(allAchieve[#allAchieve].markData) then    -- 满成就了
        aimMark = -1
        achieveAdd = allAchieve[#allAchieve].addData
    else
        for k,v in pairs(allAchieve) do
            if flag then
                achieveAdd = v.addData
                aimMark = v.markData
                aimId = v.id
                break
            end
            if v.markData > mark then
                aimMark = v.markData
                achieveAdd = v.addData
                aimId = v.id
                break
            elseif v.markData == mark then
                flag = true
            end
        end
    end
    
    return achieveAdd,aimMark,aimId
end

-- 获取成就数据通过成就Id
function IllustrationHandle.getAchieveById(achieveId)
    if achieveId < 1 then
        return nil 
    end
    local markData = nil
    for k,v in pairs(IllustrationHandle.getAllAchieveAdd()) do
        if achieveId == tonumber(v.id) then
            markData = v.markData
        end
    end

    return markData
end

-- 获取成就加成列表
function IllustrationHandle.getAllAchieveAdd()
    if nil == IllustrationHandle.achieveDatas then
        local counts = dms.count(dms["card_achieve"])
        local achieveDatas = {}
        for i=1,counts do
            local temp = {}
            local mark = dms.int(dms["card_achieve"],i,ship_illustration_achieve_mould.condition)
            local add = dms.string(dms["card_achieve"],i,ship_illustration_achieve_mould.property_add)
            local achieveId = dms.string(dms["card_achieve"],i,ship_illustration_achieve_mould.id)
            temp.markData = mark
            temp.addData = add
            temp.id = achieveId
            table.insert(achieveDatas,temp)
        end
        IllustrationHandle.achieveDatas = achieveDatas
    end

    return IllustrationHandle.achieveDatas
end

-- 获得头像
function IllustrationHandle.createHeroIcon(mouldId, isCombineCard)
    local picIndex = nil

    if isCombineCard then
        local combine_card_data = IllustrationHandle.getCombineCardDataByCardId(mouldId)
        picIndex = tonumber(combine_card_data[ship_illustration_card_mould.combine_img_id])
    else
        -- 挂上卡牌icon
        local evo_image = dms.string(dms["ship_mould"], tonumber(mouldId), ship_mould.fitSkillTwo)
        if not evo_image then
            return nil
        end
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local evo_mould_id = 0
        local ship = fundShipWidthTemplateId(tonumber(mouldId))
        if ship ~= nil then
            local ship_evo = zstring.split(ship.evolution_status, "|")
            evo_mould_id = smGetSkinEvoIdChange(ship)
        else
            local captain_name = dms.int(dms["ship_mould"], tonumber(mouldId), ship_mould.captain_name)
            evo_mould_id = evo_info[captain_name]
        end
        picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    end
    local icons = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
    return icons        
end

-- 获得颜色
function IllustrationHandle.getStringColor(strData)

    local strColorDatas = zstring.split(strData,",")
    local colors = {}
    for i,v in ipairs(strColorDatas) do
        colors[i] = tonumber(v)
    end
	local color = cc.c3b(colors[1],colors[2],colors[3])

    return color
end


-- 红点推送添加正常
function IllustrationHandle.pushTipControl(_sender,flag)
    if flag then
        if _sender._istips == nil or _sender._istips == false then
            local ball = cc.Sprite:create("images/ui/bar/tips.png")
            ball:setAnchorPoint(cc.p(1.0, 1.0))
            ball:setPosition(cc.p(_sender:getContentSize().width-ball:getContentSize().width*0.5, _sender:getContentSize().height-ball:getContentSize().height*0.5))
            _sender:addChild(ball)
            _sender._nodeChild = ball
            _sender._istips = true
        end
    else
        if _sender._istips == true then
            _sender:removeChild(_sender._nodeChild, true)
            _sender._nodeChild = nil
            _sender._istips = false
        end
    end
end

-- ======================================================
-- 组合卡册数据表数据（存储卡册模板Id）
function IllustrationHandle.getCombineCards()
    local combineCards = {}

    local count = dms.count(dms["card_mould"])
    for i = 1, count do
        local ship_group_str = dms.string(dms["card_mould"], i, ship_illustration_card_mould.ship_group)
        local ship_group = zstring.split(ship_group_str, ",")

        if tonumber(ship_group[1]) > 0 then
            local cardMouldId = dms.int(dms["card_mould"], i, ship_illustration_card_mould.id)
            table.insert(combineCards, cardMouldId)
        end
    end
    return combineCards
end

-- 获得排序好的组合卡册ID
function IllustrationHandle.getSortCombineCards()
    local combineCards = IllustrationHandle.getCombineCards()

    local function sortFunction(a, b)
        local result = false
        local cardA = IllustrationHandle.getCardDataByCardMouldId(a)
        local cardB = IllustrationHandle.getCardDataByCardMouldId(b)
        if cardA and cardB then
            local k1 = tonumber(cardA.cardScore)
            local k2 = tonumber(cardB.cardScore)
            if k1 > k2 then
                result =  true
            end
        end
        
        return result 
    end

    local finalList = {}    -- 最終卡列表
    local canUnlock = {}    -- 可激活
    local canUpLevel = {}   -- 可升级
    local haveUnlock = {}   -- 已激活
    local lock = {}         -- 未激活 

    for k, v in pairs(combineCards) do
        local combineCardData = IllustrationHandle.getCombineCardDataByCardId(v)
        local canUnlockFlag = IllustrationHandle.getCombineCardCanUnlock(combineCardData)
        local canLevelUpFlag = IllustrationHandle.getFlagLevelup(v, true)
        local cardDatas = IllustrationHandle.getCardDataByCardMouldId(v)

        if cardDatas == nil and canUnlockFlag == true then
            table.insert(canUnlock, v)
        elseif canLevelUpFlag == true then
            table.insert(canUpLevel, v)
        elseif cardDatas ~= nil then
            table.insert(haveUnlock, v)
        else
            table.insert(lock, v)
        end
    end

    table.sort(canUnlock, sortFunction)
    table.sort(canUpLevel, sortFunction)
    table.sort(haveUnlock, sortFunction)
    table.sort(lock, sortFunction)

    for k, v in pairs(canUnlock) do
        table.insert(finalList, v)
    end

    for k, v in pairs(canUpLevel) do
        table.insert(finalList, v)
    end

    for k, v in pairs(haveUnlock) do
        table.insert(finalList, v)
    end

    for k, v in pairs(lock) do
        table.insert(finalList, v)
    end
    
    return finalList
end

-- 通过cardMouldId获取组合卡册数据表数据
function IllustrationHandle.getCombineCardDataByCardId(cardMouldId)
    local cardDatas = dms.searchs(dms["card_mould"], 1, cardMouldId)
    return cardDatas[1]
end

-- 通过cardId查找服务器对应卡册数据
function IllustrationHandle.getCardDataByCardMouldId(cardMouldId)
    if nil == _ED.illustration_info_init then
        return nil
    end

    local preCardData = nil
    local cardInfo = _ED.illustration_info_init.userCardInfoList
    if cardInfo and 0 ~= #cardInfo then
        for k,v in pairs(cardInfo) do
            if tonumber(v.cardMouldId) == tonumber(cardMouldId) then
                preCardData = v
                break
            end
        end
    end
    return preCardData
end

-- 判断
function IllustrationHandle.judgeCardIsCombineCard(cardMouldId)
    local isCombineCard = false
    local combineCard = IllustrationHandle.getCombineCardDataByCardId(cardMouldId)
    local ship_group = zstring.split(combineCard[3], ",")
    if tonumber(ship_group[1]) > 0 then
        isCombineCard = true
    end
    return isCombineCard
end

-- 判断组合卡册 里面是否有可激活的卡/或可升级的卡(组合按钮上的红点显示)
function IllustrationHandle.getCombineCardShowRedPoint()
    local combineCards = IllustrationHandle.getCombineCards()
    for _, v in pairs(combineCards) do
        local combineCardData = IllustrationHandle.getCombineCardDataByCardId(v)
        local canUnlock = IllustrationHandle.getCombineCardCanUnlock(combineCardData)
        local canLevelUp = IllustrationHandle.getFlagLevelup(v, true)
        local cardDatas = IllustrationHandle.getCardDataByCardMouldId(v)

        if canLevelUp == true then
            return true
        else
            if cardDatas == nil and canUnlock == true then
                return true
            end
        end
    end
    return false
end

-- 组合卡册能否激活
function IllustrationHandle.getCombineCardCanUnlock(combineCardData)
    local baseCondition = false

    -- 普通条件
    local ship_list = IllustrationHandle.getBaseConditionList(combineCardData)

    local activiteNum = 0
    local maxNum = table.nums(ship_list)

    for _, v in pairs(ship_list) do
        local ship_mould_id = tonumber(v)
        local cardDatas = IllustrationHandle.getCardDataByShipMouldId(ship_mould_id)
        if cardDatas and cardDatas.cardStar >= 7 then
            activiteNum = activiteNum + 1
        end
    end

    baseCondition = activiteNum >= maxNum

    if baseCondition == false then 
        return baseCondition
    end

    -- 特殊条件
    local specialCondition = IllustrationHandle.isSpecialTaskAllFinished(combineCardData)

    return baseCondition and specialCondition
end

function IllustrationHandle.getBaseConditionList(combineCardData)
    local list = {}
    local ship_group_str = combineCardData[ship_illustration_card_mould.ship_group]
    local ship_group = zstring.split(ship_group_str, ",")
    for _, v in pairs(ship_group) do
        table.insert(list, tonumber(v))
    end
    return list
end

function IllustrationHandle.getSpecialConditionList(combineCardData)
    local list = {}
    local special_condition_str = combineCardData[ship_illustration_card_mould.special_condition]
    local special_condition = zstring.split(special_condition_str, ",")

    for k, v in pairs(special_condition) do
        local conditionId = tonumber(v)
        table.insert(list, conditionId)
    end
    return list
end

-- 组合卡册的特殊任务是否全部完成
function IllustrationHandle.isSpecialTaskAllFinished(combineCardData)
    local finishCount, maxNum = IllustrationHandle.getSpecialTaskFinishedCount(combineCardData)
    return finishCount >= maxNum
end

-- 组合卡册的单个特殊任务是否完成
function IllustrationHandle.isSpecialTaskFinished(cardMouldId, conditionIndex)
    local isFinish = false
    local curProgress = 0

    local index = conditionIndex - 1

    local comb_card_info = _ED.illustration_comb_card_info
    for _, v in pairs(comb_card_info) do
        if tonumber(v.cardMouldId) == cardMouldId then
            isFinish = v["condition" .. index].status
            curProgress = v["condition" .. index].currentProcess
            break
        end
    end

    return isFinish, curProgress
end

-- 组合卡册的特殊任务完成数量
function IllustrationHandle.getSpecialTaskFinishedCount(combineCardData, onlyHideCondition)
    local finishCount = 0

    local special_condition_str = combineCardData[ship_illustration_card_mould.special_condition]
    local special_condition = zstring.split(special_condition_str, ",")

    local maxNum = table.nums(special_condition)
    local cardMouldId = tonumber(combineCardData[ship_illustration_card_mould.id])

    local condition_is_hide_str = combineCardData[ship_illustration_card_mould.is_hide]
    local condition_is_hide = zstring.split(condition_is_hide_str, ",")

    for k, v in pairs(special_condition) do
        local is_hide = tonumber(condition_is_hide[k])
        local isFinish = IllustrationHandle.isSpecialTaskFinished(cardMouldId, k)

        -- 如果只计算隐藏的特殊任务的数量
        if onlyHideCondition then
            if isFinish and (is_hide == 1) then
                finishCount = finishCount + 1
            end
        else
            if isFinish then
                finishCount = finishCount + 1
            end
        end
    end

    return finishCount, maxNum
end

-- 根据cardMouldID获得卡册的最大等级
function IllustrationHandle.getCombineCardMaxLevel(cardMouldId)
    local qualityNum = cardMouldId
    local elements = dms.searchs(dms["card_unblock"], ship_illustration_consume_mould.ability, qualityNum)
    local maxLevel = table.nums(elements) - 1
    return maxLevel
end

-- 计算有多少个隐藏的任务完成(还未激活的组合卡册)
function IllustrationHandle.getHideConditionFinishCount()
    local count = 0
    local cardMouldIDs = {}

    local combineCards = IllustrationHandle.getCombineCards()

    for _, v in pairs(combineCards) do        
        local cardDatas = IllustrationHandle.getCardDataByCardMouldId(v)
        if cardDatas == nil then
            local combineCardData = IllustrationHandle.getCombineCardDataByCardId(v)
            local finishCount = IllustrationHandle.getSpecialTaskFinishedCount(combineCardData, true)

            if finishCount > 0 then
                table.insert(cardMouldIDs, v)
            end

            count = count + finishCount
        end
    end

    return count, cardMouldIDs
end

-- DB2重塑,获得策划表是否配置组合卡册
function IllustrationHandle.isCombineCardConfig()
    local count = dms.count(dms["card_mould"])
    for i = 1, count do
        local shipId = dms.string(dms["card_mould"], i, ship_illustration_card_mould.ship_id)
        if tonumber(shipId) == -1 then 
            return true
        end
    end
    return false
end

-- DB2重塑,获得策划表是否配置对应资质卡册
function IllustrationHandle.isQualityCardConfig(quailty)
    local count = dms.count(dms["card_mould"])
    for i = 1, count do
        local shipId = dms.string(dms["card_mould"], i, ship_illustration_card_mould.ship_id)
        if tonumber(shipId) ~= -1 then 
            local ability = dms.int(dms["ship_mould"], shipId, ship_mould.ability)
            if ability == quailty then
                return true
            end
        end
    end
    return false
end
