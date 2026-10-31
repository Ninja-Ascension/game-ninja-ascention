DemoMonster = class("DemoMonsterClass", Window)

local _enum_animation_frame_index = _enum_animation_frame_index or {
    animation_down = 0,
    animation_left = 1,
    animation_up = 3,
    animation_right = 2,
}

local _enum_monster_state = _enum_monster_state or {
    state_walk = 0,
    state_byAttack = 1,
    state_fly = 2,
    state_die = 3,
}

function DemoMonster:ctor()
    self.super:ctor()
    self.roots = {}
    self.parent = nil
    self.armature = nil
    self.actionTimeSpeed = 2
    self.velocity = cc.p(0, 0)
    self.accelerate = cc.p(0, 0)
    self.groundY = cc.p(0, 0)
    self.shadow = nil                   -- 影子
    self.flyRotate = false              -- 击飞时是否旋转
    self.attackInterval = 0.1           -- 攻击间隔
    self.attackElapse = 0               
    self.state = _enum_monster_state.state_walk
    self.rotatedirection = 1
    self.headId = 0
    self:setRotation(90)
	self.scaleNumber = 0
end

function DemoMonster:init(parent, groundy, headId)
    self.parent = parent
    self.velocity.x = math.random(-60, -40)
    self.groundY = groundy

    self.headId = headId

    self:onLoad()
    return self
end

function DemoMonster:onLoad()
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" ..  self.headId .. ".ExportJson")

    self:onInit()

    self:registerOnNodeEvent(self)
end

function DemoMonster:onInit()
    local armature = AdventureSprite:create(self.headId, 9) -- ccs.Armature:create("spirte_" ..  self.headId)
    
    local armatureSize = armature:getContentSize()
    self:setContentSize(armatureSize)

    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    -- armature._actionIndex = _enum_animation_frame_index.animation_left
    -- 修改面向朝下
    armature._actionIndex = _enum_animation_frame_index.animation_down
    armature._nextAction = _enum_animation_frame_index.animation_down
    armature._invoke = self.changeActionCallback
    armature._self = self

    armature:getAnimation():playWithIndex(armature._actionIndex)
    armature:setScale(2)
    
    self.armature = armature

    self:addChild(armature)
end

function DemoMonster:onEnterTransitionFinish()
    -- Note：影子加入父节点
    local shadow = cc.Sprite:create("images/ui/bg/shadow.png")
    self.parent:addChild(shadow, -1)
    shadow:setPosition(self:getPosition())
    -- 将影子旋转90度
    shadow:setRotation(90)
    self.shadow = shadow
end


function DemoMonster:update(dt)
    if self.state == _enum_monster_state.state_die then
        return
    end

    self:updatePositionLogic(dt)
    local curX, curY = self:getPosition()

    -- 进入被攻击区域
    if self.state == _enum_monster_state.state_walk and
       math.abs(curX) < self.parent.attackAreaX then
        self.state = _enum_monster_state.state_byAttack

        state_machine.excute("world_role_controller_play_attack_effect", 0, "")        
    end

    if self.state == _enum_monster_state.state_byAttack then
        self:byAttackLogic(dt)
    end

    -- 从被攻击状态退到攻击区域以外，执行击飞逻辑
    if self.state == _enum_monster_state.state_byAttack and
       math.abs(curX) > self.parent.attackAreaX then
       self:flyLogic()
       
    end

    -- 飞到屏幕以外，执行死亡逻辑
    if self.state == _enum_monster_state.state_fly and
       curX > self.parent.monsterDeadAreaX then
       self:dieLogic()
    end
end

function DemoMonster:updatePositionLogic(dt)
    self.velocity.x = self.velocity.x + self.accelerate.x * dt
    self.velocity.y = self.velocity.y + self.accelerate.y * dt

	if self.accelerate.y >= 0 and self.scaleNumber < 0.72 then
		self.scaleNumber = self.scaleNumber+0.02
		self:setScale(self.scaleNumber)
        self.shadow:setScale(self.scaleNumber)

	end
    local x, y = self:getPosition()
    local newX = x + self.velocity.x * dt
    local newY = y + self.velocity.y * dt
 
    -- 触地逻辑
    if newY < self.groundY then
        newY = self.groundY
        self.velocity.y = math.abs(self.velocity.y) * 0.8           -- 以原速度的80%反弹
    end
   
    if self.flyRotate == false then 
        self:setPosition(newX, newY) 
    end

    -- 更新影子位置
    if self.shadow then
        self.shadow:setPosition(newX, self.groundY)
    end
end

function DemoMonster:byAttackLogic(dt)
    self.accelerate.x = 200

    -- 被攻击时每隔一段时间攻击一次
    self.attackElapse = self.attackElapse + dt
    if self.attackElapse >= self.attackInterval then
        self.attackElapse = 0

        local x, y = self:getPosition()
        self:setPosition(x - math.random(5, 10), y)
    end
end

function DemoMonster:flyLogic()
    self.state = _enum_monster_state.state_fly

    self.accelerate.x = 0
    
    local direction = math.random(0, 50)    
    local offY = math.random(50,180)
    local toPos = cc.p(680,390)

    if direction > 25 then 
        toPos.y = 390 + offY
    else 
        toPos.y = -390 + offY
    end
	
    local function playOver()
        self:dieLogic()
    end
    
    local actions  = cc.MoveTo:create(2.5,toPos)
    self.flyRotate = true
    local seq = cc.Sequence:create(actions,cc.CallFunc:create(playOver))  
    
    self:runAction(seq)
    self.actionTimeSpeed = 0.4
    self.armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
	-- 在这里隐藏影子,因为其他地方有删除工作
	self.shadow:setVisible(false); 
end

function DemoMonster:dieLogic()
    self.state = _enum_monster_state.state_die
end

function DemoMonster:isDead()
    return self.state == _enum_monster_state.state_die
end

function DemoMonster.changeActionCallback(armatureBack)
    local armature = armatureBack
   -- self.bgIndex = math.random(1, 10)
    if armature ~= nil then
        local role = armature._self
        local actionIndex = armature._actionIndex

        if actionIndex == _enum_animation_frame_index.animation_down then
            if role.flyRotate then
                armature._nextAction = _enum_animation_frame_index.animation_left
				armature:setAnchorPoint(CCPoint(0.5, 0.5))
				armature:setRotation(180)
            end
		elseif actionIndex == _enum_animation_frame_index.animation_left then	
			armature._nextAction = _enum_animation_frame_index.animation_up
			armature:setAnchorPoint(CCPoint(0.5, 0.5))
			armature:setRotation(270)
        elseif actionIndex == _enum_animation_frame_index.animation_up then
            armature._nextAction = _enum_animation_frame_index.animation_right
			armature:setAnchorPoint(CCPoint(0.5, 0.5))
			armature:setRotation(360)
        elseif actionIndex == _enum_animation_frame_index.animation_right then
            armature._nextAction = _enum_animation_frame_index.animation_down
			armature:setAnchorPoint(CCPoint(0.5, 0.5))
			armature:setRotation(90)
        end
    end
end