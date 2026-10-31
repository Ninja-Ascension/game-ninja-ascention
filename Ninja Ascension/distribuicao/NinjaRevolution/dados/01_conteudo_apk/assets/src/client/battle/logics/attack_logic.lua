 attack_logic = attack_logic or {}

attack_logic.queue = {}
attack_logic.__attackers = nil
attack_logic.__defenders = nil
attack_logic.__blasters = {}
attack_logic.__blastersed = {}
attack_logic.__blaster = nil
attack_logic.__need_unlock = false
attack_logic.__fight_is_over = false
attack_logic.__hero_ui_visible = false
attack_logic.__hero_ui_lock = true 

-- ------------------------------------------------------------------------- --
-- 战斗逻辑处理
-- ------------------------------------------------------------------------- --

local __attackers = nil
local __defenders = nil
local __battleDatas = nil
local __attackDatas = nil

local __fit_params = {}
local __fit_roles = {}

local curr_fit_attacker = "0"
local curr_fit_skillElementData = nil
local curr_fit_skillInfluenceElementData = nil
local curr_fit_attackMovePos = 0
local attData = nil

local linkAttacker_state = 0

local function getRole(_camp, _target_pos)
	if tonumber(_target_pos) == 101 then
		_camp = 0
		_target_pos = 7
	elseif tonumber(_target_pos) == 102 then
		_camp = _camp
		_target_pos = 8
	end
	local _role = "".._camp == "0" and __attackers[tonumber("".._target_pos)] or __defenders[tonumber("".._target_pos)]
	return _role
end

function draw.drawFirstRechargeCG(user_grade,currentNpcId)
end

-- 战斗内使用的，根据传入的战士di,返回攻防小图标路径图
draw.getBattleHeroAbilityImg = function(shipMouldId,mouldType)
	local capacity = nil
	if mouldType==0 then
		capacity = dms.int(dms["ship_mould"], shipMouldId, ship_mould.capacity)		--武将能力标识
	elseif mouldType == 1 then
		capacity = dms.int(dms["environment_ship"], shipMouldId, environment_ship.capacity)	--武将能力标识 
	end
	return string.format("images/ui/play/adam_war/icon_%s.png",  capacity+1)
end


BattleSceneClass = class("BattleSceneClass", Window)
BattleSceneClass.__index = BattleSceneClass
BattleSceneClass._uiLayer= nil
BattleSceneClass._widget = nil
BattleSceneClass._widgetBg = nil
BattleSceneClass._effectBg = nil
BattleSceneClass._sceneTitle = nil
BattleSceneClass._lastExp = nil
BattleSceneClass._lastNeedExp = nil
BattleSceneClass._GoldBossCell = nil
BattleSceneClass._attackTotalHarm = nil
BattleSceneClass._unionBattleInfo = nil
BattleSceneClass._hero_index = 0

BattleSceneClass._isSkepBattle = false
-- ------------------------------------------------------------------------------------------------- --
-- 											战斗过程处理												 --
-- ------------------------------------------------------------------------------------------------- --

-- 战斗UI控制
local isCanSkipCurrentBattle	= false
-- 片头剧情战斗屏蔽大蛇的血条，卡牌，和战士相性图标
local shieldFoeId = 1283
-- Local Variable
-- 层的编号
local kTagFadeInLayerColor		= 190000	-- 淡入的遮挡层
local missionJump 				= 190001	-- 跳过剧情按钮的层

local kSkipPlotNPC				= 43000

local kZOrderInMap_StanddyRole	= 0
local kZOrderInMap_MoveRole		= 10000	
local kZOrderInMap_Effect		= 2000000		
local kZOrderInMap_Hurt			= 3000000		
local kZOrderInMap_sp_effect	= 4000000

-- UI
local teamTopScreenOffsetY		= 0 / CC_CONTENT_SCALE_FACTOR()			-- 敌方上方场景中的偏移量，或我方下方场景中的偏移量
local attackMoveTagetOffsetY	= 100 / CC_CONTENT_SCALE_FACTOR()			-- 与被攻击者之前的间距
local attackUnionTagetOffsetY	= 500 / CC_CONTENT_SCALE_FACTOR()		-- 公会入场偏移量

-- 数据
local fightSlotCount			= 6			-- 战斗位的数据
local fightOverCount 			= 3			-- 战斗结束场次
local lockSkipFight 			= false
local skipCurrentFight 			= false
local setDeathArmatureCount 	= -1

local fight_type_1				= 1
local fight_type_2				= 2
local fight_type_3				= 3
local fight_type_4				= 4
local fight_type_5				= 5
local fight_type_6				= 6
local fight_type_7				= 7
local fight_type_8				= 8
local fight_type_9				= 9

-- 动画的控制
local fightAccelerationOne		= zstring.tonumber(_fight_run_speed[1])
local fightAccelerationTwo		= zstring.tonumber(_fight_run_speed[2])
local fightAccelerationThree	= zstring.tonumber(_fight_run_speed[3])
local fightAccelerationFour		= zstring.tonumber(_fight_run_speed[4])
if m_tOperateSystem == 5 then
	fightAccelerationOne = fightAccelerationOne*1.5
	fightAccelerationTwo = fightAccelerationTwo*1.5
	fightAccelerationThree = fightAccelerationThree*1.5
	fightAccelerationFour = fightAccelerationFour*1.5
end
local actionTimeSpeed			= fightAccelerationOne

-- 战斗中的环境变量
local moveFrameTime = 0.013
local moveFrameSpace = 4
local moveToTargetTime = 0.5
local moveToTargetTime1 = dms.int(dms["durationmt"], 1, 1) / 60.0
local moveToTargetTime2 = dms.int(dms["durationmt"], 2, 1) / 60.0

-- -- 定义英雄动作帧组索引
-- -- {_actionIndex=0, _nextAction= _changing=false, _nextFunc = nil, _invoke = nil}
-- local animation_standby 				= 0		-- 待机
-- local animation_move 					= 1		-- 移动开始
-- local animation_moving 					= 2		-- 移动中
-- local animation_move_end				= 3		-- 移动结束帧
-- local animation_melee_attack_began		= 4		-- 近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧
-- local animation_melee_attacking			= 5		-- 近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作
-- local animation_remote_attack_began		= 6		-- 远程攻击前段，在原地，播放一个次，是准备攻击的动作帧
-- local animation_remote_attacking		= 7		-- 远程攻击中段，在原地，播放一个次，是攻击动作
-- local animation_melee_skill_began		= 8		-- 技能近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧
-- local animation_melee_skilling			= 9		-- 技能近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作
-- local animation_remote_skill_began		= 10	-- 技能攻击远程前段，在原地，播放一个次，是准备攻击的动作帧
-- local animation_remote_skilling			= 11	-- 技能攻击远程中段，在原地，播放一个次，是攻击动作
-- local animation_hero_by_attack			= 12	-- 我方被攻击，在原地，播放一个次
-- local animation_emeny_by_attack			= 13	-- 敌方被攻击，在原地，播放一个次
-- local animation_in_elite				= 14	-- 进入副本，在原地，播放一个次
-- local animation_death					= 15	-- 死亡，在原地，播放一个次
-- local animation_melee_attack_end		= 16	-- 近身攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，并且回到原位置，切换到待机帧
-- local animation_remote_attack_end		= 17	-- 远程攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
-- local animation_melee_skill_end			= 18	-- 技能攻击近身后段，播放一个次，在攻击动作播放完毕以后，播放一次，并且回到原位置，切换到待机帧
-- local animation_remote_skill_end		= 19	-- 技能远程攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
-- local animation_hero_miss				= 20	-- 我方闪避，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
-- local animation_emeny_miss				= 21	-- 敌方闪避，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
-- local animation_is_death				= 22	-- 死亡在战场中
-- local animation_attack_moving			= 23	-- 近身攻击上的移动帧组
-- local animation_skill_moving			= 24	-- 技能近身攻击上的移动帧组
-- local animation_revolve					= 25	-- 旋转帧组
-- local death_buff						= 26	-- 死亡墓碑动画
-- local death_buff_end                    = 27	-- 死亡坟墓消失动画
-- local animation_send_bullet             = 28	-- 发射子弹的
-- -- local into1								= 28	-- 出场动画1
-- -- local into2								= 29	-- 出场动画2
-- -- local into3								= 30	-- 出场动画3
-- -- local into4								= 31	-- 出场动画4
-- -- local into5								= 32	-- 出场动画5
-- -- local into6								= 33	-- 出场动画6
-- -- local animation_difangmove				= 34	-- 敌方移动
-- -- local animation_difangmoving			= 35	-- 敌方移动中
-- -- local animation_difangmove_end			= 36	-- 敌方移动结束
-- -- local animation_heti1					= 37	-- 逆时针合体技能动画
-- -- local animation_heti2					= 38	-- 顺时针合体技能动画


local battle_enum = {
	into1								= 28,	-- 出场动画1
	into2								= 29,	-- 出场动画2
	into3								= 30,	-- 出场动画3
	into4								= 31,	-- 出场动画4
	into5								= 32,	-- 出场动画5
	into6								= 33,	-- 出场动画6
	animation_difangmove				= 34,	-- 敌方移动
	animation_difangmoving				= 35,	-- 敌方移动中
	animation_difangmove_end			= 36,	-- 敌方移动结束
	animation_heti1						= 37,	-- 逆时针合体技能动画
	animation_heti2						= 38,	-- 顺时针合体技能动画
}

local into={battle_enum.into1,battle_enum.into2,battle_enum.into3,battle_enum.into4,battle_enum.into5,battle_enum.into6}-- 出场动画的表


-- ----------------------------------------功能函数------------------------------------------------- --
local moveTeam = nil						-- 移动队伍进入战斗
local moveUnionTeam = nil					-- 
local initBattle = nil						-- 初始化战斗中的我方角色
local initEnemy = nil						-- 初始化战斗中的敌方角色
local startBattle = nil						-- 开始战斗
local nextRoundBattle = nil					-- 下一回合的战斗
local nextAttack = nil						-- 下一个角色进行攻击
local executeHeroMoveToTargetFit			-- 合体技能-处理角色移动到攻击点
local executeHeroMoveToTarget = nil			-- 处理角色移动到攻击点
local executeHeroMoveToOriginTarget = nil	-- 处理角色移动到原点
local executeAttack = nil					-- 处理角色进行攻击
local executeAttacking = nil				-- 处理角色进行攻击中
local startAfterAttack = nil				-- 启动角色的后段攻击
local executeAfterAttack = nil				-- 处理角色的后段攻击
local executeAfterAttacking = nil 			-- 处理角色的后段技能效用处理
local executeByAttack = nil					-- 处理角色被攻击
local executeSkillAttack = nil				-- 处理角色进行技能攻击
local executeBySkillAttack = nil			-- 处理角色被技能攻击
local executeAttackerBuff = nil				-- 处理攻击者的BUFF
local executeDeath = nil					-- 处理角色死亡

local __attackChangeActionCallback = nil
local attackChangeActionCallback = nil		-- 攻击切帧控制
local executeMeleeAttackBegan = nil			-- 近身攻击前段
local executeMeleeAttacking = nil			-- 近身攻击中段
local executeMeleeAttackEnd = nil			-- 近身攻击后段
local executeRemoteAttackBegan = nil		-- 远程攻击前段
local executeRemoteAttacking = nil			-- 远程攻击中段
local executeRemoteAttackEnd = nil			-- 远程攻击后段
local executeMeleeSkillBegan = nil			-- 技能近身攻击前段
local executeMeleeSkilling = nil			-- 技能近身攻击中段
local executeMeleeSkillEnd = nil			-- 技能近身攻击后段
local executeRemoteSkillBegan = nil			-- 技能近远程击前段
local executeRemoteSkilling = nil			-- 技能近远程击中段
local executeRemoteSkillEnd = nil			-- 技能近远程击后段

local executeHeroByAttack = nil				-- 我方被攻击光效
local executeEmenyByAttack = nil			-- 敌方被攻击光效
local executeDrawAttackHurtNmber = nil		-- 绘制攻击伤害数字
local executeRoleDeath = nil				-- 角色死亡光效

local loadEffectFile = nil					-- 加载光效资源文件
local deleteEffectFile = nil				-- 删除光效
local createEffect = nil					-- 创建光效
local executeEffectSkillBegan = nil			-- 技能光效前段
local executeEffectSkilling = nil			-- 技能光效中段
local executeEffectSkillEnd = nil			-- 技能光效后段

local playEffectMusic = nil					-- 播放音效

local onFrameEvent = nil					-- 帧事件监听
local onFrameEvent3 = nil					-- 帧事件监听

local responseBattleFieldInit = nil
local requestEnvironmentContinueFight = nil
-- startBattle  Variable
local currentRoundIndex = 0
local currentRoundAttackIndex = 1
local currentSkillInfluenceStartIndex = 1
local isAttackInfluence = false
local attackTargetCount = 0
local executeAfterInfluenceCount = 0
local currentAttackCount = 0

local isNoDeath = false

-- nextAttack  Variable
local mPosTile = nil
local mpos = nil
local mtime = 0

local lastTimeRoundBattleNumber = 0 -- 军团副本战斗上次回合的活动对象数
local currentcurrent_scene_npc_id_length = nil --当前副本的部队数
local battleMoveUnionTeamY = nil
local mschedulerEntry=nil
local mScheduler=nil

local createFlyingEffects = nil



function getRageHead()
	local rage_head_image = "images/face/big_head/big_head_%s.png"
	return rage_head_image
end

BattleSceneClass.curDamage = 0
BattleSceneClass.bossDamage = 0

local function DamageToMoney()
	local exMoney = 0
	local i = 0
	for i=12, 1, -1 do
		local data = dms.element(dms["damage_reward_silver_param"], i)
		if dms.atoi(data, damage_reward_silver_param.damage_value) <= BattleSceneClass.curDamage then
			exMoney = dms.atoi(data, damage_reward_silver_param.reward_silver)
			break
		end
	end
	
	return math.floor(BattleSceneClass.curDamage/10) + exMoney
end

-- function 
local function getRolePad(camp, pos)
	return getRole(camp, pos)
end

local function getCampEffectId(_skillInfluenceElementData, camp, effect_index)
	-- local camp = zstring.tonumber(camp)
	-- local effectIds = zstring.split(dms.atos(_skillInfluenceElementData, effect_index), ",")
	-- local effectId = zstring.tonumber(effectIds[camp])
	-- return effectId
	return dms.atoi(_skillInfluenceElementData, effect_index)
end

local function getCampEffectIds(_skillInfluenceElementData, camp, effect_index)
	-- local camp = zstring.tonumber(camp)
	-- local effectIds = zstring.split(dms.atos(_skillInfluenceElementData, effect_index), ",")
	-- local effectId = zstring.tonumber(effectIds[camp])
	-- return effectId
	return zstring.split(dms.atos(_skillInfluenceElementData, effect_index), ",")
end

-- -- 播放音效
-- playEffectMusic = function(musicIndex)
-- 	-- 播放音效
-- 	pushEffect(formatMusicFile("effect", musicIndex))
-- end

local function resetArmatureData(armature)
	if armature ~= nil then
		armature._hurtCount = 0
		armature._hnb = nil
		armature._executeBuff = false
		armature._executeBuffs = {}
		armature._def = nil
		armature._defr = nil
		armature._sie = nil
		armature._defs = nil
		armature._isByReact = false
		armature._reactor = nil
		armature._isReact = false
		armature._isReacting = false
		armature._byReactor = nil
	end
end

-- 动帧监听函数
local nil_animationEventCallFunc = nil
local animation_changeToAction = nil

local function battle_changeAction_animationEventCallFunc(armatureBack,movementType,movementID)
	local id = movementID
	if armatureBack._changing == nil then
		armatureBack._changing = true
		if armatureBack._nextAction ~= nil and armatureBack._actionIndex ~= armatureBack._nextAction then
			armatureBack._actionIndex = armatureBack._nextAction
			armatureBack._actionLoopCount = 0
			armatureBack:getAnimation():playWithIndex(armatureBack._nextAction)
			if armatureBack._nextAction == animation_standby then
				armatureBack:getAnimation():setSpeedScale(1.0)
				showSpineAnimationStandby(armatureBack, armatureBack._nextAction)
			else
				armatureBack:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
			end
		end
		if armatureBack._nextFunc ~= nil 
			and armatureBack._nextFunc ~= battle_changeAction_animationEventCallFunc  then
			armatureBack:getAnimation():setMovementEventCallFunc(armatureBack._nextFunc)
		end 
		armatureBack._changing = nil
		
		if armatureBack._invoke ~= nil then
			armatureBack._invoke(armatureBack)
		end
	end
	if armatureBack._actionLoopCount ~= nil then
		armatureBack._actionLoopCount = armatureBack._actionLoopCount + 1
	end
end

local function doSkipCurrentFight()
	if _ED.battleData.battle_init_type == 1 then
		
		if isCanSkipCurrentBattle == true then	
			if zstring.tonumber("".._ED.vip_grade) >= 4 then
				skipCurrentFight = true
			else
				TipDlg.drawTextDailog(_string_piece_info[18])
				skipCurrentFight = false
			end
		else
			TipDlg.drawTextDailog(_string_piece_info[19])
			lockSkipFight = false
		end
	elseif _ED.battleData.battle_init_type == 3 then
		if isCanSkipCurrentBattle == true then	
			if zstring.tonumber("".._ED.vip_grade) >= 4 then
				skipCurrentFight = true
			else
				TipDlg.drawTextDailog(_string_piece_info[20])
				skipCurrentFight = false	
			end
		else
			lockSkipFight = false
			TipDlg.drawTextDailog(_string_piece_info[18])
		end
	elseif _ED.battleData.battle_init_type == 4 then
		if isCanSkipCurrentBattle == true then	
			if zstring.tonumber("".._ED.vip_grade) >= 4 then
				skipCurrentFight = true
			else
				TipDlg.drawTextDailog(_string_piece_info[21])
				skipCurrentFight = false	
			end
		end
	elseif _ED.battleData.battle_init_type >= 10 then
			skipCurrentFight = true
	else
		if isCanSkipCurrentBattle == true then	
			skipCurrentFight = true
		else
			lockSkipFight = false
			TipDlg.drawTextDailog(_string_piece_info[19])
		end
	end
end

nil_animationEventCallFunc = function(armatureBack,movementType,movementID)
	-- 无效的动画帧组监听状态
	if armatureBack._changing == nil then
		armatureBack._nextFunc = nil
		armatureBack._changing = true
		armatureBack:getAnimation():removeMovementEventCallFunc()
		armatureBack._changing = nil
	end
end

animationChangeToAction = function(armature, changeToAction, nextAction)
	if armature._actionIndex == 6 
		or armature._actionIndex == 7 
		or armature._nextAction == 6 
		or armature._nextAction == 7 
		or armature._nextAction ~= animation_standby
		or armature._isDeath == true
		or armature._over == true
		then
		return
	end
	armature._actionLoopCount = 0
	armature._changing = true
	armature:getAnimation():playWithIndex(changeToAction)
	-- armature:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
	if changeToAction == animation_standby then
		armature:getAnimation():setSpeedScale(1.0)
	else
		armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
	end

	armature._actionIndex = changeToAction
	armature._nextAction = animation_standby
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_standby
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_standby
	end
	--> print("被攻击进入待机", armature._camp, armature._pos)
	armature._changing = nil
	showSpineAnimationStandby(armature, changeToAction)
end

local function setVisibleBone(armature, boneName, var)
	armature:getBone(boneName):setVisible(false)
end

local function showRoleHP(armature)
	if armature ~= nil
		-- and armature._hpPragress ~= nil 
		then
		armature._role._hp = armature._role._hp < 0 and 0 or armature._role._hp
		local percent = armature._role._hp/armature._brole._hp * 100
		percent = percent > 100 and 100 or percent
		-- armature._hpPragress:setPercent(percent)
		-- if percent <= 0 and armature._isDeath == true then
		-- 	armature._hpPragress:getParent():setVisible(false)
		-- end
		
		if __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_koone
			then
			if nil ~= armature._heroInfoWidget 
				and 
				nil ~= armature._heroInfoWidget.showRoleHP then
				armature._heroInfoWidget:showRoleHP()
				if armature._role._hp == 0 then
					local function heroDeathFunc()
						armature._heroInfoWidget:controlLife(false, 99)
						armature._heroInfoWidget:showControl(false)
						armature._heroInfoWidget:controlLife(true, 99)
					end
					armature._heroInfoWidget:controlLife(false, 9)
					armature._heroInfoWidget:showControl(true)
					armature._heroInfoWidget:controlLife(true, 9)
					armature._heroInfoWidget:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(heroDeathFunc)))
					if armature:getParent() ~= nil and (__lua_project_id == __lua_project_digimon_adventure 
						-- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
						or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh) then 
						if armature._camp == "0" then 
							armature:getParent():showAngerEffect(false)
						else
							armature:getParent().__angerParent:showAngerEffect(false)
						end
					end
				else
					armature._heroInfoWidget:controlLife(false, 8)
					armature._heroInfoWidget:keepShow(1.0)
				end	
			
			end
		end
		
		-- 更新角色hp显示
		if armature._camp == "0" then
			-- 玩家血量更新
			--> print("我方角色血量更新", armature._pos, tonumber(percent))
			state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 2, _type = 1, _roleIndex = armature._pos, _value = percent})
			state_machine.excute("fight_hero_hp_update", 0, 0)
		else
			-- 敌方血量更新
			--> print("敌方角色血量更新", armature._pos, tonumber(percent))
			state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 1, _type = 1, _roleIndex = armature._pos, _value = percent})
		end
	end
end

local function showRoleSP(armature)
	--> print("更新怒气显示了********************", tonumber(armature._role._sp))
	-- 设置角色怒气
	if armature._camp == "0" then
		-- 玩家怒气更新
		state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 2, _type = 2, _roleIndex = armature._pos, _value = armature._role._sp})
	else
		-- 敌人怒气更新
		state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 1, _type = 2, _roleIndex = armature._pos, _value = armature._role._sp})
	end
	
	if __lua_project_id == __lua_project_warship_girl_b
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_koone
		then
		armature._heroInfoWidget:showRoleSP()
		--更新怒气动画
		if armature:getParent() ~= nil and (__lua_project_id == __lua_project_digimon_adventure 
			-- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh) then 
			if armature._camp == "0" then 
				armature:getParent():showAngerEffect(tonumber(armature._role._sp) >= 4)
			else
				armature:getParent().__angerParent:showAngerEffect(tonumber(armature._role._sp) >= 4)
			end
			
		end
	end
end

-- 移动的状态控制
local beganMoveHero = 0
local function executeMoveOverFunc()
	beganMoveHero = 2
end

-- 返回到原点
local function executeHeroMoveByBackOverFunc()
	beganMoveHero = 12
	began_hero_ZOrder = mPosTile:getLocalZOrder()
	local parent_node = mPosTile:getParent()
	
	-- parent_node:reorderChild(mPosTile, kZOrderInMap_StanddyRole)
	mPosTile._moving = false

	if __lua_project_id == __lua_project_yugioh then
		-- if mPosTile._spArmature ~= nil then
	 --        mPosTile._spArmature:setVisible(true)
		--     if mPosTile._armature ~= nil then
		--         mPosTile._armature:setVisible(false)
		--     end
	 --    end
	end
	executeAttackerBuff()
end

local function executeHeroMoveByBack()
	-- -- local array = CCArray:createWithCapacity(10)
	--array:addObject(CCActionInterval:create(1.2))
	if __fit_roles ~= nil and #__fit_roles > 0 then
		--> print("合体技能的中段处理完毕，现在让角色加到原点来。")
		move_logic.back(__fit_roles, __fit_params)
	else
		if mpos ~= nil then
			local seq = cc.Sequence:create(
				cc.MoveBy:create(mtime * __fight_recorder_action_time_speed, cc.p(-1 * mpos.x, -1 * mpos.y)),
				cc.CallFunc:create(executeHeroMoveByBackOverFunc)
			)
			mPosTile:runAction(seq)
		end
	end
end

-- 移动到目标点				
local function executeHeroMoveBy()
	-- local array = CCArray:createWithCapacity(10)
	-- --array:addObject(CCActionInterval:create(1.2))
	-- array:addObject(cc.MoveBy:create(mtime * __fight_recorder_action_time_speed, mpos))
	-- array:addObject(CCCallFunc:create(executeMoveOverFunc))
	if mpos ~= nil then
		local seq = cc.Sequence:create(
			cc.MoveBy:create(mtime * __fight_recorder_action_time_speed, mpos),
			cc.CallFunc:create(executeMoveOverFunc)
		)
		mPosTile:runAction(seq)
	end

	-- 修改 Z轴
	began_hero_ZOrder = mPosTile:getLocalZOrder()
	local parent_node = mPosTile:getParent()
	
	-- parent_node:reorderChild(mPosTile, kZOrderInMap_MoveRole)
	mPosTile._moving = true
	parent_node:reorderChild(mPosTile, kZOrderInMap_MoveRole)
end
-- END~攻击前的移动准备
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
local function changeActtackToAttackMoving(armatureBack)
	local armature = armatureBack
	local camp = zstring.tonumber(armature._camp) + 1
	-- local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.attack_move_action), ",")
	-- local actionIndex = zstring.tonumber(indexs[camp])
	local skillProperty = dms.atoi(armature._sie_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local actionIndex = skillProperty == 0 and _enum_animation_frame_index.animation_attack_moving or _enum_animation_frame_index.animation_skill_moving
	armature._nextAction = actionIndex
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = actionIndex
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = actionIndex
	end
	--> print("进入攻击移动：", actionIndex)
end

local function changeActtackToAttackBegan(armatureBack)
	local armature = armatureBack
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		battle_execute._roleExecuteAttacking(armatureBack)
	else
		local camp = zstring.tonumber(armature._camp) + 1
		--> print("dms.atos(armature._sie_action, skill_influence.before_action):", dms.atos(armature._sie_action, skill_influence.before_action))
		local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.before_action), ",")
		local actionIndex = zstring.tonumber(indexs[camp])
		armature._nextAction = actionIndex
		armature._invoke = attackChangeActionCallback
		iii = ii +1
		--> print("进入攻击前段：", actionIndex)

		if nil ~= armature._child_list then
			for i, v in pairs(armature._child_list) do
				v._nextAction = actionIndex
			end
		elseif nil ~= armature._weapon then
			armature._weapon._nextAction = actionIndex
		end
	end

	local forepart_lighting_sound_effect_id = dms.atoi(armature._sie_action, skill_influence.forepart_lighting_sound_effect_id)
	if forepart_lighting_sound_effect_id >= 0 then
		playEffectMusic(forepart_lighting_sound_effect_id)
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		
	else
		-- fwin:close(fwin:find("DrawHitDamageClass"))
		fwin:open(DrawHitDamage:new():init(0, 0), fwin._view)
	end
end

local function changeActtackToAttacking(armatureBack)
	local armature = armatureBack
	--> print("进入攻击中段：", armature._nextAction, armature._actionIndex)
	iii = ii + 1
	local camp = zstring.tonumber(armature._camp) + 1
	local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.after_action), ",")
	local actionIndex = zstring.tonumber(indexs[camp])
	armature._actionIndex = actionIndex
	armature._nextAction = actionIndex
	-- armature._invoke = attackChangeActionCallback
	--> print("进入攻击中段：", actionIndex)

	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = actionIndex
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = actionIndex
	end

	-- 角色是否在攻击中消失
	local hideAttackRole = false
	if armatureBack._sed_action ~= nil then
		if dms.atoi(armatureBack._sed_action, skill_mould.after_remove) == 1 then
			hideAttackRole = true
		end
	end
	if hideAttackRole == true then
		armatureBack:setVisible(false)
	end
end

local function changeActtackToAttackAfter(armatureBack)
	if tonumber(armatureBack._pos) == 101 or tonumber(armatureBack._pos) == 102 then
		local function executeAttackLogicingFunc(armatureBack)
	        armatureBack._actionIndex = animation_remote_skill_end
			attackChangeActionCallback(armatureBack)
	    end
		local array = {}
        table.insert(array, cc.DelayTime:create(0.5))
        table.insert(array, cc.CallFunc:create(executeAttackLogicingFunc))
        local seq = cc.Sequence:create(array)
		armatureBack:runAction(seq)
	else
		local armature = armatureBack
		local camp = zstring.tonumber(armature._camp) + 1
		local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.attack_over_action), ",")
		local actionIndex = zstring.tonumber(indexs[camp])
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			-- armature._actionIndex = animation_standby
			-- armature:getAnimation():playWithIndex(actionIndex)
			-- armature._nextAction = actionIndex
			-- if nil ~= armature._child_list then
			-- 	for i, v in pairs(armature._child_list) do
			-- 		v._actionIndex = animation_standby
			-- 		v:getAnimation():playWithIndex(actionIndex)
			-- 		v._nextAction = actionIndex
			-- 	end
			-- elseif nil ~= armature._weapon then
			-- 	armature._weapon._actionIndex = animation_standby
			-- 	armature._weapon:getAnimation():playWithIndex(actionIndex)
			-- 	armature._weapon._nextAction = actionIndex
			-- end

			roleExecuteAttackOver(armatureBack)
		else
			armature._nextAction = actionIndex
			if nil ~= armature._child_list then
				for i, v in pairs(armature._child_list) do
					v._nextAction = actionIndex
				end
			elseif nil ~= armature._weapon then
				armature._weapon._nextAction = actionIndex
			end
			-- armature._invoke = attackChangeActionCallback
		end
		--> print("进入攻击后段：", actionIndex)

		-- 角色是否在攻击中消失,进行出现
		armatureBack:setVisible(true)
	end
end



-- 近身移动
executeMoveMeleeAttackBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_attack_moving
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_attack_moving
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_attack_moving
	end
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	-- 近身移动
	--> print("近身移动")
end

-- 近身攻击
executeMeleeAttackBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_attack_began
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_melee_attack_began
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_melee_attack_began
	end
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	-- 近身攻击1
	--> print("近身攻击1")
end

executeMeleeAttacking = function(armatureBack)
	--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
	--mtime = moveToTargetTime1
	--executeHeroMoveBy()
					
	executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_melee_attacking
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_melee_attacking
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_melee_attacking
	end
	-- 近身攻击2
end

executeMeleeAttackEnd = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_attack_end
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_melee_attack_end
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_melee_attack_end
	end
	-- 近身攻击3
end
-- END~近身攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 远程攻击
executeRemoteAttackBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_attack_began
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_remote_attack_began
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_remote_attack_began
	end
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	-- 远程攻击1
	--> print("远程攻击1")
end

executeRemoteAttacking = function(armatureBack)
	executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_remote_attacking
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_remote_attacking
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_remote_attacking
	end
	-- 远程攻击2
end

executeRemoteAttackEnd = function(armatureBack)
	--executeAttacking()
	local armature = armatureBack
	armature._nextAction = animation_remote_attack_end
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_remote_attack_end
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_remote_attack_end
	end
	armature._over = true
	-- 远程攻击3
	
	--armatureBack:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
end
-- END~远程攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 移动技能近身攻击
executeMoveMeleeSkillBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_skill_moving
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_skill_moving
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_skill_moving
	end
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	-- 技能近身攻击1
	--> print("技能近身攻击1")
end

-- 技能近身攻击
executeMeleeSkillBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_skill_began
	if nil ~= armature._weapon then
		armature._weapon._nextAction = animation_melee_skill_began
	end
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	-- 技能近身攻击1
	--> print("技能近身攻击1")
end

executeMeleeSkilling = function(armatureBack)	
	--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
	--mtime = moveToTargetTime2
	--executeHeroMoveBy()
	
	executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_melee_skilling
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_melee_skilling
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_melee_skilling
	end
	-- 技能近身攻击2

end

executeMeleeSkillEnd = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_skill_end
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_melee_skill_end
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_melee_skill_end
	end
	-- 技能近身攻击3
end
-- END~技能近身攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 技能远程攻击
executeRemoteSkillBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_skill_began
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_remote_skill_began
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_remote_skill_began
	end
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	-- 技能远程攻击1
	--> print("技能远程攻击1")
end

executeRemoteSkilling = function(armatureBack)
	if executeAfterInfluenceCount > 0 then
		-- 启动反击
		executeAfterAttack()
	else
		executeAttack()
	end
	local armature = armatureBack
	armature._nextAction = animation_remote_skilling
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_remote_skilling
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_remote_skilling
	end
	-- 技能远程攻击2
end

executeRemoteSkillEnd = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_skill_end
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_remote_skill_end
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_remote_skill_end
	end
	-- 技能远程攻击3
end
-- END~技能远程攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 被攻击光效
executeHeroByAttack = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_hero_by_attack
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_hero_by_attack
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_hero_by_attack
	end
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	--> print("被攻击光效")
end

executeEmenyByAttack = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_emeny_by_attack
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = animation_emeny_by_attack
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = animation_emeny_by_attack
	end
	armature._invoke = attackChangeActionCallback
	iii = ii +1
	--> print("被攻击光效2")
end
-- END~被攻击光效
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 绘制攻击伤害数字
executeDrawAttackHurtNmber = function(armatureBack)
	-- 绘制伤害数字
end
-- END~绘制攻击伤害数字
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 清除BUFF

local function cleanBuffEffectWithMiss(_posTile, _isMiss)
	-- 清除角色的BUFF
	if _posTile ~= nil and _posTile._buff ~= nil and _posTile._effectivenessId == 84 then
		for i, v in pairs(_posTile._buff) do
			if (v._LastsCountTurns ~= nil and v._LastsCountTurns >= 0) or _isMiss == true then
				v._LastsCountTurns = 0
				deleteEffectFile(v)
			end
		end
		_posTile._buff = {}
	end
end

local function cleanBuffEffect(_posTile, _death)
	-- 清除角色的BUFF
	if _posTile ~= nil and _posTile._buff ~= nil then
		for i, v in pairs(_posTile._buff) do
			if (v._LastsCountTurns ~= nil and v._LastsCountTurns >= 0) or _death == true then
				v._LastsCountTurns = 0
				if v._LastsCountTurns <= 0 then
					-- 清除角色的BUFF
					deleteEffectFile(v)
					--_posTile._buff[i] = nil
				end
			end
		end
		_posTile._buff = {}
	end
	if _posTile ~= nil and _death == true then
		-- _posTile:removeAllChildren(true)
		_posTile:setVisible(false)
	end
end
		
-- 角色死亡光效
executeRoleDeath = function(armatureBack)
	-- 角色进行死亡帧
	--print("角色进行死亡帧")
	local armature = armatureBack
	if true == armature._isDeath then
		return
	end
	armature._isDeath = true
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		armature._actionIndex = animation_standby
		-- armature._actionIndex = animation_death
		armature._nextAction = animation_death
		armature:getAnimation():playWithIndex(animation_death)
		armature._nextAction = animation_death
		armature._actionIndex = animation_death
		if nil ~= armature._child_list then
			for i, v in pairs(armature._child_list) do
				v._actionIndex = animation_death
				v:getAnimation():playWithIndex(animation_death)
				v._nextAction = animation_death
				-- v:setVisible(false)
			end
		elseif nil ~= armature._weapon then
			armature._weapon._actionIndex = animation_death
			armature._weapon:getAnimation():playWithIndex(animation_death)
			armature._weapon._nextAction = animation_death
			if __lua_project_id == __lua_project_pacific_rim then
			else
				armature._weapon:setVisible(false)
			end
		end
		if armature._shadow ~= nil then
			armature._shadow:setVisible(false)
		end
	else
		armature._nextAction = animation_death
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	else
		armature._invoke = attackChangeActionCallback
	end

	if BattleSceneClass._isSkepBattle == true then

	else
		if __lua_project_id == __lua_project_pacific_rim then
		else
			local pos = tonumber(armatureBack._pos)
			if pos <= 3 then
				local node = getRole(tonumber(armatureBack._posTile._camp), pos + 3)
				if nil ~= node and nil ~= node._armature 
					and node._armature._isDeath ~= true 
					and node._armature._after_death ~= true
					and tonumber(node._armature._pos) == (pos + 3) then
					local offsetY = 86
					if armatureBack._posTile._camp == "1" then		
						offsetY = -1 * offsetY
					end
					battle_execute._changeToAction(node._armature, animation_moving)
					node._armature._nextAction = animation_moving
					if nil ~= node._armature._child_list then
						for i, v in pairs(node._armature._child_list) do
							battle_execute._changeToAction(v, animation_moving)
							v._nextAction = animation_moving
						end
					end
		        	node:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.MoveBy:create(2, cc.p(0, offsetY)), cc.CallFunc:create(function ( sender )
		        		if sender._armature._nextAction == animation_moving then
		        			battle_execute._changeToAction(sender._armature, animation_standby)
		                end
						if nil ~= sender._armature._child_list then
							for i, v in pairs(sender._armature._child_list) do
								if v._nextAction == animation_moving then
									battle_execute._changeToAction(v, animation_standby)
								end
							end
						end
		        	end)))
				end
			end
		end
	end
	
	if armatureBack._posTile._camp == "1" then			
		if armatureBack._isByReact == true then
			-- 敌方角色死亡-被格挡反击致死
		else
			-- 敌方角色死亡
		end
		
		-- 清除角色的BUFF
		if armatureBack._posTile._buff ~= nil then
			for i, v in pairs(armatureBack._posTile._buff) do
				if v ~= nil and v._LastsCountTurns ~= nil then
					v._LastsCountTurns = 0
					if v._LastsCountTurns <= 0 then
						-- 清除角色的BUFF
						deleteEffectFile(v)
						armatureBack._posTile._buff[i] = nil
					end
				end
			end
		end
	
		if armatureBack._def ~= nil and armatureBack._def.defAState == "1" then
			-- 敌方角色死亡， 掉落：", armatureBack._def.dropCount
			-- local fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10866")
			-- local str = tolua.cast(fightRewardItemCount,"Label"):getStringValue()
			-- str = ""..(zstring.tonumber(str) + zstring.tonumber(armatureBack._def.dropCount))
			-- tolua.cast(fightRewardItemCount,"Label"):setText(str)
			-- if armatureBack._def.dropCount > 0 then
				-- local armatureEffect = createEffect(armatureBack._posTile, 96, 0)
				-- armatureEffect._invoke = deleteEffectFile
			-- end
		else
			-- 敌方角色死亡， 掉落：", armatureBack._def.dropCount
			-- local fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10866")
			-- local str = tolua.cast(fightRewardItemCount,"Label"):getStringValue()
			-- str = ""..(zstring.tonumber(str) + zstring.tonumber(armatureBack._dropCount))
			-- tolua.cast(fightRewardItemCount,"Label"):setText(str)
			-- local armatureEffect = createEffect(armatureBack._posTile, 96, 0)
			-- armatureEffect._invoke = deleteEffectFile
		end
		
		armature._role._hp = 0
		showRoleHP(armature)
	else
		
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			armature._role._hp = 0
			showRoleHP(armature)
		end

		state_machine.excute("fight_hero_deathed", 0, 0)
		-- 我方角色死亡, 通知UI层更新状态
		-- 清除角色的BUFF
		if armatureBack ~= nil 
			and armatureBack._posTile ~= nil 
			and armatureBack._posTile._buff ~= nil 
			then
			for i, v in pairs(armatureBack._posTile._buff) do
				if v ~= nil and v._LastsCountTurns ~= nil then
					v._LastsCountTurns = 0
					if v._LastsCountTurns <= 0 then
						-- 清除角色的BUFF
						deleteEffectFile(v)
						armatureBack._posTile._buff[i] = nil
					end
				end
			end
		end
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		if armature._role._camp_preference == 20 then
		else
			local armatureEffect = createEffect(armature._posTile, "death", armature._posTile._camp, false, -1)
			armatureEffect._base = armature
			armatureEffect._sie = armature._sie
			armatureEffect._def = armature._def
			armatureEffect._invoke = deleteEffectFile
		end
	end
end
-- END~被攻击光效
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 技能技能光效帧事件监听

local function removeFrameObjectFuncN(sender)
	sender:removeFromParent(true)
end

local function checkFrameEvent(events, mode)
	if events ~= n and #events > 0 then
		for i, v in pairs(events) do
			if v == mode then
				return true
			end
		end
	end
	return false
end

local function checkAtferDeath(armature)
	if armature._after_death == true then
		return true
	end
	if _ED.battleData._deaths["" .. armature._camp .. "-" .. armature._pos] ~= true then
		return false
	end
	if _ED.attackData == nil then
		return false
	end
	local _roundData = _ED.attackData.roundData[currentRoundIndex]
	for i = currentRoundAttackIndex, _roundData.curAttackCount do
		local attData = _roundData.roundAttacksData[i]
		local attacker 				= attData.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
		local attackerPos 			= attData.attackerPos 					-- = npos(list)		--出手方位置(1-6)
		if attacker == armature._camp and attackerPos == armature._pos then
			return false
		end
	end
	_roundData = _ED.attackData.roundData[currentRoundIndex + 1]
	if nil ~= _roundData then
		for i = 1, _roundData.curAttackCount do
			local attData = _roundData.roundAttacksData[i]
			local attacker 				= attData.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
			local attackerPos 			= attData.attackerPos 					-- = npos(list)		--出手方位置(1-6)
			if attacker == armature._camp and attackerPos == armature._pos then
				return false
			end
		end
	end
	armature._after_death = true
	return true
end

local function drawFrameEvent(armature, armatureBase, _def, bone,evt,originFrameIndex,currentFrameIndex)
	--> print("evt:", evt)
	if BattleSceneClass._isSkepBattle == true then
		return
	end
	if evt ~= nil and #evt > 0 then
		local datas = zstring.split(evt, "_")
		if checkFrameEvent(datas, "start") == true then
			local tempArmature = armatureBack
			if tempArmature == nil then
				tempArmature = bone:getArmature()
			end
			if tempArmature ~= nil and tempArmature._angle ~= nil then
				-- 创建飞行的光效
				--> print("绘制路径光效！！！")
				createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
			end
		end
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			if checkFrameEvent(datas, "over") == true then
				battle_execute._executeEffectSkillingOverBullet(armature)
			end
		end
		if checkFrameEvent(datas, "after") == true then
			if _def~=nil then
				local defenderST = _def.defenderST
				if armatureBase._isReact == true or defState == "3" or defState == "4" then
				else
					-- 修改BUFF处理状态(6为中毒，9为灼烧)
					if (defenderST == "4" or defenderST == "5" or defenderST == "6" or defenderST == "7" or 
						defenderST == "8" or defenderST == "9" or defenderST == "10" or defenderST == "11" or 
						defenderST == "12" or defenderST == "13" or defenderST == "15" 
						or defenderST == "21"
						or defenderST == "22"
						or defenderST == "23"
						or defenderST == "24"
						or defenderST == "25"
						or defenderST == "26"
						or defenderST == "27"
						or defenderST == "28"
						or defenderST == "29"
						or defenderST == "30"
						or defenderST == "32"
						or defenderST == "33" -- 33造成伤害增加
						) then
					elseif defenderST == "2" or defenderST == "3" or 
							-- defenderST == "4" or 
							defenderST == "5" or
							defenderST == "7" or defenderST == "8" or 
							defenderST == "10" or defenderST == "11" or 
							defenderST == "14" then
					else
						-- 处理被攻击的后段光效
						armature._base = armatureBase
						executeEffectSkillEnd(armature)
					end
				end
			end
		end
		if checkFrameEvent(datas, "hurt") == true then
			--> print("绘制攻击伤害！！！")
		else
			--> print("无效的帧事件！！！")
			return
		end
	else
		--> print("无效的帧事件！！！")
		return
	end
	
	-- 绘制伤害数值
	--local armature = armatureBack
	if _def==nil or _def._attackSection <= 0 then
		return
	end
	_def._attackSection = _def._attackSection - 1
	
	armature._hurtCount = armature._hurtCount == nil and 0 or armature._hurtCount
	local _widget = armatureBase._posTile
	if _widget == nil then
		return
	end
	
	if armatureBase._is_vibrate == 1 then
		draw.share()
	end
	
	local tempX, tempY  = _widget:getPosition()
	local widgetSize = _widget:getContentSize()
	
	-- local _def = armature._def
	armature._def = _def
	
	local defState = _def.defState
	local defenderST = _def.defenderST
	local drawString = _def.subValue == nil and _def.stValue or _def.subValue --_def.stValue
	local defAState =  _def.defAState
	if armatureBase._isByReact == true then
		defState = armatureBase._defr.fightBackDefState
		defenderST = armatureBase._defr.fightBackSkf
		drawString = armatureBase._defr.fightBackValue
		defAState = armatureBase._defr.fightBackLiveState
		--[[
		defState = _def.fightBackDefState
		defenderST = _def.fightBackSkf
		defAState = _def.fightBackLiveState
		--]]
	end
	
	-- 控制角色被攻击时的动画及被攻击帧
	local changeToAction = nil
	local _tcamp = tonumber(armatureBase._camp)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	else
		if defState == "0" then
			-- 命中的时候切换动作帧组
			changeToAction = animation_hero_by_attack + _tcamp
		elseif defState == "1" then
			-- 闪避的时候切换动作帧组
			changeToAction = animation_hero_miss + _tcamp
		elseif defState == "2" then
			-- 暴击的时候切换动作帧组
			changeToAction = animation_hero_by_attack + _tcamp
		elseif defState == "3" then
			-- 格挡的时候切换动作帧组
			--changeToAction = animation_hero_by_attack + _tcamp
		end
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		changeToAction = animation_hero_by_attack
		if armatureBase._after_death == true then
			armatureBase._nextAction = animation_dizziness
			changeToAction = animation_dizziness
		end
	end
	
	if defenderST == "1" or defenderST == "2" or defenderST == "3" or 
			defenderST == "4" or defenderST == "5" or
			defenderST == "6" or
			defenderST == "7" or defenderST == "8" or 
			defenderST == "9" or
			defenderST == "10" or defenderST == "11" or 
			defenderST == "12" or defenderST == "14" 
			or defenderST == "21"
			or defenderST == "22"
			or defenderST == "23"
			or defenderST == "24"
			or defenderST == "25"
			or defenderST == "26"
			or defenderST == "27"
			or defenderST == "28"
			or defenderST == "29" 
			or defenderST == "30"
			or defenderST == "31"
			or defenderST == "32"
			or defenderST == "33" -- 33造成伤害增加
			then
	elseif changeToAction ~= nil  and armatureBase._isDeath ~= true then
		--> print("被攻击动作:", changeToAction)
		if armatureBase._after_death == true then
		else
			animationChangeToAction(armatureBase, changeToAction, animation_standby)
		end
	end
	
	if armatureBase._isReact == true or defState == "3" or defState == "4" then
		if armatureBase._isReacting ~= true then
			armatureBase._isReacting = true
			-- 已经进入到了反击
			executeEffectSkillEnd(armature)
		end
	else
		-- 修改BUFF处理状态(6为中毒，9为灼烧)
		if (defenderST == "4" 
			or defenderST == "5" 
			or defenderST == "6" 
			or defenderST == "7" 
			or defenderST == "8" 
			or defenderST == "9" 
			or defenderST == "10" 
			or defenderST == "11" 
			or defenderST == "12" 
			or defenderST == "13" 
			or defenderST == "15"
			) then
			if armature._executeBuffs == nil then
				armature._executeBuffs = {}
			end
			if armature._executeBuffs[armature._def.defenderST] ~= true then 
				armature._executeBuffs[armature._def.defenderST] = true
				-- 处理被攻击的后段光效
				armature._base = armatureBase
				executeEffectSkillEnd(armature)
			end
			if defenderST == "13" then
				armatureBase._posTile._effectivenessId = 84
			end
		elseif defenderST == "2" 
			or defenderST == "3" 
			--or defenderST == "4" 
			or defenderST == "5" 
			or defenderST == "7" 
			or defenderST == "8" 
			or defenderST == "10" 
			or defenderST == "11" 
			or defenderST == "14" 
			or defenderST == "21"
			or defenderST == "22"
			or defenderST == "23"
			or defenderST == "24"
			or defenderST == "25"
			or defenderST == "26"
			or defenderST == "27"
			or defenderST == "28"
			or defenderST == "29"
			or defenderST == "30" -- 闪避
			or defenderST == "33" -- 33造成伤害增加
			then
		else
			-- 处理被攻击的后段光效
			armature._base = armatureBase
			-- executeEffectSkillEnd(armature)
		end
	end
		
	-- 处理伤害
	-- 技能种类：0为攻击，1为加血，2为加怒，3为减怒，4为禁怒，5为眩晕，6为中毒，7为麻痹，8为封技，9为灼烧，10为爆裂，11为增加档格，12为增加防御, 13为必闪, 14为吸血,15禁疗
	-- 0为攻击		
	-- 1为加血		
	-- 2为加怒	即时	
	-- 3为减怒	即时	
	-- 4为封怒（无法积累怒气）	回合	
	-- 5为眩晕（无法行动）	回合	
	-- 6为腐蚀（中毒）	回合	
	-- 7为麻痹（无法普通攻击）	回合	
	-- 8为封技（无法怒气攻击）	回合	
	-- 9为燃烧	回合	
	-- 10为集中	即时	
	-- 11为格挡	即时	
	-- 12为无敌	即时	
	-- 13必闪	即时	
	-- 14吸血	即时	
	-- 15封疗	即时	
	-- 16盲目	即时	
	-- 17残废	即时	
	-- 18备用		
	-- 19备用		
	-- 20备用		
	-- 21增加攻击	即时	
	-- 22降低攻击	即时	
	-- 23增加防御	即时	
	-- 24降低防御	即时	
	-- 25受到的伤害增加	回合	
	-- 26受到的伤害降低	回合	
	-- 27增加暴击	回合	
	-- 28增加抗暴	回合	
	-- 29增加命中	回合	
	-- 30增加闪避	回合	
	-- 31持续回血	回合	
	-- 32清除负面效果	即时	  - 31draw
	-- 33造成伤害增加	即时
	if defenderST == "0" or
		defenderST == "6"
		then
		if tonumber(_def.defender) == 1 then
			-- BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(drawString)
		end
		if tonumber(drawString) > 0  then
			drawString = "-"..(zstring.tonumber(drawString) or 0)
		end
	elseif defenderST == "1" 
		or defenderST == "9" 
		-- or defenderST == "31" 
		then
		drawString = "+"..(zstring.tonumber(drawString) or 0)
	end
	
	if (defenderST == "2" or defenderST == "3") and (armatureBase~= nil and armatureBase._role ~= nil) then
		if _def.stVisible == "1" and defState ~= "1" and defState ~= "5" then
			armatureBase._role._sp = armatureBase._role._sp + ((defenderST == "2" and 1 or -1) * tonumber(drawString))
			if armatureBase._role._sp < 0 then
				armatureBase._role._sp = 0
			end
			showRoleSP(armatureBase)
		end
	end
	
	---------------------------------------------------------------------------
	-- 增加相克状态
	---------------------------------------------------------------------------
	local restrainState = _def.restrainState -- 		= npos(list) --相克状态(0,无克制 1,有克制,2被克制)
	
	if restrainState == "1" and armature._hurtCount == 0 then
		-- local xiangke = cc.Sprite:createWithSpriteFrameName("images/ui/battle/xiangke.png")
		-- xiangke:setAnchorPoint(cc.p(0.5, 0.5))
		-- xiangke:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
		-- _widget:getParent():addChild(xiangke, kZOrderInMap_Hurt)
		
		-- local seq = cc.Sequence:create(
			-- cc.MoveBy:create(0.4 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
			-- cc.CallFunc:create(removeFrameObjectFuncN)
		-- )
		-- xiangke:runAction(seq)
		-- cleanBuffEffectWithMiss(armatureBase._posTile,true)
		
		local armatureEffect = createEffectCoverSkill(armatureBase._posTile, 999, zstring.tonumber(armature._camp))
		armatureEffect._invoke = deleteEffectFile
	end
	---------------------------------------------------------------------------

	
	local numberFilePath = nil
	local isMissed = false
	-- 0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格
	if defState == "0" or defState == "3" or defState == "4" then
		-- 命中
		if defenderST == "1" 
			or defenderST == "14" 
			-- or defenderST == "31" 
			then
			numberFilePath = "images/ui/number/jiaxue.png"
			local dnum = zstring.tonumber(drawString)
			if dnum ~= nil and armatureBase._role._hp ~= nil and drawString ~= nil and drawString ~= ""then 
				armatureBase._role._hp = zstring.tonumber(armatureBase._role._hp) + dnum
			end
			showRoleHP(armatureBase)
		elseif defenderST == "2" 
			or defenderST == "3" 
			or defenderST == "4" 
			or defenderST == "5" 
			or defenderST == "6" 
			or defenderST == "7" 
			or defenderST == "8" 
			or defenderST == "9" 
			or defenderST == "10" 
			or defenderST == "11" 
			or defenderST == "12" 
			or defenderST == "13" 
			or defenderST == "15"
			then
		elseif defenderST == "21"
			or defenderST == "22"
			or defenderST == "23"
			or defenderST == "24"
			or defenderST == "25"
			or defenderST == "26"
			or defenderST == "27"
			or defenderST == "28"
			or defenderST == "29"
			or defenderST == "30"
			or defenderST == "33"
			or defenderST == "31"
			or defenderST == "35"
			then
			-- if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			-- else
			-- end
			local miss = cc.Sprite:createWithSpriteFrameName("images/ui/battle/".._battle_buff_effect_dictionary[zstring.tonumber(defenderST) + 1]..".png")
			miss:setAnchorPoint(cc.p(0.5, 0.5))
			miss:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
			_widget:getParent():addChild(miss, kZOrderInMap_Hurt)
			
			local seq = cc.Sequence:create(
				cc.MoveBy:create(0.4 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
				cc.CallFunc:create(removeFrameObjectFuncN)
			)
			miss:runAction(seq)
			cleanBuffEffectWithMiss(armatureBase._posTile,true)
		elseif defenderST == "32" then 
			--清除
			if armatureBase._sie ~= nil then 
				local cleanStateId = dms.atoi(armatureBase._sie, skill_influence.formula_info)
				if cleanStateId ~= nil and cleanStateId ~= -1 and armatureBase._posTile._buff ~= nil then 
					--清除负面状态
					for k,v in pairs(armatureBase._posTile._buff) do
						if cleanStateId == zstring.tonumber(k) then 
							v._LastsCountTurns = 0
							deleteEffectFile(v)
							armatureBase._posTile._buff[k] = nil
							break
						end
					end
				end
			end	
		else
			numberFilePath = "images/ui/number/xue.png"
			armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
			showRoleHP(armatureBase)
			--> print("--------------------减血：",drawString)
			-- 绘制连击伤害
			if defenderST == "0" then
				state_machine.excute("draw_hit_damage_draw_hit_count", 0, 1)
				state_machine.excute("draw_hit_damage_draw_hit_damage", 0, math.abs(tonumber(drawString)))
			end
		end
	elseif defState == "1" 
		then
		if defenderST == "0" 
			then
			isMissed = true
			-- 闪避
			local miss = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shanbi.png")
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				if miss == nil then
					cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
			    	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
			    	miss = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shanbi.png")
				end
			end
			miss:setAnchorPoint(cc.p(0.5, 0.5))
			miss:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
			_widget:getParent():addChild(miss, kZOrderInMap_Hurt)
			
			local seq = cc.Sequence:create(
				cc.MoveBy:create(0.4 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
				cc.CallFunc:create(removeFrameObjectFuncN)
			)
			miss:runAction(seq)
			cleanBuffEffectWithMiss(armatureBase._posTile,true)
		end
	elseif defState == "2" 
		or defState == "4" 
		then
		if armature._hnb ~= true then
			if defenderST == "1" then
				numberFilePath = "images/ui/number/baoji.png"
			else
				numberFilePath = "images/ui/number/baoji.png"
			end
			--armature._hnb = true
			armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
			showRoleHP(armatureBase)
		end
	elseif defState == "3" then
		-- 格挡
	---elseif defState == "4" then
		-- 暴击加挡格
	end
	
	--> print("drawFrameEvent : 处理伤害绘图")
	if defenderST == "2" or defenderST == "3" then
		if _def.stVisible == "1"  and  defState ~= "1" and defState ~= "5" then
			-- 怒气动画
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			else
				local spSprite = cc.Sprite:createWithSpriteFrameName(string.format("images/ui/battle/%s.png", defenderST == "2" and "nuqijia" or "nuqijian"))
				spSprite:setAnchorPoint(cc.p(0.5, 0.5))
				spSprite:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
				_widget:getParent():addChild(spSprite, kZOrderInMap_Hurt)
				
				local seq = cc.Sequence:create(
					cc.MoveBy:create(0.5 * __fight_recorder_action_time_speed, cc.p(0, (defenderST == "2" and 1 or -1) * 100 / CC_CONTENT_SCALE_FACTOR())),
					cc.CallFunc:create(removeFrameObjectFuncN)
				)
				spSprite:runAction(seq)
			end
		end
	end
	
	--> print("drawFrameEvent : 处理伤害绘图1")

	local labelAtlas = nil
	if numberFilePath ~= nil and drawString~= nil then
		if __lua_project_id == __lua_project_digimon_adventure  
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
			--> print(numberFilePath)
			labelAtlas = cc.LabelAtlas:_create(drawString, numberFilePath, 40, 48, 43)  
		elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then 
			-- 绘制被攻击者的状态图
			if _def.ctrEfeect[1] == "1" then
				local sprite = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shield_2.png")
				if sprite == nil then
					cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
			    	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
			    	sprite = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shield_2.png")
				end
				if _tcamp == 1 then
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 - 42)) 
					-- sprite:setPosition(cc.p(-62, -42)) 
					sprite:setPosition(cc.p(32, 42)) 
					if __lua_project_id == __lua_project_pacific_rim then
					else
						sprite:setScaleX(1)
						sprite:setScaleY(-1)
					end
				else
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 + 42)) 
					sprite:setPosition(cc.p(32, 42)) 
				end
				-- _widget:getParent():addChild(sprite, 100)
				_widget._armature:addChild(sprite, 100)
				sprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function ( sender )
					sender:removeFromParent(true)
				end)))
			elseif _def.ctrEfeect[2] == "1" then
				local sprite = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shield_1.png")
				if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
					if sprite == nil then
						cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
				    	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
				    	sprite = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shield_1.png")
					end
				end
				if _tcamp == 1 then
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 - 42)) 
					-- sprite:setPosition(cc.p(-32, -42)) 
					sprite:setPosition(cc.p(32, 42)) 
					if __lua_project_id == __lua_project_pacific_rim then
					else
						sprite:setScaleX(1)
						sprite:setScaleY(-1)
					end
				else
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 + 42)) 
					sprite:setPosition(cc.p(32, 42)) 
				end
				-- _widget:getParent():addChild(sprite, 100)
				_widget._armature:addChild(sprite, 100)
				sprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function ( sender )
					sender:removeFromParent(true)
				end)))
			elseif _def.ctrEfeect[4] == "1" then
				local spriteBg = cc.Sprite:create("images/ui/icon/icon_100.png")
				local sprite = cc.Sprite:create("images/ui/props/props_6020.png")
				if _tcamp == 1 then
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 - 42)) 
					-- spriteBg:setPosition(cc.p(32, 42)) 
					spriteBg:setPosition(cc.p(-32, -42)) 
					if __lua_project_id == __lua_project_pacific_rim then
						spriteBg:setScale(0.4)
					else
						spriteBg:setScaleX(0.4)
						spriteBg:setScaleY(-0.4)
					end
				else
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 + 42)) 
					spriteBg:setPosition(cc.p(-32, -42)) 
					spriteBg:setScale(0.4)
				end
				-- _widget:getParent():addChild(sprite, 100)
				local size = spriteBg:getContentSize()
				sprite:setPosition(cc.p(size.width / 2, size.height / 2))
				spriteBg:addChild(sprite)
				_widget._armature:addChild(spriteBg, 100)
				sprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0)))
				spriteBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function ( sender )
					sender:removeFromParent(true)
				end)))
			elseif _def.ctrEfeect[6] == "1" then
				local spriteBg = cc.Sprite:create("images/ui/icon/icon_100.png")
				local sprite = cc.Sprite:create("images/ui/props/props_6022.png")
				if _tcamp == 1 then
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 - 42)) 
					-- spriteBg:setPosition(cc.p(32, 42)) 
					spriteBg:setPosition(cc.p(-32, -42)) 
					if __lua_project_id == __lua_project_pacific_rim then
						spriteBg:setScale(0.4)
					else
						spriteBg:setScaleX(0.4)
						spriteBg:setScaleY(-0.4)
					end
				else
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 + 42)) 
					spriteBg:setPosition(cc.p(-32, -42)) 
					spriteBg:setScale(0.4)
				end
				-- _widget:getParent():addChild(sprite, 100)
				local size = spriteBg:getContentSize()
				sprite:setPosition(cc.p(size.width / 2, size.height / 2))
				spriteBg:addChild(sprite)
				_widget._armature:addChild(spriteBg, 100)
				sprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0)))
				spriteBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function ( sender )
					sender:removeFromParent(true)
				end)))
			end		

			--> print("本次的伤害值：", drawString)
			if _def._attackCount > 1 then
				local dv = "-1" .. math.floor(tonumber(_def.stValue * config_res.battle.hit_damage_rate[_def._hurtCount]))
				labelAtlas = cc.LabelBMFont:create(dv,"fonts/xue.fnt") 
			else
				labelAtlas = cc.LabelBMFont:create(drawString,"fonts/xue.fnt") 
			end
		else
			labelAtlas = cc.LabelAtlas:_create(drawString, numberFilePath, 34, 46, 43)   
		end
		--> print("drawFrameEvent : 处理伤害绘图2")
		-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
		labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
		labelAtlas:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0 + armature._hurtCount * ( 4))) 
		_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt)
		
		if defState == "2" or defState == "4" then
			local crit = cc.Sprite:createWithSpriteFrameName("images/ui/battle/baoji.png")
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				if crit == nil then
					cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
			    	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
			    	crit = cc.Sprite:createWithSpriteFrameName("images/ui/battle/baoji.png")
				end
			end
			crit:setAnchorPoint(cc.p(0.5, 0.5)) 
			labelAtlas:addChild(crit, kZOrderInMap_Hurt)
			crit:setPosition(cc.p(labelAtlas:getContentSize().width/2, crit:getContentSize().height + labelAtlas:getContentSize().height/2))
		end
		--> print("drawFrameEvent : 处理伤害绘图3")
		local seq = nil
		if defState == "0" then
			-- seq = cc.Sequence:create(
			-- 	cc.ScaleTo:create(3.5/60.0 * __fight_recorder_action_time_speed, 2),
			-- 	cc.ScaleTo:create(3.5/60.0 * __fight_recorder_action_time_speed, 1.0),
			-- 	cc.DelayTime:create(30.0/60.0 * __fight_recorder_action_time_speed),
			-- 	cc.ScaleTo:create(5.0/60.0 * __fight_recorder_action_time_speed, 0.2),
			-- 	cc.CallFunc:create(removeFrameObjectFuncN)
			-- )
 			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then 
 				-- 0-15帧，上移10像素，透明度从0-255，缩放从30%-100%
				-- 15-40帧，保持不变
				-- 40-60帧，上移10像素，透明度从255-0，缩放从100%-70%
 				labelAtlas:setOpacity(0)
 				labelAtlas:setScale(0.3)
 				seq = cc.Sequence:create(
 					cc.Spawn:create({cc.MoveBy:create(0.25 * __fight_recorder_action_time_speed, cc.p(0, 10)), cc.FadeTo:create(0.25 * __fight_recorder_action_time_speed, 255), cc.ScaleTo:create(0.25 * __fight_recorder_action_time_speed, 1.0)}),
					cc.DelayTime:create(0.42 * __fight_recorder_action_time_speed),
					cc.Spawn:create({cc.MoveBy:create(0.33 * __fight_recorder_action_time_speed, cc.p(0, 10)), cc.FadeTo:create(0.33 * __fight_recorder_action_time_speed, 0), cc.ScaleTo:create(0.25 * __fight_recorder_action_time_speed, 0.7)}),
					cc.CallFunc:create(removeFrameObjectFuncN)
				)
 			else
				labelAtlas:setScale(0.8)
				seq = cc.Sequence:create(
					cc.ScaleTo:create(0.1 * __fight_recorder_action_time_speed, 2.0),
					cc.ScaleTo:create(0.1 * __fight_recorder_action_time_speed, 1.0),
					cc.DelayTime:create(0.6 * __fight_recorder_action_time_speed),
					cc.CallFunc:create(removeFrameObjectFuncN)
				)
				labelAtlas:runAction(cc.MoveBy:create(0.2 * __fight_recorder_action_time_speed, cc.p(0, 50)))
			end
		else
			seq = cc.Sequence:create(
				cc.DelayTime:create(30.0/60.0 * __fight_recorder_action_time_speed),
				cc.ScaleTo:create(5.0/60.0 * __fight_recorder_action_time_speed, 0.2),
				cc.CallFunc:create(removeFrameObjectFuncN)
			)
		end	
		labelAtlas:runAction(seq)
	
	end
	
	--> print("drawFrameEvent : 处理伤害绘图4")

	if defenderST == "0" then
		armature._hurtCount = armature._hurtCount + 1
		_def._hurtCount = _def._hurtCount + 1
	end
	
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		if armatureBase._role._camp_preference ~= 2 then
			if armatureBase._after_death ~= true and isMissed ~= true then
				checkAtferDeath(armatureBase)
				if armatureBase._after_death == true then
					if __lua_project_id == __lua_project_pacific_rim then
						armatureBase._weapon._nextAction = animation_dizziness
					else
						if armatureBase._weapon ~= nil then
							armatureBase._weapon:setVisible(false)
						end
					end
					armatureBase._nextAction = animation_dizziness

					local armatureDizziness = ccs.Armature:create("effice_canying")
					armatureDizziness:getAnimation():playWithIndex(0)
					armatureDizziness:setPosition(cc.p(armatureBase:getPosition()))
					armatureBase:getParent():addChild(armatureDizziness)
					armatureBase._armatureDizziness = armatureDizziness
				end
			end
		end
	end
	
	--> print("drawFrameEvent : 校验死亡")
	-- 进入死亡状态
	if defAState == "1" and armatureBase ~= nil and 
		armatureBase._isDeath ~= true then
		executeRoleDeath(armatureBase)
	end
end

local function excecuteFrameEvent(armatureBack, armatureBase, bone,evt,originFrameIndex,currentFrameIndex)
	local armature = armatureBack
	--> print("evt:", evt)
	-- if evt ~= nil and #evt > 0 then
		-- local datas = zstring.split(evt, "_")
		--> print(evt)
		-- if datas[1] == "start" then
			-- if armature._angle ~= nil then
				-- -- 创建飞行的光效
				-- createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
			-- end
			-- if datas[2] ~= "hurt" then
				--> print("无需掉血，跳出事件帧的处理")
				-- return
			-- end
		-- end
	-- elseif evt ~= "hurt" then
		-- return
	-- end

	armature._hurtCount = armature._hurtCount == nil and 0 or armature._hurtCount
	local _widget = armatureBase._posTile
	if _widget == nil then
		return
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		if armatureBack._defs ~= nil then
			for i, v in pairs(armatureBack._defs) do
				drawFrameEvent(armature, armatureBase, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
		else
			drawFrameEvent(armature, armatureBase, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
		end
	else
		if armatureBase._defs ~= nil then
			for i, v in pairs(armatureBase._defs) do
				drawFrameEvent(armature, armatureBase, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
		else
			drawFrameEvent(armature, armatureBase, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
		end
	end
end
	
onFrameEvent = function(bone,evt,originFrameIndex,currentFrameIndex)
	--local info = string.format("(%s) emit a frame event (%s) originFrame(%d)at frame index (%d).",bone:getName(),evt,originFrameIndex, currentFrameIndex)
	
	--if originFrameIndex ~= currentFrameIndex then
	--	return
	--end
	
	-- 绘制伤害数值
	local armature = bone:getArmature()--._base
	local armatureBase = armature._base
	

	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
	local _def = armature._def == nil and armatureBase._def or armature._def
	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
	--[[
	if _def._attackSection <= 0 then
		return
	end
	_def._attackSection = _def._attackSection - 1
	--]]
	
	excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
	
end

onFrameEvent1 = function(bone,evt,originFrameIndex,currentFrameIndex)
	onFrameEvent3(bone,evt,originFrameIndex,currentFrameIndex)
end

onFrameEvent2 = function(bone,evt,originFrameIndex,currentFrameIndex)
	onFrameEvent3(bone,evt,originFrameIndex,currentFrameIndex)
end

onFrameEvent3 = function(bone,evt,originFrameIndex,currentFrameIndex)
	--local info = string.format("(%s) emit a frame event (%s) originFrame(%d)at frame index (%d).",bone:getName(),evt,originFrameIndex, currentFrameIndex)
	-- 处理全屏伤害
	
	--if originFrameIndex ~= currentFrameIndex then
	--	return
	--end
	
	--> print("onFrameEvent3:", "处理伤害.")

	local armature = bone:getArmature()--._base
	local armatureBase = armature._base

	
	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
	local _def = armature._def == nil and armatureBase._def or armature._def
	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
	local attackSection = dms.atoi(_sie, skill_influence.attack_section)
	local executeDrawEffect = true
	-- 处理光效在对方阵营中心的伤害处理
	local erole = {}
	for w = 1, _skf.defenderCount do
		local _def = _skf._defenders[w]
		local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
		local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
		local restrainState = _def.restrainState 			-- = npos(list) 		--相克状态(0,无克制 1,有克制,2被克制)
		local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
		local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
		local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
		local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
		local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
		
		local rPad = getRolePad(defender, defenderPos)
		
		if rPad._armature ~= nil then
			rPad._armature._def = nil
			rPad._armature._defs = nil
			resetArmatureData()
		end
	end
	
	for w = 1, _skf.defenderCount do
		local _def = _skf._defenders[w]
		local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
		local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
		local restrainState = _def.restrainState 			-- = npos(list) 		--相克状态(0,无克制 1,有克制,2被克制)
		local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
		local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
		local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
		local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
		local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
		
		local rPad = getRolePad(defender, defenderPos)
		if rPad._armature ~= nil then
			if defenderST == "0" then
				rPad._armature._def = _def
				rPad._armature._sie = _sie
			end
			
			--擎天柱普攻多打一次BUG
			-- _def._attackSection = _skf._attackSection
			
			rPad._armature._def = _def
			rPad._armature._sie = _sie
			if rPad._armature._defs == nil then
				rPad._armature._defs = {}
			end
			
			rPad._armature._defs[table.getn(rPad._armature._defs) + 1] = _def
			
			rPad._armature._base = rPad._armature
			
			if _def.defenderST == "6" then
				-- 6为中毒
			elseif  _def.defenderST == "9" then
				-- 9为灼烧
			end
			-- 根据攻击的段数，重新赋伤害
			if tonumber(_def.stValue) > 0 and attackSection > 0 then
				-- _def.stValue = ""..string.format("%d", math.floor(tonumber(_def.stValue)/attackSection))
				_skf._defenders[w].subValue = ""..string.format("%d", math.floor(tonumber(_def.stValue)/attackSection))
			end
			
			if executeDrawEffect == true and defenderST == "0" then
				-- 启动技能中段
				--executeEffectSkilling(rPad._armature)
			end
			
			if _def.defAState == "1" then
				local dropCount = _def.dropCount 	-- = npos(list)		--(死亡时传)掉落卡片数量
			elseif _def.defAState == "2" then 
				rPad._armature._isReact = true
				--[[
				local fightBackFlag = _def.fightBackFlag 		-- = npos(list)	-- (反击时传)反击承受方的标识 
				local fightBackPos = _def.fightBackPos 			-- = npos(list)	-- 反击承受方的位置 
				local fightBackSkf = _def.fightBackSkf 			-- = npos(list)	-- 反击承受方的作用效果 
				local fightBackValue = _def.fightBackValue 		-- = npos(list)	-- 反击承受方的作用值 
				local fightBackRound = _def.fightBackRound 		-- = npos(list)	-- 反击承受方的持续回合
				local fightBackDefState = _def.fightBackDefState -- = npos(list)	-- 反击承受方的承受状态 
				local fightBackLiveState = _def.fightBackLiveState -- = npos(list)--反击承受方生存状态 (0:存活 1:死亡)
				if _def.fightBackDefState == "1" then
					local fightBackDropCardCount = _def.fightBackDropCardCount -- = npos(list)			-- (死亡时传)掉落卡片数量
				end
				if armatureBase._reactor == nil then
					armatureBase._reactor = rPad._armature
					armatureBase._defr = _def
				end
				--]]
			end
			--if executeDrawEffect == true and defenderST == "0" then
			--	excecuteFrameEvent(rPad._armature, rPad._armature, bone,evt,originFrameIndex,currentFrameIndex)
			--end
			erole[""..defender..">"..defenderPos] = rPad._armature
		end
	end
	for i, v in pairs(erole) do
		excecuteFrameEvent(v , v, bone,evt,originFrameIndex,currentFrameIndex)
	end
end
	
onFrameEvent4 = function(bone,evt,originFrameIndex,currentFrameIndex)
	--local info = string.format("(%s) emit a frame event (%s) at frame index (%d).",bone:getName(),evt,currentFrameIndex)
	
	--if originFrameIndex ~= currentFrameIndex then
	--	return
	--end
	
	-- 绘制伤害数值
	local armature = bone:getArmature()--._base
	local armatureBase = armature._base
	

	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
	local _def = armature._def == nil and armatureBase._def or armature._def
	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
	excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
end

	
onFrameEvent5 = function(bone,evt,originFrameIndex,currentFrameIndex)
	--local info = string.format("(%s) emit a frame event (%s) at frame index (%d).",bone:getName(),evt,currentFrameIndex)
	--if originFrameIndex ~= currentFrameIndex then
	--	return
	--end
	
	-- 绘制伤害数值
	local armature = bone:getArmature()--._base
	local armatureBase = armature._base
	
	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
	local _def = armature._def == nil and armatureBase._def or armature._def
	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
	excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
end

onFrameEvent6 = function(bone,evt,originFrameIndex,currentFrameIndex)
	--local info = string.format("(%s) emit a frame event (%s) at frame index (%d).",bone:getName(),evt,currentFrameIndex)
	--if originFrameIndex ~= currentFrameIndex then
	--	return
	--end
	
	-- 绘制伤害数值
	local armature = bone:getArmature()--._base
	local armatureBase = armature._base
	

	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
	local _def = armature._def == nil and armatureBase._def or armature._def
	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
	excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
end

-- END~技能技能光效帧事件监听
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 技能光效处理

local function excuteSPSkillEffectOver(armatureBack)
	deleteEffectFile(armatureBack)
	executeHeroMoveToTarget()
end

local function initFitData()
	__fit_params = {}
	__fit_roles = {}

	-- table.insert(roles, current_attacker)
	if attData.fitHeros ~= nil and #attData.fitHeros > 0 then
		for i, v in pairs(attData.fitHeros) do
			local attacker 				= v.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
			local attackerPos 			= v.attackerPos 					-- = npos(list)		--出手方位置(1-6)
			local role = getRole(attacker, attackerPos)
			role._armature._sed_action = nil -- curr_fit_skillElementData
			role._armature._sie_action = nil -- curr_fit_skillInfluenceElementData
		end
		for i, v in pairs(attData.fitHeros) do
			--> print("有合体技能")
			local attacker 				= v.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
			local attackerPos 			= v.attackerPos 					-- = npos(list)		--出手方位置(1-6)
			local attackMovePos			= tonumber(v.attackMovePos)					-- = npos(list)		--移动到的位置(0-8)
			local skillMouldId			= tonumber(v.skillMouldId)				-- = npos(list)	--技能模板id
			local skillInfluenceCount 	= tonumber(v.skillInfluenceCount) 			-- = tonumber(npos(list))	-- 技能效用数量
			-- attData.skillInfluences = {}
			
			if __lua_project_id == __lua_project_warship_girl_b
				or __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_koone
				then
				if attacker == "0" then
					state_machine.excute("fight_hero_info_ui_show_by_pos", 0, {_roleType = 2, _roleIndex = attackerPos, _visible = false})
				else
					state_machine.excute("fight_hero_info_ui_show_by_pos", 0, {_roleType = 1, _roleIndex = attackerPos, _visible = false})
				end
			end
			

			local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
			
			-- skill data
			local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
			local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
			local skillReleasePosition = dms.atoi(skillElementData, skill_mould.skill_release_position)
			local skillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.releas_skill), "|")
			skillInfluenceIds = zstring.split(skillInfluenceIds[i], ",")
			local skillInfluenceId = zstring.tonumber(skillInfluenceIds[1])
			local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)

			local role = getRole(attacker, attackerPos)

			if skillElementData ~= nil and skillInfluenceElementData ~= nil 
				and role._armature._sed_action == nil and role._armature._sie_action == nil then
				role._armature._sed_action = skillElementData -- curr_fit_skillElementData
				role._armature._sie_action = skillInfluenceElementData -- curr_fit_skillInfluenceElementData
				role._armature._attackMovePos = curr_fit_attackMovePos
			end

			table.insert(__fit_roles, role)
		end
	end

	if #__fit_roles > 1 then
		local sync = dms.atoi(curr_fit_skillElementData, skill_mould.seriatim)
		table.insert(__fit_params, curr_fit_skillElementData)
		table.insert(__fit_params, curr_fit_skillInfluenceElementData)
		table.insert(__fit_params, curr_fit_attackMovePos)--attackMovePos
		table.insert(__fit_params, (curr_fit_attacker == "0" and __attackers or __defenders))
		table.insert(__fit_params, (curr_fit_attacker == "1" and __attackers or __defenders))
		table.insert(__fit_params, __attackers)
		table.insert(__fit_params, __defenders)
		table.insert(__fit_params, "attack_logic_start1")
		table.insert(__fit_params, sync == 0 and true or false)--sync 
		table.insert(__fit_params, 1)--param_skill_influence_index

		if skillProperty == 0 then
			-- 近身攻击上的移动帧组
			mtime = moveToTargetTime1
		else
			-- 技能近身攻击上的移动帧组
			mtime = moveToTargetTime2
		end

		table.insert(__fit_params, mtime)

		table.insert(__fit_params, attackChangeActionCallback)
		table.insert(__fit_params, changeActtackToAttackBegan)
		table.insert(__fit_params, 0)
		table.insert(__fit_params, executeAttackerBuff)
		table.insert(__fit_params, 0)

		local skillInfluenceFormation = zstring.split(dms.atos(curr_fit_skillElementData, skill_mould.releas_skill), "|")
		for i, v in pairs(__fit_roles) do
			resetArmatureData(v._armature)
			v._armature._fit = true
			v._armature._nextAction = _enum_animation_frame_index.animation_combine_skill_effect
						
			-- local armature = v._armature
			-- local camp = zstring.tonumber(armature._camp) + 1
			-- local skillInfluenceIds = zstring.split(skillInfluenceFormation[i], ",")
			-- local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceIds[1])
			-- local indexs = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.before_action), ",")
			-- local actionIndex = zstring.tonumber(indexs[camp])
			-- v._armature._nextAction = actionIndex
			

			v._armature._invoke = attackChangeActionCallback
			iii = ii +1
			-- changeActtackToAttackMoving(v._armature)
		end

		app.load("client.battle.logics.move_logic")
		-- app.load("client.battle.logics.attack_logic")
		-- state_machine.excute("move_logic_begin_move_all_role", 0, {__fit_roles, __fit_params})
		return true
	end
end

local function excuteSPSkillEffectFitOver(armatureBack)
	deleteEffectFile(armatureBack)

	__fit_params[_enum_params_index.param_attack_count] = 0
	state_machine.excute("move_logic_begin_move_all_role", 0, {__fit_roles, __fit_params})
end

local function excuteSPSkillEffectFit()
	local _dic_heads = {
		{"fit_1_1",	"fit_1_2",	"fit_1_3", 	"fit_1_4",	"fit_1_5"},	-- 头像A
		{"fit_2_1",	"fit_2_2",	"fit_2_3", 	"fit_2_4",	"fit_2_5"},	-- 头像B
		{"fit_3_1",	"fit_3_2",	"fit_3_3", 	"fit_3_4",	"fit_3_5"},	-- 头像C
		{"fit_4_1",	"fit_4_2",	"fit_4_3", 	"fit_4_4",	"fit_4_5"},	-- 头像D
	}
	local _dic_names = {	-- 技能名称
		"name_1",	"name_2",	"name_3"
	}

	local nCount = #__fit_roles
	if nCount == 2 or true then
		__fit_params[_enum_params_index.param_attack_count] = 0
		local size = cc.size(app.designSize.width, app.designSize.height)
		
		local armature_name = string.format("hero_head_effect_%s", nCount)
		
		if attData.restrainState == "1" then
			armature_name = string.format("hero_head_effect_%s_1", nCount)
	    	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_" .. nCount .. "_1.ExportJson")
	    else
		    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_" .. nCount .. ".ExportJson")
		end
		
		
		local armature = ccs.Armature:create(armature_name)
		for i, v in pairs(__fit_roles) do
			local role = v
			local posTile = v
			local armatureBack = v._armature

			local shipEffect = -1
			local effectName = -1
			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then
				shipEffect = armatureBack._brole._head
			else
				if armatureBack._erole._type == "0" then
					effectName = dms.string(dms["ship_mould"], armatureBack._brole._mouldId, ship_mould.screen_attack_effect)
				
					if zstring.tonumber(armatureBack._brole._head) < 10000 then
						shipEffect = effectName
					else
						shipEffect = armatureBack._brole._head
					end
				else
					effectName = dms.string(dms["environment_ship"], armatureBack._brole._mouldId, environment_ship.screen_attack_effect)
					shipEffect = effectName
				end
			end
			if shipEffect ~= nil and tonumber(shipEffect) > -1 then
				local skillName =  dms.string(dms["skill_mould"], armatureBack._currentSkillMouldId, skill_mould.skill_name)
				-- local size = posTile:getContentSize()
				for f, t in pairs(_dic_heads[i]) do
					local imagePath = string.format("images/face/big_head/big_head_%s.png", shipEffect)
					local head = ccs.Skin:create(imagePath)
					--> print("t:::", t, imagePath)
					armature:getBone(t):addDisplay(head, 0)
				end
				
				if mPosTile == v then
					-- draw skill name
					for s, x in pairs(_dic_names) do
						local  imagePath = ""
						if tonumber(armatureBack._brole._fit_skill_id) > 0 then
							imagePath = string.format("images/face/rage_head/rage_name_%s.png", shipEffect + 10000) 
							if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b )
								and ___is_open_fashion == true
								then
	        				   	imagePath = string.format("images/face/rage_head/rage_name_%s.png", armatureBack._brole._fit_skill_id) 
        				  	end
        				  	if __lua_project_id == __lua_project_digimon_adventure 
        				  		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        				  		or __lua_project_id == __lua_project_naruto 
        				  		or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge 
								or __lua_project_id == __lua_project_yugioh 
								then 
        				  		local effectIndex = nil
        				  		local fitId = zstring.tonumber(armatureBack._brole._fit_skill_id)
        				  		if fitId > 10000 then
        				  			fitId = fitId - 10000
        				  		end
        				  		effectIndex = dms.int(dms["skill_mould"], fitId, skill_mould.buff_affect)
        				  		if nil ~= effectIndex and effectIndex > 0 then 
        				  			imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectIndex) 
        				  		end
        				  		-- TipDlg.drawTextDailog(fitId .. "-" .. effectIndex)
        				  	end
							-- imagePath = string.format("images/face/rage_head/rage_name_%s.png", armatureBack._brole._fit_skill_id + 10000) 
						else
							imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectName + 10000) 
							
						end
						local skill_name = ccs.Skin:create(imagePath)
						armature:getBone(x):addDisplay(skill_name, 0)
					end
				end
			end
		end
		--> print("进入待机1")
		armature:getAnimation():playWithIndex(animation_standby)
		armature:setPosition(cc.p(size.width / 2, size.height / 2 - app.baseOffsetY * app.scaleFactor / 2))
		armature:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
		armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
		armature._invoke = excuteSPSkillEffectFitOver
		-- fwin._background._layer:addChild(armature)
		fwin._ui._layer:addChild(armature)
	end

	playEffectMusic(9994)
end

local function excuteSPSkillEffect(posTile, armatureBack)
	if attData.fitHeros ~= nil and #attData.fitHeros > 0 then
		initFitData()
		return
	end

	local shipEffect = -1
	local effectName = -1
	if armatureBack._brole._type == "0" then
		effectName = dms.string(dms["ship_mould"], armatureBack._brole._mouldId, ship_mould.screen_attack_effect)
		if zstring.tonumber(armatureBack._brole._head) < 10000 then
			shipEffect = effectName
		else
			shipEffect = armatureBack._brole._head
		end
	else
		effectName = dms.string(dms["environment_ship"], armatureBack._brole._mouldId, environment_ship.screen_attack_effect)
		shipEffect = effectName
	end
	--> print("怒气特效的绘制", shipEffect)
	if shipEffect ~= nil and tonumber(shipEffect) > -1 then
		if __lua_project_id ~= __lua_project_l_naruto then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect.ExportJson")
		end
		local skillName =  dms.string(dms["skill_mould"], armatureBack._currentSkillMouldId, skill_mould.skill_name)
		local size = posTile:getContentSize()
		
		local armature = ccs.Armature:create("hero_head_effect")
		-- playEffect(formatMusicFile("effect", 9994))
		--> print("进入待机2")
		armature:getAnimation():playWithIndex(animation_standby)
		armature:setPosition(cc.p(size.width/2, size.height/2))
		armature:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
		armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
		armature._invoke = excuteSPSkillEffectOver
		posTile:addChild(armature)
		local  imagePath = ""
		if tonumber(armatureBack._brole._power_skill_id) > 0 then
			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				then 
				local effectIndex = dms.int(dms["skill_mould"], armatureBack._brole._power_skill_id, skill_mould.buff_affect)
                if nil ~= effectIndex and effectIndex > 0 then
					imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectIndex)
				else
					executeHeroMoveToTarget()
					return
				end
			else
				imagePath = string.format("images/face/rage_head/rage_name_%s.png", armatureBack._brole._power_skill_id) 
			end
		else
			imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectName) 
		end
		local skill_name = ccs.Skin:create(imagePath)
		armature:getBone("skill_name"):addDisplay(skill_name, 0)
	else
		executeHeroMoveToTarget()
	end
end

-- 加载光效资源文件
-- effect_6006.ExportJson
loadEffectFile = function(fileIndex)
	local fileName = string.format("effect/effice_%s.ExportJson", "" .. fileIndex)
	-- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
	--> print(fileName)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
	--> print("..........................")
	-- cacher.addArmatureFileInfo(fileName)
	local armatureName = string.format("effice_%s", "" .. fileIndex)
	return armatureName, fileName
end

deleteEffectFile = function(armatureBack)
	-- 删除光效
	armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns
	if armatureBack._LastsCountTurns <= 0 then
		local fileName = armatureBack._fileName
		if m_tOperateSystem == 5 then
			if fileName ~= nil then
				CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
			end
		end
			if armatureBack.getParent ~= nil then
				if armatureBack:getParent() ~= nil then
					if armatureBack.removeFromParent ~= nil then
						armatureBack:removeFromParent(true)
					end
				end
			end
		if m_tOperateSystem == 5 then
			-- draw.cleanMemory()
			-- draw.cleanCacheMemory()
			-- CCArmatureDataManager:purge()
			
			CCSpriteFrameCache:purgeSharedSpriteFrameCache()
			CCTextureCache:sharedTextureCache():removeUnusedTextures()
		end
	end
end

createEffect = function(armaturePad, fileIndex, _camp, addToTile, zorder, offsetX, offsetY)
	-- 创建光效
	local armatureName, fileName = loadEffectFile(fileIndex)
	local posTile = armaturePad
	local armature = ccs.Armature:create(armatureName)
	armature._fileName = fileName
	local tempX, tempY  = posTile:getPosition()
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2 + offsetX, tempY + posTile:getContentSize().height/2 + offsetY))

	local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
	local _tcamp = zstring.tonumber("".._camp)
	local _armatureIndex = frameListCount * _tcamp
	-- print("createEffect : frameListCount->", frameListCount, _camp, _armatureIndex)
	armature:getAnimation():playWithIndex(_armatureIndex)
	armature:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
	if addToTile == true then
		armature:setPosition(cc.p(posTile:getContentSize().width/2 + offsetX, posTile:getContentSize().height/2 + offsetY))
		posTile:addChild(armature, zorder or kZOrderInMap_Effect)
	else	
		zorder = zorder or 0
		posTile:getParent():addChild(armature, kZOrderInMap_Effect + zorder)
		armature:setGlobalZOrder(kZOrderInMap_Effect + zorder)
	end
	armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
	
	local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
	if nil ~= duration then
		armature._duration = duration / 60.0
		-- iii = iii + 1

		if __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim
			then
			local info = dms.string(dms["duration"], fileIndex, 3)
			if nil ~= info then
				if __lua_project_id == __lua_project_pacific_rim then
					local infos = zstring.split(info, "|")
					if #infos > 0 then
						armature._dposs = {}
						for i, v in pairs(infos) do
							local t = zstring.split(v, ",")
							armature._dposs["t" .. i] = cc.p(t[1], t[2])
						end
						armature._height = armature._dposs["t" ..1].y
						armature._width = armature._dposs["t" ..1].x
					end
				else
					local infos = zstring.split(info, "|")
					armature._height = tonumber(infos[1])
					if nil ~= infos[2] then
						local oxs = zstring.split(infos[2], ",")
						armature._width = tonumber(oxs[math.random(1, #oxs)])
					end
				end
			end
		end
	end
	return armature
end

createEffectExt = function(armaturePad, fileIndex, _camp, addToTile, index, totalCount)
	-- 创建光效
	local armatureName, fileName = loadEffectFile(fileIndex)
	local posTile = armaturePad
	local armature = ccs.Armature:create(armatureName)
	armature._fileName = fileName
	local tempX, tempY  = posTile:getPosition()
	armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2, tempY + posTile:getContentSize().height/2))
	local armatureIndex = totalCount * ((_camp + 1)%2) + index
	--> print("createEffectExt->:", armatureIndex, _camp, index)
	armature:getAnimation():playWithIndex(armatureIndex)
	armature:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
	if addToTile == true then
		armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
		posTile:addChild(armature, kZOrderInMap_Effect)
	else	
		posTile:getParent():addChild(armature, kZOrderInMap_Effect)
		armature:setGlobalZOrder(kZOrderInMap_Effect)
	end
	armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
	return armature
end

createEffectCoverSkill = function(armaturePad, fileIndex, _camp, addToTile)
	-- 创建光效
	local armatureName, fileName = loadEffectFile(fileIndex)
	local posTile = armaturePad
	local armature = ccs.Armature:create(armatureName)
	armature._fileName = fileName
	local tempX, tempY  = posTile:getPosition()
	armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2, tempY + posTile:getContentSize().height/2))

	local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
	local _tcamp = zstring.tonumber("".._camp)
	local _armatureIndex = frameListCount * _tcamp
	--> print("createEffectCoverSkill : frameListCount->", frameListCount, _camp, _armatureIndex)
	armature:getAnimation():playWithIndex(_armatureIndex)
	armature:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
	if addToTile == true then
		armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
		posTile:addChild(armature, kZOrderInMap_sp_effect)
	else	
		posTile:getParent():addChild(armature, kZOrderInMap_sp_effect)
		armature:setGlobalZOrder(kZOrderInMap_sp_effect)
	end
	armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
	
	local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
	armature._duration = duration / 60.0
	return armature
end

-- 技能光效前段
executeEffectSkillBegan = function(armatureBack)
	local armature = armatureBack
	local skillInfluenceElementData = armature._sie
	-- local forepart_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.forepart_lighting_effect_id)
	
	local camp = zstring.tonumber(armature._camp) + 1
	local effectIds = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.forepart_lighting_effect_id), ",")
	local effectId = zstring.tonumber(indexs[camp])
	--> print("技能光效前段:", effectId)
	if forepart_lighting_effect_id >= 0 then
		local armatureEffect = createEffect(armature._posTile, forepart_lighting_effect_id, armature._posTile._camp)
		armatureEffect._invoke = deleteEffectFile
		armatureEffect._base = armature
	else
		--executeAttacking()
	end
	local forepart_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.forepart_lighting_sound_effect_id)

	if forepart_lighting_sound_effect_id >= 0 then
		playEffectMusic(forepart_lighting_sound_effect_id)
	end
end

-- 技能光效中段
local function executeEffectSkillingOver(armatureBack)
	if BattleSceneClass._isSkepBattle == true then
		--> print("executeEffectSkillingOver : 战斗跳过")
		deleteEffectFile(armatureBack)
		return
	end
	-- 准备清除技能光中段资源
	local baseArmature = armatureBack._base
	deleteEffectFile(armatureBack)
	if __fit_roles ~= nil and #__fit_roles > 0 then
		local currentArmature = __fit_roles[1]._armature
		--> print("合体技能光效中段结束", currentArmature._attackTargetCount)
		if zstring.tonumber(currentArmature._attackTargetCount) > 0 then
			currentArmature._attackTargetCount = zstring.tonumber(currentArmature._attackTargetCount) - 1
		end
		if zstring.tonumber(currentArmature._attackTargetCount) <= 0 then
			executeAttacking()
		end
		-- for i, v in pairs(__fit_roles) do
		-- 	v._armature._attackTargetCount = v._armature._attackTargetCount - 1
		-- end
	else
		--> print("技能光效中段结束")
		executeHeroMoveToOriginTarget()
	end
		
	if BattleSceneClass._hasWidgetBg == true or BattleSceneClass._effectBg ~= nil then
		BattleSceneClass._effectBg:removeFromParent(true)
		BattleSceneClass._effectBg = nil
		BattleSceneClass._hasWidgetBg = nil
	end		
end

	
local function onMoveFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
	-- local info = string.format("(%s) emit a frame event (%s) originFrame(%d)at frame index (%d).", bone:getName(),evt,originFrameIndex, currentFrameIndex)
	--> print("onMoveFrameEvent:(info)->", info)
	local pos = string.find(evt, "start_move_")
    if pos ~= nil then
    	local stime = string.sub(evt, pos+#"start_move_", #evt)
    	--> print("stime:", stime)
    	if stime ~= nil and #stime > 0 then
			local armature = bone:getArmature()
			--> print(tonumber(stime) / 60)
			armature:runAction(cc.MoveTo:create(tonumber(stime) / 60 * __fight_recorder_action_time_speed, armature._move_position))
			-- armature:runAction(cc.MoveTo:create(tonumber(stime) * 60 / 1000, cc.p(100, 500)))
    	end
    end
end

local function createMovePathEffect(armatureBack, isBaseArmature)
	local armature = armatureBack
	local backPad = armature._posTile

	--> print("backPad, mPosTile", backPad, mPosTile, backPad._camp, mPosTile._camp)


	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)

	local armatureEffect = createEffectExt(backPad, posterior_lighting_effect_id, backPad._camp)
	--> print("getMovementCount:", armatureEffect:getAnimation():getMovementCount(), armatureEffect:getAnimation():getAnimationData():getMovementCount())
	armatureEffect._base = armature
	armatureEffect._sie = armature._sie
	armatureEffect._def = armature._def
	if isBaseArmature == true then
		if armature._sie == nil then
			armatureEffect._invoke = deleteEffectFile
		else
			armatureEffect._invoke = deleteEffectFile --? executeEffectSkillingOver
			armatureEffect:getAnimation():setFrameEventCallFunc(onMoveFrameEvent)
		end
	else
		armatureEffect._invoke = deleteEffectFile
		armatureEffect:getAnimation():setFrameEventCallFunc(onMoveFrameEvent)
	end
	
	--[[
		0基于施放者与承受者的路径（根据目标数量绘制光效）
		1基于施放者位置（只绘制一个光效）
		2基于承受者位置（根据目标数量绘制光效）
		3基于对方阵营中心（只绘制一个光效）
		4基于攻击范围无视存活数量（根据目标数量绘制光效）
		5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
		6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
	--]]
	local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
	-- 处理角度和路径
	local start_pos = nil
	local end_pos = nil
	local langle = 0
	if armatureBack._isByReact == true then
		start_pos = cc.p(armatureBack._reactor._posTile:getPosition())
		end_pos = cc.p(mPosTile:getPosition())
		if armatureBack._reactor._posTile._camp == "1" then
			langle = -180
		end
	else
		start_pos = cc.p(mPosTile:getPosition())
		end_pos = cc.p(armature._posTile:getPosition())
		if mPosTile._camp == "1" then
			langle = -180
		end
	end
	local angle = ccaf(start_pos, end_pos)+langle
	if angle >= 180 then
		angle = 180 - angle
	end
	if angle <= -180 then
		angle = 180 - (180 - angle)
	end
	if angle == langle and langle < 0 then
		angle = 0
	end
	local pSize = mPosTile:getContentSize()
	start_pos.x = start_pos.x + pSize.width/2
	start_pos.y = start_pos.y + pSize.height/2
	end_pos.x = end_pos.x + pSize.width/2
	end_pos.y = end_pos.y + pSize.height/2
	
	armatureEffect:setRotation(angle)
	armatureEffect:setPosition(start_pos)
	-- armatureEffect._move_action = cc.MoveTo:create(3, end_pos) --cc.MoveTo:create(armatureEffect._duration, end_pos)
	-- armatureEffect._move_action:retain()
	armatureEffect._move_position = end_pos
end

local function createFlyingEffect(index, totalCount, bone,evt,originFrameIndex,currentFrameIndex)
	local armature = bone:getArmature()
	local backPad = armature._posTile

	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)

	local armatureEffect = createEffectExt(backPad, posterior_lighting_effect_id, backPad._camp, false, index, totalCount)
	armatureEffect._base = armature
	armatureEffect._sie = armature._sie
	armatureEffect._def = armature._def
	armatureEffect._invoke = deleteEffectFile
	armatureEffect:getAnimation():setFrameEventCallFunc(onMoveFrameEvent)

	local angle = armature._angle
	local start_pos = armature._start_position
	local _end_position = armature._end_position

	--> print("_end_position:", index, totalCount, armature._angle, start_pos.x, start_pos.y, _end_position.x, _end_position.y)

	armatureEffect:setRotation(angle)
	armatureEffect:setPosition(start_pos)
	-- armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))

	armatureEffect._move_position = _end_position
end

createFlyingEffects = function(bone,evt,originFrameIndex,currentFrameIndex)
	local armature = bone:getArmature()
	-- local frameListCount = math.ceil(armature:getAnimation():getAnimationData():getMovementCount() / 2)
	local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
	--> print("创建飞行光效", frameListCount)
	for i=2,frameListCount do
		--> print("创建飞行光效kkk", i-1)
		createFlyingEffect(i - 1, frameListCount, bone,evt,originFrameIndex,currentFrameIndex)
	end
end

local function executeEffectSkillingExt(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile

	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local count = 4
		for i=1,10 do
			createMovePathEffect(armatureBack)
		end
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

local _executeEffectSkilling = nil

_executeEffectSkilling = function(armatureBack, targetPostTile)
	local armature = armatureBack
	local backPad = armature._posTile
	local currentPosTile = mPosTile
	if targetPostTile ~= nil then
		currentPosTile = targetPostTile
	end

	-- 技能光效中段
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local interval = 0
		local actions = {}
		currentPosTile._armature._call_next_role = false
		if currentPosTile._armature._role._camp_preference == 1 or true then
			interval = 0.15
		else
			interval = 0.3
		end

		if nil ~= currentPosTile._armature._child_list then
			battle_execute._addChildSendBulletAction(armature, backPad, currentPosTile, executeAfterInfluenceCount, interval)
		end

		local angle = 0
		-- if currentPosTile._armature._camp == "1" then
		-- 	angle = -1 * angle - 180
		-- end
		--> print("create 1 bullet:", currentPosTile._armature:getRotation(), angle, currentPosTile._armature._role._camp_preference)
		
		local weapon = currentPosTile._armature._weapon
		if nil == weapon then
			weapon = currentPosTile._armature
		end
		-- if weapon.__attack_count > 0 then
		-- 	table.insert(actions, cc.DelayTime:create(0.5 * weapon.__attack_count))
		-- end
		local rotateAction = nil
		local needRotate = true

		if __lua_project_id == __lua_project_pacific_rim then
			if currentPosTile._armature._role._camp_preference == 4 then
				if nil == weapon._targets or #weapon._targets == 0 then
					local _icamp = tonumber(backPad._camp)
					local node2 = getRole(_icamp, 2)
					local node5 = getRole(_icamp, 5)

					local aposx2, aposy2 = node2:getPosition()
					local aposx5, aposy5 = node5:getPosition()

					currentPosTile.atomic_bomb_pos = cc.p(aposx2 + (aposx5 - aposx2) / 2, aposy2 + (aposy5 - aposy2) / 2)
				end
			end
			if currentPosTile._armature._role._camp_preference == 1 
				or currentPosTile._armature._role._camp_preference == 3
				or currentPosTile._armature._role._camp_preference == 4
				then
				if currentPosTile._armature._role._camp_preference == 3 then
					local slot = currentPosTile._bullet_slots or {}
					currentPosTile._bullet_slots = slot
					local aposx, aposy = backPad:getParent():getPosition()
					slot["t" .. (# slot + 1)] = cc.p(aposx, aposy)

				end
				if nil == weapon._targets or #weapon._targets == 0 then -- 坦克类型的兵种，只触发一次的攻击动作
					table.insert(actions, cc.CallFunc:create(function ( sender )
						sender.__attack_count = sender.__attack_count - 1
						local target = table.remove(sender._targets, 1)
						if target.__check_over == true then
							target.__check_over = false
							sender.__need_over = true
						end
						battle_execute._executeEffectSkillingWithBulletSend(target.__armature, 
							target.__backPad, 
							target.__currentPosTile, 
							target.__angle, 
							target.__executeAfterInfluenceCount,
							sender)
					end))

					if currentPosTile._armature._role._camp_preference == 3 then

					elseif currentPosTile._armature._role._camp_preference == 4 then

					else
						-- print("----->>>", backPad._camp)
						local tp1 = nil
						local tp2 = nil
						local tp3 = nil
						local slot = {}
						local slotRole = {}
						local isHaveRole = false

						local node = getRole(tonumber(backPad._camp), 1)
						if nil ~= node and nil ~= node._armature 
							and node._armature._isDeath ~= true 
							-- and node._armature._after_death ~= true
							then
							isHaveRole = true
							--> print("step1")
						else
							node = getRole(tonumber(backPad._camp), 4)
							--> print("step4")
						end

						--> print("t1==>>::", node)
						local aposx, aposy = node:getPosition()

						slot["tl1"] = cc.p(aposx - 42 - 12, aposy + 12 + 19)
						slot["t1"] = cc.p(aposx - 42, aposy + 12)
						slot["tr1"] = cc.p(aposx - 42 + 12, aposy + 12 - 19)

						slotRole["tl1"] = isHaveRole
						slotRole["t1"] = isHaveRole
						slotRole["tr1"] = isHaveRole

						slot["tl2"] = cc.p(aposx - 12, aposy + 19)
						slot["t2"] = cc.p(aposx, aposy)
						slot["tr2"] = cc.p(aposx + 12, aposy - 19)

						slotRole["tl2"] = isHaveRole
						slotRole["t2"] = isHaveRole
						slotRole["tr2"] = isHaveRole

						slot["tl3"] = cc.p(aposx + 42 - 12, aposy - 12 + 19)
						slot["t3"] = cc.p(aposx + 42, aposy - 12)
						slot["tr3"] = cc.p(aposx + 42 + 12, aposy - 12 - 19)

						slotRole["tl3"] = isHaveRole
						slotRole["t3"] = isHaveRole
						slotRole["tr3"] = isHaveRole

						isHaveRole = false
						node = getRole(tonumber(backPad._camp), 2)
						if nil ~= node and nil ~= node._armature 
							and node._armature._isDeath ~= true 
							-- and node._armature._after_death ~= true
							then
							isHaveRole = true
							--> print("step2")
						else
							node = getRole(tonumber(backPad._camp), 5)
							--> print("step5")
						end

						--> print("t2==>>::", node)
						aposx, aposy = node:getPosition()
						slot["tl4"] = cc.p(aposx - 42 - 12, aposy + 12 + 19)
						slot["t4"] = cc.p(aposx - 42, aposy + 12)
						slot["tr4"] = cc.p(aposx - 42 + 12, aposy + 12 - 19)
						slotRole["tl4"] = isHaveRole
						slotRole["t4"] = isHaveRole
						slotRole["tr4"] = isHaveRole

						slot["tl5"] = cc.p(aposx - 12, aposy + 19)
						slot["t5"] = cc.p(aposx, aposy)
						slot["tr5"] = cc.p(aposx + 12, aposy - 19)
						slotRole["tl5"] = isHaveRole
						slotRole["t5"] = isHaveRole
						slotRole["tr5"] = isHaveRole

						slot["tl6"] = cc.p(aposx + 42 - 12, aposy - 12 + 19)
						slot["t6"] = cc.p(aposx + 42, aposy - 12)
						slot["tr6"] = cc.p(aposx + 42 + 12, aposy - 12 - 19)
						slotRole["tl6"] = isHaveRole
						slotRole["t6"] = isHaveRole
						slotRole["tr6"] = isHaveRole

						isHaveRole = false
						node = getRole(tonumber(backPad._camp), 3)
						if nil ~= node and nil ~= node._armature 
							and node._armature._isDeath ~= true 
							-- and node._armature._after_death ~= true
							then
							isHaveRole = true
							--> print("step3")
						else
							node = getRole(tonumber(backPad._camp), 6)
							--> print("step6")
						end

						--> print("t3==>>::", node)
						aposx, aposy = node:getPosition()
						slot["tl7"] = cc.p(aposx - 42 - 12, aposy + 12 + 19)
						slot["t7"] = cc.p(aposx - 42, aposy + 12)
						slot["tr7"] = cc.p(aposx - 42 + 12, aposy + 12 - 19)
						slotRole["tl7"] = isHaveRole
						slotRole["t7"] = isHaveRole
						slotRole["tr7"] = isHaveRole

						slot["tl8"] = cc.p(aposx - 12, aposy + 19)
						slot["t8"] = cc.p(aposx, aposy)
						slot["tr8"] = cc.p(aposx + 12, aposy - 19)
						slotRole["tl8"] = isHaveRole
						slotRole["t8"] = isHaveRole
						slotRole["tr8"] = isHaveRole

						slot["tl9"] = cc.p(aposx + 42 - 12, aposy - 12 + 19)
						slot["t9"] = cc.p(aposx + 42, aposy - 12)
						slot["tr9"] = cc.p(aposx + 42 + 12, aposy - 12 - 19)
						slotRole["tl9"] = isHaveRole
						slotRole["t9"] = isHaveRole
						slotRole["tr9"] = isHaveRole

						currentPosTile._bullet_slots = slot
						currentPosTile._bullet_role_slots = slotRole
					end
				end
			else
				table.insert(actions, cc.CallFunc:create(function ( sender )
					sender.__attack_count = sender.__attack_count - 1
					local target = table.remove(sender._targets, 1)
					if target.__check_over == true then
						target.__check_over = false
						sender.__need_over = true
					end
					battle_execute._executeEffectSkillingWithBulletSend(target.__armature, 
						target.__backPad, 
						target.__currentPosTile, 
						target.__angle, 
						target.__executeAfterInfluenceCount,
						sender)
				end))
			end
		else
			if currentPosTile._armature._role._camp_preference == 4 then
				if weapon.__attack_count > 0 then
					needRotate = false
					angle = currentPosTile._armature.___angle
				else
					local current_pos = cc.p(currentPosTile:getPosition())
					local target_pos = cc.p(armature._posTile:getPosition())
					target_pos.x = 240
					angle = CC_POSITIONS_TO_DEGREES(current_pos, target_pos)
					currentPosTile._armature.___angle = angle
				end
			elseif nil ~= currentPosTile._armature._target_count then
				if weapon.__attack_count == 0 or weapon.__attack_count == currentPosTile._armature._target_count then
					angle = CC_POSITIONS_TO_DEGREES(cc.p(currentPosTile:getPosition()), cc.p(armature._posTile:getPosition()))
					currentPosTile._armature.___angle = angle
				else
					needRotate = false
					angle = currentPosTile._armature.___angle
				end
			else
				angle = CC_POSITIONS_TO_DEGREES(cc.p(currentPosTile:getPosition()), cc.p(armature._posTile:getPosition()))
			end
			if true == needRotate then
				if currentPosTile._armature._camp == "1" then
					if nil ~= currentPosTile._armature._child_list then
						rotateAction = cc.RotateTo:create(interval, 180 + 1 * angle)
					else
						rotateAction = cc.RotateTo:create(interval, -1 * angle - 180)
					end
				else
					rotateAction = cc.RotateTo:create(interval, angle);
				end
				table.insert(actions, rotateAction)
			end

			table.insert(actions, cc.CallFunc:create(function ( sender )
				sender.__attack_count = sender.__attack_count - 1
				local target = table.remove(sender._targets, 1)
				if target.__check_over == true then
					target.__check_over = false
					sender.__need_over = true
				end
				battle_execute._executeEffectSkillingWithBulletSend(target.__armature, 
					target.__backPad, 
					target.__currentPosTile, 
					target.__angle, 
					target.__executeAfterInfluenceCount,
					sender)
			end))
		end

		weapon._targets = weapon._targets or {}
		local target = {
				__armature = armature,
				__backPad = backPad,
				__currentPosTile = currentPosTile,
				__angle = angle,
				__executeAfterInfluenceCount = executeAfterInfluenceCount
			}
		target.__action = cc.Sequence:create(actions)
		if nil ~= target.__action then
			target.__action:retain()
		end

		if #weapon._targets == 0 then
			target.__check_over = true
		end
		table.insert(weapon._targets, target)
		weapon.__attack_count = weapon.__attack_count + 1

		if weapon.__attack_count == 1 then
			if __lua_project_id == __lua_project_pacific_rim then
				if currentPosTile._armature._role._camp_preference == 2 then
					currentPosTile._attack_weapon = weapon
					currentPosTile._attack_target = target
					currentPosTile._armature._nextAction = animation_moving
                    currentPosTile._armature:getAnimation():playWithIndex(animation_moving)
                    currentPosTile.__back_pos = currentPosTile.__start_pos
                    local mx, my = backPad:getPosition()
                    local flag = -1
                    if tonumber(currentPosTile._camp) == 1 then
                    	flag = 1
                    end
					currentPosTile:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(mx + flag * 68, my + flag * 28)),
						cc.CallFunc:create(function( sender )
							local weapon = sender._attack_weapon
							local target = sender._attack_target

							weapon._nextAction = animation_moving
                            weapon:getAnimation():playWithIndex(animation_remote_attack_began)
                                    
							if nil ~= target.__action then
								weapon:runAction(target.__action)
								target.__action:release()
								target.__action = nil
							end
						end)
						))
				else
					if nil ~= target.__action then
						weapon:runAction(target.__action)
						target.__action:release()
						target.__action = nil
					end
				end
			else
				if nil ~= target.__action then
					weapon:runAction(target.__action)
					target.__action:release()
					target.__action = nil
				end
			end
		end
	else
		local skillInfluenceElementData = armature._sie
		local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
		--> print("posterior_lighting_effect_id:::>>", posterior_lighting_effect_id)
		if posterior_lighting_effect_id >= 0 then		
			local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or currentPosTile._camp)
			-- local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
			--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, 0)
			armatureEffect._posTile = backPad
			armatureEffect._base = armature
			armatureEffect._sie = armature._sie
			armatureEffect._def = armature._def
			if armature._sie == nil then
				armatureEffect._invoke = deleteEffectFile
			else
				armatureEffect._invoke = executeEffectSkillingOver
				armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)
			end
			
			--[[
				0基于施放者与承受者的路径（根据目标数量绘制光效）
				1基于施放者位置（只绘制一个光效）
				2基于承受者位置（根据目标数量绘制光效）
				3基于对方阵营中心（只绘制一个光效）
				4基于攻击范围无视存活数量（根据目标数量绘制光效）
				5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
				6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
			--]]
			if armatureBack._sie ~= nil then
				local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
				-- 处理角度和路径
				local start_pos = nil
				local end_pos = nil
				local langle = 0
				if armatureBack._isByReact == true then
					start_pos = cc.p(armatureBack._reactor._posTile:getPosition())
					end_pos = cc.p(currentPosTile:getPosition())
					if armatureBack._reactor._posTile._camp == "1" then
						langle = -180
					end
				else
					start_pos = cc.p(currentPosTile:getPosition())
					end_pos = cc.p(armature._posTile:getPosition())
					if currentPosTile._camp == "1" then
						langle = -180
					end
				end
				local angle = ccaf(start_pos, end_pos)+langle
				if angle >= 180 then
					angle = 180 - angle
				end
				if angle <= -180 then
					angle = 180 - (180 - angle)
				end
				if angle == langle and langle < 0 then
					angle = 0
				end
				local pSize = currentPosTile:getContentSize()
				start_pos.x = start_pos.x + pSize.width * currentPosTile:getScaleX()/2
				start_pos.y = start_pos.y + pSize.height * currentPosTile:getScaleY()/2
				end_pos.x = end_pos.x + pSize.width * armature._posTile:getScaleX()/2
				end_pos.y = end_pos.y + pSize.height * armature._posTile:getScaleY()/2
				
				if lightingEffectDrawMethod == 0 then
					armatureEffect:setRotation(angle)
					armatureEffect:setPosition(start_pos)
					armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration * __fight_recorder_action_time_speed, end_pos))

					armatureEffect._angle = angle
					armatureEffect._start_position = start_pos
					armatureEffect._end_position = end_pos
				elseif lightingEffectDrawMethod == 7 then
					armatureEffect:setRotation(angle)
					armatureEffect:setPosition(start_pos)
				elseif lightingEffectDrawMethod == 1 then
					armatureEffect:setPosition(start_pos)
				end
			end
		else
			if armature._defs ~= nil then
				for i, v in pairs(armature._defs) do
					drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
				end
				resetArmatureData(armature)
			else
				drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
				resetArmatureData(armature)
			end
			executeHeroMoveToOriginTarget()
		end
		local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
		if posterior_lighting_sound_effect_id >= 0 then
			playEffectMusic(posterior_lighting_sound_effect_id)
		end
	end
end

local function __executeEffectSkilling(armatureBack, t)
	_executeEffectSkilling(armatureBack, armatureBack.___targetPostTile)
end

executeEffectSkilling = function(armatureBack, targetPostTile)
	_executeEffectSkilling(armatureBack, targetPostTile)

	-- armatureBack.___targetPostTile = targetPostTile
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, __executeEffectSkilling, armatureBack)
end

local _executeEffectSkilling1 = nil
_executeEffectSkilling1 = function(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 and backPad~= nil then		
		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or mPosTile._camp)
		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._skf = armature._skf
		if armature._sie == nil then
			armatureEffect._invoke = deleteEffectFile
		else
			armatureEffect._invoke = executeEffectSkillingOver
			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent1)
		end
		
		--[[
			0基于施放者与承受者的路径（根据目标数量绘制光效）
			1基于施放者位置（只绘制一个光效）
			2基于承受者位置（根据目标数量绘制光效）
			3基于对方阵营中心（只绘制一个光效）
			4基于攻击范围无视存活数量（根据目标数量绘制光效）
			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
		--]]
		
		local xx, yy = backPad:getPosition()
		local pSize = backPad:getContentSize()
		--armatureEffect:setPosition(cc.p(xx + pSize.width/2, yy + pSize.height/2 * ((tonumber(backPad._camp + 1) % 2 == 0 and 1 or -1)))
		armatureEffect:setPosition(cc.p(xx + pSize.width/2, yy + pSize.height/2 + pSize.height/2 * (backPad._camp=="0" and 1 or -1)))
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

executeEffectSkilling1 = function(armatureBack)
	_executeEffectSkilling1(armatureBack)

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, _executeEffectSkilling1, armatureBack)
end

executeEffectSkilling2 = function(armatureBack)

end

local _executeEffectSkilling3 = nil
_executeEffectSkilling3 = function(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._skf = armature._skf
		if armature._sie == nil then
			armatureEffect._invoke = deleteEffectFile
		else
			armatureEffect._invoke = executeEffectSkillingOver
			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent3)
		end
		
		--[[
			0基于施放者与承受者的路径（根据目标数量绘制光效）
			1基于施放者位置（只绘制一个光效）
			2基于承受者位置（根据目标数量绘制光效）
			3基于对方阵营中心（只绘制一个光效）
			4基于攻击范围无视存活数量（根据目标数量绘制光效）
			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
		--]]
		
		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		
		if backPad._camp == "1" then
			local posTile2 = getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
			local posTile5 = getRole(0, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy5 + (yy2 - yy5)))
			
		else
			local posTile2 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
		
			local posTile5 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy2 + (yy5 - yy2)))
		end
		
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

executeEffectSkilling3 = function(armatureBack)
	_executeEffectSkilling3(armatureBack)

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, _executeEffectSkilling3, armatureBack)
end

executeEffectSkilling4 = function(armatureBack)

end

local executeEffectSkilling5 = nil
_executeEffectSkilling5 = function(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._skf = armature._skf
		if armature._sie == nil then
			armatureEffect._invoke = deleteEffectFile
		else
			armatureEffect._invoke = executeEffectSkillingOver
			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent5)
		end
		
		--[[
			0基于施放者与承受者的路径（根据目标数量绘制光效）
			1基于施放者位置（只绘制一个光效）
			2基于承受者位置（根据目标数量绘制光效）
			3基于对方阵营中心（只绘制一个光效）
			4基于攻击范围无视存活数量（根据目标数量绘制光效）
			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
		--]]
		
		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

executeEffectSkilling5 = function(armatureBack)
	_executeEffectSkilling5(armatureBack)

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, _executeEffectSkilling5, armatureBack)
end

local _executeEffectSkilling6 = nil
_executeEffectSkilling6 = function(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	 -- dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._skf = armature._skf
		if armature._sie == nil then
			armatureEffect._invoke = deleteEffectFile
		else
			armatureEffect._invoke = executeEffectSkillingOver
			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent6)
		end
		
		--[[
			0基于施放者与承受者的路径（根据目标数量绘制光效）
			1基于施放者位置（只绘制一个光效）
			2基于承受者位置（根据目标数量绘制光效）
			3基于对方阵营中心（只绘制一个光效）
			4基于攻击范围无视存活数量（根据目标数量绘制光效）
			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
		--]]
		
		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		local attPosType = armature._skf.attPosType
		if backPad._camp == "1" then
			local posTile2 = getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
			local posTile5 = getRole(0, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy5 + (yy2 - yy5) + pSize.height/2))
			
		else
			local posTile2 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
		
			local posTile5 = getRole(1, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy2 + (yy5 - yy2) + pSize.height/2))
		end
		
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

executeEffectSkilling6 = function(armatureBack)
	_executeEffectSkilling6(armatureBack)

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, _executeEffectSkilling6, armatureBack)
end

local _executeEffectSkilling7 = nil
_executeEffectSkilling7 = function(armatureBack, defArmatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	 -- dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	
	--> print("攻击前段光效绘制7:", posterior_lighting_effect_id, armature._sie)

	if posterior_lighting_effect_id >= 0 then		
		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or mPosTile._camp)
		
		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._skf = armature._skf
		if armature._sie == nil then
			armatureEffect._invoke = deleteEffectFile
		else
			armatureEffect._invoke = executeEffectSkillingOver
			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent1)
		end
		
		--[[
			0基于施放者与承受者的路径（根据目标数量绘制光效）
			1基于施放者位置（只绘制一个光效）
			2基于承受者位置（根据目标数量绘制光效）
			3基于对方阵营中心（只绘制一个光效）
			4基于攻击范围无视存活数量（根据目标数量绘制光效）
			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
		--]]
		
		if armatureBack._sie ~= nil and lightingEffectDrawMethod == 7 then
			--> print("进行光效角度调整7")
			local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
			-- 处理角度和路径
			local start_pos = nil
			local end_pos = nil
			local langle = 0
			if armatureBack._isByReact == true then
				start_pos = cc.p(armatureBack._reactor._posTile:getPosition())
				end_pos = cc.p(mPosTile:getPosition())
				if armatureBack._reactor._posTile._camp == "1" then
					langle = -180
				end
			else
				start_pos = cc.p(mPosTile:getPosition())
				end_pos = cc.p(defArmatureBack._posTile:getPosition())
				if mPosTile._camp == "1" then
					langle = -180
				end
			end
			local angle = ccaf(start_pos, end_pos)+langle
			if angle >= 180 then
				angle = 180 - angle
			end
			if angle <= -180 then
				angle = 180 - (180 - angle)
			end
			if angle == langle and langle < 0 then
				angle = 0
			end
			
			local pSize = mPosTile:getContentSize()
			start_pos.x = start_pos.x + pSize.width * mPosTile:getScaleX()/2
			start_pos.y = start_pos.y + pSize.height * mPosTile:getScaleY()/2
			end_pos.x = end_pos.x + pSize.width * armature._posTile:getScaleX()/2
			end_pos.y = end_pos.y + pSize.height * armature._posTile:getScaleY()/2
			
			if lightingEffectDrawMethod == 0 then
				armatureEffect:setRotation(angle)
				armatureEffect:setPosition(start_pos)
				armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration * __fight_recorder_action_time_speed, end_pos))

				armatureEffect._angle = angle
				armatureEffect._start_position = start_pos
				armatureEffect._end_position = end_pos
			elseif lightingEffectDrawMethod == 7 then
				armatureEffect:setRotation(angle)
				armatureEffect:setPosition(start_pos)
			elseif lightingEffectDrawMethod == 1 then
				armatureEffect:setPosition(start_pos)
			end
		else
		end
		
		local xx, yy = backPad:getPosition()
		local pSize = backPad:getContentSize()
		--armatureEffect:setPosition(cc.p(xx + pSize.width/2, yy + pSize.height/2 * ((tonumber(backPad._camp + 1) % 2 == 0 and 1 or -1)))
		armatureEffect:setPosition(cc.p(xx + pSize.width/2, yy + pSize.height/2 + pSize.height/2 * (backPad._camp=="0" and 1 or -1)))
	else
		--> print("无光效绘制, 直接进行攻击伤害逻辑.", armature._defs)
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

local function __executeEffectSkilling7(armatureBack, t)
	_executeEffectSkilling7(armatureBack, armatureBack.___defArmatureBack)
end

executeEffectSkilling7 = function(armatureBack, defArmatureBack)
	_executeEffectSkilling7(armatureBack, defArmatureBack)

	-- armatureBack.___defArmatureBack = defArmatureBack
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, __executeEffectSkilling7, armatureBack)
end

-- BUFF持续光效
executeBuffEffect = function(armatureBack)
--[[
格挡反击技能ID 555 
格挡调用光效ID 80
禁怒调用持续光效ID 88
眩晕（冰冻）调用持续光效ID 89
麻痹（禁锢）调用持续光效ID 90
封技（短路）调用持续光效ID 91
中毒（腐蚀）调用持续光效ID 92
灼烧（燃烧）调用持续光效ID 93
爆裂状态调用持续光效ID 94（这个是天赋里会用到的）
无敌（铁壁）、增加格挡率BUFF调用持续光效ID 95
-- 处理伤害
	-- 技能种类：0为攻击，1为加血，2为加怒，3为减怒，4为禁怒，
	5为眩晕，6为中毒，7为麻痹，8为封技，9为灼烧，10为爆裂，11为增加档格，12为增加防御，13必闪，14吸血，15禁疗
	
--]]
	local armature = armatureBack
	local backPad = armature._base._posTile
	-- if backPad == nil then
		-- return
	-- end
	local effectIndex = 0
	if armatureBack._def ~= nil then
		if armatureBack._def.defenderST == "4" then
			effectIndex = 88
		elseif armatureBack._def.defenderST == "5" then
			effectIndex = 52
		elseif armatureBack._def.defenderST == "6" then
			effectIndex = 53
		elseif armatureBack._def.defenderST == "7" then
			effectIndex = 90
		elseif armatureBack._def.defenderST == "8" then
			effectIndex = 52
		elseif armatureBack._def.defenderST == "9" then
			effectIndex = 51
		elseif armatureBack._def.defenderST == "10" then
			effectIndex = 54
		elseif armatureBack._def.defenderST == "11" then
			effectIndex = 54
		elseif armatureBack._def.defenderST == "12" then
			effectIndex = 54
		elseif armatureBack._def.defenderST == "13" then
			effectIndex = 84
		elseif armatureBack._def.defenderST == "15" then
			effectIndex = 83
		end
	end
	local armatureEffect = nil
	if tonumber(armature._def.stRound) > 0 then
		if backPad._buff == nil then
			backPad._buff = {}
		end
		local tarmature = backPad._buff[armature._def.defenderST]
		if tarmature ~= nil then
			armatureEffect = tarmature
			armatureEffect._base = armature._base
			armatureEffect._sie = armature._sie
			armatureEffect._def = armature._def
			armatureEffect._LastsCountTurns = tonumber(armature._def.stRound)
			armatureEffect._lastEffect = true
		end
	end
	if armatureEffect == nil and effectIndex ~= 0 and tonumber(armature._def.stRound) > 0 then
		armatureEffect = createEffect(backPad, effectIndex, backPad._camp, true)
		armatureEffect._invoke = deleteEffectFile
		armatureEffect._base = armature._base
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._LastsCountTurns = tonumber(armature._def.stRound)
		armatureEffect._lastEffect = true
		-- armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)
		if backPad._buff == nil then
			backPad._buff = {}
		end
		if backPad._buff ~= nil then
			backPad._buff[armature._def.defenderST] = armatureEffect
		end
	end
			
	--armature._LastsCountTurns = nil
	deleteEffectFile(armatureBack)
end

-- 技能光效后段
local _executeEffectSkillEnd = nil
_executeEffectSkillEnd = function(armatureBack)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return
	end
	local armature = armatureBack
	local backPad = armature._base._posTile
	-- 技能光效后段
	-- local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local bear_lighting_effect_id = armature._base._isReact == true 
		and 80 
		or getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.bear_lighting_effect_id)	-- dms.atoi(skillInfluenceElementData, skill_influence.bear_lighting_effect_id)

	if bear_lighting_effect_id >= 0 then
		armatureEffect = createEffect(backPad, bear_lighting_effect_id, backPad._camp)
		armatureEffect._invoke = executeBuffEffect
		armatureEffect._base = armature._base
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
	end
	local bear_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.bear_sound_effect_id)
	if bear_sound_effect_id >= 0 then
		playEffectMusic(bear_sound_effect_id)
	end
end

executeEffectSkillEnd = function(armatureBack)
	_executeEffectSkillEnd(armatureBack)

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, _executeEffectSkillEnd, armatureBack)
end
-- END~技能技能光效前段
-- --------------------------------------------------------------------- --
local missTime = 0
local function cleanBattleHero()
	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
	missTime = 0
	for i=1, 6 do
		local hero = getRole(0, i) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", 0, i))
		if hero._armature ~= nil and hero._armature._isDeath == true then
			missTime = missTime + 1
			hero._armature._isDeathed = true
			hero._armature._actionIndex = death_buff
			hero._armature._nextAction = death_buff_end
			if nil ~= armature._child_list then
				for i, v in pairs(armature._child_list) do
					v._actionIndex = death_buff_end
					v._nextAction = death_buff_end
					v:getAnimation():playWithIndex(death_buff_end)
				end
			elseif nil ~= armature._weapon then
				hero._armature._weapon._actionIndex = death_buff_end
				hero._armature._weapon._nextAction = death_buff_end
				hero._armature._weapon:getAnimation():playWithIndex(death_buff_end)
			end
			local _invoke = hero._armature._invoke
			hero._armature._invoke = nil
			hero._armature:getAnimation():playWithIndex(death_buff_end)
			hero._armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
			hero._armature._invoke = _invoke
			-- tolua.cast(hero._armature, "CCNode"):removeFromParent(true)
			-- cleanBuffEffect(hero._armature._posTile, true)
		end
		
		local master = getRole(1, i) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, i))
		if master._armature ~= nil and master._armature._isDeath == true then
			missTime = missTime + 1
			master._armature._isDeathed = true
			master._armature._actionIndex = death_buff
			master._armature._nextAction = death_buff_end
			if nil ~= armature._child_list then
				for i, v in pairs(armature._child_list) do
					v._actionIndex = death_buff_end
					v._nextAction = death_buff_end
					v:getAnimation():playWithIndex(death_buff_end)
				end
			elseif nil ~= armature._weapon then
				master._armature._weapon._actionIndex = death_buff_end
				master._armature._weapon._nextAction = death_buff_end
				master._armature._weapon:getAnimation():playWithIndex(death_buff_end)
			end
			local _invoke = master._armature._invoke
			master._armature._invoke = nil
			master._armature:getAnimation():playWithIndex(death_buff_end)
			master._armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
			master._armature._invoke = _invoke
			-- tolua.cast(master._armature, "CCNode"):removeFromParent(true)
			-- cleanBuffEffect(master._armature._posTile, true)
		end
	end
end

-- --------------------------------------------------------------------- --
-- 攻击切帧控制

function deleteDropEffectFile(armatureBack)
	deleteEffectFile(armatureBack)
	if BattleSceneClass._isSkepBattle == true and setDeathArmatureCount >= 0 then
		currentRoundIndex = _ED.attackData.roundCount
		setDeathArmatureCount = 0 -- setDeathArmatureCount - 1
		nextRoundBattle()
	end
end

local function __drop_attackChangeActionCallback(armatureBack)
	local armature = armatureBack
	if armature ~= nil then
		local actionIndex = armature._actionIndex
		-- 攻击切帧控制
		if actionIndex == 0 then
			deleteDropEffectFile(armatureBack)
		elseif actionIndex == 1 then
			armature._nextAction = 2
			state_machine.excute("fight_ui_drop_moving", 0, {_index = armature.drawType, _armature = armature})
		elseif actionIndex == 2 then
			armature._nextAction = 0
		end
	end	
end

function deathBuff(armatureBack,armature)
	-- if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	-- 	if armatureBack._isDeathed == true then
	-- 		if armature._role._camp_preference == 20 then
	-- 		else
	-- 			local armatureEffect = createEffect(armature._posTile, "death", armature._posTile._camp)
	-- 			armatureEffect._base = armature
	-- 			armatureEffect._sie = armature._sie
	-- 			armatureEffect._def = armature._def
	-- 			armatureEffect._invoke = deleteEffectFile
	-- 		end
	-- 	end
	-- end

	armature._role._hp = 0
	showRoleHP(armature)
	if armatureBack._posTile._camp == "1" then
		if armatureBack._isDeathed == true then
			if armatureBack._def ~= nil then
				-- local fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10866")
				-- local str = fightRewardItemCount:getString()
				-- str = ""..(zstring.tonumber(str) + zstring.tonumber(armatureBack._def.dropCount))
				-- --tolua.cast(fightRewardItemCount,"Label"):setText(str)
				-- fightRewardItemCount:setString(str)
				state_machine.excute("fight_ui_update_battle_card_drop", 0, {dropType = zstring.tonumber(armatureBack._def.dropType), dropCount = zstring.tonumber(armatureBack._def.dropCount)})

				if armatureBack ~= nil and armatureBack._def~=nil and armatureBack._def.dropCount~=nil then
					if zstring.tonumber(armatureBack._def.dropCount) > 0 then
						local armatureEffect = createEffect(fwin._view._layer, 96, 0)
						local drawIconImage = string.format("effect/effice_96_%s.png", armatureBack._def.dropType)
						local drawIcon = ccs.Skin:create(drawIconImage)
						armatureEffect:getBone("Layer8"):addDisplay(drawIcon, 0)
						armatureEffect:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
						armatureEffect._invoke = nil
						armatureEffect._actionIndex = 0
						armatureEffect.drawType = armatureBack._def.dropType + 1
						if BattleSceneClass._isSkepBattle == true then
							setDeathArmatureCount = setDeathArmatureCount + 1
						end
						armatureEffect:getAnimation():playWithIndex(0)

						armatureEffect._nextAction = 1
						armatureEffect._invoke = __drop_attackChangeActionCallback
						iii = ii +1
						armatureEffect._move_position = cc.p(0, 0)

						local size = armatureBack:getParent():getContentSize()
						local scaleX = armatureBack:getParent():getScaleX()
						local scaleY = armatureBack:getParent():getScaleX()
						local olePosition = fwin:convertToWorldSpaceAR(armatureBack:getParent(), cc.p(0, size.height/2)) -- armatureBack._posTile:convertToWorldSpace(cc.p(0, 0))
						olePosition.x = olePosition.x / app.scaleFactor + size.width * scaleX / 2
						olePosition.y = olePosition.y / app.scaleFactor + size.height * scaleY / 2
						--fwin._view._layer:addChild(armatureEffect)
						armatureEffect:setPosition(olePosition);
					end
				end
			end
			-- armature._posTile._armature = nil
			armatureBack:removeFromParent(true)
			if nil ~= armatureBack._weapon then
				armatureBack._weapon:removeFromParent(true)
				armatureBack._weapon = nil
			end
			cleanBuffEffect(armatureBack._posTile, true)
			armatureBack._posTile:removeAllChildren(true)
			-- armature._posTile._armature:setVisible(false)
			-- armatureBack._posTile:setVisible(false)

			if BattleSceneClass._isSkepBattle == true and setDeathArmatureCount >= 0 then
				currentRoundIndex = _ED.attackData.roundCount
				setDeathArmatureCount = 0 -- setDeathArmatureCount -1
				nextRoundBattle()
			end
		end
		armatureBack._isDeathed = true
		-- 敌方死亡，绘制战场的掉落！
	else
		battle_execute._setNextAction(armature, animation_is_death)

		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			armature._heroInfoWidget:removeAllChildren(true)
		end

		if BattleSceneClass._isSkepBattle == true and setDeathArmatureCount >= 0 then
			currentRoundIndex = _ED.attackData.roundCount
			setDeathArmatureCount = 0 -- setDeathArmatureCount -1
			nextRoundBattle()
		end
	end
	
	if attack_logic.__fight_is_over == true then
		state_machine.excute("fight_is_over", 0, 0)
		attack_logic.__fight_is_over = false
	end
	
	local wait_time = 0
	local _schedulerEntry = nil
	
	local _unregisterUpdateScheduler = function()
		if app.scheduler ~= nil and _schedulerEntry ~= nil then 
			app.scheduler:unscheduleScriptEntry(_schedulerEntry)
			_schedulerEntry = nil
		end
	end
	
	local _update = function(dt)
		wait_time = wait_time + dt
		if wait_time > 10 then
			_unregisterUpdateScheduler()
		end
		if attack_logic.__fight_is_over == true then
			state_machine.excute("fight_is_over", 0, 0)
			attack_logic.__fight_is_over = false
			_unregisterUpdateScheduler()
		end
	end
	
	local _registerUpdateScheduler = function()
		_schedulerEntry = app.scheduler:scheduleScriptFunc(_update, 0.5, false)
	end
	
	_registerUpdateScheduler()
end

local function roleExecuteAttackMoving(armatureBack)
	local armature = armatureBack
	local skillQuality = dms.atoi(armatureBack._sed_action, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
	local skillProperty = dms.atoi(armatureBack._sed_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local attackMovePos = armatureBack._attackMovePos
	if skillProperty == 0 then
		-- 近身攻击上的移动帧组
		mtime = moveToTargetTime1
		executeHeroMoveBy()
		--armatureBack._nextAction = _enum_animation_frame_index.animation_melee_attack_began
		changeActtackToAttackBegan(armatureBack)
	else
		-- 技能近身攻击上的移动帧组
		mtime = moveToTargetTime2
		executeHeroMoveBy()
		--armatureBack._nextAction = _enum_animation_frame_index.animation_melee_skill_began
		changeActtackToAttackBegan(armatureBack)
	end
end

local function roleExecuteAttacking(armatureBack)
	local armature = armatureBack
	local skillQuality = dms.atoi(armatureBack._sed_action, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
	local skillProperty = dms.atoi(armatureBack._sed_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local attackMovePos = armatureBack._attackMovePos
	--> print("进入待机3")
	if attackMovePos == 0 or attackMovePos == 8 then
		if skillProperty == 0 then
             -- 远程攻击中段
            battle_execute._setNextAction(armatureBack, animation_standby)
			if armatureBack._isReact == true then
				-- 进行反击, 启动反击中段处理
				if armatureBack._byReactor ~= nil then
					-- 进行反击, 启动反击中段处理
					executeEffectSkilling(armatureBack._byReactor)
				end
			else
				executeAttacking()
			end
		else
			-- 技能攻击远程中段
			battle_execute._setNextAction(armatureBack, animation_standby)
			if executeAfterInfluenceCount > 0 then
				executeAfterAttacking()
			else
				executeAttacking()
			end
		end
	else
		if skillProperty == 0 then
			-- 近身攻击中段
			battle_execute._setNextAction(armatureBack, animation_standby)
			executeAttacking()
		else
			-- 技能近身攻击中段
			battle_execute._setNextAction(armatureBack, animation_standby)
			executeAttacking()
		end
	end

	-- if skillProperty ~= 0 then
		-- armatureBack._role._sp = armatureBack._role._sp - 4
		-- if armatureBack._role._sp < 0 then
			-- armatureBack._role._sp = 0
		-- end
		-- showRoleSP(armatureBack)
	-- end
end

roleExecuteAttackOver = function(armatureBack)
	state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
	local armature = armatureBack
	local skillQuality = dms.atoi(armatureBack._sed_action, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
	local skillProperty = dms.atoi(armatureBack._sed_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local attackMovePos = armatureBack._attackMovePos
	--> print("进入待机4")
	if attackMovePos == 0 or attackMovePos == 8 then
		if skillProperty == 0 then
		    -- 远程攻击后段
			battle_execute._setNextAction(armatureBack, animation_standby)
			if armature._reactor ~= nil and armature._reactor._isReact == true then
				-- 反击结束
				armature._reactor._isReact = false
				armature._reactor._isByReact = false
				armature._reactor._byReactor = nil
				armature._sie = nil
				armature._def = nil
				armature._def = nil
				armature._defr = nil
				armature._reactor = nil
				
				nextAttack()
			else
				executeAttackerBuff()
			end
		else
		    -- 技能远程攻击后段
			battle_execute._setNextAction(armatureBack, animation_standby)
			executeAttackerBuff()
		end
	else
		if skillProperty == 0 then
            -- 近身攻击后段
			mtime = moveToTargetTime1
			executeHeroMoveByBack()
			if needMove == true then
				-- 近身攻击后段:当前角色移动攻击完毕，现在返回原点
			else
				-- 近身攻击后段:当前角色原地攻击完毕
			end
			battle_execute._setNextAction(armatureBack, animation_standby)
		else
		    -- 技能攻击近身后段
			mtime = moveToTargetTime2
			executeHeroMoveByBack()
			if needMove == true then
				-- 技能攻击近身后段:当前角色移动攻击完毕，现在返回原点
			else
				-- 技能攻击近身后段:当前角色原地攻击完毕
			end
			battle_execute._setNextAction(armatureBack, animation_standby)
		end
	end
end

__attackChangeActionCallback = function(armatureBack)
	local armature = armatureBack
	armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
	if armature ~= nil then
		local actionIndex = armature._actionIndex
		showSpineAnimationStandby(armature, actionIndex)
		-- 攻击切帧控制

		-- if armature._isDeath == true then
		-- 	--> print("actionIndex:", actionIndex, armature._camp, armature._pos)

		-- 	if armature._weapon then
		-- 		--> print("------actionIndex---weapon->:", armature._weapon._actionIndex, armature._weapon._nextAction)
		-- 	end
		-- end
		-- if armature._camp == "0" then 
		-- 	if "" .. armature._pos == "2" then 
		-- 		--> print("actionIndex:", actionIndex)
		-- 		--> print("------actionIndex---weapon->:", armature._weapon._actionIndex, armature._weapon._nextAction)
		-- 	end
		-- end
		
		if actionIndex == animation_move then
			-- 我方移动动画
			battle_execute._setNextAction(armature, animation_moving)
		elseif actionIndex == animation_moving then
		elseif actionIndex == animation_move_end then
		elseif actionIndex == animation_standby then				-- 待机帧
			armature:getAnimation():setSpeedScale(1.0)
			if armature._start_attack == true then
				armature._start_attack = false
				--> print("准备进入攻击前段")
				changeActtackToAttackBegan(armature)
				return
			end

			if setDeathArmatureCount == 0 and isNoDeath == true and BattleSceneClass._isSkepBattle == false then
				isNoDeath = false
				currentRoundIndex = _ED.attackData.roundCount
				nextRoundBattle()
			end
		elseif actionIndex == _enum_animation_frame_index.animation_attack_moving			-- 近身攻击上的移动帧组
			or actionIndex == _enum_animation_frame_index.animation_skill_moving			-- 技能近身攻击上的移动帧组
			or actionIndex == _enum_animation_frame_index.animation_fit_move_action
			then
			roleExecuteAttackMoving(armatureBack)
		elseif actionIndex == _enum_animation_frame_index.animation_melee_attack_began		-- 近身攻击前段
			or actionIndex == _enum_animation_frame_index.animation_remote_attack_began	-- 远程攻击前段
			or actionIndex == _enum_animation_frame_index.animation_melee_skill_began		-- 技能近身攻击前段
			or actionIndex == _enum_animation_frame_index.animation_remote_skill_began		-- 技能攻击远程前段
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_attack_began 
			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_attack_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_skill_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_skill_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_skill_began
			or actionIndex == _enum_animation_frame_index.animation_hero_aircraft_carrier_skilling
			or actionIndex == _enum_animation_frame_index.animation_master_aircraft_carrier_skilling
			or actionIndex == _enum_animation_frame_index.animation_heti1
			-- or actionIndex == _enum_animation_frame_index.animation_combine_skill_effect
			or actionIndex == _enum_animation_frame_index.animation_lr_shake_skill_effect
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_shoot_began
			or actionIndex == _enum_animation_frame_index.animation_hero_melee_arow_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_arow_began
			or actionIndex == _enum_animation_frame_index.animation_hero_torpedo_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_torpedo_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_attacking
			or actionIndex == _enum_animation_frame_index.animation_fit_skill_leifu_began
			or actionIndex == _enum_animation_frame_index.animation_fit_lift_began
			or actionIndex == _enum_animation_frame_index.animation_fit_right_began
			or actionIndex == _enum_animation_frame_index.animation_fit_skill_deep_sea_began
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_hero_melee_shoot_began
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_enemy_melee_shoot_began
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_remote_summon_began
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_enemy_melee_behead_began
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_hero_melee_behead_began
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_remote_began
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_remote_began
			or actionIndex == _enum_animation_frame_index.animation_hero_45_shoot_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_45_shoot_began
			or actionIndex == _enum_animation_frame_index.animation_hero_row_attack_slow_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_row_attack_slow_began
			or actionIndex == _enum_animation_frame_index.animation_hero_multiple_behead_began
			or actionIndex == _enum_animation_frame_index.animation_enemy_multiple_behead_began
			then	-- 所有的攻击前段部分
			changeActtackToAttacking(armatureBack)
		elseif actionIndex == _enum_animation_frame_index.animation_melee_attacking		-- 近身攻击中段
			or actionIndex == _enum_animation_frame_index.animation_remote_attacking		-- 远程攻击中段
			or actionIndex == _enum_animation_frame_index.animation_melee_skilling			-- 技能近身攻击中段
			or actionIndex == _enum_animation_frame_index.animation_remote_skilling		-- 技能攻击远程中段
			or actionIndex == _enum_animation_frame_index.animation_add_hp_buff
			or actionIndex == _enum_animation_frame_index.animation_heti2
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_attacking
			-- or actionIndex == _enum_animation_frame_index.animation_enemy_remote_attacking
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_skilling
			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_skilling
			or actionIndex == _enum_animation_frame_index.animation_hero_torpedo_skilling
			or actionIndex == _enum_animation_frame_index.animation_master_torpedo_skilling
			or actionIndex == _enum_animation_frame_index.animation_scale_drop_effect
			or actionIndex == _enum_animation_frame_index.animation_lr_flip_effect
			or actionIndex == _enum_animation_frame_index.animation_line_move_to_effect
			or actionIndex == _enum_animation_frame_index.animation_lr_move_to_effect
			or actionIndex == _enum_animation_frame_index.animation_hero_move_back_launch_effect
			or actionIndex == _enum_animation_frame_index.animation_master_move_back_launch_effect
			or actionIndex == _enum_animation_frame_index.animation_fit_ru_ld_move_to_effect
			or actionIndex == _enum_animation_frame_index.animation_fit_lu_rd_move_to_effect
			or actionIndex == _enum_animation_frame_index.animation_fit_lift_skilling
			or actionIndex == _enum_animation_frame_index.animation_fit_right_skilling
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_shoot_skilling
			or actionIndex == _enum_animation_frame_index.animation_hero_melee_arow_skilling
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_arow_skilling
			or actionIndex == _enum_animation_frame_index.animation_hero_continuous_shelling_skilling
			or actionIndex == _enum_animation_frame_index.animation_enemy_continuous_shelling_skilling
			or actionIndex == _enum_animation_frame_index.animation_union_shelling_shelling_skilling
			or actionIndex == _enum_animation_frame_index.animation_fit_skill_leifu_skilling
			or actionIndex == _enum_animation_frame_index.animation_fit_skill_deep_sea_skilling
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_hero_melee_shoot_skilling
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_enemy_melee_shoot_skilling
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_remote_summon_skilling
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_enemy_melee_behead_skilling
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_hero_melee_behead_skilling
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_remote_skilling
			or actionIndex == _enum_animation_frame_index.animation_normal_fit_remote_skilling
			or actionIndex == _enum_animation_frame_index.animation_hero_45_shoot_skilling
			or actionIndex == _enum_animation_frame_index.animation_enemy_45_shoot_skilling
			or actionIndex == _enum_animation_frame_index.animation_hero_row_attack_slow_skilling
			or actionIndex == _enum_animation_frame_index.animation_enemy_row_attack_slow_skilling
			or actionIndex == _enum_animation_frame_index.animation_hero_multiple_behead_skilling
			or actionIndex == _enum_animation_frame_index.animation_enemy_multiple_behead_skilling
			then	-- 所有的攻击中段部分
			roleExecuteAttacking(armatureBack)
		elseif actionIndex == _enum_animation_frame_index.animation_melee_attack_end		 -- 近身攻击后段
			or actionIndex == _enum_animation_frame_index.animation_remote_attack_end		-- 远程攻击后段
			or actionIndex == _enum_animation_frame_index.animation_melee_skill_end		-- 技能攻击近身后段
			or actionIndex == _enum_animation_frame_index.animation_remote_skill_end		-- 技能远程攻击后段
			then		-- 所有的攻击后段部分
			roleExecuteAttackOver(armatureBack)
		elseif actionIndex == animation_hero_by_attack then			-- 我方被攻击
			--> print("进入待机5")
			battle_execute._setNextAction(armatureBack, animation_standby)
		elseif actionIndex == animation_emeny_by_attack then		-- 敌方被攻击
			--> print("进入待机6")
			battle_execute._setNextAction(armatureBack, animation_standby)
		elseif actionIndex == animation_hero_miss then				-- 我方闪避
			--> print("进入待机7")
			battle_execute._setNextAction(armatureBack, animation_standby)
		elseif actionIndex == animation_emeny_miss then				-- 我方闪避
			--> print("进入待机8")
			battle_execute._setNextAction(armatureBack, animation_standby)
		elseif actionIndex == animation_death then					-- 死亡
			deathBuff(armatureBack,armature)
		elseif actionIndex == death_buff then
		elseif actionIndex == death_buff_end then
		elseif actionIndex == animation_send_bullet then
			battle_execute._setNextAction(armatureBack, animation_standby)				
		elseif actionIndex == _enum_animation_frame_index.animation_combine_skill_effect 
			then
			--> print("进入待机9")
			battle_execute._setNextAction(armatureBack, animation_standby)
			local attackCount = __fit_params[_enum_params_index.param_attack_count] + 1
			__fit_params[_enum_params_index.param_attack_count] = attackCount
			if attackCount == #__fit_roles then
				__fit_params[_enum_params_index.param_attack_count] = 0
				excuteSPSkillEffectFit()

				-- -- excuteSPSkillEffectFit()
				-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
				-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, excuteSPSkillEffectFit)
				-- -- state_machine.excute("move_logic_begin_move_all_role", 0, {__fit_roles, __fit_params})
			end
		end
	end	
end
-- END
-- --------------------------------------------------------------------- --

nextAttack111 = function()
	local attackSectionNumber = 0 --攻击段数
	local attackTotalHarm = 0 --多段攻击总伤害
	BattleSceneClass._isSkepBattle = false
	
	if executeNextRoundBattleEvent(currentAttackCount + 1) == true then
		return
	end	
	
	currentAttackCount = currentAttackCount + 1
	--> print("当前战斗回合数：", currentRoundIndex, currentRoundAttackIndex)
	local _roundData = _ED.attackData.roundData[currentRoundIndex]
	if _roundData == nil or currentRoundAttackIndex > _roundData.curAttackCount then
		nextRoundBattle()
		return
	end
	
	attData = _roundData.roundAttacksData[currentRoundAttackIndex]
	--> print("当前战斗回合攻击数据：", attData, _roundData.curAttackCount)
	local attacker 				= attData.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
	local attackerPos 			= attData.attackerPos 					-- = npos(list)		--出手方位置(1-6)
	local linkAttackerPos 		= attData.linkAttackerPos	--是否有合体技(>0表示有.且表示合体的对象)
	local attackMovePos			= tonumber(attData.attackMovePos)					-- = npos(list)		--移动到的位置(0-8)
	local skillMouldId			= tonumber(attData.skillMouldId) 					-- = npos(list)	--技能模板id
	local skillInfluenceCount 	= tonumber(attData.skillInfluenceCount) 			-- = tonumber(npos(list))	-- 技能效用数量
	-- attData.skillInfluences = {}
	
	--> print("linkAttackerPos:", linkAttackerPos)

	local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
	
	-- skill data
	local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
	if zstring.tonumber(linkAttackerPos) > 0 then
		--> print("skillQuality:", skillQuality)
	end
	local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local skillReleasePosition = dms.atoi(skillElementData, skill_mould.skill_release_position)
	local skillInfluenceId = dms.atoi(skillElementData, skill_mould.health_affect)
	local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)

	local current_attacker = getRole(attacker, attackerPos)
	current_attacker._armature._sed_action = skillElementData
	current_attacker._armature._sie_action = skillInfluenceElementData
	current_attacker._armature._current_skill_influence_start_index = 1
	current_attacker._armature._skill_influence_count = skillInfluenceCount
	current_attacker._armature._attack_move_pos = attackMovePos
	current_attacker._armature._skill_influences = attData.skillInfluences
	current_attacker._armature._invoke = nil

	local roles = {}
	local params = {}
	table.insert(roles, current_attacker)
	
	table.insert(params, skillElementData)
	table.insert(params, skillInfluenceElementData)
	table.insert(params, attackMovePos)
	table.insert(params, (attacker == "0" and __attackers or __defenders))
	table.insert(params, (attacker == "1" and __attackers or __defenders))
	table.insert(params, __attackers)
	table.insert(params, __defenders)
	table.insert(params, "attack_logic_start")

	-- app.load("client.battle.logics.move_logic")
	-- app.load("client.battle.logics.attack_logic")
	state_machine.excute("move_logic_begin_move_all_role", 0, {roles, params})
end
___ic = 0
nextAttack = function(currentArmatureBack)
	-- if ___ic > 10 then
	-- 	iiii = iddd + 1
	-- end
	-- ___ic = ___ic + 1
	--> print("nextAttack：", attack_logic.__need_unlock, attack_logic.__blaster, attack_logic.__need_unlock)
	if attack_logic.__need_unlock == true or attack_logic.__blaster ~= nil then
		attack_logic.__need_unlock = true
		return
	end
	local attackSectionNumber = 0 --攻击段数
	local attackTotalHarm = 0 --多段攻击总伤害
	BattleSceneClass._isSkepBattle = false
	--> print("nextAttack：", 1)
	if executeNextRoundBattleEvent(currentAttackCount + 1) == true then
		return
	end	
	linkAttacker_state = 0
	currentAttackCount = currentAttackCount + 1
	--> print("当前战斗回合数：", currentRoundIndex, currentRoundAttackIndex)
	if nil == _ED.attackData then
		return
	end
	local _roundData = _ED.attackData.roundData[currentRoundIndex]
	if _roundData == nil or currentRoundAttackIndex > _roundData.curAttackCount then
		nextRoundBattle()
		return
	end
	
	if linkAttacker_state == 2 then
		linkAttacker_state = 0
		state_machine.excute("fight_skeep_fighting", 0, "")
		return
	end

	-- 更新战斗的攻击次数
	state_machine.excute("fight_total_attack_count", 0, {currentAttackCount})

	__fit_params = {}
	__fit_roles = {}
	attData = _roundData.roundAttacksData[currentRoundAttackIndex]

	--> print("当前战斗回合攻击数据：", attData, _roundData.curAttackCount)
	local attacker 				= attData.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
	local attackerPos 			= attData.attackerPos 					-- = npos(list)		--出手方位置(1-6)
	local linkAttackerPos 		= attData.linkAttackerPos	            --是否有合体技(>0表示有.且表示合体的对象)
	local attackMovePos			= tonumber(attData.attackMovePos)					-- = npos(list)		--移动到的位置(0-8)
	local skillMouldId			= tonumber(attData.skillMouldId) 					-- = npos(list)	--技能模板id
	local skillInfluenceCount 	= tonumber(attData.skillInfluenceCount) 			-- = tonumber(npos(list))	-- 技能效用数量
	
	--> print("角色进入残兵状态", attacker, attackerPos, linkAttackerPos, attackMovePos, skillMouldId, skillInfluenceCount)
	if 0 == skillInfluenceCount then
		--> print("角色进入残兵状态")
	end

	local cardProgress = attData.cardProgress	--魔法进度
	local cardMouldId = attData.cardMouldId		--魔法模板id
	if cardProgress ~= nil then
		state_machine.excute("fight_ui_update_card_progress", 0, cardProgress)
	end
	if cardMouldId ~= nil and skillInfluenceCount == 0 then
		--> print("直接切换到下一个攻击角色")
		currentRoundAttackIndex = currentRoundAttackIndex + 1
		nextAttack()
		return
	end

	if attacker == "0" then
		local totalHurt = 0
		for j = 1, attData.skillInfluenceCount do
            local _skf = attData.skillInfluences[j]
            if _skf ~= nil then
                for w = 1, _skf.defenderCount do
                    local _def = _skf._defenders[w]
                    if _def ~= nil and (_def.defenderST == "0" or _def.defenderST == "6") then
                        if tonumber(_def.defender) == 1 then
                            totalHurt = totalHurt + tonumber(_def.stValue)
                        end
                    end
                end
            end
        end

        if tonumber(attData.linkAttackerPos) > 0 and attData.fitHeros ~= nil then --如果有合体技能
            for k, fitAttData in pairs(attData.fitHeros) do
                if fitAttData ~= nil then
                    for j = 1, fitAttData.skillInfluenceCount do
                        local _fitSkf = fitAttData.skillInfluences[j]
                        if _fitSkf ~= nil then
                            for w = 1, _fitSkf.defenderCount do
                                local _def = _fitSkf._defenders[w]
                                if _def ~= nil and (_def.defenderST == "0" or _def.defenderST == "6") then
                                    if tonumber(_def.defender) == 1 then
                                        totalHurt = totalHurt + tonumber(_def.stValue)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if totalHurt ~= 0 and attData.calcHurt == nil then
        	attData.calcHurt = true
    		BattleSceneClass.curDamage = BattleSceneClass.curDamage + totalHurt
			state_machine.excute("fight_ui_for_daily_activity_copy_update_fight_damage", 0, {BattleSceneClass.curDamage})				
        end
	end

	-- attData.skillInfluences = {}
	--> print("-出手", attacker, attackerPos)
	local attackerForepartBuffState = tonumber(attData.attackerForepartBuffState)
	local _dindex = 0
	mPosTile = nil
	mPosTile = getRole(tonumber(attacker), tonumber(attackerPos))
	--> print(")))))))))))))))))--------出手BUFF-----)))))))))))))))))))))")
	local count = 1
	local function drawBuff()   
		if count > attackerForepartBuffState then
			return
		end
		for z=count, tonumber(attackerForepartBuffState) do
			local _widget = mPosTile
			local widgetSize = _widget:getContentSize()
			count = count + 1
			local attackerBuffType = attData.attackerForepartBuffType[z] 			-- = npos(list)	-- (有buff影响时传)影响类型(6为中毒,9为灼烧)
			--print(")))))))))))))))))--------出手BUFF attackerBuffType-----)))))))))))))))))))))"..attackerBuffType)
			if  attackerBuffType == "9" or attackerBuffType == "31"  then
				local attackerBuffValue = attData.attackerForepartBuffValue[z] 		-- = npos(list)	-- 影响值
				if attackerBuffType == "31"  then -- 加血
					mPosTile._armature._role._hp = mPosTile._armature._role._hp + zstring.tonumber(attackerBuffValue)
					showRoleHP(mPosTile._armature)
				else							--减血
					mPosTile._armature._role._hp = mPosTile._armature._role._hp - zstring.tonumber(attackerBuffValue)
					showRoleHP(mPosTile._armature)
				end	
				
				if z == tonumber(attackerForepartBuffState) then
					local attackerBuffDeath = attData.attackerForepartBuffDeath
					if attackerBuffDeath == "1" then
						mPosTile._armature._def = nil
						mPosTile._armature._dropCount = attData.attackerForepartBuffDropCount
						executeRoleDeath(mPosTile._armature)
						mPosTile._armature._invoke = attackChangeActionCallback
						iii = ii +1
					end
				end	
				
				local numberFilePath = nil
				local labelAtlas = nil
				if attackerBuffType == "31" then   -- 加血
					numberFilePath = "images/ui/number/jiaxue.png"
					if __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
						or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then
						labelAtlas = cc.LabelAtlas:_create("+"..attackerBuffValue, numberFilePath, 40, 48, 43)   
					else
						labelAtlas = cc.LabelAtlas:_create("+"..attackerBuffValue, numberFilePath, 34, 46, 43)   
					end			
					--> print("持续回血-------------------",count)
				else             							--减血
					numberFilePath = "images/ui/number/xue.png"
		
					if __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
						or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then
						labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 40, 48, 43)   
					else
						labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 34, 46, 43) 
					end
					--> print("燃烧-----------------",count)
				end
				-- local labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 34, 46, 43)   

				labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
				local tempX, tempY  = _widget:getPosition()

				local uiObj = nil
				if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				else
					if attackerBuffType == "6" then
						uiObj = cc.Sprite:createWithSpriteFrameName("images/ui/battle/du.png")
					elseif attackerBuffType == "9" then
						uiObj = cc.Sprite:createWithSpriteFrameName("images/ui/battle/zhuoshao.png")
					elseif attackerBuffType == "31" then
						uiObj = cc.Sprite:createWithSpriteFrameName("images/ui/battle/chixuhuixue.png")
					else
						uiObj = cc.Sprite:createWithSpriteFrameName("images/ui/battle/zhuoshao.png")
					end
				end
			
				labelAtlas:setPosition(cc.p(tempX + widgetSize.width/(2), tempY + widgetSize.height/(2))) 
				_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt) 
				
			
				if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				else
					uiObj:setAnchorPoint(cc.p(0.5, 0.5)) 
					labelAtlas:addChild(uiObj)
					uiObj:setPosition(cc.p(labelAtlas:getContentSize().width/2, uiObj:getContentSize().height 
						+ labelAtlas:getContentSize().height/2))
				end
				
				local array = {}
				-- if _dindex == 1 then
					-- labelAtlas:setVisible(false)
					-- table.insert(array, (cc.DelayTime:create(0.7 * __fight_recorder_action_time_speed)))
					-- table.insert(array, cc.Show:create())
				-- end
				
				_dindex = _dindex + 1
			

				labelAtlas:setScale(0.8)
				seq = cc.Sequence:create(
					cc.ScaleTo:create(0.1 * __fight_recorder_action_time_speed, 2.0),
					cc.ScaleTo:create(0.1 * __fight_recorder_action_time_speed, 1.0),
					cc.DelayTime:create(0.6 * __fight_recorder_action_time_speed),
					cc.CallFunc:create(removeFrameObjectFuncN),
					cc.CallFunc:create(drawBuff)
				)
				-- labelAtlas:runAction(cc.MoveBy:create(0.2 * __fight_recorder_action_time_speed, cc.p(0, 50)))
				labelAtlas:runAction(seq)
				return
			end	
		end
	end	
	
	drawBuff()

	
	-- -- 清除角色的BUFF
	-- if mPosTile._buff ~= nil then
		-- for i, v in pairs(mPosTile._buff) do
			-- if v ~= nil and v._LastsCountTurns ~= nil and v._LastsCountTurns > 0 then
				-- v._LastsCountTurns = v._LastsCountTurns - 1
				-- if v._LastsCountTurns <= 0 then
					-- -- 清除角色的BUFF
					-- mPosTile._buff[i] = nil
				-- end
			-- end
		-- end
	-- end
	
	
	
	
	
	if __lua_project_id == __lua_project_warship_girl_b
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_koone
		then
		if attacker == "0" then
			state_machine.excute("fight_hero_info_ui_show_by_pos", 0, {_roleType = 2, _roleIndex = attackerPos, _visible = false})
		elseif attacker == "1" then
			state_machine.excute("fight_hero_info_ui_show_by_pos", 0, {_roleType = 1, _roleIndex = attackerPos, _visible = false})
		end
	end	

	if __lua_project_id == __lua_project_yugioh then
		-- if mPosTile._spArmature ~= nil then
	 --        mPosTile._spArmature:setVisible(false)
		--     if mPosTile._armature ~= nil then
		--         mPosTile._armature:setVisible(true)
		--     end
	 --    end
	end
	
	local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
	
	-- skill data
	local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
	local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local skillReleasePosition = dms.atoi(skillElementData, skill_mould.skill_release_position)
	local skillInfluenceId = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")[1]
	local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
	
	--> print("技能模块ID:", skillMouldId, "技能效用ID:", skillInfluenceId, "attacker:", attacker, "attackerPos:", attackerPos)

	-- --------------------------------------------------------------------- --
	-- 攻击前的移动准备
	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
	local mx = 0
	local my = 0
	local ex = 0
	local ey = 0
	executeAfterInfluenceCount = 0
	
	local needMove = (attackMovePos ~= 0 and attackMovePos ~= 8) and true or false
	local attackingTime = 0.0
	
	mPosTile = nil
	mpos = nil
	mtime = 0
	if zstring.tonumber(linkAttackerPos) > 0 then
		--> print("skillQuality", skillQuality, needMove, attackMovePos)
		-- attackMovePos = 1
		-- needMove = true
		linkAttacker_state = 1
	end
	if attacker == "0" then
		-- 我方攻击
		state_machine.excute("battle_formation_controller_role_attack", 0, {roleType = 2, roleIndex = attackerPos})
		mPosTile = getRole(0, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, attackerPos))
		-- print("mPosTile::", mPosTile, attackerPos, mPosTile._pos, mPosTile._armature, mPosTile._camp)
		mx, my = mPosTile:getPosition()
		
		if needMove == true then
			if attackMovePos == 1 then
				local mpos2 = getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, 2))
				local epos2 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, 2))
				ex, ey = mPosTile:getPosition()
				local m2x, m2y = mpos2:getPosition()
				local e2x, e2y = epos2:getPosition()
				
				local mmx, mmy = mPosTile:getPosition()
				
				ex = ex + (m2x - ex)
				ey = ey + (e2y - m2y)/2 + (m2y - mmy) - mPosTile:getContentSize().height/2 - 20/CC_CONTENT_SCALE_FACTOR()
				
				mPosTile._mscale = epos2._scale or 1.0
			else
				local ePosTile = getRole(1, attackMovePos-1) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, attackMovePos-1))
				ex, ey = ePosTile:getPosition()
				ey = ey - attackMoveTagetOffsetY - mPosTile:getContentSize().height/2 - 20/CC_CONTENT_SCALE_FACTOR()
			end
		end
	elseif attacker == "1" then
		-- 敌方攻击
		state_machine.excute("battle_formation_controller_role_attack", 0, {roleType = 1, roleIndex = attackerPos})
		
		mPosTile = getRole(1, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, attackerPos))
		mx, my = mPosTile:getPosition()
		
		if needMove == true then
			if attackMovePos == 1 then
				local mpos2 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, 2))
				local epos2 = getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, 2))
				ex, ey = mPosTile:getPosition()
				local m2x, m2y = mpos2:getPosition()
				local e2x, e2y = epos2:getPosition()
				
				local mmx, mmy = mPosTile:getPosition()
				
				ex = ex + (m2x - ex)
				ey = ey + (e2y - m2y)/2 + (m2y - mmy) + mPosTile:getContentSize().height/2 + 20/CC_CONTENT_SCALE_FACTOR()
				
				mPosTile._mscale = epos2._scale or 1.0
			else
				local ePosTile = getRole(0, attackMovePos-1) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, attackMovePos-1))
				ex, ey = ePosTile:getPosition()
				ey = ey + attackMoveTagetOffsetY + mPosTile:getContentSize().height/2 + 20/CC_CONTENT_SCALE_FACTOR()
			end
		end
	else
		mPosTile = getRole(0, attackerPos)
	end
	
	if mPosTile._armature ~= nil then
		mPosTile._armature._sed_action = skillElementData
		mPosTile._armature._sie_action = skillInfluenceElementData
		mPosTile._armature._attackMovePos = attackMovePos

		curr_fit_attacker = attacker
		curr_fit_skillElementData = skillElementData
		curr_fit_skillInfluenceElementData = skillInfluenceElementData
		curr_fit_attackMovePos = attackMovePos
	end

	if needMove == true then
		mpos = cc.p(ex - mx, ey - my)
		mtime = (math.sqrt((math.pow(mpos.x, 2) + math.pow(mpos.y, 2))) / moveFrameSpace) * moveFrameTime
		-- 计算移动时间： mtime
	else
		mpos = nil
		mtime = 0
	end
	
	-- 清除角色的BUFF
	if mPosTile._buff ~= nil then
		for i, v in pairs(mPosTile._buff) do
			if v ~= nil and v._LastsCountTurns ~= nil and v._LastsCountTurns > 0 and (i == 5 or i == 8) then
				v._LastsCountTurns = v._LastsCountTurns - 1
				if v._LastsCountTurns <= 0 then
					deleteEffectFile(v)
					-- 清除角色的BUFF
					mPosTile._buff[i] = nil
				end
			end
		end
	end
		
	if zstring.tonumber(linkAttackerPos) > 0 then
	else
		-- 眩晕
		if skillInfluenceCount <= 0 then
			resetArmatureData(mPosTile._armature)
			executeAttackerBuff()
			return
		end
	end

	executeHeroMoveToTargetFit = function()
		if attData.fitHeros ~= nil and #attData.fitHeros > 0 then
			if __fit_roles ~= nil and #__fit_roles > 0 then
				return true
			end
			return false
		end
		return false
	end

	
	executeHeroMoveToTarget = function()
		-- 清理对象缓存信息
		resetArmatureData(mPosTile._armature)
		
		-- 角色死亡
		if mPosTile._armature == nil then
			nextAttack()
			return
		end
		
		-- if attackMovePos == 0 or attackMovePos == 8 then
		-- 	-- 在原地进行攻击
		-- 	if skillProperty == 0 then
		-- 		executeRemoteAttackBegan(mPosTile._armature)
		-- 	elseif skillProperty == 1 then
		-- 		executeRemoteSkillBegan(mPosTile._armature)
		-- 	end
		-- 	if attackMovePos == 8 then
		-- 		mPosTile:setVisible(false)
		-- 	end
		-- else
		-- 	-- 处理移动逻辑-初始化移动
		-- 	local armature = mPosTile._armature
		-- 	armature._invoke = attackChangeActionCallback
			
		-- 	if skillProperty == 0 then
		-- 		executeMoveMeleeAttackBegan(mPosTile._armature)
		-- 	elseif skillProperty == 1 then
		-- 		executeMoveMeleeSkillBegan(mPosTile._armature)
		-- 	end
			
		-- end
		if executeHeroMoveToTargetFit() == false then
			-- print("attackMovePos:", attackMovePos)
			if attackMovePos == 0 or attackMovePos == 8 then
				changeActtackToAttackBegan(mPosTile._armature)
				if attackMovePos == 8 then
					mPosTile:setVisible(false)
				end
			else
				changeActtackToAttackMoving(mPosTile._armature)
			end
		else
			--> print("进入合体技能")
		end
	end
	
	executeHeroMoveToOriginTarget = function()
		--> print("处理返回逻辑)))attackTargetCount)", attackTargetCount)
		-- 处理返回逻辑
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		else
			if attackTargetCount > 0 then
				attackTargetCount = attackTargetCount - 1
				if attackTargetCount > 0 then
					return
				end
			end
		end
		--> print("处理返回逻辑)))executeAfterInfluenceCount)", executeAfterInfluenceCount)
		if executeAfterInfluenceCount > 0 then
			-- 重新进入
			executeAfterAttacking()
			return
		end
		
		--> print("处理返回逻辑)))currentSkillInfluenceStartIndex)", currentSkillInfluenceStartIndex, skillInfluenceCount)
		-- local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
		if (currentSkillInfluenceStartIndex < skillInfluenceCount) then
			currentSkillInfluenceStartIndex = currentSkillInfluenceStartIndex + 1
			executeAttacking()
			--executeAttack()
			return
		end
		
		-- if attackMovePos == 0 or attackMovePos == 8 then
		-- 	-- 处理在原地进行攻击后的返回逻辑
		-- 	if skillProperty == 0 then	-- 物理远程攻击
		-- 		executeRemoteAttackEnd(mPosTile._armature)
		-- 	elseif skillProperty == 1 then	-- 技能远程攻击
		-- 		executeRemoteSkillEnd(mPosTile._armature)
		-- 	end
		-- 	if attackMovePos == 8 then
		-- 		mPosTile:setVisible(true)
		-- 	end
		-- else
		-- 	-- 处理攻击后的返回逻辑
		-- 	if skillProperty == 0 then	-- 物理近身攻击
		-- 		executeMeleeAttackEnd(mPosTile._armature)
		-- 	elseif skillProperty == 1 then	-- 技能近身攻击
		-- 		executeMeleeSkillEnd(mPosTile._armature)
		-- 	end
		-- end
		--> print("处理返回逻辑)))changeActtackToAttackAfter)", mPosTile._armature)
		if mPosTile._armature ~= nil then
			changeActtackToAttackAfter(mPosTile._armature)
		end
		if attackMovePos == 8 then
			mPosTile:setVisible(true)
		end
	end
	
	--[[
		0基于施放者与承受者的路径（根据目标数量绘制光效）
		1基于施放者位置（只绘制一个光效）
		2基于承受者位置（根据目标数量绘制光效）
		3基于对方阵营中心（只绘制一个光效）
		4基于攻击范围无视存活数量（根据目标数量绘制光效）
		5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
		6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
	--]]
	executeAttack = function()
		-- 执行被攻击
		for j = currentSkillInfluenceStartIndex, skillInfluenceCount do
			-- local _skf = {}
			local _skf = attData.skillInfluences[j]
			local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
			local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
			
			mPosTile._armature._skf = _skf
			resetArmatureData(mPosTile._armature)
			
			-- 加载技能效用
			local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
			local skillCategory = dms.atoi(skillInfluenceElementData, skill_influence.skill_category)
			local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
			
			mPosTile._armature._sie = skillInfluenceElementData
			-- 启动技能前段
			executeEffectSkillBegan(mPosTile._armature)
			if true then
				return
			end
			
			if lightingEffectDrawMethod == 1 then
			elseif lightingEffectDrawMethod == 3 then
				
			end
			
			for w = 1, _skf.defenderCount do
				local _def = _skf._defenders[w]
				local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
				local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
				local restrainState = _def.restrainState 			-- = npos(list) 		--相克状态(0,无克制 1,有克制,2被克制)
				local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
				local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
				local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
				local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
				local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
											
				local rPad = getRolePad(defender, defenderPos)
				--rPad._armature._def = _def
				--rPad._armature._sie = skillInfluenceElementData
				
				resetArmatureData(rPad._armature)
				
				if _def.defAState == "1" then
					local dropCount = _def.dropCount 	-- = npos(list)		--(死亡时传)掉落卡片数量
				elseif _def.defAState == "2" then 
					rPad._armature._isReact = true
					--[[
					local fightBackFlag = _def.fightBackFlag 		-- = npos(list)	-- (反击时传)反击承受方的标识 
					local fightBackPos = _def.fightBackPos 			-- = npos(list)	-- 反击承受方的位置 
					local fightBackSkf = _def.fightBackSkf 			-- = npos(list)	-- 反击承受方的作用效果 
					local fightBackValue = _def.fightBackValue 		-- = npos(list)	-- 反击承受方的作用值 
					local fightBackRound = _def.fightBackRound 		-- = npos(list)	-- 反击承受方的持续回合
					--]]
				end
			end			
			break
		end
	end
	
	local function executeAttackInfluence(skf)
		-- 执行被攻击中段
		local attackInfluencedCount = 0
		-- for j = currSkillInfluenceStartIndex, currSkillInfluenceCount do
			local _skf = skf --attData.skillInfluences[j]
			local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
			local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
			local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
			local attackerPos = _skf.attackerPos			-- 效用发动者位置
			local currPosTile = nil
			if attackerType == "1" then
				local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
				currPosTile = getRole(1, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
			else
				currPosTile = getRole(0, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
			end
			currPosTile._armature._attackTargetCount = 0
			local _tcamp = tonumber(currPosTile._camp)
				
			local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
			
			for w = 1, _skf.defenderCount do
				local _def = _skf._defenders[w]
				local defender = _def.defender
				local defenderPos = tonumber(_def.defenderPos)						
				local rPad = getRolePad(defender, defenderPos)
				resetArmatureData(rPad._armature)
			end
			
			if currPosTile == nil then
				return 2
			end
			if currPosTile._armature == nil  then
				currPosTile._armature = {}
				currPosTile._armature._posTile = currPosTile
			end
			
			
			-- 加载技能效用
			local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
			local skillCategory = dms.atoi(skillInfluenceElementData, skill_influence.skill_category)
			local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
			local attackSection = dms.atoi(skillInfluenceElementData, skill_influence.attack_section)
			local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, influenceType, skill_influence.posterior_lighting_effect_id)	 -- dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
			local is_vibrate = dms.atoi(skillInfluenceElementData, skill_influence.is_vibrate)
	
			_skf._attackSection = attackSection
			currPosTile._armature._skf = _skf
			currPosTile._armature._sie = skillInfluenceElementData
			currPosTile._armature._is_vibrate = is_vibrate
			local weapon = currPosTile._armature._weapon
			if nil == weapon then
				weapon = currPosTile._armature
			end
			weapon._targets = {}
			weapon.__attack_count = 0	
			--[[
				0基于施放者与承受者的路径（根据目标数量绘制光效）
				1基于施放者位置（只绘制一个光效）
				2基于承受者位置（根据目标数量绘制光效）
				3基于对方阵营中心（只绘制一个光效）
				4基于攻击范围无视存活数量（根据目标数量绘制光效）
				5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
				6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
			--]]
	
			local executeDrawEffect = true
			-- print("lightingEffectDrawMethod:", lightingEffectDrawMethod)
			if lightingEffectDrawMethod == 1 then
				attackTargetCount = 1
				executeEffectSkilling1(currPosTile._armature)
				executeDrawEffect = false
			elseif lightingEffectDrawMethod == 2 then
				-- executeEffectSkilling2(currPosTile._armature)
				-- executeDrawEffect = false
				_skf.attTarList = nil
			elseif lightingEffectDrawMethod == 3 then
				attackTargetCount = 1
				executeEffectSkilling3(currPosTile._armature)
				executeDrawEffect = false
			elseif lightingEffectDrawMethod == 4 then
				executeEffectSkilling4(currPosTile._armature)
			elseif lightingEffectDrawMethod == 5 then
				-- executeEffectSkilling5(currPosTile._armature)
				_skf.attTarList = nil
			elseif lightingEffectDrawMethod == 6 then
				-- executeEffectSkilling6(currPosTile._armature)
				_skf.attTarList = nil
			elseif lightingEffectDrawMethod == 0 then
				_skf.attTarList = nil
				
			end
			
			local erole = {}
			local ctrEfeect = {0, 0, 0, 0, 0, 0}
			for w = 1, _skf.defenderCount do
				local _def = _skf._defenders[w]
				local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
				local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
				local restrainState = _def.restrainState 			-- = npos(list) 		--相克状态(0,无克制 1,有克制,2被克制)
				local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
				local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
				local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
				local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
				local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
				
				_def._attackCount = attackSection
				_def._hurtCount = 1

				if _def.ctrEfeect[3] == "1" then
					ctrEfeect[3] = "1"
				elseif _def.ctrEfeect[5] == "1" then
					ctrEfeect[5] = "1"
				end

				local rPad = getRolePad(defender, defenderPos)
				if rPad._armature ~= nil then
					_def._attackSection = attackSection

					rPad._armature._def = _def
					rPad._armature._sie = skillInfluenceElementData
						
					if rPad._armature._defs == nil then
						rPad._armature._defs = {}
					end
					
					
					rPad._armature._base = currPosTile._armature
					
					if _def.defenderST == "6" then
						-- 6为中毒
					elseif  _def.defenderST == "9" then
						-- 9为灼烧
					end
					
					if defenderST == "38" then
						rPad:setVisible(true)
						rPad._armature:setVisible(true)
						rPad._armature._role._hp = tonumber(_def.stValue)
						rPad._armature._isDeath = false
						if rPad._armature._heroInfoWidget ~= nil then
							rPad._armature._heroInfoWidget:controlLife(false, 99)
							rPad._armature._heroInfoWidget:showControl(false)
						end
						showRoleHP(rPad._armature)
					end
					--[[
						defenderPos, stValue))
					--]]
					if defenderST == "0" or
						defenderST == "6"
						then
						if tonumber(_def.defender) == 1 then
							BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(_def.stValue)
							state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
						end
					end

					-- 根据攻击的段数，重新赋伤害
					if tonumber(_def.stValue) > 0 and attackSection > 0 then
						--_def.stValue = ""..string.format("%d", math.floor(tonumber(_def.stValue)/attackSection))
						_skf._defenders[w].subValue = ""..string.format("%d", math.floor(tonumber(_def.stValue)/attackSection))
						if defenderST == "0" or defenderST == "6" then
							attackSectionNumber = attackSection
							attackTotalHarm = attackTotalHarm + tonumber(_def.stValue)
						end
					end
					
					if rPad ~= currPosTile or _def.stVisible == "1" then
						rPad._armature._defs[table.getn(rPad._armature._defs) + 1] = _def
						if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
							table.insert(erole, rPad._armature)
						else
							erole[""..defender..">"..defenderPos] = rPad._armature
						end
					else
						local drawString = _def.stValue
						if defenderST == "0" or
							defenderST == "6"
							then
							if tonumber(_def.defender) == 1 then
								BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(drawString)
								state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
							end
							drawString = "-"..drawString
						elseif defenderST == "1" or 
							defenderST == "9" 
							then
							drawString = "+"..drawString
						end
							
						if (defenderST == "2" or defenderST == "3") and (rPad._armature~= nil and rPad._armature._role ~= nil) then
							if defState ~= "1" and defState ~= "5" then
								rPad._armature._role._sp = rPad._armature._role._sp + ((defenderST == "2" and 1 or -1) * tonumber(_def.stValue))
								if rPad._armature._role._sp < 0 then
									rPad._armature._role._sp = 0
								end
								showRoleSP(rPad._armature)
							end
							
						elseif (defenderST == "0" or defenderST == "1" or defenderST == "6" or defenderST == "9") then
							rPad._armature._role._hp = rPad._armature._role._hp + tonumber(drawString)
							showRoleHP(rPad._armature)
						end
					end				
					
					if _skf.attTarList ~= nil then
						for a, t in pairs(_skf.attTarList) do
							if t == defenderPos then
								-- 删除攻击节点"
								_skf.attTarList[a] = nil
							end
						end
					end
					
					if _def.defAState == "1" then
						local dropCount = _def.dropCount 	-- = npos(list)		--(死亡时传)掉落卡片数量
					elseif _def.defAState == "2" then 
						rPad._armature._isReact = true
						--[[
						local fightBackFlag = _def.fightBackFlag 				-- = npos(list)	-- (反击时传)反击承受方的标识 
						local fightBackPos = _def.fightBackPos 					-- = npos(list)	-- 反击承受方的位置 
						local fightBackSkf = _def.fightBackSkf 					-- = npos(list)	-- 反击承受方的作用效果 
						local fightBackValue = _def.fightBackValue 				-- = npos(list)	-- 反击承受方的作用值 
						local fightBackRound = _def.fightBackRound 				-- = npos(list)	-- 反击承受方的持续回合
						local fightBackDefState = _def.fightBackDefState		-- = npos(list)	-- 反击承受方的承受状态 
						local fightBackLiveState = _def.fightBackLiveState 		-- = npos(list)--反击承受方生存状态 (0:存活 1:死亡)
						if _def.fightBackDefState == "1" then
							local fightBackDropCardCount = _def.fightBackDropCardCount -- = npos(list)			-- (死亡时传)掉落卡片数量
						end
						if currPosTile._armature._reactor == nil then
							currPosTile._armature._reactor = rPad._armature
							currPosTile._armature._defr = _def
						end
						--]]
					end
				else
					--> print("攻击的承受方不存在！", defender, defenderPos)
				end
			end

			if ctrEfeect[3] == "1" then
				local spriteBg = cc.Sprite:create("images/ui/icon/icon_100.png")
				local sprite = cc.Sprite:create("images/ui/props/props_6019.png")
				if _tcamp == 1 then
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 - 42)) 
					-- spriteBg:setPosition(cc.p(32, 42)) 
					spriteBg:setPosition(cc.p(-32, -42)) 
					if __lua_project_id == __lua_project_pacific_rim then
						spriteBg:setScale(0.4)
					else
						spriteBg:setScaleX(0.4)
						spriteBg:setScaleY(-0.4)
					end
				else
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 + 42)) 
					spriteBg:setPosition(cc.p(-32, -42)) 
					spriteBg:setScale(0.4)
				end
				-- _widget:getParent():addChild(sprite, 100)
				local size = spriteBg:getContentSize()
				sprite:setPosition(cc.p(size.width / 2, size.height / 2))
				spriteBg:addChild(sprite)
				currPosTile._armature:addChild(spriteBg, 100)
				sprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0)))
				spriteBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function ( sender )
					sender:removeFromParent(true)
				end)))
			elseif ctrEfeect[5] == "1" then
				local spriteBg = cc.Sprite:create("images/ui/icon/icon_100.png")
				local sprite = cc.Sprite:create("images/ui/props/props_6021.png")
				if _tcamp == 1 then
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 - 42)) 
					-- spriteBg:setPosition(cc.p(32, 42)) 
					spriteBg:setPosition(cc.p(-32, -42)) 
					if __lua_project_id == __lua_project_pacific_rim then
						spriteBg:setScale(0.4)
					else
						spriteBg:setScaleX(0.4)
						spriteBg:setScaleY(-0.4)
					end
				else
					-- sprite:setPosition(cc.p(tempX + (widgetSize.width) / 2 + 32, tempY + widgetSize.height / 2.0 + 42)) 
					spriteBg:setPosition(cc.p(-32, -42)) 
					spriteBg:setScale(0.4)
				end
				-- _widget:getParent():addChild(sprite, 100)
				local size = spriteBg:getContentSize()
				sprite:setPosition(cc.p(size.width / 2, size.height / 2))
				spriteBg:addChild(sprite)
				currPosTile._armature:addChild(spriteBg, 100)
				sprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0)))
				spriteBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function ( sender )
					sender:removeFromParent(true)
				end)))
			end	

			local roleCount = 0
			if executeDrawEffect == true then
				-- print("准备绘制承受光效.", lightingEffectDrawMethod)
				for i, v in pairs(erole) do
					if lightingEffectDrawMethod == 7 then
						executeEffectSkilling7(currPosTile._armature,v)
					else
						executeEffectSkilling(v, currPosTile)
					end
					roleCount = roleCount + 1
				end
				attackTargetCount = roleCount
				if __fit_roles ~= nil and #__fit_roles > 0 then
					currPosTile._armature._attackTargetCount = attackTargetCount
				end
				-- print("受击目标数量:", roleCount, _skf.attTarList, lightingEffectDrawMethod)
				if roleCount <= 0 then
					executeHeroMoveToOriginTarget()
				elseif _skf.attTarList ~= nil then
					if lightingEffectDrawMethod ~= 7 then
						local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
						for a, t in pairs(_skf.attTarList) do
							local cPosTile = nil
							if attacker == "0" then
								cPosTile = getRole(1, t) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, t))
							elseif attacker == "1" then
								cPosTile = getRole(0, t) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, t))
							end
							if cPosTile ~= nil then
								-- 无视攻击位置
								local effect = createEffect(cPosTile, posterior_lighting_effect_id, (tonumber(currPosTile._camp) + 1) % 2)
								effect._invoke = deleteEffectFile
								effect._LastsCountTurns = nil
							end
						end
					end
				end
			end
			--break
		-- end
	end
	
	executeAttacking = function()
		if __fit_roles ~= nil and #__fit_roles > 0 then
			local sync = __fit_params[_enum_params_index.param_sync]
			--> print("合体技能发动，同步的状态：", sync)
			if sync == true then
				local eCount = __fit_params[_enum_params_index.param_execute_count]
				if eCount < #__fit_roles then
					eCount = eCount + 1
					__fit_params[_enum_params_index.param_execute_count] = eCount
				end
				if eCount >= #__fit_roles then
					__fit_params[_enum_params_index.param_execute_count] = 0
					local current_skill_influence_start_index = __fit_params[_enum_params_index.param_skill_influence_index]
					local is_over = true
					local nCount = 0
					for i, v in pairs(__fit_roles) do
						local fitAttData = attData.fitHeros[i]
						if current_skill_influence_start_index <= fitAttData.skillInfluenceCount then
							is_over = false
							local recal = executeAttackInfluence(fitAttData.skillInfluences[current_skill_influence_start_index])
							if recal == 2 then
								nCount = nCount + 1
								eCount = eCount + 1
								__fit_params[_enum_params_index.param_execute_count] = eCount
							end
						else
							eCount = eCount + 1
							__fit_params[_enum_params_index.param_execute_count] = eCount
						end
					end
					__fit_params[_enum_params_index.param_skill_influence_index] = current_skill_influence_start_index + 1
					if is_over == true then
						--> print("合体技能攻击完毕-角色返回！")
						attackTargetCount = 0
						executeHeroMoveToOriginTarget()
					elseif nCount == #__fit_roles then
						executeAttacking()
					end
				else
					-- if currentRoundIndex >= _ED.attackData.roundCount then
					-- 	executeAttacking()
					-- end
				end
			else
				local attackCount = __fit_params[_enum_params_index.param_attack_count]
				local attackerCount = #__fit_roles
				if attackCount < attackerCount then
					attackCount = attackCount + 1
					-- if attackCount == 2 then
					-- 	attackCount = attackCounta + 1
					-- end
					__fit_params[_enum_params_index.param_attack_count] = attackCount
					local fitAttData = attData.fitHeros[attackCount]
					local current_skill_influence_start_index = __fit_params[_enum_params_index.param_skill_influence_index]
					if current_skill_influence_start_index <= fitAttData.skillInfluenceCount then
						local recal = executeAttackInfluence(fitAttData.skillInfluences[current_skill_influence_start_index])
						if recal == 2 then
							attackCount = attackCount + 1
							__fit_params[_enum_params_index.param_attack_count] = attackCount
							executeAttacking()
						end
					else
						attackCount = attackCount + 1
						__fit_params[_enum_params_index.param_attack_count] = attackCount
						attackTargetCount = 0
						executeHeroMoveToOriginTarget()
					end
				else
					attackCount = 0
					__fit_params[_enum_params_index.param_attack_count] = attackCount
					local current_skill_influence_start_index = __fit_params[_enum_params_index.param_skill_influence_index]
					__fit_params[_enum_params_index.param_skill_influence_index] = current_skill_influence_start_index + 1

					-- if currentRoundIndex >= _ED.attackData.roundCount then
					-- 	executeAttacking()
					-- end
				end
			end
		else
			-- executeAttackInfluence(mPosTile, currentSkillInfluenceStartIndex, skillInfluenceCount)
			if currentSkillInfluenceStartIndex <= skillInfluenceCount then
				local recal = executeAttackInfluence(attData.skillInfluences[currentSkillInfluenceStartIndex])
				if recal == 2 or attData.cardMouldId ~= nil then
					currentSkillInfluenceStartIndex = currentSkillInfluenceStartIndex + 1
					executeAttacking()
				end
			else
				executeHeroMoveToOriginTarget()
			end
		end
	end
	
	startAfterAttack = function()
		if executeAfterInfluenceCount < attData.skillAfterInfluenceCount then
			executeAfterInfluenceCount = executeAfterInfluenceCount + 1
			
			local _skf = attData.skillAfterInfluences[executeAfterInfluenceCount]
			local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
			
			local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
			local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
			local attackerPos = _skf.attackerPos			-- 效用发动者位置
			local currPosTile = nil
			if attackerType == "1" then
				local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
				currPosTile = getRole(1, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
			else
				currPosTile = getRole(0, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
			end
			
			local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
			
			resetArmatureData(currPosTile._armature)
			
			if currPosTile._armature == nil then
				executeAfterInfluenceCount = attData.skillAfterInfluenceCount
				nextAttack()
			else
				currPosTile._armature._isReact = true
				currPosTile._armature._skf = _skf
					
				executeRemoteSkillBegan(currPosTile._armature)
			end
		else
			executeAfterAttack()
		end
	end
	
	executeAfterAttack = function()
		if executeAfterInfluenceCount <= attData.skillAfterInfluenceCount then
			-- 执行被攻击
			for j = executeAfterInfluenceCount, attData.skillAfterInfluenceCount do
				local _skf = attData.skillAfterInfluences[j]
				local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
				
				local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
				local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
				local attackerPos = _skf.attackerPos			-- 效用发动者位置
				local currPosTile = nil
				if attackerType == "1" then
					local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
					currPosTile = getRole(1, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
				else
					currPosTile = getRole(0, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
				end
				
				local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
				
				currPosTile._armature._skf = _skf
				resetArmatureData(currPosTile._armature)
				
				-- 加载技能效用
				local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
				local skillCategory = dms.atoi(skillInfluenceElementData, skill_influence.skill_category)
				local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
				local attackSection = dms.atoi(skillInfluenceElementData, skill_influence.attack_section)
				

				_skf._attackSection = attackSection
			
				
				currPosTile._armature._sie = skillInfluenceElementData
				-- 启动技能前段
				executeEffectSkillBegan(currPosTile._armature)
				if true then
					return
				end
				
				if lightingEffectDrawMethod == 1 then
				elseif lightingEffectDrawMethod == 3 then
					
				end
				
				for w = 1, _skf.defenderCount do
					local _def = _skf._defenders[w]
					local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
					local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
					local restrainState = _def.restrainState 			-- = npos(list) 		--相克状态(0,无克制 1,有克制,2被克制)
					local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
					local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
					local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
					local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
					local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
					
					local rPad = getRolePad(defender, defenderPos)
					
					_def._attackSection = attackSection
					
					resetArmatureData(rPad._armature)
					
					if _def.defAState == "1" then
						local dropCount = _def.dropCount 	-- = npos(list)		--(死亡时传)掉落卡片数量
					elseif _def.defAState == "2" then 
						rPad._armature._isReact = true
					--[[
						local fightBackFlag = _def.fightBackFlag 		-- = npos(list)	-- (反击时传)反击承受方的标识 
						local fightBackPos = _def.fightBackPos 			-- = npos(list)	-- 反击承受方的位置 
						local fightBackSkf = _def.fightBackSkf 			-- = npos(list)	-- 反击承受方的作用效果 
						local fightBackValue = _def.fightBackValue 		-- = npos(list)	-- 反击承受方的作用值 
						local fightBackRound = _def.fightBackRound 		-- = npos(list)	-- 反击承受方的持续回合
						--]]
					end
				end			
				break
			end
		else
			executeAfterAttacking()
		end
	end
	
	executeAfterAttacking = function()
		if executeAfterInfluenceCount > 0 and executeAfterInfluenceCount <= attData.skillAfterInfluenceCount then
			-- 处理后段效用逻辑
			-- 格挡反击-处理后段效用逻辑
			local recal = executeAttackInfluence(attData.skillAfterInfluences[executeAfterInfluenceCount])
			executeAfterInfluenceCount = executeAfterInfluenceCount + 1
			if recal == 2 then
				executeAfterAttacking()
			end
		else
			-- 没有后段的效用直接处理逻辑
			-- 格挡反击结束, 找查下一攻击角色，或进入下一回合
			nextAttack()
		end
	end
	
	local executeAttackEnd = function()
		if executeAfterInfluenceCount < attData.skillAfterInfluenceCount and executeAfterInfluenceCount == 0 then
			-- 执行被攻击后段-处理格挡反击
			--> print("执行被攻击后段-处理格挡反击")
			startAfterAttack()
		else
			-- 没有格挡反击, 找查下一攻击角色，或进入下一回合
			--> print("没有格挡反击, 找查下一攻击角色，或进入下一回合")
			nextAttack()
		end
	end

	executeAttackerBuff = function()
		if __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_koone
			then
			state_machine.excute("fight_hero_info_ui_show", 0, {_datas = {_type = 0, _visible = attack_logic.__hero_ui_visible}})
		end
		
		-- state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
		state_machine.excute("draw_hit_damage_exit", 0, 0)
		-- 处理当前攻击者的BUFF信息，然后进入到下一个攻击角色进行攻击！
		-- local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
		
		local attackerBuffState = attData.attackerBuffState 			-- = npos(list)	-- 出手方是否有buff影响(0:没有 1:有)
		local _dindex = 0
		for z=1, tonumber(attackerBuffState) do
			local _widget = mPosTile
			local widgetSize = _widget:getContentSize()
			
			local attackerBuffType = attData.attackerBuffType[z] 			-- = npos(list)	-- (有buff影响时传)影响类型(6为中毒,9为灼烧)
			local attackerBuffValue = attData.attackerBuffValue[z] 		-- = npos(list)	-- 影响值
			
			mPosTile._armature._role._hp = mPosTile._armature._role._hp - tonumber(attackerBuffValue)
			showRoleHP(mPosTile._armature)
			
			if z == tonumber(attackerBuffState) then
				local attackerBuffDeath = attData.attackerBuffDeath
				if attackerBuffDeath == "1" then
					mPosTile._armature._def = nil
					mPosTile._armature._dropCount = attData.attackerBuffDropCount
					executeRoleDeath(mPosTile._armature)
				end
			end	
			
			local numberFilePath = "images/ui/number/xue.png"
			local labelAtlas = nil
			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				then
				labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 40, 48, 43)   
			else
				labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 34, 46, 43)   
			end
			-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
			labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
			local tempX, tempY  = _widget:getPosition()
			-- 21增加攻击
			-- 22降低攻击
			-- 23增加防御
			-- 24降低防御
			-- 25受到的伤害增加
			-- 26受到的伤害降低
			-- 27增加暴击
			-- 28增加抗暴
			-- 29增加命中
			-- 30增加闪避
			-- 31持续回血

			-- -------------------------------------------
			-- 闪避
			-- 暴击
			-- 免疫：用于敌方中了某个DEBUFF，发现他免疫此DEBUFF时飘出

			-- 技能类型：
			-- 1  恢复+（加血具体数值）
			-- 2  怒气+（绿）会显示具体数值
			-- 3  怒气-（红）会显示具体数值
			-- 5  眩晕：无法行动
			-- 6  中毒：行动前扣血，死亡的话就不再行动
			-- 9  灼烧：行动前扣血，死亡的话就不再行动
			-- 12 铁壁：无敌
			-- 21 攻击↑
			-- 22 攻击↓
			-- 23 防御↑
			-- 24 防御↓
			-- 25 脆弱：受到伤害增加
			-- 26 铁壁：受到伤害降低
			-- 27 暴击↑
			-- 28 抗暴↑
			-- 29 命中↑
			-- 30 闪避↑
			-- 33 鼓舞：自身伤害提高
			-- -------------------------------------------





			local uiObj = nil
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			else
				if attackerBuffType == "6" then
					uiObj = cc.Sprite:createWithSpriteFrameName("images/ui/battle/du.png")
				elseif attackerBuffType == "9" then
					uiObj = cc.Sprite:createWithSpriteFrameName("images/ui/battle/zhuoshao.png")
				else
					uiObj = cc.Sprite:createWithSpriteFrameName("images/ui/battle/zhuoshao.png")
				end
			end
			
			labelAtlas:setPosition(cc.p(tempX + widgetSize.width/2, tempY + widgetSize.height/2)) 
			_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt) 
			
			-- animationChangeToAction(mPosTile._armature, changeToAction, animation_standby)
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			else
				uiObj:setAnchorPoint(cc.p(0.5, 0.5)) 
				labelAtlas:addChild(uiObj)
				uiObj:setPosition(cc.p(labelAtlas:getContentSize().width/2, uiObj:getContentSize().height 
					+ labelAtlas:getContentSize().height/2))
			end
			
			local array = {}
			if _dindex == 1 then
				labelAtlas:setVisible(false)
				table.insert(array, (cc.DelayTime:create(0.7 * __fight_recorder_action_time_speed)))
				table.insert(array, cc.Show:create())
			end
			
			_dindex = _dindex + 1
		
			-- table.insert(array, cc.ScaleTo:create(3.5/60.0 * __fight_recorder_action_time_speed, 2))
			-- table.insert(array, cc.ScaleTo:create(3.5/60.0 * __fight_recorder_action_time_speed, 1.0))
			-- table.insert(array, cc.DelayTime:create(30.0/60.0 * __fight_recorder_action_time_speed))
			-- table.insert(array, cc.ScaleTo:create(5.0/60.0 * __fight_recorder_action_time_speed, 0.2))
			-- table.insert(array, cc.CallFunc:create(removeFrameObjectFuncN))
			-- local seq = cc.Sequence:create(array)
			-- labelAtlas:runAction(seq)

			labelAtlas:setScale(0.8)
			seq = cc.Sequence:create(
				cc.ScaleTo:create(0.1 * __fight_recorder_action_time_speed, 2.0),
				cc.ScaleTo:create(0.1 * __fight_recorder_action_time_speed, 1.0),
				cc.DelayTime:create(0.6 * __fight_recorder_action_time_speed),
				cc.CallFunc:create(removeFrameObjectFuncN)
			)
			labelAtlas:runAction(cc.MoveBy:create(0.2 * __fight_recorder_action_time_speed, cc.p(0, 50)))

		end
		
		executeAfterInfluenceCount = 0
		currentRoundAttackIndex = currentRoundAttackIndex + 1
		--skillInfluenceStartIndex = 1
		currentSkillInfluenceStartIndex = 1
		
		-- 清除角色的BUFF
		if mPosTile._buff ~= nil then
			for i, v in pairs(mPosTile._buff) do
				if v ~= nil and v._LastsCountTurns ~= nil and v._LastsCountTurns > 0 then
					v._LastsCountTurns = v._LastsCountTurns - 1
					if v._LastsCountTurns <= 0 then
						mPosTile._buff[i] = nil
					end
				end
			end
		end
		
		
		executeAttackEnd()
		--绘制多段攻击总伤害
		if attackTotalHarm > 0 and attackSectionNumber > 1 then
			-- fwin:close(fwin:find("DrawHitDamageClass"))
   -- 	 		fwin:open(DrawHitDamage:new():init(attackSectionNumber, attackTotalHarm), fwin._view)

			--> print("绘制连击的总伤害，目前界面文件有问题，取消了绘制。")
			-- fwin:close(BattleSceneClass._attackTotalHarm)
			
			-- local csbInjury = csb.createNode("battle/injury_settlement.csb")
			-- BattleSceneClass._attackTotalHarm = csbInjury
			-- BattleSceneClass._attackTotalHarm.root = csbInjury:getChildByName("root")
			
			-- fwin:open(BattleSceneClass._attackTotalHarm, fwin._dialog)
			
			-- ccui.Helper:seekWidgetByName(BattleSceneClass._attackTotalHarm.root, "AtlasLabel_lianji"):setString(""..attackSectionNumber)
			-- ccui.Helper:seekWidgetByName(BattleSceneClass._attackTotalHarm.root, "AtlasLabel_xue"):setString(""..attackTotalHarm)
			
			-- local action = csb.createTimeline("battle/injury_settlement.csb")
			-- BattleSceneClass._shakeAction = action
			-- -- csbLogo:runAction(action)
			-- -- action:gotoFrameAndPlay(0, action:getDuration(), false)
			-- -- action:setTimeSpeed(0.1*__fight_recorder_action_time_speed)
			
			-- -- local action1 = ActionManager:shareManager():getActionByName("injury_settlement.json","Animation0")
			-- -- action1:setUnitTime(0.1*__fight_recorder_action_time_speed)
			-- -- action1:play()
			-- -- action1:setLoop(false)
			-- BattleSceneClass._shakeAction:gotoFrameAndPlay(0, BattleSceneClass._shakeAction:getDuration(), false)
			
			-- -- action:play("combo_damage")
			-- -- frame event name :combo_damage_over
		end
		attackTotalHarm = 0
		attackSectionNumber = 0
	end
	
	if cardMouldId ~= nil then
		local cardData = dms.element(dms["magic_trap_card_info"], cardMouldId)
        local card_type = dms.atos(cardData, magic_trap_card_info.card_type)

        if tonumber(card_type) == 1 then
			state_machine.excute("fight_map_play_card_animation", 0, cardMouldId)
        end
        
        local pic_index = dms.atos(cardData, magic_trap_card_info.pic)
        local armature = ccs.Armature:create("effect_magic")
        local card_name = ccs.Skin:create(string.format("images/face/skill_head/skill_name_%s.png", pic_index))
        armature:getBone("fit_name"):addDisplay(card_name, 0)

        local card_skill = ccs.Skin:create(string.format("images/ui/props/props_%d.png", pic_index))
        armature:getBone("fit_skill"):addDisplay(card_skill, 0)

        local card_bg = ""
        local card_tip = ""
        if tonumber(card_type) == 0 then
  			card_bg = ccs.Skin:create("images/ui/battle/card_magic.png")
			card_tip = ccs.Skin:create("images/ui/battle/card_tip_magic.png")
  		else
  			card_bg = ccs.Skin:create("images/ui/battle/card_trap.png")
  			card_tip = ccs.Skin:create("images/ui/battle/card_tip_trap.png")
  		end
        armature:getBone("fit_tip"):addDisplay(card_tip, 0)
        armature:getBone("fit_card"):addDisplay(card_bg, 0)

        attData.cardMouldId = nil
		armature:getAnimation():playWithIndex(0)
		local size = cc.size(app.screenSize.width / app.scaleFactor, app.screenSize.height / app.scaleFactor)
        armature:setPosition(cc.p(size.width/2 + app.baseOffsetX/2, size.height/2))
        armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
        armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
        armature._invoke = excuteSPSkillEffectOver
        fwin._view._layer:addChild(armature)
        local musicIndex = 1
        if attacker == "2" then
        	musicIndex = 1
        elseif attacker == "3" then
        	musicIndex = 2
        end
        local user_ship = 0
        for i = 2, 7 do
	        local shipId = _ED.formetion[i]
			if zstring.tonumber(shipId) > 0 then
				local findShip = _ED.user_ship[shipId].ship_template_id
				local isleadtype = dms.int(dms["ship_mould"], findShip, ship_mould.captain_type)
				local base_mould = dms.int(dms["ship_mould"], findShip, ship_mould.base_mould)
				if zstring.tonumber(isleadtype) == 0 then
					user_ship = base_mould
				end
			end
		end
		if tonumber(user_ship) ~= 0 then
			local musicIds = {}
			for k,v in pairs(_Tipstring_magic_trup_sound) do
				if tonumber(v[1]) == tonumber(user_ship) then
					musicIds = zstring.split(v[2], ",")
				end
			end
        	playEffectMusic(musicIds[musicIndex])
        end
	elseif zstring.tonumber(mPosTile._pos) == 102 then 
		--战宠
		local skillData = dms.element(dms["skill_mould"],skillMouldId)

		local skill_quality = dms.atoi(skillData,skill_mould.skill_quality)
		local armature =  nil 
		local armatureName = ""
		local skill_picIndex = dms.int(dms["ship_mould"], mPosTile._armature._role._mouldId, ship_mould.screen_attack_effect)
		
		if skill_quality == 0 then 
			armatureName = "hero_head_zc_" .. skill_picIndex .. "_0"
			armature = ccs.Armature:create(armatureName)
		else
			armatureName = "hero_head_zc_" .. skill_picIndex .. "_1"
			armature = ccs.Armature:create(armatureName)
        end
        local picIndex =  dms.int(dms["ship_mould"], mPosTile._armature._role._mouldId, ship_mould.All_icon)
      	armature:getAnimation():playWithIndex(0)
		local size = cc.size(app.screenSize.width / app.scaleFactor, app.screenSize.height / app.scaleFactor)
        armature:setPosition(cc.p(size.width/2 + app.baseOffsetX/2, size.height/2))
        armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
        armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
        armature._invoke = excuteSPSkillEffectOver
        fwin._view._layer:addChild(armature)
	else
		-- if skillQuality == 1 and mPosTile._armature._role._quality >= 3 then
		if skillQuality == 1 or skillQuality == 2 then
			-- 绘制怒气技术过场动画
			mPosTile._armature._currentSkillMouldId = skillMouldId
			excuteSPSkillEffect(mPosTile, mPosTile._armature)
		else
			executeHeroMoveToTarget()
		end
	end
end

nextRoundBattle = function()
	--> print("nextRoundBattle:", setDeathArmatureCount, currentRoundIndex, _ED.attackData.roundCount)
	if setDeathArmatureCount > 0 then
		return
	end

	if currentRoundIndex >= _ED.attackData.roundCount then
		__battleDatas = nil
		__attackDatas = nil
		--> print("当前场次的战斗结束，进入下一场战斗。")
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			state_machine.excute("fight_check_next_fight", 0, 0)
		else
			if BattleSceneClass._isSkepBattle == true then
				state_machine.excute("fight_check_skeep_fight", 0, 0)
			else
				state_machine.excute("fight_check_next_fight", 0, 0)
			end
		end
		return
	end
	currentRoundAttackIndex = 1
	currentSkillInfluenceStartIndex = 1
	
	currentRoundIndex = currentRoundIndex + 1
	
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		state_machine.excute("fight_ui_update_battle_round_count", 0, _ED.attackData.roundData[currentRoundIndex].currentRound .. "/" .. _ED.attackData.totalRoundCount)
	else
		state_machine.excute("fight_ui_update_battle_round_count", 0, _ED.attackData.roundData[currentRoundIndex].currentRound.."/".."20")
	end
	-- 更新战斗的回合数
	state_machine.excute("fight_total_round_count", 0, {currentRoundIndex})
	
	nextAttack()
end


-- END~战斗过程处理
-- ------------------------------------------------------------------------------------------------- --


function BattleSceneClass:ctor()
	self.super:ctor()
	
	lastTimeRoundBattleNumber = 0 -- 军团副本战斗上次回合的活动对象数
	currentcurrent_scene_npc_id_length = nil
	battleMoveUnionTeamY = nil

	BattleSceneClass._attackTotalHarm = nil
	skipCurrentFight = false
	lockSkipFight = false
	setDeathArmatureCount = -1
	
	local size = cc.Director:getInstance():getWinSize()
	
	BattleSceneClass._lastExp = _ED.user_info.user_experience
	BattleSceneClass._lastNeedExp = _ED.user_info.user_grade_need_experience
	
	_ED._user_last_grade = _ED.user_info.user_grade
	
	BattleSceneClass.curDamage = 0
	BattleSceneClass.bossDamage = 0
	
	-- ----------------------------------------初入战场------------------------------------------------- --
	BattleSceneClass._isSkepBattle = false
	
	startBattle = function()
		-- 开始战斗了
		currentAttackCount = 0
		currentRoundIndex = 0
		currentRoundAttackIndex = 1
		currentSkillInfluenceStartIndex = 1
		isAttackInfluence = false

		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			battle_execute._playEffectMusic = playEffectMusic
		end

		nextRoundBattle()
	end
	-- NED~战斗过程处理	
	-- ------------------------------------------------------------------------------------------------- --
end	

function BattleSceneClass.Draw()
	
end

function BattleSceneClass:resumePVEBattle()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
	else
	    nextAttack()
	end
end

function BattleSceneClass:startPVEBattle(_battleData, _attackData, _attackers, _defenders)
	state_machine.excute("fight_ui_for_daily_activity_copy_begin_calc_fight_hurt", 0, nil)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game then
		-- state_machine.excute("fight_role_controller_change_battle", 0, 0)
		-- state_machine.excute("fight_role_controller_start_fight", 0, 0)
		state_machine.excute("fight_role_controller_ready_fight", 0, 0)
		return
	end
    __battleDatas = _battleData
    __attackDatas = _attackData
    __attackers = _attackers
    __defenders = _defenders
    lockSkipFight = false
    BattleSceneClass._isSkepBattle = false
    BattleSceneClass.curDamage = 0
    BattleSceneClass.bossDamage = 0
	attackChangeActionCallback = __attackChangeActionCallback

	for i, v in pairs(__attackers) do
		if v._armature ~= nil then
    		v._move_logic_origin_position = cc.p(v:getPosition())
		end
	end

	for i, v in pairs(__defenders) do
		if v._armature ~= nil then
    		v._move_logic_origin_position = cc.p(v:getPosition())
		end
	end
	attack_logic.__blastersed = {}

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		battle_execute = battle_execute or {}
		battle_execute._executeHeroMoveToOriginTarget = function()
			--> print("攻击结束返回")
			attackTargetCount = 0
			executeHeroMoveToOriginTarget()
		end

		battle_execute._createEffect = createEffect

		battle_execute._getCampEffectId = getCampEffectId

		battle_execute._getCampEffectIds = getCampEffectIds

		battle_execute._roleExecuteAttacking = roleExecuteAttacking

		battle_execute._checkFrameEvent = checkFrameEvent

		battle_execute._deleteEffectFile = deleteEffectFile

		battle_execute._onFrameEvent = onFrameEvent
	end

    startBattle()
end
-- ~END
-- ------------------------------------------------------------------------- --

attack_logic.attack_change_action_callback = attackChangeActionCallback
function attack_logic.attack(roles, params, armature)
	attack_logic.__attackers = params[_enum_params_index.param_heros]
	attack_logic.__defenders = params[_enum_params_index.param_masters]
	armature._invoke = attack_logic.attack_change_action_callback
	iii = ii +1
	table.insert(attack_logic.queue, armature)
	local sync = params[_enum_params_index.param_next_terminal_name]
	if sync == "1" then
		if #role == #queue then
			for i, v in pairs(attack_logic.queue) do
				v._armature._start_attack = true
				v._armature._sync = true
			end
		end
	else
		armature._start_attack = true
		armature._sync = false
	end
end

__skeep_attackChangeActionCallback = function(armatureBack)
local armature = armatureBack
	if armature ~= nil then
		local actionIndex = armature._actionIndex
		-- 攻击切帧控制
		if actionIndex == animation_standby then				-- 待机帧

		elseif actionIndex == animation_death then					-- 死亡
			armature:getAnimation():setSpeedScale(1.0/_fight_run_speed[4])
			deathBuff(armatureBack,armature)
		elseif actionIndex == death_buff then
			armature:getAnimation():setSpeedScale(1.0/_fight_run_speed[4])
			deathBuff(armatureBack,armature)
		elseif actionIndex == death_buff_end then
			armature:getAnimation():setSpeedScale(1.0/_fight_run_speed[4])
			deathBuff(armatureBack,armature)
		end
	end	
end

local function createSkipDeamgeNumberAndDrop(posTile, _sDeamge)
	local _widget = posTile
							
	local tempX, tempY  = _widget:getPosition()
	local widgetSize = _widget:getContentSize()
	local numberFilePath = "images/ui/number/xue.png"
	local roleDeamge = _sDeamge
	if roleDeamge == nil then
		if _widget._armature == nil then
			return
		end
		if _widget._armature._role == nil then
			return
		end
		roleDeamge = zstring.tonumber("".._widget._armature._role._hp)
		--_widget._armature._role._hp = 0
	end
	local labelAtlas = nil
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then 
		--> print("本次的伤害值：", drawString)
		labelAtlas = cc.LabelBMFont:create(drawString,"fonts/xue.fnt") 
	else
		labelAtlas = cc.LabelAtlas:_create(""..roleDeamge, numberFilePath, 34, 46, 43)  
	end 
	-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
	labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
	labelAtlas:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
	_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt) 
	
	if defState == "2" or true then
		local crit = cc.Sprite:createWithSpriteFrameName("images/ui/battle/baoji.png")
		crit:setAnchorPoint(cc.p(0.5, 0.5)) 
		labelAtlas:addChild(crit, kZOrderInMap_Hurt)
		crit:setPosition(cc.p(labelAtlas:getContentSize().width/2, crit:getContentSize().height + labelAtlas:getContentSize().height/2))
	end
	
	local seq = nil
	if defState == "0" then
		-- seq = cc.Sequence:create(
		-- 	cc.ScaleTo:create(3.5/60.0 * __fight_recorder_action_time_speed, 2),
		-- 	cc.ScaleTo:create(3.5/60.0 * __fight_recorder_action_time_speed, 1.0),
		-- 	cc.DelayTime:create(30.0/60.0 * __fight_recorder_action_time_speed),
		-- 	cc.ScaleTo:create(5.0/60.0 * __fight_recorder_action_time_speed, 0.2),
		-- 	cc.CallFunc:create(removeFrameObjectFuncN)
		-- )

		labelAtlas:setScale(0.8)
		seq = cc.Sequence:create(
			cc.ScaleTo:create(0.1 * __fight_recorder_action_time_speed, 2.0),
			cc.ScaleTo:create(0.1 * __fight_recorder_action_time_speed, 1.0),
			cc.DelayTime:create(0.6 * __fight_recorder_action_time_speed),
			cc.CallFunc:create(removeFrameObjectFuncN)
		)
		labelAtlas:runAction(cc.MoveBy:create(0.2 * __fight_recorder_action_time_speed, cc.p(0, 50)))
	else	
		seq = cc.Sequence:create(
			cc.DelayTime:create(30.0/60.0 * __fight_recorder_action_time_speed),
			cc.ScaleTo:create(5.0/60.0 * __fight_recorder_action_time_speed, 0.2),
			cc.CallFunc:create(removeFrameObjectFuncN)
		)
	end
	
	labelAtlas:runAction(seq)
	
	showRoleHP(_widget._armature)
end

function attack_logic.skeep_influences(skillInfluences, hero, master)
	for n, t in pairs(skillInfluences) do
		for w = 1, t.defenderCount do
			local _def = t._defenders[w]
			local _role = nil
			local posTile = nil
			if _def.defender == "0" then
				if hero[_def.defenderPos] == nil then
					hero[_def.defenderPos] = getRole(0, _def.defenderPos)
				end
				posTile = hero[_def.defenderPos]
			else
				if master[_def.defenderPos] == nil then
					master[_def.defenderPos] = getRole(1, _def.defenderPos)
				end
				posTile = master[_def.defenderPos]
			end	
			if posTile._armature ~= nil and posTile._armature._role ~= nil then
				if _def.defAState == "1" then
					if posTile._armature._isDeath ~= true then
						setDeathArmatureCount = setDeathArmatureCount + 1
						posTile._armature._def = _def
						createSkipDeamgeNumberAndDrop(posTile)
						executeRoleDeath(posTile._armature)
						if _def.defender == "0" then
							hero[_def.defenderPos] = nil
						else
							master[_def.defenderPos] = nil
						end
					end
				else
					if _def.defenderST == "0" or _def.defenderST == "6" then
						if posTile.__deamge == nil then
							posTile.__deamge = zstring.tonumber(_def.stValue)
						else
							posTile.__deamge = posTile.__deamge + zstring.tonumber(_def.stValue)
						end
					end
				end
			end
		end
	end
end
-- 跳过
function attack_logic.skeep(_attackers, _defenders)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		battle_execute._is_skeep = true
		return
	end
	-- if linkAttacker_state == 2 then
	-- 	return
	-- end
	-- if linkAttacker_state == 1 then
	-- 	linkAttacker_state = 2
	-- 	return
	-- end
	if lockSkipFight == true or _ED.attackData == nil or _ED.attackData.roundData == nil 
		or __battleDatas == nil or __attackDatas == nil then
		return
	end

	local canSkipFight = false
	if __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then
		for i, v in pairs(_ED.attackData.roundData) do
			if i >= currentRoundIndex then
				canSkipFight = true
				break
			end
		end		
	else	
		for i, v in pairs(_ED.attackData.roundData) do
			if i > currentRoundIndex then
				canSkipFight = true
				break
			end
		end
	end	
	if canSkipFight == false then
		return
	end	
	lockSkipFight = true

	BattleSceneClass._isSkepBattle = true

	attackChangeActionCallback = __skeep_attackChangeActionCallback
	--> print("进入待机10")
	for i, v in pairs(_attackers) do
		if v._armature ~= nil and v._armature._isDeath ~= true then
			v:stopAllActions()
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				battle_execute._changeToAction(v._armature, animation_standby)
				if nil ~= armature._child_list then
					for i, n in pairs(armature._child_list) do
						battle_execute._changeToAction(n, animation_standby)
					end
				elseif nil ~= v._armature._weapon then
					battle_execute._changeToAction(v._armature._weapon, animation_standby)
				end
			else
				v._armature._invoke = nil
				v._armature._actionIndex = animation_standby
				v._armature:getAnimation():playWithIndex(v._armature._actionIndex)
				v._armature:getAnimation():setSpeedScale(1.0)
				v._armature._invoke = attackChangeActionCallback
				v._armature._nextAction = animation_standby
				if nil ~= armature._child_list then
					for i, n in pairs(armature._child_list) do
						n._actionIndex = animation_standby
						n._nextAction = animation_standby
						n:getAnimation():playWithIndex(v._armature._actionIndex)
					end
				elseif nil ~= v._armature._weapon then
					v._armature._weapon._actionIndex = animation_standby
					v._armature._weapon._nextAction = animation_standby
					v._armature._weapon:getAnimation():playWithIndex(v._armature._actionIndex)
				end
				v:setPosition(v._move_logic_origin_position)
			end
		end
	end

	for i, v in pairs(_defenders) do
		if v._armature ~= nil and v._armature._pos ~= nil and v._armature._isDeath ~= true then
			v:stopAllActions()
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				battle_execute._changeToAction(v._armature, animation_standby)
				if nil ~= armature._child_list then
					for i, n in pairs(armature._child_list) do
						battle_execute._changeToAction(n, animation_standby)
					end
				elseif nil ~= v._armature._weapon then
					battle_execute._changeToAction(v._armature._weapon, animation_standby)
				end
			else
				v._armature._invoke = nil
				v._armature._actionIndex = animation_standby
				v._armature:getAnimation():playWithIndex(v._armature._actionIndex)
				v._armature:getAnimation():setSpeedScale(1.0)
				v._armature._invoke = attackChangeActionCallback
				v._armature._nextAction = animation_standby
				if nil ~= armature._child_list then
					for i, n in pairs(armature._child_list) do
						n._actionIndex = animation_standby
						n._nextAction = animation_standby
						n:getAnimation():playWithIndex(v._armature._actionIndex)
					end
				elseif nil ~= v._armature._weapon then
					v._armature._weapon._actionIndex = animation_standby
					v._armature._weapon._nextAction = animation_standby
					v._armature._weapon:getAnimation():playWithIndex(v._armature._actionIndex)
				end
				v:setPosition(v._move_logic_origin_position)
			end
		end
	end

	setDeathArmatureCount  = 0
	local hero = {}
	local master = {}
	for i, v in pairs(_ED.attackData.roundData) do
		if i >= currentRoundIndex then
			for j, h in pairs(v.roundAttacksData) do
				attack_logic.skeep_influences(h.skillInfluences, hero, master)
				-- 合体技能
				if h.fitHeros ~= nil then
					for f, s in pairs(h.fitHeros) do
						attack_logic.skeep_influences(s.skillInfluences, hero, master)
					end
				end
				attack_logic.skeep_influences(h.skillAfterInfluences, hero, master)
				if h.attackerBuffState == "1" and h.attackerBuffDeath == "1" then
					local posTile = nil
					if h.attacker == "0" then
						posTile = getRole(0, h.attackerPos)
					else
						posTile = getRole(1, h.attackerPos)
					end		
					if posTile._armature ~= nil and posTile._armature._isDeath ~= true and posTile._armature._role ~= nil then
						setDeathArmatureCount = setDeathArmatureCount + 1
						posTile._armature._def = {dropType = h.dropType, dropCount = h.attackerBuffDropCount}
						posTile._armature._dropCount = h.attackerBuffDropCount
						createSkipDeamgeNumberAndDrop(posTile)
						executeRoleDeath(posTile._armature)
					end
				end
			end
		end
	end

	for i, v in pairs(hero) do
		if v._armature ~= nil and v._armature._isDeath ~= true then
			createSkipDeamgeNumberAndDrop(v, v.__deamge)
			v.__deamge = nil
		end	
	end
	
	for i, v in pairs(master) do
		if v._armature ~= nil and v._armature._isDeath ~= true then
			createSkipDeamgeNumberAndDrop(v, v.__deamge)
			v.__deamge = nil
		end
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		currentRoundIndex = _ED.attackData.roundCount
		setDeathArmatureCount = -1
		nextRoundBattle()
	else
		if BattleSceneClass._isSkepBattle == true and setDeathArmatureCount == 0 and _ED.attackData.isWin == "0" then
			currentRoundIndex = _ED.attackData.roundCount
			setDeathArmatureCount = -1
			nextRoundBattle()
		end
	end
end

function deleteBlastEffectFile(armatureBack)
	deleteEffectFile(armatureBack)

	for i, v in pairs(attack_logic.__blasters) do
		if v == attack_logic.__blaster then
			table.remove(attack_logic.__blasters, i)
		end
	end

	if #attack_logic.__blasters > 0 then
		attack_logic.__blaster = attack_logic.__blasters[1]
		attack_logic.blastEffect(attack_logic.__blaster)
		return
	else
		attack_logic.__blaster = nil
		if attack_logic.__need_unlock == true then
			attack_logic.__need_unlock  = false
			if BattleSceneClass._isSkepBattle == false then
				nextAttack()
			end
		end
	end
end

function attack_logic.blastEffect(roleInfo)
	local size = cc.size(app.screenSize.width / app.scaleFactor, app.screenSize.height / app.scaleFactor)
    local armature = ccs.Armature:create("hero_broken_effect")

    local blast_string = {
    	"fit_1_1", "fit_1_2", "fit_1_3" , "map_1"
	}

	for i, v in pairs(blast_string) do
		local imagePath = string.format("images/face/big_head/big_head_%s.png", roleInfo._head + 10000)
		if v == "map_1" then
			imagePath = _ED.battle_map_imagePath
			armature:getBone(v):setScale(1.2)
		end
		local head = ccs.Skin:create(imagePath)
		armature:getBone(v):addDisplay(head, 0)
	end

	if zstring.tonumber(roleInfo._mouldId) > 0 then
		 local data =  dms.searchs(dms["ship_sound_effect_param"], ship_sound_effect_param.ship_mould, zstring.tonumber(roleInfo._mouldId) )
	    if data ~= nil and  table.getn(data) > 0 and data[1] ~= nil then
	       local tempMusicIndex =  dms.atoi(data[1], ship_sound_effect_param.sound_effect3)
	        if tempMusicIndex > 0 then
	        	playEffectMusic(tempMusicIndex)
	        end
	    end
	 end
	-- _type = npos(list),					-- 对象类型：0用户，1环境战船
	-- 		_mouldId = npos(list),

	--> print("进入待机11")
	armature:setPosition(cc.p(size.width/2 + app.baseOffsetX/2, size.height/2))
	armature:getAnimation():playWithIndex(animation_standby)
    armature:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
	armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
    armature._invoke = deleteBlastEffectFile
    fwin._view._layer:addChild(armature)
end

-- Initialize login fight attack logic state machine.
local function init_attack_logic_terminal()
	local attack_logic_start_terminal = {
        _name = "attack_logic_start",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			attack_logic.attack(params[1], params[2], params[3])
			return true
        end,
        _terminal = nil,
        _terminals = nil
	}

	local attack_logic_skeep_fight_terminal = {
        _name = "attack_logic_skeep_fight",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			attack_logic.skeep(params[1], params[2])
			return true
        end,
        _terminal = nil,
        _terminals = nil
	}

	local attack_logic_role_blast_terminal = {
        _name = "attack_logic_role_blast",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	if ___is_open_laster == true then
	        	if BattleSceneClass._isSkepBattle == true then
	        		return
	        	end
				local roleInfo = params.roleInfo
				for i, v in pairs(attack_logic.__blastersed) do
					if v == roleInfo then
						return
					end
				end 
				local imagePath = string.format("images/face/big_head/big_head_%s.png", roleInfo._head + 10000)
				local head = ccs.Skin:create(imagePath)
				if head == nil then
					return
				end
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_broken_effect.ExportJson")
				table.insert(attack_logic.__blastersed, roleInfo)
				table.insert(attack_logic.__blasters, roleInfo)
				if attack_logic.__blaster ~= nil then
					return
				end
				attack_logic.__blaster = roleInfo
				attack_logic.blastEffect(roleInfo)
			end
			return true
        end,
        _terminal = nil,
        _terminals = nil
	}

	state_machine.add(attack_logic_start_terminal)
	state_machine.add(attack_logic_skeep_fight_terminal)
	state_machine.add(attack_logic_role_blast_terminal)
    state_machine.init()
end

-- call func init fight attack logic state machine.
init_attack_logic_terminal()

battle_execute._playEffectMusic = playEffectMusic

battle_execute._createEffect = createEffect

battle_execute._getCampEffectId = getCampEffectId

battle_execute._getCampEffectIds = getCampEffectIds

battle_execute._roleExecuteAttacking = roleExecuteAttacking

battle_execute._checkFrameEvent = checkFrameEvent

battle_execute._deleteEffectFile = deleteEffectFile

battle_execute._onFrameEvent = onFrameEvent
