
-- 技能模版
-- @author alexdu
SkillMould = class("SkillMould")
-- 技能模版
-- @author alexdu
SkillMould.SKILL_PROPERTY_PHYSICAL =  0
-- 技能模版
-- @author alexdu
SkillMould.SKILL_PROPERTY_SPECIAL =  1
-- 技能模版
-- @author alexdu
SkillMould.SKILL_RELEASE_POSION_SPOT =  0
-- 技能模版
-- @author alexdu
SkillMould.SKILL_RELEASE_POSION_CENTRE_SCREEN =  1
-- 技能模版
-- @author alexdu
SkillMould.SKILL_RELEASE_POSION_STRAIGHT =  2
-- 技能模版
-- @author alexdu
SkillMould.SKILL_RELEASE_POSION_FRONT_FORWARD =  3
-- 技能模版
-- @author alexdu
SkillMould.SKILL_RELEASE_POSION_FRONT_BACKWARD =  4
-- 技能模版
-- @author alexdu
SkillMould.SKILL_RELEASE_POSION_ASSAULT =  5
-- 技能模版
-- @author alexdu
SkillMould.SKILL_RELEASE_ZOMURIA_TWO_SIDES =  9

function SkillMould:ctor()
    --技能名称
    self.skillName = nil

    --技能描述
    self.skillDescribe = ""

    --技能描述截取25个字符
    self.skillDescribe25 = nil

    --技能类型(0:普通 1:怒气  2合体技能)
    self.skillQuality = nil

    --技能图标
    self.skillPic = nil

    --技能属性(0:物理 1:法术)
    self.skillProperty =  0

    --技能属性(0:原地 1:移动到承受者前方 2: 移动到承受者所在直线前方)
    self.skillReleasePosition =  0

    --生命影响
    self.healthAffect =  ""

    --buff影响
    self.buffAffect =  ""

    --基础模板
    self.baseMould =  0

    --下一级技能ID
    self.nextLevelSkill =  0

    --合体技能
    self.zoarium_skill =  0

    --触发合体技人员
    self.releaseMould =  ""

    --合体技人员释放技能
    self.releasSkill =  ""

    --是否逐一释放0一起 1逐一
    self.seriatim =  0

    --攻击移动方式(0跑过去，1跳过去，2待定，3......)
    self.attackMoveMode =  0

    self._skillMoulds =  nil

end

local obj = SkillMould:new()