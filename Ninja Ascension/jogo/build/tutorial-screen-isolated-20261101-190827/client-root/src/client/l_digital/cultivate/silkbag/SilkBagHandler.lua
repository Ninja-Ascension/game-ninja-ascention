--[[
    author:Rock
    time:2019-05-30 17:32:06
]]

SilkBagHandler = SilkBagHandler or {}

function SilkBagHandler.getBreakeConsumeByLevel(curLevel,silkMouldId,propId,breakeLevel)
    local breakeInfo = {}

    local breakeLibId = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.breake_group) 
    local breakeLib =dms.searchs(dms["silk_bag_break_group_mould"],ship_silk_bag_breake.lib_id,breakeLibId,ship_silk_bag_breake.cur_breake_level,breakeLevel)

    local shipConfig = breakeLib[1][ship_silk_bag_breake.breake_consume]
    local shipConfigInfo = zstring.split(shipConfig,",")
    if -1 ~= tonumber(shipConfigInfo[1]) then
        breakeInfo.prop_id = shipConfigInfo[1]
        breakeInfo.prop_type = shipConfigInfo[2]
		breakeInfo.prop_num = shipConfigInfo[3]
		return breakeInfo
	end
	
    return nil
end


--根据等级获取升级经验
function SilkBagHandler.getExpByLevel(level,silkMouldId)
    local levelLibId = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.upgrade_group) 
    local levelLib = dms.searchs(dms["silk_bag_level_up_group_mould"],ship_silk_bag_level.lib_id,levelLibId)

    for k,v in pairs(levelLib) do
        local rangeLevel = zstring.split(v[ship_silk_bag_level.cur_level_range],",")

        if tonumber(level) >= tonumber(rangeLevel[1]) and tonumber(level) <= tonumber(rangeLevel[2]) then
            local growLevelExp = levelLib[k][5]
            return growLevelExp
        end
    end
    return nil
end


function SilkBagHandler.openConfirmTip()
	function showConfirmTip(instance,n)

	end
	app.load("client.utils.ConfirmTip")
	local tip = ConfirmTip:new()
	tip:init(instance, showConfirmTip, tipStringInfo_rescue_silkbag[1])
	fwin:open(tip,fwin._ui)
end


function SilkBagHandler.comeAutoUpgradeFlag(curLevel,silkMouldId,breakeLevel,curExp)
    local aimLevel = curLevel + 1
    -- 先校验突破
    if SilkBagHandler.getBreakeConsume(aimLevel,silkMouldId,breakeLevel) then
        local breakConsumeDatas = SilkBagHandler.getBreakeConsume(aimLevel,silkMouldId,breakeLevel)
        local needNumber = breakConsumeDatas.prop_num
        local existNumber = tonumber(getPropAllCountByMouldId(breakConsumeDatas.prop_type))
        if tonumber(needNumber) > tonumber(existNumber) then
            return false
        end
    end

    -- 再校验升级
    local needExP = SilkBagHandler.getExpByLevel(curLevel,silkMouldId,breakeLevel)
    local curTotalExp = curExp
    local shipConfig = dms.string(dms["ship_config"],45,4)
    local shipConfigInfo = zstring.split(shipConfig,"|")
    for i=1,table.nums(shipConfigInfo) do
        local configPer = zstring.split(shipConfigInfo[i],",")
        local existNumber = tonumber(getPropAllCountByMouldId(configPer[2]))
        local expProvide = configPer[3]
        if 0 < existNumber then
            curTotalExp =  curTotalExp + expProvide * existNumber
        end
    end
    if tonumber(curTotalExp) < tonumber(needExP) then
        return false
    end
    return true
end


--获取突破道具数量
function SilkBagHandler.getBreakeConsume(aimLevel,silkMouldId,breakeLv)
    local breakeInfo = {}
    if (aimLevel-1) % 10 == 0 then
        local breakeLevel = math.floor( aimLevel/10 )
        if breakeLevel == tonumber(breakeLv) then
            return nil
        end
        local breakeLibId = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.breake_group) 
        local breakeLib =dms.searchs(dms["silk_bag_break_group_mould"],ship_silk_bag_breake.lib_id,breakeLibId,ship_silk_bag_breake.cur_breake_level,breakeLevel)

        local shipConfig = breakeLib[1][ship_silk_bag_breake.breake_consume]
        shipConfigInfo = zstring.split(shipConfig,",")
        if -1 ~= tonumber(shipConfigInfo[1]) then
            breakeInfo.prop_id = shipConfigInfo[1]
            breakeInfo.prop_type = shipConfigInfo[2]
            breakeInfo.prop_num = shipConfigInfo[3]

            return breakeInfo
        end
    end
    
    return nil
end

--获得专属技能描述
function SilkBagHandler.getExcluseSkill(silkMouldId,protectLv)
    local excluseInfos = -1
    local origInfo = dms.string(dms["ship_silk_bag_mould"],tonumber(silkMouldId),ship_silk_bag_mould.exclusive_skill)
    if tostring(origInfo) == "-1" then 
        return nil
    end
    local infoList = zstring.split(origInfo,"|")
    if protectLv ~= nil then 
        for i,v in ipairs(infoList) do
            if tostring(v) ~= "-1" and i == tonumber(protectLv) then 
                excluseInfos = v
                break
            end
        end
    else
        excluseInfos = infoList[1]
    end
    
    if -1 == tonumber(excluseInfos) then
        return nil
    end
    local excluseInfoGroups = zstring.split(excluseInfos,",")
    local str = "" 
    local title = SilkBagHandler.getSilkProtectCondition(silkMouldId,protectLv)
    str = str .. title
    local describeCallback = function (word_id)
        if word_id ~= "-1" then 
            local word_info = dms.element(dms["word_mould"], tonumber(word_id))
            if word_info ~= nil then 
                local desName = word_info[3]
                str = str .. tostring(desName)
            end
        end
    end
    for k,v in pairs(excluseInfoGroups) do
        local skillNameId = dms.string(dms["talent_mould"], tonumber(v), talent_mould.talent_name)
        local skillDescribeId = dms.string(dms["talent_mould"], tonumber(v), talent_mould.talent_describe)
        describeCallback(skillNameId)
        describeCallback(skillDescribeId)
    end
    if "" == str then
        return nil
    end
    return str
end

-- 锦囊当前上的护佑
function SilkBagHandler.getHaveProtect(shipId)
    local protectList = {}
    if _ED.silkbag_pack_info ~= nil then
		for k,v in pairs(_ED.silkbag_pack_info) do
				
			if tonumber(shipId) == tonumber(v.onUseShipId) then
				if -1 ~= tonumber(v.onUseIndex) and tonumber(v.onUseIndex) > 4 then
					table.insert(protectList,v)
				end
			end	
		end
    end
    return protectList
end

-- 当前护佑阶段
function SilkBagHandler.getProtectLv(silkData)
    local curProtect = 1
    if silkData ~= nil then 
        local upInfo = dms.element(dms["ship_silk_bag_mould"],tonumber(silkData.silkBagMouldId))
        if upInfo then
            local upCondition = upInfo[ship_silk_bag_mould.protect_condition]
            if upCondition and tostring(upCondition) ~= "-1" then 
                local preCondition = dms.string(dms["equipment_config"], 19, equipment_config.param)
                local preInfo = zstring.splits(preCondition,"|",",")
                local upData = zstring.split(upCondition,",")
                local protectList = SilkBagHandler.getHaveProtect(silkData.onUseShipId)
                local aimQulifly = dms.int(dms["ship_silk_bag_mould"], tonumber(silkData.silkBagMouldId), ship_silk_bag_mould.silk_qulifly) -- 护佑资质条件

                for i=1,#preInfo do
                    local tempPer = preInfo[i]
                    local sefAimLv = tonumber(tempPer[1])         -- 自身等级
                    local sefAimNum = tonumber(tempPer[2])        -- 自身装备护佑数量
                    local aimProNum = tonumber(upData[i])         -- 专属护佑数量

                    local haveAimProtect = 0
                    local haveDefProtect = 0
                    if #protectList > 0 then 
                        local shipId = tonumber(_ED.user_ship[""..tonumber(silkData.onUseShipId)].ship_template_id)
                        for m,val in ipairs(protectList) do
                            local curQulity = SilkBagHandler.getSilkQualifications(val.silkBagMouldId)
                            if curQulity >= aimQulifly then 
                                haveAimProtect = haveAimProtect + 1
                            end
                            local eType = dms.int(dms["ship_silk_bag_mould"],tonumber(val.silkBagMouldId),ship_silk_bag_mould.exclusive_id)
                            if eType == shipId then 
                                haveDefProtect = haveDefProtect + 1
                            end
                        end
                        if silkData.level >= sefAimLv and haveAimProtect >= sefAimNum and  haveDefProtect >= aimProNum then 
                            curProtect = curProtect + 1 
                        end
                    end
                end
            end
        end
    end
    return curProtect
end

-- 获得忍具当前资质
function SilkBagHandler.getSilkQualifications(silkMouldId)
    local mouldType = dms.int(dms["ship_silk_bag_mould"], tonumber(silkMouldId), ship_silk_bag_mould.exclusive_id)
    if mouldType ~= -1 then 
        local ability = dms.int(dms["ship_mould"], tonumber(mouldType), ship_mould.ability)
        return ability
    else
        return 0
    end
end

-- 锦囊护佑条件
function SilkBagHandler.getSilkProtectCondition(silkMouldId,protectLv)
    -- 阶标题
    local title = ""
    if SilkBagHandler.getOpenProtect() then 
        if protectLv == 1 then
            title = tipStringInfo_rescue_silkbag[21] .. "\n"
        elseif protectLv == 2 then 
            local preCondition = dms.string(dms["equipment_config"], 19, equipment_config.param)
            local preInfo = zstring.splits(preCondition,"|",",")
            local aimQulifly = dms.int(dms["ship_silk_bag_mould"], tonumber(silkMouldId), ship_silk_bag_mould.silk_qulifly) -- 护佑资质条件
            title = string.format(tipStringInfo_rescue_silkbag[22],preInfo[1][1],preInfo[1][2],aimQulifly) .. "\n"
        else
            -- 通用条件
            local preCondition = dms.string(dms["equipment_config"], 19, equipment_config.param)
            local preInfo = zstring.splits(preCondition,"|",",")
            local tempPer = preInfo[protectLv - 1]
            local sefAimLv = tempPer[1]         -- 自身等级
            local sefAimNum = tempPer[2]        -- 自身装备护佑数量
            local aimQulifly = dms.int(dms["ship_silk_bag_mould"], tonumber(silkMouldId), ship_silk_bag_mould.silk_qulifly) -- 护佑资质条件

            -- 自身护佑数量条件
            local condition = nil
            local conditionInfo = dms.string(dms["ship_silk_bag_mould"], tonumber(silkMouldId), ship_silk_bag_mould.protect_condition)
            if conditionInfo and tostring(conditionInfo) ~= "-1" then
                for m, val in ipairs(zstring.split(conditionInfo, ",")) do
                    if (protectLv - 1) == m and tonumber(val) ~= "-1" then
                        condition = val
                        break
                    end
                end
            end
            if condition ~= nil then
                local info = zstring.split(condition, ",")
                title = string.format(tipStringInfo_rescue_silkbag[23], protectLv,sefAimLv, sefAimNum, aimQulifly, condition) .. "\n"
            end
        end
    end
    return title
end

-- 当前锦囊护佑是否开启
function SilkBagHandler.getSilkProtectOpen(silkData)
    local openInfo = dms.element(dms["ship_silk_bag_mould"],tonumber(silkData.silkBagMouldId))
    if openInfo then 
        local openConditionLv = openInfo[ship_silk_bag_mould.protect_open]
        if tostring(openConditionLv) ~= "-1" then  
            if openConditionLv and silkData.level >= tonumber(openConditionLv) then 
                return true
            end
        end
    end
    return false
end

-- 当前锦囊护佑是否锁住
function SilkBagHandler.getSilkProtectLock(silkData)
    local openInfo = dms.element(dms["ship_silk_bag_mould"],tonumber(silkData.silkBagMouldId))
    if openInfo then 
        local openConditionLv = openInfo[ship_silk_bag_mould.protect_open]
        if openConditionLv and tostring(openConditionLv) ~= "-1" then  
            return openConditionLv
        end
    end
    return nil
end

-- 获取护佑功能是否开放
function SilkBagHandler.getOpenProtect()
    local flag = SilkBagHandler.getSlotsNums() > 4
    return flag
end

-- 获取锦囊槽位数量
function SilkBagHandler.getSlotsNums()
    local curOpenNum = dms.string(dms["equipment_config"], 20, equipment_config.param)
    if curOpenNum then 
        return tonumber(curOpenNum)
    end
    return 4
end

-- 获取升级总经验 silkMouldId:锦囊模版Id curLev:当前等级 aimLev:目标等级
function SilkBagHandler.getTotalExpByLevel(silkMouldId, curLev, aimLev)
    local levelLibId = dms.int(dms["ship_silk_bag_mould"], silkMouldId, ship_silk_bag_mould.upgrade_group)
    local levelLib = dms.searchs(dms["silk_bag_level_up_group_mould"], ship_silk_bag_level.lib_id, levelLibId)
    local upExp = 0
    local startFlag = false
    local lastLev = 0
    -- 计算经验
    local function addCallback(levOne, levTwo, expInfo)
        local cutNum = levTwo - levOne
        local expNum = cutNum * tonumber(expInfo[ship_silk_bag_level.up_level_exp])
        return expNum
    end
    for i, v in ipairs(levelLib) do
        local rangeLevel = zstring.split(v[ship_silk_bag_level.cur_level_range], ",")
        -- 当前等级和目标等级在同一升级区间
        if curLev >= tonumber(rangeLevel[1]) and curLev <= tonumber(rangeLevel[2]) and aimLev >= tonumber(rangeLevel[1]) and aimLev <= tonumber(rangeLevel[2]) then
            upExp = addCallback(curLev, aimLev, v)
            return upExp
        else
            -- 当前等级和目标等级不在同一区间
            if aimLev >= tonumber(rangeLevel[1]) and aimLev <= tonumber(rangeLevel[2]) then
                startFlag = false
                upExp = addCallback(lastLev, aimLev, v) + upExp
                return upExp
            end
            if startFlag then
                upExp = addCallback(lastLev, tonumber(rangeLevel[2]), v) + upExp
                lastLev = tonumber(rangeLevel[2])
            end
            if curLev >= tonumber(rangeLevel[1]) and curLev <= tonumber(rangeLevel[2]) then
                startFlag = true
                upExp = addCallback(curLev, tonumber(rangeLevel[2]), v) + upExp
                lastLev = tonumber(rangeLevel[2])
            end
        end
    end
    return upExp
end
