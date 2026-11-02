----------------------------------------------------------------------------------------------------
-- 说明：小图标绘制
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
FormationCarHeadCell = class("FormationCarHeadCellClass", Window)

function FormationCarHeadCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.item = nil
	self.type = 0 --物品类型：1道具，2装备，3船只

	local function init_formation_car_head_cell_terminal()
	
		local call_formation_car_head_cell_terminal = {
            _name = "call_formation_car_head_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --点击事件
				-- EquipInformation:createCell(instance.equipmentInstance)
				local equipmentInformation = EquipInformation:new()
				equipmentInformation:init(instance.equipmentInstance)
				fwin:open(equipmentInformation, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(call_formation_car_head_cell_terminal)	
        state_machine.init()
	end
	init_formation_car_head_cell_terminal()
end

function FormationCarHeadCell:onUpdateDraw()
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
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end
	
	--阵容
	if self.item ~= nil then
		local picIndex = 0
		local quality = 0
		
		item_element={
			"prop_mould",
			"equipment_mould",
			"ship_mould",
		}
		
		local item_index = nil--物品图标索引
		local item_qulityindex = nil--物品品质索引
		local item_nameIndex = nil--物品名称索引
		local item_mouldid = nil--物品模板id
		if self.type == 1 then
			item_index = prop_mould.pic_index
			item_qulityindex = prop_mould.prop_quality
			item_nameIndex = prop_mould.prop_name
			item_mouldid= self.item.user_prop_template
		elseif self.type == 2 then
			item_index = equipment_mould.pic_index
			item_qulityindex = equipment_mould.grow_level
			item_nameIndex = equipment_mould.equipment_name
			item_mouldid= self.item.user_equiment_template
		elseif self.type == 3 then
			item_index = ship_mould.head_icon
			item_qulityindex = ship_mould.ship_type
			item_nameIndex = ship_mould.captain_name
			item_mouldid= self.item.ship_template_id
		end
		picIndex = dms.int(dms[item_element[self.type]], item_mouldid, item_index)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if self.type == 1 then
				picIndex = setThePropsIcon(item_mouldid)[1]
			end
		end
		quality = dms.int(dms[item_element[self.type]], item_mouldid, item_qulityindex)+1
		
		Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_kuang_%d.png", quality))
		Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))

		if self.type == 1 then
		elseif self.type == 2 then
			item_name:setString(dms.string(dms[item_element[self.type]], item_mouldid, item_nameIndex))
			item_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
			Panel_num:setBackGroundImage(string.format("images/ui/quality/level_%d.png", quality))
			item_lv:setString(self.item.user_equiment_grade)
		elseif self.type == 3 then
			
		end
	end
	local touchImage_2 = fwin:addTouchEventListener(Panel_prop, nil, {func_string = [[state_machine.excute("call_formation_car_head_cell", 0, "click call_formation_car_head_cell.'")]]}, nil, 0)
end

function FormationCarHeadCell:onEnterTransitionFinish()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
		if root._x == nil then
			root._x = 0
		end
		if root._y == nil then
			root._x = 0
		end
	else
		local csbItem = csb.createNode("icon/item.csb")
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function FormationCarHeadCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
		if root._x ~= nil then
			root:setPositionX(root._x)
		end
		if root._y ~= nil then
			root:setPositionY(root._y)
		end
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function FormationCarHeadCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
	    cacher.freeRef("icon/item.csb", root)
	end
end

function FormationCarHeadCell:init(item,objectType,parameterSet)
	self.item = item
	self.type = objectType
	self.parameter = parameterSet
end

function FormationCarHeadCell:createCell(equipmentInstance,types)
	local cell = FormationCarHeadCell:new()
	cell.equipmentInstance = equipmentInstance
	cell.types = types
	cell:registerOnNodeEvent(cell)
	return cell
end

