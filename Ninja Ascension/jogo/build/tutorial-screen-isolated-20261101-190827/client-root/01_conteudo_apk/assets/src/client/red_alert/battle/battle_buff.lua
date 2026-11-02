-- ----------------------------------------------------------------------------------------------------
-- 说明：承受BUFF特效
-- ----------------------------------------------------------------------------------------------------
BattleBuff = class("BattleBuffClass", Window)
local execute_over = {}

local battle_buff_create_terminal = {
	add = function (role, accepter)
		
	end,
	_name = "battle_buff_create",
	_init = function (terminal)
	
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		-- 效果是否可以叠加
		local role = params[1]
		local accepter = params[2]
		-- local buffAdditioalCount = accepter.skill.buff_additioal_count
		local nCount = 0
		if tonumber(accepter.skill.skill_influence_type) == 52 then
			for i, v in pairs(role._buffs) do
				if v._accepter ~= nil and tonumber(v._accepter.skill.skill_influence_type) == tonumber(accepter.skill.skill_influence_type) then
					nCount = nCount + 1
				end
			end
		end
		if nCount > 0 then
			return
		end
		-- if nCount > 0 
		-- 	and buffAdditioalCount > 0
		-- 	and buffAdditioalCount <= nCount 
		-- 	then
		-- 	battle_logic.skill_influence_over["" .. accepter.skill.skill_influence_type](
		-- 		accepter.attacker, 
		-- 		accepter.defender, 
		-- 		accepter.skill, 
		-- 		accepter, 
		-- 		accepter.attackType, 
		-- 		accepter.battleType)
		-- 	return false
		-- end
		-- if buffAdditioalCount == -1 then
		-- 	for i, v in pairs(role._buffs) do
		-- 		if v._accepter ~= nil and v._accepter.skill.skill_influence_type == accepter.skill.skill_influence_type then
		-- 			battle_logic.skill_influence_over["" .. v._accepter.skill.skill_influence_type](
		-- 				v._accepter.attacker, 
		-- 				v._accepter.defender, 
		-- 				v._accepter.skill, 
		-- 				v._accepter, 
		-- 				v._accepter.attackType, 
		-- 				v._accepter.battleType)
		-- 			state_machine.excute("battle_buff_remove", 0, v)
		-- 			table.remove(role._buffs, i, 1)
		-- 		end
		-- 	end
		-- end
		return BattleBuff:new():init(params)
	end,
	_terminal = nil,
	_terminals = nil
}

local battle_buff_add_terminal = {
	add = function (role, accepter)
		
	end,
	_name = "battle_buff_add",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local buff = params
		buff:add()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local battle_buff_execute_terminal = {
	add = function (role, accepter)
		
	end,
	_name = "battle_buff_execute",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local buff = params
		buff:execute()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local battle_buff_over_terminal = {
	add = function (role, accepter)
	
	end,
	_name = "battle_buff_over",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local buff = params
		buff:over()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local battle_buff_remove_terminal = {
	add = function (role, accepter)
	
	end,
	_name = "battle_buff_remove",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local buff = params
		if buff ~= nil then
			if buff._sprites ~= nil then
				for i, v in pairs(buff._sprites) do
					v:removeFromParent(true)
				end
			end
			buff._sprites = nil

			buff._duration = 0
			buff._influenceDuration = 0
			buff._role:setStopAttackCount(-1)
			buff:release()
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(battle_buff_create_terminal)
state_machine.add(battle_buff_add_terminal)
state_machine.add(battle_buff_execute_terminal)
state_machine.add(battle_buff_over_terminal)
state_machine.add(battle_buff_remove_terminal)
state_machine.init()

function BattleBuff:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var 
	self._role = nil

	self._accepter = nil

	self._is_over = false

	self._duration = nil
	
	self._elapsed = 0

	self._influenceDuration = nil

	self._influenceElapsed = 0

	self._sprites = {}

	self.need_tigger_buff = true
end

function BattleBuff:init(params)
	self._role = params[1]
	self._accepter = params[2]
	if self:isOver() == false then
		self._influenceDuration = self._accepter.skill.buff_duration
		table.insert(self._role._buffs, self)
		self:retain()
	end

	self._duration = self._accepter.skill.influence_duration
	if self._accepter.skill.skill_influence_type == 63 then
		self.need_tigger_buff = false
	else
		self.need_tigger_buff = true
	end

	if self._accepter.skill.skill_influence_type == 0 		--伤害
		or self._accepter.skill.skill_influence_type == 1	--治疗
		then
		self:drawOneRoundEffect()
	elseif self._accepter.skill.skill_influence_type == 8	--沉默
		or self._accepter.skill.skill_influence_type == 26	--降低受到伤害
		or self._accepter.skill.skill_influence_type == 38	--复活
		or self._accepter.skill.skill_influence_type == 52	--伤害吸收护盾
		or self._accepter.skill.skill_influence_type == 53	--不死
		then
		self:changeStateBuffEffect(false)
	elseif self._accepter.skill.skill_influence_type == 5  -- 眩晕
		or self._accepter.skill.skill_influence_type == 54 -- 混乱
		or self._accepter.skill.skill_influence_type == 55 -- 冰冻
		then
		self:changeStateBuffEffect(true)
	elseif self._accepter.skill.skill_influence_type == 14
		or self._accepter.skill.skill_influence_type == 51
		or self._accepter.skill.skill_influence_type == 36
		or self._accepter.skill.skill_influence_type == 37
		or self._accepter.skill.skill_influence_type >= 56
		then
	else
		BattleBuff.drawTextureAction(self._role, self:getDrawTexture(self._accepter.skill.skill_influence_type))
	end
	return self
end

function BattleBuff:execute()
	battle_logic["" .. self._accepter.skill.skill_influence_type](
		self._accepter.attacker, 
		self._accepter.defender, 
		self._accepter.skill, 
		self._accepter, 
		self._accepter.attackType, 
		self._accepter.battleType)
	self:draw()
end

function BattleBuff:isOver()
	if self:checkOver() == true then
		state_machine.excute("battle_role_remove_buff", 0, {role = self._role, buff = self})
		self._is_over = true
		-- self:over()
	end
	return self._is_over or false
end

function BattleBuff:over()
	-- 效果结束是否会触发另外的效果
	-- print(self._role._shipName)
	-- print(self._accepter)
	-- print(self._accepter.skill)
	-- print(self._accepter.skill.skill_influence_type)

	battle_logic.skill_influence_over["" .. self._accepter.skill.skill_influence_type](
		self._accepter.attacker, 
		self._accepter.defender, 
		self._accepter.skill, 
		self._accepter, 
		self._accepter.attackType, 
		self._accepter.battleType)

	-- 当某效用结束时，触发效用
	local currentSkill = self._accepter.skill
	local skills = self._role._buff_skills[battle_enum._skill_influence_trigger._influence_over]

	if (self.need_tigger_buff == nil or self.need_tigger_buff == true) 
		and skills ~= nil 
		then
		for i, v in pairs(skills) do
			if v ~= nil then
				if v ~= currentSkill
					and zstring.tonumber(v.trigger_need_value) == currentSkill.id
					then
					state_machine.excute("battle_role_execute_buff_skill", 0, {self._role, v})
				end
				if v.influences ~= nil then
					for k,v1 in pairs(v.influences) do
						if v1 ~= nil
							and v1 ~= currentSkill
							and zstring.tonumber(v1.trigger_need_value) == currentSkill.id
							then
							state_machine.excute("battle_role_execute_buff_skill", 0, {self._role, v1})
						end
					end
				end
			end
		end
	end

	-- 当某效用结束时，某buff也跟随结束
	for i, v in pairs(self._role._buffs) do
		if v ~= self then
        	-- if v._accepter.skill.trigger_timing == battle_enum._skill_influence_trigger._normal 
        	-- 	and v._accepter.skill.trigger_need_value == currentSkill.id
        	-- 	then
        	-- 	state_machine.excute("battle_role_execute_buff_skill", 0, {self._role, v})
        	-- else
	        	if v._accepter ~= nil 
	        		and v._accepter.skill.influence_over_condition == 1
		        	and v._accepter.skill.influence_over_need_param == currentSkill.id
		        	then
		        	v._duration = 0
					v._influenceDuration = 0
					state_machine.excute("battle_role_remove_buff", 0, {role = v._role, buff = v})
	        	end
        	-- end
        end
    end

	if self._sprites ~= nil then
		for i, v in pairs(self._sprites) do
			v:removeFromParent(true)
		end
	end
	self._sprites = nil

	if self._accepter.skill.skill_influence_type == 5  -- 眩晕
		or self._accepter.skill.skill_influence_type == 54 -- 混乱
		or self._accepter.skill.skill_influence_type == 55 -- 冰冻
		then
		self._role:setStopAttackCount(-1)
	end
	self:release()
end

function BattleBuff:checkOver()
	-- print("self._accepter.skill.influence_over_condition:", self._accepter.skill.influence_over_condition)
	if self._accepter.skill.influence_over_condition < 0 then
		return true
	end

	return false
end

function BattleBuff:drawOneRoundEffect()
	if tonumber(self._accepter.skill.buff_effect) > 0 then
		local baseName = "effect/buff_" .. self._accepter.skill.buff_effect
		-- print("drawOneRoundEffect:", baseName)
		local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)

	    skeletonNode:registerSpineEventHandler(function (event)
	        event.skeletonAnimation:removeFromParent(true)
	    end, sp.EventType.ANIMATION_COMPLETE)

	    skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
	    self._role:addChild(skeletonNode)
	end
end

function BattleBuff:changeStateBuffEffect(changeDlE)
	if tonumber(self._accepter.skill.buff_effect) > 0 then
		local baseName = "effect/buff_" .. self._accepter.skill.buff_effect
		-- print("changeStateBuffEffect:", baseName)
		local skeletonNode = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)

	    -- skeletonNode:registerSpineEventHandler(function (event)
	    --     event.skeletonAnimation:removeFromParent(true)
	    -- end, sp.EventType.ANIMATION_COMPLETE)

	    skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
	    self._role:addChild(skeletonNode)

	    table.insert(self._sprites, skeletonNode)
	end

	if changeDlE == true then
    	self._role:changeActionToIDLE()
   	end
end

function BattleBuff:getDrawTexture(influenceType)
	return string.format("images/ui/battle/battle_buff_%s.png", influenceType)
end

local function removeDrawAntNumberFuncN(sender)
	sender:removeFromParent(true)
end

function BattleBuff.drawTextureAction(role, fileName)
	local hScale = 1.0
	local miss = cc.Sprite:createWithSpriteFrameName(fileName)
	if miss == nil then
		cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_he.png")
    	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_he.plist")
    	miss = cc.Sprite:createWithSpriteFrameName(fileName)
	end
	miss:setAnchorPoint(cc.p(0.5, 0.5))
	miss:setPosition(cc.p(role._move_pos.x, role._move_pos.y + 90))
	role._parent:addChild(miss, _scene_zorder_miss)
	miss:setScale(hScale * 0.5)
	miss:setOpacity(0)

	-- local seq = cc.Sequence:create(
	--	 cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, 100)),
	--	 cc.CallFunc:create(removeDrawAntNumberFuncN)
	-- )
	miss:runAction(cc.Sequence:create({
			cc.Spawn:create({cc.MoveBy:create(10 / 60 * __fight_recorder_action_time_speed, cc.p(0, 30)),
					cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, hScale * 1.1),
					cc.FadeTo:create(10 / 60 * __fight_recorder_action_time_speed, 255)
				}),
			cc.ScaleTo:create(9 / 60 * __fight_recorder_action_time_speed, hScale * 1.0),
			cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
			cc.FadeTo:create(20 / 60 * __fight_recorder_action_time_speed, 0),
			cc.CallFunc:create(removeDrawAntNumberFuncN)
		}))
end

function BattleBuff:onEnterTransitionFinish()

end

function BattleBuff:onUpdate(dt)
	if self._influenceDuration ~= nil
		and self._influenceDuration > 0
		then
        self._influenceElapsed = self._influenceElapsed + dt
        if self._influenceElapsed >= self._influenceDuration then
        	self._influenceElapsed = 0
            state_machine.excute("battle_buff_execute", 0, self)
            if self._accepter.skill.influence_over_condition == 3 then
            	self._duration = 0
            	state_machine.excute("battle_role_remove_buff", 0, {role = self._role, buff = self})
            end
        end
    end
    if self._duration ~= nil 
    	and self._duration > 0
    	then
        self._elapsed = self._elapsed + dt
        if self._elapsed >= self._duration then
            state_machine.excute("battle_role_remove_buff", 0, {role = self._role, buff = self})
        end
    end
end

function BattleBuff:close()

end

function BattleBuff:destroy()

end

-- 当某效用结束时，去触发角色的其他效用
function BattleBuff.influenceOver(role, influence)
	local skills = role._buff_skills[battle_enum._skill_influence_trigger._influence_over]
	if skills ~= nil and #skills > 0 then
		for i, v in pairs(skills) do
			if v.trigger_need_value == influence.id then

			end
		end
	end
end
-- ----------------------------------------------------------------------------------------------------