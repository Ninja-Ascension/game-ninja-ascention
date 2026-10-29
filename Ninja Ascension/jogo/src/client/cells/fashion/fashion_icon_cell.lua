-------------------------------------------------------
-- 说明： 时装小图标绘制
-----------------------------------------------------
FashionIconCell = class("FashionIconCell",Window)

function FashionIconCell:ctor()
	 self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_FROM_FORMATION_GOTO_FASHION_INFORMATION = 1,		-- 从阵容界面进入时装信息界面
		_FROM_FORMATION_GOTO_FASHION_INFORMATION_SHIP = 2,  -- 时装列表的战船 
	}
	self.equip = nil		-- 当前要绘制的装备实例数据对对象
	self.mould_id = nil
	self.shipData = nil   --穿戴装备的shipId
	self.is_active = false
	self.num = nil	--数量
	self.isShowName = nil
	self.isHideNameAndCount = false
	self.grade = nil 
	self.ship = nil

	local function init_fashion_icon_cell_terminal()

		state_machine.init()
	end
	   
	init_fashion_icon_cell_terminal()
end

function FashionIconCell:hideNameAndCount()
	self.isHideNameAndCount = true
end

function FashionIconCell:onUpdateDraw2()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	Image_2:setSwallowTouches(false)
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.ship ~= nil then
		local picIndex = 0
		local quality = 0
		local item_index = nil--物品图标索引
		local item_qulityindex = nil--物品品质索引
		local item_nameIndex = nil--物品名称索引
		local item_mouldid = nil--物品模板id
		item_index = ship_mould.head_icon
		item_qulityindex = ship_mould.ship_type
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			item_nameIndex = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
		else
			item_nameIndex = ship_mould.captain_name
		end

		item_mouldid= self.ship.ship_template_id
		
		picIndex = dms.int(dms["ship_mould"], item_mouldid, item_index)
		quality = dms.int(dms["ship_mould"], item_mouldid, item_qulityindex)+1
		
		if self.ship.captain_type == "0" then
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		else
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		end
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
	end
end

function FashionIconCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return 
	end 
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)

	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	-- local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	-- local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	-- local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--zuo上角等级
	-- local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级

	if self.isHideNameAndCount == true then
		item_name:setVisible(false)
		item_order_level:setVisible(false)
	end
	local picIndex = 0
	local quality = 0
	local item_index = nil--物品图标索引
	local item_qulityindex = nil--物品品质索引
	local item_nameIndex = nil--物品名称索引
	local item_mouldid = nil--物品模板id

	item_index = equipment_mould.pic_index
	item_qulityindex = equipment_mould.grow_level
	item_nameIndex = equipment_mould.equipment_name

	if self.equip ~= nil then
		item_mouldid= self.equip.user_equiment_template
	else
		item_mouldid = self.mould_id
	end
	picIndex = dms.int(dms["equipment_mould"], item_mouldid, item_index)
	picIndex = 2001
	quality = dms.int(dms["equipment_mould"], item_mouldid, item_qulityindex) + 1

	Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
	item_name:setString(dms.string(dms["equipment_mould"], item_mouldid, item_nameIndex))
	item_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	Panel_num:setBackGroundImage(string.format("images/ui/quality/level_%d.png", quality))

	-- if self.equip ~= nil then 
	-- 	item_lv:setString(self.equip.user_equiment_grade)
	-- end
	if self.grade ~= nil then
		if self.grade == -1 then
			print("未获得")
		elseif self.grade == 10000 then
			print("已装备")
		else
			print("已拥有")
		end
	end
end

function FashionIconCell:onEnterTransitionFinish()

end

function FashionIconCell:onInit()
	local csbItem = csb.createNode("fashionable_dress/fashionable_icon.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	if self.current_type == self.enum_type._FROM_FORMATION_GOTO_FASHION_INFORMATION then
		self:onUpdateDraw()
	elseif self.current_type == self.enum_type._FROM_FORMATION_GOTO_FASHION_INFORMATION_SHIP then
		self:onUpdateDraw2()
	end
end

function FashionIconCell:onExit()

end

function FashionIconCell:init(interfaceType, equip, mould_id, shipData, isShowName, num, grade, ship)
	self.current_type = interfaceType
	self.equip = equip
	self.mould_id = mould_id
	self.shipData = shipData
	self.isShowName = isShowName
	self.num = num
	self.grade = grade
	self.ship = ship

	self:onInit()
end

function FashionIconCell:createCell()
	local cell = FashionIconCell:new()
	-- cell:registerOnNodeEvent(cell)
	return cell
end

