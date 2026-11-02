-- 天赋模板
-- @author xiaofeng
TalentMould = class("TalentMould")

function TalentMould:ctor()
    --天赋名称
    self.talentName =  ""

    --天赋描述
    self.describe =  ""

    --基本属性加成(无就-1)
    self.baseAdditional =  ""

    --免疫效果(无就-1)
    self.influenceImmunity =  ""

    --战前赋予效果(无就-1)
    self.influencePriorType =  0

    --战前赋予效果影响值(无就-1)
    self.influencePriorValue =  ""

    --战内效果判断时机(无就-1，后面的都不读了)
    self.influenceJudgeOpportunity =  0

    --判断类型1(无则-1)
    self.influenceJudgeType1 =  0

    --判断类型2(无则-1)
    self.influenceJudgeType2 =  0

    --效果结果
    self.influenceJudgeResult =  ""

    --判断触发几率
    self.influenceJudgeOdds =  0

    --效用影响id
    self.influenceEffectId =  0

    --效用锁定
    self.influenceLock =  0

    --天赋技能效用
    self.talentBattleSkill = {}

    self._talentMoulds =  nil

    self.level = 1

end

local obj = TalentMould:new()
