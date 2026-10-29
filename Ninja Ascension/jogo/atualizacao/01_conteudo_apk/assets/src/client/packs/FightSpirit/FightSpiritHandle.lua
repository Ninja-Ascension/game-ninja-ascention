--[[
	战魂数据处理类
--]]

FightSpiritHandle = FightSpiritHandle or {}

-- FightSpiritHandle
FightSpiritHandle.extraInfoTag = {}
FightSpiritHandle.fSpiritBaseInfos = FightSpiritHandle.fSpiritBaseInfos or {}        -- 战魂初始数据缓存


--获取所有战魂kv对
function FightSpiritHandle.getAllFightSpirits()
    _ED.all_fight_spirits = _ED.all_fight_spirits or {}
    return _ED.all_fight_spirits
end

--获取所有战魂列表
function FightSpiritHandle:getAllFightSpiritsList()
    _ED.all_fight_spirits_list = _ED.all_fight_spirits_list or {}
    return _ED.all_fight_spirits_list
end

--获取单个英雄战魂信息
function FightSpiritHandle.getShipFightSpiritInfoById(id)
    local info = (_ED.all_ship_fight_spirit_info or {})[id] or {-1,-1,-1,-1}
    if not FightSpiritHandle.extraInfoTag[id] then
        FightSpiritHandle.extraInfoTag[id] = true
        FightSpiritHandle.setShipFightSpiritExtraInfo(id)
    end
    return clone(info)
end

--设置单个英雄战魂
function FightSpiritHandle.setShipFightSpirits(id, info)
    local allFightSpirits = FightSpiritHandle.getAllFightSpirits()

    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            smFightingChange()
            FightSpiritHandle.setShipFightSpiritExtraInfo(id)

            if fwin:find("FightSpiritCell1Class") then
                state_machine.excute("fight_spirit_main_update_detail", 0, {})
            end
            if fwin:find("SmRoleStrengthenTabFightSpiritClass") then
                state_machine.excute("sm_role_strengthen_tab_fight_spirit_update_draw", 0, {})
            end
            if fwin:find("SmRoleStrengthenTabClass") then
                state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{id})
            end
        end
    end

    protocol_command.fight_spirit_change.param_list = ""..id.."\r\n"..info[1]..","..info[2]..","..info[3]..","..info[4]
    NetworkManager:register(protocol_command.fight_spirit_change.code, nil, nil, nil, nil, responseCallback, false, nil)
end

--设置单个英雄单个战魂
function FightSpiritHandle.setShipFightSpirit(id, fightSpiritId)
    local fightSpirit = _ED.all_fight_spirits[fightSpiritId]
    local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)

    local info = FightSpiritHandle.getShipFightSpiritInfoById(id)
    info[pos] = fightSpiritId
    FightSpiritHandle.setShipFightSpirits(id, info)
end

--设置英雄战魂额外信息
function FightSpiritHandle.setShipFightSpiritExtraInfo(id)
    local allFightSpirits = FightSpiritHandle.getAllFightSpirits()
    local info = FightSpiritHandle.getShipFightSpiritInfoById(id)

    local suitCount = {}
    local quality = {}
    for _,fightSpiritId in ipairs(info) do
        if fightSpiritId > 0 then
            local fightSpirit = allFightSpirits[fightSpiritId]

            local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
            if not suitCount[suitId] then
                suitCount[suitId] = 1
            else
                suitCount[suitId] = suitCount[suitId] + 1
            end

            if not quality[suitId] or quality[suitId] > fightSpirit.quality then
                quality[suitId] = fightSpirit.quality
            end
        end
    end

    for _,fightSpiritId in ipairs(info) do
        if fightSpiritId > 0 then
            local fightSpirit = allFightSpirits[fightSpiritId]
            local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
            fightSpirit.extraInfo = {}
            if suitCount[suitId] == 4 then
                fightSpirit.extraInfo.suit2Active = true
                fightSpirit.extraInfo.suit4Active = true
            elseif suitCount[suitId] >= 2 then
                fightSpirit.extraInfo.suit2Active = true
            end
        end
    end
end

--卸下单个英雄单个战魂
function FightSpiritHandle.unloadShipFightSpirit(id, pos)
    local info = FightSpiritHandle.getShipFightSpiritInfoById(id)
    info[pos] = -1
    FightSpiritHandle.setShipFightSpirits(id, info)
end

--获取单个战魂
function FightSpiritHandle.getFightSpiritById(fightSpiritId)
    if not fightSpiritId or tonumber(fightSpiritId)==nil or tonumber(fightSpiritId)<=0 then return nil end
    return FightSpiritHandle.getAllFightSpirits()[fightSpiritId]
end

--获取单个英雄战魂总属性
function FightSpiritHandle:getShipFightSpiritAttributeById(id)
    local allFightSpirits = FightSpiritHandle.getAllFightSpirits()
    local info = FightSpiritHandle.getShipFightSpiritInfoById(id)

    local retAttrs = {}
    local suitCount = {}
    local quality = {}

    local function addAttribute(attrs)
        local attrList = zstring.split(attrs, "|")
        for _,attrItem in ipairs(attrList) do
            local attrItem = zstring.split(attrItem, ",", function (value) return tonumber(value) end)
            local attributeType = attrItem[1]
            local baseAttr = attrItem[2]
            local strengthAttr = attrItem[3]

            local value = baseAttr + strengthAttr
            if not retAttrs[attributeType] then
                retAttrs[attributeType] = value
            else
                retAttrs[attributeType] = retAttrs[attributeType] + value
            end
        end
    end
    for _,fightSpiritId in ipairs(info) do
        if fightSpiritId > 0 then
            local fightSpirit = allFightSpirits[fightSpiritId]

            addAttribute(fightSpirit.addProperty.main)
            addAttribute(fightSpirit.addProperty.random)
            -- addAttribute(fightSpirit.addProperty.awake)

            local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
            if not suitCount[suitId] then
                suitCount[suitId] = 1
            else
                suitCount[suitId] = suitCount[suitId] + 1
            end

            if not quality[suitId] or quality[suitId] > fightSpirit.quality then
                quality[suitId] = fightSpirit.quality
            end
        end
    end

    local ret = {}
    ret.attrs = retAttrs

    for suitId,count in pairs(suitCount) do
        if count == 4 then
            ret.suit2Active = true
            ret.suit4Id = suitId
            ret.suit4Quality = quality[suitId]
        elseif count >= 2 then
            ret.suit2Active = true
        end
    end
    return ret
end

--获取战魂觉醒后品质
function FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(quality)
    local awakeQualitys = zstring.split(dms.string(dms["play_config"], 236, pirates_config.param), ",")
    for i,v in ipairs(awakeQualitys) do
        local t = zstring.split(v, "|", function (value) return tonumber(value) end)
        if t[1] == quality then
            return {
                isAwaken = false,
                quality1 = t[1],
                quality2 = t[2],
                awakeIndex = i,
            }
        elseif t[2] == quality then
            return {
                isAwaken = true,
                quality1 = t[1],
                quality2 = t[2],
                awakeIndex = i,
            }
        end
    end
    return
end

--获取英雄推荐战魂
function FightSpiritHandle.getRecommendFightSpirit(id)
    local ship = getPlayerShip(id)
    local str = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fight_spirit_recommand)
    local ret = {}
    if str ~= "-1" then
        ret = zstring.split(str, ",", function (value)
            return tonumber(value)
        end)
    end
    return ret
end

--是否可强化
function FightSpiritHandle.canStrength(fightSpiritId)
    local fightSpirit = FightSpiritHandle.getFightSpiritById(fightSpiritId)
    local maxLevel = 1
    local rows = dms.searchs(dms["fight_spirit_strengthen_mould"], fight_spirit_strengthen_mould.quality, fightSpirit.quality)
    for i,row in ipairs(rows) do
        maxLevel = dms.atof(row,fight_spirit_strengthen_mould.cur_lev)
    end
    return maxLevel > fightSpirit.level
end


-- 获取单个战魂的初始数据
function FightSpiritHandle.getFightSpiritByMouldId(mouldId)
    local preData = nil
    local baseDatas = {}
    if #FightSpiritHandle.fSpiritBaseInfos == 0 then
        for i=1,dms.count(dms["fight_spirit_mould"]) do
            local elementShip = dms.element(dms["fight_spirit_mould"],i)
            table.insert(FightSpiritHandle.fSpiritBaseInfos,elementShip)
            local shipIdTemp = dms.atoi(elementShip,fight_spirit_mould.id)

            if shipIdTemp == tonumber(mouldId) then
                preData = elementShip
            end
        end
        
    else
        for i,v in ipairs(FightSpiritHandle.fSpiritBaseInfos) do
            local shipIdTemp = dms.atoi(v,fight_spirit_mould.id)
            if shipIdTemp == tonumber(mouldId) then
                preData = v
                break
            end
        end
    end

    if preData then 
        -- 基本属性
        local basicPropertyId = dms.atos(preData,fight_spirit_mould.main_lib_id)
        local basicQuality = dms.atos(preData,fight_spirit_mould.quality)

        dms.searchs(dms["fight_spirit_strengthen_mould"], fight_spirit_strengthen_mould.quality, quality,fight_spirit_strengthen_mould.cur_lev, level)
        local rows = dms.searchs(dms["fight_spirit_talent_mould"], fight_spirit_talent_mould.lib_type, 2,fight_spirit_talent_mould.lib_id, basicPropertyId)
        local row = dms.searchs(rows, fight_spirit_talent_mould.quality, basicQuality)[1]
		local attrs = dms.atos(row, fight_spirit_talent_mould.strength_attr)
        attrs = zstring.split(attrs, "|")
        local mainProperty = ""
		for i,v in ipairs(attrs) do
			local attr1 = zstring.split(v, ":")
			local attr2 = zstring.split(attr1[1], ",")
            attrs[i] = {tonumber(attr2[1]),tonumber(attr2[2]),0}
            if mainProperty ~= "" then 
                mainProperty = mainProperty .. "|" .. tonumber(attr2[1]) ..",".. tonumber(attr2[2]) ..",".. 0 
            else
                mainProperty = tonumber(attr2[1]) ..",".. tonumber(attr2[2]) ..",".. 0 
            end
        end
        local addProperty = {}
        addProperty.main = mainProperty

        
        -- 随机属性
        local str = zstring.split(dms.string(dms["play_config"], 227, pirates_config.param), "|")
        local num = zstring.split(str[1], ",")[2]
        addProperty.randomEhanceNumber = num
        -- 觉醒属性

        addProperty.awake = -1
        

        baseDatas.addProperty = addProperty
        baseDatas.quality = tonumber(basicQuality)
        baseDatas.mouldId = mouldId
        baseDatas.lockStatus = 0
    end

    return baseDatas
end
