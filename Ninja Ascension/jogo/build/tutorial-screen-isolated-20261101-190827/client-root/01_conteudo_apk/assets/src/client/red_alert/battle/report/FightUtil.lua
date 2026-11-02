
-- 战斗帮助类
-- @author xiaofeng
FightUtil = {}
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_COMMON_DAMAGE =  1
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_SPECIAL_DAMAGE =  2
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_CURE_HP =  3
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_CURE_SP =  4
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_DAMAGE_SP =  5
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_SP_DISUP =  6
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_DIZZY =  7
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_POSION =  8
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_Firing =  9
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_Explode =  10
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_PARALYSIS =  11
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_NO_SP =  12
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_RETAIN =  13
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_LESSEN_DAMAGE =  14
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_EVASION_SURELY =  15
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_DRAINS =  16
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_BEAR_HP =  17
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_BLIND =  18
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_CRIPPLE =  19
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_ATTACK =  21
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_SUB_ATTACK =  22
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_DEFENCE =  23
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_SUB_DEFENCE =  24
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_SELF_DAMAGE =  25
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_SUB_SELF_DAMAGE =  26
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_CRITICAL =  27
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_SUB_CRITICAL =  28
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_HIT =  29
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_DODGE =  30
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_ENDURANCE =  31
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_CLEAR_BUFF =  32
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_DAMAGE =  33
-- 战斗帮助类
-- @author xiaofeng
FightUtil.FORMULA_INFO_ADD_KILL =  34
-- 固伤
-- @author xiaofeng
FightUtil.FORMULA_INFO_FIXED_DAMAGE =  35
-- 即时生效 去上一个作用目标
-- @author xiaofeng
FightUtil.FORMULA_INFO_FORTHWITH = 36

function FightUtil.computeMoveCoordinate(currentAttackerCoordinate, skillReleasePosion, byAttackObjects)
	if (skillReleasePosion == SkillMould.SKILL_RELEASE_POSION_SPOT ) then
		return SkillMould.SKILL_RELEASE_POSION_SPOT
	end
	if (skillReleasePosion == SkillMould.SKILL_RELEASE_POSION_CENTRE_SCREEN) then
		return SkillMould.SKILL_RELEASE_POSION_CENTRE_SCREEN
	end
	if (skillReleasePosion == SkillMould.SKILL_RELEASE_POSION_STRAIGHT) then
		if (1 == currentAttackerCoordinate or 4 == currentAttackerCoordinate) then
			if (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			elseif (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 4
			end
		end
		if (2 == currentAttackerCoordinate or 5 == currentAttackerCoordinate) then
			if (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			elseif (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 4
			end
		end
		if (3 == currentAttackerCoordinate or 6 == currentAttackerCoordinate) then
			if (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			elseif (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 4
			elseif (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 2
			end
		end
	elseif (skillReleasePosion == SkillMould.SKILL_RELEASE_POSION_FRONT_FORWARD) then
		if (1 == currentAttackerCoordinate or 4 == currentAttackerCoordinate) then
			if (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			elseif (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 5
			elseif (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 6
			elseif (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 7
			end
		end
		if (2 == currentAttackerCoordinate or 5 == currentAttackerCoordinate) then
			if (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			elseif (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 6
			elseif (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 5
			elseif (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 7
			end
		end
		if (3 == currentAttackerCoordinate or 6 == currentAttackerCoordinate) then
			if (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			elseif (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 7
			elseif (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 6
			elseif (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 5
			end
		end
	elseif (skillReleasePosion == SkillMould.SKILL_RELEASE_POSION_FRONT_BACKWARD) then
		if (1 == currentAttackerCoordinate or 4 == currentAttackerCoordinate) then
			if (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 5
			elseif (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 6
			elseif (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 7
			elseif (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			end
		end
		if(2 == currentAttackerCoordinate or 5 == currentAttackerCoordinate)then
			if (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 6
			elseif (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 5
			elseif (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 7
			elseif (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			elseif (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			end
		elseif(3 == currentAttackerCoordinate or 6 == currentAttackerCoordinate)then
			if (nil ~= byAttackObjects[6] and true ~= byAttackObjects[6].isDead) then
				return 7
			elseif (nil ~= byAttackObjects[5] and true ~= byAttackObjects[5].isDead) then
				return 6
			elseif (nil ~= byAttackObjects[4] and true ~= byAttackObjects[4].isDead) then
				return 5
			elseif (nil ~= byAttackObjects[3] and true ~= byAttackObjects[3].isDead) then
				return 4
			elseif (nil ~= byAttackObjects[2] and true ~= byAttackObjects[2].isDead) then
				return 3
			elseif (nil ~= byAttackObjects[1] and true ~= byAttackObjects[1].isDead) then
				return 2
			end
		end
	elseif (skillReleasePosion == SkillMould.SKILL_RELEASE_POSION_ASSAULT) then
		return 8
	elseif (skillReleasePosion == SkillMould.SKILL_RELEASE_ZOMURIA_TWO_SIDES) then
		return 9
	end
	return 0
end

function FightUtil.computeEndureDirection(currentAttackerCoordinate, skillInfluence, byAttackObjects)
	----_crint( "computeEndureDirection : " .. currentAttackerCoordinate)
	--_crint ("skillInfluence id: " .. skillInfluence.id  .. ", group : " .. skillInfluence.influenceGroup)
	--_crint ("SkillInfluence.influenceRange: ".. skillInfluence.influenceRange)

	if(skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
		if(skillInfluence.influenceRange == SkillInfluence.EFFECT_RANGE_HORIZONAL)then
			if (nil ~= byAttackObjects[1] or nil ~= byAttackObjects[2] or nil ~= byAttackObjects[3])then
				return {"3", "1,2,3"}
			else
				return {"4", "4,5,6"}
			end
		elseif(skillInfluence.influenceRange == SkillInfluence.EFFECT_RANGE_HORIZONAL_BACK)then
			if (nil ~= byAttackObjects[4] or nil ~= byAttackObjects[5] or nil ~= byAttackObjects[6])then
				return {"4", "4,5,6"}
			else
				return {"3", "1,2,3"}
			end
		elseif(skillInfluence.influenceRange == SkillInfluence.EFFECT_RANGE_VERICAL)then
			if (1 == currentAttackerCoordinate or 4 == currentAttackerCoordinate) then
				if (nil ~= byAttackObjects[1]) then
					return {"0", "1,4"}
				elseif (nil ~= byAttackObjects[2]) then
					return {"1", "2,5"}
				elseif (nil ~= byAttackObjects[3]) then
					return {"2", "3,6"}
				elseif (nil ~= byAttackObjects[4]) then
					return {"0", "1,4"}
				elseif (nil ~= byAttackObjects[5]) then
					return {"1", "2,5"}
				elseif (nil ~= byAttackObjects[6]) then
					return {"2", "3,6"}
				end
			elseif(2 == currentAttackerCoordinate or 5 == currentAttackerCoordinate)then
				if (nil ~= byAttackObjects[2]) then
					return {"1", "2,5"}
				elseif (nil ~= byAttackObjects[1]) then
					return {"0", "1,4"}
				elseif (nil ~= byAttackObjects[3]) then
					return {"2", "3,6"}
				elseif (nil ~= byAttackObjects[5]) then
					return {"1", "2,5"}
				elseif (nil ~= byAttackObjects[4]) then
					return {"0", "1,4"}
				elseif (nil ~= byAttackObjects[6]) then
					return {"2", "3,6"}
				end
			elseif(3 == currentAttackerCoordinate or 6 == currentAttackerCoordinate)then
				if (nil ~= byAttackObjects[3]) then
					return {"2", "3,6"}
				elseif (nil ~= byAttackObjects[2]) then
					return {"1", "2,5"}
				elseif (nil ~= byAttackObjects[1]) then
					return {"0", "1,4"}
				elseif (nil ~= byAttackObjects[6]) then
					return {"2", "3,6"}
				elseif (nil ~= byAttackObjects[5]) then
					return {"1", "2,5"}
				elseif (nil ~= byAttackObjects[4]) then
					return {"0", "1,4"}
				end
			end
		else
			--_crint ("Other case")
		end
	end
	--_crint ("Will return last way")
	return {"-1", "-1"}
end


-- 计算攻击位置
function FightUtil.computeEffectCoordinate(currentAttackerCoordinate, skillInfluence, battleObject, byAttackObjects)
	local influenceRange = skillInfluence.influenceRange
	local headCoordinate = 1
	local backCoordinate = 1
	if (1 == currentAttackerCoordinate or 4 == currentAttackerCoordinate) then
		if (nil ~= byAttackObjects[1]) then
			headCoordinate = 1
		elseif (nil ~= byAttackObjects[2]) then
			headCoordinate = 2
		elseif (nil ~= byAttackObjects[3]) then
			headCoordinate = 3
		elseif (nil ~= byAttackObjects[4]) then
			headCoordinate = 4
		elseif (nil ~= byAttackObjects[5]) then
			headCoordinate = 5
		elseif (nil ~= byAttackObjects[6]) then
			headCoordinate = 6
		end

	elseif(2 == currentAttackerCoordinate or 5 == currentAttackerCoordinate)then
		if (nil ~= byAttackObjects[2]) then
			headCoordinate = 2
		elseif (nil ~= byAttackObjects[1]) then
			headCoordinate = 1
		elseif (nil ~= byAttackObjects[3]) then
			headCoordinate = 3
		elseif (nil ~= byAttackObjects[5]) then
			headCoordinate = 5
		elseif (nil ~= byAttackObjects[4]) then
			headCoordinate = 4
		elseif (nil ~= byAttackObjects[6]) then
			headCoordinate = 6
		end
		
	elseif(3 == currentAttackerCoordinate or 6 == currentAttackerCoordinate)then
		if (nil ~= byAttackObjects[3]) then
			headCoordinate = 3
		elseif (nil ~= byAttackObjects[2]) then
			headCoordinate = 2
		elseif (nil ~= byAttackObjects[1]) then
			headCoordinate = 1
		elseif (nil ~= byAttackObjects[6]) then
			headCoordinate = 6
		elseif (nil ~= byAttackObjects[5]) then
			headCoordinate = 5
		elseif (nil ~= byAttackObjects[4]) then
			headCoordinate = 4
		end
	end
	if (1 == currentAttackerCoordinate or 4 == currentAttackerCoordinate) then
		if (nil ~= byAttackObjects[4]) then
			backCoordinate = 4
		elseif (nil ~= byAttackObjects[5]) then
			backCoordinate = 5
		elseif (nil ~= byAttackObjects[6]) then
			backCoordinate = 6
		elseif (nil ~= byAttackObjects[1]) then
			backCoordinate = 1
		elseif (nil ~= byAttackObjects[2]) then
			backCoordinate = 2
		elseif (nil ~= byAttackObjects[3]) then
			backCoordinate = 3
		end
	elseif(2 == currentAttackerCoordinate or 5 == currentAttackerCoordinate)then
		if (nil ~= byAttackObjects[5]) then
			backCoordinate = 5
		elseif (nil ~= byAttackObjects[4]) then
			backCoordinate = 4
		elseif (nil ~= byAttackObjects[6]) then
			backCoordinate = 6
		elseif (nil ~= byAttackObjects[2]) then
			backCoordinate = 2
		elseif (nil ~= byAttackObjects[1]) then
			backCoordinate = 1
		elseif (nil ~= byAttackObjects[3]) then
			backCoordinate = 3
		end
	elseif(3 == currentAttackerCoordinate or 6 == currentAttackerCoordinate)then
		if (nil ~= byAttackObjects[6]) then
			backCoordinate = 6
		elseif (nil ~= byAttackObjects[5]) then
			backCoordinate = 5
		elseif (nil ~= byAttackObjects[4]) then
			backCoordinate = 4
		elseif (nil ~= byAttackObjects[3]) then
			backCoordinate = 3
		elseif (nil ~= byAttackObjects[2]) then
			backCoordinate = 2
		elseif (nil ~= byAttackObjects[1]) then
			backCoordinate = 1
		end
	end
	local battleObjectList = {}
	--for (BattleObject tmpBattleObject : byAttackObjects) then
	for _, tmpBattleObject in pairs(byAttackObjects) do
		if(nil ~= tmpBattleObject and true ~= tmpBattleObject.isDead)then
			if(true ~= (skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE and skillInfluence.influenceRestrict == 1 and tmpBattleObject.id == battleObject.id))then					
				table.insert(battleObjectList, tmpBattleObject)
			end
		end
	end
	local byEffectCoordinateList = {}
	if (influenceRange == SkillInfluence.EFFECT_RANGE_SINGLE ) then
		table.insert(byEffectCoordinateList, headCoordinate)
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_SELF ) then
		table.insert(byEffectCoordinateList, battleObject.coordinate)
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_SINGLE_BACK ) then
		table.insert(byEffectCoordinateList, backCoordinate)
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_VERICAL ) then
		if(headCoordinate == 1 or headCoordinate == 4)then
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList, 1)
			end
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList, 4)
			end
		elseif(headCoordinate == 2 or headCoordinate == 5)then
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList, 2)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList, 5)
			end
		elseif(headCoordinate == 3 or headCoordinate == 6)then
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList, 3)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList, 6)
			end
		end
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_HORIZONAL) then
		if(headCoordinate <= 3)then
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
		else
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
		end
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_HORIZONAL_BACK ) then
		if(backCoordinate > 3)then
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
		else
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
		end
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_ALL) then
		--for (BattleObject byAttackObject : byAttackObjects) then
		for _, byAttackObject in pairs(byAttackObjects) do
			if(nil ~= byAttackObject and true ~= byAttackObject.isDead)then
				if(skillInfluence.influenceRestrict == 1 and battleObject.battleTag == byAttackObject.battleTag 
					and battleObject.id == byAttackObject.id)then
					--continue
				else
					table.insert(byEffectCoordinateList, byAttackObject.coordinate)
				end
			end
		end
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_HEALTH_MOST) then
		local temp = {}
		for i, byAttackObject in pairs(byAttackObjects) do
			if(nil ~= byAttackObject and true ~= byAttackObject.isDead)then
				table.insert(temp,byAttackObject)
			end
		end
		for i, byAttackObject in pairs(temp) do
			table.sort(temp,function(a,b) return a.healthPoint > b.healthPoint end)
		end
		table.insert(byEffectCoordinateList,temp[1].coordinate)
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_HEALTH_LEAST) then	
		local temp = {}
		for i, byAttackObject in pairs(battleObjectList) do
			if(nil ~= byAttackObject and true ~= byAttackObject.isDead)then
				table.insert(temp,byAttackObject)
			end
		end
		if(#temp > 0) then
			table.sort(temp,function(a,b) return a.healthPoint/a.healthMaxPoint < b.healthPoint/b.healthMaxPoint end)
			table.insert(byEffectCoordinateList,temp[1].coordinate)
		end
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_RANDOM_1) then
		if(#battleObjectList > 0)then				
			battleObjectList = Unit.getRandomWithNoRepeat(battleObjectList, 1)
			if(true ~= battleObjectList[1].isDead)then						
				table.insert(byEffectCoordinateList, battleObjectList[1].coordinate)
			end
		end
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_RANDOM_2) then
		if(#battleObjectList > 0)then				
			battleObjectList = Unit.getRandomWithNoRepeat(battleObjectList, math.min(2, #battleObjectList))
			--for (BattleObject tmp : battleObjectList) then
			for _, tmp in pairs(battleObjectList)  do
				if(true ~= tmp.isDead)then							
					table.insert(byEffectCoordinateList, tmp.coordinate)
				end
			end
		end
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_RANDOM_3) then
		if(#battleObjectList > 0)then				
			battleObjectList = Unit.getRandomWithNoRepeat(battleObjectList, math.min(3, #battleObjectList))
			--for (BattleObject tmp : battleObjectList) then
			for _, tmp in pairs(battleObjectList) do
				if(true ~= tmp.isDead)then						
					table.insert(byEffectCoordinateList, tmp.coordinate)
				end
			end
		end
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_CROSS) then
		if(headCoordinate == 1)then
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
		elseif(headCoordinate == 2)then
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
		elseif(headCoordinate == 3)then
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
		elseif(headCoordinate == 4)then
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
		elseif(headCoordinate == 5)then
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
		elseif(headCoordinate == 6)then
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
		end
		
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_SP_MOST) then
		local temp = {}
		for i, byAttackObject in pairs(byAttackObjects) do
			if(nil ~= byAttackObject and true ~= byAttackObject.isDead)then
				table.insert(temp,byAttackObject)
			end
		end
		table.sort(temp,function(a,b) return a.skillPoint > b.skillPoint end)
		table.insert(byEffectCoordinateList,temp[1].coordinate)
	elseif(influenceRange == SkillInfluence.EFFECT_RANGE_HP_lEST) then
		local temp = {}
		for i, byAttackObject in pairs(byAttackObjects) do
			if(nil ~= byAttackObject and true ~= byAttackObject.isDead)then
				table.insert(temp,byAttackObject)
			end
		end
		table.sort(temp,function(a,b) return a.healthPoint < b.healthPoint end)
		local count = 0
		for i, byAttackObject in pairs(temp) do
			table.insert(byEffectCoordinateList,temp[1].coordinate)
			count = count + 1
			if tonumber(count) == 3 then
				break
			end
		end
	elseif(influenceRange == SkillInfluence.EFFECT_RANGE_HP_LESS_THEN) then
		for i, byAttackObject in pairs(byAttackObjects) do
			if(nil ~= byAttackObject and true ~= byAttackObject.isDead)then
				if(byAttackObject.healthPoint < byAttackObject.healthMaxPoint) and
					((byAttackObject.healthPoint % byAttackObject.healthMaxPoint) < 60)then
					table.insert(byEffectCoordinateList,byAttackObject.coordinate)
				end
			end
		end
	end
	return byEffectCoordinateList
end

function FightUtil.computeCounterCoordinate(attackerCoordinate, skillInfluence, battleObject, byAttackObjects)
	local influenceRange = skillInfluence.influenceRange
	local battleObjectList = {}
	--for (BattleObject tmpBattleObject : byAttackObjects) then
	for _, tmpBattleObject in pairs(byAttackObjects) do
		table.insert(battleObjectList, tmpBattleObject)
	end
	local byEffectCoordinateList = {}
	--switch(influenceRange)then
	if  (influenceRange == SkillInfluence.EFFECT_RANGE_SINGLE ) then
		table.insert(byEffectCoordinateList, attackerCoordinate)
		--break
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_VERICAL ) then
		if(attackerCoordinate == 1 or attackerCoordinate == 4)then
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
		elseif(attackerCoordinate == 2 or attackerCoordinate == 5)then
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
		elseif(attackerCoordinate == 3 or attackerCoordinate == 6)then
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
		end
		--break
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_HORIZONAL ) then
		if(attackerCoordinate <= 3)then
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
		else
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
		end
		--break
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_ALL ) then
		--for (BattleObject byAttackObject : byAttackObjects) then
		for _, byAttackObject in pairs(byAttackObjects) do
			if(nil ~= byAttackObject)then
				if(skillInfluence.influenceRestrict == 1 and battleObject.battleTag == byAttackObject.battleTag and battleObject.id == byAttackObject.id)then
					--continue
				else
					table.insert(byEffectCoordinateList, byAttackObject.coordinate)
				end
			end
		end
		--break
	elseif (influenceRange == SkillInfluence.EFFECT_RANGE_CROSS ) then
		if(attackerCoordinate == 1)then
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
		elseif(attackerCoordinate == 2)then
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
		elseif(attackerCoordinate == 3)then
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
		elseif(attackerCoordinate == 4)then
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
			if(nil ~= byAttackObjects[1])then
				table.insert(byEffectCoordinateList,  1)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
		elseif(attackerCoordinate == 5)then
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
			if(nil ~= byAttackObjects[4])then
				table.insert(byEffectCoordinateList,  4)
			end
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
			if(nil ~= byAttackObjects[2])then
				table.insert(byEffectCoordinateList,  2)
			end
		elseif(attackerCoordinate == 6)then
			if(nil ~= byAttackObjects[6])then
				table.insert(byEffectCoordinateList,  6)
			end
			if(nil ~= byAttackObjects[5])then
				table.insert(byEffectCoordinateList,  5)
			end
			if(nil ~= byAttackObjects[3])then
				table.insert(byEffectCoordinateList,  3)
			end
		end
		--break
	end
	return byEffectCoordinateList
end

function FightUtil.computeRandomSkillEffectValue(skillInfluence)
	local skillEffectValue = math.random(skillInfluence.skillEffectMinValue, skillInfluence.skillEffectMaxValue)
	if(skillInfluence.isRate == 0)then
		skillEffectValue = skillEffectValue / 100
	end
	return skillEffectValue
end

function FightUtil.computeRandomValue()
	local val = (math.random(20) + 90) / 100
	--_crint ("Random value: " .. val)
	return val
end

function FightUtil.computeCommonDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(attackObject.isCripple)then
		effectArray[1] = 0
		attackObject.effectDamage=0
		return
	end
	local finalDamage = 0
	if(true ~= byAttackObject.isNoDamage)then
		local total = 0
		if(skillMould.skillProperty==0)then
			total = math.floor (attackObject.attack+attackObject.addAttack + attackObject.physicalAttackAdd 
			+ attackObject.restrainObject.attackAdditional+ attackObject.restrainObject.physicAttackAdditional)
			--_crint ("Total 1 = " .. total)
			finalDamage =math.floor((total - byAttackObject.physicalDefence- byAttackObject.addPhysicalDefence
					- byAttackObject.restrainObject.physicDefenceAddtional)
						 * FightUtil.computeRandomSkillEffectValue(skillInfluence)
						 * FightUtil.computeRandomValue()
						 + attackObject.finalDamageAddition-byAttackObject.finalSubDamageAddition
						 + attackObject.restrainObject.finalAdditionalDamage - byAttackObject.restrainObject.finalLessenDamage)
		else
			total = math.floor (attackObject.attack+attackObject.addAttack + attackObject.skillAttackAdd
			+ attackObject.restrainObject.attackAdditional + attackObject.skillAttackAdd)
			--_crint ("Total 2 = " .. total)
			finalDamage =math.floor((total - byAttackObject.skillDefence - byAttackObject.addSkillDefence
					- byAttackObject.restrainObject.skillDefenceAddtional)
					 * FightUtil.computeRandomSkillEffectValue(skillInfluence)
					 * FightUtil.computeRandomValue()
					 + attackObject.finalDamageAddition-byAttackObject.finalSubDamageAddition
					 + attackObject.restrainObject.finalAdditionalDamage - byAttackObject.restrainObject.finalLessenDamage)
		end
		finalDamage = math.floor (finalDamage * attackObject.critialMultiple)
	end
	--_crint( "FightUtil " .. finalDamage)
	if (1 > finalDamage) then
		finalDamage = 1
	end
	local finalDamagePercent = attackObject.finalDamagePercent + attackObject.addFinalDamagePercent  + byAttackObject.addBruiseDamagePercent
	+ attackObject.restrainObject.finalAdditionalDamagePercentage
	local finalLessenDamagePercent =  byAttackObject.finalLessenDamagePercent
	+ byAttackObject.restrainObject.finalAdditionalDamagePercentage
	if(byAttackObject.isEvasion)then
		finalDamage = 0
	else
		--for (Iterator<TalentJudgeResult> talentIter = attackObject.talentJudgeResultList.iterator(); talentIter.hasNext();) then
		for _, talentJudgeResult in pairs(attackObject.talentJudgeResultList) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			local immunity = false
			--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
			for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
				if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
					immunity = true
					break
				end
			end
			if(immunity)then
				break
			end
			if (talentJudgeResult.resultType == TalentConstant.JUDGE_RESULT_FINAL_DAMAGE_PERCENT ) then
				finalDamagePercent = finalDamagePercent + talentJudgeResult.percentValue
				--break
			elseif (talentJudgeResult.resultType == TalentConstant.JUDGE_RESULT_FINAL_LESSEN_DAMAGE_PERCENT) then
				finalLessenDamagePercent = finalLessenDamagePercent + talentJudgeResult.percentValue
				--break
			elseif (talentJudgeResult.resultType == TalentConstant.JUDGE_RESULT_DAMAGE_HP_UPPER_LIMIT_PERCENT) then
				finalLessenDamagePercent = finalLessenDamagePercent + talentJudgeResult.percentValue
				--break
			end
		end
		--for (Iterator<TalentJudgeResult> talentIter = attackObject.getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_DAMAGE_PERCENT).iterator(); talentIter.hasNext();) then
		for _, 	talentJudgeResult in pairs(attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_DAMAGE_PERCENT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			local immunity = false
			--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
			for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
				if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
					immunity = true
					break
				end
			end
			if(immunity)then
				break
			end
			finalDamagePercent = finalDamagePercent + talentJudgeResult.percentValue
		end
		--for (Iterator<TalentJudgeResult> talentIter = byAttackObject.getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_LESSEN_DAMAGE_PERCENT).iterator(); talentIter.hasNext();) then
		for _, talentJudgeResult in pairs(byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_LESSEN_DAMAGE_PERCENT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			local immunity = false
			--for (TalentImmunity talentImmunity : attackObject.talentImmunityList) then
			for _, talentImmunity in pairs(attackObject.talentImmunityList) do
				if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
					immunity = true
					break
				end
			end
			if(immunity)then
				break
			end
			finalLessenDamagePercent = finalLessenDamagePercent + talentJudgeResult.percentValue
		end
		if(finalDamagePercent > 0)then
			finalDamage = finalDamage * (1 + finalDamagePercent / 100.0)
		end
		if(finalLessenDamagePercent > 0)then
			finalDamage = finalDamage * (1 - finalLessenDamagePercent / 100.0)
		end
		--for (Iterator<TalentJudgeResult> talentIter = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_DAMAGE_HP_UPPER_LIMIT_PERCENT).iterator(); talentIter.hasNext();) then
		for _, talentJudgeResult in pairs(byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_DAMAGE_HP_UPPER_LIMIT_PERCENT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			local immunity = false
			--for (TalentImmunity talentImmunity : attackObject.talentImmunityList) then
			for _, talentImmunity in pairs(attackObject.talentImmunityList) do
				if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
					immunity = true
					break
				end
			end
			if(immunity)then
				break
			end
			local damagePercent = finalDamage / byAttackObject.healthMaxPoint
			if(damagePercent > talentJudgeResult.percentValue)then
				finalDamage = math.floor (byAttackObject.healthMaxPoint * talentJudgeResult.percentValue)
				break
			end
		end
	end
	
	finalDamage = finalDamage * attackObject.grade_attack
	if(tonumber(finalDamage) < 1)then
		finalDamage = 1
	end
	
	if(attackObject.battleTag == 0)then
		if _ED.user_info.battleCache ~= nil then
			_ED.user_info.battleCache:addTotalDamage(finalDamage)
		end
	end
	-- --_crint ("Final damage is: " .. attackObject.grade_attack)
	byAttackObject:subHealthPoint(finalDamage)
	attackObject.effectDamage = finalDamage
	effectArray[1] = finalDamage
end

function FightUtil.computeReAttackDamage(attackObject, byAttackObject)
	local finalDamage = 0
	local damageFormulaA = math.floor ((attackObject.attack - byAttackObject.physicalDefence) 
			* (1) 
			* FightUtil.computeRandomSkillEffectValue(attackObject.commonBattleSkill[1].skillInfluence) 
			+ attackObject.finalDamageAddition 
			- byAttackObject.finalSubDamageAddition)
	local damageFormulaB = math.floor ((attackObject.attack 
			* FightUtil.computeRandomSkillEffectValue(attackObject.commonBattleSkill[1].skillInfluence) 
			+ attackObject.finalDamageAddition 
			- byAttackObject.finalSubDamageAddition)
			* 0.23)
	--finalDamage = math.floor damageFormulaA >= damageFormulaB ? damageFormulaA : damageFormulaB
	finalDamage = damageFormulaB;
	if (damageFormulaA >= damageFormulaB) then
		finalDamage = damageFormulaA
	end
	if (1 > finalDamage) then
		finalDamage = 1
	end
	local finalDamagePercent = attackObject.finalDamagePercent + attackObject.addFinalDamagePercent
	local finalLessenDamagePercent =  byAttackObject.finalLessenDamagePercent + byAttackObject.addBruiseDamagePercent
	--for (Iterator<TalentJudgeResult> talentIter = attackObject.getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_DAMAGE_PERCENT).iterator(); talentIter.hasNext();) then
	for _, talentJudgeResult in pairs(attackObject.getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_DAMAGE_PERCENT)) do
		--TalentJudgeResult talentJudgeResult = talentIter.next()
		local immunity = false
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
				immunity = true
				break
			end
		end
		if(immunity)then
			break
		end
		finalDamagePercent = finalDamagePercent + talentJudgeResult.percentValue
	end
	--for (Iterator<TalentJudgeResult> talentIter = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_LESSEN_DAMAGE_PERCENT).iterator(); talentIter.hasNext();) then
	for _,  talentJudgeResult in pairs(byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_LESSEN_DAMAGE_PERCENT)) do
		--TalentJudgeResult talentJudgeResult = talentIter.next()
		local immunity = false
		--for (TalentImmunity talentImmunity : attackObject.talentImmunityList) then
		for _, talentImmunity in pairs(attackObject.talentImmunityList) do
			if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
				immunity = true
				break
			end
		end
		if(immunity)then
			break
		end
		finalLessenDamagePercent = finalLessenDamagePercent + talentJudgeResult.percentValue
	end
	if(finalDamagePercent > 0)then
		finalDamage = finalDamage * (1 + finalDamagePercent / 100)
	end
	if(finalLessenDamagePercent > 0)then
		finalDamage = finalDamage * (1 - finalLessenDamagePercent / 100)
	end
	
	finalDamage = finalDamag * attackObject.grade_attack
	-- if(attackObject.battleTag == 0)then
		-- local userInfo = UserDB.getUserInfoWithUserInfoId(attackObject.userInfo + "", false)
		-- if(nil ~= userInfo and nil ~= userInfo.battleCache)then
			-- local templocal = userInfo.battleCache
			-- tempBattleCache.addTotalDamage(finalDamage)
		-- end
	-- end
	finalDamage = finalDamage * attackObject.grade_attack
	if(attackObject.battleTag == 0)then
		if _ED.user_info.battleCache ~= nil then
			_ED.user_info.battleCache:addTotalDamage(finalDamage)
		end
	end
	byAttackObject:subHealthPoint(finalDamage)
	attackObject.effectDamage=finalDamage
	return finalDamage
end

function FightUtil.computeSpecialDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	local finalDamage = 0
	if(attackObject.isCripple)then	
		effectArray[1] = finalDamage
		attackObject.effectDamage=finalDamage
		return
	end
	if(true ~= byAttackObject.isNoDamage)then			
		local total = 0
		if(skillMould.skillProperty==0)then
			total = math.floor (attackObject.attack+ attackObject.addAttack + attackObject.physicalAttackAdd
			+ attackObject.restrainObject.attackAdditional+ attackObject.restrainObject.physicAttackAdditional)
			finalDamage =math.floor((total - byAttackObject.physicalDefence)
						 * FightUtil.computeRandomSkillEffectValue(skillInfluence)
						 * FightUtil.computeRandomValue()
						 + attackObject.finalDamageAddition-byAttackObject.finalSubDamageAddition
						 + attackObject.restrainObject.finalAdditionalDamage - byAttackObject.restrainObject.finalLessenDamage)
		else
			total = math.floor (attackObject.attack+ attackObject.addAttack+attackObject.skillAttackAdd
			+ attackObject.restrainObject.attackAdditional + attackObject.skillAttackAdd)
			finalDamage =math.floor((total - byAttackObject.skillDefence)
					 * FightUtil.computeRandomSkillEffectValue(skillInfluence)
					 * FightUtil.computeRandomValue()
					 + attackObject.finalDamageAddition-byAttackObject.finalSubDamageAddition
					 + attackObject.restrainObject.finalAdditionalDamage - byAttackObject.restrainObject.finalLessenDamage)
		end
		finalDamage = math.floor (finalDamage * attackObject.critialMultiple)
	end
	if (1 > finalDamage) then
		finalDamage = 1
	end
	local finalDamagePercent = attackObject.finalDamagePercent + attackObject.addFinalDamagePercent
	+ attackObject.restrainObject.finalAdditionalDamagePercentage
	local finalLessenDamagePercent =  byAttackObject.finalLessenDamagePercent + byAttackObject.addBruiseDamagePercent
	+ byAttackObject.restrainObject.finalAdditionalDamagePercentage
	if(byAttackObject.isEvasion)then
		finalDamage = 0
	else
		--for (Iterator<TalentJudgeResult> talentIter = attackObject.getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_DAMAGE_PERCENT).iterator(); talentIter.hasNext();) then
		for _, talentJudgeResult in pairs(attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_DAMAGE_PERCENT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			local immunity = false
			--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
			for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
				if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
					immunity = true
					break
				end
			end
			if(immunity)then
				break
			end
			finalDamagePercent = finalDamagePercent + talentJudgeResult.percentValue
		end
		--for (Iterator<TalentJudgeResult> talentIter = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_LESSEN_DAMAGE_PERCENT).iterator(); talentIter.hasNext();) then
		for _, talentJudgeResult in pairs(byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_FINAL_LESSEN_DAMAGE_PERCENT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			local immunity = false
			--for (TalentImmunity talentImmunity : attackObject.talentImmunityList) then
			for _, talentImmunity in pairs(attackObject.talentImmunityList) do
				if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
					immunity = true
					break
				end
			end
			if(immunity)then
				break
			end
			finalLessenDamagePercent = finalLessenDamagePercent + talentJudgeResult.percentValue
		end
		if(finalDamagePercent > 0.0)then
			finalDamage = finalDamage * (1 + finalDamagePercent / 100)
		end
		if(finalLessenDamagePercent > 0.0)then
			finalDamage = finalDamage * (1 - finalLessenDamagePercent / 100)
		end
	end
	-- if(attackObject.battleTag == 0)then
		-- local userInfo = UserDB.getUserInfoWithUserInfoId(attackObject.userInfo + "", false)
		-- if(nil ~= userInfo and nil ~= userInfo.battleCache)then
			-- local templocal = userInfo.battleCache
			-- tempBattleCache.addTotalDamage(finalDamage)
		-- end
	-- end
	finalDamage = finalDamage * attackObject.grade_attack
	if(tonumber(finalDamage) < 1)then
		finalDamage = 1
	end
	if(attackObject.battleTag == 0)then
		if _ED.user_info.battleCache ~= nil then
			_ED.user_info.battleCache:addTotalDamage(finalDamage)
		end
	end
	byAttackObject:subHealthPoint(finalDamage)
	attackObject.effectDamage=finalDamage
	effectArray[1] = finalDamage
end

function FightUtil.computeCureHealthPoint(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	local finalCure = math.floor (attackObject.attack+attackObject.addAttack + attackObject.skillAttackAdd 
				+ attackObject.restrainObject.attackAdditional +attackObject.restrainObject.skillAttackAdditional 
				* (FightUtil.computeRandomSkillEffectValue(skillInfluence) + attackObject.cureAdditional / 100 + byAttackObject.byCurePercent / 100)
				*  FightUtil.computeRandomValue()
				+ attackObject.cureAdd
				+ byAttackObject.byCureAdd + byAttackObject.cureAdd)
	local addHpPoint = byAttackObject.healthMaxPoint - byAttackObject.healthPoint
	if(addHpPoint < 0) then
		addHpPoint = 0
	end
	local healthPoint = math.floor(math.min(addHpPoint, finalCure))
	finalCure = healthPoint
	finalCure = finalCure * attackObject.grade_attack
	if(byAttackObject.isBearHP)then	
		effectArray[1] = 0
	else
		byAttackObject:addHealthPoint(finalCure)
		effectArray[1] = finalCure
	end
end

function FightUtil.computeCureSkillPoint(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		effectArray[1] = math.floor(FightUtil.computeRandomSkillEffectValue(skillInfluence))
		byAttackObject:addSkillPoint( effectArray[1])
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeDamageSkillPoint(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then			
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_DAMAGE_SP)then
				effectArray[2] = 5
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then			
			effectArray[1] = FightUtil.computeRandomSkillEffectValue(skillInfluence)
			local damageSkillPoint =  byAttackObject.skillPoint - effectArray[1]
			byAttackObject.skillPoint= math.max(damageSkillPoint, 0)
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeSkillPointDisup(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_SP_DISUP)then
				effectArray[3] = 5
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
			byAttackObject.isSpDisable=true
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeDizzy(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_DIZZY)then
				effectArray[3] = 1
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
			byAttackObject.isDizzy=true
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computePosion(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_POSION)then
				effectArray[3] = 5
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			local skillEffect = FightUtil.computeRandomSkillEffectValue(skillInfluence)
			local effectValue = 0
			if(skillInfluence.isRate == 0)then 
				effectValue = math.floor (skillEffect * attackObject.attack+attackObject.posionAdd-byAttackObject.byPosionLes
						+attackObject.restrainObject.posionAdditional - byAttackObject.restrainObject.posionLessen)
				if (effectValue < 5) then
					effectValue = 5
				end
				byAttackObject.posionDamage=effectValue
			else
				effectValue = math.floor(skillEffect)
			end
			fightBuff.effectValue = effectValue
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeFiring(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then	
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_FIRING)then
				effectArray[3] = 5
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			local skillEffect = FightUtil.computeRandomSkillEffectValue(skillInfluence)
			local effectValue = 0
			if(skillInfluence.isRate == 0)then 
				effectValue = math.floor (skillEffect * attackObject.attack+attackObject.posionAdd-byAttackObject.byPosionLes
						+attackObject.restrainObject.firingAdditional - byAttackObject.restrainObject.firingLessen)
				if (effectValue < 5) then
					effectValue = 5
				end
				byAttackObject.posionDamage=effectValue
			else
				effectValue = math.floor(skillEffect)
			end
			fightBuff.effectValue = effectValue
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeExplode(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then			
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
		attackObject.isExplode=true
		attackObject.explodeCount=skillInfluence.influenceDuration
	end
end

function FightUtil.computeParalysis(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_PARALYSIS)then
				effectArray[3] = 5
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
			byAttackObject.isParalysis=true
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeNoSkillPoint(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_NO_SP)then
				effectArray[3] = 5
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
			byAttackObject.isDisSp=true
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddRetain(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	local fightBuff = FightBuff:new()
	fightBuff.skillInfluence=skillInfluence
	fightBuff.effectRound=skillInfluence.influenceDuration
	byAttackObject:pushBuffEffect(fightBuff)
	effectArray[2] = skillInfluence.influenceDuration
	byAttackObject.retainAdditional=byAttackObject.retainAdditional + skillInfluence.skillEffectMaxValue
end

function FightUtil.computeLessenDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then			
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
		byAttackObject.isNoDamage=true
	end
end

function FightUtil.computeEvasionSurely(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	local fightBuff = FightBuff:new()
	fightBuff.skillInfluence=skillInfluence
	fightBuff.effectRound=skillInfluence.influenceDuration
	byAttackObject:pushBuffEffect(fightBuff)
	effectArray[2] = skillInfluence.influenceDuration
	byAttackObject.isEvasionSurely=true
end

function FightUtil.computeDrains(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	local drainHP = math.floor (FightUtil.computeRandomSkillEffectValue(skillInfluence) * attackObject.totalEffectDamage
		* (1 + attackObject.cureAdditional / 100 + byAttackObject.byCurePercent / 100))
	if(drainHP + byAttackObject.healthPoint >= byAttackObject.healthMaxPoint)then
		drainHP = math.floor (byAttackObject.healthMaxPoint - byAttackObject.healthPoint)
	end
	if(byAttackObject.isBearHP)then	
		effectArray[1] = 0
	else
		byAttackObject:addHealthPoint(drainHP)
		effectArray[1] = drainHP
	end
end

function FightUtil.computeBearHP(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_BRAR_HP)then
				effectArray[3] = 7
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
			byAttackObject.isBearHP=true
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end


function FightUtil.computeEvasion(skillMould, skillInfluence, attackObject, byAttackObject)
	local isAccuracy = false
	local attackTalentMouldList = attackObject.talentMouldList
	--for (TalentMould talentMould : attackTalentMouldList) then
	for _, talentMould in pairs(attackTalentMouldList) do
		-- if(talentMould.influenceJudgeResult.equals(""..TalentConstant.JUDGE_RESULT_NO_EVASION .. ""))then
		if(talentMould.influenceJudgeResult == ""..TalentConstant.JUDGE_RESULT_NO_EVASION .. "")then
			isAccuracy = true
			break
		end
	end
	if(attackObject.isBlind)then	
		isAccuracy = true
		byAttackObject.isEvasion=true
		return
	else
		byAttackObject.isEvasion=false
	end
	if(true ~= isAccuracy)then
		if(math.random(1, 100) <= (95 + (attackObject.accuracy + attackObject.addAccuracy) - 
			(byAttackObject.evasion+ byAttackObject.addEvasion)
				+ attackObject.restrainObject.acciracuOdds - byAttackObject.restrainObject.evasionOdds))then			
			byAttackObject.isEvasion=false
		else
			byAttackObject.isEvasion=true
		end
	else
		byAttackObject.isEvasion=false
	end
end

function FightUtil.computeCritial(skillMould, skillInfluence, attackObject, byAttackObject)
	local criticalMultiple = 1.5
	--for (Iterator<TalentJudgeResult> talentIter = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_CRITICAL_MULTIPLE_ADDITIONAL_PERCENT).iterator(); talentIter.hasNext();) then
	for _, talentJudgeResult in pairs(attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_CRITICAL_MULTIPLE_ADDITIONAL_PERCENT)) do
		--TalentJudgeResult talentJudgeResult = talentIter.next()
		local immunity = false
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id)then
				immunity = true
				break
			end
		end
		if(immunity)then
			break
		end
		criticalMultiple = criticalMultiple * (1 + talentJudgeResult.percentValue / 100.0)
	end
	local talentJudgeResultList = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_CRITICAL)
	local canCritical = #talentJudgeResultList <= 0
	if((math.random(1, 100) <= (5 + (attackObject.critical + attackObject.addCritialMultiple) - (byAttackObject.criticalResist+byAttackObject.addCriticalResist)
			+ attackObject.restrainObject.criticalOdds - byAttackObject.restrainObject.criticalResistOdds) or attackObject.isExplode) and canCritical)then			
		attackObject.isCritical=true
		attackObject.critialMultiple=criticalMultiple
		if(attackObject.isExplode)then
			attackObject:subExplodeCount(1)
			if(attackObject.explodeCount <= 0)then
				attackObject.isExplode=false
				attackObject.explodeCount=0
			end
		end
	end
end

function FightUtil.computeRetain(skillMould, skillInfluence, attackObject, byAttackObject)
	if(math.random(1, 100) <= (5 + byAttackObject.retain - attackObject.retainBreak + byAttackObject.retainAdditional))then			
		byAttackObject.isRetain=true
	end
end

function FightUtil:computeBlind(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_BLIND)then
				effectArray[3] = 8
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
			byAttackObject.isBlind=true
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeCripple(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		--for (TalentImmunity talentImmunity : byAttackObject.talentImmunityList) then
		for _, talentImmunity in pairs(byAttackObject.talentImmunityList) do
			if(talentImmunity.immunityStatus == TalentConstant.IMMUNITY_STATUS_CRIPPLE)then
				effectArray[3] = 9
				return
			end
		end
		if(true ~= byAttackObject.isEvasion)then				
			local fightBuff = FightBuff:new()
			fightBuff.skillInfluence=skillInfluence
			fightBuff.effectRound=skillInfluence.influenceDuration
			byAttackObject:pushBuffEffect(fightBuff)
			effectArray[2] = skillInfluence.influenceDuration
			byAttackObject.isCripple=true
		else
			effectArray[3] = 1
		end
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddAttack(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local finalAttack = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		effectArray[2] = skillInfluence.influenceDuration
		local effectValue = 0
		if(skillInfluence.isRate == 0)then
			effectValue = attackObject.attack * finalAttack
		else
			effectValue = finalAttack
		end
		fightBuff.effectValue=effectValue
		byAttackObject:pushBuffEffect(fightBuff)
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeSubAttack(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local finalAttack = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		effectArray[2] = skillInfluence.influenceDuration
		local finalValue = 0
		if(skillInfluence.isRate > 0)then
			finalValue = finalAttack
		else
			finalValue = attackObject.attack * finalAttack
		end
		fightBuff.effectValue=finalValue
		byAttackObject:pushBuffEffect(fightBuff)
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddPhysicalDefence(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local finalAttack = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		local addPhyDefence = 0
		local addSkillDefence = 0
		if(skillInfluence.isRate > 0)then
			addPhyDefence = finalAttack
			addSkillDefence = finalAttack
		else
			addPhyDefence = attackObject.physicalDefence*finalAttack
			addSkillDefence = attackObject.skillDefence*finalAttack
		end
		fightBuff.effectValue=addPhyDefence
		fightBuff.effectValue2=addSkillDefence
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeSubPhysicalDefence(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local finalAttack = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		local addPhyDefence = 0
		local addSkillDefence = 0
		if(skillInfluence.isRate > 0)then
			addPhyDefence = finalAttack
			addSkillDefence = finalAttack
		else
			addPhyDefence = attackObject.physicalDefence*finalAttack
			addSkillDefence = attackObject.skillDefence*finalAttack
		end
		fightBuff.effectValue=addPhyDefence
		fightBuff.effectValue2=addSkillDefence
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
	else
		effectArray[3] = 1
	end
end

--受到伤害降低
function FightUtil.computeAddBurise(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence = skillInfluence
		fightBuff.effectRound = skillInfluence.influenceDuration
		local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		if skillInfluence.isRate == 1 then
			byAttackObject.finalSubDamageAddition = byAttackObject.finalSubDamageAddition + effectValue
		else
			byAttackObject.finalLessenDamagePercent = byAttackObject.finalLessenDamagePercent + effectValue*100
		end
		fightBuff.effectValue = effectValue
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeSubBurise(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
		local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		byAttackObject:subBruiseDamagePercent(effectValue)
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddCritical(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		if(effectValue > 0)then
			fightBuff.effectWorth=effectValue
			byAttackObject:pushBuffEffect(fightBuff)
		end
		effectArray[2] = skillInfluence.influenceDuration
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddResistCritical(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		if(effectValue > 0)then
			fightBuff.effectValue=effectValue
		end
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddHit(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		if(effectValue > 0)then
			fightBuff.effectValue=effectValue
			byAttackObject:pushBuffEffect(fightBuff)
		end
		effectValue = skillInfluence.influenceDuration
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddEnvsion(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		fightBuff.fffectValue = effectValue
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddEndurance(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		if(skillInfluence.isRate == 0)then
			effectValue = attackObject.attack * effectValue
		end
		if(effectValue > 0)then
			fightBuff.effectValue = effectValue
			byAttackObject:pushBuffEffect(fightBuff)
		end
		effectArray[2] = skillInfluence.influenceDuration
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeClearBuff(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local list = byAttackObject.buffEffect
		--for (Iterator iterator = list.iterator(); iterator.hasNext();) then
		for i, fightBuff in pairs(byAttackObject.buffEffect) do
			--local fightBuff = (FightBuff) iterator.next()
			if(skillInfluence.formulaInfo == fightBuff.skillInfluence.formulaInfo)then
				-- iterator.remove()
				table.remove(byAttackObject.buffEffect, i, 1)
			end
		end
		effectArray[2] = skillInfluence.influenceDuration
		effectArray[4] = skillInfluence.formulaInfo
	else
		effectArray[3] = 1
	end
end

function FightUtil.computeAddDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	if(math.random(1, 100) <= skillInfluence.additionEffectProbability)then
		local fightBuff = FightBuff:new()
		fightBuff.skillInfluence=skillInfluence
		fightBuff.effectRound=skillInfluence.influenceDuration
		local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		fightBuff.effectValue=effectValue
		byAttackObject:pushBuffEffect(fightBuff)
		effectArray[2] = skillInfluence.influenceDuration
	else
		effectArray[4] = 1
	end
end

function FightUtil.computeAllKill(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	local finalDamage = 9999999
	byAttackObject:subHealthPoint(math.floor(byAttackObject.healthPoint))
	attackObject.effectDamage=9999999
	effectArray[1] = finalDamage
	effectArray[3] = 0
end


function FightUtil.computeFixedKill(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	local effectValue = FightUtil.computeRandomSkillEffectValue(skillInfluence)
	local finalDamage = effectValue
	byAttackObject:subHealthPoint(finalDamage)
	attackObject.effectDamage = finalDamage
	effectArray[1] = finalDamage
	-- effectArray[3] = 0
end

function FightUtil.computeSkillEffect(battleSkill,skillMould, skillInfluence, attackObject, byAttackObject)
	local effectArray = {} --new int[4]
	effectArray[1] = 0
	effectArray[3] = -1
	
	effectArray[2] = 0
	effectArray[4] = 0
	local formulaInfo = battleSkill.formulaInfo
	if (formulaInfo == FightUtil.FORMULA_INFO_COMMON_DAMAGE ) then	
		FightUtil.computeCommonDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_SPECIAL_DAMAGE) then	
		FightUtil.computeSpecialDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_CURE_HP) then	
		FightUtil.computeCureHealthPoint(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_CURE_SP) then	
		FightUtil.computeCureSkillPoint(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_DAMAGE_SP) then	
		FightUtil.computeDamageSkillPoint(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_SP_DISUP) then	
		FightUtil.computeSkillPointDisup(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_DIZZY) then	
		FightUtil.computeDizzy(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_POSION) then	
		FightUtil.computePosion(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_Firing) then	
		FightUtil.computeFiring(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_Explode) then	
		FightUtil.computeExplode(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_PARALYSIS) then	
		FightUtil.computeParalysis(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_NO_SP) then	
		FightUtil.computeNoSkillPoint(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_RETAIN) then	
		FightUtil.computeAddRetain(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_LESSEN_DAMAGE) then	
		FightUtil.computeLessenDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_EVASION_SURELY) then	
		FightUtil.computeEvasionSurely(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_DRAINS) then	
		FightUtil.computeDrains(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_BEAR_HP) then	
		FightUtil.computeBearHP(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_BLIND) then	
		FightUtil.computeBlind(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_CRIPPLE) then	
		FightUtil.computeCripple(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_ATTACK) then	
		FightUtil.computeAddAttack(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_SUB_ATTACK) then	
		FightUtil.computeSubAttack(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_DEFENCE) then	
		FightUtil.computeAddPhysicalDefence(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_SUB_DEFENCE) then
		FightUtil.computeSubPhysicalDefence(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_SELF_DAMAGE) then	
		FightUtil.computeAddDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_SUB_SELF_DAMAGE) then
		FightUtil.computeAddBurise(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_CRITICAL) then	
		FightUtil.computeAddCritical(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_SUB_CRITICAL) then
		FightUtil.computeAddResistCritical(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_HIT) then
		FightUtil.computeAddHit(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_DODGE) then
		FightUtil.computeAddEnvsion(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_ENDURANCE) then
		FightUtil.computeAddEndurance(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
		FightUtil.computeClearBuff(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_DAMAGE) then
		FightUtil.computeAddDamage(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif (formulaInfo == FightUtil.FORMULA_INFO_ADD_KILL) then
		FightUtil.computeAllKill(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
		--break
	elseif(formulaInfo == FightUtil.FORMULA_INFO_FIXED_DAMAGE) then
		FightUtil.computeFixedKill(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	end
	return effectArray
end

function FightUtil.computeBuffEffect(skillMould, skillInfluence, attackObject, byAttackObject)
	local effectArray = {}
	effectArray[1] = 0
	effectArray[3] = -1	
	effectArray[2] = 0
	effectArray[4] = 0
	FightUtil.computeClearBuff(skillMould, skillInfluence, attackObject, byAttackObject, effectArray)
	return effectArray
end

