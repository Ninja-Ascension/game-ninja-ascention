
-- 天赋判断
-- @author xiaofeng
TalentJudge = class("TalentJudge")

function TalentJudge:ctor()

end

function TalentJudge:judge(judgeOpportunity, attackObject, byAttackObject, skillMould, fightModule, _talentMouldList, _owner)
	-- local attackTalentMouldList = attackObject.talentMouldList
	-- local byAttackTalentMouldList = byAttackObject.talentMouldList
	local talentMouldList = nil
	local judgeObject = nil
	local oppositeObject = nil
	-- if (judgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_ATTACK or judgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD) then
	-- 	talentMouldList = attackTalentMouldList
	-- 	judgeObject = attackObject
	-- 	oppositeObject = byAttackObject
	-- else
	-- 	talentMouldList = byAttackTalentMouldList
	-- 	judgeObject = byAttackObject
	-- 	oppositeObject = attackObject
	-- end

	if (judgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK) then
		-- talentMouldList = byAttackTalentMouldList
		talentMouldList = _talentMouldList or byAttackObject.talentMouldList
		judgeObject = byAttackObject
		oppositeObject = attackObject
	else
		-- talentMouldList = attackTalentMouldList
		talentMouldList = _talentMouldList or attackObject.talentMouldList
		judgeObject = attackObject
		oppositeObject = byAttackObject
	end

	-- 神兽免疫来自武将的天赋被动
	-- if judgeObject ~= nil and oppositeObject ~= nil then
	-- 	if judgeObject.isAnimal == false and oppositeObject.isAnimal == true then
	-- 		-- print("神兽免疫来自武将的天赋被动 judgeObject = ", judgeObject.isAnimal, judgeObject.battleTag, judgeObject.coordinate)
	-- 		-- print("神兽免疫来自武将的天赋被动 oppositeObject = ", oppositeObject.isAnimal, oppositeObject.battleTag, oppositeObject.coordinate)
	-- 		return
	-- 	end
	-- end

	for _, talentMould in pairs(talentMouldList) do
		if judgeObject:isHaveSameTalentJudgeResult(talentMould) then
			-- 该角色拥有有重复的talent类型
		else
			local _skillMould = nil

			if talentMould.influenceJudgeOpportunity == judgeOpportunity then
				-- _crint("取到对应的天赋：", talentMould.id, talentMould.influenceJudgeOpportunity, talentMould.influenceJudgeType1)
				local talentJudgeResult = TalentJudgeResult:new()
				talentJudgeResult.talentMould=talentMould
				talentJudgeResult._owner = _owner or judgeObject
				talentJudgeResult._myself = attackObject == byAttackObject
				talentJudgeResult.judgeOpportunity=talentMould.influenceJudgeOpportunity
				local judgeResultArray = zstring.split(talentMould.influenceJudgeResult, IniUtil.comma)
				talentJudgeResult.resultType=tonumber(judgeResultArray[1])
				-- if(judgeResultArray.length > 1) then
				if(table.nums(judgeResultArray) > 1) then
					local resultValue = tonumber(judgeResultArray[2])
					if(tonumber(judgeResultArray[1]) == 7) then
						_skillMould = ConfigDB.load("skill_mould",resultValue)
						--_skillMould = dms.element(dms["SkillMould"], resultValue)
						talentJudgeResult.skillMould=_skillMould
					else
						talentJudgeResult.percentValue=resultValue
					end
				end
				talentJudgeResult.influenceEffectId=talentMould.influenceEffectId
				local goon = true
				-- if(Unit.GetRandom(1, 100) > talentMould.influenceJudgeOdds) then
				if(math.random(1, 100) > talentMould.influenceJudgeOdds) then
					--continue
					goon = false
				end
				if(talentMould.influenceJudgeOpportunity == -1) then
					--continue
					goon = false
				end
				if (goon) then
					--local goonAgain = false
					if(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_SELF_HP) then
						TalentJudge:judgeSelfHP(talentMould, talentJudgeResult, judgeObject, oppositeObject)
						--continue
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_ATTACK_TYPE) then
						-- if(talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_COMMON_ATTACK or 
						--  talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SPECIAL_ATTACK) then
						-- 	TalentJudge:judgeAttackType(talentMould, talentJudgeResult, judgeObject, skillMould)
						-- end
						TalentJudge:judgeAttackType(talentMould, talentJudgeResult, judgeObject, skillMould)
						--continue
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_GENDER) then
						TalentJudge:judgeOpponetGender(talentMould, talentJudgeResult, judgeObject, oppositeObject)
						--continue
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_COMPPERENCE) then
						TalentJudge:judgeOpponetCampPreference(talentMould, talentJudgeResult, judgeObject, oppositeObject)
						--continue
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_BUFF) then
						TalentJudge:judgeOpponetBuff(talentMould, talentJudgeResult, judgeObject, oppositeObject)
						--continue
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_SP) then
						TalentJudge:judgeOpponetSp(talentMould, talentJudgeResult, judgeObject, oppositeObject)
						--continue
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_CRUEL) then
						TalentJudge:judgeBattleType(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule, byAttackObject)
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_KILL) then
						TalentJudge:judgeHeroProperty(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule, byAttackObject)
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_DODGE) then
						self:judgeHeroShipMouldId(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule, byAttackObject)
					elseif (talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_ALIVE_COUNT) then
						TalentJudge:judgeHeroAliveCount(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule, byAttackObject)
					elseif (talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_ELECTRIC_STATE) then
						TalentJudge:judgeHeroElectricState(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule, byAttackObject)
					elseif(talentMould.influenceJudgeType2 > 0) then
						if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SELF_RETAIN ) then
							if(judgeObject.isRetain()) then
								judgeObject:pushTalentJudgeResultList(talentJudgeResult)
							end
							--break
						elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SELF_EVASION) then
							if(judgeObject.isEvasion()) then
								judgeObject:pushTalentJudgeResultList(talentJudgeResult)
							end
							--break
						elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_RETAIN) then
							if(oppositeObject.isRetain()) then
								judgeObject:pushTalentJudgeResultList(talentJudgeResult)
							end
							--break
						elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SELF_CRITICAL) then
							judgeObject:pushTalentJudgeResultList(talentJudgeResult)
							--break
						end
						--continue
					else
						judgeObject:pushTalentJudgeResultList(talentJudgeResult)
					end
				end
			end
		end
	end
end

function TalentJudge:judgeSelfHP(talentMould, talentJudgeResult, judgeObject, oppositeObject)
	if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_HP_LESS_OPPONENT ) then
		if(judgeObject.healthPoint >= oppositeObject.healthMaxPoint) then
			return
		end
		--break
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_HP_GREATER_OPPONENT) then
		if(judgeObject.healthPoint <= oppositeObject.healthMaxPoint) then
			return
		end
		--break
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_HP_10PERCENT_DECREASE ) then
		local damageHP = judgeObject.healthMaxPoint - judgeObject.healthPoint
		local damangePercent = math.floor (damageHP / judgeObject.healthMaxPoint * 100.0)
		--for (int i = 0; i < damangePercent / 10; i++) {
		for i = 1, damangePercent / 10 do
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
		return
	end
	judgeObject:pushTalentJudgeResultList(talentJudgeResult)
end

function TalentJudge:judgeAttackType(talentMould, talentJudgeResult, judgeObject, skillMould)
	-- _crint("技能类型:", skillMould.id, skillMould.skillQuality, talentMould.influenceJudgeType2)
	if (talentMould.influenceJudgeType2 ==  TalentConstant.JUDGE_TYPE2_COMMON_ATTACK ) then
		if(skillMould.skillQuality == 0) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
			return
		end
		--break
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SPECIAL_ATTACK) then
		if(skillMould.skillQuality == 1) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
		--break
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_NORMAL_SKILL) then
		if(skillMould.skillQuality == 3) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
		--break
	end
end

function TalentJudge:judgeOpponetGender(talentMould, talentJudgeResult, judgeObject, oppositeObject)
	if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_GENDER_MALE ) then
		if(oppositeObject.gender == 1) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
		
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_GENDER_FEMALE ) then
		if(oppositeObject.gender == 2) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end		
	end
end

function TalentJudge:judgeOpponetCampPreference(talentMould, talentJudgeResult, judgeObject, oppositeObject)
	if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_COMPPREFERENCE_WEI ) then
		if(oppositeObject.campPreference == 1) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
		
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_COMPPREFERENCE_SHU ) then
		if(oppositeObject.campPreference == 2) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
		
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_COMPPREFERENCE_WU ) then
		if(oppositeObject.campPreference == 3) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
		
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_COMPPREFERENCE_QUN ) then
		if(oppositeObject.campPreference == 4) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end		
	end
end

function TalentJudge:judgeOpponetBuff(talentMould, talentJudgeResult, judgeObject, oppositeObject)
	--for (FightBuff fightBuff : oppositeObject.buffEffect) {
	for _,  fightBuff in pairs(oppositeObject.buffEffect)  do
		if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_POSION ) then
			if(fightBuff.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_POISON) then
				judgeObject:pushTalentJudgeResultList(talentJudgeResult)
			end		
		elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_FIRING ) then
			if(fightBuff.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_FIRING) then
				judgeObject:pushTalentJudgeResultList(talentJudgeResult)
			end		
		end
	end
end

function TalentJudge:judgeOpponetSp(talentMould, talentJudgeResult, judgeObject, oppositeObject)
	if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_SP_LESS_THAN_2 ) then
		if(oppositeObject.skillPoint <= 2) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
		
	elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_SP_LESS_THAN_4) then
		if(oppositeObject.skillPoint >= 2) then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end		
	end
end

function TalentJudge:judgeBattleType(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule)
	-- _crint("6判断战斗类型")
	if fightModule.fightType == _enum_fight_type._fight_type_11 then
		judgeObject:pushTalentJudgeResultList(talentJudgeResult)
	end
end

function TalentJudge:judgeHeroProperty(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule, byAttackObject)
	-- _crint("7判断对方属性")
	if talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_ATTACK_PROPERTY then -- 攻
		if byAttackObject.campPreference == 1 then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
	elseif talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_SKILL_PROPERTY then -- 技
		if byAttackObject.campPreference == 3 then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
	elseif talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_DEFNED_PROPERTY then -- 防
		if byAttackObject.campPreference == 2 then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
	end
end

function TalentJudge:judgeHeroShipMouldId(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule, byAttackObject)
	-- _crint("8判断对方ship_mould ID")
	judgeObject:pushTalentJudgeResultList(talentJudgeResult)
end

function TalentJudge:judgeHeroAliveCount(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule)
	-- _crint("9判断双方剩余人数")

	local ownBattleTag = -1
	local otherBattleTag = -1

	if judgeObject ~= nil then
		ownBattleTag = judgeObject.battleTag
		otherBattleTag = ownBattleTag == 0 and 1 or 0
	elseif oppositeObject ~= nil then
		otherBattleTag = oppositeObject.battleTag
		ownBattleTag = otherBattleTag == 0 and 1 or 0
	end

	-- 阵容不符合条件时，不处理后续逻辑
	if ownBattleTag == -1 or otherBattleTag == -1 then
		return
	end

	local ownSideCount = fightModule:getRemainCountByTag(ownBattleTag)
	local otherSideCount = fightModule:getRemainCountByTag(otherBattleTag)

	-- print("ownSideCount = ", ownSideCount, " otherSideCount = ", otherSideCount)
	if talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_LIVE_MAX then -- 19对方存活数大于已方
		if otherSideCount > ownSideCount then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
	elseif talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_LIVE_MIN then -- 20对方存活数小于已方
		if otherSideCount < ownSideCount then
			judgeObject:pushTalentJudgeResultList(talentJudgeResult)
		end
	end
end

function TalentJudge:judgeHeroElectricState(talentMould, talentJudgeResult, judgeObject, oppositeObject, fightModule)
	-- print("10判断对方处于感电状态 oppositeObject.isElectric = ", oppositeObject.isElectric)
	if oppositeObject.isElectric == true or oppositeObject.isStrongElectric == true then
		judgeObject:pushTalentJudgeResultList(talentJudgeResult)
	end
end

local obj = TalentJudge:new()
