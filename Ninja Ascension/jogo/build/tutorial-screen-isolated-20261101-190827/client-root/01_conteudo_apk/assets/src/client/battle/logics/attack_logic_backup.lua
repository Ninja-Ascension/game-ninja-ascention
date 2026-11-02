attack_logic = attack_logic or {}

attack_logic.queue = {}
attack_logic.__attackers = nil
attack_logic.__defenders = nil

local kZOrderInMap_StanddyRole	= 0
local kZOrderInMap_MoveRole		= 1	
local kZOrderInMap_Effect		= 2		
local kZOrderInMap_Hurt			= 3		
local kZOrderInMap_sp_effect	= 4
local actionTimeSpeed = 1.0


function attack_logic.playEffectMusic(musicIndex)
	playEffect(formatMusicFile("effect", musicIndex))
end

function attack_logic.removeFrameObjectFuncN(sender)
	sender:removeFromParent(true)
end

-- 加载光效资源文件
-- effect_6006.ExportJson
attack_logic.loadEffectFile = function(fileIndex)
	local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
	--CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
	local armatureName = string.format("effice_%d", fileIndex)
	return armatureName, fileName
end

attack_logic.deleteEffectFile = function(armatureBack)
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

attack_logic.createEffect = function(armaturePad, fileIndex, _camp, addToTile)
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
	--> print("frameListCount->", frameListCount, _camp, _armatureIndex)
	armature:getAnimation():playWithIndex(_armatureIndex)
	armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
	if addToTile == true then
		armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
		posTile:addChild(armature, kZOrderInMap_Effect)
	else	
		posTile:getParent():addChild(armature, kZOrderInMap_Effect)
	end
	armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	
	local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
	armature._duration = duration / 60.0
	return armature
end

function attack_logic.createEffectExt(armaturePad, fileIndex, _camp, addToTile, index, totalCount)
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
	armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
	if addToTile == true then
		armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
		posTile:addChild(armature, kZOrderInMap_Effect)
	else	
		posTile:getParent():addChild(armature, kZOrderInMap_Effect)
	end
	armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	return armature
end

function attack_logic.onMoveFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
	-- local info = string.format("(%s) emit a frame event (%s) originFrame(%d)at frame index (%d).", bone:getName(),evt,originFrameIndex, currentFrameIndex)
	--> print("onMoveFrameEvent:(info)->", info)
	local pos = string.find(evt, "start_move_")
    if pos ~= nil then
    	local stime = string.sub(evt, pos+#"start_move_", #evt)
    	--> print("stime:", stime)
    	if stime ~= nil and #stime > 0 then
			local armature = bone:getArmature()
			--> print(tonumber(stime) / 60)
			armature:runAction(cc.MoveTo:create(tonumber(stime) / 60, armature._move_position))
			-- armature:runAction(cc.MoveTo:create(tonumber(stime) * 60 / 1000, cc.p(100, 500)))
    	end
    end
end

function attack_logic.createFlyingEffect(index, totalCount, bone,evt,originFrameIndex,currentFrameIndex)
	local armature = bone:getArmature()
	local backPad = armature._posTile

	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = attack_logic.get_camp_effect_id(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)

	local armatureEffect = attack_logic.createEffectExt(backPad, posterior_lighting_effect_id, backPad._camp, false, index, totalCount)
	armatureEffect._base = armature
	armatureEffect._sie = armature._sie
	armatureEffect._def = armature._def
	armatureEffect._invoke = attack_logic.deleteEffectFile
	armatureEffect:getAnimation():setFrameEventCallFunc(attack_logic.onMoveFrameEvent)

	local angle = armature._angle
	local start_pos = armature._start_position
	local _end_position = armature._end_position

	--> print("_end_position:", index, totalCount, armature._angle, start_pos.x, start_pos.y, _end_position.x, _end_position.y)

	armatureEffect:setRotation(angle)
	armatureEffect:setPosition(start_pos)
	-- armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))

	armatureEffect._move_position = _end_position
end

function attack_logic.createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
	local armature = bone:getArmature()
	-- local frameListCount = math.ceil(armature:getAnimation():getAnimationData():getMovementCount() / 2)
	local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
	--> print("创建飞行光效", frameListCount)
	for i=2,frameListCount do
		--> print("创建飞行光效kkk", i-1)
		attack_logic.createFlyingEffect(i - 1, frameListCount, bone,evt,originFrameIndex,currentFrameIndex)
	end
end

function attack_logic.executeHeroMoveToOriginTarget(currentArmatureBack)
	-- -- 处理返回逻辑
	-- if attackTargetCount > 0 then
	-- 	attackTargetCount = attackTargetCount - 1
	-- 	if attackTargetCount > 0 then
	-- 		return
	-- 	end
	-- end
	
	-- if currentArmatureBack._execute_after_influence_count > 0 then
	-- 	-- 重新进入
	-- 	executeAfterAttacking()
	-- 	return
	-- end
	
	-- local attData = _roundData.roundAttacksData[currentRoundAttackIndex]
	-- if (currentSkillInfluenceStartIndex < skillInfluenceCount) then
	-- 	currentSkillInfluenceStartIndex = currentSkillInfluenceStartIndex + 1
	-- 	executeAttacking()
	-- 	--executeAttack()
	-- 	return
	-- end

	-- changeActtackToAttackAfter(mPosTile._armature)
	-- if attackMovePos == 8 then
	-- 	mPosTile:setVisible(true)
	-- end
	--> print("当前角色攻击中段结束。")
end

-- 技能光效中段
function attack_logic.executeEffectSkillingOver(armatureBack)
	-- 准备清除技能光中段资源
	local currentArmatureBack = armatureBack._currentArmatureBack
	attack_logic.deleteEffectFile(armatureBack)
	attack_logic.executeHeroMoveToOriginTarget(currentArmatureBack)
		
	if BattleSceneClass._hasWidgetBg == true or BattleSceneClass._effectBg ~= nil then
		BattleSceneClass._effectBg:removeFromParent(true)
		BattleSceneClass._effectBg = nil
		BattleSceneClass._hasWidgetBg = nil
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
			effectIndex = 85
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
		armatureEffect = attack_logic.createEffect(backPad, effectIndex, backPad._camp, true)
		armatureEffect._invoke = attack_logic.deleteEffectFile
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
	attack_logic.deleteEffectFile(armatureBack)
end

-- 技能光效后段
function attack_logic.executeEffectSkillEnd(armatureBack)
	local armature = armatureBack
	local backPad = armature._base._posTile
	-- 技能光效后段
	-- local armatureBase = armature._base
	-- deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local bear_lighting_effect_id = armature._base._isReact == true 
		and 80 
		or attack_logic.get_camp_effect_id(skillInfluenceElementData, backPad._camp, skill_influence.bear_lighting_effect_id)	-- dms.atoi(skillInfluenceElementData, skill_influence.bear_lighting_effect_id)

	if bear_lighting_effect_id >= 0 then
		armatureEffect = attack_logic.createEffect(backPad, bear_lighting_effect_id, backPad._camp)
		armatureEffect._invoke = attack_logic.executeBuffEffect
		armatureEffect._base = armature._base
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
	end
	local bear_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.bear_sound_effect_id)
	if bear_sound_effect_id >= 0 then
		attack_logic.playEffectMusic(bear_sound_effect_id)
	end
end


-- --------------------------------------------------------------------- --
-- 清除BUFF
function attack_logic.cleanBuffEffectWithMiss(_posTile, _isMiss)
	-- 清除角色的BUFF
	if _posTile ~= nil and _posTile._buff ~= nil and _posTile._effectivenessId == 84 then
		for i, v in pairs(_posTile._buff) do
			if (v._LastsCountTurns ~= nil and v._LastsCountTurns >= 0) or _isMiss == true then
				v._LastsCountTurns = 0
				attack_logic.deleteEffectFile(v)
			end
		end
		_posTile._buff = {}
	end
end

function attack_logic.cleanBuffEffect(_posTile, _death)
	-- 清除角色的BUFF
	if _posTile ~= nil and _posTile._buff ~= nil then
		for i, v in pairs(_posTile._buff) do
			if (v._LastsCountTurns ~= nil and v._LastsCountTurns >= 0) or _death == true then
				v._LastsCountTurns = 0
				if v._LastsCountTurns <= 0 then
					-- 清除角色的BUFF
					attack_logic.deleteEffectFile(v)
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
function attack_logic.executeRoleDeath(armatureBack)
	-- 角色进行死亡帧
	local armature = armatureBack
	armature._isDeath = true
	armature._nextAction = animation_death
	-- armature._invoke = attackChangeActionCallback
	
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
						attack_logic.deleteEffectFile(v)
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
		attack_logic.show_role_hp(armature)
	else
		-- 我方角色死亡, 通知UI层更新状态
		-- 清除角色的BUFF
		if armatureBack ~= nil and armatureBack._posTile ~= nil and armatureBack._posTile._buff ~= nil then
			for i, v in pairs(armatureBack._posTile._buff) do
				if v ~= nil and v._LastsCountTurns ~= nil then
					v._LastsCountTurns = 0
					if v._LastsCountTurns <= 0 then
						-- 清除角色的BUFF
						attack_logic.deleteEffectFile(v)
						armatureBack._posTile._buff[i] = nil
					end
				end
			end
		end
	end
end
-- END~被攻击光效
-- --------------------------------------------------------------------- --

function attack_logic.checkFrameEvent(events, mode)
	if events ~= n and #events > 0 then
		for i, v in pairs(events) do
			if v == mode then
				return true
			end
		end
	end
	return false
end

function attack_logic.drawFrameEvent(armature, armatureBase, _def, bone,evt,originFrameIndex,currentFrameIndex)
	--> print("evt:", evt)
	if evt ~= nil and #evt > 0 then
		local datas = zstring.split(evt, "_")
		if attack_logic.checkFrameEvent(datas, "start") == true then
			local tempArmature = armatureBack
			if tempArmature == nil then
				tempArmature = bone:getArmature()
			end
			if tempArmature ~= nil and tempArmature._angle ~= nil then
				-- 创建飞行的光效
				--> print("绘制路径光效！！！")
				attack_logic.createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
			end
		end
		if attack_logic.checkFrameEvent(datas, "after") == true then
			-- 处理被攻击的后段光效
			armature._base = armatureBase
			attack_logic.executeEffectSkillEnd(armature)
		end
		if attack_logic.checkFrameEvent(datas, "hurt") == true then
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
	if defState == "0" then
		-- 命中的时候切换动作帧组
		changeToAction = _enum_animation_frame_index.animation_hero_by_attack + _tcamp
	elseif defState == "1" then
		-- 闪避的时候切换动作帧组
		changeToAction = animation_hero_miss + _tcamp
	elseif defState == "2" then
		-- 暴击的时候切换动作帧组
		changeToAction = _enum_animation_frame_index.animation_hero_by_attack + _tcamp
	elseif defState == "3" then
		-- 格挡的时候切换动作帧组
		--changeToAction = _enum_animation_frame_index.animation_hero_by_attack + _tcamp
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
			attack_logic.executeEffectSkillEnd(armature)
		end
	else
		-- 修改BUFF处理状态(6为中毒，9为灼烧)
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
				attack_logic.executeEffectSkillEnd(armature)
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
			-- attack_logic.executeEffectSkillEnd(armature)
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
			attack_logic.get_role_sp(armatureBase)
		end
	end
	
	
	local numberFilePath = nil
	-- 0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格
	if defState == "0" or defState == "3" or defState == "4" then
		-- 命中
		if defenderST == "1" or defenderST == "14" then
			numberFilePath = "images/ui/number/jiaxue.png"
			if armatureBase._role._hp ~= nil and drawString ~= nil and drawString ~= "" then 
				armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
			end
			attack_logic.get_role_hp(armatureBase)
		elseif defenderST == "2" or defenderST == "3" or 
			defenderST == "4" or defenderST == "5" or defenderST == "6" or 
			defenderST == "7" or defenderST == "8" or defenderST == "9" or 
			defenderST == "10" or defenderST == "11" or defenderST == "12" or defenderST == "13" or defenderST == "15" then
		else
			numberFilePath = "images/ui/number/xue.png"
			armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
			attack_logic.show_role_hp(armatureBase)
		end
	elseif defState == "1" then
		if defenderST == "0" then
			-- 闪避
			local miss = cc.Sprite:create("images/ui/battle/shanbi.png")
			miss:setAnchorPoint(cc.p(0.5, 0.5))
			miss:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
			_widget:getParent():addChild(miss, kZOrderInMap_Hurt)
			
			local seq = cc.Sequence:create(
				cc.MoveBy:create(0.2 * actionTimeSpeed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
				cc.CallFunc:create(attack_logic.removeFrameObjectFuncN)
			)
			miss:runAction(seq)
			cleanBuffEffectWithMiss(armatureBase._posTile,true)
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
			attack_logic.get_role_hp(armatureBase)
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
			
			local seq = cc.Sequence:create(
				cc.MoveBy:create(0.5 * actionTimeSpeed, cc.p(0, (defenderST == "2" and 1 or -1) * 100 / CC_CONTENT_SCALE_FACTOR())),
				cc.CallFunc:create(attack_logic.removeFrameObjectFuncN)
			)
			spSprite:runAction(seq)
		end
	end
	
	local labelAtlas = nil
	if numberFilePath ~= nil and drawString~= nil then
		labelAtlas = cc.LabelAtlas:_create(drawString, numberFilePath, 56 / CC_CONTENT_SCALE_FACTOR(), 70 / CC_CONTENT_SCALE_FACTOR(), 43)   
		-- labelAtlas:setProperty(drawString, numberFilePath, 56, 70, "+")
		labelAtlas:setAnchorPoint(cc.p(0.5, 0.5)) 
		labelAtlas:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0 + armature._hurtCount * ( 4))) 
		_widget:getParent():addChild(labelAtlas, kZOrderInMap_Hurt)
		
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
				cc.CallFunc:create(attack_logic.removeFrameObjectFuncN)
			)
		else
			seq = cc.Sequence:create(
				cc.DelayTime:create(30.0/60.0 * actionTimeSpeed),
				cc.ScaleTo:create(5.0/60.0 * actionTimeSpeed, 0.2),
				cc.CallFunc:create(attack_logic.removeFrameObjectFuncN)
			)
		end	
		labelAtlas:runAction(seq)
	
	end
	
	if defenderST == "0" then
		armature._hurtCount = armature._hurtCount + 1
	end
	
	-- 进入死亡状态
	if defAState == "1" and armatureBase ~= nil and 
		armatureBase._isDeath ~= true then
		attack_logic.executeRoleDeath(armatureBase)
	end
end

function attack_logic.excecuteFrameEvent(armatureBack, armatureBase, bone,evt,originFrameIndex,currentFrameIndex)
	local armature = armatureBack
	--> print("evt:", evt)
	-- if evt ~= nil and #evt > 0 then
		-- local datas = zstring.split(evt, "_")
		--> print(evt)
		-- if datas[1] == "start" then
			-- if armature._angle ~= nil then
				-- -- 创建飞行的光效
				-- attack_logic.createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
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
	if armatureBase._defs ~= nil then
		for i, v in pairs(armatureBase._defs) do
			attack_logic.drawFrameEvent(armature, armatureBase, v, bone,evt,originFrameIndex,currentFrameIndex)
		end
	else
		attack_logic.drawFrameEvent(armature, armatureBase, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
	end
end

function attack_logic.onFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
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
	
	attack_logic.excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
	
end

attack_logic.onFrameEvent1 = function(bone,evt,originFrameIndex,currentFrameIndex)
	attack_logic.onFrameEvent3(bone,evt,originFrameIndex,currentFrameIndex)
end

attack_logic.onFrameEvent2 = function(bone,evt,originFrameIndex,currentFrameIndex)
	attack_logic.onFrameEvent3(bone,evt,originFrameIndex,currentFrameIndex)
end

attack_logic.onFrameEvent3 = function(bone,evt,originFrameIndex,currentFrameIndex)
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
			--	attack_logic.excecuteFrameEvent(rPad._armature, rPad._armature, bone,evt,originFrameIndex,currentFrameIndex)
			--end
			erole[""..defender..">"..defenderPos] = rPad._armature
		end
	end
	for i, v in pairs(erole) do
		attack_logic.excecuteFrameEvent(v , v, bone,evt,originFrameIndex,currentFrameIndex)
	end
end
	
attack_logic.onFrameEvent4 = function(bone,evt,originFrameIndex,currentFrameIndex)
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
	
	attack_logic.excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
end

	
attack_logic.onFrameEvent5 = function(bone,evt,originFrameIndex,currentFrameIndex)
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
	
	attack_logic.excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
end

attack_logic.onFrameEvent6 = function(bone,evt,originFrameIndex,currentFrameIndex)
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
	
	attack_logic.excecuteFrameEvent(armature, armature._base, bone,evt,originFrameIndex,currentFrameIndex)
end


function attack_logic.get_role(_camp, _target_pos)
	local _role = "".._camp == "0" and attack_logic.__attackers[tonumber("".._target_pos)]:getParent() or attack_logic.__defenders[tonumber("".._target_pos)]:getParent()
	return _role
end

function attack_logic.reset_armature_state_data(armature)
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


function attack_logic.show_role_hp(armature)
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

function attack_logic.show_role_sp(armature)
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

function attack_logic.get_camp_effect_id(_skillInfluenceElementData, camp, effect_index)
	-- local camp = zstring.tonumber(camp)
	-- local effectIds = zstring.split(dms.atos(_skillInfluenceElementData, effect_index), ",")
	-- local effectId = zstring.tonumber(effectIds[camp])
	-- return effectId
	return dms.atoi(_skillInfluenceElementData, effect_index)
end

function attack_logic.change_action_to_attack_began(armatureBack)
	local armature = armatureBack
	local camp = zstring.tonumber(armature._camp) + 1
	local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.before_action), ",")
	local actionIndex = zstring.tonumber(indexs[camp])
	armature._nextAction = actionIndex
	-- armature._invoke = attackChangeActionCallback
	--> print("进入攻击前段：", actionIndex)
end

function attack_logic.change_action_to_attacking(armatureBack)
	local armature = armatureBack
	local camp = zstring.tonumber(armature._camp) + 1
	local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.after_action), ",")
	local actionIndex = zstring.tonumber(indexs[camp])
	armature._nextAction = actionIndex
	-- armature._invoke = attackChangeActionCallback
	--> print("进入攻击中段：", actionIndex)
end

function attack_logic.role_execute_attacking(armatureBack)
	local armature = armatureBack
	local skillQuality = dms.atoi(armatureBack._sed_action, skill_mould.skill_quality)	-- 技能类型(0:普通 1:怒气)
	local skillProperty = dms.atoi(armatureBack._sed_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local attackMovePos = armatureBack._attack_move_pos
	--> print("执行角色攻击逻辑：", attackMovePos)
	armatureBack._current_skill_influence_start_index = 1
	armatureBack._execute_after_influence_count = 0
	if attackMovePos == 0 or attackMovePos == 8 then
		if skillProperty == 0 then
             -- 远程攻击中段
			armatureBack._nextAction = _enum_animation_frame_index.animation_standby
			if armatureBack._isReact == true then
				-- 进行反击, 启动反击中段处理
				if armatureBack._byReactor ~= nil then
					-- 进行反击, 启动反击中段处理
					executeEffectSkilling(armatureBack._byReactor)
				end
			else
				attack_logic.execute_attacking(armatureBack)
			end
		else
			-- 技能攻击远程中段
			armatureBack._nextAction = _enum_animation_frame_index.animation_standby
			if executeAfterInfluenceCount > 0 then
				executeAfterAttacking()
			else
				attack_logic.execute_attacking(armatureBack)
			end
		end
	else
		if skillProperty == 0 then
			-- 近身攻击中段
			armatureBack._nextAction = _enum_animation_frame_index.animation_standby
			attack_logic.execute_attacking(armatureBack)
		else
			-- 技能近身攻击中段
			armatureBack._nextAction = _enum_animation_frame_index.animation_standby
			attack_logic.execute_attacking(armatureBack)
		end
	end
end

function attack_logic.execute_attacking(armatureBack)
	if armatureBack._current_skill_influence_start_index <= armatureBack._skill_influence_count then
		--> print(armatureBack._current_skill_influence_start_index)
		local recal = attack_logic.execute_attack_influence(armatureBack, armatureBack._skill_influences[armatureBack._current_skill_influence_start_index])
		if recal == 2 then
			armatureBack._current_skill_influence_start_index = armatureBack._current_skill_influence_start_index + 1
			attack_logic.execute_attacking(armatureBack)
		end
	else
		attack_logic.executeHeroMoveToOriginTarget()
	end
end

function attack_logic.execute_effect_skilling(currentArmatureBack, armatureBack)
	local armature = armatureBack
	local backPad = armature._posTile
	local mPosTile = currentArmatureBack._posTile
	-- 技能光效中段
	--local armatureBase = armature._base
	-- attack_logic.deleteEffectFile(armature)
	
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_id = attack_logic.get_camp_effect_id(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = attack_logic.createEffect(backPad, posterior_lighting_effect_id, currentArmatureBack._execute_after_influence_count > 0 and (tonumber(backPad._camp) + 1) % 2 or currentArmatureBack._camp)
		-- local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		--local armatureEffect = createEffect(backPad, posterior_lighting_effect_id, 0)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._currentArmatureBack = armature._currentArmatureBack
		if armature._sie == nil then
			armatureEffect._invoke = attack_logic.deleteEffectFile
		else
			armatureEffect._invoke = attack_logic.executeEffectSkillingOver
			armatureEffect:getAnimation():setFrameEventCallFunc(attack_logic.onFrameEvent)
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
			start_pos.x = start_pos.x + pSize.width * mPosTile:getScaleX()/2
			start_pos.y = start_pos.y + pSize.height * mPosTile:getScaleY()/2
			end_pos.x = end_pos.x + pSize.width * armature._posTile:getScaleX()/2
			end_pos.y = end_pos.y + pSize.height * armature._posTile:getScaleY()/2
			
			if lightingEffectDrawMethod == 0 then
				armatureEffect:setRotation(angle)
				armatureEffect:setPosition(start_pos)
				armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))

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
				attack_logic.drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
			end
			resetArmatureData(armature)
		else
			attack_logic.drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
			resetArmatureData(armature)
		end
		attack_logic.executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		attack_logic.playEffectMusic(posterior_lighting_sound_effect_id)
	end
end

function attack_logic.execute_attack_influence(armatureBack, skf)
	-- 执行被攻击中段
	local attackInfluencedCount = 0
	-- for j = currSkillInfluenceStartIndex, currSkillInfluenceCount do
	local _skf = skf --attData.skillInfluences[j]
	local skillInfluenceId 	= tonumber(_skf.skillInfluenceId) 					-- = npos(list)	--效用1ID
	local influenceType = _skf.influenceType		-- 效用类型(0:攻击 1:反击)
	local attackerType = _skf.attackerType			-- 效用发动者(出手方标识 0:我方 1:对方)
	local attackerPos = _skf.attackerPos			-- 效用发动者位置
	local currPosTile = nil-- armatureBack._current_role
	if attackerType == "1" then
		currPosTile = attack_logic.get_role(1, attackerPos)
	else
		currPosTile = attack_logic.get_role(0, attackerPos)
	end
		
	local defenderCount 	= _skf.defenderCount						-- = tonumber(npos(list))		-- 效用承受数量

	for w = 1, _skf.defenderCount do
		local _def = _skf._defenders[w]
		local defender = _def.defender
		local defenderPos = tonumber(_def.defenderPos)						
		local rPad = attack_logic.get_role(defender, defenderPos)
		attack_logic.reset_armature_state_data(rPad._armature)
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
	local posterior_lighting_effect_id = attack_logic.get_camp_effect_id(skillInfluenceElementData, influenceType, skill_influence.posterior_lighting_effect_id)	 -- dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
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
	--> print("lightingEffectDrawMethod:", lightingEffectDrawMethod)
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
		
		local rPad = attack_logic.get_role(defender, defenderPos)
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
					--? attackSectionNumber = attackSection
					--? attackTotalHarm = attackTotalHarm + tonumber(_def.stValue)
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
						--? BattleSceneClass.curDamage = BattleSceneClass.curDamage + tonumber(drawString)
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
						attack_logic.show_role_sp(rPad._armature)
					end
					
				elseif (defenderST == "0" or defenderST == "1" or defenderST == "6" or defenderST == "9") then
					rPad._armature._role._hp = rPad._armature._role._hp + tonumber(drawString)
					attack_logic.show_role_hp(rPad._armature)
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
	local roleCount = 0
	if executeDrawEffect == true then
		for i, v in pairs(erole) do
			if lightingEffectDrawMethod == 7 then
				executeEffectSkilling7(currPosTile._armature,v)
			else
				--> print("v:pos", v._pos, v._camp)
				attack_logic.execute_effect_skilling(currPosTile._armature, v)
			end
			roleCount = roleCount + 1
		end
		attackTargetCount = roleCount
		if roleCount <= 0 then
			attack_logic.executeHeroMoveToOriginTarget()
		elseif _skf.attTarList ~= nil then
			if lightingEffectDrawMethod ~= 7 then
				local ofsetCount = fightOverCount - _ED.battleData.battle_total_count + _ED.battleData._currentBattleIndex
				for a, t in pairs(_skf.attTarList) do
					local cPosTile
					if attacker == "0" then
						cPosTile = getRole(1, t) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%s", ofsetCount, t))
					else
						cPosTile = getRole(0, t) -- ccui.Helper:seekWidgetByName(BattleSceneClass._uiLayer,string.format("Panel_%d_%d", 0, t))
					end
					if cPosTile ~= nil then
						-- 无视攻击位置
						local effect = attack_logic.createEffect(cPosTile, posterior_lighting_effect_id, (tonumber(currPosTile._camp) + 1) % 2)
						effect._invoke = attack_logic.deleteEffectFile
						effect._LastsCountTurns = nil
					end
				end
			end
		end
	end
	--break
	-- end
end

function attack_logic.attack_change_action_callback(armatureBack)
	local armature = armatureBack
	if armature ~= nil then
		local actionIndex = armature._actionIndex
		if actionIndex == _enum_animation_frame_index.animation_standby then
			if armature._start_attack == true then
				armature._start_attack = false
				--> print("准备进入攻击前段")
				attack_logic.change_action_to_attack_began(armatureBack)
			end
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
			or actionIndex == _enum_animation_frame_index.animation_add_hp_buff
			or actionIndex == _enum_animation_frame_index.animation_combine_skill_effect
			or actionIndex == _enum_animation_frame_index.animation_lr_shake_skill_effect
			then	-- 所有的攻击前段部分
			attack_logic.change_action_to_attacking(armatureBack)
		elseif actionIndex == _enum_animation_frame_index.animation_melee_attacking		-- 近身攻击中段
			or actionIndex == _enum_animation_frame_index.animation_remote_attacking		-- 远程攻击中段
			or actionIndex == _enum_animation_frame_index.animation_melee_skilling			-- 技能近身攻击中段
			or actionIndex == _enum_animation_frame_index.animation_remote_skilling		-- 技能攻击远程中段
			or actionIndex == _enum_animation_frame_index.animation_heti1
			or actionIndex == _enum_animation_frame_index.animation_heti2
			or actionIndex == _enum_animation_frame_index.animation_enemy_melee_attacking
			or actionIndex == _enum_animation_frame_index.animation_enemy_remote_attacking
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
			then	-- 所有的攻击中段部分
			attack_logic.role_execute_attacking(armatureBack)
		elseif actionIndex == _enum_animation_frame_index.animation_melee_attack_end		 -- 近身攻击后段
			or actionIndex == _enum_animation_frame_index.animation_remote_attack_end		-- 远程攻击后段
			or actionIndex == _enum_animation_frame_index.animation_melee_skill_end		-- 技能攻击近身后段
			or actionIndex == _enum_animation_frame_index.animation_remote_skill_end		-- 技能远程攻击后段
			then		-- 所有的攻击后段部分
			roleExecuteAttackOver(armatureBack)	
		elseif actionIndex == animation_hero_by_attack then			-- 我方被攻击
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_emeny_by_attack then		-- 敌方被攻击
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_hero_miss then				-- 我方闪避
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_emeny_miss then				-- 我方闪避
			armatureBack._nextAction = animation_standby
		elseif actionIndex == animation_death then					-- 死亡
			deathBuff(armatureBack,armature)
		elseif actionIndex == death_buff then
		elseif actionIndex == death_buff_end then
		
		end
	end
end

function attack_logic.attack(roles, params, armature)
	attack_logic.__attackers = params[_enum_params_index.param_heros]
	attack_logic.__defenders = params[_enum_params_index.param_masters]
	armature._invoke = attack_logic.attack_change_action_callback
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
	state_machine.add(attack_logic_start_terminal)
    state_machine.init()
end

-- call func init fight attack logic state machine.
init_attack_logic_terminal()

