---------------------------------
---说明：红宝技能信息描述

TreasureRedInfoCell = class("TreasureRedInfoCellClass", Window)
   
function TreasureRedInfoCell:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.page = nil
	self.texts = {}
	self.equipInfo = nil --装备数据
end

function TreasureRedInfoCell:onEnterTransitionFinish()
    local csbEquipInfoStrengthenListCell = csb.createNode("packs/EquipStorage/equipment_information_list_10.csb")
	local root = csbEquipInfoStrengthenListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	self:onUpdateDraw()
end

function TreasureRedInfoCell:onUpdateDraw() --缘分
	local root = self.roots[1]
	
	local talents = zstring.split(dms.string(dms["equipment_mould"], self.equipInfo.user_equiment_template, equipment_mould.equipment_talent_ids),",")
	if talents == nil then 
		return
	end
	local levels = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		levels = zstring.split(dms.string(dms["pirates_config"], 321, pirates_config.param), ",")
	else
		levels = zstring.split(dms.string(dms["pirates_config"], 322, pirates_config.param), ",")
	end
	
	for i,v in pairs(talents) do
		local Text = ccui.Helper:seekWidgetByName(root, "Text_sb_".. i)
		local activate = zstring.tonumber(self.equipInfo.equiment_refine_level)
		local infoString = "[" .. dms.string(dms["talent_mould"], v, talent_mould.talent_name) ..
			"]" .. dms.string(dms["talent_mould"], v, talent_mould.talent_describe) .. string.format(_equip_red_tip[1],zstring.tonumber(levels[i]))
		Text:setString(infoString)
		
		local colorType = nil
		if activate >= zstring.tonumber(levels[i]) then 
			colorType = red_equip_skill_color_type[2]
		else
			colorType = red_equip_skill_color_type[1]
		end
		Text:setColor(cc.c3b(colorType[1], colorType[2], colorType[3]))
	end
end

function TreasureRedInfoCell:onExit()

end

function TreasureRedInfoCell:init(equipInfo)
	self.equipInfo = equipInfo
end

function TreasureRedInfoCell:createCell()
	local cell = TreasureRedInfoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end