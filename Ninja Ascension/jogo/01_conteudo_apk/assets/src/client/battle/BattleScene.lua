-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗场景管理
-- 创建时间2014-03-01 15:06
-- 作者：周义文
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

-- local __attackers = nil
-- local __defenders = nil
-- local __battleDatas = nil
-- local __attackDatas = nil

-- local function getRole(_camp, _target_pos)
-- 	local _role = "".._camp == "0" and __attackers[tonumber("".._target_pos)]:getParent() or __defenders[tonumber("".._target_pos)]:getParent()
-- 	return _role
-- end


-- function draw.drawFirstRechargeCG(user_grade,currentNpcId)
-- end

-- -- 战斗内使用的，根据传入的战士di,返回攻防小图标路径图
-- draw.getBattleHeroAbilityImg = function(shipMouldId,mouldType)
-- 	local capacity = nil
-- 	if mouldType==0 then
-- 		capacity = dms.int(dms["ship_mould"], shipMouldId, ship_mould.capacity)		--武将能力标识
-- 	elseif mouldType == 1 then
-- 		capacity = dms.int(dms["environment_ship"], shipMouldId, environment_ship.capacity)	--武将能力标识 
-- 	end
-- 	return string.format("images/ui/play/adam_war/icon_%s.png",  capacity+1)
-- end


-- BattleSceneClass = class("BattleSceneClass", Window)
-- BattleSceneClass.__index = BattleSceneClass
-- BattleSceneClass._uiLayer= nil
-- BattleSceneClass._widget = nil
-- BattleSceneClass._widgetBg = nil
-- BattleSceneClass._effectBg = nil
-- BattleSceneClass._sceneTitle = nil
-- BattleSceneClass._lastExp = nil
-- BattleSceneClass._lastNeedExp = nil
-- BattleSceneClass._GoldBossCell = nil
-- BattleSceneClass._attackTotalHarm = nil
-- BattleSceneClass._unionBattleInfo = nil
-- BattleSceneClass._hero_index = 0

-- -- ------------------------------------------------------------------------------------------------- --
-- -- 											战斗过程处理												 --
-- -- ------------------------------------------------------------------------------------------------- --

-- -- 战斗UI控制
-- local isCanSkipCurrentBattle	= false
-- -- 片头剧情战斗屏蔽大蛇的血条，卡牌，和战士相性图标
-- local shieldFoeId = 1283
-- -- Local Variable
-- -- 层的编号
-- local kTagFadeInLayerColor		= 190000	-- 淡入的遮挡层
-- local missionJump 				= 190001	-- 跳过剧情按钮的层

-- local kSkipPlotNPC				= 43000

-- local kZOrderInMap_StanddyRole	= 0
-- local kZOrderInMap_MoveRole		= 1	
-- local kZOrderInMap_Effect		= 2		
-- local kZOrderInMap_Hurt			= 3		
-- local kZOrderInMap_sp_effect	= 4

-- -- UI
-- local teamTopScreenOffsetY		= 0 / CC_CONTENT_SCALE_FACTOR()			-- 敌方上方场景中的偏移量，或我方下方场景中的偏移量
-- local attackMoveTagetOffsetY	= 100 / CC_CONTENT_SCALE_FACTOR()			-- 与被攻击者之前的间距
-- local attackUnionTagetOffsetY	= 500 / CC_CONTENT_SCALE_FACTOR()		-- 公会入场偏移量

-- -- 数据
-- local fightSlotCount			= 6			-- 战斗位的数据
-- local fightOverCount 			= 3			-- 战斗结束场次
-- local lockSkipFight 			= false
-- local skipCurrentFight 			= false
-- local setDeathArmatureCount 	= -1

-- local fight_type_1				= 1
-- local fight_type_2				= 2
-- local fight_type_3				= 3
-- local fight_type_4				= 4
-- local fight_type_5				= 5
-- local fight_type_6				= 6
-- local fight_type_7				= 7
-- local fight_type_8				= 8
-- local fight_type_9				= 9

-- -- 动画的控制
-- local fightAccelerationOne		= zstring.tonumber(_fight_run_speed[1])
-- local fightAccelerationTwo		= zstring.tonumber(_fight_run_speed[2])
-- local fightAccelerationThree	= zstring.tonumber(_fight_run_speed[3])
-- local fightAccelerationFour		= zstring.tonumber(_fight_run_speed[4])
-- if m_tOperateSystem == 5 then
-- 	fightAccelerationOne = fightAccelerationOne*1.5
-- 	fightAccelerationTwo = fightAccelerationTwo*1.5
-- 	fightAccelerationThree = fightAccelerationThree*1.5
-- 	fightAccelerationFour = fightAccelerationFour*1.5
-- end
-- local actionTimeSpeed			= fightAccelerationOne

-- -- 战斗中的环境变量
-- local moveFrameTime = 0.013
-- local moveFrameSpace = 4
-- local moveToTargetTime = 0.5
-- local moveToTargetTime1 = dms.int(dms["durationmt"], 1, 1) / 60.0
-- local moveToTargetTime2 = dms.int(dms["durationmt"], 2, 1) / 60.0

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


-- local battle_enum = {
-- 	into1								= 28,	-- 出场动画1
-- 	into2								= 29,	-- 出场动画2
-- 	into3								= 30,	-- 出场动画3
-- 	into4								= 31,	-- 出场动画4
-- 	into5								= 32,	-- 出场动画5
-- 	into6								= 33,	-- 出场动画6
-- 	animation_difangmove				= 34,	-- 敌方移动
-- 	animation_difangmoving				= 35,	-- 敌方移动中
-- 	animation_difangmove_end			= 36,	-- 敌方移动结束
-- 	animation_heti1						= 37,	-- 逆时针合体技能动画
-- 	animation_heti2						= 38,	-- 顺时针合体技能动画
-- }

-- local into={battle_enum.into1,battle_enum.into2,battle_enum.into3,battle_enum.into4,battle_enum.into5,battle_enum.into6}-- 出场动画的表


-- -- ----------------------------------------功能函数------------------------------------------------- --
-- local moveTeam = nil						-- 移动队伍进入战斗
-- local moveUnionTeam = nil					-- 
-- local initBattle = nil						-- 初始化战斗中的我方角色
-- local initEnemy = nil						-- 初始化战斗中的敌方角色
-- local startBattle = nil						-- 开始战斗
-- local nextRoundBattle = nil					-- 下一回合的战斗
-- local nextAttack = nil						-- 下一个角色进行攻击
-- local executeHeroMoveToTarget = nil			-- 处理角色移动到攻击点
-- local executeHeroMoveToOriginTarget = nil	-- 处理角色移动到原点
-- local executeAttack = nil					-- 处理角色进行攻击
-- local executeAttacking = nil				-- 处理角色进行攻击中
-- local startAfterAttack = nil				-- 启动角色的后段攻击
-- local executeAfterAttack = nil				-- 处理角色的后段攻击
-- local executeAfterAttacking = nil 			-- 处理角色的后段技能效用处理
-- local executeByAttack = nil					-- 处理角色被攻击
-- local executeSkillAttack = nil				-- 处理角色进行技能攻击
-- local executeBySkillAttack = nil			-- 处理角色被技能攻击
-- local executeAttackerBuff = nil				-- 处理攻击者的BUFF
-- local executeDeath = nil					-- 处理角色死亡

-- local attackChangeActionCallback = nil		-- 攻击切帧控制
-- local executeMeleeAttackBegan = nil			-- 近身攻击前段
-- local executeMeleeAttacking = nil			-- 近身攻击中段
-- local executeMeleeAttackEnd = nil			-- 近身攻击后段
-- local executeRemoteAttackBegan = nil		-- 远程攻击前段
-- local executeRemoteAttacking = nil			-- 远程攻击中段
-- local executeRemoteAttackEnd = nil			-- 远程攻击后段
-- local executeMeleeSkillBegan = nil			-- 技能近身攻击前段
-- local executeMeleeSkilling = nil			-- 技能近身攻击中段
-- local executeMeleeSkillEnd = nil			-- 技能近身攻击后段
-- local executeRemoteSkillBegan = nil			-- 技能近远程击前段
-- local executeRemoteSkilling = nil			-- 技能近远程击中段
-- local executeRemoteSkillEnd = nil			-- 技能近远程击后段

-- local executeHeroByAttack = nil				-- 我方被攻击光效
-- local executeEmenyByAttack = nil			-- 敌方被攻击光效
-- local executeDrawAttackHurtNmber = nil		-- 绘制攻击伤害数字
-- local executeRoleDeath = nil				-- 角色死亡光效

-- local loadEffectFile = nil					-- 加载光效资源文件
-- local deleteEffectFile = nil				-- 删除光效
-- local createEffect = nil					-- 创建光效
-- local executeEffectSkillBegan = nil			-- 技能光效前段
-- local executeEffectSkilling = nil			-- 技能光效中段
-- local executeEffectSkillEnd = nil			-- 技能光效后段

-- local playEffectMusic = nil					-- 播放音效

-- local onFrameEvent = nil					-- 帧事件监听
-- local onFrameEvent3 = nil					-- 帧事件监听

-- local responseBattleFieldInit = nil
-- local requestEnvironmentContinueFight = nil
-- -- startBattle  Variable
-- local currentRoundIndex = 0
-- local currentRoundAttackIndex = 1
-- local currentSkillInfluenceStartIndex = 1
-- local isAttackInfluence = false
-- local attackTargetCount = 0
-- local executeAfterInfluenceCount = 0
-- local currentAttackCount = 0

-- local isNoDeath = false
-- local isSkepBattle = false

-- -- nextAttack  Variable
-- local mPosTile = nil
-- local mpos = nil
-- local mtime = 0

-- local lastTimeRoundBattleNumber = 0 -- 军团副本战斗上次回合的活动对象数
-- local currentcurrent_scene_npc_id_length = nil --当前副本的部队数
-- local battleMoveUnionTeamY = nil
-- local mschedulerEntry=nil
-- local mScheduler=nil

-- local createFlyingEffects = nil



-- function getRageHead()
-- 	local rage_head_image = "images/face/big_head/big_head_%s.png"
-- 	return rage_head_image
-- end

-- BattleSceneClass.curDamage = 0

-- local function DamageToMoney()
-- 	local exMoney = 0
-- 	local i = 0
-- 	for i=12, 1, -1 do
-- 		local data = dms.element(dms["damage_reward_silver_param"], i)
-- 		if dms.atoi(data, damage_reward_silver_param.damage_value) <= BattleSceneClass.curDamage then
-- 			exMoney = dms.atoi(data, damage_reward_silver_param.reward_silver)
-- 			break
-- 		end
-- 	end
	
-- 	return math.floor(BattleSceneClass.curDamage/10) + exMoney
-- end

-- -- function 
-- local function getRolePad(camp, pos)
-- 	return getRole(camp, pos)
-- end

-- local function getCampEffectId(_skillInfluenceElementData, camp, effect_index)
-- 	-- local camp = zstring.tonumber(camp)
-- 	-- local effectIds = zstring.split(dms.atos(_skillInfluenceElementData, effect_index), ",")
-- 	-- local effectId = zstring.tonumber(effectIds[camp])
-- 	-- return effectId
-- 	return dms.atoi(_skillInfluenceElementData, effect_index)
-- end

-- -- 播放音效
-- playEffectMusic = function(musicIndex)
-- 	-- 播放音效
-- 	playEffect(formatMusicFile("effect", musicIndex))
-- end

-- local function resetArmatureData(armature)
-- 	if armature ~= nil then
-- 		armature._hurtCount = 0
-- 		armature._hnb = nil
-- 		armature._executeBuff = false
-- 		armature._executeBuffs = {}
-- 		armature._def = nil
-- 		armature._defr = nil
-- 		armature._sie = nil
-- 		armature._defs = nil
-- 		armature._isByReact = false
-- 		armature._reactor = nil
-- 		armature._isReact = false
-- 		armature._isReacting = false
-- 		armature._byReactor = nil
-- 	end
-- end

-- -- 动帧监听函数
-- local nil_animationEventCallFunc = nil
-- local animation_changeToAction = nil
-- --local changeAction_animationEventCallFunc = nil

-- local function doSkipCurrentFight()
-- 	if _ED.battleData.battle_init_type == 1 then
		
-- 		if isCanSkipCurrentBattle == true then	
-- 			if zstring.tonumber("".._ED.vip_grade) >= 4 then
-- 				skipCurrentFight = true
-- 			else
-- 				TipDlg.drawTextDailog(_string_piece_info[18])
-- 				skipCurrentFight = false
-- 			end
-- 		else
-- 			TipDlg.drawTextDailog(_string_piece_info[19])
-- 			lockSkipFight = false
-- 		end
-- 	elseif _ED.battleData.battle_init_type == 3 then
-- 		if isCanSkipCurrentBattle == true then	
-- 			if zstring.tonumber("".._ED.vip_grade) >= 4 then
-- 				skipCurrentFight = true
-- 			else
-- 				TipDlg.drawTextDailog(_string_piece_info[20])
-- 				skipCurrentFight = false	
-- 			end
-- 		else
-- 			lockSkipFight = false
-- 			TipDlg.drawTextDailog(_string_piece_info[18])
-- 		end
-- 	elseif _ED.battleData.battle_init_type == 4 then
-- 		if isCanSkipCurrentBattle == true then	
-- 			if zstring.tonumber("".._ED.vip_grade) >= 4 then
-- 				skipCurrentFight = true
-- 			else
-- 				TipDlg.drawTextDailog(_string_piece_info[21])
-- 				skipCurrentFight = false	
-- 			end
-- 		end
-- 	elseif _ED.battleData.battle_init_type >= 10 then
-- 			skipCurrentFight = true
-- 	else
-- 		if isCanSkipCurrentBattle == true then	
-- 			skipCurrentFight = true
-- 		else
-- 			lockSkipFight = false
-- 			TipDlg.drawTextDailog(_string_piece_info[19])
-- 		end
-- 	end
-- end

-- nil_animationEventCallFunc = function(armatureBack,movementType,movementID)
-- 	-- 无效的动画帧组监听状态
-- 	if armatureBack._changing == nil then
-- 		armatureBack._nextFunc = nil
-- 		armatureBack._changing = true
-- 		armatureBack:getAnimation():removeMovementEventCallFunc()
-- 		armatureBack._changing = nil
-- 	end
-- end

-- animationChangeToAction = function(armature, changeToAction, nextAction)
-- 	armature._actionLoopCount = 0
-- 	armature._changing = true
-- 	armature:getAnimation():playWithIndex(changeToAction)
-- 	armature._actionIndex = changeToAction
-- 	armature._nextAction = animation_standby
-- 	armature._changing = nil
-- end

-- local function setVisibleBone(armature, boneName, var)
-- 	armature:getBone(boneName):setVisible(false)
-- end

-- local function showRoleHP(armature)
-- 	if armature ~= nil
-- 		-- and armature._hpPragress ~= nil 
-- 		then
-- 		armature._role._hp = armature._role._hp < 0 and 0 or armature._role._hp
-- 		local percent = armature._role._hp/armature._brole._hp * 100
-- 		percent = percent > 100 and 100 or percent
-- 		-- armature._hpPragress:setPercent(percent)
-- 		-- if percent <= 0 and armature._isDeath == true then
-- 		-- 	armature._hpPragress:getParent():setVisible(false)
-- 		-- end
		
-- 		-- 更新角色hp显示
-- 		if armature._camp == "0" then
-- 			-- 玩家血量更新
--> print("我方角色血量更新", armature._pos, tonumber(percent))
-- 			state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 2, _type = 1, _roleIndex = armature._pos, _value = percent})
-- 		else
-- 			-- 敌方血量更新
--> print("敌方角色血量更新", armature._pos, tonumber(percent))
-- 			state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 1, _type = 1, _roleIndex = armature._pos, _value = percent})
-- 		end
-- 	end
-- end

-- local function showRoleSP(armature)
--> ("更新怒气显示了********************", tonumber(armature._role._sp))
-- 	-- 设置角色怒气
-- 	if armature._camp == "0" then
-- 		-- 玩家怒气更新
-- 		state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 2, _type = 2, _roleIndex = armature._pos, _value = armature._role._sp})
-- 	else
-- 		-- 敌人怒气更新
-- 		state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 1, _type = 2, _roleIndex = armature._pos, _value = armature._role._sp})
-- 	end
-- end

-- -- 移动的状态控制
-- local beganMoveHero = 0
-- local function executeMoveOverFunc()
-- 	beganMoveHero = 2
-- end

-- -- 返回到原点
-- local function executeHeroMoveByBackOverFunc()
-- 	beganMoveHero = 12
-- 	began_hero_ZOrder = mPosTile:getLocalZOrder()
-- 	local parent_node = mPosTile:getParent()
	
-- 	parent_node:reorderChild(mPosTile, kZOrderInMap_StanddyRole)
	
-- 	executeAttackerBuff()
-- end

-- local function executeHeroMoveByBack()
-- 	-- -- local array = CCArray:createWithCapacity(10)
-- 	--array:addObject(CCActionInterval:create(1.2))
-- 	if mpos ~= nil then
-- 		local seq = cc.Sequence:create(
-- 			cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(-1 * mpos.x, -1 * mpos.y)),
-- 			cc.CallFunc:create(executeHeroMoveByBackOverFunc)
-- 		)
-- 		mPosTile:runAction(seq)
-- 	end
-- end

-- -- 移动到目标点				
-- local function executeHeroMoveBy()
-- 	-- local array = CCArray:createWithCapacity(10)
-- 	-- --array:addObject(CCActionInterval:create(1.2))
-- 	-- array:addObject(cc.MoveBy:create(mtime * actionTimeSpeed, mpos))
-- 	-- array:addObject(CCCallFunc:create(executeMoveOverFunc))
-- 	local seq = cc.Sequence:create(
-- 		cc.MoveBy:create(mtime * actionTimeSpeed, mpos),
-- 		cc.CallFunc:create(executeMoveOverFunc)
-- 	)
-- 	mPosTile:runAction(seq)

-- 	-- 修改 Z轴
-- 	began_hero_ZOrder = mPosTile:getLocalZOrder()
-- 	local parent_node = mPosTile:getParent()
	
-- 	parent_node:reorderChild(mPosTile, kZOrderInMap_MoveRole)
-- end
-- -- END~攻击前的移动准备
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- local function changeActtackToAttackMoving(armatureBack)
-- 	local armature = armatureBack
-- 	local camp = zstring.tonumber(armature._camp) + 1
-- 	local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.attack_move_action), ",")
-- 	-- local actionIndex = zstring.tonumber(indexs[camp])
-- 	local skillProperty = dms.atoi(armature._sie_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
-- 	local actionIndex = skillProperty == 0 and _enum_animation_frame_index.animation_attack_moving or _enum_animation_frame_index.animation_skill_moving
-- 	armature._nextAction = actionIndex
-- 	armature._invoke = attackChangeActionCallback
--> print("进入攻击移动：", actionIndex)
-- end

-- local function changeActtackToAttackBegan(armatureBack)
-- 	local armature = armatureBack
-- 	local camp = zstring.tonumber(armature._camp) + 1
-- 	local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.before_action), ",")
-- 	local actionIndex = zstring.tonumber(indexs[camp])
-- 	armature._nextAction = actionIndex
-- 	armature._invoke = attackChangeActionCallback
--> print("进入攻击前段：", actionIndex)
-- end

-- local function changeActtackToAttacking(armatureBack)
-- 	local armature = armatureBack
-- 	local camp = zstring.tonumber(armature._camp) + 1
-- 	local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.after_action), ",")
-- 	local actionIndex = zstring.tonumber(indexs[camp])
-- 	armature._nextAction = actionIndex
-- 	-- armature._invoke = attackChangeActionCallback
--> print("进入攻击中段：", actionIndex)
-- end

-- local function changeActtackToAttackAfter(armatureBack)
-- 	local armature = armatureBack
-- 	local camp = zstring.tonumber(armature._camp) + 1
-- 	local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.attack_over_action), ",")
-- 	local actionIndex = zstring.tonumber(indexs[camp])
-- 	armature._nextAction = actionIndex
-- 	-- armature._invoke = attackChangeActionCallback
--> print("进入攻击后段：", actionIndex)
-- end



-- -- 近身移动
-- executeMoveMeleeAttackBegan = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_attack_moving
-- 	armature._invoke = attackChangeActionCallback
-- 	-- 近身移动
-- end

-- -- 近身攻击
-- executeMeleeAttackBegan = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_melee_attack_began
-- 	armature._invoke = attackChangeActionCallback
-- 	-- 近身攻击1
-- end

-- executeMeleeAttacking = function(armatureBack)
-- 	--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
-- 	--mtime = moveToTargetTime1
-- 	--executeHeroMoveBy()
					
-- 	executeAttack()
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_melee_attacking
-- 	-- 近身攻击2
-- end

-- executeMeleeAttackEnd = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_melee_attack_end
-- 	-- 近身攻击3
-- end
-- -- END~近身攻击
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- -- 远程攻击
-- executeRemoteAttackBegan = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_remote_attack_began
-- 	armature._invoke = attackChangeActionCallback
-- 	-- 远程攻击1

-- end

-- executeRemoteAttacking = function(armatureBack)
-- 	executeAttack()
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_remote_attacking
-- 	-- 远程攻击2
-- end

-- executeRemoteAttackEnd = function(armatureBack)
-- 	--executeAttacking()
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_remote_attack_end
-- 	armature._over = true
-- 	-- 远程攻击3
	
-- 	--armatureBack:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
-- end
-- -- END~远程攻击
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- -- 移动技能近身攻击
-- executeMoveMeleeSkillBegan = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_skill_moving
-- 	armature._invoke = attackChangeActionCallback
-- 	-- 技能近身攻击1
-- end

-- -- 技能近身攻击
-- executeMeleeSkillBegan = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_melee_skill_began
-- 	armature._invoke = attackChangeActionCallback
-- 	-- 技能近身攻击1
-- end

-- executeMeleeSkilling = function(armatureBack)	
-- 	--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
-- 	--mtime = moveToTargetTime2
-- 	--executeHeroMoveBy()
	
-- 	executeAttack()
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_melee_skilling
-- 	-- 技能近身攻击2

-- end

-- executeMeleeSkillEnd = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_melee_skill_end
-- 	-- 技能近身攻击3
-- end
-- -- END~技能近身攻击
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- -- 技能远程攻击
-- executeRemoteSkillBegan = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_remote_skill_began
-- 	armature._invoke = attackChangeActionCallback
-- 	-- 技能远程攻击1
-- end

-- executeRemoteSkilling = function(armatureBack)
-- 	if executeAfterInfluenceCount > 0 then
-- 		-- 启动反击
-- 		executeAfterAttack()
-- 	else
-- 		executeAttack()
-- 	end
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_remote_skilling
-- 	-- 技能远程攻击2
-- end

-- executeRemoteSkillEnd = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_remote_skill_end
-- 	-- 技能远程攻击3
-- end
-- -- END~技能远程攻击
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- -- 被攻击光效
-- executeHeroByAttack = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_hero_by_attack
-- 	armature._invoke = attackChangeActionCallback
-- end

-- executeEmenyByAttack = function(armatureBack)
-- 	local armature = armatureBack
-- 	armature._nextAction = animation_emeny_by_attack
-- 	armature._invoke = attackChangeActionCallback
-- end
-- -- END~被攻击光效
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- -- 绘制攻击伤害数字
-- executeDrawAttackHurtNmber = function(armatureBack)
-- 	-- 绘制伤害数字
-- end
-- -- END~绘制攻击伤害数字
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- -- 清除BUFF

-- local function cleanBuffEffectWithMiss(_posTile, _isMiss)
-- 	-- 清除角色的BUFF
-- 	if _posTile ~= nil and _posTile._buff ~= nil and _posTile._effectivenessId == 84 then
-- 		for i, v in pairs(_posTile._buff) do
-- 			if (v._LastsCountTurns ~= nil and v._LastsCountTurns >= 0) or _isMiss == true then
-- 				v._LastsCountTurns = 0
-- 				deleteEffectFile(v)
-- 			end
-- 		end
-- 		_posTile._buff = {}
-- 	end
-- end

-- local function cleanBuffEffect(_posTile, _death)
-- 	-- 清除角色的BUFF
-- 	if _posTile ~= nil and _posTile._buff ~= nil then
-- 		for i, v in pairs(_posTile._buff) do
-- 			if (v._LastsCountTurns ~= nil and v._LastsCountTurns >= 0) or _death == true then
-- 				v._LastsCountTurns = 0
-- 				if v._LastsCountTurns <= 0 then
-- 					-- 清除角色的BUFF
-- 					deleteEffectFile(v)
-- 					--_posTile._buff[i] = nil
-- 				end
-- 			end
-- 		end
-- 		_posTile._buff = {}
-- 	end
-- 	if _posTile ~= nil and _death == true then
-- 		_posTile:removeAllChildren(true)
-- 	end
-- end
		
-- -- 角色死亡光效
-- executeRoleDeath = function(armatureBack)
-- 	-- 角色进行死亡帧
-- 	local armature = armatureBack
-- 	armature._isDeath = true
-- 	armature._nextAction = animation_death
-- 	armature._invoke = attackChangeActionCallback
	
-- 	if armatureBack._posTile._camp == "1" then			
-- 		if armatureBack._isByReact == true then
-- 			-- 敌方角色死亡-被格挡反击致死
-- 		else
-- 			-- 敌方角色死亡
-- 		end
		
-- 		-- 清除角色的BUFF
-- 		if armatureBack._posTile._buff ~= nil then
-- 			for i, v in pairs(armatureBack._posTile._buff) do
-- 				if v ~= nil and v._LastsCountTurns ~= nil then
-- 					v._LastsCountTurns = 0
-- 					if v._LastsCountTurns <= 0 then
-- 						-- 清除角色的BUFF
-- 						deleteEffectFile(v)
-- 						armatureBack._posTile._buff[i] = nil
-- 					end
-- 				end
-- 			end
-- 		end
	
-- 		if armatureBack._def ~= nil and armatureBack._def.defAState == "1" then
-- 			-- 敌方角色死亡， 掉落：", armatureBack._def.dropCount
-- 			-- local fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10866")
-- 			-- local str = tolua.cast(fightRewardItemCount,"Label"):getStringValue()
-- 			-- str = ""..(zstring.tonumber(str) + zstring.tonumber(armatureBack._def.dropCount))
-- 			-- tolua.cast(fightRewardItemCount,"Label"):setText(str)
-- 			-- if armatureBack._def.dropCount > 0 then
-- 				-- local armatureEffect = createEffect(armatureBack._posTile, 96, 0)
-- 				-- armatureEffect._invoke = deleteEffectFile
-- 			-- end
-- 		else
-- 			-- 敌方角色死亡， 掉落：", armatureBack._def.dropCount
-- 			-- local fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10866")
-- 			-- local str = tolua.cast(fightRewardItemCount,"Label"):getStringValue()
-- 			-- str = ""..(zstring.tonumber(str) + zstring.tonumber(armatureBack._dropCount))
-- 			-- tolua.cast(fightRewardItemCount,"Label"):setText(str)
-- 			-- local armatureEffect = createEffect(armatureBack._posTile, 96, 0)
-- 			-- armatureEffect._invoke = deleteEffectFile
-- 		end
		
-- 		armature._role._hp = 0
-- 		showRoleHP(armature)
-- 	else
-- 		-- 我方角色死亡, 通知UI层更新状态
-- 		-- 清除角色的BUFF
-- 		if armatureBack ~= nil and armatureBack._posTile ~= nil and armatureBack._posTile._buff ~= nil then
-- 			for i, v in pairs(armatureBack._posTile._buff) do
-- 				if v ~= nil and v._LastsCountTurns ~= nil then
-- 					v._LastsCountTurns = 0
-- 					if v._LastsCountTurns <= 0 then
-- 						-- 清除角色的BUFF
-- 						deleteEffectFile(v)
-- 						armatureBack._posTile._buff[i] = nil
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end
-- -- END~被攻击光效
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- -- 技能技能光效帧事件监听

-- local function removeFrameObjectFuncN(sender)
-- 	sender:removeFromParent(true)
-- end

-- local function checkFrameEvent(events, mode)
-- 	if events ~= n and #events > 0 then
-- 		for i, v in pairs(events) do
-- 			if v == mode then
-- 				return true
-- 			end
-- 		end
-- 	end
-- 	return false
-- end

-- local function drawFrameEvent(armature, armatureBase, _def, bone,evt,originFrameIndex,currentFrameIndex)
--> print("evt:", evt)
-- 	if evt ~= nil and #evt > 0 then
-- 		local datas = zstring.split(evt, "_")
-- 		if checkFrameEvent(datas, "start") == true then
-- 			local tempArmature = armatureBack
-- 			if tempArmature == nil then
-- 				tempArmature = bone:getArmature()
-- 			end
-- 			if tempArmature ~= nil and tempArmature._angle ~= nil then
-- 				-- 创建飞行的光效
 				--> print("绘制路径光效！！！")
-- 				createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
-- 			end
-- 		end
-- 		if checkFrameEvent(datas, "after") == true then
-- 			-- 处理被攻击的后段光效
-- 			armature._base = armatureBase
-- 			executeEffectSkillEnd(armature)
-- 		end
-- 		if checkFrameEvent(datas, "hurt") == true then
--> print("绘制攻击伤害！！！")
-- 		else
--> print("无效的帧事件！！！")
-- 			return
-- 		end
-- 	else
--> print("无效的帧事件！！！")
-- 		return
-- 	end
	
-- 	-- 绘制伤害数值
-- 	--local armature = armatureBack
-- 	if _def==nil or _def._attackSection <= 0 then
-- 		return
-- 	end
-- 	_def._attackSection = _def._attackSection - 1
	
-- 	armature._hurtCount = armature._hurtCount == nil and 0 or armature._hurtCount
-- 	local _widget = armatureBase._posTile
-- 	if _widget == nil then
-- 		return
-- 	end
	
-- 	if armatureBase._is_vibrate == 1 then
-- 		draw.share()
-- 	end
	
-- 	local tempX, tempY  = _widget:getPosition()
-- 	local widgetSize = _widget:getContentSize()
	
-- 	-- local _def = armature._def
-- 	armature._def = _def
	
-- 	local defState = _def.defState
-- 	local defenderST = _def.defenderST
-- 	local drawString = _def.subValue == nil and _def.stValue or _def.subValue --_def.stValue
-- 	local defAState =  _def.defAState
-- 	if armatureBase._isByReact == true then
-- 		defState = armatureBase._defr.fightBackDefState
-- 		defenderST = armatureBase._defr.fightBackSkf
-- 		drawString = armatureBase._defr.fightBackValue
-- 		defAState = armatureBase._defr.fightBackLiveState
-- 		--[[
-- 		defState = _def.fightBackDefState
-- 		defenderST = _def.fightBackSkf
-- 		defAState = _def.fightBackLiveState
-- 		--]]
-- 	end
	
	
-- 	-- 控制角色被攻击时的动画及被攻击帧
-- 	local changeToAction = nil
-- 	local _tcamp = tonumber(armatureBase._camp)
-- 	if defState == "0" then
-- 		-- 命中的时候切换动作帧组
-- 		changeToAction = animation_hero_by_attack + _tcamp
-- 	elseif defState == "1" then
-- 		-- 闪避的时候切换动作帧组
-- 		changeToAction = animation_hero_miss + _tcamp
-- 	elseif defState == "2" then
-- 		-- 暴击的时候切换动作帧组
-- 		changeToAction = animation_hero_by_attack + _tcamp
-- 	elseif defState == "3" then
-- 		-- 格挡的时候切换动作帧组
-- 		--changeToAction = animation_hero_by_attack + _tcamp
-- 	end
	
	
-- 	if defenderST == "1" or defenderST == "2" or defenderST == "3" or 
-- 			defenderST == "4" or defenderST == "5" or
-- 			defenderST == "6" or
-- 			defenderST == "7" or defenderST == "8" or 
-- 			defenderST == "9" or
-- 			defenderST == "10" or defenderST == "11" or 
-- 			defenderST == "12" or defenderST == "14" then
-- 	elseif changeToAction ~= nil  and armatureBase._isDeath ~= true then
-- 		animationChangeToAction(armatureBase, changeToAction, animation_standby)
-- 	end
	
-- 	if armatureBase._isReact == true or defState == "3" or defState == "4" then
-- 		if armatureBase._isReacting ~= true then
-- 			armatureBase._isReacting = true
-- 			-- 已经进入到了反击
-- 			executeEffectSkillEnd(armature)
-- 		end
-- 	else
-- 		-- 修改BUFF处理状态(6为中毒，9为灼烧)
-- 		if (defenderST == "4" or defenderST == "5" or defenderST == "6" or defenderST == "7" or 
-- 			defenderST == "8" or defenderST == "9" or defenderST == "10" or defenderST == "11" or 
-- 			defenderST == "12" or defenderST == "13" or defenderST == "15") then
-- 			if armature._executeBuffs == nil then
-- 				armature._executeBuffs = {}
-- 			end
-- 			if armature._executeBuffs[armature._def.defenderST] ~= true then 
-- 				armature._executeBuffs[armature._def.defenderST] = true
-- 				-- 处理被攻击的后段光效
-- 				armature._base = armatureBase
-- 				executeEffectSkillEnd(armature)
-- 			end
-- 			if defenderST == "13" then
-- 				armatureBase._posTile._effectivenessId = 84
-- 			end
-- 		elseif defenderST == "2" or defenderST == "3" or 
-- 				-- defenderST == "4" or 
-- 				defenderST == "5" or
-- 				defenderST == "7" or defenderST == "8" or 
-- 				defenderST == "10" or defenderST == "11" or 
-- 				defenderST == "14" then
-- 		else
-- 			-- 处理被攻击的后段光效
-- 			armature._base = armatureBase
-- 			-- executeEffectSkillEnd(armature)
-- 		end
-- 	end
		
-- 	-- 处理伤害
-- 	-- 技能种类：0为攻击，1为加血，2为加怒，3为减怒，4为禁怒，5为眩晕，6为中毒，7为麻痹，8为封技，9为灼烧，10为爆裂，11为增加档格，12为增加防御, 13为必闪, 14为吸血,15禁疗
-- 	if defenderST == "0" or
-- 		defenderST == "6"
-- 		then
-- 		if tonumber(_def.defender) == 1 then
-- 			BattleSceneClass.curDamage = BattleSceneClass.curDamage + tonumber(drawString)
-- 		end
-- 		if tonumber(drawString) > 0  then
-- 			drawString = "-"..drawString
-- 		end
-- 	elseif defenderST == "1" or 
-- 		defenderST == "9" 
-- 		then
-- 		drawString = "+"..drawString
-- 	end
	
-- 	if (defenderST == "2" or defenderST == "3") and (armatureBase~= nil and armatureBase._role ~= nil) then
-- 		if _def.stVisible == "1" and defState ~= "1" and defState ~= "5" then
-- 			armatureBase._role._sp = armatureBase._role._sp + ((defenderST == "2" and 1 or -1) * tonumber(drawString))
-- 			if armatureBase._role._sp < 0 then
-- 				armatureBase._role._sp = 0
-- 			end
-- 			showRoleSP(armatureBase)
-- 		end
-- 	end
	
	
-- 	local numberFilePath = nil
-- 	-- 0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格
-- 	if defState == "0" or defState == "3" or defState == "4" then
-- 		-- 命中
-- 		if defenderST == "1" or defenderST == "14" then
-- 			numberFilePath = "images/ui/number/jiaxue.png"
-- 			if armatureBase._role._hp ~= nil and drawString ~= nil and drawString ~= "" then 
-- 				armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
-- 			end
-- 			showRoleHP(armatureBase)
-- 		elseif defenderST == "2" or defenderST == "3" or 
-- 			defenderST == "4" or defenderST == "5" or defenderST == "6" or 
-- 			defenderST == "7" or defenderST == "8" or defenderST == "9" or 
-- 			defenderST == "10" or defenderST == "11" or defenderST == "12" or defenderST == "13" or defenderST == "15" then
-- 		else
-- 			numberFilePath = "images/ui/number/xue.png"
-- 			armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
-- 			showRoleHP(armatureBase)
-- 		end
-- 	elseif defState == "1" then
-- 		if defenderST == "0" then
-- 			-- 闪避
-- 			local miss = cc.Sprite:create("images/ui/battle/shanbi.png")
-- 			miss:setAnchorPoint(cc.p(0.5, 0.5))
-- 			miss:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
-- 			_widget:getParent():addChild(miss, kZOrderInMap_Hurt)
			
-- 			local seq = cc.Sequence:create(
-- 				cc.MoveBy:create(0.2 * actionTimeSpeed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
-- 				cc.CallFunc:create(removeFrameObjectFuncN)
-- 			)
-- 			miss:runAction(seq)
-- 			cleanBuffEffectWithMiss(armatureBase._posTile,true)
-- 		end
-- 	elseif defState == "2" or defState == "4" then
-- 		if armature._hnb ~= true then
-- 			if defenderST == "1" then
-- 				numberFilePath = "images/ui/number/baoji.png"
-- 			else
-- 				numberFilePath = "images/ui/number/baoji.png"
-- 			end
-- 			--armature._hnb = true
-- 			armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
-- 			showRoleHP(armatureBase)
-- 		end
-- 	elseif defState == "3" then
-- 		-- 格挡
-- 	---elseif defState == "4" then
-- 		-- 暴击加挡格
-- 	end
	
-- 	if defenderST == "2" or defenderST == "3" then
-- 		if _def.stVisible == "1"  and  defState ~= "1" and defState ~= "5" then
-- 			-- 怒气动画
-- 			local spSprite = cc.Sprite:create(string.format("images/ui/battle/%s.png", defenderST == "2" and "nuqijia" or "nuqijian"))
-- 			spSprite:setAnchorPoint(cc.p(0.5, 0.5))
-- 			spSprite:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
-- 			_widget:getParent():addChild(spSprite, kZOrderInMap_Hurt)
			
-- 			local seq = cc.Sequence:create(
-- 				cc.MoveBy:create(0.5 * actionTimeSpeed, cc.p(0, (defenderST == "2" and 1 or -1) * 100 / CC_CONTENT_SCALE_FACTOR())),
-- 				cc.CallFunc:create(removeFrameObjectFuncN)
-- 			)
-- 			spSprite:runAction(seq)
-- 		end
-- 	end
	
-- 	local labelAtlas = nil
-- 	if numberFilePath ~= nil and drawString~= nil then
-- 		labelAtlas = cc.LabelAtlas:_create(drawString, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
-- 		-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
-- 		labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
-- 		labelAtlas:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0 + armature._hurtCount * ( 4))) 
-- 		_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt)
		
-- 		if defState == "2" or defState == "4" then
-- 			local crit = cc.Sprite:create("images/ui/battle/baoji.png")
-- 			crit:setAnchorPoint(cc.p(0.5, 0.5)) 
-- 			labelAtlas:addChild(crit, kZOrderInMap_Hurt)
-- 			crit:setPosition(cc.p(labelAtlas:getContentSize().width/2, crit:getContentSize().height + labelAtlas:getContentSize().height/2))
-- 		end
		
-- 		local seq = nil
-- 		if defState == "0" then
-- 			seq = cc.Sequence:create(
-- 				cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 2),
-- 				cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 1.0),
-- 				cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
-- 				cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
-- 				cc.CallFunc:create(removeFrameObjectFuncN)
-- 			)
-- 		else
-- 			seq = cc.Sequence:create(
-- 				cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
-- 				cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
-- 				cc.CallFunc:create(removeFrameObjectFuncN)
-- 			)
-- 		end	
-- 		labelAtlas:runAction(seq)
	
-- 	end
	
-- 	if defenderST == "0" then
-- 		armature._hurtCount = armature._hurtCount + 1
-- 	end
	
-- 	-- 进入死亡状态
-- 	if defAState == "1" and armatureBase ~= nil and 
-- 		armatureBase._isDeath ~= true then
-- 		executeRoleDeath(armatureBase)
-- 	end
-- end

-- local function excecuteFrameEvent(armatureBack, armatureBase, bone,evt,originFrameIndex,currentFrameIndex)
-- 	local armature = armatureBack
--> print("evt:", evt)
--> if evt ~= nil and #evt > 0 then
-- 		-- local datas = zstring.split(evt, "_")
-- 		-- print(evt)
--> if datas[1] == "start" then
-- 			-- if armature._angle ~= nil then
-- 				-- -- 创建飞行的光效
-- 				-- createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
-- 			-- end
-- 			-- if datas[2] ~= "hurt" then
--> print("无需掉血，跳出事件帧的处理")
-- 				-- return
-- 			-- end
-- 		-- end
-- 	-- elseif evt ~= "hurt" then
-- 		-- return
-- 	-- end

-- 	armature._hurtCount = armature._hurtCount == nil and 0 or armature._hurtCount
-- 	local _widget = armatureBase._posTile
-- 	if _widget == nil then
-- 		return
-- 	end
-- 	if armatureBase._defs ~= nil then
-- 		for i, v in pairs(armatureBase._defs) do
-- 			drawFrameEvent(armature, armatureBase, v, bone,evt,originFrameIndex,currentFrameIndex)
-- 		end
-- 	else
-- 		drawFrameEvent(armature, armatureBase, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
-- 	end
-- end
	
-- onFrameEvent = function(bone,evt,originFrameIndex,currentFrameIndex)
-- 	--local info = string.format("(%s) emit a frame event (%s) originFrame(%d)at frame index (%d).",bone:getName(),evt,originFrameIndex, currentFrameIndex)
	
-- 	--if originFrameIndex ~= currentFrameIndex then
-- 	--	return
-- 	--end
	
-- 	-- 绘制伤害数值
-- 	local armature = bone:getArmature()--._base
-- 	local armatureBase = armature._base
	

-- 	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
-- 	local _def = armature._def == nil and armatureBase._def or armature._def
-- 	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
-- 	--[[
-- 	if _def._attackSection <= 0 then
-- 		return
-- 	end
-- 	_def._attackSection = _def._attackSection - 1
-- 	--]]
	
-- 	excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
	
-- end

-- onFrameEvent1 = function(bone,evt,originFrameIndex,currentFrameIndex)
-- 	onFrameEvent3(bone,evt,originFrameIndex,currentFrameIndex)
-- end

-- onFrameEvent2 = function(bone,evt,originFrameIndex,currentFrameIndex)
-- 	onFrameEvent3(bone,evt,originFrameIndex,currentFrameIndex)
-- end

-- onFrameEvent3 = function(bone,evt,originFrameIndex,currentFrameIndex)
-- 	--local info = string.format("(%s) emit a frame event (%s) originFrame(%d)at frame index (%d).",bone:getName(),evt,originFrameIndex, currentFrameIndex)
-- 	-- 处理全屏伤害
	
-- 	--if originFrameIndex ~= currentFrameIndex then
-- 	--	return
-- 	--end
-- 	local armature = bone:getArmature()--._base
-- 	local armatureBase = armature._base

	
-- 	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
-- 	local _def = armature._def == nil and armatureBase._def or armature._def
-- 	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
-- 	local attackSection = dms.atoi(_sie, skill_influence.attack_section)
-- 	local executeDrawEffect = true
-- 	-- 处理光效在对方阵营中心的伤害处理
-- 	local erole = {}
-- 	for w = 1, _skf.defenderCount do
-- 		local _def = _skf._defenders[w]
-- 		local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
-- 		local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
-- 		local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
-- 		local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
-- 		local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
-- 		local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
-- 		local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
		
-- 		local rPad = getRolePad(defender, defenderPos)
		
-- 		if rPad._armature ~= nil then
-- 			rPad._armature._def = nil
-- 			rPad._armature._defs = nil
-- 			resetArmatureData()
-- 		end
-- 	end
	
-- 	for w = 1, _skf.defenderCount do
-- 		local _def = _skf._defenders[w]
-- 		local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
-- 		local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
-- 		local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
-- 		local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
-- 		local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
-- 		local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
-- 		local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
		
-- 		local rPad = getRolePad(defender, defenderPos)
-- 		if rPad._armature ~= nil then
-- 			if defenderST == "0" then
-- 				rPad._armature._def = _def
-- 				rPad._armature._sie = _sie
-- 			end
			
-- 			--擎天柱普攻多打一次BUG
-- 			-- _def._attackSection = _skf._attackSection
			
-- 			rPad._armature._def = _def
-- 			rPad._armature._sie = _sie
-- 			if rPad._armature._defs == nil then
-- 				rPad._armature._defs = {}
-- 			end
			
-- 			rPad._armature._defs[table.getn(rPad._armature._defs) + 1] = _def
			
-- 			rPad._armature._base = rPad._armature
			
-- 			if _def.defenderST == "6" then
-- 				-- 6为中毒
-- 			elseif  _def.defenderST == "9" then
-- 				-- 9为灼烧
-- 			end
-- 			-- 根据攻击的段数，重新赋伤害
-- 			if tonumber(_def.stValue) > 0 and attackSection > 0 then
-- 				-- _def.stValue = ""..string.format("%d", math.floor(tonumber(_def.stValue)/attackSection))
-- 				_skf._defenders[w].subValue = ""..string.format("%d", math.floor(tonumber(_def.stValue)/attackSection))
-- 			end
			
-- 			if executeDrawEffect == true and defenderST == "0" then
-- 				-- 启动技能中段
-- 				--executeEffectSkilling(rPad._armature)
-- 			end
			
-- 			if _def.defAState == "1" then
-- 				local dropCount = _def.dropCount 	-- = npos(list)		--(死亡时传)掉落卡片数量
-- 			elseif _def.defAState == "2" then 
-- 				rPad._armature._isReact = true
-- 				--[[
-- 				local fightBackFlag = _def.fightBackFlag 		-- = npos(list)	-- (反击时传)反击承受方的标识 
-- 				local fightBackPos = _def.fightBackPos 			-- = npos(list)	-- 反击承受方的位置 
-- 				local fightBackSkf = _def.fightBackSkf 			-- = npos(list)	-- 反击承受方的作用效果 
-- 				local fightBackValue = _def.fightBackValue 		-- = npos(list)	-- 反击承受方的作用值 
-- 				local fightBackRound = _def.fightBackRound 		-- = npos(list)	-- 反击承受方的持续回合
-- 				local fightBackDefState = _def.fightBackDefState -- = npos(list)	-- 反击承受方的承受状态 
-- 				local fightBackLiveState = _def.fightBackLiveState -- = npos(list)--反击承受方生存状态 (0:存活 1:死亡)
-- 				if _def.fightBackDefState == "1" then
-- 					local fightBackDropCardCount = _def.fightBackDropCardCount -- = npos(list)			-- (死亡时传)掉落卡片数量
-- 				end
-- 				if armatureBase._reactor == nil then
-- 					armatureBase._reactor = rPad._armature
-- 					armatureBase._defr = _def
-- 				end
-- 				--]]
-- 			end
-- 			--if executeDrawEffect == true and defenderST == "0" then
-- 			--	excecuteFrameEvent(rPad._armature, rPad._armature, bone,evt,originFrameIndex,currentFrameIndex)
-- 			--end
-- 			erole[""..defender..">"..defenderPos] = rPad._armature
-- 		end
-- 	end
-- 	for i, v in pairs(erole) do
-- 		excecuteFrameEvent(v , v, bone,evt,originFrameIndex,currentFrameIndex)
-- 	end
-- end
	
-- onFrameEvent4 = function(bone,evt,originFrameIndex,currentFrameIndex)
-- 	--local info = string.format("(%s) emit a frame event (%s) at frame index (%d).",bone:getName(),evt,currentFrameIndex)
	
-- 	--if originFrameIndex ~= currentFrameIndex then
-- 	--	return
-- 	--end
	
-- 	-- 绘制伤害数值
-- 	local armature = bone:getArmature()--._base
-- 	local armatureBase = armature._base
	

-- 	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
-- 	local _def = armature._def == nil and armatureBase._def or armature._def
-- 	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
-- 	excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
-- end

	
-- onFrameEvent5 = function(bone,evt,originFrameIndex,currentFrameIndex)
-- 	--local info = string.format("(%s) emit a frame event (%s) at frame index (%d).",bone:getName(),evt,currentFrameIndex)
-- 	--if originFrameIndex ~= currentFrameIndex then
-- 	--	return
-- 	--end
	
-- 	-- 绘制伤害数值
-- 	local armature = bone:getArmature()--._base
-- 	local armatureBase = armature._base
	
-- 	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
-- 	local _def = armature._def == nil and armatureBase._def or armature._def
-- 	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
-- 	excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
-- end

-- onFrameEvent6 = function(bone,evt,originFrameIndex,currentFrameIndex)
-- 	--local info = string.format("(%s) emit a frame event (%s) at frame index (%d).",bone:getName(),evt,currentFrameIndex)
-- 	--if originFrameIndex ~= currentFrameIndex then
-- 	--	return
-- 	--end
	
-- 	-- 绘制伤害数值
-- 	local armature = bone:getArmature()--._base
-- 	local armatureBase = armature._base
	

-- 	local _skf = armature._skf == nil and armatureBase._skf or armature._skf
-- 	local _def = armature._def == nil and armatureBase._def or armature._def
-- 	local _sie = armature._sie == nil and armatureBase._sie or armature._sie
	
-- 	excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
-- end

-- -- END~技能技能光效帧事件监听
-- -- --------------------------------------------------------------------- --

-- -- --------------------------------------------------------------------- --
-- -- 技能光效处理

-- local function excuteSPSkillEffectOver(armatureBack)
-- 	deleteEffectFile(armatureBack)
-- 	executeHeroMoveToTarget()
-- end

-- local function excuteSPSkillEffect(posTile, armatureBack)
-- 	local shipEffect = -1
-- 	local effectName = -1
-- 	if armatureBack._brole._type == "0" then
-- 		effectName = dms.string(dms["ship_mould"], armatureBack._brole._mouldId, ship_mould.screen_attack_effect)
-- 		if zstring.tonumber(armatureBack._brole._head) < 10000 then
-- 			shipEffect = effectName
-- 		else
-- 			shipEffect = armatureBack._brole._head
-- 		end
-- 	else
-- 		effectName = dms.string(dms["environment_ship"], armatureBack._brole._mouldId, environment_ship.screen_attack_effect)
-- 		shipEffect = effectName
-- 	end

--> print("怒气特效的绘制", shipEffect)
-- 	if shipEffect ~= nil and tonumber(shipEffect) > -1 then
-- 		-- playEffect(formatMusicFile("effect", 9994))
-- 		local skillName =  dms.string(dms["skill_mould"], armatureBack._currentSkillMouldId, skill_mould.skill_name)
-- 		local size = posTile:getContentSize()
		
-- 		local armature = ccs.Armature:create("hero_head_effect")
		
-- 		armature:getAnimation():playWithIndex(animation_standby)
-- 		armature:setPosition(cc.p(size.width/2, size.height/2))
-- 		armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
-- 		--armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
-- 		armature._invoke = excuteSPSkillEffectOver
-- 		posTile:addChild(armature)

-- 		local  imagePath = ""
-- 		if tonumber(armatureBack._brole._power_skill_id) > 0 then
-- 			imagePath = string.format("images/face/rage_head/rage_name_%s.png", armatureBack._brole._power_skill_id) 
-- 		else
-- 			imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectName) 
-- 		end
-- 		local skill_name = ccs.Skin:create(imagePath)
-- 		armature:getBone("skill_name"):addDisplay(skill_name, 0)
-- 	else
-- 		executeHeroMoveToTarget()
-- 	end
-- end

-- -- 加载光效资源文件
-- -- effect_6006.ExportJson
-- loadEffectFile = function(fileIndex)
-- 	local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
-- 	--CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
-- 	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
-- 	local armatureName = string.format("effice_%d", fileIndex)
-- 	return armatureName, fileName
-- end

-- deleteEffectFile = function(armatureBack)
-- 	-- 删除光效
-- 	armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns
-- 	if armatureBack._LastsCountTurns <= 0 then
-- 		local fileName = armatureBack._fileName
-- 		if m_tOperateSystem == 5 then
-- 			if fileName ~= nil then
-- 				CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
-- 			end
-- 		end
-- 			if armatureBack.getParent ~= nil then
-- 				if armatureBack:getParent() ~= nil then
-- 					if armatureBack.removeFromParent ~= nil then
-- 						armatureBack:removeFromParent(true)
-- 					end
-- 				end
-- 			end
-- 		if m_tOperateSystem == 5 then
-- 			-- draw.cleanMemory()
-- 			-- draw.cleanCacheMemory()
-- 			-- CCArmatureDataManager:purge()
			
-- 			CCSpriteFrameCache:purgeSharedSpriteFrameCache()
-- 			CCTextureCache:sharedTextureCache():removeUnusedTextures()
-- 		end
-- 	end
-- end

-- createEffect = function(armaturePad, fileIndex, _camp, addToTile)
-- 	-- 创建光效
-- 	local armatureName, fileName = loadEffectFile(fileIndex)
-- 	local posTile = armaturePad
-- 	local armature = ccs.Armature:create(armatureName)
-- 	armature._fileName = fileName
-- 	local tempX, tempY  = posTile:getPosition()
-- 	armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2, tempY + posTile:getContentSize().height/2))

-- 	local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
-- 	local _tcamp = zstring.tonumber("".._camp)
-- 	local _armatureIndex = frameListCount * _tcamp
--> print("frameListCount->", frameListCount, _camp, _armatureIndex)
-- 	armature:getAnimation():playWithIndex(_armatureIndex)
-- 	armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
-- 	if addToTile == true then
-- 		armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
-- 		posTile:addChild(armature, kZOrderInMap_Effect)
-- 	else	
-- 		posTile:getParent():addChild(armature, kZOrderInMap_Effect)
-- 	end
-- 	armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	
-- 	local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
-- 	armature._duration = duration / 60.0
-- 	return armature
-- end

-- createEffectExt = function(armaturePad, fileIndex, _camp, addToTile, index, totalCount)
-- 	-- 创建光效
-- 	local armatureName, fileName = loadEffectFile(fileIndex)
-- 	local posTile = armaturePad
-- 	local armature = ccs.Armature:create(armatureName)
-- 	armature._fileName = fileName
-- 	local tempX, tempY  = posTile:getPosition()
-- 	armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2, tempY + posTile:getContentSize().height/2))
-- 	local armatureIndex = totalCount * ((_camp + 1)%2) + index
--> print("createEffectExt->:", armatureIndex, _camp, index)
-- 	armature:getAnimation():playWithIndex(armatureIndex)
-- 	armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
-- 	if addToTile == true then
-- 		armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
-- 		posTile:addChild(armature, kZOrderInMap_Effect)
-- 	else	
-- 		posTile:getParent():addChild(armature, kZOrderInMap_Effect)
-- 	end
-- 	armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
-- 	return armature
-- end

-- -- 技能光效前段
-- executeEffectSkillBegan = function(armatureBack)
-- 	local armature = armatureBack
-- 	local skillInfluenceElementData = armature._sie
-- 	-- local forepart_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.forepart_lighting_effect_id)
	
-- 	local camp = zstring.tonumber(armature._camp) + 1
-- 	local effectIds = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.forepart_lighting_effect_id), ",")
-- 	local effectId = zstring.tonumber(indexs[camp])
--> print("技能光效前段:", effectId)
-- 	if forepart_lighting_effect_id >= 0 then
-- 		local armatureEffect = createEffect(armature._posTile, forepart_lighting_effect_id, armature._posTile._camp)
-- 		armatureEffect._invoke = deleteEffectFile
-- 		armatureEffect._base = armature
-- 	else
-- 		--executeAttacking()
-- 	end
-- 	local forepart_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.forepart_lighting_sound_effect_id)

-- 	if forepart_lighting_sound_effect_id >= 0 then
-- 		playEffectMusic(forepart_lighting_sound_effect_id)
-- 	end
-- end

--> 技能光效中段
-- local function executeEffectSkillingOver(armatureBack)
-- 	-- 准备清除技能光中段资源
-- 	deleteEffectFile(armatureBack)
-- 	executeHeroMoveToOriginTarget()
		
-- 	if BattleSceneClass._hasWidgetBg == true or BattleSceneClass._effectBg ~= nil then
-- 		BattleSceneClass._effectBg:removeFromParent(true)
-- 		BattleSceneClass._effectBg = nil
-- 		BattleSceneClass._hasWidgetBg = nil
-- 	end		
-- end

	
-- local function onMoveFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
-- 	-- local info = string.format("(%s) emit a frame event (%s) originFrame(%d)at frame index (%d).", bone:getName(),evt,originFrameIndex, currentFrameIndex)
--> print("onMoveFrameEvent:(info)->", info)
-- 	local pos = string.find(evt, "start_move_")
--     if pos ~= nil then
--     	local stime = string.sub(evt, pos+#"start_move_", #evt)
--> print("stime:", stime)
--     	if stime ~= nil and #stime > 0 then
-- 			local armature = bone:getArmature()
--> print(tonumber(stime) / 60)
-- 			armature:runAction(cc.MoveTo:create(tonumber(stime) / 60, armature._move_position))
-- 			-- armature:runAction(cc.MoveTo:create(tonumber(stime) * 60 / 1000, cc.p(100, 500)))
--     	end
--     end
-- end

-- local function createMovePathEffect(armatureBack, isBaseArmature)
-- 	local armature = armatureBack
-- 	local backPad = armature._posTile

--> print("backPad, mPosTile", backPad, mPosTile, backPad._camp, mPosTile._camp)


-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)

-- 	local armatureEffect = createEffectExt(backPad, posterior_lighting_effect_id, backPad._camp)
--> print("getMovementCount:", armatureEffect:getAnimation():getMovementCount(), 
-- 		armatureEffect:getAnimation():getAnimationData():getMovementCount())
-- 	armatureEffect._base = armature
-- 	armatureEffect._sie = armature._sie
-- 	armatureEffect._def = armature._def
-- 	if isBaseArmature == true then
-- 		if armature._sie == nil then
-- 			armatureEffect._invoke = deleteEffectFile
-- 		else
-- 			armatureEffect._invoke = executeEffectSkillingOver
-- 			armatureEffect:getAnimation():setFrameEventCallFunc(onMoveFrameEvent)
-- 		end
-- 	else
-- 		armatureEffect._invoke = deleteEffectFile
-- 		armatureEffect:getAnimation():setFrameEventCallFunc(onMoveFrameEvent)
-- 	end
	
-- 	--[[
-- 		0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 		1基于施放者位置（只绘制一个光效）
-- 		2基于承受者位置（根据目标数量绘制光效）
-- 		3基于对方阵营中心（只绘制一个光效）
-- 		4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 		5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 		6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 	--]]
-- 	local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
-- 	-- 处理角度和路径
-- 	local start_pos = nil
-- 	local end_pos = nil
-- 	local langle = 0
-- 	if armatureBack._isByReact == true then
-- 		start_pos = cc.p(armatureBack._reactor._posTile:getPosition())
-- 		end_pos = cc.p(mPosTile:getPosition())
-- 		if armatureBack._reactor._posTile._camp == "1" then
-- 			langle = -180
-- 		end
-- 	else
-- 		start_pos = cc.p(mPosTile:getPosition())
-- 		end_pos = cc.p(armature._posTile:getPosition())
-- 		if mPosTile._camp == "1" then
-- 			langle = -180
-- 		end
-- 	end
-- 	local angle = ccaf(start_pos, end_pos)+langle
-- 	if angle >= 180 then
-- 		angle = 180 - angle
-- 	end
-- 	if angle <= -180 then
-- 		angle = 180 - (180 - angle)
-- 	end
-- 	if angle == langle and langle < 0 then
-- 		angle = 0
-- 	end
-- 	local pSize = mPosTile:getContentSize()
-- 	start_pos.x = start_pos.x + pSize.width/2
-- 	start_pos.y = start_pos.y + pSize.height/2
-- 	end_pos.x = end_pos.x + pSize.width/2
-- 	end_pos.y = end_pos.y + pSize.height/2
	
-- 	armatureEffect:setRotation(angle)
-- 	armatureEffect:setPosition(start_pos)
-- 	-- armatureEffect._move_action = cc.MoveTo:create(3, end_pos) --cc.MoveTo:create(armatureEffect._duration, end_pos)
-- 	-- armatureEffect._move_action:retain()
-- 	armatureEffect._move_position = end_pos
-- end

-- local function createFlyingEffect(index, totalCount, bone,evt,originFrameIndex,currentFrameIndex)
-- 	local armature = bone:getArmature()
-- 	local backPad = armature._posTile

-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)

-- 	local armatureEffect = createEffectExt(backPad, posterior_lighting_effect_id, backPad._camp, false, index, totalCount)
-- 	armatureEffect._base = armature
-- 	armatureEffect._sie = armature._sie
-- 	armatureEffect._def = armature._def
-- 	armatureEffect._invoke = deleteEffectFile
-- 	armatureEffect:getAnimation():setFrameEventCallFunc(onMoveFrameEvent)

-- 	local angle = armature._angle
-- 	local start_pos = armature._start_position
-- 	local _end_position = armature._end_position

--> print("_end_position:", index, totalCount, armature._angle, start_pos.x, start_pos.y, _end_position.x, _end_position.y)

-- 	armatureEffect:setRotation(angle)
-- 	armatureEffect:setPosition(start_pos)
-- 	-- armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))

-- 	armatureEffect._move_position = _end_position
-- end

-- createFlyingEffects = function(bone,evt,originFrameIndex,currentFrameIndex)
-- 	local armature = bone:getArmature()
-- 	-- local frameListCount = math.ceil(armature:getAnimation():getAnimationData():getMovementCount() / 2)
-- 	local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
--> print("创建飞行光效", frameListCount)
-- 	for i=2,frameListCount do
--> ("创建飞行光效kkk", i-1)
-- 		createFlyingEffect(i - 1, frameListCount, bone,evt,originFrameIndex,currentFrameIndex)
-- 	end
-- end

-- local function executeEffectSkillingExt(armatureBack)
-- 	local armature = armatureBack
-- 	local backPad = armature._posTile

-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
-- 	if posterior_lighting_effect_id >= 0 then		
-- 		local count = 4
-- 		for i=1,10 do
-- 			createMovePathEffect(armatureBack)
-- 		end
-- 	else
-- 		if armature._defs ~= nil then
-- 			for i, v in pairs(armature._defs) do
-- 				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
-- 			end
-- 			resetArmatureData(armature)
-- 		else
-- 			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
-- 			resetArmatureData(armature)
-- 		end
-- 		executeHeroMoveToOriginTarget()
-- 	end
-- 	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
-- 	if posterior_lighting_sound_effect_id >= 0 then
-- 		playEffectMusic(posterior_lighting_sound_effect_id)
-- 	end
-- end

-- executeEffectSkilling = function(armatureBack)
-- 	local armature = armatureBack
-- 	local backPad = armature._posTile
-- 	-- 技能光效中段
-- 	--local armatureBase = armature._base
-- 	-- deleteEffectFile(armature)
	
-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
-- 	if posterior_lighting_effect_id >= 0 then		
-- 		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or mPosTile._camp)
-- 		-- local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
-- 		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, 0)
-- 		armatureEffect._posTile = backPad
-- 		armatureEffect._base = armature
-- 		armatureEffect._sie = armature._sie
-- 		armatureEffect._def = armature._def
-- 		if armature._sie == nil then
-- 			armatureEffect._invoke = deleteEffectFile
-- 		else
-- 			armatureEffect._invoke = executeEffectSkillingOver
-- 			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)
-- 		end
		
-- 		--[[
-- 			0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 			1基于施放者位置（只绘制一个光效）
-- 			2基于承受者位置（根据目标数量绘制光效）
-- 			3基于对方阵营中心（只绘制一个光效）
-- 			4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 		--]]
-- 		if armatureBack._sie ~= nil then
-- 			local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
-- 			-- 处理角度和路径
-- 			local start_pos = nil
-- 			local end_pos = nil
-- 			local langle = 0
-- 			if armatureBack._isByReact == true then
-- 				start_pos = cc.p(armatureBack._reactor._posTile:getPosition())
-- 				end_pos = cc.p(mPosTile:getPosition())
-- 				if armatureBack._reactor._posTile._camp == "1" then
-- 					langle = -180
-- 				end
-- 			else
-- 				start_pos = cc.p(mPosTile:getPosition())
-- 				end_pos = cc.p(armature._posTile:getPosition())
-- 				if mPosTile._camp == "1" then
-- 					langle = -180
-- 				end
-- 			end
-- 			local angle = ccaf(start_pos, end_pos)+langle
-- 			if angle >= 180 then
-- 				angle = 180 - angle
-- 			end
-- 			if angle <= -180 then
-- 				angle = 180 - (180 - angle)
-- 			end
-- 			if angle == langle and langle < 0 then
-- 				angle = 0
-- 			end
-- 			local pSize = mPosTile:getContentSize()
-- 			start_pos.x = start_pos.x + pSize.width * mPosTile:getScaleX()/2
-- 			start_pos.y = start_pos.y + pSize.height * mPosTile:getScaleY()/2
-- 			end_pos.x = end_pos.x + pSize.width * armature._posTile:getScaleX()/2
-- 			end_pos.y = end_pos.y + pSize.height * armature._posTile:getScaleY()/2
			
-- 			if lightingEffectDrawMethod == 0 then
-- 				armatureEffect:setRotation(angle)
-- 				armatureEffect:setPosition(start_pos)
-- 				armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))

-- 				armatureEffect._angle = angle
-- 				armatureEffect._start_position = start_pos
-- 				armatureEffect._end_position = end_pos
-- 			elseif lightingEffectDrawMethod == 7 then
-- 				armatureEffect:setRotation(angle)
-- 				armatureEffect:setPosition(start_pos)
-- 			elseif lightingEffectDrawMethod == 1 then
-- 				armatureEffect:setPosition(start_pos)
-- 			end
-- 		end
-- 	else
-- 		if armature._defs ~= nil then
-- 			for i, v in pairs(armature._defs) do
-- 				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
-- 			end
-- 			resetArmatureData(armature)
-- 		else
-- 			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
-- 			resetArmatureData(armature)
-- 		end
-- 		executeHeroMoveToOriginTarget()
-- 	end
-- 	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
-- 	if posterior_lighting_sound_effect_id >= 0 then
-- 		playEffectMusic(posterior_lighting_sound_effect_id)
-- 	end
-- end

-- executeEffectSkilling1 = function(armatureBack)
-- 	local armature = armatureBack
-- 	local backPad = armature._posTile
-- 	--local armatureBase = armature._base
-- 	-- deleteEffectFile(armature)
	
-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
-- 	if posterior_lighting_effect_id >= 0 and backPad~= nil then		
-- 		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or mPosTile._camp)
-- 		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
-- 		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
-- 		armatureEffect._posTile = backPad
-- 		armatureEffect._base = armature
-- 		armatureEffect._sie = armature._sie
-- 		armatureEffect._def = armature._def
-- 		armatureEffect._skf = armature._skf
-- 		if armature._sie == nil then
-- 			armatureEffect._invoke = deleteEffectFile
-- 		else
-- 			armatureEffect._invoke = executeEffectSkillingOver
-- 			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent1)
-- 		end
		
-- 		--[[
-- 			0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 			1基于施放者位置（只绘制一个光效）
-- 			2基于承受者位置（根据目标数量绘制光效）
-- 			3基于对方阵营中心（只绘制一个光效）
-- 			4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 		--]]
		
-- 		local xx, yy = backPad:getPosition()
-- 		local pSize = backPad:getContentSize()
-- 		--armatureEffect:setPosition(cc.p(xx + pSize.width/2, yy + pSize.height/2 * ((tonumber(backPad._camp + 1) % 2 == 0 and 1 or -1)))
-- 		armatureEffect:setPosition(cc.p(xx + pSize.width/2, yy + pSize.height/2 + pSize.height/2 * (backPad._camp=="0" and 1 or -1)))
-- 	else
-- 		if armature._defs ~= nil then
-- 			for i, v in pairs(armature._defs) do
-- 				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
-- 			end
-- 			resetArmatureData(armature)
-- 		else
-- 			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
-- 			resetArmatureData(armature)
-- 		end
-- 		executeHeroMoveToOriginTarget()	
-- 	end
-- 	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
-- 	if posterior_lighting_sound_effect_id >= 0 then
-- 		playEffectMusic(posterior_lighting_sound_effect_id)
-- 	end
-- end

-- executeEffectSkilling2 = function(armatureBack)

-- end

-- executeEffectSkilling3 = function(armatureBack)
-- 	local armature = armatureBack
-- 	local backPad = armature._posTile
-- 	--local armatureBase = armature._base
-- 	-- deleteEffectFile(armature)
	
-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
-- 	if posterior_lighting_effect_id >= 0 then		
-- 		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
-- 		armatureEffect._posTile = backPad
-- 		armatureEffect._base = armature
-- 		armatureEffect._sie = armature._sie
-- 		armatureEffect._def = armature._def
-- 		armatureEffect._skf = armature._skf
-- 		if armature._sie == nil then
-- 			armatureEffect._invoke = deleteEffectFile
-- 		else
-- 			armatureEffect._invoke = executeEffectSkillingOver
-- 			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent3)
-- 		end
		
-- 		--[[
-- 			0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 			1基于施放者位置（只绘制一个光效）
-- 			2基于承受者位置（根据目标数量绘制光效）
-- 			3基于对方阵营中心（只绘制一个光效）
-- 			4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 		--]]
		
-- 		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
-- 		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		
-- 		if backPad._camp == "1" then
-- 			local posTile2 = getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_2", ofsetCount))
-- 			local xx2, yy2 = posTile2:getPosition()
-- 			local posTile5 = getRole(0, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_5", ofsetCount))
-- 			local xx5, yy5 = posTile5:getPosition()
-- 			local pSize = posTile5:getContentSize()
-- 			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy5 + (yy2 - yy5)))
			
-- 		else
-- 			local posTile2 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
-- 			local xx2, yy2 = posTile2:getPosition()
		
-- 			local posTile5 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
-- 			local xx5, yy5 = posTile5:getPosition()
-- 			local pSize = posTile5:getContentSize()
			
-- 			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy2 + (yy5 - yy2)))
-- 		end
		
-- 	else
-- 		if armature._defs ~= nil then
-- 			for i, v in pairs(armature._defs) do
-- 				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
-- 			end
-- 			resetArmatureData(armature)
-- 		else
-- 			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
-- 			resetArmatureData(armature)
-- 		end
-- 		executeHeroMoveToOriginTarget()
-- 	end
-- 	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
-- 	if posterior_lighting_sound_effect_id >= 0 then
-- 		playEffectMusic(posterior_lighting_sound_effect_id)
-- 	end
-- end

-- executeEffectSkilling4 = function(armatureBack)

-- end

-- executeEffectSkilling5 = function(armatureBack)
-- 	local armature = armatureBack
-- 	local backPad = armature._posTile
-- 	--local armatureBase = armature._base
-- 	-- deleteEffectFile(armature)
	
-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
-- 	if posterior_lighting_effect_id >= 0 then		
-- 		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
-- 		armatureEffect._posTile = backPad
-- 		armatureEffect._base = armature
-- 		armatureEffect._sie = armature._sie
-- 		armatureEffect._def = armature._def
-- 		armatureEffect._skf = armature._skf
-- 		if armature._sie == nil then
-- 			armatureEffect._invoke = deleteEffectFile
-- 		else
-- 			armatureEffect._invoke = executeEffectSkillingOver
-- 			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent5)
-- 		end
		
-- 		--[[
-- 			0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 			1基于施放者位置（只绘制一个光效）
-- 			2基于承受者位置（根据目标数量绘制光效）
-- 			3基于对方阵营中心（只绘制一个光效）
-- 			4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 		--]]
		
-- 		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
-- 	else
-- 		if armature._defs ~= nil then
-- 			for i, v in pairs(armature._defs) do
-- 				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
-- 			end
-- 			resetArmatureData(armature)
-- 		else
-- 			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
-- 			resetArmatureData(armature)
-- 		end
-- 		executeHeroMoveToOriginTarget()
-- 	end
-- 	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
-- 	if posterior_lighting_sound_effect_id >= 0 then
-- 		playEffectMusic(posterior_lighting_sound_effect_id)
-- 	end
-- end

-- executeEffectSkilling6 = function(armatureBack)
-- 	local armature = armatureBack
-- 	local backPad = armature._posTile
-- 	--local armatureBase = armature._base
-- 	-- deleteEffectFile(armature)
	
-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	 -- dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
-- 	if posterior_lighting_effect_id >= 0 then		
-- 		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
-- 		armatureEffect._posTile = backPad
-- 		armatureEffect._base = armature
-- 		armatureEffect._sie = armature._sie
-- 		armatureEffect._def = armature._def
-- 		armatureEffect._skf = armature._skf
-- 		if armature._sie == nil then
-- 			armatureEffect._invoke = deleteEffectFile
-- 		else
-- 			armatureEffect._invoke = executeEffectSkillingOver
-- 			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent6)
-- 		end
		
-- 		--[[
-- 			0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 			1基于施放者位置（只绘制一个光效）
-- 			2基于承受者位置（根据目标数量绘制光效）
-- 			3基于对方阵营中心（只绘制一个光效）
-- 			4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 		--]]
		
-- 		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
-- 		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
-- 		local attPosType = armature._skf.attPosType
-- 		if backPad._camp == "1" then
-- 			local posTile2 = getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_2", ofsetCount))
-- 			local xx2, yy2 = posTile2:getPosition()
-- 			local posTile5 = getRole(0, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_5", ofsetCount))
-- 			local xx5, yy5 = posTile5:getPosition()
-- 			local pSize = posTile5:getContentSize()
-- 			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy5 + (yy2 - yy5) + pSize.height/2))
			
-- 		else
-- 			local posTile2 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
-- 			local xx2, yy2 = posTile2:getPosition()
		
-- 			local posTile5 = getRole(1, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
-- 			local xx5, yy5 = posTile5:getPosition()
-- 			local pSize = posTile5:getContentSize()
			
-- 			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy2 + (yy5 - yy2) + pSize.height/2))
-- 		end
		
-- 	else
-- 		if armature._defs ~= nil then
-- 			for i, v in pairs(armature._defs) do
-- 				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
-- 			end
-- 			resetArmatureData(armature)
-- 		else
-- 			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
-- 			resetArmatureData(armature)
-- 		end
-- 		executeHeroMoveToOriginTarget()	
-- 	end
-- 	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
-- 	if posterior_lighting_sound_effect_id >= 0 then
-- 		playEffectMusic(posterior_lighting_sound_effect_id)
-- 	end
-- end

-- executeEffectSkilling7 = function(armatureBack, defArmatureBack)
-- 	local armature = armatureBack
-- 	local backPad = armature._posTile
-- 	--local armatureBase = armature._base
-- 	-- deleteEffectFile(armature)
	
-- 	local skillInfluenceElementData = armature._sie
-- 	local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	 -- dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	
-- 	if posterior_lighting_effect_id >= 0 then		
-- 		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or mPosTile._camp)
		
-- 		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
-- 		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
-- 		armatureEffect._posTile = backPad
-- 		armatureEffect._base = armature
-- 		armatureEffect._sie = armature._sie
-- 		armatureEffect._def = armature._def
-- 		armatureEffect._skf = armature._skf
-- 		if armature._sie == nil then
-- 			armatureEffect._invoke = deleteEffectFile
-- 		else
-- 			armatureEffect._invoke = executeEffectSkillingOver
-- 			armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent1)
-- 		end
		
-- 		--[[
-- 			0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 			1基于施放者位置（只绘制一个光效）
-- 			2基于承受者位置（根据目标数量绘制光效）
-- 			3基于对方阵营中心（只绘制一个光效）
-- 			4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 			5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 			6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 		--]]
		
-- 		if armatureBack._sie ~= nil and lightingEffectDrawMethod == 7 then
-- 			local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
-- 			-- 处理角度和路径
-- 			local start_pos = nil
-- 			local end_pos = nil
-- 			local langle = 0
-- 			if armatureBack._isByReact == true then
-- 				start_pos = cc.p(armatureBack._reactor._posTile:getPosition())
-- 				end_pos = cc.p(mPosTile:getPosition())
-- 				if armatureBack._reactor._posTile._camp == "1" then
-- 					langle = -180
-- 				end
-- 			else
-- 				start_pos = cc.p(mPosTile:getPosition())
-- 				end_pos = cc.p(defArmatureBack._posTile:getPosition())
-- 				if mPosTile._camp == "1" then
-- 					langle = -180
-- 				end
-- 			end
-- 			local angle = ccaf(start_pos, end_pos)+langle
-- 			if angle >= 180 then
-- 				angle = 180 - angle
-- 			end
-- 			if angle <= -180 then
-- 				angle = 180 - (180 - angle)
-- 			end
-- 			if angle == langle and langle < 0 then
-- 				angle = 0
-- 			end
			
-- 			local pSize = mPosTile:getContentSize()
-- 			start_pos.x = start_pos.x + pSize.width * mPosTile:getScaleX()/2
-- 			start_pos.y = start_pos.y + pSize.height * mPosTile:getScaleY()/2
-- 			end_pos.x = end_pos.x + pSize.width * armature._posTile:getScaleX()/2
-- 			end_pos.y = end_pos.y + pSize.height * armature._posTile:getScaleY()/2
			
-- 			if lightingEffectDrawMethod == 0 then
-- 				armatureEffect:setRotation(angle)
-- 				armatureEffect:setPosition(start_pos)
-- 				armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))

-- 				armatureEffect._angle = angle
-- 				armatureEffect._start_position = start_pos
-- 				armatureEffect._end_position = end_pos
-- 			elseif lightingEffectDrawMethod == 7 then
-- 				armatureEffect:setRotation(angle)
-- 				armatureEffect:setPosition(start_pos)
-- 			elseif lightingEffectDrawMethod == 1 then
-- 				armatureEffect:setPosition(start_pos)
-- 			end
-- 		else
-- 		end
		
-- 		local xx, yy = backPad:getPosition()
-- 		local pSize = backPad:getContentSize()
-- 		--armatureEffect:setPosition(cc.p(xx + pSize.width/2, yy + pSize.height/2 * ((tonumber(backPad._camp + 1) % 2 == 0 and 1 or -1)))
-- 		armatureEffect:setPosition(cc.p(xx + pSize.width/2, yy + pSize.height/2 + pSize.height/2 * (backPad._camp=="0" and 1 or -1)))
-- 	else
-- 		if armature._defs ~= nil then
-- 			for i, v in pairs(armature._defs) do
-- 				drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
-- 			end
-- 			resetArmatureData(armature)
-- 		else
-- 			drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
-- 			resetArmatureData(armature)
-- 		end
-- 		executeHeroMoveToOriginTarget()	
-- 	end
-- 	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
-- 	if posterior_lighting_sound_effect_id >= 0 then
-- 		playEffectMusic(posterior_lighting_sound_effect_id)
-- 	end
-- end


-- -- BUFF持续光效
-- local function executeBuffEffect(armatureBack)
-- --[[
-- 格挡反击技能ID 555 
-- 格挡调用光效ID 80
-- 禁怒调用持续光效ID 88
-- 眩晕（冰冻）调用持续光效ID 89
-- 麻痹（禁锢）调用持续光效ID 90
-- 封技（短路）调用持续光效ID 91
-- 中毒（腐蚀）调用持续光效ID 92
-- 灼烧（燃烧）调用持续光效ID 93
-- 爆裂状态调用持续光效ID 94（这个是天赋里会用到的）
-- 无敌（铁壁）、增加格挡率BUFF调用持续光效ID 95
-- -- 处理伤害
-- 	-- 技能种类：0为攻击，1为加血，2为加怒，3为减怒，4为禁怒，
-- 	5为眩晕，6为中毒，7为麻痹，8为封技，9为灼烧，10为爆裂，11为增加档格，12为增加防御，13必闪，14吸血，15禁疗
	
-- --]]
-- 	local armature = armatureBack
-- 	local backPad = armature._base._posTile
-- 	-- if backPad == nil then
-- 		-- return
-- 	-- end
-- 	local effectIndex = 0
-- 	if armatureBack._def ~= nil then
-- 		if armatureBack._def.defenderST == "4" then
-- 			effectIndex = 88
-- 		elseif armatureBack._def.defenderST == "5" then
-- 			effectIndex = 89
-- 		elseif armatureBack._def.defenderST == "6" then
-- 			effectIndex = 92
-- 		elseif armatureBack._def.defenderST == "7" then
-- 			effectIndex = 90
-- 		elseif armatureBack._def.defenderST == "8" then
-- 			effectIndex = 91
-- 		elseif armatureBack._def.defenderST == "9" then
-- 			effectIndex = 93
-- 		elseif armatureBack._def.defenderST == "10" then
-- 			effectIndex = 94
-- 		elseif armatureBack._def.defenderST == "11" then
-- 			effectIndex = 95
-- 		elseif armatureBack._def.defenderST == "12" then
-- 			effectIndex = 85
-- 		elseif armatureBack._def.defenderST == "13" then
-- 			effectIndex = 84
-- 		elseif armatureBack._def.defenderST == "15" then
-- 			effectIndex = 83
-- 		end
-- 	end
-- 	local armatureEffect = nil
-- 	if tonumber(armature._def.stRound) > 0 then
-- 		if backPad._buff == nil then
-- 			backPad._buff = {}
-- 		end
-- 		local tarmature = backPad._buff[armature._def.defenderST]
-- 		if tarmature ~= nil then
-- 			armatureEffect = tarmature
-- 			armatureEffect._base = armature._base
-- 			armatureEffect._sie = armature._sie
-- 			armatureEffect._def = armature._def
-- 			armatureEffect._LastsCountTurns = tonumber(armature._def.stRound)
-- 			armatureEffect._lastEffect = true
-- 		end
-- 	end
-- 	if armatureEffect == nil and effectIndex ~= 0 and tonumber(armature._def.stRound) > 0 then
-- 		armatureEffect = createEffect(backPad, effectIndex, backPad._camp, true)
-- 		armatureEffect._invoke = deleteEffectFile
-- 		armatureEffect._base = armature._base
-- 		armatureEffect._sie = armature._sie
-- 		armatureEffect._def = armature._def
-- 		armatureEffect._LastsCountTurns = tonumber(armature._def.stRound)
-- 		armatureEffect._lastEffect = true
-- 		-- armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)
-- 		if backPad._buff == nil then
-- 			backPad._buff = {}
-- 		end
-- 		if backPad._buff ~= nil then
-- 			backPad._buff[armature._def.defenderST] = armatureEffect
-- 		end
-- 	end
			
-- 	--armature._LastsCountTurns = nil
-- 	deleteEffectFile(armatureBack)
-- end

-- -- 技能光效后段
-- executeEffectSkillEnd = function(armatureBack)
-- 	local armature = armatureBack
-- 	local backPad = armature._base._posTile
-- 	-- 技能光效后段
-- 	-- local armatureBase = armature._base
-- 	-- deleteEffectFile(armature)
	
-- 	local skillInfluenceElementData = armature._sie
-- 	local bear_lighting_effect_id = armature._base._isReact == true 
-- 		and 80 
-- 		or getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.bear_lighting_effect_id)	-- dms.atoi(skillInfluenceElementData, skill_influence.bear_lighting_effect_id)

-- 	if bear_lighting_effect_id >= 0 then
-- 		armatureEffect = createEffect(backPad, bear_lighting_effect_id, backPad._camp)
-- 		armatureEffect._invoke = executeBuffEffect
-- 		armatureEffect._base = armature._base
-- 		armatureEffect._sie = armature._sie
-- 		armatureEffect._def = armature._def
-- 	end
-- 	local bear_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.bear_sound_effect_id)
-- 	if bear_sound_effect_id >= 0 then
-- 		playEffectMusic(bear_sound_effect_id)
-- 	end
-- end
-- -- END~技能技能光效前段
-- -- --------------------------------------------------------------------- --
-- local missTime = 0
-- local function cleanBattleHero()
-- 	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
-- 	missTime = 0
-- 	for i=1, 6 do
-- 		local hero = getRole(0, i) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", 0, i))
-- 		if hero._armature ~= nil and hero._armature._isDeath == true then
-- 			missTime = missTime + 1
-- 			hero._armature._isDeathed = true
-- 			hero._armature._actionIndex = death_buff
-- 			hero._armature._nextAction = death_buff_end
-- 			local _invoke = hero._armature._invoke
-- 			hero._armature._invoke = nil
-- 			hero._armature:getAnimation():playWithIndex(death_buff_end)
-- 			hero._armature._invoke = _invoke
-- 			-- tolua.cast(hero._armature, "CCNode"):removeFromParent(true)
-- 			-- cleanBuffEffect(hero._armature._posTile, true)
-- 		end
		
-- 		local master = getRole(1, i) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, i))
-- 		if master._armature ~= nil and master._armature._isDeath == true then
-- 			missTime = missTime + 1
-- 			master._armature._isDeathed = true
-- 			master._armature._actionIndex = death_buff
-- 			master._armature._nextAction = death_buff_end
-- 			local _invoke = master._armature._invoke
-- 			master._armature._invoke = nil
-- 			master._armature:getAnimation():playWithIndex(death_buff_end)
-- 			master._armature._invoke = _invoke
-- 			-- tolua.cast(master._armature, "CCNode"):removeFromParent(true)
-- 			-- cleanBuffEffect(master._armature._posTile, true)
-- 		end
-- 	end
-- end

-- -- --------------------------------------------------------------------- --
-- -- 攻击切帧控制

-- function deathBuff(armatureBack,armature)
-- 	armature._role._hp = 0
-- 	showRoleHP(armature)
-- 	if armatureBack._posTile._camp == "1" then
-- 		if armatureBack._isDeathed == true then
-- 			if armatureBack._def ~= nil then
-- 				-- local fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10866")
-- 				-- local str = fightRewardItemCount:getString()
-- 				-- str = ""..(zstring.tonumber(str) + zstring.tonumber(armatureBack._def.dropCount))
-- 				-- --tolua.cast(fightRewardItemCount,"Label"):setText(str)
-- 				-- fightRewardItemCount:setString(str)
-- 				state_machine.excute("fight_ui_update_battle_card_drop", 0, zstring.tonumber(armatureBack._def.dropCount))

-- 				if armatureBack ~= nil and armatureBack._def~=nil and armatureBack._def.dropCount~=nil then
-- 					if zstring.tonumber(armatureBack._def.dropCount) > 0 then
-- 						local armatureEffect = createEffect(armatureBack._posTile, 96, 0)
-- 						armatureEffect._invoke = deleteEffectFile
-- 					end
-- 				end
-- 			end
-- 			armature._posTile._armature = nil
-- 			armatureBack:removeFromParent(true)
-- 			cleanBuffEffect(armatureBack._posTile, true)
-- 		end
-- 		armatureBack._isDeathed = true
-- 		-- 敌方死亡，绘制战场的掉落！
-- 	else
-- 		armature._nextAction = animation_is_death
-- 	end
			
-- 	-- end
-- 	if isSkepBattle == true and setDeathArmatureCount >= 0 then
-- 		currentRoundIndex = _ED.attackData.roundCount
-- 		setDeathArmatureCount = -1
-- 		nextRoundBattle()
-- 	end
-- 	--[[
-- 		if setDeathArmatureCount > 0 then
-- 			setDeathArmatureCount = setDeathArmatureCount - 1
-- 			if setDeathArmatureCount == 0 then
-- 				currentRoundIndex = _ED.attackData.roundCount
-- 				nextRoundBattle()
-- 			end
-- 		end
-- 	--]]
-- end

-- local function roleExecuteAttackMoving(armatureBack)
-- 	local armature = armatureBack
-- 	local skillQuality = dms.atoi(armatureBack._sed_action, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
-- 	local skillProperty = dms.atoi(armatureBack._sed_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
-- 	local attackMovePos = armatureBack._attackMovePos
-- 	if skillProperty == 0 then
-- 		-- 近身攻击上的移动帧组
-- 		mtime = moveToTargetTime1
-- 		executeHeroMoveBy()
-- 		--armatureBack._nextAction = _enum_animation_frame_index.animation_melee_attack_began
-- 		changeActtackToAttackBegan(armatureBack)
-- 	else
-- 		-- 技能近身攻击上的移动帧组
-- 		mtime = moveToTargetTime2
-- 		executeHeroMoveBy()
-- 		--armatureBack._nextAction = _enum_animation_frame_index.animation_melee_skill_began
-- 		changeActtackToAttackBegan(armatureBack)
-- 	end
-- end

-- local function roleExecuteAttacking(armatureBack)
-- 	local armature = armatureBack
-- 	local skillQuality = dms.atoi(armatureBack._sed_action, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
-- 	local skillProperty = dms.atoi(armatureBack._sed_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
-- 	local attackMovePos = armatureBack._attackMovePos
-- 	if attackMovePos == 0 or attackMovePos == 8 then
-- 		if skillProperty == 0 then
--              -- 远程攻击中段
-- 			armatureBack._nextAction = animation_standby
-- 			if armatureBack._isReact == true then
-- 				-- 进行反击, 启动反击中段处理
-- 				if armatureBack._byReactor ~= nil then
-- 					-- 进行反击, 启动反击中段处理
-- 					executeEffectSkilling(armatureBack._byReactor)
-- 				end
-- 			else
-- 				executeAttacking()
-- 			end
-- 		else
-- 			-- 技能攻击远程中段
-- 			armatureBack._nextAction = animation_standby
-- 			if executeAfterInfluenceCount > 0 then
-- 				executeAfterAttacking()
-- 			else
-- 				executeAttacking()
-- 			end
-- 		end
-- 	else
-- 		if skillProperty == 0 then
-- 			-- 近身攻击中段
-- 			armatureBack._nextAction = animation_standby
-- 			executeAttacking()
-- 		else
-- 			-- 技能近身攻击中段
-- 			armatureBack._nextAction = animation_standby
-- 			executeAttacking()
-- 		end
-- 	end
-- end

-- local function roleExecuteAttackOver(armatureBack)
-- 	local armature = armatureBack
-- 	local skillQuality = dms.atoi(armatureBack._sed_action, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
-- 	local skillProperty = dms.atoi(armatureBack._sed_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
-- 	local attackMovePos = armatureBack._attackMovePos
-- 	if attackMovePos == 0 or attackMovePos == 8 then
-- 		if skillProperty == 0 then
-- 		    -- 远程攻击后段
-- 			armatureBack._nextAction = animation_standby
-- 			if armature._reactor ~= nil and armature._reactor._isReact == true then
-- 				-- 反击结束
-- 				armature._reactor._isReact = false
-- 				armature._reactor._isByReact = false
-- 				armature._reactor._byReactor = nil
-- 				armature._sie = nil
-- 				armature._def = nil
-- 				armature._def = nil
-- 				armature._defr = nil
-- 				armature._reactor = nil
				
-- 				nextAttack()
-- 			else
-- 				executeAttackerBuff()
-- 			end
-- 		else
-- 		    -- 技能远程攻击后段
-- 			armatureBack._nextAction = animation_standby
-- 			executeAttackerBuff()
-- 		end
-- 	else
-- 		if skillProperty == 0 then
--             -- 近身攻击后段
-- 			mtime = moveToTargetTime1
-- 			executeHeroMoveByBack()
-- 			if needMove == true then
-- 				-- 近身攻击后段:当前角色移动攻击完毕，现在返回原点
-- 			else
-- 				-- 近身攻击后段:当前角色原地攻击完毕
-- 			end
-- 			armatureBack._nextAction = animation_standby
-- 		else
-- 		    -- 技能攻击近身后段
-- 			mtime = moveToTargetTime2
-- 			executeHeroMoveByBack()
-- 			if needMove == true then
-- 				-- 技能攻击近身后段:当前角色移动攻击完毕，现在返回原点
-- 			else
-- 				-- 技能攻击近身后段:当前角色原地攻击完毕
-- 			end
-- 			armatureBack._nextAction = animation_standby
-- 		end
-- 	end
-- end

-- attackChangeActionCallback = function(armatureBack)
-- 	local armature = armatureBack
-- 	if armature ~= nil then
-- 		local actionIndex = armature._actionIndex
-- 		-- 攻击切帧控制
-- 		if actionIndex == animation_move then
-- 			-- 我方移动动画
-- 			armature._nextAction = animation_moving
-- 		elseif actionIndex == animation_moving then
-- 		elseif actionIndex == animation_move_end then
-- 		elseif actionIndex == animation_standby then				-- 待机帧
-- 			if setDeathArmatureCount == 0 and isNoDeath == true and isSkepBattle == false then
-- 				isNoDeath = false
-- 				currentRoundIndex = _ED.attackData.roundCount
-- 				nextRoundBattle()
-- 			end
-- 		elseif actionIndex == _enum_animation_frame_index.animation_attack_moving			-- 近身攻击上的移动帧组
-- 			or actionIndex == _enum_animation_frame_index.animation_skill_moving			-- 技能近身攻击上的移动帧组
-- 			then
-- 			roleExecuteAttackMoving(armatureBack)
-- 		elseif actionIndex == _enum_animation_frame_index.animation_melee_attack_began		-- 近身攻击前段
-- 			or actionIndex == _enum_animation_frame_index.animation_remote_attack_began	-- 远程攻击前段
-- 			or actionIndex == _enum_animation_frame_index.animation_melee_skill_began		-- 技能近身攻击前段
-- 			or actionIndex == _enum_animation_frame_index.animation_remote_skill_began		-- 技能攻击远程前段
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_attack_began 
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_attack_began
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_skill_began
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_skill_began
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_skill_began
-- 			or actionIndex == _enum_animation_frame_index.animation_hero_aircraft_carrier_skilling
-- 			or actionIndex == _enum_animation_frame_index.animation_master_aircraft_carrier_skilling
-- 			or actionIndex == _enum_animation_frame_index.animation_add_hp_buff
-- 			or actionIndex == _enum_animation_frame_index.animation_combine_skill_effect
-- 			or actionIndex == _enum_animation_frame_index.animation_lr_shake_skill_effect
-- 			then	-- 所有的攻击前段部分
-- 			changeActtackToAttacking(armatureBack)
-- 		elseif actionIndex == _enum_animation_frame_index.animation_melee_attacking		-- 近身攻击中段
-- 			or actionIndex == _enum_animation_frame_index.animation_remote_attacking		-- 远程攻击中段
-- 			or actionIndex == _enum_animation_frame_index.animation_melee_skilling			-- 技能近身攻击中段
-- 			or actionIndex == _enum_animation_frame_index.animation_remote_skilling		-- 技能攻击远程中段
-- 			or actionIndex == _enum_animation_frame_index.animation_heti1
-- 			or actionIndex == _enum_animation_frame_index.animation_heti2
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_attacking
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_attacking
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_skilling
-- 			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_skilling
-- 			or actionIndex == _enum_animation_frame_index.animation_hero_torpedo_skilling
-- 			or actionIndex == _enum_animation_frame_index.animation_master_torpedo_skilling
-- 			or actionIndex == _enum_animation_frame_index.animation_scale_drop_effect
-- 			or actionIndex == _enum_animation_frame_index.animation_lr_flip_effect
-- 			or actionIndex == _enum_animation_frame_index.animation_line_move_to_effect
-- 			or actionIndex == _enum_animation_frame_index.animation_lr_move_to_effect
-- 			or actionIndex == _enum_animation_frame_index.animation_hero_move_back_launch_effect
-- 			or actionIndex == _enum_animation_frame_index.animation_master_move_back_launch_effect
-- 			then	-- 所有的攻击中段部分
-- 			roleExecuteAttacking(armatureBack)
-- 		elseif actionIndex == _enum_animation_frame_index.animation_melee_attack_end		 -- 近身攻击后段
-- 			or actionIndex == _enum_animation_frame_index.animation_remote_attack_end		-- 远程攻击后段
-- 			or actionIndex == _enum_animation_frame_index.animation_melee_skill_end		-- 技能攻击近身后段
-- 			or actionIndex == _enum_animation_frame_index.animation_remote_skill_end		-- 技能远程攻击后段
-- 			then		-- 所有的攻击后段部分
-- 			roleExecuteAttackOver(armatureBack)
-- 		elseif actionIndex == animation_hero_by_attack then			-- 我方被攻击
-- 			armatureBack._nextAction = animation_standby
-- 		elseif actionIndex == animation_emeny_by_attack then		-- 敌方被攻击
-- 			armatureBack._nextAction = animation_standby
-- 		elseif actionIndex == animation_hero_miss then				-- 我方闪避
-- 			armatureBack._nextAction = animation_standby
-- 		elseif actionIndex == animation_emeny_miss then				-- 我方闪避
-- 			armatureBack._nextAction = animation_standby
-- 		elseif actionIndex == animation_death then					-- 死亡
-- 			deathBuff(armatureBack,armature)
-- 		elseif actionIndex == death_buff then
-- 		elseif actionIndex == death_buff_end then
			
-- 		end
-- 	end	
-- end
-- -- END
-- -- --------------------------------------------------------------------- --

-- nextAttack = function()
-- 	local attackSectionNumber = 0 --攻击段数
-- 	local attackTotalHarm = 0 --多段攻击总伤害
-- 	isSkepBattle = false
	
-- 	if executeNextRoundBattleEvent(currentAttackCount + 1) == true then
-- 		return
-- 	end	
	
-- 	currentAttackCount = currentAttackCount + 1
--> print("当前战斗回合数：", currentRoundIndex, currentRoundAttackIndex)
-- 	local _roundData = _ED.attackData.roundData[currentRoundIndex]
-- 	if _roundData == nil or currentRoundAttackIndex > _roundData.curAttackCount then
-- 		nextRoundBattle()
-- 		return
-- 	end
	
-- 	attData = _roundData.roundAttacksData[currentRoundAttackIndex]
--> print("当前战斗回合攻击数据：", attData, _roundData.curAttackCount)
-- 	local attacker 				= attData.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
-- 	local attackerPos 			= attData.attackerPos 					-- = npos(list)		--出手方位置(1-6)
-- 	local attackMovePos			= tonumber(attData.attackMovePos)					-- = npos(list)		--移动到的位置(0-8)
-- 	local skillMouldId			= tonumber(attData.skillMouldId) 					-- = npos(list)	--技能模板id
-- 	local skillInfluenceCount 	= tonumber(attData.skillInfluenceCount) 			-- = tonumber(npos(list))	-- 技能效用数量
-- 	-- attData.skillInfluences = {}
	
-- 	local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
	
-- 	-- skill data
-- 	local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
-- 	local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
-- 	local skillReleasePosition = dms.atoi(skillElementData, skill_mould.skill_release_position)
-- 	local skillInfluenceId = dms.atoi(skillElementData, skill_mould.health_affect)
-- 	local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)

-- 	local current_attacker = getRole(attacker, attackerPos)
-- 	current_attacker._armature._sed_action = skillElementData
-- 	current_attacker._armature._sie_action = skillInfluenceElementData
-- 	current_attacker._armature._current_skill_influence_start_index = 1
-- 	current_attacker._armature._skill_influence_count = skillInfluenceCount
-- 	current_attacker._armature._attack_move_pos = attackMovePos
-- 	current_attacker._armature._skill_influences = attData.skillInfluences
-- 	current_attacker._armature._invoke = nil

-- 	local roles = {}
-- 	local params = {}
-- 	table.insert(roles, current_attacker)
	
-- 	table.insert(params, skillElementData)
-- 	table.insert(params, skillInfluenceElementData)
-- 	table.insert(params, attackMovePos)
-- 	table.insert(params, (attacker == "0" and __attackers or __defenders))
-- 	table.insert(params, (attacker == "1" and __attackers or __defenders))
-- 	table.insert(params, __attackers)
-- 	table.insert(params, __defenders)
-- 	table.insert(params, "attack_logic_start")

-- 	app.load("client.battle.logics.move_logic")
-- 	app.load("client.battle.logics.attack_logic")
-- 	state_machine.excute("move_logic_begin_move_all_role", 0, {roles, params})
-- end

-- nextAttack111 = function()
-- 	local attackSectionNumber = 0 --攻击段数
-- 	local attackTotalHarm = 0 --多段攻击总伤害
-- 	isSkepBattle = false
	
-- 	if executeNextRoundBattleEvent(currentAttackCount + 1) == true then
-- 		return
-- 	end	
	
-- 	currentAttackCount = currentAttackCount + 1
--> print("当前战斗回合数：", currentRoundIndex, currentRoundAttackIndex)
-- 	local _roundData = _ED.attackData.roundData[currentRoundIndex]
-- 	if _roundData == nil or currentRoundAttackIndex > _roundData.curAttackCount then
-- 		nextRoundBattle()
-- 		return
-- 	end
	
-- 	attData = _roundData.roundAttacksData[currentRoundAttackIndex]
--> print("当前战斗回合攻击数据：", attData, _roundData.curAttackCount)
-- 	local attacker 				= attData.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
-- 	local attackerPos 			= attData.attackerPos 					-- = npos(list)		--出手方位置(1-6)
-- 	local attackMovePos			= tonumber(attData.attackMovePos)					-- = npos(list)		--移动到的位置(0-8)
-- 	local skillMouldId			= tonumber(attData.skillMouldId) 					-- = npos(list)	--技能模板id
-- 	local skillInfluenceCount 	= tonumber(attData.skillInfluenceCount) 			-- = tonumber(npos(list))	-- 技能效用数量
-- 	-- attData.skillInfluences = {}
	
-- 	local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
	
-- 	-- skill data
-- 	local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
-- 	local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
-- 	local skillReleasePosition = dms.atoi(skillElementData, skill_mould.skill_release_position)
-- 	local skillInfluenceId = dms.atoi(skillElementData, skill_mould.health_affect)
-- 	local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
	
--> print("技能模块ID:", skillMouldId, "技能效用ID:", skillInfluenceId, "attacker:", attacker, "attackerPos:", attackerPos)

-- 	-- --------------------------------------------------------------------- --
-- 	-- 攻击前的移动准备
-- 	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
-- 	local mx = 0
-- 	local my = 0
-- 	local ex = 0
-- 	local ey = 0
-- 	executeAfterInfluenceCount = 0
	
-- 	local needMove = (attackMovePos ~= 0 and attackMovePos ~= 8) and true or false
-- 	local attackingTime = 0.0
	
-- 	mPosTile = nil
-- 	mpos = nil
-- 	mtime = 0
-- 	if attacker == "0" then
-- 		-- 我方攻击
-- 		state_machine.excute("battle_formation_controller_role_attack", 0, {roleType = 2, roleIndex = attackerPos})
		
-- 		mPosTile = getRole(0, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, attackerPos))
--> print("mPosTile::", mPosTile, attackerPos, mPosTile._pos, mPosTile._armature, mPosTile._camp)
-- 		mx, my = mPosTile:getPosition()
		
-- 		if needMove == true then
-- 			if attackMovePos == 1 then
-- 				local mpos2 = getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, 2))
-- 				local epos2 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, 2))
-- 				ex, ey = mPosTile:getPosition()
-- 				local m2x, m2y = mpos2:getPosition()
-- 				local e2x, e2y = epos2:getPosition()
				
-- 				local mmx, mmy = mPosTile:getPosition()
				
-- 				ex = ex + (m2x - ex)
-- 				ey = ey + (e2y - m2y)/2 + (m2y - mmy) - mPosTile:getContentSize().height/2 - 20/CC_CONTENT_SCALE_FACTOR()
				
-- 				mPosTile._mscale = epos2._scale or 1.0
-- 			else
-- 				local ePosTile = getRole(1, attackMovePos-1) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, attackMovePos-1))
-- 				ex, ey = ePosTile:getPosition()
-- 				ey = ey - attackMoveTagetOffsetY - mPosTile:getContentSize().height/2 - 20/CC_CONTENT_SCALE_FACTOR()
-- 			end
-- 		end
-- 	else
-- 		-- 敌方攻击
-- 		state_machine.excute("battle_formation_controller_role_attack", 0, {roleType = 1, roleIndex = attackerPos})
		
-- 		mPosTile = getRole(1, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, attackerPos))
-- 		mx, my = mPosTile:getPosition()
		
-- 		if needMove == true then
-- 			if attackMovePos == 1 then
-- 				local mpos2 = getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, 2))
-- 				local epos2 = getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, 2))
-- 				ex, ey = mPosTile:getPosition()
-- 				local m2x, m2y = mpos2:getPosition()
-- 				local e2x, e2y = epos2:getPosition()
				
-- 				local mmx, mmy = mPosTile:getPosition()
				
-- 				ex = ex + (m2x - ex)
-- 				ey = ey + (e2y - m2y)/2 + (m2y - mmy) + mPosTile:getContentSize().height/2 + 20/CC_CONTENT_SCALE_FACTOR()
				
-- 				mPosTile._mscale = epos2._scale or 1.0
-- 			else
-- 				local ePosTile = getRole(0, attackMovePos-1) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, attackMovePos-1))
-- 				ex, ey = ePosTile:getPosition()
-- 				ey = ey + attackMoveTagetOffsetY + mPosTile:getContentSize().height/2 + 20/CC_CONTENT_SCALE_FACTOR()
-- 			end
-- 		end
-- 	end
	
-- 	mPosTile._armature._sed_action = skillElementData
-- 	mPosTile._armature._sie_action = skillInfluenceElementData
-- 	mPosTile._armature._attackMovePos = attackMovePos

-- 	if needMove == true then
-- 		mpos = cc.p(ex - mx, ey - my)
-- 		mtime = (math.sqrt((math.pow(mpos.x, 2) + math.pow(mpos.y, 2))) / moveFrameSpace) * moveFrameTime
-- 		-- 计算移动时间： mtime
-- 	else
-- 		mpos = nil
-- 		mtime = 0
-- 	end
	
-- 	-- 清除角色的BUFF
-- 	if mPosTile._buff ~= nil then
-- 		for i, v in pairs(mPosTile._buff) do
-- 			if v ~= nil and v._LastsCountTurns ~= nil and v._LastsCountTurns > 0 and (i == 5 or i == 8) then
-- 				v._LastsCountTurns = v._LastsCountTurns - 1
-- 				if v._LastsCountTurns <= 0 then
-- 					deleteEffectFile(v)
-- 					-- 清除角色的BUFF
-- 					mPosTile._buff[i] = nil
-- 				end
-- 			end
-- 		end
-- 	end
		
-- 	-- 眩晕
-- 	if skillInfluenceCount <= 0 then
-- 		resetArmatureData(mPosTile._armature)
-- 		executeAttackerBuff()
-- 		return
-- 	end
	
-- 	executeHeroMoveToTarget = function()
-- 		-- 清理对象缓存信息
-- 		resetArmatureData(mPosTile._armature)
		
-- 		-- 角色死亡
-- 		if mPosTile._armature == nil then
-- 			nextAttack()
-- 			return
-- 		end
		
-- 		-- if attackMovePos == 0 or attackMovePos == 8 then
-- 		-- 	-- 在原地进行攻击
-- 		-- 	if skillProperty == 0 then
-- 		-- 		executeRemoteAttackBegan(mPosTile._armature)
-- 		-- 	elseif skillProperty == 1 then
-- 		-- 		executeRemoteSkillBegan(mPosTile._armature)
-- 		-- 	end
-- 		-- 	if attackMovePos == 8 then
-- 		-- 		mPosTile:setVisible(false)
-- 		-- 	end
-- 		-- else
-- 		-- 	-- 处理移动逻辑-初始化移动
-- 		-- 	local armature = mPosTile._armature
-- 		-- 	armature._invoke = attackChangeActionCallback
			
-- 		-- 	if skillProperty == 0 then
-- 		-- 		executeMoveMeleeAttackBegan(mPosTile._armature)
-- 		-- 	elseif skillProperty == 1 then
-- 		-- 		executeMoveMeleeSkillBegan(mPosTile._armature)
-- 		-- 	end
			
-- 		-- end
--> print("attackMovePos:", attackMovePos)
-- 		if attackMovePos == 0 or attackMovePos == 8 then
-- 			changeActtackToAttackBegan(mPosTile._armature)
-- 			if attackMovePos == 8 then
-- 				mPosTile:setVisible(false)
-- 			end
-- 		else
-- 			changeActtackToAttackMoving(mPosTile._armature)
-- 		end
-- 	end
	
-- 	executeHeroMoveToOriginTarget = function()
-- 		-- 处理返回逻辑
-- 		if attackTargetCount > 0 then
-- 			attackTargetCount = attackTargetCount - 1
-- 			if attackTargetCount > 0 then
-- 				return
-- 			end
-- 		end
		
-- 		if executeAfterInfluenceCount > 0 then
-- 			-- 重新进入
-- 			executeAfterAttacking()
-- 			return
-- 		end
		
-- 		local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
-- 		if (currentSkillInfluenceStartIndex < skillInfluenceCount) then
-- 			currentSkillInfluenceStartIndex = currentSkillInfluenceStartIndex + 1
-- 			executeAttacking()
-- 			--executeAttack()
-- 			return
-- 		end
		
-- 		-- if attackMovePos == 0 or attackMovePos == 8 then
-- 		-- 	-- 处理在原地进行攻击后的返回逻辑
-- 		-- 	if skillProperty == 0 then	-- 物理远程攻击
-- 		-- 		executeRemoteAttackEnd(mPosTile._armature)
-- 		-- 	elseif skillProperty == 1 then	-- 技能远程攻击
-- 		-- 		executeRemoteSkillEnd(mPosTile._armature)
-- 		-- 	end
-- 		-- 	if attackMovePos == 8 then
-- 		-- 		mPosTile:setVisible(true)
-- 		-- 	end
-- 		-- else
-- 		-- 	-- 处理攻击后的返回逻辑
-- 		-- 	if skillProperty == 0 then	-- 物理近身攻击
-- 		-- 		executeMeleeAttackEnd(mPosTile._armature)
-- 		-- 	elseif skillProperty == 1 then	-- 技能近身攻击
-- 		-- 		executeMeleeSkillEnd(mPosTile._armature)
-- 		-- 	end
-- 		-- end

-- 		changeActtackToAttackAfter(mPosTile._armature)
-- 		if attackMovePos == 8 then
-- 			mPosTile:setVisible(true)
-- 		end
-- 	end
	
-- 	--[[
-- 		0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 		1基于施放者位置（只绘制一个光效）
-- 		2基于承受者位置（根据目标数量绘制光效）
-- 		3基于对方阵营中心（只绘制一个光效）
-- 		4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 		5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 		6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 	--]]
-- 	executeAttack = function()
-- 		-- 执行被攻击
-- 		for j = currentSkillInfluenceStartIndex, skillInfluenceCount do
-- 			-- local _skf = {}
-- 			local _skf = attData.skillInfluences[j]
-- 			local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
-- 			local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
			
-- 			mPosTile._armature._skf = _skf
-- 			resetArmatureData(mPosTile._armature)
			
-- 			-- 加载技能效用
-- 			local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
-- 			local skillCategory = dms.atoi(skillInfluenceElementData, skill_influence.skill_category)
-- 			local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
			
-- 			mPosTile._armature._sie = skillInfluenceElementData
-- 			-- 启动技能前段
-- 			executeEffectSkillBegan(mPosTile._armature)
-- 			if true then
-- 				return
-- 			end
			
-- 			if lightingEffectDrawMethod == 1 then
-- 			elseif lightingEffectDrawMethod == 3 then
				
-- 			end
			
-- 			for w = 1, _skf.defenderCount do
-- 				local _def = _skf._defenders[w]
-- 				local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
-- 				local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
-- 				local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
-- 				local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
-- 				local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
-- 				local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
-- 				local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
											
-- 				local rPad = getRolePad(defender, defenderPos)
-- 				--rPad._armature._def = _def
-- 				--rPad._armature._sie = skillInfluenceElementData
				
-- 				resetArmatureData(rPad._armature)
				
-- 				if _def.defAState == "1" then
-- 					local dropCount = _def.dropCount 	-- = npos(list)		--(死亡时传)掉落卡片数量
-- 				elseif _def.defAState == "2" then 
-- 					rPad._armature._isReact = true
-- 					--[[
-- 					local fightBackFlag = _def.fightBackFlag 		-- = npos(list)	-- (反击时传)反击承受方的标识 
-- 					local fightBackPos = _def.fightBackPos 			-- = npos(list)	-- 反击承受方的位置 
-- 					local fightBackSkf = _def.fightBackSkf 			-- = npos(list)	-- 反击承受方的作用效果 
-- 					local fightBackValue = _def.fightBackValue 		-- = npos(list)	-- 反击承受方的作用值 
-- 					local fightBackRound = _def.fightBackRound 		-- = npos(list)	-- 反击承受方的持续回合
-- 					--]]
-- 				end
-- 			end			
-- 			break
-- 		end
-- 	end
	
-- 	local function executeAttackInfluence(skf)
-- 		-- 执行被攻击中段
-- 		local attackInfluencedCount = 0
-- 		-- for j = currSkillInfluenceStartIndex, currSkillInfluenceCount do
-- 			local _skf = skf --attData.skillInfluences[j]
-- 			local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
-- 			local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
-- 			local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
-- 			local attackerPos = _skf.attackerPos			-- 效用发动者位置
-- 			local currPosTile = nil
-- 			if attackerType == "1" then
-- 				local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
-- 				currPosTile = getRole(1, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
-- 			else
-- 				currPosTile = getRole(0, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
-- 			end
				
-- 			local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
			
-- 			for w = 1, _skf.defenderCount do
-- 				local _def = _skf._defenders[w]
-- 				local defender = _def.defender
-- 				local defenderPos = tonumber(_def.defenderPos)						
-- 				local rPad = getRolePad(defender, defenderPos)
-- 				resetArmatureData(rPad._armature)
-- 			end
			
-- 			if currPosTile == nil then
-- 				return 2
-- 			end
-- 			if currPosTile._armature == nil  then
-- 				currPosTile._armature = {}
-- 				currPosTile._armature._posTile = currPosTile
-- 			end
			
			
-- 			-- 加载技能效用
-- 			local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
-- 			local skillCategory = dms.atoi(skillInfluenceElementData, skill_influence.skill_category)
-- 			local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
-- 			local attackSection = dms.atoi(skillInfluenceElementData, skill_influence.attack_section)
-- 			local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, influenceType, skill_influence.posterior_lighting_effect_id)	 -- dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
-- 			local is_vibrate = dms.atoi(skillInfluenceElementData, skill_influence.is_vibrate)
	
-- 			_skf._attackSection = attackSection
-- 			currPosTile._armature._skf = _skf
-- 			currPosTile._armature._sie = skillInfluenceElementData
-- 			currPosTile._armature._is_vibrate = is_vibrate
						
-- 			--[[
-- 				0基于施放者与承受者的路径（根据目标数量绘制光效）
-- 				1基于施放者位置（只绘制一个光效）
-- 				2基于承受者位置（根据目标数量绘制光效）
-- 				3基于对方阵营中心（只绘制一个光效）
-- 				4基于攻击范围无视存活数量（根据目标数量绘制光效）
-- 				5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
-- 				6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
-- 			--]]
	
-- 			local executeDrawEffect = true
--> print("lightingEffectDrawMethod:", lightingEffectDrawMethod)
-- 			if lightingEffectDrawMethod == 1 then
-- 				attackTargetCount = 1
-- 				executeEffectSkilling1(currPosTile._armature)
-- 				executeDrawEffect = false
-- 			elseif lightingEffectDrawMethod == 2 then
-- 				-- executeEffectSkilling2(currPosTile._armature)
-- 				-- executeDrawEffect = false
-- 				_skf.attTarList = nil
-- 			elseif lightingEffectDrawMethod == 3 then
-- 				attackTargetCount = 1
-- 				executeEffectSkilling3(currPosTile._armature)
-- 				executeDrawEffect = false
-- 			elseif lightingEffectDrawMethod == 4 then
-- 				executeEffectSkilling4(currPosTile._armature)
-- 			elseif lightingEffectDrawMethod == 5 then
-- 				-- executeEffectSkilling5(currPosTile._armature)
-- 				_skf.attTarList = nil
-- 			elseif lightingEffectDrawMethod == 6 then
-- 				-- executeEffectSkilling6(currPosTile._armature)
-- 				_skf.attTarList = nil
-- 			elseif lightingEffectDrawMethod == 0 then
-- 				_skf.attTarList = nil
				
-- 			end
			
-- 			local erole = {}
-- 			for w = 1, _skf.defenderCount do
-- 				local _def = _skf._defenders[w]
-- 				local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
-- 				local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
-- 				local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
-- 				local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
-- 				local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
-- 				local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
-- 				local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
				
-- 				local rPad = getRolePad(defender, defenderPos)
-- 				if rPad._armature ~= nil then
-- 					_def._attackSection = attackSection

-- 					rPad._armature._def = _def
-- 					rPad._armature._sie = skillInfluenceElementData
						
-- 					if rPad._armature._defs == nil then
-- 						rPad._armature._defs = {}
-- 					end
					
					
-- 					rPad._armature._base = currPosTile._armature
					
-- 					if _def.defenderST == "6" then
-- 						-- 6为中毒
-- 					elseif  _def.defenderST == "9" then
-- 						-- 9为灼烧
-- 					end
					
-- 					--[[
-- 						defenderPos, stValue))
-- 					--]]
					
-- 					-- 根据攻击的段数，重新赋伤害
-- 					if tonumber(_def.stValue) > 0 and attackSection > 0 then
-- 						--_def.stValue = ""..string.format("%d", math.floor(tonumber(_def.stValue)/attackSection))
-- 						_skf._defenders[w].subValue = ""..string.format("%d", math.floor(tonumber(_def.stValue)/attackSection))
-- 						if defenderST == "0" or defenderST == "6" then
-- 							attackSectionNumber = attackSection
-- 							attackTotalHarm = attackTotalHarm + tonumber(_def.stValue)
-- 						end
-- 					end
					
-- 					if rPad ~= currPosTile or _def.stVisible == "1" then
-- 						rPad._armature._defs[table.getn(rPad._armature._defs) + 1] = _def
-- 						erole[""..defender..">"..defenderPos] = rPad._armature
-- 					else
-- 						local drawString = _def.stValue
-- 						if defenderST == "0" or
-- 							defenderST == "6"
-- 							then
-- 							if tonumber(_def.defender) == 1 then
-- 								BattleSceneClass.curDamage = BattleSceneClass.curDamage + tonumber(drawString)
-- 							end
-- 							drawString = "-"..drawString
-- 						elseif defenderST == "1" or 
-- 							defenderST == "9" 
-- 							then
-- 							drawString = "+"..drawString
-- 						end
							
-- 						if (defenderST == "2" or defenderST == "3") and (rPad._armature~= nil and rPad._armature._role ~= nil) then
-- 							if defState ~= "1" and defState ~= "5" then
-- 								rPad._armature._role._sp = rPad._armature._role._sp + ((defenderST == "2" and 1 or -1) * tonumber(_def.stValue))
-- 								if rPad._armature._role._sp < 0 then
-- 									rPad._armature._role._sp = 0
-- 								end
-- 								showRoleSP(rPad._armature)
-- 							end
							
-- 						elseif (defenderST == "0" or defenderST == "1" or defenderST == "6" or defenderST == "9") then
-- 							rPad._armature._role._hp = rPad._armature._role._hp + tonumber(drawString)
-- 							showRoleHP(rPad._armature)
-- 						end
-- 					end				
					
-- 					if _skf.attTarList ~= nil then
-- 						for a, t in pairs(_skf.attTarList) do
-- 							if t == defenderPos then
-- 								-- 删除攻击节点"
-- 								_skf.attTarList[a] = nil
-- 							end
-- 						end
-- 					end
					
-- 					if _def.defAState == "1" then
-- 						local dropCount = _def.dropCount 	-- = npos(list)		--(死亡时传)掉落卡片数量
-- 					elseif _def.defAState == "2" then 
-- 						rPad._armature._isReact = true
-- 						--[[
-- 						local fightBackFlag = _def.fightBackFlag 				-- = npos(list)	-- (反击时传)反击承受方的标识 
-- 						local fightBackPos = _def.fightBackPos 					-- = npos(list)	-- 反击承受方的位置 
-- 						local fightBackSkf = _def.fightBackSkf 					-- = npos(list)	-- 反击承受方的作用效果 
-- 						local fightBackValue = _def.fightBackValue 				-- = npos(list)	-- 反击承受方的作用值 
-- 						local fightBackRound = _def.fightBackRound 				-- = npos(list)	-- 反击承受方的持续回合
-- 						local fightBackDefState = _def.fightBackDefState		-- = npos(list)	-- 反击承受方的承受状态 
-- 						local fightBackLiveState = _def.fightBackLiveState 		-- = npos(list)--反击承受方生存状态 (0:存活 1:死亡)
-- 						if _def.fightBackDefState == "1" then
-- 							local fightBackDropCardCount = _def.fightBackDropCardCount -- = npos(list)			-- (死亡时传)掉落卡片数量
-- 						end
-- 						if currPosTile._armature._reactor == nil then
-- 							currPosTile._armature._reactor = rPad._armature
-- 							currPosTile._armature._defr = _def
-- 						end
-- 						--]]
-- 					end
-- 				else
--> print("攻击的承受方不存在！", defender, defenderPos)
-- 				end
-- 			end
-- 			local roleCount = 0
-- 			if executeDrawEffect == true then
-- 				for i, v in pairs(erole) do
-- 					if lightingEffectDrawMethod == 7 then
-- 						executeEffectSkilling7(currPosTile._armature,v)
-- 					else
--> print("v:pos", v._pos, v._camp)
-- 						executeEffectSkilling(v)
-- 					end
-- 					roleCount = roleCount + 1
-- 				end
-- 				attackTargetCount = roleCount
-- 				if roleCount <= 0 then
-- 					executeHeroMoveToOriginTarget()
-- 				elseif _skf.attTarList ~= nil then
-- 					if lightingEffectDrawMethod ~= 7 then
-- 						local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
-- 						for a, t in pairs(_skf.attTarList) do
-- 							local cPosTile
-- 							if attacker == "0" then
-- 								cPosTile = getRole(1, t) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, t))
-- 							else
-- 								cPosTile = getRole(0, t) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, t))
-- 							end
-- 							if cPosTile ~= nil then
-- 								-- 无视攻击位置
-- 								local effect = createEffect(cPosTile, posterior_lighting_effect_id, (tonumber(currPosTile._camp) + 1) % 2)
-- 								effect._invoke = deleteEffectFile
-- 								effect._LastsCountTurns = nil
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 			--break
-- 		-- end
-- 	end
	
-- 	executeAttacking = function()
-- 		-- executeAttackInfluence(mPosTile, currentSkillInfluenceStartIndex, skillInfluenceCount)
-- 		if currentSkillInfluenceStartIndex <= skillInfluenceCount then
-- 			local recal = executeAttackInfluence(attData.skillInfluences[currentSkillInfluenceStartIndex])
-- 			if recal == 2 then
-- 				currentSkillInfluenceStartIndex = currentSkillInfluenceStartIndex + 1
-- 				executeAttacking()
-- 			end
-- 		else
-- 			executeHeroMoveToOriginTarget()
-- 		end
-- 	end
	
-- 	startAfterAttack = function()
-- 		if executeAfterInfluenceCount < attData.skillAfterInfluenceCount then
-- 			executeAfterInfluenceCount = executeAfterInfluenceCount + 1
			
-- 			local _skf = attData.skillAfterInfluences[executeAfterInfluenceCount]
-- 			local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
			
-- 			local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
-- 			local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
-- 			local attackerPos = _skf.attackerPos			-- 效用发动者位置
-- 			local currPosTile = nil
-- 			if attackerType == "1" then
-- 				local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
-- 				currPosTile = getRole(1, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
-- 			else
-- 				currPosTile = getRole(0, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
-- 			end
			
-- 			local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
			
-- 			resetArmatureData(currPosTile._armature)
			
-- 			if currPosTile._armature == nil then
-- 				executeAfterInfluenceCount = attData.skillAfterInfluenceCount
-- 				nextAttack()
-- 			else
-- 				currPosTile._armature._isReact = true
-- 				currPosTile._armature._skf = _skf
					
-- 				executeRemoteSkillBegan(currPosTile._armature)
-- 			end
-- 		else
-- 			executeAfterAttack()
-- 		end
-- 	end
	
-- 	executeAfterAttack = function()
-- 		if executeAfterInfluenceCount <= attData.skillAfterInfluenceCount then
-- 			-- 执行被攻击
-- 			for j = executeAfterInfluenceCount, attData.skillAfterInfluenceCount do
-- 				-- local _skf = {}
-- 				local _skf = attData.skillAfterInfluences[j]
-- 				local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
				
-- 				local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
-- 				local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
-- 				local attackerPos = _skf.attackerPos			-- 效用发动者位置
-- 				local currPosTile = nil
-- 				if attackerType == "1" then
-- 					local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
-- 					currPosTile = getRole(1, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
-- 				else
-- 					currPosTile = getRole(0, attackerPos) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
-- 				end
				
-- 				local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
				
-- 				currPosTile._armature._skf = _skf
-- 				resetArmatureData(currPosTile._armature)
				
-- 				-- 加载技能效用
-- 				local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
-- 				local skillCategory = dms.atoi(skillInfluenceElementData, skill_influence.skill_category)
-- 				local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
-- 				local attackSection = dms.atoi(skillInfluenceElementData, skill_influence.attack_section)
				

-- 				_skf._attackSection = attackSection
			
				
-- 				currPosTile._armature._sie = skillInfluenceElementData
-- 				-- 启动技能前段
-- 				executeEffectSkillBegan(currPosTile._armature)
-- 				if true then
-- 					return
-- 				end
				
-- 				if lightingEffectDrawMethod == 1 then
-- 				elseif lightingEffectDrawMethod == 3 then
					
-- 				end
				
-- 				for w = 1, _skf.defenderCount do
-- 					local _def = _skf._defenders[w]
-- 					local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
-- 					local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
-- 					local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
-- 					local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
-- 					local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
-- 					local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
-- 					local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
					
-- 					local rPad = getRolePad(defender, defenderPos)
-- 					--rPad._armature._def = _def
-- 					--rPad._armature._sie = skillInfluenceElementData
					
-- 					_def._attackSection = attackSection
					
-- 					resetArmatureData(rPad._armature)
					
-- 					if _def.defAState == "1" then
-- 						local dropCount = _def.dropCount 	-- = npos(list)		--(死亡时传)掉落卡片数量
-- 					elseif _def.defAState == "2" then 
-- 						rPad._armature._isReact = true
-- 					--[[
-- 						local fightBackFlag = _def.fightBackFlag 		-- = npos(list)	-- (反击时传)反击承受方的标识 
-- 						local fightBackPos = _def.fightBackPos 			-- = npos(list)	-- 反击承受方的位置 
-- 						local fightBackSkf = _def.fightBackSkf 			-- = npos(list)	-- 反击承受方的作用效果 
-- 						local fightBackValue = _def.fightBackValue 		-- = npos(list)	-- 反击承受方的作用值 
-- 						local fightBackRound = _def.fightBackRound 		-- = npos(list)	-- 反击承受方的持续回合
-- 						--]]
-- 					end
-- 				end			
-- 				break
-- 			end
-- 		else
-- 			executeAfterAttacking()
-- 		end
-- 	end
	
-- 	executeAfterAttacking = function()
-- 		if executeAfterInfluenceCount > 0 and executeAfterInfluenceCount <= attData.skillAfterInfluenceCount then
-- 			-- 处理后段效用逻辑
-- 			-- 格挡反击-处理后段效用逻辑
-- 			local recal = executeAttackInfluence(attData.skillAfterInfluences[executeAfterInfluenceCount])
-- 			executeAfterInfluenceCount = executeAfterInfluenceCount + 1
-- 			if recal == 2 then
-- 				executeAfterAttacking()
-- 			end
-- 		else
-- 			-- 没有后段的效用直接处理逻辑
-- 			-- 格挡反击结束, 找查下一攻击角色，或进入下一回合
-- 			nextAttack()
-- 		end
-- 	end
	
-- 	local executeAttackEnd = function()
-- 		if executeAfterInfluenceCount < attData.skillAfterInfluenceCount and executeAfterInfluenceCount == 0 then
-- 			-- 执行被攻击后段-处理格挡反击
-- 			startAfterAttack()
-- 		else
-- 			-- 没有格挡反击, 找查下一攻击角色，或进入下一回合
-- 			nextAttack()
-- 		end
-- 	end

-- 	executeAttackerBuff = function()	
-- 		state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
-- 		-- 处理当前攻击者的BUFF信息，然后进入到下一个攻击角色进行攻击！
-- 		local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
		
-- 		local attackerBuffState = attData.attackerBuffState 			-- = npos(list)	-- 出手方是否有buff影响(0:没有 1:有)
-- 		local _dindex = 0
-- 		for z=1, tonumber(attackerBuffState) do
-- 			local _widget = mPosTile
-- 			local widgetSize = _widget:getContentSize()
			
-- 			local attackerBuffType = attData.attackerBuffType[z] 			-- = npos(list)	-- (有buff影响时传)影响类型(6为中毒,9为灼烧)
-- 			local attackerBuffValue = attData.attackerBuffValue[z] 		-- = npos(list)	-- 影响值
			
-- 			mPosTile._armature._role._hp = mPosTile._armature._role._hp - tonumber(attackerBuffValue)
-- 			showRoleHP(mPosTile._armature)
			
-- 			if z == tonumber(attackerBuffState) then
-- 				local attackerBuffDeath = attData.attackerBuffDeath
-- 				if attackerBuffDeath == "1" then
-- 					mPosTile._armature._def = nil
-- 					mPosTile._armature._dropCount = attData.attackerBuffDropCount
-- 					executeRoleDeath(mPosTile._armature)
-- 				end
-- 			end	
			
-- 			local numberFilePath = "images/ui/number/xue.png"
			
-- 			local labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
-- 			-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
-- 			labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
-- 			local tempX, tempY  = _widget:getPosition()
-- 			local uiObj = nil
-- 			if attackerBuffType == "6" then
-- 				uiObj = cc.Sprite:create("images/ui/battle/du.png")
-- 			elseif attackerBuffType == "9" then
-- 				uiObj = cc.Sprite:create("images/ui/battle/zhuoshao.png")
-- 			end
			
-- 			labelAtlas:setPosition(cc.p(tempX + widgetSize.width/2, tempY + widgetSize.height/2)) 
-- 			_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt) 
			
-- 			-- animationChangeToAction(mPosTile._armature, changeToAction, animation_standby)
			
-- 			uiObj:setAnchorPoint(cc.p(0.5, 0.5)) 
-- 			labelAtlas:addChild(uiObj)
-- 			uiObj:setPosition(cc.p(labelAtlas:getContentSize().width/2, uiObj:getContentSize().height 
-- 				+ labelAtlas:getContentSize().height/2))
			
-- 			local array = {}
-- 			if _dindex == 1 then
-- 				labelAtlas:setVisible(false)
-- 				table.insert(array, (cc.DelayTime:create(0.7 * actionTimeSpeed)))
-- 				table.insert(array, cc.Show:create())
-- 			end
			
-- 			_dindex = _dindex + 1
		
-- 			table.insert(array, cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 2))
-- 			table.insert(array, cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 1.0))
			
-- 			table.insert(array, cc.DelayTime:create(30.0/60.0 * actionTimeSpeed))
-- 			table.insert(array, cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2))
-- 			table.insert(array, cc.CallFunc:create(removeFrameObjectFuncN))
-- 			local seq = cc.Sequence:create(array)
-- 			labelAtlas:runAction(seq)
-- 		end
		
-- 		executeAfterInfluenceCount = 0
-- 		currentRoundAttackIndex = currentRoundAttackIndex + 1
-- 		--skillInfluenceStartIndex = 1
-- 		currentSkillInfluenceStartIndex = 1
		
-- 		-- 清除角色的BUFF
-- 		if mPosTile._buff ~= nil then
-- 			for i, v in pairs(mPosTile._buff) do
-- 				if v ~= nil and v._LastsCountTurns ~= nil and v._LastsCountTurns > 0 then
-- 					v._LastsCountTurns = v._LastsCountTurns - 1
-- 					if v._LastsCountTurns <= 0 then
-- 						-- 清除角色的BUFF
-- 						mPosTile._buff[i] = nil
-- 					end
-- 				end
-- 			end
-- 		end
		
		
-- 		executeAttackEnd()
-- 		--绘制多段攻击总伤害
-- 		if attackTotalHarm > 0 and attackSectionNumber > 1 then
--> print("绘制连击的总伤害，目前界面文件有问题，取消了绘制。")
-- 			-- fwin:close(BattleSceneClass._attackTotalHarm)
			
-- 			-- local csbInjury = csb.createNode("battle/injury_settlement.csb")
-- 			-- BattleSceneClass._attackTotalHarm = csbInjury
-- 			-- BattleSceneClass._attackTotalHarm.root = csbInjury:getChildByName("root")
			
-- 			-- fwin:open(BattleSceneClass._attackTotalHarm, fwin._dialog)
			
-- 			-- ccui.Helper:seekWidgetByName(BattleSceneClass._attackTotalHarm.root, "AtlasLabel_1"):setString(""..attackTotalHarm)
			
-- 			-- local action = csb.createTimeline("battle/injury_settlement.csb")
-- 			-- BattleSceneClass._shakeAction = action
-- 			-- -- csbLogo:runAction(action)
-- 			-- -- action:gotoFrameAndPlay(0, action:getDuration(), false)
-- 			-- -- action:setTimeSpeed(0.1*actionTimeSpeed)
			
-- 			-- -- local action1 = ActionManager:shareManager():getActionByName("injury_settlement.json","Animation0")
-- 			-- -- action1:setUnitTime(0.1*actionTimeSpeed)
-- 			-- -- action1:play()
-- 			-- -- action1:setLoop(false)
-- 			-- BattleSceneClass._shakeAction:gotoFrameAndPlay(0, BattleSceneClass._shakeAction:getDuration(), false)
			
-- 			-- -- action:play("combo_damage")
-- 			-- -- frame event name :combo_damage_over
-- 		end
-- 		attackTotalHarm = 0
-- 		attackSectionNumber = 0
-- 	end
	
-- 	-- if skillQuality == 1 and mPosTile._armature._role._quality >= 3 then
-- 	if skillQuality == 1 then
-- 		-- 绘制怒气技术过场动画
-- 		mPosTile._armature._currentSkillMouldId = skillMouldId
-- 		excuteSPSkillEffect(mPosTile, mPosTile._armature)
-- 	else
-- 		executeHeroMoveToTarget()
-- 	end
-- end

-- nextRoundBattle = function()
-- 	if currentRoundIndex >= _ED.attackData.roundCount then
--> print("当前场次的战斗结束，进入下一场战斗。")
-- 		state_machine.excute("fight_check_next_fight", 0, 0)
-- 		return
-- 	end
	
-- 	if setDeathArmatureCount > 0 then
-- 		return
-- 	end
	
-- 	currentRoundAttackIndex = 1
-- 	currentSkillInfluenceStartIndex = 1
	
-- 	currentRoundIndex = currentRoundIndex + 1
	
-- 	state_machine.excute("fight_ui_update_battle_round_count", 0, _ED.attackData.roundData[currentRoundIndex].currentRound.."/".."30")

-- 	nextAttack()
-- end


-- -- END~战斗过程处理
-- -- ------------------------------------------------------------------------------------------------- --


-- function BattleSceneClass:ctor()
-- 	self.super:ctor()
	
-- 	lastTimeRoundBattleNumber = 0 -- 军团副本战斗上次回合的活动对象数
-- 	currentcurrent_scene_npc_id_length = nil
-- 	battleMoveUnionTeamY = nil

-- 	BattleSceneClass._attackTotalHarm = nil
-- 	skipCurrentFight = false
-- 	lockSkipFight = false
-- 	setDeathArmatureCount = -1
	
-- 	local size = cc.Director:getInstance():getWinSize()
	
-- 	BattleSceneClass._lastExp = _ED.user_info.user_experience
-- 	BattleSceneClass._lastNeedExp = _ED.user_info.user_grade_need_experience
	
-- 	_ED._user_last_grade = _ED.user_info.user_grade
	
-- 	BattleSceneClass.curDamage = 0
	
-- 	-- ----------------------------------------初入战场------------------------------------------------- --
-- 	isSkepBattle = false
	
-- 	startBattle = function()
-- 		-- 开始战斗了
-- 		currentAttackCount = 0
-- 		currentRoundIndex = 0
-- 		currentRoundAttackIndex = 1
-- 		currentSkillInfluenceStartIndex = 1
-- 		isAttackInfluence = false
-- 		nextRoundBattle()
-- 	end
-- 	-- NED~战斗过程处理	
-- 	-- ------------------------------------------------------------------------------------------------- --
-- end	

-- function BattleSceneClass.Draw()
	
-- end

-- function BattleSceneClass:resumePVEBattle()
--     nextAttack()
-- end

-- function BattleSceneClass:startPVEBattle(_battleData, _attackData, _attackers, _defenders)
--     __battleDatas = _battleData
--     __attackDatas = _attackData
--     __attackers = _attackers
--     __defenders = _defenders
--     startBattle()
-- end

battle_execute = {}
app.load("client.battle.logics.move_logic")
app.load("client.battle.logics.attack_logic")

-- END
-- ----------------------------------------------------------------------------------------------------