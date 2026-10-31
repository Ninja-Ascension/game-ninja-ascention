---------------------------------
---说明：武将合体技描述
-- 创建时间:
-- 作者：
-- 修改记录：
-- 最后修改人：
---------------------------------
ShipSkillJoinCell = class("ShipSkillJoinCellClass", Window)
   
function ShipSkillJoinCell:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

end

function ShipSkillJoinCell:onUpdateDraw()
	local root = self.roots[1]
	
	local relationInfo= dms.string(dms["fate_relationship_mould"], self.hero.relationship.relationship_id, fate_relationship_mould.zoarium_skill)
	local skillName = dms.string(dms["skill_mould"], relationInfo, skill_mould.skill_name)
	local skillDescribe = dms.string(dms["skill_mould"], relationInfo, skill_mould.skill_describe)
	
	ccui.Helper:seekWidgetByName(root, "Text_19"):setString("["..skillName.."]".." "..skillDescribe)
	
end


function ShipSkillJoinCell:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbShipSkillJoinCell = csb.createNode("packs/HeroStorage/generals_information_4_3.csb")
	local root = csbShipSkillJoinCell:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbShipSkillJoinCell)
	
	self:onUpdateDraw()
end


function ShipSkillJoinCell:onExit()

end

function ShipSkillJoinCell:init(hero)
	self.hero = hero
end

function ShipSkillJoinCell:createCell()
	local cell = ShipSkillJoinCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end