---------------------------------
---说明：武将怒气技描述
-- 创建时间
-- 作者
-- 修改记录：
-- 最后修改人：
---------------------------------

ShipSkillReagCell = class("ShipSkillReagCellClass", Window)
   
function ShipSkillReagCell:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
end

function ShipSkillReagCell:onUpdateDraw()
	local root = self.roots[1]
	
	local skillName = self.hero.deadly_skill_name
	local skillDescribe = self.hero.deadly_skill_describe
	
	ccui.Helper:seekWidgetByName(root, "Text_18"):setString("["..skillName.."]".." "..skillDescribe)
	ccui.Helper:seekWidgetByName(root, "Text_18"):setColor(cc.c3b(color_Type[8][1],color_Type[8][1],color_Type[8][1]))
end


function ShipSkillReagCell:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbShipSkillReagCell = csb.createNode("packs/HeroStorage/generals_information_4_2.csb")
	local root = csbShipSkillReagCell:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbShipSkillReagCell)
	
	self:onUpdateDraw()
end


function ShipSkillReagCell:onExit()

end

function ShipSkillReagCell:init(hero)
	self.hero = hero
end

function ShipSkillReagCell:createCell()
	local cell = ShipSkillReagCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end