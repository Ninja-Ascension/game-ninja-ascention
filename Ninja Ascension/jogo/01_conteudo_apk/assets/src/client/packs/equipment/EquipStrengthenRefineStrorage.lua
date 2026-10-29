----------------------------------------------------------------------------------------------------
-- 说明：装备强化精炼仓库
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipStrengthenRefineStrorage = class("EquipStrengthenRefineStrorageClass", Window)
EquipStrengthenRefineStrorage._equipment_font_name = ""

function EquipStrengthenRefineStrorage:ctor()
    self.super:ctor()
	self.roots = {}
	self.group = {
		_equipStrengthenPage = nil,
		_equipRefinePage = nil,
		_equipInformation = nil,
		_equipStarPage = nil , --升星 数码
	}
	app.load("client.packs.equipment.EquipStrengthenPage")
	app.load("client.packs.equipment.EquipRefinePage")
	self.equipmentInstance = nil
	self.types = nil
	self._cell = nil
	self._string_type = nil
	self.pageshowindex = 1

	self.ship = nil -- 当前装备对应的英雄实例
	self.equipType = nil --当前装备的装备位
    local function init_equip_strengthen_refine_strorage_terminal()
		
		local equip_strengthen_refine_strorage_manager_terminal = {
            _name = "equip_strengthen_refine_strorage_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local arena_grade = 0
				if  tonumber(params._datas.openWinId) == -1 then
					arena_grade = 0
				else
					arena_grade=dms.int(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.level)
				end
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
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
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_strengthen_refine_strorage_to_strengthen_terminal = {
            _name = "equip_strengthen_refine_strorage_to_strengthen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._equipStrengthenPage == nil then
					instance.group._equipStrengthenPage = EquipStrengthenPage:new()
					instance.group._equipStrengthenPage:init(params._datas._instance.equipmentInstance, params._datas._cell, params._datas._string_type)
					fwin:open(instance.group._equipStrengthenPage, fwin._background)
				end
				instance.group._equipStrengthenPage:setVisible(true)
				
				if "strengthen_master" ~= params._datas._string_type then
					state_machine.excute("equip_storage_not_show", 0, "equip_storage_not_show.")
				end
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_4"):setVisible(false)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					instance.pageshowindex = 2
					state_machine.excute("equip_strengthen_change_equip_update",0,"")
				elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					or __lua_project_id == __lua_project_yugioh
					then 
					instance:onSelectTab(1)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_strengthen_refine_strorage_to_refine_terminal = {
            _name = "equip_strengthen_refine_strorage_to_refine",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._equipRefinePage == nil then
					instance.group._equipRefinePage = EquipRefinePage:new()
					instance.group._equipRefinePage:init(params._datas._instance.equipmentInstance, params._datas._cell, params._datas._string_type)
					fwin:open(instance.group._equipRefinePage, fwin._background)
				end
				instance.group._equipRefinePage:setVisible(true)
				
				if "strengthen_master" ~= params._datas._string_type then
					state_machine.excute("equip_storage_not_show", 0, "equip_storage_not_show.")
				end
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_4"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(false)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					instance.pageshowindex = 3
					state_machine.excute("equip_refine_change_equip_refush",0,"")
				elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					or __lua_project_id == __lua_project_yugioh
					then 
					instance:onSelectTab(2)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--升星
		local equip_strengthen_refine_strorage_to_star_terminal = {
            _name = "equip_strengthen_refine_strorage_to_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._equipStarPage == nil then
					app.load("client.packs.equipment.EquipUpStarPage")
					instance.group._equipStarPage = EquipUpStarPage:new()
					instance.group._equipStarPage:init(params._datas._instance.equipmentInstance, params._datas._cell, params._datas._string_type)
					fwin:open(instance.group._equipStarPage, fwin._background)
				end
				instance.group._equipStarPage:setVisible(true)
				if "strengthen_master" ~= params._datas._string_type then
					state_machine.excute("equip_storage_not_show", 0, "equip_storage_not_show.")
				end
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					or __lua_project_id == __lua_project_yugioh
					then 
					instance:onSelectTab(3)
				elseif __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					instance.pageshowindex = 4
					state_machine.excute("equip_up_star_change_equip_update",0,"")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local equip_strengthen_refine_strorage_back_terminal = {
            _name = "equip_strengthen_refine_strorage_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- close child window
				for i, v in pairs(instance.group) do
					if v ~= nil then
						fwin:close(v)
					end
				end
				if "strengthen_master" == self._string_type then
					local FormationWnd = nil
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						FormationWnd = fwin:find("FormationTigerGateClass")
					else
						FormationWnd = fwin:find("FormationClass")
					end
					local StrengthenMasterWnd = fwin:find("StrengthenMasterClass"):setVisible(true)
					if FormationWnd ~= nil then 
						FormationWnd:setVisible(true)
						fwin:close(fwin:find("EquipPlayerInfomationClass"))					
					end
					if StrengthenMasterWnd ~= nil then 
						StrengthenMasterWnd:setVisible(true)
					end 
				else
					state_machine.excute("equip_storage_show", 0, "equip_storage_show.")
					
					state_machine.excute("equip_list_view_del_and_insert_cell", 0, {_datas = {_cell = instance._cell}})
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then			--龙虎门项目控制
						fwin:close(fwin:find("EquipPlayerInfomationClass"))
					end
				end	
				
				if "formation" == self._string_type then
					state_machine.excute("formation_cell_on_show", 0, "formation_cell_on_show.")
					state_machine.excute("equip_formation_choice_show", 0, "equip_formation_choice_show.")
					state_machine.excute("formation_property_change_equip_info", 0, "formation_property_change_equip_info.")
					state_machine.excute("formation_property_change_by_level_up", 0, "")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then			--龙虎门项目控制
						state_machine.excute("home_show_event", 0, "home_show_event.")		
					end
				elseif "formationUpStar" == self._string_type then 
					--升星返回
					state_machine.excute("formation_cell_on_show", 0, "formation_cell_on_show.")
					state_machine.excute("equip_formation_choice_show", 0, "equip_formation_choice_show.")
					
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					state_machine.excute("equip_icon_listView_close",0,"")
					state_machine.excute("hero_develop_page_show_nowpage",0,"")	
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--信息
		local equip_strengthen_refine_strorage_to_information_terminal = {
            _name = "equip_strengthen_refine_strorage_to_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._equipInformation == nil then
					
					instance.group._equipInformation = EquipInformation:new()
					instance.group._equipInformation:init(params._datas._instance.equipmentInstance, params._datas._cell,params._datas._string_type)
					fwin:open(instance.group._equipInformation, fwin._background)
				end
				instance.group._equipInformation:setVisible(true)
				
				if "strengthen_master" ~= params._datas._string_type then
					state_machine.excute("equip_storage_not_show", 0, "equip_storage_not_show.")
				end
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_4"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(false)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					instance.pageshowindex = 1
					state_machine.excute("equip_information_change_equip_update",0,"")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--列表切换
		local equip_strengthen_refine_strorage_to_change_equip_terminal = {
            _name = "equip_strengthen_refine_strorage_to_change_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local equip = params
            	for i,v in pairs(instance.group) do
            		if v ~= nil and v == instance.group._equipInformation then
            			v:init(equip,instance._cell,instance._string_type)
        			elseif v ~= nil and v == instance.group._equipStrengthenPage then
        				v:init(equip,instance._cell,instance._string_type)
        			elseif v ~= nil and v == instance.group._equipRefinePage then
						v:init(equip,instance._cell)
					elseif v ~= nil and v == instance.group._equipStarPage then
						v:init(equip,instance._cell,instance._string_type)
        			end
            	end
            	instance:init(equip,instance.types,instance._cell,instance._string_type)
            	if instance.pageshowindex == 1 then
            		state_machine.excute("equip_information_change_equip_update",0,"")
        		elseif instance.pageshowindex == 2 then			
					state_machine.excute("equip_strengthen_change_equip_update",0,"")
        		elseif instance.pageshowindex == 3 then
        			state_machine.excute("equip_refine_change_equip_refush",0,"")
        		elseif instance.pageshowindex == 4 then
        			if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then 
        				local maxStar = dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.star_level)
        				if maxStar == -1 then
        					--不能升星，需要切换到基础信息
        					state_machine.excute("equip_strengthen_refine_strorage_manager", 0, 
							{
								_datas = {
									terminal_name = "equip_strengthen_refine_strorage_manager", 	
									next_terminal_name = "equip_strengthen_refine_strorage_to_information",	
									current_button_name = "Button_equipment_0",  	
									but_image = "", 	
									terminal_state = 0, 
									_instance = self,
									_cell = self._cell,
									_string_type = self._string_type,
									openWinId = -1,
									isPressedActionEnabled = false
								}
							})
    					else
        					state_machine.excute("equip_up_star_change_equip_update",0,"")	
        				end
        			else
        				state_machine.excute("equip_up_star_change_equip_update",0,"")
        			end
        		end
				instance:onUpdateDrawButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        		--装备卸下更换之后的button状态变更
		local equip_strengthen_refine_strorage_to_update_draw_button_terminal = {
            _name = "equip_strengthen_refine_strorage_to_update_draw_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

           --单纯的关闭所有,然后到阵容界面
		local equip_strengthen_refine_strorage_to_close_all_terminal = {
            _name = "equip_strengthen_refine_strorage_to_close_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				for i, v in pairs(instance.group) do
					if v ~= nil then
						fwin:close(v)
					end
				end
				state_machine.excute("equip_icon_listView_close",0,"")
				fwin:close(fwin:find("EquipPlayerInfomationClass"))
				fwin:close(fwin:find("UserInformationHeroStorageClass"))
				fwin:close(fwin:find("UserTopInfoAClass"))
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_strengthen_refine_strorage_manager_terminal)
		state_machine.add(equip_strengthen_refine_strorage_to_strengthen_terminal)
		state_machine.add(equip_strengthen_refine_strorage_to_refine_terminal)
		state_machine.add(equip_strengthen_refine_strorage_back_terminal)
		state_machine.add(equip_strengthen_refine_strorage_to_information_terminal)
		state_machine.add(equip_strengthen_refine_strorage_to_change_equip_terminal)
		state_machine.add(equip_strengthen_refine_strorage_to_update_draw_button_terminal)
		state_machine.add(equip_strengthen_refine_strorage_to_close_all_terminal)
		state_machine.add(equip_strengthen_refine_strorage_to_star_terminal)
        state_machine.init()
    end
    
    init_equip_strengthen_refine_strorage_terminal()
end

-- 按钮的状态显示控制
function EquipStrengthenRefineStrorage:onUpdateDrawButton()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local root = self.roots[1]
		local Panel_line = ccui.Helper:seekWidgetByName(root,"Panel_line")
		local Button_equ_tihuan = ccui.Helper:seekWidgetByName(root,"Button_equ_tihuan")
		local Button_equ_xiexia = ccui.Helper:seekWidgetByName(root,"Button_equ_xiexia")
		local Text_zhuangbei = ccui.Helper:seekWidgetByName(root,"Text_zhuangbei")
		if EquipStrengthenRefineStrorage._equipment_font_name == "" then 
			EquipStrengthenRefineStrorage._equipment_font_name = Text_zhuangbei:getFontName()
		end
		local ship_id = self.equipmentInstance.ship_id
		local ship = nil
		local equipType = nil
		if tonumber(ship_id) > 0 then
			ship = _ED.user_ship[ship_id]
			self.ship = ship
			equipType = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type)
			self.equipType = equipType
			Panel_line:setVisible(true)
			Button_equ_tihuan:setVisible(true)
			Button_equ_xiexia:setVisible(true)
			Text_zhuangbei:setVisible(true)
			if tonumber(ship.captain_type) == 0 then
				Text_zhuangbei:setString(_ED.user_info.user_name)
				if ___is_open_leadname == true then
					Text_zhuangbei:setFontName("")
					Text_zhuangbei:setFontSize(Text_zhuangbei:getFontSize())
				end
			else
				if ___is_open_leadname == true then
					Text_zhuangbei:setFontName(EquipStrengthenRefineStrorage._equipment_font_name)
				end
				Text_zhuangbei:setString(ship.captain_name)
			end
		else
			Button_equ_tihuan:setVisible(false)
			Button_equ_xiexia:setVisible(false)
			Panel_line:setVisible(false)
			Text_zhuangbei:setVisible(false)
			Text_zhuangbei:setString("")
			state_machine.excute("equip_icon_listview_update_listview",0,self.equipmentInstance)
		end
	end
	local Button_shengxing = ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengxing")
	if Button_shengxing ~= nil then
		local maxStar = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.star_level)
		if maxStar <= zstring.tonumber(self.equipmentInstance.current_star_level) or maxStar == -1 then 
			Button_shengxing:setTouchEnabled(false)
			Button_shengxing:setColor(cc.c3b(150, 150, 150))
		else
			Button_shengxing:setTouchEnabled(true)
			Button_shengxing:setColor(cc.c3b(255, 255, 255))
		end
	end
end

--选择标签页
function EquipStrengthenRefineStrorage:onSelectTab(index)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(index == 1)
	ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(index == 2)
	ccui.Helper:seekWidgetByName(root, "Image_4_1"):setVisible(index == 3)
	
end

function EquipStrengthenRefineStrorage:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		state_machine.excute("hero_develop_page_hidden_nowpage",0,"")
	end	
    local csbEquipStrengthenRefineStrorage = csb.createNode("packs/EquipStorage/equipment_strengthen.csb")
	self:addChild(csbEquipStrengthenRefineStrorage)
	
	local root = csbEquipStrengthenRefineStrorage:getChildByName("root")
	table.insert(self.roots, root)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		app.load("client.packs.equipment.EquipIconListView")
		state_machine.excute("equip_icon_listView_open",0,"")
		state_machine.excute("equip_icon_listview_first_set_index",0,self.equipmentInstance)
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment"), nil, 
	{
		terminal_name = "equip_strengthen_refine_strorage_manager", 	
		next_terminal_name = "equip_strengthen_refine_strorage_to_strengthen",	
		current_button_name = "Button_equipment",  	
		but_image = "", 	
		terminal_state = 0,
		_instance = self, 
		_cell = self._cell,
		_string_type = self._string_type,
		openWinId = -1,
		isPressedActionEnabled = false
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pieces_equipment"), nil, 
	{
		terminal_name = "equip_strengthen_refine_strorage_manager", 	
		next_terminal_name = "equip_strengthen_refine_strorage_to_refine",	
		current_button_name = "Button_pieces_equipment",  	
		but_image = "", 	
		terminal_state = 0, 
		_instance = self,
		_cell = self._cell,
		_string_type = self._string_type,
		openWinId = 40,
		isPressedActionEnabled = false
	}, 
	nil, 0)

	local Button_shengxing = ccui.Helper:seekWidgetByName(root, "Button_shengxing")
	if Button_shengxing ~= nil then
		local maxStar = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.star_level)
		if maxStar <= zstring.tonumber(self.equipmentInstance.current_star_level) or maxStar == -1 then 
			Button_shengxing:setTouchEnabled(false)
			Button_shengxing:setColor(cc.c3b(150, 150, 150))
		end
		fwin:addTouchEventListener(Button_shengxing, nil, 
		{
			terminal_name = "equip_strengthen_refine_strorage_manager", 	
			next_terminal_name = "equip_strengthen_refine_strorage_to_star",	
			current_button_name = "Button_shengxing",  	
			but_image = "", 	
			terminal_state = 0, 
			_instance = self,
			_cell = self._cell,
			_string_type = self._string_type,
			openWinId = -1,
			isPressedActionEnabled = false
		}, 
		nil, 0)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment_0"), nil, 
		{
			terminal_name = "equip_strengthen_refine_strorage_manager", 	
			next_terminal_name = "equip_strengthen_refine_strorage_to_information",	
			current_button_name = "Button_equipment_0",  	
			but_image = "", 	
			terminal_state = 0, 
			_instance = self,
			_cell = self._cell,
			_string_type = self._string_type,
			openWinId = -1,
			isPressedActionEnabled = false
		}, 
		nil, 0)
	end
	local buttonBack = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "equip_strengthen_refine_strorage_back", 	
		terminal_state = 0, 
		_string_type = self._string_type,
		isPressedActionEnabled = true
	}, nil, 2)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		ccui.Helper:seekWidgetByName(root, "Button_79999"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "ImageView_5073_d"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_79999"):setVisible(false)
	end
	if tonumber(self.types) == 1 then
		-- state_machine.excute("equip_strengthen_refine_strorage_to_strengthen", 0, "equip_strengthen_refine_strorage_to_strengthen.")
		state_machine.excute("equip_strengthen_refine_strorage_manager", 0, 
		{
			_datas = {
				terminal_name = "equip_strengthen_refine_strorage_manager", 	
				next_terminal_name = "equip_strengthen_refine_strorage_to_strengthen",	
				current_button_name = "Button_equipment",  	
				but_image = "", 	
				terminal_state = 0, 
				_instance = self,
				_cell = self._cell,
				_string_type = self._string_type,
				openWinId = -1,
				isPressedActionEnabled = false
			}
		})
	elseif tonumber(self.types) == 2 then
		-- state_machine.excute("equip_strengthen_refine_strorage_to_refine", 0, "equip_strengthen_refine_strorage_to_refine.")
		state_machine.excute("equip_strengthen_refine_strorage_manager", 0, 
		{
			_datas = {
				terminal_name = "equip_strengthen_refine_strorage_manager", 	
				next_terminal_name = "equip_strengthen_refine_strorage_to_refine",	
				current_button_name = "Button_pieces_equipment",  	
				but_image = "", 	
				terminal_state = 0, 
				_instance = self,
				_cell = self._cell,
				_string_type = self._string_type,
				openWinId = 40,
				isPressedActionEnabled = false
			}
		})
	elseif tonumber(self.types) == 0 then --信息
		state_machine.excute("equip_strengthen_refine_strorage_manager", 0, 
		{
			_datas = {
				terminal_name = "equip_strengthen_refine_strorage_manager", 	
				next_terminal_name = "equip_strengthen_refine_strorage_to_information",	
				current_button_name = "Button_equipment_0",  	
				but_image = "", 	
				terminal_state = 0, 
				_instance = self,
				_cell = self._cell,
				_string_type = self._string_type,
				openWinId = -1,
				isPressedActionEnabled = false
			}
		})
	elseif tonumber(self.types) == 4 then
		--主动跳转到升星
		state_machine.excute("equip_strengthen_refine_strorage_manager", 0, 
		{
			_datas = {
				terminal_name = "equip_strengthen_refine_strorage_manager", 	
				next_terminal_name = "equip_strengthen_refine_strorage_to_star",	
				current_button_name = "Button_shengxing",  	
				but_image = "", 	
				terminal_state = 0, 
				_instance = self,
				_cell = self._cell,
				_string_type = self._string_type,
				openWinId = -1,
				isPressedActionEnabled = false
			}
		})
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self:onUpdateDrawButton()

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equ_tihuan"), nil, 
		{
			terminal_name = "open_replacement_ship_equip_window", 	
			but_image = "", 	
			terminal_state = 0,
			_self = self, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equ_xiexia"), nil, 
		{
			terminal_name = "replacement_or_unload_ship_equip_wear_request", 	
			but_image = "", 	
			terminal_state = 0,
			_self = self, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
end


function EquipStrengthenRefineStrorage:onExit()
	state_machine.remove("equip_strengthen_refine_strorage_manager")
	state_machine.remove("equip_strengthen_refine_strorage_to_strengthen")
	state_machine.remove("equip_strengthen_refine_strorage_to_refine")
	state_machine.remove("equip_strengthen_refine_strorage_to_star")
	state_machine.remove("equip_strengthen_refine_strorage_back")
	state_machine.remove("equip_strengthen_refine_strorage_to_information")
	state_machine.remove("equip_strengthen_refine_strorage_to_change_equip")
	state_machine.remove("equip_strengthen_refine_strorage_to_update_draw_button")
	state_machine.remove("equip_strengthen_refine_strorage_to_close_all")
end

function EquipStrengthenRefineStrorage:init(equipmentInstance,types,_cell,_string_type)
	self.equipmentInstance = equipmentInstance
	self.types = types
	self._cell = _cell
	self._string_type = _string_type
end
