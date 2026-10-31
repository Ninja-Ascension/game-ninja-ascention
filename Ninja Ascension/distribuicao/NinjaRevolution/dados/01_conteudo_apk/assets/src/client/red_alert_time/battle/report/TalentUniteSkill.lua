
TalentUniteSkill = class("TalentUniteSkill")

function TalentUniteSkill:ctor()
    --天赋模板
    self.talentMould =  nil

    --天赋所有者
    self.battleObject = nil

    --持续回合
    self.effectCount = nil

end

function TalentUniteSkill:subEffectCount(fightModule)
	if(talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_EMAMY_ATTACK) then
		for _,  tempObject in  pairs(fightModule.byAttackObjects) do
			if(nil ~= tempObject) then
				--for(TalentUniteSkill talentUniteSkill :tempObject.talentUniteSkillList){
				for _, talentUniteSkill in pairs(tempObject.talentUniteSkillList) do
					if(talentMould == talentUniteSkill.talentMould) then
						local count = talentUniteSkill.effectCount
						--count--
						talentUniteSkill.effectCount = count - 1
					end
				end
			end
		end
	end
	if(talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_OWER_ATTACK) then
		--for (BattleObject tempObject : fightModule.attackObjects) {
		for _, tempObject in pairs(fightModule.attackObjects) do
			if(nil ~= tempObject) then
				--for(TalentUniteSkill talentUniteSkill :tempObject.talentUniteSkillList){
				for _, talentUniteSkill in pairs(tempObject.talentUniteSkillList) do
					if(talentMould == talentUniteSkill.talentMould) then
						local count = talentUniteSkill.effectCount
						--count--
						talentUniteSkill.effectCount = count - 1
					end
				end
			end
		end
	end
end
--[[
function TalentUniteSkill:processUniteSkill(resultBuffer, fightModule)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "3").append(IniUtil.compart)
		table.insert(resultBuffer, "1").append(IniUtil.compart)
		table.insert(resultBuffer, "4").append(IniUtil.compart)
		table.insert(resultBuffer, "1").append(IniUtil.compart)
		table.insert(resultBuffer, "254").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "3").append(IniUtil.compart)
		table.insert(resultBuffer, "1").append(IniUtil.compart)
		table.insert(resultBuffer, "-1").append(IniUtil.compart)
		table.insert(resultBuffer, "-1").append(IniUtil.compart)
		table.insert(resultBuffer, "1").append(IniUtil.compart)
		table.insert(resultBuffer, "1").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "8888").append(IniUtil.compart)
		table.insert(resultBuffer, "1").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
		table.insert(resultBuffer, "0").append(IniUtil.compart)
	}
end
--]]
local obj = TalentUniteSkill:new()