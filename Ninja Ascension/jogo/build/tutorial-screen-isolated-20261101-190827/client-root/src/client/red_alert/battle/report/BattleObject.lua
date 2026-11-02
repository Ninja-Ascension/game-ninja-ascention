-- 战斗中对象
-- @author xiaofeng
BattleObject = class("BattleObject")

function BattleObject:ctor()
    --攻击标识
    self.battleTag =  0

    --对象坐标
    self.coordinate =  0

    --对象id
    self.id =  0

    --等级
    self.level = 1

    --名称
    self.name =  ""

    --武将名称
    self.captainName = ""

    --战船模板ID
    self.shipMould =  0

    --用户信息
    self.userInfo =  -1

    --动画标示
    self.picIndex =  ""

    --阵营
    self.campPreference =  0

    --性别
    self.gender =  0

    --品质
    self.quality =  0

    --攻速
    self.attackSpeed = 0

    --攻速加成
    self.attackSpeedPercent= 0 

    --攻速减少百分比
    self.attackSpeedLessenercent = 0 

    --统帅
    self.leader =  0

    --武力
    self.strength =  0

    --智慧
    self.wisdom =  0

    --生命
    self.healthPoint =  0

    --最大生命
    self.healthMaxPoint =  0

    -- 当前血量
    self.currentHealthPoint = 0

    --技能槽(怒气点数)
    self.skillPoint =  0

    --合体技能槽(怒气点数)
    self.zomlllSkillPoint =  0

    --攻击力(物攻 法攻);
    self.attack =  0

    --额外攻击力加成
    self.addAttack =  0

    --物理攻击增加
    self.physicalAttackAdd =  0

    --法术攻击增加
    self.skillAttackAdd =  0

    --额外加成攻击%
    self.extraAttack =  0

    --最终伤害加成
    self.finalDamageAddition =  0

    --最终减伤加成
    self.finalSubDamageAddition =  0

    --最终伤害比例
    self.finalDamagePercent =  0

    --最终伤害比例加成
    self.addFinalDamagePercent =  0

    --受到伤害增加
    self.addBruiseDamagePercent =  0

    --物理防御
    self.physicalDefence =  0

    --技能防御
    self.skillDefence =  0

    --增加物理防御
    self.addPhysicalDefence =  0

    --增加技能防御
    self.addSkillDefence =  0

    --暴击
    self.critical =  0

    --暴击倍率
    self.critialMultiple =  1

    --增加暴击倍率
    self.addCritialMultiple =  0

    --减少暴击倍率
    self.subCritialMultiple =  0

    --初始抗暴
    self.criticalResist =  0

    --增加抗暴
    self.addCriticalResist =  0

    --闪避
    self.evasion =  0

    --增加闪避
    self.addEvasion =  0

    --减少闪避
    self.subEvasion =  0

    --命中
    self.accuracy =  0

    --增加命中
    self.addAccuracy =  0

    --减少命中增加
    self.subAccuracy =  0

    --格挡
    self.retain =  0

    --破击
    self.retainBreak =  0

    -- 破击加成
    self.addRetainBreakPercent = 0

    --是否死亡
    self.isDead =  false

    --物理减伤
    self.physicalSubDamage =  0

    --技能减伤
    self.specialSubDatamage =  0

    --治疗加成
    self.cureAdditional =  0

    --被治疗率
    self.byCurePercent =  0

    --被治疗率增加百分比
    self.byCureAdditionalPercent =  0

    --被治疗率减少百分比
    self.byCureLessenPercent =  0

    -- 掉若干血增加若干攻击
    self.addAttackPresent = 0

    -- 对生命低于50%的目标造成伤害增加百分比
    self.addDamagePercent50 = 0
    -- 对生命低于50%的目标受到伤害降低百分比
    self.lessenDamagePercent50 = 0
    -- 对生命低于75%的目标受到伤害增加百分比  
    self.addDamagePercent75 = 0
    --受到暴击伤害减少百分比
    self.byCritLessPercent = 0

    --最终减伤比例
    self.finalLessenDamagePercent =  0

    --续航值
    self.enduranceHPoint =  0

    --治疗值增加
    self.cureAdd =  0

    --被治疗值增加
    self.byCureAdd =  0

    --灼烧伤害增加
    self.firingAdd =  0

    --灼烧伤害免疫
    self.byFiringLes =  0

    --中毒伤害增加
    self.posionAdd =  0

    --中毒伤害免伤
    self.byPosionLes =  0

    --天赋列表
    self.talentMouldList = {}

    --buff影响
    self.buffEffect = {}

    --普通技能模板
    self.commonSkillMould =  nil

    --普通攻击效用
    self.commonBattleSkill = {}

    --怒气技能模板
    self.specialSkillMould =  nil

    --自身怒气技能效用
    self.oneselfBattleSkill = {}

    --合体怒气技能效用
    self.zoariumBattleSkill = {}

    --释放合体技能
    self.releaseSkill = {}

    --反击技能模板
    self.counterSkillMould =  nil

    --反击技能效用
    self.counterBattleSkill = {}

    --天赋光环列表
    self.talentAuraList = {}

    --联动技能列表
    self.talentUniteSkillList = {}

    --天赋免疫列表
    self.talentImmunityList = {}

    --天赋结果列表
    self.talentJudgeResultList = {}

    --掉落卡片id
    self.rewardCard =  0

    --掉落卡片几率
    self.rewardRatio =  0

    --掉落道具
    self.rewardProp =  0

    --掉落道具几率
    self.rewardPropRatio =  0

    --掉落装备
    self.rewardEquipment =  0

    --掉落装备几率
    self.rewardEquipmentRatio =  0

    --是否暴击
    self.isCritical =  false

    --是否闪避
    self.isEvasion =  false

    --是否挡格
    self.isRetain =  false

    --是否禁怒
    self.isSpDisable =  false

    --是否眩晕
    self.isDizzy =  false

    --是否麻痹
    self.isParalysis =  false

    --是否封技
    self.isDisSp =  false

    --是否灼烧
    self.isFiring =  false

    --是否爆裂
    self.isExplode =  false

    --是否禁疗
    self.isBearHP =  false

    --致盲
    self.isBlind =  false

    --残废
    self.isCripple =  false

    --爆裂次数
    self.explodeCount =  0

    --挡格附加值
    self.retainAdditional =  0

    --中毒伤害值
    self.posionDamage =  0

    --灼烧伤害值
    self.firingDamage =  0

    --是否无敌
    self.isNoDamage =  false

    --是否可以反击
    self.canReAttack =  true

    --是否已经出过手
    self.isAction =  false

    --是否必闪
    self.isEvasionSurely =  false

    --造成的伤害
    self.effectDamage =  0

    --技能造成总伤害
    self.totalEffectDamage =  0

    --作用对象数量
    self.coordinateCount =  0

    --怒气点数
    self.totalSkillPoint =  0

    --合击技能模板
    self.zoariumSkillMould =  {}

    --合体技
    self.zoarium =  0

    --合体对象坐标
    self.zoariumSeat =  0

    --进阶等级
    self.advance =  1

    --合体技能释放类型 true:一起 false:依次
    self.seriatim =  false

    --合体技攻击列表
    self.fitBattleObjects = {}

    --合体技模板
    self.releaseSKillMould =  nil

    --发动者
    self.fitBuffer =  nil

    --合击数量
    self.figSkillCount =  0

    --技能效用
    self.fitSkillInflushBuffer =  nil

    --战船标识
    self.capacity =  0

    --相克类型
    self.restrainMoulds =  {}

    --相克属性
    self.restrainObject = nil --//RestrainObject:new()

    --重置合体技状态
    self.hasZoariumSkill =  false
	
	--评分伤害加成
	self.grade_attack = 1

	self.isNeedAddSkillPoint = false

	--战斗小兵对象
	self.forceObjects = {}

    -- 横扫数据添加
    -- 必杀百分比
    self.deadlyStrikePersent = 0

    -- 伤害增加百分比
    self.addDamagePercent = 0

    -- 伤害减少百分比
    self.lessenDamagePercent = 0

    -- 横扫数据添加
    self.deadlyStrikePersent = 0    -- 必杀百分比
    self.criticalResistSupoerAdditionalPercent = 0 -- 强韧百分比
    self.addDamagePercent = 0       -- 伤害增加百分比
    self.lessenDamagePercent = 0    -- 伤害减少百分比
    self.dyAddDamagePercent = 0     -- 受到伤害增加百分比
    self.dyLessenDamagePercent = 0  -- 受到伤害减少百分比
    self.spAdditionalPercent = 0        -- 聚气增加百分比
    self.spLessenPercent = 0    -- 聚气减少百分比
    --/
    --生命加成百分比
    self.powerAdditionalPercent =  0

    --生命减少百分比
    self.powerLessenPercent =  0

    --攻击加成百分比
    self.courageAdditionalPercent =  0
    
    --攻击减少百分比
    self.courageLessenPercent =  0

    --物理防御加成百分比
    self.intellectAdditionalPercent =  0

    --物理防御减少百分比
    self.intellectLessenPercent =  0

    --法防加成百分比
    self.nimableAdditionalPercent =  0

    --法防减少百分比
    self.nimableLessenPercent =  0

    --暴击加成百分比
    self.criticalAdditionalPercent =  0

    --暴击减少百分比
    self.criticalLessenPercent =  0

    --抗暴加成百分比
    self.criticalResistAdditionalPercent =  0

    --抗暴减少百分比
    self.criticalResistLessenPercent =  0

    --闪避加成百分比
    self.evasionAdditionalPercent =  0

    --闪避加成百分比
    self.evasionLessenPercent =  0

    --命中加成百分比
    self.accuracyAdditionalPercent =  0

    --命中减少百分比
    self.accuracyLessenPercent =  0

    --挡格加成百分比
    self.retainAdditionalPercent =  0

    --挡格减少百分比
    self.retainLessenPercent =  0

    --破击加成百分比
    self.retainBreakAdditionalPercent =  0

    --破击减少百分比
    self.retainBreakLessenPercent =  0

    --物理免伤加成百分比
    self.physicalLessenDamagePercent =  0

    --法术免伤加成百分比
    self.skillLessenDamagePercent =  0


    self.sprite_id = 0
    self.talent_mould_index_list = ""
    self.capacity = 0
    self.musics = {}

    -- 加密数据
    self.power = 0
    self.courage = 0
    self.intellect = 0
    self.nimable = 0
    self.base_fighting = 0

    self.key_ship_health = ""
    self.key_gas_gather = ""

	app.load("client.red_alert.battle.report.RestrainObject")
	app.load("client.red_alert.battle.report.BattleSkill")
	
end

function BattleObject:addAttackValue(addAttack)
	self.addAttack = self.addAttack + addAttack
end

function BattleObject:subAttack(addAttack)
	self.addAttack = self.addAttack - addAttack
end

function BattleObject:restoreFitStatus()
	self.fitBuffer = nil
	self.figSkillCount = 0
	self.fitSkillInflushBuffer = nil
end

function BattleObject:pushitSkillInflushBuffer(fitSkillInflushBuffer)
	if (self.fitSkillInflushBuffer == nil) then
		self.fitSkillInflushBuffer = {}
	end
	table.insert(self.fitSkillInflushBuffer, fitSkillInflushBuffer)
end

function BattleObject:addFigSkillCount(figSkillCount)
	self.figSkillCount = self.figSkillCount + figSkillCount
end

function BattleObject:addCriticalResistValue(addCriticalResist)
	self.addCriticalResist = addCriticalResist
end

function BattleObject:addExtraAttack(extraAttack)
	self.extraAttack = self.extraAttack + extraAttack
end

function BattleObject:subExtraAttack(extraAttack)
	self.extraAttack = self.extraAttack - extraAttack
end

function BattleObject:addSkillDefenceValue(addSkillDefence)
	self.addSkillDefence = self.addSkillDefence - addSkillDefence
end

function BattleObject:subSkillDefence(addSkillDefence)
	self.addSkillDefence = self.addSkillDefence - addSkillDefence
end

function BattleObject:addReleaseSkill(releaseSkill)
	self.releaseSkill = releaseSkill
end

function BattleObject:addBruiseDamagePercentValue(addBruiseDamagePercent)
	self.addBruiseDamagePercent = addBruiseDamagePercent
end

function BattleObject:subBruiseDamagePercent(addBruiseDamagePercent)
	self.addBruiseDamagePercent = addBruiseDamagePercent
end

function BattleObject:addTotalEffectDamage(totalEffectDamage)
	self.totalEffectDamage = self.totalEffectDamage + totalEffectDamage
end

function BattleObject:initWithAttackObject(fightObject)
	--攻击标识: 0代表玩家，1代表npc
    self.battleTag = fightObject.battleTag
    -- 是否是援军
    self.isPartner = fightObject.isPartner
    --对象坐标
    self.coordinate = fightObject.coordinate
    --对象id
    self.id = fightObject.id
    --等级
    self.level = fightObject.level
    --名称
    self.name = fightObject.name

    --武将名称
    self.captainName = fightObject.captainName
    
    -- 环境战船模板id
    self.mouldId = fightObject.mouldId

    --战船模板ID
    self.shipMould = fightObject.shipMould
    --用户信息
    self.userInfo = fightObject.userInfo
    --动画标示
    self.picIndex = fightObject.picIndex
    --阵营
    self.campPreference = fightObject.campPreference
    --性别
    self.gender = fightObject.gender
    --品质
    self.quality = fightObject.quality
    --攻速
    self.attackSpeed = fightObject.attackSpeed
    --统帅 ////
    self.leader =  0
    --武力 
    self.strength = fightObject.strength
    --智慧 ////
    self.wisdom = 0
    --生命  ==== 4
    self.healthPoint = fightObject.healthPoint
    --最大生命 // 同生命
    self.healthMaxPoint = fightObject.healthPoint
    -- 当前血量
    self.currentHealthPoint = fightObject.currentHealthPoint
    --生命加成 +++++  ==== 21
    self.addHealthPointPercent = 0
    --技能槽(怒气点数)  ==== 13
    self.skillPoint = fightObject.skillPoint
    --合体技能槽(怒气点数) ////
    self.zomlllSkillPoint =  0
    --攻击力(物攻 法攻)  ==== 1
    self.attack = fightObject.attack
    --额外攻击力加成 ////
    self.addAttack =  0
    --物理攻击增加  ==== 11
    self.physicalAttackAdd = fightObject.physicalAttackAdd
    --法术攻击增加  ==== 11
    self.skillAttackAdd = fightObject.skillAttackAdd
    --额外加成攻击% ////  ==== 18
    self.extraAttack =  0
    --最终伤害加成  ==== 31
    self.finalDamageAddition = fightObject.finalDamageAddition
    --最终减伤加成  ==== 32   
    self.finalSubDamageAddition = fightObject.finalSubDamageAddition
    --加伤百分比 +++++  ==== 29
    self.addDamagePercent = 0
    --减伤百分比 +++++  ==== 30
    self.subDamagePercent = 0
    --最终伤害比例
    self.finalDamagePercent = fightObject.finalDamagePercent
    --最终伤害比例加成 ////
    self.addFinalDamagePercent =  0
    --受到伤害增加 ////
    self.addBruiseDamagePercent =  0
    --物理防御  ==== 2
    self.physicalDefence = fightObject.physicalDefence
    --技能防御  ==== 3
    self.skillDefence =  fightObject.skillDefence
    --增加物理防御 ////   ==== 19
    self.addPhysicalDefence =  0
    --增加技能防御 ////   ==== 20
    self.addSkillDefence =  0
    --攻速 +++++  ==== 14
    self.attackSpeed= fightObject.attackSpeed
    --攻速加成 +++++  ==== 28
    self.attackSpeedPercent= 0      
    --暴击  ==== 5
    self.critical = fightObject.critical
    --暴击倍率
    self.critialMultiple =  fightObject.critialMultiple
    --增加暴击倍率 ////   ==== 15
    self.addCritialMultiple =  0
    --减少暴击倍率 ////   ==== 16
    self.subCritialMultiple =  0
    --初始抗暴  ==== 6
    self.criticalResist =  fightObject.criticalResist
    --增加抗暴 ////   ==== 23
    self.addCriticalResist =  0
    --闪避  ==== 8
    self.evasion =  fightObject.evasion
    --增加闪避 ////
    self.addEvasion =  0
    --减少闪避 ////
    self.subEvasion =  0
    --增加闪避加成 +++++  ==== 25
    self.addEvasionPercent = 0
    --命中  ==== 7
    self.accuracy = fightObject.accuracy
    --增加命中 ////
    self.addAccuracy =  0
    --减少命中增加 ////
    self.subAccuracy =  0
    --增加命中加成 +++++  ==== 24
    self.addAccuracyPercent = 0
    --格挡  ==== 9
    self.retain = fightObject.retain
    --格挡加成 +++++  ==== 26
    self.addRetainPercent = 0
    --破击  ==== 10
    self.retainBreak =  fightObject.retainBreak
    --破击加成 +++++  ==== 27
    self.addRetainBreakPercent = 0
    --是否死亡 ////
    self.isDead =  false
    --物理减伤  ==== 12
    self.physicalSubDamage =  fightObject.physicalLessenDamage
    --技能减伤  ==== 12
    self.specialSubDatamage =  fightObject.skillLessenDamage
    --治疗加成   ==== 17
    self.cureAdditional =  fightObject.cureOdds
    --被治疗率
    self.byCurePercent =  fightObject.byCureOdds
    --被治疗率增加百分比
    self.byCureAdditionalPercent =  fightObject.byCureAdditionalPercent
    --被治疗率减少百分比
    self.byCureLessenPercent = fightObject.byCureLessenPercent
    --最终减伤比例
    self.finalLessenDamagePercent =  fightObject.finalLessenDamagePercent
    --续航值 ////
    self.enduranceHPoint =  0
    --治疗值增加
    self.cureAdd = fightObject.cureAdd
    --被治疗值增加
    self.byCureAdd = fightObject.byCureAdd
    --灼烧伤害增加 
    self.firingAdd = fightObject.firingAdd
    --灼烧伤害免疫 
    self.byFiringLes = fightObject.byFiringLes
    --中毒伤害增加
    self.posionAdd = fightObject.posionAdd
    --中毒伤害免伤
    self.byPosionLes = fightObject.byPosionLes
    -- 掉若干血增加若干攻击
    self.addAttackPresent = fightObject.addAttackPresent
    -- 对生命低于50%的目标造成伤害增加百分比
    self.addDamagePercent50 = fightObject.addDamagePercent50
    -- 对生命低于50%的目标受到伤害降低百分比
    self.lessenDamagePercent50 = fightObject.lessenDamagePercent50
    -- 对生命低于75%的目标受到伤害增加百分比  
    self.addDamagePercent75 = fightObject.addDamagePercent75
    --受到暴击伤害减少百分比
    self.byCritLessPercent = fightObject.byCritLessPercent
    --天赋列表
    self.talentMouldList = fightObject.talentMouldList
    --buff影响 ////
    self.buffEffect = {}
    --普通技能模板 //
    self.commonSkillMould =  fightObject.commonSkill
    --普通攻击效用 ////
    self.commonBattleSkill = {}
    --怒气技能模板 //
    -- self.specialSkillMould =  fightObject.specialSkill
    --自身怒气技能效用 ////
    self.oneselfBattleSkill = {}
    --合体怒气技能效用 ////
    self.zoariumBattleSkill = {}
    --释放合体技能 ////
    self.releaseSkill = {}
    --反击技能模板 ////
    self.counterSkillMould =  nil
    --反击技能效用 ////
    self.counterBattleSkill = {}
    --天赋光环列表 ////
    self.talentAuraList = {}
    --联动技能列表 ////
    self.talentUniteSkillList = {}
    --天赋免疫列表 ////
    self.talentImmunityList = {}
    --天赋结果列表 ////
    self.talentJudgeResultList = {}
    --掉落卡片id
    self.rewardCard = fightObject.rewardCard
    --掉落卡片几率
    self.rewardRatio = fightObject.rewardRatio
    --掉落道具
    self.rewardProp = fightObject.rewardPro
    --掉落道具几率
    self.rewardPropRatio = fightObject.rewardPropRatio
    --掉落装备
    self.rewardEquipment = fightObject.rewardEquipment
    --掉落装备几率
    self.rewardEquipmentRatio = fightObject.rewardEquipmentRatio
    --是否暴击 ////
    self.isCritical =  false
    --是否闪避 ////
    self.isEvasion =  false
    --是否挡格 //// 
    self.isRetain =  false
    --是否禁怒 ////
    self.isSpDisable =  false
    --是否眩晕 ////
    self.isDizzy =  false
    --是否麻痹 ////
    self.isParalysis =  false 
    --是否封技 ////
    self.isDisSp =  false
    --是否灼烧 ////
    self.isFiring =  false
    --是否爆裂 ////
    self.isExplode =  false
    --是否禁疗 ////
    self.isBearHP =  false
    --致盲 ////
    self.isBlind =  false
    --残废 ////
    self.isCripple =  false
    --爆裂次数 ////
    self.explodeCount =  0
    --挡格附加值 ////
    self.retainAdditional =  0
    --中毒伤害值 ////
    self.posionDamage =  0
    --灼烧伤害值 ////
    self.firingDamage =  0
    --是否无敌 ////
    self.isNoDamage =  false
    --是否可以反击 ////
    self.canReAttack =  true
    --是否已经出过手 ////
    self.isAction =  false
    --是否必闪 ////
    self.isEvasionSurely =  false
    --造成的伤害 ////
    self.effectDamage =  0
    --技能造成总伤害 ////
    self.totalEffectDamage =  0
    --作用对象数量 ////
    self.coordinateCount =  0
    --怒气点数 ////
    self.totalSkillPoint =  0
    --合击技能模板 ////
    self.zoariumSkillMould =  {}
    --合体技
    self.zoarium = fightObject.zoarium
    --合体对象坐标 ////
    self.zoariumSeat =  0
    --进阶等级
    self.advance = fightObject.advance
    --合体技能释放类型 true:一起 false:依次 ////  commonskill 和specialskill中
    self.seriatim =  false
    --合体技攻击列表 ////
    self.fitBattleObjects = {}
    --合体技模板 ////
    self.releaseSKillMould =  nil
    --发动者 ////
    self.fitBuffer =  nil
    --合击数量 ////
    self.figSkillCount =  0
    --技能效用 ////
    self.fitSkillInflushBuffer =  nil
    --战船标识
    self.capacity =  fightObject.capacity
    --相克类型
    self.restrainMoulds =  {}
    --相克属性 //// fightObject.restrainMoulds
    self.restrainObject =  RestrainObject:new()
    --重置合体技状态 ////
    self.hasZoariumSkill =  false
	--评分伤害加成 ////
	self.grade_attack = 1
    --是否需要增加技能点 ////
	self.isNeedAddSkillPoint = false
	--战斗小兵对象 ////
	self.forceObjects = {}

    -- 横扫数据添加
    -- 必杀百分比
    self.deadlyStrikePersent = fightObject.deadlyStrikePersent
    -- 强韧百分比
    self.criticalResistSupoerAdditionalPercent = fightObject.criticalResistSupoerAdditionalPercent
    -- 疗效百分比
    self.curePercent = fightObject.curePercent
    -- 加伤百分比
    self.finalDamagePercent = fightObject.finalDamagePercent
    -- 减伤百分比
    self.finalLessenDamagePercent = fightObject.finalLessenDamagePercent
    -- 伤害增加百分比
    self.addDamagePercent = fightObject.addDamagePercent
    -- 伤害减少百分比
    self.lessenDamagePercent = fightObject.lessenDamagePercent
    -- 受到伤害增加百分比
    self.dyAddDamagePercent = fightObject.dyAddDamagePercent
    -- 受到伤害减少百分比
    self.dyLessenDamagePercent = fightObject.dyLessenDamagePercent
    -- 聚气增加百分比
    self.spAdditionalPercent = fightObject.spAdditionalPercent
    -- 聚气减少百分比
    self.spLessenPercent = fightObject.spLessenPercent
    --/
    --生命加成百分比
    self.powerAdditionalPercent =  fightObject.powerAdditionalPercent

    --生命减少百分比
    self.powerLessenPercent =  fightObject.powerLessenPercent

    --攻击加成百分比
    self.courageAdditionalPercent =  fightObject.courageAdditionalPercent

    --攻击减少百分比
    self.courageLessenPercent =  fightObject.courageLessenPercent

    --物理防御加成百分比
    self.intellectAdditionalPercent =  fightObject.intellectAdditionalPercent

    --物理防御减少百分比
    self.intellectLessenPercent =  fightObject.intellectLessenPercent

    --法防加成百分比
    self.nimableAdditionalPercent =  fightObject.nimableAdditionalPercent

    --法防减少百分比
    self.nimableLessenPercent =  fightObject.nimableLessenPercent

    --暴击加成百分比
    self.criticalAdditionalPercent =  fightObject.criticalAdditionalPercent

    --暴击减少百分比
    self.criticalLessenPercent =  fightObject.criticalLessenPercent

    --抗暴加成百分比
    self.criticalResistAdditionalPercent =  fightObject.criticalResistAdditionalPercent

    --抗暴减少百分比
    self.criticalResistLessenPercent =  fightObject.criticalResistLessenPercent

    --闪避加成百分比
    self.evasionAdditionalPercent =  fightObject.evasionAdditionalPercent

    --闪避加成百分比
    self.evasionLessenPercent =  fightObject.evasionLessenPercent

    --命中加成百分比
    self.accuracyAdditionalPercent =  fightObject.accuracyAdditionalPercent

    --命中减少百分比
    self.accuracyLessenPercent =  fightObject.accuracyLessenPercent

    --挡格加成百分比
    self.retainAdditionalPercent =  fightObject.retainAdditionalPercent

    --挡格减少百分比
    self.retainLessenPercent =  fightObject.retainLessenPercent

    --破击加成百分比
    self.retainBreakAdditionalPercent =  fightObject.retainBreakAdditionalPercent

    --破击减少百分比
    self.retainBreakLessenPercent =  fightObject.retainBreakLessenPercent

    --物理免伤加成百分比
    self.physicalLessenDamagePercent =  fightObject.physicalLessenDamagePercent

    --法术免伤加成百分比
    self.skillLessenDamagePercent =  fightObject.skillLessenDamagePercent

    -- 普通技能（针对敌方读取environment_ship）
    self.common_skill_mould = fightObject.common_skill_mould
    
    -- 怒气技能（针对敌方读取environment_ship）
    self.special_skill_mould = fightObject.special_skill_mould


    self.sprite_id = fightObject.sprite_id
    self.talent_mould_index_list = fightObject.talent_mould_index_list
    self.capacity = fightObject.capacity
    self.musics = fightObject.musics


    self.power = fightObject.power
    self.courage = fightObject.courage
    self.intellect = fightObject.intellect
    self.nimable = fightObject.nimable
    self.base_fighting = fightObject.base_fighting

    self.key_ship_health = fightObject.key_ship_health
    self.key_gas_gather = fightObject.key_gas_gather

	-- if fightObject.zoarium ~= nil then
	-- 	self.zoarium = fightObject.zoarium
	-- else
	-- 	self.zoarium = 0
	-- end
	-- self.zoariumSeat = fightObject.zoariumCoordinate
	-- self.counterSkillMould = ConfigDB.load("skill_mould", 1)
	-- self.advance = fightObject.advance
	
	-- self.capacity = fightObject.capacity
	-- self.restrainMoulds = fightObject.restrainMoulds
	-- self.zomlllSkillPoint = fightObject.zoariumSkillPoint

 --    -- 合体技能模块
	-- if(self.zoarium > 0) then
	-- 	local skillMould = ConfigDB.load("skill_mould", fightObject.zoarium)
	-- 	self.zoariumSkillMould = skillMould
	-- end

 --    -- 天赋模块
	-- for key, talentMould in pairs(self.talentMouldList) do
	-- 	talentMould.talentBattleSkill = {}

 --        -- 免疫列表
	-- 	if(talentMould.influenceImmunity ~= "-1") then
	-- 		local immunityArray = zstring.split(talentMould.influenceImmunity, "|")
	-- 		for i, val in pairs(immunityArray) do
	-- 			local talentImmunity = TalentImmunity:new()
	-- 			local immunityArrayParams = zstring.split(immunityArray[i], IniUtil.comma)
	-- 			local immunityType = tonumber(immunityArrayParams[1]) -- tonumber(zstring.split(immunityArray[i], IniUtil.comma)[1])
	-- 			if(immunityType == TalentConstant.IMMUNITY_TYPE_STATUS) then					
	-- 				talentImmunity.immunityStatus=tonumber(immunityArrayParams[2]) -- tonumber(immunityArray[i].split(IniUtil.comma)[2])
	-- 			end
	-- 			if(immunityType == TalentConstant.IMMUNITY_TYPE_TALENT) then
	-- 				talentImmunity.immunityTalent=tonumber(immunityArrayParams[2]) -- tonumber(immunityArray[i].split(IniUtil.comma)[2])
	-- 			end
	-- 			self:pushTalentImmunityList(talentImmunity)
	-- 		end
	-- 	end

 --        -- 战斗中天赋判断模块 逗号隔开
 --        -- if (talentMould.influenceJudgeOpportunity ~= "-1") then
	-- 	local judgeResultArray = zstring.split(talentMould.influenceJudgeResult, IniUtil.comma)
	-- 	if(table.nums(judgeResultArray) > 1) then
	-- 		local resultValue = tonumber(judgeResultArray[2])
	-- 		if(tonumber(judgeResultArray[1]) == 7) then
 --                -- 技能id 如果 第一个参数 == 7 则调用技能
	-- 			local _skillMould = ConfigDB.load("skill_mould", resultValue)
 --                -- 暂时只有被击效果同时格挡  进行反击
	-- 			if(talentMould.influenceJudgeType2 == TalentConstant.JUDGE_TYPE2_SELF_RETAIN and
	-- 				talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK) then
	-- 				self.counterSkillMould = _skillMould
	-- 			else
	-- 				local skillArray = zstring.split(_skillMould.healthAffect, "|")
	-- 				for i, val in pairs(skillArray) do
	-- 					local skillInfluence = dms.element(dms["skill_influence"], skillArray[i])
	-- 					local battleSkill = BattleSkill:new()
	-- 					battleSkill.attackerTag = self.battleTag
	-- 					battleSkill.attacterCoordinate = self.coordinate
	-- 					battleSkill.skillMould = _skillMould
	-- 					battleSkill.skillInfluence = skillInfluence
	-- 					if(self.battleTag == 0) then
	-- 						if (skillInfluence.influenceGroup == 0) then
	-- 							battleSkill.byAttackerTag = 0
	-- 						else
	-- 							battleSkill.byAttackerTag = 1
	-- 						end							
	-- 					else
	-- 						if (skillInfluence.influenceGroup == 0) then
	-- 							battleSkill.byAttackerTag = 1
	-- 						else
	-- 							battleSkill.byAttackerTag = 0
	-- 						end	
	-- 					end
	-- 					battleSkill.effectType = skillInfluence.skillCategory
	-- 					battleSkill.effectRound = skillInfluence.influenceDuration
	-- 					table.insert(talentMould.talentBattleSkill, battleSkill)
	-- 				end					
	-- 			end
	-- 		end
 --        end
	-- 	-- end
	-- end
	-- ----_crint ("self.counterSkillMould: " .. self.counterSkillMould)
	-- --os.exit()
	-- -- if (fightObject.commonSkill.healthAffect == nil) then
	-- 	-- --_crint ("" .. fightObject.commonSkill.id)
	-- -- end
    -- 普通技能 SkillMould.healthAffect 生命影响数值
	local commonSkillArray = zstring.split(string.gsub(fightObject.commonSkill.healthAffect, "|", IniUtil.comma), IniUtil.comma)
    -- 怒气技能
	-- local specialSkillArray = zstring.split(string.gsub(fightObject.specialSkill.healthAffect, "|", IniUtil.comma), IniUtil.comma)
    -- 反击技能
	-- local counterSkillArray = zstring.split(string.gsub(self.counterSkillMould.healthAffect, "|", IniUtil.comma), IniUtil.comma)

	for i, v in pairs(commonSkillArray) do
		local skillInfluence = ConfigDB.load("skill_influence", commonSkillArray[i])
		local battleSkill = BattleSkill:new()
		battleSkill.attackerTag = self.battleTag
		battleSkill.attacterCoordinate = self.coordinate
		battleSkill.skillMould = fightObject.commonSkill
		battleSkill.skillInfluence = skillInfluence
		if(self.battleTag == 0) then
			if (skillInfluence.influenceGroup == 0) then
				battleSkill.byAttackerTag = 0
			else
				battleSkill.byAttackerTag = 1
			end				
		else
			if (skillInfluence.influenceGroup == 0) then
				battleSkill.byAttackerTag = 1
			else
				battleSkill.byAttackerTag = 0
			end	
		end
		battleSkill.effectType = skillInfluence.skillCategory
		battleSkill.effectRound = skillInfluence.influenceDuration
		table.insert(self.commonBattleSkill, battleSkill)
	end

	-- for i, v in pairs(specialSkillArray) do
	-- 	local skillInfluence = ConfigDB.load("skill_influence", specialSkillArray[i])
	-- 	local battleSkill = BattleSkill:new()
	-- 	battleSkill.attackerTag = self.battleTag
	-- 	battleSkill.attacterCoordinate = self.coordinate
	-- 	battleSkill.skillMould = fightObject.specialSkill
	-- 	battleSkill.skillInfluence = skillInfluence
	-- 	if(self.battleTag == 0) then				
	-- 		if (skillInfluence.influenceGroup == 0) then
	-- 			battleSkill.byAttackerTag = 0
	-- 		else
	-- 			battleSkill.byAttackerTag = 1
	-- 		end
	-- 	else
	-- 		if (skillInfluence.influenceGroup == 0) then
	-- 			battleSkill.byAttackerTag = 1
	-- 		else
	-- 			battleSkill.byAttackerTag = 0
	-- 		end	
	-- 	end
	-- 	battleSkill.effectType = skillInfluence.skillCategory
	-- 	battleSkill.effectRound = skillInfluence.influenceDuration
	-- 	table.insert(self.oneselfBattleSkill, battleSkill)
	-- end

	-- for i, v in pairs(counterSkillArray) do
	-- 	local skillInfluence = ConfigDB.load("skill_influence", counterSkillArray[i])
	-- 	local battleSkill = BattleSkill:new()
	-- 	battleSkill.attackerTag = self.battleTag
	-- 	battleSkill.attacterCoordinate = self.coordinate
	-- 	battleSkill.skillMould = self.counterSkillMould
	-- 	battleSkill.skillInfluence = skillInfluence
	-- 	if(self.battleTag == 0)then
	-- 		if (skillInfluence.influenceGroup == 0) then
	-- 			battleSkill.byAttackerTag = 0
	-- 		else
	-- 			battleSkill.byAttackerTag = 1
	-- 		end
	-- 	else
	-- 		if (skillInfluence.influenceGroup == 0) then
	-- 			battleSkill.byAttackerTag = 1
	-- 		else
	-- 			battleSkill.byAttackerTag = 0
	-- 		end
	-- 	end
	-- 	battleSkill.effectType=skillInfluence.skillCategory
	-- 	battleSkill.effectRound=skillInfluence.influenceDuration
	-- 	table.insert(self.counterBattleSkill, battleSkill)
	-- end
    -- print("**************************")	
    -- print("hp-------------------------",self.healthPoint)
    -- print("attack---------------------",self.attack)
    -- print("defence1--------------------",self.physicalDefence)
    -- print("defence2--------------------",self.skillDefence)

	-- 小兵数据
	local forceArray = fightObject.forceArray
	for k,fceObj in pairs(forceArray) do
		local forceObject = BattleObject:new()
		forceObject:initWithAttackObject(forceArray[k])
		table.insert(self.forceObjects,forceObject)
        -- table.insert(self.forceObjects,forceArray[k])
	end
end


function BattleObject:checkBattleObject(attackObjects)
	if(self.zoariumSkillMould ~= nil and self.zoariumSkillMould.id ~= nil) then
		local zomariumShipMoulds = zstring.split(self.zoariumSkillMould.releaseMould, ",")
		--检查是否能够是否合体技
		local release = self:checkCanRelease(attackObjects, zomariumShipMoulds)
		if(false == release)then
			return
		end
		if(self.zoariumSkillMould.releasSkill == nil or  
			self.zoariumSkillMould.releasSkill == "" or  
			self.zoariumSkillMould.releasSkill == "-1")then
			return
		end
		
		local seriatim = self.zoariumSkillMould.seriatim == 0  --是否逐一释放
		
		local skill = zstring.split(self.zoariumSkillMould.releasSkill, "|")  --合体技能效用1,2|3,4|5,6
		
		--for (int i = 0; i < zomariumShipMoulds.length; i++) {
		-- for i = 1, table.maxn(zomariumShipMoulds) do
		local maxI = 0
		for i, v in pairs(zomariumShipMoulds) do
			local tempBattleObject = self:findByShipMould(attackObjects, tonumber(zomariumShipMoulds[i]))
			tempBattleObject.seriatim = seriatim
			tempBattleObject.releaseSKillMould = self.zoariumSkillMould
			if(#skill > maxI) then
				local skillInfushs = zstring.split(skill[i], ",")
				local zomaruimSkills = {}
				--for (int j = 0; j < skillInfushs.length; j++) {
				for j = 1, table.maxn(skillInfushs)  do
					if(skillInfushs[j] == "-1") then
						--continue;
					else
						local skillInfluence = ConfigDB.load("skill_influence", skillInfushs[j])
						local battleSkill = BattleSkill:new()
						battleSkill.attackerTag = self.battleTag
						battleSkill.attacterCoordinate  = self.coordinate
						battleSkill.skillMould = self.counterSkillMould
						battleSkill.skillInfluence = skillInfluence
						if(self.battleTag == 0) then
							if (skillInfluence.influenceGroup == 0) then
								battleSkill.byAttackerTag = 0
							else
								battleSkill.byAttackerTag = 1
							end
						else
							if (skillInfluence.influenceGroup == 0) then
								battleSkill.byAttackerTag = 1
							else
								battleSkill.byAttackerTag = 0
							end							
						end
						battleSkill.effectType = skillInfluence.skillCategory
						battleSkill.effectRound = skillInfluence.influenceDuration
						table.insert(zomaruimSkills, battleSkill)
					end
				end
				tempBattleObject.releaseSkill = zomaruimSkills
				table.insert(self.fitBattleObjects, tempBattleObject)
			end
			maxI = maxI + 1
		end
	end
end

function BattleObject:checkCanRelease(attackObjects, zomariumShipMoulds)
	local release = false
	local currentRelease = false
	local shipMould = ConfigDB.load("ship_mould", self.shipMould)
	--for (int i = 0; i < zomariumShipMoulds.length; i++) {
	-- for i = 1, #zomariumShipMoulds do
	for i, v in pairs(zomariumShipMoulds) do
		local smou = tonumber(zomariumShipMoulds[i])
		if(shipMould.primeMover == smou) then
			currentRelease = true
			break
		end
	end
	local needCount = 0
	if (currentRelease) then
		--for (int i = 0; i < zomariumShipMoulds.length; i++) {
		-- for i = 1, #zomariumShipMoulds do
		for i, v in pairs(zomariumShipMoulds) do
			local smou = tonumber(zomariumShipMoulds[i])
			--for (int j = 0; j < attackObjects.length; j++) {
			-- for j= 1, #attackObjects do
			for j, v in pairs(attackObjects) do
				local battleObject = attackObjects[j]
				if(battleObject == nil or battleObject.isDead) then
					--continue
				else
					if(battleObject.shipMould == smou) then
						needCount = needCount + 1
						break
					end
				end
			end
		end
	end
	if(needCount == #zomariumShipMoulds) then
		release = true
	end
	return release
end

function BattleObject:checkState(attackObjects)
	-- print("合体人员：",self.isDead,self.skillPoint,self.zoariumSkillMould,self.zoariumSkillMould.skillQuality,self.zoariumSkillMould.releaseMould)
	if(self.isDead) then
		return false
	end
	if(self.zomlllSkillPoint < 4) then
		return false
	end
	if(self.zoariumSkillMould == nil) then
		return false
	end
	if(self.zoariumSkillMould.skillQuality ~= 2) then
		return false
	end
	if(self.zoariumSkillMould == nil 
			or self.zoariumSkillMould.releaseMould == nil 
			or self.zoariumSkillMould.releaseMould== "-1"
			or self.zoariumSkillMould.releaseMould == "")then
		return false
	end
	local zomariumShipMoulds = zstring.split(self.zoariumSkillMould.releaseMould, ",")
	-- print("合体人员：",zomariumShipMoulds)
	return self:checkCanRelease(attackObjects, zomariumShipMoulds)
end

function BattleObject:findByShipMould(attackObjects, shipMould)
	for _, attackObject in pairs(attackObjects) do
			if (attackObject ~= nil) then
				if(tonumber(attackObject.shipMould) == tonumber(shipMould)) then
					return attackObject
				end
			end
	end
	return nil
end

function BattleObject:subExplodeCount(explodeCount)
	self.explodeCount = self.explodeCount - explodeCount
end

function BattleObject:pushTalentJudgeResultList(talentJudgeResult)
	table.insert(self.talentJudgeResultList, talentJudgeResult)
end

function BattleObject:clearTalentJudgeResultList()
	self.talentJudgeResultList = {}
end

function BattleObject:getTalentJudgeResultByResultType(resultType)
	local talentJudgeResultList = {}
	--for (TalentJudgeResult talentJudgeResult : self.talentJudgeResultList) {
	for _, talentJudgeResult in pairs(self.talentJudgeResultList) do
		if(resultType == talentJudgeResult.resultType) then
			table.insert(talentJudgeResultList, talentJudgeResult)
		end
	end
	return talentJudgeResultList
end

function BattleObject:pushTalentImmunityList(talentImmunity)
	--for (Iterator<TalentImmunity> iter = self.talentImmunityList.iterator(); iter.hasNext();) {
	--for _, _talentImmunity in pairs(self.talentImmunityList) do
	-- for i = 1, #self.talentImmunityList do
	for i, v in pairs(self.talentImmunityList) do
		--TalentImmunity _talentImmunity = iter.next()
		local _talentImmunity = self.talentImmunityList[i]
		if(_talentImmunity.immunityStatus == talentImmunity.immunityStatus and _talentImmunity.immunityTalent == talentImmunity.immunityTalent) then
			--iter.remove()
			--return
			self.talentImmunityList[i] = nil
		end
	end
	local tmpImmunityList = self.talentImmunityList
	self.talentImmunityList = {}
	for _, tmpImmunity in pairs(tmpImmunityList) do
		if (tmpImmunity ~= nil) then
			table.insert(self.talentImmunityList, tmpImmunity)
		end
	end
	tmpImmunityList = nil
	table.insert(self.talentImmunityList, talentImmunity)
end

function BattleObject:pushTalentAuraList(talentAura)
	table.insert(self.talentAuraList, talentAura)
end

function BattleObject:setEvasionSurely(isEvasionSurely)
	self.isEvasionSurely = isEvasionSurely
end

function BattleObject:isCanReAttack()
	return self.canReAttack
end

function BattleObject:isDead()
	return self.isDead
end

function BattleObject:setDead(isDead)
	self.isDead = isDead
end

function BattleObject:addHealthPoint(healthPoint)
	self.healthPoint = self.healthPoint + healthPoint
end

function BattleObject:addHealthMaxPoint(healthMaxPoint)
	--_crint ("Calling BattleObject:addHealthMaxPoint(healthMaxPoint)")
	self.healthMaxPoint = self.healthMaxPoint + healthMaxPoint
end

function BattleObject:subHealthPoint(healthPoint)
	self.healthPoint = self.healthPoint - healthPoint
end

function BattleObject:addSkillPoint(skillPoint)
	self.skillPoint = tonumber(self.skillPoint) + tonumber(skillPoint)
end

function BattleObject:addZomSkillPoint(skillPoint)
	self.zomlllSkillPoint = tonumber(self.zomlllSkillPoint) + tonumber(skillPoint)
end

function BattleObject:subSkillPoint(skillPoint)
	self.skillPoint = tonumber(self.skillPoint) - tonumber(skillPoint)
end

function BattleObject:subZomSkillPoint(skillPoint)
	self.zomlllSkillPoint = 0--tonumber(self.zomlllSkillPoint) - tonumber(skillPoint)
end

function BattleObject:addFinalDamageAddition(finalDamageAddition)
	self.finalDamageAddition = self.finalDamageAddition + finalDamageAddition
end

function BattleObject:subFinalDamageAddition(finalDamageAddition)
	self.finalDamageAddition = finalDamageAddition
end

function BattleObject:pushBuffEffect(fightBuff)
	table.insert(self.buffEffect, fightBuff)
end


function BattleObject:addPhysicalDefenceValue(addPhysicalDefence)
	self.addPhysicalDefence = self.addPhysicalDefence + addPhysicalDefence
end

function BattleObject:subPhysicalDefence(addPhysicalDefence)
	self.addPhysicalDefence = self.addPhysicalDefence - addPhysicalDefence
end

function BattleObject:addSubCritialMultiple(subCritialMultiple)
	self.subCritialMultiple = self.subCritialMultiple -subCritialMultiple
end

function BattleObject:addEvasionValue(addEvasion)
	self.addEvasion = self.addEvasion + addEvasion
end

function BattleObject:restoreAttackState()
	self.isCritical = false
	self.isEvasion = false
	self.isRetain = false
	self.critialMultiple = 1
end

function BattleObject:restoreBuffState()
	self.addAttack = 0
	self.addEvasion = 0
	self.addAccuracy = 0
	self.addCritialMultiple = 0
	self.addFinalDamagePercent = 0
	self.addBruiseDamagePercent = 0
	self.addPhysicalDefence = 0
	self.addSkillDefence = 0
end

function BattleObject:processUserBuffEffect(userInfo, fightModule, resultBuffer)
	if(#self.buffEffect == 0 or self.isDead) then
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
	else
		local buffBuffer = {}
		local buffCount = 0
		local deadState = 0
		for idx,  fightBuff in pairs(self.buffEffect)  do				
			fightBuff:process(self, buffBuffer)
			if(fightBuff.countBuff > 0) then
				buffCount = buffCount + 1
			end
			if(deadState == 0) then
				deadState = fightBuff.deadState
			end
			if(fightBuff.effectRound <= 0) then
				fightBuff:restoreEffect(self)
				self.buffEffect[idx] = nil
				--continue
			else
				if(deadState > 0) then
					fightBuff:restoreEffect(self)
					self.buffEffect[idx] = nil
					break
				end
			end
		end
		if(#buffBuffer > 0) then
			table.insert(resultBuffer, buffCount)
			IniUtil.concatTable(resultBuffer, buffBuffer)
			table.insert(resultBuffer,IniUtil.compart)
			table.insert(resultBuffer,deadState)
			table.insert(resultBuffer,IniUtil.compart)
		else
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
		end
		if(self.isDead) then
			if(self.battleTag == 0) then
				if(nil ~= fightModule.attackObjects[self.coordinate]) then				
					fightModule.attackCount = fightModule.attackCount - 1
					fightModule.attackObjects[self.coordinate] = nil
				end
			else
				if(nil ~= fightModule.byAttackObjects[self.coordinate]) then
					----_crint ("处理BUFF 死亡	byAttackCount--")
					fightModule.byAttackCount = fightModule.byAttackCount - 1
					fightModule.byAttackObjects[self.coordinate] = nil
				end
			end
			TalentSkill.processSelfDead(userInfo, fightModule, nil, self)
			local rewardType = 0
			local rewardCount = 0

			-- //计算卡片掉落
			-- if(self.rewardRatio ~= nil and self.rewardRatio > 0) then
			-- 	if(math.random(1, 100) <= self.rewardCard) then
			-- 		local rewardCard =  fightModule.rewardCard[self.rewardCard]
			-- 		if(rewardCard ~= nil) then
			-- 			fightModule.rewardCard[self.rewardCard] = {self.rewardCard,rewardCard + 1}
			-- 		else
			-- 			fightModule.rewardCard[self.rewardCard] = {self.rewardCard,1}
			-- 		end
			-- 		rewardCount = 1;
			-- 		rewardType = 1;
			-- 	end
			-- end
			-- 	-- //计算道具掉落
			-- if(self.rewardPropRatio ~= nil and self.rewardPropRatio > 0) then
			-- 	if(math.random(1, 100) <= self.rewardPropRatio) then
			-- 		local rewardProp =  fightModule.rewardProp[self.rewardProp]
			-- 		if(rewardProp ~= nil) then
			-- 			fightModule.rewardProp[self.rewardProp] = {self.rewardProp,rewardProp + 1}
			-- 		else
			-- 			fightModule.rewardProp[self.rewardProp] = {self.rewardProp,1}
			-- 		end
			-- 		rewardCount = 1;
			-- 		rewardType = 1;
			-- 	end
			-- end
			-- -- //计算装备掉落
			-- if(self.rewardEquipmentRatio ~= nil and self.rewardEquipmentRatio > 0) then
			-- 	if(math.random(1, 100) <= self.rewardEquipment) then
			-- 		local rewardEquipment =  fightModule.rewardEquipment[self.rewardEquipment]
			-- 		if(rewardEquipment ~= nil) then
			-- 			fightModule.rewardEquipment[self.rewardEquipment] = {self.rewardEquipment,rewardEquipment + 1}
			-- 		else
			-- 			fightModule.rewardEquipment[self.rewardEquipment] = {self.rewardEquipment,1}
			-- 		end
			-- 		rewardCount = 1;
			-- 		rewardType = 1;
			-- 	end
			-- end

			table.insert(resultBuffer,0)
			table.insert(resultBuffer,IniUtil.compart)
			table.insert(resultBuffer,0)
			table.insert(resultBuffer,IniUtil.compart)
		end
	end
end

function BattleObject:processBuffEffect(fightModule, resultBuffer)
	if(#self.buffEffect == 0 or self.isDead) then
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
	else
		local buffBuffer = {}
		local buffCount = -1
		local deadState = 0
		for idx, fightBuff in pairs(self.buffEffect) do
			fightBuff:process(self, buffBuffer)
			if(fightBuff.effectValue > 0) then
				buffCount = buffCount + 1
 			end
			if(deadState == 0) then
				deadState = fightBuff.deadState
			end
			if(fightBuff.effectRound <= 0) then
				fightBuff.restoreEffect(self)
				self.buffEffect[idx] = nil
				--continue
			else
				if(deadState > 0) then
					fightBuff.restoreEffect(self)
					self.buffEffect[idx] = nil
					break
				end
			end
		end
		
		if(#buffBuffer > 0) then
			table.insert(resultBuffer, buffCount)
			IniUtil.concatTable(resultBuffer, buffBuffer)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, deadState)
			table.insert(resultBuffer, IniUtil.compart)
		else
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
		end
		if(self.isDead) then
			if(self.battleTag == 0) then
				if(nil ~= fightModule.attackObjects[self.coordinate]) then					
					fightModule.attackCount = fightModule.attackCount - 1
					fightModule.attackObjects[self.coordinate] = nil
				end
			else
				if(nil ~= fightModule.byAttackObjects[self.coordinate]) then
					----_crint ("处理BUFF 死亡	byAttackCount--")
					fightModule.byAttackCount = fightModule.byAttackCount - 1
					fightModule.byAttackObjects[self.coordinate] = nil
				end
			end
			local rewardCount = 0
			table.insert(resultBuffer, rewardCount)
			table.insert(resultBuffer, IniUtil.compart)
		end
	end
end

function BattleObject:pushTalentUniteSkillList(talentUniteSkill)
	table.insert(self.talentUniteSkillList, talentUniteSkill)
end

--获取固定闪避值
function BattleObject:getEvasion()
    return self.evasion
end

--获取百分比闪避值
function BattleObject:getEvasionPercent()
    return self.addEvasionPercent
end

--获取固定命中值
function BattleObject:getAccuracy()
    return self.accuracy
end

--获取百分比命中值
function BattleObject:getAccuracyPercent()
    return self.addAccuracyPercent
end



function BattleObject:clear()
    --攻击标识
    self.battleTag = nil

    --对象坐标
    self.coordinate = nil

    --对象id
    self.id = nil

    --等级
    self.level = nil

    --名称
    self.name = nil

    --武将名称
    self.captainName = nil

    --战船模板ID
    self.shipMould = nil

    --用户信息
    self.userInfo = nil

    --动画标示
    self.picIndex = nil

    --阵营
    self.campPreference = nil

    --性别
    self.gender = nil

    --品质
    self.quality = nil

    --攻速
    self.attackSpeed = nil

    --攻速加成
    self.attackSpeedPercent= nil

    --攻速减少百分比
    self.attackSpeedLessenercent = nil

    --统帅
    self.leader = nil

    --武力
    self.strength = nil

    --智慧
    self.wisdom = nil

    --生命
    self.healthPoint = nil

    --最大生命
    self.healthMaxPoint = nil

    -- 当前血量
    self.currentHealthPoint = nil

    --技能槽(怒气点数)
    self.skillPoint = nil

    --合体技能槽(怒气点数)
    self.zomlllSkillPoint = nil

    --攻击力(物攻 法攻);
    self.attack = nil

    --额外攻击力加成
    self.addAttack = nil

    --物理攻击增加
    self.physicalAttackAdd = nil

    --法术攻击增加
    self.skillAttackAdd = nil

    --额外加成攻击%
    self.extraAttack = nil

    --最终伤害加成
    self.finalDamageAddition = nil

    --最终减伤加成
    self.finalSubDamageAddition = nil

    --最终伤害比例
    self.finalDamagePercent = nil

    --最终伤害比例加成
    self.addFinalDamagePercent = nil

    --受到伤害增加
    self.addBruiseDamagePercent = nil

    --物理防御
    self.physicalDefence = nil

    --技能防御
    self.skillDefence = nil

    --增加物理防御
    self.addPhysicalDefence = nil

    --增加技能防御
    self.addSkillDefence = nil

    --暴击
    self.critical = nil

    --暴击倍率
    self.critialMultiple = nil

    --增加暴击倍率
    self.addCritialMultiple = nil

    --减少暴击倍率
    self.subCritialMultiple = nil

    --初始抗暴
    self.criticalResist = nil

    --增加抗暴
    self.addCriticalResist = nil

    --闪避
    self.evasion = nil

    --增加闪避
    self.addEvasion = nil

    --减少闪避
    self.subEvasion = nil

    --命中
    self.accuracy = nil

    --增加命中
    self.addAccuracy = nil

    --减少命中增加
    self.subAccuracy = nil

    --格挡
    self.retain = nil

    --破击
    self.retainBreak = nil

    -- 破击加成
    self.addRetainBreakPercent = nil

    --是否死亡
    self.isDead = nil

    --物理减伤
    self.physicalSubDamage = nil

    --技能减伤
    self.specialSubDatamage = nil

    --治疗加成
    self.cureAdditional = nil

    --被治疗率
    self.byCurePercent = nil

    --被治疗率增加百分比
    self.byCureAdditionalPercent = nil

    --被治疗率减少百分比
    self.byCureLessenPercent = nil

    -- 掉若干血增加若干攻击
    self.addAttackPresent = nil

    -- 对生命低于50%的目标造成伤害增加百分比
    self.addDamagePercent50 = nil
    -- 对生命低于50%的目标受到伤害降低百分比
    self.lessenDamagePercent50 = nil
    -- 对生命低于75%的目标受到伤害增加百分比  
    self.addDamagePercent75 = nil

    --受到暴击伤害减少百分比
    self.byCritLessPercent = nil

    --最终减伤比例
    self.finalLessenDamagePercent = nil

    --续航值
    self.enduranceHPoint = nil

    --治疗值增加
    self.cureAdd = nil

    --被治疗值增加
    self.byCureAdd = nil

    --灼烧伤害增加
    self.firingAdd = nil

    --灼烧伤害免疫
    self.byFiringLes = nil

    --中毒伤害增加
    self.posionAdd = nil

    --中毒伤害免伤
    self.byPosionLes = nil

    --天赋列表
    -- self.talentMouldList = {}

    --buff影响
    -- self.buffEffect = {}

    --普通技能模板
    self.commonSkillMould = nil

    --普通攻击效用
    -- self.commonBattleSkill = {}

    --怒气技能模板
    self.specialSkillMould = nil

    --自身怒气技能效用
    -- self.oneselfBattleSkill = {}

    --合体怒气技能效用
    -- self.zoariumBattleSkill = {}

    --释放合体技能
    -- self.releaseSkill = {}

    --反击技能模板
    self.counterSkillMould = nil

    --反击技能效用
    -- self.counterBattleSkill = {}

    --天赋光环列表
    -- self.talentAuraList = {}

    --联动技能列表
    -- self.talentUniteSkillList = {}

    --天赋免疫列表
    -- self.talentImmunityList = {}

    --天赋结果列表
    -- self.talentJudgeResultList = {}

    --掉落卡片id
    self.rewardCard = nil

    --掉落卡片几率
    self.rewardRatio = nil

    --掉落道具
    self.rewardProp = nil

    --掉落道具几率
    self.rewardPropRatio = nil

    --掉落装备
    self.rewardEquipment = nil

    --掉落装备几率
    self.rewardEquipmentRatio = nil

    --是否暴击
    self.isCritical = nil

    --是否闪避
    self.isEvasion = nil

    --是否挡格
    self.isRetain = nil

    --是否禁怒
    self.isSpDisable = nil

    --是否眩晕
    self.isDizzy = nil

    --是否麻痹
    self.isParalysis = nil

    --是否封技
    self.isDisSp = nil

    --是否灼烧
    self.isFiring = nil

    --是否爆裂
    self.isExplode = nil

    --是否禁疗
    self.isBearHP = nil

    --致盲
    self.isBlind = nil

    --残废
    self.isCripple = nil

    --爆裂次数
    self.explodeCount = nil

    --挡格附加值
    self.retainAdditional = nil

    --中毒伤害值
    self.posionDamage = nil

    --灼烧伤害值
    self.firingDamage = nil

    --是否无敌
    self.isNoDamage = nil

    --是否可以反击
    self.canReAttack = nil

    --是否已经出过手
    self.isAction = nil

    --是否必闪
    self.isEvasionSurely = nil

    --造成的伤害
    self.effectDamage = nil

    --技能造成总伤害
    self.totalEffectDamage = nil

    --作用对象数量
    self.coordinateCount = nil

    --怒气点数
    self.totalSkillPoint = nil

    --合击技能模板
    -- self.zoariumSkillMould =  {}

    --合体技
    self.zoarium = nil

    --合体对象坐标
    self.zoariumSeat = nil

    --进阶等级
    self.advance = nil

    --合体技能释放类型 true:一起 false:依次
    self.seriatim = nil

    --合体技攻击列表
    -- self.fitBattleObjects = {}

    --合体技模板
    self.releaseSKillMould = nil

    --发动者
    self.fitBuffer = nil

    --合击数量
    self.figSkillCount = nil

    --技能效用
    self.fitSkillInflushBuffer = nil

    --战船标识
    self.capacity = nil

    --相克类型
    -- self.restrainMoulds =  {}

    --相克属性
    -- self.restrainObject =  RestrainObject:new()

    --重置合体技状态
    self.hasZoariumSkill = nil
    
    --评分伤害加成
    self.grade_attack = nil

    self.isNeedAddSkillPoint = nil

    --战斗小兵对象
    -- self.forceObjects = {}
    if nil ~= self.forceObjects then
        for i, v in pairs(self.forceObjects) do
            v:clear()
            self.forceObjects[i] = nil
        end
        self.forceObjects = nil
    end

    -- 横扫数据添加
    -- 必杀百分比
    self.deadlyStrikePersent = nil

    -- 伤害增加百分比
    self.addDamagePercent = nil

    -- 伤害减少百分比
    self.lessenDamagePercent = nil

    -- 横扫数据添加
    self.deadlyStrikePersent = nil   -- 必杀百分比
    self.criticalResistSupoerAdditionalPercent = nil -- 强韧百分比
    self.addDamagePercent = nil       -- 伤害增加百分比
    self.lessenDamagePercent = nil    -- 伤害减少百分比
    self.dyAddDamagePercent = nil     -- 受到伤害增加百分比
    self.dyLessenDamagePercent = nil  -- 受到伤害减少百分比
    self.spAdditionalPercent = nil        -- 聚气增加百分比
    self.spLessenPercent = nil    -- 聚气减少百分比
    --/
    --生命加成百分比
    self.powerAdditionalPercent = nil

    --生命减少百分比
    self.powerLessenPercent = nil

    --攻击加成百分比
    self.courageAdditionalPercent = nil
    
    --攻击减少百分比
    self.courageLessenPercent = nil

    --物理防御加成百分比
    self.intellectAdditionalPercent = nil

    --物理防御减少百分比
    self.intellectLessenPercent = nil

    --法防加成百分比
    self.nimableAdditionalPercent = nil

    --法防减少百分比
    self.nimableLessenPercent = nil

    --暴击加成百分比
    self.criticalAdditionalPercent = nil

    --暴击减少百分比
    self.criticalLessenPercent = nil

    --抗暴加成百分比
    self.criticalResistAdditionalPercent = nil

    --抗暴减少百分比
    self.criticalResistLessenPercent = nil

    --闪避加成百分比
    self.evasionAdditionalPercent = nil

    --闪避加成百分比
    self.evasionLessenPercent = nil

    --命中加成百分比
    self.accuracyAdditionalPercent = nil

    --命中减少百分比
    self.accuracyLessenPercent = nil

    --挡格加成百分比
    self.retainAdditionalPercent = nil

    --挡格减少百分比
    self.retainLessenPercent = nil

    --破击加成百分比
    self.retainBreakAdditionalPercent = nil

    --破击减少百分比
    self.retainBreakLessenPercent = nil

    --物理免伤加成百分比
    self.physicalLessenDamagePercent = nil

    --法术免伤加成百分比
    self.skillLessenDamagePercent = nil


    self.sprite_id =nil
    self.talent_mould_index_list = ""
    self.capacity = nil
    self.musics = nil
end

-- local obj = BattleObject:new()
