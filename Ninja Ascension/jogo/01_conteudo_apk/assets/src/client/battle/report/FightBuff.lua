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

    self.currentRoundCount = 0

    
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
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_ATTACK ) then -- 增加攻击比率
		battleObject.addAttackPercent = battleObject.addAttackPercent - self.effectValue

	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_ATTACK ) then -- 降低攻击比率
		battleObject.decAttackPercent = battleObject.decAttackPercent - self.effectValue

	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_DEFENSE ) then -- 增加防御
		battleObject.addPhysicalDefPercent = battleObject.addPhysicalDefPercent - self.effectValue
		battleObject.addSkillDefPercent = battleObject.addSkillDefPercent - self.effectValue2

	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_DEFENSE ) then -- 降低防御
		battleObject.decPhysicalDefPercent = battleObject.decPhysicalDefPercent - self.effectValue
		battleObject.decSkillDefPercent = battleObject.decSkillDefPercent - self.effectValue2

	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DAMAGE ) then -- 受到伤害增加比率
		-- battleObject.addBruiseDamagePercent = battleObject.addBruiseDamagePercent - self.effectValue

	elseif (skillInfluence.skillCategory == FightUtil.FORMULA_INFO_SUB_SELF_DAMAGE ) then --受到伤害降低比率
		-- battleObject.decBruiseDamagePercent = battleObject.decBruiseDamagePercent - self.effectValue

	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_CRITICAL ) then	-- 增加暴击
		battleObject.addCritialMultiple = battleObject.addCritialMultiple - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_SUB_CRITICAL ) then -- 增加抗暴
		battleObject.addCriticalResist = battleObject.addCriticalResist - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_HIT ) then	-- 增加命中
		battleObject.addAccuracy = battleObject.addAccuracy - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DODGE ) then -- 增加闪避
		battleObject.addEvasion = battleObject.addEvasion - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_ENDURANCE ) then -- 持续回血
		-- 持续回血不是利用 enduranceHPoint 来实现的，因此这里不需要处理
		--battleObject.enduranceHPoint = battleObject.enduranceHPoint - self.effectValue
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_ADD_FINNAL_DAMAGE ) then	-- 增加自身伤害率
		battleObject.addFinalDamagePercent = battleObject.addFinalDamagePercent - self.effectValue
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_50) then
		battleObject.lockAttackTargetPos = -1
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_81) then
		battleObject.isExile = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_82) then
		battleObject.isWeak = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_83) then
		battleObject.isCharm = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_84 or skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_129) then
		battleObject.isStone = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_88) then
		battleObject.isCharm = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_92) then
		battleObject.isRealDamage = false
		battleObject.realDamageRatio = 0
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_93) then
		--
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_96) then
		battleObject.isElectric = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_97) then
		battleObject.isStrongElectric = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_106) then
		battleObject.isNoDamage = false
	elseif skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_120 then
		battleObject.isParalysis = false
	end
	-- print("重置buff:", skillInfluence.skillCategory, self.effectRound)
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

	if nil ~= skillInfluence and nil ~= skillInfluence.propertyValue then
		if self.currentRoundCount ~= _ED._fightModule.roundCount then
			self.effectRound = self.effectRound - 1
		end
	else
		self.effectRound = self.effectRound - 1
	end
	-- print("处理buff:", skillInfluence.skillCategory, self.effectRound)
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
				-- _crint("角色死亡1：", battleObject.battleTag, battleObject.coordinate)
				self.deadState = 1
			end
			haveEffect = 1
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
				-- _crint("角色死亡2：", battleObject.battleTag, battleObject.coordinate)
				self.deadState = 1
			end
			haveEffect = 1
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
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_ATTACK ) then -- 增加攻击比率
		if(self.effectRound >= 0) then
			battleObject.addAttackPercent = battleObject.addAttackPercent + self.effectValue
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_ATTACK ) then -- 降低攻击比率
		if(self.effectRound >= 0)then
			battleObject.decAttackPercent = battleObject.decAttackPercent + self.effectValue
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_DEFENSE ) then -- 增加防御
		if(self.effectRound >= 0)then
			battleObject.addPhysicalDefPercent = battleObject.addPhysicalDefPercent + self.effectValue
			battleObject.addSkillDefPercent = battleObject.addSkillDefPercent + self.effectValue2
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_DEFENSE ) then -- 降低防御
		if(self.effectRound >= 0) then
			battleObject.decPhysicalDefPercent = battleObject.decPhysicalDefPercent + self.effectValue
			battleObject.decSkillDefPercent = battleObject.decSkillDefPercent + self.effectValue2
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DAMAGE ) then -- 受到伤害增加比率
		-- if(self.effectRound >= 0) then
		-- 	battleObject.addBruiseDamagePercent = battleObject.addBruiseDamagePercent + self.effectValue
		-- else
		-- 	self.effectValue = 0
		-- end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_BURISE ) then --受到伤害降低比率
		-- if(self.effectRound >= 0) then
		-- 	battleObject.decBruiseDamagePercent = battleObject.decBruiseDamagePercent - self.effectValue
		-- end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_CRITICAL ) then	-- 增加暴击
		if(self.effectRound >= 0) then
			battleObject.addCritialMultiple = battleObject.addCritialMultiple + self.effectValue
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_SUB_CRITICAL ) then -- 增加抗暴
		if(self.effectRound >= 0) then
			battleObject.addCriticalResist = battleObject.addCriticalResist + self.effectValue
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_HIT ) then	-- 增加命中
		if(self.effectRound >= 0) then
			battleObject.addAccuracy = battleObject.addAccuracy + self.effectValue
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DODGE ) then -- 增加闪避
		if(self.effectRound >= 0) then
			battleObject.addEvasion = battleObject.addEvasion + self.effectValue
		else
			self.effectValue = 0
		end
		haveEffect = 1
		self.countBuff = 1
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_ENDURANCE ) then -- 持续回血
		if(self.effectRound >= 0) then	
			local cureHp = math.min(battleObject.healthMaxPoint- battleObject.healthPoint, effectValue)
			battleObject:addHealthPoint(cureHp)
			haveEffect = 1
			self.countBuff = 1
		end
		
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_ADD_FINNAL_DAMAGE ) then	-- 33 增加自身伤害率
		if(self.effectRound >= 0) then
			battleObject.addFinalDamagePercent = battleObject.addFinalDamagePercent + self.effectValue
			haveEffect = 1
			self.countBuff = 1
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_81) then -- 81 放逐
		if self.stateDisable then
			battleObject.isExile = false
		else
			battleObject.isExile = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_82) then -- 82 虚弱
		if self.stateDisable then
			battleObject.isWeak = false
		else
			battleObject.isWeak = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_83) then -- 83 魅惑
		if self.stateDisable then
			battleObject.isCharm = false
		else
			battleObject.isCharm = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_84 or skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_129) then -- 84 石化
		if self.stateDisable then
			battleObject.isStone = false
		else
			battleObject.isStone = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_88) then -- 88 魅惑2
		if self.stateDisable then
			battleObject.isCharm = false
		else
			battleObject.isCharm = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_92) then -- 92 真实伤害
		if self.stateDisable then
			battleObject.isRealDamage = false
			battleObject.realDamageRatio = 0
		else
			battleObject.isRealDamage = true
			battleObject.realDamageRatio = FightUtil.computeRandomSkillEffectValue(skillInfluence)
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_93) then -- 93 设置真实伤害目标
		--
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_96) then -- 96 感电
		if self.stateDisable then
			battleObject.isElectric = false
		else
			battleObject.isElectric = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_97) then
		if self.stateDisable then
			battleObject.isStrongElectric = false
		else
			battleObject.isStrongElectric = true
		end
	elseif (skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_106) then
		if self.stateDisable then
			battleObject.isNoDamage = false
		else
			battleObject.isNoDamage = true
		end	
	elseif skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_120 then
		if self.stateDisable then
			battleObject.isParalysis = false
		else
			battleObject.isParalysis = true
		end
	else
		--
	end
	if(tonumber(haveEffect) == 1) then
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, effectType)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, effectValue)
	end	
end

-- 当FightBuffer删除时，要清除其产生的Bugger状态，这里的清空是恢复到原始状态
function FightBuff.clearBuff(skillCategory, battleObject, skillInfluence)
	-- print("清除buff:", skillCategory)
	if (skillCategory ==	BattleSkill.SKILL_INFLUENCE_NOSP ) then
		battleObject.isSpDisable = false
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_DIZZY ) then
		battleObject.isDizzy = false
		battleObject.isAction = false
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_PARALYSIS ) then
		battleObject.isParalysis = false
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_DISSP ) then
		battleObject.isDisSp = false
		battleObject.skipSuperSkillMould = false
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_EXPLODE ) then
		battleObject.isExplode = false
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_ADDRETAIN ) then
		battleObject.retainAdditional = 0
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_ADDDEFENCE ) then
		battleObject.isNoDamage = false
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_BEAR_HP ) then
		battleObject.isBearHP = false
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_BLIND ) then
		battleObject.isBlind = false
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_CRIPPLE ) then
		battleObject.isCripple = false
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_ATTACK ) then
		battleObject.addAttackPercent = 0

	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_ATTACK ) then
		battleObject.decAttackPercent = 0

	elseif (skillCategory== BattleSkill.SKILL_INFLUENCE_ADD_DEFENSE ) then
		battleObject.addPhysicalDefPercent = 0
		battleObject.addSkillDefPercent = 0

	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_SUB_DEFENSE ) then
		battleObject.decPhysicalDefPercent = 0
		battleObject.decSkillDefPercent = 0

	elseif (skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DAMAGE ) then
		-- battleObject.addBruiseDamagePercent = 0

	elseif (skillCategory == FightUtil.FORMULA_INFO_SUB_SELF_DAMAGE ) then
		-- battleObject.decBruiseDamagePercent = 0

	elseif (skillCategory == BattleSkill.SILL_INFLUENCE_ADD_CRITICAL ) then	
		battleObject.addCritialMultiple = 0
		
	elseif (skillCategory == BattleSkill.SILL_INFLUENCE_SUB_CRITICAL ) then
		battleObject.addCriticalResist = 0
		
	elseif (skillCategory == BattleSkill.SKILL_INFLUENCE_ADD_HIT ) then	
		battleObject.addAccuracy  = 0
		
	elseif (skillCategory == BattleSkill.SILL_INFLUENCE_ADD_DODGE ) then
		battleObject.addEvasion = 0
		
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_ENDURANCE ) then
		battleObject.enduranceHPoint = 0
		
	elseif (skillCategory== BattleSkill.SKILL_INFUENCE_ADD_FINNAL_DAMAGE ) then	
		battleObject.addFinalDamagePercent = 0
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_50) then
		battleObject.lockAttackTargetPos = -1
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_81) then
		battleObject.isExile = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_82) then
		battleObject.isWeak = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_83) then
		battleObject.isCharm = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_84 or skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_129) then
		battleObject.isStone = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_88) then
		battleObject.isCharm = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_92) then
		battleObject.isRealDamage = false
		battleObject.realDamageRatio = 0
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_93) then
		--
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_96) then
		battleObject.isElectric = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_97) then
		battleObject.isStrongElectric = false
	elseif (skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_106) then
		battleObject.isNoDamage = false
	elseif skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_120 then
		battleObject.isParalysis = false
	end

	local propertyValue

	--> __crint("清理BUFF属性：", battleObject.battleTag, battleObject.coordinate, skillInfluence.propertyType)
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if nil ~= skillInfluence and nil ~= skillInfluence.propertyValue then
			--[[输出攻击过程信息
		    ___writeDebugInfo("\t\t\t清理BUFF属性加成信息：" .. "\t" .. "属性类型：" .. __fight_debug_property_type_info["" .. skillInfluence.propertyType .. ""] .. "\t" .. "还原前的属性值：" .. battleObject:getPropertyValue(skillInfluence.propertyType) .. "\r\n")
			--]]

			propertyValue = skillInfluence.propertyValue

			battleObject:addPropertyValue(skillInfluence.propertyType, -1 * skillInfluence.propertyValue)
			skillInfluence.propertyValue = nil
		end
	-- end

	-- 注释见FightUtil.computeFor56，专为究极潜力的天赋而加的
	if skillInfluence and skillInfluence.skillInfluenceId and skillInfluence.valueFoPotential and propertyValue and propertyValue == 0 then
		if tonumber(skillInfluence.skillInfluenceId) == 1410 or tonumber(skillInfluence.skillInfluenceId) == 1411 or tonumber(skillInfluence.skillInfluenceId) == 1412 then
			battleObject:addPropertyValue(skillInfluence.propertyType, -1 * skillInfluence.valueFoPotential)
			skillInfluence.propertyValue = nil
		end
	end

end

local obj = FightBuff:new()