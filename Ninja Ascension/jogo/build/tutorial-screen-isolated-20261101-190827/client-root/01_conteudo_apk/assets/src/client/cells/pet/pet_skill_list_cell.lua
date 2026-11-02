----------------------------------------------------------------------------------------------------
-- 说明：驯兽师技能列表
-------------------------------------------------------------------------------------------------------
PetSkillListCell = class("PetSkillListCellClass", Window)

function PetSkillListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.skillId = 0 -- 技能ID
end

function PetSkillListCell:onUpdateDraw()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "Text_tc")
	
	local infoString = dms.string(dms["skill_mould"],self.skillId,skill_mould.skill_describe)
	text:setString("[" .. dms.string(dms["skill_mould"],self.skillId,skill_mould.skill_name).."]" .. infoString)
end

function PetSkillListCell:onEnterTransitionFinish()
    local csbPetSkillListCell = csb.createNode("packs/PetStorage/PetStorage_tanchuan_list.csb")
	local root = csbPetSkillListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()	
end


function PetSkillListCell:onExit()
end

function PetSkillListCell:init(skillId)
	self.skillId = skillId -- 技能ID
end

function PetSkillListCell:createCell()
	local cell = PetSkillListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end