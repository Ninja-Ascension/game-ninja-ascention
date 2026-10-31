----------------------------------------------------------------------------------------------------
-- 说明：装备仓库装备碎片信息列
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipPatchListCell = class("EquipPatchListCellClass", Window)
EquipPatchListCell.__size = nil
   
function EquipPatchListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.packs.equipment.EquipFragmentInfomation")
    local function init_equip_patch_list_cell_terminal()
		local equip_patch_list_page_get_terminal = {
            _name = "equip_patch_list_page_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- TipDlg.drawTextDailog(_function_unopened_tip_string)
				
				state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.EquipPatchListView)
	
				local prop = params._datas._equip.user_prop_template --道具模板id
				local equipId = dms.int(dms["prop_mould"], prop, prop_mould.change_of_equipment)
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_warship_girl_b 
					then 
					cell:init(prop,4)
				else
					cell:init(equipId,1)	
				end
				
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local equip_patch_list_page_combining_terminal = {
            _name = "equip_patch_list_page_combining",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responsePropCompoundCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local equipId = dms.int(dms["prop_mould"],response.node._datas._equip.user_prop_template,prop_mould.change_of_equipment)
						local name = dms.string(dms["equipment_mould"], equipId, equipment_mould.equipment_name)
						TipDlg.drawTextDailog(_string_piece_info[351] .. name)
						local cell = EquipFragmentInfomation:new()
						cell:init(response.node._datas._equip, 2)
						fwin:open(cell, fwin._view)
						state_machine.excute("equip_patch_list_page_update", 0, 
						{
							_datas = {
								_equip = response.node._datas._equip, 
								_instance = response.node._datas._instance
							}
						})
						state_machine.excute("equip_list_view_insert_cell", 0, _ED.new_equip_get)
						state_machine.excute("equip_show_equip_counts", 0, "equip_show_equip_counts.")
						
						-- local cell = EquipFragmentInfomation:new()
						-- cell:init(params._datas._equip, 2)
						-- fwin:open(cell, fwin._view)
						
						_ED.new_equip_get = ""
					end
                end
				if TipDlg.drawStorageTipo({2}) == false then
					local str = params._datas._equip.user_prop_id .. "\r\n" .. "0" .. "\r\n" .. "1"
					protocol_command.prop_compound.param_list = str
	                NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, params, responsePropCompoundCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_patch_list_page_update_terminal = {
            _name = "equip_patch_list_page_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		if instance == nil or instance.roots == nil then
            			return
            		end
            	end
				local maxNumber = dms.int(dms["prop_mould"], params._datas._equip.user_prop_template, prop_mould.split_or_merge_count)
				local numbers = ccui.Helper:seekWidgetByName(params._datas._instance.roots[1], "Text_300")
				numbers:setString(params._datas._instance.equipmentInstance.prop_number .. "/" .. maxNumber)
				
				tempCell = params._datas._instance
				
				if tonumber(params._datas._equip.prop_number) == 0 then
					state_machine.excute("equip_patch_remove_item", 0, tempCell)
					
					if nil ~= tempCell.roots and nil ~= tempCell.roots[1] then	
						ccui.Helper:seekWidgetByName(params._datas._instance.roots[1], "Button_1"):setVisible(false)
						ccui.Helper:seekWidgetByName(params._datas._instance.roots[1], "Button_7"):setVisible(true)
					end
				elseif tonumber(params._datas._equip.prop_number) < dms.int(dms["prop_mould"], params._datas._equip.user_prop_template, prop_mould.split_or_merge_count) then
					
					if nil ~= tempCell.roots and nil ~= tempCell.roots[1] then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						else
							local numberTip = ccui.Helper:seekWidgetByName(params._datas._instance.roots[1], "Text_41")
							numberTip:setString("")
							numberTip:setString( "(" .. _string_piece_info[12] .. ")" )
						end
						ccui.Helper:seekWidgetByName(params._datas._instance.roots[1], "Button_1"):setVisible(true)
						ccui.Helper:seekWidgetByName(params._datas._instance.roots[1], "Button_7"):setVisible(false)
					
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(equip_patch_list_page_get_terminal)
		state_machine.add(equip_patch_list_page_combining_terminal)
		state_machine.add(equip_patch_list_page_update_terminal)
        state_machine.init()
    end
    
    init_equip_patch_list_cell_terminal()
end

function EquipPatchListCell:onEnterTransitionFinish()

end

function EquipPatchListCell:onInit()
 --    local csbEquipPatchListCell = csb.createNode("list/list_equipment_sui_1.csb")
	-- self:addChild(csbEquipPatchListCell)
	-- local root = csbEquipPatchListCell:getChildByName("root")
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

	local head = ccui.Helper:seekWidgetByName(root, "Panel_3")
	head:removeAllChildren(true)
	local sel = ccui.Helper:seekWidgetByName(root, "Text_7")
	sel:setString("")
	local selNumber = ccui.Helper:seekWidgetByName(root, "Text_6")
	selNumber:setString("")
	
	ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(false)
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local MySize = PanelGeneralsEquipment:getContentSize()
	-- self:setContentSize(MySize)

	if EquipPatchListCell.__size == nil then
		EquipPatchListCell.__size = MySize
	end
	
	local name = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Text_1")
	local numberTip = ccui.Helper:seekWidgetByName(root, "Text_41")
	numberTip:setString("")
	if numberTip._bs == nil then
		numberTip._bs = numberTip:getString()
	end
	local number = ccui.Helper:seekWidgetByName(root, "Text_300")
	local picPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local tip = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	tip:setString(_string_piece_info[4])
	local maxNumber = dms.int(dms["prop_mould"], self.equipmentInstance.user_prop_template, prop_mould.split_or_merge_count)
	number:setString(self.equipmentInstance.prop_number .. "/" .. maxNumber)
	
	name:setString(self.equipmentInstance.prop_name)
	local colortype = dms.int(dms["prop_mould"], self.equipmentInstance.user_prop_template, prop_mould.prop_quality)
	name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	if tonumber(self.equipmentInstance.prop_number) >= dms.int(dms["prop_mould"], self.equipmentInstance.user_prop_template, prop_mould.split_or_merge_count) then
		numberTip:setString("")
		ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_7"):setVisible(true)
	else
		if numberTip._bs ~= nil then
			numberTip:setString(numberTip._bs)
		end
		ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_7"):setVisible(false)
	end
	
	picPanel:removeAllChildren(true)
	local picCell = PropIconNewCell:createCell()
	picCell:init(picCell.enum_type._SHOW_EQUIPMENT_INFORMATION, self.equipmentInstance)
	picPanel:addChild(picCell)
	
	local getButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "equip_patch_list_page_get", 
		terminal_state = 0, 
		_equip = self.equipmentInstance,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	local comdiningButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"), nil, 
	{
		terminal_name = "equip_patch_list_page_combining", 
		terminal_state = 0, 
		_equip = self.equipmentInstance,
		_instance = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1"), nil, 
		{
			terminal_name = "prop_icon_new_cell_show_prop_info", 
			terminal_state = 0, 
			_prop = self.equipmentInstance
		}, 
		nil, 0)
	end
end

function EquipPatchListCell:close( ... )
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	head:removeAllChildren(true)
end

function EquipPatchListCell:onExit()
	--state_machine.remove("equip_patch_list_page_get")
	-- state_machine.remove("equip_patch_list_page_combining")
	--state_machine.remove("equip_patch_list_page_update")
	cacher.freeRef("list/list_equipment_sui_1.csb", self.roots[1])
end

function EquipPatchListCell:init(equipmentInstance, index)
	self.equipmentInstance = equipmentInstance
	if index < 7 then
		self:onInit()
	end
	self:setContentSize(EquipPatchListCell.__size)
	return self
end

function EquipPatchListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EquipPatchListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local picPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	if picPanel ~= nil then
		picPanel:removeAllChildren(true)
	end
	cacher.freeRef("list/list_equipment_sui_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:removeFromParent(false)
	root:stopAllActions()
	self.roots = {}
end

function EquipPatchListCell:createCell()
	local cell = EquipPatchListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
