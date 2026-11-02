push_notification_sm_ship_push_state_table = {}
push_notification_sm_ship_equipment_push_state = {}
push_notification_sm_ship_push_ship_select_id = 0
local function init_push_notification_center_sm_hero_develop_terminal()
	--武将强化界面进阶标签页
    local push_notification_center_hero_develop_evolution_page_tip_terminal = {
        _name = "push_notification_center_hero_develop_evolution_page_tip",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getHeroDevelopEvolutionPageTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
                    if __lua_project_id == __lua_project_onepiece then
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-20))   
                    else
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))   
                    end
					
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    --武将强化界面升星标签页
    local push_notification_center_hero_develop_up_grade_star_page_tip_terminal = {
        _name = "push_notification_center_hero_develop_up_grade_star_page_tip",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getHeroDevelopUpGradeStarPageTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					 if __lua_project_id == __lua_project_onepiece then
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-20))   
                    else
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))   
                    end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --武将进阶界面进阶按钮
    local push_notification_center_hero_strength_evolution_button_terminal = {
        _name = "push_notification_center_hero_strength_evolution_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHeroStrengthEvolutionButton() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 0.7))
                    if __lua_project_id == __lua_project_onepiece then
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-20))   
                    else
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))   
                    end
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    --武将升星界面升星按钮
    local push_notification_center_hero_strength_up_grade_button_terminal = {
        _name = "push_notification_center_hero_strength_up_grade_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHeroStrengthUpGradeButton() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 0.7))
                    if __lua_project_id == __lua_project_onepiece then
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-20))   
                    else
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))   
                    end
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    --武将强化界面武将小图标
    local push_notification_center_hero_develop_ship_strength_icon_terminal = {
        _name = "push_notification_center_hero_develop_ship_strength_icon",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHeroDevelopShipStrengthIcon(params._widget._data) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 0.7))
                    ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))   
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    --装备强化界面武将小图标
    local push_notification_center_hero_develop_equip_strength_icon_terminal = {
        _name = "push_notification_center_hero_develop_equip_strength_icon",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHeroDevelopEquipStrengthIcon(params._widget._data) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 0.7))
                    ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))   
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --主界面武将推送
    local push_notification_center_hero_develop_home_hero_icon_terminal = {
        _name = "push_notification_center_hero_develop_home_hero_icon",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
       
            -- Home characters keep their interaction; omit upgrade red dots.
            if params._widget._nodeChild then
                params._widget:removeChild(params._widget._nodeChild,true)
                params._widget._nodeChild=nil
            end
            params._widget._istips=false
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --武将强化界面进化推送
    local push_notification_center_hero_develop_ship_evo_terminal = {
        _name = "push_notification_center_hero_develop_ship_evo",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHeroDevelopShipEvoTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 1))
                    ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))   
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local push_notification_center_hero_develop_duplicate_formation_terminal = {
        _name = "push_notification_center_hero_develop_duplicate_formation",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHeroDevelopHomeHeroIcon() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 1))
                    if __lua_project_id == __lua_project_l_naruto then
                        ball:setPosition(cc.p(params._widget:getContentSize().width * 3/4 + 5, params._widget:getContentSize().height * 3/4 + 5))
                    else
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
                    end
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(push_notification_center_hero_develop_evolution_page_tip_terminal)
    state_machine.add(push_notification_center_hero_develop_up_grade_star_page_tip_terminal)
    state_machine.add(push_notification_center_hero_strength_evolution_button_terminal)
    state_machine.add(push_notification_center_hero_strength_up_grade_button_terminal)
    state_machine.add(push_notification_center_hero_develop_ship_strength_icon_terminal)
    state_machine.add(push_notification_center_hero_develop_equip_strength_icon_terminal)
    state_machine.add(push_notification_center_hero_develop_home_hero_icon_terminal)
    state_machine.add(push_notification_center_hero_develop_ship_evo_terminal)
    state_machine.add(push_notification_center_hero_develop_duplicate_formation_terminal)
    state_machine.init()
end
init_push_notification_center_sm_hero_develop_terminal()
--武将强化界面进阶标签页
function getHeroDevelopEvolutionPageTip()
	local _windows = fwin:find("HeroDevelopClass")
    if _windows ~= nil then
        if tonumber(_windows.m_type) == 1 then
            return false
        end
        local ship = _ED.user_ship["".._windows.shipId]--fundShipWidthId(_windows.shipId)
        if shipIsCanEvolution(ship) == true then
            return true
        end
    end
    local new_windows = fwin:find("FormationTigerGateClass")
    if new_windows ~= nil then
        if tonumber(new_windows._current_page) == 4 then
            return false
        end
        local ship = new_windows.ship
        if shipIsCanEvolution(ship) == true then
            return true
        end
    end
	return false
end
--武将强化界面升星标签页
function getHeroDevelopUpGradeStarPageTip()
	local _windows = fwin:find("HeroDevelopClass")
    if _windows ~= nil then
        if tonumber(_windows.m_type) == 3 then
            return false
        end
        local ship = _ED.user_ship["".._windows.shipId]--fundShipWidthId(_windows.shipId)
        if shipIsCanUpGradeStar(ship) == true then
            return true
        end
    end
    local new_windows = fwin:find("FormationTigerGateClass")
    if new_windows ~= nil then
        if tonumber(new_windows._current_page) == 6 then
            return false
        end
        local ship = new_windows.ship
        if shipIsCanUpGradeStar(ship) == true then
            return true
        end
    end
    return false
end
--武将进阶界面进阶按钮
function getHeroStrengthEvolutionButton()
    local _windows = fwin:find("SmRoleStrengthenTabUpProductClass")
    if _windows ~= nil then
        local ship = _ED.user_ship["".._windows.ship_id]--fundShipWidthId(_windows.ship_id)
        if shipIsCanEvolution(ship) == true then
            return true
        end
    end
    return false
end

--武将升星界面升星按钮
function getHeroStrengthUpGradeButton()
    local _windows = fwin:find("SmRoleStrengthenTabRisingStarClass")
    if _windows ~= nil then
        local ship = _ED.user_ship["".._windows.ship_id]--fundShipWidthId(_windows.ship_id)
        if shipIsCanUpGradeStar(ship) == true then
            return true
        end
    end
    return false
end

--装备强化界面武将小图标
function getHeroDevelopEquipStrengthIcon(ship)
    if shipEquipmentIsCanEvolution(ship) == true then
        return true
    end
    if shipEquipmentIsCanAwake(ship) == true then
        return true
    end
    -- for i = 1 , 6 do
    --     if equipmentIsCanEvolution(ship , i) == true then
    --         return true
    --     end
    --     if equipmentIsCanAwake(ship , i) == true then
    --         return true
    --     end
    -- end
    return false
end

--武将强化界面武将小图标
function getHeroDevelopShipStrengthIcon(ship)
    if shipIsCanEvolution(ship) == true then
        return true
    end 
    if shipIsCanUpGradeStar(ship) == true then
        return true
    end
    return false
end
--主界面武将推送
function getHeroDevelopHomeHeroIcon()
    if getSortedHeroesFormationtips() == true then
        return true
    end
    for i = 2, 7 do
        local shipId = _ED.formetion[i]
        if zstring.tonumber(shipId) > 0 then
            local ship = _ED.user_ship[shipId]
            if shipIsCanEvolution(ship) == true then
                return true
            end 
            if shipIsCanUpGradeStar(ship) == true then
                return true
            end
            if shipIsCanProcess(ship) == true then
                return true
            end
            if shipEquipmentIsCanEvolution(ship) == true then
                return true
            end
            if shipEquipmentIsCanAwake(ship) == true then
                return true
            end
            -- for i = 1 , 6 do
            --     if equipmentIsCanEvolution(ship , i) == true then
            --         return true
            --     end
            --     if equipmentIsCanAwake(ship , i) == true then
            --         return true
            --     end
            -- end
        end
    end
    return false 
end

function getHeroDevelopHomeHeroIconEX( index )
    -- if getSortedHeroesFormationtips() == true then
    --     return true
    -- end
    -- for i = 2, 7 do
        local shipId = _ED.formetion[index + 1]
        if zstring.tonumber(shipId) > 0 then
            local ship = _ED.user_ship[shipId]
            if shipIsCanEvolution(ship) == true then
                return true
            end 
            if shipIsCanUpGradeStar(ship) == true then
                return true
            end
            if shipIsCanProcess(ship) == true then
                if __lua_project_id == __lua_project_onepiece then
                    return false
                end
                return true
            end
            if shipEquipmentIsCanEvolution(ship) == true then
                return true
            end
            if shipEquipmentIsCanAwake(ship) == true then
                return true
            end
            -- for i = 1 , 6 do
            --     if equipmentIsCanEvolution(ship , i) == true then
            --         return true
            --     end
            --     if equipmentIsCanAwake(ship , i) == true then
            --         return true
            --     end
            -- end
        -- else
        --     if getSortedHeroesFormationtips() == true then
        --         return true
        --     end
        end
    -- end
    return false 
end

-- 数码兽进化推送
function getHeroDevelopShipEvoTip()
    local _windows = fwin:find("SmRoleStrengthenTabClass")
    if _windows ~= nil then
        local ship = fundShipWidthId(_windows.ship_id)
        if shipIsCanProcess(ship) == true then
            return true
        end
    end
    return false
end

-- 数码兽装备推送状态
function getHeroDevelopShipEquipmentPushState(ship)
    if true then
        return
    end
    if push_notification_sm_ship_push_ship_select_id ~= tonumber(ship.ship_id) then
        push_notification_sm_ship_equipment_push_state = {}
        push_notification_sm_ship_push_ship_select_id = tonumber(ship.ship_id)
        for i = 1, 6 do
            local info = {}
            info.equip_upgrade_state = false        -- 装备是否可进阶
            info.equip_awake_state = false          -- 装备是否可觉醒
            info.equip_levelup_state = false          -- 装备是否可升级
            -- if equipmentIsCanEvolutionPush(ship, i) == true then
            --     info.equip_upgrade_state = true
            -- end
            info.equip_upgrade_state, info.equip_levelup_state = equipmentIsCanEvolutionPush(ship, i)
            if equipmentIsCanAwakePush(ship, i) == true then
                info.equip_awake_state = true
            end
            table.insert(push_notification_sm_ship_equipment_push_state, info)
        end
    end
end

function setHeroDevelopAllShipPushState(push_type)
    if true then
        return
    end
    if push_type == 1 then
        push_notification_sm_ship_push_ship_change = true           -- 数码兽属性变更
    elseif push_type == 2 then
        push_notification_sm_ship_push_equip_change = true           -- 装备信息变更
    elseif push_type == 3 then
        push_notification_sm_ship_push_prop_change = true            -- 道具信息,金币数量变更
    end
    push_notification_sm_ship_push_ship_select_id = 0           -- 刷新装备信息
end

-- 数码兽推送状态
function getHeroDevelopAllShipPushState()
    if true then
        return
    end
    local update_upgrade_state = false
    local update_raise_star_state = false
    local update_evolution_state = false
    local update_equip_upgrade_state = false
    local update_equip_awake_state = false

    local need_udpate = false

    if push_notification_sm_ship_push_ship_change == nil or push_notification_sm_ship_push_ship_change == true then         -- 数码兽属性变更
        update_raise_star_state = true
        update_evolution_state = true
        update_equip_upgrade_state = true
        need_udpate = true
    end
    if push_notification_sm_ship_push_equip_change == nil or push_notification_sm_ship_push_equip_change == true then         -- 装备信息变更
        update_equip_awake_state = true
        need_udpate = true
    end
    if push_notification_sm_ship_push_prop_change == nil or push_notification_sm_ship_push_prop_change == true then         -- 道具信息,金币数量变更
        update_upgrade_state = true
        update_raise_star_state = true
        update_equip_upgrade_state = true
        update_equip_awake_state = true
        need_udpate = true
    end

    push_notification_sm_ship_push_ship_change = false
    push_notification_sm_ship_push_equip_change = false
    push_notification_sm_ship_push_prop_change = false

    if need_udpate == false then
        return
    end

    for k, ship in pairs(_ED.user_ship) do
        local ship_push_info = push_notification_sm_ship_push_state_table[""..ship.ship_id] or {
            upgrade_state = false,        -- 是否可进阶
            raise_star_state = false,     -- 是否可升星
            evolution_state = false,      -- 是否可进化
            equip_upgrade_state = false,  -- 装备是否可进阶
            equip_awake_state = false,    -- 装备是否可觉醒
        }
        if update_upgrade_state == true then
            ship_push_info.upgrade_state = false
            if shipIsCanEvolutionPush(ship) == true then
                ship_push_info.upgrade_state = true
            end
        end

        if update_raise_star_state == true then
            ship_push_info.raise_star_state = false
            if shipIsCanUpGradeStarPush(ship) == true then
                ship_push_info.raise_star_state = true
            end
        end

        if update_evolution_state == true then
            ship_push_info.evolution_state = false
            if shipIsCanProcessPush(ship) == true then
                ship_push_info.evolution_state = true
            end
        end

        if update_equip_upgrade_state == true then
            ship_push_info.equip_upgrade_state = false
            for i = 1,6 do
                if equipmentIsCanEvolutionPush(ship, i) == true then
                    ship_push_info.equip_upgrade_state = true
                    break
                end
            end
        end

        if update_equip_awake_state == true then
            ship_push_info.equip_awake_state = false
            for i = 1,6 do
                if equipmentIsCanAwakePush(ship, i) == true then
                    ship_push_info.equip_awake_state = true
                    break
                end
            end
        end

        push_notification_sm_ship_push_state_table[""..ship.ship_id] = ship_push_info
    end
end

--武将是否可升星
function shipIsCanUpGradeStar(ship)
    local result = false
    if funOpenDrawTip(102,false) ~= true then
        result = _ED.push_user_ship_info[""..ship.ship_id][3].to_push
    end
    return result
    -- getHeroDevelopAllShipPushState()
    -- if push_notification_sm_ship_push_state_table[""..ship.ship_id] ~= nil 
    --     and push_notification_sm_ship_push_state_table[""..ship.ship_id].raise_star_state == true then
    --     return true
    -- end
    -- return false
end

--武将是否可进阶
function shipIsCanEvolution(ship)
    local result = false
    if funOpenDrawTip(100,false) ~= true then
        result = _ED.push_user_ship_info[""..ship.ship_id][2].to_push
    end
    return result
    -- getHeroDevelopAllShipPushState()
    -- if push_notification_sm_ship_push_state_table[""..ship.ship_id] ~= nil 
    --     and push_notification_sm_ship_push_state_table[""..ship.ship_id].upgrade_state == true then
    --     return true
    -- end
    -- return false
end

--武将是否可进化
function shipIsCanProcess(ship)
    local result = false
    if funOpenDrawTip(105,false) ~= true then
        result = _ED.push_user_ship_info[""..ship.ship_id][6].to_push
    end
    return result
    -- getHeroDevelopAllShipPushState()
    -- if push_notification_sm_ship_push_state_table[""..ship.ship_id] ~= nil 
    --     and push_notification_sm_ship_push_state_table[""..ship.ship_id].evolution_state == true then
    --     return true
    -- end
    -- return false
end

--武将是否有装备可进阶
function shipEquipmentIsCanEvolution(ship)
    if funOpenDrawTip(159,false) == false or funOpenDrawTip(96,false) == false then
        return _ED.push_user_ship_info[""..ship.ship_id][8].to_push
    else
        return false
    end
    -- getHeroDevelopAllShipPushState()
    -- if push_notification_sm_ship_push_state_table[""..ship.ship_id] ~= nil 
    --     and push_notification_sm_ship_push_state_table[""..ship.ship_id].equip_upgrade_state == true then
    --     return true
    -- end
    -- return false
end

--武将是否有装备可觉醒
function shipEquipmentIsCanAwake(ship)
    if funOpenDrawTip(96,false) == false and funOpenDrawTip(99,false) == false then
        return _ED.push_user_ship_info[""..ship.ship_id][9].to_push
    else
        return false
    end
    
    -- getHeroDevelopAllShipPushState()
    -- if push_notification_sm_ship_push_state_table[""..ship.ship_id] ~= nil 
    --     and push_notification_sm_ship_push_state_table[""..ship.ship_id].equip_awake_state == true then
    --     return true
    -- end
    -- return false
end

-- 装备是否可淬炼
function equipmentIsCanHarden(ship,equipIndex)
    if not ship or not tonumber(equipIndex) or not _ED.user_ship[tostring(ship.ship_id)] then return false end
    -- 需要觉醒前置条件才能开启
    local shipId = ship.ship_id
    local mIndex = equipIndex
    local shipData = _ED.user_ship[""..shipId]
    if not shipData.equipInfo then 
        return false
    end
    local shipEquip = zstring.split(shipData.equipInfo, "|")
    local newStar = zstring.split(shipEquip[4], ",")
    local awakeLevel = tonumber(newStar[tonumber(mIndex)])
    
    if _ED.user_ship[""..shipId].hardensInfo then 
        if dms.int(dms["play_config"], 196, play_config.param) >  awakeLevel then 
            return false
        end
        app.load("client.packs.EquipStorage.SmEquipmentQunenchingHandle")
        local hardenInfo = _ED.user_ship[""..shipId].hardensInfo[tonumber(mIndex)]
        if hardenInfo then 
            -- 等级
            local lv = hardenInfo.level
            local maxLv = dms.string(dms["play_config"], 182, play_config.param)
            if tonumber(lv) >= tonumber(maxLv) then 
                return false
            end
            -- 经验
            local exp = tonumber(hardenInfo.exp)
            local levelMould = SmEquipmentQunenchingHandle.getLevelMould(lv , tonumber(mIndex))
            local levelExp = tonumber(levelMould[1][3])
            -- 金币
            local levelGold = tonumber(levelMould[1][4])
            if tonumber(_ED.user_info.user_silver) < levelGold then 
                return false
            end

            -- 道具
            local propId = dms.string(dms["play_config"], 182 + tonumber(mIndex), play_config.param)
            local haveNum = 0
            if fundPropWidthId(propId) then 
                haveNum = tonumber(fundPropWidthId(propId).prop_number)
            end
            local productExp = dms.int(dms["play_config"], 191, play_config.param)
            if exp + haveNum * productExp >= levelExp then 
                return true
            end
        end
    end
    return false
end

-- 是否可以装备淬炼
function shipEquipmentIsCanHarden(ship)
    for i=1,6 do
        local flag = equipmentIsCanHarden(ship,i)
        if flag then 
            return true
        end
    end
    return false
end

--装备是否可进阶
function equipmentIsCanEvolution(ship ,equipIndex)
    local state = ship and _ED.push_user_ship_info and _ED.push_user_ship_info[tostring(ship.ship_id)]
    if not tonumber(equipIndex) or not state or not state[8] or not state[8].push_index then return false end
    if _ED.push_user_ship_info[""..ship.ship_id][8].to_push == true then
        if tonumber(equipIndex) > 4 then
            if funOpenDrawTip(159,false) == false then
                return _ED.push_user_ship_info[""..ship.ship_id][8].push_index[tonumber(equipIndex)]
            else
                return false
            end
        else
            if funOpenDrawTip(96,false) == false then
                return _ED.push_user_ship_info[""..ship.ship_id][8].push_index[tonumber(equipIndex)]
            else
                return false
            end
        end
    else
        return false
    end
    -- getHeroDevelopShipEquipmentPushState(ship)
    -- if push_notification_sm_ship_equipment_push_state[equipIndex].equip_upgrade_state == true then
    --     return true
    -- end
    -- return false
end

--装备是否可觉醒
function equipmentIsCanAwake(ship ,equipIndex)
    local state = ship and _ED.push_user_ship_info and _ED.push_user_ship_info[tostring(ship.ship_id)]
    if not tonumber(equipIndex) or not state or not state[9] or not state[9].push_index then return false end
    if _ED.push_user_ship_info[""..ship.ship_id][9].to_push == true then 
        if funOpenDrawTip(96,false) == false and funOpenDrawTip(99,false) == false then
            return _ED.push_user_ship_info[""..ship.ship_id][9].push_index[tonumber(equipIndex)]
        else
            return false
        end
    else
        return false
    end
    -- getHeroDevelopShipEquipmentPushState(ship)
    -- if push_notification_sm_ship_equipment_push_state[equipIndex].equip_awake_state == true then
    --     return true
    -- end
    -- return false
end

--装备是否可升级
function equipmentIsCanLevelUp(ship ,equipIndex)
    local state = ship and _ED.push_user_ship_info and _ED.push_user_ship_info[tostring(ship.ship_id)]
    if not tonumber(equipIndex) or not state or not state[7] or not state[7].push_index then return false end
    if _ED.push_user_ship_info[""..ship.ship_id][7].to_push == true then 
        if tonumber(equipIndex) > 4 then
            if funOpenDrawTip(159,false) == false then
                return _ED.push_user_ship_info[""..ship.ship_id][7].push_index[tonumber(equipIndex)]
            else
                return false
            end
        else
            if funOpenDrawTip(96,false) == false then
                return _ED.push_user_ship_info[""..ship.ship_id][7].push_index[tonumber(equipIndex)]
            else
                return false
            end
        end
    else
        return false
    end
    -- getHeroDevelopShipEquipmentPushState(ship)
    -- if push_notification_sm_ship_equipment_push_state[equipIndex].equip_levelup_state == true then
    --     return true
    -- end
    -- return false
end
