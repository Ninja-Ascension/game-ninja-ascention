-----------------------------------------------------------------------------------------------
-- 说明：战宠战斗前提示 
-------------------------------------------------------------------------------------------------------

PetBattleTipNumber = class("PetBattleTipNumberClass", Window)
    
function PetBattleTipNumber:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.addType = 0
	self.addValue = 0
	self.camp = 0 -- 0 英雄 2敌方
end

function PetBattleTipNumber:onEnterTransitionFinish()
    local csbItem = csb.createNode("packs/PetStorage/PetStorage_battle.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)

	ccui.Helper:seekWidgetByName(root, "Text_1"):setString(string_equiprety_name[self.addType] ..self.addValue)
	local action = csb.createTimeline("packs/PetStorage/PetStorage_battle.csb")
    table.insert(self.actions, action )
    root:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "attack_text_up_over" then
        	if self.camp == 0 then 
        		state_machine.excute("fight_pet_play_over", 0, 0)
    		else
    			state_machine.excute("fight_pet_play_master_over", 0, 0)
        	end
			fwin:close(self)
        end
    end)
	action:play("attack_text_up", false)
end

function PetBattleTipNumber:onExit()

end

-- 提升类型
function PetBattleTipNumber:init(addType ,value,camp)
	self.addType = zstring.tonumber(addType) + 1
	self.addValue = value
	self.camp = camp
end

function PetBattleTipNumber:createCell()
	local cell = PetBattleTipNumber:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
