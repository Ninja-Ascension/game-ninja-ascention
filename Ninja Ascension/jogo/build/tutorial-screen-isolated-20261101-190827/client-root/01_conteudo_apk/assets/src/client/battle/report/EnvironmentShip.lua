
-- 环境战船
-- @author alexdu
EnvironmentShip = class("EnvironmentShip")

function EnvironmentShip:ctor()
    self.captainType =  0

    --向性
    self.campPreference =  0

    --船只名称
    self.shipName =  ""

    --船只等级
    self.level =  1

    --性别
    self.gender =  0

    --普通技能模板
    self.commonSkillMould =  0

    --船只技能
    self.skillMould =  0

    --技能名称
    self.skillName =  ""

    --技能描述
    self.skillDescribe =  ""

    --战船类型，0为白色战船，1为绿色战船，2为蓝色战船，3为紫色战船，4为橙色战船
    self.shipType =  0

    --体力值
    self.power =  0

    --勇气值
    self.courage =  0

    --智力值
    self.intellect = 0

    --法防
    self.nimable =  0

    --防暴
    self.criticalResist =  0

    --闪避
    self.jink =  0

    --命中
    self.accuracy =  0

    --格挡
    self.retain =  0

    --破击
    self.retainBreak =  0

    --暴击系数
    self.critical =  0

    --拥有怒气值 0为拥有，1为没有
    self.haveDeadly =  0

    --体力成长参数
    self.growPower =  0

    --勇气成长参数
    self.growCourage =  0

    --智力成长参数
    self.growIntellect =  0

    --敏捷成长参数
    self.growNimable =  0

    --图片索引
    self.picIndex =  ""

    --半身像索引
    self.bustIndex =  -1

    --物理攻击特效
    self.physicsAttackEffect =  -1

    --屏幕攻击特效
    self.screenAttackEffect =  -1

    --物理攻击模式 0:原地攻击 1:移动到被攻击者船正前方攻击
    self.physicsAttackMode =  0

    --技能攻击模式 0:原地攻击 1:移动到被攻击者船正前方攻击
    self.skillAttackMode =  0

    --掉落卡片id
    self.rewardCard =  0

    --掉落卡片几率
    self.rewardCardRatio =  0

    --天赋模板
    self.talentMould =  ""

    --向性索引
    self.capacity =  0

    --生命加成百分比
    self.powerAdditionalPercent =  0

    --攻击加成百分比
    self.courageAdditionalPercent =  0

    --物理防御加成百分比
    self.intellectAdditionalPercent =  0

    --法防加成百分比
    self.nimableAdditionalPercent =  0

    --暴击加成百分比
    self.criticalAdditionalPercent =  0

    --抗暴加成百分比
    self.criticalResistAdditionalPercent =  0

    --闪避加成百分比
    self.evasionAdditionalPercent =  0

    --命中加成百分比
    self.accuracyAdditionalPercent =  0

    --挡格加成百分比
    self.retainAdditionalPercent =  0

    --破击加成百分比
    self.retainBreakAdditionalPercent =  0

    --物理免伤加成百分比
    self.physicalLessenDamagePercent =  0

    --法术免伤加成百分比
    self.skillLessenDamagePercent =  0

    --治疗率加成百分比
    self.curePercent =  0

    --被治疗率加成百分比
    self.byCurePercent =  0

    --最终伤害加成
    self.finalDamageAdditional =  0

    --最终免伤加成
    self.finalLessenDamageAdditional =  0

    --初始怒气增加
    self.initialSPIncrease =  0

    --天赋模板列表
    self.talentMouldList = {}

    --指向 ship_mould
    self.directing =  0

    --掉落道具
    self.dropProp =  0

    --掉落道具概率
    self.dropPropRatio =  0

    --掉落装备
    self.dropEquipment =  0

    --掉落装备概率
    self.dropEquipmentRatio =  0

    --根据影响值改变船只属性
    --@param influenceValue
    self._environmentShips =  nil
    --初始怒气槽
    self.zoariumSkillPoint = 0
end

function EnvironmentShip:addPropertyByInfluenceValue(influenceValue)
	local propertyTypeArray = zstring.split(influenceValue, "|")
	for key, property in pairs(propertyTypeArray) do
		local propertyType  = tonumber(zstring.split(property, IniUtil.comma)[1])
		local propertyValue = tonumber(zstring.split(property, IniUtil.comma)[2])
		-- _crint (propertyType, propertyValue)
		-- _crint (EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL)
		if (propertyType == EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL ) then
			-- _crint "Will add power"
			self.power = self.power + propertyValue
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL) then
			self.courage = self.courage + propertyValue				
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL ) then
			self.intellect = self.intellect + propertyValue
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL ) then
			self.nimable = self.nimable + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL_PERCENTAGE ) then
			if(propertyValue < 1) then
				propertyValue = propertyValue * 100
			end
			self.powerAdditionalPercent = self.powerAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL_PERCENTAGE ) then
			if(propertyValue < 1)then
				propertyValue = propertyValue * 100
			end
			self.courageAdditionalPercent = self.courageAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL_PERCENTAGE ) then
			if(propertyValue < 1)then
				propertyValue = propertyValue * 100
			end
			self.intellectAdditionalPercent = self.intellectAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL_PERCENTAGE ) then
			if(propertyValue < 1)then
				propertyValue = propertyValue * 100
			end
			self.nimableAdditionalPercent = self.nimableAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CRITICAL_ODDS ) then
			self.criticalAdditionalPercent = self.criticalAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CRITICAL_RESIST_ODDS ) then
			self.criticalResistAdditionalPercent = self.criticalResistAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_RETAIN_ODDS ) then
			self.retainAdditionalPercent = self.retainAdditionalPercent + propertyValue
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_RETAIN_BREAK_ODDS ) then
			self.retainBreakAdditionalPercent = self.retainBreakAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_ACCURACY_ODDS ) then
			self.accuracyAdditionalPercent = self.accuracyAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_EVASION_ODDS ) then
			self.evasionAdditionalPercent = self.evasionAdditionalPercent + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_LESSEN_DAMAGE_PERCENTAGE ) then
			self.physicalLessenDamagePercent = self.physicalLessenDamagePercent + (propertyValue / 100)
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_LESSEN_DAMAGE_PERCENTAGE ) then
			self.skillLessenDamagePercent = self.skillLessenDamagePercent + (propertyValue / 100)
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CURE_ODDS ) then
			self.curePercent = self.curePercent + (propertyValue / 100)
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_BY_CURE_ODDS ) then
			self.byCurePercent = self.byCurePercent + (propertyValue / 100)
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE ) then
			self.finalDamageAdditional = self.finalDamageAdditional + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE ) then
			self.finalLessenDamageAdditional = self.finalLessenDamageAdditional + propertyValue
			
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_INITIAL_SP_INCREASE ) then
			self.initialSPIncrease = self.initialSPIncrease + propertyValue
        elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_INIT_ZOMALSKILLPOINT) then
            self.zoariumSkillPoint = propertyValue
		else
		end
	end
end

function EnvironmentShip:calculateShipProperty()
	self:calculateShipPropertyByTalent()
	self.power = self.power * (100.0 + self.powerAdditionalPercent) / 100.0
	self.courage = self.courage * (100.0 + self.courageAdditionalPercent) / 100.0
	self.intellect = self.intellect * (100.0 + self.intellectAdditionalPercent) / 100.0
	self.nimable = self.nimable * (100.0 + self.nimableAdditionalPercent) / 100.0

	self.critical = self.critical + self.criticalAdditionalPercent
	self.jink = self.jink + self.evasionAdditionalPercent
end


-- 计算天赋影响船只能力
function EnvironmentShip:calculateShipPropertyByTalent()
	self.talentMouldList = {}
	----_crint ("self.talentMould = " .. self.talentMould)
	if( self.talentMould ~= "" and self.talentMould ~= "-1") then		
		local talentIdArray = zstring.split(self.talentMould, ",")
		--for (int i = 0; i < talentIdArray.length; i++) then
		for _, talentId in pairs(talentIdArray) do	
			--TalentMould talentMould = (TalentMould) Transformers.talentMouldDAOProxy().load(talentIdArray[i]);
			local talentMould = TalentMould:new()
			talentMould:init(dms.element(dms['talent_mould'], talentId) )
			if(talentMould.baseAdditional ~= "" and talentMould.baseAdditional ~= "-1") then					
				self:addPropertyByInfluenceValue(talentMould.baseAdditional);
			end
			table.insert(self.talentMouldList, talentMould)
		end
	end
end
	
--[[
local obj = EnvironmentShip:new()
obj:addPropertyByInfluenceValue("4, 0.6")
--_crint(obj.powerAdditionalPercent)
--]]
