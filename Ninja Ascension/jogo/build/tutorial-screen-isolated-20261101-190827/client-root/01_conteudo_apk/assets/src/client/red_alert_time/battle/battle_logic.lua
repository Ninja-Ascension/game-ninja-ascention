-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗逻辑处理
-- ----------------------------------------------------------------------------------------------------
local kZOrderInMap_Effect		= 2000000	

battle_execute._setNextAction = function (armature, nextAction)
	armature._nextAction = nextAction
	if nil ~= armature._child_list then
		for i, v in pairs(armature._child_list) do
			v._nextAction = nextAction
		end
	elseif nil ~= armature._weapon then
		armature._weapon._nextAction = nextAction
	end
	-- print("设置帧组：", armature._camp, armature._pos, nextAction)
end

battle_execute._changeToAction = function(armature, nextAction)
	if armature._over == true then
		return
	end
	armature._actionIndex = animation_standby
	armature._nextAction = nextAction
	armature:getAnimation():playWithIndex(nextAction)
	armature._actionIndex = nextAction
	armature._nextAction = animation_standby
end

battle_execute._createStreak = function(armature)
    -- local streak = cc.MotionStreak:create(1.0, 15, 12, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), "effect/ms_0.png")
    -- local streak = cc.MotionStreak:create(0.5, 16, 16, cc.c3b(255,240,131), "effect/fire.png")
    local streak = cc.MotionStreak:create(0.5, 16, 16, cc.c3b(255,240,131), "effect/ms_0.png")
    -- streak:setAnchorPoint(cc.p(0.5, 1))
    streak:setFastMode(true)
    streak:setStartingPositionInitialized(true)
    streak:setPosition(cc.p(armature:getPosition()))
    armature:getParent():addChild(streak, kZOrderInMap_Effect - 1)
    armature._streak = streak

    -- effect_smoke
	-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effect_smoke/effect_smoke.ExportJson")
	-- local armatureSmoke = ccs.Armature:create("effect_smoke")
	-- armatureSmoke:getAnimation():playWithIndex(animation_standby)
	-- armatureSmoke:getAnimation():setMovementEventCallFunc(battle_changeAction_animationEventCallFunc)
	-- armatureSmoke:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
	-- armatureSmoke._invoke = battle_execute._deleteEffectFile
	-- armature:addChild(armatureSmoke)

    -- _emitter = ParticleSystemQuad::createWithTotalParticles(100);
    -- _emitter->retain();
    -- addChild(_emitter, 10);
    -- _emitter->setTexture(Director::getInstance()->getTextureCache()->addImage("Images/fire.png"));

    -- // duration
    -- _emitter->setDuration(ParticleSystem::DURATION_INFINITY);

    -- // radius mode
    -- _emitter->setEmitterMode(ParticleSystem::Mode::RADIUS);

    -- // radius mode: start and end radius in pixels
    -- _emitter->setStartRadius(50);
    -- _emitter->setStartRadiusVar(0);
    -- _emitter->setEndRadius(ParticleSystem::START_RADIUS_EQUAL_TO_END_RADIUS);
    -- _emitter->setEndRadiusVar(0);

    -- // radius mode: degrees per second
    -- _emitter->setRotatePerSecond(0);
    -- _emitter->setRotatePerSecondVar(0);


    -- // angle
    -- _emitter->setAngle(90);
    -- _emitter->setAngleVar(0);

    -- // emitter position
    -- auto size = Director::getInstance()->getWinSize();
    -- _emitter->setPosition(Vec2(size.width/2, size.height/2));
    -- _emitter->setPosVar(Vec2::ZERO);

    -- // life of particles
    -- _emitter->setLife(5);
    -- _emitter->setLifeVar(0);

    -- // spin of particles
    -- _emitter->setStartSpin(0);
    -- _emitter->setStartSpinVar(0);
    -- _emitter->setEndSpin(0);
    -- _emitter->setEndSpinVar(0);

    -- // color of particles
    -- Color4F startColor(0.5f, 0.5f, 0.5f, 1.0f);
    -- _emitter->setStartColor(startColor);

    -- Color4F startColorVar(0.5f, 0.5f, 0.5f, 1.0f);
    -- _emitter->setStartColorVar(startColorVar);

    -- Color4F endColor(0.1f, 0.1f, 0.1f, 0.2f);
    -- _emitter->setEndColor(endColor);

    -- Color4F endColorVar(0.1f, 0.1f, 0.1f, 0.2f);
    -- _emitter->setEndColorVar(endColorVar);

    -- // size, in pixels
    -- _emitter->setStartSize(16);
    -- _emitter->setStartSizeVar(0);
    -- _emitter->setEndSize(ParticleSystem::START_SIZE_EQUAL_TO_END_SIZE);

    -- // emits per second
    -- _emitter->setEmissionRate(_emitter->getTotalParticles() / _emitter->getLife());

    -- // additive
    -- _emitter->setBlendAdditive(false);
end

battle_execute._addChildSendBulletFunc = function( sender )
	sender.__attack_count = sender.__attack_count - 1
	local target = sender._targets[1]
	if nil == target then
		return
	end
	--> print(sender._child_tag)
	battle_execute._executeEffectSkillingWithBulletChildSend(target.__armature, 
		target.__backPad, 
		target.__currentPosTile, 
		target.__angle, 
		target.__executeAfterInfluenceCount,
		sender)
end

battle_execute._addChildSendBulletFuncR = function( sender )
	sender.__attack_count = sender.__attack_count - 1
	if sender.__attack_count < 0 then
		sender.__attack_count = 0
	end
	--> print(sender._child_tag)
	--> debug.print_r(sender._targets)
	local target = table.remove(sender._targets, 1)
	if nil == target then
		return
	end
	battle_execute._executeEffectSkillingWithBulletChildSend(target.__armature, 
		target.__backPad, 
		target.__currentPosTile, 
		target.__angle, 
		target.__executeAfterInfluenceCount,
		sender)
end

battle_execute._addChildSendBulletAction = function (armature, backPad, currentPosTile, executeAfterInfluenceCount, interval)
	for i, v in pairs(currentPosTile._armature._child_list) do
		local weapon = v
		weapon._targets = {}
		weapon.__attack_count = 0
	end
	for i, v in pairs(currentPosTile._armature._child_list) do
		local start_pos = cc.p(v._posTile:getPosition())
		local mx, my = v:getPosition()
		start_pos.x = start_pos.x + mx
		start_pos.y = start_pos.y + my
		--> print("----------->>>>:::>>", i, v._child_tag)
		local angle = CC_POSITIONS_TO_DEGREES(start_pos, cc.p(backPad:getPosition()))
		-- battle_execute._executeEffectSkillingWithBulletChildSend(target.__armature, 
		-- target.__backPad, 
		-- v, 
		-- tangle, 
		-- target.__executeAfterInfluenceCount,
		-- v)

 		local rotateAction = nil
		if currentPosTile._armature._camp == "1" then
			-- rotateAction = cc.RotateTo:create(interval, -1 * angle - 180);
			rotateAction = cc.RotateTo:create(interval, 180 + 1 * angle);
		else
			rotateAction = cc.RotateTo:create(interval, angle);
		end

		local weapon = v

		actions = {}
		
		table.insert(actions, cc.DelayTime:create(math.random(1, 10) * 0.3 / 10))

		table.insert(actions, rotateAction)

		table.insert(actions, cc.CallFunc:create(battle_execute._addChildSendBulletFunc))
		
		table.insert(actions, cc.DelayTime:create(math.random(1, 10) * 0.5 / 10))

		table.insert(actions, cc.CallFunc:create(battle_execute._addChildSendBulletFuncR))

		weapon._targets = weapon._targets or {}
		local target = {
				__armature = {_base = armature._base, _sie = armature._sie, _def = armature._def, _posTile = armature._posTile},
				__backPad = backPad,
				__currentPosTile = v,
				__angle = angle,
				__executeAfterInfluenceCount = executeAfterInfluenceCount,
				__tag = v._child_tag
			}
		target.__action = cc.Sequence:create(actions)
		target.__action:retain()

		table.insert(weapon._targets, target)
		weapon.__attack_count = weapon.__attack_count + 1

		if weapon.__attack_count == 1 then
			weapon:runAction(target.__action)
			target.__action:release()
		end
	end
end

battle_execute._executeEffectSkillingOverBullet = function ( armatureBack )
	if BattleSceneClass._isSkepBattle == true then
		-- --> print("executeEffectSkillingOver : 战斗跳过")
		-- -- battle_execute._deleteEffectFile(armatureBack)
		-- executeBuffEffect(armatureBack)
		return
	end
	if armatureBack._canext == true then
		armatureBack._canext = false
		attackTargetCount = 0

		-- 准备清除技能光中段资源
		local baseArmature = armatureBack._base
		-- battle_execute._battle_execute._deleteEffectFile(armatureBack)
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
			battle_execute._executeHeroMoveToOriginTarget()
		end
			
		if BattleSceneClass._hasWidgetBg == true or BattleSceneClass._effectBg ~= nil then
			BattleSceneClass._effectBg:removeFromParent(true)
			BattleSceneClass._effectBg = nil
			BattleSceneClass._hasWidgetBg = nil
		end
	end
	-- executeBuffEffect(armatureBack)
	-- --> print("技能光效中段结束")
end

battle_execute._executeEffectSkillingWithBulletEndEffect = function ( armatureBack )
	local armature = armatureBack
	local backPad = armature._base._posTile
	-- 技能光效后段
	-- local armatureBase = armature._base
	-- battle_execute._deleteEffectFile(armature)

	-- if armature.__currentPosTile._armature._call_next_role == true then
	-- 	armature.__currentPosTile._armature._call_next_role = false
	-- 	attackTargetCount = 0
	-- 	battle_execute._executeEffectSkillingOverBullet(armature)
	-- end
	
	local skillInfluenceElementData = armature._sie
	local bear_lighting_effect_id = armature._base._isReact == true 
		and 80 
		or battle_execute._getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.bear_lighting_effect_id)	-- dms.atoi(skillInfluenceElementData, skill_influence.bear_lighting_effect_id)
	--> print("技能光效后段:", bear_lighting_effect_id)
	if bear_lighting_effect_id >= 0 then
		if __lua_project_id == __lua_project_pacific_rim then
			if backPad._camp == "0" then
				bear_lighting_effect_id = bear_lighting_effect_id + 1
			end
		end
		armatureEffect = battle_execute._createEffect(backPad, bear_lighting_effect_id, backPad._camp)
		-- armatureEffect._invoke = executeBuffEffect
		armatureEffect._base = armature._base
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._defs = armature._defs
		armatureEffect._canext = armatureBack.__need_over
		armature.__currentPosTile._armature._call_next_role = false

		armatureEffect._invoke = executeBuffEffect -- battle_execute._executeEffectSkillingOverBullet
		-- armatureEffect._invoke = battle_execute._executeEffectSkillingOverBullet
		armatureEffect:getAnimation():setFrameEventCallFunc(battle_execute._onFrameEvent)

		if armatureBack._angle ~= nil then
			armatureEffect:setRotation(armatureBack._angle)
		end
	end
	local bear_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.bear_sound_effect_id)
	if nil ~= bear_sound_effect_id and bear_sound_effect_id >= 0 then
		if nil ~= battle_execute._playEffectMusic then
			playEffectMusic(bear_sound_effect_id)
		end
	end

	if __lua_project_id == __lua_project_pacific_rim then

	else
		if armature.__currentPosTile._armature._role._camp_preference == 1 then
			state_machine.excute("fight_map_attack_shake_action", 0, 0)
		end
	end
end

battle_execute._executeEffectSkillingWithBulletEndEffectSlot = function ( armatureBack )
	local armature = armatureBack
	local backPad = armature._base._posTile
	-- 技能光效后段
	-- local armatureBase = armature._base
	-- battle_execute._deleteEffectFile(armature)

	-- if armature.__currentPosTile._armature._call_next_role == true then
	-- 	armature.__currentPosTile._armature._call_next_role = false
	-- 	attackTargetCount = 0
	-- 	battle_execute._executeEffectSkillingOverBullet(armature)
	-- end
	
	local skillInfluenceElementData = armature._sie
	local bear_lighting_effect_id = armature._base._isReact == true 
		and 80 
		or battle_execute._getCampEffectId(skillInfluenceElementData, backPad._camp, skill_influence.bear_lighting_effect_id)	-- dms.atoi(skillInfluenceElementData, skill_influence.bear_lighting_effect_id)
	-- print("技能光效后段:", bear_lighting_effect_id)
	if bear_lighting_effect_id >= 0 then
		if __lua_project_id == __lua_project_pacific_rim then
			if backPad._camp == "0" then
				bear_lighting_effect_id = bear_lighting_effect_id + 1
			end
		end
		armatureEffect = battle_execute._createEffect(backPad, bear_lighting_effect_id, backPad._camp)
		-- armatureEffect._invoke = executeBuffEffect
		armatureEffect._base = armature._base
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._defs = armature._defs
		armatureEffect._canext = armatureBack.__need_over
		armature.__currentPosTile._armature._call_next_role = false

		armatureEffect:setPosition(cc.p(armatureBack:getPosition()))

		armatureEffect._invoke = battle_execute._deleteEffectFile -- executeBuffEffect -- battle_execute._executeEffectSkillingOverBullet
		-- armatureEffect._invoke = battle_execute._executeEffectSkillingOverBullet
		-- armatureEffect:getAnimation():setFrameEventCallFunc(battle_execute._onFrameEvent)

		if armatureBack._angle ~= nil then
			armatureEffect:setRotation(armatureBack._angle)
		end
	end
	local bear_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.bear_sound_effect_id)
	if nil ~= bear_sound_effect_id and bear_sound_effect_id >= 0 then
		if nil ~= battle_execute._playEffectMusic then
			playEffectMusic(bear_sound_effect_id)
		end
	end
	-- if armature.__currentPosTile._armature._role._camp_preference == 1 then
	-- 	state_machine.excute("fight_map_attack_shake_action", 0, 0)
	-- end
end

battle_execute._executeEffectSkillingWithBulletChild = function (armature, backPad, currentPosTile, angle, executeAfterInfluenceCount, weapon, offsetY)
	--> print("发射子弹 ：", armature._pos)
	local armatureBack = armature
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_ids = battle_execute._getCampEffectIds(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	local posterior_lighting_effect_id = tonumber(posterior_lighting_effect_ids[1])
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or currentPosTile._camp)
		-- local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		--local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, 0)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._defs = armature._defs
		armatureEffect._weapon = weapon
		armatureEffect.__currentPosTile = currentPosTile
		armatureEffect._angle = angle
		if armature._sie == nil then
			armatureEffect._invoke = battle_execute._deleteEffectFile
		else
			-- armatureEffect._invoke = executeEffectSkillingOver
			-- armatureEffect:getAnimation():setFrameEventCallFunc(battle_execute._onFrameEvent)
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
			local start_pos = cc.p(currentPosTile._posTile:getPosition())
			local mx, my = weapon:getPosition()
			start_pos.x = start_pos.x + mx
			start_pos.y = start_pos.y + my

			local end_pos = cc.p(armature._posTile:getPosition())
			local velocity = 5

			-- local pSize = currentPosTile:getContentSize()
			-- start_pos.x = start_pos.x + pSize.width * currentPosTile:getScaleX()/2
			-- start_pos.y = start_pos.y + pSize.height * currentPosTile:getScaleY()/2
			-- end_pos.x = end_pos.x + pSize.width * armature._posTile:getScaleX()/2
			-- end_pos.y = end_pos.y + pSize.height * armature._posTile:getScaleY()/2

			local mp = cc.p((end_pos.x - start_pos.x), (end_pos.y - start_pos.y))
		    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
		    local t = s / velocity * 0.013 / 2.3 * 0.5
		    if __lua_project_id == __lua_project_pacific_rim then
			    if currentPosTile._armature._role._camp_preference == 1 then
			    	t = t * 0.8
			    end
			end
			if currentPosTile._armature._role._camp_preference == 1 or true then
		    	--> print("draw bullet:", t, start_pos.x, start_pos.y, end_pos.x, end_pos.y, currentPosTile._armature._role._camp_preference)
		    	offsetY = offsetY or 0
		    	offsetX = offsetX or 0
			    local w = math.sin(3.1415927 / 2 * (angle / 90)) * offsetY
			    local h = math.cos(3.1415927 / 2 * (angle / 90)) * offsetY
				if currentPosTile._armature._camp == "1" then
					start_pos.x = start_pos.x + w
					start_pos.y = start_pos.y + h
					armatureEffect:setRotation(angle)
				else
					start_pos.x = start_pos.x + w
					start_pos.y = start_pos.y + h
					armatureEffect:setRotation(angle)
				end
				--> print("offsetY:::::::::::", offsetY, angle, w, h, (90 - angle), (90 - angle) / 90)
				armatureEffect:setScale(1.2)
				armatureEffect:setPosition(start_pos)

				armatureEffect:runAction(cc.Sequence:create(
					cc.Spawn:create(
						{
							cc.MoveTo:create(t, end_pos)
							-- , cc.ScaleTo:create(t / 4, 0.8)
						}), 
					cc.CallFunc:create(function ( sender )
					sender._weapon:runAction(cc.Sequence:create(cc.RotateTo:create(0.5, 0)))
					sender:removeFromParent(true)
				end)))
			end
		end
	end
	-- local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	-- if posterior_lighting_sound_effect_id >= 0 then
	-- 	battle_execute._playEffectMusic(posterior_lighting_sound_effect_id)
	-- end
end

battle_execute._executeEffectSkillingWithBullet = function (armature, backPad, currentPosTile, angle, executeAfterInfluenceCount, weapon, offsetY, offsetX)
	--> print("发射子弹 ：", armature._pos)
	local armatureBack = armature
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_ids = battle_execute._getCampEffectIds(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	local posterior_lighting_effect_id = tonumber(posterior_lighting_effect_ids[1])
	if posterior_lighting_effect_id >= 0 then		
		local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or currentPosTile._camp)
		-- local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		--local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, 0)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._defs = armature._defs
		armatureEffect._weapon = weapon
		armatureEffect.__currentPosTile = currentPosTile
		armatureEffect._angle = angle
		armatureEffect.__need_over = armatureBack.__need_over
		armatureBack.__need_over = false
		if armature._sie == nil then
			armatureEffect._invoke = battle_execute._deleteEffectFile
		else
			-- armatureEffect._invoke = executeEffectSkillingOver
			-- armatureEffect:getAnimation():setFrameEventCallFunc(battle_execute._onFrameEvent)
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
			local start_pos = cc.p(currentPosTile:getPosition())
			local end_pos = cc.p(armature._posTile:getPosition())
			local velocity = 5

			if __lua_project_id == __lua_project_pacific_rim then
			else
				if currentPosTile._armature._role._camp_preference == 4 then
					if nil ~= offsetX then
						start_pos.x = start_pos.x + offsetX
					end
				end
			end

			-- local pSize = currentPosTile:getContentSize()
			-- start_pos.x = start_pos.x + pSize.width * currentPosTile:getScaleX()/2
			-- start_pos.y = start_pos.y + pSize.height * currentPosTile:getScaleY()/2
			-- end_pos.x = end_pos.x + pSize.width * armature._posTile:getScaleX()/2
			-- end_pos.y = end_pos.y + pSize.height * armature._posTile:getScaleY()/2

			local mp = cc.p((end_pos.x - start_pos.x), (end_pos.y - start_pos.y))
		    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
		    local t = s / velocity * 0.013 / 2.3 * 0.25
		    
			if currentPosTile._armature._role._camp_preference == 1 or true then
		    	--> print("draw bullet:", t, start_pos.x, start_pos.y, end_pos.x, end_pos.y, currentPosTile._armature._role._camp_preference)
		    	offsetY = offsetY or 0
		    	offsetX = offsetX or 0
			    -- local w = math.sin(3.1415927 / 2 * (angle / 90)) * offsetY
			    -- local h = math.cos(3.1415927 / 2 * (angle / 90)) * offsetY
			    local w = 0
			    local h = 0
			    if __lua_project_id == __lua_project_pacific_rim then
			    	w = offsetX
			    	h = offsetY
			    	if currentPosTile._armature._role._camp_preference == 1 then
				    	t = t * 0.8
				    end
			    else
			    	w = math.sin(3.1415927 / 2 * (angle / 90)) * offsetY
			    	h = math.cos(3.1415927 / 2 * (angle / 90)) * offsetY
			    end
				if currentPosTile._armature._camp == "1" then
					start_pos.x = start_pos.x + w
					start_pos.y = start_pos.y + h


					if __lua_project_id == __lua_project_pacific_rim then
						angle = CC_POSITIONS_TO_DEGREES(start_pos, end_pos)
					end
					armatureEffect:setRotation(angle)
				else
					start_pos.x = start_pos.x + w
					start_pos.y = start_pos.y + h
					if __lua_project_id == __lua_project_pacific_rim then
						angle = CC_POSITIONS_TO_DEGREES(start_pos, end_pos)
					end
					armatureEffect:setRotation(angle)
				end
				--> print("offsetY:::::::::::", offsetY, angle, w, h, (90 - angle), (90 - angle) / 90)
				armatureEffect:setScale(1.2)
				armatureEffect:setPosition(start_pos)

				armatureEffect._camp_preference = currentPosTile._armature._role._camp_preference

				local moveAction = nil
				if armatureEffect._camp_preference == 4 then
					if __lua_project_id == __lua_project_pacific_rim then
						if nil ~= currentPosTile.atomic_bomb_pos then
							local armatureEffectBoom = battle_execute._createEffect(armatureEffect._posTile, posterior_lighting_effect_id.."_1", armatureEffect.__currentPosTile._camp)
							-- local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
							--local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, 0)
							armatureEffectBoom._posTile = backPad
							armatureEffectBoom._base = armature
							armatureEffectBoom._sie = armature._sie
							armatureEffectBoom._def = armature._def
							armatureEffectBoom._defs = armature._defs
							armatureEffectBoom._weapon = weapon
							armatureEffectBoom.__currentPosTile = currentPosTile
							armatureEffectBoom._angle = angle
							armatureEffectBoom.__need_over = armatureEffect.__need_over
							-- armatureBack.__need_over = false
							armatureEffectBoom._invoke = battle_execute._deleteEffectFile
							armatureEffectBoom:setPosition(currentPosTile.atomic_bomb_pos)

							local pos = currentPosTile.atomic_bomb_pos
							currentPosTile.atomic_bomb_pos = nil

							if armature._sie == nil then
								armatureEffectBoom._invoke = battle_execute._deleteEffectFile
							else
								armatureEffectBoom._invoke = battle_execute.executeBulletEffectSkillingOver
								armatureEffectBoom:getAnimation():setFrameEventCallFunc(battle_execute.onFrameEventBulletBoom)
							end

							local armatureEffectBoom_1 = battle_execute._createEffect(armatureEffect._posTile, posterior_lighting_effect_id.."_2", armatureEffect.__currentPosTile._camp, false, -kZOrderInMap_Effect)
							armatureEffectBoom_1._posTile = backPad
							armatureEffectBoom_1._base = armature
							armatureEffectBoom_1._sie = armature._sie
							armatureEffectBoom_1._def = armature._def
							armatureEffectBoom_1._defs = armature._defs
							armatureEffectBoom_1._weapon = weapon
							armatureEffectBoom_1.__currentPosTile = currentPosTile
							armatureEffectBoom_1._angle = angle
							armatureEffectBoom_1.__need_over = armatureEffect.__need_over
							armatureEffectBoom_1._invoke = battle_execute._deleteEffectFile
							armatureEffectBoom_1:setPosition(pos)
						end
					else
						armatureEffect._end_pos = end_pos
						t = s / velocity * 0.013
						-- local move_pos = cc.p(start_pos.x + (end_pos.x - start_pos.x) / 2 + math.random(-250, 250), start_pos.y + (end_pos.y - start_pos.y) / 2)
						local move_pos = cc.p(240 + math.random(-150, 150), start_pos.y + (end_pos.y - start_pos.y) / 3)
						armatureEffect._move_pos = move_pos
						moveAction = cc.BezierTo:create(t * __fight_recorder_action_time_speed, {start_pos, move_pos, end_pos})
						state_machine.excute("fight_add_bullet", 0, armatureEffect)

						battle_execute._createStreak(armatureEffect)
						t = t * 1.5
						armatureEffect._mt = 0
						armatureEffect._tt = t / 2
						armatureEffect._camp = tonumber(currentPosTile._armature._camp)
						armatureEffect._mp = start_pos

						local mangle = CC_POSITIONS_TO_DEGREES(move_pos, start_pos)
						armatureEffect:setRotation(mangle)
						armatureEffect:setVisible(false)
						armatureEffect._visible = false
					end
				else
					moveAction = cc.MoveTo:create(t, end_pos)
				end

				if nil ~= moveAction then
					armatureEffect:runAction(cc.Sequence:create(cc.Spawn:create({moveAction
						--, cc.ScaleTo:create(t / 4, 0.8)
						}), cc.CallFunc:create(function ( sender )
						--> print("绘制承受光效。")
						-- sender._base = armatureBase
						if sender._camp_preference == 4 then
							state_machine.excute("fight_remove_bullet", 0, sender)
						end

						local weapon = sender._weapon

						battle_execute._executeEffectSkillingWithBulletEndEffect(sender)
						
						sender:removeFromParent(true)

						--> print("复位")
						if __lua_project_id == __lua_project_pacific_rim then
						else
							if nil ~= sender._weapon._child_list then
								sender._weapon:runAction(cc.Sequence:create(cc.RotateTo:create(0.5, 0)))
							elseif sender._weapon.__attack_count == 0 then
								sender._weapon:runAction(cc.Sequence:create(cc.RotateTo:create(1.5, 0)))
							end
						end
					end)))
				end
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
		battle_execute._executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		if nil ~= battle_execute._playEffectMusic then
			battle_execute._playEffectMusic(posterior_lighting_sound_effect_id)
		end
	end
end

battle_execute._executeEffectSkillingWithBulletSlot = function (armature, backPad, currentPosTile, angle, executeAfterInfluenceCount, weapon, offsetY, offsetX, bulletDPos, isHaveRole)
	-- print("发射子弹 ：", armature._pos)
	local armatureBack = armature
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_ids = battle_execute._getCampEffectIds(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	local posterior_lighting_effect_id = tonumber(posterior_lighting_effect_ids[1])
	if posterior_lighting_effect_id >= 0 then
		if __lua_project_id == __lua_project_pacific_rim then
			if currentPosTile._armature._role._camp_preference == 1 then
				if isHaveRole == false then
					posterior_lighting_effect_id = "102_1"
				end
			end
		end

		local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or currentPosTile._camp)
		-- local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		--local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, 0)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._defs = armature._defs
		armatureEffect._weapon = weapon
		armatureEffect.__currentPosTile = currentPosTile
		armatureEffect._angle = angle
		armatureEffect.__need_over = armatureBack.__need_over
		armatureBack.__need_over = false
		if armature._sie == nil then
			armatureEffect._invoke = battle_execute._deleteEffectFile
		else
			-- armatureEffect._invoke = executeEffectSkillingOver
			-- armatureEffect:getAnimation():setFrameEventCallFunc(battle_execute._onFrameEvent)
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
			local start_pos = cc.p(currentPosTile:getPosition())
			local end_pos = bulletDPos -- cc.p(armature._posTile:getPosition())
			local velocity = 5

			if __lua_project_id == __lua_project_pacific_rim then
			else
				if currentPosTile._armature._role._camp_preference == 4 then
					if nil ~= offsetX then
						start_pos.x = start_pos.x + offsetX
					end
				end
			end

			-- local pSize = currentPosTile:getContentSize()
			-- start_pos.x = start_pos.x + pSize.width * currentPosTile:getScaleX()/2
			-- start_pos.y = start_pos.y + pSize.height * currentPosTile:getScaleY()/2
			-- end_pos.x = end_pos.x + pSize.width * armature._posTile:getScaleX()/2
			-- end_pos.y = end_pos.y + pSize.height * armature._posTile:getScaleY()/2

			local mp = cc.p((end_pos.x - start_pos.x), (end_pos.y - start_pos.y))
		    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
		    local t = s / velocity * 0.013 / 2.3 * 0.25

			if currentPosTile._armature._role._camp_preference == 1 or true then
		    	--> print("draw bullet:", t, start_pos.x, start_pos.y, end_pos.x, end_pos.y, currentPosTile._armature._role._camp_preference)
		    	offsetY = offsetY or 0
		    	offsetX = offsetX or 0
			    -- local w = math.sin(3.1415927 / 2 * (angle / 90)) * offsetY
			    -- local h = math.cos(3.1415927 / 2 * (angle / 90)) * offsetY
			    local w = 0
			    local h = 0
			    if __lua_project_id == __lua_project_pacific_rim then
			    	w = offsetX
			    	h = offsetY
			    	if currentPosTile._armature._role._camp_preference == 1 then
				    	t = t * 0.8
				    end
			    else
			    	w = math.sin(3.1415927 / 2 * (angle / 90)) * offsetY
			    	h = math.cos(3.1415927 / 2 * (angle / 90)) * offsetY
			    end
				if currentPosTile._armature._camp == "1" then
					start_pos.x = start_pos.x + w
					start_pos.y = start_pos.y + h

					if __lua_project_id == __lua_project_pacific_rim then
						angle = CC_POSITIONS_TO_DEGREES(start_pos, end_pos)
					end
					armatureEffect:setRotation(angle)
				else
					start_pos.x = start_pos.x + w
					start_pos.y = start_pos.y + h

					if __lua_project_id == __lua_project_pacific_rim then
						angle = CC_POSITIONS_TO_DEGREES(start_pos, end_pos)
					end
					armatureEffect:setRotation(angle)
				end
				--> print("offsetY:::::::::::", offsetY, angle, w, h, (90 - angle), (90 - angle) / 90)
				armatureEffect:setScale(1.2)
				armatureEffect:setPosition(start_pos)

				armatureEffect._camp_preference = currentPosTile._armature._role._camp_preference

				local moveAction = nil
				if armatureEffect._camp_preference == 4 then
					armatureEffect._end_pos = end_pos
					t = s / velocity * 0.013
					-- local move_pos = cc.p(start_pos.x + (end_pos.x - start_pos.x) / 2 + math.random(-250, 250), start_pos.y + (end_pos.y - start_pos.y) / 2)
					local move_pos = cc.p(240 + math.random(-150, 150), start_pos.y + (end_pos.y - start_pos.y) / 3)
					armatureEffect._move_pos = move_pos
					moveAction = cc.BezierTo:create(t * __fight_recorder_action_time_speed, {start_pos, move_pos, end_pos})
					state_machine.excute("fight_add_bullet", 0, armatureEffect)

					battle_execute._createStreak(armatureEffect)
					t = t * 1.5
					armatureEffect._mt = 0
					armatureEffect._tt = t / 2
					armatureEffect._camp = tonumber(currentPosTile._armature._camp)
					armatureEffect._mp = start_pos

					local mangle = CC_POSITIONS_TO_DEGREES(move_pos, start_pos)
					armatureEffect:setRotation(mangle)
					armatureEffect:setVisible(false)
					armatureEffect._visible = false
				else
					moveAction = cc.MoveTo:create(t, end_pos)
				end

				armatureEffect:runAction(cc.Sequence:create(cc.Spawn:create({moveAction
					--, cc.ScaleTo:create(t / 4, 0.8)
					}), cc.CallFunc:create(function ( sender )
					-- --> print("绘制承受光效。")
					-- -- sender._base = armatureBase
					-- if sender._camp_preference == 4 then
					-- 	state_machine.excute("fight_remove_bullet", 0, sender)
					-- end

					-- local weapon = sender._weapon

					battle_execute._executeEffectSkillingWithBulletEndEffectSlot(sender)
					
					sender:removeFromParent(true)

					-- --> print("复位")
					-- if nil ~= sender._weapon._child_list then
					-- 	sender._weapon:runAction(cc.Sequence:create(cc.RotateTo:create(0.5, 0)))
					-- elseif sender._weapon.__attack_count == 0 then
					-- 	sender._weapon:runAction(cc.Sequence:create(cc.RotateTo:create(1.5, 0)))
					-- end
				end)))
			end
		end
	else
		-- if armature._defs ~= nil then
		-- 	for i, v in pairs(armature._defs) do
		-- 		drawFrameEvent(armature, armature, v, bone,evt,originFrameIndex,currentFrameIndex)
		-- 	end
		-- 	resetArmatureData(armature)
		-- else
		-- 	drawFrameEvent(armature, armature, armature._def, bone,evt,originFrameIndex,currentFrameIndex)
		-- 	resetArmatureData(armature)
		-- end
		-- battle_execute._executeHeroMoveToOriginTarget()
	end
	local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
	if posterior_lighting_sound_effect_id >= 0 then
		if nil ~= battle_execute._playEffectMusic then
			battle_execute._playEffectMusic(posterior_lighting_sound_effect_id)
		end
	end
end

battle_execute.executeBulletEffectSkillingChildSendOver = function(armatureBack)
	battle_execute._deleteEffectFile(armatureBack)
end

battle_execute.executeBulletEffectSkillingOver = function(armatureBack)
	battle_execute._deleteEffectFile(armatureBack)
end

battle_execute.onFrameEventBulletChild = function(bone,evt,originFrameIndex,currentFrameIndex)
	--> print("onFrameEventBullet evt:", evt)
	if BattleSceneClass._isSkepBattle == true then
		return
	end
	if evt ~= nil and #evt > 0 then
		local datas = zstring.split(evt, "_")

		local armature = bone:getArmature()--._base
		local armatureBase = armature._base

		if battle_execute._checkFrameEvent(datas, "send") == true then
			battle_execute._executeEffectSkillingWithBulletChild(armatureBase, 
				armature.__backPad, 
				armature.__currentPosTile, 
				armature.__angle, 
				armature.__executeAfterInfluenceCount, 
				armature.__weapon, armature._height, armature._width)
		end

		-- if battle_execute._checkFrameEvent(datas, "next") == true then
		-- 	--> print("攻击下一个目标")
		-- 	local weapon = armature.__currentPosTile._armature
		-- 	if nil ~= weapon and #weapon._targets > 0 then
		-- 		local target = weapon._targets[1]
		-- 		weapon:runAction(target.__action)
		-- 		target.__action:release()
		-- 	else
		-- 		armature.__currentPosTile._armature._call_next_role = true
		-- 		-- -- --> print("下一个角色进行攻击", armature.__currentPosTile._armature._camp, armature.__currentPosTile._armature._pos)
		-- 		-- if armature.__currentPosTile._armature._call_next_role == true then
		-- 		-- 	armature.__currentPosTile._armature._call_next_role = false
		-- 		-- 	attackTargetCount = 0
		-- 		-- 	battle_execute._executeEffectSkillingOverBullet(armature)
		-- 		-- end
		-- 	end
		-- end
	end
end

battle_execute.onFrameEventBulletBoom = function(bone,evt,originFrameIndex,currentFrameIndex)
	--> print("onFrameEventBulletBoom evt:", evt)
	if BattleSceneClass._isSkepBattle == true then
		return
	end
	if evt ~= nil and #evt > 0 then
		local datas = zstring.split(evt, "_")

		local armature = bone:getArmature()--._base
		local armatureBase = armature._base

		if battle_execute._checkFrameEvent(datas, "hurt") == true then
			-- local sender = armature
			-- if sender._camp_preference == 4 then
			-- 	state_machine.excute("fight_remove_bullet", 0, sender)
			-- end

			local weapon = armature._weapon

			battle_execute._executeEffectSkillingWithBulletEndEffect(armature)

			armature.__need_over = false
			weapon.__attack_count = 0

			if nil ~= weapon and #weapon._targets > 0 then
				while (#weapon._targets > 0) do
					local target = table.remove(weapon._targets, 1)
					if nil ~= target.__action then
						target.__action:release()
						target.__action = nil
					end

					armature._posTile = target.__backPad
					armature._base = target.__armature
					armature.__currentPosTile = target.__currentPosTile
					armature._sie = target.__armature._sie
					armature._def = target.__armature._def
					armature._defs = target.__armature._defs
					battle_execute._executeEffectSkillingWithBulletEndEffect(armature)
				end
			end
		end
	end
end

battle_execute.onFrameEventBullet = function(bone,evt,originFrameIndex,currentFrameIndex)
	-- print("onFrameEventBullet evt:", evt)
	if BattleSceneClass._isSkepBattle == true then
		return
	end
	if evt ~= nil and #evt > 0 then
		local datas = zstring.split(evt, "_")

		local armature = bone:getArmature()--._base
		local armatureBase = armature._base

		if battle_execute._checkFrameEvent(datas, "send") == true then
			if armature.__currentPosTile._armature._role._camp_preference == 1 
				or armature.__currentPosTile._armature._role._camp_preference == 3
				then
				-- state_machine.excute("fight_map_attack_shake_action", 0, 0)
				if __lua_project_id == __lua_project_pacific_rim then
					-- state_machine.excute("fight_map_attack_bullet_shake_action", 0, 0)
					local tx = datas[2]
					local dpos = armature._dposs[tx]
					if nil ~= dpos then
						armature._width = dpos.x
						armature._height = dpos.y
					end
					-- 计算子弹的落点
					if battle_execute._checkFrameEvent(datas, "d") == true then
						armature._dc = armature._dc or 0
						armature._dc = armature._dc + 1
						-- print(evt, armature._dc, armature.__currentPosTile._camp, armature.__backPad._armature._pos)

						if armature.__currentPosTile._armature._role._camp_preference == 3 then
							if armature._dc == 1 then
								-- print("当前目标", armature.__backPad._camp)
							else
								local weapon = armature.__currentPosTile._armature._weapon
								if nil ~= weapon and #weapon._targets > 0 then
									local target = weapon._targets[1]
									-- if armature._dc == ((target.__backPad._armature._pos - 1) % 3 + 1) then
										-- print(evt, target.__backPad._armature._pos)
										armatureBase = target.__armature
										armature.__backPad = target.__backPad
										armature.__currentPosTile = target.__currentPosTile
										armature.__angle = target.__angle
										armature.__executeAfterInfluenceCount = target.__executeAfterInfluenceCount
										target = table.remove(weapon._targets, 1)
										weapon.__attack_count = weapon.__attack_count - 1
										if target.__action ~= nil then
											target.__action:release()
											target.__action = nil
										end
									-- else
									-- 	return
									-- end
								else
									return
								end
							end
						else
							if armature._dc == ((armature.__backPad._armature._pos - 1) % 3 + 1) then
								-- print("当前目标", armature.__backPad._camp)
							else
								local weapon = armature.__currentPosTile._armature._weapon
								if nil ~= weapon and #weapon._targets > 0 then
									local target = weapon._targets[1]
									if armature._dc == ((target.__backPad._armature._pos - 1) % 3 + 1) then
										armatureBase = target.__armature
										armature.__backPad = target.__backPad
										armature.__currentPosTile = target.__currentPosTile
										armature.__angle = target.__angle
										armature.__executeAfterInfluenceCount = target.__executeAfterInfluenceCount
										target = table.remove(weapon._targets, 1)
										weapon.__attack_count = weapon.__attack_count - 1
										if target.__action ~= nil then
											target.__action:release()
											target.__action = nil
										end
									else
										return
									end
								else
									if armature.__currentPosTile._armature._role._camp_preference == 1 then
										battle_execute._executeEffectSkillingWithBulletSlot(armatureBase, 
											armature.__backPad, 
											armature.__currentPosTile, 
											armature.__angle, 
											armature.__executeAfterInfluenceCount, 
											armature.__weapon, armature._height, armature._width, armature.__currentPosTile._bullet_slots[tx], armature.__currentPosTile._bullet_role_slots[tx])
									end
									return
								end
							end
						end
					else
						if armature.__currentPosTile._armature._role._camp_preference == 1 then
							battle_execute._executeEffectSkillingWithBulletSlot(armatureBase, 
								armature.__backPad, 
								armature.__currentPosTile, 
								armature.__angle, 
								armature.__executeAfterInfluenceCount, 
								armature.__weapon, armature._height, armature._width, armature.__currentPosTile._bullet_slots[tx], armature.__currentPosTile._bullet_role_slots[tx])
						end
						return
					end
				end
			end
			if armature.__currentPosTile._armature._role._camp_preference == 2 then
			else
				local mx, my = armature.__currentPosTile._armature._node:getPosition()
				-- effice_sendcircle
				local armatureEffect = battle_execute._createEffect(armature.__currentPosTile, "sendcircle", armature.__currentPosTile._camp, true, -1, mx, my)
				armatureEffect._invoke = battle_execute._deleteEffectFile
			end

			if __lua_project_id == __lua_project_pacific_rim then
				if armature.__currentPosTile._armature._role._camp_preference == 2 then
					if true ~= armature.__currentPosTile._armature.__start_back then
						armature.__currentPosTile._armature.__start_back = true
					end
					-- if nil ~= armature.__currentPosTile.__back_pos then
					-- 	armature.__currentPosTile:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(armature.__currentPosTile.__back_pos)), cc.CallFunc:create(function ( sender )
							
					-- 	end)))
					-- 	armature.__currentPosTile.__back_pos = nil
					-- end
				else
					armatureBase.__need_over = armature.__need_over
					armature.__need_over = false
				end
			else
				armatureBase.__need_over = armature.__need_over
				armature.__need_over = false
			end

			battle_execute._executeEffectSkillingWithBullet(armatureBase, 
				armature.__backPad, 
				armature.__currentPosTile, 
				armature.__angle, 
				armature.__executeAfterInfluenceCount, 
				armature.__weapon, armature._height, armature._width)
		end

		if battle_execute._checkFrameEvent(datas, "next") == true 
			then
			--> print("攻击下一个目标", armature.__currentPosTile._armature._child_tag)
			local weapon = armature.__currentPosTile._armature._weapon

			if nil ~= weapon and #weapon._targets > 0 then
				local target = weapon._targets[1]
				if target.__action ~= nil then
					weapon:runAction(target.__action)
					target.__action:release()
					target.__action = nil
				end
			else
				armature.__currentPosTile._armature._call_next_role = true
				-- -- --> print("下一个角色进行攻击", armature.__currentPosTile._armature._camp, armature.__currentPosTile._armature._pos)
				-- if armature.__currentPosTile._armature._call_next_role == true then
				-- 	armature.__currentPosTile._armature._call_next_role = false
				-- 	attackTargetCount = 0
				-- 	battle_execute._executeEffectSkillingOverBullet(armature)
				-- end
			end
		end

		if battle_execute._checkFrameEvent(datas, "change") == true 
			then
			if armature.__needChange == true then
				-- armature:setVisible(false)
				battle_execute.executeBulletEffectSkillingOver(armature)
			end
		end
	end
end

battle_execute._executeEffectSkillingWithBulletChildSend = function (armature, backPad, currentPosTile, angle, executeAfterInfluenceCount, weapon)
	--> print("承受都 ：", armature._pos)
	local armatureBack = armature
	local skillInfluenceElementData = armature._sie
	--> print("executeAfterInfluenceCount:", executeAfterInfluenceCount)
	local posterior_lighting_effect_ids = battle_execute._getCampEffectIds(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	local posterior_lighting_effect_id = tonumber(posterior_lighting_effect_ids[2])
	if posterior_lighting_effect_id > 0 then
		local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or currentPosTile._camp)
		-- local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		--local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, 0)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._defs = armature._defs
		armatureEffect._weapon = weapon
		if armature._sie == nil then
			armatureEffect._invoke = battle_execute._deleteEffectFile
		else
			armatureEffect._invoke = battle_execute.executeBulletEffectSkillingChildSendOver
			armatureEffect:getAnimation():setFrameEventCallFunc(battle_execute.onFrameEventBulletChild)
		end

		--> print("----------->>", currentPosTile._armature._child_tag)

		armatureEffect.__armature = armature
		armatureEffect.__backPad = backPad
		armatureEffect.__currentPosTile = currentPosTile
		armatureEffect.__angle = angle
		armatureEffect.__executeAfterInfluenceCount = executeAfterInfluenceCount
		armatureEffect.__weapon = weapon

		local start_pos = cc.p(currentPosTile._posTile:getPosition())

		local mx, my = weapon._node:getPosition()
		start_pos.x = start_pos.x + mx
		start_pos.y = start_pos.y + my

		armatureEffect:setRotation(angle)
		armatureEffect:setPosition(start_pos)      

		-- currentPosTile._armature._actionIndex = animation_standby
		-- currentPosTile._armature:getAnimation():playWithIndex(animation_send_bullet)
		-- currentPosTile._armature._nextAction = animation_standby
		battle_execute._changeToAction(currentPosTile._armature, animation_send_bullet)
	end
end

battle_execute._executeEffectSkillingWithBulletSend = function (armature, backPad, currentPosTile, angle, executeAfterInfluenceCount, weapon)
	-- print("_executeEffectSkillingWithBulletSend 承受者 ：", armature._pos)
	local armatureBack = armature
	local skillInfluenceElementData = armature._sie
	local posterior_lighting_effect_ids = battle_execute._getCampEffectIds(skillInfluenceElementData, backPad._camp, skill_influence.posterior_lighting_effect_id)	--dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
	local posterior_lighting_effect_id = tonumber(posterior_lighting_effect_ids[2])
	if posterior_lighting_effect_id > 0 then
		local cPos = tonumber(currentPosTile._pos)
		if __lua_project_id == __lua_project_pacific_rim then
			if 1 == cPos or 4 == cPos then
				posterior_lighting_effect_id = posterior_lighting_effect_id + 200
			elseif 3 == cPos or 6 == cPos then
				posterior_lighting_effect_id = posterior_lighting_effect_id + 300
			end

			if currentPosTile._camp == "1" then
				posterior_lighting_effect_id  = posterior_lighting_effect_id + 1
			end
		end

		local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, executeAfterInfluenceCount > 0 and (tonumber(backPad._camp) + 1) % 2 or currentPosTile._camp)
		-- local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, backPad._camp)
		--local armatureEffect = battle_execute._createEffect(backPad, posterior_lighting_effect_id, 0)
		armatureEffect._posTile = backPad
		armatureEffect._base = armature
		armatureEffect._sie = armature._sie
		armatureEffect._def = armature._def
		armatureEffect._weapon = weapon
		if armature._sie == nil then
			armatureEffect._invoke = battle_execute._deleteEffectFile
		else
			armatureEffect._invoke = battle_execute.executeBulletEffectSkillingOver
			armatureEffect:getAnimation():setFrameEventCallFunc(battle_execute.onFrameEventBullet)
		end

		armatureEffect.__armature = armature
		armatureEffect.__backPad = backPad
		armatureEffect.__currentPosTile = currentPosTile
		armatureEffect.__angle = angle
		armatureEffect.__executeAfterInfluenceCount = executeAfterInfluenceCount
		armatureEffect.__weapon = weapon
		local beAttackCount = 0
		if __lua_project_id == __lua_project_pacific_rim then
			if currentPosTile._armature._skf ~= nil then
				for w = 1, currentPosTile._armature._skf.defenderCount do
					local _def = currentPosTile._armature._skf._defenders[w]
					local defender = tonumber(_def.defender)
					local defenderPos = tonumber(_def.defenderPos)
					if _def.stVisible == "1" then
						if tonumber(defender) == tonumber(currentPosTile._camp)
							and tonumber(defenderPos) == tonumber(currentPosTile._pos)
							then
						else
							beAttackCount = beAttackCount + 1
						end
					end
				end
			end
			if beAttackCount < 2 then
				armatureEffect.__needChange = true
			end
		end

		-- armatureEffect.__need_over = false
		-- if #weapon._targets == 0 then
		-- 	armatureEffect.__need_over = true
		-- end
		armatureEffect.__need_over = weapon.__need_over
		weapon.__need_over = false

		local start_pos = cc.p(currentPosTile:getPosition())
		local mx, my = weapon._node:getPosition()
		start_pos.x = start_pos.x + mx
		start_pos.y = start_pos.y + my

		if __lua_project_id == __lua_project_pacific_rim then
		else
			if nil ~= armatureEffect._width then
				start_pos.x = start_pos.x + armatureEffect._width
			end
			armatureEffect:setRotation(angle)
		end
		armatureEffect:setPosition(start_pos)

		--> print("animation_send_bullet start", animation_send_bullet)
		-- currentPosTile._armature._actionIndex = animation_remote_attack_began

		if __lua_project_id == __lua_project_pacific_rim then
			local attackActionIndex = animation_remote_attack_began
			local pos = tonumber(currentPosTile._armature._pos)
			if currentPosTile._armature._role._camp_preference == 1 
				or currentPosTile._armature._role._camp_preference == 3
				then
				if pos == 1 or pos == 4 then
					attackActionIndex = animation_left_remote_attack_began
				elseif pos == 3 or pos == 6 then
					attackActionIndex = animation_right_remote_attack_began
				end
			end
			if beAttackCount < 2 and currentPosTile._armature._role._camp_preference == 3 then
				attackActionIndex = animation_remote_attack_began_1
				if pos == 1 or pos == 4 then
					attackActionIndex = animation_left_remote_attack_began_1
				elseif pos == 3 or pos == 6 then
					attackActionIndex = animation_right_remote_attack_began_1
				end
			end
			if currentPosTile._armature._actionIndex == animation_remote_attack_began 
				or currentPosTile._armature._actionIndex == animation_left_remote_attack_began_1 
				or currentPosTile._armature._actionIndex == animation_right_remote_attack_began_1 
				or currentPosTile._armature._actionIndex == attack_1 
				or currentPosTile._armature._actionIndex == left_attack_1 
				or currentPosTile._armature._actionIndex == right_attack_1 
				then

			else
				battle_execute._changeToAction(currentPosTile._armature, attackActionIndex)
				-- print("animation_send_bullet end", animation_remote_attack_began)
				if nil ~= armature._child_list then
					-- for i, v in pairs(armature._child_list) do
						
					-- end
				elseif nil ~= currentPosTile._armature._weapon then
					-- currentPosTile._armature._weapon._actionIndex = animation_remote_attack_began
					battle_execute._changeToAction(currentPosTile._armature._weapon, attackActionIndex)
				end
				--> print("animation_send_bullet end", animation_remote_attack_began)
			end
		else
			battle_execute._changeToAction(currentPosTile._armature, animation_remote_attack_began)
			--> print("animation_send_bullet end", animation_remote_attack_began)
			if nil ~= armature._child_list then
				-- for i, v in pairs(armature._child_list) do
					
				-- end
			elseif nil ~= currentPosTile._armature._weapon then
				-- currentPosTile._armature._weapon._actionIndex = animation_remote_attack_began
				battle_execute._changeToAction(currentPosTile._armature._weapon, animation_remote_attack_began)
			end
			--> print("animation_send_bullet end", animation_remote_attack_began)
		end
	else
		battle_execute._executeEffectSkillingWithBullet(armature, backPad, currentPosTile, angle, executeAfterInfluenceCount, weapon)
	end
end

battle_execute._attackChangeActionCallback = function(armatureBack)
	local armature = armatureBack
	armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
	if armature ~= nil then
		local actionIndex = armature._actionIndex
		if armature._over == true then
			armature._nextAction = animation_moving
		end
		if actionIndex == animation_standby then
			if true == armature.__start_back then
				armature.__start_back = false
				if nil ~= armature._posTile.__back_pos then
					armature:setVisible(false)
					armature._back_armature:setVisible(true)
					armature._back_armature._nextAction = animation_moving
                    armature._back_armature:getAnimation():playWithIndex(animation_moving)
					armature._posTile:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(armature._posTile.__back_pos)), cc.CallFunc:create(function ( sender )
						sender._armature:setVisible(true)
						sender._armature._back_armature:setVisible(false)
						battle_execute._executeHeroMoveToOriginTarget()
					end)))
					armature._posTile.__back_pos = nil
				end
			end
		elseif actionIndex == animation_moving then

		elseif actionIndex == animation_remote_attack_began then

		elseif actionIndex == animation_death then
			if __lua_project_id == __lua_project_pacific_rim then
				if armature._vv == nil then
					armature._vv = true
					if nil ~= armature._armatureDizziness then
						armature._armatureDizziness:removeFromParent(true)
					end
					if nil ~= armature._heroInfoWidget 
						and nil ~= armature._heroInfoWidget.removeFromParent
						then
						armature._heroInfoWidget:removeFromParent(true)
						armature._heroInfoWidget = nil
					end
				else
					armature._posTile:setVisible(false)
				end
			else
				armature._posTile:setVisible(false)
			end
		end
	end
end
-- ----------------------------------------------------------------------------------------------------