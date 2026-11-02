
-- 技能影响
-- @author alexdu
SkillInfluence = class("SkillInfluence")
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_GROUP_OPPOSITE =  0
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_GROUP_OURSITE =  1
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_GROUP_CURRENT =  2
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_SINGLE =  0
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_SELF =  1
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_SINGLE_BACK =  2
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_VERICAL =  3
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_HORIZONAL =  4
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_HORIZONAL_BACK =  5
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_ALL =  6
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_HEALTH_MOST =  7
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_HEALTH_LEAST =  8
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_RANDOM_1 =  9
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_RANDOM_2 =  10
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_RANDOM_3 =  11
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_CROSS =  12
-- 技能影响
-- @author alexdu
SkillInfluence.EFFECT_RANGE_SP_MOST =  13
-- /**
-- * 作用范围:血量最少三的
-- */
SkillInfluence.EFFECT_RANGE_HP_lEST = 14
-- /**
--  * 作用范围:血量低于60%的
--  */
SkillInfluence.EFFECT_RANGE_HP_LESS_THEN = 15
-- 16  防属性
SkillInfluence.EFFECT_DEFEND_PROPERTY_TARGET = 16
-- 17  技属性
SkillInfluence.EFFECT_SKILL_PROPERTY_TARGET = 17
-- 18  攻属性
SkillInfluence.EFFECT_ATTACK_PROPERTY_TARGET = 18
-- 19  后排技属性
SkillInfluence.EFFECT_AFTER_SKILL_PROPERTY_TARGET = 19
-- 20   后排血最少的1个
SkillInfluence.EFFECT_AFTER_HP_LESS_THEN_TARGET = 20
-- 21 自身所在列
SkillInfluence.EFFECT_SELF_IN_COLUMN = 21
-- 22 血量值最少的1个
SkillInfluence.EFFECT_HP_PERCENT_LEAST = 22
-- 23 攻击力最高的1个
SkillInfluence.EFFECT_ATTACK_HIGHEST = 23
-- 24  随机3个（随机选择不到人时，继续选择当前攻击目标）
SkillInfluence.EFFECT_RANDOM_LIMIT_3 = 24
-- 25  后排随机1个
SkillInfluence.EFFECT_AFTER_ROW_RANDOM_LIMIT_1 = 25
-- 26  溅射
SkillInfluence.EFFECT_AFTER_SELECT_TARGET_FOR_26 = 26
-- 27 前排防属性
SkillInfluence.EFFECT_AFTER_SELECT_TARGET_FOR_27 = 27
-- 28 在剩余没有攻击的目标中随机一个目标，在同一回合攻击的时候，如果没有剩余可攻击的目标，清除记录状态，重新选
SkillInfluence.EFFECT_AFTER_SELECT_TARGET_FOR_28 = 28
-- 随机四个目标
SkillInfluence.EFFECT_AFTER_SELECT_TARGET_FOR_29 = 29
-- 自己所在的一排
SkillInfluence.EFFECT_AFTER_SELECT_TARGET_FOR_30 = 30
-- 造成伤害的目标中选取前排
SkillInfluence.EFFECT_AFTER_SELECT_TARGET_FOR_31 = 31
-- 造成伤害的目标中选取后排
SkillInfluence.EFFECT_AFTER_SELECT_TARGET_FOR_32 = 32

function SkillInfluence:ctor()
    --所属技能模版
    self.skillMould = nil

    --技能影响描述
    self.influenceDescribe = nil

    --技能种类：0为攻击，1为加血，2为加怒，3为减怒，4为禁怒，5为眩晕，6为中毒，7为麻痹，8为封技，9为灼烧，10为爆裂，11为增加档格，12为增加防御,13为必闪，14为吸血,15为禁疗
    self.skillCategory =  0

    --技能参数，技能计算参数
    self.skillParam =  0

    --技能影响最小值
    self.skillEffectMinValue =  0

    --技能影响最大值
    self.skillEffectMaxValue =  0

    --公式索引
    self.formulaInfo =  0

    --是否为百分比作用，0为是，1为否
    self.isRate =  0

    --附加效果命中率%
    self.additionEffectProbability =  0

    --作用阵营：0为作用于敌方阵营、1为作用于本方阵营、2为作用于当前英雄
    self.influenceGroup =  0

    --作用范围：0为单体、1为自己、2为后排单体、3为直线、4为横排、5为后排横排、6为全体、7为血最多的一个、8为血最少的1个、9为随机1个、10为随机2个、11为随机3个
    self.influenceRange =  0

    --作用峰值，0为无限制，1为作用至满额
    self.peakLimit =  0

    --作用限制：0:无 1:不含自己
    self.influenceRestrict =  0

    --作用时长：0为即时作用、1为作用1回合、2为作用2回合、3为作用3回合
    self.influenceDuration =  0

    --前段光效id
    self.forepartLightingEffectId =  0

    --前段光效音效id
    self.forepartLightingSoundEffectId =  0

    --后段光效id
    self.posteriorLightingEffectId =  0

    --攻击段数
    self.attackSection =  0

    --后段光效音效id
    self.posteriorLightingSoundEffectId =  0

    --光效绘制方式
    self.lightingEffectDrawMethod =  0

    --承受光效id
    self.bearLightingEffectId =  0

    --承受音效id
    self.bearSoundEffectId =  0

    --是否抖动
    self.isVibrate =  0

    self._skillInfluences =  nil

end

function SkillInfluence:setPropertyValue(propertyType, propertyValue, changeType)
    local flag = 1
    if changeType == 1 then
        flag = -1
    end
    if propertyType == 3 then
        -- self.influenceDescribe = propertyValue
    -- elseif propertyType == 4 then
    --     self.skillCategory = propertyValue * flag
    -- elseif propertyType == 5 then
    --     self.skillParam = propertyValue
    elseif propertyType == 6 then
        self.skillEffectMinValue = self.skillEffectMinValue + propertyValue * flag
    elseif propertyType == 7 then
        self.skillEffectMaxValue = self.skillEffectMaxValue + propertyValue * flag
    -- elseif propertyType == 8 then 
    --     self.formulaInfo = propertyValue
    elseif propertyType == 9 then
        self.isRate = self.isRate  + propertyValue * flag
    elseif propertyType == 10 then
        self.additionEffectProbability = self.additionEffectProbability + propertyValue * flag
    elseif propertyType == 11 then
        self.influenceGroup = self.influenceGroup + propertyValue * flag
    elseif propertyType == 12 then
        -- -- self.influenceRange = tonumber( row[12] )
        -- local arrs = zstring.split(propertyValue, ",")
        -- self.influenceRange = tonumber( arrs[1] )
        -- self.influenceRangeType = tonumber( arrs[2] )
        self.influenceRange = self.influenceRange + propertyValue * flag
    -- elseif propertyType == 13 then
    --     self.peakLimit = propertyValue * flag
    -- elseif propertyType == 14 then
    --     self.influenceRestrict = propertyValue * flag
    -- elseif propertyType == 15 then
    --     self.influenceDuration = tonumber( rpropertyValue )
    -- elseif propertyType == 16 then
    --     self.beforeAction = propertyValue
    -- elseif propertyType == 17 then
    --     self.forepartLightingEffectId = propertyValue
    -- elseif propertyType == 18 then
    --     self.forepartLightingSoundEffectId = propertyValue
    -- elseif propertyType == 19 then
    --     self.afterAction = propertyValue
    -- elseif propertyType == 20 then
    --     self.posteriorLightingEffectId = propertyValue
    -- elseif propertyType == 21 then
    --     self.attackSection = propertyValue
    -- elseif propertyType == 22 then
    --     self.posteriorLightingSoundEffectId = propertyValue
    -- elseif propertyType == 23 then
    --     self.lightingEffectDrawMethod = propertyValue
    -- elseif propertyType == 24 then
    --     self.lightingEffectCount = propertyValue
    -- elseif propertyType == 25 then
    --     self.armyBearAction = propertyValue
    -- elseif propertyType == 26 then
    --     self.bearLightingEffectId = propertyValue
    -- elseif propertyType == 27 then
    --     self.bearSoundEffectId = propertyValue
    -- elseif propertyType == 28 then
    --     self.isVibrate = propertyValue
    -- elseif propertyType == 29 then
    --     self.pathAcrtoon = propertyValue
    -- elseif propertyType == 30 then
    --     self.rearEnd = row[30]
    -- elseif propertyType == 31 then
    --     self.beforeAttackFrame = propertyValue * flag
    -- elseif propertyType == 32 then
    --     self.hitDown = propertyValue
    elseif propertyType == 33 then
        -- 技能效用的成长值
        self.levelInitValue = self.levelInitValue + propertyValue * flag -- 固定值
    elseif propertyType == 34 then
        self.levelGrowValue = self.levelGrowValue + propertyValue * flag -- 每级固定值成长
    elseif propertyType == 35 then
        self.levelPercentGrowValue = self.levelPercentGrowValue + propertyValue * flag -- 每级百分比成长
    elseif propertyType == 36 then
        self.nextSkillInfluence = self.nextSkillInfluence + propertyValue * flag -- 被执行的效用ID
    end
end

local obj = SkillInfluence:new()
