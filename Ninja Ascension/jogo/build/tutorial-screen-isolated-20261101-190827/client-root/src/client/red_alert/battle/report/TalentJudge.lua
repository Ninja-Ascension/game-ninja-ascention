
-- 天赋判断
-- @author xiaofeng
TalentJudge = class("TalentJudge")

function TalentJudge:ctor()

end

-- 解析天赋数据
function TalentJudge:judge(judgeOpportunity, attackObject, byAttackObject, skillMould)
	local attackTalentMouldList = attackObject.talentMouldList
	local byAttackTalentMouldList = byAttackObject.talentMouldList
	local talentMouldList = nil
	local judgeObject = nil
	local oppositeObject = nil
	if(judgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_ATTACK or judgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD) then
		talentMouldList = attackTalentMouldList
		judgeObject = attackObject
		oppositeObject = byAttackObject
	else
		talentMouldList = byAttackTalentMouldList
		judgeObject = byAttackObject
		oppositeObject = attackObject
	end
	--for (TalentMould talentMould : talentMouldList) {
	for _, talentMould in pairs(talentMouldList) do
		local _skillMould = nil
		local talentJudgeResult = TalentJudgeResult:new()
		-- 天赋模板
		talentJudgeResult.talentMould=talentMould
		-- 判断时机
		talentJudgeResult.judgeOpportunity=talentMould.influenceJudgeOpportunity
		-- 技能效用
		local judgeResultArray = zstring.split(talentMould.influenceJudgeResult, IniUtil.comma)
		-- 天赋调用技能效用类型 type = 1
		talentJudgeResult.resultType=tonumber(judgeResultArray[1])
		-- if(judgeResultArray.length > 1) then
		if(table.nums(judgeResultArray) > 1) then
			-- 技能效用 对应数值
			local resultValue = tonumber(judgeResultArray[2])
			-- 如果类型为7 则调用对应技能模板id
			if(tonumber(judgeResultArray[1]) == 7) then
				--_skillMould = (SkillMould) ConfigDB.load("SkillMould", (int) resultValue)
				_skillMould = dms.element(dms["SkillMould"], resultValue)
				talentJudgeResult.skillMould=_skillMould
			else
				talentJudgeResult.percentValue=resultValue
			end
		end

		-- 天赋技能效用id 调用13
		talentJudgeResult.influenceEffectId=talentMould.influenceEffectId
		local goon = true
		-- if(Unit.GetRandom(1, 100) > talentMould.influenceJudgeOdds) then
		-- 判断技能
		if(math.random(1, 100) > talentMould.influenceJudgeOdds) then
			--continue
			goon = false
		end

		-- 判断时机 == -1 后面都不进行判断
		if(talentMould.influenceJudgeOpportunity == -1) then
			--continue
			goon = false
		end

		-- 解析被动技能 和阵营加成等属性
		if (goon) then
			--local goonAgain = false
			if(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_SELF_HP) then
				judgeSelfHP(talentMould, talentJudgeResult, judgeObject, oppositeObject)
				--continue
			elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_ATTACK_TYPE) then
				if(talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_COMMON_ATTACK or 
				 talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SPECIAL_ATTACK) then
					judgeAttackType(talentMould, talentJudgeResult, judgeObject, skillMould)
				end
				--continue
			elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_GENDER) then
				judgeOpponetGender(talentMould, talentJudgeResult, judgeObject, oppositeObject)
				--continue
			elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_COMPPERENCE) then
				judgeOpponetCampPreference(talentMould, talentJudgeResult, judgeObject, oppositeObject)
				--continue
			elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_BUFF) then
				judgeOpponetBuff(talentMould, talentJudgeResult, judgeObject, oppositeObject)
				--continue
			elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_SP) then
				judgeOpponetSp(talentMould, talentJudgeResult, judgeObject, oppositeObject)
				--continue
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

local obj = TalentJudge:new()
