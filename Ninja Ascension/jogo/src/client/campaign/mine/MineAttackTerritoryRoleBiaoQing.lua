-----------------------------------------------------------------------------------------------
-- 说明：npc 废话 表情
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

MineAttackTerritoryRoleBiaoQing = class("MineAttackTerritoryRoleBiaoQingClass", Window)
    
function MineAttackTerritoryRoleBiaoQing:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
end


function MineAttackTerritoryRoleBiaoQing:onEnterTransitionFinish()
    local csbItem = csb.createNode("campaign/MineManager/attack_territory_role_biaoqin.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)
	
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_257")
	-- local size = panel:getContentSize()
	-- self:setContentSize(size)
	
	
	local action = csb.createTimeline("campaign/MineManager/attack_territory_role_biaoqin.csb")
    table.insert(self.actions, action )
    root:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()
        if str == "biaoqin_ing_over" then
			local index = self.index
			local cell = self.cell
			
			fwin:close(self)
			state_machine.excute("mine_manager_manor_patrol_dialogue", 0, {index = index, cell = cell}) 
        end
    end)
	action:play("biaoqin_ing", false)
	
	local pic = string.format("images/ui/biaoqing/%d.png", tonumber(self.id)-100)
	
	panel:setBackGroundImage(pic)
end


function MineAttackTerritoryRoleBiaoQing:onExit()

end

-- 显示的表情id, 当前是废话三人组的第几个
function MineAttackTerritoryRoleBiaoQing:init(id, index,cell)
	self.id = id
	self.index = index
	self.cell = cell
end

function MineAttackTerritoryRoleBiaoQing:createCell()
	local cell = MineAttackTerritoryRoleBiaoQing:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
