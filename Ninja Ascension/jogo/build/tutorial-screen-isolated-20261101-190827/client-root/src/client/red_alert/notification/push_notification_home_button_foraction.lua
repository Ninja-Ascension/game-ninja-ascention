-- Initialize push notification center state machine.
push_notification_vip_level = nil
push_notification_vip_value = nil
push_notification_transport_resouce = nil
local function init_push_notification_home_button_foraction_terminal()
	--主页面动态功能按钮的推送(英雄)
    local push_notification_home_button_foraction_role_terminal = {
        _name = "push_notification_home_button_foraction_role",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getHeroAllTip() == true then
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

    --主页面动态功能按钮的推送(装备)
    local push_notification_home_button_foraction_equipment_terminal = {
        _name = "push_notification_home_button_foraction_equipment",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getHaveEquipCanWearAllTip() == true then
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

                if getHaveGemAllTip() == true then
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

    --主页面动态功能按钮的推送(日常)
    local push_notification_home_button_foraction_campaign_terminal = {
        _name = "push_notification_home_button_foraction_campaign",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getCampaignAllTip() == true then
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

        --主页面动态功能按钮的推送(任务)
    local push_notification_home_button_foraction_task_terminal = {
        _name = "push_notification_home_button_foraction_task",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getTaskAllTip() == true then
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

    --主页面动态功能按钮的推送(公会)
    local push_notification_home_button_foraction_union_terminal = {
        _name = "push_notification_home_button_foraction_union",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getUnionAllTip() == true then
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

    --主页面动态功能按钮的推送(江湖)
    local push_notification_home_button_foraction_rivers_terminal = {
        _name = "push_notification_home_button_foraction_rivers",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getRiversAllTip() == true and pushNotificationRivers() == true then
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

    --武林奇遇
    local push_notification_home_button_foraction_lakes_terminal = {
        _name = "push_notification_home_button_foraction_lakes",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getRiversAllTip() == true and pushNotificationRivers() == false then
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

    --主页面动态功能按钮的推送(包裹)
    local push_notification_home_button_foraction_packs_terminal = {
        _name = "push_notification_home_button_foraction_packs",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getPacksAllTip() == true then
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

    state_machine.add(push_notification_home_button_foraction_role_terminal)
    state_machine.add(push_notification_home_button_foraction_equipment_terminal)
    state_machine.add(push_notification_home_button_foraction_campaign_terminal)
    state_machine.add(push_notification_home_button_foraction_task_terminal)
    state_machine.add(push_notification_home_button_foraction_union_terminal)
    state_machine.add(push_notification_home_button_foraction_rivers_terminal)
    state_machine.add(push_notification_home_button_foraction_lakes_terminal)
    state_machine.add(push_notification_home_button_foraction_packs_terminal)
    state_machine.init()
end
init_push_notification_home_button_foraction_terminal()


local function checkNeedStarupPush(prop_mould_id , need_count ,need_silver,need_ship_numbers,ship)
    local now_have_prop = false
    for i,prop in pairs(_ED.user_prop) do
        if tonumber(prop.user_prop_template) == prop_mould_id then
            if tonumber(prop.prop_number) >= need_count and tonumber(_ED.user_info.user_silver) >= need_silver then
                now_have_prop = true
            else
                return false
            end
        end
    end

    if now_have_prop == false then
        return false
    end

    local ship_numbers = findTheSameBaseShipMouldBy(ship)
    if ship_numbers >= need_ship_numbers then
    else
        return false
    end
    return true
end

local function checkNeedPush(prop_mould_id , need_count , need_silver)
    for i,prop in pairs(_ED.user_prop) do
        if tonumber(prop.user_prop_template) == prop_mould_id then
            if zstring.tonumber(prop.prop_number) >= need_count and tonumber(_ED.user_info.user_silver) >= need_silver then
                return true
            end
        end
    end
    return false
end

function getheroIconAllTip(ship)
    -- 是否有英雄星格可铭刻
    local star_id_tab = ship.stars_state
    local can_up_star = true
    for i,v in pairs(star_id_tab) do
        local star_id = v.star_id
        if zstring.tonumber(star_id) == -1 or zstring.tonumber(star_id) == 0 then
            can_up_star = false
        else
            local state = v.state
            local star_data = dms.element(dms["star_mould"],star_id)
            local need_prop1 = dms.atoi(star_data,star_mould.need_prop1)
            local need_prop1_count = dms.atoi(star_data,star_mould.need_prop1_count)
            local need_silver1 = dms.atoi(star_data,star_mould.need_silver1)
            if tonumber(state) ~= 1 then
                can_up_star = false
                if checkNeedPush(need_prop1,need_prop1_count,need_silver1) == true then
                    return true
                end
            end
        end
    end

    local required_material_id = dms.string(dms["ship_mould"],ship.ship_template_id,ship_mould.required_material_id)   --进阶需求索引
    local ship_grow_requirement_data = dms.element(dms["ship_grow_requirement"], required_material_id)
    local star_up_need_prop = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1)                 --需求的材料
    local star_up_need_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1_count)          --需求的材料数量
    local star_up_need_silver = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_silver)              --需求的金币
    local need_same_card_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_same_card_count)    --需求同ID武将数量
    if can_up_star == true and 
        checkNeedStarupPush(star_up_need_prop,
                            star_up_need_count,
                            star_up_need_silver,
                            need_same_card_count,
                            ship) == true then  
        return true
    end
	return false
end

--羁绊推送
function getheroFettersTip(ship)
    local total_count = #ship.relationship
    local current_count = 0
    for k=1, total_count do
        local is_activited = ship.relationship[k].is_activited
        if nil == is_activited then
            break
        end
        local rela_total_numbers = #is_activited
        local activited_numbers = 0
        local can_acitvit_numbers = 0
        for i,activited_id in pairs(is_activited) do
            if tonumber(activited_id) >= 0 then
                activited_numbers = activited_numbers + 1
            else
                local numbers = 0
                local relationship_id = ship.relationship[k].relationship_id
                local relationship_data = dms.element(dms["fate_relationship_mould"],relationship_id)
                local mould_id = dms.atoi(relationship_data,fate_relationship_mould.relation_need1+(i-1)*2)
                local rele_type = dms.atoi(relationship_data,fate_relationship_mould.relation_need1_type+(i-1)*2)
                if rele_type == 0 then
                    for i,v in pairs(_ED.user_ship) do
                        if tonumber(v.ship_base_template_id) == tonumber(mould_id) and 
                            -- v.ship_id ~= ship.ship_id and 
                            zstring.tonumber(v.formation_index) == 0 and
                            zstring.tonumber(v.little_partner_formation_index) == 0
                            then
                            numbers = numbers + 1
                            break
                        end
                    end
                else
                    for i,equip in pairs(_ED.user_equiment) do
                        if tonumber(equip.user_equiment_template) == tonumber(mould_id) and 
                            zstring.tonumber(equip.ship_id) == 0 and
                            zstring.tonumber(equip.rela_state) == 0 
                            then
                            numbers = numbers + 1
                            break
                        end
                    end
                end
                if numbers > 0 then
                    can_acitvit_numbers = can_acitvit_numbers + 1
                end
            end
        end
        if can_acitvit_numbers + activited_numbers == rela_total_numbers
            and can_acitvit_numbers > 0 then
            current_count = current_count + 1
        end
    end
    if current_count > 0 then
        -- current_count == total_count then
        return true
    end
    return false
end

-- 突破推送
function getheroGradeUpTip(ship)
    local ship_mould_id = ship.ship_template_id or ship.ship_mould_id
    local shipSkillGrowUpParam = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.skill_grow_up_param)
    shipSkillGrowUpParam = zstring.split(shipSkillGrowUpParam, "|")
    local maxOpenIndex = 0
    local waitOpenIndex = -1
    for i, v in pairs(shipSkillGrowUpParam) do
        local isAlive = ship.skill_grow_up_states[i] == "1"
        if isAlive then
            maxOpenIndex = i
        else
            if waitOpenIndex < 0 then
                waitOpenIndex = i
            end
        end
    end
    local drawIndex = maxOpenIndex
    if waitOpenIndex > maxOpenIndex then
        drawIndex = waitOpenIndex
    end
    if waitOpenIndex < maxOpenIndex then
        return false
    end
    local function getShipNumber(need_same_card_count)
        local have_numbers = 0
        local ship_str = ""
        
        for i,_ship in pairs(_ED.user_ship) do
            if _ship.ship_base_template_id == ship.ship_base_template_id and _ship.ship_id ~= ship.ship_id 
                and zstring.tonumber(_ship.ship_template_id) == zstring.tonumber(ship.ship_base_template_id)
                and zstring.tonumber(_ship.formation_index) == 0
                and zstring.tonumber(_ship.little_partner_formation_index) == 0
                and zstring.tonumber(_ship.skill_grow_up_level) <= 0
                then
                local nv = true
                for e, m in pairs(_ship.equipment) do
                    if zstring.tonumber(m.user_equiment_id) > 0 then
                        nv = false
                    end
                end
                for j,k in pairs(_ship.stars_state) do
                    if tonumber(k.state) == 1 then
                        nv = false
                    end
                end
                if true == nv then
                    have_numbers = have_numbers + 1 
                end
            end
        end
        return have_numbers
    end
    local openParam = zstring.split(shipSkillGrowUpParam[drawIndex], ",")
    local shipGrowRequirement = dms.element(dms["ship_grow_requirement"], openParam[2])
    local needLevel = dms.atoi(shipGrowRequirement, ship_grow_requirement.need_level)
    local needSameCardCount = dms.atoi(shipGrowRequirement, ship_grow_requirement.need_same_card_count)
    local growNeedExperience = dms.atoi(shipGrowRequirement, ship_grow_requirement.grow_need_experience)
    local needCount = 0
    local have_numbers = 0
    if growNeedExperience > 0 then
        needCount = growNeedExperience
        have_numbers = _ED.user_info.jade
    else
        needCount = needSameCardCount
        have_numbers = getShipNumber(needSameCardCount)
    end
    if zstring.tonumber(have_numbers) >= zstring.tonumber(needCount) and zstring.tonumber(_ED.home_build["1"].level) >= needLevel + 1 then
        return true
    end
    return false
end

-- 是否有可穿戴装备
function getHaveEquipCanWearAllTip()
    if funOpenDrawTip(68,false) == true then
        return false
    end 
    local table_panel_index = {0,1,2,3,9,10}
    for i=2,6 do
        local ship_id = _ED.formetion[i]
        if zstring.tonumber(ship_id) ~= 0 then
		    for j, equip_type in pairs(table_panel_index) do
                local equipment_id = _ED.user_ship[""..ship_id].equipment[j].user_equiment_id
                if equipment_id ~= nil then
                    if zstring.tonumber(equipment_id) ~= 0 then
                        for m,v in pairs(_ED.user_equiment) do
                            if tonumber(v.ship_id) == 0 and tonumber(v.rela_state) == 0 then 
                                local equipment = _ED.user_equiment[""..equipment_id]
                                if nil ~= equipment and zstring.tonumber(equipment.equipment_type) == zstring.tonumber(v.equipment_type) and zstring.tonumber(equipment.rank_level) < zstring.tonumber(v.rank_level) then
                                    return true
                                end
                            end
                        end
                    else 
        		        for k,equip in pairs(_ED.user_equiment) do
        		            if tonumber(equip.ship_id) == 0 and tonumber(equip.rela_state) == 0 and tonumber(equip.equipment_type) == equip_type then 
        		                return true
        		            end
        		        end
                    end
                end
		    end
		end
	end
    return false
end

--宝石
function getHaveGemAllTip()
    if funOpenDrawTip(68,false) == true then
        return false
    end 
    local table_panel_index = {0,1,2,3,9,10}
    for i=2,6 do
        local ship_id = _ED.formetion[i]
        if zstring.tonumber(ship_id) ~= 0 then
            for j, equip_type in pairs(table_panel_index) do
                local user_equiment_id = _ED.user_ship[""..ship_id].equipment[j].user_equiment_id
                if user_equiment_id ~= nil then 
                    if zstring.tonumber(user_equiment_id) > 0 then
                        local equip = _ED.user_equiment[""..user_equiment_id]
                        if equip ~= nil then 
                            local table_gem_type = {}
                            for n,v in pairs(equip.jewelrys) do
                                if tonumber(v) ~= 0 then
                                    local gem = _ED.user_gems[""..v]
                                    local gem_type = dms.int(dms["gems_mould"],gem.mould_id,gems_mould.gem_type)
                                    table.insert(table_gem_type,gem_type)
                                end
                            end

                            for l,gem_id in pairs(equip.jewelrys) do
                                if tonumber(gem_id) <= 0 then
                                    local can_add_gems = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_gem_numbers)
                                    if l <= can_add_gems then
                                        for n,v in pairs(_ED.user_gems) do
                                            local can_push = false
                                            local have_type = false
                                            if tonumber(v.equip_id) > 0 then
                                            else
                                                local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
                                                can_push = true
                                                for k,m in pairs(table_gem_type) do
                                                    if gem_type == m then
                                                        have_type = true
                                                        break
                                                    end
                                                end
                                            end

                                            if can_push == true and have_type == false then
                                                return true
                                            end
                                        end
                                    end
                                else
                                    local gem = _ED.user_gems[""..gem_id]
                                    local getExp = 0
                                    for n,v in pairs(_ED.user_gems) do
                                        if tonumber(v.equip_id) > 0 then
                                        else
                                            local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
                                            if gem_type == gem.gem_type then
                                                getExp = getExp + v.give_exp
                                            end
                                        end
                                    end
                                    if gem.up_need_exp > 0 then 
                                        if getExp >= gem.up_need_exp - gem.exp then
                                            return true
                                        end
                                    end
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

--英雄
function getHeroAllTip()
    if funOpenDrawTip(66,false) == true then
        return false
    end 
    for i=2,6 do
        if zstring.tonumber(_ED.formetion[i]) ~= 0 then
            local ship = _ED.user_ship["".._ED.formetion[i]]
            if getheroIconAllTip(ship) == true then     -- 升星
            	return true
            elseif getheroFettersTip(ship) == true then -- 羁绊
                return true
            elseif getheroGradeUpTip(ship) == true then -- 突破
                return true
            end
        end
    end
	return false
end

--日常
function getCampaignAllTip()
    if funOpenDrawTip(64,false) == true then
        return false
    end 
    -- 侠客行
    if funOpenDrawTip(126,false) == false then
        local leave_times = dms.int(dms["base_consume"],51,base_consume.vip_0_value + tonumber(_ED.vip_grade)) - _ED.three_kings_reset_times
        if leave_times > 0 or _ED.three_kings_sweeping == 1 then
            return true
        end
    end
    -- 宝石山谷
    if funOpenDrawTip(112,false) == false then
    	local max_times = _ED.push_notification_info.campaign.gem_copy_max_times
        local attack_times = 0
        local scene_id = _ED.push_notification_info.campaign.gem_copy_scene_id
        for i,v in pairs(scene_id) do
            if tonumber(_ED.get_star_count[v]) > 0 then
                attack_times = attack_times + 1
            end
        end
        local leave_times = max_times - attack_times
        if leave_times > 0 then
            return true
        end
    end
    -- 进入游戏请求运送军资数据
    if funOpenDrawTip(120,false) == false then
        if (_ED.transport_resouce_info == nil or _ED.transport_resouce_info.is_transport == nil) and push_notification_transport_resouce ~= true then
            push_notification_transport_resouce = true
            NetworkManager:register(protocol_command.ship_military_init.code, nil, nil, nil, nil, nil, false, nil) 
        end
    	-- 运送军资
        local server_time = _ED.system_time + (os.time() - _ED.native_time)
        server_time = os.date("*t", zstring.tonumber(server_time))
        if (server_time.hour >= 12 and server_time.hour <= 13) or (server_time.hour == 13 and server_time.min <= 30) or (server_time.hour >= 20 and server_time.hour <= 22) then
            local leave_tran_times = zstring.tonumber(_ED.transport_resouce_info.leave_tran_times)       --剩余运送次数
            local leave_attack_times = zstring.tonumber(_ED.transport_resouce_info.leave_attack_times)    --剩余掠夺次数
            if leave_tran_times > 0 or leave_attack_times > 0 then
                return true
            end
        end
    end 
 	-- 黑石山
    if funOpenDrawTip(111,false) == false then
        if push_notification_vip_level == nil or zstring.tonumber(push_notification_vip_level) ~= tonumber(_ED.vip_grade) then 
            push_notification_vip_level = _ED.vip_grade
            push_notification_vip_value = dms.int(dms["base_consume"],69,base_consume.vip_0_value + tonumber(push_notification_vip_level))
        end
        local leave_times = push_notification_vip_value - tonumber(_ED.npc_equip_all_attack_times)
        if leave_times > 0 then
        	return true
        end
    end
    -- 守卫襄阳
    if funOpenDrawTip(129,false) == false then
        local max_attack_times = _ED.push_notification_info.campaign.raiders_max_times
        local leave_attack_times = max_attack_times - _ED.raiders_cut_attack_times
        if leave_attack_times ~= 0 then
            return true
        end
    end
 	-- 英魂试炼
    if funOpenDrawTip(115,false) == false then
        if _ED.soul_duplicate.attack_count == 0 then
            return true
        end
    end
    -- 资源点
    if funOpenDrawTip(138,false) == false then
        if _ED.city_resource_user_info ~= nil then
            if tonumber(_ED.city_resource_user_info.my_city_id) <= 0 then
                local server_time = _ED.system_time + (os.time() - _ED.native_time)
                server_time = os.date("*t", zstring.tonumber(server_time))
                if server_time.hour >= 8 then
                    return true
                end
            end
        end
    end
	return false
end

--任务
function getTaskAllTip()
    if funOpenDrawTip(63,false) == true then
        return false
    end
    if _ED.user_task_infos == nil then
        return false
    end
    if _ED.user_task_infos["0"] == nil then
        return false
    end
    for i,v in pairs(_ED.user_task_infos["0"]) do
        if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
            return true
        end
    end
    if _ED.user_task_infos["1"] == nil then
        return false
    end
    for i,v in pairs(_ED.user_task_infos["1"]) do
        if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
            return true
        end
    end
    if _ED.user_task_infos["2"] == nil then
        return false
    end
    for i,v in pairs(_ED.user_task_infos["2"]) do
        if tonumber(v.achievement_finish_type) == 28 then
            if zstring.tonumber(v.task_complete_count) <= zstring.tonumber(v.need_complete_count) then
                return true
            end
        else
            if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
                return true
            end
        end
    end
    return false
end

--公会
function getUnionAllTip()
    if funOpenDrawTip(70,false) == true then
        return false
    end
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        then
        return false
    end
    --组队争霸
    if tonumber(_ED.union.user_union_info.team_fight_use_state) == 0 then
        return true
    end

    --阿拉希之战
    push_npc_level = _ED.push_notification_info.union.axila_npc_level
    for k,v in pairs(push_npc_level) do
        local levels = zstring.split(v, ",")
        local min_level = levels[1]
        local max_level = levels[2]
        local npc_id = levels[3]
        if tonumber(_ED.user_info.user_grade) >= tonumber(min_level)
            and tonumber(_ED.user_info.user_grade) <= tonumber(max_level)
            then
            if tonumber(_ED.npc_current_attack_count[tonumber(npc_id)]) == 0 then
                return true
            end
        end
    end

    --公会建设
    if tonumber(_ED.union.user_union_info.build_count) == 0 then
        return true
    end
    
    -- 加入申请
    if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
        if _ED.union.union_examine_list_sum ~= nil and 
            _ED.union.union_examine_list_sum ~= "" and
            tonumber(_ED.union.union_examine_list_sum) ~= 0 then
            return true
        end
    end
    return false
end

--江湖
function getRiversAllTip()
    if funOpenDrawTip(123,false) == true then
        return false
    end
    local max_attack_times = _ED.push_notification_info.campaign.raiders_max_times
    local leave_attack_times = max_attack_times - _ED.raiders_cut_attack_times
    if leave_attack_times ~= 0 then
        return true
    end
    return false
end

-- 宝箱、宝石袋
function getPacksAllTip()
    for i,v in pairs(_ED.user_prop) do
        -- 如果拥有宝箱、宝石袋就推送
        local use_of_prop_type = zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.prop_type))
        if use_of_prop_type == 0 then
            return true
        end
    end
    return false
end