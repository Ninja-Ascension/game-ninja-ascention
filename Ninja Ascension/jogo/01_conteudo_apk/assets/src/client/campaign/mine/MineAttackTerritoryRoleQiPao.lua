-----------------------------------------------------------------------------------------------
-- 说明：npc 废话 气泡
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

MineAttackTerritoryRoleQiPao = class("MineAttackTerritoryRoleQiPaoClass", Window)
    
function MineAttackTerritoryRoleQiPao:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
end


function MineAttackTerritoryRoleQiPao:onEnterTransitionFinish()
    local csbItem = csb.createNode("campaign/MineManager/attack_territory_role_qipao.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)
	
	
	-- local text_1033 = ccui.Helper:seekWidgetByName(root, "Text_1033")
	-- local size = panel:getContentSize()
	-- self:setContentSize(size)
	
	local actionName = "qipao_ing"
	local text_1033 = ccui.Helper:seekWidgetByName(root, "Text_1033")
	
	if self.isLeft == true then
		actionName = "qipao_left"
		text_1033 = ccui.Helper:seekWidgetByName(root, "Text_1033_2")
	end
	
	
	local action = csb.createTimeline("campaign/MineManager/attack_territory_role_qipao.csb")
    table.insert(self.actions, action )
    root:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()
        if str == "qipao_ing_over" then
			local index = self.index
			local cell = self.cell
			
			fwin:close(self)
			state_machine.excute("mine_manager_manor_patrol_dialogue", 0, {index = index, cell = cell}) 
        	
        end
    end)
	action:play(actionName, false)
	
	
	text_1033:setString(self.str)
end


function MineAttackTerritoryRoleQiPao:onExit()

end

-- 显示的输出文字, 当前是废话三人组的第几个
function MineAttackTerritoryRoleQiPao:init(str, index, cell, isLeft)
	self.str = str
	self.index = index
	self.cell = cell
	self.isLeft = isLeft
end

function MineAttackTerritoryRoleQiPao:createCell()
	local cell = MineAttackTerritoryRoleQiPao:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
