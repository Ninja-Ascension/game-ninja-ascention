RestrainObject = class("RestrainObject")

function RestrainObject:ctor()
    --生命加成
    self.lifeAdditional =  0

    --攻击加成
    self.attackAdditional =  0

    --物防加成
    self.physicDefenceAddtional =  0

    --法防加成
    self.skillDefenceAddtional =  0
	
	--生命加成%
	self.lifeAddtionalPercentage = 0

    --攻击加成%
    self.attackAdditionalPercentage =  0

    --物防加成%
    self.physicDefenceAddtionalPercentage =  0

    --法防加成%
    self.skillDefenceAddtionalPercentage =  0

    --暴击增加%
    self.criticalOdds =  0

    --抗暴率增加
    self.criticalResistOdds =  0

    --命中率%
    self.acciracuOdds =  0

    --闪避率%
    self.evasionOdds =  0

    --物理免伤%
    self.physicLessenDamagePercentage =  0

    --法术免伤%
    self.skillLessenDamagePercentage =  0

    --治疗率%
    self.cureOdds =  0

    --被治疗率%
    self.byCureOdds =  0

    --治疗加成
    self.cureOddsAdditional =  0

    --被治疗加成
    self.byCureOddsadditional =  0

    --最终伤害加成
    self.finalAdditionalDamage =  0

    --最终减伤加成
    self.finalLessenDamage =  0

    --最终伤害加成 %
    self.finalAdditionalDamagePercentage =  0

    --最终减伤加成 %
    self.finalLessenDamagePercentage =  0

    --最终伤害加成 PVP%
    self.finalAdditionalDamagePercentagePvp =  0

    --最终减伤加成 PVP%
    self.finalLessenDamagePercentagePve =  0

    --初始怒气增加
    self.initialSpIncrease =  0

    --统帅(力量)增加
    self.initialHead =  0

    --体质(体力)增加
    self.initialBody =  0

    --智慧(智力)增加
    self.initialWisdom =  0

    --物理攻击加成
    self.physicAttackAdditional =  0

    --法术攻击加成
    self.skillAttackAdditional =  0

    --燃烧伤害加成
    self.firingAdditional =  0

    --中毒伤害增加
    self.posionAdditional =  0

    --燃烧减伤加成
    self.firingLessen =  0

    --中毒减伤加成
    self.posionLessen =  0

end

function RestrainObject:addLifeAdditional(lifeAdditional)
	self.lifeAdditional  = self.lifeAdditional + lifeAdditional
end

function RestrainObject:addAttackAdditional(attackAdditional)
	self.attackAdditional  = self.attackAdditional + attackAdditional
end

function RestrainObject:addPhysicDefenceAddtional(physicDefenceAddtional)
	self.physicDefenceAddtional  = self.physicDefenceAddtional + physicDefenceAddtional
end

function RestrainObject:addSkillDefenceAddtional(skillDefenceAddtional)
	self.skillDefenceAddtional  = self.skillDefenceAddtional + skillDefenceAddtional
end

function RestrainObject:addLifeAddtionalPercentage(lifeAddtionalPercentage)
	self.lifeAddtionalPercentage  = self.lifeAddtionalPercentage + lifeAddtionalPercentage
end

function RestrainObject:addAttackAdditionalPercentage(attackAdditionalPercentage)
	self.attackAdditionalPercentage  = self.attackAdditionalPercentage + attackAdditionalPercentage
end

function RestrainObject:addPhysicDefenceAddtionalPercentage(physicDefenceAddtionalPercentage)
	self.physicDefenceAddtionalPercentage  = self.physicDefenceAddtionalPercentage + physicDefenceAddtionalPercentage
end

function RestrainObject:addSkillDefenceAddtionalPercentage(skillDefenceAddtionalPercentage)
	self.skillDefenceAddtionalPercentage  = self.skillDefenceAddtionalPercentage + skillDefenceAddtionalPercentage
end

function RestrainObject:addCriticalOdds(criticalOdds)
	self.criticalOdds  = self.criticalOdds + criticalOdds
end

function RestrainObject:addCriticalResistOdds(criticalResistOdds)
	self.criticalResistOdds  = self.criticalResistOdds + criticalResistOdds
end

function RestrainObject:addAcciracuOdds(acciracuOdds)
	self.acciracuOdds  = self.acciracuOdds + acciracuOdds
end

function RestrainObject:addEvasionOdds(evasionOdds)
	self.evasionOdds  = self.evasionOdds + evasionOdds
end

function RestrainObject:addPhysicLessenDamagePercentage(physicLessenDamagePercentage)
	self.physicLessenDamagePercentage  = self.physicLessenDamagePercentage + physicLessenDamagePercentage
end

function RestrainObject:addSkillLessenDamagePercentage(skillLessenDamagePercentage)
	self.skillLessenDamagePercentage  = self.skillLessenDamagePercentage + skillLessenDamagePercentage
end

function RestrainObject:addCureOdds(cureOdds)
	self.cureOdds  = self.cureOdds + cureOdds
end

function RestrainObject:addByCureOdds(byCureOdds)
	self.byCureOdds  = self.byCureOdds + byCureOdds
end

function RestrainObject:addCureOddsAdditional(cureOddsAdditional)
	self.cureOddsAdditional  = self.cureOddsAdditional + cureOddsAdditional
end

function RestrainObject:addByCureOddsadditional(byCureOddsadditional)
	self.byCureOddsadditional  = self.byCureOddsadditional + byCureOddsadditional
end

function RestrainObject:addFinalAdditionalDamage(finalAdditionalDamage)
	self.finalAdditionalDamage  = self.finalAdditionalDamage + finalAdditionalDamage
end

function RestrainObject:addFinalLessenDamage(finalLessenDamage)
	self.finalLessenDamage  = self.finalLessenDamage + finalLessenDamage
end

function RestrainObject:addFinalAdditionalDamagePercentage(finalAdditionalDamagePercentage)
	self.finalAdditionalDamagePercentage  = self.finalAdditionalDamagePercentage + finalAdditionalDamagePercentage
end

function RestrainObject:addFinalLessenDamagePercentage(finalLessenDamagePercentage)
	self.finalLessenDamagePercentage  = self.finalLessenDamagePercentage + finalLessenDamagePercentage
end

function RestrainObject:addFinalAdditionalDamagePercentagePvp(finalAdditionalDamagePercentagePvp)
	self.finalAdditionalDamagePercentagePvp  = self.finalAdditionalDamagePercentagePvp + finalAdditionalDamagePercentagePvp
end

function RestrainObject:addFinalLessenDamagePercentagePve(finalLessenDamagePercentagePve)
	self.finalLessenDamagePercentagePve  = self.finalLessenDamagePercentagePve + finalLessenDamagePercentagePve
end

function RestrainObject:addInitialSpIncrease(initialSpIncrease)
	self.initialSpIncrease  = self.initialSpIncrease + initialSpIncrease
end

function RestrainObject:addInitialHead(initialHead)
	self.initialHead  = self.initialHead + initialHead
end

function RestrainObject:addInitialBody(initialBody)
	self.initialBody  = self.initialBody + initialBody
end

function RestrainObject:addInitialWisdom(initialWisdom)
	self.initialWisdom  = self.initialWisdom + initialWisdom
end

function RestrainObject:addPhysicAttackAdditional(physicAttackAdditional)
	self.physicAttackAdditional  = self.physicAttackAdditional + physicAttackAdditional
end

function RestrainObject:addSkillAttackAdditional(skillAttackAdditional)
	self.skillAttackAdditional  = self.skillAttackAdditional + skillAttackAdditional
end

function RestrainObject:addFiringAdditional(firingAdditional)
	self.firingAdditional  = self.firingAdditional + firingAdditional
end

function RestrainObject:addPosionAdditional(posionAdditional)
	self.posionAdditional  = self.posionAdditional + posionAdditional
end

function RestrainObject:addFiringLessen(firingLessen)
	self.firingLessen  = self.firingLessen + firingLessen
end

function RestrainObject:addPosionLessen(posionLessen)
	self.posionLessen  = self.posionLessen + posionLessen
end

local obj = RestrainObject:new()