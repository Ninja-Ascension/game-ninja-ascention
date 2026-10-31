NormalLogic = NormalLogic or {}
local logic = {
	_battle_type = 0, 
	_event = 0, 
	_camp = 0,
	_attack_position = 0,
	_move_target_type = 0,
	_move_position = {x = 0, y = 0},
	_skill_mould_id = 0,
	_skill_influence_index = 0,
	_skill_influence_count = 0,
	_execute_after_influence_count = 0,
	_attacker = nil,
	_defender = nil,
	_round_attack_index = 0,
	_round_attack_total_count = 0,
	_round_index = 0, 
	_total_round_count = 0, 
	_battle_index = 0, 
	_battle_total_count = 0,
}

local __attackers = nil
local __defenders = nil
local __battleDatas = nil
local __attackDatas = nil
local __roundData = nil
local __attackData = nil


local mPosTile = nil
local __total_damage = 0 -- 单场战斗我方攻击总伤害
local attackSectionNumber = 0 --攻击段数
local attackTotalHarm = 0 --多段攻击总伤害
local attackTargetCount = 0
local executeAfterInfluenceCount = 0

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



function logic:showRoleHP(armature)
	if armature ~= nil and armature._hpPragress ~= nil then
		armature._role._hp = armature._role._hp < 0 and 0 or armature._role._hp
		local percent = armature._role._hp/armature._brole._hp * 100
		percent = percent > 100 and 100 or percent
		
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

function logic:showRoleSP(armature)
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

function logic:getRole(_camp, _target_pos)
	local _role = "".._camp == "0" and __attackers[_target_pos] or __defenders[_target_pos]
	return _role
end

function logic:getMovePosition()
	local mx = 0
	local my = 0
	local ex = 0
	local ey = 0
	
	local needMove = (logic._move_target_type ~= 0 and logic._move_target_type ~= 8) and true or false
	local attackingTime = 0.0
	
	local mPosTile = nil
	local mpos = nil
	local mtime = 0
	if logic._camp == "0" then
		-- 我方攻击
		state_machine.excute("battle_formation_controller_role_attack", 0, {roleType = 2, roleIndex = logic._attack_position})
		
		mPosTile = logic._attacker
		mx, my = mPosTile:getPosition()
		
		if needMove == true then
			if logic._move_target_type == 1 then
				-- local mpos2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, 2))
				-- local epos2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, 2))
				local mpos2 = logic:getRole(0, 2)
				local epos2 = logic:getRole(1, 2)
				ex, ey = mPosTile:getPosition()
				local m2x, m2y = mpos2:getPosition()
				local e2x, e2y = epos2:getPosition()
				
				local mmx, mmy = mPosTile:getPosition()
				
				ex = ex + (m2x - ex)
				ey = ey + (e2y - m2y)/2 + (m2y - mmy) - mPosTile:getContentSize().height/2 - 20/CC_CONTENT_SCALE_FACTOR()
				
				mPosTile._mscale = epos2._scale or 1.0
			else
				-- local ePosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, attackMovePos-1))
				local ePosTile = logic:getRole(1, attackMovePos-1)
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
		
		-- mPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, attackerPos))
		mPosTile = logic:getRole(1, attackerPos)
		mx, my = mPosTile:getPosition()
		if __lua_project_id == __lua_king_of_adventure then
			mPosTile._scale = mPosTile._scale or 1.0
			mPosTile._mscale = mPosTile._scale or 1.0
		end
		
		if needMove == true then
			if attackMovePos == 1 then
				-- local mpos2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", ofsetCount, 2))
				-- local epos2 = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, 2))
				local mpos2 = logic:getRole(1, 2)
				local epos2 = logic:getRole(0, 2)
				ex, ey = mPosTile:getPosition()
				local m2x, m2y = mpos2:getPosition()
				local e2x, e2y = epos2:getPosition()
				
				local mmx, mmy = mPosTile:getPosition()
				
				ex = ex + (m2x - ex)
				ey = ey + (e2y - m2y)/2 + (m2y - mmy) + mPosTile:getContentSize().height/2 + 20/CC_CONTENT_SCALE_FACTOR()
				
				mPosTile._mscale = epos2._scale or 1.0
			else
				-- local ePosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, attackMovePos-1))
				local ePosTile = logic:getRole(0, attackMovePos-1)
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
end

function logic:resetArmatureData(armature)
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


-- --------------------------------------------------------------------- --

-- 加载光效资源文件
-- effect_6006.ExportJson
loadEffectFile = function(fileIndex)
	local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
	--CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
	local armatureName = string.format("effice_%d", fileIndex)
	return armatureName, fileName
end

function logic.deleteEffectFile(armatureBack)
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

function logic:createEffect(armaturePad, fileIndex, _camp, addToTile)
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
function logic:executeEffectSkillBegan(armatureBack)
	local armature = armatureBack
	local skillInfluenceElementData = armature._sie
	local forepart_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.forepart_lighting_effect_id)
	--> print("***********************", skill_influence.forepart_lighting_effect_id)
	if forepart_lighting_effect_id >= 0 then
		local armatureEffect = createEffect(armature._posTile, forepart_lighting_effect_id, armature._posTile._camp)
		armatureEffect._invoke = logic.deleteEffectFile
		armatureEffect._base = armature
	else
		--logic:executeAttacking()
	end
	local forepart_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.forepart_lighting_sound_effect_id)

	if forepart_lighting_sound_effect_id >= 0 then
		playEffectMusic(forepart_lighting_sound_effect_id)
	end
end

-- 技能光效中段
function logic.executeEffectSkillingOver(armatureBack)
	-- 准备清除技能光中段资源
	logic.deleteEffectFile(armatureBack)
	logic:executeHeroMoveToOriginTarget()
		
	if BattleSceneClass._hasWidgetBg == true or BattleSceneClass._effectBg ~= nil then
		BattleSceneClass._effectBg:removeFromParent(true)
		BattleSceneClass._effectBg = nil
		BattleSceneClass._hasWidgetBg = nil
	end		
end

function logic:executeEffectSkilling(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	-- 技能光效中段
	--local armatureBase = armature._base
	-- logic.deleteEffectFile(armature)
	
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
			armatureEffect._invoke = logic.deleteEffectFile
		else
			armatureEffect._invoke = logic.executeEffectSkillingOver
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
			logic:resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			logic:resetArmatureData(armature)
		end
		logic:executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

function logic:executeEffectSkilling1(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- logic.deleteEffectFile(armature)
	
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
			armatureEffect._invoke = logic.deleteEffectFile
		else
			armatureEffect._invoke = logic.executeEffectSkillingOver
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
			logic:resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			logic:resetArmatureData(armature)
		end
		logic:executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

function logic:executeEffectSkilling2(armatureBack)

end

function logic:executeEffectSkilling3(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- logic.deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._skf = armature._skf
		if armature._sie == nil then
			armatureEffect._invoke = logic.deleteEffectFile
		else
			armatureEffect._invoke = logic.executeEffectSkillingOver
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
			local posTile2 = logic:getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
			local posTile5 = logic:getRole(0, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy5 + (yy2 - yy5)))
			
		else
			local posTile2 = logic:getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
		
			local posTile5 = logic:getRole(1, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy2 + (yy5 - yy2)))
		end
		
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v)
			end
			logic:resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			resetArmatureData(armature)
		end
		logic:executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

function logic:executeEffectSkilling4(armatureBack)

end

function logic:executeEffectSkilling5(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- logic.deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._skf = armature._skf
		if armature._sie == nil then
			armatureEffect._invoke = logic.deleteEffectFile
		else
			armatureEffect._invoke = logic.executeEffectSkillingOver
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
			logic:resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			logic:resetArmatureData(armature)
		end
		logic:executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

function logic:executeEffectSkilling6(armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- logic.deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, mPosTile._camp)
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._skf = armature._skf
		if armature._sie == nil then
			armatureEffect._invoke = logic.deleteEffectFile
		else
			armatureEffect._invoke = logic.executeEffectSkillingOver
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
			local posTile2 = logic:getRole(0, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
			local posTile5 = logic:getRole(0, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy5 + (yy2 - yy5) + pSize.height/2))
			
		else
			local posTile2 = logic:getRole(1, 2) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_2", ofsetCount))
			local xx2, yy2 = posTile2:getPosition()
		
			local posTile5 = logic:getRole(1, 5) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_5", ofsetCount))
			local xx5, yy5 = posTile5:getPosition()
			local pSize = posTile5:getContentSize()
			
			armatureEffect:setPosition(cc.p(xx2 + pSize.width/2, yy2 + (yy5 - yy2) + pSize.height/2))
		end
		
	else
		if armature._defs ~= nil then
			for i, v in pairs(armature._defs) do
				drawFrameEvent(armature, armature, v)
			end
			logic:resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			logic:resetArmatureData(armature)
		end
		logic:executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

function logic:executeEffectSkilling7(armatureBack, defArmatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	--local armatureBase = armature._base
	-- logic.deleteEffectFile(armature)
	
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
			armatureEffect._invoke = logic.deleteEffectFile
		else
			armatureEffect._invoke = logic.executeEffectSkillingOver
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
			logic:resetArmatureData(armature)
		else
			drawFrameEvent(armature, armature, armature._def)
			logic:resetArmatureData(armature)
		end
		logic:executeHeroMoveToOriginTarget()	
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

-- --------------------------------------------------------------------- --
function logic.attackChangeActionCallback(armatureBack)
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
				logic:executeHeroMoveBy()
				beganMoveHero = 1
			elseif beganMoveHero == 10 then
				logic:executeHeroMoveByBack()
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
			logic:executeHeroMoveBy()
			armatureBack._nextAction = animation_melee_attack_began
		elseif actionIndex == animation_melee_attack_began then		-- 近身攻击前段
			executeMeleeAttacking(armatureBack)
		elseif actionIndex == animation_melee_attacking then		-- 近身攻击中段
			armatureBack._nextAction = animation_standby
			logic:executeAttacking()
		elseif actionIndex == animation_melee_attack_end then		-- 近身攻击后段
			--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
			mtime = moveToTargetTime1
			-- mtime = armatureBack._duration
			logic:executeHeroMoveByBack()
			if needMove == true then
				-- 近身攻击后段:当前角色移动攻击完毕，现在返回原点
			else
				-- 近身攻击后段:当前角色原地攻击完毕
			end
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_remote_attack_began then	-- 远程攻击前段
			logic:executeRemoteAttacking(armatureBack)
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
				logic:executeAttacking()
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
				
				logic:nextAttacker()
			else
				logic:executeAttackerBuff()
			end
			
		elseif actionIndex == animation_skill_moving then			-- 技能近身攻击上的移动帧组
			mtime = moveToTargetTime2
			logic:executeHeroMoveBy()
			armatureBack._nextAction = animation_melee_skill_began
		elseif actionIndex == animation_melee_skill_began then		-- 技能近身攻击前段
			executeMeleeAttacking(armatureBack)
		elseif actionIndex == animation_melee_skilling then			-- 技能近身攻击中段
			armatureBack._nextAction = animation_standby
			logic:executeAttacking()
		elseif actionIndex == animation_melee_skill_end then		-- 技能攻击近身后段
			--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
			mtime = moveToTargetTime2
			logic:executeHeroMoveByBack()
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
				logic:executeAfterAttacking()
			else
				logic:executeAttacking()
			end
		elseif actionIndex == animation_remote_skill_end then		-- 技能远程攻击后段
			armatureBack._nextAction = animation_standby
			logic:executeAttackerBuff()
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
					logic:showRoleHP(armature)
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
-- --------------------------------------------------------------------- --

--[[
	0基于施放者与承受者的路径（根据目标数量绘制光效）
	1基于施放者位置（只绘制一个光效）
	2基于承受者位置（根据目标数量绘制光效）
	3基于对方阵营中心（只绘制一个光效）
	4基于攻击范围无视存活数量（根据目标数量绘制光效）
	5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
	6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
--]]
function logic:executeAttack()
	-- 执行被攻击
	for j = logic._skill_influence_index, logic._skill_influence_count do
		-- local _skf = {}
		local _skf = __attackData.skillInfluences[j]
		local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
		local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
		
		mPosTile._armature._skf = _skf
		logic:resetArmatureData(mPosTile._armature)
		
		-- 加载技能效用
		local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
		local skillCategory = dms.atoi(skillInfluenceElementData, skill_influence.skill_category)
		local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
		
		mPosTile._armature._sie = skillInfluenceElementData
		-- 启动技能前段
		logic:executeEffectSkillBegan(mPosTile._armature)
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
										
			local rPad = logic:getRole(defender, defenderPos)
			--rPad._armature._def = _def
			--rPad._armature._sie = skillInfluenceElementData
			
			logic:resetArmatureData(rPad._armature)
			
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

function logic:executeAttackInfluence(skf)
	-- 执行被攻击中段
	local attackInfluencedCount = 0
	-- for j = currSkillInfluenceStartIndex, currSkillInfluenceCount do
		local _skf = skf --attData.skillInfluences[j]
		local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
		local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
		local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
		local attackerPos = _skf.attackerPos			-- 效用发动者位置
		local currPosTile = logic:getRole(attackerType, attackerPos)
		-- if attackerType == "1" then
		-- 	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		-- 	currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
		-- else
		-- 	currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
		-- end
			
		local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
		
		for w = 1, _skf.defenderCount do
			local _def = _skf._defenders[w]
			local defender = _def.defender
			local defenderPos = tonumber(_def.defenderPos)						
			local rPad = logic:getRole(defender, defenderPos)
			logic:resetArmatureData(rPad._armature)
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
			logic:executeEffectSkilling1(currPosTile._armature)
			executeDrawEffect = false
		elseif lightingEffectDrawMethod == 2 then
			-- logic:executeEffectSkilling2(currPosTile._armature)
			-- executeDrawEffect = false
			_skf.attTarList = nil
		elseif lightingEffectDrawMethod == 3 then
			attackTargetCount = 1
			logic:executeEffectSkilling3(currPosTile._armature)
			executeDrawEffect = false
		elseif lightingEffectDrawMethod == 4 then
			logic:executeEffectSkilling4(currPosTile._armature)
		elseif lightingEffectDrawMethod == 5 then
			-- logic:executeEffectSkilling5(currPosTile._armature)
			_skf.attTarList = nil
		elseif lightingEffectDrawMethod == 6 then
			-- logic:executeEffectSkilling6(currPosTile._armature)
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
			
			local rPad = logic:getRole(defender, defenderPos)
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
							__total_damage = __total_damage + tonumber(drawString)
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
							logic:showRoleSP(rPad._armature)
						end
						
					elseif (defenderST == "0" or defenderST == "1" or defenderST == "6" or defenderST == "9") then
						rPad._armature._role._hp = rPad._armature._role._hp + tonumber(drawString)
						logic:showRoleHP(rPad._armature)
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
					logic:executeEffectSkilling7(currPosTile._armature,v)
				else
					logic:executeEffectSkilling(v)
				end
				roleCount = roleCount + 1
			end
			attackTargetCount = roleCount
			if roleCount <= 0 then
				logic:executeHeroMoveToOriginTarget()
			elseif _skf.attTarList ~= nil then
				if lightingEffectDrawMethod ~= 7 then
					local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
					for a, t in pairs(_skf.attTarList) do
						local cPosTile = logic:getRole(attacker, t)
						-- if attacker == "0" then
						-- 	cPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, t))
						-- else
						-- 	cPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, t))
						-- end
						if cPosTile ~= nil then
							-- 无视攻击位置
							local effect = logic:createEffect(cPosTile, posterior_lighting_effect_id, (tonumber(currPosTile._camp) + 1) % 2)
							effect._invoke = logic.deleteEffectFile
							effect._LastsCountTurns = nil
						end
					end
				end
			end
		end
		--break
	-- end
end

function logic:executeAttacking()
	-- logic:executeAttackInfluence(mPosTile, logic._skill_influence_index, logic._skill_influence_count)
	if logic._skill_influence_index <= logic._skill_influence_count then
		local recal = logic:executeAttackInfluence(__attackData.skillInfluences[logic._skill_influence_index])
		if recal == 2 then
			logic._skill_influence_index = logic._skill_influence_index + 1
			logic:executeAttacking()
		end
	else
		logic:executeHeroMoveToOriginTarget()
	end
end

function logic:startAfterAttack()
	if executeAfterInfluenceCount < __attackData.skillAfterInfluenceCount then
		executeAfterInfluenceCount = executeAfterInfluenceCount + 1
		
		local _skf = __attackData.skillAfterInfluences[executeAfterInfluenceCount]
		local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
		
		local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
		local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
		local attackerPos = _skf.attackerPos			-- 效用发动者位置
		local currPosTile = logic:getRole(attackerType, attackerPos)
		-- if attackerType == "1" then
		-- 	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
		-- 	currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
		-- else
		-- 	currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
		-- end
		
		local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
		
		logic:resetArmatureData(currPosTile._armature)
		
		if currPosTile._armature == nil then
			executeAfterInfluenceCount = __attackData.skillAfterInfluenceCount
			logic:nextAttacker()
		else
			currPosTile._armature._isReact = true
			currPosTile._armature._skf = _skf
				
			executeRemoteSkillBegan(currPosTile._armature)
		end
	else
		executeAfterAttack()
	end
end

function logic:executeAfterAttack()
	if executeAfterInfluenceCount <= __attackData.skillAfterInfluenceCount then
		-- 执行被攻击
		for j = executeAfterInfluenceCount, __attackData.skillAfterInfluenceCount do
			-- local _skf = {}
			local _skf = __attackData.skillAfterInfluences[j]
			local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
			
			local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
			local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
			local attackerPos = _skf.attackerPos			-- 效用发动者位置
			local currPosTile = logic:getRole(attackerType, attackerPos)
			-- if attackerType == "1" then
			-- 	local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
			-- 	currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, attackerPos))
			-- else
			-- 	currPosTile = ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_0_%s", attackerPos))
			-- end
			
			local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量
			
			currPosTile._armature._skf = _skf
			logic:resetArmatureData(currPosTile._armature)
			
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
				
				logic:resetArmatureData(rPad._armature)
				
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
		logic:executeAfterAttacking()
	end
end

function logic:executeAfterAttacking()
	if executeAfterInfluenceCount > 0 and executeAfterInfluenceCount <= __attackData.skillAfterInfluenceCount then
		-- 处理后段效用逻辑
		-- 格挡反击-处理后段效用逻辑
		local recal = logic:executeAttackInfluence(__attackData.skillAfterInfluences[executeAfterInfluenceCount])
		executeAfterInfluenceCount = executeAfterInfluenceCount + 1
		if recal == 2 then
			logic:executeAfterAttacking()
		end
	else
		-- 没有后段的效用直接处理逻辑
		-- 格挡反击结束, 找查下一攻击角色，或进入下一回合
		logic:nextAttacker()
	end
end

function logic:executeAttackEnd()
	if executeAfterInfluenceCount < __attackData.skillAfterInfluenceCount and executeAfterInfluenceCount == 0 then
		-- 执行被攻击后段-处理格挡反击
		logic:startAfterAttack()
	else
		-- 没有格挡反击, 找查下一攻击角色，或进入下一回合
		logic:nextAttacker()
	end
end

function logic:executeAttackerBuff()	
	state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
	-- 处理当前攻击者的BUFF信息，然后进入到下一个攻击角色进行攻击！
	-- local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
	
	local attackerBuffState = __attackData.attackerBuffState 			-- = npos(list)	-- 出手方是否有buff影响(0:没有 1:有)
	local _dindex = 0
	for z=1, tonumber(attackerBuffState) do
		local _widget = mPosTile
		local widgetSize = _widget:getContentSize()
		
		local attackerBuffType = __attackData.attackerBuffType[z] 			-- = npos(list)	-- (有buff影响时传)影响类型(6为中毒,9为灼烧)
		local attackerBuffValue = __attackData.attackerBuffValue[z] 		-- = npos(list)	-- 影响值
		
		mPosTile._armature._role._hp = mPosTile._armature._role._hp - tonumber(attackerBuffValue)
		logic:showRoleHP(mPosTile._armature)
		
		if z == tonumber(attackerBuffState) then
			local attackerBuffDeath = __attackData.attackerBuffDeath
			if attackerBuffDeath == "1" then
				mPosTile._armature._def = nil
				mPosTile._armature._dropCount = __attackData.attackerBuffDropCount
				executeRoleDeath(mPosTile._armature)
			end
		end	
		
		local numberFilePath = "images/ui/number/xue.png"
		
		local labelAtlas = cc.LabelAtlas:_create("-"..attackerBuffValue, numberFilePath, 34 / CC_CONTENT_SCALE_FACTOR(), 46 / CC_CONTENT_SCALE_FACTOR(), 43)   
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
		logic:showRoleHP(mPosTile._armature)
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
	-- currentRoundAttackIndex = currentRoundAttackIndex + 1
	--skillInfluenceStartIndex = 1
	logic._skill_influence_index = 1
	
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
	
	
	logic:executeAttackEnd()
	--绘制多段攻击总伤害
	if attackTotalHarm > 0 and attackSectionNumber > 1 then
		if BattleSceneClass._attackTotalHarm ~= nil then
			BattleSceneClass._attackTotalHarm:removeFromParent(true)
		end
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then

		else
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
	end
	attackTotalHarm = 0
	attackSectionNumber = 0
end
-- 攻击运算逻辑
-- --------------------------------------------------------------------- --



-- 移动的状态控制
local beganMoveHero = 0
function logic.executeMoveOverFunc()
	beganMoveHero = 2
end

-- 返回到原点
function logic.executeHeroMoveByBackOverFunc()
	beganMoveHero = 12
	began_hero_ZOrder = mPosTile:getLocalZOrder()
	local parent_node = mPosTile:getParent()
	
	if __lua_project_id == __lua_king_of_adventure then
		parent_node:reorderChild(mPosTile, mPosTile._oldZOrder)
	else
		parent_node:reorderChild(mPosTile, kZOrderInMap_StanddyRole)
	end
	
	logic:executeAttackerBuff()
end

function logic:executeHeroMoveByBack()
	-- -- local array = CCArray:createWithCapacity(10)
	--array:addObject(CCActionInterval:create(1.2))
	if mpos ~= nil then
		local seq = cc.Sequence:create(
			cc.MoveBy:create(mtime * actionTimeSpeed, cc.p(-1 * mpos.x, -1 * mpos.y)),
			cc.CallFunc:create(logic.executeHeroMoveByBackOverFunc)
		)
		mPosTile:runAction(seq)
		if __lua_project_id == __lua_king_of_adventure then
			mPosTile._armature:runAction(cc.ScaleTo:create(mtime * actionTimeSpeed, mPosTile._armature._brole._scale))
		end
	end
end

-- 移动到目标点				
function logic:executeHeroMoveBy()
	-- local array = CCArray:createWithCapacity(10)
	-- --array:addObject(CCActionInterval:create(1.2))
	-- array:addObject(cc.MoveBy:create(mtime * actionTimeSpeed, mpos))
	-- array:addObject(CCCallFunc:create(executeMoveOverFunc))
	local seq = cc.Sequence:create(
		cc.MoveBy:create(mtime * actionTimeSpeed, mpos),
		cc.CallFunc:create(logic.executeMoveOverFunc)
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
function logic:executeMoveMeleeAttackBegan(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_attack_moving
	armature._invoke = logic.attackChangeActionCallback
	-- 近身移动
end

-- 近身攻击
function logic:executeMeleeAttackBegan(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_attack_began
	armature._invoke = logic.attackChangeActionCallback
	-- 近身攻击1
end

function logic:executeMeleeAttacking(armatureBack)
	--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
	--mtime = moveToTargetTime1
	--logic:executeHeroMoveBy()
					
	logic:executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_melee_attacking
	-- 近身攻击2
end

function logic:executeMeleeAttackEnd(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_attack_end
	-- 近身攻击3
end
-- END~近身攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 远程攻击
function logic:executeRemoteAttackBegan(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_attack_began
	armature._invoke = logic.attackChangeActionCallback
	-- 远程攻击1
end

function logic:executeRemoteAttacking(armatureBack)
	logic:executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_remote_attacking
	-- 远程攻击2
end

function logic:executeRemoteAttackEnd(armatureBack)
	--logic:executeAttacking()
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
function logic:executeMoveMeleeSkillBegan(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_skill_moving
	armature._invoke = logic.attackChangeActionCallback
	-- 技能近身攻击1
end

-- 技能近身攻击
function logic:executeMeleeSkillBegan(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_skill_began
	armature._invoke = logic.attackChangeActionCallback
	-- 技能近身攻击1
end

function logic:executeMeleeSkilling(armatureBack)	
	--mtime = armatureBack:getAnimation():getTotalDuration()/60.0
	--mtime = moveToTargetTime2
	--logic:executeHeroMoveBy()
	
	logic:executeAttack()
	local armature = armatureBack
	armature._nextAction = animation_melee_skilling
	-- 技能近身攻击2
end

function logic:executeMeleeSkillEnd(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_melee_skill_end
	-- 技能近身攻击3
end
-- END~技能近身攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 技能远程攻击
function logic:executeRemoteSkillBegan(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_skill_began
	armature._invoke = logic.attackChangeActionCallback
	-- 技能远程攻击1
end

function logic:executeRemoteSkilling(armatureBack)
	if executeAfterInfluenceCount > 0 then
		-- 启动反击
		executeAfterAttack()
	else
		logic:executeAttack()
	end
	local armature = armatureBack
	armature._nextAction = animation_remote_skilling
	-- 技能远程攻击2
end

function logic:executeRemoteSkillEnd(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_remote_skill_end
	-- 技能远程攻击3
end
-- END~技能远程攻击
-- --------------------------------------------------------------------- --

-- --------------------------------------------------------------------- --
-- 被攻击光效
function logic:executeHeroByAttack(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_hero_by_attack
	armature._invoke = logic.attackChangeActionCallback
end

function logic:executeEmenyByAttack(armatureBack)
	local armature = armatureBack
	armature._nextAction = animation_emeny_by_attack
	armature._invoke = logic.attackChangeActionCallback
end
-- END~被攻击光效
-- --------------------------------------------------------------------- --

function logic:executeHeroMoveToTarget()
	-- 清理对象缓存信息
	logic:resetArmatureData(mPosTile._armature)
	--> print("mPosTile._armature ", mPosTile._armature )
	-- 角色死亡
	if mPosTile._armature == nil then
		logic:nextAttacker()
		return
	end
	--> print("logic._move_target_type", logic._move_target_type, logic._skill_property)
	if logic._move_target_type == 0 or logic._move_target_type == 8 then
		-- 在原地进行攻击
		if logic._skill_property == 0 then
			logic:executeRemoteAttackBegan(mPosTile._armature)
		elseif logic._skill_property == 1 then
			logic:executeRemoteSkillBegan(mPosTile._armature)
		end
		if logic._move_target_type == 8 then
			mPosTile:setVisible(false)
		end
	else
		-- 处理移动逻辑-初始化移动
		local armature = mPosTile._armature
		armature._invoke = logic.attackChangeActionCallback
		
		if logic._skill_property == 0 then
			logic:executeMoveMeleeAttackBegan(mPosTile._armature)
		elseif logic._skill_property == 1 then
			logic:executeMoveMeleeSkillBegan(mPosTile._armature)
		end
		
	end

	-- if logic._move_target_type == 0 or logic._move_target_type == 8 then
	--> 在原地进行攻击
	--> print("在原地进行攻击")
	-- 	if logic._skill_property == 0 then
	-- 		state_machine.excute(logic._camp == 0 and "hero_remote_attack_began" or "master_remote_attack_began", 0, logic._attacker)
	-- 	elseif logic._skill_property == 1 then
	-- 		state_machine.excute(logic._camp == 0 and "hero_remote_skill_began" or "master_remote_skill_began", 0, logic._attacker)
	-- 	end
	-- 	if logic._move_target_type == 8 then
	-- 		logic._attacker:setVisible(false)
	-- 	end
	-- else
	-- 	-- 处理移动逻辑-初始化移动
	--> ("处理移动逻辑-初始化移动")
	-- 	local armature = logic._attacker._armature
	-- 	armature._invoke = logic.attackChangeActionCallback
		
	-- 	if logic._skill_property == 0 then
	-- 		state_machine.excute(logic._camp == 0 and "hero_move_melee_attack_began" or "master_move_melee_attack_began", 0, logic)
	-- 	elseif logic._skill_property == 1 then
	-- 		state_machine.excute(logic._camp == 0 and "hero_move_melee_skill_began" or "master_move_melee_skill_began", 0, logic)
	-- 	end
	-- end
end

function logic:executeHeroMoveToOriginTarget()
	-- 处理返回逻辑
	if attackTargetCount > 0 then
		attackTargetCount = attackTargetCount - 1
		if attackTargetCount > 0 then
			return
		end
	end
	
	if executeAfterInfluenceCount > 0 then
		-- 重新进入
		-- logic:executeAfterAttacking()
		logic:executeAfterAttacking()
		return
	end
	
	-- local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
	if (logic._skill_influence_index < logic._skill_influence_count) then
		logic._skill_influence_index = logic._skill_influence_index + 1
		logic:executeAttacking()
		--executeAttack()
		return
	end
	
	if logic._move_target_type == 0 or logic._move_target_type == 8 then
		-- 处理在原地进行攻击后的返回逻辑
		--logic:executeAttackerBuff()
		if logic._skill_property == 0 then	-- 物理远程攻击
			logic:executeRemoteAttackEnd(mPosTile._armature)
		elseif logic._skill_property == 1 then	-- 技能远程攻击
			logic:executeRemoteSkillEnd(mPosTile._armature)
		end
		if logic._move_target_type == 8 then
			mPosTile:setVisible(true)
		end
		-- executeRemoteAttackBegan(mPosTile._armature)
		-- executeAttack()
	--elseif attackMovePos == 1 then
	--	处理移动到屏幕中进行攻击的返回逻辑
	---	-- logic:executeAttackerBuff()
	--elseif attackMovePos == 8 then
	--	处理暗杀进行攻击的返回逻辑
	--	--logic:executeAttackerBuff()
	else
		-- 处理攻击后的返回逻辑
		if logic._skill_property == 0 then	-- 物理近身攻击
			logic:executeMeleeAttackEnd(mPosTile._armature)
		elseif logic._skill_property == 1 then	-- 技能近身攻击
			logic:executeMeleeSkillEnd(mPosTile._armature)
		end
	end
end

-- 清除角色身上的buff光效
function logic:cleanBuffEffect(_role)
	
end

-- 获取当前回合的下一个可以进行攻击角色的数据，如果没有下一个行动角色的数据，进入下一战斗回合
function logic:nextAttacker()
	logic._round_attack_index = logic._round_attack_index + 1
	__attackData = __roundData.roundAttacksData[logic._round_attack_index]
	if __attackData == nil then
		logic:nextRound()
		return
	else
		logic._execute_after_influence_count = 0
		logic._camp = tonumber(__attackData.attacker)									-- = npos(list)		--回合1出手方标识(0:我方 1:对方)
		logic._attack_position = tonumber(__attackData.attackerPos)						-- = npos(list)		--出手方位置(1-6)
		logic._attacker = logic._camp == 0 and __attackers[logic._attack_position] or 	__defenders[logic._attack_position]						-- 出手的对象
		logic._move_target_type = tonumber(__attackData.attackMovePos)						-- = npos(list)		--移动到的位置(0-8)
		logic._skill_mould_id = tonumber(__attackData.skillMouldId)							-- = npos(list)	--技能模板id
		logic._skill_influence_count = tonumber(__attackData.skillInfluenceCount) 			-- = tonumber(npos(list))	-- 技能效用数量
		logic._skill_influence_index = 1

		-- temp
		mPosTile = logic._attacker

		-- load skill data
		local skillElementData = dms.element(dms["ship_mould"], logic._skill_mould_id)	
		local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)		-- 技能类型(0:普通 1:怒气)
		logic._skill_property = dms.atoi(skillElementData, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
		local skillReleasePosition = dms.atoi(skillElementData, skill_mould.skill_release_position)

		logic:cleanBuffEffect(logic._attacker)

		-- 眩晕
		if logic._skill_influence_count <= 0 then
			--> print("当前出手的角色是眩晕状态。")
			logic:nextAttacker()
			return
		end

		-- if skillQuality == 1 and mPosTile._armature._role._quality >= 3 then
		if skillQuality == 1 then
			-- 绘制怒气技术过场动画
			--> print("绘制怒气技术过场动画。")
			state_machine.excute("fight_display_sp_skill_effect", 0, 0)
		else
			--> print("进入攻击移动状态。")
			logic:executeHeroMoveToTarget()
		end
	end
end

-- 获取下一回合的战斗数据，如果不存在下一回合的数据，说明当前场次的战斗结束，需要请求下一场战斗数据
function logic:nextRound()
	logic._round_index = logic._round_index + 1
	logic._round_attack_index = 0
    __roundData = __attackDatas.roundData[logic._round_index]
    return __roundData ~= nil
end

-- 战斗是否结束，如果结束，准备进入战斗结算
function logic:isOver()
	return logic._battle_index >= logic._battle_total_count
end

-- 校验当前回合是否结束，如果结束，准备进入下一回合的战斗
function logic:roundOver()
	return logic._round_index >= logic._total_round_count
end

function logic:attack()
	if logic:roundOver() == true then
		if logic.isOver() == true then
			--> print("战斗结束。")
		else
			state_machine.excute("fight_request_battle", 0, 0)
		end
	else
	    
	    if logic:nextRound() == false then
	    	logic:attack()
	    else
	    	logic:nextAttacker()
	    	state_machine.excute("更新界面中战斗回合数的显示。", 0, __roundData.currentRound.."/".."30")
	    end
    end
end

function NormalLogic:startPVEBattle(_battleData, _attackData, _attackers, _defenders)
    __battleDatas = _battleData
    __attackDatas = _attackData
    __attackers = _attackers
    __defenders = _defenders
    __total_damage = 0

	logic._battle_type = 0
	logic._event = 0
	logic._round_index = 0
	logic._total_round_count = tonumber(""..__attackDatas.roundCount)
	logic._battle_index = logic._battle_index + 1
	logic._battle_total_count = tonumber(""..__battleDatas.battle_total_count)

    logic:attack()
end

function NormalLogic:cleanBattle()
	logic._battle_type = 0
	logic._event = 0
	logic._round_index = 0
	logic._total_round_count = 0
	logic._battle_index = 0
	logic._battle_total_count = 0

	__total_damage = 0

	__attackers = nil
	__defenders = nil
	__battleDatas = nil
	__attackDatas = nil
end


-- -----------------------------------------------------------------------------
