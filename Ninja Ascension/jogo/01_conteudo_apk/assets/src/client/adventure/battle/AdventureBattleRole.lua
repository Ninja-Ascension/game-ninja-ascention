-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗的角色
-------------------------------------------------------------------------------------------------------
AdventureBattleRole = class("AdventureBattleRoleClass", Window)
    
function AdventureBattleRole:ctor()
    self.super:ctor()
    self.roots = {}

    self.actionTimeSpeed = 1

    -- Initialize adventure battle role state machine.
    local function init_adventure_battle_role_terminal()
        state_machine.init()
    end
    
    -- call func init adventure battle role state machine.
    init_adventure_battle_role_terminal()
end

function AdventureBattleRole:init(parent, size, roleCamp, brole)
    self.parent = parent
    self:setContentSize(cc.size(size.width, size.height))

    self.roleCamp = roleCamp

    self._info = brole
    self._brole = brole
    self._erole = {_type = self._info._type}
    self._role = nil

    self:onLoad()
	return self
end

function AdventureBattleRole.changeActionCallback(armatureBack)
    local armature = armatureBack
    local fightRole = armature._self
    if armature ~= nil then
        local actionIndex = armature._actionIndex
        if actionIndex == _enum_animation_adventure_frame_index.animation_down then -- 向下
        elseif actionIndex == _enum_animation_adventure_frame_index.animation_left then -- 向左
            -- armature._nextAction = _enum_animation_adventure_frame_index.animation_down
        elseif actionIndex == _enum_animation_adventure_frame_index.animation_right then -- 向右
            -- armature._nextAction = _enum_animation_adventure_frame_index.animation_down
        elseif actionIndex == _enum_animation_adventure_frame_index.animation_up then -- 向上
            -- armature._nextAction = _enum_animation_adventure_frame_index.animation_down
        elseif actionIndex == _enum_animation_adventure_frame_index.animation_be_attaked then -- 承受
            armature._nextAction = _enum_animation_adventure_frame_index.animation_down
        elseif actionIndex == _enum_animation_adventure_frame_index.animation_win_action then -- 胜利
        elseif actionIndex == _enum_animation_adventure_frame_index.animation_is_death then -- 死亡
            -- fightRole:getParent():setVisible(false)
            fightRole:removeFromParent(true)
            state_machine.excute("adventure_battle_execute_battle_over", 0, 0)
        end
    end
end

function AdventureBattleRole:onLoad()
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_"..self._brole._head..".ExportJson")

    self:onInit()

    self:registerOnNodeEvent(self)
end

function AdventureBattleRole:onInit()
    local size = self:getContentSize()
    
    local armature = AdventureSpriteBattle:create(self._brole._head, 9) -- ccs.Armature:create("spirte_" .. self._brole._head)
    local flag = -1
    self.parent = nil
    
    if self.roleCamp == 1 then
        armature:setScaleX(-1)
        flag = 1
    end
   
    armature:setPositionX(size.width / 2)
    armature:setPositionY(0)
    
    armature:setAnchorPoint(cc.p(0.5,0.0))
    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)


    armature._actionIndex = _enum_animation_l_frame_index.animation_standby
    armature._nextAction = _enum_animation_l_frame_index.animation_standby
    armature:getAnimation():playWithIndex(armature._actionIndex)
    armature._invoke = self.changeActionCallback
    
    -- ui
    armature._self = self
    armature._camp = self.roleCamp

    -- self
    self.armature = armature
    
    ---------------------------------------------------------------------------
    -- hero information widget (show hp , sp , name , type) 
    ---------------------------------------------------------------------------
    armature._pos = self._info._pos
    armature._role = {}
    armature._role._id = self._info._id
    armature._role._mouldId = self._info._mouldId
    armature._role._type = self._info._type
    armature._role._name = self._info._name
    armature._role._hp = self._info._hp
    armature._role._sp = self._info._sp
    armature._role._quality = self._info._quality
    armature._brole = self._info
    
    self:addChild(armature)

    local shadow = cc.Sprite:create("images/ui/bg/shadow.png")
    shadow:setScale(0.5)
    self:addChild(shadow, -1)
    shadow:setPosition(cc.p(armature:getPositionX(),size.height / 2 ))
    
    self.shadow = shadow

    -- 角色影子
    -- local shadow = cc.Sprite:create("sprite/spirte_2442.png")
    -- shadow:setTextureRect(cc.rect(0, 0, 193, 89))
    -- shadow:setAnchorPoint(cc.p(0.5, 0.5))
    -- shadow:setPosition(cc.p(size.width / 2, 0))
    -- shadow:setOpacity(100)
    -- self:addChild(shadow)
    -- self.shadow = shadow
end

function AdventureBattleRole:onEnterTransitionFinish()
	
end

function AdventureBattleRole:onExit()

end