RestrainUtil = {}
function RestrainUtil.hasRestrain(attackBattleObject, byAttackCoordinates, byAttackObjects)
	--for (Byte byAttackCoordinate ) thenbyAttackCoordinates) {
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		local battleObject = byAttackObjects[byAttackCoordinate]
		if(battleObject ~= nil) then
			local restrainMould = RestrainUtil.calculateHasRestrain(attackBattleObject, battleObject)
			local bylocal = RestrainUtil.calculateHasRestrain(battleObject, attackBattleObject)
			if(restrainMould ~= nil or bylocal ~= nil) then
				return 1
			end
		end
	end
	return 0
end

function RestrainUtil.calculateHasRestrain(attackBattleObject, byAttackBattleObject)
	--_crint ("calculateHasRestrain" .. tostring(attackBattleObject) .. tostring(byAttackBattleObject))
	local restrainMoulds = attackBattleObject.restrainMoulds
	local restrainMould = nil
	--for (int i = 0; i < restrainMoulds.size(); i++) {
	for _, tempRestrainMould in pairs(restrainMoulds) do
		--local templocal = restrainMoulds.get(i)
		if(tempRestrainMould.restrainCamp == byAttackBattleObject.capacity) then
			restrainMould = tempRestrainMould
			break
		end
	end
	return restrainMould
end

function RestrainUtil.calculateRestrainProperty(attackBattleObject, byAttackBattleObject)
	local restrainMould = RestrainUtil.calculateHasRestrain(attackBattleObject, byAttackBattleObject)
	local restrainObject = RestrainObject:new()
	if(restrainMould ~= nil) then
		local propertyTypeArray = zstring.split(restrainMould.restrainAddition, "|")
		--for (String property ) thenpropertyTypeArray) {
		for _, property in pairs(propertyTypeArray) do
			local propertyType = tonumber(zstring.split(property, IniUtil.comma)[1])
			local propertyValue = tonumber(zstring.split(property, IniUtil.comma)[2])
			if (propertyType ==  EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL ) then
				restrainObject:addAttackAdditional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL) then
				restrainObject:addPhysicDefenceAddtional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL) then
				restrainObject:addSkillDefenceAddtional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL_PERCENTAGE) then
				restrainObject:addAttackAdditionalPercentage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL_PERCENTAGE) then
				restrainObject:addPhysicDefenceAddtionalPercentage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL_PERCENTAGE) then
				restrainObject:addSkillDefenceAddtionalPercentage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CRITICAL_ODDS) then
				restrainObject:addCriticalOdds(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CRITICAL_RESIST_ODDS) then
				restrainObject:addCriticalResistOdds(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_RETAIN_ODDS) then
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_RETAIN_BREAK_ODDS) then
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_ACCURACY_ODDS) then
				restrainObject:addAcciracuOdds(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_EVASION_ODDS) then
				restrainObject:addEvasionOdds(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_LESSEN_DAMAGE_PERCENTAGE) then
				restrainObject:addPhysicLessenDamagePercentage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_LESSEN_DAMAGE_PERCENTAGE) then
				restrainObject:addSkillLessenDamagePercentage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CURE_ODDS) then
				restrainObject:addCureOdds(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_BY_CURE_ODDS) then
				restrainObject:addByCureOdds(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE) then
				restrainObject:addFinalAdditionalDamage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE) then
				restrainObject:addFinalLessenDamage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_INITIAL_SP_INCREASE) then
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_ATTACK_ADDITIONAL) then
				restrainObject:addPhysicAttackAdditional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_ATTACK_ADDITIONAL) then
				restrainObject:addSkillAttackAdditional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CURE_ADDITIONAL) then
				restrainObject:addCureOddsAdditional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_BY_CURE_ADDITIONAL) then
				restrainObject:addByCureOddsadditional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FIRING_ADDITIONAL) then
				restrainObject:addFiringAdditional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_POSION_ADDITIONAL) then
				restrainObject:addPosionAdditional(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FIRING_LESSEN) then
				restrainObject:addFiringLessen(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_POSION_LESSEN) then
				restrainObject:addPosionLessen(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE_PERCENT) then
				restrainObject:addFinalAdditionalDamagePercentage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE_PERCENT) then
				restrainObject:addFinalLessenDamagePercentage(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE_PERCENT_PVP) then
				restrainObject:addFinalAdditionalDamagePercentagePvp(propertyValue)
				--break
			elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE_PERCENT_PVP) then
				restrainObject:addFinalLessenDamagePercentagePve(propertyValue)
				--break
			else
				--break
			end
		end
	end
	attackBattleObject.restrainObject = restrainObject
end

