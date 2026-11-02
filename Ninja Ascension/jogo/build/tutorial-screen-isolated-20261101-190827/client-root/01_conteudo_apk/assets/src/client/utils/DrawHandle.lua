-- ----------------------------------------------------------------------------------------------------
-- 说明：绘图工具
-- -----------------------------------------------------------------------------------------------------
DrawHandle = {}

-- @param is_scene_reward_ex_with_show_reward 是否是掉落库中显示掉落数据（如果是则table的[1]和[2]元素互换位置）
function DrawHandle.drawIcons(prop_datas, is_scene_reward_ex_with_show_reward, isOther)
    local is_scene_reward_ex_with_show_reward = is_scene_reward_ex_with_show_reward or false
    local cells = {}
    if type(prop_datas) == "string" then
        prop_datas = zstring.splits(prop_datas, "|", ",")
    end

    for i, propData in ipairs(prop_datas) do
        table.insert(cells, DrawHandle.drawIcon(propData, is_scene_reward_ex_with_show_reward, isOther))
    end

    return cells
end

-- @param is_scene_reward_ex_with_show_reward 是否是掉落库中显示掉落数据（如果是则table的[1]和[2]元素互换位置）
function DrawHandle.drawIcon(propData, is_scene_reward_ex_with_show_reward, isOther)
    local is_scene_reward_ex_with_show_reward = is_scene_reward_ex_with_show_reward or false
    if type(propData) == "string" then
        propData = zstring.split(propData, ",")
    end

    if is_scene_reward_ex_with_show_reward == true then
        local temp = propData[2]
        propData[2] = propData[1]
        propData[1] = temp
    end

    local cell = ResourcesIconCell:createCell()
    local rewardType = tonumber(propData[1])
    -- 13是武将整卡 72是神兽整卡
    if 13 == rewardType or 72 == rewardType then
        local extraTable = {}
        if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
            extraTable.shipStar = tonumber(propData[4])
        else
            extraTable.shipStar = 0
        end
        if isOther and isOther == true then
            extraTable.isOther = true
        else
            extraTable.isOther = false
        end
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
    else
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1)
    end
    return cell
end
