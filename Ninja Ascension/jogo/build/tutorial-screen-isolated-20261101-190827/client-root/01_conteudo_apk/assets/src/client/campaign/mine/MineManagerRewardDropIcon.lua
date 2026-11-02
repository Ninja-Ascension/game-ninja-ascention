-- ----------------------------------------------------------------------------------------------------
-- 说明：领地战斗结束奖励结算界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerRewardDropIcon = class("MineManagerRewardDropIconClass", Window)

function MineManagerRewardDropIcon:ctor()
	self.super:ctor()
	self.roots = {}
	self.interfaceType = {}
	self.temb = nil
end	

--道具
function MineManagerRewardDropIcon:getPropCell(mid, num,mtype)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = num
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cell:init(cellConfig)
	return cell
end

function MineManagerRewardDropIcon:onEnterTransitionFinish()
	local csbMineManagerRewardDropIcon = csb.createNode("battle/victory_in_battle_drop_icon.csb")

	local root = csbMineManagerRewardDropIcon:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbMineManagerRewardDropIcon)
	local size = root:getContentSize()
	self:setContentSize(size)
	
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local cell = self:getPropCell(self.mid, self.num,self.mtype)
	panel:addChild(cell)
	
	
	local action = csb.createTimeline("battle/victory_in_battle_drop_icon.csb")
	csbMineManagerRewardDropIcon:runAction(action)
	-- action:play("Panel_battle_victory", false)
	
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "over1111" then
			state_machine.excute("mine_manager_reward_drop_draw", 0, "")
		end
	end)
	
	

end

function MineManagerRewardDropIcon:onExit()

end

function MineManagerRewardDropIcon:init(mid, num,mtype)
	self.mid = mid
	self.num = num
	self.mtype = mtype
end


function MineManagerRewardDropIcon:createCell()
	local cell = MineManagerRewardDropIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
-- END
-- ----------------------------------------------------------------------------------------------------