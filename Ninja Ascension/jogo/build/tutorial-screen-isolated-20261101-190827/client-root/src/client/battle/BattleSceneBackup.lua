-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗场景管理
-- 创建时间2014-03-01 15:06
-- 作者：周义文
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

draw = draw or {}
draw.size = function()
	return cc.Director:getInstance():getWinSize()
end

draw.graphics = function(layer)
	fwin._scene:addChild(layer)
end

draw.label = function(_widget, _childName, _text)
	ccui.Helper:seekWidgetByName(_widget, _childName):setString(_text)
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

changeAction_animationEventCallFunc = function(armatureBack,movementType,movementID)
	local id = movementID
	if armatureBack._changing == nil then
		armatureBack._changing = true
		if armatureBack._nextAction ~= nil and armatureBack._actionIndex ~= armatureBack._nextAction then
			armatureBack._actionIndex = armatureBack._nextAction
			armatureBack._actionLoopCount = 0
			armatureBack:getAnimation():playWithIndex(armatureBack._nextAction)
		end
		if armatureBack._nextFunc ~= nil 
			and armatureBack._nextFunc ~= changeAction_animationEventCallFunc  then
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

-- 加载光效资源文件
loadEffect = function(fileName)
	-- local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
	-- CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
	--local armatureName = string.format("effice_%d", fileIndex)
	return armatureName
end

deleteEffect = function(armatureBack)
	if armatureBack == nil then
		return
	end
	
	if armatureBack._LastsCountTurns > 0 then
		-- 删除光效
		armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns - 1
		if armatureBack._LastsCountTurns <= 0 then
			local fileName = armatureBack._fileName
			armatureBack:removeFromParent(true)
			-- 删除光效文件
			ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
		end
	end
end

-- createEffect = function(armatureName, armatureFile, armaturePad, loop, ZOrder, actionTimeSpeed)
	-- loadEffect(armatureFile)
	-- local armature = ccs.Armature:create(armatureName)
	-- armature._fileName = armatureFile
	-- armature._invoke = deleteEffect
	-- armature._actionIndex = 0
	-- armature._nextAction = 0
	-- if loop ~= nil and loop > 0 then
		-- armature._LastsCountTurns = loop
	-- else
		-- armature._LastsCountTurns = -1
	-- end
	
	-- if ZOrder ~= nil then
		-- armaturePad:addChild(armature, ZOrder)
	-- else
		-- armaturePad:addChild(armature)
	-- end
	-- if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
		-- armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	-- end
	-- armature:setPosition(cc.p(armaturePad:getContentSize().width/2, armaturePad:getContentSize().height/2))
	-- armature:getAnimation():playWithIndex(0)
	-- armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)

	--> print("*********************", fileIndex)
	-- armature._duration = dms.int(dms["duration"], fileIndex, 1) / 60.0
	-- return armature
-- end

ccaf = function(start_pos, pos)
	local len_y = pos.y - start_pos.y
	local len_x = pos.x - start_pos.x
	local tan_yx = math.abs(len_y)/math.abs(len_x)
	local angle = 0
	local M_PI = 3.14159265358979323846
	if(len_y > 0 and len_x < 0) then
		angle = math.atan(tan_yx)*180/M_PI - 90;
	elseif (len_y > 0 and len_x > 0) then
		angle = 90 - math.atan(tan_yx)*180/M_PI;
	elseif(len_y < 0 and len_x < 0) then
		angle = -math.atan(tan_yx)*180/M_PI - 90;
	elseif(len_y < 0 and len_x > 0) then
		angle = math.atan(tan_yx)*180/M_PI + 90;
	end
	return angle
end

draw.createEffect = function(armatureName, armatureFile, armaturePad, loop, ZOrder, actionTimeSpeed)
	loadEffect(armatureFile)
	local armature = ccs.Armature:create(armatureName)
	armature._fileName = armatureFile
	armature._invoke = deleteEffect
	armature._actionIndex = 0
	armature._nextAction = 0
	if loop ~= nil and loop > 0 then
		armature._LastsCountTurns = loop
	else
		armature._LastsCountTurns = -1
	end
	
	if ZOrder ~= nil then
		armaturePad:addChild(armature, ZOrder)
	else
		armaturePad:addChild(armature)
	end
	if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
		armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	end
	armature:setPosition(cc.p(armaturePad:getContentSize().width/2, armaturePad:getContentSize().height/2))
	armature:getAnimation():playWithIndex(0)
	armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
	return armature
end

draw.share = function()

end

function missionIsOver()
	return true
end
function executeNextEvent()
	return false
end
function executeMissionExt()
	return false 				
end

--首充CG弹出逻辑
--level 等级
--npcId 解锁的NPC
draw.drawFirstRechargeCG = function(level, npcId)
	-- if missionIsOver() == true and zstring.tonumber(""..npcId) == 8 then
		-- --LuaClasses["FirstRechargeCGClass"].Draw()
		-- _ED._isOpenFirstRechargeCG = true
	-- elseif missionIsOver() == true and zstring.tonumber(""..npcId) == 31 then
		-- --LuaClasses["FirstRechargeCGClass"].Draw()
		-- _ED._isOpenFirstRechargeCG = true
	-- elseif missionIsOver() == true and zstring.tonumber(""..npcId) == 62 then
		-- --LuaClasses["FirstRechargeCGClass"].Draw()
		-- _ED._isOpenFirstRechargeCG = true
	-- end
end

function executeNextRoundBattleEvent(roundCount)
	return false
end

function playBgm(filePath)
	return ""
end

function stopBgm()

end

function formatMusicFile(pathRoot, musicIndex)
	return ""
end

function playEffect(filePath)
	
end

function upLevelTriggerMission()

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
local kZOrderInMap_MoveRole		= 1	
local kZOrderInMap_Effect		= 2		
local kZOrderInMap_Hurt			= 3		
local kZOrderInMap_sp_effect	= 4

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
local lockBattleRun				= false
local battleRunning				= false

-- 战斗中的环境变量
local moveFrameTime = 0.013
local moveFrameSpace = 4
local moveToTargetTime = 0.5
local moveToTargetTime1 = dms.int(dms["durationmt"], 1, 1) / 60.0
local moveToTargetTime2 = dms.int(dms["durationmt"], 2, 1) / 60.0

-- 定义英雄动作帧组索引
-- {_actionIndex=0, _nextAction= _changing=false, _nextFunc = nil, _invoke = nil}
local roleTag = 1
local animation_standby 				= 0		-- 待机
local animation_move 					= 1		-- 移动开始
local animation_moving 					= 2		-- 移动中
local animation_move_end				= 3		-- 移动结束帧
local animation_melee_attack_began		= 4		-- 近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧
local animation_melee_attacking			= 5		-- 近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作
local animation_remote_attack_began		= 6		-- 远程攻击前段，在原地，播放一个次，是准备攻击的动作帧
local animation_remote_attacking		= 7		-- 远程攻击中段，在原地，播放一个次，是攻击动作
local animation_melee_skill_began		= 8		-- 技能近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧
local animation_melee_skilling			= 9		-- 技能近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作
local animation_remote_skill_began		= 10	-- 技能攻击远程前段，在原地，播放一个次，是准备攻击的动作帧
local animation_remote_skilling			= 11	-- 技能攻击远程中段，在原地，播放一个次，是攻击动作
local animation_hero_by_attack			= 12	-- 我方被攻击，在原地，播放一个次
local animation_emeny_by_attack			= 13	-- 敌方被攻击，在原地，播放一个次
local animation_in_elite				= 14	-- 进入副本，在原地，播放一个次
local animation_death					= 15	-- 死亡，在原地，播放一个次
local animation_melee_attack_end		= 16	-- 近身攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，并且回到原位置，切换到待机帧
local animation_remote_attack_end		= 17	-- 远程攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
local animation_melee_skill_end			= 18	-- 技能攻击近身后段，播放一个次，在攻击动作播放完毕以后，播放一次，并且回到原位置，切换到待机帧
local animation_remote_skill_end		= 19	-- 技能远程攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
local animation_hero_miss				= 20	-- 我方闪避，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
local animation_emeny_miss				= 21	-- 敌方闪避，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
local animation_is_death				= 22	-- 死亡在战场中
local animation_attack_moving			= 23	-- 近身攻击上的移动帧组
local animation_skill_moving			= 24	-- 技能近身攻击上的移动帧组
local animation_revolve					= 25	-- 旋转帧组
local death_buff						= 26	-- 死亡墓碑动画
local death_buff_end                    = 27	-- 死亡坟墓消失动画
-- local into1								= 28	-- 出场动画1
-- local into2								= 29	-- 出场动画2
-- local into3								= 30	-- 出场动画3
-- local into4								= 31	-- 出场动画4
-- local into5								= 32	-- 出场动画5
-- local into6								= 33	-- 出场动画6
-- local animation_difangmove				= 34	-- 敌方移动
-- local animation_difangmoving			= 35	-- 敌方移动中
-- local animation_difangmove_end			= 36	-- 敌方移动结束
-- local animation_heti1					= 37	-- 逆时针合体技能动画
-- local animation_heti2					= 38	-- 顺时针合体技能动画


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
local heroJoinBattle = nil					-- 角色出场
local moveTeam = nil						-- 移动队伍进入战斗
local moveUnionTeam = nil					-- 
local initBattle = nil						-- 初始化战斗中的我方角色
local initEnemy = nil						-- 初始化战斗中的敌方角色
local startBattle = nil						-- 开始战斗
local nextRoundBattle = nil					-- 下一回合的战斗
local nextAttack = nil						-- 下一个角色进行攻击
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
local isSkepBattle = false

-- nextAttack  Variable
local mPosTile = nil
local mpos = nil
local mtime = 0

local initNextRoundBattle = nil --军团副本回合结算,初始化下一回合
local lastTimeRoundBattleNumber = 0 -- 军团副本战斗上次回合的活动对象数
local currentcurrent_scene_npc_id_length = nil --当前副本的部队数
local battleMoveUnionTeamY = nil
local mschedulerEntry=nil
local mScheduler=nil



function getRageHead()
	local rage_head_image = "images/face/rage_head/rage_head_%s.png"
	if __lua_project_id == __lua_project_bleach or 
		__lua_project_id == __lua_project_superhero or
		__lua_project_id == __lua_project_all_star or
		__lua_project_id == __lua_king_of_adventure then
		rage_head_image = "images/face/big_head/big_head_%s.png"
	end
	return rage_head_image
end

function isRunning()
	return battleRunning
end

function setRunning(run)
	lockBattleRun = run == true and false or true
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

local function updateGoldBossInfo()
	draw.label(BattleSceneClass._GoldBossCell, "Label_9102_1", BattleSceneClass.curDamage)
	draw.label(BattleSceneClass._GoldBossCell, "Label_9103_1", DamageToMoney())
	draw.label(BattleSceneClass._GoldBossCell, "Label_9104_1", currentRoundIndex.."/5")
end	

-- function 
local function getRolePad(camp, pos)
	local campIndex = 0
	if camp == "1" then
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		campIndex = ofsetCount
	else
	end
	return ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", campIndex, pos))
end

-- -- 播放音效
-- playEffectMusic = function(musicIndex)
-- 	-- 播放音效
-- 	-- playEffect(formatMusicFile("effect", musicIndex))
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
--local changeAction_animationEventCallFunc = nil

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
	armature._actionLoopCount = 0
	armature._changing = true
	armature:getAnimation():playWithIndex(changeToAction)
	armature._actionIndex = changeToAction
	armature._nextAction = animation_standby
	armature._changing = nil
end

local function setVisibleBone(armature, boneName, var)
	armature:getBone(boneName):setVisible(false)
end

local function showRoleHP(armature)
	if armature ~= nil and armature._hpPragress ~= nil then
		armature._role._hp = armature._role._hp < 0 and 0 or armature._role._hp
		local percent = armature._role._hp/armature._brole._hp * 100
		percent = percent > 100 and 100 or percent
		armature._hpPragress:setPercent(percent)
		if percent <= 0 and armature._isDeath == true then
			armature._hpPragress:getParent():setVisible(false)
		end
		
		-- 更新角色hp显示
		if armature._camp == "0" then
			-- 玩家血量更新
			--> print("我方角色血量更新", armature._pos, tonumber(percent))
			state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 2, _type = 1, _roleIndex = armature._pos, _value = percent})
		else
			-- 敌方血量更新
			--> print("敌方角色血量更新", armature._pos, tonumber(percent))
			state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 1, _type = 1, _roleIndex = armature._pos, _value = percent})
		end
	end
end

local function showRoleSP(armature)
	if __lua_project_id==__lua_project_all_star then 
		if zstring.tonumber(_ED._scene_npc_id) == 453 and armature._role._id == "1518" and armature._camp=="1" then
			local _sp = armature._role._sp
			setVisibleBone(armature, "power1", false)
			setVisibleBone(armature, "power2", false)
			setVisibleBone(armature, "power3", false)
			setVisibleBone(armature, "power4", false)
		
			setVisibleBone(armature, "power_effect",false)
			setVisibleBone(armature, "power_multi", false)
			setVisibleBone(armature, "power_number",false)
			if _sp > 4 then
				armature._spNumber:setString("".._sp)
			end
		else
			local _sp = armature._role._sp
			setVisibleBone(armature, "power1", (_sp > 0 and true or false))
			setVisibleBone(armature, "power2", (_sp > 1 and true or false))
			setVisibleBone(armature, "power3", (_sp > 2 and true or false))
			setVisibleBone(armature, "power4", (_sp > 3 and true or false))
			
			setVisibleBone(armature, "power_effect", (_sp > 4 and true or false))
			setVisibleBone(armature, "power_multi", (_sp > 4 and true or false))
			setVisibleBone(armature, "power_number", (_sp > 4 and true or false))
			if _sp > 4 then
				armature._spNumber:setString("".._sp)
			end
		end
	elseif __lua_project_id == __lua_king_of_adventure then
		if armature._role._id == "1500" then
			local _sp = armature._role._sp
			setVisibleBone(armature, "power1", false)
			setVisibleBone(armature, "power2", false)
			setVisibleBone(armature, "power3", false)
			setVisibleBone(armature, "power4", false)
		
			setVisibleBone(armature, "power_effect",false)
			setVisibleBone(armature, "power_multi", false)
			setVisibleBone(armature, "power_number",false)
			if _sp > 4 then
				armature._spNumber:setString("".._sp)
			end
		else
			local _sp = armature._role._sp
			setVisibleBone(armature, "power1", (_sp > 0 and true or false))
			setVisibleBone(armature, "power2", (_sp > 1 and true or false))
			setVisibleBone(armature, "power3", (_sp > 2 and true or false))
			setVisibleBone(armature, "power4", (_sp > 3 and true or false))
			
			setVisibleBone(armature, "power_effect", (_sp > 4 and true or false))
			setVisibleBone(armature, "power_multi", (_sp > 4 and true or false))
			setVisibleBone(armature, "power_number", (_sp > 4 and true or false))
			if _sp > 4 then
				armature._spNumber:setString("".._sp)
			end
		end
	else
		local _sp = armature._role._sp
		setVisibleBone(armature, "power1", (_sp > 0 and true or false))
		setVisibleBone(armature, "power2", (_sp > 1 and true or false))
		setVisibleBone(armature, "power3", (_sp > 2 and true or false))
		setVisibleBone(armature, "power4", (_sp > 3 and true or false))
		
		setVisibleBone(armature, "power_effect", (_sp > 4 and true or false))
		setVisibleBone(armature, "power_multi", (_sp > 4 and true or false))
		setVisibleBone(armature, "power_number", (_sp > 4 and true or false))
		-- if _sp > 4 then
			armature._spNumber:setString("".._sp)
		-- end
	end 
	
	--> print("更新怒气显示了********************", tonumber(armature._role._sp))
	-- 设置角色怒气
	if armature._camp == "0" then
		-- 玩家怒气更新
		state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 2, _type = 2, _roleIndex = armature._pos, _value = armature._role._sp})
	else
		-- 敌人怒气更新
		state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 1, _type = 2, _roleIndex = armature._pos, _value = armature._role._sp})
	end
end

local function updateHPPragress(armature)
	
end


local function getUnionFightInfo()
	local fight = nil	
	if _ED.battleData.battle_init_type == fight_type_7 then
		fight = _ED.union.union_counterpart_info.counterpart_fight
	elseif _ED.battleData.battle_init_type == fight_type_8 then
		fight = _ED.union.union_battleground_fight
	end
	
	return fight
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
	
	if __lua_project_id == __lua_king_of_adventure then
		parent_node:reorderChild(mPosTile, mPosTile._oldZOrder)
	else
		parent_node:reorderChild(mPosTile, kZOrderInMap_StanddyRole)
	end
	executeAttackerBuff()
end

local function executeHeroMoveByBack()
	-- -- local array = CCArray:createWithCapacity(10)
	--array:addObject(CCActionInterval:create(1.2))
	if mpos ~= nil then
		local seq = cc.Sequence:create(
			cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(-1 * mpos.x, -1 * mpos.y)),
			cc.CallFunc:create(executeHeroMoveByBackOverFunc)
		)
		mPosTile:runAction(seq)
		if __lua_project_id == __lua_king_of_adventure then
			mPosTile._armature:runAction(cc.ScaleTo:create(mtime * actionTimeSpeed, mPosTile._armature._brole._scale))
		end
	end
end

-- 移动到目标点				
local function executeHeroMoveBy()
	-- local array = CCArray:createWithCapacity(10)
	-- --array:addObject(CCActionInterval:create(1.2))
	-- array:addObject(cc.MoveBy:create(mtime * actionTimeSpeed, mpos))
	-- array:addObject(CCCallFunc:create(executeMoveOverFunc))
	local seq = cc.Sequence:create(
		cc.MoveBy:create(mtime * actionTimeSpeed, mpos),
		cc.CallFunc:create(executeMoveOverFunc)
	)
	mPosTile:runAction(seq)
	if __lua_project_id == __lua_king_of_adventure then
		mPosTile._armature:runAction(cc.ScaleTo:create(mtime * actionTimeSpeed, mPosTile._mscale))
	end 
	-- 修改 Z轴
	began_hero_ZOrder = mPosTile:getLocalZOrder()
	local parent_node = mPosTile:getParent()
	
	if __lua_project_id == __lua_king_of_adventure then
		parent_node:reorderChild(mPosTile, 2)
	else
		parent_node:reorderChild(mPosTile, kZOrderInMap_MoveRole)
	end
end
-- END~攻击前的移动准备
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 近身移动
executeMoveMeleeAttackBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_attack_moving
	armature._invoke = attackChangeActionCallback
	-- 近身移动
end

-- 近身攻击
executeMeleeAttackBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_attack_began
	armature._invoke = attackChangeActionCallback
	-- 近身攻击1
end

executeMeleeAttacking = function(armatureBack)
	--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
	--mtime = moveToTargetTime1
	--executeHeroMoveBy()
					
	executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_melee_attacking
	-- 近身攻击2
end

executeMeleeAttackEnd = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_attack_end
	-- 近身攻击3
end
-- END~近身攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 远程攻击
executeRemoteAttackBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_attack_began
	armature._invoke = attackChangeActionCallback
	-- 远程攻击1
end

executeRemoteAttacking = function(armatureBack)
	executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_remote_attacking
	-- 远程攻击2
end

executeRemoteAttackEnd = function(armatureBack)
	--executeAttacking()
	local armature = armatureBack
	armature._nextAction = animation_remote_attack_end
	armature._over = true
	-- 远程攻击3
	
	--armatureBack:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
end
-- END~远程攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 移动技能近身攻击
executeMoveMeleeSkillBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_skill_moving
	armature._invoke = attackChangeActionCallback
	-- 技能近身攻击1
end

-- 技能近身攻击
executeMeleeSkillBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_skill_began
	armature._invoke = attackChangeActionCallback
	-- 技能近身攻击1
end

executeMeleeSkilling = function(armatureBack)	
	--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
	--mtime = moveToTargetTime2
	--executeHeroMoveBy()
	
	executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_melee_skilling
	-- 技能近身攻击2
end

executeMeleeSkillEnd = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_skill_end
	-- 技能近身攻击3
end
-- END~技能近身攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 技能远程攻击
executeRemoteSkillBegan = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_skill_began
	armature._invoke = attackChangeActionCallback
	-- 技能远程攻击1
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
	-- 技能远程攻击2
end

executeRemoteSkillEnd = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_skill_end
	-- 技能远程攻击3
end
-- END~技能远程攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 被攻击光效
executeHeroByAttack = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_hero_by_attack
	armature._invoke = attackChangeActionCallback
end

executeEmenyByAttack = function(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_emeny_by_attack
	armature._invoke = attackChangeActionCallback
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
		_posTile:removeAllChildren(true)
	end
end
		
-- 角色死亡光效
executeRoleDeath = function(armatureBack)
	-- 角色进行死亡帧
	local armature = armatureBack
	armature._isDeath = true
	armature._nextAction = animation_death
	armature._invoke = attackChangeActionCallback
	
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
		-- 我方角色死亡, 通知UI层更新状态
		-- 清除角色的BUFF
		if armatureBack ~= nil and armatureBack._posTile ~= nil and armatureBack._posTile._buff ~= nil then
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
end
-- END~被攻击光效
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 技能技能光效帧事件监听

local function removeFrameObjectFuncN(sender)
	sender:removeFromParent(true)
end

local function drawAntNumber(_parent, _number, numberFilePath, _tempX, _tempY, _widgetSize, _hurtCount)
	local _numberArray = {}
	for i=1, #_number  do
		table.insert(_numberArray, _number:sub(i, i))
	end
	local _pnode = Widget:create()
	_pnode:setAnchorPoint(cc.p(0.5, 0.5))
	
	local _node = Widget:create()
	_node:setAnchorPoint(cc.p(0.5, 0.5))
	local index = 0
	local _width = 0
	local _height = 0
	local _offHeight = 0
	for i, v in pairs(_numberArray) do
		if v == "-" or v == "+" then
		else
			local labelAtlas = cc.LabelAtlas:_create(v, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)
			local labelAtlasSize = labelAtlas:getContentSize()
			if _height == 0 then
				_offHeight = _offHeight + labelAtlasSize.height/9.0
				_height = _height + labelAtlasSize.height + _offHeight
			end
			labelAtlas:setPosition(cc.p(_width, _offHeight * ((index + 1) % 2)))
			_node:addChild(labelAtlas)
			
			if v == "-" or v == "+" then
				_width = _width + labelAtlasSize.width
			else
				_width = _width + labelAtlasSize.width/2
				index = index + 1
			end
		end
	end
	_pnode:setContentSize(cc.size(_width, _height))
	_node:setContentSize(cc.size(_width, _height))
	_parent:addChild(_pnode, kZOrderInMap_Hurt)
	_pnode:addChild(_node, kZOrderInMap_Hurt)
	
	_pnode:setPosition(cc.p(_tempX + _widgetSize.width / 2, _tempY + _widgetSize.height / 2))
	_node:setPosition(cc.p(_width / 2, _height / 2))
	if __lua_project_id == __lua_king_of_adventure then
	else
		_node:setScale(0.5)
	end
	_node:setOpacity(0)
	
	local function removeDrawAntNumberFuncN(sender)
		sender:getParent():removeFromParent(true)
	end
	
	if __lua_project_id == __lua_king_of_adventure then
		local scaleSeq = cc.Sequence:create(
			cc.MoveBy:create(0.3 * actionTimeSpeed, ccpf(0, 60)),
			cc.MoveBy:create(0.5 * actionTimeSpeed, ccpf(20, 60)),
			cc.CallFunc:create(removeDrawAntNumberFuncN)
		)
		_node:runAction(scaleSeq)
		
		local fadeOutSeq = cc.Sequence:create(
			cc.FadeIn:create(0.4 * actionTimeSpeed),
			cc.DelayTime:create(2 * actionTimeSpeed),
			cc.FadeOut:create(1 * actionTimeSpeed)
		)
		_node:runAction(fadeOutSeq)
	else
		local scaleSeq = cc.Sequence:create(
			cc.ScaleTo:create(0.3 * actionTimeSpeed, 1.8),
			cc.ScaleTo:create(0.2 * actionTimeSpeed, 1),
			cc.MoveBy:create(0.5 * actionTimeSpeed, ccpf(0, 100)),
			cc.CallFunc:create(removeDrawAntNumberFuncN)
		)
		_node:runAction(scaleSeq)
		
		local fadeOutSeq = cc.Sequence:create(
			cc.FadeIn:create(0.3 * actionTimeSpeed),
			cc.DelayTime:create(0.4 * actionTimeSpeed),
			cc.FadeOut:create(0.5 * actionTimeSpeed)
		)
		_node:runAction(fadeOutSeq)
	end
	return _pnode
end

local function drawFrameEvent(armature, armatureBase, _def)
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
	
	
	if defenderST == "1" or defenderST == "2" or defenderST == "3" or 
			defenderST == "4" or defenderST == "5" or
			defenderST == "6" or
			defenderST == "7" or defenderST == "8" or 
			defenderST == "9" or
			defenderST == "10" or defenderST == "11" or 
			defenderST == "12" or defenderST == "14" then
	elseif changeToAction ~= nil  and armatureBase._isDeath ~= true then
		animationChangeToAction(armatureBase, changeToAction, animation_standby)
	end
	
	if armatureBase._isReact == true or defState == "3" or defState == "4" then
		if armatureBase._isReacting ~= true then
			armatureBase._isReacting = true
			-- 已经进入到了反击
			executeEffectSkillEnd(armature)
		end
	else
		-- 修改BUFF处理状态(6为中毒，9为灼烧)
		if __lua_project_id == __lua_project_bleach then
			if (defenderST == "4" or defenderST == "5" or defenderST == "6" or defenderST == "7" or 
				defenderST == "8" or defenderST == "9" or defenderST == "10" or defenderST == "11" or 
				defenderST == "12" or defenderST == "13" or defenderST == "15") then
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
		else
			if (defenderST == "4" or defenderST == "5" or defenderST == "6" or defenderST == "7" or 
				defenderST == "8" or defenderST == "9" or defenderST == "11" or defenderST == "12") then
				if armature._executeBuffs == nil then
					armature._executeBuffs = {}
				end
				if armature._executeBuffs[armature._def.defenderST] ~= true then 
					armature._executeBuffs[armature._def.defenderST] = true
					-- 处理被攻击的后段光效
					armature._base = armatureBase
					executeEffectSkillEnd(armature)
				end
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
		
	-- 处理伤害
	-- 技能种类：0为攻击，1为加血，2为加怒，3为减怒，4为禁怒，5为眩晕，6为中毒，7为麻痹，8为封技，9为灼烧，10为爆裂，11为增加档格，12为增加防御, 13为必闪, 14为吸血,15禁疗
	if defenderST == "0" or
		defenderST == "6"
		then
		if tonumber(_def.defender) == 1 then
			BattleSceneClass.curDamage = BattleSceneClass.curDamage + tonumber(drawString)
		end
		if tonumber(drawString) > 0  then
			drawString = "-"..drawString
		end
	elseif defenderST == "1" or 
		defenderST == "9" 
		then
		drawString = "+"..drawString
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
	
	
	local numberFilePath = nil
	-- 0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格
	if defState == "0" or defState == "3" or defState == "4" then
		-- 命中
		if __lua_project_id == __lua_project_bleach then
			if defenderST == "1" or defenderST == "14" then
				numberFilePath = "images/ui/number/jiaxue.png"
				if armatureBase._role._hp ~= nil and drawString ~= nil and drawString ~= "" then 
					armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
				end
				showRoleHP(armatureBase)
			elseif defenderST == "2" or defenderST == "3" or 
				defenderST == "4" or defenderST == "5" or defenderST == "6" or 
				defenderST == "7" or defenderST == "8" or defenderST == "9" or 
				defenderST == "10" or defenderST == "11" or defenderST == "12" or defenderST == "13" or defenderST == "15" then
			else
				numberFilePath = "images/ui/number/xue.png"
				armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
				showRoleHP(armatureBase)
			end
		else
			if defenderST == "1" or defenderST == "14" then
				numberFilePath = "images/ui/number/jiaxue.png"
				if armatureBase._role._hp ~= nil and drawString ~= nil and drawString ~= "" then 
					armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
				end
				showRoleHP(armatureBase)
			elseif defenderST == "2" or defenderST == "3" or 
				defenderST == "4" or defenderST == "5" or defenderST == "6" or 
				defenderST == "7" or defenderST == "8" or defenderST == "9" or 
				defenderST == "11" or defenderST == "12" then
			else
				numberFilePath = "images/ui/number/xue.png"
				armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
				showRoleHP(armatureBase)
			end
		end
	elseif defState == "1" then
		if defenderST == "0" then
			-- 闪避
			local miss = cc.Sprite:create("images/ui/battle/shanbi.png")
			miss:setAnchorPoint(cc.p(0.5, 0.5))
			miss:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
			_widget:getParent():addChild(miss, kZOrderInMap_Hurt)
			
			if _widget._scale ~= nil then
				miss:setScale(_widget._scale)
			end
			
			local seq = cc.Sequence:create(
				cc.MoveBy:create(0.2 * actionTimeSpeed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
				cc.CallFunc:create(removeFrameObjectFuncN)
			)
			miss:runAction(seq)
			if __lua_project_id == __lua_project_bleach then
				cleanBuffEffectWithMiss(armatureBase._posTile,true)
			end
		end
	elseif defState == "2" or defState == "4" then
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
	
	if defenderST == "2" or defenderST == "3" then
		if _def.stVisible == "1"  and  defState ~= "1" and defState ~= "5" then
			-- 怒气动画
			local spSprite = cc.Sprite:create(string.format("images/ui/battle/%s.png", defenderST == "2" and "nuqijia" or "nuqijian"))
			spSprite:setAnchorPoint(cc.p(0.5, 0.5))
			spSprite:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
			_widget:getParent():addChild(spSprite, kZOrderInMap_Hurt)
			
			if _widget._scale ~= nil then
				spSprite:setScale(_widget._scale)
			end
			
			local seq = cc.Sequence:create(
				cc.MoveBy:create(0.5 * actionTimeSpeed, cc.p(0, (defenderST == "2" and 1 or -1) * 100 / CC_CONTENT_SCALE_FACTOR())),
				cc.CallFunc:create(removeFrameObjectFuncN)
			)
			spSprite:runAction(seq)
		end
	end
	
	local labelAtlas = nil
	if __lua_project_id == __lua_king_of_adventure 
	or __lua_project_id == __lua_project_koone then
		if numberFilePath ~= nil and drawString~= nil then
			local _numberNode = drawAntNumber(_widget:getParent(), drawString, numberFilePath, tempX, tempY, widgetSize, armature._hurtCount)
			if _widget._scale ~= nil then
				_numberNode:setScale(_widget._scale)
			end
		end
	else
		if numberFilePath ~= nil and drawString~= nil then
			labelAtlas = cc.LabelAtlas:_create(drawString, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
			-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
			labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
			labelAtlas:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0 + armature._hurtCount * ( 4))) 
			_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt) 
			
			if _widget._scale ~= nil then
				labelAtlas:setScale(_widget._scale)
			end
			
			if defState == "2" or defState == "4" then
				local crit = cc.Sprite:create("images/ui/battle/baoji.png")
				crit:setAnchorPoint(cc.p(0.5, 0.5)) 
				labelAtlas:addChild(crit, kZOrderInMap_Hurt)
				crit:setPosition(cc.p(labelAtlas:getContentSize().width/2, crit:getContentSize().height + labelAtlas:getContentSize().height/2))
			end
			
			local seq = nil
			if defState == "0" then
				seq = cc.Sequence:create(
					cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 2),
					cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 1.0),
					cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
					cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
					cc.CallFunc:create(removeFrameObjectFuncN)
				)
			else
				seq = cc.Sequence:create(
					cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
					cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
					cc.CallFunc:create(removeFrameObjectFuncN)
				)
			end	
			labelAtlas:runAction(seq)
		
		end
	end
	
	if defenderST == "0" then
		armature._hurtCount = armature._hurtCount + 1
	end
	
	-- 进入死亡状态
	if defAState == "1" and armatureBase ~= nil and 
		armatureBase._isDeath ~= true then
		executeRoleDeath(armatureBase)
	end
end

local function excecuteFrameEvent(armatureBack, armatureBase)
	local armature = armatureBack
	armature._hurtCount = armature._hurtCount == nil and 0 or armature._hurtCount
	local _widget = armatureBase._posTile
	if _widget == nil then
		return
	end
	if armatureBase._defs ~= nil then
		for i, v in pairs(armatureBase._defs) do
			drawFrameEvent(armature, armatureBase, v)
		end
	else
		drawFrameEvent(armature, armatureBase, armature._def)
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
	
	excecuteFrameEvent(armature, armature._base)
	
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
			--	excecuteFrameEvent(rPad._armature, rPad._armature)
			--end
			erole[""..defender..">"..defenderPos] = rPad._armature
		end
	end
	for i, v in pairs(erole) do
		excecuteFrameEvent(v , v)
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
	
	--[[
	if _def._attackSection <= 0 then
		return
	end
	_def._attackSection = _def._attackSection - 1
	--]]
	
	excecuteFrameEvent(armature)
	
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
	
	--[[
	if _def._attackSection <= 0 then
		return
	end
	_def._attackSection = _def._attackSection - 1
	--]]
	
	excecuteFrameEvent(armature)
	
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
	
	--[[
	if _def._attackSection <= 0 then
		return
	end
	_def._attackSection = _def._attackSection - 1
	--]]
	
	excecuteFrameEvent(armature)
end

-- END~技能技能光效帧事件监听
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 技能光效处理

local function excuteSPSkillEffectOver(armatureBack)
	deleteEffectFile(armatureBack)
	executeHeroMoveToTarget()
end

local function excuteSPSkillEffect(posTile, armatureBack)
	local shipEffect = -1
	local effectName = -1
	if armatureBack._brole._type == "0" then
		-- effectName = elementAtToString(shipMoulds, armatureBack._brole._mouldId, ship_mould.screen_attack_effect)
		effectName = dms.string(dms["ship_mould"], armatureBack._brole._mouldId, ship_mould.screen_attack_effect)
		if zstring.tonumber(armatureBack._brole._head) < 10000 then
			shipEffect = effectName
		else
			shipEffect = armatureBack._brole._head
		end
	else
		-- effectName = elementAtToString(enviromentShip, armatureBack._brole._mouldId, environment_ship.screen_attack_effect)
		effectName = dms.string(dms["environment_ship"], armatureBack._brole._mouldId, environment_ship.screen_attack_effect)
		shipEffect = effectName
	end

	if shipEffect ~= nil and tonumber(shipEffect) > -1 then
		playEffect(formatMusicFile("effect", 9994))
		-- local skillName = elementAtToString(skillMould, armatureBack._currentSkillMouldId, skill_mould.skill_name)
		local skillName =  dms.string(dms["skill_mould"], armatureBack._currentSkillMouldId, skill_mould.skill_name)
		local size = draw.size()
		
		local armature = nil
		if __lua_project_id == __lua_king_of_adventure then
			if posTile._camp =="0" then
				local armatureFile = string.format("hero_head_effect_%s", _ED.user_info.user_gender)
				local armaturePve = ccs.Armature:create(armatureFile)
				if armatureBack._brole._id == _ED.battle_fashion_info[1].leaderId or 
					armatureBack._brole._id == "1292" or
					armatureBack._brole._id == "1293" or
					armatureBack._brole._id == "1455" or
					armatureBack._brole._id == "1456" or
					armatureBack._brole._id == "1459" or
					armatureBack._brole._id == "1460" or
					armatureBack._brole._id == "1463" or
					armatureBack._brole._id == "1464" then
					BattleSceneClass.initBattleFashion(armaturePve, 1)
				end
				armature = armaturePve
			else
				if _ED.battleData.battle_init_type == 11 or _ED.battleData.battle_init_type == 12 or _ED.battleData.battle_init_type == 13 then
					local armatureFile = string.format("hero_head_effect_%s", _ED.battle_fashion_info[2].genderId)
					local armaturePvp = ccs.Armature:create(armatureFile)
					if armatureBack._brole._id == _ED.battle_fashion_info[2].leaderId then
						BattleSceneClass.initBattleFashion(armaturePvp, 2)
					end
					armature = armaturePvp
				elseif _ED.battleData.battle_init_type == 10 then
					if armatureBack._brole._id == _ED.battle_fashion_info[2].leaderId then
						local armatureFile = string.format("hero_head_effect_%s", _ED.battle_fashion_info[2].genderId)
						local armaturePvp = ccs.Armature:create(armatureFile)
						
						BattleSceneClass.initBattleFashion(armaturePvp, 2)
						armature = armaturePvp
					else
						local armatureFile = string.format("hero_head_effect_%s", _ED.user_info.user_gender)
						local armaturePve = ccs.Armature:create(armatureFile)
						armature = armaturePve
					end
				else
					local armatureFile = string.format("hero_head_effect_%s", _ED.user_info.user_gender)
					armature = ccs.Armature:create(armatureFile)
				end
			end
		else
			armature = ccs.Armature:create("hero_head_effect")
		end
		
		armature:getAnimation():playWithIndex(animation_standby)
		armature:setPosition(cc.p(size.width/2, size.height/2))
		armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
		armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
		armature._invoke = excuteSPSkillEffectOver
		draw.graphics(armature, kZOrderInMap_sp_effect)

		local imagePath = nil
		if __lua_project_id == __lua_king_of_adventure then
			if posTile._camp =="0" then
				for i, v in pairs(_ED.battleData._heros) do
					if v._head == "601" or v._head == "604" or v._head == "605" or v._head == "608" then
						imagePath = string.format(getRageHead(), shipEffect+100)
					else
						imagePath = string.format(getRageHead(), shipEffect)
					end
				end
			else
				imagePath = string.format(getRageHead(), shipEffect)
			end
		else
			imagePath = string.format(getRageHead(), shipEffect)
		end
		
		local head = ccs.Skin:create(imagePath)
		armature:getBone("head"):addDisplay(head, 0)
		local  imagePath = ""
		if __lua_project_id == __lua_king_of_adventure then
			imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectName) 
		else
			if tonumber(armatureBack._brole._power_skill_id) > 0 then
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					local effectIndex = dms.int(dms["skill_mould"], armatureBack._brole._power_skill_id, skill_mould.buff_affect)
			  		if effectIndex > 0 then 	  		
						imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectIndex) 
					end
				else
					imagePath = string.format("images/face/rage_head/rage_name_%s.png", armatureBack._brole._power_skill_id) 
				end
			else
				imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectName) 
			end
		end
		local skill_name = ccs.Skin:create(imagePath)
		armature:getBone("skill_name"):addDisplay(skill_name, 0)
		
		local xxx, yyy = BattleSceneClass._widgetBg:getPosition()
		local bgSize = BattleSceneClass._widgetBg:getContentSize()
		local s = cc.Director:getInstance():getWinSize()
		
		if BattleSceneClass._hasWidgetBg ~= true then
			BattleSceneClass._hasWidgetBg = true
			
			local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 130), s.width * 2, s.height * 2)
			layer:setAnchorPoint(cc.p(0.5, 0.5))
			layer:ignoreAnchorPointForPosition(false)
			layer:setPosition(cc.p(xxx, -1 * yyy))
			BattleSceneClass._widgetBg:addChild(layer, -1, -1)
			BattleSceneClass._effectBg = layer
		end
	else
		local skillName = dms.string(dms["skill_mould"], armatureBack._currentSkillMouldId, skill_mould.skill_name)
		local namepad = cc.Sprite:create("images/ui/bar/battle_skill.png")
		local nameLabel = cc.Label:createWithTTF(skillName, "fonts/FZYiHei-M20S.ttf", 30 / CC_CONTENT_SCALE_FACTOR())
		nameLabel:setContentSize(cc.size(0, 0))
		-- nameLabel:setString(skillName)
		-- nameLabel:setFontName("fonts/FZYiHei-M20S.ttf")-->设置字体名字
		-- nameLabel:setFontSize(30 / CC_CONTENT_SCALE_FACTOR())-->设置字体大小
		nameLabel:setAnchorPoint(cc.p(0.5, 0.5))-->设置锚点
		nameLabel:setPosition(cc.p(namepad:getContentSize().width/2, namepad:getContentSize().height/2))
		namepad:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
		namepad:addChild(nameLabel)
		posTile:addChild(namepad)
		
		local function removeSkillNameFunN(sender)
			sender:removeFromParent(true)
		end
		local seq = cc.Sequence:create(
			cc.DelayTime:create(90.0/60.0 * actionTimeSpeed),
			cc.CallFunc:create(removeSkillNameFunN)
		)
		namepad:runAction(seq)
		
		executeHeroMoveToTarget()
	end
end

-- 加载光效资源文件
-- effect_6006.ExportJson
loadEffectFile = function(fileIndex)
	local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
	--CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
	local armatureName = string.format("effice_%d", fileIndex)
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

createEffect = function(armaturePad, fileIndex, _camp, addToTile)
	-- 创建光效
	local armatureName, fileName = loadEffectFile(fileIndex)
	local posTile = armaturePad
	local armature = ccs.Armature:create(armatureName)
	armature._fileName = fileName
	local tempX, tempY  = posTile:getPosition()
	armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2, tempY + posTile:getContentSize().height/2))
	armature:getAnimation():playWithIndex(zstring.tonumber("".._camp))
	armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
	if addToTile == true then
		armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
		posTile:addChild(armature, kZOrderInMap_Effect)
	else	
		posTile:getParent():addChild(armature, kZOrderInMap_Effect)
	end
	armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	
	armature._duration = dms.int(dms["duration"], fileIndex, 1) / 60.0
	-- if __lua_project_id == __lua_king_of_adventure then
		-- if posTile._scale ~= nil then
			-- armature:setScale(posTile._scale)
		-- end
	-- end
	return armature
end



-- 技能光效前段
executeEffectSkillBegan = function(armatureBack)
	local armature = armatureBack
	local skillInfluenceElementData = armature._sie
	local forepart_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.forepart_lighting_effect_id)
	--> print("***********************", skill_influence.forepart_lighting_effect_id)
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
	-- 准备清除技能光中段资源
	deleteEffectFile(armatureBack)
	executeHeroMoveToOriginTarget()
		
	if BattleSceneClass._hasWidgetBg == true or BattleSceneClass._effectBg ~= nil then
		BattleSceneClass._effectBg:removeFromParent(true)
		BattleSceneClass._effectBg = nil
		BattleSceneClass._hasWidgetBg = nil
	end		
end

executeEffectSkilling = function(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	-- 技能光效中段
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or mPosTile._camp)
		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, 0)
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
			
			if lightingEffectDrawMethod == 0 then
				armatureEffect:setRotation(angle)
				armatureEffect:setPosition(start_pos)
				armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))
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
				drawFrameEvent(armature, armature, v)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
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
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 and backPad~= nil then		
		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or mPosTile._camp)
		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
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
				drawFrameEvent(armature, armature, v)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

executeEffectSkilling2 = function(armatureBack)

end

executeEffectSkilling3 = function(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
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
			local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
			local posTile5 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy5 + (yy2 - yy5)))
			
		else
			local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
		
			local posTile5 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy2 + (yy5 - yy2)))
		end
		
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

executeEffectSkilling4 = function(armatureBack)

end

executeEffectSkilling5 = function(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
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
				drawFrameEvent(armature, armature, v)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
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
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
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
			local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
			local posTile5 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy5 + (yy2 - yy5) + pSize.height/2))
			
		else
			local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
		
			local posTile5 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy2 + (yy5 - yy2) + pSize.height/2))
		end
		
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

executeEffectSkilling7 = function(armatureBack, defArmatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	
	if posterior_lighting_effect_id >= 0 then		
		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or mPosTile._camp)
		
		local lightingEffectDrawMethod = dms.atoi(armatureBack._sie, skill_influence.lighting_effect_draw_method)
		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		
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
			start_pos.x = start_pos.x + pSize.width/2
			start_pos.y = start_pos.y + pSize.height/2
			end_pos.x = end_pos.x + pSize.width/2
			end_pos.y = end_pos.y + pSize.height/2
			
			if lightingEffectDrawMethod == 0 then
				armatureEffect:setRotation(angle)
				armatureEffect:setPosition(start_pos)
				armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))
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
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v)
			end
			resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			resetArmatureData(armature)
		end
		executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end


local function onUnionFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
	local armature = bone:getArmature()
	-- draw hp
	--armature._harmValue 
end

-- 公会副本的攻击光效
executeEffectSkillingUnion = function(backPad, _harmValue, isHero, offsetYPVP)
	local armatureEffect = createEffect(backPad, 82, 0)
	local tempX, tempY  = backPad:getPosition()
	armatureEffect:setPosition(cc.p(tempX + backPad:getContentSize().width/2, tempY + backPad:getContentSize().height))
	armatureEffect._invoke = deleteEffectFile
	armatureEffect._harmValue = _harmValue
	local armature = backPad._armature
	armature._hurtCount = 0
	local _widget = backPad --armatureBase._posTile
	local tempX, tempY  = _widget:getPosition()
	local widgetSize = _widget:getContentSize()
	local drawString = _harmValue*-1
	local numberFilePath = "images/ui/number/baoji.png"
	local labelAtlas = cc.LabelAtlas:_create(drawString, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
	labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
	labelAtlas:setPosition(cc.p((widgetSize.width) / 2.0, widgetSize.height / 2.0)) 
	_widget:addChild(labelAtlas, kZOrderInMap_Hurt) 
	----------------------------------------------------
	if defState == "2" or defState == "4" then
		local crit = cc.Sprite:create("images/ui/battle/baoji.png")
		crit:setAnchorPoint(cc.p(0.5, 0.5)) 
		labelAtlas:addChild(crit, kZOrderInMap_Hurt)
		crit:setPosition(cc.p(labelAtlas:getContentSize().width/2, crit:getContentSize().height + labelAtlas:getContentSize().height/2))
	end
	
	local seq = nil
	if defState == "0" then
		seq =  cc.Sequence:create(
			cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 2),
			cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 1.0),
			cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
			cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
			cc.CallFunc:create(removeFrameObjectFuncN)
		)
	else
		seq =  cc.Sequence:create(
			cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
			cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
			cc.CallFunc:create(removeFrameObjectFuncN)
		)
	end	
	labelAtlas:runAction(seq)
	
	--- 血条-------------------------------------------------------------
	armature._role._hp = armature._role._hp + drawString
	showRoleHP(armature)
	if armature._role._hp <= 0 then
		-- 死亡-------------------------------------------------------------
		battleDieMoveUnionTeam(armature, isHero, offsetYPVP)
		if isHero ~= true then
						
			local list =  zstring.split(_ED._scene_npc_id,",")
			local len = #list
			if current_scene_npc_id_length == nil then
				current_scene_npc_id_length = len
			end
			local fightRewardBoutCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_19849_1")
			current_scene_npc_id_length = current_scene_npc_id_length - 1
			fightRewardBoutCount:setString(current_scene_npc_id_length.."/"..len)
		end
	else
		-- 回退-------------------------------------------------------------
		battleRetreatMoveUnionTeam(armature, isHero, offsetYPVP)
	end
end

-- BUFF持续光效
local function executeBuffEffect(armatureBack)
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
			effectIndex = 89
		elseif armatureBack._def.defenderST == "6" then
			effectIndex = 92
		elseif armatureBack._def.defenderST == "7" then
			effectIndex = 90
		elseif armatureBack._def.defenderST == "8" then
			effectIndex = 91
		elseif armatureBack._def.defenderST == "9" then
			effectIndex = 93
		elseif armatureBack._def.defenderST == "10" then
			effectIndex = 94
		elseif armatureBack._def.defenderST == "11" then
			effectIndex = 95
		elseif armatureBack._def.defenderST == "12" then
			if __lua_project_id == __lua_project_bleach then
				effectIndex = 85
			else
				effectIndex = 95
			end
		elseif armatureBack._def.defenderST == "13" then
			if __lua_project_id == __lua_project_bleach then
				effectIndex = 84
			end
		elseif armatureBack._def.defenderST == "15" then
			if __lua_project_id == __lua_project_bleach then
				effectIndex = 83
			end
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
		armatureEffect:setScale(armature._base._brole._scale)
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
executeEffectSkillEnd = function(armatureBack)
	local armature = armatureBack
	local backPad = armature._base._posTile
	-- 技能光效后段
	-- local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local bear_lighting_effect_id = armature._base._isReact == true and 80 or dms.atoi(skillInfluenceElementData, skill_influence.bear_lighting_effect_id)

	if bear_lighting_effect_id >= 0 then
		armatureEffect = createEffect(backPad, bear_lighting_effect_id, backPad._camp)
		armatureEffect._invoke = executeBuffEffect
		armatureEffect._base = armature._base
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect:setScale(armature._base._brole._scale)
			
		--[[
		local armatureEffect = nil
		if tonumber(armature._def.stRound) > 0 then
			if backPad._buff == nil then
				backPad._buff = {}
			end
			local tarmature = backPad._buff[armature._def.defenderST]
			if tarmature ~= nil then
				armatureEffect = tarmature
			else
				tarmature._base = armature._base
				tarmature._sie = armature._sie
				tarmature._def = armature._def
				tarmature._LastsCountTurns = tonumber(armature._def.stRound)
			end
		end
		if armatureEffect == nil then
			armatureEffect = createEffect(backPad, bear_lighting_effect_id, backPad._camp)
			armatureEffect._invoke = deleteEffectFile
			armatureEffect._base = armature._base
			armatureEffect._sie = armature._sie
			armatureEffect._def = armature._def
			armatureEffect._LastsCountTurns = tonumber(armature._def.stRound)
			armatureEffect._lastEffect = true
			-- armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)
			if backPad._buff ~= nil then
				backPad._buff[armature._def.defenderST] = armatureEffect
			end
		end
		--]]
	end
	local bear_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.bear_sound_effect_id)
	if bear_sound_effect_id >= 0 then
		playEffectMusic(bear_sound_effect_id)
	end
end
-- END~技能技能光效前段
-- --------------------------------------------------------------------- --
local missTime = 0
local function cleanBattleHero()
	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
	missTime = 0
	for i=1, 6 do
		local hero = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", 0, i))
		if hero._armature ~= nil and hero._armature._isDeath == true then
			missTime = missTime + 1
			hero._armature._isDeathed = true
			hero._armature._actionIndex = death_buff
			hero._armature._nextAction = death_buff_end
			local _invoke = hero._armature._invoke
			hero._armature._invoke = nil
			hero._armature:getAnimation():playWithIndex(death_buff_end)
			hero._armature._invoke = _invoke
			-- tolua.cast(hero._armature, "CCNode"):removeFromParent(true)
			-- cleanBuffEffect(hero._armature._posTile, true)
		end
		
		local master = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, i))
		if master._armature ~= nil and master._armature._isDeath == true then
			missTime = missTime + 1
			master._armature._isDeathed = true
			master._armature._actionIndex = death_buff
			master._armature._nextAction = death_buff_end
			local _invoke = master._armature._invoke
			master._armature._invoke = nil
			master._armature:getAnimation():playWithIndex(death_buff_end)
			master._armature._invoke = _invoke
			-- tolua.cast(master._armature, "CCNode"):removeFromParent(true)
			-- cleanBuffEffect(master._armature._posTile, true)
		end
	end
end

-- --------------------------------------------------------------------- --
-- 攻击切帧控制

	function deathBuff(armatureBack,armature)
		armature._role._hp = 0
		showRoleHP(armature)
		if armatureBack._posTile._camp == "1" then
			if armatureBack._isDeathed == true then
				if armatureBack._def ~= nil then
					local fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10866")
					local str = fightRewardItemCount:getString()
					str = ""..(zstring.tonumber(str) + zstring.tonumber(armatureBack._def.dropCount))
					--tolua.cast(fightRewardItemCount,"Label"):setText(str)
					fightRewardItemCount:setString(str)
					if armatureBack ~= nil and armatureBack._def~=nil and armatureBack._def.dropCount~=nil then
						if zstring.tonumber(armatureBack._def.dropCount) > 0 then
							local armatureEffect = createEffect(armatureBack._posTile, 96, 0)
							armatureEffect._invoke = deleteEffectFile
						end
					end
				end
				armature._posTile._armature = nil
				armatureBack:removeFromParent(true)
				cleanBuffEffect(armatureBack._posTile, true)
			end
			armatureBack._isDeathed = true
			-- 敌方死亡，绘制战场的掉落！
		else
			armature._nextAction = animation_is_death
		end
				
		-- end
		if isSkepBattle == true and setDeathArmatureCount >= 0 then
			currentRoundIndex = _ED.attackData.roundCount
			setDeathArmatureCount = -1
			nextRoundBattle()
		end
		--[[
			if setDeathArmatureCount > 0 then
				setDeathArmatureCount = setDeathArmatureCount - 1
				if setDeathArmatureCount == 0 then
					currentRoundIndex = _ED.attackData.roundCount
					nextRoundBattle()
				end
			end
		--]]
	end
attackChangeActionCallback = function(armatureBack)
	local armature = armatureBack
	if armature ~= nil then
		local actionIndex = armature._actionIndex
		-- 攻击切帧控制
		if actionIndex == animation_move then
			-- 我方移动动画
			armature._nextAction = animation_moving
		elseif actionIndex == animation_moving then
			--[[
			if beganMoveHero == 0 then
				executeHeroMoveBy()
				beganMoveHero = 1
			elseif beganMoveHero == 10 then
				executeHeroMoveByBack()
				beganMoveHero = 11
			elseif beganMoveHero == 2 or beganMoveHero == 12 then
				armature._nextAction = animation_move_end
			end
			--]]
		elseif actionIndex == animation_move_end then
			--[[
			if beganMoveHero == 2 then
				if skillProperty == 0 then
					executeMeleeAttackBegan(armatureBack)
				elseif skillProperty == 1 then
					executeMeleeSkillBegan(armatureBack)
				end
				beganMoveHero = 3
			end
			if beganMoveHero == 2 or beganMoveHero == 12 then
				if beganMoveHero == 12 then
					armature._nextAction = animation_standby
				end
			end
			--]]
		elseif actionIndex == animation_standby then				-- 待机帧
			if setDeathArmatureCount == 0 and isNoDeath == true and isSkepBattle == false then
				isNoDeath = false
				currentRoundIndex = _ED.attackData.roundCount
				nextRoundBattle()
			end
		elseif actionIndex == animation_attack_moving then			-- 近身攻击上的移动帧组
			mtime = moveToTargetTime1
			executeHeroMoveBy()
			armatureBack._nextAction = animation_melee_attack_began
		elseif actionIndex == animation_melee_attack_began then		-- 近身攻击前段
			executeMeleeAttacking(armatureBack)
		elseif actionIndex == animation_melee_attacking then		-- 近身攻击中段
			armatureBack._nextAction = animation_standby
			executeAttacking()
		elseif actionIndex == animation_melee_attack_end then		-- 近身攻击后段
			--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
			mtime = moveToTargetTime1
			-- mtime = armatureBack._duration
			executeHeroMoveByBack()
			if needMove == true then
				-- 近身攻击后段:当前角色移动攻击完毕，现在返回原点
			else
				-- 近身攻击后段:当前角色原地攻击完毕
			end
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_remote_attack_began then	-- 远程攻击前段
			executeRemoteAttacking(armatureBack)
		elseif actionIndex == animation_remote_attacking then		-- 远程攻击中段
			-- 远程攻击中段
			armatureBack._nextAction = animation_standby
			if armatureBack._isReact == true then
				-- 进行反击, 启动反击中段处理
				--if armature._reactor._byReactor ~= nil then
				if armatureBack._byReactor ~= nil then
					-- 进行反击, 启动反击中段处理
					executeEffectSkilling(armatureBack._byReactor)
				end
			else
				executeAttacking()
			end
		elseif actionIndex == animation_remote_attack_end then		-- 远程攻击后段
			armatureBack._nextAction = animation_standby
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
			
		elseif actionIndex == animation_skill_moving then			-- 技能近身攻击上的移动帧组
			mtime = moveToTargetTime2
			executeHeroMoveBy()
			armatureBack._nextAction = animation_melee_skill_began
		elseif actionIndex == animation_melee_skill_began then		-- 技能近身攻击前段
			executeMeleeAttacking(armatureBack)
		elseif actionIndex == animation_melee_skilling then			-- 技能近身攻击中段
			armatureBack._nextAction = animation_standby
			executeAttacking()
		elseif actionIndex == animation_melee_skill_end then		-- 技能攻击近身后段
			--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
			mtime = moveToTargetTime2
			executeHeroMoveByBack()
			if needMove == true then
				-- 技能攻击近身后段:当前角色移动攻击完毕，现在返回原点
			else
				-- 技能攻击近身后段:当前角色原地攻击完毕
			end
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_remote_skill_began then		-- 技能攻击远程前段
			executeRemoteSkilling(armatureBack)
		elseif actionIndex == animation_remote_skilling then		-- 技能攻击远程中段
			armatureBack._nextAction = animation_standby
			if executeAfterInfluenceCount > 0 then
				executeAfterAttacking()
			else
				executeAttacking()
			end
		elseif actionIndex == animation_remote_skill_end then		-- 技能远程攻击后段
			armatureBack._nextAction = animation_standby
			executeAttackerBuff()
		elseif actionIndex == animation_hero_by_attack then			-- 我方被攻击
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_emeny_by_attack then		-- 敌方被攻击
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_hero_miss then				-- 我方闪避
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_emeny_miss then				-- 我方闪避
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_death then					-- 死亡
			if __lua_project_id == __lua_king_of_adventure then
			-- if isSkepBattle == true and setDeathArmatureCount >= 0 then
				-- deathBuff(armatureBack,armature)
			-- else
				-- armatureBack._nextAction = death_buff
			-- end
				if armature._role._id == "1498" or armature._role._id == "1500" then
					deathBuff(armatureBack,armature)	
				else
					armatureBack._nextAction = death_buff
					armature._role._hp = 0
					showRoleHP(armature)
				end
			else
				deathBuff(armatureBack,armature)	
			end
		elseif actionIndex == death_buff then
			if __lua_project_id == __lua_king_of_adventure then
				if armature._role._id == "1498" or armature._role._id == "1500" then
					deathBuff(armatureBack,armature)
				end
				if isSkepBattle == true and setDeathArmatureCount >= 0 then
					deathBuff(armatureBack,armature)
				end
			end
		elseif actionIndex == death_buff_end then
			if __lua_project_id == __lua_king_of_adventure then
				deathBuff(armatureBack,armature)	
				missTime = missTime - 1
				if missTime == 0 then 
					-- 清除上一场的回合数
					currentRoundIndex = 0
					_ED.battleData._currentBattleIndex = _ED.battleData._currentBattleIndex + 1
					-- 战斗胜利，即将进入下一场战斗！
					initBattle()
					initEnemy()
					if executeNextEvent(nil, true) == false then
						moveTeam()
					end
					battleRunning = true
				end
			end
		end
	end	
end
-- END
-- --------------------------------------------------------------------- --

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
	local labelAtlas = cc.LabelAtlas:_create(""..roleDeamge, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
	-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
	labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
	labelAtlas:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
	_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt) 
	
	if defState == "2" or true then
		local crit = cc.Sprite:create("images/ui/battle/baoji.png")
		crit:setAnchorPoint(cc.p(0.5, 0.5)) 
		labelAtlas:addChild(crit, kZOrderInMap_Hurt)
		crit:setPosition(cc.p(labelAtlas:getContentSize().width/2, crit:getContentSize().height + labelAtlas:getContentSize().height/2))
	end
	
	local seq = nil
	if defState == "0" then
		seq = cc.Sequence:create(
			cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 2),
			cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 1.0),
			cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
			cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
			cc.CallFunc:create(removeFrameObjectFuncN)
		)
	else	
		seq = cc.Sequence:create(
			cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
			cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
			cc.CallFunc:create(removeFrameObjectFuncN)
		)
	end
	
	labelAtlas:runAction(seq)
	
	showRoleHP(_widget._armature)
end

local function executeSkipFight()

end

nextAttack = function()
	local attackSectionNumber = 0 --攻击段数
	local attackTotalHarm = 0 --多段攻击总伤害
	isSkepBattle = false
	if skipCurrentFight == true then
		skipCurrentFight = false
		setDeathArmatureCount = 0
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		local hero = {}
		local master = {}
		if ofsetCount <= fightOverCount then			
			for i, v in pairs(_ED.attackData.roundData) do
				for j, h in pairs(v.roundAttacksData) do
					for n, t in pairs(h.skillInfluences) do
						for w = 1, t.defenderCount do
							local _def = t._defenders[w]
							local _role = nil
							local posTile = nil
							if _def.defender == "0" then
								if hero[_def.defenderPos] == nil then
									hero[_def.defenderPos] = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", 0, _def.defenderPos))
								end
								posTile = hero[_def.defenderPos]
							else
								if master[_def.defenderPos] == nil then
									master[_def.defenderPos] = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, _def.defenderPos))
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
							
							--[[
							if _def.defAState == "1" then
								local posTile = nil
								if _def.defender == "0" then
									posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", 0, _def.defenderPos))
								else
									posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, _def.defenderPos))
								end		
								if posTile._armature ~= nil and posTile._armature._isDeath ~= true and posTile._armature._role ~= nil then
									setDeathArmatureCount = setDeathArmatureCount + 1
									posTile._armature._def = _def
									createSkipDeamgeNumberAndDrop(posTile)
									executeRoleDeath(posTile._armature)
								end
							end
							--]]
						end
					end
					
					for n, t in pairs(h.skillAfterInfluences) do
						for w = 1, t.defenderCount do
							local _def = t._defenders[w]
							local _role = nil
							local posTile = nil
							if _def.defender == "0" then
								if hero[_def.defenderPos] == nil then
									hero[_def.defenderPos] = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", 0, _def.defenderPos))
								end
								posTile = hero[_def.defenderPos]
							else
								if master[_def.defenderPos] == nil then
									master[_def.defenderPos] = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, _def.defenderPos))
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
							
							--[[
							if _def.defAState == "1" then
								local posTile = nil
								if _def.defender == "0" then
									posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", 0, _def.defenderPos))
								else
									posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, _def.defenderPos))
								end		
								if posTile._armature ~= nil and posTile._armature._isDeath ~= true and posTile._armature._role ~= nil then
									setDeathArmatureCount = setDeathArmatureCount + 1
									posTile._armature._def = _def
									createSkipDeamgeNumberAndDrop(posTile)
									executeRoleDeath(posTile._armature)
								end
							end
							--]]
						end
					end
					
					if h.attackerBuffState == "1" and h.attackerBuffDeath == "1" then
						local posTile = nil
						if h.attacker == "0" then
							posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", 0, h.attackerPos))
						else
							posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, h.attackerPos))
						end		
						if posTile._armature ~= nil and posTile._armature._isDeath ~= true and posTile._armature._role ~= nil then
							setDeathArmatureCount = setDeathArmatureCount + 1
							posTile._armature._def = nil
							posTile._armature._dropCount = h.attackerBuffDropCount
							createSkipDeamgeNumberAndDrop(posTile)
							executeRoleDeath(posTile._armature)
						end
					end
				end
			end
		end
		for i, v in pairs(hero) do
			createSkipDeamgeNumberAndDrop(v, v.__deamge)
			v.__deamge = nil
		end
		
		for i, v in pairs(master) do
			createSkipDeamgeNumberAndDrop(v, v.__deamge)
			v.__deamge = nil
		end
		
		if setDeathArmatureCount == 0 then
			isNoDeath = true
		end
		
		isSkepBattle = true
		
		--[[
		if _ED.battleData.battle_init_type == 2 then
			currentRoundIndex = _ED.attackData.roundCount
			nextRoundBattle()
		end
		--]]
		
		if isSkepBattle == true and setDeathArmatureCount == 0 then
			currentRoundIndex = _ED.attackData.roundCount
			setDeathArmatureCount = -1
			nextRoundBattle()
		end
		lockSkipFight = false
		return
	end
	
	if executeNextRoundBattleEvent(currentAttackCount + 1) == true then
		return
	end	
	
	currentAttackCount = currentAttackCount + 1
	local _roundData = _ED.attackData.roundData[currentRoundIndex]
	if _roundData == nil or currentRoundAttackIndex > _roundData.curAttackCount then
		nextRoundBattle()
		return
	end
	
	if _ED.battleData.battle_init_type == 2 then
		updateGoldBossInfo()
	end
	
	
	attData = _roundData.roundAttacksData[currentRoundAttackIndex]
	
	local attacker 				= attData.attacker						-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
	local attackerPos 			= attData.attackerPos 					-- = npos(list)		--出手方位置(1-6)
	local attackMovePos			= tonumber(attData.attackMovePos)					-- = npos(list)		--移动到的位置(0-8)
	local skillMouldId			= tonumber(attData.skillMouldId) 					-- = npos(list)	--技能模板id
	local skillInfluenceCount 	= tonumber(attData.skillInfluenceCount) 			-- = tonumber(npos(list))	-- 技能效用数量
	-- attData.skillInfluences = {}
	
	local skillElementData = dms.element(dms["ship_mould"], skillMouldId)
	
	-- skill data
	local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
	local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local skillReleasePosition = dms.atoi(skillElementData, skill_mould.skill_release_position)
	
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
	if attacker == "0" then
		-- 我方攻击
		state_machine.excute("battle_formation_controller_role_attack", 0, {roleType = 2, roleIndex = attackerPos})
		
		mPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, attackerPos))
		mx, my = mPosTile:getPosition()
		if __lua_project_id == __lua_king_of_adventure then
			mPosTile._scale = mPosTile._scale or 1.0
			mPosTile._mscale = mPosTile._scale or 1.0
		end
		
		if needMove == true then
			if attackMovePos == 1 then
				local mpos2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, 2))
				local epos2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, 2))
				ex, ey = mPosTile:getPosition()
				local m2x, m2y = mpos2:getPosition()
				local e2x, e2y = epos2:getPosition()
				
				local mmx, mmy = mPosTile:getPosition()
				
				ex = ex + (m2x - ex)
				ey = ey + (e2y - m2y)/2 + (m2y - mmy) - mPosTile:getContentSize().height/2 - 20/CC_CONTENT_SCALE_FACTOR()
				
				mPosTile._mscale = epos2._scale or 1.0
			else
				local ePosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, attackMovePos-1))
				ex, ey = ePosTile:getPosition()
				ey = ey - attackMoveTagetOffsetY - mPosTile:getContentSize().height/2 - 20/CC_CONTENT_SCALE_FACTOR()
				if __lua_project_id == __lua_king_of_adventure then
					mPosTile._mscale = ePosTile._scale or 1.0
				end
			end
		end
	else
		-- 敌方攻击
		state_machine.excute("battle_formation_controller_role_attack", 0, {roleType = 1, roleIndex = attackerPos})
		
		mPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, attackerPos))
		mx, my = mPosTile:getPosition()
		if __lua_project_id == __lua_king_of_adventure then
			mPosTile._scale = mPosTile._scale or 1.0
			mPosTile._mscale = mPosTile._scale or 1.0
		end
		
		if needMove == true then
			if attackMovePos == 1 then
				local mpos2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, 2))
				local epos2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, 2))
				ex, ey = mPosTile:getPosition()
				local m2x, m2y = mpos2:getPosition()
				local e2x, e2y = epos2:getPosition()
				
				local mmx, mmy = mPosTile:getPosition()
				
				ex = ex + (m2x - ex)
				ey = ey + (e2y - m2y)/2 + (m2y - mmy) + mPosTile:getContentSize().height/2 + 20/CC_CONTENT_SCALE_FACTOR()
				
				mPosTile._mscale = epos2._scale or 1.0
			else
				local ePosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, attackMovePos-1))
				ex, ey = ePosTile:getPosition()
				ey = ey + attackMoveTagetOffsetY + mPosTile:getContentSize().height/2 + 20/CC_CONTENT_SCALE_FACTOR()
				
				if __lua_project_id == __lua_king_of_adventure then
					mPosTile._mscale = ePosTile._scale or 1.0
				end
			end
		end
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
		
	-- 眩晕
	if skillInfluenceCount <= 0 then
		resetArmatureData(mPosTile._armature)
		executeAttackerBuff()
		return
	end
	
	executeHeroMoveToTarget = function()
		-- 清理对象缓存信息
		resetArmatureData(mPosTile._armature)
		
		-- 角色死亡
		if mPosTile._armature == nil then
			nextAttack()
			return
		end
		
		if attackMovePos == 0 or attackMovePos == 8 then
			-- 在原地进行攻击
			if skillProperty == 0 then
				executeRemoteAttackBegan(mPosTile._armature)
			elseif skillProperty == 1 then
				executeRemoteSkillBegan(mPosTile._armature)
			end
			if attackMovePos == 8 then
				mPosTile:setVisible(false)
			end
		else
			-- 处理移动逻辑-初始化移动
			local armature = mPosTile._armature
			armature._invoke = attackChangeActionCallback
			
			if skillProperty == 0 then
				executeMoveMeleeAttackBegan(mPosTile._armature)
			elseif skillProperty == 1 then
				executeMoveMeleeSkillBegan(mPosTile._armature)
			end
			
		end
	end
	
	executeHeroMoveToOriginTarget = function()
		-- 处理返回逻辑
		if attackTargetCount > 0 then
			attackTargetCount = attackTargetCount - 1
			if attackTargetCount > 0 then
				return
			end
		end
		
		if executeAfterInfluenceCount > 0 then
			-- 重新进入
			-- executeAfterAttacking()
			executeAfterAttacking()
			return
		end
		
		local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
		if (currentSkillInfluenceStartIndex < skillInfluenceCount) then
			currentSkillInfluenceStartIndex = currentSkillInfluenceStartIndex + 1
			executeAttacking()
			--executeAttack()
			return
		end
		
		if attackMovePos == 0 or attackMovePos == 8 then
			-- 处理在原地进行攻击后的返回逻辑
			--executeAttackerBuff()
			if skillProperty == 0 then	-- 物理远程攻击
				executeRemoteAttackEnd(mPosTile._armature)
			elseif skillProperty == 1 then	-- 技能远程攻击
				executeRemoteSkillEnd(mPosTile._armature)
			end
			if attackMovePos == 8 then
				mPosTile:setVisible(true)
			end
			-- executeRemoteAttackBegan(mPosTile._armature)
			-- executeAttack()
		--elseif attackMovePos == 1 then
		--	处理移动到屏幕中进行攻击的返回逻辑
		---	-- executeAttackerBuff()
		--elseif attackMovePos == 8 then
		--	处理暗杀进行攻击的返回逻辑
		--	--executeAttackerBuff()
		else
			-- 处理攻击后的返回逻辑
			if skillProperty == 0 then	-- 物理近身攻击
				executeMeleeAttackEnd(mPosTile._armature)
			elseif skillProperty == 1 then	-- 技能近身攻击
				executeMeleeSkillEnd(mPosTile._armature)
			end
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
				currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
			else
				currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
			end
				
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
			local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
			local is_vibrate = dms.atoi(skillInfluenceElementData, skill_influence.is_vibrate)
	
			_skf._attackSection = attackSection
			currPosTile._armature._skf = _skf
			currPosTile._armature._sie = skillInfluenceElementData
			currPosTile._armature._is_vibrate = is_vibrate
						
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
			for w = 1, _skf.defenderCount do
				local _def = _skf._defenders[w]
				local defender = _def.defender						-- = npos(list)  		--承受方1的标识(0:我方 1:对方)
				local defenderPos = tonumber(_def.defenderPos) 		-- = npos(list)	 		--承受方1的位置
				local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
				local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
				local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
				local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
				local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
				
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
					
					--[[
						defenderPos, stValue))
					--]]
					
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
						erole[""..defender..">"..defenderPos] = rPad._armature
					else
						local drawString = _def.stValue
						if defenderST == "0" or
							defenderST == "6"
							then
							if tonumber(_def.defender) == 1 then
								BattleSceneClass.curDamage = BattleSceneClass.curDamage + tonumber(drawString)
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
				end
			end
			local roleCount = 0
			if executeDrawEffect == true then
				for i, v in pairs(erole) do
					if lightingEffectDrawMethod == 7 then
						executeEffectSkilling7(currPosTile._armature,v)
					else
						executeEffectSkilling(v)
					end
					roleCount = roleCount + 1
				end
				attackTargetCount = roleCount
				if roleCount <= 0 then
					executeHeroMoveToOriginTarget()
				elseif _skf.attTarList ~= nil then
					if lightingEffectDrawMethod ~= 7 then
						local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
						for a, t in pairs(_skf.attTarList) do
							local cPosTile
							if attacker == "0" then
								cPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, t))
							else
								cPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, t))
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
		-- executeAttackInfluence(mPosTile, currentSkillInfluenceStartIndex, skillInfluenceCount)
		if currentSkillInfluenceStartIndex <= skillInfluenceCount then
			local recal = executeAttackInfluence(attData.skillInfluences[currentSkillInfluenceStartIndex])
			if recal == 2 then
				currentSkillInfluenceStartIndex = currentSkillInfluenceStartIndex + 1
				executeAttacking()
			end
		else
			executeHeroMoveToOriginTarget()
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
				currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
			else
				currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
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
				-- local _skf = {}
				local _skf = attData.skillAfterInfluences[j]
				local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
				
				local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
				local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
				local attackerPos = _skf.attackerPos			-- 效用发动者位置
				local currPosTile = nil
				if attackerType == "1" then
					local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
					currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
				else
					currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
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
					local defenderST = _def.defenderST 					-- = npos(list)	 		--承受方1的作用效果(?)
					local stValue = _def.stValue 						-- = npos(list) 		--承受方1的作用值
					local stRound = _def.stRound 						-- = npos(list)			--承受方1的持续回合数
					local defState = _def.defState 						-- = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
					local defAState = _def.defAState 					-- = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
					
					local rPad = getRolePad(defender, defenderPos)
					--rPad._armature._def = _def
					--rPad._armature._sie = skillInfluenceElementData
					
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
			startAfterAttack()
		else
			-- 没有格挡反击, 找查下一攻击角色，或进入下一回合
			nextAttack()
		end
	end

	executeAttackerBuff = function()	
		state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
		-- 处理当前攻击者的BUFF信息，然后进入到下一个攻击角色进行攻击！
		local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
		
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
			
			local labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
			-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
			labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
			local tempX, tempY  = _widget:getPosition()
			local uiObj = nil
			if attackerBuffType == "6" then
				uiObj = cc.Sprite:create("images/ui/battle/du.png")
			elseif attackerBuffType == "9" then
				uiObj = cc.Sprite:create("images/ui/battle/zhuoshao.png")
			end
			
			labelAtlas:setPosition(cc.p(tempX + widgetSize.width/2, tempY + widgetSize.height/2)) 
			_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt) 
			
			-- animationChangeToAction(mPosTile._armature, changeToAction, animation_standby)
			
			uiObj:setAnchorPoint(cc.p(0.5, 0.5)) 
			labelAtlas:addChild(uiObj)
			uiObj:setPosition(cc.p(labelAtlas:getContentSize().width/2, uiObj:getContentSize().height 
				+ labelAtlas:getContentSize().height/2))
			
			local array = {}
			if _dindex == 1 then
				labelAtlas:setVisible(false)
				table.insert(array, (cc.DelayTime:create(0.7 * actionTimeSpeed)))
				table.insert(array, cc.Show:create())
			end
			
			_dindex = _dindex + 1
		
			table.insert(array, cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 2))
			table.insert(array, cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 1.0))
			
			table.insert(array, cc.DelayTime:create(30.0/60.0 * actionTimeSpeed))
			table.insert(array, cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2))
			table.insert(array, cc.CallFunc:create(removeFrameObjectFuncN))
			local seq = cc.Sequence:create(array)
			labelAtlas:runAction(seq)
		end
		
		--[[
		if attData.attackerBuffState == "1" then
			local _widget = mPosTile
			local widgetSize = _widget:getContentSize()
			
			local attackerBuffType = attData.attackerBuffType 			-- = npos(list)	-- (有buff影响时传)影响类型(6为中毒,9为灼烧)
			local attackerBuffValue = attData.attackerBuffValue 		-- = npos(list)	-- 影响值
			local attackerBuffDeath = attData.attackerBuffDeath
			mPosTile._armature._role._hp = mPosTile._armature._role._hp - tonumber(attackerBuffValue)
			showRoleHP(mPosTile._armature)
			if attackerBuffDeath == "1" then
				mPosTile._armature._def = nil
				mPosTile._armature._dropCount = attData.attackerBuffDropCount
				executeRoleDeath(mPosTile._armature)
			end
			
			local numberFilePath = "images/ui/number/xue.png"
			
			local labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
			-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
			labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
			local tempX, tempY  = _widget:getPosition()
			labelAtlas:setPosition(cc.p(tempX + widgetSize.width/2, tempY + widgetSize.height/2)) 
			_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt) 
			
			local uiObj = nil
			if attackerBuffType == "6" then
				uiObj = cc.Sprite:create("images/ui/battle/du.png")
			elseif attackerBuffType == "9" then
				uiObj = cc.Sprite:create("images/ui/battle/zhuoshao.png")
			end
			
			-- animationChangeToAction(mPosTile._armature, changeToAction, animation_standby)
			
			uiObj:setAnchorPoint(cc.p(0.5, 0.5)) 
			labelAtlas:addChild(uiObj)
			uiObj:setPosition(cc.p(labelAtlas:getContentSize().width/2, uiObj:getContentSize().height + labelAtlas:getContentSize().height/2))
			
			local array = CCArray:createWithCapacity(10)
		
			array:addObject(cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 2))
			array:addObject(cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 1.0))
			
			array:addObject(cc.DelayTime:create(30.0/60.0 * actionTimeSpeed))
			array:addObject(cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2))
			array:addObject(cc.CallFunc:create(removeFrameObjectFuncN))
			local seq = CCSequence:create(array)
			labelAtlas:runAction(seq)
		end
		--]]
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
						-- 清除角色的BUFF
						mPosTile._buff[i] = nil
					end
				end
			end
		end
		
		
		executeAttackEnd()
		--绘制多段攻击总伤害
		if attackTotalHarm > 0 and attackSectionNumber > 1 then
			if BattleSceneClass._attackTotalHarm ~= nil then
				BattleSceneClass._attackTotalHarm:removeFromParent(true)
			end
			
			-- GUIReader:shareReader():widgetFromCacheJsonFile("interface/injury_settlement.json", "Panel_11879", 0)
			-- BattleSceneClass._attackTotalHarm = GUIReader:shareReader():widgetFromCacheJsonFile("interface/injury_settlement.json", "Panel_11879", 1)
			-- BattleSceneClass._uiLayer:addChild(BattleSceneClass._attackTotalHarm)
			-- draw.number(BattleSceneClass._uiLayer,"LabelAtlas_11884",""..attackTotalHarm)
			-- GUIReader:shareReader():widgetFromCacheJsonFile("interface/injury_settlement.json", "Panel_11879", -1)
			
			local csbInjury = csb.createNode("battle/injury_settlement.csb")
			BattleSceneClass._attackTotalHarm = csbInjury:getChildByName("root")
			BattleSceneClass._attackTotalHarm:retain()
			BattleSceneClass._attackTotalHarm:removeFromParent(false)
			
			BattleSceneClass._uiLayer:addChild(BattleSceneClass._attackTotalHarm)
			BattleSceneClass._attackTotalHarm:release()
			
			ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer, "AtlasLabel_1"):setString(""..attackTotalHarm)
			
			-- local action = csb.createTimeline("battle/injury_settlement.csb")
			-- csbLogo:runAction(action)
			-- action:gotoFrameAndPlay(0, action:getDuration(), false)
			-- action:setTimeSpeed(0.1*actionTimeSpeed)
			
			-- local action1 = ActionManager:shareManager():getActionByName("injury_settlement.json","Animation0")
			-- action1:setUnitTime(0.1*actionTimeSpeed)
			-- action1:play()
			-- action1:setLoop(false)
			BattleSceneClass._shakeAction:gotoFrameAndPlay(0, BattleSceneClass._shakeAction:getDuration(), false)
		end
		attackTotalHarm = 0
		attackSectionNumber = 0
	end
	
	-- if skillQuality == 1 and mPosTile._armature._role._quality >= 3 then
	if skillQuality == 1 then
		-- 绘制怒气技术过场动画
		mPosTile._armature._currentSkillMouldId = skillMouldId
		excuteSPSkillEffect(mPosTile, mPosTile._armature)
	else
		executeHeroMoveToTarget()
	end
end

local function userPveDataStatistics()					--统计用户基础行为数据——pve
	-- local fightRequestData = find_param_list("battle_field_init")
	-- local params = lua_string_split_line(fightRequestData, "\r\n")
	-- if _ED.attackData.isWin == "0" then
		-- if params[2] ~= "0" and _ED.battleData.battle_init_type == 3 then			--经验宝物
			-- jttd.user_pve_action(1,_ED.user_info.user_id,jttd_data_script[22],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),"",_ED.user_info.user_grade)
		-- elseif params[2] ~= "0" and _ED.battleData.battle_init_type == 0 then		--普通副本
			-- jttd.user_pve_action(3,_ED.user_info.user_id,jttd_data_script[22],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),_ED.npc_current_attack_count[tonumber(_ED._scene_npc_id)],_ED.user_info.user_grade)
		-- elseif params[2] ~= "0" and _ED.battleData.battle_init_type == 1 then		--精英副本
			-- jttd.user_pve_action(4,_ED.user_info.user_id,jttd_data_script[22],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),"",_ED.user_info.user_grade)
		-- elseif params[2] ~= "0" and _ED.battleData.battle_init_type == 6 then		--试炼塔
			-- jttd.user_pve_action(5,_ED.user_info.user_id,jttd_data_script[22],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),_ED.scene_current_state[tonumber(_ED._current_scene_id)],_ED.user_info.user_grade)
		-- elseif _ED.battleData.battle_init_type == 2 then
			-- jttd.user_pve_action(2,_ED.user_info.user_id,jttd_data_script[22],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),"",_ED.user_info.user_grade)
		-- elseif _ED.battleData.battle_init_type == 5 then
			-- jttd.user_pve_action(6,_ED.user_info.user_id,jttd_data_script[22],elementAt(NPC,429):atos(npc.npc_name),elementAt(pveScene,145):atos(pve_scene.scene_name),_ED.WorldBossAttack,_ED.user_info.user_grade)
		-- end
	-- else
		-- if params[2] ~= "0" and _ED.battleData.battle_init_type == 3 then			--经验宝物
			-- jttd.user_pve_action(1,_ED.user_info.user_id,jttd_data_script[23],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),"",_ED.user_info.user_grade)
		-- elseif params[2] ~= "0" and _ED.battleData.battle_init_type == 0 then		--普通副本
			-- jttd.user_pve_action(3,_ED.user_info.user_id,jttd_data_script[23],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),_ED.npc_current_attack_count[tonumber(_ED._scene_npc_id)],_ED.user_info.user_grade)
		-- elseif params[2] ~= "0" and _ED.battleData.battle_init_type == 1 then		--精英副本
			-- jttd.user_pve_action(4,_ED.user_info.user_id,jttd_data_script[23],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),"",_ED.user_info.user_grade)
		-- elseif params[2] ~= "0" and _ED.battleData.battle_init_type == 6 then		--试炼塔
			-- jttd.user_pve_action(5,_ED.user_info.user_id,jttd_data_script[23],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),_ED.scene_current_state[tonumber(_ED._current_scene_id)],_ED.user_info.user_grade)
		-- elseif _ED.battleData.battle_init_type == 2 then
			-- jttd.user_pve_action(2,_ED.user_info.user_id,jttd_data_script[23],dms.string(dms["npc"], _ED._scene_npc_id, npc.npc_name),dms.string(dms["pve_scene"], _ED._current_scene_id,pve_scene.scene_name),"",_ED.user_info.user_grade)
		-- elseif _ED.battleData.battle_init_type == 5 then
			-- jttd.user_pve_action(6,_ED.user_info.user_id,jttd_data_script[23],elementAt(NPC,429):atos(npc.npc_name),elementAt(pveScene,145):atos(pve_scene.scene_name),_ED.WorldBossAttack,_ED.user_info.user_grade)
		-- end
	-- end
end

local function OverBattle()
	-- 战斗结束
	if _ED.attackData.isWin == "0" then
		if __lua_project_id == __lua_king_of_adventure then
			if mschedulerEntry ~= nil then
				mScheduler:unscheduleScriptEntry(mschedulerEntry)
				mschedulerEntry = nil
			end
		end
		-- 战斗失败,即将进行战斗失败信息界面！
		--清除上一场的回合数
		currentRoundIndex = 0
		stopBgm()
		if _ED._scene_npc_id ~= nil and _ED.npc_state[tonumber(_ED._scene_npc_id)] ~= nil and tonumber(_ED.npc_state[tonumber(_ED._scene_npc_id)]) <= 0 then
			-- jttd.failed(_ED._scene_npc_id.."|".._string_piece_info[240])
		end
		
		app.load("client.battle.BattleLose")
		-- LuaClasses["BattleLoseClass"].Draw(nil)
		fwin:open(BattleLose:new())
		
		userPveDataStatistics()
	else
		if _ED.battleData._currentBattleIndex >= _ED.battleData.battle_total_count then
			if __lua_project_id == __lua_king_of_adventure then
				if mschedulerEntry ~= nil then
					mScheduler:unscheduleScriptEntry(mschedulerEntry)
					mschedulerEntry = nil
				end
			end
			-- 战斗胜利
			--清除上一场的回合数
			currentRoundIndex = 0
			-- 战斗胜利，即将进行奖励信息及升级界面！
			stopBgm()
			
			if _ED._scene_npc_id ~= nil and _ED.npc_state[tonumber(_ED._scene_npc_id)] ~= nil and tonumber(_ED.npc_state[tonumber(_ED._scene_npc_id)]) <= 1 then
				jttd.completed(_ED._scene_npc_id)
			end
			
			-- 判断是否升级触发事件
			upLevelTriggerMission()
			
			app.load("client.battle.BattleReward")
			-- LuaClasses["BattleRewardClass"].Draw(nil)
			fwin:open(BattleReward:new(fwin,_windows))
			
			userPveDataStatistics()
		else
			-- 请求下一回合
			if __lua_project_id == __lua_king_of_adventure then
				if mschedulerEntry ~= nil then
					mScheduler:unscheduleScriptEntry(mschedulerEntry)
					mschedulerEntry = nil
				end
				cleanBattleHero()
			end
			if __lua_project_id == __lua_king_of_adventure then
			
			else
				-- 清除上一场的回合数
				currentRoundIndex = 0
				_ED.battleData._currentBattleIndex = _ED.battleData._currentBattleIndex + 1
				-- 战斗胜利，即将进入下一场战斗！
				initBattle()
				initEnemy()
				if executeNextEvent(nil, true) == false then
					moveTeam()
				end
				battleRunning = true
			end
		end
	end
end

local function fightOverFunc()
	battleRunning = false
	_ED._battle_init_type = "0"
	if _ED.battleData.battle_init_type == fight_type_8 then --军团副本战斗
		local unionName = LuaClasses["BattleSceneClass"]._unionBattleInfo.attackName
		if _ED.union.union_info.union_name == unionName  then
			if _ED.attackData.isWin == "0" then
				require "script/transformers/activity/plunder/PVpLose"
				LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
			else
				require "script/transformers/play/union/UnionBattleResult"
				LuaClasses["UnionBattleResultClass"].initData(_ED._scene_npc_id, LuaClasses["BattleSceneClass"]._unionBattleInfo.defenseName )
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["UnionBattleResultClass"])
			end
		else
			if _ED.attackData.isWin == "1" then
				require "script/transformers/activity/plunder/PVpLose"
				LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
			else
				require "script/transformers/play/union/UnionBattleResult"
				LuaClasses["UnionBattleResultClass"].initData(_ED._scene_npc_id, unionName )
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["UnionBattleResultClass"])
			end
		end
		-- 置空战斗数据
		_ED.union.union_battleground_fight = nil
	elseif _ED.battleData.battle_init_type == fight_type_7 then --军团副本战斗
		if _ED.attackData.isWin == "0" then
		-- 战斗失败,即将进行战斗失败信息界面！
			require "script/transformers/activity/plunder/PVpLose"
			LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
		else
			require "script/transformers/play/union/UnionDuplicateBattleReward"
			local battleName = "".._ED.battleData._armys[_ED.battleData._currentBattleIndex]._battleName
			local info = _ED.union.union_counterpart_info.counterpart_fight
			LuaClasses["UnionDuplicateBattleRewardClass"].initData(info, battleName)
			LuaClasses["UnionDuplicateBattleRewardClass"].Draw()
		end
		-- 置空战斗数据
		_ED.union.union_counterpart_info.counterpart_fight = nil
		
	elseif _ED.battleData.battle_init_type == 10 then	--抢夺
		if _ED.attackData.isWin == "0" then
		-- 战斗失败,即将进行战斗失败信息界面！
			require "script/transformers/activity/plunder/PVpLose"
		--	LuaClasses["BattleLoseClass"].Draw(scene)
			LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
		else
			require "script/transformers/activity/plunder/BattleVictoryAwards"
			LuaClasses["BattleVictoryAwardsClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["BattleVictoryAwardsClass"])
		end
	elseif _ED.battleData.battle_init_type == 11 then --竞技场
		if _ED.attackData.isWin == "0" then
		-- 战斗失败,即将进行战斗失败信息界面！
			require "script/transformers/activity/plunder/PVpLose"
		--	LuaClasses["BattleLoseClass"].Draw(scene)
			LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
		else
			require "script/transformers/activity/plunder/BattleVictoryAwards"
			LuaClasses["BattleVictoryAwardsClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["BattleVictoryAwardsClass"])
		end
	elseif _ED.battleData.battle_init_type == 12 then --比武
		if _ED.attackData.isWin == "0" then
		-- 战斗失败,即将进行战斗失败信息界面！
			require "script/transformers/activity/plunder/PVpLose"
		--	LuaClasses["BattleLoseClass"].Draw(scene)
			LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
		else
			require "script/transformers/activity/plunder/BattleVictoryAwards"
			LuaClasses["BattleVictoryAwardsClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["BattleVictoryAwardsClass"])
		end
	elseif _ED.battleData.battle_init_type == 13 then --军团切磋
		if _ED.attackData.isWin == "0" then
		-- 战斗失败,即将进行战斗失败信息界面！
			require "script/transformers/activity/plunder/PVpLose"
		--	LuaClasses["BattleLoseClass"].Draw(scene)
			LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
		else
			-- require "script/transformers/activity/plunder/BattleVictoryAwards"
			-- LuaClasses["BattleVictoryAwardsClass"].initData(_ED.battleData.battle_init_type)
			-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["BattleVictoryAwardsClass"])
			require "script/transformers/play/union/Unioncompare"
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["UnioncompareClass"])
		end
	elseif _ED.battleData.battle_init_type == 14 then	--资源矿抢夺
		if _ED.attackData.isWin == "0" then
		-- 战斗失败,即将进行战斗失败信息界面！
			require "script/transformers/activity/plunder/PVpLose"
		--	LuaClasses["BattleLoseClass"].Draw(scene)
			LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
		else
			require "script/transformers/play/union/Unioncompare"
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["UnioncompareClass"])
		end
	elseif _ED.battleData.battle_init_type == 15 then	--灵王宫
		if _ED.attackData.isWin == "0" then
		-- 战斗失败,即将进行战斗失败信息界面！
			require "script/jtx/play/palace/PalaceBattleLose"
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PalaceBattleLoseClass"])
		else
			require "script/jtx/play/palace/PalaceBattleWin"
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PalaceBattleWinClass"])
		end
	elseif _ED.battleData.battle_init_type == 16 then
		require "script/transformers/play/union/UnionBattleResult"
		LuaClasses["UnionBattleResultClass"].initData("", "", "", 
		  LuaClasses["CrossBattleMainViewClass"].__video_info.back_to_wnd, 
		  LuaClasses["CrossBattleMainViewClass"].__video_info.winner_name,
		  LuaClasses["CrossBattleMainViewClass"].__video_info.loser_name)
		LuaClasses["MainWindowClass"].openWindow(LuaClasses["UnionBattleResultClass"])
	elseif _ED.battleData.battle_init_type < 10 then
		-- 请求执行战斗结束的事件
		if _ED.battleData.battle_init_type == 2 then -- 摇钱树
			if _ED.attackData.isWin == "0" then
			-- 战斗失败,即将进行战斗失败信息界面！
				require "script/transformers/battle/BattleLose"
				LuaClasses["BattleLoseClass"].Draw(nil)
				--LuaClasses["PVpLoseClass"].initData(_ED.battleData.battle_init_type)
				--LuaClasses["MainWindowClass"].openWindow(LuaClasses["PVpLoseClass"])
				userPveDataStatistics()
			else
				require "script/transformers/home/pve/GoldBossReward"
				--LuaClasses["GoldBossRewardClass"].initData(_ED.battleData.battle_init_type)
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["GoldBossRewardClass"])
				userPveDataStatistics()
			end
		elseif _ED.battleData.battle_init_type == 5 then -- 世界BOSS
				require "script/transformers/activity/WorldBossFightReward"
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["WorldBossFightRewardClass"])
				userPveDataStatistics()
		else
			--if executeMission(mission_mould_battle, touch_off_mission_battle_over, 
			--	"".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) == true then
			--	return
			--end
            if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, 
				"".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) == true then
				return
			end
			if __lua_project_id == __lua_king_of_adventure then
				mScheduler = cc.Director:getInstance():getScheduler()
				local mIndex=0
					local function undate(dt)
					mIndex=mIndex+1
						if mIndex==1 then
							OverBattle()
						end
					end
				mschedulerEntry = mScheduler:scheduleScriptFunc(undate, 1, false)
			else
				OverBattle()
			end
		end
	end
end

nextRoundBattle = function()
	--> debug.log(true,"===========",nextRoundBattle)
	if _ED.battleData.battle_init_type == 2 then
		updateGoldBossInfo()
	end
	
	if _ED.battleData.battle_init_type == fight_type_7 
		or _ED.battleData.battle_init_type == fight_type_8 
		then
			battleMoveUnionTeam()
		return
	end
	if currentRoundIndex >= _ED.attackData.roundCount then
		local array = {}
		if _ED.attackData.isWin == "0" or _ED.battleData._currentBattleIndex >= _ED.battleData.battle_total_count then
			table.insert(array, cc.DelayTime:create(1.3))
		else
			table.insert(array, cc.DelayTime:create(0.65))
		end
		table.insert(array, cc.CallFunc:create(fightOverFunc))
		local seq = cc.Sequence:create(array)
		BattleSceneClass._uiLayer:runAction(seq)
		return
	end
	
	if setDeathArmatureCount > 0 then
		return
	end

	if lockBattleRun == true then
		return
	end
	
	currentRoundAttackIndex = 1
	currentSkillInfluenceStartIndex = 1
	
	currentRoundIndex = currentRoundIndex + 1
	
	local _roundData = _ED.attackData.roundData[currentRoundIndex]
	local fightRewardBoutCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10865")
	--tolua.cast(fightRewardBoutCount,"Label"):setText(_ED.attackData.roundData[currentRoundIndex].currentRound.."/".."30")
	fightRewardBoutCount:setString(_ED.attackData.roundData[currentRoundIndex].currentRound.."/".."30")

	nextAttack()
end


-- END~战斗过程处理
-- ------------------------------------------------------------------------------------------------- --


function BattleSceneClass.changeBackground(bgIndex)
	local bg1 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer, "Panel_29798")
	local bg2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer, "Panel_29799")
	bg1:setVisible(true)
	bg2:setVisible(true)
	bg1:removeBackGroundImage()
	bg2:removeBackGroundImage()

	bg1:setBackGroundImage("map/battle/battle_"..bgIndex.."_0.jpg")
	bg2:setBackGroundImage("map/battle/battle_"..bgIndex.."_1.jpg")

end

function BattleSceneClass.initBattleFashion(_armature, _roleType)
	local roleFashionLayerNames = {
		"equipment_8",		
		"equipment_13",		
		"equipment_7",		   
		"equipment_9",
		"equipment_10",        
		"equipment_11",		    
		"equipment_12",		    
		"equipment_14",
	}

	local function drawBattleFashionItem(_index, _equipmentId)
		
		if tonumber(_equipmentId)>0 then
			local equipData =elementAt(equipmentMould, tonumber(_equipmentId))
			
			local pic = equipData:atos(equipment_mould.All_icon)
			if tonumber(_ED.battle_fashion_info[_roleType].genderId) == 1 then
				local equip = string.format("images/ui/big_props/big_props_%s.png", pic)
				local roleIcon = ccs.Skin:create(equip)
				_armature:getBone(roleFashionLayerNames[_index]):addDisplay(roleIcon, 0)
			else
				local equip = string.format("images/ui/big_props/big_props_%s.png", pic+10000)
				local roleIcon = ccs.Skin:create(equip)
				_armature:getBone(roleFashionLayerNames[_index]):addDisplay(roleIcon, 0)
			end
		end
	end

	local function drawBattleFashionItems()
		drawBattleFashionItem(1, _ED.battle_fashion_info[_roleType].eye)
		drawBattleFashionItem(2, _ED.battle_fashion_info[_roleType].ear)
		drawBattleFashionItem(3, _ED.battle_fashion_info[_roleType].cap)
		drawBattleFashionItem(4, _ED.battle_fashion_info[_roleType].cloth)
		drawBattleFashionItem(5, _ED.battle_fashion_info[_roleType].glove)
		drawBattleFashionItem(6, _ED.battle_fashion_info[_roleType].weapon)
		drawBattleFashionItem(7, _ED.battle_fashion_info[_roleType].shoes)
		drawBattleFashionItem(8, _ED.battle_fashion_info[_roleType].wing)
	end
	
	drawBattleFashionItems()
end

function BattleSceneClass.initUnionBattleFashion(role, armature)
	local roleFashionLayerNames = {
		"equipment_8",		
		"equipment_13",		
		"equipment_7",		   
		"equipment_9",
		"equipment_10",        
		"equipment_11",		    
		"equipment_12",		    
		"equipment_14",
	}

	local function drawUnionBattleFashionItem(_index, _equipmentId)
		
		if tonumber(_equipmentId)>0 then
			local equipData =elementAt(equipmentMould, tonumber(_equipmentId))
			local pic = equipData:atos(equipment_mould.All_icon)
			local equip = nil
			if tonumber(role._gender) == 1 then
				equip = string.format("images/ui/big_props/big_props_%s.png", pic)
			else
				equip = string.format("images/ui/big_props/big_props_%s.png", pic+10000)
			end
			local roleIcon = ccs.Skin:create(equip)
			armature:getBone(roleFashionLayerNames[_index]):addDisplay(roleIcon, 0)
		end
	end

	local function drawUnionBattleFashionItems()
		drawUnionBattleFashionItem(1, role._eye)
		drawUnionBattleFashionItem(2, role._ear)
		drawUnionBattleFashionItem(3, role._cap)
		drawUnionBattleFashionItem(4, role._cloth)
		drawUnionBattleFashionItem(5, role._glove)
		drawUnionBattleFashionItem(6, role._weapon)
		drawUnionBattleFashionItem(7, role._shoes)
		drawUnionBattleFashionItem(8, role._wing)
	end
	
	drawUnionBattleFashionItems()
end

-- 1. 战斗开场动画
function BattleSceneClass:battleStartAnimation()
	self:heroIntoBattle()
end
-- 2. 我方角色入场
function BattleSceneClass:heroIntoBattle()
	self:moveLineSpeedAnimation()
	BattleSceneClass._shakeAction:play("hero_ruchang_6", false)
	BattleSceneClass._shakeAction:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		local str = frame:getEvent()
		if str == "battle_move_end_6_1" then			
			
			-- local function playMasterAnimation()
				-- self:masterIntoBattle()
			-- end
			-- -- 0.8秒后开是播放敌方入场动画
			-- local array = {}
			-- table.insert(array, cc.DelayTime:create(0.8))
			-- table.insert(array, cc.CallFunc:create(playMasterAnimation))
			-- local seq = cc.Sequence:create(array)
			-- BattleSceneClass._widget:runAction(seq)
			
			for i=1, BattleSceneClass._hero_index do
				local hero_pad = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel__hero_%d", i))
				
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", hero_pad._pos))
				local posOver = cc.p(posTile:getPosition())
				
				local function moveOverFunc()
					local temp_hero = hero_pad:getChildByTag(roleTag)
					temp_hero:retain()
					temp_hero:removeFromParent()
					posTile:addChild(temp_hero)
					temp_hero:release()
					self:moveOver()
				end
					-- 0.8秒后开是播放敌方入场动画
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					moveOverFunc()
				--else
					local array = {}
					table.insert(array, cc.MoveTo:create(1, posOver))
					table.insert(array, cc.CallFunc:create(moveOverFunc))
					local seq = cc.Sequence:create(array)
					hero_pad:runAction(seq)
				end
			
			end
			
			
		end
	end)
end
-- 移动线动画
function BattleSceneClass:moveLineSpeedAnimation()
	draw.createEffect("effect_6006", "effect/effect_6006.ExportJson", BattleSceneClass._widgetBg, 1, 100)
end
-- 我方移动动画，战斗回合完后的移动
function BattleSceneClass:heroBattleRoundOverMove()
	
end
-- 3. 显示UI
function BattleSceneClass:showBattleUI()
	state_machine.excute("battle_formation_show_ui", 0, nil)
	BattleSceneClass._widget:setVisible(true)
end
-- 4. 敌方角色入场
function BattleSceneClass:masterIntoBattle()
	--> print("播放敌人入场动画")
	BattleSceneClass._shakeAction:play("difang_ruchang", false)
	BattleSceneClass._shakeAction:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end
			
			local str = frame:getEvent()
			if str == "battle_hero_move_over" then
				-- 开场动画播放完毕
				-- 请求开始战斗

				self:battleRoundStart()
			end
		end)
end

-- 5. 战斗回合开始
function BattleSceneClass:battleRoundStart()
	if executeNextEvent(nil) == false then
		startBattleCallback()
	end
end

-- 
function BattleSceneClass:moveOver()
	local beganMoveTeam = 0
	-- 移动场景
	local size = cc.Director:getInstance():getWinSize() --draw.size()
	local movedHeroCount = 0
	local moveTeamState = 0
	local offsetY = 0
	local currentBattleIndex = _ED.battleData._currentBattleIndex
	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + currentBattleIndex 
	if __lua_project_id == __lua_king_of_adventure 
	or __lua_project_id == __lua_project_koone then
		ofsetCount=3
	end
			
	local function changeActionCallback(armatureBack)
		local armature = armatureBack
		if armature ~= nil then
			local actionIndex = armature._actionIndex
			if actionIndex == animation_moving then
				if armature._playerMoveMusic == true then
					if __lua_project_id == __lua_king_of_adventure then
					else
						playEffectMusic(9999)
					end
				end
				armature._nextAction = animation_move_end
			elseif actionIndex == animation_move_end then
				armature._nextAction = animation_standby
			elseif actionIndex == animation_standby then
				movedHeroCount = movedHeroCount - 1
				armature._invoke = nil
				if movedHeroCount == 0 then
					-- 我方全部进入待机
					--> print("我方全部进入待机")
					
					self:showBattleUI()
			
					local function playMasterAnimation()
						self:masterIntoBattle()
					end
					-- 0.8秒后开是播放敌方入场动画
					local array = {}
					table.insert(array, cc.DelayTime:create(0.8))
					table.insert(array, cc.CallFunc:create(playMasterAnimation))
					local seq = cc.Sequence:create(array)
					BattleSceneClass._widget:runAction(seq)
					
				end
			end
		end
	end

	local function moveToNextBattleN(sender)
		local armature = sender._armature
		if armature ~= nil then
			movedHeroCount = movedHeroCount + 1
			-- 移动
			if armature._camp == "1" then
				armature._actionIndex = battle_enum.animation_difangmove
				armature._nextAction = battle_enum.animation_difangmoving
			else
				-- 我方移动动画
				armature._actionIndex = animation_move
				armature._nextAction = animation_moving
			end
			armature._invoke = changeActionCallback
			armature:getAnimation():playWithIndex(armature._actionIndex)
			
			armature._playerMoveMusic = true
			if movedHeroCount == 1 then
				if __lua_project_id == __lua_king_of_adventure then
				else
					playEffectMusic(9999)
				end
			end
		end
	end
	
	for i=1, fightSlotCount do
		local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))		
		local array = {}
		table.insert(array, cc.CallFunc:create(moveToNextBattleN))
		local seq = cc.Sequence:create(array)
		posTile:runAction(seq)
		
		cleanBuffEffect(posTile)
	end
end

function BattleSceneClass:ctor()
	self.super:ctor()
	
	initNextRoundBattle = nil --军团副本回合结算,初始化下一回合
	lastTimeRoundBattleNumber = 0 -- 军团副本战斗上次回合的活动对象数
	currentcurrent_scene_npc_id_length = nil
	battleMoveUnionTeamY = nil

	BattleSceneClass._attackTotalHarm = nil
	skipCurrentFight = false
	lockSkipFight = false
	setDeathArmatureCount = -1
	
	BattleSceneClass._uiLayer = ccui.Layout:create()
	self:addChild(BattleSceneClass._uiLayer)
	
	local size = cc.Director:getInstance():getWinSize()
	
	BattleSceneClass._lastExp = _ED.user_info.user_experience
	BattleSceneClass._lastNeedExp = _ED.user_info.user_grade_need_experience
	
	_ED._user_last_grade = _ED.user_info.user_grade
	
	BattleSceneClass.curDamage = 0
	curMoney = 0
	if _ED._scene_npc_id ~= nil and _ED.npc_state[tonumber(_ED._scene_npc_id)] ~= nil and tonumber(_ED.npc_state[tonumber(_ED._scene_npc_id)]) <= 0 then
		jttd.begin(_ED._scene_npc_id)
	end
	-- -- --绘制当前进入的战斗地图
	-- -- GUIReader:shareReader():widgetFromCacheJsonFile("scene/battle/battle_map.json", "Panel_battle_map_1", 0)
	local mapIndex = "0"
	if _ED.battleData.battle_init_type >= 10 and _ED.battleData.battle_init_type ~= 14 and _ED.battleData.battle_init_type ~= 15 then
		mapIndex = "99"
	elseif _ED.battleData.battle_init_type == 14 then
		-- local npcIndex = LuaClasses["MineInformationClass"].__battleObj
		-- mapIndex = elementAt(NPC, npcIndex):atoi(npc.battle_background)
	elseif _ED.battleData.battle_init_type == 15 then
		-- local npcIndex = elementAt(spiritePalaceMould, tonumber(_ED.palace_inside_info.current_floor)):atoi(spirite_palace_mould.npc_index)
		-- mapIndex = elementAt(NPC, npcIndex):atoi(npc.battle_background)
	else
		local npcData = dms.element(dms["npc"], zstring.tonumber(_ED.battleData.objId))
		if npcData ~= nil then
			mapIndex = dms.atoi(npcData, npc.battle_background)
		end
	end
	-- --mapIndex = "7"
	-- --rint("mapIndex: ",mapIndex)
	-- -- draw.setImage("ImageView_16960", "map/battle/battle_"..mapIndex.."_0.jpg")
	-- -- draw.setImage("ImageView_16961", "map/battle/battle_"..mapIndex.."_1.jpg")
	-- BattleSceneClass._widgetBg = GUIReader:shareReader():widgetFromCacheJsonFile("scene/battle/battle_map.json", "Panel_battle_map_1", 1)
	-- BattleSceneClass._uiLayer:addChild(BattleSceneClass._widgetBg)
	-- BattleSceneClass._widgetBg = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_battle_map_1")
	
	local mapBg = csb.createNode("battle/battle_map.csb")
	BattleSceneClass._widgetBg = mapBg:getChildByName("root")
	BattleSceneClass._widgetBg:retain()
	BattleSceneClass._widgetBg:removeFromParent(false)
	
	BattleSceneClass._uiLayer:addChild(BattleSceneClass._widgetBg)
	BattleSceneClass._widgetBg:release()
	
	BattleSceneClass._widgetBg = ccui.Helper:seekWidgetByName(BattleSceneClass._widgetBg, "Panel_battle_map_1")
	
	BattleSceneClass.changeBackground(mapIndex)
	
	if _ED.battleData.battle_init_type == 2 then
		BattleSceneClass._GoldBossCell = draw.drawGoldBossInfo()
		BattleSceneClass._uiLayer:addChild(BattleSceneClass._GoldBossCell)
		BattleSceneClass._GoldBossCell:setPosition(cc.p(BattleSceneClass._GoldBossCell:getPositionX(), size.height/2))
	end

	local size = cc.Director:getInstance():getWinSize()
	local posx, posy =BattleSceneClass._widgetBg:getPosition()
	local posOffsetY = (size.height - fwin._width / CC_CONTENT_SCALE_FACTOR())
	BattleSceneClass._widgetBg:setPosition(cc.p(posx, posy - posOffsetY/2))
	
	BattleSceneClass._shakeAction = csb.createTimeline("battle/battle_map.csb")
    BattleSceneClass._widgetBg:getParent():runAction(BattleSceneClass._shakeAction)
    BattleSceneClass._shakeAction:gotoFrameAndPlay(0, BattleSceneClass._shakeAction:getDuration(), false)
	-- BattleSceneClass._shakeAction:setTimeSpeed(0.1*actionTimeSpeed)
	-- -- local action1 = ActionManager:shareManager():getActionByName("battle_map.json","Animation0")
	-- -- action1:play()
	
	-- 因为这个ui界面会涉及到加速跳过有较多地方在引用,为避免过多改动,显示做隐藏
	local battle_UI = csb.createNode("battle/battle_UI.csb")
	BattleSceneClass._widget = battle_UI:getChildByName("root")
	BattleSceneClass._widget:retain()
	BattleSceneClass._widget:removeFromParent(false)
	BattleSceneClass._uiLayer:addChild(BattleSceneClass._widget)
	BattleSceneClass._widget:release()
	ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer, "Panel_2"):setVisible(false)
	-- 默认隐藏UI
	BattleSceneClass._widget:setVisible(false)
	
	-- 隐藏加速按钮
	local speedIndex = 1
	while (true) do
		local speedBtn = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer, string.format("Button_x%d", speedIndex))
		if speedBtn == nil then
			break
		end
		speedBtn:setVisible(false)
		speedIndex = speedIndex + 1
	end
	
	--绘制战斗ui界面
	if _ED.battleData.battle_init_type == fight_type_7 then
		GUIReader:shareReader():widgetFromCacheJsonFile("interface/legion_fighting_ui.json", "Panel_19814", 0)
		BattleSceneClass._widget = GUIReader:shareReader():widgetFromCacheJsonFile("interface/legion_fighting_ui.json", "Panel_19814", 1)
		BattleSceneClass._uiLayer:addChild(BattleSceneClass._widget)
		GUIReader:shareReader():widgetFromCacheJsonFile("interface/legion_fighting_ui.json", "Panel_19814", -1)
		draw.setVisible(BattleSceneClass._uiLayer, "Panel_21991", false)
		local function battlefieldReportCallback(sender, eventType)				--点击确定
			if eventType == ccui.TouchEventType.ended then
				TipDlg.drawTextDailog(_function_unopened_tip_string)
			elseif eventType == ccui.TouchEventType.began then
				playEffect(formatMusicFile("button", 1))		--加入按钮音效
			end
		end
		local battlefieldReportButton = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Button_19861")
		battlefieldReportButton:addTouchEventListener(battlefieldReportCallback)

		
		-- 隐藏原来的
		draw.setVisible(BattleSceneClass._uiLayer, "Panel_10857", false)
	elseif _ED.battleData.battle_init_type == fight_type_8 then
		GUIReader:shareReader():widgetFromCacheJsonFile("interface/legion_fighting_ui_0.json", "Panel_24435", 0)
		BattleSceneClass._widget = GUIReader:shareReader():widgetFromCacheJsonFile("interface/legion_fighting_ui_0.json", "Panel_24435", 1)
		BattleSceneClass._uiLayer:addChild(BattleSceneClass._widget)
		GUIReader:shareReader():widgetFromCacheJsonFile("interface/legion_fighting_ui_0.json", "Panel_24435", -1)
		--draw.setVisible(BattleSceneClass._uiLayer, "Panel_21991", false)
		local function battlefieldReportCallback(sender, eventType)				--点击确定
			if eventType == ccui.TouchEventType.ended then
				TipDlg.drawTextDailog(_function_unopened_tip_string)
			elseif eventType == ccui.TouchEventType.began then
				playEffect(formatMusicFile("button", 1))		--加入按钮音效
			end
		end
		local battlefieldReportButton =ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Button_24451")
		battlefieldReportButton:addTouchEventListener(battlefieldReportCallback)
		
		
		
		
		-- 攻方 
		draw.label(BattleSceneClass._uiLayer, "Label_24448", LuaClasses["BattleSceneClass"]._unionBattleInfo.attackName)
		draw.label(BattleSceneClass._uiLayer, "Label_24440", LuaClasses["BattleSceneClass"]._unionBattleInfo.currentAttackNum.."/"..LuaClasses["BattleSceneClass"]._unionBattleInfo.attackNum)
		-- 守方
		draw.label(BattleSceneClass._uiLayer, "Label_24449", LuaClasses["BattleSceneClass"]._unionBattleInfo.defenseName)
		draw.label(BattleSceneClass._uiLayer, "Label_24442", LuaClasses["BattleSceneClass"]._unionBattleInfo.currentDefenseNum.."/"..LuaClasses["BattleSceneClass"]._unionBattleInfo.defenseNum)
		
		-- 隐藏原来的
		draw.setVisible(BattleSceneClass._uiLayer, "Panel_10857", false)
	end
		
	
	--战斗奖励道具数量
	local fightRewardItemCount = nil
	if _ED.battleData.battle_init_type == fight_type_7 then
		fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_19820_1")
	else
		fightRewardItemCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer, "Label_10866")
	end
	local itemCount = _ED._fight_reward_item_count
	if #itemCount<=0 then
		--tolua.cast(fightRewardItemCount,"Label"):setText("0")
		fightRewardItemCount:setString("0")
	else
		--tolua.cast(fightRewardItemCount,"Label"):setText(itemCount)
		fightRewardItemCount:setString(itemCount)
	end
	
	
	--战斗奖励将魂数量
	local fightRewardSoul = nil
	if _ED.battleData.battle_init_type == fight_type_7 then
		fightRewardSoul = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_19822_1")
	else
		fightRewardSoul = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10867")
	end
	local soulCount = _ED._fight_reward_soul
	if #soulCount<=0 then
		fightRewardSoul:setString("0")
	else
		fightRewardSoul:setString(soulCount)
	end
	--战斗奖励银币数量
	local fightRewardSilver = nil
	if _ED.battleData.battle_init_type == fight_type_7 then
		fightRewardSilver = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_19824")
	else
		fightRewardSilver = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10868")
	end
	local silverCount = _ED._fight_reward_silver
	if #silverCount<=0 then
		--tolua.cast(fightRewardSilver,"Label"):setText("0")
		fightRewardSilver:setString("0")
	else
		--tolua.cast(fightRewardSilver,"Label"):setText(silverCount)
		fightRewardSilver:setString(silverCount)
	end
	--每场战斗的战斗回合数
	local boutCount = _ED._fight_reward_bout_count
	local fightRewardBoutCount = nil
	if _ED.battleData.battle_init_type == fight_type_7 then
		fightRewardBoutCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_19849_1")
		local list =  zstring.split(_ED._scene_npc_id,",")
		local len = #list
		current_scene_npc_id_length = len
		fightRewardBoutCount:setString(current_scene_npc_id_length.."/"..len)
	else
		fightRewardBoutCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_10865")
		if #boutCount<=0 then
			--tolua.cast(fightRewardBoutCount,"Label"):setText("0".."/".."30")
			fightRewardBoutCount:setString("0".."/".."30")
		else
			--tolua.cast(fightRewardBoutCount,"Label"):setText(boutCount.."/".."30")
			fightRewardBoutCount:setString(boutCount.."/".."30")
		end
	end

	local function backPlotSceneCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if battleRunning == false then
					return
			end
			if tonumber(_ED._scene_npc_id) == kSkipPlotNPC then
				local currentAccount = _ED.user_platform[_ED.default_user].platform_account
				local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
				local saveKey = currentAccount..currentServerNumber.."bt".."m"..mission_mould_battle.."end"
				cc.UserDefault:sharedUserDefault():setStringForKey(saveKey, "6,3,0否,0,430v3")
				resetMission()
				if BattleSceneClass._effectBg ~= nil then
					BattleSceneClass._effectBg:removeFromParent(true)
					BattleSceneClass._effectBg = nil
				end

                --[[
				if executeMission(mission_mould_battle, touch_off_mission_battle_over, 
				"".._ED._scene_npc_id.."v".."3", nil) == true then
					return
				end
                --]]
                if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, 
				"".._ED._scene_npc_id.."v".."3", nil) == true then
					return
				end
			end
			if lockSkipFight == false then
				--lockSkipFight = true
				doSkipCurrentFight()
			end
			--LuaClasses["PlotSceneClass"].Draw()
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 2))		--加入按钮音效
		end
	end
	
	--跳过直接胜利
	local skipButton = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Button_10871")
	if tonumber(_ED._scene_npc_id) == kSkipPlotNPC then
		isCanSkipCurrentBattle = true
	elseif _ED.battleData.battle_init_type <1 or _ED.battleData.battle_init_type == 1 then
		isCanSkipCurrentBattle = (tonumber("".._ED.npc_state[zstring.tonumber("".._ED._scene_npc_id)]) >= tonumber("".._ED._npc_difficulty_index)) and true or false
	elseif _ED.battleData.battle_init_type >= 10 or _ED.battleData.battle_init_type == 2 or _ED.battleData.battle_init_type == 5 or  _ED.battleData.battle_init_type == 3 or  _ED.battleData.battle_init_type == 4 then
		isCanSkipCurrentBattle = true
	elseif _ED.battleData.battle_init_type == 6 then
		isCanSkipCurrentBattle = (tonumber("".._ED.npc_last_state[zstring.tonumber("".._ED._scene_npc_id)]) >= tonumber("".._ED._npc_difficulty_index)) and true or false
	end

	--[[
	skipButton:setVisible(isCanSkipCurrentBattle)

	if _ED.battleData.battle_init_type >= 1 then
		if _ED.battleData.battle_init_type < 10 then
			skipButton:setVisible(false)
		else
			skipButton:setVisible(true)
			isCanSkipCurrentBattle = (tonumber("".._ED.npc_state[zstring.tonumber("".._ED._scene_npc_id)]) >= tonumber("".._ED._npc_difficulty_index)) and true or false
		end
	else
		skipButton:setVisible(true)
		isCanSkipCurrentBattle = (tonumber("".._ED.npc_state[tonumber("".._ED._scene_npc_id)]) >= tonumber("".._ED._npc_difficulty_index)) and true or false
	end
	--]]
	if tonumber(_ED._scene_npc_id) == kSkipPlotNPC then
		local missionJumpButtonLayer = TouchGroup:create()
		draw.graphics(missionJumpButtonLayer,missionJump)
		draw.load("interface/skip.json")
		local missionJumpButton = draw.create("Button_54102")
		missionJumpButtonLayer:addChild(missionJumpButton)
		draw.delete()
		missionJumpButton:setTouchEnabled(true)
		missionJumpButton:setScale(0.8)
		missionJumpButton:setAnchorPoint(cc.p(0,0))
		missionJumpButton:setPosition(cc.p(draw.size().width-missionJumpButton:getContentSize().width,missionJumpButton:getContentSize().height))
		missionJumpButton:addTouchEventListener(backPlotSceneCallback)
		skipButton:setVisible(false)
	else
		skipButton:setVisible(false)
	end
	
	skipButton:addTouchEventListener(backPlotSceneCallback)
	
	-- -- GUIReader:shareReader():widgetFromCacheJsonFile("scene/battle/battle_map.json", "Panel_battle_map_1", -1)	
	
	--[[
	local startBattleCallback = nil
	local function responseEnvironmentFightCallback(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
			-- require "script/transformers/battle/BattleReward"
			-- LuaClasses["BattleRewardClass"].Draw()
			startBattleCallback()
		end
	end
	
	local function requestEnvironmentFightCallback(sender, eventType)	
		if eventType == ccui.TouchEventType.ended then
			--_ED._npc_difficulty_index = sender:getTag()
			protocol_command.environment_fight.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
			Sender(protocol_command.environment_fight.code, nil, nil, nil, nil, responseEnvironmentFightCallback)
		end
	end
	--]]
	
	-- requestEnvironmentFightCallback(nil, ccui.TouchEventType.ended)

	
	-- ------------------------------------------------------------------------------------------------- --
	-- 											战斗过程处理												 --
	-- ------------------------------------------------------------------------------------------------- --	
	-- 加载动画文件
	--CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
	if __lua_project_id == __lua_king_of_adventure then
		if _ED.battleData.battle_init_type == fight_type_7 or _ED.battleData.battle_init_type == fight_type_8 then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_1.ExportJson")
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_2.ExportJson")
		else
			local armatureFile = string.format("sprite/spirte_battle_card_%s.ExportJson",_ED.user_info.user_gender)
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(armatureFile)
			
			if _ED.battleData.battle_init_type == 10 or _ED.battleData.battle_init_type == 11 or _ED.battleData.battle_init_type == 12 or _ED.battleData.battle_init_type == 13 then
				local armatureFile = string.format("sprite/spirte_battle_card_%s.ExportJson", _ED.battle_fashion_info[2].genderId)
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(armatureFile)
			end
		end
	else
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
	end
	
	--CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo("sprite/hero_head_effect.ExportJson")
	if __lua_project_id == __lua_king_of_adventure then
		local armatureFile = string.format("sprite/hero_head_effect_%s.ExportJson",_ED.user_info.user_gender)
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(armatureFile)
		
		if _ED.battleData.battle_init_type == 10 or _ED.battleData.battle_init_type == 11 or _ED.battleData.battle_init_type == 12 or _ED.battleData.battle_init_type == 13 then
			local armatureFile = string.format("sprite/hero_head_effect_%s.ExportJson",_ED.battle_fashion_info[2].genderId)
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(armatureFile)
		end
	else
		if __lua_project_id ~= __lua_project_l_naruto then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect.ExportJson")
		end
	end
	
	-- 设置初始化战士的帧动画的监听
	local function animationEventCallFunc(armatureBack,movementType,movementID)
        local id = movementID
		--[[
        if movementType == ccui.MovementEventType.LOOP_COMPLETE then
		
            if id == "Fire" then
                armatureBack:stopAllActions()
                local actionToRight = cc.MoveTo:create(2, cc.p(VisibleRect:right().x - 50, VisibleRect:right().y))
                local arr = CCArray:create()
                arr:addObject(actionToRight)
                arr:addObject(CCCallFunc:create(callback1))
                armatureBack:runAction(CCSequence:create(arr))
                armatureBack:getAnimation():play("Walk")
            elseif id == "FireMax" then
                armatureBack:stopAllActions()
                local actionToLeft = cc.MoveTo:create(2, cc.p(VisibleRect:left().x + 50, VisibleRect:left().y))
                local arr = CCArray:create()
                arr:addObject(actionToLeft)
                arr:addObject(CCCallFunc:create(callback2))
                armatureBack:runAction(CCSequence:create(arr))
                armatureBack:getAnimation():play("Walk")
            end
        end
		--]]
	end
	
	-- 隐藏主角
	local function setVisibleAllHero(var)
		for i=1, fightSlotCount do
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))		
			local armature = posTile._armature
			if armature ~= nil then
				armature:setVisible(var)
			end
		end
	end
	
	--设置战士加速
	-- _camp 加速的倍数
	function BattleSceneClass.setRoleAcceleration()
		for i=1, 6 do
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
			if posTile._armature ~= nil and posTile._armature._isDeath == false then
				posTile._armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
			end
		end
		local fIndex = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		for i=1, 6 do
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", fIndex, i))
			if posTile._armature ~= nil and posTile._armature._isDeath == false then
				posTile._armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
			end
		end
		
	end
	
	
	
	-- 初始化战士动画
	local function initHero(pos, headId, quality, role, leader)
		--rint("initHero==>: " ,pos, headId, quality, role)
		BattleSceneClass._hero_index = BattleSceneClass._hero_index + 1
		local begin_pos = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel__hero_%d", BattleSceneClass._hero_index))	
		local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", pos))	
		if posTile._armature == nil then
		
			local armature=nil
			if __lua_project_id == __lua_king_of_adventure then
				if _ED.battleData.battle_init_type == fight_type_7 or _ED.battleData.battle_init_type == fight_type_8 then
					local armatureFile = string.format("spirte_battle_card_%s", role._gender)
					armature = ccs.Armature:create(armatureFile)
				else
					local armatureFile = string.format("spirte_battle_card_%s", _ED.user_info.user_gender)
					armature = ccs.Armature:create(armatureFile)
				end
			else
				armature = ccs.Armature:create("spirte_battle_card")
			end		
			
			--armature:getAnimation():playWithIndex(animation_standby)
			-- if _ED.battleData.battle_init_type >= 10 
				-- or _ED.battleData.battle_init_type == 2 
				-- or _ED.battleData.battle_init_type == 5 
				-- or _ED.battleData.battle_init_type == 6 
				-- or _ED.battleData.battle_init_type == fight_type_7
				-- or _ED.battleData.battle_init_type == fight_type_8
				-- then
				-- armature:getAnimation():playWithIndex(animation_standby)
			-- else
				-- armature:getAnimation():playWithIndex(animation_in_elite)
			-- end
			
			armature:getAnimation():playWithIndex(animation_moving)
			
			--if _ED.battleData.battle_init_type == fight_type_7 then
			--	armature:setVisible(false)	
			--end
			
			-- armature:getAnimation():play("2走位")
			-- armature:getAnimation():playWithIndex(2)
			-- armature:getAnimation():setSpeedScale(3)
			-- armature:getAnimation():play("1走位变形")
			armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
			armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
			armature:setTag(roleTag)
			posTile._armature = armature
			armature._posTile = posTile
			posTile._oldZOrder = posTile:getLocalZOrder()
			posTile._camp = "0"
			armature._camp = "0"
			armature._pos = pos
			armature._role = {}
			armature._role._id = role._id
			armature._role._hp = role._hp
			armature._role._sp = role._sp
			armature._role._quality = role._quality
			if _ED.battleData.battle_init_type == fight_type_7 
				or _ED.battleData.battle_init_type == fight_type_8
				then
				armature._role._harmValue = role._harmValue
			end
			
			armature._isNew = true
			armature._brole = role
			
			------------------------------------------------- 
			-- posTile:addChild(armature)
			begin_pos._pos = pos
			begin_pos:addChild(armature)
			------------------------------------------------- 
			
			
			armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
			
			-- 设置品质底
			if __lua_project_id==__lua_project_all_star then 
				quality=quality+1
			end 
			local qualityImage = string.format("images/card/card_quality_%s.png", quality)
			local card = ccs.Skin:create(qualityImage)
			armature:getBone("card"):addDisplay(card, 0)
			
			-- 设置角色
			local heroIcon = nil
			if __lua_project_id == __lua_project_all_star then
				heroIcon = string.format("images/face/big_head/big_head_%s.png", headId)
			else
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					heroIcon = string.format("images/face/big_head/big_head_%s.png", headId)
				else
					heroIcon = string.format("images/face/card_head/card_head_%s.png", headId)
				end
			end
			local roleIcon = ccs.Skin:create(heroIcon)
			armature:getBone("role"):addDisplay(roleIcon, 0)
			
			--绘制主角时装
			if __lua_project_id == __lua_king_of_adventure then
				if _ED.battleData.battle_init_type == 7 or _ED.battleData.battle_init_type == 8 then--公会战斗绘制时装
					BattleSceneClass.initUnionBattleFashion(role, armature)
				end
				
				if leader == true then
					--幽灵图像
					local heroDeath = string.format("images/face/big_head/big_head_233_%s.png", _ED.user_info.user_gender)
					local heroIcon = ccs.Skin:create(heroDeath)
					armature:getBone("Layer6"):addDisplay(heroIcon, 0)
					
					BattleSceneClass.initBattleFashion(armature , 1)
				else
					--幽灵图像
					local heroDeath = string.format("images/face/big_head/big_head_%s.png", 233)
					local heroIcon = ccs.Skin:create(heroDeath)
					armature:getBone("Layer6"):addDisplay(heroIcon, 0)
				end
			end
			
			-- 设置怒气数据
			local labelAtlas = cc.LabelAtlas:_create("", "images/ui/number/number_001.png", 24 / CC_CONTENT_SCALE_FACTOR(), 28 / CC_CONTENT_SCALE_FACTOR(), 48)   
			armature:getBone("power_number"):addDisplay(labelAtlas, 0)
			armature._spNumber = labelAtlas
			
			-- 设置HP数据
			local hpbgPragress = cc.Sprite:create("images/ui/pragress/xuetiao_0.png")
			armature:getBone("hp"):addDisplay(hpbgPragress, 0)
			armature._hpPragress = ccui.LoadingBar:create()
			armature._hpPragress:loadTexture("images/ui/pragress/xuetiao_1.png", 0)
			armature._hpPragress:setPercent(100)
			armature._hpPragress:setPosition(cc.p(hpbgPragress:getContentSize().width/2, hpbgPragress:getContentSize().height/2))
			hpbgPragress:addChild(armature._hpPragress)
			showRoleSP(armature)
			
			-- 设置攻防标记
			local powerInfoImg = draw.getBattleHeroAbilityImg(tonumber(role._mouldId),  tonumber(role._type))
			local powerInfo = ccs.Skin:create(powerInfoImg)
			armature:getBone("power_info"):addDisplay(powerInfo, 0)
		else
			posTile._armature._role._hp = role._hp
			posTile._armature._role._sp = role._sp
			posTile._armature._role._quality = role._quality
			posTile._armature._hpPragress:getParent():setVisible(true)
			showRoleSP(posTile._armature)
			showRoleHP(posTile._armature)
		end
		return posTile
	end
	
	-- 初始化我方战士阵型
	initBattle = function()
		state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
		BattleSceneClass._hero_index = 0
		for i, v in pairs(_ED.battleData._heros) do
			if __lua_project_id == __lua_king_of_adventure then
				local _leader =false
				if tonumber(v._id) ~= 0 then
					if v._id == _ED.battle_fashion_info[1].leaderId or tonumber (v._head) > 10000 then
						_leader =true
						if tonumber (v._head) > 10000 then
							v._head =  tonumber (v._head)-10000
						end
					end
					initHero(v._pos, v._head, v._quality, v, _leader)
				else
					if tonumber (v._head) > 10000 then
						v._head =  tonumber (v._head)-10000
						_leader =true
					end
					initHero(v._pos, v._head, v._quality, v, _leader)
				end
			else
				initHero(v._pos, v._head, v._quality, v)
			end
			
			-- 创建武将UI显示
			state_machine.excute("battle_formation_create_role_head", 0, {_roleType = 2, _id = v._id, _mouldId = v._mouldId, _pos = v._pos, _head = v._head, _roleName = "", _v = v})
		end
		
		if _ED.battleData._currentBattleIndex == 1 then
			-- setVisibleAllHero(false)
		end
		
		state_machine.excute("battle_formation_create_role_head_over", 0, {_num = num})
	end
	
	
	local function MasterAction(mposTile,index1)
		
		local eventJoinCount = 0
		local function heroJoinOver(armature)
			if armature ~= nil then
				if armature._actionIndex == animation_standby then	
					playEffectMusic(9998)
					armature._invoke = nil
					armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
				elseif armature._actionIndex == into[index1] then 
					armature._nextAction = animation_standby
					armature:setVisible(true)
					-- local armatureEffect = createEffect(armature._posTile, 63, 0)
					-- armatureEffect._invoke = deleteEffectFile
				end
			end
		end
		local function joinBattleFuncN(sender)
			local armature = sender._armature
			if armature ~= nil then
				armature._nextAction = into[index1]
				
				armature._invoke = heroJoinOver
				
				armature:getAnimation():setSpeedScale(1.0/fightAccelerationThree)
			end
		end
		
		-- 显示所有全场角色
		local armature = mposTile._armature
		if armature ~= nil then
			armature:setVisible(false)
			mposTile:getParent():reorderChild(mposTile, mposTile._oldZOrder)
			
			local array = {}
			table.insert(array, cc.DelayTime:create(1 * fightAccelerationThree))
			table.insert(array, cc.CallFunc:create(joinBattleFuncN))
			local seq = cc.Sequence:create(array)
			mposTile:runAction(seq)
		end
	end
	-- 初始化PVE敌方怪物动画
	local index = 0
	local function initMaster(fIndex, pos, headId, quality, role, enemy)
		--rint("initMaster==>: " ,fIndex, pos, headId, quality, role)
		local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", fIndex, pos))
		if __lua_project_id == __lua_king_of_adventure then
			posTile._scale = posTile:getScale()
			posTile._size = posTile:getContentSize()
			posTile:setSize(CCSize(posTile._size.width * posTile._scale, posTile._size.height * posTile._scale))
			posTile:setScale(1)
		end
		if _ED.battleData.battle_init_type == fight_type_7 
			or _ED.battleData.battle_init_type == fight_type_8
			then
			posTile:removeAllChildren(true)	
		end
		
		local armature=nil
		if __lua_project_id == __lua_king_of_adventure then
			if _ED.battleData.battle_init_type == 11 or _ED.battleData.battle_init_type == 12 or _ED.battleData.battle_init_type == 13 then
				local armatureFile = string.format("spirte_battle_card_%s", _ED.battle_fashion_info[2].genderId)
				armature = ccs.Armature:create(armatureFile)
			elseif _ED.battleData.battle_init_type == fight_type_8 then
				local armatureFile = string.format("spirte_battle_card_%s", role._gender)
				armature = ccs.Armature:create(armatureFile)
			elseif _ED.battleData.battle_init_type == 10 then
				if enemy == true then
					local armatureFile = string.format("spirte_battle_card_%s", _ED.battle_fashion_info[2].genderId)
					armature = ccs.Armature:create(armatureFile)
				else
					local armatureFile = string.format("spirte_battle_card_%s", _ED.user_info.user_gender)
					armature = ccs.Armature:create(armatureFile)
				end
			else
				local armatureFile = string.format("spirte_battle_card_%s", _ED.user_info.user_gender)
				armature = ccs.Armature:create(armatureFile)
			end
		else
			armature = ccs.Armature:create("spirte_battle_card")
		end
			
		armature:getAnimation():playWithIndex(animation_standby)
		-- armature:getAnimation():play("2走位")
		-- armature:getAnimation():playWithIndex(2)
		-- armature:getAnimation():setSpeedScale(3)
		-- armature:getAnimation():play("1走位变形")
		armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
		armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
		armature:setTag(roleTag)
		posTile._armature = armature
		armature._posTile = posTile
		posTile._oldZOrder = posTile:getLocalZOrder()
		posTile._camp = "1"
		armature._camp = "1"
		armature._role = {}
		armature._pos = pos
		armature._role._id = role._id
		armature._role._hp = role._hp
		armature._role._sp = role._sp
		armature._role._quality = role._quality
		if _ED.battleData.battle_init_type == fight_type_7 
			or _ED.battleData.battle_init_type == fight_type_8
			then
			armature._role._harmValue = role._harmValue
		end
		armature._brole = role
		posTile:addChild(armature)
		
		if __lua_project_id == __lua_king_of_adventure then
			armature._brole._scale = posTile._scale * armature._brole._scale
		end
		armature:setScale(armature._brole._scale)
		
		armature._isNew = true
		
		--if _ED.battleData.battle_init_type == fight_type_7 then
		--	armature:setVisible(false)	
		--end
		
		--local xx, yy = posTile:getPosition()
		--local psize = posTile:getContentSize()
		
		--posTile:setPosition(cc.p(xx + (1 - armature._brole._scale) * psize.width/2, yy - (1 - armature._brole._scale) * psize.height/2))
		if __lua_project_id == __lua_king_of_adventure then
			if headId == "403" or headId == "5005" then
			else
				index=index+1
				if index > 6 then
					index = 1
				end
				MasterAction(posTile,index)
			end
		end
		armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
		
		-- 设置品质底
		if __lua_project_id==__lua_project_all_star then 
			quality=quality+1
		end 
		local qualityImage = string.format("images/card/card_quality_%s.png", quality)
		local card = ccs.Skin:create(qualityImage)
        armature:getBone("card"):addDisplay(card, 0)
		
		-- 设置角色
		local heroIcon = nil
		if __lua_project_id == __lua_project_all_star then
			heroIcon = string.format("images/face/big_head/big_head_%s.png", headId)
		else
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				heroIcon = string.format("images/face/big_head/big_head_%s.png", headId)
			else
				heroIcon = string.format("images/face/card_head/card_head_%s.png", headId)
			end
			
		end
		local roleIcon = ccs.Skin:create(heroIcon)
        armature:getBone("role"):addDisplay(roleIcon, 0)
		
		--绘制主角时装
		if __lua_project_id == __lua_king_of_adventure then
			if _ED.battleData.battle_init_type == 8 then--公会战斗绘制时装
				BattleSceneClass.initUnionBattleFashion(role, armature)
			end
			
			if enemy == true then
				--幽灵图像
				local masterDeath = string.format("images/face/big_head/big_head_233_%s.png", _ED.battle_fashion_info[2].genderId)
				local masterIcon = ccs.Skin:create(masterDeath)
				armature:getBone("Layer6"):addDisplay(masterIcon, 0)
				
				BattleSceneClass.initBattleFashion(armature, 2)
			else
				--幽灵图像
				local masterDeath = string.format("images/face/big_head/big_head_%s.png", 233)
				local masterIcon = ccs.Skin:create(masterDeath)
				armature:getBone("Layer6"):addDisplay(masterIcon, 0)
			end
		end
			
		-- 设置怒气数据
		local labelAtlas = cc.LabelAtlas:_create("", "images/ui/number/number_001.png", 24 / CC_CONTENT_SCALE_FACTOR(), 28 / CC_CONTENT_SCALE_FACTOR(), 48)   
		armature:getBone("power_number"):addDisplay(labelAtlas, 0)
		armature._spNumber = labelAtlas
		
		-- 设置HP数据
		local hpbgPragress = cc.Sprite:create("images/ui/pragress/xuetiao_0.png")
		armature:getBone("hp"):addDisplay(hpbgPragress, 0)
		armature._hpPragress = ccui.LoadingBar:create()
		armature._hpPragress:loadTexture("images/ui/pragress/xuetiao_1.png", 0)
		armature._hpPragress:setPercent(100)
		--armature._hpPragress:setAnchorPoint(cc.p(0, 0))
		-- hpbgPragress:setAnchorPoint(cc.p(0.5, 0.5))
		armature._hpPragress:setPosition(cc.p(hpbgPragress:getContentSize().width/2, hpbgPragress:getContentSize().height/2))
		hpbgPragress:addChild(armature._hpPragress)
		--hpbgPragress:addChild(armature._hpPragress, 10)
		--armature._spNumber:addChild(armature._hpPragress, 1)
		
		if _ED.battleData.battle_init_type == 2 or  
			_ED.battleData.battle_init_type == 5 then
			hpbgPragress:setVisible(false)
		end
		
		-- 设置攻防标记 
		local powerInfoImg = draw.getBattleHeroAbilityImg(tonumber(role._mouldId),tonumber(role._type))
		local powerInfo = ccs.Skin:create(powerInfoImg)
		armature:getBone("power_info"):addDisplay(powerInfo, 0)

		
		showRoleSP(armature)
		if zstring.tonumber(armature._role._id) == shieldFoeId then
			hpbgPragress:setVisible(false)
			card:setVisible(false)
			labelAtlas:setVisible(false)
			powerInfo:setVisible(false)
		end
		
		if __lua_project_id == __lua_king_of_adventure then
			if headId == "403" or headId == "286" then
				hpbgPragress:setVisible(false)
				card:setVisible(false)
				labelAtlas:setVisible(false)
				powerInfo:setVisible(false)
			end
		end
		
		if __lua_project_id==__lua_project_all_star then 
			if zstring.tonumber(_ED._scene_npc_id) == 453 and role._id == "1518" and armature._camp=="1" then
				hpbgPragress:setVisible(false)
				card:setVisible(false)
				labelAtlas:setVisible(false)
				powerInfo:setVisible(false)
			end
		end 
		
		return posTile
	end
	
	-- 初始化PVE敌方阵型
	initEnemy = function()
		state_machine.excute("battle_formation_update_ui", 0, {_num = 1})
		local offsetY = 0
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		for i, v in pairs(_ED.battleData._armys[_ED.battleData._currentBattleIndex]._data) do
			if __lua_project_id == __lua_king_of_adventure then
				local _enemy = false
				if tonumber(v._id) == 0 or _ED.battleData.battle_init_type == 10 or _ED.battleData.battle_init_type == 11 or _ED.battleData.battle_init_type == 12 or _ED.battleData.battle_init_type == 13 then
					if v._id == _ED.battle_fashion_info[2].leaderId then
						_enemy =true
					end
					initMaster(ofsetCount, v._pos, v._head, v._quality, v,_enemy)
				else
					initMaster(ofsetCount, v._pos, v._head, v._quality, v,_enemy)
				end
			else
				initMaster(ofsetCount, v._pos, v._head, v._quality, v)
			end
			
			state_machine.excute("battle_formation_create_role_head", 0, {_roleType = 1, _id = v._id, _mouldId = v._mouldId, _pos = v._pos, _head = v._head, _roleName = "", _v = v})
		end
	end
	
	local function getNextScenePosition()
		local size = cc.Director:getInstance():getWinSize() --draw.size()
		
		-- 设置初始位置	
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		
		local offsetYPVP = 0
		local sPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_0_2")
		local sxx, syy = sPosTile:getPosition()
		
		local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
		local xx2, yy2 = posTile2:getPosition()
		
		local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
		local xx, yy = posTile:getPosition()
		offsetYPVP = yy - (size.height) + posTile:getContentSize().height/2
			
		offsetYPVP = offsetYPVP - syy + teamTopScreenOffsetY + (yy - yy2) + posTile:getContentSize().height
		
		local mtime = offsetYPVP/moveFrameSpace * moveFrameTime
		
		return offsetYPVP, mtime
	end
	
	local function initUnionFormation()
		--rint("initUnionFormation:  进入阵型布局")
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		local heroTeam = {}
		local armysTeam = {}
		local fight = getUnionFightInfo()
		local currentBattleIndex = fight.currentBattleIndex
		local counterpart_fight_info = fight.fight_info[currentBattleIndex]
		for i = 1, fight.fight_count do
			local id = counterpart_fight_info[i][1]
			--rint(i.."-------------------------------")
			--rint("harmValue =" , counterpart_fight_info[i][2])
			for ii, v in pairs(_ED.battleData._heros) do
				if id == v._id then
					--rint("heroTeam: " , v._id)
					--rint("v._harmValue =" , counterpart_fight_info[i][2])
					v._harmValue = counterpart_fight_info[i][2]
					table.insert(heroTeam,v)
				end
			end
			
			local id2 = counterpart_fight_info[i][3]
			for i2, v2 in pairs(_ED.battleData._armys[_ED.battleData._currentBattleIndex]._data) do
				if id2 == v2._id then
					--rint("armysTeam: " , v2._id)
					v2._harmValue = counterpart_fight_info[i][4]
					table.insert(armysTeam,v2)
				end
			end
		end
		BattleSceneClass._hero_index = 0
		for i2 = 1, 6 do
		--for i, v in pairs(heroTeam) do
		local v = heroTeam[i2]
			if v ~= nil then
				--rint("_ED.battleData._heros----------------------------")
				--rint(v._id, v._pos, v._head, v._quality, v)
				initHero(v._pos, v._head, v._quality, v)
			end
		end
		--for i2 = 1, #armysTeam do
		for i2 = 1, 6 do
			local v2 = armysTeam[i2]
			if v2 ~= nil then
				--rint("_ED.battleData._armys----------------------------")
				--rint(v2._id,v2._pos, v2._head, v2._quality, v2)
				initMaster(ofsetCount, i2, v2._head, v2._quality, v2)
			end
		end
		
		local offsetYPVP, mtime = getNextScenePosition()
		--rint("offsetYPVP:", offsetYPVP)
		for i = 1, 6 do
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))
			local xx, yy = posTile:getPosition()
			posTile:setPosition(cc.p(xx, yy+offsetYPVP - attackUnionTagetOffsetY))
			posTile._dx = xx
			posTile._dy = yy+offsetYPVP
		end
		
		for i = 1, 6 do
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))
			local xx, yy = posTile:getPosition()
			posTile:setPosition(cc.p(xx, yy + attackUnionTagetOffsetY))
			posTile._dx = xx
			posTile._dy = yy
		end
		-- set background image positon
		local xxx, yyy = BattleSceneClass._widgetBg:getPosition()
		BattleSceneClass._widgetBg:setPosition(cc.p(xxx, yyy+(offsetYPVP)*-1))
	end
	
	local function chanageToNextBattle()
		requestEnvironmentFightCallback(nil, ccui.TouchEventType.ended)
	end
--------------------------------------------------------------------------------------------------------------------------
	--pvp战场淡入
	local fadeInBattlePVP = function()
		local function fadeInBattleCallFuncN(sender)
			--cc.Director:getInstance():getRunningScene():removeChildByTag(kTagFadeInLayerColor, true)
			sender:removeFromParent(true)
			-- heroJoinBattle()
			-- 请求执行进入场景的事件
			if _ED.battleData.battle_init_type >= 10 or
				-- executeMission(mission_mould_plot, touch_off_mission_into_scene, "".._ED._scene_npc_id, nil, true) == false 
                --executeMissionExt(mission_mould_plot, touch_off_mission_into_scene, "".._ED._scene_npc_id, nil, true) == false 
				true
                then
				-- executeNextEvent(heroJoinBattle)
				for i=1, fightSlotCount do
					local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))		
					
					local armature = posTile._armature
					if armature ~= nil then
						armature._actionIndex = animation_standby
						armature._nextAction = animation_standby
						armature:setVisible(true)
					end
				end
				startBattleCallback()
				--[[
				if _ED.battleData.battle_init_type >= 1 then
					skipButton:setVisible(false)
				else
					skipButton:setVisible(true)
				end
				--]]
				if _ED.battleData.battle_init_type == 1 then
					skipButton:setVisible(true)
				elseif _ED.battleData.battle_init_type == 3 then
					skipButton:setVisible(true)
				elseif _ED.battleData.battle_init_type == 6 then
					skipButton:setVisible(true)
				elseif _ED.battleData.battle_init_type >= 10 or _ED.battleData.battle_init_type < 1 or _ED.battleData.battle_init_type == 2 or _ED.battleData.battle_init_type == 5 then
					skipButton:setVisible(true)
				end
			end
		end
		
		-- 设置初始位置	
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		
		local offsetYPVP = 0
		local sPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_0_2")
		local sxx, syy = sPosTile:getPosition()
		
		local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
		local xx2, yy2 = posTile2:getPosition()
		local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
		local xx, yy = posTile:getPosition()
		offsetYPVP = yy - (size.height) + posTile:getContentSize().height/2
			
			-- offsetY = yy - size.height + posTile:getContentSize().height + teamTopScreenOffsetY
		offsetYPVP = offsetYPVP - syy + teamTopScreenOffsetY + (yy - yy2) + posTile:getContentSize().height
		if __lua_project_id == __lua_project_all_star then
		   offsetYPVP = offsetYPVP + 30 / CC_CONTENT_SCALE_FACTOR()
		  elseif __lua_project_id == __lua_king_of_adventure then
		   offsetYPVP = offsetYPVP + 100 / CC_CONTENT_SCALE_FACTOR()
		end  
		
		if ofsetCount ~= 1 then
			for i = 1, 6 do
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))
				local xx, yy = posTile:getPosition()
				--posTile:setPosition(cc.p(xx, yy + (480 * (ofsetCount-1))/ CC_CONTENT_SCALE_FACTOR()))
				posTile:runAction(cc.MoveBy:create(0.03, cc.p(0, (offsetYPVP))))
			end
			--local xx, yy = BattleSceneClass._widgetBg:getPosition()
			--BattleSceneClass._widgetBg:setPosition(cc.p(xx, yy - (480 * (ofsetCount-1))/ CC_CONTENT_SCALE_FACTOR()))
			BattleSceneClass._widgetBg:runAction(cc.MoveBy:create(0.03, cc.p(0, -1 * (offsetYPVP))))
		end
		
		--local scene =  cc.Director:getInstance():getRunningScene()
		local s = cc.Director:getInstance():getWinSize() --draw.size()
		local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), s.width * 2, s.height * 2)
		layer:setPosition(cc.p(- 1 * draw.size().width/2, -1 * draw.size().height/2))
		-- layer:setCascadeColorEnabled(true)

		-- layer:setPosition( cc.p(0, s.height/2))
		-- layer:setOrder(kTagFadeInLayerColor)
		--scene:addChild(layer, kTagFadeInLayerColor, kTagFadeInLayerColor)
		draw.graphics(layer, kTagFadeInLayerColor, kTagFadeInLayerColor)
		
		local arr = {}
		table.insert(array, cc.DelayTime:create(0.5 * actionTimeSpeed))
		table.insert(array, cc.FadeOut:create(0.5 * actionTimeSpeed))
		table.insert(array, cc.CallFunc:create(fadeInBattleCallFuncN))
		layer:runAction(cc.Sequence:create(arr))
	end
	--pvp战场淡入END
--------------------------------------------------------------------------------------------------------------------------	
	-- 战场淡入
	local fadeInBattle = function()
		local function fadeInBattleCallFuncN(sender)
			--cc.Director:getInstance():getRunningScene():removeChildByTag(kTagFadeInLayerColor, true)
			sender:removeFromParent(true)
			-- heroJoinBattle()
			-- 请求执行进入场景的事件
			if _ED.battleData.battle_init_type >= 10 or 
				-- executeMission(mission_mould_plot, touch_off_mission_into_scene, "".._ED._scene_npc_id, nil, true) == false 
                -- executeMissionExt(mission_mould_plot, touch_off_mission_into_scene, "".._ED._scene_npc_id, nil, true) == false 
                true
                then
	            if missionIsOver() == false then
		            executeNextEvent(heroJoinBattle, true)
                    return
	            end
     
				-- executeNextEvent(heroJoinBattle)
				 heroJoinBattle()
				--[[
				if _ED.battleData.battle_init_type >= 1 then
					skipButton:setVisible(false)
				else
					skipButton:setVisible(true)
				end
				--]]
				if _ED.battleData.battle_init_type == 1 then
					skipButton:setVisible(true)
				elseif _ED.battleData.battle_init_type >= 10 
					or _ED.battleData.battle_init_type < 1 
					or _ED.battleData.battle_init_type == 2 
					or _ED.battleData.battle_init_type == 4
					or _ED.battleData.battle_init_type == 5 
					or _ED.battleData.battle_init_type == 3 then
					skipButton:setVisible(true)
				end
			end
		end
		
		-- 设置初始位置	
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		
		if _ED.battleData.battle_init_type == fight_type_7 
			or _ED.battleData.battle_init_type == fight_type_8
			then
			
		else 
			if __lua_project_id == __lua_king_of_adventure 
			or __lua_project_id == __lua_project_koone then
				local startPositionY = function()--英雄进场位置
					local size = cc.Director:getInstance():getWinSize() --draw.size()
					local movedHeroCount = 0
					local moveTeamState = 0
					local offsetY = 0
					local currentBattleIndex = _ED.battleData._currentBattleIndex
					local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + currentBattleIndex 
					local ofsetCount = 3 --索引值固定在第三波
					local sPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_0_2")
					local sxx, syy = sPosTile:getPosition()
					
					local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
					local xx2, yy2 = posTile2:getPosition()
					
					local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
					local xx, yy = posTile:getPosition()
					offsetY = yy - (size.height) + posTile:getContentSize().height/2
					
					-- offsetY = yy - size.height + posTile:getContentSize().height + teamTopScreenOffsetY
					offsetY = offsetY - syy + teamTopScreenOffsetY + (yy - yy2) + posTile:getContentSize().height
					offsetY = offsetY + 80 / CC_CONTENT_SCALE_FACTOR() 
					return offsetY
				end
				
				local offsetY=startPositionY()
				offsetY = 0.000001
				local screenSize = cc.size(640 / CC_CONTENT_SCALE_FACTOR(), 960 / CC_CONTENT_SCALE_FACTOR())
				local size = cc.Director:getInstance():getWinSize()
				offsetY = offsetY + (1136 / CC_CONTENT_SCALE_FACTOR() - size.height)
				for i = 1, 6 do
					local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))
					local xx, yy = posTile:getPosition()
					posTile:runAction(cc.MoveBy:create(0.03, cc.p(0,offsetY)))
				end
				BattleSceneClass._widgetBg:runAction(cc.MoveBy:create(0.03, cc.p(0, -1 * offsetY)))
			else
				if ofsetCount ~= 1 then
					if __lua_project_id == __lua_king_of_adventure 
					or __lua_project_id == __lua_project_koone then
						moveTeam()
					else
						for i = 1, 6 do
							local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))
							local xx, yy = posTile:getPosition()
							--posTile:setPosition(cc.p(xx, yy + (480 * (ofsetCount-1))/ CC_CONTENT_SCALE_FACTOR()))
							posTile:runAction(cc.MoveBy:create(0.03, cc.p(0, ((480 * (ofsetCount-1))/ CC_CONTENT_SCALE_FACTOR()) - posOffsetY/2)))
						end
						--local xx, yy = BattleSceneClass._widgetBg:getPosition()
						--BattleSceneClass._widgetBg:setPosition(cc.p(xx, yy - (480 * (ofsetCount-1))/ CC_CONTENT_SCALE_FACTOR()))
						BattleSceneClass._widgetBg:runAction(cc.MoveBy:create(0.03, cc.p(0, -1 * ((480 * (ofsetCount-1))/ CC_CONTENT_SCALE_FACTOR() - posOffsetY/2))))
					end
				end
			end
		end
		
		--local scene =  cc.Director:getInstance():getRunningScene()
		local s = cc.Director:getInstance():getWinSize() --draw.size()
		local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), s.width * 2, s.height * 2)
		layer:setPosition(cc.p(- 1 * draw.size().width/2, -1 * draw.size().height/2))
		-- layer:setCascadeColorEnabled(true)

		-- layer:setPosition( cc.p(0, s.height/2))
		-- layer:setOrder(kTagFadeInLayerColor)
		--scene:addChild(layer, kTagFadeInLayerColor, kTagFadeInLayerColor)
		draw.graphics(layer, kTagFadeInLayerColor, kTagFadeInLayerColor)
		
		-- -- local arr = CCArray:create()
		-- -- arr:addObject(cc.DelayTime:create(0.5 * actionTimeSpeed))
		-- -- arr:addObject(cc.FadeOut:create(0.5 * actionTimeSpeed))
		-- -- arr:addObject(cc.CallFunc:create(fadeInBattleCallFuncN))
		layer:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.5 * actionTimeSpeed),
			cc.FadeOut:create(0.5 * actionTimeSpeed),
			cc.CallFunc:create(fadeInBattleCallFuncN)
		))
	
	end
	
	-- 角色出场
	heroJoinBattle = function()
		-- 英雄加入副本
		local joinCount = 0
		local function heroJoinOver(armature)
			if armature ~= nil then
				if armature._actionIndex == animation_standby then	
					if _ED.battleData.battle_init_type == fight_type_7 
						or _ED.battleData.battle_init_type == fight_type_8
						then
						--armature:setVisible(true)
						armature._invoke = nil
						armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
						joinCount = joinCount - 1
						if joinCount == 0 then
							-- 准备移动队伍
							moveUnionTeam()
							-- armature._invoke = nil
						end
					else
						draw.share()
						playEffectMusic(9998)
						armature._invoke = nil
						armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
					
						joinCount = joinCount - 1
						if joinCount == 0 then
							-- 准备移动队伍
							if __lua_project_id == __lua_king_of_adventure 
							or __lua_project_id == __lua_project_koone then
								local posTile3 = BattleSceneClass._widgetBg:getWidgetByName("Panel_1_1")
								posTile3:setVisible(true) 
								local posTile7 = BattleSceneClass._widgetBg:getWidgetByName("Panel_1_2")
								posTile7:setVisible(true) 
								local posTile8 = BattleSceneClass._widgetBg:getWidgetByName("Panel_1_3")
								posTile8:setVisible(true) 
								local posTile4 = BattleSceneClass._widgetBg:getWidgetByName("Panel_1_4")
								posTile4:setVisible(true) 
								local posTile5 = BattleSceneClass._widgetBg:getWidgetByName("Panel_1_5")
								posTile5:setVisible(true) 
								local posTile6 = BattleSceneClass._widgetBg:getWidgetByName("Panel_1_6")
								posTile6:setVisible(true) 
							end
							-- moveTeam()
							-- armature._invoke = nil
						end
										
						-- local action1 = ActionManager:shareManager():getActionByName("battle_map.json","Animation0")
						-- action1:play()
						-- action1:setLoop(true)
						-- BattleSceneClass._shakeAction:gotoFrameAndPlay(0, BattleSceneClass._shakeAction:getDuration(), true)
					end
				elseif armature._actionIndex == animation_in_elite then
					armature._nextAction = animation_standby
					armature:setVisible(true)	
				end
				--[[
				--]]
			end
		end
		
		local function joinBattleFuncN(sender)
			local armature = sender._armature
			if armature ~= nil then
				-- armature:setVisible(true)
				-- armature._nextFunc = nil_animationEventCallFunc
				--armature:getAnimation():playWithIndex(animation_in_elite)
				--armature._invoke = heroJoinOver
				--armature._nextAction = animation_standby
				--armature._actionIndex = animation_standby
				
				if _ED.battleData.battle_init_type == fight_type_7
					or _ED.battleData.battle_init_type == fight_type_8
					then
					armature._nextAction = animation_standby
				else
					armature._nextAction = animation_in_elite
				end
				armature._invoke = heroJoinOver
				
				armature:getAnimation():setSpeedScale(1.0/fightAccelerationThree)
				
				--armature:setVisible(true)
				--armature:getAnimation():playWithIndex(animation_in_elite)
				--armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)

				--armature:getAnimation():setMovementEventCallFunc(nil_animationEventCallFunc)
				--armature:getAnimation():setMovementEventCallFunc(moving_animationEventCallFunc)
				-- armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
			end
		end
		
		-- 显示所有全场角色
		-- setVisibleAllHero(true)
			
		for i=1, fightSlotCount do
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))		
			--> print(string.format("Panel_0_%d", i))
			
			local armature = posTile._armature
			if armature ~= nil then
				if _ED.battleData.battle_init_type == fight_type_7 
					or _ED.battleData.battle_init_type == fight_type_8
					then
				else
					armature:setVisible(false)
				end
				
				if __lua_project_id == __lua_king_of_adventure then
					posTile:getParent():reorderChild(posTile, posTile._oldZOrder)
				else
					posTile:getParent():reorderChild(posTile, 0)
				end
				
				local array = {}
				table.insert(array, cc.DelayTime:create((0.01 + 0.5 * joinCount) * fightAccelerationThree))
				table.insert(array, cc.CallFunc:create(joinBattleFuncN))
				local seq = cc.Sequence:create(array)
				posTile:runAction(seq)
				joinCount = joinCount + 1
			end
		end
	end
	
	local beganMoveTeam = 0
	-- 移动队伍到目的地
	moveTeam = function()
		if true then
			self:masterIntoBattle()
			return
		end
			-- 移动场景
			local size = cc.Director:getInstance():getWinSize() --draw.size()
			local movedHeroCount = 0
			local moveTeamState = 0
			local offsetY = 0
			local currentBattleIndex = _ED.battleData._currentBattleIndex
			local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + currentBattleIndex 
			if __lua_project_id == __lua_king_of_adventure 
			or __lua_project_id == __lua_project_koone then
				ofsetCount=3
			end
			local sPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_0_2")
			local sxx, syy = sPosTile:getPosition()
			
			local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
			
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
			local xx, yy = posTile:getPosition()
			offsetY = yy - (size.height) + posTile:getContentSize().height/2
			
			-- offsetY = yy - size.height + posTile:getContentSize().height + teamTopScreenOffsetY
			offsetY = offsetY - syy + teamTopScreenOffsetY + (yy - yy2) + posTile:getContentSize().height
			if __lua_project_id == __lua_project_all_star 
				 or __lua_project_id == __lua_project_superhero then
					offsetY = offsetY + 30 / CC_CONTENT_SCALE_FACTOR()
			elseif __lua_project_id == __lua_king_of_adventure 
			or __lua_project_id == __lua_project_koone then 
				offsetY = offsetY + 80 / CC_CONTENT_SCALE_FACTOR()
			end	 
			
			--[[
			if posOffsetY > 0 then
				offsetY = 480 / CC_CONTENT_SCALE_FACTOR() + math.abs(posOffsetY/2) -- - posTile:getContentSize().height/2
				offsetY = yy2 - syy - offsetY
				local mtime = offsetY/moveFrameSpace * moveFrameTime
			end
			--]]
			local function moveOverCallback()
				-- MoveOver
				beganMoveTeam = 2
				for i=1, fightSlotCount do
					local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
					local armature = posTile._armature
					if armature ~= nil then
						armature._actionIndex = animation_move_end
						armature._nextAction = animation_move_end
						local _invoke = armature._invoke
						armature._isDeath = false
						armature._invoke = nil
						armature:getAnimation():playWithIndex(animation_move_end)
						armature._invoke = _invoke
					end
				end
			end
			local mtime = offsetY/moveFrameSpace * moveFrameTime
			if __lua_project_id == __lua_king_of_adventure 
			or __lua_project_id == __lua_project_koone then
				mtime = 0.03
				offsetY = 0.000001
			end
			
			local function changeActionCallback(armatureBack)
				local armature = armatureBack
				if armature ~= nil then
					local actionIndex = armature._actionIndex
					if actionIndex == animation_moving then
						if armature._playerMoveMusic == true then
							if __lua_project_id == __lua_king_of_adventure then
							else
								playEffectMusic(9999)
							end
						end
						if moveTeamState == 0 then
							for i=1, fightSlotCount do
								local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))		
								local array = {}
								--array:addObject(CCActionInterval:create(1.2))
								table.insert(array, cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, offsetY)))
								local seq = cc.Sequence:create(array)
								posTile:runAction(seq)
							end
							
							-- local action1 = ActionManager:shareManager():getActionByName("battle_map.json","Animation0")
							-- action1:stop()
							-- -- BattleSceneClass._shakeAction:stop()
							BattleSceneClass._shakeAction:gotoFrameAndPlay(0, 0, false)
							
							local xxx, yyy = BattleSceneClass._widgetBg:getPosition()
							local array = {}
							--array:addObject(CCActionInterval:create(0.5))
							table.insert(array, cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, offsetY * -1)))
							table.insert(array, cc.CallFunc:create(moveOverCallback))
							local seq = cc.Sequence:create(array)
							BattleSceneClass._widgetBg:stopAllActions()
							BattleSceneClass._widgetBg:runAction(seq)
							
							moveTeamState = 1
						elseif beganMoveTeam == 2 then
							--armature._nextAction = animation_move_end
						end
					elseif actionIndex == animation_move_end then
						if beganMoveTeam == 2 then
							armature._nextAction = animation_standby
						end
					elseif actionIndex == animation_standby then
						movedHeroCount = movedHeroCount - 1
						armature._invoke = nil
						-- armature:getAnimation():setMovementEventCallFunc(nil_animationEventCallFunc)
						if movedHeroCount == 0 then
							if executeNextEvent(nil) == false then
								startBattleCallback()
							end
						end
					end
				end
			end
			
				--[[
			local function onFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
				local info = string.format("(%s) emit a frame event (%s) at frame index (%d).",bone:getName(),evt,currentFrameIndex)
				if (not self:getActionByTag(frameEventActionTag)) or (not self:getActionByTag(frameEventActionTag):isDone()) then
					self:stopAllActions()
					local action =  CCShatteredTiles3D:create(0.2, cc.size(16,12), 5, false) 
					action:setTag(frameEventActionTag)
					self:runAction(action)
				end
				
			end
			--]]
		
			local function moveToNextBattleN(sender)
				local armature = sender._armature
				if armature ~= nil then
					movedHeroCount = movedHeroCount + 1
					-- 移动
					if armature._camp == "1" then
						armature._actionIndex = battle_enum.animation_difangmove
						armature._nextAction = battle_enum.animation_difangmoving
					else
						-- 我方移动动画
						armature._actionIndex = animation_move
						armature._nextAction = animation_moving
					end
					armature._invoke = changeActionCallback
					armature:getAnimation():playWithIndex(armature._actionIndex)
					
					armature._playerMoveMusic = true
					if movedHeroCount == 1 then
						if __lua_project_id == __lua_king_of_adventure then
						else
							playEffectMusic(9999)
						end
					end
					-- armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
					-- armature:getAnimation():setFrameEventCallFunc(onFrameEvent)
					
				end
			end
			
			for i=1, fightSlotCount do
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))		
				local array = {}
				--array:addObject(CCActionInterval:create(1.2 * actionTimeSpeed))
				table.insert(array, cc.CallFunc:create(moveToNextBattleN))
				local seq = cc.Sequence:create(array)
				posTile:runAction(seq)
				
				cleanBuffEffect(posTile)
			end
	end
	
	moveUnionTeam = function()
		--rint("moveUnionTeam: 小队移动 ~~~~~~~~~~~~~~")
		local size = cc.Director:getInstance():getWinSize() --draw.size()
		local movedHeroCount = 0
		local moveTeamState = 0
		
		-- 设置初始位置	
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		
		local offsetYPVP = 0
		--local sPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_0_2")
		--local sxx, syy = sPosTile:getPosition()
		
		--local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
		--local xx2, yy2 = posTile2:getPosition()
		
		--local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
		--local xx, yy = posTile:getPosition()
		--offsetYPVP = yy - (size.height) + posTile:getContentSize().height/2
			
		--offsetYPVP = offsetYPVP - syy + teamTopScreenOffsetY + (yy - yy2) + posTile:getContentSize().height
		
		offsetYPVP = 200
		local mtime = offsetYPVP/moveFrameSpace * moveFrameTime
		
		local function moveOverCallback()
			-- MoveOver
			
			beganMoveTeam = 2
			for i=1, fightSlotCount do
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
				local armature = posTile._armature
				if armature ~= nil then
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					local _invoke = armature._invoke
					armature._isDeath = false
					armature._invoke = nil
					armature:getAnimation():playWithIndex(animation_move_end)
					armature._invoke = _invoke
				end
			end
			
			for i=1, fightSlotCount do
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))	
				local armature = posTile._armature
				if armature ~= nil then
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					local _invoke = armature._invoke
					armature._isDeath = false
					armature._invoke = nil
					armature:getAnimation():playWithIndex(animation_move_end)
					armature._invoke = _invoke
				end
			end
		end
		
		local function changeActionCallback(armatureBack)
			local armature = armatureBack
			if armature ~= nil then
				local actionIndex = armature._actionIndex
				if actionIndex == animation_moving then
					if armature._playerMoveMusic == true then
						if __lua_project_id == __lua_king_of_adventure then
						else
							playEffectMusic(9999)
						end
					end
					if moveTeamState == 0 then
						for i=1, 6 do
							local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
							--[[
							if posTile._isLive == true then
								-- 存在
								posTile._armature:stopAllActions()
							else
								posTile._isLive = true
								local tx, ty = posTile:getPosition()
								--posTile._dx = tx
								--posTile._dy = ty
								posTile:setPosition(cc.p(tx, ty - offsetYPVP))
								
								local tempArmature = posTile._armature
								if tempArmature ~= nil then
									tempArmature:setVisible(true)	
								end
								
								local array = CCArray:createWithCapacity(10)
								--array:addObject(CCActionInterval:create(1.2))
								array:addObject(cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, offsetYPVP)))
								local seq = CCSequence:create(array)
								posTile:runAction(seq)
							end
							--]]
							
							local tempArmature = posTile._armature
							if tempArmature ~= nil and (tempArmature._isNew == true or posTile._swap == true)then
								tempArmature._isNew = false
								posTile._swap = false
								local array = {}
								table.insert(array, cc.MoveTo:create(mtime * actionTimeSpeed, cc.p(posTile._dx, posTile._dy)))
								local seq = cc.Sequence:create(array)
								posTile:runAction(seq)
							end
						end
						
						for i=1, 6 do
							local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d",ofsetCount, i))		
							--[[
							if posTile._isLive == true then
								-- 存在
								posTile._armature:stopAllActions()
							else
								posTile._isLive = true
								
								if posTile._dy == nil then
									local tx, ty = posTile:getPosition()
									posTile._dx = tx
									posTile._dy = ty
								end
								
								posTile:setPosition(cc.p(posTile._dx, posTile._dy + offsetYPVP))
								
								local tempArmature = posTile._armature
								if tempArmature ~= nil then
									tempArmature:setVisible(true)	
								end
								
								local array = CCArray:createWithCapacity(10)
								--array:addObject(CCActionInterval:create(1.2))
								array:addObject(cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, -1*offsetYPVP)))
								local seq = CCSequence:create(array)
								posTile:runAction(seq)
							end
							--]]
							local tempArmature = posTile._armature
							if tempArmature ~= nil and tempArmature._isNew == true then
								tempArmature._isNew = false
								local array = {}
								table.insert(array, cc.MoveTo:create(mtime * actionTimeSpeed, cc.p(posTile._dx, posTile._dy)))
								local seq = cc.Sequence:create(array)
								posTile:runAction(seq)
							end
						end
						
						local xxx, yyy = BattleSceneClass._widgetBg:getPosition()
						local array = {}
						table.insert(array, cc.DelayTime:create(mtime * actionTimeSpeed))
						--array:addObject(cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, offsetY * -1)))
						table.insert(array, cc.CallFunc:create(moveOverCallback))
						local seq = cc.Sequence:create(array)
						BattleSceneClass._widgetBg:stopAllActions()
						BattleSceneClass._widgetBg:runAction(seq)
						
						moveTeamState = 1
					elseif beganMoveTeam == 2 then
						--armature._nextAction = animation_move_end
					end
				elseif actionIndex == animation_move_end then
					if beganMoveTeam == 2 then
						armature._nextAction = animation_standby
					end
				elseif actionIndex == animation_standby then
					movedHeroCount = movedHeroCount - 1
					armature._invoke = nil
					-- armature:getAnimation():setMovementEventCallFunc(nil_animationEventCallFunc)
					if movedHeroCount == 0 then
						if executeNextEvent(nil) == false then
							startBattleCallback()
						end
					end
				end
			end
		end
		
		local function moveToNextBattleN(sender)
			local armature = sender._armature
			if armature ~= nil then
				movedHeroCount = movedHeroCount + 1
				--[[
				-- 移动
				if armature._posTile._isLive == true then
					-- 存在
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					armature._invoke = changeActionCallback
					armature:getAnimation():playWithIndex(animation_move_end)
					--changeActionCallback(armature)
				else
					armature._actionIndex = animation_move
					armature._nextAction = animation_moving
					armature._invoke = changeActionCallback
					armature:getAnimation():playWithIndex(animation_move)
					armature._playerMoveMusic = true
					if movedHeroCount == 1 then
						playEffectMusic(9999)
					end
				end
				--]]
				
				if armature._camp == "1" then
					-- 敌方移动动画
					armature._actionIndex = battle_enum.animation_difangmove
					armature._nextAction = battle_enum.animation_difangmoving
				else
					-- 我方移动动画
					armature._actionIndex = animation_move
					armature._nextAction = animation_moving
				end
				armature._invoke = changeActionCallback
				armature:getAnimation():playWithIndex(armature._actionIndex)
				armature._playerMoveMusic = true
				if movedHeroCount == 1 then
					if __lua_project_id == __lua_king_of_adventure then
					else
						playEffectMusic(9999)
					end
				end
				
				-- armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
				-- armature:getAnimation():setFrameEventCallFunc(onFrameEvent)
				
			end
		end
		
		local movedTargetCount = 0
		for i=1, 6 do 
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))
			local armature = posTile._armature
			if armature ~= nil 
				and (armature._isNew == true or posTile._swap == true)
				then
				armature._invoke = nil
				armature:getAnimation():playWithIndex(animation_standby)
				
				local array = {}
				table.insert(array, cc.DelayTime:create(1.2 * actionTimeSpeed))
				table.insert(array, cc.CallFunc:create(moveToNextBattleN))
				local seq = cc.Sequence:create(array)
				posTile:runAction(seq)
				cleanBuffEffect(posTile)
				
				movedTargetCount = movedTargetCount + 1
			else
				posTile:setPosition(cc.p(posTile._dx, posTile._dy))
			end
		end
		
		for i=1, 6 do 
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))
			local armature = posTile._armature
			if armature ~= nil 
				and armature._isNew == true then
				armature._invoke = nil
				armature:getAnimation():playWithIndex(animation_standby)
				
				local array = {}
				table.insert(array, cc.DelayTime:create(1.2 * actionTimeSpeed))
				table.insert(array, cc.CallFunc:create(moveToNextBattleN))
				local seq = cc.Sequence:create(array)
				posTile:runAction(seq)
				cleanBuffEffect(posTile)
				
				movedTargetCount = movedTargetCount + 1
			else
				posTile:setPosition(cc.p(posTile._dx, posTile._dy))
			end
		end
		
		if movedTargetCount == 0 and executeNextEvent(nil) == false then
			startBattleCallback()
		end
		
		-- set background image positon
		--local xxx, yyy = BattleSceneClass._widgetBg:getPosition()
		--BattleSceneClass._widgetBg:setPosition(cc.p(xxx, yyy+(offsetYPVP)*-1))
	end
	
	
	-- 公会战斗开始移动
	battleMoveUnionTeam = function()
		--rint("battleMoveUnionTeam: 公会战斗开始移动 ~~~~~~~~~~~~~~")
		local size = cc.Director:getInstance():getWinSize() --draw.size()
		local movedHeroCount = 0
		local moveTeamState = 0
		lastTimeRoundBattleNumber = 0
		
		-- 设置初始位置	
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		
		local offsetYPVP = 0
		local sPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_0_2")
		local sxx, syy = sPosTile:getPosition()
		
		local posTile2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
		local xx2, yy2 = posTile2:getPosition()

		offsetYPVP = (yy2 - syy)/4 
		
		if battleMoveUnionTeamY == nil then
			battleMoveUnionTeamY = offsetYPVP
		end
		
		local moveUnionAttackTeamOffsetY = ((posTile2._dy - sPosTile._dy) - sPosTile:getContentSize().height)/2
		local mtime = moveUnionAttackTeamOffsetY / moveFrameSpace * moveFrameTime --offsetYPVP/moveFrameSpace * moveFrameTime
		
		
		local function moveOverCallback()
			--[[
			-- MoveOver
			local fight = _ED.union.union_counterpart_info.counterpart_fight
			local fightInfo = fight.fight_info[fight.currentBattleIndex]
			beganMoveTeam = 2
			for i=1, _ED.union.union_counterpart_info.counterpart_fight.fight_count do
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
				local armature = posTile._armature
				if armature ~= nil then
					-- 如果当前位置的面前id==0 则跳出
							
					lastTimeRoundBattleNumber = lastTimeRoundBattleNumber +1
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					local _invoke = armature._invoke
					armature._isDeath = false
					armature._invoke = nil
					armature:getAnimation():playWithIndex(animation_move_end)
				--	armature._invoke = _invoke
					
					--if zstring.tonumber(fightInfo[i][3]) ~= 0 then
						executeEffectSkillingUnion(posTile, armature._role._harmValue, true, battleMoveUnionTeamY)
						armature._role._harmValue = 0
					--end		
					
				end
			end
			
			for i=1, _ED.union.union_counterpart_info.counterpart_fight.fight_count do
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))		
				local armature = posTile._armature
				if armature ~= nil then
				
					lastTimeRoundBattleNumber = lastTimeRoundBattleNumber +1
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					local _invoke = armature._invoke
					armature._isDeath = false
					armature._invoke = nil
					armature:getAnimation():playWithIndex(animation_move_end)
					armature._invoke = _invoke
					
					--if zstring.tonumber(fightInfo[i][1]) ~= 0 then
						executeEffectSkillingUnion(posTile, armature._role._harmValue, false, battleMoveUnionTeamY)
						armature._role._harmValue = 0
					--end
					
				end
			end
			--]]
			
			beganMoveTeam = 2
			local fight = getUnionFightInfo()
			local fightInfo = fight.fight_info[fight.currentBattleIndex]
			for i=1, fightSlotCount do
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
				local armature = posTile._armature
				if armature ~= nil then
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					local _invoke = armature._invoke
					armature._isDeath = false
					armature._invoke = nil
					armature:getAnimation():playWithIndex(animation_move_end)
					armature._invoke = _invoke
				end
			end
			
			for i=1, fightSlotCount do
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))	
				local armature = posTile._armature
				if armature ~= nil then
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					local _invoke = armature._invoke
					armature._isDeath = false
					armature._invoke = nil
					armature:getAnimation():playWithIndex(animation_move_end)
					armature._invoke = _invoke
				end
			end
			
			
			local function drawDamageValue(backPad, _harmValue)
				local _widget = backPad
				local widgetSize = _widget:getContentSize()
				local drawString = _harmValue*-1
				local numberFilePath = "images/ui/number/baoji.png"
				local labelAtlas = cc.LabelAtlas:_create(""..drawString, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
				labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
				labelAtlas:setPosition(cc.p((widgetSize.width) / 2.0, widgetSize.height / 2.0)) 
				_widget:addChild(labelAtlas, kZOrderInMap_Hurt) 
				
				local array = {}
				-- 命中
				table.insert(array, cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 2))
				table.insert(array, cc.ScaleTo:create(3.5/60.0 * actionTimeSpeed, 1.0))
				
				table.insert(array, cc.DelayTime:create(30.0/60.0 * actionTimeSpeed))
				table.insert(array, cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2))
				table.insert(array, cc.CallFunc:create(removeFrameObjectFuncN))
				local seq = cc.Sequence:create(array)
				labelAtlas:runAction(seq)
	
				local armature = backPad._armature
				armature._hurtCount = 0
				armature._role._hp = armature._role._hp + drawString
				showRoleHP(armature)
				
				if armature._role._hp <= 0 then
					armature._isDeath = true
					if armature._posTile._camp == "1" then
						-- 敌人死亡
						if _ED.battleData.battle_init_type == fight_type_7 then
							local list =  zstring.split(_ED._scene_npc_id,",")
							local len = #list
							if current_scene_npc_id_length == nil then
								current_scene_npc_id_length = len
							elseif current_scene_npc_id_length < 1 then
								current_scene_npc_id_length = 1
							end
							local fightRewardBoutCount = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Label_19849_1")
							current_scene_npc_id_length = current_scene_npc_id_length - 1
							fightRewardBoutCount:setString(current_scene_npc_id_length.."/"..len)
						end
					end
				else
					armature._isDeath = false
					armature._isBack = true
				end
			end
			
			local function drawAttackEffect(backPad, pdx, pdy, effectIndex)
				local armatureEffect = createEffect(backPad, effectIndex, 0)
				local tempX, tempY  = backPad:getPosition()
				armatureEffect:setPosition(cc.p(tempX + backPad:getContentSize().width/2, tempY + backPad:getContentSize().height))
				armatureEffect._invoke = deleteEffectFile
				--armatureEffect._harmValue = _harmValue
			end
			--rint("移动完毕: moveOverCallback~~~~~~~~~~~~~~~~~~~~~~~" )
			local fight = getUnionFightInfo()
			local fightInfo = fight.fight_info[fight.currentBattleIndex]
			for i=1, fight.fight_count do
				if zstring.tonumber(fightInfo[i][1]) ~= 0 
					and zstring.tonumber(fightInfo[i][3]) ~= 0
				then
					local hero = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
					local master = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))	
					local effectIndex = 15
					if __lua_project_id == __lua_project_kofmusou then
						effectIndex = 125
					end
					--rint("开始依次检查撞击之后的结果~~~~~~~~~~~~~")
					-- 检测是否为退场状态
					if _ED.battleData.battle_init_type == fight_type_8 then
						hero._armature._isOff = false
						if zstring.tonumber(fightInfo[i][5]) == 2 then
							--rint("攻击方 离场~~~")
							hero._armature._isOff = true
							BattleSceneClass._unionBattleInfo.currentAttackNum = BattleSceneClass._unionBattleInfo.currentAttackNum -1
							draw.label(BattleSceneClass._uiLayer, "Label_24440", BattleSceneClass._unionBattleInfo.currentAttackNum.."/"..BattleSceneClass._unionBattleInfo.attackNum)
						end
						master._armature._isOff = false
						if zstring.tonumber(fightInfo[i][6]) == 2 then
							--rint("防守方 离场~~~")
							master._armature._isOff = true
							BattleSceneClass._unionBattleInfo.currentDefenseNum = BattleSceneClass._unionBattleInfo.currentDefenseNum -1
							draw.label(BattleSceneClass._uiLayer, "Label_24442", BattleSceneClass._unionBattleInfo.currentDefenseNum.."/"..BattleSceneClass._unionBattleInfo.defenseNum)
						end
					end
					
					drawAttackEffect(hero, 0, 0, effectIndex)
					drawDamageValue(hero, fightInfo[i][2])
					drawDamageValue(master, fightInfo[i][4])
					--检查死亡
					if _ED.battleData.battle_init_type == fight_type_8 then
						if hero._isDeath == true then	
							--rint("攻击方 死亡~~~")
							BattleSceneClass._unionBattleInfo.currentAttackNum = BattleSceneClass._unionBattleInfo.currentAttackNum -1
							draw.label(BattleSceneClass._uiLayer, "Label_24440", BattleSceneClass._unionBattleInfo.currentAttackNum.."/"..BattleSceneClass._unionBattleInfo.attackNum)
						end
						if master._isDeath == true then	
							--rint("防守方 死亡~~~")
							BattleSceneClass._unionBattleInfo.currentDefenseNum = BattleSceneClass._unionBattleInfo.currentDefenseNum -1
							draw.label(BattleSceneClass._uiLayer, "Label_24442", BattleSceneClass._unionBattleInfo.currentDefenseNum.."/"..BattleSceneClass._unionBattleInfo.defenseNum)
						end
					end
					--rint("当前剩余数~~~~~~~~~~~~~~~~~~~~")
					--rint("攻击方: " , BattleSceneClass._unionBattleInfo.currentAttackNum)
					--rint("防守方: " , BattleSceneClass._unionBattleInfo.currentDefenseNum)
				end
			end
			
		end
		
		
		
		local function changeActionCallback(armatureBack)
			local fight = getUnionFightInfo()
			local fightInfo = fight.fight_info[fight.currentBattleIndex]
			local armature = armatureBack
			if armature ~= nil then
				local actionIndex = armature._actionIndex
				if actionIndex == animation_moving then
					
					if armature._isDeath == true then
						return
					end
					if armature._isBack == true then
						return
					end
					
					if armature._playerMoveMusic == true then
						if __lua_project_id == __lua_king_of_adventure then
						else
							playEffectMusic(9999)
						end
					end
					if moveTeamState == 0 then
						--[[
						for i=1, _ED.union.union_counterpart_info.counterpart_fight.fight_count do

							local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))		
							local tx, ty = posTile:getPosition()
							local _dy = posTile._dy
							posTile:setPosition(cc.p(tx, _dy))
							
							local tempArmature = posTile._armature
							if tempArmature ~= nil then
								tempArmature:setVisible(true)	
							end
							
							-- 如果当前位置的面前id==0 则跳出
							--if zstring.tonumber(fightInfo[i][3]) ~= 0 then
								local array = CCArray:createWithCapacity(10)
								--array:addObject(CCActionInterval:create(1.2))
								array:addObject(cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, battleMoveUnionTeamY)))
								local seq = CCSequence:create(array)
								posTile:runAction(seq)
							--end
							
						end
						
						for i=1, _ED.union.union_counterpart_info.counterpart_fight.fight_count do
							
							local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))		
							
							local tx, ty = posTile:getPosition()
							--posTile:setPosition(cc.p(tx, ty + offsetYPVP))
							
							local tempArmature = posTile._armature
							if tempArmature ~= nil then
								tempArmature:setVisible(true)	
							end
							
							if zstring.tonumber(fightInfo[i][1]) ~= 0 then
								local array = CCArray:createWithCapacity(10)
								--array:addObject(CCActionInterval:create(1.2))
								array:addObject(cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, -1*battleMoveUnionTeamY)))
								local seq = CCSequence:create(array)
								posTile:runAction(seq)
							end
							
						end
						--]]
						
						--rint("开始移动~~~~ moveTeamState == 0")
						for i=1, 6 do
							local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
							
							local tempArmature = posTile._armature
							if tempArmature ~= nil and fightInfo[i]~=nil and fightInfo[i][3] ~= "0" then
								local array = {}
								table.insert(array, cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, moveUnionAttackTeamOffsetY)))
								local seq = cc.Sequence:create(array)
								posTile:runAction(seq)
							end
						end
						
						for i=1, 6 do
							local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d",ofsetCount, i))		
							
							local tempArmature = posTile._armature
							if tempArmature ~= nil and fightInfo[i]~=nil and fightInfo[i][1] ~= "0" then
								local array = {}
								table.insert(array, cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, -1 * moveUnionAttackTeamOffsetY)))
								local seq = cc.Sequence:create(array)
								posTile:runAction(seq)
							end
						end
						
						local xxx, yyy = BattleSceneClass._widgetBg:getPosition()
						local array = {}
						table.insert(array, cc.DelayTime:create(mtime * actionTimeSpeed))
						--table.insert(array, cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, offsetY * -1)))
						table.insert(array, cc.CallFunc:create(moveOverCallback))
						local seq = cc.Sequence:create(array)
						BattleSceneClass._widgetBg:stopAllActions()
						BattleSceneClass._widgetBg:runAction(seq)
						
						moveTeamState = 1
					elseif beganMoveTeam == 2 then
						--armature._nextAction = animation_move_end
					end
				elseif actionIndex == animation_move_end then
					--rint("移动结束~~~~ animation_move_end")
					local function roleMoveOverCallbackN(sender)
						sender._armature._isDeathed = sender._armature._isDeath;
						sender._armature._isBacked = sender._armature._isBack;
						sender._armature._isDeath = false
						sender._armature._isBack = false
						sender._armature._isOff = false
						
						sender._armature._actionIndex = animation_move_end
						sender._armature._nextAction = animation_move_end
						local _invoke = sender._armature._invoke
						sender._armature._invoke = nil
						sender._armature:getAnimation():playWithIndex(animation_move_end)
						sender._armature._invoke = _invoke
					end
					
					if armature._isOff == true then
						--rint("离场~~~~~~_isOff")
						if armature._camp == "1" then
							-- 敌方移动动画
							armature._nextAction = battle_enum.animation_difangmove
						else
							-- 我方移动动画
							armature._nextAction = animation_move
						end

						local posTile = armature._posTile
						if posTile ~= nil then
							posTile:setPosition(cc.p(posTile._dx, posTile._dy))
							local array = {}
							table.insert(array, cc.MoveTo:create(mtime * actionTimeSpeed, cc.p(posTile._dx, posTile._dy + attackUnionTagetOffsetY * (posTile._camp == "1" and 1 or -1))))
							table.insert(array, cc.CallFunc:create(roleMoveOverCallbackN))
							local seq = cc.Sequence:create(array)
							posTile:runAction(seq)
						end
						return
					end
					
					if armature._isDeath == true then
						--rint("死亡~~~~~~_isDeath")
						if armature._camp == "1" then
							-- 敌方移动动画
							armature._nextAction = battle_enum.animation_difangmove
						else
							-- 我方移动动画
							armature._nextAction = animation_move
						end
						local posTile = armature._posTile
						if posTile ~= nil then
							posTile:setPosition(cc.p(posTile._dx, posTile._dy))
							
							local box = cc.LayerColor:create(cc.c4b(0,0,0,0))-->定义一个层的对象，颜色为红色
							box:setAnchorPoint(cc.p(0.5,0.5))-->设置对象box的锚点
							box:setContentSize(cc.size(2, 2))-->设置对象box的大小
							--box:ignoreAnchorPointForPosition(false)-->定义box对象的宽高是boxSize的大小
							box:setPosition(cc.p(posTile._dx+posTile:getContentSize().width/2, posTile._dy+posTile:getContentSize().height/2))-->设置box对象的坐标
							--layer:addChild(box);-->将box对象添加到层layer上
							posTile:getParent():addChild(box)
							armature:setPosition(cc.p(posTile:getContentSize().width/(-4), posTile:getContentSize().height/(-4)))-->设置box对象的坐标
							armature:retain()
							armature:removeFromParent(false)
							box._armature = armature
							box:addChild(armature)
							armature:release()
							
							local array = {}
							table.insert(array, cc.MoveTo:create(mtime * actionTimeSpeed, cc.p(posTile._dx, posTile._dy + attackUnionTagetOffsetY * (posTile._camp == "1" and 1 or -1))))
							table.insert(array, cc.CallFunc:create(roleMoveOverCallbackN))
							local seq = cc.Sequence:create(array)
							box:runAction(seq)
							box:runAction(cc.RotateBy:create(0.5, 360))
						end
						return
					end
					if armature._isBack == true then
						--rint("归位~~~~~~_isBack")
						if armature._camp == "1" then
							-- 敌方移动动画
							armature._nextAction = battle_enum.animation_difangmove
						else
							-- 我方移动动画
							armature._nextAction = animation_move
						end
						local posTile = armature._posTile
						if posTile ~= nil then
							local array = {}
							table.insert(array, cc.MoveTo:create(mtime * actionTimeSpeed, cc.p(posTile._dx, posTile._dy)))
							table.insert(array, cc.CallFunc:create(roleMoveOverCallbackN))
							local seq = cc.Sequence:create(array)
							posTile:runAction(seq)
						end
						return
					end
					
					if beganMoveTeam == 2 then
						armature._nextAction = animation_standby
					end
				elseif actionIndex == animation_move then
					--rint("移动中~~~animation_move")
					-- 我方移动动画
					armature._nextAction = animation_moving
				elseif actionIndex == animation_standby then
					--rint("移动停下来了~~~animation_standby")
					movedHeroCount = movedHeroCount - 1
					armature._invoke = nil
					
					if armature._isDeathed == true then
						armature._isDeathed = false;
						armature._isDeath = false
						armature._posTile._armature = nil
						tolua.cast(armature, "CCNode"):removeFromParent(true)
						cleanBuffEffect(armature._posTile, true)
					else
						armature._isDeath = false
						armature._isBack = false
						armature._isDeathed = false
						armature._isBacked = false
					end
					if movedHeroCount == 0 then
						if executeNextEvent(nil) == false then
							--startBattleCallback()
							initNextRoundBattle()
						end
					end
				end
			end
		end
		
		local function moveToNextBattleN(sender)
			local armature = sender._armature
			if armature ~= nil then
				movedHeroCount = movedHeroCount + 1
				-- 移动
				if armature._camp == "1" then
					-- 敌方移动动画
					armature._actionIndex = battle_enum.animation_difangmove
					armature._nextAction = battle_enum.animation_difangmoving
				else
					-- 我方移动动画
					armature._actionIndex = animation_move
					armature._nextAction = animation_moving
				end
				armature._invoke = changeActionCallback
				armature:getAnimation():playWithIndex(armature._actionIndex)
				
				armature._playerMoveMusic = true
				if movedHeroCount == 1 then
					if __lua_project_id == __lua_king_of_adventure then
					else
						playEffectMusic(9999)
					end
				end
				
			end
		end
	
		local fight = getUnionFightInfo()
		local fightInfo = fight.fight_info[fight.currentBattleIndex]
		for i=1, 6 do 
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))
			local armature = posTile._armature
			if armature ~= nil and fightInfo[i]~=nil and fightInfo[i][3] ~= "0" then
				armature._invoke = nil
				armature:getAnimation():playWithIndex(animation_standby)
				
				local array = {}
				table.insert(array, cc.DelayTime:create(1.2 * actionTimeSpeed))
				table.insert(array, cc.CallFunc:create(moveToNextBattleN))
				local seq = cc.Sequence:create(array)
				posTile:runAction(seq)
				cleanBuffEffect(posTile)
			else
				
			end
		end
		
		for i=1, 6 do 
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))
			local armature = posTile._armature
			if armature ~= nil and fightInfo[i]~=nil and fightInfo[i][1] ~= "0" then
				armature._invoke = nil
				armature:getAnimation():playWithIndex(animation_standby)
				
				local array = {}
				table.insert(array, cc.DelayTime:create(1.2 * actionTimeSpeed))
				table.insert(array, cc.CallFunc:create(moveToNextBattleN))
				local seq = cc.Sequence:create(array)
				posTile:runAction(seq)
				cleanBuffEffect(posTile)
			else
				
			end
		end
	end
	
	-----公会战斗后撤
	battleRetreatMoveUnionTeam = function(armature, isHero, offsetYPVP)
		local size = cc.Director:getInstance():getWinSize() --draw.size()
		local movedHeroCount = 0
		local moveTeamState = 0

		local mtime = 1--offsetYPVP/moveFrameSpace * moveFrameTime
		local function moveOverCallback()
			-- MoveOver
			beganMoveTeam = 2
			if isHero then
				local posTile = armature._posTile
				if armature ~= nil then
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					local _invoke = armature._invoke
					armature._isDeath = false
					armature._invoke = nil
					armature:getAnimation():playWithIndex(animation_move_end)
					--armature._invoke = _invoke
					initNextRoundBattle()
				end
			else
				local posTile = armature._posTile
				if armature ~= nil then
					armature._actionIndex = animation_move_end
					armature._nextAction = animation_move_end
					local _invoke = armature._invoke
					armature._isDeath = false
					armature._invoke = nil
					armature:getAnimation():playWithIndex(animation_move_end)
					--armature._invoke = _invoke
					initNextRoundBattle()
				end
			end	
		end
		
		local function changeActionCallback(armatureBack)
			local armature = armatureBack
			if armature ~= nil then
				local actionIndex = armature._actionIndex
				if actionIndex == animation_moving then
					if armature._playerMoveMusic == true then
						if __lua_project_id == __lua_king_of_adventure then
						else
							playEffectMusic(9999)
						end
					end
					if moveTeamState == 0 then
						if isHero then
							local posTile = armature._posTile	
							local tx, ty = posTile:getPosition()
							local tempArmature = posTile._armature
							if tempArmature ~= nil then
								tempArmature:setVisible(true)	
							end
							local array = {}
							table.insert(array, cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, -1*offsetYPVP)))
							local seq = cc.Sequence:create(array)
							posTile:runAction(seq)
						else
							local posTile = armature._posTile	
							local tx, ty = posTile:getPosition()
							local tempArmature = posTile._armature
							if tempArmature ~= nil then
								tempArmature:setVisible(true)	
							end
							local array = {}
							table.insert(array, cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, offsetYPVP)))
							local seq = cc.Sequence:create(array)
							posTile:runAction(seq)
						end
						local xxx, yyy = BattleSceneClass._widgetBg:getPosition()
						local array = {}
						table.insert(array, cc.DelayTime:create(mtime * actionTimeSpeed))
						table.insert(array, cc.CallFunc:create(moveOverCallback))
						local seq = cc.Sequence:create(array)
					--	BattleSceneClass._widgetBg:stopAllActions()
					--	BattleSceneClass._widgetBg:runAction(seq)
						armature:stopAllActions()
						armature:runAction(seq)
						moveTeamState = 1
					elseif beganMoveTeam == 2 then
						--armature._nextAction = animation_move_end
					end
				elseif actionIndex == animation_move_end then
					if beganMoveTeam == 2 then
						armature._nextAction = animation_standby
					end
				elseif actionIndex == animation_standby then
					movedHeroCount = movedHeroCount - 1
					armature._invoke = nil
					-- armature:getAnimation():setMovementEventCallFunc(nil_animationEventCallFunc)
					if movedHeroCount == 0 then
						if executeNextEvent(nil) == false then
							--startBattleCallback()
						end
					end
				end
			end
		end
		
		local function moveToNextBattleN(sender)
			local armature = sender._armature
			if armature ~= nil then
				movedHeroCount = movedHeroCount + 1
				-- 移动
				if armature._camp == "1" then
					-- 敌方移动动画
					armature._actionIndex = battle_enum.animation_difangmove
					armature._nextAction = battle_enum.animation_difangmoving
				else
					-- 我方移动动画
					armature._actionIndex = animation_move
					armature._nextAction = animation_moving
				end
				armature._invoke = changeActionCallback
				armature:getAnimation():playWithIndex(armature._actionIndex)
				armature._playerMoveMusic = true
				if movedHeroCount == 1 then
					if __lua_project_id == __lua_king_of_adventure then
					else
						playEffectMusic(9999)
					end
				end
				-- armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
				-- armature:getAnimation():setFrameEventCallFunc(onFrameEvent)
			end
		end
		
		local posTile = armature._posTile
		local array = {}
		table.insert(array, cc.DelayTime:create(1.2 * actionTimeSpeed))
		table.insert(array, cc.CallFunc:create(moveToNextBattleN))
		local seq = cc.Sequence:create(array)
		posTile:runAction(seq)
		cleanBuffEffect(posTile)
	end
	
	-----公会战斗死亡
	battleDieMoveUnionTeam = function(armature, isHero, offsetYPVP)
		local size = cc.Director:getInstance():getWinSize()
		local movedHeroCount = 0
		local moveTeamState = 0

		local mtime = 1--offsetYPVP/moveFrameSpace * moveFrameTime
		
		local function moveOverCallback()
			-- MoveOver
			local posTile = armature._posTile
			posTile._isLive = false
			posTile:stopAllActions()

			posTile:setRotation(0)
			--posTile:stopAllActions()
			
			--particleSystem:setRotatePerSecond(45)
			--particleSystem:setRotatePerSecondVar(0)
		
			
			armature._isDeath = true
			armature._actionIndex = animation_standby
			armature._nextAction = animation_standby
			armature._invoke = nil
			armature:getAnimation():playWithIndex(animation_standby)
			--armature:setVisible(false)
			
			local posTile = armature._posTile
			posTile._armature = nil
			armature:removeFromParent(true)
			cleanBuffEffect(armature._posTile, true)
			initNextRoundBattle()
		end

		local function moveToNextBattleN(sender)
			local armature = sender._armature
			if armature ~= nil then
				if isHero == true then
					local posTile = armature._posTile	
					local tx, ty = posTile:getPosition()
					local tempArmature = posTile._armature
					if tempArmature ~= nil then
						tempArmature:setVisible(true)	
					end
					local dieMoveBy = size.height*-1
					local array = {}
					local action1 = cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, dieMoveBy))
					local action2 = cc.Repeat:create(cc.RotateBy:create(0.5, 360),-1)
					table.insert(array, cc.Sequence:createWithTwoActions(action1, action2))
					local seq = cc.Sequence:create(array)
					posTile:runAction(seq)
				else
					local posTile = armature._posTile	
					local tx, ty = posTile:getPosition()
					local tempArmature = posTile._armature
					if tempArmature ~= nil then
						tempArmature:setVisible(true)	
					end
					local dieMoveBy = size.height
					--local array = CCArray:createWithCapacity(10)
					local action1 = cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(0, dieMoveBy))
					local action2 = cc.Repeat:create(cc.RotateBy:create(0.5, 360),-1)
					--array:addObject(CCSequence:createWithTwoActions(action1, action2))
					--local seq = CCSequence:create(array)
					posTile:runAction(cc.Sequence:createWithTwoActions(action1, action2))
				end
				local xxx, yyy = BattleSceneClass._widgetBg:getPosition()
				local array = {}
				table.insert(array, cc.DelayTime:create(mtime * actionTimeSpeed))
				table.insert(array, cc.CallFunc:create(moveOverCallback))
				local seq = cc.Sequence:create(array)
			--	BattleSceneClass._widgetBg:stopAllActions()
			--	BattleSceneClass._widgetBg:runAction(seq)
				armature:stopAllActions()
				armature:runAction(seq)
			end
		end
		
		local posTile = armature._posTile
		local array = {}
		table.insert(array, cc.DelayTime:create(1.2 * actionTimeSpeed))
		table.insert(array, cc.CallFunc:create(moveToNextBattleN))
		local seq = cc.Sequence:create(array)
		posTile:runAction(seq)
		cleanBuffEffect(posTile)
	end
	
	swapPosTileUnion = function (oldSiteIndex, newSiteIndex)
		--rint("我要交换的: ",oldSiteIndex, newSiteIndex )
		local oldPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", oldSiteIndex))
		local newPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", newSiteIndex))
		local ox = oldPosTile._dx
		local oy = oldPosTile._dy
		local nx = newPosTile._dx
		local ny = newPosTile._dy
		
		-- newPosTile:runAction(cc.MoveBy:create(0.5, cc.p(ox-nx, 0)))
		-- oldPosTile:runAction(cc.MoveBy:create(0.5, cc.p(nx-ox, 0)))
		
		newPosTile:setPosition(cc.p(ox,oy))
		--oldPosTile:setPosition(cc.p(nx,ny))
		
		oldPosTile._dx = newPosTile._dx
		oldPosTile._dy = newPosTile._dy
		newPosTile._dx = ox
		newPosTile._dy = oy
		
		oldPosTile._swap = true
		
		newPosTile:setName(string.format("Panel_0_%d", oldSiteIndex))
		oldPosTile:setName(string.format("Panel_0_%d", newSiteIndex))
	end
	
	local function createUnionBattleObject(roundIndex)
		local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		local fight = getUnionFightInfo()
		local currentInfo = fight.fight_info[roundIndex]
		
		for i= 1 , fight.fight_count do --循环( 2v2 3v3 )战斗数组,这一回合中每个战斗次序
			local currId = zstring.tonumber(currentInfo[i][1])
			if currId ~= 0 and zstring.tonumber(currentInfo[i][3]) ~= 0 then
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))
				if posTile._armature == nil then
					for m=1, 3 do
						local mposTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", m))
						if mposTile._armature ~= nil and ""..mposTile._armature._role._id == ""..currId then
							swapPosTileUnion(m, i)
						end
					end
				end
			end
		end
		
		for i= 1 , fight.fight_count do --循环( 2v2 3v3 )战斗数组,这一回合中每个战斗次序
			if zstring.tonumber(currentInfo[i][1]) ~= 0 then
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))
				if posTile._armature == nil then
					BattleSceneClass._hero_index = 0
					for iv, v in pairs(_ED.battleData._heros) do
						if currentInfo[i][1] == v._id then
							initHero(i, v._head, v._quality, v)
							
							posTile:setPosition(cc.p(posTile._dx, posTile._dy - attackUnionTagetOffsetY))
						end
					end
				end
			end
			if zstring.tonumber(currentInfo[i][3]) ~= 0 then
				local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, i))
				if posTile._armature == nil then
					for i2, v2 in pairs(_ED.battleData._armys[_ED.battleData._currentBattleIndex]._data) do
						if currentInfo[i][3] == v2._id then
							initMaster(ofsetCount, i, v2._head, v2._quality, v2)
							posTile:setPosition(cc.p(posTile._dx, posTile._dy + attackUnionTagetOffsetY))
						end
					end
				end
			end
		end
	end
	
	--回合结束
	initNextRoundBattle = function()
		local fight = getUnionFightInfo()
		local lastBattleIndex = fight.currentBattleIndex
		fight.currentBattleIndex = fight.currentBattleIndex +1
		if fight.currentBattleIndex > fight.round_count then
			-- 结束了
			if _ED.attackData == nil then
				_ED.attackData = {}
			end
			_ED.attackData.isWin = ""..fight.result
			fightOverFunc()
			return
		end
		createUnionBattleObject(fight.currentBattleIndex)
		-- 创建新的对象
		-- 设置位置
		-- 移动位置
		-- 开始回合调用
		moveUnionTeam()
	end
	
	local function ViceComeIn(item)
		-- Panel_2457 	--副队长图片
		-- Label_2464	--生命
		-- Label_2466	--物防
		-- Label_2468	--攻击
		-- Label_2469	--灵防
		-- vice_captain_mould
		if item == 1 and tonumber(_ED.battleData.viceId) ~= 0 then
			draw.load("interface/vice_captain_battle.json")
			local viceCell = draw.create("Panel_2456")
			draw.delete()
			local viceId = _ED.battleData.viceId
			local data = elementAt(viceCaptainMould, viceId)
			local vicePic = data:atos(vice_captain_mould.all_icon)
			draw.image(viceCell, "Panel_2457", string.format("images/face/big_head/big_head_%s.png", vicePic))
			if _ED.battleData.attribute ~= "" and _ED.battleData.attribute ~= " " then
				draw.label(viceCell, "Label_2464", _ED.battleData.Onelife)
				draw.label(viceCell, "Label_2466", _ED.battleData.Onephysical_defence)
				draw.label(viceCell, "Label_2468", _ED.battleData.Oneattack)
				draw.label(viceCell, "Label_2469", _ED.battleData.Oneskill_defence)
			else
				draw.label(viceCell, "Label_2464", "0")
				draw.label(viceCell, "Label_2466", "0")
				draw.label(viceCell, "Label_2468", "0")
				draw.label(viceCell, "Label_2469", "0")
			end
			local position = cc.p(ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_2"):getPosition())
			viceCell:setPosition(position)
			-- viceCell:setOpacity(0)
			return viceCell
		elseif item == 2 and tonumber(_ED.battleData.otherViceId) ~= 0 then
			draw.load("interface/vice_captain_battle.json")
			local viceCell = draw.create("Panel_2456")
			draw.delete()
			local viceId = _ED.battleData.otherViceId
			local data = elementAt(viceCaptainMould, viceId)
			local vicePic = data:atos(vice_captain_mould.all_icon)
			draw.image(viceCell, "Panel_2457", string.format("images/face/big_head/big_head_%s.png", vicePic))
			if _ED.battleData.attribute ~= "" and _ED.battleData.attribute ~= " " then
				draw.label(viceCell, "Label_2464", _ED.battleData.Twolife)
				draw.label(viceCell, "Label_2466", _ED.battleData.Twophysical_defence)
				draw.label(viceCell, "Label_2468", _ED.battleData.Twoattack)
				draw.label(viceCell, "Label_2469", _ED.battleData.Twoskill_defence)
			else
				draw.label(viceCell, "Label_2464", "0")
				draw.label(viceCell, "Label_2466", "0")
				draw.label(viceCell, "Label_2468", "0")
				draw.label(viceCell, "Label_2469", "0")
			end
			local position = cc.p(ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_2"):getPosition())
			viceCell:setPosition(position)
			-- viceCell:setOpacity(0)
			return viceCell
		end
	end
	
	-- 战斗回合开始
	startBattleCallback = function()
		--> debug.log(true, "战斗回合开始")
		-- 战斗开始了~~~~~~~~~~~~" ,os.time())
		-- 处理回合开始的动画
		local battleName = "".._ED.battleData._armys[_ED.battleData._currentBattleIndex]._battleName
		if _ED.battleData.battle_init_type == fight_type_7 then
			draw.setVisible(BattleSceneClass._uiLayer, "Panel_21991", true)
			-- local action1 = ActionManager:shareManager():getActionByName("legion_fighting_ui.json","Animation0")
			-- action1:play()
			-- action1:setLoop(false)
			BattleSceneClass._shakeAction:gotoFrameAndPlay(0, BattleSceneClass._shakeAction:getDuration(), false)
			ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_21991"):setOpacity(255)
			local nIndex = _ED.union.union_counterpart_info.counterpart_fight.currentBattleIndex
			draw.number(BattleSceneClass._uiLayer, "LabelAtlas_21994", ""..nIndex)
		else
			if battleName ~= " " and battleName ~= "?" then
				if __lua_project_id == __lua_king_of_adventure then
					if _ED.battleData._currentBattleIndex > 1 then
					else
						ccui.Helper:seekWidgetByName(BattleSceneClass._widget, "Panel_2"):setVisible(true)
						local battleRound = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_2")
						
						-- local armature = draw.createEffect("effect_100", "images/ui/effice/effect_100.ExportJson", battleRound, 1, 100)
						local armature = draw.createEffect("effice_7", "effect/effice_97.ExportJson", battleRound, 1, 100)
					end
				else
					ccui.Helper:seekWidgetByName(BattleSceneClass._widget, "Panel_2"):setVisible(true)
					-- local action1 = ActionManager:shareManager():getActionByName("battle_UI.json","Animation1")
					-- action1:play()
					-- action1:setLoop(false)
					local action1 = csb.createTimeline("battle/battle_UI.csb")
					BattleSceneClass._widget:getParent():runAction(action1)
					action1:gotoFrameAndPlay(0, action1:getDuration(), false)
				
					ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_2"):setOpacity(255)
					-- draw.label(BattleSceneClass._uiLayer, "Label_10876", battleName)
					-- draw.number(BattleSceneClass._uiLayer, "LabelAtlas_10878", "".._ED.battleData._currentBattleIndex)
					-- draw.number(BattleSceneClass._uiLayer, "LabelAtlas_10879", "".._ED.battleData.battle_total_count)
					ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_11"):setBackGroundImage(string.format("images/ui/battle/boshu_%d.png", tonumber(_ED.battleData._currentBattleIndex)))
					ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_12"):setBackGroundImage(string.format("images/ui/battle/boshu_%d.png", tonumber(_ED.battleData.battle_total_count)))
				end
			end
		end
		
		local function startBattleFunc()
			-- 请求执行战斗开始的事件
            --[[
			if _ED.battleData.battle_init_type >= 10 or 
				executeMission(mission_mould_battle, touch_off_mission_start_battle, 
					"".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil, true) == false then
				startBattle()
			end
            --]]

            if _ED.battleData.battle_init_type >= 10 or 

				executeMissionExt(mission_mould_battle, touch_off_mission_start_battle, 
					"".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil, true) == false then
					
				if __lua_project_id == __lua_project_bleach or __lua_project_id == __lua_project_all_star then
					if tonumber(_ED.battleData.battle_init_type) == 7 or tonumber(_ED.battleData.battle_init_type) == 8 then
						startBattle()
				    else
						local viceCell = ViceComeIn(1)
						local viceTwoCell = ViceComeIn(2)
						if viceCell ~= nil then
							BattleSceneClass._uiLayer:addChild(viceCell)
							local function removeArray(sender)
								viceCell:removeFromParent(true)
								if viceTwoCell == nil then
									startBattle()
								end
							end
							local function startPlays()
								for i, v in pairs(_ED.battleData._heros) do
									local effectPad = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", v._pos))
									local armature = draw.createEffect("effice_97", "effect/effice_97.ExportJson", effectPad, 1, 100,0.5)
								end
							end
							local size = cc.Director:getInstance():getWinSize()
							local posx, posy = viceCell:getPosition()
							viceCell:setPosition(cc.p(posx-size.width, posy))
							local array = {}
							table.insert(array, cc.MoveTo:create(0.2,cc.p(posx,posy)))
							table.insert(array, cc.DelayTime:create(1))
							table.insert(array, cc.MoveTo:create(0.2,cc.p(posx+size.width,posy)))
							table.insert(array, cc.CallFunc:create(startPlays))
							table.insert(array, cc.DelayTime:create(1))
							table.insert(array, cc.CallFunc:create(removeArray))
							local seq = cc.Sequence:create(array)
							viceCell:runAction(seq)
						end
						
						if viceTwoCell ~= nil then
							BattleSceneClass._uiLayer:addChild(viceTwoCell)
							
							local function removeArrays(sender)
								viceTwoCell:removeFromParent(true)
								startBattle()
							end
							local function startPlay()
								for i, v in pairs(_ED.battleData._armys[_ED.battleData._currentBattleIndex]._data) do
									local effectPad = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_3_%d", v._pos))
									local armatures = draw.createEffect("effice_97", "effect/effice_97.ExportJson", effectPad, 1, 100,0.5)
								end
							end
							local size = cc.Director:getInstance():getWinSize()
							local posx, posy = viceTwoCell:getPosition()
							viceTwoCell:setPosition(cc.p(posx+size.width, posy))
							local temb = {}
							table.insert(array, cc.DelayTime:create(2.5))
							table.insert(array, cc.MoveTo:create(0.2,cc.p(posx,posy)))
							table.insert(array, cc.DelayTime:create(0.8))
							table.insert(array, cc.MoveTo:create(0.2,cc.p(posx-size.width,posy)))
							table.insert(array, cc.CallFunc:create(startPlay))
							table.insert(array, cc.DelayTime:create(1))
							table.insert(array, cc.CallFunc:create(removeArrays))
							local seqw = cc.Sequence:create(temb)
							viceTwoCell:runAction(seqw)
						end
						
						if viceCell == nil and viceTwoCell == nil then
							startBattle()
						end
					end	
					
				else
					startBattle()
				end
			end
		end
		
		local function responseFightCallback()
			local array = {}
			if _ED.battleData.battle_init_type >= 10 or _ED.battleData.battle_init_type == 2 or _ED.battleData.battle_init_type == 5 or _ED.battleData.battle_init_type == 6 then
				table.insert(array, cc.FadeOut:create(0))
			else
				table.insert(array, cc.DelayTime:create(1))
				table.insert(array, cc.FadeOut:create(0.5))
			end
			table.insert(array, cc.CallFunc:create(startBattleFunc))
			--array:addObject(CCHide:create())
			local seq = cc.Sequence:create(array)
			if _ED.battleData.battle_init_type == fight_type_7 then
				ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_21991"):runAction(seq)
			elseif _ED.battleData.battle_init_type == fight_type_8  then
				startBattleFunc()
			else
				ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Panel_2"):runAction(seq)
			end	
		end

		local responseEnvironmentFightCallback = nil
		responseEnvironmentFightCallback = function(response)
			-- local pNode = tolua.cast(_cObj, "CCNode")
			-- local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
			-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
				-- responseFightCallback()
			-- else
				-- local statusCode = pDataInterpreter:getStatusCode()
				-- if draw.isLogin == false then 
					
				-- elseif statusCode ~= 200 and statusCode ~= 0 then
					-- require "script/transformers/home/TimeoutChaining"
					-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["TimeoutChainingClass"])
					-- return
				-- end
			
			-- end
			
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				responseFightCallback()
			else
				-- local statusCode = pDataInterpreter:getStatusCode()
				-- if draw.isLogin == false then 
					
				-- elseif statusCode ~= 200 and statusCode ~= 0 then
					-- require "script/transformers/home/TimeoutChaining"
					-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["TimeoutChainingClass"])
					-- return
				-- end
			end
		end
		
		local function requestEnvironmentFightCallback(sender, eventType)	
			if eventType == ccui.TouchEventType.ended then
				if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
					app.load("client.battle.report.BattleReport")
					local fightModule = FightModule:new()
					fightModule:doFight()
					
					responseEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
				else
					protocol_command.environment_fight.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0".."\r\n".."0"
					-- Sender(protocol_command.environment_fight.code, nil, nil, nil, nil, responseEnvironmentFightCallback, 0)
					NetworkManager:register(protocol_command.environment_fight.code, nil, nil, nil, nil, responseEnvironmentFightCallback, false, nil)
				end
			end
		end
		
		responseBattleFieldInit = function()
			if zstring.tonumber(_ED._login_status) == 0 then 
				requestEnvironmentFightCallback(nil, ccui.TouchEventType.ended)
			else
				local _oldBattleIndex = _ED.battleData._currentBattleIndex
				local _currBattleIndex = _ED.battleData._currentBattleIndex
				local responseCheckEnvironmentFightCallback = nil
				responseCheckEnvironmentFightCallback = function(_cObj, _tJsd)
					-- local pNode = tolua.cast(_cObj, "CCNode")
					-- local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
					-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
						-- _oldBattleIndex = _oldBattleIndex - 1
						-- if _oldBattleIndex > 0 then
							-- timer send
							-- local scheduler = cc.Director:getInstance():getScheduler()
							-- local responseEnvironmentFightEntry = nil
							-- local function responseEnvironmentFightStep()
								-- if responseEnvironmentFightEntry ~= nil then
									-- scheduler:unscheduleScriptEntry(responseEnvironmentFightEntry)
									-- responseEnvironmentFightEntry = nil
								-- end
								-- if currentRoundIndex <=0 then
									-- protocol_command.environment_fight.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0".."\r\n".."0"
									-- Sender(protocol_command.environment_fight.code, nil, nil, nil, nil, responseCheckEnvironmentFightCallback, 0)
									-- NetworkManager:register(protocol_command.environment_fight.code, nil, nil, nil, nil, responseCheckEnvironmentFightCallback, false, nil)
								-- end
							-- end
							-- responseEnvironmentFightEntry = scheduler:scheduleScriptFunc(responseEnvironmentFightStep, 0.1, false)
						-- else
						-- local scheduler2 = cc.Director:getInstance():getScheduler()
							-- local responseEnvironmentFightEntry2 = nil
							-- local function responseEnvironmentFightStep2()
								-- if responseEnvironmentFightEntry2 ~= nil then
									-- scheduler2:unscheduleScriptEntry(responseEnvironmentFightEntry2)
									-- responseEnvironmentFightEntry2 = nil
								-- end
								-- _ED.battleData._currentBattleIndex = _currBattleIndex
								-- requestEnvironmentFightCallback(nil, ccui.TouchEventType.ended)
							-- end
							
							-- responseEnvironmentFightEntry2 = scheduler2:scheduleScriptFunc(responseEnvironmentFightStep2, 0.1, false)
						-- end
					-- else
						
					-- end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_oldBattleIndex = _oldBattleIndex - 1
						if _oldBattleIndex > 0 then
							-- timer send
							local scheduler = cc.Director:getInstance():getScheduler()
							local responseEnvironmentFightEntry = nil
							local function responseEnvironmentFightStep(dt)
								if responseEnvironmentFightEntry ~= nil then
									scheduler:unscheduleScriptEntry(responseEnvironmentFightEntry)
									responseEnvironmentFightEntry = nil
								end
								if currentRoundIndex <=0 then
									if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
										app.load("client.battle.report.BattleReport")
										local fightModule = FightModule:new()
										fightModule:doFight()
										
										responseCheckEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
									else
										protocol_command.environment_fight.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0".."\r\n".."0"
										-- Sender(protocol_command.environment_fight.code, nil, nil, nil, nil, responseCheckEnvironmentFightCallback, 0)
										NetworkManager:register(protocol_command.environment_fight.code, nil, nil, nil, nil, responseCheckEnvironmentFightCallback, false, nil)
									end
								end
							end
							responseEnvironmentFightEntry = scheduler:scheduleScriptFunc(responseEnvironmentFightStep, 0.1, false)
						else
						local scheduler2 = cc.Director:getInstance():getScheduler()
							local responseEnvironmentFightEntry2 = nil
							local function responseEnvironmentFightStep2()
								if responseEnvironmentFightEntry2 ~= nil then
									scheduler2:unscheduleScriptEntry(responseEnvironmentFightEntry2)
									responseEnvironmentFightEntry2 = nil
								end
								_ED.battleData._currentBattleIndex = _currBattleIndex
								requestEnvironmentFightCallback(nil, ccui.TouchEventType.ended)
							end
							
							responseEnvironmentFightEntry2 = scheduler2:scheduleScriptFunc(responseEnvironmentFightStep2, 0.1, false)
						end
					else
						
					end
				end
				
				local function responseBattleFieldInitCallback(_cObj, _tJsd)
					-- local pNode = tolua.cast(_cObj, "CCNode")
					-- local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
					-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
						-- _oldBattleIndex = _oldBattleIndex - 1
						-- if _oldBattleIndex > 0 then
							-- if currentRoundIndex <=0 then
								-- protocol_command.environment_fight.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0".."\r\n".."0"
								-- -- Sender(protocol_command.environment_fight.code, nil, nil, nil, nil, responseCheckEnvironmentFightCallback, 0)
								-- NetworkManager:register(protocol_command.environment_fight.code, nil, nil, nil, nil, responseCheckEnvironmentFightCallback, false, nil)
							-- end
						-- else
							-- requestEnvironmentFightCallback(nil, ccui.TouchEventType.ended)
						-- end
					-- end
					
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_oldBattleIndex = _oldBattleIndex - 1
						if _oldBattleIndex > 0 then
							if currentRoundIndex <=0 then
								if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
									app.load("client.battle.report.BattleReport")
									local fightModule = FightModule:new()
									fightModule:doFight()
									
									responseCheckEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
								else
									protocol_command.environment_fight.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0".."\r\n".."0"
									-- Sender(protocol_command.environment_fight.code, nil, nil, nil, nil, responseCheckEnvironmentFightCallback, 0)
									NetworkManager:register(protocol_command.environment_fight.code, nil, nil, nil, nil, responseCheckEnvironmentFightCallback, false, nil)
								end
							end
						else
							requestEnvironmentFightCallback(nil, ccui.TouchEventType.ended)
						end
					end
				end
				
				if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
					app.load("client.battle.report.BattleReport")
					local fightModule = FightModule:new()
					fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0)
					fightModule:doFight()
					
					responseBattleFieldInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
				else
					protocol_command.battle_field_init.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
					-- Sender(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleFieldInitCallback, 0)
					NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleFieldInitCallback, false, nil)
				end
			end
		end
		
		if _ED.battleData.battle_init_type >= 10 
			or _ED.battleData.battle_init_type == 5 
			or _ED.battleData.battle_init_type == 6 
			or _ED.battleData.battle_init_type == fight_type_7
			or _ED.battleData.battle_init_type == fight_type_8
			then
			responseFightCallback()
		else
			if  __lua_project_id==__lua_project_all_star and LuaClasses["MissionClass"]._isFirstGame == true then
				responseFightCallback()
				LuaClasses["MissionClass"]._isFirstGame = false
			else
				requestEnvironmentFightCallback(nil, ccui.TouchEventType.ended)
			end
		end
	end
	
	
	-- ----------------------------------------初入战场------------------------------------------------- --
	
	-- if _ED.battleData.battle_init_type >= 10 
		-- or _ED.battleData.battle_init_type == 2 
		-- or _ED.battleData.battle_init_type == 5 
		-- or _ED.battleData.battle_init_type == 6 then
		-- fadeInBattlePVP();
	-- else
		-- fadeInBattle()
	-- end
	
	
	if _ED.battleData.battle_init_type == fight_type_7 
		or _ED.battleData.battle_init_type == fight_type_8
		then
		initUnionFormation()
	else
		initBattle()
		initEnemy()	
	end
	
	self:battleStartAnimation()
		
	battleRunning = true
	isSkepBattle = false
	-- moveTeam()
	
	startBattle = function()
		-- 开始战斗了
		currentAttackCount = 0
		currentRoundIndex = 0
		currentRoundAttackIndex = 1
		currentSkillInfluenceStartIndex = 1
		isAttackInfluence = false
		if _ED.battleData.battle_init_type == 2 then
			updateGoldBossInfo()
		end
		nextRoundBattle()
	end
	
	local musicIndex = -1
	if _ED.battleData.battle_init_type == 10 then
		musicIndex = 98
	elseif _ED.battleData.battle_init_type == 14 then
		-- local npcIndex = LuaClasses["MineInformationClass"].__battleObj
		-- musicIndex = elementAt(NPC, npcIndex):atoi(npc.battle_background_music)
	elseif _ED.battleData.battle_init_type == 15 then
		-- local npcIndex = elementAt(spiritePalaceMould, tonumber(_ED.palace_inside_info.current_floor)):atoi(spirite_palace_mould.npc_index)
		-- musicIndex = elementAt(NPC, npcIndex):atoi(npc.battle_background_music)
	elseif _ED.battleData.battle_init_type == 16 then
		musicIndex = 99
	elseif _ED.battleData.battle_init_type == 11 then
		musicIndex = 99
	elseif _ED.battleData.battle_init_type == 12 then
		musicIndex = 99
	elseif _ED.battleData.battle_init_type == 5 then
		musicIndex = 99
	elseif _ED.battleData.battle_init_type == 13 then
		musicIndex = 99
	--elseif _ED.battleData.battle_init_type == fight_type_8 then
	--	musicIndex = 99
	elseif _ED.battleData.battle_init_type == fight_type_7 then
		local list =  zstring.split(_ED._scene_npc_id,",")
		local _scene_npc_id =  439 --list[#list]
		-- -- musicIndex = elementAt(NPC, tonumber(_scene_npc_id)):atoi(npc.battle_background_music)
		
		local npcData = dms.element(dms["npc"], _scene_npc_id)
		if npcData ~= nil then
			musicIndex = dms.atoi(npcData, npc.battle_background_music)
		end
	else
		-- -- musicIndex = elementAt(NPC, tonumber(_ED._scene_npc_id)):atoi(npc.battle_background_music)
		local npcData = dms.element(dms["npc"], _ED._scene_npc_id)
		if npcData ~= nil then
			musicIndex = dms.atoi(npcData, npc.battle_background_music)
		end
	end
	-- 开始播放背景音效（index : %d）", musicIndex
	if musicIndex >= 0 then
		playBgm(formatMusicFile("background", musicIndex))
	end
	
	local ButtonX1 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Button_x1")
	local ButtonX2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Button_x2")
	local ButtonX3 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Button_x3")
	local ButtonX4 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,"Button_x4")
	
	if actionTimeSpeed == fightAccelerationOne then
		ButtonX1:setVisible(true)
		ButtonX1:setTouchEnabled(true)
	elseif actionTimeSpeed == fightAccelerationTwo then
		ButtonX2:setVisible(true)
		ButtonX2:setTouchEnabled(true)
	elseif actionTimeSpeed == fightAccelerationThree then
		ButtonX3:setVisible(true)
		ButtonX3:setTouchEnabled(true)
	elseif actionTimeSpeed == fightAccelerationFour then
		ButtonX4:setVisible(true)
		ButtonX4:setTouchEnabled(true)
	else 
		ButtonX1:setVisible(true)
		ButtonX1:setTouchEnabled(true)
	end
	
	local function x1buttonCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if __lua_project_id == __lua_project_all_star then
				if BattleSceneClass.lastLevel == nil or BattleSceneClass.lastLevel == "" then
					return
				end
			end	
			if tonumber(""..BattleSceneClass.lastLevel) < 5 and zstring.tonumber("".._ED.vip_grade) < 1 then
				TipDlg.drawTextDailog(_string_piece_info[22])
				return
			end
			if true == funOpenDrawTip(36) then
                return false
            end
		
			actionTimeSpeed = fightAccelerationTwo --1.0/2
			sender:setVisible(false)
			sender:setTouchEnabled(false)
			ButtonX2:setVisible(true)
			ButtonX2:setTouchEnabled(true)
			BattleSceneClass.setRoleAcceleration()
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 2))		--加入按钮音效	
		end
	end
	
	local function x2buttonCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if true == funOpenDrawTip(36) then
                return false
            end
			if tonumber(""..BattleSceneClass.lastLevel) < 40 and zstring.tonumber("".._ED.vip_grade) < 1 then
				TipDlg.drawTextDailog(_string_piece_info[23])
				actionTimeSpeed = fightAccelerationOne
				sender:setVisible(false)
				sender:setTouchEnabled(false)
				ButtonX1:setVisible(true)
				ButtonX1:setTouchEnabled(true)
				BattleSceneClass.setRoleAcceleration()
				return
			end
			
			actionTimeSpeed = fightAccelerationThree -- 1.0/3
			sender:setVisible(false)
			sender:setTouchEnabled(false)
			ButtonX3:setVisible(true)
			ButtonX3:setTouchEnabled(true)
			BattleSceneClass.setRoleAcceleration()
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 2))		--加入按钮音效	
		end
	end
	
	local function x3buttonCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			actionTimeSpeed = fightAccelerationOne
			sender:setVisible(false)
			sender:setTouchEnabled(false)
			ButtonX1:setVisible(true)
			ButtonX1:setTouchEnabled(true)
			BattleSceneClass.setRoleAcceleration()
			
			--[[
			actionTimeSpeed = fightAccelerationFour -- 1.0/4
			sender:setVisible(false)
			sender:setTouchEnabled(false)
			ButtonX4:setVisible(true)
			ButtonX4:setTouchEnabled(true)
			BattleSceneClass.setRoleAcceleration()
			--]]
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 2))		--加入按钮音效	
		end
	end
	
	local function x4buttonCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			actionTimeSpeed = fightAccelerationOne
			sender:setVisible(false)
			sender:setTouchEnabled(false)
			ButtonX1:setVisible(true)
			ButtonX1:setTouchEnabled(true)
			BattleSceneClass.setRoleAcceleration()
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 2))		--加入按钮音效	
		end
	end
	
	ButtonX1:addTouchEventListener(x1buttonCallback)
	
	ButtonX2:addTouchEventListener(x2buttonCallback)
	
	ButtonX3:addTouchEventListener(x3buttonCallback)
	
	-- ButtonX4:addTouchEventListener(x4buttonCallback)
	-- NED~战斗过程处理	
	-- ------------------------------------------------------------------------------------------------- --
end	

-- function BattleSceneClass.create(scene)
	-- local layer = LuaClasses["BattleSceneClass"].super.extend(BattleSceneClass, CCLayer:create())
    -- layer:init(scene)
    -- return layer
-- end

function BattleSceneClass.Draw()
	-- -- --local scene = CCScene:create()
	-- -- --scene:addChild(BattleSceneClass.create(scene))
	-- -- --cc.Director:getInstance():replaceScene(scene)
	-- -- draw.isLogin = true
	-- -- draw.clear()
	-- -- draw.graphics(BattleSceneClass.create())
	-- -- BattleSceneClass.lastLevel = _ED.user_info.user_grade
	-- -- --require "script/transformers/battle/BattleReward"
	-- -- --LuaClasses["BattleRewardClass"].Draw(scene)
	
	-- -- --require "script/transformers/battle/BattleLose"
	-- -- --LuaClasses["BattleLoseClass"].Draw(scene)
	
		-- draw.isLogin = true
	-- draw.clear()
	clearMissionUIData()
	-- fwin:reset()
	fwin:cleanView(fwin._background)
	fwin:cleanView(fwin._view)
	fwin:cleanView(fwin._viewdialog)
	fwin:cleanView(fwin._taskbar)
	fwin:cleanView(fwin._ui)
		
	-- local function battleDraw(window, ZOrder)
		-- ZOrder = ZOrder == nil and 0 or ZOrder
		-- window:init()
		-- fwin._scene:addChild(window, ZOrder)
		-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- end
	-- battleDraw(BattleSceneClass:new())
	app.load("client.battle.BattleFormationController")
	--> print("-------0000000000---------")
	fwin:open(BattleFormationController:new(), fwin._ui)
	--> print("-------222222222---------")
	fwin:open(BattleSceneClass:new())
	--> print("-------3333333333333---------")
	BattleSceneClass.lastLevel = _ED.user_info.user_grade
	--> print("-------444444444---------")
	-- state_machine.excute("battle_start_play_start_effect", 0, 0)
end

-- 角色出场
local eventJoinCount = 0
local heroJoinBattle1 = function(posTile, joinCount)
	-- 英雄加入副本1
		
	local function heroJoinOver(armature)
		if armature ~= nil then
			if armature._actionIndex == animation_standby then	
				draw.share()
				playEffectMusic(9998)
				armature._invoke = nil
				armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
				
				eventJoinCount = eventJoinCount - 1
				if eventJoinCount == 0 then
					-- 进入下一个事件2
					executeNextEvent(nil, true)
				end
								
				-- local action1 = ActionManager:shareManager():getActionByName("battle_map.json","Animation0")
				-- action1:play()
				-- action1:setLoop(true)
				-- BattleSceneClass._shakeAction:gotoFrameAndPlay(0, BattleSceneClass._shakeAction:getDuration(), true)
			elseif armature._actionIndex == animation_in_elite then
				armature._nextAction = animation_standby
				armature:setVisible(true)
				local armatureEffect = createEffect(armature._posTile, 63, 0)
				armatureEffect._invoke = deleteEffectFile
			end
		end
	end
	
	local function joinBattleFuncN(sender)
	
		local armature = sender._armature
		if armature ~= nil then
			armature._nextAction = animation_in_elite
			armature._invoke = heroJoinOver
			armature._posTile:setVisible(true)
			
			armature:getAnimation():setSpeedScale(1.0/fightAccelerationThree)
		end
	end
	
	-- 显示所有全场角色
	local armature = posTile._armature
	if armature ~= nil then
		armature:setVisible(false)
		if __lua_project_id == __lua_king_of_adventure then
			posTile:getParent():reorderChild(posTile, posTile._oldZOrder)
		else
			posTile:getParent():reorderChild(posTile, 0)
		end
		local array = {}
		table.insert(array, cc.DelayTime:create((0.01 + 0.5 * joinCount) * fightAccelerationThree))
		table.insert(array, cc.CallFunc:create(joinBattleFuncN))
		local seq = cc.Sequence:create(array)
		posTile:runAction(seq)
	end
end

--请求战斗事件ID是10106的时候隐藏对方角色
function BattleSceneClass.hideMaster()
	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
	for i, v in pairs(_ED.battleData._armys[_ED.battleData._currentBattleIndex]._data) do
		local posTileOne = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, v._pos))	
		posTileOne:setVisible(false)
	end
end

function BattleSceneClass.showRole(_camp, params)
	-- 角色出现或消失
	local show_list = zstring.split(params, ",")
	if _camp == "0" then
		for i=1, 6 do
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%d", i))	
			local isVisible = tonumber(show_list[i]) == 1 and true or false
			local proVisible = posTile:isVisible()
			--if proVisible ~= isVisible then
				posTile:setVisible(isVisible)
				if isVisible == true then
					if posTile._isShow ~= true then
						posTile._isShow = true
						heroJoinBattle1(posTile, eventJoinCount)
						eventJoinCount = eventJoinCount + 1
					end
				else
					posTile._isShow = false
				end
			--end
		end
	else
		local fIndex = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		for i=1, 6 do
			local posTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", fIndex, i))
			local isVisible = tonumber(show_list[i]) == 1 and true or false
			local proVisible = posTile:isVisible()
			--if proVisible ~= isVisible then
				posTile:setVisible(isVisible)
				if isVisible == true then
					if posTile._isShow ~= true then
						posTile._isShow = true
						heroJoinBattle1(posTile, eventJoinCount)
						eventJoinCount = eventJoinCount + 1
					end
				else
					posTile._isShow = false
				end
			--end
		end
	end
	local function callFunc()
	end
	-- executeNextEvent(callFunc)
	if eventJoinCount == 0 then
		-- 进入下一个事件。
		executeNextEvent(nil)
	end
end

function BattleSceneClass.missionAttack(execute_type)
	if execute_type == execute_type_move_team then
		moveTeam()
		checkMissionIsOver()
	elseif execute_type == execute_type_request_battle then
		startBattleCallback()
	elseif execute_type == execute_type_start_battle then
		startBattle()
		checkMissionIsOver()
	elseif execute_type == execute_type_over_battle then
		OverBattle()
		checkMissionIsOver()
	else
		nextAttack()
	end
end


function BattleSceneClass.continueFight()
	responseBattleFieldInit()
end

function BattleSceneClass.setUnionBattleInfo(_attackName, _attackNum, _defenseName, _defenseNum)
	BattleSceneClass._unionBattleInfo = {
		attackName = _attackName,
		currentAttackNum = _attackNum,
		attackNum = _attackNum,
		defenseName = _defenseName,
		currentDefenseNum = _defenseNum,
		defenseNum = _defenseNum
	}
end

function clearBattleEffect()
	if __lua_project_id == __lua_king_of_adventure then
		CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo("sprite/spirte_battle_card_1.ExportJson")
		CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo("sprite/spirte_battle_card_2.ExportJson")
	end
	CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
	if __lua_project_id ~= __lua_project_l_naruto then
		CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo("sprite/hero_head_effect.ExportJson")
	end
end

function clearBattleData()
	actionTimeSpeed = fightAccelerationOne
	clearBattleEffect()
end
-- END
-- ----------------------------------------------------------------------------------------------------