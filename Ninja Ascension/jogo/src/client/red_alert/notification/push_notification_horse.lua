-- Initialize push notification center state machine.
local function init_push_notification_horse_terminal()
    -- 主界面是否可以鉴定
    local push_notification_horse_recuit_terminal = {
        _name = "push_notification_horse_recuit",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getHorseRecuitTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    -- 龙马合成
    local push_notification_horse_combing_terminal = {
        _name = "push_notification_horse_combing",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHorseCombingTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    -- 珍兽跟随
    local push_notification_horse_all_info_terminal = {
        _name = "push_notification_horse_all_info",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHorseAllTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    -- 兽魂
    local push_notification_horse_spilits_ware_terminal = {
        _name = "push_notification_horse_spilits_ware",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local horse_spirits = params._datas._horse_spirits

            if getHorseSpilitsWareTip(horse_spirits) == true then
                if params._widget._isUpTips == true then
                    params._widget._nodeUpChild:setVisible(false)
                    params._widget._isUpTips = false
                end
                if params._widget._isRedTips == nil or params._widget._isRedTips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
                    params._widget:addChild(ball)
                    params._widget._nodeRedChild = ball
                    params._widget._isRedTips = true
                end
            else
                if params._widget._isRedTips == true then
                    params._widget:removeChild(params._widget._nodeRedChild, true)
                    params._widget._nodeRedChild = nil
                    params._widget._isRedTips = false
                end
                if haveHorseSpilitsUpTip(horse_spirits) == true then
                    if params._widget._isUpTips == nil or params._widget._isUpTips == false then
                        if params._widget._nodeUpChild ~= nil then
                            params._widget._nodeUpChild:setVisible(true)
                        else
                            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_point/effect_point.ExportJson")
                            local effice = ccs.Armature:create("effect_point")
                            params._widget._nodeUpChild = effice
                            effice:setPosition(cc.p(params._widget:getContentSize().width*0.8, params._widget:getContentSize().height*0.8))
                            effice:getAnimation():playWithIndex(0)
                            params._widget:addChild(effice) 
                        end
                        params._widget._isUpTips = true
                    end
                else
                    if params._widget._isUpTips == true then
                        params._widget._nodeUpChild:setVisible(false)
                        params._widget._isUpTips = false
                    end
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 附魔包裹
    local push_notification_horse_soul_terminal = {
        _name = "push_notification_horse_soul",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHorseCombingSoulTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    -- 单个英雄珍兽推送
    local push_notification_horse_one_hero_horse_terminal = {
        _name = "push_notification_horse_one_hero_horse",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local ship = params._datas._ship
            if params._widget ~= nil and params._widget.from_type ~= 8 then
                return
            end
            if getOneHorseTips(ship) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    -- 兽魂兑换
    local push_notification_horse_spilits_combing_terminal = {
        _name = "push_notification_horse_spilits_combing",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getHorseSpilitsCombingTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    state_machine.add(push_notification_horse_recuit_terminal)
    state_machine.add(push_notification_horse_combing_terminal)
    state_machine.add(push_notification_horse_spilits_ware_terminal)
    state_machine.add(push_notification_horse_soul_terminal)
    state_machine.add(push_notification_horse_all_info_terminal)
    state_machine.add(push_notification_horse_one_hero_horse_terminal)
    state_machine.add(push_notification_horse_spilits_combing_terminal)
    state_machine.init()
end
init_push_notification_horse_terminal()

--可鉴定
function getHorseRecuitTip()
    --如果有普通鉴定或高级鉴定次数推送
    if tonumber(_ED.horse_normal_number) > 0 
        or tonumber(_ED.horse_specil_number) > 0 
        then
        return true
    end
    return false
end

-- 可合成珍兽
function getHorseCombingTip()
    --所需碎片
    local maxCount = dms.int(dms["horse_config"], 4, horse_config.param)
    --如果拥有碎片大于或等于所需碎片时推送
    if tonumber(_ED.user_info.dragon_horse_patch) >= maxCount then
        return true
    end
    return false
end

-- 同类型有更高等级或高品质兽魂
function getHorseSpilitsWareTip( horse_spirits )
    if horse_spirits ~= nil then
        local baseHorseSpilits = dms.element(dms["horse_spirit_mould"], horse_spirits.mould_id)
        local baseSameId = dms.atoi(baseHorseSpilits, horse_spirit_mould.same_type_id)
        local baseQuality = dms.atoi(baseHorseSpilits, horse_spirit_mould.quality)
        local baseLevel = dms.atoi(baseHorseSpilits, horse_spirit_mould.level)
        for k,v in pairs(_ED.horse_spirits) do
            if tonumber(v.horse_id) > 0 then
            else
                local horseSpilitsData = dms.element(dms["horse_spirit_mould"], v.mould_id)
                local level = dms.atoi(horseSpilitsData, horse_spirit_mould.level)
                local quality = dms.atoi(horseSpilitsData, horse_spirit_mould.quality)
                local sameId = dms.atoi(horseSpilitsData, horse_spirit_mould.same_type_id)
                if baseSameId == sameId then
                    if quality > baseQuality then
                        return true
                    elseif quality == baseQuality then
                        if level > baseLevel then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

-- 兽魂可升级
function haveHorseSpilitsUpTip( horse_spirits )
    if horse_spirits ~= nil then
        local baseHorseSpilits = dms.element(dms["horse_spirit_mould"], horse_spirits.mould_id)
        -- 升级消耗经验
        local upgrade_cost_exp = dms.atoi(baseHorseSpilits, horse_spirit_mould.upgrade_cost_exp)   
        local get_exp = 0
        for k,v in pairs(_ED.horse_spirits) do
            if tonumber(v.horse_id) > 0 then
            else
                -- 可提供经验
                local horseSpilitsData = dms.element(dms["horse_spirit_mould"], v.mould_id)
                local make_exp = dms.atoi(horseSpilitsData, horse_spirit_mould.make_exp) 
                get_exp = get_exp + v.now_exp + make_exp
            end
        end
        if upgrade_cost_exp > 0 then 
            if get_exp >= upgrade_cost_exp - horse_spirits.now_exp then
                return true
            end
        end
    end
    return false
end

--橙色附魔碎片可合成
function getHorseCombingSoulTip()
    --所需碎片
    local param = dms.int(dms["horse_config"], 4, horse_config.param)     
    --如果拥有碎片大于或等于所需碎片时推送
    if tonumber(_ED.user_info.horse_spirits_patch) >= param then 
        return true
    end
    return false
end

--所有珍兽
function getHorseAllTip()
    if funOpenDrawTip(87, false) == true then
        return false
    end
    for i=2,6 do
        if zstring.tonumber(_ED.formetion[i]) ~= 0 then
            local ship = _ED.user_ship["".._ED.formetion[i]]
            if getOneHorseTips(ship) == true then
                return true
            end
        end
    end
    return false
end

-- 单个英雄珍兽
function getOneHorseTips( ship )
    if funOpenDrawTip(87, false) == true then
        return false
    end
    local rider_horse_id = ship.rider_horse_id
    if tonumber(rider_horse_id) <= 0 then
        if _ED.horses ~= nil then
            for k,v in pairs(_ED.horses) do
                if tonumber(v.ship_id) <= 0 then
                    return true
                end
            end
        end
    else
        if _ED.horses ~= nil then
            local baseHorse = _ED.horses[""..rider_horse_id]
            if baseHorse ~= nil then
                local baseQuality = dms.int(dms["horse_mould"], baseHorse.mould_id, horse_mould.quality)
                for k,v in pairs(_ED.horses) do
                    if tonumber(v.ship_id) <= 0 then
                        local quality = dms.int(dms["horse_mould"], v.mould_id, horse_mould.quality)
                        if quality > baseQuality then
                            return true
                        end
                    end
                end
                local max_horse_spirit = dms.int(dms["horse_mould"], baseHorse.mould_id, horse_mould.max_horse_spirit)
                local horse_spirits_type = {}
                local index = 0 
                local sort_order = {}
                for k,v in pairs(baseHorse.horse_spirits) do
                    if k <= max_horse_spirit then
                        if tonumber(v) ~= 0 then
                            index = index + 1
                            local spirits = _ED.horse_spirits[""..v].mould_id
                            local same_type_id = dms.int(dms["horse_spirit_mould"], spirits, horse_spirit_mould.same_type_id)
                            table.insert(horse_spirits_type,same_type_id)
                            if getHorseSpilitsWareTip( _ED.horse_spirits[""..v] ) == true then
                                return true
                            end
                        else
                            table.insert(sort_order,k)
                        end
                    end
                end
                if _ED.horse_spirits ~= nil then
                    for i,v in pairs(_ED.horse_spirits) do
                        if tonumber(v.horse_id) > 0 then
                        else
                            local horse_spirit_type = dms.int(dms["horse_spirit_mould"], v.mould_id, horse_spirit_mould.horse_spirit_type)
                            if horse_spirit_type == 1 then
                                -- 格子开启等级
                                local horse_spirit_open_info = dms.string(dms["horse_mould"], baseHorse.mould_id, horse_mould.horse_spirit_open_info) 
                                local infos = zstring.split(horse_spirit_open_info, "|")
                                local is_lock = false
                                local open_level = 0
                                -- 判断是否有开启且未镶嵌兽魂的格子
                                for n,m in pairs(sort_order) do
                                    for k,l in pairs(infos) do
                                        if k == tonumber(m) then
                                            local spirit_info = zstring.split(l, ",")
                                            open_level = tonumber(spirit_info[2])
                                            if tonumber(_ED.user_info.user_grade) >= open_level then
                                                is_lock = true
                                            end
                                        end
                                    end
                                end
                                -- 镶嵌过兽魂，有不同类型的可以镶嵌
                                local same_type_id = dms.int(dms["horse_spirit_mould"], v.mould_id, horse_spirit_mould.same_type_id)
                                local have_type = false
                                if #horse_spirits_type ~= 0 then 
                                    for i,v in pairs(horse_spirits_type) do
                                        if same_type_id == tonumber(v) then
                                            have_type = true
                                            break
                                        end
                                    end
                                    if have_type == false and index < max_horse_spirit and is_lock == true then
                                        return true
                                    end
                                else -- 没镶嵌过兽魂
                                    if is_lock == true then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    for k,v in pairs(baseHorse.horse_spirits) do
                        if k <= max_horse_spirit then
                            if tonumber(v) ~= 0 then
                                if haveHorseSpilitsUpTip(_ED.horse_spirits[""..v]) == true then
                                    return 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

--可合成兽魂
function getHorseSpilitsCombingTip()
    --所需碎片
    local recharge_infos = dms.string(dms["horse_change"], 1, horse_change.recharge_infos)
    local recharge_infos = zstring.split(recharge_infos, ",")
    --如果拥有碎片大于或等于所需碎片时推送
    if tonumber(_ED.user_info.horse_spirits_patch) >= tonumber(recharge_infos[3])then
        return true
    end
    return false
end