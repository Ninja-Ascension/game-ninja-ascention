battle_logic = battle_logic or {
	formula_enum = {
		crit = 0
	},
	skill_influence_over = {

	}
}

--[[
accepter = {
	-- 攻击者
	attacker = obj

	-- 承受者
	defender = obj

	-- 技能效用的数据
	skill = nil
	
	-- 是否发生闪避
	miss = true/false,

	-- 是否发生暴击
	crit = true/false,

	-- 是否发生格档
	parry = true/false

	-- 增益：0：攻击增益，1：治疗增益
	gain = 0/1

	-- 造成的伤害输出
	damage = { value = int},
	
	-- 治疗的增益输出
	cure = { value = int},

	-- BUFF
	buffs = {
		buff = {
			type = 0/1...,	-- BUFF类型
			round = 0/1...,	-- 持续回合数
			value = 0/1...,	-- 相关数值
		}
		...
	}

	-- 附加作用效果
	accepters = {
		accepter = {}
	}
}]]--
battle_logic.attack = function(attacker, defender, skill, accepter, attackType, battleType)
    accepter = accepter or {accepters = {}}
  	accepter.accepters = accepter.accepters or {}

  --   -- local defenders = nil
  --   -- if type(defender) == "table" then
  --   -- 	defenders = defender
  --   -- else
  --   -- 	defenders = {defender}
  --  	-- end

  --  	-- for i, v in pairs(defenders) do
		-- if skill.skill_influence_type == 0 then
		-- 	-- 伤害类型技能

		-- 	--计算闪避
		-- 	battle_logic.hit(attacker, defender, skill, accepter, attackType, battleType)
		-- elseif skill.skill_influence_type == 1 then
		-- 	-- 治疗类型技能
		-- else
		-- 	-- BUFF类型技能
		-- end

		-- if true ~= accepter.miss 
		-- 	and true ~= accepter.parry
		-- 	then
  --   		-- battle_logic.execute(attacker, defender, skill, accepter)
  --   		local f = battle_logic["" .. skill.skill_influence_type]
  --   		assert(f ~= nil, "skill_influence_type can't no-nil")
  --   		if nil ~= f then
  --   			f(attacker, defender, skill, accepter, attackType, battleType)
  --   		end
  --   	end
  --  	-- end
  	battle_logic.execute(attacker, defender, skill, accepter, attackType, battleType)
	-- for i, v in pairs(skill.other) do
	-- 	local taccepter = {}
	-- 	battle_logic.execute(attacker, defender, v, taccepter, attackType, battleType)
	-- 	table.insert(accepter.accepters, taccepter)
	-- end
    return accepter
end

-- 处理攻击运算逻辑
battle_logic.execute = function(attacker, defender, skill, accepter, attackType, battleType)
	accepter.attacker = attacker
	accepter.defender = defender
	accepter.skill = skill
	accepter.attackType = attackType
	accepter.battleType = battleType
    if skill.skill_influence_type == 0 then
		-- 伤害类型技能

		--计算闪避
		battle_logic.hit(attacker, defender, skill, accepter, attackType, battleType)
	-- elseif skill.skill_influence_type == 1 then
	-- 	-- 治疗类型技能
	end
		-- BUFF类型技能
		local rate = math.random(1, 100)
		if rate > skill.addition_effect_probability then
			accepter.invalid = true
			return
		end
	-- end

	if true ~= accepter.miss 
		and true ~= accepter.parry
		then
		-- battle_logic.execute(attacker, defender, skill, accepter)
		local flag = true
		if _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
			if defender._role._camp == 1 and defender._role._hp_rt < 0.6 then
				local buffs = zstring.split(dms.string(dms["soul_copy_config"], 8, soul_copy_config.param), ",")
				local result = true
				for k,v in pairs(buffs) do
					if tonumber(v) == skill.skill_influence_type then
						result = true
						break
					else
						result = false
					end
				end
				if result == false then
					flag = false
				end
			end
		end
		if flag == true then
			local f = battle_logic["" .. skill.skill_influence_type]
			assert(f ~= nil, "skill_influence_type can't no-nil")
			if nil ~= f then
				if tonumber(skill.skill_influence_type) ~= 0 then
					for i, v in pairs(defender._role._buffs) do
						if v._accepter ~= nil 
							and tonumber(v._accepter.skill.skill_influence_type) == tonumber(skill.skill_influence_type) 
							and tonumber(v._accepter.skill.trigger_timing) ~= tonumber(battle_enum._skill_influence_trigger._fight_start) 
							then
							v.need_tigger_buff = nil
            				state_machine.excute("battle_buff_over", 0, v)
							table.remove(defender._role._buffs, i, 1)
						end
					end
				end
				f(attacker, defender, skill, accepter, attackType, battleType)
			end

			if skill.influences ~= nil then
				for i, v in pairs(skill.influences) do
					local taccepter = {}
					battle_logic.execute(attacker, defender, v, taccepter, attackType, battleType)
					accepter.accepters = accepter.accepters or {}
					table.insert(accepter.accepters, taccepter)
				end
			end
		end
	end
	
 --    if skill.trigger_timing == battle_enum._skill_influence_trigger._attack_addition then
	-- 	-- 2：攻击附带
	-- 	if skill.skill_influence_type == 0 then
	-- 		attacker._role:executeSkills(battle_enum._skill_influence_trigger._attack_addition, accepter.skill.id)
	-- 	end
	-- end
end

-- 公式设计
battle_logic.formula = function(attacker, defender, skill, accepter, formulaType, attackType, battleType)
	
end

-- 计算是否发生暴击
-- 暴击相关计算公式
-- 暴击概率=暴击值/（守方等级*暴击参数A+暴击参数B）
-- 韧性概率=韧性值/（攻方等级*韧性参数A+韧性参数B）
-- 实际暴击率=暴击概率-韧性概率
-- If Rnd（0~1）<实际暴击率 
-- 则判定为暴击
battle_logic.crit = function(attacker, defender, skill, accepter, attackType, battleType)
	local isCrit = false

	local attackerLevel = attacker.level		--攻击者等级
	local defenderLevel = defender.level		--防守者等级

	local baoji_A = dms.string(dms["fight_config"], battle_enum._fight_config_num.baoji_A, fight_config.attribute)
	local baoji_B = dms.string(dms["fight_config"], battle_enum._fight_config_num.baoji_B, fight_config.attribute)

	local renxing_A = dms.string(dms["fight_config"], battle_enum._fight_config_num.renxing_A, fight_config.attribute)
	local renxing_B = dms.string(dms["fight_config"], battle_enum._fight_config_num.renxing_B, fight_config.attribute)

	-- 总暴击值
	local totalCritical = battle_logic.critical(attacker) -- attacker.critical * math.max(0, (1 + attacker.criticalAdditionalPercent - attacker.criticalLessenPercent))
	-- 暴击概率
	local criticalOdds = totalCritical / (defenderLevel  * baoji_A + baoji_B)

	-- 总韧性值
	local totalCriticalResist = battle_logic.criticalResist(defender) -- defender.criticalResist * math.max(0, (1 + defender.criticalResistAdditionalPercent - defender.criticalResistLessenPercent))
	-- 韧性概率
	local criticalResistOdds = totalCriticalResist / (attackerLevel * renxing_A + renxing_B)

	local resultCriticalOdds = criticalOdds - criticalResistOdds
	-- print("暴击相关计算公式：", attacker.userInfo, defender.userInfo, attacker.shipMould, defender.shipMould, attackerLevel, defenderLevel, criticalOdds, criticalResistOdds, resultCriticalOdds)
	local randomValue = math.random()
	if resultCriticalOdds > 0 and randomValue < resultCriticalOdds then
		isCrit = true
		-- print("发生了暴击：", resultCriticalOdds, randomValue)
	end
	accepter.crit = isCrit
	return isCrit
end

-- 计算是否发生命中
-- 命中概率计算公式
-- 命中概率=命中值/（守方等级*命中参数A+命中参数B）
-- 闪避概率=闪避值/（攻方等级*闪避参数A+闪避参数B）
-- 实际命中率=1+命中概率-闪避概率
-- If Rnd（0~1）<实际命中率
-- 则判定为命中，反之判定为闪避
battle_logic.hit = function(attacker, defender, skill, accepter, attackType, battleType)
	local isHit = false

	if attacker._role._must_hit == true then
		isHit = true
		accepter.miss = false
	else
		local attackerLevel = attacker.level		--攻击者等级
		local defenderLevel = defender.level		--防守者等级

		local mingzhong_A = dms.string(dms["fight_config"], battle_enum._fight_config_num.mingzhong_A, fight_config.attribute)
		local mingzhong_B = dms.string(dms["fight_config"], battle_enum._fight_config_num.mingzhong_B, fight_config.attribute)

		local shanbi_A = dms.string(dms["fight_config"], battle_enum._fight_config_num.shanbi_A, fight_config.attribute)
		local shanbi_B = dms.string(dms["fight_config"], battle_enum._fight_config_num.shanbi_B, fight_config.attribute)

		--攻击方总命中值
		local attackerHit = battle_logic.accuracy(attacker) -- attacker.accuracy * math.max(0, (1 + attacker.accuracyAdditionalPercent - attacker.accuracyLessenPercent))
		--命中概率
		local hitPercent = attackerHit / (defenderLevel * mingzhong_A + mingzhong_B)

		--防守方总闪避值
		local defenderMiss = battle_logic.evasion(defender) -- defender.evasion * math.max(0, (1 + defender.evasionAdditionalPercent - defender.evasionLessenPercent))
		--闪避概率
		local missPercent = defenderMiss / (attackerLevel * shanbi_A + shanbi_B)

		--实际命中率
		local hitPercentFinal = 1 + hitPercent - missPercent
		if math.random() < hitPercentFinal then
			isHit = true
			accepter.miss = false
		else
			isHit = false
			accepter.miss = true
		end
		-- print("命中概率计算公式：", isHit, random, attackerHit, defenderMiss, attacker._role._shipName, attacker._role._camp, defender._role._shipName, defender._role._camp, hitPercent, missPercent, hitPercentFinal)
	end
	-- accepter.miss = (isHit == true and false or true)
	return isHit
end

-- 计算是否发生格档
-- 格挡概率计算公式
-- 格挡概率=格挡值/（攻方等级*格挡参数A+格挡参数B）
-- 破击概率=破击值/（守方等级*破击参数A+破击参数B）
-- 实际格挡率=格挡概率-破击概率
-- If Rnd（0~1）< 实际格挡率
-- 则判定为格挡
battle_logic.parry = function(attacker, defender, skill, accepter, attackType, battleType)
	local isParry = false

	local attackerLevel = attacker.level		--攻击者等级
	local defenderLevel = defender.level		--防守者等级

	local gedang_A = dms.string(dms["fight_config"], battle_enum._fight_config_num.gedang_A, fight_config.attribute)
	local gedang_B = dms.string(dms["fight_config"], battle_enum._fight_config_num.gedang_B, fight_config.attribute)

	local poji_A = dms.string(dms["fight_config"], battle_enum._fight_config_num.poji_A, fight_config.attribute)
	local poji_B = dms.string(dms["fight_config"], battle_enum._fight_config_num.poji_B, fight_config.attribute)

	-- 总格挡值
	local totalRetain = battle_logic.retain(defender) -- defender.retain * math.max(0, (1 + defender.retainAdditionalPercent - defender.retainLessenPercent))
	local retainOdds = totalRetain / (attackerLevel  * gedang_A + gedang_B)

	-- 总破击值
	local totalRetainBreak = battle_logic.retainBreak(attacker) -- attacker.retainBreak * math.max(0, (1 + attacker.retainBreakAdditionalPercent - attacker.retainBreakLessenPercent))
	local retainBreakOdds = totalRetainBreak / (defenderLevel * poji_A + poji_B)

	local resultRetainOdds = retainOdds - retainBreakOdds
	-- print("格挡概率计算公式：", attacker.userInfo, defender.userInfo, attacker.shipMould, defender.shipMould, attackerLevel, defenderLevel, retainOdds, retainBreakOdds, resultRetainOdds)
	local randomValue = math.random()
	if randomValue < resultRetainOdds then
		isParry = true
		-- print("发生了格挡：", resultRetainOdds, randomValue)
	end

	accepter.parry = isParry
	return isParry
end

-- 格挡效果值
-- 格挡效果值=0.5
battle_logic.parryValue = function(attacker, defender, skill, accepter, attackType, battleType)
	return dms.string(dms["fight_config"], battle_enum._fight_config_num.gedangxiaoguo, fight_config.attribute)
end

-- 暴击倍率计算公式
-- 暴击倍率=必杀-强韧值+1.35 
battle_logic.critRate = function(attacker, defender, skill, accepter, attackType, battleType)
	local result = attacker.deadlyStrikePersent - defender.criticalResistSupoerAdditionalPercent + dms.string(dms["fight_config"], battle_enum._fight_config_num.baojibeilv, fight_config.attribute)
	return result
end

-- 最终的攻击值
battle_logic.attackValue = function(targeter, skill)
	-- 每掉若干血增加若干攻击
    -- fight_add_att_value=已掉血量/ skill_ratio
    local addAttack = 0
    if targeter._role.addAttackOpen == true and targeter.addAttackPresent ~= 0 then
    	addAttack = math.max(0, targeter._role._max_hp - targeter._role._hp) / targeter.addAttackPresent
    end
	return targeter.attack * math.max(0, (1 + targeter.courageAdditionalPercent - targeter.courageLessenPercent)) + addAttack
end

-- 最终物理防御
battle_logic.physicalDefence = function(targeter)
	return targeter.physicalDefence * math.max(0, (1 + targeter.intellectAdditionalPercent - targeter.intellectLessenPercent))
end

-- 最终法术防御
battle_logic.skillDefence = function(targeter)
	return targeter.skillDefence * math.max(0, (1 + targeter.nimableAdditionalPercent - targeter.nimableLessenPercent))
end

-- 最终兵力
battle_logic.healthPoint = function(targeter)
	return targeter.healthPoint * math.max(0, (1 + targeter.powerAdditionalPercent - targeter.powerLessenPercent))
end

-- 最终暴击值
battle_logic.critical = function(targeter)
	return targeter.critical * math.max(0, (1 + targeter.criticalAdditionalPercent - targeter.criticalLessenPercent))
end

-- 最终韧性值
battle_logic.criticalResist = function(targeter)
	return targeter.criticalResist * math.max(0, (1 + targeter.criticalResistAdditionalPercent - targeter.criticalResistLessenPercent))
end

-- 最终命中值
battle_logic.accuracy = function(targeter)
	return targeter.accuracy * math.max(0, (1 + targeter.accuracyAdditionalPercent - targeter.accuracyLessenPercent))
end

-- 最终闪避值
battle_logic.evasion = function(targeter)
	return targeter.evasion * math.max(0, (1 + targeter.evasionAdditionalPercent - targeter.evasionLessenPercent))
end

-- 最终格挡值
battle_logic.retain = function(targeter)
	return targeter.retain * math.max(0, (1 + targeter.retainAdditionalPercent - targeter.retainLessenPercent))
end

-- 最终破击值
battle_logic.retainBreak = function(targeter)
	return targeter.retainBreak * math.max(0, (1 + targeter.retainBreakAdditionalPercent - targeter.retainBreakLessenPercent))
end

-- 最终攻速值
battle_logic.attackSpeed = function(targeter)
	return targeter.attackSpeed * math.max(0, (1 + targeter.attackSpeedPercent - targeter.attackSpeedLessenercent))
end

-- 最终疗效百分比
battle_logic.byCurePercent = function(targeter)
	return targeter.byCurePercent + targeter.byCureAdditionalPercent - targeter.byCureLessenPercent
end

-- 最终造成伤害百分比
battle_logic.damagePercent = function(targeter, byAttacker)
	local result = 0
	if byAttacker ~= nil and byAttacker._role ~= nil then
		if byAttacker._role._hp_rt <= 0.75 then
			if targeter.addDamagePercent75 == nil then
				targeter.addDamagePercent75 = 0
			end
			result = targeter.addDamagePercent75
		end
		if result == 0 then
			if byAttacker._role._hp_rt <= 0.5 then
				if targeter.addDamagePercent50 == nil then
					targeter.addDamagePercent50 = 0
				end
				result = targeter.addDamagePercent50
			end
		end
	end
	return result + targeter.addDamagePercent - targeter.lessenDamagePercent
end

-- 最终受到伤害百分比
battle_logic.dyDamagePercent = function(targeter)
	local result = 0
	if targeter ~= nil and targeter._role ~= nil then
		if targeter._role._hp_rt <= 0.5 then
			if targeter.lessenDamagePercent50 == nil then
				targeter.lessenDamagePercent50 = 0
			end
			result = targeter.lessenDamagePercent50
		end
	end
	return targeter.dyLessenDamagePercent - targeter.dyAddDamagePercent + result
end

-- 最终聚气百分比
battle_logic.spPercent = function(targeter)
	return targeter.spAdditionalPercent - targeter.spLessenPercent
end

-- 当前攻击方的最大攻击力的角色
battle_logic.maxAttacker = function(attacker, defender, skill, accepter, attackType, battleType)
	local objects = attacker._role._camp == 0 and attacker._role._scene._attackerFormation or attacker._role._scene._defenderFormation
	local object = nil
	for i, v in pairs(objects) do
		v._attack_value = battle_logic.attackValue(v._heroBattleObject, skill)
		if object == nil then
			object = v
		else
			if v._attack_value > object._attack_value then
				object = v
			end
		end
	end
	return object
end

-- 效用计算类型
-- -1：无需计算类型
-- 1：施法者造成基础伤害
-- 2：施法者攻击
-- 3：施法者最大生命
-- 4：施法者受到最终伤害
-- 5：施法者物理防御
-- 6：施法者法术防御
-- 7：受击者攻击
-- 8：受击者物理防御
-- 9：受击者法术防御
-- 10：施法者攻速
-- 11：受击者攻速
-- 12：施法者聚气速度
-- 13：受击者聚气速度
-- 14：我方场上最高攻击者的攻击（需要将该目标的整体属性赋予该角色）
-- 15：施法者造成最终伤害
-- 16：受击者受到最终伤害
-- 17：受击者造成最终伤害
-- 18：我方场上最高攻击者造成的伤害（需要将该目标的整体属性赋予该角色）
battle_logic.compute_mode_value = function(attacker, defender, skill, accepter, attackType, battleType)
	if skill.compute_mode == -1 then
		return 0
	elseif skill.compute_mode == 1 then
		local bordinal = battle_logic.bordinal(attacker, defender, skill, accepter, attackType, battleType)
		local defendValue = 0
		if attackType == 0 then
			defendValue = defender.physicalDefence
		else
			defendValue = defender.skillDefence
		end

		local skillOrdinal = skill.skill_effect_max_value

		-- 最终攻击值
		local totalAttack = battle_logic.attackValue(attacker, skill) 
		local result = totalAttack * bordinal - defendValue
		return result
	elseif skill.compute_mode == 2 then
		return battle_logic.attackValue(attacker, skill)
	elseif skill.compute_mode == 3 then
		return attacker._role._max_hp
	elseif skill.compute_mode == 4 then	
		return attacker._role.damage.value
	elseif skill.compute_mode == 5 then	
		return 0
	elseif skill.compute_mode == 6 then	
		return 0
	elseif skill.compute_mode == 7 then	
		return 0
	elseif skill.compute_mode == 8 then	
		return 0
	elseif skill.compute_mode == 9 then	
		return 0
	elseif skill.compute_mode == 10 then	
		return 0
	elseif skill.compute_mode == 11 then	
		return 0
	elseif skill.compute_mode == 12 then	
		return 0
	elseif skill.compute_mode == 13 then	
		return 0
	elseif skill.compute_mode == 14 then
		local object = battle_logic.maxAttacker(attacker, defender, skill, accepter, attackType, battleType)
		if object == nil then
			return 0
		else
			return object._attack_value
		end
	elseif skill.compute_mode == 15 then	
		return 0
	elseif skill.compute_mode == 16 then	
		return 0
	elseif skill.compute_mode == 17 then	
		return 0
	elseif skill.compute_mode == 18 then
		local object = battle_logic.maxAttacker(attacker, defender, skill, accepter, attackType, battleType)
		return battle_logic["0"](object, defender, skill, accepter, attackType, battleType)
	end
end

-- 战斗类型系数
battle_logic.bordinal = function(attacker, defender, skill, accepter, attackType, battleType)
	if battleType == 0 then
		return dms.string(dms["fight_config"], battle_enum._fight_config_num.pve, fight_config.attribute)
	else
		return dms.string(dms["fight_config"], battle_enum._fight_config_num.pvp, fight_config.attribute)
	end
end

-- 攻击伤害计算
-- ➢	基础伤害
-- 	基础伤害=我方攻击*战斗类型系数-敌方防御 
-- 	PVP时候，战斗类型系数为0.8
-- 	PVE时候，战斗类型系数为1
-- ➢	伤害技能值=（基础伤害*技能系数*（1+我方加伤百分比-敌方减伤百分比）+我方加伤-敌方减伤）*(1+我方伤害百分比增加-敌方伤害百分比减少)
-- 技能系数为技能提供的伤害比例加成，比如一般普攻系数为1，司马懿的太乙阴雷系数为2.8
-- ➢	不破防情况下的特殊处理
-- 	 if  伤害技能伤害<参数A*（我方攻击*战斗类型系数*技能系数+我方加伤）
-- 		基础伤害=参数A*（我方攻击*战斗类型系数*技能系数+我方加伤）*(我方攻击*战斗		类型系数*技能系数+我方加伤)*（1-参数A）/（敌方防御*技能系数+敌方减伤）
-- 参数A暂定为0.1
-- ➢	最终伤害=伤害技能值*if（是否暴击,暴击倍率，if（是否格挡, 1-格挡效果值，1））
battle_logic["0"] = function(attacker, defender, skill, accepter, attackType, battleType)
	accepter.damage = accepter.damage or {}

	local bordinal = battle_logic.bordinal(attacker, defender, skill, accepter, attackType, battleType)

	-- print("战斗类型系数：", bordinal)

	local defendValue = 0
	if attackType == 0 then
		defendValue = battle_logic.physicalDefence(defender)--defender.physicalDefence
		-- print("物理攻击：", defendValue)
	else
		defendValue = battle_logic.skillDefence(defender)--defender.skillDefence
		-- print("法术攻击：", defendValue)
	end
	if attacker._not_defend == true then
		defendValue = 0
	end

	local skillOrdinal = skill.skill_effect_max_value -- dms.atos(skill.skill_influence_element, skill_influence.skill_effect_max_value)

	-- 最终攻击值
	local totalAttack = battle_logic.attackValue(attacker, skill) -- attacker.attack * math.max(0, (1 + attacker.courageAdditionalPercent - attacker.courageLessenPercent)) + defender.addAttack

	-- 最终受到伤害增加百分比
	-- local totalFinalDamagePercent = 

	local result = totalAttack * bordinal - defendValue
	accepter.base_damage = result

	result = (result * skillOrdinal * (1 + attacker.finalDamagePercent - defender.finalLessenDamagePercent) + attacker.finalDamageAddition - defender.finalSubDamageAddition) 
		* (1 + battle_logic.damagePercent(attacker, defender) - battle_logic.dyDamagePercent(defender))

	local bupofang_A = dms.string(dms["fight_config"], battle_enum._fight_config_num.bupofang_A, fight_config.attribute)
	local hdValue = (totalAttack * bordinal * skillOrdinal + attacker.finalDamageAddition)

	if result < (bupofang_A * totalAttack * bordinal) then
		result = bupofang_A * totalAttack * bordinal
		-- result = bupofang_A * hdValue * hdValue * (1 - bupofang_A) / (defendValue * skillOrdinal + defender.finalSubDamageAddition)
		-- print("没有破防")
	end

	local rate = 1

	if battle_logic.crit(attacker, defender, skill, accepter, attackType, battleType) == true then
		rate = battle_logic.critRate(attacker, defender, skill, accepter, attackType, battleType)
	elseif battle_logic.parry(attacker, defender, skill, accepter, attackType, battleType) == true then
		rate = 1 - battle_logic.parryValue(attacker, defender, skill, accepter, attackType, battleType)
	end

	local addAttack = 1
    if _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
		local present = 0
		local addition = nil
    	if defender._role._camp == 1 then
    		addition = zstring.split(dms.string(dms["soul_copy_config"], 7, soul_copy_config.param), ",")
    		present = defender._role._hp/defender._role._max_hp
    	else
    		addition = zstring.split(dms.string(dms["soul_copy_config"], 6, soul_copy_config.param), ",")
			present = attacker._role._hp/attacker._role._max_hp
    	end
		if present >= 0.9 then
			addAttack = addition[1]
		elseif present >= 0.8 then
			addAttack = addition[2]
		elseif present >= 0.7 then
			addAttack = addition[3]
		elseif present >= 0.6 then
			addAttack = addition[4]
		elseif present >= 0.5 then
			addAttack = addition[5]
		elseif present >= 0.4 then
			addAttack = addition[6]
		elseif present >= 0.3 then
			addAttack = addition[7]
		elseif present >= 0.2 then
			addAttack = addition[8]
		elseif present >= 0.1 then
			addAttack = addition[9]
		elseif present >= 0 then
			addAttack = addition[10]
		end
    end

	result = math.ceil(result * rate * (1 - zstring.tonumber(defender._role.byCritLessPercent)))
	accepter.init_damage = result * tonumber(addAttack)
	if defender._role.damage_absorbability ~= nil 
		and defender._role.damage_absorbability.value > 0
		then
		local lessHurt = result - defender._role.damage_absorbability.value
		if lessHurt < 0 then
			defender._role.damage_absorbability.value = defender._role.damage_absorbability.value - result
			result = 0
		else
			defender._role.damage_absorbability.value = 0
			result = lessHurt
		end
		if defender._role.damage_absorbability.value <= 0 then
			defender._role.damage_absorbability.value = 0
			for i, v in pairs(defender._role._buffs) do
	            if v._accepter ~= nil 
	            	and v._accepter.skill ~= nil
	            	and tonumber(v._accepter.skill.skill_influence_type) == 52 
	            	then
					state_machine.excute("battle_role_remove_buff", 0, {role = defender._role, buff = v})
	            end
	        end
		end
		accepter.damage.absorbability = true
	end

    accepter.damage.value = result * tonumber(addAttack)
	if _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then
		if attacker._role._camp == 1 then
			accepter.damage.value = accepter.damage.value + accepter.damage.value * _ED.city_resource_battle_attack_additional
		end
		if defender._role._camp == 1 then
			accepter.damage.value = accepter.damage.value - accepter.damage.value * _ED.city_resource_battle_attack_additional
		end
	end
    -- print("攻击伤害计算：", attacker.userInfo, defender.userInfo, attacker.shipMould, defender.shipMould, result, rate)
end

-- 治疗效果值=攻击*战斗类型系数*技能系数*（1+疗效）
-- 疗效指被治疗效果
battle_logic["1"] = function(attacker, defender, skill, accepter, attackType, battleType)
	accepter.cure = accepter.cure or {}

	-- local bordinal = 0
	-- if battleType == 1 then
	-- 	bordinal = dms.string(dms["fight_config"], battle_enum._fight_config_num.pve, fight_config.attribute)
	-- else
	-- 	bordinal = dms.string(dms["fight_config"], battle_enum._fight_config_num.pvp, fight_config.attribute)
	-- end

	-- local skillOrdinal = skill.skill_effect_max_value

	-- local result = math.ceil(attacker.attack * bordinal * skillOrdinal * (1 + defender.curePercent))
 --    accepter.cure.value = result

 	local value = battle_logic.compute_mode_value(attacker, defender, skill, accepter, attackType, battleType)
	if skill.compute_mode == 2 then
		value = value * battle_logic.bordinal(attacker, defender, skill, accepter, attackType, battleType)
	end
	local result = math.ceil(value * skill.skill_effect_max_value * (1 + battle_logic.byCurePercent(defender)))
	accepter.cure.value = result
	defender._role._hp = defender._role._hp + accepter.cure.value
    defender._role._hp = math.min(defender._role._hp, defender._role._max_hp)
    if defender._role._camp == 0 then
        state_machine.excute("battle_ui_update_role_hp", 0, {role = defender._role, shipId = defender._role._shipMouldId, hp = defender._role._hp, maxHp = defender._role._max_hp})
    end
end

-- 2为加怒        恢复聚气    立即生效类   有   
battle_logic["2"] = function(attacker, defender, skill, accepter, attackType, battleType)
	local skillOrdinal = skill.skill_effect_max_value
	defender._role._sp = encryptInfo(decryptInfo(defender._role._sp) + skillOrdinal)

	local r = defender._role
	state_machine.excute("battle_ui_update_role_sp", 0, {role = r, shipId = r._shipMouldId, sp = decryptInfo(r._sp), maxSp = decryptInfo(r._max_sp), showSpEffect = true})
end
-- 3为减怒        减少聚气    立即生效类   有   
battle_logic["3"] = function(attacker, defender, skill, accepter, attackType, battleType)
	if defender._role._not_lose_sp == true then
		return
	end
	accepter._lose_sp = true
	local skillOrdinal = skill.skill_effect_max_value
	defender._role._sp = encryptInfo(decryptInfo(defender._role._sp) - skillOrdinal)

	local r = defender._role
	state_machine.excute("battle_ui_update_role_sp", 0, {role = r, shipId = r._shipMouldId, sp = decryptInfo(r._sp), maxSp = decryptInfo(r._max_sp), showSpEffect = true})
end
-- 4为封怒（无法积累怒气）        X           
battle_logic["4"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 5为眩晕（无法行动）      眩晕（眩晕附带打断效果）    特殊BUFF类     
battle_logic["5"] = function(attacker, defender, skill, accepter, attackType, battleType)
	if defender._role._not_dizziness == true then
	else
		accepter._dizziness = true
		defender._role._dizziness = true
	end
end
-- 6为腐蚀（中毒）                    
battle_logic["6"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 7为麻痹（无法普通攻击）        X           
battle_logic["7"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 8为封技（无法怒气攻击）        沉默（无法使用技能附带打断效果）    特殊BUFF类     
battle_logic["8"] = function(attacker, defender, skill, accepter, attackType, battleType)
	if defender._role._not_silence == true then
	else
		accepter._silence = true
		defender._role._silence = true
	end
end
-- 9为燃烧                    
battle_logic["9"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 10为集中       X           
battle_logic["10"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 11为格挡       X           
battle_logic["11"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 12为无敌       X           
battle_logic["12"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 13必闪        X           
battle_logic["13"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 14吸血        吸血  立即生效类       
battle_logic["14"] = function(attacker, defender, skill, accepter, attackType, battleType)
	-- 吸血量=final_att_value*skill_ratio*吸血战斗类型参数
	-- 吸血战斗类型参数分为PVP和PVE两个值，在fight_config里面读取
	local bordinal = 1
	if battleType == 0 then
		bordinal = dms.string(dms["fight_config"], battle_enum._fight_config_num.bloodsucking_PVE, fight_config.attribute)
	else
		bordinal = dms.string(dms["fight_config"], battle_enum._fight_config_num.bloodsucking_PVP, fight_config.attribute)
	end
    accepter.bloodsucking = accepter.bloodsucking or {}
    accepter.bloodsucking.value = battle_logic.attackValue(attacker) * skill.skill_effect_max_value * bordinal * (1 + battle_logic.byCurePercent(defender))

    local role = defender._role
    role._hp = role._hp + accepter.bloodsucking.value
    role._hp = math.min(role._hp, role._max_hp)
	if role._camp == 0 
		and role._scene._fight_type ~= battle_enum._fight_type._fight_type_105
		then
        local baseHp = tonumber(aeslua.decrypt("jar-world", role._heroBattleObject.key_ship_health, aeslua.AES128, aeslua.ECBMODE))
        if role._hp > baseHp then
            if fwin:find("ReconnectViewClass") == nil then
                fwin:open(ReconnectView:new():init(red_alert_all_str[184]), fwin._system)
            end
        end
    end
    state_machine.excute("battle_role_hp_update", 0, {roleHP = role._ui_role_hp, shipId = role._shipMouldId, hp = role._hp, maxHp = role._max_hp})
end
-- 15封疗        X           
battle_logic["15"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 16盲目        X           
battle_logic["16"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 17残废        X           
battle_logic["17"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 18备用        X           
battle_logic["18"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 19备用        X           
battle_logic["19"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 20备用        X           
battle_logic["20"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 21增加攻击      攻击提高百分比 BUFF影响属性类       
battle_logic["21"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.courageAdditionalPercent = defender.courageAdditionalPercent + skill.skill_effect_max_value
end
-- 22降低攻击      攻击降低百分比 BUFF影响属性类       
battle_logic["22"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.courageLessenPercent = defender.courageLessenPercent + skill.skill_effect_max_value
end
-- 23增加防御      X           
battle_logic["23"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 24降低防御      X           
battle_logic["24"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 25受到的伤害增加       受到伤害加深百分比   BUFF影响属性类       
battle_logic["25"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.dyAddDamagePercent = defender.dyAddDamagePercent + skill.skill_effect_max_value
end
-- 26受到的伤害降低       降低受到伤害百分比   BUFF影响属性类       
battle_logic["26"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.dyLessenDamagePercent = defender.dyLessenDamagePercent + skill.skill_effect_max_value
end
-- 27增加暴击      暴击增加百分比 BUFF影响属性类       
battle_logic["27"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.criticalAdditionalPercent = defender.criticalAdditionalPercent + skill.skill_effect_max_value
end
-- 28增加抗暴      韧性增加百分比 BUFF影响属性类       
battle_logic["28"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.criticalResistAdditionalPercent = defender.criticalResistAdditionalPercent + skill.skill_effect_max_value
end
-- 29增加命中      命中增加百分比 BUFF影响属性类       
battle_logic["29"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.accuracyAdditionalPercent = defender.accuracyAdditionalPercent + skill.skill_effect_max_value
end
-- 30增加闪避      闪避增加百分比 BUFF影响属性类       
battle_logic["30"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.evasionAdditionalPercent = defender.evasionAdditionalPercent + skill.skill_effect_max_value
end
-- 31持续回血                  
battle_logic["31"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 32清除负面效果        X           
battle_logic["32"] = function(attacker, defender, skill, accepter, attackType, battleType)
	-- 3\5\8\22\25\46\47\48\49\50\54\55
end
-- 33造成伤害增加        造成伤害增加百分比           
battle_logic["33"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.addDamagePercent = defender.addDamagePercent + skill.skill_effect_max_value
end
-- 34全体秒杀      X           
battle_logic["34"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 35固定伤害      X           
battle_logic["35"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 36反弹伤害    立即生效类       
battle_logic["36"] = function(attacker, defender, skill, accepter, attackType, battleType)
    -- 反弹伤害计算公式
    -- 本次反弹伤害值=根据取值类型取值* skill_ratio * bordinal
	-- 如果取值类型为攻击时，需要额外乘以一个战斗类型系数
    accepter.counterstrike = accepter.counterstrike or {}
    -- battle_logic.compute_mode_value(attacker, defender, skill, accepter, attackType, battleType)
    accepter.counterstrike.value = skill.skill_effect_max_value

    attacker.counterstrike = attacker.counterstrike or {}
    attacker.counterstrike.value = skill.skill_effect_max_value
    	-- * battle_logic.bordinal(attacker, defender, skill, accepter, attackType, battleType)
    -- local role = attacker._role
    -- role._hp = role._hp - accepter.counterstrike.value
    -- role._hp = math.min(role._hp, role._max_hp)
    -- state_machine.excute("battle_role_hp_update", 0, {roleHP = role._ui_role_hp, shipId = role._shipMouldId, hp = role._hp, maxHp = role._max_hp})
end
-- 37必定命中    立即生效类       
battle_logic["37"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._must_hit = true
end
-- 38复活  立即生效类       
battle_logic["38"] = function(attacker, defender, skill, accepter, attackType, battleType)
	-- 复活给与初始生命计算公式
	-- 初始生命=skill_ratio*受击者生命最大值
	accepter.resurrection = defender.resurrection or {}
    accepter.resurrection.value = defender._role._max_hp * skill.skill_effect_max_value 
    -- print("复活", defender._role._shipName, accepter.resurrection.value)
end
-- 39物理防御增加百分比   BUFF影响属性类       
battle_logic["39"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.intellectAdditionalPercent = defender.intellectAdditionalPercent + skill.skill_effect_max_value
end
-- 40法术防御增加百分比   BUFF影响属性类       
battle_logic["40"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.nimableAdditionalPercent = defender.nimableAdditionalPercent + skill.skill_effect_max_value
end
-- 41提高攻速    BUFF影响属性类       
battle_logic["41"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.attackSpeedPercent = defender.attackSpeedPercent + skill.skill_effect_max_value
end
-- 42增加回复聚气速度    BUFF影响属性类       
battle_logic["42"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.spAdditionalPercent = defender.spAdditionalPercent + skill.skill_effect_max_value
end
-- 43格挡增加百分比 BUFF影响属性类       
battle_logic["43"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.retainAdditionalPercent = defender.retainAdditionalPercent + skill.skill_effect_max_value
end
-- 44破击增加百分比 BUFF影响属性类       
battle_logic["44"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.retainBreakAdditionalPercent = defender.retainBreakAdditionalPercent + skill.skill_effect_max_value
end
-- 45疗效增加    BUFF影响属性类       
battle_logic["45"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.byCureAdditionalPercent = defender.byCureAdditionalPercent + skill.skill_effect_max_value
end
-- 46物理防御降低百分比   BUFF影响属性类       
battle_logic["46"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.intellectLessenPercent = defender.intellectLessenPercent + skill.skill_effect_max_value
end
-- 47法术防御降低百分比   BUFF影响属性类       
battle_logic["47"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.nimableLessenPercent = defender.nimableLessenPercent + skill.skill_effect_max_value
end
-- 48降低攻速    BUFF影响属性类       
battle_logic["48"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.attackSpeedLessenercent = defender.attackSpeedLessenercent + skill.skill_effect_max_value
end
-- 49降低回复聚气速度    BUFF影响属性类       
battle_logic["49"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.spLessenPercent = defender.spLessenPercent + skill.skill_effect_max_value
end
-- 50疗效减少    BUFF影响属性类       
battle_logic["50"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.byCureLessenPercent = defender.byCureLessenPercent + skill.skill_effect_max_value
end
-- 51每掉若干血增加若干攻击 特殊BUFF类     
battle_logic["51"] = function(attacker, defender, skill, accepter, attackType, battleType)
	attacker._role.addAttackOpen = true
	attacker.addAttackPresent = attacker.addAttackPresent + skill.skill_effect_max_value
end
-- 52伤害吸收护盾  特殊BUFF类     
battle_logic["52"] = function(attacker, defender, skill, accepter, attackType, battleType)
	-- 伤害吸收护盾计算公式
	-- 能够吸收的总伤害值=根据取值类型取值* skill_ratio
	-- 如果取值类型为攻击时，需要额外乘以一个战斗类型系数
    defender._role.damage_absorbability = defender._role.damage_absorbability or {}
    defender._role.damage_absorbability.value = battle_logic.compute_mode_value(attacker, defender, skill, accepter, attackType, battleType) 
    	* skill.skill_effect_max_value 
    	* battle_logic.bordinal(attacker, defender, skill, accepter, attackType, battleType)
end
-- 53不死  特殊BUFF类     
battle_logic["53"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._undead = true
end
-- 54混乱（眩晕附带打断效果）    特殊BUFF类     
battle_logic["54"] = function(attacker, defender, skill, accepter, attackType, battleType)
	if defender._role._not_dizziness == true then
	else
		accepter._dizziness = true
		defender._role._dizziness = true
	end
end
-- 55冻结（眩晕附带打断效果）    特殊BUFF类     
battle_logic["55"] = function(attacker, defender, skill, accepter, attackType, battleType)
	if defender._role._not_dizziness == true then
	else
		accepter._dizziness = true
		defender._role._dizziness = true
	end
end
-- 56激活神将技能
battle_logic["56"] = function(attacker, defender, skill, accepter, attackType, battleType)
	state_machine.excute("battle_scene_update_skill_influence", 0, {attacker._role._camp, skill, skill.skill_effect_max_value})
end
-- 57免疫眩晕、冰冻、混乱
battle_logic["57"] = function(attacker, defender, skill, accepter, attackType, battleType)
	accepter._not_dizziness = true
	defender._role._not_dizziness = true
end
-- 58 免疫沉默
battle_logic["58"] = function(attacker, defender, skill, accepter, attackType, battleType)
	accepter._not_silence = true
	defender._role._not_silence = true
end
-- 59 免疫减少聚气
battle_logic["59"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._not_lose_sp = true
end
-- 60 对生命低于50%的目标造成伤害增加百分比
battle_logic["60"] = function(attacker, defender, skill, accepter, attackType, battleType)
	attacker.addDamagePercent50 = attacker.addDamagePercent50 + skill.skill_effect_max_value
end
-- 61 对生命低于50%的目标受到伤害降低百分比
battle_logic["61"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.lessenDamagePercent50 = defender.lessenDamagePercent50 + skill.skill_effect_max_value
end
-- 62 对生命低于75%的目标受到伤害增加百分比
battle_logic["62"] = function(attacker, defender, skill, accepter, attackType, battleType)
	attacker.addDamagePercent75 = attacker.addDamagePercent75 + skill.skill_effect_max_value
end
-- 63 虚弱
battle_logic["63"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._debilitated = true
	defender._role._debilitated_rate = skill.skill_effect_max_value
end
-- 64 降低减伤
battle_logic["64"] = function(attacker, defender, skill, accepter, attackType, battleType)
	-- defender.base_finalSubDamageAddition = defender.finalSubDamageAddition
	-- defender.finalSubDamageAddition = defender.finalSubDamageAddition * (1 - skill.skill_effect_max_value)
end
-- 65 增加减伤
battle_logic["65"] = function(attacker, defender, skill, accepter, attackType, battleType)
	-- defender.finalSubDamageAddition = defender.finalSubDamageAddition + (1 + skill.skill_effect_max_value)
end
-- 66 无视敌方防御
battle_logic["66"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._not_defend = true
end
-- 67 窃取减伤
battle_logic["67"] = function(attacker, defender, skill, accepter, attackType, battleType)
	-- defender._role._debilitated_rate = skill.skill_effect_max_value
end
-- 68 暴击伤害降低
battle_logic["68"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role.byCritLessPercent = skill.skill_effect_max_value
end
-- ~~~~~~~~~End

-- --------------------------------------------------------------------------------------------------------
-- BUFF效用结束
-- --------------------------------------------------------------------------------------------------------
-- 1为受伤
battle_logic.skill_influence_over["0"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 1为回血
battle_logic.skill_influence_over["1"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 2为加怒        恢复聚气    立即生效类   有   
battle_logic.skill_influence_over["2"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 3为减怒        减少聚气    立即生效类   有   
battle_logic.skill_influence_over["3"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 4为封怒（无法积累怒气）        X           
battle_logic.skill_influence_over["4"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 5为眩晕（无法行动）      眩晕（眩晕附带打断效果）    特殊BUFF类     
battle_logic.skill_influence_over["5"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._dizziness = false
	defender._role._moving = false
end
-- 6为腐蚀（中毒）                    
battle_logic.skill_influence_over["6"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 7为麻痹（无法普通攻击）        X           
battle_logic.skill_influence_over["7"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 8为封技（无法怒气攻击）        沉默（无法使用技能附带打断效果）    特殊BUFF类     
battle_logic.skill_influence_over["8"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._silence = false
end
-- 9为燃烧                    
battle_logic.skill_influence_over["9"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 10为集中       X           
battle_logic.skill_influence_over["10"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 11为格挡       X           
battle_logic.skill_influence_over["11"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 12为无敌       X           
battle_logic.skill_influence_over["12"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 13必闪        X           
battle_logic.skill_influence_over["13"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 14吸血        吸血  立即生效类       
battle_logic.skill_influence_over["14"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 15封疗        X           
battle_logic.skill_influence_over["15"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 16盲目        X           
battle_logic.skill_influence_over["16"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 17残废        X           
battle_logic.skill_influence_over["17"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 18备用        X           
battle_logic.skill_influence_over["18"] = function(attacker, defender, skill, accepter, attackType, battleType)
   
end
-- 19备用        X           
battle_logic.skill_influence_over["19"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 20备用        X           
battle_logic.skill_influence_over["20"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 21增加攻击      攻击提高百分比 BUFF影响属性类       
battle_logic.skill_influence_over["21"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.courageAdditionalPercent = defender.courageAdditionalPercent - skill.skill_effect_max_value
end
-- 22降低攻击      攻击降低百分比 BUFF影响属性类       
battle_logic.skill_influence_over["22"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.courageLessenPercent = defender.courageLessenPercent - skill.skill_effect_max_value
end
-- 23增加防御      X           
battle_logic.skill_influence_over["23"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 24降低防御      X           
battle_logic.skill_influence_over["24"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 25受到的伤害增加       受到伤害加深百分比   BUFF影响属性类       
battle_logic.skill_influence_over["25"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.dyAddDamagePercent = defender.dyAddDamagePercent - skill.skill_effect_max_value
end
-- 26受到的伤害降低       降低受到伤害百分比   BUFF影响属性类       
battle_logic.skill_influence_over["26"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.dyLessenDamagePercent = defender.dyLessenDamagePercent - skill.skill_effect_max_value
end
-- 27增加暴击      暴击增加百分比 BUFF影响属性类       
battle_logic.skill_influence_over["27"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.criticalAdditionalPercent = defender.criticalAdditionalPercent - skill.skill_effect_max_value
end
-- 28增加抗暴      韧性增加百分比 BUFF影响属性类       
battle_logic.skill_influence_over["28"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.criticalResistAdditionalPercent = defender.criticalResistAdditionalPercent - skill.skill_effect_max_value
end
-- 29增加命中      命中增加百分比 BUFF影响属性类       
battle_logic.skill_influence_over["29"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.accuracyAdditionalPercent = defender.accuracyAdditionalPercent - skill.skill_effect_max_value
end
-- 30增加闪避      闪避增加百分比 BUFF影响属性类       
battle_logic.skill_influence_over["30"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.evasionAdditionalPercent = defender.evasionAdditionalPercent - skill.skill_effect_max_value
end
-- 31持续回血                  
battle_logic.skill_influence_over["31"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 32清除负面效果        X           
battle_logic.skill_influence_over["32"] = function(attacker, defender, skill, accepter, attackType, battleType)
	-- 3\5\8\22\25\46\47\48\49\50\54\55
end
-- 33造成伤害增加        造成伤害增加百分比           
battle_logic.skill_influence_over["33"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.addDamagePercent = defender.addDamagePercent - skill.skill_effect_max_value
end
-- 34全体秒杀      X           
battle_logic.skill_influence_over["34"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 35固定伤害      X           
battle_logic.skill_influence_over["35"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 36反弹伤害    立即生效类       
battle_logic.skill_influence_over["36"] = function(attacker, defender, skill, accepter, attackType, battleType)
    accepter.counterstrike = nil
    attacker.counterstrike = nil
end
-- 37必定命中    立即生效类       
battle_logic.skill_influence_over["37"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._must_hit = false
end
-- 38复活  立即生效类       
battle_logic.skill_influence_over["38"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 39物理防御增加百分比   BUFF影响属性类       
battle_logic.skill_influence_over["39"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.intellectAdditionalPercent = defender.intellectAdditionalPercent - skill.skill_effect_max_value
end
-- 40法术防御增加百分比   BUFF影响属性类       
battle_logic.skill_influence_over["40"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.nimableAdditionalPercent = defender.nimableAdditionalPercent - skill.skill_effect_max_value
end
-- 41提高攻速    BUFF影响属性类       
battle_logic.skill_influence_over["41"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.attackSpeedPercent = defender.attackSpeedPercent - skill.skill_effect_max_value
end
-- 42增加回复聚气速度    BUFF影响属性类       
battle_logic.skill_influence_over["42"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.spAdditionalPercent = defender.spAdditionalPercent - skill.skill_effect_max_value
end
-- 43格挡增加百分比 BUFF影响属性类       
battle_logic.skill_influence_over["43"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.retainAdditionalPercent = defender.retainAdditionalPercent - skill.skill_effect_max_value
end
-- 44破击增加百分比 BUFF影响属性类       
battle_logic.skill_influence_over["44"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.retainBreakAdditionalPercent = defender.retainBreakAdditionalPercent - skill.skill_effect_max_value
end
-- 45疗效增加    BUFF影响属性类       
battle_logic.skill_influence_over["45"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.byCureAdditionalPercent = defender.byCureAdditionalPercent - skill.skill_effect_max_value
end
-- 46物理防御降低百分比   BUFF影响属性类       
battle_logic.skill_influence_over["46"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.intellectLessenPercent = defender.intellectLessenPercent - skill.skill_effect_max_value
end
-- 47法术防御降低百分比   BUFF影响属性类       
battle_logic.skill_influence_over["47"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.nimableLessenPercent = defender.nimableLessenPercent - skill.skill_effect_max_value
end
-- 48降低攻速    BUFF影响属性类       
battle_logic.skill_influence_over["48"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.attackSpeedLessenercent = defender.attackSpeedLessenercent - skill.skill_effect_max_value
end
-- 49降低回复聚气速度    BUFF影响属性类       
battle_logic.skill_influence_over["49"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.spLessenPercent = defender.spLessenPercent - skill.skill_effect_max_value
end
-- 50疗效减少    BUFF影响属性类       
battle_logic.skill_influence_over["50"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.byCureLessenPercent = defender.byCureLessenPercent - skill.skill_effect_max_value
end
-- 51每掉若干血增加若干攻击 特殊BUFF类     
battle_logic.skill_influence_over["51"] = function(attacker, defender, skill, accepter, attackType, battleType)
	attacker._role.addAttackOpen = false
	attacker.addAttackPresent = attacker.addAttackPresent - skill.skill_effect_max_value
end
-- 52伤害吸收护盾  特殊BUFF类     
battle_logic.skill_influence_over["52"] = function(attacker, defender, skill, accepter, attackType, battleType)
    defender._role.damage_absorbability = nil
end
-- 53不死  特殊BUFF类     
battle_logic.skill_influence_over["53"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._undead = false
end
-- 54混乱（眩晕附带打断效果）    特殊BUFF类     
battle_logic.skill_influence_over["54"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._dizziness = false
	defender._role._moving = false
end
-- 55冻结（眩晕附带打断效果）    特殊BUFF类     
battle_logic.skill_influence_over["55"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._dizziness = false
	defender._role._moving = false
end
-- 56
battle_logic.skill_influence_over["56"] = function(attacker, defender, skill, accepter, attackType, battleType)
	
end
-- 57免疫眩晕、冰冻、混乱
battle_logic.skill_influence_over["57"] = function(attacker, defender, skill, accepter, attackType, battleType)
	accepter._not_dizziness = false
	defender._role._not_dizziness = false
	defender._role._moving = false
end
-- 58 免疫沉默
battle_logic.skill_influence_over["58"] = function(attacker, defender, skill, accepter, attackType, battleType)
	accepter._not_silence = false
	defender._role._not_silence = false
end
-- 59 免疫减少聚气
battle_logic.skill_influence_over["59"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._not_lose_sp = false
end
-- 60 对生命低于50%的目标造成伤害增加百分比     
battle_logic.skill_influence_over["60"] = function(attacker, defender, skill, accepter, attackType, battleType)
	attacker.addDamagePercent50 = attacker.addDamagePercent50 - skill.skill_effect_max_value
end
-- 61 对生命低于50%的目标受到伤害降低百分比    
battle_logic.skill_influence_over["61"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender.lessenDamagePercent50 = defender.lessenDamagePercent50 - skill.skill_effect_max_value
end
-- 62 对生命低于75%的目标造成伤害增加百分比     
battle_logic.skill_influence_over["62"] = function(attacker, defender, skill, accepter, attackType, battleType)
	attacker.addDamagePercent75 = attacker.addDamagePercent75 - skill.skill_effect_max_value
end
-- 63 虚弱    
battle_logic.skill_influence_over["63"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role._debilitated = false
	defender._role._debilitated_rate = 0
end
-- 64 降低减伤    
battle_logic.skill_influence_over["64"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 65 增加减伤 
battle_logic.skill_influence_over["65"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 66 无视防御    
battle_logic.skill_influence_over["66"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._not_defend = false
end
-- 67 窃取减伤
battle_logic.skill_influence_over["67"] = function(attacker, defender, skill, accepter, attackType, battleType)

end
-- 68 暴击伤害降低
battle_logic.skill_influence_over["68"] = function(attacker, defender, skill, accepter, attackType, battleType)
	defender._role.byCritLessPercent = 0
end
-- ~~~~~~~~~End

-- --------------------------------------------------------------------------------------------------------
