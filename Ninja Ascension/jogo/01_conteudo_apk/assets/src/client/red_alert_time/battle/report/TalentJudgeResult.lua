-- 天赋判断结果
-- @author xiaofeng
TalentJudgeResult = class("TalentJudgeResult")

function TalentJudgeResult:ctor()
    --天赋模板
    self.talentMould =  nil

    --判断时机
    self.judgeOpportunity =  -1

    --结果类型
    self.resultType =  -1

    --百分比值
    self.percentValue =  0

    --技能模板
    self.skillMould =  nil

    --效用影响id
    self.influenceEffectId =  nil

end

local obj = TalentJudgeResult:new()