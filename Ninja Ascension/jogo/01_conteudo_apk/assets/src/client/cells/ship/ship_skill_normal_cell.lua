---------------------------------
---说明：武将普通技能描述
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
---------------------------------

ShipSkillNormalCell = class("ShipSkillNormalCellClass", Window)
   
function ShipSkillNormalCell:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
end

function ShipSkillNormalCell:onUpdateDraw()
	local root = self.roots[1]
	
	local skillName = self.hero.skill_name
	local skillDescribe = self.hero.skill_describe
	
	ccui.Helper:seekWidgetByName(root, "Text_17"):setString("["..skillName.."]".." "..skillDescribe)
	ccui.Helper:seekWidgetByName(root, "Text_17"):setColor(cc.c3b(color_Type[8][1],color_Type[8][1],color_Type[8][1]))
end


function ShipSkillNormalCell:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbShipSkillNormalCell = csb.createNode("packs/HeroStorage/generals_information_4_1.csb")
	local root = csbShipSkillNormalCell:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbShipSkillNormalCell)
	
	self:onUpdateDraw()
end


function ShipSkillNormalCell:onExit()
	
end

function ShipSkillNormalCell:init(hero)
	self.hero = hero
end

function ShipSkillNormalCell:createCell()
	local cell = ShipSkillNormalCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end