app.load("client.battle.report.FightUtil")
app.load("client.battle.report.RestrainUtil")
-- 战斗技能
-- @author xiaofeng
BattleSkill = class("BattleSkill")
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_DAMAGEHP =  0
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADDHP =  1
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADDSP =  2
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_DAMAGESP =  3
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_NOSP =  4
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_DIZZY =  5
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_POISON =  6
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_PARALYSIS =  7
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_DISSP =  8
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_FIRING =  9
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_EXPLODE =  10
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADDRETAIN =  11
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADDDEFENCE =  12
-- 吸血
BattleSkill.SKILL_INFLUENCE_DRAINS_HP =  14
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_BEAR_HP =  15
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_BLIND =  16
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_CRIPPLE =  17
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADD_ATTACK =  21
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_SUB_ATTACK =  22
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADD_DEFENSE =  23
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_SUB_DEFENSE =  24
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_ADD_DAMAGE =  25
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_ADD_BURISE =  26
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_ADD_CRITICAL =  27 -- 增加暴击率
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_SUB_CRITICAL =  28 -- 增加抗暴率
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADD_HIT =  29 -- 增加命中率
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_ADD_DODGE =  30 -- 增加闪避率
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFUENCE_ENDURANCE =  31 -- 持续回血
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFUENCE_CLEAR_BUFF =  32 -- 清除BUFF
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFUENCE_ADD_FINNAL_DAMAGE =  33 -- 增加自身伤害
BattleSkill.SKILL_INFUENCE_RESULT_FOR_34 = 34	-- 全体秒杀
BattleSkill.SKILL_INFUENCE_RESULT_FOR_35 = 35	-- 固定伤害
BattleSkill.SKILL_INFUENCE_RESULT_FOR_36 = 36	-- 降低治疗效果
BattleSkill.SKILL_INFUENCE_RESULT_FOR_37 = 37	-- 溅射
BattleSkill.SKILL_INFUENCE_RESULT_FOR_38 = 38	-- 增加格挡强度
BattleSkill.SKILL_INFUENCE_RESULT_FOR_39 = 39	-- 降低格挡率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_40 = 40	-- 增加吸血率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_41 = 41	-- 反弹
BattleSkill.SKILL_INFUENCE_RESULT_FOR_42 = 42	-- 小技能触发概率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_43 = 43	-- 增加破格挡率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_44 = 44	-- 增加反弹率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_45 = 45	-- 增加伤害减免
BattleSkill.SKILL_INFUENCE_RESULT_FOR_46 = 46	-- 变形（变成玩偶）
BattleSkill.SKILL_INFUENCE_RESULT_FOR_47 = 47	-- 降低小技能触发概率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_48 = 48	-- 降低暴击伤害
BattleSkill.SKILL_INFUENCE_RESULT_FOR_49 = 49	-- 减少造成的必杀伤害
BattleSkill.SKILL_INFUENCE_RESULT_FOR_50 = 50	-- 嘲讽
BattleSkill.SKILL_INFUENCE_RESULT_FOR_51 = 51	-- 降低伤害加成
BattleSkill.SKILL_INFUENCE_RESULT_FOR_52 = 52	-- 增加伤害加成
BattleSkill.SKILL_INFUENCE_RESULT_FOR_53 = 53	-- 增加控制率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_54 = 54	-- 增加造成的必杀伤害
BattleSkill.SKILL_INFUENCE_RESULT_FOR_55 = 55	-- 减少必杀伤害率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_56 = 56	-- 降低怒气回复速度
BattleSkill.SKILL_INFUENCE_RESULT_FOR_57 = 57	-- 提高怒气回复速度
BattleSkill.SKILL_INFUENCE_RESULT_FOR_58 = 58	-- 增加暴击伤害
BattleSkill.SKILL_INFUENCE_RESULT_FOR_59 = 59	-- --
BattleSkill.SKILL_INFUENCE_RESULT_FOR_60 = 60	-- 增加暴击强度
BattleSkill.SKILL_INFUENCE_RESULT_FOR_61 = 61	-- 降低伤害减免
BattleSkill.SKILL_INFUENCE_RESULT_FOR_62 = 62	-- 增加必杀伤害率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_63 = 63	-- 增加格挡率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_64 = 64	-- 增加数码兽类型克制伤害加成
BattleSkill.SKILL_INFUENCE_RESULT_FOR_65 = 65	-- 增加数码兽类型克制伤害减免
BattleSkill.SKILL_INFUENCE_RESULT_FOR_66 = 66	-- 降低暴击率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_67 = 67	-- 降低抗暴率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_68 = 68	-- 增加必杀抗性
BattleSkill.SKILL_INFUENCE_RESULT_FOR_69 = 69	-- 减少必杀抗性
BattleSkill.SKILL_INFUENCE_RESULT_FOR_70 = 70	-- 复活概率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_71 = 71	-- 复活继承血量
BattleSkill.SKILL_INFUENCE_RESULT_FOR_72 = 72	-- 复活继承怒气
BattleSkill.SKILL_INFUENCE_RESULT_FOR_73 = 73	-- 增加复活复活概率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_74 = 74	-- 增加复活继承血量
BattleSkill.SKILL_INFUENCE_RESULT_FOR_75 = 75	-- 被复活概率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_76 = 76	-- 被复活继承血量
BattleSkill.SKILL_INFUENCE_RESULT_FOR_77 = 77	-- 被复活继承怒气
BattleSkill.SKILL_INFUENCE_RESULT_FOR_78 = 78	-- 免疫控制
BattleSkill.SKILL_INFUENCE_RESULT_FOR_79 = 79	-- 复活
BattleSkill.SKILL_INFUENCE_RESULT_FOR_81 = 81	-- 放逐效果
BattleSkill.SKILL_INFUENCE_RESULT_FOR_82 = 82	-- 虚弱效果
BattleSkill.SKILL_INFUENCE_RESULT_FOR_83 = 83	-- 魅惑
BattleSkill.SKILL_INFUENCE_RESULT_FOR_84 = 84	-- 石化
BattleSkill.SKILL_INFUENCE_RESULT_FOR_85 = 85	-- 增加复仇概率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_86 = 86	-- 增加复仇伤害
BattleSkill.SKILL_INFUENCE_RESULT_FOR_87 = 87	-- 复仇效果
BattleSkill.SKILL_INFUENCE_RESULT_FOR_88 = 88	-- 魅惑2
BattleSkill.SKILL_INFUENCE_RESULT_FOR_89 = 89	-- 增加复仇概率2
BattleSkill.SKILL_INFUENCE_RESULT_FOR_90 = 90	-- 增加复仇伤害2
BattleSkill.SKILL_INFUENCE_RESULT_FOR_91 = 91	-- 复仇效果2
BattleSkill.SKILL_INFUENCE_RESULT_FOR_92 = 92	-- 真实伤害
BattleSkill.SKILL_INFUENCE_RESULT_FOR_93 = 93	-- 设置真实伤害目标
BattleSkill.SKILL_INFUENCE_RESULT_FOR_94 = 94	-- 治疗率增加
BattleSkill.SKILL_INFUENCE_RESULT_FOR_95 = 95	-- 免控率上升
BattleSkill.SKILL_INFUENCE_RESULT_FOR_96 = 96	-- 弱感电
BattleSkill.SKILL_INFUENCE_RESULT_FOR_97 = 97	-- 强感电
BattleSkill.SKILL_INFUENCE_RESULT_FOR_98 = 98	-- 增加复仇概率3
BattleSkill.SKILL_INFUENCE_RESULT_FOR_99 = 99	-- 增加复仇伤害3
BattleSkill.SKILL_INFUENCE_RESULT_FOR_100 = 100	-- 复仇效果3
BattleSkill.SKILL_INFUENCE_RESULT_FOR_101 = 101	-- 禁止神兽使用X回合
BattleSkill.SKILL_INFUENCE_RESULT_FOR_102 = 102	-- 免控率下降
BattleSkill.SKILL_INFUENCE_RESULT_FOR_103 = 103	-- 格挡强度下降
BattleSkill.SKILL_INFUENCE_RESULT_FOR_104 = 104	-- 清除所有减益buff
BattleSkill.SKILL_INFUENCE_RESULT_FOR_105 = 105	-- 免疫石化和感电
BattleSkill.SKILL_INFUENCE_RESULT_FOR_106 = 106	-- 无敌效果（虚化）
BattleSkill.SKILL_INFUENCE_RESULT_FOR_107 = 107	-- 清除所有增益buff
BattleSkill.SKILL_INFUENCE_RESULT_FOR_108 = 108	-- 无视防御buff
BattleSkill.SKILL_INFUENCE_RESULT_FOR_109 = 109	-- 无视抗暴率buff
BattleSkill.SKILL_INFUENCE_RESULT_FOR_110 = 110	-- 无视格挡率buff
BattleSkill.SKILL_INFUENCE_RESULT_FOR_111 = 111	-- 无视免伤率buff
BattleSkill.SKILL_INFUENCE_RESULT_FOR_112 = 112	-- 无视奥义（必杀）抗性buff
BattleSkill.SKILL_INFUENCE_RESULT_FOR_113 = 113	-- 庇护效果
BattleSkill.SKILL_INFUENCE_RESULT_FOR_114 = 114	-- 控制率降低
BattleSkill.SKILL_INFUENCE_RESULT_FOR_115 = 115	-- 受到神兽伤害降低
BattleSkill.SKILL_INFUENCE_RESULT_FOR_116 = 116	-- 伤害吸收
BattleSkill.SKILL_INFUENCE_RESULT_FOR_117 = 117	-- 复仇4(究极反击)概率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_118 = 118	-- 复仇4(究极反击)伤害倍数
BattleSkill.SKILL_INFUENCE_RESULT_FOR_119 = 119	-- 复仇4(究极反击)效果
BattleSkill.SKILL_INFUENCE_RESULT_FOR_120 = 120 -- 睡眠效果（同麻痹）
BattleSkill.SKILL_INFUENCE_RESULT_FOR_121 = 121 -- 伤害吸收2
BattleSkill.SKILL_INFUENCE_RESULT_FOR_122 = 122 -- 庇护效果2
BattleSkill.SKILL_INFUENCE_RESULT_FOR_123 = 123 -- 小技能伤害降低
BattleSkill.SKILL_INFUENCE_RESULT_FOR_124 = 124 -- 被治疗率增加
BattleSkill.SKILL_INFUENCE_RESULT_FOR_125 = 125 -- 复活概率降低
BattleSkill.SKILL_INFUENCE_RESULT_FOR_126 = 126 -- 计数器增加
BattleSkill.SKILL_INFUENCE_RESULT_FOR_127 = 127 -- 计数器减少
BattleSkill.SKILL_INFUENCE_RESULT_FOR_128 = 128 -- 计数器清空
BattleSkill.SKILL_INFUENCE_RESULT_FOR_129 = 129 -- 石化2(停滞)
BattleSkill.SKILL_INFUENCE_RESULT_FOR_130 = 130 -- 吸血率降低
BattleSkill.SKILL_INFUENCE_RESULT_FOR_131 = 131 -- 生命链接
BattleSkill.SKILL_INFUENCE_RESULT_FOR_132 = 132 -- 计数器增加2（添加惩戒爪击）
BattleSkill.SKILL_INFUENCE_RESULT_FOR_133 = 133 -- 计数器减少2（减少惩戒爪击）
BattleSkill.SKILL_INFUENCE_RESULT_FOR_134 = 134 -- 计数器清空2（清空惩戒爪击）
BattleSkill.SKILL_INFUENCE_RESULT_FOR_135 = 135	-- 复仇5(神罚)概率
BattleSkill.SKILL_INFUENCE_RESULT_FOR_136 = 136	-- 复仇5(神罚)伤害倍数
BattleSkill.SKILL_INFUENCE_RESULT_FOR_137 = 137	-- 复仇5(神罚)效果
BattleSkill.SKILL_INFUENCE_RESULT_FOR_138 = 138 -- 伤害吸收3
BattleSkill.SKILL_INFUENCE_RESULT_FOR_139 = 139 -- 生命链接2（守护之心）
BattleSkill.SKILL_INFUENCE_RESULT_FOR_140 = 140 -- 破除庇护效果
BattleSkill.SKILL_INFUENCE_RESULT_FOR_141 = 141 -- 破除伤害吸收效果

-- 所有的吸收伤害的技能类型
BattleSkill.ALL_SKILL_DAMAGE_TO_HEATH = {BattleSkill.SKILL_INFUENCE_RESULT_FOR_116, BattleSkill.SKILL_INFUENCE_RESULT_FOR_121, BattleSkill.SKILL_INFUENCE_RESULT_FOR_138}

-- 所有的庇护效果的技能类型
BattleSkill.ALL_SKILL_PROTECT_DAMAGE = {BattleSkill.SKILL_INFUENCE_RESULT_FOR_113, BattleSkill.SKILL_INFUENCE_RESULT_FOR_122}

-- 所有的生命链接的技能类型
BattleSkill.ALL_SKILL_LIFE_CHAIN = {BattleSkill.SKILL_INFUENCE_RESULT_FOR_131, BattleSkill.SKILL_INFUENCE_RESULT_FOR_139}

function BattleSkill:ctor()
    --出手方标识(0:我方 1:敌方)
    self.attackerTag =  0

    --出手方坐标
    self.attacterCoordinate =  0

    --作用数量
    self.effectAmount =  0

    --技能模板id
    self.skillMould =  nil

    --技能效用
    self.skillInfluence =  nil

    --承受方标识
    self.byAttackerTag =  0

    --承受方位置
    self.byAttackerCoordinate =  0

    --影响类型
    self.effectType =  0

    --影响值
    self.effectValue =  0

    --是否显示
    self.isDisplay =  1

    --影响回合
    self.effectRound =  0

    --承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加格挡)
    self.bearState =  0

    --掉落卡牌数量
    self.dropCardNo =  0

    --掉落道具数量
    self.dropPropNo =  0

    --掉落装备数量
    self.dropEquipmentNo =  0

    --掉落类型 0道具 1武将 2装备
    self.dropType =  0

    --生存状态(0:存活 1:死亡 2:反击 3:复活)
    self.aliveState =  0

    --清除的BUFF类型
    self.clearBuffState =  0

    --相克状态
    self.restrain =  0

    --计算战船死亡掉落
    --@param userInfo
    --@param byAttackObject
    --如果是攻击技能则计算闪避、暴击和挡格
    --击杀恢复生命
    --效用n模板ID
    --如果是攻击技能则计算闪避、暴击和挡格
    --击杀恢复生命
    --效用n模板ID
    self.reattackObject =  nil

    self.formulaInfo = 0

    -- 真实伤害
    self.realDamageValue = 0

    -- 天赋结果类型26 对承受者造成的伤害
    self.damageByTalentType26 = 0

    -- 计数器种类
    self.counterType = 0
    -- 计数器数量
    self.counterCount = 0
end

function BattleSkill:executeNextSkillInfluenceEx(attackObject, byAttackObjects, userInfo, fightModule, effectBuffer, nextSkillInfluenceInstance, resultType)
	-- 将要触发的天赋
	local nextSkillInfluence = nil
	if nextSkillInfluenceInstance or self.skillInfluence.nextSkillInfluence > 0 then
		nextSkillInfluence = nextSkillInfluenceInstance or ConfigDB.load("skill_influence", self.skillInfluence.nextSkillInfluence)
	end
	
	-- 如果将要触发的技能效用是生命链接
	if nextSkillInfluence and BattleSkill.isLifeChainSkill(nextSkillInfluence.skillCategory) then
		-- 计算触发概率
		if nextSkillInfluence.additionEffectProbability < math.random(1, 100) then
			return
		end

		-- 将之后的触发概率调整为100%
		nextSkillInfluence.additionEffectProbability = 100

		-- 执行天赋类型43的技能标记数+1
		local skillInfluenceId = tonumber(nextSkillInfluence.id)
		if (resultType and resultType == 43) and (attackObject.skillTriggerListFor43 and attackObject.skillTriggerListFor43[skillInfluenceId]) then
			attackObject.skillTriggerListFor43[skillInfluenceId] = attackObject.skillTriggerListFor43[skillInfluenceId] + 1
		end

		-- 执行生命链接，释放时，清空本方的生命链接效果
		local teamObjects = {}
		if attackObject.battleTag == 0 then
			teamObjects = fightModule.attackObjects
		else
			teamObjects = fightModule.byAttackObjects
		end
		for _, battleObject in pairs(teamObjects) do
			if (battleObject ~= nil and battleObject.isDead ~= true and battleObject.revived ~= true) then
				local bSuccess = battleObject:removeBuffEffect(nextSkillInfluence.skillCategory)

				if bSuccess then
					-- 表现层清理掉buff
					local bs = BattleSkill:new()
					bs.byAttackerTag = battleObject.battleTag
					bs.byAttackerCoordinate = battleObject.coordinate
					bs.isDisplay = 0
					bs.effectType = nextSkillInfluence.skillCategory
					bs.effectValue = 0
					bs.effectRound = -1
					bs:writeSkillAttack(userInfo, attackObject, battleObject, fightModule, effectBuffer)
					self.effectAmount = self.effectAmount + 1
				end
			end
		end

		for i, byAttackObject in pairs(byAttackObjects) do
			self:executeNextSkillInfluence(attackObject, byAttackObject, userInfo, fightModule, effectBuffer, nextSkillInfluence, resultType)
		end
	else
		-- 如果将要触发的技能效用不是生命链接
		for i, byAttackObject in pairs(byAttackObjects) do
			self:executeNextSkillInfluence(attackObject, byAttackObject, userInfo, fightModule, effectBuffer, nextSkillInfluenceInstance, resultType)
		end
	end
end

function BattleSkill:executeNextSkillInfluence(attackObject, byAttackObject, userInfo, fightModule, effectBuffer, nextSkillInfluenceInstance, resultType)
	local isEffective = false
	if nextSkillInfluenceInstance or self.skillInfluence.nextSkillInfluence > 0 then
		local nextSkillInfluence = nextSkillInfluenceInstance or ConfigDB.load("skill_influence", self.skillInfluence.nextSkillInfluence)
	    local battleSkill = BattleSkill:new()
	    battleSkill.attackerTag = self.attackerTag
	    battleSkill.attacterCoordinate = self.attacterCoordinate
	    battleSkill.skillMould = self.skillMould
	    battleSkill.skillInfluence = nextSkillInfluence
	    nextSkillInfluence.level = self.skillInfluence.level
	    battleSkill.formulaInfo = battleSkill.skillInfluence.formulaInfo
	    if(self.attackerTag == 0) then
	        if (nextSkillInfluence.influenceGroup == 0) then
	            battleSkill.byAttackerTag = 0
	        else
	            battleSkill.byAttackerTag = 1
	        end             
	    else
	        if (nextSkillInfluence.influenceGroup == 0) then
	            battleSkill.byAttackerTag = 1
	        else
	            battleSkill.byAttackerTag = 0
	        end 
	    end
	    battleSkill.effectType = nextSkillInfluence.skillCategory
	    battleSkill.effectRound = nextSkillInfluence.influenceDuration

	    local effectArray1 = FightUtil.computeSkillEffect(battleSkill, battleSkill.skillMould, battleSkill.skillInfluence, attackObject, byAttackObject, userInfo, fightModule, effectBuffer)
		if effectArray1[3] == 1 then
			-- ...
			-- A，B两个效用，B是由A触发的效用，触发B时，因承受者免疫负面buff，则效用B不生效，技能类型78（免疫控制）生效，因此要添加到A效用的效用承受数量（_skf.defenderCount）里
			self.effectAmount = self.effectAmount + battleSkill.effectAmount
		else
			local skillInfluenceId = tonumber(battleSkill.skillInfluence.id)
			if not BattleSkill.isLifeChainSkill(battleSkill.skillInfluence.skillCategory) then
				-- 天赋类型43
				if (resultType and resultType == 43) and (attackObject.skillTriggerListFor43 and attackObject.skillTriggerListFor43[skillInfluenceId]) then
					attackObject.skillTriggerListFor43[skillInfluenceId] = attackObject.skillTriggerListFor43[skillInfluenceId] + 1
				end
			end

			if(battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
					 and effectArray1[3] == 1) then
					battleSkill.isDisplay = 0
			end
			
			if(battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_ADD_KILL) then
				battleSkill.bearState = 0
			end

			battleSkill.effectValue = effectArray1[1]
			battleSkill.effectRound =  effectArray1[2]
			battleSkill.clearBuffState = effectArray1[4]
			battleSkill.realDamageValue = effectArray1[5]

			if(effectArray1[3] > 0)then
				battleSkill.bearState =  effectArray1[3]
			end

			battleSkill.byAttackerTag = byAttackObject.battleTag
			battleSkill.byAttackerCoordinate = byAttackObject.coordinate

			battleSkill:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
			-- 效用触发且生效
			isEffective = true
		end

		if nextSkillInfluence.nextSkillInfluence > 0 then
			nextSkillInfluenceInstance = ConfigDB.load("skill_influence", nextSkillInfluence.nextSkillInfluence)
			if (nil ~= nextSkillInfluenceInstance) then
				self:executeNextSkillInfluence(attackObject, byAttackObject, userInfo, fightModule, effectBuffer, nextSkillInfluenceInstance)
			end
		end
	end
	return isEffective
end

function BattleSkill:processAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, resultBuffer)
	--[[输出攻击过程信息
    ___writeDebugInfo("\t\t进行效用攻击：" .. "当前的攻击方：" .. attackObject.battleTag .. "\t" 
    	.. "当前的攻击方站位：" .. attackObject.coordinate .. "\t" 
    	.. "效用ID：" .. self.skillInfluence.id .. "\t" 
    	.. "\r\n")
    --]]

	-- _crint("技能效用ID:", self.skillInfluence.id)

	local attackObjects = nil

	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	--_crint ("endureDirection: " .. endureDirection[1] .. ", " ..endureDirection[2] .. ", " .. attackObject.coordinate)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	if(attackObject.isAction ~= true) then
		attackObject.isAction = true
		self:restoreStatus()
		self.effectAmount = self.effectAmount + 1
		self.byAttackerTag = attackObject.battleTag
		self.byAttackerCoordinate = attackObject.coordinate
		self.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
		self.isDisplay = 0
		if(attackObject.skillPoint >= FightModule.MAX_SP and true ~= attackObject.isDisSp) and true ~= attackObject.skipSuperSkillMould then
			self.effectType = BattleSkill.SKILL_INFLUENCE_DAMAGESP
			self.effectValue = attackObject.skillPoint * 1000
			attackObject:subSkillPoint(self.effectValue)
			attackObject.totalSkillPoint = self.effectValue
		elseif(true ~= attackObject.isSpDisable) then
			local addSpValue = FightModule.ATTACK_SP_ADD_VAULE + attackObject.attackAdditionSpValue
			self.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
			self.effectValue = addSpValue
			self.effectValue = attackObject:addSkillPoint(addSpValue, true)
		end
		if attackObject.isNeedAddSkillPoint == false then
			attackObject:addZomSkillPoint(FightModule.ATTACK_SP_ADD_VAULE)
		end
		--_crint ("Exit before write")
		self:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- 触发出手前的天赋
		if attackObject.battleTag == 0 then
			attackObjects = fightModule.attackObjects
		else
			attackObjects = fightModule.byAttackObjects
		end
		TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK_BEFORE, attackObject, byAttackObject, self.skillMould, fightModule)
		attackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_ATTACK_BEFORE, fightModule, userInfo, attackObject, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )

		-- 触发时机13，究极潜力专用
		if attackObject.bHasHandlePotentiality == false then
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_13, attackObject, byAttackObject, self.skillMould, fightModule)
			attackObject:influenceTalentJudgeResults(TalentConstant.JUDGE_OPPORTUNITY_13, fightModule, userInfo, attackObject, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )
			attackObject.bHasHandlePotentiality = true
		end

		-- 如果放的是必杀技，且技能效用类型是攻击类型时
		if attackObject._isAction == true and self.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP then
			if attackObject.bHasHandleTalentWhenSpAttack == false then
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_14, attackObject, byAttackObject, self.skillMould, fightModule)
				attackObject:influenceTalentJudgeResults(TalentConstant.JUDGE_OPPORTUNITY_14, fightModule, userInfo, attackObject, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )
				attackObject.bHasHandleTalentWhenSpAttack = true
			end
		end

		-- 17 我方神兽释放技能时
		-- 18 敌方神兽释放技能时
		if attackObject.isAnimal == true and attackObject.animalAttackFlag == false then
			local defenderObjects = {}
			if attackObject.battleTag == 0 then
				defenderObjects = fightModule.byAttackObjects
			else
				defenderObjects = fightModule.attackObjects
			end

			local talentJudgeType = -1
			if attackObject.battleTag == 0 then
				talentJudgeType = TalentConstant.JUDGE_OPPORTUNITY_17
			else
				talentJudgeType = TalentConstant.JUDGE_OPPORTUNITY_18
			end

			for _, v in pairs(attackObjects) do
				if (v ~= nil and v.isDead ~= true and v.revived ~= true) then
					TalentJudge:judge(talentJudgeType, v, nil, self.skillMould, fightModule)
					v:influenceTalentJudgeResults( talentJudgeType, fightModule, userInfo, v, nil, byAttackCoordinates, attackObjects, defenderObjects, self, effectBuffer )
				end
			end

			attackObject.animalAttackFlag = true
		end
	end
	
	local count=0
	
	attackObject.reanaAttackDamage = 0

	-- 设置造成伤害的目标
	if self.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP then
		attackObject.damageTargets = {}
		for _, byAttackCoordinate in pairs(byAttackCoordinates) do
			local byAttackObject = byAttackObjects[byAttackCoordinate]
			if (byAttackObject ~= nil and byAttackObject.isDead ~= true and byAttackObject.revived ~= true) then
				table.insert(attackObject.damageTargets, byAttackObject)
			end
		end
	elseif BattleSkill.isLifeChainSkill(self.skillInfluence.skillCategory) then
		-- 生命链接释放时，清空本方的生命链接效果
		for _, battleObject in pairs(byAttackObjects) do
			if (battleObject ~= nil and battleObject.isDead ~= true and battleObject.revived ~= true) then
				local bSuccess = battleObject:removeBuffEffect(self.skillInfluence.skillCategory)

				if bSuccess then
					-- 表现层清理掉buff
					local bs = BattleSkill:new()
					bs.byAttackerTag = battleObject.battleTag
					bs.byAttackerCoordinate = battleObject.coordinate
					bs.isDisplay = 0
					bs.effectType = self.skillInfluence.skillCategory
					bs.effectValue = 0
					bs.effectRound = -1
					bs:writeSkillAttack(userInfo, attackObject, battleObject, fightModule, effectBuffer)
					self.effectAmount = self.effectAmount + 1
				end
			end
		end
	end

	-- 清除掉角色身上的lifeChain的buff
	for _, skillCategory in pairs(BattleSkill.ALL_SKILL_LIFE_CHAIN) do
		local fightBuff = attackObject:getBuffEffect(skillCategory)
		if fightBuff and fightBuff.effectRound <= 0 then
			attackObject:removeBuffEffect(skillCategory)

			-- 表现层清理掉buff
			local bs = BattleSkill:new()
			bs.byAttackerTag = attackObject.battleTag
			bs.byAttackerCoordinate = attackObject.coordinate
			bs.isDisplay = 0
			bs.effectType = skillCategory
			bs.effectValue = 0
			bs.effectRound = -1
			bs:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
		end
	end

	
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		count = count + 1
		self:restoreStatus()
		-- attackObject.isCritical=false
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		attackObject.lastByAttackTarget = byAttackObject
		if(nil == byAttackObject or byAttackObject.isDead or byAttackObject.revived) then
			--continue
			--_crint ("Target attack obj nil")
		else
			--[[输出攻击过程信息
		    ___writeDebugInfo("\t\t\t" .. "当前的承受方：" .. byAttackObject.battleTag .. "\t" .. "当前的承受方站位：" .. byAttackObject.coordinate .. "\r\n")
		    --]]

			byAttackObject.reboundDamageValueResult = 0
			byAttackObject.damageToHealthValue = 0
			byAttackObject.beAttackedDamageValue = 0

			local currentHp = byAttackObject.healthPoint
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			-- 技能类型为攻击类型
			if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
				attackObject.isCritical=false
				attackObject.isByRetain = false

				attackObject:restoreAttackState()
				byAttackObject:restoreAttackState()

				-- 设置攻击的来源者
				byAttackObject.attackFromObject = attackObject
				
				local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject);
				
				if (restrainObj ~= nil) then
					self.restrain = 1
				else
					self.restrain = 0
				end
				----_crint ("has restrain: " .. self.restrain)
				--os.exit()
				RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
				RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)

				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					attackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_ATTACK, fightModule, userInfo, attackObject, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )
					byAttackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, fightModule, userInfo, byAttackObject, attackObject, byAttackCoordinates, byAttackObjects, attackObjects, self, effectBuffer )
				end

				FightUtil.computeEvasion(self.skillMould, self.skillInfluence, attackObject, byAttackObject)

				-- 当被击方不是攻击者自己且被击方没有处于无敌状态时，计算伤害吸收效果值
				local isSelf = (attackObject.battleTag == byAttackObject.battleTag) and (attackObject.coordinate == byAttackObject.coordinate)
				if (not isSelf) and byAttackObject.isNoDamage == false then
					FightUtil.computeDamageToHealthEffectValue(byAttackObject)
				end

				if(byAttackObject.isEvasionSurely) then
					byAttackObject.isEvasion=true
					byAttackObject.isEvasionSurely=false
				end
				if(true ~= byAttackObject.isEvasion) then
					if attackObject.isAnimal == true then
						FightUtil.computeAnimalCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
					else
						FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
					end

					-- 计算格挡
					FightUtil.computeRetain(self.skillMould, self.skillInfluence, attackObject, byAttackObject)

					if(attackObject.isCritical) then
						self.bearState = 2
						----_crint ("self.bearState = 2")
						--os.exit()
					end
					if(byAttackObject.isRetain) then
						attackObject.isByRetain = true
						if(self.bearState == 2) then
							self.bearState = 4
						else	
							self.bearState = 3
						end
						if(byAttackObject.canReAttack) then						
							self.aliveState = 2
							-- for i = 1, table.maxn(byAttackObjects) do
							for i, v in pairs(byAttackObjects) do
								if(nil ~= byAttackObjects[i]) then
									byAttackObjects[i].canReAttack=false
								end
							end
						end
					end
				else
					self.bearState = 1
				end
			elseif self.effectType == BattleSkill.SKILL_INFUENCE_RESULT_FOR_37 then
				if(attackObject.isCritical) then
					self.bearState = 2
					----_crint ("self.bearState = 2")
					--os.exit()
				end
				if(attackObject.isByRetain) then
					if(self.bearState == 2) then
						self.bearState = 4
					else	
						self.bearState = 3
					end
				end
			else
				self.bearState = 0
			end

			-- 15 被暴击时判断
			-- 16 暴击时判断
			if self.bearState == 2 or self.bearState == 4 then
				-- 设置被暴击状态
				byAttackObject.isBeCritical = true

				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_15, byAttackObject, attackObject, self.skillMould, fightModule)
				byAttackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_15, fightModule, userInfo, byAttackObject, attackObject, byAttackCoordinates, byAttackObjects, attackObjects, self, effectBuffer )
				
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_16, attackObject, byAttackObject, self.skillMould, fightModule)
				attackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_16, fightModule, userInfo, attackObject, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )

				-- print("被暴击时判断 攻击者身上复仇状态 = ", attackObject.coordinate, attackObject.battleTag, attackObject.ptvf88, attackObject.ptvf89)
				-- print("被暴击时判断 被击者身上复仇状态 = ", byAttackObject.coordinate, byAttackObject.battleTag, byAttackObject.ptvf88, byAttackObject.ptvf89)
			end

			local effectArray = nil
			if(self.skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_CLEAR_BUFF) then
				--_crint ("effectArray is clear buff")
				effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			elseif(self.skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_104) then
				-- 清除所有减益buff
				effectArray = FightUtil.computeAllDebuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			elseif(self.skillInfluence.skillCategory == BattleSkill.SKILL_INFUENCE_RESULT_FOR_107) then
				-- 清除所有增益buff
				effectArray = FightUtil.computeAllGainBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			else
				--_crint ("effectArray is computeSkillEffect")
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject, userInfo, fightModule, effectBuffer)
				if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
				
				if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_ADD_KILL) then
					self.bearState = 0
				end
			end
			attackObject.totalSkillPoint = 0
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			self.clearBuffState = effectArray[4]

			-- 真实伤害
			self.realDamageValue = effectArray[5]

			-- 处理吸收伤害后转化的血量
			if self.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP then
				local beAttackedDamageValue = byAttackObject.beAttackedDamageValue
				local damageToHealthValue = byAttackObject.damageToHealthValue

				if beAttackedDamageValue > 0 and damageToHealthValue > 0 then
					local recoveryHealth = byAttackObject.healthMaxPoint - byAttackObject.healthPoint
					local beAttackValue = math.floor(beAttackedDamageValue * damageToHealthValue)
					if recoveryHealth > beAttackValue then
						recoveryHealth = beAttackValue
					end
					-- print("处理吸收伤害后转化的血量 = ", recoveryHealth)
					if recoveryHealth > 0 then
						local bs = BattleSkill:new()
						bs.byAttackerTag = byAttackObject.battleTag
						bs.byAttackerCoordinate = byAttackObject.coordinate
						bs.isDisplay = 1
						bs.effectType = BattleSkill.SKILL_INFLUENCE_ADDHP
						bs.effectValue = recoveryHealth
						byAttackObject:addHealthPoint(recoveryHealth)
						bs:writeSkillAttack(userInfo, byAttackObject, byAttackObject, fightModule, effectBuffer)
						self.effectAmount = self.effectAmount + 1
					end
					byAttackObject.beAttackedDamageValue = 0
					byAttackObject.damageToHealthValue = 0
				end
			end

			-- 新判断机制_遭受致死攻击时
			-- print("新判断机制_遭受致死攻击时11 byAttackObject.healthPoint = ", byAttackObject.healthPoint)
			if byAttackObject.healthPoint < 1 then
				byAttackObject:setHealthPoint(0)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_19, byAttackObject, attackObject, self.skillMould, fightModule)
				byAttackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_19, fightModule, userInfo, byAttackObject, attackObject, byAttackCoordinates, byAttackObjects, attackObjects, self, effectBuffer )
			end

			-- 重置攻击的来源者
			byAttackObject.attackFromObject = nil

			-- print("新判断机制_遭受致死攻击时22 byAttackObject.healthPoint = ", byAttackObject.healthPoint)
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				byAttackObject.isDead = true
				-- _crint("角色死亡3：", attackObject.battleTag, attackObject.coordinate, byAttackObject.battleTag, byAttackObject.coordinate, self.effectValue, byAttackObject.healthMaxPoint, byAttackObject.healthPoint)
				byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			else
				if(self.aliveState == 2) then
					if(attackObject.healthPoint < 1) then
						if(attackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount - 1
							fightModule.attackObjects[attackObject.coordinate] = nil
						else
							fightModule.byAttackCount = fightModule.byAttackCount - 1
							fightModule.byAttackObjects[attackObject.coordinate] = nil
						end
						attackObject.isDead = true
						-- _crint("角色死亡4：", attackObject.battleTag, attackObject.coordinate)
						self.aliveState = 1
					else
						self.reattackObject = attackObject
					end
					local talentJudgeResultList = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
					if(#talentJudgeResultList > 0) then
						self.aliveState = 0
						self.reattackObject = nil
					end
				end
			end

			-- if nil ~= byAttackObject.talentJudgeResultList then
			-- 	for i, v in pairs(byAttackObject.talentJudgeResultList) do
			-- 		v:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
			-- 	end
			-- end

			if(effectArray[3] > 0)then
				self.bearState =  effectArray[3]
			end
			
			local dspValue = 0
			-- 被击怒气
			if byAttackObject.byAttackDamageAddSp == 1 then
				dspValue = (currentHp - byAttackObject.healthPoint) / byAttackObject.healthMaxPoint * FightModule.MAX_SP
			end


			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if byAttackObject.isDead == true then
					if attackObject.killTargetAddSp == 1 then
						if attackObject.skillPoint <= FightModule.MAX_SP then
							local bs = BattleSkill:new()
							bs.byAttackerTag = attackObject.battleTag
							bs.byAttackerCoordinate = attackObject.coordinate
							bs.isDisplay = 0
							bs.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
							bs.effectValue = FightModule.KILL_TARGET_SP_ADD_VAULE
							attackObject:addSkillPoint(FightModule.KILL_TARGET_SP_ADD_VAULE)
							bs:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
							self.effectAmount = self.effectAmount + 1
						end
					end

					-- 3自己击杀对手时判断
					TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD, attackObject, byAttackObject, self.skillMould, fightModule)
					attackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD, fightModule, userInfo, attackObject, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )

					-- 11对手死亡时判断
					for ii, vv in pairs(attackObjects) do
						if nil ~= vv and vv.isDead ~= true then
							TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD_GLOBAL, vv, byAttackObject, self.skillMould, fightModule)
							vv:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD_GLOBAL, fightModule, userInfo, vv, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )
						end
					end
					-- attackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD_GLOBAL, fightModule, userInfo, attackObject, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )

					-- 2自身死亡时判断
					TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_SELF_DEAD, byAttackObject, attackObject, self.skillMould, fightModule)
					byAttackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_SELF_DEAD, fightModule, userInfo, byAttackObject, attackObject, byAttackCoordinates, byAttackObjects, attackObjects, self, effectBuffer )

					-- 7友军阵亡时判定
					for m, n in pairs(byAttackObjects) do
						if nil ~= n and true ~= n.isDead then
							TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_CAMP_ROLE_DEATH, n, attackObject, self.skillMould, fightModule)
							n:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_CAMP_ROLE_DEATH, fightModule, userInfo, n, attackObject, byAttackCoordinates, byAttackObjects, attackObjects, self, effectBuffer )
						end
					end
				end

				-- print("回合数 = ", fightModule.roundCount)
				-- print("攻击者身上复仇状态 = ", attackObject.coordinate, attackObject.battleTag, attackObject.ptvf88, attackObject.ptvf89)
				-- print("被击者身上复仇状态 = ", byAttackObject.coordinate, byAttackObject.battleTag, byAttackObject.ptvf88, byAttackObject.ptvf89)

				-- 复仇
				-- 如果技能效用类型是攻击类型，并且复仇概率和复仇伤害倍数都大于0，则触发复仇
				if self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP and byAttackObject.ptvf88 > 0 and byAttackObject.ptvf89 > 0 then
					local r = math.random(1, 100)
					local probability = byAttackObject.ptvf88 * 100
					if r <= probability then
						local bs = BattleSkill:new()
						bs.byAttackerTag = attackObject.battleTag
						bs.byAttackerCoordinate = attackObject.coordinate
						bs.isDisplay = 1
						bs.effectType = BattleSkill.SKILL_INFLUENCE_DAMAGEHP
						bs.effectValue = byAttackObject.attack * byAttackObject.ptvf89

						-- pvp战报功能
						byAttackObject:addTotalDamageValue(bs.effectValue)
						attackObject:addTotalBearValue(bs.effectValue)

						attackObject:subHealthPoint(bs.effectValue)

						if(attackObject.healthPoint < 1) then
							if(attackObject.battleTag == 0) then
								fightModule.attackCount = fightModule.attackCount - 1
								fightModule.attackObjects[attackObject.coordinate] = nil
							else
								fightModule.byAttackCount = fightModule.byAttackCount - 1
								fightModule.byAttackObjects[attackObject.coordinate] = nil
							end
							attackObject.isDead = true
							-- 
							bs.aliveState = 1
							-- print("被复仇角色死亡：", attackObject.battleTag, attackObject.coordinate, byAttackObject.battleTag, byAttackObject.coordinate, bs.effectValue, attackObject.healthPoint)
						end

						bs:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
						self.effectAmount = self.effectAmount + 1

						-- 复仇
						local fightBuff_85 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_85)
						local fightBuff_86 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_86)

						-- 复仇2
						local fightBuff_89 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_89)
						local fightBuff_90 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_90)

						-- 复仇3
						local fightBuff_98 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_98)
						local fightBuff_99 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_99)

						-- 复仇4
						local fightBuff_117 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_117)
						local fightBuff_118 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_118)

						-- 复仇5
						local fightBuff_135 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_135)
						local fightBuff_136 = byAttackObject:getBuffEffect(BattleSkill.SKILL_INFUENCE_RESULT_FOR_136)

						-- 复仇效果显示
						local revengeEffectType = nil
						if fightBuff_85 and fightBuff_86 then
							revengeEffectType = BattleSkill.SKILL_INFUENCE_RESULT_FOR_87
						elseif fightBuff_89 and fightBuff_90 then
							revengeEffectType = BattleSkill.SKILL_INFUENCE_RESULT_FOR_91
						elseif fightBuff_98 and fightBuff_99 then
							revengeEffectType = BattleSkill.SKILL_INFUENCE_RESULT_FOR_100
						elseif fightBuff_117 and fightBuff_118 then
							revengeEffectType = BattleSkill.SKILL_INFUENCE_RESULT_FOR_119
						elseif fightBuff_135 and fightBuff_136 then
							revengeEffectType = BattleSkill.SKILL_INFUENCE_RESULT_FOR_137
						end

						-- print("fightBuff_85 = ", fightBuff_85, " fightBuff_86 = ", fightBuff_86, " fightBuff_89 = ", fightBuff_89, " fightBuff_90 = ", fightBuff_90)
						-- print("revengeEffectType = ", revengeEffectType)

						if revengeEffectType then
							local bs2 = BattleSkill:new()
							bs2.byAttackerTag = attackObject.battleTag
							bs2.byAttackerCoordinate = attackObject.coordinate
							bs2.isDisplay = 1
							bs2.effectType = revengeEffectType
							bs2.effectValue = 0
							bs2:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
							self.effectAmount = self.effectAmount + 1
						end
					end
				end

				if byAttackObject.reboundDamageValue > 0 then
					local reboundDamageValueResult = math.floor(math.min(attackObject.healthPoint - 1, byAttackObject.reboundDamageValueResult))

					if reboundDamageValueResult > 0 then
						-- 反弹伤害回复怒气
						local reboundDamageDspValue = reboundDamageValueResult / attackObject.healthMaxPoint * FightModule.MAX_SP
						if attackObject.skillPoint <= FightModule.MAX_SP then
							if reboundDamageDspValue > 0 then
								local bs = BattleSkill:new()
								bs.byAttackerTag = attackObject.battleTag
								bs.byAttackerCoordinate = attackObject.coordinate
								bs.isDisplay = 0
								bs.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
								bs.effectValue = reboundDamageDspValue
								bs.effectValue = attackObject:addSkillPoint(reboundDamageDspValue, true)
								bs:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
								self.effectAmount = self.effectAmount + 1
								-- _crint("反弹伤害回复怒气:", reboundDamageDspValue, reboundDamageValueResult, attackObject.healthMaxPoint, FightModule.MAX_SP)
							end
						end
						
						local bs = BattleSkill:new()
						bs.byAttackerTag = attackObject.battleTag
						bs.byAttackerCoordinate = attackObject.coordinate
						bs.isDisplay = 1
						bs.effectType = BattleSkill.SKILL_INFUENCE_RESULT_FOR_41
						bs.effectValue = reboundDamageValueResult

						-- pvp战报功能
						byAttackObject:addTotalDamageValue(bs.effectValue)
						attackObject:addTotalBearValue(bs.effectValue)

						attackObject:subHealthPoint(bs.effectValue)
						bs:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
						self.effectAmount = self.effectAmount + 1

						-- _crint("反弹：", bs.effectValue, byAttackObject.reboundDamageValue, "承受者的信息：", attackObject.battleTag, attackObject.coordinate)
					end
				end

				if byAttackObject.battleTag ~= attackObject.battleTag then

					if attackObject.inhaleHpDamagePercent > 0 then
						local inhaleHpDamageValueResult = math.floor(attackObject.inhaleHpDamagePercent * self.effectValue)
						if inhaleHpDamageValueResult > 0 then
							local bs = BattleSkill:new()
							bs.byAttackerTag = attackObject.battleTag
							bs.byAttackerCoordinate = attackObject.coordinate
							bs.isDisplay = 1
							bs.effectType = BattleSkill.SKILL_INFLUENCE_DRAINS_HP
							bs.effectValue = inhaleHpDamageValueResult
							attackObject:addHealthPoint(bs.effectValue)
							bs:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
							self.effectAmount = self.effectAmount + 1

							-- _crint("吸血：", bs.effectValue, attackObject.inhaleHpDamagePercent, "承受者的信息：", attackObject.battleTag, attackObject.coordinate)
						end
					end
				end

				if byAttackObject.skillPoint <= FightModule.MAX_SP then
					if dspValue > 0 then
						local bs = BattleSkill:new()
						bs.byAttackerTag = byAttackObject.battleTag
						bs.byAttackerCoordinate = byAttackObject.coordinate
						bs.isDisplay = 0
						bs.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
						bs.effectValue = dspValue
						bs.effectValue = byAttackObject:addSkillPoint(dspValue, true)
						bs:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
						self.effectAmount = self.effectAmount + 1
					end
				end

				-- 处理庇护效果
				if byAttackObject.battleTag ~= attackObject.battleTag then
					-- print("处理庇护效果!!")
					for _, skillCategory in pairs(BattleSkill.ALL_SKILL_PROTECT_DAMAGE) do
						local nums = 0
						for _, v in ipairs(byAttackObject.protectBigDamageList) do
							if v.skillCategory == skillCategory then
								nums = nums + 1
							end
						end
					 	if nums == 0 then
							byAttackObject:clearBuffBySkilCategory(skillCategory)

							local bs = BattleSkill:new()
							bs.byAttackerTag = byAttackObject.battleTag
							bs.byAttackerCoordinate = byAttackObject.coordinate
							bs.isDisplay = 1
							bs.effectType = skillCategory
							bs.effectValue = 0
							bs.effectRound = -1
							bs:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
							self.effectAmount = self.effectAmount + 1
						end
					end
				end

				--伤害吸收buff失效处理
				if byAttackObject.battleTag ~= attackObject.battleTag then
					-- print("伤害吸收buff失效处理!!")
					for _, skillCategory in pairs(BattleSkill.ALL_SKILL_DAMAGE_TO_HEATH) do
						local nums = 0
						for _, v in ipairs(byAttackObject.damageToHealthList) do
							if v.skillCategory == skillCategory then
								nums = nums + 1
							end
						end
					 	if nums == 0 then
							byAttackObject:clearBuffBySkilCategory(skillCategory)

							local bs = BattleSkill:new()
							bs.byAttackerTag = byAttackObject.battleTag
							bs.byAttackerCoordinate = byAttackObject.coordinate
							bs.isDisplay = 1
							bs.effectType = skillCategory
							bs.effectValue = 0
							bs.effectRound = -1
							bs:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
							self.effectAmount = self.effectAmount + 1
						end
					end
				end

				-- 处理生命链接显示数据
				self:processShowLifeChain(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)

		        -- -- 如果是青龙兽，并且减伤属性ptvf62大于0，则重置，就是减伤只能持续一次攻击
		        -- if tonumber(byAttackObject.shipMould) == 10 then
		        --     byAttackObject.ptvf62 = 0
		        --     byAttackObject:clearBuffBySkilCategory(26)
		        -- end

		        -- 清理被击对象身上的 当次被击生效 的buff
		        if tonumber(self.effectType) == 0 then
		        	byAttackObject:clearBuffByDisposable()
		        end

				if byAttackObject.isDead == true then
					-- 死亡时被复活概率=	被复活概率[77]	
					-- 死亡时被复活继承血量=	被复活继承血量[80]	
					-- 死亡时被复活继承怒气=	被复活继承怒气[81]	
					if math.random(1, 100) <= byAttackObject.ptvf77 and byAttackObject.reviveCount < 1 then
						local oldsp = byAttackObject.skillPoint
						byAttackObject:setHealthPoint(byAttackObject.healthMaxPoint * byAttackObject.ptvf80)
						byAttackObject:setSkillPoint(byAttackObject.skillPoint * byAttackObject.ptvf81)
						-- byAttackObject.isAction = true
						byAttackObject.isDead = false
						byAttackObject.unload = false
						byAttackObject.revived = true
						byAttackObject.reviveRoundCount = fightModule.roundCount
				        byAttackObject.reviveCount = byAttackObject.reviveCount + 1
				        byAttackObject:nextBattleClearBuff(true)
					    self.aliveState = 3
					    byAttackObjects[byAttackCoordinate] = byAttackObject

					    if (byAttackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount + 1
						else
							fightModule.byAttackCount = fightModule.byAttackCount + 1
						end

					    local bs = BattleSkill:new()
						bs.byAttackerTag = byAttackObject.battleTag
						bs.byAttackerCoordinate = byAttackObject.coordinate
						bs.isDisplay = 1
						bs.effectType = BattleSkill.SKILL_INFUENCE_RESULT_FOR_79
						bs.effectValue = 0
						bs.effectRound = 2
						bs.aliveState = 3
						bs:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
						self.effectAmount = self.effectAmount + 1
						--> __crint("被复活后的信息：", byAttackObject.battleTag, byAttackObject.coordinate, byAttackObject.healthMaxPoint, byAttackObject.healthPoint, oldsp, byAttackObject.skillPoint)
					end
				end

				if byAttackObject.isDead == true then
					-- 死亡时复活概率=	if( 复活概率[76] = 0 , 复活概率[76] , 复活概率[76] + 增加复活概率[82])
					-- 死亡时复活继承血量=	复活继承血量[78] + 增加复活继承血量[83]	
					-- 死亡时复活继承怒气=	复活继承怒气[79]
					if byAttackObject.ptvf76 > 0 and byAttackObject.reviveCount < 1 then
						if math.random(1, 100) <= (byAttackObject.ptvf76 + byAttackObject.ptvf82) then
							local oldsp = byAttackObject.skillPoint
							byAttackObject:setHealthPoint(byAttackObject.healthMaxPoint * (byAttackObject.ptvf78 + byAttackObject.ptvf83))
							byAttackObject:setSkillPoint(byAttackObject.skillPoint * byAttackObject.ptvf79)
							-- byAttackObject.isAction = true
							byAttackObject.isDead = false
							byAttackObject.unload = false
							byAttackObject.revived = true
							byAttackObject.reviveRoundCount = fightModule.roundCount
					        byAttackObject.reviveCount = byAttackObject.reviveCount + 1
					        byAttackObject:nextBattleClearBuff(true)
					        self.aliveState = 3
					        byAttackObjects[byAttackCoordinate] = byAttackObject

					        if (byAttackObject.battleTag == 0) then
								fightModule.attackCount = fightModule.attackCount + 1
							else
								fightModule.byAttackCount = fightModule.byAttackCount + 1
							end

					        local bs = BattleSkill:new()
							bs.byAttackerTag = byAttackObject.battleTag
							bs.byAttackerCoordinate = byAttackObject.coordinate
							bs.isDisplay = 1
							bs.effectType = BattleSkill.SKILL_INFUENCE_RESULT_FOR_79
							bs.effectValue = 0
							bs.effectRound = 2
							bs.aliveState = 3
							bs:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
							self.effectAmount = self.effectAmount + 1
					        --> __crint("复活后的信息：", byAttackObject.battleTag, byAttackObject.coordinate, byAttackObject.healthMaxPoint, byAttackObject.healthPoint, oldsp, byAttackObject.skillPoint)
						end
					end
				end
			end
			if 1 == effectArray[3] then
				-- print("未触发，不传结果数据")
			else
				if (true == byAttackObject.isNoDamage) then
					self.isDisplay = 2 -- 绘制承受动作和承受动画，但不绘制伤害数字
				end
				self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
				self.effectAmount = self.effectAmount + 1
				attackObject:addTotalEffectDamage(self.effectValue)

				self:executeNextSkillInfluence(attackObject, byAttackObject, userInfo, fightModule, effectBuffer)
			end


			if(self:checkSkillAndTalent(attackObject) and count < #byAttackCoordinates)then
				--continue
			else
				-- print("---------------self.effectType---------"..self.effectType)
				if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or self.effectType == BattleSkill.SKILL_INFLUENCE_ADDHP) then
					TalentSkill.processAttack(userInfo, self, fightModule, attackObject, byAttackObject)
					TalentSkill.processByAttack(userInfo, self, fightModule, attackObject, byAttackObject)
					TalentSkill.processUniteAttack(userInfo, self, fightModule, attackObject, byAttackObject)
				end
				attackObject:clearTalentJudgeResultList()
				byAttackObject:clearTalentJudgeResultList()
				attackObject.isAction=true
			end

			if attackObject.isDead == true then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD, byAttackObject, attackObject, self.skillMould, fightModule)
					byAttackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_OPPONENT_DEAD, fightModule, userInfo, byAttackObject, attackObject, byAttackCoordinates, byAttackObjects, attackObjects, self, effectBuffer )

					TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_SELF_DEAD, attackObject, byAttackObject, self.skillMould, fightModule)
					attackObject:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_SELF_DEAD, fightModule, userInfo, attackObject, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )

					for m, n in pairs(attackObjects) do
						if nil ~= n and true ~= n.isDead then
							TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_CAMP_ROLE_DEATH, n, byAttackObject, self.skillMould, fightModule)
							n:influenceTalentJudgeResults( TalentConstant.JUDGE_OPPORTUNITY_CAMP_ROLE_DEATH, fightModule, userInfo, n, byAttackObject, byAttackCoordinates, attackObjects, byAttackObjects, self, effectBuffer )
						end
					end
				end
			end

			-- 我方角色死亡 给对方加怒气值
			if attackObject.isDead == true then
				local battleTag = attackObject.battleTag == 0 and 1 or 0
				fightModule:addAnimalAngerValue(battleTag, 1)
			end

			-- 对方角色死亡或对方没有死亡但被复活 给我方加怒气值
			if byAttackObject.isDead == true or byAttackObject.revived == true then
				local battleTag = byAttackObject.battleTag == 0 and 1 or 0
				fightModule:addAnimalAngerValue(battleTag, 1)
			end
			
			--[[输出攻击过程信息
			if byAttackObject.healthPoint < 0 then
				byAttackObject.healthPoint = 0
			end
		    ___writeDebugInfo("\t\t\t" .. "当前的承受方：" .. byAttackObject.battleTag .. "\t" 
		    	.. "当前的承受方站位：" .. byAttackObject.coordinate .. "\t"
		    	.. "被攻击前的血量信息：" .. currentHp .. "\t" 
		    	.. "被攻击后的血量信息：" .. byAttackObject.healthPoint .. "\t"
		    	.. "公式ID：" .. __fight_debug_formula_type_info["" .. self.formulaInfo .. ""] .. "\t"
		    	.. "攻击的结果值：" .. effectArray[1] .. "\t"
		    	.. "\r\n")
		    --]]
		end
	end  -- endfor

	if tonumber(self.effectType) == 0 then
    	attackObject:clearBuffByDisposable()
    end
	if(self.effectAmount > 0) then
		fightModule.battleSkillCount = fightModule.battleSkillCount + 1
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)

	--[[输出攻击过程信息
    ___writeDebugInfo("\t\t效用攻击结束：" 
    	.. "当前的攻击方：" .. attackObject.battleTag .. "\t" 
    	.. "当前的攻击方站位：" .. attackObject.coordinate .. "\t" 
    	.. "效用ID：" .. self.skillInfluence.id .. "\t" 
    	.. "当前攻击者的血量：" .. attackObject.healthPoint .. "\t"
    	.. "当前攻击者的怒气：" .. attackObject.skillPoint .. "\t"
    	.. "\r\n")
    --]]
end


function BattleSkill:processTalentAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, byAttackTalent, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	--for (Byte byAttackCoordinate : byAttackCoordinates) {	
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		self:restoreStatus()
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
		else
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			if(effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
				attackObject:restoreAttackState()
				byAttackObject:restoreAttackState()
				local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject);
				if (nil == restrainObj) then
					self.restrain = 0
				else
					self.restrain = 1
				end
	
				RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
				RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
				FightUtil.computeEvasion(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				if(byAttackObject.isEvasionSurely) then
					byAttackObject.isEvasion=true
					byAttackObject.isEvasionSurely=false
				end
				if(true ~= byAttackObject.isEvasion) then
					FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
					if(attackObject.isCritical) then
						self.bearState = 2
					end
					if(byAttackObject.isRetain) then
						if(self.bearState == 2) then
							self.bearState = 4
						else							
							self.bearState = 3
						end
					end
				else
					self.bearState = 1
				end
			else
				self.bearState = 0
			end
			local effectArray = nil
			if(self.skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
			end
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				byAttackObject.isDead = true
				-- _crint("角色死亡5：", byAttackObject.battleTag, byAttackObject.coordinate)
				byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			else
				if(self.aliveState == 2) then
					if(attackObject.healthPoint < 1) then
						if(attackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount - 1
							fightModule.attackObjects[attackObject.coordinate] = nil
						else
							----_crint ("处理 天赋反击死亡	byAttackCount--	")
							fightModule.byAttackCount = fightModule.byAttackCount - 1
							fightModule.byAttackObjects[attackObject.coordinate] = nil
						end
						attackObject.isDead = true
						-- _crint("角色死亡6：", attackObject.battleTag, attackObject.coordinate)
						self.aliveState = 0
					else
						self.reattackObject = attackObject
					end
					local talentJudgeResultList = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
					if(#talentJudgeResultList > 0) then
						self.aliveState = 0
						self.reattackObject = nil
					end
				end
			end
			if(effectArray[3] > 0) then
				self.bearState =  effectArray[3]
			end
			if(self.effectRound > 1 and byAttackTalent) then
				self.effectRound = self.effectRound - 1
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
			attackObject:clearTalentJudgeResultList()
			byAttackObject:clearTalentJudgeResultList()
		end
	end   --endfor
	if(self.effectAmount > 0) then
		fightModule.battleSkillCount = fightModule.battleSkillCount + 1
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end

function BattleSkill:processTalentUniteAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, byAttackTalent, resultBuffer, effectCount)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	--for (Byte byAttackCoordinate : byAttackCoordinates) {	
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		self:restoreStatus()
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
		else
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
				attackObject:restoreAttackState()
				byAttackObject:restoreAttackState()
				local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject)
				if (restrainObj == nil) then
					self.restrain = 0
				else
					self.restrain = 1
				end
				--restrain =  (RestrainUtil.calculateHasRestrain(attackObject, byAttackObject) == nil ? 0:1)
				RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
				RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
				FightUtil.computeEvasion(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				if(byAttackObject.isEvasionSurely) then
					byAttackObject.isEvasion=true
					byAttackObject.isEvasionSurely=false
				end
				if(true ~= byAttackObject.isEvasion) then
					FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
					if(attackObject.isCritical) then
						self.bearState = 2
					end
					if(byAttackObject.isRetain) then
						if(self.bearState == 2)then
							self.bearState = 4
						else							
							self.bearState = 3
						end
					end
				else
					self.bearState = 1
				end
			else
				self.bearState = 0
			end
			local effectArray = nil
			if(skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				if(skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
					 and effectArray[3] == 1) then
					self.isDisplay = 0
				end
			end
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				byAttackObject.isDead = true
				-- _crint("角色死亡7：", byAttackObject.battleTag, byAttackObject.coordinate)
				byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			else
				if(self.aliveState == 2) then
					if(attackObject.healthPoint < 1) then
						if(attackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount - 1
							fightModule.attackObjects[attackObject.coordinate] = nil
						else
							----_crint ("处理 天赋反击死亡	byAttackCount--	")
							fightModule.byAttackCount = fightModule.byAttackCount - 1
							fightModule.byAttackObjects[attackObject.coordinate] = nil
						end
						attackObject.isDead = true
						-- _crint("角色死亡8：", attackObject.battleTag, attackObject.coordinate)
						self.aliveState = 0
					else
						self.reattackObject = attackObject
					end
					local talentJudgeResultList = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
					if( #talentJudgeResultList > 0) then
						self.aliveState = 0
						self.reattackObject = nil
					end
				end
			end
			if(effectArray[3] > 0) then
				self.bearState =  effectArray[3]
			end
			if(self.effectRound > 1 and byAttackTalent) then
				self.effectRound = self.effectRound - 1
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
			attackObject:clearTalentJudgeResultList()
			byAttackObject:clearTalentJudgeResultList()
		end
	end  -- endfor
	if(self.effectAmount > 0) then
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end

function BattleSkill:restoreStatus()
	self.byAttackerTag = 0
	self.byAttackerCoordinate = 0
	self.effectType = 0
	self.effectValue = 0
	self.isDisplay = 1
	self.effectRound = 0
	self.bearState = 0
	self.aliveState = 0
	self.dropCardNo = 0
	self.dropPropNo = 0
	self.dropEquipmentNo = 0
	self.dropType = 0
	self.reattackObject = nil
	self.clearBuffState = 0
	self.restrain = 0
	self.realDamageValue = 0
	self.damageByTalentType26 = 0
	self.counterType = 0
	self.counterCount = 0
end

function BattleSkill:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, resultBuffer)
	table.insert(resultBuffer, self.byAttackerTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.byAttackerCoordinate)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.restrain)
	table.insert(resultBuffer, IniUtil.compart)
	if tonumber(self.effectType) == 35 
		-- or tonumber(self.effectType) == 36 
		then
		self.effectType = 0
	end
	table.insert(resultBuffer, self.effectType)
	table.insert(resultBuffer, IniUtil.compart)
	if(self.clearBuffState > 0) then
		table.insert(resultBuffer, self.clearBuffState)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.counterType)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.counterCount)
	else
		if(tonumber(self.effectType) ~= 0 
			and tonumber(self.effectType) ~= 1
			and tonumber(self.effectType) ~= 2
			and tonumber(self.effectType) ~= 3
			and tonumber(self.effectType) ~= 4 
			and tonumber(self.effectType) ~= 6 
			and tonumber(self.effectType) ~= 9
			and tonumber(self.effectType) ~= 14
			and tonumber(self.effectType) ~= 17
			and tonumber(self.effectType) ~= 19
			and tonumber(self.effectType) ~= 20
			and tonumber(self.effectType) ~= 31
			and tonumber(self.effectType) ~= 34
			and tonumber(self.effectType) ~= 35
			and tonumber(self.effectType) ~= 37
			and tonumber(self.effectType) ~= 41
			and tonumber(self.effectType) ~= 46
			and tonumber(self.effectType) ~= 53
			and not BattleSkill.isLifeChainSkill(self.effectType)
			) 
			then
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, self.counterType)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, self.counterCount)
		else
			table.insert(resultBuffer, self.effectValue)
			table.insert(resultBuffer, IniUtil.compart)
			if tonumber(self.effectType) == 0 then
				table.insert(resultBuffer, self.realDamageValue)
			else
				table.insert(resultBuffer, 0)
			end
			table.insert(resultBuffer, IniUtil.compart)
			if tonumber(self.effectType) == 0 then
				table.insert(resultBuffer, self.damageByTalentType26)
			else
				table.insert(resultBuffer, 0)
			end
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, self.counterType)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, self.counterCount)
		end
	end
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.isDisplay)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectRound)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.bearState)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.aliveState)
	table.insert(resultBuffer, IniUtil.compart)
	if(self.aliveState == 1) then
		table.insert(resultBuffer, self.dropType)
		table.insert(resultBuffer, IniUtil.compart)
		--switch (self.dropType) {
		if (self.dropType == 0) then
			table.insert(resultBuffer, self.dropPropNo)
			--break
		elseif (self.dropType == 1) then
			table.insert(resultBuffer, self.dropCardNo)
			--break
		elseif (self.dropType == 2) then
			table.insert(resultBuffer, self.dropEquipmentNo)
			--break
		else
			table.insert(resultBuffer, 0)
			--break
		end
		table.insert(resultBuffer, IniUtil.compart)
	elseif(self.aliveState == 3) then
	end
	table.insert(resultBuffer, byAttackObject.healthPoint)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, byAttackObject.skillPoint)
	table.insert(resultBuffer, IniUtil.compart)
	
	-- if(self.aliveState == 2 and nil ~= reattackObject) then
		-- fightModule.counterBuffer = {}
		-- counterAttack(userInfo, byAttackObject, attackObject, fightModule, fightModule.counterBuffer)
		-- self.reattackObject = nil
	-- end
	self:processReflectDamage(userInfo, self, fightModule, attackObject, byAttackObject)
end

function BattleSkill:writeTalentAttack(userInfo, attackObject, byAttackObject, fightModule, resultBuffer)
	table.insert(resultBuffer, self.byAttackerTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.byAttackerCoordinate)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.restrain)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectType)
	table.insert(resultBuffer, IniUtil.compart)
	if(self.clearBuffState > 0) then
		table.insert(resultBuffer, self.clearBuffState)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.counterType)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.counterCount)
	else
		if(tonumber(self.effectType) ~= 0 
			and tonumber(self.effectType) ~= 1
			and tonumber(self.effectType) ~= 2
			and tonumber(self.effectType) ~= 3
			and tonumber(self.effectType) ~= 4 
			and tonumber(self.effectType) ~= 6 
			and tonumber(self.effectType) ~= 9
			and tonumber(self.effectType) ~= 31
			and tonumber(self.effectType) ~= 35) then
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, self.counterType)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, self.counterCount)
		else
			table.insert(resultBuffer, self.effectValue)
			table.insert(resultBuffer, IniUtil.compart)
			if tonumber(self.effectType) == 0 then
				table.insert(resultBuffer, self.realDamageValue)
			else
				table.insert(resultBuffer, 0)
			end
			table.insert(resultBuffer, IniUtil.compart)
			if tonumber(self.effectType) == 0 then
				table.insert(resultBuffer, self.damageByTalentType26)
			else
				table.insert(resultBuffer, 0)
			end
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, self.counterType)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, self.counterCount)
		end
	end
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.isDisplay)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectRound)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.bearState)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.aliveState)
	table.insert(resultBuffer, IniUtil.compart)
	if(self.aliveState == 1) then
		table.insert(resultBuffer, self.dropType)
		table.insert(resultBuffer, IniUtil.compart)
		if (self.dropType == 0 ) then
			table.insert(resultBuffer, self.dropPropNo)
			--break
		elseif (self.dropType == 1) then
			table.insert(resultBuffer, self.dropCardNo)
			--break
		elseif (self.dropType == 2) then
			table.insert(resultBuffer, self.dropEquipmentNo)
			--break
		else
			table.insert(resultBuffer, 0)
			--break
		end
		table.insert(resultBuffer, IniUtil.compart)
	end
end

function BattleSkill:counterAttack(userInfo, attackObject, byAttackObject, fightModule, resultBuffer)
	local battleSkillList = attackObject.counterBattleSkill
	table.insert(resultBuffer, #battleSkillList)
	table.insert(resultBuffer, IniUtil.compart)
	local byAttackCoordinates = {}
	--for (local battleSkill : battleSkillList) {
	for _, battleSkill in pairs(battleSkillList) do
		table.insert(resultBuffer, battleSkill.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 1)
		table.insert(resultBuffer, IniUtil.compart)
		if (0 == attackObject.battleTag)  then
			if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
				byAttackCoordinates = FightUtil.computeEffectCoordinate(attackObject.coordinate, battleSkill.skillInfluence, attackObject, fightModule.attackObjects)
				battleSkill:processOwnCounterAttack(userInfo, byAttackCoordinates, attackObject, fightModule.attackObjects, fightModule, resultBuffer)
			else
				byAttackCoordinates = FightUtil.computeCounterCoordinate(byAttackObject.coordinate, battleSkill.skillInfluence, attackObject, fightModule.byAttackObjects)
				battleSkill:processCounterAttack(userInfo, byAttackCoordinates, attackObject, fightModule.byAttackObjects, fightModule, resultBuffer)
			end
		else
			if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
				byAttackCoordinates = FightUtil.computeEffectCoordinate(attackObject.coordinate, battleSkill.skillInfluence, attackObject, fightModule.byAttackObjects)
				battleSkill:processOwnCounterAttack(userInfo, byAttackCoordinates, attackObject, fightModule.byAttackObjects, fightModule, resultBuffer)
			else
				byAttackCoordinates = FightUtil.computeCounterCoordinate(byAttackObject.coordinate, battleSkill.skillInfluence, attackObject, fightModule.attackObjects)
				battleSkill:processCounterAttack(userInfo, byAttackCoordinates, attackObject, fightModule.attackObjects, fightModule, resultBuffer)
			end
		end
	end
end

function BattleSkill:processCounterAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, resultBuffer)
	self:restoreStatus()
	self.effectAmount =  #byAttackCoordinates
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	--for (Byte byAttackCoordinate : byAttackCoordinates) {
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject) then
			self.effectAmount = self.effectAmount - 1
			--continue
		else
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			if(attackObject.isCritical) then
				self.bearState = 2
			end
			local effectArray = nil
			if(skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				if(skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
			end
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					----_crint ("处理反击死亡	byAttackCount--	")
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				byAttackObject.isDead = true
				-- _crint("角色死亡9：", byAttackObject.battleTag, byAttackObject.coordinate)
				byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
		end
	end  --endfor
	table.insert(resultBuffer, attackObject.battleTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, attackObject.coordinate)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectAmount)
	table.insert(resultBuffer, IniUtil.compart)
	IniUtil.concatTable(resultBuffer, effectBuffer)
end

function BattleSkill:processReflectDamage(userInfo, battleSkill, fightModule, attackObject, byAttackObject)
	-- 如果攻击者是神兽不能被反击
	if(attackObject.isDead or attackObject.isAnimal == true) then
		return
	end
	if(battleSkill.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
		--for (Iterator<TalentJudgeResult> talentIter = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_REFLECT).iterator(); talentIter.hasNext();) {
		for _, talentJudgeResult in pairs(byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_REFLECT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			local immunity = false
			--for (TalentImmunity talentImmunity : attackObject.talentImmunityList) {
			for _, talentImmunity in pairs(attackObject.talentImmunityList) do
				if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id) then
					immunity = true
					break
				end
			end
			if(immunity) then
				break
			end
			local reflectDamage = math.floor( battleSkill.effectValue * talentJudgeResult.percentValue / 100)
			local _battleSkill =  BattleSkill:new()
			_battleSkill.byAttackerTag=attackObject.battleTag
			_battleSkill.byAttackerCoordinate=attackObject.coordinate
			_battleSkill.effectValue=reflectDamage
			attackObject.subHealthPoint(reflectDamage)
			if(attackObject.healthPoint < 1) then
				_battleSkill.aliveState= 1
				attackObject.isDead = true
				-- _crint("角色死亡10：", attackObject.battleTag, attackObject.coordinate)
				if(attackObject.battleTag == 0) then
					fightModule.attackObjects[attackObject.coordinate] = nil
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
					--self:dropReward(fightModule, byAttackObject)
					fightModule.byAttackObjects[attackObject.coordinate] = nil
				end
				TalentSkill.processTargetDead(userInfo, fightModule, byAttackObject, attackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, byAttackObject, attackObject)
			end
			fightModule.battleSkillCount = fightModule.battleSkillCount + 1
			table.insert(fightModule.battleSkillBuffer, talentJudgeResult.talentMould.influenceEffectId)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, 1)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, byAttackObject.battleTag)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, byAttackObject.coordinate)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, 1)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, -1)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, -1)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			--talentIter.remove()
			_battleSkill:writeTalentAttack(userInfo, attackObject, byAttackObject, fightModule, fightModule.battleSkillBuffer)
		end
	end
end

function BattleSkill:processHpRemainDamage(userInfo, battleSkill, fightModule, attackObject)
	if(attackObject.isDead) then
		return
	end
	if(battleSkill.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
		--for (Iterator<TalentJudgeResult> talentIter = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_DAMAGE_HP_PERCENT).iterator(); talentIter.hasNext();) {
		for _, talentJudgeResult in pairs(attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_DAMAGE_HP_PERCENT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			fightModule.battleSkillCount = fightModule.battleSkillCount + 1
			fightModule.battleSkillBuffer.append(talentJudgeResult.talentMould.influenceEffectId)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(1)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(attackObject.battleTag)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(attackObject.coordinate)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			local byEffectCoordinateList = {}
			local itObjects = fightModule.byAttackObjects
			if (attackObject.battleTag ~= 0) then
				itObjects = fightModule.attackObjects
			end
			--for (local _byAttackObject : attackObject.battleTag == 0 ? fightModule.byAttackObjects : fightModule.attackObjects) {
			for _, _byAttackObject in pairs(itObjects) do
				if(true ~= _byAttackObject and true ~= _byAttackObject.isDead) then
					table.insert(byEffectCoordinateList, _byAttackObject.coordinate)
				end
			end
			fightModule.battleSkillBuffer.append(#byEffectCoordinateList)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(-1)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(-1)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			--for (int i = 0; i < byEffectCoordinateList.size(); i++) {
			-- for i = 1, table.maxn(byEffectCoordinateList) do
			for i, v in pairs(byEffectCoordinateList) do
				--local _byAttackObject = attackObject.battleTag == 0 ? fightModule.byAttackObjects[byEffectCoordinateList.get(i) - 1] : fightModule.attackObjects[byEffectCoordinateList.get(i) - 1]
				local _byAttackObject = fightModule.byAttackObjects[byEffectCoordinateList.get(i)]
				if (attackObject.battleTag ~= 0) then
					_byAttackObject = fightModule.attackObjects[byEffectCoordinateList.get(i)]
				end
				local damage =  (_byAttackObject.healthPoint * talentJudgeResult.percentValue / 100)
				local _battleSkill =  BattleSkill:new()
				_battleSkill.byAttackerTag=_byAttackObject.battleTag
				_battleSkill.byAttackerCoordinate=_byAttackObject.coordinate
				_battleSkill.effectValue=damage
				_byAttackObject.subHealthPoint(damage)
				if(_byAttackObject.healthPoint < 1) then
					_battleSkill.aliveState= 1
					_byAttackObject.isDead = true
					-- _crint("角色死亡11：", _byAttackObject.battleTag, _byAttackObject.coordinate)
					if(_byAttackObject.battleTag == 0) then
						fightModule.attackObjects[_byAttackObject.coordinate - 1] = nil
						fightModule.attackCount = fightModule.attackCount - 1
					else
						fightModule.byAttackCount = fightModule.byAttackCount - 1
						--self:dropReward(fightModule, byAttackObject)
						fightModule.byAttackObjects[_byAttackObject.coordinate - 1] = nil
					end
					TalentSkill.processTargetDead(userInfo, fightModule, attackObject, _byAttackObject)
					TalentSkill.processSelfDead(userInfo, fightModule, attackObject, _byAttackObject)
				end
				_battleSkill:writeTalentAttack(userInfo, attackObject, _byAttackObject, fightModule, fightModule.battleSkillBuffer)
			end
			--talentIter.remove()  --as of no use, just comment this line out
		end
	end
end

function BattleSkill:processHpCurePercent(userInfo, battleSkill, fightModule, attackObject)
	if(attackObject.isDead) then
		return
	end
	if(attackObject.isBearHP) then
		return
	end
	--for (Iterator<TalentJudgeResult> talentIter = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_CURE_HP_BY_HP_UPPER_LIMIT).iterator(); talentIter.hasNext();) {
	for _, talentJudgeResult in pairs(attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_CURE_HP_BY_HP_UPPER_LIMIT)) do
		--TalentJudgeResult talentJudgeResult = talentIter.next()
		fightModule.battleSkillCount = fightModule.battleSkillCount + 1
		fightModule.battleSkillBuffer.append(talentJudgeResult.talentMould.influenceEffectId)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(1)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(attackObject.battleTag)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(attackObject.coordinate)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(1)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(-1)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(-1)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		local cureHp =  (attackObject.healthMaxPoint * talentJudgeResult.percentValue / 100)
		-- cureHp =  math.min(attackObject.healthMaxPoint - attackObject.healthPoint, cureHp)
		local _battleSkill =  BattleSkill:new()
		_battleSkill.byAttackerTag=attackObject.battleTag
		_battleSkill.byAttackerCoordinate=attackObject.coordinate
		_battleSkill.effectValue = cureHp
		attackObject:addHealthPoint(cureHp)
		_battleSkill.effectType = BattleSkill.SKILL_INFLUENCE_ADDHP
		_battleSkill:writeTalentAttack(userInfo, attackObject, attackObject, fightModule, fightModule.battleSkillBuffer)
	end
end

function BattleSkill:processOwnCounterAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	--for (Byte byAttackCoordinate : byAttackCoordinates) {	
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		self:restoreStatus()
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
		else
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			if(attackObject.isAction ~= true) then
				attackObject.isAction = true
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
			end
			local effectArray = nil
			if(skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				if(skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
			end
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					----_crint ("处理 processOwnCounterAttack死亡	byAttackCount--	")
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				byAttackObject.isDead = true
				-- _crint("角色死亡12：", byAttackObject.battleTag, byAttackObject.coordinate)
				byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
		end
	end --endfor
	table.insert(resultBuffer, attackObject.battleTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, attackObject.coordinate)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectAmount)
	table.insert(resultBuffer, IniUtil.compart)
	IniUtil.concatTable(resultBuffer, effectBuffer)
end

function BattleSkill:checkSkillAndTalent(attackObject)
	if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DRAINS or
			self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_CURE_HP) then
		return true
	end
	--for (Iterator<TalentMould> talentIter = attackObject.talentMouldList.iterator(); talentIter.hasNext();) {
	for _, talentMould in pairs(attackObject.talentMouldList) do
		--TalentMould talentMould = talentIter.next()
		local battleSkillList = talentMould.talentBattleSkill
		--for (int i = 0; i < battleSkillList.size(); i++) {
		for _, battleSkill in pairs(battleSkillList) do
			--local battleSkill = battleSkillList.get(i)
			if(battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DRAINS	
					or battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_CURE_HP	
					or battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_EVASION_SURELY
					or battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_CURE_SP) then
				return true
			end
		end
	end
	return false
end

function BattleSkill:processFitAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	local count=0
	--for (Byte byAttackCoordinate : byAttackCoordinates) {
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		count = count + 1
		self:restoreStatus()
		attackObject.isCritical=false
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
		else
			-- if battleObject.isAction ~= true then
			-- 	-- battleObject.isAction = false
			-- end
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
				attackObject:restoreAttackState()
				byAttackObject:restoreAttackState()
				local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject);
				if (restrainObj == nil)  then
					self.restrain = 0
				else
					self.restrain = 1
				end
				--restrain =  (RestrainUtil.calculateHasRestrain(attackObject, byAttackObject) == nil ? 0:1)
				RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
				RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
				FightUtil.computeEvasion(self.skillMould, skillInfluence, attackObject, byAttackObject)
				if(byAttackObject.isEvasionSurely) then
					byAttackObject.isEvasion=true
					byAttackObject.isEvasionSurely=false
				end
				if(true ~= byAttackObject.isEvasion) then
					FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
					if(attackObject.isCritical) then
						self.bearState = 2
					end
					if(byAttackObject.isRetain) then
						if(self.bearState == 2) then
							self.bearState = 4
						else							
							self.bearState = 3
						end
						if(byAttackObject.canReAttack) then
							self.aliveState = 2
							--for (int i = 0; i < byAttackObjects.length; i++) {
							for _, byObj in pairs(byAttackObjects) do
								if(nil ~= byObj) then
									byObj.canReAttack=false
								end
							end
						end
					end
				else
					self.bearState = 1
				end
			else
				self.bearState = 0
			end
			local effectArray = nil
			if(self.skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				
				if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
			end
			attackObject.totalSkillPoint=0
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				byAttackObject.isDead = true
				-- _crint("角色死亡13：", byAttackObject.battleTag, byAttackObject.coordinate)
				byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			else
				if(self.aliveState == 2) then
					if(attackObject.healthPoint < 1) then
						if(attackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount - 1
							fightModule.attackObjects[attackObject.coordinate] = nil
						else
							----_crint ("处理攻反击死亡	byAttackCount--	" + attackObject.battleTag)
							fightModule.byAttackCount = fightModule.byAttackCount - 1
							fightModule.byAttackObjects[attackObject.coordinate] = nil
						end
						attackObject.isDead = true
						-- _crint("角色死亡14：", attackObject.battleTag, attackObject.coordinate)
						self.aliveState = 0
					else
						self.reattackObject = attackObject
					end
					local talentJudgeResultList = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
					if(#talentJudgeResultList > 0) then
						self.aliveState = 0
						self.reattackObject = nil
					end
				end
			end
			if(effectArray[2] > 0) then
				self.bearState =  effectArray[3]
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
			attackObject:addTotalEffectDamage(self.effectValue)
			if(self:checkSkillAndTalent(attackObject) and count < #byAttackCoordinates) then
				--continue
			else
				if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or self.effectType == BattleSkill.SKILL_INFLUENCE_ADDHP) then
					TalentSkill.processAttack(userInfo, self, fightModule, attackObject, byAttackObject)
					TalentSkill.processByAttack(userInfo, self, fightModule, attackObject, byAttackObject)
					TalentSkill.processUniteAttack(userInfo, self, fightModule, attackObject, byAttackObject)
				end
				attackObject:clearTalentJudgeResultList()
				byAttackObject:clearTalentJudgeResultList()
				-- attackObject.isAction=false
			end
		end
	end
	if(self.effectAmount > 0)then
		fightModule.fitBattleSkillCount = fightModule.fitBattleSkillCount + 1
		if(fightModule.fitSelfBuffer ~=  nil) then
			self.effectAmount = self.effectAmount + 1
			-- table.insert(effectBuffer, fightModule.fitSelfBuffer)
			IniUtil.concatTable(effectBuffer, fightModule.fitSelfBuffer)
			fightModule.fitSelfBuffer = nil
		end
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end

-- /**
--  * 计算战船死亡掉落
--  * @param userInfo
--  * @param byAttackObject
--  */
function BattleSkill:dropReward(fightModule,byAttackObject)
	-- //计算道具掉落
	-- if(byAttackObject.rewardPropRatio ~= nil and byAttackObject.rewardPropRatio > 0) then
	-- 	if(math.random(1, 100) <= byAttackObject.rewardPropRatio) then
	-- 		local rewardProp =  fightModule.rewardProp[byAttackObject.rewardProp]
	-- 		if(rewardProp ~= nil) then
	-- 			fightModule.rewardProp[byAttackObject.rewardProp] = {byAttackObject.rewardProp,rewardProp + 1}
	-- 		else
	-- 			fightModule.rewardProp[byAttackObject.rewardProp] = {byAttackObject.rewardProp,1}
	-- 		end
	-- 		self.dropCardNo = 1;
	-- 		self.dropType = 1;
	-- 	end
	-- end
	-- -- //计算装备掉落
	-- if(byAttackObject.rewardEquipmentRatio ~= nil and byAttackObject.rewardEquipmentRatio > 0) then
	-- 	if(math.random(1, 100) <= byAttackObject.rewardEquipment) then
	-- 		local rewardEquipment =  fightModule.rewardEquipment[byAttackObject.rewardEquipment]
	-- 		if(rewardEquipment ~= nil) then
	-- 			fightModule.rewardEquipment[byAttackObject.rewardEquipment] = {byAttackObject.rewardEquipment,rewardEquipment + 1}
	-- 		else
	-- 			fightModule.rewardEquipment[byAttackObject.rewardEquipment] = {byAttackObject.rewardEquipment,1}
	-- 		end
	-- 		self.dropCardNo = 1;
	-- 		self.dropType = 1;
	-- 	end
	-- end

	-- -- //计算卡片掉落
	-- if(byAttackObject.rewardRatio ~= nil and byAttackObject.rewardRatio > 0) then
	-- 	if(math.random(1, 100) <= byAttackObject.rewardCard) then
	-- 		local rewardInfo = {
	-- 			card = byAttackObject.rewardCard,
	-- 			count = 1
	-- 		}
	-- 		local rewardCard =  fightModule.rewardCard[byAttackObject.rewardCard]
	-- 		if(rewardCard ~= nil) then
	-- 			rewardInfo.count = rewardCard.count+1
	-- 			fightModule.rewardCard[byAttackObject.rewardCard] = rewardInfo
	-- 		else
	-- 			fightModule.rewardCard[byAttackObject.rewardCard] = rewardInfo
	-- 		end
	-- 		self.dropCardNo = 1;
	-- 		self.dropType = 1;
	-- 	end
	-- end
end


function BattleSkill:processOneAttack(userInfo,attackObject, byAttackObject, fightModule, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	--_crint ("endureDirection: " .. endureDirection[1] .. ", " ..endureDirection[2] .. ", " .. attackObject.coordinate)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	-- if(attackObject.isAction ~= true) then
	-- 	attackObject.isAction = true
	-- 	self:restoreStatus()
	-- 	self.effectAmount = self.effectAmount + 1
	-- 	self.byAttackerTag = attackObject.battleTag
	-- 	self.byAttackerCoordinate = attackObject.coordinate
	-- 	self.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
	-- 	self.isDisplay = 0
	-- 	if(attackObject.skillPoint >= 4 and true ~= attackObject.isDisSp) then
	-- 		self.effectType = BattleSkill.SKILL_INFLUENCE_DAMAGESP
	-- 		self.effectValue = 4
	-- 		attackObject:subSkillPoint(4)
	-- 		attackObject.totalSkillPoint = self.effectValue
	-- 	elseif(true ~= attackObject.isSpDisable) then
	-- 		self.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
	-- 		self.effectValue = 2
	-- 		attackObject:addSkillPoint(FightModule.ATTACK_SP_ADD_VAULE)
	-- 	end
	-- 	if attackObject.isNeedAddSkillPoint == false then
	-- 		attackObject:addZomSkillPoint(2)
	-- 	end
	-- 	--_crint ("Exit before write")
	-- 	self:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
	-- end
	local count=0
	
	--for (Byte byAttackCoordinate : byAttackCoordinates) {
	--_crint ("byAttackCoordinates are: ")
	self.byAttackerTag = byAttackObject.battleTag
	self.byAttackerCoordinate = byAttackObject.coordinate
	self.effectType = self.skillInfluence.skillCategory
	if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
		attackObject:restoreAttackState()
		byAttackObject:restoreAttackState()
		
		local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject);
		
		if (restrainObj ~= nil) then
			self.restrain = 1
		else
			self.restrain = 0
		end
		----_crint ("has restrain: " .. self.restrain)
		--os.exit()
		RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
		RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
		TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
		TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
		FightUtil.computeEvasion(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
		if(byAttackObject.isEvasionSurely) then
			byAttackObject.isEvasion=true
			byAttackObject.isEvasionSurely=false
		end
		if(true ~= byAttackObject.isEvasion) then
			FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			if(attackObject.isCritical) then
				self.bearState = 2
				----_crint ("self.bearState = 2")
				--os.exit()
			end
			if(byAttackObject.isRetain) then
				if(self.bearState == 2) then
					self.bearState = 4
				else	
					self.bearState = 3
				end
				if(byAttackObject.canReAttack) then						
					self.aliveState = 2
					-- for i = 1, table.maxn(byAttackObjects) do
					for i, v in pairs(byAttackObjects) do
						if(nil ~= byAttackObjects[i]) then
							byAttackObjects[i].canReAttack=false
						end
					end
				end
			end
		else
			self.bearState = 1
		end
	
	else
		self.bearState = 0
	end
	local effectArray = nil
	if(self.skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
		--_crint ("effectArray is clear buff")
		effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
	else
		--_crint ("effectArray is computeSkillEffect")
		effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
		if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
				 and effectArray[3] == 1) then
				self.isDisplay = 0
		end
		
		if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_ADD_KILL) then
			self.bearState = 0
		end
	end
	attackObject.totalSkillPoint = 0
	self.effectValue = effectArray[1]
	self.effectRound =  effectArray[2]
	self.clearBuffState = effectArray[4]
	if(byAttackObject.healthPoint < 1) then
		if(byAttackObject.battleTag == 0) then
			fightModule.attackCount = fightModule.attackCount - 1
		else
			fightModule.byAttackCount = fightModule.byAttackCount - 1
		end
		byAttackObject.isDead = true
		-- _crint("角色死亡15：", byAttackObject.battleTag, byAttackObject.coordinate)
		-- byAttackObjects[byAttackCoordinate] = nil
		TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
		TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
		self:processHpCurePercent(userInfo, self, fightModule, attackObject)
		self.aliveState = 1
		--self:dropReward(fightModule, byAttackObject)
	else
		if(self.aliveState == 2) then
			if(attackObject.healthPoint < 1) then
				if(attackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
					fightModule.attackObjects[attackObject.coordinate] = nil
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
					fightModule.byAttackObjects[attackObject.coordinate] = nil
				end
				attackObject.isDead = true
				-- _crint("角色死亡16：", attackObject.battleTag, attackObject.coordinate)
				self.aliveState = 0
			else
				self.reattackObject = attackObject
			end
			local talentJudgeResultList = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
			if(#talentJudgeResultList > 0) then
				self.aliveState = 0
				self.reattackObject = nil
			end
		end
	end
	if(effectArray[3] > 0)then
		self.bearState =  effectArray[3]
	end
	self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
	self.effectAmount = self.effectAmount + 1
	attackObject:addTotalEffectDamage(self.effectValue)
	-- if(self:checkSkillAndTalent(attackObject) and count < #byAttackCoordinates)then
	-- 	--continue
	-- else
	if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
		TalentSkill.processAttack(userInfo, self, fightModule, attackObject, byAttackObject)
		TalentSkill.processByAttack(userInfo, self, fightModule, attackObject, byAttackObject)
		TalentSkill.processUniteAttack(userInfo, self, fightModule, attackObject, byAttackObject)
	end
	attackObject:clearTalentJudgeResultList()
	byAttackObject:clearTalentJudgeResultList()
		-- attackObject.isAction=false
	-- end
	if(self.effectAmount > 0) then
		fightModule.battleSkillCount = fightModule.battleSkillCount + 1
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end

function BattleSkill.isLifeChainSkill(targetSkillCategory)
	if targetSkillCategory == nil then
		return false
	end

	local targetSkillCategory = zstring.tonumber(targetSkillCategory)

	for _, skillCategory in pairs(BattleSkill.ALL_SKILL_LIFE_CHAIN) do
		if targetSkillCategory == skillCategory then
			return true
		end
	end
	return false
end

-- 处理生命链接间接伤害表现
function BattleSkill:processShowLifeChain(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
	if byAttackObject.battleTag ~= attackObject.battleTag then
		local num = table.nums(byAttackObject.lstLifeChainMoveTargetInfo)

		if num > 0 then 
			--[[
			-- 被击者表现（飘buff图标）
			local skillCategory = nil
			for i, targetInfo in pairs(byAttackObject.lstLifeChainMoveTargetInfo) do
				if skillCategory == targetInfo.skillCategory then

				else
					skillCategory = targetInfo.skillCategory

					local bs = BattleSkill:new()
					bs.byAttackerTag = byAttackObject.battleTag
					bs.byAttackerCoordinate = byAttackObject.coordinate
					bs.isDisplay = 1
					bs.effectType = skillCategory
					bs.effectValue = 0
					bs.effectRound = -1
					bs:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
					self.effectAmount = self.effectAmount + 1
				end
			end
			--]]

			-- 伤害转移者表现
			for i, targetInfo in pairs(byAttackObject.lstLifeChainMoveTargetInfo) do
				local targetObject = targetInfo.targetObject

				-- 处理间接伤害
				if targetInfo.damage > 0 then
					local bs = BattleSkill:new()
					bs.byAttackerTag = targetObject.battleTag
					bs.byAttackerCoordinate = targetObject.coordinate
					bs.isDisplay = 1
					bs.effectType = targetInfo.skillCategory
					bs.effectValue = targetInfo.damage
					bs.effectRound = -1
					bs:writeSkillAttack(userInfo, attackObject, targetObject, fightModule, effectBuffer)
					self.effectAmount = self.effectAmount + 1
				end

				-- 处理吸收伤害的回血效果
				if targetInfo.recoveryHealth > 0 then
					local bs = BattleSkill:new()
					bs.byAttackerTag = targetObject.battleTag
					bs.byAttackerCoordinate = targetObject.coordinate
					bs.isDisplay = 1
					bs.effectType = BattleSkill.SKILL_INFLUENCE_ADDHP
					bs.effectValue = targetInfo.recoveryHealth
					bs:writeSkillAttack(userInfo, attackObject, targetObject, fightModule, effectBuffer)
					self.effectAmount = self.effectAmount + 1
				end

				for _, skillCategory in pairs(BattleSkill.ALL_SKILL_DAMAGE_TO_HEATH) do
					local nums = 0
					for _, v in ipairs(targetObject.damageToHealthList) do
						if v.skillCategory == skillCategory then
							nums = nums + 1
						end
					end

					if nums == 0 then											
						targetObject:clearBuffBySkilCategory(skillCategory)
						local bs = BattleSkill:new()
						bs.byAttackerTag = targetObject.battleTag
						bs.byAttackerCoordinate = targetObject.coordinate
						bs.isDisplay = 1
						bs.effectType = skillCategory
						bs.effectValue = 0
						bs.effectRound = -1
						bs:writeSkillAttack(userInfo, attackObject, targetObject, fightModule, effectBuffer)
						self.effectAmount = self.effectAmount + 1
					end
				end

				-- 处理庇护效果
				if targetInfo.protectEffectValue > 0 then
					for _, skillCategory in pairs(BattleSkill.ALL_SKILL_PROTECT_DAMAGE) do
						local nums = 0
						for _, v in ipairs(targetObject.protectBigDamageList) do
							if v.skillCategory == skillCategory then
								nums = nums + 1
							end
						end
						if nums == 0 then
							targetObject:clearBuffBySkilCategory(skillCategory)

							local bs = BattleSkill:new()
							bs.byAttackerTag = targetObject.battleTag
							bs.byAttackerCoordinate = targetObject.coordinate
							bs.isDisplay = 1
							bs.effectType = skillCategory
							bs.effectValue = 0
							bs.effectRound = -1
							bs:writeSkillAttack(userInfo, attackObject, targetObject, fightModule, effectBuffer)
							self.effectAmount = self.effectAmount + 1
						end
					end
				end
			end
		end

		byAttackObject.lstLifeChainMoveTargetInfo = {}
	end
end