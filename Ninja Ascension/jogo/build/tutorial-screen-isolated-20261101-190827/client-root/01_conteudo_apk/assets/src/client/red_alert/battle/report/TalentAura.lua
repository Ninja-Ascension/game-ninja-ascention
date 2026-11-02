
-- 天赋光环
-- @author xiaofeng
TalentAura = class("TalentAura")

function TalentAura:ctor()
    --作用回合
    self.effectCount =  -1

    --作用类型
    self.effectType =  0

    --作用zhi
    self.effectValue =  0

end

function TalentAura:subEffectCount(effectCount)
	self.effectCount = self.effectCount - effectCount
end

local obj = TalentAura:new()