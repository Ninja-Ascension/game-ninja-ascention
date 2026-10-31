----------------------------------------------------------------------------------------------------
-- 说明：红装天赋列表
-------------------------------------------------------------------------------------------------------
EquipRedTalentListCell = class("EquipRedTalentListCellClass", Window)

function EquipRedTalentListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.talentId = 0 -- 天賦ID
	self.level = 0 -- 精炼等级
	self.isActivate = false --是否激活

end

function EquipRedTalentListCell:onUpdateDraw()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "Text_tc")
	
	local tipHeight = 0
	
	local infoString = "[" .. dms.string(dms["talent_mould"], self.talentId, talent_mould.talent_name) ..
	"]" .. dms.string(dms["talent_mould"], self.talentId, talent_mould.talent_describe) .. string.format(_equip_red_tip[1],zstring.tonumber(self.level))
	text:setString(infoString)
	if self.isActivate == true then 
		text:setColor(cc.c3b(255, 0, 0))
	else
		text:setColor(cc.c3b(0, 0, 0))
	end
end

function EquipRedTalentListCell:onEnterTransitionFinish()
    local csbEquipRedTalentListCell = csb.createNode("packs/EquipStorage/equipment_information_tanchuan_list.csb")
	local root = csbEquipRedTalentListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()	
end


function EquipRedTalentListCell:onExit()
	state_machine.remove("equip_info_describe_list")
end

function EquipRedTalentListCell:init(talentId,level,isActivate)
	self.talentId = talentId -- 天賦ID
	self.level = level -- 精炼等级 
	self.isActivate = isActivate --是否激活
end

function EquipRedTalentListCell:createCell()
	local cell = EquipRedTalentListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end