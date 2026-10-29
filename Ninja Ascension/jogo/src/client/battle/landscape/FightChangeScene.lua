FightChangeScene = class("FightChangeSceneClass", Window)
 
function FightChangeScene:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function FightChangeScene:onEnterTransitionFinish()
	local csbChangeSceneCell = csb.createNode("battle/battle_map_heng_huihe_hei.csb")
	local root = csbChangeSceneCell:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbChangeSceneCell)

	local action = csb.createTimeline("battle/battle_map_heng_huihe_hei.csb")
    table.insert(self.actions, action)

    csbChangeSceneCell:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "heiping_huihe_over" then
        	fwin:close(self)
        end
    end)
    action:play("heiping_huihe", false)
end

function FightChangeScene:onExit()
end
