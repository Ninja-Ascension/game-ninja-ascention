--[[
	--装备淬炼处理
    --author: Rock
    --time:2020-07-08 14:27:50
--]]

SmEquipmentQunenchingHandle = SmEquipmentQunenchingHandle or {}

-- 获得等级经验 等级,部位(1,2,3,4,5,6)
function SmEquipmentQunenchingHandle.getLevelMould(levelId , typeId)
    local exp = dms.searchs(dms["equipment_harden"],7,tonumber(typeId),2,(tonumber(levelId)))
    if exp then 
        return exp
    else
        return nil
    end
end


-- 获得词条范围  等级,部位(1,2,3,4,5,6),属性类型
function SmEquipmentQunenchingHandle.getRange(levelId , typeId ,propertyId)
    local property = dms.searchs(dms["equipment_harden_param"],2,tonumber(typeId),3,tonumber(propertyId))
    if property and property[1] then 
        if levelId > 0 then 
            local befNum = 0
            local aftNum = 0
            local propertyData = zstring.split(property[1][4],",")
            befNum = befNum + tonumber(propertyData[1])
            aftNum = aftNum + tonumber(propertyData[2])
            for i=1,tonumber(levelId) do
                local temps = zstring.split(property[1][i + 4],",")
                befNum = befNum + tonumber(temps[1])

                aftNum = aftNum + tonumber(temps[2])
            end

            return befNum..","..aftNum
        else
            return property[1][levelId + 4]
        end
        
    else
        return nil
    end
end

