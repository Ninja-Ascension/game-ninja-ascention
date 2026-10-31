-- 天赋技能
-- @author xiaofeng
-- TalentSkill = class("TalentSkill")

-- function TalentSkill:ctor()
-- end

TalentSkill = {}

---处理被攻击者释放技能
function TalentSkill.processByAttack(userInfo, attackBattleSkill, fightModule, attackObject, byAttackObject)
	--for (Iterator<TalentMould> talentIter = byAttackObject.talentMouldList.iterator(); talentIter.hasNext();) then
	for _, talentMould in pairs(byAttackObject.talentMouldList) do
		--TalentMould talentMould = talentIter.next()
		if(talentMould.influenceJudgeOpportunity ~= TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK) then
			--continue
		else
			-- if((Unit.GetRandom(1, 100) > talentMould.influenceJudgeOdds)) then
			if((math.random(1, 100) > talentMould.influenceJudgeOdds)) then
				--continue
			else
				local goon = true
				if(talentMould.influenceJudgeType1 ~= -1) then
					if(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_SELF_HP) then			
						if(talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_HP_LESS_OPPONENT) then
							if(byAttackObject.healthPoint >= attackObject.healthMaxPoint) then
								--continue
								goon = false
							else
								--break
						end
						elseif(talentMould.influenceJudgeType2 ==  TalentConstant.JUDGE_TYPE2_HP_GREATER_OPPONENT) then
							if(byAttackObject.healthPoint <= attackObject.healthMaxPoint) then
								--continue
								goon = false
							else
								break
							end
						end
					elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_ATTACK_TYPE) then
						if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_COMMON_ATTACK) then
							if(attackBattleSkill.skillMould.skillQuality ~= 0) then
								--continue
								goon = false
							else
								break
							end
						elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SPECIAL_ATTACK) then
							if(attackBattleSkill.skillMould.skillQuality ~= 1) then
								--continue
								goon = false
							else
								break
							end
						end
					end
				end
			end
		end
		if(talentMould.influenceJudgeType2 ~= -1) then
			if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SELF_RETAIN ) then
				if(byAttackObject.isRetain() ~= true) then
					--continue
					goon = false
				else
					break
				end
			elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SELF_EVASION ) then
				if(byAttackObject.isEvasion() ~= true) then
					--continue
					goon = false
				else 
					break
				end
			end
		end
		if goon == true then 
			TalentSkill.executeSkill(userInfo, talentMould, fightModule, byAttackObject, attackObject.coordinate, true)
		end 
	end
end

--- 处理攻击者释放技能
function TalentSkill.processAttack(userInfo, attackBattleSkill, fightModule, attackObject, byAttackObject)
	local buff = byAttackObject.buffEffect
	local battleObjectList = fightModule.byAttackObjects;
	if ( attackObject.battleTag == 0 ) then
		battleObjectList = fightModule.attackObjects
	end
	for _,  battleObject  in pairs(battleObjectList) do
		--BattleObject battleObject = battleObjectList[i]
		if(battleObject == null) then
			--continue
		else
			if(battleObject.id ~= attackObject.id) then
				local talentMouldList = battleObject.talentMouldList
				for idx, talentMould in pairs(talentMouldList)  do
					if(talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_ATTACK) then
						local isActivate = false
						if(talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_WEI ) then
							isActivate = attackObject.campPreference == 1
							--break
						elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_SHU ) then
							isActivate = attackObject.campPreference == 2
							--break
						elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_WU ) then
							isActivate = attackObject.campPreference == 3
							--break
						elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_QUN ) then
							isActivate = attackObject.campPreference == 4
							--break
						elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_ALL_SELF ) then
							isActivate = true
							--break
						end
						if(isActivate) then
							---这个地方是错误的  FightObject中的talentMouldList没有索引 ！！！
							attackObject.talentMouldList[talentMould.id] = nil
							table.insert(attackObject.talentMouldList,talentMould)
						end
					end
				end
			end
		end
	end

	--for (Iterator<TalentMould> talentIter = attackObject.talentMouldList.iterator(); talentIter.hasNext();) then
	for _, talentMould in pairs(attackObject.talentMouldList) do
		--TalentMould talentMould = talentIter.next()
		local goon = true
		if(talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_ATTACK 
				and talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_BUFF)then	
			local isPosion = false
			for _, fightBuff in pairs(buff) do
				--FightBuff fightBuff = buff.get(i)
				local formulaInfo = fightBuff.skillInfluence.formulaInfo
				if(formulaInfo == FightUtil.FORMULA_INFO_POSION 
						and talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_POSION
					or formulaInfo == FightUtil.FORMULA_INFO_Firing 
						and talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_FIRING)then	
					isPosion = true
				end
			end
			if(isPosion ~= true)then
				--continue
				goon = false
			end
		end
		if(talentMould.influenceJudgeOpportunity ~= TalentConstant.JUDGE_OPPORTUNITY_ATTACK)then
			--continue
			goon = false
		end
		-- if((Unit.GetRandom(1, 100) > talentMould.influenceJudgeOdds))then
		if((math.random(1, 100) > talentMould.influenceJudgeOdds))then
			--continue
			goon = false
		end
		local goonAgain = true
		if (goon) then
			if(talentMould.influenceJudgeType1 ~= -1)then
				if(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_SELF_HP)then					
					if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_HP_LESS_OPPONENT) then
						if(byAttackObject.healthPoint >= attackObject.healthMaxPoint)then
							--continue
							goonAgain = false
						end
						-- delete switch case break
						--break
					elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_HP_GREATER_OPPONENT) then
						if(byAttackObject.healthPoint <= attackObject.healthMaxPoint)then
							--continue
							goonAgain = false
						end
						--break
					end
				elseif(talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_ATTACK_TYPE)then	
					if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_COMMON_ATTACK )then
						if(attackBattleSkill.skillMould.skillQuality ~= 0)then
							--continue
							goonAgain = false
						end
						--break
					elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SPECIAL_ATTACK )then
						if(attackBattleSkill.skillMould.skillQuality ~= 1)then
							--continue
							goonAgain = false
						end
						--break
					end
				elseif (talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_GENDER)then
					if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_GENDER_MALE ) then
						if(byAttackObject.gender ~= 1)then
							--continue
							goonAgain = false
						end
						--break
					elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_GENDER_FEMALE ) then
						if(byAttackObject.gender ~= 2)then
							--continue
							goonAgain = false
						end
						--break
					end
				elseif (talentMould.influenceJudgeType1 == TalentConstant.JUDGE_TYPE1_OPPONENT_BUFF)then
					-- of no use
					--for (FightBuff fightBuff : byAttackObject.buffEffect) then							
					--	switch(talentMould.influenceJudgeType2)then
					--	case TalentConstant.JUDGE_TYPE2_OPPONENT_POSION:
					--		if(fightBuff.skillInfluence.skillCategory ~= BattleSkill.SKILL_INFLUENCE_POISON)then
					--			continue
					--		end
					--		break
					--	case TalentConstant.JUDGE_TYPE2_OPPONENT_FIRING:
					--		if(fightBuff.skillInfluence.skillCategory ~= BattleSkill.SKILL_INFLUENCE_FIRING)then
					--			continue
					--		end
					--		break
					--	end							
					--end
					--
				end
			end
		end  -- endof goon
		if (goonAgain and goon) then   --我日你仙人的，就差一个goon 执行下面的逻辑了。操蛋的！！！！老子检查了两天
			local toProcess = true
			if(talentMould.influenceJudgeType2 ~= -1)then
				if (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_RETAIN ) then
					if(byAttackObject.isRetain() ~= true)then
						--continue
						toProcess = false
					end
					--break
				elseif (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SELF_CRITICAL) then
					if(attackObject.isCritical() ~= true)then
						-- continue
						toProcess = false
					end
					--break
				end
			end
			if (toProcess) then
				TalentSkill.executeSkill(userInfo, talentMould, fightModule, attackObject, byAttackObject.coordinate, false)
			end
		end  -- endof goonAgain
	end
end


function TalentSkill.processSelfDead(userInfo, fightModule, attackObject, deadObject)
		if( deadObject.isDead ~= true)then
			return
		end
		--for (Iterator<TalentMould> talentIter = deadObject.talentMouldList.iterator(); talentIter.hasNext();) then
		for _, talentMould in pairs(deadObject.talentMouldList)  do
			--TalentMould talentMould = talentIter.next()
			local goon = true
			if(talentMould.influenceJudgeOpportunity ~= TalentConstant.JUDGE_OPPORTUNITY_SELF_DEAD)then
				--continue
				goon = false
			end
			-- if((Unit.GetRandom(1, 100) > talentMould.influenceJudgeOdds))then
			if((math.random(1, 100) > talentMould.influenceJudgeOdds))then
				--continue
				goon = false
			end
			if (goon) then
				if(null ~= attackObject)then					
					TalentSkill.executeSkill(userInfo, talentMould, fightModule, deadObject, attackObject.coordinate, true)
				else
					TalentSkill.executeSkill(userInfo, talentMould, fightModule, deadObject, -1, true)
				end
			end
		end
	
end

function TalentSkill.processTargetDead(userInfo, fightModule, attackObject, deadObject)
	if(deadObject.isDead ~= true)then
		return
	end
	--for (Iterator<TalentMould> talentIter = attackObject.talentMouldList.iterator(); talentIter.hasNext();) then
	for _, talentMould in pairs(attackObject.talentMouldList)  do
		--TalentMould talentMould = talentIter.next()
		local goon = true
		if(talentMould.influenceJudgeOpportunity ~= TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD)then
			--continue
			goon = false
		end
		-- if((Unit.GetRandom(1, 100) > talentMould.influenceJudgeOdds))then
		if((math.random(1, 100) > talentMould.influenceJudgeOdds))then
			--continue
			goon = false
		end
		if (goon) then
			TalentSkill.executeSkill(userInfo, talentMould, fightModule, attackObject, -1, false)
		end
	end
end

function TalentSkill.executeSkill(userInfo, talentMould, fightModule, executeObject, coordinate, byAttackTalent)
	local battleSkillList = talentMould.talentBattleSkill
	local byAttackCoordinates = {}
	
	--for (Object battleSkillObj : battleSkillList) then
	for _, battleSkill in pairs(battleSkillList) do
		--BattleSkill battleSkill = (BattleSkill)battleSkillObj
		if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or 
			battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP)then
			byAttackCoordinates = {}
		end
		if (0 == executeObject.battleTag) then
			if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
				if (#byAttackCoordinates == 0)then
					if(talentMould.influenceLock == TalentConstant.INFLUENCE_LOCK_LOCK)then
						byAttackCoordinates = FightUtil:computeCounterCoordinate(coordinate, battleSkill.skillInfluence, executeObject, fightModule.byAttackObjects)
					else							
						byAttackCoordinates = FightUtil:computeEffectCoordinate(executeObject.coordinate, battleSkill.skillInfluence, executeObject, fightModule.byAttackObjects)
					end
				end
				battleSkill:processTalentAttack(userInfo, byAttackCoordinates, executeObject, fightModule.byAttackObjects, fightModule, byAttackTalent, fightModule.battleSkillBuffer)
			elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE)then
				byAttackCoordinates = FightUtil.computeEffectCoordinate(executeObject.coordinate, battleSkill.skillInfluence, executeObject, fightModule.attackObjects)
				battleSkill:processTalentAttack(userInfo, byAttackCoordinates, executeObject, fightModule.attackObjects, fightModule, byAttackTalent, fightModule.battleSkillBuffer)
			elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT)then
				byAttackCoordinates.clear()
				byAttackCoordinates.add(executeObject.coordinate)
				battleSkill:processTalentAttack(userInfo, byAttackCoordinates, executeObject, fightModule.attackObjects, fightModule, byAttackTalent, fightModule.battleSkillBuffer)
			end
		else
			if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
				if (#byAttackCoordinates == 0)then
					if(talentMould.influenceLock == TalentConstant.INFLUENCE_LOCK_LOCK)then							
						byAttackCoordinates = FightUtil:computeCounterCoordinate(coordinate, battleSkill.skillInfluence, executeObject, fightModule.attackObjects)
					else							
						byAttackCoordinates = FightUtil:computeEffectCoordinate(executeObject.coordinate, battleSkill.skillInfluence, executeObject, fightModule.attackObjects)
					end
				end
				battleSkill:processTalentAttack(userInfo, byAttackCoordinates, executeObject, fightModule.attackObjects, fightModule, byAttackTalent, fightModule.battleSkillBuffer)
			elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE)then
				byAttackCoordinates = FightUtil:computeEffectCoordinate(executeObject.coordinate, battleSkill.skillInfluence, executeObject, fightModule.byAttackObjects)
				battleSkill:processTalentAttack(userInfo, byAttackCoordinates, executeObject, fightModule.byAttackObjects, fightModule, byAttackTalent, fightModule.battleSkillBuffer)
			elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT)then
				byAttackCoordinates = {}
				byAttackCoordinates.add(executeObject.coordinate)
				battleSkill:processTalentAttack(userInfo, byAttackCoordinates, executeObject, fightModule.byAttackObjects, fightModule, byAttackTalent, fightModule.battleSkillBuffer)
			end
		end
	end
end

function TalentSkill.processUniteAttack(userInfo, attackBattleSkill, fightModule, attackObject, byAttackObject)
	--for(Iterator<TalentUniteSkill> iterator = attackObject.talentUniteSkillList.iterator();iterator.hasNext();)then
	for _, talentUniteSkill in pairs(attackObject.talentUniteSkillList) do
		--TalentUniteSkill talentUniteSkill = iterator.next()
		if(talentUniteSkill.effectCount == 0)then
			--continue
		else
			local talentMould = talentUniteSkill.talentMould
			local attackBattleObject = talentUniteSkill.battleObject
			local coordinate = byAttackObject.coordinate
			local goon = true
			if(attackBattleObject.isDead)then
				--continue
				goon = false
			else
				if(talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_EMAMY_ATTACK)then
					if(attackObject.battleTag == 0)then
						--continue
						goon = false
					end
					coordinate = attackObject.coordinate
				elseif(talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_OWER_ATTACK)then
					if(attackObject.battleTag == 1 )then
						--continue
						goon = false
					end
					coordinate  = byAttackObject.coordinate
					if(byAttackObject.isDead)then
						--continue
						goon = false
					end
				else
					--continue
					goon = false
				end
			end
			if (goon) then
				local goonAgain = true
				if  (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_CRITICAL ) then
					if(attackObject.isCritical() ~= true and byAttackObject.isDead ~= true)then
						--continue
						goonAgain = false
					end
					--break
				elseif  (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_PEER_DEAD)then
					if(byAttackObject.isDead ~= true)then
						--continue
						goonAgain = false
					end
					coordinate  = attackObject.coordinate
					--break
				elseif  (talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_OPPONENT_PEER_EVAGE)then
					if(byAttackObject.isEvasion() ~= true)then
						--continue
						goonAgain = false
					end
					--break
				else
					-- As default is continue,  nothing to do
					--continue
					goonAgain = false
				end
				if (goonAgain) then
					talentUniteSkill.subEffectCount(fightModule)
					--local skillMould = (SkillMould)ConfigDB.load("SkillMould", talentMould.influenceJudgeResult.split(IniUtil.comma)[1])
					local skillMouldString = dms.element(dms["skill_mould"], string.split(talentMould.influenceJudgeResult, IniUtil.comma)[2])
					local skillMould = SkillMould:new():int(skillMouldString)

					local skillList = zstring.split(skillMould.healthAffect, IniUtil.comma)
					local resultBuffer = {}
					resultBuffer[#resultBuffer] = attackBattleObject.battleTag
					resultBuffer[#resultBuffer] = IniUtil.compart
					resultBuffer[#resultBuffer] = attackBattleObject.coordinate
					resultBuffer[#resultBuffer] = IniUtil.compart
					resultBuffer[#resultBuffer] = 0
					resultBuffer[#resultBuffer] = IniUtil.compart
					resultBuffer[#resultBuffer] = skillMould.id
					resultBuffer[#resultBuffer] = IniUtil.compart
					resultBuffer[#resultBuffer] = table.nums(skillList) -- skillList.length
					resultBuffer[#resultBuffer] = IniUtil.compart
					local effectCount = 0
					for i, _ in pairs(skillList) do
						local skillInfluenceString = dms.element(dms["skill_influence"], skillList[i])
						local skillInfluence = SkillInfluence:init(skillInfluenceString)
						local battleSkill = BattleSkill:new()
						battleSkill.attackerTag=attackBattleObject.battleTag
						battleSkill.attacterCoordinate=attackBattleObject.coordinate
						battleSkill.skillMould=skillMould
						battleSkill.skillInfluence=skillInfluence
						battleSkill.effectType=skillInfluence.skillCategory
						battleSkill.effectRound=skillInfluence.influenceDuration
						talentMould.talentBattleSkill = {}
						table.insert(talentMould.talentBattleSkill, battleSkill)
						TalentSkill.executeTalentUniteSkill(userInfo, talentMould, fightModule, attackBattleObject, coordinate, false, resultBuffer,effectCount)
					end
					talentMould.talentBattleSkill = {}
				end
			end  -- end goon
		end
	end
end

function TalentSkill.executeTalentUniteSkill(userInfo, talentMould, fightModule, executeObject, coordinate, byAttackTalent, resultBuffer, effectCount)
	local battleSkillList = talentMould.talentBattleSkill
	local byAttackCoordinates = {}
	--for (Object battleSkillObj : battleSkillList) then
	for _, battleSkill in pairs(battleSkillList) do
		--BattleSkill battleSkill = (BattleSkill)battleSkillObj
		if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or 
			battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP)then
			byAttackCoordinates = {}
		end
		if (0 == executeObject.battleTag) then
			if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
				if (#byAttackCoordinates == 0)then
					if(talentMould.influenceLock == TalentConstant.INFLUENCE_LOCK_LOCK)then							
						byAttackCoordinates = FightUtil.computeCounterCoordinate(coordinate, battleSkill.skillInfluence, executeObject, fightModule.byAttackObjects)
					else							
						byAttackCoordinates = FightUtil:computeEffectCoordinate(executeObject.coordinate, battleSkill.skillInfluence, executeObject, fightModule.byAttackObjects)
					end
				end
				battleSkill.processTalentUniteAttack(userInfo, byAttackCoordinates, executeObject, fightModule.byAttackObjects, fightModule, byAttackTalent, resultBuffer,effectCount)
			elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE)then
				byAttackCoordinates = FightUtil.computeEffectCoordinate(executeObject.coordinate, battleSkill.skillInfluence, executeObject, fightModule.attackObjects)
				battleSkill.processTalentUniteAttack(userInfo, byAttackCoordinates, executeObject, fightModule.attackObjects, fightModule, byAttackTalent, resultBuffer,effectCount)
			elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT)then
				byAttackCoordinates.clear()
				byAttackCoordinates.add(executeObject.coordinate)
				battleSkill.processTalentUniteAttack(userInfo, byAttackCoordinates, executeObject, fightModule.attackObjects, fightModule, byAttackTalent, resultBuffer,effectCount)
			end
		else
			if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
				if (#byAttackCoordinates == 0)then
					if(talentMould.influenceLock == TalentConstant.INFLUENCE_LOCK_LOCK)then							
						byAttackCoordinates = FightUtil:computeCounterCoordinate(coordinate, battleSkill.skillInfluence, executeObject, fightModule.attackObjects)
					else							
						byAttackCoordinates = FightUtil:computeEffectCoordinate(executeObject.coordinate, battleSkill.skillInfluence, executeObject, fightModule.attackObjects)
					end
				end
				battleSkill.processTalentUniteAttack(userInfo, byAttackCoordinates, executeObject, fightModule.attackObjects, fightModule, byAttackTalent, resultBuffer,effectCount)
			elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE)then
				byAttackCoordinates = FightUtil:computeEffectCoordinate(executeObject.coordinate, battleSkill.skillInfluence, executeObject, fightModule.byAttackObjects)
				battleSkill.processTalentUniteAttack(userInfo, byAttackCoordinates, executeObject, fightModule.byAttackObjects, fightModule, byAttackTalent, resultBuffer,effectCount)
			elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT)then
				byAttackCoordinates.clear()
				byAttackCoordinates.add(executeObject.coordinate)
				battleSkill.processTalentUniteAttack(userInfo, byAttackCoordinates, executeObject, fightModule.byAttackObjects, fightModule, byAttackTalent, resultBuffer,effectCount)
			end
		end
	end	
end

