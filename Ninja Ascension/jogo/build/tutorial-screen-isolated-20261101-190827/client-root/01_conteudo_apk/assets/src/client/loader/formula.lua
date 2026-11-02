local FightUtil = {}
FightUtil.SKILL_CATEGORY_OURSITE_SPEED = 12
FightUtil.SKILL_CATEGORY_OURSITE_DEFENCE = 13
FightUtil.SKILL_CATEGORY_OURSITE_EVADE = 14
FightUtil.SKILL_CATEGORY_OURSITE_AUTHORITY = 15

local skillBasePropertyMap = {}
local _ZERO_BASE_PROPERTY = {
	speed = 0,
	defence = 0,
	avd = 0,
	authority = 0
}
function getSkillBaseProperty(skillMouldId)
	if (skillMouldId <= 0) then		
		return	_ZERO_BASE_PROPERTY
	end
	local cachedProperty = skillBasePropertyMap[skillMouldId]
	if (cachedProperty ~= nil)then
		return cachedProperty
	end

	local skillMould = dms.element(dms['skill_mould'], skillMouldId)
	if (skillMould == nil) then
		return _ZERO_BASE_PROPERTY
	end
	--print("SkillMould: ", skillMould)
	cachedProperty = {
		speed = 0,
		defence = 0,
		avd = 0,
		authority = 0
	}
	--print("column id: ", skill_mould.health_affect)
	local healthAffect = dms.atos(skillMould, skill_mould.health_affect)
	--print("Skill healthAffect: ", healthAffect)
	local skillInfluenceIdArray = zstring.split(healthAffect, ",")
	for _, skillInfluenceId in pairs( skillInfluenceIdArray) do
		local skillInfluence = dms.element(dms['skill_influence'], skillInfluenceId)
		--print (skillInfluence)
		--print("Column id: ", skill_influence.skill_category, skill_influence.skill_effect_min_value)
		local skillInfluenceCategory = dms.atoi(skillInfluence, skill_influence.skill_category)
		local skillEffectMinValue = dms.atoi(skillInfluence, skill_influence.skill_effect_min_value)
		local skillEffectMaxValue = dms.atoi(skillInfluence, skill_influence.skill_effect_max_value)
		--print("Skill influence ", skillInfluenceCategory, skillEffectMinValue, skillEffectMaxValue)
		if(skillInfluenceCategory == FightUtil.SKILL_CATEGORY_OURSITE_SPEED) then
			cachedProperty.speed = cachedProperty.speed + skillEffectMinValue
		elseif (skillInfluenceCategory == FightUtil.SKILL_CATEGORY_OURSITE_DEFENCE ) then
			cachedProperty.defence = cachedProperty.defence + skillEffectMinValue
		elseif (skillInfluenceCategory == FightUtil.SKILL_CATEGORY_OURSITE_EVADE) then
			cachedProperty.avd = cachedProperty.avd + skillEffectMinValue
		elseif (skillInfluenceCategory == FightUtil.SKILL_CATEGORY_OURSITE_AUTHORITY) then
			cachedProperty.authority = cachedProperty.authority + skillEffectMinValue
		end
	end
	skillBasePropertyMap[skillMouldId] = cachedProperty
	return cachedProperty
end

local equipBasePropertyMap = {}
function getEquipmentBaseProperty(equipMouldId)
	if (equipMouldId == nil or equipMouldId <= 0) then
		return _ZERO_BASE_PROPERTY
	end

	local cachedProperty = equipBasePropertyMap[equipMouldId]
	if (cachedProperty ~= nil) then
		return cachedProperty
	end
	cachedProperty = {
		speed = 0,
		defence = 0,
		avd = 0,
		authority = 0
	}
	local equipMould = dms.element(dms['equipment_mould'], equipMouldId)
	--print("Equipment mould: ", equipMould)
	--print ("Column index: ", equipment_mould.skill_mould)
	local skillMouldId = dms.atoi(equipMould, equipment_mould.skill_mould)
	--local skillMould = dms.element(dms['skill_mould'], skillMouldId)
	addBaseProperty(cachedProperty, getSkillBaseProperty(skillMouldId))
	
	equipBasePropertyMap[equipMouldId] = cachedProperty
	return cachedProperty
end

function getShipBaseProperty(ship_mould_id)
	local this_ship_mould = dms.element(dms['ship_mould'], ship_mould_id)
	local deadly_skill_mould_id = dms.atoi(this_ship_mould, ship_mould.deadly_skill_mould)
	local base_property = {
		speed = 0,
		defence = 0,
		avd = 0,
		authority = 0
	}
	addBaseProperty(base_property, getSkillBaseProperty(deadly_skill_mould_id))
	return base_property
end

function getTrainedShipBaseProperty(ship_mould_id)
	local this_ship_mould = dms.element(dms['ship_mould'], ship_mould_id)
	local deadly_skill_mould_id = dms.atoi(this_ship_mould, ship_mould.deadly_skill_mould)
	local init_equipment = dms.atoi(this_ship_mould, ship_mould.treasureSkill)
	local base_property = {
		speed = 0,
		defence = 0,
		avd = 0,
		authority = 0
	}
	addBaseProperty(base_property, getSkillBaseProperty(deadly_skill_mould_id))
	addBaseProperty(base_property, getEquipmentBaseProperty(init_equipment))
	return base_property
end
	

function addBaseProperty(dest, added) 
	dest.speed = dest.speed + added.speed
	dest.defence = dest.defence + added.defence
	dest.avd = dest.avd + added.avd
	dest.authority = dest.authority + added.authority
end	

function recalShipBaseProperty()
	
end

function getShipTotalCostExperience(ship)
	local ship_mould_id = ship.ship_template_id
	local level = tonumber(ship.ship_grade)
	
	local stage = dms.int(dms['ship_mould'], ship_mould_id, ship_mould.initial_rank_level)
	return getTotalCostExperience(stage, level)
end 
function getTotalCostExperience(stage, level)
	--function dms.searchs(element, column1, value1, column2, value2)
	local element = dms['ship_experience_param']
	if element == nil or level == nil or level == nil then
		return 0
    end
	local col_stage = ship_experience_param.stage
	local col_level = ship_experience_param.level
	local col_experience = ship_experience_param.needs_experience
	stage = tonumber(""..stage)
	level = tonumber("" .. level)
	local total_needs = 0
	--for i, data in ipairs(element) do
	for i=1,level do
		-- data = split(data, "\t")
		-- local temp_stage = tonumber(data[col_stage])
		-- local temp_level = tonumber( data[col_level])
		-- local temp_experience = tonumber(data[col_experience])
		local levelInfo = dms.element(dms["ship_experience_param"], i)
		local temp_stage = dms.atoi(levelInfo, ship_experience_param.stage)
		local temp_level = dms.atoi(levelInfo, ship_experience_param.level)
		local temp_experience = dms.atoi(levelInfo, ship_experience_param.needs_experience)
		if (temp_stage > stage) then
			--print("temp_stage > stage", temp_stage, stage)
			break
		end
		if (temp_stage == stage and temp_level >= level) then
			--print("temp_level >= level", temp_stage, temp_level, level)
			break
		end
		total_needs = total_needs + temp_experience
	end
	return math.floor(total_needs * 0.7)
end

function recalcFormationBaseProperty(formationString)
	local totalBaseProperty = {
		speed = 0,
		defence = 0,
		avd = 0,
		authority = 0
	}
	local formationShipMouldList = {}
	--- List<SkillMould> skillMouldList = new ArrayList<SkillMould>();
	--- int totalFightForce = simpleFormation.getFightForceAdd();
	--- BaseProperty totalBaseProperty = new BaseProperty();
	local unionSkillMouldList = {}
	local shipIds = zstring.split(formationString, ",")

	for _, shipIdString in pairs(shipIds) do		
		local ship = _ED.user_ship[shipIdString]
		local shipMouldId = ship.ship_template_id

		local base_shipMouldId = dms.int(dms['ship_mould'], shipMouldId, ship_mould.base_mould)
		local isMaster = dms.int(dms['ship_mould'], shipMouldId, ship_mould.captain_type) == 0
		--table.insert(formationShipMouldList, shipMouldId)		
		formationShipMouldList[base_shipMouldId] = 1

		if (ship.treasure_strengthen_level ~= nil and
			tonumber(ship.treasure_strengthen_level) ~= nil and
			tonumber(ship.treasure_strengthen_level) > 0) then
			addBaseProperty(totalBaseProperty, getTrainedShipBaseProperty(shipMouldId))
		else
			addBaseProperty(totalBaseProperty, getShipBaseProperty(shipMouldId))
		end
		local this_ship_mould = dms.element(dms['ship_mould'], shipMouldId)
		--print(this_ship_mould)
		local union_skillId1 = dms.atoi(this_ship_mould, ship_mould.fitSkillOne)
		local union_skillId2 = dms.atoi(this_ship_mould, ship_mould.fitSkillTwo)
		--print(union_skillId1, union_skillId2)
		if (union_skillId1 > 0) then
			unionSkillMouldList[union_skillId1] = 1
			--table.insert(unionSkillMouldList, union_skillId1)
		end
		if (union_skillId2 > 0) then
			unionSkillMouldList[union_skillId2] = 1
			--table.insert(unionSkillMouldList, union_skillId2)
		end
		if (ship.equipment[1] ~= nil  and isMaster) then
			addBaseProperty(totalBaseProperty, getEquipmentBaseProperty(tonumber(ship.equipment[1].user_equiment_template)))
		end
		local oneagreement = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.price)
    	local twoagreement = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.need_honor)
    	local multiple_num = 0
		if zstring.tonumber(ship.agreementStates) == 1  then 
			if oneagreement > 0 then 

				local add_speed =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_speed)
				local add_denfence =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_denfence)
				local add_adv =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_adv)
				local add_authority =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_authority)
				
				totalBaseProperty.speed = totalBaseProperty.speed + add_speed
				totalBaseProperty.defence = totalBaseProperty.defence + add_denfence
				totalBaseProperty.avd = totalBaseProperty.avd + add_adv
				totalBaseProperty.authority = totalBaseProperty.authority + add_authority
			end
		end
		if zstring.tonumber(ship.agreementStates) == 2  then 
			if twoagreement > 0 and  oneagreement > 0 then 
				local add_speed1 =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_speed)
				local add_denfence1 =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_denfence)
				local add_adv1 =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_adv)
				local add_authority1 =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_authority)
				totalBaseProperty.speed = totalBaseProperty.speed + add_speed1
				totalBaseProperty.defence = totalBaseProperty.defence + add_denfence1
				totalBaseProperty.avd = totalBaseProperty.avd + add_adv1
				totalBaseProperty.authority = totalBaseProperty.authority + add_authority1

				multiple_num = dms.int(dms["contract_mould"], twoagreement, contract_mould.add_hero_attr_multiple)

				local add_speed =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_speed)
				local add_denfence =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_denfence)
				local add_adv =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_adv)
				local add_authority =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_authority)
				totalBaseProperty.speed = totalBaseProperty.speed + add_speed
				totalBaseProperty.defence = totalBaseProperty.defence + add_denfence
				totalBaseProperty.avd = totalBaseProperty.avd + add_adv
				totalBaseProperty.authority = totalBaseProperty.authority + add_authority
			end
		end
		local piratesConfig = dms.element(dms['pirates_config'],308)
		local maxLevel = dms.atoi(piratesConfig,pirates_config.param)
		if tonumber(ship.ship_breakthrough_level) >= maxLevel then
			
			if tonumber(ship.speed) > 0 then
				totalBaseProperty.speed = totalBaseProperty.speed + ship.speed * (1 + multiple_num)
			end
			if tonumber(ship.defence) > 0 then
				totalBaseProperty.defence = totalBaseProperty.defence + ship.defence * (1 + multiple_num)
			end
			if tonumber(ship.avd) > 0 then
				totalBaseProperty.avd = totalBaseProperty.avd + ship.avd * (1 + multiple_num)
			end
			if tonumber(ship.authority) > 0 then
				totalBaseProperty.authority = totalBaseProperty.authority + ship.authority * (1 + multiple_num)
			end
		end

	end

	local triggeredSkills = {}
	for skill_mould_id, _ in pairs(unionSkillMouldList) do
		if (triggeredSkills[skill_mould_id] == nil) then		
			local this_skill_mould = dms.element(dms['skill_mould'], skill_mould_id)
			local release_mould = dms.atos(this_skill_mould, skill_mould.release_mould)
			local shipMouldIds = zstring.split(release_mould, ",");
			local skillTriger = true
			for _, shipMouldId in pairs(shipMouldIds) do
				local exists = formationShipMouldList[tonumber(shipMouldId)]
				if (1 ~= exists) then
					skillTriger = false
					break
				end
			end
			if (skillTriger) then
				addBaseProperty(totalBaseProperty, getSkillBaseProperty(skill_mould_id))
				triggeredSkills[skill_mould_id] = 1
			end
		end
	end	
	return totalBaseProperty
end

--- 计算武将的战力公式( ship 为 EnvironmentData 中的对象)
function get_ship_fight_force(ship)
	local ship_mould_id = ship.ship_template_id
	local level = tonumber(ship.ship_grade)
	local equip_level = tonumber(ship.equipment_strengthen_level or 0)
	local break_up_level = tonumber(ship.ship_breakthrough_level or 0)
	return calculate_ship_fight_force(ship_mould_id, level, equip_level, break_up_level)
end

--- 计算武将觉醒后属性 加成
function get_ship_growup_added_fight_force(ship)
	local ship_mould_id = ship.ship_template_id
	local level = tonumber(ship.ship_grade)
	local equip_level = tonumber(ship.equipment_strengthen_level or 0)
	local break_up_level = tonumber(ship.ship_breakthrough_level or 0)
	
	local cur_ship_mould = dms.element(dms['ship_mould'], ship_mould_id)
	--print (cur_ship_mould)
	
	local next_ship_mould_id = dms.atoi(cur_ship_mould, ship_mould.grow_target_id)
	if (next_ship_mould_id <= 0) then
		return 0
	end
	
	local next_ship_mould = dms.element(dms['ship_mould'], next_ship_mould_id)
	local next_initial_level = dms.atoi(next_ship_mould, ship_mould.initial_level)
	--print("Ship mould change: ", ship_mould_id, next_ship_mould_id, level, next_initial_level)
	local old = calculate_ship_fight_force(ship_mould_id, level, equip_level, break_up_level)
	local changed = calculate_ship_fight_force(next_ship_mould_id, next_initial_level, equip_level, break_up_level)
	return changed - old
end

--- 计算武将强化后属性加成
function get_ship_strength_added_fight_force(ship)
	local ship_mould_id = ship.ship_template_id
	local level = tonumber(ship.ship_grade)
	local equip_level = tonumber(ship.equipment_strengthen_level or 0)
	local break_up_level = tonumber(ship.ship_breakthrough_level or 0)
	local old = calculate_ship_fight_force(ship_mould_id, level, equip_level, break_up_level)
	local after_strength = calculate_ship_fight_force(ship_mould_id, level + 1, equip_level, break_up_level)
	return after_strength - old
end

--- 计算武将强化后属性加成一键升级时使用
function get_ship_strength_added_fight_force_quick(ship,uplevel)
	local ship_mould_id = ship.ship_template_id
	local level = tonumber(ship.ship_grade)
	local equip_level = tonumber(ship.equipment_strengthen_level or 0)
	local break_up_level = tonumber(ship.ship_breakthrough_level or 0)
	local old = calculate_ship_fight_force(ship_mould_id, level, equip_level, break_up_level)
	local after_strength = calculate_ship_fight_force(ship_mould_id, uplevel, equip_level, break_up_level)
	return after_strength - old
end

--- 计算武将 突破后属性 加成
function get_ship_breakup_added_fight_force(ship)
	local ship_mould_id = ship.ship_template_id
	local level = tonumber(ship.ship_grade)
	local equip_level = tonumber(ship.equipment_strengthen_level or 0)
	local break_up_level = tonumber(ship.ship_breakthrough_level or 0)
	local old = calculate_ship_fight_force(ship_mould_id, level, equip_level, break_up_level)
	local after_breakup = calculate_ship_fight_force(ship_mould_id, level, equip_level, break_up_level + 1)
	return after_breakup - old
end

--- 计算武将 武具强化 或者 主角宿命强化 后属性加成
function get_ship_levelup_added_fight_force(ship)
	local ship_mould_id = ship.ship_template_id
	local level = tonumber(ship.ship_grade)
	local equip_level = tonumber(ship.equipment_strengthen_level or 0)
	local break_up_level = tonumber(ship.ship_breakthrough_level or 0)
	local old = calculate_ship_fight_force(ship_mould_id, level, equip_level, break_up_level)
	local after_levelup = calculate_ship_fight_force(ship_mould_id, level, equip_level + 1, break_up_level)
	return after_levelup - old
end


--- 计算武将的战力公式(传入的为简单对象)
--- ship_mould_id 武将模板id, 非基础模板                   对应于 ship 的 ship_template_id 属性
--- level   武将当前等级                                   对应于 ship 的ship_grade 属性
--- equip_level  武将武具强化等级  或者 主角 宿命强化等级, 对应ship 的 equipment_strengthen_level 属性 
--- break_up_level 武将限界突破等级,武将觉醒5此后可以突破  对应ship 的 ship_breakthrough_level 属性 
---（初始战力(包括觉醒加层)+(进阶等级*成长加成)） * （100+界限突破加成比例+武具强化加成比例）/100
function calculate_ship_fight_force(ship_mould_id, level, equip_level, break_up_level)
	local mould = dms.element(dms['ship_mould'], ship_mould_id)
	--print("ship_mould is: ", mould)

	local initial_power = dms.atoi(mould, ship_mould.initial_power)
	local initial_level = dms.atoi(mould, ship_mould.initial_level)
	local grow_power = dms.atoi(mould, ship_mould.grow_power)	
	local base = initial_power + (level - initial_level) * grow_power
	--print(initial_power, grow_power)
	local is_master = dms.atoi(mould, ship_mould.captain_type) == 0
	local added_rate = 0
	break_up_level = tonumber(break_up_level)
	if (break_up_level > 0) then
		added_rate = get_ship_breakup_add_rate(break_up_level)
	end
	
	local equip_strength_add_rate = 0
	if (is_master) then
		equip_strength_add_rate = get_master_ship_strength_add_rate(equip_level)
	else
		equip_strength_add_rate = get_ship_strength_add_rate(equip_level)
	end
	if (equip_strength_add_rate ~= nil) then
		added_rate = added_rate + equip_strength_add_rate
	end

	local add_force = 0
	if isMaster == true then
			local index_exp = get_agreement_level()
			add_force = dms.int(dms["contract_grade_param"],index_exp,contract_grade_param.add_force)
		end
	return math.floor(base * (100 + added_rate) / 100) + add_force
	--local base_fightforce = ship_mould[]
end

-- 人物(非主角) 觉醒到5 后, 界限突破属性加成
function get_ship_breakup_add_rate(break_up_level)
	if (tonumber(break_up_level) <= 0) then
		return 0
	end
	local v = dms.int(dms['limit_breached'], break_up_level, limit_breached.add_power)
	if (v == nil or v < 0) then
		v = 0
	end

	return v
end

-- 武具强化
function get_ship_strength_add_rate(equip_level)
	if (equip_level == nil or equip_level < 1) then
		return 0
	end
	return dms.int(dms['ship_rank_up_param'], equip_level, ship_rank_up_param.add_power)
end

-- 宿命武器强化
function get_master_ship_strength_add_rate(equip_level)
	if (equip_level == nil or equip_level < 1) then
		return 0
	end
	return dms.int(dms['destiny_strength_param'], equip_level, destiny_strength_param.property_add_rate)
end

local cached_type_ship_moulds = {}
local unionSkillMoulds = {}
function get_typed_base_ship_moulds()
	if (#cached_type_ship_moulds > 0) then
		return cached_type_ship_moulds
	end
	local datas = dms['ship_mould']
	if (type(datas) == 'string') then
		datas = datas.split("\r\n")
	end
	local retArray = {}
	--print ("=======  ship mould count =============", #datas)
	for i, mould in pairs(datas) do
		--local mould  = datas[i]

		local is_can_recruit = dms.atoi(mould, ship_mould.can_recruit) > 0
		local is_master = dms.atoi(mould, ship_mould.captain_type) == 0
		local is_base = dms.atoi(mould, ship_mould.base_mould) == tonumber(i)
		local ship_type = dms.atoi(mould, ship_mould.ship_type)
		
		if (is_base and is_master == false and is_can_recruit == true) then
			if (retArray[ship_type] == nil) then
				retArray[ship_type] = {}
			end
			table.insert(retArray[ship_type], mould)
			
			local union_skill1 = dms.atoi(mould, ship_mould.fitSkillOne)
			local union_skill2 = dms.atoi(mould, ship_mould.fitSkillTwo)
			if (union_skill1 > 0) then
				if (unionSkillMoulds[union_skill1] == nil) then
					unionSkillMoulds[union_skill1] = {}
				end
				table.insert(unionSkillMoulds[union_skill1], i)
			end
			
			if (union_skill2 > 0) then
				if (unionSkillMoulds[union_skill2] == nil) then
					unionSkillMoulds[union_skill2] = {}
				end
				table.insert(unionSkillMoulds[union_skill2], i)
			end
			
		end
	end
	cached_type_ship_moulds = retArray
	return cached_type_ship_moulds
end

function get_agreement_level()
	local index_exp = 1

    for i=1,31 do
        local exp_value =dms.int(dms["contract_grade_param"], i, contract_grade_param.upgrade_need_exp)
        if i == 31 then 
            index_exp = i
        end
        if exp_value > _ED.user_info.contract_exp then
            if i == 1 then 
                index_exp = i 
            else
                index_exp = i -1 
            end
            break 
        end 
    end
    return index_exp
end
--get_typed_base_ship_moulds()
--for sk_mould_id, val in pairs(unionSkillMoulds) do
--	print(sk_mould_id, val[1], val[2], val[3], val[4], val[5], val[6], val[7])
--end

-- 武具强化最大等级
function get_ship_max_equip_strength_level(ship_mould_id)
	local mould = dms.element(dms['ship_mould'], ship_mould_id)
	local is_master = dms.atoi(mould, ship_mould.captain_type) == 0
	if (is_master) then
		if (type(dms['destiny_strength_param']) == 'string' ) then
			elements_size = dms['destiny_strength_param'].split("\r\n")					
			return #elements_size
		else
			return #(dms['destiny_strength_param'])
		end
	else
		if (type(dms['ship_rank_up_param']) == 'string' ) then
			elements_size = dms['ship_rank_up_param'].split("\r\n")					
			return #elements_size
		else
			return #(dms['ship_rank_up_param'])
		end		
	end
end


function get_prop_amount(prop_mould_id)
	for _, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(prop_mould_id) then
			return zstring.tonumber(v.prop_number)
		end
	end
	return 0
end

function is_skill_union(skill_mould_data)
	local release_mould = dms.atos(skill_mould_data, skill_mould.release_mould)
	return (release_mould ~= nil and release_mould ~= '-1')
end

function recalc_triggered_union_skill()
	local idx = zstring.tonumber(_ED.formetion_index)
	_ED.triggered_union_skill = {}
	--_ED.formetion_list[idx]

	local formationShipMouldList = {}	
	local unionSkillMouldList = {}

	for i ,w in pairs(_ED.formetion) do
		--local ship_id = _ED.formetion_list[idx][i]   -- string
		if i >= 1 then 
			local temp_ship = _ED.user_ship[w]
			if (temp_ship ~= nil) then		
				local temp_ship_mould = dms.element(dms['ship_mould'], temp_ship.ship_template_id)
				local base_shipMouldId = dms.atoi(temp_ship_mould, ship_mould.base_mould)
				formationShipMouldList[base_shipMouldId] = 1

				local union_skillId1 = dms.atoi(temp_ship_mould, ship_mould.fitSkillOne)
				local union_skillId2 = dms.atoi(temp_ship_mould, ship_mould.fitSkillTwo)
				--print(union_skillId1, union_skillId2)
				if (union_skillId1 > 0) then
					unionSkillMouldList[union_skillId1] = 1			
				end
				if (union_skillId2 > 0) then
					unionSkillMouldList[union_skillId2] = 1			
				end
			end
		end
	end


	for skill_mould_id, _ in pairs(unionSkillMouldList) do
		if (_ED.triggered_union_skill[skill_mould_id] == nil) then		
			local this_skill_mould = dms.element(dms['skill_mould'], skill_mould_id)
			local release_mould = dms.atos(this_skill_mould, skill_mould.release_mould)
			local shipMouldIds = zstring.split(release_mould, ",");
			local skillTriger = true
			for _, shipMouldId in pairs(shipMouldIds) do
				local exists = formationShipMouldList[tonumber(shipMouldId)]
				if (1 ~= exists) then
					skillTriger = false
					break
				end
			end
			if (skillTriger) then				
				_ED.triggered_union_skill[skill_mould_id] = 1
			end
		end
	end	
end

function is_union_skill_trigger(skill_mould_id)
	return 1 == _ED.triggered_union_skill[tonumber(skill_mould_id)]
end

function get_language_index()
	local langue = cc.UserDefault:getInstance():getStringForKey("current_language", "zh")
	if langue == _lua_release_language_zh or langue == _lua_release_language_zh_CN then
		return 1
	elseif langue == "vi" then 
		return 2
	elseif langue == _lua_release_language_th then
		return 3
	else
		return 1
	end
end

----红警
-- |  attack_speed = "102" -- 攻速
-- |  ship_health = "3762.0" -- 生命
-- |  hero_fight = "595" 
-- |  ship_courage = "1367.0"--攻击
-- |  ship_type = 3--
-- |  captain_name = "泰兰德·语风"
-- |  block = "85.0"--格挡
-- |  relationship_count = 4
-- |  talent_count = 13
-- |  capacity = 8
-- |  wreck = "105.0"--破击
-- |  hit = "120.0" -- 命中
-- |  little_partner_formation_index = "0"
-- |  toughness = "90.0" -- 韧性
-- |  ship_quick = "274.0" -- 物防
-- |  ship_intellect = "301.0" -- 法防
-- |  formation_index = ""
-- |  dodge = "85.0" -- 闪避
-- |  camp_preference = 0
-- |  talent_state = "1,0,0,0,0,0,0,0,0,0,0,0,0,"
-- |  fetters_state = "-1,-1,-1,-1,|-1,|-1,|-1,|"
-- |  gas_gather = "0" -- 聚气
-- |  crit = "110.0" -- 暴击
-- |  ship_template_id = "394"
-- |  ship_id = "45"
-- 总基础攻击*0.1
-- 总兵力*0.5
-- 总物防*0.75
-- 总法防*0.75
-- 总命中值*1.5
-- 总闪避值*1.5
-- 总暴击值*1.5
-- 总韧性值*1.5
-- 总格挡值*1.5
-- 总破击值*1.5
-- 总减伤值*0.4
-- 总加伤值*0.4
fight_pro_number = {
	["0"] = 0.1,		-- 生命
	["1"] = 0.5,		-- 攻击
	["2"] = 0.75,		-- 物防
	["3"] = 0.75,		-- 法防
	["18"] = 0.4,		-- 伤害增加
	["19"] = 0.4,		-- 伤害减少
	["40"] = 1.5,		-- 暴击
	["41"] = 1.5,		-- 韧性
	["42"] = 1.5,		-- 命中
	["43"] = 1.5,		-- 闪避
	["44"] = 1.5,		-- 格挡
	["45"] = 1.5,		-- 破击
}

function getShipFight(ship, leadersShip, formation_type)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local shipMouldData = dms.element(dms["ship_mould"], ship.ship_template_id)  
		--兵种系数
		local armsCoefficient = dms.atoi(shipMouldData, ship_mould.wisdom)
		local ship_type = dms.atoi(shipMouldData, ship_mould.camp_preference)
		if ship_type == nil or ship_type < 1 or ship_type > 4 then
			return 0
		end

		-- --基础命中，基础闪避，基础暴击，基础抗爆
		local basisHit = dms.atoi(shipMouldData, ship_mould.initial_accuracy)
		local basisDodge = dms.atoi(shipMouldData, ship_mould.initial_jink)
		local basisCrit = dms.atoi(shipMouldData, ship_mould.initial_critical)
		local basisAnti = dms.atoi(shipMouldData, ship_mould.initial_critical_resist)
		
		--参数a
		local parameter_a = dms.float(dms["fight_config"], 29, fight_config.attribute)
		--参数b
		local parameter_b = dms.float(dms["fight_config"], 30, fight_config.attribute)
		--参数c
		local parameter_c = dms.float(dms["fight_config"], 31, fight_config.attribute)
		--参数d
		local parameter_d = dms.float(dms["fight_config"], 32, fight_config.attribute)
		--参数e
		local parameter_e = dms.float(dms["fight_config"], 33, fight_config.attribute)
		--参数f
		local parameter_f = zstring.tonumber(dms.float(dms["fight_config"], 39, fight_config.attribute))
		
		local leaderHit = 0
		local leaderDodge = 0
		local leaderCrit = 0
		local leaderAnti = 0
		if leadersShip ~= nil then
			leaderHit = zstring.tonumber(leadersShip.hit)
			leaderDodge = zstring.tonumber(leadersShip.dodge)
			leaderCrit = zstring.tonumber(leadersShip.crit)
			leaderAnti = zstring.tonumber(leadersShip.toughness)
		end
		local armor_addition = nil
		if formation_type > 0 then
			armor_addition = _ED.armor_attributes_addition[formation_type]
		end
		if armor_addition == nil then
			armor_addition = {
				HPAdditionRatio = 0,
				AttackAdditionRatio = 0,
				Hit = 0,
				Dodge = 0,
				Crit = 0,
				Anti = 0,
			}
		end

		local add_factor_percent = 0
		local less_factor_percent = 0
		if _ED.factor_info ~= nil then
			for k,v in pairs(_ED.factor_info) do
				if tonumber(v.factor_type) == 56 then
					add_factor_percent = zstring.tonumber(zstring.split(dms.string(dms["talent_mould"], v.mould_id, talent_mould.base_additional), ",")[2])
				elseif tonumber(v.factor_type) == 34 then
					less_factor_percent = zstring.tonumber(zstring.split(dms.string(dms["talent_mould"], v.mould_id, talent_mould.base_additional), ",")[2])
				end
			end
		end

		--单个兵种战力
		local ship_fight = armsCoefficient
			*(1+parameter_f*((zstring.tonumber(_ED.user_attributes_addition[ship_type].HPAdditionRatio) + zstring.tonumber(armor_addition.HPAdditionRatio))/100))
			*(1+parameter_f*((zstring.tonumber(_ED.user_attributes_addition[ship_type].AttackAdditionRatio) + zstring.tonumber(armor_addition.AttackAdditionRatio))/100))
			*(1+parameter_a*(basisHit/100+(zstring.tonumber(_ED.user_attributes_addition[ship_type].Hit) + leaderHit + zstring.tonumber(armor_addition.Hit))/100))
			*(1+parameter_a*(basisDodge/100+(zstring.tonumber(_ED.user_attributes_addition[ship_type].Dodge) + leaderDodge + zstring.tonumber(armor_addition.Dodge))/100))
			*(1+parameter_a*(basisCrit/100+(zstring.tonumber(_ED.user_attributes_addition[ship_type].Crit) + leaderCrit + zstring.tonumber(armor_addition.Crit))/100))
			*(1+parameter_a*(basisAnti/100+(zstring.tonumber(_ED.user_attributes_addition[ship_type].Anti) + leaderAnti + zstring.tonumber(armor_addition.Anti))/100))
			*(1+parameter_b*(zstring.tonumber(_ED.user_attributes_addition[ship_type].penetrate)))
			*(1+parameter_b*(zstring.tonumber(_ED.user_attributes_addition[ship_type].shelter)))
			*(1+parameter_a*(add_factor_percent + less_factor_percent)/100)
			*math.max(zstring.tonumber(_ED.user_info.booming)/zstring.tonumber(_ED.user_info.forage), 0.3)
		if leadersShip ~= nil then
			local leaderCombat = (1+parameter_c*(zstring.tonumber(leadersShip.pierce_through))/100)
				*(1+parameter_c*(zstring.tonumber(leadersShip.protect))/100)
				*(1+parameter_d*(zstring.tonumber(leadersShip.talents[1].is_activited)
					+zstring.tonumber(leadersShip.talents[2].is_activited)
					+zstring.tonumber(leadersShip.talents[3].is_activited)
					+zstring.tonumber(leadersShip.talents[4].is_activited)))
				ship_fight = ship_fight * leaderCombat
		end
		return ship_fight
	else
		local fight_numbers = zstring.tonumber(ship.ship_courage)*0.5
							 +zstring.tonumber(ship.ship_health)*0.1
							 +zstring.tonumber(ship.ship_quick)*0.75
							 +zstring.tonumber(ship.ship_intellect)*0.75
							 +zstring.tonumber(ship.hit)*1.5
							 +zstring.tonumber(ship.dodge)*1.5
							 +zstring.tonumber(ship.crit)*1.5
							 +zstring.tonumber(ship.toughness)*1.5
							 +zstring.tonumber(ship.block)*1.5
							 +zstring.tonumber(ship.wreck)*1.5
							 +zstring.tonumber(ship.add_damage)*0.4
							 +zstring.tonumber(ship.lessen_damage)*0.4					 
		return math.floor(fight_numbers * 7.5)
	end
end

function getLeaderFighting( leadersShip )
	--参数a
	local parameter_a = dms.float(dms["fight_config"], 29, fight_config.attribute)
	--参数b
	local parameter_b = dms.float(dms["fight_config"], 30, fight_config.attribute)
	--参数c
	local parameter_c = dms.float(dms["fight_config"], 31, fight_config.attribute)
	--参数d
	local parameter_d = dms.float(dms["fight_config"], 32, fight_config.attribute)
	--参数e
	local parameter_e = dms.float(dms["fight_config"], 33, fight_config.attribute)
	
	local ship_fight = (1+parameter_a*(zstring.tonumber(leadersShip.hit)/100))
		*(1+parameter_a*(zstring.tonumber(leadersShip.dodge)/100))
		*(1+parameter_a*(zstring.tonumber(leadersShip.crit)/100))
		*(1+parameter_a*(zstring.tonumber(leadersShip.toughness)/100))
		*(1+parameter_c*(zstring.tonumber(leadersShip.pierce_through)/100))
		*(1+parameter_c*(zstring.tonumber(leadersShip.protect)/100))
		*(1+parameter_d*(zstring.tonumber(leadersShip.talents[1].is_activited)+zstring.tonumber(leadersShip.talents[2].is_activited)+zstring.tonumber(leadersShip.talents[3].is_activited)+zstring.tonumber(leadersShip.talents[4].is_activited)))
	return ship_fight
end

function showFightUpOrDown()
	if zstring.tonumber(_ED.user_info.fighter_capacity) ~= zstring.tonumber(_ED.last_fight_number) then
		if zstring.tonumber(_ED.user_info.fighter_capacity) < zstring.tonumber(_ED.last_fight_number) then
			local needChange = false
			if _ED.user_info.last_soldier == nil or zstring.tonumber(_ED.user_info.last_soldier) >= zstring.tonumber(_ED.user_info.soldier) then
				needChange = state_machine.excute("combat_effectiveness_up_window_open",0,0)
			else
				needChange = true
			end
			if needChange == true then
				_ED.last_fight_number = _ED.user_info.fighter_capacity
			end
		else
			local needChange = state_machine.excute("combat_effectiveness_up_window_open",0,0)
			if needChange == true then
				_ED.last_fight_number = _ED.user_info.fighter_capacity
			end
		end
	end
end

function getUserFight()
	local fight_numbers = 0
	for i,v in pairs(_ED.formetion) do
		if i == 1 or zstring.tonumber(v) == 0 then
		else
			fight_numbers = fight_numbers + zstring.tonumber(_ED.user_ship[""..v].hero_fight)
		end
	end
	_ED.user_info.fight_capacity = math.floor(fight_numbers)

	if _ED.user_info.fight_capacity ~= zstring.tonumber(_ED.last_fight_number) then
		if fwin:find("MainWindowClass") ~= nil then
			local isUp = false
			if tonumber(_ED.user_info.fight_capacity) - tonumber(_ED.last_fight_number) > 0 then
				isUp = true
			end
			isUp = true
			state_machine.excute("fighting_up_window_open",0,isUp)
			state_machine.excute("player_info_update_draw",0,"")
		end
	end
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		if tonumber(_ED.user_info.fight_capacity) ~= 0 then
			_ED.last_fight_number = _ED.user_info.fight_capacity
		end
	else
		_ED.last_fight_number = _ED.user_info.fight_capacity
	end

	_ED.baseFightingCount = calcTotalFormationFight()
end

function getEquipmentFightByMouldId(equipment_mould_id)
	local fight_numbers = 0
	local temp = dms.string(dms["equipment_mould"],equipment_mould_id,equipment_mould.initial_value)
	temp = zstring.split(temp,",")
	local add_type = tonumber(temp[1])
	local add_numbers = tonumber(temp[2])
	fight_numbers = add_numbers * fight_pro_number[""..add_type]

	local additive_attribute = dms.string(dms["equipment_mould"],equipment_mould_id,equipment_mould.additive_attribute)

	if add_attribute ~= "-1" then
		additive_attribute = zstring.split(additive_attribute,",")
		local add_pro_type = tonumber(additive_attribute[1])
		local add_pro_number = tonumber(additive_attribute[2])
		if add_pro_type >= 0 then
			fight_numbers = add_pro_number * fight_pro_number[""..add_pro_type] + fight_numbers
		end
	end
	return math.floor(fight_numbers * 7.5)
end

function getEquipmentFight(equipment,user_type)
	local fight_numbers = 0
	local temp = equipment.user_equiment_ability
	temp = zstring.split(temp,",")
	local add_type = tonumber(temp[1])
	local add_numbers = tonumber(temp[2])
	fight_numbers = add_numbers * fight_pro_number[""..add_type]
	
	local equipment_mould_id = equipment.user_equiment_template
	local additive_attribute = dms.string(dms["equipment_mould"],equipment_mould_id,equipment_mould.additive_attribute)

	if add_attribute ~= "-1" then
		additive_attribute = zstring.split(additive_attribute,",")
		local add_pro_type = tonumber(additive_attribute[1])
		local add_pro_number = tonumber(additive_attribute[2])
		if add_pro_type >= 0 then
			fight_numbers = add_pro_number * fight_pro_number[""..add_pro_type] + fight_numbers
		end
	end
	-- print("=========",user_type)
	if user_type == 0 then --自己
		fight_numbers = fight_numbers + getGemsFight(equipment)
	elseif user_type == 1 then
		fight_numbers = fight_numbers + getOtherGemsFight(equipment)
	end
	return math.floor(fight_numbers * 7.5)
end


function getOtherGemsFight(equipment)
	local fight_numbers = 0
	-- debug.print_r(equipment)
	-- debug.print_r(_ED.other_user_gems)
	for i,v in pairs(equipment.jewelrys) do
		if tonumber(v) > 0 then
			local user_gem = _ED.other_user_gems[""..v]
			if user_gem == nil then
				return 0 
			end
			local user_gem_mould_id = user_gem.mould_id
			local add_str = dms.string(dms["gems_mould"],user_gem_mould_id,gems_mould.add_attribute)
			add_str = zstring.split(add_str,",")
			local add_type = tonumber(add_str[1])
			local add_numbers = tonumber(add_str[2])
			fight_numbers = add_numbers * fight_pro_number[""..add_type] + fight_numbers
		end
	end
	return math.floor(fight_numbers)
end

function getGemsFight(equipment)
	local fight_numbers = 0
	for i,v in pairs(equipment.jewelrys) do
		if tonumber(v) > 0 then
			local user_gem = _ED.user_gems[""..v]
			if user_gem == nil then
				return 0 
			end
			local user_gem_mould_id = user_gem.mould_id
			local add_str = dms.string(dms["gems_mould"],user_gem_mould_id,gems_mould.add_attribute)
			add_str = zstring.split(add_str,",")
			local add_type = tonumber(add_str[1])
			local add_numbers = tonumber(add_str[2])
			fight_numbers = add_numbers * fight_pro_number[""..add_type] + fight_numbers

		end
	end
	return math.floor(fight_numbers)
end

----红警