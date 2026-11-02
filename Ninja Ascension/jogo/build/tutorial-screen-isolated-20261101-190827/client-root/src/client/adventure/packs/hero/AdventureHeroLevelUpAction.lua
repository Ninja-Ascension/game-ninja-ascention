-- ----------------------------------------------------------------------------------------------------
-- 说明：武将列表，武将升级动画
-------------------------------------------------------------------------------------------------------
AdventureHeroLevelUpAction = class("AdventureHeroLevelUpActionClass", Window)
    
function AdventureHeroLevelUpAction:ctor()
    self.super:ctor()
    self.roots = {}

    self.pos = cc.p(0, 0)

    -- Initialize adventure hero level up action state machine.
    local function init_adventure_hero_level_up_action_terminal()
        state_machine.init()
    end
    
    -- call func init adventure hero level up action state machine.
    init_adventure_hero_level_up_action_terminal()
end

function AdventureHeroLevelUpAction:init(dx, dy, cell)
    self.pos = cc.p(dx, dy)
	self._rootWindows = cell
    return self
end

function AdventureHeroLevelUpAction:playAnimation()
    local root = self.roots[1]
    local Panel_12 = ccui.Helper:seekWidgetByName(root, "Panel_12")
    local ArmatureNode_1 = Panel_12:getChildByName("ArmatureNode_1")
    local function changeActionCallback(armatureBack)
        -- armatureBack._self:updateDraw()
        -- armatureBack:setVisible(false)
        -- armatureBack._invoke = nil
        -- fwin:close(fwin:find("AdventureHeroLevelUpActionClass"))
		fwin:close(armatureBack._self)
    end
    ArmatureNode_1:setVisible(true)
    csb.animationChangeToAction(ArmatureNode_1, 0, 0, nil)
    ArmatureNode_1._invoke = changeActionCallback
end

function AdventureHeroLevelUpAction:onEnterTransitionFinish()
    local csbAdventureHeroLevelUpAction = csb.createNode("utils/prompt_donghua.csb")
    local root = csbAdventureHeroLevelUpAction:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroLevelUpAction)

    -- self:setPosition(self.pos)

    -- local action = csb.createTimeline("utils/prompt_donghua.csb")
    -- csbAdventureHeroLevelUpAction:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end

    --     local str = frame:getEvent()
    --     if str == "role_shengji_over" then
    --         fwin:close(self)
    --     end
    -- end)

    -- 初始化动画文件
    local Panel_12 = ccui.Helper:seekWidgetByName(root, "Panel_12")
    local ArmatureNode_1 = Panel_12:getChildByName("ArmatureNode_1")
    ArmatureNode_1._self = self
    draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
    ArmatureNode_1:getAnimation():playWithIndex(0, 0, 0)
    self:playAnimation()
end

function AdventureHeroLevelUpAction:onExit()

end
