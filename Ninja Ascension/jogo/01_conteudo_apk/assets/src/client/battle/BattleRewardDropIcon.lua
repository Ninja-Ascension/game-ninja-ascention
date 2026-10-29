-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束奖励结算界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
BattleRewardDropIcon = class("BattleRewardDropIconClass", Window)

function BattleRewardDropIcon:ctor()
	self.super:ctor()
	self.roots = {}
	self.interfaceType = {}
	self.temb = nil
end	

function BattleRewardDropIcon:onEnterTransitionFinish()
	local csbBattleRewardDropIcon = csb.createNode("battle/victory_in_battle_drop_icon.csb")

	local root = csbBattleRewardDropIcon:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbBattleRewardDropIcon)
	local size = root:getContentSize()
	self:setContentSize(size)
	
	local action = csb.createTimeline("battle/victory_in_battle_drop_icon.csb")
	csbBattleRewardDropIcon:runAction(action)
	-- action:play("Panel_battle_victory", false)
	
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "over1111" then
			state_machine.excute("battle_reward_drop_draw", 0, "")
		end
	end)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	if self.temb == 1 then
		local cell = PropIconCell:createCell()
		--> print(self.interfaceType[1],self.interfaceType[2], self.interfaceType[3],"kkkkk--------11111111111---------------------------")
		if self.interfaceType[3] ~= nil then
			cell:init(self.interfaceType[1], self.interfaceType[2], self.interfaceType[3])
		else
			cell:init(self.interfaceType[1], self.interfaceType[2])
		end
		panel:addChild(cell)
	elseif self.temb == 2 then
		local cell = ShipHeadCell:createCell()
		if self.interfaceType[3] ~= nil then
			cell:init(self.interfaceType[1], self.interfaceType[2], self.interfaceType[3])
		else
			cell:init(self.interfaceType[1], self.interfaceType[2])
		end
		panel:addChild(cell)
	elseif self.temb == 3 then
		local cell = EquipIconCell:createCell()
		if self.interfaceType[3] ~= nil then
			cell:init(self.interfaceType[1], self.interfaceType[2], self.interfaceType[3])
		else
			cell:init(self.interfaceType[1], self.interfaceType[2])
		end
		panel:addChild(cell)
	elseif self.temb == 4 then
		local cell = ResourcesIconCell:createCell()
		cell:init(self.interfaceType[1], self.interfaceType[2], -1)
		panel:addChild(cell)
	elseif self.temb == 5 then
		local cell = ResourcesIconCell:createCell()
		cell:init(self.interfaceType[1], self.interfaceType[2], -1)
		panel:addChild(cell)
	end
	
	
end

function BattleRewardDropIcon:onExit()

end

function BattleRewardDropIcon:init(interfaceType, temb)
	self.interfaceType = interfaceType
	self.temb = temb
end


function BattleRewardDropIcon:createCell()
	local cell = BattleRewardDropIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
-- END
-- ----------------------------------------------------------------------------------------------------