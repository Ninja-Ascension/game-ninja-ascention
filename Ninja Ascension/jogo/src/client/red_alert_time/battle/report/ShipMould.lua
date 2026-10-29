
-- 卡片数据信息
-- @author alexdu
ShipMould = class("ShipMould")
-- 卡片数据信息
-- @author alexdu
ShipMould.CAPTAIN_TYPE_MAIN =  0
-- 卡片数据信息
-- @author alexdu
ShipMould.CAPTAIN_TYPE_GENERAL =  1
-- 卡片数据信息
-- @author alexdu
ShipMould.CAPTAIN_TYPE_ARMY =  2

function ShipMould:ctor()
    --主角名称
    self.captainName =  ""

    --主角阵营
    self.campPreference =  0

    --伙伴类型
    self.captainType =  0

    --伙伴性别
    self.heroGender =  0

    --是否为名将
    self.isGeneral =  0

    --战船名称
    self.shipName =  ""

    --能否在船坞中招募
    self.canRecruit =  0

    --资质
    self.ability =  0

    --统帅
    self.leader =  0

    --武力
    self.strength =  0

    --智慧
    self.wisdom = 0

    --初始生命值
    self.initialPower =  0

    --初始物防
    self.initialIntellect =  0

    --初始攻击值
    self.initialCourage =  0

    --初始法防
    self.initialNimable =  0

    --初始暴击系数
    self.initialCritical =  0

    --初始防暴系数
    self.initialCriticalResist =  0

    --初始闪避系数
    self.initialJink =  0

    --初始命中系数
    self.initialAccuracy =  0

    --初始格挡系数
    self.initialRetain =  0

    --初始破击系数
    self.initialRetainBreak =  0

    --拥有怒气值 0为拥有，1为没有
    self.haveDeadly =  0

    --耐久成长参数
    self.growPower =  0

    --防御成长参数
    self.growIntellect =  0

    --攻击成长参数
    self.growCourage =  0

    --精准成长参数
    self.growNimable =  0

    --普通技能模版
    self.skillMould =  0

    --暴怒技能模板
    self.deadlySkillMould =  0

    --羁绊模板ID
    self.relationshipId =  ""

    --天赋模板ID
    self.talentId =  ""

    --天赋激活需求进阶等级
    self.talentActiviteNeed =  ""

    --技能名称
    self.skillName =  ""

    --技能描述
    self.skillDescribe =  ""

    --所需要船坞等级
    self.boatyardLevel =  0

    --角色颜色品质
    self.shipType =  0

    --角色形象索引
    self.shipPic =  ""

    --价格
    self.price =  0

    --所需荣耀值
    self.needHonor =  0

    --物理攻击特效
    self.physicsAttackEffect =  -1

    --屏幕攻击特效
    self.screenAttackEffect =  -1

    --物理攻击模式 0:原地攻击 1:移动到被攻击者船正前方攻击
    self.physicsAttackMode =  0

    --技能攻击模式 0:原地攻击 1:移动到被攻击者船正前方攻击
    self.skillAttackMode =  0

    --初始等级
    self.initialLevel =  1

    --初始进阶等级
    self.initialRankLevel =  0

    --进阶等级上限
    self.rankGrowUpLimit =  0

    --进阶成长id(进阶成长加成表)
    self.growTargetId =  0

    --进阶需求材料ID
    self.requiredMaterialId =  0

    --英雄星级
    self.shipStar =  1

    --头像图标
    self.headIcon =  0

    --半身像下标
    self.bustIndex =  0

    --全身图下标
    self.allIcon =  0

    --相同英雄标识
    self.baseMould =  0

    --简介文字
    self.introduce =  ""

    --提供初始经验
    self.initialExperienceSupply =  0

    --卖出获得银币
    self.sellGetMoney =  0

    --炼化获得将魂,
    self.refineGetSoul =  0

    --炼化获得魂玉
    self.refineGetJade =  0

    --获得途径
    self.wayOfGain =  ""

    --战士能力标识（0：攻击；1：防御；2：辅助）
    --@return
    self.capacity =  0

    --相同英雄标识2
    self.baseMould2 =  0

    --相同英雄标识优先级(0:优先第一 1:优先第二)
    self.baseMouldPriority =  0

    --培养属性id
    self.cultivatePropertyId =  0

    --合体技能
    self.zoariumSkill =  0

    --合体技发动者
    self.primeMover =  0

    --初始竞技场
    self.arenaInit =  0

    self._shipMoulds =  nil

end

local obj = ShipMould:new()