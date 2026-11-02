-- ----------------------------------------------------------------------------------------------------
-- 说明：道具使用动画
-------------------------------------------------------------------------------------------------------
AdventurePropRewardAnimation = class("AdventurePropRewardAnimationClass", Window)
    
function AdventurePropRewardAnimation:ctor()
    self.super:ctor()
    self.roots = {}
	self.types = nil
	self.number = 0
    self.pos = cc.p(0, 0)


    -- Initialize adventure hero level up action state machine.
    local function init_adventure_hero_level_up_action_terminal()
        state_machine.init()
    end
    
    -- call func init adventure hero level up action state machine.
    init_adventure_hero_level_up_action_terminal()
end

function AdventurePropRewardAnimation:init(types,number,cell)
	self.types = types
	self.number = number
	self._rootWindows = cell
    self._zorder = 10
    return self
end

function AdventurePropRewardAnimation:onEnterTransitionFinish()
    local csbAdventureHeroLevelUpAction = csb.createNode("utils/prompt_donghua.csb")
    local root = csbAdventureHeroLevelUpAction:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroLevelUpAction)
	local position = ccui.Helper:seekWidgetByName(self._rootWindows.roots[1], "Image_13")
	root:setPosition(cc.p(position:getPositionX(),position:getPositionY() + position:getContentSize().height *3/5))
	local Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")
	Panel_image:removeBackGroundImage()
	if zstring.tonumber(self.types) == 1 then
		Panel_image:setBackGroundImage("images/ui/icon/icon_gold_1.png")
	elseif zstring.tonumber(self.types) == 8 then
		Panel_image:setBackGroundImage("images/ui/icon/icon_exp_1.png")
	end
	local Text_exp = ccui.Helper:seekWidgetByName(root, "Text_exp")
	Text_exp:setString(self.number)
	local action = csb.createTimeline("utils/prompt_donghua.csb") 
    -- table.insert(self.actions, action )
    csbAdventureHeroLevelUpAction:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "prompt_feizi_over" then
        	fwin:close(self)
        end
    end)
    action:play("prompt_feizi", false)
end

function AdventurePropRewardAnimation:onExit()

end
