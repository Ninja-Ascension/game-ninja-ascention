----------------------------------------------------------------------------------------------------
-- 说明：装备图标列表
-- 创建时间
-- 作者：杨晗
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TreasureIconListCell = class("TreasureIconListCellClass", Window)
TreasureIconListCell.__size = nil
   
function TreasureIconListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.treasure_instance = nil
	self.isshow = false
    local function init_treasure_icon_list_cell_terminal()

        state_machine.init()
    end
    
    init_treasure_icon_list_cell_terminal()
end

function TreasureIconListCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil or self.roots == nil then
		--界面没有显示，不用刷新，reload 的时候 会自动刷新
		return
	end
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_zhenxing = ccui.Helper:seekWidgetByName(root, "Panel_zhenxing")
	local images_chuandai =  ccui.Helper:seekWidgetByName(root, "Image_line_equ")
	local images_shangzhen = ccui.Helper:seekWidgetByName(root, "Image_line_role")
	local images_zhushou = ccui.Helper:seekWidgetByName(root, "Image_zhushou")
	images_zhushou:setVisible(false)	
	local textlv =  ccui.Helper:seekWidgetByName(root, "Text_equip_lv")
	local picIndex = dms.int(dms["equipment_mould"], self.treasure_instance.user_equiment_template, equipment_mould.pic_index)
	local quality = dms.int(dms["equipment_mould"], self.treasure_instance.user_equiment_template, equipment_mould.grow_level) + 1
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		Panel_prop:removeAllChildren(true)
		local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
		Panel_4:setVisible(false)		
	end
	Panel_prop:removeBackGroundImage()
	Panel_kuang:removeBackGroundImage()
	Panel_zhenxing:removeBackGroundImage()
	Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))

	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		else
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
		end
	end
	images_chuandai:setVisible(false)
	images_shangzhen:setVisible(false)
	if tonumber(self.treasure_instance.ship_id) ~= 0 then
		images_chuandai:setVisible(true)
	end
	local Image_600 = ccui.Helper:seekWidgetByName(root,"Image_600")
	Image_600:setVisible(false)
	Image_600:setVisible(self.isshow)
	local str = "lv "..self.treasure_instance.user_equiment_grade
	textlv:setString("")
	textlv:setVisible(false)
	if tonumber(self.treasure_instance.user_equiment_grade) > 0 then
		textlv:setString(str)
		textlv:setVisible(true)
	end
end

function TreasureIconListCell:onEnterTransitionFinish()

end

function TreasureIconListCell:setSelected(isshow)
	local root = self.roots[1]
	if root == nil or self.roots == nil then
		return
	end
	local Image_600 = ccui.Helper:seekWidgetByName(root,"Image_600")
	Image_600:setVisible(isshow)
end

function TreasureIconListCell:onInit()
	local root = cacher.createUIRef("formation/line_up_icon_up.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
 	if TreasureIconListCell.__size == nil then
 		local Panel_list_cell_size = ccui.Helper:seekWidgetByName(root,"Panel_list_cell_size")
 		TreasureIconListCell.__size = Panel_list_cell_size:getContentSize()
 	end
 	local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop")
	fwin:addTouchEventListener(Panel_prop, nil, 
	{
		terminal_name = "treasure_icon_listview_set_index", 
		next_terminal_name = "treasure_refine_update_for_icon",
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = false
	},	
	nil, 0)	
	self:onUpdateDraw()
end

function TreasureIconListCell:onExit()

	local root = self.roots[1]
	if root ~= nil then
		cacher.freeRef("formation/line_up_icon_up.csb", self.roots[1])
	end
end

function TreasureIconListCell:init(treasure_instance, index)
	self.treasure_instance = treasure_instance
	if index ~= nil and index < 7 then
		self:onInit()
	end

	self:setContentSize(TreasureIconListCell.__size)
	return self
end

function TreasureIconListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TreasureIconListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("formation/line_up_icon_up.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function TreasureIconListCell:createCell()
	local cell = TreasureIconListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end