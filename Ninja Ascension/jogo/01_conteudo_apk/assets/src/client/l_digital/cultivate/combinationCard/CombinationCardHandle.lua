--[[
    组合卡数据处理类
    author: Rock
    time:2019-10-25 17:51:39
--]]

CombinationCardHandle = CombinationCardHandle or {}
CombinationCardHandle.redCount = 0
CombinationCardHandle.cardRedDatas = {}
CombinationCardHandle.shipIdListDatas = nil  -- 组合卡列表shipId 缓存
-- 获得组合卡列表shipId
function CombinationCardHandle.getCardList()
    if CombinationCardHandle.shipIdListDatas then
        return CombinationCardHandle.shipIdListDatas
    end
    local shipNum = dms.count(dms["comb_mould"])
    local shipIdList = {}
    for i=1,tonumber(shipNum) do
        local elementShip = dms.element(dms["comb_mould"],i)
        local shipId = dms.atos(elementShip,ship_combination_card_mould.ship_id)
        shipIdList[i] = shipId
    end
   return shipIdList
end

-- 某张卡是不是组合卡
function CombinationCardHandle.getIsCombCard(mouldId)
    for k, v in pairs(CombinationCardHandle.getCardList()) do
        if tonumber(mouldId) == tonumber(v) then
            return true
        end
    end
    return false
end

--根据ShipId获得组合卡行数据
function CombinationCardHandle.getRowByShipId(shipId)
    for i=1,dms.count(dms["comb_mould"]) do
        local elementShip = dms.element(dms["comb_mould"],i)
        local shipIdTemp = dms.atoi(elementShip,ship_combination_card_mould.ship_id)

        if shipIdTemp == tonumber(shipId) then
            local elementData = elementShip
            return elementData
        end
    end
    
    return nil 
end

--根据ship获得排序因子
function CombinationCardHandle.getSortByShipId(shipId)
    local elementData = CombinationCardHandle.getRowByShipId(shipId)
    local sortNum = dms.atoi(elementData,ship_combination_card_mould.card_sort)

    return sortNum
end

--根据ShipId获得单个配置数据
function CombinationCardHandle.getPerMouldByShipId(shipId,mouldIndex)
    local elementData = CombinationCardHandle.getRowByShipId(shipId)
    local perData = dms.atoi(elementData,mouldIndex)

    return perData
end

--根据ShipId获得单个配置数据(string)
function CombinationCardHandle.getPerMouldStrByShipId(shipId,mouldIndex)
    local elementData = CombinationCardHandle.getRowByShipId(shipId)
    local perData = dms.atos(elementData,mouldIndex)

    return perData
end

--根据ShipId获得解锁条件
function CombinationCardHandle.unLockConditionByShipId(shipId, conditionIndex)
    local elementData = CombinationCardHandle.getRowByShipId(shipId)
    local mouldData = dms.atos(elementData, conditionIndex)

    if nil ~= tonumber(mouldData) or -1 == tonumber(mouldData) then
        return nil
    else
        local conDatas = zstring.split(mouldData, "|")
        local datas = {}
        datas.ship_id = conDatas[1]                 -- id
        datas.star_level = conDatas[2]              -- 星级
        datas.eight_level = conDatas[3]             -- 八门
        datas.fight_effect = conDatas[4]            -- 战斗力
        return datas
    end
end

-- 解锁消耗道具
function CombinationCardHandle.unLockConsumeByShipId(shipId)
    local elementData = CombinationCardHandle.getRowByShipId(shipId)
    local mouldData = dms.atos(elementData, ship_combination_card_mould.unlock_consume_prop)
    local consumeDatas = zstring.split(mouldData, "|")
    return consumeDatas
end

-- 获得组合卡武将名字
function CombinationCardHandle.getNameByShipId(shipId)
    local mouldData = CombinationCardHandle.getPerMouldByShipId(shipId,ship_combination_card_mould.card_name)
    local card_word = dms.element(dms["word_mould"], mouldData)
	local name = card_word[3]

    return name
end

-- 获得武将名字
function CombinationCardHandle.getHeroNameByShipId(shipId)
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], shipId, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id =  evo_info[dms.int(dms["ship_mould"], shipId, ship_mould.captain_name)]
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local hero_name = word_info[3]

    return hero_name
end

-- 获得槽位数据
function CombinationCardHandle.getSoltDatas(shipId)
    local startIndex = ship_combination_card_mould.solt_ship_id_one
    local soltDatas = {}
    for i=1,7 do
        local perShipId = CombinationCardHandle.getPerMouldByShipId(shipId,startIndex)
        startIndex = startIndex + 1
        if -1 ~= tonumber(perShipId)  then
            table.insert(soltDatas,perShipId)
        end
    end

    return soltDatas
end

-- 根据槽位库组获得升级或进阶模型
function CombinationCardHandle.getSoltMould(groupId,levelId)
    local mouldDatas = nil

    if nil == levelId then
        levelId = 1
    end

    for i=1,dms.count(dms["comb_inset"]) do
        local elementShip = dms.element(dms["comb_inset"],i)
        local group_id = dms.atoi(elementShip,ship_combination_card_level_mould.group_id)
        local level_id = dms.atoi(elementShip,ship_combination_card_level_mould.level)

        if group_id == tonumber(groupId) and level_id == tonumber(levelId) then
            mouldDatas = elementShip
        end
    end

    return mouldDatas
end

-- 根据槽位库组获得升级或进阶消耗
function CombinationCardHandle.getSoltConsume(groupId,levelId,curBreak)
    local isUpLevel = true  -- 是升级还是升阶
    if nil == curBreak then
        curBreak = 1
    end
    local elementShip = CombinationCardHandle.getSoltMould(groupId,levelId)
    if nil == elementShip then
        return  nil
    end
    local consumeDatas = dms.atos(elementShip,ship_combination_card_level_mould.up_consume)
    local break_id = dms.atoi(elementShip,ship_combination_card_level_mould.breake_level)
    local break_consume = dms.atos(elementShip,ship_combination_card_level_mould.breake_consume)
    if break_id == tonumber(curBreak) and -1 ~= tonumber(break_consume) then
        isUpLevel = false
        consumeDatas = break_consume
    end

    if consumeDatas then
        consumeDatas = zstring.split(consumeDatas,"|")
    end
    return consumeDatas,isUpLevel
end

-- 根据资质和升阶等级获得进阶或者上卡槽位条件
function CombinationCardHandle.getBreakCondition(curBreak)
    for i=1,dms.count(dms["comb_inset_param"]) do
        local elementShip = dms.element(dms["comb_inset_param"],i)
        local break_id = dms.atoi(elementShip,ship_combination_card_add_mould.level)

        if break_id == tonumber(break_id) then
            local mouldData = dms.atos(elementShip,ship_combination_card_add_mould.condition)
            local conDatas = zstring.split(mouldData, "|")
            local datas = {}
            datas.star_level = conDatas[1]              -- 星级
            datas.eight_level = conDatas[2]             -- 八门
            datas.fight_effect = conDatas[3]            -- 战斗力
            return datas
        end
    end

    return nil
end


-- 根据槽位库组获得槽位基础加成
function CombinationCardHandle.getSoltAdd(groupId,levelId)

    local elementShip = CombinationCardHandle.getSoltMould(groupId,levelId)

    local addDatas = dms.atos(elementShip,ship_combination_card_level_mould.add_params)
    addDatas = zstring.split(addDatas,"|")

    return addDatas
end

-- 获得颜色
function CombinationCardHandle.getStringColor(strData)

    local strColorDatas = zstring.split(strData,",")
    local colors = {}
    for i,v in ipairs(strColorDatas) do
        colors[i] = tonumber(v)
    end
	local color = cc.c3b(colors[1],colors[2],colors[3])

    return color
end

-- 根据槽位id获取服务器单个槽位信息
function CombinationCardHandle.getOneSoltInfoById(soltId)
    local soltId = tonumber(soltId) - 1
    if _ED.one_card_solt_infos then 
        for k,v in pairs(_ED.one_card_solt_infos) do
            if tonumber(k) == soltId then 
                return v
            end
        end
    end

    return nil
end

-- 根据shipMouldId判断卡是否解锁
function CombinationCardHandle.getCardStateById(cardId)
    for i,v in ipairs(_ED.combine_card_list_info.comb_mould_list) do
        if tonumber(v.shipId) == tonumber(cardId) then
            return v.isUnlock
        end
    end

    return false
end

-- 获得基础加成属性
function CombinationCardHandle.getAddProperty(soltId)
    local propertyData = {}
    if -1 == tonumber(soltId) then
        propertyData = zstring.split(_ED.one_card_total_addition,"|")
    else
        propertyData = zstring.split(CombinationCardHandle.getOneSoltInfoById(soltId).oneSlotAddition,"|")
    end    
        
    return propertyData
end

-- 八门难度加成
function CombinationCardHandle.getMegaProperty(shipId)
    local megalv = 0
    local heroinfo = {}
    for k,v in pairs(_ED.mega_info) do
        if tonumber(v.shipId) == tonumber(shipId) then
            megalv = 0
            heroinfo = v.info
            heroinfo = json.decode(heroinfo)
            if heroinfo.megaLevel then
                for k,v in pairs(heroinfo.megaLevel) do
                    megalv = megalv + 1
                end
            end
        end
    end

    return megalv
end


-- 获得槽位解锁道具和条件
function CombinationCardHandle.getSoltUnlockCondition(mouldId,soltId)
    local unlockSoltData = dms.string(dms["play_config"], 180, pirates_config.param)
    local unlockCondition = nil
    local condition = CombinationCardHandle.getPerMouldStrByShipId(mouldId,(ship_combination_card_mould.card_sort + soltId))
    if condition and -1 ~= tonumber(condition) then
        unlockCondition = {}
        local datas = zstring.split(condition,"|")
        for k,v in pairs(datas) do
            local conData = {}
            local data = zstring.split(v,",")
            conData.type = tonumber(data[1])
            conData.level = tonumber(data[2])
            table.insert( unlockCondition,conData)
        end
    end
    return unlockSoltData,unlockCondition
end


-- 根据mouldId返回星级,八门,战力
function CombinationCardHandle.getCurDataByMouldId(mouldId)
    local shipData = getStrongestShipByTemplateId(mouldId)
    --八门阶数
    local heroinfo = {}
    if shipData then
        for k,v in pairs(_ED.mega_info) do
            if v.shipId == tonumber(shipData.ship_id) then
                heroinfo = v.info
                break
            end
        end
    end

    local lv = 0
    local sonLv = 0
    if #heroinfo ~= 0 then
        heroinfo = json.decode(heroinfo)
        local megaLevelDatas = heroinfo.megaLevel
        for k,v in pairs(megaLevelDatas) do
            sonLv = v
            lv = lv + 1
        end
    end
    
    -- 星级数
    local curStar = 0
    if shipData then
        curStar = tonumber(shipData.StarRating)
    end
    -- 战力数
    local cur_fight = 0

    if shipData then
        cur_fight = shipData.hero_fight
        if cur_fight == nil or cur_fight == "" then
            local ship_info = getShipByTalent(shipData)
            cur_fight = math.ceil(ship_info.hero_fight)
        end
    end
    return tonumber(curStar),tonumber(lv),tonumber(sonLv),tonumber(cur_fight)
end

-- 返回固定槽位等级总和
function CombinationCardHandle.getCurLevelByMouldId(mouldId)
    local soltTotal = 0
    if _ED.one_card_solt_infos then 
        for k,v in pairs(_ED.one_card_solt_infos) do
            if v.defaultShipId > 0 then 
                soltTotal = soltTotal + tonumber(v.slotLevel)
            end
        end
    end
    return soltTotal
end


-- 某张组合卡是否可以解锁
function CombinationCardHandle.getCanUnlockByMouldId(mouldId)
    --卡是否解锁
    local CardState = CombinationCardHandle.getCardStateById(mouldId)
    if CardState then
        return false
    end
	local conditionNum = CombinationCardHandle.getPerMouldByShipId(mouldId,ship_combination_card_mould.solt_num)

	-- 解锁条件
	for i=1,conditionNum do
        local conDatas = CombinationCardHandle.unLockConditionByShipId(mouldId, ship_combination_card_mould.solt_num + i)
        local shipDatas = getStrongestShipByTemplateId(conDatas.ship_id)
		if shipDatas then
            local curStar,lv,sonLv,curFight = CombinationCardHandle.getCurDataByMouldId(tonumber(conDatas.ship_id))
			if tonumber(lv) >= tonumber(zstring.split(conDatas.eight_level,",")[1]) 
				and tonumber(sonLv) >= tonumber(zstring.split(conDatas.eight_level,",")[2]) 
					and tonumber(shipDatas.StarRating) >= tonumber(conDatas.star_level)
						and tonumber(curFight) >= tonumber(conDatas.fight_effect) 
							then				
			else
				return false
			end
        else
            return false
        end
	end

	-- 解锁消耗
	local propConsumeDatas = CombinationCardHandle.unLockConsumeByShipId(mouldId)
	for i=1,#propConsumeDatas do
		local propDatas = zstring.split(propConsumeDatas[i],",")
		local propId = tonumber(propDatas[2])
		local aimNum = tonumber(propDatas[3])

        local haveNum = 0
        local fundProp = fundPropWidthId(propId)
		if fundProp then
			haveNum = fundProp.prop_number
		end

		if tonumber(haveNum) >= aimNum then
		else
			return false
		end
	end
	return true
end

-- 是否有可解锁组合卡
function CombinationCardHandle.getCombinationCardIsUnlock()
	if _ED.combine_card_list_info then
		for k,v in pairs(_ED.combine_card_list_info.comb_mould_list) do
			if not v.isUnlock then
				local mouldId = v.shipId
				return CombinationCardHandle.getCanUnlockByMouldId(mouldId)
			end
		end
	end
	return false
end

-- 是否有卡的槽位可以解锁
function CombinationCardHandle.getSoltIsUnlock()
	if _ED.combine_card_list_info then
		for k,v in pairs(_ED.combine_card_list_info.comb_mould_list) do
			if v.isUnlock then
				local mouldId = v.shipId
				return getSoltCanUnlockByMouldId(mouldId)
			end
		end
	end
	return false
end

-- 某个卡是否有槽位可以解锁
function CombinationCardHandle.getSoltCanUnlockByMouldId(mouldId)
    --卡是否解锁
    local CardState = CombinationCardHandle.getCardStateById(mouldId)
    if not CardState then
        return false
    end
    local slotNumNimble = CombinationCardHandle.getPerMouldByShipId(mouldId,ship_combination_card_mould.solt_num) + 1
    for i = slotNumNimble,7 do
        if CombinationCardHandle.getOneSoltInfoById(i) then
            local soltState = tonumber(CombinationCardHandle.getOneSoltInfoById(i).shipId)
            if 0 > soltState then
                if CombinationCardHandle.getSoltCanUnlockBySoltId(mouldId,i) then
                    return true
                end
            end
        end
    end
    return false
end

-- 某个卡的某个槽位是否可以解锁
function CombinationCardHandle.getSoltCanUnlockBySoltId(mouldId,soltId)
    local conditionData,condition = CombinationCardHandle.getSoltUnlockCondition(mouldId, soltId)
    local canAimFlag = true
    -- 条件
	if condition then
		local conNum = #condition
		for i=1,conNum do
			local conData = condition[i]
			local type = conData.type
			local level = conData.level
			if 0 == type then
				local totalLevel = CombinationCardHandle.getCurLevelByMouldId(mouldId)
				if totalLevel >= level then
				else
                    canAimFlag = false
                    return canAimFlag
				end
			else
				local curLevel = CombinationCardHandle.getOneSoltInfoById(type).slotLevel
				if curLevel >= level then
				else
                    canAimFlag = false
                    return canAimFlag
				end
			end
		end
	end
    -- 道具
    local consumeData = zstring.split(conditionData,",")
	local propType = 6
	local propId = tonumber(consumeData[1])

	local haveNum = 0
	local aimNum = tonumber(consumeData[2])
	if propType == 1 then
		haveNum = _ED.user_info.user_silver
	elseif propType == 2 then
		haveNum = _ED.user_info.user_gold
    else
        local fundProp = fundPropWidthId(propId)
		if fundProp then
			haveNum = fundProp.prop_number
		end
    end
    
    if tonumber(haveNum) < aimNum then
        canAimFlag = false
    end
    return canAimFlag
end

-- 某个卡是否符合上阵条件
function CombinationCardHandle.getCardCanPitch(soltId,mouldId)
    local slotCalss = CombinationCardHandle.getOneSoltInfoById(soltId).slotClass
    local soltLimitCondition = CombinationCardHandle.getBreakCondition(slotCalss)
    local curStar,lv,sonLv,curFight = CombinationCardHandle.getCurDataByMouldId(tonumber(mouldId))
    local starNumLimit = tonumber(soltLimitCondition.star_level)
    if curStar < starNumLimit then
        return false
    end

    local eightLvs = zstring.split(soltLimitCondition.eight_level,",")
    local shipStepLv = tonumber(eightLvs[1])
    local shipStepSonLv = tonumber(eightLvs[2])
    if lv < shipStepLv and sonLv < shipStepSonLv then
        return false
    end

    local aimCombat = tonumber(soltLimitCondition.fight_effect)
    if curFight < aimCombat then
        return false
    end

    return true
end

-- 任意槽位是否可上阵固定卡
function CombinationCardHandle.getUpFlag(mouldId,templeId)
    local soltData = CombinationCardHandle.getSoltDatas(mouldId)
    for k,v in pairs(soltData) do
        if tonumber(v) == tonumber(templeId) then
            return false
        end
    end
    return true
end

-- 某个槽位有多少卡可上阵
function CombinationCardHandle.getCanAddCardUp(mouldId,soltId,canMouldId,haveMouldId)
    local number = 0
    if 0 < tonumber(haveMouldId) then
		number = number + 1
	end
    if -1 == tonumber(canMouldId) then
        number = #CombinationCardHandle.getCanAddCardDatas(mouldId,soltId) + number
    else
        if CombinationCardHandle.getCanAddFixCardDatas(canMouldId) then
            number = number + 1
        end
    end

    return number
end

-- 红点推送添加小
function CombinationCardHandle.pushTipControlSmall(_sender,flag,mouldId)
    if flag then
        if _sender._istips == nil or _sender._istips == false then
            local ball = cc.Sprite:create("images/ui/bar/tips.png")
            ball:setAnchorPoint(cc.p(0.4, 0.4))
            ball:setScale(0.5)
            ball:setPosition(cc.p(_sender:getContentSize().width-ball:getContentSize().width*0.5, _sender:getContentSize().height-ball:getContentSize().height*0.5))
            _sender:addChild(ball)
            _sender._nodeChild = ball
            _sender._istips = true
            CombinationCardHandle.redCount = CombinationCardHandle.redCount + 1
            local haveFlag = false
            for k,v in pairs(CombinationCardHandle.cardRedDatas) do
                if tonumber(v.mouldId) == tonumber(mouldId) then
                    v.count = v.count + 1
                    haveFlag = true
                end
            end
            if not haveFlag then
                local cardTypeData = {}
                cardTypeData.mouldId = mouldId
                cardTypeData.count = 1
                table.insert(CombinationCardHandle.cardRedDatas,cardTypeData)
            end
        end
    else
        if _sender._istips == true then
            _sender:removeChild(_sender._nodeChild, true)
            _sender._nodeChild = nil
            _sender._istips = false
        end
        if 0 < CombinationCardHandle.redCount then
            CombinationCardHandle.redCount = CombinationCardHandle.redCount - 1
        end
        for k,v in pairs(CombinationCardHandle.cardRedDatas) do
            if tonumber(v.mouldId) == tonumber(mouldId) and 0 < v.count then
                v.count = v.count - 1
            end
        end
    end
end

-- 单卡红点计数
function CombinationCardHandle:getCardRedCountFlag(mouldId)
    if CombinationCardHandle.cardRedDatas then
        for k,v in pairs(CombinationCardHandle.cardRedDatas) do
            if tonumber(mouldId) == v.mouldId and 0 < v.count then
                return true
            end
        end
    end

    return false
end

-- 红点推送添加正常
function CombinationCardHandle.pushTipControl(_sender,flag)
    if flag then
        if _sender._istips == nil or _sender._istips == false then
            local ball = cc.Sprite:create("images/ui/bar/tips.png")
            ball:setAnchorPoint(cc.p(1.0, 1.0))
            ball:setPosition(cc.p(_sender:getContentSize().width-ball:getContentSize().width*0.5, _sender:getContentSize().height-ball:getContentSize().height*0.5))
            _sender:addChild(ball)
            _sender._nodeChild = ball
            _sender._istips = true
            CombinationCardHandle.redCount = CombinationCardHandle.redCount + 1
        end
    else
        if _sender._istips == true then
            _sender:removeChild(_sender._nodeChild, true)
            _sender._nodeChild = nil
            _sender._istips = false
        end
        if 0 < CombinationCardHandle.redCount then
            CombinationCardHandle.redCount = CombinationCardHandle.redCount - 1
        end
    end
end

-- 红点引用计数
function CombinationCardHandle.getRedCountFlag()
    if CombinationCardHandle.redCount < 1 then
        return false
    else
        return true
    end
end

-- 获得阶级颜色和后缀 
function CombinationCardHandle.getQualityColorByBreak(breakLevel)
    breakLevel = tonumber(breakLevel)
    local colour = 0
    local str = ""  -- 后缀
	if breakLevel <= 1 then
        colour = 1
        str = tipStringInfo_combination_card_quality[colour]
	elseif breakLevel <= 4 and breakLevel > 1 then
        colour = 2
        str = tipStringInfo_combination_card_quality[colour]
        if 0 < (breakLevel - 2) then
            str = str.." +"..(breakLevel - 2)
        end
	elseif breakLevel <= 7 and breakLevel > 4 then
        colour = 3
        str = tipStringInfo_combination_card_quality[colour]
        if 0 < (breakLevel - 5) then
            str = str.." +"..(breakLevel - 5)
        end
    elseif breakLevel <= 11 and breakLevel > 7 then
        colour = 4
        str = tipStringInfo_combination_card_quality[colour]
        if 0 < (breakLevel - 8) then
            str = str.." +"..(breakLevel - 8)
        end
	elseif breakLevel <= 15 and breakLevel > 11 then
        colour = 5
        str = tipStringInfo_combination_card_quality[colour]
        if 0 < (breakLevel - 12) then
            str = str.." +"..(breakLevel - 12)
        end
	else
        colour = 6
        str = tipStringInfo_combination_card_quality[colour]
        if 0 < (breakLevel - 16) then
            str = str.." +"..(breakLevel - 16)
        end
    end
    local colorData = cc.c3b(color_Type[colour][1],color_Type[colour][2],color_Type[colour][3])
	return colorData,str
end

-- 获得等级颜色
function CombinationCardHandle.getQualityColorByLevel(level)
    local colour = 0
    if level <= 20 and level >= 0 then
		colour = 1
	elseif level <= 50 and level > 20 then
		colour = 2
	elseif level <= 80 and level > 50 then
		colour = 3
	elseif level <= 120 and level > 80 then
		colour = 4
	elseif level <= 160 and level > 120 then
		colour = 5
	else
		colour = 6
    end

    local colorData = cc.c3b(color_Type[colour][1],color_Type[colour][2],color_Type[colour][3])
	return colorData
end

-- 组合卡是否上阵
function CombinationCardHandle.getIsUpLoadFlag(mouldId)
    if _ED.user_comb_has_field_mould_info then
        for k,v in pairs(_ED.user_comb_has_field_mould_info) do
            if tonumber(v.userCombShipId) == tonumber(mouldId) then
                return true
            end
        end
    end
    return false
end

-- 任意槽位可上阵卡数据
function CombinationCardHandle.getCanAddCardDatas(cardId,soltId)
    --组合卡数据
    local shipDatas = {}
    for k,v in pairs(CombinationCardHandle.getSortedHeroes()) do
        if (nil == v.combUpLockState or 0 == tonumber(v.combUpLockState)) 
                    and (nil == v.combLockState or 0 == tonumber(v.combLockState)) 
                        and (0 >= zstring.tonumber(v.formation_index) or nil == zstring.tonumber(v.formation_index)) 
                            and false == CombinationCardHandle.getIsCombCard(v.ship_template_id) 
                                and CombinationCardHandle.getCardCanPitch(soltId,v.ship_template_id) 
                                    and CombinationCardHandle.getUpFlag(cardId,v.ship_template_id) then
                                        table.insert(shipDatas,v)     
        end
    end

    
    return shipDatas
end

-- 固定槽位可上阵卡数据
function CombinationCardHandle.getCanAddFixCardDatas(canMouldId)
    local shipData = nil 
    for k,v in pairs(_ED.user_ship) do
        if tonumber(v.ship_template_id) == tonumber(canMouldId) then
            shipData = v
            return shipData
        end
    end
    return shipData
end

function CombinationCardHandle.getSortedHeroes()
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end

	local tSortedHeroes = {}
	-- 上阵武将数组
	local arrBusyHeroes = {}
	-- 各星级武将数组
	local arrStarLevelHeroesWhite = {}--白
	local arrStarLevelHeroesGreen = {}--绿
	local arrStarLevelHeroesKohlrabiblue= {}--蓝
	local arrStarLevelHeroesPurple = {}--紫
	local arrStarLevelHeroesOrange = {}--橙
	local arrStarLevelHeroesRed = {}--红
	local arrStarLevelHeroesGold = {}--金
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		for i, ship in pairs(_ED.user_ship) do
			if ship.ship_id ~= nil then
				if zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
					table.insert(arrBusyHeroes, ship)
				else
					table.insert(arrStarLevelHeroesWhite, ship)	
				end
			end
		end
		table.sort(arrBusyHeroes, fightingCapacity)
		table.sort(arrStarLevelHeroesWhite, fightingCapacity)
		for i=1, #arrBusyHeroes do
			table.insert(tSortedHeroes, arrBusyHeroes[i])
		end
		for i=1, #arrStarLevelHeroesWhite do
			table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
		end
	else
		-- 主角放在第一位
		for i, ship in pairs(_ED.user_ship) do
			if ship.ship_id ~= nil then
				local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
				local captain_type = dms.atoi(shipData, ship_mould.captain_type)
				if captain_type == 0 then
					tSortedHeroes[1] = ship
				elseif zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
					table.insert(arrBusyHeroes, ship)
				else
					if captain_type ~= 3 then 
						if dms.atoi(shipData, ship_mould.ship_type) == 0 then
							table.insert(arrStarLevelHeroesWhite, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
							table.insert(arrStarLevelHeroesGreen, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
							table.insert(arrStarLevelHeroesKohlrabiblue, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
							table.insert(arrStarLevelHeroesPurple, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
							table.insert(arrStarLevelHeroesOrange, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
							table.insert(arrStarLevelHeroesRed, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
							table.insert(arrStarLevelHeroesGold, ship)
						end 
					end
				end
			end
		end
		table.sort(arrBusyHeroes, fightingCapacity)
		table.sort(arrStarLevelHeroesWhite, fightingCapacity)
		table.sort(arrStarLevelHeroesGreen, fightingCapacity)
		table.sort(arrStarLevelHeroesKohlrabiblue, fightingCapacity)
		table.sort(arrStarLevelHeroesPurple, fightingCapacity)
		table.sort(arrStarLevelHeroesOrange, fightingCapacity)
		table.sort(arrStarLevelHeroesRed, fightingCapacity)
		table.sort(arrStarLevelHeroesGold, fightingCapacity)
		-- 把已排序好的上阵武将加入到 武将排序数组中
		for i=1, #arrBusyHeroes do
			table.insert(tSortedHeroes, arrBusyHeroes[i])
		end
		for i=1, #arrStarLevelHeroesGold do
			table.insert(tSortedHeroes, arrStarLevelHeroesGold[i])
		end
		for i=1, #arrStarLevelHeroesRed do
			table.insert(tSortedHeroes, arrStarLevelHeroesRed[i])
		end
		for i=1, #arrStarLevelHeroesOrange do
			table.insert(tSortedHeroes, arrStarLevelHeroesOrange[i])
		end
		for i=1, #arrStarLevelHeroesPurple do
			table.insert(tSortedHeroes, arrStarLevelHeroesPurple[i])
		end
		for i=1, #arrStarLevelHeroesKohlrabiblue do
			table.insert(tSortedHeroes, arrStarLevelHeroesKohlrabiblue[i])
		end
		for i=1, #arrStarLevelHeroesGreen do
			table.insert(tSortedHeroes, arrStarLevelHeroesGreen[i])
		end
		for i=1, #arrStarLevelHeroesWhite do
			table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
		end
	end
	
	return tSortedHeroes
end

-- 获取每一组数据中，升级消耗的道具内容
function CombinationCardHandle.getUpgradeConsumePropByData(columnData, slotClass)
    local consumePropString = ""
    local consumePropInfo = {}
    local upgradeConsume = dms.atos(columnData, ship_combination_card_level_mould.up_consume)
    local breakConsume = dms.atos(columnData, ship_combination_card_level_mould.breake_consume)
    local curClassLevel = dms.atoi(columnData, ship_combination_card_level_mould.breake_level)

	consumePropString = upgradeConsume
    -- 若该库组小于玩家的库组，则不计入进阶材料
    if tonumber(breakConsume) ~= -1 and curClassLevel >= slotClass then
        consumePropString = upgradeConsume .. "|" .. breakConsume
    end
    consumePropInfo = zstring.splits(consumePropString, "|", ",", tonumber)
    
    return consumePropInfo
end

-- 获取该库组所有的数据
function CombinationCardHandle.getAllDatasByGroupID(groupId)
	local allDatasInfo = dms.searchs(dms["comb_inset"], comb_inset.groupId, groupId) 
	return allDatasInfo
end
