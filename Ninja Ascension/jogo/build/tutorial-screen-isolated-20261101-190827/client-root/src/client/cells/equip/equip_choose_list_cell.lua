----------------------------------------------------------------------------------------------------
-- 说明：装备选择信息列(装备出售)
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipChooseListCell = class("EquipChooseListCellClass", Window)
EquipChooseListCell.__size = nil
 
function EquipChooseListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.status = false
	self.equipmentInstance = nil
	self.showPrice = nil
	self.interfaceType = 0
	self.enum_type = {
		_EQUIP_SELL_LIST_VIEW_CHOOSE_SELL_EQUIP = 0,
		_EQUIP_RESOLVE_CHOOSE_NEED_EQUIP = 1,
	}
	
    local function init_equip_choose_list_cell_terminal()
		local equip_choose_list_page_choose_terminal = {
            _name = "equip_choose_list_page_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local tempCell = params._datas.cell
				if tempCell.status == false then
					if tempCell.roots[1] ~= nil then
						ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(true)
					end
					tempCell.status = true
				else
					if tempCell.roots[1] ~= nil then
						ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(false)
					end
					tempCell.status = false
				end
				state_machine.excute("equip_sell_update_cell_status", 0, {cell = tempCell, equipmentInstance = tempCell.equipmentInstance})
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local equip_choose_list_page_choose_update_terminal = {
			_name = "equip_choose_list_page_choose_update",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				local sell_quality = params._datas.quality
				local tempStatus =params._datas.status
				
				local quality = dms.int(dms["equipment_mould"], params._datas.cell.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
				if sell_quality == quality then
					if  tempStatus == true then
						if tempCell.status == true then
							return
						end
						tempCell.status = false
					else
						tempCell.status = true
					end
					state_machine.excute("equip_choose_list_page_choose", 0, {_datas = {cell = tempCell}})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local equip_choose_list_cell_for_equip_resolve_terminal = {
			_name = "equip_choose_list_cell_for_equip_resolve",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("equip_resolve_page_check_conut", 0, {_datas = {cell = params._datas.cell}})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(equip_choose_list_page_choose_terminal)
		state_machine.add(equip_choose_list_page_choose_update_terminal)
		state_machine.add(equip_choose_list_cell_for_equip_resolve_terminal)
        state_machine.init()
    end
	
    init_equip_choose_list_cell_terminal()
end

function EquipChooseListCell:onEnterTransitionFinish()

end

function EquipChooseListCell:onInit()
 --    local csbEquipPatchListCell = csb.createNode("list/list_equipment_sui_1.csb")
	-- local root = csbEquipPatchListCell:getChildByName("root")
	-- root:removeFromParent(true)
	-- self:addChild(root)
	-- table.insert(self.roots, root)

	local root = cacher.createUIRef("list/list_equipment_sui_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("list/list_equipment_sui_1.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local MySize = PanelGeneralsEquipment:getContentSize()
	-- self:setContentSize(MySize)
	if EquipChooseListCell.__size == nil then
		EquipChooseListCell.__size = MySize
	end
	local head = ccui.Helper:seekWidgetByName(root, "Panel_3")
	head:removeAllChildren(true)
	local name = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Text_1")
	local head = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local level = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	local levelNumber = ccui.Helper:seekWidgetByName(root, "Text_300")
	local sel = ccui.Helper:seekWidgetByName(root, "Text_7")
	local selNumber = ccui.Helper:seekWidgetByName(root, "Text_6")

	local Text_41 = ccui.Helper:seekWidgetByName(root, "Text_41")
	Text_41:setString("")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if tonumber(self.equipmentInstance.equiment_refine_level) > 0 then
			Text_41:setString(_string_piece_info[45] .. self.equipmentInstance.equiment_refine_level .. _string_piece_info[46])
		end
	end
	level:setString(_string_piece_info[16] .. ":")
	
	if self.interfaceType == self.enum_type._EQUIP_SELL_LIST_VIEW_CHOOSE_SELL_EQUIP then
		sel:setString(_string_piece_info[17])
		selNumber:setString(self.equipmentInstance.sell_price)
	else
		sel:setString("")
		selNumber:setString("")
	end
	
	ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_10"):setVisible(self.status)
	ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Button_7"):setVisible(false)
	
	name:setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name))
	local colortype = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
	name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	levelNumber:setString(self.equipmentInstance.user_equiment_grade)
	
	head:removeAllChildren(true)
	app.load("client.cells.equip.equip_icon_new_cell")
	local picCell = EquipIconNewCell:createCell()
	picCell:init(picCell.enum_type._SHOW_EQUIPMENT_PATCH_INFORMATION, self.equipmentInstance)
	head:addChild(picCell)
	
	if self.interfaceType == self.enum_type._EQUIP_SELL_LIST_VIEW_CHOOSE_SELL_EQUIP then
		fwin:addTouchEventListener(
			ccui.Helper:seekWidgetByName(root, "Panel_6"), 
			nil, 
			{
				terminal_name = "equip_choose_list_page_choose", 	
				next_terminal_name = "", 	
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false,
			}, 
			nil, 
			0)
	elseif self.interfaceType == self.enum_type._EQUIP_RESOLVE_CHOOSE_NEED_EQUIP then
		fwin:addTouchEventListener(
			ccui.Helper:seekWidgetByName(root, "Panel_6"), 
			nil, 
			{
				terminal_name = "equip_choose_list_cell_for_equip_resolve", 	
				next_terminal_name = "", 	
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false,
			}, 
			nil, 
			0)
	end
end

function EquipChooseListCell:close( ... )
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	head:removeAllChildren(true)
end

function EquipChooseListCell:onExit()
	-- state_machine.remove("equip_choose_list_page_choose")
	-- state_machine.remove("equip_choose_list_page_choose_update")
	cacher.freeRef("list/list_equipment_sui_1.csb", self.roots[1])
end

function EquipChooseListCell:init(equipmentInstance, interfaceType, index)
	self.equipmentInstance = equipmentInstance
	self.interfaceType = interfaceType or 0

	if index ~= nil and index < 7 then
		self:onInit()
	end
	self:setContentSize(EquipChooseListCell.__size)
	return self
end

function EquipChooseListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EquipChooseListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	if head ~= nil then
		head:removeAllChildren(true)
	end
	cacher.freeRef("list/list_equipment_sui_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function EquipChooseListCell:createCell()
	local cell = EquipChooseListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end