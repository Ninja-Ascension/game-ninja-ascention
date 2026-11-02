
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
 -- * 作用范围:血量低于60%的
 -- */
SkillInfluence.EFFECT_RANGE_HP_LESS_THEN = 15

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

local obj = SkillInfluence:new()