-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的强化大师 界面
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
StrengthenMaster = class("StrengthenMasterClass", Window)
    
function StrengthenMaster:ctor()
    self.super:ctor()
    
	self.roots = {}
	self.group = {
		_equipStrengthen = nil,
		_equipRefine = nil,
		_treasureStrengthen = nil,
		_treasureRefine = nil,
	}
	
	self.ship_id = nil
	self.ship_info = nil
	
	self.equipStrengthenMasterInfo = {
		current_master_level = nil,
		next_master_need_level = nil, 
		current_master_depict = nil, 
		next_master_depict = nil, 
		current_master_property = nil, 
		next_master_property = nil,
	}
		
	self.equipRefineMasterInfo = {
		current_master_level = nil,
		next_master_need_level = nil, 
		current_master_depict = nil, 
		next_master_depict = nil, 
		current_master_property = nil, 
		next_master_property = nil,
	}
	
	self.treasureStrengthenMasterInfo = {
		current_master_level = nil,
		next_master_need_level = nil, 
		current_master_depict = nil, 
		next_master_depict = nil, 
		current_master_property = nil, 
		next_master_property = nil,
	}
	
	self.treasureRefineMasterInfo = {
		current_master_level = nil,
		next_master_need_level = nil, 
		current_master_depict = nil, 
		next_master_depict = nil, 
		current_master_property = nil, 
		next_master_property = nil,
	}
	
	self.button_name = {
		_equipStrengthen = "",
		_equipRefine = "",
		_treasureStrengthen = "",
		_treasureRefine = "",
	}
	
	app.load("client.cells.formation.strengthen_master_cell")
	app.load("client.player.UserInformationHeroStorage")
	app.load("client.player.EquipPlayerInfomation") 					--顶部用户信息
	app.load("client.packs.equipment.EquipStrengthenRefineStrorage")	--装备强化精炼主窗口
	app.load("client.packs.equipment.EquipRefinePage")					--装备精炼
	app.load("client.packs.equipment.EquipStrengthenPage")				--装备强化
	app.load("client.packs.equipment.EquipInformation")					--装备信息
	app.load("client.packs.treasure.TreasureControllerPanel")
	
    -- Initialize StrengthenMaster state machine.
    local function init_strengthen_master_terminal()
		local strengthen_master_close_terminal = {
            _name = "strengthen_master_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)			
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

		local strengthen_master_manager_terminal = {
            _name = "strengthen_master_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if terminal.last_terminal_name ~= params._datas.next_terminal_name then
					-- hide child window
            		for i, v in pairs(instance.group) do
						if v ~= nil then
							v:setVisible(false)
						end
					end
					
                    terminal.last_terminal_name = params._datas.next_terminal_name
            		state_machine.excute(params._datas.next_terminal_name, 0, params)
				end
				
				-- set select ui button is highlighted
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(false)
					terminal.select_button:setTouchEnabled(true)
				end
				terminal.page_name = params._datas.but_image
				if terminal.select_button == nil and params._datas.current_button_name ~= nil then
					terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				else
					terminal.select_button = params
				end
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(true)
					terminal.select_button:setTouchEnabled(false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 装备强化跳转
        local strengthen_master_show_equip_strengthen_view_terminal = {
            _name = "strengthen_master_show_equip_strengthen_view",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._equipStrengthen == nil then
					instance.group._equipStrengthen = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_023")
					state_machine.excute("strengthen_master_draw_equip_strengthen", 0, "strengthen_master_draw_equip_strengthen.")
				end
				instance.group._equipStrengthen:setVisible(true)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_38"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39_0"):setVisible(false)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_38"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39_0"):setVisible(false)
				end 
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 装备精炼跳转
        local strengthen_master_show_equip_refine_view_terminal = {
            _name = "strengthen_master_show_equip_refine_view",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._equipRefine == nil then
					instance.group._equipRefine = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_024")
					state_machine.excute("strengthen_master_draw_equip_refine", 0, "strengthen_master_draw_equip_refine.")
				end

				instance.group._equipRefine:setVisible(true)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_38"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39_0"):setVisible(false)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_38"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39_0"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 宝物强化跳转
        local strengthen_master_show_treasure_strengthen_view_terminal = {
            _name = "strengthen_master_show_treasure_strengthen_view",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._treasureStrengthen == nil then
					instance.group._treasureStrengthen = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_025")
					state_machine.excute("strengthen_master_draw_treasure_strengthen", 0, "strengthen_master_draw_treasure_strengthen.")
				end
				instance.group._treasureStrengthen:setVisible(true)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_38"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39_0"):setVisible(false)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_38"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39_0"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 宝物精炼跳转
        local strengthen_master_show_treasure_refine_view_terminal = {
            _name = "strengthen_master_show_treasure_refine_view",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._treasureRefine == nil then
					instance.group._treasureRefine = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_026")
					state_machine.excute("strengthen_master_draw_treasure_refine", 0, "strengthen_master_draw_treasure_refine.")
				end
				instance.group._treasureRefine:setVisible(true)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_38"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39_0"):setVisible(false)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_38"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_39_0"):setVisible(true)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 装备强化绘制
        local strengthen_master_draw_equip_strengthen_terminal = {
            _name = "strengthen_master_draw_equip_strengthen",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				-- 0武器	1头盔	2项链	3盔甲	4战马	5兵书
				local equips_id = {}
				local equips_min_level = nil
				local ship_equips = instance.ship_info.equipment
				
				for i, v in pairs(ship_equips) do
					if v.user_equiment_id ~= "0" then
						local tempType = tonumber(v.equipment_type)
						
						if tempType ~= nil and tempType < 4 then
							equips_id[tempType] = v.user_equiment_id
							
							local tempLevel = tonumber(v.user_equiment_grade)
							if equips_min_level == nil or tempLevel < equips_min_level then
								equips_min_level = tempLevel
							end	
						end
					end	
				end
				
				local flag = false
				local temp_master_data = nil
				local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 0)
				for i, v in ipairs(strengthen_master_data) do
					local need_level = dms.atoi(v, strengthen_master_info.need_level)
					if equips_min_level >= need_level then
						flag = true
					end
					if equips_min_level < need_level and flag == true then
						instance.equipStrengthenMasterInfo.current_master_level = dms.atoi(temp_master_data, strengthen_master_info.master_level)
						instance.equipStrengthenMasterInfo.next_master_need_level = need_level
						instance.equipStrengthenMasterInfo.current_master_depict = dms.atos(temp_master_data, strengthen_master_info.depict)
						instance.equipStrengthenMasterInfo.next_master_depict = dms.atos(v, strengthen_master_info.depict)
						instance.equipStrengthenMasterInfo.current_master_property = dms.atos(temp_master_data, strengthen_master_info.additional_property)
						instance.equipStrengthenMasterInfo.next_master_property = dms.atos(v, strengthen_master_info.additional_property)
						break
					end
					temp_master_data = v
				end
				
				-- 绘制装备
				for i = 1, 4 do
					local equip_cell = StrengthenMasterCell:createCell()
					equip_cell:init(1, equips_id[i - 1], instance.equipStrengthenMasterInfo.next_master_need_level)
					local equip_cell_pad = ccui.Helper:seekWidgetByName(root, string.format("Panel_022_%d", i))
					equip_cell_pad:removeAllChildren(true)
					equip_cell_pad:addChild(equip_cell)
				end
				
				-- 绘制强化大师等级
				local depict_text = ccui.Helper:seekWidgetByName(root, "Text_035")
				depict_text:setString(instance.equipStrengthenMasterInfo.current_master_depict)
				
				-- 绘制强化大师属性
				local zero_level_text = ccui.Helper:seekWidgetByName(root, "Text_037_0")
				zero_level_text:setVisible(true)
				
				local current_property_text = ccui.Helper:seekWidgetByName(root, "Text_037")
				current_property_text:setVisible(true)
				
				local next_property_text = ccui.Helper:seekWidgetByName(root, "Text_0378")
				
				local current_property = ""
				local next_property = ""
				
				if instance.equipStrengthenMasterInfo.current_master_level == 0 then
					current_property = _strengthen_master_info[1]
					zero_level_text:setString(current_property)
					current_property_text:setVisible(false)
				else
					local _property_str = instance:getDepictByDataString(instance.equipStrengthenMasterInfo.current_master_property)
					current_property = instance.equipStrengthenMasterInfo.current_master_depict .. "\r\n"
					current_property = current_property .. _property_str
					current_property_text:setString(current_property)
					zero_level_text:setVisible(false)
				end

				local _property_str = instance:getDepictByDataString(instance.equipStrengthenMasterInfo.next_master_property)
				next_property = instance.equipStrengthenMasterInfo.next_master_depict .. "\r\n"
				next_property = next_property .. "(" .. _strengthen_master_info[6] .. instance.equipStrengthenMasterInfo.next_master_need_level
							    .. _string_piece_info[6] .. ")" .. "\r\n"
				next_property = next_property .. _property_str		
				next_property_text:setString(next_property)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 装备精炼绘制
        local strengthen_master_draw_equip_refine_terminal = {
            _name = "strengthen_master_draw_equip_refine",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				-- 0武器	1头盔	2项链	3盔甲	4战马	5兵书
				local equips_id = {}
				local equips_min_level = nil
				local ship_equips = instance.ship_info.equipment
				
				for i, v in pairs(ship_equips) do
					if v.user_equiment_id ~= "0" then
						local tempType = tonumber(v.equipment_type)
						
						if tempType ~= nil and tempType < 4 then
							equips_id[tempType] = v.user_equiment_id
							
							local tempLevel = tonumber(v.equiment_refine_level)
							if equips_min_level == nil or tempLevel < equips_min_level then
								equips_min_level = tempLevel
							end	
						end
					end	
				end
				
				local flag = false
				local temp_master_data = nil
				local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 1)
				for i, v in ipairs(strengthen_master_data) do
					local need_level = dms.atoi(v, strengthen_master_info.need_level)
					if equips_min_level >= need_level then
						flag = true
					end
					if equips_min_level < need_level and flag == true then
						instance.equipStrengthenMasterInfo.current_master_level = dms.atoi(temp_master_data, strengthen_master_info.master_level)
						instance.equipStrengthenMasterInfo.next_master_need_level = need_level
						instance.equipStrengthenMasterInfo.current_master_depict = dms.atos(temp_master_data, strengthen_master_info.depict)
						instance.equipStrengthenMasterInfo.next_master_depict = dms.atos(v, strengthen_master_info.depict)
						instance.equipStrengthenMasterInfo.current_master_property = dms.atos(temp_master_data, strengthen_master_info.additional_property)
						instance.equipStrengthenMasterInfo.next_master_property = dms.atos(v, strengthen_master_info.additional_property)
						break
					end
					temp_master_data = v
				end
				
				-- 绘制装备
				for i = 1, 4 do
					local equip_cell = StrengthenMasterCell:createCell()
					equip_cell:init(2, equips_id[i-1], instance.equipStrengthenMasterInfo.next_master_need_level)
					local equip_cell_pad = ccui.Helper:seekWidgetByName(root, string.format("Panel_022_%d_%d", i, 27 + 2*i))
					equip_cell_pad:removeAllChildren(true)
					equip_cell_pad:addChild(equip_cell)
				end
				
				-- 绘制强化大师等级
				local depict_text = ccui.Helper:seekWidgetByName(root, "Text_035_42")
				depict_text:setString(instance.equipStrengthenMasterInfo.current_master_depict)
				
				-- 绘制强化大师属性
				local zero_level_text = ccui.Helper:seekWidgetByName(root, "Text_037_46_0")
				zero_level_text:setVisible(true)
				
				local current_property_text = ccui.Helper:seekWidgetByName(root, "Text_037_46")
				current_property_text:setVisible(true)
				
				local next_property_text = ccui.Helper:seekWidgetByName(root, "Text_0378_48")
				
				local current_property = ""
				local next_property = ""
				
				if instance.equipStrengthenMasterInfo.current_master_level == 0 then
					current_property = _strengthen_master_info[2]
					zero_level_text:setString(current_property)
					current_property_text:setVisible(false)
				else
					local _property_str = instance:getDepictByDataString(instance.equipStrengthenMasterInfo.current_master_property)
					current_property = instance.equipStrengthenMasterInfo.current_master_depict .. "\r\n"
					current_property = current_property .. _property_str
					current_property_text:setString(current_property)
					zero_level_text:setVisible(false)
				end

				local _property_str = instance:getDepictByDataString(instance.equipStrengthenMasterInfo.next_master_property)
				next_property = instance.equipStrengthenMasterInfo.next_master_depict .. "\r\n"
				next_property = next_property .. "(" .. _strengthen_master_info[7] .. instance.equipStrengthenMasterInfo.next_master_need_level
							    .. _string_piece_info[6] .. ")" .. "\r\n"
				next_property = next_property .. _property_str		
				next_property_text:setString(next_property)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 宝物强化绘制
        local strengthen_master_draw_treasure_strengthen_terminal = {
            _name = "strengthen_master_draw_treasure_strengthen",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				-- 0武器	1头盔	2项链	3盔甲	4战马	5兵书
				local equips_id = {}
				local equips_min_level = nil
				local ship_equips = instance.ship_info.equipment
				
				for i, v in pairs(ship_equips) do
					if v.user_equiment_id ~= "0" then
						local tempType = zstring.tonumber(v.equipment_type)
						if tempType >= 4 and tempType <= 5 then
							equips_id[tempType] = v.user_equiment_id
							
							local tempLevel = tonumber(v.user_equiment_grade)
							if equips_min_level == nil or tempLevel < equips_min_level then
								equips_min_level = tempLevel
							end	
						end
					end	
				end
				
				local flag = false
				local temp_master_data = nil
				local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 2)
				for i, v in ipairs(strengthen_master_data) do
					local need_level = dms.atoi(v, strengthen_master_info.need_level)
					if equips_min_level >= need_level then
						flag = true
					end
					if equips_min_level < need_level and flag == true then
						instance.equipStrengthenMasterInfo.current_master_level = dms.atoi(temp_master_data, strengthen_master_info.master_level)
						instance.equipStrengthenMasterInfo.next_master_need_level = need_level
						instance.equipStrengthenMasterInfo.current_master_depict = dms.atos(temp_master_data, strengthen_master_info.depict)
						instance.equipStrengthenMasterInfo.next_master_depict = dms.atos(v, strengthen_master_info.depict)
						instance.equipStrengthenMasterInfo.current_master_property = dms.atos(temp_master_data, strengthen_master_info.additional_property)
						instance.equipStrengthenMasterInfo.next_master_property = dms.atos(v, strengthen_master_info.additional_property)
						break
					end
					temp_master_data = v
				end
				
				-- 绘制装备
				for i = 1, 2 do
					local equip_cell = StrengthenMasterCell:createCell()
					equip_cell:init(3, equips_id[i+3], instance.equipStrengthenMasterInfo.next_master_need_level)
					local equip_cell_pad = ccui.Helper:seekWidgetByName(root, string.format("Panel_022_%d_%d_%d", i, 27 + 2*i, 36 + 2*i))
					equip_cell_pad:removeAllChildren(true)
					equip_cell_pad:addChild(equip_cell)
				end
				
				-- 绘制强化大师等级
				local depict_text = ccui.Helper:seekWidgetByName(root, "Text_035_42_52")
				depict_text:setString(instance.equipStrengthenMasterInfo.current_master_depict)
				
				-- 绘制强化大师属性
				local zero_level_text = ccui.Helper:seekWidgetByName(root, "Text_037_46_56")
				zero_level_text:setVisible(true)
				
				local current_property_text = ccui.Helper:seekWidgetByName(root, "Text_037_46_57")
				current_property_text:setVisible(true)
				
				local next_property_text = ccui.Helper:seekWidgetByName(root, "Text_0378_48_58")
				
				local current_property = ""
				local next_property = ""
				
				if instance.equipStrengthenMasterInfo.current_master_level == 0 then
					current_property = _strengthen_master_info[3]
					zero_level_text:setString(current_property)
					current_property_text:setVisible(false)
				else
					local _property_str = instance:getDepictByDataString(instance.equipStrengthenMasterInfo.current_master_property)
					current_property = instance.equipStrengthenMasterInfo.current_master_depict .. "\r\n"
					current_property = current_property .. _property_str
					current_property_text:setString(current_property)
					zero_level_text:setVisible(false)
				end

				local _property_str = instance:getDepictByDataString(instance.equipStrengthenMasterInfo.next_master_property)
				next_property = instance.equipStrengthenMasterInfo.next_master_depict .. "\r\n"
				next_property = next_property .. "(" .. _strengthen_master_info[8] .. instance.equipStrengthenMasterInfo.next_master_need_level
							    .. _string_piece_info[6] .. ")" .. "\r\n"
				next_property = next_property .. _property_str		
				next_property_text:setString(next_property)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 宝物精炼绘制
        local strengthen_master_draw_treasure_refine_terminal = {
            _name = "strengthen_master_draw_treasure_refine",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				-- 0武器	1头盔	2项链	3盔甲	4战马	5兵书
				local equips_id = {}
				local equips_min_level = nil
				local ship_equips = instance.ship_info.equipment
				
				for i, v in pairs(ship_equips) do
					if v.user_equiment_id ~= "0" then
						local tempType = tonumber(v.equipment_type)
						
						if tempType >= 4 and tempType <= 5 then
							equips_id[tempType] = v.user_equiment_id
							
							local tempLevel = tonumber(v.equiment_refine_level)
							if equips_min_level == nil or tempLevel < equips_min_level then
								equips_min_level = tempLevel
							end	
						end
					end	
				end
				
				local flag = false
				local temp_master_data = nil
				local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 3)
				for i, v in ipairs(strengthen_master_data) do
					local need_level = dms.atoi(v, strengthen_master_info.need_level)
					if equips_min_level >= need_level then
						flag = true
					end
					if equips_min_level < need_level and flag == true then
						instance.equipStrengthenMasterInfo.current_master_level = dms.atoi(temp_master_data, strengthen_master_info.master_level)
						instance.equipStrengthenMasterInfo.next_master_need_level = need_level
						instance.equipStrengthenMasterInfo.current_master_depict = dms.atos(temp_master_data, strengthen_master_info.depict)
						instance.equipStrengthenMasterInfo.next_master_depict = dms.atos(v, strengthen_master_info.depict)
						instance.equipStrengthenMasterInfo.current_master_property = dms.atos(temp_master_data, strengthen_master_info.additional_property)
						instance.equipStrengthenMasterInfo.next_master_property = dms.atos(v, strengthen_master_info.additional_property)
						break
					end
					temp_master_data = v
				end
				
				-- 绘制装备
				for i = 1, 2 do
					local equip_cell = StrengthenMasterCell:createCell()
					equip_cell:init(4, equips_id[i+3], instance.equipStrengthenMasterInfo.next_master_need_level)
					local equip_cell_pad = ccui.Helper:seekWidgetByName(root, string.format("Panel_022_%d_%d_%d_%d", i, 27 + 2*i, 36 + 2*i, 1 + 2*i))
					equip_cell_pad:removeAllChildren(true)
					equip_cell_pad:addChild(equip_cell)
				end
				
				-- 绘制强化大师等级
				local depict_text = ccui.Helper:seekWidgetByName(root, "Text_035_42_52_7")
				depict_text:setString(instance.equipStrengthenMasterInfo.current_master_depict)
				
				-- 绘制强化大师属性
				local zero_level_text = ccui.Helper:seekWidgetByName(root, "Text_037_46_56_11")
				zero_level_text:setVisible(true)
				
				local current_property_text = ccui.Helper:seekWidgetByName(root, "Text_037_46_57_15")
				current_property_text:setVisible(true)
				
				local next_property_text = ccui.Helper:seekWidgetByName(root, "Text_0378_48_58_13")
				
				local current_property = ""
				local next_property = ""
				
				if instance.equipStrengthenMasterInfo.current_master_level == 0 then
					current_property = _strengthen_master_info[4]
					zero_level_text:setString(current_property)
					current_property_text:setVisible(false)
				else
					local _property_str = instance:getDepictByDataString(instance.equipStrengthenMasterInfo.current_master_property)
					current_property = instance.equipStrengthenMasterInfo.current_master_depict .. "\r\n"
					current_property = current_property .. _property_str
					current_property_text:setString(current_property)
					zero_level_text:setVisible(false)
				end

				local _property_str = instance:getDepictByDataString(instance.equipStrengthenMasterInfo.next_master_property)
				next_property = instance.equipStrengthenMasterInfo.next_master_depict .. "\r\n"
				next_property = next_property .. "(" .. _strengthen_master_info[9] .. instance.equipStrengthenMasterInfo.next_master_need_level
							    .. _string_piece_info[6] .. ")" .. "\r\n"
				next_property = next_property .. _property_str		
				next_property_text:setString(next_property)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(strengthen_master_close_terminal)	
		state_machine.add(strengthen_master_manager_terminal)	
		
		state_machine.add(strengthen_master_show_equip_strengthen_view_terminal)	
		state_machine.add(strengthen_master_show_equip_refine_view_terminal)	
		state_machine.add(strengthen_master_show_treasure_strengthen_view_terminal)	
		state_machine.add(strengthen_master_show_treasure_refine_view_terminal)	
		
		state_machine.add(strengthen_master_draw_equip_strengthen_terminal)	
		state_machine.add(strengthen_master_draw_equip_refine_terminal)	
		state_machine.add(strengthen_master_draw_treasure_strengthen_terminal)	
		state_machine.add(strengthen_master_draw_treasure_refine_terminal)	
		
        state_machine.init()
    end
    
    init_strengthen_master_terminal()
end

function StrengthenMaster:init(_ship_id)
	self.ship_id = _ship_id
	self.ship_info = _ED.user_ship[self.ship_id]
end

function StrengthenMaster:getDepictByDataString(_data_string)
	if _data_string == "-1" then
		return ""
	end	

	local _depict = ""
	local _datas = zstring.split(_data_string, "|")
	
	for i, v in ipairs(_datas) do
		local _data = string.split(v, ",")
		local _type = tonumber(_data[1])
		local _value = _data[2]
		
		if _type > 3 and _type < 18 or _type > 32 and _type < 37 then
			_value = string.format("%.1f", tonumber(_data[2])).."%"
		end
		
		_depict = _depict .. string_equiprety_name[_type + 1] .. _value .. "\r\n"
	end
	
	return _depict
end

function StrengthenMaster:unlockStrengthenMaster()
	--> print("按等级解锁强化大师功能，例如15级时，显示装备强化、宝物强化，宝物不够2个时显示宝物强化灰色不可用", _ED.user_info.user_grade)
	local root = self.roots[1]
	
	self.button_name._equipStrengthen = "Button_02"
	self.button_name._equipRefine = "Button_03"
	self.button_name._treasureStrengthen = "Button_04"
	self.button_name._treasureRefine = "Button_06"
	
	local all_func_panel = ccui.Helper:seekWidgetByName(root, "Panel_001")
	local low_func_panel = ccui.Helper:seekWidgetByName(root, "Panel_002")
	
	-- all_func_panel:setVisible(false)
	-- low_func_panel:setVisible(true)
	-- self.button_name._equipStrengthen = "Button_02_2"
	-- self.button_name._treasureStrengthen = "Button_04_6"
	
	low_func_panel:setVisible(false)
	all_func_panel:setVisible(true)
	all_func_panel:getChildByName("Button_06"):setVisible(true)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_37"):setVisible(true)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_38"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_39"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_39_0"):setVisible(false)
	
	
	local equips_id = {}
	local ship_equips = self.ship_info.equipment
	
	for i, v in pairs(ship_equips) do
		if v.user_equiment_id ~= "0" then
			local tempType = zstring.tonumber(v.equipment_type)
			
			if tempType >= 4 and tempType <= 5 then
				equips_id[tempType] = v.user_equiment_id
			end
		end	
	end
	
	for i = 1, 2 do
		if equips_id[i+3] == nil then
			local tsDisableBtn = ccui.Helper:seekWidgetByName(root, self.button_name._treasureStrengthen)
			local trDisableBtn = ccui.Helper:seekWidgetByName(root, self.button_name._treasureRefine)
			tsDisableBtn:setEnabled(false)
			tsDisableBtn:setBright(false)
			trDisableBtn:setEnabled(false)
			trDisableBtn:setBright(false)
			
			break
		end
	end
end

function StrengthenMaster:onEnterTransitionFinish()
    local csbStrengthenMaster = csb.createNode("formation/strengthen_masters.csb")
    self:addChild(csbStrengthenMaster)
	local root = csbStrengthenMaster:getChildByName("root"):getChildByName("Panel_qhds")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("formation/strengthen_masters.csb")
    csbStrengthenMaster:runAction(action)
    action:play("window_open", false)
	
	self.group = {
		_equipStrengthen = nil,
		_equipRefine = nil,
		_treasureStrengthen = nil,
		_treasureRefine = nil,
	}
	
	self:unlockStrengthenMaster()
	
	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_05"), nil, 
	{
		terminal_name = "strengthen_master_close", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_01"), nil, 
	{
		terminal_name = "strengthen_master_close", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	-- 装备强化
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, self.button_name._equipStrengthen), nil, 
	{
		terminal_name = "strengthen_master_manager", 	
		next_terminal_name = "strengthen_master_show_equip_strengthen_view",	
		current_button_name = self.button_name._equipStrengthen,  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	
	-- 装备精炼
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, self.button_name._equipRefine), nil, 
	{
		terminal_name = "strengthen_master_manager", 	
		next_terminal_name = "strengthen_master_show_equip_refine_view",	
		current_button_name = self.button_name._equipRefine,  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	
	-- 宝物强化
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, self.button_name._treasureStrengthen), nil, 
	{
		terminal_name = "strengthen_master_manager", 	
		next_terminal_name = "strengthen_master_show_treasure_strengthen_view",	
		current_button_name = self.button_name._treasureStrengthen,  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	
	-- 宝物精炼
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, self.button_name._treasureRefine), nil, 
	{
		terminal_name = "strengthen_master_manager", 	
		next_terminal_name = "strengthen_master_show_treasure_refine_view",	
		current_button_name = self.button_name._treasureRefine,  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
end

function StrengthenMaster:onExit()
	state_machine.remove("strengthen_master_close")
	state_machine.remove("strengthen_master_manager")
	
	state_machine.remove("strengthen_master_show_equip_strengthen_view")
	state_machine.remove("strengthen_master_show_equip_refine_view")
	state_machine.remove("strengthen_master_show_treasure_strengthen_view")
	state_machine.remove("strengthen_master_show_treasure_refine_view")
	
	state_machine.remove("strengthen_master_draw_equip_strengthen")
	state_machine.remove("strengthen_master_draw_equip_refine")
	state_machine.remove("strengthen_master_draw_treasure_strengthen")
	state_machine.remove("strengthen_master_draw_treasure_refine")
end