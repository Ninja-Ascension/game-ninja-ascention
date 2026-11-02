DemoHero = class("DemoHeroClass", Window)
DemoHero._Panel_size = nil
local _enum_animation_frame_index = _enum_animation_frame_index or {
    animation_down = 0,
    animation_left = 1,
    animation_up = 3,
    animation_right = 2,
}

function DemoHero:ctor()
    self.super:ctor()
    self.roots = {}
    self.parent = nil
    self.index = 0
    self.armature = nil
    self.changeState = false
    self.changeDownCount = 0                    -- 变身时切换到向下状态的次数
    self.shadow = nil   
    self.shadowScale = 0                         -- 影子
    self.actionTimeSpeed = 2
    if DemoHero._Panel_size == nil then 
        DemoHero._Panel_size = cc.size(34,34)
    end
    self:setContentSize(DemoHero._Panel_size)
    self.headId = 0
end

function DemoHero:init(parent, index, headId)
    self.parent = parent
    self.index = index
    self.headId = headId

    self:registerOnNodeEvent(self)
    
    self:onLoad()
    return self
end

function DemoHero:onLoad()
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. self.headId .. ".ExportJson")

    self:onInit()

    -- self:registerOnNodeEvent(self)
end


function DemoHero:onInit()
    if self.armature ~= nil then
        self.armature:removeFromParent(true)
        self.armature = nil
    end
    local armature = AdventureSpriteBattle:create(self.headId, 9) -- ccs.Armature:create("spirte_" .. self.headId)
    
    local armatureSize = armature:getContentSize()
    --self:setContentSize(armatureSize)
    local size = self:getContentSize()
    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    -- armature._actionIndex = _enum_animation_frame_index.animation_right
    -- 初始化朝向
    armature._actionIndex = _enum_animation_frame_index.animation_up
    armature._nextAction = _enum_animation_frame_index.animation_up
    armature._invoke = self.changeActionCallback
    armature._self = self

    armature:getAnimation():playWithIndex(armature._actionIndex)
    armature:setScale(2)
    armature:setAnchorPoint(cc.p(0.5,0.0))
    self.armature = armature
    armature:setPosition(cc.p(0, -size.height-5))

    -- 旋转90度
    self:setRotation(90)
    self:addChild(armature)
end

function DemoHero:onEnterTransitionFinish()
    local shadow = cc.Sprite:create("images/ui/bg/shadow.png")
    self.parent:addChild(shadow, -1)
    local pos = cc.p(self:getPosition())
    shadow:setPosition(cc.p(pos.x ,pos.y))
    -- 旋转90
    shadow:setRotation(90)
    self.shadow = shadow
    self.shadow:setScale(self.shadowScale)
end

-- 开始切换角色
function DemoHero:setShadowScale(scaleNumber)
    self.shadowScale = scaleNumber
end

-- 开始切换角色
function DemoHero:changeRole()
    self.changeState = true
    self.actionTimeSpeed = 0.2
    self.armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
end

-- 切换角色完毕
function DemoHero:changeRoleOver()
    self.changeState = false
    self.actionTimeSpeed = 2
    self.armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)

    -- self.armature:getBone("v"):addDisplay(roleIcon, 0)

    local instance = self.parent
    local headId = instance:getHeroHead(self.headId)
    if headId ~= self.headId then
        self.headId = headId
        self:onLoad()
    end
end

function DemoHero.changeActionCallback(armatureBack)
    local armature = armatureBack
    if armature ~= nil then
        local role = armature._self
        local actionIndex = armature._actionIndex
        if actionIndex == _enum_animation_frame_index.animation_down then
            if role.changeDownCount < 1 then
                armature._nextAction = _enum_animation_frame_index.animation_left
                role.changeDownCount = role.changeDownCount + 1
            else
                armature._nextAction = _enum_animation_frame_index.animation_right
                role.changeDownCount = 0
                
                role:changeRoleOver()
            end     
        elseif actionIndex == _enum_animation_frame_index.animation_left then
            armature._nextAction = _enum_animation_frame_index.animation_up
        elseif actionIndex == _enum_animation_frame_index.animation_up then
            -- 朝上就不切帧
            -- armature._nextAction = _enum_animation_frame_index.animation_right
			if role.changeState then
                armature._nextAction = _enum_animation_frame_index.animation_down
            end
        elseif actionIndex == _enum_animation_frame_index.animation_right then
            armature._nextAction = _enum_animation_frame_index.animation_up
        end
    end
end