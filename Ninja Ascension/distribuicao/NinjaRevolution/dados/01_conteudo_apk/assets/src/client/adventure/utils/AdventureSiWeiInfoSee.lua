-- ----------------------------------------------------------------------------------------------------
-- 说明：四维属性
-------------------------------------------------------------------------------------------------------
AdventureSiWeiInfoSee = class("AdventureSiWeiInfoSeeClass", Window)
    
function AdventureSiWeiInfoSee:ctor()
    self.super:ctor()
    self.roots = {}
    self.show_type = 0 

	
    -- Initialize adventure battle reward state machine.
    local function init_adventure_battle_reward_terminal()

        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_battle_reward_terminal()
end

function AdventureSiWeiInfoSee:init(cell,show_type)
	
	self._rootWindows = cell
    self.show_type = show_type 
	--print(cell:getPositionX(),cell:getPositionY()," 父节点坐标")
	return self
end

function AdventureSiWeiInfoSee:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("utils/siwei_tips.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
    --print(self._rootWindows:getPositionX()-root:getContentSize().width,self._rootWindows:getPositionY(),"直接点坐标")
    if self.show_type == 2 then 
        self:setPosition(cc.p(-root:getContentSize().width,self:getPositionY()-root:getContentSize().height + self._rootWindows:getContentSize().height/2))
        else
        self:setPosition(cc.p(self:getPositionX()+ self._rootWindows:getContentSize().width*3/4,self:getPositionY()-root:getContentSize().height + self._rootWindows:getContentSize().height/2))    
    end
	
	
end

function AdventureSiWeiInfoSee:onExit()

end