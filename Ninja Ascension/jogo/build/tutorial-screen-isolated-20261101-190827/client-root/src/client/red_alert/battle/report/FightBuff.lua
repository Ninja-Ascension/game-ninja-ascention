FightBuff = class("FightBuff")

function FightBuff:ctor()
    --技能效用
    self.skillInfluence =  nil

    --影响的回合
    self.effectRound =  0

    --状态是否无效
    self.stateDisable =  false

    --是否为百分比作用，0为是，1为否
    self.isRate =  0

    --影响值1
    self.effectValue =  0

    --影响值2
    self.effectValue2 =  0

    --影响值
    self.effectWorth =  0

    --BUFF是否参与技术
    self.countBuff =  0

    --死亡状态
    self.deadState =  0

end

function FightBuff:getIsRang()
	return isRate
end

function FightBuff:setIsRang(isRate)
	self.isRate = isRate
end

function FightBuff:isStateDisable()
	return stateDisable
end

function FightBuff:restoreEffect(battleObject)
	local skillInfluence = self.skillInfluence
	if (skillInfluence.skillCategory ==	BattleSkill.SKILL_INFLUENCE_NOSP ) then
		battleObject.isSpDisable = false
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DIZZY ) then
		battleObject.isDizzy = false
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_PARALYSIS ) then
		battleObject.isParalysis = false
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DISSP ) then
		battleObject.isDisSp = false
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_EXPLODE ) then
		battleObject.isExplode = false
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDRETAIN ) then
		battleObject.retainAdditional = 0
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDDEFENCE ) then
		battleObject.isNoDamage = false
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_BEAR_HP ) then
		battleObject.isBearHP = false
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_BLIND ) then
		battleObject.isBlind = false
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_CRIPPLE ) then
		battleObject.isCripple = false
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_ATTACK ) then
		battleObject.addAttack = battleObject.addAttack - self.effectValue
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_ATTACK ) then
		battleObject.addAttack = battleObject.addAttack + self.effectValue
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_DEFENSE ) then
		battleObject.addPhysicalDefence = battleObject.addPhysicalDefence - self.effectValue
		battleObject.addSkillDefence = battleObject.addSkillDefence - self.effectValue
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_DEFENSE ) then
		battleObject.addPhysicalDefence = battleObject.addPhysicalDefence - self.effectValue
		battleObject.addSkillDefence = battleObject.addSkillDefence - self.effectValue
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DAMAGE ) then
		if skillInfluence.isRate == 1 then
			battleObject.finalDamageAddition =  battleObject.finalDamageAddition - self.effectValue
		else
			battleObject.addFinalDamagePercent = battleObject.addFinalDamagePercent - self.effectValue
		end
	--清除减伤
	elseif (skillInfluence.skillCategory == FightUtil.FORMULA_INFO_SUB_SELF_DAMAGE ) then
		if skillInfluence.isRate == 1 then
			battleObject.finalSubDamageAddition = battleObject.finalSubDamageAddition - self.effectValue
		else
			battleObject.finalLessenDamagePercent = battleObject.finalLessenDamagePercent - self.effectValue*100
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_CRITICAL ) then	
		battleObject.addCritialMultiple = battleObject.addCritialMultiple - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_SUB_CRITICAL ) then
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_HIT ) then	
		battleObject.addAccuracy = battleObject.addAccuracy - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DODGE ) then
		battleObject.addEvasion = battleObject.addEvasion - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_ENDURANCE ) then
		battleObject.enduranceHPoint = battleObject.enduranceHPoint - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_ADD_FINNAL_DAMAGE ) then	
		battleObject.addBruiseDamagePercent = battleObject.addBruiseDamagePercent - self.effectValue

	end
end

function FightBuff:process(battleObject, resultBuffer)
	local haveEffect = 0
	self.countBuff = 0
	local effectValue = self.effectValue 
	local skillInfluence = self.skillInfluence
	local effectType = skillInfluence.skillCategory
	if(self.effectRound <= 0) then
		self.stateDisable = true
	end
	self.effectRound = self.effectRound - 1
	if (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_NOSP ) then
		if (self.stateDisable ) then
			battleObject.isSpDisable = false
		else
			battleObject.isSpDisable = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DIZZY) then
		if (self.stateDisable ) then
			battleObject.isDizzy = false
		else
			battleObject.isDizzy = true
		end			
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_POISON) then
		if(self.effectRound >= 0) then			
			battleObject:subHealthPoint(self.effectValue)
			if(battleObject.healthPoint < 1) then
				battleObject.isDead = true
				self.deadState = 1
			end
			self.haveEffect = 1
			self.countBuff = 1
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_PARALYSIS) then
		if (self.stateDisable ) then
			battleObject.isParalysis = false
		else
			battleObject.isParalysis = true
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DISSP ) then
		if (self.stateDisable ) then
			battleObject.isDisSp = false
		else
			battleObject.isDisSp = true
		end			
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_FIRING ) then
		if(self.effectRound >= 0) then			
			battleObject:subHealthPoint(effectValue)
			if(battleObject.healthPoint < 1) then
				battleObject.isDead = true
				self.deadState = 1
			end
			self.haveEffect = 1
			self.countBuff = 1
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_EXPLODE ) then
		if (self.stateDisable ) then
			battleObject.isExplode = false
		else
			battleObject.isExplode = true
		end			
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDRETAIN ) then
		if(self.stateDisable) then			
			battleObject.setRetainAdditional(0)
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDDEFENCE ) then
		if (self.stateDisable ) then
			battleObject.isNoDamage = false
		else
			battleObject.isNoDamage = true
		end		
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_BEAR_HP ) then
		if (self.stateDisable ) then
			battleObject.isBearHP = false
		else
			battleObject.isBearHP = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_BLIND ) then
		if (self.stateDisable ) then
			battleObject.isBlind = false
		else
			battleObject.isBlind = true
		end			
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_CRIPPLE ) then
		if (self.stateDisable ) then
			battleObject.isCripple = false
		else
			battleObject.isCripple = true
		end			
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_ATTACK ) then	
		if(self.effectRound >= 0) then
			battleObject:addAttackValue(effectValue)
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_ATTACK ) then	
		if(self.effectRound >= 0)then
			battleObject:subAttack(effectValue)
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_DEFENSE ) then  
		if(self.effectRound >= 0)then
			battleObject:addPhysicalDefenceValue(effectValue)
			battleObject:addSkillDefenceValue(self.effectValue2)
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_DEFENSE ) then	
		if(self.effectRound >= 0) then
			battleObject:subPhysicalDefence(effectValue)
			battleObject:subSkillDefence(self.effectValue2)
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DAMAGE ) then	
		if(self.effectRound >= 0) then
			battleObject.addFinalDamagePercent = effectValue
		else
			self.effectValue = 0
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_BURISE ) then	
		if(self.effectRound >= 0) then
			battleObject.addBruiseDamagePercent = effectValue
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_CRITICAL ) then	
		if(self.effectRound >= 0) then
			battleObject.addCritialMultiple = effectValue
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_SUB_CRITICAL ) then	
		if(self.effectRound >= 0) then
			battleObject:addCriticalResistValue(effectValue)
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_HIT ) then	
		if(self.effectRound >= 0) then
			battleObject.addAccuracy = effectValue
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DODGE ) then
		if(self.effectRound >= 0) then
			battleObject:addEvasionValue(effectValue)
		else
			self.effectValue = 0
		end
		self.haveEffect = 1
		self.countBuff = 1
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_ENDURANCE ) then	

		if(self.effectRound >= 0) then	
			local cureHp = math.min(battleObject.healthMaxPoint- battleObject.healthPoint, effectValue)
			battleObject:addHealthPoint(cureHp)
			self.haveEffect = 1
			self.countBuff = 1
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_ADD_FINNAL_DAMAGE ) then
		if(self.effectRound >= 0) then
			battleObject.addBruiseDamagePercent = effectValue
			self.haveEffect = 1
			self.countBuff = 1
		end
		
	end
	if(tonumber(self.haveEffect) == 1) then
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, effectType)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, effectValue)
	end	
end

local obj = FightBuff:new()