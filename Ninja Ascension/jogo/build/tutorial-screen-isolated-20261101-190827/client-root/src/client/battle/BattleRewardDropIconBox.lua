-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束奖励结算界面显示的宝箱动画
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
BattleRewardDropIconBox = class("BattleRewardDropIconBoxClass", Window)

function BattleRewardDropIconBox:ctor()
	self.super:ctor()
	self.roots = {}
	self.interfaceType = {}
	self.temb = nil
	self.isOver = false
end	

function BattleRewardDropIconBox:onEnterTransitionFinish()
	local csbBattleRewardDropIconBox = csb.createNode("battle/victory_in_battle_drop_1.csb")

	local root = csbBattleRewardDropIconBox:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbBattleRewardDropIconBox)
	
	
	local size = root:getContentSize()
	self:setContentSize(size)
	
	local action = csb.createTimeline("battle/victory_in_battle_drop_1.csb")
	csbBattleRewardDropIconBox:runAction(action)

	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if self.isOver ~= true and str == "diaoluoing_over" then
			
			self.isOver = true
			--state_machine.excute("battle_reward_drop_draw", 0, "")
		end
	end)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	if self.temb == 1 then --道具
		ccui.Helper:seekWidgetByName(root, "Image_daoju"):setVisible(true)
	elseif self.temb == 2 then --战船
		ccui.Helper:seekWidgetByName(root, "Image_wujiang"):setVisible(true)
	elseif self.temb == 3 then --装备
		ccui.Helper:seekWidgetByName(root, "Image_zhuangbei"):setVisible(true)
	elseif self.temb == 4 then --资源4
		ccui.Helper:seekWidgetByName(root, "Image_daoju"):setVisible(true)
	elseif self.temb == 5 then --资源5
		ccui.Helper:seekWidgetByName(root, "Image_daoju"):setVisible(true)
	end
	
	action:play("diaoluoing", false)
end

function BattleRewardDropIconBox:onExit()

end

function BattleRewardDropIconBox:init(temb)
	self.temb = temb
end


function BattleRewardDropIconBox:createCell()
	local cell = BattleRewardDropIconBox:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
-- END
-- ----------------------------------------------------------------------------------------------------