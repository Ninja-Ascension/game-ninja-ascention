
-- 装备模版
-- @author alexdu
EquipmentMould = class("EquipmentMould")
-- 装备模版
-- @author alexdu
EquipmentMould.SELL_TAG_NORMAL =  0
-- 装备模版
-- @author alexdu
EquipmentMould.SELL_TAG_DISCOUNT =  1
-- 装备模版
-- @author alexdu
EquipmentMould.SELL_TAG_LIMIT =  2
-- 装备模版
-- @author alexdu
EquipmentMould.SELL_TAG_WORTH =  3
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_WEAPON =  0
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_HELMET =  1
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_NECKLACE =  2
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_ARMOUR =  3
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_HORSE =  4
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_BOOK =  5
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_FASHION =  6
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_HYALINE_FASHION =  7
-- 装备模版
-- @author alexdu
EquipmentMould.EQUIPMENT_TYPE_TREASURE1 =  8
EquipmentMould.EQUIPMENT_TYPE_TREASURE2 =  9
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL =  0
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL =  1
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL =  2
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL =  3
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL_PERCENTAGE =  4
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL_PERCENTAGE =  5
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL_PERCENTAGE =  6
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL_PERCENTAGE =  7
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_CRITICAL_ODDS =  8
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_CRITICAL_RESIST_ODDS =  9
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_RETAIN_ODDS =  10
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_RETAIN_BREAK_ODDS =  11
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_ACCURACY_ODDS =  12
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_EVASION_ODDS =  13
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_PHYSIC_LESSEN_DAMAGE_PERCENTAGE =  14
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_SKILL_LESSEN_DAMAGE_PERCENTAGE =  15
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_CURE_ODDS =  16
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_BY_CURE_ODDS =  17
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE =  18
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE =  19
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_INITIAL_SP_INCREASE =  20
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_INITIAL_HEAD =  21
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_INITIAL_BODY =  22
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_INITIAL_WISDOM =  23
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_PHYSIC_ATTACK_ADDITIONAL =  24
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_SKILL_ATTACK_ADDITIONAL =  25
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_CURE_ADDITIONAL =  26
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_BY_CURE_ADDITIONAL =  27
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_FIRING_ADDITIONAL =  28
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_POSION_ADDITIONAL =  29
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_FIRING_LESSEN =  30
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_POSION_LESSEN =  31
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_EXPERIENCE =  32
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE_PERCENT =  33
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE_PERCENT =  34
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE_PERCENT_PVP =  35
-- 装备模版
-- @author alexdu
EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE_PERCENT_PVP =  36
-- 初始合击槽
-- @author cpzheng
EquipmentMould.PROPERTY_TYPE_FINAL_INIT_ZOMALSKILLPOINT =  37
-- 每次出手增加的怒气
-- @author cpzheng
EquipmentMould.PROPERTY_TYPE_EVERY_ATTACK_ADD_SP =  38
-- 灼烧伤害% 
-- @author cpzheng
EquipmentMould.PROPERTY_TYPE_FIRING_DAMAGE_PERCENT =  39
-- 吸血率%
-- @author cpzheng
EquipmentMould.PROPERTY_TYPE_INHALE_HP_DAMAGE_PERCENT =  40
-- 怒气
-- @author cpzheng
EquipmentMould.PROPERTY_TYPE_ADD_SP_VALUE =  41   
-- 42.反弹%  
EquipmentMould.PROPERTY_TYPE_REBOUND_DAMAGE_VALUE =  42
-- 43.暴伤加成%	   
EquipmentMould.PROPERTY_TYPE_UNIQUE_SKILL_DAMAGE_PERCENT =  43
-- 44.免控率%  
EquipmentMould.PROPERTY_TYPE_AVOID_CONTROL_PERCENT =  44
-- 45.小技能触发概率%  
EquipmentMould.PROPERTY_TYPE_NORMATIN_SKILL_TRIGGER_PERCENT =  45
-- 46.格挡强度% 
EquipmentMould.PROPERTY_TYPE_UNIQUE_SKILL_RESISTANCE_PERCENT =  46
-- 47.控制率%
EquipmentMould.PROPERTY_TYPE_CONTROL_PERCENT =  47
-- 48.治疗效果% 
EquipmentMould.PROPERTY_TYPE_CURE_EFFECT_PERCENT =  48
-- 49.暴击强化% 
EquipmentMould.PROPERTY_TYPE_CRITICAL_ADDITION_PERCENT =  49
-- 50.数码兽类型克制伤害%
EquipmentMould.PROPERTY_TYPE_HERO_RESTRAIN_DAMAGEPERCENT =  50
-- 51.溅射伤害% 
EquipmentMould.PROPERTY_TYPE_SPUTTERING_ATTACK_ADD_DAMAGE_PERCENT =  51
-- 52.技能伤害%
EquipmentMould.PROPERTY_TYPE_SKILL_ATTACK_ADD_DAMAGE_PERCENT =  52
-- 53.被治疗减少%
EquipmentMould.PROPERTY_TYPE_BY_CURE_LESSEN_PERCENT = 53
-- 54.伤害提升%（数码大冒险中的说法：伤害提升、额外造成伤害、额外增加伤害、伤害翻倍都属于这类）
EquipmentMould.PROPERTY_TYPE_ADDITIONAL_DAMAGE_PERCENT_FOR_54 = 54
-- 55.必杀伤害率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_ODDS_FOR_55 = 55
-- 56.增加必杀伤害%
EquipmentMould.PROPERTY_TYPE_ADDITIONAL_DAMAGE_PERCENT_FOR_56 = 56
-- 57.减少必杀伤害%（数码大冒险中的说法：增加必杀伤害、必杀伤害抗性都属于这类）
EquipmentMould.PROPERTY_TYPE_LESSEN_DAMAGE_PERCENT_FOR_57 = 57
-- 58.增加暴击伤害%
EquipmentMould.PROPERTY_TYPE_ADDITIONAL_DAMAGE_PERCENT_FOR_58 = 58
-- 59.减少暴击伤害%
EquipmentMould.PROPERTY_TYPE_LESSEN_DAMAGE_PERCENT_FOR_59 = 59
-- 60.受到的必杀伤害增加%
EquipmentMould.PROPERTY_TYPE_ADDITIONAL_DAMAGE_PERCENT_FOR_60 = 60
-- 61怒气回复速度%
EquipmentMould.PROPERTY_TYPE_ADDITIONAL_PWER_ADD_SPEED_FOR_61 = 61
-- 62受到伤害降低%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_PERCENT_FOR_62 = 62
-- 63降低攻击(%)	
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_ATTACK_PERCENT_FOR_63 = 63
-- 64降低防御
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_64 = 64
-- 65.伤害加成提升%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_65 = 65
-- 66.降低必杀伤害率%	
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_66 = 66
-- 67.降低伤害减免%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_67 = 67
-- 68.降低防御（%）
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_68 = 68
-- 69.降低怒气回复速度
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_69 = 69
-- 70数码兽类型克制伤害加成%   
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_70 = 70
-- 71数码兽类型克制伤害减免%   
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_71 = 71
-- 72.降低攻击
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_72 = 72
-- 73.增加必杀抗性%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_73 = 73
-- 74.减少必杀抗性%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_74 = 74
-- 75降低免控率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_75 = 75
-- 76复活概率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_76 = 76
-- 77被复活概率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_77 = 77
-- 78复活继承血量%   
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_78 = 78
-- 79复活继承怒气%   
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_79 = 79
-- 80被复活继承血量%  
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_80 = 80
-- 81被复活继承怒气%  
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_81 = 81
-- 82增加复活概率%   
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_82 = 82
-- 83增加复活继承血量% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_83 = 83
-- 84小技能伤害提升% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_84 = 84
-- 85连击概率% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_85 = 85
-- 88增加复仇概率% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_88 = 88
-- 89增加复仇伤害% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_89 = 89
-- 90防克攻伤害加成% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_90 = 90
-- 91攻克技伤害加成% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_91 = 91
-- 92技克防伤害加成% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_92 = 92
-- 93防克攻伤害减免% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_93 = 93
-- 94攻克技伤害减免% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_94 = 94
-- 95技克防伤害减免% 
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_95 = 95

-- 96 神兽攻击
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_96 = 96
-- 97 神兽攻击加成百分比%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_97 = 97
-- 98 神兽伤害增加%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_98 = 98
-- 99 神兽伤害减免%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_99 = 99
-- 100 神兽受到的伤害增加%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_100 = 100
-- 101 神兽受到的伤害降低%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_101 = 101
-- 102 神兽暴击伤害%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_102 = 102
-- 103 神兽暴击率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_103 = 103
-- 104 神兽抗暴率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_104 = 104
-- 105 强力免控率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_105 = 105
-- 106 强力控制率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_106 = 106
-- 107 无视防御%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_107 = 107
-- 108 无视抗暴率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_108 = 108
-- 109 无视格挡率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_109 = 109
-- 110 无视免伤率%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_110 = 110
-- 111 无视奥义（必杀）抗性%
EquipmentMould.PROPERTY_TYPE_DAMAGE_LESSEN_DEFEND_FOR_111 = 111

-- 测试武将模板ID
-- 15、32、25、24、44、46、51、37、53

function EquipmentMould:ctor()
    --装备名称
    self.equipmentName = nil

    --影响类型
    self.influenceType = nil

    --影响类型：0为影响耐久、1为影响攻击、2为影响防御、3为影响精准
    self.suitId =  0

    --装备类型：0武器 1头盔 2项链 3盔甲 4战马 5兵书6时装
    self.equipmentType =  0

    --初始附加值
    self.initialValue =  ""

    --品级
    self.rankLevel =  0

    --星级
    self.starLevel =  0

    --成长等级：0为白色，1为绿色，2为蓝色，3为紫色，4为橙色，5为黑色
    self.growLevel =  0

    --成长值
    self.growValue =  ""

    --初始佩戴所需战船等级
    self.initShipLevel =  0

    --出售给系统的价格
    self.silverPrice =  0

    --是否商店出售的商品：0为非出售、1为出售
    self.isSell =  0

    --商店的贝里标价（不出售则不填写）
    self.shopOfSilver =  0

    --商店的宝石标价（不出售则不填写）
    self.shopOfGold =  0

    --商店的精铁标价(不出售则不填写)
    self.shopOfIron =  0

    --图标标识
    self.picIndex =  nil

    --大图片标识
    self.allIcon =  ""

    --追踪描述
    self.traceRemarks = nil

    --追踪场景
    self.traceScene = nil

    --追踪NPC
    self.traceNpc = nil

    --追踪NPC下标
    self.traceNpcIndex = nil

    --显示所需玩家等级
    self.visibleOfLevel =  0

    --显示所需VIP等级
    self.visibleOfVipLevel =  0

    --出售所需vip等级
    self.sellOfVipLevel =  0

    --限定购买次数
    self.purchaseCountLimit =  0

    --是否每日刷新限定购买次数 0:否 1:是
    self.isDailyRefreshLimit =  0

    --初始等级
    self.initialLevel =  1

    --出售标签
    self.sellTag =  SELL_TAG_NORMAL

    --限量购买次数
    self.entirePurchaseCountLimit =  0

    --宝物20级解锁属性
    self.level20UnlockValue =  ""

    --宝物40级解锁属性
    self.level40UnlockValue =  "";

    --宝物精炼成长值
    self.refiningGrowValue =  ""

    --宝物精炼需求id
    self.refiningRequireId =  ""

    --宝物精炼等级上限
    self.refiningLevelLimit =  0

    --初始提供强化经验
    self.initialSupplyEscalateExp =  0

    --炼化获得洗练石
    self.refiningGetOfStone =  0

    --炼化获得宝物精华
    self.refiningGetOfEssence =  0

    --羁绊标识
    self.relationshipTag =  ""

    --抢夺关系
    self.grabRankLink =  0

    --洗练属性id
    self.refiningPropertyId =  0

    --分解获得物品id和数量
    self.refiningItems = ""

    --装备位
    self.equipmentSeat = nil

    --炼化获得威名
    self.refiningGetOfGlories = nil

    --技能装备模板
    self.skillEquipmentAdronMould = nil

    self._equipmentMoulds =  nil

end

function EquipmentMould:getTypeValue(typeValueString, valueType)
	if(typeValueString == "-1")then
		return 0
	end
	local valueArray = zstring.split(typeValueString, "|")
	for i, v in pairs(valueArray) do
		if(tonumber(zstring.split(valueArray[i], IniUtil.comma)[1]) == valueType) then
			return tonumber(zstring.split(valueArray[i], IniUtil.comma)[2])
		end
	end
	return 0
end

function EquipmentMould:growValueGet(valueType)
	return EquipmentMould:getTypeValue(self.growValue, valueType)
end

function EquipmentMould:treasureGrowValueGet(valueType)
	return EquipmentMould:getTypeValue(self.growValue, valueType)
end

function EquipmentMould:initialValueGet(valueType)
	return EquipmentMould:getTypeValue(self.initialValue, valueType)
end

function EquipmentMould:addEntirePurchaseCountLimit(limitPurchaseCount)
	self.entirePurchaseCountLimit = self.entirePurchaseCountLimit + limitPurchaseCount
end

function EquipmentMould:subEntirePurchaseCountLimit(limitPurchaseCount)
	self.entirePurchaseCountLimit = self.entirePurchaseCountLimit - limitPurchaseCount
end

function EquipmentMould:refiningGrowValueGet(valueType)
	return EquipmentMould:getTypeValue(self.refiningGrowValue, valueType)
end

function EquipmentMould:refiningRequireIdGet(rankLevel)
	return tonumber(zstring.split(self.refiningRequireId, IniUtil.comma)[rankLevel])
end

--[[
local obj = EquipmentMould:new()
obj.initialValue  = "1,40|12,0.4"
--_crint(obj:initialValueGet(2))
--]]
